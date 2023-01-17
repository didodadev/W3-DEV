<!--- 
	page_type: masrafın tutuldugu belge tipini gösterir.
	page_type=1 fatura masrafları icin kullanılır, INVOICE_COST tablosuna kayıt ekler.
	page_type=2 siparis kayıtları icin kullanılır, ORDER_OFFER_COST tablosuna kayıt ekler.
	page_type=3 teklif kayıtları icin kullanılır, ORDER_OFFER_COST tablosuna kayıt ekler.OZDEN16112005 --->
<!--- 	
	page_type=4 ithal mal girişi kayıtları icin kullanılır, INVOICE_COST tablosuna kayıt ekler.
	page_type=5 depolararası sevk için kayıtları icin kullanılır, INVOICE_COST tablosuna kayıt ekler.
	ORDER_OFFER_COST tablosunda siparisten gelen masraflar icin IS_ORDER=1,tekliften gelenler icin ise IS_ORDER=0 set edilir OZDEN20060503--->

<!--- bu sayfa ve tablo yapısı detaylı olarak ele alınıp standart yapıya getirilmeli. INVOICE_COST_INVOICE_COST_ROW VE INVOICE_COST_MONEY oluşturulmalı.
maliyet dağıtım yöntemleri eklenirken bu işlemlerde ele alınsın ayrıca fatura-irsaliye ve sipariş silme sayfalarında bu tablolardaki ilgili kayıtların 
silinmesi de kontrol edilmeli. OZDEN20070823
 --->
 <cfparam  name="attributes.tax_type_id" default="">
 <cf_xml_page_edit>
	<cfset system_round_number =2>
	<cfif isdefined('attributes.basket_id') and len(attributes.basket_id)>
		<!--- harcama detay cagrıldıgı işlem detayda kullanılan basketin yuvarlama bilgisini kullanır. --->
		<cfquery name="get_round_number" datasource="#dsn3#">
			SELECT PRICE_ROUND_NUMBER FROM SETUP_BASKET WHERE BASKET_ID = #attributes.basket_id# AND B_TYPE=1
		</cfquery>
		<cfif len(get_round_number.PRICE_ROUND_NUMBER)>
			<cfset system_round_number =get_round_number.PRICE_ROUND_NUMBER>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.page_type") and attributes.page_type eq 1> <!--- fatura masrafları --->
		<cfquery name="COST_PAGE_DETAIL" datasource="#dsn2#">
			SELECT INVOICE_ID AS COST_PAGE_ID, INVOICE_NUMBER AS COST_PAGE_NUMBER, PURCHASE_SALES,PROJECT_ID,PROCESS_CAT,INVOICE_DATE AS PAPER_DATE FROM INVOICE WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
		</cfquery>
		<cfquery name="get_process_cat" datasource="#dsn2#">
			SELECT IS_PROJECT_BASED_ACC,IS_ACCOUNT_GROUP FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#COST_PAGE_DETAIL.PROCESS_CAT#">
		</cfquery>
		<cfquery name="GET_COST_DETAIL" datasource="#dsn2#">
			SELECT 
				INVOICE_COST_ID AS COST_ID,
				INVOICE_ID,
				INVOICE_NUMBER,
				PURCHASE_SALES,
				ROW_PAPER_NO,
				DOCUMENT_TYPE_ID,
				EXPENSE_ITEM_ID,
				DETAIL,
				INVOICE_COST AS COST,
				INVOICE_COST_MONEY AS COST_MONEY,
				INVOICE_OTHER_COST AS OTHER_COST,
				OTHER_MONEY,
				FOREIGN_MONEY,
				FOREIGN_MONEY_COST,
				QUANTITY,
				DISTRIBUTE_TYPE,
				ACCOUNT_CODE,
				UPDATE_DATE,
				UPDATE_EMP,
				PROCESS_CAT,
				PROCESS_TYPE,
				TAX_TYPE,
				COMPANY_ID,
				EMPLOYEE_ID,
				CONSUMER_ID,
				UPDATE_IP
			FROM 
				INVOICE_COST 
			WHERE 
				INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
		</cfquery>
		<cfquery name="get_max_id" datasource="#dsn2#">
			SELECT MAX(INVOICE_COST_ID) MAX_ID,MAX(PROCESS_TYPE) PROCESS_TYPE FROM INVOICE_COST WHERE INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
		</cfquery>
	<cfelseif isdefined("attributes.page_type") and attributes.page_type eq 2> <!--- siparis masrafları --->
		<cfquery name="COST_PAGE_DETAIL" datasource="#dsn3#">
			SELECT ORDER_ID AS COST_PAGE_ID, ORDER_NUMBER AS COST_PAGE_NUMBER,PURCHASE_SALES ,PROJECT_ID FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
		</cfquery>
		<cfquery name="GET_COST_DETAIL" datasource="#dsn3#">
			SELECT 
				* 
			FROM 
				ORDER_OFFER_COST 
			WHERE 
				ORDER_OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
				AND IS_ORDER = 1
		</cfquery>
	<cfelseif isdefined("attributes.page_type") and attributes.page_type eq 3> <!--- teklif masrafları --->
		<cfquery name="COST_PAGE_DETAIL" datasource="#dsn3#">
			SELECT OFFER_ID AS COST_PAGE_ID, OFFER_NUMBER AS COST_PAGE_NUMBER,PURCHASE_SALES FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
		</cfquery>
		<cfquery name="GET_COST_DETAIL" datasource="#dsn3#">
			SELECT 
				* 
			FROM 
				ORDER_OFFER_COST 
			WHERE 
				ORDER_OFFER_ID = #URL.ID# 
				AND IS_ORDER = 0 
		</cfquery>
	<cfelseif isdefined("attributes.page_type") and (attributes.page_type eq 4 or attributes.page_type eq 5)> <!--- ithal mal girişi masraflari --->
		<cfquery name="COST_PAGE_DETAIL" datasource="#dsn2#">
			SELECT SHIP_ID AS COST_PAGE_ID, SHIP_NUMBER AS COST_PAGE_NUMBER, PURCHASE_SALES,PROJECT_ID,PROCESS_CAT,SHIP_DATE AS PAPER_DATE FROM SHIP WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
		</cfquery>
		<cfquery name="get_process_cat" datasource="#dsn2#">
			SELECT IS_PROJECT_BASED_ACC,IS_ACCOUNT_GROUP FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#COST_PAGE_DETAIL.PROCESS_CAT#">
		</cfquery>
		<cfquery name="GET_COST_DETAIL" datasource="#dsn2#">
			SELECT 
				INVOICE_COST_ID AS COST_ID,
				SHIP_ID,
				SHIP_NUMBER,
				PURCHASE_SALES,
				ROW_PAPER_NO,
				DOCUMENT_TYPE_ID,
				EXPENSE_ITEM_ID,
				DETAIL,
				INVOICE_COST AS COST,
				INVOICE_COST_MONEY AS COST_MONEY,
				INVOICE_OTHER_COST AS OTHER_COST,
				OTHER_MONEY,
				FOREIGN_MONEY,
				FOREIGN_MONEY_COST,
				QUANTITY,
				DISTRIBUTE_TYPE,
				PROCESS_CAT,
				PROCESS_TYPE,
				TAX_TYPE,
				COMPANY_ID,
				EMPLOYEE_ID,
				CONSUMER_ID,
				ACCOUNT_CODE
			FROM 
				INVOICE_COST 
			WHERE 
				SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
		</cfquery>
		<cfquery name="get_max_id" datasource="#dsn2#">
			SELECT MAX(INVOICE_COST_ID) MAX_ID,MAX(PROCESS_TYPE) PROCESS_TYPE FROM INVOICE_COST WHERE SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
		</cfquery>
	</cfif>
	<cfset row = GET_COST_DETAIL.recordcount>
	<cfif isdefined("attributes.page_type") and listfind('1,4,5',attributes.page_type)>
		<cfquery name="GET_MONEY" datasource="#dsn2#">
			SELECT 
				MONEY_TYPE AS MONEY,
				RATE1,
				RATE2 
			FROM 
				INVOICE_COST_MONEY 
			WHERE
			<cfif attributes.page_type eq 1>
				INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
			<cfelse>
				SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
			</cfif>
		</cfquery>
	<cfelseif  isdefined("attributes.page_type") and listfind('2,3',attributes.page_type)>
		<cfquery name="GET_MONEY" datasource="#dsn3#">
			SELECT 
				MONEY_TYPE AS MONEY,
				RATE1,
				RATE2 
			FROM 
				ORDER_OFFER_COST_MONEY 
			WHERE
			<cfif attributes.page_type eq 3>
				OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
			<cfelse>
				ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ID#">
			</cfif>
		</cfquery>
	</cfif>
	<cfif not GET_MONEY.recordcount>
		<cfquery name="GET_MONEY" datasource="#dsn2#">
			SELECT	
				MONEY,
				RATE1,
				RATE2 
			FROM 
				SETUP_MONEY 
			WHERE 
				MONEY_STATUS = 1
		</cfquery>
	</cfif>
	<cfquery name="GET_DOCUMENT_TYPE" datasource="#DSN#">
		SELECT
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
		FROM
			SETUP_DOCUMENT_TYPE,
			SETUP_DOCUMENT_TYPE_ROW
		WHERE
			SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
			SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE '%#fuseaction#%'
		ORDER BY
			DOCUMENT_TYPE_NAME		
	</cfquery>
	<cfquery name="get_tax_type" datasource="#dsn3#">
		SELECT TAX_TYPE_ID,TAX_TYPE FROM TAX_TYPE ORDER BY TAX_TYPE		
	</cfquery>
	<cfsavecontent variable="title_"><cf_get_lang dictionary_id='33848.Harcama Detay'>: <cfif cost_page_detail.recordcount and len(cost_page_detail.cost_page_number)><cfoutput>#cost_page_detail.cost_page_number#</cfoutput></cfif></cfsavecontent>
	<cfsavecontent variable="images_">
		<cfif (attributes.page_type eq 4 and x_acc_act eq 1) or (attributes.page_type eq 1 and x_acc_act_invoice eq 1)>
			<cfif get_module_user(22) and len(get_max_id.max_id)>
				<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_table=INVOICE_COST&action_id=#get_max_id.max_id#&process_cat=#get_max_id.process_type#</cfoutput>','page','form_upd_expense_cost');"><img src="/images/extre.gif"  border="0" title="<cf_get_lang dictionary_id='58452.Mahsup Fişi'>"></a>
			</cfif>
		</cfif>
	</cfsavecontent>
	<div class="col col-12 col-xs-12">
		<cf_box title="#title_#" right_images="#images_#">
			<cfform method="post" name="list_cost" action="#request.self#?fuseaction=objects.emptypopup_add_cost" onsubmit="return unformat_fields();">
				<cfoutput>
					<input type="hidden" name="cost_page_id" id="cost_page_id" value="#COST_PAGE_DETAIL.COST_PAGE_ID#">
					<input type="hidden" name="cost_page_number" id="cost_page_number" value="#COST_PAGE_DETAIL.COST_PAGE_NUMBER#">
					<input type="hidden" name="purchase_sales" id="purchase_sales" value="#COST_PAGE_DETAIL.PURCHASE_SALES#">
					<input type="hidden" name="page_type" id="page_type" value="#url.page_type#">
					<input type="hidden" name="masraf_dagit" id="masraf_dagit" value="0">
					<cfif isdefined("cost_page_detail.project_id") and len(cost_page_detail.project_id)><input type="hidden" name="project_id" id="project_id" value="#cost_page_detail.project_id#"></cfif>
					<input type="hidden" name="acc_action" id="acc_action" value="0">
					<input type="hidden" name="x_inventory_products" id="x_inventory_products" value="#x_inventory_products#">
                    <cfif isdefined("attributes.page_type") and listfind('1,4,5',attributes.page_type)>
                        <input type="hidden" name="paper_date" id="paper_date" value="#dateFormat(COST_PAGE_DETAIL.PAPER_DATE,'dd/mm/yyyy')#">
                    </cfif>
					<cf_box_elements>
						<div class="col col-3 col-md-4 col-sm-6 col-xs-12">
							<div class="form-group" id="item-process_cat">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'>*</label>
								<div class="col col-8 col-xs-12">
									<cfif len(GET_COST_DETAIL.PROCESS_CAT)>							
										<cf_workcube_process_cat process_cat="#GET_COST_DETAIL.PROCESS_CAT#">
									<cfelse>
										<cf_workcube_process_cat>
									</cfif>										
								</div>
							</div>
						</div>
					</cf_box_elements>
				</cfoutput>
				<cf_grid_list>
					<thead>
						<tr>
							<th width="20">
								<input name="record_num" id="record_num" type="hidden" value="<cfif get_cost_detail.recordcount><cfoutput>#row#</cfoutput></cfif>">
								<a onclick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
							</th>
							<th><cf_get_lang dictionary_id='32902.Dağıtım Türü'></th>
							<th width="100"><cf_get_lang dictionary_id='58578.Belge Turu'></th>
							<th width="100"><cf_get_lang dictionary_id='62506.vergi türü'></th>
							<th><cf_get_lang dictionary_id='57880.Belge No'></th>
							<th><cf_get_lang dictionary_id='57519.cari hesap'></th>
							<th><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
							<cfif x_show_acc_code eq 1 and listfind('1,4',attributes.page_type)>
								<th><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></th>
							</cfif>
							<th><cf_get_lang dictionary_id='57629.Açıklama'>*</th>				
							<th><cf_get_lang dictionary_id='57635.Miktar'></th>
							<th><cf_get_lang dictionary_id='57673.Tutar'>*</th>
							<th><cf_get_lang dictionary_id='57489.Para Birimi'>*</th>
						</tr>
					</thead>
					<tbody name="table1" id="table1">
						<cfif get_cost_detail.recordcount and get_cost_detail.currentrow>
							<cfoutput query="get_cost_detail">
								<tr id="frm_row#currentrow#">
									<td><a href="javascript://" onclick="sil(#currentrow#);"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
									<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="2"><!--- önceki kayıt olduğunu belirtmek için value olarak 2 atanıyor.--->
									<td>
										<div class="form-group">
											<select name="dis_type#currentrow#" id="dis_type#currentrow#">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<option value="0" <cfif distribute_type eq 0>selected</cfif>><cf_get_lang dictionary_id='60089.Parasal Değer'></option>
												<option value="1" <cfif distribute_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29784.Ağırlık'></option>
												<option value="2" <cfif distribute_type eq 2>selected</cfif>><cf_get_lang dictionary_id='30114.Hacim'></option>
											</select>
										</div>
									</td>
									<td>
										<div class="form-group">
											<cfset aktif_document = document_type_id>
											<select name="document_type_id#currentrow#" id="document_type_id#currentrow#">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="get_document_type"> 
													<option value="#get_document_type.document_type_id#" <cfif get_document_type.document_type_id eq aktif_document>selected</cfif>>#get_document_type.document_type_name#</option>
												</cfloop> 
											</select>
										</div>
									</td>
									<td>
										<div class="form-group">
											<cfset aktif_tax = tax_type>
											<select name="tax_type_id#currentrow#" id="tax_type_id#currentrow#">
												<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
												<cfloop query="get_tax_type"> 
													<option value="#get_tax_type.tax_type_id#" <cfif get_tax_type.tax_type_id eq aktif_tax>selected</cfif>>#tax_type#</option>
												</cfloop> 
											</select>
										</div>
									</td>
									<td>
										<div class="form-group">
											<input type="text" name="row_paper_no#currentrow#" id="row_paper_no#currentrow#" style="width:70px;" value="#row_paper_no#">
										</div>
									</td>					
							
									<cfset ch_partner_type_value = len(COMPANY_ID) ? "partner" : len(CONSUMER_ID) ?  "consumer" : len(employee_id) ? "employee" : "">
									<cfset member_id = len(COMPANY_ID) ? COMPANY_ID : len(CONSUMER_ID) ?  CONSUMER_ID : len(employee_id) ? employee_id : "">
									<cfset member_name = len(COMPANY_ID) ? get_par_info(COMPANY_ID,1,0,0) : len(CONSUMER_ID) ?  get_cons_info(CONSUMER_ID,0,0) : len(employee_id) ? get_emp_info(employee_id,0,0) : "">
									
									<td>
										<div class="form-group">
											<input type="hidden" name="ch_member_type#currentrow#" id="ch_member_type#currentrow#" value="#ch_partner_type_value#">
											<input type="hidden" name="ch_member_id#currentrow#" id="ch_member_id#currentrow#" value="#member_id#">
											<div class="input-group">
												<input name="ch_member#currentrow#" type="text" id="ch_member#currentrow#" value="#member_name#">
												<span class="input-group-addon icon-ellipsis btnPointer" onClick="get_member(#currentrow#);"></span>
											</div>
										</div>
									</td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="<cfif len(expense_item_id)>#expense_item_id#</cfif>">
												<cfif len(expense_item_id)>
													<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
														SELECT EXPENSE_ITEM_NAME, EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID =#expense_item_id#
													</cfquery>
													<cfset expense_item_name_=GET_EXPENSE_ITEM.EXPENSE_ITEM_NAME>
												<cfelse>
													<cfset expense_item_name_=''>
												</cfif>
													<input name="expense_item#currentrow#" type="text" id="expense_item#currentrow#" value="#expense_item_name_#" onfocus="AutoComplete_Create('expense_item#currentrow#','EXPENSE_ITEM_NAME','EXPENSE_ITEM_NAME','get_expense_item','','EXPENSE_ITEM_ID','expense_item_id#currentrow#','list_cost','1');" autocomplete="off">
													<span class="input-group-addon icon-ellipsis" onclick="pencere_ac('#currentrow#');"></span>
												<cfif not(x_show_acc_code eq 1 and listfind('1,4',attributes.page_type))>
													<input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#account_code#">
													<input type="hidden" name="account_code#currentrow#" id="account_code#currentrow#" value="#account_code#">
												</cfif>
											</div>
										</div>
									</td>
									<cfif x_show_acc_code eq 1 and listfind('1,4',attributes.page_type)>
										<td>
											<div class="form-group">
												<div class="input-group">
													<input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#account_code#">
													<input type="text" name="account_code#currentrow#" id="account_code#currentrow#" value="#account_code#"><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('#currentrow#');"></span>
												</div>
											</div>
										</td>
									</cfif>
									<td><div class="form-group"><input type="text" name="detail#currentrow#" id="detail#currentrow#" value="#URLDecode(detail)#"></div></td>
									<td><div class="form-group"><input type="text" name="quantity#currentrow#" id="quantity#currentrow#" class="moneybox" value="#tlformat(quantity)#" onkeyup="return(FormatCurrency(this,event,0));"></div></td>
									<td><div class="form-group"><input type="text" name="amount#currentrow#" id="amount#currentrow#" class="moneybox"  value="#tlformat(other_cost,system_round_number)#" onblur="return toplam_kontrol();" onkeyup="return(FormatCurrency(this,event,system_round_number));"></div></td>
									<td>
										<div class="form-group">
											<select name="money_type#currentrow#" id="money_type#currentrow#" onchange="toplam_kontrol();">
												<cfset get_setup_money_id = trim(get_cost_detail.other_money)>
												<cfloop query="get_money">
													<option value="#money#;#rate1#;#rate2#" <cfif get_money.money eq get_setup_money_id>selected</cfif>>#money#</option>
												</cfloop>
											</select>
										</div>
									</td>
								</tr>
							</cfoutput>
						</cfif>
					</tbody>
				</cf_grid_list>
				<div class="ui-row">
					<div id="sepetim_total" class="padding-0">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='57677.Döviz'></span>
									<div class="collapse">
										<span class="icon-minus"></span>
									</div>
								</div>
								<div class="totalBoxBody">
									<table cellspacing="0">
										<cfoutput>
											<input type="hidden" name="deger_get_money" id="deger_get_money" value="#get_money.recordcount#">
											<cfif session.ep.rate_valid eq 1>
												<cfset readonly_info = "yes">
											<cfelse>
												<cfset readonly_info = "no">
											</cfif>
											<cfif len(get_cost_detail.FOREIGN_MONEY)>
												<cfset selected_money = get_cost_detail.FOREIGN_MONEY>
											<cfelse>
												<cfset selected_money = session.ep.money2>
											</cfif>
											<cfloop query="get_money">
												<cfif currentrow mod 2 eq 1>
													<tr>
												</cfif>
														<tr>
															<td><div class="form-group"><input type="radio" name="rd_money" id="rd_money_#get_money.currentrow#" value="#money#;#rate1#;#rate2#" onclick="toplam_kontrol();" <cfif (selected_money eq get_money.money)>checked</cfif>></div></td>
															<td><div class="form-group">#money#</div></td>
															<td><div class="form-group">#rate1#/</div></td>
															<td>
																<div class="form-group">
																	<input type="text" name="txt_rate2_#money#" id="txt_rate2_#money#" <cfif readonly_info>readonly</cfif> value="#TLFormat(rate2,system_round_number)#" onclick="toplam_kontrol();" class="moneybox" onkeyup="return(FormatCurrency(this,event,system_round_number));" onblur="if((this.value.length == 0) || filterNum(this.value) <=0 ) this.value=commaSplit(1,system_round_number);toplam_kontrol();" <cfif money eq session_base.money>readonly</cfif>>
																	<input type="hidden" name="txt_money_#money#" id="txt_money_#money#" value="#money#;#rate1#">
																	<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
																	<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
																</div>
															</td>
														</tr>
												<cfif currentrow mod 2 eq 0>
													</tr>
												</cfif>
											</cfloop>
										</cfoutput>
									</table>
								</div>
							</div>
						</div>
						<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='57492.Toplam'></span>
									<div class="collapse">
										<span class="icon-minus"></span>
									</div>
								</div>
								<div class="totalBoxBody">       
									<table cellspacing="0">
										<tr>
											<cfoutput> 
												<td class="txtbold">
													<div class="form-group">
														<label class="col col-4"><cf_get_lang dictionary_id='57492.Toplam'></label>
														<div class="col col-6"><input type="text" name="toplam_miktar" id="toplam_miktar" value="" class="moneybox" readonly=""></div>	
														<div class="col col-2"><cfoutput>#session.ep.money#</cfoutput></div>
													</div>
												</td>
											</cfoutput>
										</tr>
									</table>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<div class="totalBox">
								<div class="totalBoxHead font-grey-mint">
									<span class="headText"><cf_get_lang dictionary_id='40163.Toplam Miktar'></span>
									<div class="collapse">
										<span class="icon-minus"></span>
									</div>
								</div>
								<div class="totalBoxBody" id="totalAmountList">  
									<table>
										<tr>
											<cfoutput>
												<td class="txtbold">
													<div class="form-group">
														<label class="col col-4"><cf_get_lang dictionary_id='58124.Döviz Toplam'></label>
														<div class="col col-4"><input type="text" name="other_toplam" id="other_toplam" value="" class="moneybox" readonly=""></div>
														<div class="col col-4"><input type="text" name="doviz_name" id="doviz_name" value="" class="moneybox" readonly=""></div>
													</div>
												</td>
											</cfoutput>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</div>
				</div>				
				<cf_box_footer>
					<cfif get_cost_detail.recordcount>
						<cf_record_info query_name="get_cost_detail">
						<!---<cfif listfind('1,2,4,5',attributes.page_type,',')>--->
							<!--- <cfif (attributes.page_type eq 4 and x_acc_act eq 1) or (attributes.page_type eq 1 and x_acc_act_invoice eq 1)>
								<cf_workcube_buttons is_upd='1' is_cancel='0' insert_info='Muhasebeleştir' is_delete='0' add_function='kontrol(2)'>
							</cfif> --->							 
							<cfif listfind('1,2',attributes.page_type,',') and (GET_COST_DETAIL.recordcount)>
								<cfsavecontent  variable="title"><cf_get_lang dictionary_id='62508.Ürün Maliyetine Dağıt'></cfsavecontent>
								<cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="#title#" extraFunction='kontrol(2)'>
							</cfif>
							<cf_workcube_buttons is_upd='1' is_cancel='0' is_delete='0' add_function='kontrol(1)'>
						<!---</cfif>--->
						<!---<cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' add_function='kontrol(0)'>--->
					<cfelse>
						<cf_workcube_buttons is_upd='0' is_cancel='0' add_function='kontrol(1)'>
					</cfif>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
	<script type="text/javascript">
		row_count=<cfoutput>#row#</cfoutput>;
		system_round_number=<cfoutput>#system_round_number#</cfoutput>;
		function sil(sy)
		{
			var my_element=document.getElementById("row_kontrol"+sy);
			my_element.value=0;
	
			var my_element=document.getElementById("frm_row"+sy);
			my_element.style.display="none";
	
			toplam_kontrol();
		}
		
		function toplam_kontrol()
		{	
			var sira_no=0;
			sira_no=document.getElementById("record_num").value;
			toplam_al(sira_no);
			return true;
		}
	
		function toplam_al(sira)
		{	
			document.getElementById("toplam_miktar").value=0;
			var toplam_1=0;
			for(var i=1; i <= sira; i++)
				if(document.getElementById("row_kontrol"+i).value > 0)
				{
					var ara_toplam=document.getElementById("amount"+i);					
					if(ara_toplam!= null && ara_toplam.value != "")
					{	
						ara_toplam.value=filterNum(ara_toplam.value,system_round_number);
						deger_money_id =document.getElementById("money_type"+i).value;
						rate2_value = filterNum(document.getElementById("txt_rate2_"+list_getat(deger_money_id,1,';')).value,system_round_number);
						toplam_1 = toplam_1 + (parseFloat(ara_toplam.value) * (parseFloat(rate2_value) / parseFloat(list_getat(deger_money_id,2,';'))));
						ara_toplam.value=commaSplit(ara_toplam.value,system_round_number);
						document.getElementById("toplam_miktar").value=commaSplit(toplam_1,system_round_number);
					}
				}
			doviz_toplam();
		}
	
		function doviz_toplam()
		{
			toplam_miktar_son=filterNum(document.getElementById("toplam_miktar").value,system_round_number);
			for(s=1;s<=document.getElementById("deger_get_money").value;s++)
			{
				if(document.getElementById("rd_money_"+s).checked == true)
				{
					deger_diger_para = document.getElementById("rd_money_"+s).value;
					temp_checked_money = list_getat(deger_diger_para,1,';');
					temp_rate2=filterNum(document.getElementById("txt_rate2_"+temp_checked_money).value,system_round_number);
					if(toplam_miktar_son > 0)
						document.getElementById("other_toplam").value = commaSplit((toplam_miktar_son/temp_rate2),system_round_number);
					else
						document.getElementById("other_toplam").value=0;
					document.getElementById("doviz_name").value=temp_checked_money;
				}
			}	
		}
	
		function add_row()
		{		
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
	
			document.getElementById("record_num").value=row_count;
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';				
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><select name="dis_type' + row_count +'" id="dis_type' + row_count +'" style="width:100px;"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><option value="0"><cf_get_lang dictionary_id='60089.Parasal Değer'></option><option value="1"><cf_get_lang dictionary_id='29784.Ağırlık'></option><option value="2"><cf_get_lang dictionary_id='30114.Hacim'></option></select></div>';
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><select name="document_type_id' + row_count +'" id="document_type_id' + row_count +'" style="width:100px;"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_document_type"><option value="#document_type_id#">#document_type_name#</option></cfoutput></select></div>';
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><select name="tax_type_id' + row_count +'" id="tax_type_id' + row_count +'" style="width:100px;"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_tax_type"><option value="#tax_type_id#">#tax_type#</option></cfoutput></select></div>';
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="row_paper_no' + row_count +'" id="row_paper_no' + row_count +'" style="width:70px;" value=""></div>';
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.whiteSpace = 'nowrap';
			newCell.innerHTML = '<input type="hidden" name="ch_member_type'+ row_count +'" id="ch_member_type'+ row_count +'" value=""><input type="hidden" name="ch_member_id'+ row_count +'" id="ch_member_id'+ row_count +'" value="">';
			newCell.innerHTML += '<div class="form-group"><div class="input-group"><input name="ch_member'+ row_count +'" type="text" id="ch_member'+ row_count +'" value=""><span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="get_member('+row_count+');"></span></div></div>';


			newCell = newRow.insertCell(newRow.cells.length);
			newCell.style.whiteSpace = 'nowrap';
			newCell.innerHTML = '<input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'">';
			newCell.innerHTML +='<div class="form-group"><div class="input-group"><input type="text" name="expense_item' + row_count +'" id="expense_item' + row_count +'" value="" style="width:100px;" onFocus="AutoComplete_Create(\'expense_item' + row_count +'\',\'EXPENSE_ITEM_NAME\',\'EXPENSE_ITEM_NAME\',\'get_expense_item\',\'\',\'EXPENSE_ITEM_ID\',\'expense_item_id' + row_count +'\',\'list_cost\',1);" ><span class="input-group-addon icon-ellipsis" onClick="pencere_ac('+ row_count +');"></span>';
			
			<cfif x_show_acc_code eq 1 and listfind('1,4',attributes.page_type)>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.style.whiteSpace = 'nowrap';
				newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value=""><input type="text" style="width:100px;" name="account_code' + row_count +'" id="account_code' + row_count +'" value=""><span class="input-group-addon icon-ellipsis" onclick="pencere_ac_acc('+ row_count +');"></span></div></div>';
			<cfelse>
				newCell.innerHTML += '<input  type="hidden" name="account_id' + row_count +'" id="account_id' + row_count +'" value=""><input type="hidden" name="account_code' + row_count +'" id="account_code' + row_count +'" value="">';
			</cfif>
				
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><div class="form-group"><input type="text" name="detail' + row_count +'" id="detail' + row_count +'" style="width:130px;"></div>';
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" style="width:50px;" class="moneybox" onkeyup="return(FormatCurrency(this,event,0));"></div>';
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="amount' + row_count +'" id="amount' + row_count +'" style="width:80px;" class="moneybox" onkeyup="return(FormatCurrency(this,event,system_round_number));" onBlur="return toplam_al(row_count);"></div>';
	
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><select name="money_type' + row_count +'" id="money_type' + row_count +'" style="width:100px;"  onchange="toplam_kontrol();"><cfoutput query="get_money"><option value="#money#;#rate1#;#rate2#" <cfif get_money.MONEY eq session.ep.money>selected</cfif>>#money#</option></cfoutput></select></div>';
	
		}		
	
		function kontrol(update_type)
		{	
			<cfif isdefined("attributes.page_type") and listfind('1,4,5',attributes.page_type)>
				if(!chk_period(document.getElementById("paper_date"), 'İşlem')) return false;
			</cfif>
		
			if(document.getElementById('process_cat').value=='')
			{
				alert("<cf_get_lang dictionary_id='58770.işlem tipi seçiniz'>");
				return false;
			}
			doviz_toplam();
			if(update_type != 2)
			{
				for(var i=1; i<=row_count; i++)
				{
					if (document.getElementById("row_kontrol"+i).value != 0)
					{
						if(document.getElementById("amount"+i).value == "")
						{
							alert("<cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'>");
							return false;
						}
						if(document.getElementById("detail"+i).value == "")
						{
							alert("<cf_get_lang dictionary_id='33337.Açıklama Girmelisiniz'>!");
							return false;
						}
					}
				}
				if(document.getElementById("other_toplam").value != "")
				document.getElementById("other_toplam").value=filterNum(document.getElementById("other_toplam").value,system_round_number);
			
				document.getElementById("masraf_dagit").value=update_type;
				document.getElementById("acc_action").value=update_type;
				return true;
			}
			else 
			{
				windowopen('<cfoutput>#request.self#?fuseaction=invoice.popup_list_invoice_product_cost&iid=#url.id#</cfoutput>','medium');
			}
			/* else
			{
				<cfif attributes.page_type eq 4 and isdefined("get_process_cat") and get_process_cat.is_project_based_acc eq 1 and not len(cost_page_detail.project_id) and x_acc_act eq 1>
					alert("<cf_get_lang dictionary_id='60090.Proje Bazında Muhasebeleştirme Yapabilmek İçin İthal Mal Girişi Detayında Proje Seçmelisiniz'> !");
					return false;
				</cfif>
				<cfif attributes.page_type eq 1 and isdefined("get_process_cat") and get_process_cat.is_project_based_acc eq 1 and not len(cost_page_detail.project_id) and x_acc_act_invoice eq 1>
					alert("<cf_get_lang dictionary_id='60091.Proje Bazında Muhasebeleştirme Yapabilmek İçin Fatura Detayında Proje Seçmelisiniz'> !");
					return false;
				</cfif>
			} */
			
		}
		function unformat_fields()
		{
			for(var i=1; i<=row_count; i++)
			{
				if (document.getElementById("row_kontrol"+i).value != 0)
				{
					if(document.getElementById("amount"+i).value!= "")
						document.getElementById("amount"+i).value=filterNum(document.getElementById("amount"+i).value,system_round_number);
					if(document.getElementById("amount"+i).value!= "")				
						document.getElementById("quantity"+i).value=filterNum(document.getElementById("quantity"+i).value,system_round_number);
	
				}
			}
			<cfoutput query="get_money">
				document.getElementById("txt_rate2_#money#").value=filterNum(document.getElementById("txt_rate2_#money#").value,system_round_number);
			</cfoutput>
		}
		toplam_kontrol();
		function pencere_ac(no)
		{
			windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=list_cost.expense_item_id" + no +"&field_account_no=list_cost.account_code" + no +"&field_account_no2=list_cost.account_id" + no +"&field_name=list_cost.expense_item"+ no,'list');
		}
		function pencere_ac_acc(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=list_cost.account_id' + no +'&field_name=list_cost.account_code' + no +'','list');
		}	
		function get_member(no)
		{
			adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_cari_action=1';
			adres_ += '&field_comp_id=list_cost.ch_member_id'+no;
			adres_ += '&field_comp_name=list_cost.ch_member'+no;	
			adres_ += '&field_consumer=list_cost.ch_member_id'+no;
			adres_ += '&field_member_name=list_cost.ch_member'+no;
			adres_ += '&field_emp_id=list_cost.ch_member_id'+no;
			adres_ += '&field_name=list_cost.ch_member'+no;
			adres_ += '&field_type=list_cost.ch_member_type'+no;
			adres_ += '&select_list=1,2,3';
			windowopen(adres_,'list');
		}											
	</script>
	