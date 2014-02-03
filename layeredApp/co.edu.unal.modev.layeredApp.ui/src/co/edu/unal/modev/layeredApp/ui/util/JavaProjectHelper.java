package co.edu.unal.modev.layeredApp.ui.util;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IProjectDescription;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.IncrementalProjectBuilder;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.Path;


/**
 * 
 * Metodos Helper para configuracion de IProject
 */
public class JavaProjectHelper {
	
	private static final JavaProjectHelper INSTANCE = new JavaProjectHelper();
	
	private String projectName;
	
	private JavaProjectHelper(){
		
	}
	
	public static JavaProjectHelper getInstance( ){
		return INSTANCE;
	}
	
	public String getProjectName() {
		return projectName;
	}
	
	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}
	
	
	public static void refreshWorkspaceProject(String projectName) throws CoreException{		
		IWorkspaceRoot root = ResourcesPlugin.getWorkspace().getRoot();
		IProject project = root.getProject(projectName);
		if(project.exists())
		{
			project.refreshLocal(IResource.DEPTH_INFINITE, null);
		}
		else{
			project.create(null);
			if (!project.isOpen()) {
				project.open(null);
			}
		}
	}
	
	public static void importExistingProject(String location) throws CoreException{
		IProjectDescription description = ResourcesPlugin
				   .getWorkspace().loadProjectDescription(
				        new Path(location+"/.project"));
				IProject project = ResourcesPlugin.getWorkspace()
				   .getRoot().getProject(description.getName());
				if(!project.exists()){
					project.create(description, null);
				}
				project.open(null);
				project.refreshLocal(IResource.DEPTH_INFINITE, null);
				project.build(IncrementalProjectBuilder.FULL_BUILD, null);
	}
	
	public static String getCurrentWorkspaceRootPath() {
		
		IWorkspaceRoot root = ResourcesPlugin.getWorkspace().getRoot();
		return root.getLocation().toOSString();
	}
	
	public static String getCurrentProjectPath(){
		String ws = JavaProjectHelper.getCurrentWorkspaceRootPath();
		String projectName2 = JavaProjectHelper.getInstance().getProjectName();
		
		return ws + "/" + projectName2;
	}
}