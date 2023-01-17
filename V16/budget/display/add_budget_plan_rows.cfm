<cfsetting showdebugoutput="no">
<cfquery name="get_cost_template" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		EXPENSE_PLANS_TEMPLATES 
	WHERE 
		TEMPLATE_ID IS NOT NULL 
		AND IS_ACTIVE = 1
	ORDER BY 
		TEMPLATE_NAME
</cfquery>
<cfquery name="get_money_rate" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfquery name="get_tax" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfquery name="get_expense_center" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE,HIERARCHY FROM EXPENSE_CENTER ORDER BY EXPENSE_CODE
</cfquery>
<cfquery name="get_activity_types" datasource="#dsn#">
	SELECT ACTIVITY_ID,ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>
<cfsavecontent variable="title_info"><cf_get_lang dictionary_id="34266.Masraf Dağılımı Yap"></cfsavecontent>
<cf_box id="add_budget_plan_rows" title="#title_info#" closable="1" draggable="1">
	<cf_box_elements>
		<div class="col col-12 col-xs-12">
			<div class="form-group">
				<label class="col col-5 col-xs-12 control-label padding-left-0 padding-right-0"><cf_get_lang dictionary_id='49147.Masraf/Gelir Şablonları'></label>
				<div class="col col-7 col-xs-12 padding-right-0">
					<select name="exp_template_id" id="exp_template_id" style="width:130px;" onchange="setButtonState()">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_cost_template">
							<option value="#template_id#">#template_name#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-5 col-xs-12 control-label padding-left-0 padding-right-0"><cf_get_lang dictionary_id='58235.Masraf/Gelir Merkezi'></label>
				<div class="col col-7 col-xs-12 padding-right-0">
					<cfset pre_expense_code = "">
					<select name="exp_center_id" id="exp_center_id" style="width:130px;" class="txt">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfloop query="get_expense_center">
							<cfoutput>
								<option value="#expense_id#" <cfif HIERARCHY eq 1>disabled</cfif>>
									<cfloop index="i" from="1" to="#listLen(expense_code,'.')#">
										<cfif listfirst(expense_code,'.') eq pre_expense_code>&nbsp;</cfif>
									</cfloop>
									#EXPENSE#
								</option>
								<cfset pre_expense_code=listfirst(expense_code,'.')>
							</cfoutput>
						</cfloop>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-5 col-xs-12 control-label padding-left-0 padding-right-0"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></label>
				<div class="col col-7 col-xs-12 padding-right-0">
					<div class="input-group">
						<input type="hidden" name="exp_account_id" id="exp_account_id" value="">
						<input type="hidden" name="exp_account_code" id="exp_account_code" value="" onFocus="AutoComplete_Create('exp_account_code','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE','exp_account_id','','3','225');" autocomplete="off">
						<input type="hidden" name="exp_cat_id" id="exp_cat_id" value="">
						<input type="hidden" name="exp_cat_name" id="exp_cat_name" value="">
						<input type="hidden" name="exp_item_id" id="exp_item_id" value="">
						<input type="text" name="exp_item_name" id="exp_item_name"  value="" style="width:130px;" onFocus="AutoComplete_Create('exp_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE,EXPENSE_CAT_ID,EXPENSE_CAT_NAME','exp_item_id,exp_account_code,exp_cat_id,exp_cat_name','add_budget_plan_rows',1);" autocomplete="off">
						<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="pencere_ac_exp_box();"></span>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-5 col-xs-12 control-label padding-left-0 padding-right-0"><cf_get_lang dictionary_id='49184.Aktivite Tipi'></label>
				<div class="col col-7 col-xs-12 padding-right-0">
					<select name="exp_activity_type" id="exp_activity_type" style="width:130px;">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfloop query="get_activity_types">
							<cfoutput><option value="#activity_id#">#activity_name#</option></cfoutput>
						</cfloop>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-5 col-xs-12 control-label padding-left-0 padding-right-0"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>
				<div class="col col-7 col-xs-12 padding-right-0">
					<div class="input-group">
						<input type="text" name="search_date1" id="search_date1" style="width:130px;" value="">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date1"></span>
					</div>
				</div>
			</div>
			<div class="form-group">
				<div class="col col-5 col-xs-12 control-label padding-left-0 padding-right-0"></div>
				<div class="col col-7 col-xs-12 padding-right-0">
					<div class="input-group">
						<input type="text" name="search_date2" id="search_date2" style="width:130px;" value="">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="search_date2"></span>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-5 col-xs-12 control-label padding-left-0 padding-right-0"><cf_get_lang dictionary_id='57629.Açıklama'></label>
				<div class="col col-7 col-xs-12 padding-right-0">
					<input type="text" name="exp_detail" id="exp_detail" value="" style="width:130px;">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-5 col-xs-12 control-label padding-left-0 padding-right-0"><cf_get_lang dictionary_id='57673.Tutar'></label>
				<div class="col col-7 col-xs-12 padding-right-0">
					<input type="text" class="moneybox" name="exp_amount" id="exp_amount" value="0" style="width:130px;" onKeyUp="return(FormatCurrency(this,event,4));" onBlur="exp_toplam_hesapla();">
				</div>
			</div>
		</div>
	</cf_box_elements>
	<div class="row formContentFooter padding-top-5 padding-bottom-5 text-right" style="height:35px !important;">
		<input type="button" name="calcAmount" id="calcAmount" value="<cf_get_lang dictionary_id='58998.Hesapla'>" onClick="calculateAmount()" style="display:none;">
		<input type="button" value="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_process();">
	</div>
</cf_box>
<script type="text/javascript">
	function calculateAmount() {
		var get_temp_type = wrk_safe_query('cst_get_temp_type','dsn2',0,document.getElementById('exp_template_id').value);
		if(get_temp_type.IS_INCOME == 0){
			is_income_value1 = 0;
			is_income_value2 = 1;
		}
		else{
			is_income_value1 = 1;
			is_income_value2 = 0;
		}
		if(document.getElementById("exp_center_id").value != "" && $("#exp_center_id option:selected").text() != ""){
			exp_center_id = document.getElementById("exp_center_id").value;
		}
		else{
			exp_center_id = "_";
		}
		if(document.getElementById("exp_item_id").value != "" && document.getElementById("exp_item_name").value != ""){
			exp_item_id = document.getElementById("exp_item_id").value;
		}
		else{
			exp_item_id = "_";
		}
		if(document.getElementById("exp_activity_type").value != ""){
			exp_activity_type = document.getElementById("exp_activity_type").value;
		}
		else{
			exp_activity_type = "_";
		}
		if(document.getElementById("search_date1").value != ""){
			search_date1 = js_date(document.getElementById("search_date1").value);
		}
		else{
			search_date1 = "_";
		}
		if(document.getElementById("search_date2").value != ""){
			search_date2 = js_date(document.getElementById("search_date2").value);
		}
		else{
			search_date2 = "_";
		}
		var listParam = is_income_value1 + "*" + exp_center_id + "*" + exp_item_id + "*" + exp_activity_type + "*" + search_date1 + "*" + search_date2 + "*" + is_income_value2;
		var total_amount = wrk_safe_query('get_expense_items_amount','dsn2',0,listParam);
		if(total_amount.TOTAL_AMOUNT < 0){
			document.getElementById('exp_amount').value = commaSplit(0);
		}
		else{
			document.getElementById('exp_amount').value = commaSplit(total_amount.TOTAL_AMOUNT);
		}
	}

	function exp_toplam_hesapla()
	{
		exp_amount = filterNum(document.getElementById('exp_amount').value);
		document.getElementById('exp_amount').value = commaSplit(exp_amount);
	}

	function add_process()
	{
		exp_toplam_hesapla();
		if(document.getElementById('exp_template_id').value == '')
		{
			alert("<cf_get_lang dictionary_id ="51638.Masraf/Gelir Şablonu Seçmelisiniz !">");
			return false;
		}
		else
		{
			//1.Satır atandığı kısım
			var get_temp_type = wrk_safe_query('cst_get_temp_type','dsn2',0,document.getElementById('exp_template_id').value);
			exp_center = $("#exp_center_id option:selected").text();
			exp_center_id = document.getElementById('exp_center_id').value;
			row_detail = document.getElementById('exp_detail').value;
			exp_item_name = document.getElementById('exp_item_name').value;
			exp_item_id = document.getElementById('exp_item_id').value;
			exp_acc_id = document.getElementById('exp_account_id').value;
			exp_acc_code = document.getElementById('exp_account_code').value;
			exp_act_type = document.getElementById('exp_activity_type').value;
			exp_cat_id = document.getElementById('exp_cat_id').value;
			exp_cat_name = document.getElementById('exp_cat_name').value;
			if(get_temp_type.IS_INCOME == 0){
				income_total = commaSplit(filterNum(document.getElementById('exp_amount').value));
				expense_total = 0;
			}
			else{
				expense_total = commaSplit(filterNum(document.getElementById('exp_amount').value));
				income_total = 0;
			}
			add_row("",row_detail,exp_center_id,exp_item_id,exp_item_name,exp_cat_id,exp_cat_name,exp_acc_id,exp_acc_code,exp_act_type,"","","","","","","","",income_total,expense_total,0,0,0,0,"","");
			
			//Diğer Satırların atandığı kısım
			var get_temp_rows = wrk_safe_query('cst_get_temp_rows','dsn2',0,document.getElementById('exp_template_id').value);
			other_exp_amount = filterNum(document.getElementById('exp_amount').value);
			for(i=0;i<get_temp_rows.recordcount;i++)
			{
				if(get_temp_type.IS_INCOME == 0){
					other_expense_total = other_exp_amount*get_temp_rows.RATE[i]/100;
					other_expense_total = commaSplit(other_expense_total);
					other_income_total = 0;
				}
				else{
					other_expense_total = 0;
					other_income_total = other_exp_amount*get_temp_rows.RATE[i]/100;
					other_income_total = commaSplit(other_income_total);
				}
				other_row_detail = document.getElementById('exp_detail').value;
				other_exp_center = get_temp_rows.EXPENSE[i];
				other_exp_center_id =get_temp_rows.EXPENSE_CENTER_ID[i];
				other_exp_item_name =get_temp_rows.EXPENSE_ITEM_NAME[i];
				other_exp_item_id =get_temp_rows.EXPENSE_ITEM_ID[i];
				other_exp_act_type =get_temp_rows.PROMOTION_ID[i];
				other_exp_acc_code =get_temp_rows.ACCOUNT_CODE[i];
				other_exp_work_id =get_temp_rows.WORKGROUP_ID[i];
				other_exp_member_type =get_temp_rows.MEMBER_TYPE[i];
				other_exp_comp_id =get_temp_rows.COMPANY_ID[i];
				other_exp_partner_id =get_temp_rows.COMPANY_PARTNER_ID[i];
				if (get_temp_rows.EXPENSE_CATEGORY_ID[i] != '') {
					var get_exp_cat_name = wrk_safe_query('get_expense_cat_name','dsn2',0,get_temp_rows.EXPENSE_CATEGORY_ID[i]);
					other_exp_cat_id = get_temp_rows.EXPENSE_CATEGORY_ID[i];
					other_exp_cat_name = get_exp_cat_name.EXPENSE_CAT_NAME;
				}
				else{
					other_exp_cat_id = '';
					other_exp_cat_name = '';
				}
				//Project
				if(get_temp_rows.PROJECT_ID[i] != '')
				{
					var get_pro_name = wrk_safe_query('cst_get_pro_name','dsn',0,get_temp_rows.PROJECT_ID[i]);
					other_exp_pro_id = get_temp_rows.PROJECT_ID[i];
					other_exp_pro_name = get_pro_name.PROJECT_HEAD;
				}
				else
				{
					other_exp_pro_id = '';
					other_exp_pro_name = '';
				}

				//Asset
				if(get_temp_rows.ASSET_ID[i] != '')
				{
					var get_pro_name = wrk_safe_query('cst_get_pro_name_2','dsn',0,get_temp_rows.ASSET_ID[i]);
					other_exp_asset_id = get_temp_rows.ASSET_ID[i];
					other_exp_asset_name = get_pro_name.ASSETP;
				}
				else
				{
					other_exp_asset_id = '';
					other_exp_asset_name = '';
				}

				//Company
				if(other_exp_comp_id != '')
				{
					var get_comp_name = wrk_safe_query('cst_get_company','dsn',0,other_exp_comp_id);
					other_exp_comp_name = get_comp_name.FULLNAME;
				}
				else
				{
					other_exp_comp_name = '';
				}

				//Partner, Consumer, Employee
				if(other_exp_member_type != '' && other_exp_partner_id != '' && other_exp_member_type =='partner')
				{
					other_exp_authorized_con = other_exp_partner_id;
				}
				else if(other_exp_member_type != '' && other_exp_partner_id != '' && other_exp_member_type =='consumer')
				{
					other_exp_authorized_con = other_exp_partner_id;
				}
				else if(other_exp_member_type != '' && other_exp_partner_id != '' && other_exp_member_type =='employee')
				{
					var get_emp_name =  wrk_safe_query('cst_get_emp_name','dsn',0,other_exp_partner_id);
					other_exp_authorized_emp = get_emp_name.EMPLOYEE_ID;
				}
				else
				{
					other_exp_authorized_con = '';
					other_exp_authorized_emp = '';
				}

				add_row("",other_row_detail,other_exp_center_id,other_exp_item_id,other_exp_item_name,other_exp_cat_id,other_exp_cat_name,other_exp_acc_code,other_exp_acc_code,other_exp_act_type,other_exp_work_id,other_exp_member_type,other_exp_comp_id,other_exp_authorized_con,other_exp_authorized_emp,other_exp_comp_name,other_exp_pro_id,other_exp_pro_name,other_income_total,other_expense_total,0,0,0,0,other_exp_asset_id,other_exp_asset_name);
			}
			document.getElementById('open_process').style.display ='none';
		}
	}
	function pencere_ac_exp_box()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_budget_plan.exp_item_id&field_name=add_budget_plan.exp_item_name&field_account_no=add_budget_plan.exp_account_code&field_account_no2=add_budget_plan.exp_account_id&field_cat_id=add_budget_plan.exp_cat_id&field_cat_name=add_budget_plan.exp_cat_name','list');
	}
	function setButtonState(){
		if ($('#exp_template_id').val() == "") {
			$('#calcAmount').hide();
			$('#exp_amount').val(commaSplit(0));
		} else {
			$('#calcAmount').show();
		}
    }
</script>