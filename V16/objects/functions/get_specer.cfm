<!--- SELECT IS_PRODUCTION,IS_PROTOTYPE,* FROM PRODUCT --->
<!--- 
Spect Main TAblosunda Fuseaction'lara göre nerelerden eklendiğini görmek için açıklamalar.

--sales.emptypopup_upd_order => Satış Siparişi
--objects.emptypopup_add_spect_main_versiyon => Ürün Ağacından Ağacı Kaydet Dendiğinde.
--objects.popup_ajax_new_cre_spect => Spect Ekle Ekranından alt kırılımlardan kaydet denildiğinde
--objects.emptypopup_upd_spect_query_new => Spect Ekle Yada Spect Güncelle Ekranından Kaydedildiğinde
--prod.emptypopup_add_prod_order_result_act => Üretim Sonunu Kaydetme Ekranı
--prod.emptypopup_upd_prod_order_result_act => Üretim Sonucu Güncelleme Ekranı
 --->
<!--- pp ve ww için yazmadım cünkü object2 dosyasında zaten bu işi yapıyor onlar icin --->
<!--- FBS 20111216 pda eklendi --->
<cfscript>
	if(isdefined("session.pda") and isDefined("session.pda.userid"))
	{
		session_base.money = session.pda.money;
		session_base.money2 = session.pda.money2;
		session_base.userid = session.pda.userid;
		session_base.company_id = session.pda.our_company_id;
		session_base.our_company_id = session.pda.our_company_id;
		session_base.period_id = session.pda.period_id;
	}
	else if(isdefined("session.ep") and isDefined("session.ep.userid"))
	{
		session_base.money = session.ep.money;
		session_base.money2 = session.ep.money2;
		session_base.userid = session.ep.userid;
		session_base.company_id = session.ep.company_id;
		session_base.period_id = session.ep.period_id;
	}
</cfscript>
<cfif isDefined('session.ep.userid')>
	<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and listfind(fusebox.spect_company_list,session_base.company_id)>
		<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfelse>
		<cfset new_dsn3 = dsn3>
	</cfif>
<cfelseif isDefined('session.pp.userid')>
	<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and listfind(fusebox.spect_company_list,session.pp.our_company_id)>
		<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfelse>
		<cfset new_dsn3 = dsn3>
	</cfif>
<cfelseif isDefined('session.ww.userid')>
	<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and listfind(fusebox.spect_company_list,session.ww.our_company_id)>
		<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfelse>
		<cfset new_dsn3 = dsn3>
	</cfif>
<cfelseif isdefined("dsn3")>
	<cfset new_dsn3 = dsn3>
</cfif>
<!--- uretim planlamada main_spec guncelleme ekraninda elle yapiliyor burda yapilan main_spec le ilgili duzenleme ordada yapilsin --->
<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="yes">
<cffunction name="specer" returntype="string" output="false">
	<!---
	by : TolgaS 20061004    
	notes : 
		.....gelen parametrelere gore main_spec ve spec kayitlari yapar.....
		fonksiyondan donen deger spec_return isminde bir liste icerisinde
			spec_return : main_spec_id, spec_id,spec_name, spec ytl tutar,  spec_other_value, spec_other_money, spec_maliyet(ana urun fiyat cinsinden), maliyet para birimi , sistem para birimi cinsinden maliyeti, sistem para birimi cinsinden extra maliyeti
		only_main_spec:sadece main spec kaydedilecegi zaman yollanır
		insert_spec: spec kayit islemimi(1) yoksa update mi(0) onu beliritr
		spec_id: spec guncellenecekse guncellenecek spec id (insert_spec 0 oldugunda yollanmali)
		add_to_main_spec : eklencek spec main specdeki degerlerle eklenecekse 1 yollanmali( urun popuplari v.s. icin)
		main_spec_id: add_to_main_spec degeri 1 yollandi ise main_spec_id degeri mutlaka yollanmali
		company_id , consumer_id : eger spec bir main specden alinarak eklenecekse urun fiyatlarinin kime ait oldugun belirtmek icin yollanmazsa standart fiyatlar alinir
	usage :
	sadece main_spec_id den degerler alinarak kaydedilecekse
		specer(
				dsn_type:dsn3,
				spec_type:1,
				main_spec_id:492,
				add_to_main_spec:1,
				company_id (consumer_id):6
				
				money_list:'YTL,USD,EURO', (bu para birimleri ile ilgili liste yollanmazsa setup_moneyden alir kurlari)
				money_rate1_list:'1,1.5,1.7',
				money_rate2_list:'1,1,1',
			);
	tum degerler yollanacaksa
		specer(
				dsn_type:dsn3,
				insert_spec:0,(eklememi guncellememi 1 ekleme)
				spec_id= 100,( guncelleme ise guncellenecek spec id)
				spec_type:1,
				spec_is_tree:0,
				main_stock_id:4,
				main_product_id:4,
				spec_name:'sadas',
				spec_total_value:150,
				main_product_money :'YTL',
				spec_other_total_value:100,
				other_money:'USD',
				money_list:'YTL,USD,EURO',
				money_rate1_list:'1,1.5,1.7',
				money_rate2_list:'1,1,1',
				spec_row_count:4,
				stock_id_list:'1,2,5,6',
				product_id_list:'1,2,5,6',
				product_name_list:'a,b,c,d',
				amount_list:'1,2,2,2',
				is_sevk_list:'0,0,0,1',	
				is_configure_list:'1,0,0,0',
				is_property_list:'1,0,0,0',
				property_id_list:'1,0,0,0',
				variation_id_list:'0,0,0,0',
				total_min_list:'-,-,-,-',
				total_max_list : '-,-,-,-',
				diff_price_list : '0,0,0,0',
				product_price_list : '10,50,60,30',
				product_money_list : 'YTL,YTL,YTL,YTL',
				tolerance_list : '-,-,-,-'
			);
	--->
    
    
    
	<cfargument name="dsn_type" type="string" default="#new_dsn3#">
    <cfargument name="company_related_dsn" default="#arguments.dsn_type#">
	<cfargument name="main_spec_id" type="numeric"><!--- eger main_spec_id biliniyorsa yollanir gelirse main_spec kaydetmez --->
	<cfargument name="only_main_spec" type="boolean" default="0"><!--- sadece main_spec kaydedilecekse 1 gider --->
	<cfargument name="insert_spec" type="boolean" default="1"><!--- spect kaydedilecekse 1 update ise 0 --->
	<cfargument name="is_purchasesales" type="boolean" required="no" default="1"><!--- spect alis tipinde spec alis fiyatindan ve maliyette sadece urun alis fiyati atilmali --->
	<cfargument name="spec_id" type="string"><!--- spec guncellenecekse guncellenecek spec id--->
	<cfargument name="action_date" type="numeric" default="#now()#"><!--- maliyet v.s. tarihi ( ODBC Formatta !!!)--->
	<cfargument name="add_to_main_spec" type="boolean"><!--- main_spec_id var ve eklenecek spec main_spec deki degerlerle eklenecekse 1 yollanmalı ( urun popuplari v.s. icin)--->
	<cfargument name="company_id" type="string" default="0">
	<cfargument name="consumer_id" type="string" default="0">
	<cfargument name="spec_type" type="numeric" default="1"><!--- spec type 1:alternatifli 2: --->
	<cfargument name="spec_is_tree" type="boolean" default="0"><!--- spect agacin aynisi ise 1 degilse 0 --->
	<cfargument name="main_stock_id" type="numeric"><!--- spec eklenecek urun stock_id si --->
	<cfargument name="main_product_id" type="numeric"><!--- spec eklenecek urun product_id si --->
	<cfargument name="spec_name" type="string">
	<cfargument name="spec_total_value" type="numeric"><!--- YTL cinsinden --->
	<cfargument name="main_prod_price" type="numeric"><!--- urun fiyati --->
	<cfargument name="main_product_money" type="string" default="#session_base.money#"><!--- spec eklenecek urunun fiyat para birimi --->
	<cfargument name="spec_other_total_value" type="string" default="0">
	<cfargument name="marj_total_value" type="string" default="0"><!--- Marjlı toplam fiyatı tutar. --->
	<cfargument name="marj_other_total_value" type="string"><!--- Marjlı olan toplam döviz fiyatını tutar. --->
	<cfargument name="marj_amount" type="string" default="0"><!--- Uygulanan marj miktarını ifade eder,yani toplam fiyatının üzerine eklenen değerdir. --->
	<cfargument name="marj_percent" type="string" default="0"><!--- Uygulanan marj miktarına eklenecek %'lik değeri ifade eder. --->			
	<cfargument name="calculate_type_list" type="string" default=""><!--- Fire ve sarf ürünlerinin hesaplanırken,ürün özelliklerindeki en*boy hesaplamasının hangisi ile hesaplandığını tutar,listeye ürün özelliğinin currentrow'ları gönderiliyor,ona göre hesaplama yapılıyor.Kullanılmayan yerlerde 0 gönderilmelidri. --->
	<cfargument name="other_money" type="string" default="#session_base.money2#">
	<cfargument name="money_list" type="string" default=""><!--- para birimleri--->
	<cfargument name="money_rate1_list" type="string" default="">
	<cfargument name="money_rate2_list" type="string" default="">
	<cfargument name="spec_money_select" type="string" default="#session_base.money2#"><!--- secili olan para birimi --->
	<cfargument name="spec_row_count" type="numeric"><!--- spec satir sayisi --->
	<cfargument name="stock_id_list" type="string" default=""><!--- satirlarin stock_id leri olmayanlar 0 olarak yollanmali --->
	<cfargument name="product_id_list" type="string" default=""><!--- satirlarin product_id leri olmayanlar 0 olarak yollanmali --->
	<cfargument name="product_space_list" type="string" default=""><!--- (Metrekare)Ürün özelliklerinin en ve boy çarpımında yani max ve min çarpımından bulunan alanı tutar.yok ise 0 gönderilmelidir. --->
	<cfargument name="product_display_list" type="string" default=""><!--- (Metre)Ürün özelliklerinin en ve boy çarpımında yani max ve min çarpımından bulunan çevresini tutar.yok ise 0 gönderilmelidir. --->
	<cfargument name="product_rate_list" type="string" default=""><!--- ( % ) Maliyeti bulurken alan ile çarpılan yüzdelik dilimi ifade eder. Boş ise 0 gönderilmelidir.--->
	<cfargument name="product_name_list" type="string" default=""><!--- satirlarin urun isimleri olmayanlar - olarak yollanmali --->
	<cfargument name="amount_list" type="string" default=""><!--- satirlarin urun miktarlari --->
	<cfargument name="is_sevk_list" type="string" default=""><!--- satirlar sevkte birlestirse 1 degilse 0 --->
    <cfargument name="detail_list" type="string" default="">
	<cfargument name="is_configure_list" type="string" default=""><!--- satirlar configure edilebiliyorsa birlestirse 1 degilse 0 --->
	<cfargument name="is_property_list" type="string" default=""><!--- satirlar ozellik satiri ise 1 sarf ise 0 fire ürünü ise 2 ve operasyon ise 3 set edilmelidir. --->
	<cfargument name="property_id_list" type="string" default=""><!--- satirlar ozellikli ise ozellik idsi --->
	<cfargument name="variation_id_list" type="string" default=""><!--- satirlar ozellikli ise varyasyon idsi --->
	<cfargument name="total_min_list" type="string" default=""><!--- satirlar ozellikli ise total_minler olmayanlarda - yollanmali --->
	<cfargument name="total_max_list" type="string" default=""><!--- satirlar ozellikli ise total_maxlar olmayanlarda - yollanmali--->
	
    <cfargument name="configurator_variation_id_list" type="string" default=""><!--- özellik uniq id (SETUP_PRODUCT_CONFIGURATOR_VARIATION tablosundaki CONFIGURATOR_VARIATION_ID)--->
	<!--- <cfargument name="chapter_id_list" type="string" default=""><!--- ürün konfigüratöründeki bölüm id---> --->
	<cfargument name="dimension_list" type="string" default=""><!---Ölçek varsa gönderili yoksa - gönderilir.. --->
	<!--- <cfargument name="rel_variation_id_list" type="string" default=""><!--- İlişkili varyasyon id varsa gönderlir yoksa 0 atılmalı...---> --->
	<cfargument name="fire_amount_list" type="string" default="">
	<cfargument name="fire_rate_list" type="string" default="">
	<cfargument name="is_free_amount_list" type="string" default="">
	<cfargument name="is_phantom_list" type="string" default="">

	<cfargument name="diff_price_list" type="string" default=""><!--- satirlarda oluşan alternatif urunle ana urun arasındaki fiyat farki--->
	<cfargument name="product_price_list" type="string" default=""><!--- satirlarda oluşan urunlerin fiyatlari--->
	<cfargument name="list_price_list" type="string" default=""><!--- Satırlardaki ürünlerin o anki liste fiyatları yoksa 0 gönderilmelidir. --->
	<cfargument name="product_money_list" type="string" default=""><!--- satirlarda oluşan urun fiyatlarin para birimi--->
	<cfargument name="tolerance_list" type="string" default=""><!--- satirların tolerans yoksa - yollanmali--->
	<cfargument name="spect_file_name" type="string" default=""><!--- Specte dosya eklenirse objects altında tutuyor. --->
	<cfargument name="spect_server_file_name" type="string" default="">
	<cfargument name="old_files" type="string" default="">
	<cfargument name="old_server_id" type="string" default="">
	<cfargument name="del_attach" type="string" default="">
	<cfargument name="spect_status" type="numeric" default="1"><!--- Spect_main tablosundaki spect_status alanını kaydederken 1 olarak atar --->
	<cfargument name="related_spect_id_list" type="string" default=""><!--- satirlardaki üretilen ürünlerin ilişkili [MAIN_SPECT_ID]'si yoksa 0 gönderilmelidir. --->
	<cfargument name="related_spect_name_list" type="string" default=""><!--- satirlardaki üretilen ürünlerin ilişkili [MAIN_SPECT_ID]'lere ait spect isimleri --->
	<cfargument name="spect_detail" type="string" default=""><!--- Spect'in detayları --->
    <cfargument name="line_number_list" type="string"><!--- Ürünün ağaç ve spectdeki kullanım sırası,her yerde kullanılmıyor bu sebeble parametreye bağlı olarak gelicek. --->
    <cfargument name="question_id_list" type="string"><!---Alternatif ürünler seçilirken kullanılacak... --->
    <cfargument name="station_id_list" type="string"><!--- Ürün Ağacında seçilen Default İstasyon... --->
    <cfargument name="upd_spec_main_row" type="string" default=""><!--- Spec Kullanmayan Yerlerde Ürün Ağacı Güncellediği Zaman SpecMain'in Satırlarıda Güncellensin Diye Eklendi!Sadece ÜrünAğacını Kaydederken Gönderiyorum,Başka Yerlerde Kullanması Sıkıntıya Sebebiyet verir.. --->
    <cfargument name="is_limited_stock" type="numeric" default="0"><!--- seri sonu specmi  --->
    <cfargument name="special_code_1" type="string" default=""><!--- özel kod 1 uniq  --->
    <cfargument name="special_code_2" type="string" default=""><!--- özel kod 2 uniq  --->
    <cfargument name="special_code_3" type="string" default=""><!--- özel kod 3  --->
    <cfargument name="special_code_4" type="string" default=""><!--- özel kod 4  --->
	<cfargument name="related_tree_id_list" type="string" default=""><!--- satirlar operasyon  ise operasyonun bağlı bulunduğu ürün ağacının satırının id'si.. idsi yoksa 0 gönderilmelidir. --->
	<cfargument name="operation_type_id_list" type="string" default=""><!--- Satırlar operasyon ise operasyon id'si.. --->
    <cfargument name="is_product_tree_import" type="string" default=""><!--- Sadece Ürün ağacından import yapılıyor ise gönderilir... --->
	<cfargument name="is_control_spect_name" type="string" default="0">
	<cfargument name="is_control_tree" type="string" default="1">
	<cfargument name="is_add_same_name_spect" type="string" default="0"><!--- Aynı isimli spect oluşamasın seçili ise xml de 1 gelir. --->
    <cfargument name="is_spect_name_to_property" type="string" default="0"><!---eğer özellikler sayfasından geliyorsa spec ismini de kontrol etsin diye yollandı--->
	 <!--- grup içi işlemden yeni spect oluşturmak için eklendi PY 102015 --->
    <cfargument name="is_company_related_action" default="0">
   
    <cfif arguments.is_company_related_action>
    	<cfset new_dsn3 = arguments.company_related_dsn>
    </cfif>
<!---     grup içi işlemden yeni spect oluşturmak için eklendi PY 102015 
---> <!---<cfdump var="#arguments#">
 <cfabort> --->
 	<cfif not isdefined("new_dsn3")><cfset new_dsn3 = arguments.dsn_type></cfif>
	<cfset is_new_spec = 0>
	<cfif isdefined('del_attach') and del_attach eq 1>
		<cf_del_server_file output_file="objects/#old_files#" output_server="#old_server_id#">
		<cfquery name="UPD_DEL_ATTACH" datasource="#arguments.dsn_type#">
			UPDATE
				#new_dsn3#.SPECTS
			SET
				FILE_NAME = NULL,
				FILE_SERVER_ID = NULL
			WHERE
				SPECT_VAR_ID=#arguments.spec_id#
		</cfquery>
	</cfif>
	<cfif isdefined('arguments.spect_file_name') and len(arguments.spect_file_name)>
		<cf_del_server_file output_file="objects/#old_files#" output_server="#old_server_id#">
		<cffile action="UPLOAD"
					nameconflict="OVERWRITE" 
					filefield="spect_file_name" 
					destination="#upload_folder#objects#dir_seperator#">
		<cfset file_name_ = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder#objects#dir_seperator##cffile.serverfile#" destination="#upload_folder#objects#dir_seperator##file_name_#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#objects#dir_seperator##file_name_#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset arguments.spect_file_name=file_name_>
		<cfset arguments.spect_server_file_name = cffile.serverfile>
	</cfif>
	<cfset ayirac='|@|'><!--- AYIRAC FONSIYONUN CAGRIDILDIGI YERDE DUZELTILINCE BU bolum QUERY VS KALDIRILACAK --->
    <cfif isdefined('arguments.spec_name')>
        <cfset arguments.spec_name=replace(arguments.spec_name,',',' ','all')>
    </cfif>
    <cfif listlen(product_name_list,'#ayirac#') neq listlen(stock_id_list,',')><!--- özellikli olan speclerde aciklama alani kaydediliyor o yuzden o sayfada ayirac duzenlendi diger sayfalarda duznlenmeli --->
        <cfif listlen(arguments.stock_id_list,',')>
            <cfset arguments.product_name_list="">
            <cfloop list="#arguments.stock_id_list#" delimiters="," index="stk_id">
            <cfif stk_id neq 0>
                <cfquery name="GET_PRODUCT_NAME" datasource="#arguments.dsn_type#">
                    SELECT
                        STOCK_ID,
                        PRODUCT_DETAIL,
                        PRODUCT_NAME,
                        PROPERTY,
						PRODUCT_ID
                    FROM 
                        #new_dsn3#.STOCKS 
                    WHERE 
                        STOCK_ID IN (#stk_id#)
                </cfquery>
                <cfif isdefined('session.ep.userid') or isDefined("session.pda.userid")>
                    <cfif GET_PRODUCT_NAME.recordcount>
                        <cfset pro_name='#GET_PRODUCT_NAME.PRODUCT_NAME# #GET_PRODUCT_NAME.PROPERTY#'>
                        <cfif len(pro_name) gt 150><cfset pro_name=left(pro_name,150)></cfif>
                        <cfset arguments.product_name_list=listappend(arguments.product_name_list,pro_name,ayirac)>
                    <cfelse>
                        <cfset arguments.product_name_list=listappend(arguments.product_name_list,'-',ayirac)>
                    </cfif>
                <cfelse><!--- partnersa --->
                    <cfif GET_PRODUCT_NAME.recordcount and len(GET_PRODUCT_NAME.PRODUCT_DETAIL)>
                        <cfset pro_name=GET_PRODUCT_NAME.PRODUCT_DETAIL>
                        <cfif len(pro_name) gt 150><cfset pro_name=left(pro_name,150)></cfif>
                        <cfset arguments.product_name_list=listappend(arguments.product_name_list,pro_name,ayirac)>
                    <cfelse>
                        <cfset pro_name='#GET_PRODUCT_NAME.PRODUCT_NAME# #GET_PRODUCT_NAME.PROPERTY#'>
                        <cfif len(pro_name) gt 150><cfset pro_name=left(pro_name,150)></cfif>
                        <cfset arguments.product_name_list=listappend(arguments.product_name_list,pro_name,ayirac)>
                    </cfif>
                </cfif>
            <cfelse>
                <cfset arguments.product_name_list=listappend(arguments.product_name_list,'-',ayirac)>
            </cfif>
            </cfloop>
        </cfif>
    </cfif>
	<!--- main_spec ekliyor --->
	<cfif not isdefined("arguments.main_stock_id")>
		<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session_base.userid#_'&round(rand()*100)>
	<cfelseif isdefined("arguments.spec_row_count")>		
		<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session_base.userid#_#arguments.main_stock_id#_#arguments.spec_row_count#_'&round(rand()*100)>
	<cfelse>
		<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session_base.userid#_#arguments.main_stock_id#_'&round(rand()*100)>
	</cfif>
	<cfif not isdefined('arguments.main_spec_id') or not len(arguments.main_spec_id)>
		<cfif arguments.spec_row_count eq 0><!--- Main Spec Oluşturmak İçin Üründe hiçbir sarf olmadığı durumlarda. --->
            Birleşeni Olmayan Ürünler İçin Spec Oluşturamazsınız!
			<cfabort>
		</cfif>
		<!--- 
            Eğer Ana Ürünümüz Özelleştirilebiliyor ise Yeni Main Specler Oluşur,
            Özelleştirilmiyorsa yeni spec oluşmaz,olası bir güncellemede spec_main_row satırları silinerek yeni satırlar eklenir.
            M.ER 27 01 2008 
        --->
        <cfquery name="get_product_info_spec"  datasource="#arguments.dsn_type#">
        	SELECT 
				<cfif arguments.is_add_same_name_spect eq 1><!--- eğer aynı isimle spect eklenemesin denmişse sadece isme göre kontrol yapsın diye özelleştirilebilir değeri 0 yapılıyor --->
					0 IS_PROTOTYPE
				<cfelse>
					ISNULL(IS_PROTOTYPE,0) AS IS_PROTOTYPE
				</cfif>,
				ISNULL(IS_PROTOTYPE,0) AS IS_PROTOTYPE_OLD,
				PRODUCT_ID 
			FROM 
				#new_dsn3#.STOCKS 
			WHERE 
				STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_stock_id#">
        </cfquery>
		<cfif isdefined("arguments.main_product_id") and (arguments.main_product_id eq 0 or not len(arguments.main_product_id))><cfset arguments.main_product_id = get_product_info_spec.PRODUCT_ID></cfif>
        <cfquery name="GET_SPECT" datasource="#arguments.dsn_type#">
	        <cfif get_product_info_spec.IS_PROTOTYPE eq 1 and not len(arguments.is_product_tree_import)>
				SELECT 
					COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID),
					SPECT_MAIN.SPECT_MAIN_ID,
					SPECT_MAIN.SPECT_MAIN_NAME
				FROM 
					#new_dsn3#.SPECT_MAIN_ROW SPECT_MAIN_ROW,
					#new_dsn3#.SPECT_MAIN SPECT_MAIN
				WHERE
					SPECT_MAIN.SPECT_STATUS=1 AND 
					SPECT_MAIN.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_stock_id#"> AND
					SPECT_MAIN_ROW.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID AND
					(
						<cfloop from="1" to="#arguments.spec_row_count#" index="ii">
							(
								IS_SEVK = <cfqueryparam cfsqltype="cf_sql_smallint" value="#listgetat(arguments.is_sevk_list,ii,',')#">
								AND SPECT_MAIN_ROW.AMOUNT = <cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(arguments.amount_list,ii,',')#">
								AND SPECT_MAIN_ROW.IS_PROPERTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.is_property_list,ii,',')#">
								<cfif listgetat(arguments.stock_id_list,ii,',') gt 0>
									AND	SPECT_MAIN_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.stock_id_list,ii,',')#">
								</cfif>
                                <cfif arguments.is_spect_name_to_property eq 2>
                                	AND SPECT_MAIN_ROW.PRODUCT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#listgetat(arguments.product_name_list,ii,ayirac)#"> 
                                </cfif>
								<cfif isdefined('arguments.related_spect_id_list') and listlen(arguments.related_spect_id_list,',')>
									<cfif listgetat(arguments.related_spect_id_list,ii,',') neq 0>
										AND	SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.related_spect_id_list,ii,',')#">
									</cfif>
								<cfelse>
									AND	SPECT_MAIN_ROW.RELATED_MAIN_SPECT_ID IS NULL
								</cfif>
								<cfif isdefined('arguments.property_id_list') and listgetat(arguments.property_id_list,ii,',') gt 0>
									AND SPECT_MAIN_ROW.PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(property_id_list,ii,',')#">
								</cfif>
								<cfif isdefined('arguments.operation_type_id_list') and listlen(arguments.operation_type_id_list) and listgetat(arguments.operation_type_id_list,ii,',') gt 0>
									AND SPECT_MAIN_ROW.OPERATION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(operation_type_id_list,ii,',')#">
								</cfif>
								
								<cfif isdefined('arguments.variation_id_list') and listgetat(arguments.variation_id_list,ii,',') gt 0>
									AND SPECT_MAIN_ROW.VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(variation_id_list,ii,',')#">
								</cfif>
								<cfif isdefined('arguments.total_min_list') and listgetat(arguments.total_min_list,ii,',') gt 0>
									AND SPECT_MAIN_ROW.TOTAL_MIN = <cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(arguments.total_min_list,ii,',')#">
								</cfif>
								<cfif isdefined('arguments.total_max_list') and listgetat(arguments.total_max_list,ii,',') gt 0>
									AND SPECT_MAIN_ROW.TOTAL_MAX = <cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(arguments.total_max_list,ii,',')#">
								</cfif>
								<cfif isdefined('arguments.tolerance_list') and listgetat(arguments.tolerance_list,ii,',') neq '-'>
									AND SPECT_MAIN_ROW.TOLERANCE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.tolerance_list,ii,',')#">
								</cfif>
								<cfif isdefined('arguments.product_space_list') and len(arguments.product_space_list) and listgetat(arguments.product_space_list,ii,',') gt 0>
									AND SPECT_MAIN_ROW.PRODUCT_SPACE = <cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(arguments.product_space_list,ii,',')#">
								</cfif>
								<cfif isdefined('arguments.product_display_list') and len(arguments.product_display_list) and listgetat(arguments.product_display_list,ii,',') gt 0>
									AND SPECT_MAIN_ROW.PRODUCT_DISPLAY = <cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(arguments.product_display_list,ii,',')#">
								</cfif>
								<cfif isdefined('arguments.product_rate_list') and len(arguments.product_rate_list) and listgetat(arguments.product_rate_list,ii,',') gt 0>
									AND SPECT_MAIN_ROW.PRODUCT_RATE = <cfqueryparam cfsqltype="cf_sql_float" value="#listgetat(arguments.product_rate_list,ii,',')#">
								</cfif>
								<cfif isdefined('arguments.question_id_list') and len(arguments.question_id_list) and listgetat(arguments.question_id_list,ii,',') gt 0>
									AND SPECT_MAIN_ROW.QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.question_id_list,ii,',')#">
								</cfif>
								<!--- <cfif isdefined('arguments.calculate_type_list') and len(arguments.calculate_type_list) and listgetat(arguments.calculate_type_list,ii,',') gt 0 >
									AND SPECT_MAIN_ROW.CALCULATE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(arguments.calculate_type_list,ii,',')#">
								</cfif> --->
							) 
							<cfif listlen(arguments.stock_id_list,',') gt ii>OR</cfif>
						</cfloop>
					)
					AND (SELECT COUNT(SMR.SPECT_MAIN_ROW_ID) FROM #new_dsn3#.SPECT_MAIN_ROW SMR WHERE SMR.SPECT_MAIN_ID=SPECT_MAIN.SPECT_MAIN_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spec_row_count#">
				GROUP BY SPECT_MAIN.SPECT_MAIN_ID,SPECT_MAIN.SPECT_MAIN_NAME
				HAVING COUNT(SPECT_MAIN_ROW.SPECT_MAIN_ROW_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spec_row_count#">
            <cfelse>
            	SELECT TOP 1 SPECT_MAIN_ID,SPECT_MAIN_NAME FROM #new_dsn3#.SPECT_MAIN SM WHERE SM.SPECT_STATUS=1 AND SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_stock_id#"> <cfif arguments.is_control_tree eq 1 and not(arguments.is_control_spect_name eq 1 and get_product_info_spec.is_prototype_old eq 1)>AND SM.IS_TREE = 1</cfif> <cfif arguments.is_control_spect_name eq 1 and get_product_info_spec.is_prototype_old eq 1>AND SM.SPECT_MAIN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.spec_name#"></cfif> ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
            </cfif>
		</cfquery>
        <!--- <cfdump var="#GET_SPECT#"><cfoutput>[#get_product_info_spec.IS_PROTOTYPE#]--#arguments.is_product_tree_import#</cfoutput><cfabort> ---->
		<cfif GET_SPECT.RECORDCOUNT eq 0>
		<cfif not len(arguments.main_product_id)>
				<cfquery name="get_prod_id" datasource="#arguments.dsn_type#">
					SELECT PRODUCT_ID FROM #new_dsn3#.STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.main_stock_id#">
				</cfquery>
				<cfset arguments.main_product_id = get_prod_id.product_id>
			</cfif>
			<cfquery name="ADD_VAR_SPECT" datasource="#arguments.dsn_type#">
				INSERT INTO
					#new_dsn3#.SPECT_MAIN
					(
						SPECT_MAIN_NAME,
						SPECT_TYPE,
						PRODUCT_ID,
						STOCK_ID,
						IS_TREE,
						SPECT_STATUS,
						RECORD_IP,
						<cfif isDefined("session.pp")>
                            RECORD_PAR,
                        <cfelseif isDefined("session.ww")>
                            RECORD_CON,
                        <cfelse>
                            RECORD_EMP,
                        </cfif>
						RECORD_DATE,
                        FUSEACTION,
                        IS_LIMITED_STOCK,
                        SPECIAL_CODE_1,
                        SPECIAL_CODE_2,
                        SPECIAL_CODE_3,
                        SPECIAL_CODE_4,
                        WRK_ID
					)
					VALUES
					(
						'#left(arguments.spec_name,500)#',
						#arguments.spec_type#,
						#arguments.main_product_id#,
						#arguments.main_stock_id#,
						#arguments.spec_is_tree#,
						#arguments.spect_status#,
						'#cgi.remote_addr#',
						<cfif isdefined('session_base.userid')>
							#session_base.userid#,
						<cfelse>
							NULL,
						</cfif>
						#now()#,
                        '#attributes.fuseaction#',
                        <cfif isdefined('arguments.is_limited_stock') and len(arguments.is_limited_stock)>#arguments.is_limited_stock#<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.special_code_1') and len(arguments.special_code_1)>'#arguments.special_code_1#'<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.special_code_2') and len(arguments.special_code_2)>'#arguments.special_code_2#'<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.special_code_3') and len(arguments.special_code_3)>'#arguments.special_code_3#'<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.special_code_4') and len(arguments.special_code_4)>'#arguments.special_code_4#'<cfelse>NULL</cfif>,
						'#wrk_id#'
					)
			</cfquery>
			<cfquery name="GET_MAX_ID" datasource="#arguments.dsn_type#">
				SELECT MAX(SPECT_MAIN_ID) AS MAX_ID FROM #new_dsn3#.SPECT_MAIN WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">
			</cfquery>
			<cfset main_spec_id=get_max_id.max_id>
			<cfset is_new_spec = 1>
			<cfquery name="INSRT_STK_ROW" datasource="#arguments.dsn_type#">
				INSERT INTO #dsn2_alias#.STOCKS_ROW 
					(
						STOCK_ID,
						PRODUCT_ID,
						SPECT_VAR_ID
					)
				VALUES 
					(
						#arguments.main_stock_id#,
						#arguments.main_product_id#,
						#main_spec_id#
					)
			</cfquery>
            <!--- Main Spec Satırlarının Oluşturuyor.. --->
            <cfinclude template="../query/add_main_spec_row.cfm">
		<cfelse>
			<cfif arguments.is_control_spect_name eq 1 and isdefined("GET_SPECT")>
				<cfquery name="GET_SPECT_NEW" dbtype="query">
					SELECT * FROM GET_SPECT WHERE SPECT_MAIN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.spec_name#">
				</cfquery>
				<cfif GET_SPECT_NEW.recordcount>
					<cfset main_spec_id=GET_SPECT_NEW.SPECT_MAIN_ID>
				<cfelse>
					<cfset main_spec_id=GET_SPECT.SPECT_MAIN_ID>
				</cfif>
			<cfelse>
				<cfset main_spec_id=GET_SPECT.SPECT_MAIN_ID>
			</cfif>
        	<cfif arguments.spec_is_tree eq 1><!--- Eğerki ürün ağacından ağaç varyasyonlanıyorsa,ağaçta oluşturulan main_spec daha önceden oluşturulmuş ise ağaçın şu andaki    varyasyonu is_tree = 1 olmalıdır o sebeble burda is_tree'yi 1 olarak set edicez. --->
                <cfquery name="upd_main_spec_is_tree" datasource="#arguments.dsn_type#"><!--- İlk önce diğer main_speclerin hepsinin is_tree'sini boşaltıyoruz. --->
                    UPDATE #new_dsn3#.SPECT_MAIN SET IS_TREE = 0 WHERE STOCK_ID = #arguments.MAIN_STOCK_ID#
                </cfquery>
                <cfquery name="upd_main_spec_is_tree" datasource="#arguments.dsn_type#"><!--- daha sonra is_tree'yi 1 olarak set ediyoruz. --->
                    UPDATE #new_dsn3#.SPECT_MAIN SET IS_TREE = 1 WHERE SPECT_MAIN_ID = #main_spec_id#
                </cfquery>
			</cfif>
            <!--- Özelliştirilmiyor ve ÜrünAğacından Güncelleme Yapılıyor İse SpecMain Satırları Güncelleniyor... --->
			<cfif get_product_info_spec.IS_PROTOTYPE eq 0 and isdefined('arguments.upd_spec_main_row') and arguments.upd_spec_main_row eq 1><!--- Eğerki ürün özelleştirilmiyor ise ve main spec'e ait kayıt bulunmuş ise önce main_spec'in satırlarını silicez,daha sonra fonksiyondan gelen değerlerle yeniden set ediyoruz,bu şekilde yeni bir spec oluşmadan ürünün son spec'ini ağacınının son hali ile oluşturmuş oluyoruz..Bir nevi güncelleme! --->
                <!--- Ürün  Konfig. Edilmediği İçin Ürün Ağacındaki En Son Halini Varolan MainSpec'inin satırları yapıyoruz,önce satırları sildik,daha sonra fonksiyona gelen değerlere göre yeniden satırları yazıcaz. --->
                <cfquery name="DELETE_MAIN_SPEC_ROW" datasource="#arguments.dsn_type#">
                    DELETE #new_dsn3#.SPECT_MAIN_ROW WHERE SPECT_MAIN_ID = #GET_SPECT.SPECT_MAIN_ID# 
                </cfquery>
                <!--- Main Spec Satırlarının Oluşturuyor.. --->
                <cfinclude template="../query/add_main_spec_row.cfm">
            </cfif>
		</cfif>
	<cfelse>
		<cfset main_spec_id=arguments.main_spec_id>
	</cfif>
	<cfif arguments.only_main_spec eq 0>
		<!--- fiyatlar : main_specden eklenecekse veya fiyat listeleri yollanmadi ise fiyatlar alinir--->
		<cfif len(main_spec_id) and (isdefined('arguments.add_to_main_spec') and arguments.add_to_main_spec) or (listlen(arguments.product_price_list,',') eq 0 and listlen(arguments.product_money_list,',') eq 0)>
			<cfset product_id_list_2="">
			<cfset stock_id_list_2="">
			<cfif isdefined('arguments.add_to_main_spec') and arguments.add_to_main_spec eq 1><!--- main_specden ekleniyorsa urunler aliniyor listeye atiliyor--->
				<cfquery name="GET_MAIN_SPEC" datasource="#arguments.dsn_type#">
					SELECT 
                    	SPECT_MAIN.SPECIAL_CODE_1,
                        SPECT_MAIN.IS_LIMITED_STOCK,
                        SPECT_MAIN.SPECIAL_CODE_2,
                        SPECT_MAIN.SPECIAL_CODE_3,
                        SPECT_MAIN.SPECIAL_CODE_4,
						SPECT_MAIN.SPECT_MAIN_NAME,
						SPECT_MAIN.SPECT_TYPE,
						SPECT_MAIN.STOCK_ID MAIN_STOCK_ID,
						SPECT_MAIN.PRODUCT_ID MAIN_PRODUCT_ID,
						SPECT_MAIN.IS_TREE,
						SPECT_MAIN_ROW.* 
					FROM 
						#new_dsn3#.SPECT_MAIN SPECT_MAIN,
						#new_dsn3#.SPECT_MAIN_ROW SPECT_MAIN_ROW
					WHERE
						SPECT_MAIN.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_spec_id#">
						AND SPECT_MAIN.SPECT_MAIN_ID=SPECT_MAIN_ROW.SPECT_MAIN_ID
				</cfquery>
				<cfif not GET_MAIN_SPEC.RECORDCOUNT>    
                	<cfdump var="#arguments.main_spec_id# ID Numarasına Sahip Spec in Satirlari yok! Ağacı Kontrol ediniz.">
					<cfabort>
				<cfelse>
					<cfset main_product=GET_MAIN_SPEC.MAIN_PRODUCT_ID>
					<cfset arguments.product_id_list = valuelist(GET_MAIN_SPEC.PRODUCT_ID,',')>
					<cfset arguments.stock_id_list = valuelist(GET_MAIN_SPEC.STOCK_ID,',')>
					<cfset product_id_list_2 = ListAppend(arguments.product_id_list,GET_MAIN_SPEC.MAIN_PRODUCT_ID,',')>
					<cfset stock_id_list_2 = ListAppend(arguments.stock_id_list,GET_MAIN_SPEC.MAIN_STOCK_ID,',')>
				</cfif>
			<cfelseif listlen(arguments.product_id_list,',') and listlen(arguments.stock_id_list,',')><!--- urun listeleri geldi ise --->
				<cfset product_id_list_2=arguments.product_id_list>
				<cfset stock_id_list_2=arguments.stock_id_list>
				<cfset product_id_list_2=listappend(product_id_list_2,arguments.main_product_id,',')>
				<cfset stock_id_list_2=listappend(stock_id_list_2,arguments.main_stock_id,',')>
				<cfset main_product=arguments.main_product_id>
			</cfif>
			<cfset arguments.product_id_list=Replace(arguments.product_id_list,',,',',','all')>
			<cfset arguments.product_id_list=Replace(arguments.product_id_list,', ,',',','all')>
			<cfset arguments.stock_id_list=Replace(arguments.stock_id_list,',,','','all')>
			<cfset arguments.stock_id_list=Replace(arguments.stock_id_list,', ,','','all')>
			<cfset product_id_list_2=Replace(product_id_list_2,',,',',','all')>
			<cfset product_id_list_2=Replace(product_id_list_2,', ,','','all')>
			<cfset stock_id_list_2=Replace(stock_id_list_2,',,','','all')>
			<cfset stock_id_list_2=Replace(stock_id_list_2,', ,','','all')>
			<!--- uyenin fiyat listesini bulmak icin--->
			<cfif arguments.is_purchasesales eq 1><!--- satissa sadece buraya girer alis ise sadece standart alis fiyatini almali --->
				<cfif arguments.company_id gt 0>
					<cfquery name="GET_PRICE_CAT_CREDIT" datasource="#arguments.dsn_type#">
						SELECT PRICE_CAT FROM #dsn_alias#.COMPANY_CREDIT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.company_id#">
					</cfquery>
					<cfif GET_PRICE_CAT_CREDIT.RECORDCOUNT and len(GET_PRICE_CAT_CREDIT.PRICE_CAT)>
						<cfset attributes.price_catid=GET_PRICE_CAT_CREDIT.PRICE_CAT>
					<cfelse>
						<cfquery name="GET_COMP_CAT" datasource="#arguments.dsn_type#">
							SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
						</cfquery>
						<cfquery name="GET_PRICE_CAT_COMP" datasource="#arguments.dsn_type#">
							SELECT PRICE_CATID FROM #dsn3_alias#.PRICE_CAT PRICE_CAT WHERE COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GET_COMP_CAT.COMPANYCAT_ID#,%">
						</cfquery>
						<cfset attributes.price_catid=GET_PRICE_CAT_COMP.PRICE_CATID>
					</cfif>
				</cfif>
				<cfif arguments.consumer_id gt 0>
					<cfquery name="GET_COMP_CAT" datasource="#arguments.dsn_type#">
						SELECT CONSUMER_CAT_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
					</cfquery>
					<cfquery name="GET_PRICE_CAT" datasource="#arguments.dsn_type#">
						SELECT PRICE_CATID FROM #dsn3_alias#.PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
					</cfquery>
					<cfset attributes.price_catid=get_price_cat.PRICE_CATID>
				</cfif>
				<!--- //uyenin fiyat listesini bulmak icin--->
				<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
					<cfquery name="GET_PRICE" datasource="#arguments.dsn_type#">
						SELECT
							PRICE_STANDART.PRODUCT_ID,
							PRICE_STANDART.MONEY,
							PRICE_STANDART.PRICE
						FROM
							#dsn3_alias#.PRICE PRICE_STANDART,	
							#dsn3_alias#.PRODUCT_UNIT PRODUCT_UNIT
						WHERE
							PRICE_STANDART.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
							PRICE_STANDART.STARTDATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.action_date#"> AND 
							(PRICE_STANDART.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.action_date#"> OR PRICE_STANDART.FINISHDATE IS NULL) AND
							PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
							ISNULL(PRICE_STANDART.STOCK_ID,0)=0 AND
							ISNULL(PRICE_STANDART.SPECT_VAR_ID,0)=0 AND
							PRICE_STANDART.PRODUCT_ID IN (#listsort(product_id_list_2,"numeric","ASC",",")#) AND 
							PRODUCT_UNIT.IS_MAIN = 1
					</cfquery>
				</cfif>
			</cfif>
			<cfquery name="GET_PRICE_STANDART" datasource="#arguments.dsn_type#">
				SELECT
					PRICE_STANDART.PRODUCT_ID,
					PRICE_STANDART.MONEY,
					PRICE_STANDART.PRICE
				FROM
					#dsn3_alias#.PRODUCT PRODUCT,
					#dsn3_alias#.PRICE_STANDART PRICE_STANDART
				WHERE
					PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
					PURCHASESALES = <cfif arguments.is_purchasesales eq 1>1<cfelse>0</cfif> AND
					PRICESTANDART_STATUS = 1 AND
					PRODUCT.PRODUCT_ID IN (#listsort(product_id_list_2,"numeric","ASC",",")#)
			</cfquery>
			<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>
				<cfquery name="GET_PRICE_MAIN_PROD" dbtype="query">
					SELECT * FROM GET_PRICE WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_product#">
				  </cfquery>
			</cfif>
			<cfif not isdefined("GET_PRICE_MAIN_PROD") or GET_PRICE_MAIN_PROD.RECORDCOUNT eq 0>
				<cfquery name="GET_PRICE_MAIN_PROD" dbtype="query">
					SELECT * FROM GET_PRICE_STANDART WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_product#">
				</cfquery>
			</cfif>
			<cfscript>
			if(listlen(arguments.product_id_list,',') and listlen(arguments.stock_id_list,','))
			{
				if(not isdefined('arguments.spec_total_value') or not len(arguments.spec_total_value))
				{
					if(GET_PRICE_MAIN_PROD.MONEY eq session_base.money)
					{
						arguments.spec_total_value=GET_PRICE_MAIN_PROD.PRICE;
					}
					else
					{
						//urun fiyati sistem para biriminden farkli ise once sisteme ceviriyoz
						money_pos=listfind(arguments.money_list,GET_PRICE_MAIN_PROD.MONEY,',');
						if(money_pos)
							arguments.spec_total_value=GET_PRICE_MAIN_PROD.PRICE*(listgetat(arguments.money_rate2_list,money_pos,','));
						else
							arguments.spec_total_value=GET_PRICE_MAIN_PROD.PRICE;//para birimi yoksa setup_moneyde direk fiyatı atıyoruz
					}
				}
				arguments.main_prod_price=GET_PRICE_MAIN_PROD.PRICE;
				arguments.main_product_money=GET_PRICE_MAIN_PROD.MONEY;
				if(not isdefined('arguments.spec_other_total_value') or not len(arguments.spec_other_total_value) or not arguments.spec_other_total_value gt 0)arguments.spec_other_total_value=GET_PRICE_MAIN_PROD.PRICE;
				if(not isdefined('arguments.other_money') or not len(arguments.other_money))arguments.other_money=GET_PRICE_MAIN_PROD.MONEY;
				arguments.spec_row_count=listlen(arguments.product_id_list,',');
				for(s=1;s lte arguments.spec_row_count;s=s+1)
				{//product_id 0 dan fakli ise fiyati alinir degilse 0 atiyoz
					if(listgetat(arguments.product_id_list,s,',') gt 0 and isdefined("attributes.price_catid") and len(attributes.price_catid))
						GET_PRICE_PROD = cfquery(SQLString:"SELECT * FROM GET_PRICE WHERE PRODUCT_ID=#listgetat(arguments.product_id_list,s,',')#",Datasource:dsn3,dbtype:1,is_select:1);	
					if(listgetat(arguments.product_id_list,s,',') gt 0 and (not isdefined("GET_PRICE_PROD") or GET_PRICE_PROD.RECORDCOUNT eq 0) and isdefined("cfquery"))
						GET_PRICE_PROD = cfquery(SQLString:"SELECT * FROM GET_PRICE_STANDART WHERE PRODUCT_ID=#listgetat(arguments.product_id_list,s,',')#",Datasource:dsn3,dbtype:1,is_select:1);	
					if(isdefined('GET_PRICE_PROD') and len(GET_PRICE_PROD.PRICE))
					{
						arguments.product_price_list=listappend(arguments.product_price_list,GET_PRICE_PROD.PRICE,',');
						arguments.product_money_list=listappend(arguments.product_money_list,GET_PRICE_PROD.MONEY,',');
					}
					else
					{
						arguments.product_price_list=listappend(arguments.product_price_list,0,',');
						arguments.product_money_list=listappend(arguments.product_money_list,session_base.money,',');
					}
				}
			}
			</cfscript>
		</cfif>
		<cfif len(main_spec_id) and isdefined('arguments.add_to_main_spec') and arguments.add_to_main_spec><!--- spec main spec den eklenecekse listeler oluşturulacak --->		
			<cfscript>
				arguments.stock_id_list='';
				arguments.product_id_list='';
				arguments.line_number_list='';
				arguments.question_id_list='';
				arguments.spec_is_tree=GET_MAIN_SPEC.IS_TREE;
				arguments.spec_type=GET_MAIN_SPEC.SPECT_TYPE;
				arguments.main_stock_id=GET_MAIN_SPEC.MAIN_STOCK_ID;
				arguments.main_product_id=GET_MAIN_SPEC.MAIN_PRODUCT_ID;
				arguments.spec_name=GET_MAIN_SPEC.SPECT_MAIN_NAME;
				
				arguments.special_code_1=GET_MAIN_SPEC.SPECIAL_CODE_1;
				arguments.special_code_2=GET_MAIN_SPEC.SPECIAL_CODE_2;
				arguments.special_code_3=GET_MAIN_SPEC.SPECIAL_CODE_3;
				arguments.special_code_4=GET_MAIN_SPEC.SPECIAL_CODE_4;
				arguments.is_limited_stock=GET_MAIN_SPEC.IS_LIMITED_STOCK;
				//para birimi listelerinden eksik bir deger varsa listeler olusturulacak
				if(listlen(arguments.money_list,',') eq 0 or listlen(arguments.money_rate1_list,',') or listlen(arguments.money_rate2_list,',') eq 0)
				{
					if(isdefined("session.ep.company_id"))
						GET_MONEY_SPEC = cfquery(SQLString:'SELECT MONEY AS MONEY_TYPE,RATE2,RATE1 FROM #dsn_alias#.SETUP_MONEY SETUP_MONEY WHERE COMPANY_ID=#session.ep.company_id# AND PERIOD_ID=#session_base.period_id# AND MONEY_STATUS=1',Datasource:arguments.dsn_type,is_select:1);	
					else
						GET_MONEY_SPEC = cfquery(SQLString:'SELECT MONEY AS MONEY_TYPE,RATE2,RATE1 FROM #dsn_alias#.SETUP_MONEY SETUP_MONEY WHERE COMPANY_ID=#session_base.our_company_id# AND PERIOD_ID=#session_base.period_id# AND MONEY_STATUS=1',Datasource:arguments.dsn_type,is_select:1);	
					
					for(a=1;a lte GET_MONEY_SPEC.RECORDCOUNT;a=a+1)
					{
						arguments.money_list=listappend(arguments.money_list,GET_MONEY_SPEC.MONEY_TYPE[a],',');
						arguments.money_rate1_list=listappend(arguments.money_rate1_list,GET_MONEY_SPEC.RATE1[a],',');
						arguments.money_rate2_list=listappend(arguments.money_rate2_list,GET_MONEY_SPEC.RATE2[a],',');
					}
				}
				if(GET_PRICE_MAIN_PROD.MONEY eq session_base.money)
				{
					arguments.spec_total_value=GET_PRICE_MAIN_PROD.PRICE;
				}
				else
				{
					//urun fiyati sistem para biriminden farkli ise once sisteme ceviriyoz
					money_pos=listfind(arguments.money_list,GET_PRICE_MAIN_PROD.MONEY,',');
					if(money_pos)
						arguments.spec_total_value=GET_PRICE_MAIN_PROD.PRICE*(listgetat(arguments.money_rate2_list,money_pos,','));
					else
							arguments.spec_total_value=GET_PRICE_MAIN_PROD.PRICE;//para birimi yoksa setup_moneyde direk fiyatı atıyoruz
				}
				arguments.main_prod_price=GET_PRICE_MAIN_PROD.PRICE;
				arguments.main_product_money=GET_PRICE_MAIN_PROD.MONEY;
				arguments.spec_other_total_value=GET_PRICE_MAIN_PROD.PRICE;
				arguments.other_money=GET_PRICE_MAIN_PROD.MONEY;

				arguments.spec_row_count=GET_MAIN_SPEC.RECORDCOUNT;
				for(s=1;s lte GET_MAIN_SPEC.RECORDCOUNT;s=s+1)
				{
					if(GET_MAIN_SPEC.STOCK_ID[s] gt 0)
						arguments.stock_id_list=listappend(arguments.stock_id_list,GET_MAIN_SPEC.STOCK_ID[s],',');
					else
						arguments.stock_id_list=listappend(arguments.stock_id_list,0,',');
						
					if(GET_MAIN_SPEC.PRODUCT_ID[s] gt 0)
						arguments.product_id_list=listappend(arguments.product_id_list,GET_MAIN_SPEC.PRODUCT_ID[s],',');
					else
						arguments.product_id_list=listappend(arguments.product_id_list,0,',');
					
					if(len(GET_MAIN_SPEC.PRODUCT_NAME[s]))
						arguments.product_name_list=listappend(arguments.product_name_list,GET_MAIN_SPEC.PRODUCT_NAME[s],ayirac);
					else
						arguments.product_name_list=listappend(arguments.product_name_list,'-',ayirac);
					
					/*if(len(GET_MAIN_SPEC.RELATED_MAIN_SPECT_ID[s]))
						arguments.related_spect_id_list=listappend(arguments.related_spect_id_list,GET_MAIN_SPEC.RELATED_MAIN_SPECT_ID[s],',');
					else
						arguments.related_spect_id_list=listappend(arguments.related_spect_id_list,0,',');
					*/
					if(len(GET_MAIN_SPEC.PRODUCT_NAME[s]))
						arguments.amount_list=listappend(arguments.amount_list,GET_MAIN_SPEC.AMOUNT[s],',');
					else
						arguments.amount_list=listappend(arguments.amount_list,0,',');
	
					if(len(GET_MAIN_SPEC.IS_SEVK[s]))
						arguments.is_sevk_list=listappend(arguments.is_sevk_list,GET_MAIN_SPEC.IS_SEVK[s],',');
					else
						arguments.is_sevk_list=listappend(arguments.is_sevk_list,0,',');
					
					
					if(len(GET_MAIN_SPEC.IS_CONFIGURE[s]))
						arguments.is_configure_list=listappend(arguments.is_configure_list,GET_MAIN_SPEC.IS_CONFIGURE[s],',');
					else
						arguments.is_configure_list=listappend(arguments.is_configure_list,0,',');
					
					if(len(GET_MAIN_SPEC.IS_PROPERTY[s]))
						arguments.is_property_list=listappend(arguments.is_property_list,GET_MAIN_SPEC.IS_PROPERTY[s],',');
					else
						arguments.is_property_list=listappend(arguments.is_property_list,0,',');
	
					if(len(GET_MAIN_SPEC.PROPERTY_ID[s]))
						arguments.property_id_list=listappend(arguments.property_id_list,GET_MAIN_SPEC.PROPERTY_ID[s],',');
					else
						arguments.property_id_list=listappend(arguments.property_id_list,0,',');
					
					//operasyon yada ürünlerin ilişkili product_tree_id'si..
					if(len(GET_MAIN_SPEC.RELATED_TREE_ID[s]))
						arguments.related_tree_id_list=listappend(arguments.related_tree_id_list,GET_MAIN_SPEC.RELATED_TREE_ID[s],',');
					else
						arguments.related_tree_id_list=listappend(arguments.related_tree_id_list,0,',');
					//operasyon_id'si..
					if(len(GET_MAIN_SPEC.OPERATION_TYPE_ID[s]))
						arguments.operation_type_id_list=listappend(arguments.operation_type_id_list,GET_MAIN_SPEC.OPERATION_TYPE_ID[s],',');
					else
						arguments.operation_type_id_list=listappend(arguments.operation_type_id_list,0,',');
					
					
					
					if(len(GET_MAIN_SPEC.VARIATION_ID[s]))
						arguments.variation_id_list=listappend(arguments.variation_id_list,GET_MAIN_SPEC.VARIATION_ID[s],',');
					else
						arguments.variation_id_list=listappend(arguments.variation_id_list,0,',');
					
					if(len(GET_MAIN_SPEC.TOTAL_MIN[s]))
						arguments.total_min_list=listappend(arguments.total_min_list,GET_MAIN_SPEC.TOTAL_MIN[s],',');
					else
						arguments.total_min_list=listappend(arguments.total_min_list,'-',',');
					
					if(len(GET_MAIN_SPEC.TOTAL_MAX[s]))
						arguments.total_max_list=listappend(arguments.total_max_list,GET_MAIN_SPEC.TOTAL_MAX[s],',');
					else
						arguments.total_max_list=listappend(arguments.total_max_list,'-',',');
				
					if(len(GET_MAIN_SPEC.CONFIGURATOR_VARIATION_ID[s]))
						arguments.configurator_variation_id_list=listappend(arguments.configurator_variation_id_list,GET_MAIN_SPEC.CONFIGURATOR_VARIATION_ID[s],',');
					else
						arguments.configurator_variation_id_list=listappend(arguments.configurator_variation_id_list,0,',');
					/*
					if(len(GET_MAIN_SPEC.CHAPTER_ID[s]))
						arguments.chapter_id_list=listappend(arguments.chapter_id_list,GET_MAIN_SPEC.CHAPTER_ID[s],',');
					else
						arguments.chapter_id_list=listappend(arguments.chapter_id_list,0,',');
					*/	
					if(len(GET_MAIN_SPEC.DIMENSION[s]))
						arguments.dimension_list=listappend(arguments.dimension_list,GET_MAIN_SPEC.DIMENSION[s],',');
					else
						arguments.dimension_list=listappend(arguments.dimension_list,'-',',');
						
					/*if(len(GET_MAIN_SPEC.REL_VARIATION_ID[s]))
						arguments.rel_variation_id_list=listappend(arguments.rel_variation_id_list,GET_MAIN_SPEC.REL_VARIATION_ID[s],',');
					else
						arguments.rel_variation_id_list=listappend(arguments.rel_variation_id_list,0,',');
					*/	
					arguments.diff_price_list=listappend(arguments.diff_price_list,0,',');
	
					if(len(GET_MAIN_SPEC.PRODUCT_ID[s]) and isdefined("attributes.price_catid") and len(attributes.price_catid))
						GET_PRICE_PROD = cfquery(SQLString:'SELECT * FROM GET_PRICE WHERE PRODUCT_ID=#GET_MAIN_SPEC.PRODUCT_ID[s]#',Datasource:dsn3,dbtype:1,is_select:1);	
					if(len(GET_MAIN_SPEC.PRODUCT_ID[s]) and (not isdefined("GET_PRICE_PROD") or GET_PRICE_PROD.RECORDCOUNT eq 0))
						GET_PRICE_PROD = cfquery(SQLString:'SELECT * FROM GET_PRICE_STANDART WHERE PRODUCT_ID=#GET_MAIN_SPEC.PRODUCT_ID[s]#',Datasource:dsn3,dbtype:1,is_select:1);	
					if(isdefined('GET_PRICE_PROD') and len(GET_PRICE_PROD.PRICE))
					{
						arguments.product_price_list=listappend(arguments.product_price_list,GET_PRICE_PROD.PRICE,',');
						arguments.product_money_list=listappend(arguments.product_money_list,GET_PRICE_PROD.MONEY,',');
					}
					else
					{
						arguments.product_price_list=listappend(arguments.product_price_list,0,',');
						arguments.product_money_list=listappend(arguments.product_money_list,session_base.money,',');
					}
					
					if(len(GET_MAIN_SPEC.TOLERANCE[s]))
						arguments.tolerance_list=listappend(arguments.tolerance_list,GET_MAIN_SPEC.TOLERANCE[s],',');
					else
						arguments.tolerance_list=listappend(arguments.tolerance_list,'-',',');
					/*if(len(GET_MAIN_SPEC.PRODUCT_SPACE[s]))
						arguments.product_space_list=listappend(arguments.product_space_list,GET_MAIN_SPEC.PRODUCT_SPACE[s],',');
					else
						arguments.product_space_list=listappend(arguments.product_space_list,'-',',');
					if(len(GET_MAIN_SPEC.CALCULATE_TYPE[s]))
						arguments.calculate_type_list=listappend(arguments.calculate_type_list,GET_MAIN_SPEC.CALCULATE_TYPE[s],',');
					else
						arguments.calculate_type_list=listappend(arguments.calculate_type_list,0,',');
					
					if(len(GET_MAIN_SPEC.PRODUCT_DISPLAY[s]))
						arguments.product_display_list=listappend(arguments.product_display_list,GET_MAIN_SPEC.PRODUCT_DISPLAY[s],',');
					else
						arguments.product_display_list=listappend(arguments.product_display_list,'-',',');	
					if(len(GET_MAIN_SPEC.PRODUCT_RATE[s]))
						arguments.product_rate_list=listappend(arguments.product_rate_list,GET_MAIN_SPEC.PRODUCT_RATE[s],',');
					else
						arguments.product_rate_list=listappend(arguments.product_rate_list,'-',',');
					*/	
					if(len(GET_MAIN_SPEC.PRODUCT_LIST_PRICE[s]))
						arguments.list_price_list=listappend(arguments.list_price_list,GET_MAIN_SPEC.PRODUCT_LIST_PRICE[s],',');
					else
						arguments.list_price_list=listappend(arguments.list_price_list,'-',',');
					if(len(GET_MAIN_SPEC.LINE_NUMBER[s]))
						arguments.line_number_list = listappend(arguments.line_number_list,GET_MAIN_SPEC.LINE_NUMBER[s],',');
					else
						arguments.line_number_list  =listappend(arguments.line_number_list,'-',',');
					
					if(len(GET_MAIN_SPEC.QUESTION_ID[s]))
						arguments.question_id_list = listappend(arguments.question_id_list,GET_MAIN_SPEC.QUESTION_ID[s],',');
					else
						arguments.question_id_list  =listappend(arguments.question_id_list,'-',',');	
				}
			</cfscript>
		</cfif>
	</cfif>
	<!--- <cfdump var="#ayirac#">
	<cfabort> --->
	<!--- spec ekleme --->
	<cfif len(main_spec_id) and arguments.only_main_spec eq 0>
		<cfif arguments.insert_spec or is_new_spec eq 1 or arguments.is_control_spect_name eq 1>
			<cfquery name="ADD_VAR_SPECT" datasource="#arguments.dsn_type#">
				INSERT
				INTO
					#new_dsn3#.SPECTS
					(
						SPECT_MAIN_ID,
						SPECT_VAR_NAME,
						SPECT_TYPE,
						PRODUCT_ID,
						STOCK_ID,
						TOTAL_AMOUNT,
						OTHER_MONEY_CURRENCY,
						OTHER_TOTAL_AMOUNT,
						PRODUCT_AMOUNT,
						PRODUCT_AMOUNT_CURRENCY,
						IS_TREE,
						FILE_NAME,
						FILE_SERVER_ID,
						MARJ_TOTAL_AMOUNT,
						MARJ_OTHER_TOTAL_AMOUNT,
						MARJ_AMOUNT,
						MARJ_PERCENT,
						DETAIL,
						RECORD_IP,
						<cfif isDefined("session.pp")>
                            RECORD_PAR,
                        <cfelseif isDefined("session.ww")>
                            RECORD_CONS,
                        <cfelse>
                            RECORD_EMP,
                        </cfif>
						RECORD_DATE,
                        IS_LIMITED_STOCK,
                        SPECIAL_CODE_1,
                        SPECIAL_CODE_2,
                        SPECIAL_CODE_3,
                        SPECIAL_CODE_4,
                        WRK_ID
					)
					VALUES
					(
						#main_spec_id#,
						'#left(arguments.spec_name,500)#',
						#arguments.spec_type#,
						<cfif isdefined("arguments.main_product_id") and len(arguments.main_product_id)>#arguments.main_product_id#<cfelse>NULL</cfif>,
						<cfif isdefined("arguments.main_stock_id") and len(arguments.main_stock_id)>#arguments.main_stock_id#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.spec_total_value') and len(arguments.spec_total_value)>#arguments.spec_total_value#<cfelse>0</cfif>,
						'#arguments.other_money#',
						<cfif len(arguments.spec_other_total_value)>#arguments.spec_other_total_value#<cfelse>0</cfif>,
						<cfif isdefined("arguments.main_prod_price") and len(arguments.main_prod_price)>#arguments.main_prod_price#<cfelse>0</cfif>,
						<cfif len(arguments.main_product_money)>'#arguments.main_product_money#'<cfelse>'#session_base.money#'</cfif>,
						#arguments.spec_is_tree#,
						<cfif len(arguments.spect_file_name)>'#arguments.spect_file_name#'<cfelse>NULL</cfif>,
						<cfif len(arguments.spect_file_name)>#fusebox.server_machine#<cfelse>NULL</cfif>,
						<cfif isdefined('arguments.marj_total_value') and len(arguments.marj_total_value)>#arguments.marj_total_value#<cfelse>0</cfif>,
						<cfif isdefined('arguments.marj_other_total_value') and len(arguments.marj_other_total_value)>#arguments.marj_other_total_value#<cfelse>0</cfif>,
						<cfif isdefined('arguments.marj_amount') and len(arguments.marj_amount)>#arguments.marj_amount#<cfelse>0</cfif>,
						<cfif isdefined('arguments.marj_percent') and len(arguments.marj_percent)>#arguments.marj_percent#<cfelse>0</cfif>,
						<cfif isdefined('arguments.spect_detail') and len(arguments.spect_detail)>'#arguments.spect_detail#'<cfelse>NULL</cfif>,
						'#cgi.remote_addr#',
						<cfif isdefined('session_base.userid')>
							#session_base.userid#,
						<cfelse>
							NULL,
						</cfif>
						#now()#,
                        <cfif isdefined('arguments.is_limited_stock') and len(arguments.is_limited_stock)>#arguments.is_limited_stock#<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.special_code_1') and len(arguments.special_code_1)>'#arguments.special_code_1#'<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.special_code_2') and len(arguments.special_code_2)>'#arguments.special_code_2#'<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.special_code_3') and len(arguments.special_code_3)>'#arguments.special_code_3#'<cfelse>NULL</cfif>,
                        <cfif isdefined('arguments.special_code_4') and len(arguments.special_code_4)>'#arguments.special_code_4#'<cfelse>NULL</cfif>,
						'#wrk_id#'                        
					)
			</cfquery>
			<cfquery name="GET_MAX" datasource="#arguments.dsn_type#">
				SELECT MAX(SPECT_VAR_ID) AS MAX_ID FROM #new_dsn3#.SPECTS WHERE WRK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id#">
			</cfquery>
		<cfelseif isdefined('arguments.spec_id') and len(arguments.spec_id)>
			<cfquery name="UPD_VAR_SPECT" datasource="#arguments.dsn_type#">
				UPDATE
					#new_dsn3#.SPECTS
				SET
					SPECT_MAIN_ID=#main_spec_id#,
					SPECT_VAR_NAME='#arguments.spec_name#',
					SPECT_TYPE=#arguments.spec_type#,
					PRODUCT_ID=<cfif isdefined("arguments.main_product_id") and len(arguments.main_product_id)>#arguments.main_product_id#<cfelse>NULL</cfif>,
					STOCK_ID=<cfif isdefined("arguments.main_stock_id") and len(arguments.main_stock_id)>#arguments.main_stock_id#<cfelse>NULL</cfif>,
					TOTAL_AMOUNT=<cfif len(arguments.spec_total_value)>#arguments.spec_total_value#<cfelse>0</cfif>,
					OTHER_MONEY_CURRENCY='#arguments.main_product_money#',
					OTHER_TOTAL_AMOUNT=<cfif len(arguments.spec_other_total_value)>#arguments.spec_other_total_value#<cfelse>0</cfif>,
					PRODUCT_AMOUNT=<cfif isdefined("arguments.main_prod_price") and len(arguments.main_prod_price)>#arguments.main_prod_price#<cfelse>0</cfif>,
					PRODUCT_AMOUNT_CURRENCY=<cfif len(arguments.main_product_money)>'#arguments.main_product_money#'<cfelse>'#session_base.money#'</cfif>,
					IS_TREE=#arguments.spec_is_tree#,
					<cfif len(arguments.spect_file_name)>
					FILE_NAME='#arguments.spect_file_name#',
					FILE_SERVER_ID=#fusebox.server_machine#,
					</cfif>
					MARJ_TOTAL_AMOUNT=<cfif len(arguments.marj_total_value)>#arguments.marj_total_value#<cfelse>0</cfif>,
					MARJ_OTHER_TOTAL_AMOUNT=<cfif isdefined('arguments.marj_other_total_value') and len(arguments.marj_other_total_value)>#arguments.marj_other_total_value#<cfelse>0</cfif>,
					MARJ_AMOUNT=<cfif len(arguments.marj_amount)>#arguments.marj_amount#<cfelse>0</cfif>,
					MARJ_PERCENT=<cfif len(arguments.marj_percent)>#arguments.marj_percent#<cfelse>0</cfif>,
					DETAIL =<cfif isdefined('arguments.spect_detail') and len(arguments.spect_detail)>'#arguments.spect_detail#'<cfelse>NULL</cfif>,
					UPDATE_IP='#cgi.remote_addr#',
                    <cfif isDefined("session.pp")>
                        UPDATE_PAR=#session_base.userid#,
                    <cfelseif isDefined("session.ww")>
                        UPDATE_CONS=#session_base.userid#,
                    <cfelse>
                        UPDATE_EMP=#session_base.userid#,
                    </cfif>
					UPDATE_DATE=#now()#,
                    SPECIAL_CODE_1 = <cfif isdefined('arguments.special_code_1') and len(arguments.special_code_1)>'#arguments.special_code_1#'<cfelse>NULL</cfif>,
                    SPECIAL_CODE_2 = <cfif isdefined('arguments.special_code_2') and len(arguments.special_code_2)>'#arguments.special_code_2#'<cfelse>NULL</cfif>,
                    SPECIAL_CODE_3 = <cfif isdefined('arguments.special_code_3') and len(arguments.special_code_3)>'#arguments.special_code_3#'<cfelse>NULL</cfif>,
                    SPECIAL_CODE_4 = <cfif isdefined('arguments.special_code_4') and len(arguments.special_code_4)>'#arguments.special_code_4#'<cfelse>NULL</cfif>
				WHERE
					SPECT_VAR_ID=#arguments.spec_id#
			</cfquery>		
			<!--- eger guncelleniyorsa money ve satirlar siliniyor --->
			<cfquery name="DEL_ROW" datasource="#arguments.dsn_type#">
				DELETE FROM #new_dsn3#.SPECTS_ROW WHERE SPECT_ID = #arguments.spec_id#
			</cfquery>
			<cfif listlen(arguments.money_list,',') and listlen(arguments.money_rate1_list,',') and listlen(arguments.money_rate2_list,',')>
			<!--- guncelleme islemi sirasinda para birimi ve kur listeleri gelmezse kur degerleri silinmiyor ve eski degerleri ile kaliyor --->
				<cfquery name="DEL_MONEY_ROW" datasource="#arguments.dsn_type#">
					DELETE FROM #new_dsn3#.SPECT_MONEY WHERE ACTION_ID =#arguments.spec_id#
				</cfquery>
			</cfif>
			<cfset get_max.max_id=arguments.spec_id>
		</cfif>
		<cfif arguments.insert_spec or is_new_spec eq 1 or (listlen(arguments.money_list,',') and listlen(arguments.money_rate1_list,',') and listlen(arguments.money_rate2_list,','))>
		<!---*** yeni spec ekleme ise mutlaka girmeli (money listeleri yollanmalı) ancak guncelleme ve main specden ekleme ise degerler gelmedi ise girmesin --->
			<cfloop from="1" to="#listlen(arguments.money_list,',')#" index="xx">
				<cfscript>
					spec_money_type=listgetat(arguments.money_list,xx,',');
					spec_txt_rate1=listgetat(arguments.money_rate1_list,xx,',');
					spec_txt_rate2=listgetat(arguments.money_rate2_list,xx,',');
					if(spec_money_type eq spec_money_select)spec_money_check=1; else spec_money_check=0;
				</cfscript>
				<cfquery name="add_spec_money" datasource="#arguments.dsn_type#">
					INSERT INTO
						#new_dsn3#.SPECT_MONEY
						(
							MONEY_TYPE,
							ACTION_ID,
							RATE2,
							RATE1,
							IS_SELECTED
						)
					VALUES
						(
							'#spec_money_type#',
							#get_max.max_id#,
							#spec_txt_rate2#,
							#spec_txt_rate1#,
							#spec_money_check#
						)
				</cfquery>
			</cfloop>
		</cfif>
		<cfloop from="1" to="#arguments.spec_row_count#" index="zz">
			<cfscript>
				form_product_name = listgetat(arguments.product_name_list,zz,ayirac);
				form_product_id = listgetat(arguments.product_id_list,zz,',');
				form_stock_id = listgetat(arguments.stock_id_list,zz,',');
				if(len(amount_list))
					form_amount = listgetat(arguments.amount_list,zz,',');
				else
					form_amount = '';	
				if(len(diff_price_list))
					form_diff_price = listgetat(arguments.diff_price_list,zz,',');
				else
					form_diff_price = '';	
				form_total_amount = listgetat(arguments.product_price_list,zz,',');
				form_value_money_type =  listgetat(arguments.product_money_list,zz,',');
				form_is_property = listgetat(arguments.is_property_list,zz,',');
				form_is_configure = listgetat(arguments.is_configure_list,zz,',');
				form_property_id = listgetat(arguments.property_id_list,zz,',');
				form_variation_id = listgetat(arguments.variation_id_list,zz,',');
				form_total_min = listgetat(arguments.total_min_list,zz,',');
				form_total_max = listgetat(arguments.total_max_list,zz,',');
				
				if(isdefined('arguments.related_tree_id_list') and len(arguments.related_tree_id_list))
					form_related_tree_id = listgetat(arguments.related_tree_id_list,zz,',');
				if(isdefined('arguments.operation_type_id_list') and len(arguments.operation_type_id_list))
					form_operation_type_id = listgetat(arguments.operation_type_id_list,zz,',');
				
				if(isdefined('arguments.configurator_variation_id_list') and len(arguments.configurator_variation_id_list) and listlen(arguments.configurator_variation_id_list) gte zz) form_configurator_variation_id=listgetat(arguments.configurator_variation_id_list,zz,',');
				//if(isdefined('arguments.chapter_id_list') and len(arguments.chapter_id_list)) form_chapter_id=listgetat(arguments.chapter_id_list,zz,',');
				if(isdefined('arguments.dimension_list') and len(arguments.dimension_list)) form_dimention=listgetat(arguments.dimension_list,zz,',');
				//if(isdefined('arguments.rel_variation_id_list') and len(arguments.rel_variation_id_list)) form_rel_variation_id=listgetat(arguments.rel_variation_id_list,zz,',');
				if(isdefined('arguments.tolerance_list') and len(arguments.tolerance_list)) form_tolerance = listgetat(arguments.tolerance_list,zz,',');
				if(isdefined('arguments.is_sevk_list') and len(arguments.is_sevk_list)) form_is_sevk = listgetat(arguments.is_sevk_list,zz,',');
				
				if (len(arguments.product_space_list)){form_product_space = listgetat(arguments.product_space_list,zz,',');}
				if (len(arguments.product_display_list)){form_product_display = listgetat(arguments.product_display_list,zz,',');}
				if (len(arguments.product_rate_list)){form_product_rate = listgetat(arguments.product_rate_list,zz,',');}
				if (len(arguments.list_price_list)){form_list_price = listgetat(arguments.list_price_list,zz,',');}
				//if (len(arguments.calculate_type_list)){form_calculate_type = listgetat(arguments.calculate_type_list,zz,',');}
				if (len(arguments.related_spect_id_list)){form_related_spect_id = listgetat(arguments.related_spect_id_list,zz,',');}
				if (isDefined("arguments.question_id_list") and len(arguments.question_id_list)){form_question_id= listgetat(arguments.question_id_list,zz,',');}
				
				if (isdefined('arguments.line_number_list') and len(arguments.line_number_list) and listlen(arguments.line_number_list) gte zz )
					form_line_number = listgetat(arguments.line_number_list,zz,',');
			
			</cfscript>

			<cfquery name="ADD_ROW" datasource="#arguments.dsn_type#">
				INSERT
				INTO
					#new_dsn3#.SPECTS_ROW
					(
						SPECT_ID,
						PRODUCT_ID,
						STOCK_ID,
						AMOUNT_VALUE,
						TOTAL_VALUE,
						MONEY_CURRENCY,
						PRODUCT_NAME,
						IS_PROPERTY,
						IS_CONFIGURE,
						DIFF_PRICE,

						PROPERTY_ID,
						VARIATION_ID,
						TOTAL_MIN,
						TOTAL_MAX,
						TOLERANCE,
						IS_SEVK,
						PRODUCT_SPACE,
						PRODUCT_DISPLAY,
						PRODUCT_RATE,
						PRODUCT_LIST_PRICE,
                        LINE_NUMBER,
                        CONFIGURATOR_VARIATION_ID,
                        DIMENSION,
                        RELATED_TREE_ID,
                        OPERATION_TYPE_ID,
						RELATED_SPECT_ID						
					<!--- CALCULATE_TYPE,
                        <!--- CHAPTER_ID,	,
                        <!--- ,REL_VARIATION_ID --->
                        ,
                        ,
                        QUESTION_ID ---> --->
                        

					)
					VALUES
					(
						#get_max.max_id#,
						<cfif form_product_id gt 0>#form_product_id#<cfelse>NULL</cfif>,
						<cfif form_stock_id gt 0>#form_stock_id#<cfelse>NULL</cfif>,
						<cfif isdefined('form_amount') and len(form_amount)>#form_amount#<cfelse>NULL</cfif>,
						<cfif len(form_total_amount)>#form_total_amount#<cfelse>0</cfif>,
						'#form_value_money_type#',
						<cfif len(form_product_name)>'#form_product_name#'<cfelse>NULL</cfif>,
						#form_is_property#,
						#form_is_configure#,
						<cfif len(form_diff_price)>#form_diff_price#<cfelse>0</cfif>,

						<cfif form_property_id gt 0>#form_property_id#<cfelse>NULL</cfif>,
						<cfif form_variation_id gt 0>#form_variation_id#<cfelse>NULL</cfif>,
						<cfif form_total_min neq '-'>#form_total_min#<cfelse>NULL</cfif>,
						<cfif form_total_max neq '-'>#form_total_max#<cfelse>NULL</cfif>,
						<cfif form_tolerance neq '-'>#form_tolerance#<cfelse>NULL</cfif>,
						#form_is_sevk#,
						<cfif isdefined('form_product_space') and form_product_space gt 0>#form_product_space#<cfelse>NULL</cfif>,
						<cfif isdefined('form_product_display') and form_product_display gt 0>#form_product_display#<cfelse>NULL</cfif>,
						<cfif isdefined('form_product_rate') and form_product_rate gt 0>#form_product_rate#<cfelse>NULL</cfif>,
						<cfif isdefined('form_list_price') and form_list_price gt 0>#form_list_price#<cfelse>NULL</cfif>,
						<cfif isdefined('form_line_number') and form_line_number GT 0>#form_line_number#<cfelse>NULL</cfif>,
                        <cfif isdefined('form_configurator_variation_id') and form_configurator_variation_id gt 0>#form_configurator_variation_id#<cfelse>NULL</cfif>,
                        <cfif isdefined('form_dimention') and form_dimention neq '-'>#form_dimention#<cfelse>NULL</cfif>,
                        <cfif isdefined('form_related_tree_id') and form_related_tree_id gt 0>#form_related_tree_id#<cfelse>NULL</cfif>,
                        <cfif isdefined('form_operation_type_id') and  form_operation_type_id gt 0>#form_operation_type_id#<cfelse>NULL</cfif>,
					<cfif isdefined('form_related_spect_id') and form_related_spect_id GT 0>#form_related_spect_id#<cfelse>NULL</cfif>						
					<!--- ,
						<!--- <cfif isdefined('form_calculate_type') and len(form_calculate_type)>#form_calculate_type#<cfelse>NULL</cfif>, --->
						,
						<!--- <cfif isdefined('form_chapter_id') and form_chapter_id gt 0>#form_chapter_id#<cfelse>NULL</cfif>, --->
                        ,<!--- ,
						<cfif isdefined('form_rel_variation_id') and form_rel_variation_id gt 0>#form_rel_variation_id#<cfelse>NULL</cfif> --->
                        <cfif isdefined('form_related_tree_id') and form_related_tree_id gt 0>#form_related_tree_id#<cfelse>NULL</cfif>,
                        ,
                        <cfif isdefined('form_question_id') and  form_question_id gt 0>#form_question_id#<cfelse>NULL</cfif> --->
					)
			</cfquery>
		</cfloop>
	</cfif>
	<cfquery name="get_spect_cost_f" datasource="#arguments.dsn_type#" maxrows="1"><!--- Ürünün geçerli maliyetini getiriyor.--->
		SELECT 
			PRODUCT_COST,
			PURCHASE_NET_SYSTEM,
			PURCHASE_EXTRA_COST_SYSTEM 
		FROM 
			#dsn1_alias#.PRODUCT_COST AS PRODUCT_COST 
		WHERE 
			SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#main_spec_id#"> AND
			START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.action_date#">
		ORDER BY 
			RECORD_DATE DESC,START_DATE DESC
	</cfquery>
	<cfif get_spect_cost_f.recordcount and len(get_spect_cost_f.PRODUCT_COST)>
		<cfset toplam_spec_maliyet = get_spect_cost_f.PRODUCT_COST>
		<cfset toplam_spec_maliyet_system = get_spect_cost_f.PURCHASE_NET_SYSTEM>
		<cfset toplam_spec_maliyet_extra_system = get_spect_cost_f.PURCHASE_EXTRA_COST_SYSTEM>
	<cfelse>
		<cfset toplam_spec_maliyet = 0>
		<cfset toplam_spec_maliyet_system = 0>
		<cfset toplam_spec_maliyet_extra_system = 0>
	</cfif>
	<cfif not len(arguments.spec_other_total_value)><cfset arguments.spec_other_total_value = 0></cfif>
	<cfif not len(arguments.main_product_money)><cfset arguments.main_product_money = 0></cfif>
	<cfif arguments.only_main_spec>
		<cfset spec_return='#main_spec_id#,0,#replace(arguments.spec_name,',','','all')#,0,0,#session_base.money#,0,#session_base.money#,0,0,#is_new_spec#'>
	<cfelse>
		<cfset spec_return='#main_spec_id#,#get_max.max_id#,#replace(arguments.spec_name,',','','all')#,#arguments.spec_total_value#,#arguments.spec_other_total_value#,#arguments.other_money#,#toplam_spec_maliyet#,#arguments.main_product_money#,#toplam_spec_maliyet_system#,#toplam_spec_maliyet_extra_system#,#is_new_spec#'>
	</cfif>
	<cfreturn spec_return>
</cffunction>
</cfprocessingdirective>
<cfsetting enablecfoutputonly="no">
<!---
a=specer(
		dsn_type:dsn3,
		main_spec_id=492,
		add_to_main_spec=1,
		company_id=6
	);

a=specer(
			dsn_type : dsn3,
			insert_spec : 1,
			spec_type : 1,
			spec_is_tree : 0,
			main_stock_id : 4,
			main_product_id : 4,
			spec_name : 'sadas',
			spec_total_value : 150,
			main_product_money : 'YTL',
			spec_other_total_value : 100,
			other_money : 'USD',
			money_list : 'YTL,USD,EURO',
			money_rate1_list : '1,1.5,1.7',
			money_rate2_list : '1,1,1',
			spec_row_count : 4,
			stock_id_list : '1,2,5,6',
			product_id_list : '1,2,5,6',
			product_name_list : 'a,b,c,d',
			amount_list : '1,2,2,2',
			is_sevk_list : '0,0,0,1',	
			is_configure_list : '1,0,0,0',
			is_property_list : '1,0,0,0',
			property_id_list : '1,0,0,0',
			variation_id_list : '0,0,0,0',
			total_min_list : '-,-,-,-',
			total_max_list : '-,-,-,-',
			diff_price_list : '0,0,0,0',
			product_price_list : '10,50,60,30',
			product_money_list : 'YTL,YTL,YTL,YTL',
			tolerance_list : '-,-,-,-'
		);

a=specer(
			dsn_type:dsn3,
			insert_spec:0,
			spec_id=100,
			spec_type:1,
			spec_is_tree:0,
			main_stock_id:4,
			main_product_id:4,
			spec_name:'sadas',
			spec_total_value:150,
			main_product_money:'YTL',
			spec_other_total_value:100,
			other_money:'USD',
			money_list:'YTL,USD,EURO',
			money_rate1_list:'1,1.5,1.7',
			money_rate2_list:'1,1,1',
			spec_row_count:4,
			stock_id_list:'1,2,5,6',
			product_id_list:'1,2,5,6',
			product_name_list:'a,b,c,d',
			amount_list:'1,2,2,2',
			is_sevk_list:'0,0,0,1',	
			is_configure_list:'1,0,0,0',
			is_property_list:'1,0,0,0',
			property_id_list:'1,0,0,0',
			variation_id_list:'0,0,0,0',
			total_min_list:'-,-,-,-',
			total_max_list : '-,-,-,-',
			diff_price_list : '0,0,0,0',
			product_price_list : '10,50,60,30',
			product_money_list : 'YTL,YTL,YTL,YTL',
			tolerance_list : '-,-,-,-'
		);
 --->
