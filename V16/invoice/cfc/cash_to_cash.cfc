
<cfcomponent  extends="cfc.faFunctions">
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn1 = dsn & "_product">
    <cfset dsn2 = dsn & "_" & session.ep.period_year & "_" & session.ep.company_id>
    <cfset dsn3 = dsn & "_" & session.ep.company_id>
    <cfset dsn3_alias = dsn & "_" & session.ep.company_id>
    <cfset dsn_alias = dsn >
    <cfset dsn1_alias = dsn & "_product">
	<cfscript>
		functions = CreateObject("component","WMO.functions");
		filterNum = functions.filterNum;
        wrk_round = functions.wrk_round;
        getlang = functions.getlang;
	</cfscript>
    <cffunction name="get_pos_equipment" access="public" returntype="query">
        <cfquery name="get_pos_equipment" datasource="#DSN3#">
            SELECT EQUIPMENT, POS_ID,BRANCH_ID FROM POS_EQUIPMENT
        </cfquery>
        <cfreturn get_pos_equipment>
    </cffunction>
	<cffunction name="get_pos_cash" access="public" returntype="query">
		<cfargument name="pos_id" default="">
		<cfquery name="get_pos_equipment" datasource="#DSN3#">
            SELECT BRANCH_ID FROM POS_EQUIPMENT WHERE POS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_id#">
        </cfquery>
        <cfquery name="get_pos_cash" datasource="#dsn2#">
            SELECT CASH_ID,CASH_NAME FROM CASH WHERE IS_WHOPS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos_equipment.branch_id#">
        </cfquery>
        <cfreturn get_pos_cash>
    </cffunction>
    <cffunction name="get_branch" access="public" returntype="query">
        <cfquery name="get_branches" datasource="#dsn#">
			SELECT 
            	BRANCH_ID,
                BRANCH_NAME,
                COMPANY_ID
			FROM 
            	BRANCH 
			WHERE 
				1=1
                <cfif not session.ep.ehesap>
					AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
				</cfif>
             ORDER BY 
             	BRANCH_NAME        
        </cfquery>
  		<cfreturn get_branches>
	</cffunction>
    <cffunction name="add_cash"  access="remote" returntype="any">
		<cfset attributes = arguments>
        <cfset form = arguments>
		<cfif isdefined("attributes.delivery_date") and len(attributes.delivery_date)>
			<cf_date tarih="attributes.delivery_date">
		</cfif>
        <cfset responseStruct = structNew()>
		<cftry>
				<cfquery name="add_cash" datasource="#DSN2#">
					INSERT INTO
						STORE_REPORT
						(
							POS_ID,
							CASH_ID,
							CASH_TL,
							CASH_USD,
							CASH_EURO,
							DELIVERED_TL,
							DELIVERED_USD,
							DELIVERED_EURO,
							REMAINING_TRANSFERRED_TL,
							REMAINING_TRANSFERRED_USD,
							REMAINING_TRANSFERRED_EURO,
							DELIVERY_EMP_ID,
							RECEIVER_EMP_ID,
							STORE_REPORT_DATE,<!--- teslim tarihi --->
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP
						)
						VALUES
						(
							<cfif isDefined("attributes.whops_pos_id") and len(attributes.whops_pos_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.whops_pos_id#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.whops_cash_id") and len(attributes.whops_cash_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.whops_cash_id#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.cash_TL") and len(attributes.cash_TL)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.cash_TL,4)#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.cash_USD") and len(attributes.cash_USD)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.cash_USD,4)#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.cash_EURO") and len(attributes.cash_EURO)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.cash_EURO,4)#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.delivered_TL") and len(attributes.delivered_TL)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.delivered_TL,4)#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.delivered_USD") and len(attributes.delivered_USD)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.delivered_USD,4)#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.delivered_EURO") and len(attributes.delivered_EURO)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.delivered_EURO,4)#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.remaining_transferred_TL") and len(attributes.remaining_transferred_TL)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.remaining_transferred_TL,4)#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.remaining_transferred_USD") and len(attributes.remaining_transferred_USD)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.remaining_transferred_USD,4)#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.remaining_transferred_EURO") and len(attributes.remaining_transferred_EURO)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.remaining_transferred_EURO,4)#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.delivery_emp_id") and len(attributes.delivery_emp_id) and isDefined("attributes.delivery_emp") and len(attributes.delivery_emp)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delivery_emp_id#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.receiver_emp_id") and len(attributes.receiver_emp_id) and isDefined("attributes.receiver_emp") and len(attributes.receiver_emp)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiver_emp_id#"><cfelse>NULL</cfif>,
							<cfif isDefined("attributes.delivery_date") and len(attributes.delivery_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.delivery_date#"><cfelse>NULL</cfif>,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
						)
				</cfquery>
				<cfquery name="GET_MAX" datasource="#dsn2#" maxrows="1">
					SELECT TOP 1 * FROM STORE_REPORT   
					ORDER BY 
					STORE_REPORT_ID DESC
				</cfquery>
				<cfset responseStruct.message = "İşlem Başarılı">
				<cfset responseStruct.status = true>
				<cfset responseStruct.error = {}>
				<cfset responseStruct.identity = '#GET_MAX.STORE_REPORT_ID#'>
			<cfcatch type="database">
				<cftransaction action="rollback">
				<cfset responseStruct.message = "İşlem Hatalı">
				<cfset responseStruct.status = false>
				<cfset responseStruct.error = cfcatch>
				<cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>
        <cfreturn responseStruct>
    </cffunction>
	<cffunction name="upd_cash" access="remote" returntype="any">
		<cfset attributes = arguments>
        <cfset form = arguments>
		<cfif isdefined("attributes.delivery_date") and len(attributes.delivery_date)>
			<cf_date tarih="attributes.delivery_date">
		</cfif>
        <cfset responseStruct = structNew()>
		<cftry>
			<cfquery name="upd_cash" datasource="#dsn2#">
				UPDATE
					STORE_REPORT
				SET
					POS_ID= <cfif isDefined("attributes.whops_pos_id") and len(attributes.whops_pos_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.whops_pos_id#"><cfelse>NULL</cfif>,
					CASH_ID = <cfif isDefined("attributes.whops_cash_id") and len(attributes.whops_cash_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.whops_cash_id#"><cfelse>NULL</cfif>,
					CASH_TL= <cfif isDefined("attributes.cash_TL") and len(attributes.cash_TL)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.cash_TL,4)#"><cfelse>NULL</cfif>,
					CASH_USD= <cfif isDefined("attributes.cash_USD") and len(attributes.cash_USD)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.cash_USD)#"><cfelse>NULL</cfif>,
					CASH_EURO= <cfif isDefined("attributes.cash_EURO") and len(attributes.cash_EURO)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.cash_EURO)#"><cfelse>NULL</cfif>,
					DELIVERED_TL= <cfif isDefined("attributes.delivered_TL") and len(attributes.delivered_TL)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.delivered_TL)#"><cfelse>NULL</cfif>,
					DELIVERED_USD= <cfif isDefined("attributes.delivered_USD") and len(attributes.delivered_USD)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.delivered_USD)#"><cfelse>NULL</cfif>,
					DELIVERED_EURO= <cfif isDefined("attributes.delivered_EURO") and len(attributes.delivered_EURO)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.delivered_EURO)#"><cfelse>NULL</cfif>,
					REMAINING_TRANSFERRED_TL= <cfif isDefined("attributes.remaining_transferred_TL") and len(attributes.remaining_transferred_TL)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.remaining_transferred_TL)#"><cfelse>NULL</cfif>,
					REMAINING_TRANSFERRED_USD= <cfif isDefined("attributes.remaining_transferred_USD") and len(attributes.remaining_transferred_USD)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.remaining_transferred_USD)#"><cfelse>NULL</cfif>,
					REMAINING_TRANSFERRED_EURO= <cfif isDefined("attributes.remaining_transferred_EURO") and len(attributes.remaining_transferred_EURO)><cfqueryparam cfsqltype="cf_sql_float" value="#filternum(attributes.remaining_transferred_EURO)#"><cfelse>NULL</cfif>,
					DELIVERY_EMP_ID= <cfif isDefined("attributes.delivery_emp_id") and len(attributes.delivery_emp_id) and isDefined("attributes.delivery_emp") and len(attributes.delivery_emp)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.delivery_emp_id#"><cfelse>NULL</cfif>,
					RECEIVER_EMP_ID= <cfif isDefined("attributes.receiver_emp_id") and len(attributes.receiver_emp_id) and isDefined("attributes.receiver_emp") and len(attributes.receiver_emp)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiver_emp_id#"><cfelse>NULL</cfif>,
					STORE_REPORT_DATE= <cfif isDefined("attributes.delivery_date") and len(attributes.delivery_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.delivery_date#"><cfelse>NULL</cfif>,
					UPDATE_DATE= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					UPDATE_IP= <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					UPDATE_EMP= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
				WHERE
					STORE_REPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.store_report_id#">
			</cfquery>
				<cfset responseStruct.message = "İşlem Başarılı">
				<cfset responseStruct.status = true>
				<cfset responseStruct.error = {}>
				<cfset responseStruct.identity = ''>
			<cfcatch type="database">
				<cftransaction action="rollback">
				<cfset responseStruct.message = "İşlem Hatalı">
				<cfset responseStruct.status = false>
				<cfset responseStruct.error = cfcatch>
			</cfcatch>
		</cftry>
        <cfreturn responseStruct>
	</cffunction>
	<cffunction name="del_cash" access="remote" returntype="any">
		<cfset attributes = arguments>
        <cfset form = arguments>
        <cfset responseStruct = structNew()>
		<cftry>
			<cfquery name="del_cash" datasource="#dsn2#">
				DELETE FROM STORE_REPORT WHERE STORE_REPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.store_report_id#">
			</cfquery>
				<cfset responseStruct.message = "İşlem Başarılı">
				<cfset responseStruct.status = true>
				<cfset responseStruct.error = {}>
				<cfset responseStruct.identity = ''>
			<cfcatch type="database">
				<cftransaction action="rollback">
				<cfset responseStruct.message = "İşlem Hatalı">
				<cfset responseStruct.status = false>
				<cfset responseStruct.error = cfcatch>
			</cfcatch>
		</cftry>
        <cfreturn responseStruct>
	</cffunction>
	<cffunction name="get_cash" access="remote" returntype="query">
		<cfargument name="pos_id" default="">
		<cfargument name="cash_id" default="">
		<cfargument name="branch_id" default="">
		<cfargument name="delivery_start_date" default="">
		<cfargument name="delivery_finish_date" default="">
		<cfquery name="get_cash" datasource="#dsn2#">
			SELECT
				STORE_REPORT_ID,
				SR.POS_ID,
				SR.CASH_ID,
				CASH_TL,
				CASH_USD,
				CASH_EURO,
				DELIVERED_TL,
				DELIVERED_USD,
				DELIVERED_EURO,
				REMAINING_TRANSFERRED_TL,
				REMAINING_TRANSFERRED_USD,
				REMAINING_TRANSFERRED_EURO,
				DELIVERY_EMP_ID,
				RECEIVER_EMP_ID,
				STORE_REPORT_DATE,
				PE.EQUIPMENT,
				B.BRANCH_NAME,
				C.CASH_NAME
			FROM
				STORE_REPORT SR
				LEFT JOIN #dsn3_alias#.POS_EQUIPMENT PE ON PE.POS_ID = SR.POS_ID
				LEFT JOIN CASH C ON C.CASH_ID = SR.CASH_ID
				LEFT JOIN #dsn_alias#.BRANCH B ON B.BRANCH_ID = PE.BRANCH_ID
			WHERE
				1=1
				<cfif isDefined("arguments.pos_id") and len(arguments.pos_id)> 
					AND SR.POS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pos_id#">
				</cfif>
				<cfif isDefined("arguments.cash_id") and len(arguments.cash_id)> 
					AND SR.CASH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cash_id#">
				</cfif>
				<cfif isDefined("arguments.branch_id") and len(arguments.branch_id)> 
					AND PE.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.branch_id#">
				</cfif>
				<cfif isDefined("arguments.delivery_start_date") and len(arguments.delivery_start_date)> 
					AND SR.STORE_REPORT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.delivery_start_date#">
				</cfif>
				<cfif isDefined("arguments.delivery_finish_date") and len(arguments.delivery_finish_date)> 
					AND SR.STORE_REPORT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.delivery_finish_date#">
				</cfif>
		</cfquery>
        <cfreturn get_cash>
	</cffunction>
	<cffunction name="get_store_report" access="remote" returntype="query">
		<cfargument name="store_report_id" default="">
		<cfquery name="get_store_report" datasource="#dsn2#">
			SELECT
				STORE_REPORT_ID,
				SR.POS_ID,
				SR.CASH_ID,
				CASH_TL,
				CASH_USD,
				CASH_EURO,
				DELIVERED_TL,
				DELIVERED_USD,
				DELIVERED_EURO,
				REMAINING_TRANSFERRED_TL,
				REMAINING_TRANSFERRED_USD,
				REMAINING_TRANSFERRED_EURO,
				DELIVERY_EMP_ID,
				RECEIVER_EMP_ID,
				STORE_REPORT_DATE,
				UPDATE_EMP,
				UPDATE_IP,
				UPDATE_DATE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			FROM
				STORE_REPORT SR
			WHERE
				STORE_REPORT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.store_report_id#">
		</cfquery>
        <cfreturn get_store_report>
	</cffunction>
</cfcomponent>