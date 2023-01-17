<cfif not isdefined("new_dsn2")><cfset new_dsn2 = dsn2></cfif>
<cfif not isdefined("new_dsn3_group_alias")><cfset new_dsn3_group_alias = dsn3_alias></cfif>
<cfquery name="GET_UNIT" datasource="#new_dsn2#">
	SELECT 
		ADD_UNIT,
		MULTIPLIER,
		MAIN_UNIT,
		PRODUCT_UNIT_ID
	FROM
		#new_dsn3_group_alias#.PRODUCT_UNIT 
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.product_id#i#")#"> AND
		ADD_UNIT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.unit#i#")#"> AND
        PRODUCT_UNIT_STATUS=1
</cfquery>

