<!--- muhasebe kalemleri icin query--->
<cfset cmp = createObject("component","V16.hr.ehesap.cfc.periods_to_in_out") />
<cfset get_acc_type = cmp.setup_acc_type()>
<cfif isdefined("attributes.record_num")>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cflock name="#createUUID()#" timeout="60">		
			<cftransaction>
			<cfset cmp = createObject("component","V16.hr.ehesap.cfc.periods_to_in_out") />
			<cfset sonuc = cmp.get_period_control(in_out_id:evaluate('attributes.in_out_id#i#'),period_id:attributes.period_id)>
			<cfif sonuc.recordcount><!--- Kayıt varsa--->
			<cfset cmp.upd_inout_period(
				period_code_cat:evaluate('period_code_cat#i#'),
				expense_item_id:evaluate('expense_item_id#i#'),
				expense_item_name:evaluate('expense_item_name#i#'),
				expense_center_id:evaluate('expense_center_id#i#'),
				expense_code:evaluate('expense_code#i#'),
				expense_code_name:evaluate('expense_code_name#i#'),
				in_out_id:evaluate('in_out_id#i#'),
				period_id:attributes.period_id
			)>
			<cfelse>
			<cfset cmp.add_inout_period(
				period_code_cat:evaluate('period_code_cat#i#'),
				expense_item_id:evaluate('expense_item_id#i#'),
				expense_item_name:evaluate('expense_item_name#i#'),
				expense_center_id:evaluate('expense_center_id#i#'),
				expense_code:evaluate('expense_code#i#'),
				expense_code_name:evaluate('expense_code_name#i#'),
				in_out_id:evaluate('in_out_id#i#'),
				period_id:attributes.period_id
			)>
			</cfif>
			
			<!---ilişkili hesaplar ekleme --->
			<cfquery name="del_rows" datasource="#dsn#">
				DELETE FROM EMPLOYEES_ACCOUNTS WHERE EMPLOYEE_ID = #evaluate('employee_id#i#')# AND IN_OUT_ID = #evaluate('in_out_id#i#')# AND PERIOD_ID = #attributes.period_id#
			</cfquery>
			<cfloop query="get_acc_type">
				<cfif len(evaluate('account_code_#get_acc_type.currentrow#_#i#')) and len(evaluate('account_name_#get_acc_type.currentrow#_#i#'))>
					<cfif Evaluate("acc_type_id_#get_acc_type.currentrow#_#i#") eq -1>
						<cfquery name="upd_" datasource="#dsn#">
							UPDATE
								EMPLOYEES_IN_OUT_PERIOD
							SET
								ACCOUNT_CODE = <cfif len(evaluate('account_code_#get_acc_type.currentrow#_#i#'))>'#evaluate('account_code_#get_acc_type.currentrow#_#i#')#'<cfelse>NULL</cfif>
							WHERE
								IN_OUT_ID  = #evaluate('in_out_id#i#')# AND
								PERIOD_ID = #attributes.period_id#
						</cfquery>
					</cfif>
					<cfset cmp.add_emp_accounts(
						acc_type_id:evaluate('acc_type_id_#get_acc_type.currentrow#_#i#'),
						account_code:evaluate('account_code_#get_acc_type.currentrow#_#i#'),
						period_id:attributes.period_id,
						in_out_id:evaluate('in_out_id#i#'),
						employee_id:evaluate('employee_id#i#')
					)>
				</cfif>
			</cfloop>
			<!---//ilişkili hesaplar son --->
			</cftransaction>
		</cflock>
	</cfloop>
</cfif>
<script type="text/javascript">
	history.go(-1);
</script>
