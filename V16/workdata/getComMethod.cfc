<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cffunction name="getCompenentFunction">
		<cfquery name="getComMethod" datasource="#dsn#">
			SELECT 
                COMMETHOD_ID,
                  CASE
                WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                    ELSE COMMETHOD
                END AS COMMETHOD
             FROM
             SETUP_COMMETHOD
             	LEFT JOIN SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_COMMETHOD.COMMETHOD_ID
                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="COMMETHOD">
                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_COMMETHOD">
                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
		</cfquery>
		<cfreturn getComMethod>
	</cffunction>
</cfcomponent>

