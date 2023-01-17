<!---
	Atıkların ya da atıklardan üretilen yarı mamül ve son mamüllerin analiz
	şablonlarında tanımlanabilen testlerinin takip edildiği objedir. Ürünün
	kalitesi analiz edilir, bu sonuçlar joystick üzerinde de depoların nem,
	ısı, basınç vb gibi ölçüm değerleriyle birlikte yöneticilere ve tesis
	müdürünün takibine sunulur. Sonuçların woc ile çıktı alınması sağlanır.
--->

<cfcomponent extends="cfc.faFunctions">
	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />
	<cfset request.self = application.systemParam.systemParam().request.self />
    <cfset fusebox.process_tree_control = application.systemParam.systemParam().fusebox.process_tree_control>

	<cfscript>
		functions = CreateObject("component","WMO.functions");
		filterNum = functions.filterNum;
        wrk_round = functions.wrk_round;
        getlang = functions.getlang;
		date_add= functions.date_add;
		ListDeleteDuplicates= functions.ListDeleteDuplicates;
	</cfscript>
	<cfsetting requesttimeout="2000">

	<cffunction name="getSampleAnalysisCat" access="public" returntype="any">
		<cfquery name="getSampleAnalysisCat" datasource="#dsn#">
			SELECT * FROM REFINERY_ANALYZE_CAT WHERE OUR_COMPANY_ID = <cfqueryparam	cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfreturn getSampleAnalysisCat>
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
		<cfargument name = "sample_date1" default="" required="false">
		<cfargument name = "sample_date2" default="" required="false">
		<cfargument name= "analyse_date1" default="" required="false">
		<cfargument name= "analyse_date2" default="" required="false">
		<cfargument name= "stock_id" default="" required="false">
		<cfargument name= "requesting_employee_name" default="" required="false">
		<cfargument name= "requesting_employee_id" default="" required="false">
		<cfargument name= "sample_employee_id" default="" required="false">
		<cfargument name= "sample_employee_name" default="" required="false">
		<cfargument name="analysis_method" default="" required="false">
		<cfargument name="member_name" default="" required="false">
		<cfargument name="consumer_id" default="" required="false">
		<cfargument name="company_id" default="" required="false">
		<cfargument name="member_type" default="" required="false">
		<cfargument name="spect_main_id" default="" required="false">
		<cfargument name="spect_name" default="" required="false">
		<cfargument name="serial_no" default="" required="false">

		<cfquery name="getLabTest" datasource="#DSN#">
			SELECT 
				REF.PROCESS_STAGE,
				REF.LAB_REPORT_NO,
				REF.NUMUNE_DATE,
				REF.ANALYSE_DATE,
				REF.REQUESTING_EMPLOYE_ID,
				REF.DETAIL,
				REF.SAMPLE_EMPLOYEE_ID,
				REF.REFINERY_LAB_TEST_ID,
				REF.PRODUCT_SAMPLE_ID
				
				
			FROM 
				REFINERY_LAB_TESTS AS REF
			LEFT JOIN PROCESS_TYPE_ROWS AS PTR ON REF.PROCESS_STAGE = PTR.PROCESS_ROW_ID
			LEFT JOIN LAB_SAMPLING LS ON REF.REFINERY_LAB_TEST_ID = LS.SAMPLE_ANALYSIS_ID
			LEFT JOIN LAB_SAMPLING_ROW LSR ON LSR.SAMPLING_ID = LS.SAMPLING_ID
			LEFT JOIN REFINERY_LAB_TESTS_ROW REFR ON REFR.REFINERY_LAB_TEST_ID =REF.REFINERY_LAB_TEST_ID
			LEFT JOIN #dsn3#.STOCKS S ON S.STOCK_ID = LSR.STOCK_ID
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
			<cfif isdate(arguments.sample_date1) and len(arguments.sample_date1)>
				AND REF.NUMUNE_DATE >= #arguments.sample_date1#
			</cfif>
			<cfif isdate(arguments.sample_date2) and len(arguments.sample_date2)>
				AND REF.NUMUNE_DATE <=  #arguments.sample_date2#
			</cfif>
			<cfif isdate(arguments.analyse_date1) and len(arguments.analyse_date1)>
				AND REF.ANALYSE_DATE >= #arguments.analyse_date1#
			</cfif>
			<cfif isdate(arguments.analyse_date2) and len(arguments.analyse_date2)>
				AND REF.ANALYSE_DATE <=  #arguments.analyse_date2#
			</cfif>
			<cfif isDefined("arguments.stock_id") and len(arguments.stock_id)>
				AND LSR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
			</cfif>
			<cfif len(arguments.requesting_employee_name) and len(arguments.requesting_employee_id)>
				AND REF.REQUESTING_EMPLOYE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.requesting_employee_id#">
			</cfif>
			<cfif len(arguments.sample_employee_name) and len(arguments.sample_employee_id)>
				AND REF.SAMPLE_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sample_employee_id#">
			</cfif>
			<cfif len(arguments.analysis_method)>
				AND REFR.GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analysis_method#">
			</cfif>
			<cfif len(arguments.member_name)>
				<cfif len(arguments.consumer_id)>
					AND REF.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
				<cfelseif len(arguments.company_id)>
					AND REF.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
				<cfelseif len(arguments.member_type)>
					AND REF.MEMBER_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.member_type#">
				</cfif>
			</cfif>
			<cfif len(arguments.spect_name) and len(arguments.spect_main_id)>
				AND LSR.SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_main_id#">
			</cfif>
			<cfif len(arguments.serial_no)>
				AND LSR.SERIAL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.serial_no#%">
			</cfif>
			
			GROUP BY 
				REF.LAB_REPORT_NO,
				REF.REFINERY_LAB_TEST_ID,
				REF.NUMUNE_DATE,
				REF.ANALYSE_DATE,
				REF.REQUESTING_EMPLOYE_ID,
				REF.DETAIL,
				REF.SAMPLE_EMPLOYEE_ID,
				REF.PROCESS_STAGE,
				REF.PRODUCT_SAMPLE_ID
				
				ORDER BY
				REFINERY_LAB_TEST_ID DESC

		</cfquery>
		<cfreturn getLabTest />
	</cffunction>
	<cffunction name="getLabTestRow" access="remote" returntype="any">
		<cfargument name = "refinery_lab_test_id" default="" required="false">
		<cfquery name="getLabTestRow" datasource="#DSN#">
			SELECT
				REF.*,
				RLT.*,
				EMP.EMPLOYEE_NAME,
				EMP.EMPLOYEE_SURNAME,
				RTU.UNIT_NAME
			FROM
				REFINERY_LAB_TESTS_ROW AS REF
				LEFT JOIN REFINERY_LAB_TESTS RLT ON RLT.REFINERY_LAB_TEST_ID= REF.REFINERY_LAB_TEST_ID
				LEFT JOIN EMPLOYEES AS EMP ON EMP.EMPLOYEE_ID = REF.RECORD_EMP
				LEFT JOIN REFINERY_TEST_UNITS RTU ON RTU.REFINERY_UNIT_ID = REF.UNIT_ID
			WHERE
				RLT.REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.refinery_lab_test_id#">
		</cfquery>
		<cfreturn getLabTestRow />
	</cffunction>
	<cffunction name="get_detail_lab_test" access="remote" returntype="any">
		<cfargument name="refinery_lab_test_id" default="">
		<cfquery name="get_detail_lab_test" datasource="#dsn#">
			SELECT
			REFINERY_LAB_TEST_ID
			, LAB_TEST_ID 
			, REQUESTING_PERSON 
			, LAB_REPORT_NO 
			, NUMUNE_DATE 
			, NUMUNE_PERSON 
			, NUMUNE_ACCEPT_DATE 
			, NUMUNE_NAME 
			, ANALYSE_DATE 
			, ANALYSE_DATE_EXIT 
			, NUMUNE_PLACE 
			, DETAIL 
			, NUMUNE_POINT 
			, RECORD_EMP 
			, RECORD_DATE 
			, RECORD_IP 
			, UPDATE_EMP 
			, UPDATE_DATE 
			, UPDATE_IP 
			, CONFIRM_EMP 
			, CONFIRM_DATE 
			, REQUESTING_EMPLOYE_ID 
			, SAMPLE_EMPLOYEE_ID 
			, REFINERY_WASTE_OIL_ID 
			, PROCESS_STAGE 
			, CONSUMER_ID 
			, COMPANY_ID 
			, MEMBER_TYPE 
			, OUR_COMPANY_ID 
			, LOCATION_ID 
			, DEPARTMENT_ID 
			, BRANCH_ID 
			, IS_VALID 
			, ANALYSIS_CAT_ID 
			, SAMPLING_ID 
			, PRODUCT_SAMPLE_ID
	
			FROM
				REFINERY_LAB_TESTS 
			WHERE
				REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_lab_test_id#">
		</cfquery>
		<cfreturn get_detail_lab_test>
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
		<cfargument name="rowcount_" default="">
		<cfargument name="q_row_accept" default="">
		<cfargument name="test_report_content" default="">
		<cfargument name="p_sample_id" default="">

		<!--- save_sampling --->
		<cfargument name = "sampling_id" default="">
		<cfargument name = "process_cat" default="">
		<cfargument name = "sampling_date" default="">
		<cfargument name = "sampling_time" default="">
		<cfargument name = "sample_analysis_id" default="">
		<!--- save_sampling_row--->
		<cfargument name = "sampling_row_id" default="">
		<cfargument name = "samplingRowId" default="">
		<cfargument name = "stock_id" default="">
		<cfargument name = "product_id" default="">
		<cfargument name = "description" default="">
		<cfargument name = "lot_no" default="">
		<cfargument name = "spect_var_id" default="">
		<cfargument name = "serial_no" default="">
		<cfargument name = "unit_id" default="">
		<cfargument name = "sample_amount" default="">
		<cfargument name="total_count" default="">
		<cfset attributes.fuseaction= "lab.sample_analysis">
		<cfset caller.attributes.fuseaction = "lab.sample_analysis">
		<cfset responseStruct = structNew()>
		
        <cftry>
			<cfif len( arguments.numune_date )>
				<cf_date tarih="arguments.numune_date">
				<cfif len( arguments.numune_hour )><cfset arguments.numune_date = date_add("h", arguments.numune_hour - session.ep.time_zone, arguments.numune_date)></cfif>
				<cfif len( arguments.numune_minute )><cfset arguments.numune_date = date_add("n", arguments.numune_minute, arguments.numune_date)></cfif>
			</cfif>
			
			<cfif len( arguments.numune_accept_date )>
				<cf_date tarih="arguments.numune_accept_date">
				<cfif len( arguments.numune_accept_hour )><cfset arguments.numune_accept_date = date_add("h", arguments.numune_accept_hour - session.ep.time_zone, arguments.numune_accept_date)></cfif>
				<cfif len( arguments.numune_accept_minute )><cfset arguments.numune_accept_date = date_add("n", arguments.numune_accept_minute, arguments.numune_accept_date)></cfif>
			</cfif>
			
			<cfif len( arguments.analyse_date )>
				<cf_date tarih="arguments.analyse_date">
				<cfif len( arguments.analyse_date_entry_hour )><cfset arguments.analyse_date = date_add("h", arguments.analyse_date_entry_hour - session.ep.time_zone, arguments.analyse_date)></cfif>
				<cfif len( arguments.analyse_date_entry_minute )><cfset arguments.analyse_date = date_add("n", arguments.analyse_date_entry_minute, arguments.analyse_date)></cfif>
			</cfif>
			
			<cfif len( arguments.analyse_date_exit )>
				<cf_date tarih="arguments.analyse_date_exit">
				<cfif len( arguments.analyse_date_exit_hour )><cfset arguments.analyse_date_exit = date_add("h", arguments.analyse_date_exit_hour - session.ep.time_zone, arguments.analyse_date_exit)></cfif>
				<cfif len( arguments.analyse_date_exit_minute )><cfset arguments.analyse_date_exit = date_add("n", arguments.analyse_date_exit_minute, arguments.analyse_date_exit)></cfif>
			</cfif>
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
					ANALYSIS_CAT_ID,
					OUR_COMPANY_ID,
					LOCATION_ID,
					DEPARTMENT_ID,
					BRANCH_ID,
					REPORT_CONTENT,
					PRODUCT_SAMPLE_ID
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
					<cfif len(arguments.branch_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
					<cfif len(arguments.test_report_content)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.test_report_content#"><cfelse>NULL</cfif>,
					<cfif len(arguments.p_sample_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.p_sample_id#"><cfelse>NULL</cfif>

				)
			</cfquery>
			<cfquery name="GET_MAX" datasource="#dsn#" maxrows="1">
				SELECT * FROM REFINERY_LAB_TESTS   
				ORDER BY 
				REFINERY_LAB_TEST_ID DESC
			</cfquery>
			<cfif isDefined("rowcount_") and rowcount_ gt 0>
				<cfloop index="i" from="1" to="#rowcount_#">
					<cfif isDefined("arguments.groupId#i#") and Len(Evaluate('arguments.groupId#i#'))><cfset groupId = Evaluate('arguments.groupId#i#')><cfelse><cfset groupId = ""></cfif>
					<cfif isDefined("arguments.parameterId#i#") and Len(Evaluate('arguments.parameterId#i#'))><cfset parameterId = Evaluate('arguments.parameterId#i#')><cfelse><cfset parameterId = ""></cfif>
					<cfif isDefined("arguments.minLimit#i#") and Len(Evaluate('arguments.minLimit#i#'))><cfset minLimit = Evaluate('arguments.minLimit#i#')><cfelse><cfset minLimit = ""></cfif>
					<cfif isDefined("arguments.maxLimit#i#") and Len(Evaluate('arguments.maxLimit#i#'))><cfset maxLimit = Evaluate('arguments.maxLimit#i#')><cfelse><cfset maxLimit = ""></cfif>
					<cfif isDefined("arguments.options#i#") and Len(Evaluate('arguments.options#i#'))><cfset options = Evaluate('arguments.options#i#')><cfelse><cfset options = ""></cfif>
					<cfif isDefined("arguments.unitId#i#") and Len(Evaluate('arguments.unitId#i#'))><cfset unitId = Evaluate('arguments.unitId#i#')><cfelse><cfset unitId = ""></cfif>
					<cfif isDefined("arguments.amount_#i#") and Len(Evaluate('arguments.amount_#i#'))><cfset amount = Evaluate('arguments.amount_#i#')><cfelse><cfset amount = ""></cfif>
					<cfif isDefined("arguments.standart_value_#i#") and Len(Evaluate('arguments.standart_value_#i#'))><cfset standart_value = Evaluate('arguments.standart_value_#i#')><cfelse><cfset standart_value = ""></cfif>
					<cfif isDefined("arguments.result_#i#") and Len(Evaluate('arguments.result_#i#'))><cfset result = Evaluate('arguments.result_#i#')><cfelse><cfset result = ""></cfif>
					<cfif isDefined("arguments.sample_method_#i#") and Len(Evaluate('arguments.sample_method_#i#'))><cfset sample_method = Evaluate('arguments.sample_method_#i#')><cfelse><cfset sample_method = ""></cfif>
					<cfif isDefined("arguments.sample_number_#i#") and Len(Evaluate('arguments.sample_number_#i#'))><cfset sample_number = Evaluate('arguments.sample_number_#i#')><cfelse><cfset sample_number = ""></cfif>
					<cfif isDefined("arguments.accept_#i#") and Len(Evaluate('arguments.accept_#i#'))><cfset accept = Evaluate('arguments.accept_#i#')><cfelse><cfset accept = ""></cfif>
					<cfif isDefined("arguments.type_description_#i#") and Len(Evaluate('arguments.type_description_#i#'))><cfset type_description = Evaluate('arguments.type_description_#i#')><cfelse><cfset type_description = ""></cfif>
					<cfif isDefined("arguments.q_row_accept_#i#") and Len(Evaluate('arguments.q_row_accept_#i#'))><cfset q_row_accept = Evaluate('arguments.q_row_accept_#i#')><cfelse><cfset q_row_accept = ""></cfif>
			
					<cfquery name="ADD_PARAMETERS" datasource="#dsn#">
						INSERT INTO
							REFINERY_LAB_TESTS_ROW
							(
								REFINERY_LAB_TEST_ID,
								GROUP_ID,
								PARAMETER_ID,
								MIN_LIMIT,
								MAX_LIMIT,
								OPTIONS,
								UNIT_ID,
								AMOUNT,
								STANDART_VALUE,
								RESULT,
								SAMPLE_METHOD,
								SAMPLE_NUMBER,
								IS_ACCEPT,
								DESCRIPTION,
								RECORD_EMP,
								RECORD_DATE,
								IS_ACCEPT_TEST

							)
							VALUES
							(
								#GET_MAX.REFINERY_LAB_TEST_ID#,
								<cfif len(groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#groupId#"><cfelse>NULL</cfif>,
								<cfif len(parameterId)><cfqueryparam cfsqltype="cf_sql_integer" value="#parameterId#"><cfelse>NULL</cfif>,
								<cfif len(minLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(minLimit)#"><cfelse>NULL</cfif>,
								<cfif len(maxLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(maxLimit)#"><cfelse>NULL</cfif>,
								<cfif len(options)><cfqueryparam cfsqltype="cf_sql_integer" value="#options#"><cfelse>NULL</cfif>,
								<cfif len(unitId)><cfqueryparam cfsqltype="cf_sql_integer" value="#unitId#"><cfelse>NULL</cfif>,
								<cfif len(amount)><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(amount)#"><cfelse>NULL</cfif>,
								<cfif len(standart_value)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(standart_value)#"><cfelse>NULL</cfif>,
								<cfif len(result)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(result)#"><cfelse>NULL</cfif>,
								<cfif len(sample_method)><cfqueryparam cfsqltype="cf_sql_integer" value="#sample_method#"><cfelse>NULL</cfif>,
								<cfif len(sample_number)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(sample_number)#"><cfelse>NULL</cfif>,
								<cfif len(accept)><cfqueryparam cfsqltype="cf_sql_bit" value="#accept#"><cfelse>0</cfif>,
								<cfif len(type_description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#type_description#"><cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfif len(q_row_accept)><cfqueryparam cfsqltype="cf_sql_bit" value="#q_row_accept#"><cfelse>0</cfif>

							)
					</cfquery>
				</cfloop>
			</cfif>
			<cfquery name="UPDATE_GENERAL_PAPERS" datasource="#dsn3#">
				UPDATE GENERAL_PAPERS 
				SET SAMPLE_ANALYSIS_NUMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#listGetAt(arguments.lab_report_no,2,"-")#">
				WHERE PAPER_TYPE IS NULL
			</cfquery>
			<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn#' 
			old_process_line='0'
			process_stage='#arguments.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='REFINERY_LAB_TESTS'
			action_column='REFINERY_LAB_TEST_ID'
			action_id='#GET_MAX.REFINERY_LAB_TEST_ID#'
			action_page='#request.self#?fuseaction=lab.sample_analysis&event=upd&refinery_lab_test_id=#GET_MAX.REFINERY_LAB_TEST_ID#' 
			warning_description='Numune Analizi: #GET_MAX.REFINERY_LAB_TEST_ID#'>

			
				<cfscript>
					arguments.process_cat = 260;
					arguments.sampling_date = arguments.numune_date;
					arguments.sampling_time = createdatetime(year(arguments.sampling_date),month(arguments.sampling_date),day(arguments.sampling_date),LSParseNumber(arguments.numune_hour),LSParseNumber(arguments.numune_minute),0);
				</cfscript>
				<cfif len(arguments.sampling_id)>
					<cfquery name = "upd_sampling" datasource="#dsn#">
						UPDATE
							LAB_SAMPLING
						SET
							PROCESS_CAT = <cfif len(arguments.process_cat)>#arguments.process_cat#<cfelse>NULL</cfif>,
							DEPARTMENT_ID = <cfif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
							LOCATION_ID = <cfif len(arguments.location_id)>#arguments.location_id#<cfelse>NULL</cfif>,
							UPDATE_EMP = #session.ep.userid#,
							UPDATE_DATE = #now()#,
							UPDATE_IP = '#cgi.remote_addr#',
							SAMPLING_DATE = #arguments.sampling_date#,
							SAMPLING_TIME = #arguments.sampling_time#,
							SAMPLE_ANALYSIS_ID = <cfif len(GET_MAX.REFINERY_LAB_TEST_ID)>#GET_MAX.REFINERY_LAB_TEST_ID#<cfelse>NULL</cfif>
						WHERE
							SAMPLING_ID = #arguments.sampling_id#
					</cfquery>
					<cfquery name = "upd_sample_analysis" datasource="#dsn#">
						UPDATE REFINERY_LAB_TESTS SET SAMPLING_ID = #arguments.sampling_id# WHERE REFINERY_LAB_TEST_ID = #GET_MAX.REFINERY_LAB_TEST_ID#
					</cfquery>
				<cfelse>
					<cfquery name = "add_sampling" datasource="#dsn#" result = "r">
						INSERT INTO
							LAB_SAMPLING
						(
							PROCESS_CAT,
							DEPARTMENT_ID,
							LOCATION_ID,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP,
							OUR_COMPANY_ID,
							SAMPLING_DATE,
							SAMPLING_TIME,
							SAMPLE_ANALYSIS_ID
						) VALUES
						(
							<cfif len(arguments.process_cat)>#arguments.process_cat#<cfelse>NULL</cfif>,
							<cfif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
							<cfif len(arguments.location_id)>#arguments.location_id#<cfelse>NULL</cfif>,
							#session.ep.userid#,
							#now()#,
							'#cgi.remote_addr#',
							#session.ep.company_id#,
							<cfif len(arguments.process_cat)>#arguments.sampling_date#<cfelse>NULL</cfif>,
							<cfif len(arguments.process_cat)>#arguments.sampling_time#<cfelse>NULL</cfif>,
							<cfif len(GET_MAX.REFINERY_LAB_TEST_ID)>#GET_MAX.REFINERY_LAB_TEST_ID#<cfelse>NULL</cfif>
						)
					</cfquery>
					<cfquery name = "upd_sample_analysis" datasource="#dsn#">
						UPDATE REFINERY_LAB_TESTS SET SAMPLING_ID = #r.identitycol# WHERE REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_MAX.REFINERY_LAB_TEST_ID#">
					</cfquery>
				</cfif>
				<cfif len(arguments.sampling_id)><cfset samp_id=arguments.sampling_id><cfelseif len(r.identitycol)><cfset samp_id=r.identitycol></cfif>
					
				<cfif arguments.total_count gt 0>
					<cfloop from = "1" to = "#arguments.total_count#" index = "i">
						<cfif isDefined("arguments.stock_id#i#") and Len(Evaluate('arguments.stock_id#i#'))><cfset arguments.stock_id = Evaluate('arguments.stock_id#i#')><cfelse><cfset arguments.stock_id = ""></cfif>
						<cfif isDefined("arguments.product_id#i#") and Len(Evaluate('arguments.product_id#i#'))><cfset arguments.product_id = Evaluate('arguments.product_id#i#')><cfelse><cfset arguments.product_id = ""></cfif>
						<cfif isDefined("arguments.samplingRowId#i#") and Len(Evaluate('arguments.samplingRowId#i#'))><cfset arguments.samplingRowId = Evaluate('arguments.samplingRowId#i#')><cfelse><cfset arguments.samplingRowId = ""></cfif>
						<cfif isDefined("arguments.description#i#") and Len(Evaluate('arguments.description#i#'))><cfset arguments.description = Evaluate('arguments.description#i#')><cfelse><cfset arguments.description = ""></cfif>
						<cfif isDefined("arguments.lot_no#i#") and Len(Evaluate('arguments.lot_no#i#'))><cfset arguments.lot_no = Evaluate('arguments.lot_no#i#')><cfelse><cfset arguments.lot_no = ""></cfif>
						<cfif isDefined("arguments.spect_var_id#i#") and Len(Evaluate('arguments.spect_var_id#i#'))><cfset arguments.spect_var_id = Evaluate('arguments.spect_var_id#i#')><cfelse><cfset arguments.spect_var_id = ""></cfif>
						<cfif isDefined("arguments.serial_no#i#") and Len(Evaluate('arguments.serial_no#i#'))><cfset arguments.serial_no = Evaluate('arguments.serial_no#i#')><cfelse><cfset arguments.serial_no = ""></cfif>
						<cfif isDefined("arguments.stock_unit_id#i#") and Len(Evaluate('arguments.stock_unit_id#i#'))><cfset arguments.stock_unit_id = Evaluate('arguments.stock_unit_id#i#')><cfelse><cfset arguments.stock_unit_id = ""></cfif>
						<cfif isDefined("arguments.sample_amount#i#") and Len(Evaluate('arguments.sample_amount#i#'))><cfset arguments.sample_amount = Evaluate('arguments.sample_amount#i#')><cfelse><cfset arguments.sample_amount = ""></cfif>
							
						<cfif evaluate("arguments.samplingRowDeleted#i#") eq 0>
							<cfquery name = "checkStockAmount" datasource="#dsn#">
								SELECT
									SUM(STOCK_IN - STOCK_OUT) AS TOTAL_STOCK
								FROM
									#dsn2#.STOCKS_ROW SR
								WHERE
									1 = 1
									AND SR.STOCK_ID = #arguments.stock_id#
									AND SR.PRODUCT_ID = #arguments.product_id#
									AND SR.STORE = #arguments.department_id#
									AND SR.STORE_LOCATION = #arguments.location_id#
									<cfif len(arguments.spect_var_id)>
										AND SR.SPECT_VAR_ID = #arguments.spect_var_id#
									<cfelse>
										AND SR.SPECT_VAR_ID IS NULL
									</cfif>
									<cfif len(arguments.lot_no)>
										AND SR.LOT_NO = '#arguments.lot_no#'
									<cfelse>
										AND SR.LOT_NO IS NULL
									</cfif>
							</cfquery>
							<cfif checkStockAmount.total_stock gte filterNum(arguments.sample_amount)>
								<cfif filterNum(arguments.sample_amount) gt 0>
									<cfquery name="ADD_STOCK_ROW" datasource="#dsn#" result = "sr">
										INSERT INTO
											#dsn2#.STOCKS_ROW
											(
												UPD_ID,
												PRODUCT_ID,
												STOCK_ID,
												PROCESS_TYPE,
												STOCK_OUT,
												STORE,
												STORE_LOCATION,
												PROCESS_DATE,
												PROCESS_TIME,
												SPECT_VAR_ID,
												LOT_NO
											) VALUES (
												#row2.identitycol#,
												#arguments.product_id#,
												#arguments.stock_id#,
												961,
												#filterNum(arguments.sample_amount)#,
												#arguments.department_id#,
												#arguments.location_id#,
												#arguments.sampling_date#,
												#arguments.sampling_time#,
												<cfif len(arguments.spect_var_id)>#arguments.spect_var_id#<cfelse>NULL</cfif>,
												<cfif len(arguments.lot_no)>'#arguments.lot_no#'<cfelse>NULL</cfif>
											)
									</cfquery>
					
									<cfquery name = "upd_stock_row_id" datasource="#dsn#">
										UPDATE
											#dsn#.LAB_SAMPLING_ROW
										SET
											STOCK_ROW_ID = #sr.identitycol#
										WHERE
											SAMPLING_ROW_ID = #row2.identitycol#
									</cfquery>
								</cfif>
							</cfif>
						</cfif>
						<cfquery name = "add_sampling_row" datasource="#dsn#" result = "row2">
							INSERT INTO
								LAB_SAMPLING_ROW
							(
								SAMPLING_ID,
								STOCK_ID,
								PRODUCT_ID,
								DESCRIPTION,
								LOT_NO,
								SPECT_ID,
								SERIAL_NO,
								STOCK_UNIT_ID,
								SAMPLE_AMOUNT
							) VALUES (
								<cfif len(samp_id)>#samp_id#<cfelse>NULL</cfif>,
								<cfif len(arguments.stock_id)>#arguments.stock_id#<cfelse>NULL</cfif>,
								<cfif len(arguments.product_id)>#arguments.product_id#<cfelse>NULL</cfif>,
								<cfif len(arguments.description)>'#arguments.description#'<cfelse>NULL</cfif>,
								<cfif len(arguments.lot_no)>'#arguments.lot_no#'<cfelse>NULL</cfif>,
								<cfif len(arguments.spect_var_id)>#arguments.spect_var_id#<cfelse>NULL</cfif>,
								<cfif len(arguments.serial_no)>'#arguments.serial_no#'<cfelse>NULL</cfif>,
								<cfif len(arguments.stock_unit_id)>#arguments.stock_unit_id#<cfelse>NULL</cfif>,
								<cfif len(arguments.sample_amount)>#filterNum(arguments.sample_amount)#<cfelse>NULL</cfif>
							)
						</cfquery>
					</cfloop>
				</cfif>

			<cfset responseStruct.message = "İşlem Başarılı">
             <cfset responseStruct.status = true>
             <cfset responseStruct.error = {}>
             <cfset responseStruct.identity = GET_MAX.REFINERY_LAB_TEST_ID>
             <cfcatch>
				<cftransaction action="rollback">
				<cfset responseStruct.message = "İşlem Hatalı">
				<cfset responseStruct.status = false>
				<cfset responseStruct.error = cfcatch>
			</cfcatch>
		</cftry>
     <cfreturn responseStruct>
		<script>
			location.href= document.referrer;
			window.location.href= '<cfoutput>#request.self#?fuseaction=lab.sample_analysis&event=upd&refinery_lab_test_id=#GET_MAX.REFINERY_LAB_TEST_ID#</cfoutput>';
		</script>
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
		<cfargument name="ref_lab_test_id" default="" required="false">
		<cfargument name="upd_groupId" default="" required="false">
		<cfargument name="upd_parameterId" default="" required="false">
		<cfargument name="upd_minLimit" default="" required="false">
		<cfargument name="upd_maxLimit" default="" required="false">
		<cfargument name="upd_options" default="" required="false">
		<cfargument name="upd_unit" default="" required="false">
		<cfargument name="test_report_content" default="">
		<cfargument name="samplingRowId" default="">
		<cfargument name="sampling_id" default="" required="false">
		<cfargument name="p_sample_id" default="">
		<cfset attributes.fuseaction= "lab.sample_analysis">
		<cfset caller.attributes.fuseaction = "lab.sample_analysis">
		<cfset responseStruct = structNew()>
		<cftry>
			<cfif len( arguments.numune_date )>
				<cf_date tarih="arguments.numune_date">
				<cfif len( arguments.numune_hour )><cfset arguments.numune_date = date_add("h", arguments.numune_hour - session.ep.time_zone, arguments.numune_date)></cfif>
				<cfif len( arguments.numune_minute )><cfset arguments.numune_date = date_add("n", arguments.numune_minute, arguments.numune_date)></cfif>
			</cfif>
			
			<cfif len( arguments.numune_accept_date )>
				<cf_date tarih="arguments.numune_accept_date">
				<cfif len( arguments.numune_accept_hour )><cfset arguments.numune_accept_date = date_add("h", arguments.numune_accept_hour - session.ep.time_zone, arguments.numune_accept_date)></cfif>
				<cfif len( arguments.numune_accept_minute )><cfset arguments.numune_accept_date = date_add("n", arguments.numune_accept_minute, arguments.numune_accept_date)></cfif>
			</cfif>
			
			<cfif len( arguments.analyse_date )>
				<cf_date tarih="arguments.analyse_date">
				<cfif len( arguments.analyse_date_entry_hour )><cfset arguments.analyse_date = date_add("h", arguments.analyse_date_entry_hour - session.ep.time_zone, arguments.analyse_date)></cfif>
				<cfif len( arguments.analyse_date_entry_minute )><cfset arguments.analyse_date = date_add("n", arguments.analyse_date_entry_minute, arguments.analyse_date)></cfif>
			</cfif>
			
			<cfif len( arguments.analyse_date_exit )>
				<cf_date tarih="arguments.analyse_date_exit">
				<cfif len( arguments.analyse_date_exit_hour )><cfset arguments.analyse_date_exit = date_add("h", arguments.analyse_date_exit_hour - session.ep.time_zone, arguments.analyse_date_exit)></cfif>
				<cfif len( arguments.analyse_date_exit_minute )><cfset arguments.analyse_date_exit = date_add("n", arguments.analyse_date_exit_minute, arguments.analyse_date_exit)></cfif>
			</cfif>
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
					ANALYSIS_CAT_ID = <cfif len(arguments.analyze_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analyze_cat#"><cfelse>NULL</cfif>,
					LOCATION_ID = <cfif len(arguments.location_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.location_id#"><cfelse>NULL</cfif>,
					DEPARTMENT_ID = <cfif len(arguments.department_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#"><cfelse>NULL</cfif>,
					BRANCH_ID = <cfif len(arguments.branch_id) and len(arguments.department_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#"><cfelse>NULL</cfif>,
					REPORT_CONTENT = <cfif len(arguments.test_report_content)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.test_report_content#"><cfelse>NULL</cfif>,
					PRODUCT_SAMPLE_ID = <cfif len(arguments.p_sample_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.p_sample_id#"><cfelse>NULL</cfif>
				WHERE 
					REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_lab_test_id#">
			</cfquery>

			<!---Parametreler Update ediliyor.  --->
			<cfif isDefined("rowcount_new") and rowcount_new gt 0>
				<cfloop index="i" from="1" to="#rowcount_new#">
					<cfif isDefined("arguments.upd_groupId#i#") and Len(Evaluate('arguments.upd_groupId#i#'))><cfset upd_groupId = Evaluate('arguments.upd_groupId#i#')><cfelse><cfset upd_groupId = ""></cfif>
					<cfif isDefined("arguments.upd_parameterId#i#") and Len(Evaluate('arguments.upd_parameterId#i#'))><cfset upd_parameterId = Evaluate('arguments.upd_parameterId#i#')><cfelse><cfset upd_parameterId = ""></cfif>
					<cfif isDefined("arguments.upd_minLimit#i#") and Len(Evaluate('arguments.upd_minLimit#i#'))><cfset upd_minLimit = Evaluate('arguments.upd_minLimit#i#')><cfelse><cfset upd_minLimit = ""></cfif>
					<cfif isDefined("arguments.upd_maxLimit#i#") and Len(Evaluate('arguments.upd_maxLimit#i#'))><cfset upd_maxLimit = Evaluate('arguments.upd_maxLimit#i#')><cfelse><cfset upd_maxLimit = ""></cfif>
					<cfif isDefined("arguments.upd_options#i#") and Len(Evaluate('arguments.upd_options#i#'))><cfset upd_options = Evaluate('arguments.upd_options#i#')><cfelse><cfset upd_options = ""></cfif>
					<cfif isDefined("arguments.upd_unit_#i#") and Len(Evaluate('arguments.upd_unit_#i#'))><cfset upd_unit = Evaluate('arguments.upd_unit_#i#')><cfelse><cfset upd_unit = ""></cfif>
					<cfif isDefined("arguments.upd_amount_#i#") and Len(Evaluate('arguments.upd_amount_#i#'))><cfset upd_amount = Evaluate('arguments.upd_amount_#i#')><cfelse><cfset upd_amount = ""></cfif>
					<cfif isDefined("arguments.upd_standart_value_#i#") and Len(Evaluate('arguments.upd_standart_value_#i#'))><cfset upd_standart_value = Evaluate('arguments.upd_standart_value_#i#')><cfelse><cfset upd_standart_value = ""></cfif>
					<cfif isDefined("arguments.upd_result_#i#") and Len(Evaluate('arguments.upd_result_#i#'))><cfset upd_result = Evaluate('arguments.upd_result_#i#')><cfelse><cfset upd_result = ""></cfif>
					<cfif isDefined("arguments.upd_sample_method_#i#") and Len(Evaluate('arguments.upd_sample_method_#i#'))><cfset upd_sample_method = Evaluate('arguments.upd_sample_method_#i#')><cfelse><cfset upd_sample_method = ""></cfif>
					<cfif isDefined("arguments.upd_sample_number_#i#") and Len(Evaluate('arguments.upd_sample_number_#i#'))><cfset upd_sample_number = Evaluate('arguments.upd_sample_number_#i#')><cfelse><cfset upd_sample_number = ""></cfif>
					<cfif isDefined("arguments.upd_accept_#i#") and Len(Evaluate('arguments.upd_accept_#i#'))><cfset upd_accept = Evaluate('arguments.upd_accept_#i#')><cfelse><cfset upd_accept = ""></cfif>
					<cfif isDefined("arguments.upd_type_description_#i#") and Len(Evaluate('arguments.upd_type_description_#i#'))><cfset upd_type_description = Evaluate('arguments.upd_type_description_#i#')><cfelse><cfset upd_type_description = ""></cfif>
					<cfif isDefined("arguments.upd_accepted_#i#") and Len(Evaluate('arguments.upd_accepted_#i#'))><cfset upd_accepted = Evaluate('arguments.upd_accepted_#i#')><cfelse><cfset upd_accepted = ""></cfif>
					<cfif isDefined("arguments.ref_lab_test_id#i#") and Len(Evaluate('arguments.ref_lab_test_id#i#'))><cfset ref_lab_test_id = Evaluate('arguments.ref_lab_test_id#i#')><cfelse><cfset ref_lab_test_id = ""></cfif>
					<cfif len(ref_lab_test_id)>
						<cfquery name="add_UPD_PARAMETERS" datasource="#dsn#">
							UPDATE REFINERY_LAB_TESTS_ROW
							SET
								GROUP_ID = <cfif len(upd_groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#upd_groupId#"><cfelse>NULL</cfif>,
								PARAMETER_ID = <cfif len(upd_parameterId)><cfqueryparam cfsqltype="cf_sql_integer" value="#upd_parameterId#"><cfelse>NULL</cfif>,
								MIN_LIMIT = <cfif len(upd_minLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(upd_minLimit)#"><cfelse>NULL</cfif>,
								MAX_LIMIT = <cfif len(upd_maxLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(upd_maxLimit)#"><cfelse>NULL</cfif>,
								OPTIONS= <cfif len(upd_options)><cfqueryparam cfsqltype="cf_sql_integer" value="#upd_options#"><cfelse>NULL</cfif>,
								UNIT_ID = <cfif len(upd_unit)><cfqueryparam cfsqltype="cf_sql_integer" value="#upd_unit#"><cfelse>NULL</cfif>,
								AMOUNT = <cfif len(upd_amount)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(upd_amount)#"><cfelse>NULL</cfif>,
								STANDART_VALUE= <cfif len(upd_standart_value)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(upd_standart_value)#"><cfelse>NULL</cfif>,
								RESULT= <cfif len(upd_result)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(upd_result)#"><cfelse>NULL</cfif>,
								SAMPLE_METHOD= <cfif len(upd_sample_method)><cfqueryparam cfsqltype="cf_sql_integer" value="#upd_sample_method#"><cfelse>NULL</cfif>,
								SAMPLE_NUMBER= <cfif len(upd_sample_number)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(upd_sample_number)#"><cfelse>NULL</cfif>,
								IS_ACCEPT= <cfif len(upd_accept)>1<cfelse>0</cfif>,
								DESCRIPTION= <cfif len(upd_type_description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#upd_type_description#"><cfelse>NULL</cfif>,
								UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								IS_ACCEPT_TEST= <cfif len(upd_accepted)><cfqueryparam cfsqltype="cf_sql_integer" value="#upd_accepted#"><cfelse>0</cfif>
								WHERE REFINERY_LAB_TEST_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ref_lab_test_id#">
						</cfquery>
					<cfelse>
						<cfquery name="UPD_PARAMETERS" datasource="#dsn#">
							INSERT INTO
							REFINERY_LAB_TESTS_ROW
							(
								REFINERY_LAB_TEST_ID,
								GROUP_ID,
								PARAMETER_ID,
								MIN_LIMIT,
								MAX_LIMIT,
								OPTIONS,
								UNIT_ID,
								AMOUNT,
								STANDART_VALUE,
								RESULT,
								SAMPLE_METHOD,
								SAMPLE_NUMBER,
								IS_ACCEPT,
								DESCRIPTION,
								RECORD_EMP,
								RECORD_DATE,
								IS_ACCEPT_TEST
	
							)
							VALUES
							(
								#arguments.refinery_lab_test_id#,
								<cfif len(upd_groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#upd_groupId#"><cfelse>NULL</cfif>,
								<cfif len(upd_parameterId)><cfqueryparam cfsqltype="cf_sql_integer" value="#upd_parameterId#"><cfelse>NULL</cfif>,
								<cfif len(upd_minLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(upd_minLimit)#"><cfelse>NULL</cfif>,
								<cfif len(upd_maxLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(upd_maxLimit)#"><cfelse>NULL</cfif>,
								<cfif len(upd_options)><cfqueryparam cfsqltype="cf_sql_integer" value="#upd_options#"><cfelse>NULL</cfif>,
								<cfif len(upd_unit)><cfqueryparam cfsqltype="cf_sql_integer" value="#upd_unit#"><cfelse>NULL</cfif>,
								<cfif len(upd_amount)><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(upd_amount)#"><cfelse>NULL</cfif>,
								<cfif len(upd_standart_value)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(upd_standart_value)#"><cfelse>NULL</cfif>,
								<cfif len(upd_result)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(upd_result)#"><cfelse>NULL</cfif>,
								<cfif len(upd_sample_method)><cfqueryparam cfsqltype="cf_sql_integer" value="#upd_sample_method#"><cfelse>NULL</cfif>,
								<cfif len(upd_sample_number)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(upd_sample_number)#"><cfelse>NULL</cfif>,
								<cfif len(upd_accept)><cfqueryparam cfsqltype="cf_sql_bit" value="#upd_accept#"><cfelse>0</cfif>,
								<cfif len(upd_type_description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#upd_type_description#"><cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfif len(upd_accepted)><cfqueryparam cfsqltype="cf_sql_bit" value="#upd_accepted#"><cfelse>0</cfif>
	
							)
						</cfquery>
					</cfif> 
				</cfloop>
			</cfif>
			<!--- Yeni Eklenen parametreler Insert ediliyor. --->
			<cfif isDefined("rowcount_") and rowcount_ gt 0>
				<cfloop index="i" from="1" to="#rowcount_#">
					<cfif isDefined("arguments.groupId#i#") and Len(Evaluate('arguments.groupId#i#'))><cfset groupId = Evaluate('arguments.groupId#i#')><cfelse><cfset groupId = ""></cfif>
					<cfif isDefined("arguments.parameterId#i#") and Len(Evaluate('arguments.parameterId#i#'))><cfset parameterId = Evaluate('arguments.parameterId#i#')><cfelse><cfset parameterId = ""></cfif>
					<cfif isDefined("arguments.minLimit#i#") and Len(Evaluate('arguments.minLimit#i#'))><cfset minLimit = Evaluate('arguments.minLimit#i#')><cfelse><cfset minLimit = ""></cfif>
					<cfif isDefined("arguments.maxLimit#i#") and Len(Evaluate('arguments.maxLimit#i#'))><cfset maxLimit = Evaluate('arguments.maxLimit#i#')><cfelse><cfset maxLimit = ""></cfif>
					<cfif isDefined("arguments.options#i#") and Len(Evaluate('arguments.options#i#'))><cfset options = Evaluate('arguments.options#i#')><cfelse><cfset options = ""></cfif>
					<cfif isDefined("arguments.unitId#i#") and Len(Evaluate('arguments.unitId#i#'))><cfset unitId = Evaluate('arguments.unitId#i#')><cfelse><cfset unitId = ""></cfif>
					<cfif isDefined("arguments.amount_#i#") and Len(Evaluate('arguments.amount_#i#'))><cfset amount = Evaluate('arguments.amount_#i#')><cfelse><cfset amount = ""></cfif>
					<cfif isDefined("arguments.standart_value_#i#") and Len(Evaluate('arguments.standart_value_#i#'))><cfset standart_value = Evaluate('arguments.standart_value_#i#')><cfelse><cfset standart_value = ""></cfif>
					<cfif isDefined("arguments.result_#i#") and Len(Evaluate('arguments.result_#i#'))><cfset result = Evaluate('arguments.result_#i#')><cfelse><cfset result = ""></cfif>
					<cfif isDefined("arguments.sample_method_#i#") and Len(Evaluate('arguments.sample_method_#i#'))><cfset sample_method = Evaluate('arguments.sample_method_#i#')><cfelse><cfset sample_method = ""></cfif>
					<cfif isDefined("arguments.sample_number_#i#") and Len(Evaluate('arguments.sample_number_#i#'))><cfset sample_number = Evaluate('arguments.sample_number_#i#')><cfelse><cfset sample_number = ""></cfif>
					<cfif isDefined("arguments.accept_#i#") and Len(Evaluate('arguments.accept_#i#'))><cfset accept = Evaluate('arguments.accept_#i#')><cfelse><cfset accept = ""></cfif>
					<cfif isDefined("arguments.type_description_#i#") and Len(Evaluate('arguments.type_description_#i#'))><cfset type_description = Evaluate('arguments.type_description_#i#')><cfelse><cfset type_description = ""></cfif>
					<cfif isDefined("arguments.q_row_accept_#i#") and Len(Evaluate('arguments.q_row_accept_#i#'))><cfset q_row_accept = Evaluate('arguments.q_row_accept_#i#')><cfelse><cfset q_row_accept = ""></cfif>
	
					<cfquery name="ADD_PARAMETERS" datasource="#dsn#">
						INSERT INTO
							REFINERY_LAB_TESTS_ROW
							(
								REFINERY_LAB_TEST_ID,
								GROUP_ID,
								PARAMETER_ID,
								MIN_LIMIT,
								MAX_LIMIT,
								OPTIONS,
								UNIT_ID,
								AMOUNT,
								STANDART_VALUE,
								RESULT,
								SAMPLE_METHOD,
								SAMPLE_NUMBER,
								IS_ACCEPT,
								DESCRIPTION,
								RECORD_EMP,
								RECORD_DATE,
								IS_ACCEPT_TEST
	
							)
							VALUES
							(
								#arguments.refinery_lab_test_id#,
								<cfif len(groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#groupId#"><cfelse>NULL</cfif>,
								<cfif len(parameterId)><cfqueryparam cfsqltype="cf_sql_integer" value="#parameterId#"><cfelse>NULL</cfif>,
								<cfif len(minLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(minLimit)#"><cfelse>NULL</cfif>,
								<cfif len(maxLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(maxLimit)#"><cfelse>NULL</cfif>,
								<cfif len(options)><cfqueryparam cfsqltype="cf_sql_integer" value="#options#"><cfelse>NULL</cfif>,
								<cfif len(unitId)><cfqueryparam cfsqltype="cf_sql_integer" value="#unitId#"><cfelse>NULL</cfif>,
								<cfif len(amount)><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(amount)#"><cfelse>NULL</cfif>,
								<cfif len(standart_value)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(standart_value)#"><cfelse>NULL</cfif>,
								<cfif len(result)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(result)#"><cfelse>NULL</cfif>,
								<cfif len(sample_method)><cfqueryparam cfsqltype="cf_sql_integer" value="#sample_method#"><cfelse>NULL</cfif>,
								<cfif len(sample_number)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(sample_number)#"><cfelse>NULL</cfif>,
								<cfif len(accept)><cfqueryparam cfsqltype="cf_sql_bit" value="#accept#"><cfelse>0</cfif>,
								<cfif len(type_description)><cfqueryparam cfsqltype="cf_sql_varchar" value="#type_description#"><cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfif len(q_row_accept)><cfqueryparam cfsqltype="cf_sql_bit" value="#q_row_accept#"><cfelse>0</cfif>
	
							)
					</cfquery>
				</cfloop>
			</cfif>
			
			
			<cfscript>
				arguments.process_cat = 260;
				arguments.sampling_date = arguments.numune_date;
				arguments.sampling_time = createdatetime(year(arguments.sampling_date),month(arguments.sampling_date),day(arguments.sampling_date),LSParseNumber(arguments.numune_hour),LSParseNumber(arguments.numune_minute),0);
			</cfscript>
			<cfif len(arguments.sampling_id)>
				<cfquery name = "upd_sampling" datasource="#dsn#">
					UPDATE
						LAB_SAMPLING
					SET
						PROCESS_CAT = <cfif len(arguments.process_cat)>#arguments.process_cat#<cfelse>NULL</cfif>,
						DEPARTMENT_ID = <cfif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
						LOCATION_ID = <cfif len(arguments.location_id)>#arguments.location_id#<cfelse>NULL</cfif>,
						UPDATE_EMP = #session.ep.userid#,
						UPDATE_DATE = #now()#,
						UPDATE_IP = '#cgi.remote_addr#',
						SAMPLING_DATE = #arguments.sampling_date#,
						SAMPLING_TIME = #arguments.sampling_time#,
						SAMPLE_ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_lab_test_id#">
					WHERE
						SAMPLING_ID = #arguments.sampling_id#
				</cfquery>
				<cfquery name = "upd_sample_analysis" datasource="#dsn#">
					UPDATE REFINERY_LAB_TESTS SET SAMPLING_ID = #arguments.sampling_id# WHERE REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_lab_test_id#">
				</cfquery>
			<cfelse>
				<cfquery name = "add_sampling" datasource="#dsn#" result = "res_row">
					INSERT INTO
						LAB_SAMPLING
					(
						PROCESS_CAT,
						DEPARTMENT_ID,
						LOCATION_ID,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP,
						OUR_COMPANY_ID,
						SAMPLING_DATE,
						SAMPLING_TIME,
						SAMPLE_ANALYSIS_ID
					) VALUES
					(
						<cfif len(arguments.process_cat)>#arguments.process_cat#<cfelse>NULL</cfif>,
						<cfif len(arguments.department_id)>#arguments.department_id#<cfelse>NULL</cfif>,
						<cfif len(arguments.location_id)>#arguments.location_id#<cfelse>NULL</cfif>,
						#session.ep.userid#,
						#now()#,
						'#cgi.remote_addr#',
						#session.ep.company_id#,
						<cfif len(arguments.process_cat)>#arguments.sampling_date#<cfelse>NULL</cfif>,
						<cfif len(arguments.process_cat)>#arguments.sampling_time#<cfelse>NULL</cfif>,
						<cfif len(arguments.refinery_lab_test_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_lab_test_id#"><cfelse>NULL</cfif>
					)
				</cfquery>
				<cfquery name = "upd_sample_analysis" datasource="#dsn#">
					UPDATE REFINERY_LAB_TESTS SET SAMPLING_ID = #res_row.identitycol# WHERE REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_lab_test_id#">
				</cfquery>
			</cfif>
				<cfif len(arguments.sampling_id)><cfset samp_id=arguments.sampling_id><cfelseif len(res_row.identitycol)><cfset samp_id=res_row.identitycol></cfif>
				<cfif arguments.total_count gt 0>
					<cfloop from = "1" to = "#arguments.total_count#" index = "i">
						<cfif isDefined("arguments.stock_id#i#") and Len(Evaluate('arguments.stock_id#i#'))><cfset arguments.stock_id = Evaluate('arguments.stock_id#i#')><cfelse><cfset arguments.stock_id = ""></cfif>
						<cfif isDefined("arguments.product_id#i#") and Len(Evaluate('arguments.product_id#i#'))><cfset arguments.product_id = Evaluate('arguments.product_id#i#')><cfelse><cfset arguments.product_id = ""></cfif>
						<cfif isDefined("arguments.samplingRowId#i#") and Len(Evaluate('arguments.samplingRowId#i#'))><cfset arguments.samplingRowId = Evaluate('arguments.samplingRowId#i#')><cfelse><cfset arguments.samplingRowId = ""></cfif>
						<cfif isDefined("arguments.description#i#") and Len(Evaluate('arguments.description#i#'))><cfset arguments.description = Evaluate('arguments.description#i#')><cfelse><cfset arguments.description = ""></cfif>
						<cfif isDefined("arguments.lot_no#i#") and Len(Evaluate('arguments.lot_no#i#'))><cfset arguments.lot_no = Evaluate('arguments.lot_no#i#')><cfelse><cfset arguments.lot_no = ""></cfif>
						<cfif isDefined("arguments.spect_var_id#i#") and Len(Evaluate('arguments.spect_var_id#i#'))><cfset arguments.spect_var_id = Evaluate('arguments.spect_var_id#i#')><cfelse><cfset arguments.spect_var_id = ""></cfif>
						<cfif isDefined("arguments.serial_no#i#") and Len(Evaluate('arguments.serial_no#i#'))><cfset arguments.serial_no = Evaluate('arguments.serial_no#i#')><cfelse><cfset arguments.serial_no = ""></cfif>
						<cfif isDefined("arguments.stock_unit_id#i#") and Len(Evaluate('arguments.stock_unit_id#i#'))><cfset arguments.stock_unit_id = Evaluate('arguments.stock_unit_id#i#')><cfelse><cfset arguments.stock_unit_id = ""></cfif>
						<cfif isDefined("arguments.sample_amount#i#") and Len(Evaluate('arguments.sample_amount#i#'))><cfset arguments.sample_amount = Evaluate('arguments.sample_amount#i#')><cfelse><cfset arguments.sample_amount = ""></cfif>

						<cfquery name = "checkStockAmount" datasource="#dsn#">
							SELECT
								SUM(STOCK_IN - STOCK_OUT) AS TOTAL_STOCK
							FROM
								#dsn2#.STOCKS_ROW SR
							WHERE
								1 = 1
								AND SR.STOCK_ID = #arguments.stock_id#
								AND SR.PRODUCT_ID = #arguments.product_id#
								AND SR.STORE = #arguments.department_id#
								AND SR.STORE_LOCATION = #arguments.location_id#
								<cfif len(arguments.spect_var_id)>
									AND SR.SPECT_VAR_ID = #arguments.spect_var_id#
								<cfelse>
									AND SR.SPECT_VAR_ID IS NULL
								</cfif>
								<cfif len(arguments.lot_no)>
									AND SR.LOT_NO = '#arguments.lot_no#'
								<cfelse>
									AND SR.LOT_NO IS NULL
								</cfif>
						</cfquery>
						
						<cfif len(arguments.samplingRowId)>
							<cfquery name = "upd_sampling_row" datasource="#dsn#">
								UPDATE
									LAB_SAMPLING_ROW
				
								SET
									STOCK_ID = <cfif len(arguments.stock_id)>#arguments.stock_id#<cfelse>NULL</cfif>,
									PRODUCT_ID = <cfif len(arguments.product_id)>#arguments.product_id#<cfelse>NULL</cfif>,
									DESCRIPTION = <cfif len(arguments.description)>'#arguments.description#'<cfelse>NULL</cfif>,
									LOT_NO = <cfif len(arguments.lot_no)>'#arguments.lot_no#'<cfelse>NULL</cfif>,
									SPECT_ID = <cfif len(arguments.spect_var_id)>#arguments.spect_var_id#<cfelse>NULL</cfif>,
									SERIAL_NO = <cfif len(arguments.serial_no)>'#arguments.serial_no#'<cfelse>NULL</cfif>,
									STOCK_UNIT_ID = <cfif len(arguments.stock_unit_id)>#arguments.sampling_id#<cfelse>NULL</cfif>,
									SAMPLE_AMOUNT = <cfif len(arguments.sample_amount)>#filterNum(arguments.sample_amount)#<cfelse>NULL</cfif>
								WHERE
									SAMPLING_ROW_ID = #arguments.samplingRowId#
							</cfquery>
						<cfelse>
							<cfquery name = "add_sampling_row" datasource="#dsn#" result = "row2">
								INSERT INTO
									LAB_SAMPLING_ROW
								(
									SAMPLING_ID,
									STOCK_ID,
									PRODUCT_ID,
									DESCRIPTION,
									LOT_NO,
									SPECT_ID,
									SERIAL_NO,
									STOCK_UNIT_ID,
									SAMPLE_AMOUNT
								) VALUES (
									<cfif len(samp_id)>#samp_id#<cfelse>NULL</cfif>,
									<cfif len(arguments.stock_id)>#arguments.stock_id#<cfelse>NULL</cfif>,
									<cfif len(arguments.product_id)>#arguments.product_id#<cfelse>NULL</cfif>,
									<cfif len(arguments.description)>'#arguments.description#'<cfelse>NULL</cfif>,
									<cfif len(arguments.lot_no)>'#arguments.lot_no#'<cfelse>NULL</cfif>,
									<cfif len(arguments.spect_var_id)>#arguments.spect_var_id#<cfelse>NULL</cfif>,
									<cfif len(arguments.serial_no)>'#arguments.serial_no#'<cfelse>NULL</cfif>,
									<cfif len(arguments.stock_unit_id)>#arguments.stock_unit_id#<cfelse>NULL</cfif>,
									<cfif len(arguments.sample_amount)>#filterNum(arguments.sample_amount)#<cfelse>NULL</cfif>
								)
							</cfquery>
						</cfif>	
						<cfif len(arguments.samplingRowId)><cfset samp_row_id= arguments.samplingRowId><cfelse><cfset samp_row_id= row2.identitycol> </cfif>
						<cfif checkStockAmount.total_stock gte filterNum(arguments.sample_amount)>
							<cfif filterNum(arguments.sample_amount) gt 0>
								<cfquery name="ADD_STOCK_ROW" datasource="#dsn#" result = "sr">
									INSERT INTO
										#dsn2#.STOCKS_ROW
										(
											UPD_ID,
											PRODUCT_ID,
											STOCK_ID,
											PROCESS_TYPE,
											STOCK_OUT,
											STORE,
											STORE_LOCATION,
											PROCESS_DATE,
											PROCESS_TIME,
											SPECT_VAR_ID,
											LOT_NO
										) VALUES (
											#samp_row_id#,
											#arguments.product_id#,
											#arguments.stock_id#,
											961,
											#filterNum(arguments.sample_amount)#,
											#arguments.department_id#,
											#arguments.location_id#,
											#arguments.sampling_date#,
											#arguments.sampling_time#,
											<cfif len(arguments.spect_var_id)>#arguments.spect_var_id#<cfelse>NULL</cfif>,
											<cfif len(arguments.lot_no)>'#arguments.lot_no#'<cfelse>NULL</cfif>
										)
								</cfquery>
								<cfquery name = "upd_stock_row_id" datasource="#dsn#">
									UPDATE
										#dsn#.LAB_SAMPLING_ROW
									SET
										STOCK_ROW_ID = #sr.identitycol#
									WHERE
										SAMPLING_ROW_ID = #samp_row_id#
								</cfquery>
							</cfif>
						</cfif>
					</cfloop>
				</cfif>
			<cf_workcube_process 
			is_upd='1' 
			data_source='#dsn#' 
			old_process_line='#arguments.old_process_line#'
			process_stage='#arguments.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_table='REFINERY_LAB_TESTS'
			action_column='REFINERY_LAB_TEST_ID'
			action_id='#arguments.refinery_lab_test_id#'
			action_page='#request.self#?fuseaction=lab.sample_analysis&event=upd&refinery_lab_test_id=#arguments.refinery_lab_test_id#' 
			warning_description='Numune Analizi: #arguments.refinery_lab_test_id#'>

			<cfset responseStruct.message = "İşlem Başarılı">
			<cfset responseStruct.status = true>
			<cfset responseStruct.error = {}>
			<cfset responseStruct.identity = arguments.refinery_lab_test_id>
			<cfcatch>
			   <cftransaction action="rollback">
			   <cfset responseStruct.message = "İşlem Hatalı">
			   <cfset responseStruct.status = false>
			   <cfset responseStruct.error = cfcatch>
		   </cfcatch>
	   </cftry>
		<cfreturn responseStruct>
    </cffunction>
	<cffunction name="save_parameters" access="remote" returnFormat="JSON">
		<cfargument name="refinery_lab_test_id" default="" required="true">
		<cfargument name="rowcount_add" default="">
		<cfargument name="is_sample" default="">
		<cfargument name="is_upd" default="">
		<cfargument name="del_list" default="">
		<cfargument name="product_sample_id" default="">
		<cfset response = structNew()>
        <cfset response.status = true>

		<cftry>
			<cfset is_upd = ListDeleteDuplicates(arguments.is_upd)>
			<cfset product_sample_id = ListDeleteDuplicates(arguments.product_sample_id)>
			<cfscript>
				sample_number = '';
				sample_method = '';
				min_limit = '';
				max_limit = '';
				standart_value = '';
				control_operator = '';
				amount = '';
				unit = '';
			</cfscript>
			<cfif len(arguments.del_list)>
				<cfset main_del_ids=''>  
				<cfset sub_del_ids=''>  
				<cfloop from="1" to="#listLen(arguments.del_list,',')#" index="i">
					<cfoutput>
						<cfset del_test = listGetAt(arguments.del_list,i)>
						<cfset el_main_del_list = listGetAt(del_test,1,";")>
						<cfset main_del_ids = listappend(main_del_ids,el_main_del_list,",")>

						<cfset del_parameter = listGetAt(arguments.del_list,i)>
						<cfset el_sub_del_list = listGetAt(del_parameter,2,";")>
						<cfset sub_del_ids = listappend(sub_del_ids,el_sub_del_list,",")>
					</cfoutput>
				</cfloop>
			</cfif>
			<cfset rowcount_add = listLast(arguments.rowcount_add)>
			<!--- Numuneden geliyorsa --->
			<cfif is_upd eq 1>
				<cfif len(arguments.del_list)>
					<cfquery name="del_parameters" datasource="#dsn#" result="r">
						DELETE FROM
							REFINERY_LAB_TESTS_ROW
						WHERE
							REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_lab_test_id#">
							AND GROUP_ID in (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#main_del_ids#">)
							AND PARAMETER_ID in (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#sub_del_ids#">)
					</cfquery>
				</cfif>
				<cfif isDefined("rowcount_add") and rowcount_add gt 0>
					<cfloop index="i" from="1" to="#rowcount_add#">
						<cfif isDefined("arguments.groupId#i#") and Len(Evaluate('arguments.groupId#i#'))><cfset groupId = Evaluate('arguments.groupId#i#')><cfelse><cfset groupId = ""></cfif>
						<cfif isDefined("arguments.parameterId#i#") and Len(Evaluate('arguments.parameterId#i#'))><cfset parameterId = Evaluate('arguments.parameterId#i#')><cfelse><cfset parameterId = ""></cfif>
						<cfquery name="get_old_rec" datasource="#dsn#" result="r">
							SELECT
								*
							FROM	
								REFINERY_LAB_TESTS_ROW
							WHERE
								REFINERY_LAB_TEST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.refinery_lab_test_id#">
								<cfif len(groupId)>
									AND GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#groupId#">
								</cfif>
								<cfif len(parameterId)>
									AND PARAMETER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#parameterId#">
								</cfif>
						</cfquery>
						<cfif r.recordCount eq 0>
							<!--- Ürüne tanımlı Kalite Parametreleri kontrol ediliyor. --->
							<cfif len(product_sample_id)>
								<cfquery name="get_prod_id" datasource="#dsn3#" result="get_prod_id">
									SELECT PRODUCT_ID FROM #dsn1#.PRODUCT WHERE P_SAMPLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_sample_id#">
								</cfquery>
								<cfif len(groupId) and len(parameterId) and get_prod_id.recordCount>
									<cfquery name="get_product_quality" datasource="#dsn3#">
										SELECT
											SAMPLE_NUMBER
											, SAMPLE_METHOD
											, MIN_LIMIT
											, MAX_LIMIT
											, STANDART_VALUE
											, CONTROL_OPERATOR
											, AMOUNT
											,UNIT
										FROM 
											PRODUCT_QUALITY_CONTROL_ROW
										WHERE 
											PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prod_id.PRODUCT_ID#">
											AND QUALITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#groupId#">
											AND QUALITY_CONTROL_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#parameterId#">
									</cfquery>
								</cfif>
								
								<cfif get_product_quality.recordCount>
									<cfscript>
										sample_number = get_product_quality.sample_number;
										sample_method = get_product_quality.sample_method;
										min_limit = get_product_quality.min_limit;
										max_limit = get_product_quality.max_limit;
										standart_value = get_product_quality.standart_value;
										control_operator = get_product_quality.control_operator;
										amount = get_product_quality.amount;
										unit = get_product_quality.unit;
									</cfscript>
								</cfif>
								
							</cfif>
							<cfquery name="ADD_PARAMETERS" datasource="#dsn#" result="a">
								INSERT INTO
									REFINERY_LAB_TESTS_ROW
									(
										REFINERY_LAB_TEST_ID
										,GROUP_ID
										,PARAMETER_ID
										,SAMPLE_NUMBER
										,SAMPLE_METHOD
										,MIN_LIMIT
										,MAX_LIMIT
										,STANDART_VALUE
										,OPTIONS
										,AMOUNT
										,UNIT_ID
										,RECORD_EMP
										,RECORD_DATE
										
										
									)
									VALUES
									(
										#arguments.refinery_lab_test_id#,
										<cfif len(groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#groupId#"><cfelse>NULL</cfif>,
										<cfif len(parameterId)><cfqueryparam cfsqltype="cf_sql_integer" value="#parameterId#"><cfelse>NULL</cfif>,
										<cfif len(sample_number)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(sample_number)#"><cfelse>NULL</cfif>,
										<cfif len(sample_method)><cfqueryparam cfsqltype="cf_sql_integer" value="#sample_method#"><cfelse>NULL</cfif>,
										<cfif len(min_limit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(min_limit)#"><cfelse>NULL</cfif>,
										<cfif len(max_limit)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(max_limit)#"><cfelse>NULL</cfif>,
										<cfif len(standart_value)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(standart_value)#"><cfelse>NULL</cfif>,
										<cfif len(control_operator)><cfqueryparam cfsqltype="cf_sql_varchar" value="#control_operator#"><cfelse>NULL</cfif>,
										<cfif len(amount)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(amount)#"><cfelse>NULL</cfif>,
										<cfif len(unit)><cfqueryparam cfsqltype="cf_sql_integer" value="#unit#"><cfelse>NULL</cfif>,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
									)
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			<cfcatch>
                <cfset response.status = false>
            </cfcatch>
		</cftry>
		<cfreturn LCase(Replace(SerializeJson(response),"//","")) />
	</cffunction>
</cfcomponent>