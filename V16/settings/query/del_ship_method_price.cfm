<cflock name="#CREATEUUID()#" timeout="60">
 	<cftransaction>
		<cfquery name="DEL_SHIP_METHOD_PRICE" datasource="#DSN#">
			DELETE FROM SHIP_METHOD_PRICE WHERE SHIP_METHOD_PRICE_ID = #attributes.ship_method_price_id#
		</cfquery>	
		<cfquery name="DEL_SHIP_METHOD_PRICE_ROW" datasource="#DSN#">
			DELETE FROM SHIP_METHOD_PRICE_ROW WHERE SHIP_METHOD_PRICE_ID = #attributes.ship_method_price_id#
		</cfquery>
		<cf_add_log  log_type="-1" action_id="#attributes.ship_method_price_id#" action_name="#attributes.head#">
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=settings.list_ship_method_price" addtoken="no">
