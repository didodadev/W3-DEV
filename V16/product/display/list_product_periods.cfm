<cf_xml_page_edit fuseact="product.popup_list_period">
	<cfinclude template="../query/get_product_account_function.cfm">
	<cfinclude template="../query/get_periods.cfm">
	<cfinclude template="../query/get_product_period_details.cfm">
	<cfparam name="attributes.modal_id" default="">
	<cfset period_selected = ValueList(GET_PRODUCT_PERIODS.PERIOD_ID)>
	<cfquery name="GET_EXPENSE_ITEM1" datasource="#dsn2#">
		SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
	</cfquery> 
	 <cfquery name="GET_EXPENSE_CENTER2" datasource="#dsn2#">
		SELECT EXPENSE_ID, EXPENSE, EXPENSE_CODE FROM EXPENSE_CENTER ORDER BY  EXPENSE_CODE
	</cfquery> 
	<cfquery name="GET_EXPENSE_TEMPLATE" datasource="#dsn2#">
		SELECT TEMPLATE_ID, TEMPLATE_NAME,IS_INCOME FROM EXPENSE_PLANS_TEMPLATES ORDER BY TEMPLATE_NAME
	</cfquery>
	<cfquery name="GET_EXPENSE_TEMPLATE_EXPENSE" dbtype="query">
		SELECT TEMPLATE_ID, TEMPLATE_NAME FROM GET_EXPENSE_TEMPLATE WHERE IS_INCOME<>1 ORDER BY TEMPLATE_NAME
	</cfquery>
	<cfquery name="GET_EXPENSE_TEMPLATE_INCOME" dbtype="query">
		SELECT TEMPLATE_ID, TEMPLATE_NAME FROM GET_EXPENSE_TEMPLATE WHERE IS_INCOME=1 ORDER BY TEMPLATE_NAME
	</cfquery>
	<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
		SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY WHERE ACTIVITY_STATUS = 1 ORDER BY ACTIVITY_NAME
	</cfquery>
	<cfset attributes.active_cat = 1>
	<cfinclude template="../query/get_code_cat.cfm">
	<cfquery name="get_product_info" datasource="#dsn1#">
		SELECT PRODUCT_CODE, PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #attributes.pid#
	</cfquery>
	<cf_box title="#get_product_info.product_code# - #get_product_info.product_name#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_period" method="post" action="#request.self#?fuseaction=product.emptypopup_add_periods_to_product&pid=#attributes.pid#">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
					<input type="hidden" name="company_main_id" id="company_main_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
						<div class="col col-8 col-xs-12">
							<select name="period_main_id" id="period_main_id" onchange="javascript:window.location.href='<cfoutput>#request.self#?fuseaction=product.popup_list_period&pid=#attributes.pid#&period_id=</cfoutput>' + add_period.period_main_id.options[add_period.period_main_id.options.selectedIndex].value;">
								<cfoutput query="get_company_periods">
									<option value="#period_id#" <cfif get_company_periods.period_id eq attributes.period_id >selected</cfif>>#period#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<input name="product_id" id="product_id" type="hidden" value="<cfoutput>#attributes.pid#</cfoutput>" />
				<cfif get_other_period.recordcount>
					<input name="record_num" id="record_num" value="<cfoutput>#get_other_period.recordcount#</cfoutput>" type="hidden" />
					<input type="hidden" name="periods" id="periods" value="<cfoutput>#valuelist(get_other_period.period_id)#</cfoutput>" />
					<cfoutput query="GET_OTHER_PERIOD">
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'> <cf_get_lang dictionary_id='58455.Yıl'></label>
								<div class="col col-8 col-xs-12">
									<input type="text" value="#period# / #period_year#" readonly>
									<input type="hidden" name="for_control" id="for_control" value="#period_year#-#our_company_id#-#period_id#" />
									<input type="hidden" name="product_period_cat_id" id="product_period_cat_id" value="#GET_PRODUCT_PERIODS.product_period_cat_id#" />
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37567.Muhasebe Kod Grubu'></label>
								<div class="col col-8 col-xs-12">
									<cfset old_code_list = "#GET_PRODUCT_PERIODS.product_period_cat_id#,#GET_PRODUCT_PERIODS.ACCOUNT_CODE#,#GET_PRODUCT_PERIODS.ACCOUNT_CODE_PUR#,#GET_PRODUCT_PERIODS.ACCOUNT_DISCOUNT#,#GET_PRODUCT_PERIODS.ACCOUNT_PRICE#,#GET_PRODUCT_PERIODS.ACCOUNT_PRICE_PUR#,#GET_PRODUCT_PERIODS.ACCOUNT_PUR_IADE#,#GET_PRODUCT_PERIODS.ACCOUNT_IADE#,#GET_PRODUCT_PERIODS.ACCOUNT_YURTDISI#,#GET_PRODUCT_PERIODS.ACCOUNT_YURTDISI_PUR#,#GET_PRODUCT_PERIODS.ACCOUNT_DISCOUNT_PUR#,#GET_PRODUCT_PERIODS.ACCOUNT_LOSS#,#GET_PRODUCT_PERIODS.ACCOUNT_EXPENDITURE#,#GET_PRODUCT_PERIODS.OVER_COUNT#,#GET_PRODUCT_PERIODS.UNDER_COUNT#,#GET_PRODUCT_PERIODS.PRODUCTION_COST#,#GET_PRODUCT_PERIODS.HALF_PRODUCTION_COST#,#GET_PRODUCT_PERIODS.SALE_PRODUCT_COST#,#GET_PRODUCT_PERIODS.MATERIAL_CODE#,#GET_PRODUCT_PERIODS.KONSINYE_PUR_CODE#,#GET_PRODUCT_PERIODS.KONSINYE_SALE_CODE#,#GET_PRODUCT_PERIODS.KONSINYE_SALE_NAZ_CODE#,#GET_PRODUCT_PERIODS.DIMM_CODE#,#GET_PRODUCT_PERIODS.DIMM_YANS_CODE#,#GET_PRODUCT_PERIODS.PROMOTION_CODE#,#GET_PRODUCT_PERIODS.EXPENSE_CENTER_ID#,#GET_PRODUCT_PERIODS.EXPENSE_ITEM_ID#,#GET_PRODUCT_PERIODS.ACTIVITY_TYPE_ID#,#GET_PRODUCT_PERIODS.EXPENSE_TEMPLATE_ID#,#GET_PRODUCT_PERIODS.COST_EXPENSE_CENTER_ID#,#GET_PRODUCT_PERIODS.INCOME_ITEM_ID#,#GET_PRODUCT_PERIODS.INCOME_ACTIVITY_TYPE_ID#,#GET_PRODUCT_PERIODS.INCOME_TEMPLATE_ID#,#GET_PRODUCT_PERIODS.INVENTORY_CAT_ID#,#GET_PRODUCT_PERIODS.INVENTORY_CODE#,#GET_PRODUCT_PERIODS.AMORTIZATION_METHOD_ID#,#GET_PRODUCT_PERIODS.AMORTIZATION_TYPE_ID#,#GET_PRODUCT_PERIODS.AMORTIZATION_EXP_CENTER_ID#,#GET_PRODUCT_PERIODS.AMORTIZATION_EXP_ITEM_ID#,#GET_PRODUCT_PERIODS.AMORTIZATION_CODE#,#GET_PRODUCT_PERIODS.PROD_GENERAL_CODE#,#GET_PRODUCT_PERIODS.PROD_LABOR_COST_CODE#,#GET_PRODUCT_PERIODS.RECEIVED_PROGRESS_CODE#,#GET_PRODUCT_PERIODS.SALE_MANUFACTURED_COST#,#GET_PRODUCT_PERIODS.MATERIAL_CODE_SALE#,#GET_PRODUCT_PERIODS.PRODUCTION_COST_SALE#,#GET_PRODUCT_PERIODS.SCRAP_CODE_SALE#,#GET_PRODUCT_PERIODS.SCRAP_CODE#,#GET_PRODUCT_PERIODS.EXE_VAT_SALE_INVOICE#,#GET_PRODUCT_PERIODS.DISCOUNT_EXPENSE_CENTER_ID#,#GET_PRODUCT_PERIODS.DISCOUNT_EXPENSE_ITEM_ID#,#GET_PRODUCT_PERIODS.DISCOUNT_ACTIVITY_TYPE_ID#,#GET_PRODUCT_PERIODS.REASON_CODE#,#GET_PRODUCT_PERIODS.OUTGOING_STOCK#,#GET_PRODUCT_PERIODS.INCOMING_STOCK#,#GET_PRODUCT_PERIODS.ACCOUNT_EXPORTREGISTERED#">
									<select name="period_code_cat" id="period_code_cat" onchange="cat_kontrol();">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_code_cat">
											<cfset period_code_list =  "#PRO_CODE_CATID#,#ACCOUNT_CODE#,#ACCOUNT_CODE_PUR#,#ACCOUNT_DISCOUNT#,#ACCOUNT_PRICE#,#ACCOUNT_PRICE_PUR#,#ACCOUNT_PUR_IADE#,#ACCOUNT_IADE#,#ACCOUNT_YURTDISI#,#ACCOUNT_YURTDISI_PUR#,#ACCOUNT_DISCOUNT_PUR#,#ACCOUNT_LOSS#,#ACCOUNT_EXPENDITURE#,#OVER_COUNT#,#UNDER_COUNT#,#PRODUCTION_COST#,#HALF_PRODUCTION_COST#,#SALE_PRODUCT_COST#,#MATERIAL_CODE#,#KONSINYE_PUR_CODE#,#KONSINYE_SALE_CODE#,#KONSINYE_SALE_NAZ_CODE#,#DIMM_CODE#,#DIMM_YANS_CODE#,#PROMOTION_CODE#,#EXP_CENTER_ID#,#EXP_ITEM_ID#,#EXP_ACTIVITY_TYPE_ID#,#EXP_TEMPLATE_ID#,#INC_CENTER_ID#,#INC_ITEM_ID#,#INC_ACTIVITY_TYPE_ID#,#INC_TEMPLATE_ID#,#INVENTORY_CAT_ID#,#INVENTORY_CODE#,#AMORTIZATION_METHOD_ID#,#AMORTIZATION_TYPE_ID#,#AMORTIZATION_EXP_CENTER_ID#,#AMORTIZATION_EXP_ITEM_ID#,#AMORTIZATION_CODE#,#PROD_GENERAL_CODE#,#PROD_LABOR_COST_CODE#,#RECEIVED_PROGRESS_CODE#,#PROVIDED_PROGRESS_CODE#,#SALE_MANUFACTURED_COST#,#MATERIAL_CODE_SALE#,#PRODUCTION_COST_SALE#,#SCRAP_CODE_SALE#,#SCRAP_CODE#,#EXE_VAT_SALE_INVOICE#,#EXPENSE#,#EXPENSE_ITEM_NAME#,#EXPENSE_INCOME#,#EXPENSE_ITEM_NAME_INCOME#,#DISCOUNT_EXPENSE_CENTER_ID#,#DISCOUNT_EXPENSE_CENTER_NAME#,#DISCOUNT_EXPENSE_ITEM_ID#,#DISCOUNT_EXPENSE_ITEM_NAME#,#DISCOUNT_ACTIVITY_TYPE_ID#,#REASON_CODE#,#OUTGOING_STOCK#,#INCOMING_STOCK#,#ACCOUNT_EXPORTREGISTERED#">
											<option value="#period_code_list#" <cfif period_code_list eq old_code_list or GET_PRODUCT_PERIODS.PRODUCT_PERIOD_CAT_ID eq PRO_CODE_CATID>selected</cfif>>#PRO_CODE_CAT_NAME#</option>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<label colspan="2" class="headbold font-red-sunglo col col-12" ><cf_get_lang dictionary_id='58811.Muhasebe Kodları'></label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37368.Satış Hesabı'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,1,'ACCOUNT_CODE')>
										<input type="text" name="account_code_sale" id="account_code_sale" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_code_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_code_sale','','3','200');"/>
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_code_sale');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37369.Alış Hesabı'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,2,'ACCOUNT_CODE_PUR')>
										<input type="text"  name="account_code_purchase" id="account_code_purchase" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_code_purchase','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_code_purchase','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"  onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_code_purchase');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60300.Giden Yoldaki Stok(Satış)'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,60,'OUTGOING_STOCK')>
										<input type="text" name="outgoing_stock" id="outgoing_stock" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('outgoing_stock','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_code_sale','','3','200');"/>
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','outgoing_stock');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60299.Gelen Yoldaki Stok(Alış)'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,61,'INCOMING_STOCK')>
										<input type="text"  name="incoming_stock" id="incoming_stock" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('incoming_stock','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_code_purchase','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"  onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','incoming_stock');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37459.Satış İskonto'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,3,'ACCOUNT_DISCOUNT')>
										<input type="text" name="account_discount" id="account_discount" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_discount','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_discount','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"  onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_discount');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37464.Alış İskonto'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,9,'ACCOUNT_DISCOUNT_PUR')>
										<input type="text"  name="account_discount_pur" id="account_discount_pur" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_discount_pur','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_discount_pur','','3','200');" />                      					
										<span class="input-group-addon btnPointer icon-ellipsis"  onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_discount_pur');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37462.Satış İade'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,7,'ACCOUNT_IADE')>
										<input type="text" name="account_iade" id="account_iade" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_iade','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"  onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_iade');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37461.Alış İade'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,6,'ACCOUNT_PUR_IADE')>
										<input type="text" name="account_pur_iade" id="account_pur_iade" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_pur_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_pur_iade','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"  onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_pur_iade');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37749.Satış Fiyat Farkı'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,4,'ACCOUNT_PRICE')>
										<input type="text" name="account_price" id="account_price" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('account_price','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_price','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_price');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37750.Alış Fiyat Farkı'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,5,'ACCOUNT_PRICE_PUR')>
										<input type="text" name="account_price_pur" id="account_price_pur" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_price_pur','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_price_pur','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_price_pur');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60998.İhraç Kayıtlı Satış'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,62,'ACCOUNT_EXPORTREGISTERED')>
										<input type="text" name="account_exportregistered" id="account_exportregistered" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_exportregistered','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_exportregistered','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_exportregistered');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37463.Yurtdışı Satış'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,8,'ACCOUNT_YURTDISI')>
										<input type="text" name="account_yurtdisi" id="account_yurtdisi" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_yurtdisi','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_yurtdisi','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_yurtdisi');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37465.Yurtdışı Alış'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,10,'ACCOUNT_YURTDISI_PUR')>
										<input type="text"  name="account_yurtdisi_pur" id="account_yurtdisi_pur" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_yurtdisi_pur','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_yurtdisi_pur','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_yurtdisi_pur');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37498.Hammadde'><cf_get_lang dictionary_id='57448.Satis'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,32,'MATERIAL_CODE_SALE')>
										<input type="text" name="material_code_sale" id="material_code_sale" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('material_code_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','material_code_sale','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','material_code_sale');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37498.Hammadde'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,18,'MATERIAL_CODE')>
										<input type="text" name="material_code" id="material_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('material_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','material_code','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"    onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','material_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37483.Fireler'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,11,'ACCOUNT_LOSS')>
										<input type="text" name="account_loss" id="account_loss" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_loss','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_loss','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_loss');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30009.Sarflar'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,12,'ACCOUNT_EXPENDITURE')>
										<input type="text"  name="account_expenditure" id="account_expenditure" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('account_expenditure','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','account_expenditure','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','account_expenditure');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57753.Sayım Fazlası'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,13,'OVER_COUNT')>
										<input type="text"  name="over_count" id="over_count" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('over_count','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','over_count','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','over_count');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57754.Sayım Eksiği'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,14,'UNDER_COUNT')>
										<input type="text"  name="under_count" id="under_count" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('under_count','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','under_count','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','under_count');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37458.Mamül'><cf_get_lang dictionary_id='57448.Satis'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,33,'PRODUCTION_COST_SALE')>
										<input type="text"  name="production_cost_sale" id="production_cost_sale" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('production_cost_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','production_cost_sale','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','production_cost_sale');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57456.Üretim'>/<cf_get_lang dictionary_id='37458.Mamül'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,15,'PRODUCTION_COST')>
										<input type="text"  name="production_cost" id="production_cost" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('production_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','production_cost','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','production_cost');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57456.Üretim'>/<cf_get_lang dictionary_id='37473.Yarı Mamül'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,16,'HALF_PRODUCTION_COST')>
										<input type="text"  name="half_production_cost" id="half_production_cost" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('half_production_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','half_production_cost','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"  onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','half_production_cost');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37474.Satılan Malın Maliyeti'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,17,'SALE_PRODUCT_COST')>
										<input type="text" name="sale_product_cost" id="sale_product_cost" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('sale_product_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','sale_product_cost','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','sale_product_cost');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59119.Satılan Mamülün Maliyeti"></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,30,'SALE_MANUFACTURED_COST')>
										<input type="text" name="sale_manufactured_cost" id="sale_manufactured_cost" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('sale_manufactured_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','sale_manufactured_cost','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','sale_manufactured_cost');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60403.Konsinye Alış Hesabı'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,19,'KONSINYE_PUR_CODE')>
										<input type="text" name="konsinye_pur_code" id="konsinye_pur_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('konsinye_pur_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','konsinye_pur_code','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','konsinye_pur_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37506.Diger Satış Hesabı'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,20,'KONSINYE_SALE_CODE')>
										<cf_wrk_account_codes form_name='add_period' account_code="KONSINYE_SALE_CODE" is_sub_acc='0' is_multi_no = '19'>
										<input type="text" name="konsinye_sale_code" id="konsinye_sale_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('konsinye_sale_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','konsinye_sale_code','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','konsinye_sale_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37508.Diger Satış Nazım Hesabı'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,21,'KONSINYE_SALE_NAZ_CODE')>
										<input type="text" name="konsinye_sale_naz_code" id="konsinye_sale_naz_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('konsinye_sale_naz_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','konsinye_sale_naz_code','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','konsinye_sale_naz_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37034.Alınan Hakediş Muhasebe Kodu'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,28,'RECEIVED_PROGRESS_CODE')>
										<input type="text"  name="get_received_code" id="get_received_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('get_received_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','get_received_code','','3','200');">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','get_received_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37036.Verilen Hakediş Muhasebe Kodu'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,29,'PROVIDED_PROGRESS_CODE')>
										<input type="text" name="get_provided_code" id="get_provided_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#" onfocus="AutoComplete_Create('get_provided_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','get_provided_code','','3','200');">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','get_provided_code');" ></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="37093.Hurda Hesabı"><cf_get_lang dictionary_id='57448.Satis'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,34,'SCRAP_CODE_SALE')>
										<input type="text" name="scrap_code_sale" id="scrap_code_sale" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('scrap_code_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','scrap_code_sale','','3','200');">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','scrap_code_sale');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="37093.Hurda Hesabı"></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,31,'SCRAP_CODE')>
									<input type="text" name="scrap_code" id="scrap_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('scrap_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','scrap_code','','3','200');">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','scrap_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37751.Direkt İlk Madde Malz Hesabı '></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,22,'DIMM_CODE')>
										<input type="text" name="dimm_code" id="dimm_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('dimm_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','dimm_code','','3','200');"/>
										<span class="input-group-addon btnPointer icon-ellipsis"  onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','dimm_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='37752.Direkt İlk Madde Malz Yans Hesabı '></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,23,'DIMM_YANS_CODE')>
										<input type="text" name="dimm_yans_code" id="dimm_yans_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('dimm_yans_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','dimm_yans_code','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','dimm_yans_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37559.Promosyon Hesabı'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,24,'PROMOTION_CODE')>
										<input type="text" name="promotion_code" id="promotion_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('promotion_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','promotion_code','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','promotion_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37019.Genel Üretim Giderleri Yansıtma Hesabı'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,26,'PROD_GENERAL_CODE')>
										<input type="text"  name="prod_general_code" id="prod_general_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('prod_general_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','prod_general_code','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','prod_general_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37033.Üretim İşçilik Yansıtma Hesabı'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,27,'PROD_LABOR_COST_CODE')>
										<input type="text" name="prod_labor_cost_code" id="prod_labor_cost_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('prod_labor_cost_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','prod_labor_cost_code','','3','200');">
										<span class="input-group-addon btnPointer icon-ellipsis"   onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','prod_labor_cost_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12" ><cf_get_lang dictionary_id='37047.Gider Dağılım'></label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37112.Gider Merkezi'></label>
								<div class="col col-8 col-xs-12">
									<cfif isDefined("get_product_periods.cost_expense_center_id") and  len(get_product_periods.cost_expense_center_id)>	
										<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
											SELECT EXPENSE_ID, EXPENSE, EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #get_product_periods.cost_expense_center_id#
										</cfquery>
										<cfset exp_name = get_expense_center.expense>
									<cfelse>
										<cfset exp_name = ''>	
									</cfif> 
									<div class="input-group">
										<input type="hidden" name="expense_center_gider" id="expense_center_gider" value="#get_product_periods.cost_expense_center_id#" />
										<input type="text" onChange="kontrol(1);" name="expense" id="expense"  value="<cfif isdefined("exp_name") and len(exp_name)>#exp_name#</cfif>"  />
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_period.expense_center_gider&field_name=add_period.expense&is_invoice=1','','ui-draggable-box-small'); kontrol(1);"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("get_product_periods.expense_item_id") and len(get_product_periods.expense_item_id)>
										<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
											SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 And EXPENSE_ITEM_ID = #get_product_periods.expense_item_id#
										</cfquery>
										<cfset item_name  = GET_EXPENSE_ITEM.expense_item_name>
									<cfelse>
										<cfset item_name  = ''>
									</cfif>	
									<div class="input-group">
										<input type="hidden" name="expense_item" id="expense_item" value="#get_product_periods.expense_item_id#" />
										<input type="text" onChange="kontrol(1);" name="expense_item_name" id="expense_item_name" value="<cfif isdefined("item_name") and len(item_name)> #item_name# </cfif>" />
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=add_period.expense_item&field_name=add_period.expense_item_name&is_expence=1','','ui-draggable-box-small'); kontrol(1);"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37218.Aktivite Tipi'></label>
								<div class="col col-8 col-xs-12">
									<select name="activity_type" id="activity_type"  onchange="kontrol(1);">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_activity_types">
											<option value="#activity_id#" title="#activity_name#"<cfif activity_id eq get_product_periods.activity_type_id>selected</cfif>>#activity_name#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58822.Masraf Şablonu'></label>
								<div class="col col-8 col-xs-12">
									<select name="expense_template" id="expense_template"  onchange="kontrol(2);">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_expense_template_expense">
											<option value="#template_id#" title="#template_name#"<cfif template_id eq get_product_periods.expense_template_id>selected</cfif>>#template_name#</option>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12" ><cf_get_lang dictionary_id='37236.Gelir Dağılım'></label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58172.Gelir Merkezi'></label>
								<div class="col col-8 col-xs-12">
									<cfif isDefined("get_product_periods.expense_center_id") and len(get_product_periods.expense_center_id)>
										<cfquery name="GET_EXPENSE_CENTER_INC" datasource="#dsn2#">
											SELECT EXPENSE_ID, EXPENSE, EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #get_product_periods.expense_center_id#
										</cfquery>
										<cfset inc_name  = get_expense_center_inc.expense>
									<cfelse>
										<cfset inc_name  = ''>
									</cfif>	
									<div class="input-group">
										<input type="hidden" name="expense_center" id="expense_center" value="#get_product_periods.expense_center_id#" />
										<input type="text" onChange="kontrol2(1);" name="expense1" id="expense1"  value="<cfif isdefined("inc_name") and len(inc_name)>#inc_name# </cfif>" />
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_period.expense_center&field_name=add_period.expense1&is_invoice=1','','ui-draggable-box-small');kontrol2(1);"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58173.Gelir Kalemi'></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("get_product_periods.income_item_id") and len(get_product_periods.income_item_id)>	
										<cfquery name="GET_EXPENSE_INCOME" datasource="#dsn2#">
											SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE INCOME_EXPENSE = 1 AND EXPENSE_ITEM_ID = #get_product_periods.income_item_id#
										</cfquery>
											<cfset income_name  = get_expense_income.expense_item_name>
									<cfelse>
										<cfset income_name  = ''>
									</cfif>	
									<div class="input-group">
										<input type="hidden" name="income_item" id="income_item" value="#get_product_periods.income_item_id#" />
										<input type="text" onChange="kontrol2(1);" name="expense_item_name1" id="expense_item_name1"  value="<cfif isdefined("income_name") and len(inc_name)>#income_name#</cfif>" />
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=add_period.income_item&field_name=add_period.expense_item_name1&is_income=1','','ui-draggable-box-small'); kontrol2(1);"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37218.Aktivite Tipi'></label>
								<div class="col col-8 col-xs-12">
									<select name="activity_type_income" id="activity_type_income"  onchange="kontrol2(1);">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_activity_types">
											<option value="#activity_id#" title="#activity_name#" <cfif activity_id eq get_product_periods.income_activity_type_id>selected</cfif>>#activity_name#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58823.Gelir Şablonu'></label>
								<div class="col col-8 col-xs-12">
									<select name="expense_template_income" id="expense_template_income"  onchange="kontrol2(2);">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_expense_template_income">
											<option value="#template_id#" title="#template_name#"<cfif template_id eq get_product_periods.income_template_id>selected</cfif>>#template_name#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12" ><cf_get_lang dictionary_id='58478.Sabit Kıymet'></label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
								<div class="col col-8 col-xs-12">
									<cfif len(get_product_periods.INVENTORY_CAT_ID)>
										<cfquery name="GET_INV_CAT" datasource="#dsn3#">
											SELECT INVENTORY_CAT FROM SETUP_INVENTORY_CAT WHERE INVENTORY_CAT_ID = #get_product_periods.INVENTORY_CAT_ID#
										</cfquery>
										<cfset inv_cat = GET_INV_CAT.INVENTORY_CAT>
									<cfelse>
										<cfset inv_cat = "">
									</cfif>
									<div class="input-group">
										<input type="hidden" name="inventory_cat_id" id="inventory_cat_id" value="#get_product_periods.INVENTORY_CAT_ID#" />
										<input type="text" name="inventory_cat" id="inventory_cat" value="<cfif len(inv_cat)>#inv_cat#</cfif>"  />
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_inventory_cat&field_id=add_period.inventory_cat_id&field_name=add_period.inventory_cat','','ui-draggable-box-small');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,25,'INVENTORY_CODE')>
										<input type="text" name="inventory_code" id="inventory_code" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('inventory_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','inventory_code','','3','200');" />
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','inventory_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></label>
								<div class="col col-8 col-xs-12">
									<select name="amortization_method_id" id="amortization_method_id" >
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="0" <cfif get_product_periods.amortization_method_id eq 0>selected</cfif>><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'></option>
										<option value="1" <cfif get_product_periods.amortization_method_id eq 1>selected</cfif>><cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'></option>
										<option value="2" <cfif get_product_periods.amortization_method_id eq 2>selected</cfif>><cf_get_lang dictionary_id='29423.Hızlandırılmış Azalan Bakiye'></option>
										<option value="3" <cfif get_product_periods.amortization_method_id eq 3>selected</cfif>><cf_get_lang dictionary_id='29424.Hızlandırılmış Sabit Değer'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29425.Amortisman Türü'></label>
								<div class="col col-8 col-xs-12">
									<select name="amortization_type_id" id="amortization_type_id" >
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="1" <cfif get_product_periods.amortization_type_id eq 1>selected</cfif>><cf_get_lang dictionary_id='29426.Kıst Amortismana Tabi'></option>
										<option value="2" <cfif get_product_periods.amortization_type_id eq 2>selected</cfif>><cf_get_lang dictionary_id='29427.Kıst Amortismana Tabi Değil'></option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
								<div class="col col-8 col-xs-12">
									<select name="amortization_exp_center_id" id="amortization_exp_center_id" >
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_expense_center2">
											<option value="#expense_id#" <cfif get_expense_center2.expense_id eq get_product_periods.AMORTIZATION_EXP_CENTER_ID>selected</cfif>>
												<cfloop from="2" to="#ListLen(EXPENSE_CODE,".")#" index="i">
													&nbsp;&nbsp;
												</cfloop>
												#expense#
											</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
								<div class="col col-8 col-xs-12">
									<select name="amortization_exp_item_id" id="amortization_exp_item_id" >
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_expense_item1">
											<option value="#expense_item_id#" title="#expense_item_name#" <cfif get_expense_item1.expense_item_id eq get_product_periods.amortization_exp_item_id>selected</cfif>>#expense_item_name#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58298.Birikmiş Amortisman'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="text" name="amortization_code" id="amortization_code" value="#get_product_periods.amortization_code#" >
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','amortization_code');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12" ><cf_get_lang dictionary_id='57639.KDV'></label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37631.Alış KDV'></label>
								<div class="col col-8 col-xs-12">
									<cfinclude template="../query/get_kdv.cfm">
									<select name="tax_purchase" id="tax_purchase" >
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_kdv">
											<option value="#tax#" <cfif isdefined("get_product_tax") and get_product_tax.tax_purchase eq tax>selected</cfif>>#tax#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37916.Satış KDV'></label>
								<div class="col col-8 col-xs-12">
									<select name="tax" id="tax" >
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_kdv">
											<option value="#tax#" <cfif isdefined("get_product_tax") and get_product_tax.tax eq tax>selected</cfif>>#get_kdv.tax#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group">
								<cfinclude template="../query/get_otv.cfm">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58021.ÖTV'></label>
								<div class="col col-8 col-xs-12">
									<select name="OTV" id="OTV" >
										<option value=""><cf_get_lang dictionary_id='58546.Yok'></option>
										<cfloop query="get_otv">
											<option value="#tax#" <cfif isdefined("get_product_tax") and get_product_tax.otv eq tax>selected</cfif>>#tax#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<!--- e-fatura kullanılıyorsa ve xml setuptan vergi kodu gösterilsin seçildi ise --->
							<cfif is_taxcode eq 1 and session.ep.our_company_info.is_efatura>
								<cfinclude template="../../objects/query/tax_type_code.cfm">
								<div class="form-group">
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30006.Vergi Kodu'>/<cf_get_lang dictionary_id='57639.KDV'></label>
									<div class="col col-4 col-xs-12">
										<select name="tax_code" id="tax_code" >
											<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
											<cfloop query="TAX_CODES">
												<option value="#tax_code_id#;#tax_code_name#" title="#detail#" <cfif get_product_periods.tax_code eq tax_codes.tax_code_id>selected="selected"</cfif>>#tax_code_name#</option>
											</cfloop>
										</select>
									</div>
									<div class="col col-4">
										<select name="tax_code2" id="tax_code2" >
											<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
											<cfloop query="get_kdv">
												<option value="#tax#" <cfif get_product_periods.tax eq tax>selected</cfif>>#tax#</option>
											</cfloop>
										</select>
									</div>
								</div>
							</cfif>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="36834.KDV'den Muaf Satış Faturası"></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,35,'EXE_VAT_SALE_INVOICE')>
										<input type="text"  name="exe_vat_sale_invoice" id="exe_vat_sale_invoice" value="#acc_inf.acc_code#" title="#acc_inf.acc_name#"  onfocus="AutoComplete_Create('exe_vat_sale_invoice','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','exe_vat_sale_invoice');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12" ><cf_get_lang dictionary_id='43458.İstisna Kodu'></label>
							</div>
							<!--- İstisna --->
							<cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#reason_codes.xml" variable="xmldosyam" charset = "UTF-8">
							<cfset dosyam = XmlParse(xmldosyam)>
							<cfset xml_dizi = dosyam.REASON_CODES.XmlChildren>
							<cfset d_boyut = ArrayLen(xml_dizi)>
							<cfset reason_code_list = "">
							<cfloop index="abc" from="1" to="#d_boyut#">    	
								<cfset reason_code_list = listappend(reason_code_list,'#dosyam.REASON_CODES.REASONS[abc].REASONS_CODE.XmlText#--#dosyam.REASON_CODES.REASONS[abc].REASONS_NAME.XmlText#','*')>
							</cfloop>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43458.İstisna Kodu'></label>
								<div class="col col-8 col-xs-12">
									<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,35,'REASON_CODE')>
									<select name="reason_code" id="reason_code">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop list="#reason_code_list#" index="info_list" delimiters="*">
											<option value="#info_list#" <cfif get_product_periods.reason_code eq info_list>selected</cfif>>#info_list#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<!--- İstisna --->
							<div class="form-group">
								<label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12" ><cf_get_lang dictionary_id='57641.İskonto'><cf_get_lang dictionary_id='54118.Gider Dağılım'></label>
							</div>
							<cfif isDefined("get_product_periods.discount_expense_center_id") and  len(get_product_periods.discount_expense_center_id)>	
								<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
									SELECT EXPENSE_ID, EXPENSE, EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #get_product_periods.discount_expense_center_id#
								</cfquery>
								<cfset exp_name = get_expense_center.expense>
							<cfelse>
								<cfset exp_name = ''>	
							</cfif> 
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37112.Gider Merkezi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="discount_expense_center" id="discount_expense_center" value="#get_product_periods.discount_expense_center_id#" />
										<input type="text" onChange="kontrol(1);" name="discount_expense_center_name" id="discount_expense_center_name"  value="<cfif isdefined("exp_name") and len(exp_name)>#exp_name#</cfif>"/>
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=add_period.discount_expense_center&field_name=add_period.discount_expense_center_name&is_invoice=1','','ui-draggable-box-small'); kontrol(1);"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
								<div class="col col-8 col-xs-12">
									<cfif isdefined("get_product_periods.discount_expense_item_id") and len(get_product_periods.discount_expense_item_id)>
										<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
											SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 And EXPENSE_ITEM_ID = #get_product_periods.discount_expense_item_id#
										</cfquery>
										<cfset item_name  = GET_EXPENSE_ITEM.expense_item_name>
									<cfelse>
										<cfset item_name  = ''>
									</cfif>	
									<div class="input-group">
										<input type="hidden" name="discount_expense_item" id="discount_expense_item" value="#get_product_periods.discount_expense_item_id#" />
										<input type="text" onChange="kontrol(1);" name="discount_expense_item_name" id="discount_expense_item_name" value="<cfif isdefined("item_name") and len(item_name)> #item_name# </cfif>" />
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=add_period.discount_expense_item&field_name=add_period.discount_expense_item_name&is_expence=1','','ui-draggable-box-small'); kontrol(1);"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37218.Aktivite Tipi'><cf_get_lang dictionary_id='57448.Satis'></label>
								<div class="col col-8 col-xs-12">
									<select name="discount_activity_type" id="discount_activity_type"  onchange="kontrol(1);">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfloop query="get_activity_types">
											<option value="#activity_id#" title="#activity_name#"<cfif activity_id eq get_product_periods.discount_activity_type_id>selected</cfif>>#activity_name#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12" ><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54531.Ödeme Yöntemi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif len(GET_PRODUCT_PERIODS.purchase_paymethod_id)>
											<cfquery name="GET_PURCHASE_PAYMETHOD" datasource="#dsn#">
												SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PRODUCT_PERIODS.purchase_paymethod_id#">
											</cfquery>
										</cfif>
										<input type="hidden" name="purchase_paymethod_id" id="purchase_paymethod_id" value="<cfif isDefined("GET_PURCHASE_PAYMETHOD") and len(GET_PRODUCT_PERIODS.purchase_paymethod_id)>#GET_PRODUCT_PERIODS.purchase_paymethod_id#</cfif>">
										<input type="text" name="purchase_paymethod" id="purchase_paymethod" value="<cfif isdefined("GET_PURCHASE_PAYMETHOD")>#GET_PURCHASE_PAYMETHOD.PAYMETHOD#</cfif>">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_period.purchase_paymethod_id&field_name=add_period.purchase_paymethod</cfoutput>','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54532.Satış Ödeme Yöntemi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif len(GET_PRODUCT_PERIODS.sales_paymethod_id)>
											<cfquery name="GET_SALES_PAYMETHOD" datasource="#dsn#">
												SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PRODUCT_PERIODS.sales_paymethod_id#">
											</cfquery>
										</cfif>
										<input type="hidden" name="sales_paymethod_id" id="sales_paymethod_id" value="<cfif isDefined("GET_SALES_PAYMETHOD") and len(GET_PRODUCT_PERIODS.sales_paymethod_id)>#GET_PRODUCT_PERIODS.sales_paymethod_id#</cfif>">
										<input type="text" name="sales_paymethod" id="sales_paymethod" value="<cfif isdefined("GET_SALES_PAYMETHOD")>#GET_SALES_PAYMETHOD.PAYMETHOD#</cfif>">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=add_period.sales_paymethod_id&field_name=add_period.sales_paymethod</cfoutput>','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12" ><cf_get_lang dictionary_id="41029.Tahakkuk İşlem Hesapları"></label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60404.Tahakkuk Gelir Kalemi'></label>
								<div class="col col-8 col-xs-12">
									<cfif isDefined("get_product_periods.accrual_income_item_id") and  len(get_product_periods.accrual_income_item_id)>	
										<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
											SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 0 And EXPENSE_ITEM_ID = #get_product_periods.accrual_income_item_id#
										</cfquery>
										<cfset item_name  = GET_EXPENSE_ITEM.expense_item_name>
									<cfelse>
										<cfset item_name  = ''>
									</cfif>
									<div class="input-group">
										<input type="hidden" name="accrual_income_item_id" id="accrual_income_item_id" value="#get_product_periods.accrual_income_item_id#" />
										<input type="text" name="accrual_income_item_name" id="accrual_income_item_name"  value="#item_name#"/>
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=add_period.accrual_income_item_id&field_name=add_period.accrual_income_item_name&is_income=1','','ui-draggable-box-small');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41055.Tahakkuk Gider Kalemi'></label>
								<div class="col col-8 col-xs-12">
									<cfif isDefined("get_product_periods.accrual_expense_item_id") and  len(get_product_periods.accrual_expense_item_id)>	
										<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
											SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 And EXPENSE_ITEM_ID = #get_product_periods.accrual_expense_item_id#
										</cfquery>
										<cfset item_name  = GET_EXPENSE_ITEM.expense_item_name>
									<cfelse>
										<cfset item_name  = ''>
									</cfif>
									<div class="input-group">
										<input type="hidden" name="accrual_expense_item_id" id="accrual_expense_item_id" value="#get_product_periods.accrual_expense_item_id#" />
										<input type="text" name="accrual_expense_item_name" id="accrual_expense_item_name"  value="#item_name#"/>
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=add_period.accrual_expense_item_id&field_name=add_period.accrual_expense_item_name&is_expence=1','','ui-draggable-box-small');"></span>
									</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41024.Gelecek Aylara Ait Gelirler Muhasebe Kodu"></label>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,36,'NEXT_MONTH_INCOMES_ACC_CODE')>
										<input type="text" name="next_month_incomes_acc_code" id="next_month_incomes_acc_code" value="#acc_inf.acc_code#" onfocus="AutoComplete_Create('next_month_incomes_acc_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
										<span class="input-group-addon icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','next_month_incomes_acc_code',1);"></span>
									</div>
								</div>
								<div class="col col-4 col-xs-12">
									<input type="text" name="next_month_incomes_acc_key" id="next_month_incomes_acc_key" value="#get_product_periods.next_month_incomes_acc_key#" placeholder = "#getLang('','Tahakkuk Anahtarı',63063)#">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41021.Gelecek Yıllara Ait Gelirler Muhasebe Kodu"></label>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,37,'NEXT_YEAR_INCOMES_ACC_CODE')>
										<input type="text" name="next_year_incomes_acc_code" id="next_year_incomes_acc_code" value="#acc_inf.acc_code#" onfocus="AutoComplete_Create('next_year_incomes_acc_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','next_year_incomes_acc_code',1);"></span>
									</div>
								</div>
								<div class="col col-4 col-xs-12">
									<input type="text" name="next_year_incomes_acc_key" id="next_year_incomes_acc_key" value="#get_product_periods.next_year_incomes_acc_key#" placeholder = "#getLang('','Tahakkuk Anahtarı',63063)#">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41020.Gelecek Aylara Ait Giderler Muhasebe Kodu"></label>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,38,'NEXT_MONTH_EXPENSES_ACC_CODE')>
										<input type="text" name="next_month_expenses_acc_code" id="next_month_expenses_acc_code" value="#acc_inf.acc_code#" onfocus="AutoComplete_Create('next_month_expenses_acc_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','next_month_expenses_acc_code',1);"></span>
									</div>
								</div>
								<div class="col col-4 col-xs-12">
									<input type="text" name="next_month_expenses_acc_key" id="next_month_expenses_acc_key" value="#get_product_periods.next_month_expenses_acc_key#" placeholder = "#getLang('','Tahakkuk Anahtarı',63063)#">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="41022.Gelecek Yıllara Ait Giderler Muhasebe Kodu"></label>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<cfset new_struct = get_account_code(attributes.PID,PERIOD_ID,39,'NEXT_YEAR_EXPENSES_ACC_CODE')>
										<input type="text" name="next_year_expenses_acc_code" id="next_year_expenses_acc_code" value="#acc_inf.acc_code#" onfocus="AutoComplete_Create('next_year_expenses_acc_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('#PERIOD_YEAR#','#OUR_COMPANY_ID#','next_year_expenses_acc_code',1);"></span>
									</div>
								</div>
								<div class="col col-4 col-xs-12">
									<input type="text" name="next_year_expenses_acc_key" id="next_year_expenses_acc_key" value="#get_product_periods.next_year_expenses_acc_key#" placeholder = "#getLang('','Tahakkuk Anahtarı',63063)#">
								</div>
							</div>
							<div class="form-group">
								<label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id="41025.Tahakkuk Ay Sayısı"></label>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58793.Tek Düzen">:</label>
								<div class="col col-4 col-xs-12">
									<input type="number" name="accrual_month" id="accrual_month" value="#get_product_periods.accrual_month#">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58308.IFRS">:</label>
								<div class="col col-4 col-xs-12">
									<input type="number" name="accrual_month_ifrs" id="accrual_month_ifrs" value="#get_product_periods.accrual_month_ifrs#">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57559.Bütçe'>:</label>
								<div class="col col-4 col-xs-12">
									<input type="number" name="accrual_month_budget" id="accrual_month_budget" value="#get_product_periods.accrual_month_budget#">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id="41023.İlk 12 Ayı Gelecek Aylara Dağıt"></label>
								<div class="col col-2 col-xs-12">
									<cf_get_lang dictionary_id='58793.Tek Düzen'>
									<input type="checkbox" name="first_12_to_month" id="first_12_to_month" value="1" <cfif get_product_periods.first_12_to_month eq 1>checked</cfif>>
								</div>
								<div class="col col-2 col-xs-12">
									<cf_get_lang dictionary_id='58308.UFRS'> 
									<input type="checkbox" name="first_12_to_month_ifrs" id="first_12_to_month_ifrs" value="1" <cfif get_product_periods.first_12_to_month_ifrs eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='60405.Tahakkuk İşleminde Başlangıç Tarihini Ürün Teslim Tarihinden Al'></label>
								<div class="col col-2 col-xs-12">
									<cf_get_lang dictionary_id='58793.Tek Düzen'>
									<input type="checkbox" name="start_from_delivery_date" id="start_from_delivery_date" value="1" <cfif get_product_periods.start_from_delivery_date eq 1>checked</cfif>>
								</div>
								<div class="col col-2 col-xs-12">
									<cf_get_lang dictionary_id='58308.UFRS'>
									<input type="checkbox" name="start_from_delivery_date_ifrs" id="start_from_delivery_date_ifrs" value="1" <cfif get_product_periods.start_from_delivery_date_ifrs eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='60406.Tahakkuk İşlemini Mali Yıl Sonuna Kadar Yap'></label>
								<div class="col col-2 col-xs-12">
									<cf_get_lang dictionary_id='58793.Tek Düzen'>
									<input type="checkbox" name="distribute_to_fiscal_end" id="distribute_to_fiscal_end" value="1" <cfif get_product_periods.distribute_to_fiscal_end eq 1>checked</cfif>>
								</div>
								<div class="col col-2 col-xs-12">
									<cf_get_lang dictionary_id='58308.UFRS'>
									<input type="checkbox" name="distribute_to_fiscal_end_ifrs" id="distribute_to_fiscal_end_ifrs" value="1" <cfif get_product_periods.distribute_to_fiscal_end_ifrs eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='60407.Tahakkuk İşlemini Gün Bazında Yap'></label>
								<div class="col col-2 col-xs-12">
									<cf_get_lang dictionary_id='58793.Tek Düzen'>
									<input type="checkbox" name="distribute_day_based" id="distribute_day_based" value="1" <cfif get_product_periods.distribute_day_based eq 1>checked</cfif>>
								</div>
								<div class="col col-2 col-xs-12">
									<cf_get_lang dictionary_id='58308.UFRS'>
									<input type="checkbox" name="distribute_day_based_ifrs" id="distribute_day_based_ifrs" value="1" <cfif get_product_periods.distribute_day_based_ifrs eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-8 col-xs-12"><cf_get_lang dictionary_id='61003.Geçmiş Ayların Dağıtım Tutarını İlk Aya Ekle'></label>
								<div class="col col-2 col-xs-12">
									<cf_get_lang dictionary_id='58793.Tek Düzen'>
									<input type="checkbox" name="past_months_to_first" id="past_months_to_first" value="1" <cfif get_product_periods.past_months_to_first eq 1>checked</cfif>>
								</div>
								<div class="col col-2 col-xs-12">
									<cf_get_lang dictionary_id='58308.UFRS'>
									<input type="checkbox" name="past_months_to_first_ifrs" id="past_months_to_first_ifrs" value="1" <cfif get_product_periods.past_months_to_first_ifrs eq 1>checked</cfif>>
								</div>
							</div>
						</div>
					</cfoutput>
				</cfif>		
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6">
					<cfoutput>
						<cfif len(GET_PRODUCT_PERIODS.RECORD_EMP)>
							<cf_record_info query_name="GET_PRODUCT_PERIODS" >
						</cfif>
					</cfoutput>
				</div>
				<div class="col col-6">
					<cf_workcube_buttons type_format='1' is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("control_wrk() && loadPopupBox('add_period' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
	<script type="text/javascript">
		function pencere_ac(period,company,isim)
		{
			temp_account_code = eval('document.add_period.'+isim);
			if (temp_account_code.value.length >= 3)
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan_all&db_source='+company+'&PERIOD_YEAR='+period+'&field_id=add_period.'+isim+'&account_code=' + temp_account_code.value+'&is_title=1'</cfoutput>, 'list');
			else
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan_all&db_source='+company+'&PERIOD_YEAR='+period+'&field_id=add_period.'+isim+'&is_title=1'</cfoutput>, 'list');
		}
		function kontrol(degerid)
		{
			if(degerid == 1)
			{
				document.getElementById("expense_template").selectedIndex = 0;
			}
			else
			{
				document.getElementById("expense_center_gider").value = "";
				document.getElementById("expense").value="";
				document.getElementById("expense_item").value="";
				document.getElementById("expense_item_name").value="";
				document.getElementById("activity_type").selectedIndex = 0;
			}
		}
		function cat_kontrol()
		{
			degerler = document.getElementById("period_code_cat").value.split(',');//hepsi için list_getat kullanmaktansa bir kere split yapıyoruz...
			if(degerler != '')
			{
				document.getElementById("product_period_cat_id").value=degerler[0];
				document.getElementById("account_code_sale").value=degerler[1];
				document.getElementById("account_code_purchase").value=degerler[2];
				document.getElementById("account_discount").value=degerler[3];
				document.getElementById("account_price").value=degerler[4];
				document.getElementById("account_price_pur").value=degerler[5];
				document.getElementById("account_pur_iade").value=degerler[6];
				document.getElementById("account_iade").value=degerler[7];
				document.getElementById("account_yurtdisi").value=degerler[8];
				document.getElementById("account_yurtdisi_pur").value=degerler[9];
				document.getElementById("account_discount_pur").value=degerler[10];
				document.getElementById("account_loss").value=degerler[11];
				document.getElementById("account_expenditure").value=degerler[12];
				document.getElementById("over_count").value=degerler[13];
				document.getElementById("under_count").value=degerler[14];
				document.getElementById("production_cost").value=degerler[15];
				document.getElementById("half_production_cost").value=degerler[16];
				document.getElementById("sale_product_cost").value=degerler[17];
				document.getElementById("material_code").value=degerler[18];	
				document.getElementById("konsinye_pur_code").value=degerler[19];	
				document.getElementById("konsinye_sale_code").value=degerler[20];	
				document.getElementById("konsinye_sale_naz_code").value=degerler[21];	
				document.getElementById("dimm_code").value=degerler[22];	
				document.getElementById("dimm_yans_code").value=degerler[23];	
				document.getElementById("promotion_code").value=degerler[24];	
				document.getElementById("prod_general_code").value=degerler[40];	
				document.getElementById("prod_labor_cost_code").value=degerler[41];	
				if(degerler[42] != undefined)
				document.getElementById("get_received_code").value=degerler[42];	
				if(degerler[43] != undefined)
				document.getElementById("get_provided_code").value=degerler[43];	
				document.getElementById("expense_center_gider").value=degerler[25];	
				document.getElementById("expense_item").value=degerler[26];	
				document.getElementById("activity_type").value=degerler[27];	
				document.getElementById("expense_template").value=degerler[28];	
				document.getElementById("expense_center").value=degerler[29];
				document.getElementById("income_item").value=degerler[30];	
				document.getElementById("activity_type_income").value=degerler[31];	
				document.getElementById("expense_template_income").value=degerler[32];	
				document.getElementById("inventory_cat_id").value=degerler[33];
				if(degerler[33] != "")
				{
					var get_inv_info = wrk_safe_query('prd_get_inv_info','dsn3',0,degerler[33]);
					document.getElementById("inventory_cat").value=get_inv_info.INVENTORY_CAT;
				}
				else 
					document.getElementById("inventory_cat").value="";		
				document.getElementById("inventory_code").value=degerler[34];
				document.getElementById("amortization_method_id").value=degerler[35];
				document.getElementById("amortization_type_id").value=degerler[36];
				document.getElementById("amortization_exp_center_id").value=degerler[37];
				document.getElementById("amortization_exp_item_id").value=degerler[38];
				document.getElementById("amortization_code").value=degerler[39];
				document.getElementById("sale_manufactured_cost").value=degerler[44];
				document.getElementById("material_code_sale").value=degerler[45];
				document.getElementById("production_cost_sale").value=degerler[46];
				document.getElementById("scrap_code_sale").value=degerler[47];
				document.getElementById("scrap_code").value=degerler[48];
				document.getElementById("exe_vat_sale_invoice").value=degerler[49];
				document.getElementById("expense").value=degerler[50];
				document.getElementById("expense_item_name").value=degerler[51];
				document.getElementById("expense1").value=degerler[52];
				document.getElementById("expense_item_name1").value=degerler[53];
				document.getElementById("discount_expense_center").value=degerler[54];
				document.getElementById("discount_expense_center_name").value=degerler[55];
				document.getElementById("discount_expense_item").value=degerler[56];
				document.getElementById("discount_expense_item_name").value=degerler[57];
				document.getElementById("discount_activity_type").value=degerler[58];
				document.getElementById("reason_code").value=degerler[59];
				document.getElementById("outgoing_stock").value=degerler[60];
				document.getElementById("incoming_stock").value=degerler[61];
				document.getElementById("account_exportregistered").value=degerler[62];
			}
			else
			{
				document.getElementById("product_period_cat_id").value='';
				document.getElementById("account_code_sale").value='';
				document.getElementById("account_code_purchase").value='';
				document.getElementById("account_discount").value='';
				document.getElementById("account_price").value='';
				document.getElementById("account_price_pur").value='';
				document.getElementById("account_pur_iade").value='';
				document.getElementById("account_iade").value='';
				document.getElementById("account_yurtdisi").value='';
				document.getElementById("account_yurtdisi_pur").value='';
				document.getElementById("account_discount_pur").value='';
				document.getElementById("account_loss").value='';
				document.getElementById("account_expenditure").value='';
				document.getElementById("over_count").value='';
				document.getElementById("under_count").value='';
				document.getElementById("production_cost").value='';
				document.getElementById("half_production_cost").value='';
				document.getElementById("sale_product_cost").value='';
				document.getElementById("material_code").value='';
				document.getElementById("konsinye_pur_code").value='';
				document.getElementById("konsinye_sale_code").value='';
				document.getElementById("konsinye_sale_naz_code").value='';
				document.getElementById("dimm_code").value='';
				document.getElementById("dimm_yans_code").value='';
				document.getElementById("promotion_code").value='';	
				document.getElementById("prod_general_code").value='';	
				document.getElementById("prod_labor_cost_code").value='';	
				document.getElementById("get_received_code").value='';
				document.getElementById("get_provided_code").value='';	
				document.getElementById("expense_center_gider").value='';
				document.getElementById("expense_item").value='';
				document.getElementById("activity_type").value='';
				document.getElementById("expense_template").value='';
				document.getElementById("expense_center").value='';	
				document.getElementById("income_item").value='';	
				document.getElementById("activity_type_income").value='';
				document.getElementById("expense_template_income").value='';
				document.getElementById("inventory_cat_id").value='';
				document.getElementById("inventory_cat").value='';	
				document.getElementById("inventory_code").value='';
				document.getElementById("amortization_method_id").value='';
				document.getElementById("amortization_type_id").value='';
				document.getElementById("amortization_exp_center_id").value='';
				document.getElementById("amortization_exp_item_id").value='';
				document.getElementById("amortization_code").value='';
				document.getElementById("sale_manufactured_cost").value='';
				document.getElementById("material_code_sale").value='';
				document.getElementById("production_cost_sale").value='';
				document.getElementById("scrap_code_sale").value='';
				document.getElementById("scrap_code").value='';
				document.getElementById("exe_vat_sale_invoice").value='';
				document.getElementById("discount_expense_center").value='';
				document.getElementById("discount_expense_center_name").value='';
				document.getElementById("discount_expense_item").value='';
				document.getElementById("discount_expense_item_name").value='';
				document.getElementById("discount_activity_type").value='';
				document.getElementById("reason_code").value='';
				document.getElementById("outgoing_stock").value='';
				document.getElementById("incoming_stock").value='';
				document.getElementById("account_exportregistered").value='';
			}
		}
		function kontrol2(degerid)
		{
			if(degerid == 1)
			{
				document.getElementById("expense_template_income").selectedIndex = 0;
			}
			else
			{
				document.getElementById("expense_center").value = "";
				document.getElementById("expense1").value = "";
				document.getElementById("income_item").value = "";
				document.getElementById("expense_item_name1").value = "";
				document.getElementById("activity_type_income").selectedIndex = 0;
			}
		}
		function control_wrk()
		{
			var Dizi = new Array();	
			Dizi[0]= new Array ('account_code_sale','Satış Hesabı Kayıtlı Değildir.')
			Dizi[1]= new Array ('account_code_purchase','Alış Hesabı Kayıtlı Değildir.')
			Dizi[2]= new Array ('account_discount','Satış İskonto Kayıtlı Değildir.')
			Dizi[3]= new Array ('account_price','Satış Fiyat Farkı Kayıtlı Değildir.')
			Dizi[4]= new Array ('account_price_pur','Alış Fiyat Farkı Kayıtlı Değildir.')
			Dizi[5]= new Array ('account_pur_iade','Alış İade Kayıtlı Değildir.')
			Dizi[6]= new Array ('account_iade','Satış İade Kayıtlı Değildir.')
			Dizi[7]= new Array ('account_yurtdisi','Yurtdışı Satış Kayıtlı Değildir.')
			Dizi[8]= new Array ('account_yurtdisi_pur','Yurtdışı Alış Kayıtlı Değildir.')
			Dizi[9]= new Array ('account_discount_pur','Alış İskonto Kayıtlı Değildir.')
			Dizi[10]= new Array ('account_loss','Fireler Kayıtlı Değildir.')
			Dizi[11]= new Array ('account_expenditure','Sarflar Kayıtlı Değildir.')
			Dizi[12]= new Array ('over_count','Sayım Fazlası Kayıtlı Değildir.')
			Dizi[13]= new Array ('under_count','Sayım Eksiği Kayıtlı Değildir.')
			Dizi[14]= new Array ('production_cost','Üretim Kayıtlı Değildir.')
			Dizi[15]= new Array ('half_production_cost','Yarı Mamül Kayıtlı Değildir.')
			Dizi[16]= new Array ('sale_product_cost','Satılan Malın Maliyeti Kayıtlı Değildir.')
			Dizi[17]= new Array ('material_code','Hammadde Kayıtlı Değildir.')
			Dizi[18]= new Array ('konsinye_pur_code','Konsinye Alış Hesabı Kayıtlı Değildir.')
			Dizi[19]= new Array ('konsinye_sale_code','Konsinye Satış Hesabı Kayıtlı Değildir.')
			Dizi[20]= new Array ('konsinye_sale_naz_code','Konsinye Satış Nazım Hesabı Kayıtlı Değildir.')
			Dizi[21]= new Array ('dimm_code','D.İ.Mad. Malz. Hesabı Kayıtlı Değildir.')
			Dizi[22]= new Array ('dimm_yans_code','D.İ.Mad. Malz. Yans. Hesabı Kayıtlı Değildir.')
			Dizi[23]= new Array ('promotion_code','Promosyon Hesabı Kayıtlı Değildir.')
			Dizi[24]= new Array ('inventory_code','Sabit Kıymet Hesabı Kayıtlı Değildir.')
			Dizi[25]= new Array ('prod_general_code','Genel Üretim Giderleri Yansıtma Hesabı Kayıtlı Değildir.')
			Dizi[26]= new Array ('prod_labor_cost_code','Üretim İşçilik Yansıtma Hesabı Kayıtlı Değildir.')
			Dizi[27]= new Array('get_received_code','Alınan Hakediş Yansıtma Hesabı Kayıtlı Değildir.')
			Dizi[28]= new Array('get_provided_code','Verilen Hakediş Yansıtma Hesabı Kayıtlı Değildir.')
			Dizi[29]= new Array('sale_manufactured_cost','Satılan Mamulun Maliyeti Hesabı Kayıtlı Değildir.')
			Dizi[30]= new Array('material_code_sale','Hammadde Satış Hesabı Kayıtlı Değildir.')
			Dizi[31]= new Array('production_cost_sale','Mamul Satış Hesabı Kayıtlı Değildir.')
			Dizi[32]= new Array('scrap_code_sale','Hurda Satış Hesabı Kayıtlı Değildir.')
			Dizi[33]= new Array('scrap_code','Hurda Hesabı Kayıtlı Değildir.')
			for(i=0;i<=33;i++)
			{
				var my_value = document.getElementById(Dizi[i][0]).value;
				if(my_value != "")
				{ 
					if(WrkAccountControl(my_value,Dizi[i][1]) == 0)
					{
						return false;
						break;
					}	
				}	
			}
			return true;
		}
	</script>
	