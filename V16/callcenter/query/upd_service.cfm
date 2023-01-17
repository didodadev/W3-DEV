 <cfif isdefined("attributes.apply_date") and isdate(attributes.apply_date) and isdefined("attributes.finish_date1") and isdate(attributes.finish_date1)>
	<cfset fark=datediff("n",attributes.apply_date,attributes.finish_date1)>
</cfif>
<cfif isdefined("attributes.apply_date") and len(attributes.apply_date)>
	<cf_date tarih="attributes.apply_date">
	<cfset apply_date=date_add("h", attributes.apply_hour - session.ep.time_zone, attributes.apply_date)>
	<cfset apply_date=date_add("n",attributes.apply_minute,apply_date)>
</cfif>
<cfif isdefined("attributes.start_date1") and len(attributes.start_date1)>
	<cf_date tarih="attributes.start_date1">
	<cfset start_date1=date_add("h", attributes.start_hour - session.ep.time_zone,attributes.start_date1)>
	<cfset start_date1=date_add("n",attributes.start_minute,start_date1)>
</cfif>
<cfif isdefined("attributes.finish_date1") and isdate(attributes.finish_date1)>
	<cf_date tarih="attributes.finish_date1">
	<cfset finish_date1=date_add("h",attributes.finish_hour - session.ep.time_zone,attributes.finish_date1)>
	<cfset finish_date1=date_add("n",attributes.finish_minute,finish_date1)>
</cfif>
<cfquery name="UPD_SERVICE" datasource="#DSN#">
	UPDATE
		G_SERVICE
	SET
		SERVICE_ACTIVE = <cfif isDefined("attributes.status") and attributes.status>1<cfelse>0</cfif>,
		SERVICECAT_ID = <cfif isdefined("appcat_id") and len(appcat_id)>#appcat_id#<cfelse>NULL</cfif>,
		SERVICE_STATUS_ID = #attributes.process_stage#,
		PRIORITY_ID = <cfif len(priority_id)>#priority_id#<cfelse>NULL</cfif>,
		COMMETHOD_ID = <cfif len(commethod_id)>#commethod_id#<cfelse>NULL</cfif>,
		SERVICE_HEAD = '#service_head#',
		SERVICE_DETAIL = <cfif len(service_detail)>'#service_detail#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			SERVICE_COMPANY_ID = #attributes.company_id#,
			SERVICE_PARTNER_ID = <cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
			SERVICE_EMPLOYEE_ID = NULL,
			SERVICE_CONSUMER_ID = NULL,
		<cfelseif isdefined("attributes.employee_id") and len(attributes.employee_id)>
			SERVICE_COMPANY_ID = NULL,
			SERVICE_PARTNER_ID = NULL,
			SERVICE_EMPLOYEE_ID = #attributes.employee_id#,
			SERVICE_CONSUMER_ID = NULL,
		<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			SERVICE_COMPANY_ID = NULL,
			SERVICE_CONSUMER_ID = #attributes.consumer_id#,
			SERVICE_EMPLOYEE_ID = NULL,
			SERVICE_PARTNER_ID = NULL,
		</cfif>
		<cfif isdefined("attributes.notify_app_type") and len(attributes.notify_app_type) and isdefined("attributes.notify_app_name") and len(attributes.notify_app_name)>
			<cfif attributes.notify_app_type is 'partner'>
				NOTIFY_PARTNER_ID = <cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
				NOTIFY_CONSUMER_ID = NULL,
				NOTIFY_EMPLOYEE_ID = NULL,
			<cfelseif attributes.notify_app_type is 'consumer'>
				NOTIFY_PARTNER_ID = NULL,
				NOTIFY_CONSUMER_ID = <cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
				NOTIFY_EMPLOYEE_ID = NULL,
			<cfelseif attributes.notify_app_type is 'employee'>
				NOTIFY_PARTNER_ID = NULL,
				NOTIFY_CONSUMER_ID = NULL,
				NOTIFY_EMPLOYEE_ID = <cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
			</cfif>
		<cfelse>
			NOTIFY_PARTNER_ID = NULL,
			NOTIFY_CONSUMER_ID = NULL,
			NOTIFY_EMPLOYEE_ID = NULL,
		</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_MEMBER = #session.ep.userid# ,
		APPLY_DATE = <cfif len(apply_date)>#apply_date#<cfelse>NULL</cfif>,
		START_DATE = <cfif isdefined("start_date1") and len(start_date1)>#start_date1#<cfelse>#now()#</cfif>,
		FINISH_DATE = <cfif len(finish_date1)>#finish_date1#<cfelse>NULL</cfif>,
		SERVICE_BRANCH_ID = <cfif isDefined("service_branch_id") AND len(service_branch_id)>#service_branch_id#<cfelse>NULL</cfif>,
		SUBSCRIPTION_ID = <cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and len(attributes.subscription_head)>#attributes.subscription_id#<cfelse>NULL</cfif>,
		PROJECT_ID = <cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
		APPLICATOR_NAME = '#attributes.member_name#',
		SEND_MAIL = <cfif isDefined("attributes.send_mail")>1<cfelse>0</cfif>,
		SEND_SMS = <cfif isDefined("attributes.send_sms")>1<cfelse>0</cfif>,
		REF_NO = <cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
        <cfif len(attributes.resp_emp_id) and len(attributes.resp_emp_name)>
       		RESP_EMP_ID = #attributes.resp_emp_id#,
            RESP_PAR_ID = NULL,
            RESP_COMP_ID = NULL,
            RESP_CONS_ID = NULL,
        <cfelseif len(attributes.resp_par_id) and len(attributes.resp_emp_name)>
        	RESP_EMP_ID = NULL,
            RESP_PAR_ID = #attributes.resp_par_id#,
            RESP_COMP_ID = #attributes.resp_comp_id#,
            RESP_CONS_ID = NULL,
        <cfelseif len(attributes.resp_cons_id) and len(attributes.resp_emp_name)>
        	RESP_EMP_ID = NULL,
            RESP_PAR_ID = NULL,
            RESP_COMP_ID = NULL,
            RESP_CONS_ID = #attributes.resp_cons_id#,
        </cfif>
		CAMPAIGN_ID = <cfif isdefined('attributes.camp_name') and len(attributes.camp_name) and isdefined('attributes.camp_id') and Len(attributes.camp_id)>#attributes.camp_id#<cfelse>NULL</cfif>,
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ,
		FUSEACTION=<cfif isdefined('attributes.url') and len(attributes.url)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.url#"><cfelse>NULL</cfif>
	WHERE
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cfquery name="GET_SERVICE1" datasource="#DSN#">
	SELECT SERVICE_ID, SERVICE_NO, SERVICE_HEAD, SERVICE_DETAIL,SERVICE_PARTNER_ID FROM G_SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cfquery name="ADD_HISTORY" datasource="#DSN#">
	INSERT INTO
		G_SERVICE_HISTORY
	(
		SERVICE_ACTIVE,
		SERVICECAT_ID,
		SERVICE_STATUS_ID,
		PRIORITY_ID,
		COMMETHOD_ID,
		SERVICE_HEAD,
		SERVICE_DETAIL,
		SERVICE_CONSUMER_ID,
		RECORD_DATE,
		RECORD_MEMBER,
		APPLY_DATE,
		FINISH_DATE,
		START_DATE,
		UPDATE_DATE,
		UPDATE_MEMBER,
		RECORD_PAR,
		UPDATE_PAR,
		APPLICATOR_NAME,
		SERVICE_ID,
		RESP_EMP_ID,
        RESP_PAR_ID,
        RESP_COMP_ID,
        RESP_CONS_ID
	)
	SELECT
		SERVICE_ACTIVE,
		SERVICECAT_ID,
		SERVICE_STATUS_ID,
		PRIORITY_ID,
		COMMETHOD_ID,
		SERVICE_HEAD,
		SERVICE_DETAIL,
		SERVICE_CONSUMER_ID,
		RECORD_DATE,
		RECORD_MEMBER,
		APPLY_DATE,
		FINISH_DATE,
		START_DATE,
		UPDATE_DATE,
		UPDATE_MEMBER,
		RECORD_PAR,
		UPDATE_PAR,
		APPLICATOR_NAME,
		SERVICE_ID,
		RESP_EMP_ID,
        RESP_PAR_ID,
        RESP_COMP_ID,
        RESP_CONS_ID
	FROM
		G_SERVICE
	WHERE
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery>
<cfif attributes.appcat_id neq attributes.old_appcat_id>
	<cfset mail_gonderisi = 1>
<cfelse>
	<cfset mail_gonderisi = 0>
</cfif>
<cfquery name="DEL_" datasource="#DSN#">
	DELETE FROM G_SERVICE_APP_ROWS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
</cfquery><!--- Xml parametresine gore alt tree kategoriler tek tek gelsin secilirse FBS 20090526 --->

<!--- Xml parametresine gore alt tree kategoriler tek tek gelsin secilirse FBS 20090526 --->
<cfif attributes.x_is_sub_tree_single_select eq 1>
	<cfquery name="ADD_SERVICE_STATUS_ROW" datasource="#DSN#">
		INSERT INTO 
			G_SERVICE_APP_ROWS
			(
				SERVICE_ID,
				SERVICECAT_ID,
				SERVICE_SUB_CAT_ID,
				SERVICE_SUB_STATUS_ID
			)
		VALUES
			(
				#attributes.service_id#,
				#attributes.appcat_id#,
				<cfif isdefined("attributes.servicecat_sub_id") and len(attributes.servicecat_sub_id)>#attributes.servicecat_sub_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.servicecat_sub_tree_id") and len(attributes.servicecat_sub_tree_id)>#attributes.servicecat_sub_tree_id#<cfelse>NULL</cfif>
			)
	</cfquery>
    <cfquery name="GET_MAX" datasource="#DSN#">
        SELECT MAX(SERVICE_HISTORY_ID) SERVICE_HISTORY_ID FROM G_SERVICE_HISTORY
    </cfquery>
    <cfquery name="ADD_SER_ST_ROW_HISTORY" datasource="#DSN#">
		INSERT INTO 
			G_SERVICE_APP_ROWS_HIST
			(
              	HISTORY_ID,
				SERVICE_ID,
				SERVICECAT_ID,
				SERVICE_SUB_CAT_ID,
				SERVICE_SUB_STATUS_ID
			)
		VALUES
			(
            	#get_max.service_history_id#,
				#attributes.service_id#,
				#attributes.appcat_id#,
				<cfif isdefined("attributes.servicecat_sub_id") and len(attributes.servicecat_sub_id)>#attributes.servicecat_sub_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.servicecat_sub_tree_id") and len(attributes.servicecat_sub_tree_id)>#attributes.servicecat_sub_tree_id#<cfelse>NULL</cfif>
			)
	</cfquery>
<cfelse>
	<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#">
		SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.appcat_id#">
	</cfquery>
	<cfset my_counter = 0>
	<cfoutput query="get_service_appcat_sub">	
		<cfif isdefined("attributes.service_sub_cat_id_#service_sub_cat_id#") and len(evaluate("attributes.service_sub_cat_id_#service_sub_cat_id#"))>
			<cfset deger = listgetat(evaluate("attributes.service_sub_cat_id_#service_sub_cat_id#"),2,',')>
            <cfif len(deger)>
                <cfif (listlen(attributes.old_app_rows) and not listfindnocase(attributes.old_app_rows,deger)) or not listlen(attributes.old_app_rows)>
                    <cfset mail_gonderisi = 1>
                </cfif>
                <cfset my_counter = 1>
                <cfquery name="ADD_SERVICE_STATUS_ROW" datasource="#DSN#">
                    INSERT INTO 
                        G_SERVICE_APP_ROWS
                        (
                            SERVICE_ID,
                            SERVICECAT_ID,
                            SERVICE_SUB_CAT_ID,
                            SERVICE_SUB_STATUS_ID
                        )
                    VALUES
                        (
                            #attributes.service_id#,
                            #attributes.appcat_id#,
                            #get_service_appcat_sub.service_sub_cat_id#,
                            #deger#
                        )
                </cfquery>
                <cfquery name="GET_MAX" datasource="#DSN#">
                    SELECT MAX(SERVICE_HISTORY_ID) SERVICE_HISTORY_ID FROM G_SERVICE_HISTORY
                </cfquery>
                <cfquery name="ADD_SER_ST_ROW_HISTORY" datasource="#DSN#">
                    INSERT INTO 
                        G_SERVICE_APP_ROWS_HIST
                        (
                            HISTORY_ID,
                            SERVICE_ID,
                            SERVICECAT_ID,
                            SERVICE_SUB_CAT_ID,
                            SERVICE_SUB_STATUS_ID
                        )
                    VALUES
                        (
                            #get_max.service_history_id#,
                            #attributes.service_id#,
                            #attributes.appcat_id#,
                            #get_service_appcat_sub.service_sub_cat_id#,
                            #deger#                    
                        )
                </cfquery>
            </cfif>	
		</cfif>	
	</cfoutput>
	<cfif my_counter eq 0>
		<cfquery name="ADD_SERVICE_STATUS_ROW" datasource="#DSN#">
			INSERT INTO 
				G_SERVICE_APP_ROWS
				(
					SERVICE_ID,
					SERVICECAT_ID
				)
			VALUES
				(
					#attributes.service_id#,
					#attributes.appcat_id#
				)
		</cfquery>
        <cfquery name="GET_MAX" datasource="#DSN#">
            SELECT MAX(SERVICE_HISTORY_ID) SERVICE_HISTORY_ID FROM G_SERVICE_HISTORY
        </cfquery>
		<cfquery name="ADD_SERVICE_STATUS_ROW_HISTORY" datasource="#DSN#">
			INSERT INTO 
				G_SERVICE_APP_ROWS_HIST
				(
                	HISTORY_ID,
					SERVICE_ID,
					SERVICECAT_ID
				)
			VALUES
				(
                	#get_max.service_history_id#,
					#attributes.service_id#,
					#attributes.appcat_id#
				)
		</cfquery>
	</cfif>
</cfif>
<!--- Mail gonder secili ise gorevlilere mail gider --->
<cfif isDefined("attributes.send_mail")>
	<cfset service_id = url.id>
	<cfquery name="GET_SERVICE_TASK" datasource="#DSN#">
		SELECT 
			EMPLOYEES.EMPLOYEE_NAME NAME,
			EMPLOYEES.EMPLOYEE_SURNAME SURNAME,
			EMPLOYEES.EMPLOYEE_EMAIL MAIL,
			1 TYPE
		FROM
			PRO_WORKS,
			EMPLOYEES
		WHERE
			PRO_WORKS.G_SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#"> AND
			EMPLOYEES.EMPLOYEE_ID = PRO_WORKS.PROJECT_EMP_ID AND
			EMPLOYEES.EMPLOYEE_EMAIL IS NOT NULL
	UNION ALL
		SELECT 
			COMPANY_PARTNER.COMPANY_PARTNER_NAME NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME SURNAME, 
			COMPANY_PARTNER.COMPANY_PARTNER_EMAIL MAIL,
			2 TYPE			
		FROM
			PRO_WORKS,
			COMPANY_PARTNER
		WHERE
			PRO_WORKS.G_SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">  AND
			COMPANY_PARTNER.PARTNER_ID = PRO_WORKS.OUTSRC_PARTNER_ID AND
			COMPANY_PARTNER.COMPANY_PARTNER_EMAIL IS NOT NULL
	</cfquery>
	<cfif get_service_task.recordcount>
		<cfoutput query="get_service_task">
			<cfset task_user_name = get_service_task.name>
			<cfset task_user_surname = get_service_task.surname>
			<cfset task_user_email = get_service_task.mail>
	
			<cfif get_service_task.type eq 1>
				<cfset form.task_position_code = 1>
			<cfelse>
				<cfset form.task_position_code = "">
			</cfif>
			<cfif len(task_user_email)>
				<cfsavecontent variable="message">#service_head# Servis Başvurusundan Adınıza Yapılmış Güncellenmiş Bir Görevlendirme !</cfsavecontent>
				<cfmail to="#task_user_email#"
					  from="#session.ep.company#<#session.ep.company_email#>"
					  subject="#message#"
					  type="HTML">
				<cfinclude template="add_work_mail.cfm">
				</cfmail>
			</cfif>
		</cfoutput>
	</cfif>
</cfif>
<!--- Sms Gonder Secilir Ise Satndart Basvuru Maili Gonderilir --->
<cfif isDefined("attributes.send_sms")>
	<cfinclude template="sms_send_info.cfm">
</cfif>
<!--- Gonderi Listesi, alt tree kategoriler tek secildiginde kullanilmayacak --->
<!---<cfif x_is_sub_tree_single_select neq 1 and (isdefined ("attributes.task_person_name") and len(attributes.task_person_name) and len(attributes.task_emp_id) and isdefined("is_send_mail") and is_send_mail eq 1) or not isdefined("is_send_mail") or (isdefined ("attributes.task_person_name") and not len(attributes.task_person_name) and isdefined("is_send_mail") and is_send_mail eq 0) or (isdefined("is_send_mail") and is_send_mail eq 1)>
--->	
<cfif attributes.x_is_sub_tree_single_select neq 1>
	<cfif mail_gonderisi eq 1>
		<cfinclude template="mail_send_list.cfm">
	</cfif>
</cfif>
<!---Ek Bilgiler--->
<cfset attributes.info_id =  attributes.service_id>
<cfset attributes.is_upd = 1>
<cfset attributes.info_type_id = -24>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!---Ek Bilgiler--->
<cf_workcube_process 
	is_upd='1' 
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='G_SERVICE'
	action_column='SERVICE_ID'
	action_id='#attributes.service_id#' 
	action_page='#request.self#?fuseaction=call.list_service&event=upd&service_id=#attributes.service_id#' 
	warning_description='<strong>#get_service1.service_head#</strong><br/><br/>#get_service1.service_detail#'>
    <cfset attributes.actionId = attributes.service_id >
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=call.list_service&event=upd&service_id=#attributes.service_id#</cfoutput>"
</script>
