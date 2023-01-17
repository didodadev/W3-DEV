<cfif len(attributes.main_start_date)><cf_date tarih='attributes.main_start_date'></cfif>
<cfif len(attributes.main_finish_date)><cf_date tarih='attributes.main_finish_date'></cfif>
<cflock name="#CreateUUID()#" timeout="90">
	<cftransaction>
	<cfquery name="UPD_EVENT_PLAN" datasource="#DSN#">
		UPDATE
			EVENT_PLAN
		SET
			IS_SALES = 0,
			IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
			EVENT_PLAN_HEAD = '#attributes.warning_head#',
			DETAIL = <cfif len(attributes.event_detail)>'#attributes.event_detail#'<cfelse>NULL</cfif>,
			EVENT_STATUS = #attributes.process_stage#,
			ANALYSE_ID = <cfif len(attributes.analyse_head) and len(attributes.analyse_id)>#attributes.analyse_id#<cfelse>NULL</cfif>,
			ISPOTANTIAL = 1,
			MAIN_START_DATE = <cfif len(attributes.main_start_date)>#attributes.main_start_date#<cfelse>NULL</cfif>,
			MAIN_FINISH_DATE = <cfif len(attributes.main_finish_date)>#attributes.main_finish_date#<cfelse>NULL</cfif>,
			SALES_ZONES = <cfif len(attributes.sales_zones)>#attributes.sales_zones#<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#'			
		WHERE
			EVENT_PLAN_ID = #attributes.visit_id#
	</cfquery>
	<!--- <cfquery name="DEL_PRO_POSITIONS" datasource="#dsn#">
		DELETE FROM EVENT_PLAN_ROW_POS WHERE EVENT_PLAN_ID = #attributes.visit_id#
	</cfquery> --->
	<cfquery name="DEL_INF_POSITIONS" datasource="#dsn#">
		DELETE FROM EVENT_PLAN_ROW_CC WHERE EVENT_PLAN_ID = #attributes.visit_id#
	</cfquery>
	<cfif isdefined("attributes.event_plan_row_id")>
		<cfloop from="1" to="#listlen(attributes.event_plan_row_id)#" index="i">
		<cfquery name="DEL_ROW_ID" datasource="#DSN#">
			DELETE FROM
				EVENT_PLAN_ROW_PARTICIPATION_POS
			WHERE
				EVENT_ROW_ID = #listgetat(attributes.event_plan_row_id, i, ',')#
		</cfquery>
		</cfloop>
	</cfif>
	
	<cfif isdefined("attributes.cc_pos_ids") and len(attributes.cc_pos_ids)>
		<cfloop from="1" to="#listlen(attributes.cc_pos_ids, ',')#" index="i">
		<cfquery name="ADD_INF_POSITIONS" datasource="#DSN#">
			INSERT INTO
				EVENT_PLAN_ROW_CC
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
			//form_event_row_ids = evaluate("attributes.event_row_ids#i#");
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
			<cfset form_event_row_ids = 'attributes.event_row_ids'&i>
			<cfif isdefined("#form_event_row_ids#")>
			<cfset form_event_row_ids_value = evaluate(form_event_row_ids)>
				<cfif len(form_company_id)>
				<cfquery name="UPD_EVENT_PLAN_ROW" datasource="#DSN#">
					UPDATE
						EVENT_PLAN_ROW
					SET
						BRANCH_ID = <cfif len(attributes.sales_zones)>#attributes.sales_zones#<cfelse>NULL</cfif>,
						IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
						IS_SALES = 0,
						PLAN_ROW_STATUS = 0,
						COMPANY_ID = #form_company_id#,
						PARTNER_ID = <cfif len(form_partner_id)>#form_partner_id#<cfelse>NULL</cfif>,
						START_DATE = <cfif len(form_start_date)>#form_start_date#<cfelseif len(attributes.main_start_date)>#attributes.main_start_date#<cfelse>NULL</cfif>,
						FINISH_DATE = <cfif len(form_finish_date)>#form_finish_date#<cfelseif len(attributes.main_finish_date)>#attributes.main_finish_date#<cfelse>NULL</cfif>,
						EVENT_PLAN_ID = #attributes.visit_id#,
						WARNING_ID = <cfif len(form_warning_id)>#form_warning_id#<cfelse>NULL</cfif>,
						UPDATE_DATE = #now()#,
						UPDATE_EMP = #session.ep.userid#,
						UPDATE_IP = '#cgi.remote_addr#'
					WHERE
						EVENT_PLAN_ROW_ID = #form_event_row_ids_value#
				</cfquery>
				<cfif len(form_pos_emp_id)>
					<cfloop from="1" to="#listlen(form_pos_emp_id)#" index="i">
					<cfquery name="ADD_ROW_POS" datasource="#DSN#">
						INSERT INTO
							EVENT_PLAN_ROW_PARTICIPATION_POS
						(
							EVENT_ROW_ID,
							EVENT_POS_ID
						)
						VALUES
						(
							#form_event_row_ids_value#,
							#listgetat(form_pos_emp_id, i, ',')#
						)
					</cfquery>
					</cfloop>
				</cfif>
				</cfif>
			<cfelse>
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
					#attributes.visit_id#,
					<cfif len(form_warning_id)>#form_warning_id#<cfelse>NULL</cfif>,
					#now()#,
					#session.ep.userid#,
					'#cgi.remote_addr#'
				)
				</cfquery>
				
				<cfquery name="GET_MAX" datasource="#DSN#">
				SELECT MAX(EVENT_PLAN_ROW_ID) AS MAX_EVENT_PLAN_ROW_ID FROM EVENT_PLAN_ROW
				</cfquery>
				
				<cfif len(form_pos_emp_id)>
				<cfloop from="1" to="#listlen(form_pos_emp_id)#" index="i">
					<cfquery name="ADD_ROW_POS" datasource="#DSN#">
					INSERT INTO
						EVENT_PLAN_ROW_PARTICIPATION_POS
					(
						EVENT_ROW_ID,
						EVENT_POS_ID
					)
					VALUES
					(
						#get_max.max_event_plan_row_id#,
						#listgetat(form_pos_emp_id, i, ',')#
					)
					</cfquery>
				</cfloop>
				</cfif>
			</cfif>
			<cfelse>
			<cfset form_event_row_ids = 'attributes.event_row_ids'&i>
			<cfif isdefined("#form_event_row_ids#")>
				<cfset form_event_row_ids_value = evaluate(form_event_row_ids)>
				<cfquery name="DEL_ROW" datasource="#DSN#">
				DELETE FROM EVENT_PLAN_ROW WHERE EVENT_PLAN_ROW_ID = #form_event_row_ids_value#
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
		action_page='#request.self#?fuseaction=crm.form_upd_visit&visit_id=#attributes.visit_id#' 
		action_id='#attributes.visit_id#' 
		old_process_line='#attributes.old_process_line#'
		warning_description='Ziyaret : #attributes.visit_id#'>
	</cftransaction>
</cflock>
<script>
	alert("<cf_get_lang dictionary_id='44003.Transaction completed successfully'>!");
	location.href="<cfoutput>#request.self#?fuseaction=crm.form_upd_visit&visit_id=#attributes.visit_id#</cfoutput>";
</script>
