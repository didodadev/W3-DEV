<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.prom_condition_id") and attributes.prom_condition_id gt 0>
	<cfquery name="GET_COND" datasource="#DSN3#">
		SELECT 
        	TOTAL_PRODUCT_AMOUNT,
            CATALOG_ID,
            TOTAL_PRODUCT_PRICE,
            TOTAL_PRODUCT_PRICE_LAST,
            TOTAL_PRODUCT_POINT,
            LIST_WORK_TYPE 
        FROM 
        	PROMOTION_CONDITIONS 
        WHERE 
        	PROM_CONDITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_condition_id#">
	</cfquery>
	<cfquery name="GET_COND_PRODUCTS" datasource="#DSN3#">
		SELECT 
			PP.PRODUCT_ID,
            PP.STOCK_ID,
            PP.CATALOG_PAGE_NUMBER,
            PP.PRODUCT_AMOUNT,
            PP.IS_SALE_WITH_PROM,
			<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>P.PRODUCT_CODE_2 AS PRODUCT_CODE<cfelse>P.PRODUCT_CODE</cfif>,
			P.PRODUCT_NAME 
		FROM 
			PROMOTION_CONDITIONS_PRODUCTS PP,
			PRODUCT P
		WHERE 
			PP.PROM_CONDITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_condition_id#"> AND 
            PP.PRODUCT_ID = P.PRODUCT_ID
		ORDER BY
			P.PRODUCT_CODE_2
	</cfquery>
<cfelse>
	<cfset get_cond.recordcount = 0>
	<cfset get_cond_products.recordcount = 0>
</cfif>
<cfoutput>
	<input type="hidden" id="row_control_prom_#attributes.row_id#" name="row_control_prom_#attributes.row_id#" value="1">
    <div class="row">
    	<div class="col col-12">
			<div class="form-group">
				<label class="bold"><cf_get_lang dictionary_id ='37934.Koşul'>#attributes.row_id# <cfif get_cond_products.recordcount>(Ürün Sayısı : <cfoutput>#get_cond_products.recordcount#</cfoutput>)</cfif></label>
				<div class="pull-left">
					<cfif isdefined("attributes.prom_condition_id") and attributes.prom_condition_id gt 0><a href="javascript://" onclick="open_file_#attributes.row_id#();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='29410.Ürün Ekle'>" align="absmiddle" style="cursor:pointer;"></i></a></cfif><a href="javascript://" onclick="del_condition(#attributes.row_id#);"><i class="fa fa-minus" border="0" title="<cf_get_lang dictionary_id='57238.Koşul'> <cf_get_lang dictionary_id ='57463.Sil'>"></i></a>
					<div id="prom_condition_file_#attributes.row_id#" style="position:absolute; margin-left:-150px;"></div>
				</div>
			</div>
        </div>
        <div class="col col-12">
        	<div class="row" id="product_condition">
            	<div class="col col-12">
					<div class="form-group">
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37533.Toplam Adet'></label>
                        <div class="col col-8 col-xs-12">
                        	<input type="text" name="product_count_#attributes.row_id#" id="product_count_#attributes.row_id#" onkeyup="isNumber(this);" style="width:50px;" class="moneybox" <cfif get_cond.recordcount>value="#get_cond.total_product_amount#"</cfif>>
                        </div>
                    </div>
                    <div class="form-group">
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37216.Katalog'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
								<cfif get_cond.recordcount and len(get_cond.catalog_id)>
                                    <cfquery name="GET_CATALOG" datasource="#DSN3#">
                                        SELECT CATALOG_ID,CATALOG_HEAD FROM CATALOG_PROMOTION WHERE CATALOG_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cond.catalog_id#">
                                    </cfquery>
                                </cfif>	
                                <input type="hidden" name="catalog_id_#attributes.row_id#" id="catalog_id_#attributes.row_id#" value="<cfif get_cond.recordcount and len(get_cond.catalog_id)>#get_cond.catalog_id#</cfif>">
                                <input type="text" name="catalog_name_#attributes.row_id#" id="catalog_name_#attributes.row_id#" value="<cfif get_cond.recordcount and len(get_cond.catalog_id)>#get_catalog.catalog_head#</cfif>" style="width:100px;">
                        		<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_catalog_promotion&field_id=add_prom.catalog_id_#attributes.row_id#&is_applied_info=1&field_name=add_prom.catalog_name_#attributes.row_id#<cfif attributes.row_id eq 1>&field_id_2=add_prom.catalog_id&field_name_2=add_prom.catalog_name</cfif>','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group"><!---BK sorun cikarsa bu degiskene bakilmali--->
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29534.Toplam Tutar'></label>
                        <div class="col col-8 col-xs-12">
                        	<div class="input-group">
                            	<input type="text" name="product_amount_#attributes.row_id#" id="product_amount_#attributes.row_id#" onkeyup="return(FormatCurrency(this,event));" style="width:50px;" class="moneybox" <cfif get_cond.recordcount>value="#tlformat(get_cond.total_product_price)#"</cfif>>
                            	<span class="input-group-addon no-bg">/</span>
                                <input type="text" name="total_product_amount_2_#attributes.row_id#" id="total_product_amount_2_#attributes.row_id#" onkeyup="return(FormatCurrency(this,event));" style="width:50px;" class="moneybox" <cfif get_cond.recordcount>value="#tlformat(get_cond.total_product_price_last)#"</cfif>>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58985.Toplam Puan'></label>
                        <div  class="col col-8 col-xs-12">
                        	<input type="text" name="product_point_#attributes.row_id#" id="product_point_#attributes.row_id#" onkeyup="isNumber(this);" style="width:50px;" class="moneybox" <cfif get_cond.recordcount>value="#get_cond.total_product_point#"</cfif>>
                        </div>
                    </div>
                    <div class="form-group">
                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37640.Liste Çalışma Şekli'></label>
                        <div class="col col-4 col-xs-12">
                        	<label><input type="checkbox" name="prom_list_status_and_#attributes.row_id#" id="prom_list_status_and_#attributes.row_id#" value="1" onclick="check_list_status_#attributes.row_id#(1);" <cfif get_cond.recordcount and get_cond.list_work_type eq 1>checked<cfelseif get_cond.recordcount eq 0>checked</cfif>><cf_get_lang dictionary_id ='37669.Listedeki Tüm Ürünler'></label>
                        </div>
						<div class="col col-4 col-xs-12">
							<label><input type="checkbox" name="prom_list_status_or_#attributes.row_id#" id="prom_list_status_or_#attributes.row_id#" value="1" onclick="check_list_status_#attributes.row_id#(2);" <cfif get_cond.recordcount and get_cond.list_work_type eq 0>checked</cfif>> <cf_get_lang dictionary_id ='37670.Ürünlerden Herhangi Biri'></label>
						</div>
                    </div>
				</div>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='58942.Ürün Listesi'></cfsavecontent>
                <cf_seperator title="#message#" id="urun_listesi_#row_id#">
                <div class="col col-12">
                <table id="urun_listesi_#row_id#">
                    <tr>
                        <td>
                        <div style="position:absolute; margin-left:5px; margin-top:25px;" id="open_process_#attributes.row_id#"></div>
                        	<cf_grid_list class="workDevList">
                                <thead>
                                    <tr>
                                        <th>
                                            <a onclick="open_process_row_#attributes.row_id#();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='37697.Hızlı Ürün Ekle'>" align="absmiddle" style="cursor:pointer;"></i></a>
                                        </th>
                                        <th>
                                            <input type="hidden" name="record_num1_#attributes.row_id#" id="record_num1_#attributes.row_id#" value="<cfif get_cond.recordcount>#get_cond_products.recordcount#</cfif>">
                                            <a onclick="add_product_#attributes.row_id#();"><i class="fa fa-plus" title="Ürün Ekle" align="absmiddle" style="cursor:pointer;"></i></a>
                    
                                        </th>
                                        <th class="txtbold" width="65"><cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1><cf_get_lang dictionary_id='57789.Özel Kod'><cfelse><cf_get_lang dictionary_id ='57518.Stok Kodu'></cfif></th>
                                        <th class="txtbold" width="120"><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                                        <th class="txtbold" width="55"><cf_get_lang dictionary_id ='37936.Sayfa No'></th>
                                        <th class="txtbold"><cf_get_lang dictionary_id ='58082.Adet'></th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody id="table_product_#attributes.row_id#">
                                    <cfif get_cond_products.recordcount>
                                        <cfloop query="get_cond_products">
                                            <tr id="frm_row_product_#attributes.row_id#_#get_cond_products.currentrow#">
                                                <td></td>
                                                <td><input  type="hidden" value="1" name="row_kontrol1_#attributes.row_id#_#get_cond_products.currentrow#" id="row_kontrol1_#attributes.row_id#_#get_cond_products.currentrow#"><a href="javascript://" onclick="sil1_#attributes.row_id#(#get_cond_products.currentrow#);"><img  src="images/delete_list.gif" border="0"></a></td>
                                                <td><input type="text" name="stock_code_#attributes.row_id#_#get_cond_products.currentrow#" id="stock_code_#attributes.row_id#_#get_cond_products.currentrow#" class="text" style="width:60px;" readonly value="#get_cond_products.product_code#"></td>
                                                <td>
                                                <div class="input-group">
                                                    <input  type="hidden" name="product_id_#attributes.row_id#_#get_cond_products.currentrow#" id="product_id_#attributes.row_id#_#get_cond_products.currentrow#" value="#product_id#">
                                                    <input  type="hidden" name="stock_id_#attributes.row_id#_#get_cond_products.currentrow#" id="stock_id_#attributes.row_id#_#get_cond_products.currentrow#" value="#stock_id#">
                                                    <input type="text" name="product_name_#attributes.row_id#_#get_cond_products.currentrow#" id="product_name_#attributes.row_id#_#get_cond_products.currentrow#" class="text" style="width:100px;" onfocus="AutoComplete_Create('product_name_#attributes.row_id#_#get_cond_products.currentrow#','<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME','<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME','get_product_autocomplete',0,'PRODUCT_ID,STOCK_ID,PRODUCT_NAME,<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>','product_id_#attributes.row_id#_#currentrow#,stock_id_#attributes.row_id#_#currentrow#,product_name_#attributes.row_id#_#currentrow#,stock_code_#attributes.row_id#_#currentrow#','add_prom',3,270);" value="#get_cond_products.product_name#" autocomplete="off">
                                                    <span class="input-group-addon btnPointer no-bg icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&product_id=add_prom.product_id_#attributes.row_id#_#currentrow#<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>&field_code2=add_prom.stock_code_#attributes.row_id#_#currentrow#<cfelse>&field_code=add_prom.stock_code_#attributes.row_id#_#currentrow#</cfif>&field_name=add_prom.product_name_#attributes.row_id#_#currentrow#&field_id=add_prom.stock_id_#attributes.row_id#_#currentrow#','list');"></span>
                                                </div>
                                                </td>
                                                <td nowrap="nowrap"><input type="text" name="catalog_page_no_#attributes.row_id#_#get_cond_products.currentrow#" id="catalog_page_no_#attributes.row_id#_#get_cond_products.currentrow#" class="moneybox" style="width:50px;" value="#get_cond_products.catalog_page_number#"></td>
                                                <td><input type="text" name="product_amount_#attributes.row_id#_#get_cond_products.currentrow#" id="product_amount_#attributes.row_id#_#get_cond_products.currentrow#" class="moneybox" style="width:40px;" value="#get_cond_products.product_amount#" onkeyup="isNumber(this);"></td>
                                                <td><input type="checkbox" name="is_only_sale_product_#attributes.row_id#_#get_cond_products.currentrow#" id="is_only_sale_product_#attributes.row_id#_#get_cond_products.currentrow#" value="1" <cfif get_cond_products.is_sale_with_prom eq 1>checked</cfif> title="<cf_get_lang dictionary_id='60492.Sadece Bu Promosyonla Satılabilir'>"></td>
                                            </tr>
                                        </cfloop>										
                                    </cfif>
                                </tbody>
                            </cf_grid_list>
                        </td>
                    </tr>
                </table>
                </div>
            </div>
        </div>
    </div>
</cfoutput>
<script type="text/javascript">
	<cfoutput>
		row_count1_#attributes.row_id# = <cfif get_cond.recordcount>#get_cond_products.recordcount#<cfelse>0</cfif>;
		function sil1_#attributes.row_id#(sy)
		{
			var my_element=eval("document.getElementById('row_kontrol1_#attributes.row_id#_" + sy + "')");
			my_element.value=0;
			var my_element=eval("frm_row_product_#attributes.row_id#_"+sy);
			my_element.style.display="none";
		}
		function del_all_product_#attributes.row_id#()
		{
			for(sy=1;sy<=eval("document.getElementById('record_num1_#attributes.row_id#')").value;sy++)
			{
				var my_element=eval("document.getElementById('row_kontrol1_#attributes.row_id#_" + sy + "')");
				my_element.value=0;
				var my_element=eval("frm_row_product_#attributes.row_id#_"+sy);
				my_element.style.display="none";
			}
		}
		function add_product_#attributes.row_id#(product_id,stock_id,product_name,stock_code,page_no)
		{
			if(product_id == undefined)
				product_id = '';
			if(stock_id == undefined)
				stock_id = '';
			if(product_name == undefined)
				product_name = '';
			if(stock_code == undefined)
				stock_code = '';
			if(page_no == undefined)
				page_no = '';
			row_count1_#attributes.row_id#++;
			var newRow;
			var newCell;
			newRow = document.getElementById('table_product_#attributes.row_id#').insertRow();
			newRow.setAttribute("name","frm_row_product_#attributes.row_id#_" + row_count1_#attributes.row_id#);
			newRow.setAttribute("id","frm_row_product_#attributes.row_id#_" + row_count1_#attributes.row_id#);
			document.getElementById('record_num1_#attributes.row_id#').value=row_count1_#attributes.row_id#;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="row_kontrol1_#attributes.row_id#_'+row_count1_#attributes.row_id#+'" id="row_kontrol1_#attributes.row_id#_'+row_count1_#attributes.row_id#+'" value="1"><a style="cursor:pointer" style="text-align:center; width:20px" onclick="sil1_#attributes.row_id#(' + row_count1_#attributes.row_id# + ');"><i class="fa fa-minus"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="stock_code_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" id="stock_code_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" class="text" style="width:60px;" readonly value='+stock_code+'>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<div class="input-group"><input  type="hidden" name="product_id_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" id="product_id_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" value="'+product_id+'"><input  type="hidden" name="stock_id_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" id="stock_id_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" value="'+stock_id+'"><input type="text" name="product_name_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" id="product_name_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" class="text" style="width:100px;" value="'+product_name+'" onFocus="AutoComplete_Create(\'product_name_#attributes.row_id#_' + row_count1_#attributes.row_id# +'\',\'<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME\',\'<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>,PRODUCT_NAME\',\'get_product_autocomplete\',0,\'PRODUCT_ID,STOCK_ID,PRODUCT_NAME,<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>STOCK_CODE_2<cfelse>STOCK_CODE</cfif>\',\'product_id_#attributes.row_id#_' + row_count1_#attributes.row_id# +',stock_id_#attributes.row_id#_' + row_count1_#attributes.row_id# +',product_name_#attributes.row_id#_' + row_count1_#attributes.row_id# +',stock_code_#attributes.row_id#_' + row_count1_#attributes.row_id# +'\',\'add_prom\',3,270);">'
							+' '+'<span class="input-group-addon btnPointer icon-ellipsis no-bg" onClick="windowopen('+"'#request.self#?fuseaction=objects.popup_product_names&product_id=add_prom.product_id_#attributes.row_id#_" + row_count1_#attributes.row_id# + "<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>&field_code2=add_prom.stock_code_#attributes.row_id#_" + row_count1_#attributes.row_id# + "<cfelse>&field_code=add_prom.stock_code_#attributes.row_id#_" + row_count1_#attributes.row_id# + "</cfif>&field_id=add_prom.stock_id_#attributes.row_id#_" + row_count1_#attributes.row_id# + "&field_name=add_prom.product_name_#attributes.row_id#_" + row_count1_#attributes.row_id# + "','list');"+'"></span></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap')
			newCell.innerHTML = '<input type="text" name="catalog_page_no_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" id="catalog_page_no_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" class="moneybox" style="width:50px;" readonly value="'+page_no+'" onKeyup="isNumber(this);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="product_amount_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" id="product_amount_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" class="moneybox" style="width:40px;" value="1" onKeyup="isNumber(this);">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="checkbox" name="is_only_sale_product_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" id="is_only_sale_product_#attributes.row_id#_' + row_count1_#attributes.row_id# +'" value="1" title="<cf_get_lang dictionary_id='60492.Sadece Bu Promosyonla Satılabilir'>">';
		}
		function open_process_row_#attributes.row_id#()
		{
			document.getElementById('open_process_#attributes.row_id#').style.display ='';
			document.getElementById('open_process_#attributes.row_id#').style.visibility ='';
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.emptypopup_form_add_prom_condition_product<cfif isdefined("attributes.is_product_code_2") and attributes.is_product_code_2 eq 1>&is_product_code_2=1</cfif>&row_id=#attributes.row_id#&catalog_id='+document.getElementById('catalog_id_#attributes.row_id#').value+'</cfoutput>','open_process_#attributes.row_id#',1);
	
		}
		function check_list_status_#attributes.row_id#(kont)
		{
			if(kont==1)
			{
				if(document.getElementById('prom_list_status_and_#attributes.row_id#').checked == true)
					document.getElementById('prom_list_status_or_#attributes.row_id#').checked = false;
			}
			else
			{
				if(document.getElementById('prom_list_status_or_#attributes.row_id#').checked == true)
					document.getElementById('prom_list_status_and_#attributes.row_id#').checked = false;
			}
		}
		function open_file_#attributes.row_id#()
		{
			document.getElementById('prom_condition_file_#attributes.row_id#').style.display='';
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=product.popup_add_prom_condition_file&prom_condition_id=#attributes.prom_condition_id#</cfoutput>','prom_condition_file_#attributes.row_id#',1);
			return false;
		}
	</cfoutput>
</script>
