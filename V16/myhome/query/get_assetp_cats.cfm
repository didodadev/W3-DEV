<cfquery name="GET_ASSETP_CATS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		ASSET_P_CAT
	<cfif isdefined("attributes.cat_id")>
	WHERE
		ASSETP_CATID = #attributes.cat_id#
	</cfif>	
</cfquery>
