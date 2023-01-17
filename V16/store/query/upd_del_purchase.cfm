	<cfquery name="get_ship_orders" datasource="#dsn2#">
		SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#attributes.UPD_ID# AND PERIOD_ID=#session.ep.period_id#
	</cfquery>
	<cflock name="#CreateUUID()#" timeout="20">
		<cftransaction>
		<cfif len(GET_NUMBER.SHIP_TYPE)>
			<cfquery name="DEL1" datasource="#DSN2#">
				DELETE FROM STOCKS_ROW WHERE UPD_ID = #attributes.UPD_ID# AND PROCESS_TYPE = #GET_NUMBER.SHIP_TYPE#
			</cfquery>
			<!--- seri no kayitlari silinir --->
			<cfinclude template="../../objects/functions/del_serial_no.cfm">
			<cfscript>
			del_serial_no(
			process_id : attributes.UPD_ID,
			process_cat : GET_NUMBER.SHIP_TYPE, 
			period_id : session.ep.period_id
			);
			</cfscript>
			<!--- seri no kayitlari silinir --->
		</cfif>
		<cfquery name="DEL4" datasource="#dsn2#">
			DELETE FROM SHIP_MONEY WHERE ACTION_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL2" datasource="#DSN2#">
			DELETE FROM	SHIP_ROW WHERE SHIP_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL3" datasource="#DSN2#">
			DELETE FROM	SHIP WHERE SHIP_ID = #attributes.UPD_ID#
		</cfquery>
		<cfif get_ship_orders.recordcount>
			<cfset order_id_list=valuelist(get_ship_orders.ORDER_ID)>
			<cfquery name="del_ship_orders" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#attributes.UPD_ID# AND PERIOD_ID=#session.ep.period_id#
			</cfquery>
			<cfloop list="#order_id_list#" index="k">
				 <cfset attributes.order_id = k >
				 <cfinclude template="get_order_rate.cfm">
			</cfloop>
		</cfif>
		<cf_add_log log_type="-1" action_id="#attributes.UPD_ID#" action_name="#attributes.ship_number# Silindi" paper_no="#attributes.ship_number#" process_type="#attributes.cat#" data_source="#DSN2#">
		</cftransaction>
	</cflock>
	<cflocation url="#request.self#?fuseaction=store.list_ship" addtoken="no">
