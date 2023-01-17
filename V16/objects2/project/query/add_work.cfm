<cf_date tarih="attributes.WORK_H_START">
<cf_date tarih="attributes.WORK_H_FINISH">
<cfset attributes.WORK_H_START=date_add("h", START_HOUR - session.pp.TIME_ZONE, attributes.WORK_H_START)>
<cfset attributes.WORK_H_FINISH=date_add("h", FINISH_HOUR - session.pp.TIME_ZONE, attributes.WORK_H_FINISH)>
<cfif len(FORM.PROJECT_ID)>
	<cfquery name="GET_CMP" datasource="#dsn#">
		SELECT * FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.project_id#">
	</cfquery>
	<cfoutput query="get_cmp">
		<cfset cmps=get_cmp.COMPANY_ID>
		<cfset pstart=get_cmp.TARGET_START>
		<cfset pfinish=get_cmp.TARGET_FINISH>
		
		<cfif attributes.WORK_H_START LT pstart>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1498.Girdiğiniz İşin Hedef Başlangıç Tarihi Projesinin Hedef Başlangıç Tarihinden Önce Gözüküyor Lütfen Düzeltin'>!");
				window.history.go(-1);
			</script>
			<cfabort>
		<cfelseif attributes.WORK_H_FINISH GT pfinish>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1499.Girdiğiniz İşin Hedef Bitiş Tarihi Projesinin Hedef Bitiş Tarihinden Sonra Gözüküyor  Lütfen Düzeltin'>!");
				window.history.go(-1);
			</script>
			<cfabort>
		<cfelseif attributes.WORK_H_START GT attributes.WORK_H_FINISH>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1499.Girdiğiniz İşin Hedef Bitiş Tarihi Projesinin Hedef Bitiş Tarihinden Sonra Gözüküyor  Lütfen Düzeltin'>!");
				window.history.go(-1);
			</script>
			<cfabort>
		</cfif>
	</cfoutput>
</cfif>

<cflock name="#CREATEUUID()#" timeout="20">
  <cftransaction>
    <cfif isDefined("FORM.WORK_HEAD") and isDate(FORM.WORK_H_START)>
  		    <cfquery name="ADD_WORK" datasource="#dsn#">
				  INSERT INTO PRO_WORKS (
					<cfif LEN(attributes.COMPANY_ID) and len(attributes.COMPANY_PARTNER_ID)>
						COMPANY_ID, COMPANY_PARTNER_ID,
					</cfif>
						WORK_CAT_ID,
					<cfif isDefined("FORM.PROJECT_ID") and len(FORM.PROJECT_ID)>
						PROJECT_ID,
					</cfif>
					<cfif isdefined("form.estimated_time") and len(form.estimated_time)>
						ESTIMATED_TIME,
					</cfif>
					<cfif isdefined("form.expected_budget") and len(form.expected_budget)>
						EXPECTED_BUDGET,
					</cfif>
					<cfif isdefined("form.expected_budget_money") and len(form.expected_budget_money)>
						EXPECTED_BUDGET_MONEY,
					</cfif>					  
					POSITION_CODE,
					OUTSRC_CMP_ID,
					OUTSRC_PARTNER_ID,
						WORK_HEAD, WORK_DETAIL, TARGET_START, TARGET_FINISH, RECORD_PAR, WORK_CURRENCY_ID,
						WORK_PRIORITY_ID, RECORD_DATE, RECORD_IP, WORK_STATUS
					)
				  VALUES
					(
					<cfif len(attributes.company_id) and len(attributes.company_partner_id)>
						#attributes.company_id#, #attributes.company_partner_id#,
					</cfif>
						#attributes.PRO_WORK_CAT#,
						#FORM.PROJECT_ID#,
					<cfif isdefined("form.estimated_time") and len(form.estimated_time)>
						#ESTIMATED_TIME#,
					</cfif>
					<cfif isdefined("form.expected_budget") and len(form.expected_budget)>
						#replace(EXPECTED_BUDGET,",","","all")#,
					</cfif>
					<cfif isdefined("form.expected_budget_money") and len(form.expected_budget_money)>
						'#EXPECTED_BUDGET_MONEY#',
					</cfif>
					<cfif len(attributes.position_code)>
						#FORM.position_code#,
						NULL,
						NULL,
					<cfelse>
						NULL,
						#FORM.TASK_COMPANY_ID#,
						#FORM.TASK_PARTNER_ID#,
					</cfif>					
						'#FORM.WORK_HEAD#', '#FORM.WORK_DETAIL#', #attributes.WORK_H_START#, #attributes.WORK_H_FINISH#,
						#SESSION.PP.USERID#, -1, #FORM.PRIORITY_CAT#, #NOW()#, '#CGI.REMOTE_ADDR#',1
					)
				  </cfquery>
    </cfif>
    <cfquery name="GET_LAST_WORK" datasource="#dsn#">
		SELECT MAX(WORK_ID) AS WORK_ID FROM PRO_WORKS
    </cfquery>
    <cfset work_id=get_last_work.WORK_ID>
    <cfset POSITION_CODE=FORM.POSITION_CODE>
  		
	<cfif len(FORM.POSITION_CODE)>
		<cfinclude template="get_work_pos.cfm">
		<cfset task_user_id=GET_POS.EMPLOYEE_ID>
		<cfset task_user_name=GET_POS.EMPLOYEE_NAME>
		<cfset task_user_surname=GET_POS.EMPLOYEE_SURNAME>
		<cfset task_user_email=GET_POS.EMPLOYEE_EMAIL>
	<cfelseif len(FORM.TASK_PARTNER_ID)>
		<cfinclude template="get_work_partner.cfm">
		<cfset task_user_name=GET_WORK_PARTNER.COMPANY_PARTNER_NAME>
		<cfset task_user_surname=GET_WORK_PARTNER.COMPANY_PARTNER_SURNAME>
		<cfset task_user_email=GET_WORK_PARTNER.COMPANY_PARTNER_EMAIL>
	<cfelse>
		<cfset task_user_email=''>
	</cfif>
		
   			<cfquery name="ADD_WORK_HISTORY" datasource="#dsn#">
		INSERT INTO 
		  PRO_WORKS_HISTORY
		   ( 
			WORK_CAT_ID, 
			WORK_ID, 
		<cfif len(form.POSITION_CODE)>
			POSITION_CODE, 
			EMPLOYEE_ID,
			EMPLOYEE_NAME, 
			EMPLOYEE_SURNAME,
		</cfif>
		<cfif len(FORM.PROJECT_ID)>
			PROJECT_ID,
		</cfif>
		<cfif len(attributes.company_partner_id)>
			COMPANY_ID,
			COMPANY_PARTNER_ID,
		</cfif>
			TARGET_START, 
			TARGET_FINISH, 
			WORK_CURRENCY_ID, 
			WORK_PRIORITY_ID, 
		<cfif len(form.task_partner_id) and len(form.task_company_id)>
			OUTSRC_CMP_ID,
			OUTSRC_PARTNER_ID, 
		</cfif>
			UPDATE_DATE, 
			UPDATE_AUTHOR 
		) 
	 VALUES
		( 
			 #attributes.PRO_WORK_CAT#,
			 #work_id#, 
		<cfif len(form.POSITION_CODE)>
			 #FORM.POSITION_CODE#, 
			 #task_user_id#, 
			 '#task_user_name#', 
			 '#task_user_surname#',
		</cfif>
		<cfif len(FORM.PROJECT_ID)>
			#FORM.PROJECT_ID#,
		</cfif>
		<cfif len(attributes.company_partner_id)>
			#attributes.company_id#,
			#attributes.company_partner_id#,
		</cfif>
			#attributes.WORK_H_START#,
			#attributes.WORK_H_FINISH#,
			-1,
			#FORM.PRIORITY_CAT#,
		<cfif len(form.task_partner_id) and len(form.task_company_id)>
			#form.task_company_id#,
			#form.task_partner_id#,
		</cfif>
			#NOW()#,
			#SESSION.PP.USERID#
		)
    </cfquery>
  </cftransaction>
</cflock>
<cfif isDefined("get_pos.EMPLOYEE_EMAIL") and len(get_pos.EMPLOYEE_EMAIL)>
	<cfset WORK_ID=GET_LAST_WORK.WORK_ID>
	<cfmail to = "#get_pos.EMPLOYEE_EMAIL#"
		  from = "#session.pp.our_name#<#session.pp.our_company_email#>"
		  subject = "Adınıza Yapılmış Yeni Bir Görevlendirme!" type="HTML">
		<cfinclude template="add_work_mail.cfm">
	</cfmail>
</cfif>
<!---history tablosuna kayıt bitti--->
<cfif cgi.referer contains "popup">
	<script type="text/javascript">window.close();</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=project.works" addtoken="no">
</cfif>
