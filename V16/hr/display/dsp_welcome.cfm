<cfoutput> 
    <div class="pagemenus_container">
    	<div style="float:left;">
			<cfif get_module_user(48)>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang dictionary_id='57654.E Hesap'></strong>
                        <ul>
                            <li><a href="#request.self#?fuseaction=ehesap.list_puantaj"><cf_get_lang dictionary_id='58650.Puantaj'></a></li>
                            <li><a href="#request.self#?fuseaction=ehesap.list_salary"><cf_get_lang dictionary_id='56118.Ücret Ödenek'></a></li>
                            <li><a href="#request.self#?fuseaction=ehesap.list_dynamic_bordro"><cf_get_lang dictionary_id='50206.Bordro'></a></li>
                            <li><a href="#request.self#?fuseaction=ehesap.offtimes"><cf_get_lang dictionary_id='55143.İzinler'></a></li>
                            <li><a href="#request.self#?fuseaction=ehesap.list_ssk_xml_export"><cf_get_lang dictionary_id='56301.Bildirimler'></a></li>
                            <li><a href="#request.self#?fuseaction=ehesap.list_fire"><cf_get_lang dictionary_id='56122.Giriş Çıkış'></a></li>
                            <!--- <li><a href="#request.self#?fuseaction=ehesap.offtimes"><cf_get_lang no='58.İzinler'></a></li> --->
                            <li><a href="#request.self#?fuseaction=ehesap.list_visited_relative"><cf_get_lang dictionary_id='58156.Diğer'></a></li>
                            <cfif session.ep.ehesap><li><a href="#request.self#?fuseaction=ehesap.definition"><cf_get_lang dictionary_id='57529.Tanımlar'></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
            <div class="pagemenus_clear"></div>
            <ul class="pagemenus">
                <li><strong><cf_get_lang_main no='711.planlama'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'hr.list_positions')><li><a href="#request.self#?fuseaction=hr.list_positions"><cf_get_lang dictionary_id='55162.pozisyonlar'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.form_add_position')><li><a href="#request.self#?fuseaction=hr.list_positions&event=add"><cf_get_lang dictionary_id='55163.Pozisyon Ekle'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.form_add_position_cat')><li><a href="#request.self#?fuseaction=hr.form_add_position_cat"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_standby')><li><a href="#request.self#?fuseaction=hr.list_standby"><cf_get_lang dictionary_id='56112.Amirler ve Yedekler'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_titles')><li><a href="#request.self#?fuseaction=hr.list_titles"><cf_get_lang dictionary_id='55168.Ünvanlar'></a></li></cfif>	
                        <cfif not listfindnocase(denied_pages,'hr.list_contents')><li><a href="#request.self#?fuseaction=hr.list_contents"><cf_get_lang dictionary_id='55169.Yetki ve Sorumluluklar'></a></li></cfif>	
                        <cfif not listfindnocase(denied_pages,'hr.list_norm_positions')><li><a href="#request.self#?fuseaction=hr.list_norm_positions"><cf_get_lang dictionary_id='55211.norm kadrolar'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_norm_staff_minus')><li><a href="#request.self#?fuseaction=hr.list_norm_staff_minus"><cf_get_lang dictionary_id='55093.Norm Kadro Eksik / Fazlalıkları'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_position_req_type')><li><a href="#request.self#?fuseaction=hr.list_position_req_type"><cf_get_lang dictionary_id='55214.Yeterlilik Tanımları'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_requirement_types')><li><a href="#request.self#?fuseaction=hr.list_requirement_types"><cf_get_lang dictionary_id='55210.Yeterliliklere Uygun Çalışan Seçimi'></a></li></cfif>
                    </ul>
                </li>
            </ul>
            <div class="pagemenus_clear"></div>
            <ul class="pagemenus">
                <li><strong><cf_get_lang no='119.İş Sağlığı ve Güvenliği'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'hr.list_employee_healty_all')><li><a href="#request.self#?fuseaction=hr.list_employee_healty_all"><cf_get_lang dictionary_id="32167.Sağlık İşlemleri"></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_inventory_zimmet')><li><a href="#request.self#?fuseaction=hr.list_inventory_zimmet"><cf_get_lang dictionary_id="53011.Zimmetler"></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_audits')><li><a href="#request.self#?fuseaction=hr.list_audits"><cf_get_lang dictionary_id="53094.Denetim İşlemleri"></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'objects.popup_list_templates')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_templates&module=3&assetcat_id=8','medium');"> <cf_get_lang dictionary_id="32171.Ek Formlar"></a></li></cfif>
                    </ul>
                </li>
            </ul>
        </div>
        <div style="float:left;">
            <ul class="pagemenus">
                <li><strong><cf_get_lang dictionary_id='57996.Ise Alim'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'hr.form_add_emp')><li><a href="#request.self#?fuseaction=hr.list_hr&event=add"><cf_get_lang dictionary_id='55170.çalısan ekle'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.form_add_cv')><li><a href="#request.self#?fuseaction=hr.form_add_cv"><cf_get_lang dictionary_id='56038.CV Kayıt'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr..list_cv')><li><a href="#request.self#?fuseaction=hr.list_cv"><cf_get_lang dictionary_id='56039.CV Bank'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.apps')><li><a href="#request.self#?fuseaction=hr.apps"><cf_get_lang dictionary_id='58186.basvurular'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.search_app')><li><a href="#request.self#?fuseaction=hr.search_app"><cf_get_lang dictionary_id='55173.basvuru ara'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_notice')><li><a href="#request.self#?fuseaction=hr.list_notice"><cf_get_lang dictionary_id='35242.ilanlar'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.form_add_notice')><li><a href="#request.self#?fuseaction=hr.list_notice&event=add"><cf_get_lang dictionary_id='55175.ilan ekle'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_orientation')><li><a href="#request.self#?fuseaction=hr.list_orientation"><cf_get_lang dictionary_id='55213.oryantasyo egitimleri'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.emp_app_select_list')><li><a href="#request.self#?fuseaction=hr.emp_app_select_list"><cf_get_lang dictionary_id='56037.Seçim Listesi'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_personel_rotation_form')><li><a href="#request.self#?fuseaction=hr.list_personel_rotation_form"><cf_get_lang dictionary_id ='56302.Terfi-Transfer-Rotasyon Talep Formu'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_personel_requirement_form')><li><a href="#request.self#?fuseaction=hr.list_personel_requirement_form"><cf_get_lang dictionary_id='56114.Personel Talepleri'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_personel_assign_form')><li><a href="#request.self#?fuseaction=hr.list_personel_assign_form"><cf_get_lang dictionary_id ='55632.Atama Formları'></a></li></cfif>
                    </ul>
                </li>
            </ul>
            <div class="pagemenus_clear"></div>
            <ul class="pagemenus">
                <li><strong><cf_get_lang_main no='591.performans'></strong>
                    <ul>
                        <!--- <cfif not listfindnocase(denied_pages,'hr.list_perform')><li><a href="#request.self#?fuseaction=hr.list_perform"><cf_get_lang no='683.ölçme değerlendirmeler'></a></li></cfif> --->
                        <cfif not listfindnocase(denied_pages,'hr.list_performance_forms')><li><a href="#request.self#?fuseaction=hr.list_performance_forms"><cf_get_lang dictionary_id='55105.Performans Formu'></a></li></cfif>
                        <!---<cfif not listfindnocase(denied_pages,'hr.list_out_employees')><li><a href="#request.self#?fuseaction=hr.list_out_employees"><cf_get_lang no='127.mülakatlar'></a></li></cfif>
                         <cfif not listfindnocase(denied_pages,'hr.list_quizs')><li><a href="#request.self#?fuseaction=hr.list_quizs"><cf_get_lang_main no='1971.Formlar'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.form_add_quiz')><li><a href="#request.self#?fuseaction=hr.form_add_quiz"><cf_get_lang no='100.Form Ekle'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.form_add_app_quiz')><li><a href="#request.self#?fuseaction=hr.form_add_app_quiz"><cf_get_lang no='1218.Mülakat D Formu Ekle'></a></li></cfif> 
                        <cfif not listfindnocase(denied_pages,'hr.list_timecost')><li><a href="#request.self#?fuseaction=report.time_cost_report"><cf_get_lang no='93.Zaman Yönetimi'></a></li></cfif>--->
                        <cfif not listfindnocase(denied_pages,'hr.targets')><li><a href="#request.self#?fuseaction=hr.targets"><cf_get_lang dictionary_id='57964.Hedefler'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_target_cat')><li><a href="#request.self#?fuseaction=hr.list_target_cat"><cf_get_lang dictionary_id='56304.Hedef Kategorileri'></a></li></cfif>
                        <cfif workcube_mode neq 1>
                            <cfif not listfindnocase(denied_pages,'hr.list_total_performances')><li><a href="#request.self#?fuseaction=hr.list_total_performances"><cf_get_lang dictionary_id='55183.performanslar'></a></li></cfif>
                            <!--- <cfif not listfindnocase(denied_pages,'hr.list_stand_meet_form')><li><a href="#request.self#?fuseaction=hr.list_stand_meet_form"><cf_get_lang no ='1241.Standart Performans'></a></li></cfif> ---><!--- //SG20121005 --->
                            <cfif not listfindnocase(denied_pages,'hr.list_target_perf')><li><a href="#request.self#?fuseaction=hr.list_target_perf"><cf_get_lang dictionary_id ='56668.Hedef Yetkinlik'></a></li></cfif>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_detail_survey_report')><li><a href="#request.self#?fuseaction=hr.list_detail_survey_report_perf&action_type=8"><cf_get_lang dictionary_id='29768.Formlar'></a></li></cfif>
                    </ul>
                </li>
            </ul>
            <div class="pagemenus_clear"></div>
            <ul class="pagemenus">
                <li><strong><cf_get_lang dictionary_id='58009.PDKS'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'hr.list_emp_pdks')><li><a href="#request.self#?fuseaction=hr.list_emp_pdks"><cf_get_lang dictionary_id='56556.PDKS Durumları'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_emp_daily_in_out_row')><li><a href="#request.self#?fuseaction=hr.list_emp_daily_in_out_row"><cf_get_lang dictionary_id='29494.PDKS Listesi'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_emp_daily_in_out')><li><a href="#request.self#?fuseaction=hr.list_emp_daily_in_out"><cf_get_lang dictionary_id ='56561.PDKS Import'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.popup_emp_daily_in_out_shift')><li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_emp_daily_in_out_shift','list','popup_emp_daily_in_out_shift')"><cf_get_lang dictionary_id='58574.PDKS Vardiyalar'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.branch_pdks_table')><li><a href="#request.self#?fuseaction=hr.branch_pdks_table"><cf_get_lang dictionary_id='55674.Şube Bazında PDKS'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.shift_hesapla')><li><a href="#request.self#?fuseaction=hr.shift_hesapla"><cf_get_lang dictionary_id='55095.Vardiya Hesaplama'></a></li></cfif> <!--- | Vardiya Hesapla Linki | --->
                    </ul>
                </li>
            </ul>
        </div>
        <div style="float:left;">
            <ul class="pagemenus">
                <li><strong><cf_get_lang_main no='560.organizasyon'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'hr.list_headquarters')><li><a href="#request.self#?fuseaction=hr.list_headquarters&hr=1"><cf_get_lang dictionary_id='56297.Üst Düzey Birimler'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.company_info_list')><li><a href="#request.self#?fuseaction=hr.company_info_list"><cf_get_lang dictionary_id='29531.şirket bilgileri'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_zones')><li><a href="#request.self#?fuseaction=hr.list_zones"><cf_get_lang dictionary_id='55188.bölgeler'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_branches')><li><a href="#request.self#?fuseaction=hr.list_branches"><cf_get_lang_main dictionary_id='29434.şubeler'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_depts')><li><a href="#request.self#?fuseaction=hr.list_depts"><cf_get_lang dictionary_id='55190.departmanlar'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_workgroup')><li><a href="#request.self#?fuseaction=hr.list_workgroup"><cf_get_lang dictionary_id='29818.iş grupları'></a></li></cfif>
                        <li><a href="#request.self#?fuseaction=salesplan.list_sales_team"><cf_get_lang dictionary_id ='57803.Satış Takımları'></a></li>
                    </ul>
                </li>
            </ul>
            <div class="pagemenus_clear"></div>
            <ul class="pagemenus">
                <li><strong><cf_get_lang dictionary_id='58005.Şemalar'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'hr.organization_schema_group')><li><a href="#request.self#?fuseaction=hr.organization_schema_group"><cf_get_lang dictionary_id='56115.Grup Başkanlıkları'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.organization_schema')><li><a href="#request.self#?fuseaction=hr.organization_schema"><cf_get_lang dictionary_id='55188.bölgeler'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.organization_schema_comp')><li><a href="#request.self#?fuseaction=hr.organization_schema_comp"><cf_get_lang dictionary_id='29531.Şirketler'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.organization_schema_work_group')><li><a href="#request.self#?fuseaction=hr.organization_schema_work"><cf_get_lang dictionary_id='29818.iş grupları'></a></li></cfif>
                        <!--- <cfif not listfindnocase(denied_pages,'hr.draw_position_hierarchy')><li><a href="#request.self#?fuseaction=hr.draw_position_hierarchy"><cf_get_lang_main no ='1014.Şema Tasarımcısı'></a></li></cfif> 
                        <li><a href="#request.self#?fuseaction=hr.draw_organization_hierarchy"><cf_get_lang no ='1306.Organizasyon Şemacısı'></a></li>--->
						<li><a href="#request.self#?fuseaction=hr.dsp_simulation_schema"><cf_get_lang dictionary_id ='56379.Organizasyon Simülatörü'></a></li>
                        <cfif not listfindnocase(denied_pages,'hr.organization_schema_designer')>
							<li><a href="#request.self#?fuseaction=hr.organization_schema_designer" ><cf_get_lang dictionary_id ='33740.Organizasyon Görsel Tasarımcısı'></a></li>
						</cfif>
                    </ul>
                </li>
            </ul>
            <cfif not listfindnocase(denied_pages,'hr.ozlukucret')>
            	<div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang dictionary_id='56116.Özlük-Ücret'></strong>
                        <ul>
                            <cfif not listfindnocase(denied_pages,'hr.list_salary')><li><a href="#request.self#?fuseaction=hr.list_salary"><cf_get_lang dictionary_id='56118.Ücret Ödenek'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'hr.list_payment_requests')><li><a href="#request.self#?fuseaction=hr.list_payment_requests"><cf_get_lang dictionary_id='56119.Avans Talepleri'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'hr.list_payments')><li><a href="#request.self#?fuseaction=hr.list_payments"><cf_get_lang dictionary_id='32127.Ödenek Listesi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'hr.list_ext_worktimes')><li><a href="#request.self#?fuseaction=hr.list_ext_worktimes"><cf_get_lang dictionary_id='56018.Fazla Mesailer'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'hr.list_interruption')><li><a href="#request.self#?fuseaction=hr.list_interruption"><cf_get_lang dictionary_id='56023.Kesintiler'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'hr.list_visited')><li><a href="#request.self#?fuseaction=hr.list_visited"><cf_get_lang dictionary_id='56026.Çalışan Viziteler'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'hr.list_visited_relative')><li><a href="#request.self#?fuseaction=hr.list_visited_relative"><cf_get_lang dictionary_id='56244.Çalışan Yakını Viziteler'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'hr.list_emp_rel_healty')><li><a href="#request.self#?fuseaction=hr.list_emp_rel_healty"><cf_get_lang dictionary_id='53174.Eş Çocuk Sağlık Belgesi'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'hr.list_icmal_personal')><li><a href="#request.self#?fuseaction=hr.list_icmal_personal"><cf_get_lang dictionary_id='56121.Kişi İcmal'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'hr.list_icmal')><li><a href="#request.self#?fuseaction=hr.list_icmal"><cf_get_lang dictionary_id='58584.İcmal'></a></li></cfif>
                            <cfif not listfindnocase(denied_pages,'hr.list_fire')><li><a href="#request.self#?fuseaction=hr.list_fire"><cf_get_lang dictionary_id='56122.Giriş-Çıkış'></a></li></cfif>
                        </ul>
                    </li>
                </ul>
            </cfif>
        </div>
    </div>
</cfoutput> 
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
