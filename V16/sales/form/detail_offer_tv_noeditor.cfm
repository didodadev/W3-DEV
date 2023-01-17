        <cfoutput>
            <cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-offer_head">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58820.Başlık'></label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="offer_head" value="#get_offer.offer_head#" required="yes" message="#message#" maxlength="200">
                        </div>
                    </div>
                    <div class="form-group" id="item-company_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
                        <div class="col col-8 col-sm-12">
                            <cfset str_linkeait="&field_adress_id=form_basket.ship_address_id&field_revmethod_id=form_basket.paymethod_id&field_revmethod=form_basket.pay_method&ship_method_id=form_basket.ship_method_id&ship_method_name=form_basket.ship_method_name">
                            <cfif len(get_offer.company_id)>
                                <div class="input-group">
                                    <input type="text" name="company_name" id="company_name" value="#get_par_info(get_offer.company_id,1,0,0)#" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0#str_linkeait#&field_comp_id=form_basket.company_id&field_id=form_basket.member_id&field_comp_name=form_basket.company_name&field_name=form_basket.consumer&field_type=form_basket.member_type&field_consumer=form_basket.member_id&field_long_address=form_basket.ship_address&field_city_id=form_basket.city_id&field_county_id=form_basket.county_id&function_name=fill_country&select_list=7,8','list');"></span>
                                </div>
                            <cfelse>
                                <div class="input-group">
                                    <input type="text" name="company_name" id="company_name" value="" readonly>
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0#str_linkeait#&field_comp_id=form_basket.company_id&field_id=form_basket.member_id&field_comp_name=form_basket.company_name&field_name=form_basket.consumer&field_type=form_basket.member_type&field_consumer=form_basket.member_id&field_long_address=form_basket.ship_address&field_city_id=form_basket.city_id&field_county_id=form_basket.county_id&function_name=fill_country&select_list=7,8','list');"></span>
                                </div>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-partner_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                        <div class="col col-8 col-sm-12">
                            <!--- Uye degisiklerinin analizi etkileyeceği icin old alanlar dusunuldu --->
                            <cfif contact_type is "c">
                                <input type="hidden" name="old_member_type" id="old_member_type" value="consumer">
                                <input type="hidden" name="old_member_id" id="old_member_id" value="#contact_id#">
                                <input type="hidden" name="old_consumer_id" id="old_consumer_id" value="#contact_id#">

                                <input type="hidden" name="member_type" id="member_type" value="consumer">
                                <input type="hidden" name="member_id" id="member_id" value="#contact_id#">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="#contact_id#">
                                <input type="text" name="consumer" id="consumer" value="#trim(get_cons_info(contact_id,0,0))#" readonly>
                            <cfelseif contact_type is "p" or contact_type is "comp">
                                <input type="hidden" name="old_member_type" id="old_member_type" value="partner">
                                <input type="hidden" name="old_consumer_id" id="old_consumer_id" value="">
                                <input type="hidden" name="old_member_id" id="old_member_id" value="<cfif contact_type is "p">#contact_id#</cfif>">

                                <input type="hidden" name="member_type" id="member_type" value="partner">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                <input type="hidden" name="member_id" id="member_id" value="<cfif contact_type is "p">#contact_id#</cfif>">
                                <input type="text" name="consumer" id="consumer" value="<cfif contact_type is "p" >#trim(get_par_info(contact_id,0,-1,0))#<cfelse>#trim(get_par_info(contact_id,1,0,0))#</cfif>" readonly>
                            <cfelse>
                                <input type="hidden" name="old_member_type" id="old_member_type" value="">
                                <input type="hidden" name="old_consumer_id" id="old_consumer_id" value="">
                                <input type="hidden" name="old_member_id" id="old_member_id" value="">

                                <input type="hidden" name="member_type" id="member_type" value="">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                <input type="hidden" name="member_id" id="member_id" value="">
                                <input type="text" name="consumer" id="consumer" value="" readonly>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-sales_emp">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='40903.Satış Yapan'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="hidden" name="sales_emp_id" id="sales_emp_id" value="#get_offer.sales_emp_id#">
                            <cfif len(get_offer.sales_emp_id)>
                                <div class="input-group">
                                    <input name="sales_emp" type="text" id="sales_emp" onFocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','','3','110');" value="#get_emp_info(get_offer.sales_emp_id,0,0)#" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.sales_emp_id&field_name=form_basket.sales_emp&select_list=1');"></span>
                                </div>
                            <cfelse>
                                <div class="input-group">
                                    <input name="sales_emp" type="text" id="sales_emp" onFocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','','3','110');" value="" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.sales_emp_id&field_name=form_basket.sales_emp&select_list=1');"></span>
                                </div>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-ref_no">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="text" name="ref_no" id="ref_no" value="<cfif len(get_offer.ref_no)>#get_offer.ref_no#</cfif>" maxlength="50" >
                        </div>
                    </div>
                    <div class="form-group" id="item-sales_member">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='49283.satış Ortağı'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(get_offer.sales_partner_id)>
                                <input type="hidden" name="sales_member_id" id="sales_member_id" value="#get_offer.sales_partner_id#">
                                <input type="hidden" name="sales_member_type" id="sales_member_type" value="partner">
                                <div class="input-group">
                                    <input type="text" name="sales_member" id="sales_member" value="#get_par_info(get_offer.sales_partner_id,0,-1,0)#-#get_par_info(get_offer.sales_partner_id,0,1,0)#" onFocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\'','PARTNER_ID,MEMBER_TYPE','sales_member_id,sales_member_type','','3','250');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&is_rate_select=1&field_id=form_basket.sales_member_id&field_name=form_basket.sales_member&field_type=form_basket.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8');"></span>
                                </div>
                            <cfelseif len(get_offer.sales_consumer_id)>
                                <input type="hidden" name="sales_member_id" id="sales_member_id" value="#get_offer.sales_consumer_id#">
                                <input type="hidden" name="sales_member_type"  id="sales_member_type" value="consumer">
                                <div class="input-group">
                                    <input type="text" name="sales_member" id="sales_member" value="#get_cons_info(get_offer.sales_consumer_id,1,0,0)#" onFocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\'','PARTNER_ID,MEMBER_TYPE','sales_member_id,sales_member_type','','3','250');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&is_rate_select=1&field_id=form_basket.sales_member_id&field_name=form_basket.sales_member&field_type=form_basket.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8');"></span>
                                </div>
                            <cfelse>
                                <input type="hidden" name="sales_member_id" id="sales_member_id" value="">
                                <input type="hidden" name="sales_member_type"  id="sales_member_type" value="">
                                <div class="input-group">
                                    <input type="text" name="sales_member" id="sales_member" value=""  onFocus="AutoComplete_Create('sales_member','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2\'','PARTNER_ID,MEMBER_TYPE','sales_member_id,sales_member_type','','3','250');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&is_rate_select=1&field_id=form_basket.sales_member_id&field_name=form_basket.sales_member&field_type=form_basket.sales_member_type<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8');"></span>
                                </div>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-sales_add_option">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='41142.Satış Özel Tanım'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinclude template="../query/get_sale_add_option.cfm">
                            <select name="sales_add_option" id="sales_add_option">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfloop query="get_sale_add_option">
                                    <option value="#sales_add_option_id#" <cfif sales_add_option_id eq get_offer.sales_add_option_id>selected</cfif>>#sales_add_option_name#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-probability">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58652.Olasılık'> %</label>
                        <div class="col col-8 col-sm-12">
                            <select name="probability" id="probability" >
                                <cfloop from="0" to="100" index="i" step="5">
                                    <option value="#i#" <cfif get_offer.probability eq i>selected</cfif>>#i#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-offer_date">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='46831.Teklif Tarihi'> *</label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='38656.Teklif Tarihi Girmelisiniz'>!</cfsavecontent>
                            <div class="input-group">
                                <cfinput type="text" name="offer_date" value="#dateformat(get_offer.offer_date,dateformat_style)#" validate="#validate_style#" message="#message#" onblur="change_money_info('form_basket','offer_date');">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="offer_date" call_function="change_money_info"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ship_date">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='40834.Sevk Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='40895.Sevk Tarihi Girmelisiniz'>!</cfsavecontent>
                            <div class="input-group">
                                <cfinput type="text" name="ship_date" value="#dateformat(get_offer.ship_date,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="ship_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-deliverdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'> *</label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='40987.Teslim Tarihi Girmelisiniz'></cfsavecontent>
                            <div class="input-group">
                                <cfinput type="text" name="deliverdate" id="deliverdate" value="#dateformat(get_offer.deliverdate,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="deliverdate"></span>
                                <cfif isdefined('is_termin_calc') and is_termin_calc eq 1>
                                    <span class="input-group-addon btnPointer icon-cogs" onClick="calc_deliver_date();"></span>
                                </cfif>
                            </div>
                            <div style="position:absolute;z-index:9999999;" id="deliver_date_info"></div>
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='40906.Gecerlilik Tarihi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='40988.Gecerlilik Tarihi Girmelisiniz'></cfsavecontent>
                            <div class="input-group">
                                <cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(get_offer.finishdate,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                    </div>
                    <cfquery name="getOfferRelation" datasource="#dsn3#" maxrows="1"><!--- bu teklife ait iliskili teklif var ise aşağıda silinip silinmemesini kontrol ediyor. --->
                        SELECT OFFER_ID FROM OFFER WHERE RELATION_OFFER_ID = #attributes.offer_id#
                    </cfquery>
                    <div class="form-group" id="item-rel_offer_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='40880.İlişkili Teklif'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif isdefined("get_offer.relation_offer_id") and len(get_offer.relation_offer_id)>
                                <cfquery name="getRelOfferId" datasource="#dsn3#">
                                    SELECT OFFER_ID FROM OFFER WHERE RELATION_OFFER_ID = #get_offer.relation_offer_id# ORDER BY OFFER_ID DESC
                                </cfquery>
                                <cfquery name="GET_OFFER_HEAD" datasource="#dsn3#">
                                    SELECT OFFER_HEAD,OFFER_NUMBER FROM OFFER WHERE OFFER_ID = #get_offer.relation_offer_id#
                                </cfquery>
                                <cfset rel_offer_head = get_offer_head.offer_number>
                                <cfif listfind(valuelist(getRelOfferId.offer_id),attributes.offer_id)>
                                    <div class="input-group">
                                        <input type="hidden" name="rel_offer_id" id="rel_offer_id" value="#get_offer.relation_offer_id#">
                                        <input type="text" name="rel_offer_head" id="rel_offer_head" value="#rel_offer_head#" <cfif not listfind(valuelist(getRelOfferId.offer_id),attributes.offer_id)>readonly="readonly"</cfif>>
                                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=sales.popup_list_offers&field_offer_id=form_basket.rel_offer_id&field_offer_number=form_basket.rel_offer_head');"></span>
                                    </div>
                                <cfelse>
                                        <input type="hidden" name="rel_offer_id" id="rel_offer_id" value="#get_offer.relation_offer_id#">
                                        <input type="text" name="rel_offer_head" id="rel_offer_head" value="#rel_offer_head#" <cfif not listfind(valuelist(getRelOfferId.offer_id),attributes.offer_id)>readonly="readonly"</cfif>>
                                </cfif>
                            <cfelse>
                                <div class="input-group">
                                    <input type="hidden" name="rel_offer_id" id="rel_offer_id" value="">
                                    <input type="text" name="rel_offer_head" id="rel_offer_head" value="">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=sales.popup_list_offers&field_offer_id=form_basket.rel_offer_id&field_offer_number=form_basket.rel_offer_head');"></span>
                                </div>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-country_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='58219.Ülke'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="country_id" id="country_id" onchange="auto_sales_zone();">
                                <option value="">
                                    <cf_get_lang dictionary_id='57734.Seçiniz'>
                                </option>
                                <cfloop query="get_country">
                                    <option value="#country_id#" <cfif get_offer.country_id eq country_id>selected</cfif>>#country_name#</option>
                                </cfloop>
                            </select>
                        </div>
                        </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-offer_status">
                        <label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="offer_status" id="offer_status" value="1" <cfif get_offer.offer_status eq 1> checked</cfif>></label>&nbsp;&nbsp;&nbsp;
                        <label><cf_get_lang dictionary_id='40847.Public'><input type="checkbox" name="is_public_zone" id="is_public_zone" value="1" <cfif get_offer.is_public_zone is 1>checked</cfif>></label>&nbsp;&nbsp;&nbsp;
                        <label><cf_get_lang dictionary_id='58885.Partner'><input type="checkbox" name="is_partner_zone" id="is_partner_zone" value="1" <cfif get_offer.is_partner_zone is 1>checked</cfif>></label>
                    </div>
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                        <div class="col col-8 col-sm-12">
                            <cf_workcube_process is_upd='0' select_value='#get_offer.offer_stage#' process_cat_width='130' is_detail='1'>
                        </div>
                    </div>
                    <div class="form-group" id="item-ship_method_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29500.Sevk Yontemi'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="hidden" name="ship_method_id" id="ship_method_id" value="#get_offer.ship_method#">
                            <cfif len(get_offer.ship_method)>
                                <cfset attributes.ship_method=get_offer.ship_method>
                                <cfset attributes.ship_address= get_offer.ship_address>
                                <cfinclude template="../query/get_ship_method.cfm">
                            </cfif>
                            <div class="input-group">
                                <input name="ship_method_name" type="text" id="ship_method_name" onFocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','110');" value="<cfif len(get_offer.ship_method)>#get_ship_method.ship_method#</cfif>" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id','','ui-draggable-box-small');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-paymethod_vehicle">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.pay_method&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
                            <cfif len(get_offer.paymethod)>
                                <cfset attributes.paymethod_id = get_offer.paymethod>
                                <cfinclude template="../query/get_paymethod.cfm">
                                <input type="hidden" name="paymethod_id" id="paymethod_id" value="#get_paymethod.paymethod_id#">
                                <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                                <input type="hidden" name="commission_rate" id="commission_rate" value="">
                                <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="#get_paymethod.payment_vehicle#"><!--- Ödeme aracını tutuyor ve basket hesaplamalarında kullanılıyor lütfen silmeyiniz --->
                                <div class="input-group">
                                    <input type="text" name="pay_method" id="pay_method" value="#get_paymethod.paymethod#"  onFocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.pay_method#card_link#','list');"></span>
                                </div>
                            <cfelseif len(get_offer.card_paymethod_id)>
                                <cfset card_pay_id = get_offer.card_paymethod_id>
                                <cfinclude template="../query/get_card_paymethod.cfm">
                                <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="-1">
                                <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_card_paymethod.payment_type_id#">
                                <input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
                                <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                                <div class="input-group">
                                    <input type="text" name="pay_method" id="pay_method" value="#get_card_paymethod.card_no#"  onFocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.pay_method#card_link#','list');"></span>
                                </div>
                            <cfelse>
                                <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
                                <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                                <input type="hidden" name="commission_rate" id="commission_rate" value="">
                                <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                                <div class="input-group">
                                    <input type="text" name="pay_method" id="pay_method" value=""  onFocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.pay_method#card_link#','list');"></span>
                                </div>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-project_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="hidden" name="project_id" id="project_id" value="#get_offer.project_id#">
                            <cfset str_linke_ait_prj="&comp_id='+document.form_basket.company_id.value+'&cons_id='+document.form_basket.consumer_id.value+'&comp_name='+document.form_basket.company_name.value+'">
                            <div class="input-group">
                                <input type="text" name="project_head" id="project_head" value="<cfif len(get_offer.project_id)>#GET_PROJECT_NAME(get_offer.project_id)#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135')" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects#str_linke_ait_prj#&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                                <span class="input-group-addon btnPointer icon-question" onClick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=OFFER&id='+document.getElementById('project_id').value+'','page_display');else alert('Proje Seçiniz');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-camp_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(get_offer.camp_id)>
                                <cfquery name="get_camp_info" datasource="#dsn3#">
                                    SELECT CAMP_ID,CAMP_HEAD FROM CAMPAIGNS WHERE CAMP_ID = #get_offer.camp_id#
                                </cfquery>
                            <cfelse>
                                <cfset get_camp_info.camp_head = ''>
                            </cfif>
                            <input type="hidden" name="camp_id" id="camp_id" value="#get_offer.camp_id#">
                            <div class="input-group">
                                <input type="text" name="camp_name" id="camp_name" value="#get_camp_info.camp_head#">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_campaigns&field_id=form_basket.camp_id&field_name=form_basket.camp_name');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-sales_zone_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57659.Satış Bölgesi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="sales_zone_id" id="sales_zone_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfloop query="get_sale_zones">
                                    <option value="#sz_id#" <cfif get_offer.SZ_ID eq sz_id>selected</cfif>>#sz_name#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-offer_detail">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-sm-12">
                            <textarea name="offer_detail" id="offer_detail">#get_offer.offer_detail#</textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-city_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58449.Teslim Yeri'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="hidden" name="city_id" id="city_id" value="#get_offer.city_id#">
                            <input type="hidden" name="county_id" id="county_id" value="#get_offer.county_id#">
                            <input type="hidden" name="ship_address_id" id="ship_address_id" value="#get_offer.ship_address_id#">
                            <div class="input-group">
                                <textarea name="ship_address" id="ship_address" onChange="kontrol(this,200)">#get_offer.ship_address#</textarea>
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="add_adress();"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-work_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58445.İş'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="hidden" name="work_id" id="work_id" value="<cfif len(get_offer.work_id)>#get_offer.work_id#</cfif>">
                            <div class="input-group">
                                <input type="text" name="work_head" id="work_head" value="<cfif len(get_offer.work_id)>#get_work_name(get_offer.work_id)#</cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head&project_id='+document.getElementById('project_id').value+'&project_head='+document.getElementById('project_head').value+'');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ref_company_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58784.Referans'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(get_offer.ref_partner_id)>
                                <input type="hidden" name="ref_company_id" id="ref_company_id" value="#get_offer.ref_company_id#">
                                <input type="hidden" name="ref_member_type" id="ref_member_type" value="partner">
                                <input type="hidden" name="ref_member_id" id="ref_member_id" value="#get_offer.ref_partner_id#">
                                <div class="input-group">
                                    <input type="text" name="ref_company" id="ref_company" value="#get_par_info(get_offer.ref_company_id,1,0,0)#"  onfocus="AutoComplete_Create('ref_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','ref_company_id,ref_member_type,ref_member_id,ref_member','','3','250');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&field_partner=form_basket.ref_member_id&field_consumer=form_basket.ref_member_id&field_comp_id=form_basket.ref_company_id&field_comp_name=form_basket.ref_company&field_name=form_basket.ref_member&field_type=form_basket.ref_member_type&select_list=7,8');"></span>
                                </div>
                            <cfelseif len(get_offer.ref_consumer_id)>
                                <input type="hidden" name="ref_company_id" id="ref_company_id" value="#get_offer.ref_company_id#">
                                <input type="hidden" name="ref_member_type" id="ref_member_type" value="consumer">
                                <input type="hidden" name="ref_member_id" id="ref_member_id" value="#get_offer.ref_consumer_id#">
                                <div class="input-group">
                                    <input type="text" name="ref_company" value="" id="ref_member_id"  onfocus="AutoComplete_Create('ref_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','ref_company_id,ref_member_type,ref_member_id,ref_member','','3','250');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&field_partner=form_basket.ref_member_id&field_consumer=form_basket.ref_member_id&field_comp_id=form_basket.ref_company_id&field_comp_name=form_basket.ref_company&field_name=form_basket.ref_member&field_type=form_basket.ref_member_type&select_list=7,8');"></span>
                                </div>
                            <cfelse>
                                <input type="hidden" name="ref_company_id" id="ref_company_id" value="">
                                <input type="hidden" name="ref_member_type" id="ref_member_type" value="">
                                <input type="hidden" name="ref_member_id" id="ref_member_id" value="">
                                <div class="input-group">
                                    <input type="text" name="ref_company" id="ref_company"  value="" onfocus="AutoComplete_Create('ref_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','ref_company_id,ref_member_type,ref_member_id,ref_member','','3','250');" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&field_partner=form_basket.ref_member_id&field_consumer=form_basket.ref_member_id&field_comp_id=form_basket.ref_company_id&field_comp_name=form_basket.ref_company&field_name=form_basket.ref_member&field_type=form_basket.ref_member_type&select_list=7,8');"></span>
                                </div>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-ref_member">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(get_offer.ref_partner_id)>
                                <input type="text" name="ref_member" id="ref_member" value="#get_par_info(get_offer.ref_partner_id,0,-1,0)#" readonly>
                            <cfelseif len(get_offer.ref_consumer_id)>
                                <input type="text" name="ref_member" id="ref_member" value="#get_cons_info(get_offer.ref_consumer_id,0,0,0)#" readonly>
                            <cfelse>
                                <input type="text" name="ref_member" id="ref_member" value="" readonly>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-wrk_add_info">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfquery name="controlSalesAddOptions" datasource="#dsn3#">
                                SELECT * FROM SETUP_PRO_INFO_PLUS_NAMES WHERE OWNER_TYPE_ID = -9 AND SALES_ADD_OPTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#trim(get_offer.sales_add_option_id)#,%">
                            </cfquery>
                            <cfset sales_add_option = "">
                            <cfif controlSalesAddOptions.recordCount>
                                <cfset sales_add_option = get_offer.sales_add_option_id>
                            </cfif>
                            <cf_wrk_add_info info_type_id="-9" info_id="#attributes.offer_id#" upd_page = "1" colspan="9" sales_add_option="#sales_add_option#">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6"><cf_record_info query_name='get_offer' is_partner='1' is_consumer='1' record_emp="record_member" update_emp="update_member"></div>
                <div class="col col-6">
                    <cfif get_offer.is_processed eq 1>
                        <cf_get_lang dictionary_id='139.Islendi'>
                    <cfelse>
                        <cfif xml_offer_revision eq 1 and ((isdefined('getRelOfferId.offer_id') and not listfind(valuelist(getRelOfferId.offer_id),attributes.offer_id) ) or (isdefined('getOfferRelation.recordcount') and getOfferRelation.recordcount))>
                            <cf_workcube_buttons is_upd='1' is_delete="0" add_function='check()' type_format="1">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <cfelse>
                            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=sales.emptypopup_del_offer&offer_id=#attributes.offer_id#&head=#head_#&pageHead=#head_#' add_function='check()'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </cfif>
                    </cfif>
                </div>
            </cf_box_footer>
        </cfoutput>
<script type="text/javascript">
function calc_deliver_date()
{
	stock_id_list = '';
	var row_c = document.getElementsByName('stock_id').length;
	if(row_c != 0)
	{
		if(row_c > 1)
		{//1den fazla satır varsa
			for(var ii=0;ii<row_c;ii++)
			{
				var n_stock_id =document.all.stock_id[ii].value;
				var n_amount = filterNum(document.all.amount[ii].value,6);
				var n_spect_id = document.all.spect_id[ii].value;
				var n_is_production = document.all.is_production[ii].value;
				if(n_spect_id == "") n_spect_id =0;
				if(n_stock_id != "" && n_is_production ==1)//ürün silinmemiş ise
					stock_id_list +=n_stock_id+'-'+n_spect_id+'-'+n_amount+'-'+n_is_production+',';
			}
		}
		else if(row_c == 1){
			var n_stock_id =document.all.stock_id.value;
			var n_amount = filterNum(document.all.amount.value,6);
			var n_spect_id = document.all.spect_id.value;
			var n_is_production = document.all.is_production.value;
			if(n_spect_id == "") n_spect_id =0;
			if(n_stock_id != "" && n_is_production ==1)
			stock_id_list +=n_stock_id+'-'+n_spect_id+'-'+n_amount+'-'+n_is_production+',';
		}
		document.getElementById('deliver_date_info').style.display='';
		AjaxPageLoad(<cfoutput>'#request.self#?fuseaction=objects.popup_ajax_deliver_date_calc&stock_id_list='+stock_id_list+''</cfoutput>,'deliver_date_info',1,"<cf_get_lang dictionary_id ='41164.Teslim Tarihi Hesaplanıyor'>");
	}
	else
	alert("<cf_get_lang dictionary_id='58227.Ürün Seçmelisiniz'>");
}
function fill_country(member_id,type)
{
			document.getElementById('country_id').value='';
			document.getElementById('sales_zone_id').value='';
			if(type==1)
			{
				var sql = "SELECT COUNTRY,SALES_COUNTY FROM COMPANY WHERE COMPANY_ID = " + member_id
				get_country = wrk_query(sql,'dsn');
				if(get_country.COUNTRY!='' && get_country.COUNTRY!='undefined')
					document.getElementById('country_id').value=get_country.COUNTRY;
				if(get_country.SALES_COUNTY!='' && get_country.SALES_COUNTY!='undefined')
					document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;
			}
			else if(type==2)
			{
				var sql = "select SALES_COUNTY,TAX_COUNTRY_ID from CONSUMER WHERE CONSUMER_ID = " + member_id;
				get_country= wrk_query(sql,'dsn');
				if(get_country.TAX_COUNTRY_ID!='' && get_country.TAX_COUNTRY_ID!='undefined')
					document.getElementById('country_id').value=get_country.TAX_COUNTRY_ID;
				if(get_country.SALES_COUNTY!='' && get_country.TAX_COUNTRY_ID!='undefined')
					document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;

			}
}
function auto_sales_zone()
{
    var sql = "SELECT SZ.SZ_ID FROM SALES_ZONES_TEAM SZT,SALES_ZONES SZ WHERE SZ.SZ_ID = SZT.SALES_ZONES AND SZT.COUNTRY_ID = " + document.getElementById('country_id').value;
	get_sales_zone_id = wrk_query(sql,'dsn');
    if(get_sales_zone_id.recordcount == 1)
    {
    	document.getElementById('sales_zone_id').value = get_sales_zone_id.SZ_ID;
		return false;
    }
	else if(get_sales_zone_id.recordcount == 0)
	{
		alert("<cf_get_lang dictionary_id='40952.Ülke ile İlişkili Satış Bölgesi Bulunamadı'>!");
		return false;
	}
	else if(get_sales_zone_id.recordcount > 1)
	{
		alert('<cf_get_lang dictionary_id="40955.Ülke ile İlişkili Birden Fazla Satış Bölgesi Bulunmaktadır"> !');
		return false;
	}
}
</script>
