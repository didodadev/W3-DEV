<!--- 
	amac            : gelen event_name parametresine göre EVENT_HEAD,EVENT_ID bilgisini getirmek
	parametre adi   : event_name
	kullanim        : get_event 
 --->
<cffunction name="get_event" access="public" returnType="query" output="no">
	<cfargument name="event_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1"><!--- -1 (All) yerine kullanilabilir FBS --->
		<cfquery name="get_event_" datasource="#dsn#" maxrows="-1"><!--- maxrows="#arguments.maxrows#" --->
			SELECT
				EVENT_ID,
				EVENT_HEAD
			FROM 
				EVENT
			WHERE
				EVENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.event_name#%">
			ORDER BY EVENT_HEAD
		</cfquery>
	<cfreturn get_event_>
</cffunction>
