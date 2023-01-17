<cfquery name="GET_INVOICE_INFO" datasource="#DSN2#">
	SELECT 
		INVOICE.COMPANY_ID,
		INVOICE.PARTNER_ID,
		INVOICE.CONSUMER_ID,
		INVOICE.INVOICE_CAT,		
		INVOICE.INVOICE_NUMBER,
		INVOICE.INVOICE_DATE,
		INVOICE_ROW.STOCK_ID,
		INVOICE_ROW.PRODUCT_ID,
		INVOICE_ROW.AMOUNT,
		INVOICE_ROW.UNIT,
		INVOICE_ROW.INVOICE_ROW_ID,
		INVOICE_ROW.STOCK_ID,
		INVOICE_ROW.NAME_PRODUCT,
		INVOICE_ROW.GROSSTOTAL,
		INVOICE_ROW.NETTOTAL,
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
		INVOICE_ROW.OTHER_MONEY,
		INVOICE_ROW.OTHER_MONEY_VALUE,
		INVOICE_ROW.OTHER_MONEY_GROSS_TOTAL,
		INVOICE_ROW.NAME_PRODUCT,	
		PRODUCT.PRODUCT_NAME,
		PRODUCT.PRODUCT_CATID,
		INVOICE.SUBSCRIPTION_ID,
		INVOICE_ROW.SUBSCRIPTION_ID ROW_SUBSCRIPTION_ID,
		ISNULL(INVOICE.PROCESS_DATE,INVOICE.INVOICE_DATE) AS PROCESS_DATE
	FROM
		INVOICE,
		INVOICE_ROW,
		#dsn3_alias#.PRODUCT AS PRODUCT
	WHERE
		INVOICE.INVOICE_ID = #URL.ID# AND
		INVOICE_ROW.INVOICE_ID = INVOICE.INVOICE_ID AND
		PRODUCT.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID AND
		INVOICE_ROW.GROSSTOTAL > 0
</cfquery>
<cfif not get_invoice_info.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='34201.Fatura Tutarınızı Kontrol Ediniz'>");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_COST_TEMPLATE" datasource="#dsn2#">
	SELECT 
		TEMPLATE_ID,
		TEMPLATE_NAME
	FROM 
		EXPENSE_PLANS_TEMPLATES 
	WHERE 
		TEMPLATE_ID IS NOT NULL AND 
		IS_ACTIVE = 1 AND 
		IS_INCOME = 1
	ORDER BY 
		TEMPLATE_NAME
</cfquery>
<cfset components2 = createObject('component','V16.workdata.get_budget_period_date')>
<cfset budget_date = components2.get_budget_period_date()>

<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Gelir Merkezlerine Dağıtım',34202)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_expense_invoice" action="#request.self#?fuseaction=objects.emptypopup_add_income_center_invoce_detail" method="post">
		<cf_box_search>
			<cfoutput>
				<div class="form-group">
					<cf_get_lang dictionary_id='57519.Cari Hesap'>:
					<cfif len(get_invoice_info.company_id)>#get_par_info(get_invoice_info.company_id,1,1,0)#
					<cfelseif len(get_invoice_info.consumer_id)>#get_cons_info(get_invoice_info.consumer_id,1,0)#
					<cfif len(get_invoice_info.partner_id)> - ( #get_par_info(get_invoice_info.partner_id,0,-1,0)# )</cfif>
					</cfif>
				</div>
				<div class="form-group">
					<cf_get_lang dictionary_id='58133.Fatura No'>
					#get_invoice_info.invoice_number#
				</div>
				<div class="form-group">
					<cf_get_lang dictionary_id='58759.Fatura Tarihi'>
					#dateformat(get_invoice_info.invoice_date,dateformat_style)#
				</div>
			</cfoutput>
		</cf_box_search>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th class="text-right"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='58823.Gelir Şablonu'></th>
					<th width="20"></th>
					<th width="20"></th>
				</tr>
			</thead>
			<tbody>
				<cfinput type="hidden" name="budget_period" id="budget_period" value="#dateformat(budget_date.budget_period_date,dateformat_style)#">
				<input type="hidden" name="invoice_id" id="invoice_id" value="<cfoutput>#url.id#</cfoutput>">
				<input type="hidden" name="page_info" id="page_info" value="<cfoutput>#url.id#</cfoutput>">
				<input type="hidden" name="page_record_num" id="page_record_num" value="<cfoutput>#get_invoice_info.recordcount#</cfoutput>">
				<input type="hidden" name="page_type" id="page_type" value="<cfoutput>#get_process_name(GET_INVOICE_INFO.INVOICE_CAT)#</cfoutput>">
				<input type="hidden" name="invoice_cat" id="invoice_cat" value="<cfoutput>#GET_INVOICE_INFO.INVOICE_CAT#</cfoutput>">
				<input type="hidden" name="invoice_number" id="invoice_number" value="<cfoutput>#GET_INVOICE_INFO.INVOICE_NUMBER#</cfoutput>">
				<input type="hidden" name="expense_date" id="expense_date" value="<cfoutput>#dateformat(get_invoice_info.PROCESS_DATE,dateformat_style)#</cfoutput>">
				<cfoutput query="get_invoice_info">
					<cfif len(ROW_SUBSCRIPTION_ID)>
						<cfset sub_id = GET_INVOICE_INFO.ROW_SUBSCRIPTION_ID>
					<cfelse>
						<cfset sub_id = GET_INVOICE_INFO.SUBSCRIPTION_ID>
					</cfif>
					<cfquery name="CONTROL_1" datasource="#DSN2#">
						SELECT EXP_ITEM_ROWS_ID FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #GET_INVOICE_INFO.INVOICE_ROW_ID# AND INVOICE_ID=#URL.ID# AND IS_DETAILED=1
					</cfquery>
					<cfquery name="GET_EXPENSE_ITEM_ROWS" datasource="#DSN2#">
						SELECT * FROM EXPENSE_ITEMS_ROWS WHERE IS_DETAILED=0 AND EXPENSE_ITEMS_ROWS.ACTION_ID = #GET_INVOICE_INFO.INVOICE_ROW_ID# AND EXPENSE_ITEMS_ROWS.EXPENSE_COST_TYPE = #get_invoice_info.INVOICE_CAT#
					</cfquery>
					<cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
						SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = #PRODUCT_CATID#
					</cfquery>
					<cfquery name="GET_KONTROL_LAST" datasource="#dsn2#">
						SELECT EXP_ITEM_ROWS_ID FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #get_invoice_info.invoice_row_id# AND EXPENSE_COST_TYPE = #get_invoice_info.INVOICE_CAT#
					</cfquery>
					<cfquery name="GET_PRODUCT_PER" datasource="#dsn3#">
						SELECT INCOME_TEMPLATE_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_invoice_info.product_id# AND PERIOD_ID = #session.ep.period_id#
					</cfquery>
						<tr>
							<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#get_invoice_info.stock_id#">
							<input type="hidden" name="name_product#currentrow#" id="name_product#currentrow#" value="#get_invoice_info.name_product#">
							<input type="hidden" name="invoice_row_id#currentrow#" id="invoice_row_id#currentrow#" value="#invoice_row_id#">
							<input type="hidden" name="grosstotal_page#currentrow#" id="grosstotal_page#currentrow#" value="#get_invoice_info.grosstotal#">	
							<input type="hidden" name="nettotal_page#currentrow#" id="nettotal_page#currentrow#" value="#get_invoice_info.nettotal#">	
							<input type="hidden" name="taxtotal_page#currentrow#" id="taxtotal_page#currentrow#" value="#get_invoice_info.taxtotal#">
							<input type="hidden" name="otvtotal_page#currentrow#" id="otvtotal_page#currentrow#" value="#get_invoice_info.otvtotal#">		
							<input type="hidden" name="bsmvtotal_page#currentrow#" id="bsmvtotal_page#currentrow#" value="#get_invoice_info.bsmvtotal#">
							<input type="hidden" name="tevkifattotal_page#currentrow#" id="tevkifattotal_page#currentrow#" value="#get_invoice_info.tevkifattotal#">
							<input type="hidden" name="oivtotal_page#currentrow#" id="oivtotal_page#currentrow#" value="#get_invoice_info.oivtotal#">		
							<input type="hidden" name="otv_oran_page#currentrow#" id="otv_oran_page#currentrow#" value="#get_invoice_info.otv_oran#">
							<input type="hidden" name="bsmv_oran_page#currentrow#" id="bsmv_oran_page#currentrow#" value="#get_invoice_info.bsmv_oran#">
							<input type="hidden" name="oiv_oran_page#currentrow#" id="oiv_oran_page#currentrow#" value="#get_invoice_info.oiv_oran#">
							<input type="hidden" name="tevkifat_oran_page#currentrow#" id="tevkifat_oran_page#currentrow#" value="#get_invoice_info.tevkifat_oran#">
							<input type="hidden" name="tax_page#currentrow#" id="tax_page#currentrow#" value="#get_invoice_info.tax#">				
							<input type="hidden" name="other_money_value_page#currentrow#" id="other_money_value_page#currentrow#" value="#get_invoice_info.other_money_value#">
							<input type="hidden" name="other_money_grosstotal_page#currentrow#" id="other_money_grosstotal_page#currentrow#" value="#get_invoice_info.other_money_gross_total#">
							<input type="hidden" name="other_money_page#currentrow#" id="other_money_page#currentrow#" value="#get_invoice_info.other_money#">
							<input type="hidden" name="subscription_id#currentrow#" id="subscription_id#currentrow#" value="#sub_id#">
							<input type="hidden" name="subscription_name#currentrow#" id="subscription_name#currentrow#" value="<cfif sub_id gt 0>--</cfif>">
							<td>#name_product#</td>
							<td>#get_product_cat.product_cat#</td>
							<td class="text-right">#amount# #unit# <input type="hidden" name="amount#currentrow#" id="amount#currentrow#" value="#grosstotal#"></td>
							<td class="text-right">#tlformat(grosstotal)# #session.ep.money#</td>
							<td><div class="form-group"><input type="text" name="detail#currentrow#" id="detail#currentrow#" class="boxtext" value="<cfif len(get_expense_item_rows.detail)>#get_expense_item_rows.detail#<cfelse>#name_product#</cfif>" <cfif control_1.recordcount>disabled</cfif>></div></td>
							<td width="120">
								<div class="form-group">
									<select name="exp_template_id#currentrow#" id="exp_template_id#currentrow#">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_cost_template">
											<option value="#get_cost_template.template_id#" <cfif get_cost_template.template_id eq GET_PRODUCT_PER.INCOME_TEMPLATE_ID>selected</cfif>>#get_cost_template.template_name#</option>
										</cfloop>
									</select>
								</div>
							</td>
							<td>
								<cfif control_1.recordcount>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_upd_income_center_invoice_detail&invoice_row_id=#get_invoice_info.invoice_row_id#&invoice_cat=#GET_INVOICE_INFO.INVOICE_CAT#','','ui-draggable-box-large');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='33874.Ayrıntılı'>"></i></a>
								<cfelse>
									<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_income_center_invoice_detail&invoice_row_id=#get_invoice_info.invoice_row_id#&invoice_cat=#GET_INVOICE_INFO.INVOICE_CAT#&row_id=#currentrow#','','ui-draggable-box-large');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='33874.Ayrıntılı'>"></i></a>
								</cfif>
							</td>
							<cfsavecontent variable="cancel_message"><cf_get_lang dictionary_id ='34200.Bu Satıra İlişkin Kayıtlı Gelir Bilgilerini İptal Ediyorsunuz ! Emin misiniz'></cfsavecontent>
							<td><cfif get_kontrol_last.recordcount><a href="javascript://" onClick="javascript:if(confirm('#cancel_message#')) openBoxDraggable('#request.self#?fuseaction=objects.emptypopup_del_cost_info&invoice_row_id=#invoice_row_id#&invoice_id=#URL.ID#&invoice_cat=#invoice_cat#'); else return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='34203.Gelir Bilgisini İptale Et'>"></i></a></cfif>
						</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('add_expense_invoice' , #attributes.modal_id#)"),DE(""))#">
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	row_count = <cfoutput>#get_invoice_info.recordcount#</cfoutput>;
	//Bütçe tarih kısıtı kontrolü
	if(!date_check_hiddens(document.getElementById("budget_period"),document.getElementById("expense_date"),'Bütçe dönemi kapandığı için satırdaki harcama tarihi '+document.getElementById("budget_period").value+' tarihinden sonra girilmiş olmalıdır.'))
	return false;
	for (var r=1;r<=row_count;r++)
	{	
		temp_id = eval("document.add_expense_invoice.exp_template_id"+r);
		if(temp_id == '')
		{
			alert("<cf_get_lang dictionary_id='60302.Dağılım Yapabilmek İçin Gelir Şablonu Seçmelisiniz'> !");
			return false;
		}
	}
	<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.form_basket.is_cost.value=1;
	return true;
}
</script>
