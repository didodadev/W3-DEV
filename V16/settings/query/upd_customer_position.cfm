<cfquery name="UPD_CUSTOMER_POSITION" datasource="#DSN#">
	UPDATE
		SETUP_CUSTOMER_POSITION
    SET
        POSITION_NAME = '#attributes.position_name#',
        DETAIL = '#attributes.detail#',
        UPDATE_IP = '#cgi.remote_addr#',
        UPDATE_DATE = #now()#,
        UPDATE_EMP = #session.ep.userid#	 
    WHERE
        POSITION_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_customer_position" addtoken="no">
