<cfif len(attributes.main_start_date)><cf_date tarih='attributes.main_start_date'></cfif>
<cfif len(attributes.main_finish_date)><cf_date tarih='attributes.main_finish_date'></cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_EVENT_PLAN" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				ACTIVITY_PLAN
					(
						IS_ACTIVE,
						EVENT_PLAN_HEAD,
						DETAIL,
						EVENT_STATUS,
						ANALYSE_ID,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						ISPOTANTIAL,
						MONEY_CURRENCY,
						EST_LIMIT,
						MAIN_START_DATE,
						MAIN_FINISH_DATE,
						EVENT_CAT,
						EXPENSE_ID,
						SALES_ZONES
					)
					VALUES
					(
						1,
						'#attributes.warning_head#',
						<cfif isDefined('attributes.event_detail') and len(attributes.event_detail)>'#attributes.event_detail#',<cfelse>NULL,</cfif>
						#attributes.process_stage#,
						<cfif len(attributes.analyse_head) and len(attributes.analyse_id)>#attributes.analyse_id#,<cfelse>NULL,</cfif>
						#now()#,
						#session.ep.userid#,
						'#cgi.remote_addr#',
						1,
						'#attributes.money#',
						<cfif len(attributes.est_limit)>#attributes.est_limit#,<cfelse>0,</cfif>
						<cfif len(attributes.main_start_date)>#attributes.main_start_date#,<cfelse>NULL,</cfif>
						<cfif len(attributes.main_finish_date)>#attributes.main_finish_date#,<cfelse>NULL,</cfif>
						<cfif len(attributes.main_warning_id)>#attributes.main_warning_id#,<cfelse>NULL,</cfif>
						<cfif len(attributes.main_expense_id)>#attributes.main_expense_id#,<cfelse>NULL,</cfif>
						<cfif len(attributes.sales_zones)>#attributes.sales_zones#<cfelse>NULL</cfif>
					)
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
							#MAX_ID.IDENTITYCOL#,
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
							#MAX_ID.IDENTITYCOL#,
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
						form_est_limit = attributes.est_limit;
						form_money = attributes.money;
						form_expense_id = attributes.main_expense_id;
						
						if (len(attributes.est_limit))
						{
							form_est_limit = (attributes.est_limit / row_toplam);
							form_money = attributes.money;
						}
					</cfscript>	
					<cfif len(form_start_date)><cf_date tarih='form_start_date'></cfif>
					<cfif len(form_finish_date)><cf_date tarih='form_finish_date'></cfif>
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
									#MAX_ID.IDENTITYCOL#,
									<cfif len(form_warning_id)>#form_warning_id#,<cfelseif len(attributes.main_warning_id)>#attributes.main_warning_id#,<cfelse>NULL,</cfif>
									<cfif len(form_est_limit)>#form_est_limit#,<cfelse>0,</cfif>
									<cfif len(form_money)>'#form_money#',<cfelse>NULL,</cfif>
									<cfif len(form_expense_id)>#form_expense_id#,<cfelseif len(attributes.main_expense_id)>#attributes.main_expense_id#,<cfelse>NULL,</cfif>
									<cfif len(form_pos_emp_id)>#form_pos_emp_id#<cfelse>NULL</cfif>
								)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfset visit_id = MAX_ID.IDENTITYCOL>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=crm.form_upd_activity&visit_id=#MAX_ID.IDENTITYCOL#' 
			action_id='#MAX_ID.IDENTITYCOL#'
			warning_description='Ziyaret : #MAX_ID.IDENTITYCOL#'>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=crm.form_upd_activity&visit_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
