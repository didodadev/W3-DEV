<cfset var_="upd_purchase_basket">
<cfquery name="get_upd_piece" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_PIECE WHERE PIECE_ROW_ID = #attributes.design_piece_row_id#
</cfquery>
<cfquery name="get_prototip_defaults" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_PIECE_PROTOTIP_DEFAULT WHERE PIECE_TYPE = #get_upd_piece.PIECE_TYPE#
</cfquery>
<cfif not get_prototip_defaults.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='2952.Önce Tasarım Genel Default Bilgilerini Tanımlayınız'>!");
		window.close()
	</script>
    <cfabort>
</cfif>
<cfif get_upd_piece.PIECE_TYPE eq 4>
    <cfquery name="get_piece_alternatives" datasource="#dsn3#">
        SELECT        
            ED.ALTERNATIVE_AMOUNT_FORMUL, 
            ED.ALTERNATIVE_AMOUNT AS AMOUNT,
            S.PRODUCT_NAME,
            S.STOCK_ID,
            S.PRODUCT_ID
		FROM            
    		EZGI_DESIGN_PIECE_PROTOTIP_ALTERNATIVE AS ED INNER JOIN
          	STOCKS AS S ON ED.ALTERNATIVE_STOCK_ID = S.STOCK_ID
		WHERE        
        	ED.PIECE_ROW_ID = #attributes.design_piece_row_id#
    </cfquery>
<cfelse>
	<cfquery name="get_piece_alternatives" datasource="#dsn3#">
        SELECT        
            ED.ALTERNATIVE_AMOUNT_FORMUL, 
            ED.ALTERNATIVE_AMOUNT AS AMOUNT, 
            EP.PIECE_NAME AS PRODUCT_NAME,
            ED.ALTERNATIVE_PIECE_ROW_ID AS STOCK_ID,
            ED.ALTERNATIVE_PIECE_ROW_ID AS PRODUCT_ID
        FROM 
        	EZGI_DESIGN_PIECE_PROTOTIP_ALTERNATIVE AS ED INNER JOIN
         	EZGI_DESIGN_PIECE_ROWS AS EP ON ED.ALTERNATIVE_PIECE_ROW_ID = EP.PIECE_ROW_ID
        WHERE        
            ED.PIECE_ROW_ID = #attributes.design_piece_row_id#
    </cfquery>
</cfif>
<cfquery name="get_piece_prototip" datasource="#dsn3#">
	SELECT * FROM EZGI_DESIGN_PIECE_PROTOTIP WHERE PIECE_ROW_ID = #attributes.design_piece_row_id#
</cfquery>
<cfquery name="get_design" datasource="#dsn3#">
	SELECT  * FROM EZGI_DESIGN WHERE DESIGN_ID = #get_upd_piece.design_id#
</cfquery>
<cfquery name="Get_Alternative_Questions" datasource="#dsn#">
	SELECT        
    	QUESTION_ID, 
        QUESTION_NAME
	FROM        
    	SETUP_ALTERNATIVE_QUESTIONS
	ORDER BY 
    	QUESTION_NAME
</cfquery>
<cfif get_piece_prototip.recordcount>
	<cfset standart_boy_formul = get_piece_prototip.BOY_FORMUL>
    <cfset standart_en_formul = get_piece_prototip.EN_FORMUL>
    <cfset standart_amount_formul = get_piece_prototip.AMOUNT_FORMUL>
<cfelse>
	<cfset standart_boy_formul = get_prototip_defaults.DEFAULT_BOY_FORMUL>
    <cfset standart_en_formul = get_prototip_defaults.DEFAULT_EN_FORMUL>
    <cfset standart_amount_formul = get_prototip_defaults.DEFAULT_AMOUNT_FORMUL>
</cfif>
<br />
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='2854.Özelleştirilebilir Ürün'>&nbsp;</td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
            <cf_form_box>
                <cfform name="upd_alternatives" method="post" action="#request.self#?fuseaction=prod.emptypopup_upd_ezgi_product_tree_creative_piece_row_prototip">
                    <cfinput type="hidden" name="design_piece_row_id" value="#attributes.design_piece_row_id#">
                    <cfinput type="hidden" name="piece_type" value="#get_upd_piece.PIECE_TYPE#">
                    <cfoutput>
                    <cf_area>
                        <table>
                        	<tr height="25px"  id="is_price_">
                             	<td>#getLang('product',992)#</td>
                              	<td>
                                	<input type="checkbox" name="is_price" id="is_price" value="1" <cfif  get_piece_prototip.IS_PRICE_CHANGE eq 1>checked</cfif>>
                              	</td>
                          	</tr>
                        	<cfif get_upd_piece.PIECE_TYPE neq 4>
                                <tr height="25px"  id="piece_en_">
                                    <td width="120"><cf_get_lang_main no ='2902.Boy'> <cf_get_lang_main no ='616.Formül'></td>
                                    <td width="310">
                                        <cfinput type="text" name="boy_formul" id="boy_formul" value="#standart_boy_formul#" style="width:300px; height:20px">
                                    </td>
                                </tr>
                                <tr height="25px"  id="piece_boy_">
                                    <td><cf_get_lang_main no ='2901.En'> <cf_get_lang_main no ='616.Formül'></td>
                                    <td>
                                        <cfinput type="text" name="en_formul" id="en_formul" value="#standart_en_formul#" style="width:300px; height:20px">
                                    </td>
                                </tr>
                            </cfif>
                            <tr height="25px"  id="is_amount_">
                             	<td><cf_get_lang_main no ='2631.Miktar Göster'></td>
                              	<td>
                                	<input type="checkbox" name="is_amount" id="is_amount" value="1" <cfif  get_piece_prototip.IS_AMOUNT_CHANGE eq 1>checked</cfif>>
                              	</td>
                          	</tr>
                           	<tr height="25px"  id="is_amount_formul_">
                               	<td><cf_get_lang_main no ='223.Miktar'> <cf_get_lang_main no ='616.Formül'></td>
                               	<td>
                                  	<cfinput type="text" name="amount_formul" id="amount_formul" value="#standart_amount_formul#" style="width:300px; height:20px">
                              	</td>
                         	</tr>
                            <tr height="25px"  id="piece_alternative_Question_">
                                <td>#getLang('prod',141)#</td>
                                <td>
                                	<select name="alternative_question_id" id="alternative_question_id" style="width:130px; height:20px" onChange="piece_alternative_Question();">
                                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        <cfloop query="Get_Alternative_Questions">
                                            <option value="#QUESTION_ID#" <cfif get_piece_prototip.QUESTION_ID eq QUESTION_ID>style="font-weight:bold" selected </cfif>>#QUESTION_NAME#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                            <tr height="25px"  id="piece_alternative_Products_">
                                <td>#getLang('prod',526)#</td>
                                <td>
                                	<div id="aksesuar_" style="width:300px; <cfif not len(get_piece_prototip.QUESTION_ID)>display:none</cfif>">
                                        <cf_form_list id="_aksesuar">
                                            <thead>
                                                <tr>
                                                    <th style="width:30px; text-align:center">
                                                        <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_piece_alternatives.recordcount#</cfoutput>">
                                                        <a href="javascript:openProducts();"><img src="/images/plus_list.gif"  border="0"></a>
                                                    </th>
                                                    <th width="200px" nowrap="nowrap"><cf_get_lang_main no='40.Stok'></th>
                                                    <th width="60px"><cf_get_lang_main no='223.Miktar'></th>
                                                </tr>
                                            </thead>
                                            <tbody name="new_row" id="new_row">
                                                <cfif get_piece_alternatives.recordcount>
                                                    <cfloop query="get_piece_alternatives">
                                                     	<tr name="frm_row" id="frm_row#currentrow#">
                                                       		<td style="text-align:center">
                                                            	<a style="cursor:pointer" onclick="sil(#currentrow#);" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>
                                                            	<!---<input type="button" class="silbuton" title="<cf_get_lang_main no='51.Sil'>" onclick="sil(#currentrow#);">--->
                                                              	<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
                                                         	</td>
                                                       		<td nowrap="nowrap">
                                                             	<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#get_piece_alternatives.product_id#">
                                                             	<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#get_piece_alternatives.stock_id#">
                                                           		<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="#get_piece_alternatives.product_name#" style="width:200px;">
                                                          	</td>
                                                         	<td>
                                                             	<input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#TlFormat(get_piece_alternatives.amount,4)#" style="width:50px; text-align:right;">
                                                          	</td>
                                                    	</tr>
													</cfloop>
                                                </cfif>
                                          	</tbody>
                                        </cf_form_list>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </cf_area>
                    </cfoutput>
                    <cf_form_box_footer>
                        <cf_workcube_buttons 
                                is_upd='1' 
                                is_delete='1' 
                                delete_page_url='#request.self#?fuseaction=prod.emptypopup_upd_ezgi_product_tree_creative_piece_row_prototip&is_delete=1&design_piece_row_id=#attributes.design_piece_row_id#'
                                add_function='kontrol()'>
                        <cf_record_info 
                            query_name="get_upd_piece"
                            record_emp="RECORD_EMP" 
                            record_date="record_date"
                            update_emp="UPDATE_EMP"
                            update_date="update_date">
                    </cf_form_box_footer>
                </cfform>
            </cf_form_box>
     	</td>
	</tr>
</table>
<script type="text/javascript">
	var row_count=document.upd_alternatives.record_num.value;
	function piece_alternative_Question()
	{
		if(document.getElementById('alternative_question_id').value>0)
			document.getElementById('aksesuar_').style.display = '';
		if(document.getElementById('alternative_question_id').value=='')
			document.getElementById('aksesuar_').style.display = 'none';
	}
	function openProducts()
	{
		<cfif get_upd_piece.PIECE_TYPE eq 4>
			windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_ezgi_stocks&price_cat=-2&list_order_no=3,4&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists='</cfoutput>,'page');
		<cfelse>
			windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_ezgi_stocks&price_cat=-2&ezgi_design=1&ezgi_prototip=1&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists='</cfoutput>,'page');
		</cfif>
	}
	function add_row(stockid,stockprop,sirano,product_id,product_name,manufact_code,tax,tax_purchase,add_unit,product_unit_id,money,is_serial_no,discount1,discount2,discount3,discount4,discount5,discount6,discount7,discount8,discount9,discount10,del_date_no,p_price,s_price,product_cost,extra_product_cost,is_production,list_price,other_list_price,spec_main_id,spec_main_name)
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
		document.upd_alternatives.record_num.value = row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a>';	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" name="stock_id'+row_count+'" value="' + stockid + '">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="product_id'+row_count+'" value="'+product_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="unit_id'+row_count+'" value="'+product_unit_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="product_name' + row_count + '" style="width:200px;" class="boxtext" value="'+product_name+'">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="<cfoutput>#TlFormat(1,4)#</cfoutput>" style="width:50px; text-align:right;">';
	}
	function sil(sy)
	{
	
		var element=eval("upd_alternatives.row_kontrol"+sy);
		element.value=0;
		var element=eval("frm_row"+sy); 
		element.style.display="none";		
	}
</script>
