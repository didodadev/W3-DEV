<cfif len(attributes.birth_date)><cf_date tarih="attributes.birth_date"></cfif>
<cfif len(attributes.work_start)><cf_date tarih="attributes.work_start"></cfif>
<cfif len(attributes.work_finish)><cf_date tarih="attributes.work_finish"></cfif>
<cfif len(attributes.old_work_start)><cf_date tarih="attributes.old_work_start"></cfif>
<cfif len(attributes.old_work_finish)><cf_date tarih="attributes.old_work_finish"></cfif>
<cflock timeout="100">
<cftransaction>
	<cfquery name="add_personel_requirement_form" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			PERSONEL_ASSIGN_FORM
		(
			PERSONEL_ASSIGN_HEAD,
			PERSONEL_ASSIGN_DETAIL,
			PERSONEL_NAME,
			PERSONEL_SURNAME,
			PERSONEL_TC_IDENTY_NO,
			BIRTH_DATE,
			SEX,
			MILITARY_STATUS,
			MILITARY_DETAIL,
			TRAINING_LEVEL,
			PERSONEL_ATTEMPT,
			LICENCECAT_ID,
			IS_PSYCHOTECHNICS,
			RELATIVE_STATUS,
			RELATIVE_DETAIL,
			WORK_START,
			WORK_FINISH,
			OUR_COMPANY_ID,
			DEPARTMENT_ID,
			BRANCH_ID,
			OLD_OUR_COMPANY_ID,
			OLD_DEPARTMENT_ID,
			OLD_BRANCH_ID,
			POSITION_CAT_ID,
			OLD_POSITION_ID,
			OLD_POSITION_NAME,
			OLD_WORK_START,
			OLD_WORK_FINISH,
			OLD_FINISH_DETAIL,
			ASSIGN_PROPERTIES,
			SALARY,
			SALARY_MONEY,
			OLD_SALARY,
			OLD_SALARY_MONEY,
			RELATED_CV_BANK_ID,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP,
			PERSONEL_REQ_ID,
			PER_ASSIGN_STAGE
		)
		VALUES
		(
			'#attributes.PERSONEL_ASSIGN_HEAD#',
			'#attributes.PERSONEL_ASSIGN_DETAIL#',
			'#attributes.PERSONEL_NAME#',
			'#attributes.PERSONEL_SURNAME#',
			'#attributes.PERSONEL_TC_IDENTY_NO#',
			<cfif len(attributes.birth_date)>#attributes.birth_date#<cfelse>NULL</cfif>,
			#attributes.sex#,
			#attributes.MILITARY_STATUS#,
			'#attributes.MILITARY_DETAIL#',
			#attributes.TRAINING_LEVEL#,
			'#attributes.PERSONEL_ATTEMPT#',
			<cfif isdefined("attributes.driver_licence_type") and len(attributes.driver_licence_type)>'#attributes.driver_licence_type#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.is_psychotechnics")>#attributes.is_psychotechnics#<cfelse>0</cfif>,
			#attributes.RELATIVE_STATUS#,
			'#attributes.RELATIVE_DETAIL#',
			<cfif len(attributes.work_start)>#attributes.work_start#<cfelse>NULL</cfif>,
			<cfif len(attributes.work_finish)>#attributes.work_finish#<cfelse>NULL</cfif>,
			<cfif len(attributes.OUR_COMPANY_ID)>#attributes.OUR_COMPANY_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.DEPARTMENT_ID)>#attributes.DEPARTMENT_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.BRANCH_ID)>#attributes.BRANCH_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.OLD_OUR_COMPANY_ID)>#attributes.OLD_OUR_COMPANY_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.OLD_DEPARTMENT_ID)>#attributes.OLD_DEPARTMENT_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.OLD_BRANCH_ID)>#attributes.OLD_BRANCH_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.POSITION_CAT_ID)>#attributes.POSITION_CAT_ID#<cfelse>NULL</cfif>,
			<cfif len(attributes.OLD_POSITION_ID)>#attributes.OLD_POSITION_ID#<cfelse>NULL</cfif>,
			'#attributes.OLD_POSITION_NAME#',
			<cfif len(attributes.OLD_WORK_START)>#attributes.OLD_WORK_START#<cfelse>NULL</cfif>,
			<cfif len(attributes.OLD_WORK_FINISH)>#attributes.OLD_WORK_FINISH#<cfelse>NULL</cfif>,
			'#attributes.OLD_FINISH_DETAIL#',
			<cfif isdefined("attributes.ASSIGN_PROPERTIES") and len(attributes.ASSIGN_PROPERTIES)>'#attributes.ASSIGN_PROPERTIES#'<cfelse>NULL</cfif>,
			<cfif len(attributes.SALARY)>#attributes.SALARY#<cfelse>NULL</cfif>,
			'#attributes.SALARY_MONEY#',
			<cfif len(attributes.OLD_SALARY)>#attributes.OLD_SALARY#<cfelse>NULL</cfif>,
			'#attributes.OLD_SALARY_MONEY#',
			<cfif isDefined("attributes.related_cv_bank_id") and Len(attributes.related_cv_bank_id)>#attributes.related_cv_bank_id#<cfelse>NULL</cfif>,
			#session.ep.userid#,
			#now()#,
			'#cgi.REMOTE_ADDR#',
			<cfif len(attributes.PERSONEL_REQ_ID)>#attributes.PERSONEL_REQ_ID#<cfelse>NULL</cfif>,
			#attributes.process_stage#
		)
	</cfquery>
	<cfif len(attributes.branch_id)>
		<cfquery name="get_olds" datasource="#dsn#" maxrows="1">
			SELECT ASSIGN_NUMBER FROM PERSONEL_ASSIGN_FORM WHERE BRANCH_ID = #attributes.branch_id# AND PERSONEL_ASSIGN_ID <> #MAX_ID.IDENTITYCOL# AND ASSIGN_NUMBER IS NOT NULL ORDER BY ASSIGN_NUMBER DESC
		</cfquery>
		<cfif get_olds.recordcount>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE
					PERSONEL_ASSIGN_FORM
				SET
					ASSIGN_NUMBER = #get_olds.ASSIGN_NUMBER + 1#
				WHERE
					PERSONEL_ASSIGN_ID = #MAX_ID.IDENTITYCOL#
			</cfquery>
		</cfif>
	</cfif>
	<cfif Len(attributes.PERSONEL_ASSIGN_DETAIL)>
		<cfif Len(attributes.personel_assign_detail) gt 75>
			<cfset pers_det_ = Left(attributes.personel_assign_detail,72) & "...">
		<cfelse>
			<cfset pers_det_ = attributes.personel_assign_detail>
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
				 #MAX_ID.IDENTITYCOL#,
				'#pers_det_#',
				'#attributes.PERSONEL_ASSIGN_DETAIL#',
				 0,
				 0,
				 #session.ep.company_id#,
				 #session.ep.userid#,
				 #now()#,
				'#cgi.remote_addr#'
			)
		</cfquery>
	</cfif>
	<!--- Surec taginin transaction icinde kalmasi onemle rica olunur, filelarda kullaniliyor FBS 20100606 --->
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#'
		action_table='PERSONEL_ASSIGN_FORM'
		action_column='PERSONEL_ASSIGN_ID'
		action_id='#MAX_ID.IDENTITYCOL#'
		action_page='#request.self#?fuseaction=hr.list_personel_assign_form&event=upd&per_assign_id=#MAX_ID.IDENTITYCOL#'
		warning_description = 'Personel Atama Formu : #attributes.personel_assign_head#'>
</cftransaction>
</cflock>
<cfset attributes.actionId=MAX_ID.IDENTITYCOL>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_personel_assign_form&event=upd&per_assign_id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>
