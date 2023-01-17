<!--- Genuis Export  --->
<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
	<!--- Fiyat Degisim Belgesi --->
	<cfquery name="GET_DEPT" datasource="#DSN#" maxrows="1">
		SELECT
			DEPARTMENT.DEPARTMENT_ID,
			SETUP_BRANCH_PRICE_CHANGE_NO.SON_BELGE_NO
		FROM
			DEPARTMENT,
			SETUP_BRANCH_PRICE_CHANGE_NO
		WHERE
			DEPARTMENT.BRANCH_ID = #attributes.branch_id# AND
			SETUP_BRANCH_PRICE_CHANGE_NO.BRANCH_ID = DEPARTMENT.BRANCH_ID
	</cfquery>
	<cfset attributes.belge_no = get_dept.son_belge_no>
<cfelse>
	<cfset get_dept.recordcount = 0>
</cfif>

<cfif not get_dept.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='34050.Seçtiğiniz Şubeye Kayıtlı Depo Yok'> !");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfif attributes.target_pos eq "-4">
	<cfif not isdefined('attributes.price_catid') or not len(attributes.price_catid)>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='34051.Fiyat Listesi Seçmediniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="0">

<cfif isdefined("attributes.recorddate") and len(attributes.recorddate)>
	<cf_date tarih="attributes.recorddate">
	<cfset attributes.recorddate = date_add('h', attributes.record_hour, attributes.recorddate)>
	<cfset attributes.recorddate = date_add('n', attributes.record_min, attributes.recorddate)>
</cfif>

<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
	<cfset attributes.startdate = date_add('h', attributes.start_hour, attributes.startdate)>
	<cfset attributes.startdate = date_add('n', attributes.start_min, attributes.startdate)>
</cfif>

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
	<cfset attributes.finishdate = date_add('h', attributes.finish_hour, attributes.finishdate)>
	<cfset attributes.finishdate = date_add('n', attributes.finish_min, attributes.finishdate)>
</cfif>
<cfscript>
	if (attributes.target_pos is "-1")
	{
		upload_folder = "#upload_folder#store#dir_seperator#";
		file_name = "#CreateUUID()#.gtf";
	}
	else if (attributes.target_pos is "-2")
	{
		upload_folder = "#upload_folder#store#dir_seperator#";
		file_name = "#CreateUUID()#.dat";
	}
	else if (attributes.target_pos is "-3")
	{
		upload_folder = "#upload_folder#store#dir_seperator#";
		file_name = "#CreateUUID()#.dat";
	}
	else if (attributes.target_pos is "-4")
	{
		upload_folder = "#upload_folder#store#dir_seperator#";
		file_name = "#CreateUUID()#.xml";
	}		
	// satır atlama karakteri
	CRLF = Chr(13) & Chr(10);
	
	dosya = ArrayNew(1);
	barcodes = ArrayNew(1);
	index_array = 1;	
	file_content2 = ArrayNew(1);
	index_array2 = 1;
	urun_say = 0;
</cfscript>
	
<cfif attributes.target_pos is "-1"><!--- Genius --->
	<!--- Urunler Alinir --->
	<cfinclude template="get_price_change_4_genius_export.cfm">
	<cfif not get_price_change_4_genius_export.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='34053.Girdiğiniz Koşullara Uygun Kayıt Bulunamadı'>!");
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<cffile action="write" output="<SIGNATURE=GNDPCHNG.GDF><VERSION=0222000>" addnewline="yes" file="#upload_folder##file_name#">
		<cffile action="write" output="" addnewline="no" file="#upload_folder#barcodes_#file_name#">
		<!--- Loop ile file oluşturulur --->
		<cfoutput query="get_price_change_4_genius_export">
			<cftry>
				<cfscript>
				// 1.Satir
				satir1 = "01 " & repeatString(" ", 145);													// satir no 
				satir2 = "02 " & repeatString(" ", 100);													// satir no

				satir1 = yerles(satir1, left(attributes.belge_no+currentrow, 12), 4, 12, " ");				// belge no
				satir1 = yerles(satir1, dateformat(now(),dateformat_style), 16, 14, " ");						// belge kayit tarihi
				satir1 = yerles(satir1, attributes.branch_id, 72, 6, " ");									// Magaza Numarası
				satir1 = yerles(satir1, dateformat(startdate,dateformat_style), 78, 14, " ");					// Fiyat Degisikligi Uygulama Tarihi
				if (len(finishdate))
					satir1 = yerles(satir1, dateformat(finishdate,dateformat_style), 92, 14, " ");				// Fiyat Degisikligi Geri Alma Tarihi {eger yoksa uygulama tarihi ile aynı olmalı}
				else
					satir1 = yerles(satir1, dateformat(startdate,dateformat_style), 92, 14, " ");				// Fiyat Degisikligi Geri Alma Tarihi {eğer yoksa uygulama tarihi ile aynı olmalı}
				satir1 = yerles(satir1, dateformat(now(), dateformat_style), 114, 14, " ");						// Fiyat Degisikligin Oluşturulduğu Tarih
				satir1 = yerles(satir1, 0, 136, 3, " ");													// Fiyat Degisimi Islem Türü {0 : eklendi / 1 : Düzeltildi}
				satir1 = yerles(satir1, "#timeformat(startdate,'HH')#:#timeformat(startdate,'MM')#:00", 139, 8, " ");	// Fiyat Degisimi Uygulama Saati
				
				// 2.Satir
				satir2 = yerles(satir2, 0, 4, 3, " ");											// Degisen Fiyat Bilgisinin index bilgisi {0 : satış / 5 : alış}
				satir2 = yerles(satir2, left("#product_id#.#stock_id#", 24), 7, 24, " ");		// stok kodu yerine product_id.stock_id aldık erk 20040114
		

				//Birimdeki paket carpan sayisi icin eklendi. sadece Paket,koli,kutu icin BK 20090506
				if(isdefined("attributes.x_genius_box_price") and attributes.x_genius_box_price eq 1 and listfindnocase("Paket,Koli,Kutu", add_unit))
				{
					temp_price_kdv = price_kdv / multiplier;
					temp_price_kdv = replace(left(temp_price_kdv ,15),".",",");
					temp_price = price / multiplier;
					temp_price = replace(left(temp_price ,15),".",",");
				}
				else
				{
					temp_price_kdv = replace(left(price_kdv ,15),".",",");
					temp_price = replace(left(price ,15),".",",");
				}
				if(is_kdv eq 1)
				{
					satir2 = yerles(satir2, temp_price_kdv, 31, 15, " ");						// Eski fiyat
					satir2 = yerles(satir2, temp_price_kdv, 53, 15, " ");						// Yeni Fiyat 
				}
				else
				{
					satir2 = yerles(satir2, temp_price, 31, 15, " ");							// Eski fiyat
					satir2 = yerles(satir2, temp_price, 53, 15, " ");							// Yeni Fiyat 
				}

				satir2 = yerles(satir2, iif(is_kdv eq 1,0,1), 46, 1, " ");						// Eski Fiyata KDV Durumu {0 : dahil / 1 : hariç}
				satir2 = yerles(satir2, iif(is_kdv eq 1,0,1), 68, 1, " ");						// Yeni Fiyat KDV Durumu
				satir2 = yerles(satir2, tax_id-1, 47, 3, " ");									// Eski Fiyat KDV referansı
				satir2 = yerles(satir2, tax_id-1, 69, 3, " ");									// Yeni Fiyat KDV Referansı
				satir2 = yerles(satir2, 0, 50, 3, " ");											// Eski Fiyat Ödeme Türü {0,1,2 : Nakit, Dolar, Mark} {0..39 arası}
				satir2 = yerles(satir2, 0, 72, 3, " ");											// Yeni Fiyat Ödeme Türü
				satir2 = yerles(satir2, tax, 95, 3, " ");										// Eski KDV Yüzdesi
				satir2 = yerles(satir2, tax, 98, 3, " ");										// Yeni KDV Yüzdesi
				ArrayAppend(dosya,satir1);
				ArrayAppend(dosya,satir2);
				if(len(barcod))
					ArrayAppend(barcodes, "#barcod#,1,#product_name#"); 						// etiket basma icin arraye eklenir
				</cfscript>
				<cfcatch type="any">
					#currentrow#. Satırda hata ! {#product_name#}<br/>
				</cfcatch>
			</cftry>
			<cfif (get_price_change_4_genius_export.currentrow mod 1000) eq 0><!--- 20041210 performans icin --->
				<!--- daha once yukarida eklenmis dosyanin icerigi doluyor --->
				<cffile action="append" output="#ArrayToList(dosya,CRLF)#" file="#upload_folder##file_name#" charset="ISO-8859-9">
				<cffile action="append" output="#ArrayToList(barcodes,CRLF)#" file="#upload_folder#barcodes_#file_name#" charset="ISO-8859-9">
				<cfset dosya = ArrayNew(1)>
				<cfset barcodes = ArrayNew(1)>
			</cfif>
		</cfoutput>
		<cfif (get_price_change_4_genius_export.recordcount mod 1000) eq 0>
			<cfset yeni_satir = 0>
		<cfelse>
			<cfset yeni_satir = 1>
		</cfif>
		<cffile action="append" output="#ArrayToList(dosya,CRLF)#" addnewline="#yeni_satir#" file="#upload_folder##file_name#" charset="ISO-8859-9">
		<cffile action="append" output="#ArrayToList(barcodes,CRLF)#" addnewline="#yeni_satir#" file="#upload_folder#barcodes_#file_name#" charset="ISO-8859-9">
		<cfset dosya = ''>
		<cfset barcodes = ''>
	</cfif>
<cfelseif attributes.target_pos is "-2"><!--- MPOS --->
	<cffile action="write" output="" addnewline="no" file="#upload_folder##file_name#" charset="ISO-8859-9">
	<!--- urunler alinir --->
	<cfinclude template="get_price_change_inter_export.cfm">

	<cfif not get_stocks.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='34053.Girdiğiniz Koşullara Uygun Kayıt Bulunamadı'>!");
			history.back();
		</script>
		<cfabort>
	<cfelse>
	
	<cfoutput query="get_stocks">
	<cfscript>
		if (len(property))
			product_name_ = left("#product_name# - #property#", 20);
		else
			product_name_ = left(product_name, 20);

		turkish_list = "ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö";
		utf_list = "u,g,i,s,c,o,U,G,I,S,C,O";
		product_name_ = replacelist(product_name_,turkish_list,utf_list);
		
		if(is_terazi eq 1)
			terazi_ = "E";
		else
			terazi_ = "H";

		stock_unit = add_unit;
		if (is_kdv)
			std_satis = price_kdv;
		else
			std_satis = round((price*(100+tax)) / 100);				
			
		if (ceiling(std_satis) eq std_satis)
			std_satis = ceiling(std_satis) & '.00';
		else if ((round(std_satis*10)/10) eq std_satis)
			std_satis = std_satis & '0';
				
		if(len(std_satis) gt 10)
		{
			writeoutput("<cf_get_lang dictionary_id='34054.İnter Uyumsuz Fiyat'>:#product_name_# (#std_satis#)<br/>");
			break;
		}
		
		switch (stock_unit)
		{
			case "Adet" : unit_id_ = "AD"; break;
			case "kg" : unit_id_ = "KG"; break;
			case "metre" : unit_id_ = "MT"; break;
			case "litre" : unit_id_ = "LT"; break;
			case "koli" : unit_id_ = "KL"; break;
			default : unit_id_ = "  ";
		}
				
		if (len(tax_id) eq 1)
			my_kdv_ = "0" & tax_id;
		else
		
			my_kdv_ = tax_id;

			satir1 = "1" & repeatString(" ",63);
			satir1 = yerles_saga(satir1,stock_id,2,6,"0");
			satir1 = yerles(satir1,barcod,8,20," ");
			satir1 = yerles(satir1,product_name_,28,20," ");
			satir1 = yerles_saga(satir1,std_satis,48,10,"0");
			satir1 = yerles(satir1,"#my_kdv_#",58,2,"0");
			satir1 = yerles(satir1,unit_id_,60,4," ");
			satir1 = left(satir1,63)&terazi_;

			file_content[index_array] = "#satir1#";
			urun_say = urun_say + 1;
			index_array = index_array+1;
			</cfscript>
			</cfoutput>			

			<cffile action="append" output="#ArraytoList(file_content,CRLF)#" file="#upload_folder##file_name#" charset="ISO-8859-9">
			<cfset file_content = ArrayNew(1)>
			<cfset index_array = 1>
			<cfset index_array_pluno = 1>
	
	</cfif>
<cfelseif attributes.target_pos is "-3"><!--- NCR --->
	<cfset ext_code = -1>
	<cfinclude template="../functions/barcode.cfm">
	<cffile action="write" output="" addnewline="no" file="#upload_folder##file_name#" charset="ISO-8859-9">

	<!--- Ürünler Alınır --->
	<cfinclude template="get_price_change_ncr_export.cfm">
	
	<cfif not get_stocks.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='34053.Girdiğiniz Koşullara Uygun Kayıt Bulunamadı'>!");
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<cfset my_date = CreateODBCDateTime(CreateDate(year(now()),month(now()),day(now())))>
		<cfset simdi_tarih = date_add('h',session.ep.time_zone,my_date)>
				
		<cfset group_id="STOCK_ID">
		<cfoutput query="get_stocks" group="#group_id#">
			<cfoutput>
			<cfscript>
			satir1 = repeatString(" ",78);
			if (len(property))
				product_name_ = left("#product_name# - #property#", 20);
			else
				product_name_ = left(product_name, 20);

			stock_unit = add_unit;
			if (is_kdv)
				std_satis = price_kdv;
			else
				std_satis = round((price*(100+tax)) / 100);
	
			switch (stock_unit)
			{
				case "Adet" : unit_id_ = "AD"; break;
				case "kg" : unit_id_ = "KG"; break;
				case "metre" : unit_id_ = "MT"; break;
				case "litre" : unit_id_ = "LT"; break;
				case "koli" : unit_id_ = "KL"; break;
				default : unit_id_ = "  ";
			}
			barcod_ncr = BARCOD;// DB den gelen
			is_barcod_process = false;
			if (len(barcod) eq 7)
			{
				is_barcod_process = true;
			}
			ncrhata = 0;
			if (unit_id_ eq "  ") {ncrhata = 1; hata_str = "Birim Hatalı !";}
			if (len(std_satis) gt 9) {ncrhata = 2; hata_str = "Fiyat 9 haneden uzun !";}
			if (len(barcod) gt 13) {ncrhata = 3; hata_str = "Barkod 13 haneden uzun !";}

			if (not ncrhata)
				{
				satir1 = yerles_saga(satir1, barcod_ncr, 4, 13, " ");	// barkod
				satir1 = yerles(satir1, "3800", 17, 4, " ");		// departman kodu kilerde şimdilik 3800
				if (ListFindNoCase("AD,KL", unit_id_, ","))
				{
					satir1 = yerles(satir1, "0", 21, 1, " ");		// ürün ölçeklenebilir ? (birim kg vs. ise)
					satir1 = yerles(satir1, "0", 22, 1, " ");		// ondalık izni var (birim kg vs. ise)
				}
				else
				{
					satir1 = yerles(satir1, "2", 21, 1, " ");		// ürün ölçeklenebilir ? (birim kg vs. ise)
					satir1 = yerles(satir1, "1", 22, 1, " ");		// ondalık izni var (birim kg vs. ise)
				}
		
				satir1 = yerles(satir1, "0", 23, 1, " ");			// indirim kategorisi (şimdilik 0)
				satir1 = yerles(satir1, TAX_ID-1, 24, 1, " ");		// VAT Kodu
				satir1 = yerles(satir1, "00", 25, 2, " ");			// TARE veya Mix-Match (kilerde 00)
		
				satir1 = yerles(satir1, unit_id_, 27, 2, " ");		// birim 2 hane (KG,AD,...)
				if (multiplier contains ".")
				{
					multiplier1 = repeatString("0", 3-Len(ListFirst(multiplier, "."))) & ListFirst(multiplier, ".");
					multiplier2 = Left(ListLast(multiplier, "."), 1);
				}
				else
				{
					multiplier1 = repeatString("0", 3-Len(ListFirst(multiplier, "."))) & multiplier;
					multiplier2 = 0;
				}
				std_satis = replace((std_satis*100),'.','');			//kuruş olarak fiyat ayarlamak için
						
				satir1 = yerles(satir1, multiplier1, 29, 3, " ");		// birim çarpanı (ör : 0010; ilk 3 hane tam son hane yuzde)
				satir1 = yerles(satir1, multiplier2, 32, 1, " ");		// birim çarpanı (ör : 0010; ilk 3 hane tam son hane yuzde)
		
				satir1 = yerles(satir1, "0000", 33, 4, " ");			// depozit link (0000)
				satir1 = yerles(satir1, product_name_, 37, 20, " ");	// ürün adı
				satir1 = yerles(satir1, " ", 58, 2, " ");				// reserved
				//satir1 = yerles(satir1, " ", 60, 9, " ");				// alternatif fiyat
				satir1 = yerles(satir1, " ", 69, 1, " ");				// code 4
				// ürün fiyatı 9 hane tikkat
				satir1 = yerles_saga(satir1, std_satis, 70, 9, "0");	// fiyat
				file_content[index_array] = "#satir1#";
				urun_say = urun_say + 1;
				index_array = index_array+1;
				if(is_barcod_process)
				{
					//terazi barkodlari 13 haneye tamamlanip bir satir daha ekleniyor
					barcod_ncr = '#barcod_ncr#00000'; // terazili kasalar yuzunden barkod 12 haneye tamamlaniyor 13 karakter kontrol karakteri altta veriyoruz.
					barcod_ncr = barcod_ncr & WRK_UPCEANCheck(barcod_ncr);
					satir1 = yerles_saga(satir1, barcod_ncr, 4, 13, " ");	// barkod
					file_content[index_array] = "#satir1#";
					urun_say = urun_say + 1;
					index_array = index_array+1;
				}
				writeoutput("<font size=2>#get_stocks.currentrow#:#product_name_# BR:#BARCOD#,#stock_unit#</font><br/>");
			}
			else
			{
				file_content2[index_array2] = ":::#hata_str#_#get_stocks.currentrow#:#product_name_#_Barcod:#BARCOD#_Fiyat:#std_satis#_Birim:#stock_unit#";
				index_array2 = index_array2+1;
			}
			</cfscript>
			</cfoutput>
				<cffile action="append" output="#ArraytoList(file_content,CRLF)#" file="#upload_folder##file_name#" charset="ISO-8859-9">
				<cfset file_content = ArrayNew(1)>
				<cfset index_array = 1>
				<cfset index_array_pluno = 1>
		</cfoutput>
	</cfif>
	
	<cfif attributes.target_pos is "-3"><!--- NCR icin --->
		<strong><cf_get_lang dictionary_id='34056.NCR Uyumsuz kayıtlar'> : </strong><br/>
		<font size=2 color=red>
		<cfoutput>#ArraytoList(file_content2, "<br/>")#</cfoutput>
		</font>
		<hr>
	</cfif>
	<!--- ncr bitti--->
<cfelseif attributes.target_pos is "-4"><!--- Workcube --->
	<cfquery name="get_stocks" datasource="#dsn3#">
		SELECT DISTINCT
			PRODUCT.PRODUCT_ID,
			PRODUCT.PRODUCT_NAME,
			PRODUCT.BARCOD,
			ST.TAX_ID,
			ST.TAX,
			PR.PRICE,
			PR.PRICE_KDV,
			PR.IS_KDV,
			PR.MONEY,
			PU.ADD_UNIT,
			PR.STARTDATE,
			PR.FINISHDATE
		FROM
			PRODUCT, 
			PRODUCT_UNIT PU,
			#dsn2_alias#.SETUP_TAX ST,
			PRICE_CAT PC, 
			PRICE PR
		WHERE  
			PRODUCT.IS_INVENTORY = 1 AND
			PRODUCT.PRODUCT_STATUS = 1 AND
			ISNULL(PR.STOCK_ID,0)=0 AND
			ISNULL(PR.SPECT_VAR_ID,0)=0 AND
			PC.PRICE_CAT_STATUS = 1 AND
			PR.PRICE > 0 AND
			PRODUCT.PRODUCT_ID = PU.PRODUCT_ID AND
			PRODUCT.PRODUCT_ID = PR.PRODUCT_ID AND
			PR.PRICE_CATID = PC.PRICE_CATID AND
			PR.UNIT = PU.PRODUCT_UNIT_ID AND
			ST.TAX = PRODUCT.TAX AND
			PC.PRICE_CATID = #attributes.price_catid#
			<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdefined("attributes.finishdate") and len(attributes.finishdate)>
				AND
				(
					(PR.STARTDATE <= #attributes.finishdate# AND PR.FINISHDATE >= #attributes.startdate#) OR
					(PR.STARTDATE <= #attributes.finishdate# AND PR.FINISHDATE IS NULL)
				)
			<cfelseif isdefined("attributes.startdate") and len(attributes.startdate)>
				<cfset finishdate = date_add("d",1,attributes.startdate)>
				<cfset finishdate = date_add("n",-1,finishdate)>
				AND PR.STARTDATE BETWEEN #attributes.startdate# AND #finishdate#
			<cfelseif isdefined("attributes.finishdate") and len(attributes.finishdate)>
				<cfset finishdate = date_add("s",-1,attributes.finishdate)>
				AND PR.FINISHDATE = #finishdate#
			</cfif>
		ORDER BY
			PRODUCT.PRODUCT_ID
	</cfquery>
	
	<cfif not get_stocks.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='34053.Girdiğiniz Koşullara Uygun Kayıt Bulunamadı'>!");
			history.back();
		</script>
		<cfabort>
	<cfelse>
		<cfset group_id="PRODUCT_ID">
		<cffile action="write" output="" addnewline="no" file="#upload_folder##file_name#" charset="UTF-8">
		<cfscript>
			my_doc = XmlNew();
			my_doc.xmlRoot = XmlElemNew(my_doc,"PRODUCT_PRICE");
			//lisans numarası alınıyor ve belgeye ekleniyor
			get_license=cfquery(SQLString:"SELECT WORKCUBE_ID,COMPANY FROM LICENSE",is_select:1,Datasource:DSN);
			get_company=cfquery(SQLString:"SELECT NICK_NAME FROM OUR_COMPANY WHERE COMP_ID=#session.ep.company_id#",is_select:1,Datasource:dsn);
			get_brand_all=cfquery(SQLString:"SELECT	BRAND_ID, BRAND_NAME FROM PRODUCT_BRANDS",is_select:1,Datasource:dsn1);			
			my_doc.xmlRoot.XmlChildren[index_array] = XmlElemNew(my_doc,"PRODUCT_DESCRIPTION");
			my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1] = XmlElemNew(my_doc,"CREATION_SERVER_DATE");
			my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1].XmlText = "#dateformat(NOW(),dateformat_style)# #timeformat(date_add("h",session.ep.time_zone,NOW()),timeformat_style)#";
			my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2] = XmlElemNew(my_doc,"WORKCUBE_ID");
			my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2].XmlText = get_license.WORKCUBE_ID;
			my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3] = XmlElemNew(my_doc,"SERVER_COMPANY");
			my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3].XmlText = get_company.NICK_NAME;
			my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4] = XmlElemNew(my_doc,"DESTINATION_COMPANY");
			my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4].XmlText = attributes.destination_company_name;
			my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5] = XmlElemNew(my_doc,"DESTINATION_COMPANY_ID");
			my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5].XmlText = attributes.destination_company_id;
			index_array = index_array+1;
		</cfscript>
		<cfoutput query="get_stocks" group="#group_id#">
			<cfoutput>
			<cfscript>
				my_doc.xmlRoot.XmlChildren[index_array] = XmlElemNew(my_doc,"PRODUCT");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1] = XmlElemNew(my_doc,"BARCOD");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[1].XmlText = BARCOD;
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2] = XmlElemNew(my_doc,"PRODUCT_NAME");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[2].XmlText = PRODUCT_NAME;
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3] = XmlElemNew(my_doc,"PRICE");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[3].XmlText = PRICE;
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4] = XmlElemNew(my_doc,"PRICE_KDV");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[4].XmlText = PRICE_KDV;
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5] = XmlElemNew(my_doc,"MONEY");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[5].XmlText = MONEY;
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[6] = XmlElemNew(my_doc,"ADD_UNIT");
				my_doc.xmlRoot.XmlChildren[index_array].XmlChildren[6].XmlText = ADD_UNIT;
				index_array = index_array+1;
				urun_say = urun_say + 1;
			</cfscript>
			</cfoutput>
			<!--- <cfset index_array = 1> --->
			<cfset index_array_pluno = 1>
		</cfoutput>
		<cffile action="append" file="#upload_folder##file_name#" output="#toString(my_doc)#" charset="utf-8">
	</cfif>
</cfif>	
	

<!--- dosya loglanır --->
<cfquery name="add_file" datasource="#DSN2#">
	INSERT INTO	
		FILE_EXPORTS
	(
		TARGET_SYSTEM,
		PROCESS_TYPE,
		PRODUCT_COUNT,
		FILE_NAME,
		FILE_SERVER_ID,
		STARTDATE,
		FINISHDATE,
		DEPARTMENT_ID,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
	<cfif attributes.target_pos eq -4 and len(attributes.destination_company_id) and len(attributes.destination_company_name)>
		,DESTINATION_COMPANY_ID
	</cfif>
	)
	VALUES
	(
		#target_pos#,
		-3,
		<cfif attributes.target_pos is "-3" or attributes.target_pos is "-2" or attributes.target_pos is "-4">#urun_say#,<cfelseif IsDefined('get_price_change_4_genius_export.recordcount')>#get_price_change_4_genius_export.recordcount#,<cfelse>NULL,</cfif>
		'#FILE_NAME#',
		#fusebox.server_machine#,
	<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
		#attributes.startdate#,
	<cfelse>
		NULL,
	</cfif>
	<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
		#attributes.finishdate#,
	<cfelse>
		NULL,
	</cfif>
	<cfif isdefined("get_dept.department_id") and len(get_dept.department_id)>
		#get_dept.department_id#,
	<cfelse>
		NULL,
	</cfif>
		#NOW()#,
		'#CGI.REMOTE_ADDR#',
		#SESSION.EP.USERID#
	<cfif attributes.target_pos eq -4 and len(attributes.destination_company_id) and len(attributes.destination_company_name)>
		,#attributes.destination_company_id#
	</cfif>	
	)
</cfquery>

<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
	<!--- şube son belgeno güncellenir --->
	<cfif IsDefined('get_price_change_4_genius_export.recordcount')>
		<cfset urun_say=get_price_change_4_genius_export.recordcount>
	</cfif>
	<cfquery name="upd_sube_belge_no" datasource="#dsn#">
		UPDATE
			SETUP_BRANCH_PRICE_CHANGE_NO
		SET
			SON_BELGE_NO = '#attributes.belge_no+urun_say+1#'
		WHERE
			BRANCH_ID = #attributes.branch_id#
	</cfquery>
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=pos.list_price_change_genius';
</script>

