<cfset product_id_list = ''>
<cfinclude template="../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfset order = createObject("component","V16.objects2.sale.cfc.order")>

<cfset attributes.order_id = attributes.param_2>
<cfset GET_BANK_INFO = order.GET_BANK_INFO(order_id : attributes.order_id)>
<cfset GET_MONEY_CREDITS = order.GET_MONEY_CREDITS(order_id : attributes.order_id)>
<cfset GET_ORDER_LIST = order.GET_ORDER_LIST(order_id : attributes.order_id, zone : attributes.is_sales_zone)>
<cfset GET_PARTNER = order.GET_PARTNER(partner_id_list : GET_ORDER_LIST.PARTNER_ID)>


<cfif isdefined("session.ww.userid")>
	<cfset GET_CONS_REF_CODE = order.GET_CONS_REF_CODE(user_id : session.ww.userid)>
	<cfset GET_CAMP_ID = order.GET_CAMP_ID()>
	
	<cfif get_camp_id.recordcount>
		<cfset GET_LEVEL = order.GET_LEVEL(consumer_cat_id : get_cons_ref_code.consumer_cat_id, camp_id : get_camp.camp_id)>
		<cfset ref_count = get_level.pre_level + listlen(get_cons_ref_code.consumer_reference_code,'.')>
	<cfelse>
		<cfset ref_count = 0>
	</cfif>
	<cfset GET_REF_MEMBER = order.GET_REF_MEMBER(user_id : session.ww.userid, ref_count : ref_count)>
	<cfset list_ref_member = ''>
	<cfoutput query="get_ref_member">
		<cfif len(consumer_id) and not listfind(list_ref_member,consumer_id)>
			<cfset list_ref_member = Listappend(list_ref_member,consumer_id)>
		</cfif>
	</cfoutput>
</cfif>
<cfinclude template="../query/get_order_det.cfm">
<!--- SipariS iptal edilebilsin secenegi secilmisse bagli fatura kontrol ediliyor --->
<cfset control_cancel = 0>
<cfif isdefined("attributes.is_order_cancel") and attributes.is_order_cancel eq 1>
	<cfset GET_INVOICE_DET = order.GET_INVOICE_DET(order_id: attributes.order_id)>

	<cfif get_invoice_det.recordcount>
		<cfset GET_PRINT_COUNT = order.GET_PRINT_COUNT(invoice_id : get_invoice_det.invoice_id)>
		<cfif get_print_count.print_count gt 0>
			<cfset control_cancel = 1>
		<cfelse>
			<cfset control_cancel = 0>
		</cfif>
	<cfelse>
		<cfset GET_INVOICE_DET = order.GET_INVOICE_DET(order_id : attributes.order_id)>
		
		<cfif get_invoice_det.recordcount>
			<cfset control_cancel = 1>
		</cfif>
	</cfif>
<cfelse>
	<cfset control_cancel = 0>
</cfif>
<cfif len(get_order_det.deliver_dept_id)>
	<cfset GET_STORE = order.GET_STORE(deliver_dept_id: get_order_det.deliver_dept_id )>
	
</cfif>
<cfif len(get_order_det.ship_method)>
	<cfset GET_METHOD = order.GET_METHOD(ship_method: get_order_det.ship_method)>
</cfif>

<cfset GET_ORDER_MONEY = order.GET_ORDER_MONEY(order_id: attributes.order_id)>

<cfif isdefined('attributes.is_order_risc_currency') and attributes.is_order_risc_currency eq 1>
	<cfset GET_RISC_MONEY = order.GET_RISC_MONEY()>
</cfif>

<cfset GET_SELECTED_MONEY = order.GET_SELECTED_MONEY(order_id : attributes.order_id, money: '#iif(isdefined("get_risc_money"),"get_risc_money.money",DE(""))#')>
<cfset GET_PROCESS = order.GET_PROCESS(order_stage: get_order_det.order_stage)>

<cfset session_company_category = session_base.company_category>
<cfset xml_company_cat_member_id = attributes.company_cat_member_id>

<cfset session_company_category = listSort(session_company_category, 'numeric')>
<cfset xml_company_cat_member_id = listSort(xml_company_cat_member_id, 'numeric')>

<cf_send_woc 
			action_id = #attributes.order_id#
			action_type = order_id
			>
<cfif isDefined("attributes.is_b2b") and attributes.is_b2b eq 0>
	<div class="form-row">
		<div class="form-group col-md-5">
			<label><cf_get_lang dictionary_id='58820.Başlık'></label>
			<input type="text" class="form-control" value="<cfoutput>#get_order_det.order_head#</cfoutput>">
		</div>
		<div class="form-group col-md-1">
			<label><cf_get_lang dictionary_id='57493.Aktif'></label><br>
			<label class="checkbox-container-lg">
				<input type="checkbox"/>
				<span class="checkmark-lg"></span>
			</label> 
		</div>
	</div>
	<cfif len(xml_company_cat_member_id) and ((compareNoCase(session_company_category,xml_company_cat_member_id) eq 0) or (compareNoCase(session_company_category,xml_company_cat_member_id) eq 1) or (compareNoCase(session_company_category,xml_company_cat_member_id) eq -1))>
		<div class="form-row">
			<div class="form-group col-md-3">
				<label><cf_get_lang dictionary_id='33008.Satış Yapan'> İş Ortağı</label>
				<input type="text" class="form-control" value="<cfoutput><cfif isdefined("comp")>#get_order_det_comp.fullname#<cfelse>#get_cons_name.consumer_name#&nbsp;#get_cons_name.consumer_surname#</cfif><cfif isdefined("get_cons_name.consumer_name")> / #get_cons_name.member_code#<cfelseif isdefined("get_order_det_cons.name")>#get_order_det_cons.name#</cfif></cfoutput>" readonly>
			</div>
			<div class="form-group col-md-3">
				<label>Satış Yapan İş Ortağı Yetkili</label>
				<input type="text" class="form-control" value="<cfoutput>#get_partner.company_partner_name# #GET_PARTNER.company_partner_surname#</cfoutput>" readonly>
			</div>
			<div class="form-group col-md-3">
				<label><cf_get_lang dictionary_id='57457.Müşteri'></label>
				<cfinclude template="../query/get_emps_pars_cons.cfm">					
				<select class="form-control" name="member" id="member">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_emps_pars_cons">
					<cfif (type eq 2) or (type eq 4) or (type eq 5)>
						<option value="#uye_id#,#comp_id#,#type#"><cfif len(get_emps_pars_cons.nickname)>#nickname# - </cfif>#uye_name# #uye_surname#</option>
					</cfif>
					</cfoutput>
				</select>			
			</div>
			<cfif isDefined("attributes.is_consumer") and attributes.is_consumer eq 1>
				<div class="form-group col-md-3">
					<label><cf_get_lang dictionary_id='58832.Abone'></label>
					<cfinclude template="../query/get_emps_pars_cons.cfm">					
					<select class="form-control" name="member" id="member">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_emps_pars_cons">
						<cfif (type eq 1) or (type eq 3)>
							<option value="#uye_id#,#comp_id#,#type#"><cfif len(get_emps_pars_cons.nickname)>#nickname# - </cfif>#uye_name# #uye_surname#</option>
						</cfif>
						</cfoutput>
					</select>
				</div>
			</cfif>						
		</div>
		<div class="form-row">
			<div class="form-group col-md-2">
				<label><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
				<input type="text" class="form-control" name="deliverdate" value="<cfoutput>#dateformat(get_order_det.deliverdate,'dd/mm/yyyy')#</cfoutput>" validate="eurodate" readonly>
			</div>
		</div>
	</cfif>	
<cfelse>
	<cfoutput>
		<h4 class="header-color mb-3"><cf_get_lang dictionary_id='58211.Sipariş No'>: #get_order_det.order_number#</h4>	
		<table class="table table-borderless">
			<cfif (isdefined("attributes.is_order_head") and attributes.is_order_head eq 1)>
				<tr>
					<td><cf_get_lang dictionary_id='57611.Sipariş'></td>
					<td colspan="3">: #get_order_det.order_head#</td>
				</tr>
			</cfif>
			<tr>
				<td><cf_get_lang dictionary_id='30339.Üye Adı'></td>
				<td>: 
					<cfif isdefined("comp")>
						#get_order_det_comp.fullname#
					<cfelse>
						#get_cons_name.consumer_name#&nbsp;#get_cons_name.consumer_surname#
					</cfif>
					<cfif isdefined("get_cons_name.consumer_name")> / 
						#get_cons_name.member_code#
					<cfelseif isdefined("get_order_det_cons.name")>
						#get_order_det_cons.name#
					</cfif>
				</td>
				<td><cfif (isdefined("attributes.is_ship_method") and attributes.is_ship_method eq 1)><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></cfif></td>
				<td>
					: 
					<cfif (isdefined("attributes.is_ship_method") and attributes.is_ship_method eq 1)>
						<cfif len(get_order_det.ship_method)>
							<cfif session_base.language neq 'tr'>
								<cfquery name="GET_LANG_SHIP_METHOD" dbtype="query">
									SELECT 
										* 
									FROM 
										GET_ALL_FOR_LANGS 
									WHERE 
										TABLE_NAME = 'SHIP_METHOD' AND 
										COLUMN_NAME = 'SHIP_METHOD' AND 
										UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.ship_method#">
								</cfquery>
								<cfif get_lang_ship_method.recordcount>
									#get_lang_ship_method.item#
								<cfelse>
									#get_method.ship_method#
								</cfif>
							<cfelse>									
								#get_method.ship_method#
							</cfif>
						</cfif>
					</cfif>	
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58593.Tarihi'></td>
				<td>: #dateformat(get_order_det.order_date,'dd/mm/yyyy')#</td>
				<td><cf_get_lang dictionary_id='57482.Aşama'></td>
				<td>: 
					<cfif isdefined('attributes.is_order_state') and attributes.is_order_state eq 1>
						<cfif session_base.language neq 'tr'>     
							<cfquery name="GET_ENG_STAGES" dbtype="query">
								SELECT * FROM GET_ALL_FOR_LANGS WHERE TABLE_NAME = 'PROCESS_TYPE_ROWS' AND COLUMN_NAME = 'STAGE' AND UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.order_stage#">
							</cfquery> 
							<cfif get_eng_stages.recordcount>
								#get_eng_stages.item#
							<cfelse>
								<cfif get_process.recordcount and len(get_process.stage)>
										#get_process.stage#
								</cfif>                                   
							</cfif>                               
						<cfelse>
							<cfif get_process.recordcount and len(get_process.stage)>
									#get_process.stage#
							</cfif>
						</cfif>
					<cfelse>
						<cfif get_process.recordcount and len(get_process.detail)>
								#get_process.detail#
						</cfif>
					</cfif>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
				<td>: 
					<cfif len(get_order_det.paymethod)>
						<cfset attributes.paymethod_id = get_order_det.paymethod>
						<cfinclude template="../../sales/query/get_paymethod.cfm">
						<cfif session_base.language neq 'tr'>
							<cfquery name="GET_FOR_PAYMETHOD" dbtype="query">
								SELECT 
									* 
								FROM 
									GET_ALL_FOR_LANGS 
								WHERE 
									TABLE_NAME = 'SETUP_PAYMETHOD' AND 
									COLUMN_NAME = 'PAYMETHOD' AND 
									UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.paymethod_id#">
							</cfquery>
							<cfif get_for_paymethod.recordcount>
								#get_for_paymethod.item#
							<cfelse>
								#get_paymethod.paymethod#
							</cfif>
						<cfelse>
							#get_paymethod.paymethod#
						</cfif>
					<cfelseif len(get_order_det.card_paymethod_id)>
						<cfquery name="GET_CARD_PAYMETHOD" datasource="#DSN3#">
							SELECT 
								CARD_NO
								<cfif get_order_det.commethod_id eq 6><!--- WW den gelen siparişlerin guncellemesi --->
									,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
								<cfelse><!--- EP VE PP den gelen siparişlerin guncellemesi --->
									,COMMISSION_MULTIPLIER 
								</cfif>
							FROM 
								CREDITCARD_PAYMENT_TYPE
							WHERE 
								PAYMENT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.card_paymethod_id#">
						</cfquery>
						#get_card_paymethod.card_no#
					</cfif>
				</td>
				<td><cf_get_lang dictionary_id='57881.Vade Tarihi'></td>
				<td>: #dateformat(get_order_det.due_date,'dd/mm/yyyy')#</td>
			</tr>
			<cfif (isdefined("attributes.is_deliverdate") and attributes.is_deliverdate eq 1) or not isdefined("attributes.is_deliverdate")>
				<tr>
					<td><cf_get_lang dictionary_id='57645.Teslim Tarihi'></td>
					<td>: #dateformat(get_order_det.deliverdate,'dd/mm/yyyy')#</td>
				</tr>
			</cfif>
			<cfif isdefined("attributes.is_sales_zone") and attributes.is_sales_zone eq 1>
				<tr>
					<td><cf_get_lang dictionary_id='33624.Bölge Kodu'></td>
					<td>: <cfif isdefined("ims_code")>#ims_code#</cfif></td>
				</tr>
			</cfif>
			<tr>
				<td><cf_get_lang dictionary_id='58449.Teslim Yeri'></td>
				<td>: #get_order_det.ship_address#</td>
				<cfif isdefined("attributes.is_order_cancel") and attributes.is_order_cancel eq 1 and control_cancel eq 0 and get_order_det.order_status eq 1 and isdefined("session.ep")>
					<td>
						<input type="button" name="cancel_order" id="cancel_order" value="Siparişi İptal Et" onclick="if (confirm('Sipariş İptal Edilecek Emin misiniz?')) window.location='<cfoutput>#request.self#?fuseaction=objects2.emptypopup_upd_order_status&order_id=#attributes.order_id#</cfoutput>'">
					</td>
				</cfif>
				<cfif isdefined("attributes.is_order_return") and attributes.is_order_return eq 1 and isdefined("session.ep")>
					<cfquery name="GET_INVOICE_DET_2" datasource="#DSN3#">
						SELECT INVOICE_ID FROM ORDERS_INVOICE WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
					</cfquery>
					<cfif get_invoice_det_2.recordcount>
						<cfquery name="GET_INVOICE_NUMBER" datasource="#DSN2#">
							SELECT INVOICE_NUMBER FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice_det_2.invoice_id#">
						</cfquery>
						<td><input type="button" name="add_return" id="add_return" value="İade Talebi Ekle" onclick="windowopen('#request.self#?fuseaction=objects2.add_return&invoice_no=#get_invoice_number.invoice_number#&invoice_year=#year(now())#&consumer_id=#get_order_det.consumer_id#','wide');"></td>
					</cfif>
				</cfif>
			</tr>
			<cfif isdefined('attributes.is_order_project') and attributes.is_order_project eq 1 and len(get_order_det.project_id)>
				<cfquery name="GETPROJECT" datasource="#DSN#">
					SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_det.project_id#">
				</cfquery>
				<tr>
					<td><cf_get_lang_main no='4.Proje'></td>
					<td>: #getProject.project_id# - #getProject.project_head#</td>
					<cfif isdefined('attributes.is_order_detail') and attributes.is_order_detail eq 1 and len(get_order_det.order_detail)>
						<td><cf_get_lang dictionary_id='36199.Açıklama'></td>
						<td>: #get_order_det.order_detail#</td>
					</cfif>
				</tr>
			</cfif>
		</table>		
	</cfoutput>
</cfif>		

<div style="font-size:25px; color:#e38283;font-family:'PoppinsR';padding:20px 0 0 0"><cf_get_lang dictionary_id='57564.Ürünler'> - <cf_get_lang dictionary_id='37090.Hizmetler'></div>

<div class="table-responsive">
	<table class="table table-bordered basket_table">
		<thead>
			<tr>
				<td><cf_get_lang dictionary_id='44019.Ürün'></td>
				<cfif isdefined('attributes.is_product_name2') and attributes.is_product_name2 eq 1><td><cf_get_lang dictionary_id='36199.Açıklama'></td></cfif>
				<cfif isdefined('attributes.is_order_stock_code') and attributes.is_order_stock_code eq 1>
					<td><cf_get_lang dictionary_id='57518.Stok Kodu'></td>
				</cfif>
				<cfif isdefined('attributes.is_order_special_code') and attributes.is_order_special_code eq 1>
					<td><cf_get_lang dictionary_id='57789.Özel Kod'></td>
				</cfif>
				<cfif isdefined('attributes.is_order_stage') and attributes.is_order_stage eq 1>
					<td><cf_get_lang dictionary_id='57482.Aşama'></td>
				</cfif>
				<td><cf_get_lang dictionary_id='57636.Birim'></td>
				<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></td>
				<cfif isdefined('attributes.is_order_prices_kdv') and attributes.is_order_prices_kdv eq 1>
					<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57639.KDV'></td>
				</cfif>
				<cfif isdefined('attributes.is_order_unit_prices') and attributes.is_order_unit_prices eq 1>
					<td align="right" style="text-align:right;"><cf_get_lang_main no ='2227.KDVsiz'> <cf_get_lang dictionary_id='57638.Birim Fiyat'></td>
				</cfif>
				<cfif isdefined('attributes.is_order_prices_total') and attributes.is_order_prices_total eq 1>
					<td align="right" style="text-align:right;"><cf_get_lang_main no ='2227.KDVsiz'> <cf_get_lang dictionary_id='57492.Toplam'></td>
				</cfif>
				<cfif isdefined('attributes.is_order_unit_prices_kdv') and attributes.is_order_unit_prices_kdv eq 1>
					<td align="right" style="text-align:right;"><cf_get_lang_main no ='1304.KDVli'> <cf_get_lang dictionary_id='58084.Fiyat'></td>
				</cfif>
				<cfif isdefined('attributes.is_order_prices_total_kdv') and attributes.is_order_prices_total_kdv eq 1>
					<td align="right" style="text-align:right;"><cf_get_lang_main no ='1304.KDVli'> <cf_get_lang dictionary_id='57492.Toplam'></td>
				</cfif>
				<cfif isdefined('attributes.is_order_discount') and attributes.is_order_discount eq 1>
					<td align="center"><cf_get_lang dictionary_id='34551.İsk.'>-1</td>
					<td align="center"><cf_get_lang dictionary_id='34551.İsk.'>-2</td>
					<td align="center"><cf_get_lang dictionary_id='34551.İsk.'>-3</td>
					<td align="center"><cf_get_lang dictionary_id='34551.İsk.'>-4</td>
					<td align="center"><cf_get_lang dictionary_id='34551.İsk.'>-5</td>
				</cfif>
				<cfif isdefined('attributes.is_order_other_prices') and attributes.is_order_other_prices eq 1>
					<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='34076.Döviz Fiyat'></td>
					<cfif isdefined('attributes.is_order_other_money') and attributes.is_order_other_money eq 1>
						<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57677.Döviz'></td>
					</cfif>
				</cfif>
				<cfif isdefined('attributes.is_order_discount_total') and attributes.is_order_discount_total eq 1>
					<td align="right" style="text-align:right;"><cf_get_lang dictionary_id='57649.Toplam İndirim'></td>
				</cfif> 
				<cfif isdefined('attributes.is_order_prices_nettotal') and attributes.is_order_prices_nettotal eq 1>
					<td align="right" style="text-align:right;" ><cf_get_lang dictionary_id='57642.Net Toplam'></td>
				</cfif>
			</tr>
		</thead>
		<cfinclude template="../query/show_order_basket.cfm">	
		<cfoutput query="get_order_row">
			<cfif len(product_id) and not listfind(product_id_list,product_id)>
				<cfset product_id_list = listappend(product_id_list,product_id)>
			</cfif>
		</cfoutput>
		<cfif len(product_id_list)>
			<cfquery name="GET_KARMA_PRODUCTS" datasource="#DSN1_alias#">
				SELECT 
					PRODUCT_NAME,
					UNIT,
					PRODUCT_AMOUNT,
					KARMA_PRODUCT_ID
				FROM 
					KARMA_PRODUCTS
				WHERE
					KARMA_PRODUCT_ID IN (#product_id_list#)
			</cfquery>
		</cfif>
		<cfset toplam_indirim = 0>
		<cfset netTotal_ = 0>
		<cfoutput query="get_order_row">
			<cfset row_grosstotal = price * quantity>
			<cfset toplam_indirim = toplam_indirim+(row_grosstotal-nettotal)>
			<cfset price_kdv_ = (price+(price*tax/100))>
			<cfset price_kdv_total_ = (price+(price*tax/100))*quantity>
			<cfset netTotal_ = netTotal_+row_grosstotal>
			<tbody>
			<tr>
				<td>
					<cfif session_base.language neq 'tr'>
						<cfquery name="GET_LANG_PRODUCT_NAME" dbtype="query">
							SELECT 
								* 
							FROM 
								GET_ALL_FOR_LANGS 
							WHERE 
								TABLE_NAME = 'PRODUCT' AND 
								COLUMN_NAME = 'PRODUCT_NAME' AND 
								UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">
						</cfquery>  
						<cfif get_lang_product_name.recordcount>
							#get_lang_product_name.item#
						<cfelse>
							#product_name#
						</cfif>                
					<cfelse> 	
						#product_name# 
					</cfif>
					
					<cfif len(spect_var_name) and spect_var_name neq product_name>- #spect_var_name#</cfif>
					<!--- <cfif get_module_user(5)>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&sid=#order_id#','medium');"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no ='1352.Ürün Detayları'>" border="0" align="absmiddle"></a>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_std_sale&price_type=purc&pid=#product_id#','list');"><img src="/images/plus_thin_p.gif" title="<cf_get_lang_main no ='309.Ürün Fiyat Tarihçe'>" border="0" align="absmiddle"></a>
					</cfif> --->
					
				</td>
				<cfif isdefined('attributes.is_product_name2') and attributes.is_product_name2 eq 1><td>#product_name2#</td></cfif>
				<cfif isdefined('attributes.is_order_stock_code') and attributes.is_order_stock_code eq 1>
					<td>
						<cfif isdefined('attributes.related_product_lists') and len(attributes.related_product_lists)>
							<cfif  not listfindnocase(attributes.related_product_lists,product_id)>
								#stock_code#
							</cfif>
						<cfelse>
							#stock_code#
						</cfif>
					</td>
				</cfif>
				<cfif isdefined('attributes.is_order_special_code') and attributes.is_order_special_code eq 1>
					<td>
						<cfif isdefined('attributes.related_product_lists') and len(attributes.related_product_lists)>
							<cfif  not listfindnocase(attributes.related_product_lists,product_id)>
								#stock_code_2#
							</cfif>
						<cfelse>
							#stock_code_2#
						</cfif>
					</td>
				</cfif>
				<cfif isdefined('attributes.is_order_stage') and attributes.is_order_stage eq 1>
					<td>&nbsp;
						<cfif get_order_row.order_row_currency eq -1><cf_get_lang dictionary_id='58717.Açık'>
						<cfelseif get_order_row.order_row_currency eq -2><cf_get_lang dictionary_id='29745.Tedarik'>
						<cfelseif get_order_row.order_row_currency eq -3><cf_get_lang dictionary_id='29746.Kapatıldı'>
						<cfelseif get_order_row.order_row_currency eq -4><cf_get_lang dictionary_id='29747.Kısmi Üretim'>
						<cfelseif get_order_row.order_row_currency eq -5><cf_get_lang dictionary_id='57456.Üretim'>
						<cfelseif get_order_row.order_row_currency eq -6><cf_get_lang dictionary_id='58761.Sevk'>
						<cfelseif get_order_row.order_row_currency eq -7><cf_get_lang dictionary_id='29748.Eksik Teslimat'>
						<cfelseif get_order_row.order_row_currency eq -8><cf_get_lang dictionary_id='29749.Fazla Teslimat'>
						<cfelseif get_order_row.order_row_currency eq -9><cf_get_lang dictionary_id='58506.İptal'>
						<cfelseif get_order_row.order_row_currency eq -10><cf_get_lang dictionary_id='40876.Kapatıldı(Manuel)'>
						</cfif>
					</td>
				</cfif>
				<td>&nbsp;#unit#</td>
				<td align="right" style="text-align:right;">#amountformat(quantity)#</td>
				<cfif isdefined('attributes.is_order_prices_kdv') and attributes.is_order_prices_kdv eq 1>
					<td align="right" style="text-align:right;">#TLFormat(tax,0)#</td>
				</cfif>
				<cfif isdefined('attributes.is_order_unit_prices') and attributes.is_order_unit_prices eq 1>
					<td align="right" style="text-align:right;">#TLFormat(price)#</td>
				</cfif>
				<cfif isdefined('attributes.is_order_prices_total') and attributes.is_order_prices_total eq 1>
					<td align="right" style="text-align:right;">#TLFormat(row_grosstotal)#</td>
				</cfif>
				<cfif isdefined('attributes.is_order_unit_prices_kdv') and attributes.is_order_unit_prices_kdv eq 1>
					<td align="right" style="text-align:right;">#TLFormat(price_kdv_)#</td>
				</cfif>
				<cfif isdefined('attributes.is_order_prices_total_kdv') and attributes.is_order_prices_total_kdv eq 1>
					<td align="right" style="text-align:right;">#TLFormat(price_kdv_total_)#</td>
				</cfif>
				<cfif isdefined('attributes.is_order_discount') and attributes.is_order_discount eq 1>
					<td align="center">#discount_1#</td>
					<td align="center">#discount_2#</td>
					<td align="center">#discount_3#</td>
					<td align="center">#discount_4#</td>
					<td align="center">#discount_5#</td>
				</cfif>
				<cfif isdefined('attributes.is_order_other_prices') and attributes.is_order_other_prices eq 1>
					<td align="right" style="text-align:right;">#TLFormat(price_other)#</td>
					<cfif isdefined('attributes.is_order_other_money') and attributes.is_order_other_money eq 1>
						<td align="right" style="text-align:right;">#other_money#</td>
					</cfif>
				</cfif>
				<cfif isdefined('attributes.is_order_discount_total') and attributes.is_order_discount_total eq 1>
					<td align="right" style="text-align:right;">#TLFormat(row_grosstotal-nettotal)#</td>
				</cfif>
				<cfif isdefined('attributes.is_order_prices_nettotal') and attributes.is_order_prices_nettotal eq 1>
					<td align="right" style="text-align:right;">#TLFormat(nettotal)#</td>
				</cfif>
			</tr>
				<cfif isdefined('attributes.is_show_product_detail') and attributes.is_show_product_detail eq 1 and is_karma eq 1>
					<cfquery name="GET_KARMA_PRODUCT_ROW" dbtype="query">
						SELECT PRODUCT_NAME,UNIT,PRODUCT_AMOUNT FROM GET_KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_row.product_id#">
					</cfquery>
					<cfloop query="get_karma_product_row">
						<tr  class="color-row" style="font-size:9px">
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_karma_product_row.product_name#</td>
							<cfif isdefined('attributes.is_product_name2') and attributes.is_product_name2 eq 1><td ></td></cfif>
							<cfif isdefined('attributes.is_order_stock_code') and attributes.is_order_stock_code eq 1><td ></td></cfif>
							<cfif isdefined('attributes.is_order_special_code') and attributes.is_order_special_code eq 1><td></td></cfif>
							<cfif isdefined('attributes.is_order_stage') and attributes.is_order_stage eq 1><td></td></cfif>
							<!--- <td>&nbsp#unit#</td> Karma Koli ürün birimi 
							<td align="right">#amountformat(product_amount)#</td> Karma koli ürün adedi--->
							<td colspan="10"></td>
						</tr>
					</cfloop>
				</cfif>
			<tr>
				<cfif isdefined('attributes.is_spect_var_id') and attributes.is_spect_var_id eq 1>							
					<cfif len(spect_var_id)>
						<a href="javascript://" onclick="gizle_goster(spect#spect_var_id#);"><b><font color="##FF0000"><cf_get_lang dictionary_id='34460.ürün Bileşenleri'></font></b></a>
						<cfset GET_SPECT = order.GET_SPECT(spect_var_id : spect_var_id)>						
						<table class="table" style="display:none;" id="spect#spect_var_id#">
							<tr>
								<td>#get_spect.spect_var_name#</td>
								<td align="right" style="width:40px;text-align:right;"></td>
							<tr> 
							<cfloop query='get_spect'>
								<tr>
									<td>#product_detail#</td>
									<td align="right" style="width:40px;text-align:right;">#amount_value#</td>
								</tr>
							</cfloop>
						</table>
					</cfif>							
				</cfif>
			</tr>
		</tbody>
		</cfoutput>
	</table>
</div>
		
<div class="row">
	<div class="col-lg-4">
		<cfif isdefined('attributes.is_order_kur') and attributes.is_order_kur eq 1>
			<table class="table table-sm m-4">
				<tr>
					<td class="w-100" colspan="2"><label class="font-weight-bold text-color-4"><cf_get_lang dictionary_id='33314.Kur Bilgisi'></label></td>
				</tr>
				<cfoutput query="get_order_money">
					<tr>
						<td class="w-100"><label class="text-w3">#money_type#</label></td>
						<td class="w-100"><label class="text-right">#TLFormat(rate2,4)#</label></td>
					</tr>						
				</cfoutput>
				<tr>
					<td class="w-100" colspan="2"><p class="mt-3 text-color-4"><small>Bu cari hesapla TL çalışılmaktadır.</small></p></td>           
				</tr>	
			</table>
		</cfif>			
	</div>
	<div class="col-xl-5 ml-auto">		
		<cfif get_bank_info.recordcount>
			<table class="table table-sm m-4">
				<cfoutput>								
					<tr>
						<td colspan="2"  class="font-weight-bold"> 
							<cf_get_lang dictionary_id='32736.Havale'> / EFT Bilgileri
						</td>
					</tr>
					<tr>
						<td class="font-weight-bold"><cf_get_lang dictionary_id='30349.Banka Adı'><cf_get_lang dictionary_id='57989.ve'><cf_get_lang dictionary_id='58941.Şubesi'> :</td>
						<td>#get_bank_info.bank_name# - #get_bank_info.bank_branch_name#</td>
					</tr>
					<tr>
						<td class="font-weight-bold">Sube No :</td>
						<td>#get_bank_info.branch_code#</td>
					</tr>
					<tr>
						<td class="font-weight-bold">Hesap Numarasi :</td>
						<td>#get_bank_info.account_no#</td>
					</tr>
					<tr>
						<td class="font-weight-bold">IBAN No :</td>
						<td>#get_bank_info.account_owner_customer_no#</td>
					</tr>  
					<tr>
						<td class="font-weight-bold">EFT Islemleri Için Alici Ünvani :</td> 										
						<td>
							<cfif isdefined('session.pp.userid')>
								#session.pp.our_name#
							<cfelse>
								#session.ww.our_name#
							</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="2"><b>Lütfen EFT/Havale Açiklamasini Siparis Numarasi - Ad Soyad Seklinde Belirtiniz</b></td>
					</tr>								
				</cfoutput>
			</table>
		</cfif> 
		<cfif isdefined('attributes.is_order_main_total') and attributes.is_order_main_total eq 1>
			<table class="table table-sm mt-lg-4">
				<cfoutput>						
					<tr>
						<td class="w-100"><cf_get_lang dictionary_id='57492.Toplam'></td>
						<cfif isdefined('attributes.is_order_doviz_total') and attributes.is_order_doviz_total eq 1>
							<cfset doviz_total = get_order_det.grosstotal / get_selected_money.rate2>
							<td align="right" style="width:90px;text-align:right;font-weight:bold">&nbsp;#TLFormat(doviz_total)# <cfoutput>#get_selected_money.money_type#</cfoutput></td>
						</cfif>
						<td class="w-100" align="right" style="text-align:right;font-weight:bold">&nbsp;#TLFormat(netTotal_)# 
							<cfif isdefined("session.pp.money")>
								<cfoutput>#session.pp.money#</cfoutput>
							<cfelseif isdefined("session.ww.money")>
								<cfoutput>#session.ww.money#</cfoutput>
							<cfelse>
								<cfoutput>#session.ep.money#</cfoutput>
							</cfif>
						</td>
					</tr>
					<cfif (isdefined("attributes.is_basket_discount") and attributes.is_basket_discount eq 1) or not isdefined("attributes.is_basket_discount")>			  
						<tr>
							<td><cf_get_lang dictionary_id='58765.Satıraltı İndirim'></td>
							<cfif isdefined('attributes.is_order_doviz_total') and attributes.is_order_doviz_total eq 1>
								<cfset doviz_indirim = get_order_det.sa_discount / get_selected_money.rate2>
								<td align="right" style="text-align:right;font-weight:bold">&nbsp;#TLFormat(doviz_indirim)#</td>
							</cfif>
							<td align="right" style="text-align:right;font-weight:bold">&nbsp;#TLFormat(get_order_det.sa_discount)#</td>
						</tr>
					</cfif>
					<cfif (isdefined("attributes.is_total_discount") and attributes.is_total_discount eq 1) or not isdefined("attributes.is_total_discount")>			  
							<td class="w-100"><cf_get_lang dictionary_id='57649.Toplam İndirim'></td>
							<cfif isdefined('attributes.is_order_doviz_total') and attributes.is_order_doviz_total eq 1>
								<cfset doviz_indirim2= (toplam_indirim+get_order_det.sa_discount) / get_selected_money.rate2>
								<td class="w-100" align="right" style="text-align:right;font-weight:bold">&nbsp;#TLFormat(doviz_indirim2)#</td>
							</cfif>
							<td class="w-100" align="right" style="text-align:right;font-weight:bold">&nbsp;#TLFormat(toplam_indirim+get_order_det.sa_discount)#</td>
						</tr>	
					</cfif>	
					<tr>
						<td class="w-100"><cf_get_lang dictionary_id='31169.Toplam KDV'></td>
						<cfif isdefined('attributes.is_order_doviz_total') and attributes.is_order_doviz_total eq 1>
							<cfset doviz_kdv= get_order_det.taxtotal / get_selected_money.rate2>
							<td class="w-100" align="right" style="text-align:right;font-weight:bold">&nbsp;#TLFormat(doviz_kdv)#</td>
						</cfif>
						<td class="w-100" align="right" style="text-align:right;font-weight:bold">&nbsp;#TLFormat(get_order_det.taxtotal)#</td>
					</tr>
					<tr>
						<td class="w-100" class="font-weight-bold" style="color:##2eac23"><cf_get_lang_main no ='268.Genel Toplam'></td>
						<cfif isdefined('attributes.is_order_doviz_total') and attributes.is_order_doviz_total eq 1>
							<td class="w-100" align="right" class="text-color-4 font-weight-bold" style="text-align:right;color:##2eac23">&nbsp;#TLFormat(get_order_det.other_money_value)#</td>
						</cfif>
						<td class="w-100" align="right" class="font-weight-bold" style="color:##2eac23">&nbsp;
						<!---#TLFormat(get_order_det.nettotal)#--->
						#TLFormat((netTotal_-(toplam_indirim+get_order_det.sa_discount))+get_order_det.taxtotal)#</td>
					</tr>
					<cfif get_money_credits.recordcount>
						<cfquery name="GET_GIFT_CREDIT" dbtype="query">
							SELECT SUM(USED_VALUE) AS TOTAL_USED_VALUE FROM GET_MONEY_CREDITS WHERE IS_TYPE = 1
						</cfquery>
						<cfif get_gift_credit.recordcount>
							<tr>
								<td><cf_get_lang no='55.Hediye Kartı İndirimi'></td>
								<td style="text-align:right;"><cfif get_gift_credit.recordcount>#TLFormat(get_gift_credit.total_used_value,2)#<cfelse>0</cfif></td>
							</tr>                                     
						</cfif>
						<cfquery name="GET_MONEY_CREDIT" dbtype="query">
							SELECT SUM(USED_VALUE) AS  TOTAL_USED_VALUE FROM GET_MONEY_CREDITS WHERE IS_TYPE = 0
						</cfquery>
						<cfif get_money_credit.recordcount>
							<tr>
								<td class="txtbold">Kullanılan Parapuan</td>
								<td style="text-align:right;"><cfif get_money_credit.recordcount>#TLFormat(get_money_credit.total_used_value,2)#<cfelse>0</cfif></td>
							</tr> 
						</cfif>
						<tr>
							<cfset discount_total = get_order_det.nettotal>
							<cfif get_gift_credit.recordcount and len(get_gift_credit.total_used_value)>
								<cfset discount_total = discount_total - get_gift_credit.total_used_value>
							</cfif>     
							<cfif get_money_credit.recordcount and len(get_money_credit.total_used_value)>
								<cfset discount_total = discount_total - get_money_credit.total_used_value>
							</cfif>                       
							<td>İndirimli Genel Toplam</td>
							<td style="text-align:right;"><cfif len(discount_total)>#TLFormat(discount_total,2)#</cfif></td>
						</tr> 
					</cfif>						
				</cfoutput>
			</table>
		</cfif>
	</div>
</div>		