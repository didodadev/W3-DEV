<cfoutput>
    <cf_box_elements>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="1" sort="true"><!---/// Kolon  type column verilecek sort duruma göre true false--->
            <div class="form-group" id="item-order_head"><!---/// uniq id verilecek tr de tanmılı id yi alabilirsiniz.--->
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'></label><!---/// label --->
                <div class="col col-8 col-xs-12"> <!---/// input content --->
                    <cfinput type="text" name="order_head" value="#get_order_detail.order_head#" required="yes" message="#getLang('','Başlık girmelisiniz',38560)#" maxlength="200">
                </div>
            </div>
            <div class="form-group" id="item-consumer_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari hesap'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <input type="hidden" name="consumer_id" id="consumer_id" value="#get_order_detail.consumer_id#">
                        <input type="hidden" name="company_id" id="company_id" value="#get_order_detail.company_id#">
                        <input readonly type="text" name="company" id="company"  value="<cfif Len(get_order_detail.company_id)>#get_par_info(get_order_detail.company_id,1,0,0)#</cfif>">
                        <cfset str_linkeait="&field_consumer=form_basket.consumer_id&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.pay_method&field_basket_due_value=form_basket.basket_due_value&ship_method_id=form_basket.ship_method_id&ship_method_name=form_basket.ship_method_name&field_card_payment_id=form_basket.card_paymethod_id">		  
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form_basket.company_id&field_comp_name=form_basket.company&field_partner=form_basket.partner_id&field_name=form_basket.partner&field_adress_id=form_basket.ship_address_id&field_long_address=form_basket.ship_address&field_city_id=form_basket.ship_address_city_id&field_county_id=form_basket.ship_address_county_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&call_function=change_paper_duedate()&select_list=7,8#str_linkeait#')"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-partner">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'>*</label>
                <div class="col col-8 col-xs-12"> 
                    <input type="hidden" name="partner_id" id="partner_id" value="#get_order_detail.PARTNER_ID#">
                    <input readonly type="text" name="partner" id="partner" value="<cfif len(get_order_detail.PARTNER_ID)>#get_par_info(get_order_detail.PARTNER_ID,0,-1,0)#<cfelseif len(get_order_detail.consumer_id)>#get_cons_info(get_order_detail.consumer_id,0,0)#</cfif>">
                </div>
            </div>
            <div class="form-group" id="item-order_employee">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58796.Sipariş Veren'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <input type="hidden" name="order_employee_id" id="order_employee_id" value="#get_order_detail.order_employee_id#">
                        <input type="text" name="order_employee" id="order_employee" value="#get_emp_info(get_order_detail.order_employee_id,0,0)#" onFocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','130');" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.order_employee&field_emp_id2=form_basket.order_employee_id')"></span>
                    </div>    
                </div>
            </div>
            <div class="form-group" id="item-ref_no">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
                <div class="col col-8 col-xs-12"> 
                    <input type="text" name="ref_no" id="ref_no"  maxlength="50" value="<cfif len(get_order_detail.ref_no)>#get_order_detail.ref_no#</cfif>" >
                </div>
            </div>
            <div class="form-group" id="item-work_head">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38513.İş Görev'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <cfif len(get_order_detail.work_id)>
                            <cfquery name="GET_WORK" datasource="#dsn#">
                                SELECT WORK_HEAD FROM PRO_WORKS WHERE WORK_ID = #get_order_detail.work_id#
                            </cfquery>
                        </cfif>
                        <input type="hidden" name="work_id"  id="work_id" value="<cfoutput>#get_order_detail.work_id#</cfoutput>">
                        <input type="text" name="work_head" id="work_head"  value="<cfif len(get_order_detail.work_id)><cfoutput>#GET_WORK.WORK_HEAD#</cfoutput></cfif>">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction</cfoutput>=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-cf_wrk_add_info">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                <div class="col col-8 col-xs-12"> 
                    <cf_wrk_add_info info_type_id="-12" info_id="#attributes.order_id#" upd_page = "1" colspan="9">
                </div>
            </div>                    
        </div>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="2" sort="true"><!---/// Kolon  type column verilecek sort duruma göre true false--->
            <div class="form-group" id="item-order_date">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <cfinput type="text" name="order_date"  value="#dateformat(get_order_detail.order_date,dateformat_style)#" validate="#validate_style#" message="#getLang('','Sipariş Tarihi Girmelisiniz',38654)# !" maxlength="10" required="yes">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="order_date" call_function="change_money_info"></span> 
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-deliverdate">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'>*</label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <cfinput type="text" name="deliverdate"  value="#dateformat(get_order_detail.deliverdate,dateformat_style)#" validate="#validate_style#" message="#getLang('','Teslim girmelisiniz',38627)#" maxlength="10" required="yes">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="deliverdate"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-pay_method">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <cfif len(get_order_detail.paymethod)>
                            <cfset pay_id =get_order_detail.PAYMETHOD>
                            <cfinclude template="../query/get_payment_method.cfm">
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="#get_payment_method.paymethod_id#">
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                            <input type="hidden" name="commission_rate" id="commission_rate" value="">
                            <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="#get_payment_method.payment_vehicle#"> <!--- Ödeme aracını tutuyor ve basket hesaplamalarında kullanılıyor lütfen silmeyiniz --->
                            <input type="text" name="pay_method" id="pay_method" value="#get_payment_method.paymethod#"  onFocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                        <cfelseif len(get_order_detail.card_paymethod_id)>
                            <cfquery name="get_card_paymethod" datasource="#dsn3#">
                                SELECT CARD_NO,COMMISSION_MULTIPLIER FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID=#get_order_detail.card_paymethod_id#
                            </cfquery>
                            <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="-1">
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="#get_order_detail.card_paymethod_id#">
                            <input type="hidden" name="commission_rate" id="commission_rate" value="#get_card_paymethod.commission_multiplier#">
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                            <input type="text" name="pay_method" id="pay_method" value="#get_card_paymethod.card_no#"  onFocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                        <cfelse>
                            <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="">
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
                            <input type="hidden" name="commission_rate" id="commission_rate" value="">
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                            <input type="text" name="pay_method" id="pay_method" value=""   onFocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                        </cfif>
                        <cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.pay_method&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=<cfif xml_delivery_date_calculated>deliverdate<cfelse>order_date</cfif>&field_id=form_basket.paymethod_id&field_name=form_basket.pay_method&field_dueday=form_basket.basket_due_value#card_link#');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-basket_due_value">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57881.Vade/Tarih'></label>
                <div class="col col-3 col-xs-12"> 
                <cfif xml_delivery_date_calculated neq 1>
                    <input type="text" name="basket_due_value" id="basket_due_value" value="<cfif len(get_order_detail.due_date) and len(get_order_detail.order_date)>#datediff('d',get_order_detail.order_date,get_order_detail.due_date)#</cfif>"onChange="change_paper_duedate('order_date');" onKeyUp="isNumber(this);" >
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='38681.Vade Tarihi İçin Geçerli Bir Format Giriniz'>!</cfsavecontent>
                <cfelse>
                    <input type="text" name="basket_due_value" id="basket_due_value" value="<cfif len(get_order_detail.due_date) and len(get_order_detail.deliverdate)>#datediff('d',get_order_detail.deliverdate,get_order_detail.due_date)#</cfif>"onChange="change_paper_duedate('deliverdate');" onKeyUp="isNumber(this);" >
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='38681.Vade Tarihi İçin Geçerli Bir Format Giriniz'>!</cfsavecontent>
                </cfif>
                </div>
                <div class="col col-5 col-xs-12"> 
                    <div class="input-group">
                        <cfif xml_delivery_date_calculated neq 1>
                            <cfinput type="text" name="basket_due_value_date_" value="#dateformat(get_order_detail.order_date,dateformat_style)#" onChange="change_paper_duedate('order_date',1);" validate="#validate_style#" message="#message#" maxlength="10"  readonly>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
                        <cfelse>
                            <cfinput type="text" name="basket_due_value_date_" value="#dateformat(get_order_detail.deliverdate,dateformat_style)#" onChange="change_paper_duedate('deliverdate',1);" validate="#validate_style#" message="#message#" maxlength="10"  readonly>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
                        </cfif>                
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-publishdate">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38530.PartnerPortal'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <span class="input-group-addon"><input type="checkbox" name="invisible" id="invisible" <cfif get_order_detail.invisible is 1>checked</cfif> value="checkbox"></span>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='38596.yayın tarihi girmelisiniz'></cfsavecontent>
                        <cfinput type="Text" style="width:68px;" size="12" maxlength="10" name="publishdate" value="#dateformat(get_order_detail.publishdate,dateformat_style)#" validate="#validate_style#" message="#message#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="publishdate"></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="3" sort="true">
            <div class="form-group" id="item-process">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                <div class="col col-8 col-xs-12"> 
                    <cf_workcube_process is_upd='0' select_value='#get_order_detail.order_stage#' process_cat_width='140' is_detail='1'>
                </div>
            </div>
            <cfif xml_show_process_stage eq 1>
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process_cat process_cat='#get_order_detail.PROCESS_CAT#'>
                    </div>
                </div>
            </cfif>
            <div class="form-group" id="item-priority_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                <div class="col col-8 col-xs-12"> 
                    <select name="priority_id" id="priority_id">
                        <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfloop query="get_setup_priority">
                            <option <cfif get_order_detail.priority_id is priority_id>selected </cfif>value="#priority_id#">#priority#</option>
                        </cfloop>
                    </select>
                </div>
            </div>
            <div class="form-group" id="item-ship_method_name">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <input type="hidden" name="ship_method_id" id="ship_method_id" value="#get_order_detail.ship_method#">
                        <cfif len(get_order_detail.ship_method)>
                            <cfset attributes.ship_method=get_order_detail.ship_method>
                            <cfinclude template="../query/get_ship_method.cfm">
                            <cfset ship_method = get_ship_method.ship_method>
                        <cfelse>
                            <cfset ship_method = "">
                        </cfif>
                        <input type="text" name="ship_method_name" id="ship_method_name" value="#ship_method#" onFocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','140');" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id','','ui-draggable-box-small');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-deliver_loc_id">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57646.Teslim Depo'></label>
                <div class="col col-8 col-xs-12"> 
                    <cfset location_info_ = get_location_info(get_order_detail.deliver_dept_id,get_order_detail.location_id,1,1)>
                        <cf_wrkdepartmentlocation 
                            returnInputValue="deliver_loc_id,deliver_dept_name,deliver_dept_id,branch_id"
                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                            fieldName="deliver_dept_name"
                            fieldid="deliver_loc_id"
                            department_fldId="deliver_dept_id"
                            branch_fldId="branch_id"
                            branch_id="#listlast(location_info_,',')#"
                            department_id="#get_order_detail.deliver_dept_id#"
                            location_id="#get_order_detail.location_id#"
                            location_name="#listfirst(location_info_,',')#"
                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                            width="140"
                            is_branch="1">
                        </div>
            </div>
            <div class="form-group" id="item-contract">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29522.Sözleşme'></label>
                <div class="col col-8 col-xs-12">
                    <div class="input-group">
                        <cfif len(get_order_detail.contract_id)>
                            <cfquery name="getContract" datasource="#dsn3#">
                                SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #get_order_detail.contract_id#
                            </cfquery>
                        </cfif>
                        <input type="hidden" name="contract_id" id="contract_id" value="<cfif len(get_order_detail.contract_id)><cfoutput>#get_order_detail.contract_id#</cfoutput></cfif>"> 
                        <input type="text" name="contract_no" id="contract_no" value="<cfif len(get_order_detail.contract_id)><cfoutput>#getContract.contract_head#</cfoutput></cfif>">
                        <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_basket.contract_id&field_name=form_basket.contract_no'</cfoutput>);"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-order_status">
                <div>
                    <label><cf_get_lang dictionary_id='57493.Aktif'>&nbsp;&nbsp;<input type="checkbox" name="order_status" id="order_status" value="1" <cfif get_order_detail.order_status is 1>checked</cfif>></label>&nbsp;&nbsp;&nbsp;
                    <label><cf_get_lang dictionary_id='57452.Stok'><cf_get_lang dictionary_id='38586.Rezerve Et'><input type="checkbox" name="reserved" id="reserved" value="1" <cfif get_order_detail.reserved is 1>checked</cfif> onClick="check_reserved_rows();"></label>
                    <label><cf_get_lang dictionary_id='29692.Yurtdışı'><input type="checkbox" id="is_foreign" name="is_foreign" value="1" <cfif get_order_detail.is_foreign eq 1>checked="checked"</cfif>/></label>
                </div>
            </div>
        </div>
        <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="4" sort="true">
            <div class="form-group" id="item-project_head">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <input type="hidden" name="project_id" id="project_id" value="#get_order_detail.PROJECT_ID#" >
                        <input type="text" name="project_head" id="project_head"  value="<cfif LEN(get_order_detail.PROJECT_ID)>#GET_PROJECT_NAME(get_order_detail.PROJECT_ID)#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','130')" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=ORDERS&id='+document.getElementById('project_id').value+'','horizantal');else alert('<cf_get_lang dictionary_id="58797.Proje Seçiniz">');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-order_detail">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                <div class="col col-8 col-xs-12"> 
                    <textarea name="order_detail" id="order_detail" >#get_order_detail.order_detail#</textarea>
                </div>
            </div>
            <div class="form-group" id="item-catalog_name">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38626.Aksiyon'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <cfset attributes.catalog_id = get_order_detail.catalog_id>
                        <cfinclude template="../query/get_catalog_promotion.cfm">
                        <input type="Hidden" name="catalog_id" id="catalog_id" value="#get_order_detail.catalog_id#">	
                        <input type="text" name="catalog_name" id="catalog_name"  value="#get_cat_prom_name.catalog_head#">
                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_catalog_promotion&field_id=form_basket.catalog_id&field_name=form_basket.catalog_name','list');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-ship_address">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29462.Yükleme Yeri'></label>
                <div class="col col-8 col-xs-12"> 
                    <div class="input-group">
                        <input type="hidden" name="ship_address_city_id" id="ship_address_city_id" value="#get_order_detail.city_id#">
                        <input type="hidden" name="ship_address_county_id" id="ship_address_county_id" value="#get_order_detail.county_id#">
                        <input type="hidden" name="deliver_comp_id" id="deliver_comp_id" value="#get_order_detail.deliver_comp_id#">
                        <input type="hidden" name="deliver_cons_id" id="deliver_cons_id" value="#get_order_detail.deliver_cons_id#">
                        <input type="hidden" name="ship_address_id" id="ship_address_id" value="#get_order_detail.ship_address_id#">
                        <input type="text" name="ship_address" id="ship_address" value="#get_order_detail.ship_address#">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="add_adress();"></span>
                    </div>
                </div>
            </div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <div class="col col-6 text-right"> 
            <cfif len(get_order_detail.frm_branch_id)>
                <cfquery name="get_branch" datasource="#dsn#">
                    SELECT BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #get_order_detail.frm_branch_id#<!--- FBS 20120906 bunu boyle yazan arkadas nedenini aciklayabilir mi? listede baska burda baska? IN (SELECT BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_order_detail.deliver_dept_id#) --->
                </cfquery>
            </cfif>
            <cfif x_branch_info eq 1><cfif len(get_order_detail.frm_branch_id)>Şube : #get_branch.branch_name#&nbsp;</cfif></cfif>
            <cf_record_info query_name='get_order_detail'>
            <cfif get_order_detail.IS_PROCESSED eq 1> 
                <cfquery name="get_our_comp_inf" datasource="#dsn#">
                    SELECT * FROM OUR_COMPANY_INFO WHERE COMP_ID = #session.ep.company_id#
                </cfquery>
                <!--- aktif donemde siparisle ilgili irsaliye kaydı olup olmadığı kontrol edilir --->
                <cfquery name="control_order_ship" datasource="#dsn3#"> 
                    SELECT SHIP_ID,PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID=#url.ORDER_ID#
                </cfquery>
                <cfif control_order_ship.recordcount><!--- bu irsaliyelerle ilgili sevkiyat ve fatura bilgileri kontrol ediliyor --->
                    <font color="FF0000"><cf_get_lang dictionary_id='57893.İrsaliye Kesildi'>!</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfset ship_period_list=listdeleteduplicates(valuelist(control_order_ship.PERIOD_ID))>
                    <cfif listlen(ship_period_list) eq 1 and ship_period_list eq session.ep.period_id>
                        <cfset control_ship_list=valuelist(control_order_ship.SHIP_ID)>
                        <!--- bu kontrolle direk siparişten olusturulmus (irsaliyeli) fatura kayıtlarına da ulaşılabiliyor. --->
                        <cfquery name="control_invoice_ships" datasource="#dsn2#">
                            SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_ID IN (#control_ship_list#) AND SHIP_PERIOD_ID=#session.ep.period_id#
                        </cfquery>
                        <cfif not(isdefined('control_invoice_ships.SHIP_ID') and len(control_invoice_ships.SHIP_ID))>
                            <cfquery name="control_order_invoice_ships" datasource="#dsn3#">
                                SELECT ORDER_ID FROM ORDERS_INVOICE WHERE ORDER_ID=#url.ORDER_ID# and PERIOD_ID=#session.ep.period_id#
                            </cfquery>	
                        </cfif>
                        <cfif control_invoice_ships.recordcount>
                            <font color="FF0000"><cf_get_lang dictionary_id='38693.Fatura Kesildi'>!</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </cfif>
                        <cfif isdefined('control_order_invoice_ships.ORDER_ID') and len(control_order_invoice_ships.ORDER_ID)>
                            <font color="FF0000"><cf_get_lang dictionary_id='38693.Fatura Kesildi'>!</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </cfif>
                        <cfquery name="control_ship_result" datasource="#dsn2#"><!--- siparisin baglı oldugu irsaliyelerin sevkiyatları kontrol ediliyor --->
                            SELECT 
                                SR.SHIP_FIS_NO,SR.SHIP_RESULT_ID
                            FROM
                                SHIP_RESULT SR,
                                SHIP_RESULT_ROW SR_ROW 
                            WHERE 
                                SR.SHIP_RESULT_ID = SR_ROW.SHIP_RESULT_ID
                                AND SR.IS_TYPE IS NULL
                                AND SR_ROW.SHIP_ID IN (#control_ship_list#)
                        </cfquery>
                        <cfif control_ship_result.recordcount>
                            <font color="FF0000"><cf_get_lang dictionary_id='38694.Sevkiyat Yapıldı'>!</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        </cfif>
                    <cfelse>
                        <cfquery name="get_ship_periods_" datasource="#dsn#">
                            SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID IN (#ship_period_list#)
                        </cfquery>
                        <CFLOOP query="control_order_ship">
                            <cfif isdefined('control_ship_list_#period_id#')>
                                <cfset 'control_ship_list_#period_id#'=listappend(evaluate('control_ship_list_#period_id#'),control_order_ship.SHIP_ID)>
                            <cfelse>
                                <cfset 'control_ship_list_#period_id#'=control_order_ship.SHIP_ID>
                            </cfif>
                        </CFLOOP>
                        <cfloop query="get_ship_periods_">
                            <cfset new_dsn2 = '#dsn#_#get_ship_periods_.PERIOD_YEAR#_#get_ship_periods_.OUR_COMPANY_ID#'>
                            <cfset control_ship_list=valuelist(control_order_ship.SHIP_ID)>
                            <cfquery name="control_invoice_ships" datasource="#new_dsn2#">
                                SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_ID IN (#evaluate('control_ship_list_#get_ship_periods_.period_id#')#) AND SHIP_PERIOD_ID=#get_ship_periods_.period_id#
                            </cfquery>
                            <cfif control_invoice_ships.recordcount>
                                <font color="FF0000"><cf_get_lang dictionary_id='38693.Fatura Kesildi'>!</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <cfset is_inv=1>
                            </cfif>
                            <cfquery name="control_ship_result" datasource="#new_dsn2#"><!--- siparisin baglı oldugu irsaliyelerin sevkiyatları kontrol ediliyor --->
                                SELECT 
                                    SR.SHIP_FIS_NO,
                                    SR.SHIP_RESULT_ID
                                FROM
                                    SHIP_RESULT SR,
                                    SHIP_RESULT_ROW SR_ROW 
                                WHERE 
                                    SR.SHIP_RESULT_ID = SR_ROW.SHIP_RESULT_ID AND
                                    SR.IS_TYPE IS NULL AND
                                    SR_ROW.SHIP_ID IN (#evaluate('control_ship_list_#get_ship_periods_.period_id#')#)
                            </cfquery>
                            <cfif control_ship_result.recordcount>
                                <font color="FF0000"><cf_get_lang dictionary_id='38694.Sevkiyat Yapıldı'>!</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </cfif>
                            <cfif isdefined('is_inv') and is_inv eq 1>
                                <cfbreak>
                            </cfif>
                        </cfloop>
                    </cfif>
                <cfelse>
                    <cfquery name="control_order_invoice" datasource="#dsn3#">  <!--- direk faturaya cekilmiş ve fatura irsaliye olusturmuyorsa --->
                        SELECT INVOICE_ID FROM ORDERS_INVOICE WHERE ORDER_ID=#url.ORDER_ID#
                    </cfquery>
                    <cfif control_order_invoice.recordcount>
                        <font color="FF0000"><cf_get_lang dictionary_id='38693.Fatura Kesildi'>!</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </cfif>
                </cfif>
                <!--- kapatılmıs ve fazla teslimat asamasındaki satırlar display geldigi ve guncellenemedigi icin butonlar acıldı. --->
            </cfif>
        </div>
        <div class="col col-6 text-right">   
            <cf_basket_form_button>
                
                <cfif get_order_detail.IS_PROCESSED eq 1>
                    <cfif get_our_comp_inf.IS_PURCHASE_ORDER_UPDATE eq 1><!---İşlenmiş satınalma siparişleri Guncellenebilsin--->
                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                    </cfif>
                <cfelse>
                    <cf_workcube_buttons 
                        is_upd='1'
                        del_action= '/V16/purchase/cfc/OrderPurchaseAction:del_order:order_id=#url.order_id#'
                        del_next_page = '#request.self#?fuseaction=#attributes.fuseaction#'
                        add_function = 'kontrol()'
                        data_action = '/V16/purchase/cfc/OrderPurchaseAction:upd_order'
                    >
                </cfif>
            </cf_basket_form_button>
        </div>
    </cf_box_footer>
</cfoutput>
