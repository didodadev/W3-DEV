<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.date1" default="01/01/#year(now())#">
	<cfparam name="attributes.date2" default="31/12/#year(now())#">
</cfif>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.personel_extre';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/personel_extre.cfm';
</cfscript>
