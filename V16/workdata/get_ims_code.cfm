<!--- Autocomplate için yapıldı,tüm IMS_CODE'ları  getirir --->

<cffunction name="get_ims_code" access="public" returntype="query" output="no">
	<cfargument name="ims_code" required="yes" type="string">
    <cfargument name="maxrows" required="yes" type="string" default="">
	<cfquery name="get_ims_code_" datasource="#dsn#">
             SELECT
                IMS_CODE_ID,
                IMS_CODE,
                IMS_CODE_NAME,
                <cfif database_type is 'MSSQL'>
				IMS_CODE + ' ' + IMS_CODE_NAME AS IMS_NAME
				<cfelseif database_type is 'DB2'>
				IMS_CODE || ' ' || IMS_CODE_NAME AS IMS_NAME
				</cfif>
            FROM
                SETUP_IMS_CODE
            WHERE
                IMS_CODE_ID IS NOT NULL 
                 AND
                    (
                        IMS_CODE LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ims_code#%"> OR
                        IMS_CODE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ims_code#%">
                    )
            ORDER BY
                IMS_CODE
	</cfquery>
	<cfreturn get_ims_code_>
</cffunction>

