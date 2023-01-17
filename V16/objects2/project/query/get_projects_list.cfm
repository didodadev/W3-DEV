<cfquery name="GET_PROJECTS" datasource="#DSN#">
	SELECT 
		DISTINCT(PP.PROJECT_ID),
		PP.PROJECT_HEAD,
		PP.CONSUMER_ID,
		PP.COMPANY_ID,
		PP.PARTNER_ID,
        PP.PROJECT_EMP_ID,
        PP.PRO_PRIORITY_ID,
        PP.PROCESS_CAT,
        PP.PROJECT_NUMBER,
        PP.WORKGROUP_ID,
		(SELECT EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = PP.PROJECT_EMP_ID) PRO_EMPLOYEE,
		PP.OUTSRC_PARTNER_ID,
		PP.TARGET_FINISH,
		PP.TARGET_START,
		PP.PRO_CURRENCY_ID,
		SP.COLOR,
		SP.PRIORITY
	FROM 
		WORK_GROUP WG,
		WORKGROUP_EMP_PAR WEP,
		PRO_PROJECTS PP,
		SETUP_PRIORITY SP
		<cfif len(attributes.keyword)>
			,PRO_HISTORY
		</cfif>
	WHERE
		WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND 
		PP.PRO_PRIORITY_ID = SP.PRIORITY_ID AND
		(	
        	PP.PROJECT_ID = WG.PROJECT_ID OR 
			WG.PROJECT_ID IS NULL 
		)
       AND
		(	
			PP.OUTSRC_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
			PP.OUTSRC_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
			PP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
			PP.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
			PP.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
			WEP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR
			WEP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		)
		<cfif len(attributes.keyword) gt 1>
			AND PP.PROJECT_ID=PRO_HISTORY.PROJECT_ID
			AND (
                    PP.PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    PP.PROJECT_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
		<cfelseif len(attributes.keyword) eq 1>
			AND PP.PROJECT_ID = PRO_HISTORY.PROJECT_ID
			AND PP.PROJECT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif len(attributes.currency)>
			AND PP.PRO_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency#">
		</cfif>
		<cfif len(attributes.priority_cat)>
			AND PP.PRO_PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.priority_cat#"> 
		</cfif>
		<cfif attributes.project_status eq "1">
			AND PP.PROJECT_STATUS = 1
		<cfelseif attributes.project_status eq "-1">
			AND PP.PROJECT_STATUS = 0 
		<cfelseif attributes.project_status eq "0">
			AND (PP.PROJECT_STATUS = 0 OR PP.PROJECT_STATUS=1)
		<cfelse><!--- default secim --->
			AND PP.PROJECT_STATUS=1
		</cfif>
</cfquery>
