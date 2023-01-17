<cfquery name="GET_MAX_POS" datasource="#dsn#">
			SELECT
				MAX(POSITION_CODE) AS PCODE
			FROM
				EMPLOYEE_POSITIONS
</cfquery>
	<cfif not len(get_max_pos.PCODE)>
		<cfset p=0>
	<cfelse>
			<cfset p=get_max_pos.PCODE>
	</cfif>
<cfset pcode=evaluate(p + 1)>
<cfquery name="copy_positions" datasource="#dsn#">	
	INSERT INTO
		EMPLOYEE_POSITIONS
			(
				IN_COMPANY_REASON_ID,
				POSITION_CODE,
				POSITION_CAT_ID,
				COLLAR_TYPE,
				POSITION_STATUS,
				POSITION_NAME,
				DETAIL,
				USER_GROUP_ID,
				DEPARTMENT_ID,
				EHESAP,
				IS_VEKALETEN,
				VEKALETEN_DATE,
				TITLE_ID,
				IS_CRITICAL,
				ORGANIZATION_STEP_ID,
				OZEL_KOD,
				HIERARCHY,
				DYNAMIC_HIERARCHY,
				DYNAMIC_HIERARCHY_ADD,
				IS_MASTER,
				UPPER_POSITION_CODE,
				UPPER_POSITION_CODE2,
				IS_ORG_VIEW,
				FUNC_ID,
				POSITION_STAGE,
				ON_HOUR_DAILY,
				ON_MALIYET_YIL,
				ON_HOUR,
				ON_MALIYET,
				ONGR_UCRET
			)				
			SELECT 
				IN_COMPANY_REASON_ID,
				#pcode#,
				POSITION_CAT_ID,
				COLLAR_TYPE,
				POSITION_STATUS,
				POSITION_NAME,
				DETAIL,
				USER_GROUP_ID,
				DEPARTMENT_ID,
				EHESAP,
				IS_VEKALETEN,
				VEKALETEN_DATE,
				TITLE_ID,
				IS_CRITICAL,
				ORGANIZATION_STEP_ID,
				OZEL_KOD,
				HIERARCHY,
				DYNAMIC_HIERARCHY,
				DYNAMIC_HIERARCHY_ADD,
				0,
				UPPER_POSITION_CODE,
				UPPER_POSITION_CODE2,
				IS_ORG_VIEW,
				FUNC_ID,
				POSITION_STAGE,
				ON_HOUR_DAILY,
				ON_MALIYET_YIL,
				ON_HOUR,
				ON_MALIYET,
				ONGR_UCRET
				
			FROM
				EMPLOYEE_POSITIONS
			WHERE 
				POSITION_ID=#attributes.position_id#
</cfquery>		
<cfquery name="GET_MAX_ID" datasource="#dsn#">
	SELECT MAX(POSITION_ID) AS POSITION_ID FROM EMPLOYEE_POSITIONS
</cfquery>	
<cfset history_position_id = GET_MAX_ID.POSITION_ID>
<cfinclude template="add_position_history.cfm">
<cfquery name="INSERT_POSITION_COST" datasource="#dsn#">
	INSERT INTO
		EMPLOYEE_POSITIONS_COST
		(
			POSITION_ID,
			DETAIL,
			COST_TYPE,
			POSITION_COST
		)
	SELECT 
			#history_position_id#,
			DETAIL,
			COST_TYPE,
			POSITION_COST
	FROM 
			EMPLOYEE_POSITIONS_COST
	WHERE
			POSITION_ID=#attributes.position_id#
</cfquery>	
<cfquery name="INSERT_EMP_AUTHORITY_CODES" datasource="#DSN#">
	INSERT INTO
		EMPLOYEES_AUTHORITY_CODES
		(
			POSITION_ID,
			AUTHORITY_CODE,
			MODULE_ID,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
		SELECT 
			#history_position_id#,
			AUTHORITY_CODE,
			MODULE_ID,
			#session.ep.userid#,
			'#cgi.remote_addr#',
			#now()#
		FROM 
			EMPLOYEES_AUTHORITY_CODES
		WHERE
			POSITION_ID=#attributes.position_id#
</cfquery>
<cfquery name="ADD_EMP_PERIODS" datasource="#dsn#">
		INSERT INTO 
			EMPLOYEE_POSITION_PERIODS
			(
				POSITION_ID,
				PERIOD_ID,
				PERIOD_DATE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
		SELECT 
				#history_position_id#,
				PERIOD_ID,
				PERIOD_DATE,
				#session.ep.userid#,
				#now()#,
				'#cgi.remote_addr#'
		FROM 
				EMPLOYEE_POSITION_PERIODS
		WHERE
				POSITION_ID=#attributes.position_id#
						
</cfquery>
<cfquery name="add_emp_branches" datasource="#dsn#">
		INSERT INTO
				EMPLOYEE_POSITION_BRANCHES
			(
				POSITION_CODE,
				BRANCH_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
        SELECT 
                    #pcode#,
                    BRANCH_ID,
                    #session.ep.userid#,
                    #now()#,
                    '#cgi.remote_addr#'
        FROM 
                    EMPLOYEE_POSITION_BRANCHES
        WHERE
				POSITION_CODE=#attributes.position_code#
</cfquery>
<cflocation url="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#GET_MAX_ID.POSITION_ID#" addtoken="no">

