<cf_xml_page_edit>
<cfif (isDefined('attributes.sid') and not len(attributes.sid)) and (isDefined('attributes.pid') and not len(attributes.pid))>
    <script type="text/javascript">
        alert("<cf_get_lang dictionary_id ='40069.Lütfen ürün seçiniz.'>");
        window.close();
    </script>
    <cfabort>
</cfif>
<cfif isdefined('attributes.sid') and not isdefined('attributes.pid')><!--- Sadece stock_id geliyorsa --->
    <cfquery name="get_product_id" datasource="#dsn1#">
        SELECT PRODUCT_ID FROM STOCKS WHERE STOCK_ID = #attributes.sid#
    </cfquery>
    <cfif get_product_id.recordcount>
        <cfset attributes.pid = get_product_id.PRODUCT_ID>
        <cfset url.pid = get_product_id.PRODUCT_ID>
    <cfelse>
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id ='46866.Bu Özellikte Bir Ürün Bulunamadı'>");
            window.close();
        </script>
        <cfabort>
    </cfif>
</cfif>
<cfinclude template="../query/get_detail_product.cfm">
<cfif not get_product.recordcount>
	<br/><br/><br/><b><cf_get_lang dictionary_id='33282.Ürün Bulunamadı'>...!!!</b>
	<cfexit method="exittemplate">
</cfif>
<cfinclude template="../query/get_detail_money.cfm">
<cfquery name="GET_PROD_IMAGES" datasource="#DSN3#">
	SELECT 
		PATH, 
	    PATH_SERVER_ID,
		IMAGE_SIZE,
		PRODUCT_IMAGEID,
		PRODUCT_ID 
	FROM 
		PRODUCT_IMAGES 
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.pid#"> 
        <cfif isdefined("url.stock_id") and len(url.stock_id)>
            AND STOCK_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#url.stock_id#,%"> 
        </cfif>
	ORDER BY 
		PRODUCT_IMAGEID DESC
</cfquery>
<cfquery name="GET_MIDDLE_IMAGE" dbtype="query">
	SELECT 
		*
	FROM 
		GET_PROD_IMAGES 
	WHERE 
		IMAGE_SIZE = 1
	ORDER BY 
		PRODUCT_IMAGEID DESC
</cfquery>
<cfquery name="GET_PRICE" datasource="#DSN3#">
	SELECT 
		PRICE,
		MONEY,
		PURCHASESALES
	FROM 
		PRICE_STANDART,
		PRODUCT_UNIT 
	WHERE
		PRODUCT_UNIT.IS_MAIN = 1 AND 
		PRICE_STANDART.PRICESTANDART_STATUS = 1 AND 
		PRICE_STANDART.PRODUCT_ID = #url.pid# AND 
		PRODUCT_UNIT.PRODUCT_ID = #url.pid#
	ORDER BY
		PRICE_STANDART.PURCHASESALES DESC
</cfquery>
<cfif len(get_product.brand_id)>
	<cfquery name="get_brand" datasource="#DSN3#">
		SELECT 
			BRAND_NAME	
		FROM
			PRODUCT_BRANDS
		WHERE
			BRAND_ID = #get_product.brand_id#
	</cfquery>
</cfif>
<cfsavecontent variable="header_"><cfoutput><cf_get_lang dictionary_id='57657.Ürün'>: #get_product.PRODUCT_NAME_#</cfoutput></cfsavecontent>
<cfsavecontent variable="buttons">					
    <cfoutput>
            <cfinclude template="../../product/query/get_product_stock_id.cfm">	
            <li><a href="#request.self#?fuseaction=product.list_product_actions&id=#attributes.pid#&is_from_product=1" target="_blank" title="<cf_get_lang dictionary_id='61273.Ürün Aksiyonları'>" class="font-red-pink"><i class="fa fa-gears"></i></a></li>
            <cfif not listfindnocase(denied_pages,'product.popup_form_add_info_plus')><li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_comp_add_info&product_catid=#get_product.product_catid#&info_id=#attributes.pid#&type_id=-5');" title="<cf_get_lang dictionary_id='32671.Ek Bilgi'>" class="font-red-pink"><i class="fa fa-info-circle"></i></a></li></cfif>
            <cfif get_stock.recordcount>
                <cfif not listfindnocase(denied_pages,'objects.popup_list_related_trees')><li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_related_trees&stock_id=#get_stock.stock_id#');" title="<cf_get_lang dictionary_id='38017.İlişkili Ağaçlar'>" class="font-red-pink"><i class="fa fa-tree"></i></a></li></cfif>
            </cfif>
            <cfif get_module_user(13)>
                <cfif not listfindnocase(denied_pages,'objects.popup_product_property')>
                    <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_property&pid=#url.pid#');" title="<cf_get_lang dictionary_id='58910.Özellikler'>" class="font-red-pink"><i class="fa fa-bars"></i></a></li>
                </cfif>
                <cfif isdefined("attributes.sid")>
                    <cfif not listfindnocase(denied_pages,'stock.popup_list_product_spects')>
                        <li><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=stock.popup_list_product_spects&pid=#attributes.pid#</cfoutput>')" title="<cf_get_lang dictionary_id ='33727.Spec Stokları'>" class="font-red-pink"><i class="fa fa-truck"></i></a></li>
                    </cfif>
                    <cfif not listfindnocase(denied_pages,'stock.detail_store_stock_popup')>
                        <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=stock.detail_store_stock_popup&stock_id=#sid#&product_id=#attributes.pid#')"  title="<cf_get_lang dictionary_id='32884.Lokasyonlara Göre Stoklar'>" class="font-red-pink"><i class="fa fa-cube"></i></a></li>
                    </cfif>
                </cfif>
            </cfif>	
            <cfif not isdefined("attributes.is_store_module")>
                <cfif get_module_user(13)>
                    <cfif not listfindnocase(denied_pages,'stock.detail_stock_popup')>
                        <li><a onclick="openBoxDraggable('#request.self#?fuseaction=stock.detail_stock_popup&pid=#attributes.pid#<cfif isdefined("attributes.sid")>&stock_id=#attributes.sid#</cfif>')" target="_blank" title="<cf_get_lang dictionary_id='58166.Stoklar'>" class="font-red-pink"><i class="fa fa-truck"></i></a></li>
                    </cfif>
                </cfif>
            <cfelse>
                <cfif get_module_user(32)>
                    <cfif not listfindnocase(denied_pages,'stock.detail_stock_popup')>
                        <li><a onclick="openBoxDraggable('#request.self#?fuseaction=stock.detail_stock_popup&pid=#attributes.pid#<cfif isdefined("attributes.sid")>&stock_id=#attributes.sid#</cfif>')" target="_blank" title="<cf_get_lang dictionary_id='58166.Stoklar'>" class="font-red-pink"><i class="fa fa-truck"></i></a></li>
                    </cfif>
                </cfif>
            </cfif>	
            <cfif not listfindnocase(denied_pages,'objects.popup_product_stocks')>
                <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_stocks&pid=#attributes.pid#<cfif isdefined("attributes.sid")>&sid=#attributes.sid#</cfif><cfif isdefined("attributes.is_store_module")>&is_store_module=1</cfif>');" title="<cf_get_lang dictionary_id='32883.Depolara Göre Stoklar'>" class="font-red-pink"><i class="fa fa-archive"></i></a></li>
            </cfif>
            <cfif get_module_user(5)>
                <cfif not listfindnocase(denied_pages,'objects.popup_product_contract')>
                    <li><a onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_std_sale&pid=#attributes.pid#')" title="<cf_get_lang dictionary_id='32994.Satınalma Koşulları'>" class="font-red-pink"><i class="fa fa-handshake-o"></i></a>
                </cfif>
            </cfif>
            <cfif len(get_product.is_karma) and get_product.is_karma eq 1> <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_dsp_karma_koli&pid=#attributes.pid#');" title="<cf_get_lang dictionary_id='34010.Karma Koli'>" class="font-red-pink"><i class="fa fa-square"></i></a></li></cfif>
            <cfif get_module_user(5) and  session.ep.cost_display_valid neq 1>
                <li><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=product.popup_list_product_cost_detail&pid=#attributes.pid#')" title="<cf_get_lang dictionary_id='37292.Maliyet Tarihçesi'>" class="font-red-pink"><i class="fa fa-history"></i></a></li>
            </cfif>
		</cfoutput>
</cfsavecontent>
<div class="col col-12 col-xs-12">
    <cf_box title="#header_#" right_images="#buttons#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <table>
            <tr>
                <td>
                    <cf_flat_list>
                        <tr>
                            <cfoutput>
                            <td width="110"><cf_get_lang dictionary_id='58800.Ürün Kodu'></td>
                            <td width="150">: #get_product.product_code# <cfif get_product.product_status eq 1>(<cf_get_lang dictionary_id='57493.Aktif'>)<cfelse>(<cf_get_lang dictionary_id='57494.Pasif'>)</cfif></td>
                            <td width="110"><cf_get_lang dictionary_id='57486.Kategori'></td>
                            <td width="150">: #get_product.product_cat#</td>
                            </cfoutput>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id='57633.Barkod'></td>
                            <td>: <cfoutput>#get_product.barcod#</cfoutput></td>
                            <td><cf_get_lang dictionary_id='58847.Marka'></td>
                            <td>: <cfif len(get_product.brand_id)><cfoutput>#get_brand.brand_name#</cfoutput></cfif></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id='57634.Üretici Kodu'></td>
                            <td>: <cfoutput>#get_product.MANUFACT_CODE#</cfoutput></td>
                            <td><cfif get_module_user(5)><cf_get_lang dictionary_id='32526.Alış Fiyatı'></cfif></td>
                            <td>
                            <cfif get_module_user(5)>
                                : <cfoutput>#TLFormat(get_price.price[2],xml_round_number)#</cfoutput>
                                <cfoutput query="get_money">
                                <cfif get_money.money is get_price.money[2]>#get_money.money#</cfif>
                                </cfoutput>
                            </cfif>
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id='32538.Raf Ömrü'></td>
                            <td>: <cfoutput>#get_product.SHELF_LIFE# (<cf_get_lang dictionary_id='57490.Gün'>)</cfoutput> </td>
                            <td><cf_get_lang dictionary_id='32534.Std Fiyatı'></td>
                            <td>:
                            <cfoutput>#TLFormat(get_price.price[1],xml_round_number)#</cfoutput>
                            <cfoutput query="get_money">
                                <cfif get_money.money is get_price.money[1]>#get_money.money#</cfif>
                            </cfoutput>
                            </td>
                        </tr>
                        <tr>
                            <td width="70"><cf_get_lang dictionary_id='57544.Sorumlu'></td>
                            <td>: <cfif len(get_product.product_manager)><cfoutput>#GET_EMP_INFO(get_product.product_manager,1,1)#</cfoutput></cfif></td>
                            <td><cf_get_lang no='146.KDV Oranı'></td>
                            <td>:
                                <cf_get_lang dictionary_id='58176.Alış'> :<cfoutput>% #get_product.tax_purchase#</cfoutput>
                                <cf_get_lang dictionary_id='57448.Satış'> :<cfoutput>% #get_product.tax#</cfoutput>				
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id='29412.Seri'></td>
                            <td>: <cfif get_product.IS_SERIAL_NO eq 1><cf_get_lang dictionary_id='32900.Takip Ediliyor'><cfelse><cf_get_lang dictionary_id='32900.Takip Edilmiyor'></cfif></td>
                            <td><cf_get_lang dictionary_id='32512.Envanter'></td>
                            <td>: <cfif get_product.IS_INVENTORY eq 1><cf_get_lang dictionary_id='32924.Dahil'><cfelse> <cf_get_lang dictionary_id='32928.Dahil Değil'></cfif></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id='57448.Satış'></td>
                            <td>: <cfif get_product.IS_SALES eq 1><cf_get_lang dictionary_id='33237.Satılabilir'><cfelse><cf_get_lang dictionary_id='32929.Satılamaz'></cfif></td>
                            <td><cf_get_lang dictionary_id='29745.Tedarik'></td>
                            <td>: <cfif get_product.IS_PURCHASE eq 1><cf_get_lang dictionary_id='32986.Edilebilir'><cfelse> <cf_get_lang dictionary_id='32988.Edilemez'></cfif></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id='29533.Tedarikçi'></td>
                            <td>: 
                                <cfif len(get_product.COMPANY_ID)>
                                    <cfquery name="GET_COMP" datasource="#DSN#">
                                    SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = #GET_PRODUCT.COMPANY_ID#
                                    </cfquery>
                                    <cfoutput>#get_comp.nickname#</cfoutput>
                                </cfif>
                            </td>
                            <td><cf_get_lang dictionary_id='33326.Sıfır Stok'></td>
                            <td>: <cfif get_product.IS_ZERO_STOCK eq 1><cf_get_lang dictionary_id ='33305.Çalışabilir'><cfelse><cf_get_lang dictionary_id ='33906.Çalışamaz'></cfif></td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id='32699.Birimler'></td>
                            <td colspan="3">:
                                <cfquery name="GET_PRODUCT_UNITS" datasource="#DSN3#">
                                    SELECT 
                                        * 
                                    FROM 
                                        PRODUCT_UNIT 
                                    WHERE 
                                        PRODUCT_ID = #attributes.pid# AND 
                                        PRODUCT_UNIT_STATUS = 1
                                </cfquery>
                                <cfoutput query="GET_PRODUCT_UNITS">
                                    <cfif is_main is 1>
                                        <font color="##ff0000">#add_unit# = #MULTIPLIER# x #main_unit#,</font>
                                    <cfelse>
                                        #add_unit# = #MULTIPLIER#  x #main_unit#,
                                    </cfif>                        
                                </cfoutput>
                            </td>
                        </tr>
                        <tr>
                            <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
                            <td colspan="3">:<cfoutput>#get_product.PRODUCT_DETAIL#</cfoutput></td>
                        </tr>
                    </cf_flat_list>
                </td>
                <td>
                    <table>
                        <tr>
                            <td valign="top">
                                <cfif get_middle_image.recordcount>
                                    <cf_get_server_file output_file="product/#get_middle_image.path#" output_server="#get_middle_image.path_server_id#" output_type="0"  image_link="1" image_width="200" image_height="200">
                                <cfelseif get_prod_images.recordcount>
                                    <cf_get_server_file output_file="product/#get_prod_images.path#" output_server="#get_prod_images.path_server_id#" output_type="0"  image_link="1" image_width="200" image_height="200">
                                </cfif>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <cf_flat_list>
            <cfif isdefined('attributes.spec_id')><!--- BU SAYFADA spec_id parametresi gelirse main spec id bulunur ve o main spec e ait stok gösterilir yada direk main_spec_id parametreside gelebilir --->
            <cfquery name="GET_SPEC_MAIN" datasource="#dsn3#">
                SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID	= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spec_id#">
            </cfquery>
            <cfif GET_SPEC_MAIN.RECORDCOUNT>
                <cfset attributes.main_spec_id = GET_SPEC_MAIN.SPECT_MAIN_ID>
            </cfif>
            </cfif>
            <thead>
                <tr>
                    <th colspan="10"><cf_get_lang dictionary_id='32542.Stok Durumu'> <cfif isdefined('attributes.main_spec_id')><cf_get_lang dictionary_id="36536.Spec Main ID">:<cfoutput>#attributes.main_spec_id#</cfoutput></cfif></th>                
                </tr>
            </thead>
            <tbody>
                <cfif isdefined('attributes.main_spec_id')>
                    <tr>
                        <td colspan="2">&nbsp;</td>
                        <td><cf_get_lang dictionary_id ='57492.Toplam'></td>
                        <td><cf_get_lang dictionary_id='57647.Spec'></td>
                        <td colspan="2">&nbsp;</td>
                        <td><cf_get_lang dictionary_id ='57492.Toplam'></td>
                        <td><cf_get_lang dictionary_id='57647.Spec'></td>
                        <td colspan="2">&nbsp;</td>
                    </tr>
                </cfif>
                <tr>
                    <cfinclude template="../query/get_stock_reserved.cfm"> 
                    <td width="150"><cf_get_lang dictionary_id='58120.Gerçek Stok'></td>
                    <td>:</td>
                    <td><cfoutput><cfif len(product_total_stock.product_total_stock)>#TLFormat(product_total_stock.product_total_stock)#<cfelse>#NumberFormat(0)#</cfif></cfoutput></td>
                    <cfif isdefined('attributes.main_spec_id')>
                    <td><cfoutput><cfif len(PRODUCT_TOTAL_STOCK_SPEC.PRODUCT_TOTAL_STOCK)>#TLFormat(PRODUCT_TOTAL_STOCK_SPEC.PRODUCT_TOTAL_STOCK)#<cfelse>#NumberFormat(0)#</cfif></cfoutput></td></cfif>
                    <td style="text-align:right;"><cf_get_lang dictionary_id='32545.Alınan Sipariş(Rezerve)'></td>
                    <td width="20">:</td>
                    <td width="130"><cfoutput><cfif len(get_stock_reserved.azalan)>#TLFormat(get_stock_reserved.azalan)#<cfelse>#NumberFormat(0)#</cfif></cfoutput></td>
                    <cfif isdefined('attributes.main_spec_id')><td><cfoutput><cfif len(get_stock_reserved_spec.azalan)>#TLFormat(get_stock_reserved_spec.azalan)#<cfelse>#NumberFormat(0)#</cfif></cfoutput></td></cfif>
                    <td width="20">&nbsp;</td> 
                    <td width="20">
                    <cfif get_stock_reserved.recordcount and len(get_stock_reserved.azalan)>
                        <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_orders&taken=1&pid=#attributes.pid#</cfoutput>');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='32428.Rezerve Siparişler Detayı'>" border="0"></i></a>
                    </cfif>
                    </td>
            </tr>
            <tr>
                    <td><cf_get_lang dictionary_id='32544.Kullanılabilir Stok'></td>
                    <td width="3">:</td>
                    <td>
                        <cfif len(PRODUCT_TOTAL_STOCK.PRODUCT_TOTAL_STOCK)>
                            <cfset PRODUCT_STOCK=PRODUCT_TOTAL_STOCK.PRODUCT_TOTAL_STOCK><!--- !!! Ellemeyin !!! 20050325 --->
                        <cfelse>
                            <cfset PRODUCT_STOCK=0>
                        </cfif> 
                        <!--- <cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock) and scrap_location_total_stock.total_scrap_stock gt 0>
                            <cfset product_stock = product_stock - scrap_location_total_stock.total_scrap_stock>
                        </cfif> --->
                        <cfif get_stock_reserved.recordcount and len(get_stock_reserved.ARTAN)>
                            <cfset PRODUCT_STOCK = PRODUCT_STOCK + get_stock_reserved.ARTAN>
                        </cfif>
                        <cfif get_stock_reserved.recordcount and len(get_stock_reserved.AZALAN)>
                            <cfset PRODUCT_STOCK = PRODUCT_STOCK - get_stock_reserved.AZALAN>
                        </cfif>
                        <cfif get_prod_reserved.recordcount>
                        <cfif len(get_prod_reserved.AZALAN)>
                        <cfset PRODUCT_STOCK = PRODUCT_STOCK - get_prod_reserved.AZALAN>
                        </cfif>
                        <cfif len(get_prod_reserved.ARTAN)>
                        <cfset PRODUCT_STOCK = PRODUCT_STOCK + get_prod_reserved.ARTAN>
                        </cfif>
                        </cfif>
                        <cfif location_based_total_stock.recordcount and len(location_based_total_stock.TOTAL_LOCATION_STOCK)>
                        <cfset PRODUCT_STOCK = PRODUCT_STOCK - location_based_total_stock.TOTAL_LOCATION_STOCK>
                        </cfif> 
                        <cfoutput>#TLFormat(PRODUCT_STOCK)#</cfoutput>
                    </td>
                    <cfif isdefined('attributes.main_spec_id')>
                        <td>
                            <cfif len(PRODUCT_TOTAL_STOCK_SPEC.PRODUCT_TOTAL_STOCK)>
                                <cfset PRODUCT_STOCK=PRODUCT_TOTAL_STOCK_SPEC.PRODUCT_TOTAL_STOCK>
                            <cfelse>
                                <cfset PRODUCT_STOCK=0>
                            </cfif> 
                            <cfif get_stock_reserved_spec.recordcount and len(get_stock_reserved_spec.ARTAN)>
                                <cfset PRODUCT_STOCK = PRODUCT_STOCK + get_stock_reserved_spec.ARTAN>
                            </cfif>
                            <cfif get_stock_reserved_spec.recordcount and len(get_stock_reserved_spec.AZALAN)>
                                <cfset PRODUCT_STOCK = PRODUCT_STOCK - get_stock_reserved_spec.AZALAN>
                            </cfif>
                            <cfif get_prod_reserved_spec.recordcount>
                                <cfif len(get_prod_reserved_spec.AZALAN)>
                                    <cfset PRODUCT_STOCK = PRODUCT_STOCK - get_prod_reserved_spec.AZALAN>
                                </cfif>
                                <cfif len(get_prod_reserved_spec.ARTAN)>
                                    <cfset PRODUCT_STOCK = PRODUCT_STOCK + get_prod_reserved_spec.ARTAN>
                                </cfif>
                            </cfif>
                            <cfif location_based_total_stock_spec.recordcount and len(location_based_total_stock_spec.TOTAL_LOCATION_STOCK)>
                                <cfset PRODUCT_STOCK = PRODUCT_STOCK - location_based_total_stock_spec.TOTAL_LOCATION_STOCK>
                            </cfif> 
                            <cfoutput>#TLFormat(PRODUCT_STOCK)#</cfoutput>
                        </td>
                    </cfif>
                    <td style="text-align:right;"><cf_get_lang dictionary_id='32546.Verilen Sipariş(Beklenen)'></td>
                    <td>:</td>
                    <td><cfif len(get_stock_reserved.artan)><cfoutput>#TLFormat(get_stock_reserved.artan)#</cfoutput><cfelse>0</cfif></td>
                    <cfif isdefined('attributes.main_spec_id')><td><cfif len(get_stock_reserved_spec.artan)><cfoutput>#TLFormat(get_stock_reserved_spec.artan)#</cfoutput><cfelse>0</cfif></td></cfif>
                    <td width="20">&nbsp;</td>
                    <td>
                    <cfif get_stock_reserved.recordcount and len(get_stock_reserved.artan)>
                        <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#attributes.pid#&nosale_order_location=0</cfoutput>');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='32428.Rezerve Siparişler Detayı'>" border="0"></i></a>
                    </cfif>
                    </td>
            </tr>
            <tr>
                    <td><cf_get_lang dictionary_id='58763.Depo'><cf_get_lang dictionary_id='58761.Sevk'>-<cf_get_lang dictionary_id='29588.İthal Mal Girişi'></td>
                    <td width="3">:</td>
                    <td>
                    <cfquery name="get_sevk" datasource="#DSN2#">
                        SELECT 
                            SUM(STOCK_OUT-STOCK_IN) AS MIKTAR 
                        FROM 
                            STOCKS_ROW 
                        WHERE
                            PRODUCT_ID = #attributes.pid# AND
                            PROCESS_TYPE IN (81,811)
                    </cfquery>
                    <cfoutput>#TLformat(get_sevk.MIKTAR)#</cfoutput>
                    </td>
                    <cfif isdefined('attributes.main_spec_id')>
                    <td>
                    <cfquery name="get_sevk_spec" datasource="#DSN2#">
                        SELECT 
                            SUM(STOCK_OUT-STOCK_IN) AS MIKTAR 
                        FROM 
                            STOCKS_ROW 
                        WHERE
                            SPECT_VAR_ID = #attributes.main_spec_id# AND
                            PRODUCT_ID = #attributes.pid# AND
                            PROCESS_TYPE IN (81,811)
                    </cfquery>
                    <cfoutput>#TLformat(get_sevk_spec.MIKTAR)#</cfoutput>
                    </td>
                    </cfif>
                    <td class="moneybox"><cf_get_lang dictionary_id='30049.Üretim Emri'>(<cf_get_lang dictionary_id='29750.Rezerve'>)</td>
                    <td width="3">:</td>
                    <td> <cfoutput>#TLFormat(get_prod_reserved.AZALAN)#</cfoutput></td>
                    <cfif isdefined('attributes.main_spec_id')><td><cfoutput>#TLFormat(get_prod_reserved_spec.AZALAN)#</cfoutput></td></cfif>
                    <td width="20">&nbsp;</td>
                    <td><cfif len(get_prod_reserved.azalan)><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_reserved_production_orders&type=2&pid=#attributes.pid#</cfoutput>');"><i class="fa fa-truck"></i></a></cfif></td>
            </tr>		
            <cfoutput>
            <tr>
                    <td><cf_get_lang dictionary_id ='33729.Satış Yapılamaz Lokasyonlar'></td>
                    <td width="3">:</td>
                    <td><cfif len(LOCATION_BASED_TOTAL_STOCK.TOTAL_LOCATION_STOCK)>#TLFormat(LOCATION_BASED_TOTAL_STOCK.TOTAL_LOCATION_STOCK)#</cfif></td>
                    <cfif isdefined('attributes.main_spec_id')><td><cfif len(LOCATION_BASED_TOTAL_STOCK_SPEC.TOTAL_LOCATION_STOCK)>#TLFormat(LOCATION_BASED_TOTAL_STOCK_SPEC.TOTAL_LOCATION_STOCK)#</cfif></td></cfif>
                    <td class="moneybox"><cf_get_lang dictionary_id='30049.Üretim Emri'>(<cf_get_lang dictionary_id='58119.Beklenen'>)</td>
                    <td width="3">:</td>
                    <td>#TLFormat(get_prod_reserved.ARTAN)#</td>
                    <cfif isdefined('attributes.main_spec_id')><td>#TLFormat(get_prod_reserved_spec.ARTAN)#</td></cfif>
                    <td width="20">&nbsp;</td>
                    <td><cfif len(get_prod_reserved.artan)><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_production_orders&type=1&pid=#attributes.pid#');"><i class="fa fa-truck" title="<cf_get_lang dictionary_id='45572.Beklenen Üretim Emirleri Detayı'>" border="0"></i></a></cfif></td>
            </tr>		
            <tr>
                    <td style="text-align:left;"><cf_get_lang dictionary_id ='33729.Satış Yapılamaz Lokasyonlar'><br/>(<cf_get_lang dictionary_id='32546.Verilen Sipariş(Beklenen)'>)</td>
                    <td width="3">:</td>
                    <cfif not isdefined('attributes.main_spec_id')><cfif len(get_nosale_location_reserve_stock.nosale_reserve_stock)><td>#TLFormat(get_nosale_location_reserve_stock.nosale_reserve_stock)#<cfelse><td></cfif><cfelse><td colspan="2"></cfif></td>
                    <td class="moneybox"><cf_get_lang dictionary_id='59521.Kabul Edilen Teklif'></td>
                    <td width="3">:</td>
                    <td colspan="4"><cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock)>#TLFormat(scrap_location_total_stock.total_scrap_stock)#</cfif></td> 
                </tr>	
            </cfoutput>
            </tbody>
        </cf_flat_list>
            <cfinclude template="popup_list_stock_strategy.cfm">
            <cfinclude template="popup_list_pro_info.cfm">
            <cfinclude template="detail_product_related.cfm">
            <cfinclude template="detail_product_alternatives.cfm"><br/>
    </cf_box>
</div>

