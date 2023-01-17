<cfset attributes.to_day=now()>
<cfquery name="GET_SERVICE_SUPPORT" datasource="#dsn3#">
	SELECT
		*
	FROM
		SERVICE_SUPPORT,
		#dsn_alias#.SETUP_SUPPORT AS SETUP_SUPPORT
	WHERE 
		SERVICE_SUPPORT.SUPPORT_CAT_ID=SETUP_SUPPORT.SUPPORT_CAT_ID
		AND
		(
			(
			SERVICE_SUPPORT.FINISHDATE < #DATEADD("D",1,attributes.to_day)#
			AND
			SERVICE_SUPPORT.FINISHDATE > #DATEADD("D",-1,attributes.to_day)#
			)
		OR
			SERVICE_SUPPORT.FINISHDATE < #attributes.to_day#
		)
	ORDER BY 
		SERVICE_SUPPORT.RECORD_DATE DESC
</cfquery>
