
<cfobject name="product_plan" component="WBP.Fashion.files.cfc.product_plan">
<cfset plan_process_stage=attributes.process_stage>
<cfif len(attributes.project_emp_id) and len(attributes.emp_name) and not len(attributes.work_id)>
   <cfscript>
       if(not len(attributes.date_start))
       {
           attributes.date_start=now();
       }
       workid=addwork(
               service_head:'Plan Id :'& attributes.plan_id & ' '& attributes.plan_type & ' Görevi',
               service_detail:'Plan Id :'& attributes.plan_id & ' '& attributes.plan_type & ' Görevi',
               project_id:attributes.project_id,
               company_id:attributes.company_id,
               partner_id:attributes.partner_id,
               company_name:"",
               partner_name:"",
               pstartdate:attributes.date_start,
               pfinishdate:attributes.date_finish,
               pro_work_cat:1,
               project_emp_id:attributes.project_emp_id
       );
   </cfscript>

   <cfset attributes.work_id=workid>
</cfif>
   <cfscript>
       empid='';
       if (len(attributes.project_emp_id) and len(attributes.emp_name) and attributes.project_emp_id neq attributes.old_project_emp_id)
       {
           empid=attributes.project_emp_id;
           attributes.date_start="";
           attributes.date_finish="";
           if(not len(attributes.date_start))
               attributes.date_start=now();
           else
           {
               year=Year(attributes.date_start);
               month=Month(attributes.date_start);
               day=Day(attributes.date_start);
               if(len(attributes.date_start_hour))
                   hour=attributes.date_start_hour;
               else
                   hour=Hour(now());
               if(len(attributes.date_start_minute))
                   minute=attributes.date_start_minute;
               else
                   minute=Minute(now());
               
               attributes.date_start=CreateDateTime(year, month, day, hour, minute);
           }
       }
       else if(len(attributes.project_emp_id) and len(attributes.emp_name) and attributes.project_emp_id eq attributes.old_project_emp_id)
       {
           empid=attributes.project_emp_id;
           if(len(attributes.date_start))
           {
               year=Year(attributes.date_start);
               month=Month(attributes.date_start);
               day=Day(attributes.date_start);
               if(len(attributes.date_start_hour))
                   hour=attributes.date_start_hour;
               else
                   hour=Hour(now());
               if(len(attributes.date_start_minute))
                   minute=attributes.date_start_minute;
               else
                   minute=Minute(now());
               
               attributes.date_start=CreateDateTime(year, month, day, hour, minute);
           }
           if(len(attributes.date_finish))
           {
               year=Year(attributes.date_finish);
               month=Month(attributes.date_finish);
               day=Day(attributes.date_finish);
               if(len(attributes.date_finish_hour))
                   hour=attributes.date_finish_hour;
               else
                   hour=Hour(now());
               if(len(attributes.date_finish_minute))
                   minute=attributes.date_finish_minute;
               else
                   minute=Minute(now());
               
               attributes.date_finish=CreateDateTime(year, month, day, hour, minute);
           }
       }
       else if(not len(attributes.project_emp_id) or not len(attributes.emp_name))
       {
           attributes.date_start="";
           attributes.date_finish="";
           
       }

       updateResult=product_plan.update_productplan
       (
           plan_id:attributes.plan_id,
           req_id:attributes.req_id,
           project_id:attributes.project_id,
           plan_date:attributes.plan_date,
           start_date:attributes.date_start,
           finish_date:attributes.date_finish,
           stage:plan_process_stage,
           task_emp:empid,
           active:'#IIf(IsDefined("attributes.status_plan"),"attributes.status_plan",DE(""))#',
           work_id:attributes.work_id
       );
   </cfscript>

<cfif attributes.referel_page eq 'wash_plan'>
   <cfobject name="wash_plan" component="WBP.Fashion.files.cfc.wash_plan">
   <cfset process_count=attributes.process_count>
   <cfloop from="1" to="#process_count#" index="i">
     
                    <cfscript>
                       delResult=wash_plan.del_washplan
                        (
                            plan_id:attributes.plan_id,
                            req_id:attributes.req_id,
                            wash_type:#i#
                        );
                    </cfscript>
         <cfif isdefined("attributes.islem#i#") and listlen(evaluate("attributes.islem#i#"))>
            <cfloop list="#evaluate("attributes.islem#i#")#" index="x">
                     <cfscript>
                            addResult=wash_plan.add_washplan
                            (
                                plan_id:attributes.plan_id,
                                req_id:attributes.req_id,
                                wash_type:#i#,
                                wash_value_id:x,
                                price:0
                            );
                    </cfscript>
            </cfloop>
       </cfif>
    </cfloop>
</cfif> 
   
   <cf_workcube_process 
       is_upd='1' 
       data_source='#dsn3#' 
       old_process_line='0'
       process_stage='#attributes.process_stage#' 
       record_member='#session.ep.userid#'
       record_date='#now()#' 
       action_table='TEXTILE_PRODUCT_PLAN'
       action_column='PLAN_ID'
       action_id='#attributes.plan_id#'
       action_page='#request.self#?fuseaction=textile.#attributes.referel_page#&event=upd&plan_id=#attributes.plan_id#' 
       warning_description='#attributes.referel_page# : #attributes.plan_id#'>
   <script>
   window.location.href= '<cfoutput>#request.self#?fuseaction=textile.#attributes.referel_page#&event=upd&plan_id=#attributes.plan_id#</Cfoutput>';
</script>
  
<cffunction name="addwork" returnformat="plain" output="no">
   <cfargument name="service_head" type="string" required="yes">
   <cfargument name="service_detail" type="string" required="yes">
   <cfargument name="project_id" type="string" required="yes">
   <cfargument name="company_id" type="string" required="yes">
   <cfargument name="partner_id" type="string" required="yes">
   <cfargument name="company_name" type="string" required="yes">
   <cfargument name="partner_name" type="string" required="yes">
   <cfargument name="pstartdate" type="string" required="no">
   <cfargument name="pfinishdate" type="string" required="no">
   <cfargument name="gstartdate" type="string" required="no">
   <cfargument name="gfinishdate" type="string" required="no">
   <cfargument name="pro_work_cat" type="string" required="no">
   <cfargument name="project_emp_id" required="yes" type="string">   
       <cfset our_company_id=session.ep.company_id>
       <cfset process_stage_id="">
       <cfset subscription_id=1>
       <cfset priority_id=1>
       <cftransaction action="begin">	                       
           <cfset attributes.project_emp_id = arguments.PROJECT_EMP_ID>
           <cfset caller.attributes.fuseaction = "project.upd_work">
           <cfset attributes.module_name = "project">
           <cfset attributes.lang_name = "tr">
           <cfset caller.language = 'tr'>
           <cfset caller.lang_auto_control = 1>
           <cfset attributes.is_mobile = 1>
           <cfset caller.dsn3 = dsn3>
           <cfset caller.dsn = dsn>
           <cfset caller.fusebox.workcube_mode = 1>
           <cfif arguments.company_id gt 0>
               <cfset attributes.company_id = arguments.company_id>
           <cfelse>
               <cfset attributes.company_id =""><!---bireysel üyeiçin--->
           </cfif>
           <cfset attributes.is_mail = 0>
           <cfset attributes.our_company_id = our_company_id>
           <cfset attributes.startdate_plan = NOW()>
           <!---<cfset employee_domain = 'http://#listfirst(employee_url,';')#/'>--->
           <cfset attributes.project_id = arguments.project_id>
           <cfset attributes.work_head = left(arguments.service_head,100)>
           <cfset attributes.fuseaction = "project.add_service">
           <cfset attributes.company_partner_id =arguments.partner_id>
           <cfset language = 'tr'>
           <cfif not (IsDefined("arguments.pro_work_cat") and len(arguments.pro_work_cat))>
               <cfquery name="GET_WORK_CAT" datasource="#DSN#" maxrows="1">
                       SELECT WORK_CAT_ID, WORK_CAT FROM #dsn#.PRO_WORK_CAT ORDER BY WORK_CAT
               </cfquery>
               <cfset attributes.PRO_WORK_CAT = GET_WORK_CAT.WORK_CAT_ID>
           <cfelse>
               <cfset attributes.PRO_WORK_CAT =arguments.pro_work_cat>
           </cfif>
           <cfquery name="GET_CATS" datasource="#DSN#" maxrows="1">
               SELECT PRIORITY_ID, PRIORITY FROM #dsn#.SETUP_PRIORITY ORDER BY PRIORITY
           </cfquery>
           <cfset attributes.PRIORITY_CAT = GET_CATS.PRIORITY_ID>
           <cfquery name="GET_WORK_PROCESS" datasource="#DSN#" maxrows="1">
               SELECT TOP 1
                   PTR.STAGE,
                   PTR.PROCESS_ROW_ID
               FROM 
                   #dsn#.PROCESS_TYPE_ROWS  PTR,																								
                   #dsn#.PROCESS_TYPE_OUR_COMPANY PTO,
                   #dsn#.PROCESS_TYPE PT
               WHERE
                   PT.PROCESS_ID = PTR.PROCESS_ID AND
                   PT.PROCESS_ID = PTO.PROCESS_ID AND
                   PTO.OUR_COMPANY_ID = #our_company_id# AND <!--- company_id gönderilsin --->
                   PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.addwork,%">
                   ORDER BY
                           PTR.LINE_NUMBER
           </cfquery>
           <cfset attributes.work_process_stage = get_work_process.PROCESS_ROW_ID>

           <cfset process_stage_id=attributes.work_process_stage>
           <cfset file_web_path = '/documents/'>
           <cfset attributes.process_stage = process_stage_id>
           <cfset user_domain = 'http://#cgi.http_host#/'>
           <cfset attributes.work_status = 1>
           <cfset attributes.work_fuse = 'service.add_service'>
           <cfset attributes.work_detail = arguments.service_detail>
           <cfset attributes.apply_date = arguments.pstartdate>
           <cfset attributes.apply_hour = Hour(NOW())> 
           <cfset attributes.apply_minute = Minute(NOW())>  
           <cfset temp_apply_date = attributes.apply_date>
           <cfset attributes.startdate_plan = dateFormat(temp_apply_date, dateformat_style)>
           <cfscript>
                   CALLER.WORKCUBE_MODE=1;
           </cfscript>
           <cfif not isDate(temp_apply_date)>
               <cf_date tarih='temp_apply_date'>
           </cfif>
           <cfset attributes.finishdate_plan = dateformat(dateadd('d',1,temp_apply_date),'dd/mm/yyyy')>
           <cfset attributes.finish_hour_plan = attributes.apply_hour>
           <cfset attributes.finish_hour = attributes.apply_hour>
           <cfset attributes.start_hour = attributes.apply_hour>
           <cfset attributes.old_process_line = 0>
           <!---<cfset attributes.action_id = XXX.IDENTITYCOL>--->
                                                                                                                                                                                                                       </cftransaction>
   <cfinclude template="add_work.cfm">
                       
   <cfscript>
       sonuc = get_last_work.work_id;
   </cfscript>
   <cfreturn sonuc>
</cffunction>