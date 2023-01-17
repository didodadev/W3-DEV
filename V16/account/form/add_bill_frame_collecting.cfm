<cfif isDefined("session.ep") and len(session.ep.our_company_info.is_ifrs eq 1)>
	<cfset is_ifrs = 1>
<cfelse>
	<cfset is_ifrs = 0>
</cfif>
<cfif  isdefined("attributes.card_id") and len(attributes.card_id) and isdefined("GET_ACCOUNT_CARD") and GET_ACCOUNT_CARD.recordcount>
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
<div class="row">
	<div class="col col-2 form-group">
		<select name="show_type" id="show_type">
			<option value="1" <cfif is_ifrs eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"></option>
			<option value="2" <cfif is_ifrs eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id="58308.ufrs"></option>
			<option value="3" <cfif is_ifrs eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"> + <cf_get_lang dictionary_id="58308.ufrs"></option>
		</select>
	</div>
</div>
<div class="ListContent">
    <cf_grid_list sort="0" id="delete_tr">
        <thead>
            <tr> 
                <th><a href="javascript://" onClick="addRow();"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57707.Satır Ekle'>" title="<cf_get_lang dictionary_id='57707.Satır Ekle'>"></i></a></th>
                <th><cf_get_lang dictionary_id='57487.No'></th>
                <th  style="min-width:150px"><cf_get_lang dictionary_id='47299.Hesap Kodu'></th>
                <th id="ifrs" <cfif session.ep.our_company_info.is_ifrs neq 1>style="display:none;"</cfif>><cf_get_lang dictionary_id='58130.UFRS Kod'></th>
                <th id="private" <cfif session.ep.our_company_info.is_ifrs neq 1 or (not isdefined("get_account_rows_A") or get_account_card.is_account_code2 neq 1)>style="display:none;"</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                <th>&nbsp;</th>
                <th><cf_get_lang dictionary_id='57631.Ad'></th>
                <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                <cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0><th><cf_get_lang dictionary_id='57572.Departman'></th></cfif>
                <cfif xml_acc_project_info><th><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
                <th><cf_get_lang_main dictionary_id='57588.Alacak'></th>
            <cfif len(session.ep.money2)>
                <th><cf_get_lang dictionary_id='47385.2.Döviz'></th>
            </cfif>  
                <th id="other_money_1" <cfif (not isdefined("get_account_rows_A") or get_account_card.is_other_currency neq 1) and (not isdefined("get_comp_info.is_other_money") or get_comp_info.is_other_money neq 1)><cfset display_none=1>style="display:none;"</cfif>><cf_get_lang dictionary_id='58121.Islem Dovizi'></th>            
                <th id="other_money_2" <cfif (not isdefined("get_account_rows_A") or get_account_card.is_other_currency neq 1) and (not isdefined("get_comp_info.is_other_money") or get_comp_info.is_other_money neq 1)>style="display:none;"</cfif>><cf_get_lang dictionary_id='58864.Para Br'></th>
            </tr>
        </thead>
        <tbody id="table_list">
            <cfif isdefined("get_account_rows_A")>
                <cfset dep_id_list=''>
                <cfoutput query="get_account_rows_A">
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
                <cfoutput query="get_account_rows_A">
                    <cfset degisken_money = '#get_account_rows_A.OTHER_CURRENCY#'>
                    <tr id="tr_id#currentrow#">
                        <td><a href="javascript://" title="<cf_get_lang dictionary_id ='57463.Sil'>" class="btnDelete"><i class="fa fa-minus"></i></a></td>
                        <td id="td_id">#currentrow#</td>
                        <td>
							<div class="form-group">
								<div class="input-group">
									<input type="text" name="acc_code" id="acc_code#currentrow#" value="#ACCOUNT_ID#" onFocus="auto_acc_code(#currentrow#);" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis"  onClick="pencere_ac(#currentrow#);"></span> 
									<span class="input-group-addon btnPointer icon-chart"  onClick="ac_hesap_detay(#currentrow#);"></span>
								</div>
							</div>
						</td>
                        <td id="ifrs" <cfif session.ep.our_company_info.is_ifrs neq 1>style="display:none;"</cfif>>
							<div class="form-group" style="width:150px;">
									<input type="text" name="ifrs_code" id="ifrs_code" value="#IFRS_CODE#">
							</div>
						</td>
                        <td id="private" <cfif session.ep.our_company_info.is_ifrs neq 1 or get_account_card.IS_ACCOUNT_CODE2 neq 1>style="display:none;"</cfif>>
							<div class="form-group" style="width:150px;">
									<input type="text" name="account_code2" id="account_code2" value="#ACCOUNT_CODE2#">
							</div>
						</td>
                        <td nowrap>
	
                        </td>
                        <td>
							<div class="form-group" style="width:150px;">
									<input type="text" name="acc_name" id="acc_name#currentrow#" value="#ACCOUNT_NAME#">
							</div>
						</td>
                        <td>
							<div class="form-group" style="width:150px;">
									<input type="text" name="detail_#currentrow#" id="detail_#currentrow#" value="#DETAIL#" onchange="hesapla();">
							</div>
						</td>
                        <cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
                            <td>
								<div class="form-group" style="width:150px;">
										<div class="input-group">
											<input type="hidden" name="acc_department_id#currentrow#" id="acc_department_id#currentrow#" value="#ACC_DEPARTMENT_ID#">
											<input type="text" name="acc_department_name#currentrow#" id="acc_department_name#currentrow#"  value="<cfif len(ACC_DEPARTMENT_ID)>#get_dep_detail.BRANCH_NAME[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]# - #get_dep_detail.DEPARTMENT_HEAD[listfind(dep_id_list,ACC_DEPARTMENT_ID,',')]#</cfif>" style="width:110px;">
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_departments&field_id=add_bill.acc_department_id#currentrow#' +'&field_dep_branch_name=add_bill.acc_department_name#currentrow#','list')" ></span>
										</div>
									</div>
							</td>
                        </cfif>
                        <cfif xml_acc_project_info>
                            <td>
								<div class="form-group" style="width:150px;">
										<div class="input-group">
											<input type="hidden" name="acc_project_id#currentrow#" id="acc_project_id#currentrow#" value="#acc_project_id#">
											<input type="text" name="acc_project_name#currentrow#" id="acc_project_name#currentrow#" value="<cfif len(acc_project_id)>#get_project_name(acc_project_id)#</cfif>" style="width:110px;" onFocus="AutoComplete_Create('acc_project_name#currentrow#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','acc_project_id#currentrow#','list_works','3','250');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_bill.acc_project_id#currentrow#' +'&project_head=add_bill.acc_project_name#currentrow#')" ></span>
										</div>
								</div>
							</td>
                        </cfif> 
                        <td>
							<div class="form-group" style="width:150px;">
									<input type="text" name="claim" id="claim" value="#TLFormat(AMOUNT)#" onchange="hesapla();" onBlur="f_kur_hesapla(1,'#currentrow#');hesapla();" onkeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:80px;">
								</div>
						</td>
					    <cfif len(session.ep.money2)>
                            <td>
								<div class="form-group" style="width:150px;">
										<input type="text" name="amount_2" id="amount_2" value="#TLFormat(AMOUNT_2)#" onchange="hesapla();" onBlur="hesapla();" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
									</div>
							</td>
                        </cfif>
                        <td id="other_money_1" <cfif get_account_card.is_other_currency neq 1>style="display:none;"</cfif>>
							<div class="form-group" style="width:150px;">
									<input type="text" name="other_amount" id="other_amount" value="#TLFormat(OTHER_AMOUNT)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
								</div>
						</td>
                        <td id="other_money_2" <cfif get_account_card.is_other_currency neq 1>style="display:none;"</cfif>>
							<div class="form-group" style="width:150px;">
									<select name="other_currency" id="other_currency" onChange="f_kur_hesapla(this.value,'#currentrow#');hesapla();">
										<cfloop query="get_money_doviz">
											<option value="#MONEY#"<cfif MONEY is degisken_money> selected</cfif>>#MONEY#</option>
										</cfloop>
									</select>
							</div>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <cfoutput> 
                    <cfloop from="1" to="10" index="i">
                        <tr id="tr_id#i#">
                            <td><a href="javascript://" title="<cf_get_lang dictionary_id ='57463.Sil'>" class="btnDelete"><i class="fa fa-minus"></i></a></td>
                            <td>#i#</td>
							<td>
								<div class="form-group">
										<div class="input-group">	
											<input type="text" name="acc_code" id="acc_code#i#" onFocus="auto_acc_code(#i#);">
											<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac(#i#);" alt="<cf_get_lang dictionary_id='57734.Seçiniz'>" align="absmiddle" border="0"></span>
												<span onClick="ac_hesap_detay(#i#);" class="input-group-addon btnPointer icon-chart"></span>
											</div>	
									</div>
								</div>		
							</td>
                            <td id="ifrs" <cfif session.ep.our_company_info.is_ifrs neq 1>style="display:none;"</cfif>>
								<div class="form-group" style="width:150px;">
										<input type="text" name="ifrs_code" id="ifrs_code" value="">
								</div>
							</td>
                            <td id="private" style="display:none;">
								<div class="form-group" style="width:150px;">
										<input type="text" name="account_code2" id="account_code2" value="">
									</div>
							</td>
                            <td nowrap></td>
                            <td>
								<div class="form-group" style="width:150px;">
										<input type="text" name="acc_name" id="acc_name#i#" value="">
									</div>
							</td>
                            <td>
								<div class="form-group" style="width:150px;">
										<input type="text" name="detail_#i#" id="detail_#i#" value=""  maxlength="100" onchange="hesapla();">
									</div>
							</td>
                            <cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
                                <td>
									<div class="form-group" style="width:150px;">
											<div class="input-group">
												<input type="hidden" name="acc_department_id#i#" id="acc_department_id#i#" value="">
												<input type="text" name="acc_department_name#i#" id="acc_department_name#i#"  value="">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_departments&field_id=add_bill.acc_department_id#i#' +'&field_dep_branch_name=add_bill.acc_department_name#i#','list')" ></span>
											</div>
										</div>
								</td>
                            </cfif>
                            <cfif xml_acc_project_info>
                                <td>
									<div class="form-group" style="width:150px;">
											<div class="input-group">
												<input type="hidden" name="acc_project_id#i#" id="acc_project_id#i#" value="">
												<input type="text" name="acc_project_name#i#" id="acc_project_name#i#"  value="" onFocus="AutoComplete_Create('acc_project_name#i#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','acc_project_id#i#','list_works','3','250');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis"  onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=add_bill.acc_project_id#i#' +'&project_head=add_bill.acc_project_name#i#')" ></span>
											</div>
									</div>
								</td>
                            </cfif>
                            <td>
								<div class="form-group" style="width:150px;">
										<input type="text" name="claim" id="claim" value="" class="moneybox" onchange="f_kur_hesapla(1,'#i#');hesapla();" onBlur="f_kur_hesapla(1,'#i#');hesapla();" onkeyup="return(FormatCurrency(this,event));">
									</div>
							</td>
							<cfif len(session.ep.money2)>
                                <td>
									<div class="form-group">
											<input type="text" name="amount_2" id="amount_2" value="" onchange="hesapla();" onBlur="hesapla();" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
										</div>
								</td>
                            </cfif>	
                            <td id="other_money_1" <cfif not isdefined("get_comp_info.is_other_money") or get_comp_info.is_other_money neq 1>style="display:none;"</cfif>>
								<div class="form-group" style="width:150px;">
										<input type="text" name="other_amount" id="other_amount" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
									</div>
							</td>
                            <td id="other_money_2" <cfif not isdefined("get_comp_info.is_other_money") or get_comp_info.is_other_money neq 1>style="display:none;"</cfif>>
								<div class="form-group" style="width:80px;">
										<select name="other_currency" id="other_currency" onChange="f_kur_hesapla(this.value,'#i#');hesapla();">
										<cfloop query="get_money_doviz">
											<option value="#MONEY#" <cfif money eq session.ep.money>selected</cfif>>#MONEY#</option>
										</cfloop>
										</select>
								</div>
                            </td>
                        </tr>
                    </cfloop>
                </cfoutput>
            </cfif>
            <input type="hidden" name="claim_total" id="claim_total" value="0">
            <input type="hidden" name="rowCount" id="rowCount" value="<cfif isdefined("GET_ACCOUNT_ROWS_A.recordcount")><cfoutput>#GET_ACCOUNT_ROWS_A.recordcount#</cfoutput><cfelse>10</cfif>">
        </tbody>
    </cf_grid_list>
</div>

<script type="text/javascript">
	rowCount = <cfif isdefined("GET_ACCOUNT_ROWS_A.recordcount")><cfoutput>#get_account_rows_A.recordcount#</cfoutput><cfelse>rowCount = 10;</cfif>;
	var session_money_round='<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>';
	var money2_js = <cfoutput>'#session.ep.money2#'</cfoutput>;
	function auto_acc_code(no)
	{	
		AutoComplete_Create('acc_code'+no,'ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','CODE_NAME','acc_name'+no,'','3','250');
	}
	function hesapla()
	{
		var t_claim = 0;
		var t_amount_2 = 0;
		for (var j=0; j < rowCount; j++)
		{
			if(rowCount==1)
			{
				if(add_bill.claim.value.length)
					t_claim += parseFloat(filterNum(add_bill.claim.value));
				if(add_bill.amount_2 != undefined && add_bill.amount_2.value.length)
					t_amount_2 += parseFloat(filterNum(add_bill.amount_2.value));
			}
			else
			{
				if (add_bill.claim[j].value.length)
					t_claim += parseFloat(filterNum(add_bill.claim[j].value));
				if(add_bill.amount_2 != undefined && add_bill.amount_2[j] != undefined && add_bill.amount_2[j].value.length)
					t_amount_2 += parseFloat(filterNum(add_bill.amount_2[j].value));
			}
		}
		add_bill.cash_debt.value = commaSplit(t_claim);
		if(add_bill.amount_2 != undefined)
		{
			add_bill.cash_amount_2.value = commaSplit(t_amount_2);
			x = add_bill.other_cash_currency.selectedIndex;
			if(add_bill.other_cash_currency.value == money2_js)
			add_bill.other_cash_amount.value = commaSplit(t_amount_2);
		}
		f_total_hesapla();
	}
	
	function kontrol2()
	{
		document.getElementById('is_other_currency').disabled = false;
		if(document.getElementById('document_type').value != '' && document.getElementById('paper_no').value == '')
		{
			alert("<cf_get_lang dictionary_id='58556.Belge No Giriniz'>!");
			return false;
		}
		
		if((document.getElementById('document_type').value == -1 || document.getElementById('document_type').value == -3) && document.getElementById('due_date').value == '')
		{
			alert("<cf_get_lang dictionary_id='59046.Vade Tarihi Giriniz'>!");
			return false;
		}
		if(add_bill.bill_detail.value.length > 150)
		{
			alert("<cf_get_lang dictionary_id='47384.Açıklama Uzunluğunu Aştınız'>");
			return false;
		}
		
		if (document.getElementById("cash_acc_code").value == '')
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik veri'>:<cf_get_lang dictionary_id='47301.Kasa hesap adı'>!");
			return false;
		}
		
		if (!chk_period(add_bill.process_date,'İşlem')) return false;
		var toplam_all_row=0;
		if(rowCount ==1)
		{
			if ((!add_bill.acc_code.value.length) && (add_bill.claim.value.length))
			{
				alert((1) + "<cf_get_lang dictionary_id='47421.satırın Muhasebe Kodu Olmamasına Rağmen Bakiyesi Var'>!");
				return false;
			}
			hesapla();			
			add_bill.claim.value = filterNum(add_bill.claim.value);
			add_bill.other_amount.value = filterNum(add_bill.other_amount.value);
			if((add_bill.amount_2 != undefined))//Sistem Para Birimi 2 tanimli ise
				add_bill.amount_2.value = filterNum(add_bill.amount_2.value);		
			toplam_all_row=add_bill.claim.value;
			if (add_bill.claim.value == '') add_bill.claim.value = 0;
			if (add_bill.other_amount.value == '') add_bill.other_amount.value = 0;
			if (add_bill.ifrs_code.value == '') add_bill.ifrs_code.value = 0;
			if((add_bill.account_code2 != undefined))
			if(add_bill.account_code2.value == '') add_bill.account_code2.value = 0;
			if((add_bill.amount_2 != undefined))
			if(add_bill.amount_2.value == '') add_bill.amount_2.value = 0;	
		}
		else
		{
			/*muhasebe kodu olmayanlar sıfırlanır*/
			for (var j=0; j < rowCount; j++)
				if ((!add_bill.acc_code[j].value.length) && (add_bill.claim[j].value.length))
				{
					alert((j+1) + "<cf_get_lang dictionary_id='47421.satırın Muhasebe Kodu Olmamasına Rağmen Bakiyesi Var'>!");
					return false;
				}
			hesapla();			
			for (var j=0; j < rowCount; j++)
				{
				add_bill.claim[j].value = filterNum(add_bill.claim[j].value);
				add_bill.other_amount[j].value = filterNum(add_bill.other_amount[j].value);
				if((add_bill.amount_2 != undefined && add_bill.amount_2[j] != undefined))//Sistem Para Birimi 2 tanimli ise
					add_bill.amount_2[j].value = filterNum(add_bill.amount_2[j].value);			
				
				if (add_bill.claim[j].value == '') add_bill.claim[j].value = 0;
				if (add_bill.ifrs_code[j].value == '') add_bill.ifrs_code[j].value = 0;
				if((add_bill.account_code2 != undefined && add_bill.account_code2[j] != undefined))
					if(add_bill.account_code2[j].value == '') add_bill.account_code2[j].value = 0;
				if (add_bill.other_amount[j].value == '') add_bill.other_amount[j].value = 0;
				if((add_bill.amount_2 != undefined && add_bill.amount_2[j] != undefined))
					if(add_bill.amount_2[j].value == '') add_bill.amount_2[j].value = 0;			
				toplam_all_row+=add_bill.claim[j].value;
				}
			}
		add_bill.claim_total.value=toplam_all_row;
		if(add_bill.claim_total.value==0 && add_bill.claim_total.value ==0)
		{
			alert("<cf_get_lang dictionary_id='59053.Bakiye Girmelisiniz'>!");
			return false;
		}	
		add_bill.cash_debt.value = filterNum(add_bill.cash_debt.value);
		if((add_bill.amount_2 != undefined))
			add_bill.cash_amount_2.value = filterNum(add_bill.cash_amount_2.value);
		add_bill.other_cash_amount.value = filterNum(add_bill.other_cash_amount.value);
		for(var i=1;i<=add_bill.kur_say.value;i++)
		{
			eval('add_bill.txt_rate1_' + i).value = filterNum(eval('add_bill.txt_rate1_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('add_bill.txt_rate2_' + i).value = filterNum(eval('add_bill.txt_rate2_' + i).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		if(document.getElementById("document_type").value == '' && document.getElementById("payment_type").value != '')
		{
			if (!confirm("<cf_get_lang dictionary_id='59050.Belge tipi seçmediniz. Kaydetmek istediğinizden emin misiniz'>?"))
				return false;
		}
		if(document.getElementById("payment_type").value == '' && document.getElementById("document_type").value != '')
		{
			if (!confirm("<cf_get_lang dictionary_id='59051.Ödeme şekli seçmediniz. Kaydetmek istediğinizden emin misiniz'>?"))
				return false;
		}
		if(document.add_bill.card_id.value){
			var parameter = document.add_bill.card_id.value + '*' + document.getElementById("paper_no").value + '*' + '11';
		}
		else
		{
			var parameter = document.getElementById("paper_no").value + '*' + '11';
		}
		var get_paper_no = wrk_safe_query('acc_get_paper_no','dsn2',0,parameter);
		if( get_paper_no.recordcount)
		{
			alert("<cf_get_lang dictionary_id='59366.Girdiğiniz Belge Numarası Kullanılmaktadır'> !");
			return false;
		}
		
		//if (!chk_process_cat('add_bill')) return false;
		return true;
	}		
	
	function pencere_ac(row)
	{
		row--;
		if(rowCount==1){
			
			if (add_bill.acc_code.value.length != 0)
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_bill.acc_code&field_ufrs_no=add_bill.ifrs_code&field_name=add_bill.acc_name&account_code=' + add_bill.acc_code.value, 'list');
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_bill.acc_code&field_ufrs_no=add_bill.ifrs_code&field_name=add_bill.acc_name', 'list');
		}else{
			if (add_bill.acc_code[row].value.length != 0)
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_bill.acc_code[' + row + ']&field_ufrs_no=add_bill.ifrs_code[' + row + ']&field_name=add_bill.acc_name[' + row + ']&account_code=' + add_bill.acc_code[row].value, 'list');
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_bill.acc_code[' + row + ']&field_ufrs_no=add_bill.ifrs_code[' + row + ']&field_name=add_bill.acc_name[' + row + ']', 'list');
		}
	}
	
	function addRow()
	{
		rowCount++;
		add_bill.rowCount.value = rowCount;
		var newRow;
		var newCell;
		
		newRow = document.getElementById("table_list").insertRow(document.getElementById("table_list").rows.length);
		newRow.setAttribute("id","tr_id" + rowCount);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a href="javascript://" title="<cf_get_lang dictionary_id ='57463.Sil'>" class="btnDelete"><i class="fa fa-minus"></i></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = rowCount;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML =  '<div class="form-group">	<div class="input-group"><input type="text" name="acc_code" id="acc_code' + rowCount + '" onFocus="auto_acc_code(' + rowCount + ');" autocomplete="off"><span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac(' + rowCount + ');"></span><span class="input-group-addon btnPointer icon-chart" onClick="ac_hesap_detay(' + rowCount + ');"></span></div></div> ';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.id = 'ifrs';
		if(document.add_bill.is_ifrs != undefined && document.add_bill.is_ifrs.checked) 
		newCell.style.display = ''; 
		else 
		newCell.style.display = 'none';
		newCell.innerHTML = '<div class="form-group" style="width:150px;"><input type="text" name="ifrs_code" value=""></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.id = 'private';
		if(document.add_bill.is_account_code2 != undefined && document.getElementById('is_account_code2').checked) newCell.style.display = ''; else newCell.style.display = 'none';
		newCell.innerHTML = '<input type="text" name="account_code2" value="" style="width:65px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group" style="width:150px;"><input type="text" name="acc_name" id="acc_name' + rowCount + '"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group" style="width:150px;"><input type="text" name="detail_' + rowCount + '" onchange="hesapla();"></div>';
		
		<cfif xml_acc_department_info and session.ep.isBranchAuthorization eq 0>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group" style="width:150px;"><div class="input-group"><input type="hidden" name="acc_department_id' + rowCount + '"><input type="text" name="acc_department_name' + rowCount + '"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="select_acc_department('+ rowCount +');"></span></div></div>';
		</cfif>	
		<cfif xml_acc_project_info>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group" style="width:150px;"><div class="input-group"><input type="hidden" name="acc_project_id' + rowCount + '" id="acc_project_id' + rowCount + '"><input type="text" name="acc_project_name' + rowCount + '" id="acc_project_name' + rowCount + '" onFocus="auto_project('+ rowCount +');" autocomplete="off"><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="select_acc_project('+ rowCount +');"></span></div></div>';
		</cfif>	
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group" style="width:150px;"><input type="text" name="claim" value="" onchange="hesapla();" onBlur="f_kur_hesapla(1,' + rowCount + ');hesapla();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
		//2.döviz
		if(money2_js != '')
		{
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group" style="width:150px;"><input type="text" name="amount_2" value="" onchange="hesapla();" onBlur="hesapla();" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
		}
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.id = 'other_money_1';
		<cfif isdefined("display_none")>newCell.style.display = 'none'; <cfelse> newCell.style.display = '';</cfif>
		newCell.innerHTML = '<div class="form-group" style="width:150px;"><input type="text" name="other_amount" id="other_amount" value="" onkeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.id = 'other_money_2';
		<cfif isdefined("display_none")> newCell.style.display = 'none';<cfelse> newCell.style.display = ''; </cfif>
		newCell.innerHTML = '<div class="form-group" style="width:80px;"><select name="other_currency" id="other_currency" onChange="f_kur_hesapla(this.value,' + rowCount + ');hesapla();"><cfoutput query="get_money_doviz"><option value="#MONEY#"  <cfif money eq session.ep.money>selected</cfif>>#MONEY#</option></cfoutput></select></div>';
	}
	$('#delete_tr').on('click','.btnDelete',function () {
		yer = $('#delete_tr tr').index($(this).closest('tr'));
		  if(yer==1 && rowCount==1)
		{
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
			add_bill.claim[yer-1].value = '';
			add_bill.acc_code[yer-1].value = '';
			add_bill.acc_name[yer-1].value = '';
			add_bill.other_amount[yer-1].value = '';
			add_bill.ifrs_code[yer-1].value = '';
			add_bill.account_code2[yer-1].value = '';
			if(add_bill.amount_2 != undefined && (add_bill.amount_2[yer-1] != undefined))
				add_bill.amount_2[yer-1].value = '';		
			
			temp_element = eval('add_bill.detail_'+yer);
		}
		temp_element.value = '';
		hesapla();
		$("#tr_id"+yer).css("display", "none");
	});
	
	hesapla();
	function ac_hesap_detay(code_row)
	{
		try {
			code_row --;
			if(rowCount==1) code_ = add_bill.acc_code.value;	
			else code_ = add_bill.acc_code[code_row].value;
			if(code_.length)
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=account.popup_list_account_plan_rows&code=' + code_,'wide');	
			}
		catch(e){}	
	}
	
	function other_money_action()
	{
		gizle_goster(main_other_money);
		gizle_goster(text_other_money);
		for (var jmk=0; jmk < rowCount+1; jmk++)
		{
			gizle_goster(other_money_1[jmk]);
			gizle_goster(other_money_2[jmk]);
		}
		/*if(add_bill.amount_2 != undefined)
			add_bill.other_cash_amount.value = add_bill.cash_amount_2.value;*/
	}
	function ifrs_action()
	{
		for (var rs=0; rs < rowCount+1; rs++)
		{
			gizle_goster(ifrs[rs]);
		}
	}
	function private_code_action()
	{
		for (var prv=0; prv < rowCount+1; prv++)
		{
			gizle_goster(private[prv]);
		}
	}
	
	function f_kur_hesapla(temp_act,row_no)
	{
		if(rowCount==1)//tek satırlı işlemlerde
		{	
			if(temp_act == 1 ) //borc-alacak tutarları degistiginde
				temp_act=add_bill.other_currency.value;
			for(var i=1;i<=<cfoutput>#get_money_bskt.recordcount#</cfoutput>;i++)
			{
				if(eval('add_bill.hidden_rd_money_'+i).value == temp_act || eval('add_bill.hidden_rd_money_'+i).value == money2_js)
				{
					rate1_eleman = filterNum(eval('add_bill.txt_rate1_' + i).value,session_money_round);
					rate2_eleman = filterNum(eval('add_bill.txt_rate2_' + i).value,session_money_round);
					if(eval('add_bill.hidden_rd_money_'+i).value == money2_js)
						add_bill.amount_2.value = commaSplit(filterNum(add_bill.claim.value)*rate1_eleman/rate2_eleman);
					if(eval('add_bill.hidden_rd_money_'+i).value == temp_act)
						add_bill.other_amount.value = commaSplit(filterNum(add_bill.claim.value)*rate1_eleman/rate2_eleman);
				}
			}
			if(temp_act == '<cfoutput>#session.ep.money#</cfoutput>')
				add_bill.other_amount.value = add_bill.claim.value;
			else if(temp_act == '' || temp_act == 0)
				add_bill.other_amount.value = '';
		}
		else
		{
			if(temp_act == 1) //borc-alacak tutarları degistiginde
				temp_act=add_bill.other_currency[row_no-1].value;
			for(var i=1;i<=<cfoutput>#get_money_bskt.recordcount#</cfoutput>;i++)
			{
				if(eval('add_bill.hidden_rd_money_'+i).value == temp_act || eval('add_bill.hidden_rd_money_'+i).value == money2_js)
				{
					rate1_eleman = filterNum(eval('add_bill.txt_rate1_' + i).value,session_money_round);
					rate2_eleman = filterNum(eval('add_bill.txt_rate2_' + i).value,session_money_round);
					if(eval('add_bill.hidden_rd_money_'+i).value == money2_js)
						add_bill.amount_2[row_no-1].value = commaSplit(filterNum(add_bill.claim[row_no-1].value)*rate1_eleman/rate2_eleman);
					if(eval('add_bill.hidden_rd_money_'+i).value == temp_act)
						add_bill.other_amount[row_no-1].value = commaSplit(filterNum(add_bill.claim[row_no-1].value)*rate1_eleman/rate2_eleman);
				}
			}
			if(temp_act == '<cfoutput>#session.ep.money#</cfoutput>')
				add_bill.other_amount[row_no-1].value = add_bill.claim[row_no-1].value;
			else if(temp_act == '' || temp_act == 0)
				add_bill.other_amount[row_no-1].value = '';
		}
	}
	function f_kur_hesapla_multi()
	{
		if(rowCount==1)//tek satırlı işlemlerde
		{	
			if(add_bill.claim.value != '')
			{
				for(var i=1;i<=<cfoutput>#get_money_bskt.recordcount#</cfoutput>;i++)
				{
					if(eval('add_bill.hidden_rd_money_'+i).value == add_bill.other_currency.value || eval('add_bill.hidden_rd_money_'+i).value == money2_js)
					{
						rate1_eleman = filterNum(eval('add_bill.txt_rate1_' + i).value,session_money_round);
						rate2_eleman = filterNum(eval('add_bill.txt_rate2_' + i).value,session_money_round);
						if(eval('add_bill.hidden_rd_money_'+i).value == money2_js)
							add_bill.amount_2.value = commaSplit(filterNum(add_bill.claim.value)*rate1_eleman/rate2_eleman);
						if(eval('add_bill.hidden_rd_money_'+i).value == add_bill.other_currency.value)
							add_bill.other_amount.value = commaSplit(filterNum(add_bill.claim.value)*rate1_eleman/rate2_eleman);
					}
				}
			}
		}
		else
		{
			for (var j=0; j < rowCount; j++)
			{
				if(add_bill.claim[j].value != '')
				{
					for(var i=1;i<=<cfoutput>#get_money_bskt.recordcount#</cfoutput>;i++)
					{
						if(eval('add_bill.hidden_rd_money_'+i).value == add_bill.other_currency[j].value || eval('add_bill.hidden_rd_money_'+i).value == money2_js)
						{
							rate1_eleman = filterNum(eval('add_bill.txt_rate1_' + i).value,session_money_round);
							rate2_eleman = filterNum(eval('add_bill.txt_rate2_' + i).value,session_money_round);
							if(eval('add_bill.hidden_rd_money_'+i).value == money2_js)
								add_bill.amount_2[j].value = commaSplit(filterNum(add_bill.claim[j].value)*rate1_eleman/rate2_eleman);
							if(eval('add_bill.hidden_rd_money_'+i).value == add_bill.other_currency[j].value)
								add_bill.other_amount[j].value = commaSplit(filterNum(add_bill.claim[j].value)*rate1_eleman/rate2_eleman);
						}
					}
				}
			}
		}
	}
	
	function f_total_hesapla(temp_act)
	{
		if(temp_act == undefined || temp_act == '')
			temp_act = add_bill.other_cash_currency.value;
		if(temp_act == '<cfoutput>#session.ep.money#</cfoutput>')
			add_bill.other_cash_amount.value =add_bill.cash_debt.value;
		else if(temp_act == '')
			add_bill.other_cash_amount.value ='';
		else
		{
			for(var i=1;i<=<cfoutput>#get_money_bskt.recordcount#</cfoutput>;i++)
			{
				if(eval('add_bill.hidden_rd_money_'+i).value == temp_act)
				{
					rate1_eleman = filterNum(eval('add_bill.txt_rate1_' + i).value,session_money_round);
					rate2_eleman = filterNum(eval('add_bill.txt_rate2_' + i).value,session_money_round);
					add_bill.other_cash_amount.value = commaSplit(filterNum(add_bill.cash_debt.value)*rate1_eleman/rate2_eleman);
				}
			}
		}
	}
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
