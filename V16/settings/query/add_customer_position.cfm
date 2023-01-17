<cfquery name="ADD_CUSTOMER_POSITION" datasource="#DSN#">
    INSERT INTO
        SETUP_CUSTOMER_POSITION
    (
        POSITION_NAME,
        DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
    VALUES
    (
        '#attributes.position_name#',
        <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cfif isDefined("attributes.is_detail")>
	<script language="JavaScript1.2">
        wrk_opener_reload();
        self.close();
    </script>
<cfelse>
    <cflocation url="#request.self#?fuseaction=settings.form_add_customer_position" addtoken="no">
</cfif>
