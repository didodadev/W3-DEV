<cfquery name="get_alternative" datasource="#dsn3#">
	SELECT 
		AP.*,
		S.PRODUCT_NAME,
		S.STOCK_CODE,
		S.STOCK_ID,
        S.PRODUCT_CATID,
        PU.MAIN_UNIT,
        C.FULLNAME,
        SAQ.QUESTION_DETAIL
	FROM 
		ALTERNATIVE_PRODUCTS AP
        LEFT JOIN #dsn#.COMPANY AS C ON C.COMPANY_ID = AP.COMPANY_ID
        LEFT JOIN #dsn#.SETUP_ALTERNATIVE_QUESTIONS AS SAQ ON SAQ.QUESTION_ID = AP.QUESTION_ID,
		STOCKS S,
        PRODUCT_UNIT PU
	WHERE 
		S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID AND
		S.STOCK_ID = AP.STOCK_ID AND
        S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID  
		<cfif isdefined('attributes.product_id') and len(attributes.product_id)>
		   AND AP.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		</cfif> 
        <cfif isdefined('attributes.product_tree_id') and len(attributes.product_tree_id) and attributes.type eq 1>
            AND PRODUCT_TREE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_tree_id#">
        </cfif>
	ORDER BY ALTERNATIVE_PRODUCT_NO
</cfquery>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>
    <cf_grid_list id="table#attributes.counter#_#attributes.product_id#">
        <thead>
            <cfif attributes.type eq 1>
                <tr>
                    <th colspan="12"><cf_get_lang dictionary_id='63590.Versiyonlar'>: <cfoutput>#get_alternative.QUESTION_DETAIL#</cfoutput></th>
                </tr>
            <cfelse>
                <tr>
                    <th colspan="14"><cf_get_lang dictionary_id='29745.Tedarik'>: <cf_get_lang dictionary_id='45311.Alternatif Ürünler'></th>
                </tr>
            </cfif>
            <tr>
                <cfif attributes.type eq 2>
                <th>
					<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_products_only&counter=#attributes.counter#&stock_id=purchase_plan_form_#attributes.counter#.stock_id&product_catid=#get_alternative.product_catid#&is_alternative_products=1&product_id=add_product_alternative.anative_product_id&field_name=add_product_alternative.product_name&call_function=get_product_main_spec_row&call_function_parameter=#get_alternative.recordCount#&row_info=#get_alternative.recordCount#</cfoutput>');"  title="<cf_get_lang_main no ='170.Ekle'>"><i class="fa fa-plus"></i></a>
                </th>
                </cfif>
                <th width="10"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                <th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
                <th width="170"><cf_get_lang dictionary_id='57647.Spekt'></th>
                <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                <th><cf_get_lang dictionary_id='57636.Birim'></th>
                <th><cf_get_lang dictionary_id='62606.Hedef Fiyat'></th>
                <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
                <th><cf_get_lang dictionary_id='57634.Üretici Kodu'></th>
                <th><cf_get_lang dictionary_id='63567.Alım Fiyatı'></th>
                <th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <th><cf_get_lang dictionary_id='63568.Tedarikçi Puanı'></th>
            </tr>
        </thead>
        <tbody>
            <input type="hidden" name="alternative_count" id="alternative_count" value="<cfoutput>#get_alternative.recordCount#</cfoutput>">
            <input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.product_id#</cfoutput>">
            <cfoutput query="get_alternative">
                <tr id="row#currentrow#">
                    <cfif attributes.type eq 2>
                        <td><a onclick="sil<cfoutput>#attributes.counter#</cfoutput>('#currentrow#');"><i class="fa fa-minus" title="Sil "></i></a></td>
                    </cfif>
                    <td>#currentrow#</td>
                    <td>#PRODUCT_NAME#</td>
                    <td>#STOCK_CODE#</td>
                    <td class="text-center">
                        <div class="form-group">
                            <div class="input-group">
                                <cfif len(SPECT_MAIN_ID)>
                                    #SPECT_MAIN_ID#<span class="input-group-addon icon-ellipsis"  onclick="windowopen('index.cfm?fuseaction=objects.popup_upd_spect&upd_main_spect=1&spect_main_id=#SPECT_MAIN_ID#','list');"></span>
                                </cfif>
                            </div>
                        </div>   
                    </td>
                    <td class="text-right"> <input type="text" style="width:35px;text-align:right;" name="quantity#currentrow#" value="#TlFormat(QUANTITY)#"></td>
                    <td>#MAIN_UNIT#</td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="alternative_target_price_#currentrow#" value="#( len( TARGET_PRICE ) ) ? tlformat(TARGET_PRICE) : ''#"  class="moneybox" onkeyup="return(FormatCurrency(this,event,2))">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <select name="alternative_target_currency_#currentrow#">
                                <cfloop query="GET_MONEY">
                                    <option value="#MONEY#" <cfif money eq get_alternative.TARGET_PRICE_CURRENCY> selected </cfif>>#MONEY#</option>
                                </cfloop>
                            </select>
                        </div>
                    </td>
                    <td class="text-center">
                        <div class="form-group">
                            <div class="input-group">
                                <input type="hidden" name="alternative_id_#currentrow#" id="alternative_id_#currentrow#" value="#ALTERNATIVE_ID#">
                                <input type="hidden" name="alternative_supplier_company_id_#currentrow#" id="alternative_supplier_company_id_#currentrow#" value="#( len( COMPANY_ID ) ) ? COMPANY_ID : ''#">
                                <input type="text" name="alternative_supplier_company_#currentrow#" id="alternative_supplier_company_#currentrow#" value="#( len( COMPANY_ID ) ) ? FULLNAME : '' #">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=purchase_plan_form_#attributes.counter#.alternative_supplier_company_id_#currentrow#&field_comp_name=purchase_plan_form_#attributes.counter#.alternative_supplier_company_#currentrow#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2');" title="<cf_get_lang dictionary_id='170.Ekle'>"></span>
                            </div>
                        </div>   
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="alternative_production_code_#currentrow#" value="#( len( PRODUCTION_CODE ) ) ? PRODUCTION_CODE : ''#">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="text" name="alternative_buy_amount_#currentrow#" class="moneybox" value="#( len( LAST_PRICE ) ) ? tlformat(LAST_PRICE) : ''#" onkeyup="return(FormatCurrency(this,event,2))">
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <select name="last_price_currency_#currentrow#">
                                <cfloop query="GET_MONEY">
                                    <option value="#MONEY#" <cfif money eq get_alternative.LAST_PRICE_CURRENCY> selected </cfif>>#MONEY#</option>
                                </cfloop>
                            </select>
                        </div>
                    </td>
                    <td>
                        <div class="form-group">
                            <input type="number" name="alternative_techinal_point_#currentrow#" value="#( len( TECHNICAL_POINT ) ) ? TECHNICAL_POINT : ''#">
                        </div>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </cf_grid_list>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <div class="ui-form-list-btn">
            <a href="javascript://" class="ui-ripple-btn btn-success" onclick="kontrol2(<cfoutput>#attributes.counter#,#attributes.type#</cfoutput>)"><cf_get_lang dictionary_id='57461.Kaydet'></a>
        </div>        
    </div>
<script>
   
    row_count = <cfoutput>#get_alternative.recordcount#</cfoutput>;
    satir_say = <cfoutput>#get_alternative.recordcount#</cfoutput>;

function sil<cfoutput>#attributes.counter#</cfoutput>(row){
    if ( $("#alternative_id_"+row).val() != '' ){
        if( confirm("Silmek istediğinize emin misiniz ?") ){
            var data = new FormData();  
                data.append("alternative_id", $("#alternative_id_"+row).val());
                AjaxControlPostDataJson("V16/production_plan/cfc/get_tree.cfc?method=del_alternative", data, function(response){
                    if( response.STATUS ){
                        alert(response.MESSAGE);
                        location.reload();
                    }
                });
            return false; 
        }
    }else{
        var my_element = eval("row" + row);
            my_element.remove();
            satir_say--;
            document.getElementById("alternative_count").value = satir_say;
        }
}
   

function product_gonder<cfoutput>#attributes.counter#</cfoutput>(product_id,product_name,stock_code,stock_id,unit){
    QueryTextSpec = 'prdp_get_main_spec_id_3';
    var get_main_spec_id_ = wrk_safe_query(QueryTextSpec,'dsn3',0,stock_id);
    if(get_main_spec_id_.recordcount){
        spect_main_id = get_main_spec_id_.SPECT_MAIN_ID ;
        spect_main_name = get_main_spec_id_.SPECT_MAIN_NAME ;
    }else{
        spect_main_id = "" ;
        spect_main_name = "";
    }
    row_count++;
    satir_say++;
    var newRow;
    var newCell;
    newRow = document.getElementById("table<cfoutput>#attributes.counter#_#attributes.product_id#</cfoutput>").insertRow(document.getElementById("table<cfoutput>#attributes.counter#_#attributes.product_id#</cfoutput>").rows.length);
    newRow.setAttribute("name","row" + row_count);
    newRow.setAttribute("id","row" + row_count);		
    newRow.setAttribute("NAME","row" + row_count);
    newRow.setAttribute("ID","row" + row_count);		
    newRow.className = 'color-row';
    document.getElementById("alternative_count").value = row_count;
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<a onclick="sil<cfoutput>#attributes.counter#</cfoutput>(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = row_count;
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = product_name;
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+ product_id +'"><input type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+ stock_id +'"><input type="text" name="stock_code' + row_count +'" id="stock_code' + row_count +'" value="'+stock_code+'" readonly><input type="hidden" name="product_name' + row_count +'" id="product_name' + row_count +'" value="'+ product_name +'" onkeyup="isNumber(this);" readonly>';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.setAttribute('nowrap','nowrap');
    newCell.innerHTML = '<div class="form-group"><div class="col col-3"><input type="text" name="spect_main_id'+ row_count +'" id="spect_main_id'+ row_count +'" value="'+spect_main_id+'">-</div><div class="input-group" class="col col-9"><input type="text" name="spect_main_name'+ row_count +'" id="spect_main_name'+ row_count +'" value="'+spect_main_name+'" readonly><span class="input-group-addon icon-ellipsis btnPointer" onClick="open_spec<cfoutput>#attributes.counter#</cfoutput>('+ row_count +');"  id="'+ row_count +'""></span><div><div>';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.setAttribute('align','right');
    newCell.innerHTML =  '<input type="text" style="width:20px;text-align:right;" name="quantity'+ row_count +'" id="quantity'+ row_count +'" value="1">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = unit;
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" class="moneybox" name="alternative_target_price_' + row_count +'" id="alternative_target_price_' + row_count +'" value="" onkeyup="return(FormatCurrency(this,event,4));">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = "<div class='form-group'><select name='alternative_target_currency_"+row_count+"' id='alternative_target_currency_"+row_count+"' ><cfoutput query="get_money"><option value='#MONEY#'>#MONEY#</option></cfoutput></select></div>";
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.setAttribute('nowrap','nowrap');
    newCell.innerHTML ='<div class="form-group"><div class="input-group"><input type="hidden" name="alternative_id_'+row_count+'" id="alternative_id_'+row_count+'" ><input type="hidden" name="alternative_supplier_company_id_' + row_count +'" id="alternative_supplier_company_id_' + row_count +'" value="" onkeyup=""><input type="text" name="alternative_supplier_company_' + row_count +'" id="alternative_supplier_company_' + row_count +'" value="" onkeyup=""> <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable(\'<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=purchase_plan_form_<cfoutput>#attributes.counter#</cfoutput>.alternative_supplier_company_'+row_count+'&field_comp_id=purchase_plan_form_<cfoutput>#attributes.counter#</cfoutput>.alternative_supplier_company_id_'+row_count+'&select_list=2&is_form_submitted=1&keyword=\'+document.purchase_plan_form_<cfoutput>#attributes.counter#</cfoutput>.alternative_supplier_company_'+row_count+'.value);"></span></div></div>';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="alternative_production_code_' + row_count +'" id="alternative_production_code_' + row_count +'" value=""> ';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="text" name="alternative_buy_amount_' + row_count +'" id="alternative_buy_amount_' + row_count +'" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">';
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = "<div class='form-group'><select name='last_price_currency_"+row_count+"' id='last_price_currency_"+row_count+"' ><cfoutput query="get_money"><option value='#MONEY#'>#MONEY#</option></cfoutput></select></div>";
    newCell = newRow.insertCell(newRow.cells.length);
    newCell.innerHTML = '<input type="number" name="alternative_techinal_point_' + row_count +'" id="alternative_techinal_point_' + row_count +'" value="">';
}
function open_spec<cfoutput>#attributes.counter#</cfoutput>(row_info){
    form_name="purchase_plan_form_<cfoutput>#attributes.counter#</cfoutput>";
		if(document.getElementById('stock_id'+row_info).value.length > 0 && document.getElementById('product_name'+row_info).value.length > 0){
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1&basket_id=1&field_name='+form_name+'.spect_main_name'+row_info+'&field_main_id='+form_name+'.spect_main_id'+row_info+'&stock_id='+document.getElementById('stock_id'+row_info).value);
		}	
		else
			alert("<cf_get_lang dictionary_id ='36677.Ürün Seçmelisiniz'>!");
	}

</script>

