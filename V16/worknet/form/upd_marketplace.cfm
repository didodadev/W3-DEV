<style>
    p{text-align:center}
</style>
<cfset wrk = createObject("component","V16.worknet.cfc.worknet")>
<cfset cmp = createObject("component","V16.worknet.cfc.worknet_add_member")>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfset get_our_cmp = company_cmp.GET_OURCMP_INFO(company_id : session.ep.company_id)>
<cfparam  name="attributes.wrkid" default="">
<cfparam  name="attributes.wid" default="">
<cfset get_worknet = wrk.select( wid: attributes.wid)>
<cfset getRelationCompany = cmp.getRelationCompany( wrkid: attributes.wid)>
<cfset getComponent = createObject('component','V16.objects.cfc.upgrade_notes')>
<cfset get_release_version = getComponent.GET_RELEASE_VERSION()>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <div style="display:flex;align-items:center">
            <cfoutput query="get_worknet">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_get_server_file output_file="asset/watalogyImages/#IMAGE_PATH#" output_server="#SERVER_IMAGE_PATH_ID#" output_type="0" image_class="w-card">   
                </div>             
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <a <cfif len(getRelationCompany.STORE_URL)>href="#getRelationCompany.STORE_URL#" target="_blank"<cfelse>href="javascript://"</cfif> class="pull-right" ><span class="icn-md catalyst-home" style="color:##4DBEEF;font-size:20px"></span></a>
                    <a <cfif len(APPLICATION_WEB_ADRESS)>href="#APPLICATION_WEB_ADRESS#" target="_blank"<cfelse>href="javascript://"</cfif> class="pull-right padding-right-10" title="<cf_get_lang dictionary_id='65324.?'>"><span class="icn-md catalyst-doc" style="color:##4DBEEF;font-size:20px"></span></a>
                </div>
            </cfoutput>
        </div>
       
    </cf_box>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="update" method="post">
            <cfinput type="hidden" name="wrkid" id="wrkid" value="#attributes.wrkid#">
            <cfinput type="hidden" name="wid" id="wid" value="#attributes.wid#">
            <cfinput type="hidden" name="watalogy_code" id="watalogy_code" value="#get_our_cmp.WATALOGY_MEMBER_CODE#">
            <cfinput type="hidden" name="subscription_no" id="subscription_no" value="#get_release_version.workcube_id#">
            <div id="tab_menu">
                <cf_tab defaultOpen="shopping_information" divId="shopping_information,categories,products,orders,summer,dashboard" divLang="Mağaza Bilgileri;Kategoriler;Ürünler;Siparişler;Cari Hesap Özeti;Dashboard">
                    <div id="unique_shopping_information" class="uniqueBox">
                        <div class="col col-5 col-md-5 col-sm-12 col-xs-12">
                            <cf_box_elements>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">                                        
                                        <input type="checkbox" name="is_active" id="is_active" value="1" checked>
                                    </div>                              
                                </div>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='50938.Seller'></label>
                                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                        <div class="input-group">
                                            <div class="input-group_tooltip">Pazaryerinden aldığınız aşağıdaki bilgilerden birini giriniz. Seller ID, Client Key, Supplier Key, Client ID, Merchant ID, App ID, Supplier ID, Account Code</div>
                                            <cfinput type="text" name="seller" id="seller" value="#iif(getRelationCompany.recordcount gt 0,'getRelationCompany.seller',DE(''))#">
                                            <span class="input-group-addon icon-question input-group-tooltip"></span>
                                        </div>
                                    </div>                                    
                                </div>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'>-<cf_get_lang dictionary_id='44928.Key'></label>
                                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                        <div class="input-group">
                                            <div class="input-group_tooltip">Pazaryerinden aldığınız aşağıdaki bilgilerden birini giriniz. Secret Key, Autorization Key, Access  Code, Access Key, Client Key, Client Secret, Token, Auth Token için kullanılır.</div>
                                            <cf_duxi type="text"name="client_key" value="#iif(getRelationCompany.recordcount gt 0,'getRelationCompany.client_key',DE(''))#" gdpr="9">
                                            <span class="input-group-addon icon-question input-group-tooltip"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57930.User'></label>                                    
                                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                        <div class="input-group">
                                            <div class="input-group_tooltip">Pazaryerinden aldığınız aşağıdaki bilgilerden birini giriniz. E-mail, User Name yerine geçer</div>
                                            <cfinput type="text" name="user_name_mail" id="user_name_mail" value="#iif(getRelationCompany.recordcount gt 0,'getRelationCompany.user_name_mail',DE(''))#">
                                            <span class="input-group-addon icon-question input-group-tooltip"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group">
                                    <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='65274.Store URL'></label>
                                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                        <div class="input-group">
                                            <div class="input-group_tooltip">Mağazanın adresini giriniz.</div>
                                            <cfinput type="text" name="store_url" id="store_url" value="#iif(getRelationCompany.recordcount gt 0,'getRelationCompany.store_url',DE(''))#">
                                            <span class="input-group-addon icon-question input-group-tooltip"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group flex-end">
                                    <label class="col col-9 col-md-9 col-sm-9 col-xs-12 pull-right">
                                        <cf_get_lang dictionary_id='65275.Watalogy mağazasını kullanın'>
                                        <input type="checkbox" name="use_watalogy_store" id="use_watalogy_store" value="1" <cfif getRelationCompany.use_watalogy_store eq 1>checked</cfif>>
                                    </label>
                                </div>
                                <div class="col col-12 col-md-12 col-sm-12 col-xs-12 form-group flex-end">
                                    <a class="col col-9 col-md-9 col-sm-9 col-xs-12 pull-right" href="javascript://" onclick="openContract()" style="color:##ff0000">>><cf_get_lang dictionary_id='65276.?'></a>
                                </div>
                            </cf_box_elements> 
                        </div>                            
                    </div>
                    <div id="unique_categories" class="uniqueBox">
                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                            <cf_flat_list>
                                <thead>
                                    <tr><th><cf_get_lang dictionary_id='29736.Upper Category'></th></tr>
                                </thead>
                                <tbody id="upper_categories">
                                    
                                </tbody>
                            </cf_flat_list>
                        </div>                        
                    </div>                     
                    <div id="unique_products" class="uniqueBox">
                        Ürünler
                    </div>
                    <div id="unique_orders" class="uniqueBox">
                        Siparişler
                    </div>
                    <div id="unique_summer" class="uniqueBox">
                        Cari Hesap Özeti
                    </div>
                    <div id="unique_dashboard" class="uniqueBox">
                        Dashboard
                    </div>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                        <cf_box_footer>
                            <div>
                                <a href="javascript://" class="ui-wrk-btn ui-wrk-btn-success ui-wrk-btn-addon-left"><cf_get_lang dictionary_id='65323.Entegrasyonu Test Et'></a>
                            </div>
                            <cf_workcube_buttons data_action="V16/worknet/cfc/worknet_add_member:updateRelationWorknet" next_page="#request.self#?fuseaction=watalogy.marketplace&event=det&wid=" class="ui-wrk-btn ui-wrk-btn-red ui-wrk-btn-addon-left">
                        </cf_box_footer>
                    </div>                        
                </cf_tab>
            </div>
        </cfform>
    </cf_box>
</div>