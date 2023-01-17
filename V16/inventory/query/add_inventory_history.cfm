<cf_date tarih='attributes.action_date'>
<cflock name="#createUUID()#" timeout="60">
	<cftransaction>
		<cfif isdefined("attributes.record_num") and len(attributes.record_num)>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("row_check") and listfind(row_check,i)>
					<cfquery name="get_last_amortization_" datasource="#dsn3#">
						SELECT
							MAX(ACTION_DATE) ACTION_DATE
						FROM
							INVENTORY_HISTORY
						WHERE
							INVENTORY_HISTORY.INVENTORY_ID = #evaluate("attributes.inventory_id#i#")# 
					</cfquery>
					<cfquery name="add_inventory_history" datasource="#dsn3#">
						INSERT INTO
							INVENTORY_HISTORY
							(
								INVENTORY_ID,
								ACTION_DATE,
								PROJECT_ID,
								EXPENSE_CENTER_ID,
								EXPENSE_ITEM_ID,
								CLAIM_ACCOUNT_CODE,
								DEBT_ACCOUNT_CODE,
								ACCOUNT_CODE,
								INVENTORY_DURATION,
								INVENTORY_DURATION_IFRS,
								AMORTIZATION_RATE,
								RECORD_EMP,
								RECORD_IP,
								RECORD_DATE	
							)
							VALUES
							(
								#evaluate("attributes.inventory_id#i#")#,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.action_date#">,
								<cfif len(evaluate("attributes.project_id#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.exp_center_id#i#"))>#evaluate("attributes.exp_center_id#i#")#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.exp_item_id#i#"))>#evaluate("attributes.exp_item_id#i#")#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.claim_acc_code#i#"))>'#evaluate("attributes.claim_acc_code#i#")#'<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.debt_acc_code#i#"))>'#evaluate("attributes.debt_acc_code#i#")#'<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.acc_code#i#"))>'#evaluate("attributes.acc_code#i#")#'<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.inventory_duration#i#"))>#evaluate("attributes.inventory_duration#i#")#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.inventory_duration_ifrs#i#"))>#evaluate("attributes.inventory_duration_ifrs#i#")#<cfelse>NULL</cfif>,
								<cfif len(evaluate("attributes.inventory_rate#i#"))>#filterNum(evaluate("attributes.inventory_rate#i#"),8)#<cfelse>NULL</cfif>,
								#session.ep.userid#,
								'#cgi.remote_addr#',
								#now()#		
							)
					</cfquery>
					<cfif isdefined("get_last_amortization_.action_date") and len(get_last_amortization_.action_date) and datediff('d',dateformat(attributes.action_date),dateformat(get_last_amortization_.action_date)) lte 0>
						<cfquery name="upd_inventory" datasource="#dsn3#">
							UPDATE
								INVENTORY
							SET
                            	INVENTORY_NAME = <cfif len(evaluate("attributes.inventory_name#i#"))>'#wrk_eval("attributes.inventory_name#i#")#'<cfelse>NULL</cfif>,
								PROJECT_ID = <cfif len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project_head#i#"))>#evaluate("attributes.project_id#i#")#<cfelse>NULL</cfif>,
								EXPENSE_CENTER_ID = <cfif len(evaluate("attributes.exp_center_id#i#")) and len(evaluate("attributes.exp_center_name#i#"))>#evaluate("attributes.exp_center_id#i#")#<cfelse>NULL</cfif>,
								EXPENSE_ITEM_ID = <cfif len(evaluate("attributes.exp_item_id#i#")) and len(evaluate("attributes.exp_item_name#i#"))>#evaluate("attributes.exp_item_id#i#")#<cfelse>NULL</cfif>,
								CLAIM_ACCOUNT_ID = <cfif len(evaluate("attributes.claim_acc_code#i#"))>'#evaluate("attributes.claim_acc_code#i#")#'<cfelse>NULL</cfif>,
								DEBT_ACCOUNT_ID = <cfif len(evaluate("attributes.debt_acc_code#i#"))>'#evaluate("attributes.debt_acc_code#i#")#'<cfelse>NULL</cfif>,
								ACCOUNT_ID = <cfif len(evaluate("attributes.acc_code#i#"))>'#evaluate("attributes.acc_code#i#")#'<cfelse>NULL</cfif>,
								INVENTORY_DURATION = <cfif len(evaluate("attributes.inventory_duration#i#"))>#evaluate("attributes.inventory_duration#i#")#<cfelse>NULL</cfif>,
								INVENTORY_DURATION_IFRS = <cfif len(evaluate("attributes.inventory_duration_ifrs#i#"))>#evaluate("attributes.inventory_duration_ifrs#i#")#<cfelse>NULL</cfif>,
								AMORTIZATON_ESTIMATE = <cfif len(evaluate("attributes.inventory_rate#i#"))>#filterNum(evaluate("attributes.inventory_rate#i#"),8)#<cfelse>NULL</cfif>
							WHERE
								INVENTORY_ID = #evaluate("attributes.inventory_id#i#")#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=invent.upd_collacted_inventory";
</script>