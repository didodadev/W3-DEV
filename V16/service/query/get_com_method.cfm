<cfquery name="GET_COM_METHOD" datasource="#DSN#">
	SELECT 
		COMMETHOD_ID,
		#dsn#.Get_Dynamic_Language(COMMETHOD_ID,'#session.ep.language#','SETUP_COMMETHOD','COMMETHOD',NULL,NULL,COMMETHOD) AS COMMETHOD
	FROM 
		SETUP_COMMETHOD
		<cfif isDefined("attributes.commethod_id")>
            WHERE
                COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#">
		</cfif>		
	ORDER BY
		COMMETHOD
</cfquery>

