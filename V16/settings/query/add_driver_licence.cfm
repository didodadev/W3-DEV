<cfquery name="INSDRIVERLICENCE" datasource="#dsn#">
	INSERT 
	INTO 
		SETUP_DRIVERLICENCE 
	(
		LICENCECAT,
		IS_LAST_YEAR_CONTROL,
		USAGE_YEAR,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES 
	(
		'#LICENCECAT#',
		<cfif isdefined("attributes.IS_LAST_YEAR_CONTROL")>1<cfelse>0</cfif>,
		<cfif len(attributes.USAGE_YEAR)>#attributes.USAGE_YEAR#<cfelse>NULL</cfif>,
		#SESSION.EP.USERID#,
		#NOW()#,
		'#CGI.REMOTE_ADDR#'
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_driver_licence" addtoken="no">
