<cfquery name="ADD_CAMP_TYPES" datasource="#DSN3#">
	INSERT INTO
		CAMPAIGN_TYPES
    (
        CAMP_TYPE,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    )
    VALUES
    (
        '#attributes.camp_type#',
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_camp_types" addtoken="no">
