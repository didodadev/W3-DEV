<cfquery name="get_p_order_results" datasource="#dsn3#">
	SELECT
		P_ORDER_ID,
		RESULT_NO,
		PRODUCTION_ORDER_NO,
		START_DATE,
		FINISH_DATE
	FROM
		PRODUCTION_ORDER_RESULTS
	WHERE
		1 = 1 
	  <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND (PRODUCTION_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR RESULT_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
	  </cfif>
	 <cfif len(attributes.start_date)>
		AND START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp"  value="#attributes.start_date#">
	</cfif>
	<cfif len(attributes.finish_date)>
		AND FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("d",1,attributes.finish_date)#">
	</cfif>
	ORDER BY
		RESULT_NO
</cfquery>
