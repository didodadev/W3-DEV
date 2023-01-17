<cfset process_action = 'add'>
<cfset module_name="prod">
<cfquery name="get_paper_no" datasource="#dsn3#">
 	SELECT  TOP (1) P_ORDER_PARTI_NUMBER FROM EZGI_IFLOW_PRODUCTION_ORDERS_PARTI WHERE P_ORDER_PARTI_NUMBER > 1 ORDER BY P_ORDER_PARTI_NUMBER DESC
</cfquery>
<cfquery name="get_cat_id" datasource="#dsn3#">
	SELECT MASTER_PLAN_CAT_ID FROM EZGI_IFLOW_MASTER_PLAN WHERE MASTER_PLAN_ID = #attributes.master_plan_id#
</cfquery>
<cfset attributes.p_order_date = DateFormat(now(),'dd/mm/yyyy')>
<cfset attributes.p_order_detail = "">
<cfparam name="attributes.p_order_status" default="">
<cfset attributes.p_order_status = 1>
<cfif get_paper_no.recordcount>
	<cfset attributes.parti_no = get_paper_no.P_ORDER_PARTI_NUMBER + 1>
<cfelse>
	<cfset attributes.parti_no = 10000001>
</cfif>
<cfset get_p_order.recordcount =0>
<table class="dph">
  	<tr>
        <td class="dpht">
           	<cfoutput>#getLang('prod',65)#</cfoutput>
        </td>
        <td class="dphb">
            <table align="right">
                <tr>
                    <td>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_iflow_demands&action_type=3&cat_id=#get_cat_id.MASTER_PLAN_CAT_ID#&is_filter=1</cfoutput>','longpage');"><img src="/images/messenger2.gif" title="<cf_get_lang_main no='1525.Transfer İşlemi'>" border="0"></a>
                    	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_iflow_demands&action_type=1&is_filter=1</cfoutput>','longpage');"><img src="/images/messenger8.gif" title="<cf_get_lang_main no='3336.Planlama Talebinden Ekleme'>" border="0"></a>
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_ezgi_iflow_demands&action_type=2</cfoutput>','longpage');"><img src="/images/messenger3.gif" title="<cf_get_lang_main no='3337.Satış Siparişinden Ekleme'>" border="0"></a>
                        <a href="javascript://" onClick="openProducts();"><img src="/images/messenger5.gif" title="<cf_get_lang_main no='3338.Serbest Ekleme'>" border="0"></a>
                    </td>
                </tr>
            </table>
        </td>
  	</tr>
</table>
<cfform name="form_basket" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_iflow_production_order">
	<cfif isdefined('attributes.master_plan_id') and len(attributes.master_plan_id)>
    	<cfinput name="master_plan_id" type="hidden" value="#attributes.master_plan_id#">
    </cfif>
	<cf_basket_form id="detail_inv_menu">
		<cfoutput>
        <cf_object_main_table>	
            <cf_object_table column_width_list="90,120">
                <cfsavecontent variable="header_"><cf_get_lang_main no='3339.Planlama Tarihi'></cfsavecontent>
                <cf_object_tr id="form_ul_order_date" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='3339.Planlama Tarihi'>*</cf_object_td>
                    <cf_object_td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='3095.Planlama Tarihi Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="text" name="p_order_date" id="p_order_date" required="yes" value="#attributes.p_order_date#" validate="eurodate" message="#message#" maxlength="10" style="width:70px;" readonly>
                        <cf_wrk_date_image date_field="p_order_date">
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
            <cf_object_table column_width_list="60,120">
                <cfsavecontent variable="header_"><cf_get_lang_main no='3273.Parti'> No</cfsavecontent>
                <cf_object_tr id="form_ul_parti_no" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no='3273.Parti'> No*</cf_object_td>
                    <cf_object_td>
                        <cfinput type="text" name="parti_no" id="parti_no" value="#attributes.parti_no#" maxlength="10" style="width:70px;" readonly>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
             <cf_object_table column_width_list="50,120">
                <cfsavecontent variable="header_"><cf_get_lang_main no="1447.Süreç"></cfsavecontent>
                <cf_object_tr id="form_ul_process_stage" Title="#header_#">
                    <cf_object_td type="text"><cf_get_lang_main no="1447.Süreç"></cf_object_td>
                    <cf_object_td>
                        <cf_workcube_process is_upd='0' process_cat_width='125' is_detail='0'>
                    </cf_object_td>
                </cf_object_tr>
            </cf_object_table>
        </cf_object_main_table>
        </cfoutput>	
        <cfif isdefined("attributes.p_order_id")>
            <cf_basket_form_button></cf_basket_form_button>
        <cfelse>
            <cf_basket_form_button>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_basket_form_button>
        </cfif>
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
                                    <th nowrap width="40px" id="basket_header_add" style="text-align:center"></th>
                                    <th width="70px" nowrap><cfoutput>#getLang('bank',138)#</cfoutput></th>
                                    <th width="90px" nowrap><cfoutput>#getLang('main',3340)#</cfoutput></th>
                                    <th width="150px" nowrap><cf_get_lang_main no='1388.Ürün Kodu'></th>
                                    <th nowrap><cf_get_lang_main no='245.Ürün'></th>
                                    <th width="90px" nowrap><cf_get_lang_main no='223.Miktar'></th>
                                    <th width="60px" nowrap><cf_get_lang_main no='224.Birim'></th>
                                    <th width="300px" nowrap><cf_get_lang_main no='217.Açıklama'></th>
                                    <th width="25px"><cf_get_lang_main no='3341.DRM'></th>
                                </cfoutput>
                            </tr>
                        </thead>
                        <tbody name="new_row" id="new_row">
                            <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_p_order.recordcount#</cfoutput>">
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
		newCell.innerHTML = '<input type="hidden" id="action_type' + row_count + '" name="action_type' + row_count + '" value="'+action_type+'"><input type="hidden" id="action_id' + row_count + '" name="action_id' + row_count + '" value="'+action_id+'"><input type="hidden" name="type' + row_count + '" value="'+type+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="type_detail' + row_count + '" style="width:70px;" class="boxtext" value="'+type_detail+'">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="stock_code' + row_count + '" style="width:140px;" class="boxtext" value="'+stock_code+'">';
		
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" name="spect_main_id'+row_count+'" value="' + spect_main_id + '">';
		newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" name="stock_id'+row_count+'" value="' + stockid + '">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="product_id'+row_count+'" value="'+product_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="product_name' + row_count + '" style="width:300px;" class="boxtext" value="'+product_name+'">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="'+commaSplit(action_amount,2)+'" style="width:90px; text-align:right;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="main_unit' + row_count + '" style="width:60px;" class="boxtext" value="'+main_unit+'">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="detail' + row_count + '" style="width:300px;" value="">';
		
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