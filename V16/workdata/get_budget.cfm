<!--- 
	amac            : gelen budget_name parametresine g�re BUDGET_NAME,BUDGET_ID bilgisini getirmek
	parametre adi   : budget_name
	kullanim        : get_budget('Iliskili Butce') 
	Yazan           : S.T
	Tarih           : 20081121--->
<cffunction name="get_budget" access="public" returnType="query" output="no">
	<cfargument name="budget_name" required="yes" type="string">
     <cfquery name="GET_BUDGET" datasource="#dsn#">
        SELECT
            BUDGET_ID,
            BUDGET_NAME
        FROM
            BUDGET
        WHERE
            BUDGET_ID IS NOT NULL AND
            BUDGET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.budget_name#%">
     </cfquery>				
<cfreturn get_budget>
</cffunction>
	 


