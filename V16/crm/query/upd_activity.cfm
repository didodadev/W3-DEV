<cfif len(attributes.main_start_date)>
	<cf_date tarih='attributes.main_start_date'>
</cfif>
<cfif len(attributes.main_finish_date)>
	<cf_date tarih='attributes.main_finish_date'>
</cfif> 
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_EVENT_PLAN" datasource="#dsn#">
			UPDATE
				ACTIVITY_PLAN
			SET
				IS_ACTIVE = <cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif>
				EVENT_PLAN_HEAD = '#attributes.warning_head#',
				DETAIL = <cfif len(attributes.event_detail)>'#attributes.event_detail#',<cfelse>NULL,</cfif>
				EVENT_STATUS = #attributes.process_stage#,
				ANALYSE_ID = <cfif len(attributes.analyse_head) and len(attributes.analyse_id)>#attributes.analyse_id#,<cfelse>NULL,</cfif>
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				ISPOTANTIAL = 1,
				MONEY_CURRENCY = '#attributes.money#',
				EST_LIMIT = <cfif len(attributes.est_limit)>#attributes.est_limit#,<cfelse>0,</cfif>
				MAIN_START_DATE = <cfif len(attributes.main_start_date)>#attributes.main_start_date#,<cfelse>NULL,</cfif>
				MAIN_FINISH_DATE = <cfif len(attributes.main_finish_date)>#attributes.main_finish_date#,<cfelse>NULL,</cfif>
				EVENT_CAT = <cfif len(attributes.main_warning_id)>#attributes.main_warning_id#,<cfelse>NULL,</cfif>
				EXPENSE_ID = <cfif len(attributes.main_expense_id)>#attributes.main_expense_id#,<cfelse>NULL,</cfif>
				SALES_ZONES = <cfif len(attributes.sales_zones)>#attributes.sales_zones#<cfelse>NULL</cfif>
			WHERE
				EVENT_PLAN_ID = #attributes.visit_id#
		</cfquery>
		<cfquery name="DEL_PRO_POSITIONS" datasource="#dsn#">
			DELETE FROM ACTIVITY_PLAN_ROW_POS WHERE EVENT_PLAN_ID = #attributes.visit_id#
		</cfquery>
		<cfquery name="DEL_INF_POSITIONS" datasource="#dsn#">
			DELETE FROM ACTIVITY_PLAN_ROW_CC WHERE EVENT_PLAN_ID = #attributes.visit_id#
		</cfquery>
		<cfif isdefined("attributes.to_pos_ids") and len(attributes.to_pos_ids)>
			<cfloop from="1" to="#listlen(attributes.to_pos_ids, ',')#" index="i">
				<cfquery name="ADD_PRO_POSITIONS" datasource="#dsn#">
					INSERT
					INTO
						ACTIVITY_PLAN_ROW_POS
						(
							EVENT_PLAN_ID,
							POS_ID
						)
						VALUES
						(
							#attributes.visit_id#,
							#listgetat(attributes.to_pos_ids, i, ',')#
						)
				</cfquery>
			</cfloop>
		</cfif>
		<cfif isdefined("attributes.cc_pos_ids") and len(attributes.cc_pos_ids)>
			<cfloop from="1" to="#listlen(attributes.cc_pos_ids, ',')#" index="i">
				<cfquery name="ADD_INF_POSITIONS" datasource="#dsn#">
					INSERT
					INTO
						ACTIVITY_PLAN_ROW_CC
						(
							EVENT_PLAN_ID,
							CC_ID
						)
						VALUES
						(
							#attributes.visit_id#,
							#listgetat(attributes.cc_pos_ids, i, ',')#
						)
				</cfquery>
			</cfloop>
		</cfif>
		<cfset row_toplam = 0>
		<cfif len(attributes.record_num) and attributes.record_num neq "">
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfset row_toplam = row_toplam + 1>
				</cfif>
			</cfloop>
		</cfif>
		<cfif len(attributes.record_num) and attributes.record_num neq "">
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol#i#")>
					<cfscript>
						form_warning_id = attributes.main_warning_id;
						form_company_id = evaluate("attributes.company_id#i#");
						form_partner_id = evaluate("attributes.partner_id#i#");
 						form_start_date = evaluate("attributes.start_date#i#");
						form_finish_date = evaluate("attributes.start_date#i#");			
						form_pos_emp_id = evaluate("attributes.pos_emp_id#i#");
						//form_event_row_ids = evaluate("attributes.event_row_ids#i#");
						form_est_limit = attributes.est_limit;
						form_money = attributes.money;
						form_expense_id = attributes.main_expense_id;
						
						if (len(attributes.est_limit))
						{
							form_est_limit = (attributes.est_limit / row_toplam);
							form_money = attributes.money;
						}
					</cfscript>	
					<cfif len(form_start_date)>
						<cf_date tarih='form_start_date'>
					</cfif>
					<cfif len(form_finish_date)>
						<cf_date tarih='form_finish_date'>
					</cfif>
					<cfset form_event_row_ids = 'attributes.event_row_ids'&i>
					<cfif isdefined("#form_event_row_ids#")>
					<cfset form_event_row_ids_value = evaluate(form_event_row_ids)>
						<cfif len(form_company_id)>
							<cfquery name="ADD_EVENT_PLAN_ROW" datasource="#dsn#">
								UPDATE
									ACTIVITY_PLAN_ROW
								SET
									PLAN_ROW_STATUS = 1,
									COMPANY_ID = #form_company_id#,
									PARTNER_ID = <cfif len(form_partner_id)>#form_partner_id#,<cfelse>NULL,</cfif>
									START_DATE = <cfif len(form_start_date)>#form_start_date#,<cfelseif len(attributes.main_start_date)>#attributes.main_start_date#,<cfelse>NULL,</cfif>
									FINISH_DATE = <cfif len(form_finish_date)>#form_finish_date#,<cfelseif len(attributes.main_finish_date)>#attributes.main_finish_date#,<cfelse>NULL,</cfif>
									EVENT_PLAN_ID = #attributes.visit_id#,
									WARNING_ID = <cfif len(form_warning_id)>#form_warning_id#,<cfelseif len(attributes.main_warning_id)>#attributes.main_warning_id#,<cfelse>NULL,</cfif>
									SUB_EST_LIMIT = <cfif len(form_est_limit)>#form_est_limit#,<cfelse>0,</cfif>
									SUB_MONEY = <cfif len(form_money)>'#form_money#',<cfelse>NULL,</cfif>
									SUB_EXPENSE_ID = <cfif len(form_expense_id)>#form_expense_id#,<cfelseif len(attributes.main_expense_id)>#attributes.main_expense_id#,<cfelse>NULL,</cfif>
									POSITION_ID = <cfif len(form_pos_emp_id)>#form_pos_emp_id#<cfelse>NULL</cfif>
								WHERE
									EVENT_PLAN_ROW_ID = #form_event_row_ids_value#
							</cfquery>
						</cfif>
					<cfelse>
						<cfif len(form_company_id)>
							<cfquery name="ADD_EVENT_PLAN_ROW" datasource="#dsn#">
								INSERT
								INTO
									ACTIVITY_PLAN_ROW
									(
										PLAN_ROW_STATUS,
										COMPANY_ID,
										PARTNER_ID,
										START_DATE,
										FINISH_DATE,
										EVENT_PLAN_ID,
										WARNING_ID,
										SUB_EST_LIMIT,
										SUB_MONEY,
										SUB_EXPENSE_ID,
										POSITION_ID
									)
									VALUES
									(
										1,
										#form_company_id#,
										<cfif len(form_partner_id)>#form_partner_id#,<cfelse>NULL,</cfif>
										<cfif len(form_start_date)>#form_start_date#,<cfelseif len(attributes.main_start_date)>#attributes.main_start_date#,<cfelse>NULL,</cfif>
										<cfif len(form_finish_date)>#form_finish_date#,<cfelseif len(attributes.main_finish_date)>#attributes.main_finish_date#,<cfelse>NULL,</cfif>
										#attributes.visit_id#,
										<cfif len(form_warning_id)>#form_warning_id#,<cfelseif len(attributes.main_warning_id)>#attributes.main_warning_id#,<cfelse>NULL,</cfif>
										<cfif len(form_est_limit)>#form_est_limit#,<cfelse>0,</cfif>
										<cfif len(form_money)>'#form_money#',<cfelse>NULL,</cfif>
										<cfif len(form_expense_id)>#form_expense_id#,<cfelseif len(attributes.main_expense_id)>#attributes.main_expense_id#,<cfelse>NULL,</cfif>
										<cfif len(form_pos_emp_id)>#form_pos_emp_id#<cfelse>NULL</cfif>
									)
							</cfquery>
						</cfif>
					</cfif>
				<cfelse>
					<cfset form_event_row_ids = 'attributes.event_row_ids'&i>
					<cfif isdefined("#form_event_row_ids#")>
					<cfset form_event_row_ids_value = evaluate(form_event_row_ids)>
						<cfquery name="DEL_ROW" datasource="#dsn#">
							DELETE FROM ACTIVITY_PLAN_ROW WHERE EVENT_PLAN_ROW_ID = #form_event_row_ids_value#
						</cfquery>
						<cfquery name="DEL_ROW_RESULT" datasource="#dsn#">
							DELETE FROM ACTIVITY_PLAN_ROW_RESULT WHERE EVENT_PLAN_ROW_ID = #form_event_row_ids_value#
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cf_workcube_process 
			is_upd='1' 
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=crm.form_upd_activity&visit_id=#attributes.visit_id#' 
			action_id='#attributes.visit_id#' 
			old_process_line='#attributes.old_process_line#'
			warning_description='Ziyaret : #attributes.visit_id#'>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=crm.form_upd_activity&visit_id=#attributes.visit_id#" addtoken="no">
