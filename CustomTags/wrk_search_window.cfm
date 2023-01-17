<!--- 
Description : ozel popup arama sayfalarini acar.

Parameters :
	window_page = required;
	window_width = not required;
	window_height = not required;
	scrolling = not required; //popupda cok fazla deger oldugunda scroll gosterimi icin yes degeri gonderilmeli.
	form_name = not required; //baska bir forma deger gönderileceginde form adini dinamik olarak kullanmak icin kullanilir.
Syntax :
	<cf_wrk_search_window>
	<cf_wrk_search_window scrolling="auto" window_page="report.popup_search_product_property" form_name="list_product">
created :
	YO20060907
--->
<cfparam name="attributes.window_width" default="850">
<cfparam name="attributes.window_height" default="200">
<cfparam name="attributes.scrolling" default="no">
<cfparam name="attributes.form_name" default="">

<cfset a=StructKeyArray(caller.attributes)>

<cfset url_link=attributes.window_page>
<cfloop from="1" to="#StructCount(caller.attributes)#" index="im">
	<cfif a[im] neq "FUSEACTION">
		<cfset url_link = url_link & "&" & #a[im]# & "=" & #evaluate('caller.attributes.#a[im]#')#>
	</cfif>
</cfloop>

<cfoutput>
	<div id="search_window" align="center" style="position:absolute;z-index: font:Verdana, Arial, Helvetica, sans-serif;font-size:18px; display:none; left:1; top:1;width:#attributes.window_width#px; height:#attributes.window_height#px; z-index:1;">
		<iframe src="#request.self#?fuseaction=#url_link#&ajax=1<cfif len(attributes.form_name)>&form_name=#attributes.form_name#</cfif>" scrolling="#attributes.scrolling#" frameborder="0" width="#attributes.window_width#" height="#attributes.window_height#" name="cont_" id="cont_"></iframe>
	</div>
	<script>
	function get_search()
	{
		search_window.style.left=(screen.width-#attributes.window_width#)/2;
		search_window.style.top=200+"px";
		gizle_goster(search_window);
	}
	</script>
	<a href="javascript://" onClick="get_search();"><img src="/images/find.gif" border="0" align="absmiddle"></a>
</cfoutput>
