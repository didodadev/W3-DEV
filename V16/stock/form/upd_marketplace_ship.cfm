<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.UPD_ID = url.ship_id >
<cfscript>session_basket_kur_ekle(action_id=attributes.ship_id,table_type_id:2,process_type:1);</cfscript>
<cfinclude template="../query/get_upd_purchase.cfm">
<cfif not get_upd_purchase.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfset attributes.company_id = get_upd_purchase.COMPANY_ID >
<cfset company_id = get_upd_purchase.company_id>
<cfset type_id = get_upd_purchase.ship_type >
<div id="basket_main_div">
<cf_catalystHeader>
  <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
      <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_marketplace_ship">
      
        <cf_basket_form id="marketplace_ship">
          <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
          <input type="hidden" name="form_action_address" id="form_action_address" value="<cfoutput>#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_marketplace_ship</cfoutput>">
          <input type="hidden" name="search_process_date" id="search_process_date" value="ship_date">
          <input type="hidden" name="upd_id" id="upd_id" value="<cfoutput>#attributes.UPD_ID#</cfoutput>">
          <input type="hidden" name="TYPE_ID" id="TYPE_ID" value="<cfoutput>#type_id#</cfoutput>">
          <cf_box_elements>
            <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="1">
              <div class="form-group" id="item-process_cat">			
                  <label class="col col-4" ><cf_get_lang dictionary_id='57800.Operasyon Tipi'></label>
                  <div class="col col-8">
                    <cf_workcube_process_cat process_cat="#get_upd_purchase.process_cat#">
                  </div>
              </div> 
              <div class="form-group" id="item-ship_number">
                  <label class="col col-4" ><cf_get_lang dictionary_id='58138.İrsaliye No'>*</label>
                  <div class="col col-8">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='41835.İrsaliye No Girmelisiniz'>!</cfsavecontent>
                    <cfinput type="text" name="ship_number" style="width:150px;"  value="#get_upd_purchase.ship_number#" required="Yes" maxlength="50" message="#message#">
                  </div>
              </div>  
              <div class="form-group" id="item-ship_method">
                  <label class="col col-4" ><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                  <div class="col col-8">
                      <div class="input-group">
                        <input type="hidden" name="ship_method" id="ship_method" value="<cfoutput>#get_upd_purchase.SHIP_METHOD#</cfoutput>">
                        <cfif len(get_upd_purchase.SHIP_METHOD)>
                          <cfset attributes.ship_method_id = get_upd_purchase.SHIP_METHOD>
                          <cfinclude template="../query/get_ship_method.cfm">
                        </cfif>
                        <input type="text" name="ship_method_name" id="ship_method_name" style="width:150px;" readonly value="<cfif len(get_upd_purchase.SHIP_METHOD)><cfoutput>#GET_SHIP_METHOD.SHIP_METHOD#</cfoutput></cfif>" >
                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method');"></span>
                      </div>
                  </div>
              </div> 
            </div>
            <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="2">
              <div class="form-group" id="item-comp_name">
                  <label class="col col-4" style="text-align:left;"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
                  <div class="col col-8">
                      <div class="input-group">
                        <cfoutput>
                          <input type="hidden" name="company_id" id="company_id" value="#get_upd_purchase.company_id#">
                        </cfoutput>
                        <cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0>
                          <cfinclude template="../query/get_company_discount.cfm">
                          <cfinput type="text" name="comp_name"  value="#get_par_info(get_upd_purchase.company_id,1,0,0)#" style="width:150px;">
                        <cfelse>
                          <cfquery name="GET_CONS_NAME_UPD" datasource="#dsn#">
                          SELECT CONSUMER_NAME, CONSUMER_SURNAME, COMPANY, CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID=#get_upd_purchase.CONSUMER_ID#
                          </cfquery>
                          <cfinput type="text" name="comp_name" value="#get_cons_name_upd.company#" style="width:150px;">
                        </cfif>                        
                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_name=form_basket.partner_name&field_partner=form_basket.partner_id&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id&come=stock&var_new=form_basket<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>')"></span>
                      </div>    
                  </div>
              </div>
              <div class="form-group" id="item-ship_date">
                  <label class="col col-4" style="text-align:left;"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                  <div class="col col-8">
                      <div class="input-group">
                          <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih Giriniz'></cfsavecontent>
                          <cfinput type="text" name="ship_date" style="width:150px;" validate="#validate_style#"  value="#dateformat(get_upd_purchase.ship_date,dateformat_style)#" message="#message#">  
                          <span class="input-group-addon"><cf_wrk_date_image date_field="ship_date"></span>
                      </div>
                  </div>
              </div>
              <div class="form-group" id="item-location_id">
                  <label class="col col-4" style="text-align:left;"><cf_get_lang dictionary_id='58763.Depo'>*</label>
                  <div class="col col-8">   
                    <cfset search_dep_id = get_upd_purchase.DEPARTMENT_IN>
                    <cfinclude template = "../query/get_dep_names_for_inv.cfm">
                    <cfset txt_department_name = get_name_of_dep.DEPARTMENT_HEAD>
                    <cfset branch_id = get_name_of_dep.BRANCH_ID>
                    <cfif len(search_dep_id) and len(trim(get_upd_purchase.LOCATION_IN))>
                        <cfset search_location_id = get_upd_purchase.LOCATION_IN>
                        <cfinclude template="../query/get_location_for_inv.cfm">
                        <cfset txt_department_name = txt_department_name & "-" & get_location.COMMENT>
                    </cfif>
                    <cf_wrkdepartmentlocation 
                        returnInputValue="location_id,department_name,department_id,branch_id"
                        returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                        fieldName="department_name"
                        fieldId="location_id"
                        department_fldId="department_id"
                        branch_fldId="branch_id"
                        branch_id="#branch_id#"
                        department_id="#get_upd_purchase.DEPARTMENT_IN#"
                        location_id="#get_upd_purchase.LOCATION_IN#"
                        location_name="#txt_department_name#"
                        user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                        width="150"
                        is_branch="1">   
                  </div>
                </div>
            </div> 
            <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="3">
              <div class="form-group" id="item-partner_name">
                  <label class="col col-4" style="text-align:left;"><cf_get_lang dictionary_id='57578.Yetkili'></label>
                  <div class="col col-8">
                    <cfoutput>
                      <input type="hidden" name="partner_id" id="partner_id" value="#get_upd_purchase.partner_id#">
                      <input type="hidden" name="consumer_id" id="consumer_id" value="#get_upd_purchase.consumer_id#">
                    </cfoutput>
                    <cfif len(get_upd_purchase.company_id) and  get_upd_purchase.company_id neq 0>
                      <input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_par_info(get_upd_purchase.partner_id,0,0,0)#</cfoutput>" style="width:150px;">
                      <cfelse>
                      <input type="text" name="partner_name" id="partner_name" value="<cfoutput>#get_cons_name_upd.CONSUMER_NAME# #get_cons_name_upd.CONSUMER_SURNAME#</cfoutput>" style="width:150px;">
                    </cfif>
                  </div>
              </div>   
              <div class="form-group" id="item-deliver_date_frm">
                  <label class="col col-4" style="text-align:left;"><cf_get_lang dictionary_id='34140.Fiili Sevk Tarihi'></label>
                  <div class="col col-8">
                      <div class="input-group">
                          <cfsavecontent variable="message"><cf_get_lang dictionary_id='41841.Fiili Sevk Tarihi Girmelisiniz'></cfsavecontent>
                          <cfinput type="text" name="deliver_date_frm" style="width:150px;" value="#dateformat(get_upd_purchase.deliver_date,dateformat_style)#" validate="#validate_style#" message="#message#">
                          <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm"></span>
                      </div>
                  </div>
              </div>
              <div class="form-group" id="item-deliver_date_frm">
                  <label class="col col-4" style="text-align:left;"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
                  <div class="col col-8">
                      <div class="input-group">        
                        <input type="hidden" name="deliver_get_id" id="deliver_get_id"  value="<cfoutput>#get_upd_purchase.deliver_emp_id#</cfoutput>">
                        <cfinput type="text" name="deliver_get" style="width:150px;" readonly value="#get_emp_info(GET_UPD_PURCHASE.deliver_emp_id,0,0)#">
                          <span class="input-group-addon icon-ellipsis btnPointer" href="#" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.deliver_get&field_emp_id2=form_basket.deliver_get_id</cfoutput>')"></span>
                      </div>
                  </div>
              </div>
            </div>
            <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="3">
              <div class="form-group" id="item-ship_number">
                <cfquery name="get_invoice_ship" datasource="#dsn2#">
                  SELECT INVOICE_NUMBER,INVOICE_ID FROM INVOICE_SHIPS WHERE SHIP_ID = #get_upd_purchase.SHIP_ID# AND SHIP_PERIOD_ID=#session.ep.period_id#
                </cfquery>
                <cf_get_lang dictionary_id='45679.İrsaliye İptal'><input name="irsaliye_iptal" id="irsaliye_iptal" value="1" type="checkbox" <cfif len(get_upd_purchase.is_ship_iptal) and get_upd_purchase.is_ship_iptal eq 1>checked</cfif>>
              </div>
            </div>
          </cf_box_elements>
          <cf_box_footer>
            <cf_record_info query_name='get_upd_purchase'>
              <input type="hidden" name="del" id="del" value="">
              <cfif not len(get_upd_purchase.IS_WITH_SHIP) or  ( len( get_upd_purchase.IS_WITH_SHIP) and not get_upd_purchase.IS_WITH_SHIP)>
                  <cf_workcube_buttons 
                      is_upd='1' 
                      is_delete=1 
                      add_function='upd_form_function()' 
                      del_function='cagir()'
                      >
                  <!--- <cf_workcube_buttons
                          is_upd = '0'
                          insert_info = '  Sil  '
                          is_reset=false
                          is_cancel=false
                          add_function = 'cagir()'
                          insert_alert = 'Silmek İstediğinizden Emin misiniz?'>	 --->											
              <cfelse>
                  <cf_workcube_buttons 
                      is_upd='1'
                      is_delete=false 
                      add_function='upd_form_function()' 
                      >
              </cfif>
          </cf_box_footer>
        </cf_basket_form>
        <cfset attributes.basket_id =40>
        <cfinclude template="../../objects/display/basket.cfm">
      </cfform>
    </cf_box>
  </div>
</div>
         
<script type="text/javascript">
	function upd_form_function()
	{
		if(!chk_process_cat('form_basket')) return false;
		if(!chck_zero_stock()) return false;
		saveForm();
        return false;
	}
	function cagir()
	{
		if(!chk_process_cat('form_basket')) return false;
		if(!chck_zero_stock(1)) return false; //sadece silme işleminden cagrılırken 1 gönderiliyor
		<cfif len(get_invoice_ship.INVOICE_NUMBER)>
			if(!confirm("<cf_get_lang dictionary_id='41890.Bu irsaliye fatura ile ilişkilendirilmiş silmek istediğinizden emin misiniz'>?")) return false;
		</cfif>
		form_basket.del.value=1;
	}
	function chck_zero_stock(is_del)
	{ 
		if(check_stock_action('form_basket'))
		{
			var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
			if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonunda sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılır --->
			{
				var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
				var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
				if(!zero_stock_control(form_basket.department_id.value,form_basket.location_id.value,form_basket.upd_id.value,temp_process_type.value,0,is_del)) return false;
			}
		}
		return true;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
