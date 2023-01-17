<!--- 
	amac            : gelen team_name parametresine g�re TEAM_NAME,TEAM_ID ve SZ_NAME bilgisini getirmek
	parametre adi   : team_name
	kullanim        : get_team('Takim') 
	Yazan           : S.T
	Tarih           : 20081121--->
<cffunction name="get_team" access="public" returnType="query" output="no">
    <cfargument name="team_name" required="yes" type="string">
    <cfquery name="GET_TEAM_" datasource="#dsn#">
        SELECT 
            SZT.TEAM_ID,
            SZT.TEAM_NAME,
            SZ.SZ_NAME
        FROM 
            SALES_ZONES_TEAM SZT,
            SALES_ZONES SZ
        WHERE 
            SZ.SZ_ID = SZT.SALES_ZONES AND
            TEAM_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.team_name#%">
        ORDER BY SZT.TEAM_NAME
    </cfquery>				
<cfreturn get_team_>
</cffunction>
	 


