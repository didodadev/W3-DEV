<cfset attributes.upload_folder = '#server.coldfusion.rootdir##dir_seperator#CustomTags#dir_seperator#'>
<cffile action="read" file="#attributes.upload_folder#language.xml" variable="xmldosyam" charset="UTF-8">
<cfset my_lang_arr=ListToArray("tr,eng",",")>
<cfscript> dosyam = XmlParse(xmldosyam);</cfscript>

<cfloop from="1" to="2" index="i">	
	<cfscript>
		xml_dizi = dosyam.LANG.XmlChildren;
		d_boyut = ArrayLen(xml_dizi);
		search_text="LANG/#my_lang_arr[i]#";
		search_text="#search_text#/#attributes.module_name#/";
		selectedElements = XmlSearch(dosyam,search_text);
		int_dz=arraylen(selectedElements[1].XmlChildren);
	</cfscript>
	<cfset selectedElements[attributes.id].ITEM.XmlText=evaluate("attributes.sub_modulename_#i#")>
</cfloop>

<input name="str_link" id="str_link"  type="hidden" value="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_lang_settings&keyword=<cfoutput>#attributes.sub_modulename_1#</cfoutput>">
<cfset XMLText=ToString(dosyam)>

<cffile action="write" file="#attributes.upload_folder#language.xml" output="#XMLText##Chr(13)#" charset="UTF-8"> 

<script type="text/javascript">
	opener.location.href=document.getelementById('str_link').value;
	window.close();
</script>
