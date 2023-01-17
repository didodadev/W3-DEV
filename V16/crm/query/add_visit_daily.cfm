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
				IS_ACTIVE,
				IS_DAILY
			)
			VALUES
			(
				0,
				'#attributes.warning_head#',
				NULL,
				#attributes.process_stage#,
				NULL,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#',
				1,
				<cfif len(attributes.main_start_date)>#attributes.main_start_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.main_finish_date)>#attributes.main_finish_date#<cfelse>NULL</cfif>,
				#attributes.sales_zones#,
				1,
				1
			)
		</cfquery>
	  	<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.check_#i#")>
				<cfscript>
					form_company_id = evaluate("attributes.company_id_#i#");
					form_partner_id = evaluate("attributes.partner_id_#i#");
					form_warning_id = attributes.warning_id;
					form_start_date = attributes.main_start_date;
					form_start_clock = attributes.start_clock;
					form_start_minute = attributes.start_minute;
					form_finish_date = attributes.main_start_date;
					form_finish_clock = attributes.finish_clock;
					form_finish_minute = attributes.finish_minute;
					form_pos_emp_id = attributes.pos_emp_id;					
				</cfscript>	
				<cfif len(form_start_date)>
					<!--- <cf_date tarih='form_start_date'> --->
					<cfscript>
						form_start_date = date_add('h', form_start_clock, form_start_date);
						form_start_date = date_add('n', form_start_minute, form_start_date);
					</cfscript>
				</cfif>
				<cfif len(form_finish_date)>
					<!--- <cf_date tarih='form_finish_date'> --->
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
							#attributes.sales_zones#,
							1,
							0,
							0,
							#form_company_id#,
							#form_partner_id#,
							<cfif len(form_start_date)>#form_start_date#<cfelseif len(attributes.main_start_date)>#attributes.main_start_date#<cfelse>NULL</cfif>,
							<cfif len(form_finish_date)>#form_finish_date#<cfelseif len(attributes.main_finish_date)>#attributes.main_finish_date#<cfelse>NULL</cfif>,
							#MAX_ID.IDENTITYCOL#,
							<cfif len(form_warning_id)>#form_warning_id#<cfelse>NULL</cfif>,
							#now()#,
							#session.ep.userid#,
							'#cgi.remote_addr#'
						)
					</cfquery>
					<cfquery name="ADD_ROW_POS" datasource="#DSN#">
						INSERT INTO
							EVENT_PLAN_ROW_PARTICIPATION_POS
						(
							EVENT_ROW_ID,
							EVENT_POS_ID
						)
						VALUES
						(
							#MAX_ID.IDENTITYCOL#,
							#form_pos_emp_id#
						)
					</cfquery>
				</cfif>
			</cfif>
		</cfloop>
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
