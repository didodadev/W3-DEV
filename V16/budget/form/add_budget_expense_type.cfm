<cfinclude template="../../objects/query/tax_type_code.cfm">
<cfinclude template="../query/get_expense_cat_list.cfm">
<cfscript>
	cfc = createObject("component", "V16.budget.cfc.budget_expense_cat");
	BudgetCats = cfc.GetBudgetCats();
</cfscript>
<cfparam name="attributes.upper_cat" default="">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">

<cfsavecontent variable="head"><cf_get_lang dictionary_id='51365.Bütçe Kalemleri'> <cf_get_lang dictionary_id='44630.Ekle'></cfsavecontent>
<cf_box title="#head#" closable="0">
<cfform name="add_expense_item" id="add_expense_item" method="post" action="#request.self#?fuseaction=budget.emptypopup_add_expense_item">
	<cf_box_elements>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group col col-1 col-md-1 col-sm-6 col-xs-12" id="item-is_active">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="is_active" id="is_active" checked>
				</label>
			</div>
			
			<div class="form-group col col-1 col-md-2 col-sm-6 col-xs-12" id="income_expense">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_get_lang dictionary_id='58677.Gelir'><input type="checkbox" name="income_expense" id="income_expense" checked>
				</label>
			</div>
			<div class="form-group col col-1 col-md-2 col-sm-6 col-xs-12" id="is_expense">
				<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_get_lang dictionary_id='58678.Gider'><input type="checkbox" name="is_expense" id="is_expense" checked>
				</label>
			</div>
		</div>
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group" id="item-expense_cat">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
				<div class="col col-8 col-xs-12">
					<select name="expense_cat" id="expense_cat" onchange="document.getElementById('head_cat_code').value = document.add_expense_item.expense_cat[document.add_expense_item.expense_cat.selectedIndex].value;">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="BudgetCats">
						<option value="#expense_cat_code#" <cfif IsDefined("IS_SUB_EXPENSE_CAT") and IS_SUB_EXPENSE_CAT eq 1> disabled style="font-weight:bold;"</cfif>>
						<cfif ListLen(expense_cat_code,".") neq 1>
								<cfloop from="1" to="#ListLen(expense_cat_code,".")#" index="i">&nbsp;</cfloop>
							</cfif>
							#expense_cat_code# #expense_cat_name#</option>
						</cfoutput>
					</select>                            
				</div>
			</div>
			
			<div class="form-group" id="item-expense_item_name">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32775.Kategori Kodu'> *</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<input type="text" name="head_cat_code" id="head_cat_code" placeholder="<cf_get_lang dictionary_id='57986.Alt'><cf_get_lang dictionary_id='57559.Bütçe'><cf_get_lang dictionary_id='32775.Kategori Kodu'>" value="<cfif len(attributes.upper_cat)>#attributes.upper_cat#</cfif>" disabled>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='420.Kategori Kodu girmelisiniz'></cfsavecontent>
						<span class="input-group-addon no-bg"></span>
						<input type="text" name="expense_item_code" id="expense_item_code" placeholder="<cf_get_lang dictionary_id='58234.Bütçe Kalemi'><cf_get_lang dictionary_id='49089.Kodu'>" value="" maxlength="50" required="yes" message="#message#" style="width:98px;">
					</div>
				</div>
			</div>
		</div>
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
			<div class="form-group" id="item-expense_item_name">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'> *</label>
				<div class="col col-8 col-xs-12">
					<input type="text" name="expense_item_name" id="expense_item_name" maxlength="50">
				</div>
			</div>
			<div class="form-group" id="item-account_code">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'> *</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<input type="hidden" name="account_id" id="account_id">
						<input type="text" name="account_code" id="account_code" readonly>
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_name=add_expense_item.account_code&field_id=add_expense_item.account_id','list')" title="<cfoutput>#getLang('main',1399)#</cfoutput>"></span>
					</div>
				</div>
			</div>
		</div>
		<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
			<cfif session.ep.our_company_info.is_efatura>
				<div class="form-group" id="item-tax_code">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30006.Vergi Kodu'></label>
					<div class="col col-8 col-xs-12">
						<select name="tax_code" id="tax_code" style="width:175px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="TAX_CODES">
								<option value="#TAX_CODE_ID#;#TAX_CODE_NAME#" title="#detail#">#TAX_CODE_NAME#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</cfif>
			<div class="form-group" id="item-expense_item_detail">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
				<div class="col col-8 col-xs-12">
					<textarea name="expense_item_detail" id="expense_item_detail"></textarea>
				</div>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
	</cf_box_footer>
</cfform>
</div>
</cf_box>
<script type="text/javascript">
	/* public query function GetUpperCatCode(cat_id){
	queryObj = new Query();
	queryObj.setDatasource("#dsn2#");
	result = queryObj.execute(sql="SELECT * FROM EXPENSE_CAT_CODE WHERE EXPENSE_CAT_ID = '#cat_id#'");
	result = result.getResult();
	document.getElementById('head_cat_code').value = result;
	queryObj.clearParams();

	return result;
    } */
	function kontrol()
	{
		if(document.getElementById("expense_cat").value == '')
		{
			alert("<cf_get_lang dictionary_id='49135.Bütçe Kategorisi Seçmediniz'> !");
			return false;
		}
		if(document.getElementById("expense_item_code").value == '')
		{
			alert("<cf_get_lang dictionary_id='33952.Kod Girmelisiniz'> !");
			return false;
		}
		if(document.getElementById("expense_item_name").value == '')
		{
			alert("<cf_get_lang dictionary_id='49131.Bütçe Kalemi Girmelisiniz'> !");
			return false;
		}
		if(document.getElementById("account_code").value == '')
		{
			alert("<cf_get_lang dictionary_id='49155.Muhasebe Kodu girmelisiniz'>!");
			return false;
		}
		if(document.getElementById("income_expense").checked == false && document.getElementById("is_expense").checked == false)
		{
			alert("<cf_get_lang dictionary_id='49158.Gelir yada Gider Seçmelisiniz'> !");
			return false;
		}	
		return true;
	}
</script>
