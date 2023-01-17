<cflock timeout="100">
<cftransaction>
	<cfset personel_detail_ = attributes.PERSONEL_ASSIGN_DETAIL>
	<cfif isDefined("attributes.x_display_page_detail") and attributes.x_display_page_detail eq 1>
		<cfquery name="upd_personel_requirement_form" datasource="#dsn#">
			UPDATE 
				PERSONEL_ASSIGN_FORM
			SET
				PERSONEL_ASSIGN_DETAIL = '#personel_detail_#',
				PER_ASSIGN_STAGE = <cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_DATE=#now()#,
				UPDATE_IP='#CGI.REMOTE_ADDR#'
			WHERE
				PERSONEL_ASSIGN_ID = #attributes.per_assign_id#
		</cfquery>
	<cfelse>
		<cfif len(attributes.birth_date)><cf_date tarih="attributes.birth_date"></cfif>
		<cfif len(attributes.work_start)><cf_date tarih="attributes.work_start"></cfif>
		<cfif len(attributes.work_finish)><cf_date tarih="attributes.work_finish"></cfif>
		<cfif len(attributes.old_work_start)><cf_date tarih="attributes.old_work_start"></cfif>
		<cfif len(attributes.old_work_finish)><cf_date tarih="attributes.old_work_finish"></cfif>
		<cfquery name="add_personel_requirement_form" datasource="#dsn#">
			UPDATE
				PERSONEL_ASSIGN_FORM
			SET
				PERSONEL_REQ_ID = <cfif len(attributes.PERSONEL_REQ_ID)>#attributes.PERSONEL_REQ_ID#<cfelse>NULL</cfif>,
				PERSONEL_ASSIGN_HEAD = '#attributes.PERSONEL_ASSIGN_HEAD#',
				PERSONEL_ASSIGN_DETAIL = '#personel_detail_#',
				PERSONEL_NAME = '#attributes.PERSONEL_NAME#',
				PERSONEL_SURNAME = '#attributes.PERSONEL_SURNAME#', 
				PERSONEL_TC_IDENTY_NO = '#attributes.PERSONEL_TC_IDENTY_NO#',
				BIRTH_DATE = <cfif len(attributes.birth_date)>#attributes.birth_date#<cfelse>NULL</cfif>,
				SEX = #attributes.sex#,
				MILITARY_STATUS = #attributes.MILITARY_STATUS#,
				MILITARY_DETAIL = '#attributes.MILITARY_DETAIL#',
				TRAINING_LEVEL = #attributes.TRAINING_LEVEL#,
				PERSONEL_ATTEMPT = '#attributes.PERSONEL_ATTEMPT#',
				LICENCECAT_ID = <cfif isdefined("attributes.driver_licence_type") and len(attributes.driver_licence_type)>'#attributes.driver_licence_type#'<cfelse>NULL</cfif>,
				IS_PSYCHOTECHNICS = <cfif isdefined("attributes.is_psychotechnics")>#attributes.is_psychotechnics#<cfelse>0</cfif>,
				RELATIVE_STATUS = #attributes.RELATIVE_STATUS#,
				RELATIVE_DETAIL = '#attributes.RELATIVE_DETAIL#',
				WORK_START = <cfif len(attributes.work_start)>#attributes.work_start#<cfelse>NULL</cfif>,
				WORK_FINISH = <cfif len(attributes.work_finish)>#attributes.work_finish#<cfelse>NULL</cfif>,
				OUR_COMPANY_ID = <cfif len(attributes.OUR_COMPANY_ID)>#attributes.OUR_COMPANY_ID#<cfelse>NULL</cfif>,
				DEPARTMENT_ID = <cfif len(attributes.DEPARTMENT_ID)>#attributes.DEPARTMENT_ID#<cfelse>NULL</cfif>,
				BRANCH_ID = <cfif len(attributes.BRANCH_ID)>#attributes.BRANCH_ID#<cfelse>NULL</cfif>,
				OLD_OUR_COMPANY_ID = <cfif len(attributes.OLD_OUR_COMPANY_ID)>#attributes.OLD_OUR_COMPANY_ID#<cfelse>NULL</cfif>,
				OLD_DEPARTMENT_ID = <cfif len(attributes.OLD_DEPARTMENT_ID)>#attributes.OLD_DEPARTMENT_ID#<cfelse>NULL</cfif>,
				OLD_BRANCH_ID = <cfif len(attributes.OLD_BRANCH_ID)>#attributes.OLD_BRANCH_ID#<cfelse>NULL</cfif>,
				POSITION_CAT_ID = <cfif len(attributes.POSITION_CAT_ID)>#attributes.POSITION_CAT_ID#<cfelse>NULL</cfif>,
				OLD_POSITION_ID = <cfif len(attributes.OLD_POSITION_ID)>#attributes.OLD_POSITION_ID#<cfelse>NULL</cfif>,
				OLD_POSITION_NAME = '#attributes.OLD_POSITION_NAME#',
				OLD_WORK_START = <cfif len(attributes.OLD_WORK_START)>#attributes.OLD_WORK_START#<cfelse>NULL</cfif>,
				OLD_WORK_FINISH = <cfif len(attributes.OLD_WORK_FINISH)>#attributes.OLD_WORK_FINISH#<cfelse>NULL</cfif>,
				OLD_FINISH_DETAIL = '#attributes.OLD_FINISH_DETAIL#',
				ASSIGN_PROPERTIES = <cfif isdefined("attributes.ASSIGN_PROPERTIES") and len(attributes.ASSIGN_PROPERTIES)>'#attributes.ASSIGN_PROPERTIES#'<cfelse>NULL</cfif>,
				SALARY = <cfif len(attributes.SALARY)>#attributes.SALARY#<cfelse>NULL</cfif>,
				SALARY_MONEY = '#attributes.SALARY_MONEY#',
				OLD_SALARY = <cfif len(attributes.OLD_SALARY)>#attributes.OLD_SALARY#<cfelse>NULL</cfif>,
				OLD_SALARY_MONEY = '#attributes.OLD_SALARY_MONEY#',
				RELATED_CV_BANK_ID = <cfif isDefined("attributes.related_cv_bank_id") and Len(attributes.related_cv_bank_id)>#attributes.related_cv_bank_id#<cfelse>NULL</cfif>,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.REMOTE_ADDR#',
				PER_ASSIGN_STAGE = #attributes.process_stage#
			WHERE
				PERSONEL_ASSIGN_ID = #attributes.PER_ASSIGN_ID#
		</cfquery>
	</cfif>
	
	<cfif Len(personel_detail_)>
		<cfif Len(personel_detail_) gt 75>
			<cfset pers_det_ = Left(personel_detail_,72) & "...">
		<cfelse>
			<cfset pers_det_ = personel_detail_>
		</cfif>
		<!--- Notlara Ekleniyor --->
		<cfquery name="Add_Notes" datasource="#dsn#">
			INSERT INTO 
				NOTES
			(
				ACTION_SECTION,
				ACTION_ID,
				NOTE_HEAD,
				NOTE_BODY,
				IS_SPECIAL,
				IS_WARNING,
				COMPANY_ID,
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			)
			VALUES
			(
				'PER_ASSIGN_ID',
				 #attributes.PER_ASSIGN_ID#,
				'#pers_det_#',
				'#personel_detail_#',
				 0,
				 0,
				 #session.ep.company_id#,
				 #session.ep.userid#,
				 #now()#,
				'#cgi.remote_addr#'
			)
		</cfquery>
	</cfif>
	<!--- Surec taginin transaction icinde kalmasi onemle rica olunur, filelarda kullaniliyor FBS 20010606 --->
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#'
		action_table='PERSONEL_ASSIGN_FORM'
		action_column='PERSONEL_ASSIGN_ID'
		action_id='#attributes.PER_ASSIGN_ID#'
		action_page='#request.self#?fuseaction=hr.list_personel_assign_form&event=upd&per_assign_id=#attributes.PER_ASSIGN_ID#'
		warning_description = 'Personel Atama Formu : #attributes.personel_assign_head#'>
</cftransaction>
</cflock>
<cfset attributes.actionId=attributes.PER_ASSIGN_ID>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_personel_assign_form&event=upd&per_assign_id=#attributes.PER_ASSIGN_ID#</cfoutput>";
</script>
