<cf_xml_page_edit fuseact="invent.add_invent_sale">
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT 
    	MONEY_ID,
        MONEY, 
        RATE1, 
        RATE2, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID,
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	SETUP_MONEY 
    WHERE
	    PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1 
    ORDER BY 
    	MONEY_ID
</cfquery>
<cfquery name="KASA" datasource="#dsn2#">
	SELECT 
    	CASH_ID, 
        CASH_NAME, 
        CASH_ACC_CODE, 
        BRANCH_ID, 
        CASH_CURRENCY_ID,
        DEPARTMENT_ID, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE	 
    FROM 
    	CASH 
    WHERE 
	    CASH_ACC_CODE IS NOT NULL 
    ORDER BY 
    	CASH_NAME
</cfquery>
<cfquery name="GET_TAX" datasource="#dsn2#">
	SELECT 
        TAX, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_TAX 
    ORDER BY 
    	TAX
</cfquery>
<cfquery name="GET_OTV" datasource="#DSN3#">
	SELECT TAX FROM SETUP_OTV WHERE PERIOD_ID = #session.ep.period_id# ORDER BY TAX
</cfquery>
<cfquery name="get_expense_center" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE,EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_SALE_DET" datasource="#dsn2#">
	SELECT 
		ACC_DEPARTMENT_ID
	FROM
		INVOICE
	WHERE
		INVOICE_CAT <> 67 AND
		INVOICE_CAT <> 69
</cfquery>
<cfquery name="get_einvoice_type" datasource="#DSN#" maxrows="1"><!---MCP tarafından #75351 numaralı iş için E-Fatura Kullanıp Kullanmadığı Kontrolü İçin kullanılacak. --->
     SELECT * FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
</cfquery>
<cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#reason_codes.xml" variable="xmldosyam" charset = "UTF-8">
<cfset dosyam = XmlParse(xmldosyam)>
<cfset xml_dizi = dosyam.REASON_CODES.XmlChildren>
<cfset d_boyut = ArrayLen(xml_dizi)>
<cfset reason_code_list = "">
<cfloop index="abc" from="1" to="#d_boyut#">    	
    <cfset reason_code_list = listappend(reason_code_list,'#dosyam.REASON_CODES.REASONS[abc].REASONS_CODE.XmlText#--#dosyam.REASON_CODES.REASONS[abc].REASONS_NAME.XmlText#','*')>
</cfloop>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_invent" method="post" action="#request.self#?fuseaction=invent.emptypopup_add_invent_sale">
			<input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>"> 
			<input type="hidden" name="xml_total_budget" id="xml_total_budget" value="<cfoutput>#xml_total_budget#</cfoutput>"> 
			<cf_box_elements id="invent_sale">  
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
						<div class="col col-8 col-xs-12"><cf_workcube_process_cat slct_width="140"></div>
					</div>
					<div class="form-group" id="item-comp_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="">
								<input type="hidden" name="consumer_id" id="consumer_id" value="">
								<input type="hidden" name="emp_id" id="emp_id" value=""> 
								<input type="hidden" name="member_code" id="member_code" value="">
								<input type="text" name="comp_name" id="comp_name" value="" readonly="readonly">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_member_account_code=add_invent.member_code&is_cari_action=1&select_list=1,2,3&field_name=add_invent.partner_name&field_partner=add_invent.partner_id&field_comp_name=add_invent.comp_name&field_comp_id=add_invent.company_id&field_consumer=add_invent.consumer_id&field_emp_id=add_invent.emp_id&field_revmethod_id=add_invent.paymethod_id&field_revmethod=add_invent.paymethod&field_basket_due_value_rev=add_invent.basket_due_value&field_adress_id=add_invent.ship_address_id&field_long_address=add_invent.adres&call_function=change_paper_duedate()</cfoutput>','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-partner_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="partner_id" id="partner_id" value="">
							<input type="text" name="partner_name" id="partner_name" value="" readonly>
						</div>
					</div>
					<div class="form-group" id="item-employee">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56987.Satış Yapan'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="">
								<input type="text" name="employee" id="employee" style="width:140px;" onchange="clear_();" value="">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='56987.Satış Yapan'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_invent.employee_id&field_name=add_invent.employee&select_list=1','list');"></span>
							</div>
						</div>
					</div>
					<cfif session.ep.our_company_info.IS_EFATURA eq 1 >
						<div class="form-group" id="item-ship_address">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="34252.Sevk Adresi"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="ship_address_id" id="ship_address_id" value="">
									<cfinput type="text" name="adres" value="" maxlength="200" style="width:140px;">
									<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='34252.Sevk Adresi'>" onclick="add_adress();"></span>
								</div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-invoice_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="invoice_date" validate="#validate_style#" value="#dateformat(now(),dateformat_style)#" maxlength="10" onblur="change_money_info('add_invent','invoice_date');">
								<span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='58759.Fatura Tarihi'>" ><cf_wrk_date_image date_field="invoice_date" call_function="change_paper_duedate&change_money_info"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-serial_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isDefined('paper_full')>
									<cfinput type="text" maxlength="5" name="serial_number" value="#paper_code#">
									<span class="input-group-addon no-bg"> - </span> 
									<cfinput type="text" maxlength="50" name="serial_no" value="#paper_number#" onBlur="paper_control(this,'INVOICE',true,'','','','','','',1,add_invent.serial_number);">
								<cfelse>
									<cfinput type="text" maxlength="5" name="serial_number" value="">
									<span class="input-group-addon no-bg"> - </span>                                            
									<cfinput type="text" maxlength="50" name="serial_no" value="" onBlur="paper_control(this,'INVOICE',true,'','','','','','',1,add_invent.serial_number);">
								</cfif>  
							</div>
						</div>
					</div>
					<div class="form-group" id="item-ship_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58138.İrsaliye No'> *</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="ship_number" value="" maxlength="50" style="width:80px;">
						</div>
					</div>
					<cfif xml_is_department neq 0>
						<div class="form-group" id="item-acc_department">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'><cfif xml_is_department eq 2> *</cfif></label>
							<div class="col col-8 col-xs-12">
								<cf_wrkDepartmentBranch fieldId='acc_department_id' is_department='1' width='135' selected_value='#get_sale_det.ACC_DEPARTMENT_ID#'>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-department_location">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'> *</label>
						<div class="col col-8 col-xs-12">
							<cf_wrkdepartmentlocation
								returnInputValue="location_id,department_name,department_id,branch_id"
								returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
								fieldName="department_name"
								fieldid="location_id"
								department_fldId="department_id"
								branch_fldId="branch_id"
								user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
								width="120">
						</div>
					</div>
					<div class="form-group" id="item-paymethod">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58516.Ödeme Yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
								<input type="hidden" name="commission_rate" id="commission_rate" value="">
								<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
								<input type="text" name="paymethod" id="paymethod" style="width:120px;"  value="">
								<cfset card_link="&field_card_payment_id=add_invent.card_paymethod_id&field_card_payment_name=add_invent.paymethod&field_commission_rate=add_invent.commission_rate">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_invent.paymethod_id&field_dueday=add_invent.basket_due_value&function_name=change_paper_duedate&field_name=add_invent.paymethod#card_link#</cfoutput>','list');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-basket_due_value">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input name="basket_due_value" id="basket_due_value" type="text" value="" onChange="change_paper_duedate('invoice_date');" style="width:45px;">
								<span class="input-group-addon no-bg"></span>
								<cfinput type="text" name="basket_due_value_date_" value="" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" maxlength="10" style="width:72px;" readonly>
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
							</div>
						</div>
					</div>
					<cfif session.ep.our_company_info.project_followup eq 1>
						<div class="form-group" id="item-project">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cf_wrk_projects form_name='add_invent' project_id='project_id' project_name='project_head'>
									<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.pj_id')><cfoutput>#attributes.pj_id#</cfoutput></cfif>">
									<input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.pj_id') and  len(attributes.pj_id)><cfoutput>#GET_PROJECT_NAME(attributes.pj_id)#</cfoutput></cfif>" style="width:120px;" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=add_invent.project_id&project_head=add_invent.project_head');"></span>
								</div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-detail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="detail" id="detail" style="width:140;height:50px;"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-cash">
						<label class="col col-4 col-xs-12">
							<div id="kasa_sec_text">
								<cfif kasa.recordcount>
									<cf_get_lang dictionary_id='56929.Nakit Satış'>
									<input type="checkbox" name="cash" id="cash" onClick="ayarla_gizle_goster();">
								</cfif>
							</div>
						</label>
						<div class="col col-8 col-xs-12" style="display:none;" id="kasa_sec">
							<cfif kasa.recordcount>
								<select name="kasa" id="kasa" style="width:140px;">
								<cfoutput query="kasa">
								<option value="#cash_id#;#cash_currency_id#">#cash_name# </option>
								</cfoutput>
								</select>
							</cfif>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
			
			<cf_basket id="invent_sale_bask">
				<cf_grid_list name="table1" id="table1" class="detail_basket_list">
					<thead>
						<cfif xml_multi_change eq 1> 
							<tr>
								<th colspan="14"></th>
								<th nowrap="nowrap">
									<input type="hidden" name="account_id_all" id="account_id_all" />
									<input type="text" name="account_code_all" id="account_code_all"/>
									<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.account_id_all&field_name=add_invent.account_code_all&function_name=change_acc_all()','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
								</th>
								<th colspan="2"></th>
							<th nowrap="nowrap">	<!--- masraf merkezi --->	
									<input type="hidden" name="expense_center_id_all" id="expense_center_id_all" value="">
									<input type="text" name="main_exp_center_name_all" id="main_exp_center_name_all" style="width:130px;" value="" onFocus="AutoComplete_Create('main_exp_center_name_all','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','','EXPENSE_ID','expense_center_id_all','','3','200',true,'change_expense_center()');"  autocomplete="off">
									<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=add_invent.expense_center_id_all&field_name=add_invent.main_exp_center_name_all&call_function=change_expense_center()','list','popup_expense_center');"><img src="/images/plus_thin.gif" align="absbottom" border="0"></a>
								</th>
								<th nowrap="nowrap">
									<input type="hidden" name="budget_item_id_all" id="budget_item_id_all" />
									<input type="text" name="budget_item_name_all" id="budget_item_name_all"/>
									<a href="javascript://"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=add_invent.budget_item_id_all&field_name=add_invent.budget_item_name_all&field_account_no=add_invent.budget_account_code_all&field_account_no2=add_invent.budget_account_id_all&function_name=change_exp_all()','list');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
								</th>
								<th nowrap="nowrap">
									<input type="hidden" name="budget_account_id_all" id="budget_account_id_all" />
									<input type="text" name="budget_account_code_all" id="budget_account_code_all" style="width:100px;" />
									<img src="/images/plus_thin.gif" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.budget_account_id_all&field_name=add_invent.budget_account_code_all&function_name=change_budget_acc_all()','list');" align="absmiddle" border="0"></a>
								</th>
								<th nowrap="nowrap">
									<input type="hidden" name="amort_account_id_all" id="amort_account_id_all" value="">
									<input type="text" name="amort_account_code_all" id="amort_account_code_all" value="" style="width:200px;">
									<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=add_invent.amort_account_id_all&field_name=add_invent.amort_account_code_all&function_name=change_amort_all()','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
								</th>
								<th colspan="3"></th>
							</tr>
						</cfif>  
						<tr>
							<th><input name="record_num" id="record_num" type="hidden" value="0">
								<a onClick="f_add_invent();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
							</th>
							
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58878.Demirbaş No'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57629.Açıklama'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57635.Miktar'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57638.Birim Fiyat'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id="59342.Dövizli Birim Fiyat">&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57639.KDV'> % &nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58021.OTV'> % &nbsp;</th>
							<th nowrap="nowrap" style="text-align:right;">&nbsp;<cf_get_lang dictionary_id='57639.KDV'></th>
							<th nowrap="nowrap" style="text-align:right;">&nbsp;<cf_get_lang dictionary_id='58021.OTV'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='58084.Fiyat'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58083.Net'><cf_get_lang dictionary_id='56994.Döviz Fiyat'>&nbsp;</th>
							<th nowrap="nowrap" ><cf_get_lang dictionary_id='57677.Döviz'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58456.Oran'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56909.Son Değer'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56966.Gelir/Gider'><cf_get_lang dictionary_id='56964.Farkı'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='39939.İstisna'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58460.Masraf Merkezi'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56966.Gelir/Gider'><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56963.Amortisman'><cf_get_lang dictionary_id='56962.Karşılık'><cf_get_lang dictionary_id='58811.Muhasebe Kodu'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57452.Stok'>&nbsp;</th>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='56990.Stok Birimi'>&nbsp;</th>
						</tr>
					</thead>
				</cf_grid_list>

				<cf_basket_footer height="95">
					<div class="ui-row">
						<div id="sepetim_total">
							<div class="col col-2 col-md-3 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57677.Döviz'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody">
											<table cellspacing="0" id="money_rate_table">
												<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
												<cfquery name="get_standart_process_money" datasource="#dsn#"><!--- muhasebe doneminden standart islem dövizini alıyor --->
													SELECT 
														PERIOD_ID, 
														OUR_COMPANY_ID, 
														OTHER_MONEY, 
														STANDART_PROCESS_MONEY, 
														RECORD_DATE, 
														RECORD_IP, 
														RECORD_EMP, 
														UPDATE_DATE, 
														UPDATE_IP,
														UPDATE_EMP
													FROM 
														SETUP_PERIOD 
													WHERE 
														PERIOD_ID = #session.ep.period_id#
												</cfquery>
												<cfoutput>
												<cfif IsQuery(get_standart_process_money) and len(get_standart_process_money.STANDART_PROCESS_MONEY)>
													<cfset selected_money=get_standart_process_money.STANDART_PROCESS_MONEY>
												<cfelseif len(session.ep.money2)>
													<cfset selected_money=session.ep.money2>
												<cfelse>
													<cfset selected_money=session.ep.money>
												</cfif>
												<cfloop query="get_money">
													<tr>
														<td>
															<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
															<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
															<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" onClick="toplam_hesapla();" <cfif selected_money eq money>checked</cfif>>#money#
														</td>
														<cfif session.ep.rate_valid eq 1>
															<cfset readonly_info = "yes">
														<cfelse>
															<cfset readonly_info = "no">
														</cfif>
														<td>
															#TLFormat(rate1,0)#/<input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,session.ep.our_company_info.rate_round_num)#" <cfif money eq session.ep.money>readonly="yes"</cfif> style="width:50px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="toplam_hesapla();">
														</td>
													</tr>
												</cfloop>
												</cfoutput>
											</table>                    
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-5 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"> <cf_get_lang dictionary_id='57492.Toplam'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody"> 
										<table>
											<tr>
												<td height="20" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
												<td width="100" style="text-align:right;">
													<input type="text" name="total_amount" id="total_amount" class="box" readonly="" value="0">
												</td>
												<td><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id ='57643.KDV Toplam'></td>
												<td style="text-align:right;"><input type="text" name="kdv_total_amount" id="kdv_total_amount" class="box" value="0"  readonly></td>
												<td><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id ='58021.OTV'><cf_get_lang dictionary_id='57492.Toplam'></td>
												<td style="text-align:right;"><input type="text" name="otv_total_amount" id="otv_total_amount" class="box" value="0"  readonly></td><td><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;">
													<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stoppage_rates&field_stoppage_rate=add_invent.stopaj_yuzde&field_stoppage_rate_id=add_invent.stopaj_rate_id&field_decimal=#session.ep.our_company_info.purchase_price_round_num#&call_function=toplam_hesapla()</cfoutput>','list')"><img src="/images/plus_small.gif" title="Stopaj Oranları"></a>
													<cf_get_lang dictionary_id='57711.Stopaj'>%</td>
														<input type="hidden" name="stopaj_rate_id" id="stopaj_rate_id" value="0">
												<td><input type="text" name="stopaj_yuzde" id="stopaj_yuzde" class="box" onBlur="calc_stopaj();" onkeyup="return(FormatCurrency(this,event,0));" value="0" autocomplete="off"></td>
											</tr>
											<tr class="txtbold" style="text-align:right;">	
												<td><input type="text" class="box" name="stopaj" id="stopaj" value="0" onBlur="toplam_hesapla(1);" readonly="readonly"></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id ='57678.Fatura Altı İndirim'></td>
												<td style="text-align:right;"><input type="text" name="net_total_discount" id="net_total_discount" class="box" value="0" onBlur="toplam_hesapla();" onkeyup="return(FormatCurrency(this,event));"></td><td><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='56975.KDV li Toplam'></td>
												<td style="text-align:right;"><input type="text" name="net_total_amount" id="net_total_amount" class="box" readonly="" value="0"></td><td><cfoutput>#session.ep.money#</cfoutput></td>
											</tr>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='58124.Döviz Toplam'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="totalBoxBody" id="totalAmountList">  
										<table>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='58124.Döviz Toplam'></td>
												<td id="rate_value1" style="text-align:right;">
													<input type="text" name="other_total_amount" id="other_total_amount" class="box" readonly="" value="0">
												</td><td>
													<input type="text" name="tl_value1" id="tl_value1" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>" style="width:40px;">
												</td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='56961.Döviz KDV Toplam'></td>
												<td style="text-align:right;"><input type="text" name="other_kdv_total_amount" id="other_kdv_total_amount" class="box" readonly value="0">
												</td><td>
													<input type="text" name="tl_value2" id="tl_value2" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>" style="width:40px;"></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id="34065.Dövizli ÖTV Toplam"></td>
												<td style="text-align:right;"><input type="text" name="other_otv_total_amount" id="other_otv_total_amount" class="box" readonly value="0"></td><td><input type="text" name="tl_value5" id="tl_value5" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>" style="width:40px;"></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id ='57678.Fatura Altı İndirim'><cf_get_lang dictionary_id ='57677.Döviz'></td>
												<td style="text-align:right;"><input type="text" name="other_net_total_discount" id="other_net_total_discount" class="box" readonly value="0"></td><td>
												<input type="text" name="tl_value4" id="tl_value4" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>" style="width:40px;"></td>
											</tr>
											<tr>
												<td class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='56993.Döviz KDV li Toplam'></td>
												<td id="rate_value3" style="text-align:right;"><input type="text" name="other_net_total_amount" id="other_net_total_amount" class="box" readonly="" value="0"></td><td>
												<input type="text" name="tl_value3" id="tl_value3" class="box" readonly="" value="<cfoutput>#selected_money#</cfoutput>" style="width:40px;"></td>
											</tr>
										</table>
									</div>
								</div>
							</div>
							<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
								<div class="totalBox">
									<table>
										<tr>
											<td colspan="2" width="190">
												<input type="checkbox" id="tevkifat_box" name="tevkifat_box" onClick="goster(tevkifat_oran);gizle_goster(tevkifat_plus);gizle_goster(tevk_1);gizle_goster(tevk_2);gizle_goster(beyan_1);gizle_goster(beyan_2);toplam_hesapla();">
												<b><cf_get_lang dictionary_id='58022.Tevkfat'></b>
												<input type="hidden" id="tevkifat_id" name="tevkifat_id" value="">
												<input type="text" id="tevkifat_oran" name="tevkifat_oran" value="" readonly style="display:none;width:35px;" onBlur="toplam_hesapla();">
												<a style="display:none;cursor:pointer" id="tevkifat_plus" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_tevkifat_rates&field_tevkifat_rate=add_invent.tevkifat_oran&field_tevkifat_rate_id=add_invent.tevkifat_id&call_function=toplam_hesapla()</cfoutput>','small')"> <img src="images/plus_thin.gif" alt="<cf_get_lang dictionary_id='58022.Tevkfat'>" border="0" align="absmiddle"></a>
											</td>
										</tr>
										<tr>
											<td id="tevk_1" style="display:none"><b><cf_get_lang dictionary_id ='58022.Tevkifat'>:</b></td>
											<td id="tevk_2" style="display:none" nowrap="nowrap"><div id="tevkifat_text"></div></td>
										</tr>
										<tr>
											<td id="beyan_1" style="display:none"><b><cf_get_lang dictionary_id ='58024.Beyan Edilen'>:</b></td>
											<td id="beyan_2" style="display:none" nowrap="nowrap"><div id="beyan_text"></div></td>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</cf_basket_footer>
			</cf_basket>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	record_exist=0;
	function add_adress()
	{
		if(!(document.getElementById('company_id').value=="") || !(document.getElementById('consumer_id').value=="") || !(document.getElementById('employee_id').value==""))
		{
			if(document.getElementById('company_id').value!="")
			{
				str_adrlink = '&field_long_adres=add_invent.adres&field_adress_id=add_invent.ship_address_id&is_compname_readonly=1';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(add_invent.comp_name.value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				str_adrlink = '&field_long_adres=add_invent.adres&field_adress_id=add_invent.ship_address_id&is_compname_readonly=1';
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(add_invent.partner_name.value)+''+ str_adrlink , 'list');
				return true;
			}
		}
		else
		{
			alert("<cf_get_lang dictionary_id='56901.Cari Hesap Seçmelisiniz'>");
			return false;
		}
	}
	function kontrol()
	{
		if(!paper_control(add_invent.serial_no,'INVOICE',true,'','','','','','',1,add_invent.serial_number)) return false;
		if(!chk_period(add_invent.invoice_date,"İşlem")) return false;
		if (!chk_process_cat('add_invent')) return false;
		if(!check_display_files('add_invent')) return false;
		if(!$("#department_name").val().length)
		{
			alertObject({message: "<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58763.Depo'>"})
			return false;
		}
		if(!$("#ship_number").val().length)
		{
			alertObject({message: "<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='58138.İrsaliye No'>"})
			return false;
		}
		<cfif xml_is_department eq 2>
			if(!$("#acc_department_id").options[$("#acc_department_id").selectedIndex].val().length)
			{
				alertObject({message: "<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57572.Departman'>"})
				return false;
			}
		</cfif>
		if(!$("#comp_name").val().length && !$("#consumer_id").val().length && !$("#emp_id").val().length)
		{ 
			alertObject({message: "<cf_get_lang dictionary_id='56901.Cari Hesap Seçmelisiniz'> !"})
			return false;
		}
		   <cfif session.ep.our_company_info.IS_EFATURA eq 1 ><!--- MCP tarafından #75351 numaralı iş için eklendi.e-Fatura kullanıyorsa gösterilecek --->
		 	var get_efatura_info = wrk_query("SELECT USE_EFATURA FROM COMPANY WHERE COMPANY_ID = "+document.getElementById('company_id').value,"dsn");	
				if(get_efatura_info.USE_EFATURA == 1)															   
				{
					if(document.getElementById('ship_address_id').value =='' || document.getElementById('adres').value =='')
					{
						alertObject({message: "<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='34252.Sevk Adresi'>"})
						return false;
					}
				}
		</cfif>
		process=document.all.process_cat.value;
		var get_process_cat = wrk_safe_query('acc_process_cat','dsn3',0,process);
		if(get_process_cat.IS_ACCOUNT ==1)
		{
			if ($("#comp_name").val().length && !$("#member_code").val().length )
			{ 
				alertObject({message: "<cf_get_lang dictionary_id='56912.Seçtiğiniz Üyenin Muhasebe Kodu Seçilmemiş'> !"})
				return false;
			}
		}	
		change_paper_duedate('invoice_date');
		for(r=1;r<=document.all.record_num.value;r++)
		{
			if(eval("document.all.row_kontrol"+r).value == 1)
			{
			record_exist=1;
				if (eval("document.all.invent_no"+r).value == "")
				{ 
					alertObject({message: "<cf_get_lang dictionary_id='56981.Lütfen Demirbaş No Giriniz'> !"})
					return false;
				}
				if (eval("document.all.invent_name"+r).value == "")
				{ 
					alertObject({message: "<cf_get_lang dictionary_id='56660.Lütfen Açıklama Giriniz'> !"})
					return false;
				}
				if ((eval("document.all.row_total_"+r).value == ""))
				{ 
					alertObject({message: "<cf_get_lang dictionary_id='29535.Lütfen Tutar Giriniz '> !"})
					return false;
				}
				if ((eval("document.all.amortization_rate"+r).value == "")||(eval("document.all.amortization_rate"+r).value ==0))
				{ 
					alertObject({message: "<cf_get_lang dictionary_id='56988.Amortisman Oranı Giriniz'> !"})
					return false;
				}
				if (eval("document.all.account_code"+r).value == "")
				{ 
					alertObject({message: "<cf_get_lang dictionary_id='56989.Muhasebe Kodu Girmelisiniz'> !"})
					return false;
				}
				if (eval("document.all.last_diff_value"+r).value != 0 && filterNum(eval("document.all.last_diff_value"+r).value) > 0 && eval("document.all.budget_account_code"+r).value == "")
				{ 
					alertObject({message: "<cf_get_lang dictionary_id='56958.Lütfen Gelir/Gider Farkı İçin Muhasebe Kodu Seçiniz'> !"})
					return false;
				}
				if (eval("document.all.last_diff_value"+r).value != 0 && filterNum(eval("document.all.last_diff_value"+r).value) > 0 && eval("document.all.amort_account_code"+r).value == "")
				{ 
					alertObject({message: "<cf_get_lang dictionary_id='56957.Lütfen Amortisman Karşılık Muhasebe Kodu Seçiniz'> !"})
					return false;
				}
			}
		}
		if (record_exist == 0) 
			{
				alertObject({message: "<cf_get_lang dictionary_id='56983.Lütfen Demirbaş Giriniz'> !"})
				return false;
			}
		return(unformat_fields());
	}
	function unformat_fields()
	{
		for(r=1;r<=document.all.record_num.value;r++)
		{
			deger_total = eval("document.all.row_total_"+r);
			deger_total2 = eval("document.all.row_total2_"+r);
			deger_kdv_total= eval("document.all.kdv_total"+r);
			deger_otv_total= document.getElementById("otv_total"+r);
			deger_net_total = eval("document.all.net_total"+r);
			deger_other_net_total = eval("document.all.row_other_total"+r);
			deger_amortization_rate = eval("document.all.amortization_rate"+r);
			deger_unit_last= eval("document.all.unit_last_value"+r);
			total_deger_unit_last= eval("document.all.last_inventory_value"+r);
			deger_last_value= eval("document.all.last_diff_value"+r);
			deger_unit_first= eval("document.all.unit_first_value"+r);
			total_deger_unit_first= eval("document.all.total_first_value"+r);
			
			deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_amortization_rate.value = filterNum(deger_amortization_rate.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_unit_last.value = filterNum(deger_unit_last.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_last_value.value = filterNum(deger_last_value.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			total_deger_unit_last.value = filterNum(total_deger_unit_last.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_unit_first.value = filterNum(deger_unit_first.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			total_deger_unit_first.value = filterNum(total_deger_unit_first.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		}
		document.getElementById("total_amount").value = filterNum(document.getElementById("total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.kdv_total_amount.value = filterNum(document.all.kdv_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("otv_total_amount").value = filterNum(document.getElementById("otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.all.net_total_amount.value = filterNum(document.all.net_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.other_total_amount.value = filterNum(document.all.other_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.other_kdv_total_amount.value = filterNum(document.all.other_kdv_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("other_otv_total_amount").value = filterNum(document.getElementById("other_otv_total_amount").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.all.other_net_total_amount.value = filterNum(document.all.other_net_total_amount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.net_total_discount.value = filterNum(document.all.net_total_discount.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.tevkifat_oran.value = filterNum(document.all.tevkifat_oran.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj_yuzde").value = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("stopaj").value = filterNum(document.getElementById("stopaj").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=document.all.kur_say.value;s++)
		{
			eval('document.all.txt_rate2_' + s).value = filterNum(eval('document.all.txt_rate2_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			eval('document.all.txt_rate1_' + s).value = filterNum(eval('document.all.txt_rate1_' + s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
	}
	row_count=0;
	satir_say=0;
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=document.getElementById("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
		satir_say--;
	}
	function clear_()
	{
		if(document.getElementById('employee').value=='')
		{
			document.getElementById('employee_id').value='';
		}
	}
	function hesapla(satir,hesap_type)
	{
		var toplam_dongu_0 = 0;//satir toplam
		if(eval("document.all.row_kontrol"+satir).value==1)
		{
			deger_total = eval("document.all.row_total_"+satir);//tutar
			deger_total2 = eval("document.all.row_total2_"+satir);//dövizli tutar
			deger_miktar = eval("document.all.quantity"+satir);//miktar
			deger_kdv_total= eval("document.all.kdv_total"+satir);//kdv tutarı
			deger_otv_total= document.getElementById("otv_total"+satir);//otv tutarı
			deger_net_total = eval("document.all.net_total"+satir);//kdvli tutar
			deger_tax_rate = eval("document.all.tax_rate"+satir);//kdv oranı
			deger_otv_rate = document.getElementById("otv_rate"+satir);//otv oranı
			deger_other_net_total = eval("document.all.row_other_total"+satir);//dovizli tutar kdv dahil
			deger_last_value = eval("document.all.last_inventory_value"+satir);//Son değer
			deger_last_unit_value = eval("document.all.unit_last_value"+satir);//Son değer birim
			deger_first_value = eval("document.all.total_first_value"+satir);//İlk değer
			deger_first_unit_value = eval("document.all.unit_first_value"+satir);//İlk değer birim
			deger_diff_value = eval("document.all.last_diff_value"+satir);//Fark
			if(deger_total.value == "") deger_total.value = 0;
			if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
			if(deger_net_total.value == "") deger_net_total.value = 0;
			deger_money_id = eval("document.all.money_id"+satir);
			deger_money_id_ilk = list_getat(deger_money_id.value,2,',');
			deger_money_id_son = list_getat(deger_money_id.value,3,',');
			deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_miktar.value = filterNum(deger_miktar.value,0);
			deger_last_value.value = filterNum(deger_last_value.value);
			deger_last_unit_value.value = filterNum(deger_last_unit_value.value);
			deger_first_value.value = filterNum(deger_first_value.value);
			deger_first_unit_value.value = filterNum(deger_first_unit_value.value);
			deger_diff_value.value = filterNum(deger_diff_value.value);
			
			for(s=1;s<=add_invent.kur_say.value;s++)
			{
				if(list_getat(document.add_invent.rd_money[s-1].value,1,',') == list_getat(deger_money_id.value,1,','))
				{
                    satir_rate2 = filterNum(document.getElementById("txt_rate2_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
                    satir_rate1 = filterNum(document.getElementById("txt_rate1_"+s).value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
				}
			}
			
			if(hesap_type ==undefined)
			{
				deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
				deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate.value)/100;
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
					deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_miktar.value)) * deger_tax_rate.value)/100;
				<cfelse>
					deger_kdv_total.value = ((parseFloat(deger_total.value* deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
				</cfif>
			}
			else if(hesap_type == 1)
			{
				deger_total.value = parseFloat(deger_total2.value)*(parseFloat(satir_rate2)/parseFloat(satir_rate1));
				deger_otv_total.value = (parseFloat(deger_total.value) * deger_miktar.value * deger_otv_rate.value)/100;
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
					deger_kdv_total.value = ((parseFloat(deger_total.value) * parseFloat(deger_miktar.value)) * deger_tax_rate.value)/100;
				<cfelse>
					deger_kdv_total.value = ((parseFloat(deger_total.value* deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
				</cfif>
			}
			else if(hesap_type == 2)
			{
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>  
					deger_total.value = ((parseFloat(deger_net_total.value)/parseFloat(deger_miktar.value))*100)/ (parseFloat(deger_tax_rate.value)+parseFloat(otv_rate_)+100);
					deger_kdv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_tax_rate.value))/100;
					deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate.value))/100;
				<cfelse>
					deger_total.value = ((parseFloat(deger_net_total.value)*100)/ (parseFloat(deger_tax_rate.value)+100))/deger_miktar.value;
					deger_otv_total.value = (parseFloat(deger_total.value * deger_miktar.value * deger_otv_rate.value))/100;
					deger_kdv_total.value = ((parseFloat(deger_total.value * deger_miktar.value)+parseFloat(deger_otv_total.value)) * deger_tax_rate.value)/100;
				</cfif>
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
			}
			else if(hesap_type == 3)
			{
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
					deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
				<cfelse>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
					deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate.value))/(100 + parseFloat(deger_otv_rate.value));
				</cfif>
					deger_total.value = parseFloat(deger_net_total.value - deger_kdv_total.value);
					deger_total.value = parseFloat(deger_total.value - deger_otv_total.value);
					deger_total.value = (deger_total.value/deger_miktar.value);
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
			}
			else if(hesap_type == 4)
			{
				for(s=1;s<=add_invent.kur_say.value;s++)
				{
					if(list_getat(document.add_invent.rd_money[s-1].value,1,',') == list_getat(deger_money_id.value,1,','))
					{
						satir_rate2 = filterNum(document.getElementById("txt_rate2_"+s).value);
						satir_rate1 = document.getElementById("txt_rate1_"+s).value;
					}
				}
				deger_net_total.value = parseFloat(deger_other_net_total.value) * (parseFloat(satir_rate2)/parseFloat(satir_rate1));
				
				<cfif isdefined('x_kdv_add_to_otv') and x_kdv_add_to_otv eq 0>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
					deger_otv_total.value = (parseFloat(deger_net_total.value * deger_otv_rate.value))/(100 + parseFloat(deger_tax_rate.value)+ parseFloat(deger_otv_rate.value));
				<cfelse>
					deger_kdv_total.value = (parseFloat(deger_net_total.value * deger_tax_rate.value))/(100 + parseFloat(deger_tax_rate.value));
					deger_otv_total.value = (parseFloat((deger_net_total.value - deger_kdv_total.value) * deger_otv_rate.value))/(100 + parseFloat(deger_otv_rate.value));
				</cfif>
					deger_total.value = parseFloat(deger_net_total.value - deger_kdv_total.value);
					deger_total.value = parseFloat(deger_total.value - deger_otv_total.value);
					deger_total.value = (deger_total.value/deger_miktar.value);
					deger_total2.value = parseFloat(deger_total.value)*(parseFloat(satir_rate1)/parseFloat(satir_rate2));
			}
            toplam_dongu_0 = (parseFloat(deger_total.value)*deger_miktar.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value);
            deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) * parseFloat(deger_money_id_ilk) / (parseFloat(deger_money_id_son)));
			deger_net_total.value = commaSplit(toplam_dongu_0,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_last_value.value =  parseFloat(deger_last_unit_value.value * deger_miktar.value);
			deger_first_value.value =  parseFloat(deger_first_unit_value.value * deger_miktar.value);
			deger_diff_value.value = parseFloat((deger_total.value * deger_miktar.value)  - deger_last_value.value);
			deger_diff_value.value = commaSplit(deger_diff_value.value);
			deger_last_value.value = commaSplit(deger_last_value.value);
			deger_last_unit_value.value = commaSplit(deger_last_unit_value.value);
			deger_first_value.value = commaSplit(deger_first_value.value);
			deger_first_unit_value.value = commaSplit(deger_first_unit_value.value);
			deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_total2.value = commaSplit(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		}
		toplam_hesapla();
	}
	var stopaj_yuzde_;
	function calc_stopaj()
	{
		stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		if((stopaj_yuzde_ < 0) || (stopaj_yuzde_ > 99.99))
		{
			alert("<cf_get_lang dictionary_id='50036.Stopaj Oranı'>!");
			document.getElementById("stopaj_yuzde").value = 0;
		}
		toplam_hesapla(0);
	}
	function toplam_hesapla(type)
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		var toplam_dongu_4 = 0;// kdvli genel toplam
		var toplam_dongu_5 = 0;// ötv genel toplam
		var beyan_tutar = 0;
		var tevkifat_info = "";
		var beyan_tutar_info = "";
		var new_taxArray = new Array(0);
		var taxBeyanArray = new Array(0);
		var taxTevkifatArray = new Array(0);
		for(r=1;r<=document.all.record_num.value;r++)
		{
			if(eval("document.all.row_kontrol"+r).value==1)
			{
				toplam_dongu_4 = toplam_dongu_4 + (parseFloat(filterNum(eval("document.all.row_total_"+r).value) * filterNum(eval("document.all.quantity"+r).value)));
			}
		}			
		genel_indirim_yuzdesi = commaSplit(parseFloat(document.all.net_total_discount.value) / parseFloat(toplam_dongu_4),8);
		genel_indirim_yuzdesi = filterNum(genel_indirim_yuzdesi,8);
		genel_indirim_yuzdesi = wrk_round(genel_indirim_yuzdesi,2);
		deger_discount_value = document.all.net_total_discount.value;
		deger_discount_value = filterNum(deger_discount_value,4);
	
		for(r=1;r<=document.all.record_num.value;r++)
		{
			if(eval("document.all.row_kontrol"+r).value==1)
			{
				deger_total = eval("document.all.row_total_"+r);//tutar
				deger_total2 = eval("document.all.row_total2_"+r);//dövizli tutar
				deger_miktar = eval("document.all.quantity"+r);//miktar
				deger_kdv_total= eval("document.all.kdv_total"+r);//kdv tutarı
				deger_otv_total= document.getElementById("otv_total"+r);//ötv tutarı
				deger_net_total = eval("document.all.net_total"+r);//kdvli tutar
				deger_tax_rate = eval("document.all.tax_rate"+r);//kdv oranı
				deger_other_net_total = eval("document.all.row_other_total"+r);//dovizli tutar kdv dahil
				deger_money_id = eval("document.all.money_id"+r);
				deger_money_id_ilk = list_getat(deger_money_id.value,1,',');
				for(s=1;s<=document.all.kur_say.value;s++)
					{
						if(list_getat(document.all.rd_money[s-1].value,1,',') == deger_money_id_ilk)
						{
							satir_rate2= eval("document.all.txt_rate2_"+s).value;
						}
					}
				satir_rate2= filterNum(satir_rate2,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');	
				deger_miktar.value = filterNum(deger_miktar.value,0);		
				deger_total.value = filterNum(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = filterNum(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = filterNum(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = filterNum(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_net_total.value = filterNum(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = filterNum(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_miktar.value);
                deger_other_net_total.value = ((parseFloat(deger_total.value * deger_miktar.value) + parseFloat(deger_kdv_total.value) + parseFloat(deger_otv_total.value)) / (parseFloat(satir_rate2)));
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_5 = toplam_dongu_5 + parseFloat(deger_otv_total.value);
				deger_indirim_kdv = parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + ((parseFloat(deger_total.value)- (parseFloat(deger_total.value)*genel_indirim_yuzdesi)) * deger_miktar.value);
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_kdv_total.value)- parseFloat(deger_kdv_total.value*genel_indirim_yuzdesi);
				toplam_dongu_3 = toplam_dongu_3 + parseFloat(deger_otv_total.value);
				
				if(document.all.tevkifat_oran != undefined && document.all.tevkifat_oran.value != "" && document.all.tevkifat_box.checked == true)
				{//tevkifat hesaplamaları
					beyan_tutar = beyan_tutar + wrk_round(deger_indirim_kdv*filterNum(document.all.tevkifat_oran.value));
					if(new_taxArray.length != 0)
						for (var m=0; m < new_taxArray.length; m++)
						{	
							var tax_flag = false;
							if(new_taxArray[m] == deger_tax_rate.value){
								tax_flag = true;
								taxBeyanArray[m] += wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.all.tevkifat_oran.value))));
								taxTevkifatArray[m] += wrk_round(deger_indirim_kdv*(filterNum(document.all.tevkifat_oran.value)));
								break;
							}
						}
					if(!tax_flag){
						new_taxArray[new_taxArray.length] = deger_tax_rate.value;
						taxBeyanArray[taxBeyanArray.length] = wrk_round(deger_indirim_kdv - (deger_indirim_kdv*(filterNum(document.all.tevkifat_oran.value))));
						taxTevkifatArray[taxTevkifatArray.length] = wrk_round(deger_indirim_kdv*(filterNum(document.all.tevkifat_oran.value)));
					}
				}
				deger_net_total.value = commaSplit(deger_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total.value = commaSplit(deger_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_total2.value = commaSplit(deger_total2.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_kdv_total.value = commaSplit(deger_kdv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_otv_total.value = commaSplit(deger_otv_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				deger_other_net_total.value = commaSplit(deger_other_net_total.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			}
		}	
		if(document.all.tevkifat_oran != undefined && document.all.tevkifat_oran.value != "" && document.all.tevkifat_box.checked == true)
		{	//tevkifat hesaplamaları
			toplam_dongu_3 = toplam_dongu_3 - toplam_dongu_2 + beyan_tutar;
			toplam_dongu_2 = beyan_tutar;
			tevkifat_text.style.fontWeight = 'bold';
			tevkifat_text.innerHTML = '';
			beyan_text.style.fontWeight = 'bold';
			beyan_text.innerHTML = '';
			for (var tt=0; tt < new_taxArray.length; tt++)
			{
				tevkifat_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxBeyanArray[tt],4) + ' ';
				beyan_text.innerHTML += '% ' + new_taxArray[tt] + ' : ' + commaSplit(taxTevkifatArray[tt],4) + ' ';
			}
		}	
		
		var stopaj_yuzde_ = filterNum(document.getElementById("stopaj_yuzde").value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		if(type == undefined || stopaj_yuzde_ == 0)
			stopaj_ = wrk_round(((toplam_dongu_1 * stopaj_yuzde_) / 100),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		else
			stopaj_ = filterNum(document.getElementById("stopaj").value);
			
		document.getElementById("stopaj_yuzde").value = commaSplit(stopaj_yuzde_);
		document.getElementById("stopaj").value = commaSplit(stopaj_,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		
		toplam_dongu_3 = toplam_dongu_3-parseFloat(stopaj_);
		//stopajlar hesaplandi
		document.all.total_amount.value = commaSplit(toplam_dongu_1,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.kdv_total_amount.value = commaSplit(toplam_dongu_2,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.getElementById("otv_total_amount").value = commaSplit(toplam_dongu_5,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.all.net_total_amount.value = commaSplit(toplam_dongu_3,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		for(s=1;s<=document.all.kur_say.value;s++)
		{
			form_txt_rate2_ = eval("document.all.txt_rate2_"+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(document.all.kur_say.value == 1)
			for(s=1;s<=document.all.kur_say.value;s++)
			{
				if(document.all.rd_money.checked == true)
				{
					deger_diger_para = document.all.rd_money;
					form_txt_rate2_ = eval("document.all.txt_rate2_"+s);
				}
			}
		else 
			for(s=1;s<=document.all.kur_say.value;s++)
			{
				if(document.all.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.all.rd_money[s-1];
					form_txt_rate2_ = eval("document.all.txt_rate2_"+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.all.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>); 
		document.getElementById("other_otv_total_amount").value = commaSplit(toplam_dongu_5 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.other_net_total_discount.value = commaSplit(deger_discount_value* parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value)),<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
		document.all.net_total_discount.value = commaSplit(deger_discount_value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
	
		document.all.tl_value1.value = deger_money_id_1;
		document.all.tl_value2.value = deger_money_id_1;				//kdv
		document.getElementById("tl_value5").value = deger_money_id_1;	//otv
		document.all.tl_value3.value = deger_money_id_1;
		document.all.tl_value4.value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	function gonder(invent_id,invent_name,invent_no,quantity,acc_id,amort_rate,amortizaton_method,unit_last_value,last_inventory_value,unit_first_value,total_first_value,last_diff_value,expense_center_id,expense_center_name,budget_item_id,budget_item_name,debt_account_id,claim_account_id,product_id,product_name,product_unit_id,stock_id,product_unit,reason_code)
	{
		if(invent_name.indexOf('"') > -1)
			invent_name = invent_name.replace(/"/g,'');
		if(invent_name.indexOf("'") > -1)
			invent_name = invent_name.replace(/'/g,'');
		row_count++;
		satir_say++;
		var newRow;
		var newCell;
		if (reason_code == undefined) reason_code ="";
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.getElementById("record_num").value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		x = '<input type="hidden" value="WRK'+row_count+ js_create_unique_id() + row_count+'" id="wrk_row_id' + row_count +'" name="wrk_row_id' + row_count +'"><input  type="hidden" value="" id="wrk_row_relation_id' + row_count +'" name="wrk_row_relation_id' + row_count +'">';
		newCell.innerHTML = x + '<input  type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'" ><a href="javascript://" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" id="invent_id' + row_count +'" name="invent_id' + row_count +'" value="'+ invent_id +'" readonly><input type="text" id="invent_no' + row_count +'" name="invent_no' + row_count +'" style="width:100%;" class="boxtext" value="'+ invent_no +'" maxlength="50">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="text" readonly id="invent_name' + row_count +'" name="invent_name' + row_count +'" style="width:100px;" class="boxtext" value="'+ invent_name + '" maxlength="100">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="quantity' + row_count +'" name="quantity' + row_count +'" style="width:60px;" class="box" value="'+ quantity +'" onBlur="hesapla(' + row_count +');" onkeyup="return(FormatCurrency(this,event));">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="row_total_' + row_count +'" name="row_total_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +');" style="width:60px;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="row_total2_' + row_count +'" name="row_total2_' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onBlur="hesapla(' + row_count +',1);" style="width:60px;" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.innerHTML = '<select id="tax_rate'+ row_count +'" name="tax_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_tax"><option value="#tax#">#tax#</option></cfoutput></select>';
		//otv orani
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<select id="otv_rate'+ row_count +'" name="otv_rate'+ row_count +'" style="width:100%;" onChange="hesapla('+ row_count +');" class="box"><cfoutput query="get_otv"><option value="#tax#">#tax#</option></cfoutput></select>';
		//kdv total
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="kdv_total' + row_count +'" name="kdv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:60px;" onBlur="hesapla(' + row_count +',1);" class="box">';
		//otv total
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="otv_total' + row_count +'" name="otv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" style="width:60px;" onBlur="hesapla(' + row_count +',1);" class="box">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
        newCell.innerHTML = '<input type="text" id="net_total' + row_count +'" name="net_total' + row_count +'" value="0" style="width:60px;" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" onblur="hesapla(' + row_count +',3);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
        newCell.innerHTML = '<input type="text" id="row_other_total' + row_count +'" name="row_other_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>));" width:60px; class="box" onblur="hesapla(' + row_count +',4);">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<select id="money_id' + row_count  +'" name="money_id' + row_count  +'" width="300" class="boxtext" onChange="hesapla('+ row_count +');"><cfoutput query="get_money"><option value="#money#,#rate1#,#rate2#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="amortization_rate' + row_count +'" name="amortization_rate' + row_count +'" value="'+ amort_rate +'" width:60px; class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		if(amortizaton_method == 0)
			newCell.innerHTML = '<input type="text" id="amortization_method'+ row_count +'" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang dictionary_id="29421.Azalan Bakiye Üzerinden">">';
		else if(amortizaton_method == 1)
			newCell.innerHTML = '<input type="text" id="amortization_method'+ row_count +'" readonly name="amortization_method'+ row_count +'" style="width:165px;" class="boxtext" value="<cf_get_lang dictionary_id="29422.Sabit Miktar Üzeriden">">';
			newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="account_id' + row_count +'" name="account_id' + row_count +'"  value="'+ acc_id +'"><input type="text" name="account_code' + row_count +'"  id="account_code' + row_count +'" value="'+ acc_id +'" class="boxtext" onFocus="autocomp_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="hidden" id="unit_last_value' + row_count +'" name="unit_last_value' + row_count +'" value="'+ unit_last_value +'"><input type="hidden" name="unit_first_value' + row_count +'" value="'+ unit_first_value +'"><input type="hidden" id="total_first_value' + row_count +'" name="total_first_value' + row_count +'" value="'+ total_first_value +'"><input type="text" id="last_inventory_value' + row_count +'" name="last_inventory_value' + row_count +'" value="'+ last_inventory_value +'" style="width:60%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML = '<input type="text" id="last_diff_value' + row_count +'" name="last_diff_value' + row_count +'" value="'+last_diff_value+'" style="width:60%;" class="box" onkeyup="return(FormatCurrency(this,event));" readonly="yes">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		<cfoutput>
			reas = '<select name="reason_code' + row_count  +'" id="reason_code' + row_count  +'" class="boxtext"  style="width:165px;"><option value=""><cf_get_lang dictionary_id='39939.İstisna'></option>';
			<cfloop list="#reason_code_list#" index="info_list" delimiters="*">
				if('#listfirst(info_list,'*')#' == reason_code)
					reas += '<option value="#listfirst(info_list,'*')#" selected>#listlast(info_list,'*')#</option>';
				else
					reas += "<option value='#listfirst(info_list,'*')#'>#listlast(info_list,'*')#</option>";
			</cfloop>
			newCell.innerHTML =reas+ '</select>';
		</cfoutput>

		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" value="'+expense_center_id+'" id="expense_center_id' + row_count +'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="exp_center('+row_count+');" value="'+expense_center_name+'" style="width:150px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp_center('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;	
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" name="budget_item_id' + row_count +'" id="budget_item_id' + row_count +'" value='+budget_item_id+'><input type="text" style="width:115px;" name="budget_item_name' + row_count +'" id="budget_item_name' + row_count +'" class="boxtext" value="'+budget_item_name+'" onFocus="exp_item('+row_count+');"><a href="javascript://"><img src="/images/plus_thin.gif" onclick="pencere_ac_exp('+ row_count +');" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" name="budget_account_id' + row_count +'" id="budget_account_id' + row_count +'" value="'+debt_account_id+'"><input type="text" name="budget_account_code' + row_count +'" id="budget_account_code' + row_count +'"  value="'+debt_account_id+'" class="boxtext" style="width:155px;" onFocus="autocomp_budget_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc_1('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");	
		newCell.innerHTML = '<input  type="hidden" name="amort_account_id' + row_count +'" id="amort_account_id' + row_count +'" value="'+claim_account_id+'"><input type="text" name="amort_account_code' + row_count +'" id="amort_account_code' + row_count +'"  value="'+claim_account_id+'" class="boxtext" style="width:205px;" onFocus="autocomp_amort_account('+row_count+');"><a href="javascript://"onclick="pencere_ac_acc_2('+ row_count +');" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden" id="product_id' + row_count +'" name="product_id' + row_count +'" value="'+product_id+'"><input id="stock_id' + row_count +'" type="hidden" name="stock_id' + row_count +'" value="'+stock_id+'"><input type="text" id="product_name' + row_count +'" name="product_name' + row_count +'" class="boxtext" value="'+product_name+'" onFocus="AutoComplete_Create(\'product_name' + row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME,STOCK_CODE\',\'get_product_autocomplete\',\'0\',\'PRODUCT_ID,STOCK_ID,MAIN_UNIT,PRODUCT_UNIT_ID\',\'product_id' + row_count +',stock_id' + row_count +',stock_unit' + row_count  +',stock_unit_id' + row_count  +'\',\'add_invent\',1,\'\',\'\');">'
							+'<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=product_id" + row_count + "&field_id=stock_id" + row_count + "&field_unit_name=stock_unit" + row_count + "&field_main_unit=stock_unit_id" + row_count + "&field_name=product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.title=document.getElementById("invent_name"+satir_say).value;
		newCell.innerHTML = '<input type="hidden" id="stock_unit_id' + row_count +'" name="stock_unit_id' + row_count +'" value="'+product_unit_id+'"><input type="text" name="stock_unit' + row_count +'" id="stock_unit' + row_count +'" style="width:100%;" class="boxtext">';
	}
	/* masraf merkezi popup */
	function pencere_ac_exp_center(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_invent.expense_center_id' + no +'&field_name=add_invent.expense_center_name' + no,'list');
	}
	/* masraf merkezi autocomplete */
	function exp_center(no)
	{
		AutoComplete_Create("expense_center_name" + no,"EXPENSE,EXPENSE_CODE","EXPENSE,EXPENSE_CODE","get_expense_center","","EXPENSE_ID","expense_center_id"+no,"",3);
	}
	/* gider kalemi autocomplete */
	function exp_item(no)
	{
		AutoComplete_Create("budget_item_name" + no,"EXPENSE_ITEM_NAME","EXPENSE_ITEM_NAME","get_expense_item","","EXPENSE_ITEM_ID,ACCOUNT_CODE","budget_item_id"+no+",budget_account_code"+no,"",3);
	}
	function autocomp_account(no)
	{
		AutoComplete_Create("account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","account_id"+no,"",3);
	}
	function autocomp_budget_account(no)
	{
		AutoComplete_Create("budget_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","budget_account_id"+no,"",3);
	}
	function autocomp_amort_account(no)
	{
		AutoComplete_Create("amort_account_code"+no,"ACCOUNT_CODE,ACCOUNT_NAME","ACCOUNT_CODE,ACCOUNT_NAME","get_account_code","0","ACCOUNT_CODE","amort_account_id"+no,"",3);
	}
	function pencere_ac_acc(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=account_id' + no +'&field_name=account_code' + no +'','list');
	}
	function pencere_ac_acc_1(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=budget_account_id' + no +'&field_name=budget_account_code' + no +'','list');
	}
	function pencere_ac_acc_2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=amort_account_id' + no +'&field_name=amort_account_code' + no +'','list');
	}
	function pencere_ac_exp(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&is_budget_items=1&field_id=budget_item_id' + no +'&field_name=budget_item_name' + no +'&field_account_no=budget_account_code' + no +'&field_account_no2=budget_account_id' + no +'','list');
	}
	function pencere_ac_stock(no)
	{
		if(document.all.branch_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='57723.Önce depo seçmelisiniz'>!");
			return false;
		}
		if(document.all.company_id.value.length==0)
		{ 
			alert("<cf_get_lang dictionary_id='57715.Önce Üye Seçiniz'>!");
			return false;
		}
		if(document.all.company_id!=undefined && document.all.company_id.value.length)
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_products&company_id='+document.all.company_id.value+'&int_basket_id=1&is_sale_product=0&update_product_row_id=0</cfoutput>','list');
	}
	function ayarla_gizle_goster()
	{
		if(document.all.cash.checked)
			kasa_sec.style.display='';
		else
			kasa_sec.style.display='none';
	}
	
	function f_add_invent()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_inventory&field_id=invent_id&is_sale=1','wide');
	}
	
	function change_paper_duedate(field_name,type,is_row_parse) 
	{
		paper_date_=eval('document.all.invoice_date.value');
		if(type!=undefined && type==1)
			document.all.basket_due_value.value = datediff(paper_date_,document.all.basket_due_value_date_.value,0);
		else
		{
			if(isNumber(document.all.basket_due_value)!= false && (document.all.basket_due_value.value != 0))
				document.all.basket_due_value_date_.value = date_add('d',+document.all.basket_due_value.value,paper_date_);
			else
			{
				document.all.basket_due_value_date_.value =paper_date_;
				if(document.all.basket_due_value.value == '')
					document.all.basket_due_value.value = datediff(paper_date_,document.all.basket_due_value_date_.value,0);
			}
		}
	}
	function change_acc_all()
	{
		var loopcount=document.getElementById('record_num').value;	
		if(loopcount>0)
		{
			for(var i=1;i<=loopcount;++i)
			{
				document.getElementById('account_id'+i).value = document.getElementById('account_id_all').value;
				document.getElementById('account_code'+i).value = document.getElementById('account_code_all').value;
			}
		}
	}
	function change_budget_acc_all()
	{
		var loopcount=document.getElementById('record_num').value;	
		if(loopcount>0)
		{
			for(var i=1;i<=loopcount;++i)
			{
				document.getElementById('budget_account_id'+i).value = document.getElementById('budget_account_id_all').value;
				document.getElementById('budget_account_code'+i).value = document.getElementById('budget_account_code_all').value;
			}
		}
	}
	function change_exp_all()
	{
		var loopcount=document.getElementById('record_num').value;	
		if(loopcount>0)
		{
			for(var i=1;i<=loopcount;++i)
			{
				document.getElementById('budget_item_id'+i).value = document.getElementById('budget_item_id_all').value;
				document.getElementById('budget_item_name'+i).value = document.getElementById('budget_item_name_all').value;
				document.getElementById('budget_account_id'+i).value = document.getElementById('budget_account_id_all').value;
				document.getElementById('budget_account_code'+i).value = document.getElementById('budget_account_code_all').value;
			}
		}
	}
	function change_amort_all()
	{
		var loopcount=document.getElementById('record_num').value;	
		if(loopcount>0)
		{
			for(var i=1;i<=loopcount;++i)
			{
				document.getElementById('amort_account_id'+i).value = document.getElementById('amort_account_id_all').value;
				document.getElementById('amort_account_code'+i).value = document.getElementById('amort_account_code_all').value;
			}
		}
	}
	function change_expense_center()
	{
		var loopcount=document.getElementById('record_num').value;
		if(loopcount>0)
		{
			for(var i=1;i<=loopcount;++i)
			{
				document.getElementById('expense_center_id'+i).value = document.getElementById('expense_center_id_all').value;
				document.getElementById('expense_center_name'+i).value = document.getElementById('main_exp_center_name_all').value;
			}
		}
	}
</script>
