<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfif not isdefined("butceci")>
			<cfinclude template="../../objects/functions/get_butceci.cfm">
		</cfif>
		<cfif not isdefined("carici")>
			<cfinclude template="../../objects/functions/get_carici.cfm">
		</cfif>
		<cfif not isdefined("muhasebeci")>
			<cfinclude template="../../objects/functions/get_muhasebeci.cfm">
		</cfif>
		<cfif not isdefined("get_consumer_period")>
			<cfinclude template="../../objects/functions/get_user_accounts.cfm">
		</cfif>
		<cfif not isdefined("basket_kur_ekle")>
			<cfinclude template="../../objects/functions/get_basket_money_js.cfm">
		</cfif>
		<cfquery name="UPD_ORDER" datasource="#DSN2#">
			UPDATE
				#dsn3_alias#.ORDERS
			SET
				ORDER_STATUS = 0,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.remote_addr#',
				CANCEL_DATE = #now()#,
			<cfif isdefined("session.ww.userid")>
				CANCEL_CON = #session.ww.userid#
			<cfelseif  isdefined("session.pp.userid")>
				CANCEL_PAR = #session.pp.userid#
			<cfelseif isdefined("session.ep.userid")>
				CANCEL_EMP = #session.ep.userid#
			</cfif>
			WHERE
				ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
		</cfquery>
		<cfquery name="UPD_ORDER_DEMANDS" datasource="#DSN2#">
			UPDATE #dsn3_alias#.ORDER_DEMANDS SET DEMAND_STATUS = 0 WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
		</cfquery>	
		<cfquery name="GET_ORDER_ROW" datasource="#DSN2#">
			SELECT QUANTITY,ORDER_ROW_ID FROM #dsn3_alias#.ORDER_ROW WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#">
		</cfquery>
		<cfoutput query="get_order_row">
			<cfquery name="GET_DEMAND" datasource="#DSN2#">
				SELECT DEMAND_ID FROM #dsn3_alias#.ORDER_DEMANDS_ROW WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row.order_row_id#">
			</cfquery>
			<cfif get_demand.recordcount>
				<cfquery name="UPD_DEMAND" datasource="#DSN2#">
					UPDATE #dsn3_alias#.ORDER_DEMANDS SET GIVEN_AMOUNT = GIVEN_AMOUNT - #get_order_row.quantity# WHERE DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_demand.demand_id#">
				</cfquery>
				<cfquery name="DEL_DEMAND_ROW" datasource="#DSN2#">
					DELETE FROM #dsn3_alias#.ORDER_DEMANDS_ROW WHERE ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row.order_row_id#">
				</cfquery>
			</cfif>
		</cfoutput>
		<cfquery name="GET_INVOICE_DET" datasource="#DSN2#">
			SELECT INVOICE_ID FROM #dsn3_alias#.ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
		</cfquery>
		<cfif get_invoice_det.recordcount>
			<cfquery name="GET_PROCESS_TYPE_INFO" datasource="#DSN2#">
				SELECT INVOICE_CAT FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_det.invoice_id#">
			</cfquery>
			<cfset form.invoice_id = get_invoice_det.invoice_id>
			<cfset form.old_process_type = get_process_type_info.invoice_cat>
			<cfset get_number.cash_id = ''>
			<cfquery name="GET_SHIP_ID" datasource="#DSN2#"><!--- faturanın kendi irsaliyesi varsa alır ve faturanın kendi irsaliyesi faturayla aynı dönemde olur.--->
				SELECT 
					INV_S.SHIP_ID,
					INV_S.INVOICE_NUMBER,
					INV_S.SHIP_NUMBER,
					INV_S.IS_WITH_SHIP,
					S.SHIP_TYPE
				FROM 
					INVOICE_SHIPS INV_S,
					SHIP S
				WHERE 
					INV_S.SHIP_ID=S.SHIP_ID AND
					INV_S.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.invoice_id#"> AND
					INV_S.IS_WITH_SHIP=1 
			</cfquery>
			<cfset from_order_info = 1>
			<cfinclude template="../../invoice/query/update_invoice_iptal.cfm">
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=objects2.view_list_order<cfif not isdefined("session.ep")>&zone=1</cfif>&form_submitted=1</cfoutput>';
</script>
