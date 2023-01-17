<cflock timeout="60">
	<cftransaction>
		<cfquery name="ADD_CASH" datasource="#dsn2#" result="MAXID">
			INSERT INTO
				CASH
				(
					CASH_STATUS,
					CASH_NAME,
					CASH_CODE,
					CASH_ACC_CODE,
					A_CHEQUE_ACC_CODE,
					CASH_CURRENCY_ID,
					BRANCH_ID,
					ISOPEN,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					DEPARTMENT_ID,
					A_VOUCHER_ACC_CODE,
					V_VOUCHER_ACC_CODE,
					DUE_DIFF_ACC_CODE,
					TRANSFER_CHEQUE_ACC_CODE,
					TRANSFER_VOUCHER_ACC_CODE,
					EMP_ID,
					IS_ALL_BRANCH,
					IS_WHOPS,
					PROTESTOLU_SENETLER_CODE,
					KARSILIKSIZ_CEKLER_CODE
				)
				VALUES
				(
					<cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CASH_NAME#">,
					<cfif isDefined("attributes.CASH_CODE")  and len(attributes.CASH_CODE)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CASH_CODE#">,
					<cfelse>
					NULL,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.a_cheque_account_id#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CURRENCY_ID#">,
					#attributes.BRANCH_ID#,
					0,
					#SESSION.EP.USERID#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
					#NOW()#
					<cfif isDefined('attributes.DEPARTMENT_ID') and len(attributes.DEPARTMENT_ID)>
						,#attributes.DEPARTMENT_ID#
					<cfelse>
						,NULL
					</cfif>
					,<cfif len(attributes.a_voucher_account_id) and len(attributes.a_voucher_account_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.a_voucher_account_id#"><cfelse>NULL</cfif>
					,<cfif len(attributes.v_voucher_account_id) and len(attributes.v_voucher_account_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.v_voucher_account_id#"><cfelse>NULL</cfif>
					,<cfif len(attributes.due_account_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.due_account_id#"><cfelse>NULL</cfif>
					,<cfif len(attributes.cheque_transfer_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cheque_transfer_account_id#"><cfelse>NULL</cfif>
					,<cfif len(attributes.voucher_transfer_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.voucher_transfer_account_id#"><cfelse>NULL</cfif>
					,<cfif len(attributes.cash_emp_id)>#attributes.cash_emp_id#<cfelse>NULL</cfif>
					,<cfif isDefined('attributes.is_all_branch')>1<cfelse>0</cfif>
					,<cfif isDefined('attributes.is_whops')>1<cfelse>0</cfif>
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.protestolu_senetler_id#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.karsiliksiz_cekler_id#">
				)
		</cfquery>
	</cftransaction>
</cflock>
<cfset attributes.actionId = MAXID.IdentityCol>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=cash.list_cashes&event=upd&ID=<cfoutput>#MAXID.IdentityCol#</cfoutput>';
</script>