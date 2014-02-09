package co.edu.unal.modev.layeredApp.ui.util;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import org.eclipse.core.resources.IContainer;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IPath;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl;
import org.eclipse.emf.ecore.util.EcoreUtil;

public class WorkspaceUtils {

	/**
	 * Returns the set of all TxtureFiles contained within the given workspace folder that have the given file
	 * extension.
	 * 
	 * @param folder
	 *            The folder to search in
	 * @param fileExtension
	 *            The file extension of the DSL files to look for
	 * @return The set of TxtureFiles generated from the encountered DSL files
	 */
	public static Set<IFile> getAllDSLFilesInFolder(final IPath folder, final String fileExtension) {
		Set<IFile> resultSet = new HashSet<IFile>();
		IWorkspaceRoot workspaceRoot = ResourcesPlugin.getWorkspace().getRoot();
		Set<IResource> resources = new HashSet<IResource>();
		getAllTxtureFilesInFolderRec(resources, folder, workspaceRoot, fileExtension);
		for (IResource resource : resources) {
			IFile file = (IFile) resource;
			System.out.println(file);
			resultSet.add(file);
		}
		return resultSet;
	}

	private static void getAllTxtureFilesInFolderRec(final Set<IResource> resources, final IPath path,
			final IWorkspaceRoot root, final String fileExtension) {
		IContainer container = root.getContainerForLocation(path);
		try {
			IResource[] containedResources = container.members();
			for (IResource member : containedResources) {
				if (member.getName().endsWith(fileExtension)) {
					// we've found a file resource that ends with ".move",
					// so we add it to our list
					resources.add(member);
				} else if (member.getType() == IResource.FOLDER) {
					// we've found a folder. We need to check its contents for
					// ".move" files.
					IPath folderPath = member.getLocation();
					getAllTxtureFilesInFolderRec(resources, folderPath, root, fileExtension);
				}
			}
		} catch (CoreException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Returns all model elements in the project.<br>
	 * This method will also resolve cross-references between Xtext DSL files.
	 * 
	 * @return The set of all model elements in the project.
	 */
	public static Set<EObject> getModelElements(final Set<IFile> sourceFiles, ResourceSet projectResourceSet) {
		for (IFile dslFile : sourceFiles) {
			try {
				Resource resource = projectResourceSet.getResource(URI.createPlatformResourceURI(dslFile.getFullPath().toString(), true), true);
				resource.load(null);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		// resolve all cross-references in the resource set
		EcoreUtil.resolveAll(projectResourceSet);
		Set<EObject> modelElements = new HashSet<EObject>();
		System.out
				.println("Gathering model elements from " + projectResourceSet.getResources().size() + " resource(s)");
		for (Resource resource : projectResourceSet.getResources()) {
			System.out.println("Found " + resource.getContents().size() + " root element(s) in resource "
					+ resource.getURI().toString());
			modelElements.addAll(resource.getContents());
		}
		return modelElements;
	}
}