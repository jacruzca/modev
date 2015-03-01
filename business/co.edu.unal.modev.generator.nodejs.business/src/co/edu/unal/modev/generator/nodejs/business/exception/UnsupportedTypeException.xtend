package co.edu.unal.modev.generator.nodejs.business.exception

class UnsupportedTypeException extends RuntimeException {

	new() {
	}

	new(String message) {
		super(message)
	}

	new(String message, Throwable cause) {
		super(message, cause)
	}

	new(Throwable cause) {
		super(cause)
	}

}
