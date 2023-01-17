<!--- act_type 1 olanlar istisnai fiyat listesi --->
<cf_get_lang_set module_name="contract">
<cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
	SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> ORDER BY PRICE_CAT
</cfquery>
<cfquery name="get_price_cat_exceptions" datasource="#DSN3#">
	SELECT * FROM PRICE_CAT_EXCEPTIONS WHERE CONTRACT_ID IS NULL AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND ISNULL(ACT_TYPE,1) IN(1,3)
</cfquery>
<cfset row = get_price_cat_exceptions.RecordCount>
<cfform name="form_price_cat" method="post" action="#request.self#?fuseaction=contract.emptypopoup_add_company_price_cat">
    <cf_grid_list>
        <thead>
            <tr>
                <cfif get_module_user(17)><th width="10"><a onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th></cfif>
                <th width="200"><cf_get_lang dictionary_id='58964.Fiyat Listesi'>
                    <input type="hidden" name="form_upd_" id="form_upd_" value="1">
                    <input type="hidden"  name="record_num" id="record_num"  value="<cfoutput>#row#</cfoutput>">
                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                </th>
                <th width="125"><cf_get_lang dictionary_id='57486.Kategori'></th>
                <th width="125"><cf_get_lang dictionary_id='58847.Marka'></th>
                <th width="125"><cf_get_lang dictionary_id='58225.Model'></th>
                <th width="125"><cf_get_lang dictionary_id='57657.Ürün'></th>
                <th width="125"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
                <th width="60" nowrap="nowrap"><cf_get_lang dictionary_id='57641.İskonto'> 1</th>
                <th width="60" nowrap="nowrap"><cf_get_lang dictionary_id='57641.İskonto'> 2</th>
                <th width="60" nowrap="nowrap"><cf_get_lang dictionary_id='57641.İskonto'> 3</th>
                <th width="60" nowrap="nowrap"><cf_get_lang dictionary_id='57641.İskonto'> 4</th>
                <th width="60" nowrap="nowrap"><cf_get_lang dictionary_id='57641.İskonto'> 5</th>
            </tr>
        </thead>
        <tbody name="table4" id="table4">
            <cfoutput query="GET_PRICE_CAT_EXCEPTIONS">
                <tr id="frm_row_4#currentrow#">
                    <cfif get_module_user(17)><td><a onclick="sil(#currentrow#);" ><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></a></i></td></cfif>
                    <td>
                        <div class="form-group">
                            <select id="price_cat#get_price_cat_exceptions.currentrow#" name="price_cat#get_price_cat_exceptions.currentrow#">
                                <cfloop query="get_price_cats">
                                    <option value="#get_price_cats.price_catid#" <cfif get_price_cat_exceptions.price_catid eq get_price_cats.price_catid>selected</cfif>>#get_price_cats.PRICE_CAT#</option>
                                </cfloop>
                            </select>
                            <input  type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                        </div>
                    </td>
                    <td nowrap="nowrap">
                        <input type="hidden" name="product_cat_id#get_price_cat_exceptions.currentrow#" id="product_cat_id#get_price_cat_exceptions.currentrow#" value="#PRODUCT_CATID#" >
                        <cfif len(get_price_cat_exceptions.PRODUCT_CATID)>
                            <cfset attributes.id = get_price_cat_exceptions.product_catid>
                            <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
                                SELECT 
                                    PRODUCT_CATID, 
                                    HIERARCHY, 
                                    PRODUCT_CAT
                                FROM
                                    PRODUCT_CAT
                                WHERE
                                    PRODUCT_CATID IS NOT NULL
                                <cfif isDefined("attributes.id")>AND PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
                                <cfelseif isDefined("attributes.hier")>AND HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hier#"></cfif>
                                ORDER BY
                                    HIERARCHY
                            </cfquery>					
                            <cfif GET_PRODUCT_CAT.recordCount>
                                <cfset GET_PRODUCT_CAT_product_cat = GET_PRODUCT_CAT.product_cat>
                                <cfset GET_PRODUCT_CAT_HIERARCHY = GET_PRODUCT_CAT.HIERARCHY>
                            <cfelse>
                                <cfset GET_PRODUCT_CAT_product_cat = "">
                                <cfset GET_PRODUCT_CAT_HIERARCHY = "">
                            </cfif>
                        <cfelse>
                            <cfset GET_PRODUCT_CAT_product_cat = "">
                            <cfset GET_PRODUCT_CAT_HIERARCHY = "">
                        </cfif>
                        <div class="form-group">
                            <div class="input-group">
                                <input type="text" name="product_cat_name#get_price_cat_exceptions.currentrow#" id="product_cat_name#get_price_cat_exceptions.currentrow#" value="#GET_PRODUCT_CAT_HIERARCHY# #GET_PRODUCT_CAT_product_cat#"><span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=form_price_cat.product_cat_id#get_price_cat_exceptions.currentrow#&field_name=form_price_cat.product_cat_name#get_price_cat_exceptions.currentrow#');"></span></div></div>
                            </div>
                        </div>
                    </td>
                    <td nowrap="nowrap">
                        <cfif len(brand_id)>
                            <cfquery name="get_brand_name" datasource="#DSN3#">
                                SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = #brand_id#
                            </cfquery>
                            <cfif get_brand_name.recordcount>
                                <cfset get_brand_name_BRAND_NAME = get_brand_name.BRAND_NAME>
                            <cfelse>
                                <cfset get_brand_name_BRAND_NAME = "">
                            </cfif>
                        <cfelse>
                            <cfset get_brand_name_BRAND_NAME = "">
                        </cfif>
                        <div class="form-group">
                            <div class="input-group">
                                <input type="hidden" name="brand_id#get_price_cat_exceptions.currentrow#" id="brand_id#get_price_cat_exceptions.currentrow#" value="#brand_id#">
                                <input type="text" name="BRAND_NAME#get_price_cat_exceptions.currentrow#" id="BRAND_NAME#get_price_cat_exceptions.currentrow#" value="#get_brand_name_BRAND_NAME#"><span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_brands&brand_id=form_price_cat.brand_id#get_price_cat_exceptions.currentrow#&brand_name=form_price_cat.BRAND_NAME#get_price_cat_exceptions.currentrow#','','ui-draggable-box-small');"></span>
                            </div>
                        </div>
                    </td>
                    <td nowrap="nowrap">
                        <input type="hidden" name="short_code_id#get_price_cat_exceptions.currentrow#" id="short_code_id#get_price_cat_exceptions.currentrow#" value="#short_code_id#">
                        <cfif len(get_price_cat_exceptions.short_code_id)>
                            <cfset attributes.short_code_id = get_price_cat_exceptions.short_code_id>
                        <cfquery name="get_product_model" datasource="#DSN1#">
                            SELECT 
                                MODEL_ID,
                                MODEL_NAME
                            FROM 
                                PRODUCT_BRANDS_MODEL
                            WHERE
                                MODEL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
                        </cfquery>
                        <cfif get_product_model.recordcount>
                            <cfset get_product_model_MODEL_NAME = get_product_model.MODEL_NAME>
                        <cfelse>
                            <cfset get_product_model_MODEL_NAME = "">
                        </cfif>
                        <cfelse>
                            <cfset get_product_model_MODEL_NAME = "">
                        </cfif>
                        <div class="form-group">
                            <div class="input-group">
                                <input type="text" name="short_code#get_price_cat_exceptions.currentrow#" id="short_code#get_price_cat_exceptions.currentrow#" value="#get_product_model_MODEL_NAME#"><span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_product_model&model_id=form_price_cat.short_code_id#get_price_cat_exceptions.currentrow#&model_name=form_price_cat.short_code#get_price_cat_exceptions.currentrow#','','ui-draggable-box-small');"></span>
                            </div>
                        </div>
                    </td>
                    <td nowrap="nowrap">
                        <cfif len(get_price_cat_exceptions.PRODUCT_ID)>
                        <cfset attributes.PID = get_price_cat_exceptions.PRODUCT_ID>
                            <cfquery name="get_product_name" datasource="#DSN3#">
                                SELECT PRODUCT_NAME, PROD_COMPETITIVE FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PID#">
                            </cfquery>
                        <cfif get_product_name.recordCount>
                            <cfset get_product_name_PRODUCT_NAME = get_product_name.PRODUCT_NAME>
                        <cfelse>
                            <cfset get_product_name_PRODUCT_NAME = "">
                        </cfif>
                        <cfelse>
                            <cfset get_product_name_PRODUCT_NAME = "">
                        </cfif>
                        <div class="form-group">
                            <div class="input-group">
                                <input type="hidden" name="PRODUCT_ID#get_price_cat_exceptions.currentrow#" id="PRODUCT_ID#get_price_cat_exceptions.currentrow#" value="#PRODUCT_ID#" >
                                <input type="text" name="product_name#get_price_cat_exceptions.currentrow#"  id="product_name#get_price_cat_exceptions.currentrow#" value="#get_product_name_PRODUCT_NAME#"><span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_products_only&product_id=form_price_cat.PRODUCT_ID#get_price_cat_exceptions.currentrow#&field_name=form_price_cat.product_name#get_price_cat_exceptions.currentrow#');"></span>
                            </div>
                        </div>
                    </td>
                    <td nowrap="nowrap">
                        <div class="form-group">
                            <div class="input-group">
                                <cfinput type="hidden" name="payment_type_id#get_price_cat_exceptions.currentrow#" value="#get_price_cat_exceptions.payment_type_id#">
                                <cfif len(get_price_cat_exceptions.payment_type_id)>
                                    <cfquery name="get_payment_type" datasource="#DSN#">
                                        SELECT PAYMETHOD_ID,PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_price_cat_exceptions.payment_type_id#">
                                    </cfquery>
                                    <cfinput type="text" name="payment_type#get_price_cat_exceptions.currentrow#" value="#get_payment_type.paymethod#" readonly><span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_paymethods&is_paymethods=1&field_id=form_price_cat.payment_type_id#get_price_cat_exceptions.currentrow#&field_name=form_price_cat.payment_type#get_price_cat_exceptions.currentrow#');"></span>
                                <cfelse>
                                    <cfinput type="text" name="payment_type#get_price_cat_exceptions.currentrow#" value="" readonly>
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_paymethods&is_paymethods=1&field_id=form_price_cat.payment_type_id#get_price_cat_exceptions.currentrow#&field_name=form_price_cat.payment_type#get_price_cat_exceptions.currentrow#');"></span>
                                </cfif>
                            </div>
                        </div>
                    </td>
                    <td><input type="text" name="discount_info_#get_price_cat_exceptions.currentrow#" id="discount_info_#get_price_cat_exceptions.currentrow#" value="#TLFormat(DISCOUNT_RATE)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="discount_info2_#get_price_cat_exceptions.currentrow#" id="discount_info2_#get_price_cat_exceptions.currentrow#" value="#TLFormat(DISCOUNT_RATE_2)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="discount_info3_#get_price_cat_exceptions.currentrow#" id="discount_info3_#get_price_cat_exceptions.currentrow#" value="#TLFormat(DISCOUNT_RATE_3)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="discount_info4_#get_price_cat_exceptions.currentrow#" id="discount_info4_#get_price_cat_exceptions.currentrow#" value="#TLFormat(DISCOUNT_RATE_4)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></td>
                    <td><input type="text" name="discount_info5_#get_price_cat_exceptions.currentrow#" id="discount_info5_#get_price_cat_exceptions.currentrow#" value="#TLFormat(DISCOUNT_RATE_5)#" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
    <cf_box_footer>
        <div class="col col-6">
            <cf_record_info query_name="GET_PRICE_CAT_EXCEPTIONS">
        </div>
        <div class="col col-6">
            <cf_workcube_buttons is_upd='1' type_format='1' is_delete="0">
        </div>
    </cf_box_footer>
</cfform>
<script type="text/javascript">
$(document).ready(function(){
		row_count=<cfoutput>#row#</cfoutput>;
});
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row_4"+sy);
		my_element.style.display="none";
	}
	function kontrol_et()
	{
		if(row_count ==0)
			return false;
		else
			return true;
	}
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table4").insertRow(document.getElementById("table4").rows.length);	
		newRow.setAttribute("name","frm_row_4" + row_count);
		newRow.setAttribute("id","frm_row_4" + row_count);		
		document.getElementById('record_num').value = row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" value="1" id="row_kontrol'+row_count +'" name="row_kontrol'+row_count +'" ><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="Sil"></i></a>';				
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><select name="price_cat' + row_count + '" id="price_cat' + row_count + '"><cfoutput query="GET_PRICE_CATS"><option value="#PRICE_CATID#">#PRICE_CAT#</option></cfoutput></select></div>';
		newCell.setAttribute('nowrap','nowrap');
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden"  id="product_cat_id' + row_count +'"  name="product_cat_id' + row_count +'" ><input type="text"  id="product_cat_name' + row_count + '" name="product_cat_name' + row_count + '"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac(' + row_count + ');"></span></div></div>';			
		newCell.setAttribute('nowrap','nowrap');
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden"  id="brand_id' + row_count +'" name="brand_id' + row_count +'" ><input type="text"  id="brand_name' + row_count + '" name="brand_name' + row_count + '"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="markaBul(' + row_count + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" id="short_code_id' + row_count +'"  name="short_code_id' + row_count +'" ><input type="text"  id="short_code' + row_count + '" name="short_code' + row_count + '"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="modelBul(' + row_count + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" id="PRODUCT_ID' + row_count +'"  name="PRODUCT_ID' + row_count +'" ><input type="text"  id="product_name' + row_count + '" name="product_name' + row_count + '"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_pos(' + row_count + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" id="payment_type_id' + row_count +'" name="payment_type_id' + row_count +'"><input type="text" name="payment_type' + row_count + '"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_paymethod(' + row_count + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="discount_info_' + row_count + '" id="discount_info_' + row_count + '" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="discount_info2_' + row_count + '" id="discount_info2_' + row_count + '" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text"  name="discount_info3_' + row_count + '" id="discount_info3_' + row_count + '" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="discount_info4_' + row_count + '" id="discount_info4_' + row_count + '" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="discount_info5_' + row_count + '" id="discount_info5_' + row_count + '" class="moneybox" onkeyup="return(FormatCurrency(this,event));"></div>';
	}
	function pencere_ac(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&is_form_submitted=1&field_id=form_price_cat.product_cat_id' + no + '&field_name=form_price_cat.product_cat_name' + no );	/*&process=purchase_contract      var_=purchase_contr_cat_premium&*/
	}
	function pencere_pos(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products_only&is_form_submitted=1&product_id=form_price_cat.PRODUCT_ID' + no + '&field_name=form_price_cat.product_name' + no); /*&process=purchase_contract  var_=purchase_contr_cat_premium&*/
	}
	function pencere_paymethod(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&is_paymethods=1&is_form_submitted=1&field_id=form_price_cat.payment_type_id' + no + '&field_name=form_price_cat.payment_type' + no);
	}
	function markaBul(no)
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&is_form_submitted=1&brand_id=form_price_cat.brand_id' + no + '&brand_name=form_price_cat.brand_name' + no + '</cfoutput>','','ui-draggable-box-small');
	}
	function modelBul(no)
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_product_model&is_form_submitted=1&model_id=form_price_cat.short_code_id' + no + '&model_name=form_price_cat.short_code' + no + '</cfoutput>','','ui-draggable-box-small');
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
