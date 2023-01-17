<cfquery name="INSSERVICECAT" datasource="#DSN3#">
	INSERT INTO 
		SETUP_PROD_CANCEL_CATS
    (
        CANCEL_CAT,
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
<cflocation url="#request.self#?fuseaction=settings.form_add_prod_cancel_cats" addtoken="no">
