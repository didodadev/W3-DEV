<cfquery name="DELPRO_PACKAGE" datasource="#dsn#">
	DELETE 
	FROM  
		SETUP_PACKAGE_TYPE 
	WHERE 
		PACKAGE_TYPE_ID=#URL.TYPE_ID#
</cfquery>
 <cflocation url="#request.self#?fuseaction=settings.add_package_type" addtoken="no">
