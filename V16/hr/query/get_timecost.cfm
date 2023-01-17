<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.startdate">
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfset attributes.day=date_add("D",-7,now())>
	<cfif isdefined('attributes.s') and len(attributes.s)>
		<cf_date tarih="attributes.s">
	</cfif>
</cfif>

<cfquery name="GET_TIME_COST" datasource="#dsn#">
	SELECT 
		TIME_COST.* 
	FROM 
		TIME_COST
	WHERE 
		TIME_COST.EMPLOYEE_ID=#attributes.id#
	<cfif isDefined("attributes.keyword") AND len(attributes.keyword)>
		AND
		(
			TIME_COST.COMMENT LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isDefined("attributes.STARTDATE") and len(attributes.STARTDATE) AND isDefined("attributes.FINISHDATE") and len(attributes.FINISHDATE)>
		AND TIME_COST.EVENT_DATE >= #attributes.STARTDATE#
		AND TIME_COST.EVENT_DATE <= #attributes.FINISHDATE#
	</cfif>
	ORDER BY
		TIME_COST.TIME_COST_ID DESC
</cfquery>
