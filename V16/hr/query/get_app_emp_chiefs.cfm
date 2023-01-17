<cfif isnumeric(attributes.APP_POSITION_ID)>
<!--- 	<cfquery name="GET_NOTICE_POSITION_CODE" datasource="#dsn#">
		SELECT
			POSITION_CODE
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_ID = #attributes.APP_POSITION_ID#
	</cfquery>
 --->	
	<cfquery name="GET_NOTICE_ID" datasource="#dsn#">
		SELECT
			MAX(NOTICE_ID) NOTICE_ID 
		FROM
			NOTICES
		WHERE
			POSITION_ID = #attributes.APP_POSITION_ID#
	</cfquery><!--- #GET_NOTICE_POSITION_CODE.POSITION_CODE# --->
	
	<cfif isnumeric(GET_NOTICE_ID.NOTICE_ID)>
		<cfquery name="GET_NOTICE" datasource="#dsn#">
			SELECT
				*
			FROM
				NOTICES
			WHERE
				NOTICE_ID = #GET_NOTICE_ID.NOTICE_ID#
		</cfquery>
		<cfif len(GET_NOTICE.INTERVIEW_POSITION_CODE)>
			<cfquery name="GET_EMP_DEPT_CHIEF" datasource="#dsn#">
				SELECT 
					EMPLOYEE_ID, POSITION_CODE, EMPLOYEE_NAME, EMPLOYEE_SURNAME
				FROM 
					EMPLOYEE_POSITIONS
				WHERE
					POSITION_CODE = #GET_NOTICE.INTERVIEW_POSITION_CODE# 
			</cfquery>
		</cfif>
		<cfif len(GET_NOTICE.VALIDATOR_POSITION_CODE)>
			<cfquery name="GET_EMP_BRANCH_CHIEF" datasource="#dsn#">
				SELECT 
					EMPLOYEE_ID, POSITION_CODE, EMPLOYEE_NAME, EMPLOYEE_SURNAME
				FROM 
					EMPLOYEE_POSITIONS
				WHERE
					POSITION_CODE = #GET_NOTICE.VALIDATOR_POSITION_CODE# 
			</cfquery>
		</cfif>
	</cfif>
</cfif>
