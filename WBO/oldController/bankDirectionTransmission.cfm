<cf_get_lang_set module_name="bank">
<cfquery name="get_periods" datasource="#dsn#">
	SELECT 
		SP.*,
		OC.COMPANY_NAME 
	FROM 
		SETUP_PERIOD SP,
		OUR_COMPANY OC
	WHERE
		SP.OUR_COMPANY_ID = OC.COMP_ID
</cfquery>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'bank.popup_form_bank_order_copy';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'bank/form/bank_order_copy.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'bank/query/bank_order_copy.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'bank.popup_form_bank_order_copy&event=add';

</cfscript>

