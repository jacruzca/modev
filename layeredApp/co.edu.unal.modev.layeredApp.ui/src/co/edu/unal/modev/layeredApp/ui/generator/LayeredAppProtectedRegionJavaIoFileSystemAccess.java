package co.edu.unal.modev.layeredApp.ui.generator;

import org.eclipse.emf.common.util.URI;
import org.eclipse.xtext.parser.IEncodingProvider;
import org.eclipse.xtext.resource.IResourceServiceProvider.Registry;

import com.google.inject.Inject;

import net.danieldietrich.protectedregions.xtext.ProtectedRegionJavaIoFileSystemAccess;

public class LayeredAppProtectedRegionJavaIoFileSystemAccess extends ProtectedRegionJavaIoFileSystemAccess {

	@Inject
	public LayeredAppProtectedRegionJavaIoFileSystemAccess(Registry registry,
			IEncodingProvider encodingProvider) {
		super(registry, new IEncodingProvider() {
			@Override
			public String getEncoding(URI uri) {
				return "UTF-8";
			}
		});
	}

	@Override
	public void setOutputPath(String path) {
		support().clearRegions();
		super.setOutputPath(path);
	}
	
	@Override
	protected String getEncoding(URI fileURI) {
		// TODO Auto-generated method stub
		return "UTF-8";
	}
}