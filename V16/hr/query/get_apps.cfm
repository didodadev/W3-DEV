<cfquery name="GET_APPS" datasource="#dsn#">
	SELECT
		EMPLOYEES_APP.EMPAPP_ID,
		<!--- EMPLOYEES_APP.APP_NO, --->
		EMPLOYEES_APP.NAME,
		EMPLOYEES_APP.SURNAME,
<!--- 		EMPLOYEES_APP.POSITION_ID,
		EMPLOYEES_APP.POSITION_CAT_ID, --->
		EMPLOYEES_APP.STEP_NO,
		EMPLOYEES_APP.COMMETHOD_ID,
		EMPLOYEES_APP.APPNOT,
		EMPLOYEES_APP.APP_STATUS,
		<!--- EMPLOYEES_APP.VALIDATOR_POSITION_CODE, --->
		EMPLOYEES_APP.VALID_DATE,
		EMPLOYEES_APP.RECORD_DATE
	FROM
		EMPLOYEES_APP
	WHERE
    <cfif isDefined("STATUS")>		
	   (
		NAME LIKE '%#attributes.keyword#%'
		OR
		SURNAME LIKE '%#attributes.keyword#%'
	   )	
	   	<cfif isdefined("attributes.commethod_id") AND (attributes.commethod_id neq 0)>
		 AND
		   COMMETHOD_ID = #attributes.COMMETHOD_ID#
		</cfif>	
		<cfif isdefined("attributes.notice_id") AND len(attributes.notice_id)>
		  AND
		    NOTICE_ID = #attributes.notice_id#
		</cfif> 
		<cfif isdefined("attributes.ended") AND (attributes.ended neq 0)>
			<cfif attributes.ended eq 1>
				AND
				STEP_NO IN (-3,-4)
			<cfelseif attributes.ended eq 2>
				AND
				STEP_NO = -2
			<cfelseif attributes.ended eq 3>
				AND
				STEP_NO = -1
			</cfif>
		</cfif> 
		 <cfif STATUS NEQ 0>
			AND
			APP_STATUS = #STATUS-1#
		  </cfif>
    <cfelse>
		APP_STATUS = 1	
	</cfif>
	ORDER BY 
		NAME 
</cfquery>
