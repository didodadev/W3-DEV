<!--- get_price_cat.cfm --->
<cfquery name="GET_PRICE_CAT" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		PRICE_CAT
	WHERE
		1 = 1
		<cfif isDefined("URL.PCAT_ID")>
			AND PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.PCAT_ID#">
		</cfif>
		<cfif isDefined("is_purchase")>
			AND IS_PURCHASE = 1
		</cfif>
</cfquery>
