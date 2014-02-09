package co.edu.unal.modev.generator;

import java.util.List;

import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.xtext.generator.IGenerator;
import org.eclipse.xtext.generator.JavaIoFileSystemAccess;


public interface IGeneratorLayeredApp extends IGenerator 
{

	public void doBeginGeneration(Resource resource, JavaIoFileSystemAccess fsa, IProgressMonitor monitor, int i);
	
	public List<String> doGenerateDifferentiation(Resource newResource, Resource oldResource);
}

