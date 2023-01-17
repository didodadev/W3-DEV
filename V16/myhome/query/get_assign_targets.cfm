<cfquery name="get_assign_targets" datasource="#dsn#">
	SELECT 
		T.*,
		TC.TARGETCAT_NAME
	FROM 
		TARGET T,
		TARGET_CAT TC
	WHERE 
		TC.TARGETCAT_ID=T.TARGETCAT_ID
		AND TARGET_EMP = #session.ep.userid#
		<cfif isDefined("attributes.KEYWORD")>
		AND TARGET_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.KEYWORD#%">
		</cfif>
	ORDER BY STARTDATE DESC
</cfquery>

