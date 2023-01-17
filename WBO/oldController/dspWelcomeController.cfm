<cf_xml_page_edit fuseact='rule.welcome'>
<cfset attributes.is_home = 1>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'rule.welcome';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'rules/display/dsp_welcome.cfm';
	
	
</cfscript>
