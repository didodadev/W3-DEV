<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
  <cfif isdefined("attributes.id")>
    <cfset attributes.order_id=attributes.id>
  </cfif>
  <cfscript>session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,process_type:1);</cfscript>
  <cfinclude template="../query/get_priorities.cfm">
  <cfset order_purchase=1>
  <cfinclude template="../query/get_order_detail.cfm">
  <cfinclude template="../query/get_stores.cfm">
  <script type="text/javascript">
    function go_approve(incoming)
    {
      window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.approve_order&id=" + incoming;
    }
    
    function go_del(incoming)
    {
      window.location.href = "<cfoutput>#request.self#?fuseaction=purchase.del_order&order_id=#attributes.order_id#</cfoutput>";
    }
  </script>
  <cfquery name="GET_ORDERS_SHIP" datasource="#dsn3#">
      SELECT * FROM ORDERS_SHIP WHERE ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID = #session.ep.period_id#
  </cfquery>
  <cfquery name="GET_ORDERS_INVOICE" datasource="#dsn3#">
      SELECT * FROM ORDERS_INVOICE WHERE ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID = #session.ep.period_id#
  </cfquery>
  <cf_catalystHeader>
    <div class="col col-12">
      <cf_box>
        <form name="form_basket" id="form_basket">
          <cf_basket_form id="detail_orderp">
           
                          <div class="ui-form-list row" type="row">
                              <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                  <div class="form-group" id="item-partner_id">
                                      <label class="col col-3 col-xs-12 bold"><cf_get_lang_main no='162.Şirket'>:</label>
                                        <label class="col col-9 col-xs-12">
                                        <cfoutput>#get_par_info(get_order_detail.partner_id,0,1,0)#</cfoutput>
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-partner_id">
                                      <label class="col col-3 col-xs-12 bold"><cf_get_lang_main no='166.Yetkili'>:</label>
                                        <label class="col col-9 col-xs-12">
                          <cfoutput>#get_par_info(get_order_detail.partner_id,0,-1,0)#</cfoutput>
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-order_number">
                                      <cfif session.ep.our_company_info.subscription_contract eq 1>
                                        <label class="col col-3 col-xs-12 bold"><cf_get_lang_main no='799.Sipariş No'>:</label>
                                        </cfif>
                                        <label class="col col-9 col-xs-12">
                          <cfoutput>#get_order_detail.order_number#</cfoutput> <cfoutput>#get_order_detail.order_head#</cfoutput>
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-order_detail">
                                      <cfif session.ep.our_company_info.subscription_contract eq 1>
                                        <label class="col col-3 col-xs-12 bold"><cf_get_lang_main no='217.Açıklama'>:</label>
                                        </cfif>
                                        <label class="col col-9 col-xs-12">
                          
                          <cfif len(get_order_detail.offer_id) and (get_order_detail.offer_id neq 0)>
                                            <cfset attributes.offer_id = get_order_detail.offer_id>
                                            <cfinclude template="../query/get_offer_head.cfm">
                                            <input type="hidden" name="offer_id" id="offer_id" value="<cfoutput>#get_order_detail.offer_id#</cfoutput>">
                                            <cfoutput>#get_offer_head.offer_head#</cfoutput>
                                          <cfelseif len(get_order_detail.order_detail)>
                                            <cfoutput>#get_order_detail.order_detail#</cfoutput>
                                          </cfif>
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-ref_no">
                                      <cfif session.ep.our_company_info.subscription_contract eq 1>
                                        <label class="col col-3 col-xs-12 bold"><cf_get_lang_main no='1382.Sipariş No'>:</label>
                                        </cfif>
                                        <label class="col col-9 col-xs-12">
                          <cfoutput>#get_order_detail.ref_no#</cfoutput>
                                        </label>
                                    </div>
                                </div>
                                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                  <div class="form-group" id="item-deliverdate">
                                      <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no='233.Teslim Tarihi'>:</label>
                                        <label class="col col-8 col-xs-12">
                                          <cfoutput>#dateformat(get_order_detail.deliverdate,dateformat_style)#</cfoutput>
                                        </label>
                                    </div>
                                     <div class="form-group" id="item-deliver_state_id">
                                      <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no='1037.Teslim Yeri'>:</label>
                                        <label class="col col-8 col-xs-12">
                                          <cfoutput>
                          <cfif isDefined("attributes.order_id") and len(get_order_detail.SHIP_ADDRESS) and isnumeric(get_order_detail.SHIP_ADDRESS)>
                                              #stores.DEPARTMENT_HEAD#
                                              <cfelse>
                                              #get_order_detail.SHIP_ADDRESS#
                                            </cfif>
                                          </cfoutput>
                                          <input type="hidden" name="deliver_state_id" id="deliver_state_id" value="">
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-SHIP_METHOD_ID">
                                      <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no='1703.Sevk Yöntemi'>:</label>
                                        <label class="col col-8 col-xs-12">
                                          
                          <cfif len(get_order_detail.SHIP_METHOD)>
                                            <cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
                                                SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID=#get_order_detail.SHIP_METHOD#
                                            </cfquery>
                                            <cfoutput>#GET_SHIP_METHOD.SHIP_METHOD#</cfoutput>
                                          </cfif>
                                          <input type="hidden" name="deliver_state_id" id="deliver_state_id" value="">
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-SHIP_ADDRESS">
                                      <label class="col col-4 col-xs-12 bold"><cf_get_lang no='125.Sevk Adresi'>:</label>
                                        <label class="col col-8 col-xs-12">
                                          
                          <cfif isnumeric(get_order_detail.SHIP_ADDRESS)>
                                            <cfset search_dep_id=get_order_detail.SHIP_ADDRESS>
                                            <cfinclude template="../query/get_dep_names_for_inv.cfm">
                                            <cfset txt_department_name=get_name_of_dep.DEPARTMENT_HEAD>
                                            <cfoutput>#txt_department_name#</cfoutput>
                                          </cfif>
                                        </label>
                                    </div>
                                </div>
                                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                  <div class="form-group" id="item-order_status">
                                      <label class="col col-3 col-xs-12 bold"><cf_get_lang_main no='344.Durum'>:</label>
                                        <label class="col col-9 col-xs-12">
                          
                          <cfif get_order_Detail.order_status is 1>
                                            - <cf_get_lang_main no='81.Aktif'>
                                            <cfelse>
                                            - <cf_get_lang_main no='82.Pasif'>
                                          </cfif>
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-priority_id">
                                      <label class="col col-3 col-xs-12 bold"><cf_get_lang_main no='73.Öncelik'>:</label>
                                        <label class="col col-9 col-xs-12">
                          
                                            <cfloop from="1" to="#get_priorities.recordcount#" index="i">
                                              <cfif get_priorities.priority_id[i] eq get_order_detail.priority_id>
                                                <cfoutput>#get_priorities.priority[i]#</cfoutput>
                                              </cfif>
                                            </cfloop>
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-RECORD_DATE">
                                      <label class="col col-3 col-xs-12 bold"><cf_get_lang_main no='71.Kayıt'>:</label>
                                        <label class="col col-9 col-xs-12">
                          <cfoutput>#get_emp_info(get_order_detail.record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,get_order_detail.RECORD_DATE),dateformat_style)# #dateformat(date_add('h',session.ep.time_zone,get_order_detail.RECORD_DATE),timeformat_style)#</cfoutput>
                                        </label>
                                    </div>
                                    <div class="form-group" id="item-PROJECT_ID">
                                    <cfif session.ep.our_company_info.project_followup eq 1>
                                      <label class="col col-3 col-xs-12 bold"><cf_get_lang_main no='4.Proje'>:</label></cfif>
                                        <label class="col col-9 col-xs-12">
                          <cfif session.ep.our_company_info.project_followup eq 1>
                            <cfif len(get_order_detail.project_id)>
                                                    <cfquery name="GET_PROJECT" datasource="#dsn#">
                                                        SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_order_detail.project_id#
                                                    </cfquery>
                                                  <cfoutput>#get_project.project_head#</cfoutput>
                                                <cfelse>
                                                </cfif>
                                            </cfif>
                                        </label>
                                    </div>
                                </div>
                            </div>
                    
          </cf_basket_form>
          <cfset attributes.basket_id = 15 >
          <cfset attributes.is_view = 1 > 
          <cfinclude template="../../objects/display/basket.cfm">
        </form>
      </cf_box>
    </div>
   
  
  <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
  