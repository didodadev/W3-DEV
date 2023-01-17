<cfquery name="ADD_PURCHASE_AUTHORITY" datasource="#DSN#">
	INSERT INTO
		SETUP_PURCHASE_AUTHORITY
    (
        AUTHORITY_NAME,
        DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
	VALUES
    (
        '#attributes.authority_name#',
        <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_purchase_authority" addtoken="no">
