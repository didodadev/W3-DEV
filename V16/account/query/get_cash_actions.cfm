<cfif isdefined("attributes.date1") and isdefined("attributes.date2") and LEN(attributes.date2)  and  LEN(attributes.date1)>
	<cf_date tarih="attributes.date1">
	<cf_date tarih="attributes.date2">
</cfif>
<cfquery name="GET_CASH_ACTIONS" datasource="#dsn2#">
	SELECT
		*
	FROM
		CASH_ACTIONS
	WHERE
		WITH_NEXT_ROW = 1 AND
		ACTION_ID IS NOT NULL AND
		IS_ACCOUNT = 0
	<cfif attributes.process_type eq 1>
		AND ACTION_TYPE_ID IN(#process_list#)
	<cfelseif not len(process_list)>
		AND (ACTION_TYPE_ID = 38 OR ACTION_TYPE_ID = 39)
	<cfelse>
		AND 1=0
	</cfif>
	<cfif isDefined("attributes.date1") AND isDefined("attributes.date2") and LEN(attributes.date2)  and  LEN(attributes.date1)>
	AND ACTION_DATE<=#attributes.date2#
	AND ACTION_DATE>=#attributes.date1#
	</cfif>
</cfquery>
