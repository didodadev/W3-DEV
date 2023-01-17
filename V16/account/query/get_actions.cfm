<!--- <cfif isdefined("attributes.date1") and isdefined("attributes.date2") and LEN(attributes.date2)  and  LEN(attributes.date1)>
	<cf_date tarih="attributes.date1">
	<cf_date tarih="attributes.date2">
</cfif> --->
<cfquery name="GET_ACTIONS" datasource="#dsn2#">
	SELECT
		*
	FROM
		BANK_ACTIONS
	WHERE
		ACTION_ID IS NOT NULL
	<cfif isDefined("attributes.CARD_TYPE") and len(attributes.CARD_TYPE)>
		AND IS_ACCOUNT_TYPE=#attributes.CARD_TYPE#
	</cfif>
		AND IS_ACCOUNT=0
	<cfif len(attributes.process_type) and attributes.process_type eq 5>
		AND ACTION_TYPE_ID IN (#process_list#)
	<cfelseif not len(attributes.process_type)>
		AND (ACTION_TYPE_ID = 21 OR ACTION_TYPE_ID = 22 OR ACTION_TYPE_ID = 23)
	<cfelse>
		AND 1=0
	</cfif>	
	<cfif isDefined("attributes.date1") AND isDefined("attributes.date2") and LEN(attributes.date2) and  LEN(attributes.date1)>
		AND ACTION_DATE<=#attributes.date2#
		AND ACTION_DATE>=#attributes.date1#
	</cfif>
</cfquery>
