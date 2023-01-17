<cfquery name="GET_SETUP_PRODUCT_CONFIGURATOR_COMPONENTS" datasource="#DSN3#">
	SELECT 
		SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.*,
		PRODUCT_CAT.PRODUCT_CAT,
		PRODUCT_CAT.HIERARCHY
	FROM 
		SETUP_PRODUCT_CONFIGURATOR_COMPONENTS,
		PRODUCT_CAT
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID  = SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.SUB_PRODUCT_CAT_ID AND
		PRODUCT_CONFIGURATOR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prod_conf_id#">
	ORDER BY
		SETUP_PRODUCT_CONFIGURATOR_COMPONENTS.ORDER_NO
</cfquery>
<cfif listlen(get_setup_product_configurator_components.sub_product_cat_id)>
	<cfquery name="GET_SETUP_PRODUCT_CONFIGURATOR_COMPONENTS_KEY" dbtype="query">
		SELECT 
			SUB_PRODUCT_CAT_ID,
			HIERARCHY,
			PROPERTY_ID
		FROM 
			GET_SETUP_PRODUCT_CONFIGURATOR_COMPONENTS
		WHERE
			IS_KEY_COMPONENT = 1
	</cfquery>
	<cfquery name="GET_STDMONEY" datasource="#DSN#">
		SELECT MONEY FROM SETUP_MONEY WHERE RATE2 = RATE1 AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
	</cfquery>
</cfif>
