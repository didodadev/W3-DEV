<cfquery name="CAMP_PROMS" datasource="#DSN3#">
	SELECT PROM_ID,PROM_HEAD FROM PROMOTIONS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#camp_id#">
</cfquery>
