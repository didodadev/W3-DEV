<!---<cf_get_lang_set module_name="sales">--->
 <cfset member_name_="">
                    <input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>">
                    <input type="hidden" name="req_id" id="req_id" value="<cfoutput>#get_opportunity.req_id#</cfoutput>">
                    <input type="hidden" name="old_process_stage" id="old_process_stage" value="#get_opportunity.req_stage#">
                    <div class="row" type="row" >
                        <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-opp_no">
										<label class="col col-4 col-sm-12">Model No</label>
										<div class="col col-4 col-sm-12" extra_checkbox="req_status">
											<input type="hidden" name="req_id2" id="req_id2" value="<cfoutput>#get_opportunity.req_id# </cfoutput>" readonly>
											<input type="text" name="req_no" id="req_no" value="<cfoutput>#get_opportunity.req_no#</cfoutput>" readonly>
										</div>
										<label class="col col-4 col-xs-12" extra_checkbox="opp_status" ><input type="checkbox" name="opp_status" id="opp_status" value="1" <cfif get_opportunity.req_status>checked</cfif>><cf_get_lang_main no='81.Aktif'></label>
									</div>
								<div class="form-group" id="item-opp_stage">
									<label class="col col-4 col-sm-12"><cf_get_lang_main no='1447.Süreç'> *</label>
									<div class="col col-8 col-sm-12">
										<cf_workcube_process is_upd='0' select_value='#get_opportunity.req_stage#' process_cat_width='140' is_detail='1'>
									</div>
								</div>
								<div class="form-group" id="item-opportunity_type_id">
									<label class="col col-4 col-sm-12">Model Kategorisi</label>
									<div class="col col-8 col-sm-12">
										<select name="opportunity_type_id" id="opportunity_type_id">
											<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
											<cfoutput query="get_opportunity_type">
												<option value="#opportunity_type_id#" <cfif opportunity_type_id eq get_opportunity.req_type_id>selected</cfif>>#opportunity_type#</option>
											</cfoutput>
										</select>
									</div>
								</div>
								 <div class="form-group" id="item-opp_date">
									<label class="col col-4 col-sm-12">Tarih</label>
									<div class="col col-8 col-sm-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
											<input type="text" name="opp_date" id="opp_date" value="<cfoutput>#dateformat(get_opportunity.req_date,dateformat_style)#</cfoutput>"  maxlength="10"  style="width:70px;">
											<span class="input-group-addon"><cf_wrk_date_image date_field="opp_date" call_function="change_money_info"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-sales_emp_id">
									<label class="col col-4 col-sm-12">Müşteri Temsilcisi</label>
									<div class="col col-8 col-sm-12">
										<input type="hidden" name="sales_emp_id" id="sales_emp_id" value="<cfoutput>#get_opportunity.sales_emp_id#</cfoutput>">
										<div class="input-group">
											<input type="text" name="sales_emp" id="sales_emp" value="<cfif len(get_opportunity.sales_emp_id)><cfoutput>#get_emp_info(get_opportunity.sales_emp_id,0,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','','3','140');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_opp.sales_emp_id&field_name=upd_opp.sales_emp&select_list=1','list');"></span>
										</div>
									</div>
								</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-detail">
								<label class="col col-4 col-sm-12">Açıklama</label>
								<div class="col col-8 col-sm-12">
										<textarea name="req_detail" id="req_detail" ><cfoutput>#get_opportunity.req_detail#</cfoutput></textarea>
								</div>
							</div>
							<div class="form-group" id="item-desing_emp_id">
								<label class="col col-4 col-sm-12">Tasarımcı</label>
								<div class="col col-8 col-sm-12">
									<input type="hidden" name="desing_emp_id" id="desing_emp_id" value="<cfoutput>#get_opportunity.desing_emp_id#</cfoutput>">
									<div class="input-group">
										<input type="text" name="desing_emp" id="desing_emp" value="<cfif len(get_opportunity.desing_emp_id)><cfoutput>#get_emp_info(get_opportunity.desing_emp_id,0,0)#</cfoutput></cfif>" onFocus="AutoComplete_Create('desing_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','desing_emp_id','','3','140');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_opp.desing_emp_id&field_name=upd_opp.desing_emp&select_list=1','list');"></span>
									</div>
								</div>
							</div>
						</div>                     
                    </div>
					<cfoutput>
					<div class="row" type="row">
						  <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="3" sort="true">
								<span><strong><h4><b>Müşteri Detayları</b></h4></strong></span>
									<div class="form-group" id="item-company">
									<label class="col col-4 col-sm-12"><cf_get_lang_main no='45.Müşteri'> *</label>
										<div class="col col-8 col-sm-12">
											<input type="hidden" name="old_company_id" id="old_company_id" value="#get_opportunity.company_id#">
											<cfif len(get_opportunity.partner_id)>
												<input type="hidden" name="company_id" id="company_id" value="#get_opportunity.company_id#">
												<input type="hidden" name="member_type" id="member_type" value="partner">
												<input type="hidden" name="member_id" id="member_id" value="#get_opportunity.partner_id#">
												<input type="hidden" name="old_member_id" id="old_member_id" value="#get_opportunity.partner_id#">
												<div class="input-group">
													<input type="text" name="company" id="company" value="#get_par_info(get_opportunity.company_id,1,0,0)#" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_partner=upd_opp.member_id&field_consumer=upd_opp.member_id&field_comp_id=upd_opp.company_id&field_comp_name=upd_opp.company&function_name=fill_country&field_name=upd_opp.member&field_type=upd_opp.member_type&select_list=7,8','list');"></span>
												</div>
											<cfelseif len(get_opportunity.consumer_id)>
												<input type="hidden" name="company_id" id="company_id" value="#get_opportunity.company_id#">
												<input type="hidden" name="member_type" id="member_type" value="consumer">
												<input type="hidden" name="member_id" id="member_id"  value="#get_opportunity.consumer_id#">
												<input type="hidden" name="old_member_id" id="old_member_id" value="#get_opportunity.consumer_id#">
												<div class="input-group">
													<input type="text" name="company" id="company"  value="" readonly onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_partner=upd_opp.member_id&field_consumer=upd_opp.member_id&field_comp_id=upd_opp.company_id&field_comp_name=upd_opp.company&function_name=fill_country&field_name=upd_opp.member&field_type=upd_opp.member_type&select_list=7,8','list');"></span>
												</div>
											<cfelse>
												<input type="hidden" name="company_id" id="company_id" value="">
												<input type="hidden" name="member_type" id="member_type" value="">
												<input type="hidden" name="member_id" id="member_id" value="">
												<input type="hidden" name="old_member_id" id="old_member_id"  value="">
												<div class="input-group">
													<input type="text" name="company" id="company"  value="" onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_partner=upd_opp.member_id&field_consumer=upd_opp.member_id&field_comp_id=upd_opp.company_id&field_comp_name=upd_opp.company&function_name=fill_country&field_name=upd_opp.member&field_type=upd_opp.member_type&select_list=7,8','list');"></span>
												</div>
											</cfif>
										</div>
								</div>
						
								   <div class="form-group" id="item-member">
										<label class="col col-4 col-sm-12"><cf_get_lang_main no='166.Yetkili'></label>
										<div class="col col-8 col-sm-12">
											<cfif len(get_opportunity.partner_id)>
												<input type="text" name="member" id="member" value="#get_par_info(get_opportunity.partner_id,0,-1,0)#" readonly>
											<cfelseif len(get_opportunity.consumer_id)>
												<input type="text" name="member" id="member" value="#get_cons_info(get_opportunity.consumer_id,0,0,0)#" readonly>
											<cfelse>
												<input type="text" name="member" id="member" value="" readonly>
											</cfif>
										</div>
									</div>
								<div class="form-group" id="item-invoice-company">
									<label class="col col-4 col-sm-12">Fatura Müşterisi </label>
									<div class="col col-8 col-sm-12">
										<input type="hidden" name="invoice_company_id" id="invoice_company_id" value="#get_opportunity.invoice_company_id#">
										<input type="hidden" name="invoice_member_type" id="invoice_member_type" value="">
										<input type="hidden" name="invoice_member_id" id="invoice_member_id" value="">
										<input type="hidden" name="invoice_old_member_id" id="invoice_old_member_id"  value="">
										<div class="input-group">
											<input type="text" name="invoice_company" id="invoice_company"  value="#get_opportunity.INVOICE_COMPANY#" onFocus="AutoComplete_Create('invoice_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','invoice_company_id,invoice_member_type,invoice_member_id,invoice_member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_partner=upd_opp.invoice_member_id&field_consumer=upd_opp.invoice_member_id&field_comp_id=upd_opp.invoice_company_id&field_comp_name=upd_opp.invoice_company&function_name=fill_country&field_name=upd_opp.invoice_member&field_type=upd_opp.invoice_member_type&select_list=7,8','list');"></span>
										</div>
									</div>
									<!--- 
									<div class="col col-8 col-sm-12">
										<input type="hidden" name="invoice_company_id" id="invoice_company_id" value="#get_opportunity.invoice_company_id#" readonly>
										<input type="text" disabled name="invoice_company" id="invoice_company" value="#get_opportunity.INVOICE_COMPANY#" readonly>
									</div> --->
								</div>
										
								 <div class="form-group" id="item-order-no">
									 <label class="col col-4 col-sm-12">Order No</label>
										<div class="col col-8 col-sm-12">
											<input type="text" name="order_no" value="#get_opportunity.company_order_no#">
										</div>
								  </div>
								   <div class="form-group" id="item-project">
									 <label class="col col-4 col-sm-12">Proje No</label>
										<div class="col col-8 col-sm-12">
											<input type="hidden" name="project_id" id="project_id" value="#get_opportunity.project_id#">
												<input type="text" disabled name="project_head" id="project_head" value="<cfif len(get_opportunity.project_id)>#get_opportunity.PROJECT_HEAD#</cfif>"   onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
												<!---<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_projects&project_id=upd_opp.project_id&project_head=upd_opp.project_head','list');"></span>--->
										</div>
								  </div>
								  <div class="form-group" id="item-main-project">
									 <label class="col col-4 col-sm-12">Ana Sipariş Projesi</label>
										<div class="col col-8 col-sm-12">
											<input type="hidden" name="main_project_id" id="main_project_id" value="#get_opportunity.RELATED_PROJECT_ID#">
												<input type="text" disabled name="main_project_head" id="main_project_head" value="<cfif len(get_opportunity.RELATED_PROJECT_HEAD)>#get_opportunity.RELATED_PROJECT_HEAD#</cfif>"   onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
												<!---<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_projects&project_id=upd_opp.project_id&project_head=upd_opp.project_head','list');"></span>--->
										</div>
								  </div>
								   <div class="form-group" id="item-opp_invoice_date">
										     <label class="col col-4 col-sm-12">Teslim Tarihi</label>
										<div class="col col-8 col-sm-12">
											<div class="input-group">
												<input type="text" name="opp_invoice_date" id="opp_invoice_date" value="#dateformat(get_opportunity.invoice_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
												<span class="input-group-addon"><cf_wrk_date_image date_field="opp_invoice_date"></span>
											</div>
										</div>
									</div>
						</div>
						 <div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="4" sort="true">
							<span><h4><b>Ürün Detayları</b></h4></span>
								 <div class="form-group" id="item-product_cat_id">
									<label class="col col-4 col-sm-12"><cf_get_lang_main no='1604.Ürün Kategorisi'></label>
									<div class="col col-8 col-sm-12" style="font-size: 14px;">
										<cfif len(get_opportunity.product_cat_id)>
											<cfset attributes.id = get_opportunity.product_cat_id>
											<cfinclude template="/V16/product/query/get_product_cat.cfm">
											<input type="hidden" name="product_cat_id" id="product_cat_id" value="#get_opportunity.product_cat_id#">
											<div class="input-group" style="font-size: 14px;">
												<cfif not len(get_product_cat.product_cat)>
													<input type="text" name="product_cat" id="product_cat" value="#get_product_cat.hierarchy# #get_product_cat.product_cat#" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','175');" autocomplete="off">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_cat_names&field_id=upd_opp.product_cat_id&field_name=upd_opp.product_cat','list');"></span>
												<cfelse>
													<input type="hidden" name="product_cat" id="product_cat" value="#get_product_cat.hierarchy# #get_product_cat.product_cat#">
													#get_product_cat.hierarchy# #get_product_cat.product_cat#
												</cfif>
											</div>
										<cfelse>
											<input type="hidden" name="product_cat_id" id="product_cat_id" value="">
											<div class="input-group" >
												<input type="text" name="product_cat" id="product_cat" value="" onFocus="AutoComplete_Create('product_cat','HIERARCHY,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','175');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_product_cat_names&field_id=upd_opp.product_cat_id&field_name=upd_opp.product_cat','list');"></span>
											</div>
										</cfif>
									</div>
								</div>
								 <div class="form-group" id="item-stock_id">
									<label class="col col-4 col-sm-12">Ürün Kodu</label>
									<div class="col col-8 col-sm-12">
										<input type="hidden" name="stock_id" id="stock_id" value="#get_opportunity.stock_id#">
										<cfif len(get_opportunity.stock_id)>
											<cfset attributes.stock_id = get_opportunity.stock_id>
											<cfinclude template="/V16/sales/query/get_stock_name.cfm">
										</cfif>
										<div class="input-group">
												<cfif not len(get_opportunity.stock_id)>
													<input type="text" name="stock_name" id="stock_name" value="<cfif len(get_opportunity.stock_id)>#get_stock_name.product_name#</cfif>">
												<cfelse>
															<label class="hide">Ürün No</label>
															<!---#get_stock_name.product_name#--->
															<input type="hidden" name="stock_name" id="stock_name" value="<cfif len(get_opportunity.stock_id)>#get_stock_name.product_name#</cfif>">
															<a class="tableyazi" style="font-size: 14px;" href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.list_product&event=det&pid=#get_opportunity.product_id#','page');">#get_stock_name.product_name#</a>											
												</cfif>
										</div>
									</div>
								</div>
									<div class="form-group" id="item-short_code_name">
										<label class="col col-4 col-sm-12"><cf_get_lang_main no='813.Model'></label>
													<cfset deger = "">
										<div class="col col-8 col-sm-12" style="font-size: 14px;">
											<cfif not len(get_opportunity.short_code_id)>
																	<cf_wrkproductmodel
														returninputvalue="short_code_id,short_code,short_code_name"
														returnqueryvalue="MODEL_ID,MODEL_CODE,MODEL_NAME"
														width="140"
														fieldname="short_code_name"
														fieldid="short_code_id"
														fieldcode="short_code"
														compenent_name="getProductModel"            
														boxwidth="300"
														boxheight="150"
														control_field_id="#deger#"
														control_field_name="brand_name"
														control_field_message="Marka Seçiniz!"
														model_id="#get_opportunity.short_code_id#">
														<input type="hidden" name="old_short_code" id="old_short_code" value="<cfoutput>#get_opportunity.short_code#</cfoutput>">
										<cfelse>
												<input type="hidden" name="old_short_code" id="old_short_code" value="<cfoutput>#get_opportunity.short_code#</cfoutput>">
												<input type="hidden" name="short_code" id="short_code" value="<cfoutput>#get_opportunity.short_code#</cfoutput>">
												<input type="hidden" name="short_code_id" id="short_code_id" value="<cfoutput>#get_opportunity.short_code_id#</cfoutput>">
												#get_opportunity.short_code#
										</cfif>
										</div>
									</div>
								   <div class="form-group" id="item-model-no">
									 <label class="col col-4 col-sm-12">Müşteri Model No</label>
										<div class="col col-8 col-sm-12">
											<input type="text" name="musteri_model_no" value="<cfoutput>#get_opportunity.company_model_no#</cfoutput>">
										</div>
								  </div>
								  <div class="form-group" id="item-ok-price">
									 <label class="col col-4 col-sm-12">Satış Fiyatı</label>
										<div class="col col-2 col-sm-2">
											<input type="text" name="config_price_other" class="box" readonly value="#tlformat(get_opportunity.config_price_other)#">	
										</div>
										<div class="col col-2 col-sm-2">
												#get_opportunity.config_price_money#
										</div>
								  </div>
								
						 </div>
					</div>
                    <div class="row formContentFooter">
                        <div class="col col-6"><cf_record_info query_name="get_opportunity" is_partner='1'></div>
                        <div class="col col-6">
                            <cfif get_opportunity.is_processed eq 1>
                                <div style="padding:3px; float:right;"><font color="red"><strong><cf_get_lang no='139.Islendi'></strong></font></div>
                            <cfelse>
							<cfif attributes.fuseaction eq 'textile.list_sample_request' and attributes.event eq 'det'>
								<cfset url.req_id=attributes.req_id>
                               <cf_workcube_buttons is_upd='1' is_delete="0" type_format="1" delete_page_url='#request.self#?fuseaction=textile.emptypopup_del_req&req_id=#url.req_id#&opportunity_no=#get_opportunity.req_no#&head=#get_opportunity.req_head#&cat=#get_opportunity_type.opportunity_type_id#' add_function='kontrol()'>
							</cfif>
								
                            </cfif>
                        </div>
                    </div>
				</cfoutput>	
				<script>
					$("#company_detay input").prop('disabled', true);
				</script>