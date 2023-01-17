<cfinclude template="../query/get_money_doviz.cfm">
<cfif isDefined("session.ep") and len(session.ep.our_company_info.is_ifrs eq 1)>
	<cfset is_ifrs = 1>
<cfelse>
	<cfset is_ifrs = 0>
</cfif>
<cfif isdefined("GET_ACCOUNT_CARD") and GET_ACCOUNT_CARD.recordcount>
	<cfif len(GET_ACCOUNT_CARD.record_type)>
		<cfif GET_ACCOUNT_CARD.record_type eq 3>
			<cfset is_ifrs = 1>
		<cfelseif GET_ACCOUNT_CARD.record_type eq 2>
			<cfset is_ifrs = 2>
		<cfelse>
			<cfset is_ifrs = 0>
		</cfif>
	</cfif>
</cfif>
<div class="ui-form-list flex-list">
	<div class="form-group">
		<select name="show_type" id="show_type">
			<option value="1" <cfif is_ifrs eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"></option>
			<option value="2" <cfif is_ifrs eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id="58308.ufrs"></option>
			<option value="3" <cfif is_ifrs eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"> + <cf_get_lang dictionary_id="58308.ufrs"></option>
		</select>
	</div>
</div>
<cf_grid_list sort="0"  id="delete_tr">
		<thead>
			<tr>
				<cfset colspan_ = 8>
				<th><a href="javascript://" onClick="addRow();"><i class="fa fa-plus" alt="<cf_get_lang_main no='295.Satır Ekle'>" title="<cf_get_lang_main no='295.Satır Ekle'>"></i></a></th>
				<th><cf_get_lang_main no='75.No'></th>
				<th><cf_get_lang_main no='1399.Muhasebe Kodu'></th>
				<th id="ifrs" <cfif session.ep.our_company_info.is_ifrs neq 1>style="display:none;"</cfif>><cf_get_lang_main no='718.UFRS Kod'></th>
				<th id="private" <cfif attributes.special_code neq 1><cfif session.ep.our_company_info.is_ifrs neq 1 or (not isdefined("get_account_rows_A") or get_account_card.IS_ACCOUNT_CODE2 neq 1)>style="display:none;"</cfif><cfelse><cfif  get_account_card.IS_ACCOUNT_CODE2 neq 1>style="display:none;"</cfif></cfif>><cf_get_lang_main no='377.Özel Kod'></th>
				<th nowrap="nowrap">&nbsp;</th>
				<th><cf_get_lang dictionary_id='32634.Hesap Adı'></th>
				<th><cf_get_lang_main no='217.Açıklama'></th>
				<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
					<cfset colspan_ = colspan_+1>
					<th><cf_get_lang_main no='160.Departman'></th>
				</cfif>
				<cfif xml_acc_project_info>
					<cfset colspan_ = colspan_+1>
					<th><cf_get_lang_main no='4.Proje'></th>
				</cfif>
				<cfif xml_acc_quantity_info>
					<th><cf_get_lang_main no ='223.Miktar'></th>
				</cfif>
				<cfif xml_acc_price_info>
					<th nowrap="nowrap"><cf_get_lang_main no ='226.Birim Fiyat'></th>
				</cfif>
				<th><cf_get_lang_main no='175.Borç'></th>
				<th><cf_get_lang_main no='176.Alacak'></th>
				<cfif len(session.ep.money2)>
					<th>2.<cf_get_lang dictionary_id="57677.Döviz"></th>
				</cfif>
				<th id="other_money_1" <cfif (not isdefined("get_account_rows_main") or get_account_card.is_other_currency neq 1) and (not isdefined("get_comp_info.is_other_money") or get_comp_info.is_other_money neq 1)>style="display:none;"</cfif>><cf_get_lang_main no='709.Islem Dovizi'></th>
				<th id="other_money_2" <cfif (not isdefined("get_account_rows_main") or get_account_card.is_other_currency neq 1) and (not isdefined("get_comp_info.is_other_money") or get_comp_info.is_other_money neq 1)>style="display:none;"</cfif>><cf_get_lang_main no='77.Para Br'></th>
			</tr>
		</thead>
		<tbody id="table_list">
			<cfif isdefined('attributes.from_rate_valuation')> <!--- kur degerleme sayfasından acılıyorsa --->
				<input type="hidden" name="is_rate_diff" id="is_rate_diff" value="1"> <!--- olusturulacak mahsubun bir kur farkı fişi oldugunu gösteriyor --->
				<cfset acc_currentrow = 0>
				<cfoutput>
					<cfloop from="#attributes.acc_start_row#" to="#attributes.acc_end_row#" index="tsr">
						<cfif isdefined("attributes.is_acc_diff_#tsr#")>				
							<tr id="tr_id#tsr#">
								<td><a href="javascript://" class="btnDelete"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a></td>
								<td id="td_id">#acc_currentrow+1#</td>
								<td nowrap="nowrap">
									<input type="hidden" name="is_rate_diff_row_#acc_currentrow#" id="is_rate_diff_row_#acc_currentrow#" value="1" >
									<input type="text" name="acc_code" id="acc_code#acc_currentrow#" value="#evaluate('attributes.diff_acc_code_#tsr#')#" onFocus="auto_acc_code(#acc_currentrow#);" autocomplete="off">
								</td>
								<td id="ifrs" <cfif session.ep.our_company_info.is_ifrs neq 1>style="display:none;"</cfif>><input type="text" name="ifrs_code" id="ifrs_code" value=""></td>
								<td id="private" style="display:none;"><input type="text" name="account_code2" id="account_code2" value=""></td>
								<td nowrap>
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://"  onClick="pencere_ac(#acc_currentrow#);"></span>
									<a href="javascript://" onClick="ac_hesap_detay(#acc_currentrow#);"><i class="fa fa-table" alt="<cf_get_lang_main no='507.Hareketler'>"></i></a>
								</td>
								<td><input type="text" name="acc_name" id="acc_name#acc_currentrow#" value="#evaluate('attributes.diff_acc_name_#tsr#')#" ></td>
								<td><input type="text" name="detail_#acc_currentrow+1#" id="detail_#acc_currentrow+1#" value="Kur Farkı" onchange="hesapla(-1);" ></td>
								<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
									<td nowrap>
										<input type="hidden" name="acc_department_id#acc_currentrow#" id="acc_department_id#acc_currentrow#" value="">
										<input type="text" name="acc_department_name#acc_currentrow#" id="acc_department_name#acc_currentrow#"  value="" >
										<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_departments&field_id=add_bill.acc_department_id#acc_currentrow#' +'&field_dep_branch_name=add_bill.acc_department_name#acc_currentrow#','list')"></span>
									</td>
								</cfif>
								<cfif xml_acc_project_info>
									<td nowrap="nowrap">
										<div class="input-group">
											<input type="hidden" name="acc_project_id#acc_currentrow#" id="acc_project_id#acc_currentrow#" value="">
											<input type="text" name="acc_project_name#acc_currentrow#" id="acc_project_name#acc_currentrow#" value=""  onFocus="AutoComplete_Create('acc_project_name#acc_currentrow#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','acc_project_id#acc_currentrow#','list_works','3','250');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_bill.acc_project_id#acc_currentrow#' +'&project_head=add_bill.acc_project_name#acc_currentrow#')"></span>
										</div>
									</td>
								</cfif> 
								<cfif xml_acc_quantity_info>
									<td><input type="text" name="quantity" id="quantity" value=""  onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"></td>
								</cfif>
								<cfif xml_acc_price_info>
									<td><input type="text" name="price" id="price" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"></td>
								</cfif>
								<td><input type="text" name="debt" id="debt" value="<cfif (evaluate('attributes.diff_bakiye_type_#tsr#') eq 0 and evaluate('attributes.is_acc_diff_#tsr#') gt 0) or ((evaluate('attributes.diff_bakiye_type_#tsr#') eq 1 and evaluate('attributes.is_acc_diff_#tsr#') lt 0)) >#TLFormat(abs(evaluate('attributes.is_acc_diff_#tsr#')))#</cfif>" onchange="hesapla(0);" onBlur="f_kur_hesapla(this.value,'#acc_currentrow#');hesapla(0);" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
								<td><input type="text" name="claim" id="claim" value="<cfif (evaluate('attributes.diff_bakiye_type_#tsr#') eq 1 and evaluate('attributes.is_acc_diff_#tsr#') gt 0) or (evaluate('attributes.diff_bakiye_type_#tsr#') eq 0 and evaluate('attributes.is_acc_diff_#tsr#') lt 0)>#TLFormat(abs(evaluate('attributes.is_acc_diff_#tsr#')))#</cfif>" onchange="hesapla(1);" onBlur="f_kur_hesapla(this.value,'#acc_currentrow#');hesapla(1);" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
								<cfif len(session.ep.money2)>
									<td><input type="text" name="amount_2" id="amount_2" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" <cfif xml_change_doviz eq 0>readonly="readonly"</cfif>></td>
								</cfif>
								<td id="other_money_1"><input type="text" name="other_amount" id="other_amount" value="#TLFormat(0)#" <cfif xml_islem_dovizli eq 1>onBlur="f_kur_hesapla(-1,'#acc_currentrow#');"</cfif> onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
								<td id="other_money_2">
									<select name="other_currency" id="other_currency" >
										<cfloop query="get_money_doviz">
											<option value="#money#" <cfif evaluate('attributes.acc_diff_money_#tsr#') is money>selected</cfif>>#money#</option>
										</cfloop>
									</select>
								</td>
							</tr>
							<cfset acc_currentrow = acc_currentrow + 1>
						</cfif>
					</cfloop>
				</cfoutput>
			<cfelseif isdefined("get_account_rows_main")>
				<cfset dep_id_list=''>
				<cfoutput query="get_account_rows_main">
					<cfif len(ACC_DEPARTMENT_ID) and not listfind(dep_id_list,ACC_DEPARTMENT_ID)>
					<cfset dep_id_list=listappend(dep_id_list,ACC_DEPARTMENT_ID)>
					</cfif>
				</cfoutput>
				<cfif len(dep_id_list)>
					<cfset dep_id_list=listsort(dep_id_list,"numeric","ASC",",")>
					<cfquery name="get_dep_detail" datasource="#dsn#">
						SELECT
							D.DEPARTMENT_HEAD,
							B.BRANCH_NAME
						FROM
							DEPARTMENT D,
							BRANCH B
						WHERE
							D.BRANCH_ID=B.BRANCH_ID
							AND D.DEPARTMENT_ID IN (#dep_id_list#)
						ORDER BY
							D.DEPARTMENT_ID
					</cfquery>
				</cfif>
				<cfoutput query="get_account_rows_main">
					<cfset degisken_money = '#get_account_rows_main.OTHER_CURRENCY#'>
					<tr id="tr_id#currentrow#">
						<td><a href="javascript://" class="btnDelete"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a></td>
						<td id="td_id">#currentrow#</td>
						<td nowrap>
							<div class="form-group">
								<div class="input-group">
									<input type="text" name="acc_code" id="acc_code#currentrow#" value="#ACCOUNT_ID#" onFocus="auto_acc_code(#currentrow#);" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac(#currentrow#);"></span>
								</div>
							</div>			
						</td>
						<td id="ifrs" <cfif session.ep.our_company_info.is_ifrs neq 1>style="display:none;"</cfif>>
							<div class="form-group"> 
								<input type="text" name="ifrs_code" id="ifrs_code" value="#IFRS_CODE#">
							</div>		
						</td>
						<td id="private" <cfif session.ep.our_company_info.is_ifrs neq 1 or get_account_card.IS_ACCOUNT_CODE2 neq 1>style="display:none;"</cfif>>
							<div class="form-group"> 
								<input type="text" name="account_code2" id="account_code2" value="#ACCOUNT_CODE2#">
							</div>		
						</td>
						<td nowrap>
							<a href="javascript://" onClick="ac_hesap_detay(#currentrow#);"><i class="fa fa-table" alt="<cf_get_lang_main no='507.Hareketler'>"></i></a>
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="acc_name" id="acc_name#currentrow#" value="#ACCOUNT_NAME#" >
							</div>	
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="detail_#currentrow#" id="detail_#currentrow#" value="#DETAIL#" onchange="hesapla(-1);" >
							</div>	
						</td>
						<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="acc_department_id#currentrow#" id="acc_department_id#currentrow#" value="#ACC_DEPARTMENT_ID#">
										<input type="text" name="acc_department_name#currentrow#" id="acc_department_name#currentrow#"  value="<cfif len(ACC_DEPARTMENT_ID)>#get_dep_detail.BRANCH_NAME[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]# - #get_dep_detail.DEPARTMENT_HEAD[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]#</cfif>" >
										<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_departments&field_id=add_bill.acc_department_id#currentrow#' +'&field_dep_branch_name=add_bill.acc_department_name#currentrow#','list')" ></span>
									</div>
								</div>		
							</td>
						</cfif>
						<cfif xml_acc_project_info>
							<td nowrap="nowrap">
								<div class="form-group">
									<div class="input-group">
										<input type="hidden" name="acc_project_id#currentrow#" id="acc_project_id#currentrow#" value="#acc_project_id#">
										<input type="text" name="acc_project_name#currentrow#" id="acc_project_name#currentrow#"  value="<cfif len(acc_project_id)>#get_project_name(acc_project_id)#</cfif>" onFocus="AutoComplete_Create('acc_project_name#currentrow#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','acc_project_id#currentrow#','list_works','3','250');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_bill.acc_project_id#currentrow#' +'&project_head=add_bill.acc_project_name#currentrow#')" ></span>
									</div>
								</div>
							</td>
						</cfif>
						<cfif xml_acc_quantity_info>
							<td>
								<div class="form-group">
									<input type="text" name="quantity" id="quantity" value="<cfif len(QUANTITY)>#TLFormat(QUANTITY)#</cfif>"  onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
								</div>
							</td>
						</cfif>
						<cfif xml_acc_price_info>
							<td>
								<div class="form-group">
									<input type="text" name="price" id="price" value="<cfif len(PRICE)>#TLFormat(PRICE)#</cfif>" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
								</div>	
							</td>
						</cfif>
						<td>
							<div class="form-group">
								<input type="text" name="debt" id="debt" value="<cfif BA eq 0>#TLFormat(AMOUNT)#</cfif>" onchange="hesapla(0);" onBlur="hesapla(0);f_kur_hesapla(1,'#currentrow#');" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
							</div>	
						</td>
						<td>
							<div class="form-group">
								<input type="text" name="claim" id="claim"  value="<cfif BA eq 1>#TLFormat(AMOUNT)#</cfif>" onchange="hesapla(1);" onBlur="hesapla(1);f_kur_hesapla(1,'#currentrow#');" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
							</div>
						</td>
						<cfif len(session.ep.money2)>
							<td>
								<div class="form-group">
									<input type="text" name="amount_2" id="amount_2" value="#TLFormat(AMOUNT_2)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox" <cfif xml_change_doviz eq 0>readonly="readonly"</cfif>>
								</div>
							</td>
						</cfif>
						<td id="other_money_1" <cfif get_account_card.is_other_currency neq 1>style="display:none;"</cfif>>
							<div class="form-group">
								<input type="text" name="other_amount" id="other_amount" value="#TLFormat(OTHER_AMOUNT)#" <cfif xml_islem_dovizli eq 1>onBlur="f_kur_hesapla(-1,'#currentrow#');"</cfif> onkeyup="return(FormatCurrency(this,event));" class="moneybox">
							</div>
						</td>
						<td id="other_money_2" <cfif get_account_card.is_other_currency neq 1>style="display:none;"</cfif>>
							<div class="form-group">
								<select name="other_currency" id="other_currency"  onChange="f_kur_hesapla(this.value,'#currentrow#');hesapla();">
									<cfloop query="get_money_doviz">
										<option value="#money#"<cfif money is degisken_money> selected</cfif>>#money#</option>
									</cfloop>
								</select>
							</div>		
						</td>
					</tr>
				</cfoutput>
			<!---
				<cfif get_account_rows_main.recordcount eq 1>
					<tr>
						<td><a href="javascript://" class="btnDelete"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a></td>
						<td id="td_id">2</td>
						<td nowrap>
							<input type="text" name="acc_code" id="acc_code" onFocus="AutoComplete_Create('acc_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','CODE_NAME','acc_name','','3','250');" autocomplete="off">
						</td>
						<td id="ifrs" <cfif session.ep.our_company_info.is_ifrs neq 1>style="display:none;"</cfif>>
							<input type="text" name="ifrs_code" id="ifrs_code" value="">
						</td>
						<td id="private" <cfif session.ep.our_company_info.is_ifrs neq 1 or get_account_card.IS_ACCOUNT_CODE2 neq 1>style="display:none;"</cfif>><input type="text" name="account_code2" id="account_code2" value=""></td>
						<td nowrap>
							<div class="input-group">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac(2);"></span>
							</div>
							<a href="javascript://" onClick="ac_hesap_detay(2);"><i class="fa fa-table" alt="<cf_get_lang_main no='507.Hareketler'>"></i></a>
						</td>
						<td><input type="text" name="acc_name" id="acc_name" ></td>
						<td><input type="text" name="detail_2" id="detail_2" onchange="hesapla(-1);" ></td>
						<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
							<td nowrap>
								<cfif len(get_account_rows_main.ACC_DEPARTMENT_ID)>
									<cfquery name="get_dep_detail" datasource="#dsn#">
										SELECT
											D.DEPARTMENT_HEAD,
											B.BRANCH_NAME
										FROM
											DEPARTMENT D,
											BRANCH B
										WHERE
											D.BRANCH_ID=B.BRANCH_ID
											AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_account_rows_main.ACC_DEPARTMENT_ID#">
									</cfquery>
								</cfif>
								<div class="input-group">
									<input type="hidden" name="acc_department_id1" id="acc_department_id1" value="#get_account_rows_main.ACC_DEPARTMENT_ID#">
									<input type="text" name="acc_department_name1" id="acc_department_name1"  value="<cfif len(get_account_rows_main.ACC_DEPARTMENT_ID)>#get_dep_detail.BRANCH_NAME[listfind(dep_id_list,get_account_rows_main.ACC_DEPARTMENT_ID,',')]# - #get_dep_detail.DEPARTMENT_HEAD[listfind(dep_id_list,get_account_rows_main.ACC_DEPARTMENT_ID,',')]#</cfif>" >
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_departments&field_id=add_bill.acc_department_id1&field_dep_branch_name=add_bill.acc_department_name1','list')"></span>
								</div>
							</td>
						</cfif>
						<cfif xml_acc_project_info>
							<td>
								<div class="input-group">
									<input type="hidden" name="acc_project_id1" id="acc_project_id1" value="#get_account_rows_main.acc_project_id#">
									<input type="text" name="acc_project_name1" id="acc_project_name1" value="<cfif len(get_account_rows_main.acc_project_id)>#get_project_name(get_account_rows_main.acc_project_id)#</cfif>"  onFocus="AutoComplete_Create('acc_project_name1','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','acc_project_id1','list_works','3','250');" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_bill.acc_project_id1&project_head=add_bill.acc_project_name1','list')"></span>
								</div>
							</td>
						</cfif>
						<cfif xml_acc_quantity_info>
							<td><input type="text" name="quantity" id="quantity" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox" ></td>
						</cfif>
						<cfif xml_acc_price_info>
							<td><input type="text" name="price" id="price" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"></td>
						</cfif>
						<td><input type="text" name="debt" id="debt" onchange="hesapla(0);" onBlur="hesapla(0);" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
						<td><input type="text" name="claim" id="claim" onchange="hesapla(1);" onBlur="hesapla(1);" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
						<cfif len(session.ep.money2)>
							<td><input type="text" name="amount_2" id="amount_2" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox" <cfif xml_change_doviz eq 0>readonly="readonly"</cfif>></td>
						</cfif>
						<td id="other_money_1" <cfif get_account_card.is_other_currency neq 1>style="display:none;"</cfif>><input type="text" name="other_amount" id="other_amount" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></td>
						<td id="other_money_2" <cfif get_account_card.is_other_currency neq 1>style="display:none;"</cfif>>
						<select name="other_currency" id="other_currency" >
							<cfloop query="get_money_doviz">
								<option value="#money#">#money#</option>
							</cfloop>
						</select>
						</td>
					</tr>
				</cfif>
				--->
			<cfelse>
				<cfoutput>
					<cfloop from="1" to="10" index="i">
						<tr id="tr_id#i#">
							<td><a href="javascript://" class="btnDelete"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a></td>
							<td id="td_id">#i#</td>
							<td>
								<div class="form-group">
									<div class="input-group">
										<input type="text" name="acc_code" id="acc_code#i#" onFocus="auto_acc_code(#i#);">
										<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac(#i#);" alt="<cf_get_lang_main no='322.Seçiniz'>" align="absmiddle" border="0"></span>
									</div>
								</div>		
							</td>
							<td id="ifrs" <cfif session.ep.our_company_info.is_ifrs neq 1>style="display:none;"</cfif>>
								<div class="form-group">
									<input type="text" name="ifrs_code" id="ifrs_code" value="">
								</div>		
							</td>
							<td id="private" style="display:none;">
								<div class="form-group">
									<input type="text" name="account_code2" id="account_code2" value="">
								</div>		 
							</td>
							<td nowrap>
								<a href="javascript://" onClick="ac_hesap_detay(#i#);"><i class="fa fa-table" alt="<cf_get_lang_main no='507.Hareketler'>"></i></a>
							</td>
							<td>
								<div class="form-group">
									<input type="text" name="acc_name" id="acc_name#i#">
								</div>		
							</td>
							<td>
								<div class="form-group">
									<input type="text" name="detail_#i#" id="detail_#i#" onchange="hesapla(-1);" maxlength="100" >
								</div>	
							</td>
							<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
								<td nowrap>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="acc_department_id#i#" id="acc_department_id#i#" value="">
											<input type="text" name="acc_department_name#i#" id="acc_department_name#i#"  value="">
											<span class="input-group-addon btnPointer icon-ellipsis"  href="javascript://" alt="<cf_get_lang_main no='322.seçiniz'>" title="<cf_get_lang_main no='322.seçiniz'>" border="0" align="absmiddle" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_departments&field_id=add_bill.acc_department_id#i#' +'&field_dep_branch_name=add_bill.acc_department_name#i#','list')" ></span>
										</div>
									</div>	
								</td>
							</cfif>
							<cfif xml_acc_project_info>
								<td nowrap="nowrap">
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="acc_project_id#i#" id="acc_project_id#i#" value="">
											<input type="text" name="acc_project_name#i#" id="acc_project_name#i#" value=""   onFocus="AutoComplete_Create('acc_project_name#i#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','acc_project_id#i#','list_works','3','250');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" alt="<cf_get_lang_main no='322.seçiniz'>" title="<cf_get_lang_main no='322.seçiniz'>" border="0" align="top" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_bill.acc_project_id#i#' +'&project_head=add_bill.acc_project_name#i#')" ></span>
										</div>
									</div>
								</td>
							</cfif>
							<cfif xml_acc_quantity_info> 
							<td>
								<div class="form-group">
									<input type="text" name="quantity" id="quantity" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
								</div>
							</td>
							</cfif>
							<cfif xml_acc_price_info>
								<td>
									<div class="form-group">
										<input type="text" name="price" id="price" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
									</div>	
								</td>
							</cfif>
							<td>
								<div class="form-group">
									<input type="text" name="debt" id="debt" onchange="hesapla(0);" onBlur="hesapla(0);f_kur_hesapla(1,'#i#');" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
								</div>	
							</td>
							<td>
								<div class="form-group">
									<input type="text" name="claim" id="claim" onchange="hesapla(1);" onBlur="hesapla(1);f_kur_hesapla(1,'#i#');" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
								</div>	
							</td>
							<cfif len(session.ep.money2)>
								<td nowrap="nowrap">
									<div class="form-group">
										<input type="text" name="amount_2" id="amount_2"  onkeyup="return(FormatCurrency(this,event));" class="moneybox" <cfif xml_change_doviz eq 0>readonly="readonly"</cfif>>
									</div>	
								</td>
							</cfif>
							<td id="other_money_1" <cfif not isdefined("get_comp_info.is_other_money") or get_comp_info.is_other_money neq 1>style="display:none;"</cfif>>
								<div class="form-group">
									<input type="text" name="other_amount" id="other_amount" value="" <cfif xml_islem_dovizli eq 1>onBlur="f_kur_hesapla(-1,'#i#');"</cfif> onkeyup="return(FormatCurrency(this,event));" class="moneybox">
								</div>	
							</td>
							<td id="other_money_2" <cfif not isdefined("get_comp_info.is_other_money") or get_comp_info.is_other_money neq 1>style="display:none;"</cfif>>
								<div class="form-group">
									<select name="other_currency" id="other_currency" onChange="f_kur_hesapla(this.value,'#i#');">
										<cfloop query="get_money_doviz">
											<option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
										</cfloop>
									</select>
								</div>		
							</td>
						</tr>
					</cfloop>
				</cfoutput>
			</cfif>
		</tbody>
</cf_grid_list>

<div class="ui-info-bottom">
	<table>
		<tr>
			<td width="60" class="txtbold"><cf_get_lang_main no='80.Toplam'></td>
			<td width="125" id="td_debt" style="text-align:right;"></td>
			<td width="125" id="td_claim" style="text-align:right;"></td>
			<td id="other_money_1" <cfif (not isdefined("get_account_rows_main") or get_account_card.is_other_currency neq 1) and (not isdefined("get_comp_info.is_other_money") or get_comp_info.is_other_money neq 1)>style="display:none;"</cfif>>&nbsp;</td>
			<td id="other_money_2" <cfif (not isdefined("get_account_rows_main") or get_account_card.is_other_currency neq 1) and (not isdefined("get_comp_info.is_other_money") or get_comp_info.is_other_money neq 1)>style="display:none;"</cfif>>&nbsp;</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang_main no='177.Bakiye'></td>
			<td width="125" id="td_bakiye" style="text-align:right;" nowrap="nowrap"></td>
			<td>&nbsp;</td>
			<td id="other_money_1" colspan="2" <cfif (not isdefined("get_account_rows_main") or get_account_card.is_other_currency neq 1) and (not isdefined("get_comp_info.is_other_money") or get_comp_info.is_other_money neq 1)>style="display:none;"</cfif>>&nbsp;</td>
		</tr>
		<input type="hidden" name="debt_total" id="debt_total" value="">
		<input type="hidden" name="claim_total" id="claim_total" value="">
		<input type="hidden" name="total" id="total" value="">
		<input type="hidden" name="rowCount" id="rowCount" value="">
	</table>
</div>
<script type="text/javascript">
	/*kur degerleme sayfasından acılıyorsa*/
	<cfoutput>
		rowCount = <cfif isdefined("from_rate_valuation")>#acc_currentrow#<cfelseif isdefined("get_account_rows_main")>#get_account_rows_main.recordcount#<cfelse>10</cfif>;
	</cfoutput>
	/* <cfif isdefined("get_account_rows_main") and get_account_rows_main.recordcount eq 1>
		rowCount++;
	</cfif> */
	add_bill.rowCount.value = rowCount;
	var money2_js = <cfoutput>'#session.ep.money2#'</cfoutput>;
	var session_money_round='<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>';
		 
	function auto_acc_code(no)
	{
		AutoComplete_Create('acc_code'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','CODE_NAME','acc_name'+no,'','3','250');
	}
	
	function hesapla(gelen)
	{
		t_debt = 0;
		t_claim = 0;
		if(rowCount==1)
		{
			add_bill.debt.value = filterNum(add_bill.debt.value);
			add_bill.claim.value = filterNum(add_bill.claim.value);
			if ( (gelen == 0) && (add_bill.debt.value.length) && (add_bill.claim.value.length) )
				add_bill.claim.value = '';
			else if  ((gelen == 1) && (add_bill.debt.value.length) && (add_bill.claim.value.length) )
				add_bill.debt.value = '';
			if (add_bill.debt.value.length)
				t_debt += parseFloat(add_bill.debt.value);
			if (add_bill.claim.value.length)
				t_claim += parseFloat(add_bill.claim.value);
			add_bill.debt.value = commaSplit(add_bill.debt.value);
			add_bill.claim.value = commaSplit(add_bill.claim.value);
		}
		else
		{
			for (var jj=0; jj < rowCount; jj++)
			{ 
				add_bill.debt[jj].value = filterNum(add_bill.debt[jj].value);
				add_bill.claim[jj].value = filterNum(add_bill.claim[jj].value);
				if ( (gelen == 0) && (add_bill.debt[jj].value.length) && (add_bill.claim[jj].value.length) )
					add_bill.claim[jj].value = '';
				else if  ((gelen == 1) && (add_bill.debt[jj].value.length) && (add_bill.claim[jj].value.length) )
					add_bill.debt[jj].value = '';
				if (add_bill.debt[jj].value.length)
					t_debt += parseFloat(add_bill.debt[jj].value);
				if (add_bill.claim[jj].value.length)
					t_claim += parseFloat(add_bill.claim[jj].value);
				add_bill.debt[jj].value = commaSplit(add_bill.debt[jj].value);
				add_bill.claim[jj].value = commaSplit(add_bill.claim[jj].value);
			}
		}
		t_debt = wrk_round(t_debt);
		t_claim = wrk_round(t_claim);
		add_bill.debt_total.value = t_debt;
		add_bill.claim_total.value = t_claim;
		if (t_debt >= t_claim) add_bill.total.value = wrk_round(t_debt - t_claim);
		else add_bill.total.value = wrk_round(t_claim - t_debt);
	
		td_debt.innerHTML = commaSplit(add_bill.debt_total.value);
		td_debt_ust.innerHTML = commaSplit(add_bill.debt_total.value);
		td_claim.innerHTML = commaSplit(add_bill.claim_total.value);
		td_claim_ust.innerHTML = commaSplit(add_bill.claim_total.value);
		td_bakiye.innerHTML = commaSplit(add_bill.total.value);
		td_bakiye_ust.innerHTML = commaSplit(add_bill.total.value);
		if (t_debt > t_claim)
			{td_bakiye.innerHTML += ' <cfoutput>#session.ep.money#</cfoutput> Borç';td_bakiye_ust_ba.innerHTML = '(B)';}
		else if (t_debt < t_claim)
			{td_bakiye.innerHTML += ' <cfoutput>#session.ep.money#</cfoutput> Alacak';td_bakiye_ust_ba.innerHTML = '(A)';}
		else
			{td_bakiye.innerHTML += '';}
	}
	
	hesapla(-1);
		
	function kontrol()
	{
		for(i=1;i<=rowCount;i++){
			var detail = $.trim( $("#detail_"+i).val() );
			if( detail != '' ){
				if(detail.includes('--')){
					var det=detail.replace(/--/gi, '-');
					$('#detail_'+i).val(det);
				}
			}
		}
		if(!chk_process_cat('add_bill')) return false;
		if(!check_display_files('add_bill')) return false;
		document.getElementById('is_other_currency').disabled = false;
		if(!kontrol2())/*20050331*/
		{
			setTimeout("add_bill.wrk_submit_button.disabled=false",10);
			return false;
		}
		return true;
	}
	
	function kontrol2()
	{
		if(document.getElementById('document_type').value != '' && document.getElementById('paper_no').value == '')
		{
			alert("<cf_get_lang_main no='1144.Belge No Giriniz'>!");
			return false;
		}
				
		if((document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3) && document.getElementById('due_date').value == '')
		{
			alert("<cf_get_lang_main no='2587.Vade Tarihi Giriniz'>!");
			return false;
		}
		
		if(add_bill.bill_detail.value.length > 150)
		{
			alert("<cf_get_lang no='122.Açıklama Uzunluğunu Aştınız'>!");
			return false;
		}
		if (!chk_period(add_bill.process_date,'İşlem')) return false;
		if(rowCount==1)
		{
			for (var j=0; j < rowCount; j++)
			{
				if ((!add_bill.acc_code.value.length) && ( (add_bill.debt.value.length) || (add_bill.claim.value.length) ) )
				{
					alert((j+1) + ".<cf_get_lang no ='159.satırın Muhasebe Kodu Olmamasına Rağmen Bakiyesi Var '> !");
					return false;
				}
			}
		}
		else
		{
			for (var j=0; j < rowCount; j++)
			{
				if ((!add_bill.acc_code[j].value.length) && ( (add_bill.debt[j].value.length) || (add_bill.claim[j].value.length) ) )
				{
					alert((j+1) + ".<cf_get_lang no ='159.satırın Muhasebe Kodu Olmamasına Rağmen Bakiyesi Var '> !");
					return false;
				}
			}
		}
		a=1/0;
		hesapla(-1);
		if(add_bill.debt_total.value==0){alert(<cfoutput>"#getLang('account',160)#"</cfoutput>);return false;}
		if (add_bill.total.value == 0 || $("#ct_process_type_"+$("#process_cat").val()).val() == 10)
		{
			for (var j=0; j < rowCount; j++)
			{ 
				

				<cfif xml_acc_quantity_info>add_bill.quantity[j].value = filterNum(add_bill.quantity[j].value);</cfif>
				<cfif xml_acc_price_info>add_bill.price[j].value = filterNum(add_bill.price[j].value);</cfif>
				add_bill.debt[j].value = filterNum(add_bill.debt[j].value);
				add_bill.claim[j].value = filterNum(add_bill.claim[j].value);
				add_bill.other_amount[j].value = filterNum(add_bill.other_amount[j].value);
				if((add_bill.amount_2 != undefined) && (add_bill.amount_2[j] != undefined))//Sistem Para Birimi 2 tanimli ise
					add_bill.amount_2[j].value = filterNum(add_bill.amount_2[j].value);
				
				if(add_bill.debt[j].value == '') add_bill.debt[j].value = 0;
				if(add_bill.claim[j].value == '') add_bill.claim[j].value = 0;
				if(add_bill.other_amount[j].value == '') add_bill.other_amount[j].value = 0;
				if((add_bill.amount_2 != undefined) && (add_bill.amount_2[j] != undefined))
					if(add_bill.amount_2[j].value == '') add_bill.amount_2[j].value = 0;
				<cfif xml_acc_quantity_info>if(add_bill.quantity[j].value == '') add_bill.quantity[j].value = 0;</cfif>
				if(add_bill.ifrs_code[j].value == '') add_bill.ifrs_code[j].value = 0;
				if(add_bill.account_code2[j].value == '') add_bill.account_code2[j].value = 0;
				<cfif xml_acc_price_info>if(add_bill.price[j].value == '') add_bill.price[j].value = 0;</cfif>
			}
			for(var i=1;i<=add_bill.kur_say.value;i++)
			{
				eval('add_bill.txt_rate1_' + i).value = filterNum(eval('add_bill.txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				eval('add_bill.txt_rate2_' + i).value = filterNum(eval('add_bill.txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
			if(document.getElementById("document_type").value == '' && document.getElementById("payment_type").value != '')
			{
				if (!confirm("<cf_get_lang no ='311.Belge tipi seçmediniz. Kaydetmek istediğinizden emin misiniz'>?"))
					return false;
			}
			if(document.getElementById("payment_type").value == '' && document.getElementById("document_type").value != '')
			{
				if (!confirm("<cf_get_lang no ='312.Ödeme şekli seçmediniz. Kaydetmek istediğinizden emin misiniz'>?"))
					return false;
			}
			return true;
		}
		else 
		{
			if($("#ct_process_type_"+$("#process_cat").val()).val() != 10 ){
				alert(<cfoutput>"#getLang('account',160)#"</cfoutput>)
				//alert("<cf_get_lang no ='313.Bakiye (0) Sıfır Olmalıdır'>!");
				return false;
			}
			else
			return true;
		}
		return true;
	}		
	function pencere_ac(row)
	{
		row --;
		if (add_bill.acc_code[row].value.length != 0)
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_bill.acc_code[' + row + ']&field_ufrs_no=add_bill.ifrs_code[' + row + ']&field_name=add_bill.acc_name[' + row + ']&account_code=' + add_bill.acc_code[row].value );
		else
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_bill.acc_code[' + row + ']&field_ufrs_no=add_bill.ifrs_code[' + row + ']&field_name=add_bill.acc_name[' + row + ']');
	}
	function addRow()
	{
		rowCount++;
		add_bill.rowCount.value = rowCount;
		var newRow;
		var newCell;
		newRow = document.getElementById("table_list").insertRow(-1);
		newCell = newRow.insertCell(newRow.cells.length);
		newRow.setAttribute("id","tr_id" + rowCount);
		newCell.innerHTML = '<a href="javascript://" class="btnDelete"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='57463.Sil'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = rowCount;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML =  '<div class="form-group"><div class="input-group"><input type="text" name="acc_code" id="acc_code' + rowCount + '" onFocus="auto_acc_code(' + rowCount + ');" autocomplete="off"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac(' + rowCount + ');"></span></div></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		
		newCell.id = 'ifrs';
		if(document.add_bill.is_ifrs != undefined && document.add_bill.is_ifrs.checked) newCell.style.display = ''; else newCell.style.display = 'none';
		newCell.innerHTML = '<div class="form-group"><input type="text" name="ifrs_code" value=""></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		
		newCell.id = 'private';
		if(document.add_bill.IS_ACCOUNT_CODE2 != undefined && document.add_bill.IS_ACCOUNT_CODE2.checked) newCell.style.display = ''; else newCell.style.display = 'none';
		newCell.innerHTML = '<div class="form-group"><input type="text" name="account_code2" value="" ></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML += ' <a href="javascript://" onClick="ac_hesap_detay(' + rowCount + ');"><i class="fa fa-table" alt="<cf_get_lang_main no='507.Hareketler'>"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		
		newCell.innerHTML = '<div class="form-group"><input type="text" name="acc_name" id="acc_name' + rowCount + '" ></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text"  id="detail_' + rowCount + '" name="detail_' + rowCount + '" onchange="hesapla(-1);" ></div>';
		
		<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="acc_department_id' + rowCount + '"><input type="text" name="acc_department_name' + rowCount + '" ><span class="input-group-addon btnPointer icon-ellipsis"href="javascript://" onClick="select_acc_department('+ rowCount +');"></span></div></div>';
		</cfif>	
		<cfif xml_acc_project_info>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="acc_project_id' + rowCount + '" id="acc_project_id' + rowCount + '"><input type="text" name="acc_project_name' + rowCount + '" id="acc_project_name' + rowCount + '"  onFocus="auto_project('+ rowCount +');" autocomplete="off"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="select_acc_project('+ rowCount +');"></span></div></div>';
		</cfif>
		<cfif xml_acc_quantity_info>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="quantity" value="" onkeyup="return(FormatCurrency(this,event,4));"  class="moneybox"></div>';
		</cfif>
		<cfif xml_acc_price_info>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="price" value="" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox"></div>';
		</cfif>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="debt" value="" onchange="hesapla(0);" onBlur="f_kur_hesapla(1,' + rowCount + ');hesapla();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="claim" value="" onchange="hesapla(1);" onBlur="f_kur_hesapla(1,' + rowCount + ');hesapla();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
		if(money2_js != '')
		{
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="amount_2" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
		}
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.id = 'other_money_1';
		if(document.add_bill.is_other_currency.checked) newCell.style.display = ''; else newCell.style.display = 'none';
		newCell.innerHTML = '<div class="form-group"><input type="text" name="other_amount" id="other_amount" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.id = 'other_money_2';
		if(document.add_bill.is_other_currency.checked) newCell.style.display = ''; else newCell.style.display = 'none';
		newCell.innerHTML = '<div class="form-group"><select name="other_currency" id="other_currency"  onChange="f_kur_hesapla(this.value,' + rowCount + ');hesapla();"><cfoutput query="get_money_doviz"><option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select></div>';
	}
		
	$('#delete_tr').on('click','.btnDelete',function () {
		yer = $('#delete_tr tr').index($(this).closest('tr'));
		if(yer==1 && rowCount==1)
		{	
			add_bill.debt.value = '';
			add_bill.claim.value = '';
			add_bill.acc_code.value = '';
			add_bill.acc_name.value = '';
			add_bill.other_amount.value = '';
			add_bill.ifrs_code.value = '';
			add_bill.account_code2.value = '';
			if ((add_bill.amount_2 != undefined))
			add_bill.amount_2.value = '';		
			temp_element = eval('add_bill.detail_'+yer);
		}
		else
		{
			add_bill.debt[yer-1].value = '';
			add_bill.claim[yer-1].value = '';
			add_bill.acc_code[yer-1].value = '';
			add_bill.acc_name[yer-1].value = '';
			add_bill.other_amount[yer-1].value = '';
			add_bill.ifrs_code[yer-1].value = '';
			add_bill.account_code2[yer-1].value = '';
			if ((add_bill.amount_2 != undefined) && (add_bill.amount_2[yer-1] != undefined))
				add_bill.amount_2[yer-1].value = '';
		
			
			add_bill.other_amount[yer-1].value = '';
			temp_element = eval('add_bill.detail_'+yer);
		}
		temp_element.value = '';
		hesapla(-1);
		$("#tr_id"+yer).css("display", "none");
	});
		
	function ac_hesap_detay(code_row)
	{
		try {
			code_row --;
			if(rowCount==1)	code_ = add_bill.acc_code.value;	
			else code_ = add_bill.acc_code[code_row].value;
			if(code_.length)
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_list_account_plan_rows&code=' + code_,'wide');	
			}
		catch(e){}	
	}	
		
	function other_money_action()
	{
		for(var jmk=0; jmk < rowCount+1; jmk++)
		{
			gizle_goster(other_money_1[jmk]);
			gizle_goster(other_money_2[jmk]);
		}
	}
	
	function ifrs_action()
	{
		for (var rs=0; rs < rowCount+1; rs++)
			gizle_goster(ifrs[rs]);
	}
	
	function private_code_action()
	{
		for (var prv=0; prv < rowCount+1; prv++)
			gizle_goster(private[prv]);
	}
	/* temp_act:1 ise borc ya da alacak degismistir, -1 ise islem dovizi degismistir */
	function f_kur_hesapla(temp_act,row_no)
	{
		if(rowCount==1)//tek satırlı işlemlerde
		{	
			if(add_bill.claim.value != '')
				row_amount_ = filterNum(add_bill.claim.value);
			else if(add_bill.debt.value != '')
				row_amount_ = filterNum(add_bill.debt.value);
			else
				row_amount_ = '';
	
			if(temp_act == 1) //borc-alacak tutarları degistiginde
				temp_act = add_bill.other_currency.value;
			else if(temp_act == -1)
				currency_ = add_bill.other_currency.value;
	
			if(row_amount_ != undefined && row_amount_ != '')
			{
				for(var i=1;i<=<cfoutput>#get_money_bskt.recordcount#</cfoutput>;i++)
				{
					if(temp_act == -1)
					{
						if(eval('add_bill.hidden_rd_money_'+i).value == currency_)
						{
							rate1_ = filterNum(eval('add_bill.txt_rate1_' + i).value,session_money_round);
							rate2_ = filterNum(eval('add_bill.txt_rate2_' + i).value,session_money_round);
							if(add_bill.claim.value != '')
								add_bill.claim.value = commaSplit(filterNum(add_bill.other_amount.value)*rate2_/rate1_);
							else if(add_bill.debt.value != '')
								add_bill.debt.value = commaSplit(filterNum(add_bill.other_amount.value)*rate2_/rate1_);
						}
					}
					if((eval('add_bill.hidden_rd_money_'+i).value == temp_act || eval('add_bill.hidden_rd_money_'+i).value == money2_js) & temp_act != -1)
					{
						sel_money_rate1 = filterNum(eval('add_bill.txt_rate1_' + i).value,session_money_round);
						sel_money_rate2 = filterNum(eval('add_bill.txt_rate2_' + i).value,session_money_round);
						if(money2_js != '' && eval('add_bill.hidden_rd_money_'+i).value == money2_js)
							add_bill.amount_2.value =commaSplit(row_amount_*sel_money_rate1/sel_money_rate2);
						if(eval('add_bill.hidden_rd_money_'+i).value == temp_act)
							add_bill.other_amount.value = commaSplit(row_amount_*sel_money_rate1/sel_money_rate2);
					}
					
				}
				if(temp_act == '<cfoutput>#session.ep.money#</cfoutput>')
					add_bill.other_amount.value = commaSplit(row_amount_);
				else if(temp_act == '' || temp_act == 0)
					add_bill.other_amount.value = '';
				else if(temp_act == -1 && add_bill.claim.value != '' && currency_ == '<cfoutput>#session.ep.money#</cfoutput>')
					add_bill.claim.value = commaSplit(filterNum(add_bill.other_amount.value));
				else if(temp_act == -1 && add_bill.debt.value != '' && currency_ == '<cfoutput>#session.ep.money#</cfoutput>')
					add_bill.debt.value = commaSplit(filterNum(add_bill.other_amount.value));
				
				if(temp_act == -1)
				{
					for(var j=1;j<=<cfoutput>#get_money_bskt.recordcount#</cfoutput>;j++)
					{
						if (eval('add_bill.hidden_rd_money_'+j).value == 'USD')
						{	
							money_rate1_ = filterNum(eval('add_bill.txt_rate1_' + j).value,session_money_round);
							money_rate2_ = filterNum(eval('add_bill.txt_rate2_' + j).value,session_money_round);
							if(money2_js != '' && eval('add_bill.hidden_rd_money_'+j).value == money2_js && add_bill.claim.value != '')
								add_bill.amount_2.value = commaSplit(filterNum(add_bill.claim.value)*money_rate1_/money_rate2_);
							else if(money2_js != '' && eval('add_bill.hidden_rd_money_'+j).value == money2_js && add_bill.debt.value != '')
								add_bill.amount_2.value = commaSplit(filterNum(add_bill.debt.value)*money_rate1_/money_rate2_);
						}
					}
				}
			}
			else
			{
				add_bill.other_amount.value =  '';
				if(money2_js != '') add_bill.amount_2.value ='';
			}
		}
		else
		{
			if(add_bill.claim[row_no-1].value != '')
				row_amount_ = filterNum(add_bill.claim[row_no-1].value);
			else if(add_bill.debt[row_no-1].value != '')
				row_amount_ = filterNum(add_bill.debt[row_no-1].value);
			else
				row_amount_ = '';
	
			if(temp_act == 1) //borc-alacak tutarları degistiginde
				temp_act = add_bill.other_currency[row_no-1].value;
			else if(temp_act == -1)
				currency_ = add_bill.other_currency[row_no-1].value;
	
			if(row_amount_ != undefined && row_amount_ != '')
			{
				for(var i=1;i<=<cfoutput>#get_money_bskt.recordcount#</cfoutput>;i++)
				{
					if(temp_act == -1)
					{
						if(eval('add_bill.hidden_rd_money_'+i).value == currency_)
						{
							rate1_ = filterNum(eval('add_bill.txt_rate1_' + i).value,session_money_round);
							rate2_ = filterNum(eval('add_bill.txt_rate2_' + i).value,session_money_round);
							if(add_bill.claim[row_no-1].value != '')
								add_bill.claim[row_no-1].value = commaSplit(filterNum(add_bill.other_amount[row_no-1].value)*rate2_/rate1_);
							else if(add_bill.debt[row_no-1].value != '')
								add_bill.debt[row_no-1].value = commaSplit(filterNum(add_bill.other_amount[row_no-1].value)*rate2_/rate1_);
						}
					}
					if((eval('add_bill.hidden_rd_money_'+i).value == temp_act || eval('add_bill.hidden_rd_money_'+i).value == money2_js) & temp_act != -1)
					{
						sel_money_rate1 = filterNum(eval('add_bill.txt_rate1_' + i).value,session_money_round);
						sel_money_rate2 = filterNum(eval('add_bill.txt_rate2_' + i).value,session_money_round);
						if(money2_js != '' && eval('add_bill.hidden_rd_money_'+i).value == money2_js)
							add_bill.amount_2[row_no-1].value =commaSplit(row_amount_*sel_money_rate1/sel_money_rate2);
						if(eval('add_bill.hidden_rd_money_'+i).value == temp_act)
							add_bill.other_amount[row_no-1].value = commaSplit(row_amount_*sel_money_rate1/sel_money_rate2);
					}
					
				}
				if(temp_act == '<cfoutput>#session.ep.money#</cfoutput>')
					add_bill.other_amount[row_no-1].value = commaSplit(row_amount_);
				else if(temp_act == '' || temp_act == 0)
					add_bill.other_amount[row_no-1].value = '';
				else if(temp_act == -1 && add_bill.claim[row_no-1].value != '' && currency_ == '<cfoutput>#session.ep.money#</cfoutput>')
					add_bill.claim[row_no-1].value = commaSplit(filterNum(add_bill.other_amount[row_no-1].value));
				else if(temp_act == -1 && add_bill.debt[row_no-1].value != '' && currency_ == '<cfoutput>#session.ep.money#</cfoutput>')
					add_bill.debt[row_no-1].value = commaSplit(filterNum(add_bill.other_amount[row_no-1].value));
				
				if(temp_act == -1)
				{
					for(var j=1;j<=<cfoutput>#get_money_bskt.recordcount#</cfoutput>;j++)
					{
						if (eval('add_bill.hidden_rd_money_'+j).value == 'USD')
						{	
							money_rate1_ = filterNum(eval('add_bill.txt_rate1_' + j).value,session_money_round);
							money_rate2_ = filterNum(eval('add_bill.txt_rate2_' + j).value,session_money_round);
							if(money2_js != '' && eval('add_bill.hidden_rd_money_'+j).value == money2_js && add_bill.claim[row_no-1].value != '')
								add_bill.amount_2[row_no-1].value = commaSplit(filterNum(add_bill.claim[row_no-1].value)*money_rate1_/money_rate2_);
							else if(money2_js != '' && eval('add_bill.hidden_rd_money_'+j).value == money2_js && add_bill.debt[row_no-1].value != '')
								add_bill.amount_2[row_no-1].value = commaSplit(filterNum(add_bill.debt[row_no-1].value)*money_rate1_/money_rate2_);
						}
					}
				}
			}
			else
			{
				add_bill.other_amount[row_no-1].value =  '';
				if(money2_js != '') add_bill.amount_2[row_no-1].value ='';
			}
		}
	}
	
	function f_kur_hesapla_multi()
	{
		if(rowCount==1)//tek satırlı işlemlerde
		{	
			if(add_bill.claim.value != '')
				row_amount_ = filterNum(add_bill.claim.value);
			else if(add_bill.debt.value != '')
				row_amount_ = filterNum(add_bill.claim.value);
			else
				row_amount_ ='';
			if(row_amount_ != undefined && row_amount_ != '')
			{
				for(var i=1;i<=<cfoutput>#get_money_bskt.recordcount#</cfoutput>;i++)
				{
					if(eval('add_bill.hidden_rd_money_'+i).value == add_bill.other_currency.value || eval('add_bill.hidden_rd_money_'+i).value == money2_js)
					{
						sel_money_rate1 = filterNum(eval('add_bill.txt_rate1_' + i).value,session_money_round);
						sel_money_rate2 = filterNum(eval('add_bill.txt_rate2_' + i).value,session_money_round);
						if(money2_js != '' && eval('add_bill.hidden_rd_money_'+i).value == money2_js)
							add_bill.amount_2.value = commaSplit(row_amount_*sel_money_rate1/sel_money_rate2);
						<cfif not isdefined("from_rate_valuation")>
						if(eval('add_bill.hidden_rd_money_'+i).value == add_bill.other_currency.value)
							add_bill.other_amount.value = commaSplit(row_amount_*sel_money_rate1/sel_money_rate2);
						</cfif>
					}
				}
			}
		}
		else
		{
			for (var jj=0; jj < rowCount; jj++)
			{
				if(add_bill.claim[jj].value != '')
					row_amount_ = filterNum(add_bill.claim[jj].value);
				else if(add_bill.debt[jj].value != '')
					row_amount_ = filterNum(add_bill.debt[jj].value);
				else
					row_amount_ ='';
				if(row_amount_ != undefined && row_amount_ != '')
				{
					for(var i=1;i<=<cfoutput>#get_money_bskt.recordcount#</cfoutput>;i++)
					{
						if(eval('add_bill.hidden_rd_money_'+i).value == add_bill.other_currency[jj].value || eval('add_bill.hidden_rd_money_'+i).value == money2_js)
						{
							sel_money_rate1 = filterNum(eval('add_bill.txt_rate1_' + i).value,session_money_round);
							sel_money_rate2 = filterNum(eval('add_bill.txt_rate2_' + i).value,session_money_round);
							if(money2_js != '' && eval('add_bill.hidden_rd_money_'+i).value == money2_js)
								add_bill.amount_2[jj].value =commaSplit(row_amount_*sel_money_rate1/sel_money_rate2);
							<cfif not isdefined("from_rate_valuation")>
							if(eval('add_bill.hidden_rd_money_'+i).value == add_bill.other_currency[jj].value)
								add_bill.other_amount[jj].value = commaSplit(row_amount_*sel_money_rate1/sel_money_rate2);
							</cfif>
						}
					}
				}
			}
		}
	}
	<cfif isdefined("from_rate_valuation")> //kur degerleme sayfasından acılıyorsa
		f_kur_hesapla_multi();
	</cfif>
	function select_acc_department(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_bill.acc_department_id' + no +'&field_dep_branch_name=add_bill.acc_department_name' + no,'list');
	}
	function select_acc_project(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_bill.acc_project_id' + no +'&project_head=add_bill.acc_project_name' + no);
	}
	function auto_project(no)
	{
		AutoComplete_Create('acc_project_name'+no,'PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','acc_project_id'+no,'','3','250');
	}
</script>

