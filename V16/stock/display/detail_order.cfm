<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
    <cfif isdefined("attributes.id")>
      <cfset attributes.order_id=attributes.id>
    </cfif>
    <cfscript>session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,process_type:1);</cfscript>
    <cfinclude template="../query/get_priorities.cfm">
    <cfinclude template="../query/get_order_detail.cfm">
    <cfif not GET_ZONE_TYPE.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfquery name="GET_ORDERS_SHIP" datasource="#dsn3#">
        SELECT 
            ORDER_SHIP_ID, 
            ORDER_ID, 
            SHIP_ID, 
            PERIOD_ID, 
            CHANGE_RESERVE_STATUS, 
            ADD_FLAG 
        FROM 
            ORDERS_SHIP 
        WHERE 
            ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID = #session.ep.period_id#
    </cfquery>
    <cfquery name="GET_ORDERS_INVOICE" datasource="#dsn3#">
        SELECT 
            ORDER_INVOICE_ID, 
            INVOICE_ID, 
            INVOICE_NUMBER, 
            ORDER_ID, 
            ORDER_NUMBER, 
            PERIOD_ID, 
            CHANGE_RESERVE_STATUS, 
            ADD_FLAG 
        FROM 
            ORDERS_INVOICE 
        WHERE 
            ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID = #session.ep.period_id#
    </cfquery>	
    <cf_catalystHeader>
    <div class="col col-12">
        <cf_box>
            <form name="form_basket">
                    <!--- siparis dogrudan faturalastırıldıgında hem ORDERS_INVOICE tablosuna kayıt atar, hem de bu faturanın oluşturdugu irsaliye ile
                    baglantının kopmaması için ORDERS_SHIP tablosuna da kayıt atar.
                        1- irsaliyeye veya faturaya cekilmemis siparis icin ORDERS_SHIP tablosunda kayıt olmaz, bu durumda siparis faturalandırılabilir
                        2- siparis daha önce faturalandırılmıssa kapatılana kadar tekrar faturalandırılabilir. --->
                <cf_basket_form id="detail_order">
                
                                <div class="ui-form-list row" type="row">
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                        <div class="form-group" id="item-consumer_id">
                                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no='45.Müşteri'>:</label>
                                            <label class="col col-8 col-xs-12">
                                                
                                                <cfif len(get_order_detail.partner_id)>
                                                <cfoutput>#get_par_info(get_order_detail.partner_id,0,0,1)#</cfoutput>
                                                <cfelseif len(get_order_detail.consumer_id)>
                                                <cfoutput>#get_cons_info(get_order_detail.consumer_id,0,1)#</cfoutput>
                                                </cfif>
                                            </label>
                                        </div>
                                        <div class="form-group" id="item-order_number">
                                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no='799.sip no'>:</label>
                                            <label class="col col-8 col-xs-12">
                                                <cfoutput>#get_order_detail.order_number#</cfoutput>
                                            </label>
                                        </div>
                                        <div class="form-group" id="item-offer_id">
                                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no='800.Teklif No'>:</label>
                                            <label class="col col-8 col-xs-12">
                                                <cfif len(get_order_detail.offer_id)>
                                                    <cfset attributes.offer_id = get_order_detail.offer_id>
                                                    <cfinclude template="../query/get_offer_head.cfm">
                                                    <cfoutput>#get_order_detail.offer_id#</cfoutput>
                                                </cfif>
                                            </label>
                                        </div>
                                        <div class="form-group" id="item-ref_no">
                                            <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no='1382.Ref No'>:</label>
                                            <label class="col col-8 col-xs-12">
                                                
                                            <cfoutput>#get_order_detail.ref_no#</cfoutput>
                                            </label>
                                        </div>
                                        <div class="form-group" id="item-subscription_id">
                                            <cfif session.ep.our_company_info.subscription_contract eq 1>
                                                <label class="col col-4 col-xs-12 bold"><cf_get_lang_main no='1420.Abone'>:</label>
                                            </cfif>
                                            <label class="col col-8 col-xs-12">
                                                
                                                <cfif session.ep.our_company_info.subscription_contract eq 1>
                                                    <cfif len(get_order_detail.subscription_id)>
                                                        <cfquery name="GET_SUB" datasource="#DSN3#">
                                                            SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #get_order_detail.subscription_id#
                                                        </cfquery>
                                                        <cfif get_module_user(11)>
                                                            <cfoutput><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#get_order_detail.subscription_id#" class="tableyazi" target="_blank">#GET_SUB.SUBSCRIPTION_NO#</a></cfoutput>
                                                        <cfelse>
                                                            <cfoutput>#GET_SUB.SUBSCRIPTION_NO#</cfoutput>
                                                        </cfif>
                                                    </cfif>
                                                </cfif>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                                        <div class="form-group" id="item-deliverdate">
                                            <label class="col col-5 col-xs-12 bold"><cf_get_lang_main no='233.Teslim Tarihi'>:</label>
                                            <label class="col col-7 col-xs-12">
                                                <cfoutput>#dateformat(get_order_detail.deliverdate,dateformat_style)#</cfoutput>
                                            </label>
                                        </div>
                                        <div class="form-group" id="item-ship_address">
                                            <label class="col col-5 col-xs-12 bold"><cf_get_lang_main no='1037.teslim yeri'>:</label>
                                            <label class="col col-7 col-xs-12">
                                                <cfoutput>#get_order_detail.ship_address#</cfoutput>
                                            </label>
                                        </div>
                                        <div class="form-group" id="item-GET_SHIP_METHOD">
                                            <label class="col col-5 col-xs-12 bold"><cf_get_lang_main no='1703.Sevk Yöntemi'>:</label>
                                            <label class="col col-7 col-xs-12">
                                                
                                                <cfif len(get_order_detail.ship_method)>
                                                <cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
                                                    SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #get_order_detail.ship_method#
                                                </cfquery>
                                                <cfoutput>#get_ship_method.ship_method#</cfoutput>
                                            </cfif>
                                            </label>
                                        </div>
                                        <div class="form-group" id="item-GET_SHIP_METHOD">
                                        <cfif session.ep.our_company_info.project_followup eq 1>
                                            <label class="col col-5 col-xs-12 bold"><cf_get_lang_main no='4.Proje'>:</label></cfif>
                                            <label class="col col-7 col-xs-12">
                                                
                                                <cfif session.ep.our_company_info.project_followup eq 1>
                                                <cfif len(get_order_detail.project_id)>
                                                    <cfquery name="GET_PROJECT" datasource="#DSN#">
                                                        SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_order_detail.project_id#
                                                    </cfquery>
                                                    <cfoutput>#get_project.project_head#</cfoutput>
                                                </cfif>
                                            </cfif>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                                        <div class="form-group" id="item-order_status">
                                            <label class="col col-5 col-xs-12 bold"><cf_get_lang_main no='344.Durum'>:</label>
                                            <label class="col col-7 col-xs-12">
                                                <cf_get_lang_main no='1349.Sevk'> -
                                                    <cfif get_order_detail.order_status eq 0>
                                                    <cf_get_lang no='148.Gündemde Değil'>
                                                    <cfelse>
                                                    <cf_get_lang no='149.Gündemde'>
                                                    </cfif>
                                            </label>
                                        </div>
                                        <div class="form-group" id="item-priority_id">
                                        <cfif session.ep.our_company_info.project_followup eq 1>
                                            <label class="col col-5 col-xs-12 bold"><cf_get_lang_main no='73.öncelik'>:</label></cfif>
                                            <label class="col col-7 col-xs-12">
                                                
                                                <cfloop from="1" to="#get_priorities.recordcount#" index="i">
                                                <cfif get_priorities.priority_id[i] eq get_order_detail.priority_id>
                                                    <cfoutput>#get_priorities.priority[i]#</cfoutput>
                                                </cfif>
                                                </cfloop>
                                            </label>
                                        </div>
                                        <div class="form-group" id="item-order_employee_id">
                                        <cfif session.ep.our_company_info.project_followup eq 1>
                                            <label class="col col-5 col-xs-12 bold"><cf_get_lang no='52.satis calisan'>:</label></cfif>
                                            <label class="col col-7 col-xs-12">
                                                <cfif len(get_order_detail.order_employee_id)><cfoutput>#get_emp_info(get_order_detail.order_employee_id,0,0)#</cfoutput></cfif>
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                                        <div class="form-group" id="item-order_detail">
                                        <cfif session.ep.our_company_info.project_followup eq 1>
                                            <label class="col col-5 col-xs-12 bold"><cf_get_lang_main no ='217.Açıklama'>:</label></cfif>
                                            <label class="col col-7 col-xs-12">
                                                <cfoutput>#get_order_detail.order_detail#</cfoutput>
                                            </label>
                                        </div>
                                        <div class="form-group" id="item-print_count">
                                        <cfif session.ep.our_company_info.project_followup eq 1>
                                            <label class="col col-5 col-xs-12 bold"><cf_get_lang no="349.Sipariş Print Sayısı">:</label></cfif>
                                            <label class="col col-7 col-xs-12">
                                                <cfoutput>#get_order_detail.print_count#</cfoutput>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <cf_box_footer>
                                    <cf_record_info query_name='get_order_detail'>
                                </cf_box_footer>
                    
                </cf_basket_form>
                <div id="detail_order_bask">
                    <cfset attributes.basket_id = 14>
                    <cfset attributes.is_view= 1 >
                    <cfinclude template="../../objects/display/basket.cfm">
                </div>
            </form>
        </cf_box>
    </div>
    
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
    <cfsetting showdebugoutput="yes">
    