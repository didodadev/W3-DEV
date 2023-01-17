<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)><!--- Butceden Donustuyse --->
	<cfquery name="get_rows" datasource="#dsn#">
		SELECT EXP_INC_CENTER_ID EXPENSE_CENTER_ID, BUDGET_ITEM_ID EXPENSE_ITEM_ID,'' WORK_ID,'' OPP_ID,'' EXPENSE_ACCOUNT_CODE,* FROM BUDGET_PLAN_ROW WHERE BUDGET_PLAN_ROW_ID = #attributes.budget_plan_row_id# AND IS_PAYMENT =1
	</cfquery>
	<cfquery name="get_money_rate" datasource="#dsn#">
		SELECT MONEY_TYPE FROM BUDGET_PLAN_MONEY WHERE ACTION_ID = #get_rows.budget_plan_id# AND IS_SELECTED = 1
	</cfquery>
<cfelseif isdefined("attributes.credit_contract_id") and len(attributes.credit_contract_id)><!--- Kredi Fon Yonetiminden Donustuyse --->
	<cfquery name="get_rows" datasource="#dsn3#">
		SELECT '' EXPENSE_ACCOUNT_CODE,1 AS TYPE,'' WORK_ID,'' OPP_ID,*,(SELECT RATE2 FROM CREDIT_CONTRACT_MONEY WHERE MONEY_TYPE = CREDIT_CONTRACT_ROW.OTHER_MONEY AND ACTION_ID =#attributes.credit_contract_id#) RATE2 FROM CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ID = #attributes.credit_contract_id# AND  CREDIT_CONTRACT_ROW_ID = #attributes.credit_contract_row_id#
		UNION ALL
		SELECT '' EXPENSE_ACCOUNT_CODE,0 AS TYPE,'' WORK_ID,'' OPP_ID,*,(SELECT RATE2 FROM CREDIT_CONTRACT_MONEY WHERE MONEY_TYPE = CREDIT_CONTRACT_ROW.OTHER_MONEY AND ACTION_ID =#attributes.credit_contract_id#) RATE2  FROM CREDIT_CONTRACT_ROW WHERE CREDIT_CONTRACT_ID = #attributes.credit_contract_id# AND  CREDIT_CONTRACT_ROW_ID = #attributes.credit_contract_row_id# AND INTEREST_PRICE > 0
	</cfquery>
<cfelseif isdefined("attributes.expense_id") and len(attributes.expense_id)><!--- Masraf Kopyalama Ise --->
	<cfquery name="get_rows" datasource="#dsn2#">
		SELECT * FROM EXPENSE_ITEMS_ROWS WHERE EXPENSE_ID = #attributes.expense_id# ORDER BY EXP_ITEM_ROWS_ID
	</cfquery>
<cfelseif isdefined("attributes.request_id") and len(attributes.request_id)><!--- Harcama Talebinden Donustuyse --->
	<cfquery name="get_rows" datasource="#dsn2#">
		SELECT '' EXPENSE_ACCOUNT_CODE,* FROM EXPENSE_ITEM_PLAN_REQUESTS_ROWS WHERE EXPENSE_ID = #attributes.request_id#
	</cfquery>
<cfelse>
	<cfset get_rows.recordcount = 0>
</cfif>
<table name="table1" id="table1" class="color-border" border="0" cellpadding="0" cellspacing="1">
	<tr class="color-header" height="25">
		<td align="center" nowrap>
			<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_rows.recordcount#</cfoutput>">
			<input type="button" class="eklebuton" title="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_row();">&nbsp;
			<a onClick="open_process_row();"><img src="images/shema_list.gif" title="<cf_get_lang dictionary_id='34266.Masraf Dağılımı Yap'>" align="absmiddle" style="cursor:pointer;"></a>
			<div style="position:absolute;" id="open_process"></div>
		</td>
		<cfif x_is_showing_exp_date eq 1><td class="form-title" style="width:85px;" nowrap><cf_get_lang dictionary_id='57742.Tarih'>*</td></cfif>
		<td class="form-title" width="120" nowrap><cf_get_lang dictionary_id='57629.Açıklama'>*</td>
		<cfif x_is_project_priority eq 0>
			<td class="form-title" style="width:230px;" nowrap><cf_get_lang dictionary_id='58460.Masraf Merkezi'>*</td>
			<td class="form-title" style="width:230px;" nowrap><cf_get_lang dictionary_id='58551.Gider Kalemi'>*</td>
			<cfif x_is_showing_account_code eq 1><td class="form-title" style="width:160px;" nowrap><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>*</td></cfif>
		</cfif>
		<cfif x_is_showing_physical_asset eq 1 and fuseaction contains "assetcare"><td class="form-title" width="140" nowrap><cf_get_lang dictionary_id='58833.Fiziki Varlık'><cfif x_is_required_physical_asset eq 1>*</cfif></td></cfif>
		<cfif x_is_project_priority eq 1><td class="form-title" width="150" nowrap><cf_get_lang dictionary_id='57416.Proje'></td></cfif>
		<cfif x_is_showing_product eq 1 or x_is_project_priority eq 1><td class="form-title" width="160" nowrap><cf_get_lang dictionary_id='57657.Ürün'></td></cfif>
		<cfif x_is_showing_unit eq 1><td class="form-title" width="40" nowrap><cf_get_lang dictionary_id='57636.Birim'></td></cfif>
		<td class="form-title" width="50"><cf_get_lang dictionary_id='57635.Miktar'></td>
		<td width="80"  nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></td>
		<td  nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'>%</td>
		<td  nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58021.ÖTV'>%</td>
		<td width="60"  nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></td>
		<td width="60"  nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58021.ÖTV'></td>
		<td class="form-title" width="80" nowrap><cf_get_lang dictionary_id='57680.KDV li Toplam'></td>
		<td class="form-title" width="55" nowrap><cf_get_lang dictionary_id='57489.Para Br'></td>
		<td width="80"  nowrap class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='58056.Dövizli Tutar'></td>
		<cfif x_is_showing_activity_type eq 1><td class="form-title" style="width:175px;" nowrap><cf_get_lang dictionary_id='33167.Akitivite Tipi'></td></cfif>
		<cfif x_is_showing_work_group eq 1><td class="form-title" style="width:175px;" nowrap><cf_get_lang dictionary_id='58140.İş Grubu'></td></cfif>
		<cfif x_is_showing_work_head eq 1><td class="form-title" width="148" nowrap><cf_get_lang dictionary_id='58445.İş'></td></cfif>
		<cfif x_is_showing_opportunities_head eq 1><td class="form-title" width="144" nowrap><cf_get_lang dictionary_id='57612.Fırsat'></td></cfif>
		<cfif x_is_showing_project eq 1 and x_is_project_priority eq 0><td class="form-title" width="130" nowrap><cf_get_lang dictionary_id='57416.Proje'></td></cfif>
		<cfif x_is_showing_system eq 1><td class="form-title" width="130" nowrap><cf_get_lang dictionary_id='58832.Abone'></td></cfif>
		<td class="form-title" style="width:250px;" nowrap><cf_get_lang dictionary_id='33257.Harcama Yapan'></td>
		<cfif x_is_showing_physical_asset eq 1 and fuseaction contains "cost."><td class="form-title" width="140" nowrap><cf_get_lang dictionary_id='58833.Fiziki Varlık'><cfif x_is_required_physical_asset eq 1>*</cfif></td></cfif>
	</tr>
	<cfset expense_center_list = "">
	<cfset expense_item_list = "">
	<cfset subscription_list = "">
	<cfset pyschical_asset_list = "">
	<cfset work_head_list = "">
	<cfset opp_head_list = "">
	<cfif get_rows.recordcount>
		<cfoutput query="get_rows">
			<cfif len(expense_center_id) and not listfind(expense_center_list,expense_center_id)>
				<cfset expense_center_list=listappend(expense_center_list,expense_center_id)>
			</cfif>
			<cfif len(expense_item_id) and not listfind(expense_item_list,expense_item_id)>
				<cfset expense_item_list=listappend(expense_item_list,expense_item_id)>
			</cfif>
			<cfif isdefined("subscription_id") and len(subscription_id) and not listfind(subscription_list,subscription_id)>
				<cfset subscription_list=listappend(subscription_list,subscription_id)>
			</cfif>
			<cfif isdefined("pyschical_asset_id") and len(pyschical_asset_id) and not listfind(pyschical_asset_list,pyschical_asset_id)>
				<cfset pyschical_asset_list=listappend(pyschical_asset_list,pyschical_asset_id)>
			</cfif>
			<cfif len(work_id) and not listfind(work_head_list,work_id)>
				<cfset work_head_list=listappend(work_head_list,work_id)>
			</cfif>
			<cfif len(opp_id) and not listfind(opp_head_list,opp_id)>
				<cfset opp_head_list=listappend(opp_head_list,opp_id)>
			</cfif>
		</cfoutput>
		<cfif ListLen(expense_center_list)>
			<cfset expense_center_list=listsort(expense_center_list,"numeric","ASC",",")>
			<cfquery name="get_expense_center" datasource="#dsn2#">
				SELECT EXPENSE_ID, EXPENSE + ' ' + EXPENSE_CODE AS EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_center_list#) ORDER BY EXPENSE_ID
			</cfquery>
			<cfset expense_center_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_center.expense_id)),'numeric','ASC',',')>
		</cfif>
		<cfif ListLen(expense_item_list)>
			<cfset expense_item_list=listsort(expense_item_list,"numeric","ASC",",")>
			<cfquery name="get_expense_item" datasource="#dsn2#">
				SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#expense_item_list#) ORDER BY EXPENSE_ITEM_ID
			</cfquery>
			<cfset expense_item_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_item.expense_item_id)),'numeric','ASC',',')>
		</cfif>
		<cfif ListLen(subscription_list)>
			<cfset subscription_list=listsort(subscription_list,"numeric","ASC",",")>
			<cfquery name="get_subscription" datasource="#dsn3#">
				SELECT SUBSCRIPTION_ID, SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IN (#subscription_list#) ORDER BY SUBSCRIPTION_ID
			</cfquery>
			<cfset subscription_list = ListSort(ListDeleteDuplicates(ValueList(get_subscription.subscription_id)),'numeric','ASC',',')>
		</cfif>
		<cfif ListLen(pyschical_asset_list)>
			<cfset pyschical_asset_list=listsort(pyschical_asset_list,"numeric","ASC",",")>
			<cfquery name="get_pyschical_asset" datasource="#dsn#">
				SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#pyschical_asset_list#) ORDER BY ASSETP_ID
			</cfquery>
			<cfset pyschical_asset_list = ListSort(ListDeleteDuplicates(ValueList(get_pyschical_asset.assetp_id)),'numeric','ASC',',')>
		</cfif>
		<cfif len(work_head_list)>
			<cfset work_head_list=listsort(work_head_list,"numeric","ASC",",")>
			<cfquery name="get_work" datasource="#dsn#">
				SELECT WORK_ID,WORK_HEAD FROM PRO_WORKS WHERE WORK_ID IN (#work_head_list#) ORDER BY WORK_ID
			</cfquery>
			<cfset work_head_list = ListSort(ListDeleteDuplicates(ValueList(get_work.work_id)),'numeric','ASC',',')>
		</cfif>
		<cfif len(opp_head_list)>
			<cfset opp_head_list=listsort(opp_head_list,"numeric","ASC",",")>
			<cfquery name="get_opportunities" datasource="#DSN3#">
				SELECT OPP_ID,OPP_HEAD FROM OPPORTUNITIES WHERE OPP_ID IN (#opp_head_list#) ORDER BY OPP_ID
			</cfquery>
			<cfset opp_head_list = ListSort(ListDeleteDuplicates(ValueList(get_opportunities.opp_id)),'numeric','ASC',',')>
		</cfif>
		<cfoutput query="get_rows">
			<cfset total_value_ = 0>
			<cfset net_total_value_ = 0>
			<cfset other_net_total_value_ = 0>
			<cfset deger_money = "">
			<cfset activity_type_ = "">
			<cfset workgroup_id_ = "">
			<cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id)><!--- Butceden Donustuyse --->
				<cfset total_value_ = row_total_expense>
				<cfset net_total_value_ = row_total_expense>
				<cfset other_net_total_value_ = other_row_total_expense>
				<cfset deger_money = get_money_rate.money_type>
				<cfset activity_type_ = activity_type_id>
				<cfset workgroup_id_ = workgroup_id>
			<cfelseif isdefined("attributes.credit_contract_id") and len(attributes.credit_contract_id)><!--- Kredi Fon Yonetiminden Donustuyse --->
				<cfif type eq 0>
					<cfset other_net_total_value_ = interest_price>
					<cfset total_value_ = interest_price*rate2>
					<cfset net_total_value_ = interest_price*rate2>
				<cfelse>
					<cfset other_net_total_value_ = capital_price>
					<cfset total_value_ = capital_price*rate2>
					<cfset net_total_value_ = capital_price*rate2>
				</cfif>
				<cfset deger_money = other_money>
				<cfset activity_type_ = "">
				<cfset workgroup_id_ = "">
			<cfelseif isdefined("attributes.expense_id") and len(attributes.expense_id)><!--- Masraf Kopyalama Ise --->
				<cfset total_value_ = amount>
				<cfset net_total_value_ = total_amount>
				<cfset other_net_total_value_ = other_money_gross_total>
				<cfset deger_money = money_currency_id>
				<cfset activity_type_ = activity_type>
				<cfset workgroup_id_ = workgroup_id>
			<cfelseif isdefined("attributes.request_id") and len(attributes.request_id)><!--- Harcama Talebinden Donustuyse --->
				<cfset total_value_ = amount>
				<cfset net_total_value_ = total_amount>
				<cfset other_net_total_value_ = other_money_value>
				<cfset deger_money = money_currency_id>
				<cfset activity_type_ = activity_type>
				<cfset workgroup_id_ = "">
			</cfif>
			<tr id="frm_row#currentrow#" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td><cfif isdefined("attributes.budget_plan_id") and len(attributes.budget_plan_id) or (isdefined("attributes.expense_id") and len(attributes.expense_id) and len(budget_plan_row_id))>
						<input type="hidden" name="budget_plan_row_id#currentrow#" id="budget_plan_row_id#currentrow#" value="#budget_plan_row_id#">
					</cfif>
					<input type="hidden" name="credit_type#currentrow#" id="credit_type#currentrow#" value="<cfif isdefined("get_rows.type")>#get_rows.type#<cfelse>1</cfif>">
					<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1" title="#detail#">
					<a href="javascript://" onClick="sil('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a>
					<a style="cursor:pointer" onclick="copy_row('#currentrow#');" title="Satır Kopyala"><img  src="images/copy_list.gif" border="0"></a>
				</td>
				<cfif x_is_showing_exp_date eq 1>
					<td nowrap="nowrap">
						<input type="text" name="expense_date#currentrow#" id="expense_date#currentrow#" style="width:65px;" value="<cfif isdefined("get_rows.expense_date") and len(get_rows.expense_date)>#dateformat(get_rows.expense_date,dateformat_style)#<cfelseif isdefined("get_expense.expense_date") and len(get_expense.expense_date) >#dateformat(get_expense.expense_date,dateformat_style)#</cfif>" title="#detail#">
						<cf_wrk_date_image date_field="expense_date#currentrow#">
					</td>
				</cfif>
				<td><input type="text" name="row_detail#currentrow#" id="row_detail#currentrow#" value="#detail#" class="boxtext" style="width:100%;" title="#detail#"></td>
				<cfif x_is_project_priority eq 0>
					<td nowrap>
						<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#expense_center_id#">
						<input type="text" id="expense_center_name#currentrow#" name="expense_center_name#currentrow#" value="<cfif len(expense_center_id)>#get_expense_center.expense[listfind(expense_center_list,expense_center_id,',')]#</cfif>" class="boxtext" style="width:230px;" onFocus="AutoComplete_Create('expense_center_name#currentrow#','EXPENSE','EXPENSE','get_expense_center','','EXPENSE_ID','expense_center_id#currentrow#','add_costplan',1);" autocomplete="off">
						<a href="javascript://" onClick="pencere_ac_exp('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
					</td>
					<td nowrap>
						<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id#">
						<input type="text" id="expense_item_name#currentrow#" name="expense_item_name#currentrow#" value="<cfif len(expense_item_id)>#get_expense_item.expense_item_name[listfind(expense_item_list,expense_item_id,',')]#</cfif>" class="boxtext" style="width:230px;" onFocus="AutoComplete_Create('expense_item_name#currentrow#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID,ACCOUNT_CODE','expense_item_id#currentrow#,account_code#currentrow#','add_costplan',1);" autocomplete="off">
						<a href="javascript://" onClick="pencere_ac_item('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
					</td>
					<cfif x_is_showing_account_code eq 1>
						<td nowrap>
							<input type="text" readonly name="account_code#currentrow#" id="account_code#currentrow#" value="<cfif len(expense_account_code)>#expense_account_code#<cfelseif len(expense_item_id)>#get_expense_item.account_code[listfind(expense_item_list,expense_item_id,',')]#</cfif>" style="width:150px;" class="boxtext" title="#detail#">
							<a href="javascript://" onclick="pencere_ac_acc('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
						</td>
					<cfelse>
						<input type="hidden" name="account_code#currentrow#" id="account_code#currentrow#" value="<cfif len(expense_account_code)>#expense_account_code#<cfelseif len(expense_item_id)>#get_expense_item.account_code[listfind(expense_item_list,expense_item_id,',')]#</cfif>" style="width:150px;" class="boxtext" readonly="yes" title="#detail#">
					</cfif>
				<cfelse>
					<input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#expense_center_id#">
					<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#expense_item_id#">
					<input type="hidden" id="expense_center_name#currentrow#" name="expense_center_name#currentrow#" value="<cfif len(expense_center_id)>#get_expense_center.expense[listfind(expense_center_list,expense_center_id,',')]#</cfif>">
					<input type="hidden" id="expense_item_name#currentrow#" name="expense_item_name#currentrow#" value="<cfif len(expense_item_id)>#get_expense_item.expense_item_name[listfind(expense_item_list,expense_item_id,',')]#</cfif>">
					<input type="hidden" name="account_code#currentrow#" id="account_code#currentrow#" value="<cfif len(expense_account_code)>#expense_account_code#<cfelseif len(expense_item_id)>#get_expense_item.account_code[listfind(expense_item_list,expense_item_id,',')]#</cfif>" style="width:150px;" class="boxtext" readonly="yes" title="#detail#">
				</cfif>
				<cfif x_is_showing_physical_asset eq 1 and fuseaction contains "assetcare">
					<td><input type="hidden" name="asset_id#currentrow#" id="asset_id#currentrow#" value="<cfif isdefined("pyschical_asset_id") and len(pyschical_asset_id)>#pyschical_asset_id#</cfif>">
						<input type="text" name="asset#currentrow#" id="asset#currentrow#" value="<cfif isdefined("pyschical_asset_id") and len(pyschical_asset_id)>#get_pyschical_asset.assetp[ListFind(pyschical_asset_list,pyschical_asset_id,',')]#</cfif>" style="width:120px;" class="boxtext" onFocus="AutoComplete_Create('asset#currentrow#','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID','asset_id#currentrow#','add_costplan','3','140');" autocomplete="off" title="#detail#">
						<a href="javascript://" onClick="pencere_ac_asset('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
					</td>
				</cfif>
				<cfif x_is_project_priority eq 1>
					<td><input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="<cfif isdefined("project_id") and len(project_id)>#project_id#</cfif>">
						<input type="text" name="project#currentrow#" id="project#currentrow#" value="<cfif isdefined("project_id") and len(project_id)>#get_project_name(project_id)#</cfif>" style="width:110px;" class="boxtext" title="#detail#">
						<a href="javascript://" onClick="pencere_ac_project('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
					</td>
				</cfif>
				<cfif x_is_showing_product eq 1 or x_is_project_priority eq 1>
					<td  nowrap="nowrap" style="text-align:right;">
						<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>#stock_id_2#<cfelseif isdefined("attributes.request_id") and len(attributes.request_id)>#stock_id#</cfif>">
						<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="<cfif isdefined("product_id") and len(product_id)>#product_id#</cfif>">
						<input type="text" name="product_name#currentrow#" id="product_name#currentrow#" value="<cfif isdefined("product_id") and len(product_id)>#get_product_name(product_id)#</cfif>" style="width:160px;" class="boxtext">
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid='+document.getElementById('product_id#currentrow#').value+'&sid='+document.getElementById('stock_id#currentrow#').value+'','list');"><img border="0" align="middle" src="/images/plus_thin_p.gif" id="product_info#currentrow#" style="display:none" title="<cf_get_lang no='458.Ürün Detay'>"></a>
						<a href="javascript://" onClick="pencere_ac_product('#currentrow#');"><img border="0" align="middle" src="/images/plus_thin.gif"></a>
					</td>
				</cfif>
				<cfif x_is_showing_unit eq 1>
					<td><input type="hidden" name="stock_unit_id#currentrow#" id="stock_unit_id#currentrow#" value="<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>#unit_id#</cfif>">
						<input type="text" name="stock_unit#currentrow#" id="stock_unit#currentrow#" class="boxtext" value="<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>#unit#</cfif>" readonly="yes" style="width:40px;">
					</td>
				</cfif>
				<td><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" style="width:100%;" class="box" value="<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>#TLFormat(quantity,session.ep.our_company_info.rate_round_num)#<cfelse>1</cfif>" onBlur="hesapla('#currentrow#');" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));"></td>
				<td><input type="text" name="total#currentrow#" id="total#currentrow#" value="#TLFormat(total_value_,session.ep.our_company_info.rate_round_num)#" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" style="width:75;" onBlur="hesapla('#currentrow#');" class="box" title="#detail#">&nbsp;</td>
				<td><select name="tax_rate#currentrow#" id="tax_rate#currentrow#" style="width:100%;" class="box" onChange="hesapla('#currentrow#');">
						<cfif isdefined("kdv_rate")><cfset kdvdeger = kdv_rate><cfelse><cfset kdvdeger = ""></cfif>
						<cfloop query="get_tax">
							<option value="#tax#" <cfif kdvdeger eq tax>selected</cfif>>#tax#</option>
						</cfloop>
					</select>
				</td>
				<td><input type="text" name="otv_rate#currentrow#" id="otv_rate#currentrow#" value="<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>#otv_rate#<cfelse>0</cfif>0" onKeyUp="return(FormatCurrency(this,event,0));" style="width:100%;" onBlur="hesapla('#currentrow#');" class="box" title="#detail#"></td>
				<td><input type="text" name="kdv_total#currentrow#" id="kdv_total#currentrow#" value="<cfif (isdefined("attributes.expense_id") and len(attributes.expense_id)) or (isdefined("attributes.request_id") and len(attributes.request_id))>#TLFormat(amount_kdv,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(0,session.ep.our_company_info.rate_round_num)#</cfif>" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" style="width:100%;" onBlur="hesapla('#currentrow#',1);" class="box" title="#detail#"></td>
				<td><input type="text" name="otv_total#currentrow#" id="otv_total#currentrow#" value="<cfif isdefined("attributes.expense_id") and len(attributes.expense_id)>#TLFormat(amount_otv,session.ep.our_company_info.rate_round_num)#<cfelse>#TLFormat(0,session.ep.our_company_info.rate_round_num)#</cfif>" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" style="width:100%;" onBlur="hesapla('#currentrow#',1);" class="box" title="#detail#"></td>
				<td><input type="text" name="net_total#currentrow#" id="net_total#currentrow#" value="#TLFormat(net_total_value_,session.ep.our_company_info.rate_round_num)#" onKeyUp="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" style="width:100%;" onBlur="hesapla('#currentrow#',2);" class="box" title="#detail#"></td>
				<td><select name="money_id#currentrow#" id="money_id#currentrow#" style="width:100%;" class="boxtext" onChange="other_calc('#currentrow#');" title="#detail#">
						<cfloop query="get_money">
							<cfif isdefined("money")><cfset money_ = money><cfelse><cfset money_money_type></cfif>
							<option value="#money_#,#rate1#,#rate2#" <cfif deger_money eq money_>selected</cfif>>#money_#</option>
						</cfloop>
					</select>
				</td>
				<td><input type="text" name="other_net_total#currentrow#" id="other_net_total#currentrow#" value="#TLFormat(other_net_total_value_,session.ep.our_company_info.rate_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="other_calc('#currentrow#');" style="width:100%;" class="box" title="#detail#"></td>
				<cfif x_is_showing_activity_type eq 1>
					<td><select name="activity_type#currentrow#" id="activity_type#currentrow#" style="width:100%;" class="boxtext">
							<option value=""><cf_get_lang dictionary_id='33167.Akitivite Tipi'></option>
							<cfloop query="get_activity_types">
								<option value="#activity_id#" <cfif activity_type_ eq activity_id>selected</cfif>>#activity_name#</option>
							</cfloop>
						</select>
					</td>
				</cfif>
				<cfif x_is_showing_work_group eq 1>
				<td><select name="workgroup_id#currentrow#" id="workgroup_id#currentrow#" style="width:100%;" class="boxtext">
						<option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
						<cfloop query="get_workgroups">
							<option value="#workgroup_id#" <cfif workgroup_id_ eq workgroup_id>selected</cfif>>#workgroup_name#</option>
						</cfloop>
					</select>
				</td>
				</cfif>
				<cfif x_is_showing_work_head eq 1>
					<td><input type="hidden" class="boxtext" name="work_id#currentrow#" id="work_id#currentrow#" value="#work_id#">
						<input name="work_head#currentrow#" id="work_head#currentrow#" type="text" class="boxtext" style="width:124px;" value="<cfif len(work_id)>#get_work.work_head[listfind(work_head_list,work_id,',')]#</cfif>">
						<cfif len(work_id)><a href="javascript://" onclick="pencere_detail_work(#currentrow#);"><img src="/images/plus_thin_p.gif" title="<cf_get_lang dictionary_id='55061.iş detayı'>"align="absmiddle" border="0"></a><cfelse>&nbsp;&nbsp;&nbsp;</cfif>
						<a href="javascript://" onClick="pencere_ac_work('#currentrow#');"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='58691.iş listesi'>" align="absmiddle" border="0"></a>
					</td>
				</cfif>
				<cfif x_is_showing_opportunities_head eq 1>
					<td><input type="hidden" class="boxtext" name="opp_id#currentrow#" id="opp_id#currentrow#" value="#opp_id#">
						<input type="text" name="opp_head#currentrow#" id="opp_head#currentrow#" class="boxtext" style="width:132px;" value="<cfif len(opp_id)>#get_opportunities.opp_head[listfind(opp_head_list,opp_id,',')]#</cfif>">
						<a href="javascript://" onClick="pencere_ac_oppotunity('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
					</td>
				</cfif>
				<cfif x_is_showing_project eq 1 and x_is_project_priority eq 0>
					<td><input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="<cfif isdefined("project_id") and len(project_id)>#project_id#</cfif>">
						<input type="text" name="project#currentrow#" id="project#currentrow#" value="<cfif isdefined("project_id") and len(project_id)>#get_project_name(project_id)#</cfif>" autocomplete="off" style="width:115px;" class="boxtext" title="#detail#">
						<a href="javascript://" onClick="pencere_ac_project('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
					</td>
				</cfif>
				<cfif x_is_showing_system eq 1>
					<td nowrap="nowrap">
						<input type="hidden" name="subscription_id#currentrow#" id="subscription_id#currentrow#" value="<cfif isdefined("subscription_id") and len(subscription_id)>#subscription_id#</cfif>">
						<input type="text" name="subscription_name#currentrow#" id="subscription_name#currentrow#" value="<cfif isdefined("subscription_id") and len(subscription_id)>#get_subscription.subscription_no[ListFind(subscription_list,subscription_id,',')]#</cfif>" style="width:120px;" class="boxtext" title="#detail#">
						<a href="javascript://" onClick="pencere_ac_subs('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
					</td>
				</cfif>
				<td><cfif isdefined("member_type") and member_type eq 'partner'>
						<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="partner">
						<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#company_partner_id#">
						<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
						<input type="text" name="authorized#currentrow#" id="authorized#currentrow#"  value="#get_par_info(company_partner_id,0,-1,0)#" style="width:115px;" class="boxtext" title="#detail#">&nbsp;
						<input type="text" name="company#currentrow#" id="company#currentrow#" onFocus="AutoComplete_Create('company#currentrow#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','member_type#currentrow#,member_id#currentrow#,company_id#currentrow#','','3','150');" value="#get_par_info(company_id,1,0,0)#" style="width:115px;" class="boxtext" title="#detail#">
					<cfelseif isdefined("member_type") and member_type eq 'consumer'>
						<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="consumer">
						<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#company_partner_id#">
						<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
						<input type="text" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_cons_info(company_partner_id,0,0)#" style="width:115px;" class="boxtext" title="#detail#">&nbsp;
						<input type="text" name="company#currentrow#" id="company#currentrow#" value="#get_cons_info(company_partner_id,2,0)#" style="width:115px;" class="boxtext" title="#detail#">
					<cfelseif isdefined("member_type") and member_type eq 'employee'>
						<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="employee">
						<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#company_partner_id#">
						<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
						<input type="text" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_emp_info(company_partner_id,0,0)#" style="width:115px;" class="boxtext" title="#detail#">&nbsp;
						<input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:115px;" class="boxtext" title="#detail#">
					<cfelse>
						<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="">
						<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="">
						<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
						<input type="text" style="width:110px;" name="authorized#currentrow#" id="authorized#currentrow#" value="" class="boxtext" title="#detail#">&nbsp;
						<input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:110px;" class="boxtext" title="#detail#">
					</cfif>
					<a href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
				</td>
				<cfif x_is_showing_physical_asset eq 1 and fuseaction contains "cost.">
					<td><input type="hidden" name="asset_id#currentrow#" id="asset_id#currentrow#" value="<cfif isdefined("pyschical_asset_id") and len(pyschical_asset_id)>#pyschical_asset_id#</cfif>">
						<input type="text" name="asset#currentrow#" id="asset#currentrow#" value="<cfif isdefined("pyschical_asset_id") and len(pyschical_asset_id)>#get_pyschical_asset.assetp[ListFind(pyschical_asset_list,pyschical_asset_id,',')]#</cfif>" style="width:120px;" class="boxtext" onFocus="AutoComplete_Create('asset#currentrow#','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID','asset_id#currentrow#','add_costplan','3','140');" autocomplete="off" title="#detail#">
						<a href="javascript://" onClick="pencere_ac_asset('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
					</td>
				</cfif>
			</tr>
		</cfoutput>
	</cfif>
</table>
