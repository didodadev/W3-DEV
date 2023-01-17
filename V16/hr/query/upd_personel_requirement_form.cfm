<cflock timeout="100">
<cftransaction>
	<cfif ListFirst(attributes.fuseaction,'.') is 'myhome'>
		<cfset attributes.per_req_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.per_req_id,accountKey:'wrk')>
	</cfif>
	<cfset personel_other_ = attributes.personel_other>
	<cfif isDefined("attributes.x_display_page_detail") and attributes.x_display_page_detail eq 1>
		<cfquery name="upd_personel_requirement_form" datasource="#dsn#">
			UPDATE 
				PERSONEL_REQUIREMENT_FORM
			SET
				PERSONEL_OTHER='#personel_other_#',
				PER_REQ_STAGE=<cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_DATE=#now()#,
				UPDATE_IP='#CGI.REMOTE_ADDR#'
			WHERE
				PERSONEL_REQUIREMENT_ID = #attributes.per_req_id#
		</cfquery>
	<cfelse>
		<cfif isDefined("attributes.startdate") and Len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
		<cfif isDefined("attributes.old_personel_finishdate") and Len(attributes.old_personel_finishdate)><cf_date tarih="attributes.old_personel_finishdate"></cfif>
		<cfif isDefined("attributes.requirement_date") and Len(attributes.requirement_date)><cf_date tarih="attributes.requirement_date"></cfif>
		<cfif isDefined("attributes.change_personel_finishdate") and Len(attributes.change_personel_finishdate)><cf_date tarih="attributes.change_personel_finishdate"></cfif>
		<cfif isDefined("attributes.transfer_personel_startdate") and Len(attributes.transfer_personel_startdate)><cf_date tarih="attributes.transfer_personel_startdate"></cfif>
		<cfif isDefined("attributes.work_start") and Len(attributes.work_start)><cf_date tarih="attributes.work_start"></cfif>
		<cfif isDefined("attributes.work_finish") and Len(attributes.work_finish)><cf_date tarih="attributes.work_finish"></cfif>
	
		<cfquery name="add_personel_requirement_form" datasource="#dsn#">
			UPDATE 
				PERSONEL_REQUIREMENT_FORM
			SET
				PERSONEL_REQUIREMENT_HEAD = <cfif isDefined("attributes.req_head") and Len(attributes.req_head)>'#attributes.req_head#'<cfelse>NULL</cfif>,
				OUR_COMPANY_ID = <cfif isDefined("attributes.our_company_id") and Len(attributes.our_company_id)>#attributes.our_company_id#<cfelse>NULL</cfif>,
				BRANCH_ID = <cfif isDefined("attributes.branch_id") and Len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
				DEPARTMENT_ID = <cfif isDefined("attributes.department_id") and Len(attributes.department_id)>#attributes.department_id#<cfelse>NULL</cfif>,
				
				POSITION_CAT_ID = <cfif isDefined("attributes.position_cat") and Len(attributes.position_cat) and isDefined("attributes.position_cat_id") and Len(attributes.position_cat_id)>#attributes.position_cat_id#<cfelse>NULL</cfif>,
				POSITION_ID=<cfif isDefined("attributes.position_id") and Len(attributes.position_id)>#attributes.position_id#<cfelse>NULL</cfif>,
				PERSONEL_EMPLOYEE_ID = <cfif isDefined("attributes.personel_employee_id") and Len(attributes.personel_employee_id)>#attributes.personel_employee_id#<cfelse>NULL</cfif>,
				DEMAND_POSITION_ID=<cfif isDefined("attributes.demand_position_id") and Len(attributes.demand_position_id)>#attributes.demand_position_id#<cfelse>NULL</cfif>,
				FORM_TYPE = <cfif isDefined("attributes.form_type") and Len(attributes.form_type)>#attributes.form_type#<cfelse>NULL</cfif>,
				PERSONEL_COUNT = <cfif isDefined("attributes.personel_count") and Len(attributes.personel_count)>#attributes.personel_count#<cfelse>NULL</cfif>,
				PERSONEL_DETAIL = <cfif isDefined("attributes.personel_detail") and Len(attributes.personel_detail)>'#attributes.personel_detail#'<cfelse>NULL</cfif>,
				REQUIREMENT_REASON = <cfif isDefined("attributes.requirement_reason") and Len(attributes.requirement_reason)>'#attributes.requirement_reason#'<cfelse>NULL</cfif>,
				MIN_SALARY = <cfif isDefined("attributes.min_salary") and Len(attributes.min_salary)>#attributes.min_salary#<cfelse>NULL</cfif>,
				MIN_SALARY_MONEY = <cfif isDefined("attributes.min_salary_money") and len(attributes.min_salary_money)>'#attributes.min_salary_money#'<cfelse>NULL</cfif>,
				MAX_SALARY = <cfif len(attributes.max_salary)>#attributes.max_salary#<cfelse>NULL</cfif>,
				MAX_SALARY_MONEY=<cfif isDefined("attributes.max_salary_money") and len(attributes.max_salary_money)>'#attributes.max_salary_money#'<cfelse>NULL</cfif>,
				PERSONEL_START_DATE= <cfif isDefined("attributes.startdate") and Len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.requirement_member_id') and len(attributes.requirement_member_id)>
					REQUIREMENT_EMP = #attributes.requirement_member_id#,
					REQUIREMENT_EMP_POS_CODE = #attributes.requirement_pos_code#,
					REQUIREMENT_PAR_ID = NULL,
					REQUIREMENT_CONS_ID = NULL,
				<cfelseif isdefined('attributes.requirement_partner_id') and len(attributes.requirement_partner_id)>
					REQUIREMENT_EMP = NULL,
					REQUIREMENT_EMP_POS_CODE = NULL,
					REQUIREMENT_PAR_ID = #attributes.requirement_partner_id#,
					REQUIREMENT_CONS_ID=NULL,
				<cfelseif isdefined('attributes.requirement_consumer_id') and len(attributes.requirement_consumer_id)>
					REQUIREMENT_EMP=NULL,
					REQUIREMENT_EMP_POS_CODE = NULL,
					REQUIREMENT_PAR_ID=NULL,
					REQUIREMENT_CONS_ID=#attributes.requirement_consumer_id#,
				</cfif>
				TRAINING_LEVEL=<cfif isdefined('attributes.training_level') and len(attributes.training_level)>#attributes.training_level#<cfelse>NULL</cfif>,
				PERSONEL_EXP='#attributes.personel_exp#',
				<!---PERSONEL_AGE='#attributes.personel_age#',--->
				PERSONAL_AGE_MIN = <cfif len(attributes.personal_age_min)>#attributes.personal_age_min#<cfelse>NULL</cfif>,
				PERSONAL_AGE_MAX = <cfif len(attributes.personal_age_max)>#attributes.personal_age_max#<cfelse>NULL</cfif>,
				PERSONEL_ABILITY='#attributes.personel_ability#',
				PERSONEL_PROPERTIES='#attributes.personel_properties#',
				PERSONEL_LANG=<cfif isDefined("attributes.personel_lang")>'#attributes.personel_lang#'<cfelse>NULL</cfif>,
				PERSONEL_OTHER='#personel_other_#',
				PER_REQ_STAGE=<cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
				VEHICLE_REQ = <cfif isDefined("attributes.vehicle_req") and len(attributes.vehicle_req)>#attributes.vehicle_req#<cfelse>NULL</cfif>,
				VEHICLE_REQ_MODEL = '#attributes.VEHICLE_REQ_MODEL#',
				LICENCECAT_ID = <cfif isdefined("attributes.driver_licence_type")>'#attributes.driver_licence_type#'<cfelse>NULL</cfif>,
				SEX = <cfif isDefined("attributes.sex") and Len(attributes.sex)>'#attributes.sex#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.language") and attributes.language eq 1 and isDefined("attributes.language_id") and attributes.language_id neq 0 and attributes.knowlevel_id neq 0 and isDefined("attributes.knowlevel_id")>
					LANGUAGE = 1,
					LANGUAGE_ID = '#attributes.language_id#',
					KNOWLEVEL_ID = '#attributes.knowlevel_id#',
				<cfelse>
					LANGUAGE = 0,
					LANGUAGE_ID = NULL,
					KNOWLEVEL_ID = NULL,
				</cfif>
				OLD_PERSONEL_NAME = '#attributes.OLD_PERSONEL_NAME#',
				OLD_PERSONEL_DETAIL = '#attributes.OLD_PERSONEL_DETAIL#',
				OLD_PERSONEL_POSITION = '#attributes.OLD_PERSONEL_POSITION#',
				OLD_PERSONEL_FINISHDATE = <cfif len(attributes.OLD_PERSONEL_FINISHDATE)>#attributes.OLD_PERSONEL_FINISHDATE#<cfelse>NULL</cfif>,
				CHANGE_PERSONEL_NAME = '#attributes.CHANGE_PERSONEL_NAME#',
				CHANGE_PERSONEL_POSITION = '#attributes.CHANGE_PERSONEL_POSITION#',
				CHANGE_PERSONEL_POSITION_NEW = '#attributes.CHANGE_PERSONEL_POSITION_NEW#',
				CHANGE_PERSONEL_FINISHDATE = <cfif len(attributes.CHANGE_PERSONEL_FINISHDATE)>#attributes.CHANGE_PERSONEL_FINISHDATE#<cfelse>NULL</cfif>,
				CHANGE_POSITION_ID = <cfif len(attributes.CHANGE_POSITION_ID)>#attributes.CHANGE_POSITION_ID#<cfelse>NULL</cfif>,
				CHANGE_PERSONEL_POSITION_NEW_ID = <cfif len(attributes.CHANGE_PERSONEL_POSITION_NEW_ID)>#attributes.CHANGE_PERSONEL_POSITION_NEW_ID#<cfelse>NULL</cfif>,
				TRANSFER_PERSONEL_NAME = '#attributes.TRANSFER_PERSONEL_NAME#',
				TRANSFER_PERSONEL_POSITION = '#attributes.TRANSFER_PERSONEL_POSITION#',
				TRANSFER_PERSONEL_BRANCH_NEW = '#attributes.TRANSFER_PERSONEL_BRANCH_NEW#',
				TRANSFER_PERSONEL_POSITION_NEW = '#attributes.TRANSFER_PERSONEL_POSITION_NEW#',
				TRANSFER_PERSONEL_STARTDATE = <cfif len(attributes.TRANSFER_PERSONEL_STARTDATE)>#attributes.TRANSFER_PERSONEL_STARTDATE#<cfelse>NULL</cfif>,
				TRANSFER_POSITION_ID = <cfif len(attributes.TRANSFER_POSITION_ID)>#attributes.TRANSFER_POSITION_ID#<cfelse>NULL</cfif>,
				TRANSFER_PERSONEL_POSITION_NEW_ID = <cfif len(attributes.TRANSFER_PERSONEL_POSITION_NEW_ID)>#attributes.TRANSFER_PERSONEL_POSITION_NEW_ID#<cfelse>NULL</cfif>,
				TRANSFER_PERSONEL_BRANCH_NEW_ID = <cfif len(attributes.TRANSFER_PERSONEL_BRANCH_NEW_ID)>#attributes.TRANSFER_PERSONEL_BRANCH_NEW_ID#<cfelse>NULL</cfif>,
				REQUIREMENT_DATE = <cfif len(attributes.REQUIREMENT_DATE)>#attributes.REQUIREMENT_DATE#<cfelse>NULL</cfif>,
				WORK_START = <cfif len(attributes.WORK_START)>#attributes.WORK_START#<cfelse>NULL</cfif>,
				WORK_FINISH = <cfif len(attributes.WORK_FINISH)>#attributes.WORK_FINISH#<cfelse>NULL</cfif>,
				RELATED_FORMS = <cfif isdefined("attributes.RELATED_FORMS") and len(attributes.RELATED_FORMS)>'#attributes.RELATED_FORMS#'<cfelse>NULL</cfif>,
				IS_ORGANIZATION_CHANGE = <cfif isdefined('attributes.is_organization_change') and len(attributes.is_organization_change)>#attributes.is_organization_change#<cfelse>NULL</cfif>,
				IS_VOLUME_OF_BUSINESS = <cfif isdefined('attributes.is_volume_of_business') and len(attributes.is_volume_of_business)>#attributes.is_volume_of_business#<cfelse>NULL</cfif>, 
				VOLUME_BUSINESS_MIN = <cfif len(attributes.volume_business_min)>#attributes.volume_business_min#<cfelse>NULL</cfif>,
				VOLUME_BUSINESS_MAX = <cfif len(attributes.volume_business_max)>#attributes.volume_business_max#<cfelse>NULL</cfif>,
				IS_NEW_PROJECT = <cfif isdefined('attributes.is_new_project') and len(attributes.is_new_project)>#attributes.is_new_project#<cfelse>NULL</cfif>,
				IS_NUMBER_OF_TRANSACTIONS = <cfif isdefined('attributes.is_number_of_transactions')>#attributes.is_number_of_transactions#<cfelse>NULL</cfif>,
				TRANSACTION_NUMBER_MIN = <cfif len(attributes.transaction_number_min)>#attributes.transaction_number_min#<cfelse>NULL</cfif>,
				TRANSACTION_NUMBER_MAX = <cfif len(attributes.transaction_number_max)>#attributes.transaction_number_max#<cfelse>NULL</cfif>,
				ADDITIONAL_STAFF_DETAIL = <cfif len(attributes.additional_staff_detail)>'#attributes.additional_staff_detail#'<cfelse>NULL</cfif>,
				IS_STAFF = <cfif isdefined('attributes.is_staff') and len(attributes.is_staff)>#attributes.is_staff#<cfelse>NULL</cfif>,
				IS_OUTSOURCE = <cfif isdefined('attributes.is_outsource') and len(attributes.is_outsource)>#attributes.is_outsource#<cfelse>NULL</cfif>,
				IS_FULLTIME = <cfif isdefined('attributes.is_fulltime') and len(attributes.is_fulltime)>#attributes.is_fulltime#<cfelse>NULL</cfif>,
				IS_HALFTIME = <cfif isdefined('attributes.is_halftime') and len(attributes.is_halftime)>#attributes.is_halftime#<cfelse>NULL</cfif>,
				IS_SHIFT = <cfif isdefined('attributes.is_shift') and len(attributes.is_shift)>#attributes.is_shift#<cfelse>NULL</cfif>,
				IS_FOREIGN_LANG_EXAM = <cfif isdefined('attributes.is_foreign_lang_exam') and len(attributes.is_foreign_lang_exam)>#attributes.is_foreign_lang_exam#<cfelse>NULL</cfif>,
				UPDATE_EMP=#session.ep.userid#,
				UPDATE_DATE=#now()#,
				UPDATE_IP='#CGI.REMOTE_ADDR#'
			WHERE
				PERSONEL_REQUIREMENT_ID = #attributes.per_req_id#
		</cfquery>
	</cfif>
	
	<cfif Len(personel_other_)>
		<cfif Len(personel_other_) gt 75>
			<cfset pers_det_ = Left(personel_other_,72) & "...">
		<cfelse>
			<cfset pers_det_ = personel_other_>
		</cfif>
		<!--- Notları Güncelliyor --->
		<cfquery name="upd_Notes" datasource="#dsn#">
			UPDATE
				NOTES
			SET 
				NOTE_HEAD = '#pers_det_#',
				NOTE_BODY = '#personel_other_#',
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE =  #now()#,
				UPDATE_IP = '#cgi.remote_addr#'
			WHERE 
			 ACTION_ID = #attributes.per_req_id#
		</cfquery>
	</cfif>
	<!--- Surec taginin transaction icinde kalmasi onemle rica olunur, filelarda kullaniliyor FBS 20010606 --->
    <cfif ListFirst(attributes.fuseaction,'.') is 'myhome'>
    	<cfset per_req_id_ = contentEncryptingandDecodingAES(isEncode:1,content:attributes.per_req_id,accountKey:'wrk')>
  	<cfelse>
   		<cfset per_req_id_ = attributes.per_req_id>
	 </cfif>
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_page='#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form&event=upd&per_req_id=#per_req_id_#'
		action_id='#attributes.per_req_id#'
		warning_description = 'Personel Talep Formu : #attributes.req_head#'>
</cftransaction>
</cflock>	
<cfset attributes.actionId = per_req_id_>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form&event=upd&per_req_id=#per_req_id_#</cfoutput>";
</script>
