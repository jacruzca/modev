package co.edu.unal.modev.layeredApp.generator;

import java.util.Map;

import org.eclipse.xtext.generator.IGenerator;

import co.edu.unal.modev.generator.nodejs.layeredApp.NodejsGenerator;
import co.edu.unal.modev.layeredApp.layeredAppDsl.TECHNOLOGY;

import com.google.inject.Inject;
import com.google.inject.Provider;

/**
 * Factory class for {@link IGenerator} implementations
 * @author jacruzca
 *
 */
public class GeneratorFactory {
	
	@Inject
	Map<TECHNOLOGY, Provider<IGenerator>> generatorMap;
	@Inject
	Provider<NodejsGenerator> defaultGenerator;
	
	/**
	 * Returns an implementation of {@link IGenerator} according to the passed parameter
	 * @param val
	 * @return
	 */
	public IGenerator getGenerator(TECHNOLOGY val){
		return generatorMap.containsKey(val) ? generatorMap.get(val).get(): defaultGenerator.get();
	}
}