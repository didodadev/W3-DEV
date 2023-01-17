<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.show_alternative_prod') and attributes.show_alternative_prod eq 1>
	<cfquery name="GET_PRODUCT" datasource="#dsn3#">
		SELECT 
			AP.PRODUCT_ID,
			#dsn#.Get_Dynamic_Language(P.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,P.PRODUCT_NAME) AS PRODUCT_NAME,
			P.PRODUCT_ID AS ALTERNATIVE_PROD,
			ISNULL(P.IS_PRODUCTION,0) AS IS_PRODUCTION,
			ISNULL(P.IS_PURCHASE,0) AS IS_PURCHASE,
			PU.MAIN_UNIT 
		FROM 
			ALTERNATIVE_PRODUCTS AP,
			PRODUCT P,
			PRODUCT_UNIT PU
		WHERE 
			P.PRODUCT_ID =AP.ALTERNATIVE_PRODUCT_ID
			AND AP.PRODUCT_ID = #attributes.pid#
			AND P.PRODUCT_ID = PU.PRODUCT_ID
			AND PU.IS_MAIN = 1
		ORDER BY P.PRODUCT_ID
	</cfquery>
	<cfset prod_id_list_=listdeleteduplicates(valuelist(GET_PRODUCT.ALTERNATIVE_PROD))>
<cfelse>
	<cfquery name="GET_PRODUCT" datasource="#DSN3#">
		SELECT
			#dsn#.Get_Dynamic_Language(P.PRODUCT_ID,'#session.ep.language#','PRODUCT','PRODUCT_NAME',NULL,NULL,P.PRODUCT_NAME) AS PRODUCT_NAME,
			P.PRODUCT_ID,
			ISNULL(P.IS_PRODUCTION,0) AS IS_PRODUCTION,
			ISNULL(P.IS_PURCHASE,0) AS IS_PURCHASE,
			PU.MAIN_UNIT 
		FROM 
			PRODUCT P,
			PRODUCT_UNIT PU
		WHERE
			P.PRODUCT_ID = PU.PRODUCT_ID
			AND P.PRODUCT_ID =#attributes.pid#
			AND PU.IS_MAIN = 1
	</cfquery>		
	<cfset prod_id_list_=attributes.pid>
</cfif>
<cfif isdefined('prod_id_list_') and len(prod_id_list_)>
	<cfquery name="GET_STOCKS_ALL" datasource="#DSN2#">
		SELECT 
			SR.PRODUCT_STOCK,
			SR.STOCK_ID,
			SR.STOCK_CODE,
			SR.BARCOD,
			SR.PROPERTY,
			SR.PRODUCT_ID,
			D.DEPARTMENT_ID,
			D.DEPARTMENT_HEAD
		FROM 
			GET_STOCK_PRODUCT SR,
			#dsn_alias#.DEPARTMENT D
		WHERE 
			SR.DEPARTMENT_ID = D.DEPARTMENT_ID
			AND SR.PRODUCT_ID IN (#prod_id_list_#)
		ORDER BY
			SR.PRODUCT_ID,
			SR.STOCK_ID,
			SR.DEPARTMENT_ID
	</cfquery>
	<cfquery name="GET_STRATEGY_MAIN" datasource="#DSN2#">
		SELECT 
			MAXIMUM_STOCK,
			REPEAT_STOCK_VALUE,
			MINIMUM_STOCK,
			DEPARTMENT_ID,
			PRODUCT_ID,
			STOCK_ID
		FROM 
			GET_STOCK_STRATEGY
		WHERE 
			PRODUCT_ID IN (#prod_id_list_#)
			AND DEPARTMENT_ID IS NOT NULL
		ORDER BY 
			PRODUCT_ID
	</cfquery>
	<cfscript>
		if(GET_STRATEGY_MAIN.recordcount)
		{
			for(str_i=1;str_i lte GET_STRATEGY_MAIN.recordcount;str_i=str_i+1)
			{
				'is_strategy_#GET_STRATEGY_MAIN.STOCK_ID[str_i]#_#GET_STRATEGY_MAIN.DEPARTMENT_ID[str_i]#'=1;
				'strategy_min_stock_#GET_STRATEGY_MAIN.STOCK_ID[str_i]#_#GET_STRATEGY_MAIN.DEPARTMENT_ID[str_i]#'=GET_STRATEGY_MAIN.MINIMUM_STOCK[str_i];
				'strategy_max_stock_#GET_STRATEGY_MAIN.STOCK_ID[str_i]#_#GET_STRATEGY_MAIN.DEPARTMENT_ID[str_i]#'=GET_STRATEGY_MAIN.MAXIMUM_STOCK[str_i];
				'strategy_repeat_stock_value_#GET_STRATEGY_MAIN.STOCK_ID[str_i]#_#GET_STRATEGY_MAIN.DEPARTMENT_ID[str_i]#'= GET_STRATEGY_MAIN.REPEAT_STOCK_VALUE[str_i];
			}
		}
	</cfscript>
<cfelse>
	<cfset get_stocks_all.recordcount=0>
</cfif>
<cf_grid_list>
	<thead>
         <tr>
            <th><cf_get_lang dictionary_id='57518.stok kodu'></th>
            <th><cf_get_lang dictionary_id='57633.barkod'></th>
            <th><cf_get_lang dictionary_id='57657.ürün'></th>
            <th><cf_get_lang dictionary_id='58763.depo'></th>
            <th><cf_get_lang dictionary_id='57635.miktar'>-<cf_get_lang dictionary_id='57636.birim'></th>
            <th><cf_get_lang dictionary_id='57756.durum'></th>
            <th><a href="javascript://"><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='45387.Spect Durumları'>"></i></a></th>
			<th><a href="javascript://"><i class="fa fa-gears" title="<cf_get_lang dictionary_id='57919.Hareketler'>"></i></a></th>
			<th><a href="javascript://"><i class="fa fa-stop" title="<cf_get_lang dictionary_id='45221.Lokasyonlar'>"></i></a></th>
			<th><a href="javascript://"><i class="fa fa-truck"></i></a></th>
        </tr>
    <thead>
    <tbody>
	<cfif get_stocks_all.recordcount>
		<cfoutput query="get_stocks_all">
            <cfif isdefined('is_strategy_#STOCK_ID#_#DEPARTMENT_ID#') and evaluate('is_strategy_#STOCK_ID#_#DEPARTMENT_ID#') eq 1>
                <cfif product_stock lte 0>
                    <cfsavecontent variable="stock"><cf_get_lang dictionary_id ='45214.Stok Yok'></cfsavecontent>
                    <cfset stock_status = '<font color="ff0000">#stock#</font>'>
                <cfelseif isdefined('strategy_min_stock_#STOCK_ID#_#DEPARTMENT_ID#') and len(evaluate('strategy_min_stock_#STOCK_ID#_#DEPARTMENT_ID#')) and product_stock lte evaluate('strategy_min_stock_#STOCK_ID#_#DEPARTMENT_ID#')>
                    <cfsavecontent variable="yet"><cf_get_lang dictionary_id ='45560.Yetersiz Stok'></cfsavecontent>
                    <cfset stock_status = '<font color="ff0000">#yet#</font>'>
                <cfelseif isdefined('strategy_repeat_stock_value_#STOCK_ID#_#DEPARTMENT_ID#') and len(evaluate('strategy_repeat_stock_value_#STOCK_ID#_#DEPARTMENT_ID#')) and product_stock lte evaluate('strategy_repeat_stock_value_#STOCK_ID#_#DEPARTMENT_ID#') 
                    and isdefined('strategy_min_stock_#STOCK_ID#_#DEPARTMENT_ID#') and len(evaluate('strategy_min_stock_#STOCK_ID#_#DEPARTMENT_ID#')) and product_stock gt evaluate('strategy_min_stock_#STOCK_ID#_#DEPARTMENT_ID#')>
                    <cfsavecontent variable="order"><cf_get_lang dictionary_id ='45318.Sipariş Ver'></cfsavecontent>
                    <cfset stock_status = '<font color="009933">#order#</font>'>
                <cfelseif isdefined('strategy_max_stock_#STOCK_ID#_#DEPARTMENT_ID#') and len(evaluate('strategy_max_stock_#STOCK_ID#_#DEPARTMENT_ID#')) and product_stock lt evaluate('strategy_max_stock_#STOCK_ID#_#DEPARTMENT_ID#')>
                    <cfsavecontent variable="yet_stock"><cf_get_lang dictionary_id ='45285.Yeterli Stok'></cfsavecontent>
                    <cfset stock_status = "#yet_stock#">
                <cfelseif isdefined('strategy_max_stock_#STOCK_ID#_#DEPARTMENT_ID#') and len(evaluate('strategy_max_stock_#STOCK_ID#_#DEPARTMENT_ID#')) and product_stock gte evaluate('strategy_max_stock_#STOCK_ID#_#DEPARTMENT_ID#')>
                    <cfsavecontent variable="f_stock"><cf_get_lang dictionary_id ='45336.Fazla Stok'></cfsavecontent>
                    <cfset stock_status = '<font color="6666FF">#f_stock#</font>'>
                </cfif>
            <cfelse>
            <cfsavecontent variable="define"><cf_get_lang dictionary_id='58845.Tanımsız'></cfsavecontent>
                <cfset stock_status = '#define#'>
            </cfif>
            <tr>
                <td width="100"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=stock.detail_stock_popup&stock_id=#stock_id#&pid=#attributes.pid#','work')" class="tableyazi">#stock_code#</a></td>
                <td>#barcod#</td>
                <td>#get_product.product_name[listfind(prod_id_list_,product_id)]# #property#</td>
                <td>#department_head#</td>
                <td align="right" style="text-align:right;"><cfif product_stock lt 0><font color="red">#AmountFormat(product_stock)# #get_product.main_unit[listfind(prod_id_list_,product_id)]#</font><cfelse>#tlformat(product_stock)# #get_product.main_unit[listfind(prod_id_list_,product_id)]#</cfif></td>
                <td>#stock_status#</td> 
                <!---<td style="width:100px;" nowrap="nowrap">
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=stock.popup_list_product_spects&stock_id=#stock_id#&department_id=#department_id#','list')"><img src="/images/assortment.gif" title="<cf_get_lang dictionary_id='210.Spect Durumları'>"></a>
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=stock.detail_stock_popup&pid=#attributes.pid#&stock_id=#stock_id#&department_id=#department_id#&department_out=#department_id#','wide')"><img src="/images/forklift.gif" title="<cf_get_lang dictionary_id='507.Hareketler'>"></a>
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=stock.detail_store_stock_popup&stock_id=#stock_id#&department=#department_id#&product_id=#attributes.pid#','list')"><img src="/images/cuberelation.gif" title="<cf_get_lang dictionary_id='44.Lokasyonlar'>"></a>
                     <cfif get_product.is_production[listfind(prod_id_list_,product_id)] eq 1>
                        <cfif get_module_user(26)>
                            <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.add_prod_order&stock_id=#STOCK_ID#&product_name=#get_product.product_name[listfind(prod_id_list_,product_id)]#','wwide');"><img src="/images/forklift.gif" width="25" height="21" title="<cf_get_lang dictionary_id='359.Üretim Emri Ver'>"></a>
                        <cfelse>
                            <a href="#request.self#?fuseaction=correspondence.add_internaldemand&stock_id=#STOCK_ID#"><img src="/images/ship.gif" width="25" height="21" title="<cf_get_lang dictionary_id='141.Sipariş Ver'>"></a>
                        </cfif>
                    <cfelseif get_product.is_purchase[listfind(prod_id_list_,product_id)] eq 1>
                        <cfif get_module_user(12)>
                            <a href="#request.self#?fuseaction=purchase.add_product_all_order&stock_id=#STOCK_ID#&order_base=2&stock_dept_id=#DEPARTMENT_ID#"><img src="/images/ship.gif" width="25" height="21" title="<cf_get_lang dictionary_id='141.Sipariş Ver'>"></a>
                        <cfelse>
                            <a href="#request.self#?fuseaction=correspondence.add_internaldemand&stock_id=#STOCK_ID#"><img src="/images/ship.gif" width="25" height="21" title="<cf_get_lang dictionary_id='141.Sipariş Ver'>"></a>
                        </cfif>
                    </cfif>
                </td>--->
                
                <td>
                    <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=stock.popup_list_product_spects&stock_id=#stock_id#&department_id=#department_id#')"><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='45387.Spect Durumları'>"></i></a>
                    </td><td> <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=stock.detail_stock_popup&pid=#attributes.pid#&stock_id=#stock_id#&department_id=#department_id#&department_out=#department_id#')"><i class="fa fa-gears" title="<cf_get_lang dictionary_id='57919.Hareketler'>"></i></a>
				   </td> <td> <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=stock.detail_store_stock_popup&stock_id=#stock_id#&department=#department_id#&product_id=#attributes.pid#')"><i class="fa fa-stop" title="<cf_get_lang dictionary_id='45221.Lokasyonlar'>"></i></a>
				   </td><td><cfif get_product.is_production[listfind(prod_id_list_,product_id)] eq 1>
                        <cfif get_module_user(26)>
                            <a href="javascript://" onClick="window.open('#request.self#?fuseaction=prod.order&event=add&stock_id=#STOCK_ID#&product_name=#get_product.product_name[listfind(prod_id_list_,product_id)]#','wwide');"><i class="fa fa-truck" width="25" height="21" title="<cf_get_lang dictionary_id='45536.Üretim Emri Ver'>"></i></a>
                        <cfelse>
                            <a href="#request.self#?fuseaction=correspondence.list_internaldemand&event=add&stock_id=#STOCK_ID#"><i class="fa fa-truck" width="25" height="21" title="<cf_get_lang dictionary_id='45318.Sipariş Ver'>"></i></a>
                        </cfif>
                    <cfelseif get_product.is_purchase[listfind(prod_id_list_,product_id)] eq 1>
                        <cfif get_module_user(12)>
                            <a href="#request.self#?fuseaction=purchase.list_order&event=add&stock_id=#STOCK_ID#&order_base=2&stock_dept_id=#DEPARTMENT_ID#"><i class="fa fa-truck" width="25" height="21" title="<cf_get_lang dictionary_id='45318.Sipariş Ver'>"></i></a>
                        <cfelse>
                            <a href="#request.self#?fuseaction=correspondence.list_internaldemand&event=add&stock_id=#STOCK_ID#"><i class="fa fa-truck" width="25" height="21" title="<cf_get_lang dictionary_id='45318.Sipariş Ver'>"></i></a>
                        </cfif>
                    </cfif> 
                </td>
            </tr>
        </cfoutput>
	<cfelse>
        <tr>
            <td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
        </tr>
	</cfif>
    </tbody>
</cf_grid_list>

