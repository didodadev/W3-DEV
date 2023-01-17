<cfquery name="GET_EMPS_PARS_CONS" datasource="#DSN#">
	<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
			SELECT
				3 AS TYPE,
				CP.PARTNER_ID AS UYE_ID,
				CP.COMPANY_ID AS COMP_ID,
				CP.COMPANY_PARTNER_NAME AS UYE_NAME,
				CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
				C.NICKNAME AS NICKNAME
			FROM
				COMPANY_PARTNER CP,
				COMPANY C
			WHERE
				CP.COMPANY_ID = C.COMPANY_ID AND
				CP.COMPANY_PARTNER_STATUS = 1 AND		
				CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		<cfif attributes.company_id neq session.pp.company_id>
			UNION
				SELECT
					4 AS TYPE,
					CP.PARTNER_ID AS UYE_ID,
					CP.COMPANY_ID AS COMP_ID,
					CP.COMPANY_PARTNER_NAME AS UYE_NAME,
					CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
					C.NICKNAME AS NICKNAME
				FROM
					COMPANY_PARTNER CP,
					COMPANY C
				WHERE
					CP.COMPANY_ID = C.COMPANY_ID AND	
					CP.COMPANY_PARTNER_STATUS = 1 AND	
					CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
	<cfelse>
			SELECT
				1 AS TYPE,
				EP.EMPLOYEE_ID AS UYE_ID,
				0 AS COMP_ID,
				EP.EMPLOYEE_NAME AS UYE_NAME,
				EP.EMPLOYEE_SURNAME AS UYE_SURNAME,
				'' AS NICKNAME
			FROM
				EMPLOYEE_POSITIONS EP,
				WORKGROUP_EMP_PAR WE
			WHERE
				EP.POSITION_STATUS = 1 AND
				EP.POSITION_CODE = WE.POSITION_CODE AND
				WE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		UNION
			SELECT
				2 AS TYPE,
				CP.PARTNER_ID AS UYE_ID,
				CP.COMPANY_ID AS COMP_ID,
				CP.COMPANY_PARTNER_NAME AS UYE_NAME,
				CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
				C.NICKNAME AS NICKNAME
			FROM
				COMPANY_PARTNER CP,
				WORKGROUP_EMP_PAR WE,
				COMPANY C
			WHERE
				C.COMPANY_ID = CP.COMPANY_ID AND
				CP.PARTNER_ID = WE.PARTNER_ID AND
				CP.COMPANY_PARTNER_STATUS = 1 AND
				WE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		UNION
			SELECT
				3 AS TYPE,
				CP.PARTNER_ID AS UYE_ID,
				CP.COMPANY_ID AS COMP_ID,
				CP.COMPANY_PARTNER_NAME AS UYE_NAME,
				CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
				C.NICKNAME AS NICKNAME
			FROM
				COMPANY_PARTNER CP,
				COMPANY C
			WHERE
				CP.COMPANY_ID = C.COMPANY_ID AND
				CP.COMPANY_PARTNER_STATUS = 1 AND		
				CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		UNION
			SELECT
				4 AS TYPE,
				CP.PARTNER_ID AS UYE_ID,
				CP.COMPANY_ID AS COMP_ID,
				CP.COMPANY_PARTNER_NAME AS UYE_NAME,
				CP.COMPANY_PARTNER_SURNAME AS UYE_SURNAME,
				C.NICKNAME AS NICKNAME
			FROM
				COMPANY_PARTNER CP,
				COMPANY C
			WHERE
				CP.COMPANY_ID = C.COMPANY_ID AND
				CP.COMPANY_PARTNER_STATUS = 1 AND		
				C.HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		UNION
			SELECT
				5 AS TYPE,
				C.CONSUMER_ID AS UYE_ID,
				0 AS COMP_ID,
				C.CONSUMER_NAME AS UYE_NAME,
				C.CONSUMER_SURNAME AS UYE_SURNAME,
				'' AS NICKNAME
			FROM
				CONSUMER C
			WHERE	
				C.HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	</cfif>
</cfquery>
