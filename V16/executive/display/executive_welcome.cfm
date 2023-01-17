<cfinclude template="../../report/display/report_menu.cfm">
<div class="row">
	<div class="col col-12">
		<h3><cfoutput>#getLang('main',27)#</cfoutput></h3>
	</div>
</div>
   <cfoutput> 
    <div class="pagemenus_container">
        <ul class="pagemenus">
            <li><strong><cf_get_lang no='2.İK ve Üyeler'></strong>
                <ul>
                    <cfif not listfindnocase(denied_pages,'report.employee_analyse_report')><li><a href="#request.self#?fuseaction=report.employee_analyse_report"> <cf_get_lang_main no='1463.Çalışanlar'></a></li></cfif>
                    <li><a href="#request.self#?fuseaction=report.employee_salary_analyse_report"> <cf_get_lang no='4.Ücretler'></a></li>
                    <li><a href="#request.self#?fuseaction=report.perform_report"> <cf_get_lang no='5.Performans Değerlendirme'></a></li>
                    <li><a href="#request.self#?fuseaction=report.report_targets"> <cf_get_lang_main no='552.Hedefler'> </a></li>
                    <li><a href="#request.self#?fuseaction=report.system_login_logoff_report"> <cf_get_lang no='6.Sisteme Giriş Çıkış'> </a></li>
                    <li><a href="#request.self#?fuseaction=report.training_analyse_report"> <cf_get_lang_main no='7.Eğitim'> </a></li>
                    <li><a href="#request.self#?fuseaction=report.report_target_market"> <cf_get_lang no='7.Üye Segmentasyon'></a></li>
                    <li><a href="#request.self#?fuseaction=report.detayli_uye_analizi_raporu"> <cf_get_lang no='8.Üye Listeleme'></a></li>
                    <cfif not listfindnocase(denied_pages,'hr.draw_position_hierarchy')><li> <a href="#request.self#?fuseaction=hr.draw_position_hierarchy"><cf_get_lang no='9.Pozisyon Semasi'></a></li></cfif>
                </ul>
            </li>
        </ul>
        <cfif fusebox.use_period>
        <ul class="pagemenus">
            <li><strong><cf_get_lang no='10.Operasyonlar'></strong>
                <ul>
                    <li><a href="#request.self#?fuseaction=report.sale_analyse_report"> <cf_get_lang no='11.Satış Fatura Analizi'></a></li>
                    <li><a href="#request.self#?fuseaction=report.sale_analyse_report_orders"> <cf_get_lang no='12.Satış Sipariş Analizi'></a></li>
                    <li><a href="#request.self#?fuseaction=report.purchase_analyse_report"> <cf_get_lang no='13.Alış Fatura Analizi'></a></li>
                    <li><a href="#request.self#?fuseaction=report.purchase_analyse_report_orders"> <cf_get_lang no='14.Alış Sipariş Analizi'></a></li>
                    <li><a href="#request.self#?fuseaction=report.stock_analyse"> <cf_get_lang no='15.Stok Analizi'></a></li>
                    <li><a href="#request.self#?fuseaction=report.service_analyse_report"> <cf_get_lang no='16.Servis Analizi'></a></li>
                    <li><a href="#request.self#?fuseaction=report.system_analyse_report"> <cf_get_lang_main no='1420.Abone'></a></li>
                    <li><a href="#request.self#?fuseaction=report.ship_result_analyse_report"> <cf_get_lang no='17.Sevkiyat Analizi'></a></li>
                    <li><a href="#request.self#?fuseaction=report.agenda_rapor"> <cf_get_lang_main no='3.Ajanda'></a></li>
                    <li><a href="#request.self#?fuseaction=report.detail_visit_report"> <cf_get_lang no='18.Detaylı Ziyaret Raporu'></a></li>
                    <li><a href="#request.self#?fuseaction=report.etkilesim_rapor"> <cf_get_lang_main no='1317.Etkileşimler'></a></li>
                    <li><a href="#request.self#?fuseaction=report.pro_material_result"> <cf_get_lang no='19.Proje Aksiyonları'></a></li>
                    <li><a href="#request.self#?fuseaction=report.time_cost_report"> <cf_get_lang_main no='149.Zaman Harcamaları'></a></li>
                    <li><a href="#request.self#?fuseaction=report.bsc_company"> <cf_get_lang no='21.BSC'> </a></li>
                </ul>
            </li>
        </ul>
        <ul class="pagemenus">
            <li><strong><cf_get_lang_main no='30.Finans'></strong>
                <ul>
                    <li><a href="#request.self#?fuseaction=report.activity_summary"> <cf_get_lang_main no='509.Cari Faaliyet Özeti'></a></li>
                    <li><a href="#request.self#?fuseaction=report.compare_activity_summary"> <cf_get_lang no='22.Karşılaştırmalı Cari Faaliyet Özeti'></a></li>
                    <li><a href="#request.self#?fuseaction=report.risc_analys"> <cf_get_lang_main no='277.Risk'> </a></li>
                    <li><a href="#request.self#?fuseaction=report.mizan_raporu"> <cf_get_lang no='23.Mizan'> </a></li>
                    <li><a href="#request.self#?fuseaction=report.cost_analyse_report"> <cf_get_lang no='25.Masraf Analizi'></a></li>
                    <cfif not listfindnocase(denied_pages,'myhome.welcome_fa')><li> <a href="#request.self#?fuseaction=myhome.welcome_fa"> <cf_get_lang no='28.Finans Gündemi'></a></li></cfif>
                    <cfif not listfindnocase(denied_pages,'ch.list_duty_claim')><li><a href="#request.self#?fuseaction=ch.list_duty_claim"> <cf_get_lang_main no='2279.Borç Alacak Dökümü'></a></li></cfif>
                    <cfif not listfindnocase(denied_pages,'ch.list_revenue_collector')><li><a href="#request.self#?fuseaction=ch.list_duty_claim&money_info=2&is_submitted=1&from_rev_collecter"> <cf_get_lang no='30.Ödeme Takip'></a></li></cfif>
                    <cfif not listfindnocase(denied_pages,'finance.scenario')><li> <a href="#request.self#?fuseaction=finance.scenario&is_group_scenerio=1"> <cf_get_lang no='31.Grup Finans Senaryosu'></a></li></cfif>
                    <cfif not listfindnocase(denied_pages,'report.company_ekg') and fusebox.use_period><li> <a href="#request.self#?fuseaction=report.company_ekg"><cf_get_lang_main no='571.EKG'></a></li></cfif>
                </ul>
            </li>
        </ul>
        </cfif>
    </div>
</cfoutput>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
