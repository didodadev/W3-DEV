<!--- 
	amac            : gelen limb parametresine göre limb_id,limb bilgisini getirmek
	parametre adi   : limb
	Yazan           : Melek KOCABEY
	Tarih           : 20191212
 --->
<cffunction name="Get_SetupLimb" access="public" returnType="query" output="no">
	<cfargument name="limb" required="yes" type="string">
		<cfquery name="Get_SetupLimb" datasource="#DSN#">
			SELECT
                LIMB_ID,
                LIMB_NAME
			FROM
                SETUP_LIMB
			WHERE
            	1=1 AND				
				LIMB_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.limb#%"> 
			ORDER BY
            LIMB_ID
		</cfquery>
	<cfreturn Get_SetupLimb>
</cffunction>