<cfquery name="GET_APPS" datasource="#dsn#">
	SELECT
		EMPLOYEES_APP.EMPAPP_ID,
		EMPLOYEES_APP_POS.APP_POS_ID,
		EMPLOYEES_APP_POS.POSITION_ID,
		EMPLOYEES_APP_POS.POSITION_CAT_ID,
		EMPLOYEES_APP_POS.APP_DATE,
		EMPLOYEES_APP.NAME,
		EMPLOYEES_APP.SURNAME,
		EMPLOYEES_APP_POS.NOTICE_ID,
		EMPLOYEES_APP_POS.APP_POS_STATUS,
		EMPLOYEES_APP.RECORD_DATE
	FROM
		EMPLOYEES_APP,
		EMPLOYEES_APP_POS
	WHERE
		EMPLOYEES_APP.EMPAPP_ID IS NOT NULL
		AND EMPLOYEES_APP.EMPAPP_ID=EMPLOYEES_APP_POS.EMPAPP_ID
		AND EMPLOYEES_APP_POS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		AND EMPLOYEES_APP_POS.APP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">  
		AND EMPLOYEES_APP_POS.APP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
			<cfif isdefined("attributes.keyword") AND len(attributes.keyword)>
			 AND
			   (
			   	EMPLOYEES_APP.NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				EMPLOYEES_APP.SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
			</cfif>
			<cfif len(attributes.status) eq 1>
				AND EMPLOYEES_APP_POS.APP_POS_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
		 	</cfif>
		 <cfif attributes.date_status eq 1>ORDER BY EMPLOYEES_APP_POS.APP_DATE DESC
			<cfelseif attributes.date_status eq 2>ORDER BY EMPLOYEES_APP_POS.APP_DATE ASC
			<cfelseif attributes.date_status eq 3>ORDER BY EMPLOYEES_APP.RECORD_DATE DESC
			<cfelseif attributes.date_status eq 4>ORDER BY EMPLOYEES_APP.RECORD_DATE ASC
			<cfelseif attributes.date_status eq 5>ORDER BY NAME DESC
			<cfelseif attributes.date_status eq 6>ORDER BY NAME ASC
		</cfif>
</cfquery>

