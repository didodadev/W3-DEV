<cfinclude template="../query/get_invoice_cost_info.cfm">
<cfif not GET_INVOICE_INFO.recordcount>
	<br/><br/><br/><b><cf_get_lang dictionary_id='60301.Fatura Kaydı Bulunamadı veya Dağıtım Yapılabilecek Fatura Satırı Yok'>!!</b>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="get_cost_template" datasource="#dsn2#">
	SELECT 
		TEMPLATE_ID,
        TEMPLATE_NAME
	FROM 
		EXPENSE_PLANS_TEMPLATES
	WHERE 
		TEMPLATE_ID IS NOT NULL 
		AND IS_ACTIVE = 1 
		AND IS_INCOME = 0
	ORDER BY 
		TEMPLATE_NAME
</cfquery>
<cfset components2 = createObject('component','V16.workdata.get_budget_period_date')>
<cfset budget_date = components2.get_budget_period_date()>
<div class="col col-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='32524.Faturayı Maliyet Merkezlerine Dağıt'></cfsavecontent>
    <cf_box  title="#message#">
        <cfform name="add_expense_invoice" action="#request.self#?fuseaction=objects.emptypopup_add_expensecenter_invoce_detail" method="post">
            <cfinput type="hidden" name="budget_period" id="budget_period" value="#dateformat(budget_date.budget_period_date,dateformat_style)#">
            <cf_box_elements>
                <cfoutput>
                    <b><cf_get_lang dictionary_id='57519.Cari Hesap'></b>:
                    <cfif len(get_invoice_info.company_id)>#get_par_info(get_invoice_info.company_id,1,1,0)#
                        <cfelseif len(get_invoice_info.consumer_id)>#get_cons_info(get_invoice_info.consumer_id,1,0)#
                    </cfif>
                    <cfif len(get_invoice_info.partner_id)>- #get_par_info(get_invoice_info.partner_id,0,-1,0)#</cfif>
                    &nbsp;&nbsp;<cfif not isdefined("attributes.is_stock_fis")><b><cf_get_lang dictionary_id='58133.Fatura No'><cfelse><cf_get_lang dictionary_id='33102.Stok Fişi'></cfif></b>: #get_invoice_info.invoice_number#
                    &nbsp;&nbsp;<cfif not isdefined("attributes.is_stock_fis")><b><cf_get_lang dictionary_id='58759.Fatura Tarihi'><cfelse><cf_get_lang dictionary_id='57879.İşlem Tarihi'></cfif></b>: #dateformat(get_invoice_info.invoice_date,dateformat_style)#                        
                </cfoutput>                            
            </cf_box_elements>
            <cf_flat_list>
                    <thead>
                        <tr>
                            <th style="width:120px;"><cf_get_lang dictionary_id='57657.Ürün'></th>
                            <th style="width:120px;"><cf_get_lang dictionary_id='57486.Kategori'></th>
                            <th style="text-align:right;width:55px;"><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th style="text-align:right;width:120px;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                            <th style="width:150px;"><cf_get_lang dictionary_id='57629.Açıklama'></th>
                            <cfif not isdefined("attributes.is_stock_fis")>
                                <th style="width:150px;"><cf_get_lang dictionary_id='58822.Masraf Şablonu'></th>
                            </cfif>
                            <th style="width:15px;"></th>
                            <th style="width:15px;">&nbsp;</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif isdefined('attributes.is_stock_fis')>
                            <input type="hidden" name="is_stock_fis" id="is_stock_fis" value="1">
                        </cfif>
                        <input type="hidden" name="invoice_id" id="invoice_id" value="<cfoutput>#url.id#</cfoutput>">
                        <input type="hidden" name="page_info" id="page_info" value="<cfoutput>#url.id#</cfoutput>">
                        <input type="hidden" name="page_record_num" id="page_record_num" value="<cfoutput>#get_invoice_info.recordcount#</cfoutput>">
                        <input type="hidden" name="page_type" id="page_type" value="<cfoutput>#get_process_name(GET_INVOICE_INFO.INVOICE_CAT)#</cfoutput>">
                        <input type="hidden" name="invoice_cat" id="invoice_cat" value="<cfoutput>#GET_INVOICE_INFO.INVOICE_CAT#</cfoutput>">
                        <input type="hidden" name="invoice_number" id="invoice_number" value="<cfoutput>#GET_INVOICE_INFO.INVOICE_NUMBER#</cfoutput>">
                        <input type="hidden" name="expense_date" id="expense_date" value="<cfoutput>#dateformat(get_invoice_info.process_date,dateformat_style)#</cfoutput>">
                        <cfoutput query="get_invoice_info">
                            <cfif not isdefined("attributes.is_stock_fis")>
                                <cfquery name="CONTROL_1" datasource="#dsn2#" maxrows="1">
                                    SELECT EXP_ITEM_ROWS_ID FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #GET_INVOICE_INFO.INVOICE_ROW_ID# AND INVOICE_ID=#URL.ID# AND IS_DETAILED=1
                                </cfquery>
                            <cfelse>
                                <cfquery name="CONTROL_1" datasource="#dsn2#" maxrows="1">
                                    SELECT EXP_ITEM_ROWS_ID FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #GET_INVOICE_INFO.INVOICE_ROW_ID# AND STOCK_FIS_ID=#URL.ID# AND IS_DETAILED=1
                                </cfquery>
                            </cfif>
                            <cfquery name="GET_EXPENSE_ITEM_ROWS" datasource="#dsn2#">
                                SELECT * FROM EXPENSE_ITEMS_ROWS WHERE IS_DETAILED=0 AND EXPENSE_ITEMS_ROWS.ACTION_ID = #get_invoice_info.invoice_row_id# AND EXPENSE_ITEMS_ROWS.EXPENSE_COST_TYPE = #get_invoice_info.INVOICE_CAT#
                            </cfquery>
                            <cfquery name="GET_PRODUCT_PER" datasource="#dsn3#">
                                SELECT INCOME_TEMPLATE_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_invoice_info.product_id# AND PERIOD_ID = #session.ep.period_id#
                            </cfquery>
                            <cfquery name="GET_PRODUCT_CAT" datasource="#dsn3#">
                                SELECT PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = #product_catid#
                            </cfquery>
                            <cfquery name="GET_KONTROL_LAST" datasource="#dsn2#">
                                SELECT EXP_ITEM_ROWS_ID FROM EXPENSE_ITEMS_ROWS WHERE ACTION_ID = #get_invoice_info.invoice_row_id# AND EXPENSE_COST_TYPE = #get_invoice_info.INVOICE_CAT#
                            </cfquery>
                            <cfif not isdefined("attributes.is_stock_fis")>
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
                            </cfif>
                            <tr>
                                <td>#name_product#</td>
                                <td>#get_product_cat.product_cat#</td>
                                <td style="text-align:right;width:100px">#amount# #unit# <input type="hidden" name="amount#currentrow#" id="amount#currentrow#" value="#grosstotal#"></td>
                                <td style="text-align:right;">#tlformat(grosstotal)# #session.ep.money#</td>
                                <td><input type="text" name="detail#currentrow#" id="detail#currentrow#" class="boxtext" style="width:400px;" value="<cfif (get_expense_item_rows.recordcount) and len(get_expense_item_rows.detail)>#get_expense_item_rows.detail#<cfelse>#name_product#</cfif>" <cfif control_1.recordcount>disabled</cfif>></td>
                                <cfif not isdefined("attributes.is_stock_fis")>
                                    <td width="120">
                                        <select name="exp_template_id#currentrow#" id="exp_template_id#currentrow#" style="width:150px;">
                                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                            <cfloop query="get_cost_template">
                                                <option value="#get_cost_template.template_id#" <cfif get_cost_template.template_id eq GET_PRODUCT_PER.INCOME_TEMPLATE_ID>selected</cfif>>#get_cost_template.template_name#</option>
                                            </cfloop>
                                        </select>
                                    </td>
                                </cfif>
                                <td>
                                    <cfif control_1.recordcount>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_expensecenter_invoice_detail&invoice_row_id=#get_invoice_info.invoice_row_id#&invoice_cat=#GET_INVOICE_INFO.INVOICE_CAT#<cfif isdefined("attributes.is_stock_fis")>&is_stock_fis=1</cfif>','horizantal');"><img src="/images/cuberelation.gif" title="<cf_get_lang dictionary_id ='33874.Ayrıntılı'>" border="0"></a>
                                    <cfelse>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_add_expensecenter_invoice_detail&invoice_row_id=#get_invoice_info.invoice_row_id#&invoice_cat=#GET_INVOICE_INFO.INVOICE_CAT#&row_id=#currentrow#<cfif isdefined("attributes.is_stock_fis")>&is_stock_fis=1</cfif>','horizantal');"><img src="/images/cuberelation.gif" title="<cf_get_lang dictionary_id ='33874.Ayrıntılı'>" border="0"></a>
                                    </cfif>
                                </td>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='33876.Bu Satıra İlişkin Kayıtlı Harcama Bilgilerini İptal Ediyorsunuz Emin misiniz'></cfsavecontent>
                                <td>
                                    <cfif get_kontrol_last.recordcount><a href="javascript://" onClick="javascript:if(confirm('#message#')) windowopen('#request.self#?fuseaction=objects.emptypopup_del_cost_info&invoice_row_id=#invoice_row_id#&invoice_id=#url.id#&invoice_cat=#invoice_cat#<cfif isdefined("attributes.is_stock_fis")>&is_stock_fis=1</cfif>','small'); else return false;"><img src="/images/delete_list.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id ='33875.Harcama Bilgisini İptal Et'>"></a></cfif>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </cf_flat_list>
            <cf_box_footer>
                <cfif not isdefined("attributes.is_stock_fis")>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()' type_format="1">
                </cfif>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
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
		window.opener.document.form_basket.is_cost.value=1;
		return true;
	}
</script>
