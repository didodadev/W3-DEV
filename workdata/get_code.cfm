<!--- 
	amac            : gelen code_name parametresine g�re IMS_CODE_NAME, IMS_CODE_ID ve IMS_CODE bilgisini getirmek
	parametre adi   : code_name
	kullanim        : get_code('Mikro Bolge Kodu') 
	Yazan           : S.T
	Tarih           : 20081121--->
<cffunction name="get_code" access="public" returnType="query" output="no">
	<cfargument name="code_name" required="yes" type="string">
    <cfquery name="GET_CODE_" datasource="#dsn#">
        SELECT
            IMS_CODE_ID,
            IMS_CODE,
            <cfif database_type is 'MSSQL'>
            IMS_CODE + ' ' + IMS_CODE_NAME AS  IMS_CODE_NAME
            <cfelseif database_type is 'DB2'>
            IMS_CODE || ' ' || IMS_CODE_NAME AS  IMS_CODE_NAME
            </cfif>
        FROM
            SETUP_IMS_CODE
        WHERE
            IMS_CODE_ID IS NOT NULL AND
            <cfif database_type is 'MSSQL'>
            IMS_CODE + ' ' + IMS_CODE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.code_name#%">  
            <cfelseif database_type is 'DB2'>
            IMS_CODE || ' ' || IMS_CODE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.code_name#%">
            </cfif>
        ORDER BY IMS_CODE     
    </cfquery>				
<cfreturn get_code_>
</cffunction>
	 


