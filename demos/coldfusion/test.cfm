<cfscript>
writedump(application);
/*
ds = createObject("java", "com.vladsch.flexmark.util.data.MutableDataSet");
ps = createObject("java", "com.vladsch.flexmark.parser.Parser").builder(ds).build();
hm = createObject("java", "com.vladsch.flexmark.html.HtmlRenderer").builder(ds).build();

doc = ps.parse("This is *sparta*");
writedump(doc);
result = hm.render(doc);
//writeoutput(result);
*/
function toMarkdown(str) {

	var ds = createObject("java", "com.vladsch.flexmark.util.data.MutableDataSet");
	var ps = createObject("java", "com.vladsch.flexmark.parser.Parser").builder(ds).build();
	var hm = createObject("java", "com.vladsch.flexmark.html.HtmlRenderer").builder(ds).build();
	var doc = ps.parse(str);
	return hm.render(doc);

}
</cfscript>

<cfsavecontent variable="test">
# Hello World

Tell me why you love my [blog](https://www.raymondcamden.com).

This is another paragraph. 

## Stuff I like:

* Books
* Video Games
* Music 
* Beer 


</cfsavecontent>

<cfoutput>#toMarkdown(test)#</cfoutput>
