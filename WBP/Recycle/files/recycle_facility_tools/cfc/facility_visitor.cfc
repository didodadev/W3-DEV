<cfcomponent>

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">
	<cffunction name="addFacilityVisitor" access="remote" returntype="any">
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

		<cfquery name="addFacilityVisitor" datasource="#dsn#" result="result">
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
	<cffunction name="getFacilityVisitor" access="remote" returntype="any">
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

		<cfquery name="getFacilityVisitor" datasource="#DSN#">
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
		<cfreturn getFacilityVisitor />
	</cffunction>
	<cffunction name="updFacilityVisitor" access="remote" returntype="any">
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

		<cfquery name="updFacilityVisitor" datasource="#dsn#">
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
</cfcomponent>