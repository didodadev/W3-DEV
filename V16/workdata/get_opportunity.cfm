<!--- 
	amac            : gelen opp_name parametresine göre OPP_HEAD,OPP_ID bilgisini getirmek
	parametre adi   : opp_name
	kullanim        : get_opportunity 
 --->
<cffunction name="get_opportunity" access="public" returnType="query" output="no">
	<cfargument name="opp_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1"><!--- -1 (All) yerine kullanilabilir FBS --->
		<cfquery name="get_opportunity_" datasource="#dsn3#" maxrows="-1"><!--- maxrows="#arguments.maxrows#" --->
			SELECT
				OPP_ID,
				OPP_HEAD
			FROM 
				OPPORTUNITIES
			WHERE
				OPP_STATUS = 1 AND
				OPP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.opp_name#%">
			ORDER BY OPP_HEAD
		</cfquery>
	<cfreturn get_opportunity_>
</cffunction>
