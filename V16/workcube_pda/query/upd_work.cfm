<cfif len(attributes.work_h_start)>
	<cf_date tarih='attributes.work_h_start'>
</cfif>
<cfif len(attributes.work_h_finish)>
	<cf_date tarih='attributes.work_h_finish'>
</cfif>
<cfscript>
	attributes.work_h_start = date_add("h",attributes.start_hour,attributes.work_h_start);
	attributes.work_h_finish = date_add("h",attributes.finish_hour,attributes.work_h_finish);
</cfscript>
<cfif not isdefined('attributes.total_time_hour') or not attributes.total_time_hour gt 0><cfset attributes.total_time_hour=0></cfif>
<cfif not isdefined('attributes.total_time_minute') or not attributes.total_time_minute gt 0><cfset attributes.total_time_minute=0></cfif>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="UPD_WORK" datasource="#DSN#">
			UPDATE 
				PRO_WORKS
			SET
				WORK_HEAD = '#attributes.work_head#',
				WORK_DETAIL = <cfif isDefined('attributes.work_detail') and len(attributes.work_detail)>'#attributes.work_detail#'<cfelse>''</cfif>,
				WORK_CAT_ID = #attributes.pro_work_cat#,
				TARGET_START = #attributes.work_h_start#,
				TARGET_FINISH = #attributes.work_h_finish#,
				PROJECT_EMP_ID = <cfif isDefined('attributes.employee_id') and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
				WORK_CURRENCY_ID = <cfif isDefined('attributes.process_stage') and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
				WORK_PRIORITY_ID = #attributes.priority_cat#,
				PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				TOTAL_TIME_HOUR = <cfif isdefined("attributes.total_time_hour") and len(attributes.total_time_hour)>#attributes.total_time_hour#<cfelse>NULL</cfif>,
				TOTAL_TIME_MINUTE = <cfif isdefined("attributes.total_time_minute") and len(attributes.total_time_minute)>#attributes.total_time_minute#<cfelse>NULL</cfif>,	
                TO_COMPLETE = #attributes.to_complete#,
				UPDATE_AUTHOR = #session.pda.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE
				WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
		</cfquery>
        
		<cfquery name="ADD_HIST_WORK" datasource="#DSN#">
			INSERT INTO
				PRO_WORKS_HISTORY
                (
                    WORK_ID,
                    WORK_HEAD,
                    WORK_DETAIL,
                    WORK_CAT_ID,
                    TARGET_START,
                    TARGET_FINISH,
					PROJECT_EMP_ID,
                    WORK_CURRENCY_ID,
					TO_COMPLETE,
                    TOTAL_TIME_HOUR,
                    TOTAL_TIME_MINUTE,
                    WORK_PRIORITY_ID,
                    UPDATE_AUTHOR,
					UPDATE_DATE
                )
                VALUES
                (
                    #attributes.work_id#,
                    '#attributes.work_head#',
					<cfif isDefined('attributes.work_detail') and len(attributes.work_detail)>'#attributes.work_detail#'<cfelse>''</cfif>,
                    #attributes.pro_work_cat#,
                    <cfif isdefined("attributes.work_h_start") and len(attributes.work_h_start)>#attributes.work_h_start#,<cfelse>NULL,</cfif>
                    <cfif isdefined("attributes.work_h_finish") and len(attributes.work_h_finish)>#attributes.work_h_finish#,<cfelse>NULL,</cfif>
					<cfif isDefined('attributes.employee_id') and len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
					<cfif isDefined('attributes.process_stage') and len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.to_complete") and len(attributes.to_complete)>#attributes.to_complete#<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.total_time_hour") and len(attributes.total_time_hour)>#attributes.total_time_hour#<cfelse>NULL</cfif>,
                    <cfif isDefined("attributes.total_time_minute") and len(attributes.total_time_minute)>#attributes.total_time_minute#<cfelse>NULL</cfif>,
                    #attributes.priority_cat#,
                    #session.pda.userid#,
					#now()#	
                )
		</cfquery>
        
		<cfif isdefined("attributes.cc_par_ids") or isdefined("attributes.cc_emp_ids")>
			<cfquery name="DEL_WORK_CC" datasource="#DSN#">
				DELETE FROM PRO_WORKS_CC WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
			</cfquery>
			<cfif (isdefined("attributes.cc_par_ids") and ListLen(attributes.cc_par_ids)) or (isdefined("attributes.cc_emp_ids") and ListLen(attributes.cc_emp_ids))>
				<cfif isDefined("attributes.cc_par_ids") and ListLen(attributes.cc_par_ids)>
					<cfloop list="#attributes.cc_par_ids#" index="pid">
						<cfquery name="ADD_WORK_CC_PAR" datasource="#DSN#">
							INSERT INTO 
								PRO_WORKS_CC 
								(
									CC_PAR_ID, 
									WORK_ID
								) 
								VALUES 
								(
									#pid#, 
									#attributes.work_id#
								)
						</cfquery>
					</cfloop>
				</cfif>
				<cfif isDefined("attributes.cc_emp_ids") and ListLen(attributes.cc_emp_ids)>
					<cfloop list="#attributes.cc_emp_ids#" index="eid">
						<cfquery name="ADD_WORK_CC_EMP" datasource="#DSN#">
							INSERT INTO 
								PRO_WORKS_CC 
								(
									CC_EMP_ID, 
									WORK_ID
								) 
								VALUES 
								(
									#eid#, 
									#attributes.work_id#
								)
						</cfquery>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>

		<cfif (attributes.total_time_hour gt 0 or attributes.total_time_minute gt 0)>
            <cfquery name="GET_HOURLY_SALARY" datasource="#DSN#">
                SELECT ISNULL(ON_MALIYET,0) ON_MALIYET, ISNULL(ON_HOUR,0) ON_HOUR FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.position_code#">
            </cfquery>
            <cfquery name="get_process_stage" datasource="#dsn#" maxrows="1">
                SELECT
                    PTR.PROCESS_ROW_ID 
                FROM
                    PROCESS_TYPE_ROWS PTR,
                    PROCESS_TYPE_OUR_COMPANY PTO,
                    PROCESS_TYPE PT
                WHERE
                    PT.IS_ACTIVE = 1 AND
                    PT.PROCESS_ID = PTR.PROCESS_ID AND
                    PT.PROCESS_ID = PTO.PROCESS_ID AND
                    PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                    PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%myhome.time_cost%">
                ORDER BY
                    PTR.LINE_NUMBER
            </cfquery>
            <cfif get_hourly_salary.recordcount and get_hourly_salary.on_maliyet eq 0 or get_hourly_salary.on_hour eq  0>
                <cfif isDefined('session.pda.time_cost_control') and session.pda.time_cost_control eq 1 and ListFind("1,2",session.pda.time_cost_control_type,",")>
                    <script type="text/javascript">
                        alert("<cf_get_lang no ='325.Insan Kaynaklari Bölümü Pozisyon Çalisma Maliyetiniz Belirtilmemis'> !");
                        history.back();
                    </script>
                    <cfabort>
                <cfelse>
                    <cfset salary_minute = 0>	
                </cfif>
            <cfelse>
                <cfset salary_minute = get_hourly_salary.on_maliyet / get_hourly_salary.on_hour / 60>
            </cfif>
            <cfset topson_=(attributes.total_time_hour*60)+attributes.total_time_minute>
            <cfset topson=topson_/60>
            <cfquery name="TIME_TOTAL" datasource="#DSN#">
                SELECT
                    SUM(EXPENSED_MINUTE) AS TOTAL_TIME
                FROM
                    TIME_COST
                WHERE
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.userid#"> AND
                    EVENT_DATE > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',-1,now())#"> AND 
                    EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            </cfquery>
            <cfif time_total.recordcount and len(time_total.total_time)>
                <cfset xx=(time_total.total_time/60) + topson>
            <cfelse>
                <cfset xx=topson>
            </cfif>
            <cfif xx gt 24>
                <script type="text/javascript">
                    alert("Bir Gün Içinde 24 Saatten Fazla Zaman Harcamasi Girilemez!");
                    history.back();
                </script>
                <cfabort>
            </cfif>
            <!--- etkilesim sayfasindaki sistem bilgisini getirir --->
            <cfquery name="GET_CUS_HELP_DET" datasource="#DSN#">
                SELECT CH.SUBSCRIPTION_ID,CH.CUS_HELP_ID FROM PRO_WORKS PW,CUSTOMER_HELP CH WHERE CH.CUS_HELP_ID = PW.CUS_HELP_ID AND PW.WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
            </cfquery>
            <!--- //etkilesim sayfasindaki sistem bilgisini getirir --->
            <cfset total_min=(attributes.total_time_hour*60)+attributes.total_time_minute>
            <cfset para=round(salary_minute*total_min)>				
            <cfquery name="ADD_TIME_COST" datasource="#DSN#">
                INSERT INTO
                    TIME_COST
                (
                    OUR_COMPANY_ID,
                    CRM_ID,
                    WORK_ID,
                    COMPANY_ID,
                    PARTNER_ID,
                    CUS_HELP_ID,
                    SUBSCRIPTION_ID,
                    PROJECT_ID,
                    TOTAL_TIME,
                    EXPENSED_MONEY,
                    EXPENSED_MINUTE,
                    EMPLOYEE_ID,
                    EVENT_DATE,
                    COMMENT,
                    ACTIVITY_ID,
                    TIME_COST_STAGE,
                    RECORD_DATE,
                    RECORD_IP,
                    RECORD_EMP
                )
                VALUES
                (
                    #session.pda.our_company_id#,
                    <cfif isdefined("attributes.service_id") and len(attributes.service_id)>#attributes.service_id#<cfelse>NULL</cfif>,
                    #attributes.work_id#,
                    <cfif isDefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
                    <cfif isDefined('attributes.company_partner_id') and len(attributes.company_partner_id)>#attributes.company_partner_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('get_cus_help_det.cus_help_id') and len(get_cus_help_det.cus_help_id)>#get_cus_help_det.cus_help_id#<cfelse>NULL</cfif>,
                    <cfif isdefined('get_cus_help_det.subscription_id') and len(get_cus_help_det.subscription_id)>#get_cus_help_det.subscription_id#<cfelse>NULL</cfif>,
                    <cfif len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
                    #topson#,
                    #para#,
                    #total_min#,
                    #session.pda.userid#,
                    #now()#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.work_head#">,
                    <cfif isDefined('attributes.activity_type') and len(attributes.activity_type)>#attributes.activity_type#<cfelse>NULL</cfif>,
                    <cfif isdefined('get_process_stage.process_row_id') and len(get_process_stage.process_row_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_stage.process_row_id#"><cfelse>NULL</cfif>,
                    #now()#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    #session.pda.userid#
                )
            </cfquery>
        </cfif>
                
        <cf_workcube_process 
            is_upd='1' 
            data_source='#dsn#'
            old_process_line='0' 
            process_stage='#attributes.process_stage#'
            record_member='#session.pda.userid#' 
            record_date='#now()#' 
            action_table='PRO_WORKS'
            action_column='WORK_ID'
            action_id='#attributes.work_id#'
            action_page='#request.self#?fuseaction=pda.form_upd_work&id=#attributes.work_id#' 
            warning_description = 'Ilgili Is : #attributes.work_head#'>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=pda.welcome" addtoken="no">

