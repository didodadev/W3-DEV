<cfif isdefined("attributes.is_pool") and attributes.is_pool neq 1>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0' 
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='EMPLOYEES_APP_SEL_LIST'
	action_column='LIST_ID'
	action_id='#attributes.list_id#'
	action_page='#request.self#?fuseaction=myhome.upd_emp_app_select_list&list_id=#attributes.list_id#' 
	warning_description = 'Seçim Listesi : Aşaması Değişti'>
</cfif>
<cfquery name="upd_list" datasource="#dsn#">
	UPDATE
		EMPLOYEES_APP_SEL_LIST
	SET
		LIST_NAME='#attributes.list_name#',
		LIST_DETAIL='#attributes.list_detail#',
		LIST_STATUS=<cfif IsDefined('attributes.list_status')>1<cfelse>0</cfif>,
		IS_APPLICANT_POOL = <cfif isdefined("attributes.is_pool") and len(attributes.is_pool)>#attributes.is_pool#<cfelse>0</cfif>,
		<cfif len(attributes.notice_id) and len(notice_head)>
			NOTICE_ID=#attributes.notice_id#
		<cfelse>
			NOTICE_ID=NULL
		</cfif>,
		<cfif len(attributes.app_position) and len(attributes.position_id)>
			POSITION_ID=#attributes.position_id#
		<cfelse>
			POSITION_ID=NULL
		</cfif>,
		<cfif len(attributes.POSITION_CAT) and len(attributes.position_cat_id)>
			POSITION_CAT_ID=#attributes.position_cat_id#
		<cfelse>
			POSITION_CAT_ID=NULL
		</cfif>,
		<cfif len(attributes.company) and len(attributes.company_id)>
			COMPANY_ID=#attributes.company_id#
		<cfelse>
			COMPANY_ID=NULL
		</cfif>,
		<cfif len(attributes.our_company_id)>
			OUR_COMPANY_ID=#attributes.our_company_id#
		<cfelse>
			OUR_COMPANY_ID=NULL
		</cfif>,
		<cfif len(attributes.department_id) and len(attributes.department)>
			DEPARTMENT_ID=#attributes.department_id#
		<cfelse>
			DEPARTMENT_ID=NULL
		</cfif>,
		<cfif len(attributes.branch) and len(attributes.branch_id)>
			BRANCH_ID=#attributes.branch_id#
		<cfelse>
			BRANCH_ID=NULL
		</cfif>,
		SEL_LIST_STAGE=<cfif isdefined("attributes.process_stage")>#attributes.process_stage#<cfelse>NULL</cfif>,
		PIF_ID=<cfif len(attributes.pif_id)>#attributes.pif_id#<cfelse>NULL</cfif>,
		UPDATE_DATE=#now()#,
		UPDATE_EMP=#session.ep.userid#,
		UPDATE_IP='#cgi.REMOTE_ADDR#'
	WHERE
		LIST_ID=#attributes.list_id#
</cfquery>

<cfloop from="1" to="#attributes.record_count#" index="i">
	<cfif isDefined("attributes.sms_startdate#i#") and len(evaluate("attributes.sms_startdate#i#"))>
		<cf_date tarih="attributes.sms_startdate#i#">
		<cfset SMS_WARNING_DATE = date_add('h',evaluate("attributes.SMS_START_CLOCK#i#")-session.ep.time_zone,evaluate("attributes.sms_startdate#i#"))>
		<cfset SMS_WARNING_DATE = date_add('n',evaluate("attributes.SMS_START_MIN#i#"),SMS_WARNING_DATE)>
	<cfelse>
		<cfset SMS_WARNING_DATE = "NULL">
	</cfif>
	
	<cfif isDefined("attributes.email_startdate#i#") and len(evaluate("attributes.email_startdate#i#"))>
		<cf_date tarih="attributes.email_startdate#i#">
		<cfset EMAIL_WARNING_DATE = date_add('h',evaluate("attributes.EMAIL_START_CLOCK#i#")-session.ep.time_zone,evaluate("attributes.email_startdate#i#"))>
		<cfset EMAIL_WARNING_DATE = date_add('n',evaluate("attributes.EMAIL_START_MIN#i#"),EMAIL_WARNING_DATE)>
	<cfelse>
		<cfset EMAIL_WARNING_DATE = "NULL">
	</cfif>
	
	<cfif isDefined("attributes.response_date#i#") and len(evaluate("attributes.response_date#i#"))>
		<cf_date tarih="attributes.response_date#i#">
		<cfset RESPONSE_DATE = date_add('h',evaluate("attributes.response_clock#i#")-session.ep.time_zone,evaluate("attributes.response_date#i#"))>
		<cfset RESPONSE_DATE = date_add('n',evaluate("attributes.response_min#i#"),RESPONSE_DATE)>
	<cfelse>
		<cfset RESPONSE_DATE = "NULL">
	</cfif>

	<cfquery name="add_warning" datasource="#dsn#" result="GET_WARNINGS">
		INSERT INTO
			PAGE_WARNINGS
			(
			URL_LINK,
			WARNING_HEAD,
			SETUP_WARNING_ID,
			WARNING_DESCRIPTION,
			SMS_WARNING_DATE,
			EMAIL_WARNING_DATE,
			LAST_RESPONSE_DATE,
			RECORD_DATE,
			IS_ACTIVE,
			IS_PARENT,
			RESPONSE_ID,
			RECORD_IP,
			RECORD_EMP,
			POSITION_CODE
			)
		VALUES
			(
			'#attributes.URL_LINK#',
			'#ListGetAt(evaluate("WARNING_HEAD#i#"),1,"--")#',
			#ListGetAt(evaluate("WARNING_HEAD#i#"),2,"--")#,
			'#wrk_eval("attributes.WARNING_DESCRIPTION#i#")#',
			#SMS_WARNING_DATE#,
			#EMAIL_WARNING_DATE#,
			#RESPONSE_DATE#,
			#NOW()#,
			1,
			1,
			0,
			'#CGI.REMOTE_ADDR#',
			#SESSION.EP.USERID#,
		<cfif isdefined("attributes.position_code#i#") and isdefined("attributes.employee#i#") and len(evaluate("attributes.employee#i#")) and len(evaluate("attributes.position_code#i#"))>
			#evaluate("attributes.position_code#i#")#
		<cfelse>
			NULL
		</cfif>
			)
	</cfquery>
	<cfquery name="UPD_WARNINGS" datasource="#dsn#">
		UPDATE PAGE_WARNINGS SET PARENT_ID = #GET_WARNINGS.IDENTITYCOL# WHERE W_ID = #GET_WARNINGS.IDENTITYCOL#			
	</cfquery>
<!---YETKİLİLER--->
	<cfif isdefined("attributes.position_code#i#") and isdefined("attributes.employee#i#") and len(evaluate("attributes.employee#i#")) and len(evaluate("attributes.position_code#i#"))>
		<cfquery name="get_authority" datasource="#dsn#">
			SELECT 
				POS_CODE
			FROM
				EMPLOYEES_APP_AUTHORITY
			WHERE
				LIST_ID=#attributes.list_id# AND
				POS_CODE=#evaluate("attributes.position_code#i#")#
		</cfquery>
		<cfif not get_authority.recordcount>
			<cfquery name="add_authoriyt" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_APP_AUTHORITY
					(
						AUTHORITY_TYPE,
						LIST_ID,
						POS_CODE,
						AUTHORITY_STATUS
					)VALUES
					(	
						1,
						#attributes.list_id#,
						#evaluate("attributes.position_code#i#")#,
						1
					)
			</cfquery>
		<cfelseif get_authority.recordcount>
			<cfquery name="upd_authority" datasource="#dsn#">
				UPDATE
					EMPLOYEES_APP_AUTHORITY
				SET
					AUTHORITY_STATUS = 1
				WHERE 
					LIST_ID = #attributes.list_id# AND
					POS_CODE = #evaluate("attributes.position_code#i#")#
			</cfquery>
		</cfif>
	</cfif>
<!---YETKİLİLER--->
</cfloop>
<script type="text/javascript">
	window.location.href = '<cfoutput>#request.self#?fuseaction=hr.emp_app_select_list&event=det&list_id=#attributes.list_id#</cfoutput>';
</script>
