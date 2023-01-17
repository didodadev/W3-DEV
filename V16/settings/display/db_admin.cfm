<table class="dph">
    <tr>
        <td class="dpht"><cf_get_lang no='1478.Dönem ve Bakım İşlemleri'></td>
    </tr>
</table>
<cfoutput> 
    <div class="pagemenus_container">
    	<cfif session.ep.admin eq 1>
            <div style="float:left;">
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no='338.Dönem Başı İşlemleri'></strong>
                        <ul>
							<li><a href="#request.self#?fuseaction=settings.form_add_period"><cf_get_lang no='499.Muhasebe Dönemi Ekle'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.employee_period_transfer"><cf_get_lang no='1549.Çalışan Dönem Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.employee_period_transfer_all"><cf_get_lang no='1549.Çalışan Dönem Aktarım'> (<cf_get_lang_main no='576.Geçişli'>)</a></li>
                            <li><a href="#request.self#?fuseaction=settings.money_period_transfer"> <cf_get_lang_main no="77.Para Birimi"> <cf_get_lang no="1548.Aktarım"></a></li>
                            <li><a href="#request.self#?fuseaction=settings.company_period_transfer"><cf_get_lang no='2070.Kurumsal Üye Dönem Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.company_period_transfer_all"><cf_get_lang no='2070.Kurumsal Üye Dönem Aktarım'> (<cf_get_lang_main no='576.Geçişli'>)</a></li>
                            <li><a href="#request.self#?fuseaction=settings.consumer_period_transfer"><cf_get_lang no='1562.Bireysel Üye Dönem Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.consumer_period_transfer&is_transfer_all=1"><cf_get_lang no='1562.Bireysel Üye Dönem Aktarım'> (<cf_get_lang_main no='576.Geçişli'>)</a></li>
                            <li><a href="#request.self#?fuseaction=settings.tax_rate_transfer"><cf_get_lang no='24.KDV Oranı Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.withholding_tax_rate_transfer"><cf_get_lang no='27.Stopaj Oranı Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.product_period_transfer"><cf_get_lang no='1553.Ürün Dönem Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.project_period_transfer"><cf_get_lang no='1554.Proje Dönem Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.location_period_transfer"><cf_get_lang no='28.Depo Dönem Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.cash_transfer"><cf_get_lang no='1783.Kasa Aktarim'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.expense_item_plans_transfer"><cf_get_lang no='1560.Bütçe Kal-Bütçe Kat-Masraf Merk Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.employee_account_transfer_all"><cf_get_lang no='32.Çalışan Muhasebe Tanım Aktarım'></a></li>
                            <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_form_close_cari','wide');"><cf_get_lang no='1555.Kurumsal Üye Dönem Açılışı'></a></li>
                            <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_form_close_cari&is_consumer=1','wide');"><cf_get_lang no='1556.Bireysel Üye Dönem Açılışı'></a></li>
                            <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_form_close_cari&is_employee=1','wide');"><cf_get_lang no='344.Çalışan Dönem Açılışı'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.form_cheque_copy"><cf_get_lang no='1589.Çek Dönem Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.form_voucher_copy"><cf_get_lang no='1594.Senet Dönem Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.endorsement_cheque_copy"><cf_get_lang no='1595.Ciro Çekleri Dönem Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.endorsement_voucher_copy"><cf_get_lang no='1630.Ciro Senetleri Dönem Aktarım'></a></li>
                            <li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=bank.popup_form_bank_order_copy','small');"><cf_get_lang no='366.Banka Talimatları Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.stock_transfer"><cf_get_lang no='1563.Stok Devir Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.stock_age_transfer"><cf_get_lang no='1564.Stok Yaşı Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.consignment_transfer"><cf_get_lang no='30.Konsinye Aktarım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.financial_tables_transfer"><cf_get_lang_main no='118.Mali Tablolar'><cf_get_lang no='1548.Aktarım'></a></li>
                       		<cfif isdefined("is_gov_payroll") and is_gov_payroll eq 1>
                            	<li><a href="#request.self#?fuseaction=settings.employee_rank_transfer_all">Çalışan Derece-Kademe Aktarım</a></li>
							</cfif>
                            <li><a href="#request.self#?fuseaction=settings.workstations_account_transfer">Üretim İstasyon Masraf Merkezi <cf_get_lang no='1548.Aktarım'></a></li>
					    </ul>
                    </li>
                </ul>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no='1569.Muhasebe Devir İşlemleri'></strong>
                        <ul>
                            <li><a href="#request.self#?fuseaction=settings.form_muhasebe_devir"><cf_get_lang no='370.Muhasebe Dönem Açılış Fişi'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.form_add_acc_close_card"><cf_get_lang no='2563.Muhasebe Dönem Kapanış Fişi'></a></li>
                        </ul>
                    </li>
                </ul>
            </div>
            <div style="float:left;">
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no='397.Muhasebe Bakım'></strong>
                        <ul>
                            <li><a href="#request.self#?fuseaction=settings.control_acc_card_list"><cf_get_lang no ='2172.Hesap Planında Olmayıp Hareket Gören Hesaplar'></a></li>
                            <li><a href="#request.self#?fuseaction=report.borc_alacak_tutmayanlar"><cf_get_lang no ='2872.Borç Alacak Tutmayan Muhasebe Fişleri'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.check_account_code"><cf_get_lang no ='1357.Hesap Kontrol Raporu'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.bills_without_action"><cf_get_lang no ='1366.İşlemi Olmayan Muhasebe Fişleri'></a></li>
                        </ul>
                    </li>
                </ul>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no='1565.Bütçe ve Masraf Bakım'></strong>
                        <ul>
                            <li><a href="#request.self#?fuseaction=settings.upd_budget"><cf_get_lang no='1566.Bütçe Dağılım'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.close_invoice"><cf_get_lang no="888.Fatura Kapama"></a></li>
                        </ul>
                    </li>
                </ul>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus" style="width:auto;">
                    <li><strong><cf_get_lang no='1567.Ürün ve Stok Bakım'></strong>
                        <ul>
                            <li><a href="#request.self#?fuseaction=settings.add_new_cost"><cf_get_lang no='1568.Yeniden Maliyet Oluşturma'> (<cf_get_lang no ='2173.Belgelerden'> - <cf_get_lang no='117.Ağırlıklı Ortalama'>)</a></li>
                            <li><a href="#request.self#?fuseaction=settings.add_new_cost&is_fifo=1"><cf_get_lang no='1568.Yeniden Maliyet Oluşturma'> (<cf_get_lang no ='2173.Belgelerden'> - <cf_get_lang no='210.İlk Giren İlk Çıkar'>)</a></li>
                            <li><a href="#request.self#?fuseaction=settings.add_new_cost_price"><cf_get_lang no='1568.Yeniden Maliyet Oluşturma'> (<cf_get_lang no ='2174.Fiyatlardan'>)</a></li>
                            <li><a href="#request.self#?fuseaction=settings.add_new_cost_excel"><cf_get_lang no='1568.Yeniden Maliyet Oluşturma'> ( <cf_get_lang_main no="1934.Excel"> ) </a></li>
                            <li><a href="#request.self#?fuseaction=settings.list_product_cost_txt"><cf_get_lang no="896.Maliyet(txt)"></a></li>
                            <li><a href="#request.self#?fuseaction=settings.stock_action_without_record">Belgesi Olmayan Stok Hareketleri</a></li>
                            <li><a href="#request.self#?fuseaction=report.list_nondispatch_related_bills_record">Fatura Kaydı Olmayan İlişkili İrsaliyeler</a></li>

                        </ul>
                    </li>
                </ul>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no='1580.İşlem Kategorileri Aktarım İşlemi'></strong>
                        <ul>
                            <li><a href="#request.self#?fuseaction=settings.transfer_process_cat"><cf_get_lang no='1580.İşlem Kategorileri Aktarım İşlemi'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.all_categories_position_authority"><cf_get_lang no='177.İşlem Kategorileri'><cf_get_lang no='1551.Toplu Yetki'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.all_g_service_appcat_position_authority"><cf_get_lang no='939.Şikayet Kategorileri'><cf_get_lang no='1551.Toplu Yetki'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.all_process_position_authority"><cf_get_lang no='1266.Süreçler'><cf_get_lang no='1551.Toplu Yetki'></a></li>
                        </ul>
                    </li>
                </ul>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no='73.Basket Aktarım'></strong>
                        <ul>
                            <li><a href="#request.self#?fuseaction=settings.transfer_basket_row"><cf_get_lang no='73.Basket Aktarım'></a>
                        </ul>
                    </li>
                </ul>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no='398.İleri Seviye Kümelatif Rapor'></strong>
                        <ul>
                            <li><a href="#request.self#?fuseaction=settings.advanced_cumulative_reports_categories"><cf_get_lang no='400.Rapor Kümülasyonları'></a></li>
                        </ul>
                    </li>
                </ul>
                <div class="pagemenus_clear"></div>
                <ul class="pagemenus">
                    <li><strong><cf_get_lang no='2875.Sistem Bakım'></strong>
                        <ul>
                            <li><a href="#request.self#?fuseaction=settings.create_main_views"><cf_get_lang no='12.Main Viewleri Raporu'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.create_company_views"><cf_get_lang no='2873.Şirket Viewleri Raporu'></a></li>
                            <li><a href="#request.self#?fuseaction=settings.create_period_views"><cf_get_lang no='2874.Dönem Viewleri Raporu'></a></li>
							<li><a href="#request.self#?fuseaction=settings.create_product_views">Product View Raporu</a></li>
                        </ul>
                    </li>
                </ul>
                <cfif session.ep.username eq 'barbaros'>
                    <div class="pagemenus_clear"></div>
                    <ul class="pagemenus">
                        <li><strong><cf_get_lang no='2876.Workcube Upgrade'></strong>
                            <ul>
                                <li><a href="#request.self#?fuseaction=settings.list_upgrade_note"><cf_get_lang no='2877.Upgrade Note'></a></li>
                            </ul>
                        </li>
                    </ul>
                </cfif>
            </div>
        	<div style="float:left;">
            	<ul class="pagemenus">
                    <li><strong><cf_get_lang no='1346.Cari Bakım'></strong>
                        <ul>
                            <li><a href="#request.self#?fuseaction=settings.list_nonoperation_ch_actions"><cf_get_lang_main no ='2340.İşlemi Olmayan Cari Hareketler'></a></li>
                        </ul>                        
                    </li>
                </ul> 
        </cfif>
    </div>
</cfoutput>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
