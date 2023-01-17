<cf_get_lang_set module_name="store">
<cfoutput>
    <div style="width:180px;">
        <li><a href="#request.self#?fuseaction=store.list_purchase"><cf_get_lang_main no='2267.Stok Hareketleri'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_bill"><cf_get_lang_main no='1505.Faturalar'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_bill_purchase"><cf_get_lang_main no='764.Alis'> <cf_get_lang_main no='29.Fatura'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_bill"><cf_get_lang_main no='36.Satış'> <cf_get_lang_main no='29.Fatura'></a></li>
        <li><a href="#request.self#?fuseaction=store.add_bill_retail"><cf_get_lang_main no='353.Perakende Satış Faturası'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_command"><cf_get_lang_main no='116.Emirler'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_purchase"><cf_get_lang_main no='764.Alis'> <cf_get_lang_main no='361.Irsaliye'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_sale"><cf_get_lang_main no='36.Satış'> <cf_get_lang_main no='361.Irsaliye'></a></li>
     	<cfif session.ep.OUR_COMPANY_INFO.WORKCUBE_SECTOR eq "per">
           <li><a href="#request.self#?fuseaction=store.marketplace_commands"><cf_get_lang_main no='2287.Hal İrsaliyeleri'></a></li>
        </cfif>
        <cfif session.ep.OUR_COMPANY_INFO.WORKCUBE_SECTOR eq "per">
          <li><a href="#request.self#?fuseaction=store.add_marketplace_ship"><cf_get_lang_main no='2288.Hal İrsaliyesi Ekle'></a></li>
        </cfif>
        <li><a href="#request.self#?fuseaction=store.add_dispatch_internaldemand"><cf_get_lang_main no='2268.Sevk Talebi Ekle'></a></li>
        <li><a href="#request.self#?fuseaction=store.add_ship_dispatch"><cf_get_lang_main no='1351.Depo'> <cf_get_lang_main no='1349.Sevk'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_fis"><cf_get_lang_main no='2269.Fiş'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_bill_other"><cf_get_lang_main no='2270.Diğer Alış Ekle'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_internaldemand"><cf_get_lang_main no='1386.İç Talep'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_order"><cf_get_lang_main no ='795.Satış Siparişleri'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_order_instalment"><cf_get_lang_main no ='796.Taksitli Satışlar'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_purchase_order"><cf_get_lang_main no='2211.Satınalma Siparişleri'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_purchasedemand"><cf_get_lang_main no='2271.Satın Alma Talebi'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_group_ships"><cf_get_lang_main no='2272.Grup İçi İrsaliyeler'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_group_ships"><cf_get_lang_main no='2273.Grup İçi İrsaliye Ekle'></a></li>
        <li><a href="#request.self#?fuseaction=store.sale_analyse_report"><cf_get_lang_main no='2274.Satış Analiz Raporu'></a></li>
        <li><a href="#request.self#?fuseaction=store.sale_analyse_report_orders"><cf_get_lang_main no='2273.Satış Analiz Sipariş'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_serial_operations"><cf_get_lang_main no='2276.Seri Lot İşlemleri'></a></li>
        <li><a href="#request.self#?fuseaction=store.stock_analyse"><cf_get_lang_main no='606.Stok Analiz'></a></li>
        <li style="list-style:none; height:8px;"></li>
        <li><a href="#request.self#?fuseaction=store.purchase_analyse_report"><cf_get_lang_main no ='2281.Alış Raporu Fatura'></a></li>
        <li><a href="#request.self#?fuseaction=store.purchase_analyse_report_ship"><cf_get_lang_main no ='2282.Alış Raporu İrsaliye'> </a></li>
    </div>
    <div style="width:170px;">
        <li><a href="#request.self#?fuseaction=store.list_products"><cf_get_lang_main no ='152.Ürünler'></a></li>
        <li><a href="#request.self#?fuseaction=store.prices"><cf_get_lang_main no='1614.fiyatlar'></a></li>
        <li><a href="#request.self#?fuseaction=store.stocks"><cf_get_lang_main no ='754.Stoklar'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_store_promotion"><cf_get_lang_main no='1576.Aksiyonlar'></a></li>
        <li><a href="#request.self#?fuseaction=store.promotions"><cf_get_lang_main no='171.Promosyon'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_product_cost"><cf_get_lang_main no='2277.Urun Maliyetleri'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_stock_export"><cf_get_lang_main no='267.POS'></a></li>
        <li style="list-style:none; height:8px;"></li>
        <li><a href="#request.self#?fuseaction=store.consumer_list"><cf_get_lang_main no='1609.Bireysel Üyeler'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_consumer"><cf_get_lang_main no ='1610.Bireysel Üye Ekle'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_list_company"><cf_get_lang_main no='1611.Kurumsal Üyeler'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_company"><cf_get_lang_main no ='1612.Kurumsal Üye Ekle'></a></li>
     	<li style="list-style:none; height:8px;"></li>
        <li><a href="#request.self#?fuseaction=store.list_caris"><cf_get_lang_main no='2278.Cari Hareketler'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_company_extre&amp;is_page=1"><cf_get_lang_main no ='397.Hesap Ekstresi'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_duty_claim"><cf_get_lang_main no='2279.Borç Alacak Dökümü'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_cari_to_cari"><cf_get_lang_main no='2328.Cari Virman Ekle'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_collacted_cari_virman"><cf_get_lang_main no='645.Toplu'><cf_get_lang_main no='1770.Cari Virman'></a></li>
        <li><a href="#request.self#?fuseaction=store.add_collacted_dekont"><cf_get_lang_main no='1849.Toplu Dekont'> <cf_get_lang_main no='170.Ekle'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_securefund"><cf_get_lang_main no='264.Teminatlar'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_upd_account_open"><cf_get_lang_main no='1344.Açılış Fişi'></a></li>
        <li style="list-style:none; height:8px;"></li>
        <li><a href="#request.self#?fuseaction=store.cost_analyse_report"><cf_get_lang_main no='2283.Detaylı Harcama Analizi'></a></li>
        <li><a href="#request.self#?fuseaction=store.detail_budget_report"><cf_get_lang_main no='1648.Butce Raporu'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_expense_income"><cf_get_lang_main no ='1591.Masraf ve Gelir Fişleri'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_expense_cost"><cf_get_lang_main no='2296.Masraf Ekle'></a></li>
        <li><a href="#request.self#?fuseaction=store.add_income_cost"><cf_get_lang_main no='2297.Gelir Ekle'></a></li>
    </div>
    <div style="width:180px;">
        <li><a href="#request.self#?fuseaction=store.list_cash_actions"><cf_get_lang_main no ='1485.Kasa İşlemleri'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_cash_rate_valuation"><cf_get_lang_main no ='2613.Kasa Kur Değerleme'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_cash_revenue"><cf_get_lang_main no ='2284.Nakit Tahsilat'></a></li>
        <li><a href="#request.self#?fuseaction=store.add_collacted_revenue"><cf_get_lang_main no ='1763.Toplu Tahsilat'></a></li>
        <li><a href="#request.self#?fuseaction=store.add_collacted_payment"><cf_get_lang_main no ='1765.Toplu Ödeme'></a></li>        
        <li><a href="#request.self#?fuseaction=store.form_add_cash_to_cash"><cf_get_lang_main no ='2233.Virman - Döviz Alış\Satış İşlemi'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_stores_daily_reports"><cf_get_lang_main no='2303.Günlük Finansal Rapor'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_daily_zreport"><cf_get_lang_main no='1026.Z Raporu'></a></li>
        <li style="list-style:none; height:8px;"></li>
        <li><a href="#request.self#?fuseaction=store.list_bank_actions"> <cf_get_lang_main no ='1484.Banka İşlemleri'></a></li>
		<li><a href="#request.self#?fuseaction=store.form_add_bank_account_open"><cf_get_lang_main no='2280.Banka Hesabı Açılışı'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_bank_rate_valuation"><cf_get_lang_main no='1759.Banka Kur Değerleme'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_invest_money"><cf_get_lang_main no ='2285.Hesaba Para Yatır'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_get_money"><cf_get_lang_main no='2286.Hesaptan Para Çek'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_gidenh"><cf_get_lang_main no ='423.Giden Havale'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_gelenh"><cf_get_lang_main no ='422.Gelen Havale'></a></li>
        <li><a href="#request.self#?fuseaction=store.add_collacted_gidenh"><cf_get_lang_main no ='1758.Toplu Giden Havale'></a></li>
        <li><a href="#request.self#?fuseaction=store.add_collacted_gelenh"><cf_get_lang_main no ='1750.Toplu Gelen Havale'></a></li>        
        <li><a href="#request.self#?fuseaction=store.list_creditcard_revenue"><cf_get_lang_main no='424.Kredi Kartı Tahsilat'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_credit_card_expense"><cf_get_lang_main no='2333.Kredi Kartıyla Ödemeler'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_payment_credit_cards"><cf_get_lang_main no='1751.Kredi Kartı Hesaba Geçiş'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_virman"><cf_get_lang_main no ='2233.Virman - Döviz Alış\Satış İşlemi'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_bank_account"><cf_get_lang_main no ='1590.Banka Hesapları'></a></li>
    </div>
    <div>
        <li><a href="#request.self#?fuseaction=store.list_cheque_actions"><cf_get_lang_main no='2290.Çek İşlemleri'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_payroll_entry"><cf_get_lang_main no ='440.Çek Giriş Bordrosu'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_payroll_bank_revenue"><cf_get_lang_main no='441.Çek Çıkış Bordrosu-Tahsil'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_payroll_bank_guaranty"><cf_get_lang_main no='2291.Çek Çıkış - Banka'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_payroll_bank_guaranty_tem"><cf_get_lang_main no='442.Çek Çıkış Bordrosu-Banka Teminat'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_payroll_endorsement"><cf_get_lang_main no='2292.Çek Çıkış Bordrosu'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_payroll_entry_return"><cf_get_lang_main no ='444.Çek İade Giriş Bordrosu'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_payroll_bank_guaranty_return"><cf_get_lang_main no='444.Çek İade Giriş Bordrosu'>-<cf_get_lang_main no='109.Banka'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_payroll_endor_return"><cf_get_lang_main no ='445.Çek İade Çıkış Bordrosu'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_cheque_transfer"><cf_get_lang_main no='2293.Çek Transfer'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_voucher_actions"><cf_get_lang_main no='2294.Senet İşlemleri'></a></li>
        <li><a href="#request.self#?fuseaction=store.list_vouchers"><cf_get_lang_main no='2295.Senet Listesi'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_voucher_payroll_entry"><cf_get_lang_main no ='598.Senet Giriş Bordrosu'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_voucher_payroll_endorsement"><cf_get_lang_main no ='599.Senet Çıkış Bordrosu'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_voucher_payroll_revenue"><cf_get_lang_main no='1808.Senet Çıkış - Tahsil'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_voucher_payroll_bank_tah"><cf_get_lang_main no='1803.Senet Çıkış Banka - Tahsil'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_voucher_payroll_bank_tem"><cf_get_lang_main no='1804.Senet Çıkış Banka - Teminat'></a></li>
        <li><a href="#request.self#?fuseaction=store.add_voucher_payroll_entry_return"><cf_get_lang_main no ='601.Senet İade Giriş Bordrosu'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_voucher_bank_guaranty_return"><cf_get_lang_main no ='601.Senet İade Giriş Bordrosu'>-<cf_get_lang_main no='109.Banka'></a></li>
        <li><a href="#request.self#?fuseaction=store.form_add_voucher_transfer"><cf_get_lang_main no='2289.Senet Transfer'></a></li>
        <li><a href="#request.self#?fuseaction=store.add_voucher_payroll_endor_return"><cf_get_lang_main no='600.Senet İade Çıkış Bordrosu'></a></li>
		<li><a href="#request.self#?fuseaction=store.list_payment_voucher"><cf_get_lang_main no='1823.Senet Tahsilat'></a></li>
        <li style="list-style:none; height:8px;"></li>
    </div>     
</cfoutput>
