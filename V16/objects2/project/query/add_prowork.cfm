<cfset type = evaluate(#listgetat(form.task_,4,',')#)><!--- FA 20070219 selectboxdan gelen id degerlerini çekmek için hem kurumsal hem çalısan için --->
<cf_date tarih="attributes.work_h_start">
<cf_date tarih="attributes.work_h_finish">
<cfset attributes.work_h_start = date_add("h",start_hour - session.pp.time_zone,attributes.work_h_start)>
<cfset attributes.work_h_finish = date_add("h",finish_hour - session.pp.time_zone,attributes.work_h_finish)>
<cfif attributes.pro_h_start gt attributes.work_h_start>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1498.Girdiğiniz İşin Hedef Başlangıç Tarihi Projesinin Hedef Başlangıç Tarihinden Önce Gözüküyor Lütfen Düzeltin'>!");
		history.back();
	</script>
	<cfabort>
<cfelseif attributes.pro_h_finish lt attributes.work_h_finish>
	<script type="text/javascript">
		alert("Girdiğiniz İşin Hedef Bitiş Tarihi Projesinin Hedef Bitiş Tarihinden Sonra Gözüküyor  Lütfen Düzeltin!");
		history.back();
	</script>
	<cfabort>
<cfelseif attributes.work_h_start gt attributes.work_h_finish>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1500.Girdiğiniz İşin Hedef Başlangıç Tarihi ile Hedef Bitiş Tarihi Mantıklı Gözükmüyor Lütfen Düzeltin'>!");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfquery name="GET_REL_WORK_PRO" datasource="#DSN#">
		SELECT
			TARGET_START
		FROM
			PRO_WORKS
		WHERE	
			WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#rel_work_id#">
	</cfquery>
	<cfset rel_work_bdate=get_rel_work_pro.target_start>
	<cfset work_bdate=attributes.work_h_start>
	<cfif work_bdate lt rel_work_bdate>
		<script type="text/javascript">
			alert("İlişkilendirdiğiniz İşin Başlangıç Tarihi, İşin Başlangıç Tarihinden Küçük Gözüküyor!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfif isdefined("url.id")>
		<cfset form.project_id = url.id>
	</cfif>
	<cflock name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfif IsDefined ("form.work_head") and isdate(form.work_h_start)>
				<cfquery name="ADD_WORK" datasource="#DSN#">
					INSERT INTO 
						PRO_WORKS 
						(
							WORK_CAT_ID,
							PROJECT_ID,
							COMPANY_ID,
							COMPANY_PARTNER_ID,						
							RELATED_WORK_ID,
							<cfif isdefined("form.estimated_time") and len(form.estimated_time)>
								ESTIMATED_TIME,
							</cfif>
							<cfif isdefined("form.expected_budget") and len(form.expected_budget)>
								EXPECTED_BUDGET,
							</cfif>
							<cfif isdefined("form.expected_budget_money") and len(form.expected_budget_money)>
								EXPECTED_BUDGET_MONEY,
							</cfif>
							PROJECT_EMP_ID,							
							OUTSRC_CMP_ID,
							OUTSRC_PARTNER_ID,
							WORK_HEAD,
							WORK_DETAIL,
							TARGET_START,
							TARGET_FINISH,
							RECORD_PAR,
							WORK_CURRENCY_ID,
							WORK_PRIORITY_ID,
							RECORD_DATE,
							RECORD_IP,
							WORK_STATUS
						)
					VALUES 
						(
							#attributes.pro_work_cat#,
							#project_id#,
							#attributes.company_id#,
							#attributes.partner_id#,
							<cfif isdefined("form.rel_work_id") and len(form.rel_work_id)>
								#form.rel_work_id#,
							<cfelse>
								NULL,
							</cfif>
							<cfif isdefined("form.estimated_time") and len(form.estimated_time)>
								#estimated_time#,
							</cfif>
							<cfif isdefined("form.expected_budget") and len(form.expected_budget)>
								#expected_budget#,
							</cfif>
							<cfif isdefined("form.expected_budget_money") and len(form.expected_budget_money)>
								'#expected_budget_money#',
							</cfif>								
							<cfif type eq '1'>
								#listgetat(form.task_,3,',')#,
							<cfelse>
								NULL,
							</cfif>
							<cfif type eq '2' or type eq '3'>
								#listgetat(form.task_,2,',')#,
								#listgetat(form.task_,3,',')#,
							<cfelse>
								NULL,
								NULL,
							</cfif>
							'#form.work_head#',
							'#form.work_detail#',
							#attributes.work_h_start#,
							#attributes.work_h_finish#,
							#session.pp.userid#,
							#attributes.process_stage#,
							#form.priority_cat#,
							#NOW()#,
							'#CGI.REMOTE_ADDR#',
							1
							)
				</cfquery>
			</cfif>
			<cfquery name="GET_LAST_WORK" datasource="#DSN#">
				SELECT MAX(WORK_ID) AS WORK_ID FROM PRO_WORKS
			</cfquery>
			<cfif isdefined("form.rel_work_id") and len(form.rel_work_id)>
				<cfquery name="ADD_RELATION" datasource="#DSN#">
					INSERT INTO
						PRO_WORK_RELATIONS
						(
							WORK_ID,
							PRE_ID
						)
					VALUES
						(
							#GET_LAST_WORK.WORK_ID#,
							#REL_WORK_ID#
						)
				</cfquery>
			</cfif>
			<cfif listgetat(attributes.task_,4,',') eq 1>
				<cfquery name="GET_EMAIL_ADDRESS" datasource="#DSN#">
					SELECT EMPLOYEE_ID, EMPLOYEE_NAME AS NAME, EMPLOYEE_SURNAME AS SURNAME, EMPLOYEE_EMAIL AS EMAIL_ADDRESS FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.task_,3,',')#">
				</cfquery>
			<cfelse>
				<cfquery name="GET_EMAIL_ADDRESS" datasource="#DSN#">
					SELECT PARTNER_ID, COMPANY_PARTNER_EMAIL AS EMAIL_ADDRESS, COMPANY_PARTNER_NAME AS NAME, COMPANY_PARTNER_SURNAME AS SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.task_,3,',')#">
				</cfquery>
			</cfif>
			<cfquery name="ADD_WORK_HISTORY" datasource="#DSN#">
				INSERT INTO
					PRO_WORKS_HISTORY
					(
						WORK_CAT_ID,
						WORK_ID,
						COMPANY_ID,
						COMPANY_PARTNER_ID,
						PROJECT_ID,
						WORK_HEAD,
						WORK_DETAIL,
						RELATED_WORK_ID,
						PROJECT_EMP_ID,							
						OUTSRC_CMP_ID,
						OUTSRC_PARTNER_ID,
						TARGET_START,
						TARGET_FINISH,
						WORK_CURRENCY_ID,
						WORK_PRIORITY_ID,
						UPDATE_DATE,
						UPDATE_PAR
					)
					VALUES
					(
						#attributes.pro_work_cat#,
						#get_last_work.work_id#,
						#attributes.company_id#,
						#attributes.partner_id#,
						#form.project_id#,
						'#form.work_head#',
						'#form.work_detail#',
						<cfif len(form.rel_work_id)>#rel_work_id#,<cfelse>NULL,</cfif>
						<cfif type eq '1'>#listgetat(form.task_,3,',')#<cfelse>NULL</cfif>,
						<cfif type eq '2' or type eq '3'>
							#listgetat(form.task_,2,',')#,
							#listgetat(form.task_,3,',')#,
						<cfelse>
							NULL,
							NULL,
						</cfif>
						#attributes.work_h_start#,
						#attributes.work_h_finish#,
						#attributes.process_stage#,
						#form.priority_cat#,
						#now()#,
						#session.pp.userid#
					)
			</cfquery>
            <cfif isdefined('get_email_address.email_address') and len(get_email_address.email_address)>
                <cfsavecontent variable="message"><cf_get_lang no='134.Adınıza Yapılmış Yeni Bir Bilgilendirme'> !</cfsavecontent>
                <cfset task_user_name = get_email_address.name>
                <cfset task_user_surname = get_email_address.surname>
                <cfset attributes.work_id = get_last_work.work_id>
                <cfmail
                    to="#get_email_address.email_address#"
                    from="#session.pp.our_name#<#session.pp.our_company_email#>"
                    subject="#message#" 
                    type="HTML">
                    <cfinclude template="add_work_mail.cfm">
                </cfmail>  
            </cfif> 
		</cftransaction>
	</cflock>
	<cf_workcube_process 
	    is_upd='1'
		old_process_line='0'
		data_source='#dsn#'
		process_stage='#attributes.process_stage#'
		record_member='#session.pp.userid#' 
		record_date='#now()#' 
		action_table='PRO_WORKS'
		action_column='WORK_ID'
		action_id='#GET_LAST_WORK.work_id#'
		action_page='#request.self#?fuseaction=objects2.updwork&work_id=#encrypt(GET_LAST_WORK.work_id,session.pp.userid,"CFMX_COMPAT","Hex")#' 
		warning_description = 'İlgili İş : #attributes.work_head#'>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
</cfif>
