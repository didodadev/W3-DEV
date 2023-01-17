<!--- Kopyalandigi satis faturasinin kaydeden kismini da getiriyordu. Onu Kaldirdim. M.E.Y 20120816 --->
<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="invoice.form_add_bill">
<cfinclude template="../query/get_sale_det.cfm">
<cfif not get_sale_det.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id="57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı"> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfinclude template="../query/get_session_cash_all.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfparam name="attributes.company_id" default="#get_sale_det.company_id#">
<cfparam name="attributes.invoice_number" default="">
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfset pageHead = #getLang('invoice', 383)#>
<cfset paper_type = 'invoice'>
<cfif len(get_sale_det.company_id)>
	<cfquery name="get_comp_info" datasource="#dsn#">
		SELECT FULLNAME,USE_EFATURA,EFATURA_DATE FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.company_id#">
	</cfquery>
	<cfif session.ep.our_company_info.is_efatura eq 1 and len(get_comp_info.use_efatura) and get_comp_info.use_efatura eq 1 and datediff('d',dateformat(get_comp_info.efatura_date,dateformat_style),dateformat(now(),dateformat_style)) gte 0>
		<cfset paper_type = 'e_invoice'>
	</cfif>
	<cfset member_account_code = get_company_period(get_sale_det.company_id)>
<cfelseif len(get_sale_det.consumer_id)>
	<cfquery name="get_cons_info_" datasource="#dsn#">
		SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FULLNAME,USE_EFATURA,EFATURA_DATE FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sale_det.consumer_id#">
	</cfquery>
	<cfif session.ep.our_company_info.is_efatura eq 1 and  len(get_cons_info_.use_efatura) and get_cons_info_.use_efatura eq 1 and datediff('d',dateformat(get_cons_info_.efatura_date,dateformat_style),dateformat(now(),dateformat_style)) gte 0>
		<cfset paper_type = 'e_invoice'>
	</cfif>
	<cfset member_account_code = get_consumer_period(get_sale_det.consumer_id)>
<cfelseif len(get_sale_det.employee_id)>
	<cfset member_account_code = get_employee_period(get_sale_det.employee_id)>
</cfif>
<cf_catalystHeader>
<div id="basket_main_div">
<cf_papers paper_type="#paper_type#" form_name="form_basket" form_field="invoice_number">
	<cfform name="form_basket" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill" method="post">
    	<cf_basket_form id="copy_bill">
			<cfoutput>
                <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_bill">
                <input type="hidden" name="paper" id="paper" value="<cfif isDefined('paper_number')>#paper_number#</cfif>">
                <input type="hidden" name="paper_printer_id" id="paper_printer_id" value="<cfif isDefined('paper_printer_code')>#paper_printer_code#</cfif>">
                <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
                <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
                <input type="hidden" name="member_account_code" id="member_account_code" value="#member_account_code#">
            </cfoutput>
            <div class="row">
                    <div class="col col-12 uniqueRow">
                        <div class="row">
                            <div class="row" type="row">
                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                    <div class="form-group" id="item-process_cat">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'> *</label>
                                        <div class="col col-8 col-xs-12">
                                            <cf_workcube_process_cat onclick_function="kontrol_yurtdisi();check_process_is_sale();" process_cat="#get_sale_det.process_cat#" slct_width="140">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-comp_name">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari hesap'> *</label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <cfoutput>
                                                	<input type="hidden" name="company_id" id="company_id" value="#get_sale_det.company_id#">
													<cfif len(get_sale_det.company_id) and get_sale_det.company_id neq 0>
                                                        <input type="text" name="comp_name" id="comp_name" value="#get_sale_det_comp.fullname#" readonly style="width:140px;">
                                                    <cfelseif len(get_sale_det.consumer_id)>
                                                        <input type="text" name="comp_name" id="comp_name" value="#get_cons_name.company#" readonly style="width:140px;">
                                                    <cfelse>
                                                        <input type="text" name="comp_name" id="comp_name" value="" readonly style="width:140px;">
                                                    </cfif>
                                                </cfoutput>
                                                <cfset str_linkeait="&field_revmethod_id=form_basket.paymethod_id&field_revmethod=form_basket.paymethod&field_basket_due_value_rev=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&call_function=add_general_prom()-check_member_price_cat()">
                                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_adress_id=form_basket.ship_address_id&is_cari_action=1&select_list=2,3,1,9&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_emp_id=form_basket.employee_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&field_member_account_code=form_basket.member_account_code#str_linkeait#&come=invoice&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name&field_long_address=form_basket.adres&field_city_id=form_basket.city_id&field_county_id=form_basket.county_id&field_cons_ref_code=form_basket.consumer_reference_code<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list');"></span>
                                            </div>
                                        </div>
                                    </div>
                                   	<div class="form-group" id="item-partner_name">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
                                        <div class="col col-8 col-xs-12">
                                            <cfoutput>
											<cfset emp_id = get_sale_det.employee_id>
                                            <cfif len(get_sale_det.ACC_TYPE_ID)>
                                                <cfset emp_id = "#emp_id#_#get_sale_det.ACC_TYPE_ID#">
                                            </cfif>
                                                <input type="hidden" name="partner_reference_code" id="partner_reference_code" value="#get_sale_det.partner_reference_code#">
                                                <input type="hidden" name="partner_id" id="partner_id" value="#get_sale_det.partner_id#">
                                                <input type="hidden" name="consumer_reference_code" id="consumer_reference_code" value="#get_sale_det.consumer_reference_code#">
                                                <input type="hidden" name="consumer_id" id="consumer_id" value="#get_sale_det.consumer_id#">
                                                <input type="hidden" name="employee_id" id="employee_id" value="#emp_id#">
                                                <cfset str_par_names = "">
                                                <cfif len(GET_SALE_DET.PARTNER_ID)>
                                                	<cfset str_par_names = "#GET_SALE_DET_CONS.COMPANY_PARTNER_NAME# #GET_SALE_DET_CONS.COMPANY_PARTNER_SURNAME#">
                                                <cfelseif len(get_sale_det.consumer_id)>
                                                	<cfset str_par_names = "#get_cons_name.consumer_name# #get_cons_name.consumer_surname#">
                                                <cfelseif len(get_sale_det.employee_id)>
                                                	<cfset str_par_names = "#get_emp_info(get_sale_det.employee_id,0,0,0,get_sale_det.ACC_TYPE_ID)#">
                                                </cfif>
                                                <input type="text" name="partner_name" id="partner_name" value="#str_par_names#" readonly style="width:140px;">						
                                            </cfoutput>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-irsaliye">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57773.İrsaliye'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="">
                                                <input type="text" name="irsaliye" id="irsaliye"  style="width:140px;" value="" readonly>
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="add_irsaliye();"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-deliver_get">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <cfoutput><input type="text" name="deliver_get" id="deliver_get" style="width:140px;" value="#get_sale_det.deliver_emp#"></cfoutput>
												<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_rate_select=1&select_list=2,3,4,5,6&field_name=form_basket.deliver_get&come=stock&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value</cfoutput>','list');"></span>
                                            </div>
                                        </div>
                                    </div>
                                   	<cfif session.ep.our_company_info.subscription_contract eq 1>
                                        <div class="form-group" id="item-subscription_id">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
                                            <div class="col col-8 col-xs-12">
                                                <cfif isdefined("get_sale_det.subscription_id") and len(get_sale_det.subscription_id)>
                                                <cf_wrk_subscriptions width_info='140' subscription_id='#get_sale_det.subscription_id#'  fieldId='subscription_id' fieldName='subscription_no' form_name='form_basket' img_info='plus_thin'>
                                            <cfelse>
                                                <cf_wrk_subscriptions width_info='140' fieldId='subscription_id' fieldName='subscription_no' form_name='form_basket' img_info='plus_thin'>
                                            </cfif>
                                            </div>
                                        </div>
                                    </cfif>
                                    <div class="form-group" id="item-order_id_form">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57611.sipariş'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="order_id_listesi" id="order_id_listesi" value="">
                                                <input type="text" name="order_id_form" id="order_id_form" value=""readonly style="width:135px;">
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="add_order();"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="add_info_plus"></div><!--- isbak için eklendi kaldırmayınız sm --->
                                </div>
                        		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                	<div class="form-group" id="item-serial_number">
                                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57637.Seri No'> *</label>
                                        <div class="col col-8 col-xs-12">
                                        	<div class="input-group">
                                            	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57184.Fatura No Girmelisiniz!'></cfsavecontent>
                                                <cfif isDefined('paper_full')>
                                                    <cfinput type="text" maxlength="5" name="serial_number" value="#paper_code#" style="width:20px;">
                                                    <span class="input-group-addon no-bg"> - </span>
                                                    <cfinput type="text" maxlength="50" name="serial_no" value="#paper_number#" required="Yes" message="#message#" style="width:70px;" onBlur="check_invoice_type();">
                                                <cfelse>
                                                    <cfinput type="text" maxlength="5" name="serial_number" value="" style="width:20px;">
                                                    <span class="input-group-addon no-bg"> - </span>
                                                    <cfinput type="text" maxlength="50" name="serial_no" value="" required="Yes" message="#message#" style="width:70px;" onBlur="check_invoice_type();">
                                                </cfif>
                                            </div>
                                        </div>
                                    </div>
                                	<div class="form-group" id="item-invoice_date">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'> *</label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'></cfsavecontent>
                                    			<cfinput type="text" name="invoice_date" style="width:100px;" required="yes" message="#message#" value="#dateformat(now(),dateformat_style)#" onChange="check_member_price_cat();change_paper_duedate('invoice_date');" validate="#validate_style#" readonly="yes">
                                    			<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="invoice_date" call_function="add_general_prom&change_money_info"></span>&nbsp;
                                                <cfoutput>
													<cfset value_invoice_date_h = hour(now())>
													<cfset value_invoice_date_m = minute(now())>
												<span class="input-group-addon">					
													<cf_wrkTimeFormat name="invoice_date_h" value="#value_invoice_date_h#">
												</span>
												<span class="input-group-addon">
													<select name="invoice_date_m" id="invoice_date_m">
														<cfloop from="0" to="59" index="i">
															<option value="#i#" <cfif value_invoice_date_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#i# </option>
														</cfloop>
													</select>														
												</span>
											</cfoutput>  
                                            </div>
                                        </div>
                                    </div>
									<cfif xml_show_ship_date eq 1>
                                        <div class="form-group" id="item-ship_date">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57009.Fiili Sevk Tarihi'></label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
                                    				<cfinput type="text" name="ship_date" id="ship_date" style="width:100px;" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10">
													<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="ship_date"></span>
                                                </div>
                                            </div>
                                        </div>
                                    </cfif>
                                  	<div class="form-group" id="item-PARTNER_NAMEO">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57321.Satış Çalışanı'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <cfif not len(get_sale_det.sale_emp) and not len(get_sale_det.sale_partner)>
                                                    <input type="hidden" name="EMPO_ID" id="EMPO_ID">
                                                    <input type="hidden" name="PARTO_ID" id="PARTO_ID">
                                                    <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="" readonly style="width:135px;">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&is_rate_select=1&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID</cfoutput>','list')"></span>
                                                <cfelse>
                                                    <cfoutput>
                                                    <input type="hidden" name="EMPO_ID" id="EMPO_ID" value="#get_sale_det.sale_emp#">
                                                    <input type="hidden" name="PARTO_ID" id="PARTO_ID" value="#get_sale_det.sale_partner#">
                                                    <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" <cfif len(get_sale_det.sale_partner) >value="#get_par_info(get_sale_det.sale_partner,0,0,0)#"<cfelse> value="#get_emp_info(get_sale_det.SALE_EMP,0,0)#"</cfif>disabled style="width:135px;">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&is_rate_select=1&select_list=1&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID','list')"></span>
                                                    </cfoutput>
                                                </cfif>				
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-sales_member">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57322.Satis Ortagi'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
												<cfif len(get_sale_det.sales_partner_id)>
                                                    <input type="hidden" name="sales_member_id" id="sales_member_id" value="<cfoutput>#get_sale_det.sales_partner_id#</cfoutput>">
                                                    <input type="hidden" name="sales_member_type" id="sales_member_type" value="partner">
                                                    <input type="text" name="sales_member" id="sales_member" style="width:135px;" value="<cfoutput>#get_par_info(get_sale_det.sales_partner_id,0,-1,0)#</cfoutput>">
                                                <cfelseif len(get_sale_det.sales_consumer_id)>
                                                    <input type="hidden" name="sales_member_id" id="sales_member_id" value="<cfoutput>#get_sale_det.sales_consumer_id#</cfoutput>">
                                                    <input type="hidden" name="sales_member_type" id="sales_member_type" value="consumer">
                                                    <input type="text" name="sales_member" id="sales_member" style="width:135px;" value="<cfoutput>#get_cons_info(get_sale_det.sales_consumer_id,0,0)#</cfoutput>">
                                                <cfelse>
                                                    <input type="hidden" name="sales_member_id" id="sales_member_id" value="">
                                                    <input type="hidden" name="sales_member_type" id="sales_member_type" value="">
                                                    <input type="text" name="sales_member" id="sales_member" style="width:135px;" value="">
                                                </cfif>
                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_rate_select=1&field_id=form_basket.sales_member_id&field_name=form_basket.sales_member&field_type=form_basket.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3','list','popup_list_pars');"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <cfif xml_acc_department_info>
                                        <div class="form-group" id="item-acc_department_id">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
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
											<cfset attributes.department_id = get_sale_det.DEPARTMENT_ID>
                                            <cfinclude template="../query/get_dept_name.cfm">
                                            <cfset txt_department_name = get_dept_name.DEPARTMENT_HEAD>
                                            <cfset branch_id = get_dept_name.BRANCH_ID>
                                            <cfif len(get_sale_det.DEPARTMENT_LOCATION)>
                                            <cfset attributes.location_id = get_sale_det.DEPARTMENT_LOCATION>
                                            <cfinclude template="../query/get_location_name.cfm">
                                            <cfset txt_department_name = txt_department_name & "-" & get_location_name.COMMENT>
                                            </cfif>
                                            <cf_wrkdepartmentlocation
                                                returnInputValue="location_id,department_name,department_id,branch_id"
                                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                fieldName="department_name"
                                                fieldId="location_id"
                                                department_fldId="department_id"
                                                branch_fldId="branch_id"
                                                branch_id="#branch_id#"
                                                department_id="#get_sale_det.department_id#"
                                                location_id="#get_sale_det.department_location#"
                                                location_name="#txt_department_name#"
                                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                width="135">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-ship_method">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#get_sale_det.SHIP_METHOD#</cfoutput>">
												<cfif len(get_sale_det.ship_method)>
													<cfset attributes.ship_method_id=get_sale_det.ship_method>
                                                    <cfinclude template="../query/get_ship_methods.cfm">
                                                </cfif>
                                                <input type="text" name="ship_method_name" id="ship_method_name" style="width:135px;" value="<cfif len(get_sale_det.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>" >
                        						<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-paymethod">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <cfset card_link="&function_name=change_paper_duedate&function_parameter=invoice_date&field_dueday=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate">
												<cfif len(get_sale_det.pay_method)>
                                                    <cfset attributes.paymethod_id=get_sale_det.pay_method>
                                                    <cfinclude template="../query/get_paymethod.cfm">
                                                    <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_sale_det.pay_method#</cfoutput>">
                                                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                                                    <input type="hidden" name="commission_rate" id="commission_rate" value="">							
                                                    <input type="text" name="paymethod" id="paymethod" style="width:135px;" value="<cfoutput>#get_paymethod.paymethod#</cfoutput>" readonly>
                                                <cfelseif len(get_sale_det.card_paymethod_id)>
                                                    <cfquery name="get_card_paymethod" datasource="#dsn3#">
                                                        SELECT 
                                                        CARD_NO
                                                        <cfif get_sale_det.commethod_id eq 6> <!--- WW den gelen siparişlerin guncellemesi, (siparisin commethod_id si faturaya tasınıyor) --->
                                                            ,PUBLIC_COMMISSION_MULTIPLIER AS COMMISSION_MULTIPLIER
                                                        <cfelse>  <!--- EP VE PP den gelen siparişlerin guncellemesi --->
                                                            ,COMMISSION_MULTIPLIER 
                                                        </cfif>
                                                        FROM 
                                                        CREDITCARD_PAYMENT_TYPE 
                                                        WHERE 
                                                        PAYMENT_TYPE_ID=#get_sale_det.card_paymethod_id#
                                                    </cfquery>
                                                    <cfoutput>
                                                        <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                                                        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_sale_det.card_paymethod_id#">
                                                        <input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
                                                        <input type="text" name="paymethod" id="paymethod" style="width:135px;" value="#get_card_paymethod.card_no#" readonly>
                                                    </cfoutput>
                                                <cfelse>
                                                    <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                                                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                                                    <input type="hidden" name="commission_rate" id="commission_rate" value="">
                                                    <input type="text" name="paymethod" id="paymethod" style="width:135px;" value="" readonly>
                                                </cfif>
                                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod#card_link#</cfoutput>','list');"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-basket_due_value">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                            	<input name="basket_due_value" id="basket_due_value" type="text" value="<cfif len(get_sale_det.due_date) and len(get_sale_det.invoice_date)><cfoutput>#datediff('d',get_sale_det.invoice_date,get_sale_det.due_date)#</cfoutput></cfif>"onChange="change_paper_duedate('invoice_date');" style="width:43px;">
                                				<span class="input-group-addon no-bg"></span>
                                                <cfinput type="text" name="basket_due_value_date_" value="#dateformat(get_sale_det.due_date,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" style="width:90px;" readonly>
                                				<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-ship_address_id">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57248.Sevk Adresi'> *</label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="city_id" id="city_id" value="">
												<input type="hidden" name="county_id" id="county_id" value="">
												<input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfoutput>#get_sale_det.ship_address_id#</cfoutput>">
												<cfif Len(get_sale_det.ship_address)>
													<cfinput type="text" name="adres" message="#message#" value="#trim(get_sale_det.ship_address)#" maxlength="200" style="width:135px;">
												<cfelse>
													<cfinput type="text" name="adres" message="#message#" value="" maxlength="200" style="width:135px;">
												</cfif>
                                				<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_adress();"></span>
                                            </div>
                                        </div>
                                    </div>
                      				<cfif session.ep.our_company_info.asset_followup eq 1>
                                        <div class="form-group" id="item-asset_id">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
                                            <div class="col col-8 col-xs-12">
                                                <cf_wrkAssetp asset_id="#get_sale_det.assetp_id#" fieldId='asset_id' fieldName='asset_name' form_name='form_basket' width='135' button_type="plus_thin">
                                            </div>
                                        </div>
									</cfif>
                                    <div class="form-group" id="item-service_no">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57656.Servis'></label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="service_id" id="service_id"  value="<cfif isdefined("attributes.service_id")>#attributes.service_id#</cfif>">
                                                <input type="text" name="service_no" id="service_no" value="<cfif isdefined("attributes.service_no")>#attributes.service_no#</cfif>" style="width:135px;"  maxlength="50">
                                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='51183.İş/Görev'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_service&field_id=form_basket.service_id&field_no=form_basket.service_no&field_subs_id=form_basket.subscription_id&field_subs_no=form_basket.subscription_no','list');"></span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                                	<div class="form-group" id="item-note">
                                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                        <div class="col col-8 col-xs-12">
                                			<textarea name="note" id="note" style="width:140px;height:45px;"><cfoutput>#GET_SALE_DET.note#</cfoutput></textarea>
                                        </div>
                                    </div>
                                    <cfif session.ep.our_company_info.project_followup eq 1>
                                        <div class="form-group" id="item-project_head">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                            <div class="col col-8 col-xs-12">
                                                <div class="input-group">
													<cfif isdefined('get_subscription.project_id') and len(get_subscription.project_id)> 
                                                        <cfquery name="get_project_info" datasource="#dsn#">
                                                            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.project_id#">
                                                        </cfquery>
                                                    </cfif>
                                                    <cfif session.ep.our_company_info.project_followup eq 1>
                                                        <cfoutput>
                                                            <cfif len(get_sale_det.project_id)>
                                                                <cfquery name="GET_PROJECT" datasource="#dsn#">
                                                                    SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_sale_det.project_id#
                                                                </cfquery>
                                                                <input type="hidden" name="project_id" id="project_id" value="#get_sale_det.project_id#"> 
                                                                <input type="text" name="project_head" id="project_head" style="width:140px;" value="#get_project.project_head#">
                                                            <cfelse>
                                                                <input type="hidden" name="project_id" id="project_id" value=""> 
                                                                <input type="text" name="project_head" id="project_head" style="width:140px;" value="">
                                                            </cfif>
                            								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                                                            <span class="input-group-addon btnPointer bold" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=INVOICE&id='+document.getElementById('project_id').value+'','horizantal');else alert('<cf_get_lang dictionary_id='58797.Proje Seçiniz'>');">?</span>
                                                        </cfoutput>
                                                    </cfif>
                                                </div>
                                            </div>
                                        </div>
                                    </cfif>
                                    <div class="form-group" id="item-ref_no">
                                    	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
                                        <div class="col col-8 col-xs-12">
                                   			<input type="text" name="ref_no" id="ref_no" maxlength="50" value="<cfif len(get_sale_det.ref_no)><cfoutput>#get_sale_det.ref_no#</cfoutput></cfif>" style="width:140px;">
                                        </div>
                                    </div>
                                    <cfif xml_show_cash_checkbox eq 1>     
                                    	<div class="form-group" id="item-kasa">    
                                            <label class="col col-4 col-xs-12" id="kasa_sec1"><cfif kasa.recordcount><cf_get_lang dictionary_id='57030.Nakit Satış'><input type="checkbox" name="cash" id="cash" onClick="gizle_goster(not1);"<cfif get_sale_det.is_cash eq 1>checked</cfif>></cfif></label>
                                            <div class="col col-8 col-xs-12"  <cfif get_sale_det.is_cash neq 1> style="display:none;" </cfif> id="not1">
                                                <select name="kasa" id="kasa" style="width:140px;">
													<cfoutput query="kasa">
                                                        <option value="#cash_id#" <cfif get_sale_det.kasa_id eq cash_id>selected</cfif>>#cash_name#</option>
                                                    </cfoutput>
                                                </select>
                                                <cfoutput query="kasa">
                                                    <input type="hidden" name="str_kasa_parasi#cash_id#" id="str_kasa_parasi#cash_id#" value="#CASH_CURRENCY_ID#">
                                                </cfoutput>	
                                            </div>
                                        </div>
                                    </cfif>
                                </div>
                            </div>
                            <div class="row formContentFooter">
                            	<div class="col col-12">
                                	<cf_workcube_buttons is_upd='0' is_delete=false	add_function='kontrol()'>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
		</cf_basket_form>
		<cfset attributes.basket_id = 2>
        <cfinclude template="../../objects/display/basket.cfm">
	</cfform>
</div>
<script type="text/javascript">
	change_money_info('form_basket','invoice_date');
	function add_irsaliye()
	{
		if (confirm("<cf_get_lang dictionary_id ='57357.İrsaliye Seçerseniz Ürünler Silinecek, Emin misiniz'> ?"))
			del_rows();
		str_irslink = '&ship_id_liste=' + form_basket.irsaliye_id_listesi.value + '&id=sale_upd&sale_product=1&company_id='+form_basket.company_id.value+'&consumer_id='+ form_basket.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_store='+1</cfif>;
		 <cfif session.ep.our_company_info.project_followup eq 1>
		 	if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
				str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
		 </cfif>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_choice_ship' + str_irslink , 'page');
		return true;
	}
	function add_order()
	{	
		if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!="") || (form_basket.employee_id.value.length!="" && form_basket.employee_id.value!=""))
		{	
			str_irslink = '&is_from_invoice=1&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase=0&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_sale_store='+1</cfif>; 
			<cfif session.ep.our_company_info.project_followup eq 1>
				if(form_basket.project_id.value!='' && form_basket.project_head.value!='')
					str_irslink = str_irslink+'&project_id='+form_basket.project_id.value;
			</cfif>
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
			return true;
		}
		else (form_basket.company_id.value =="")
		{
			alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'> !");
			return false;
		}
	}
	function check_invoice_type()
	{
		if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
		{
			var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, form_basket.company_id.value);
		}
		else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
		{
			var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,form_basket.consumer_id.value);
        }
        is_efatura = '<cfoutput>#session.ep.our_company_info.is_efatura#</cfoutput>';
		if(is_efatura == 1 && get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
			paper_type = 'E_INVOICE';
		else
			paper_type = 'INVOICE';
		paper_control(form_basket.serial_no,paper_type,true,0,'','','','','',1,form_basket.serial_number);
	}
	function kontrol()
	{
        var get_is_no_sale=wrk_query("SELECT NO_SALE FROM STOCKS_LOCATION WHERE DEPARTMENT_ID ="+document.getElementById('department_id').value+" AND LOCATION_ID ="+document.getElementById('location_id').value,"dsn");
        if(get_is_no_sale.recordcount)
        {
            var is_sale_=get_is_no_sale.NO_SALE;
            if(is_sale_==1)
            {
                alert("<cf_get_lang dictionary_id='45400.Bu lokasyondan satış yapılamaz.'>");
                return false;
            }
        }
		if(form_basket.order_id_listesi.value!='' && form_basket.irsaliye_id_listesi.value != '')
		{
			alert("<cf_get_lang dictionary_id='57101.İrsaliye ve Sipariş Aynı Anda Seçilemez. Lütfen Seçimlerinizi Kontrol Ediniz !'>");
			return false;
		}
		<cfif xml_show_ship_date eq 1>
			if (!date_check(form_basket.invoice_date,form_basket.ship_date,"<cf_get_lang dictionary_id='57119.Fiili Sevk Tarihi, Fatura Tarihinden Önce Olamaz'>!"))
				return false;
		</cfif>
		if(form_basket.company_id!=undefined && form_basket.company_id.value.length)
		{
			var get_member_control = wrk_safe_query('obj_get_company_efatura','dsn' , 0, form_basket.company_id.value);
		}
		else if(form_basket.consumer_id!=undefined && form_basket.consumer_id.value.length)
		{
			var get_member_control = wrk_safe_query('obj_get_consumer_efatura','dsn',0,form_basket.consumer_id.value);
		}
		if(get_member_control != undefined && get_member_control.USE_EFATURA == 1 && datediff(date_format(get_member_control.EFATURA_DATE),document.getElementById('invoice_date').value,0) >= 0)
			paper_type = 'E_INVOICE';
		else
			paper_type = 'INVOICE';
		if(!paper_control(document.form_basket.serial_no,paper_type,true,0,'','','','','',1,form_basket.serial_number)) return false;
		<cfif isdefined('xml_acc_department_info') and xml_acc_department_info eq 2> //xmlde muhasebe icin departman secimi zorunlu ise
			if( document.form_basket.acc_department_id.options[document.form_basket.acc_department_id.selectedIndex].value=='')
			{
				alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
				return false;
			} 
		</cfif>
		<cfif isdefined("xml_upd_row_project") and xml_upd_row_project eq 1 and session.ep.our_company_info.project_followup eq 1>
			apply_deliver_date('','project_head','');
		</cfif>
		if (!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
		if (!check_accounts('form_basket')) return false;
		if (!check_product_accounts()) return false;
		if (!kontrol_ithalat()) return false;
		var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		if(temp_process_cat.length)
		{
			if(check_stock_action('form_basket')) //islem kategorisi stok hareketi yapıyorsa
			{
				var fis_no = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
				if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonlarında sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılıyor --->
				{
					if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,0,fis_no.value)) return false;
				}
			}
		}
		change_paper_duedate('invoice_date');
		saveForm();
		return false;
	}
	function kontrol2()
	{
		if (!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
		return true;
	}

function kontrol_ithalat()
{
	deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
	sistem_para_birimi = "<cfoutput>#SESSION.EP.MONEY#</cfoutput>";	
	if(deger != ""){
		var fis_no = eval("form_basket.ct_process_type_" + deger);
		//kdvden muaf satis faturasi : 533
		if(list_find('531,533',fis_no.value))
			reset_basket_kdv_rates();
	}
	return true;
}
function kontrol_yurtdisi()
{
	deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
	if(deger != ""){
		var fis_no = eval("form_basket.ct_process_type_" + deger);
		if(list_find('531,533',fis_no.value))
		{
			<cfif xml_show_cash_checkbox eq 1>
				kasa_sec1.style.display='none';
				not1.style.display='none';
			</cfif>
			reset_basket_kdv_rates(); //kdv oranları sıfırlanıyor dsp_basket_js_scripts te tanımlı
		}
		else
		{
			<cfif xml_show_cash_checkbox eq 1>
				<cfif get_sale_det.is_cash eq 1>
					kasa_sec1.style.display='';
					not1.style.display='';
				</cfif>
			</cfif>
		}
	}
}

function check_process_is_sale(){/*alım iadeleri satis karakterli oldugu halde alış fiyatları ile çalışması için*/
	<cfif get_basket.basket_id is 2>
		var selected_ptype = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
		if(selected_ptype!=''){
			eval('var proc_control = document.form_basket.ct_process_type_'+selected_ptype+'.value');
			if(proc_control==62)
				sale_product= 0;
			else
				sale_product = 1;
			}
		else
			return true;
	<cfelse>
		return true;
	</cfif>
}
function add_adress()
{
	if(!(form_basket.company_id.value=="") || !(form_basket.consumer_id.value=="") || !(form_basket.employee_id.value==""))
	{
		if(form_basket.company_id.value!="")
		{
			str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
			if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
			if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(form_basket.comp_name.value)+''+ str_adrlink , 'list');
			return true;
		}
		else
		{
			str_adrlink = '&field_long_adres=form_basket.adres&field_adress_id=form_basket.ship_address_id';
			if(form_basket.city_id!=undefined) str_adrlink = str_adrlink+'&field_city=form_basket.city_id';
			if(form_basket.county_id!=undefined) str_adrlink = str_adrlink+'&field_county=form_basket.county_id'<cfif session.ep.isBranchAuthorization>+'&is_store_module='+1</cfif>;
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(form_basket.partner_name.value)+''+ str_adrlink , 'list');
			return true;
		}
	}
	else
	{
		alert("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz'>");
		return false;
	}
}

	
kontrol_yurtdisi();
check_process_is_sale();
change_paper_duedate('invoice_date');
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
