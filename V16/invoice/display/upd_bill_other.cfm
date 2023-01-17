<cf_get_lang_set module_name="invoice"> 
<cf_xml_page_edit fuseact="invoice.detail_invoice_other">
<cfif isnumeric(attributes.iid)>
    <cfinclude template="../query/get_purchase_det.cfm">
<cfelse>
    <cfset get_sale_det.recordcount = 0>
</cfif>
<cfif not get_sale_det.recordcount>
    <cfset hata  = 11>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'>  <cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>	
<cfset attributes.basket_id = 33>
<cfinclude template="../query/get_session_cash.cfm">
<cfinclude template="../query/get_inv_cancel_types.cfm">
<cfscript>
    session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);
</cfscript>   
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <div id="basket_main_div">
            <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_bill_other">
                <cf_basket_form id="upd_other_bill">
                    <input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_bill_other</cfoutput>">
					<cf_papers paper_type="invoice" form_name="form_basket" form_field="invoice_number">
                    <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
                    <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
                    <input type="hidden" name="invoice_id" id="invoice_id" value="<cfoutput>#attributes.iid#</cfoutput>">
                    <input type="hidden" name="old_net_total" id="old_net_total" value="<cfoutput>#GET_SALE_DET.NETTOTAL#</cfoutput>">
                    <input type="hidden" name="old_pay_method" id="old_pay_method" value="<cfoutput>#GET_SALE_DET.PAY_METHOD#</cfoutput>">
                    <input type="hidden" name="del_invoice_id" id="del_invoice_id" value="0">
                    <input type="hidden" name="is_cost" id="is_cost" value="<cfif get_sale_det.is_cost eq 1>1<cfelse>0</cfif>">
                    <cfif len(get_sale_det.company_id)>
                        <cfset member_account_code = get_company_period(get_sale_det.company_id)>
                    <cfelse>
                        <cfset member_account_code = get_consumer_period(get_sale_det.consumer_id)>
                    </cfif>
                    <input type="hidden" name="member_account_code" id="member_account_code" value="<cfoutput>#member_account_code#</cfoutput>">
                    <input type="hidden" name="other_account_code" id="other_account_code" value="">
                    <cf_box_elements>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_workcube_process_cat  slct_width="140" onclick_function="order_show();" process_cat="#get_sale_det.process_cat#">
                                </div>
                            </div>
                            <cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
                                <div class="form-group" id="item-process_stage">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_workcube_process is_upd='0' select_value='#get_sale_det.process_stage#' process_cat_width='150' is_detail='1'>
                                    </div>
                                </div>
                            </cfif>
                            <div class="form-group" id="item-company">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari hesap'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfoutput>
                                            <input type="hidden" name="company_id" id="company_id" value="#get_sale_det.company_id#" >
                                            <cfif len(get_sale_det.company_id) and get_sale_det.company_id neq 0>
                                                <input type="text" name="company" id="company" value="#get_sale_det_comp.fullname#" readonly>
                                            <cfelse>
                                                <input type="text" name="company" id="company" value="#get_cons_name.company#" readonly>
                                            </cfif>
                                        </cfoutput>
                                        <cfset str_linkeait="&ship_method_id=form_basket.ship_method&ship_method_name=form_basket.ship_method_name&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value&field_card_payment_id=form_basket.card_paymethod_id">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.company&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=invoice&field_member_account_code=form_basket.member_account_code#str_linkeait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>','list')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-partner_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfoutput>
                                        <input type="hidden" name="partner_id" id="partner_id" value="#get_sale_det.partner_id#">
                                        <input type="hidden" name="consumer_id" id="consumer_id" value="#get_sale_det.consumer_id#">
                                        <cfif len(GET_SALE_DET.PARTNER_ID) and isnumeric(GET_SALE_DET.PARTNER_ID)>
                                            <input type="text" name="partner_name" id="partner_name" value="#GET_SALE_DET_CONS.COMPANY_PARTNER_NAME# #GET_SALE_DET_CONS.COMPANY_PARTNER_SURNAME#" readonly>
                                        <cfelseif len(GET_SALE_DET.consumer_id) and isnumeric(GET_SALE_DET.consumer_id) >
                                            <input type="text" name="partner_name" id="partner_name" value="#get_cons_name.consumer_name# #get_cons_name.consumer_surname#" readonly>
                                        <cfelse>
                                            <input type="text" name="partner_name" id="partner_name" value="" readonly>							
                                        </cfif>
                                    </cfoutput>
                                </div>
                            </div>
                            <div class="form-group" id="item-deliver_get">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(get_sale_det.deliver_emp) and isnumeric(get_sale_det.deliver_emp)>
                                            <cfset str_del_name=get_emp_info(get_sale_det.deliver_emp,0,0)>
                                        <cfelse>
                                            <cfset str_del_name="">
                                        </cfif>	
                                        <cfoutput>
                                        <input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="<cfif isnumeric(get_sale_det.deliver_emp)>#get_sale_det.deliver_emp#</cfif>">
                                        <input type="text" name="deliver_get" id="deliver_get" value="<cfif len(get_sale_det.deliver_emp)>#str_del_name#</cfif>" readonly>
                                        </cfoutput>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>','list')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-acc_department_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' width='135' selected_value='#get_sale_det.acc_department_id#'>
                                </div>
                            </div>
                            <div class="form-group" id="order_id_form">
                                <label class="col col-4 col-xs-12" ><cf_get_lang dictionary_id='57611.sipariş'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="order_id_listesi" id="order_id_listesi" value="<cfif isdefined("get_order_num") and get_order_num.recordcount><cfoutput>#ValueList(get_order_num.ORDER_ID)#</cfoutput></cfif>">
                                        <input type="text" name="order_id_form" id="order_id_form" value="<cfif isdefined("get_order_num") and get_order_num.recordcount><cfoutput>#ListSort(valuelist(GET_ORDER_NUM.ORDER_NUMBER),'text')#</cfoutput></cfif>"readonly>
                                        <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="add_order();"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                            <div class="form-group" id="item-invoice_number">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58133.Fatura No'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <cfinput type="text" name="invoice_number" maxlength="50" value="#get_sale_det.invoice_number#" required="Yes" message="Belge No !">
                                </div>
                            </div>
                            <div class="form-group" id="item-invoice_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58759.Fatura Tarihi'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang no='183.Fatura Tarihi Girmelisiniz'> !</cfsavecontent>
                                        <cfinput type="text" name="invoice_date" required="Yes" message="#message#" readonly value="#dateformat(get_sale_det.invoice_date,dateformat_style)#" validate="#validate_style#">
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="invoice_date" call_function="changeProcessDate"  control_date="#dateformat(get_sale_det.invoice_date,dateformat_style)#"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-process_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> *</label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif not len(get_sale_det.process_date)>
                                            <cfset p_date = get_sale_det.invoice_date>
                                        <cfelse>
                                            <cfset p_date = get_sale_det.process_date>
                                        </cfif>
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57906.İşlem Tarihi Girmelisiniz'> !</cfsavecontent>
                                        <cfinput type="text" name="process_date" required="Yes" message="#message#" value="#dateformat(p_date,dateformat_style)#" validate="#validate_style#" readonly="readonly">
                                        <span class="input-group-addon btnPointer" title="<cf_get_lang dictionary_id='57734.seçiniz'>"><cf_wrk_date_image date_field="process_date" id="process_date_image" control_date="#dateformat(p_date,dateformat_style)#"></span>
                                    </div>
                                </div>
                            </div>
                            <cfif session.ep.our_company_info.project_followup eq 1>
                                <div class="form-group" id="item-project_head">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                    <div class="col col-8 col-xs-12">
                                        <div class="input-group">
                                            <cfif len(get_sale_det.project_id)>
                                                <cfquery name="GET_PROJECT" datasource="#dsn#">
                                                    SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_sale_det.project_id#
                                                </cfquery>
                                                <input type="hidden" name="project_id" id="project_id" value="<cfoutput>#get_sale_det.project_id#</cfoutput>"> 
                                                <input type="text" name="project_head" id="project_head" value="<cfoutput>#get_project.project_head#</cfoutput>">
                                            <cfelse>
                                                <input type="hidden" name="project_id" id="project_id" value=""> 
                                                <input type="text" name="project_head" id="project_head" value="">
                                            </cfif>
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                                        </div>
                                    </div>
                                </div>
                            </cfif>
                            <div class="form-group" id="item-ref_no">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="ref_no" id="ref_no" maxlength="50" value="<cfif len(get_sale_det.ref_no)><cfoutput>#get_sale_det.ref_no#</cfoutput></cfif>">
                                </div>
                            </div>
                            <div class="form-group" id="item-PARTNER_NAMEO">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30011.Satın alan'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif get_sale_det.SALE_EMP eq "" and get_sale_det.SALE_PARTNER eq "">
                                            <input type="hidden" name="EMPO_ID" id="EMPO_ID">
                                            <input type="hidden" name="PARTO_ID" id="PARTO_ID">
                                            <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="">
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID</cfoutput>','list')"></span>
                                        <cfelse>
                                            <cfoutput>
                                                <input type="hidden" name="EMPO_ID" id="EMPO_ID" value="#get_sale_det.SALE_EMP#">
                                                <input type="hidden" name="PARTO_ID" id="PARTO_ID" value="#get_sale_det.SALE_PARTNER#">
                                            </cfoutput>
                                            <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" <cfif len(get_sale_det.sale_partner)>value="<cfoutput>#get_par_info(get_sale_det.sale_partner,0,0,0)#</cfoutput>"<cfelse>value="<cfoutput>#get_emp_info(get_sale_det.sale_emp,0,0)#</cfoutput>"</cfif>>
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID&select_list=1,2</cfoutput>','list')"></span>
                                        </cfif>
                                    </div>
                                </div>
                            </div>
                            <cfif session.ep.our_company_info.asset_followup eq 1>
                                <div class="form-group" id="item-asset_name">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58833.Fiziki Varlık'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cf_wrkassetp asset_id="#get_sale_det.assetp_id#" fieldid='asset_id' fieldname='asset_name' form_name='form_basket' width='135'>
                                    </div>
                                </div>
                            </cfif>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="3">
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
                                        returninputvalue="location_id,department_name,department_id,branch_id"
                                        returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                        fieldname="department_name"
                                        fieldid="location_id"
                                        department_fldid="department_id"
                                        branch_fldid="branch_id"
                                        branch_id="#branch_id#"
                                        department_id="#get_sale_det.department_ID#"
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
                                        <input type="hidden" name="ship_method" id="ship_method"  readonly value="<cfoutput>#get_sale_det.ship_method#</cfoutput>">
                                        <cfif len(get_sale_det.ship_method)>
                                            <cfset attributes.ship_method_id=get_sale_det.ship_method>
                                            <cfinclude template="../query/get_ship_methods.cfm">
                                        </cfif>
                                        <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(get_sale_det.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-paymethod">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntem'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="input-group">
                                        <cfif len(get_sale_det.pay_method)>
                                            <cfset attributes.paymethod_id = get_sale_det.pay_method>
                                            <cfinclude template="../query/get_paymethod.cfm">
                                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_sale_det.pay_method#</cfoutput>">
                                            <input type="text" name="paymethod" id="paymethod" value="<cfoutput>#get_paymethod.paymethod#</cfoutput>" readonly>
                                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                                            <input type="hidden" name="commission_rate" id="commission_rate" value="">
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
                                                <input type="text" name="paymethod" id="paymethod" value="#get_card_paymethod.card_no#" readonly >
                                                <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_sale_det.card_paymethod_id#">
                                                <input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
                                            </cfoutput>
                                        <cfelse>
                                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                                            <input type="text" name="paymethod" id="paymethod" value="" readonly >
                                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                                            <input type="hidden" name="commission_rate" id="commission_rate" value="">
                                        </cfif>
                                        <cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.paymethod&field_commission_rate=form_basket.commission_rate">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=invoice_date&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod&field_dueday=form_basket.basket_due_value#card_link#</cfoutput>','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-basket_due_value">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57640.Vade'></label>
                                <div class="col col-8 col-xs-12">
                                    <div class="col col-4 col-md-6">
                                        <input  type="text" id="basket_due_value" name="basket_due_value" value="<cfif len(get_sale_det.due_date) and len(get_sale_det.invoice_date)><cfoutput>#datediff('d',get_sale_det.invoice_date,get_sale_det.due_date)#</cfoutput></cfif>" <cfif session.ep.our_company_info.workcube_sector is 'metal'> readonly</cfif> onchange="change_paper_duedate('invoice_date');">
                                    </div>
                                    <div class="input-group">
                                        <cfinput type="text" name="basket_due_value_date_" value="#dateformat(get_sale_det.due_date,dateformat_style)#" onChange="change_paper_duedate('invoice_date',1);" validate="#validate_style#" message="#message#" maxlength="10" readonly>
                                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
                                    </div>
                                </div>
                            </div>
                            <cfif session.ep.our_company_info.subscription_contract eq 1>
                                <div class="form-group" id="item-subscription_id">
                                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29502.Abone No'></label>
                                    <div class="col col-8 col-xs-12">
                                        <cfif isdefined("get_sale_det.subscription_id") and len(get_sale_det.subscription_id)>
                                            <cfif xml_upd_subscription eq 1>
                                                <cf_wrk_subscriptions width_info='140' subscription_id='#get_sale_det.subscription_id#' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin' is_upd="1">
                                            <cfelse>
                                                <cf_wrk_subscriptions width_info='140' subscription_id='#get_sale_det.subscription_id#' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
                                            </cfif>
                                        <cfelse>
                                            <cfif xml_upd_subscription eq 1>
                                                <cf_wrk_subscriptions width_info='140' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin' is_upd="1">
                                            <cfelse>
                                                <cf_wrk_subscriptions width_info='140' fieldid='subscription_id' fieldname='subscription_no' form_name='form_basket' img_info='plus_thin'>
                                            </cfif>
                                        </cfif>
                                    </div>
                                </div>
                            </cfif>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="4">
                            <div class="form-group" id="item-note">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-8 col-xs-12">
                                    <textarea name="note" id="note"><cfoutput>#get_sale_det.note#</cfoutput></textarea>
                                </div>
                            </div>                           
                            <div class="form-group" id="item-tax_code">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30006.Vergi Kodu'></label>
                                <div class="col col-8 col-xs-12">
                                    <input type="text" name="tax_code" id="tax_code" value="<cfoutput>#get_sale_det.tax_code#</cfoutput>">
                                </div>
                            </div>
                            <cfif kasa.recordcount>
                                <div class="form-group" id="item-cash_id">
                                    <label class="col col-4"><cf_get_lang dictionary_id='57163.Nakit Alış'><input type="checkbox" name="cash" id="cash" onclick="gizle_goster(not1);"<cfif get_sale_det.is_cash eq 1> checked</cfif> value="1"></label>
                                    <div class="col col-8" <cfif get_sale_det.is_cash neq 1> style="display:none;" </cfif> id="not1">
                                        <select name="kasa" id="kasa">
                                            <cfoutput query="kasa">
                                                <option value="#cash_id#"<cfif get_sale_det.kasa_id eq cash_id>selected</cfif>>#cash_name#-#cash_currency_id#
                                            </cfoutput>
                                        </select>
                                        <cfoutput query="kasa">
                                            <input type="hidden" name="str_kasa_parasi#cash_id#" id="str_kasa_parasi#cash_id#" value="#CASH_CURRENCY_ID#">
                                        </cfoutput>	
                                    </div>
                                </div>
                            </cfif>
                            <div class="form-group" id="item-is_return">
                                <label class="col col-12"><cf_get_lang dictionary_id ='57318.Satış İade'><input type="Checkbox" name="is_return" id="is_return" <cfif get_sale_det.IS_RETURN eq 1>checked</cfif> value="1"></label>
                            </div>
                            <div class="form-group" id="item-fatura_iptal">
                                <div class="col col-4">
                                    <cfif get_sale_det.is_iptal eq 1>
                                        <font color="FF0000"><cf_get_lang dictionary_id='58750.Fatura İptal'></font><input name="fatura_iptal" id="fatura_iptal" onclick="document.getElementById('cancel_type').style.visibility = (document.getElementById('cancel_type').style.visibility=='hidden')?'visible':'hidden'" value="1" checked type="checkbox">
                                    <cfelse>
                                        <cf_get_lang dictionary_id='58750.Fatura İptal'><input name="fatura_iptal" id="fatura_iptal" value="1" type="checkbox" onclick="document.getElementById('cancel_type').style.visibility = (document.getElementById('cancel_type').style.visibility=='hidden')?'visible':'hidden'">
                                    </cfif>
                                </div>
                                <div class="col col-8" id="cancel_type" style="visibility:hidden;">
                                    <cfif isdefined("is_add_cancel_types") and is_add_cancel_types eq 1>
                                        <select name="cancel_type_id" id="cancel_type_id">
                                            <option value=""><cf_get_lang dictionary_id='58825.İptal Nedeni'></option>
                                            <cfoutput query="get_inv_cancel_types">
                                                <option value="#inv_cancel_type_id#" <cfif get_sale_det.cancel_type_id eq inv_cancel_type_id>selected</cfif>>#inv_cancel_type#</option>
                                            </cfoutput>
                                        </select>
                                    </cfif>
                                </div>
                                <div class="col col-8" id="cancel_type" style="visibility:hidden;">
                                    <cfif isdefined("is_add_cancel_types") and is_add_cancel_types eq 1>
                                        <select name="cancel_type_id" id="cancel_type_id">
                                            <option value=""><cf_get_lang dictionary_id='58825.İptal Nedeni'></option>
                                            <cfoutput query="get_inv_cancel_types">
                                                <option value="#inv_cancel_type_id#" <cfif get_sale_det.cancel_type_id eq inv_cancel_type_id>selected</cfif>>#inv_cancel_type#</option>
                                            </cfoutput>
                                        </select>
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-add_info">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_add_info info_type_id="-8" info_id="#attributes.iid#" upd_page = "1" colspan="9">
                                </div>
                            </div>
                            <div class="form-group" id="item-add_info">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                                <div class="col col-8 col-xs-12">
                                    <cf_wrk_add_info info_type_id="-8" info_id="#attributes.iid#" upd_page = "1" colspan="9">
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <cf_box_footer>
                        <div class="col col-6 col-xs-12"><cf_record_info query_name="get_sale_det"></div>
                        <div class="col col-6 col-xs-12">
                            <cfif not len(isClosed('INVOICE',attributes.iid)) and (GET_SALE_DET.RELATED_ACTION_TABLE eq '' or not len(isClosed(GET_SALE_DET.RELATED_ACTION_TABLE,GET_SALE_DET.RELATED_ACTION_ID)))>
                                <cfif get_sale_det.upd_status neq 0>
                                    <cf_workcube_buttons 
                                            is_upd='1'
                                            is_delete=1
                                            add_function='cagir_tarih()'
                                            del_function='kontrol2()'>
                                </cfif>
                            <cfelse>
                                    <font color="FF0000"><cf_get_lang dictionary_id='47262.Fatura kapama işlemi yapılan belgede değişiklik yapılamaz'>!</font>
                            </cfif>
                        </div>
                    </cf_box_footer>
                </cf_basket_form>
                <cfinclude template="../../objects/display/basket.cfm">
            </cfform>
        </div>
    </cf_box>
</div>  
</cfif>
<script type="text/javascript">
function changeProcessDate(){
        $("#process_date").val($("#invoice_date").val());
    }
    function order_show() {
        deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
        
        if(deger == 45 || deger == 49){
            goster(order_id_form);
        }
        else {
            gizle(order_id_form);
        }
            
    }
    function add_order()
        {	
            deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
            if(deger == '')
            {
                alert("<cf_get_lang dictionary_id='58770.İşlem Tipi Seçmelisiniz'> !");
                return false;
            }	
            if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!=""))
            {
                str_irslink = '&is_from_invoice=1&is_purchase=1&is_return=0&order_id_liste=' + form_basket.order_id_listesi.value + '&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_sale_store='+1</cfif>; 
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
    function cagir_tarih()
    {	
        <cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
            if(document.form_basket.process_stage.value == "")
                {
                    alert("<cf_get_lang dictionary_id ='41036.Lütfen Süreçlerinizi Tanimlayiniz veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
                    return false;
                }
        </cfif>
        if(!paper_control(form_basket.invoice_number,'INVOICE',false,<cfoutput>'#attributes.iid#','#get_sale_det.invoice_number#'</cfoutput>)) return false;
        var is_invoice_cost = true;
        if(document.form_basket.is_cost.value==0) is_invoice_cost = false;
        if (is_invoice_cost && !confirm("<cf_get_lang dictionary_id ='57271.Güncellediğiniz Faturanın Masraf- Gelir Dağıtımı Yapılmış Devam Ederseniz Bu Dağıtım Silinecektir'>!")) return false;
        var int_cat_type = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
        if (!chk_process_cat('form_basket')) return false;
        if(!check_display_files('form_basket')) return false;
        if(int_cat_type == 64 || int_cat_type == 690)
        if(form_basket.department_id.value=="" || form_basket.department_name.value=="")
        {
            alert("<cf_get_lang dictionary_id='57284.Lütfen Depo Seçiniz'>!");
            return false;
        }
        if(form_basket.deliver_get.value=="")
        {
            alert("<cf_get_lang dictionary_id='57285.Teslim Alan Seçiniz'>!");
            return false;			
        }		
        if (!chk_period(form_basket.process_date,"İşlem")) return false;
        change_paper_duedate('invoice_date');
        <cfif session.ep.our_company_info.is_lot_no eq 1>//şirket akış parametrelerinde lot no zorunlu olsun seçili ise
            row_count = window.basket.items.length;
            if(check_lotno('form_basket') != undefined && check_lotno('form_basket'))//işlem kategorisinde lot no zorunlu olsun seçili ise
                {
                    if(row_count != undefined)
                    {
                        for(i=0;i<row_count;i++)
                        {
                            if(window.basket.items[i].STOCK_ID.length != 0)
                            {
                                get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[i].STOCK_ID);
                                if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
                                {
                                    if(window.basket.items[i].LOT_NO.length == 0)
                                    {
                                        alert((i+1)+ '<cf_get_lang dictionary_id="37377.satırdaki">' + window.basket.items[i].PRODUCT_NAME + '<cf_get_lang dictionary_id="59288.ürünü için lot no takibi yapılmaktadır">!');
                                        return false;
                                    }
                                }
                            }
                        }
                    }
                }
            else
                {
                    if(window.basket.items[0].STOCK_ID.length != 0)
                    {
                        get_prod_detail = wrk_safe_query('obj2_get_prod_name','dsn3',0,window.basket.items[0].STOCK_ID);
                        if(get_prod_detail.IS_LOT_NO == 1)//üründe lot no takibi yapılıyor seçili ise
                        {
                            if(window.basket.items[0].LOT_NO == '')
                            {
                                alert((1)+ '<cf_get_lang dictionary_id="37377.satırdaki">' + window.basket.items[0].PRODUCT_NAME + '<cf_get_lang dictionary_id="59288.ürünü için lot no takibi yapılmaktadır">!');
                                return false;
                            }
                        }
                    }
                }
                            
        </cfif>	
        <cfif not get_module_power_user(20)>
            var process_info = wrk_safe_query('inv_process_info','dsn3',0,form_basket.old_process_cat_id.value);
            var listParam = "<cfoutput>#attributes.iid#</cfoutput>" + "*" + form_basket.old_process_type.value ;
            var closed_info = wrk_safe_query("inv_closed_info",'dsn2',0,listParam);
            if(closed_info.recordcount)
                if((process_info.IS_PAYMETHOD_BASED_CARI == 1 && document.form_basket.old_pay_method.value != document.form_basket.paymethod_id.value) || document.form_basket.old_net_total.value != filterNum(document.all.basket_net_total.value) || (closed_info.COMPANY_ID != '' && closed_info.COMPANY_ID != form_basket.company_id.value) || (closed_info.CONSUMER_ID != '' && closed_info.CONSUMER_ID != form_basket.consumer_id.value) || (form_basket.old_process_type.value != eval("document.form_basket.ct_process_type_" + int_cat_type).value))
                {
                    alert("<cf_get_lang dictionary_id='57405.Belge Kapama Talep veya Emir Girilen Belgenin Tutarı Carisi Ödeme Yöntemi veya İşlem Tipi Değiştirilemez'>!");
                    return false;
                }
        </cfif>
        <cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
            return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && process_cat_control() && saveForm());
        <cfelse>
            return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && saveForm());
        </cfif>
    }
    function kontrol2()
    {
        if (!chk_process_cat('form_basket')) return false;
        if(!check_display_files('form_basket')) return false;
        if (!chk_period(form_basket.invoice_date,"İşlem")) return false;    
        <cfif session.ep.our_company_info.is_efatura and isdefined("get_efatura_det") and get_efatura_det.recordcount>
            alert("<cf_get_lang dictionary_id='57114.Fatura ile İlişkili e-Fatura Olduğu için Silinemez'> !");
            return false;
        </cfif>	
        form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
        <cfif isdefined("xml_show_process_stage") and len(xml_show_process_stage) and xml_show_process_stage eq 1>
            return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && process_cat_control() && saveForm()); 
        <cfelse>
            return (control_account_process(<cfoutput>'#attributes.iid#','#get_sale_det.invoice_cat#'</cfoutput>) && saveForm()); 
        </cfif>
        //return true;	
    }	
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
