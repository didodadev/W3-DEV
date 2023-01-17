<cfquery name="insert_ims_codes" datasource="#DSN#"> 
	INSERT INTO 
		SETUP_FUEL_TYPE
    (
        FUEL_NAME,
        FUEL_DETAIL,
        RECORD_IP,
        RECORD_DATE,
        RECORD_EMP
    ) 
    VALUES 
    (
        '#attributes.fuel_name#',
        <cfif len(attributes.fuel_detail)>'#attributes.fuel_detail#'<cfelse>null</cfif>,
        '#cgi.remote_addr#',
        #now()#,
        #session.ep.userid#
    )
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_fuel_type" addtoken="no">
