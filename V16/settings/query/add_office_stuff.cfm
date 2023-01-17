<cfquery name="INSERT_OFFICE_STUFF" datasource="#DSN#"> 
	INSERT INTO 
		SETUP_OFFICE_STUFF
    (
        STUFF_NAME,
        STUFF_DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    ) 
    VALUES 
    (
        '#attributes.stuff_name#',
        <cfif len(attributes.stuff_detail)>'#attributes.stuff_detail#'<cfelse>NULL</cfif>,
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_office_stuff" addtoken="no">
