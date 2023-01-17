<cfquery name="ADD_NET_CONNECTION" datasource="#DSN#">
    INSERT INTO
        SETUP_NET_CONNECTION
    (
        CONNECTION_NAME,
        DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
    VALUES
    (
        '#attributes.connection_name#',
        <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_net_connection" addtoken="no">
