<cfparam name="attributes.sort_type" default="10">
<cfinclude template="../query/get_ezgi_iflow_production_order.cfm">
<cfquery name="get_p_order_control" dbtype="query">
	SELECT IS_STAGE FROM get_production_orders WHERE IS_STAGE IN (1,2)
</cfquery>
<cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
    <cfquery name="get_master_plan" datasource="#dsn3#">
        SELECT MASTER_PLAN_NUMBER FROM EZGI_IFLOW_MASTER_PLAN WHERE MASTER_PLAN_ID = #attributes.master_plan_id#
    </cfquery>
    <cfset master_plan_number = get_master_plan.MASTER_PLAN_NUMBER>
<cfelse>
	<cfset master_plan_number = ''>
</cfif>
<cfset attributes.p_order_date = DateFormat(get_production_orders.P_ORDER_PARTI_DATE,'dd/mm/yyyy')>
<cfset attributes.process_stage = get_production_orders.PROD_ORDER_STAGE>
<cfset attributes.parti_no = get_production_orders.P_ORDER_PARTI_NUMBER>
<table class="dph">
  	<tr>
        <td class="dpht" nowrap="nowrap">
            <a href="javascript:gizle_goster_basket(detail_inv_menu);">&raquo;</a><cf_get_lang_main no='3420.Üretim Emri Güncelle'>
        </td>
        <td class="dphb">
            <table align="right">
                <tr>
                    <td>
                    	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_iflow_demands&action_type=1&is_filter=1</cfoutput>','longpage');"><img src="/images/messenger8.gif" title="<cf_get_lang_main no='3336.Planlama Talebinden Ekleme'>" border="0"></a>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_iflow_demands&action_type=2</cfoutput>','longpage');"><img src="/images/messenger3.gif" title="<cf_get_lang_main no='3337.Satış Siparişinden Ekleme'>" border="0"></a>
                        <a href="javascript://" onClick="openProducts();"><img src="/images/messenger5.gif" title="<cf_get_lang_main no='3338.Serbest Ekleme'>" border="0"></a>
                    </td>
                </tr>
            </table>
        </td>
  	</tr>
</table>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_iflow_production_order">
  	<cfinput name="master_plan_id" type="hidden" value="#attributes.master_plan_id#">
    <cfinput name="rel_p_order_id" type="hidden" value="#attributes.rel_p_order_id#">
	<cf_basket_form id="detail_inv_menu">
		<cfoutput>
        <cf_object_main_table>	
            <cf_object_table column_width_list="90,120">
                <cfsavecontent variable="header_">#getLang('prod',566)#</cfsavecontent>
                <cf_object_tr id="form_ul_order_date" Title="#header_#">
                    <cf_object_td type="text">#getLang('prod',566)#*</cf_object_td>
                    <cf_object_td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='3421.Emir Tarihi Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="text" name="p_order_date" id="p_order_date" required="yes" value="#attributes.p_order_date#" validate="eurodate" message="#message#" maxlength="10" style="width:70px;" readonly>
                        <cf_wrk_date_image date_field="p_order_date">
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="60,120">
                <cfsavecontent variable="header_">#getLang('prod',215)#</cfsavecontent>
                <cf_object_tr id="form_ul_lot_no" Title="#header_#">
                    <cf_object_td type="text">#getLang('prod',215)#*</cf_object_td>
                    <cf_object_td>
                        <cfinput type="text" name="parti_no" id="parti_no" value="#attributes.parti_no#" maxlength="10" style="width:70px;" readonly>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="50,140">
                <cfsavecontent variable="header_"><cf_get_lang_main no="1447.Süreç"></cfsavecontent>
                <cf_object_tr id="form_ul_process_stage" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no="1447.Süreç"></cf_object_td>
                    <cf_object_td>
                       <cf_workcube_process is_upd='0' select_value='#attributes.process_stage#' process_cat_width='125' is_detail='1'>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="60,180">
                <cfsavecontent variable="header_"><cf_get_lang_main no='217.Açıklama'></cfsavecontent>
                <cf_object_tr id="form_ul_process_stage" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='217.Açıklama'></cf_object_td>
                    <cf_object_td>
                    	<textarea name="detail" style="width:180px; height:20px">#get_production_orders.P_ORDER_PARTI_DETAIL#</textarea>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
        </cf_object_main_table> 
        </cfoutput>	
        <cf_basket_form_button>
        	<cfif get_p_order_control.recordcount>
                <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()' >
            <cfelse>
                <cf_workcube_buttons is_upd='1'  add_function='kontrol()' delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_ezgi_iflow_production_order&rel_p_order_id=#attributes.rel_p_order_id#&master_plan_id=#attributes.master_plan_id#' del_function='kontrol()'>
            </cfif>
      	</cf_basket_form_button>
    </cf_basket_form>
	<cfset sepet_satir = 0>
	<cfset var_="upd_purchase_basket">
    <table id="sepet_table" align="center" cellpadding="0" cellspacing="0" style="table-layout:fixed; width:99%;">
        <tr valign="top" id="basket_tr">
            <td class="sepetim_td" width="100%">
                <table id="table_list" class="basket_list" cellpadding="0" cellspacing="0" width="100%">
                    <div id="sepetim" style="width:100%">
                        <thead>
                            <tr height="25">
                                <cfoutput>
                                <th nowrap width="30px" id="basket_header_add" style="text-align:center">
                                     
                                </th>
                                <th width="90px" nowrap><cfoutput>#getLang('objects2',1471)#</cfoutput></th>
                                <th width="70px" nowrap>Plan No</th>
                                <th width="70px" nowrap>Lot No</th>
                                <th width="70px" nowrap><cf_get_lang_main no='245.Ürün'> <cf_get_lang_main no='3019.Tipi'></th>
                                <th width="110px" nowrap><cf_get_lang_main no='1388.Ürün Kodu'></th>
                                <th nowrap><cf_get_lang_main no='245.Ürün'></th>
                                <th width="70px" nowrap><cf_get_lang_main no='223.Miktar'></th>
                                <th width="60px" nowrap><cf_get_lang_main no='224.Birim'></th>
                                <th width="200px" nowrap><cf_get_lang_main no='217.Açıklama'></th>
                                <th width="25px"><cf_get_lang_main no='3341.DRM'></th>
                                </cfoutput>
                            </tr>
                        </thead>
                        <tbody name="new_row" id="new_row">
                            <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_production_orders.recordcount#</cfoutput>">
                            <cfif get_production_orders.recordcount>
                            <cfoutput query="get_production_orders">
                                <input type="hidden" value="1" name="row_kontrol#currentrow#">
                                <input type="hidden" name="iflow_p_order_id_list" id="iflow_p_order_id_list" value="#get_production_orders.iflow_p_order_id#">
                                <tr height="20" id="frm_row#currentrow#">
                                    <td style="text-align:right">
                                    	<cfif IS_STAGE eq 0 or IS_STAGE eq 4>
                                            <a style="cursor:pointer" onclick="sil(#currentrow#);" >
                                                <img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0">
                                            </a> 
                                        </cfif>
                                        #currentrow#&nbsp;
                                    </td>
                                    <td class="boxtext" style="text-align:center">
                                    	<cfif ACTION_TYPE eq 1><cf_get_lang_main no='3422.Planlama Talebi'>
                                        <cfelseif ACTION_TYPE eq 2><cf_get_lang_main no='3423.Sipariş Emri'>
                                        <cfelse><cf_get_lang_main no='3424.Serbest Giriş'>
                                        </cfif>
                                    </td>
                                    <td style="text-align:center">#MASTER_PLAN_NUMBER#</td>
                                    <td style="text-align:center">#LOT_NO#</td>
                                    <td class="boxtext">
                                       <cfif PRODUCT_TYPE eq 1><cf_get_lang_main no='1099.Takım'>
                                        <cfelseif PRODUCT_TYPE eq 2><cf_get_lang_main no='2944.Modül'>
                                        <cfelseif PRODUCT_TYPE eq 3><cf_get_lang_main no='2903.Paket'>
                                        <cfelseif PRODUCT_TYPE eq 4><cf_get_lang_main no='2848.Parça'>
                                        <cfelse><cf_get_lang_main no='3207.Hammadde'>
                                        </cfif>
                                        <input type="hidden" name="type#currentrow#" id="type#currentrow#" value="#PRODUCT_TYPE#"> 
                                    </td>
                                    <td nowrap style="text-align:left;" title="">
                                        <input type="text" id="stock_code#currentrow#" name="stock_code#currentrow#" style="width:110px;" class="boxtext" value="#PRODUCT_CODE#" readonly=yes>
                                    </td>
                                    <td nowrap style="text-align:left;" title="">
                                        <input type="Hidden" name="stock_id#currentrow#" value="#stock_id#">
                                        <input type="text" name="product_name#currentrow#" style="width:300px;" class="boxtext" value="#product_name#">
                                    </td>
                                    <td nowrap style="text-align:right;" title="">
                                        	<input type="text" id="quantity#currentrow#" name="quantity#currentrow#" value="#TlFormat(quantity,2)#" readonly="readonly" style="width:70px; text-align:right;">
                                    </td>
                                    <td nowrap style="text-align:left;" title="">
                                        <input type="text" name="main_unit#currentrow#" style="width:60px;" class="boxtext" value="#unit#">
                                    </td>
                                    <td nowrap style="text-align:left;" title="">
                                        <input type="text" name="detail#currentrow#" style="width:200px;" value="#DETAIL#">
                                    </td>
                                    <td style="text-align:center">
                                    	<cfif IS_STAGE eq 4>
                                            <img src="/images/blue_glob.gif" title="<cf_get_lang_main no='1515.Sanal'> <cf_get_lang_main no='2252.Üretim Emri'>">
                                        <cfelseif IS_STAGE eq 0>
                                            <img src="/images/yellow_glob.gif" title="<cf_get_lang_main no='3279.Başlamadı'>">
                                        <cfelseif IS_STAGE eq 1>
                                            <img src="/images/green_glob.gif" title="<cf_get_lang_main no='3201.Başladı'>">
                                        <cfelseif IS_STAGE eq 2>
                                            <img src="/images/red_glob.gif" title="<cf_get_lang_main no='3108.Bitti'>">
                                        <cfelseif IS_STAGE eq 3>
                                            <img src="/images/grey_glob.gif" title="<cf_get_lang_main no='3101.Arıza'>">
                                        </cfif>
                                    </td>
                                </tr>
                            </cfoutput>
                            </cfif>
                        </tbody>
                    </div>
                </table>
            </td>
        </tr>
    </table>
</cfform>
<script type="text/javascript">
	var row_count = document.form_basket.record_num.value;
	function kontrol()
	{
		if (form_basket.p_order_date.value.length == 0)
		{
			alert("<cf_get_lang_main no='3095.Planlama Tarihi Girmelisiniz'> !");
			return false;
		}
		if(process_cat_control())
			return true;
		else
			return false;
	}
	function openProducts()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_ezgi_stocks&price_cat=-2&ezgi_production=1&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists='</cfoutput>,'page');
	}
	<!---function deleteProducts()
	{
		sor=confirm("<cf_get_lang_main no='121.Silmek İstediğinizden Emin Misiniz?'>");
		if(sor==true)
			window.location ="<cfoutput>
		#request.self#?fuseaction=prod.emptypopup_del_ezgi_iflow_production_order&rel_p_order_id=#attributes.rel_p_order_id#&master_plan_id=#attributes.master_plan_id#</cfoutput>";
		else
			return false;
	}--->
	function add_row(stockid,stockprop,sirano,product_id,product_name,stock_code,type,type_detail,main_unit,sales_price,money,discount,action_id,action_amount,action_type,action_detail,spect_main_id)
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("new_row").insertRow(document.getElementById("new_row").rows.length);
		newRow.className = 'color-row';
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		document.form_basket.record_num.value = row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("style", "text-align:right;");
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a> '+row_count+'&nbsp;';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("style", "text-align:center;");
		newCell.innerHTML = action_detail;	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("style", "text-align:center;");
		newCell.innerHTML = '<cfoutput>#master_plan_number#</cfoutput>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute("style", "text-align:center;");
		newCell.innerHTML = '';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" id="action_type' + row_count + '" name="action_type' + row_count + '" value="'+action_type+'"><input type="hidden" id="action_id' + row_count + '" name="action_id' + row_count + '" value="'+action_id+'"><input type="hidden" name="type' + row_count + '" value="'+type+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="type_detail' + row_count + '" style="width:70px;" class="boxtext" value="'+type_detail+'">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="stock_code' + row_count + '" style="width:110px;" class="boxtext" value="'+stock_code+'">';
		
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="stock_id'+row_count+'" value="' + stockid + '">';
		newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" name="spect_main_id'+row_count+'" value="' + spect_main_id + '">';

		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="product_id'+row_count+'" value="'+product_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="product_name' + row_count + '" style="width:300px;" class="boxtext" value="'+product_name+'">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("style", "text-align:right;");
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="'+commaSplit(action_amount,2)+'" style="width:70px; text-align:right;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="main_unit' + row_count + '" style="width:60px;" class="boxtext" value="'+main_unit+'">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="detail' + row_count + '" style="width:200px;" value="">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.setAttribute("style", "text-align:center;");
		newCell.innerHTML = '<img src="/images/blue_glob.gif" title="<cf_get_lang_main no='3425.Hesaplanmadı'>">';
	}
	function sil(sy)
	{
		var element=eval("form_basket.row_kontrol"+sy);
		element.value=0;
		var element=eval("frm_row"+sy); 
		element.style.display="none";		
	}
</script>