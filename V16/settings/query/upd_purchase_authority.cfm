<cfquery name="UPD_PURCHASE_AUTHORITY" datasource="#DSN#">
	UPDATE
		SETUP_PURCHASE_AUTHORITY
    SET
        AUTHORITY_NAME = '#attributes.authority_name#',
        DETAIL = '#attributes.detail#',
        UPDATE_IP = '#cgi.remote_addr#', ,
        UPDATE_DATE = #now()#,
        UPDATE_EMP = #session.ep.userid#	 
    WHERE
        AUTHORITY_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_purchase_authority" addtoken="no">
