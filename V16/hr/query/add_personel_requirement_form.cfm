<cfif len(attributes.startdate)><cf_date tarih="attributes.startdate"><cfelse><cfset attributes.startdate = "null"></cfif>
<cfif isDefined("attributes.OLD_PERSONEL_FINISHDATE") and len(attributes.OLD_PERSONEL_FINISHDATE)><cf_date tarih="attributes.OLD_PERSONEL_FINISHDATE"></cfif>
<cfif isDefined("attributes.CHANGE_PERSONEL_FINISHDATE") and len(attributes.CHANGE_PERSONEL_FINISHDATE)><cf_date tarih="attributes.CHANGE_PERSONEL_FINISHDATE"></cfif>
<cfif isDefined("attributes.transfer_personel_startdate") and len(attributes.transfer_personel_startdate)><cf_date tarih="attributes.transfer_personel_startdate"></cfif>
<cfif isDefined("attributes.requirement_date") and len(attributes.requirement_date)><cf_date tarih="attributes.requirement_date"></cfif>
<cfif isDefined("attributes.work_start") and len(attributes.work_start)><cf_date tarih="attributes.work_start"></cfif>
<cfif isDefined("attributes.work_finish") and len(attributes.work_finish)><cf_date tarih="attributes.work_finish"></cfif>
	<cfset language_id_list = ''>
	<cfset knowlevel_id_list = ''>
	<cfloop from="1" to="#attributes.record_num#" index="m">
		<cfset language_id_list=listappend(language_id_list,'#evaluate('attributes.language_id#m#')#')>
		<cfset knowlevel_id_list=listappend(knowlevel_id_list,'#evaluate('attributes.knowlevel_id#m#')#')>
	</cfloop>
<cflock timeout="100">
<cftransaction>
	<cfquery name="add_personel_requirement_form" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			PERSONEL_REQUIREMENT_FORM
		(
			PERSONEL_REQUIREMENT_HEAD,
			OUR_COMPANY_ID,
			DEPARTMENT_ID,
			BRANCH_ID,
			POSITION_CAT_ID,
			POSITION_ID,
			PERSONEL_EMPLOYEE_ID,
			DEMAND_POSITION_ID,
			FORM_TYPE,
			PERSONEL_COUNT,
			PERSONEL_DETAIL,
			REQUIREMENT_REASON,
			MIN_SALARY,
			MIN_SALARY_MONEY,
			MAX_SALARY,
			MAX_SALARY_MONEY,
			PERSONEL_START_DATE,
			REQUIREMENT_EMP,
			REQUIREMENT_EMP_POS_CODE,
			REQUIREMENT_PAR_ID,
			REQUIREMENT_CONS_ID,
			TRAINING_LEVEL,
			PERSONEL_EXP,
			PERSONAL_AGE_MIN,
			PERSONAL_AGE_MAX,
			PERSONEL_ABILITY,
			PERSONEL_PROPERTIES,
			PERSONEL_LANG,
			PERSONEL_OTHER,
			PER_REQ_STAGE,
			VEHICLE_REQ,
			VEHICLE_REQ_MODEL,
			LICENCECAT_ID,
			SEX,
			LANGUAGE,
			LANGUAGE_ID,
			KNOWLEVEL_ID,
			OLD_PERSONEL_NAME,
			OLD_PERSONEL_DETAIL,
			OLD_PERSONEL_POSITION,
			OLD_PERSONEL_FINISHDATE,
			CHANGE_POSITION_ID,
			CHANGE_PERSONEL_POSITION_NEW_ID,
			CHANGE_PERSONEL_NAME,
			CHANGE_PERSONEL_POSITION,
			CHANGE_PERSONEL_POSITION_NEW,
			CHANGE_PERSONEL_FINISHDATE,
			TRANSFER_PERSONEL_NAME,
			TRANSFER_PERSONEL_POSITION,
			TRANSFER_PERSONEL_BRANCH_NEW,
			TRANSFER_PERSONEL_POSITION_NEW,
			TRANSFER_PERSONEL_STARTDATE,
			TRANSFER_POSITION_ID,
			TRANSFER_PERSONEL_POSITION_NEW_ID,
			TRANSFER_PERSONEL_BRANCH_NEW_ID,
			REQUIREMENT_DATE,
			WORK_START,
			WORK_FINISH,
			RELATED_FORMS,
			IS_ORGANIZATION_CHANGE,
			IS_VOLUME_OF_BUSINESS,
			VOLUME_BUSINESS_MIN,
			VOLUME_BUSINESS_MAX,
			IS_NEW_PROJECT,
			IS_NUMBER_OF_TRANSACTIONS,
			TRANSACTION_NUMBER_MIN,
			TRANSACTION_NUMBER_MAX,
			ADDITIONAL_STAFF_DETAIL,
			IS_STAFF,
			IS_OUTSOURCE,
			IS_FULLTIME,
			IS_HALFTIME,
			IS_SHIFT,
			IS_FOREIGN_LANG_EXAM,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
		VALUES
		(
			'#attributes.req_head#',
			<cfif len(attributes.our_company) and len(attributes.our_company_id)>
				#attributes.our_company_id#,
				#attributes.department_id#,
				#attributes.branch_id#,
			<cfelse>
				NULL,
				NULL,
				NULL,
			</cfif>
			<cfif len(attributes.position_cat) and len(attributes.position_cat_id)>
				#attributes.position_cat_id#,
			<cfelse>
				NULL,
			</cfif>
			<cfif len(attributes.position_id)>
				#attributes.position_id#,
			<cfelse>
				NULL,
			</cfif>
			<cfif len(attributes.personel_employee_id)>
				#attributes.personel_employee_id#,
			<cfelse>
				NULL,
			</cfif>
			<cfif len(attributes.demand_position_id)>
				#attributes.demand_position_id#,
			<cfelse>
				NULL,
			</cfif>
			#attributes.form_type#,
			<cfif len(attributes.personel_count)>#attributes.personel_count#<cfelse>NULL</cfif>,
			'#attributes.personel_detail#',
			'#attributes.requirement_reason#',
			<cfif len(attributes.min_salary)>#attributes.min_salary#<cfelse>NULL</cfif>,
			<cfif len(attributes.min_salary_money)>'#attributes.min_salary_money#'<cfelse>NULL</cfif>,
			<cfif len(attributes.max_salary)>#attributes.max_salary#<cfelse>NULL</cfif>,
			<cfif len(attributes.max_salary_money)>'#attributes.max_salary_money#'<cfelse>NULL</cfif>,
			<cfif len(attributes.startdate)>#attributes.startdate#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.requirement_member_id') and len(attributes.requirement_member_id) and attributes.requirement_member_type eq 'employee'>
				#attributes.requirement_member_id#,
				#attributes.requirement_pos_code#,
				NULL,
				NULL,
			<cfelseif isdefined('attributes.requirement_partner_id') and len(attributes.requirement_partner_id) and attributes.requirement_member_type eq 'partner'>
				NULL,
				NULL,
				#attributes.requirement_partner_id#,
				NULL,
			<cfelseif isdefined('attributes.requirement_consumer_id') and len(attributes.requirement_consumer_id) and attributes.requirement_member_type eq 'consumer'>
				NULL,
				NULL,
				NULL,
				#attributes.requirement_consumer_id#,
			<cfelse>
				NULL,
				NULL,
				NULL,
				NULL,
			</cfif>
			<cfif isdefined('attributes.training_level') and len(attributes.training_level)>#attributes.training_level#<cfelse>NULL</cfif>,
				'#attributes.personel_exp#',
				<cfif len(attributes.personal_age_min)>#attributes.personal_age_min#<cfelse>NULL</cfif>,
				<cfif len(attributes.personal_age_max)>#attributes.personal_age_max#<cfelse>NULL</cfif>,
				'#attributes.personel_ability#',
				'#attributes.personel_properties#',
				<cfif isDefined("attributes.personel_lang")>'#attributes.personel_lang#'<cfelse>NULL</cfif>,
				'#attributes.personel_other#',
				<cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>,
				#attributes.VEHICLE_REQ#,
				'#attributes.VEHICLE_REQ_MODEL#',
				<cfif isdefined("attributes.driver_licence_type")>'#attributes.driver_licence_type#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.sex") and Len(attributes.sex)>'#attributes.sex#'<cfelse>NULL</cfif>,
				<cfif isDefined("attributes.language") and attributes.language eq 1>
					1,
					'#language_id_list#',
					'#knowlevel_id_list#',
				<cfelse>
					0,
					NULL,
					NULL,
				</cfif>
				'#attributes.OLD_PERSONEL_NAME#',
				'#attributes.OLD_PERSONEL_DETAIL#',
				'#attributes.OLD_PERSONEL_POSITION#',
				<cfif len(attributes.OLD_PERSONEL_FINISHDATE)>#attributes.OLD_PERSONEL_FINISHDATE#<cfelse>NULL</cfif>,
				<cfif len(attributes.CHANGE_POSITION_ID)>#attributes.CHANGE_POSITION_ID#<cfelse>NULL</cfif>,
				<cfif len(attributes.CHANGE_PERSONEL_POSITION_NEW_ID)>#attributes.CHANGE_PERSONEL_POSITION_NEW_ID#<cfelse>NULL</cfif>,
				'#attributes.CHANGE_PERSONEL_NAME#',
				'#attributes.CHANGE_PERSONEL_POSITION#',
				'#attributes.CHANGE_PERSONEL_POSITION_NEW#',
				<cfif len(attributes.CHANGE_PERSONEL_FINISHDATE)>#attributes.CHANGE_PERSONEL_FINISHDATE#<cfelse>NULL</cfif>,
				'#attributes.TRANSFER_PERSONEL_NAME#',
				'#attributes.TRANSFER_PERSONEL_POSITION#',
				'#attributes.TRANSFER_PERSONEL_BRANCH_NEW#',
				'#attributes.TRANSFER_PERSONEL_POSITION_NEW#',
				<cfif len(attributes.TRANSFER_PERSONEL_STARTDATE)>#attributes.TRANSFER_PERSONEL_STARTDATE#<cfelse>NULL</cfif>,
				<cfif len(attributes.TRANSFER_POSITION_ID)>#attributes.TRANSFER_POSITION_ID#<cfelse>NULL</cfif>,
				<cfif len(attributes.TRANSFER_PERSONEL_BRANCH_NEW_ID)>#attributes.TRANSFER_PERSONEL_BRANCH_NEW_ID#<cfelse>NULL</cfif>,
				<cfif len(attributes.TRANSFER_PERSONEL_POSITION_NEW_ID)>#attributes.TRANSFER_PERSONEL_POSITION_NEW_ID#<cfelse>NULL</cfif>,
				<cfif len(attributes.REQUIREMENT_DATE)>#attributes.REQUIREMENT_DATE#<cfelse>NULL</cfif>,
				<cfif len(attributes.work_start)>#attributes.work_start#<cfelse>NULL</cfif>,
				<cfif len(attributes.work_finish)>#attributes.work_finish#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.RELATED_FORMS") and len(attributes.RELATED_FORMS)>'#attributes.RELATED_FORMS#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_organization_change') and len(attributes.is_organization_change)>#attributes.is_organization_change#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_volume_of_business') and len(attributes.is_volume_of_business)>#attributes.is_volume_of_business#<cfelse>NULL</cfif>,
				<cfif len(attributes.volume_business_min)>#attributes.volume_business_min#<cfelse>NULL</cfif>,
				<cfif len(attributes.volume_business_max)>#attributes.volume_business_max#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_new_project') and len(attributes.is_new_project)>#attributes.is_new_project#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_number_of_transactions') and len(attributes.is_number_of_transactions)>#attributes.is_number_of_transactions#<cfelse>NULL</cfif>,
				<cfif len(attributes.transaction_number_min)>#attributes.transaction_number_min#<cfelse>NULL</cfif>,
				<cfif len(attributes.transaction_number_max)>#attributes.transaction_number_max#<cfelse>NULL</cfif>,
				<cfif len(attributes.additional_staff_detail)>'#attributes.additional_staff_detail#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_staff') and len(attributes.is_staff)>#attributes.is_staff#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_outsource') and len(attributes.is_outsource)>#attributes.is_outsource#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_fulltime') and len(attributes.is_fulltime)>#attributes.is_fulltime#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_halftime') and len(attributes.is_halftime)>#attributes.is_halftime#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_shift') and len(attributes.is_shift)>#attributes.is_shift#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.is_foreign_lang_exam') and len(attributes.is_foreign_lang_exam)>#attributes.is_foreign_lang_exam#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				'#CGI.REMOTE_ADDR#'
		)
	</cfquery>
	<cfif len(attributes.branch_id)>
		<cfquery name="get_olds" datasource="#dsn#" maxrows="1">
			SELECT REQ_NUMBER FROM PERSONEL_REQUIREMENT_FORM WHERE BRANCH_ID = #attributes.branch_id# AND PERSONEL_REQUIREMENT_ID <> #MAX_ID.IDENTITYCOL# AND REQ_NUMBER IS NOT NULL ORDER BY REQ_NUMBER DESC
		</cfquery>
		<cfif get_olds.recordcount>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE
					PERSONEL_REQUIREMENT_FORM
				SET
					REQ_NUMBER = #get_olds.REQ_NUMBER + 1#
				WHERE
					PERSONEL_REQUIREMENT_ID = #MAX_ID.IDENTITYCOL#
			</cfquery>
		</cfif>
	</cfif>
	<cfif Len(attributes.personel_other)>
		<cfif Len(attributes.personel_other) gt 75>
			<cfset pers_det_ = Left(attributes.personel_other,72) & "...">
		<cfelse>
			<cfset pers_det_ = attributes.personel_other>
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
				'PER_REQ_ID',
				 #MAX_ID.IDENTITYCOL#,
				'#pers_det_#',
				'#attributes.personel_other#',
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
    <cfif attributes.circuitDet is 'myhome'>
    	<cfset per_req_id_ = contentEncryptingandDecodingAES(isEncode:1,content:MAX_ID.IDENTITYCOL,accountKey:'wrk')>
  	<cfelse>
      	<cfset per_req_id_ = MAX_ID.IDENTITYCOL>
 	</cfif>
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#'
		action_table='PERSONEL_REQUIREMENT_FORM'
		action_column='PERSONEL_REQUIREMENT_ID'
		action_id='#MAX_ID.IDENTITYCOL#'
		action_page='#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form&event=upd&per_req_id=#per_req_id_#'
		warning_description = 'Personel Talep Formu : #attributes.req_head#'>
</cftransaction>
</cflock>
<cfset attributes.actionId = per_req_id_>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.list_personel_requirement_form&event=upd&per_req_id=#per_req_id_#</cfoutput>";
</script>