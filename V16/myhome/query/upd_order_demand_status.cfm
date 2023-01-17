<cfsetting showdebugoutput="no">
<cfquery name="upd_pro" datasource="#dsn3#">
	UPDATE 
		ORDER_DEMANDS
	SET 
		DEMAND_STATUS = 0
	WHERE 
		DEMAND_ID = #attributes.demand_id#
</cfquery>
