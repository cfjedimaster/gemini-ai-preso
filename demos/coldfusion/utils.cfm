<cfscript>
function md2HTML(str) {

	var ds = createObject("java", "com.vladsch.flexmark.util.data.MutableDataSet");
	var ps = createObject("java", "com.vladsch.flexmark.parser.Parser").builder(ds).build();
	var hm = createObject("java", "com.vladsch.flexmark.html.HtmlRenderer").builder(ds).build();
	var doc = ps.parse(str);
	return hm.render(doc);

}
</cfscript>