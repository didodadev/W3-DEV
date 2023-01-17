<cfoutput>
        <cf_box_elements>
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="1" sort="true"><!---/// Kolon  type column verilecek sort duruma göre true false--->
                <div class="form-group" id="item-order_head"><!---/// uniq id verilecek tr de tanmılı id yi alabilirsiniz.--->
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'></label><!---/// label --->
                    <div class="col col-8 col-xs-12"> <!---/// input content --->
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" required="Yes" message="#message#" value="#attributes.subject#" name="order_head" maxlength="200">
                    </div>
                </div>
                <div class="form-group" id="item-company">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.cari hesap'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
                            <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#</cfif>">
                            <input type="text" name="company" id="company"  value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#get_par_info(attributes.partner_id,0,1,0)#</cfif>" readonly>
                            <cfset str_linkeait="&field_consumer=form_basket.consumer_id&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.pay_method&field_basket_due_value=form_basket.basket_due_value&ship_method_id=form_basket.ship_method_id&ship_method_name=form_basket.ship_method_name&field_card_payment_id=form_basket.card_paymethod_id&field_long_address=form_basket.ship_address&field_city_id=form_basket.ship_address_city_id&field_county_id=form_basket.ship_address_county_id&field_adress_id=form_basket.ship_address_id">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&field_comp_id=form_basket.company_id&field_comp_name=form_basket.company&field_partner=form_basket.partner_id&field_name=form_basket.partner_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8&call_function=check_member_price_cat()-change_paper_duedate()#str_linkeait#')"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-partner">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'>*</label>
                    <div class="col col-8 col-xs-12"> 
                        <input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#</cfif>">
                        <input type="text" name="partner_name" id="partner_name" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#get_par_info(attributes.partner_id,0,-1,0)#<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>#get_cons_info(attributes.consumer_id,0,0)#</cfif>" readonly>
                    </div>
                </div>
                <div class="form-group" id="item-order_employee">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58796.Sipariş Veren'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <input type="hidden" name="order_employee_id" id="order_employee_id" value="#session.ep.userid#">
                            <input type="text" name="order_employee" id="order_employee" value="#get_emp_info(session.ep.userid,0,0)#"  onfocus="AutoComplete_Create('order_employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','150');" autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.order_employee&field_emp_id2=form_basket.order_employee_id')"></span>
                        </div>    
                    </div>
                </div>
                <div class="form-group" id="item-ref_no">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'></label>
                    <div class="col col-8 col-xs-12"> 
                        <!--- related_order_id, siparisin ilgili oldugu satıs siparisinin id sini tutar --->
                        <cfif isdefined('attributes.related_order_id') and len(attributes.related_order_id)>
                            <cfset attributes.ref_paper_id = attributes.related_order_id>
                        </cfif>
                        <cfif isdefined('attributes.related_order_no') and len(attributes.related_order_no)>
                            <cfset attributes.ref_no = attributes.related_order_no>
                        </cfif>
                        <input type="hidden" name="ref_paper_id" id="ref_paper_id" value="<cfif isdefined('attributes.ref_paper_id') and len(attributes.ref_paper_id)>#attributes.ref_paper_id#</cfif>">
                        <input type="text" name="ref_no" id="ref_no" value="<cfif isdefined('attributes.ref_no') and len(attributes.ref_no)>#attributes.ref_no#</cfif>" maxlength="50" >    
                    </div>
                </div>
                <div class="form-group" id="item-work_head">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38513.İş Görev'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <input type="hidden" name="work_id" id="work_id" value="<cfif isdefined("attributes.work_id") and len(attributes.work_id)><cfoutput>#attributes.work_id#</cfoutput></cfif>">
                            <input type="text" name="work_head" id="work_head"  value="<cfif isdefined("attributes.work_id") and len(attributes.work_id)><cfoutput>#get_work_name(attributes.work_id)#</cfoutput></cfif>">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction</cfoutput>=objects.popup_add_work&field_id=form_basket.work_id&field_name=form_basket.work_head');"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="2" sort="true"><!---/// Kolon  type column verilecek sort duruma göre true false--->
                <div class="form-group" id="item-order_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='38654.Sipariş Tarihi Girmelisiniz'>!</cfsavecontent>
                            <cfif isdefined("attributes.order_date") and isdate(attributes.order_date)>
                                <cfset order_date_ = attributes.order_date>
                            <cfelse>
                                <cfset order_date_ = dateformat(now(),dateformat_style)>
                            </cfif>
                            <cfinput type="text" name="order_date"  value="#order_date_#" validate="#validate_style#" maxlength="10" required="yes" message="#message#" passthrough="onblur=""change_money_info('form_basket','order_date');""">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="order_date" call_function="change_money_info"></span>   
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-deliverdate">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'>*</label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='38627.Teslim Tarihi Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="deliverdate"  value="#attributes.deliverdate#" validate="#validate_style#" maxlength="10" required="yes" message="#message#">		  
                            <span class="input-group-addon"><cf_wrk_date_image date_field="deliverdate"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-pay_method">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>
                                <cfset pay_id = attributes.paymethod_id>
                                <cfinclude template="../query/get_payment_method.cfm">
                                <cfset attributes.pay_method = get_payment_method.paymethod>
                                <cfset attributes.due_date_value = get_payment_method.due_day>
                                <cfif Len(get_payment_method.due_day)>
                                    <cfif get_payment_method.is_due_endofmonth eq 1><!--- Vade Aysonundan Baslasin Icin Ayin Son Gunu Atanir --->
                                        <cfif xml_delivery_date_calculated eq 0>
                                            <cfset attributes.due_date = CreateDate(Year(order_date_),Month(order_date_),DaysInMonth(order_date_))>
                                            <cfset attributes.due_date_value = attributes.due_date_value + DateDiff('d',order_date_,attributes.due_date)>
                                        <cfelse>
											<cfif not (isDefined("attributes.deliverdate") and Len(attributes.deliverdate))><cfset attributes.deliverdate = now()></cfif>
                                            <cfset attributes.due_date = CreateDate(Year(attributes.deliverdate),Month(attributes.deliverdate),DaysInMonth(attributes.deliverdate))>
                                            <cfset attributes.due_date_value = attributes.due_date_value + DateDiff('d',attributes.deliverdate,attributes.due_date)>
                                        </cfif>
                                    </cfif>
                                    <cfset attributes.due_date = DateFormat(date_add('d',get_payment_method.due_day,attributes.due_date),dateformat_style)>
                                </cfif>
                            <cfelseif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
                                <cfquery name="get_card_paymethod" datasource="#dsn3#">
                                    SELECT CARD_NO,COMMISSION_MULTIPLIER FROM CREDITCARD_PAYMENT_TYPE WHERE PAYMENT_TYPE_ID = #attributes.card_paymethod_id#
                                </cfquery>
                                <cfset attributes.commission_rate = get_card_paymethod.commission_multiplier>
                                <cfset attributes.pay_method = get_card_paymethod.card_no>
                            <cfelse>
                                <!--- Odeme Yontemi Yoksa Kurumsal veya Bireysel Oyelerdeki Yontemleri Kontrol Edilir --->
                                <cfif (isDefined("attributes.company_id") and Len(attributes.company_id)) or (isDefined("attributes.consumer_id") and Len(attributes.consumer_id))>
                                    <cfset get_member_payment_method = createObject("component","V16.objects.cfc.getMemberPaymentMethod").getMemberPaymentMethod(dsn:dsn,is_sales_type:0,our_company_id:session.ep.company_id,company_id:iif(isDefined("attributes.company_id"),"attributes.company_id",""),consumer_id:iif(isDefined("attributes.consumer_id"),"attributes.consumer_id",""))>
                                    <cfif get_member_payment_method.recordcount>
                                        <cfset attributes.paymethod_id = get_member_payment_method.payment_method_id>
                                        <cfset attributes.card_paymethod_id = get_member_payment_method.card_payment_method_id>
                                        <cfset attributes.commission_rate = get_member_payment_method.commission_multiplier>
                                        <cfset attributes.paymethod_vehicle = get_member_payment_method.payment_vehicle>
                                        <cfset attributes.pay_method = get_member_payment_method.payment_method_name>
                                        <cfset attributes.due_date_value = get_member_payment_method.due_day>
                                        <cfif Len(get_member_payment_method.due_day)>
                                            <cfset attributes.due_date = DateFormat(DateAdd('d',get_member_payment_method.due_day,order_date_),dateformat_style)>
                                        </cfif>
                                    </cfif>
                                </cfif>
                            </cfif>
                            <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfif isdefined('attributes.card_paymethod_id') and len(attributes.card_paymethod_id)>#attributes.card_paymethod_id#</cfif>">
                            <input type="hidden" name="commission_rate" id="commission_rate" value="<cfif isdefined('attributes.commission_rate') and len(attributes.commission_rate)>#attributes.commission_rate#</cfif>">
                            <input type="hidden" name="paymethod_vehicle" id="paymethod_vehicle" value="<cfif isDefined('attributes.paymethod_vehicle') and Len(attributes.paymethod_vehicle)>#attributes.paymethod_vehicle#</cfif>"><!--- Ödeme aracını tutuyor ve basket hesaplamalarında kullanılıyor lütfen silmeyiniz --->
                            <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)>#attributes.paymethod_id#</cfif>">
                            <input type="text" name="pay_method" id="pay_method" value="<cfif isdefined('attributes.pay_method') and len(attributes.pay_method)>#attributes.pay_method#</cfif>"  onfocus="AutoComplete_Create('pay_method','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMENT_TYPE_ID,COMMISSION_MULTIPLIER,PAYMETHOD_ID,PAYMENT_VEHICLE','card_paymethod_id,commission_rate,paymethod_id,paymethod_vehicle','','3','200');" autocomplete="off">
                            <cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.pay_method&field_commission_rate=form_basket.commission_rate&field_paymethod_vehicle=form_basket.paymethod_vehicle">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_paymethods&function_name=change_paper_duedate&function_parameter=<cfif xml_delivery_date_calculated>deliverdate<cfelse>order_date</cfif>&field_id=form_basket.paymethod_id&field_name=form_basket.pay_method&field_dueday=form_basket.basket_due_value#card_link#');return false;"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-basket_due_value">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57881.Vade/Tarih'></label>
                    <div class="col col-3 col-xs-12"> 
                    <cfif xml_delivery_date_calculated neq 1>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='38681.Vade Tarihi İçin Geçerli Bir Format Giriniz'>!</cfsavecontent>
                        <input name="basket_due_value" id="basket_due_value" type="text" value="<cfif isdefined("attributes.due_date_value") and len(attributes.due_date_value)>#attributes.due_date_value#</cfif>" onchange="change_paper_duedate('order_date');" onkeyup="isNumber(this);">
                    <cfelse>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='38681.Vade Tarihi İçin Geçerli Bir Format Giriniz'>!</cfsavecontent>
                        <input name="basket_due_value" id="basket_due_value" type="text" value="<cfif isdefined("attributes.due_date_value") and len(attributes.due_date_value)>#attributes.due_date_value#</cfif>" onchange="change_paper_duedate('deliverdate');" onkeyup="isNumber(this);" >
                    </cfif>
                    </div>
                    <div class="col col-5 col-xs-12"> 
                        <div class="input-group">
                            <cfif xml_delivery_date_calculated neq 1>
                                <cfinput type="text" name="basket_due_value_date_" value="#attributes.due_date#" onChange="change_paper_duedate('order_date',1);" validate="#validate_style#" message="#message#" maxlength="10"  readonly>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
                            <cfelse>
                                <cfinput type="text" name="basket_due_value_date_" value="#attributes.due_date#" onChange="change_paper_duedate('deliverdate',1);" validate="#validate_style#" message="#message#" maxlength="10"  readonly>
                                <span class="input-group-addon"><cf_wrk_date_image date_field="basket_due_value_date_"></span>
                            </cfif>                
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-publishdate">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38530.PartnerPortal'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='38596.yayın tarihi girmelisiniz'></cfsavecontent>
                            <span class="input-group-addon"><input type="checkbox" name="invisible" id="invisible" <cfif isdefined("attributes.invisible") and attributes.invisible eq 1>checked</cfif>></span>
                            <cfinput type="text" name="publishdate" id="publishdate"  value="#attributes.publishdate#" validate="#validate_style#" maxlength="10" message="#message#">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="publishdate"></span>
                        </div>
                    </div>
                </div>
				<div class="form-group" id="item-cf_wrk_add_info">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57810.Ek Bilgi'></label>
                    <div class="col col-8 col-xs-12"> 
                        <cf_wrk_add_info info_type_id="-12" upd_page = "0"> 
                    </div>
				</div>
            </div>
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-process">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                    <div class="col col-8 col-xs-12"> 
                        <cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'>    
                    </div>
                </div>
                <cfif xml_show_process_stage eq 1>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.işlem tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process_cat>
                        </div>
                    </div>
                </cfif>
                <div class="form-group" id="item-priority_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57485.Öncelik'></label>
                    <div class="col col-8 col-xs-12"> 
                        <select name="priority_id" id="priority_id">
                            <option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_setup_priority">
                                <option value="#priority_id#" <cfif isdefined("attributes.priority_id") and attributes.priority_id eq priority_id>selected</cfif>>#priority#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-ship_method_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>
                                <cfinclude template="../query/get_ship_method.cfm">
                                <cfset attributes.ship_method_name = get_ship_method.ship_method>
                            </cfif>
                            <input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined('attributes.ship_method') and len(attributes.ship_method)>#attributes.ship_method#</cfif>">
                            <input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined('attributes.ship_method_name') and len(attributes.ship_method_name)>#attributes.ship_method_name#</cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','140');" autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id','','ui-draggable-box-small');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-deliver_loc_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57646.Teslim Depo'></label>
                    <div class="col col-8 col-xs-12"> 
                        <cf_wrkdepartmentlocation 
                            returninputvalue="deliver_loc_id,deliver_dept_name,deliver_dept_id,branch_id"
                            returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                            fieldname="deliver_dept_name"
                            fieldid="deliver_loc_id"
                            department_fldid="deliver_dept_id"
                            branch_fldid="branch_id"
                            branch_id="#attributes.branch_id#"
                            department_id="#attributes.deliver_dept_id#"
                            location_id="#attributes.deliver_loc_id#"
                            location_name="#attributes.deliver_dept_name#"
                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"                
                            width="140">      
                    </div>
                </div>
                <div class="form-group" id="item-contract">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29522.Sözleşme'></label> 
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfif isdefined('attributes.contract_id') and len(attributes.contract_id)>
                                <cfquery name="getContract" datasource="#dsn3#">
                                    SELECT CONTRACT_HEAD FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
                                </cfquery>
                                <input type="hidden" name="contract_id" id="contract_id" value="<cfif len(attributes.contract_id)><cfoutput>#attributes.contract_id#</cfoutput></cfif>" />
                                <input type="text" name="contract_no" id="contract_no" value="<cfif len(attributes.contract_id)><cfoutput>#getContract.contract_head#</cfoutput></cfif>"/>
                            <cfelse>
                                <input type="hidden" name="contract_id" id="contract_id" value="" />
                                <input type="text" name="contract_no" id="contract_no" value=""/>
                            </cfif>
                            <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&field_id=form_basket.contract_id&field_name=form_basket.contract_no'</cfoutput>);"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-order_status">
                    <div>
                        <label><cf_get_lang dictionary_id='57493.Aktif'><input type="checkbox" name="order_status" id="order_status" value="1" <cfif (isdefined("get_order_detail.order_status") and get_order_detail.order_status eq 1) or not isdefined("get_order_detail.order_status")>checked</cfif>></label>&nbsp;&nbsp;&nbsp;
                        <label><cf_get_lang dictionary_id='41185.Stok Rezerve Et'> <input type="checkbox" name="reserved" id="reserved" value="1" <cfif not isdefined("attributes.reserved") or (isdefined("attributes.reserved") and attributes.reserved eq 1)>checked</cfif> onclick="check_reserved_rows();"></label>&nbsp;&nbsp;&nbsp;
                        <label><cf_get_lang dictionary_id='29692.Yurtdışı'><input type="checkbox" id="is_foreign" name="is_foreign" value="1"/></label>
                    </div>
                </div>
            </div>
            <div class="col col-3 col-md-3 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                <div class="form-group" id="item-project_head">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#attributes.project_id#<cfelseif isdefined("attributes.convert_project_id") and len(attributes.convert_project_id)>#attributes.convert_project_id#</cfif>">
                            <input type="text" name="project_head" id="project_head" value="<cfif isdefined('attributes.project_id') and len(attributes.project_id)>#get_project_name(attributes.project_id)#<cfelseif isdefined("attributes.convert_project_id") and len(attributes.convert_project_id)>#get_project_name(attributes.convert_project_id)#</cfif>"  onfocus="AutoComplete_Create('project_head','PROJECT_ID,PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','form_basket','3','135')"autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"></span>
                            <span class="input-group-addon btnPointer bold" onclick="if(document.getElementById('project_id').value!='')windowopen('#request.self#?fuseaction=project.popup_list_project_actions&from_paper=ORDERS&id='+document.getElementById('project_id').value+'','horizantal');else alert('<cf_get_lang dictionary_id='58797.Proje Seçiniz'>');">?</span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-order_detail">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12"> 
                        <textarea name="order_detail" id="order_detail"><cfif isdefined('attributes.order_detail') and len(attributes.order_detail)>#attributes.order_detail#</cfif></textarea>
                    </div>
                </div>
                <div class="form-group" id="item-catalog_name">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38626.Aksiyon'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id)>
                                <cfinclude template="../query/get_catalog_promotion.cfm">
                                <cfset attributes.catalog_name = get_cat_prom_name.catalog_head>
                            </cfif>
                            <input type="hidden" name="catalog_id" id="catalog_id" value="">
                            <input type="text" name="catalog_name" id="catalog_name" value="<cfif isdefined('attributes.catalog_name') and len(attributes.catalog_name)>#attributes.catalog_name#</cfif>">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_catalog_promotion&field_id=form_basket.catalog_id&field_name=form_basket.catalog_name','list');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-ship_address">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29462.Yükleme Yeri'></label>
                    <div class="col col-8 col-xs-12"> 
                        <div class="input-group">
                            <!--- Uye Bilgilerinden gelindiginde teslim yeri alaninin dolu gelmesi icin eklendi --->
                            <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                                <cfquery name="get_ship_address" datasource="#dsn#">
                                    SELECT
                                        TOP 1 *
                                    FROM
                                        (	SELECT 0 AS TYPE,COMPBRANCH_ID,COMPBRANCH_ADDRESS AS ADDRESS,POS_CODE,SEMT,COUNTY_ID AS COUNTY,CITY_ID AS CITY,COUNTRY_ID AS COUNTRY FROM COMPANY_BRANCH WHERE IS_SHIP_ADDRESS = 1 AND COMPANY_ID = #attributes.company_id# 
                                            UNION
                                            SELECT 1 AS TYPE,-1 COMPBRANCH_ID,COMPANY_ADDRESS AS ADDRESS,POS_CODE,SEMT,COUNTY,CITY,COUNTRY FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
                                        ) AS TYPE
                                    ORDER BY
                                        TYPE 
                                </cfquery>
                                <cfset address_ = get_ship_address.address>
                                <cfset attributes.ship_address_id_ = get_ship_address.COMPBRANCH_ID>
                                <cfif len(get_ship_address.pos_code) and len(get_ship_address.semt)>
                                    <cfset address_ = "#address_# #get_ship_address.pos_code# #get_ship_address.semt#">
                                </cfif>
                                <cfif len(get_ship_address.county)>
                                    <cfquery name="get_county_name" datasource="#dsn#">
                                        SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_ship_address.county#
                                    </cfquery>
                                    <cfset attributes.ship_address_county_id = get_county_name.county_id>
                                    <cfset address_ = "#address_# #get_county_name.county_name#">
                                </cfif>
                                <cfif len(get_ship_address.city)>
                                    <cfquery name="get_city_name" datasource="#dsn#">
                                        SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_ship_address.city#
                                    </cfquery>
                                    <cfset attributes.ship_city_id = get_city_name.city_id>
                                    <cfset address_ = "#address_# #get_city_name.city_name#">
                                </cfif>
                                <cfif len(get_ship_address.country)>
                                    <cfquery name="get_country_name" datasource="#dsn#">
                                        SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_ship_address.country#
                                    </cfquery>
                                    <cfset address_ = "#address_# #get_country_name.country_name#">
                                </cfif>
                            </cfif>
                            <!--- //Uye Bilgilerinden gelindiginde teslim yeri alaninin dolu gelmesi icin eklendi --->
                            <input type="hidden" name="ship_address_city_id" id="ship_address_city_id" value="<cfif isdefined('attributes.ship_city_id') and len(attributes.ship_city_id)>#attributes.ship_city_id#</cfif>">
                            <input type="hidden" name="ship_address_county_id" id="ship_address_county_id" value="<cfif isDefined("attributes.ship_address_county_id") and len(attributes.ship_address_county_id)>#attributes.ship_address_county_id#</cfif>">
                            <input type="hidden" name="deliver_comp_id" id="deliver_comp_id" value="<cfif isdefined('attributes.deliver_comp_id') and len(attributes.deliver_comp_id)>#attributes.deliver_comp_id#</cfif>">
                            <input type="hidden" name="deliver_cons_id" id="deliver_cons_id" value="<cfif isDefined("attributes.deliver_cons_id") and len(attributes.deliver_cons_id)>#attributes.deliver_cons_id#</cfif>">
                            <input type="hidden" name="ship_address_id" id="ship_address_id" value="<cfif isdefined('attributes.ship_address_id_') and len(attributes.ship_address_id_)>#attributes.ship_address_id_#</cfif>">
                            <input type="text" name="ship_address" id="ship_address"  maxlength="200" value="<cfif isdefined('address_') and len(address_)>#address_#</cfif>">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="add_adress();"></span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_basket_form_button>
                <cf_workcube_buttons 
                                    is_upd='0' 
                                    add_function='kontrol()'
                                    data_action = '/V16/purchase/cfc/OrderPurchaseAction:add_order'
                                    next_page = '#request.self#?fuseaction=#attributes.fuseaction#&event=upd&order_id='> 
                </cf_basket_form_button>
        </cf_box_footer>
</cfoutput>

