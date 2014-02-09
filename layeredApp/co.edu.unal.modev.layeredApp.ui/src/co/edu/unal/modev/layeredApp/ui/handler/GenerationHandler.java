package co.edu.unal.modev.layeredApp.ui.handler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.commands.IHandler;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.jobs.Job;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.handlers.HandlerUtil;
import org.eclipse.xtext.generator.JavaIoFileSystemAccess;
import org.eclipse.xtext.resource.IResourceDescriptions;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.ui.resource.IResourceSetProvider;
import org.eclipse.xtext.util.concurrent.IUnitOfWork;

import co.edu.unal.modev.generator.IGeneratorLayeredApp;
import co.edu.unal.modev.layeredApp.generator.GeneratorFactory;
import co.edu.unal.modev.layeredApp.layeredAppDsl.App;
import co.edu.unal.modev.layeredApp.layeredAppDsl.TECHNOLOGY;
import co.edu.unal.modev.layeredApp.ui.exception.ModelLoaderException;
import co.edu.unal.modev.layeredApp.ui.util.JavaProjectHelper;
import co.edu.unal.modev.layeredApp.ui.util.LayeredAppUtil;
import co.edu.unal.modev.layeredApp.ui.util.WorkspaceUtils;

import com.google.inject.Inject;

public class GenerationHandler extends AbstractHandler implements IHandler{
	
	@Inject
	IResourceDescriptions resourceDescriptions;

	@Inject
	IResourceSetProvider resourceSetProvider;
	
	@Inject
	GeneratorFactory generatorFactory;

	@Inject
	private JavaIoFileSystemAccess fsa;
	
	/**
	 * Creates the eclipse resource object
	 * @param project
	 * @param filePath
	 * @return
	 */
	private Resource getResource(IProject project, String filePath) {
		URI uri = URI.createPlatformResourceURI(filePath, true);
		ResourceSet rs = resourceSetProvider.get(project);
		
		System.out.println(project.getLocation());
		
		loadAllReferences(rs, project.getLocation());
		
		Resource r = rs.getResource(uri, true);
		return r;
	}
	
	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		ISelection selection = HandlerUtil.getCurrentSelection(event);
		if (selection instanceof IStructuredSelection) {
			IStructuredSelection structuredSelection = (IStructuredSelection) selection;
			Object firstElement = structuredSelection.getFirstElement();
			if (firstElement instanceof IFile) {
				IFile file = (IFile) firstElement;
				IProject project = file.getProject();
				String filePath = file.getFullPath().toString();

				// gets the resource
				Resource r = getResource(project, filePath);

				initGeneration(r);
			}
		} else {
			IEditorPart activeEditor = HandlerUtil.getActiveEditor(event);
			if (activeEditor instanceof XtextEditor) {
				((XtextEditor) activeEditor).getDocument().readOnly(
						new IUnitOfWork<Boolean, XtextResource>() {

							@Override
							public Boolean exec(XtextResource resource)
									throws Exception {
								
								initGeneration(resource);
								return Boolean.TRUE;
							}
						});

			}
		}
		return null;
	}
	
	/**
	 * Starts the generation of the project
	 * @param resource
	 */
	private void initGeneration(Resource resource) {
		try {
			for (int i = 0; i < resource.getContents().size(); i++) {
				
				EObject contents = resource.getContents().get(i);
				if (contents instanceof App) {

					generateProject((App) contents, resource);
				}
			}
		} catch (CoreException e) {
			e.printStackTrace();
			LayeredAppUtil.manageException(e.getMessage(), e.getMessage(), e);
		} catch (ModelLoaderException e) {
			e.printStackTrace();
			LayeredAppUtil.manageException(e.getMessage(), e.getMessage(), e);
		} catch (Exception e) {
			e.printStackTrace();
			LayeredAppUtil.manageException(e.getMessage(), e.getMessage(), e);
		}
	}
	
	private List<String> getAllModelExtensions(){
		List<String> extensions = new ArrayList<String>();
			
		extensions.add(".entity");
		extensions.add(".layeredApp");
		extensions.add(".dbConfig");
		
		
		return extensions;
	}
	
	private void loadAllReferences(ResourceSet resourceSet, IPath folder){
		List<String> allModelExtensions = getAllModelExtensions();
		Set<IFile> resultSet = new HashSet<IFile>();
		for (String fileExtension : allModelExtensions) {
			Set<IFile> allDSLFilesInFolder = WorkspaceUtils.getAllDSLFilesInFolder(folder, fileExtension);
			resultSet.addAll(allDSLFilesInFolder);
		}
		
		WorkspaceUtils.getModelElements(resultSet, resourceSet);
	}
	
	/**
	 * Dispatches the generation
	 * 
	 * @param app
	 * @param resource
	 * @throws CoreException
	 * @throws ModelLoaderException
	 * @throws IOException
	 */
	private void generateProject(App app, final Resource resource)
			throws CoreException, ModelLoaderException, IOException {

		boolean mainFileValid = validateMainFile(app);
		
		final String projectName = app.getConfig().getProjectConfig().getProjectName();
		final TECHNOLOGY technology = app.getConfig().getProjectConfig().getTechnology();
		final String projectLocation = app.getConfig().getProjectConfig().getProjectLocation();
		
		if (mainFileValid) {

			String rootPath = JavaProjectHelper.getCurrentWorkspaceRootPath();

			final String parentLocation = rootPath + "/"
					+ projectLocation + "/"
					+ projectName;
			
			
			Job job = new Job("Generando aplicación "+projectName) {
				
				@Override
				protected IStatus run(IProgressMonitor monitor) {
					
					try {
						monitor.beginTask("Generating application "+projectName, 100);						
						monitor.worked(10);
						
						monitor.subTask("Verifying protected regions ...");
						
						fsa.setOutputPath(parentLocation);
						
						//request specific generator based on technology
						IGeneratorLayeredApp generator = (IGeneratorLayeredApp) generatorFactory.getGenerator(technology);	
						generator.doBeginGeneration(resource, fsa, monitor, 80);
						
						monitor.subTask("Reloading workspace ...");
						monitor.worked(10);
						monitor.subTask("Finishing");
						monitor.done();
						return Status.OK_STATUS;
						
					/*} catch (CoreException e) {
						LayeredAppUtil.logErrorMessage(e.getMessage(), e);
						return Status.CANCEL_STATUS;
					} catch (IOException e) {
						LayeredAppUtil.logErrorMessage(e.getMessage(), e);
						return Status.CANCEL_STATUS;*/
					} catch (Exception e) {
						LayeredAppUtil.logErrorMessage(e.getMessage(), e);
						return Status.CANCEL_STATUS;
					}
				}
			};
			job.setUser(true);
			job.schedule(0);
		}
	}
	
	
	/**
	 * Validates the main file
	 * 
	 * @param app
	 * @throws ModelLoaderException
	 */
	private boolean validateMainFile(App app) throws ModelLoaderException {
		if (app.getConfig() == null) {
			throw new ModelLoaderException(
					"A .layeredApp file must be selected to start the generation of the project");
		}

		return true;
	}
}
