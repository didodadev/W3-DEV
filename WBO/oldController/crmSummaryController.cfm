<cfif not isdefined("attributes.startdate")><cfset attributes.startdate = ''></cfif>
<cfif not isdefined("attributes.finishdate")><cfset attributes.finishdate = ''></cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'report.crm_summary';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'report/standart/crm_summary.cfm';

</cfscript>
