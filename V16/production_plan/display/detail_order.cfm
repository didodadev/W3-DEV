<cf_xml_page_edit fuseact="prod.add_prod_order">
<cfquery name="get_tree_xml_amount" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = #session_base.company_id# AND
		FUSEACTION_NAME = 'prod.add_product_tree' AND
		PROPERTY_NAME = 'is_show_prod_amount'
</cfquery>
<cfif get_tree_xml_amount.recordcount>
	<cfset is_show_prod_amount = get_tree_xml_amount.PROPERTY_VALUE>
<cfelse>
	<cfset is_show_prod_amount = 1>
</cfif>
<cfinclude template="../query/get_order_detail.cfm">
<cf_catalystHeader>
    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
<cf_box title="#getlang('','Özet','58052')#">
    <cfoutput>
    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
    <div class="form-group" id="item_order">
        <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='36447.Sipariş Eden'></label>
    <div class="col col-8 col-md-8 col-xs-12">: 
        <cfif len(order_detail.partner_id)>
            <cfquery name="GET_ORDERER" datasource="#DSN#">
                SELECT 
                     C.FULLNAME,
                     CP.COMPANY_PARTNER_NAME,
                     CP.COMPANY_PARTNER_SURNAME,
                     C.COMPANY_ID 
                FROM 
                    COMPANY_PARTNER CP,
                    COMPANY C 
                WHERE
                    CP.PARTNER_ID = #order_detail.partner_id# AND
                    CP.COMPANY_ID = C.COMPANY_ID
            </cfquery>
            <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#GET_ORDERER.COMPANY_ID#','list');">
            #GET_ORDERER.COMPANY_PARTNER_NAME#&nbsp;#GET_ORDERER.COMPANY_PARTNER_SURNAME# - </a>
            <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#order_detail.PARTNER_ID#','list');"> 
            #GET_ORDERER.FULLNAME#</a>
        <cfelseif len(order_detail.company_id)>
            <cfquery name="GET_ORDERER" datasource="#DSN#">
                SELECT 
                     C.FULLNAME,
                     C.COMPANY_ID 
                FROM 
                    COMPANY C 
                WHERE
                    C.COMPANY_ID = #order_detail.company_id#
            </cfquery>
            <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#order_detail.PARTNER_ID#','list');">#GET_ORDERER.FULLNAME#</a>
        <cfelseif len(order_detail.consumer_id)>
            <cfquery name="GET_ORDERER" datasource="#DSN#">
                SELECT 
                    CONSUMER_NAME, 
                    CONSUMER_SURNAME 
                FROM 
                    CONSUMER
                WHERE
                    CONSUMER_ID = #order_detail.consumer_id#
            </cfquery>
            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#order_detail.consumer_id#','medium');">#get_orderer.consumer_name# #get_orderer.consumer_surname#</a>
    </cfif>
    </div>
    </div>
    <div class="form-group" id="item_order_">
        <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58211.Siparis No'></label>
    <div class="col col-8 col-md-8 col-xs-12">
        : #ORDER_DETAIL.ORDER_NUMBER#
    </div>
    </div>
    <div class="form-group" id="item_date">
        <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></label>
    <div class="col col-8 col-md-8 col-xs-12">
        : #dateformat(order_detail.ORDER_DATE,dateformat_style)#
    </div>
    </div>
    <div class="form-group" id="item_method">
        <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Metodu'></label>
    <div class="col col-8 col-md-8 col-xs-12">: 
        <cfif len(ORDER_DETAIL.SHIP_METHOD)>
            <cfquery name="get_ship_type" datasource="#DSN#">
                SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID=#ORDER_DETAIL.SHIP_METHOD#
            </cfquery>
            #get_ship_type.SHIP_METHOD#
        </cfif>
    </div>
    </div>
    <div class="form-group" id="item_date_">
        <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
    <div class="col col-8 col-md-8 col-xs-12">
        : #dateformat(order_detail.DELIVERdate,dateformat_style)# 
    </div>
    </div>
</div>

<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
    <cfif len(order_detail.PRIORITY_ID)>
    <div class="form-group" id="item_priority">
        <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
    <div class="col col-8 col-md-8 col-xs-12">
        : <cfquery name="GET_PRIORITIES" datasource="#DSN#">
            SELECT PRIORITY FROM SETUP_PRIORITY WHERE PRIORITY_ID=#order_detail.PRIORITY_ID#
        </cfquery>
        <cfoutput>#GET_PRIORITIES.PRIORITY#</cfoutput>
    </div>
    </div>
</cfif>  
    <div class="form-group" id="">
        <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='36453.Sipariş Alan Çalışan'></label>
    <div class="col col-8 col-md-8 col-xs-12">
        :
        <cfif len(order_detail.order_employee_id)>
        <cfset attributes.employee_id = order_detail.order_employee_id>
         <cfinclude template="../query/get_position.cfm">
        <cfoutput> <a href="javascript://"  class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_position.EMPLOYEE_ID#&POS_ID=#get_position.POSITION_CODE#&DEPARTMENT_ID=#get_position.DEPARTMENT_ID#','list');" > #get_position.employee_name# #get_position.employee_surname# </a> </cfoutput>
        </cfif>
    </div>
    </div>
    <div class="form-group" id="">
        <label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='36462.Sipariş Alan İş Ortağı'></label>
    <div class="col col-8 col-md-8 col-xs-12">
        :
    <cfif len(order_detail.sales_partner_id)>
    <cfset attributes.partner_id = order_detail.sales_partner_id>
    <cfinclude template="../query/get_partner_name.cfm">
    </cfif>
    <cfif len(order_detail.sales_partner_id)>
     <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_partner_name.COMPANY_ID#','list');" >#get_partner_name.COMPANY_PARTNER_NAME#&nbsp;#get_partner_name.COMPANY_PARTNER_SURNAME#</a> - 
     <a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#order_detail.sales_partner_id#','list');" > #get_partner_name.company_partner_name# #get_partner_name.company_partner_surname# </a>
    </cfif>
    </div>
    </div>
</div>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
    <div class="form-group" id="item_address">
        <label class="col col-2 col-md-2 col-xs-12"><cf_get_lang dictionary_id='58449.Teslim Yeri'></label>
    <div class="col col-10 col-md-10 col-xs-12">
    : #order_detail.SHIP_ADDRESS#
    </div>
    </div>
    <div class="form-group" id="item_print">
        <label class="col col-2 col-md-2 col-xs-12"><cf_get_lang dictionary_id="36792.Print Sayısı"></label>
    <div class="col col-4 col-md-4 col-xs-12">
        :<p><cfoutput>#order_detail.print_count#</cfoutput>
    </div>
    </div>
</div>
</cfoutput>
</cf_box>
<cf_box title="#getlang('','Sipariş Karşılama Raporu','45788')#">
            <cf_grid_list>
            	<thead>
                    <tr>
                        <th width="200"><cf_get_lang dictionary_id='57518.Stok Kodu'><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th width="60"><cf_get_lang dictionary_id='57647.spec'></th>
                        <cfif session.ep.our_company_info.workcube_sector eq 'tex'>
                        <th width="70"><cf_get_lang dictionary_id='36588.asorti'></th>
                        </cfif>
                        <th width="50" style="text-align:right;"><cf_get_lang dictionary_id='58046.Sipariş Talebi'></th>
                        <th width="50" style="text-align:right;"><cf_get_lang dictionary_id='36459.Sipariş Verilen'></th>
                        <th width="50" style="text-align:right;"><cf_get_lang dictionary_id='58048.Rezerve Edilen'></th>
                        <th width="50" style="text-align:right;"><cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
                        <th width="50" style="text-align:right;"><cf_get_lang dictionary_id='60526.Kullanılabilir Stok'></th>
                        <th width="50" style="text-align:right;"><cf_get_lang dictionary_id='36800.Verilen Ü E'></th>
                        <th width="50" style="text-align:right;"><cf_get_lang dictionary_id='36801.Kalan Ü E'></th>
                        <cfif is_show_prod_amount eq 1><th width="15"></th></cfif>
                    </tr>
                </thead>
                <tbody>
                <cfif GET_ORDERS_PRODUCTS.recordcount>
                    <cfset order_product_id_list = ValueList(GET_ORDERS_PRODUCTS.PRODUCT_ID,',')>
                    <cfset order_stock_id_list = ValueList(GET_ORDERS_PRODUCTS.STOCK_ID,',')>
                    <cfset order_stock_id_list=listsort(order_stock_id_list,"numeric","ASC",",")>
                    <cfset order_product_id_list=listsort(order_product_id_list,"numeric","ASC",",")>
                    <cfquery name="_PRODUCT_TOTAL_STOCK_" datasource="#DSN2#">
                        SELECT 
                            PRODUCT_TOTAL_STOCK,PRODUCT_ID
                        FROM 
                            GET_PRODUCT_STOCK 
                        WHERE 
                          <cfif isdefined("order_product_id_list") and len(order_product_id_list)>
                            PRODUCT_ID IN (#order_product_id_list#)
                          <cfelse>
                            PRODUCT_ID IS NULL
                          </cfif>
                    </cfquery>
                    <cfset order_product_id_list = listsort(listdeleteduplicates(valuelist(_PRODUCT_TOTAL_STOCK_.PRODUCT_ID,',')),'numeric','ASC',',')>
                    <cfquery name="_GET_STOCK_RESERVED_" datasource="#DSN3#">
                        SELECT
                            ISNULL(SUM(STOCK_ARTIR),0) AS ARTAN,
                            ISNULL(SUM(STOCK_AZALT),0) AS AZALAN,
                            STOCK_ID
                        FROM
                            GET_STOCK_RESERVED
                        WHERE
                            STOCK_ID IN (#order_stock_id_list#)
                        GROUP BY STOCK_ID	
                    </cfquery>
                    <cfset order_stock_id_list = listsort(listdeleteduplicates(valuelist(_GET_STOCK_RESERVED_.STOCK_ID,',')),'numeric','ASC',',')>
                </cfif>
                <cfoutput query="GET_ORDERS_PRODUCTS">
                    <cfset attributes.stock_id = STOCK_ID>
                    <cfset attributes.product_id = PRODUCT_ID>
                    <cfif len(_PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')])>
                        <cfset PRODUCT_STOCK = _PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')]>
                    <cfelse>
                        <cfset PRODUCT_STOCK = 0 >
                    </cfif>
                    <cfif _GET_STOCK_RESERVED_.recordcount and len(_GET_STOCK_RESERVED_.ARTAN)>
                        <cfif len(_GET_STOCK_RESERVED_.ARTAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')])>
                            <cfset GET_STOCK_RESERVED_ARTAN = _GET_STOCK_RESERVED_.ARTAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')]>
                        <cfelse>
                            <cfset GET_STOCK_RESERVED_ARTAN = 0>	
                        </cfif>
                        <cfset PRODUCT_ARTAN = GET_STOCK_RESERVED_ARTAN >
                        <cfset PRODUCT_STOCK = PRODUCT_STOCK + GET_STOCK_RESERVED_ARTAN>
                    </cfif>
                    <cfif _GET_STOCK_RESERVED_.recordcount and len(_GET_STOCK_RESERVED_.AZALAN)>
                        <cfif len(_GET_STOCK_RESERVED_.AZALAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')])>
                            <cfset GET_STOCK_RESERVED_AZALAN = _GET_STOCK_RESERVED_.AZALAN[listfind(order_stock_id_list,GET_ORDERS_PRODUCTS.STOCK_ID,',')] >
                        <cfelse>
                            <cfset GET_STOCK_RESERVED_AZALAN = 0 >
                        </cfif>
                        <cfset PRODUCT_AZALAN = GET_STOCK_RESERVED_AZALAN>
                        <cfset PRODUCT_STOCK = PRODUCT_STOCK - GET_STOCK_RESERVED_AZALAN >
                    </cfif>
                    <tr>
                        <td><a class="tableyazi" href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#PRODUCT_ID#">#STOCK_CODE#</a>
                            <a class="tableyazi" href="#request.self#?fuseaction=prod.list_product_tree&event=upd&stock_id=#STOCK_ID#">#PRODUCT_NAME##PROPERTY#</a></td>
                        <td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect&id=#SPECT_VAR_ID#&order_id=#order_id#','list');">#SPECT_VAR_NAME#</a></td>
                        <td style="text-align:right;">#QUANTITY#</td>
                        <td style="text-align:right;"><cfif isdefined('PRODUCT_ARTAN')>#PRODUCT_ARTAN#</cfif></td>
                        <td style="text-align:right;"><cfif isdefined('PRODUCT_AZALAN')>#PRODUCT_AZALAN#</cfif></td>
                        <td style="text-align:right;">#_PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')]#	<!--- Liste Yöntemi Gerçek Stok: ---></td>
                        <td style="text-align:right;">#WRK_ROUND(PRODUCT_STOCK)#</td>
                        <cfquery name="GET_PRODUCTION_INFO" datasource="#DSN3#">
                           SELECT
                                SUM(PO.QUANTITY) QUANTITY
                            FROM 
                                PRODUCTION_ORDERS PO 
                            WHERE 
                                P_ORDER_ID IN(SELECT PRODUCTION_ORDER_ID FROM PRODUCTION_ORDERS_ROW WHERE ORDER_ROW_ID IN (#attributes.order_row_id#))
                                AND PRODUCTION_LEVEL = 0
                        </cfquery>
                        <cfif GET_PRODUCTION_INFO.recordcount and len(GET_PRODUCTION_INFO.QUANTITY)>
                            <cfset 'verilen_uretim_emri#currentrow#' = GET_PRODUCTION_INFO.QUANTITY>
                        <cfelse>
                            <cfset 'verilen_uretim_emri#currentrow#' =  0>
                        </cfif>
                        <cfif len(_PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')]) and _PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')] lt 0>
                            <cfset gerekli_uretim_miktarı = QUANTITY - _PRODUCT_TOTAL_STOCK_.PRODUCT_TOTAL_STOCK[listfind(order_product_id_list,GET_ORDERS_PRODUCTS.PRODUCT_ID,',')]>
                        <cfelse>
                            <cfset gerekli_uretim_miktarı = QUANTITY >
                        </cfif>
                        <cfset gerekli_uretim_miktarı = gerekli_uretim_miktarı - Evaluate('verilen_uretim_emri#currentrow#')>
                        <td style="text-align:right;">#Evaluate('verilen_uretim_emri#currentrow#')#</td>
                        <td style="text-align:right;">
                        <input type="hidden" style="width:50px;" name="product_amount_old" id="product_amount_old" value="#TlFormat(gerekli_uretim_miktarı,2)#">
                        <input type="text" style="width:50px;" readonly name="product_amount0" id="product_amount0" value="#TlFormat(gerekli_uretim_miktarı,2)#" class="box"></td><!---  onChange="calculate_production_amounts();" --->
                        <cfif is_show_prod_amount eq 1>
							<td style="text-align:right;"><cfif IS_PRODUCTION eq 1><a href="javascript://" class="tableyazi" onClick="gizle_goster(_PRODUCT_STOCKS_STATUS_#STOCK_ID#);AjaxPageLoad('#request.self#?fuseaction=prod.popup_ajax_order_products_stock_status&stock_id=#stock_id#&this_production_amount=#gerekli_uretim_miktarı#&spect_var_id=#SPECT_VAR_ID#','PRODUCT_STOCKS_STATUS#STOCK_ID#',1);" title="<cf_get_lang dictionary_id ='36497.Malzeme İhtiyaçları'>"><i class="fa fa-truck"></i></a></cfif></td>
						</cfif>
                    </tr>
                    <tr class="nohover" id="_PRODUCT_TREE_#STOCK_ID#" style="display:none">
                        <td colspan="13"><div id="PRODUCT_TREE#STOCK_ID#"></div></td>
                    </tr>
                    <tr class="nohover" id="_PRODUCT_STOCKS_STATUS_#STOCK_ID#" style="display:none">
                        <td colspan="13"><div id="PRODUCT_STOCKS_STATUS#STOCK_ID#"></div></td>
                    </tr>
                </cfoutput>
               </tbody>
            </cf_grid_list>
			

  
        </cf_box>
        <cf_box title="#getlang('','Üretim Emirleri','51318')#"><cfinclude template="list_porder_for_order.cfm"></cf_box>
        </div>
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
            <cf_get_workcube_note  company_id="#session.ep.company_id#" action_section='ORDER' action_id='#attributes.order_id#'>
        </div>

      
<script type="text/javascript">
	function calculate_production_amounts(){
		var old_amount = filterNum(document.getElementById('product_amount_old').value,3);
		var production_amounts = document.getElementsByName('product_amount').length;
		var rate = parseFloat(old_amount/parseInt(document.getElementById('product_amount0').value));
		for (ii=0;ii<production_amounts;ii++){
			document.all.product_amount[ii].value = parseInt((filterNum(document.all.product_amount[ii].value,4))/(rate));
		}
	}
</script>
