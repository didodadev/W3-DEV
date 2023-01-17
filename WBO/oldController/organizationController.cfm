<cf_basket>
    <iframe src="<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_disp_organization_schema&iframe=1" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe> 
</cf_basket>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'rule.organization';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'rules/display/organization.cfm';
		
</cfscript>
