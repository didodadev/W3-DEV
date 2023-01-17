
<cf_box>
    <cf_box_elements>
    <cfoutput>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12 ">
            <ul class="ui-list_type2">
                <li>
                    <div class="ui-list-left">
                        <img src="css/assets/icons/catalyst-icon-svg/ctl-briefcase.svg" width="50px" height="80px">
                        
                    </div>
                    <div class="ui-info-text">
                        <cfif get_module_user(52)>
                        <ul>
                            <a href="#request.self#?fuseaction=crm.welcome"><strong><cf_get_lang no='186.Müşteri Bilgi Yönetimi'></strong></a>
                        </ul>
                        <ul>
                            <li><a href="#request.self#?fuseaction=crm.form_search_company"><cf_get_lang no='289.Müşteri Ara'></a></li>
                            <li><a href="#request.self#?fuseaction=crm.form_add_company"><cf_get_lang no='183.Müşteri Ekle'></a></li>
                            <li><a href="#request.self#?fuseaction=crm.list_supplier"><cf_get_lang_main no='1731.Tedarikçiler'></a></li>
                            <li><a href="#request.self#?fuseaction=crm.form_add_supplier&event=add"><cf_get_lang no='534.Tedarikçi Ekle'></a></li>
                            <li><a href="#request.self#?fuseaction=crm.my_buyers"><cf_get_lang dictionary_id='30762.My Customers'></a></li>
                            <li><a href="#request.self#?fuseaction=crm.detail_search"><cf_get_lang no='182.Detaylı Müşteri Arama'></a></li>
                          </ul>
                        </cfif>
                    </div>
                </li>
            </ul>
        </div>    
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12 ">
            <ul class="ui-list_type2">
                <li>
                    <div class="ui-list-left">
                        <img src="css/assets/icons/catalyst-icon-svg/ctl-network.svg" width="50px" height="80px">
                        
                    </div>
                    <div class="ui-info-text">
                        <cfif get_module_user(52)>
                        <ul>
                            <a href="#request.self#?fuseaction=crm.list_visit"><strong><cf_get_lang no='483.Ziyaret Yönetimi'></strong></a>
                        </ul>
                        <ul>
                            <li><a href="#request.self#?fuseaction=crm.form_add_visit_daily"><cf_get_lang no='778.Günlük Ziyaret Girişi'></a></li>
                            <li><a href="#request.self#?fuseaction=crm.form_add_visit"><cf_get_lang no='535.Ziyaret Planla'></a></li>
                            <li><a href="#request.self#?fuseaction=crm.list_visit"><cf_get_lang no='536.Ziyaretlerim'></a></li>
                            <li><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=crm.popup_add_visit');"><cf_get_lang no='537.Plansız Ziyaret Ekle'></a></li>
                            <li><a href="#request.self#?fuseaction=report.detail_report&event=det&report_id=3451"><cf_get_lang no='538.Detaylı Ziyaret Raporu'></a></li>
                        </ul>
                    </cfif>
                    </div>
                </li>
            </ul>
        </div> 
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12 ">
            <ul class="ui-list_type2">
                <li>
                    <div class="ui-list-left">
                        <img src="css/assets/icons/catalyst-icon-svg/ctl-crm.svg" width="50px" height="80px">
                        
                    </div>
                    <div class="ui-info-text">
                        <cfif get_module_user(52)>
                            <ul>
                                <a href="#request.self#?fuseaction=crm.list_risk_request"><strong><cf_get_lang no='547.Risk Yönetimi'></strong></a>
                            </ul>
                       
                            <ul>
                                <li><a href="#request.self#?fuseaction=crm.list_risk_request"><cf_get_lang no='547.Risk Yönetimi'></a></li>
                                <li><a href="#request.self#?fuseaction=crm.list_company_securefund"><cf_get_lang no='552.Teminat Yönetimi'></a></li>
                                <li><a href="#request.self#?fuseaction=crm.list_sales_request"><cf_get_lang no='553.Satışa Açma Talebi'></a></li>
                                <li><a href="#request.self#?fuseaction=crm.list_sales_close_request"><cf_get_lang no='554.Satışa Kapama Talebi'></a></li>
                                <li><a href="#request.self#?fuseaction=crm.list_law_request"><cf_get_lang no='555.Avukata Verme Talebi'></a></li>
                                <li><a href="#request.self#?fuseaction=crm.list_postpone_debit"><cf_get_lang no='741.Borç Erteleme Talebi'></a></li>
                            </ul>
                        </cfif>
                    </div>
                </li>
            </ul>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12 ">
            <ul class="ui-list_type2">
                <li>
                    <div class="ui-list-left">
                        <img src="css/assets/icons/catalyst-icon-svg/ctl-bars-graphic.svg" width="50px" height="80px">
                    </div>
                    <div class="ui-info-text">
                        <cfif get_module_user(33)>
                            <ul>
                                <a href="#request.self#?fuseaction=report.welcome"><strong><cf_get_lang no='549.Analitik Raporlar'></strong></a>
                            </ul>
                       
                            <ul>
                                <li><a href="#request.self#?fuseaction=report.welcome"><cf_get_lang no='558.Raporları Göster'></a></li>
                            </ul>
                        </cfif>
                    </div>
                </li>
            </ul>
        </div>
    </cfoutput>
    </cf_box_elements>

    <cf_box_elements>
    <cfoutput>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" >
            <ul class="ui-list_type2">
                <li>
                    <div class="ui-list-left">
                        <img src="css/assets/icons/catalyst-icon-svg/ctl-protest.svg" width="50px" height="80px">
                    </div>
                    <div class="ui-info-text">
                        <cfif get_module_user(52)>
                            <ul>
                                <a href="#request.self#?fuseaction=crm.list_activities"><strong><cf_get_lang no='488.Etkinlik Yönetimi'></strong></a>
                            </ul>
                       
                            <ul>
                                <li><a href="#request.self#?fuseaction=crm.form_add_activity"><cf_get_lang no='322.Etkinlik Planla'></a></li>
                                <li><a href="#request.self#?fuseaction=crm.list_activities"><cf_get_lang no='539.Etkinliklerim'></a></li>
                                <li><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=crm.popup_activity_info');"><cf_get_lang no='540.Plansız Etkinlik Ekle'></a></li>
                                <li><a href="#request.self#?fuseaction=report.detail_report&event=det&report_id=1641"><cf_get_lang no='541.Detaylı Etkinlik Raporu'></a></li>
                            </ul>
                        </cfif>
                    </div>
                </li>
            </ul>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" >
            <ul class="ui-list_type2">
                <li>
                    <div class="ui-list-left">
                        <img src="css/assets/icons/catalyst-icon-svg/ctl-weekly-calendar.svg" width="50px" height="80px">
                    </div>
                    <div class="ui-info-text">
                        <cfif get_module_user(6)>
                        <ul>
                            <a href="#request.self#?fuseaction=agenda.view_daily"><strong><cf_get_lang no='133.Ajanda Yönetimi'></strong></a>
                        </ul>
                        
                            <ul>
                                <li><a href="#request.self#?fuseaction=agenda.view_daily&event=add"><cf_get_lang no='542.Konu Ekle'></a></li>
                                <li><a href="#request.self#?fuseaction=agenda.view_daily"><cf_get_lang no='543.Günlük Göster'></a></li>
                                <li><a href="#request.self#?fuseaction=agenda.view_daily"><cf_get_lang no='544.Haftalık Göster'></a></li>
                                <li><a href="#request.self#?fuseaction=agenda.view_daily"><cf_get_lang no='545.Aylık Göster'></a></li>
                            </ul>
                   
                        </cfif>
                    </div>
                </li>
            </ul>
        </div>
        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" >
            <ul class="ui-list_type2">
                <li>
                    <div class="ui-list-left">
                        <img src="css/assets/icons/catalyst-icon-svg/ctl-chatting.svg" width="50px" height="80px">
                    </div>
                    <div class="ui-info-text">
                        <cfif get_module_user(52)>
                        <ul>
                            <a href="#request.self#?fuseaction=correspondence.welcome"><strong><cf_get_lang no='548.İletişim Yönetimi'></strong></a>
                        </ul>
                        <ul>
                            <li><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=correspondence.addressbook');"><cf_get_lang_main no='17.Adres Defteri'></a></li>
                            <li><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_add_nott');"><cf_get_lang_main no='53.Not Ekle'></a></li>
                            <li><a href="#request.self#?fuseaction=member.list_analysis"><cf_get_lang_main no='535.Anketler'></a></li>
                            <li><a href="#request.self#?fuseaction=correspondence.list_correspondence"><cf_get_lang no='556.Yazışmalarım'></a></li>
                            <li><a href="#request.self#?fuseaction=correspondence.list_correspondence&event=add"><cf_get_lang no='557.Yazışma Ekle'></a></li>
                            <li><a href="#request.self#?fuseaction=forum.list_forum"><cf_get_lang_main no='9.Forum'></a></li>
                        </ul>
                        </cfif>
                    </div>
                </li>
            </ul>
        </div>
    
    </cfoutput>
    </cf_box_elements>

    <cf_box_elements>
    <cfoutput>
    <div class="col col-2 col-md-3 col-sm-4 col-xs-12" >
        <ul class="ui-list_type2 mx-2">
            <li>
                <div class="ui-list-left">
                    <img src="css/assets/icons/catalyst-icon-svg/ctl-school-material.svg" width="30px" height="40px">
                </div>
                <div class="ui-info-text">
                    <ul>
                        <a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=myhome.popup_dsp_user_guides');"> <cf_get_lang no='559.Kullanıcı Dökümanları'></a>
                    </ul>
                </div>
            </li>
        </ul>
    </div>
    <div class="col col-2 col-md-3 col-sm-4 col-xs-12" >
        <ul class="ui-list_type2 mx-2">
            <li>
                <div class="ui-list-left">
                    <img src="css/assets/icons/catalyst-icon-svg/ctl-018-monitor.svg" width="30px" height="40px">
                </div>
                <div class="ui-info-text">
                    <ul>
                        <a href="mailto:workcube@hedefalliance.com.tr;"> <cf_get_lang no='560.Sistem Yöneticisi'></a>
                    </ul>
                </div>
            </li>
         </ul>
    </div>
</cfoutput>
    </cf_box_elements>
</cf_box>

<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
