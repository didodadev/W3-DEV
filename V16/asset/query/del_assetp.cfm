<cfquery name="DEL_ASSETP" datasource="#dsn#">
	DELETE FROM 
		ASSET_P
	WHERE		
		ASSETP_ID = #attributes.ASSETP_ID#
</cfquery>
<cfquery name="DEL_ASSET_P_RESERVE" datasource="#DSN#">
    DELETE FROM
	    ASSET_P_RESERVE
    WHERE
	    ASSETP_ID = #attributes.ASSETP_ID#		
</cfquery>
<cflocation url="#request.self#?fuseaction=assetcare.list_assetp" addtoken="no">
