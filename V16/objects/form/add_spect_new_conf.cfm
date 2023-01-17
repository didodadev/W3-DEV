<cfquery name="get_product_conf" datasource="#dsn3#">
	SELECT CONFIGURATOR_NAME,PRODUCT_CONFIGURATOR_ID FROM SETUP_PRODUCT_CONFIGURATOR WHERE CONFIGURATOR_STOCK_ID = #attributes.stock_id#
</cfquery>
<div style="overflow:auto;height:800px;">
<table  width="100%">
<tr height="25">
	<td class="headbold">
		<cfoutput>
		<input type="hidden" name="record_count" id="record_count" value="0">
		<font color="red"><cf_get_lang dictionary_id='59106.Özellikler'>/<cf_get_lang dictionary_id='37249.Varyasyonlar'>/<cf_get_lang dictionary_id='36437.İhtiyaçlar'></font>
		<input type="hidden" name="product_name" id="product_name" value="#GET_PRODUCT.PRODUCT_NAME#">
		<input type="hidden" name="PRODUCT_CONFIGURATOR_ID" id="PRODUCT_CONFIGURATOR_ID" value="#get_product_conf.PRODUCT_CONFIGURATOR_ID#">
		</cfoutput>
	</td>
</tr>
<cfif get_product_conf.recordcount>
	<cfquery name="get_conf_compenents" datasource="#dsn3#">
		SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_COMPONENTS WHERE PRODUCT_CONFIGURATOR_ID = #get_product_conf.PRODUCT_CONFIGURATOR_ID# ORDER BY ORDER_NO
	</cfquery>
	<cfquery name="get_conf_variations" datasource="#dsn3#">
		SELECT * FROM SETUP_PRODUCT_CONFIGURATOR_VARIATION WHERE PRODUCT_CONFIGURATOR_ID = #get_product_conf.PRODUCT_CONFIGURATOR_ID#
	</cfquery>
	<cfset conf_id = get_product_conf.PRODUCT_CONFIGURATOR_ID>
	<tr>
		<td>
			<table>
			<cfif not isdefined("attributes.price")><cfset attributes.price = 0></cfif>
			<cfif not isdefined("attributes.money_")><cfset attributes.money_ = session.ep.money></cfif>
			<cfquery name="get_money_2_rate" dbtype="query">
				SELECT * FROM GET_MONEY WHERE MONEY = '#attributes.money_#'
			</cfquery>
			<cfset attributes.price = attributes.price/get_money_2_rate.rate2>
			   <tr>
			   		<td class="txtbold"><cf_get_lang dictionary_id='58084.Fiyat'> : <cfoutput>#tlformat(attributes.price,2)# #attributes.money_#</cfoutput></td>
			   </tr>
			   <tr><td>&nbsp;</td></tr>
			   <cfoutput query="get_conf_compenents">
					<cfset amount_type_ = get_conf_compenents.amount_type>
					<cfset price_type_ = get_conf_compenents.price_type>
					<cfset require_type_ = get_conf_compenents.require_type>
					<cfset formula_id_ = get_conf_compenents.formula_id>
					<cfset amount_ = get_conf_compenents.amount>
					<cfset row_id_ = get_conf_compenents.product_configurator_compenents_id>
					<cfif len(property_id)>
						<cfquery name="get_property_name" datasource="#dsn1#">
							SELECT PROPERTY FROM PRODUCT_PROPERTY WHERE PROPERTY_ID = #property_id#
						</cfquery>
						<cfset property_name_ =  get_property_name.PROPERTY>  
					<cfelse>
						<cfset property_name_ =  ''>   
					</cfif>
					<cfif isdefined("is_upd_") and is_upd_ eq 1>
						<cfquery name="get_property" dbtype="query">
							SELECT * FROM GET_SPECT_ROW WHERE IS_PROPERTY = 1 AND PROPERTY_ID = #property_id#
						</cfquery>
						<cfset amount_new = get_property.amount_value>
					</cfif>
					<tr>
						<td class="txtboldblue">
							<a href="javascript://" onClick="gizle_goster(component_tr_#get_conf_compenents.currentrow#);">#get_conf_compenents.currentrow# - #property_name_#</a>
						</td>
					</tr>
					<tr id="component_tr_#get_conf_compenents.currentrow#">
						<td>
							<table>
								<tr id="td_req_type_1_#row_id_#" <cfif require_type_ eq 1>style="display=none;"</cfif>>
									<td><input type="radio" id="req_type_#row_id_#" name="req_type_#row_id_#" value="1" onClick="show_input(#row_id_#,#amount_type_#);" <cfif isdefined("is_upd_") and is_upd_ eq 1 and get_property.recordcount>checked</cfif>><cf_get_lang dictionary_id='58564.Var'></td>
								</tr>
								<tr id="td_req_type_2_#row_id_#" <cfif require_type_ eq 1>style="display=none;"</cfif>>
									<td><input type="radio" id="req_type_#row_id_#" name="req_type_#row_id_#" value="0" onClick="show_input(#row_id_#,#amount_type_#);" <cfif isdefined("is_upd_") and is_upd_ eq 1 and get_property.recordcount eq 0>checked</cfif>><cf_get_lang dictionary_id='58546.Yok'></td>
								</tr>
								<tr id="td_req_type_3_#row_id_#" <cfif require_type_ eq 2 and not (isdefined("is_upd_") and is_upd_ eq 1 and get_property.recordcount)>style="display=none;"</cfif>>
									<cfif listfind('1,2',amount_type_)>
										<td class="txtboldblue" width="50"><cf_get_lang dictionary_id='50801.Katsayı'></td>
										<td><input name="amount_#row_id_#" id="amount_#row_id_#" type="text" style="width:50px;" value="<cfif isdefined("amount_new")>#tlformat(amount_new,4)#<cfelseif len(amount_)>#tlformat(amount,4)#</cfif>" onkeyup="return(FormatCurrency(this,event,4));" <cfif amount_type_ eq 2>readonly</cfif> class="moneybox"></td>
									<cfelseif listfind('3',amount_type_)>
										<td class="txtboldblue" width="50"><cf_get_lang dictionary_id='57673.Tutar'></td>
										<td><input name="amount_value_#row_id_#" id="amount_value_#row_id_#" type="text" style="width:50px;" value="<cfif isdefined("amount_new")>#tlformat(amount_new,4)#<cfelseif len(amount_)>#tlformat(amount,4)#</cfif>" onkeyup="return(FormatCurrency(this,event,4));" <cfif amount_type_ eq 2>readonly</cfif> class="moneybox"></td>
									<cfelseif listfind('4,5',amount_type_)>
										<cfquery name="get_conf_variation_row" dbtype="query">
											SELECT * FROM get_conf_variations WHERE PRODUCT_COMPENENT_ID = #row_id_#
										</cfquery>
										<td>
											<table>											
											<tr class="color-list" id="compenent_row_frm_row2_#row_id_#" valign="top" <cfif require_type_ eq 2 and not (isdefined("is_upd_") and is_upd_ eq 1 and get_property.recordcount)>style="display=none;"</cfif>>
												<td colspan="2">
													<table id="table2_#currentrow#" cellpadding="2" cellspacing="1" class="color-header">
														<tr class="color-list">
															<cfif amount_type_ eq 4><td width="10"></td></cfif><td width="120" class="txtboldblue">Varyasyon</td><td class="txtboldblue"><cf_get_lang dictionary_id='50801.Katsayı'></td>
														</tr>
														<cfloop query="get_conf_variation_row">
															<tr id="variation_row_frm_row_relation_#row_id_#">
																<cfif len(get_conf_variation_row.variation_property_detail_id)>
																	<cfquery name="get_property_row_name" datasource="#dsn1#">
																		SELECT PROPERTY_DETAIL,PROPERTY_DETAIL_ID FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID =#get_conf_variation_row.variation_property_detail_id#
																	</cfquery>
																	<cfset property_detail_row =  get_property_row_name.PROPERTY_DETAIL>  
																	<cfset property_detail_row_id = get_property_row_name.PROPERTY_DETAIL_ID>  
																<cfelse>
																	<cfset property_detail_row_id = ''>  
																	<cfset property_detail_row =  ''>
																</cfif>
																<cfif isdefined("is_upd_") and is_upd_ eq 1>
																	<cfquery name="get_property_row" dbtype="query">
																		SELECT * FROM GET_SPECT_ROW WHERE IS_PROPERTY = 1 AND PROPERTY_ID = #get_conf_compenents.property_id# AND VARIATION_ID = #property_detail_row_id#
																	</cfquery>
																	<cfset amount_new_ = get_property_row.amount_value>
																</cfif>
                                                                <cfif amount_type_ eq 4>
																	<td><input type="radio" id="configurator_variation_id_#row_id_#" name="configurator_variation_id_#row_id_#" value="#property_detail_row_id#" <cfif isdefined("is_upd_") and is_upd_ eq 1 and get_property_row.recordcount>checked</cfif>></td>
																</cfif>
																<td><input type="hidden" id="variation_id_#row_id_#_#property_detail_row_id#" name="variation_id_#row_id_#_#property_detail_row_id#" value="#get_conf_variation_row.variation_property_detail_id#"><input type="text" id="variation_name_#row_id_#_#property_detail_row_id#" name="variation_name_#row_id_#_#property_detail_row_id#" value="#property_detail_row#"></td>
																<td><input type="text" id="variation_value_#row_id_#_#property_detail_row_id#" name="variation_value_#row_id_#_#property_detail_row_id#" value="<cfif isdefined("is_upd_") and is_upd_ eq 1 and get_property_row.recordcount>#tlformat(amount_new_,4)#<cfelse>#tlformat(get_conf_variation_row.variaton_property_value,4)#</cfif>" onKeyUp="return(FormatCurrency(this,event));" style="width:50px;" class="moneybox"></td>
															</tr>
														</cfloop>
													</table>
												</td>
											</tr>													
											</table>
										</td>
									<cfelseif listfind('6',amount_type_)>
										<cfquery name="get_conf_formula" datasource="#dsn3#">
											SELECT * FROM SETUP_PRODUCT_FORMULA_COMPONENTS WHERE PRODUCT_FORMULA_ID = #formula_id_#
										</cfquery>
										<td>
											<table>							
												<cfloop query="get_conf_formula">
													<tr class="color-list" id="compenent_row_frm_row2_#formula_id_#" valign="top">
														<cfset amount_type_formula = get_conf_formula.amount_type>
														<cfset amount_formula = get_conf_formula.amount>
														<cfif len(get_conf_formula.property_id)>
															<cfquery name="get_property_row_name" datasource="#dsn1#">
																SELECT PROPERTY,PROPERTY_ID FROM PRODUCT_PROPERTY WHERE PROPERTY_ID = #get_conf_formula.property_id#
															</cfquery>
															<cfset property_detail_row =  get_property_row_name.PROPERTY>  
															<cfset property_detail_row_id = get_property_row_name.PROPERTY_ID>  
														<cfelse>
															<cfset property_detail_row_id = ''>  
															<cfset property_detail_row = ''>
														</cfif>
														<cfif isdefined("is_upd_") and is_upd_ eq 1>
															<cfquery name="get_property" dbtype="query">
																SELECT * FROM GET_SPECT_ROW WHERE IS_PROPERTY = 1 AND PROPERTY_ID = #property_detail_row_id#
															</cfquery>
															<cfset amount_new = get_property.amount_value>
														</cfif>
														<td class="txtboldblue" width="50">#property_detail_row#</td>
														<cfif listfind('1',amount_type_formula)>
															<td><input name="amount_formula_#row_id_#_#property_detail_row_id#" id="amount_formula_#row_id_#_#property_detail_row_id#" type="text" style="width:50px;" value="<cfif isdefined("amount_new")>#tlformat(amount_new,4)#<cfelseif len(amount_formula)>#tlformat(amount_formula,4)#</cfif>" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"></td>
														<cfelseif listfind('4',amount_type_formula)>
															<cfquery name="get_conf_variation_formula" datasource="#dsn3#">
																SELECT * FROM SETUP_PRODUCT_FORMULA_VARIATION WHERE PRODUCT_FORMULA_ID = #formula_id_#
															</cfquery>
															<td>
																<table>												
																<tr class="color-list" id="compenent_row_frm_row3_#row_id_#" valign="top" <cfif require_type_ eq 2>style="display=none;"</cfif>>
																	<td colspan="2">
																		<table id="table3_#currentrow#" cellpadding="2" cellspacing="1" class="color-header">
																			<tr class="color-list">
																				<td width="10"></td><td width="120" class="txtboldblue"><cf_get_lang dictionary_id='37249.Varyasyon'></td><td class="txtboldblue"><cf_get_lang dictionary_id='50801.Katsayı'></td>
																			</tr>
																			<cfloop query="get_conf_variation_formula">
																				<tr id="variation_row_frm_row_relation_formula_#row_id_#">
																					<cfif len(get_conf_variation_formula.variation_property_detail_id)>
																						<cfquery name="get_property_row_name" datasource="#dsn1#">
																							SELECT PROPERTY_DETAIL,PROPERTY_DETAIL_ID FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID =#get_conf_variation_formula.variation_property_detail_id#
																						</cfquery>
																						<cfset property_detail_row =  get_property_row_name.PROPERTY_DETAIL>  
																						<cfset property_detail_row_id = get_property_row_name.PROPERTY_DETAIL_ID>  
																					<cfelse>
																						<cfset property_detail_row_id = ''>  
																						<cfset property_detail_row =  ''>
																					</cfif>
																					<td><input type="radio" id="configurator_variation_id_formula_#row_id_#" name="configurator_variation_id_formula_#row_id_#" value="#property_detail_row_id#"></td>
																					<td><input type="hidden" id="variation_id_formula_#row_id_#_#property_detail_row_id#" name="variation_id_formula_#row_id_#_#property_detail_row_id#" value="#get_conf_variation_formula.variation_property_detail_id#"><input type="text" id="variation_name_formula_#row_id_#_#property_detail_row_id#" name="variation_name_formula_#row_id_#_#property_detail_row_id#" value="#property_detail_row#"></td>
																					<td><input type="text" id="variation_value_formula_#row_id_#_#property_detail_row_id#" name="variation_value_formula_#row_id_#_#property_detail_row_id#" value="#tlformat(get_conf_variation_formula.variaton_property_value,4)#" onKeyUp="return(FormatCurrency(this,event));" style="width:50px;" class="moneybox"></td>
																				</tr>
																			</cfloop>
																		</table>
																	</td>
																</tr>
																</table>
															</td>
														</cfif>
													</tr>
												</cfloop>
											</table>
										</td>
									</cfif>
								</tr>
							</table>
						</td>
					</tr>
			   </cfoutput>
			   <tr>
					<td>
						<input type="button" name="price_calc" value="Fiyat Hesapla" onclick="calculate_price();">
					</td>
			   </tr>
			   <tr>
					<td><div id="configurator_divid"></div></td>
			   </tr>
			</table>    
		 </td>
	</tr>           
<cfelse>
	<cf_get_lang dictionary_id='60233.Ürüne Ait Konfigürasyon Kaydı Bulunamadı'>!
</cfif>
</table>
</div>
<script language="javascript">
	function calculate_price()
	{
		new_list_req = '';
		new_list_property = '';
		new_list_property_row = '';
		new_list_amount = '';
		new_list_amount_value = '';
		new_list_price_type = '';
		new_list_formula_id = '';
		<cfif get_product_conf.recordcount>
			<cfoutput query="get_conf_compenents">
				<cfset price_type_ = get_conf_compenents.price_type>
				<cfset property_id_ = get_conf_compenents.property_id>
				<cfset property_id_row_ = get_conf_compenents.property_id_row>
				<cfset amount_type_ = get_conf_compenents.amount_type>
				<cfset require_type_ = get_conf_compenents.require_type>
				<cfset formula_id_ = get_conf_compenents.formula_id>
				<cfset amount_ = get_conf_compenents.amount>
				<cfset row_id_ = get_conf_compenents.product_configurator_compenents_id>
				new_list_property = new_list_property+'_'+'#property_id_#';
				<cfif amount_type_ neq 6>
					new_list_price_type = new_list_price_type+'_'+'#price_type_#';
					if('#property_id_row_#' != '')
						new_list_property_row = new_list_property_row+'_'+'#property_id_row_#';
					else
						new_list_property_row = new_list_property_row+'_'+0;
					if('#formula_id_#' != '')
						new_list_formula_id = new_list_formula_id+'_'+'#formula_id_#';
					else
						new_list_formula_id = new_list_formula_id+'_'+0;
				<cfelse>
					new_list_price_type = new_list_price_type+'_'+'1';
					new_list_property_row = new_list_property_row+'_'+0;
					new_list_formula_id = new_list_formula_id+'_'+0;
				</cfif>
				<cfif require_type_ neq 1>
					if(eval('document.all.req_type_#row_id_#')[0].checked == true)
						new_list_req = new_list_req+'_'+1;
					else
						new_list_req = new_list_req+'_'+0;
				<cfelse>
					new_list_req = new_list_req+'_'+1;
				</cfif>
				<cfif listfind('1,2',amount_type_)>
					if(eval('document.all.amount_#row_id_#').value != '')
						new_list_amount = new_list_amount+'_'+eval('document.all.amount_#row_id_#').value;
					else
						new_list_amount = new_list_amount+'_'+0;
					new_list_amount_value = new_list_amount_value+'_'+0;
				<cfelseif listfind('3',amount_type_)>
					if(eval('document.all.amount_value_#row_id_#').value != '')
						new_list_amount_value = new_list_amount_value+'_'+eval('document.all.amount_value_#row_id_#').value;
					else
						new_list_amount_value = new_list_amount_value+'_'+0;
					new_list_amount = new_list_amount+'_'+0;
				<cfelseif listfind('4,5',amount_type_)>
					new_list_amount_value = new_list_amount_value+'_'+0;
					<cfquery name="get_conf_variation_row" dbtype="query">
						SELECT * FROM get_conf_variations WHERE PRODUCT_COMPENENT_ID = #row_id_#
					</cfquery>
					value_var_ = 1;
					<cfloop query="get_conf_variation_row">
						<cfif amount_type_ eq 4>
							/*if(eval('document.all.configurator_variation_id_#row_id_#')['#get_conf_variation_row.currentrow-1#'].checked == true)
							{
								value_var = filterNum(eval('document.all.configurator_variation_id_#row_id_#')['#get_conf_variation_row.currentrow-1#'].value,4);
								value_var_ = filterNum(eval('document.all.variation_value_#row_id_#_'+value_var).value,4);
							}*/
							if(document.getElementsByName('configurator_variation_id_#row_id_#')['#get_conf_variation_row.currentrow-1#'].checked == true)
							{
								value_var = filterNum(document.getElementsByName('configurator_variation_id_#row_id_#')['#get_conf_variation_row.currentrow-1#'].value,4);
								value_var_ = filterNum(document.getElementById('variation_value_#row_id_#_'+value_var).value,4);
							}
						<cfelse>
							value_var_ = parseFloat(value_var_*filterNum(eval('document.all.variation_value_#row_id_#_#get_conf_variation_row.variation_property_detail_id#').value));
						</cfif>
					</cfloop>
					if(value_var_ != '')
						new_list_amount = new_list_amount+'_'+commaSplit(value_var_);
					else
						new_list_amount = new_list_amount+'_'+0;
				<cfelseif listfind('6',amount_type_)>
					new_list_amount = new_list_amount+'_'+0;
					new_list_amount_value = new_list_amount_value+'_'+0;
					<cfquery name="get_conf_formula" datasource="#dsn3#">
						SELECT * FROM SETUP_PRODUCT_FORMULA_COMPONENTS WHERE PRODUCT_FORMULA_ID = #formula_id_#
					</cfquery>
					<cfloop query="get_conf_formula">
						<cfset amount_type_formula = get_conf_formula.amount_type>
						<cfset amount_formula = get_conf_formula.amount>
						<cfset property_detail_row_id = get_conf_formula.property_id>
						new_list_req = new_list_req+'_'+1;
						new_list_price_type = new_list_price_type+'_'+'1';
						new_list_property = new_list_property+'_'+'#property_detail_row_id#';
						new_list_property_row = new_list_property_row+'_'+0;
						if('#formula_id_#' != '')
							new_list_formula_id = new_list_formula_id+'_'+'#formula_id_#';
						else
							new_list_formula_id = new_list_formula_id+'_'+0;
						<cfif listfind('1',amount_type_formula)>
							new_list_amount = new_list_amount+'_'+eval('document.all.amount_formula_#row_id_#_#property_detail_row_id#').value;
							new_list_amount_value = new_list_amount_value+'_'+0;
						<cfelseif listfind('4',amount_type_formula)>
							<cfquery name="get_conf_variation_formula" datasource="#dsn3#">
								SELECT * FROM SETUP_PRODUCT_FORMULA_VARIATION WHERE PRODUCT_FORMULA_ID = #formula_id_#
							</cfquery>
							value_var_ = 1;
							<cfloop query="get_conf_variation_formula">
								<cfif amount_type_formula eq 4>
									if(eval('document.all.configurator_variation_id_formula_#row_id_#')['#get_conf_variation_formula.currentrow-1#'].checked == true)
									{
										value_var = filterNum(eval('document.all.configurator_variation_id_formula_#row_id_#')['#get_conf_variation_formula.currentrow-1#'].value,4);
										value_var_ = filterNum(eval('document.all.variation_value_formula_#row_id_#_'+value_var).value,4);
									}
								<cfelse>
									value_var_ = parseFloat(value_var_*filterNum(eval('document.all.variation_value_formula_#row_id_#_#get_conf_variation_formula.variation_property_detail_id#').value));
								</cfif>
							</cfloop>
							if(value_var_ != '')
								new_list_amount = new_list_amount+'_'+commaSplit(value_var_);
							else
								new_list_amount = new_list_amount+'_'+0;
							new_list_amount_value = new_list_amount_value+'_'+0;
						</cfif>
					</cfloop>
				</cfif>
			</cfoutput>
			var adres = '<cfoutput>#request.self#?fuseaction=objects.emptypopup_calc_spect_new_conf&price=#attributes.price#&configurator_id=#get_product_conf.PRODUCT_CONFIGURATOR_ID#&new_list_property='+new_list_property+'&new_list_property_row='+new_list_property_row+'&new_list_formula_id='+new_list_formula_id+'&new_list_price_type='+new_list_price_type+'&new_list_req='+new_list_req+'&new_list_amount='+new_list_amount+'&new_list_amount_value='+new_list_amount_value</cfoutput>;
			AjaxPageLoad(adres,'configurator_divid','1','');			
		</cfif>
	}
	function show_input(row_no,amount_type_)
	{
		if(eval('document.all.req_type_'+row_no)[0].checked == true)
		{
			eval('td_req_type_3_'+row_no).style.display = '';
			if(amount_type_ == 4 || amount_type_ == 5)
				eval('compenent_row_frm_row2_'+row_no).style.display = '';
			if(amount_type_ == 6)
				eval('compenent_row_frm_row3_'+row_no).style.display = '';
		}
		else
		{
			eval('td_req_type_3_'+row_no).style.display = 'none';
			if(amount_type_ == 4 || amount_type_ == 5)
				eval('compenent_row_frm_row2_'+row_no).style.display = 'none';
			if(amount_type_ == 6)
				eval('compenent_row_frm_row3_'+row_no).style.display = 'none';
		}
	}
	<cfif isdefined("is_upd_") and is_upd_ eq 1>
		calculate_price();
	</cfif>
</script>
