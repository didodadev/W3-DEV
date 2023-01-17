<cfquery name="ADD_SETUP_FUEL_TYPE" datasource="#DSN#"> 
	UPDATE  
		SETUP_FUEL_TYPE
	SET
        FUEL_NAME = '#attributes.fuel_name#',
        FUEL_DETAIL =<cfif len(attributes.fuel_detail)>'#attributes.fuel_detail#'<cfelse>null</cfif>,
        UPDATE_IP = '#cgi.remote_addr#',
        UPDATE_DATE = #now()#,
        UPDATE_EMP = #session.ep.userid#	
	WHERE 
        FUEL_ID = #attributes.fuel_id#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_fuel_type" addtoken="no">
