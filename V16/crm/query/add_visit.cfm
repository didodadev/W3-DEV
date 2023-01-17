<cfif len(attributes.main_start_date)><cf_date tarih='attributes.main_start_date'></cfif>
<cfif len(attributes.main_finish_date)><cf_date tarih='attributes.main_finish_date'></cfif>
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_EVENT_PLAN" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				EVENT_PLAN
			(
				IS_SALES,
				EVENT_PLAN_HEAD,
				DETAIL,
				EVENT_STATUS,
				ANALYSE_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				ISPOTANTIAL,
				MAIN_START_DATE,
				MAIN_FINISH_DATE,
				SALES_ZONES,
				IS_ACTIVE
			)
			VALUES
			(
				0,
				'#attributes.warning_head#',
				<cfif len(attributes.event_detail)>'#attributes.event_detail#'<cfelse>NULL</cfif>,
				#attributes.process_stage#,
				<cfif len(attributes.analyse_head) and len(attributes.analyse_id)>#attributes.analyse_id#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				1,
				<cfif len(attributes.main_start_date)>#attributes.main_start_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.main_finish_date)>#attributes.main_finish_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.sales_zones)>#attributes.sales_zones#<cfelse>NULL</cfif>,
				1
			)
		</cfquery>
		<cfif isdefined("attributes.cc_pos_ids") and len(attributes.cc_pos_ids)>
			<cfloop from="1" to="#listlen(attributes.cc_pos_ids, ',')#" index="i">
				<cfquery name="ADD_INF_POSITIONS" datasource="#dsn#">
					INSERT INTO
						EVENT_PLAN_ROW_CC
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
		<cfif len(attributes.record_num) and attributes.record_num neq "">
		  	<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol#i#") and (evaluate("attributes.row_kontrol#i#") eq 1)>
				<cfscript>
					form_warning_id = evaluate("attributes.warning_id#i#");
					form_company_id = evaluate("attributes.company_id#i#");
					form_partner_id = evaluate("attributes.partner_id#i#");
					form_start_date = evaluate("attributes.start_date#i#");
					form_start_clock = evaluate("attributes.start_clock#i#");
					form_start_minute = evaluate("attributes.start_minute#i#");
					form_finish_date = evaluate("attributes.start_date#i#");
					form_finish_clock = evaluate("attributes.finish_clock#i#");
					form_finish_minute = evaluate("attributes.finish_minute#i#");
					form_pos_emp_id = evaluate("attributes.pos_emp_id#i#");
				</cfscript>	
				<cfif len(form_start_date)>
					<cf_date tarih='form_start_date'>
					<cfscript>
						form_start_date = date_add('h', form_start_clock, form_start_date);
						form_start_date = date_add('n', form_start_minute, form_start_date);
					</cfscript>
				</cfif>
				<cfif len(form_finish_date)>
					<cf_date tarih='form_finish_date'>
					<cfscript>
						form_finish_date = date_add('h', form_finish_clock, form_finish_date);
						form_finish_date = date_add('n', form_finish_minute, form_finish_date);
					</cfscript>
				</cfif>
				<cfif len(form_company_id)>
					<cfquery name="ADD_EVENT_PLAN_ROW" datasource="#DSN#">
						INSERT INTO
							EVENT_PLAN_ROW
						(
							BRANCH_ID,
							IS_ACTIVE,
							IS_SALES,
							PLAN_ROW_STATUS,
							COMPANY_ID,
							PARTNER_ID,
							START_DATE,
							FINISH_DATE,
							EVENT_PLAN_ID,
							WARNING_ID,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
						VALUES
						(
							<cfif len(attributes.sales_zones)>#attributes.sales_zones#<cfelse>NULL</cfif>,
							1,
							0,
							0,
							#form_company_id#,
							<cfif len(form_partner_id)>#form_partner_id#<cfelse>NULL</cfif>,
							<cfif len(form_start_date)>#form_start_date#<cfelseif len(attributes.main_start_date)>#attributes.main_start_date#<cfelse>NULL</cfif>,
							<cfif len(form_finish_date)>#form_finish_date#<cfelseif len(attributes.main_finish_date)>#attributes.main_finish_date#<cfelse>NULL</cfif>,
							#MAX_ID.IDENTITYCOL#,
							<cfif len(form_warning_id)>#form_warning_id#<cfelse>NULL</cfif>,
							#now()#,
							#session.ep.userid#,
							'#cgi.remote_addr#'
						)
					</cfquery>
					<cfquery name="GET_MAXROW_ID" datasource="#dsn#">
						SELECT MAX(EVENT_PLAN_ROW_ID) AS MAX_ID FROM EVENT_PLAN_ROW
					</cfquery>
					<cfif len(form_pos_emp_id)>
						<cfloop from="1" to="#listlen(form_pos_emp_id)#" index="i">
							<cfquery name="ADD_ROW_POS" datasource="#dsn#">
								INSERT INTO
									EVENT_PLAN_ROW_PARTICIPATION_POS
									(
										EVENT_ROW_ID,
										EVENT_POS_ID
									)
									VALUES
									(
										#get_maxrow_id.max_id#,
										#listgetat(form_pos_emp_id, i, ',')#
									)
							</cfquery>
						</cfloop>
					</cfif>
				</cfif>
			</cfif>
			</cfloop>
		</cfif>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#' 
			action_page='#request.self#?fuseaction=crm.form_upd_visit&visit_id=#MAX_ID.IDENTITYCOL#' 
			action_id='#MAX_ID.IDENTITYCOL#'
			warning_description='Ziyaret : #MAX_ID.IDENTITYCOL#'>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=crm.form_upd_visit&visit_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
