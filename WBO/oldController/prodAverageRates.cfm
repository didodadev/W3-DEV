<cfquery name="GET_RATES" datasource="#DSN3#">
    SELECT * FROM ASSEMPTION_AVERAGE_RATES
</cfquery>
<cfoutput query="get_rates">
    <cfset "rate_#method_id#_#month_value#" = average_rate>
</cfoutput>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'prod.form_add_average_rates';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/form/add_average_rates.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'production_plan/query/add_average_rates.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'prod.form_add_average_rates&event=add';
</cfscript>
