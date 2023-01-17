<cfset offer_to_info = 0>
<cfif isdefined("get_offer_detail")>
	<cfset partner_list = "">
	<cfset consumer_list = "">
	<cfif Len(get_offer_detail.offer_to_partner)><cfset partner_list = get_offer_detail.offer_to_partner></cfif>
	<cfif Len(get_offer_detail.offer_to_consumer)><cfset consumer_list = get_offer_detail.offer_to_consumer></cfif>
	<cfif (ListLen(partner_list)+ListLen(consumer_list)) eq 1>
		<cfif ListLen(partner_list)>
			<cfset offer_to_info = 1>
		<cfelse>
			<cfset offer_to_info = 2>
		</cfif>
	</cfif>
</cfif>
<cfoutput>
    <cf_box_elements><!---/// Satır type a row verilecek --->
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="1" sort="true"><!---/// Kolon  type column verilecek sort duruma göre true false--->
            <div class="form-group" id="item-offer_head"><!---/// uniq id verilecek tr de tanmılı id yi alabilirsiniz.--->
                <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='58820.Başlık'></label><!---/// label --->
                <div class="col col-8 col-xs-12"> <!---/// input content --->
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='38560.Başlık Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" required="Yes" message="#message#" value="#attributes.offer_head#" name="offer_head" maxlength="200">
                </div>
            </div>
            <cfif xml_show_process_stage eq 1>
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process_cat slct_width="150"  >
                    </div>
                </div>
            </cfif>    
            <div class="form-group" id="item-order_employee_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id)>#attributes.ship_method_id#</cfif>">
                        <cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id)>
                            <cfset attributes.ship_method = attributes.ship_method_id>
                            <cfinclude template="../query/get_ship_method.cfm">
                            <cfset attributes.ship_method_name = get_ship_method.ship_method>
                        </cfif>
                        <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and isdefined('attributes.ship_method_name') and len(attributes.ship_method_name)>#attributes.ship_method_name#</cfif>">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-paymethod_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>
                            <cfset pay_id =attributes.paymethod_id>
                            <cfinclude template="../query/get_payment_method.cfm">
                            <cfset paymethod_id_ = get_payment_method.paymethod_id>
                            <cfset card_paymethod_id_ = "">
                            <cfset commission_rate_ = "">
                            <cfset paymethod_vehicle_ = get_payment_method.payment_vehicle>
                            <cfset pay_method_ = get_payment_method.paymethod>
                        <cfelseif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
                                <cfset card_pay_id = attributes.card_paymethod_id>
                            <cfinclude template="../query/get_card_paymethod.cfm">
                            <cfset paymethod_id_ = "">
                            <cfset card_paymethod_id_ = get_card_paymethod.payment_type_id>
                            <cfset commission_rate_ = get_card_paymethod.commission_multiplier>
                            <cfset paymethod_vehicle_ = "-1">
                            <cfset pay_method_ = get_card_paymethod.card_no>
                        <cfelse>
                            <cfset paymethod_id_ = "">
                            <cfset card_paymethod_id_ = "">
                            <cfset commission_rate_ = "">
                            <cfset paymethod_vehicle_ = "">
                            <cfset pay_method_ = "">
                            <!--- Odeme Yontemi Yoksa Kurumsal veya Bireysel Oyelerdeki Yontemleri Kontrol Edilir --->
                            <cfif isDefined("attributes.member_id") and Len(attributes.member_id)>
                                <cfquery name="get_member_company" datasource="#dsn#">
                                    SELECT COMPANY_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.member_id#">
                                </cfquery>
                                <cfset get_member_payment_method = createObject("component","V16.objects.cfc.getMemberPaymentMethod").getMemberPaymentMethod(dsn:dsn,is_sales_type:0,our_company_id:session.ep.company_id,company_id:iif(isDefined("attributes.member_id"),"get_member_company.company_id",""),consumer_id:iif(isDefined("attributes.consumer_id"),"attributes.consumer_id",""))>
                                <cfif get_member_payment_method.recordcount>
                                    <cfset paymethod_id_ = get_member_payment_method.payment_method_id>
                                    <cfset card_paymethod_id_ = get_member_payment_method.card_payment_method_id>
                                    <cfset commission_rate_ = get_member_payment_method.commission_multiplier>
                                    <cfset paymethod_vehicle_ = get_member_payment_method.payment_vehicle>
                                    <cfset pay_method_ = get_member_payment_method.payment_method_name>
                                </cfif>
                            </cfif>
                        </cfif>
                        <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="#paymethod_vehicle_#">
                        <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#card_paymethod_id_#">
                        <input type="hidden" name="commission_rate" id="commission_rate" value="#commission_rate_#">
                        <input type="hidden" name="paymethod_id" id="paymethod_id" value="#paymethod_id_#">
                        <input type="text" name="pay_method" id="pay_method" value="#pay_method_#"  onfocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                        <cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.pay_method&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.pay_method#card_link#');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-deliver_state_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58449.Teslim Yeri'></label>
                <div class="col col-8 col-xs-12">
                    <cf_wrkdepartmentlocation
                        returninputvalue="deliver_loc_id,deliver_state,deliver_state_id,branch_id"
                        returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                        fieldname="deliver_state"
                        fieldid="deliver_loc_id"
                        department_fldid="deliver_state_id"
                        branch_fldid="branch_id"
                        branch_id="#attributes.branch_id#"
                        department_id="#attributes.deliver_state_id#"
                        location_id="#attributes.deliver_loc_id#"
                        location_name="#attributes.deliver_state#"
                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#">
                </div>
            </div>
            <div class="form-group" id="item-sales_emp_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="sales_emp_id" id="sales_emp_id" value="#session.ep.userid#">
                        <input type="text" name="sales_emp_name" id="sales_emp_name" value="#get_emp_info(session.ep.userid,0,0)#"  onfocus="AutoComplete_Create('sales_emp','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','sales_emp_id','','3','125');" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.sales_emp_id&field_name=form_basket.sales_emp_name&select_list=1');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-project_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#</cfif>">
                        <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#get_project_name(attributes.project_id)#</cfif>"  onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135')"autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                        <span class="input-group-addon btnPointer icon-question" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=OFFER&id='+document.getElementById('project_id').value+'','horizantal');else alert('<cf_get_lang dictionary_id='58797.Proje Seçiniz'>');"></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group" id="item-process_type">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                <div class="col col-8 col-xs-12">
                    <cf_workcube_process is_upd='0' is_detail='0'>
                </div>
            </div>
            <div class="form-group" id="item-priority_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                <div class="col col-8 col-xs-12">
                    <select name="priority_id" id="priority_id">
                        <cfloop query="get_setup_priority">
                            <option value="#priority_id#" <cfif isdefined('attributes.priority') and len(attributes.priority) and attributes.priority eq priority_id>selected</cfif>>#PRIORITY#</option>
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-offer_currency">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='38502.Özel Tanım'></label>
                <div class="col col-8 col-xs-12">
                    <select name="offer_currency" id="offer_currency">
                        <cfloop query="get_offer_currencies">
                            <option value="#offer_currency_id#" <cfif len(attributes.offer_currency) and attributes.offer_currency eq offer_currency_id>selected</cfif>>#OFFER_CURRENCY#</option>
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-ref_no">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
                <div class="col col-8 col-xs-12">
                    <input type="text" name="ref_no" id="ref_no" maxlength="50" value="<cfif (isdefined('attributes.internal_row_info') and isdefined('internaldemand_id_list') and len(internaldemand_id_list)) or (isdefined("attributes.internaldemand_id") and len(attributes.internaldemand_id))>#internal_number_list#<cfelseif isdefined('attributes.ref_no') and len(attributes.ref_no)>#attributes.ref_no#</cfif>">
                </div>
            </div>
            <div class="form-group" id="item-cf_wrk_add_info">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                <div class="col col-8 col-xs-12"> 
                    <cf_wrk_add_info info_type_id="-30" upd_page= "0"> 
                </div>
            </div>
            <cfif isdefined("attributes.for_offer_id") and len(attributes.for_offer_id)>
                <div class="form-group" id="item-company_ids">
                    <label class="col col-4 col-xs-3"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="company_ids" id="company_ids" value="<cfif isdefined("attributes.company_ids")>#listdeleteduplicates(attributes.company_ids)#<cfelseif offer_to_info eq 1>#listdeleteduplicates(get_offer_detail.offer_to)#</cfif>">
                            <input type="text" name="company_names" id="company_names" value="<cfif isdefined("attributes.company_ids")>#get_par_info(listdeleteduplicates(attributes.company_ids),1,1,0)#<cfelseif offer_to_info eq 1>#get_par_info(listdeleteduplicates(get_offer_detail.offer_to),1,1,0)#</cfif>" readonly>
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form_basket.company_ids&field_comp_name=form_basket.company_names&field_partner=form_basket.partner_ids&field_name=form_basket.partner_names&field_consumer=form_basket.consumer_ids<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8')"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-partner_ids">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                    <div class="col col-8 col-xs-12">
                        <input type="hidden" name="consumer_ids" id="consumer_ids" value="<cfif isdefined('attributes.consumer_ids')>#attributes.consumer_ids#<cfelseif offer_to_info eq 2>#listfirst(get_offer_detail.offer_to_consumer,',')#</cfif>">
                        <input type="hidden" name="partner_ids" id="partner_ids" value="<cfif isdefined('attributes.partner_ids')>#attributes.partner_ids#<cfelseif offer_to_info eq 1>#listfirst(get_offer_detail.offer_to_partner,',')#</cfif>">
                        <input type="text" name="partner_names" id="partner_names" value="<cfif isdefined('attributes.consumer_ids')>#get_cons_info(attributes.consumer_ids,0,0)#<cfelseif isdefined('attributes.partner_ids')>#get_par_info(attributes.partner_ids,0,-1,0)#<cfelseif offer_to_info eq 1>#get_par_info(listfirst(get_offer_detail.offer_to_partner,','),0,-1,0)#<cfelseif offer_to_info eq 2>#get_cons_info(listfirst(get_offer_detail.offer_to_consumer,','),0,0)#</cfif>">
                    </div>
                </div>
            <cfelse>
                <div class="form-group" id="item-is_public_zone">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29479.Yayın'></label>
                    <div class="col col-8 col-xs-12">
                        <label><input type="checkbox" name="is_public_zone" id="is_public_zone" value="1" <cfif len(attributes.is_public_zone) and attributes.is_public_zone eq 1>checked</cfif>><cf_get_lang dictionary_id='38605.Public'></label>
                        <label><input type="checkbox" name="is_partner_zone" id="is_partner_zone" value="1"<cfif len(attributes.is_partner_zone) and attributes.is_partner_zone eq 1>checked</cfif>><cf_get_lang dictionary_id='58885.Partner'></label>
                    </div>
                </div>
            </cfif>
        </div>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-work_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38513.İş Görev'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="work_id" id="work_id" value="<cfif isdefined("attributes.work_id") and len(attributes.work_id)>#attributes.work_id#</cfif>">
                        <input type="text" name="work_head" id="work_head" value="<cfif isdefined("attributes.work_id") and len(attributes.work_id)>#get_work_name(attributes.work_id)#</cfif>">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head&project_id='+document.getElementById('project_id').value+'&project_head='+document.getElementById('project_head').value+'');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-offer_date">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38655.Teklif Tarihi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='38656.teklif tarihi girmelisiniz'></cfsavecontent>
                        <cfif isdefined("attributes.offer_date")><cfset new_date = attributes.offer_date><cfelse><cfset new_date = dateformat(now(),dateformat_style)></cfif>
                        <cfinput type="text" name="offer_date" value="#new_date#" required="yes" message="#message#" validate="#validate_style#" passthrough="onBlur=""change_money_info('form_basket','offer_date');""">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="offer_date" call_function="change_money_info"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-offer_finishdate">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='38503.Teklif Son Tarihi'></label>
                <div class="col col-4 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" name="offer_finishdate" value="#attributes.offer_finishdate#" message="#getLang('','Teklif Sonlanma Tarihi Girmelisiniz',38656)#" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="offer_finishdate"></span>
                    </div>
                </div>
                <div class="col col-2 col-xs-12">
                    <cf_wrkTimeFormat name="offer_finish_hour" id="offer_finish_hour" value="#NumberFormat("#timeformat(now(),'HH')#",00)#">
                </div>
                <div class="col col-2 col-xs-12">
                    <select name="offer_finish_min" id="offer_finish_min">
                        <cfloop from="0" to="55" step="5" index="app_min">
                            <option value="#NumberFormat(app_min,00)#">#NumberFormat(app_min,00)#</option>
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-deliverdate">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57645.Teslim Tarihi'></cfsavecontent>
                        <cfinput type="text" name="deliverdate" value="#attributes.deliverdate#" validate="#validate_style#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="deliverdate" call_function="change_money_info"></span>
                    </div>
                </div>
            </div>
            <cfif isdefined("attributes.for_offer_id") and len(attributes.for_offer_id)>
                <div class="form-group" id="item-related_offer_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='38501.İlişkili Teklif'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="related_offer_id" id="related_offer_id" value="#attributes.for_offer_id#">
                            <input type="text" name="related_offer_number" id="related_offer_number" value="<cfif len(get_related_offer_.offer_number)>#get_related_offer_.offer_number#</cfif>" readonly>
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="goster(iliskili_teklif_id);list_teklif();"></span>
                            <div style="position:absolute;height:200;width:80;z-index:9999;"id="iliskili_teklif_id"></div>
                            <script type="text/javascript">
                                function list_teklif(){AjaxPageLoad('#request.self#?fuseaction=purchase.popup_add_related_purchase_offer&offer_id_=' + document.getElementById('related_offer_id').value+ '','iliskili_teklif_id',1);}
                            </script>
                        </div>
                    </div>
                </div>
            <cfelse>
                <div class="form-group" id="item-startdate">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38607.Yayın Başlama'></label>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="startdate" value="#attributes.startdate#" validate="#validate_style#" message="#getLang('','Lütfen Yayın Başlama Tarihi Giriniz',38686)#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="startdate" call_function="change_money_info"></span>
                        </div>
                    </div>
                    <div class="col col-2 col-xs-12">
                        <cf_wrkTimeFormat name="start_hour" id="start_hour" value="#NumberFormat("#timeformat(now(),'HH')#",00)#">
                    </div>
                    <div class="col col-2 col-xs-12">
                        <select name="start_min" id="start_min">
                            <cfloop from="0" to="55" step="5" index="app_min">
                                <option value="#NumberFormat(app_min,00)#">#NumberFormat(app_min,00)#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-finishdate">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38611.Yayın Bitiş'></label>
                    <div class="col col-4 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='38536.Yayın Bitiş Tarihi'></cfsavecontent>
                            <cfinput type="text" name="finishdate" value="#attributes.finishdate#" message="#message#" validate="#validate_style#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                        </div>
                    </div>
                    <div class="col col-2 col-xs-12">
                        <cf_wrkTimeFormat name="finish_hour" id="finish_hour" value="#NumberFormat("#timeformat(now(),'HH')#",00)#">
                    </div>
                    <div class="col col-2 col-xs-12">
                        <select name="finish_min" id="finish_min">
                            <cfloop from="0" to="55" step="5" index="app_min">
                                <option value="#NumberFormat(app_min,00)#">#NumberFormat(app_min,00)#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
            </cfif>
        </div>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="4" sort="true">
            <cfif not (isdefined("attributes.for_offer_id") and len(attributes.for_offer_id))>
                <div class="form-group" id="item-OFFER_ID">
                    <label style="display:none;"><cf_get_lang dictionary_id='38600.Teklif İstenenler'></label>
                        <cfsavecontent variable="header_"><cf_get_lang dictionary_id='38600.Teklif İstenenler'></cfsavecontent>
                        <cfif isdefined("attributes.offer_id") and len(attributes.offer_id)>
                            <cf_workcube_to_cc
                                is_update = "1"
                                to_dsp_name = "#header_#"
                                form_name = "form_basket"
                                str_list_param = "2"
                                select_list = "7,8"
                                action_dsn = "#DSN3#"
                                str_action_names = "OFFER_TO AS TO_COMP,OFFER_TO_PARTNER AS TO_PAR,OFFER_TO_CONSUMER TO_CON"
                                action_table = "OFFER"
                                action_id_name = "OFFER_ID"
                                action_id = "#attributes.offer_id#"
                                data_type = "1"
                                str_alias_names = "">
                        <cfelseif isdefined('attributes.member_id') and len(attributes.member_id)>
                            <cf_workcube_to_cc
                                is_update = "1"
                                to_dsp_name = "#header_#"
                                form_name = "form_basket"
                                str_list_param = "2"
                                select_list = "7,8"
                                action_dsn = "#DSN#"
                                str_action_names = "PARTNER_ID AS TO_PAR"
                                action_table = "COMPANY_PARTNER"
                                action_id_name = "PARTNER_ID"
                                action_id = "#attributes.member_id#"
                                data_type = "1"
                                str_alias_names = "">
                        <cfelse>
                            <cf_workcube_to_cc
                                is_update="0"
                                to_dsp_name="#header_#"
                                form_name="form_basket"
                                str_list_param = "2"
                                select_list = "7,8"
                                data_type="1">
                        </cfif>
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
                                <option value="#TENDER_TYPE_ID#">#TENDER_TYPE#</option>
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
                            <option value="1"><cf_get_lang dictionary_id='46843.Açık Eksiltme'></option>
                            <option value="2"><cf_get_lang dictionary_id='46842.Açık Arttırma'></option>
                            <option value="3"><cf_get_lang dictionary_id='60628.Kapalı Zarf'></option>
                            <option value="4"><cf_get_lang dictionary_id='60629.Pazarlık Usulü'></option>
                        </select>
                    </div>
                </div>
            </cfif>                    
        </div>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="5" sort="true">
            <div class="form-group" id="item-offer_detail">
                <label class="col col-12 col-xs-12">
                    <a href="javascript:void(0)" onclick="gizle_goster_image('list_address_img3','list_address_img4','detail_menu');"><i class="fa fa-arrow-right" id="list_address_img4" style="display:;cursor:pointer;"></i></a>
                    <a href="javascript:void(0)" onclick="gizle_goster_image('list_address_img3','list_address_img4','detail_menu');"><i class="fa fa-arrow-up" id="list_address_img3" style="display:none;cursor:pointer;"></i></a>
                    <cf_get_lang dictionary_id='38571.Ek aciklama girmek için tiklayiniz'>
                </label>
            </div>
            <div class="form-group" id="item-offer_detail2">
                <div class="col col-12 col-xs-12" id="detail_menu" style="display:none;">
                    <cfmodule
                        template="/fckeditor/fckeditor.cfm"
                        toolbarset="Basic"
                        basepath="/fckeditor/"
                        instancename="offer_detail"
                        valign="top"
                        value="#attributes.offer_detail#"
                        width="650"
                        height="150">
                </div>
            </div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <cf_basket_form_button><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_basket_form_button>
    </cf_box_footer>
</cfoutput>