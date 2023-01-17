<div style="display:none;z-index:10;" id="wizard_div"></div>
<cfif not isdefined("attributes.is_stock_fis")>
	<cfquery name="GET_INVOICE_ROW" datasource="#dsn2#">
		SELECT 
			INVOICE_ROW.GROSSTOTAL,
			INVOICE_ROW.NAME_PRODUCT, 
			INVOICE_ROW.INVOICE_ROW_ID,
			INVOICE.INVOICE_DATE,
			INVOICE_ROW.STOCK_ID,
			INVOICE_ROW.INVOICE_ID,
			INVOICE_ROW.UNIT,
			INVOICE_ROW.AMOUNT,
			INVOICE_ROW.PRODUCT_ID,
			INVOICE_ROW.NETTOTAL,
			INVOICE_ROW.TAXTOTAL,
			INVOICE_ROW.OTVTOTAL,
			ISNULL(INVOICE_ROW.BSMV_AMOUNT,0) BSMVTOTAL,
			ISNULL(INVOICE_ROW.OIV_AMOUNT,0) OIVTOTAL,
			ISNULL(INVOICE_ROW.TEVKIFAT_AMOUNT,0) TEVKIFATTOTAL,
			INVOICE_ROW.TAX,
			INVOICE_ROW.OTV_ORAN,
			ISNULL(INVOICE_ROW.BSMV_RATE,0) BSMV_ORAN,
			ISNULL(INVOICE_ROW.OIV_RATE,0) OIV_ORAN,
			ISNULL(INVOICE_ROW.TEVKIFAT_RATE,0) TEVKIFAT_ORAN,
			INVOICE_ROW.OTHER_MONEY,
			INVOICE_ROW.OTHER_MONEY_VALUE,
			INVOICE_ROW.OTHER_MONEY_GROSS_TOTAL,
			INVOICE.INVOICE_NUMBER,
			INVOICE.COMPANY_ID,
			INVOICE.PARTNER_ID,
			INVOICE.CONSUMER_ID,
			INVOICE.DEPARTMENT_ID,
			ISNULL(INVOICE.PROCESS_DATE,INVOICE.INVOICE_DATE) AS PROCESS_DATE
		FROM 
			INVOICE_ROW,
			INVOICE
		WHERE 
			INVOICE_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_row_id#"> AND
			INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID
	</cfquery>
<cfelse>
	<!--- Bu querylerin ayrı ayrı yazılması gerekiyor union olunca bizde sorun olmuyor fakat SQL 2000 kullanan müşterilerde çakıyor. SM --->
	<cfquery name="GET_INVOICE_ROW1" datasource="#dsn2#">
		SELECT
			ISNULL((SELECT TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*STOCK_FIS_ROW.AMOUNT FROM #DSN3_ALIAS#.PRODUCT_COST PC WHERE PC.PRODUCT_ID=STOCKS.PRODUCT_ID AND START_DATE <= STOCK_FIS.FIS_DATE AND SPECT_MAIN_ID IS NULL ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC),((COST_PRICE+EXTRA_COST)*STOCK_FIS_ROW.AMOUNT)) GROSSTOTAL,
			STOCKS.PRODUCT_NAME NAME_PRODUCT, 
			STOCK_FIS_ROW.STOCK_FIS_ROW_ID INVOICE_ROW_ID,
			STOCK_FIS_ROW.STOCK_ID,
			STOCK_FIS.FIS_DATE INVOICE_DATE,
			0 TAXTOTAL,
			0 OTVTOTAL,
			0 BSMVTOTAL,
			0 OIVTOTAL,
			0 TEVKIFATTOTAL,
			0 TAX,
			0 OTV_ORAN,
			0 BSMV_ORAN,
			0 OIV_ORAN,
			0 TEVKIFAT_ORAN,
			STOCK_FIS.FIS_ID INVOICE_ID,
			STOCK_FIS_ROW.UNIT,
			STOCK_FIS_ROW.AMOUNT,
			STOCKS.PRODUCT_ID,
			ISNULL((SELECT TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*STOCK_FIS_ROW.AMOUNT FROM #DSN3_ALIAS#.PRODUCT_COST PC WHERE PC.PRODUCT_ID=STOCKS.PRODUCT_ID AND START_DATE <= STOCK_FIS.FIS_DATE AND SPECT_MAIN_ID IS NULL ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC),((COST_PRICE+EXTRA_COST)*STOCK_FIS_ROW.AMOUNT)) NETTOTAL,
			ISNULL((SELECT TOP 1 MONEY FROM #DSN3_ALIAS#.PRODUCT_COST PC WHERE PC.PRODUCT_ID=STOCKS.PRODUCT_ID AND START_DATE <= STOCK_FIS.FIS_DATE AND SPECT_MAIN_ID IS NULL ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC),'#session.ep.money#') OTHER_MONEY,
			ISNULL((SELECT TOP 1 (PURCHASE_NET+PURCHASE_EXTRA_COST)*STOCK_FIS_ROW.AMOUNT FROM #DSN3_ALIAS#.PRODUCT_COST PC WHERE PC.PRODUCT_ID=STOCKS.PRODUCT_ID AND START_DATE <= STOCK_FIS.FIS_DATE AND SPECT_MAIN_ID IS NULL ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC),((COST_PRICE+EXTRA_COST)*STOCK_FIS_ROW.AMOUNT)) OTHER_MONEY_VALUE,
			ISNULL((SELECT TOP 1 (PURCHASE_NET+PURCHASE_EXTRA_COST)*STOCK_FIS_ROW.AMOUNT FROM #DSN3_ALIAS#.PRODUCT_COST PC WHERE PC.PRODUCT_ID=STOCKS.PRODUCT_ID AND START_DATE <= STOCK_FIS.FIS_DATE AND SPECT_MAIN_ID IS NULL ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC),((COST_PRICE+EXTRA_COST)*STOCK_FIS_ROW.AMOUNT)) OTHER_MONEY_GROSS_TOTAL,
			STOCK_FIS.FIS_NUMBER INVOICE_NUMBER,
			NULL COMPANY_ID,
			NULL PARTNER_ID,
			NULL CONSUMER_ID,
			NULL DEPARTMENT_ID,
			STOCK_FIS.FIS_DATE AS PROCESS_DATE
		FROM
			STOCK_FIS,
			STOCK_FIS_ROW,
			#DSN3_ALIAS#.STOCKS AS STOCKS
		WHERE
			STOCK_FIS_ROW.STOCK_FIS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_row_id#"> AND
			STOCK_FIS_ROW.FIS_ID = STOCK_FIS.FIS_ID AND
			STOCKS.STOCK_ID = STOCK_FIS_ROW.STOCK_ID AND
			STOCK_FIS_ROW.SPECT_VAR_ID IS NULL
	</cfquery>
	<cfquery name="GET_INVOICE_ROW2" datasource="#dsn2#">
		SELECT
			ISNULL((SELECT TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*STOCK_FIS_ROW.AMOUNT FROM #DSN3_ALIAS#.PRODUCT_COST PC WHERE PC.PRODUCT_ID=STOCKS.PRODUCT_ID AND START_DATE <= STOCK_FIS.FIS_DATE AND SPECT_MAIN_ID=SPECTS.SPECT_MAIN_ID ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC),((COST_PRICE+EXTRA_COST)*STOCK_FIS_ROW.AMOUNT)) GROSSTOTAL,
			STOCKS.PRODUCT_NAME NAME_PRODUCT, 
			STOCK_FIS_ROW.STOCK_FIS_ROW_ID INVOICE_ROW_ID,
			STOCK_FIS_ROW.STOCK_ID,
			STOCK_FIS.FIS_DATE INVOICE_DATE,
			0 TAXTOTAL,
			0 OTVTOTAL,
			0 BSMVTOTAL,
			0 OIVTOTAL,
			0 TEVKIFATTOTAL,
			0 TAX,
			0 OTV_ORAN,
			0 BSMV_ORAN,
			0 OIV_ORAN,
			0 TEVKIFAT_ORAN,
			STOCK_FIS.FIS_ID INVOICE_ID,
			STOCK_FIS_ROW.UNIT,
			STOCK_FIS_ROW.AMOUNT,
			STOCKS.PRODUCT_ID,
			ISNULL((SELECT TOP 1 (PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM)*STOCK_FIS_ROW.AMOUNT FROM #DSN3_ALIAS#.PRODUCT_COST PC WHERE PC.PRODUCT_ID=STOCKS.PRODUCT_ID AND START_DATE <= STOCK_FIS.FIS_DATE AND SPECT_MAIN_ID=SPECTS.SPECT_MAIN_ID ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC),((COST_PRICE+EXTRA_COST)*STOCK_FIS_ROW.AMOUNT)) NETTOTAL,
			ISNULL((SELECT TOP 1 MONEY FROM #DSN3_ALIAS#.PRODUCT_COST PC WHERE PC.PRODUCT_ID=STOCKS.PRODUCT_ID AND START_DATE <= STOCK_FIS.FIS_DATE AND SPECT_MAIN_ID=SPECTS.SPECT_MAIN_ID ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC),'#session.ep.money#') OTHER_MONEY,
			ISNULL((SELECT TOP 1 (PURCHASE_NET+PURCHASE_EXTRA_COST)*STOCK_FIS_ROW.AMOUNT FROM #DSN3_ALIAS#.PRODUCT_COST PC WHERE PC.PRODUCT_ID=STOCKS.PRODUCT_ID AND START_DATE <= STOCK_FIS.FIS_DATE AND SPECT_MAIN_ID=SPECTS.SPECT_MAIN_ID ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC),((COST_PRICE+EXTRA_COST)*STOCK_FIS_ROW.AMOUNT)) OTHER_MONEY_VALUE,
			ISNULL((SELECT TOP 1 (PURCHASE_NET+PURCHASE_EXTRA_COST)*STOCK_FIS_ROW.AMOUNT FROM #DSN3_ALIAS#.PRODUCT_COST PC WHERE PC.PRODUCT_ID=STOCKS.PRODUCT_ID AND START_DATE <= STOCK_FIS.FIS_DATE AND SPECT_MAIN_ID=SPECTS.SPECT_MAIN_ID ORDER BY START_DATE DESC,RECORD_DATE DESC,PRODUCT_COST_ID DESC),((COST_PRICE+EXTRA_COST)*STOCK_FIS_ROW.AMOUNT)) OTHER_MONEY_GROSS_TOTAL,
			STOCK_FIS.FIS_NUMBER INVOICE_NUMBER,
			NULL COMPANY_ID,
			NULL PARTNER_ID,
			NULL CONSUMER_ID,
			NULL DEPARTMENT_ID,
			STOCK_FIS.FIS_DATE AS PROCESS_DATE
		FROM
			STOCK_FIS,
			STOCK_FIS_ROW,
			#DSN3_ALIAS#.STOCKS AS STOCKS,
			#DSN3_ALIAS#.SPECTS SPECTS
		WHERE
			STOCK_FIS_ROW.STOCK_FIS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_row_id#"> AND
			STOCK_FIS_ROW.FIS_ID = STOCK_FIS.FIS_ID AND
			STOCKS.STOCK_ID = STOCK_FIS_ROW.STOCK_ID AND
			STOCK_FIS_ROW.SPECT_VAR_ID=SPECTS.SPECT_VAR_ID
	</cfquery>
	<cfquery name="GET_INVOICE_ROW" dbtype="query">
		SELECT * FROM GET_INVOICE_ROW1
		UNION ALL
		SELECT * FROM GET_INVOICE_ROW2
	</cfquery>
</cfif>
<cfquery name="GET_PRODUCT_PER" datasource="#dsn3#">
	SELECT EXPENSE_TEMPLATE_ID FROM PRODUCT_PERIOD WHERE PRODUCT_ID = #get_invoice_row.product_id# AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfif len(get_invoice_row.other_money)>
	<cfquery name="GET_MONEY" datasource="#dsn#">
		SELECT RATE2, RATE1 FROM SETUP_MONEY WHERE MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_invoice_row.other_money#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
</cfif>
<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>
<cfquery name="GET_WORKGROUPS" datasource="#dsn#">
	SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND IS_BUDGET = 1 ORDER BY WORKGROUP_NAME
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_NAME, EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 AND IS_ACTIVE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE, EXPENSE_ID, EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ACTIVE = 1 ORDER BY EXPENSE_CODE
</cfquery>
<cfset components2 = createObject('component','V16.workdata.get_budget_period_date')>
<cfset budget_date = components2.get_budget_period_date()>
<cfsavecontent  variable="right">
	<div id = "tabMenu">
		<a href = "#" onClick = "open_wizard();" ><cf_get_lang dictionary_id='59935.Planlama Sihirbazı'></a>
	</div>
</cfsavecontent>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='33004.Ayrıntılı Maliyet Dağıtımı'></cfsavecontent>
<cf_popup_box title="#message#" right_images = "#right#">
	<cfform name="add_collacted_expense_rows" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_expensecenter_invoce_detail">
		<cfif isdefined('attributes.is_stock_fis')>
			<input type="hidden" name="is_stock_fis" id="is_stock_fis" value="1">
		</cfif>
		<cfinput type="hidden" name="budget_period" id="budget_period" value="#dateformat(budget_date.budget_period_date,dateformat_style)#">
		<input type="hidden" name="invoice_row_id" id="invoice_row_id" value="<cfoutput>#attributes.invoice_row_id#</cfoutput>">
		<input type="hidden" name="name_product" id="name_product" value="<cfoutput>#get_invoice_row.name_product#</cfoutput>">
		<input type="hidden" name="invoice_number" id="invoice_number" value="<cfoutput>#get_invoice_row.invoice_number#</cfoutput>">
		<input type="hidden" name="expense_date" id="expense_date" value="<cfoutput>#dateformat(get_invoice_row.process_date,dateformat_style)#</cfoutput>">
		<input type="hidden" name="page_type" id="page_type" value="<cfoutput>#get_process_name(attributes.invoice_cat)#</cfoutput>">		
		<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#get_invoice_row.stock_id#</cfoutput>">	
		<input type="hidden" name="invoice_id" id="invoice_id" value="<cfoutput>#get_invoice_row.invoice_id#</cfoutput>">
		<input type="hidden" name="grosstotal" id="grosstotal" value="<cfoutput>#tlformat(get_invoice_row.grosstotal)#</cfoutput>">
		<input type="hidden" name="invoice_cat" id="invoice_cat" value="<cfoutput>#url.invoice_cat#</cfoutput>">
			<cfoutput>
				<table>
					<tr>
						<td style="width:100px"> <b><cf_get_lang dictionary_id='57519.Cari Hesap'></b></td>
						<td style="width:130px"><cfif len(get_invoice_row.company_id)>#get_par_info(get_invoice_row.company_id,1,1,0)#<cfelseif len(get_invoice_row.consumer_id)>#get_cons_info(get_invoice_row.consumer_id,1,0)#</cfif><cfif len(get_invoice_row.partner_id)> - #get_par_info(get_invoice_row.partner_id,0,-1,0)#</cfif></td>
						<td style="width:120px"><b><cfif not isdefined("attributes.is_stock_fis")><cf_get_lang dictionary_id='58133.Fatura No'><cfelse><cf_get_lang dictionary_id='33102.Stok Fişi'></cfif></b></td>
						<td style="width:100px">#get_invoice_row.invoice_number#</td>
						<td style="width:100px"><b><cfif not isdefined("attributes.is_stock_fis")><cf_get_lang dictionary_id='58759.Fatura Tarihi'><cfelse><cf_get_lang dictionary_id='57879.İşlem Tarihi'></cfif></b></td>
						<td>#dateformat(get_invoice_row.invoice_date,dateformat_style)#</td>
					</tr>
					<tr>
						<td><b><cf_get_lang dictionary_id ='57657.Ürün'></b></td> <td> #get_invoice_row.name_product#</td>
						<td><b><cf_get_lang dictionary_id ='57635.Miktar'></b></td> <td>#get_invoice_row.amount# #get_invoice_row.unit#</td>
						<td><b><cf_get_lang dictionary_id ='57492.Toplam'></b></td> <td>#get_invoice_row.grosstotal#</td>
					</tr>
				</table>			 
			</cfoutput>
			<cf_form_list>
                <thead>
                    <tr>
                        <th style="text-align:center; width:40px;"><input type="button" class="eklebuton" title="<cf_get_lang dictionary_id ='57582.Ekle'>" onClick="add_row();"></th>
		                <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <th style="width:150px;"><cf_get_lang dictionary_id ='58460.Masraf Merkezi'>*</th>
                        <th style="width:150px;"><cf_get_lang dictionary_id ='58551.Gider Kalemi'>*</th>
                        <th style="width:150px;"><cf_get_lang dictionary_id ='33167.Aktivite Tipi'></th>
                        <th style="width:150px;"><cf_get_lang dictionary_id ='58140.Is Grubu'></th>
                        <th style="width:230px;"><cf_get_lang dictionary_id ='33257.Harcama Yapan'></th>
                        <th style="width:120px;"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></th>
						<th><cf_get_lang dictionary_id='29502.Abone No'></th>
                        <th style="width:120px;"><cf_get_lang dictionary_id ='57416.Proje'> </th>
                        <th width="40">%</th>
                        <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                    </tr>
                </thead>
				<tbody id="table1">
					<cfset toplam_rate = 0>
                    <cfset toplam_amount = 0>
                    <cfif len(get_product_per.expense_template_id)>
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
                                EXPENSE_PLANS_TEMPLATES.TEMPLATE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_per.expense_template_id#"> AND
                                EXPENSE_PLANS_TEMPLATES.TEMPLATE_ID = EXPENSE_PLANS_TEMPLATES_ROWS.TEMPLATE_ID
                                AND (EXPENSE_PLANS_TEMPLATES.IS_DEPARTMENT=0 <cfif len(GET_INVOICE_ROW.DEPARTMENT_ID)>OR (EXPENSE_PLANS_TEMPLATES.IS_DEPARTMENT=1 AND EXPENSE_PLANS_TEMPLATES_ROWS.DEPARTMENT_ID=#GET_INVOICE_ROW.DEPARTMENT_ID#)</cfif>)
                        </cfquery>
                        <cfif get_expense_template.recordcount>
                            <input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_expense_template.recordcount#</cfoutput>">
                        <cfelse>
                            <input name="record_num" id="record_num" type="hidden" value="0">
                        </cfif>
                        <cfoutput query="get_expense_template">
                        <cfif len(ASSET_ID)>
                            <cfquery name="GET_ROW_ASSET" datasource="#dsn#">
                                SELECT ASSETP_ID, ASSETP FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#asset_id#">
                            </cfquery>
                        </cfif>
                        <cfif len(PROJECT_ID)>
                            <cfquery name="GET_ROW_PROJECT" datasource="#dsn#">	
                                SELECT PROJECT_ID, PROJECT_HEAD FROM  PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#">
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
                        <input type="hidden" name="tax#currentrow#" id="tax#currentrow#" value="#get_invoice_row.tax#">
						<input type="hidden" name="otv_oran#currentrow#" id="otv_oran#currentrow#" value="#get_invoice_row.otv_oran#">
						<input type="hidden" name="bsmv_oran#currentrow#" id="bsmv_oran#currentrow#" value="#get_invoice_row.bsmv_oran#">
						<input type="hidden" name="oiv_oran#currentrow#" id="oiv_oran#currentrow#" value="#get_invoice_row.oiv_oran#">
						<input type="hidden" name="tevkifat_oran#currentrow#" id="tevkifat_oran#currentrow#" value="#get_invoice_row.tevkifat_oran#">
                        <input type="hidden" name="other_money_value#currentrow#" id="other_money_value#currentrow#" value="#tlformat(get_invoice_row.other_money_value)#">
                        <input type="hidden" name="other_money_grosstotal#currentrow#" id="other_money_grosstotal#currentrow#" value="#tlformat(get_invoice_row.other_money_gross_total)#">
                        <input type="hidden" name="rate_value_one#currentrow#" id="rate_value_one#currentrow#" value="<cfif isdefined("get_money.rate1")>#tlformat(get_money.rate1)#<cfelse>1</cfif>">	
                        <input type="hidden" name="rate_value_two#currentrow#" id="rate_value_two#currentrow#" value="<cfif isdefined("get_money.rate2")>#tlformat(get_money.rate2)#<cfelse>1</cfif>">	
                        <tr id="frm_row#currentrow#">
                            <td><input  type="hidden" value="1" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#"><a style="cursor:pointer" onclick="sil('#currentrow#');"><img  src="images/delete_list.gif" border="0"></a></td>
							<td style = "width:85px;">
								<input type = "text" id = "expense_date#currentrow#" name = "expense_date#currentrow#" style = "width:65px;" value = "#dateformat(expense_date,dateformat_style)#">
								<cf_wrk_date_image date_field="expense_date#currentrow#">
							</td>
                            <td>
                                <select name="expense_center_ids#currentrow#" id="expense_center_ids#currentrow#" style="width:120px;">
                                    <cfset template_center = get_expense_template.expense_center_id>
                                    <option value=""><cf_get_lang dictionary_id='58460.Masraf Merkezi'></option>
                                    <cfloop query="get_expense_center">
                                    	<option value="#expense_id#" <cfif listfind(template_center eq expense_id,EXPENSE_ID,',')>selected</cfif>>
											<cfloop from="2" to="#ListLen(EXPENSE_CODE,".")#" index="i">
												&nbsp;&nbsp;
											</cfloop>
											#expense#
										</option>
                                    </cfloop>
                                </select>
                            </td>
                            <td>
                                <select name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" style="width:120px;">
                                    <option value=""><cf_get_lang dictionary_id='58551.Gider Kalemi'></option>
                                    <cfset template_item = get_expense_template.expense_item_id>
                                <cfloop query="get_expense_item">
                                    <option value="#expense_item_id#" <cfif template_item eq expense_item_id>selected</cfif>>#expense_item_name#</option>
                                </cfloop>
                                </select>
                            </td>
                            <td>
                                <select name="activity_type#currentrow#" id="activity_type#currentrow#" style="width:120px;">
                                    <option value=""><cf_get_lang dictionary_id ='33167.Aktivite Tipi'></option>
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
                                <!--- EĞER ŞABLON VARSA ORDA KAYITLAR POZİSTON_code la ANCAK HARCAMA YAPANDA EMPLOYEE_ID TUTMALI--->
                                <cfquery name="get_emp_id" datasource="#dsn#">
                                    SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_partner_id#">
                                </cfquery>
                            <td>
                                <input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="employee">
                                <input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#get_emp_id.EMPLOYEE_ID#">
                                <input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="#company_partner_id#">
                                <input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
                                <input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:100px;" class="txt">
                                <input type="text" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_emp_info(company_partner_id,1,0)#" class="txt" style="width:100px;"><a href="javascript://" onClick="pencere_ac_company('#currentrow#');"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
                            </td>
                            <cfelseif member_type eq 'partner'>
                            <td>
                                <input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="partner">
                                <input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#company_partner_id#">
                                <input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
                                <input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
                                <input type="text" name="company#currentrow#" id="company#currentrow#" value="#get_par_info(company_id,1,0,0)#" style="width:100px;" class="txt">
                                <input type="text" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_par_info(company_partner_id,0,-1,0)#" class="txt" style="width:100px;"><a href="javascript://" onClick="pencere_ac_company('#currentrow#');"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
                            </td>
                            <cfelseif member_type eq 'consumer'>
                            <td>
                                <input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="consumer">
                                <input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="#company_partner_id#">
                                <input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
                                <input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
                                <input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:100px;" class="txt">
                                <input type="text" name="authorized#currentrow#" id="authorized#currentrow#" value="#get_cons_info(company_partner_id,2,0)#" class="txt" style="width:100px;"><a href="javascript://" onClick="pencere_ac_company('#currentrow#');"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
                            </td>
                            <cfelse>
                            <td>
                                <input type="hidden" name="member_type#currentrow#" id="member_type#currentrow#" value="">
                                <input type="hidden" name="member_id#currentrow#" id="member_id#currentrow#" value="">
                                <input type="hidden" name="member_code#currentrow#" id="member_code#currentrow#" value="">
                                <input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="">
                                <input type="text" name="company#currentrow#" id="company#currentrow#" value="" style="width:100px;">
                                <input type="text" name="authorized#currentrow#" id="authorized#currentrow#" value="" style="width:100px;"><a href="javascript://" onClick="pencere_ac_company('#currentrow#');"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
                            </td>
                            </cfif>
                            <td><input type="hidden" name="asset_id#currentrow#" id="asset_id#currentrow#" value="#ASSET_ID#"><input type="text" name="asset#currentrow#" id="asset#currentrow#" value="<cfif len(ASSET_ID)>#GET_ROW_ASSET.ASSETP#</cfif>" style="width:100px;"><a href="javascript://" onClick="pencere_ac_asset('#currentrow#');"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a></td>
                            <td nowrap="nowrap">
								<input type="hidden" name="subscription_id#currentrow#" id="subscription_id#currentrow#" value="">
								<input type="text" name="subscription_name#currentrow#" id="subscription_name#currentrow#" onFocus="AutoComplete_Create('subscription_name#currentrow#','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id#currentrow#','','3','150');" value="" style="width:100px;">
								<a href="javascript://" onClick="pencere_ac_subs('#currentrow#');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
							</td>
							<td><input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#PROJECT_ID#"><input type="text" name="project#currentrow#" id="project#currentrow#" value="<cfif len(PROJECT_ID)>#GET_ROW_PROJECT.PROJECT_HEAD#</cfif>" style="width:100px;"><a href="javascript://" onClick="pencere_ac_project('#currentrow#');"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a></td>
                            <td><input type="text" name="expense_item_value#currentrow#" id="expense_item_value#currentrow#" style="width:40px;" onBlur="toplam_center();" onkeyup="isNumber(this);" value="#tlformat(rate)#" class="moneybox"></td>
                            <td><input type="text" name="total_expense_item#currentrow#" id="total_expense_item#currentrow#"  value="#tlformat((rate*get_invoice_row.grosstotal)/100)#" onkeyup="isNumber(this);" style="width:75px;" maxlength="3" onBlur="toplam_center();" class="moneybox"></td>
                        </tr>
                        <cfset toplam_rate = toplam_rate + rate>
                        <cfset toplam_amount = toplam_amount + ((get_invoice_row.grosstotal*rate)/100)>
                        </cfoutput>
                    <cfelse>
                        <input name="record_num" id="record_num" type="hidden" value="0">
                    </cfif>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="12" style="text-align:right;"><b><cf_get_lang dictionary_id ='57492.Toplam'></b><cfinput type="text" name="total_amount" style="width:40px;" value="#tlformat(toplam_rate)#" readonly="yes" class="moneybox"> <cfinput type="text" name="total_rate" style="width:75px;" value="#tlformat(toplam_amount)#" readonly="yes" class="moneybox">&nbsp;</td>
                    </tr>
                </tfoot>
		</cf_form_list>
		<cf_popup_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
	function open_wizard() {
		document.getElementById("wizard_div").style.display ='';
		
		$("#wizard_div").css('margin-left',$("#tabMenu").position().left - 300);
		$("#wizard_div").css('margin-top',$("#tabMenu").position().top + 20);
		$("#wizard_div").css('position','absolute');
		
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_budget_row_calculator&type=invoice_expense','wizard_div',1);
		return true;
	}

	<cfif isdefined("get_expense_template.recordcount") and get_expense_template.recordcount>
		row_count=<cfoutput>#get_expense_template.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
	function sil(sy)
	{
		var my_element=eval("add_collacted_expense_rows.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function kontrol_et()
	{
		if(row_count ==0)
			return false;
		else
			return true;
	}
	function add_row(expense_date,exp_center_id,exp_item_id,exp_act_id,exp_work_id,exp_member_type,exp_partner_id,exp_comp_id,exp_authorized,exp_comp_name,exp_asset_id,exp_asset_name,exp_pro_id,exp_pro_name,exp_rate,exp_amount,exp_subs_id,exp_subs_name)
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
			
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.add_collacted_expense_rows.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<cfoutput><input type="hidden" name="other_money' + row_count +'" value="#get_invoice_row.other_money#"><input type="hidden" name="grosstotal' + row_count +'" value="#tlformat(get_invoice_row.grosstotal)#"><input type="hidden" name="nettotal' + row_count +'" value="#tlformat(get_invoice_row.nettotal)#"><input type="hidden" name="taxtotal' + row_count +'" value="#tlformat(get_invoice_row.taxtotal)#"><input type="hidden" name="otvtotal' + row_count +'" value="#tlformat(get_invoice_row.otvtotal)#"><input type="hidden" name="bsmvtotal' + row_count +'" value="#tlformat(get_invoice_row.bsmvtotal)#"><input type="hidden" name="oivtotal' + row_count +'" value="#tlformat(get_invoice_row.oivtotal)#"><input type="hidden" name="tevkifattotal' + row_count +'" value="#tlformat(get_invoice_row.tevkifattotal)#"><input type="hidden" name="tax' + row_count +'" value="#get_invoice_row.tax#"><input type="hidden" name="otv_oran' + row_count +'" value="#get_invoice_row.otv_oran#"><input type="hidden" name="bsmv_oran' + row_count +'" value="#get_invoice_row.bsmv_oran#"><input type="hidden" name="oiv_oran' + row_count +'" value="#get_invoice_row.oiv_oran#"><input type="hidden" name="tevkifat_oran' + row_count +'" value="#get_invoice_row.tevkifat_oran#"><input type="hidden" name="other_money_grosstotal' + row_count +'" value="#tlformat(get_invoice_row.other_money_gross_total)#"><input type="hidden" name="other_money_value' + row_count +'" value="#tlformat(get_invoice_row.other_money_value)#"><input type="hidden" name="rate_value_one' + row_count +'" value="<cfif isdefined('get_money.rate1')>#tlformat(get_money.rate1)#<cfelse>1</cfif>"><input type="hidden" name="rate_value_two' + row_count +'" value="<cfif isdefined('get_money.rate2')>#tlformat(get_money.rate2)#<cfelse>1</cfif>"></cfoutput><input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang dictionary_id='58972.Satır Kopyala'>"><img  src="images/copy_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);

		newCell.setAttribute("nowrap","nowrap");
		newCell.setAttribute("id","expense_date" + row_count + "_td");
		newCell.innerHTML = '<input type="text" id="expense_date' + row_count +'" name="expense_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="' + expense_date +'"> ';
		wrk_date_image('expense_date' + row_count);
		newCell = newRow.insertCell(newRow.cells.length);


		c = '<select name="expense_center_ids' + row_count  +'" id="expense_center_ids' + row_count  +'" style="width:120px;" class="text"><option value="">Gelir Merkezi</option>';
		<cfoutput query="get_expense_center">
		if('#expense_id#' == exp_center_id)
			c += '<option value="#expense_id#" selected><cfloop from="2" to="#ListLen(EXPENSE_CODE,".")#" index="i">&nbsp;&nbsp;</cfloop>#expense#</option>';
		else
			c += '<option value="#expense_id#"><cfloop from="2" to="#ListLen(EXPENSE_CODE,".")#" index="i">&nbsp;&nbsp;</cfloop>#expense#</option>';
		</cfoutput>
		newCell.innerHTML =c+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		a = '<select name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:120px;" class="text"><option value="">Gelir Kalemi</option>';
		<cfoutput query="get_expense_item">
		if('#expense_item_id#' == exp_item_id)
			a += '<option value="#expense_item_id#" selected>#expense_item_name#</option>';
		else
			a += '<option value="#expense_item_id#">#expense_item_name#</option>';
		</cfoutput>
		newCell.innerHTML =a+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);		
		b = '<select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:120px;" class="text"><option value="">Aktivite Tipi</option>';
		<cfoutput query="get_activity_types">
		if('#activity_id#' == exp_act_id)
			b += '<option value="#activity_id#" selected>#activity_name#</option>';
		else
			b += '<option value="#activity_id#">#activity_name#</option>';
		</cfoutput>
		newCell.innerHTML =b+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		c = '<select name="workgroup_id' + row_count  +'" id="workgroup_id' + row_count  +'" style="width:150px;"><option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>';
		<cfoutput query="get_workgroups">
		if('#workgroup_id#' == exp_work_id)
			c += '<option value="#workgroup_id#" selected>#workgroup_name#</option>';
		else
			c += '<option value="#workgroup_id#">#workgroup_name#</option>';
		</cfoutput>
		newCell.innerHTML =c+ '</select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value="'+exp_member_type+'"><input type="hidden" name="member_code'+ row_count +'" value="'+exp_partner_id+'"><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'" value="'+exp_partner_id+'"><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value="'+exp_comp_id+'"><input type="text" name="company'+ row_count +'" id="company'+ row_count +'" value="'+exp_comp_name+'" style="width:100px;"> <input type="text" style="width:100px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="'+exp_authorized+'"><a href="javascript://" onClick="pencere_ac_company('+ row_count +');"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value="'+exp_asset_id+'"><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="'+exp_asset_name+'" style="width:95px;" onFocus="AutoComplete_Create(\'asset'+ row_count +'\',\'ASSETP\',\'ASSETP\',\'get_assetp_autocomplete\',\'\',\'ASSETP_ID\',\'asset_id'+ row_count +'\',\'\',3,130)"><a href="javascript://" onClick="pencere_ac_asset('+ row_count +');"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input type="hidden" name="subscription_id'+ row_count +'" id="subscription_id'+ row_count +'" value="'+exp_subs_id+'"><input type="text" name="subscription_name'+ row_count +'" id="subscription_name'+ row_count +'" value="'+exp_subs_name+'" style="width:100px;" onFocus="auto_subscription('+ row_count +');"> <a href="javascript://" onClick="pencere_ac_subs('+ row_count +');" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+exp_pro_id+'"><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="'+exp_pro_name+'" style="width:95px;" onFocus="AutoComplete_Create(\'project'+ row_count +'\',\'PROJECT_HEAD\',\'PROJECT_HEAD\',\'get_project\',\'\',\'PROJECT_ID\',\'project_id'+ row_count +'\',\'\',3,200)"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" name="expense_item_value' + row_count +'" id="expense_item_value' + row_count +'" style="width:40px;" onBlur="toplam_center();" onKeyup="isNumber(this);" value="'+exp_rate+'" class="moneybox">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="rate_value1' + row_count +'" value="1"><input type="hidden" name="rate_value2' + row_count +'" value="1"><input type="text" name="total_expense_item' + row_count +'" id="total_expense_item' + row_count +'" value="'+exp_amount+'" style="width:75px;" onBlur="toplam_center2();" class="moneybox">';
		}
		
	function copy_row(no_info)
	{
		expense_date = eval("document.getElementById('expense_date" + no_info + "')").value;
		exp_center_id = eval("document.getElementById('expense_center_ids" + no_info + "')").value;
		exp_item_id = eval("document.getElementById('expense_item_id" + no_info + "')").value;
		
		if(eval("document.getElementById('activity_type" + no_info + "')") != undefined)
			exp_act_id = eval("document.getElementById('activity_type" + no_info + "')").value;
		else
			exp_act_id = '';
		if(eval("document.getElementById('workgroup_id" + no_info + "')") != undefined)
			exp_work_id = eval("document.getElementById('workgroup_id" + no_info + "')").value;
		else
			exp_work_id = '';
		exp_member_type = eval("document.getElementById('member_type" + no_info + "')").value;
		exp_partner_id = eval("document.getElementById('member_id" + no_info + "')").value;
		exp_comp_id = eval("document.getElementById('company_id" + no_info + "')").value;
		exp_authorized = eval("document.getElementById('authorized" + no_info + "')").value;
		exp_comp_name = eval("document.getElementById('company" + no_info + "')").value;
		if(eval("document.getElementById('asset_id" + no_info + "')") != undefined)
		{
			exp_asset_id = eval("document.getElementById('asset_id" + no_info + "')").value;
			exp_asset_name = eval("document.getElementById('asset" + no_info + "')").value;
		}
		else
		{
			exp_asset_id = '';
			exp_asset_name = '';
		}
		if(eval("document.getElementById('project_id" + no_info + "')") != undefined)
		{
			exp_pro_id = eval("document.getElementById('project_id" + no_info + "')").value;
			exp_pro_name = eval("document.getElementById('project" + no_info + "')").value;
		}
		else
		{
			exp_pro_id = '';
			exp_pro_name = '';
		}
		if(eval("document.getElementById('subscription_id" + no_info + "')") != undefined)
		{
			exp_subs_id = eval("document.getElementById('subscription_id" + no_info + "')").value;
			exp_subs_name = eval("document.getElementById('subscription_name" + no_info + "')").value;
		}
		else
		{
			exp_subs_id = '';
			exp_subs_name = '';
		}
		exp_rate = eval("document.getElementById('expense_item_value" + no_info + "')").value;
		exp_amount = eval("document.getElementById('total_expense_item" + no_info + "')").value;
		
		add_row(expense_date,exp_center_id,exp_item_id,exp_act_id,exp_work_id,exp_member_type,exp_partner_id,exp_comp_id,exp_authorized,exp_comp_name,exp_asset_id,exp_asset_name,exp_pro_id,exp_pro_name,exp_rate,exp_amount,exp_subs_id,exp_subs_name);
		toplam_center();
	}
	
	function toplam_center()
	{
		total_collection_rate = 0;
		total_collection = 0;
		add_collacted_expense_rows.grosstotal.value = filterNum(add_collacted_expense_rows.grosstotal.value);		
		for (var r=1;r<=row_count;r++)
		{
			form_expense_item_value = eval("document.add_collacted_expense_rows.expense_item_value"+r);
			form_total_expense_item = eval("document.add_collacted_expense_rows.total_expense_item"+r);
			form_row_kontrol = eval("document.add_collacted_expense_rows.row_kontrol"+r);
			if(form_expense_item_value.value == "") { form_expense_item_value.value = 0; }
			if(form_row_kontrol.value != 0)
			{
				form_expense_item_value.value = filterNum(form_expense_item_value.value);
				form_total_expense_item.value = (parseFloat(add_collacted_expense_rows.grosstotal.value) * parseFloat(form_expense_item_value.value) / 100);
				total_collection_rate = total_collection_rate + parseFloat(form_expense_item_value.value);
				total_collection = total_collection + parseFloat(form_total_expense_item.value);
				form_total_expense_item.value = commaSplit(form_total_expense_item.value);
				form_expense_item_value.value = commaSplit(form_expense_item_value.value);
			}
		}
		document.add_collacted_expense_rows.total_amount.value = commaSplit(total_collection_rate);
		document.add_collacted_expense_rows.total_rate.value = commaSplit(total_collection);
		add_collacted_expense_rows.grosstotal.value = commaSplit(add_collacted_expense_rows.grosstotal.value);
	}
	
	function toplam_center2()
	{
		total_collection_rate = 0;
		total_collection = 0;
		add_collacted_expense_rows.grosstotal.value = filterNum(add_collacted_expense_rows.grosstotal.value);		
		for (var r=1;r<=row_count;r++)
		{
			form_expense_item_value = eval("document.add_collacted_expense_rows.expense_item_value"+r);
			form_total_expense_item = eval("document.add_collacted_expense_rows.total_expense_item"+r);
			form_row_kontrol = eval("document.add_collacted_expense_rows.row_kontrol"+r);
			if(form_total_expense_item.value == "") { form_total_expense_item.value = 0; }
			if(form_row_kontrol.value != 0)
			{
				form_total_expense_item.value = filterNum(form_total_expense_item.value);
				form_expense_item_value.value = (100 * parseFloat(form_total_expense_item.value) / parseFloat(add_collacted_expense_rows.grosstotal.value));
				total_collection_rate = total_collection_rate + parseFloat(form_expense_item_value.value);
				total_collection = total_collection + parseFloat(form_total_expense_item.value);
				form_total_expense_item.value = commaSplit(form_total_expense_item.value);
				form_expense_item_value.value = commaSplit(form_expense_item_value.value);
			}
		}
		document.add_collacted_expense_rows.total_amount.value = commaSplit(total_collection_rate);
		document.add_collacted_expense_rows.total_rate.value = commaSplit(total_collection);
		add_collacted_expense_rows.grosstotal.value = commaSplit(add_collacted_expense_rows.grosstotal.value);
	}
	
	function pencere_ac_asset(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps&field_id=add_collacted_expense_rows.asset_id' + no +'&field_name=add_collacted_expense_rows.asset' + no +'&event_id=0&motorized_vehicle=0','list');
	}
	function pencere_ac_project(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_collacted_expense_rows.project_id' + no +'&project_head=add_collacted_expense_rows.project' + no);
	}
	function pencere_ac_subs(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=add_collacted_expense_rows.subscription_id' + no +'&field_no=add_collacted_expense_rows.subscription_name' + no,'list');
	}
	function auto_subscription(no)
	{
		AutoComplete_Create('subscription_name'+no,'SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID','subscription_id'+no,'','3','150');
	}
	
	function pencere_ac_company(no)
	{
		eval("document.add_collacted_expense_rows.member_type"+no).value = '';
		eval("document.add_collacted_expense_rows.member_id"+no).value = '';
		eval("document.add_collacted_expense_rows.company_id"+no).value = '';
		eval("document.add_collacted_expense_rows.company"+no).value = '';
		eval("document.add_collacted_expense_rows.authorized"+no).value = '';
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_collacted_expense_rows.member_id' + no +'&field_id=add_collacted_expense_rows.member_id' + no +'&field_comp_name=add_collacted_expense_rows.company' + no +'&field_name=add_collacted_expense_rows.authorized' + no +'&field_comp_id=add_collacted_expense_rows.company_id' + no + '&field_type=add_collacted_expense_rows.member_type' + no + '&select_list=1,2,3','list');
	}
	function kontrol()
	{
		add_collacted_expense_rows.total_amount.value = filterNum(add_collacted_expense_rows.total_amount.value);
		if(add_collacted_expense_rows.total_amount.value > 100)
		{
			alert("<cf_get_lang dictionary_id ='33878.Toplam Oran 100 den Büyük Olamaz'>!");
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
					alert("<cf_get_lang dictionary_id ='33881.Lütfen'>" + sira_deger + ".<cf_get_lang dictionary_id ='33879.Satırdakidaki Masraf Merkezini Seçiniz'>!");
					return false;
				}
				if(form_expense_item_id.value =="")
				{
					alert("<cf_get_lang dictionary_id ='33881.Lütfen'>" + sira_deger + ".<cf_get_lang dictionary_id ='33880.Satırdakidaki Gider Kalemini Seçiniz'>!");
					return false;
				}
				//Bütçe tarih kısıtı kontrolü
				if(!date_check_hiddens(document.getElementById("budget_period"),document.getElementById("expense_date"+r),'Bütçe dönemi kapandığı için satırdaki harcama tarihi '+document.getElementById("budget_period").value+' tarihinden sonra girilmiş olmalıdır.'))
				return false;
			}
		}
		if(sira_deger == 0)
		{
			alert("<cf_get_lang dictionary_id ='33822.Lütfen Satır Ekleyiniz'>!");
			return false;
		}
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
		window.opener.opener.document.form_basket.is_cost.value=1;
	}
	<cfif not isdefined('attributes.is_stock_fis') and isdefined("attributes.row_id") and not len(GET_PRODUCT_PER.EXPENSE_TEMPLATE_ID)>
		temp_id = eval('window.opener.document.all.exp_template_id'+<cfoutput>#attributes.row_id#</cfoutput>).value;
		if(temp_id != '')
		{
			var get_temp_rows = wrk_safe_query('obj_get_temp_rows','dsn2',0,emp_id);
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
					var get_pro_name = wrk_safe_query('obj_get_pro_name','dsn', 0, get_temp_rows.PROJECT_ID[i]);
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
					var get_pro_name = wrk_safe_query('obj_get_pro_name_2','dsn',0, get_temp_rows.ASSET_ID[i]);
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
					var get_comp_name = wrk_safe_query('obj_get_comp_name','dsn',0, exp_comp_id);
					exp_comp_name = get_comp_name.FULLNAME;
				}
				else
				{
					exp_comp_name = '';
				}
				if(exp_member_type != '' && exp_partner_id != '' && exp_member_type =='partner')
				{
					var get_par_name = wrk_safe_query('obj_get_par_name','dsn',0,exp_partner_id);
					exp_authorized = get_par_name.COMPANY_PARTNER_NAME+' '+get_par_name.COMPANY_PARTNER_SURNAME;
				}
				else if(exp_member_type != '' && exp_partner_id != '' && exp_member_type =='consumer')
				{
					var get_cons_name = wrk_safe_query('obj_get_cons_name','dsn',0,exp_partner_id);
					exp_authorized = get_cons_name.CONSUMER_NAME+' '+get_cons_name.CONSUMER_SURNAME;
				}
				else if(exp_member_type != '' && exp_partner_id != '' && exp_member_type =='employee')
				{
					var get_emp_name = wrk_safe_query('obj_get_emp_name','dsn',0,exp_partner_id);
					exp_authorized = get_emp_name.EMPLOYEE_NAME+' '+get_emp_name.EMPLOYEE_SURNAME;
				}
				else
				{
					exp_authorized = '';
				}
				add_row(exp_center_id,exp_item_id,exp_act_id,exp_work_id,exp_member_type,exp_partner_id,exp_comp_id,exp_authorized,exp_comp_name,exp_asset_id,exp_asset_name,exp_pro_id,exp_pro_name,get_temp_rows.RATE[i],exp_amount);
			}
			toplam_center2();	
		}
	</cfif>
</script>
