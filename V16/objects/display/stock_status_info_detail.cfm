<!--- Ek birime göre filtre eklendiği için ajax yapısında düzenlendi sayfa
	Modified by halime gül 20120926
 --->
<cfsetting showdebugoutput="no">
<cfparam name="attributes.row_number" default="1">
<cfif isdefined('attributes.sid') and len(attributes.sid)>
	<cfquery name="PRODUCT_TOTAL_STOCK" datasource="#DSN2#">
		SELECT 
			SUM(PRODUCT_STOCK) AS PRODUCT_TOTAL_STOCK,
			STOCK_ID,PRODUCT_ID
		FROM
			<cfif isdefined("attributes.dept_loc_info_stock_") and len(attributes.dept_loc_info_stock_)>
				GET_STOCK_LOCATION_TOTAL
			<cfelse>	
				GET_STOCK 
			</cfif>
		WHERE
			STOCK_ID = #attributes.sid#
			<cfif isdefined("attributes.dept_loc_info_stock_") and len(attributes.dept_loc_info_stock_)>
				AND STORE = #listfirst(attributes.dept_loc_info_stock_,'-')#
				<cfif listlen(attributes.dept_loc_info_,'-') eq 2>
					AND STORE_LOCATION = #listlast(attributes.dept_loc_info_stock_,'-')#
				</cfif>
			</cfif>
		GROUP BY
			STOCK_ID,
			PRODUCT_ID
	</cfquery>
<cfelse>
	<cfquery name="PRODUCT_TOTAL_STOCK" datasource="#DSN2#">
		SELECT 
			PRODUCT_TOTAL_STOCK,PRODUCT_ID
		FROM 
			GET_PRODUCT_STOCK 
		WHERE 
		  <cfif isdefined("attributes.pid") and len(attributes.pid)>
			PRODUCT_ID IN (#attributes.pid#)
		  <cfelse>
			PRODUCT_ID IS NULL
		  </cfif>
	</cfquery>
</cfif>
<cfquery name="GET_STOCK_STRATEGY" datasource="#DSN3#">
	SELECT 
		BLOCK_STOCK_VALUE
	FROM 
		STOCK_STRATEGY 
	WHERE 
	<cfif isdefined("attributes.sid") and len(attributes.sid)>
		STOCK_ID = #attributes.sid#
	<cfelse>
		PRODUCT_ID = #attributes.pid#
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
		<div class="form-group" style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="width:100px;text-align:right;font-weight:bold;">#AmountFormat(wrk_round(product_stock/attributes.multiplier))#</div>	
			<div class="col col-2" style="width:20px;text-align:right;" id="_stock_detail_popup_#attributes.row_number#"></div>	
		</div>
		<div class="form-group" style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<cfinclude template="../../stock/query/get_stock_reserved.cfm">
			<cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock) and scrap_location_total_stock.total_scrap_stock gt 0>
				<cfset product_stock = product_stock - scrap_location_total_stock.total_scrap_stock>
			</cfif>
            <cfif len(location_based_total_stock.total_location_stock)>
            	<cfset product_stock = product_stock - location_based_total_stock.total_location_stock>
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
			<cfif SCRAP_NOSALE_LOCATION_TOTAL_STOCK.recordcount and len(SCRAP_NOSALE_LOCATION_TOTAL_STOCK.TOTAL_LOCATION_STOCK)><!---hem hurda hemde satış yapılamaz lokasyonlar için kontrol--->
                <cfset product_stock = product_stock + SCRAP_NOSALE_LOCATION_TOTAL_STOCK.TOTAL_LOCATION_STOCK>
            </cfif>
			<div class="col col-6" style="text-align:right; font-weight:bold;">#AmountFormat(product_stock/attributes.multiplier)#</div><!--- eski hali --->
			<div class="col col-2" style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"></div>
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock)>#AmountFormat(scrap_location_total_stock.total_scrap_stock/attributes.multiplier)#</cfif></div>
			<div class="col col-2" id="_stock_detail_popup_#attributes.row_number#"></div>
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_stock_reserved.azalan)>#AmountFormat(get_stock_reserved.azalan/attributes.multiplier)#</cfif></div>
			<div class="col col-2" style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_stock_reserved.azalan) and get_stock_reserved.azalan neq 0><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_orders&taken=1&pid=#attributes.pid#');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>"></i></a></cfif></div>
		</div>
		<cfif isdefined('attributes.ajax')>
			<cfif isdefined("attributes.amount")>
			<div  class="form-group" style="height:24px; border-bottom-style: groove;  border-width: thin;">
				<div class="col col-6" style="text-align:right; font-weight:bold;">#AmountFormat(attributes.amount/attributes.multiplier)#</div>
				<div class="col col-2" style="text-align:right;"id="_stock_detail_popup_#attributes.row_number#"></div>
			</div>
			</cfif>
		</cfif>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_stock_reserved.artan)>#AmountFormat(get_stock_reserved.artan/attributes.multiplier)#</cfif></div>
			<div class="col col-2" style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_stock_reserved.artan) and get_stock_reserved.artan neq 0><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#attributes.pid#&nosale_order_location=0');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>"></i></a></cfif></div>
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_prod_reserved.azalan)>#AmountFormat(get_prod_reserved.azalan/attributes.multiplier)#</cfif></div>
			<div class="col col-2" style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_prod_reserved.azalan)><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_production_orders&type=2&pid=#attributes.pid#');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45573.Rezerve Üretim Emirleri Detayı'>"></i></a></cfif></div>
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_prod_reserved.artan)>#AmountFormat(get_prod_reserved.artan/attributes.multiplier)#</cfif></div>
			<div class="col col-2" style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_prod_reserved.artan)><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_production_orders&type=1&pid=#attributes.pid#');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45572.Beklenen Üretim Emirleri Detayı'>"></i></a></cfif></div>
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<cfquery name="GET_SEVK" datasource="#DSN2#">
				SELECT 
					SUM(STOCK_OUT-STOCK_IN) MIKTAR 
				FROM 
					STOCKS_ROW 
				WHERE
					PRODUCT_ID = #attributes.pid# AND
					PROCESS_TYPE IN (81,811)
			</cfquery>
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_sevk.miktar)>#AmountFormat(get_sevk.miktar/attributes.multiplier)#</cfif></div>
			<div class="col col-2" style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_sevk.miktar) and get_sevk.miktar gt 0><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_dispatch_product_import&pid=#attributes.pid#&is_ship_iptal=1');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45279.İthal Mal Girişi Detayı'>"></i></a></cfif></div>
		</div>
		<cfset no_sale_stock = 0>
		<cfset service_stock = 0>
		<div class="form-group"   style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(location_based_total_stock.total_location_stock)>#AmountFormat(location_based_total_stock.total_location_stock/attributes.multiplier)#</cfif></div>
			<div class="col col-2" style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"></div>
		</div>
		<div class="form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;">
			<div class="col col-6" style="text-align:right; font-weight:bold;"><cfif len(get_nosale_location_reserve_stock.nosale_reserve_stock)>#AmountFormat(get_nosale_location_reserve_stock.nosale_reserve_stock/attributes.multiplier)#</cfif></div>
			<div class="col col-2" style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_nosale_location_reserve_stock.nosale_reserve_stock) and get_nosale_location_reserve_stock.nosale_reserve_stock neq 0><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#attributes.pid#&nosale_order_location=1');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'>-<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>"></i></a></cfif></div>
		</div>
	</cfoutput>
