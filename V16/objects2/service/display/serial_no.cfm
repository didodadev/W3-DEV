<cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no)>
	<cfquery name="GET_SEARCH_RESULTS_FREE" datasource="#DSN3#" maxrows="1">
		SELECT 
			SG.SALE_START_DATE,
            SG.SALE_FINISH_DATE,
            SG.PROCESS_ID,
            SG.SERIAL_NO,
            SG.STOCK_ID,
            SG.PROCESS_ID,
            SG.GUARANTY_ID,
            SG.IS_SALE,
            SG.SALE_GUARANTY_CATID,
           	SG.PROCESS_CAT,
            SG.SALE_CONSUMER_ID,
            SG.IS_PURCHASE,
            SG.IN_OUT,
            SG.IS_RETURN,
            SG.IS_RMA,
            SG.IS_SERVICE,
			SG.IS_TRASH,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			D.DEPARTMENT_HEAD,
			S.PRODUCT_NAME
		FROM 
			SERVICE_GUARANTY_NEW SG,
			STOCKS S,
			#DSN_ALIAS#.EMPLOYEES E,
			#DSN_ALIAS#.DEPARTMENT D
		WHERE 
			(SALE_COMPANY_ID IS NOT NULL OR SALE_CONSUMER_ID IS NOT NULL) AND
			SG.RECORD_EMP = E.EMPLOYEE_ID
			AND SG.DEPARTMENT_ID = D.DEPARTMENT_ID
			AND SG.STOCK_ID = S.STOCK_ID
			AND SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">
		ORDER BY GUARANTY_ID DESC
	</cfquery>
	<cfquery name="GET_SEARCH_RESULTS_" datasource="#DSN3#" maxrows="1">
		SELECT 
			SG.SALE_START_DATE,
            SG.SALE_FINISH_DATE,
            SG.PROCESS_ID,
            SG.SERIAL_NO,
            SG.STOCK_ID,
            SG.PROCESS_ID,
            SG.GUARANTY_ID,
            SG.IS_SALE,
            SG.SALE_GUARANTY_CATID,
           	SG.PROCESS_CAT,
            SG.SALE_CONSUMER_ID,
            SG.IS_PURCHASE,
            SG.IN_OUT,
            SG.IS_RETURN,
            SG.IS_RMA,
            SG.IS_SERVICE,
			SG.IS_TRASH,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			D.DEPARTMENT_HEAD,
			S.PRODUCT_NAME
		FROM 
			SERVICE_GUARANTY_NEW SG,
			STOCKS S,
			#DSN_ALIAS#.EMPLOYEES E,
			#DSN_ALIAS#.DEPARTMENT D
		WHERE 
			<cfif isdefined("session.pp.userid")>
				(SALE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR PURCHASE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">) AND
			<cfelseif isdefined("session.ww.userid")>
				(SALE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR PURCHASE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">) AND
			<cfelse>
				1 = 0 AND
			</cfif>
			SG.RECORD_EMP = E.EMPLOYEE_ID AND 
			SG.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			SG.STOCK_ID = S.STOCK_ID AND
			SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">
		ORDER BY GUARANTY_ID DESC
	</cfquery>

	<cfif get_search_results_.recordcount and len(get_search_results_.process_id)>
		<cfquery name="GET_RELATED_RESULTS_" datasource="#DSN3#">
			SELECT 
				SG.SALE_START_DATE,
            	SG.SALE_FINISH_DATE,
            	SG.GUARANTY_ID,
            	SG.IS_SALE,
            	SG.SALE_GUARANTY_CATID,
                SG.PROCESS_CAT,
            	SG.SALE_CONSUMER_ID,
            	SG.IS_PURCHASE,
                SG.IN_OUT,
            	SG.IS_RETURN,
                SG.IS_RMA,
              	SG.IS_SERVICE,
				SG.IS_TRASH,
                E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				D.DEPARTMENT_HEAD,
				S.PRODUCT_NAME
			FROM 
				SERVICE_GUARANTY_NEW SG,
				STOCKS S,
				#DSN_ALIAS#.EMPLOYEES E,
				#DSN_ALIAS#.DEPARTMENT D
			WHERE 
				<cfif isdefined("session.pp.userid")>
					(SALE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR PURCHASE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">) AND
				<cfelseif isdefined("session.ww.userid")>
					(SALE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> OR PURCHASE_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">) AND
				<cfelse>
					1 = 0 AND
				</cfif>
				SG.RECORD_EMP = E.EMPLOYEE_ID AND 
				SG.DEPARTMENT_ID = D.DEPARTMENT_ID AND 
				SG.STOCK_ID = S.STOCK_ID AND 
				RETURN_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_search_results_.serial_no#"> AND 
				RETURN_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_search_results_.stock_id#"> AND 
				RETURN_PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_.process_id#"> 
			ORDER BY GUARANTY_ID DESC
		</cfquery>
	</cfif>
</cfif>
<cfinclude template="serial_number.cfm">
<br/>
<cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no) and (get_search_results_.recordcount or get_search_results_free.recordcount)>
	<cfinclude template="serial_no_last_row.cfm">
	<cfif (isdefined("session.pp.userid") or isdefined("session.ww.userid")) and get_search_results_.recordcount>
		<br/>
		<cfinclude template="serial_no_history.cfm">
		<br/>
		<cfif isdefined("get_related_results_") and get_related_results_.recordcount>
			<cfinclude template="serial_no_process_rows.cfm">
		</cfif>	
		<cfinclude template="list_serial_services.cfm">
		<!--- <cfelse> --->
		<br/>
		<cfinclude template="serial_no_service_status.cfm">
	</cfif>
</cfif>
<cfif isdefined("session.pp.our_company_id") and len(session.pp.our_company_id)>
	<cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no) and get_search_results_.recordcount>
		<br/>
		<cf_get_workcube_note company_id="#session.pp.our_company_id#" style="1" action_section='GUARANTY_SERIAL_NO' action_id='#attributes.product_serial_no#' action_type='1'>
	</cfif>				
</cfif>

