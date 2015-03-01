package co.edu.unal.modev.generator.nodejs.doc.exceptions

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
