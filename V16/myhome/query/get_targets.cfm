<cfquery name="GET_TARGETS" datasource="#dsn#">
	SELECT 
		T.*,
		TC.TARGETCAT_NAME
	FROM 
		TARGET T,
		TARGET_CAT TC
	WHERE 
		TC.TARGETCAT_ID=T.TARGETCAT_ID
		AND POSITION_CODE = #SESSION.EP.POSITION_CODE#
		<cfif isDefined("attributes.KEYWORD") and len(attributes.KEYWORD)>
		AND TARGET_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.KEYWORD#%">
		</cfif>
		ORDER BY T.STARTDATE DESC
</cfquery>

