<cfset upload_folder = "#upload_folder#reserve_files#dir_seperator#">
<cftry>
	<cffile action="UPLOAD"
			filefield="fileToUpload"
			destination="#upload_folder#"
			mode="777"
			nameconflict="MAKEUNIQUE">
		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset attributes.fileToUpload = '#file_name#.#cffile.serverfileext#'>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>

<cftry>
	<cfspreadsheet 
	action="read" 
	src="#upload_folder##file_name#.#cffile.serverfileext#" 
	query="qData"
	>
	
	<cfset attributes.is_product_name = "1">
	<cfset i = 1>
	<cfloop from="2" to="#qData.recordcount#" index="aaa">
		<cfset i = i + 1>

		<cfset PRODUCT_DETAIL = qData.col_2[aaa]>
		<cfset p_code_wrk = qData.col_3[aaa]>
		<cfset barcode_ = qData.col_6[aaa]>		
		<cfif not len(barcode_)>
			<cfset barcode_ = p_code_wrk>
		</cfif>		
		<cfset cat_id_ = attributes.PRODUCT_CATID>
		<cfset surec_id = 65>
		
		<cfset uye_kodu = "">
		
		<cfquery name="GET_COMPANY" datasource="#DSN#">
			SELECT MEMBER_CODE,COMPANY_ID FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
		</cfquery>
		<cfif GET_COMPANY.recordcount>
			<cfset uye_kodu = GET_COMPANY.MEMBER_CODE>
		</cfif>			
		
		<cfset carpan = 1>
		<cfset error_flag = 0>
		<cfset is_problem = 0>
		<cfset barcode_no_list="">
		 <cftry> 
			<cfscript>
			counter = 0;
			counter = counter + 1;
			j = 0;
			kayit_tipi = 1;
			
			//barcode no
			barcode_no = barcode_;
			barcode_no=trim(barcode_no);
			barcode_no_list =ListAppend(barcode_no_list,barcode_no,',');
			j=j+1;
			
			//kategori_id
			kategori_id = cat_id_;
			kategori_id = trim(kategori_id);
			j=j+1;
		
			
			//barcodeno2
			barcode_no2 = '';
			barcode_no2 = trim(barcode_no2);
			barcode_no_list =ListAppend(barcode_no_list,barcode_no2,',');
			j=j+1;
			
			//urun adi
			urun_adi = p_code_wrk;
			if(Left(urun_adi,1) is '"') urun_adi = mid(urun_adi,2,len(urun_adi)-2);
			urun_adi = left(trim(urun_adi),250);
			j=j+1;
		
			//cesit_adı
			cesit_adi = '';
			cesit_adi = left(trim(cesit_adi),100);
			j=j+1;
		
			//birim
			birim= 'Piece';
			birim = trim(birim);
			j=j+1;	
			
			//alis_kdv
			alis_kdv = 0;
			alis_kdv = trim(alis_kdv);
			alis_kdv=Replace(alis_kdv,',','.');
			if(not isnumeric(alis_kdv))
			{ alis_kdv = 0; }
			j=j+1;
			
			//satis_kdv
			satis_kdv = 0;
			satis_kdv = trim(satis_kdv);
			satis_kdv=Replace(satis_kdv,',','.');
			if(not isnumeric(satis_kdv))
			{ satis_kdv = 0; }
			j=j+1;
			
			//alis_fiyat_kdvli
			alis_fiyat_kdvli = 0;
			alis_fiyat_kdvli = trim(alis_fiyat_kdvli);
			alis_fiyat_kdvli=Replace(alis_fiyat_kdvli,',','.');
			j=j+1;
			
			//alis_fiyat_kdvsiz
			alis_fiyat_kdvsiz = 0;
			alis_fiyat_kdvsiz = trim(alis_fiyat_kdvsiz);
			alis_fiyat_kdvsiz=Replace(alis_fiyat_kdvsiz,',','.');
			j=j+1;
			
			//Alis Money
			purchase_money = 'USD';
			purchase_money = trim(purchase_money);
			j=j+1;
		
			//satis_fiyat_kdvli
			satis_fiyat_kdvli = 0;
			satis_fiyat_kdvli = trim(satis_fiyat_kdvli);
			satis_fiyat_kdvli=Replace(satis_fiyat_kdvli,',','.');
			j=j+1;
			
			//satis_fiyat_kdvsiz
			satis_fiyat_kdvsiz = 0;
			satis_fiyat_kdvsiz = trim(satis_fiyat_kdvsiz);
			satis_fiyat_kdvsiz=Replace(satis_fiyat_kdvsiz,',','.');
			j=j+1;
			
			//Satis Money
			sales_money = 'USD';
			sales_money = trim(sales_money);
			j=j+1;
		
			//uye_kodu
			uye_kodu = trim(uye_kodu);
			j=j+1;
		
			//uretici_urun_kodu
			uretici_urun_kodu = '';
			uretici_urun_kodu = trim(uretici_urun_kodu);
			j=j+1;
			
			//fiyat_yetkisi
			fiyat_yetkisi = '';
			fiyat_yetkisi = trim(fiyat_yetkisi);
			j=j+1;
			
			//surec_id
			surec_id = trim(surec_id);
			j=j+1;
			
			//Ozel Kod(PRODUCT_CODE_2)
			product_code_2 = p_code_wrk;
			product_code_2 = trim(product_code_2);
			j=j+1;
		
			//Marka (BRAND_ID)
			brand_id = '';
			brand_id = trim(brand_id);
			j=j+1;
			
			//Model (SHORT_CODE)
			short_code_id = '';
			short_code_id = trim(short_code_id);
			j=j+1;
			
			//açıklama (PRODUCT_DETAIL)
			detail = '#PRODUCT_DETAIL#';
			detail = left(trim(detail),255);
			j=j+1;
			
			//açıklama2 (PRODUCT_DETAIL2)
			
			detail_2 = '';
			detail_2 = left(trim(detail_2),255);
			j=j+1;
			
			
			
			is_inventory = 1;
			j=j+1;
			
			
			is_production = 0;
			is_production = trim(is_production);
			j=j+1;
			
			is_sales = 1;
			is_sales = trim(is_sales);
			j=j+1;
			
			is_purchase = 1;
			is_purchase = trim(is_purchase);
			j=j+1;
			
			is_internet = 0;
			is_internet = trim(is_internet);
			j=j+1;
			
			is_extranet = 0;
			is_extranet = trim(is_extranet);
			j=j+1;
			
			//sıfır stok
			is_zero_stock = 1;
			is_zero_stock = trim(is_zero_stock);
			j=j+1;
			
			//stoklarla sınırlı
			is_limited_stock = 0;
			is_limited_stock = trim(is_limited_stock);
			j=j+1;
			
			//kalite takip ediliyor
			is_quality = 0;
			is_quality = trim(is_quality);
			j=j+1;
			
			//min marj
			min_margin = 0;
			min_margin = trim(min_margin);
			min_margin=Replace(min_margin,',','.');
			j=j+1;
			
			//max marj
			max_margin = 0;
			max_margin = trim(max_margin);
			max_margin=Replace(max_margin,',','.');
			j=j+1;
			
			//muhasebe kod id
			account_code = '';
			account_code = trim(account_code);
			j=j+1;
			
			//raf ömrü
			shelf_life = '';
			shelf_life = trim(shelf_life);
			j=j+1;
			
			//birim boyut
			dimention = '';
			dimention = trim(dimention);
			dimention=Replace(dimention,',','.');
			j=j+1;
			
			//birim hacim
			volume = '';
			volume = trim(volume);
			volume=Replace(volume,',','.');
			j=j+1;
			
			//birim ağırlık
			weight = '';
			weight = trim(weight);
			weight=Replace(weight,',','.');
			j=j+1;
			
			//hedef pazar
			segment_id = '';
			segment_id = trim(segment_id);
			segment_id=Replace(segment_id,',','.');
			</cfscript>
			 <cfcatch type="Any">
				<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu. <br/>
				<cfset error_flag = 1>
				<cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>	 

		<cfif error_flag eq 0 and len(urun_adi)>
			<cfif not len(surec_id)> 
					<cfoutput>#i#.Satır İçin süreç Giriniz !</cfoutput><br/>
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
			
			<cfif error_flag eq 0 and len(urun_adi) and kayit_tipi is 1>
				<cfquery name="CHECK_SAME" datasource="#dsn1#">
					SELECT P.PRODUCT_ID FROM PRODUCT P WHERE P.PRODUCT_NAME = '#urun_adi#'
				</cfquery>
				<cfif check_same.recordcount>
					<cfoutput>#i#.satır - #barcode_no# - #urun_adi#</cfoutput> ürün adı var.<br/>
					<cfset error_flag = 1>
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

				<cfinclude template="/V16/settings/query/add_import_product.cfm">
				<cfinclude template="/V16/settings/query/add_import_product_barcode.cfm">
				<cfset attributes.pid = GET_PID.PRODUCT_ID>
				<cfset attributes.pcode = attributes.PRODUCT_CODE>
				
				<cfquery name="ADD_MAIN_UNIT" datasource="#DSN1#">
					INSERT INTO
						PRODUCT_UNIT 
						(
							PRODUCT_ID, 
							PRODUCT_UNIT_STATUS, 
							MAIN_UNIT_ID, 
							MAIN_UNIT, 
							UNIT_ID, 
							ADD_UNIT,
							DIMENTION,
							VOLUME,
							WEIGHT,
							IS_MAIN,
							MULTIPLIER,
							RECORD_EMP,
							RECORD_DATE
					
						)
						VALUES 
						(
							#attributes.pid#,
							1,
							1,
							'Piece',
							2,
							'Pallet',
							NULL,
							NULL,
							NULL,
							0,
							#carpan#,
							1,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)					
				</cfquery>
			</cfif>
		<cfelse>
			<cfoutput>#aaa#</cfoutput>. Error <br/>
			<cfset is_problem = 1>
		</cfif>
	</cfloop>
	
	Finished! Success!
	
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("File Error!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>