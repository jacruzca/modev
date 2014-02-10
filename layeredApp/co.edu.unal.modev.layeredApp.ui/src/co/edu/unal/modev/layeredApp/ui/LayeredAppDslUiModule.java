/*
 * generated by Xtext
 */
package co.edu.unal.modev.layeredApp.ui;

import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.xtext.generator.IGenerator;

import co.edu.unal.modev.generator.jee.layeredapp.JeeGenerator;
import co.edu.unal.modev.generator.nodejs.layeredApp.NodejsGenerator;
import co.edu.unal.modev.layeredApp.layeredAppDsl.TECHNOLOGY;

import com.google.inject.Binder;
import com.google.inject.multibindings.MapBinder;

/**
 * Use this class to register components to be used within the IDE.
 */
public class LayeredAppDslUiModule extends co.edu.unal.modev.layeredApp.ui.AbstractLayeredAppDslUiModule {
	public LayeredAppDslUiModule(AbstractUIPlugin plugin) {
		super(plugin);
	}
	
	@Override
	public void configure(Binder binder) {
		super.configure(binder);
		MapBinder<TECHNOLOGY, IGenerator> myBinder = MapBinder.newMapBinder(binder, TECHNOLOGY.class, IGenerator.class);
		myBinder.addBinding(TECHNOLOGY.NODEJS).to(NodejsGenerator.class);
		myBinder.addBinding(TECHNOLOGY.JEE).to(JeeGenerator.class);
	}
}
