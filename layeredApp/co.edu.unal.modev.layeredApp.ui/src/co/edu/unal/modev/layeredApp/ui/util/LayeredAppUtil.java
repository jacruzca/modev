package co.edu.unal.modev.layeredApp.ui.util;

import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.Status;
import org.eclipse.jface.dialogs.MessageDialog;

public class LayeredAppUtil {
	
	/**
	 * Escribe en el log de eclipse el error lanzado junto con la excepcion. Igualmente muestra una ventana emergente informando el error. 
	 * @param titleMessage titulo de la ventana
	 * @param errorMessage mensaje de error
	 * @param e excepcion lanzada
	 */
	public static void manageException(String titleMessage, String errorMessage, Exception e){
		LayeredAppUtil.logErrorMessage(errorMessage+e.getMessage(), e);
		MessageDialog.openError(null, titleMessage, errorMessage);
	}
	

	/**
	 * Escribe en el log de eclipse el error lanzado junto con la excepcion. Igualmente muestra una ventana emergente informando el error. 
	 * @param titleMessage titulo de la ventana
	 * @param errorMessage mensaje de error
	 * @param e excepcion lanzada
	 */
	public static void manageException(String titleMessage, String errorMessage){
		LayeredAppUtil.logErrorMessage(errorMessage);
		MessageDialog.openError(null, titleMessage, errorMessage);
	}
	
	/**
	 * Escribe en el log de eclipse el log de la generación lanzado junto con la excepción. Igualmente muestra una ventana emergente informando el mensaje. 
	 * @param titleMessage titulo de la ventana
	 * @param errorMessage mensaje de información
	 * @param e excepción lanzada
	 */
	public static void showInfoMessage(String titleMessage, String infoMessage){
		LayeredAppUtil.logInfoMessage(infoMessage);
		MessageDialog.openInformation(null, titleMessage, infoMessage);
	}
	
	
	
	/**
	 * Realiza el log de un mensaje de error en la consola de eclipse
	 * 
	 * @param message
	 *            Mensaje a realizar log
	 */
	public static void logErrorMessage(String message) {
		System.err.println("ERROR - "+message);
		ResourcesPlugin.getPlugin().getLog().log(new Status(Status.ERROR, LayeredAppConstants.CONFIG_PLUGIN_ID, message));
	}
	
	/**
	 * Realiza el log de un mensaje de error en la consola de eclipse
	 * 
	 * @param message
	 *            Mensaje a realizar log
	 */
	public static void logErrorMessage(String message, Throwable e) {
		System.out.println("ERROR - "+message);
		ResourcesPlugin.getPlugin().getLog().log(new Status(Status.ERROR, LayeredAppConstants.CONFIG_PLUGIN_ID, message, e));
	}
	
	/**
	 * Realiza el log de un mensaje de informacion en la consola de eclipse
	 * 
	 * @param message
	 *            Mensaje a realizar log
	 */
	public static void logInfoMessage(String message) {
		System.out.println("INFO - "+message);
		ResourcesPlugin.getPlugin().getLog().log(new Status(Status.INFO, LayeredAppConstants.CONFIG_PLUGIN_ID, message));
	}
	
}
