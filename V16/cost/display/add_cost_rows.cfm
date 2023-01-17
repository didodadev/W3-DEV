 <cfsetting showdebugoutput="no">
<cfquery name="get_cost_template" datasource="#dsn2#">
	SELECT 
		* 
	FROM 
		EXPENSE_PLANS_TEMPLATES 
	WHERE 
		TEMPLATE_ID IS NOT NULL 
		AND IS_ACTIVE = 1 
		<cfif attributes.type eq 1>
			AND IS_INCOME = 0
		<cfelse>
			AND IS_INCOME = 1
		</cfif>
	ORDER BY 
		TEMPLATE_NAME
</cfquery>
<cfquery name="get_money_rate" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfquery name="get_tax" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX ORDER BY TAX
</cfquery>
<cfif attributes.type eq 1><cfset title_info="#getLang('','Masraf Dağılımı Yap',34266)#"><cfelse><cfset title_info="#getLang('','Gelir Dağılımı Yap',64599)#"></cfif>
<cf_box id="add_cost_rows" title="#title_info#" closable="1" draggable="1" resize="0">
	<cf_box_elements vertical="1">
		<div class="form-group col col-4 col-md-6 col-sm-6 col-xs-12">
			<label><cfif attributes.type eq 1><cf_get_lang_main no='1410.Masraf Şablonu'><cfelse><cf_get_lang_main no='1411.Gelir Şablonu'></cfif></label>
			<select name="exp_template_id" id="exp_template_id">
				<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				<cfoutput query="get_cost_template">
					<option value="#template_id#">#template_name#</option>
				</cfoutput>
			</select>
		</div>
		<div class="form-group col col-4 col-md-6 col-sm-6 col-xs-12">
			<label><cfif attributes.type eq 1><cf_get_lang_main no='1139.Gider Kalemi'><cfelse><cf_get_lang_main no='761.Gelir Kalemi'></cfif></label>
			<div class="input-group">
				<input type="hidden" name="account_code" id="account_code" value="">
				<input type="hidden" name="expense_item_id" id="expense_item_id" value="">
				<input type="text" name="expense_item_name" id="expense_item_name" value=""onFocus="AutoComplete_Create('expense_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID','expense_item_id','add_costplan',1);">
				<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_costplan.expense_item_id&field_name=add_costplan.expense_item_name&field_account_no=add_costplan.account_code','list');"></span>
			</div>
		</div>
		<div class="form-group col col-4 col-md-6 col-sm-6 col-xs-12">
			<label><cf_get_lang_main no='217.Açıklama'></label>
			<input type="text" name="exp_detail" id="exp_detail" value="">
		</div>
		<div class="form-group col col-4 col-md-6 col-sm-6 col-xs-12">
			<label><cf_get_lang_main no='261.Tutar'></label>
			<input type="text" class="moneybox" name="exp_amount" id="exp_amount" value="0" onKeyUp="return(FormatCurrency(this,event,4));" onBlur="exp_toplam_hesapla();">
		</div>
		<div class="form-group col col-4 col-md-6 col-sm-6 col-xs-12">
			<label><cf_get_lang_main no='227.KDV'></label>
			<input type="text" class="moneybox" name="exp_tax_amount" id="exp_tax_amount" value="0" onKeyUp="return(FormatCurrency(this,event,4));" onBlur="exp_toplam_hesapla();">
		</div>
		<cfif attributes.type eq 1>
			<div class="form-group col col-4 col-md-6 col-sm-6 col-xs-12">
				<label><cf_get_lang_main no='609.OTV'></label>
				<input type="text" class="moneybox" name="exp_otv_amount" id="exp_otv_amount" value="0" onKeyUp="return(FormatCurrency(this,event,4));" onBlur="exp_toplam_hesapla();">
			</div>
		<cfelse>
			<input type="hidden" class="moneybox" name="exp_otv_amount" id="exp_otv_amount" value="0"> 
		</cfif>
		<div class="form-group col col-4 col-md-6 col-sm-6 col-xs-12">
			<label><cf_get_lang_main no='80.Toplam'></label>
			<input type="text" class="moneybox" name="exp_total_amount" id="exp_total_amount" value="0" readonly>
		</div>
		<div class="form-group col col-4 col-md-6 col-sm-6 col-xs-12">
			<label><cf_get_lang_main no='227.KDV'><cf_get_lang_main no='1259.Oranı'></label>
				<select name="exp_tax_rate" id="exp_tax_rate" style="width:130px;">
					<cfoutput query="get_tax">
						<option value="#tax#">#tax#</option>
					</cfoutput>
				</select>
		</div>
		<div class="form-group col col-4 col-md-6 col-sm-6 col-xs-12">
			<label><cf_get_lang_main no='77.Para Birimi'></label>
			<select name="exp_money_type" id="exp_money_type" style="width:130px;">
				<cfoutput query="get_money_rate">
					<option value="#money#,#rate1#,#rate2#" <cfif ListFirst(money) eq session.ep.money>selected</cfif>>#money#</option>
				</cfoutput>
			</select>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<div>
			<input type="button" value="<cf_get_lang_main no='170.Ekle'>" onClick="add_process();">
		</div>
	</cf_box_footer>	
</cf_box>
<script type="text/javascript">
	function exp_toplam_hesapla()
	{
		exp_amount = filterNum(document.getElementById('exp_amount').value);
		exp_tax_amount = filterNum(document.getElementById('exp_tax_amount').value);
		exp_otv_amount = filterNum(document.getElementById('exp_otv_amount').value);
		document.getElementById('exp_total_amount').value = commaSplit(parseFloat(exp_amount)+parseFloat(exp_tax_amount)+parseFloat(exp_otv_amount));
		document.getElementById('exp_amount').value = commaSplit(exp_amount);
		document.getElementById('exp_tax_amount').value = commaSplit(exp_tax_amount);
		document.getElementById('exp_otv_amount').value = commaSplit(exp_otv_amount);
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
			for(s=1;s<=document.all.kur_say.value;s++)
			{
				money_deger =list_getat(document.all.rd_money[s-1].value,1,',');
				if(money_deger == list_getat(document.getElementById('exp_money_type').value,1))
				{
					
					exp_rate2 = filterNum(eval("document.all.txt_rate2_"+s).value);
				}
			}
			exp_money_type = document.getElementById('exp_money_type').value;
			var get_temp_rows = wrk_safe_query('cst_get_temp_rows','dsn2',0,document.getElementById('exp_template_id').value);
			for(i=0;i<get_temp_rows.recordcount;i++)
			{
				row_detail = document.getElementById('exp_detail').value;
				exp_tax_rate = document.getElementById('exp_tax_rate').value;
				row_money = document.getElementById('exp_money_type').value;
				exp_amount = filterNum(document.getElementById('exp_amount').value);
				exp_tax_amount = filterNum(document.getElementById('exp_tax_amount').value);
				exp_otv_amount = filterNum(document.getElementById('exp_otv_amount').value);
				exp_amount = parseFloat(exp_amount*exp_rate2)*get_temp_rows.RATE[i]/100;
				exp_tax_amount = parseFloat(exp_tax_amount*exp_rate2)*get_temp_rows.RATE[i]/100;
				exp_otv_amount = parseFloat(exp_otv_amount*exp_rate2)*get_temp_rows.RATE[i]/100;
				exp_center =get_temp_rows.EXPENSE[i];
				exp_center_id =get_temp_rows.EXPENSE_CENTER_ID[i];
				if(document.getElementById('expense_item_id').value != '' && document.getElementById('expense_item_name').value != '')
				{
					exp_item = document.getElementById('expense_item_name').value;
					exp_item_id = document.getElementById('expense_item_id').value;
					acc_code = document.getElementById('account_code').value;
				}
				else
				{
					exp_item =get_temp_rows.EXPENSE_ITEM_NAME[i];
					exp_item_id =get_temp_rows.EXPENSE_ITEM_ID[i];
					acc_code =get_temp_rows.ACCOUNT_CODE[i];
				}
				exp_act_id =get_temp_rows.PROMOTION_ID[i];
				exp_work_id =get_temp_rows.WORKGROUP_ID[i];
				exp_member_type =get_temp_rows.MEMBER_TYPE[i];
				exp_comp_id =get_temp_rows.COMPANY_ID[i];
				exp_partner_id =get_temp_rows.COMPANY_PARTNER_ID[i];
				if(get_temp_rows.PROJECT_ID[i] != '')
				{
					var get_pro_name = wrk_safe_query('cst_get_pro_name','dsn',0,get_temp_rows.PROJECT_ID[i]);
					exp_pro_id = get_temp_rows.PROJECT_ID[i];
					exp_pro_name = get_pro_name.PROJECT_HEAD;
				}
				else
				{
					exp_pro_id = '';
					exp_pro_name = '';
				}
				if(get_temp_rows.ASSET_ID[i] != '')
				{
					var get_pro_name = wrk_safe_query('cst_get_pro_name_2','dsn',0,get_temp_rows.ASSET_ID[i]);
					exp_asset_id = get_temp_rows.ASSET_ID[i];
					exp_asset_name = get_pro_name.ASSETP;
				}
				else
				{
					exp_asset_id = '';
					exp_asset_name = '';
				}
				if(exp_comp_id != '')
				{
					var get_comp_name = wrk_safe_query('cst_get_company','dsn',0,exp_comp_id);
					exp_comp_name = get_comp_name.FULLNAME;
				}
				else
				{
					exp_comp_name = '';
				}
				if(exp_member_type != '' && exp_partner_id != '' && exp_member_type =='partner')
				{
					var get_par_name = wrk_safe_query('cst_get_comp_name','dsn',0,exp_partner_id);
					exp_authorized = get_par_name.COMPANY_PARTNER_NAME+' '+get_par_name.COMPANY_PARTNER_SURNAME;
				}
				else if(exp_member_type != '' && exp_partner_id != '' && exp_member_type =='consumer')
				{
					var get_cons_name = wrk_safe_query('cst_get_cons_name_2','dsn',0,exp_partner_id);
					exp_authorized = get_cons_name.CONSUMER_NAME+' '+get_cons_name.CONSUMER_SURNAME;
				}
				else if(exp_member_type != '' && exp_partner_id != '' && exp_member_type =='employee')
				{
					var get_emp_name =  wrk_safe_query('cst_get_emp_name','dsn',0,exp_partner_id); 
					exp_authorized = get_emp_name.EMPLOYEE_NAME+' '+get_emp_name.EMPLOYEE_SURNAME;
					exp_partner_id = get_emp_name.EMPLOYEE_ID;
				}
				else
				{
					exp_authorized = '';
				}
				<cfif attributes.type eq 1>
					add_row(row_detail,exp_center,exp_center_id,exp_item,exp_item_id,exp_pro_id,exp_pro_name,"","","","","","","",exp_member_type,exp_partner_id,exp_comp_id,exp_comp_name,exp_authorized,exp_amount,exp_tax_amount,exp_otv_amount,exp_tax_rate,exp_money_type,exp_act_id,exp_work_id,"","",exp_asset_id,exp_asset_name,acc_code,"","","","","","");//otv_rate
				<cfelse>
					add_row(row_detail,exp_center,exp_center_id,exp_item,exp_item_id,exp_pro_id,exp_pro_name,"","","","","","","",exp_member_type,exp_partner_id,exp_comp_id,exp_comp_name,exp_authorized,exp_amount,exp_tax_amount,exp_otv_amount,exp_tax_rate,exp_money_type,exp_act_id,exp_work_id,"","",exp_asset_id,exp_asset_name,acc_code,"","","","","","");
				</cfif>
				hesapla('total',row_count);
			}
			document.getElementById('open_process').style.display ='none';
		}
	}
</script>
