<cfscript>
function md2HTML(str) {

	var ds = createObject("java", "com.vladsch.flexmark.util.data.MutableDataSet");
	var ps = createObject("java", "com.vladsch.flexmark.parser.Parser").builder(ds).build();
	var hm = createObject("java", "com.vladsch.flexmark.html.HtmlRenderer").builder(ds).build();
	var doc = ps.parse(str);
	return hm.render(doc);

}

function slugify(s, sep="-") {
	// replace any non a-z number with sep
	s = s.reReplaceNoCase('[^a-z\d]', '#arguments.sep#','all');

	// remove training sep
	while(right(s,1) === arguments.sep) {
		s = s.mid(1, len(s) - 1);
	}
	// remove initial sep
	while(left(s,1) === arguments.sep) {
		s = s.mid(2, len(s));
	}
	
	// lowercase
	s = s.lcase();
	return s;
}

</cfscript>