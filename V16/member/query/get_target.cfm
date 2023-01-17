<!--- get_target.cfm --->
<cfquery name="GET_TARGET" DATASOURCE="#DSN#" MAXROWS="10">
	SELECT 	
		TARGET_ID, 
		TARGET_HEAD 
		<cfif #isDefined("URL.TID")#>
		,STARTDATE,
		FINISHDATE,
		TARGET_DETAIL,
		PARTNER_ID,
		TARGET_NUMBER
		</cfif>
	FROM 
		TARGET
		<cfif #isDefined("URL.TID")#>
	WHERE 
		TARGET.TARGET_ID = #URL.TID# 
		</cfif>
		<cfif #isDefined("URL.PID")#>
	WHERE 
		PARTNER_ID=#URL.PID#
		</cfif>
		<cfif isDefined("URL.CPID")>
	WHERE 
		COMPANY_ID = #URL.CPID#
		</cfif>
	ORDER BY 
		TARGET_ID DESC
	</cfquery>
	<cfif not fuseaction contains "detail_partner">
	<cfquery name="CP_DETAIL" datasource="#dsn#">
		SELECT 
		   CP.PARTNER_ID,
		   CP.COMPANY_ID, 
		   C.FULLNAME, 
		   CP.COMPANY_PARTNER_NAME, 
		   CP.COMPANY_PARTNER_SURNAME 
		FROM 
			COMPANY_PARTNER CP, COMPANY C
		<cfif isDefined("URL.PID") OR isDefined("URL.CPID")>WHERE</cfif>
		<cfif isDefined("URL.PID")>CP.PARTNER_ID = #GET_TARGET.PARTNER_ID#</cfif>
		<cfif isDefined("URL.CPID")><cfif isDefined("URL.PID")>AND</cfif> C.COMPANY_ID = CP.COMPANY_ID</cfif>
	</cfquery>
</cfif>
