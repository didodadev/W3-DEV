<cfif not isdefined("attributes.period_id")>
	<cfset attributes.period_id = session.ep.period_id>
</cfif>
<cfquery name="GET_OTHER_PERIOD" datasource="#DSN#">
	SELECT	
		* 
	FROM 
		SETUP_PERIOD 
	WHERE 
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
</cfquery>
<cfquery name="GET_COMP_ID" datasource="#DSN#">
	SELECT	
		OUR_COMPANY_ID
	FROM 
		SETUP_PERIOD 
	WHERE 
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
</cfquery>
<cfset attributes.company_id = get_comp_id.our_company_id>
<cfquery name="get_product_tax" datasource="#dsn3#">
	SELECT * FROM PRODUCT_TAX WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> 
</cfquery>
<cfquery name="GET_PRODUCT_PERIODS" datasource="#DSN3#">
	SELECT
		CP.*
	FROM
		PRODUCT_PERIOD CP,
        PRODUCT P
	WHERE
		CP.PRODUCT_ID = P.PRODUCT_ID AND
        P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">  AND
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
</cfquery>
