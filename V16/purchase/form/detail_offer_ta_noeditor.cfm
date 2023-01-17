<cfoutput>
    <cf_box_elements>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group" id="item-offer_head">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='58820.Başlık'></label>
                <div class="col col-8 col-xs-12">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" value="#get_offer_detail.offer_head#" name="offer_head" maxlength="200" required="yes" message="#message#">
                </div>
            </div>
            <cfif xml_show_process_stage eq 1>
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process_cat process_cat='#get_offer_detail.PROCESS_CAT#' slct_width="135">
                    </div>
                </div>
            </cfif>
            <div class="form-group" id="item-order_employee_id">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif len(get_offer_detail.ship_method)>#get_offer_detail.ship_method#</cfif>">
                        <cfif len(get_offer_detail.SHIP_METHOD)>
                            <cfset attributes.ship_method=get_offer_detail.SHIP_METHOD>
                            <cfinclude template="../query/get_ship_method.cfm">
                        </cfif>
                        <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif len(get_offer_detail.SHIP_METHOD)>#get_ship_method.ship_method#</cfif>">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id');"></span>
                    </div>
                </div>
            </div>  
            <div class="form-group" id="item-paymethod_id">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfif len(get_offer_detail.paymethod)>
                            <cfset pay_id =get_offer_detail.paymethod>
                            <cfinclude template="../query/get_payment_method.cfm">
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="#get_payment_method.paymethod_id#">
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                            <input type="hidden" name="commission_rate" id="commission_rate" value="">
                            <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="#get_payment_method.payment_vehicle#"><!--- Ödeme aracını tutuyor ve basket hesaplamalarında kullanılıyor lütfen silmeyiniz --->
                            <input type="text" name="pay_method" id="pay_method" value="#get_payment_method.paymethod#"  onfocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                        <cfelseif len(get_offer_detail.card_paymethod_id)>
                            <cfset card_pay_id = get_offer_detail.card_paymethod_id>
                            <cfinclude template="../query/get_card_paymethod.cfm">
                            <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="-1">
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_card_paymethod.payment_type_id#">
                            <input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                            <input type="text" name="pay_method" id="pay_method" value="#get_card_paymethod.card_no#"  onfocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                        <cfelse>
                            <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                            <input type="hidden" name="commission_rate" id="commission_rate" value="">
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                            <input type="text" name="pay_method" id="pay_method" value=""  onfocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                        </cfif>
                        <cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.pay_method&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.pay_method#card_link#');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-deliver_state_id">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='58449.Teslim Yeri'></label>
                <div class="col col-8 col-xs-12">
                    <cf_wrkdepartmentlocation
                        returninputvalue="deliver_loc_id,deliver_state,deliver_state_id,branch_id"
                        returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                        fieldname="deliver_state"
                        fieldid="deliver_loc_id"
                        department_fldid="deliver_state_id"
                        branch_fldid="branch_id"
                        department_id="#get_stores.DEPARTMENT_ID#"
                        location_id="#get_offer_detail.LOCATION_ID#"
                        location_name="#get_stores.DEPARTMENT_HEAD#"
                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                        width="130">
                </div>
            </div>
            <div class="form-group" id="item-sales_emp_id">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="sales_emp_id" id="sales_emp_id" value="<cfif len(get_offer_detail.sales_emp_id)>#get_offer_detail.sales_emp_id#</cfif>">
                        <input type="text" name="sales_emp_name" id="sales_emp_name"  value="<cfif len(get_offer_detail.sales_emp_id)>#get_emp_info(get_offer_detail.sales_emp_id,0,0)#</cfif>">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.sales_emp_id&field_name=form_basket.sales_emp_name&select_list=1');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-project_id">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='57416.Proje'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="project_id" id="project_id" value="#GET_OFFER_DETAIL.PROJECT_ID#">
                        <input type="text" name="project_head" id="project_head" value="<cfif len(GET_OFFER_DETAIL.PROJECT_ID)>#GET_PROJECT_NAME(GET_OFFER_DETAIL.PROJECT_ID)#</cfif>"  onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135')"autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                        <span class="input-group-addon btnPointer icon-question" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=OFFER&id='+document.getElementById('project_id').value+'','horizantal');else alert('Proje Seçiniz');"></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group" id="item-offer_status">
                <div class="col col-8 col-xs-12">
                    <label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox"  name="offer_status" id="offer_status" value="1"<cfif get_offer_detail.offer_status is 1> checked</cfif>></label>
                </div>
            </div>
            <div class="form-group" id="item-process_type">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='58859.Süreç'></label>
                <div class="col col-8 col-xs-12">
                    <cf_workcube_process is_upd='0' select_value='#get_offer_detail.offer_stage#' process_cat_width='130' is_detail='1'>
                </div>
            </div>
            <div class="form-group" id="item-priority_id">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                <div class="col col-8 col-xs-12">
                    <select name="PRIORITY_ID" id="PRIORITY_ID">
                        <cfloop query="get_setup_priority">
                            <option <cfif get_offer_detail.priority_id is priority_id>selected </cfif>value="#PRIORITY_ID#">#PRIORITY#
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-offer_currency">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id ='38502.Özel Tanım'></label>
                <div class="col col-8 col-xs-12">
                    <select name="offer_currency" id="offer_currency" >
                        <cfloop query="get_offer_currencies">
                            <option <cfif get_offer_detail.offer_currency is offer_currency_id>selected</cfif> value="#offer_currency_id#">#OFFER_CURRENCY#
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-ref_no">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='58784.Referans'></label>
                <div class="col col-8 col-xs-12">
                    <input type="text" name="ref_no" id="ref_no" maxlength="50" value="<cfif len(get_offer_detail.ref_no)>#get_offer_detail.ref_no#</cfif>" >
                </div>
            </div>
            <cfif len(get_offer_detail.for_offer_id)>
                <div class="form-group" id="item-company_ids">
                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="company_ids" id="company_ids" value="<cfif len(get_offer_detail.offer_to)>#get_offer_detail.offer_to#</cfif>">
                            <input type="text" name="company_names" id="company_names" value="<cfif len(get_offer_detail.offer_to)>#get_par_info(listdeleteduplicates(get_offer_detail.offer_to),1,1,0)#</cfif>" readonly >
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form_basket.company_ids&field_comp_name=form_basket.company_names&field_partner=form_basket.partner_ids&field_name=form_basket.partner_names&field_consumer=form_basket.consumer_ids<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8')"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-partner_ids">
                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="hidden" name="consumer_ids" id="consumer_ids" value="<cfif len(get_offer_detail.offer_to_consumer)>#get_offer_detail.offer_to_consumer#</cfif>">
                        <input type="hidden" name="partner_ids" id="partner_ids" value="<cfif len(get_offer_detail.offer_to_partner)>#get_offer_detail.offer_to_partner#</cfif>">
                        <input type="text" name="partner_names" id="partner_names" value="<cfif len(get_offer_detail.offer_to_partner) and listlen(get_offer_detail.offer_to_partner) neq 0>#get_par_info(listdeleteduplicates(get_offer_detail.offer_to_partner),0,-1,0)#<cfelseif Len(get_offer_detail.offer_to_consumer)>#get_cons_info(listdeleteduplicates(get_offer_detail.offer_to_consumer),0,0)#</cfif>" >
                    </div>
                </div>
            <cfelse>
                <div class="form-group" id="item-is_public_zone">
                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='29479.Yayın'></label>
                    <div class="col col-8 col-xs-12">
                        <label><input type="checkbox" name="is_public_zone" id="is_public_zone" value="1" <cfif len(get_offer_detail.is_public_zone) and get_offer_detail.is_public_zone eq 1>checked</cfif>><cf_get_lang dictionary_id='38605.Public'></label>
                        <label><input type="checkbox" name="is_partner_zone" id="is_partner_zone" value="1"<cfif len(get_offer_detail.is_partner_zone) and get_offer_detail.is_partner_zone eq 1>checked</cfif>><cf_get_lang dictionary_id='58885.Partner'></label>
                    </div>
                </div>
            </cfif>
        </div>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="3" sort="true">
            <div class="form-group" id="item-work_id">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='38513.İş Görev'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="work_id" id="work_id" value="<cfif len(get_offer_detail.work_id)>#get_offer_detail.work_id#<cfelseif isdefined("get_related_internaldemand.work_id") and len(get_related_internaldemand.work_id)>#get_related_internaldemand.work_id#</cfif>">
                        <input type="text" name="work_head" id="work_head" value="<cfif len(get_offer_detail.work_id)>#get_work_name(get_offer_detail.work_id)#<cfelseif isdefined("get_related_internaldemand.work_id") and len(get_related_internaldemand.work_id)>#get_work_name(get_related_internaldemand.work_id)#</cfif>">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head&project_id='+document.getElementById('project_id').value+'&project_head='+document.getElementById('project_head').value+'');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-offer_date">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='38655.Teklif Tarihi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='38656.teklif tarihi girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="offer_date" value="#dateformat(get_offer_detail.offer_date,dateformat_style)#" required="yes"  message="#message#" validate="#validate_style#" passthrough="onBlur=""change_money_info('form_basket','offer_date');""">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="offer_date" call_function="change_money_info"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-offer_finishdate1">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id ='38503.Teklif Son Tarihi'></label>
                <div class="col col-4 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" name="offer_finishdate" value="#dateformat(get_offer_detail.offer_finishdate,dateformat_style)#"  message="#getLang('','Teklif Sonlanma Tarihi Girmelisiniz',38656)#" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="offer_finishdate"></span>
                    </div>
                </div>
                <div class="col col-2 col-xs-12">
                    <cfif len(get_offer_detail.offer_finishdate)>
                        <cf_wrkTimeFormat name="offer_finish_hour" id="offer_finish_hour" value="#NumberFormat("#datepart("H",get_offer_detail.offer_finishdate)#",00)#">
                    <cfelse>
                        <cf_wrkTimeFormat name="offer_finish_hour" id="offer_finish_hour" value="#NumberFormat("00",00)#">
                    </cfif>
                </div>
                <div class="col col-2 col-xs-12">
                    <select name="offer_finish_min" id="offer_finish_min" >
                        <cfloop from="0" to="55" step="5" index="app_min">
                            <option value="#NumberFormat(app_min,00)#" <cfif len(get_offer_detail.offer_finishdate) and datepart("N",get_offer_detail.offer_finishdate) eq app_min>selected</cfif>>#NumberFormat(app_min,00)#</option>
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-deliverdate">
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57645.Teslim Tarihi'></cfsavecontent>
                        <cfinput type="text" name="deliverdate" value="#dateformat(get_offer_detail.deliverdate,dateformat_style)#" validate="#validate_style#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="deliverdate" call_function="change_money_info"></span>
                    </div>
                </div>
            </div>
            <cfif len(get_offer_detail.for_offer_id)>
                <div class="form-group" id="item-related_offer_id">
                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id ='38501.İlişkili Teklif'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="related_offer_id" id="related_offer_id" value="#get_offer_detail.for_offer_id#">
                            <input type="text" name="related_offer_number" id="related_offer_number" value="#get_related_offer_.offer_number#" readonly >
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="goster(iliskili_teklif_id);list_teklif();"></span>
                            <div style="position:absolute;height:200;width:80;z-index:9999;"id="iliskili_teklif_id"></div>
                            <script type="text/javascript">
                            function list_teklif(){AjaxPageLoad('#request.self#?fuseaction=purchase.popup_add_related_purchase_offer&offer_id_=' + document.all.related_offer_id.value+ '','iliskili_teklif_id',1);}
                            </script>
                        </div>
                    </div>
                </div>
            <cfelse>
                <div class="form-group" id="item-startdate">
                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='38607.Yayın Başlama'></label>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="startdate" id="startdate" value="#dateformat(get_offer_detail.startdate,dateformat_style)#"  validate="#validate_style#" message="#getLang('','Lütfen Yayın Başlama Tarihi Giriniz',38686)#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate" call_function="change_money_info"></span>
                        </div>
                    </div>
                    <div class="col col-2 col-xs-12">
                        <cfif len(get_offer_detail.startdate)>
                            <cf_wrkTimeFormat name="start_hour" id="start_hour" value="#NumberFormat("#datepart("H",get_offer_detail.startdate)#",00)#">
                        <cfelse>
                            <cf_wrkTimeFormat name="start_hour" id="start_hour" value="#NumberFormat("00",00)#">
                        </cfif>
                    </div>
                    <div class="col col-2 col-xs-12">
                        <select name="start_min" id="start_min">
                            <cfloop from="0" to="55" step="5" index="app_min">
                                <option value="#NumberFormat(app_min,00)#" <cfif len(get_offer_detail.startdate) and datepart("N",get_offer_detail.startdate) eq app_min>selected</cfif>>#NumberFormat(app_min,00)#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-finishdate2">
                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='38611.Yayın Bitiş'></label>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='38536.Yayın Bitiş Tarihi'></cfsavecontent>
                            <cfinput type="text" name="finishdate" value="#dateformat(get_offer_detail.finishdate,dateformat_style)#"  message="#message#" validate="#validate_style#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                        </div>
                    </div>
                    <div class="col col-2 col-xs-12">
                        <cfif len(get_offer_detail.finishdate)>
                            <cf_wrkTimeFormat name="finish_hour" id="finish_hour" value="#NumberFormat("#datepart("H",get_offer_detail.finishdate)#",00)#">
                        <cfelse>
                            <cf_wrkTimeFormat name="finish_hour" id="finish_hour" value="#NumberFormat("00",00)#">
                        </cfif>
                    </div>
                    <div class="col col-2 col-xs-12">
                        <select name="finish_min" id="finish_min">
                            <cfloop from="0" to="55" step="5" index="app_min">
                                <option value="#NumberFormat(app_min,00)#" <cfif len(get_offer_detail.finishdate) and datepart("N",get_offer_detail.finishdate) eq app_min>selected</cfif>>#NumberFormat(app_min,00)#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
            </cfif>
            <div class="form-group" id="item-cf_wrk_add_info">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                <div class="col col-8 col-xs-12"> 
                    <cf_wrk_add_info info_type_id="-30" info_id="#attributes.offer_id#" upd_page = "1" colspan="9"> 
                </div>
            </div>
        </div>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="4" sort="true">
            <cfif len(get_offer_detail.for_offer_id)>
                <div class="form-group" id="item-bagli_teklif">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='38510.Bağlı Olduğu Teklif'>:</label>
                    <div class="col col-8 col-xs-12">
                        <cfoutput><a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#get_offer_detail.for_offer_id#" class="tableyazi">#get_related_offer_.offer_number#</a> - #TLFormat(get_related_offer_.other_money_value)# #get_related_offer_.other_money#</cfoutput>
                    </div>
                </div>
            <cfelse>
                <div class="form-group" id="teklif_isteyenler_alan">
                    <cfsavecontent variable="msg_txt"><cf_get_lang dictionary_id='38600.Teklif İstenenler'></cfsavecontent>
                    <cfif x_related_offer_view_type Eq 0>
                        <cfset to_title = 1 />
                    <cfelseif x_related_offer_view_type Eq 1>
                        <cfset to_title = 3 />
                    </cfif>
                    <cf_workcube_to_cc
                        is_update = "1"
                        to_dsp_name = "#msg_txt#"
                        form_name = "form_basket"
                        str_list_param = "2"
                        select_list = "7,8"
                        action_dsn = "#DSN3#"
                        str_action_names = "OFFER_TO AS TO_COMP,OFFER_TO_PARTNER AS TO_PAR,OFFER_TO_CONSUMER AS TO_CON"
                        action_table = "OFFER"
                        action_id_name = "OFFER_ID"
                        action_id = "#attributes.OFFER_ID#"
                        data_type = "1"
                        str_alias_names = ""
                        from_purchase_offer="1"
                        print_all="2"
                        to_title="#to_title#">
                </div>
            </cfif>
            <cfif isDefined("x_sales_tender_type") and x_sales_tender_type eq 1>
                <div class="form-group" id="item-tender_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="47808.İhale Tipi"></label>
                    <div class="col col-8 col-xs-12">
                        <cfquery name="get_tender_types" datasource="#dsn3#">
                            SELECT * FROM PURCHASE_SALES_TENDER_TYPE
                        </cfquery>
                        <select name="tender_type" id="tender_type">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <cfloop query="get_tender_types">
                                <option value="#TENDER_TYPE_ID#" <cfif TENDER_TYPE_ID eq get_offer_detail.TENDER_TYPE_ID>selected</cfif>>#TENDER_TYPE#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
            </cfif>
            <cfif isDefined("x_sales_bargaining_type") and x_sales_bargaining_type eq 1>
                <div class="form-group" id="item-bargaining_type">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60627.Pazarlık Tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="bargaining_type" id="bargaining_type">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <option value="1" <cfif get_offer_detail.BARGAINING_TYPE_ID eq 1>selected</cfif>><cf_get_lang dictionary_id='46843.Açık Eksiltme'></option>
                            <option value="2" <cfif get_offer_detail.BARGAINING_TYPE_ID eq 2>selected</cfif>><cf_get_lang dictionary_id='46842.Açık Arttırma'></option>
                            <option value="3" <cfif get_offer_detail.BARGAINING_TYPE_ID eq 3>selected</cfif>><cf_get_lang dictionary_id='60628.Kapalı Zarf'></option>
                            <option value="4" <cfif get_offer_detail.BARGAINING_TYPE_ID eq 4>selected</cfif>><cf_get_lang dictionary_id='60629.Pazarlık Usulü'></option>
                        </select>
                    </div>
                </div>
            </cfif>
            <cfif len(get_offer_detail.ACCEPTED_OFFER_ID)>
                <cfquery name="get_accepted_offer" datasource="#dsn3#">
                    SELECT OFFER_NUMBER,OFFER_HEAD,OFFER_TO_PARTNER,OTHER_MONEY,OTHER_MONEY_VALUE FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_detail.ACCEPTED_OFFER_ID#">
                </cfquery>
                <div class="form-group" id="item-accepted_offer">
                    <div class="col col-12 col-xs-12">
                        <cf_get_lang dictionary_id='59521.Kabul Edilen Teklif'>:<cfoutput><a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#get_offer_detail.ACCEPTED_OFFER_ID#" class="tableyazi">#get_accepted_offer.offer_number#</a> - #TLFormat(get_accepted_offer.other_money_value)# #get_accepted_offer.other_money#</cfoutput>
                    </div>
                </div>
            </cfif>
        </div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="5" sort="true">
            <div class="form-group" id="item-offer_detail">
                <label class="col col-12 col-xs-12">
                    <a href="javascript:void(0)" id="list_address_img4" onclick="gizle_goster_image('list_address_img3','list_address_img4','ek_bilgi');"><i class="fa fa-arrow-right"></i></a>
                    <a href="javascript:void(0)" id="list_address_img3" style="display:none;" onclick="gizle_goster_image('list_address_img3','list_address_img4','ek_bilgi');"><i class="fa fa-arrow-up"></i></a>
                    <cf_get_lang dictionary_id='38571.Ek aciklama girmek için tiklayiniz'>
                </label>
            </div>
            <div class="form-group" id="item-offer_detail2">
                <div class="col col-12 col-xs-12" id="ek_bilgi" style="display:none;">
                    <cfmodule
                        template="/fckeditor/fckeditor.cfm"
                        toolbarset="Basic"
                        basepath="/fckeditor/"
                        instancename="offer_detail"
                        valign="top"
                        value="#get_offer_detail.offer_detail#"
                        width="650"
                        height="150">
                </div>
            </div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <div class="col col-6">
            <cf_record_info 
                query_name="get_offer_detail" 
                record_emp="record_member" 
                record_date="record_date"
                update_emp="update_member"
                update_date="update_date">
        </div>
        <div class="col col-6">
            <cfif get_offer_detail.is_processed eq 1>
                    <font color="red"><cf_get_lang dictionary_id='38577.işlendi'>!</font>
            <cfelse>
                <cfif get_control_for_offer_id.recordCount>
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                <cfelse>
                    <cf_workcube_buttons is_upd='1' is_delete='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=purchase.emptypopup_del_offer&offer_id=#get_offer_detail.OFFER_ID#'>
                </cfif>
            </cfif>
        </div>
    </cf_box_footer>
</cfoutput>
