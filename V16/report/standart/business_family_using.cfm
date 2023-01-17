<style type="text/css">
    body {
      background-color: #ffffff;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol";
    }
    #chartdiv {
      width: 100%;
      max-width: 100%;
      height:900px;
    }
</style>

<script src="JS/holisticJs/core.js"></script>
<script src="JS/holisticJs/charts.js"></script>
<script src="JS/holisticJs/themes/animated.js"></script>
<script src="JS/holisticJs/plugins/forceDirected.js"></script>

    <cf_box title="#getLang('process',19)#"> 
    
        <div id="chartdiv"></div>	
                      

        <cfset anaTablo = arrayNew(2)>
        <cfset anaTablo[1][1] = "Pazarlama">
        <cfset anaTablo[2][1] = "Satış">
        <cfset anaTablo[3][1] = "Bütçe ve Hedefler">
        <cfset anaTablo[4][1] = "Stratejik Planlama">
        <cfset anaTablo[5][1] = "Üretim">
        <cfset anaTablo[6][1] = "Ürün Yönetimi">
        <cfset anaTablo[7][1] = "Satınalma">
        <cfset anaTablo[8][1] = "Muhasebe">
        <cfset anaTablo[9][1] = "Bordrolama">
        <cfset anaTablo[10][1] = "E Ticaret">
        <cfset anaTablo[11][1] = "Depo ve Lojistic">
        <cfset anaTablo[12][1] = "Abonelik">
        <cfset anaTablo[13][1] = "İletişim ve İş Birliği">
        <cfset anaTablo[14][1] = "Güvenlik">
        <cfset anaTablo[15][1] = "Denetim ve Risk">
        <cfset anaTablo[16][1] = "Kurumsal Literatür">
        <cfset anaTablo[17][1] = "Fiziki Kaynaklar">
        <cfset anaTablo[18][1] = "Finansal Kaynaklar">
        <cfset anaTablo[19][1] = "Müşteri İlişkileri">

        <cfset tablolar = ArrayNew(2)>

        <!--- [1] = Tablo Adı , [2] = Tablo Adı Açıklaması , [3] = Kat Değeri , [4] = Type Id , [5] = Varsa Koşullar --->
        <cfset tablolar[1][1] = '#dsn#.CONSUMER'><cfset tablolar[1][2] = "Bireysel Müşteriler"><cfset tablolar[1][3] = "1"><cfset tablolar[1][4] = "Pazarlama"><cfset tablolar[1][5] = "">
        <cfset tablolar[2][1] = '#dsn#.COMPANY_PARTNER'><cfset tablolar[2][2] = "Kurumsal Üye Çalışanları"><cfset tablolar[2][3] = "1"><cfset tablolar[2][4] = "Pazarlama"><cfset tablolar[2][5] = "">
        <cfset tablolar[3][1] = '#dsn#.COMPANY'><cfset tablolar[3][2] = "Kurumsal Üyeler"><cfset tablolar[3][3] = "1"><cfset tablolar[3][4] = "Pazarlama"><cfset tablolar[3][5] = "">
        <cfset tablolar[4][1] = '#dsn#.MAILS'><cfset tablolar[4][2] = "E-Mail"><cfset tablolar[4][3] = "1"><cfset tablolar[4][4] = "Pazarlama"><cfset tablolar[4][5] = "">
        <cfset tablolar[5][1] = '#dsn#.SURVEY'><cfset tablolar[5][2] = "Anketler"><cfset tablolar[5][3] = "1"><cfset tablolar[5][4] = "Pazarlama"><cfset tablolar[5][5] = "">
        <cfset tablolar[6][1] = '#dsn#.SOCIAL_MEDIA_REPORT'><cfset tablolar[6][2] = "Sosyal Odaklı Tanıma"><cfset tablolar[6][3] = "1"><cfset tablolar[6][4] = "Pazarlama"><cfset tablolar[6][5] = "">
        <cfset tablolar[7][1] = '#dsn3#.TARGET_MARKETS'><cfset tablolar[7][2] = "Hedef Kitle"><cfset tablolar[7][3] = "1"><cfset tablolar[7][4] = "Pazarlama"><cfset tablolar[7][5] = "">
        <cfset tablolar[8][1] = '#dsn#.SMS_TEMPLATE'><cfset tablolar[8][2] = "SMS"><cfset tablolar[8][3] = "1"><cfset tablolar[8][4] = "Pazarlama"><cfset tablolar[8][5] = "">
        <cfset tablolar[9][1] = '#dsn#.ORGANIZATION'><cfset tablolar[9][2] = "Etkinlik"><cfset tablolar[9][3] = "1"><cfset tablolar[9][4] = "Pazarlama"><cfset tablolar[9][5] = "">
        <cfset tablolar[10][1] = '#dsn3#.CAMPAIGNS'><cfset tablolar[10][2] = "Kampanya Yönetimi"><cfset tablolar[10][3] = "1"><cfset tablolar[10][4] = "Pazarlama"><cfset tablolar[10][5] = "">
        <cfset tablolar[11][1] = ''><cfset tablolar[11][2] = "Liste Yöneticisi"><cfset tablolar[11][3] = "1"><cfset tablolar[11][4] = "Pazarlama"><cfset tablolar[11][5] = "">
        <cfset tablolar[12][1] = '#dsn#.PAGE_WARNINGS'><cfset tablolar[12][2] = "Notification"><cfset tablolar[12][3] = "1"><cfset tablolar[12][4] = "Pazarlama"><cfset tablolar[12][5] = "">
        <cfset tablolar[13][1] = '#dsn#.CONTENT'><cfset tablolar[13][2] = "İçerik & Web Sitesi"><cfset tablolar[13][3] = "1"><cfset tablolar[13][4] = "Pazarlama"><cfset tablolar[13][5] = "">
        <cfset tablolar[14][1] = ''><cfset tablolar[14][2] = "Post Yayın"><cfset tablolar[14][3] = "1"><cfset tablolar[14][4] = "Pazarlama"><cfset tablolar[14][5] = "">
        <cfset tablolar[15][1] = ''><cfset tablolar[15][2] = "Gönderi Sonuç"><cfset tablolar[15][3] = "1"><cfset tablolar[15][4] = "Pazarlama"><cfset tablolar[15][5] = "">
        <cfset tablolar[16][1] = ''><cfset tablolar[16][2] = "IVR & Call"><cfset tablolar[16][3] = "1"><cfset tablolar[16][4] = "Pazarlama"><cfset tablolar[16][5] = "">
        <cfset tablolar[17][1] = '#dsn#.EVENT_PLAN'><cfset tablolar[17][2] = "Müşteri Ziyareti"><cfset tablolar[17][3] = "1"><cfset tablolar[17][4] = "Satış"><cfset tablolar[17][5] = "">
        <cfset tablolar[18][1] = ''><cfset tablolar[18][2] = "İlk Temas"><cfset tablolar[18][3] = "1"><cfset tablolar[18][4] = "Satış"><cfset tablolar[18][5] = "">
        <cfset tablolar[19][1] = '#dsn3#.OPPORTUNITIES'><cfset tablolar[19][2] = "Fırsat"><cfset tablolar[19][3] = "1"><cfset tablolar[19][4] = "Satış"><cfset tablolar[19][5] = "">
        <cfset tablolar[20][1] = '#dsn2#.INVOICE'><cfset tablolar[20][2] = "Perakende Satış"><cfset tablolar[20][3] = "1"><cfset tablolar[20][4] = "Satış"><cfset tablolar[20][5] = "WHERE INVOICE_CAT = 52">
        <cfset tablolar[21][1] = ''><cfset tablolar[21][2] = "Satış Sözleşmesi"><cfset tablolar[21][3] = "1"><cfset tablolar[21][4] = "Satış"><cfset tablolar[21][5] = "">
        <cfset tablolar[22][1] = '#dsn3#.OFFER'><cfset tablolar[22][2] = "Satış Teklifi"><cfset tablolar[22][3] = "1"><cfset tablolar[22][4] = "Satış"><cfset tablolar[22][5] = "WHERE PURCHASE_SALES = 1">
        <cfset tablolar[23][1] = '#dsn3#.ORDERS'><cfset tablolar[23][2] = "Satış Siparişi"><cfset tablolar[23][3] = "1"><cfset tablolar[23][4] = "Satış"><cfset tablolar[23][5] = "WHERE PURCHASE_SALES = 1">
        <cfset tablolar[24][1] = ''><cfset tablolar[24][2] = "Sevk Emirleri ve Talimatlar"><cfset tablolar[24][3] = "1"><cfset tablolar[24][4] = "Satış"><cfset tablolar[24][5] = "">
        <cfset tablolar[25][1] = '#dsn#.COMPANY_CREDIT'><cfset tablolar[25][2] = "Risk ve Diğer Koşullar"><cfset tablolar[25][3] = "1"><cfset tablolar[25][4] = "Satış"><cfset tablolar[25][5] = "">
        <cfset tablolar[26][1] = '#dsn2#.INVOICE_CONTRACT_COMPARISON'><cfset tablolar[26][2] = "Primler"><cfset tablolar[26][3] = "1"><cfset tablolar[26][4] = "Satış"><cfset tablolar[26][5] = "">
        <cfset tablolar[27][1] = '#dsn3#.PROMOTIONS'><cfset tablolar[27][2] = "Promosyon"><cfset tablolar[27][3] = "1"><cfset tablolar[27][4] = "Satış"><cfset tablolar[27][5] = "">
        <cfset tablolar[28][1] = ''><cfset tablolar[28][2] = "Fiyat Koruma"><cfset tablolar[28][3] = "1"><cfset tablolar[28][4] = "Satış"><cfset tablolar[28][5] = "">
        <cfset tablolar[29][1] = ''><cfset tablolar[29][2] = "Rapor Tasarımı"><cfset tablolar[29][3] = "1"><cfset tablolar[29][4] = "Bütçe ve Hedefler"><cfset tablolar[29][5] = "">
        <cfset tablolar[30][1] = '#dsn#.REPORTS'><cfset tablolar[30][2] = "Raporlar"><cfset tablolar[30][3] = "1"><cfset tablolar[30][4] = "Bütçe ve Hedefler"><cfset tablolar[30][5] = "">
        <cfset tablolar[31][1] = ''><cfset tablolar[31][2] = "Dashboard"><cfset tablolar[31][3] = "1"><cfset tablolar[31][4] = "Bütçe ve Hedefler"><cfset tablolar[31][5] = "">
        <cfset tablolar[32][1] = ''><cfset tablolar[32][2] = "Uyarı ve Yayın"><cfset tablolar[32][3] = "1"><cfset tablolar[32][4] = "Bütçe ve Hedefler"><cfset tablolar[32][5] = "">
        <cfset tablolar[33][1] = '#dsn#.PRO_WORKS'><cfset tablolar[33][2] = "İş Planı"><cfset tablolar[33][3] = "1"><cfset tablolar[33][4] = "Stratejik Planlama"><cfset tablolar[33][5] = "">
        <cfset tablolar[34][1] = '#dsn#.SALES_ZONES'><cfset tablolar[34][2] = "Satış Bölgeleri"><cfset tablolar[34][3] = "1"><cfset tablolar[34][4] = "Stratejik Planlama"><cfset tablolar[34][5] = "">
        <cfset tablolar[35][1] = '#dsn#.SALES_ZONES_TEAM'><cfset tablolar[35][2] = "Satış Takımları"><cfset tablolar[35][3] = "1"><cfset tablolar[35][4] = "Stratejik Planlama"><cfset tablolar[35][5] = "">
        <cfset tablolar[36][1] = '#dsn#.EXPENSE_CENTER'><cfset tablolar[36][2] = "Masraf ve Gelir Merkezleri"><cfset tablolar[36][3] = "1"><cfset tablolar[36][4] = "Stratejik Planlama"><cfset tablolar[36][5] = "">
        <cfset tablolar[37][1] = ''><cfset tablolar[37][2] = "Örgüt Matris Canvası"><cfset tablolar[37][3] = "1"><cfset tablolar[37][4] = "Stratejik Planlama"><cfset tablolar[37][5] = "">
        <cfset tablolar[38][1] = ''><cfset tablolar[38][2] = "Pazar ve Rekabet Analizi"><cfset tablolar[38][3] = "1"><cfset tablolar[38][4] = "Stratejik Planlama"><cfset tablolar[38][5] = "">
        <cfset tablolar[39][1] = '#dsn#.TARGET'><cfset tablolar[39][2] = "Satış Hedefleri"><cfset tablolar[39][3] = "1"><cfset tablolar[39][4] = "Stratejik Planlama"><cfset tablolar[39][5] = "">
        <cfset tablolar[40][1] = '#dsn#.BUDGET'><cfset tablolar[40][2] = "Bütçe Tasarımı"><cfset tablolar[40][3] = "1"><cfset tablolar[40][4] = "Stratejik Planlama"><cfset tablolar[40][5] = "">
        <cfset tablolar[41][1] = ''><cfset tablolar[41][2] = "Matris Performans Takımları"><cfset tablolar[41][3] = "1"><cfset tablolar[41][4] = "Stratejik Planlama"><cfset tablolar[41][5] = "">
        <cfset tablolar[42][1] = ''><cfset tablolar[42][2] = "Soft Skill Hedefler"><cfset tablolar[42][3] = "1"><cfset tablolar[42][4] = "Stratejik Planlama"><cfset tablolar[42][5] = "">
        <cfset tablolar[43][1] = '#dsn#.BUDGET_PLAN'><cfset tablolar[43][2] = "Bütçe Planı"><cfset tablolar[43][3] = "1"><cfset tablolar[43][4] = "Stratejik Planlama"><cfset tablolar[43][5] = "">
        <cfset tablolar[44][1] = ''><cfset tablolar[44][2] = "Mali Kayıt İşlem Kuralları"><cfset tablolar[44][3] = "1"><cfset tablolar[44][4] = "Stratejik Planlama"><cfset tablolar[44][5] = "">
        <cfset tablolar[45][1] = '#dsn#.EMPLOYEE_NORM_POSITIONS'><cfset tablolar[45][2] = "Rol Yetki Norm"><cfset tablolar[45][3] = "1"><cfset tablolar[45][4] = "Stratejik Planlama"><cfset tablolar[45][5] = "">
        <cfset tablolar[46][1] = ''><cfset tablolar[46][2] = "Mali Denetim Kuralları"><cfset tablolar[46][3] = "1"><cfset tablolar[46][4] = "Stratejik Planlama"><cfset tablolar[46][5] = "">
        <cfset tablolar[47][1] = '#dsn2#.ACCOUNT_PLAN'><cfset tablolar[47][2] = "Hesap Planı"><cfset tablolar[47][3] = "1"><cfset tablolar[47][4] = "Stratejik Planlama"><cfset tablolar[47][5] = "">
        <cfset tablolar[48][1] = ''><cfset tablolar[48][2] = "Denetim Periyod ve Raporlar"><cfset tablolar[48][3] = "1"><cfset tablolar[48][4] = "Stratejik Planlama"><cfset tablolar[48][5] = "">
        <cfset tablolar[49][1] = '#dsn#.PROCESS_TYPE_ROWS'><cfset tablolar[49][2] = "İş Süreçleri"><cfset tablolar[49][3] = "1"><cfset tablolar[49][4] = "Stratejik Planlama"><cfset tablolar[49][5] = "">
        <cfset tablolar[50][1] = ''><cfset tablolar[50][2] = "QPIC-RS Matrisi"><cfset tablolar[50][3] = "1"><cfset tablolar[50][4] = "Stratejik Planlama"><cfset tablolar[50][5] = "">
        <cfset tablolar[51][1] = ''><cfset tablolar[51][2] = "BSC-KPI Belirleme"><cfset tablolar[51][3] = "1"><cfset tablolar[51][4] = "Stratejik Planlama"><cfset tablolar[51][5] = "">
        <cfset tablolar[52][1] = ''><cfset tablolar[52][2] = "Risk Faktörleri Belirleme"><cfset tablolar[52][3] = "1"><cfset tablolar[52][4] = "Stratejik Planlama"><cfset tablolar[52][5] = "">
        <cfset tablolar[53][1] = ''><cfset tablolar[53][2] = "Üretim Kalite Tasarımı"><cfset tablolar[53][3] = "1"><cfset tablolar[53][4] = "Üretim"><cfset tablolar[53][5] = "">
        <cfset tablolar[54][1] = '#dsn3#.STOCKS'><cfset tablolar[54][2] = "Ağaç Reçete"><cfset tablolar[54][3] = "1"><cfset tablolar[54][4] = "Üretim"><cfset tablolar[54][5] = "WHERE IS_PRODUCTION = 1">
        <cfset tablolar[55][1] = ''><cfset tablolar[55][2] = "Üretim Planlama"><cfset tablolar[55][3] = "1"><cfset tablolar[55][4] = "Üretim"><cfset tablolar[55][5] = "">
        <cfset tablolar[56][1] = '#dsn3#.WORKSTATIONS'><cfset tablolar[56][2] = "İş İstasyonları"><cfset tablolar[56][3] = "1"><cfset tablolar[56][4] = "Üretim"><cfset tablolar[56][5] = "">
        <cfset tablolar[57][1] = '#dsn3#.PRODUCTION_ORDERS'><cfset tablolar[57][2] = "Üretim"><cfset tablolar[57][3] = "1"><cfset tablolar[57][4] = "Üretim"><cfset tablolar[57][5] = "">
        <cfset tablolar[58][1] = ''><cfset tablolar[58][2] = "CAD/CAM"><cfset tablolar[58][3] = "1"><cfset tablolar[58][4] = "Üretim"><cfset tablolar[58][5] = "">
        <cfset tablolar[59][1] = '#dsn3#.PRODUCTION_ORDERS'><cfset tablolar[59][2] = "Üretim Emirleri"><cfset tablolar[59][3] = "1"><cfset tablolar[59][4] = "Üretim"><cfset tablolar[59][5] = "">
        <cfset tablolar[60][1] = ''><cfset tablolar[60][2] = "Operasyon İşlem Adımları"><cfset tablolar[60][3] = "1"><cfset tablolar[60][4] = "Üretim"><cfset tablolar[60][5] = "">
        <cfset tablolar[61][1] = '#dsn3#.PRODUCTION_ORDER_RESULTS'><cfset tablolar[61][2] = "Üretim Sonucu"><cfset tablolar[61][3] = "1"><cfset tablolar[61][4] = "Üretim"><cfset tablolar[61][5] = "">
        <cfset tablolar[62][1] = ''><cfset tablolar[62][2] = "Malzeme Rezerve"><cfset tablolar[62][3] = "1"><cfset tablolar[62][4] = "Üretim"><cfset tablolar[62][5] = "">
        <cfset tablolar[63][1] = ''><cfset tablolar[63][2] = "Atomize Parçalama"><cfset tablolar[63][3] = "1"><cfset tablolar[63][4] = "Üretim"><cfset tablolar[63][5] = "">
        <cfset tablolar[64][1] = ''><cfset tablolar[64][2] = "OVT IOT"><cfset tablolar[64][3] = "1"><cfset tablolar[64][4] = "Üretim"><cfset tablolar[64][5] = "">
        <cfset tablolar[65][1] = '#dsn2#.STOCK_FIS'><cfset tablolar[65][2] = "Sarf"><cfset tablolar[65][3] = "1"><cfset tablolar[65][4] = "Üretim"><cfset tablolar[65][5] = "WHERE FIS_TYPE = 111">
        <cfset tablolar[66][1] = '#dsn2#.STOCK_FIS'><cfset tablolar[66][2] = "Fire"><cfset tablolar[66][3] = "1"><cfset tablolar[66][4] = "Üretim"><cfset tablolar[66][5] = "WHERE FIS_TYPE = 112">
        <cfset tablolar[67][1] = ''><cfset tablolar[67][2] = "Malzeme İhtiyaç Analizi"><cfset tablolar[67][3] = "1"><cfset tablolar[67][4] = "Üretim"><cfset tablolar[67][5] = "">
        <cfset tablolar[68][1] = ''><cfset tablolar[68][2] = "Kalite Kontrol"><cfset tablolar[68][3] = "1"><cfset tablolar[68][4] = "Üretim"><cfset tablolar[68][5] = "">
        <cfset tablolar[69][1] = '#dsn2#.STOCK_FIS'><cfset tablolar[69][2] = "Stoğa Giriş"><cfset tablolar[69][3] = "1"><cfset tablolar[69][4] = "Üretim"><cfset tablolar[69][5] = "WHERE FIS_TYPE = 119">
        <cfset tablolar[70][1] = ''><cfset tablolar[70][2] = "Lot, Seri No, QR"><cfset tablolar[70][3] = "1"><cfset tablolar[70][4] = "Üretim"><cfset tablolar[70][5] = "">
        <cfset tablolar[71][1] = '#dsn3#.INTERNALDEMAND'><cfset tablolar[71][2] = "Satınalma Talepleri"><cfset tablolar[71][3] = "1"><cfset tablolar[71][4] = "Üretim"><cfset tablolar[71][5] = "">
        <cfset tablolar[72][1] = '#dsn1#.PRODUCT'><cfset tablolar[72][2] = "Ürün"><cfset tablolar[72][3] = "1"><cfset tablolar[72][4] = "Ürün Yönetimi"><cfset tablolar[72][5] = "">
        <cfset tablolar[73][1] = '#dsn1#.STOCKS'><cfset tablolar[73][2] = "Stok"><cfset tablolar[73][3] = "1"><cfset tablolar[73][4] = "Ürün Yönetimi"><cfset tablolar[73][5] = "">
        <cfset tablolar[74][1] = '#dsn3#.SPECTS'><cfset tablolar[74][2] = "Spec"><cfset tablolar[74][3] = "1"><cfset tablolar[74][4] = "Ürün Yönetimi"><cfset tablolar[74][5] = "">
        <cfset tablolar[75][1] = ''><cfset tablolar[75][2] = "E-Ticaret Detayları"><cfset tablolar[75][3] = "1"><cfset tablolar[75][4] = "Ürün Yönetimi"><cfset tablolar[75][5] = "">
        <cfset tablolar[76][1] = '#dsn1#.PRODUCT_GENERAL_PARAMETERS'><cfset tablolar[76][2] = "Özellikler"><cfset tablolar[76][3] = "1"><cfset tablolar[76][4] = "Ürün Yönetimi"><cfset tablolar[76][5] = "">
        <cfset tablolar[77][1] = '#dsn3#.SETUP_SALEABLE_STOCK_ACTION'><cfset tablolar[77][2] = "Stok Stratejileri"><cfset tablolar[77][3] = "1"><cfset tablolar[77][4] = "Ürün Yönetimi"><cfset tablolar[77][5] = "">
        <cfset tablolar[78][1] = '#dsn3#.PRODUCT_SEGMENT'><cfset tablolar[78][2] = "Hedef Pazarlar"><cfset tablolar[78][3] = "1"><cfset tablolar[78][4] = "Ürün Yönetimi"><cfset tablolar[78][5] = "">
        <cfset tablolar[79][1] = ''><cfset tablolar[79][2] = "İçerik ve Bilgi Üretimi"><cfset tablolar[79][3] = "1"><cfset tablolar[79][4] = "Ürün Yönetimi"><cfset tablolar[79][5] = "">
        <cfset tablolar[80][1] = '#dsn1#.PRODUCT_CAT'><cfset tablolar[80][2] = "Kategori Yönetim"><cfset tablolar[80][3] = "1"><cfset tablolar[80][4] = "Ürün Yönetimi"><cfset tablolar[80][5] = "">
        <cfset tablolar[81][1] = ''><cfset tablolar[81][2] = "Maliyet Envanter Yönetim"><cfset tablolar[81][3] = "1"><cfset tablolar[81][4] = "Ürün Yönetimi"><cfset tablolar[81][5] = "">
        <cfset tablolar[82][1] = '#dsn3#.PRICE_CAT'><cfset tablolar[82][2] = "Satış Fiyatları"><cfset tablolar[82][3] = "1"><cfset tablolar[82][4] = "Ürün Yönetimi"><cfset tablolar[82][5] = "">
        <cfset tablolar[83][1] = '#dsn3#.PRICE_RIVAL'><cfset tablolar[83][2] = "Rekabet ve Rakip Fiyatları"><cfset tablolar[83][3] = "1"><cfset tablolar[83][4] = "Ürün Yönetimi"><cfset tablolar[83][5] = "">
        <cfset tablolar[84][1] = '#dsn3#.ORDER_RESULT_QUALITY'><cfset tablolar[84][2] = "Kalite Tasarımı"><cfset tablolar[84][3] = "1"><cfset tablolar[84][4] = "Ürün Yönetimi"><cfset tablolar[84][5] = "">
        <cfset tablolar[85][1] = '#dsn3#.PROMOTIONS'><cfset tablolar[85][2] = "Promosyon"><cfset tablolar[85][3] = "1"><cfset tablolar[85][4] = "Ürün Yönetimi"><cfset tablolar[85][5] = "">
        <cfset tablolar[86][1] = '#dsn3#.CONTRACT_SALES_PROD_DISCOUNT'><cfset tablolar[86][2] = "Satış Koşulları"><cfset tablolar[86][3] = "1"><cfset tablolar[86][4] = "Ürün Yönetimi"><cfset tablolar[86][5] = "">
        <cfset tablolar[87][1] = '#dsn3#.PRICE_CHANGE'><cfset tablolar[87][2] = "Satış Fiyat Önerileri"><cfset tablolar[87][3] = "1"><cfset tablolar[87][4] = "Ürün Yönetimi"><cfset tablolar[87][5] = "">
        <cfset tablolar[88][1] = '#dsn3#.INTERNALDEMAND_ROW'><cfset tablolar[88][2] = "Satınalma Talepleri"><cfset tablolar[88][3] = "1"><cfset tablolar[88][4] = "Satınalma"><cfset tablolar[88][5] = "">
        <cfset tablolar[89][1] = ''><cfset tablolar[89][2] = "Tedarikçi Değerleme"><cfset tablolar[89][3] = "1"><cfset tablolar[89][4] = "Satınalma"><cfset tablolar[89][5] = "">
        <cfset tablolar[90][1] = '#dsn3#.OFFER'><cfset tablolar[90][2] = "Alım Teklifleri"><cfset tablolar[90][3] = "1"><cfset tablolar[90][4] = "Satınalma"><cfset tablolar[90][5] = "WHERE PURCHASE_SALES = 0">
        <cfset tablolar[91][1] = ''><cfset tablolar[91][2] = "Alış Fiyatları"><cfset tablolar[91][3] = "1"><cfset tablolar[91][4] = "Satınalma"><cfset tablolar[91][5] = "">
        <cfset tablolar[92][1] = '#dsn3#.ORDERS'><cfset tablolar[92][2] = "Satınalma Siparişi"><cfset tablolar[92][3] = "1"><cfset tablolar[92][4] = "Satınalma"><cfset tablolar[92][5] = "WHERE PURCHASE_SALES = 0">
        <cfset tablolar[93][1] = ''><cfset tablolar[93][2] = "Sözleşme"><cfset tablolar[93][3] = "1"><cfset tablolar[93][4] = "Satınalma"><cfset tablolar[93][5] = "">
        <cfset tablolar[94][1] = ''><cfset tablolar[94][2] = "İhale"><cfset tablolar[94][3] = "1"><cfset tablolar[94][4] = "Satınalma"><cfset tablolar[94][5] = "">
        <cfset tablolar[95][1] = ''><cfset tablolar[95][2] = "Alım Koşulları"><cfset tablolar[95][3] = "1"><cfset tablolar[95][4] = "Satınalma"><cfset tablolar[95][5] = "">
        <cfset tablolar[96][1] = ''><cfset tablolar[96][2] = "Mal Hizmet Kabul Emirleri"><cfset tablolar[96][3] = "1"><cfset tablolar[96][4] = "Satınalma"><cfset tablolar[96][5] = "">
        <cfset tablolar[97][1] = ''><cfset tablolar[97][2] = "Teslimat Onay"><cfset tablolar[97][3] = "1"><cfset tablolar[97][4] = "Satınalma"><cfset tablolar[97][5] = "">
        <cfset tablolar[98][1] = ''><cfset tablolar[98][2] = "Fiyat - Fatura Kontrol"><cfset tablolar[98][3] = "1"><cfset tablolar[98][4] = "Satınalma"><cfset tablolar[98][5] = "">
        <cfset tablolar[99][1] = ''><cfset tablolar[99][2] = "Teslimat - Risk Kontrol"><cfset tablolar[99][3] = "1"><cfset tablolar[99][4] = "Satınalma"><cfset tablolar[99][5] = "">
        <cfset tablolar[100][1] = ''><cfset tablolar[100][2] = "Kalite Kontrol"><cfset tablolar[100][3] = "1"><cfset tablolar[100][4] = "Satınalma"><cfset tablolar[100][5] = "">
        <cfset tablolar[101][1] = ''><cfset tablolar[101][2] = "İadeler ve Cezalar"><cfset tablolar[101][3] = "1"><cfset tablolar[101][4] = "Satınalma"><cfset tablolar[101][5] = "">
        <cfset tablolar[102][1] = ''><cfset tablolar[102][2] = "Hakediş"><cfset tablolar[102][3] = "1"><cfset tablolar[102][4] = "Satınalma"><cfset tablolar[102][5] = "">
        <cfset tablolar[103][1] = ''><cfset tablolar[103][2] = "Ödeme Onay"><cfset tablolar[103][3] = "1"><cfset tablolar[103][4] = "Satınalma"><cfset tablolar[103][5] = "">
        <cfset tablolar[104][1] = ''><cfset tablolar[104][2] = "Sabit Kıymet Değerleme"><cfset tablolar[104][3] = "1"><cfset tablolar[104][4] = "Muhasebe"><cfset tablolar[104][5] = "">
        <cfset tablolar[105][1] = ''><cfset tablolar[105][2] = "Sabit Kıymet Alış-Satış"><cfset tablolar[105][3] = "1"><cfset tablolar[105][4] = "Muhasebe"><cfset tablolar[105][5] = "">
        <cfset tablolar[106][1] = ''><cfset tablolar[106][2] = "Gider Pusulaları"><cfset tablolar[106][3] = "1"><cfset tablolar[106][4] = "Muhasebe"><cfset tablolar[106][5] = "">
        <cfset tablolar[107][1] = '#dsn2#.EXPENSE_ITEM_PLANS'><cfset tablolar[107][2] = "Gelir Fişleri"><cfset tablolar[107][3] = "1"><cfset tablolar[107][4] = "Muhasebe"><cfset tablolar[107][5] = "WHERE ACTION_TYPE = 121">
        <cfset tablolar[108][1] = '#dsn2#.INVOICE'><cfset tablolar[108][2] = "Satış Faturaları"><cfset tablolar[108][3] = "1"><cfset tablolar[108][4] = "Muhasebe"><cfset tablolar[108][5] = "WHERE PURCHASE_SALES = 1">
        <cfset tablolar[109][1] = '#dsn2#.CARI_ROWS'><cfset tablolar[109][2] = "Cari İşlem Kayıtları"><cfset tablolar[109][3] = "1"><cfset tablolar[109][4] = "Muhasebe"><cfset tablolar[109][5] = "">
        <cfset tablolar[110][1] = ''><cfset tablolar[110][2] = "Yansıtma Fişleri"><cfset tablolar[110][3] = "1"><cfset tablolar[110][4] = "Muhasebe"><cfset tablolar[110][5] = "">
        <cfset tablolar[111][1] = ''><cfset tablolar[111][2] = "Kur Değerleme"><cfset tablolar[111][3] = "1"><cfset tablolar[111][4] = "Muhasebe"><cfset tablolar[111][5] = "">
        <cfset tablolar[112][1] = ''><cfset tablolar[112][2] = "Bakım Fişleri"><cfset tablolar[112][3] = "1"><cfset tablolar[112][4] = "Muhasebe"><cfset tablolar[112][5] = "">
        <cfset tablolar[113][1] = '#dsn2#.INVOICE'><cfset tablolar[113][2] = "Alış Faturaları"><cfset tablolar[113][3] = "1"><cfset tablolar[113][4] = "Muhasebe"><cfset tablolar[113][5] = "WHERE PURCHASE_SALES = 0">
        <cfset tablolar[114][1] = '#dsn2#.ACCOUNT_CARD'><cfset tablolar[114][2] = "Muhasebe Fişleri"><cfset tablolar[114][3] = "0.3"><cfset tablolar[114][4] = "Muhasebe"><cfset tablolar[114][5] = "">
        <cfset tablolar[115][1] = '#dsn2#.ACCOUNT_CARD_ROWS'><cfset tablolar[115][2] = "Muhasebe İşlem Kayıtları"><cfset tablolar[115][3] = "0.1"><cfset tablolar[115][4] = "Muhasebe"><cfset tablolar[115][5] = "">
        <cfset tablolar[116][1] = ''><cfset tablolar[116][2] = "Mustahsil Makbuzları"><cfset tablolar[116][3] = "1"><cfset tablolar[116][4] = "Muhasebe"><cfset tablolar[116][5] = "">
        <cfset tablolar[117][1] = ''><cfset tablolar[117][2] = "Serbest Meslek Makbuzları"><cfset tablolar[117][3] = "1"><cfset tablolar[117][4] = "Muhasebe"><cfset tablolar[117][5] = "">
        <cfset tablolar[118][1] = '#dsn2#.STOCK_FIS'><cfset tablolar[118][2] = "Stok Fişleri"><cfset tablolar[118][3] = "1"><cfset tablolar[118][4] = "Muhasebe"><cfset tablolar[118][5] = "">
        <cfset tablolar[119][1] = '#dsn2#.EXPENSE_ITEM_PLANS'><cfset tablolar[119][2] = "Masraf Fişleri"><cfset tablolar[119][3] = "1"><cfset tablolar[119][4] = "Muhasebe"><cfset tablolar[119][5] = "WHERE ACTION_TYPE = 120">
        <cfset tablolar[120][1] = ''><cfset tablolar[120][2] = "Maliyet Kayıtları"><cfset tablolar[120][3] = "1"><cfset tablolar[120][4] = "Muhasebe"><cfset tablolar[120][5] = "">
        <cfset tablolar[121][1] = ''><cfset tablolar[121][2] = "Gelir Gider Bütçe Kayıtları"><cfset tablolar[121][3] = "1"><cfset tablolar[121][4] = "Muhasebe"><cfset tablolar[121][5] = "">
        <cfset tablolar[122][1] = '#dsn#.SETUP_POSITION_CAT'><cfset tablolar[122][2] = "Rol-Yetki Yönetimi"><cfset tablolar[122][3] = "1"><cfset tablolar[122][4] = "Bordrolama"><cfset tablolar[122][5] = "">
        <cfset tablolar[123][1] = '#dsn#.EMPLOYEES'><cfset tablolar[123][2] = "Çalışan Bilgi Yönetimi"><cfset tablolar[123][3] = "1"><cfset tablolar[123][4] = "Bordrolama"><cfset tablolar[123][5] = "">
        <cfset tablolar[124][1] = ''><cfset tablolar[124][2] = "Ödeme ve Avans Yönetimi"><cfset tablolar[124][3] = "1"><cfset tablolar[124][4] = "Bordrolama"><cfset tablolar[124][5] = "">
        <cfset tablolar[125][1] = ''><cfset tablolar[125][2] = "İK İcra İşlemleri"><cfset tablolar[125][3] = "1"><cfset tablolar[125][4] = "Bordrolama"><cfset tablolar[125][5] = "">
        <cfset tablolar[126][1] = ''><cfset tablolar[126][2] = "Terfi ve Rotasyon"><cfset tablolar[126][3] = "1"><cfset tablolar[126][4] = "Bordrolama"><cfset tablolar[126][5] = "">
        <cfset tablolar[127][1] = ''><cfset tablolar[127][2] = "Performans İzleme"><cfset tablolar[127][3] = "1"><cfset tablolar[127][4] = "Bordrolama"><cfset tablolar[127][5] = "">
        <cfset tablolar[128][1] = '#dsn#.ORGANIZATION'><cfset tablolar[128][2] = "Organizasyon Planlama"><cfset tablolar[128][3] = "1"><cfset tablolar[128][4] = "Bordrolama"><cfset tablolar[128][5] = "">
        <cfset tablolar[129][1] = ''><cfset tablolar[129][2] = "İş Gücü Sözleşme ve Kuralları"><cfset tablolar[129][3] = "1"><cfset tablolar[129][4] = "Bordrolama"><cfset tablolar[129][5] = "">
        <cfset tablolar[130][1] = ''><cfset tablolar[130][2] = "Özlük Ücret"><cfset tablolar[130][3] = "1"><cfset tablolar[130][4] = "Bordrolama"><cfset tablolar[130][5] = "">
        <cfset tablolar[131][1] = ''><cfset tablolar[131][2] = "Puantaj"><cfset tablolar[131][3] = "1"><cfset tablolar[131][4] = "Bordrolama"><cfset tablolar[131][5] = "">
        <cfset tablolar[132][1] = ''><cfset tablolar[132][2] = "Bordro"><cfset tablolar[132][3] = "1"><cfset tablolar[132][4] = "Bordrolama"><cfset tablolar[132][5] = "">
        <cfset tablolar[133][1] = ''><cfset tablolar[133][2] = "Ödenek ve Kesintiler"><cfset tablolar[133][3] = "1"><cfset tablolar[133][4] = "Bordrolama"><cfset tablolar[133][5] = "">
        <cfset tablolar[134][1] = ''><cfset tablolar[134][2] = "İş Gücü Talebi"><cfset tablolar[134][3] = "1"><cfset tablolar[134][4] = "Bordrolama"><cfset tablolar[134][5] = "">
        <cfset tablolar[135][1] = ''><cfset tablolar[135][2] = "İşe Alım Seçme Değerleme"><cfset tablolar[135][3] = "1"><cfset tablolar[135][4] = "Bordrolama"><cfset tablolar[135][5] = "">
        <cfset tablolar[136][1] = ''><cfset tablolar[136][2] = "İzin ve Zaman Yönetimi"><cfset tablolar[136][3] = "1"><cfset tablolar[136][4] = "Bordrolama"><cfset tablolar[136][5] = "">
        <cfset tablolar[137][1] = ''><cfset tablolar[137][2] = "PDKS"><cfset tablolar[137][3] = "1"><cfset tablolar[137][4] = "Bordrolama"><cfset tablolar[137][5] = "">
        <cfset tablolar[138][1] = ''><cfset tablolar[138][2] = "CMB"><cfset tablolar[138][3] = "1"><cfset tablolar[138][4] = "Bordrolama"><cfset tablolar[138][5] = "">
        <cfset tablolar[139][1] = ''><cfset tablolar[139][2] = "Bordro Onay ve İtiraz"><cfset tablolar[138][3] = "1"><cfset tablolar[139][4] = "Bordrolama"><cfset tablolar[139][5] = "">
        <cfset tablolar[140][1] = ''><cfset tablolar[140][2] = "Gantchart"><cfset tablolar[140][3] = "1"><cfset tablolar[140][4] = "Bordrolama"><cfset tablolar[140][5] = "">
        <cfset tablolar[141][1] = ''><cfset tablolar[141][2] = "Kanban"><cfset tablolar[141][3] = "1"><cfset tablolar[141][4] = "Bordrolama"><cfset tablolar[141][5] = "">
        <cfset tablolar[142][1] = '#dsn#.PRO_PROJECTS'><cfset tablolar[142][2] = "Proje"><cfset tablolar[142][3] = "1"><cfset tablolar[142][4] = "Bordrolama"><cfset tablolar[142][5] = "">
        <cfset tablolar[143][1] = '#dsn#.PRO_WORKS'><cfset tablolar[143][2] = "Görev"><cfset tablolar[143][3] = "1"><cfset tablolar[143][4] = "Bordrolama"><cfset tablolar[143][5] = "">
        <cfset tablolar[144][1] = ''><cfset tablolar[144][2] = "B2C Müşteri Portali"><cfset tablolar[144][3] = "1"><cfset tablolar[144][4] = "E Ticaret"><cfset tablolar[144][5] = "">
        <cfset tablolar[145][1] = '#dsn#.WORKNET'><cfset tablolar[145][2] = "Pazar Yeri"><cfset tablolar[145][3] = "1"><cfset tablolar[145][4] = "E Ticaret"><cfset tablolar[145][5] = "">
        <cfset tablolar[146][1] = ''><cfset tablolar[146][2] = "Tedarikçi Portali"><cfset tablolar[146][3] = "1"><cfset tablolar[146][4] = "E Ticaret"><cfset tablolar[146][5] = "">
        <cfset tablolar[147][1] = ''><cfset tablolar[147][2] = "B2B Channel Portal"><cfset tablolar[147][3] = "1"><cfset tablolar[147][4] = "E Ticaret"><cfset tablolar[147][5] = "">
        <cfset tablolar[148][1] = ''><cfset tablolar[148][2] = "Workcube Protein CMS"><cfset tablolar[148][3] = "1"><cfset tablolar[148][4] = "E Ticaret"><cfset tablolar[148][5] = "">
        <cfset tablolar[149][1] = '#dsn#.MAIN_MENU_SETTINGS'><cfset tablolar[149][2] = "Web Siteleri"><cfset tablolar[149][3] = "1"><cfset tablolar[149][4] = "E Ticaret"><cfset tablolar[149][5] = "">
        <cfset tablolar[150][1] = '#dsn#.STOCKS_LOCATION'><cfset tablolar[150][2] = "Depo Alan Planlama"><cfset tablolar[150][3] = "1"><cfset tablolar[150][4] = "Depo ve Lojistic"><cfset tablolar[150][5] = "">
        <cfset tablolar[151][1] = ''><cfset tablolar[151][2] = "Lokasyon ve Raflar"><cfset tablolar[151][3] = "1"><cfset tablolar[151][4] = "Depo ve Lojistic"><cfset tablolar[151][5] = "">
        <cfset tablolar[152][1] = ''><cfset tablolar[152][2] = "Stok Yerleşim Planı"><cfset tablolar[152][3] = "1"><cfset tablolar[152][4] = "Depo ve Lojistic"><cfset tablolar[152][5] = "">
        <cfset tablolar[153][1] = ''><cfset tablolar[153][2] = "Mal Kabul Emirleri"><cfset tablolar[153][3] = "1"><cfset tablolar[153][4] = "Depo ve Lojistic"><cfset tablolar[153][5] = "">
        <cfset tablolar[154][1] = ''><cfset tablolar[154][2] = "Elleçleme"><cfset tablolar[154][3] = "1"><cfset tablolar[154][4] = "Depo ve Lojistic"><cfset tablolar[154][5] = "">
        <cfset tablolar[155][1] = '#dsn2#.SHIP'><cfset tablolar[155][2] = "Alış İrsaliyesi"><cfset tablolar[155][3] = "1"><cfset tablolar[155][4] = "Depo ve Lojistic"><cfset tablolar[155][5] = "WHERE PURCHASE_SALES = 0">
        <cfset tablolar[156][1] = ''><cfset tablolar[156][2] = "Stok Rezerve İşlemleri"><cfset tablolar[156][3] = "1"><cfset tablolar[156][4] = "Depo ve Lojistic"><cfset tablolar[156][5] = "">
        <cfset tablolar[157][1] = ''><cfset tablolar[157][2] = "Seri ve Lot İşlemleri"><cfset tablolar[157][3] = "1"><cfset tablolar[157][4] = "Depo ve Lojistic"><cfset tablolar[157][5] = "">
        <cfset tablolar[158][1] = ''><cfset tablolar[158][2] = "Alım İadeleri"><cfset tablolar[158][3] = "1"><cfset tablolar[158][4] = "Depo ve Lojistic"><cfset tablolar[158][5] = "">
        <cfset tablolar[159][1] = ''><cfset tablolar[159][2] = "Sevkiyat Planlama"><cfset tablolar[159][3] = "1"><cfset tablolar[159][4] = "Depo ve Lojistic"><cfset tablolar[159][5] = "">
        <cfset tablolar[160][1] = '#dsn2#.SHIP'><cfset tablolar[160][2] = "Satış İrsaliyesi"><cfset tablolar[160][3] = "1"><cfset tablolar[160][4] = "Depo ve Lojistic"><cfset tablolar[160][5] = "WHERE PURCHASE_SALES = 1">
        <cfset tablolar[161][1] = ''><cfset tablolar[161][2] = "Satış İadeleri"><cfset tablolar[161][3] = "1"><cfset tablolar[161][4] = "Depo ve Lojistic"><cfset tablolar[161][5] = "">
        <cfset tablolar[162][1] = ''><cfset tablolar[162][2] = "Araç - Ekip Yükleme"><cfset tablolar[162][3] = "1"><cfset tablolar[162][4] = "Depo ve Lojistic"><cfset tablolar[162][5] = "">
        <cfset tablolar[163][1] = ''><cfset tablolar[163][2] = "Teslimat"><cfset tablolar[163][3] = "1"><cfset tablolar[163][4] = "Depo ve Lojistic"><cfset tablolar[163][5] = "">
        <cfset tablolar[164][1] = ''><cfset tablolar[164][2] = "Fire Iskarta Sarf"><cfset tablolar[164][3] = "1"><cfset tablolar[164][4] = "Depo ve Lojistic"><cfset tablolar[164][5] = "">
        <cfset tablolar[165][1] = ''><cfset tablolar[165][2] = "Ödeme Provizyon"><cfset tablolar[165][3] = "1"><cfset tablolar[165][4] = "Abonelik"><cfset tablolar[165][5] = "">
        <cfset tablolar[166][1] = '#dsn2#.INVOICE'><cfset tablolar[166][2] = "Fatura"><cfset tablolar[166][3] = "1"><cfset tablolar[166][4] = "Abonelik"><cfset tablolar[166][5] = "">
        <cfset tablolar[167][1] = ''><cfset tablolar[167][2] = "Abonelik Sayaçları"><cfset tablolar[167][3] = "1"><cfset tablolar[167][4] = "Abonelik"><cfset tablolar[167][5] = "WHERE SUBSCRIPTION_ID IS NOT NULL">
        <cfset tablolar[168][1] = ''><cfset tablolar[168][2] = "IoT Okuma"><cfset tablolar[168][3] = "1"><cfset tablolar[168][4] = "Abonelik"><cfset tablolar[168][5] = "">
        <cfset tablolar[169][1] = ''><cfset tablolar[169][2] = "Kurulum ve Servis İş Emri"><cfset tablolar[169][3] = "1"><cfset tablolar[169][4] = "Abonelik"><cfset tablolar[169][5] = "">
        <cfset tablolar[170][1] = '#dsn3#.SUBSCRIPTION_CONTRACT'><cfset tablolar[170][2] = "Abone Kayıt"><cfset tablolar[170][3] = "0.1"><cfset tablolar[170][4] = "Abonelik"><cfset tablolar[170][5] = "">
        <cfset tablolar[171][1] = ''><cfset tablolar[171][2] = "Abonelik Sözleşmesi"><cfset tablolar[171][3] = "1"><cfset tablolar[171][4] = "Abonelik"><cfset tablolar[171][5] = "">
        <cfset tablolar[172][1] = ''><cfset tablolar[172][2] = "Tarife ve Fiyatlama"><cfset tablolar[172][3] = "1"><cfset tablolar[172][4] = "Abonelik"><cfset tablolar[172][5] = "">
        <cfset tablolar[173][1] = ''><cfset tablolar[173][2] = "Müşteri Onay"><cfset tablolar[173][3] = "1"><cfset tablolar[173][4] = "Abonelik"><cfset tablolar[173][5] = "">
        <cfset tablolar[174][1] = ''><cfset tablolar[174][2] = "Sarf"><cfset tablolar[174][3] = "1"><cfset tablolar[174][4] = "Abonelik"><cfset tablolar[174][5] = "">
        <cfset tablolar[175][1] = '#dsn3#.SUBSCRIPTION_CONTRACT'><cfset tablolar[175][2] = "Fiziki Varlık Atama"><cfset tablolar[175][3] = "1"><cfset tablolar[175][4] = "Abonelik"><cfset tablolar[175][5] = "WHERE ASSETP_ID IS NOT NULL">
        <cfset tablolar[176][1] = ''><cfset tablolar[176][2] = "Ödeme Bilgisi"><cfset tablolar[176][3] = "1"><cfset tablolar[176][4] = "Abonelik"><cfset tablolar[176][5] = "">
        <cfset tablolar[177][1] = '#dsn#.EVENT'><cfset tablolar[177][2] = "Ajanda"><cfset tablolar[177][3] = "1"><cfset tablolar[177][4] = "İletişim ve İş Birliği"><cfset tablolar[177][5] = "">
        <cfset tablolar[178][1] = '#dsn#.PAGE_WARNINGS'><cfset tablolar[178][2] = "Bildirim"><cfset tablolar[178][3] = "1"><cfset tablolar[178][4] = "İletişim ve İş Birliği"><cfset tablolar[178][5] = "">
        <cfset tablolar[179][1] = ''><cfset tablolar[179][2] = "Uyarı ve Onaylar"><cfset tablolar[179][3] = "1"><cfset tablolar[179][4] = "İletişim ve İş Birliği"><cfset tablolar[179][5] = "">
        <cfset tablolar[180][1] = '#dsn#.WRK_MESSAGE'><cfset tablolar[180][2] = "Hızlı Mesaj Chat"><cfset tablolar[180][3] = "1"><cfset tablolar[180][4] = "İletişim ve İş Birliği"><cfset tablolar[180][5] = "">
        <cfset tablolar[181][1] = '#dsn#.MAILS'><cfset tablolar[181][2] = "E-Mail"><cfset tablolar[181][3] = "1"><cfset tablolar[181][4] = "İletişim ve İş Birliği"><cfset tablolar[181][5] = "">
        <cfset tablolar[182][1] = '#dsn#.USER_GROUP'><cfset tablolar[182][2] = "Yetki Grupları"><cfset tablolar[182][3] = "1"><cfset tablolar[182][4] = "Güvenlik"><cfset tablolar[182][5] = "">
        <cfset tablolar[183][1] = ''><cfset tablolar[183][2] = "Yedekleme"><cfset tablolar[183][3] = "1"><cfset tablolar[183][4] = "Güvenlik"><cfset tablolar[183][5] = "">
        <cfset tablolar[184][1] = ''><cfset tablolar[184][2] = "Güvenlik"><cfset tablolar[184][3] = "1"><cfset tablolar[184][4] = "Güvenlik"><cfset tablolar[184][5] = "">
        <cfset tablolar[185][1] = ''><cfset tablolar[185][2] = "KVKK Yönetimi"><cfset tablolar[185][3] = "1"><cfset tablolar[185][4] = "Güvenlik"><cfset tablolar[185][5] = "">
        <cfset tablolar[186][1] = ''><cfset tablolar[186][2] = "Risk Kontol"><cfset tablolar[186][3] = "1"><cfset tablolar[186][4] = "Denetim ve Risk"><cfset tablolar[186][5] = "">
        <cfset tablolar[187][1] = ''><cfset tablolar[187][2] = "Yaşlandırma Ödeme Prf."><cfset tablolar[187][3] = "1"><cfset tablolar[187][4] = "Denetim ve Risk"><cfset tablolar[187][5] = "">
        <cfset tablolar[188][1] = '#dsn2#.CASH_ACTIONS'><cfset tablolar[188][2] = "Satış Fatura Kapama"><cfset tablolar[188][3] = "1"><cfset tablolar[188][4] = "Denetim ve Risk"><cfset tablolar[188][5] = "WHERE ACTION_TYPE_ID = 35">
        <cfset tablolar[189][1] = ''><cfset tablolar[189][2] = "Banka Tahsilat"><cfset tablolar[189][3] = "1"><cfset tablolar[189][4] = "Denetim ve Risk"><cfset tablolar[189][5] = "">
        <cfset tablolar[190][1] = '#dsn2#.CASH_ACTIONS'><cfset tablolar[190][2] = "Nakit Tahsilat"><cfset tablolar[190][3] = "1"><cfset tablolar[190][4] = "Denetim ve Risk"><cfset tablolar[190][5] = "WHERE ACTION_TYPE_ID = 31">
        <cfset tablolar[191][1] = ''><cfset tablolar[191][2] = "Çek Senet Tahsil"><cfset tablolar[191][3] = "1"><cfset tablolar[191][4] = "Denetim ve Risk"><cfset tablolar[191][5] = "">
        <cfset tablolar[192][1] = '#dsn3#.CREDIT_CARD_BANK_PAYMENTS'><cfset tablolar[192][2] = "Kredi Kartı Tahsil"><cfset tablolar[192][3] = "1"><cfset tablolar[192][4] = "Denetim ve Risk"><cfset tablolar[192][5] = "">
        <cfset tablolar[193][1] = '#dsn3#.CREDIT_CARD_BANK_PAYMENTS_ROWS'><cfset tablolar[193][2] = "Kart Hesaba Geçiş"><cfset tablolar[193][3] = "1"><cfset tablolar[193][4] = "Denetim ve Risk"><cfset tablolar[193][5] = "WHERE BANK_ACTION_ID IS NOT NULL">
        <cfset tablolar[194][1] = ''><cfset tablolar[194][2] = "Maaş Ödeme"><cfset tablolar[194][3] = "1"><cfset tablolar[194][4] = "Denetim ve Risk"><cfset tablolar[194][5] = "">
        <cfset tablolar[195][1] = ''><cfset tablolar[195][2] = "Ödeme Emri"><cfset tablolar[195][3] = "1"><cfset tablolar[195][4] = "Denetim ve Risk"><cfset tablolar[195][5] = "">
        <cfset tablolar[196][1] = '#dsn2#.CASH_ACTIONS'><cfset tablolar[196][2] = "Alış Fatura Kapama"><cfset tablolar[196][3] = "1"><cfset tablolar[196][4] = "Denetim ve Risk"><cfset tablolar[196][5] = "WHERE ACTION_TYPE_ID = 34">
        <cfset tablolar[197][1] = ''><cfset tablolar[197][2] = "Banka Ödeme"><cfset tablolar[197][3] = "1"><cfset tablolar[197][4] = "Denetim ve Risk"><cfset tablolar[197][5] = "">
        <cfset tablolar[198][1] = '#dsn2#.CASH_ACTIONS'><cfset tablolar[198][2] = "Nakit Ödeme"><cfset tablolar[198][3] = "1"><cfset tablolar[198][4] = "Denetim ve Risk"><cfset tablolar[198][5] = "WHERE ACTION_TYPE_ID = 32">
        <cfset tablolar[199][1] = ''><cfset tablolar[199][2] = "Çek-Senet Ödeme"><cfset tablolar[199][3] = "1"><cfset tablolar[199][4] = "Denetim ve Risk"><cfset tablolar[199][5] = "">
        <cfset tablolar[200][1] = '#dsn3#.CREDIT_CARD_BANK_EXPENSE'><cfset tablolar[200][2] = "Kredi Kartı Ödeme"><cfset tablolar[200][3] = "1"><cfset tablolar[200][4] = "Denetim ve Risk"><cfset tablolar[200][5] = "">
        <cfset tablolar[201][1] = ''><cfset tablolar[201][2] = "Kart Hesaptan Çıkış"><cfset tablolar[201][3] = "1"><cfset tablolar[201][4] = "Denetim ve Risk"><cfset tablolar[201][5] = "">
        <cfset tablolar[202][1] = ''><cfset tablolar[202][2] = "Avans Takip"><cfset tablolar[202][3] = "1"><cfset tablolar[202][4] = "Denetim ve Risk"><cfset tablolar[202][5] = "">
        <cfset tablolar[203][1] = ''><cfset tablolar[203][2] = "Cari Hesap"><cfset tablolar[203][3] = "1"><cfset tablolar[203][4] = "Denetim ve Risk"><cfset tablolar[203][5] = "">
        <cfset tablolar[204][1] = ''><cfset tablolar[204][2] = "Limit Tanımlama"><cfset tablolar[204][3] = "1"><cfset tablolar[204][4] = "Denetim ve Risk"><cfset tablolar[204][5] = "">
        <cfset tablolar[205][1] = ''><cfset tablolar[205][2] = "Kur Farkı Carileştirme"><cfset tablolar[205][3] = "1"><cfset tablolar[205][4] = "Denetim ve Risk"><cfset tablolar[205][5] = "">
        <cfset tablolar[206][1] = ''><cfset tablolar[206][2] = "Vade Farkı Carileştirme"><cfset tablolar[206][3] = "1"><cfset tablolar[206][4] = "Denetim ve Risk"><cfset tablolar[206][5] = "">
        <cfset tablolar[207][1] = ''><cfset tablolar[207][2] = "Nakit Yönetimi Senaryoları"><cfset tablolar[207][3] = "1"><cfset tablolar[207][4] = "Denetim ve Risk"><cfset tablolar[207][5] = "">
        <cfset tablolar[208][1] = ''><cfset tablolar[208][2] = "Borç Alacak Yönetimi"><cfset tablolar[208][3] = "1"><cfset tablolar[208][4] = "Denetim ve Risk"><cfset tablolar[208][5] = "">
        <cfset tablolar[209][1] = ''><cfset tablolar[209][2] = "İcra Takip İşlemleri"><cfset tablolar[209][3] = "1"><cfset tablolar[209][4] = "Denetim ve Risk"><cfset tablolar[209][5] = "">
        <cfset tablolar[210][1] = '#dsn#.FORUM_MAIN'><cfset tablolar[210][2] = "Forum"><cfset tablolar[210][3] = "1"><cfset tablolar[210][4] = "Kurumsal Literatür"><cfset tablolar[210][5] = "">
        <cfset tablolar[211][1] = '#dsn#.CONTENT'><cfset tablolar[211][2] = "İçerik"><cfset tablolar[211][3] = "1"><cfset tablolar[211][4] = "Kurumsal Literatür"><cfset tablolar[211][5] = "">
        <cfset tablolar[212][1] = ''><cfset tablolar[212][2] = "Eğitim Katalogları"><cfset tablolar[212][3] = "1"><cfset tablolar[212][4] = "Kurumsal Literatür"><cfset tablolar[212][5] = "">
        <cfset tablolar[213][1] = ''><cfset tablolar[213][2] = "Video ve Sunum İçerikler"><cfset tablolar[213][3] = "1"><cfset tablolar[213][4] = "Kurumsal Literatür"><cfset tablolar[213][5] = "">
        <cfset tablolar[214][1] = '#dsn#.SURVEY'><cfset tablolar[214][2] = "Anket"><cfset tablolar[214][3] = "1"><cfset tablolar[214][4] = "Kurumsal Literatür"><cfset tablolar[214][5] = "">
        <cfset tablolar[215][1] = '#dsn#.ASSET'><cfset tablolar[215][2] = "Dijital Arşiv"><cfset tablolar[215][3] = "1"><cfset tablolar[215][4] = "Kurumsal Literatür"><cfset tablolar[215][5] = "">
        <cfset tablolar[216][1] = ''><cfset tablolar[216][2] = "Katılımcı Seçimi"><cfset tablolar[216][3] = "1"><cfset tablolar[216][4] = "Kurumsal Literatür"><cfset tablolar[216][5] = "">
        <cfset tablolar[217][1] = '#dsn#.QUESTION'><cfset tablolar[217][2] = "Soru Bankası ve Sınav"><cfset tablolar[217][3] = "1"><cfset tablolar[217][4] = "Kurumsal Literatür"><cfset tablolar[217][5] = "">
        <cfset tablolar[218][1] = ''><cfset tablolar[218][2] = "İş Kural ve Standartları Literatür"><cfset tablolar[218][3] = "1"><cfset tablolar[218][4] = "Kurumsal Literatür"><cfset tablolar[218][5] = "">
        <cfset tablolar[219][1] = ''><cfset tablolar[219][2] = "Eğitim Maliyeti"><cfset tablolar[219][3] = "1"><cfset tablolar[219][4] = "Kurumsal Literatür"><cfset tablolar[219][5] = "">
        <cfset tablolar[220][1] = '#dsn#.TRAINING'><cfset tablolar[220][2] = "Eğitim"><cfset tablolar[220][3] = "1"><cfset tablolar[220][4] = "Kurumsal Literatür"><cfset tablolar[220][5] = "">
        <cfset tablolar[221][1] = ''><cfset tablolar[221][2] = "Eğitim Takvimi"><cfset tablolar[221][3] = "1"><cfset tablolar[221][4] = "Kurumsal Literatür"><cfset tablolar[221][5] = "">
        <cfset tablolar[222][1] = ''><cfset tablolar[222][2] = "Sertifikalar Yetkinlikler"><cfset tablolar[222][3] = "1"><cfset tablolar[222][4] = "Kurumsal Literatür"><cfset tablolar[222][5] = "">
        <cfset tablolar[223][1] = ''><cfset tablolar[223][2] = "Eğitim Sonucu"><cfset tablolar[223][3] = "1"><cfset tablolar[223][4] = "Kurumsal Literatür"><cfset tablolar[223][5] = "">
        <cfset tablolar[224][1] = ''><cfset tablolar[224][2] = "Eğitim Duyuruları"><cfset tablolar[224][3] = "1"><cfset tablolar[224][4] = "Kurumsal Literatür"><cfset tablolar[224][5] = "">
        <cfset tablolar[225][1] = ''><cfset tablolar[225][2] = "Katılımcı Davet ve Yönetimi"><cfset tablolar[225][3] = "1"><cfset tablolar[225][4] = "Kurumsal Literatür"><cfset tablolar[225][5] = "">
        <cfset tablolar[226][1] = ''><cfset tablolar[226][2] = "Sözleşme ve Kontrol"><cfset tablolar[226][3] = "1"><cfset tablolar[226][4] = "Fiziki Kaynaklar"><cfset tablolar[226][5] = "">
        <cfset tablolar[227][1] = ''><cfset tablolar[227][2] = "Makine Veri Toplama"><cfset tablolar[227][3] = "1"><cfset tablolar[227][4] = "Fiziki Kaynaklar"><cfset tablolar[227][5] = "">
        <cfset tablolar[228][1] = ''><cfset tablolar[228][2] = "IoT PLC"><cfset tablolar[228][3] = "1"><cfset tablolar[228][4] = "Fiziki Kaynaklar"><cfset tablolar[228][5] = "">
        <cfset tablolar[229][1] = ''><cfset tablolar[229][2] = "Sayaçlar"><cfset tablolar[229][3] = "1"><cfset tablolar[229][4] = "Fiziki Kaynaklar"><cfset tablolar[229][5] = "">
        <cfset tablolar[230][1] = ''><cfset tablolar[230][2] = "Kiralama"><cfset tablolar[230][3] = "1"><cfset tablolar[230][4] = "Fiziki Kaynaklar"><cfset tablolar[230][5] = "">
        <cfset tablolar[231][1] = ''><cfset tablolar[231][2] = "Makinalar Binalar"><cfset tablolar[231][3] = "1"><cfset tablolar[231][4] = "Fiziki Kaynaklar"><cfset tablolar[231][5] = "">
        <cfset tablolar[232][1] = ''><cfset tablolar[232][2] = "Periyodik Bakım"><cfset tablolar[232][3] = "1"><cfset tablolar[232][4] = "Fiziki Kaynaklar"><cfset tablolar[232][5] = "">
        <cfset tablolar[233][1] = ''><cfset tablolar[233][2] = "Arızalar"><cfset tablolar[233][3] = "1"><cfset tablolar[233][4] = "Fiziki Kaynaklar"><cfset tablolar[233][5] = "">
        <cfset tablolar[234][1] = ''><cfset tablolar[234][2] = "Fiziki Varlık Talepleri"><cfset tablolar[234][3] = "1"><cfset tablolar[234][4] = "Fiziki Kaynaklar"><cfset tablolar[234][5] = "">
        <cfset tablolar[235][1] = ''><cfset tablolar[235][2] = "Araçlar"><cfset tablolar[235][3] = "1"><cfset tablolar[235][4] = "Fiziki Kaynaklar"><cfset tablolar[235][5] = "">
        <cfset tablolar[236][1] = ''><cfset tablolar[236][2] = "Tamir Bakım"><cfset tablolar[236][3] = "1"><cfset tablolar[236][4] = "Fiziki Kaynaklar"><cfset tablolar[236][5] = "">
        <cfset tablolar[237][1] = ''><cfset tablolar[237][2] = "Garanti"><cfset tablolar[237][3] = "1"><cfset tablolar[237][4] = "Fiziki Kaynaklar"><cfset tablolar[237][5] = "">
        <cfset tablolar[238][1] = '#dsn#.EMPLOYEES_INVENT_ZIMMET'><cfset tablolar[238][2] = "Zimmet"><cfset tablolar[238][3] = "1"><cfset tablolar[238][4] = "Fiziki Kaynaklar"><cfset tablolar[238][5] = "">
        <cfset tablolar[239][1] = '#dsn#.ASSET_P, #dsn#.ASSET_P_CAT'><cfset tablolar[239][2] = "IT Varlıklar"><cfset tablolar[239][3] = "1"><cfset tablolar[239][4] = "Fiziki Kaynaklar"><cfset tablolar[239][5] = "WHERE ASSET_P.ASSETP_CATID = ASSET_P_CAT.ASSETP_CATID AND ASSET_P_CAT.IT_ASSET = 1">
        <cfset tablolar[240][1] = ''><cfset tablolar[240][2] = "Sarf ve Harcamalar"><cfset tablolar[240][3] = "1"><cfset tablolar[240][4] = "Fiziki Kaynaklar"><cfset tablolar[240][5] = "">
        <cfset tablolar[241][1] = ''><cfset tablolar[241][2] = "Cezalar"><cfset tablolar[241][3] = "1"><cfset tablolar[241][4] = "Fiziki Kaynaklar"><cfset tablolar[241][5] = "">
        <cfset tablolar[242][1] = '#dsn2#.CASH'><cfset tablolar[242][2] = "Kasalar"><cfset tablolar[242][3] = "1"><cfset tablolar[242][4] = "Finansal Kaynaklar"><cfset tablolar[242][5] = "">
        <cfset tablolar[243][1] = ''><cfset tablolar[243][2] = "Banka Talimatları"><cfset tablolar[243][3] = "1"><cfset tablolar[243][4] = "Finansal Kaynaklar"><cfset tablolar[243][5] = "">
        <cfset tablolar[244][1] = '#dsn3#.ACCOUNTS'><cfset tablolar[244][2] = "Banka Hesapları"><cfset tablolar[244][3] = "1"><cfset tablolar[244][4] = "Finansal Kaynaklar"><cfset tablolar[244][5] = "">
        <cfset tablolar[245][1] = '#dsn2#.CHEQUE'><cfset tablolar[245][2] = "Çekler"><cfset tablolar[245][3] = "1"><cfset tablolar[245][4] = "Finansal Kaynaklar"><cfset tablolar[245][5] = "">
        <cfset tablolar[246][1] = ''><cfset tablolar[246][2] = "Menkul Kıymetler"><cfset tablolar[246][3] = "1"><cfset tablolar[246][4] = "Finansal Kaynaklar"><cfset tablolar[246][5] = "">
        <cfset tablolar[247][1] = ''><cfset tablolar[247][2] = "Kredi Limitleri"><cfset tablolar[247][3] = "1"><cfset tablolar[247][4] = "Finansal Kaynaklar"><cfset tablolar[247][5] = "">
        <cfset tablolar[248][1] = ''><cfset tablolar[248][2] = "Tedarikçi Limitleri"><cfset tablolar[248][3] = "1"><cfset tablolar[248][4] = "Finansal Kaynaklar"><cfset tablolar[248][5] = "">
        <cfset tablolar[249][1] = ''><cfset tablolar[249][2] = "Değerleme Alış-Satış"><cfset tablolar[249][3] = "1"><cfset tablolar[249][4] = "Finansal Kaynaklar"><cfset tablolar[249][5] = "">
        <cfset tablolar[250][1] = ''><cfset tablolar[250][2] = "Kredi Sözleşmeleri"><cfset tablolar[250][3] = "1"><cfset tablolar[250][4] = "Finansal Kaynaklar"><cfset tablolar[250][5] = "">
        <cfset tablolar[251][1] = ''><cfset tablolar[251][2] = "Kredi Geri Ödeme"><cfset tablolar[251][3] = "1"><cfset tablolar[251][4] = "Finansal Kaynaklar"><cfset tablolar[251][5] = "">
        <cfset tablolar[252][1] = ''><cfset tablolar[252][2] = "Call Center Başvuru"><cfset tablolar[252][3] = "1"><cfset tablolar[252][4] = "Müşteri İlişkileri"><cfset tablolar[252][5] = "">
        <cfset tablolar[253][1] = '#dsn3#.SERVICE'><cfset tablolar[253][2] = "Servis Kayıt"><cfset tablolar[253][3] = "1"><cfset tablolar[253][4] = "Müşteri İlişkileri"><cfset tablolar[253][5] = "">
        <cfset tablolar[254][1] = ''><cfset tablolar[254][2] = "Servis İş Emri"><cfset tablolar[254][3] = "1"><cfset tablolar[254][4] = "Müşteri İlişkileri"><cfset tablolar[254][5] = "">
        <cfset tablolar[255][1] = ''><cfset tablolar[255][2] = "Garantili Ürün ve Abonelik"><cfset tablolar[255][3] = "1"><cfset tablolar[255][4] = "Müşteri İlişkileri"><cfset tablolar[255][5] = "">
        <cfset tablolar[256][1] = ''><cfset tablolar[256][2] = "Servis Sonucu"><cfset tablolar[256][3] = "1"><cfset tablolar[256][4] = "Müşteri İlişkileri"><cfset tablolar[256][5] = "">
        <cfset tablolar[257][1] = ''><cfset tablolar[257][2] = "Ekip Atama"><cfset tablolar[257][3] = "1"><cfset tablolar[257][4] = "Müşteri İlişkileri"><cfset tablolar[257][5] = "">
        <cfset tablolar[258][1] = ''><cfset tablolar[258][2] = "Teklif"><cfset tablolar[258][3] = "1"><cfset tablolar[258][4] = "Müşteri İlişkileri"><cfset tablolar[258][5] = "">
        <cfset tablolar[259][1] = '#dsn2#.INVOICE'><cfset tablolar[259][2] = "Fatura"><cfset tablolar[259][3] = "1"><cfset tablolar[259][4] = "Müşteri İlişkileri"><cfset tablolar[259][5] = "">
        <cfset tablolar[260][1] = ''><cfset tablolar[260][2] = "Sarf"><cfset tablolar[260][3] = "1"><cfset tablolar[260][4] = "Müşteri İlişkileri"><cfset tablolar[260][5] = "">
        <cfset tablolar[261][1] = '#dsn2#.VOUCHER'><cfset tablolar[261][2] = "Senetler"><cfset tablolar[261][3] = "1"><cfset tablolar[261][4] = "Finansal Kaynaklar"><cfset tablolar[261][5] = "">
    </cf_box>    

<!---
<cfscript>
		get_rows = CreateObject("component","V16.report.cfc.kayitsayisi");
		get_rows.dsn = dsn;
</cfscript>
--->
<script>
    am4core.ready(function() {

    am4core.useTheme(am4themes_animated);
    var chart = am4core.create("chartdiv", am4plugins_forceDirected.ForceDirectedTree);
    chart.legend = new am4charts.Legend();

    var networkSeries = chart.series.push(new am4plugins_forceDirected.ForceDirectedSeries())


    networkSeries.data = [
        <cfloop from="1" to="#arrayLen(anaTablo)#" index="i">
            {
                name: '<cfoutput>#anaTablo[i][1]#</cfoutput>',
                children: [
                <cfloop from="1" to="#arrayLen(tablolar)#" index="y"> 
                    <cfif anatablo[i][1] eq tablolar[y][4]>
                        <cfif len(tablolar[y][1])>
                            <cfquery name="get_record" datasource="#dsn#">
                                Select 
                                    COUNT(*) cnt 
                                FROM 
                                    #tablolar[y][1]#
                                    #tablolar[y][5]#
                            </cfquery>
                            <!---<cfscript>get_cons_ct = get_rows.get_count_fnc(table_name : '#tablolar[y][1]#');</cfscript>--->
                            <cfset get_cons_ct = #get_record.cnt#>
                        <cfelse>
                            <cfset get_cons_ct = 0>
                        </cfif>
                        <cfif len(get_cons_ct)>
                            <cfset katli = get_cons_ct * tablolar[i][3]>
                        <cfelse>
                            <cfset katli = 0>
                        </cfif>
                        <cfoutput>
                            {name: '#tablolar[y][2]#', value: #katli#},
                        </cfoutput>
                    </cfif>
                </cfloop>
                ]
            }<cfif i neq arrayLen(anaTablo)>, </cfif>
        </cfloop>
    ];




    networkSeries.dataFields.linkWith = "linkWith";
    networkSeries.dataFields.name = "name";
    networkSeries.dataFields.id = "name";
    networkSeries.dataFields.value = "value";
    networkSeries.dataFields.children = "children";

    networkSeries.nodes.template.tooltipText = "{name} - {value}";
    networkSeries.nodes.template.fillOpacity = 1;

    networkSeries.nodes.template.label.text = "{name}"
    networkSeries.fontSize = 9.5;
    networkSeries.maxLevels = 3;
    networkSeries.maxRadius = am4core.percent(4);
    networkSeries.manyBodyStrength = -6;
    networkSeries.nodes.template.label.hideOversized = true;
    networkSeries.nodes.template.label.truncate = true;
    });
</script>