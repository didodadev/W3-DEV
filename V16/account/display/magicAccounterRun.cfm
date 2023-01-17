<cfquery name = "get_wizard" datasource = "#dsn#">
	SELECT
		AW.WIZARD_ID,
		AW.WIZARD_NAME,
		AW.WIZARD_DESIGNER,
		E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS EMPLOYEE_FULLNAME,
		AW.WIZARD_STAGE,
		CONVERT(nvarchar(10),AW.WIZARD_DATE,103) AS WIZARD_DATE,
		AW.PERIOD_MONTH,
		AW.PERIOD_DAY,
		AW.CARD_PROCESS_CAT,
		AW.TARGET_TYPE,
		AWB.WIZARD_BLOCK_ID,
		AWB.BLOCK_NAME,
		AWB.BLOCK_BA,
		AWBR.WIZARD_BLOCK_ROW_ID,
		AWBR.BLOCK_COLUMN,
		AWBR.ACCOUNT_CODE,
		AWBR.RATE,
		AWBR.DESCRIPTION,
		AWBR.ACTION_TYPE
	FROM
		ACCOUNT_WIZARD AW
			LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = AW.WIZARD_DESIGNER
			LEFT JOIN ACCOUNT_WIZARD_BLOCK AWB ON AWB.WIZARD_ID = AW.WIZARD_ID
			LEFT JOIN ACCOUNT_WIZARD_BLOCK_ROW AWBR ON AWBR.WIZARD_BLOCK_ID = AWB.WIZARD_BLOCK_ID
	WHERE
		AW.WIZARD_ID = #attributes.wizard_id#
	ORDER BY
		AW.WIZARD_ID,
		AWB.WIZARD_BLOCK_ID,
		AWBR.WIZARD_BLOCK_ROW_ID
</cfquery>
<cfif not get_wizard.recordcount>
	<script type = "text/javascript">
		alert("<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>");
		window.location.href = "<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
	</script>
	<cfabort>
</cfif>
<cfscript>
	getJSON = serializeJSON(get_wizard,'struct');
	if(left(getJSON,2) eq '//')
		getJSON = replace(getJSON, '//', '');
</cfscript>

<cfsavecontent  variable="tab_menu">
	<cfoutput>
		<a href="index.cfm?fuseaction=account.wizard" target="_blank" title="Liste">
			<i class="icon-list-ul"></i>
		</a>
		<a href="#request.self#?fuseaction=account.wizard&event=upd&wizard_id=#wizard_id#">
			<i class="fa fa-edit" aria-hidden="true"></i>
		</a>
	</cfoutput>
</cfsavecontent>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','',60726)# : #get_wizard.wizard_name#" closable="0"> 
		<cfparam name = "attributes.start_date" default = "01#dateformat(now(),'/mm/yyyy')#">
		<cfparam name = "attributes.finish_date" default = "#daysinmonth(now())##dateformat(now(),'/mm/yyyy')#">
		<cfparam name = "attributes.action_date" default = "#dateformat(now(),'dd/mm/yyyy')#">
		<cfparam name = "attributes.target_type" default = "#get_wizard.TARGET_TYPE#">

		<cf_date tarih = "attributes.start_date">
		<cf_date tarih = "attributes.finish_date">
		<cf_date tarih = "attributes.action_date">

		<cfquery name = "get_blocks" dbtype = "query">
			SELECT DISTINCT WIZARD_BLOCK_ID FROM get_wizard
		</cfquery>
			<div class="row">
				<cfoutput>
					<cfform name = "run_wizard" id = "run_wizard" method = "post">
						<input type = "hidden" name = "run_submitted" id = "run_submitted" value = "1">
						<input type = "hidden" name = "save_submitted" id = "save_submitted" value = "0">
						<input type = "hidden" name = "is_manual" id = "is_manual" value = "0">
						<cf_box_elements>
							<div class="col col-3">
								<div class="form-group" id="item-start_date">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<input type="text" name="start_date" id="start_date" maxlength="10" value = "#dateformat(attributes.start_date,'dd/mm/yyyy')#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-finish_date">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<input type="text" name="finish_date" id="finish_date" maxlength="10"  value = "#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-action_date">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47445.Fiş Tarihi'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<div class="input-group">
											<input type="text" name="action_date" id="action_date" maxlength="10"  value = "#dateformat(attributes.action_date,'dd/mm/yyyy')#">
											<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-target_type">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57951.Hedef'> <cf_get_lang dictionary_id='38752.Tablo'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<select name = "target_type" id = "target_type">
											<option value = ""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<option value = "0" <cfif attributes.target_type eq 0>selected</cfif>><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
											<option value = "1" <cfif attributes.target_type eq 1>selected</cfif>>IFRS</option>
											<option value = "2" <cfif attributes.target_type eq 2>selected</cfif>><cf_get_lang dictionary_id='63097.Birleşik'></option>
										</select>
									</div>
								</div>
							</div>
						</cf_box_elements>
						<cf_box_footer>
							<div class="col col-12 col-md-12 col-sm-12 col-xs-12 text-right">
								<input type = "button" value = "<cf_get_lang dictionary_id='57911.Çalıştır'>" onClick = "submit();">
								<cfif isDefined('attributes.run_submitted') and attributes.run_submitted eq 1>
									<input type = "button" value = "<cf_get_lang dictionary_id='57461.Kaydet'>" onClick = "save_card();">
								</cfif>
							</div>
						</cf_box_footer>
					</cfform>
				</cfoutput>
			</div>
				<script type = "text/javascript">
					function save_card() {
							$("#save_submitted").val(1);
							$("#is_manual").val(1);
							$("#run_wizard").submit();
						return true;
					}
				</script>
				<cfquery name = "get_prev_cards" datasource = "#dsn#">
					SELECT
						AC.CARD_ID,
						AC.BILL_NO,
						AC.ACTION_DATE
					FROM
						ACCOUNT_WIZARD_RELATION AWR
							LEFT JOIN #dsn2#.ACCOUNT_CARD AC ON AC.CARD_ID = AWR.CARD_ID
					WHERE
						AWR.WIZARD_ID = #get_wizard.wizard_id#
						AND AWR.PERIOD_ID = #session.ep.period_id#
						AND AC.CARD_ID IS NOT NULL
					ORDER BY
						AC.ACTION_DATE DESC,
						AC.BILL_NO DESC
				</cfquery>	
			<div class="col col-12">
				<cf_grid_list>
					<thead>
						<tr>
							<th width="10">#</th>
							<th><cf_get_lang dictionary_id='57742.Tarih'></th>
							<th><cf_get_lang dictionary_id='39373.Yevmiye No'></th>
							<th width="20"><a href="javascript:void(0)"><i class="fa fa-pencil"></i></a></th>
						</tr>
					</thead>
					<tbody>
						<cfif get_prev_cards.recordcount>
							<cfoutput query = "get_prev_cards">
								<tr>
									<td>#currentrow#</td>
									<td>#dateformat(action_date,dateformat_style)#</td>
									<td>#bill_no#</td>
									<td>
										<a href="index.cfm?fuseaction=account.form_add_bill_cash2cash&amp;event=upd&amp;card_id=#card_id#" target="_blank">
											<i class="fa fa-pencil" title=" <cf_get_lang dictionary_id='57464.Güncelle'>  (#bill_no#)"></i>
										</a>
									</td>
								</tr>
							</cfoutput>
						<cfelse>
							<tr>
								<td colspan = "4"><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
							</tr>
						</cfif>
					</tbody>
				</cf_grid_list>
			</div>
			<div class="col col-12">
				<cfif isDefined('attributes.run_submitted') and attributes.run_submitted eq 1>
					<cfquery name = "del_empty_relations" datasource = "#dsn#">
						WITH CTE1 AS (
							SELECT
								AWR.WIZARD_CARD_RELATION_ID,
								AW.WIZARD_ID,
								AC.CARD_ID
							FROM
								ACCOUNT_WIZARD_RELATION AWR
									LEFT JOIN ACCOUNT_WIZARD AW ON AW.WIZARD_ID = AWR.WIZARD_ID
									LEFT JOIN #dsn2#.ACCOUNT_CARD AC ON AC.CARD_ID = AWR.CARD_ID
							WHERE
								AWR.PERIOD_ID = #session.ep.period_id#
								AND (
									AW.WIZARD_ID IS NULL
									OR AC.CARD_ID IS NULL
								)
						)
						DELETE FROM ACCOUNT_WIZARD_RELATION WHERE WIZARD_CARD_RELATION_ID IN (SELECT WIZARD_CARD_RELATION_ID FROM CTE1)
					</cfquery>
					<cfscript>
						borc_hesap_list = '';
						borc_tutar_list = '';
						alacak_hesap_list = '';
						alacak_tutar_list = '';

						fis_satir_detay = [];
						fis_satir_detay[1] = [];
						fis_satir_detay[2] = [];
					</cfscript>

					<cfloop from = "1" to = "#get_blocks.recordcount#" index = "b">
						<cfquery name = "get_block" dbtype = "query">
							SELECT * FROM get_wizard WHERE WIZARD_BLOCK_ID = #get_blocks.wizard_block_id[b]# ORDER BY BLOCK_COLUMN
						</cfquery>
						
						<cfset total_block1_bakiye = 0>
						<cfset total_block3_bakiye = 0>

						<cfscript>
							first_hesap_list = '';
							first_tutar_list = '';
							second_hesap_list = '';
							second_tutar_list = '';

							first_detay_list = [];
							second_detay_list = [];

							first_toplam = 0;
							second_toplam = 0;
						</cfscript>

						<cfoutput query = "get_block">
							
							<cfif block_column eq 1>
								
								<cfquery name = "get_balance" datasource = "#dsn2#">
									WITH CTE1 AS (
										SELECT
											AP.ACCOUNT_CODE,
											ISNULL(SUM(ACR.AMOUNT * (1 - 2 * ACR.BA)),0) AS ACC_BALANCE
										FROM
											ACCOUNT_PLAN AP
												LEFT JOIN ACCOUNT_CARD_ROWS ACR ON ACR.ACCOUNT_ID LIKE AP.ACCOUNT_CODE + '%'
												LEFT JOIN ACCOUNT_CARD AC ON AC.CARD_ID = ACR.CARD_ID
										WHERE
											1 = 1
											<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
												AND AC.ACTION_DATE >= #attributes.start_date#
											</cfif>
											<cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
												AND AC.ACTION_DATE <= #attributes.finish_date#
											</cfif>
											<cfif len(get_block.ACTION_TYPE[currentRow])>
												AND AC.ACTION_TYPE IN (#get_block.ACTION_TYPE[currentRow]#)
											</cfif>
										GROUP BY
											AP.ACCOUNT_CODE
									)
									SELECT
										ACCOUNT_CODE,
										ACC_BALANCE
									FROM
										CTE1
									WHERE
										ACCOUNT_CODE = '#account_code#'
								</cfquery>
							</cfif>
							<cfif len(get_balance.acc_balance)>
								<cfset acc_balance = get_balance.acc_balance>
							<cfelse>
								<cfset acc_balance = 0>
							</cfif>
							<cfscript>
								switch(block_column) {
									case 1 :
										this_bakiye = acc_balance * (rate/100);

										if(this_bakiye gt 0) {
											this_borc = 0;
											this_alacak = acc_balance * (rate/100);
										} else {
											this_borc = acc_balance * (rate/100) * -1;
											this_alacak = 0;
										}
										
										total_block1_bakiye = total_block1_bakiye + this_bakiye;
									break;

									case 2 :
										if(total_block1_bakiye gt 0) {
											this_borc = total_block1_bakiye * (rate/100);
											this_alacak = 0;
										} else {
											this_borc = 0;
											this_alacak = total_block1_bakiye * (rate/100) * -1;
										}
									break;

									case 3 :
										if(total_block1_bakiye gt 0) {
											this_alacak = 0;
											this_borc = total_block1_bakiye * (rate/100);

											total_block3_bakiye = total_block3_bakiye + this_borc;
										} else {
											this_alacak = total_block1_bakiye * (rate/100) * -1;
											this_borc = 0;
											
											total_block3_bakiye = total_block3_bakiye - this_alacak;
										}
									break;

									case 4 :
										if(total_block3_bakiye gt 0) {
											this_borc = 0;
											this_alacak = total_block3_bakiye * (rate/100);
										} else {
											this_borc = total_block3_bakiye * (rate/100);
											this_alacak = 0;
										}
									break;

									default :
										this_borc = 0;
										this_alacak = 0;
									break;
								}

								this_borc = numberFormat(this_borc,'9.99');
								this_alacak = numberFormat(this_alacak,'9.99');
							</cfscript>

							<cfscript>
								if(this_borc gt 0) {
									first_tutar_list = listAppend(first_tutar_list, this_borc);
									first_hesap_list = listAppend(first_hesap_list, account_code);
									first_detay_list[arrayLen(first_detay_list) + 1] = '#block_name# - #description#';

									first_toplam = first_toplam + this_borc;
								}
								
								if(this_alacak gt 0) {
									second_tutar_list = listAppend(second_tutar_list, this_alacak);
									second_hesap_list = listAppend(second_hesap_list, account_code);
									second_detay_list[arrayLen(second_detay_list) + 1] = '#block_name# - #description#';

									second_toplam = second_toplam + this_alacak;
								}

								switch(block_ba) {
									case 0 : // Borç
										if(total_block1_bakiye gt 0) {
											reverse_type = 1;
										} else {
											reverse_type = 0;
										}
									break;
									case 1 : // Alacak
										if(total_block1_bakiye gt 0) {
											reverse_type = 0;
										} else {
											reverse_type = 1;
										}
									break;
								}
							</cfscript>
						</cfoutput>

						<cfscript>
							if(reverse_type eq 1) {
								borc_hesap_list = listAppend(borc_hesap_list, first_hesap_list);
								borc_tutar_list = listAppend(borc_tutar_list, first_tutar_list);
								alacak_hesap_list = listAppend(alacak_hesap_list, second_hesap_list);
								alacak_tutar_list = listAppend(alacak_tutar_list, second_tutar_list);

								for(f = 1; f lte arrayLen(first_detay_list); f++ ) {
									fis_satir_detay[1][arrayLen(fis_satir_detay[1]) + 1] = first_detay_list[f];
								}
								for(f = 1; f lte arrayLen(second_detay_list); f++ ) {
									fis_satir_detay[2][arrayLen(fis_satir_detay[2]) + 1] = second_detay_list[f];
								}
							} else {
								borc_hesap_list = listAppend(borc_hesap_list, second_hesap_list);
								borc_tutar_list = listAppend(borc_tutar_list, second_tutar_list);
								alacak_hesap_list = listAppend(alacak_hesap_list, first_hesap_list);
								alacak_tutar_list = listAppend(alacak_tutar_list, first_tutar_list);


								for(f = 1; f lte arrayLen(second_detay_list); f++ ) {
									fis_satir_detay[1][arrayLen(fis_satir_detay[1]) + 1] = second_detay_list[f];
								}
								for(f = 1; f lte arrayLen(first_detay_list); f++ ) {
									fis_satir_detay[2][arrayLen(fis_satir_detay[2]) + 1] = first_detay_list[f];
								}
							}
						</cfscript>
					</cfloop>
					<cfscript>
						total_borc = 0;
						total_alacak = 0;
						for( b = 1; b lte listLen(borc_tutar_list); b++ ) {
							total_borc = total_borc + listGetAt(borc_tutar_list, b);
						}
						for( a = 1; a lte listLen(alacak_tutar_list); a++ ) {
							total_alacak = total_alacak + listGetAt(alacak_tutar_list, a);
						}

						round_diff = total_borc - total_alacak;

						if(round_diff gt 0) {
							listSetAt(borc_tutar_list, listLen(borc_tutar_list), listLast(borc_tutar_list) - round_diff);
						}
					</cfscript>
					<cfquery name = "get_acc_names" datasource = "#dsn2#">
						SELECT ACCOUNT_CODE, ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ',#listAppend(borc_hesap_list,alacak_hesap_list)#,' LIKE '%,' + ACCOUNT_CODE + ',%'
					</cfquery>
									
					<cfoutput>
						<cf_grid_list>
							<cfset borc_toplam = 0>
							<cfset alacak_toplam = 0>
							<thead>
								<tr>
									<th><cf_get_lang dictionary_id='57587.Borç'> <cf_get_lang dictionary_id='57652.Hesap'></th>
									<th><cf_get_lang dictionary_id='57588.Alacak'> <cf_get_lang dictionary_id='57652.Hesap'></th>
									<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
									<th style = "text-align:right;"><cf_get_lang dictionary_id='57587.Borç'> <cf_get_lang dictionary_id='57673.Tutar'></th>
									<th style = "text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'> <cf_get_lang dictionary_id='57673.Tutar'></th>
									
								</tr>
							</thead>
							<tbody>
								<cfloop from = "1" to = "#listlen(borc_hesap_list)#" index = "b">
									<cfset borc_toplam = borc_toplam + listGetAt(borc_tutar_list,b)>
									<tr>
										<cfquery name = "get_this_acc" dbtype = "query">
											SELECT * FROM get_acc_names WHERE ACCOUNT_CODE = '#listGetAt(borc_hesap_list,b)#'
										</cfquery>
										<td>#listGetAt(borc_hesap_list,b)# - #get_this_acc.account_name#</td>
										<td></td>
										<td>#fis_satir_detay[1][b]#</td>
										<td style = "text-align:right;">#TLFormat(listGetAt(borc_tutar_list,b))# #session.ep.money#</td>
										<td style = "text-align:right;"></td>
									</tr>
								</cfloop>
								<cfloop from = "1" to = "#listlen(alacak_hesap_list)#" index = "a">
									<cfset alacak_toplam = alacak_toplam + listGetAt(alacak_tutar_list,a)>
									<tr>
										<cfquery name = "get_this_acc" dbtype = "query">
											SELECT * FROM get_acc_names WHERE ACCOUNT_CODE = '#listGetAt(alacak_hesap_list,a)#'
										</cfquery>
										<td></td>
										<td>#listGetAt(alacak_hesap_list,a)# - #get_this_acc.account_name#</td>
										<td>#fis_satir_detay[2][a]#</td>
										<td style = "text-align:right;"></td>
										<td style = "text-align:right;">#TLFormat(listGetAt(alacak_tutar_list,a))# #session.ep.money#</td>
									</tr>
								</cfloop>
							</tbody>
								<tr>
									<td colspan = "3" style = "text-align:right;"><strong><cf_get_lang dictionary_id='57492.Toplam'>:</strong></td>
									<td style = "text-align:right;"><strong>#TLFormat(borc_toplam)# #session.ep.money#</strong></td>
									<td style = "text-align:right;"><strong>#TLFormat(alacak_toplam)# #session.ep.money#</strong></td>
								</tr>
						</cf_grid_list>
					</cfoutput>
				<cfelse>

				</cfif>
			</div>
		<cfif isDefined('attributes.save_submitted') and attributes.save_submitted eq 1>
			<cfscript>
				round_amount = first_toplam - second_toplam;
				if(get_block.block_ba eq 1) {
					alacak_tutar_list = listSetAt(alacak_tutar_list, listLen(alacak_tutar_list), listLast(alacak_tutar_list) + round_amount);
				} else if(isdefined("borc_tutar_list") and len(borc_tutar_list)) {
					borc_tutar_list = listSetAt(borc_tutar_list, listLen(borc_tutar_list), listLast(borc_tutar_list) - round_amount);
				}else{ 
				}
				card_id = muhasebeci(
					action_id : 0,
					workcube_process_type : 13,
					account_card_type : 13,
					account_card_catid : get_wizard.card_process_cat,
					islem_tarihi : attributes.action_date,
					borc_hesaplar : borc_hesap_list,
					borc_tutarlar : borc_tutar_list,
					alacak_hesaplar : alacak_hesap_list,
					alacak_tutarlar : alacak_tutar_list,
					fis_detay : "#dateformat(attributes.start_date,'dd/mm/yyyy')# - #dateformat(attributes.finish_date,'dd/mm/yyyy')# #get_wizard.wizard_name# işlemi.",
					fis_satir_detay : fis_satir_detay,
					max_round_amount : 0.5
				);
			</cfscript>

			<cfif attributes.target_type eq 0>
				<cfquery name = "del_ifrs_rows" datasource = "#dsn2#">
					DELETE FROM ACCOUNT_ROWS_IFRS WHERE CARD_ID = #card_id#
				</cfquery>
			<cfelseif attributes.target_type eq 1>
				<cfquery name = "del_vuk_rows" datasource = "#dsn2#">
					DELETE FROM ACCOUNT_CARD_ROWS WHERE CARD_ID = #card_id#
				</cfquery>
			</cfif>

			<cfif len(card_id) and card_id gt 0>
				<cfquery name = "get_card" datasource = "#dsn2#">
					SELECT CARD_ID, BILL_NO FROM ACCOUNT_CARD WHERE CARD_ID = #card_id#
				</cfquery>
				<cfquery name = "save_relation" datasource = "#dsn#">
					INSERT INTO
						ACCOUNT_WIZARD_RELATION
					(
						WIZARD_ID,
						CARD_ID,
						PERIOD_ID,
						IS_MANUAL,
						RECORD_DATE
					) VALUES (
						#get_wizard.wizard_id#,
						#get_card.card_id#,
						#session.ep.period_id#,
						#attributes.is_manual#,
						#now()#
					)
				</cfquery>
				<script type = "text/javascript">
					alert('Mahsup fişi kaydedildi. Yevmiye No : <cfoutput>#get_card.bill_no#</cfoutput>');
					window.location.href = "<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&wizard_id=#get_wizard.wizard_id#</cfoutput>";
				</script>
			</cfif>
		</cfif>
	</cf_box>
</div>