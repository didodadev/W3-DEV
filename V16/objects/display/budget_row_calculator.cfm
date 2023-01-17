<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY ORDER BY MONEY_ID
</cfquery>
<cfquery name="get_expense_center" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="get_activity_types" datasource="#dsn#">
	SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>
<cfquery name="get_workgroups" datasource="#dsn#">
	SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY HIERARCHY
</cfquery>

<cf_box id="wizard_box" title="#getLang('','Planlama Sihirbazı',59935)#" draggable="1" closable="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_budget_wizard">
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
				<div class="form-group" id="item-wizard_action_value">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58123.Planlama"><cf_get_lang dictionary_id="54452.Tutarı"></label>
					<div class="col col-5 col-xs-12">
						<cfinput type="text" name="wizard_action_value" value = "#TLFormat(0)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,2,'float'));">
					</div>
					<div class="col col-3 col-xs-12">
						<select id = "wizard_currency" name = "wizard_currency">
							<cfoutput query = "get_money">
								<option value = "#money#">#money#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-wizard_start_date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57655.Başlama Tarihi"></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput name="wizard_start_date" id="wizard_start_date" type="text" value="#dateformat(now(),dateformat_style)#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="wizard_start_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-installment">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="31581.Taksit"></label>
					<div class="col col-8 col-xs-12">
						<cfinput name="installment" id="installment" type="number" value="1">
					</div>
				</div>
				<div class="form-group" id="item-wizard_count">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="42674.Periyot"></label>
					<div class="col col-4 col-xs-12">
						<cfinput name="wizard_count" id="wizard_count" type="number" value="1">
					</div>
					<div class="col col-4 col-xs-12">
						<select id = "period_type" name = "period_type">
							<option value = "month"><cf_get_lang dictionary_id="58724.Ay"></option>
							<option value = "day"><cf_get_lang dictionary_id="57490.Gün"></option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12 control-label padding-left-0 padding-right-0"><cf_get_lang dictionary_id="29818.İş Grupları"></label>
					<div class="col col-8 col-xs-12 padding-right-0">
						<select name="wizard_workgroup" id="wizard_workgroup">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="get_workgroups">
								<cfoutput><option value="#workgroup_id#">#workgroup_name#</option></cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-wizard_asset_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58833.Fiziki Varlık"></label>
					<div class="col col-8 col-xs-12">
						<cf_wrkAssetp asset_id="" fieldId='wizard_asset_id' fieldName='wizard_asset_name' form_name='add_budget_wizard'>
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
				<div class="form-group" id="item-wizard_expense_center">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59936.Bütçe Merkezi"></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="wizard_expense_center_id" id="wizard_expense_center_id" value="">
							<cfinput type="text" name="wizard_expense_center" value="">
							<span class="input-group-addon icon-ellipsis" onClick="open_exp_center();"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-wizard_activity_type">
					<label class="col col-4 col-xs-12 control-label padding-left-0 padding-right-0"><cf_get_lang dictionary_id='49184.Aktivite Tipi'></label>
					<div class="col col-8 col-xs-12 padding-right-0">
						<select name="wizard_activity_type" id="wizard_activity_type">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="get_activity_types">
								<cfoutput><option value="#activity_id#">#activity_name#</option></cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-wizard_project_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfoutput>
								<input type="hidden"  name="wizard_project_id" id="wizard_project_id"  value="" />
								<input type="text" name="wizard_project_head" id="wizard_project_head" value="" onFocus="AutoComplete_Create('wizard_project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','wizard_project_head','add_budget_wizard','3','135')" autocomplete="off" />
							</cfoutput>
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_budget_wizard.wizard_project_id&project_head=add_budget_wizard.wizard_project_head');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-bol_ve_dagit">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58930.Expense'></label>
					<div class="col col-8 col-xs-12">
						<select name = "income_expense" id = "income_expense">
							<option value = "0"><cf_get_lang dictionary_id='58677.Gelir'></option>
							<option value = "1"><cf_get_lang dictionary_id='58678.Gider'></option>
						</select>
					</div>					
				</div>	
				<div class="form-group" id="item-wizard_month_expense_item">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59937.Gelecek Aylara Ait Bütçe Kalemi'></label>
					<div class="col col-4 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="wizard_month_expense_item_id" id="wizard_month_expense_item_id" value="">
							<cfinput type="text" name="wizard_month_expense_item_name" value="">
							<span class="input-group-addon icon-ellipsis" onClick="open_exp_item('1');" title=""></span>
						</div>
					</div>
					<div class="col col-4 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="wizard_month_account_id" id="wizard_month_account_id" value="">
							<input type="text" name="wizard_month_account_code" id="wizard_month_account_code" onFocus="AutoComplete_Create('wizard_month_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE','wizard_month_account_id','','3','225');">
							<span class="input-group-addon icon-ellipsis" onClick="open_acc_code('1');" title=""></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-wizard_year_expense_item">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59938.Gelecek Yıllara Ait Bütçe Kalemi'></label>
					<div class="col col-4 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="wizard_year_expense_item_id" id="wizard_year_expense_item_id" value="">
							<cfinput type="text" name="wizard_year_expense_item_name" value="">
							<span class="input-group-addon icon-ellipsis" onClick="open_exp_item('2');" title=""></span>
						</div>
					</div>
					<div class="col col-4 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="wizard_year_account_id" id="wizard_year_account_id" value="">
							<input type="text" name="wizard_year_account_code" id="wizard_year_account_code" onFocus="AutoComplete_Create('wizard_year_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE','wizard_year_account_id','','3','225');">
							<span class="input-group-addon icon-ellipsis" onClick="open_acc_code('2');" title=""></span>
						</div>
					</div>
				</div>							
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cfsavecontent  variable="button_name">
				<cf_get_lang dictionary_id="59939.Böl ve Dağıt">
			</cfsavecontent>
			<cfsavecontent  variable="message">
				<cf_get_lang dictionary_id="59951.Mevcut satırlar silinecek.Onaylıyor musunuz?">
			</cfsavecontent>
			<!---<input type="button" name="bol_ve_dagit" id="bol_ve_dagit" value="Böl ve Dağıt" onClick="bol_ve_dagit_function();">--->
			<cf_workcube_buttons add_function='bol_ve_dagit_function()' is_upd='0' insert_info='#button_name#'  insert_alert='#message#'>
		</cf_box_footer>
	</cfform>
</cf_box>

<script type = "text/javascript">
	var wizard_type = '<cfoutput>#url.type#</cfoutput>';

	$( document ).ready(function() {
		switch(wizard_type) {
			case 'budget_plan' :

			break;
			case 'expense' :
				$("#income_expense").val(1);
				$("#income_expense").attr('disabled',true);
			break;
			case 'income' :
				$("#income_expense").val(0);
				$("#income_expense").attr('disabled',true);
			break;
			case 'invoice_expense' :
				$("#income_expense").val(1);
				$("#income_expense").attr('disabled',true);

				$("#wizard_action_value").val($("#grosstotal").val());
				$("#wizard_start_date").val($("#expense_date").val());
			break;
			case 'invoice_income' :
				$("#income_expense").val(0);
				$("#income_expense").attr('disabled',true);

				$("#wizard_action_value").val($("#grosstotal").val());
				$("#wizard_start_date").val($("#expense_date").val());
			break;
			default :

			break;
		}
	});

	function formatMoney(number, decPlaces, decSep, thouSep) {
		decPlaces = isNaN(decPlaces = Math.abs(decPlaces)) ? 2 : decPlaces,
		decSep = typeof decSep === "undefined" ? "," : decSep;
		thouSep = typeof thouSep === "undefined" ? "." : thouSep;
		var sign = number < 0 ? "-" : "";
		var i = String(parseInt(number = Math.abs(Number(number) || 0).toFixed(decPlaces)));
		var j = (j = i.length) > 3 ? j % 3 : 0;

		return sign +
		(j ? i.substr(0, j) + thouSep : "") +
		i.substr(j).replace(/(\decSep{3})(?=\decSep)/g, "$1" + thouSep) +
		(decPlaces ? decSep + Math.abs(number - i).toFixed(decPlaces).slice(2) : "");
	}

	function addDays(date, days) {
		var result = new Date(date);
		result.setDate(result.getDate() + days);
		return result;
	}

	function bol_ve_dagit_function() {
		existing_rows = parseInt($("#record_num").val());

		for(i = 1; i <= existing_rows; i++ ) {

			switch(wizard_type) {
				case 'budget_plan' :
					if($("#row_kontrol" + i).val() == 1) {
						sil(i);
					}
				break;
				case 'expense' :
					if($("#row_kontrol" + i).val() == 1) {
						sil(i);
					}
				break;
				case 'income' :
					if($("#row_kontrol" + i).val() == 1) {
						sil(i);
					}
				break;
				case 'invoice_income' :
					if($("#row_kontrol" + i).val() == 1) {
						sil(i,'');
					}
				break;
				case 'invoice_expense' :
					if($("#row_kontrol" + i).val() == 1) {
						sil(i,'');
					}
				break;
				default :

				break;
			}
		}

		installment = parseInt($("#installment").val());

		if($("#income_expense").val() == 0) {
			toplam_gelir = parseFloat(filterNum($("#wizard_action_value").val()));
			toplam_gider = parseFloat(0);
		} else {
			toplam_gelir = parseFloat(0);
			toplam_gider = parseFloat(filterNum($("#wizard_action_value").val()));
		}

		existing_rows = parseInt($("#record_num").val());

		aylik_gelir = (toplam_gelir/installment).toFixed(2);
		gelir_taksit_toplam = aylik_gelir * installment;
		round_gelir = (toplam_gelir - gelir_taksit_toplam).toFixed(2);

		aylik_gider = (toplam_gider/installment).toFixed(2);
		gider_taksit_toplam = aylik_gider * installment;
		round_gider = (toplam_gider - gider_taksit_toplam).toFixed(2);

		var expense_day = parseInt($("#wizard_start_date").val().split("/")[0]);
		var expense_month = parseInt($("#wizard_start_date").val().split("/")[1]);
		var expense_year = parseInt($("#wizard_start_date").val().split("/")[2]);

		other_currency = $("#wizard_currency").val();

		var currency_multiplier = 0;
		for(i = 1; i <= parseInt($("#kur_say").val()); i++ ) {
			if($("#hidden_rd_money_" + i).val() == other_currency) {
				$("input[name=rd_money][value*='" + other_currency + "']").prop("checked",true);
				currency_multiplier = parseFloat(filterNum($("#txt_rate2_" + i).val(),8)) / parseFloat(filterNum($("#txt_rate1_" + i).val(),8));
			}
		}

		switch(wizard_type) {
			case 'budget_plan' :
				toplam_doviz_hesapla();
			break;
			case 'expense' :

			break;
			case 'income' :

			break;
			case 'invoice_income' :

			break;
			case 'invoice_expense' :

			break;
			default :

			break;
		}

		total_income = 0;
		total_income_other = 0;
		total_expense = 0;
		total_expense_other = 0;

		for(i = 1; i <= installment; i++ ) {

			this_expense_date = new Date(expense_year,expense_month - 1,expense_day);
			expense_date = this_expense_date.getDate() + '/' + parseInt(this_expense_date.getMonth() + 1) + '/' + this_expense_date.getFullYear();
			row_detail = i + '. ay plan satırı';
			expense_center_id = $("#wizard_expense_center_id").val();
			expense_center = $("#wizard_expense_center").val();
			expense_cat_id = '';
			expense_cat_name = '';

			if(expense_year == parseInt($("#wizard_start_date").val().split("/")[2])) {
				account_id = $("#wizard_month_account_id").val();
				account_code = $("#wizard_month_account_code").val();
				expense_item_id = $("#wizard_month_expense_item_id").val();
				expense_item_name = $("#wizard_month_expense_item_name").val();
			} else {
				account_id = $("#wizard_year_account_id").val();
				account_code = $("#wizard_year_account_code").val();
				expense_item_id = $("#wizard_year_expense_item_id").val();
				expense_item_name = $("#wizard_year_expense_item_name").val();
			}

			activity_type = $("#wizard_activity_type").val();
			workgroup_id = $("#wizard_workgroup").val();
			member_type = '';
			company_id = '';
			consumer_id = '';
			employee_id = '';
			authorized = '';
			project_id = $("#wizard_project_id").val();
			project_name = $("#wizard_project_head").val();
			diff_total = formatMoney(aylik_gelir - aylik_gider);

			if(i == installment) {
				aylik_gider = parseFloat(aylik_gider) + parseFloat(round_gider);
				aylik_gelir = parseFloat(aylik_gelir) + parseFloat(round_gelir);
			}

			income_total = formatMoney(aylik_gelir * currency_multiplier);
			expense_total = formatMoney(aylik_gider * currency_multiplier);
			other_income_total = formatMoney(aylik_gelir);
			other_expense_total = formatMoney(aylik_gider);
			other_diff_total = formatMoney(aylik_gelir - aylik_gider);

			assetp_id = $("#wizard_asset_id").val();
			assetp_name = $("#wizard_asset_name").val();

			switch(wizard_type) {
				case 'budget_plan' :
					add_row(expense_date,row_detail,expense_center_id,expense_item_id,expense_item_name,expense_cat_id,expense_cat_name,account_id,account_code,activity_type,workgroup_id,member_type,company_id,consumer_id,employee_id,authorized,project_id,project_name,income_total,expense_total,diff_total,other_income_total,other_expense_total,other_diff_total,assetp_id,assetp_name);
				break;
				case 'expense' :
					add_row(row_detail,expense_center,expense_center_id,expense_item_name,expense_item_id,project_id,project_name,'','','','','','','','','','','','',expense_total,0,0,0,other_currency,activity_type,'','','',assetp_id,assetp_name,account_code,expense_date,'','','','',0,1,0);
					hesapla('total',parseInt(existing_rows) + i);
				break;
				case 'income' :
					add_row(row_detail,expense_center,expense_center_id,expense_item_name,expense_item_id,project_id,project_name,'','','','','','','','','','','','',income_total,0,0,0,other_currency,activity_type,'','','',assetp_id,assetp_name,account_code,expense_date,'','','','',0,1,0);
					hesapla('total',parseInt(existing_rows) + i);
				break;
				case 'invoice_expense' :
					//expense_date,prefix,exp_center_id,exp_item_id,exp_act_id,exp_work_id,exp_member_type,exp_partner_id,exp_comp_id,exp_authorized,exp_comp_name,exp_asset_id,exp_asset_name,exp_pro_id,exp_pro_name,exp_rate,exp_amount,exp_subs_id,exp_subs_name
					add_row(expense_date,'',expense_center_id,expense_item_id,activity_type,workgroup_id,'','','','','',assetp_id,assetp_name,project_id,project_name,formatMoney(100/installment),income_total,'','');
					toplam_center('');
				break;
				case 'invoice_income' :
					//expense_date,prefix,exp_center_id,exp_item_id,exp_act_id,exp_work_id,exp_member_type,exp_partner_id,exp_comp_id,exp_authorized,exp_comp_name,exp_asset_id,exp_asset_name,exp_pro_id,exp_pro_name,exp_rate,exp_amount,exp_subs_id,exp_subs_name
					add_row(expense_date,'',expense_center_id,expense_item_id,activity_type,workgroup_id,'','','','','',assetp_id,assetp_name,project_id,project_name,formatMoney(100/installment),income_total,'','');
					toplam_center('');
				break;
				default :

				break;
			}

			wizard_count = parseInt($("#wizard_count").val());

			if($("#period_type").val() == 'month') { 
				expense_year = expense_year + Math.floor((expense_month + wizard_count)/12);
				expense_month = (expense_month + wizard_count) % 12;

				if(expense_month == 2) {
					if(expense_year % 4 == 0) {
						days_in_month = 29;
					} else {
						days_in_month = 28;
					}
				} else if($.inArray(expense_month,[4,6,9,11]) != -1) {
					days_in_month = 30;
				} else {
					days_in_month = 31;
				}

				if(days_in_month < expense_day) {
					expense_day = days_in_month;
				}
			} else if($("#period_type").val() == 'day') {
				expense_day = expense_day + wizard_count;
			}

		}
		<cfif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );<cfelse>$("#wizard_div").hide();</cfif>

		return false;
	}

	form_name = 'add_budget_wizard';

	function open_exp_center()
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=' + form_name + '.wizard_expense_center_id&field_name=' + form_name + '.wizard_expense_center','','ui-draggable-box-small');
	}
	function open_exp_item(sira)
	{
		if(sira == 1)
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=' + form_name + '.wizard_month_expense_item_id&field_name=' + form_name + '.wizard_month_expense_item_name&field_account_no=' + form_name + '.wizard_month_account_code&field_account_id=' + form_name + '.wizard_month_account_id');
		else if(sira == 2)
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=' + form_name + '.wizard_year_expense_item_id&field_name=' + form_name + '.wizard_year_expense_item_name&field_account_no=' + form_name + '.wizard_year_account_code&field_account_id=' + form_name + '.wizard_year_account_id');
	}
</script>