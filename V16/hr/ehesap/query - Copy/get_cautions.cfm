<cfinclude template="../../query/get_position_branches.cfm">
<cfquery name="GET_CAUTION" datasource="#dsn#">
	SELECT
    	EC.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NO,
        E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME AS WARNER_NAME,
		EP.POSITION_NAME,
		EP.POSITION_CAT_ID,
		SETUP_POSITION_CAT.POSITION_CAT
 	FROM
		EMPLOYEES_CAUTION EC
			LEFT JOIN EMPLOYEES E2 ON E2.EMPLOYEE_ID = EC.WARNER
			LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EC.CAUTION_TO
			LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = EC.CAUTION_TO
			LEFT JOIN SETUP_POSITION_CAT ON SETUP_POSITION_CAT.POSITION_CAT_ID = EP.POSITION_CAT_ID
	WHERE 
		1=1
    	AND EP.POSITION_STATUS = 1
		AND EP.IS_MASTER = 1
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND CAUTION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
	</cfif>
	<cfif isdefined("attributes.decision_no") and len(attributes.decision_no)>
		AND DECISION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.decision_no#">
	</cfif>
	<cfif isDefined("attributes.caution_type") and len(attributes.caution_type)>
	   	AND CAUTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.caution_type#">
	</cfif>
	<cfif isDefined("attributes.startdate") and len(attributes.startdate)>
	  	AND CAUTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
	</cfif>
    <cfif isDefined("attributes.finishdate") and len(attributes.finishdate)>
	  	AND CAUTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
	</cfif>
    <cfif isDefined("attributes.apol_startdate") and len(attributes.apol_startdate)>
	  	AND APOLOGY_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.apol_startdate#">
	</cfif>
    <cfif isDefined("attributes.apol_finishdate") and len(attributes.apol_finishdate)>
	  	AND APOLOGY_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.apol_finishdate#">
	</cfif>
    <cfif isDefined("attributes.is_active") and (attributes.is_active eq 1)>
	  	AND EC.IS_ACTIVE = 1
   	<cfelseif isDefined("attributes.is_active") and (attributes.is_active eq 0)>
    	AND EC.IS_ACTIVE <> 1
	</cfif>
	<cfif not session.ep.ehesap>
		AND E.EMPLOYEE_ID IN	
		(	
		SELECT EMPLOYEE_ID 
		FROM EMPLOYEE_POSITIONS,DEPARTMENT
		WHERE EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND DEPARTMENT.BRANCH_ID IN (#my_branch_list#) 
		)
	</cfif>
    <cfif isDefined("attributes.process_stage") and len(attributes.process_stage)>
    	AND EC.STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
    </cfif>
    <cfif isDefined("attributes.department_id") and len(attributes.department_id)>
    	AND EC.CAUTION_TO IN (SELECT DISTINCT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE DEPARTMENT_ID IN (#attributes.department_id#) AND START_DATE <= EC.CAUTION_DATE AND (FINISH_DATE >= EC.CAUTION_DATE OR FINISH_DATE IS NULL))
    </cfif>
    <cfif len(attributes.cautionto_employee_id) and len(attributes.cautionto_employee_name)>
    	AND EC.CAUTION_TO = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cautionto_employee_id#">
    </cfif>
    ORDER BY
    	EC.CAUTION_ID DESC
</cfquery>


