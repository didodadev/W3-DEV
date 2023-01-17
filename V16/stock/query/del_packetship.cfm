<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="GET_PROCESS" datasource="#DSN2#">
			SELECT SHIP_RESULT_ID,SHIP_FIS_NO,SHIP_STAGE FROM SHIP_RESULT WHERE SHIP_FIS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.head#"><!--- SHIP_RESULT_ID = #attributes.ship_result_id# --->
		</cfquery>
		<cfset attributes.ship_result_id = get_process.ship_result_id>
		<!--- tekli sevkiyatsa --->
		<cfif attributes.multi_packet_ship eq 0>
			<cfset action_id = attributes.ship_result_id>
			<!--- Eger irsaliye ise --->
			<cfif attributes.is_type neq 2>
				<!--- siparis iliskisi silinir --->
				<cfquery name="GET_SHIP_RESULT_ROW" datasource="#DSN2#">
					SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#"> AND SHIP_ID IS NOT NULL
				</cfquery>
				<cfif get_ship_result_row.recordcount>
					<cfquery name="UPD_ORDERS" datasource="#DSN2#">
						UPDATE #dsn3_alias#.ORDERS SET IS_DISPATCH = 0 WHERE ORDER_ID IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND SHIP_ID IN (#valuelist(get_ship_result_row.ship_id)#))
					</cfquery>
				</cfif>

				<!--- irsaliye iliskisi silinir --->
				<cfquery name="UPD_SHIP" datasource="#DSN2#">
					UPDATE SHIP SET IS_DISPATCH = 0 WHERE SHIP_ID IN(SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#">)
				</cfquery>
			<cfelse>
				<cfquery name="UPD_ORDERS" datasource="#DSN2#">
					UPDATE #dsn3_alias#.ORDERS SET IS_DISPATCH = 0 WHERE ORDER_ID IN(SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#">)
				</cfquery>	
			</cfif>			
			<cfquery name="DEL_SHIP_RESULT" datasource="#DSN2#">
				DELETE FROM SHIP_RESULT WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#">
			</cfquery>
			<!--- Urun Iliskileri --->
			<cfquery name="DEL_SHIP_RESULT_PACKAGE_PRODUCT" datasource="#DSN2#">
				DELETE FROM SHIP_RESULT_PACKAGE_PRODUCT WHERE SHIP_ID = (SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_result_id#">)
			</cfquery>			
			<cfquery name="DEL_SHIP_RESULT_ROW" datasource="#DSN2#">
				DELETE FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#">
			</cfquery>			
			<cfquery name="DEL_SHIP_RESULT_PACKAGE" datasource="#DSN2#">
				DELETE FROM SHIP_RESULT_PACKAGE WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#">
			</cfquery>
		<!--- coklu sevkiyatsa --->
		<cfelse>
			<cfquery name="GET_SHIP_RESULT" datasource="#DSN2#">
				SELECT SHIP_RESULT_ID FROM SHIP_RESULT WHERE MAIN_SHIP_FIS_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.main_ship_fis_no#">
			</cfquery>

			<!--- irsaliye iliskisi silinir --->
			<cfquery name="UPD_SHIP" datasource="#DSN2#">
				UPDATE SHIP SET IS_DISPATCH = 0 WHERE SHIP_ID IN(SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID IN(#valuelist(get_ship_result.ship_result_id)#))
			</cfquery>
	
			<!--- siparis iliskisi silinir --->
			<cfquery name="GET_SHIP_RESULT_ROW" datasource="#DSN2#">
				SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID IN (#valuelist(get_ship_result.ship_result_id)#) AND SHIP_ID IS NOT NULL
			</cfquery>
			<cfif get_ship_result_row.recordcount>
				<cfquery name="UPD_ORDERS" datasource="#DSN2#">
					UPDATE #dsn3_alias#.ORDERS SET IS_DISPATCH = 0 WHERE ORDER_ID IN (SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND SHIP_ID IN (#valuelist(get_ship_result_row.ship_id)#))
				</cfquery>
			</cfif>

			<!--- ilk satir otomatik atanir. --->
			<cfset action_id = get_ship_result.ship_result_id[1]>
			<cfoutput query="get_ship_result">
				<cfquery name="DEL_SHIP_RESULT" datasource="#DSN2#">
					DELETE FROM SHIP_RESULT WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_result_id#">
				</cfquery>
				<!--- Urun Iliskileri --->
				<cfquery name="DEL_SHIP_RESULT_PACKAGE_PRODUCT" datasource="#DSN2#">
					DELETE FROM SHIP_RESULT_PACKAGE_PRODUCT WHERE SHIP_ID IN (SELECT SHIP_ID FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_result_id#">)
				</cfquery>
				<cfquery name="DEL_SHIP_RESULT_ROW" datasource="#DSN2#">
					DELETE FROM SHIP_RESULT_ROW WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_result_id#">
				</cfquery>
				<cfquery name="DEL_SHIP_RESULT_PACKAGE" datasource="#DSN2#">
					DELETE FROM SHIP_RESULT_PACKAGE WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_result_id#">
				</cfquery>
				<cfquery name="DEL_SHIP_RESULT_COMPONENT" datasource="#DSN2#"><!--- Satirdaki urunun bilesenleri --->
					DELETE FROM SHIP_RESULT_ROW_COMPONENT WHERE SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_result_id#">
				</cfquery>
			</cfoutput>	
			<cf_add_log log_type="-1" action_id="#action_id#" action_name="#attributes.head#" paper_no="#get_process.ship_fis_no#" process_stage="#get_process.ship_stage#" data_source="#dsn2#">
		</cfif>	
	</cftransaction>
</cflock>
<cfif attributes.multi_packet_ship eq 0>
	<script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=stock.list_packetship</cfoutput>";
    </script>
<cfelse>
	<script type="text/javascript">
    	window.location.href="<cfoutput>#request.self#?fuseaction=stock.list_multi_packetship</cfoutput>";
    </script>
</cfif>