<div class="pagemenus_container">
        <div style="float:left;">
                <ul class="pagemenus">
                    <li><strong><cfoutput>#market_name#</cfoutput> Raporlar</strong>
                        <ul>
                        	<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.depo_stock_report">Stok Kontrol Raporu Alt Grup 2</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.depo_stock_report_upper">Stok Kontrol Raporu Ana Grup</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.price_report">Fiyat Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.purchase_sale_report">Alış - Satış Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.purchase_sale_report_datagrid">Alış - Satış Raporu_datagrid</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.purchase_sale_company_report">Cari Satış Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.purchase_sale_report_period">Dönemsel Satış Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.purchase_analyse_report_ship">Alış Analiz İrsaliye</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.active_stock_order_report">Güncel Stok - Sipariş Bakiye Raporu</a></li>
                        </ul>
                    </li>
                </ul>
               <ul class="pagemenus">
                    <li><strong>Konsinye Satış Raporlar</strong>
                        <ul>
                        	<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.purchase_consignment_report">Konsinye Satış Rapor</a></li>
                        </ul>
                    </li>
                </ul>
               <ul class="pagemenus">
                    <li><strong><cfoutput>#market_name#</cfoutput> Mağaza Raporlar</strong>
                        <ul>
                        	<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.depo_transfer_report">Sevk Bakiye Raporu</a></li>
                        </ul>
                    </li>
                </ul>
                <ul class="pagemenus">
                    <li><strong>Genius Raporlar</strong>
                        <ul>
                        	<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.genius_sales_report">Satış Kontrol Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.genius_fis">Fişler</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.list_consumer_bonus_report">Müşteri Puan</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.list_consumer_bonus_dash">Müşteri Puan Dashboard</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.odeme_report">Pos Kasa Nakit Akışı</a></li>
                        </ul>
                    </li>
                </ul>
                
                <ul class="pagemenus">
                    <li><strong>K Raporlar</strong>
                        <ul>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.k1_report">Haftalık Satış Tahsilat Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.k2_report">Günlük Satış Tahsilat Tablosu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.k3_report">Kasadan Yapılan Ödemeler</a></li>
                        </ul>
                    </li>
                </ul>
        </div>
        
        <div style="float:left;">
                <ul class="pagemenus">
                    <li><strong>Depo Raporlar</strong>
                        <ul>
                        	<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.depo_order_report">Depo Sipariş Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.depo_transfer_report_all">Depo Sipariş Raporu_ALL</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.depo_all_stock_report">Depo Stok Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.depo_all_stock_report2">Depoda Olup Lok. Olmayan Stok Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.depo_all_stock_report3">Şube Stok Satış Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.depo_all_stock_report4">Depoda Stoğu Olup Şubede Olmayan Stok Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.depo_new_stock_report">Depo Sayım Yapılacak Stok Raporu</a></li>
                        </ul>
                    </li>
                </ul>
        </div>
        
        <div style="float:left;">
                <ul class="pagemenus">
                    <li><strong>Muhasebe Raporlar</strong>
                        <ul>
                        	<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.cash_report">Kasa Aktarım Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.credit_card_payment_report">Kredi Kartı Raporu</a></li>
                            <li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.credit_payment_report">Kredi Ödeme Raporu</a></li>
                        </ul>
                    </li>
                </ul>
        </div>
         <div style="float:left;">
                <ul class="pagemenus">
                    <li><strong>İk Raporlar</strong>
                        <ul>
                        	<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.Yillik_izin_reports">Personel Yıllık İzin Raporu</a></li>
                        </ul>
                           </ul>
                    </li>
                         </ul>
        </div>
        <div style="float:left;">
                <ul class="pagemenus">
                    <li><strong>Sayım Raporlar</strong>
                        <ul>
                        	<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=retail.sayım_raporu.cfm">Sayım Raporu</a></li>
                        </ul>
                           </ul>
                    </li>
                         </ul>
        </div>
  
</div>


