<cfset attributes.upload_folder = '#server.coldfusion.rootdir##dir_seperator#CustomTags#dir_seperator#'>
<cffile action="read" file="#attributes.upload_folder#language.xml" variable="xmldosyam" charset = "UTF-8">
<cfquery   name="get_lang" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_LANGUAGE
</cfquery>
<cfset my_arr_q=ValueList(get_lang.LANGUAGE_SHORT,",")>
<cfset my_arr_lang=ListToArray(my_arr_q,",")>

<cfscript>
	dosyam = XmlParse(xmldosyam);
	xml_dizi = dosyam.LANG.XmlChildren;
	d_boyut = ArrayLen(xml_dizi);
</cfscript>
<!--- dillerin oldugu loop veritabanindan gelicek gelicek--->
<cfloop from="1" to="#ArrayLen(my_arr_lang)#" index="i" >
	<cfscript>
		search_text="LANG/#my_arr_lang[i]#/#attributes.strmodule#/";
		selectedElements = XmlSearch(dosyam,search_text);
	</cfscript>
	<cfif ArrayLen(selectedElements) gte attributes.item_id>
		<cfscript>
			StructDelete(selectedElements[attributes.item_id], "XmlChildren");
			ArrayClear(selectedElements[attributes.item_id].XmlChildren);
			ArrayDeleteAt(selectedElements[attributes.item_id],1);
		</cfscript>

	</cfif>
</cfloop>

<cfset XMLText=ToString(dosyam)>
<cffile action="write" file="#attributes.upload_folder#language.xml" output="#XMLText##Chr(13)#" charset = "UTF-8"> 

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
