<cfif len(attributes.search_date)>
	<cf_date tarih="attributes.search_date">
</cfif>
<cfquery name="get_catalog_names" datasource="#DSN3#">
	SELECT 
		CATALOG_PROMOTION.*,
		EMP.EMPLOYEE_NAME,
		EMP.EMPLOYEE_SURNAME
	FROM
		CATALOG_PROMOTION,
		#dsn_alias#.EMPLOYEES AS EMP
	WHERE
		CATALOG_PROMOTION.RECORD_EMP = EMP.EMPLOYEE_ID AND
		<cfif not isdefined("attributes.is_applied_info")>
			CATALOG_PROMOTION.IS_APPLIED = 1 AND
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		(
				CATALOG_PROMOTION.CATALOG_HEAD LIKE '%#attributes.keyword#%'
			OR 
				CATALOG_PROMOTION.CATALOG_DETAIL LIKE '%#attributes.keyword#%'
			OR
				EMP.EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
			OR
				EMP.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		)		
		<cfelse>
			CATALOG_PROMOTION.CATALOG_ID IS NOT NULL
		</cfif>
		<cfif len(attributes.search_date)>
			AND #attributes.search_date# BETWEEN CATALOG_PROMOTION.STARTDATE AND CATALOG_PROMOTION.FINISHDATE
		</cfif>
	ORDER BY 
		CATALOG_PROMOTION.CATALOG_ID DESC
</cfquery>
