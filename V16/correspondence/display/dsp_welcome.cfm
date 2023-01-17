<div class="pagemenus_container">
    <cfoutput>
        <ul class="pagemenus">
            <li><strong><cf_get_lang no='87.İK Talepleri'></strong>
                <ul>
                    <li><a href="#request.self#?fuseaction=correspondence.list_personel_requirement_form"><cf_get_lang no='88.Personel Talepleri'></a></li>
                    <li><a href="#request.self#?fuseaction=correspondence.from_add_personel_requirement_form"><cf_get_lang no='89.Personel Talebi Ekle'></a></li>
                    <li><a href="#request.self#?fuseaction=myhome.emp_app_select_list"><cf_get_lang no='90.İşe Alım Seçim Listeleri'></a></li>
                    <li><a href="#request.self#?fuseaction=myhome.list_personel_rotation_form"><cf_get_lang no='91.Terfi Transfer Talepleri'></a></li>
                    <li><a href="#request.self#?fuseaction=correspondence.add_personel_rotation_form"><cf_get_lang no='141.Terfi Transfer Talebi Ekle'></a></li>
                    <li><a href="#request.self#?fuseaction=myhome.detail_target_perfection"><cf_get_lang no='92.Hedef Yetkinlik Belirleme'></a></li>
                    <li><a href="#request.self#?fuseaction=myhome.list_perform"><cf_get_lang no='93.Çalışan Ölçme Değerlendirme'></a></li>
                </ul>
            </li>
        </ul>
        <cfif get_module_user(29)>
            <ul class="pagemenus">
                <li><strong><cf_get_lang no='96.Diğer Talepler'></strong>
                    <ul>
                        <li><a href="#request.self#?fuseaction=correspondence.list_internaldemand"><cf_get_lang no ='142.İç Talepler'></a></li>
                        <li><a href="#request.self#?fuseaction=correspondence.list_internaldemand&event=add"><cf_get_lang_main no='1386.İç Talep'></a></li>
                        <li><a href="#request.self#?fuseaction=correspondence.add_payment_actions&act_type=2&correspondence_info=1"><cf_get_lang no='72.Ödeme Talebi Ekle'></a></li>
                        <li><a href="#request.self#?fuseaction=correspondence.list_payment_actions&act_type=2&correspondence_info=1"><cf_get_lang no='5.Ödeme Talepleri'></a></li>
                        <li><a href="#request.self#?fuseaction=correspondence.add_assetp_demand"><cf_get_lang no='95.Fiziki Varlık Talebi'></a></li>
                        <cfif fusebox.use_period><li><a href="#request.self#?fuseaction=myhome.form_add_expense_plan_request"><cf_get_lang no='97.Masraf Talebi'></a></li></cfif>
                        <li><a href="#request.self#?fuseaction=correspondence.list_asset_failure"><cf_get_lang no='4.Arıza Bildirimleri'></a></li>
                    </ul>
                </li>
           </ul>
       </cfif>
       <cfif get_module_user(29)>
           <ul class="pagemenus">
                <li><strong><cf_get_lang no='98.Kurumsal Yazışmalar'></strong>
                    <ul>
                        <li><a href="#request.self#?fuseaction=correspondence.list_correspondence"><cf_get_lang_main no='47.Yazışmalar'></a></li>
                        <li><a href="#request.self#?fuseaction=correspondence.add_correspondence&to_mail_id=0"><cf_get_lang no='3.Yazışma Ekle'></a></li>
                    </ul>
                </li>
            </ul>
        </cfif>
        <cfif get_module_user(29)>
            <div style="float:left;">
                <ul class="pagemenus">
                    <li><strong><cf_get_lang_main no='1884.CubeMail'></strong>
                        <ul>
                            <li><a href="#request.self#?fuseaction=correspondence.cubemail"><cf_get_lang_main no='1884.CubeMail'></a></li>
                            <!--- BK İlgili link kaldirildi 90 gune kaldirilsin 20130717 <li><a href="#request.self#?fuseaction=correspondence.list_mymails"><cf_get_lang no='79.mail hesapları'></a></li> --->
                        </ul>
                    </li>
                </ul>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no='18.Exchange Server'></strong>
                        <ul>	
                            <li><a href="#request.self#?fuseaction=correspondence.exchangemail"><cf_get_lang no='260.Exchange Server Mail'></a></li>
                            <li><a href="#request.self#?fuseaction=correspondence.list_mymails_exchange"><cf_get_lang no='19.Exchange Server Ayarları'></a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </cfif>
    </cfoutput> 
</div>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
