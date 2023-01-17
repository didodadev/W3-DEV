<!---SELECT ifadeleri düzenlendi 19072012 e.a--->
<cf_xml_page_edit fuseact="ch.form_add_premium_payment">
<cfset system_money_info = session.ep.money>
<cfinclude template="../../bank/query/get_accounts.cfm">
<cfquery name="get_payment" datasource="#dsn2#">
	SELECT 
		*
	FROM 
		INVOICE_MULTILEVEL_PAYMENT,
		#dsn3_alias#.CAMPAIGNS C 
	WHERE 
		C.CAMP_ID = CAMPAIGN_ID
		AND INV_PAYMENT_ID = #attributes.inv_payment_id# 
</cfquery>
<cfif len(get_payment.STOPPAGE_RATE_ID)>
	<cfquery name="get_rate" datasource="#dsn2#">
		SELECT STOPPAGE_RATE FROM SETUP_STOPPAGE_RATES WHERE STOPPAGE_RATE_ID = #get_payment.STOPPAGE_RATE_ID#
	</cfquery>
</cfif>
<cfquery name="get_rows" datasource="#dsn2#">
	SELECT 
		SUM(PAY_AMOUNT) PAY_AMOUNT,
		SUM(STOPPAGE_AMOUNT) STOPPAGE_AMOUNT,
		BANK_ORDER_ID,
		CARI_ACTION_ID,
		CONSUMER_ID 
	FROM 
		INVOICE_MULTILEVEL_PAYMENT_ROWS 
	WHERE 
		INV_PAYMENT_ID = #attributes.inv_payment_id# 
	GROUP BY 
		BANK_ORDER_ID,
		CARI_ACTION_ID,
		CONSUMER_ID 
</cfquery>
<cfif get_rows.recordcount>
	<cfset consumer_id_list = valuelist(get_rows.consumer_id)>
	<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",',')>	
	<cfquery name="get_cons_name" datasource="#dsn#">
        SELECT   
        	CH.CONSUMER_ID,
            CH.MEMBER_CODE,
            CH.CONSUMER_NAME,
            CH.CONSUMER_SURNAME,
            CC.CONSCAT,
            ISNULL(CH.IS_TAXPAYER, 0) AS IS_TAXPAYER
        FROM     
        	CONSUMER_HISTORY CH, 
       		CONSUMER_CAT CC
        WHERE    
        	CH.CONSUMER_CAT_ID = CC.CONSCAT_ID AND 
        	CH.CONSUMER_ID IN (#consumer_id_list#) AND
        	CH.CAMP_ID = #get_payment.camp_id#
        ORDER BY 
        	CH.CONSUMER_ID
	</cfquery>
    <cfif not get_cons_name.recordcount>
    	<cfquery name="get_cons_name" datasource="#dsn#">
            SELECT   
                CH.CONSUMER_ID,
                CH.MEMBER_CODE,
                CH.CONSUMER_NAME,
                CH.CONSUMER_SURNAME,
                CC.CONSCAT,
                ISNULL(CH.IS_TAXPAYER, 0) AS IS_TAXPAYER
            FROM     
                CONSUMER CH, 
                CONSUMER_CAT CC
            WHERE    
                CH.CONSUMER_CAT_ID = CC.CONSCAT_ID AND 
                CH.CONSUMER_ID IN (#consumer_id_list#)
            ORDER BY 
                CH.CONSUMER_ID
        </cfquery>
    </cfif>	
	<cfset main_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_cons_name.CONSUMER_ID,',')),'numeric','ASC',',')>
</cfif>
<cfform name="upd_premium_payment" method="post" action="#request.self#?fuseaction=ch.form_upd_premium_payment">
	<cf_basket_form id="add_law">
    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
    <input type="hidden" name="dekont_process_id" id="dekont_process_id" value="<cfif isdefined("dekont_process_id")><cfoutput>#dekont_process_id#</cfoutput></cfif>">
    <input type="hidden" name="bank_order_process_id" id="bank_order_process_id" value="<cfif isdefined("bank_order_process_id")><cfoutput>#bank_order_process_id#</cfoutput></cfif>">
		<div class="row">
			<div class="col col-12 uniqueRow">
				<div class="row formContent">
					<div class="row" type="row">
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        	<div class="form-group">
                            	<label class="col col-4 col-xs-12 bold"><cf_get_lang_main no='34.Kampanya'></label>
                                <div class="col col-8 col-xs-12">
                                	<cfoutput>#get_payment.camp_head#</cfoutput>
                                </div>
                            </div>
                            <div class="form-group">
                            	<label class="col col-4 col-xs-12 bold"><cf_get_lang no='63.Stopaj Oranı'></label>
                                <div class="col col-8 col-xs-12">
                                	<cfif isdefined("get_rate.stoppage_rate")><cfoutput>#get_rate.stoppage_rate#</cfoutput><cfelse>0</cfif>
                                </div>
                            </div>
                            <div class="form-group">
                            	<label class="col col-4 col-xs-12 bold"><cf_get_lang no='205.Prim Tipi'></label>
                                <div class="col col-8 col-xs-12">
                                	<cfif get_payment.premium_type eq 1><cfoutput>#getLang('ch',207)#</cfoutput>
									<cfelseif get_payment.premium_type eq 2>#getLang('ch',208)#
                                    <cfelseif get_payment.premium_type eq 3>#getLang('ch',209)#
                                    <cfelseif get_payment.premium_type eq 4>#getLang('ch',210)#
                                    <cfelseif get_payment.premium_type eq 5>#getLang('ch',211)#
                                    <cfelseif get_payment.premium_type eq 6>#getLang('ch',212)#
                                    <cfelseif get_payment.premium_type eq 7>#getLang('ch',213)#Diger Nakit Ödül Programı Primi
                                    <cfelseif get_payment.premium_type eq 8>#getLang('main',744)# #getLang('ch',209)#</cfif>
                                </div>
                            </div>
                        </div>
					</div>
				</div>
			</div>
		</div>
	</cf_basket_form>
	<cf_basket id="add_law_row">
		<table class="detail_basket_list">
			<thead>
				<tr>
					<th width="20"><cf_get_lang_main no='75.No'></th>
					<th width="65"><cf_get_lang_main no='496.Temsilci'> <cf_get_lang_main no='75.No'></th>
					<th><cf_get_lang_main no ='174.Bireysel Üye'></th>
					<th><cf_get_lang_main no ='1197.Üye Kategorisi'></th>
					<th style="text-align:right;"><cf_get_lang_main no ='299.Stopaj'></th>
					<th style="text-align:right;"><cf_get_lang no='62.Net Ödenen'></th>
					<th width="50"></td>
				</tr>
			</thead>
			<cfscript>
				total_1 = 0;
				total_2 = 0;
			</cfscript>
			<tbody>
			<cfoutput query="get_rows">
				<tr>
					<td>#currentrow#</td>
					<td>#get_cons_name.MEMBER_CODE[listfind(main_consumer_id_list,consumer_id,',')]#</td>
					<td><a href="javascript:// " onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#consumer_id#','medium');" class="tableyazi">#get_cons_name.CONSUMER_NAME[listfind(main_consumer_id_list,consumer_id,',')]#&nbsp;#get_cons_name.CONSUMER_SURNAME[listfind(main_consumer_id_list,consumer_id,',')]#</a></td>
					<td>#get_cons_name.CONSCAT[listfind(main_consumer_id_list,consumer_id,',')]#</td>
					<td style="text-align:right;">#tlformat(STOPPAGE_AMOUNT)# #session.ep.money#</td>
					<td style="text-align:right;">#tlformat(PAY_AMOUNT)# #session.ep.money#</td>
					<td width="50" align="center">
						<cfif len(bank_order_id)>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.popup_upd_assign_order&bank_order_id=#bank_order_id#','list');"><img src="/images/update_list.gif" alt="<cf_get_lang no='61.Talimat Güncelle'>" title="<cf_get_lang no='61.Talimat Güncelle'>" border="0"></a>	
						</cfif>
						<cfif len(cari_action_id)>
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ch.popup_form_upd_debit_claim_note&id=#cari_action_id#','list');"><img src="/images/update_list.gif" alt="<cf_get_lang no='59.Dekont Güncelle'>" title="<cf_get_lang no='59.Dekont Güncelle'>" border="0"></a>	
						</cfif>
					</td>
				</tr>
				<cfscript>
					total_1 = total_1 + STOPPAGE_AMOUNT;
					total_2 = total_2 + PAY_AMOUNT;
				</cfscript>
			</cfoutput>
			<cfoutput>
				<tr>
					<td colspan="4" class="txtbold" style="text-align:right;"><cf_get_lang_main no ='80.Toplam'></td>
					<td nowrap class="txtbold" style="text-align:right;">#tlformat(total_1)# #session.ep.money#</td>
					<td nowrap class="txtbold" style="text-align:right;">#tlformat(total_2)# #session.ep.money#</td>
					<td></td>
				</tr>
			</cfoutput>
			<tbody>
		</table>
		<cf_basket_footer height="165">
			<table>
				<tr>
					<td width="350" valign="top" class="sepetim_total_table_tutar_td">
						<table>
							<tr>
								<td width="100"><cf_get_lang_main no='388.İşlem Tipi'> *</td>
								<td><cf_workcube_process_cat slct_width="220" process_cat=#get_payment.process_cat_id#></td>
							</tr>
							<tr>
								<td><cf_get_lang_main no='1652.Banka Hesabı'> *</td>
								<td>
									<cf_wrkBankAccounts width='220' selected_value='#get_payment.account_id#' is_upd='1' is_system_money='1'>
								</td>
							</tr>
							<cfquery name="GET_EXPENSE_A" datasource="#dsn2#">
								SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #get_payment.EXPENSE_CENTER_ID#
							</cfquery>
							<cfquery name="GET_EXPENSE_ITEM_A" datasource="#dsn2#">
								SELECT EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = #get_payment.EXPENSE_ITEM_ID#
							</cfquery>
							<tr>
								<td><cf_get_lang_main no='1048.Masraf Merkezi'> *</td>
								<td>
									<input name="expense_center_id_2" id="expense_center_id_2" type="hidden" value="<cfoutput>#get_payment.EXPENSE_CENTER_ID#</cfoutput>">
									<cfinput name="expense_center_2" type="text" value="#GET_EXPENSE_A.EXPENSE#" style="width:220px;" readonly>
									<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&field_name=add_premium_payment.expense_center_2&field_id=add_premium_payment.expense_center_id_2&is_invoice=1</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" alt="<cf_get_lang_main no='1048.Masraf Merkezi'>" align="absmiddle"></a>
								</td>
							</tr>
							<tr>
								<td><cf_get_lang_main no='1139.Gider Kalemi'> *</td>
								<td>
									<input type="hidden" name="expense_item_id_2" id="expense_item_id_2" value="<cfoutput>#get_payment.EXPENSE_ITEM_ID#</cfoutput>">
									<cfinput type="text" name="expense_item_name_2" value="#GET_EXPENSE_ITEM_A.EXPENSE_ITEM_NAME#" style="width:220px;" readonly>
									<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=add_premium_payment.expense_item_id_2&field_name=add_premium_payment.expense_item_name_2','list');"><img src="/images/plus_thin.gif" border="0" alt="<cf_get_lang_main no='1139.Gider Kalemi'> " align="absmiddle"></a>
								</td>
							</tr>
							<tr>
								<td><cf_get_lang_main no='1439.Ödeme Tarihi'> *</td>
								<td>
									<cfsavecontent variable="message"><cf_get_lang no='174.Ödeme Tarihi Giriniz'></cfsavecontent>
									<cfinput type="text" name="payment_date" validate="#validate_style#" required="yes" message="#message#" value="#dateformat(get_payment.payment_date,dateformat_style)#" maxlength="10" style="width:65px;">
									<cf_wrk_date_image date_field="payment_date">
								</td>
							</tr>
							<tr>
								<td></td>
								<td>
									<cfquery name="get_bank_actions" datasource="#dsn2#">
										SELECT DISTINCT BANK_ORDER_ID FROM INVOICE_MULTILEVEL_PAYMENT_ROWS WHERE BANK_ORDER_ID IS NOT NULL AND INV_PAYMENT_ID = #url.inv_payment_id#
									</cfquery>
									<cfif get_bank_actions.recordcount>
										<cfquery name="CONTROL_BANK_ORDER" datasource="#dsn2#">
											SELECT
												BANK_ORDER_ID
											FROM
												BANK_ORDERS
											WHERE
												BANK_ORDER_ID IN(#valuelist(get_bank_actions.bank_order_id)#)
												AND BANK_ORDER_TYPE = 250
												AND ISNULL(IS_PAID,0) = 1
										</cfquery>								
									</cfif>
									<cfif get_bank_actions.recordcount and control_bank_order.recordcount>
										<font color="red"><cf_get_lang no='56.Havale Edilen Banka Talimatları Olduğu İçin İşlemi Silemezsiniz'>!</font>
									<cfelse>
										<cf_workcube_buttons 
											is_upd='1' 
											is_insert='0' 
											delete_page_url = '#request.self#?fuseaction=ch.emptypopup_del_premium_payment&payment_id=#attributes.inv_payment_id#&process_type=#get_payment.process_type#'>	
									</cfif>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</cf_basket_footer>
	</cf_basket>
</cfform>
