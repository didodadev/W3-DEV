<!--- dosya formatı form ekranıda yazıyor ürün kayıt tipi 0 olacaksa mutlaka dosyadaki ondan önceki kayıt tipi 1 olan ürünün onun üst ürünü olmalıdır--->
<cfsetting showdebugoutput="no">
<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" fileField = "uploaded_file" destination = "#upload_folder#" nameConflict = "MakeUnique" mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='63329.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>

<cftry>
<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
<cffile action="delete" file="#upload_folder##file_name#">
<cfcatch>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='63330.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.'>");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
</cfscript>
<cfset counter = 0>
<cfset liste = "">

<cfloop from="2" to="#line_count#" index="i">
	<cfset j = 1>
	<cfset error_flag = 0>
	<cfset is_problem = 0>
	<cfset barcode_no_list="">
	 <cftry> 
		<cfscript>
		counter = counter + 1;
		if(right(dosya[i],1) is ';')
		{
			dosya[i] = dosya[i] & ' ';
		}
		kayit_tipi = Listgetat(dosya[i],j,";");
		if (kayit_tipi eq "1" or kayit_tipi eq "0")
		{
			//kayıt tipi
			kayit_tipi = trim(kayit_tipi);
		}else
		{
			kayit_tipi="1";//kayit tipi boş geliyorsa 1 atıyoruz
		}
		j=j+1;
		
		//barcode no
		barcode_no = Listgetat(dosya[i],j,";");
		barcode_no=trim(barcode_no);
		barcode_no_list =ListAppend(barcode_no_list,barcode_no,',');
		j=j+1;
		
		//barcodeno2
		barcode_no2 = Listgetat(dosya[i],j,";");
		barcode_no2 = trim(barcode_no2);
		barcode_no_list =ListAppend(barcode_no_list,barcode_no2,',');
		j=j+1;
		
		//urun adi
		urun_adi = Listgetat(dosya[i],j,";");
		if(Left(urun_adi,1) is '"') urun_adi = mid(urun_adi,2,len(urun_adi)-2);
		urun_adi = left(trim(urun_adi),250);
		j=j+1;
	
		//cesit_adı
		cesit_adi = Listgetat(dosya[i],j,";");
		cesit_adi = left(trim(cesit_adi),100);
		j=j+1;
	
		//birim
		birim= Listgetat(dosya[i],j,";");
		birim = trim(birim);
		j=j+1;	
		
		//alis_kdv
		alis_kdv = Listgetat(dosya[i],j,";");
		alis_kdv = trim(alis_kdv);
		alis_kdv=Replace(alis_kdv,',','.');
		if(not isnumeric(alis_kdv))
		{ alis_kdv = 0; }
		j=j+1;
		
		//satis_kdv
		satis_kdv = Listgetat(dosya[i],j,";");
		satis_kdv = trim(satis_kdv);
		satis_kdv=Replace(satis_kdv,',','.');
		if(not isnumeric(satis_kdv))
		{ satis_kdv = 0; }
		j=j+1;
		
		//alis_fiyat_kdvli
		alis_fiyat_kdvli = Listgetat(dosya[i],j,";");
		alis_fiyat_kdvli = trim(alis_fiyat_kdvli);
		alis_fiyat_kdvli=Replace(alis_fiyat_kdvli,',','.');
		j=j+1;
		
		//alis_fiyat_kdvsiz
		alis_fiyat_kdvsiz = Listgetat(dosya[i],j,";");
		alis_fiyat_kdvsiz = trim(alis_fiyat_kdvsiz);
		alis_fiyat_kdvsiz=Replace(alis_fiyat_kdvsiz,',','.');
		j=j+1;
		
		//Alis Money
		purchase_money = Listgetat(dosya[i],j,";");
		purchase_money = trim(purchase_money);
		j=j+1;
	
		//satis_fiyat_kdvli
		satis_fiyat_kdvli = Listgetat(dosya[i],j,";");
		satis_fiyat_kdvli = trim(satis_fiyat_kdvli);
		satis_fiyat_kdvli=Replace(satis_fiyat_kdvli,',','.');
		j=j+1;
		
		//satis_fiyat_kdvsiz
		satis_fiyat_kdvsiz = Listgetat(dosya[i],j,";");
		satis_fiyat_kdvsiz = trim(satis_fiyat_kdvsiz);
		satis_fiyat_kdvsiz=Replace(satis_fiyat_kdvsiz,',','.');
		j=j+1;
		
		//Satis Money
		sales_money = Listgetat(dosya[i],j,";");
		sales_money = trim(sales_money);
		j=j+1;
	
		//kategori_id
		kategori_id = Listgetat(dosya[i],j,";");
		kategori_id = trim(kategori_id);
		j=j+1;
	
		//uye_kodu
		uye_kodu = Listgetat(dosya[i],j,";");
		uye_kodu = trim(uye_kodu);
		j=j+1;
	
		//uretici_urun_kodu
		uretici_urun_kodu = Listgetat(dosya[i],j,";");
		uretici_urun_kodu = trim(uretici_urun_kodu);
		j=j+1;
		
		//fiyat_yetkisi
		fiyat_yetkisi = Listgetat(dosya[i],j,";");
		fiyat_yetkisi = trim(fiyat_yetkisi);
		j=j+1;
		
		//surec_id
		surec_id = Listgetat(dosya[i],j,";");
		surec_id = trim(surec_id);
		j=j+1;
		
		//Ozel Kod(PRODUCT_CODE_2)
		product_code_2 = Listgetat(dosya[i],j,";");
		product_code_2 = trim(product_code_2);
		j=j+1;
	
		//Marka (BRAND_ID)
		brand_id = Listgetat(dosya[i],j,";");
		brand_id = trim(brand_id);
		j=j+1;
		
		//Model (SHORT_CODE)
		short_code_id = Listgetat(dosya[i],j,";");
		short_code_id = trim(short_code_id);
		j=j+1;
		
		//açıklama (PRODUCT_DETAIL)
		detail = Listgetat(dosya[i],j,";");
		detail = left(trim(detail),255);
		j=j+1;
		
		//açıklama2 (PRODUCT_DETAIL2)
		
		detail_2 = Listgetat(dosya[i],j,";");
		detail_2 = left(trim(detail_2),255);
		j=j+1;
		
		//inventory
		if(listlen(dosya[i],';') gte j)
		{
			is_inventory = Listgetat(dosya[i],j,";");
			is_inventory = trim(is_inventory);
			j=j+1;
		}				
		else
		{
			is_inventory = '';
			j=j+1;
		}
		
		is_production = Listgetat(dosya[i],j,";");
		is_production = trim(is_production);
		j=j+1;
		
		is_sales = Listgetat(dosya[i],j,";");
		is_sales = trim(is_sales);
		j=j+1;
		
		is_purchase = Listgetat(dosya[i],j,";");
		is_purchase = trim(is_purchase);
		j=j+1;
		
		is_internet = Listgetat(dosya[i],j,";");
		is_internet = trim(is_internet);
		j=j+1;
		
		is_extranet = Listgetat(dosya[i],j,";");
		is_extranet = trim(is_extranet);
		j=j+1;
		
		//sıfır stok
		is_zero_stock = Listgetat(dosya[i],j,";");
		is_zero_stock = trim(is_zero_stock);
		j=j+1;
		
		//stoklarla sınırlı
		is_limited_stock = Listgetat(dosya[i],j,";");
		is_limited_stock = trim(is_limited_stock);
		j=j+1;
		
		//kalite takip ediliyor
		is_quality = Listgetat(dosya[i],j,";");
		is_quality = trim(is_quality);
		j=j+1;
		
		//min marj
		min_margin = Listgetat(dosya[i],j,";");
		min_margin = trim(min_margin);
		min_margin=Replace(min_margin,',','.');
		j=j+1;
		
		//max marj
		max_margin = Listgetat(dosya[i],j,";");
		max_margin = trim(max_margin);
		max_margin=Replace(max_margin,',','.');
		j=j+1;
		
		//muhasebe kod id
		account_code = Listgetat(dosya[i],j,";");
		account_code = trim(account_code);
		j=j+1;
		
		//raf ömrü
		shelf_life = Listgetat(dosya[i],j,";");
		shelf_life = trim(shelf_life);
		j=j+1;
		
		//birim boyut
		dimention = Listgetat(dosya[i],j,";");
		dimention = trim(dimention);
		dimention=Replace(dimention,',','.');
		j=j+1;
		
		//birim hacim
		volume = Listgetat(dosya[i],j,";");
		volume = trim(volume);
		volume=Replace(volume,',','.');
		j=j+1;
		
		//birim ağırlık
		weight = Listgetat(dosya[i],j,";");
		weight = trim(weight);
		weight=Replace(weight,',','.');
		j=j+1;
		
		//hedef pazar
		segment_id = Listgetat(dosya[i],j,";");
		segment_id = trim(segment_id);
		segment_id=Replace(segment_id,',','.');

		//bsmv
		if(listlen(dosya[i],';') gte j)
		{
			bsmv = Listgetat(dosya[i],j,";");
			bsmv = trim(bsmv);
			bsmv=Replace(bsmv,',','.');
			if(not isnumeric(bsmv))
			{ bsmv = 0; }
			j=j+1;
		}else{
			bsmv="";
		}

		//oiv
		if(listlen(dosya[i],';') gte j)
		{
			oiv = Listgetat(dosya[i],j,";");
			oiv = trim(oiv);
			oiv=Replace(oiv,',','.');
			if(not isnumeric(oiv))
			{ oiv = 0; }
			j=j+1;
		}else{
			oiv="";
		}
		</cfscript>
		 <cfcatch type="Any">
			<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='63328.satır 1. adımda sorun oluştu'> <br/>
			<cfset error_flag = 1>
		</cfcatch>
	</cftry>	 

	<cfif error_flag eq 0 and len(urun_adi)>
		<cfif not len(surec_id)> 
				<cfoutput>#i#.<cf_get_lang dictionary_id='63327.Satır İçin süreç Giriniz'> !</cfoutput><br/>
				<cfset error_flag = 1>
		</cfif>
		<!---barkod no_1 varmı--->
		<cfif len(barcode_no) gt 0>
			<cfquery name="CHECK_SAME" datasource="#dsn1#">
				SELECT BARCODE FROM STOCKS_BARCODES WHERE BARCODE = '#barcode_no#'
			</cfquery>
			<cfif check_same.recordcount>
				<cfoutput>#i#.satır - #barcode_no#</cfoutput> barcode var<br/>
				<cfset error_flag = 1>
			</cfif>
		</cfif>
	
		<!---barkod no_2 varmı--->
		<cfif error_flag eq 0 and len(barcode_no2) gt 0 and listlen(barcode_no_list,',') eq 2>
			<cfquery name="CHECK_SAME" datasource="#dsn1#">
				SELECT BARCODE FROM STOCKS_BARCODES WHERE BARCODE = '#barcode_no#'
			</cfquery>
			<cfif check_same.recordcount>
				<cfoutput>#i#.satır - #barcode_no2#</cfoutput> barcode var<br/>
				<cfset error_flag = 1>
			</cfif>
		</cfif>
		
		<!---ürün adı kontrolü--->
		<cfif not isdefined("attributes.is_product_name")><!---  and attributes.is_product_name neq 1 --->
			<cfif error_flag eq 0 and len(urun_adi) and kayit_tipi is 1>
				<cfquery name="CHECK_SAME" datasource="#dsn1#">
					SELECT P.PRODUCT_ID FROM PRODUCT P WHERE P.PRODUCT_NAME = '#urun_adi#'
				</cfquery>
				<cfif check_same.recordcount>
					<cfoutput>#i#.satır - #barcode_no# - #urun_adi#</cfoutput> ürün adı var.<br/>
					<cfset error_flag = 1>
				</cfif>
			</cfif>
		</cfif>

		<cfif error_flag neq 1>			
			<!---kayıt tipine göre kayıt işlimi çalışıyor---->
			<cfif len(kategori_id) and isNumeric(kategori_id)>
				<!--- ürün kodunu hierarchye göre oluşturalım--->
				<cfquery name="GET_PRODUCT_CAT" datasource="#dsn1#">
					SELECT HIERARCHY FROM PRODUCT_CAT WHERE PRODUCT_CATID = #kategori_id#
				</cfquery>
				<cfset attributes.HIERARCHY=get_product_cat.HIERARCHY>
			<cfelse>
				<!---kategori yoksa default HIERARCHY numarası--->
				<cfset attributes.HIERARCHY=attributes.default_hierarchy>
				<cfset kategori_id=attributes.default_kategori>
			</cfif>

			<cfif len(kayit_tipi) and len(birim) and len(urun_adi) and len(kategori_id)>
				<cfif kayit_tipi is 1 or len(kayit_tipi) eq 0>
					<cftransaction>
						<cfinclude template="add_import_product.cfm">
						<cfinclude template="add_import_product_barcode.cfm">
					</cftransaction>
					<cfset attributes.pid = GET_PID.PRODUCT_ID>
					<cfset attributes.pcode = attributes.PRODUCT_CODE>
				<cfelseif kayit_tipi is 0 and isdefined("attributes.pid") and len(attributes.pid)>
					<cfinclude template="add_import_product_stock.cfm">
					<cfinclude template="add_import_product_barcode.cfm">
				</cfif>
				<cfif barcode_no2 gt 0><!---2. barcod kayıt ediliyor--->
					<cfset barcode_no=trim(barcode_no2)>
					<cfinclude template="add_import_product_barcode.cfm">
				</cfif>
			<cfelseif not len(kategori_id)>
				<cfoutput>#i#</cfoutput>.<cf_get_lang dictionary_id='63326.satırda kategori bilgisi eksik'> ...<br/>
				<cfset is_problem = 1>
			</cfif> 	
		</cfif>
	<cfelse>
		<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='63325.satırda ürün adı yok veya hata var'>...<br/>
		<cfset is_problem = 1>
	</cfif>
	<cfif is_problem eq 1 or error_flag eq 1>
		<cf_get_lang dictionary_id='63324.Sorunlu kayıtların barcod noları ve sıraları lütfen bu kayıtları kontrol ediniz'> : <br/>
	<cfelse>
		<cf_get_lang dictionary_id='63248.Sorunsuz Kayıt Yapıldı'>.<br />
		<script type="text/javascript"> 
			window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_product_import</cfoutput>";
		</script>
	</cfif>
</cfloop>
<cfoutput><cf_get_lang dictionary_id='44638.Toplam belge satır sayısı'>: #counter# !!!</cfoutput>
<script type="text/javascript"> 
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_product_import</cfoutput>";
</script>