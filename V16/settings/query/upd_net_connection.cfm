<cfquery name="UPD_NET_CONNECTION" datasource="#DSN#">
	UPDATE
		SETUP_NET_CONNECTION
    SET
        CONNECTION_NAME = '#attributes.connection_name#',
        DETAIL = '#attributes.detail#',
        UPDATE_IP = '#cgi.remote_addr#',
        UPDATE_DATE = #now()#,
        UPDATE_EMP = #session.ep.userid#	 
    WHERE
        CONNECTION_ID = #attributes.id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_net_connection" addtoken="no">
