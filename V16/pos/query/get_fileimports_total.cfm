<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfquery name="get_fileimports_total" datasource="#DSN2#">
	SELECT 
		FIT.FILE_IMPORTS_TOTAL_ID,
		FIT.PROCESS_DATE,
		FIT.STOCK_AMOUNT,
		FIT.FILE_AMOUNT,
		S.PRODUCT_NAME,
		S.PROPERTY
	FROM
		FILE_IMPORTS_TOTAL FIT,
		#dsn3_alias#.STOCKS S
	WHERE 
		FIT.FIS_ID IS NULL
		AND S.STOCK_ID = FIT.STOCK_ID  
	<cfif isdefined("attributes.department_id") and (attributes.department_id neq 0)>
		AND FIT.DEPARTMENT_ID = #attributes.department_id#
	</cfif>
	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
		AND FIT.PROCESS_DATE =  #attributes.start_date#
	</cfif>
	ORDER BY
		(FIT.FILE_AMOUNT-FIT.STOCK_AMOUNT)  DESC
</cfquery>

