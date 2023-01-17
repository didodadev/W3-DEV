<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<div class="ui-row">
	<div id="sepetim_total" class="padding-0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<div class="totalBox">
				<div class="totalBoxHead font-grey-mint">
					<span class="headText"> <cf_get_lang_main no='265.Dövizler'> </span>
					<div class="collapse">
						<span class="icon-minus"></span>
					</div>
				</div>
				<div class="totalBoxBody">
					<table id="mny_table">
						<tbody>
						<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_rate.recordcount#</cfoutput>">
						<cfinput type="hidden" name="money_type" id="money_type" value="#session.ep.money#">
						<cfoutput query="get_money_rate">
							<cfif is_action_date eq 1>
								<cfquery name="GET_MONEY_HIST" datasource="#DSN#" maxrows="1">
									SELECT
										<cfif xml_money_type eq 1>
											ISNULL(RATE3,RATE2) RATE2_
										<cfelseif xml_money_type eq 3>
											ISNULL(EFFECTIVE_PUR,RATE2) RATE2_
										<cfelseif xml_money_type eq 4>
											ISNULL(EFFECTIVE_SALE,RATE2) RATE2_
										<cfelse>
											RATE2 RATE2_
										</cfif>
									FROM 
										MONEY_HISTORY
									WHERE 
										VALIDATE_DATE <= #CreateODBCDate(attributes.action_date)#
										AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
										AND MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_money_rate.money#">
									ORDER BY 
										MONEY_HISTORY_ID DESC
								</cfquery>
							</cfif>
							<cfif isdefined("get_money_hist") and get_money_hist.recordcount>
								<cfset rate2_new = get_money_hist.rate2_>
							<cfelse>
								<cfset rate2_new = rate2_>
							</cfif>
							<tr>
								<td height="17">
									<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
									<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
									<input type="radio" name="rd_money" id="rd_money" onClick="toplam_hesapla();" value="#money#,#currentrow#,#rate1#,#rate2_new#" <cfif money eq session.ep.money2>checked</cfif>>#money#
								</td>
								<td>#TLFormat(rate1,0)#/</td>
								<td><input type="text" class="box" money_type="#money#" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2_new,4)#" onKeyUp="return(FormatCurrency(this,event,4));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(1);toplam_hesapla();" style="width:100%;"></td>
							</tr>
						</cfoutput>
						<tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
			<cf_box_elements>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<cf_get_lang dictionary_id="35377.işlem adı">
					</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="act_type" id="act_type" onclick="control_act_type(this.value)">
							<option value="1"><cf_get_lang dictionary_id="60372.Dekont Eklensin"></option>
							<option value="2"><cf_get_lang dictionary_id="60373.Sistem Ödeme Planı Satırı Eklensin"></option>
							<option value="3"><cf_get_lang dictionary_id="60374.Fatura Kontrol Satırı Eklensin"></option>
						</select>
					</div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="act_1">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='388.işlem tipi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process_cat slct_width="200"></div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="act_4">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process is_upd='0' is_detail='0' process_cat_width="200"></div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="act_2" style="display:none;">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no = '245.Ürün'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="product_id" id="product_id" value="">
						<input type="hidden" name="tax" id="tax" value="">
						<input type="hidden" name="stock_id" id="stock_id" value="">
						<input type="text" name="product_name" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID,TAX','product_id,stock_id,tax','add_due_diff_action','3','250');" value="" readonly="yes" autocomplete="off">
						<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_tax=add_due_diff_action.tax&product_id=add_due_diff_action.product_id&field_id=add_due_diff_action.stock_id&field_name=add_due_diff_action.product_name','list');"></span>
					</div>
					</div>
				</div>
				<cfif is_action_date eq 0>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='467.İşlem Tarihi'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="action_date" validate="#validate_style#" required="yes" message="İşlem Tarihi Giriniz" value="#dateformat(now(),dateformat_style)#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
							</div>
						</div>
					</div>
				</cfif>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1104.Ödeme Yöntemi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">	
						<div class="input-group">
							<input type="hidden" name="card_paymethod_id2" id="card_paymethod_id2" value="<cfif isdefined("attributes.card_paymethod_id2") and len(attributes.card_paymethod_id2)><cfoutput>#attributes.card_paymethod_id2#</cfoutput></cfif>">
							<input type="hidden" name="payment_type_id2" id="payment_type_id2" value="<cfif isdefined("attributes.payment_type_id2") and len(attributes.payment_type_id2)><cfoutput>#attributes.payment_type_id2#</cfoutput></cfif>">
							<input type="text" name="payment_type2" id="payment_type2" value="<cfif isdefined("attributes.payment_type2") and len(attributes.payment_type2)><cfoutput>#attributes.payment_type2#</cfoutput></cfif>">
							<input type="hidden"  name="due_day" id="due_day" value="<cfif isdefined("attributes.due_day") and len(attributes.due_day)><cfoutput>#attributes.due_day#</cfoutput></cfif>">
							
							<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" title="<cf_get_lang_main no='1104.Ödeme Yöntemi'>" OnCLick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=add_due_diff_action.payment_type_id2&field_name=add_due_diff_action.payment_type2&field_card_payment_id=add_due_diff_action.card_paymethod_id2&field_card_payment_name=add_due_diff_action.payment_type2&field_dueday=add_due_diff_action.due_day','medium');"></span>
						</div>
					</div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="act_3" style="display:none;">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='25.KDV Dahil'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="checkbox" name="is_kdv" id="is_kdv" value="1">
					</div>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.açıklama'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><textarea name="note" id="note"></textarea></div>
				</div>
			</cf_box_elements>
		</div>
		<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
			<cf_box_elements vertical="1">
				<cfoutput query="get_money">
					<div class="form-group">
						<div class="input-group">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
								<input value="#money#" readonly>
							</div>
							<span class="input-group-addon"><strong>0</strong></span>
							<input id="deger_artis_#money#" name="deger_artis_#money#" value="0" class="moneybox" readonly type="text">
						</div>
					</div>
				</cfoutput>
				<div class="form-group">
					<label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><cf_get_lang dictionary_id='33046.Sistem Para Birimi'>- <cf_get_lang dictionary_id='57492.Toplam'></label>
					<div class="input-group">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<input value="<cfoutput>#session.ep.money#</cfoutput>" readonly>
						</div>
						<span class="input-group-addon"><strong>0</strong></span>
						<input id="deger_artis_system" name="deger_artis_system" value="0" class="moneybox" readonly type="text">
					</div>
				</div>
			</cf_box_elements>
		</div>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<div class="ui-form-list-btn flex-end">
				<cf_workcube_buttons is_upd='0' is_cancel='0' add_function='kontrol()'>
			</div>
		</div>
	</div>
</div>
