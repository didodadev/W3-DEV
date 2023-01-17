<cfquery name="INSSERVICECAT" datasource="#DSN3#">
	INSERT INTO 
		SETUP_PROD_RETURN_CATS
    (
        RETURN_CAT,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    ) 
    VALUES 
    (
        '#attributes.returncat#',
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_prod_return_cats" addtoken="no">
