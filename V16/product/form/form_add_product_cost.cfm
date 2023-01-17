<cf_xml_page_edit fuseact="product.form_add_product_cost">
<cf_get_lang_set module_name="product">
<cfquery name="get_periods" datasource="#dsn#">
	SELECT 
        INVENTORY_CALC_TYPE	 
    FROM 
    	SETUP_PERIOD
	WHERE
		PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfif get_periods.inventory_calc_type eq 3>
	<cfinclude template="form_add_product_cost_gpa.cfm">
<cfelseif get_periods.inventory_calc_type eq 1>
	<cfinclude template="form_add_product_cost_fifo.cfm">
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">	
