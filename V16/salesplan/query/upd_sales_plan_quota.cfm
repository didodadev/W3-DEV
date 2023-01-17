<cf_date tarih = 'attributes.plan_date'>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="add_sales_plan" datasource="#dsn#">
			UPDATE 
				SALES_QUOTES_GROUP
			SET
				SALES_ZONE_ID=<cfif len(attributes.zone_id)>#attributes.zone_id#<cfelse>0</cfif>,
				QUOTE_YEAR = #attributes.plan_year#,
				QUOTE_DETAIL ='#attributes.detail#',
				PLANNER_EMP_ID = <cfif len(attributes.planner_id) and len(attributes.planner_name)>#attributes.planner_id#<cfelse>NULL</cfif>,
				PAPER_NO= '#attributes.paper_no#',
				PROCESS_STAGE = #attributes.process_stage#,
				SCOPE =#attributes.sale_scope#,
				PLAN_DATE =#attributes.plan_date#,
				IS_PLAN = 1,
				QUOTE_TYPE = #attributes.sale_scope#,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP ='#CGI.REMOTE_ADDR#',
				COMPANYCAT_ID = <cfif len(attributes.companycat_id)>#attributes.companycat_id#<cfelse>0</cfif>
			WHERE
				SALES_QUOTE_ID = #attributes.plan_id#
		</cfquery>
		<cfquery name="del_rows" datasource="#dsn#">
			DELETE FROM SALES_QUOTES_GROUP_ROWS WHERE SALES_QUOTE_ID = #attributes.plan_id#
		</cfquery>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
				<cfloop from="1" to="12" index="kk">
					<cfquery name="add_sales_plan_row" datasource="#dsn#">
						INSERT INTO
							SALES_QUOTES_GROUP_ROWS
							(
								SALES_QUOTE_ID,
								<cfif attributes.sale_scope eq 1>
									SUB_ZONE_ID,
								<cfelseif attributes.sale_scope eq 2>
									SUB_BRANCH_ID,
								<cfelseif attributes.sale_scope eq 3>
									TEAM_ID,
								<cfelseif attributes.sale_scope eq 4>
									IMS_ID,
								<cfelseif attributes.sale_scope eq 5>
									EMPLOYEE_ID,
								<cfelseif attributes.sale_scope eq 6>
									CUSTOMER_COMP_ID,
								<cfelseif attributes.sale_scope eq 7>
									PRODUCTCAT_ID,
								<cfelseif attributes.sale_scope eq 8>
									BRAND_ID,
								<cfelseif attributes.sale_scope eq 9>
									COMPANYCAT_ID,
								</cfif>
								QUOTE_MONTH,
								ROW_TOTAL,
								ROW_TOTAL2,
								ROW_PROFIT,
								ROW_PREMIUM,
								ROW_QUANTITY
							)
							VALUES
							(
								#attributes.plan_id#,
								#evaluate("attributes.plan_scope_id#i#")#,
								#kk#,
								#evaluate("attributes.net_total#kk#_#i#")#,
								#evaluate("attributes.net_total_other#kk#_#i#")#,
								#evaluate("attributes.net_kar#kk#_#i#")#,
								#evaluate("attributes.net_prim#kk#_#i#")#,
								<cfif len(evaluate("attributes.quantity#kk#_#i#"))>#evaluate("attributes.quantity#kk#_#i#")#<cfelse>0</cfif>
							)
					</cfquery>
				</cfloop>
			</cfif>
		</cfloop>
		<cfquery name="del_money" datasource="#dsn#">
			DELETE FROM SALES_QUOTES_GROUP_MONEY WHERE ACTION_ID = #attributes.plan_id#
		</cfquery>
		<cfloop from="1" to="#attributes.kur_say#" index="i">
			<cfquery name="add_money" datasource="#dsn#">
				INSERT INTO
					SALES_QUOTES_GROUP_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
				VALUES
					(
						#attributes.plan_id#,
						'#wrk_eval("attributes.hidden_rd_money_#i#")#',
						 #evaluate("attributes.txt_rate2_#i#")#,
						 #evaluate("attributes.txt_rate1_#i#")#,
						<cfif evaluate("attributes.hidden_rd_money_#i#") is listfirst(attributes.rd_money,',')>1<cfelse>0</cfif>
					)
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=salesplan.list_sales_plan_quotas&event=upd&plan_id=<cfoutput>#attributes.plan_id#</cfoutput>';
</script>
