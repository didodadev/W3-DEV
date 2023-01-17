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
<cfif isdefined('attributes.record_num') and len(attributes.record_num) and attributes.record_num neq "">
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif isdefined("attributes.work_id#i#")>
            <cfif Len(evaluate("attributes.work_id#i#"))>
                <cfquery name="get_related_work_help" datasource="#dsn#">
                    SELECT CUS_HELP_ID FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.work_id#i#')#">
                </cfquery>
            </cfif>
            <cfscript>
                if(Len(evaluate('attributes.work_id#i#')))
                    form_cus_help_id = get_related_work_help.cus_help_id;
                else
                    form_cus_help_id = "";
    
                form_total_time_hour = evaluate("attributes.time_hour#i#");
                form_total_time_minute = evaluate("attributes.time_minute#i#");
                form_project_id = evaluate("attributes.project_id#i#");
                form_project = evaluate("attributes.project#i#");
                form_work_id = evaluate("attributes.work_id#i#");
                form_work_head = evaluate("attributes.work_head#i#");
                
                if(isdefined("attributes.employee_id#i#"))
                form_employee_id = evaluate("attributes.employee_id#i#");
    
                if(isdefined("attributes.partner_id#i#"))
                form_partner_id = evaluate("attributes.partner_id#i#");
                
                if(isdefined("attributes.company_id#i#"))
                form_company_id = evaluate("attributes.company_id#i#");
    
                form_member_name = evaluate("attributes.member_name#i#");
                form_row_kontrol = evaluate("attributes.row_kontrol#i#");
            </cfscript>
            
            <!--- SAAT ÜCRETİ HESAPLAMASI --->
            <cfquery name="get_hourly_salary" datasource="#dsn#">
                SELECT 
                    ON_MALIYET,
                    ON_HOUR 
                FROM 
                    EMPLOYEE_POSITIONS 
                WHERE 
                    EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND IS_MASTER = 1
            </cfquery>
            <cfif get_hourly_salary.recordcount and not len(get_hourly_salary.ON_MALIYET) or not len(get_hourly_salary.ON_HOUR)>
                <script type="text/javascript">
                    alert("İnsan Kaynakları Bölümü Pozisyon Çalışma Maliyetinizi Belirtilmemiş !");
                    history.back();
                </script>
                <cfabort>
            <cfelse>
                <cfset salary_minute = get_hourly_salary.on_maliyet/get_hourly_salary.on_hour/60>
            </cfif>
            
            <cfif form_row_kontrol eq 1>
                <cfset degerim = 1> 
                <cf_date tarih="attributes.today">
                <cfif isdefined("form_total_time_hour") and len(form_total_time_hour)>
                    <cfset totalhour = form_total_time_hour>
                <cfelse>
                    <cfset totalhour=0>
                </cfif>
                <cfif isdefined("form_total_time_minute") and len(form_total_time_minute)>
                    <cfset totalminute = form_total_time_minute>
                <cfelse>
                    <cfset totalminute = 0>
                </cfif>
                <cfif totalminute lt 0>
                    <cfset totalminute = abs(totalminute)>
                    <cfset totalminute = 60 - totalminute>*
                    <cfset totalhour = totalhour-1>
                </cfif>
                <cfset topson=(totalhour*60) + totalminute>
        
                <cfset total_min=(totalhour*60)+totalminute>
                <cfset para=wrk_round(salary_minute*total_min*degerim)>
    
    
                <cfif (len(form_total_time_hour) or len(form_total_time_minute)) and (form_total_time_hour+form_total_time_minute) neq 0>
                    <cfquery name="ADD_TIME_COST" datasource="#dsn#">
                        INSERT INTO
                            TIME_COST
                        (
                            TOTAL_TIME,
                            EXPENSED_MINUTE,
                            EVENT_DATE,
                            WORK_ID,
                            COMMENT,
                            PROJECT_ID,
                            EMPLOYEE_ID,
                            PARTNER_ID,
                            COMPANY_ID,
                            TIME_COST_STAGE,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        )
                        VALUES
                        (
                            #wrk_round(TOPSON)#,
                            #TOTAL_MIN#,
                            #attributes.today#,
                            <cfif len(form_work_id) and len(form_work_head)>#form_work_id#<cfelse>NULL</cfif>,
                            <cfif len(form_work_id) and len(form_work_head)>'#form_work_head#'<cfelse>NULL</cfif>,
                            <cfif isdefined("form_project_id") and len(form_project_id) and isdefined("form_project") and len(form_project)>#form_project_id#,<cfelse>NULL,</cfif>
                            <cfif isdefined("form_employee_id") and len(form_member_name)>#form_employee_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("form_partner_id") and len(form_partner_id) and len(form_member_name)>#form_partner_id#<cfelse>NULL</cfif>,
                            <cfif isdefined("form_company_id") and len(form_company_id) and len(form_member_name)>#form_company_id#<cfelse>NULL</cfif>,
                            <cfif isdefined('get_process_stage.process_row_id') and len(get_process_stage.process_row_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_process_stage.process_row_id#"><cfelse>NULL</cfif>,
                            #now()#,
                            #session.ep.userid#,
                            '#cgi.remote_addr#'
                        )
                    </cfquery>
                </cfif>
            </cfif>
        </cfif>
	</cfloop>
</cfif>
<cflocation url="#request.self#?fuseaction=hr.distribution_entry" addtoken="No">
