<cfset temp_apply_date = attributes.apply_date>
<cfif len(attributes.apply_date)>
	<cf_date tarih="attributes.apply_date">
	<cfset attributes.apply_date=date_add("H", attributes.apply_hour - session.ep.time_zone,attributes.apply_date)>
	<cfset attributes.apply_date=date_add("N", attributes.apply_minute,attributes.apply_date)>
</cfif>
<cfif isdefined("attributes.start_date1") and len(attributes.start_date1)>
	<cf_date tarih="attributes.start_date1">
	<cfset attributes.start_date1=date_add("H", attributes.start_hour - session.ep.time_zone,attributes.start_date1)>
	<cfset attributes.start_date1=date_add("N", attributes.start_minute,attributes.start_date1)>
</cfif>
<cfif not (isdefined("attributes.service_default_no") and len(attributes.service_default_no))>
	<cftransaction>
		<cf_papers paper_type="g_service_app">
		<cfset system_paper_no=paper_code & '-' & paper_number>
		<cfset system_paper_no_add=paper_number>
		<cfif len(system_paper_no_add)>
			<cfquery name="UPD_GEN_PAP" datasource="#DSN#">
				UPDATE
					GENERAL_PAPERS_MAIN
				SET
					G_SERVICE_APP_NUMBER = #system_paper_no_add#
				WHERE
					G_SERVICE_APP_NUMBER IS NOT NULL
			</cfquery>
		</cfif>
	</cftransaction>
<cfelse>
	<cfstoredproc procedure="WRK_GENERATESERVICENO" datasource="#dsn#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#attributes.service_default_no#">
		<cfprocparam TYPE="IN" cfsqltype="cf_sql_varchar" value="#session.ep.userid#">
		<cfprocresult name="get_paper_no">
	</cfstoredproc>
	<cfset system_paper_no=get_paper_no.ServiceNo>
</cfif>
<cfquery name="ADD_SERVICE" datasource="#DSN#"  result="my_result">
	INSERT INTO
		G_SERVICE
		(
			SERVICE_ACTIVE,
			ISREAD,
			SERVICECAT_ID,
			SERVICE_STATUS_ID,
			PRIORITY_ID,
			COMMETHOD_ID,
			SERVICE_HEAD,
			SERVICE_DETAIL,
			APPLY_DATE,
			START_DATE,
			SERVICE_EMPLOYEE_ID,
			SERVICE_CONSUMER_ID,
			SERVICE_COMPANY_ID,
			SERVICE_PARTNER_ID,
			NOTIFY_PARTNER_ID,
			NOTIFY_CONSUMER_ID,
			NOTIFY_EMPLOYEE_ID,
			SERVICE_BRANCH_ID,
			APPLICATOR_NAME,
			SERVICE_NO,
			SUBSCRIPTION_ID,
			PROJECT_ID,
			REF_NO,
			CUS_HELP_ID,
			RECORD_DATE,
			RECORD_MEMBER,
			RESP_EMP_ID,
			CAMPAIGN_ID,
			OUR_COMPANY_ID	
		)
		VALUES
		(
			1,
			0,
			<cfif len(appcat_id)>#appcat_id#<cfelse>NULL</cfif>,
			#attributes.process_stage#,
			<cfif len(priority_id)>#priority_id#<cfelse>NULL</cfif>,
			<cfif len(commethod_id)>#commethod_id#<cfelse>NULL</cfif>,
			<cfif len(service_head)>'#service_head#'<cfelse>'#system_paper_no#'</cfif>,
			<cfif isdefined("service_detail") and len(service_detail)>'#service_detail#'<cfelse>NULL</cfif>,
			<cfif len(attributes.apply_date)>#attributes.apply_date#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.start_date1") and len(attributes.start_date1)>#attributes.start_date1#<cfelseif len(attributes.apply_date)>#attributes.apply_date#<cfelse>NULL</cfif>,
			<cfif isDefined("employee_id") and len(employee_id)>#employee_id#<cfelse>NULL</cfif>,
			<cfif isDefined("consumer_id") and len(consumer_id)>#consumer_id#<cfelse>NULL</cfif>,
			<cfif isDefined("company_id") and len(company_id)>#company_id#<cfelse>NULL</cfif>,
			<cfif isDefined("partner_id") and len(partner_id)>#partner_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.notify_app_type") and len(attributes.notify_app_type) and isdefined("attributes.notify_app_name") and len(attributes.notify_app_name)>
				<cfif attributes.notify_app_type is 'partner'>
					<cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
					NULL,
					NULL,
				<cfelseif attributes.notify_app_type is 'consumer'>
					NULL,
					<cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
					NULL,
				<cfelseif attributes.notify_app_type is 'employee'>
					NULL,
					NULL,
					<cfif len(attributes.notify_app_id)>#attributes.notify_app_id#<cfelse>NULL</cfif>,
				</cfif>
			<cfelse>
				NULL,
				NULL,
				NULL,
			</cfif>
			
			<cfif isDefined("service_branch_id") and len(service_branch_id)>#service_branch_id#<cfelse>NULL</cfif>,
			'#member_name#',
			'#system_paper_no#',
			<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.cus_help_id") and len(attributes.cus_help_id)>#attributes.cus_help_id#<cfelse>NULL</cfif>,
			#now()#,
			#session.ep.userid#,
			<cfif isdefined("attributes.resp_emp_id") and len(attributes.resp_emp_id)>#attributes.resp_emp_id#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.camp_name') and len(attributes.camp_name) and isdefined('attributes.camp_id') and Len(attributes.camp_id)>#attributes.camp_id#<cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
		)
</cfquery>
<cfquery name="GET_SERVICE1" datasource="#DSN#">
	SELECT SERVICE_ID, SERVICE_NO, SERVICE_HEAD, SERVICE_DETAIL,SERVICE_PARTNER_ID FROM G_SERVICE WHERE RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND SERVICE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#system_paper_no#">
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
			RESP_EMP_ID
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
			RESP_EMP_ID
		FROM
			G_SERVICE
		WHERE
			SERVICE_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_service1.service_id#">
</cfquery>
<!--- Xml parametresine gore alt tree kategoriler tek tek gelsin secilirse FBS 20090526 --->
<cfif x_is_sub_tree_single_select eq 1>
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
				#get_service1.service_id#,
				#attributes.appcat_id#,
				<cfif isdefined("attributes.servicecat_sub_id") and len(attributes.servicecat_sub_id)>#attributes.servicecat_sub_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.servicecat_sub_tree_id") and len(attributes.servicecat_sub_tree_id)>#attributes.servicecat_sub_tree_id#<cfelse>NULL</cfif>
			)
	</cfquery>
<cfelse>
	<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#">
		SELECT SERVICE_SUB_CAT_ID, SERVICE_SUB_CAT, SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.appcat_id#">
	</cfquery>
	<cfset my_counter = 0>
	<cfoutput query="get_service_appcat_sub">
		<cfif isdefined("attributes.service_sub_cat_id_#service_sub_cat_id#") and len(evaluate("attributes.service_sub_cat_id_#service_sub_cat_id#"))>
			<cfset deger = evaluate("attributes.service_sub_cat_id_#service_sub_cat_id#")>
			<cfif len(deger)>
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
							#get_service1.service_id#,
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
					#get_service1.service_id#,
					#attributes.appcat_id#
				)
		</cfquery>
	</cfif>
</cfif>
<cfif isdefined("attributes.task_person_name") and len(attributes.task_person_name) and len(attributes.task_emp_id)>
	<cfset attributes.startdate_plan = temp_apply_date>
	<!--- BK isin ayni gun aynı saate yazilmamisi icin 1 gun sonra bitis tarihi --->
	<cf_date tarih='temp_apply_date'>
	<cfset attributes.finishdate_plan = dateformat(date_add('d',1,temp_apply_date),dateformat_style)>
	<cfset attributes.finish_hour_plan = attributes.apply_hour>
	<cfset attributes.start_hour = attributes.apply_hour>
	<cfset attributes.work_fuse = 'service.add_service'>
	<cfset attributes.work_head = left(attributes.service_head,100)>
	<cfset attributes.work_detail = attributes.service_detail>
	<cfset attributes.project_emp_id = attributes.task_emp_id>
	<cfif len(attributes.consumer_id)>
		<cfset attributes.company_partner_id = attributes.consumer_id>
	<cfelse>
		<cfset attributes.company_id = attributes.company_id>
		<cfset attributes.company_partner_id = attributes.partner_id>
	</cfif>
	<cfquery name="GET_WORK_CAT" datasource="#DSN#" maxrows="1">
		SELECT WORK_CAT_ID, WORK_CAT FROM PRO_WORK_CAT ORDER BY WORK_CAT
	</cfquery>
	<cfset attributes.pro_work_cat = get_work_cat.work_cat_id>
	<cfif len(attributes.priority_id)>
		<cfset attributes.priority_cat = attributes.priority_id>
	<cfelse>
		<cfquery name="GET_CATS" datasource="#DSN#" maxrows="1">
			SELECT PRIORITY_ID, PRIORITY FROM SETUP_PRIORITY ORDER BY PRIORITY
		</cfquery>
		<cfset attributes.priority_cat = get_cats.priority_id>
	</cfif>
	<cfquery name="GET_WORK_PROCESS" datasource="#DSN#" maxrows="1">
		SELECT TOP 1
			PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
			PROCESS_TYPE_ROWS.STAGE,
			PROCESS_TYPE_ROWS.LINE_NUMBER LINE_NUMBER,
			PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
		FROM
			PROCESS_TYPE PROCESS_TYPE,
			PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
			PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS
		WHERE
			PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
			PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
			PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.addwork,%">
	</cfquery>
	<cfset attributes.work_process_stage = get_work_process.process_row_id>
</cfif>

<cfif isdefined("attributes.task_person_name") and  len(attributes.task_person_name) and len(attributes.task_emp_id)>
	<cfset attributes.g_service_id = get_service1.service_id>
	<cfset attributes.our_company_id = session.ep.company_id>
	<cfset attributes.is_mail = 1>
	<cfset attributes.WORK_STATUS = 1>
    <cfif isdefined("attributes.resp_emp_id") and len(attributes.resp_emp_id)>
    	<cfset attributes.cc_emp_id = attributes.resp_emp_id>
    <cfelse>
    	<cfset attributes.cc_emp_id = ''>
    </cfif>
	<cfinclude template="../../project/query/add_work.cfm">
</cfif>
<!--- Gonderi Listesi, alt tree kategoriler tek secildiginde kullanilmayacak --->
<cfif x_is_sub_tree_single_select eq 1 > <!---and ((isdefined("attributes.task_person_name") and len(attributes.task_person_name) and len(attributes.task_emp_id) and isdefined("is_send_mail") and is_send_mail eq 1) or not isdefined("is_send_mail") or (not len(attributes.task_person_name) and isdefined("is_send_mail") and is_send_mail eq 0) or (isdefined("is_send_mail") and is_send_mail eq 1))>--->
	<cfinclude template="mail_send_list.cfm">
</cfif>
<cfif x_subs_team_mail eq 1 and isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
	<cfquery name="get_subscription_team" datasource="#dsn#">
		SELECT 
			EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME AS NAME, 
			EMPLOYEE_EMAIL,
			SUBSCRIPTION_STAGE,
			STAGE
		FROM WORK_GROUP 
		LEFT JOIN #dsn3#.SUBSCRIPTION_CONTRACT ON WORK_GROUP.ACTION_ID = SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID
		LEFT JOIN PROCESS_TYPE_ROWS ON PROCESS_TYPE_ROWS.PROCESS_ROW_ID = SUBSCRIPTION_CONTRACT.SUBSCRIPTION_STAGE
		LEFT JOIN WORKGROUP_EMP_PAR ON WORK_GROUP.WORKGROUP_ID = WORKGROUP_EMP_PAR.WORKGROUP_ID 
		LEFT JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID= WORKGROUP_EMP_PAR.EMPLOYEE_ID
		WHERE 
			ACTION_FIELD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="subscription">
			AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
	</cfquery>	
	<cfset target_domain = employee_url>
	<cftry>
		<cfset sender='#session.ep.company#<#session.ep.company_email#>'>
		<cfoutput query="get_subscription_team">			
			<cfif len(employee_email)>
				<cfmail from="#sender#" to="#employee_email#" subject="Başvuru Kayıt Bilgilendirme - #get_service1.service_no#" type="html" charset="utf-8">
					<table width="50%" border="0">
						#EMPLOYEE_EMAIL#
						<tr class="color-header">
							<td colspan="2"><b><cf_get_lang dictionary_id='58780.Sayın'></b> #name#,</td>
						</tr>
						<tr>
							<td colspan="2"><b><cf_get_lang dictionary_id='61970.Adınıza Yapılmış Yeni Bir Başvuru Var. İlgili Başvuruya Aşağıdaki Linki Tıklayarak Ulaşabilirsiniz.'></b></td>
						</tr>
						<tr>
							<td><b><cf_get_lang dictionary_id='61969.Başvuru Adı'>:</b></td>
							<td>#service_head#</td>
						</tr>
						<tr>
							<td><b><cf_get_lang dictionary_id='40124.Abone Durumu'>:</b></td>
							<td>#stage#</td>
						</tr>
						<tr>
							<td><b><cf_get_lang dictionary_id='57629.Açıklama'></b>: </td>
							<td>#service_detail#</td>
						</tr>
						<tr>
							<td><b><cf_get_lang dictionary_id='61968.İlgili Başvuru'>:</b></td>
							<td><a href="#target_domain#/#request.self#?fuseaction=call.list_service&event=upd&service_id=#get_service1.service_id#&service_no=#get_service1.service_no#" target="_blank">#get_service1.service_no#</a></td>
						</tr>
						<tr>
							<td><b><cf_get_lang dictionary_id='41084.İyi çalışmalar'></b></td>
						</tr>
					</table>	
				</cfmail>	
			</cfif>
		</cfoutput>
	   	
		<script type="text/javascript">
		 	alert("<cf_get_lang_main no='101.Mail Başarıyla Gönderildi'>");
		</script>
		<cfcatch>	
			<script type="text/javascript">
				alert("Mail gönderilemedi!");
		   </script>	
		</cfcatch>
	</cftry>
</cfif>
<!---Ek Bilgiler----->
<cfset attributes.info_id = my_result.IDENTITYCOL>
<cfset attributes.is_upd = 0>
<cfset attributes.info_type_id = -24>
<cfinclude template="../../objects/query/add_info_plus2.cfm">
<!----Ek Bilgiler--->
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#'
	action_table='G_SERVICE'
	action_column='SERVICE_ID'
	action_id='#get_service1.service_id#'
	action_page='#request.self#?fuseaction=call.list_service&event=upd&service_id=#get_service1.service_id#' 
	warning_description='<strong>#get_service1.service_head#</strong><br><br>#get_service1.service_detail#'>

<cfset attributes.actionId = get_service1.service_id >
<cfif attributes.my_fuseaction contains 'popup'>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse>
	<script type="text/javascript">
		window.location.href="<cfoutput>#request.self#?fuseaction=call.list_service&event=upd&service_id=#get_service1.service_id#</cfoutput>";
	</script>
</cfif>
