<cfif len(attributes.startdate)><cf_date tarih='attributes.startdate'></cfif>
<cfif len(attributes.finishdate)><cf_date tarih='attributes.finishdate'></cfif>
<cflock name="#CreateUUID()#" timeout="60">
  	<cftransaction>
		<cfquery name="ADD_EVENT_PLAN" datasource="#DSN#">
			INSERT INTO
				EVENT_PLAN
			(
				EVENT_PLAN_HEAD,
				DETAIL,
				EVENT_STATUS,
				ISPOTANTIAL,
				MAIN_START_DATE,
				MAIN_FINISH_DATE,
				SALES_ZONES,
				IS_ACTIVE,
				IS_SALES,
				VIEW_TO_ALL,
				IS_WIEW_BRANCH,
				IS_WIEW_DEPARTMENT,
				ANALYSE_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP							
			)
			VALUES
			(
				'#attributes.plan_name#',
				<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
				49,
				1,
				<cfif len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
				<cfif len(attributes.finishdate)>#attributes.finishdate#<cfelse>NULL</cfif>,
				<cfif len(attributes.sales_zones)>#attributes.sales_zones#<cfelse>NULL</cfif>,
				1,
				1,
				<cfif isDefined('attributes.view_to_all') and len(attributes.view_to_all)>#attributes.view_to_all#<cfelse>NULL</cfif>, 
				NULL,
				NULL,
				<cfif len(attributes.visit_analysis_id)>'#attributes.visit_analysis_id#'<cfelse>NULL</cfif>,
				#now()#,
				#session.pda.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
			)
		</cfquery>
		<cfquery name="GET_MAXID" datasource="#DSN#">
			SELECT MAX(EVENT_PLAN_ID) AS MAX_ID FROM EVENT_PLAN
		</cfquery>
        <cfif len(attributes.total_row_count) and attributes.total_row_count neq "">
			<cfloop from="1" to="#attributes.total_row_count#" index="i">
           		<cfif evaluate("attributes.row_control#i#") and evaluate("attributes.row_control#i#") eq 1>
					<cfscript>
						form_row_kontrol_ = evaluate("attributes.row_control#i#");
		  				//if(isdefined('attributes.project_id#i#') and len(evaluate("attributes.project_id#i#")))form_project_id=evaluate("attributes.project_id#i#");else form_project_id="";
		  				//if(isdefined('attributes.relation_asset_id#i#') and len(evaluate("attributes.relation_asset_id#i#")))form_asset_id=evaluate("attributes.relation_asset_id#i#");else form_asset_id="";
						//form_warning_id = evaluate("attributes.warning_id#i#");
						if(isdefined("attributes.company_id#i#") and len(evaluate("attributes.company_id#i#")))form_company_id = evaluate("attributes.company_id#i#");else form_company_id = "";
						if(isdefined("attributes.partner_id#i#") and len(evaluate("attributes.partner_id#i#")))form_partner_id = evaluate("attributes.partner_id#i#");else form_partner_id = "";
						//if(isdefined("attributes.consumer_id#i#") and len(evaluate("attributes.consumer_id#i#")))form_consumer_id = evaluate("attributes.consumer_id#i#");else form_consumer_id = "";
						form_start_date = evaluate("attributes.ship_date#i#");
						form_start_clock = evaluate("attributes.event_start_clock#i#");
						form_start_minute = evaluate("attributes.event_start_minute#i#");
						form_finish_date = evaluate("attributes.ship_date#i#");
						form_finish_clock = evaluate("attributes.event_start_clock#i#");
						form_finish_minute = evaluate("attributes.event_start_minute#i#");
						//form_pos_emp_id = evaluate("attributes.pos_emp_id#i#");
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
					<cfif form_row_kontrol_ eq 1 and ((isDefined('form_company_id') and len(form_company_id)) or (isDefined('form_consumer_id') and len(form_consumer_id)))>
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
								CONSUMER_ID,
								START_DATE,
								FINISH_DATE,
								EVENT_PLAN_ID,
								<!---WARNING_ID,
                                ASSET_ID,
                                PROJECT_ID	--->	
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
							VALUES
							(
								<cfif len(attributes.sales_zones)>#attributes.sales_zones#<cfelse>NULL</cfif>,
								1,
								1,
								0,
								<cfif len(form_company_id) and len(form_partner_id)>
									#form_company_id#,
									#form_partner_id#,
									NULL,
								<cfelseif len(form_consumer_id)>
									NULL,
									NULL,
									#form_consumer_id#,
								</cfif>
								<cfif len(form_start_date)>#form_start_date#<cfelseif len(attributes.main_start_date)>#attributes.main_start_date#<cfelse>NULL</cfif>,
								<cfif len(form_finish_date)>#form_finish_date#<cfelseif len(attributes.main_finish_date)>#attributes.main_finish_date#<cfelse>NULL</cfif>,
								#get_maxid.max_id#,								
								<!---<cfif len(form_warning_id)>#form_warning_id#<cfelseif len(attributes.main_warning_id)>#attributes.main_warning_id#<cfelse>NULL</cfif>,
                                <cfif len(form_asset_id)>#form_asset_id#<cfelseif  isdefined("attributes.relation_asset_id") and len(attributes.relation_asset_id)>#attributes.relation_asset_id#<cfelse>NULL</cfif>,
                                <cfif len(form_project_id)>#form_project_id#<cfelseif  isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>--->
								#now()#,
								#session.pda.userid#,
								'#cgi.remote_addr#'
							)
						</cfquery>
						<cfquery name="GET_MAXROW_ID" datasource="#DSN#">
							SELECT MAX(EVENT_PLAN_ROW_ID) AS MAX_ID FROM EVENT_PLAN_ROW
						</cfquery>
						<cfif isDefined('form_pos_emp_id') and len(form_pos_emp_id)>
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
  	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=pda.daily" addtoken="no">
