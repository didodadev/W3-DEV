<cf_get_lang_set module_name="invoice"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined('form.active_company') and form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='35766.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı. Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.marketplace_commands</cfoutput>';
	</script>
	<cfabort>
</cfif> 
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cfset kontrol_status = 1>
<cfinclude template="../query/get_session_cash_all.cfm">
<cfinclude template="../query/control_bill_no.cfm">
<cfinclude template="../query/get_marketplace_info.cfm">


<div id="basket_main_div">
  <cf_catalystHeader>
  <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>  
      <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_marketplace_bill">
          <cf_basket_form id="marketplace_bill">
            <cfoutput>
              <input type="hidden" name="form_action_address" id="form_action_address" value="#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_marketplace_bill">
              <input type="hidden" name="active_period" id="active_period" value="#session.ep.period_id#">
              <input type="hidden" name="search_process_date" id="search_process_date" value="invoice_date">
              <input type="hidden" name="member_account_code" id="member_account_code" <cfif len(GET_SHIP_DETAIL.CONSUMER_ID)>value="#GET_CONSUMER_PERIOD(GET_SHIP_DETAIL.CONSUMER_ID)#"<cfelse>value="#GET_COMPANY_PERIOD(GET_SHIP_DETAIL.COMPANY_ID)#"</cfif>>
            </cfoutput>
            <cf_box_elements>
              <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="1">
                <div class="form-group" id="item-process_cat">			
                  <label class="col col-4"><cf_get_lang dictionary_id='57800.Operasyon Tipi'></label>
                  <div class="col col-8">
                    <cf_workcube_process_cat>
                  </div>
                </div> 
                <div class="form-group" id="item-invoice_number">			
                  <label class="col col-4"><cf_get_lang dictionary_id='58133.Fatura No'>*</label>
                  <div class="col col-8">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57184.Fatura No Girmelisiniz !'></cfsavecontent>
                    <cfinput type="text" maxlength="50" name="invoice_number" style="width:150px;" required="Yes" message="#message#" >
                  </div>
                </div> 
                <div class="form-group" id="item-ship_method">			
                  <label class="col col-4"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                  <div class="col col-8">
                    <div class="input-group">
                      <input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#GET_SHIP_DETAIL.SHIP_METHOD#</cfoutput>">
                        <cfif len(GET_SHIP_DETAIL.ship_method)>
                          <cfset attributes.ship_method_id=GET_SHIP_DETAIL.ship_method>
                          <cfinclude template="../query/get_ship_methods.cfm">
                        </cfif>
                        <input type="text" name="ship_method_name" id="ship_method_name" style="width:150px;" value="<cfif len(GET_SHIP_DETAIL.ship_method)><cfoutput>#ship_methods.ship_method#</cfoutput></cfif>">
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method');"></span>
                    </div>
                  </div>
                </div> 
                <div class="form-group" id="item-cash">			
                  <label class="col col-4"><cfif kasa.recordcount><cf_get_lang dictionary_id='57163.Nakit Alış'></cfif></label>
                  <div class="col col-8">
                    <cfif kasa.recordcount> <input type="Checkbox" name="cash" id="cash" onClick="ayarla_gizle_goster();"></cfif>
                  </div>
                </div> 
                <div class="form-group" style="display:none;" id="item-kasa">			
                  <label class="col col-4"><cfif kasa.recordcount><cf_get_lang dictionary_id='57031.Kasa Seçimi'></cfif></label>
                  <div class="col col-8">
                    <select name="kasa" id="kasa" style="width:150px;">
                      <cfoutput QUERY="kasa">
                        <option VALUE="#cash_id#">#cash_name# 
                      </cfoutput>
                    </select>
                      <cfoutput QUERY="kasa">
                        <input type="hidden" name="str_kasa_parasi#cash_id#" id="str_kasa_parasi#cash_id#" value="#CASH_CURRENCY_ID#">
                      </cfoutput>	
                  </div>
                </div> 
              </div>
              <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="2">
                <div class="form-group" id="item-comp_name">			
                  <label class="col col-4"><cf_get_lang dictionary_id='57519.cari hesap'>*</label>
                  <div class="col col-8">
                    <div class="input-group">
                      <cfset str_linkeait="&field_paymethod_id=form_basket.paymethod_id&field_paymethod=form_basket.paymethod&field_basket_due_value=form_basket.basket_due_value">					
                        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#GET_SHIP_DETAIL.COMPANY_ID#</cfoutput>">
                        <input  name="comp_name" id="comp_name" type="text" readonly <cfif len(GET_SHIP_DETAIL.COMPANY_ID)>value="<cfoutput>#get_par_info(GET_SHIP_DETAIL.COMPANY_ID,1,0,0)#</cfoutput>"</cfif> style="width:150px;">
                        <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&field_member_account_code=form_basket.member_account_code#str_linkeait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>')">
                        </span>
                    </div>
                  </div>
                </div> 
                <div class="form-group" id="item-invoice_date">			
                  <label class="col col-4"><cf_get_lang dictionary_id='58759.Fatura Tarihi'>*</label>
                  <div class="col col-8">
                    <div class="input-group">
                      <cfsavecontent variable="message"><cf_get_lang dictionary_id='57185.Fatura Tarihi Girmelisiniz !'></cfsavecontent>
                      <cfinput type="text" name="invoice_date" style="width:150px;" validate="#validate_style#" VALUE="#dateformat(now(),dateformat_style)#" required="yes" message="#message#">
                      <span class="input-group-addon"><cf_wrk_date_image date_field="invoice_date"></span>
                    </div>
                  </div>
                </div> 
                <div class="form-group" id="item-department_name">			
                  <label class="col col-4"><cf_get_lang dictionary_id='58763.Depo'>*</label>
                  <div class="col col-8">
                    <div class="input-group">
                      <cfif len(GET_SHIP_DETAIL.DEPARTMENT_IN)>
                        <cfset attributes.department_id = GET_SHIP_DETAIL.DEPARTMENT_IN >
                        <cfinclude template="../query/get_dept_name.cfm" >
                        <cfset branch_id=get_dept_name.BRANCH_ID>
                        <cfset txt_department_name = get_dept_name.DEPARTMENT_HEAD >
                        <cfif len(GET_SHIP_DETAIL.LOCATION_IN) >
                          <cfset attributes.location_id = GET_SHIP_DETAIL.LOCATION_IN >
                          <cfinclude template="../query/get_location_name.cfm" >
                          <cfset txt_department_name = txt_department_name & "-" & get_location_name.COMMENT >
                        </cfif>
                      <cfelse>
                        <cfset txt_department_name="">
                        <cfset txt_department_id = "">,
                        <cfset branch_id="">
                      </cfif>
                      <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#branch_id#</cfoutput>">							
                      <input type="hidden" name="department_id" id="department_id" value="<cfoutput>#GET_SHIP_DETAIL.DEPARTMENT_IN#</cfoutput>">
                      <input type="hidden" name="location_id" id="location_id" value="<cfoutput>#GET_SHIP_DETAIL.LOCATION_IN#</cfoutput>">
                      <cfsavecontent variable="message"><cf_get_lang dictionary_id='57186.Depo Girmelisiniz !'></cfsavecontent>
                      <cfinput type="Text"  style="width:150px;" name="department_name"  value="#txt_department_name#" required="yes" message="#message#">
                      <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=department_name&field_id=department_id&field_location_id=location_id<cfif session.ep.isBranchAuthorization>&is_branch=1</cfif></cfoutput>')"></span>				
                    </div>
                  </div>
                </div> 
              </div>
              <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="3">
                <div class="form-group" id="item-partner_name">			
                  <label class="col col-4"><cf_get_lang dictionary_id='57578.Yetkili'>*</label>
                  <div class="col col-8">
                    <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#GET_SHIP_DETAIL.PARTNER_ID#</cfoutput>">
                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#GET_SHIP_DETAIL.CONSUMER_ID#</cfoutput>">
                    <input type="text" name="partner_name" id="partner_name" <cfif len(GET_SHIP_DETAIL.CONSUMER_ID)>value="<cfoutput>#get_cons_info(GET_SHIP_DETAIL.CONSUMER_ID,0,0)#</cfoutput>"<cfelse>value="<cfoutput>#get_par_info(GET_SHIP_DETAIL.PARTNER_ID,0,0,0)#</cfoutput>"</cfif> readonly style="width:150px;">
                  </div>
                </div> 
                <div class="form-group" id="item-deliver_get">			
                  <label class="col col-4"><cf_get_lang dictionary_id='57775.Teslim Alan'>*</label>
                  <div class="col col-8">
                    <div class="input-group">
                      <input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="<cfoutput>#session.ep.userid#</cfoutput>">
                      <input type="text" name="deliver_get" id="deliver_get" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" style="width:150px;" readonly>
                      <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>');"></span> 
                    </div>
                  </div>
                </div> 
                <div class="form-group" id="item-note">			
                  <label class="col col-4"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                  <div class="col col-8">
                    <textarea style="width:150px;height:45px;" name="note" id="note"></textarea>
                  </div>
                </div> 
              </div>
              <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="4">
                <div class="form-group" id="item-irsaliye">			
                  <label class="col col-4"><cf_get_lang dictionary_id='57773.İrsaliye'></label>
                  <div class="col col-8">
                    <input type="hidden" name="irsaliye_ids" id="irsaliye_ids" value="<cfoutput>#VALUELIST(GET_SHIP_DETAIL.SHIP_ID)#</cfoutput>">
                    <input type="text" name="irsaliye" id="irsaliye" style="width:150px;" value="<cfoutput>#VALUELIST(GET_SHIP_DETAIL.SHIP_NUMBER)#</cfoutput>" readonly>
                  </div>
                </div> 
                <div class="form-group" id="item-irsaliye">			
                  <label class="col col-4"><cf_get_lang dictionary_id='30011.Satın alan'></label>
                  <div class="col col-8">
                    <div class="input-group">
                      <input type="hidden" name="EMPO_ID" id="EMPO_ID">
                      <input type="hidden" name="PARTO_ID" id="PARTO_ID" value="">
                      <input type="text" name="PARTNER_NAMEO" id="PARTNER_NAMEO" value="" style="width:150px;"> 
                      <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=form_basket.PARTNER_NAMEO&field_EMP_id=form_basket.EMPO_ID&field_id=form_basket.PARTO_ID</cfoutput>')"></span>
                    </div>
                  </div>
                </div> 
                <div class="form-group" id="item-irsaliye">			
                  <label class="col col-4"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                  <div class="col col-8">
                    <div class="input-group">
                      <input name="basket_due_value" id="basket_due_value" type="hidden" value="">				  
                      <input type="hidden" name="paymethod_id" id="paymethod_id" value="">
                      <input type="text" name="paymethod" id="paymethod" style="width:150px;"  value="" readonly>
                      <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.paymethod</cfoutput>');"></span> 
                    </div>
                  </div>
                </div> 
              </div>
            </cf_box_elements>
            <cf_box_footer>
              <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
          </cf_basket_form> 
          <cfset attributes.basket_sub_id = 42 >
          <cfset attributes.basket_id = 42 >
          <cfinclude template="../../objects/display/basket.cfm">
      </cfform>
    </cf_box>
  </div>
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
						alert("<cf_get_lang dictionary_id ='57034.Sistem Para Birimi ile Kasanizin Para Birimi Aynı Değil'>!");
						return false;
					}
				}else{
					if(sistem_para_birimi==document.all.basket_money.value){
						alert("<cf_get_lang dictionary_id ='57122.Sistem Para Birimi ile Fatura Para Birimi İthalat Faturası İçin Aynı'>!");
						/*Talep Uzerine Sadece Bilgi Verilmesi Istendi, Islem Engellenmesin
						return false;
						*/
					}
				}
		}else{
			if(form_basket.cash.checked){
				kasa_para_birimi = eval("form_basket.str_kasa_parasi" + form_basket.kasa.options[form_basket.kasa.selectedIndex].value);
				if( sistem_para_birimi != kasa_para_birimi.value){
					alert("<cf_get_lang dictionary_id ='57034.Sistem Para Birimi ile Kasanizin Para Birimi Aynı Değil'>!");
					return false;
				}
			}
		}
	}
	return true;
}
function kontrol()
{	
	if (!chk_process_cat('form_basket')) return false;
	if(!check_display_files('form_basket')) return false;
	if (!chk_period(form_basket.invoice_date,"İşlem")) return false;
	if (!kontrol_ithalat()) return false;
	try{
		try{a=form_basket.row_ship_id[0].value;}catch(e){a=form_basket.row_ship_id.value;}
		if (a == "" || a == "0" )
		{
			if(form_basket.department_id.value==""){
				alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
				return false;
			}
			if(form_basket.deliver_get.value==""){
				alert("<cf_get_lang dictionary_id ='57285.Teslim Alan Seçiniz'>!");
				return false;			
			}
		}
	}
		catch(e){
			if(form_basket.department_id.value==""){
				alert("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>");
				return false;
			}
			if(form_basket.deliver_get.value==""){
				alert("<cf_get_lang dictionary_id ='57285.Teslim Alan Seçiniz'>!");
				return false;			
			}		
		}	

	if (document.form_basket.comp_name.value == ""  && document.form_basket.consumer_id.value == "")
		{ 
		alert ("<cf_get_lang dictionary_id='57183.Cari Hesap Seçmelisiniz !'>");
		return false;
		}
	if (!check_accounts('form_basket')) return false;
	if (!check_product_accounts()) return false;
	saveForm();
	return false;
}
function ayarla_gizle_goster()
{
	if(form_basket.cash.checked) {
		not.style.display = '';
		not_2.style.display = '';
		not_3.style.display = '';
	}else{
		not.style.display = 'none';
		not_2.style.display = 'none';
		not_3.style.display = 'none';		
	}
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
