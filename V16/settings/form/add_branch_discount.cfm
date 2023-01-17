<cfquery name="get_branch_discount" datasource="#dsn3#">
	SELECT 
    	ID, 
        BRANCH_ID, 
        PAYMETHOD_ID, 
        CARD_PAYMETHOD_ID, 
        BRAND_ID, 
        PRODUCT_CAT_ID, 
        DISCOUNT, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
	    SETUP_BRANCH_DISCOUNT 
    ORDER BY 
    	ID 
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_NAME, BRANCH_ID FROM BRANCH ORDER BY BRANCH_NAME
</cfquery>

<cf_box title="#getLang('','Şube İskonto Yetkisi',44682)#" ><!--- Basket Ek Tanımları --->

<cfform name="branch_discount" action="#request.self#?fuseaction=settings.emptypopup_add_branch_discount" method="post">
    <cf_grid_list>
    	
                    
                        <thead>
                            <th style="width:10px;"><a style="cursor:pointer" onclick="add_row();"><img src="images/plus_list.gif" border="0"></a></th>
                            <th class="txtboldblue"><cf_get_lang_main no='41.Şube'></th>
                            <th class="txtboldblue"><cf_get_lang_main no='1104.Ödeme Yöntemi'></th>
                            <th class="txtboldblue"><cf_get_lang_main no='155.Ürün Kategori'></th>
                            <th class="txtboldblue"><cf_get_lang_main no='1435.Marka'></th>
                            <th class="txtboldblue"><cf_get_lang_main no='229.İskonto'></th>
                        </thead>
                        <tbody name="table1" id="table1">
                            <cfset my_count = 0>
                            <cfif get_branch_discount.recordcount>
                                <cfoutput query="get_branch_discount">
                                    <cfset my_count = my_count + 1>
                                    <tr id="frm_row#my_count#">
                                        <div class="form-group">
                                        <input type="hidden" name="branch_discount_id#my_count#" id="branch_discount_id#my_count#" value="#id#">
                                        <td><input type="hidden" name="row_kontrol#my_count#" id="row_kontrol#my_count#" value="1"><a style="cursor:pointer" onclick="sil(#my_count#);"><img  src="images/delete_list.gif" border="0"></a></td>
                                        <td>
                                            <div class="form-group">
                                                <select name="branch_id#my_count#" id="branch_id#my_count#" style="width:120px;">
                                                <option value=""><cf_get_lang_main no ="322.Seçiniz"></option>
                                                    <cfloop query="GET_BRANCH">
                                                        <option value="#branch_id#" <cfif get_branch.branch_id eq get_branch_discount.branch_id>selected</cfif>>#branch_name#</option>
                                                    </cfloop>
                                                </select>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="form-group">
                                            <cfif len(get_branch_discount.PAYMETHOD_ID)>
                                                <cfquery name="GET_PAYMETHOD" datasource="#dsn#">
                                                    SELECT PAYMETHOD,PAYMETHOD_ID FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = #get_branch_discount.PAYMETHOD_ID#
                                                </cfquery>
                                                <input type="hidden" name="card_paymethod_id#my_count#" id="card_paymethod_id#my_count#" value="">
                                                <input type="hidden" name="payment_type_id#my_count#" id="payment_type_id#my_count#" value="#get_branch_discount.PAYMETHOD_ID#">
                                                <input type="text" name="payment_type#my_count#" id="payment_type#my_count#" value="#GET_PAYMETHOD.PAYMETHOD#" style="width:120px;">
                                            <cfelseif len(get_branch_discount.CARD_PAYMETHOD_ID)>
                                                <cfquery name="get_card_paymethod" datasource="#dsn3#">
                                                    SELECT CARD_NO FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #get_branch_discount.card_paymethod_id#
                                                </cfquery>
                                                <input type="hidden" name="card_paymethod_id#my_count#" id="card_paymethod_id#my_count#" value="#get_branch_discount.card_paymethod_id#">
                                                <input type="hidden" name="payment_type_id#my_count#" id="payment_type_id#my_count#" value="">
                                                <input type="text" name="payment_type#my_count#" id="payment_type#my_count#" value="#get_card_paymethod.card_no#" style="width:120px;">
                                            <cfelse>
                                                <input type="hidden" name="card_paymethod_id#my_count#" id="card_paymethod_id#my_count#" value="">
                                                <input type="hidden" name="payment_type_id#my_count#" id="payment_type_id#my_count#" value="">
                                                <input type="text" name="payment_type#my_count#" id="payment_type#my_count#" value="" style="width:120px;">
                                            </cfif>
                                            <a href="javascript://" onClick="pencere_ac_paymethod(#my_count#);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                                        </div>
                                        </td>
                                        <td>
                                            <div class="form-group">
                                            <cfif len(get_branch_discount.product_cat_id)>
                                                <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
                                                    SELECT PRODUCT_CATID,PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID IS NOT NULL AND PRODUCT_CATID = #get_branch_discount.product_cat_id#
                                                </cfquery>
                                                <input type="hidden" name="cat_id#my_count#" id="cat_id#my_count#" value="#get_branch_discount.product_cat_id#">
                                                <input type="text" name="category_name#my_count#" id="category_name#my_count#" value="#GET_PRODUCT_CAT.PRODUCT_CAT#" style="width:120px;">
                                            <cfelse>
                                                <input type="hidden" name="cat_id#my_count#" id="cat_id#my_count#" value="">
                                                <input type="text" name="category_name#my_count#" id="category_name#my_count#" value="" style="width:120px;">
                                            </cfif>
                                            <a href="javascript://" onClick="pencere_ac_category(#my_count#);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                                        </div>
                                        </td>
                                        <td>
                                            <div class="form-group">
                                            <cfif len(get_branch_discount.brand_id)>
                                                <cfquery name="get_brand" datasource="#DSN3#">
                                                    SELECT BRAND_NAME, BRAND_CODE FROM PRODUCT_BRANDS WHERE BRAND_ID = #get_branch_discount.brand_id#
                                                </cfquery>
                                                <input type="hidden" name="brand_id#my_count#" id="brand_id#my_count#" value="#get_branch_discount.brand_id#">
                                                <input type="text" name="brand_name#my_count#" id="brand_name#my_count#" value="#get_brand.brand_name#" style="width:120px;">
                                            <cfelse>
                                                <input type="hidden" name="brand_id#my_count#" id="brand_id#my_count#" value="">
                                                <input type="text" name="brand_name#my_count#" id="brand_name#my_count#" value="" style="width:120px;">
                                            </cfif>
                                            <a href="javascript://" onClick="pencere_ac_brand(#my_count#);"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                                        </div>
                                        </td>
                                        <td>
                                            <div class="form-group">
                                                <input type="text" name="discount#my_count#" id="discount#my_count#" value="#discount#" style="width:50px;" onKeyUp="return(FormatCurrency(this,event));">
                                        </div>
                                    </td>
                                    </tr>
                                </cfoutput>
                            </cfif>
                            <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#my_count#</cfoutput>">
                            <input type="hidden" name="counter" id="counter" value="<cfoutput>#my_count#</cfoutput>">
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="12"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                            </tr>
                        </tfoot>
                 
             
    </cf_grid_list>
</cfform>
</cf_box>
<script type="text/javascript">
	var row_count=document.branch_discount.record_num.value;
	function kontrol()
	{
		for(i=1;i<=row_count;i++)
		{
			if(eval('document.all.branch_id'+i).value == '')
			{
				alert(i+".<cf_get_lang no='2926.Satırda Lütfen Şube Seçiniz'> !");
				return false;	
			}
			if(eval("document.getElementById('discount" + i + "')").value == '')
			{	
				alert(i+".<cf_get_lang no='2928.Satırda Lütfen İskonto Değerini Giriniz'> !");
				return false;
			}
		}
		return true;
	}
	
	function sil(sy)
	{
		var my_element=eval("branch_discount.row_kontrol"+sy);
		my_element.value=0;
		document.branch_discount.counter.value=filterNum(document.branch_discount.counter.value)-1;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		document.branch_discount.counter.value=filterNum(document.branch_discount.counter.value)+1;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
		document.branch_discount.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="branch_discount_id'+row_count+'" value=""><input type="hidden" name="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"  ><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="branch_id'+row_count+'" style="width:120px;"><option value=""><cf_get_lang_main no ="322.Seçiniz"></option><cfoutput query="GET_BRANCH"><option value="#branch_id#">#branch_name#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="card_paymethod_id'+row_count+'" id="card_paymethod_id'+row_count+'" value=""><input type="hidden" name="payment_type_id' + row_count +'" value=""><input type="text" name="payment_type' + row_count +'" id="payment_type' + row_count +'" value="" style="width:120px;"><span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac_paymethod('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="cat_id' + row_count +'" value=""><input type="text" name="category_name' + row_count +'" id="category_name' + row_count +'" value="" style="width:120px;"><span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac_category('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="brand_id' + row_count +'" value=""><input type="text" name="brand_name' + row_count +'" id="brand_name' + row_count +'" value="" style="width:120px;"><span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac_brand('+ row_count +');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="discount' + row_count +'" id="discount' + row_count +'" value="" style="width:50px;" onKeyUp="return(FormatCurrency(this,event));"></div>';
	}
	function pencere_ac_paymethod(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=branch_discount.payment_type_id' + no +'&field_name=branch_discount.payment_type' + no +'&field_card_payment_id=branch_discount.card_paymethod_id'+no+'&field_card_payment_name=branch_discount.payment_type'+no,'medium');
	}
	function pencere_ac_category(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=branch_discount.cat_id'+no+'&field_name=branch_discount.category_name'+no);
	}
	function pencere_ac_brand(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id=branch_discount.brand_id'+no+'&brand_name=branch_discount.brand_name'+no,'small');
	}
</script>
