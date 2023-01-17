<cfcomponent>

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">
	<cffunction name="setSession" access="remote" returntype="any" returnFormat="json">
    	<cfset session.ep.refineryObjectId = arguments.refineryObjectId>
		<cfreturn 1>
	</cffunction>
	<cffunction name="saveParameter" access="public" returntype="any">
		<cfargument name = "parameterId" default="">
		<cfargument name = "groupId" default="">
		<cfargument name = "parameterName" default="">
		<cfargument name = "minLimit" default="">
		<cfargument name = "maxLimit" default="">
		<cfargument name = "parameterStatus" default="">
		<cfargument name = "parameterDeleted" default="">

		<cfquery name="UPD_PARAMETERS" datasource="#dsn#">
			<cfif len(arguments.parameterId)>
				<cfif arguments.parameterDeleted eq 0>
					UPDATE
						REFINERY_TEST_PARAMETERS
					SET
						PARAMETER_NAME = <cfif len(arguments.parameterName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parameterName#"><cfelse>NULL</cfif>,
						MIN_LIMIT = <cfif len(arguments.minLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.minLimit#"><cfelse>NULL</cfif>,
						MAX_LIMIT = <cfif len(arguments.maxLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.maxLimit#"><cfelse>NULL</cfif>,
						GROUP_ID = <cfif len(arguments.groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#"><cfelse>NULL</cfif>,
						PARAMETER_STATUS = <cfif len(arguments.parameterStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.parameterStatus#"><cfelse>NULL</cfif>,
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					WHERE
						REFINERY_TEST_PARAMETER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parameterId#">
				<cfelse>
					DELETE FROM REFINERY_TEST_PARAMETERS WHERE REFINERY_TEST_PARAMETER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parameterId#">
				</cfif>
			<cfelse>
				INSERT INTO
					REFINERY_TEST_PARAMETERS
				(
					PARAMETER_NAME,
					MIN_LIMIT,
					MAX_LIMIT,
					GROUP_ID,
					PARAMETER_STATUS,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfif len(arguments.parameterName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parameterName#"><cfelse>NULL</cfif>,
					<cfif len(arguments.minLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.minLimit#"><cfelse>NULL</cfif>,
					<cfif len(arguments.maxLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.maxLimit#"><cfelse>NULL</cfif>,
					<cfif len(arguments.groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#"><cfelse>NULL</cfif>,
					<cfif len(arguments.parameterStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.parameterStatus#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
			</cfif>
		</cfquery>
		<cfreturn 1>
	</cffunction>
	<cffunction name="delParameter" access="public" returntype="any">
		<cfargument name = "groupId" default="">
		<cfquery name="DEL_PARAMETERS" datasource="#dsn#">
			DELETE FROM REFINERY_TEST_PARAMETERS WHERE GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#">
		</cfquery>
	</cffunction>
	<cffunction name="saveMethod" access="public" returntype="any">
		<cfargument name = "methodId" default="">
		<cfargument name = "groupId" default="">
		<cfargument name = "parameterId" default="">
		<cfargument name = "methodName" default="">
		<cfargument name = "methodStatus" default="">
		<cfargument name = "methodDeleted" default="">

		<cfquery name="UPD_METHOD" datasource="#dsn#">
			<cfif len(arguments.methodId)>
				<cfif arguments.methodDeleted eq 0>
					UPDATE
						REFINERY_TEST_METHODS
					SET
						REFINERY_GROUP_ID = <cfif len(arguments.groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#"><cfelse>NULL</cfif>,
						REFINERY_TEST_PARAMETER_ID = <cfif len(arguments.parameterId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parameterId#"><cfelse>NULL</cfif>,
						TEST_METHOD_NAME = <cfif len(arguments.methodName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.methodName#"><cfelse>NULL</cfif>,
						TEST_METHOD_STATUS = <cfif len(arguments.methodStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.methodStatus#"><cfelse>NULL</cfif>,
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					WHERE
						REFINERY_TEST_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.methodId#">
				<cfelse>
					DELETE FROM REFINERY_TEST_METHODS WHERE REFINERY_TEST_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.methodId#">
				</cfif>
			<cfelse>
				INSERT INTO
					REFINERY_TEST_METHODS
				(
					REFINERY_GROUP_ID,
					REFINERY_TEST_PARAMETER_ID,
					TEST_METHOD_NAME,
					TEST_METHOD_STATUS,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfif len(arguments.groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#"><cfelse>NULL</cfif>,
					<cfif len(arguments.parameterId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parameterId#"><cfelse>NULL</cfif>,
					<cfif len(arguments.methodName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.methodName#"><cfelse>NULL</cfif>,
					<cfif len(arguments.methodStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.methodStatus#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
			</cfif>
		</cfquery>
		<cfreturn 1>
	</cffunction>
	<cffunction name="delMethod" access="public" returntype="any">
		<cfargument name = "groupId" default="">
		<cfquery name="DEL_METHOD" datasource="#dsn#">
			DELETE FROM REFINERY_TEST_METHODS WHERE REFINERY_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#">
		</cfquery>
	</cffunction>
	<cffunction name="saveUnit" access="public" returntype="any">
		<cfargument name = "unitId" default="">
		<cfargument name = "unitName" default="">
		<cfargument name = "unitStatus" default="">
		<cfargument name = "unitDeleted" default="">

		<cfquery name="UPD_PARAMETERS" datasource="#dsn#">
			<cfif len(arguments.unitId)>
				<cfif arguments.unitDeleted eq 0>
					UPDATE
						REFINERY_TEST_UNITS
					SET
						UNIT_NAME = <cfif len(arguments.unitName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.unitName#"><cfelse>NULL</cfif>,
						UNIT_STATUS = <cfif len(arguments.unitStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.unitStatus#"><cfelse>NULL</cfif>,
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					WHERE
						REFINERY_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unitId#">
				<cfelse>
					DELETE FROM REFINERY_TEST_UNITS WHERE REFINERY_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unitId#">
				</cfif>
			<cfelse>
				INSERT INTO
					REFINERY_TEST_UNITS
				(
					UNIT_NAME,
					UNIT_STATUS,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfif len(arguments.unitName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.unitName#"><cfelse>NULL</cfif>,
					<cfif len(arguments.unitStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.unitStatus#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
			</cfif>
		</cfquery>
		<cfreturn 1>
	</cffunction>
	<cffunction name="saveAnalyzeCat" access="public" returntype="any">
		<cfargument name = "analyzeCatId" default="">
		<cfargument name = "analyzeCatName" default="">
		<cfargument name = "analyzeCatStatus" default="">
		<cfargument name = "analyzeCatDeleted" default="">

		<cfquery name="UPD_PARAMETERS" datasource="#dsn#">
			<cfif len(arguments.analyzeCatId)>
				<cfif arguments.analyzeCatDeleted eq 0>
					UPDATE
						REFINERY_ANALYZE_CAT
					SET
						ANALYZE_CAT_NAME = <cfif len(arguments.analyzeCatName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.analyzeCatName#"><cfelse>NULL</cfif>,
						ANALYZE_CAT_STATUS = <cfif len(arguments.analyzeCatStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.analyzeCatStatus#"><cfelse>NULL</cfif>,
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					WHERE
						ANALYZE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analyzeCatId#">
				<cfelse>
					DELETE FROM REFINERY_ANALYZE_CAT WHERE ANALYZE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analyzeCatId#">
				</cfif>
			<cfelse>
				INSERT INTO
					REFINERY_ANALYZE_CAT
				(
					ANALYZE_CAT_NAME,
					ANALYZE_CAT_STATUS,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfif len(arguments.analyzeCatName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.analyzeCatName#"><cfelse>NULL</cfif>,
					<cfif len(arguments.analyzeCatStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.analyzeCatStatus#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
			</cfif>
		</cfquery>
		<cfreturn 1>
	</cffunction>
	<cffunction name="getAnalyzeCat" access="public" returntype="any">
		<cfquery name="getAnalyzeCat" datasource="#dsn#">
			SELECT * FROM REFINERY_ANALYZE_CAT WHERE OUR_COMPANY_ID = <cfqueryparam	cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfreturn getAnalyzeCat>
	</cffunction>
	<cffunction name="saveGroup" access="public" returntype="any">
		<cfargument name = "groupId" default="">
		<cfargument name = "groupName" default="">
		<cfargument name = "groupStatus" default="">
		<cfargument name = "groupDeleted" default="">

		<cfquery name="UPD_PARAMETERS" datasource="#dsn#">
			<cfif len(arguments.groupId)>
				<cfif arguments.groupDeleted eq 0>
					UPDATE
						REFINERY_GROUPS
					SET
						GROUP_NAME = <cfif len(arguments.groupName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupName#"><cfelse>NULL</cfif>,
						GROUP_STATUS = <cfif len(arguments.groupStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.groupStatus#"><cfelse>NULL</cfif>,
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					WHERE
						REFINERY_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#">
				<cfelse>
					DELETE FROM REFINERY_GROUPS WHERE REFINERY_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#">
				</cfif>
			<cfelse>
				INSERT INTO
					REFINERY_GROUPS
				(
					GROUP_NAME,
					GROUP_STATUS,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfif len(arguments.groupName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupName#"><cfelse>NULL</cfif>,
					<cfif len(arguments.groupStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.groupStatus#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
			</cfif>
		</cfquery>
		<cfreturn 1>
	</cffunction>
	<cffunction name="getAnalyze" access="public" returntype="any">
		<cfargument name="refinery_test_id" default="" required="true">
		<cfquery name="GET_TEST_ALL" datasource="#DSN#">
			SELECT
				*
			FROM
				REFINERY_TEST
			WHERE 
				REFINERY_TEST_ID = #arguments.refinery_test_id# AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfreturn GET_TEST_ALL>
	</cffunction>
	<cffunction name="getAnalyzeRow" access="public" returntype="any">
		<cfargument name="refinery_test_id" default="" required="true">
		<cfquery name="GET_TEST_ROW" datasource="#DSN#">
			SELECT
				*
			FROM
				REFINERY_TEST_ROWS
			WHERE 
				PARAMETER_TEST_ID = #arguments.refinery_test_id#
		</cfquery>
		<cfreturn GET_TEST_ROW>
	</cffunction>
	<cffunction name="getLabTest" access="remote" returntype="any">
		<cfargument name = "refinery_lab_test_id" default="" required="false">
		<cfargument name = "keyword" default="" required="false">
		<cfargument name = "analyze_cat" default="" required="false">

		<cfquery name="getLabTest" datasource="#DSN#">
			SELECT 
				REF.*,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				EMPX.EMPLOYEE_NAME AS SAMPLE_EMPLOYEE_NAME,
				EMPX.EMPLOYEE_SURNAME AS SAMPLE_EMPLOYEE_SURNAME,
				CON.CONSUMER_NAME,
				CON.CONSUMER_SURNAME,
				COM.FULLNAME,
				DP.DEPARTMENT_HEAD,
				ST.COMMENT,
				#dsn#.#dsn#.Get_Dynamic_Language(PROCESS_ROW_ID,'#ucase(session.ep.language)#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE
			FROM 
				REFINERY_LAB_TESTS AS REF
			JOIN PROCESS_TYPE_ROWS AS PTR ON REF.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			JOIN EMPLOYEES AS EMP ON REF.REQUESTING_EMPLOYE_ID = EMP.EMPLOYEE_ID
			LEFT JOIN EMPLOYEES AS EMPX ON REF.SAMPLE_EMPLOYEE_ID = EMPX.EMPLOYEE_ID
			LEFT JOIN CONSUMER AS CON ON REF.CONSUMER_ID = CON.CONSUMER_ID
			LEFT JOIN COMPANY AS COM ON REF.COMPANY_ID = COM.COMPANY_ID
			LEFT JOIN STOCKS_LOCATION AS ST ON REF.LOCATION_ID = ST.LOCATION_ID and REF.DEPARTMENT_ID = ST.DEPARTMENT_ID
			LEFT JOIN DEPARTMENT AS DP ON REF.DEPARTMENT_ID = DP.DEPARTMENT_ID
			WHERE 1 = 1 AND REF.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			<cfif isDefined("arguments.refinery_lab_test_id") and len(arguments.refinery_lab_test_id)>
				AND REF.REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.refinery_lab_test_id#">
			</cfif>
			<cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
				AND REF.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
			</cfif>
			<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
				AND REF.LAB_REPORT_NO LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%">
			</cfif>
			<cfif isDefined("arguments.analyze_cat") and len(arguments.analyze_cat)>
				AND REF.ANALYZE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analyze_cat#">
			</cfif>
			ORDER BY
				REFINERY_LAB_TEST_ID DESC
		</cfquery>
		<cfreturn getLabTest />
	</cffunction>
	<cffunction name="getLabTestRow" access="remote" returntype="any">
		<cfargument name = "refinery_lab_test_id" default="" required="false">
		<cfquery name="getLabTestRow" datasource="#DSN#">
			SELECT REF.*, EMP.EMPLOYEE_NAME, EMP.EMPLOYEE_SURNAME FROM REFINERY_LAB_TESTS_ROW AS REF
			LEFT JOIN EMPLOYEES AS EMP ON EMP.EMPLOYEE_ID = REF.RECORD_EMP
			WHERE REF.REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.refinery_lab_test_id#">
		</cfquery>
		<cfreturn getLabTestRow />
	</cffunction>
	<cffunction name="saveLabTestForm" access="remote" returntype="any">
		<cfargument name="refinery_waste_oil_id" default="" required="false">
		<cfargument name="process_stage" default="" required="false">
		<cfargument name="requesting_employee_id" default="" required="false">
		<cfargument name="requesting_employee_name" default="" required="false">
		<cfargument name="lab_report_no" default="" required="false">
		<cfargument name="numune_date" default="" required="false">
		<cfargument name="numune_name" default="" required="false">
		<cfargument name="numune_accept_date" default="" required="false">
		<cfargument name="sample_employee_id" default="" required="false">
		<cfargument name="sample_employee_name" default="" required="false">
		<cfargument name="analyse_date" default="" required="false">
		<cfargument name="analyse_date_exit" default="" required="false">
		<cfargument name="numune_place" default="" required="false">
		<cfargument name="detail" default="" required="false">
		<cfargument name="numune_point" default="" required="false">
		<cfargument name="lab_test_id" default="" required="false">
		<cfargument name="consumer_id" default="" required="false">
		<cfargument name="company_id" default="" required="false">
		<cfargument name="member_name" default="" required="false">
		<cfargument name="member_type" default="" required="false">
		<cfargument name="analyze_cat" default="" required="false">
		<cfargument name="location_id" default="" required="false">
		<cfargument name="department_name" default="" required="false">
		<cfargument name="department_id" default="" required="false">
		<cfargument name="branch_id" default="" required="false">
		
		<cfquery name="saveLabTestForm" datasource="#dsn#" result="result">
			INSERT INTO
				REFINERY_LAB_TESTS
			(
				REFINERY_WASTE_OIL_ID,
				LAB_TEST_ID,
				REQUESTING_EMPLOYE_ID,
				LAB_REPORT_NO,
				NUMUNE_DATE,
				NUMUNE_ACCEPT_DATE,
				NUMUNE_NAME,
				SAMPLE_EMPLOYEE_ID,
				ANALYSE_DATE,
				ANALYSE_DATE_EXIT,
				NUMUNE_PLACE,
				DETAIL,
				NUMUNE_POINT,
				PROCESS_STAGE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				CONSUMER_ID,
				COMPANY_ID,
				MEMBER_TYPE,
				ANALYZE_CAT_ID,
				OUR_COMPANY_ID,
				LOCATION_ID,
				DEPARTMENT_ID,
				BRANCH_ID
			)
			VALUES
			(
				<cfif len(arguments.refinery_waste_oil_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_waste_oil_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.lab_test_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lab_test_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.requesting_employee_id) and len(arguments.requesting_employee_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.requesting_employee_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.lab_report_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.lab_report_no#"><cfelse>NULL</cfif>,
				<cfif len(arguments.numune_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.numune_date#"><cfelse>NULL</cfif>,
				<cfif len(arguments.numune_accept_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.numune_accept_date#"><cfelse>NULL</cfif>,
				<cfif len(arguments.numune_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.numune_name#"><cfelse>NULL</cfif>,
				<cfif len(arguments.sample_employee_id) and len(arguments.sample_employee_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sample_employee_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.analyse_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.analyse_date#"><cfelse>NULL</cfif>,
				<cfif len(arguments.analyse_date_exit)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.analyse_date_exit#"><cfelse>NULL</cfif>,
				<cfif len(arguments.numune_place)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.numune_place#"><cfelse>NULL</cfif>,
				<cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
				<cfif len(arguments.numune_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.numune_point#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfif len(arguments.consumer_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.company_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.member_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.member_type#"><cfelse>NULL</cfif>,
				<cfif len(arguments.analyze_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analyze_cat#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
				<cfif len(arguments.location_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.department_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.branch_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="updLabTestForm" access="remote" returntype="any">
		<cfargument name="refinery_lab_test_id" default="" required="true">
		<cfargument name="process_stage" default="" required="false">
		<cfargument name="requesting_employee_id" default="" required="false">
		<cfargument name="requesting_employee_name" default="" required="false">
		<cfargument name="lab_report_no" default="" required="false">
		<cfargument name="numune_date" default="" required="false">
		<cfargument name="numune_person" default="" required="false">
		<cfargument name="numune_accept_date" default="" required="false">
		<cfargument name="numune_name" default="" required="false">
		<cfargument name="sample_employee_id" default="" required="false">
		<cfargument name="sample_employee_name" default="" required="false">
		<cfargument name="analyse_date" default="" required="false">
		<cfargument name="analyse_date_exit" default="" required="false">
		<cfargument name="numune_place" default="" required="false">
		<cfargument name="detail" default="" required="false">
		<cfargument name="numune_point" default="" required="false">
		<cfargument name="lab_test_id" default="" required="false">
		<cfargument name="consumer_id" default="" required="false">
		<cfargument name="company_id" default="" required="false">
		<cfargument name="member_name" default="" required="false">
		<cfargument name="member_type" default="" required="false">
		<cfargument name="analyze_cat" default="" required="false">
		<cfargument name="location_id" default="" required="false">
		<cfargument name="department_id" default="" required="false">
		<cfargument name="branch_id" default="" required="false">
		<cfargument name="department_name" default="" required="false">

		<cfquery name="updLabTestForm" datasource="#dsn#">
			UPDATE REFINERY_LAB_TESTS
			SET
				REQUESTING_EMPLOYE_ID = <cfif len(arguments.requesting_employee_id) and len(arguments.requesting_employee_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.requesting_employee_id#"><cfelse>NULL</cfif>,
				LAB_REPORT_NO = <cfif len(arguments.lab_report_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.lab_report_no#"><cfelse>NULL</cfif>,
				NUMUNE_DATE = <cfif len(arguments.numune_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.numune_date#"><cfelse>NULL</cfif>,
				NUMUNE_PERSON = <cfif len(arguments.numune_person)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.numune_person#"><cfelse>NULL</cfif>,
				NUMUNE_ACCEPT_DATE = <cfif len(arguments.numune_accept_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.numune_accept_date#"><cfelse>NULL</cfif>,
				NUMUNE_NAME = <cfif len(arguments.numune_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.numune_name#"><cfelse>NULL</cfif>,
				SAMPLE_EMPLOYEE_ID = <cfif len(arguments.sample_employee_id) and len(arguments.sample_employee_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sample_employee_id#"><cfelse>NULL</cfif>,
				ANALYSE_DATE = <cfif len(arguments.analyse_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.analyse_date#"><cfelse>NULL</cfif>,
				ANALYSE_DATE_EXIT = <cfif len(arguments.analyse_date_exit)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.analyse_date_exit#"><cfelse>NULL</cfif>,
				NUMUNE_PLACE = <cfif len(arguments.numune_place)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.numune_place#"><cfelse>NULL</cfif>,
				DETAIL = <cfif len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.detail#"><cfelse>NULL</cfif>,
				NUMUNE_POINT = <cfif len(arguments.numune_point)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.numune_point#"><cfelse>NULL</cfif>,
				LAB_TEST_ID = <cfif len(arguments.lab_test_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.lab_test_id#"><cfelse>NULL</cfif>,
				PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.process_stage#">,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				CONSUMER_ID = <cfif len(arguments.consumer_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
				COMPANY_ID = <cfif len(arguments.company_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
				MEMBER_TYPE = <cfif len(arguments.member_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.member_type#"><cfelse>NULL</cfif>,
				ANALYZE_CAT_ID = <cfif len(arguments.analyze_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analyze_cat#"><cfelse>NULL</cfif>,
				LOCATION_ID = <cfif len(arguments.location_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#"><cfelse>NULL</cfif>,
				DEPARTMENT_ID = <cfif len(arguments.department_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"><cfelse>NULL</cfif>,
				BRANCH_ID = <cfif len(arguments.branch_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>
			WHERE 
				REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_lab_test_id#">
		</cfquery>
    </cffunction>
	<cffunction name="savePostCargo" access="remote" returntype="any">
    	<cfargument name="postSender" default="" required="false">
		<cfargument name="postSenderId" default="" required="false">
		<cfargument name="postBuyer" default="" required="false">
		<cfargument name="postBuyerId" default="" required="false">
		<cfargument name="postResponsible" default="" required="false">
		<cfargument name="postResponsibleId" default="" required="false">
		<cfargument name="postType" default="" required="false">
		<cfargument name="exitDate" default="" required="false">
		<cfquery name="savePostCargo" datasource="#dsn#" result="result">
			INSERT INTO
				REFINERY_POST_CARGO
			(
				POST_SENDER,
				POST_SENDER_ID,
				POST_BUYER,
				POST_BUYER_ID,
				POST_RESPONSIBLE,
				POST_RESPONSIBLE_ID,
				POST_TYPE,
				<!---POST_TYPE_ID,--->
				POST_DATE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				OUR_COMPANY_ID
			)
			VALUES
			(
				<cfif len(arguments.postSender)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.postSender#"><cfelse>NULL</cfif>,
				<cfif len(arguments.postSenderId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.postSenderId#"><cfelse>NULL</cfif>,
				<cfif len(arguments.postBuyer)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.postBuyer#"><cfelse>NULL</cfif>,
				<cfif len(arguments.postBuyerId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.postBuyerId#"><cfelse>NULL</cfif>,
				<cfif len(arguments.postResponsible)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.postResponsible#"><cfelse>NULL</cfif>,
				<cfif len(arguments.postResponsibleId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.postResponsibleId#"><cfelse>NULL</cfif>,
				<cfif len(arguments.postType)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.postType#"><cfelse>NULL</cfif>,
				<!---<cfif len(arguments.post_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.post_type_id#"><cfelse>NULL</cfif>,--->
				<cfif len(arguments.exitDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.exitDate#"><cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="updPostCargo" access="remote" returntype="any">
		<cfargument name="refinery_post_cargo_id" default="" required="true">
		<cfargument name="postSender" default="" required="false">
		<cfargument name="postSenderId" default="" required="false">
		<cfargument name="postBuyer" default="" required="false">
		<cfargument name="postBuyerId" default="" required="false">
		<cfargument name="postResponsible" default="" required="false">
		<cfargument name="postResponsibleId" default="" required="false">
		<cfargument name="postType" default="" required="false">
		<cfargument name="exitDate" default="" required="false">
		<cfquery name="updPostCargo" datasource="#dsn#">
			UPDATE REFINERY_POST_CARGO
			SET	
				POST_SENDER = <cfif len(arguments.postSender)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.postSender#"><cfelse>NULL</cfif>,
				POST_SENDER_ID = <cfif len(arguments.postSenderId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.postSenderId#"><cfelse>NULL</cfif>,
				POST_BUYER = <cfif len(arguments.postBuyer)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.postBuyer#"><cfelse>NULL</cfif>,
				POST_BUYER_ID = <cfif len(arguments.postBuyerId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.postBuyerId#"><cfelse>NULL</cfif>,
				POST_RESPONSIBLE = <cfif len(arguments.postResponsible)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.postResponsible#"><cfelse>NULL</cfif>,
				POST_RESPONSIBLE_ID = <cfif len(arguments.postResponsibleId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.postResponsibleId#"><cfelse>NULL</cfif>,
				POST_TYPE = <cfif len(arguments.postType)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.postType#"><cfelse>NULL</cfif>,
				POST_DATE = <cfif len(arguments.exitDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.exitDate#"><cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
			WHERE REFINERY_POST_CARGO_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_post_cargo_id#">
		</cfquery>
	</cffunction>
	<cffunction name="getPostCargo" access="remote" returntype="any">
		<cfargument name = "refinery_post_cargo_id" default="" required="false">
		<cfargument name = "keyword" default="" required="false">

		<cfquery name="getPostCargo" datasource="#DSN#">
			SELECT 
				*
			FROM 
				REFINERY_POST_CARGO 
				WHERE 1 = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif isDefined("arguments.refinery_post_cargo_id") and len(arguments.refinery_post_cargo_id)>
					AND REFINERY_POST_CARGO_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.refinery_post_cargo_id#">
				</cfif>
			ORDER BY
				POST_DATE DESC
		</cfquery>
		<cfreturn getPostCargo />
	</cffunction>
	<cffunction name="saveProductAcceptence" access="remote" returntype="any">
		<cfargument name="despatchNumber" default="" required="false">
		<cfargument name="companyName" default="" required="false">
		<cfargument name="companyId" default="" required="false">
		<cfargument name="orderResponsible" default="" required="false">
		<cfargument name="orderResponsibleId" default="" required="false">
		<cfargument name="responsible" default="" required="false">
		<cfargument name="responsibleId" default="" required="false">
		<cfargument name="postDate" default="" required="false">
		<cfargument name="exitDate" default="" required="false">
		
		<cfquery name="saveProductAcceptence" datasource="#dsn#" result="result">
			INSERT INTO
				REFINERY_PRODUCT_ACCEPTENCE
			(
				DESPATCH_NUMBER,
				COMPANY_NAME,
				COMPANY_ID,
				ORDER_RESPONSIBLE,
				ORDER_RESPONSIBLE_ID,
				RESPONSIBLE,
				RESPONSIBLE_ID,
				ACCEPT_DATE,
				EXIT_DATE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				OUR_COMPANY_ID
			)
			VALUES
			(
				<cfif len(arguments.despatchNumber)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.despatchNumber#"><cfelse>NULL</cfif>,
				<cfif len(arguments.companyName)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.companyName#"><cfelse>NULL</cfif>,
				<cfif len(arguments.companyId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.companyId#"><cfelse>NULL</cfif>,
				<cfif len(arguments.orderResponsible)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.orderResponsible#"><cfelse>NULL</cfif>,
				<cfif len(arguments.orderResponsibleId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderResponsibleId#"><cfelse>NULL</cfif>,
				<cfif len(arguments.responsible)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.responsible#"><cfelse>NULL</cfif>,
				<cfif len(arguments.responsibleId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.responsibleId#"><cfelse>NULL</cfif>,
				<cfif len(arguments.postDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.postDate#"><cfelse>NULL</cfif>,
				<cfif len(arguments.exitDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.exitDate#"><cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="updProductAcceptence" access="remote" returntype="any">
		<cfargument name="refinery_product_acceptence_id" default="" required="true">
		<cfargument name="despatchNumber" default="" required="false">
		<cfargument name="companyName" default="" required="false">
		<cfargument name="companyId" default="" required="false">
		<cfargument name="orderResponsible" default="" required="false">
		<cfargument name="orderResponsibleId" default="" required="false">
		<cfargument name="responsible" default="" required="false">
		<cfargument name="responsibleId" default="" required="false">
		<cfargument name="postDate" default="" required="false">
		<cfargument name="exitDate" default="" required="false">

		<cfquery name="updProductAcceptence" datasource="#dsn#">
			UPDATE REFINERY_PRODUCT_ACCEPTENCE
			SET
				DESPATCH_NUMBER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.despatchNumber#">,
				COMPANY_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.companyName#">,
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.companyId#">,
				ORDER_RESPONSIBLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.orderResponsible#">,
				ORDER_RESPONSIBLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.orderResponsibleId#">,
				RESPONSIBLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.responsible#">,
				RESPONSIBLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.responsibleId#">,
				ACCEPT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.postDate#">,
				EXIT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.exitDate#">,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
			WHERE
				REFINERY_PRODUCT_ACCEPTENCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_product_acceptence_id#">
		</cfquery>
	</cffunction>
	<cffunction name="getProductAcceptence" access="remote" returntype="any">
		<cfargument name = "refinery_product_acceptence_id" default="" required="false">
		<cfargument name = "keyword" default="" required="false">

		<cfquery name="getProductAcceptence" datasource="#DSN#">
			SELECT 
				*
			FROM 
				REFINERY_PRODUCT_ACCEPTENCE 
			WHERE 1 = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif isDefined("arguments.refinery_product_acceptence_id") and len(arguments.refinery_product_acceptence_id)>
					AND REFINERY_PRODUCT_ACCEPTENCE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_product_acceptence_id#">
				</cfif>
			ORDER BY
				EXIT_DATE DESC
		</cfquery>
		<cfreturn getProductAcceptence />
	</cffunction>
	<cffunction name="saveRegisterVisitor" access="remote" returntype="any">
		<cfargument name="visitorName" default="" required="false">
		<cfargument name="tcIdentityNumber" default="" required="false">
		<cfargument name="consumer_id" default="" required="false">
		<cfargument name="company_id" default="" required="false">
		<cfargument name="analyze_company_name" default="" required="false">
		<cfargument name="car_number" default="" required="false">
		<cfargument name="special_code" default="" required="false">
		<cfargument name="member_type" default="" required="false">
		<cfargument name="phoneNumber" default="" required="false">
		<cfargument name="emailAddress" default="" required="false">
		<cfargument name="employeeName" default="" required="false">
		<cfargument name="employeeId" default="" required="false">
		<cfargument name="visitTime" default="" required="false">
		<cfargument name="visitTime_exit" default="" required="false">
		<cfargument name="visitorCartnumber" default="" required="false">
		<cfargument name="visitorPurpose" default="" required="false">
		<cfargument name="note" default="" required="false">
		<cfargument name="isg_entry_time" default="" required="false">
		<cfargument name="isg_exit_time" default="" required="false">
		<cfargument name="process_stage" default="" required="false">

		<cfquery name="saveRegisterVisitor" datasource="#dsn#" result="result">
			INSERT INTO
				REFINERY_VISITOR_REGISTER
			(
				VISITOR_NAME,
				TC_IDENTITY_NUMBER,
				COMPANY_ID,
				CONSUMER_ID,
				MEMBER_TYPE,
				CAR_NUMBER,
				SPECIAL_CODE,
				PHONE_NUMBER,
				EMAIL_ADDRESS,
				EMPLOYEE_ID,
				--VISIT_TIME,
				--VISIT_TIME_EXIT,
				VISITOR_CART_NUMBER,
				VISITOR_PURPOSE,
				NOTE,
				ISG_ENTRY_TIME,
				ISG_EXIT_TIME,
				PROCESS_STAGE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				OUR_COMPANY_ID
			)
			VALUES
			(
				<cfif len(arguments.visitorName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.visitorName#"><cfelse>NULL</cfif>,
				<cfif len(arguments.tcIdentityNumber)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tcIdentityNumber#"><cfelse>NULL</cfif>,
				<cfif len(arguments.company_id) and len(arguments.analyze_company_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.consumer_id) and len(arguments.analyze_company_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.member_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.member_type#"><cfelse>NULL</cfif>,
				<cfif len(arguments.car_number)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.car_number#"><cfelse>NULL</cfif>,
				<cfif len(arguments.special_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.special_code#"><cfelse>NULL</cfif>,
				<cfif len(arguments.phoneNumber)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.phoneNumber#"><cfelse>NULL</cfif>,
				<cfif len(arguments.emailAddress)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailAddress#"><cfelse>NULL</cfif>,
				<cfif len(arguments.employeeId) and len(arguments.employeeName)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employeeId#"><cfelse>NULL</cfif>,
				--<cfif len(arguments.visitTime)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.visitTime#"><cfelse>NULL</cfif>,
				--<cfif len(arguments.visitTime_exit)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.visitTime_exit#"><cfelse>NULL</cfif>,
				<cfif len(arguments.visitorCartnumber)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.visitorCartnumber#"><cfelse>NULL</cfif>,
				<cfif len(arguments.visitorPurpose)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.visitorPurpose#"><cfelse>NULL</cfif>,
				<cfif len(arguments.note)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.note#"><cfelse>NULL</cfif>,
				<cfif len(arguments.isg_entry_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.isg_entry_time#"><cfelse>NULL</cfif>,
				<cfif len(arguments.isg_exit_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.isg_exit_time#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="getRegisterVisitor" access="remote" returntype="any">
		<cfargument name = "refinery_visitor_register_id" default="" required="false">
		<cfargument name = "keyword" default="" required="false">
		<cfargument name = "process_stage" default="" required="false">
		<cfargument name = "start_date" default="" required="true">
		<cfargument name = "finish_date" default="" required="true">

		<cfif not len(arguments.process_stage)>
			<cfset Cmp = createObject("component","CustomTags.cfc.get_workcube_process") />
			<cfset Cmp.data_source = dsn />
			<cfset Cmp.process_db = "#dsn#." />
			<cfset Cmp.module_type = "e" />
			<cfset Cmp.my_our_company_id_ = session.ep.company_id />
			<cfset Cmp.lang = session.ep.language />

			<cfset get_ProcessType = Cmp.get_ProcessType(
				our_company_id	: session.ep.company_id,
				fuseaction		: "recycle.visitors"
				) />

			<cfset get_Faction = Cmp.get_Faction(
				extra_process_row_id: "-1",
				fuseaction			: "recycle.visitors",
				position_code		: session.ep.position_code,
				pathinfo 			: "#request.self#?fuseaction=recycle.visitors"
			) />
			<cfset arguments.process_stage = valueList(get_Faction.PROCESS_ROW_ID) />
		</cfif>

		<cfquery name="getRegisterVisitor" datasource="#DSN#">
			SELECT 
				REFI.*,
				CONI.CONSUMER_NAME,
				CONI.CONSUMER_SURNAME,
				COMI.FULLNAME,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME
			FROM 
				REFINERY_VISITOR_REGISTER AS REFI
			JOIN PROCESS_TYPE_ROWS AS PTR ON REFI.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			LEFT JOIN CONSUMER AS CONI ON REFI.CONSUMER_ID = CONI.CONSUMER_ID
			LEFT JOIN COMPANY AS COMI ON REFI.COMPANY_ID = COMI.COMPANY_ID
			JOIN EMPLOYEES AS EMP ON REFI.EMPLOYEE_ID = EMP.EMPLOYEE_ID
			WHERE 1 = 1 AND REFI.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			<cfif isDefined("arguments.refinery_visitor_register_id") and len(arguments.refinery_visitor_register_id)>
				AND REFI.REFINERY_VISITOR_REGISTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_visitor_register_id#">
			</cfif>
			<cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
				AND REFI.PROCESS_STAGE IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#" list="yes">)
			</cfif>
			<cfif isDefined("arguments.refinery_visitor_register_id") and len(arguments.refinery_visitor_register_id)>
				AND REFI.REFINERY_VISITOR_REGISTER_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.refinery_visitor_register_id#">
			</cfif>
			<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
				AND (
					CONI.CONSUMER_NAME + ' ' + CONI.CONSUMER_SURNAME LIKE '%#arguments.keyword#%'
					OR COMI.FULLNAME LIKE '%#arguments.keyword#%'
					OR REFI.VISITOR_NAME LIKE '%#arguments.keyword#%'
					OR REFI.TC_IDENTITY_NUMBER LIKE '%#arguments.keyword#%'
					OR REFI.CAR_NUMBER LIKE '%#arguments.keyword#%'
				)
			</cfif>
			<cfif isDefined("arguments.start_date") and len(arguments.start_date)>
				AND (REFI.VISIT_TIME >= #arguments.start_date# OR REFI.VISIT_TIME IS NULL)
			</cfif>
			<cfif isDefined("arguments.finish_date") and len(arguments.finish_date)>
				AND (REFI.VISIT_TIME <= #arguments.finish_date# OR REFI.VISIT_TIME IS NULL)
			</cfif>
			ORDER BY
				REFI.VISIT_TIME DESC
		</cfquery>
		<cfreturn getRegisterVisitor />
	</cffunction>
	<cffunction name="updRegisterVisitor" access="remote" returntype="any">
		<cfargument name="refinery_visitor_register_id" default="" required="true">
		<cfargument name="visitorName" default="" required="false">
		<cfargument name="tcIdentityNumber" default="" required="false">
		<cfargument name="consumer_id" default="" required="false">
		<cfargument name="company_id" default="" required="false">
		<cfargument name="analyze_company_name" default="" required="false">
		<cfargument name="member_type" default="" required="false">
		<cfargument name="car_number" default="" required="false">
		<cfargument name="special_code" default="" required="false">
		<cfargument name="phoneNumber" default="" required="false">
		<cfargument name="emailAddress" default="" required="false">
		<cfargument name="employeeName" default="" required="false">
		<cfargument name="employeeId" default="" required="false">
		<cfargument name="visitTime" default="" required="false">
		<cfargument name="visitTime_exit" default="" required="false">
		<cfargument name="visitorCartnumber" default="" required="false">
		<cfargument name="visitorPurpose" default="" required="false">
		<cfargument name="note" default="" required="false">
		<cfargument name="isg_entry_time" default="" required="false">
		<cfargument name="isg_exit_time" default="" required="false">
		<cfargument name="process_stage" default="" required="false">

		<cfquery name="updRegisterVisitor" datasource="#dsn#">
			UPDATE REFINERY_VISITOR_REGISTER
			SET
				VISITOR_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.visitorName#">,
				TC_IDENTITY_NUMBER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.tcIdentityNumber#">,
				CONSUMER_ID = <cfif len(arguments.consumer_id) AND len(arguments.analyze_company_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
				COMPANY_ID = <cfif len(arguments.company_id) AND len(arguments.analyze_company_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
				MEMBER_TYPE = <cfif len(arguments.member_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.member_type#"><cfelse>NULL</cfif>,
				CAR_NUMBER = <cfif len(arguments.car_number)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.car_number#"><cfelse>NULL</cfif>,
				SPECIAL_CODE = <cfif len(arguments.special_code)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.special_code#"><cfelse>NULL</cfif>,
				PHONE_NUMBER = <cfif len(arguments.phoneNumber)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.phoneNumber#"><cfelse>NULL</cfif>,
				EMAIL_ADDRESS = <cfif len(arguments.emailAddress)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.emailAddress#"><cfelse>NULL</cfif>,
				EMPLOYEE_ID = <cfif len(arguments.employeeId) AND len(arguments.employeeName)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employeeId#"><cfelse>NULL</cfif>,
				--VISIT_TIME = <cfif len(arguments.visitTime)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.visitTime#"><cfelse>NULL</cfif>,
				--VISIT_TIME_EXIT = <cfif len(arguments.visitTime_exit)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.visitTime_exit#"><cfelse>NULL</cfif>,
				VISITOR_CART_NUMBER = <cfif len(arguments.visitorCartnumber)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.visitorCartnumber#"><cfelse>NULL</cfif>,
				VISITOR_PURPOSE = <cfif len(arguments.visitorPurpose)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.visitorPurpose#"><cfelse>NULL</cfif>,
				NOTE = <cfif len(arguments.note)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.note#"><cfelse>NULL</cfif>,
				ISG_ENTRY_TIME = <cfif len(arguments.isg_entry_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.isg_entry_time#"><cfelse>NULL</cfif>,
				ISG_EXIT_TIME = <cfif len(arguments.isg_exit_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.isg_exit_time#"><cfelse>NULL</cfif>,
				PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
			WHERE 
				REFINERY_VISITOR_REGISTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_visitor_register_id#">
		</cfquery>
	</cffunction>
	<cffunction name="saveProductOff" access="remote" returntype="any">
		<cfargument name="carNumber" default="" required="false">
		<cfargument name="despatchNumber" default="" required="false">
		<cfargument name="productName" default="" required="false">
		<cfargument name="buyerCompanyName" default="" required="false">
		<cfargument name="buyerCompanyId" default="" required="false">
		<cfargument name="buyerResponsible" default="" required="false">
		<cfargument name="exitDate" default="" required="false">

		<cfquery name="saveProductOff" datasource="#dsn#" result="result">
			INSERT INTO
				REFINERY_PRODUCT_OFF
			(
				CAR_NUMBER,
				DESPATCH_NUMBER,
				PRODUCT_NAME,
				BUYER_COMPANY,
				BUYER_COMPANY_ID,
				RESPONSIBLE,
				EXIT_DATE,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				OUR_COMPANY_ID
			)
			VALUES
			(
				<cfif len(arguments.carNumber)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carNumber#"><cfelse>NULL</cfif>,
				<cfif len(arguments.despatchNumber)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.despatchNumber#"><cfelse>NULL</cfif>,
				<cfif len(arguments.productName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productName#"><cfelse>NULL</cfif>,
				<cfif len(arguments.buyerCompanyName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.buyerCompanyName#"><cfelse>NULL</cfif>,
				<cfif len(arguments.buyerCompanyId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.buyerCompanyId#"><cfelse>NULL</cfif>,
				<cfif len(arguments.buyerResponsible)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.buyerResponsible#"><cfelse>NULL</cfif>,
				<cfif len(arguments.exitDate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.exitDate#"><cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="updProductoff" access="remote" returntype="any">
		<cfargument name="refinery_product_off_id" default="" required="true">
		<cfargument name="carNumber" default="" required="false">
		<cfargument name="despatchNumber" default="" required="false">
		<cfargument name="productName" default="" required="false">
		<cfargument name="buyerCompanyName" default="" required="false">
		<cfargument name="buyerResponsible" default="" required="false">
		<cfargument name="exitDate" default="" required="false">

		<cfquery name="updProductoff" datasource="#dsn#">
			UPDATE REFINERY_PRODUCT_OFF
			SET
				CAR_NUMBER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.carNumber#">,
				DESPATCH_NUMBER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.despatchNumber#">,
				PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.productName#">,
				BUYER_COMPANY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.buyerCompanyName#">,
				RESPONSIBLE = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.buyerResponsible#">,
				EXIT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.exitDate#">,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
			WHERE 
				REFINERY_PRODUCT_OFF_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_product_off_id#">
		</cfquery>
	</cffunction>
	<cffunction name="getProductOff" access="remote" returntype="any">
		<cfargument name = "refinery_product_off_id" default="" required="false">
		<cfargument name = "keyword" default="" required="false">

		<cfquery name="getProductOff" datasource="#DSN#">
			SELECT 
				*
			FROM 
				REFINERY_PRODUCT_OFF 
			WHERE 1 = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif isDefined("arguments.refinery_product_off_id") and len(arguments.refinery_product_off_id)>
					AND REFINERY_PRODUCT_OFF_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.refinery_product_off_id#">
				</cfif>
			ORDER BY
				EXIT_DATE DESC
		</cfquery>
		<cfreturn getProductOff />
	</cffunction>
	<cffunction name="getWasteOil" access="public" returntype="any">
		<cfargument name = "refinery_waste_oil_id" default="" required="false">
		<cfargument name = "keyword" default="" required="false">
		<cfargument name = "consumer_id" default="" required="false">
		<cfargument name = "company_id" default="" required="false">
		<cfargument name = "member_name" default="" required="false">
		<cfargument name = "process_stage" default="" required="false">
		<cfargument name = "is_exit_date_null" default="0" required="false">
		<cfargument name = "is_analyzeLab" default="0" required="false">
		<cfargument name = "analyzeLabId" default="" required="false">
		
		<cfquery name="getWasteOil" datasource="#dsn2#">
			SELECT 
				REF.REFINERY_WASTE_OIL_ID,
				REF.CAR_NUMBER,
				REF.DORSE_PLAKA,
				REF.BO_NUMBER,
				REF.CAR_ENTRY_TIME,
				REF.CAR_ENTRY_KG,
				REF.CAR_EXIT_TIME,
				REF.CAR_EXIT_KG,
				REF.CONSUMER_ID,
				REF.COMPANY_ID,
				REF.MEMBER_TYPE,
				REF.CARRIER_CONSUMER_ID,
				REF.CARRIER_COMPANY_ID,
				REF.CARRIER_MEMBER_TYPE,
				REF.DRIVER_PARTNER_ID,
				REF.DRIVER_YRD_PARTNER_ID,
				REF.PROCESS_STAGE,
				REF.GENERAL_PAPER_NO,
				REF.PRODUCT_ID,
				REF.STOCK_ID AS PRODUCT_STOCK_ID,
				REF.PRODUCT_MAIN_UNIT_ID,
				REF.PROPERTY_ID,
				REF.BRANCH_ID,
				REF.DEPARTMENT_ID,
				REF.LOCATION_ID,
				CON.CONSUMER_NAME,
				CON.CONSUMER_SURNAME,
				COM.FULLNAME,
				CON_CARRIER.CONSUMER_NAME AS CARRIER_CONSUMER_NAME,
				CON_CARRIER.CONSUMER_SURNAME AS CARRIER_CONSUMER_SURNAME,
				COM_CARRIER.FULLNAME AS CARRIER_FULLNAME,
				COMP.COMPANY_PARTNER_NAME,
				COMP.COMPANY_PARTNER_SURNAME,
				COMP_HELPER.COMPANY_PARTNER_NAME AS HELPER_COMPANY_PARTNER_NAME,
				COMP_HELPER.COMPANY_PARTNER_SURNAME AS HELPER_COMPANY_PARTNER_SURNAME,
				#dsn#.#dsn#.Get_Dynamic_Language(PROCESS_ROW_ID,'#ucase(session.ep.language)#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,
				PROD.PRODUCT_NAME,
				PROD.PRODUCT_CODE,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				PROD.BARCOD,
				STCK.STOCK_ID,
				STCK.STOCK_CODE,
				STCK.STOCK_CODE_2,
				REF.RECORD_EMP,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				REF.SHIP_ID,
				SU.UNIT
			FROM 
				#dsn#.REFINERY_WASTE_OIL AS REF
			JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON REF.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			JOIN #dsn#.EMPLOYEES AS EMP ON REF.RECORD_EMP = EMP.EMPLOYEE_ID
			LEFT JOIN #dsn#.CONSUMER AS CON ON REF.CONSUMER_ID = CON.CONSUMER_ID
			LEFT JOIN #dsn#.COMPANY AS COM ON REF.COMPANY_ID = COM.COMPANY_ID
			LEFT JOIN #dsn#.CONSUMER AS CON_CARRIER ON REF.CARRIER_CONSUMER_ID = CON_CARRIER.CONSUMER_ID
			LEFT JOIN #dsn#.COMPANY AS COM_CARRIER ON REF.CARRIER_COMPANY_ID = COM_CARRIER.COMPANY_ID
			LEFT JOIN #dsn#.COMPANY_PARTNER AS COMP ON REF.DRIVER_PARTNER_ID = COMP.PARTNER_ID 
			LEFT JOIN #dsn#.COMPANY_PARTNER AS COMP_HELPER ON REF.DRIVER_YRD_PARTNER_ID = COMP_HELPER.PARTNER_ID
			LEFT JOIN #dsn#_product.PRODUCT AS PROD ON REF.PRODUCT_ID = PROD.PRODUCT_ID
			LEFT JOIN #dsn#_product.STOCKS AS STCK ON REF.STOCK_ID = STCK.STOCK_ID
			LEFT JOIN #dsn#.SETUP_UNIT AS SU ON SU.UNIT_ID = REF.PRODUCT_MAIN_UNIT_ID
			WHERE 1 = 1 AND REF.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			<cfif isDefined("arguments.refinery_waste_oil_id") and len(arguments.refinery_waste_oil_id)>
				AND REF.REFINERY_WASTE_OIL_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.refinery_waste_oil_id#">
			</cfif>
			<cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
				AND REF.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
			</cfif>
			<cfif isDefined("arguments.consumer_id") and len(arguments.consumer_id) and isDefined("arguments.member_name") and len(arguments.member_name)>
				AND REF.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
			</cfif>
			<cfif isDefined("arguments.company_id") and len(arguments.company_id) and isDefined("arguments.member_name") and len(arguments.member_name)>
				AND REF.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
			</cfif>
			<cfif isDefined("arguments.is_exit_date_null") and arguments.is_exit_date_null eq 1>
				AND REF.CAR_EXIT_TIME IS NULL
			</cfif>
			<cfif isDefined("arguments.is_analyzeLab") and arguments.is_analyzeLab eq 1>
				AND REF.REFINERY_WASTE_OIL_ID NOT IN (SELECT DISTINCT REFINERY_WASTE_OIL_ID FROM #dsn#.REFINERY_LAB_TESTS WHERE REFINERY_WASTE_OIL_ID IS NOT NULL <cfif isDefined("arguments.analyzeLabId") and len(arguments.analyzeLabId)>AND REFINERY_LAB_TEST_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analyzeLabId#"></cfif>)
			</cfif>
			<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
				AND 
					(
						REF.CAR_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%">
					)
			</cfif>
		</cfquery>
		<cfreturn getWasteOil />
	</cffunction>
	<cffunction name="getWasteOilRow" access="public" returntype="any">
		<cfargument name = "refinery_waste_oil_id" default="" required="false">
		<cfargument name = "refinery_waste_oil_row_id" default="" required="false">
		
		<cfquery name="getWasteOilRow" datasource="#dsn2#">
			SELECT REFR.*, ASSET.ASSET_FILE_NAME, ASSET.ASSET_NAME, ASSET.ASSET_FILE_REAL_NAME, ASSET.ASSETCAT_ID, ASSET_CAT.ASSETCAT_PATH
			FROM #dsn#.REFINERY_WASTE_OIL_ROW AS REFR
			LEFT JOIN #dsn#.ASSET ON REFR.ASSET_ID = ASSET.ASSET_ID
			LEFT JOIN #dsn#.ASSET_CAT ON ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
			WHERE
				1 = 1 
				<cfif len( arguments.refinery_waste_oil_id )>AND REFR.REFINERY_WASTE_OIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_waste_oil_id#"> </cfif>
				<cfif len( arguments.refinery_waste_oil_row_id )>AND REFR.REFINERY_WASTE_OIL_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_waste_oil_row_id#"> </cfif>
			ORDER BY REFINERY_WASTE_OIL_ROW_NUMBER
		</cfquery>
		<cfreturn getWasteOilRow />
	</cffunction>
	<cffunction name="getWasteOilRowDocs" access="public" returntype="any">
		<cfargument name = "row_number" default="" required="false">
		<cfargument name = "member_type" default="" required="false">
		<cfargument name = "member_id" default="" required="false">
		<cfargument name = "dorse_plaka" default="" required="false">
		<cfargument name = "driver_id" default="" required="false">
		
		<cfquery name="getWasteOilRowDocs" datasource="#dsn2#">
			SELECT TOP 1 REFR.*, ASSET.ASSET_FILE_NAME, ASSET.ASSET_NAME, ASSET.ASSET_FILE_REAL_NAME, ASSET.ASSETCAT_ID, ASSET_CAT.ASSETCAT_PATH
			FROM #dsn#.REFINERY_WASTE_OIL_ROW AS REFR
			JOIN #dsn#.REFINERY_WASTE_OIL AS REF ON REFR.REFINERY_WASTE_OIL_ID = REF.REFINERY_WASTE_OIL_ID
			LEFT JOIN #dsn#.ASSET ON REFR.ASSET_ID = ASSET.ASSET_ID
			LEFT JOIN #dsn#.ASSET_CAT ON ASSET.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID
			WHERE
				REFR.ASSET_ID IS NOT NULL 
				<cfif len( arguments.row_number )> AND REFR.REFINERY_WASTE_OIL_ROW_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_number#"></cfif>
				<cfif len( arguments.member_type ) and arguments.member_type eq 'partner'>
					AND REF.CARRIER_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
				<cfelseif len(arguments.member_type) and arguments.member_type eq 'consumer'>
					AND REF.CARRIER_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_id#">
				</cfif>
				<cfif len( arguments.dorse_plaka )> AND REF.DORSE_PLAKA = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.dorse_plaka#"></cfif>
				<cfif len( arguments.driver_id )> AND REF.DRIVER_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_id#"></cfif>
			ORDER BY REFR.UPDATE_DATE DESC, REFR.RECORD_DATE DESC
		</cfquery>
		<cfreturn getWasteOilRowDocs />
	</cffunction>
	<cffunction name="getDrivers" access="public" returntype="any">
		<cfargument name = "company_id" default="" required="false">
		
		<cfquery name="getDrivers" datasource="#dsn#">
			SELECT PARTNER_ID, COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME
			FROM COMPANY_PARTNER
			WHERE
				COMPANY_PARTNER_STATUS = 1
				<cfif len( arguments.company_id )>AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> </cfif>
		</cfquery>
		<cfreturn getDrivers />
	</cffunction>
	<cffunction name="delWastOilRow" access="public" returntype="any">
		<cfargument name = "refinery_waste_oil_row_id" default="" required="false">
		
		<cfquery name="delWastOilRow" datasource="#dsn2#">
			DELETE FROM #dsn#.REFINERY_WASTE_OIL_ROW WHERE REFINERY_WASTE_OIL_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_waste_oil_row_id#">
		</cfquery>
	</cffunction>
	<cffunction name="getWasteOil_weighbridge" returnType="any" access="remote" returnformat="JSON">
		<cfargument name="plaka" required="true">
		<!---
		<cfquery name="getWeighBridge" datasource="#dsn#_kantar">
			SELECT
			(SELECT TOP 1 ISNULL(CONVERT(INT,Tartim1),0) FROM dbo.Tartim1 WHERE Plaka = <cfqueryparam value = "#arguments.plaka#" cfsqltype="cf_sql_nvarchar"> ORDER BY Tarih1 DESC, Saat1 DESC) AS TARTIM1,
			(SELECT TOP 1 ISNULL(CONVERT(INT,Tartim2),0) FROM dbo.Tartim2 WHERE Plaka = <cfqueryparam value = "#arguments.plaka#" cfsqltype="cf_sql_nvarchar"> ORDER BY Tarih2 DESC, Saat2 DESC) AS TARTIM2
		</cfquery>
		--->
		<cfquery name="getWeighBridge" datasource="#dsn#_kantar">
			SELECT TOP 1 ISNULL(CONVERT(INT,Tartim1),0) AS TARTIM1, ISNULL(CONVERT(INT,Tartim2),0) AS TARTIM2 FROM dbo.Tartim2 
			WHERE Plaka = <cfqueryparam value = "#arguments.plaka#" cfsqltype="cf_sql_nvarchar">
			ORDER BY No DESC
		</cfquery>
	

		<cfreturn Replace(SerializeJson( { tartim_1: getWeighBridge.TARTIM1, tartim_2: getWeighBridge.TARTIM2 } ), "//", "") />
	</cffunction>
	<cffunction name="saveWasteOil" access="public" returntype="any">
		<cfargument name="process_stage" required="true">
		<cfargument name="general_paper_no" required="true">
		<cfargument name="carNumber" required="true">
		<cfargument name="consumer_id" default="" required="false">
		<cfargument name="company_id" default="" required="false">
		<cfargument name="member_name" default="" required="false">
		<cfargument name="member_type" default="" required="false">
		<cfargument name="dorse_plaka" default="" required="true">
		<cfargument name="bo_number" default="" required="true">
		<cfargument name="driver_id" default="" required="false">
		<cfargument name="yrd_driver_id" default="" required="false">
		<cfargument name="car_entry_time" default="" required="false">
		<cfargument name="car_entry_kg" default="" required="false">
		<cfargument name="car_exit_time" default="" required="false">
		<cfargument name="car_exit_kg" default="" required="false">
		<cfargument name="car_entry_hour" default="" required="false">
		<cfargument name="car_entry_minute" default="" required="false">
		<cfargument name="car_exit_hour" default="" required="false">
		<cfargument name="car_exit_minute" default="" required="false">
		<cfargument name="product_id" default="" required="false">
		<cfargument name="product_name" default="" required="false">
		<cfargument name="property_id" default="" required="false">
		<cfargument name="branch_id" default="" required="false">
		<cfargument name="department_id" default="" required="false">
		<cfargument name="location_id" default="" required="false">
		<cfargument name="department_name" default="" required="false">
		<cfargument name="carrier_consumer_id" default="" required="false">
		<cfargument name="carrier_company_id" default="" required="false">
		<cfargument name="carrier_member_name" default="" required="false">
		<cfargument name="carrier_member_type" default="" required="false">
		<cfargument name="stock_id" default="" required="false">
		<cfargument name="main_unit_id" default="" required="false">

		<cfquery name="saveWasteOil" datasource="#dsn2#" result="result">
			INSERT INTO
			#dsn#.REFINERY_WASTE_OIL
			(
				CAR_NUMBER,
				CONSUMER_ID,
				COMPANY_ID,
				MEMBER_TYPE,
				CARRIER_CONSUMER_ID,
				CARRIER_COMPANY_ID,
				CARRIER_MEMBER_TYPE,
				DORSE_PLAKA,
				BO_NUMBER,
				DRIVER_PARTNER_ID,
				DRIVER_YRD_PARTNER_ID,
				CAR_ENTRY_KG,
				CAR_EXIT_KG,
				PROCESS_STAGE,
				GENERAL_PAPER_NO,
				PRODUCT_ID,
				PROPERTY_ID,
				BRANCH_ID,
				DEPARTMENT_ID,
				LOCATION_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				STOCK_ID,
				PRODUCT_MAIN_UNIT_ID,
				OUR_COMPANY_ID
			)
			VALUES
			(
				<cfif len(arguments.carNumber)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.carNumber#"><cfelse>NULL</cfif>,
				<cfif len(arguments.consumer_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.company_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.member_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.member_type#"><cfelse>NULL</cfif>,
				<cfif len(arguments.carrier_consumer_id) AND len(arguments.carrier_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrier_consumer_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.carrier_company_id) AND len(arguments.carrier_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrier_company_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.carrier_member_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.carrier_member_type#"><cfelse>NULL</cfif>,
				<cfif len(arguments.dorse_plaka)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.dorse_plaka#"><cfelse>NULL</cfif>,
				<cfif len(arguments.bo_number)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.bo_number#"><cfelse>NULL</cfif>,
				<cfif len(arguments.driver_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_partner_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.driver_yrd_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_yrd_partner_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.car_entry_kg)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.car_entry_kg#"><cfelse>NULL</cfif>,
				<cfif len(arguments.car_exit_kg)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.car_exit_kg#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.general_paper_no#">,
				<cfif len(arguments.product_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.property_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.property_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.branch_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.department_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.location_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#"><cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfif len(arguments.stock_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.main_unit_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_unit_id#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
 	<cffunction name="updWasteOil" access="public" returntype="any">
		<cfargument name="refinery_waste_oil_id" default="" required="true">
		<cfargument name="process_stage" required="true">
		<cfargument name="general_paper_no" required="true">
		<cfargument name="carNumber" default="" required="false">
		<cfargument name="consumer_id" default="" required="false">
		<cfargument name="company_id" default="" required="false">
		<cfargument name="member_name" default="" required="false">
		<cfargument name="member_type" default="" required="false">
		<cfargument name="dorse_plaka" default="" required="false">
		<cfargument name="bo_number" default="" required="false">
		<cfargument name="driver_partner_id" default="" required="false">
		<cfargument name="driver_yrd_partner_id" default="" required="false">
		<cfargument name="car_entry_time" default="" required="false">
		<cfargument name="car_entry_kg" default="" required="false">
		<cfargument name="car_exit_time" default="" required="false">
		<cfargument name="car_exit_kg" default="" required="false">
		<cfargument name="car_entry_hour" default="" required="false">
		<cfargument name="car_entry_minute" default="" required="false">
		<cfargument name="car_exit_hour" default="" required="false">
		<cfargument name="car_exit_minute" default="" required="false">
		<cfargument name="product_id" default="" required="false">
		<cfargument name="product_name" default="" required="false">
		<cfargument name="property_id" default="" required="false">
		<cfargument name="branch_id" default="" required="false">
		<cfargument name="department_id" default="" required="false">
		<cfargument name="location_id" default="" required="false">
		<cfargument name="department_name" default="" required="false">
		<cfargument name="carrier_consumer_id" default="" required="false">
		<cfargument name="carrier_company_id" default="" required="false">
		<cfargument name="carrier_member_name" default="" required="false">
		<cfargument name="carrier_member_type" default="" required="false">
		<cfargument name="stock_id" default="" required="false">
		<cfargument name="main_unit_id" default="" required="false">

		<cfquery name="updWasteOil" datasource="#dsn2#">
			UPDATE #dsn#.REFINERY_WASTE_OIL
			SET
				CAR_NUMBER = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.carNumber#">,
				CONSUMER_ID = <cfif len(arguments.consumer_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
				COMPANY_ID = <cfif len(arguments.company_id) AND len(arguments.member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
				MEMBER_TYPE = <cfif len(arguments.member_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.member_type#"><cfelse>NULL</cfif>,
				CARRIER_CONSUMER_ID = <cfif len(arguments.carrier_consumer_id) AND len(arguments.carrier_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrier_consumer_id#"><cfelse>NULL</cfif>,
				CARRIER_COMPANY_ID = <cfif len(arguments.carrier_company_id) AND len(arguments.carrier_member_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrier_company_id#"><cfelse>NULL</cfif>,
				CARRIER_MEMBER_TYPE = <cfif len(arguments.carrier_member_type)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.carrier_member_type#"><cfelse>NULL</cfif>,
				DORSE_PLAKA = <cfif len(arguments.dorse_plaka)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.dorse_plaka#"><cfelse>NULL</cfif>,
				BO_NUMBER = <cfif len(arguments.bo_number)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.bo_number#"><cfelse>NULL</cfif>,
				DRIVER_PARTNER_ID = <cfif len(arguments.driver_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_partner_id#"><cfelse>NULL</cfif>,
				DRIVER_YRD_PARTNER_ID = <cfif len(arguments.driver_yrd_partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_yrd_partner_id#"><cfelse>NULL</cfif>,
				CAR_ENTRY_KG = <cfif len(arguments.car_entry_kg)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.car_entry_kg#"><cfelse>NULL</cfif>,
				CAR_EXIT_KG = <cfif len(arguments.car_exit_kg)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.car_exit_kg#"><cfelse>NULL</cfif>,
				PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				GENERAL_PAPER_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.general_paper_no#">,
				PRODUCT_ID = <cfif len(arguments.product_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
				PROPERTY_ID = <cfif len(arguments.property_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.property_id#"><cfelse>NULL</cfif>,
				BRANCH_ID = <cfif len(arguments.branch_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
				DEPARTMENT_ID = <cfif len(arguments.department_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"><cfelse>NULL</cfif>,
				LOCATION_ID = <cfif len(arguments.location_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#"><cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				STOCK_ID = <cfif len(arguments.stock_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"><cfelse>NULL</cfif>,
				PRODUCT_MAIN_UNIT_ID = <cfif len(arguments.main_unit_id) and len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_unit_id#"><cfelse>NULL</cfif>
			WHERE 
				REFINERY_WASTE_OIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_waste_oil_id#">
		</cfquery>
	</cffunction>
	<cffunction name="getAsset" access="public" returntype="any">
		<cfargument name="asset_id" required="false">

		<cfquery name="getAsset" datasource="#dsn2#">
			SELECT #dsn#.ASSET_FILE_NAME, ASSET_NAME, ASSET_FILE_REAL_NAME FROM ASSET
			WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#">
		</cfquery>
		<cfreturn getAsset />
	</cffunction>
	<cffunction name="addAsset" access="public" returntype="any">
		<cfargument name="module_name" required="false">
		<cfargument name="module_id" required="false">
		<cfargument name="action_section" required="false">
		<cfargument name="action_id" required="false">
		<cfargument name="assetcat_id" required="false">
		<cfargument name="asset_file_name" required="true">
		<cfargument name="asset_file_size" required="true">
		<cfargument name="asset_file_server_id" default="1" required="false">
		<cfargument name="asset_name" default="" required="false">
		<cfargument name="asset_file_server_name" default="" required="false">
		<cfargument name="asset_file_real_name" default="" required="false">
		<cfargument name="property_id" default="" required="false">

		<cfset info = { company_id: session.ep.company_id, period_id: session.ep.period_id } />

		<cfquery name="addAsset" datasource="#dsn2#" result="result">
			INSERT INTO #dsn#.[ASSET]
			(
				[MODULE_NAME]
				,[MODULE_ID]
				,[ACTION_SECTION]
				,[ACTION_ID]
				,[ASSETCAT_ID]
				,[ASSET_FILE_NAME]
				,[ASSET_FILE_SIZE]
				,[ASSET_FILE_SERVER_ID]
				,[ASSET_FILE_FORMAT]
				,[ASSET_NAME]
				,[COMPANY_ID]
				,[RECORD_DATE]
				,[RECORD_EMP]
				,[RECORD_IP]
				,[SERVER_NAME]
				,[IS_LIVE]
				,[ASSET_FILE_REAL_NAME]
				,[PERIOD_ID]
				,[IS_ACTIVE]
				,[PROPERTY_ID]
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.module_name#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.module_id#">
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.action_section#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetcat_id#">
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_file_name#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_file_size#">
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_file_server_id#">
				,0
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_name#">
				,#info.company_id#
				,#now()#
				,#session.ep.userid#
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_file_server_name#">
				,0
				,<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_file_real_name#">
				,#info.period_id#
				,1
				,<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.property_id#">
			)
		</cfquery>

		<cfreturn result />

	</cffunction>
	<cffunction name="updAsset" access="public" returntype="any">
		<cfargument name="asset_id" required="false">
		<cfargument name="action_id" required="false">
		<cfargument name="asset_file_name" required="true">
		<cfargument name="asset_file_size" required="true">
		<cfargument name="asset_name" default="" required="false">
		<cfargument name="asset_file_real_name" default="" required="false">
		<cfargument name="property_id" default="" required="false">

		<cfset info = { company_id: session.ep.company_id, period_id: session.ep.period_id } />

		<cfquery datasource="#dsn2#" result="result">
			UPDATE #dsn#.ASSET 
			SET
				[ACTION_ID] = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.action_id#">,
				[ASSET_FILE_NAME] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_file_name#">,
				[ASSET_FILE_SIZE] = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_file_size#">,
				[ASSET_NAME] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_name#">,
				[UPDATE_DATE] = #now()#,
				[UPDATE_EMP] = #session.ep.userid#,
				[UPDATE_IP] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				[ASSET_FILE_REAL_NAME] = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.asset_file_real_name#">,
				[PROPERTY_ID] = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.property_id#">
			WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#">
		</cfquery>

		<cfreturn result />

	</cffunction>
	<cffunction name="delAsset" access="public" returntype="any">
		<cfargument name="asset_id" required="false">

		<cfquery datasource="#dsn2#">
			DELETE FROM #dsn#.ASSET WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#">
		</cfquery>
	</cffunction>

	
	<cffunction name="getSamplingPoints" access="public" returntype="any">
		<cfargument name = "sampling_id" default="" required="false">

		<cfquery name="getSamplingPoints" datasource="#DSN#">
			SELECT * FROM SAMPLING_POINTS
			WHERE 
				1 = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif isDefined("arguments.sampling_id") and len(arguments.sampling_id)>
					AND SAMPLING_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sampling_id#">
				</cfif>
		</cfquery>
		<cfreturn getSamplingPoints />
	</cffunction>
	<cffunction name="addSamplingPoints" access="public" returntype="any">
		<cfargument name="sampling_points_name" required="false">

		<cfquery name="addSamplingPoints" datasource="#dsn#" result="result">
			INSERT INTO
				SAMPLING_POINTS
			(
				SAMPLING_POINTS_NAME,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				OUR_COMPANY_ID
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sampling_points_name#">,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="updSamplingPoints" access="public" returntype="any">
		<cfargument name="sampling_id" default="" required="true">
		<cfargument name="sampling_points_name" default="" required="false">

		<cfquery name="updSamplingPoints" datasource="#dsn#">
			UPDATE SAMPLING_POINTS
			SET
				SAMPLING_POINTS_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sampling_points_name#">,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
			WHERE 
				SAMPLING_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sampling_id#">
		</cfquery>
	</cffunction>
	<cffunction name="GetAnalysisOperations" access="public" returntype="any">
		<cfargument name = "sample_points_id" default="" required="false">

		<cfquery name="GetAnalysisOperations" datasource="#DSN#">
			SELECT * FROM SAMPLE_POINTS AS SP 
			JOIN SAMPLING_POINTS AS SGP ON SP.SAMPLING_ID = SGP.SAMPLING_ID AND SGP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			WHERE
				SP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif isDefined("arguments.sample_points_id") and len(arguments.sample_points_id)>
					AND SP.SAMPLE_POINTS_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sample_points_id#">
				</cfif>
		</cfquery>
		<cfreturn GetAnalysisOperations />
	</cffunction>
	<cffunction name="addAnalysisOperations" access="public" returntype="any">
		<cfargument name="sampling_id" required="false">
		<cfargument name="sample_points_date_entry" required="false">
		<cfargument name="period" required="false">
		<cfargument name="sample_points_reason" required="false">

		<cfquery name="addAnalysisOperations" datasource="#dsn#" result="result">
			INSERT INTO
				SAMPLE_POINTS
			(
				SAMPLING_ID,
				SAMPLE_POINTS_DATE_ENTRY,
				PERIOD,
				SAMPLE_POINTS_REASON,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				OUR_COMPANY_ID
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sampling_id#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sample_points_date_entry#">,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.period#">,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sample_points_reason#">,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="updAnalysisOperations" access="public" returntype="any">
		<cfargument name="sample_points_id" default="" required="true">
		<cfargument name="sampling_id" default="" required="false">
		<cfargument name="sample_points_date_entry" default="" required="false">
		<cfargument name="period" default="" required="false">
		<cfargument name="sample_points_reason" default="" required="false">

		<cfquery name="updAnalysisOperations" datasource="#dsn#">
			UPDATE SAMPLE_POINTS
			SET
				SAMPLING_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sampling_id#">,
				SAMPLE_POINTS_DATE_ENTRY = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.sample_points_date_entry#">,
				PERIOD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.period#">,
				SAMPLE_POINTS_REASON = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.sample_points_reason#">,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
			WHERE 
				SAMPLE_POINTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sample_points_id#">
		</cfquery>
	</cffunction>

	<cffunction name="GetTransportOrders" access="public" returntype="any">
		<cfargument name = "refinery_transport_id" default="" required="true">
		<cfargument name = "process_stage" default="" required="true">
		<cfargument name = "keyword" default="" required="false">

		<cfquery name="GetTransportOrders" datasource="#dsn2#">
			SELECT 
				REF.REFINERY_TRANSPORT_ID,
				REF.ORDERING_EMPLOYEE_ID,
				REF.OPERATOR_EMPLOYEE_ID,
				EMP.EMPLOYEE_NAME AS ORDER_EMPLOYEE_NAME,
				EMP.EMPLOYEE_ID AS ORDER_EMPLOYEE_ID,
				EMP.EMPLOYEE_SURNAME AS ORDER_EMPLOYEE_SURNAME,
				EMP_OP.EMPLOYEE_NAME AS OPARATOR_EMPLOYEE_NAME,
				EMP_OP.EMPLOYEE_ID AS OPARATOR_EMPLOYEE_ID,
				EMP_OP.EMPLOYEE_SURNAME AS OPARATOR_EMPLOYEE_SURNAME,
				REF.PRODUCT_ID,
				REF.UNIT_PRODUCT_ID,
				REF.LOCATION_EXIT_ID,
				REF.DEPARTMENT_EXIT_ID,
				REF.BRANCH_EXIT_ID,
				REF.LOCATION_ENTRY_ID,
				REF.DEPARTMENT_ENTRY_ID,
				REF.BRANCH_ENTRY_ID,
				REF.UNIT,
				REF.AMOUNT,
				REF.PROCESS_STAGE,
				REF.UPDATE_DATE,
				REF.STOCK_RECEIPT_ID,
				PROD.PRODUCT_ID AS PR_PRODUCT_ID,
				PROD.PRODUCT_NAME AS PR_PRODUCT_NAME,
				PU.MAIN_UNIT,
				S.STOCK_ID,
				DP_E.DEPARTMENT_HEAD AS DPE_DEPARTMENT_HEAD,
				DP_X.DEPARTMENT_HEAD AS DPX_DEPARTMENT_HEAD,
				ST_E.COMMENT AS STE_COMMENT,
				ST_X.COMMENT AS STX_COMMENT
			FROM #dsn#.REFINERY_TRANSPORT_ORDERS AS REF
			JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON REF.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			JOIN #dsn#.EMPLOYEES AS EMP ON REF.ORDERING_EMPLOYEE_ID = EMP.EMPLOYEE_ID
			JOIN #dsn#.EMPLOYEES AS EMP_OP ON REF.OPERATOR_EMPLOYEE_ID = EMP_OP.EMPLOYEE_ID
			LEFT JOIN #dsn#_product.PRODUCT AS PROD ON REF.PRODUCT_ID = PROD.PRODUCT_ID
			LEFT JOIN #dsn#_product.PRODUCT_UNIT AS PU ON PU.PRODUCT_UNIT_ID = REF.UNIT_PRODUCT_ID
			LEFT JOIN #dsn#.STOCKS_LOCATION AS ST_E ON (REF.LOCATION_ENTRY_ID = ST_E.LOCATION_ID and REF.DEPARTMENT_ENTRY_ID = ST_E.DEPARTMENT_ID)
			LEFT JOIN #dsn#.DEPARTMENT AS DP_E ON REF.DEPARTMENT_ENTRY_ID = DP_E.DEPARTMENT_ID
			LEFT JOIN #dsn#.STOCKS_LOCATION AS ST_X ON (REF.LOCATION_EXIT_ID = ST_X.LOCATION_ID and REF.DEPARTMENT_EXIT_ID = ST_X.DEPARTMENT_ID)
			LEFT JOIN #dsn#.DEPARTMENT AS DP_X ON REF.DEPARTMENT_EXIT_ID = DP_X.DEPARTMENT_ID
			JOIN #dsn#_product.STOCKS AS S ON PROD.PRODUCT_ID = S.PRODUCT_ID
			WHERE
				1 = 1 AND REF.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif isDefined("arguments.refinery_transport_id") and len(arguments.refinery_transport_id)>
				AND REF.REFINERY_TRANSPORT_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.refinery_transport_id#">
				</cfif>
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
					AND 
					(
						REF.AMOUNT LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#arguments.keyword#%">
					)
				</cfif>
				<cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
						AND REF.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
				</cfif>
			ORDER BY REF.REFINERY_TRANSPORT_ID DESC
		</cfquery>
		<cfreturn GetTransportOrders />
	</cffunction>
	<cffunction name="saveTransportOrders" access="public" returntype="any">
		<cfargument name="process_stage" required="true">
		<cfargument name="transport_ordering_employee_id" required="false">
		<cfargument name="transport_ordering_name" required="false">
		<cfargument name="operator_employee_id" required="false">
		<cfargument name="operator_name" required="false">
		<cfargument name="department_exit_name" required="false">
		<cfargument name="location_exit_id" required="false">
		<cfargument name="department_exit_id" required="false">
		<cfargument name="branch_exit_id" required="false">
		<cfargument name="department_entry_name" required="false">
		<cfargument name="location_entry_id" required="false">
		<cfargument name="department_entry_id" required="false">
		<cfargument name="branch_entry_id" required="false">
		<cfargument name="product_id" required="false">
		<cfargument name="product_name" required="false">
		<cfargument name="unit_product_id" required="false">
		<cfargument name="unit_product_name" required="false">
		<cfargument name="transport_quantity" required="false">

		<cfquery name="saveTransportOrders" datasource="#dsn#" result="result">
			INSERT INTO
				REFINERY_TRANSPORT_ORDERS
			(
				PROCESS_STAGE,
				ORDERING_EMPLOYEE_ID,
				OPERATOR_EMPLOYEE_ID,
				LOCATION_EXIT_ID,
				DEPARTMENT_EXIT_ID,
				BRANCH_EXIT_ID,
				LOCATION_ENTRY_ID,
				DEPARTMENT_ENTRY_ID,
				BRANCH_ENTRY_ID,
				PRODUCT_ID,
				STOCK_ID,
				UNIT_PRODUCT_ID,
				UNIT,
				AMOUNT,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				OUR_COMPANY_ID
			)
			VALUES
			(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				<cfif len(arguments.transport_ordering_employee_id) AND len(arguments.transport_ordering_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.transport_ordering_employee_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.operator_employee_id) AND len(arguments.operator_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.operator_employee_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.location_exit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_exit_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.department_exit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_exit_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.branch_exit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_exit_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.location_entry_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_entry_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.department_entry_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_entry_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.branch_entry_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_entry_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.product_id) AND len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.stock_id) AND len(arguments.stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.unit_product_id) AND len(arguments.unit_product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit_product_id#"><cfelse>NULL</cfif>,
				<cfif len(arguments.unit_product_id) AND len(arguments.unit_product_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.unit_product_name#"><cfelse>NULL</cfif>,
				<cfif len(arguments.transport_quantity)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.transport_quantity#"><cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="updTransportOrders" access="public" returntype="any">
		<cfargument name="process_stage" required="true">
		<cfargument name="refinery_transport_id" default="" required="true">
		<cfargument name="transport_ordering_employee_id" required="false">
		<cfargument name="transport_ordering_name" required="false">
		<cfargument name="operator_employee_id" required="false">
		<cfargument name="operator_name" required="false">
		<cfargument name="department_exit_name" required="false">
		<cfargument name="location_exit_id" required="false">
		<cfargument name="department_exit_id" required="false">
		<cfargument name="branch_exit_id" required="false">
		<cfargument name="department_entry_name" required="false">
		<cfargument name="location_entry_id" required="false">
		<cfargument name="department_entry_id" required="false">
		<cfargument name="branch_entry_id" required="false">
		<cfargument name="product_id" required="false">
		<cfargument name="product_name" required="false">
		<cfargument name="unit_product_id" required="false">
		<cfargument name="unit_product_name" required="false">
		<cfargument name="transport_quantity" required="false">

		<cfquery name="updTransportOrders" datasource="#dsn2#">
			UPDATE #dsn#.REFINERY_TRANSPORT_ORDERS
			SET
				PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				ORDERING_EMPLOYEE_ID = <cfif len(arguments.transport_ordering_employee_id) AND len(arguments.transport_ordering_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.transport_ordering_employee_id#"><cfelse>NULL</cfif>,
				OPERATOR_EMPLOYEE_ID = <cfif len(arguments.operator_employee_id) AND len(arguments.operator_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.operator_employee_id#"><cfelse>NULL</cfif>,
				LOCATION_EXIT_ID = <cfif len(arguments.location_exit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_exit_id#"></cfif>,
				DEPARTMENT_EXIT_ID = <cfif len(arguments.department_exit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_exit_id#"><cfelse>NULL</cfif>,
				BRANCH_EXIT_ID = <cfif len(arguments.branch_exit_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_exit_id#"><cfelse>NULL</cfif>,
				LOCATION_ENTRY_ID = <cfif len(arguments.location_entry_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_entry_id#"><cfelse>NULL</cfif>,
				DEPARTMENT_ENTRY_ID = <cfif len(arguments.department_entry_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_entry_id#"><cfelse>NULL</cfif>,
				BRANCH_ENTRY_ID = <cfif len(arguments.branch_entry_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_entry_id#"><cfelse>NULL</cfif>,
				PRODUCT_ID = <cfif len(arguments.product_id) AND len(arguments.product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.product_id#"><cfelse>NULL</cfif>,
				STOCK_ID = <cfif len(arguments.stock_id) AND len(arguments.stock_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"><cfelse>NULL</cfif>,
				UNIT_PRODUCT_ID = <cfif len(arguments.unit_product_id) AND len(arguments.unit_product_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unit_product_id#"><cfelse>NULL</cfif>,
				UNIT = <cfif len(arguments.unit_product_id) AND len(arguments.unit_product_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.unit_product_name#"><cfelse>NULL</cfif>,
				AMOUNT = <cfif len(arguments.transport_quantity)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.transport_quantity#"><cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
			WHERE 
				REFINERY_TRANSPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_transport_id#">
		</cfquery>
	</cffunction>

	<cffunction name="GetWasteCollectionExpeditions" access="public" returntype="any">
		<cfargument name = "waste_collection_expeditions_id" default="" required="false">
		<cfargument name = "keyword" default="" required="false">
		<cfargument name = "process_stage" default="" required="false">

		<cfquery name="GetWasteCollectionExpeditions" datasource="#dsn#">
			SELECT
				REFI.WASTE_COLLECTION_EXPEDITIONS_ID,
				REFI.PROCESS_STAGE,
				REFI.ATS_NO,
				REFI.DRIVER_ID,
				REFI.YRD_DRIVER_ID,
				REFI.ASSETP_ID,
				REFI.ASSETP_DORSE_ID,
				REFI.EXPEDITION_ENTRY_TIME,
				REFI.EXPEDITION_EXIT_TIME,
				REFI.RECORD_EMP,
				REFI.RECORD_DATE,
				REFI.UPDATE_EMP,
				REFI.UPDATE_DATE,
				REFI.EXPEDITION_ENTRY_TIME,
				REFI.EXPEDITION_EXIT_TIME,
				EMP.EMPLOYEE_NAME AS DRIVER_EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME AS DRIVER_EMPLOYEE_SURNAME,
				EMP_YRD.EMPLOYEE_NAME AS YRD_EMPLOYEE_NAME,
				EMP_YRD.EMPLOYEE_SURNAME AS YRD_EMPLOYEE_SURNAME,
				ASS_CEKICI.ASSETP AS ASSETP_NAME,
				ASS_DORSE.ASSETP AS ASSETP_DORSE_NAME

			FROM 
				REFINERY_WASTE_COLLECTION AS REFI
			JOIN #dsn#.PROCESS_TYPE_ROWS AS PTR ON REFI.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			LEFT JOIN EMPLOYEES AS EMP ON REFI.DRIVER_ID = EMP.EMPLOYEE_ID
			LEFT JOIN EMPLOYEES AS EMP_YRD ON REFI.YRD_DRIVER_ID = EMP_YRD.EMPLOYEE_ID
			LEFT JOIN ASSET_P AS ASS_CEKICI ON REFI.ASSETP_ID = ASS_CEKICI.ASSETP_ID
			LEFT JOIN ASSET_P AS ASS_DORSE ON REFI.ASSETP_DORSE_ID = ASS_DORSE.ASSETP_ID
			WHERE
				1 = 1
				AND REFI.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				<cfif isDefined("arguments.waste_collection_expeditions_id") and len(arguments.waste_collection_expeditions_id)>
					AND REFI.WASTE_COLLECTION_EXPEDITIONS_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.waste_collection_expeditions_id#">
				</cfif>
				<cfif isDefined("arguments.process_stage") and len(arguments.process_stage)>
					AND REFI.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
				</cfif>
		</cfquery>
		<cfreturn GetWasteCollectionExpeditions />
	</cffunction>
	<cffunction name="saveWasteCollectionExpeditions" access="public" returntype="any">
		<cfargument name="process_stage" required="true">
		<cfargument name="ats_no" required="false">
		<cfargument name="driver_id" required="false">
		<cfargument name="driver_name" required="false">
		<cfargument name="driver_yrd_id" required="false">
		<cfargument name="driver_yrd_name" required="false">
		<cfargument name="assetp_id" required="false">
		<cfargument name="assetp_name" required="false">
		<cfargument name="assetp_dorse_id" required="false">
		<cfargument name="assetp_dorse_name" required="false">
		<cfargument name="expedition_entry_time" required="false">
		<cfargument name="expedition_exit_time" required="false">

		<cfquery name="saveWasteCollectionExpeditions" datasource="#dsn#" result="result">
			INSERT INTO
				REFINERY_WASTE_COLLECTION
				(
					PROCESS_STAGE,
					ATS_NO,
					DRIVER_ID,
					YRD_DRIVER_ID,
					ASSETP_ID,
					ASSETP_DORSE_ID,
					EXPEDITION_ENTRY_TIME,
					EXPEDITION_EXIT_TIME,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
					<cfif len(arguments.ats_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ats_no#"><cfelse>NULL</cfif>,
					<cfif len(arguments.driver_id) AND len(arguments.driver_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_id#"><cfelse>NULL</cfif>,
					<cfif len(arguments.driver_yrd_id) AND len(arguments.driver_yrd_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_yrd_id#"><cfelse>NULL</cfif>,
					<cfif len(arguments.assetp_id) AND len(arguments.assetp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_id#"><cfelse>NULL</cfif>,
					<cfif len(arguments.assetp_dorse_id) AND len(arguments.assetp_dorse_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_dorse_id#"><cfelse>NULL</cfif>,
					<cfif len(arguments.expedition_entry_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expedition_entry_time#"><cfelse>NULL</cfif>,
					<cfif len(arguments.expedition_exit_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expedition_exit_time#"><cfelse>NULL</cfif>,
					#session.ep.userid#,
					#now()#,
					<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
		</cfquery>
		<cfreturn result>
	</cffunction>
	<cffunction name="updWasteCollectionExpeditions" access="public" returntype="any">
		<cfargument name="waste_collection_expeditions_id" required="true">
		<cfargument name="process_stage" required="true">
		<cfargument name="ats_no" required="false">
		<cfargument name="driver_id" default="" required="false">
		<cfargument name="driver_name" default="" required="false">
		<cfargument name="driver_yrd_id" default="" required="false">
		<cfargument name="driver_yrd_name" default="" required="false">
		<cfargument name="assetp_id" default="" required="false">
		<cfargument name="assetp_name" default="" required="false">
		<cfargument name="assetp_dorse_id" default="" required="false">
		<cfargument name="assetp_dorse_name" default="" required="false">
		<cfargument name="expedition_entry_time" default="" required="false">
		<cfargument name="expedition_exit_time" default="" required="false">

		<cfquery name="updWasteCollectionExpeditions" datasource="#dsn#">
			UPDATE REFINERY_WASTE_COLLECTION
			SET
				PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
				ATS_NO = <cfif len(arguments.ats_no)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ats_no#"></cfif>,
				DRIVER_ID = <cfif len(arguments.driver_id) AND len(arguments.driver_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_id#"><cfelse>NULL</cfif>,
				YRD_DRIVER_ID = <cfif len(arguments.driver_yrd_id) AND len(arguments.driver_yrd_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.driver_yrd_id#"><cfelse>NULL</cfif>,
				ASSETP_ID = <cfif len(arguments.assetp_id) AND len(arguments.assetp_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_id#"><cfelse>NULL</cfif>,
				ASSETP_DORSE_ID = <cfif len(arguments.assetp_dorse_id) AND len(arguments.assetp_dorse_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.assetp_dorse_id#"><cfelse>NULL</cfif>,
				EXPEDITION_ENTRY_TIME = <cfif len(arguments.expedition_entry_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expedition_entry_time#"><cfelse>NULL</cfif>,
				EXPEDITION_EXIT_TIME = <cfif len(arguments.expedition_exit_time)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.expedition_exit_time#"><cfelse>NULL</cfif>, 
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.REMOTE_ADDR#">
			WHERE 
				WASTE_COLLECTION_EXPEDITIONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.waste_collection_expeditions_id#">
		</cfquery>
	</cffunction>
	<cffunction name="GetWasteCollectionExpeditionsRows" access="public" returntype="any">
		<cfargument name = "waste_collection_expeditions_id" default="" required="false">
		<cfquery name="GetWasteCollectionExpeditionsRows" datasource="#dsn#">
			SELECT
				REFI.*,
				S.SERVICE_NO,
				C.FULLNAME,
				CB.COMPBRANCH_ADDRESS ADDRESS,
                CB.COMPBRANCH_POSTCODE POSTCODE,
                CB.COUNTY_ID COUNTY,
                CB.CITY_ID CITY,
                CB.COUNTRY_ID COUNTRY,
                CB.SEMT SEMT,
				SCTRY.COUNTRY_NAME,
                SCITY.CITY_NAME,
                SCTY.COUNTY_NAME,
                P.COMPANY_PARTNER_ADDRESS,
                P.COMPANY_PARTNER_POSTCODE,
                P.SEMT P_SEMT,
                SCTRY2.COUNTRY_NAME P_COUNTRY_NAME,
                SCITY2.CITY_NAME P_CITY_NAME,
                SCTY2.COUNTY_NAME P_COUNTY_NAME,
                (SELECT SUM(ISNULL(AMOUNT,0)) AMOUNT FROM #dsn3#.SERVICE_OPERATION WHERE SERVICE_ID = REFI.SERVICE_ID) AMOUNT
			FROM 
				REFINERY_WASTE_COLLECTION_ROWS AS REFI
				LEFT JOIN #dsn3#.SERVICE S ON REFI.SERVICE_ID = S.SERVICE_ID
				LEFT JOIN #dsn#.COMPANY_BRANCH CB ON CB.COMPBRANCH_ID = S.OTHER_COMPANY_BRANCH_ID
                LEFT JOIN #dsn#.COMPANY C ON CB.COMPANY_ID = C.COMPANY_ID AND CB.COMPANY_ID = S.OTHER_COMPANY_ID
                LEFT JOIN #dsn#.SETUP_COUNTRY SCTRY ON SCTRY.COUNTRY_ID = CB.COUNTRY_ID
                LEFT JOIN #dsn#.SETUP_CITY SCITY ON SCITY.CITY_ID = CB.CITY_ID
                LEFT JOIN #dsn#.SETUP_COUNTY SCTY ON SCTY.COUNTY_ID = CB.COUNTY_ID
                LEFT JOIN #dsn#.COMPANY_PARTNER P ON S.SERVICE_COMPANY_ID = P.COMPANY_ID AND S.SERVICE_PARTNER_ID = P.PARTNER_ID
                LEFT JOIN #dsn#.SETUP_COUNTRY SCTRY2 ON SCTRY2.COUNTRY_ID = P.COUNTRY
                LEFT JOIN #dsn#.SETUP_CITY SCITY2 ON SCITY2.CITY_ID = P.CITY
                LEFT JOIN #dsn#.SETUP_COUNTY SCTY2 ON SCTY2.COUNTY_ID = P.COUNTY
			WHERE
				1 = 1
				<cfif isDefined("arguments.waste_collection_expeditions_id") and len(arguments.waste_collection_expeditions_id)>
					AND REFI.WASTE_COLLECTION_EXPEDITIONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.waste_collection_expeditions_id#">
				</cfif>
		</cfquery>
		<cfreturn GetWasteCollectionExpeditionsRows />
	</cffunction>
	<cffunction name="GetWasteCollectionExpeditionsServicesRows" access="remote" returntype="query">
        <cfargument name="service_id" default="">
        <cfquery name="GetWasteCollectionExpeditionsServicesRows" datasource="#DSN3#">
            SELECT 
                ISNULL(SO.AMOUNT,0) AMOUNT,
                SO.PREDICTED_AMOUNT,
                SO.WRK_ROW_ID,
                SO.SPARE_PART_ID,
                SO.SERVICE_EMP_ID,
                SO.SERIAL_NO,
                SO.STOCK_ID,
                SO.PRODUCT_ID,
                SO.PRODUCT_NAME,
                SO.DETAIL,
                SO.UNIT_ID,
                SO.UNIT,
                SO.PRICE,
                SO.TOTAL_PRICE,
                SO.CURRENCY,
                SO.IS_TOTAL,
                SO.SERVICE_OPE_ID,
                SSP.SPARE_PART,
                P.PRODUCT_CODE_2,
				P.PRODUCT_CODE_2 + '-' + P.PRODUCT_NAME P_FULLNAME
            FROM 
                SERVICE_OPERATION SO
                LEFT JOIN SERVICE_SPARE_PART SSP ON SO.SPARE_PART_ID = SSP.SPARE_PART_ID
                LEFT JOIN #dsn1#.PRODUCT P ON SO.PRODUCT_ID = P.PRODUCT_ID
            WHERE 
                SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.service_id#">
        </cfquery>
        <cfreturn GetWasteCollectionExpeditionsServicesRows>
    </cffunction>
	
</cfcomponent>