<cfif url.sdate eq "">
<cfset url.sdate=now()>
</cfif>
<cfif url.fdate eq "">
<cfset url.fdate=date_add("y",60,url.sdate)>
</cfif>

<cfquery name="GET_PARTNER_AGENDA" datasource="#dsn#">
	SELECT
		*
	FROM
		EVENT
	WHERE
		EVENT_TO_PARTNER LIKE '%#URL.PARTNER_ID#%' 
	AND

		STARTDATE>#URL.SDATE#
				
	
</cfquery>

