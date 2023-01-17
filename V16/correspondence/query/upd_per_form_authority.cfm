<cfloop from="1" to="#attributes.record_count#" index="i">
	<cfif isDefined("attributes.sms_startdate#i#") and len(evaluate("attributes.sms_startdate#i#"))>
		<cf_date tarih="attributes.sms_startdate#i#">
		<cfset SMS_WARNING_DATE = DATEADD('h',evaluate("attributes.SMS_START_CLOCK#i#")-session.ep.time_zone,evaluate("attributes.sms_startdate#i#"))>
		<cfset SMS_WARNING_DATE = DATEADD('n',evaluate("attributes.SMS_START_MIN#i#"),SMS_WARNING_DATE)>
	<cfelse>
		<cfset SMS_WARNING_DATE = "NULL">
	</cfif>
	
	<cfif isDefined("attributes.email_startdate#i#") and len(evaluate("attributes.email_startdate#i#"))>
		<cf_date tarih="attributes.email_startdate#i#">
		<cfset EMAIL_WARNING_DATE = dateadd('h',evaluate("attributes.EMAIL_START_CLOCK#i#")-session.ep.time_zone,evaluate("attributes.email_startdate#i#"))>
		<cfset EMAIL_WARNING_DATE = dateadd('n',evaluate("attributes.EMAIL_START_MIN#i#"),EMAIL_WARNING_DATE)>
	<cfelse>
		<cfset EMAIL_WARNING_DATE = "NULL">
	</cfif>
	
	<cfif isDefined("attributes.response_date#i#") and len(evaluate("attributes.response_date#i#"))>
		<cf_date tarih="attributes.response_date#i#">
		<cfset RESPONSE_DATE = dateadd('h',evaluate("attributes.response_clock#i#")-session.ep.time_zone,evaluate("attributes.response_date#i#"))>
		<cfset RESPONSE_DATE = dateadd('n',evaluate("attributes.response_min#i#"),RESPONSE_DATE)>
	<cfelse>
		<cfset RESPONSE_DATE = "NULL">
	</cfif>
	
	<cfquery name="add_warning" datasource="#dsn#">
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
			OUR_COMPANY_ID,
			PERIOD_ID,
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
			#session.ep.company_id#,
            #session.ep.period_id#,
		<cfif isdefined("attributes.position_code#i#") and isdefined("attributes.employee#i#") and len(evaluate("attributes.employee#i#")) and len(evaluate("attributes.position_code#i#"))>
			#evaluate("attributes.position_code#i#")#
		<cfelse>
			NULL
		</cfif>
			)
	</cfquery>
	<cfquery name="GET_WARNINGS" datasource="#dsn#">
		SELECT  Max(W_ID) AS max FROM PAGE_WARNINGS
	</cfquery>
	
	<cfquery name="GET_WARNINGS" datasource="#dsn#">
		UPDATE
			PAGE_WARNINGS 
		SET
			PARENT_ID = #GET_WARNINGS.max# 
		WHERE
			W_ID = #GET_WARNINGS.max#			
	</cfquery>
<!---YETKİLİLER--->
<!---personel talebi--->
<cfif isdefined("attributes.per_req_id")>
	<cfif isdefined("attributes.position_code#i#") and isdefined("attributes.employee#i#") and len(evaluate("attributes.employee#i#")) and len(evaluate("attributes.position_code#i#"))>
		<cfquery name="get_authority" datasource="#dsn#">
			SELECT 
				POS_CODE
			FROM
				EMPLOYEES_APP_AUTHORITY
			WHERE
				PER_REQ_FORM_ID=#attributes.per_req_id# AND
				POS_CODE=#evaluate("attributes.position_code#i#")#
		</cfquery>
		<cfif not get_authority.recordcount>
			<cfquery name="add_authoriyt" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_APP_AUTHORITY
					(
						AUTHORITY_TYPE,
						PER_REQ_FORM_ID,
						POS_CODE,
						AUTHORITY_STATUS
					)VALUES
					(
						2,
						#attributes.per_req_id#,
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
					PER_REQ_FORM_ID=#attributes.per_req_id# AND
					POS_CODE=#evaluate("attributes.position_code#i#")#
			</cfquery>
		</cfif>
	</cfif>
</cfif>
<!---transfer rotasyon--->
<cfif isdefined("attributes.per_rot_id")>
	<cfif isdefined("attributes.position_code#i#") and isdefined("attributes.employee#i#") and len(evaluate("attributes.employee#i#")) and len(evaluate("attributes.position_code#i#"))>
		<cfquery name="get_authority" datasource="#dsn#">
			SELECT 
				POS_CODE
			FROM
				EMPLOYEES_APP_AUTHORITY
			WHERE
				ROTATION_FORM_ID=#attributes.per_rot_id# AND
				POS_CODE=#evaluate("attributes.position_code#i#")#
		</cfquery>
		<cfif not get_authority.recordcount>
			<cfquery name="add_authoriyt" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_APP_AUTHORITY
					(
						AUTHORITY_TYPE,
						ROTATION_FORM_ID,
						POS_CODE,
						AUTHORITY_STATUS
					)VALUES
					(
						3,
						#attributes.per_rot_id#,
						#evaluate("attributes.position_code#i#")#,
						1
					)
			</cfquery>
		<cfelseif get_authority.recordcount>
			<cfquery name="upd_authoriyt" datasource="#dsn#">
				UPDATE
					EMPLOYEES_APP_AUTHORITY
				SET
					AUTHORITY_STATUS = 1
				WHERE
					ROTATION_FORM_ID=#attributes.per_rot_id# AND
					POS_CODE=#evaluate("attributes.position_code#i#")#
			</cfquery>
		</cfif>
	</cfif>
</cfif>
<!---YETKİLİLER--->
</cfloop>
<cfif isdefined("attributes.per_req_id")>
	<cflocation url="#request.self#?fuseaction=correspondence.popup_upd_per_form_autority&per_req_id=#attributes.per_req_id#" addtoken="no">
<cfelseif isdefined("attributes.per_rot_id")>
	<cflocation url="#request.self#?fuseaction=correspondence.popup_upd_per_form_autority&per_rot_id=#attributes.per_rot_id#" addtoken="no">
</cfif>
