<cfquery name="DEL_ASSETP_RESERVE" datasource="#dsn#">
	DELETE FROM 
		ASSET_P_RESERVE
	WHERE
		ASSETP_RESID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ASSETP_RESID#">
</cfquery>

<cflocation url="#CGI.REFERER#" addtoken="no">
