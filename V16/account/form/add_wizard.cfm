
<cfif attributes.event eq 'upd' or attributes.event eq 'run'>
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
			AWBR.ACTION_TYPE,
			AW.RECORD_EMP,
			AW.RECORD_DATE,
			AW.RECORD_IP,
			AW.UPDATE_EMP,
			AW.UPDATE_DATE,
			AW.UPDATE_IP
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
			alert('<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!');
			window.location.href = "<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
		</script>
		<cfabort>
	</cfif>
	<cfscript>
		getJSON = serializeJSON(get_wizard,'struct');
		if(left(getJSON,2) eq '//')
			getJSON = replace(getJSON, '//', '');
	</cfscript>
</cfif>
<cfif attributes.event eq 'run'> 
	<cfparam name = "attributes.start_date" default = "01#dateformat(now(),'/mm/yyyy')#">
	<cfparam name = "attributes.finish_date" default = "#daysinmonth(now())##dateformat(now(),'/mm/yyyy')#">
	<cfparam name = "attributes.action_date" default = "#dateformat(now(),'dd/mm/yyyy')#">

	<cf_date tarih = "attributes.start_date">
	<cf_date tarih = "attributes.finish_date">
	<cf_date tarih = "attributes.action_date">

	<cfquery name = "get_blocks" dbtype = "query">
		SELECT DISTINCT WIZARD_BLOCK_ID FROM get_wizard
	</cfquery>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cfoutput>
				<cfform name = "run_wizard" id = "run_wizard" method = "post">
					<input type = "hidden" name = "run_submitted" id = "run_submitted" value = "1">
					<input type = "hidden" name = "save_submitted" id = "save_submitted" value = "0">
					<input type = "hidden" name = "is_manual" id = "is_manual" value = "0">
					<cf_box_elements>
						<div class = "col col-3">
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
										<input type="text" name="finish_date" id="finish_date" maxlength="10" value = "#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-action_date">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47445.Fiş Tarihi'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="action_date" id="action_date" maxlength="10" value = "#dateformat(attributes.action_date,'dd/mm/yyyy')#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
									</div>
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_box_footer >
						<div class="col col-12 col-md-12 col-sm-12 col-xs-12 text-right">
							<input type = "button" value = "Çalıştır!" onClick = "submit();">
							<cfif isDefined('attributes.run_submitted') and attributes.run_submitted eq 1>
								<input type = "button" value = "Kaydet!" onClick = "save_card();">
							</cfif>
						</div>
					</cf_box_footer>
				</cfform>
			</cfoutput>
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
			<div class = "col col-12">
				<cf_grid_list>
					<thead>
						<tr>
							<th></th>
							<th><cf_get_lang dictionary_id='57742.Tarih'></th>
							<th><cf_get_lang dictionary_id='39373.Yevmiye No'></th>
							<th></th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query = "get_prev_cards">
							<tr>
								<td>#currentrow#</td>
								<td>#dateformat(action_date,'dd/mm/yyyy')#</td>
								<td>#bill_no#</td>
								<td>
									<a href="index.cfm?fuseaction=account.form_add_bill_cash2cash&amp;event=upd&amp;card_id=#card_id#" target="_blank">
										<img src="/images/update_list.gif" style="vertical-align:middle" alt=" <cf_get_lang dictionary_id='57464.Güncelle'>  (#bill_no#)" title=" <cf_get_lang dictionary_id='57464.Güncelle'>  (#bill_no#)">
									</a>
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</cf_grid_list>
			</div>
			<div class = "col col-12">
				<cf_grid_list>
					<thead>
						<tr>
							<th><cf_get_lang dictionary_id='57587.Borç'> <cf_get_lang dictionary_id='57652.Hesap'></th>
							<th><cf_get_lang dictionary_id='57588.Alacak'> <cf_get_lang dictionary_id='57652.Hesap'></th>
							<th style = "text-align:right;"><cf_get_lang dictionary_id='57587.Borç'> <cf_get_lang dictionary_id='57673.Tutar'></th>
							<th style = "text-align:right;"><cf_get_lang dictionary_id='57588.Alacak'> <cf_get_lang dictionary_id='57673.Tutar'></th>
						</tr>
					</thead>
					<tbody>
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

								borc_toplam = 0;
								alacak_toplam = 0;
							</cfscript>

							<cfloop from = "1" to = "#get_blocks.recordcount#" index = "b">
								<cfquery name = "get_block" dbtype = "query">
									SELECT * FROM get_wizard WHERE WIZARD_BLOCK_ID = #get_blocks.wizard_block_id[b]# ORDER BY BLOCK_COLUMN
								</cfquery>

								<cfset total_block1_borc = 0>
								<cfset total_block1_alacak = 0>
								<cfset total_block3_borc = 0>
								<cfset total_block3_alacak = 0>

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
										<cfif get_block.block_ba eq 0>
											<cfif get_balance.acc_balance gt 0>
												<cfset acc_balance = get_balance.acc_balance>
											<cfelse>
												<cfset acc_balance = 0>
											</cfif>
										<cfelse>
											<cfif get_balance.acc_balance lt 0>
												<cfset acc_balance = -1 * get_balance.acc_balance>
											<cfelse>
												<cfset acc_balance = 0>
											</cfif>
										</cfif>
									<cfelse>
										<cfset acc_balance = 0>
									</cfif>
									<cfscript>
										switch(block_column) {
											case 1 :
												this_borc = acc_balance * (rate/100) * block_ba;
												this_alacak = acc_balance * (rate/100) * (1 - block_ba);

												total_block1_borc = total_block1_borc + this_borc;
												total_block1_alacak = total_block1_alacak + this_alacak;
											break;

											case 2 :
												this_borc = total_block1_alacak * (rate/100);
												this_alacak = total_block1_borc * (rate/100);
											break;

											case 3 :
												this_borc = total_block1_alacak * (rate/100);
												this_alacak = total_block1_borc * (rate/100);

												total_block3_borc = total_block3_borc + this_borc;
												total_block3_alacak = total_block3_alacak + this_alacak;
											break;

											case 4 :
												this_borc = total_block3_alacak * (rate/100);
												this_alacak = total_block3_borc * (rate/100);
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
											borc_tutar_list = listAppend(borc_tutar_list, this_borc);
											borc_hesap_list = listAppend(borc_hesap_list, account_code);
											fis_satir_detay[1][arrayLen(fis_satir_detay[1]) + 1] = '#block_name# - #description#';

											borc_toplam = borc_toplam + this_borc;
										}
										
										if(this_alacak gt 0) {
											alacak_tutar_list = listAppend(alacak_tutar_list, this_alacak);
											alacak_hesap_list = listAppend(alacak_hesap_list, account_code);
											fis_satir_detay[2][arrayLen(fis_satir_detay[2]) + 1] = '#block_name# - #description#';

											alacak_toplam = alacak_toplam + this_alacak;
										}
									</cfscript>

									<cfif this_borc gt 0 or this_alacak gt 0>
										<tr>
											<td>
												<cfif this_borc gt 0>
													#account_code#
												</cfif>
											</td>
											<td>
												<cfif this_alacak gt 0>
													#account_code#
												</cfif>
											</td>
											<td style = "text-align:right;">
												<cfif this_borc gt 0>
													#TLFormat(this_borc)# #session.ep.money#
												</cfif>
											</td>
											<td style = "text-align:right;">
												<cfif this_alacak gt 0>
													#TLFormat(this_alacak)# #session.ep.money#
												</cfif>
											</td>
										</tr>
									</cfif>
								</cfoutput>
							</cfloop>
						<cfelse>

						</cfif>
					</tbody>
					<tfoot>
						<cfif isDefined('attributes.run_submitted') and attributes.run_submitted eq 1>
							<tr>
								<cfoutput>
									<td colspan = "2" style = "text-align:right;"><strong>Toplam : </strong></td>
									<td style = "text-align:right;"><strong>#TLFormat(borc_toplam)# #session.ep.money#</strong></td>
									<td style = "text-align:right;"><strong>#TLFormat(alacak_toplam)# #session.ep.money#</strong></td>
								</cfoutput>
							</tr>
							<cfif isDefined('attributes.save_submitted') and attributes.save_submitted eq 1>
								<cfscript>
									round_amount = borc_toplam - alacak_toplam;
									if(get_block.block_ba eq 1) {
										alacak_tutar_list = listSetAt(alacak_tutar_list, listLen(alacak_tutar_list), listLast(alacak_tutar_list) + round_amount);
									} else {
										borc_tutar_list = listSetAt(borc_tutar_list, listLen(borc_tutar_list), listLast(borc_tutar_list) - round_amount);
									}
									card_id = muhasebeci(
										action_id : 0,
										workcube_process_type : 13,
										account_card_type : 13,
										islem_tarihi : attributes.finish_date,
										borc_hesaplar : borc_hesap_list,
										borc_tutarlar : borc_tutar_list,
										alacak_hesaplar : alacak_hesap_list,
										alacak_tutarlar : alacak_tutar_list,
										fis_detay : "#dateformat(attributes.start_date,'dd/mm/yyyy')# - #dateformat(attributes.finish_date,'dd/mm/yyyy')# #get_wizard.wizard_name# <cf_get_lang dictionary_id='64398.işlemi'>.",
										fis_satir_detay : fis_satir_detay
									);
								</cfscript>
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
										window.location.href = "<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&event=run&wizard_id=#get_wizard.wizard_id#</cfoutput>";
									</script>
								</cfif>
							</cfif>
						</cfif>
					</tfoot>
				</cf_grid_list>
			</div>
		</cf_box>
	</div>
<cfelse>
	<cf_catalystHeader>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box title="#getLang('','','30404')#">
				<cfform name="add_wizard" id="add_wizard" method="post">
					<input type="hidden" name="wizard_id" id="wizard_id" value="" maxlength="25">
					<div class="row">
						<div class="col col-12 uniqueRow">
							<div class="row formContent">
								<cf_box_elements>
									<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
										<div class="form-group" id="item-wizard_name">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='60726.Sihirbaz'><cf_get_lang dictionary_id='57897.Adı'></label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<input type="text" name="wizard_name" id="wizard_name" value="" maxlength="50">
											</div>
										</div>
										<div class="form-group" id="item-wizard_designer">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55065.Tasarlayan'></label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="employee_id" id="employee_id" value="">
													<input type="text" name="employee_name" id="employee_name"  onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" value="" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_wizard.employee_id&field_name=add_wizard.employee_name&select_list=1');"></span>
												</div>
											</div>
										</div>
									</div>
									<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
										<div class="form-group" id="item-wizard_stage">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<cf_workcube_process slct_width="180px;" is_upd = "0" is_detail = "0">
											</div>
										</div>
										<div class="form-group" id="item-process_date">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29792.Tasarım'> <cf_get_lang dictionary_id='58593.Tarihi'></label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang_main no='59.Eksik Veri'>:<cf_get_lang_main no='330.Tarih'>!</cfsavecontent>
													<cfinput type="text" name="process_date" maxlength="10" required="Yes" message="#message#" validate="#validate_style#" onblur="change_money_info('add_wizard','process_date');">
													<span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
												</div>
											</div>
										</div>
									</div>
									<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
										<div class="form-group" id="item-run_period">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63096.Çalışma Periyodu'></label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<div class="input-group col-12">
													<select name = "run_period" id = "run_period">
														<option value = "0"><cf_get_lang dictionary_id='58500.Manuel'></option>
														<option value = "1"><cf_get_lang dictionary_id='58724.Ay'></option>
														<option value = "3">3 <cf_get_lang dictionary_id='58724.Ay'></option>
														<option value = "6">6 <cf_get_lang dictionary_id='58724.Ay'></option>
														<option value = "12">12 <cf_get_lang dictionary_id='58724.Ay'></option>
													</select>
												</div>
											</div>
										</div>
										<div class="form-group" id="item-period_day">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> <cf_get_lang dictionary_id='53477.Günü'></label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<div class="input-group col-12">
													<input type="number" name="period_day" id="period_day">
												</div>
											</div>
										</div>
									</div>
									<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
										<!--- <cfquery name = "getProcessCat" datasource = "#dsn3#">
											SELECT PROCESS_CAT_ID, PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 13
										</cfquery> --->
										<div class="form-group" id="item-process_cat">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'>*</label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<cf_workcube_process_cat slct_width="180px;">
											</div>
										</div>
										<div class="form-group" id="item-target_type">
											<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57951.Hedef'> <cf_get_lang dictionary_id='38752.Tablo'></label>
											<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
												<div class="input-group col-12">
													<select name = "target_type" id = "target_type">
														<option value = ""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
														<option value = "0"><cf_get_lang dictionary_id='58793.Tek Düzen'></option>
														<option value = "1">IFRS</option>
														<option value = "2"><cf_get_lang dictionary_id='63097.Birleşik'></option>
													</select>
												</div>
											</div>
										</div>
									</div>
								</cf_box_elements>
								<div class="row">
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
										<div class="ui-card">
											<input type="hidden" name="rowCount" id="rowCount" value="0">
											<div class="ui-card-add-btn"><a href="javascript://" onClick="addRow();"><i class="icon-pluss" alt="<cf_get_lang_main no='295.Satır Ekle'>" title="<cf_get_lang_main no='295.Satır Ekle'>"></i></a></div>
											<!--- <table>
												
												<thead>
													<tr>
														<cfset colspan_ = 8>
														<th><cf_get_lang_main no='75.No'></th>
														<th>Blok Adı</th>
														<th>Blok Tipi</th>
														<th>Blok Detay</th>
													</tr>
												</thead>
												<tbody id="table_list">
												</tbody>
											</table> --->
											<div id="table_list">

											</div>
										</div>
									</div>
								</div>
								<cf_box_footer>
									<cfif attributes.event eq 'upd'>
										<div class = "col col-4"><cf_record_info query_name="get_wizard"></div>
										<div class = "col col-8"><cf_workcube_buttons is_upd='1' add_function="kontrol()" delete_page_url = "#request.self#?fuseaction=#attributes.fuseaction#&event=del&wizard_id=#attributes.wizard_id#"></div>
									<cfelse>
										<div class="col col-12"><cf_workcube_buttons is_upd='0' add_function="kontrol()"></div>
									</cfif>
								</cf_box_footer>
							
				</cfform>
			</cf_box>
		</div>
	<script type="text/javascript">
		$( document ).ready(function() {
			<cfif isDefined('getJSON')>
				getJSON = <cfoutput>#getJSON#</cfoutput>;
				processedBlocks = [];
				processedRows = [];
				
				$.each(getJSON, function( index, value ) {
					if(index == 0) { // İlk gelenden wizard alanlarını doldurucaz.
						$("#wizard_id").val(value.WIZARD_ID);
						$("#wizard_name").val(value.WIZARD_NAME);
						$("#employee_id").val(value.WIZARD_DESIGNER);
						$("#employee_name").val(value.EMPLOYEE_FULLNAME);
						$("#process_stage").val(value.WIZARD_STAGE);
						$("#process_date").val(value.WIZARD_DATE);
						$("#run_period").val(value.PERIOD_MONTH);
						$("#period_day").val(value.PERIOD_DAY);
						$("#target_type").val(value.TARGET_TYPE);
						$("#process_cat").val(value.CARD_PROCESS_CAT);
					}
					if($.inArray(value.WIZARD_BLOCK_ID,processedBlocks) == -1) { // İlk gelenden blok alanlarını dolduruyoruz.
						processedBlocks.push(value.WIZARD_BLOCK_ID);

						addRow();
						$("#block_name_" + $("#rowCount").val()).val(value.BLOCK_NAME);
						$("#block_type_" + $("#rowCount").val()).val(value.BLOCK_BA);
					}
					if($.inArray(value.WIZARD_BLOCK_ROW_ID,processedRows) == -1) { // İlk gelenden row alanlarını dolduruyoruz.
						processedRows.push(value.WIZARD_BLOCK_ROW_ID);

						addAccount($("#rowCount").val(),value.BLOCK_COLUMN);
						acc_input = $("#acc_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
						rate_input = $("#rate_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
						desc_input = $("#desc_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
						action_type_input_hidden = $("#action_type_hidden_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());
						action_type_input = $("#action_type_" + $("#rowCount").val() + '_' + value.BLOCK_COLUMN + '_' + $("#counter_" + $("#rowCount").val() + "_" + value.BLOCK_COLUMN).val());

						acc_input.val(value.ACCOUNT_CODE);
						rate_input.val(value.RATE);
						desc_input.val(value.DESCRIPTION);
						action_type_input_hidden.val(value.ACTION_TYPE);
						if( action_type_input_hidden.val().length > 0 ){
							var tut = action_type_input_hidden.val().split(",");
							action_type_input.val( tut.length );
						}
					}
				});
			</cfif>
		});
		rowCount = 0;

		function kontrol()
		{
			if($("#wizard_name").val() == '') {
				alert('<cf_get_lang dictionary_id='63109.Sihirbaz ismi giriniz'>!');
				return false;
			}
			if($("#employee_id").val() == '' || $("#employee_name").val() == '') {
				alert('<cf_get_lang dictionary_id='58194.Zorunlu Alan'> <cf_get_lang dictionary_id='55065.Tasarlayan'>');
				return false;
			}
			if($("#process_date").val() == '') {
				alert('<cf_get_lang dictionary_id='61893.Tarih Giriniz'>!');
				return false;
			}
			if(parseInt($("#rowCount").val()) == 0) {
				alert('<cf_get_lang dictionary_id='63110.Lütfen Blok Ekleyiniz'>!');
				return false;
			} else {
				for( i = 1; i <= parseInt($("#rowCount").val()); i++ ) {
					if($("#row_kontrol_" + i).val() == 1) {
						rowNum = i;

						accNum1 = parseInt($('#counter_' + rowNum + '_1').val());
						accNum2 = parseInt($('#counter_' + rowNum + '_2').val());
						accNum3 = parseInt($('#counter_' + rowNum + '_3').val());
						accNum4 = parseInt($('#counter_' + rowNum + '_4').val());

						for( j = 1; j <= 4; j++ ) {
							for(k = 1; k <= eval('accNum' + j); k++ ) {
								if($('#acc_control_' + rowNum + '_' + j + '_' + k).val() == 0) {
									$('#counter_' + rowNum + '_' + j).val(parseInt($('#counter_' + rowNum + '_' + j).val()) - 1);
								}
							}
						}

						if(accNum1 == 0 || accNum2 == 0) {
							alert('<cf_get_lang dictionary_id='63105.1. ve 2. blokları boş bırakmayınız'>!');
							return false;
						}

						if((accNum3 != 0 && accNum4 == 0) || (accNum3 == 0 && accNum4 != 0)) {
							alert('<cf_get_lang dictionary_id='63104.Üçüncü ve dördüncü bloklar birlikte tanımlanmalıdır'>!');
							return false;
						}


						for( j = 1; j <= 4; j++ ) {
							colNum = j;

							columnTotal = 0;
							for(k = 1; k <= eval('accNum' + j); k++ ) {
								if($('#acc_control_' + rowNum + '_' + j + '_' + k).val() == 1) {
									if($('#acc_' + rowNum + '_' + colNum + '_' + k).val() == '') {
										alert('<cf_get_lang dictionary_id='63106.Muhasebe Kodu alanlarını boş bırakmayınız'>!');
										return false;
									}
									columnTotal = columnTotal + toFloat($('#rate_' + rowNum + '_' + colNum + '_' + k).val());
								}
							}
							if(colNum % 2 == 0) { // 2. ve 4. kolonlarda rate toplamı %100 olmalı.
								if(columnTotal != 100 && (colNum == 2 || (accNum3 != 0 && accNum4 != 0))) {
									alert('<cf_get_lang dictionary_id='63107.Blokların ikinci ve dördüncü kolonlarındaki dağılım %100 e eşit olmalıdır'>! ' + colNum + '. <cf_get_lang dictionary_id='63108.Kolon Toplam'> : ' + columnTotal);
									return false;
								}
							}
						}
					}
				}
			}
			return true;
		}
		function addRow()
		{
			rowCount++;
			add_wizard.rowCount.value = rowCount;
			var newRow;
			var newCell;
			newRow = $('<div />');
			newRow.attr({"id":"block_row_" + rowCount,"class":"ui-card-item"});
			newCell = '<input type = "hidden" id = "row_kontrol_' + rowCount + '" name = "row_kontrol_' + rowCount + '" value = "1"><div class="ui-card-item-hide"><a href="javascript://" onClick="delRow(' + rowCount + ');"><i class="icon-minus" alt="<cf_get_lang_main no ='286.Sıfırla'>"></i></a></div>';
			newRow.append(newCell);
			newCell = '<div class="col col-12 col-xs-12 acc-top">'+
			'<div class="acc-count">'+rowCount+'</div>'+
			'<div class="acc-block-name"><input type="text" name="block_name_' + rowCount + '" id="block_name_' + rowCount + '"></div>'+
			'<div class="acc-block-type"><select name="block_type_' + rowCount + '" id="block_type_' + rowCount + '"><option value = "0">Borç</option><option value = "1">Alacak</option></select></div>'+
			'</div>';
			newRow.append(newCell);
			newCell = '<div class="acc-body" id = "block_detail_' + rowCount + '"></div>';
			newRow.append(newCell);
			$('#table_list').append(newRow);
			createBlock(rowCount);
		}

		function delRow(block_id) {
			$("#row_kontrol_" + block_id).val(0);
			$("#block_row_" + block_id).hide();
		}

		function pencere_ac(acc_input) {
			fuseaction = 'popup_account_plan';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.' + fuseaction + '&field_id=add_wizard.' + acc_input, 'list');
		}

		function open_modal(rowNum, colNum, accNum) {
			account_code = $("#acc_"+ rowNum + '_' + colNum + '_' + accNum).val();
			if(account_code != '') cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=account.wizardActionType&type_id='+rowNum+'_'+colNum+'_'+accNum+'&account_id='+account_code,'warning_modal');
			else alert("<cf_get_lang dictionary_id='47351.Hesap Kodu Seçin'>"); return false;
		}

		function delAcc(row,col,acc) {
			$('#acc_control_' + row + '_' + col + '_' + acc).val(0);
			$('#div_' + row + '_' + col + '_' + acc).hide();
		}

		function addAccount(rowNum, colNum) {
			accNum = parseInt($('#counter_' + rowNum + '_' + colNum).val()) + 1;

			acc_div = $("<div />");
			acc_div.attr('class','acc-body-item');
			acc_div.attr('id','div_' + rowNum + '_' + colNum + '_' + accNum);

			//4

			acc_form_grp4 = $("<div />");
			acc_form_grp4.attr('class','form-group pa col col-1');
			acc_form_grp4.appendTo(acc_div);

			acc_inpt_grp4 = $("<div />");
			acc_inpt_grp4.attr('class','input-group');
			acc_inpt_grp4.appendTo(acc_form_grp4);

			acc_del = $("<a />");
			acc_del.attr("onClick","delAcc(" + rowNum + "," + colNum + "," + accNum + ")");
			acc_del.append('<i class="icon-minus"></i>');
			acc_del.appendTo(acc_inpt_grp4);

			//1
			
			acc_form_grp = $("<div />");
			acc_form_grp.attr('class','form-group col col-3');
			acc_form_grp.appendTo(acc_div);

			acc_inpt_grp = $("<div />");
			acc_inpt_grp.attr('class','input-group');
			acc_inpt_grp.appendTo(acc_form_grp);
			
			acc_inpt_grp.append('<input type = "hidden" id = "acc_control_' + rowNum + '_' + colNum + '_' + accNum + '" name = "acc_control_' + rowNum + '_' + colNum + '_' + accNum + '" value = "1">');

			acc_input = $("<input />").attr('id','acc_' + rowNum + '_' + colNum + '_' + accNum);
			acc_input.attr('name','acc_' + rowNum + '_' + colNum + '_' + accNum);
			acc_input.attr('readonly',true);
			acc_input.attr('type','text');
			acc_input.appendTo(acc_inpt_grp);

			acc_selector= $("<span />");
			acc_selector.attr('class','input-group-addon btnPointer icon-ellipsis');
			acc_selector.attr('onClick','pencere_ac("acc_' + rowNum + '_' + colNum + '_' + accNum + '");');
			acc_selector.appendTo(acc_inpt_grp);


			// 5

			acc_action_grp = $("<div />");
			acc_action_grp.attr('class','form-group col col-3');
			acc_action_grp.appendTo(acc_div);

			action_inpt_grp = $("<div />");
			action_inpt_grp.attr('class','input-group');
			action_inpt_grp.appendTo(acc_action_grp);

			action_box = $("<input />").attr('id','action_type_' + rowNum + '_' + colNum + '_' + accNum);
			action_box.attr('name','action_type_' + rowNum + '_' + colNum + '_' + accNum);
			action_box.attr('type','text');
			action_box.attr('title','İşlem Tipi Seçin');
			action_box.attr('readonly',true);

			action_box_hidden = $("<input />").attr('id','action_type_hidden_' + rowNum + '_' + colNum + '_' + accNum);
			action_box_hidden.attr('name','action_type_hidden_' + rowNum + '_' + colNum + '_' + accNum);
			action_box_hidden.attr('type','hidden');
			action_box_hidden.attr('readonly',true);

			action_box_hidden.appendTo(action_inpt_grp);
			action_box.appendTo(action_inpt_grp);
			

			action_box_selector2= $("<span />");
			action_box_selector2.attr('class','input-group-addon btnPointer');
			action_box_selector2.attr('onclick','open_modal('+rowNum+', '+colNum+', '+accNum+');');
			action_box_selector2.append('<i class="fa fa-plug" title="İşlem Tipi Seç"></i>');
			action_box_selector2.appendTo(action_inpt_grp);

			//2

			acc_form_grp2 = $("<div />");
			acc_form_grp2.attr('class','form-group col col-2');
			acc_form_grp2.appendTo(acc_div);

			acc_inpt_grp2 = $("<div />");
			acc_inpt_grp2.attr('class','input-group');
			acc_inpt_grp2.appendTo(acc_form_grp2);

			rate_box = $("<input />").attr('id','rate_' + rowNum + '_' + colNum + '_' + accNum);
			rate_box.attr('name','rate_' + rowNum + '_' + colNum + '_' + accNum);
			rate_box.attr('type','number');
			rate_box.attr('value','0');
			//rate_box.attr('style','width:40px!important');
			rate_box.appendTo(acc_inpt_grp2);

			acc_selector2= $("<span />");
			acc_selector2.attr('class','input-group-addon');
			acc_selector2.append('<strong>%</strong>');
			acc_selector2.appendTo(acc_inpt_grp2);

			//3

			acc_form_grp3 = $("<div />");
			acc_form_grp3.attr('class','form-group col col-3');
			acc_form_grp3.appendTo(acc_div);

			acc_inpt_grp3 = $("<div />");
			acc_inpt_grp3.attr('class','input-group');
			acc_inpt_grp3.appendTo(acc_form_grp3);

			desc_box = $("<input />").attr('id','desc_' + rowNum + '_' + colNum + '_' + accNum);
			desc_box.attr('name','desc_' + rowNum + '_' + colNum + '_' + accNum);
			desc_box.attr('type','text');
			//desc_box.attr('style','width:80px!important');
			desc_box.appendTo(acc_form_grp3);

			acc_div.appendTo($("#detail_" + rowNum + "_" + colNum));

			$('#counter_' + rowNum + '_' + colNum).val(parseInt($('#counter_' + rowNum + '_' + colNum).val()) + 1);
		}

		function createBlock(row_number) {
			block = $("#block_detail_" + row_number);

			for( i = 1; i <= 4; i++) {
				blockDetailColumn = $("<div />");
				if(i == 2 || i == 4){
					blockDetailColumn.attr('class','col col-12 col-md-12 col-sm-12 col-xs-12');
				}
				else{
					blockDetailColumn.attr('class','col col-11 col-md-11 col-sm-11 col-xs-12');
				}
				//blockDetailColumn.attr('style','border:solid;height:200px;');
				blockDetailColumn.attr('id','detail_' + i + '_' + row_number);
				if(i == 2){
					lineArrow = $("<div />");
					lineArrow.attr('class','acc-flex col col-12 col-md-12 col-xs-12');
					lineArrow.append('<i class="icon-chevron-down"></i>');
					lineArrow.appendTo(blockDetailColumn)
				}
				flag = $("<div />");
				flag.attr('class','acc-flex col col-6 col-md-6 col-xs-12');
				

				arrow = $("<div />");
				if(i == 2){
					arrow.attr('class','col col-12 col-xs-12 flag-arrow');
				}
				else{
					arrow.attr('class','col col-1 col-xs-12 flag-arrow');
				}
				
				header = $("<div />").attr('class','acc-body-title');

				plus = $("<a href='javascript:void(0)'>");
				plus.append('<i class="icon-pluss"></i>');
				plus.attr('onClick','addAccount(' + row_number + ', ' + i + ')');
				blockDetailColumn.attr('id','detail_' + row_number + '_' + i);
				plus.appendTo(header);

				switch(i) {
					case 1:
						header.append('<strong><cf_get_lang dictionary_id='48702.Hesaptan'></strong>');
						arrow.append('<span>=</span>');
					break;
					case 2:
						header.append('<strong><cf_get_lang dictionary_id='48703.Hesaba'></strong>');
						arrow.append('<i class="icon-down"></i>');
					break;
					case 3:
						header.append('<strong><cf_get_lang dictionary_id='64399.Oranla'></strong>');
						arrow.append('<span>=</span>');
					break;
					case 4:
						header.append('<strong><cf_get_lang dictionary_id='48778.Karşılık'></strong>');
					break;
				}

				blockCount = $("<input />").attr('id','counter_' + row_number + '_' + i);
				blockCount.attr('name','counter_' + row_number + '_' + i);
				blockCount.attr('type','hidden');
				blockCount.attr('value', 0);
				blockCount.appendTo(header);

				flag.appendTo(block);
				header.appendTo(blockDetailColumn);

				blockDetailColumn.appendTo(flag);
				arrow.appendTo(flag);
				if(i == 2){
					arrow.insertAfter(flag)
				}
			}
		}

		function toFloat(num) {
			dotPos = num.indexOf('.');
			commaPos = num.indexOf(',');

			if (dotPos < 0)
				dotPos = 0;

			if (commaPos < 0)
				commaPos = 0;

			if ((dotPos > commaPos) && dotPos)
				sep = dotPos;
			else {
				if ((commaPos > dotPos) && commaPos)
					sep = commaPos;
				else
					sep = false;
			}

			if (sep == false)
				return parseFloat(num.replace(/[^\d]/g, ""));

			return parseFloat(
				num.substr(0, sep).replace(/[^\d]/g, "") + '.' + 
				num.substr(sep+1, num.length).replace(/[^0-9]/, "")
			);

		}


	</script>
</cfif>