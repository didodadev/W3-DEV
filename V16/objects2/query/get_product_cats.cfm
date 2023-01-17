<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PC.PRODUCT_CAT,
		PC.PRODUCT_CATID,
		PC.HIERARCHY
	FROM 
		PRODUCT_CAT PC,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		<cfif isdefined('attributes.is_main_cats') and attributes.is_main_cats eq 1>
			PC.HIERARCHY NOT LIKE '%.%' AND
		</cfif>
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		PC.IS_PUBLIC = 1	
	ORDER BY
		PC.HIERARCHY 
</cfquery>
