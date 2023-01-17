<cfset my_source = "#dsn#_#attributes.p_year#_#session.pp.our_company_id#">
<cfquery name="GET_CARIS" datasource="#my_source#">
	SELECT
		*
	FROM
		CARI_ROWS
	WHERE
		CARI_ACTION_ID IS NOT NULL
	<cfif isDefined("attributes.ACTION") AND len(attributes.ACTION)>
		AND ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action#">
	</cfif>
	<cfif isDefined("attributes.KEYWORD") AND len(attributes.KEYWORD)>
		AND ACTION_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.KEYWORD#%">
	</cfif>
	AND
	(
		TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	OR
		FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	)
	<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
		AND ACTION_DATE >= #attributes.start_date#
	</cfif>
	<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
		AND ACTION_DATE <= #attributes.finish_date#
	</cfif>
	ORDER BY
		ACTION_DATE
</cfquery>

