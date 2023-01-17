<cfset dsn = application.systemParam.systemParam().dsn>
<cffunction name="get_table_def_fnc" returntype="query">
	<cfargument name="table_code_type" default="">
	<cfargument name="process_stage" default="">
	<cfargument name="table_TYPE" default="">
	<cfargument name="is_show" default="0">
	<cfquery name="get_table_def" datasource="#this.dsn2#">
		SELECT
			 FA.FINANCIAL_AUDIT_ID,
			 FAR.FINANCIAL_AUDIT_ROW_ID,
			 FAR.CODE,
			 FAR.NAME,
			 FAR.NAME_LANG_NO,
			<cfif isdefined('attributes.table_code_type') and attributes.table_code_type eq 1>
				IFRS_CODE AS ACCOUNT_CODE,
			<cfelse>
				ACCOUNT_CODE,
			</cfif>
			SIGN,BA,VIEW_AMOUNT_TYPE
		FROM
			FINANCIAL_AUDIT FA
			JOIN FINANCIAL_AUDIT_ROW FAR ON FA.FINANCIAL_AUDIT_ID = FAR.FINANCIAL_AUDIT_ID
		WHERE
			<cfif arguments.is_show eq 1>
				(FAR.IS_SHOW = 1 OR
				<cfif isdefined('attributes.table_code_type') and attributes.table_code_type eq 1>
					IFRS_CODE IS NULL
				<cfelse>
					ACCOUNT_CODE IS NULL
				</cfif>
				)
			<cfelse>
				1 = 1 
			</cfif>
			<cfif len(arguments.process_stage)>
				AND PROCESS_STAGE =  <cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
			</cfif>
			<cfif len(arguments.table_TYPE)>
				AND TABLE_TYPE =  <cfqueryparam  cfsqltype="cf_sql_VARCHAR" value="#arguments.table_TYPE#">
			</cfif>
		ORDER BY 
			FAR.CODE 
	</cfquery>
	<cfreturn get_table_def>
</cffunction>
<cffunction name="get_table_audit_fnc" returntype="query">
	<cfargument name="audit_id" default="">
	<cfquery name="get_table_audit" datasource="#this.dsn2#">
		SELECT * FROM FINANCIAL_AUDIT WHERE FINANCIAL_AUDIT_ID = <cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.audit_id#">
	</cfquery>
	<cfreturn get_table_audit>
</cffunction>
<cffunction name="get_period_list_fnc" returntype="query">
	<cfquery name="GET_PERIOD_LIST" datasource="#DSN#">
		SELECT 
			PERIOD_ID,PERIOD_YEAR 
		FROM 
			SETUP_PERIOD 
		WHERE 
			OUR_COMPANY_ID=#session.ep.company_id#
		ORDER BY 
			PERIOD_YEAR DESC
	</cfquery>
	<cfreturn GET_PERIOD_LIST>
</cffunction>
<cffunction name="get_table_audit_row_fnc" returntype="query">
	<cfargument name="audit_id" default="">
	<cfquery name="get_table_audit_row" datasource="#this.dsn2#">
		SELECT * FROM FINANCIAL_AUDIT_ROW WHERE FINANCIAL_AUDIT_ID = <cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.audit_id#">
	</cfquery>
	<cfreturn get_table_audit_row>
</cffunction>
<cffunction name="get_table_copies_fnc" returntype="query">
	<cfargument name="table_id" default="">
	<cfquery name="get_table_copies" datasource="#this.dsn2#">
		SELECT * FROM FINANCIAL_TABLES_COPIES
		<cfif isdefined("arguments.table_id") and len(arguments.table_id)>
			WHERE FINANCIAL_TABLE_ID = <cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.table_id#">
		</cfif>
	</cfquery>
	<cfreturn get_table_copies>
</cffunction>
<cffunction name="get_table_copies_list_fnc" returntype="query">
	<cfargument name="keyword" default="">
	<cfargument name="copy_name" default="">
	<cfargument name="table_code_type" default="">
	<cfargument name="copy_date" default="">
	<cfargument name="emp_id" default="">
	<cfargument name="PROCESS_STAGE" default="">
	<cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
	<cfquery name="get_table_copies" datasource="#this.dsn2#">
		WITH CTE1 AS (
			SELECT 
				FA.*,
				(SELECT STAGE FROM #this.DSN_ALIAS#.PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = FA.PROCESS_STAGE) AS STAGE
			FROM 
				FINANCIAL_TABLES_COPIES FA
			WHERE
			1 = 1
			<cfif len(arguments.copy_date)>
				AND ARRANGEMENT_DATE =  <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#arguments.copy_date#">
			</cfif>
			<cfif len(arguments.copy_name)>
				AND TABLE_NAME LIKE <cfqueryparam  cfsqltype="cf_sql_varchar" value="%#arguments.copy_name#%">
			</cfif>
			<cfif len(arguments.process_stage)>
				AND PROCESS_STAGE =  <cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
			</cfif>
			<cfif len(arguments.table_code_type)>
				AND IS_IFRS =  <cfqueryparam  cfsqltype="cf_sql_bit" value="#arguments.table_code_type#">
			</cfif>
		),
		CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (
											ORDER BY FINANCIAL_TABLE_ID
                            			) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
	</cfquery>
	<cfreturn get_table_copies>
</cffunction>
<cffunction name="upd_table_copies_fnc" returntype="void">
	<cfargument name="financial_table_id" default="">
	<cfargument name="name" default="">
	<cfargument name="is_ifrs" default="">
	<cfargument name="process_stage" default="">
	<cfargument name="copy_date" default="">
	<cfargument name="emp_id" default="">
	<cfquery name="add_table_copies" datasource="#this.dsn2#">
		UPDATE FINANCIAL_TABLES_COPIES 
		SET 
			TABLE_NAME = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.name#">,
			PROCESS_STAGE = <cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.PROCESS_STAGE#">,
			IS_IFRS = <cfqueryparam  cfsqltype="cf_sql_bit" value="#arguments.is_ifrs#">,
			ARRANGEMENT_DATE = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#arguments.copy_date#">,
			ARRANGEMENT_EMP = <cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.emp_id#">,
			UPDATE_DATE = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#now()#">,
			UPDATE_EMP = <cfqueryparam  cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		WHERE
			FINANCIAL_TABLE_ID = <cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.financial_table_id#">
	</cfquery>
</cffunction>
<cffunction name="add_table_copies_fnc" returntype="any">
	<cfargument name="name" default="">
	<cfargument name="is_ifrs" default="">
	<cfargument name="process_stage" default="">
	<cfargument name="copy_date" default="">
	<cfargument name="emp_id" default="">
		<cfquery name="add_table_copies" datasource="#this.dsn2#" result="xx">
			INSERT INTO FINANCIAL_TABLES_COPIES
			(
				TABLE_NAME,
				IS_IFRS,
				PROCESS_STAGE,
				RECORD_DATE,
				RECORD_EMP,
				ARRANGEMENT_DATE,
				ARRANGEMENT_EMP
			)
			VALUES
			(
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.name#">,
				<cfqueryparam  cfsqltype="cf_sql_bit" value="#arguments.is_ifrs#">,
				<cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.PROCESS_STAGE#">,
				<cfqueryparam  cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam  cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam  cfsqltype="cf_sql_timestamp" value="#arguments.copy_date#">,
				<cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.emp_id#">
			)
		</cfquery>
		<cfset max_id = xx.IDENTITYCOL>
		<cfsavecontent  variable="table_path">
			<cfoutput>
				<cfif arguments.is_ifrs eq 1>#this.dsn2#.ACCOUNT_ROWS_IFRS_<cfelse>#this.dsn2#.ACCOUNT_CARD_ROWS</cfif>COPY#max_id#
			</cfoutput>
		</cfsavecontent>
		<cfquery name="add_table_copies" datasource="#this.dsn2#">
			SELECT *
			INTO #table_path#
			FROM 
				<cfif arguments.is_ifrs eq 1>
					ACCOUNT_ROWS_IFRS
				<cfelse>
					ACCOUNT_CARD_ROWS
				</cfif>
		</cfquery>
		<cfquery name="upd_" datasource="#this.dsn2#">
			UPDATE FINANCIAL_TABLES_COPIES SET TABLE_PATH = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#table_path#"> 
			WHERE FINANCIAL_TABLE_ID = <cfqueryparam  cfsqltype="cf_sql_integer" value="#max_id#">
		</cfquery>
	<cfreturn max_id>
</cffunction>
<cffunction name="get_definitions_fnc" returntype="query">
	<cfargument name="table_name" default="">
	<cfargument name="table_TYPE" default="">
	<cfargument name="PROCESS_STAGE" default="">
	<cfargument name="record_date" default="">
	<cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
	<cfquery name="get_definitions" datasource="#this.dsn2#">
	 WITH CTE1 AS (
		SELECT 
			FA.*,
			(SELECT STAGE FROM #this.DSN_ALIAS#.PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = FA.PROCESS_STAGE) AS STAGE
		from 
			FINANCIAL_AUDIT FA
		WHERE
			1 = 1
			<cfif len(arguments.table_name)>
				AND TABLE_NAME =  <cfqueryparam  cfsqltype="cf_sql_VARCHAR" value="#arguments.table_name#">
			</cfif>
			<cfif len(arguments.table_TYPE)>
				AND TABLE_TYPE =  <cfqueryparam  cfsqltype="cf_sql_VARCHAR" value="#arguments.table_TYPE#">
			</cfif>
			<cfif len(arguments.PROCESS_STAGE)>
				AND PROCESS_STAGE =  <cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.PROCESS_STAGE#">
			</cfif>
			<cfif len(arguments.record_date)>
				AND RECORD_DATE =  <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#arguments.record_date#">
			</cfif>
		),
		CTE2 AS (
				SELECT
					CTE1.*,
					ROW_NUMBER() OVER (
											ORDER BY TABLE_TYPE
                            			) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
	</cfquery>
	<cfreturn get_definitions>
</cffunction>