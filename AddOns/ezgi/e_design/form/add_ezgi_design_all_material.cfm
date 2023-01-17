<cfparam name="attributes.price_catid" default="">
<cfinclude template="../../../../JS/div_function.cfm">
<cfif IsDefined("attributes.design_package_row_id")>
	<cfquery name="get_product_list" datasource="#dsn3#">
    	SELECT * FROM EZGI_DESIGN_ALL_MATERIAL WHERE DESIGN_PACKAGE_ROW_ID = #attributes.design_package_row_id#
    </cfquery>
    <cfset type = 1>
    <cfset type_id = attributes.design_package_row_id>
<cfelseif IsDefined("attributes.design_main_row_id")>
	<cfquery name="get_product_list" datasource="#dsn3#">
    	SELECT * FROM EZGI_DESIGN_ALL_MATERIAL WHERE DESIGN_MAIN_ROW_ID = #attributes.design_main_row_id# AND DESIGN_PACKAGE_ROW_ID IS NULL
    </cfquery>
    <cfset type = 2>
    <cfset type_id = attributes.design_main_row_id>
<cfelse>
    <cfset get_product_list.RecordCount = 0>
</cfif>
<cfset recordnumber = get_product_list.RecordCount>
<cfset module_name="product">
<cfset var_="upd_purchase_basket">
<br />
<table class="dph">
 	<tr>
    	<td class="dpht"><cfoutput>#getLang('main',2858)#</cfoutput></td>
     	<td class="dphb"> 
        	<cfif type eq 1>
              	<a href="javascript://" onClick="transfer_material();"><img src="/images/forward.gif" align="absmiddle" title="<cf_get_lang_main no='2876.Malzemeyi Parçaya Dönüştür'>"></a>
         	</cfif>
     	</td>
    </tr>
</table>
<cf_popup_box title=''>
    <cfform name="form_basket" method="post" action="#request.self#?fuseaction=prod.emptypopup_add_ezgi_design_all_material">
        <cfoutput>
            <input type="Hidden" name="var_" id="var_" value="#var_#">
            <input type="Hidden" name="module_name" id="module_name" value="#module_name#">
            <input type="Hidden" name="record_num" id="record_num" value="#recordnumber#">
            <cfif IsDefined("attributes.design_package_row_id")>
            	<input type="Hidden" name="design_package_row_id" id="design_package_row_id" value="#attributes.design_package_row_id#">
          	<cfelseif IsDefined("attributes.design_main_row_id")>
            	<input type="Hidden" name="design_main_row_id" id="design_main_row_id" value="#attributes.design_main_row_id#">
            </cfif>
        </cfoutput>
        <cf_form_list>
            <thead>
                <tr>
                    <th width="30"><a href="javascript:openProducts();"><img src="/images/plus_list.gif"  border="0"></a></th>
                    <th width="30"><cf_get_lang_main no='75.No'></th>
                    <th width="340"><cf_get_lang_main no='217.Açıklama'></th>
                    <th width="60"><cf_get_lang_main no='224.Birim'></th>
                    <th width="65" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
                </tr>
            </thead>
            <tbody name="table1" id="table1">
                <cfif get_product_list.recordcount>
                    <cfoutput query="get_product_list">
                    	<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
                        	SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #STOCK_ID#
                        </cfquery>
                        <input type="Hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                        <input type="Hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#PRODUCT_ID#">
                        <input type="Hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#UNIT_ID#">
                        <input type="Hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#STOCK_ID#">
                        <tr id="frm_row#currentrow#" height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                            <td align="center" width="15">
                            <cfsavecontent variable="alert"><cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
                            <a style="cursor:pointer" onClick="sil(#currentrow#);"><img  src="images/delete_list.gif" border="0" title="<cf_get_lang no='100.Ürünü Sil'>"></a></td>
                            <td nowrap>#currentrow#</td>
                            <td>
                                <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" style="width:300px;" class="boxtext" value="#GET_PRODUCT_NAME.product_name#" readonly>
                            </td>
                            <td><input type="text" name="unit#currentrow#" id="unit#currentrow#" value="#UNIT#" style="width:60px;" class="boxtext" readonly></td>
                            <td><input type="text" name="row_amount#currentrow#" id="row_amount#currentrow#" style="width:65px;" class="box" value="#AmountFormat(amount,3)#">
                            </td>
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
            
        </cf_form_list>
        <cf_form_box_footer>
                <cf_workcube_buttons 
                    is_upd='1' 
                    delete_page_url='#request.self#?fuseaction=prod.emptypopup_del_ezgi_design_all_material&type=#type#&type_id=#type_id#'>
            </cf_form_box_footer>
    </cfform>
</cf_popup_box>
<cfsavecontent variable="delete_alert"><cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
<script type="text/javascript">
	row_count=<cfoutput>#recordnumber#</cfoutput>;
	function add_row(stockid,stockprop,sirano,product_id,product_name,manufact_code,tax,tax_purchase,add_unit,product_unit_id,money,is_serial_no,discount1,discount2,discount3,discount4,discount5,discount6,discount7,discount8,discount9,discount10,del_date_no,p_price,s_price,product_cost,extra_product_cost,is_production,list_price,other_list_price,spec_main_id,spec_main_name)
	{
		
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.className = 'color-row';
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		document.form_basket.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML='<a style="cursor:pointer" onclick="sil('+row_count+');"><img src="images/delete_list.gif" border="0" alt=""></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" name="stock_id'+row_count+'" value="' + stockid + '">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="product_id'+row_count+'" value="'+product_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="unit_id'+row_count+'" value="'+product_unit_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="product_name' + row_count + '" style="width:340px;" class="boxtext" value="'+product_name+'">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="unit' + row_count + '" style="width:60px;" class="boxtext" readonly value="' + add_unit + '">';
		
		newCell = newRow.insertCell(newRow.cells.length);//Miktar
		newCell.innerHTML = '<input type="text" name="row_amount' + row_count + '" style="width:65px;" class="box" value="1" onBlur="calculate_amount(' + row_count + ');">';

	}	
	function sil(sy)
	{
		if(confirm('<cfoutput>#delete_alert#</cfoutput>'))
		{
			var my_element=eval("form_basket.row_kontrol"+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
		}	
	}
	function openProducts()
	{
		windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_ezgi_stocks&list_order_no=3,4&price_cat=-2&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists='</cfoutput>,'page');
	}
	
	function transfer_material()
	{
		<cfif isdefined('attributes.design_package_row_id') and len(attributes.design_package_row_id)>
			window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_add_ezgi_product_tree_material_transfer&design_package_row_id=#attributes.design_package_row_id#</cfoutput>";
		</cfif>
	}
</script>
