<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfif len(GET_NUMBER.SHIP_TYPE)>
			<cfquery name="DEL1" datasource="#DSN2#">
				DELETE FROM STOCKS_ROW WHERE UPD_ID=#attributes.UPD_ID# AND PROCESS_TYPE=#GET_NUMBER.SHIP_TYPE#
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
		<cfquery name="get_ship_orders" datasource="#dsn2#">
			SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#attributes.UPD_ID# AND PERIOD_ID=#session.ep.period_id#
		</cfquery>
		<cfif get_ship_orders.recordcount>
			<cfset order_id_list=valuelist(get_ship_orders.ORDER_ID)>
			<cfquery name="del_ship_orders" datasource="#dsn2#">
				DELETE FROM #dsn3_alias#.ORDERS_SHIP WHERE SHIP_ID=#attributes.UPD_ID# AND PERIOD_ID=#session.ep.period_id#
			</cfquery>
			<cfloop list="#order_id_list#" index="k">
				 <cfset attributes.order_id=k>
				 <cfinclude template="../query/get_order_rate_purchase.cfm">
				<cfquery name="UPD_ORD" datasource="#dsn2#">
					UPDATE 
						#dsn3_alias#.ORDERS 
					SET 
						IS_PROCESSED = <cfif isdefined("is_processed")>#is_processed#,<cfelse>1,</cfif>
						ORDER_CURRENCY = #ORDER_CUR#,
						RESERVED = 0
					WHERE 
						ORDER_ID =#attributes.order_id#
				</cfquery>
			</cfloop>
		</cfif>
		<cfquery name="DEL4" datasource="#dsn2#">
			DELETE FROM SHIP_MONEY WHERE ACTION_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL2" datasource="#DSN2#">
			DELETE FROM	SHIP_ROW WHERE SHIP_ID=#attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL3" datasource="#DSN2#">
			DELETE FROM	SHIP WHERE SHIP_ID=#attributes.UPD_ID#
		</cfquery>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=service.popup_check_service_ships&service_id=#attributes.service_id#" addtoken="no">

