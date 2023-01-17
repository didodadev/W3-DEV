<cfquery name="DEL_ASSETP_CAT" datasource="#DSN#">
	DELETE FROM
		ASSET_P_CAT
	WHERE
		ASSETP_CATID = #ASSETP_CATID#
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.add_assetp_cat" addtoken="no">
