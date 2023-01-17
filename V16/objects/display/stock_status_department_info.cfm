<!--- modified by halimegul 20120717 - depo filtresine göre ürün stok bilgisinin getirilmesi --->
<cfsetting showdebugoutput="no">
<cfquery name="PRODUCT_TOTAL_STOCK" datasource="#DSN2#">
	SELECT 
		SUM(PRODUCT_STOCK) AS PRODUCT_TOTAL_STOCK,
		PRODUCT_ID
		<cfif isdefined("attributes.sid") and len(attributes.sid)>
			,STOCK_ID
		</cfif>
	FROM
		GET_STOCK_LOCATION_TOTAL
	WHERE
		<cfif isdefined("attributes.sid") and len(attributes.sid)>
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#"> AND
		</cfif>
		STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> AND
		STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"> AND
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	GROUP BY
		<cfif isdefined("attributes.sid") and len(attributes.sid)>
			STOCK_ID,
		</cfif>
		PRODUCT_ID
</cfquery>
<cfquery name="GET_STOCK_STRATEGY" datasource="#DSN3#">
	SELECT 
		BLOCK_STOCK_VALUE
	FROM 
		STOCK_STRATEGY 
	WHERE 
	<cfif isdefined("attributes.sid") and len(attributes.sid)>
		STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#">
	<cfelse>
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfif>
		AND BLOCK_STOCK_VALUE IS NOT NULL
		AND BLOCK_STOCK_VALUE > 0
</cfquery>
<cfif get_stock_strategy.recordcount>
	<cfset block_stock = get_stock_strategy.block_stock_value>
<cfelse>
	<cfset block_stock = 0>
</cfif>
<cfif product_total_stock.recordcount and len(product_total_stock.product_total_stock)>
	<cfset product_stock = product_total_stock.product_total_stock>
<cfelse>
	<cfset product_stock = 0>
</cfif>
	<cfoutput>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="width:100px;text-align:right;font-weight:bold;">#AmountFormat(wrk_round(product_stock/attributes.multiplier))#</div>	
			<div class="col col-2" style="width:20px;text-align:right;"></div>	
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<cfinclude template="../../stock/query/get_stock_reserved.cfm">
			<cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock) and scrap_location_total_stock.total_scrap_stock gt 0>
				<cfset product_stock = product_stock - scrap_location_total_stock.total_scrap_stock>
			</cfif>
			<cfif get_stock_reserved.recordcount and len(get_stock_reserved.artan)>
				<cfset product_stock = product_stock + get_stock_reserved.artan>
			</cfif>
			<cfif get_stock_reserved.recordcount and len(get_stock_reserved.azalan)>
				<cfset product_stock = product_stock - get_stock_reserved.azalan>
			</cfif>
			<cfif get_prod_reserved.recordcount>
				<cfif len(get_prod_reserved.azalan)>
					<cfset product_stock = product_stock - get_prod_reserved.azalan>
				</cfif>
				<cfif len(get_prod_reserved.artan)>
					<cfset product_stock = product_stock + get_prod_reserved.artan>
				</cfif>
			</cfif>
            <cfif location_based_total_stock.recordcount and len(location_based_total_stock.total_location_stock)>
				<cfset product_stock = product_stock - location_based_total_stock.total_location_stock>
            </cfif>
			<div class="col col-6" style="text-align:right; font-weight:bold;">#AmountFormat(product_stock/attributes.multiplier)#</div>
			<div class="col col-2" style="width:20px;text-align:right;"></div>
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock)>#AmountFormat(scrap_location_total_stock.total_scrap_stock/attributes.multiplier)#<cfelse>#AmountFormat(0)#</cfif></div>
			<div class="col col-2" style="width:20px;text-align:right;"></div>
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_stock_reserved.azalan)>#AmountFormat(get_stock_reserved.azalan/attributes.multiplier)#<cfelse>#AmountFormat(0)#</cfif></div>
			<div class="col col-2" style="width:20px;text-align:right;"><cfif len(get_stock_reserved.azalan) and get_stock_reserved.azalan neq 0><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_orders&taken=1&pid=#attributes.pid#&dept_id=#attributes.department_id#&loc_id=#attributes.location_id#');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>" border="0"></i></a></cfif></div>
		</div>
		<cfif isdefined('attributes.ajax')>
			<cfif isdefined("attributes.amount")>
			<div class="form-group" style="height:24px; border-bottom-style: groove;  border-width: thin;">
				<div class="col col-6" style="text-align:right; font-weight:bold;">#AmountFormat(attributes.amount/attributes.multiplier)#</td>
				<div class="col col-2" style="width:20px;text-align:right;"></div>
			</div>
			</cfif>
		</cfif>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_stock_reserved.artan)>#AmountFormat(get_stock_reserved.artan/attributes.multiplier)#<cfelse>#AmountFormat(0)#</cfif></div>
			<div class="col col-2" style="width:20px;text-align:right;"><cfif len(get_stock_reserved.artan) and get_stock_reserved.artan neq 0><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#attributes.pid#&nosale_order_location=0&dept_id=#attributes.department_id#&loc_id=#attributes.location_id#');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>" border="0"></i></a></cfif></div>
		</div>
		<div class="form-group" style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_prod_reserved.azalan)>#AmountFormat(get_prod_reserved.azalan/attributes.multiplier)#<cfelse>#AmountFormat(0)#</cfif></div>
			<div class="col col-2" style="width:20px;text-align:right;"><cfif len(get_prod_reserved.azalan)><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_production_orders&type=2&pid=#attributes.pid#&dept_id=#attributes.department_id#&loc_id=#attributes.location_id#');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45573.Rezerve Üretim Emirleri Detayı'>" border="0"></i></a></cfif></div>
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_prod_reserved.artan)>#AmountFormat(get_prod_reserved.artan/attributes.multiplier)#<cfelse>#AmountFormat(0)#</cfif></div>
			<div class="col col-2" style="width:20px;text-align:right;"><cfif len(get_prod_reserved.artan)><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_production_orders&type=1&pid=#attributes.pid#&dept_id=#attributes.department_id#&loc_id=#attributes.location_id#');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45572.Beklenen Üretim Emirleri Detayı'>" border="0"></i></a></cfif></div>
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<cfquery name="GET_SEVK" datasource="#DSN2#">
				SELECT 
					SUM(STOCK_OUT-STOCK_IN) MIKTAR 
				FROM 
					STOCKS_ROW 
				WHERE
					PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
					PROCESS_TYPE IN (81,811) AND
					STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> AND
					STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"> AND
					UPD_ID IN(SELECT SHIP.SHIP_ID FROM SHIP,SHIP_ROW WHERE SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND SHIP_ROW.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID AND (SHIP.IS_DELIVERED = 0 OR SHIP.IS_DELIVERED IS NULL))
			</cfquery>
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_sevk.miktar)>#AmountFormat(get_sevk.miktar/attributes.multiplier)#<cfelse>#AmountFormat(0)#</cfif></div>
			<div class="col col-2" style="width:20px;text-align:right;"><cfif len(get_sevk.miktar)><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_dispatch_product_import&pid=#attributes.pid#&dept_id=#attributes.department_id#&loc_id=#attributes.location_id#&is_ship_iptal=1');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45279.İthal Mal Girişi Detayı'>" border="0"></i></a></cfif></div>
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(location_based_total_stock.total_location_stock)>#AmountFormat(location_based_total_stock.total_location_stock/attributes.multiplier)#<cfelse>#AmountFormat(0)#</cfif></div>
			<div class="col col-2" style="width:20px;text-align:right;"></div>
		</div>
		<div class="form-group"   style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_nosale_location_reserve_stock.nosale_reserve_stock)>#AmountFormat(get_nosale_location_reserve_stock.nosale_reserve_stock/attributes.multiplier)#<cfelse>#AmountFormat(0)#</cfif></div>
			<div class="col col-2" style="width:20px;text-align:right;"><cfif len(get_nosale_location_reserve_stock.nosale_reserve_stock) and get_nosale_location_reserve_stock.nosale_reserve_stock neq 0><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#attributes.pid#&nosale_order_location=1&dept_id=#attributes.department_id#&loc_id=#attributes.location_id#');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'>-<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>" border="0"></i></a></cfif></div>
		</div>
	</cfoutput>
</table>
