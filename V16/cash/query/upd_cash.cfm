<cflock timeout="60">
	<cftransaction>
		<cfquery name="UPD_CASH" datasource="#DSN2#">
			UPDATE
				CASH
			SET
				CASH_STATUS = <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,	
				CASH_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CASH_NAME#">,
				CASH_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CASH_CODE#">,
				CASH_ACC_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ACCOUNT_ID#">,
				A_CHEQUE_ACC_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.a_cheque_account_id#">,
				BRANCH_ID = #attributes.BRANCH_ID#,
				A_VOUCHER_ACC_CODE = <cfif len(attributes.a_voucher_account_id) and len(attributes.a_voucher_account_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.a_voucher_account_id#"><cfelse>NULL</cfif>,
                V_VOUCHER_ACC_CODE = <cfif len(attributes.v_voucher_account_id) and len(attributes.v_voucher_account_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.v_voucher_account_id#"><cfelse>NULL</cfif>,
				DUE_DIFF_ACC_CODE = <cfif len(attributes.due_account_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.due_account_id#"><cfelse>NULL</cfif>,
				TRANSFER_CHEQUE_ACC_CODE = <cfif len(attributes.cheque_transfer_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cheque_transfer_account_id#"><cfelse>NULL</cfif>,
				TRANSFER_VOUCHER_ACC_CODE = <cfif len(attributes.voucher_transfer_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.voucher_transfer_account_id#"><cfelse>NULL</cfif>,
				<cfif isDefined('attributes.DEPARTMENT_ID') and len(attributes.DEPARTMENT_ID)>
					DEPARTMENT_ID = #attributes.DEPARTMENT_ID#,
				<cfelse>
					DEPARTMENT_ID = NULL,
				</cfif>
				EMP_ID = <cfif len(attributes.cash_emp_id)>#attributes.cash_emp_id#<cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				UPDATE_DATE = #now()#,
				IS_ALL_BRANCH = <cfif isDefined('attributes.is_all_branch')>1<cfelse>0</cfif>,
				IS_WHOPS = <cfif isDefined('attributes.is_whops')>1<cfelse>0</cfif>,
				PROTESTOLU_SENETLER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.protestolu_senetler_id#">,
				KARSILIKSIZ_CEKLER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.karsiliksiz_cekler_id#">
			WHERE
				CASH_ID = #attributes.id#
		</cfquery>	
	</cftransaction>
</cflock>
<cfset attributes.actionId = attributes.id>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=cash.list_cashes&event=upd&ID=<cfoutput>#attributes.actionId#</cfoutput>';
</script>