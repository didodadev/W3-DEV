<cf_date tarih="attributes.record_date">
<cfif not isdefined("attributes.audit_id")>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
		<cfquery name="add" datasource="#dsn2#" result="xx">
			INSERT INTO FINANCIAL_AUDIT
			(
				TABLE_NAME,
				TABLE_TYPE,
				PROCESS_STAGE,
				DETAIL,
				RECORD_DATE,
				RECORD_EMP

			)
			VALUES 
			(
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#attributes.table_name#">,
				<cfqueryparam  cfsqltype="cf_sql_integer" value="#attributes.table_type#">,
				<cfqueryparam  cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
				<cfqueryparam  cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">,
				<cfif len(attributes.record_id) and len(attributes.record_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#"></cfif>
			)
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") eq 1>
				<cfquery name="add_row" datasource="#dsn2#">
					INSERT INTO FINANCIAL_AUDIT_ROW
					(
						FINANCIAL_AUDIT_ID,
						CODE,
						NAME,
						ACCOUNT_CODE,
						SIGN,
						BA,
						VIEW_AMOUNT_TYPE,
						IFRS_CODE,
						IS_SHOW,
						IS_CUMULATIVE
					<!---	,NAME_LANG_NO--->
					)
					VALUES 
					(
						<cfqueryparam  cfsqltype="cf_sql_integer" value="#xx.IDENTITYCOL#">,
						<cfif len(evaluate('attributes.code#i#'))><cfqueryparam  cfsqltype="cf_sql_varchar" value="#evaluate('attributes.code#i#')#"><cfelse>NULL</cfif>,
						<cfif len(evaluate('attributes.account_name#i#'))><cfqueryparam  cfsqltype="cf_sql_varchar" value="#evaluate('attributes.account_name#i#')#"><cfelse>NULL</cfif>,
						<cfif (isdefined("is_cumulative#i#") and evaluate('attributes.is_cumulative#i#') eq 0) and len(evaluate('attributes.account_code#i#'))><cfqueryparam  cfsqltype="cf_sql_varchar" value="#evaluate('attributes.account_code#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.sign#i#") and len(evaluate('attributes.sign#i#'))><cfqueryparam  cfsqltype="cf_sql_varchar" value="#evaluate('attributes.sign#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.bakiye#i#") and len(evaluate('attributes.bakiye#i#'))><cfqueryparam  cfsqltype="cf_sql_bit" value="#evaluate('attributes.bakiye#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.view_amount_type#i#") and len(evaluate('attributes.view_amount_type#i#'))><cfqueryparam  cfsqltype="cf_sql_integer" value="#evaluate('attributes.view_amount_type#i#')#"><cfelse>2</cfif>,
						<cfif len(evaluate('attributes.ifrs_code#i#'))><cfqueryparam  cfsqltype="cf_sql_varchar" value="#evaluate('attributes.ifrs_code#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("is_show#i#")>#val(evaluate("is_show#i#"))#<cfelse>0</cfif>,
						<cfif isdefined("is_cumulative#i#") and len(evaluate('attributes.is_cumulative#i#'))><cfqueryparam  cfsqltype="cf_sql_bit" value="#evaluate('attributes.is_cumulative#i#')#"><cfelse>0</cfif>
						<!---,<cfqueryparam  cfsqltype="cf_sql_integer" value="">--->
						
					)
				</cfquery>
			</cfif>
		</cfloop>
		</cftransaction>
		<cfset attributes.audit_id = xx.IDENTITYCOL>
	</cflock>
<cfelse>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
		<cfquery name="add" datasource="#dsn2#">
			UPDATE FINANCIAL_AUDIT
			SET
				TABLE_NAME = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#attributes.table_name#">,
				TABLE_TYPE = <cfqueryparam  cfsqltype="cf_sql_integer" value="#attributes.table_type#">,
				PROCESS_STAGE = <cfqueryparam  cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
				DETAIL = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#attributes.detail#">,
				UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">,
				UPDATE_EMP = <cfif len(attributes.record_id) and len(attributes.record_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#"></cfif>	
			WHERE 
				FINANCIAL_AUDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.audit_id#">
		</cfquery>
		<cfquery name="del_" datasource="#dsn2#">
			DELETE FROM FINANCIAL_AUDIT_ROW WHERE FINANCIAL_AUDIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.audit_id#">
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif evaluate("attributes.row_kontrol#i#") eq 1>
				<cfquery name="add_row" datasource="#dsn2#">
					INSERT INTO FINANCIAL_AUDIT_ROW
					(
						FINANCIAL_AUDIT_ID,
						CODE,
						NAME,
						ACCOUNT_CODE,
						SIGN,
						BA,
						VIEW_AMOUNT_TYPE,
						IFRS_CODE,
						IS_SHOW,
						IS_CUMULATIVE
					<!---	,NAME_LANG_NO--->
					)
					VALUES 
					(
						<cfqueryparam  cfsqltype="cf_sql_integer" value="#attributes.audit_id#">,
						<cfif len(evaluate('attributes.code#i#'))><cfqueryparam  cfsqltype="cf_sql_varchar" value="#evaluate('attributes.code#i#')#"><cfelse>NULL</cfif>,
						<cfif len(evaluate('attributes.account_name#i#'))><cfqueryparam  cfsqltype="cf_sql_varchar" value="#evaluate('attributes.account_name#i#')#"><cfelse>NULL</cfif>,
						<cfif (isdefined("is_cumulative#i#") and evaluate('attributes.is_cumulative#i#') eq 0) and len(evaluate('attributes.account_code#i#'))><cfqueryparam  cfsqltype="cf_sql_varchar" value="#evaluate('attributes.account_code#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.sign#i#") and len(evaluate('attributes.sign#i#'))><cfqueryparam  cfsqltype="cf_sql_varchar" value="#evaluate('attributes.sign#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.bakiye#i#") and  len(evaluate('attributes.bakiye#i#'))><cfqueryparam  cfsqltype="cf_sql_bit" value="#evaluate('attributes.bakiye#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.view_amount_type#i#") and  len(evaluate('attributes.view_amount_type#i#'))><cfqueryparam  cfsqltype="cf_sql_integer" value="#evaluate('attributes.view_amount_type#i#')#"><cfelse>NULL</cfif>,
						<cfif len(evaluate('attributes.ifrs_code#i#'))><cfqueryparam  cfsqltype="cf_sql_varchar" value="#evaluate('attributes.ifrs_code#i#')#"><cfelse>NULL</cfif>,
						<cfif isdefined("is_show#i#")>#val(evaluate("is_show#i#"))#<cfelse>0</cfif>,
						<cfif isdefined("is_cumulative#i#") and len(evaluate('attributes.is_cumulative#i#'))><cfqueryparam  cfsqltype="cf_sql_bit" value="#evaluate('attributes.is_cumulative#i#')#"><cfelse>0</cfif>
						<!---,<cfqueryparam  cfsqltype="cf_sql_integer" value="">--->
						
					)
				</cfquery>
			</cfif>
		</cfloop>
		</cftransaction>
	</cflock>
</cfif>
<script>
	window.location.href= "<cfoutput>#request.self#?fuseaction=account.financial_audit_table_definition&event=upd&audit_id=#attributes.audit_id#</cfoutput>";
</script>
