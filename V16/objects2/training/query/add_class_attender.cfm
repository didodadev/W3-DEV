<cfsetting showdebugoutput="no">
<cfquery name="get_class_name" datasource="#dsn#">
	SELECT CLASS_NAME FROM TRAINING_CLASS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_class_id#">
</cfquery>
<cfquery name="GET_PROCESS" datasource="#DSN#" maxrows="1">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		<cfif isdefined("session.pp")>
			PTR.IS_PARTNER = 1 AND
		<cfelse>
			PTR.IS_CONSUMER = 1 AND
		</cfif>
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.popup_add_helpdesk%">
</cfquery>

<cfquery name="ADD_HELP" datasource="#DSN#">
	INSERT INTO
		CUSTOMER_HELP
	(
		OUR_COMPANY_ID,
		SITE_DOMAIN,
		PARTNER_ID,
		COMPANY_ID,
		CONSUMER_ID,
		APP_CAT,
		SUBJECT,
		PROCESS_STAGE,
		APPLICANT_NAME,
		APPLICANT_MAIL,
		SUBSCRIPTION_ID,
		<cfif isdefined('session.pp.userid')>
			RECORD_PAR,
		<cfelseif isdefined('session.ww.userid')>
			RECORD_CONS,
		<cfelseif isdefined('session.cp.userid')>
			RECORD_APP,
		<cfelse>
			GUEST,
		</cfif>
		RECORD_DATE,
		RECORD_IP,
		IS_REPLY,
		IS_REPLY_MAIL,
		INTERACTION_DATE
	)
	VALUES
	(
		#session_base.our_company_id#,
		'#cgi.http_host#',
		NULL,
		NULL,
		NULL,
		6,
		'Eğitim: #get_class_name.class_name#<br /> Açıklama: #my_subject#',
		#GET_PROCESS.PROCESS_ROW_ID#,
		'#my_name#',
		'#my_email#',
		NULL,
		<cfif isdefined('session.pp.userid')>
			#session.pp.userid#,
		<cfelseif isdefined('session.ww.userid')>
			#session.ww.userid#,
		<cfelseif isdefined('session.cp.userid')>
			#session.cp.userid#,
		<cfelse>
			1,
		</cfif>
		#now()#,
		'#cgi.remote_addr#',
		0,
		0,
		#now()#
	)
</cfquery>
