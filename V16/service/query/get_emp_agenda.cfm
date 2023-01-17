<cfif url.sdate eq "">
<cfset url.sdate=now()>
</cfif>
<cfif url.fdate eq "">
<cfset url.fdate=date_add("y",60,url.sdate)>
</cfif>


<cfquery name="GET_EMP_AGENDA" datasource="#dsn#">
	SELECT
		*
	FROM
		EVENT
	WHERE
		EVENT_TO_EMP LIKE '%#URL.EMP_ID#%' 
	AND

		STARTDATE>#URL.SDATE#
	
</cfquery>

