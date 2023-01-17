<cfquery name="GET_COM_METHOD" datasource="#dsn#">
	SELECT 
		*
	FROM 
		SETUP_COMMETHOD
		<cfif isDefined("attributes.COMMETHOD_ID")>
	WHERE
		COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#">
		</cfif>		
	ORDER BY
		COMMETHOD
</cfquery>
<!---
<cfquery name="GET_SERVICE_COM_METHOD" datasource="#dsn#">
	SELECT 
		*
	FROM 
		SETUP_COMMETHOD,
		#dsn3_alias#.SERVICE SRV
	WHERE
		SRV.COMMETHOD_ID=SETUP_COMMETHOD.COMMETHOD_ID
</cfquery>
--->
