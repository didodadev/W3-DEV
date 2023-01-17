<cfsetting showdebugoutput="no">
<cfquery name="UPD_PRO" datasource="#DSN3#">
	UPDATE 
		ORDER_DEMANDS
	SET 
		DEMAND_STATUS = 0
	WHERE 
		DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.demand_id#">
</cfquery>
