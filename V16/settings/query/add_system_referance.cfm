<cfquery name="add_referance_status" datasource="#dsn3#">
	INSERT INTO 
        SETUP_REFERANCE_STATUS
        (
            REFERANCE_STATUS,
            IS_ACTIVE,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
        ) 
        VALUES 
        (
            '#attributes.REFERANCE_STATUS#',
            <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
            #NOW()#,
            #SESSION.EP.USERID#,
            '#CGI.REMOTE_ADDR#'
        )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_system_referance" addtoken="no">
