<cfset modul_list = "">
 <cfset counter = 1>
 <cfloop list="#session.ep.user_level#" index="i">
   <cfif i eq 1>
     <cfset modul_list = listappend(modul_list,counter)>
   </cfif>
   <cfset counter = counter + 1>
 </cfloop>
<cfquery name="get_reports" datasource="#dsn#">
   SELECT
	  R.REPORT_ID,
	  R.REPORT_NAME,
	  R.REPORT_ID,
	  R.IS_SPECIAL,
	  R.RECORD_EMP,
	  R.REPORT_DETAIL,
	  R.RECORD_DATE
	FROM 
	  REPORTS R
	WHERE
		 R.RECORD_EMP = #session.ep.userid# 
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			R.REPORT_NAME LIKE '%#attributes.keyword#%'
			OR
			R.REPORT_DETAIL LIKE '%#attributes.keyword#%'
		)
	</cfif>  
	<cfif isdefined("attributes.report_status") and attributes.report_status eq -1>
			AND REPORT_STATUS = 1
	<cfelseif isdefined("attributes.report_status") and attributes.report_status eq 0>
			AND REPORT_STATUS = 0
	<cfelse>
			AND (REPORT_STATUS=1 OR REPORT_STATUS=0)
	</cfif>
	ORDER BY
		R.REPORT_NAME 
</cfquery> 
