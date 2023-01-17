<cf_get_lang_set module_name="process">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cffile action="read" variable="xmldosyam" file="#index_folder#process#dir_seperator#files#dir_seperator#process_template.xml" charset = "UTF-8">
    <cfscript>
        dosyam = XmlParse(xmldosyam);
        xml_dizi = dosyam.process_stage_file.XmlChildren;
        d_boyut = ArrayLen(xml_dizi);
    </cfscript>
</cfif>

</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'process.list_template';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'process/display/list_template.cfm';

</cfscript>
