<cfquery name="ADD_IT_CONCERNED" datasource="#DSN#">
	INSERT INTO
		SETUP_IT_CONCERNED
    (
        CONCERN_NAME,
        DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
	VALUES
    (
        '#attributes.concern_name#',
        <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_it_concerned" addtoken="no">
