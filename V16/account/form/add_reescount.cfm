<!--- Reeskont Islemleri --->
<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.due_date" default="31/12/#session.ep.period_year#">

<cfif isdefined("attributes.form_submitted")>
	<cfif len(attributes.due_date)>
		<cf_date tarih="attributes.due_date">
	</cfif>
	<cfif isDefined("attributes.is_cheque")>
		<cfquery name="get_cheque_voucher" datasource="#dsn2#">
			SELECT 
				CHEQUE_ID,
				CHEQUE_NO DOC_NO,
				CHEQUE_DUEDATE DUE_DATE,
				CHEQUE_VALUE TOTAL_VALUE,
				CURRENCY_ID,
				CHEQUE_STATUS_ID STATUS_ID
			FROM 
				CHEQUE
			WHERE
				CHEQUE_DUEDATE > '2012-12-31 00:00:00.0'
				AND CHEQUE_ID NOT IN (SELECT CHEQUE_ID FROM REESCOUNT_ROWS WHERE CHEQUE_ID IS NOT NULL)
				<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
					AND CURRENCY_ID = '#attributes.money_type#'
				</cfif>
				<cfif isdefined("attributes.status") and len(attributes.status)>
					AND CHEQUE_STATUS_ID IN (#attributes.status#)
				</cfif>
			ORDER BY
				CHEQUE_DUEDATE
		</cfquery>
	<cfelse>
		<cfquery name="get_cheque_voucher" datasource="#dsn2#">
			SELECT 
				VOUCHER_ID,
				VOUCHER_NO DOC_NO,
				VOUCHER_DUEDATE DUE_DATE,
				VOUCHER_VALUE TOTAL_VALUE,
				CURRENCY_ID,
				VOUCHER_STATUS_ID STATUS_ID
			FROM 
				VOUCHER
			WHERE
				VOUCHER_DUEDATE > '2012-12-31 00:00:00.0'
				AND VOUCHER_ID NOT IN (SELECT VOUCHER_ID FROM REESCOUNT_ROWS WHERE VOUCHER_ID IS NOT NULL)
				<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
					AND CURRENCY_ID = '#attributes.money_type#'
				</cfif>
				<cfif isdefined("attributes.status") and len(attributes.status)>
					AND VOUCHER_STATUS_ID IN (#attributes.status#)
				</cfif>
			ORDER BY
				VOUCHER_DUEDATE
		</cfquery>
	</cfif>
	<cfquery name="get_process_cat_" datasource="#dsn3#">
		SELECT PROCESS_TYPE, PROCESS_CAT_ID, PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN(13,14) ORDER BY PROCESS_CAT
	</cfquery>
<cfelse>
	<cfset get_member.recordcount = 0>
</cfif>
<cfinclude template="../query/get_money.cfm">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfform name="form_reeskont" method="post" action="#request.self#?fuseaction=account.list_reescount&event=add">
			<cf_box>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<cf_basket_form id="reeskont_valuation">
					<cf_box_elements>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-status">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
								<div class="col col-8 col-xs-12">
									<select name="status" id="status" multiple>
										<option value="1" <cfif isDefined("attributes.status") and listfind(attributes.status,'1',',')>selected</cfif>><cf_get_lang dictionary_id='50249.Portföyde'></option>
										<option value="2" <cfif isDefined("attributes.status") and listfind(attributes.status,'2',',')>selected</cfif>><cf_get_lang dictionary_id='50250.Bankada'></option>
										<option value="13" <cfif isDefined("attributes.status") and listfind(attributes.status,'13',',')>selected</cfif>><cf_get_lang dictionary_id='50467.Teminatta'></option>
										<option value="3" <cfif isDefined("attributes.status") and listfind(attributes.status,'3',',')>selected</cfif>><cf_get_lang dictionary_id='50251.Tahsil Edildi'></option>
										<option value="4" <cfif isDefined("attributes.status") and listfind(attributes.status,'4',',')>selected</cfif>><cf_get_lang dictionary_id='50252.Ciro Edildi'></option>
										<option value="5" <cfif isDefined("attributes.status") and listfind(attributes.status,'5',',')>selected</cfif>><cf_get_lang dictionary_id='50253.Karşılıksız'></option>
										<option value="6" <cfif isDefined("attributes.status") and listfind(attributes.status,'6',',')>selected</cfif>><cf_get_lang dictionary_id='50254.Ödenmedi'></option>
										<option value="7" <cfif isDefined("attributes.status") and listfind(attributes.status,'7',',')>selected</cfif>><cf_get_lang dictionary_id='50255.Ödendi'></option>
										<option value="8" <cfif isDefined("attributes.status") and listfind(attributes.status,'8',',')>selected</cfif>><cf_get_lang dictionary_id='58506.İptal'></option>
										<option value="9" <cfif isDefined("attributes.status") and listfind(attributes.status,'9',',')>selected</cfif>><cf_get_lang dictionary_id='29418.İade'></option>
										<option value="10" <cfif isDefined("attributes.status") and listfind(attributes.status,'10',',')>selected</cfif>><cf_get_lang dictionary_id='50253.Karşılıksız'>-<cf_get_lang dictionary_id='50249.Portföyde'></option>
										<option value="12" <cfif isDefined("attributes.status") and listfind(attributes.status,'12',',')>selected</cfif>><cf_get_lang dictionary_id='50363.İcra'></option>
										<option value="14" <cfif isDefined("attributes.status") and listfind(attributes.status,'14',',')>selected</cfif>><cf_get_lang dictionary_id='58568.Transfer'></option>
									</select>                                
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-money_type">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57489.Para Birimi'></label>
								<div class="col col-8 col-xs-12">
									<select name="money_type" id="money_type">
										<cfoutput query="get_money">
											<option value="#money#" <cfif isdefined("attributes.money_type") and len(attributes.money_type) and money eq attributes.money_type>selected</cfif>>#money#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-duty_claim">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57587.Borç'> / <cf_get_lang dictionary_id='57588.Alacak'></label>
								<div class="col col-8 col-xs-12">
									<select name="duty_claim" id="duty_claim">
										<option value=""><cf_get_lang dictionary_id='57587.Borç'> / <cf_get_lang dictionary_id='57588.Alacak'></option>
										<option value="1" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 1>selected</cfif>><cf_get_lang dictionary_id='57587.Borç'></option>
										<option value="2" <cfif isDefined("attributes.duty_claim") and attributes.duty_claim eq 2>selected</cfif>><cf_get_lang dictionary_id='57588.Alacak'></option>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-reeskont_rate">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50210.Reeskont Oranı'></label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="reeskont_rate" id="reeskont_rate" value="<cfif isDefined("attributes.reeskont_rate")><cfoutput>#attributes.reeskont_rate#</cfoutput></cfif>">
								</div>
							</div>
							<div class="form-group" id="item-due_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57881.Vade Tarihi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="due_date" id="due_date" value="#dateformat(attributes.due_date,dateformat_style)#" maxlength="10" validate="#validate_style#">
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="due_date"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="item-is_cheque">
								<label class="col col-12"><cf_get_lang dictionary_id='58007.Çek'><input type="checkbox" name="is_cheque" id="is_cheque" <cfif isdefined('attributes.is_cheque')>checked</cfif>></label>
							</div>
							<div class="form-group" id="item-is_voucher">
								<label class="col col-12"><cf_get_lang dictionary_id='58008.Senet'><input type="checkbox" name="is_voucher" id="is_voucher" <cfif isdefined('attributes.is_voucher')>checked</cfif>></label>
							</div>                         
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_wrk_search_button search_function="controlReescount()" button_type="2" button_name="#getLang('','Dök',57650)#" float="right">
					</cf_box_footer>
				</cf_basket_form>
			</cf_box>
			<cfif isdefined("attributes.form_submitted") and get_cheque_voucher.recordcount>
				<cf_box>
					<cf_basket id="reeskont_valuation_basket">
						<cf_grid_list>
							<thead>
								<tr>
									<th><cf_get_lang dictionary_id='57487.No'></th>
									<th><cfif isDefined("attributes.is_cheque")><cf_get_lang dictionary_id='58007.Cek'><cfelse><cf_get_lang dictionary_id='58008.Senet'></cfif><cf_get_lang dictionary_id='57487.No'></th>
									<th><cf_get_lang dictionary_id='57482.Asama'></th>	  
									<th class="text-right"><cf_get_lang dictionary_id='57673.Tutar'></th>
									<th><cf_get_lang dictionary_id='57489.Para Birimi'></th>
									<th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
									<th><cf_get_lang dictionary_id='57640.Vade'>/<cf_get_lang dictionary_id='57490.Gun'></th>
									<th class="text-right"><cf_get_lang dictionary_id='50221.Reeskont Tutarı'></th>
									<th class="text-right"><cf_get_lang dictionary_id='50224.İndirgenmiş Değer'></th>
									<th width="20"><input type="checkbox" name="all_check" id="all_check" value="1" onClick="check_all();"></th>
								</tr>
							</thead>
							<tbody>
								<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_cheque_voucher.recordcount#</cfoutput>">
								<cfoutput query="get_cheque_voucher">	
									<cfset vade_gun = DateDiff("d",due_date,attributes.due_date)>	
									<cfset reeskont_value = (total_value*(abs(vade_gun)*(filterNum(reeskont_rate)/365)))/100>
									<tr>
										<td>#currentrow#</td>
										<td>#doc_no#</td>
										<td>
											<cfswitch expression="#status_id#">
												<cfcase value="1"><font color="##003399"><cf_get_lang dictionary_id='50249.Portföyde'></font></cfcase>
												<cfcase value="2"><font color="##993366"><cf_get_lang dictionary_id='50250.Bankada'></font></cfcase>
												<cfcase value="13"><font color="##993366"><cf_get_lang dictionary_id='50467.Teminatta'></font></cfcase>
												<cfcase value="3"><cf_get_lang dictionary_id='50251.Tahsil Edildi'></cfcase>
												<cfcase value="4"><font color="##339900"><cf_get_lang dictionary_id='50252.Ciro Edildi'></font></cfcase>
												<cfcase value="5"><font color="##FF0000"><cf_get_lang dictionary_id='50253.Karşılıksız'></font></cfcase>
												<cfcase value="6"><font color="##FF0000"><cf_get_lang dictionary_id='50254.Ödenmedi'></font></cfcase>
												<cfcase value="7"><font color="##006600"><cf_get_lang dictionary_id='50255.Ödendi'></font></cfcase>
												<cfcase value="8"><font color="##006600"><cf_get_lang dictionary_id='58506.İptal'></font></cfcase>
												<cfcase value="9"><font color="##006600"><cf_get_lang dictionary_id='29418.İade'></font></cfcase>
												<cfcase value="10"><font color="##FF0000"><cf_get_lang dictionary_id='50253.Karşılıksız'>-<cf_get_lang dictionary_id='50249.Portföyde'></font></cfcase>
												<cfcase value="12"><font color="##FF0000"><cf_get_lang dictionary_id='50363.İcra'></font></cfcase>
												<cfcase value="14"><font color="##003399"><cf_get_lang dictionary_id='58568.transfer'></font></cfcase>
											</cfswitch>
										</td>
										<td class="text-right">#tlformat(total_value,2)#</td>
										<td>#currency_id#</td>
										<td>#dateformat(due_date,dateformat_style)#</td>
										<td>#DateDiff("d",due_date,attributes.due_date)#</td>
										<td class="text-right">#tlformat(reeskont_value,2)#</td>
										<td class="text-right">#tlformat(total_value-reeskont_value,2)#</td>
										<td class="text-center">
											<input type="checkbox" name="row_check#currentrow#" id="row_check#currentrow#" value="1" onchange="total_amount();" onClick="total_amount();">
										</td>				
									</tr>
									<input type="hidden" name="cheque_id#currentrow#" id="cheque_id#currentrow#" value="<cfif isdefined('cheque_id') and len(cheque_id)>#cheque_id#</cfif>" />
									<input type="hidden" name="voucher_id#currentrow#" id="voucher_id#currentrow#" value="<cfif isdefined('voucher_id') and len(voucher_id)>#voucher_id#</cfif>" /> 
									<input type="hidden" name="currency_id#currentrow#" id="currency_id#currentrow#" value="#currency_id#" />
									<input type="hidden" name="duedate_diff#currentrow#" id="duedate_diff#currentrow#" value="#vade_gun#" />
									<input type="hidden" name="cheq_voucher_due_date#currentrow#" id="cheq_voucher_due_date#currentrow#" value="#due_date#" />
									<input type="hidden" name="cheq_voucher_value#currentrow#" id="cheq_voucher_value#currentrow#" value="#tlformat(total_value,2)#" /> 
									<input type="hidden" name="reescount_value#currentrow#" id="reescount_value#currentrow#" value="#tlformat(reeskont_value,2)#" /> 
									<input type="hidden" name="discount_value#currentrow#" id="discount_value#currentrow#" value="#tlformat(total_value-reeskont_value,2)#" /> 
								</cfoutput>
							</tbody>
						</cf_grid_list>
						<br>
						<cf_box_elements>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
								<div class="form-group" id="item-process_cat">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57800.Operasyon Tipi'> *</label>
									<div class="col col-8 col-sm-12"><cf_workcube_process_cat slct_width="120"></div>
								</div>
								<div class="form-group" id="item-receipt_type">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="47348.Fiş Türü"> *</label>
									<div class="col col-8 col-sm-12">
										<select name="receipt_type" id="receipt_type">
											<option value=""><cf_get_lang dictionary_id ='57734.Seciniz'></option>
											<cfoutput query="get_process_cat_">
												<option value="#process_type#;#process_cat_id#">#process_cat#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-total_value">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='50226.Toplam Çek/Senet Tutarı'></label>
									<div class="col col-8 col-sm-12">
										<input type="text" name="total_value" id="total_value" value="" >
									</div>
								</div>
								<div class="form-group" id="item-total_reescount_value">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='50221.Reeskont Tutarı'></label>
									<div class="col col-8 col-sm-12">
										<input type="text" name="total_reescount_value" id="total_reescount_value" value="">
									</div>
								</div>
								<div class="form-group" id="item-total_reescount_value">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='50224.İndirgenmiş Değer'></label>
									<div class="col col-8 col-sm-12">
										<input type="text" name="total_discount_value" id="total_discount_value" value="">
									</div>
								</div>
								<div class="form-group" id="item-total_reescount_value">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57861.Ortalama Vade'></label>
									<div class="col col-8 col-sm-12">
										<cfinput type="text" name="average_due_date" id="average_due_date" value="" maxlength="10" validate="#validate_style#" readonly="readonly">
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="6" sort="true">
								<div class="form-group" id="item-expense_center_id">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></label>
									<div class="col col-8 col-sm-12">
										<cf_wrkExpenseCenter width_info="150" fieldId="expense_center_id" fieldName="expense_center_name" form_name="form_reeskont">
									</div>
								</div>
								<div class="form-group" id="item-expense_item_id">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></label>
									<div class="col col-8 col-sm-12">
										<cf_wrkExpenseItem width_info="150" fieldId="expense_item_id" fieldName="expense_item_name" form_name="form_reeskont" income_type_info="1" acc_code="reeskont_acc_code">
									</div>
								</div>
								<div class="form-group" id="item-reeskont_acc_code">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='50213.Reeskont'> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
									<div class="col col-8 col-sm-12">
										<div class="input-group">
											<cfinput type="text" name="reeskont_acc_code" value="" onFocus="AutoComplete_Create('reeskont_acc_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
											<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_reeskont.reeskont_acc_code');" title="<cfoutput>#getLang('main','Soru',58810)#</cfoutput>"></span>	
										</div>
									</div>
								</div>
								<div class="form-group" id="item-equivalent_acc_code">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='30087.Çek İşlemleri'> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
									<div class="col col-8 col-sm-12">
										<div class="input-group">
											<cfinput type="text" name="equivalent_acc_code" value="" onFocus="AutoComplete_Create('equivalent_acc_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','0','','','','3','225');" >
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_reeskont.equivalent_acc_code');" title="<cfoutput>#getLang('main','Soru',58810)#</cfoutput>"></span>	
										</div>
									</div>
								</div>
								<div class="form-group" id="item-action_date">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
									<div class="col col-8 col-sm-12">
										<div class="input-group">
											<cfinput type="text" name="action_date" value="#dateformat(now(),dateformat_style)#" maxlength="10" validate="#validate_style#">
											<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="action_date"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="7" sort="true">
								<div class="form-group" id="item-action_date">
									<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
									<div class="col col-9 col-xs-12">
										<textarea name="detail" id="detail" value="" style="width:140px;height:45px;"></textarea>
									</div>
								</div>
							</div>
						</cf_box_elements>
						<cf_box_footer>
							<cf_workcube_buttons is_upd='0' insert_info='#getLang('','Kaydet',57461)#' is_cancel='0' add_function="save_reescount()"></div>
						</cf_box_footer>
					</cf_basket>
				</cf_box>
			</cfif>
		</cfform>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

<script type="text/javascript">
	<cfif isdefined("attributes.form_submitted") and get_cheque_voucher.recordcount>
		document.getElementById('all_check').checked = true;
		check_all();
	</cfif>
	function controlReescount()
	{
		if ((document.getElementById('is_cheque').checked == true && document.getElementById('is_voucher').checked == true) || (document.getElementById('is_cheque').checked == false && document.getElementById('is_voucher').checked == false))
		{
			alert("<cf_get_lang dictionary_id='57198.Çek veya Senet Seçeneklerinden Birini Seçmelisiniz'>");
			return false;
		}
		if (document.getElementById('reeskont_rate').value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='50210.Reeskont Oranı'>");
			return false;
		}
		if (document.getElementById('due_date').value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57881.Vade Tarihi'>");
			return false;
		}
		if (document.getElementById('duty_claim').value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id ='57587.Borç'>/<cf_get_lang dictionary_id ='57588.Alacak'>");
			return false;
		}
		return true;
	}
	function check_all()
	{
		<cfif isdefined("get_cheque_voucher") and get_cheque_voucher.recordcount >
			if(document.getElementById('all_check').checked)
			{
				for (var i=1; i <= <cfoutput>#get_cheque_voucher.recordcount#</cfoutput>; i++)
				{
					var form_field = document.getElementById('row_check' + i);
					form_field.checked = true;
				}
			}
			else
			{
				for (var i=1; i <= <cfoutput>#get_cheque_voucher.recordcount#</cfoutput>; i++)
				{
					form_field = document.getElementById('row_check' + i);
					form_field.checked = false;
				}				
			}
		</cfif>
		total_amount();
	}
	function total_amount()
	{
		var total_value = 0;
		var total_reescount_value = 0;
		var total_discount_value = 0;
		var total_carpan_new = 0;
		var avg_duedate_new = 0;
		<cfif isdefined("get_cheque_voucher")>
			for (var i=1; i <= <cfoutput>#get_cheque_voucher.recordcount#</cfoutput>; i++)
			{		
				if(document.getElementById('row_check' +i).checked)	
				{
					total_value += parseFloat(filterNum(document.getElementById('cheq_voucher_value'+i).value));
					total_reescount_value += parseFloat(filterNum(document.getElementById('reescount_value'+i).value));
					total_discount_value += parseFloat(filterNum(document.getElementById('discount_value'+i).value));
					total_carpan_new = parseFloat(total_carpan_new) + parseFloat(filterNum(document.getElementById('cheq_voucher_value'+i).value)*document.getElementById('duedate_diff'+i).value);
				}
			}
			// hesaplanan toplam degerler set ediliyor
			document.getElementById('total_value').value = commaSplit(total_value);							//toplam cek/senet tutari
			document.getElementById('total_reescount_value').value = commaSplit(total_reescount_value);		//toplam reeskont tutari
			document.getElementById('total_discount_value').value = commaSplit(total_discount_value); 		//indirgenmis deger
			if (total_value != 0)																			
				avg_duedate_new = parseInt(total_carpan_new / total_value);
			avg_duedate_new = date_add('d',avg_duedate_new,document.getElementById('due_date').value);
			document.getElementById('average_due_date').value = avg_duedate_new;							//ortalama Vade
		</cfif>
	}
	function save_reescount()
	{
		if (!chk_process_cat('form_reeskont')) return false;
		if (document.getElementById('receipt_type').value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='39346.Fiş Türü'>");
			return false;
		} 
		if (document.getElementById('action_date').value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57879.İşlem Tarihi'>");
			return false;
		}
		if (document.getElementById('reeskont_acc_code').value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='50213.Reeskont'> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'>");
			return false;
		}
		if (document.getElementById('equivalent_acc_code').value == '')
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='50227.Çek/Senet Karşılık'> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'>");
			return false;
		}
		unformat_fields();
		document.getElementById('form_reeskont').action = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.emptypopup_add_reescount';
	}
	function unformat_fields()
	{
		for(var i=1; i<=document.getElementById('record_num').value; i++)
		{
			document.getElementById('cheq_voucher_value'+i).value = filterNum(document.getElementById('cheq_voucher_value'+i).value);
			document.getElementById('discount_value'+i).value = filterNum(document.getElementById('discount_value'+i).value);
			document.getElementById('reescount_value'+i).value = filterNum(document.getElementById('reescount_value'+i).value);
		}
		document.getElementById('reeskont_rate').value = filterNum(document.getElementById('reeskont_rate').value);
		document.getElementById('total_value').value = filterNum(document.getElementById('total_value').value);
		document.getElementById('total_discount_value').value = filterNum(document.getElementById('total_discount_value').value);
		document.getElementById('total_reescount_value').value = filterNum(document.getElementById('total_reescount_value').value);
	}	
</script>

