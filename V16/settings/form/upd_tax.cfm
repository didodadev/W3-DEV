<cfinclude template="../../objects/query/tax_type_code.cfm">
<cfset UPD_tax = createObject("component","V16.settings.cfc.tax")/>
<cfset CATEGORY =UPD_tax.SelectID(
			tid:attributes.tid
		)/>
<cfif not category.recordcount>
	<script type="text/javascript">		
        alert('Böyle bir kayıt bulunmamaktadır!!!');
        window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_add_tax</cfoutput>";
    </script>
	<cfabort>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang(547,'KDV Oranları',42151)#" add_href="#request.self#?fuseaction=settings.list_tax" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_tax.cfm">
		</div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
		<cfform name="tax" method="post">
			<input type="hidden" id="counter" name="counter">				
			<cfif isdefined("tax_list") and len(tax_list)>
				<cfset tax_list = listdeleteat(tax_list,listfind(tax_list,category.tax,','),',')>
			</cfif>
			<input type="hidden" name="tax_list" id="tax_list" value="<cfif isdefined("tax_list") and len(tax_list)><cfoutput>#tax_list#</cfoutput></cfif>">
			<input type="hidden" name="tid" id="tid" value="<cfoutput>#attributes.tid#</cfoutput>">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
					<div class="form-group" id="item-Account_Code_s">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42531.Satış Muhasebe Kodu'><cfif session.ep.period_is_integrated eq 1> *</cfif></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='42203.Satış Muhasebe Kodu girmelisiniz'></cfsavecontent>
								<cfinput type="text" required="yes" message="#message#" name="Account_Code_s" value="#category.sale_code#" onFocus="AutoComplete_Create('Account_Code_s','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code_s');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-Account_Code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42532.Alış Muhasebe Kodu'><cfif session.ep.period_is_integrated eq 1> *</cfif></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='42253.Alış Muhasebe Kodu girmelisiniz'></cfsavecontent>
								<cfinput type="text" required="yes" message="#message#" name="Account_Code" onFocus="AutoComplete_Create('Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off" value="#category.purchase_code#">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-Account_Code_s_iade">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42995.Satış İade Muhasebe Kodu'>*</label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='43187.Satış İade Muhasebe Kodu girmelisiniz'></cfsavecontent>
								<cfinput type="text" required="yes" message="#message#" name="Account_Code_s_iade" value="#category.sale_code_iade#" onFocus="AutoComplete_Create('Account_Code_s_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code_s_iade');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-Account_Code_iade">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42996.Alış İade Muhasebe Kodu'>*</label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" required="yes" message="Alış İade Muhasebe Kodu girmelisiniz" name="Account_Code_iade" value="#category.purchase_code_iade#" onFocus="AutoComplete_Create('Account_Code_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('Account_Code_iade');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-inventory_Account_Code_s">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58686.Sabit Kıymet Satış Muhasebe Kodu'></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="inventory_Account_Code_s" value="#category.inventory_sale_code#" onFocus="AutoComplete_Create('inventory_Account_Code_s','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('inventory_Account_Code_s');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-inventory_Account_Code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58665.Sabit Kıymet Alış Muhasebe Kodu'></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="inventory_Account_Code" value="#category.inventory_purchase_code#" onFocus="AutoComplete_Create('inventory_Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('inventory_Account_Code');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-pro_price_dif_Account_Code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44990.Verilen Fiyat Farkı Muhasebe Kodu'></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="pro_price_dif_Account_Code" value="#category.sale_price_diff_code#" onFocus="AutoComplete_Create('pro_price_dif_Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('pro_price_dif_Account_Code');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-rec_price_dif_Account_Code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44988.Alınan Fiyat Farkı Muhasebe Kodu'></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="rec_price_dif_Account_Code" value="#category.purchase_price_diff_code#" onFocus="AutoComplete_Create('rec_price_dif_Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('rec_price_dif_Account_Code');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-exp_reg_sales_dif_Account_Code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44214.İhraç Kayıtlı Satış Muhasebe Kodu'></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="exp_reg_sales_dif_Account_Code" value="#category.EXP_SALES_CODE#" onFocus="AutoComplete_Create('exp_reg_sales_dif_Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('exp_reg_sales_dif_Account_Code');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
					<div class="form-group" id="item-exp_reg_purchase_dif_Account_Code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44243.İhraç Kayıtlı Alış Muhasebe Kodu'></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="exp_reg_purchase_dif_Account_Code" value="#category.EXP_PURCHASE_CODE#" onFocus="AutoComplete_Create('exp_reg_purchase_dif_Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('exp_reg_purchase_dif_Account_Code');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-inward_process_dif_Account_Code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44244.Dahilde İşlem Muhasebe Kodu'></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="inward_process_dif_Account_Code" value="#category.INWARD_PROCESS_CODE#" onFocus="AutoComplete_Create('inward_process_dif_Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('inward_process_dif_Account_Code');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-direct_expense_Account_Code">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='56194.Doğrudan Giderleştirme Hesabı'></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="direct_expense_Account_Code" value="#category.DIRECT_EXPENSE_CODE#" onFocus="AutoComplete_Create('direct_expense_Account_Code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','tax','3','150');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac('direct_expense_Account_Code');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-expense_item_name1">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='45607.Doğrudan Giderleştirme Gider Kalemi'></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="hidden" name="expense_item_id" id="expense_item_id" value="#category.EXPENSE_ITEM_ID#">
								<cfinput type="text" name="expense_item_name" id="expense_item_name" value="#category.EXPENSE_ITEM_NAME#" onFocus="AutoComplete_Create('expense_item_name','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','0','EXPENSE_ITEM_ID,ACCOUNT_CODE,TAX_CODE','expense_item_id,account_code,tax_code','add_costplan',1);" autocomplete="off">
								<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_item();"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-tax_rate">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42533.KDV Oranı'><cfif len(session.ep.our_company_info.is_efatura) and session.ep.our_company_info.is_efatura>*</cfif>*</label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='285.KDV Oranı girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="tax_rate" size="10" value="#category.tax#" maxlength="4" required="Yes" message="#message#" validate="float" range="0.0,999.9" onKeyUp="isNumber(this);" style="width:140px;">
						</div>
					</div>
					<div class="form-group" id="item-tax_code1">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='30006.Vergi Kodu'><cfif len(session.ep.our_company_info.is_efatura) and session.ep.our_company_info.is_efatura>*</cfif>*</label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="tax_code" id="tax_code" style="width:140px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>!</option>
								<cfoutput query="TAX_CODES">
									<option value="#TAX_CODE_ID#,#TAX_CODE_NAME#" title="#detail#" <cfif category.tax_code eq tax_codes.tax_code_id>selected="selected"</cfif>>#TAX_CODE_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<textarea name="detail" id="detail" rows="6" cols="45"  style="width:140px;height:40px;"><cfoutput>#category.detail#</cfoutput></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="CATEGORY">
				<cfquery name="GET_PRODUCT_TAX_ID" datasource="#DSN3#" maxrows="1">
					SELECT TAX, TAX_PURCHASE FROM PRODUCT WHERE TAX=#CATEGORY.TAX# OR TAX_PURCHASE=#CATEGORY.TAX#
				</cfquery>
				<cfif get_product_tax_id.recordcount>
					<cf_workcube_buttons is_upd='1' is_delete='0' add_function='tax_kontrol()'>
				<cfelse>
					<cf_workcube_buttons is_upd='1' add_function='form_kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_tax_del&tid=#attributes.tid#'> </td>
				</cfif>
			</cf_box_footer>
		</cfform>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
	function form_kontrol()
	{
		x = (50 - document.tax.detail.value.length);
		if ( x < 0)
		{ 
			alert ("<cf_get_lang dictionary_id='43826.Açıklama Bölümüne En Fazla 50 Karakter Girmelisiniz'>");
			return false;
		}
		if (<cfoutput>#session.ep.period_is_integrated#</cfoutput> == 1)
		{
			if (document.tax.Account_Code_s =='')
			{
				alert("<cf_get_lang dictionary_id='43177.Lütfen Satış Muhasebe Kodu Seçiniz'>!");
				return false;
			}
			if (document.tax.Account_Code =='')
			{
				alert("<cf_get_lang dictionary_id='43178.Lütfen Alış Muhasebe Kodu Seçiniz'>!");
				return false;
			}
		}
		if(document.tax.tax_list.value.length > 0 && list_find(document.tax.tax_list.value,document.tax.tax_rate.value,','))
		{
			alert("<cf_get_lang dictionary_id ='43834.Aynı KDV Oranını Giremezsiniz'>!");
			return false;
		}
		if(document.getElementById('tax_code').value == '')
		{
			alert("<cf_get_lang dictionary_id='60818.Vergi Kodu Seçiniz'>");
			return false;
		}
		if(tax_code_validation() == 0)
			return false;
		return true;
	}
	function tax_kontrol()
	{
		if(document.tax.tax_list.value.length > 0 && list_find(document.tax.tax_list.value,document.tax.tax_rate.value,','))
		{
			alert("<cf_get_lang dictionary_id ='43834.Aynı KDV Oranını Giremezsiniz'>!");
			return false;
		}
		<cfif session.ep.our_company_info.is_efatura>
				if(document.getElementById('tax_code').value == '')
				{
					alert("<cf_get_lang dictionary_id='60818.Vergi Kodu Seçiniz'>");
					return false;
				}
		</cfif>
		if(tax_code_validation() == 0)
			return false;
		return true;
	}
	function tax_code_validation()
	{
		var inputlist = ["Account_Code_s","Account_Code","Account_Code_s_iade","Account_Code_iade","inventory_Account_Code_s","inventory_Account_Code","pro_price_dif_Account_Code","rec_price_dif_Account_Code"];
		for(i=1; i<= inputlist.length; i++) {
			if(document.getElementById(inputlist[i-1]).value != '')
			{
				if(WrkAccountControl(document.getElementById(inputlist[i-1]).value,"<cf_get_lang dictionary_id='61205.Lütfen geçerli muhasebe kodları kullanınız'>",'<cfoutput>#dsn2#</cfoutput>') == 0)
					return false;
			}
		}
		return true;
	}
	function pencere_ac(isim)
	{
		if(document.getElementById(isim).value.length != 0)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=tax.'+isim+'&account_code=' + document.getElementById(isim).value, 'list');
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=tax.'+isim, 'list');
	}
	function pencere_ac_item()
	{
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=all.expense_item_id&field_name=all.expense_item_name', 'list');
	}
</script>