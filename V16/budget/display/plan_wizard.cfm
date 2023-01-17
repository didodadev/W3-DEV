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

<cf_box id="wizard_box" title="Planlama Sihirbazı" collapsable="0">
	<cfform name="add_budget_wizard">
		<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
		<div class="row">
			<div class="col col-6 col-xs-12">
				<div class="form-group" id="item-wizard_action_value">
					<label class="col col-4 col-xs-12">Planlama Tutarı</label>
					<div class="col col-5 col-xs-12">
						<cfinput type="text" name="wizard_action_value" value = "#TLFormat(0)#" class="moneybox" style="width:150px;" onkeyup="return(FormatCurrency(this,event,2,'float'));">
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
					<label class="col col-4 col-xs-12">Başlama Tarihi</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput name="wizard_start_date" id="wizard_start_date" type="text" value="#dateformat(now(),dateformat_style)#">
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="wizard_start_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-wizard_month_count">
					<label class="col col-4 col-xs-12">Ay Sayısı</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group" style="width:150px;">
							<cfinput name="wizard_month_count" id="wizard_month_count" type="number" value="1" style="width:100%;">
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12 control-label padding-left-0 padding-right-0">İş Grupları</label>
					<div class="col col-8 col-xs-12 padding-right-0">
						<select name="wizard_workgroup" id="wizard_workgroup" style="width:130px;">
							<option value="">Seçiniz</option>
							<cfloop query="get_workgroups">
								<cfoutput><option value="#workgroup_id#">#workgroup_name#</option></cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-wizard_asset_id">
					<label class="col col-4 col-xs-12">Fiziki Varlık</label>
					<div class="col col-8 col-xs-12">
						<cf_wrkAssetp asset_id="" fieldId='wizard_asset_id' fieldName='wizard_asset_name' form_name='add_budget_wizard'>
					</div>
				</div>
			</div>
			<div class="col col-6 col-xs-12">
				<div class="form-group" id="item-wizard_expense_center">
					<label class="col col-4 col-xs-12">Bütçe Merkezi</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="wizard_expense_center_id" id="wizard_expense_center_id" value="">
							<cfinput type="text" name="wizard_expense_center" value="" style="width:175px;">
							<span class="input-group-addon icon-ellipsis" onClick="open_exp_center();"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-wizard_activity_type">
					<label class="col col-4 col-xs-12 control-label padding-left-0 padding-right-0"><cf_get_lang dictionary_id='49184.Aktivite Tipi'></label>
					<div class="col col-8 col-xs-12 padding-right-0">
						<select name="wizard_activity_type" id="wizard_activity_type" style="width:130px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfloop query="get_activity_types">
								<cfoutput><option value="#activity_id#">#activity_name#</option></cfoutput>
							</cfloop>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-wizard_project_id">
					<label class="col col-4 col-xs-12"><cf_get_lang_main no='4.Proje'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfoutput>
								<input type="hidden"  name="wizard_project_id" id="wizard_project_id"  value="" />
								<input type="text" style="width:150px" name="wizard_project_head" id="wizard_project_head" value="" onFocus="AutoComplete_Create('wizard_project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','wizard_project_head','add_budget_wizard','3','135')" autocomplete="off" />
							</cfoutput>
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_budget_wizard.wizard_project_id&project_head=add_budget_wizard.wizard_project_head');"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-wizard_month_expense_item">
					<label class="col col-12 col-xs-12">Gelecek Aylara Ait Bütçe Kalemi</label>
					<div class="col col-12 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="wizard_month_expense_item_id" id="wizard_month_expense_item_id" value="">
							<cfinput type="text" name="wizard_month_expense_item_name" value="" style="width:175px;">
							<span class="input-group-addon icon-ellipsis" onClick="open_exp_item('1');" title=""></span>

							<input type="hidden" name="wizard_month_account_id" id="wizard_month_account_id" value="">
							<input type="text" name="wizard_month_account_code" id="wizard_month_account_code" onFocus="AutoComplete_Create('wizard_month_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE','wizard_month_account_id','','3','225');">
							<span class="input-group-addon icon-ellipsis" onClick="open_acc_code('1');" title=""></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-wizard_year_expense_item">
					<label class="col col-12 col-xs-12">Gelecek Yıllara Ait Bütçe Kalemi</label>
					<div class="col col-12 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="wizard_year_expense_item_id" id="wizard_year_expense_item_id" value="">
							<cfinput type="text" name="wizard_year_expense_item_name" value="" style="width:175px;">
							<span class="input-group-addon icon-ellipsis" onClick="open_exp_item('2');" title=""></span>

							<input type="hidden" name="wizard_year_account_id" id="wizard_year_account_id" value="">
							<input type="text" name="wizard_year_account_code" id="wizard_year_account_code" onFocus="AutoComplete_Create('wizard_year_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE','wizard_year_account_id','','3','225');">
							<span class="input-group-addon icon-ellipsis" onClick="open_acc_code('2');" title=""></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-bol_ve_dagit">
					<div class="col col-6 col-xs-12">
						<select name = "income_expense" id = "income_expense">
							<option value = "0">Gelir</option>
							<option value = "1">Gider</option>
						</select>
					</div>
					<div class="col col-6 col-xs-12">
						<div class="input-group">
							<input type="button" name="bol_ve_dagit" id="bol_ve_dagit" value="Böl ve Dağıt" onClick="bol_ve_dagit_function();">
						</div>
					</div>
				</div>
			</div>
		</div>
	</cfform>
</cf_box>