<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="stock">
<cfparam name="attributes.row_number" default="1">
<cfparam name="attributes.department_id" default="">
<!---?! bu açıklama yanlış sanki?! attributes.dept_loc_info_stock_ parametresi stok liste sayfasının xml inden geliyor. Eğer 1 gelirse stok bilgileri depoya göre listeleniyor --->
<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
	<cfsavecontent variable="td_class">onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';"</cfsavecontent>
	<cfquery name="GET_ORDER_RESERVE" datasource="#DSN3#">
		SELECT
			SUM(RESERVE_STOCK_OUT) AS SALES_REZERVE
		FROM
			ORDER_ROW_RESERVED
		WHERE  
			STOCK_ID = #attributes.sid# AND 
			ORDER_ID IN(#attributes.order_id#)
	</cfquery>
<cfelse>
	<cfsavecontent variable="td_class"></cfsavecontent>    
</cfif>
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		SL.COMMENT,
		SL.LOCATION_ID,
		D.DEPARTMENT_HEAD + ' - ' + SL.COMMENT AS LOCATION_NAME
	FROM
		BRANCH B,
		DEPARTMENT D,
        STOCKS_LOCATION SL
	WHERE
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		B.BRANCH_ID = D.BRANCH_ID AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.DEPARTMENT_STATUS = 1 AND
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	ORDER BY
		LOCATION_NAME
</cfquery>
<cfquery name="product_unit" datasource="#DSN3#">
	SELECT UNIT_ID,ADD_UNIT,MAIN_UNIT_ID,MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND PRODUCT_UNIT_STATUS = 1 ORDER BY ADD_UNIT
</cfquery>
<cfparam name="attributes.unit_id" default="#product_unit.main_unit_id#">
<cfif isdefined('attributes.ajax')>
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
		<cfif isdefined("attributes.sid")>
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
</cfif>
<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="stock">
<cfparam name="attributes.row_number" default="1">
<cfparam name="attributes.department_id" default="">
<!---?! bu açıklama yanlış sanki?! attributes.dept_loc_info_stock_ parametresi stok liste sayfasının xml inden geliyor. Eğer 1 gelirse stok bilgileri depoya göre listeleniyor --->
<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
	<cfsavecontent variable="td_class">onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';"</cfsavecontent>
	<cfquery name="GET_ORDER_RESERVE" datasource="#DSN3#">
		SELECT
			SUM(RESERVE_STOCK_OUT) AS SALES_REZERVE
		FROM
			ORDER_ROW_RESERVED
		WHERE  
			STOCK_ID = #attributes.sid# AND 
			ORDER_ID IN(#attributes.order_id#)
	</cfquery>
<cfelse>
	<cfsavecontent variable="td_class"></cfsavecontent>    
</cfif>
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_ID,
		D.DEPARTMENT_HEAD,
		SL.COMMENT,
		SL.LOCATION_ID,
		D.DEPARTMENT_HEAD + ' - ' + SL.COMMENT AS LOCATION_NAME
	FROM
		BRANCH B,
		DEPARTMENT D,
        STOCKS_LOCATION SL
	WHERE
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		B.BRANCH_ID = D.BRANCH_ID AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.DEPARTMENT_STATUS = 1 AND
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	ORDER BY
		LOCATION_NAME
</cfquery>
<cfquery name="product_unit" datasource="#DSN3#">
	SELECT UNIT_ID,ADD_UNIT,MAIN_UNIT_ID,MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND PRODUCT_UNIT_STATUS = 1 ORDER BY ADD_UNIT
</cfquery>
<cfparam name="attributes.unit_id" default="#product_unit.main_unit_id#">
<cfif isdefined('attributes.ajax')>
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
		<cfif isdefined("attributes.sid")>
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
</cfif>

<cfif #attributes.fuseaction# eq "stock.list_stock">

	<cf_box_elements>
	<div  class="col col-12">
		<cfif not isdefined('attributes.ajax')>
			<div class="form-group" id="item-SELECT_ITEMS">
				<div class="col col-2 ">
					<label><cf_get_lang dictionary_id='57636.Birim'></label>
				</div>
				<div class="col col-5 ">
					<select name="unit_id" id="unit_id" onchange="get_loc_stock();" style="width:80px;">
							<cfoutput query="product_unit">
								<option value="#unit_id#-#multiplier#" <cfif unit_id eq attributes.unit_id>selected</cfif>>#add_unit#</option>
							</cfoutput>
					</select>
   				 </div>
				<div class="col col-5 ">
					<select name="department_id" id="department_id" onchange="get_loc_stock();" style="width:140px;">
						<option value=""><cf_get_lang dictionary_id='58763.Depo'></option>
						<cfoutput query="get_department">
							<option value="#department_id#-#location_id#">#location_name#</option>
						</cfoutput>
					</select>
   				 </div>
				<div class="col col-6">
				 </div>
			</div>
		</cfif>
	</div>
<div class="col-6" style="margin-top:10px;">
		<cfif isdefined('attributes.ajax')>
			<div class="form-group" id="item-GERCEK_STOK" style="height:24px;">
				<div class="col col-6 col-xs-12">
					<cf_get_lang dictionary_id='58120.Gerçek Stok'>
				</div>
				<div style="text-align:right; font-weight:bold;" class="col col-4 col-xs-12">
					<cfoutput>#AmountFormat(wrk_round(product_stock))# </cfoutput>
				</div>
				<div  style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#" class="col col-2 col-xs-12">
				</div>
			</div>
			<div class="form-group" id="item-SATILABILIR_STOK" style="height:24px;">
				 <cfinclude template="../../stock/query/get_stock_reserved.cfm">
				 <cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock) and scrap_location_total_stock.total_scrap_stock gt 0>
                                <cfset product_stock = product_stock - scrap_location_total_stock.total_scrap_stock>
                </cfif>
				<cfif get_stock_reserved.recordcount and len(get_stock_reserved.artan)>
                                <cfset product_stock = product_stock + get_stock_reserved.artan>
                </cfif>
                <cfif len(location_based_total_stock.total_location_stock)>
            					<cfset product_stock = product_stock - location_based_total_stock.total_location_stock>
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
                <cfif SCRAP_NOSALE_LOCATION_TOTAL_STOCK.recordcount and len(SCRAP_NOSALE_LOCATION_TOTAL_STOCK.TOTAL_LOCATION_STOCK)><!---hem hurda hemde satış yapılamaz lokasyonlar için kontrol--->
                        		<cfset product_stock = product_stock + SCRAP_NOSALE_LOCATION_TOTAL_STOCK.TOTAL_LOCATION_STOCK>
            	</cfif>

				<label class="col col-6 col-xs-12">
					<cf_get_lang dictionary_id='45241.Satılabilir Stok'>
				</label>
				<label style="text-align:right; font-weight:bold;" nowrap="nowrap" class="col col-4 col-xs-12">
					<cfoutput>#AmountFormat(wrk_round(product_stock))# </cfoutput>
				</label>
				<label style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#" class="col col-2 col-xs-12">
				</label>
			</div>

			<div class="form-group" id="item-HURDA_DEPO" style="height:24px;">
				<label class="col col-6 col-xs-12">
					<cf_get_lang dictionary_id='45413.Hurda Depo'><!--- eski hali hurdalarıda dahil ediyor yenileri ise etmiyor,dolayısı ile eski hali - yeni hali bize hurda miktarını veriyor! --->
				</label>
				<label style="text-align:right; font-weight:bold;" class="col col-4 col-xs-12">
					<cfoutput><cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock)>#AmountFormat(scrap_location_total_stock.total_scrap_stock)#</cfif></cfoutput>
				</label>
				<label id="_stock_detail_popup_#attributes.row_number#" class="col col-2 col-xs-12">
				</label>
			</div>

			<div class="form-group" id="item-ALINAN_SIPARIS_REZERVE" style="height:24px;">
				<label class="col col-6 col-xs-12">
					<cf_get_lang dictionary_id='45242.Alınan Sipariş Rezerve'>
				</label>
				<label style="text-align:right; font-weight:bold;" class="col col-4 col-xs-12">
					<cfoutput><cfif len(get_stock_reserved.azalan)>#AmountFormat(get_stock_reserved.azalan)#</cfif></cfoutput>
				</label>
				<label style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#" class="col col-2 col-xs-12">
				<cfif len(get_stock_reserved.azalan) and get_stock_reserved.azalan neq 0><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_orders&taken=1&pid=#attributes.pid#</cfoutput>');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>"></i></a></cfif>
				</label>
			</div>
			<cfif isdefined('attributes.ajax')>
                <cfif isdefined("attributes.amount")>
					<div class="form-group" id="item-SIPARIS_TALEBI" style="height:24px;">
						<label class="col col-6 col-xs-12">
							<cf_get_lang dictionary_id='58046.Sipariş Talebi'>
						</label>
						<label style="text-align:right; font-weight:bold;" class="col col-4 col-xs-12">
							<cfoutput>#AmountFormat(attributes.amount)#</cfoutput>
						</label>
						<label style="text-align:right;"id="_stock_detail_popup_#attributes.row_number#" class="col col-2 col-xs-12">
						</label>
					</div>
                 </cfif>
            </cfif>
			<div class="form-group" id="item-VERILEN_SIPARIS_BEKLEME" style="height:24px;">
				<label class="col col-6 col-xs-12">
					<cf_get_lang dictionary_id='45243.Verilen Sipariş Bekleme'>
				</label>
				<label style="text-align:right; font-weight:bold;" class="col col-4 col-xs-12">
					<cfoutput><cfif len(get_stock_reserved.artan)>#AmountFormat(get_stock_reserved.artan)#</cfif></cfoutput>
				</label>
				<label style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#" class="col col-2 col-xs-12">
				<cfif len(get_stock_reserved.artan) and get_stock_reserved.artan neq 0><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#attributes.pid#&nosale_order_location=0</cfoutput>');"><i class="fa fa-truck"  title="<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>"></i></a></cfif>
				</label>
			</div>
			<div class="form-group" id="item-URETIM_EMRI_REZERVE" style="height:24px;">
				<label class="col col-6 col-xs-12">
					<cf_get_lang dictionary_id='45388.Üretim Emri'>/<cf_get_lang dictionary_id='29750.Rezerve'>
				</label>
				<label style="text-align:right; font-weight:bold;" class="col col-4 col-xs-12">
					<cfoutput><cfif len(get_prod_reserved.azalan)>#AmountFormat(get_prod_reserved.azalan)#</cfif></cfoutput>
				</label>
				<label style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#" class="col col-2 col-xs-12">
					<cfif len(get_prod_reserved.azalan)><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_production_orders&type=2&pid=#attributes.pid#</cfoutput>');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45573.Rezerve Üretim Emirleri Detayı'>"></i></a></cfif>
				</label>
			</div>
			<div class="form-group" id="item-URETIM_EMRI_BEKLENEN" style="height:24px;">
				<label class="col col-6 col-xs-12">
					<cf_get_lang dictionary_id='45388.Üretim Emri'>/<cf_get_lang dictionary_id='58119.Beklenen'>
				</label>
				<label style="text-align:right; font-weight:bold;" class="col col-4 col-xs-12">
					<cfoutput><cfif len(get_prod_reserved.artan)>#AmountFormat(get_prod_reserved.artan)#</cfif></cfoutput>
				</label>
				<label  style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#" class="col col-2 col-xs-12">
					<cfif len(get_prod_reserved.artan)><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_production_orders&type=1&pid=#attributes.pid#</cfoutput>');"><i class="fa fa-truck"  title="<cf_get_lang dictionary_id='45572.Beklenen Üretim Emirleri Detayı'>"></i></a></cfif>
				</label>
			</div>
			<div class="form-group" id="item-DEPOLARARASI_SEVK" style="height:24px;">
						<label class="col col-6 col-xs-12">
							<cf_get_lang dictionary_id='45377.Depolararası Sevk'>-<cf_get_lang dictionary_id='29588.İthal Mal Girişi'>
						</label>
						<cfquery name="GET_SEVK" datasource="#DSN2#">
                                    SELECT 
                                        SUM(STOCK_OUT-STOCK_IN) MIKTAR 
                                    FROM 
                                        STOCKS_ROW 
                                    WHERE
                                        PRODUCT_ID = #attributes.pid# AND
                                        PROCESS_TYPE IN (81,811)
                                </cfquery>
						<label style="text-align:right; font-weight:bold;" class="col col-4 col-xs-12">
							<cfoutput><cfif len(get_sevk.miktar)>#AmountFormat(get_sevk.miktar)#</cfif></cfoutput>
						</label>
						<label style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#" class="col col-2 col-xs-12">
							<cfif len(get_sevk.miktar) and get_sevk.miktar gt 0><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_dispatch_product_import&pid=#attributes.pid#&is_ship_iptal=1</cfoutput>');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45279.İthal Mal Girişi Detayı'>"></i></a></cfif>
						</label>
			</div>

			<cfset no_sale_stock = 0>
			<cfset service_stock = 0>

			<div class="form-group" id="item-SATIS_YAPILAMAZ_LOKASYONLAR" style="height:24px;">
						<label class="col col-6 col-xs-12">
							<cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'>
						</label>
						<label style="text-align:right; font-weight:bold;" class="col col-4 col-xs-12">
							<cfoutput><cfif len(location_based_total_stock.total_location_stock)>#AmountFormat(location_based_total_stock.total_location_stock)#</cfif></cfoutput>
						</label>
						<label style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#" class="col col-2 col-xs-12">
						</label>
			</div>

			<div class="form-group" id="item-SATIS_YAPILAMAZ_LOKASYONLAR_VERILEN_SB" style="height:24px;">
						<label class="col col-6 col-xs-12">
						<cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'> (<cf_get_lang dictionary_id='45243.Verilen Sipariş Bekleme'>)
						</label>
						<label style="text-align:right; font-weight:bold;" class="col col-4 col-xs-12">
							<cfoutput><cfif len(get_nosale_location_reserve_stock.nosale_reserve_stock)>#AmountFormat(get_nosale_location_reserve_stock.nosale_reserve_stock)#</cfif></cfoutput>
						</label>
						<label style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#" class="col col-2 col-xs-12">
						<cfif len(get_nosale_location_reserve_stock.nosale_reserve_stock) and get_nosale_location_reserve_stock.nosale_reserve_stock neq 0><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#attributes.pid#&nosale_order_location=1</cfoutput>');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'>-<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>"></i></a></cfif>
						</label>
			</div>





		<cfelse>	
		<b>
		<div  class="col col-12 form-group"  style="height:24px; border-bottom-style: groove;  border-width: thin;" id="item-GERCEK_STOK">
			<label ><cf_get_lang dictionary_id='58120.Gerçek Stok'></label>
		</div>
		
		<div class="col col-12 form-group"   style="height:24px; border-bottom-style: groove;  border-width: thin;" id="item-SATILABILIR_STOK">
				<div ><cf_get_lang dictionary_id='45241.Satılabilir Stok'></div>
		</div>
		<div class="col col-12 form-group"   style="height:24px; border-bottom-style: groove;  border-width: thin;" id="item-HURDA_DEPO">
				<div ><cf_get_lang dictionary_id='45413.Hurda Depo'></div>
		</div>
		<div class="col col-12 form-group"    style="height:24px; border-bottom-style: groove;  border-width: thin;" id="item-ALINAN_SIPARIS_REZERVE">
				<div ><cf_get_lang dictionary_id='45242.Alınan Sipariş Rezerve'></div>
		</div>
		<cfif isdefined('attributes.ajax')>
								<cfif isdefined("attributes.amount")>
								<div class="col col-12"   style="height:24px; border-bottom-style: groove;  border-width: thin;" id="item-SIPARIS_TALEBI">
									<div ><cf_get_lang dictionary_id='58046.Sipariş Talebi'></div>
								</div>
								</cfif>
		</cfif>
		<div class="col col-12 form-group"   style="height:24px; border-bottom-style: groove;  border-width: thin;" id="item-VERILEN_SIPARIS_BEKLEME">
				<div ><cf_get_lang dictionary_id='45243.Verilen Sipariş Bekleme'></div>
		</div>
		<div class="col col-12 form-group"   style="height:24px; border-bottom-style: groove;  border-width: thin;" id="item-URETIM_EMIRLERI_REZERVE">
				<div ><cf_get_lang dictionary_id='45388.Üretim Emri'>/<cf_get_lang dictionary_id='29750.Rezerve'></div>
		</div>

		<div class="col col-12 form-group"   style="height:24px; border-bottom-style: groove;  border-width: thin;" id="item-URETIM_EMRI_BEKLENEN">
				<div ><cf_get_lang dictionary_id='45388.Üretim Emri'>/<cf_get_lang dictionary_id='58119.Beklenen'></div>
		</div>
		<div class="col col-12 form-group"   style="height:24px; border-bottom-style: groove;  border-width: thin;" id="item-DEPOLAR_ARASI_SEVK">
				<div ><cf_get_lang dictionary_id='45377.Depolararası Sevk'>-<cf_get_lang dictionary_id='29588.İthal Mal Girişi'></div>
		</div>
		<div class="col col-12 form-group"    style="height:24px; border-bottom-style: groove;  border-width: thin;" id="item-SATIS_YAPILMAZ_LOKASYONLAR">
				<div ><cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'></div>
		</div>
		<div class="col col-12 form-group"   style="height:24px; border-bottom-style: groove;  border-width: thin;" id="item-SATIS_YAPILMAZ_LOKASYONLAR_VERILEN_SB">
				<div ><cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'> (<cf_get_lang dictionary_id='45243.Verilen Sipariş Bekleme'>)</div>
		</div>
		</div>
	</b>
</cfif>
<cfif not isdefined('attributes.ajax')>
				<div class="col-3" style="margin-top:10px;"><div id="stock_info"></div></div>
				<div class="col-3" style="margin-top:10px;"><div id="stock_department_info"></div></div>
			</cfif>
</cf_box_elements>
<cfelse>
	<cfset row_ = 0>
	<cfif isdefined("attributes.crtrow")>
		<cfset attributes.crtrow = attributes.crtrow>
	<cfelseif isdefined("attributes.row_number")>
		<cfset attributes.crtrow = attributes.row_number>
	</cfif>
	<cfif isdefined('attributes.ajax')>
		<cfsavecontent  variable="variable"><cf_get_lang dictionary_id ='45567.Stok Detay'>
		</cfsavecontent>
		<cf_seperator title="#variable#" id="stock_detail#attributes.crtrow#">
	</cfif>
	<cf_flat_list id="stock_detail#attributes.crtrow#">
		<cfif not isdefined('attributes.ajax')>
			<tr #td_class#>
				<cfset row_ = row_ + 1>
				<cfdump var ="#row_#">
				
				<td colspan="3">
					<select name="unit_id" id="unit_id" onchange="get_loc_stock();" style="width:80px;">
						<cfoutput query="product_unit">
							<option value="#unit_id#-#multiplier#" <cfif unit_id eq attributes.unit_id>selected</cfif>>#add_unit#</option>
						</cfoutput>
					</select>
					<select name="department_id" id="department_id" onchange="get_loc_stock();" style="width:140px;">
						<option value=""><cf_get_lang dictionary_id='58763.Depo'></option>
						<cfoutput query="get_department">
							<option value="#department_id#-#location_id#">#location_name#</option>
						</cfoutput>
					</select>
				</td>
			</tr>
		</cfif>
		<tr>
			<td>
				<cfif isdefined('attributes.ajax')>
					<table class="ajax_list">
                        <cfoutput>
                        <tr style="height:24px;" #td_class#>
                            <td><cf_get_lang dictionary_id='58120.Gerçek Stok'></td>
                            <td style="text-align:right; font-weight:bold;">#AmountFormat(wrk_round(product_stock))#</td>
                            <td style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"></td>
                        </tr>
                        <tr style="height:24px;" #td_class#>
                            <cfinclude template="../../stock/query/get_stock_reserved.cfm">
                            <cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock) and scrap_location_total_stock.total_scrap_stock gt 0>
                                <cfset product_stock = product_stock - scrap_location_total_stock.total_scrap_stock>
                            </cfif>
                            <cfif get_stock_reserved.recordcount and len(get_stock_reserved.artan)>
                                <cfset product_stock = product_stock + get_stock_reserved.artan>
                            </cfif>
							<!--- 522. satırda aynı işlemi yapıyor
                              <cfif len(location_based_total_stock.total_location_stock)>
            						<cfset product_stock = product_stock - location_based_total_stock.total_location_stock>
           					 </cfif> --->
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
                            <cfif SCRAP_NOSALE_LOCATION_TOTAL_STOCK.recordcount and len(SCRAP_NOSALE_LOCATION_TOTAL_STOCK.TOTAL_LOCATION_STOCK)><!---hem hurda hemde satış yapılamaz lokasyonlar için kontrol--->
                            	<cfset product_stock = product_stock + SCRAP_NOSALE_LOCATION_TOTAL_STOCK.TOTAL_LOCATION_STOCK>
                            </cfif>
                            <td><cf_get_lang dictionary_id='45241.Satılabilir Stok'></td>
                            <td style="text-align:right; font-weight:bold;" nowrap="nowrap">#AmountFormat(product_stock)#</td><!--- eski hali --->
                            <td style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"></td>
                        </tr>
                        <tr style="height:24px;" #td_class#>
                            <td><cf_get_lang dictionary_id='45413.Hurda Depo'></td><!--- eski hali hurdalarıda dahil ediyor yenileri ise etmiyor,dolayısı ile eski hali - yeni hali bize hurda miktarını veriyor! --->
                            <td style="text-align:right; font-weight:bold;"><cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock)>#AmountFormat(scrap_location_total_stock.total_scrap_stock)#</cfif></td>
                            <td id="_stock_detail_popup_#attributes.row_number#"></td>
                        </tr>
                        <tr style="height:24px;" #td_class#>
                            <td><cf_get_lang dictionary_id='45242.Alınan Sipariş Rezerve'></td>
                            <td style="text-align:right; font-weight:bold;"> <cfif len(get_stock_reserved.azalan)>#AmountFormat(get_stock_reserved.azalan)#</cfif></td>
                            <td style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_stock_reserved.azalan) and get_stock_reserved.azalan neq 0><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_orders&taken=1&pid=#attributes.pid#');"><i class="fa fa-truck"  title="<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>"></i></a></cfif></td>
                        </tr>
                        <cfif isdefined('attributes.ajax')>
                            <cfif isdefined("attributes.amount")>
                            <tr style="height:24px;" #td_class#>
                                <td width="100"><cf_get_lang dictionary_id='58046.Sipariş Talebi'></td>
                                <td style="text-align:right; font-weight:bold;">#AmountFormat(attributes.amount)#</td>
                                <td style="text-align:right;"id="_stock_detail_popup_#attributes.row_number#"></td>
                            </tr>
                            </cfif>
                        </cfif>
                        <tr style="height:24px;" #td_class#>
                            <td><cf_get_lang dictionary_id='45243.Verilen Sipariş Bekleme'></td>
                            <td style="text-align:right; font-weight:bold;"><cfif len(get_stock_reserved.artan)>#AmountFormat(get_stock_reserved.artan)#</cfif></td>
                            <td style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_stock_reserved.artan) and get_stock_reserved.artan neq 0><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#attributes.pid#&nosale_order_location=0');"><i class="fa fa-truck"  title="<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>"></i></a></cfif></td>
                        </tr>
                        <tr style="height:24px;" #td_class#>
                            <td><cf_get_lang dictionary_id='45388.Üretim Emri'>/<cf_get_lang dictionary_id='29750.Rezerve'></td>
                            <td style="text-align:right; font-weight:bold;"><cfif len(get_prod_reserved.azalan)>#AmountFormat(get_prod_reserved.azalan)#</cfif></td>
                            <td style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_prod_reserved.azalan)><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_production_orders&type=2&pid=#attributes.pid#');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45573.Rezerve Üretim Emirleri Detayı'>"></i></a></cfif></td>
                        </tr>
                        <tr style="height:24px;" #td_class#>
                           <td><cf_get_lang dictionary_id='45388.Üretim Emri'>/<cf_get_lang dictionary_id='58119.Beklenen'></td>
                           <td style="text-align:right; font-weight:bold;"><cfif len(get_prod_reserved.artan)>#AmountFormat(get_prod_reserved.artan)#</cfif></td>
                           <td style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_prod_reserved.artan)><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_production_orders&type=1&pid=#attributes.pid#');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45572.Beklenen Üretim Emirleri Detayı'>"></i></a></cfif></td>
                        </tr>
                        <tr style="height:24px;" #td_class#>
                            <td><cf_get_lang dictionary_id='45377.Depolararası Sevk'>-<cf_get_lang dictionary_id='29588.İthal Mal Girişi'></td>
                                <cfquery name="GET_SEVK" datasource="#DSN2#">
                                    SELECT 
                                        SUM(STOCK_OUT-STOCK_IN) MIKTAR 
                                    FROM 
                                        STOCKS_ROW 
                                    WHERE
                                        PRODUCT_ID = #attributes.pid# AND
                                        PROCESS_TYPE IN (81,811)
                                </cfquery>
                            <td style="text-align:right; font-weight:bold;"><cfif len(get_sevk.miktar)>#AmountFormat(get_sevk.miktar)#</cfif></td>
                            <td style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_sevk.miktar) and get_sevk.miktar gt 0><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_dispatch_product_import&pid=#attributes.pid#&is_ship_iptal=1');"><i class="fa fa-truck"  title="<cf_get_lang dictionary_id='45279.İthal Mal Girişi Detayı'>"></i></a></cfif></td>
                        </tr>
                        </cfoutput>
                        <cfset no_sale_stock = 0>
                        <cfset service_stock = 0>
                        <cfoutput>
                            <tr style="height:24px;" #td_class#>
                                <td><cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'></td>
                                <td style="text-align:right; font-weight:bold;"><cfif len(location_based_total_stock.total_location_stock)>#AmountFormat(location_based_total_stock.total_location_stock)#</cfif></td>
                                <td style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"></td>
                            </tr>
                            <tr style="height:30px;" #td_class#>
                                <td><cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'> (<cf_get_lang dictionary_id='45243.Verilen Sipariş Bekleme'>)</td>
                                <td style="text-align:right; font-weight:bold;"><cfif len(get_nosale_location_reserve_stock.nosale_reserve_stock)>#AmountFormat(get_nosale_location_reserve_stock.nosale_reserve_stock)#</cfif></td>
                                <td style="text-align:right;" id="_stock_detail_popup_#attributes.row_number#"><cfif len(get_nosale_location_reserve_stock.nosale_reserve_stock) and get_nosale_location_reserve_stock.nosale_reserve_stock neq 0><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#attributes.pid#&nosale_order_location=1');"><i class="fa fa-truck"  title="<cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'>-<cf_get_lang dictionary_id='45574.Rezerve Siparişler Detayı'>"></i></a></cfif></td>
                            </tr>
                        </cfoutput>
					</table>
				<cfelse>
					<table class="ajax_list">
						<cfoutput>
							<tr #td_class# style="height:24px;">
								<td><cf_get_lang dictionary_id='58120.Gerçek Stok'></td>
							</tr>
							<tr #td_class# style="height:24px;">
								<td><cf_get_lang dictionary_id='45241.Satılabilir Stok'></td>
							</tr>
							<tr #td_class# style="height:24px;">
								<td><cf_get_lang dictionary_id='45413.Hurda Depo'></td><!--- eski hali hurdalarıda dahil ediyor yenileri ise etmiyor,dolayısı ile eski hali - yeni hali bize hurda miktarını veriyor! --->
							</tr>
							<tr #td_class# style="height:24px;">
								<td><cf_get_lang dictionary_id='45242.Alınan Sipariş Rezerve'></td>
							</tr>
							<cfif isdefined('attributes.ajax')>
								<cfif isdefined("attributes.amount")>
								<tr #td_class# style="height:24px;">
									<td width="100"><cf_get_lang dictionary_id='58046.Sipariş Talebi'></td>
								</tr>
								</cfif>
							</cfif>
							<tr #td_class# style="height:24px;">
								<td><cf_get_lang dictionary_id='45243.Verilen Sipariş Bekleme'></td>
							</tr>
							<tr #td_class# style="height:24px;">
								<td><cf_get_lang dictionary_id='45388.Üretim Emri'>/<cf_get_lang dictionary_id='29750.Rezerve'></td>
							</tr>
							<tr #td_class# style="height:24px;">
								<td><cf_get_lang dictionary_id='45388.Üretim Emri'>/<cf_get_lang dictionary_id='58119.Beklenen'></td>
							</tr>
							<tr #td_class# style="height:24px;">
								<td><cf_get_lang dictionary_id='45377.Depolararası Sevk'>-<cf_get_lang dictionary_id='29588.İthal Mal Girişi'></td>
							</tr>
							<tr #td_class# style="height:24px;">
								<td><cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'></td>
							</tr>
							<tr style="height:30px;" #td_class#>
								<td><cf_get_lang dictionary_id='45544.Satış Yapılamaz Lokasyonlar'> (<cf_get_lang dictionary_id='45243.Verilen Sipariş Bekleme'>)</td>
							</tr>
						</cfoutput>
					</table>
				</cfif>
			</td>
			<cfif not isdefined('attributes.ajax')>
				<td><div style="width:200;" id="stock_info"></div></td>
				<td><div style="width:200;" id="stock_department_info"></div></td>
			</cfif>
		</tr>
	</cf_flat_list>
</cfif>	
</cf_get_lang_set>
<cfif isdefined('attributes.ajax')>
	<cfoutput>
		<script type="text/javascript">
			function td_hide(){
				if(document.getElementsByName('_stock_detail_popup_#attributes.row_number#').length > 0){
					for(ti=0;ti<document.getElementsByName('_stock_detail_popup_#attributes.row_number#').length;ti++)
						document.getElementsByName('_stock_detail_popup_#attributes.row_number#')[ti].style.display = 'none';
				}	
				else
					setTimeout('td_hide()',5);
			}
			td_hide();
		</script>
	</cfoutput>
</cfif>
<cfif not isdefined('attributes.ajax')>
	<script type="text/javascript">
		get_loc_stock();
		function get_loc_stock()
		{
			var dept_id = list_getat(document.getElementById('department_id').value,1,'-');
			var loc_id = list_getat(document.getElementById('department_id').value,2,'-');
			var unit_id_ = list_getat(document.getElementById('unit_id').value,1,'-');
			var multiplier_ = list_getat(document.getElementById('unit_id').value,2,'-');
			<cfif isdefined("attributes.sid") and len(attributes.sid)>
				var sid = <cfoutput>#attributes.sid#</cfoutput>;
			<cfelse>
				var sid = '';
			</cfif>
			if(document.getElementById('unit_id').value != '')
			{
				goster(stock_info);
				var send_address = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_stock_info_ajax&pid=#attributes.pid#&td_class=#td_class#<cfif isdefined("attributes.ajax")>&ajax=#attributes.ajax#</cfif><cfif isdefined("attributes.amount")>&amount=#attributes.amount#</cfif></cfoutput>&sid="+sid+"&multiplier="+multiplier_+"&unit_id=";
				send_address += unit_id;
				AjaxPageLoad(send_address,'stock_info');
			}
			else
			{
				gizle(stock_info);
			}
			if(document.getElementById('department_id').value != '')
			{
				goster(stock_department_info);
				var send_address = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_stock_dept_info_ajax&pid=#attributes.pid#&td_class=#td_class#<cfif isdefined("attributes.ajax")>&ajax=#attributes.ajax#</cfif><cfif isdefined("attributes.amount")>&amount=#attributes.amount#</cfif></cfoutput>&sid="+sid+"&multiplier="+multiplier_+"&unit_id="+unit_id_+"&location_id="+loc_id+"&department_id=";
				send_address += dept_id;
				AjaxPageLoad(send_address,'stock_department_info');
			}
			else
			{
				gizle(stock_department_info);
			}
		}
	</script>		
</cfif>
