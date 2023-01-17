<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
	SELECT 
		PC.PRODUCT_CATID, 
		PC.HIERARCHY, 
		PC.PRODUCT_CAT 
	FROM 
		PRODUCT_CAT PC,
		#dsn1#.PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND 
		PC.PRODUCT_CATID = PCO.PRODUCT_CATID
		<cfif isDefined("attributes.id")>
			AND PC.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
		<cfelseif isDefined("attributes.hier")>
			AND PC.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hier#">
		</cfif>
	ORDER BY 
		PC.HIERARCHY
</cfquery>


