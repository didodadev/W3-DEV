<!--- get_partner_det.cfm --->
<cfif isdefined("url.pid")>
	<cfquery name="GET_PARTNER_DET" datasource="#dsn#">
	SELECT 
		NICKNAME, 
		COMPANY_PARTNER_NAME 
	FROM 
		COMPANY_PARTNER CP, 
		COMPANY C
	WHERE 
		CP.PARTNER_ID = #URL.PID# AND
		  CP.COMPANY_ID = C.COMPANY_ID	
	</cfquery>
<cfelseif isdefined("url.bid")>
	<cfquery name="GET_PARTNER_DET" datasource="#dsn#">
		SELECT 
			NICKNAME, 
			COMPANY_PARTNER_NAME 
		FROM 
			COMPANY_PARTNER CP, 
			COMPANY C
		WHERE  
			CP.COMPANY_ID = C.COMPANY_ID	
	</cfquery>
</cfif>
