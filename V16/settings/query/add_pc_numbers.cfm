<cfquery name="INS_PC_NUMBERS" datasource="#DSN#"> 
    INSERT INTO 
        SETUP_PC_NUMBER
    (
        UNIT_NAME,
        UNIT_DESC,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    ) 
    VALUES 
    (
        '#attributes.unit_name#',
        '#attributes.unit_desc#',
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_pc_number">
