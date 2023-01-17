<cfif isDefined("attributes.cat") and attributes.cat neq "0">
	<cfif listgetat(attributes.cat,1,"-") is "comp">
		<cfset cat_comp = listgetat(attributes.cat,2,"-")>
	<cfelseif listgetat(attributes.cat,1,"-") is "cons">
		<cfset cat_cons = listgetat(attributes.cat,2,"-")>
	</cfif>	
</cfif>
<cfif isdate(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif isdate(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>
<cfquery name="GET_CATALOG" datasource="#DSN3#">
	SELECT 
		CATALOG_PROMOTION.CATALOG_HEAD, 
		CATALOG_PROMOTION.CATALOG_ID, 
		CATALOG_PROMOTION.STARTDATE, 
		CATALOG_PROMOTION.FINISHDATE, 
		CATALOG_PROMOTION.RECORD_EMP,
		CATALOG_PROMOTION.RECORD_DATE,
		CATALOG_PROMOTION.VALID,
		CATALOG_PROMOTION.VALID_EMP,
		CATALOG_PROMOTION.VALIDATE_DATE,
		CATALOG_PROMOTION.CAMP_ID,
		CATALOG_PROMOTION.IS_APPLIED,
		CATALOG_PROMOTION.CAT_PROM_NO,
		CAMPAIGNS.CAMP_HEAD,
        EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME EMP_NAME,
        EMPLOYEES_2.EMPLOYEE_NAME +' '+ EMPLOYEES_2.EMPLOYEE_SURNAME VALID_EMP_NAME
	FROM
		CATALOG_PROMOTION
	        LEFT JOIN CAMPAIGNS ON CATALOG_PROMOTION.CAMP_ID = CAMPAIGNS.CAMP_ID
            LEFT JOIN #dsn_alias#.EMPLOYEES ON CATALOG_PROMOTION.RECORD_EMP = EMPLOYEES.EMPLOYEE_ID
            LEFT JOIN #dsn_alias#.EMPLOYEES EMPLOYEES_2 ON CATALOG_PROMOTION.VALID_EMP = EMPLOYEES_2.EMPLOYEE_ID
	WHERE
		CATALOG_ID IS NOT NULL
		<cfif isDefined("attributes.catalog_status")>
			<cfif (attributes.catalog_status eq 1) or (attributes.catalog_status eq 0)>
			AND CATALOG_STATUS = #attributes.catalog_status#
			</cfif>	 
		<cfelse>
			AND CATALOG_STATUS = 1
		</cfif>
		<cfif isDefined("attributes.price_catid") AND len(attributes.price_catid)>
		  	AND CATALOG_ID IN (SELECT 
									CATALOG_PROMOTION_ID
								FROM
									CATALOG_PRICE_LISTS
								WHERE
									PRICE_LIST_ID = #attributes.price_catid#)
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		  	AND (CATALOG_HEAD LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR CAT_PROM_NO LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
		</cfif>
		<cfif isDefined("attributes.position_code") and len(attributes.position_code) and isDefined("attributes.position_name") and len(attributes.position_name)>
	   		AND CATALOG_PROMOTION.RECORD_EMP = #attributes.position_code#
		</cfif>
		<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
			AND #attributes.start_date# BETWEEN STARTDATE AND FINISHDATE
		</cfif>
		<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
			AND CATALOG_PROMOTION.RECORD_DATE >= #attributes.finish_date#
			AND CATALOG_PROMOTION.RECORD_DATE < #DATEADD("d",1,attributes.finish_date)#
		</cfif>
		<cfif isDefined("attributes.is_applied") and len(attributes.is_applied)>
			<cfif attributes.is_applied eq 1>
				AND IS_APPLIED = 1
			</cfif>
			<cfif attributes.is_applied eq 0>
				AND IS_APPLIED IS NULL
			</cfif>
		</cfif>
	ORDER BY
		IS_APPLIED,
		CATALOG_ID DESC		
</cfquery>
