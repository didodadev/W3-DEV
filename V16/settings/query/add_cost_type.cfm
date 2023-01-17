<cfquery name="ADD_COST_TYPE" datasource="#DSN#">
    INSERT INTO 
        SETUP_COST_TYPE
  	(
        COST_TYPE_NAME,
        COST_TYPE_DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
   	)
    VALUES
    (
        '#attributes.cost_type_name#',
        '#attributes.cost_type_detail#',
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_cost_type" addtoken="no">
