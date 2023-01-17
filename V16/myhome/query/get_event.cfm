<cfparam name="attributes.all_events" default="">
<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
	<cf_date tarih = "attributes.startdate">
</cfif>
<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
	<cf_date tarih = "attributes.finishdate">
</cfif>
<cfquery name="GET_EVENT" datasource="#dsn#">
	SELECT
		EVENT_ID,
		EVENT_HEAD,
		EVENTCAT_ID,
		STARTDATE,
		FINISHDATE
	FROM
		EVENT 
	WHERE
		EVENT_ID IS NOT NULL
	<cfif attributes.all_events neq 1>
		AND EVENT_TO_POS LIKE '%,#session.ep.USERID#,%'
	</cfif>
	<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
		AND STARTDATE >= #attributes.startdate# 
		AND STARTDATE < #CreateODBCDateTime(DATEADD("d",1,attributes.startdate))# 
	</cfif>
	<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
		AND FINISHDATE < #CreateODBCDateTime(DATEADD("d",1,attributes.finishdate))#
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND EVENT_HEAD LIKE '<cfif len(attributes.keyword) neq 1>%</cfif>#attributes.keyword#%'
	</cfif>
	ORDER BY 
		EVENT_HEAD
</cfquery>
