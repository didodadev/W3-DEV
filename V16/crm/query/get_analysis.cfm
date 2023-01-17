<cfquery name="GET_ANALYSIS" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		MEMBER_ANALYSIS
	WHERE 1=1
	<cfif not isdefined("attributes.cpid") and isDefined("attributes.ANALYSIS_ID") and len(attributes.ANALYSIS_ID)>
		AND ANALYSIS_ID=  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ANALYSIS_ID#"> 
	</cfif>
</cfquery>
