/*
* generated by Xtext
*/
package co.edu.unal.modev.dtoFromDocument;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class DtoFromDocumentDslStandaloneSetup extends DtoFromDocumentDslStandaloneSetupGenerated{

	public static void doSetup() {
		new DtoFromDocumentDslStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}
