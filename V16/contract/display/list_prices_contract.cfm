<cfinclude template="../query/get_moneys.cfm">
<cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
	SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT WHERE PRICE_CAT_STATUS = 1 ORDER BY PRICE_CAT
</cfquery>
<cfif isdefined("attributes.contract_id") and len(attributes.contract_id)>
	<cfquery name="get_price_cat_exceptions" datasource="#DSN3#">
		SELECT 
        	PRICE_CAT_EXCEPTION_ID, 
            IS_GENERAL, 
            COMPANY_ID, 
            PRODUCT_CATID, 
            CONSUMER_ID, 
            BRAND_ID, 
            PRODUCT_ID, 
            PRICE_CATID, 
            DISCOUNT_RATE, 
            COMPANYCAT_ID, 
            SUPPLIER_ID, 
            ACT_TYPE, 
            IS_DEFAULT, 
            PURCHASE_SALES, 
            DISCOUNT_RATE_2, 
            DISCOUNT_RATE_3, 
            DISCOUNT_RATE_4, 
            DISCOUNT_RATE_5, 
            PAYMENT_TYPE_ID, 
            SHORT_CODE_ID, 
            CONTRACT_ID, 
            PRICE, 
            PRICE_MONEY, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP 
        FROM 
    	    PRICE_CAT_EXCEPTIONS 
        WHERE 
	        CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contract_id#"> AND ISNULL(ACT_TYPE,1) IN(1,3)
	</cfquery>
<cfelse>
	<cfset get_price_cat_exceptions.recordcount = 0>
</cfif>
<cfset row = get_price_cat_exceptions.RecordCount>
<cfform method="post" name="ajax_name" action="#request.self#?fuseaction=contract.popup_det_contract">
    <cf_grid_list>
        <thead>
            <input type="hidden" name="form_upd_" id="form_upd_" value="1">
            <input type="hidden" name="contract_id" id="contract_id" value="<cfif isdefined("attributes.contract_id") and len(attributes.contract_id)><cfoutput>#attributes.contract_id#</cfoutput></cfif>">
            <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
            <input name="record_num_" id="record_num_" type="hidden" value="<cfoutput>#row#</cfoutput>">
            <tr>
            <cfif get_module_user(17)><th width="10" style="text-align:center"><input type="button" class="eklebuton" title="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_row_cont();"></th></cfif>
                <th width="130"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></th>
                <th width="90" nowrap="nowrap"><cf_get_lang dictionary_id='57486.Kategori'></th>
                <th width="90"><cf_get_lang dictionary_id='58847.Marka'></th>
                <th width="90"><cf_get_lang dictionary_id='58225.Model'></th>
                <th width="90"><cf_get_lang dictionary_id='57657.Ürün'></th>
                <th width="90"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
                <th width="60"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                <th width="60"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <th width="50" nowrap="nowrap"><cf_get_lang dictionary_id='57641.İskonto'> 1</th>
                <th width="50" nowrap="nowrap"><cf_get_lang dictionary_id='57641.İskonto'> 2</th>
                <th width="50" nowrap="nowrap"><cf_get_lang dictionary_id='57641.İskonto'> 3</th>
                <th width="50" nowrap="nowrap"><cf_get_lang dictionary_id='57641.İskonto'> 4</th>
                <th width="50" nowrap="nowrap"><cf_get_lang dictionary_id='57641.İskonto'> 5</th>
            </tr>
        </thead>
        <tbody name="table2" id="table2">
            <cfif GET_PRICE_CAT_EXCEPTIONS.recordcount>
                <cfoutput query="GET_PRICE_CAT_EXCEPTIONS">
                    <input  type="hidden" name="row_kontrol_2#currentrow#" id="row_kontrol_2#currentrow#" value="1">
                    <tr id="frm_row_2#currentrow#">
                        <cfif get_module_user(17)><td style="cursor:pointer"><a style="cursor:pointer" onClick="sil(#currentrow#);" ><i class="fa fa-minus"></i></a></td></cfif>
                        <td>
                            <div class="form-group">
                                <select name="price_cat#get_price_cat_exceptions.currentrow#" id="price_cat#get_price_cat_exceptions.currentrow#" style="width:130px;">
                                    <cfloop query="get_price_cats">
                                        <option value="#get_price_cats.price_catid#" <cfif get_price_cat_exceptions.price_catid eq get_price_cats.price_catid>selected</cfif>>#get_price_cats.price_cat#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </td>
                        <td nowrap="nowrap">
                            <input type="hidden" name="PRODUCT_CAT_ID#get_price_cat_exceptions.currentrow#" id="PRODUCT_CAT_ID#get_price_cat_exceptions.currentrow#" value="#PRODUCT_CATID#" >
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
                                    <input type="text" name="product_cat_name#get_price_cat_exceptions.currentrow#" id="product_cat_name#get_price_cat_exceptions.currentrow#" style="width:90px;" value="#GET_PRODUCT_CAT_HIERARCHY# #GET_PRODUCT_CAT_product_cat#">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=ajax_name.PRODUCT_CAT_ID#get_price_cat_exceptions.currentrow#&field_name=ajax_name.product_cat_name#get_price_cat_exceptions.currentrow#');" title="<cf_get_lang dictionary_id='50885.Ürün Seç'>"></span>
                                </div>
                            </div>
                        </td>
                        <td nowrap="nowrap"><input type="hidden" name="brand_id#get_price_cat_exceptions.currentrow#" id="brand_id#get_price_cat_exceptions.currentrow#" value="#brand_id#" >
                            <cfif len(get_price_cat_exceptions.brand_id)>
                                <cfset attributes.brand_id = get_price_cat_exceptions.brand_id>
                                <cfquery name="get_brand_name" datasource="#DSN3#">
                                    SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
                                </cfquery>
                                <cfif get_brand_name.recordCount>
                                    <cfset get_brand_name_BRAND_NAME = get_brand_name.BRAND_NAME>
                                <cfelse>
                                    <cfset get_brand_name_BRAND_NAME = "">
                                </cfif>
                            <cfelse>
                                <cfset get_brand_name_BRAND_NAME = "">
                            </cfif>
                            <div class="form-group">
                                <div class="input-group">
                                    <input type="text" name="BRAND_NAME#get_price_cat_exceptions.currentrow#" id="BRAND_NAME#get_price_cat_exceptions.currentrow#" style="width:90px;" value="#get_brand_name_BRAND_NAME#" >
                                    <span class="input-group-addon icon-ellipsis" href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_brands&brand_id=ajax_name.brand_id#get_price_cat_exceptions.currentrow#&brand_name=ajax_name.BRAND_NAME#get_price_cat_exceptions.currentrow#');" title="<cf_get_lang dictionary_id='50885.Ürün Seç'>"></span>
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
                                    <input type="text" name="short_code#get_price_cat_exceptions.currentrow#" id="short_code#get_price_cat_exceptions.currentrow#" value="#get_product_model_MODEL_NAME#" style="width:90px;">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://"  onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_product_model&model_id=upd_cont.short_code_id#get_price_cat_exceptions.currentrow#&model_name=upd_cont.short_code#get_price_cat_exceptions.currentrow#');" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></span>
                                </div>
                            </div>
                        </td>
                        <td nowrap="nowrap"><input type="hidden" name="PRODUCT_ID#get_price_cat_exceptions.currentrow#" id="PRODUCT_ID#get_price_cat_exceptions.currentrow#" value="#PRODUCT_ID#" >
                            <cfif len(get_price_cat_exceptions.PRODUCT_ID)>
                                <cfset attributes.PID = get_price_cat_exceptions.PRODUCT_ID>
                                <cfquery name="get_product_name" datasource="#DSN3#">
                                    SELECT PRODUCT_NAME,PROD_COMPETITIVE FROM PRODUCT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.PID#">
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
                                    <input type="text" name="product_name#get_price_cat_exceptions.currentrow#"  id="product_name#get_price_cat_exceptions.currentrow#" value="#get_product_name_PRODUCT_NAME#" style="width:90px;">
                                    <span class="input-group-addon icon-ellipsis" href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_products_only&product_id=ajax_name.PRODUCT_ID#get_price_cat_exceptions.currentrow#&field_name=ajax_name.product_name#get_price_cat_exceptions.currentrow#');" title="<cf_get_lang dictionary_id='50885.Ürün Seç'>"></span>
                                </div>
                            </div>
                        </td>
                        <td width="30" nowrap="nowrap">
                            <cfinput type="hidden" name="payment_type_id#get_price_cat_exceptions.currentrow#" value="#get_price_cat_exceptions.payment_type_id#">
                            <div class="form-group">
                                <div class="input-group">
                                    <cfif len(get_price_cat_exceptions.payment_type_id)>
                                        <cfquery name="get_payment_type" datasource="#DSN#">
                                            SELECT PAYMETHOD_ID,PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_price_cat_exceptions.payment_type_id#">
                                        </cfquery>
                                        <cfinput type="text" name="payment_type#get_price_cat_exceptions.currentrow#" value="#get_payment_type.paymethod#" readonly style="width:90px;">
                                        <span class="input-group-addon icon-ellipsis" href="javascript://"onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_paymethods&is_paymethods=1&field_id=ajax_name.payment_type_id#get_price_cat_exceptions.currentrow#&field_name=ajax_name.payment_type#get_price_cat_exceptions.currentrow#');"></span>					  
                                    <cfelse>
                                        <cfinput type="text" name="payment_type#get_price_cat_exceptions.currentrow#" value="" readonly style="width:90px;">
                                        <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_paymethods&is_paymethods=1&field_id=upd_cont.payment_type_id#get_price_cat_exceptions.currentrow#&field_name=upd_cont.payment_type#get_price_cat_exceptions.currentrow#');"></span>
                                    </cfif>
                                </div>
                            </div>
                        </td>
                        <td><input type="text" name="price#get_price_cat_exceptions.currentrow#" id="price#get_price_cat_exceptions.currentrow#" value="#TLFormat(get_price_cat_exceptions.price)#" style="width:60px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></td>
                        <td nowrap>
                            <div class="form-group">
                                <select name="price_money#currentrow#" id="price_money#currentrow#" style="width:60px;" class="text">
                                    <cfloop query="get_moneys">
                                        <option value="#money#" <cfif money eq get_price_cat_exceptions.price_money>selected</cfif>>#money#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </td>
                        <td><input type="text" name="discount_info_#get_price_cat_exceptions.currentrow#" id="discount_info_#get_price_cat_exceptions.currentrow#" value="#TLFormat(DISCOUNT_RATE)#" style="width:50px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></td>
                        <td><input type="text" name="discount_info2_#get_price_cat_exceptions.currentrow#" id="discount_info2_#get_price_cat_exceptions.currentrow#" value="#TLFormat(DISCOUNT_RATE_2)#" style="width:50px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></td>
                        <td><input type="text" name="discount_info3_#get_price_cat_exceptions.currentrow#" id="discount_info3_#get_price_cat_exceptions.currentrow#" value="#TLFormat(DISCOUNT_RATE_3)#" style="width:50px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></td>
                        <td><input type="text" name="discount_info4_#get_price_cat_exceptions.currentrow#" id="discount_info4_#get_price_cat_exceptions.currentrow#" value="#TLFormat(DISCOUNT_RATE_4)#" style="width:50px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></td>
                        <td><input type="text" name="discount_info5_#get_price_cat_exceptions.currentrow#" id="discount_info5_#get_price_cat_exceptions.currentrow#" value="#TLFormat(DISCOUNT_RATE_5)#" style="width:50px;" class="moneybox" onKeyUp="return(FormatCurrency(this,event));"></td>
                    </tr>
                </cfoutput> 
            </cfif>
        </tbody>
        
    </cf_grid_list>
    <div class="ui-info-bottom flex-end">
        <cf_workcube_buttons type_format='1' is_upd='0' is_delete='0'>
    </div>
</cfform>
<script>
    	row_count_2 = <cfoutput>#get_price_cat_exceptions.RecordCount#</cfoutput>;
	function sil(sy)
	{
		var my_element=eval("ajax_name.row_kontrol_2"+sy);
		my_element.value=0;
		var my_element=eval("frm_row_2"+sy);
		my_element.style.display="none";
	}

	function add_row_cont()
	{
		row_count_2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);	
		newRow.setAttribute("name","frm_row_2" + row_count_2);
		newRow.setAttribute("id","frm_row_2" + row_count_2);		
		document.ajax_name.record_num_.value=row_count_2;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden" value="1" name="row_kontrol_2'+row_count_2 +'" ><a style="cursor:pointer" onclick="sil(' + row_count_2 + ');"><i class="fa fa-minus"></i></a>';				
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = ' <div class="form-group"><select name="price_cat' + row_count_2 + '" style="width:130px;"><cfoutput query="GET_PRICE_CATS"><option value="#PRICE_CATID#">#PRICE_CAT#</option></cfoutput></select></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden"  name="PRODUCT_CAT_ID' + row_count_2 +'" ><input type="text" name="product_cat_name' + row_count_2 + '" style="width:90px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac(' + row_count_2 + ');"></span></div></div>';			
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden"  name="brand_id' + row_count_2 +'" ><input type="text" name="brand_name' + row_count_2 + '" style="width:90px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="markaBul(' + row_count_2 + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden"  name="short_code_id' + row_count_2 +'" ><input type="text" name="short_code' + row_count_2 + '" style="width:90px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="modelBul(' + row_count_2 + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden"  name="PRODUCT_ID' + row_count_2 +'" ><input type="text" name="product_name' + row_count_2 + '" style="width:90px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_pos(' + row_count_2 + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden"  name="payment_type_id' + row_count_2 +'"><input type="text" name="payment_type' + row_count_2 + '" style="width:90px;"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_paymethod(' + row_count_2 + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="price' + row_count_2 + '" style="width:60px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		a = '<div class="form-group"><select name="price_money' + row_count_2  +'" id="money_id' + row_count_2  +'" style="width:60px;" class="moneytext"></div>';
		<cfoutput query="get_moneys">
			a += '<option value="#money#">#money#</option>';
		</cfoutput>
		newCell.innerHTML =a+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="discount_info_' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="discount_info2_' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="discount_info3_' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="discount_info4_' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="text" name="discount_info5_' + row_count_2 + '" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">';
	}
	function pencere_ac(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=ajax_name.PRODUCT_CAT_ID' + no + '&field_name=ajax_name.product_cat_name' + no);	/*&process=purchase_contract      var_=purchase_contr_cat_premium&*/
	}
	function pencere_pos(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products_only&product_id=ajax_name.PRODUCT_ID' + no + '&field_name=ajax_name.product_name' + no); /*&process=purchase_contract  var_=purchase_contr_cat_premium&*/
	}
	function pencere_paymethod(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&is_paymethods=1&field_id=ajax_name.payment_type_id' + no + '&field_name=ajax_name.payment_type' + no);
	}
	function markaBul(no)
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=ajax_name.brand_id' + no + '&brand_name=ajax_name.brand_name' + no + '</cfoutput>');
	}
	function modelBul(no)
	{
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_product_model&model_id=ajax_name.short_code_id' + no + '&model_name=ajax_name.short_code' + no + '</cfoutput>');
	}
</script>