<cfif not isdefined("db_adres")>
	<cfset db_adres = "#dsn2#">
</cfif>
<cfquery name="GET_ACTION_DETAIL" datasource="#db_adres#">
	SELECT
		*
	FROM
		#ATTRIBUTES.TABLE_NAME#
	WHERE
		ACTION_ID=#URL.ID#
</cfquery>
