component {

	this.name = "gemini_demos_2";
	this.javaSettings = {
		loadPaths = ["./flexmark-all-0.64.8-lib.jar"]
	};

	public function onApplicationStart() {
		// credit: https://www.bennadel.com/blog/2838-reading-environment-variables-in-coldfusion.htm
		var system = createObject( "java", "java.lang.System" );
		application.GEMINI_API_KEY = system.getenv(javaCast("string", "GEMINI_API_KEY"));
		return true;
	}
}