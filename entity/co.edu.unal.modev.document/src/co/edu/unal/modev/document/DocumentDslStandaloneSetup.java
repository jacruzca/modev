/*
* generated by Xtext
*/
package co.edu.unal.modev.document;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class DocumentDslStandaloneSetup extends DocumentDslStandaloneSetupGenerated{

	public static void doSetup() {
		new DocumentDslStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

