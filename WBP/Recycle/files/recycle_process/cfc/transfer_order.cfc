<cfcomponent>

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">
	<cffunction name="GetTransferOrder" access="public" returntype="any">
		<cfargument name = "refinery_transport_id" default="" required="true">
		<cfargument name = "process_stage" default="" required="true">
		<cfargument name = "keyword" default="" required="false">

		<cfquery name="GetTransferOrder" datasource="#dsn2#">
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
		<cfreturn GetTransferOrder />
	</cffunction>
	<cffunction name="addTransferOrder" access="public" returntype="any">
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

		<cfquery name="addTransferOrder" datasource="#dsn#" result="result">
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
	<cffunction name="updTransferOrder" access="public" returntype="any">
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

		<cfquery name="updTransferOrder" datasource="#dsn2#">
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
</cfcomponent>