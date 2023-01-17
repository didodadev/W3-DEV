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
                                <th nowrap width="55px" id="basket_header_add" style="text-align:center">
                                	<cfif ListFind(session.ep.power_user_level_id,2188)>
                              			<a href="javascript://" onClick="openProducts();"><img src="/images/plus_list.gif" border="0" id="basket_header_add" title="Ürün Ekle"></a>
                                    </cfif>
                                </th>
                                <th width="60px">Durum</th>
                                <th width="30px">Boy</th>
                                <th width="30px">En</th>
                                <th width="30px">Derin</th>
                                <th width="40px">Yön</th>
                                <th width="180px">Ürün</th>
                                <th width="50px">Miktar</th>
                                <th width="40px" >Birim</th>
                                <cfif ListFind(session.ep.power_user_level_id,2188)>
                                <th width="20px" ></th>
                                </cfif>
                                <th width="20px" ></th>
                                <cfif ListFind(session.ep.power_user_level_id,2188)>
                                <th width="60px" >Fiyat</th>
                                <th width="65px" >Hizmet</th>
                                <th width="50px" >Döviz</th>
                                <th width="70px" >ISK.TUTAR</th>
                                <th width="40px" >
                                	<input type="text" name="disc_1" id="disc_1" value="<cfoutput>#TlFormat(0,2)#</cfoutput>" class="boxtext" style="width:30px; text-align:right" onChange="top_disc(1)">
                                </th>
                                <th width="40px" >
                                	<input type="text" name="disc_2" id="disc_2" value="<cfoutput>#TlFormat(0,2)#</cfoutput>" class="boxtext" style="width:30px; text-align:right" onChange="top_disc(2)">
                                </th>
                                <th width="40px" >
                                	<input type="text" name="disc_3" id="disc_3" value="<cfoutput>#TlFormat(0,2)#</cfoutput>" class="boxtext" style="width:30px; text-align:right" onChange="top_disc(3)">
                                </th>
                                <th width="40px" >KDV</th>
                                </cfif>
                                <th>Açıklama</th>
                                <cfif ListFind(session.ep.power_user_level_id,2188)>
                                	<th width="60px" >Net Fiyat</th>
                                    <th width="75px" >Toplam Tutar</th>
                                    <th width="75px" >(#session.ep.money#) Tutar</th>
                                </cfif>
                            </cfoutput>
                        </tr>
                    </thead>
                    <tbody name="new_row" id="new_row">
                    	<input type="hidden" name="gizle_goster" id="gizle_goster" value="0">
                        <input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_virtual_offer_row.recordcount#</cfoutput>">
                        <cfif get_virtual_offer_row.recordcount>
							<cfoutput query="get_virtual_offer_row">
                            	<cfif (process_fuse eq 'upd' and get_virtual_offer_row.DELIVER_AMOUNT gt 0) or process_fuse eq 'add'>
                                	<cfset virtual_offer_lock = 1>
                                <cfelse>
                                	<cfset virtual_offer_lock = 0>
                                </cfif>
                             	<input type="hidden" name="special_code#currentrow#" id="special_code#currentrow#" value="#PRODUCT_CODE_2#">
                                <input type="hidden" value="1" name="row_kontrol#currentrow#">
                                <input type="hidden" value="#ezgi_id#" name="ezgi_id#currentrow#">
                                <input type="hidden" value="#wrk_row_relation_id#" name="WRK_ROW_RELATION_ID_#currentrow#">
                                <tr height="20" id="frm_row#currentrow#" title="#PRODUCT_CODE_2#">
                                    <td  style="text-align:right">
                                    	<cfif ListFind(session.ep.power_user_level_id,2188) and OFFER_ID lte 0>
                                        	<cfif get_virtual_offer.max_rev_no lte 0>
                                            <a style="cursor:pointer" onclick="sil(#currentrow#);" >
                                                <img src="/images/delete_list.gif" alt="<cf_get_lang_main no='1559.Satır Sil'>" title="<cf_get_lang_main no='1559.Satır Sil'>" border="0">
                                            </a>
                                            </cfif>
                                        </cfif>
                                    	<cfif isdefined("attributes.virtual_offer_id")>
											<cfif not get_upd_control.recordcount and is_revision_small eq 0>
                                            	<cfif VIRTUAL_OFFER_ROW_CURRENCY neq 3>
                                                <a style="cursor:pointer" onclick="kopyala(#VIRTUAL_OFFER_ROW_ID#);" >
                                                    <img src="/images/copy_list.gif" alt="<cf_get_lang_main no='1560.Satır Kopyala'>" title="<cf_get_lang_main no='1560.Satır Kopyala'>" border="0">
                                                </a> 
                                                <cfelse>
                                                	<img src="/images/add_gray_mini.gif">
                                                </cfif>
                                            </cfif>
                                        </cfif>
                                        #currentrow#&nbsp;
                                    </td>
                                	<td>
                                   		<select name="currency#currentrow#" id="currency#currentrow#" style="width:75px; height:20px">
                                        	<cfif OFFER_ID gt 0>
                                            	<cfset kilit = 1>
                                            	<option value="3" <cfif VIRTUAL_OFFER_ROW_CURRENCY eq 3>selected</cfif>>İşlendi</option>
                                            <cfelse>
                                            	<cfset kilit = 0>
                                          		<option value="1" <cfif VIRTUAL_OFFER_ROW_CURRENCY eq 1>selected</cfif>>Açık</option>
												<cfif product_id gt 0>
                                                    <option value="2" <cfif VIRTUAL_OFFER_ROW_CURRENCY eq 2>selected</cfif>>Onaylandı</option>
                                                </cfif>
                                           	</cfif>
                                      	</select>
                                 	</td>
                                    <td nowrap style="text-align:left;">
                                    	<input type="text" id="boy#currentrow#" name="boy#currentrow#" style="width:30px; text-align:right" value="#boy#" readonly=yes>
                                    </td>
                                    <td nowrap style="text-align:left;">
                                    	<input type="text" id="en#currentrow#" name="en#currentrow#" style="width:30px; text-align:right"  value="#en#" readonly=yes>
                                    </td>
                                    <td nowrap style="text-align:left;">
                                    	<input type="text" id="derinlik#currentrow#" name="derinlik#currentrow#" style="width:30px; text-align:right" value="#derinlik#" readonly=yes>
                                    </td>
                                    <td nowrap style="text-align:left;">
                                    	<cfif yon eq 1>
                                        	<cfset yon_= 'Sağ'>
                                        <cfelseif yon eq 2>
                                        	<cfset yon_= 'Sol'>
                                      	<cfelseif yon eq 3>
                                        	<cfset yon_= 'D.Sağ'>
                                       	<cfelseif yon eq 4>
                                        	<cfset yon_= 'D.Sol'>
                                       	<cfelse>
                                        	<cfset yon_= ''>
                                        </cfif>
                                    	<input type="hidden" id="yon#currentrow#" name="yon#currentrow#" value="#yon#" >
                                        <input type="text" id="yon_#currentrow#" name="yon_#currentrow#" style="width:40px; text-align:center" value="#yon_#" readonly=yes>
                                    </td>
                                    <td nowrap style="text-align:left;">
                                        <input type="Hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
                                        <input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
                                        <input type="text" name="product_name#currentrow#" id="product_name#currentrow#" style="width:100%;" class="boxtext" readonly="readonly" value="#product_name#">
                                    	<input type="hidden" id="product_code#currentrow#" name="product_code#currentrow#" value="#stock_code#">
                                    </td>
                                    <td nowrap style="text-align:right;">
                                        <input type="text" name="quantity#currentrow#" id="quantity#currentrow#" value="#TlFormat(AMOUNT,2)#" style="width:50px; text-align:right;" onchange="hesapla(#currentrow#);" <cfif virtual_offer_lock eq 1 or (virtual_offer_lock eq 0 and not ListFind(session.ep.power_user_level_id,2188))>readonly</cfif>>
                                    </td>
                                    <td nowrap style="text-align:left;">
                                        <input type="text" name="main_unit#currentrow#" id="main_unit#currentrow#" style="width:40px;" class="boxtext" value="#unit#">
                                    </td>
                                    <cfif ListFind(session.ep.power_user_level_id,2188)>
                                    <td nowrap style="text-align:center;" title="">
                                    	<cfif isdefined('attributes.virtual_offer_id')>
                                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=prod.popup_dsp_ezgi_virtual_cost&virtual_offer_row_id=#VIRTUAL_OFFER_ROW_ID#&stock_id=#STOCK_ID#','longpage');">
                                                <img src="images/money.gif" title="Maliyet" border="0" />
                                            </a>
                                        </cfif>
                                    </td>
                                    </cfif>
                                    <td nowrap style="text-align:center;">
                                  		<a href="javascript://" onClick="add_spect(#ezgi_id#,#kilit#);">
                                         	<img src="images/elements.gif" title="Spekt Oluştur" border="0" />
                                     	</a>
                                    </td>
                                    <cfif ListFind(session.ep.power_user_level_id,2188)>
                                    <td nowrap style="text-align:left;">
                                        <input type="text" name="sales_price#currentrow#" id="sales_price#currentrow#" style="width:60px;text-align:right" class="boxtext" value="#TlFormat(sales_price,2)#" onchange="hesapla(#currentrow#);" <cfif get_virtual_offer.max_rev_no gt 0 or IS_TERAZI eq 1>readonly="readonly"</cfif>>
                                    </td>
                                    <cfelse>
                                    	<input type="hidden" name="sales_price#currentrow#" id="sales_price#currentrow#" value="#TlFormat(sales_price,2)#">
                                    </cfif>
                                    <cfif ListFind(session.ep.power_user_level_id,2188)>
                                    <td nowrap style="text-align:left;">
                                    	<input type="text" name="cost#currentrow#" id="cost#currentrow#" style="width:55px;text-align:right" class="boxtext" value="#TlFormat(hizmet,2)#" readonly onchange="hesapla(#currentrow#);">
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=sales.popup_upd_ezgi_virtual_cost&ezgi_id=#EZGI_ID#&row_money=#get_virtual_offer_row.money#','small');">
                                        	<img src="images/plus_thin.gif" id="cost_pin">
                                        </a>
                                    </td>
                                    <cfelse>
                                    	<input type="hidden" name="cost#currentrow#" id="cost#currentrow#" value="#TlFormat(cost,2)#">
                                    </cfif>
                                    <cfif ListFind(session.ep.power_user_level_id,2188)>
                                    <td nowrap style="text-align:left;">
                                        <select name="money#currentrow#" id="money#currentrow#" style="width:45;" onchange="satir_doviz_hesapla(#currentrow#);">
											<cfloop query="get_money"><option value="#money#" <cfif get_virtual_offer_row.money eq get_money.money>selected</cfif>>#money#</option></cfloop>
                                      	</select>
                                        <input type="hidden" value="#TlFormat(Evaluate('RATE2_#get_virtual_offer_row.money#'),4)#" id="row_rate2_#currentrow#" name="row_rate2_#currentrow#">
                                    </td>
                                    <cfelse>
                                        <input type="hidden" value="#get_virtual_offer_row.money#" id="money#currentrow#" name="money#currentrow#">
                                        <input type="hidden" value="#TlFormat(Evaluate('RATE2_#get_virtual_offer_row.money#'),4)#" id="row_rate2_#currentrow#" name="row_rate2_#currentrow#">
                                    </cfif>
                                    <cfif ListFind(session.ep.power_user_level_id,2188)>
                                    <td nowrap style="text-align:left;">
                                        <input type="text" name="discount_tut#currentrow#" id="discount_tut#currentrow#" style="width:60px; text-align:right" class="boxtext" value="#TlFormat(discount_tut,2)#" onchange="hesapla(#currentrow#);">
                                    </td>
                                    <cfelse>
                                    	<input type="hidden" name="discount_tut#currentrow#" id="discount_tut#currentrow#" value="#TlFormat(discount_tut,2)#">
                                    </cfif>
                                    <cfif ListFind(session.ep.power_user_level_id,2188)>
                                    <td nowrap style="text-align:left;">
                                        <input type="text" name="discount1_#currentrow#" id="discount1_#currentrow#" style="width:40px; text-align:center" class="boxtext" value="#TlFormat(discount1,2)#" onchange="hesapla(#currentrow#);">
                                    </td>
                                    <cfelse>
                                    	<input type="hidden" name="discount1_#currentrow#" id="discount1_#currentrow#" value="#TlFormat(discount1,2)#">
                                    </cfif>
                                    <cfif ListFind(session.ep.power_user_level_id,2188)>
                                    <td nowrap style="text-align:left;">
                                        <input type="text" name="discount2_#currentrow#" id="discount2_#currentrow#" style="width:40px; text-align:center" class="boxtext" value="#TlFormat(discount2,2)#" onchange="hesapla(#currentrow#);">
                                    </td>
                                    <cfelse>
                                    	<input type="hidden" name="discount2_#currentrow#" id="discount2_#currentrow#" value="#TlFormat(discount2,2)#">
                                    </cfif>
                                    <cfif ListFind(session.ep.power_user_level_id,2188)>
                                    <td nowrap style="text-align:left;">
                                        <input type="text" name="discount3_#currentrow#" id="discount3_#currentrow#" style="width:40px; text-align:center" class="boxtext" value="#TlFormat(discount3,2)#" onchange="hesapla(#currentrow#);">
                                    </td>
                                    <cfelse>
                                    	<input type="hidden" name="discount3_#currentrow#" id="discount3_#currentrow#" value="#TlFormat(discount3,2)#">
                                    </cfif>
                                    <cfif ListFind(session.ep.power_user_level_id,2188)>
									<td nowrap style="text-align:left;">
                                        <input type="text" name="tax#currentrow#" id="tax#currentrow#" style="width:30px; text-align:center" class="boxtext" value="#TlFormat(tax,0)#" onchange="hesapla(#currentrow#);">
                                    </td>
                                    <cfelse>
                                    	<input type="hidden" name="tax#currentrow#" id="tax#currentrow#" value="#TlFormat(tax,0)#">
                                    </cfif>
                                    <td nowrap style="text-align:left;">
                                        <input type="text" name="detail#currentrow#" style="width:100%;" value="#PRODUCT_NAME2#">
                                    </td>
                                 	<cfset row_net_other_ = sales_price+cost-discount_tut>
                                 	<cfset row_net_other_ = row_net_other_-(row_net_other_*discount1/100)>
                                   	<cfset row_net_other_ = row_net_other_-(row_net_other_*discount2/100)>
                                  	<cfset row_net_other_ = row_net_other_-(row_net_other_*discount3/100)>
                                    <td nowrap style="text-align:left;">
                                            <input type="text" name="row_net_other#currentrow#" id="row_net_other#currentrow#" style="width:60px;text-align:right" class="boxtext" value="#TlFormat(row_net_other_,2)#" readonly>
                                        </td>
                                    
                                    <cfset total_brut_other_ = (sales_price+hizmet)*quantity>
                                 	<cfset total_net_other_ = total_brut_other_-(discount_tut*quantity)>
                                 	<cfset total_net_other_ = total_net_other_-(total_net_other_*discount1/100)>
                                   	<cfset total_net_other_ = total_net_other_-(total_net_other_*discount2/100)>
                                  	<cfset total_net_other_ = total_net_other_-(total_net_other_*discount3/100)>
                                	<cfset total_tax_other_ = total_net_other_*tax/100>
                                    <cfif ListFind(session.ep.power_user_level_id,2188)>
                                        <td nowrap style="text-align:left;">
                                            <input type="text" name="total_brut_other#currentrow#" id="total_brut_other#currentrow#" style="width:75px;text-align:right" class="boxtext" value="#TlFormat(total_brut_other_,2)#" readonly>
                                        </td>
                                    <cfelse>
                                    	<input type="hidden" name="total_brut_other#currentrow#" id="total_brut_other#currentrow#" value="#TlFormat(total_brut_other_,2)#">
                                    </cfif>
                                    <input type="hidden" name="total_tax_other#currentrow#" id="total_tax_other#currentrow#" value="#TlFormat(total_tax_other_,2)#">
                                 	<input type="hidden" name="total_net_other#currentrow#" id="total_net_other#currentrow#" value="#TlFormat(total_net_other_,2)#">
                                    <cfset total_brut_ = Evaluate('RATE2_#MONEY#')*total_brut_other_>
                                	<cfset total_net_ = Evaluate('RATE2_#MONEY#')*total_net_other_>
                                 	<cfset total_tax_ = Evaluate('RATE2_#MONEY#')*total_tax_other_ >
                                    <cfif ListFind(session.ep.power_user_level_id,2188)>
                                        <td nowrap style="text-align:left;">
                                            <input type="text" name="total_brut#currentrow#" id="total_brut#currentrow#" style="width:75px;text-align:right" class="boxtext" value="#TlFormat(total_brut_,2)#" readonly>
                                        </td>
                                    <cfelse>
                                    	<input type="hidden" name="total_brut#currentrow#" id="total_brut#currentrow#" value="#TlFormat(total_brut_,2)#">
                                    </cfif>
                                    <input type="hidden" name="total_tax#currentrow#" id="total_tax#currentrow#" value="#TlFormat(total_tax_,2)#">
                                 	<input type="hidden" name="total_net#currentrow#" id="total_net#currentrow#" value="#TlFormat(total_net_,2)#">
                                    <input type="hidden" name="purchase_price#currentrow#" id="purchase_price#currentrow#" value="#TlFormat(purchase_price_,2)#">
                                    <input type="hidden" name="cost_price#currentrow#" id="cost_price#currentrow#" value="#TlFormat(cost_price_,2)#">
                                    <input type="hidden" name="purchase_price_money#currentrow#" id="purchase_price_money#currentrow#" value="#purchase_price_money_#">
                                    <input type="hidden" name="cost_price_money#currentrow#" id="cost_price_money#currentrow#" value="#cost_price_money_#">
                                    <input type="hidden" name="p_purchase_price#currentrow#" id="p_purchase_price#currentrow#" value="#TlFormat(p_purchase_price,2)#">
                                    <input type="hidden" name="p_purchase_price_money#currentrow#" id="p_purchase_price_money#currentrow#" value="#p_purchase_price_money#">
                                    <input type="hidden" name="p_discount_1_#currentrow#"  id="p_discount_1_#currentrow#" value="#TlFormat(P_DISCOUNT_1,2)#">
                                    <input type="hidden" name="p_discount_2_#currentrow#"  id="p_discount_2_#currentrow#" value="#TlFormat(P_DISCOUNT_2,2)#">
                                    <input type="hidden" name="p_discount_3_#currentrow#"  id="p_discount_3_#currentrow#" value="#TlFormat(P_DISCOUNT_3,2)#">
                                    <input type="hidden" name="p_discount_4_#currentrow#"  id="p_discount_4_#currentrow#" value="#TlFormat(P_DISCOUNT_4,2)#">
                                    <input type="hidden" name="p_discount_5_#currentrow#"  id="p_discount_5_#currentrow#" value="#TlFormat(P_DISCOUNT_5,2)#">
                                </tr>
                            </cfoutput>
                        </cfif>
                    </tbody>
                </div>
            </table>
		</td>
	</tr>
</table>
<script type="text/javascript">
	var row_count = document.form_basket.record_num.value;
	function add_spect(ezgi_id,kilit)
	{
		<cfif isdefined("attributes.virtual_offer_id")>
			if(kilit == 1)
			  	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_upd_ezgi_virtual_offer_row_spect&ezgi_kilit=1&<cfif get_virtual_offer.max_rev_no gt 0>revision=1&</cfif>ezgi_id='+ezgi_id,'wide');
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_upd_ezgi_virtual_offer_row_spect&<cfif get_virtual_offer.max_rev_no gt 0>revision=1&</cfif>ezgi_id='+ezgi_id,'wide');
		</cfif>
	}
	function openProducts()
	{
		if(document.getElementById('company_id').value <=0 && document.getElementById('consumer_id').value <=0)
		{
			alert('Önce Üye Seçimi Yapınız!');
			return false;
		}
		else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_list_ezgi_virtual_offer_product&list_order_no=6,9,8','wide');
	}
	function change_row(stock_id,product_name,product_code,product_code_2,main_unit,product_id,sales_price,money,boy,en,derinlik,satir_no)
	{
		document.getElementById('stock_id'+satir_no).value = stock_id;
		document.getElementById('product_name'+satir_no).value = product_name;
		document.getElementById('product_code'+satir_no).value = product_code;
		document.getElementById('special_code'+satir_no).value = special_code;
		document.getElementById('main_unit'+satir_no).value = main_unit;
		document.getElementById('product_id'+satir_no).value = product_id;
		document.getElementById('boy'+satir_no).value = boy;
		document.getElementById('en'+satir_no).value = en;
		document.getElementById('derinlik'+satir_no).value = derinlik;
		document.getElementById('link_param'+satir_no).value = link_param;
	}
	function add_row(stock_id,product_name,product_code,special_code,main_unit,product_id,sales_price,money,boy,en,derinlik)
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
		newCell.style.textAlign = 'right';
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0"></a><!---<a style="cursor:pointer" onclick="duzenle(' + row_count + ');" ><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" border="0"></a>---> '+row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<select name="currency' + row_count +'" id="currency' + row_count +'" style="width:75px;"><option value="1">Açık</option></select>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="boy' + row_count + '" style="width:30px;text-align:right" value="'+boy+'">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="en' + row_count + '" style="width:30px;text-align:right" value="'+en+'">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="derinlik' + row_count + '" style="width:30px;text-align:right" value="'+derinlik+'">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="yon' + row_count + '" style="width:30px;text-align:right" value="">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol'+row_count+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" name="stock_id'+row_count+'" id="stock_id'+row_count+'" value="' + stock_id + '">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="product_id'+row_count+'" id="product_id'+row_count+'" value="'+product_id+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="text" name="product_name' + row_count + '" style="width:180px;" readonly="readonly" value="'+product_name+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="product_code' + row_count + '" value="'+product_code+'">';
		newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="special_code' + row_count + '" value="'+special_code+'">';
		
		newCell=newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" value="<cfoutput>#TlFormat(1,2)#</cfoutput>" style="width:50px; text-align:right;" onchange="hesapla('+row_count+');">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="main_unit' + row_count + '" style="width:40px;" class="boxtext" value="'+main_unit+'">';
		
		<cfif ListFind(session.ep.power_user_level_id,2188)>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '';
		</cfif>
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="sales_price' + row_count + '" id="sales_price' + row_count + '" style="width:60px;text-align:right" class="boxtext" value="'+ sales_price +'" onchange="hesapla('+row_count+');">';
		
		<cfif ListFind(session.ep.power_user_level_id,2188)>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="text" name="cost' + row_count + '" id="cost' + row_count + '" style="width:55px;text-align:right" class="boxtext" value="<cfoutput>#TlFormat(0,2)#</cfoutput>" onchange="hesapla('+row_count+');">';
		</cfif>
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<select name="money' + row_count +'" id="money' + row_count +'" style="width:45px;" onchange="satir_doviz_hesapla('+ row_count +');"><cfoutput query="get_money"><option value="#money#">#money#</option></cfoutput></select> <input type="hidden" value="1" id="row_rate2_'+ row_count +'" name="row_rate2_'+ row_count +'">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="discount_tut' + row_count + '" id="discount_tut' + row_count + '" style="width:60px;text-align:right" class="boxtext" value="0" onchange="hesapla('+row_count+');">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="discount1_' + row_count + '" id="discount1_' + row_count + '" style="width:40px;text-align:center" class="boxtext" value="0" onchange="hesapla('+row_count+');">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="discount2_' + row_count + '" id="discount2_' + row_count + '" style="width:40px;text-align:center" class="boxtext" value="0" onchange="hesapla('+row_count+');">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="discount3_' + row_count + '" id="discount3_' + row_count + '" style="width:40px;text-align:center" class="boxtext" value="0" onchange="hesapla('+row_count+');">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="tax' + row_count + '" id="tax' + row_count + '" style="width:30px;text-align:center" class="boxtext" value="18" onchange="hesapla('+row_count+');">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="detail' + row_count + '" style="width:100%;" maxlength="150" value="">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="row_net_other' + row_count + '" id="row_net_other' + row_count + '" value="0" style="width:65px;text-align:right" class="boxtext" readonly>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="total_brut_other' + row_count + '" id="total_brut_other' + row_count + '" value="0" style="width:75px;text-align:right" class="boxtext" readonly><input type="hidden" name="total_net_other' + row_count + '" id="total_net_other' + row_count + '" value="0"><input type="hidden" name="total_tax_other' + row_count + '" id="total_tax_other' + row_count + '" value="0">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="total_brut' + row_count + '" id="total_brut' + row_count + '" value="0" style="width:75px;text-align:right" class="boxtext" readonly><input type="hidden" name="total_net' + row_count + '" id="total_net' + row_count + '" value="0"><input type="hidden" name="total_tax' + row_count + '" id="total_tax' + row_count + '" value="0">';
	hesapla(row_count);
	sub_total();
		
	}
	function sil(sy)
	{
		sil_sor = confirm('Teklif Satırını Siliyorsunuz Emin misiniz?');
		if(sil_sor == 1)
		{
			var element=eval("form_basket.row_kontrol"+sy);
			element.value=0;
			var element=eval("frm_row"+sy); 
			element.style.display="none";	
			document.getElementById('total_net'+sy).value = 0;
			document.getElementById('total_brut'+sy).value = 0;
			document.getElementById('total_tax'+sy).value = 0;
			sub_total();
		}
		else
		{
			return false;

		}
	}

	function kopyala(sy)
	{
		<cfif isdefined("attributes.virtual_offer_id")>
		kopyala_sor = confirm('Teklifin Satırını Kopyalıyorsunuz !');
		if(kopyala_sor==true)
			window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_cpy_ezgi_virtual_offer_row&virtual_offer_id=#attributes.virtual_offer_id#</cfoutput>&virtual_offer_row_id="+sy;
		else
			return false;
		</cfif>
	}
	function hesapla(row)
	{
		
		document.getElementById('row_net_other'+row).value = commaSplit(parseFloat(filterNum(document.getElementById('sales_price'+row).value,2)) + parseFloat(filterNum(document.getElementById('cost'+row).value,2)) - parseFloat(filterNum(document.getElementById('discount_tut'+row).value,2)),2);

		document.getElementById('row_net_other'+row).value = commaSplit(parseFloat(filterNum(document.getElementById('row_net_other'+row).value,2)) - (parseFloat(filterNum(document.getElementById('row_net_other'+row).value,2))*parseFloat(filterNum(document.getElementById('discount1_'+row).value,2))/100),2);
		
		document.getElementById('row_net_other'+row).value = commaSplit(parseFloat(filterNum(document.getElementById('row_net_other'+row).value,2)) - (parseFloat(filterNum(document.getElementById('row_net_other'+row).value,2))*parseFloat(filterNum(document.getElementById('discount2_'+row).value,2))/100),2);
		
		document.getElementById('row_net_other'+row).value = commaSplit(parseFloat(filterNum(document.getElementById('row_net_other'+row).value,2)) - (parseFloat(filterNum(document.getElementById('row_net_other'+row).value,2))*parseFloat(filterNum(document.getElementById('discount3_'+row).value,2))/100),2);
		
		
		document.getElementById('total_net'+row).value = commaSplit((parseFloat(filterNum(document.getElementById('sales_price'+row).value,2)) + parseFloat(filterNum(document.getElementById('cost'+row).value,2))) * parseFloat(filterNum(document.getElementById('quantity'+row).value,2)) * parseFloat(filterNum(document.getElementById('row_rate2_'+row).value,4)),2);

	document.getElementById('total_net'+row).value = commaSplit(parseFloat(filterNum(document.getElementById('total_net'+row).value,2)) - (parseFloat(filterNum(document.getElementById('discount_tut'+row).value,2)) * parseFloat(filterNum(document.getElementById('quantity'+row).value,2)) * parseFloat(filterNum(document.getElementById('row_rate2_'+row).value,4))),2);

	document.getElementById('total_net'+row).value = commaSplit(parseFloat(filterNum(document.getElementById('total_net'+row).value,2)) - (parseFloat(filterNum(document.getElementById('total_net'+row).value,2))*parseFloat(filterNum(document.getElementById('discount1_'+row).value,2))/100),2);
		
		document.getElementById('total_net'+row).value = commaSplit(parseFloat(filterNum(document.getElementById('total_net'+row).value,2)) - (parseFloat(filterNum(document.getElementById('total_net'+row).value,2))*parseFloat(filterNum(document.getElementById('discount2_'+row).value,2))/100),2);
		
		document.getElementById('total_net'+row).value = commaSplit(parseFloat(filterNum(document.getElementById('total_net'+row).value,2)) - (parseFloat(filterNum(document.getElementById('total_net'+row).value,2))*parseFloat(filterNum(document.getElementById('discount3_'+row).value,2))/100),2);
		
		document.getElementById('total_tax'+row).value = commaSplit(parseFloat(filterNum(document.getElementById('total_net'+row).value,2)*document.getElementById('tax'+row).value/100),2);
		
		document.getElementById('total_brut'+row).value = commaSplit((parseFloat(filterNum(document.getElementById('sales_price'+row).value,2))+parseFloat(filterNum(document.getElementById('cost'+row).value,2)))*parseFloat(filterNum(document.getElementById('quantity'+row).value,2))*parseFloat(filterNum(document.getElementById('row_rate2_'+row).value,4)),2);
		
		document.getElementById('total_brut_other'+row).value = commaSplit((parseFloat(filterNum(document.getElementById('sales_price'+row).value,2))+parseFloat(filterNum(document.getElementById('cost'+row).value,2)))*parseFloat(filterNum(document.getElementById('quantity'+row).value,2)),2);
		sub_total();
	}
	function sub_total()
	{
		document.getElementById('sub_total_brut').value = 0;
		document.getElementById('sub_total_net').value = 0;
		document.getElementById('sub_total_tax').value = 0;
		document.getElementById('sub_total_brut_other').value = 0;
		document.getElementById('sub_total_net_other').value = 0;
		document.getElementById('sub_total_tax_other').value = 0;
		for (var r=1;r<=document.form_basket.record_num.value;r++)
		{
			document.getElementById('sub_total_brut').value = commaSplit(parseFloat(filterNum(document.getElementById('sub_total_brut').value,2))+parseFloat(filterNum(document.getElementById('total_brut'+r).value,2)),2);
			document.getElementById('sub_total_net').value = commaSplit(parseFloat(filterNum(document.getElementById('sub_total_net').value,2))+parseFloat(filterNum(document.getElementById('total_net'+r).value,2)),2);
			document.getElementById('sub_total_discount').value = commaSplit(parseFloat(filterNum(document.getElementById('sub_total_brut').value,2))-parseFloat(filterNum(document.getElementById('sub_total_net').value,2)),2);
			document.getElementById('sub_total_tax').value =  commaSplit(parseFloat(filterNum(document.getElementById('sub_total_tax').value,2))+parseFloat(filterNum(document.getElementById('total_tax'+r).value,2)),2);
			document.getElementById('sub_total_end').value = commaSplit(parseFloat(filterNum(document.getElementById('sub_total_net').value,2))-parseFloat(filterNum(document.getElementById('sub_total_discount_ext').value,2))+ parseFloat(filterNum(document.getElementById('sub_total_tax').value,2)),2);
			
			document.getElementById('sub_total_brut_other').value = commaSplit(parseFloat(filterNum(document.getElementById('sub_total_brut').value,2))/parseFloat(filterNum(document.getElementById('virtual_offer_rate2').value,4)),2);
			document.getElementById('sub_total_net_other').value = commaSplit(parseFloat(filterNum(document.getElementById('sub_total_net').value,2))/parseFloat(filterNum(document.getElementById('virtual_offer_rate2').value,4)),2);
			document.getElementById('sub_total_discount_other').value = commaSplit(parseFloat(filterNum(document.getElementById('sub_total_discount').value,2))/parseFloat(filterNum(document.getElementById('virtual_offer_rate2').value,4)),2);
			document.getElementById('sub_total_tax_other').value = commaSplit(parseFloat(filterNum(document.getElementById('sub_total_tax').value,2))/parseFloat(filterNum(document.getElementById('virtual_offer_rate2').value,4)),2);
			document.getElementById('sub_total_end_other').value = commaSplit(parseFloat(filterNum(document.getElementById('sub_total_end').value,2))/parseFloat(filterNum(document.getElementById('virtual_offer_rate2').value,4)),2);
		}
	}
	function satir_doviz_hesapla(currentrow)
	{
		row_money = document.getElementById('money'+currentrow).value;
		<cfif isdefined('attributes.virtual_offer_id')>
			<cfoutput query="get_virtual_offer_money">
				money_type = '#get_virtual_offer_money.money_type#';
				money_currentrow = #get_virtual_offer_money.currentrow#
				if(row_money==money_type)
				{
					document.getElementById('row_rate2_'+currentrow).value=document.getElementById('money_'+money_currentrow).value;
				}
			</cfoutput>
		<cfelse>
			<cfoutput query="get_money">
				money_type = '#get_money.money#';
				money_currentrow = #get_money.currentrow#
				if(row_money==money_type)
				{
					document.getElementById('row_rate2_'+currentrow).value=document.getElementById('money_'+money_currentrow).value;
				}
			</cfoutput>
		</cfif>
		hesapla(currentrow);
	}
	function gizle_goster()
	{
		if(document.getElementById('gizle_goster').value == 0)
		{
			document.getElementById('siparis_gizle').style.display='';
			document.getElementById('siparis_goster').style.display='none';
			document.getElementById('gizle_goster').value = 1;
			document.getElementById('b_depo').style.display='';
			document.getElementById('u_emir').style.display='';
			document.getElementById('a_sipa').style.display='';
			document.getElementById('s_stok').style.display='';
			for (var k=1;k<=paketsayisi;k++)
			{
				document.getElementById('p'+k).style.display='';
			}
			for (var r=1;r<=document.form_basket.record_num.value;r++)
			{
				document.getElementById('b_depo'+r).style.display='';
				document.getElementById('u_emir'+r).style.display='';
				document.getElementById('a_sipa'+r).style.display='';
				document.getElementById('s_stok'+r).style.display='';
				for (var k=1;k<=paketsayisi;k++)
				{
					document.getElementById('p'+k+'_'+r).style.display='';
				}
			}
		}
		else
		{
			document.getElementById('siparis_gizle').style.display='none';
			document.getElementById('siparis_goster').style.display='';
			document.getElementById('gizle_goster').value = 0;
			document.getElementById('b_depo').style.display='none';
			document.getElementById('u_emir').style.display='none';
			document.getElementById('a_sipa').style.display='none';
			document.getElementById('s_stok').style.display='none';
			for (var k=1;k<=paketsayisi;k++)
			{
				document.getElementById('p'+k).style.display='none';
			}
			for (var r=1;r<=document.form_basket.record_num.value;r++)
			{
				document.getElementById('b_depo'+r).style.display='none';
				document.getElementById('u_emir'+r).style.display='none';
				document.getElementById('a_sipa'+r).style.display='none';
				document.getElementById('s_stok'+r).style.display='none';
				for (var k=1;k<=paketsayisi;k++)
				{
					document.getElementById('p'+k+'_'+r).style.display='none';
				}
			}
		}
	}
	function top_disc(iskonto)
	{
		iskonto_oran = document.getElementById('disc_'+iskonto).value;
		for (var r=1;r<=document.form_basket.record_num.value;r++)
		{
			document.getElementById('discount'+iskonto+'_'+r).value = iskonto_oran;	
			hesapla(r);
		}
	}
</script>