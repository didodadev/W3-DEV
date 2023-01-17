<cfquery name="UPDDRIVERLICENCE" datasource="#dsn#">
	UPDATE 
		SETUP_DRIVERLICENCE 
	SET 
		LICENCECAT='#LICENCECAT#',
		IS_LAST_YEAR_CONTROL = <cfif isdefined("attributes.IS_LAST_YEAR_CONTROL")>1<cfelse>0</cfif>,
		USAGE_YEAR = <cfif len(attributes.USAGE_YEAR)>#attributes.USAGE_YEAR#<cfelse>NULL</cfif>,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_DATE = #NOW()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE 
		LICENCECAT_ID=#LICENCECAT_ID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_driver_licence" addtoken="no">
