<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="../query/get_purchase_det.cfm">
<cfif not get_sale_det.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfset attributes.basket_id = 42>
<cfinclude template="../query/get_session_cash_all.cfm">
<cfscript>session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);</cfscript>

<div id="basket_main_div">
    <cf_catalystHeader>
    <cf_box>
        <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_marketplace_bill">
            <cf_basket_form id="marketplace_bill">
                <cfoutput>
                    <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_marketplace_bill">
                    <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
                    <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
                    <input type="hidden" name="invoice_id" id="invoice_id" value="#attributes.iid#">
                    <input type="hidden" name="del_invoice_id" id="del_invoice_id" value="0">		
                    <cfif len(get_sale_det.company_id)>
                        <cfset member_account_code = get_company_period(get_sale_det.company_id)>
                    <cfelse>
                        <cfset member_account_code = get_consumer_period(get_sale_det.consumer_id)>
                    </cfif>
                    <input type="hidden" name="member_account_code" id="member_account_code" value="#member_account_code#">
                </cfoutput>
                <cf_box_elements>
                    <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="1">
                        <div class="form-group" id="item-process_cat">			
                            <label class="col col-4"><cf_get_lang dictionary_id='57800.Operasyon Tipi'></label>
                            <div class="col col-8">
                                <cf_workcube_process_cat process_cat="#get_sale_det.process_cat#">
                            </div>
                        </div> 
                        <div class="form-group" id="item-invoice_number">			
                            <label class="col col-4"><cf_get_lang dictionary_id='58133.Fatura No'>*</label>
                            <div class="col col-8">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57184.Fatura No Girmelisiniz !'></cfsavecontent>
                                <cfinput type="text" name="invoice_number" maxlength="50" style="width:150px;" value="#get_sale_det.invoice_number#" required="Yes" message="#message#">
                            </div>
                        </div> 
                        <div class="form-group" id="item-ship_method">			
                            <label class="col col-4"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <input type="hidden" name="ship_method" id="ship_method"  readonly value="<cfoutput>#get_sale_det.ship_method#</cfoutput>">
                                    <cfif len(get_sale_det.ship_method)>
                                        <cfset attributes.ship_method_id=get_sale_det.ship_method>
                                        <cfinclude template="../query/get_ship_methods.cfm">
                                    </cfif>
                                    <input type="text" name="ship_method_name" id="ship_method_name"  style="width:150px;"  value="<cfif len(get_sale_det.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>" >
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method');"></span>
                                </div>
                            </div>
                        </div> 
                        <div class="form-group" id="item-company_id">			
                            <label class="col col-4"><cf_get_lang dictionary_id='57519.cari Hesap'>*</label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <cfoutput>
                                        <input type="hidden" name="company_id" id="company_id" value="#get_sale_det.company_id#" >
                                        <cfif len(get_sale_det.company_id) and get_sale_det.company_id neq 0>
                                        <input type="text" name="comp_name" id="comp_name" value="#get_sale_det_comp.fullname#" readonly style="width:150px;">
                                        <cfelse>
                                        <input type="text" name="comp_name" id="comp_name" value="#get_cons_name.company#" readonly style="width:150px;">
                                        </cfif>
                                    </cfoutput>
                                    <cfset str_linkeait = "&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value">
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=invoice&field_member_account_code=form_basket.member_account_code#str_linkeait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>')"></span>
                                </div>
                            </div>
                        </div> 
                    </div>
                    <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="2">
                        <div class="form-group" id="item-invoice_date">			
                            <label class="col col-4"><cf_get_lang dictionary_id='58759.Fatura Tarihi'></label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz'> !</cfsavecontent>
                                    <cfinput type="text" name="invoice_date" style="width:150px;" required="Yes" message="#message#" readonly value="#dateformat(get_sale_det.invoice_date,dateformat_style)#" validate="#validate_style#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="invoice_date" control_date="#dateformat(get_sale_det.invoice_date,dateformat_style)#"></span>
                                </div>
                            </div>
                        </div> 
                        <div class="form-group" id="item-department_id">			
                            <label class="col col-4"><cf_get_lang dictionary_id='58763.Depo'></label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <cfset attributes.department_id = get_sale_det.DEPARTMENT_ID>
                                    <cfinclude template="../query/get_dept_name.cfm">
                                    <cfset txt_department_name = get_dept_name.DEPARTMENT_HEAD>
                                    <cfset branch_id=get_dept_name.BRANCH_ID>
                                    <cfif len(get_sale_det.DEPARTMENT_LOCATION)>
                                        <cfset attributes.location_id = get_sale_det.DEPARTMENT_LOCATION>
                                        <cfinclude template="../query/get_location_name.cfm">
                                        <cfset txt_department_name = txt_department_name & "-" & get_location_name.COMMENT>
                                    </cfif>
                                    <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#branch_id#</cfoutput>">
                                    <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_sale_det.department_ID#</cfoutput>" >
                                    <input type="hidden" name="location_id" id="location_id" value="<cfoutput>#get_sale_det.department_location#</cfoutput>" >
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57186.Depo Girmelisiniz !'></cfsavecontent>
                                    <cfinput type="Text"  style="width:150px;" name="department_name"  value="#txt_department_name#" >
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=department_name&field_id=department_id&field_location_id=location_id&branch_id=branch_id<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif>')" ></span>
                                </div>
                            </div>
                        </div> 
                        <div class="form-group" id="item-consumer_id">			
                            <label class="col col-4"><cf_get_lang dictionary_id='57578.Yetkili'>*</label>
                            <div class="col col-8">
                                <cfoutput>
                                    <input type="hidden" name="partner_id" id="partner_id" value="#get_sale_det.partner_id#">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="#get_sale_det.consumer_id#">
                                    <cfif len(GET_SALE_DET.PARTNER_ID) and isnumeric(GET_SALE_DET.PARTNER_ID)>
                                    <input type="text" name="partner_name" id="partner_name" value="#GET_SALE_DET_CONS.COMPANY_PARTNER_NAME# #GET_SALE_DET_CONS.COMPANY_PARTNER_SURNAME#" readonly style="width:150px;">
                                    <cfelseif len(GET_SALE_DET.consumer_id) and isnumeric(GET_SALE_DET.consumer_id) >
                                    <input type="text" name="partner_name" id="partner_name" value="#get_cons_name.consumer_name# #get_cons_name.consumer_surname#" readonly style="width:150px;">
                                    <cfelse>
                                    <input type="text" name="partner_name" id="partner_name" value="" readonly style="width:150px;">							
                                    </cfif>
                                </cfoutput>
                            </div>
                        </div> 
                        <div class="form-group" id="item-note">			
                            <label class="col col-4"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8">
                                <textarea style="width:150px;height:45px;" name="note" id="note"><cfoutput>#get_sale_det.note#</cfoutput></textarea>
                            </div>
                        </div> 
                    </div>
                    <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="3">
                        <div class="form-group" id="item-deliver_get">			
                            <label class="col col-4"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
                            <div class="col col-8">
                                <div class="input-group">
                                    <cfif len(get_sale_det.deliver_emp) and isnumeric(get_sale_det.deliver_emp)>
                                        <cfset str_del_name=get_emp_info(get_sale_det.deliver_emp,0,0)>
                                    <cfelse>
                                        <cfset str_del_name="">
                                    </cfif>	
                                    <cfoutput>
                                        <input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="#get_sale_det.deliver_emp#">
                                        <input type="text" name="deliver_get" id="deliver_get" value="<cfif len(get_sale_det.deliver_emp)>#str_del_name#</cfif>" readonly style="width:150px;">
                                    </cfoutput>
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>')"></span>
                                </div>
                            </div>
                        </div> 
                        <div class="form-group" id="item-irsaliye_id_listesi">			
                            <label class="col col-4"><cf_get_lang dictionary_id='57773.İrsaliye'></label>
                            <div class="col col-8">
                                <input type="hidden" name="irsaliye_id_listesi" id="irsaliye_id_listesi" value="<cfoutput>#ValueList(GET_WITH_SHIP_ALL.SHIP_ID)#</cfoutput>">
                                <input type="text" name="irsaliye" id="irsaliye" style="width:150px;" value="<cfoutput>#ValueList(GET_WITH_SHIP_ALL.SHIP_NUMBER)#</cfoutput>" readonly>
                            </div>
                        </div> 
                        <div class="form-group" id="item-PARTNER_NAMEO">			
                            <label class="col col-4"><cf_get_lang dictionary_id='30011.Satın alan'></label>
                            <div class="col col-8">
                               <div class="input-group">
                                <cfif get_sale_det.SALE_EMP eq "" and get_sale_det.SALE_PARTNER eq "">
                                    <input type="hidden" name="EMPO_ID" id="EMPO_ID">
                                    <input type="hidden" name="PARTO_ID" id="PARTO_ID">
                                    <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="" style="width:150px;">
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID</cfoutput>')"></span>
                                <cfelse>
                                    <cfoutput>
                                    <input type="hidden" name="EMPO_ID" id="EMPO_ID" value="#get_sale_det.SALE_EMP#">
                                    <input type="hidden" name="PARTO_ID" id="PARTO_ID" value="#get_sale_det.SALE_PARTNER#">
                                    </cfoutput>
                                    <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" <cfif len(get_sale_det.sale_partner)>value="<cfoutput>#get_par_info(get_sale_det.sale_partner,0,0,0)#</cfoutput>"<cfelse>value="<cfoutput>#get_emp_info(get_sale_det.sale_emp,0,0)#</cfoutput>"</cfif> style="width:150px;">
                                        <span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_name=form_basket.PARTNER_NAMEO&field_id=form_basket.PARTO_ID&field_EMP_id=form_basket.EMPO_ID&select_list=1,2</cfoutput>')"></span>
                                </cfif>
                               </div>
                            </div>
                        </div> 
                        <div class="form-group" id="item-paymethod">			
                            <label class="col col-4"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                            <div class="col col-8">
                               <div class="input-group">
                                <cfif len(get_sale_det.pay_method)>
                                    <cfset attributes.paymethod_id = get_sale_det.pay_method>
                                    <cfinclude template="../query/get_paymethod.cfm">
                                    <input name="basket_due_value" id="basket_due_value" type="hidden" value="<cfoutput>#get_paymethod.DUE_DAY#</cfoutput>">							
                                    <input type="hidden" name="paymethod_id" id="paymethod_id" value="<cfoutput>#get_sale_det.pay_method#</cfoutput>">
                                    <input type="text" name="paymethod" id="paymethod" style="width:150px;"  value="<cfoutput>#get_paymethod.paymethod#</cfoutput>" readonly>
                                <cfelse>
                                    <input name="basket_due_value" id="basket_due_value" type="hidden" value="">
                                    <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                                    <input type="text" name="paymethod" id="paymethod" style="width:150px;"  value="" readonly >
                                </cfif>
                                <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod</cfoutput>');"></span> 
                               </div>
                            </div>
                        </div> 
                    </div>
                    <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="4">
                        <div class="form-group" id="item-cash">			
                            <label class="col col-4"><cfif kasa.recordcount><cf_get_lang dictionary_id='57163.Nakit Alış'></cfif></label>
                            <div class="col col-8">
                                <cfif kasa.recordcount>
                                    <input type="checkbox" name="cash" id="cash" onClick="gizle_goster(not);gizle_goster(not1);"<cfif get_sale_det.is_cash eq 1> checked  </cfif>>
                                </cfif>
                            </div>
                        </div> 
                        <div class="form-group" id="item-kasa">			
                            <label class="col col-4"><cfif kasa.recordcount>
                                <div <cfif get_sale_det.is_cash neq 1> style="display:none;" </cfif> id="not"><cf_get_lang dictionary_id='57031.Kasa Seçimi'> </div>
                            </cfif></label>
                            <div class="col col-8">
                                <cfif kasa.recordcount>
                                    <div <cfif get_sale_det.is_cash neq 1> style="display:none;" </cfif> id="not1">
                                    <select name="kasa" id="kasa" style="width:150px;">
                                        <cfoutput query="kasa">
                                        <option value="#cash_id#"<cfif get_sale_det.kasa_id eq cash_id>selected</cfif>>#cash_name# 
                                        </cfoutput>
                                    </select>
                                    </div>
                                </cfif>
                                <cfoutput query="kasa">
                                    <input type="hidden" name="str_kasa_parasi#cash_id#" id="str_kasa_parasi#cash_id#" value="#CASH_CURRENCY_ID#">
                                </cfoutput>	
                            </div>
                        </div> 
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cfoutput>
                        <cfif len(get_sale_det.RECORD_EMP)><cf_get_lang dictionary_id='57483.Kayıt'>:
                        <cfif get_sale_det.RECORD_EMP eq 0><cf_get_lang dictionary_id='57702.Sistem Admin'><cfelse>#get_emp_info(get_sale_det.RECORD_EMP,0,0)# #dateformat(date_add('h',session.ep.time_zone,get_sale_det.RECORD_DATE),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,get_sale_det.RECORD_DATE),timeformat_style)#</cfif>
                        </cfif>
                        <br/>
                        <cfif len(get_sale_det.update_emp)><cf_get_lang dictionary_id='57703.Güncelleyen'>:
                            <cfif get_sale_det.update_emp eq 0><cf_get_lang dictionary_id='57702.Sistem Admin'>#dateformat(date_add('h',session.ep.time_zone,get_sale_det.update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,get_sale_det.update_date),timeformat_style)#)
                            <cfelseif len(get_sale_det.update_emp)>#get_emp_info(get_sale_det.update_emp,0,0)# #dateformat(date_add('h',session.ep.time_zone,get_sale_det.update_date),dateformat_style)#(#timeformat(date_add('h',session.ep.time_zone,get_sale_det.update_date),timeformat_style)#)
                            </cfif>
                        </cfif>
                    </cfoutput>
                    <cfif get_sale_det.upd_status neq 0>
                    <cf_workcube_buttons 
                            is_upd='1'
                            is_delete='1'
                            add_function='cagir_tarih()'
                            del_function='kontrol2()'
                            >
                    </cfif>
                </cf_box_footer>	
            </cf_basket_form>
            <cfinclude template="../../objects/display/basket.cfm">
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol_ithalat()
	{
	deger = form_basket.process_cat.options[form_basket.process_cat.selectedIndex].value;
	sistem_para_birimi = "<cfoutput>#SESSION.EP.MONEY#</cfoutput>";	
	if(deger != ""){
		var fis_no = eval("form_basket.ct_process_type_" + deger);
		if (fis_no.value == 591)
		{
			if(form_basket.cash.checked){
				kasa_para_birimi = eval("form_basket.str_kasa_parasi" + form_basket.kasa.options[form_basket.kasa.selectedIndex].value);
				if(document.all.basket_money.value != kasa_para_birimi.value){
					alert("<cf_get_lang dictionary_id='57034.Sistem Para Birimi ile Kasanizin Para Birimi Aynı Değil'>!");
					return false;
				}
			}else{
				if(sistem_para_birimi==document.all.basket_money.value){
					alert("<cf_get_lang dictionary_id='57122.Sistem Para Birimi ile Fatura Para Birimi İthalat Faturası İçin Aynı'>!");
					/*Talep Uzerine Sadece Bilgi Verilmesi Istendi, Islem Engellenmesin
					return false;
					*/
				}
			}
		}else{
			if(form_basket.cash.checked){
				kasa_para_birimi = eval("form_basket.str_kasa_parasi" + form_basket.kasa.options[form_basket.kasa.selectedIndex].value);
				if( sistem_para_birimi != kasa_para_birimi.value){
					alert("<cf_get_lang dictionary_id='57034.Sistem Para Birimi ile Kasanizin Para Birimi Aynı Değil'>!");
					return false;
				}
			}
		}
	}
	return true;
	}
	function cagir_tarih()
	{
		control_account_process(<cfoutput>'#attributes.iid#',document.form_basket.old_process_type.value</cfoutput>); 
		if (!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
		if (!check_accounts('form_basket')) return false;
		if (!kontrol_ithalat()) return false;
		if (!check_product_accounts()) return false;
		saveForm();
		return false;
	}
	function kontrol2()
	{
		return control_account_process(<cfoutput>'#attributes.iid#',document.form_basket.old_process_type.value</cfoutput>); 
		if (!chk_process_cat('form_basket')) return false;
		if(!check_display_files('form_basket')) return false;
		form_basket.del_invoice_id.value = <cfoutput>#attributes.iid#</cfoutput>;
		return true;	
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
