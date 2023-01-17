<cfset attributes.upload_folder = '#server.coldfusion.rootdir##dir_seperator#CustomTags#dir_seperator#'>
<cffile action="read" file="#attributes.upload_folder#language.xml" variable="xmldosyam" charset = "UTF-8">

<!---
  <cfset ITEM_ID=attributes.max_item_id+1>
  <cfset max_element=	max_element_no+1>
  <input type="hidden" name="item_id" value="<cfoutput>#ITEM_ID#</cfoutput>">
  <input type="hidden" name="max_element" value="<cfoutput>#max_element#</cfoutput>">
  <input type="hidden" name="module_name" value="<cfoutput>#attributes.strmodule#</cfoutput>">	
 --->
<cfset my_lang_arr=ListToArray("tr,eng",",")>
<cfscript> dosyam = XmlParse(xmldosyam);</cfscript>
	<!--- max element no vs bulunancak. --->
	<cfscript>
		xml_dizi = dosyam.LANG.XmlChildren;
		d_boyut = ArrayLen(xml_dizi);
		search_text="LANG/tr/#attributes.module_name#/";
		selectedElements = XmlSearch(dosyam,search_text);
		int_dz=arraylen(selectedElements);
	</cfscript>

	<cfloop from="1" to="#int_dz#" index="i">
		<cfif i eq 1>
			<cfset MAX_ITEM_NO=selectedElements[i].ITEM_ID.XmlText>
		<cfelse>
			<cfif selectedElements[i].ITEM_ID.XmlText gt MAX_ITEM_NO >
				<cfset MAX_ITEM_NO=selectedElements[i].ITEM_ID.XmlText>
			</cfif>
		</cfif>
	    <cfset len_of_list=i>
	</cfloop>
	<cfif isdefined('MAX_ITEM_NO')>
		<cfset attributes.ITEM_ID=MAX_ITEM_NO + 1>		
	<cfelse>
		<cfset attributes.ITEM_ID= + 1>		
	</cfif>

<!--- 	<cfdump var="#dosyam#"> --->
<!--- <cfabort>	 --->
	<!--- max element no vs bulundu. --->
<cfloop from="1" to="#ArrayLen(my_lang_arr)#" index="i">	
	<cfscript>
		xml_dizi = dosyam.LANG.XmlChildren;
		d_boyut = ArrayLen(xml_dizi);
		search_text="LANG/#my_lang_arr[i]#/";
		search_text=search_text;
		selectedElements = XmlSearch(dosyam,search_text);
		int_dz=arraylen(selectedElements[1].XmlChildren);
	</cfscript>
	<cfscript>	
		selectedElements[1].XmlChildren[int_dz+1] = XmlElemNew(dosyam,"#attributes.module_name#");
		selectedElements[1].XmlChildren[int_dz+1].XmlChildren[1] = XmlElemNew(dosyam,"ITEM_ID");
		selectedElements[1].XmlChildren[int_dz+1].XmlChildren[2] = XmlElemNew(dosyam,"ITEM");	
		selectedElements[1].XmlChildren[int_dz+1].XmlChildren[1].XmlText = attributes.ITEM_ID;
		selectedElements[1].XmlChildren[int_dz+1].XmlChildren[2].XmlText =evaluate("attributes.sub_modulename_#i#");
	</cfscript>
</cfloop>

<input name="str_link" id="str_link"  type="hidden" value="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_lang_settings&keyword=<cfoutput>#attributes.sub_modulename_1#</cfoutput>">
<cfset XMLText=ToString(dosyam)>
<cffile action="write"file="#attributes.upload_folder#language.xml" output="#XMLText##Chr(13)#" charset = "UTF-8">

<script type="text/javascript">
	opener.location.href=document.getElementById('str_link').value;
	window.close();
</script>
