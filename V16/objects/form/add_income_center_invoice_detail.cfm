<div style="display:none;z-index:10;" id="wizard_div"></div>
<cfinclude template="../query/get_invoice_cats.cfm">
<cfquery name="GET_INVOICE_ROW" datasource="#dsn2#">
	SELECT 
		INVOICE_ROW.GROSSTOTAL,
		INVOICE_ROW.NAME_PRODUCT, 
		INVOICE_ROW.INVOICE_ROW_ID,
		INVOICE_ROW.STOCK_ID,
		INVOICE.INVOICE_DATE,
		INVOICE_ROW.TAXTOTAL,
		INVOICE_ROW.OTVTOTAL,
		ISNULL(INVOICE_ROW.BSMV_AMOUNT,0) BSMVTOTAL,
		ISNULL(INVOICE_ROW.OIV_AMOUNT,0) OIVTOTAL,
		ISNULL(INVOICE_ROW.TEVKIFAT_AMOUNT,0) TEVKIFATTOTAL,
		INVOICE_ROW.OTV_ORAN,
		INVOICE_ROW.TAX,
		ISNULL(INVOICE_ROW.BSMV_RATE,0) BSMV_ORAN,
		ISNULL(INVOICE_ROW.OIV_RATE,0) OIV_ORAN,
		ISNULL(INVOICE_ROW.TEVKIFAT_RATE,0) TEVKIFAT_ORAN,
		INVOICE_ROW.STOCK_ID,
		INVOICE_ROW.INVOICE_ID,
		INVOICE_ROW.UNIT,
		INVOICE_ROW.AMOUNT,
		INVOICE_ROW.PRODUCT_ID,
		INVOICE_ROW.NETTOTAL,
		INVOICE_ROW.OTHER_MONEY,
		INVOICE_ROW.OTHER_MONEY_VALUE,
		INVOICE_ROW.OTHER_MONEY_GROSS_TOTAL,
		INVOICE_ROW.DISCOUNTTOTAL,
		INVOICE.INVOICE_NUMBER,
		INVOICE.COMPANY_ID,
		INVOICE.PARTNER_ID,
		INVOICE.CONSUMER_ID,
		INVOICE.INVOICE_ID,
		INVOICE.DEPARTMENT_ID,
		INVOICE.SUBSCRIPTION_ID,
		INVOICE_ROW.SUBSCRIPTION_ID ROW_SUBSCRIPTION_ID	,
		ISNULL(INVOICE.PROCESS_DATE,INVOICE.INVOICE_DATE) AS PROCESS_DATE
	FROM 
		INVOICE_ROW,
		INVOICE
	WHERE 
		INVOICE_ROW_ID = #attributes.invoice_row_id# AND
		INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID
</cfquery>
<cfif GET_INVOICE_ROW.recordCount eq 0>
	<cfset hata  = 10>
	<cfinclude template="../../dsp_hata.cfm">
    <cfabort>
</cfif>
<cfquery name="GET_PRODUCT_PER" datasource="#dsn3#">
	SELECT INCOME_TEMPLATE_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_invoice_row.product_id# AND PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfif len(get_invoice_row.other_money)>
	<cfquery name="GET_MONEY" datasource="#dsn#">
		SELECT RATE2, RATE1, (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY = '#get_invoice_row.other_money#' AND PERIOD_ID = #session.ep.period_id#
	</cfquery>
</cfif>
<cfif not isdefined("GET_MONEY") or GET_MONEY.recordcount eq 0>
	<cfset GET_MONEY.RATE = 1>
	<cfset GET_MONEY.RATE1 = 1>
	<cfset GET_MONEY.RATE2 = 1>
</cfif>
<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>
<cfquery name="GET_WORKGROUPS" datasource="#dsn#">
	SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY WORKGROUP_NAME
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_NAME, EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE INCOME_EXPENSE = 1 AND IS_ACTIVE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE, EXPENSE_ID, EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ACTIVE = 1 ORDER BY EXPENSE_CODE
</cfquery>
<cfscript>
	expense_amount=get_invoice_row.discounttotal;
	expense_amount_kdv=(expense_amount*get_invoice_row.tax)/100;
	expense_amount_tevkifat = expense_amount_kdv*get_invoice_row.tevkifat_oran;
	expense_amount_otv=(expense_amount*get_invoice_row.otv_oran)/100;
	expense_amount_bsmv=(expense_amount*get_invoice_row.bsmv_oran)/100;
	expense_amount_oiv=(expense_amount*get_invoice_row.OIV_ORAN)/100;
	expense_amount_total=expense_amount+( expense_amount_kdv - expense_amount_tevkifat) +expense_amount_otv + expense_amount_bsmv + expense_amount_oiv;
</cfscript>
<cfset components2 = createObject('component','V16.workdata.get_budget_period_date')>
<cfset budget_date = components2.get_budget_period_date()>
<cfsavecontent  variable="right">
	<div id = "tabMenu">
		<a href = "#" onClick = "open_wizard();"><cf_get_lang dictionary_id='59935.Planlama Sihirbazı'></a>
	</div>
</cfsavecontent>
<cf_box title="#getLang('','Ayrıntılı Gelir Dağıtımı',32702)#" right_images = "#right#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_collacted_expense_rows" action="#request.self#?fuseaction=objects.emptypopup_add_income_center_invoce_detail" method="post">
		<cfinput type="hidden" name="budget_period" id="budget_period" value="#dateformat(budget_date.budget_period_date,dateformat_style)#">
		<input type="hidden" name="invoice_row_id" id="invoice_row_id" value="<cfoutput>#attributes.invoice_row_id#</cfoutput>">
		<input type="hidden" name="name_product" id="name_product" value="<cfoutput>#get_invoice_row.name_product#</cfoutput>">
		<input type="hidden" name="invoice_number" id="invoice_number" value="<cfoutput>#get_invoice_row.invoice_number#</cfoutput>">
		<input type="hidden" name="expense_date" id="expense_date" value="<cfoutput>#dateformat(get_invoice_row.process_date,dateformat_style)#</cfoutput>">
		<input type="hidden" name="page_type" id="page_type" value="<cfif ListLen(list_fat) and ListLen(list_cat)><cfoutput>#ListGetAt(list_fat,listFind(list_cat,url.invoice_cat))#</cfoutput></cfif>">
		<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#get_invoice_row.stock_id#</cfoutput>">	
		<input type="hidden" name="invoice_id" id="invoice_id" value="<cfoutput>#get_invoice_row.invoice_id#</cfoutput>">
		<input type="hidden" name="grosstotal" id="grosstotal" value="<cfoutput>#tlformat(get_invoice_row.grosstotal)#</cfoutput>">
		<input type="hidden" name="discount_grosstotal" id="discount_grosstotal" value="<cfoutput>#tlformat(expense_amount_total)#</cfoutput>">  
		<input type="hidden" name="invoice_cat" id="invoice_cat" value="<cfoutput>#url.invoice_cat#</cfoutput>">
		<cfoutput>
			<cf_box_search>
				<div class="form-group">
					<cf_get_lang dictionary_id='57519.Cari Hesap'>
						<cfif len(get_invoice_row.company_id)>#get_par_info(get_invoice_row.company_id,1,1,0)#<cfelseif len(get_invoice_row.consumer_id)>#get_cons_info(get_invoice_row.consumer_id,1,0)#</cfif><cfif len(get_invoice_row.partner_id)> - #get_par_info(get_invoice_row.partner_id,0,-1,0)#</cfif>
				</div>
				<div class="form-group">
					<cf_get_lang dictionary_id='58133.Fatura No'>
						#get_invoice_row.invoice_number#
				</div>
				<div class="form-group">
					<cf_get_lang dictionary_id='58759.Fatura Tarihi'>
						#dateformat(get_invoice_row.invoice_date,dateformat_style)#
				</div>
				<div class="form-group">
					<cf_get_lang dictionary_id='57657.Ürün'>
						#get_invoice_row.name_product#
				</div>
				<div class="form-group">
					<cf_get_lang dictionary_id='57635.Miktar'>
						#get_invoice_row.amount# #get_invoice_row.unit#
				</div>
				<div class="form-group">
					<cf_get_lang dictionary_id='57492.Toplam'>
						#TLFormat(get_invoice_row.grosstotal,2)#
				</div>
				<div class="form-group">
					<cf_get_lang dictionary_id='57641.İskonto'>
						#TLFormat(expense_amount_total,2)#
				</div>
			</cf_box_search>
		</cfoutput>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><a onClick="add_row('');"><i class="fa fa-plus" title="Ekle"></i></a></th>
					<th width="100"><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th width="150"><cf_get_lang dictionary_id='58172.Gelir Merkezi'></th>
					<th width="150"><cf_get_lang dictionary_id='58173.Gelir Kalemi'></th>
					<th width="100"><cf_get_lang dictionary_id='33167.Aktivite Tipi'></th>
					<th width="100"><cf_get_lang dictionary_id='58140.İş Grubu'></th>
					<th width="200"><cf_get_lang dictionary_id='33008.Satış Yapan'></th>
					<th width="150"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></th>
					<th width="150"><cf_get_lang dictionary_id='29502.Abone No'></th>
					<th width="150"><cf_get_lang dictionary_id='57416.Proje'></th>
					<th width="50">%</th>
					<th width="50"><cf_get_lang dictionary_id='57673.Tutar'></th>
				</tr>
			</thead>
			<tbody id="table1">
				<cfset toplam_rate = 0>
				<cfset toplam_amount = 0>
				<cfif len(get_product_per.income_template_id)>
					<cfquery name="GET_EXPENSE_TEMPLATE" datasource="#dsn2#">
						SELECT 
							EXPENSE_PLANS_TEMPLATES_ROWS.EXPENSE_ITEM_ID, 
							EXPENSE_PLANS_TEMPLATES_ROWS.EXPENSE_CENTER_ID,
							EXPENSE_PLANS_TEMPLATES_ROWS.RATE,
							EXPENSE_PLANS_TEMPLATES_ROWS.MEMBER_TYPE,
							EXPENSE_PLANS_TEMPLATES_ROWS.COMPANY_PARTNER_ID,
							EXPENSE_PLANS_TEMPLATES_ROWS.COMPANY_ID,
							EXPENSE_PLANS_TEMPLATES_ROWS.ASSET_ID,
							EXPENSE_PLANS_TEMPLATES_ROWS.PROJECT_ID,
							EXPENSE_PLANS_TEMPLATES_ROWS.PROMOTION_ID
						FROM 
							EXPENSE_PLANS_TEMPLATES,
							EXPENSE_PLANS_TEMPLATES_ROWS
						WHERE
							EXPENSE_PLANS_TEMPLATES.TEMPLATE_ID = #get_product_per.income_template_id# AND
							EXPENSE_PLANS_TEMPLATES.TEMPLATE_ID = EXPENSE_PLANS_TEMPLATES_ROWS.TEMPLATE_ID
							AND (EXPENSE_PLANS_TEMPLATES.IS_DEPARTMENT=0 <cfif len(GET_INVOICE_ROW.DEPARTMENT_ID)>OR (EXPENSE_PLANS_TEMPLATES.IS_DEPARTMENT=1 AND EXPENSE_PLANS_TEMPLATES_ROWS.DEPARTMENT_ID=#GET_INVOICE_ROW.DEPARTMENT_ID#)</cfif>)
					</cfquery>
					<cfif get_expense_template.recordcount>
						<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_expense_template.recordcount#</cfoutput>">
					<cfelse>
						<input type="hidden" name="record_num" id="record_num" value="0">
					</cfif>
					<cfoutput query="get_expense_template">
					<cfif len(ASSET_ID)>
						<cfquery name="GET_ROW_ASSET" datasource="#dsn#">
							SELECT
								ASSETP_ID,
								ASSETP
							FROM
								ASSET_P
							WHERE
								ASSETP_ID = #ASSET_ID#
						</cfquery>
					</cfif>
					<cfif len(PROJECT_ID)>
						<cfquery name="GET_ROW_PROJECT" datasource="#dsn#">	
							SELECT
								PROJECT_ID,
								PROJECT_HEAD
							FROM 
								PRO_PROJECTS
							WHERE
								PROJECT_ID=#PROJECT_ID#
						</cfquery>
					</cfif>
					<input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#get_invoice_row.other_money#">
					<input type="hidden" name="grosstotal#currentrow#" id="grosstotal#currentrow#" value="#tlformat(get_invoice_row.grosstotal)#">	
					<input type="hidden" name="nettotal#currentrow#" id="nettotal#currentrow#" value="#tlformat(get_invoice_row.nettotal)#">	
					<input type="hidden" name="taxtotal#currentrow#" id="taxtotal#currentrow#" value="#tlformat(get_invoice_row.taxtotal)#">
					<input type="hidden" name="otvtotal#currentrow#" id="otvtotal#currentrow#" value="#tlformat(get_invoice_row.otvtotal)#">
					<input type="hidden" name="bsmvtotal#currentrow#" id="bsmvtotal#currentrow#" value="#tlformat(get_invoice_row.bsmvtotal)#">
					<input type="hidden" name="oivtotal#currentrow#" id="oivtotal#currentrow#" value="#tlformat(get_invoice_row.oivtotal)#">
					<input type="hidden" name="tevkifattotal#currentrow#" id="tevkifattotal#currentrow#" value="#tlformat(get_invoice_row.tevkifattotal)#">
					<input type="hidden" name="otv_oran#currentrow#" id="otv_oran#currentrow#" value="#get_invoice_row.otv_oran#">
					<input type="hidden" name="tax#currentrow#" id="tax#currentrow#" value="#get_invoice_row.tax#">
					<input type="hidden" name="bsmv_oran#currentrow#" id="bsmv_oran#currentrow#" value="#get_invoice_row.bsmv_oran#">
					<input type="hidden" name="oiv_oran#currentrow#" id="oiv_oran#currentrow#" value="#get_invoice_row.oiv_oran#">
					<input type="hidden" name="tevkifat_oran#currentrow#" id="tevkifat_oran#currentrow#" value="#get_invoice_row.tevkifat_oran#">
					<input type="hidden" name="other_money_value#currentrow#" id="other_money_value#currentrow#" value="#tlformat(get_invoice_row.other_money_value)#">
					<input type="hidden" name="other_money_grosstotal#currentrow#" id="other_money_grosstotal#currentrow#" value="#tlformat(get_invoice_row.other_money_gross_total)#">
					<input type="hidden" name="rate_value_one#currentrow#" id="rate_value_one#currentrow#" value="<cfif isdefined("get_money.rate1")>#tlformat(get_money.rate1)#<cfelse>1</cfif>">	
					<input type="hidden" name="rate_value_two#currentrow#" id="rate_value_two#currentrow#" value="<cfif isdefined("get_money.rate2")>#tlformat(get_money.rate2)#<cfelse>1</cfif>">	
					<tr id="frm_row#currentrow#">
						<td><input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"  value="1"><a style="cursor:pointer" onclick="sil('#currentrow#','');"><img  src="images/delete_list.gif" border="0"></a></td>
						<td style = "width:85px;">
							<input type = "text" id = "expense_date#currentrow#" name = "expense_date#currentrow#" style = "width:65px;" value = "#dateformat(expense_date,dateformat_style)#">
							<cf_wrk_date_image date_field="expense_date#currentrow#">
						</td>
						<td>
							<select name="expense_center_ids#currentrow#" id="expense_center_ids#currentrow#" style="width:150px;">
							<cfset template_center = get_expense_template.expense_center_id>
							<option value=""><cf_get_lang dictionary_id='58172.Gelir Merkezi'></option>
							<cfloop query="get_expense_center">
								<option value="#expense_id#" <cfif listfind(template_center eq expense_id,EXPENSE_ID,',')>selected</cfif>>
									<cfloop from="2" to="#ListLen(EXPENSE_CODE,".")#" index="i">&nbsp;&nbsp;</cfloop>#expense#
								</option>
							</cfloop>
						</select></td>
						<td><select name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" style="width:150px;">
							<option value=""><cf_get_lang dictionary_id='58173.Gelir Kalemi'></option>
							<cfset template_item = get_expense_template.expense_item_id>
							<cfloop query="get_expense_item">
							<option value="#expense_item_id#" <cfif template_item eq expense_item_id>selected</cfif>>#expense_item_name#</option>
							</cfloop>
							</select>
						</td>
						<td>
							<select name="activity_type#currentrow#" id="activity_type#currentrow#" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='51319.Aktivite Tipi'></option>
								<cfloop from="1" to="#get_activity_types.recordcount#" index="satir"><option value="#get_activity_types.activity_id[satir]#" <cfif len(get_expense_template.PROMOTION_ID) and get_activity_types.activity_id[satir] eq get_expense_template.PROMOTION_ID>selected</cfif>>#get_activity_types.activity_name[satir]#</option></cfloop>
							</select>
						</td>
						<td>
							<select name="workgroup_id#currentrow#" id="workgroup_id#currentrow#" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
								<cfloop from="1" to="#get_workgroups.recordcount#" index="satir"><option value="#get_workgroups.workgroup_id[satir]#" <cfif len(get_expense_template.PROMOTION_ID) and get_workgroups.workgroup_id[satir] eq get_expense_template.PROMOTION_ID>selected</cfif>>#get_workgroups.workgroup_name[satir]#</option></cfloop>
							</select>
						</td>
						<cfif member_type eq 'employee'>
							<cfquery name="get_emp_id" datasource="#dsn#">
								SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#company_partner_id#
							</cfquery>
							<td>
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="employee">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#get_emp_id.EMPLOYEE_ID#">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="#company_partner_id#">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:100px;" class="txt">
								<input type="text" style="width:100px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_emp_info(company_partner_id,1,0)#" class="txt"><a href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
							</td>
						<cfelseif member_type eq 'partner'>
							<td>
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="partner">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#company_partner_id#">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="#get_par_info(company_id,1,0,0)#" style="width:100px;" class="txt">
								<input type="text" style="width:100px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_par_info(company_partner_id,0,-1,0)#" class="txt"><a href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
							</td>
						<cfelseif member_type eq 'consumer'>
							<td>
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="consumer">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#company_partner_id#">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:100px;" class="txt">
								<input type="text" style="width:100px;" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_cons_info(company_partner_id,2,0)#" class="txt"><a href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
							</td>
						<cfelse>
							<td>
								<input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="">
								<input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="">
								<input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
								<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
								<input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:100px;">
								<input type="text" style="width:100px;" name="authorized#currentrow#" id="authorized#currentrow#" value=""><a href="javascript://" onClick="pencere_ac_company('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
							</td>
						</cfif>
						<td><input type="hidden" name="asset_id#currentrow#" id="asset_id#currentrow#" value="#ASSET_ID#">
							<input type="text" name="asset#currentrow#" id="asset#currentrow#" value="<cfif len(ASSET_ID)>#GET_ROW_ASSET.ASSETP#</cfif>" style="width:100px;"><a href="javascript://" onClick="pencere_ac_asset('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a></td>
						<td nowrap="nowrap">
							<input type="hidden" name="subscription_id#currentrow#" id="subscription_id#currentrow#" value="">
							<input type="text" name="subscription_name#currentrow#" id="subscription_name#currentrow#" onFocus="AutoComplete_Create('subscription_name#currentrow#','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id#currentrow#','','3','150');" value="" style="width:100px;">
							<a href="javascript://" onClick="pencere_ac_subs('#currentrow#','');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
						</td>
						<td><input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#"  value="#PROJECT_ID#">
							<input type="text" name="project#currentrow#" id="project#currentrow#" value="<cfif len(PROJECT_ID)>#GET_ROW_PROJECT.PROJECT_HEAD#</cfif>" style="width:100px;"><a href="javascript://" onClick="pencere_ac_project('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a></td>
						<td><input type="text" name="expense_item_value#currentrow#" id="expense_item_value#currentrow#" style="width:40px;" onBlur="toplam_center('');" value="#tlformat(rate)#" class="moneybox"></td>
						<td><input type="text" name="total_expense_item#currentrow#" id="total_expense_item#currentrow#" value="#tlformat((rate*get_invoice_row.grosstotal)/100)#" style="width:75px;" maxlength="3" onBlur="toplam_center2('');" class="moneybox"></td>
					</tr>
					<cfset toplam_rate = toplam_rate + rate>
					<cfset toplam_amount = toplam_amount + ((get_invoice_row.grosstotal*rate)/100)>
					</cfoutput>
				<cfelse>
					<tr id="frm_row" style="display:none;"><td colspan="12"><input name="record_num" id="record_num" type="hidden" value="0"></td></tr>
				</cfif>
			</tbody>
			<tfoot>
				<tr>
					<td style="text-align:right;" colspan="12"><cf_get_lang dictionary_id='57492.Toplam'>&nbsp;<cfinput type="text" name="total_amount" style="width:40px;" value="#tlformat(toplam_rate)#" readonly="yes" class="moneybox"> <cfinput type="text" name="total_rate" style="width:75px;" value="#tlformat(toplam_amount)#" readonly="yes" class="moneybox">&nbsp;</td>
				</tr>
			</tfoot>
			<cfif GET_INVOICE_ROW.DISCOUNTTOTAL GT 0>
				<cfquery name="GET_DISCOUNT_EXPENSE_ITEM" datasource="#dsn2#">
					SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 AND IS_ACTIVE=1 ORDER BY EXPENSE_ITEM_NAME
				</cfquery>
				<cfquery name="GET_DISCOUNT_EXPENSE_CENTER" datasource="#dsn2#">
					SELECT EXPENSE, EXPENSE_ID, EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ACTIVE = 1 ORDER BY EXPENSE_CODE
				</cfquery>
				<tr>
					<td colspan="2"><b><cf_get_lang dictionary_id='60199.İskonto Gider Dağıtımı'></b></td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<cf_grid_list>
							<thead>
								<tr>
									<th width="20"><input name="discount_record_num" id="discount_record_num" type="hidden" value="0"><a onClick="add_row('discount_');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
									<th width="100"><cf_get_lang dictionary_id='57742.Tarih'></th>
									<th width="150"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
									<th width="150"><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
									<th width="100"><cf_get_lang dictionary_id='33167.Aktivite Tipi'></th>
									<th width="100"><cf_get_lang dictionary_id='58140.İş Grubu'></th>
									<th width="150"><cf_get_lang dictionary_id='32856.Harcama Yapılan'></th>
									<th width="150"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></th>
									<th width="150"><cf_get_lang dictionary_id='29502.Abone No'></th>
									<th width="150"><cf_get_lang dictionary_id='57416.Proje'></th>
									<th width="50"> %</th>
									<th width="50"><cf_get_lang dictionary_id='57673.Tutar'></th>
								</tr>
							</thead>
							<tbody id="table2">
								<cfset toplam_rate = 0>
								<cfset toplam_amount = 0>
								<tr id="discount_frm_row#currentrow#" style="display:none;">

								</tr>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="12" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'><cfinput type="text" name="discount_total_amount" style="width:40px;" value="#tlformat(toplam_rate)#" readonly="yes" class="moneybox"> <cfinput type="text" name="discount_total_rate" style="width:75px;" value="#tlformat(toplam_amount)#" readonly="yes" class="moneybox">&nbsp;</td>
								</tr>
							</tfoot>
						</cf_grid_list>
					</td>
				</tr>	
			</cfif>
		</cf_grid_list>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function="kontrol()">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function open_wizard() 
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_budget_row_calculator&type=invoice_income');
		return true;
	}

	<cfif isdefined("get_expense_template.recordcount") and get_expense_template.recordcount>
		row_count=<cfoutput>#get_expense_template.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
	discount_row_count= 0;

	function sil(sy,prefix)
	{
		if(prefix == undefined || prefix=='')
			var my_element=eval("add_collacted_expense_rows.row_kontrol"+sy);
		else
			var my_element=eval("add_collacted_expense_rows.discount_row_kontrol"+sy);
		my_element.value=0;
		if(prefix == undefined || prefix=='')
			var my_element=eval("frm_row"+sy);
		else
			var my_element=eval("discount_frm_row"+sy);
		my_element.style.display="none";
	}
	function kontrol_et()
	{
		if(row_count ==0)
			return false;
		else
			return true;
	}
function add_row(expense_date,prefix,exp_center_id,exp_item_id,exp_act_id,exp_work_id,exp_member_type,exp_partner_id,exp_comp_id,exp_authorized,exp_comp_name,exp_asset_id,exp_asset_name,exp_pro_id,exp_pro_name,exp_rate,exp_amount,exp_subs_id,exp_subs_name)
{
	if(expense_date == undefined)
		expense_date = '';
	if(exp_center_id == undefined)
		exp_center_id = '';
	if(exp_item_id == undefined)
		exp_item_id = '';
	if(exp_act_id == undefined)
		exp_act_id = '';
	if(exp_work_id == undefined)
		exp_work_id = '';
	if(exp_member_type == undefined)
		exp_member_type = '';
	if(exp_partner_id == undefined)
		exp_partner_id = '';
	if(exp_comp_id == undefined)
		exp_comp_id = '';
	if(exp_authorized == undefined)
		exp_authorized = '';
	if(exp_comp_name == undefined)
		exp_comp_name = '';
	if(exp_asset_id == undefined)
		exp_asset_id = '';
	if(exp_asset_name == undefined)
		exp_asset_name = '';
	if(exp_pro_id == undefined)
		exp_pro_id = '';
	if(exp_pro_name == undefined)
		exp_pro_name = '';
	if(exp_rate == undefined)
		exp_rate = 0;
	if(exp_amount == undefined)
		exp_amount = 0;
	if(exp_subs_id == undefined)
		exp_subs_id = '';
	if(exp_subs_name == undefined)
		exp_subs_name = '';
	if(prefix == undefined)
		prefix = "";
	
	var newRow;
	var newCell;
	if(prefix==''){
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		row_count++;
		line_count= row_count;
	}
	else{
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		discount_row_count++;	
		line_count= discount_row_count;
	}
		
	newRow.setAttribute("name",prefix+"frm_row" + line_count);
	newRow.setAttribute("id",prefix+"frm_row" + line_count);		
	newRow.setAttribute("NAME",prefix+"frm_row" + line_count);
	newRow.setAttribute("ID",prefix+"frm_row" + line_count);
	if(prefix==''){	
		document.add_collacted_expense_rows.record_num.value=line_count;
	}else{
		document.add_collacted_expense_rows.discount_record_num.value=line_count;
	}
	newCell = newRow.insertCell(newRow.cells.length);
	if(prefix==''){	
	newCell.innerHTML = '<cfoutput><input type="hidden" name="'+prefix+'other_money' + line_count +'" value="#get_invoice_row.other_money#"><input type="hidden" name="'+prefix+'grosstotal' + line_count +'" value="#tlformat(get_invoice_row.grosstotal)#"><input type="hidden" name="'+prefix+'nettotal' + line_count +'" value="#tlformat(get_invoice_row.nettotal)#"><input type="hidden" name="'+prefix+'taxtotal' + line_count +'" value="#tlformat(get_invoice_row.taxtotal)#"><input type="hidden" name="'+prefix+'otvtotal' + line_count +'" value="#tlformat(get_invoice_row.otvtotal)#"><input type="hidden" name="'+prefix+'bsmvtotal' + line_count +'" value="#tlformat(get_invoice_row.bsmvtotal)#"><input type="hidden" name="'+prefix+'oivtotal' + line_count +'" value="#tlformat(get_invoice_row.oivtotal)#"><input type="hidden" name="'+prefix+'tevkifattotal' + line_count +'" value="#tlformat(get_invoice_row.tevkifattotal)#"><input type="hidden" name="'+prefix+'tax' + line_count +'" value="#get_invoice_row.tax#"><input type="hidden" name="'+prefix+'otv_oran' + line_count +'" value="#get_invoice_row.otv_oran#"><input type="hidden" name="'+prefix+'bsmv_oran' + line_count +'" value="#get_invoice_row.bsmv_oran#"><input type="hidden" name="'+prefix+'oiv_oran' + line_count +'" value="#get_invoice_row.oiv_oran#"><input type="hidden" name="'+prefix+'tevkifat_oran' + line_count +'" value="#get_invoice_row.tevkifat_oran#"><input type="hidden" name="'+prefix+'other_money_value' + line_count +'" value="#tlformat(get_invoice_row.other_money_value)#"><input type="hidden" name="'+prefix+'other_money_grosstotal' + line_count +'" value="#tlformat(get_invoice_row.other_money_gross_total)#"><input type="hidden" name="'+prefix+'rate_value_one' + line_count +'" value="<cfif isdefined('get_money.rate1')>#tlformat(get_money.rate1)#<cfelse>1</cfif>"><input type="hidden" name="'+prefix+'rate_value_two' + line_count +'" value="<cfif isdefined('get_money.rate2')>#tlformat(get_money.rate2)#<cfelse>1</cfif>"></cfoutput><input  type="hidden"  value="1"  name="'+prefix+'row_kontrol' + line_count +'" id="'+prefix+'row_kontrol' + line_count +'"><ul class="ui-icon-list"><li><a onclick="sil(' + line_count + ',\''+prefix+'\');"><i class="fa fa-minus" title="Sil"></i></a></li><li><a onclick="copy_row('+line_count+',\''+prefix+'\');"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"></i></a></li></ul>';
	}else{
	newCell.innerHTML = '<cfoutput><input type="hidden" name="'+prefix+'other_money' + line_count +'" value="#get_invoice_row.other_money#"><input type="hidden" name="'+prefix+'grosstotal' + line_count +'" value="#tlformat(get_invoice_row.discounttotal)#"><input type="hidden" name="'+prefix+'nettotal' + line_count +'" value="#tlformat(get_invoice_row.discounttotal)#"><input type="hidden" name="'+prefix+'taxtotal' + line_count +'" value="#tlformat(0)#"><input type="hidden" name="'+prefix+'otvtotal' + line_count +'" value="#tlformat(0)#"><input type="hidden" name="'+prefix+'bsmvtotal' + line_count +'" value="#tlformat(0)#"><input type="hidden" name="'+prefix+'oivtotal' + line_count +'" value="#tlformat(0)#"><input type="hidden" name="'+prefix+'tevkifattotal' + line_count +'" value="#tlformat(0)#"><input type="hidden" name="'+prefix+'tax' + line_count +'" value="0"><input type="hidden" name="'+prefix+'otv_oran' + line_count +'" value="0"><input type="hidden" name="'+prefix+'bsmv_oran' + line_count +'" value="0"><input type="hidden" name="'+prefix+'oiv_oran' + line_count +'" value="0"><input type="hidden" name="'+prefix+'tevkifat_oran' + line_count +'" value="0"><input type="hidden" name="'+prefix+'other_money_value' + line_count +'" value="#tlformat(wrk_round(get_invoice_row.DISCOUNTTOTAL/GET_MONEY.RATE,2))#"><input type="hidden" name="'+prefix+'other_money_grosstotal' + line_count +'" value="#tlformat(wrk_round(get_invoice_row.DISCOUNTTOTAL/GET_MONEY.RATE,2))#"><input type="hidden" name="'+prefix+'rate_value_one' + line_count +'" value="<cfif isdefined('get_money.rate1')>#tlformat(get_money.rate1)#<cfelse>1</cfif>"><input type="hidden" name="'+prefix+'rate_value_two' + line_count +'" value="<cfif isdefined('get_money.rate2')>#tlformat(get_money.rate2)#<cfelse>1</cfif>"></cfoutput><input  type="hidden"  value="1"  name="'+prefix+'row_kontrol' + line_count +'"><ul class="ui-icon-list"><li><a onclick="sil(' + line_count + ',\''+prefix+'\');"><i class="fa fa-minus"></i></a></li><li><a onclick="copy_row('+line_count+',\''+prefix+'\');"><i class="fa fa-copy" title="<cf_get_lang_main no="1560.Satır Kopyala">"></i></a></li></ul>';	
	}
	newCell = newRow.insertCell(newRow.cells.length);

	newCell.setAttribute("nowrap","nowrap");
	newCell.setAttribute("id","expense_date" + line_count + "_td");
	newCell.innerHTML = '<input type="text" id="expense_date' + line_count +'" name="expense_date' + line_count +'" class="text" maxlength="10" style="width:65px;" value="' + expense_date +'"> ';
	wrk_date_image('expense_date' + line_count);
	newCell = newRow.insertCell(newRow.cells.length);


	c = '<div class="form-group"><select name="'+prefix+'expense_center_ids' + line_count  +'" id="'+prefix+'expense_center_ids' + line_count  +'" style="width:120px;" class="text"><option value="">Gelir Merkezi</option>';
	if(prefix == ''){
		<cfoutput query="get_expense_center">
		if('#expense_id#' == exp_center_id)
			c += '<option value="#expense_id#" selected><cfloop from="2" to="#ListLen(EXPENSE_CODE,".")#" index="i">&nbsp;&nbsp;</cfloop>#expense#</option>';
		else
			c += '<option value="#expense_id#"><cfloop from="2" to="#ListLen(EXPENSE_CODE,".")#" index="i">&nbsp;&nbsp;</cfloop>#expense#</option>';
		</cfoutput>
	}else{
		<cfif isdefined("get_discount_expense_center")>
		<cfoutput query="get_discount_expense_center">
		if('#expense_id#' == exp_center_id)
			c += '<option value="#expense_id#" selected><cfloop from="2" to="#ListLen(EXPENSE_CODE,".")#" index="i">&nbsp;&nbsp;</cfloop>#expense#</option>';
		else
			c += '<option value="#expense_id#"><cfloop from="2" to="#ListLen(EXPENSE_CODE,".")#" index="i">&nbsp;&nbsp;</cfloop>#expense#</option>';
		</cfoutput>
		</cfif>
	}
	newCell.innerHTML =c+ '</select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	a = '<div class="form-group"><select name="'+prefix+'expense_item_id' + line_count  +'" id="'+prefix+'expense_item_id' + line_count  +'" style="width:150px;" class="text"><option value="">Gelir Kalemi</option>';
	if(prefix == ''){
		<cfoutput query="get_expense_item">
		if('#expense_item_id#' == exp_item_id)
			a += '<option value="#expense_item_id#" selected>#expense_item_name#</option>';
		else
			a += '<option value="#expense_item_id#">#expense_item_name#</option>';
		</cfoutput>
	}else{
		<cfif isdefined("get_discount_expense_item")>
		<cfoutput query="get_discount_expense_item">
		if('#expense_item_id#' == exp_item_id)
			a += '<option value="#expense_item_id#" selected>#expense_item_name#</option>';
		else
			a += '<option value="#expense_item_id#">#expense_item_name#</option>';
		</cfoutput>
		</cfif>
	}
	newCell.innerHTML =a+ '</select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	b = '<div class="form-group"><select name="'+prefix+'activity_type' + line_count  +'" id="'+prefix+'activity_type' + line_count  +'" style="width:100px;" class="text"><option value="">Aktivite Tipi</option>';
	<cfoutput query="get_activity_types">
	if('#activity_id#' == exp_act_id)
		b += '<option value="#activity_id#" selected>#activity_name#</option>';
	else
		b += '<option value="#activity_id#">#activity_name#</option>';
	</cfoutput>
	newCell.innerHTML =b+ '</select>';
	newCell = newRow.insertCell(newRow.cells.length);
	c = '<select name="'+prefix+'workgroup_id' + line_count  +'" id="'+prefix+'workgroup_id' + line_count  +'" style="width:150px;" class="text"><option value=""><cf_get_lang dictionary_id="58140.İş Grubu"></option>';
	<cfoutput query="get_workgroups">
	if('#workgroup_id#' == exp_work_id)
		c += '<option value="#workgroup_id#" selected>#workgroup_name#</option>';
	else
		c += '<option value="#workgroup_id#">#workgroup_name#</option>';
	</cfoutput>
	newCell.innerHTML =c+ '</select></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="'+prefix+'member_type'+ line_count +'" id="'+prefix+'member_type'+ line_count +'" value="'+exp_member_type+'"><input type="hidden" name="'+prefix+'member_code'+ line_count +'" id="'+prefix+'member_code'+ line_count +'" value="'+exp_partner_id+'"><input type="hidden" name="'+prefix+'member_id'+ line_count +'" id="'+prefix+'member_id'+ line_count +'" value="'+exp_partner_id+'"><input type="hidden" name="'+prefix+'company_id'+ line_count +'" id="'+prefix+'company_id'+ line_count +'" value="'+exp_comp_id+'"><div class="col col-3"><div class="form-group"><input type="text" name="'+prefix+'company'+ line_count +'" id="'+prefix+'company'+ line_count +'" value="'+exp_comp_name+'" class="txt"></div></div><div class="col col-9"><div class="form-group"><div class="input-group"><input type="text" name="'+prefix+'authorized'+ line_count +'" id="'+prefix+'authorized'+ line_count +'" value="'+exp_authorized+'" class="txt"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_company('+ line_count +',\''+prefix+'\');"></span></div></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="'+prefix+'asset_id'+ line_count +'" id="'+prefix+'asset_id'+ line_count +'" value="'+exp_asset_id+'"><div class="form-group"><div class="input-group"><input type="text" name="'+prefix+'asset'+ line_count +'" id="'+prefix+'asset'+ line_count +'" value="'+exp_asset_name+'" onFocus="AutoComplete_Create(\''+prefix+'asset'+ line_count +'\',\'ASSETP\',\'ASSETP\',\'get_assetp_autocomplete\',\'\',\'ASSETP_ID\',\''+prefix+'asset_id'+ line_count +'\',\'\',3,130)"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_asset('+ line_count +',\''+prefix+'\');"></span></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute("nowrap","nowrap");
	newCell.innerHTML = '<input type="hidden" name="'+prefix+'subscription_id'+ line_count +'" id="'+prefix+'subscription_id'+ line_count +'" value="'+exp_subs_id+'"><div class="form-group"><div class="input-group"><input type="text" name="'+prefix+'subscription_name'+ line_count +'" id="'+prefix+'subscription_name'+ line_count +'" value="'+exp_subs_name+'" onFocus="auto_subscription('+ line_count +',\''+prefix+'\');"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_subs('+ line_count +',\''+prefix+'\');"></span></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);	
	newCell.innerHTML = '<input type="hidden" name="'+prefix+'project_id'+ line_count +'" id="'+prefix+'project_id'+ line_count +'" value="'+exp_pro_id+'"><div class="form-group"><div class="input-group"><input type="text" name="'+prefix+'project'+ line_count +'" id="'+prefix+'project'+ line_count +'" value="'+exp_pro_name+'" onFocus="AutoComplete_Create(\''+prefix+'project'+ line_count +'\',\'PROJECT_HEAD\',\'PROJECT_HEAD\',\'get_project\',\'\',\'PROJECT_ID\',\''+prefix+'project_id'+ line_count +'\',\'\',3,100)"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_project('+ line_count +',\''+prefix+'\');"></span></div></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<div class="form-group"><input type="text" name="'+prefix+'expense_item_value' + line_count +'" id="'+prefix+'expense_item_value' + line_count +'" onBlur="toplam_center(\''+prefix+'\');" value="'+exp_rate+'" class="moneybox"></div>';
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="'+prefix+'rate_value1' + line_count +'" value="1"><input type="hidden" name="'+prefix+'rate_value2' + line_count +'" value="1"><div class="form-group"><input type="text" name="'+prefix+'total_expense_item' + line_count +'" id="'+prefix+'total_expense_item' + line_count +'" value="'+exp_amount+'" onBlur="toplam_center2(\''+prefix+'\');" class="moneybox" <!--- readonly="yes" --->></div>';

}

function copy_row(no_info,prefix)
	{
	expense_date = eval("document.getElementById('expense_date" + no_info + "')").value;
	exp_center_id = eval("document.getElementById('"+prefix+"expense_center_ids" + no_info + "')").value;
	exp_item_id = eval("document.getElementById('"+prefix+"expense_item_id" + no_info + "')").value;
	
	if(eval("document.getElementById('"+prefix+"activity_type" + no_info + "')") != undefined)
		exp_act_id = eval("document.getElementById('"+prefix+"activity_type" + no_info + "')").value;
	else
		exp_act_id = '';
	if(eval("document.getElementById('"+prefix+"workgroup_id" + no_info + "')") != undefined)
		exp_work_id = eval("document.getElementById('"+prefix+"workgroup_id" + no_info + "')").value;
	else
		exp_work_id = '';
	exp_member_type = eval("document.getElementById('"+prefix+"member_type" + no_info + "')").value;
	exp_partner_id = eval("document.getElementById('"+prefix+"member_code" + no_info + "')").value;
	exp_comp_id = eval("document.getElementById('"+prefix+"company_id" + no_info + "')").value;
	exp_authorized = eval("document.getElementById('"+prefix+"authorized" + no_info + "')").value;
	exp_comp_name = eval("document.getElementById('"+prefix+"company" + no_info + "')").value;
	if(eval("document.getElementById('"+prefix+"asset_id" + no_info + "')") != undefined)
	{
		exp_asset_id = eval("document.getElementById('"+prefix+"asset_id" + no_info + "')").value;
		exp_asset_name = eval("document.getElementById('"+prefix+"asset" + no_info + "')").value;
	}
	else
	{
		exp_asset_id = '';
		exp_asset_name = '';
	}
	if(eval("document.getElementById('"+prefix+"subscription_id" + no_info + "')") != undefined)
	{
		exp_subs_id = eval("document.getElementById('"+prefix+"subscription_id" + no_info + "')").value;
		exp_subs_name = eval("document.getElementById('"+prefix+"subscription_name" + no_info + "')").value;
	}
	if(eval("document.getElementById('"+prefix+"project_id" + no_info + "')") != undefined)
	{
		exp_pro_id = eval("document.getElementById('"+prefix+"project_id" + no_info + "')").value;
		exp_pro_name = eval("document.getElementById('"+prefix+"project" + no_info + "')").value;
	}
	else
	{
		exp_pro_id = '';
		exp_pro_name = '';
	}
	exp_rate = eval("document.getElementById('"+prefix+"expense_item_value" + no_info + "')").value;
	exp_amount = eval("document.getElementById('"+prefix+"total_expense_item" + no_info + "')").value;
	
	add_row(expense_date,prefix,exp_center_id,exp_item_id,exp_act_id,exp_work_id,exp_member_type,exp_partner_id,exp_comp_id,exp_authorized,exp_comp_name,exp_asset_id,exp_asset_name,exp_pro_id,exp_pro_name,exp_rate,exp_amount,exp_subs_id,exp_subs_name);
	toplam_center(prefix);
	}
	
function toplam_center(prefix)
{
	total_collection_rate = 0;
	total_collection = 0;
	if(prefix == ''){
		add_collacted_expense_rows.grosstotal.value = filterNum(add_collacted_expense_rows.grosstotal.value);
		line_count = row_count;
	}else{
		add_collacted_expense_rows.discount_grosstotal.value = filterNum(add_collacted_expense_rows.discount_grosstotal.value);
		line_count = discount_row_count;
	}
	for (var r=1;r<=line_count;r++)
	{
		if(prefix==''){
			form_expense_item_value = eval("document.add_collacted_expense_rows.expense_item_value"+r);
			form_total_expense_item = eval("document.add_collacted_expense_rows.total_expense_item"+r);
			form_row_kontrol = eval("document.add_collacted_expense_rows.row_kontrol"+r);
		}else{
			form_expense_item_value = eval("document.add_collacted_expense_rows.discount_expense_item_value"+r);
			form_total_expense_item = eval("document.add_collacted_expense_rows.discount_total_expense_item"+r);
			form_row_kontrol = eval("document.add_collacted_expense_rows.discount_row_kontrol"+r);
		}
		if(form_expense_item_value.value == "") { form_expense_item_value.value = 0; }
		if(form_row_kontrol.value != 0)
		{
			form_expense_item_value.value = filterNum(form_expense_item_value.value);
			if(prefix=='')
				form_total_expense_item.value = (parseFloat(add_collacted_expense_rows.grosstotal.value) * parseFloat(form_expense_item_value.value) / 100);
			else
				form_total_expense_item.value = (parseFloat(add_collacted_expense_rows.discount_grosstotal.value) * parseFloat(form_expense_item_value.value) / 100);
			total_collection_rate = total_collection_rate + parseFloat(form_expense_item_value.value);
			total_collection = total_collection + parseFloat(form_total_expense_item.value);
			form_total_expense_item.value = commaSplit(form_total_expense_item.value);
			form_expense_item_value.value = commaSplit(form_expense_item_value.value);
		}
	}
	if(prefix==''){
		document.add_collacted_expense_rows.total_amount.value = commaSplit(total_collection_rate);
		document.add_collacted_expense_rows.total_rate.value = commaSplit(total_collection);
		document.add_collacted_expense_rows.grosstotal.value = commaSplit(document.add_collacted_expense_rows.grosstotal.value);
	}else{
		document.add_collacted_expense_rows.discount_total_amount.value = commaSplit(total_collection_rate);
		document.add_collacted_expense_rows.discount_total_rate.value = commaSplit(total_collection);
		document.add_collacted_expense_rows.discount_grosstotal.value = commaSplit(document.add_collacted_expense_rows.discount_grosstotal.value);
	}
}


function toplam_center2(prefix)
{

	total_collection_rate = 0;
	total_collection = 0;
	if(prefix == ''){
		add_collacted_expense_rows.grosstotal.value = filterNum(add_collacted_expense_rows.grosstotal.value);
		line_count=row_count;
	}else{
		add_collacted_expense_rows.discount_grosstotal.value = filterNum(add_collacted_expense_rows.discount_grosstotal.value);
		line_count=discount_row_count;
	}
	for (var r=1;r<=line_count;r++)
	{
		if(prefix == ''){
			form_expense_item_value = eval("document.add_collacted_expense_rows.expense_item_value"+r);
			form_total_expense_item = eval("document.add_collacted_expense_rows.total_expense_item"+r);
			form_row_kontrol = eval("document.add_collacted_expense_rows.row_kontrol"+r);
		}else{
			form_expense_item_value = eval("document.add_collacted_expense_rows.discount_expense_item_value"+r);
			form_total_expense_item = eval("document.add_collacted_expense_rows.discount_total_expense_item"+r);
			form_row_kontrol = eval("document.add_collacted_expense_rows.discount_row_kontrol"+r);
		}
		if(form_total_expense_item.value == "") { form_total_expense_item.value = 0; }
		if(form_row_kontrol.value != 0)
		{
			form_total_expense_item.value = filterNum(form_total_expense_item.value);
			if(prefix == ''){
				form_expense_item_value.value = (100 * parseFloat(form_total_expense_item.value) / parseFloat(add_collacted_expense_rows.grosstotal.value));
			}else{
				form_expense_item_value.value = (100 * parseFloat(form_total_expense_item.value) / parseFloat(add_collacted_expense_rows.discount_grosstotal.value));
			}
			total_collection_rate = total_collection_rate + parseFloat(form_expense_item_value.value);
			total_collection = total_collection + parseFloat(form_total_expense_item.value);
			form_total_expense_item.value = commaSplit(form_total_expense_item.value);
			form_expense_item_value.value = commaSplit(form_expense_item_value.value);
		}
	}
	
	if(prefix == ''){
		document.add_collacted_expense_rows.total_amount.value = commaSplit(total_collection_rate);
		document.add_collacted_expense_rows.total_rate.value = commaSplit(total_collection);
		add_collacted_expense_rows.grosstotal.value = commaSplit(add_collacted_expense_rows.grosstotal.value);
	}else{
		document.add_collacted_expense_rows.discount_total_amount.value = commaSplit(total_collection_rate);
		document.add_collacted_expense_rows.discount_total_rate.value = commaSplit(total_collection);
		add_collacted_expense_rows.discount_grosstotal.value = commaSplit(add_collacted_expense_rows.discount_grosstotal.value);
	}
}
	
function pencere_ac_asset(no,prefix)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_collacted_expense_rows.'+prefix+'asset_id' + no +'&field_name=add_collacted_expense_rows.'+prefix+'asset' + no +'&event_id=0');
	
}
function pencere_ac_project(no,prefix)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_collacted_expense_rows.'+prefix+'project_id' + no +'&project_head=add_collacted_expense_rows.'+prefix+'project' + no);
}

function pencere_ac_company(no,prefix)
{
	eval("document.add_collacted_expense_rows."+prefix+"member_type"+no).value = '';
	eval("document.add_collacted_expense_rows."+prefix+"member_id"+no).value = '';
	eval("document.add_collacted_expense_rows."+prefix+"member_code"+no).value = '';
	eval("document.add_collacted_expense_rows."+prefix+"company_id"+no).value = '';
	eval("document.add_collacted_expense_rows."+prefix+"company"+no).value = '';
	eval("document.add_collacted_expense_rows."+prefix+"authorized"+no).value = '';
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_collacted_expense_rows.'+prefix+'member_id' + no +'&field_code=add_collacted_expense_rows.'+prefix+'member_code' + no +'&field_id=add_collacted_expense_rows.'+prefix+'member_id' + no +'&field_comp_name=add_collacted_expense_rows.'+prefix+'company' + no +'&field_name=add_collacted_expense_rows.'+prefix+'authorized' + no +'&field_comp_id=add_collacted_expense_rows.'+prefix+'company_id' + no + '&field_type=add_collacted_expense_rows.'+prefix+'member_type' + no + '&select_list=1,2,3');
}

function pencere_ac_subs(no,prefix)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=add_collacted_expense_rows.'+prefix+'subscription_id' + no +'&field_no=add_collacted_expense_rows.'+prefix+'subscription_name' + no);
}
function auto_subscription(no,prefix)
{
	AutoComplete_Create(prefix+'subscription_name'+no,'SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID',prefix+'subscription_id'+no,'','3','150');
}

function kontrol()
	{
		var discounttotalamount = 0;
		if(add_collacted_expense_rows.discount_total_amount !== undefined)
			discounttotalamount = filterNum(add_collacted_expense_rows.discount_total_amount.value);

		if(filterNum(add_collacted_expense_rows.total_amount.value) > 100 || discounttotalamount > 100)
		{
			alert("<cf_get_lang dictionary_id='33878.Toplam Oran 100 den Büyük Olamaz'>!");
			return false;
		}
		sira_deger = 0
		for (var r=1;r<=row_count;r++)
		{
			form_row_kontrol = eval("document.add_collacted_expense_rows.row_kontrol"+r);
			form_expense_center_id = eval("document.add_collacted_expense_rows.expense_center_ids"+r);
			form_expense_item_id = eval("document.add_collacted_expense_rows.expense_item_id"+r);
			if(form_row_kontrol.value == 1)
			{
				sira_deger = sira_deger + 1;
				if(form_expense_center_id.value =="")
				{
					alert(sira_deger + "<cf_get_lang dictionary_id='33488.Lütfen gelir merkezi seçiniz'> !");
					return false;
				}
				if(form_expense_item_id.value =="")
				{
					alert(sira_deger + "<cf_get_lang dictionary_id='33489.Lütfen gelir kalemi seçiniz'> !");
					return false;
				}
				//Bütçe tarih kısıtı kontrolü
				if(!date_check_hiddens(document.getElementById("budget_period"),document.getElementById("expense_date"+r),'Bütçe dönemi kapandığı için satırdaki harcama tarihi '+document.getElementById("budget_period").value+' tarihinden sonra girilmiş olmalıdır.'))
				return false;
			}
		}
		if(sira_deger == 0)
		{
			alert("<cf_get_lang dictionary_id='48664.Lütfen Satır Ekleyiniz'> !");
			return false;
		}
		if(discount_row_count > 0)
		{
			sira_deger= 0;
			for (var r=1;r<=discount_row_count;r++)
			{
				form_row_kontrol = eval("document.add_collacted_expense_rows.discount_row_kontrol"+r);
				form_expense_center_id = eval("document.add_collacted_expense_rows.discount_expense_center_ids"+r);
				form_expense_item_id = eval("document.add_collacted_expense_rows.discount_expense_item_id"+r);
				if(form_row_kontrol.value == 1)
				{
					sira_deger = sira_deger + 1;
					if(form_expense_center_id.value =="")
					{
						alert("<cf_get_lang dictionary_id='57641.İskonto'>" + sira_deger + ".<cf_get_lang dictionary_id='33488.Lütfen gelir merkezi seçiniz'> !");
						return false;
					}
					if(form_expense_item_id.value =="")
					{
						alert("<cf_get_lang dictionary_id='57641.İskonto'>" + sira_deger + ".<cf_get_lang dictionary_id='33489.Lütfen gelir kalemi seçiniz'> !");
						return false;
					}
				}
			}
		}

		add_collacted_expense_rows.total_amount.value = filterNum(add_collacted_expense_rows.total_amount.value);
		for (var r=1;r<=row_count;r++)
		{
			form_expense_item_value = eval("document.add_collacted_expense_rows.expense_item_value"+r);
			form_total_expense_item = eval("document.add_collacted_expense_rows.total_expense_item"+r);
			form_grosstotal = eval("document.add_collacted_expense_rows.grosstotal"+r);
			form_nettotal = eval("document.add_collacted_expense_rows.nettotal"+r);
			form_taxtotal = eval("document.add_collacted_expense_rows.taxtotal"+r);
			form_otvtotal = eval("document.add_collacted_expense_rows.otvtotal"+r);
			form_bsmvtotal = eval("document.add_collacted_expense_rows.bsmvtotal"+r);
			form_oivtotal = eval("document.add_collacted_expense_rows.oivtotal"+r);
			form_tevkifattotal = eval("document.add_collacted_expense_rows.tevkifattotal"+r);
			form_other_money_value = eval("document.add_collacted_expense_rows.other_money_value"+r);
			form_other_money_grosstotal = eval("document.add_collacted_expense_rows.other_money_grosstotal"+r);
			form_rate_value_one = eval("document.add_collacted_expense_rows.rate_value_one"+r);
			form_rate_value_two = eval("document.add_collacted_expense_rows.rate_value_two"+r);
	
			form_expense_item_value.value = filterNum(form_expense_item_value.value);		
			form_total_expense_item.value = filterNum(form_total_expense_item.value);		
			form_grosstotal.value = filterNum(form_grosstotal.value);		
			form_nettotal.value = filterNum(form_nettotal.value);		
			form_taxtotal.value = filterNum(form_taxtotal.value);		
			form_otvtotal.value = filterNum(form_otvtotal.value);
			form_bsmvtotal.value = filterNum(form_bsmvtotal.value);
			form_oivtotal.value = filterNum(form_oivtotal.value);
			form_tevkifattotal.value = filterNum(form_tevkifattotal.value);		
			form_other_money_value.value = filterNum(form_other_money_value.value);		
			form_other_money_grosstotal.value = filterNum(form_other_money_grosstotal.value);		
			
			form_rate_value_one.value = filterNum(form_rate_value_one.value);		
			form_rate_value_two.value = filterNum(form_rate_value_two.value);
		}
		add_collacted_expense_rows.total_rate.value = filterNum(add_collacted_expense_rows.total_rate.value);
		add_collacted_expense_rows.grosstotal.value = filterNum(add_collacted_expense_rows.grosstotal.value);
		<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.opener.document</cfif>.form_basket.is_cost.value=1;

		if(discount_row_count > 0)
		{
			for (var r=1;r<=discount_row_count;r++)
			{
				form_expense_item_value = eval("document.add_collacted_expense_rows.discount_expense_item_value"+r);
				form_total_expense_item = eval("document.add_collacted_expense_rows.discount_total_expense_item"+r);
				form_grosstotal = eval("document.add_collacted_expense_rows.discount_grosstotal"+r);
				form_nettotal = eval("document.add_collacted_expense_rows.discount_nettotal"+r);
				form_taxtotal = eval("document.add_collacted_expense_rows.discount_taxtotal"+r);
				form_otvtotal = eval("document.add_collacted_expense_rows.discount_otvtotal"+r);
				form_oivtotal = eval("document.add_collacted_expense_rows.discount_oivtotal"+r);
				form_bsmvtotal = eval("document.add_collacted_expense_rows.discount_bsmvtotal"+r);
				form_tevkifattotal = eval("document.add_collacted_expense_rows.discount_tevkifattotal"+r);
				form_other_money_value = eval("document.add_collacted_expense_rows.discount_other_money_value"+r);
				form_other_money_grosstotal = eval("document.add_collacted_expense_rows.discount_other_money_grosstotal"+r);
				form_rate_value_one = eval("document.add_collacted_expense_rows.discount_rate_value_one"+r);
				form_rate_value_two = eval("document.add_collacted_expense_rows.discount_rate_value_two"+r);

				form_expense_item_value.value = filterNum(form_expense_item_value.value);		
				form_total_expense_item.value = filterNum(form_total_expense_item.value);		
				form_grosstotal.value = filterNum(form_grosstotal.value);		
				form_nettotal.value = filterNum(form_nettotal.value);		
				form_taxtotal.value = filterNum(form_taxtotal.value);		
				form_otvtotal.value = filterNum(form_otvtotal.value);
				form_bsmvtotal.value = filterNum(form_bsmvtotal.value);	
				form_oivtotal.value = filterNum(form_oivtotal.value);
				form_tevkifattotal.value = filterNum(form_tevkifattotal.value);	
				form_other_money_value.value = filterNum(form_other_money_value.value);		
				form_other_money_grosstotal.value = filterNum(form_other_money_grosstotal.value);		
				
				form_rate_value_one.value = filterNum(form_rate_value_one.value);		
				form_rate_value_two.value = filterNum(form_rate_value_two.value);
			}
			add_collacted_expense_rows.discount_total_rate.value = filterNum(add_collacted_expense_rows.discount_total_rate.value);
			add_collacted_expense_rows.discount_grosstotal.value = filterNum(add_collacted_expense_rows.discount_grosstotal.value);
		}

		<cfif isdefined("attributes.draggable")>
			loadPopupBox('add_collacted_expense_rows' , <cfoutput>#attributes.modal_id#</cfoutput>)
		</cfif>
		return true;
	}
	<cfif isdefined("attributes.row_id") and not len(GET_PRODUCT_PER.INCOME_TEMPLATE_ID)>
		temp_id = eval('<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.all.exp_template_id'+<cfoutput>#attributes.row_id#</cfoutput>).value;
		if(temp_id != '')
		{
			var get_temp_rows = wrk_safe_query('obj_get_temp_rows' ,'dsn2' , 0, temp_id);
			for(i=0;i<get_temp_rows.recordcount;i++)
			{
				exp_amount = <cfoutput>#get_invoice_row.grosstotal#</cfoutput>;
				exp_amount = commaSplit(parseFloat(exp_amount*get_temp_rows.RATE[i]/100));
				exp_center =get_temp_rows.EXPENSE[i];
				exp_center_id =get_temp_rows.EXPENSE_CENTER_ID[i];
				exp_item =get_temp_rows.EXPENSE_ITEM_NAME[i];
				exp_item_id =get_temp_rows.EXPENSE_ITEM_ID[i];
				exp_act_id =get_temp_rows.PROMOTION_ID[i];
				exp_work_id =get_temp_rows.WORKGROUP_ID[i];
				exp_member_type =get_temp_rows.MEMBER_TYPE[i];
				exp_comp_id =get_temp_rows.COMPANY_ID[i];
				exp_partner_id =get_temp_rows.COMPANY_PARTNER_ID[i];
				if(get_temp_rows.PROJECT_ID[i] != '')
				{
					var get_pro_name = wrk_safe_query('obj_get_pro_name' ,'dsn', 0, get_temp_rows.PROJECT_ID[i]);
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
					var get_pro_name = wrk_safe_query('obj_get_pro_name_2' ,'dsn' , 0, get_temp_rows.ASSET_ID[i]);
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
					var get_comp_name = wrk_safe_query('obj_get_comp_name', 'dsn', 0, exp_comp_id);
					exp_comp_name = get_comp_name.FULLNAME;
				}
				else
				{
					exp_comp_name = '';
				}
				if(exp_member_type != '' && exp_partner_id != '' && exp_member_type =='partner')
				{
					var get_par_name = wrk_safe_query('obj_get_par_name', 'dsn', 0, exp_partner_id);
					exp_authorized = get_par_name.COMPANY_PARTNER_NAME+' '+get_par_name.COMPANY_PARTNER_SURNAME;
				}
				else if(exp_member_type != '' && exp_partner_id != '' && exp_member_type =='consumer')
				{
					var get_cons_name = wrk_safe_query('obj_get_cons_name','dsn', 0, exp_partner_id);
					exp_authorized = get_cons_name.CONSUMER_NAME+' '+get_cons_name.CONSUMER_SURNAME;
				}
				else if(exp_member_type != '' && exp_partner_id != '' && exp_member_type =='employee')
				{
					var get_emp_name = wrk_safe_query('obj_get_emp_name','dsn', 0, exp_partner_id);
					exp_authorized = get_emp_name.EMPLOYEE_NAME+' '+get_emp_name.EMPLOYEE_SURNAME;
				}
				else
				{
					exp_authorized = '';
				}
				add_row(prefix,exp_center_id,exp_item_id,exp_act_id,exp_work_id,exp_member_type,exp_partner_id,exp_comp_id,exp_authorized,exp_comp_name,exp_asset_id,exp_asset_name,exp_pro_id,exp_pro_name,get_temp_rows.RATE[i],exp_amount);
			}
			toplam_center2(prefix);	
		}
	</cfif>
</script>
