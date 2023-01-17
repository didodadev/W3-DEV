<cfquery name="ADD_DUTY_PERIOD" datasource="#DSN#">
    INSERT INTO
        SETUP_DUTY_PERIOD
   	(
        PERIOD_NAME,
        DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
    VALUES
    (
        '#attributes.period_name#',
        <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_duty_period" addtoken="no">
