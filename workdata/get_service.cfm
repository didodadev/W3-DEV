<!--- FBS 20081007 Servis - Basvuru ekranlarinda Search Bar kullanimi icin eklenmistir. --->
<cffunction name="get_service" access="public" returnType="query" output="no">
	<cfargument name="basvuru_no" required="yes" type="string">
	<cfquery name="get_service" datasource="#dsn3#">
		SELECT 
			SERVICE_ID,
			SERVICE_NO,
			SERVICE_HEAD
		FROM 
			SERVICE 
		WHERE 
			SERVICE_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.basvuru_no#%">
			OR SERVICE_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.basvuru_no#%">
	</cfquery>
	<cfreturn get_service>
</cffunction>

