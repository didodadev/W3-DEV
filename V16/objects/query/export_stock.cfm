<!--- Genius + Intel + NCR Export + ESPOS stok kartlari --->

<!--- BK 20090415
x_genius_box_office attributes ifadesi Genius kasalar icin paket fiyatının adet cinsinden gonderilmesinde kullanilmıstir. 
Paket fiyatı girilirken verilen fiyat carpan ifadesine bolundugunda bulunan degerin virgulden sonraki iki basamak olmalı. Or:0,65
BK 20100221 xml_coefficient ifadesi ozel kod alanindaki degerlerin stok export dosyasinda Katsayi 1 alaninda bire bir bu degeri kullanmak icin eklendi
BK 20110222 xml_stock_detail2 Stok Karti Aciklamasi degeri ürün detayındaki Açıklama2 değerini kullanılmasi icin eklendi
--->
<!--- Popup da bu parametreler gerekli olmadıgı icin popupflush sayfada eklendi BK 20110222 --->
<cf_xml_page_edit fuseact="objects.popup_form_export_stock">
<cfsetting requesttimeout="3600">
<cfsetting showdebugoutput="no">
<!---!!! İ Ş İ N İ Z  B İ T İ N C E  M U T L A K A  K A P A T I N !!! --->
<!--- Kontrollu olarak kaldiriniz Espos MYSQL kayit atmada kullaniliyordu BK 20080724
<cfinclude template="../../objects/functions/export_stock_espos_functions.cfm"> --->

<cfif listfind("-3,-5",attributes.target_pos)>
	<cfset ext_code = -1>
	<cfinclude template="../functions/barcode.cfm">
</cfif>
<cfif attributes.target_pos is "-2">
	<cfscript>
	/**
	 * Create a zip file of a directory or just a file.
	 * 
	 * @param zipPath  File name of the zip to create. (Required)
	 * @param toZip  Folder or full path to file to add to zip. (Required)
	 * @param relativeFrom  Some or all of the toZip path, from which the entries in the zip file will be relative (Optional)
	 * @return Returns nothing. 
	 * @author Nathan Dintenfass (nathan@changemedia.com) 
	 * @version 1.1, January 19, 2004 
	 */
	function zipFileNew(zipPath,toZip)
	{
	//make a fileOutputStream object to put the ZipOutputStream into
	var output = createObject("java","java.io.FileOutputStream").init(zipPath);
	//make a ZipOutputStream object to create the zip file
	var zipOutput = createObject("java","java.util.zip.ZipOutputStream").init(output);
	//make a byte array to use when creating the zip
	//yes, this is a bit of hack, but it works
	var byteArray = repeatString(" ",1024).getBytes();
	//we'll need to create an inputStream below for writing out to the zip file
	var input = "";
	//we'll be making zipEntries below, so make a variable to hold them
	var zipEntry = "";
	var zipEntryPath = "";
	//we'll use this while reading each file
	var len = 0;
	//a var for looping below
	var ii = 1;
	//a an array of the files we'll put into the zip
	var fileArray = arrayNew(1);
	//an array of directories we need to traverse to find files below whatever is passed in
	var directoriesToTraverse = arrayNew(1);
	//a var to use when looping the directories to hold the contents of each one
	var directoryContents = "";
	//make a fileObject we can use to traverse directories with
	var fileObject = createObject("java","java.io.File").init(toZip);
	//which part of the file path should be excluded in the zip?
	var relativeFrom = "";
	
	//if there is a 3rd argument, that is the relativeFrom value
	if(structCount(arguments) GT 2){
	relativeFrom = arguments[3];
	}
	
	//
	// first, we'll deal with traversing the directory tree below the path passed in, so we get all files under the directory
	// in reality, this should be a separate function that goes out and traverses a directory, but cflib.org does not allow for UDF's that rely on other UDF's!!
	//
	
	//if this is a directory, let's set it in the directories we need to traverse
	if(fileObject.isDirectory())
	arrayAppend(directoriesToTraverse,fileObject);
	//if it's not a directory, add it the array of files to zip
	else
	arrayAppend(fileArray,fileObject);
	//now, loop through directories iteratively until there are none left
	while(arrayLen(directoriesToTraverse)){
	//grab the contents of the first directory we need to traverse
	directoryContents = directoriesToTraverse[1].listFiles();
	//loop through the contents of this directory
	for(ii = 1; ii LTE arrayLen(directoryContents); ii = ii + 1){
	//if it's a directory, add it to those we need to traverse
	if(directoryContents[ii].isDirectory())
	arrayAppend(directoriesToTraverse,directoryContents[ii]);
	//if it's not a directory, add it to the array of files we want to add
	else
	arrayAppend(fileArray,directoryContents[ii]);
	}
	//now kill the first member of the directoriesToTraverse to clear out the one we just did
	arrayDeleteAt(directoriesToTraverse,1);
	} 
	
	//
	// And now, on to the zip file
	//
	
	//let's use the maximum compression
	zipOutput.setLevel(9);
	//loop over the array of files we are going to zip, adding each to the zipOutput
	for(ii = 1; ii LTE arrayLen(fileArray); ii = ii + 1){
	//make a fileInputStream object to read the file into
	input = createObject("java","java.io.FileInputStream").init(fileArray[ii].getPath());
	//make an entry for this file
	zipEntryPath = fileArray[ii].getPath();
	//if we are making the zip relative from a certain directory, exclude that from the zipEntryPath
	if(len(relativeFrom)){
	zipEntryPath = replace(zipEntryPath,relativeFrom,"");
	} 
	zipEntry = createObject("java","java.util.zip.ZipEntry").init(zipEntryPath);
	//put the entry into the zipOutput stream
	zipOutput.putNextEntry(zipEntry);
	// Transfer bytes from the file to the ZIP file
	len = input.read(byteArray);
	while (len gt 0) {
	zipOutput.write(byteArray, 0, len);
	len = input.read(byteArray);
	}
	//close out this entry
	zipOutput.closeEntry();
	input.close();
	}
	//close the zipOutput
	zipOutput.close();
	//return nothing
	return "";
	}
	</cfscript>
</cfif>

<cfif ((not isdefined("attributes.department_id")) or (isdefined("attributes.department_id") and not len(attributes.department_id))) and (isdefined('attributes.target_pos') and attributes.target_pos neq -4)>
	<script type="text/javascript">
		alert("Şube Seçmediniz !");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif isdate(attributes.product_recorddate)><cf_date tarih='attributes.product_recorddate'></cfif>
<cfif isdate(attributes.price_recorddate)><cf_date tarih='attributes.price_recorddate'></cfif>

<!--- Urunler Alinir --->
<cfinclude template="get_stocks2.cfm">

<cfif not get_stocks.recordcount>
	<script type="text/javascript">
		alert("Girdiğiniz Koşullara Uygun Kayıt Bulunamadı!");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfset my_date = CreateODBCDateTime(CreateDate(year(now()),month(now()),day(now())))>
	<cfset simdi_tarih = date_add('h',session.ep.time_zone,my_date)>
	<cfif attributes.target_pos is "-1"><!--- 20050527 sadece genius promosyonlarını aliyoruz simdilik --->
		<cfquery name="GET_ALL_PROMS" datasource="#DSN3#">
			SELECT 
				DISCOUNT,
				AMOUNT_DISCOUNT,
				BRAND_ID,
				STOCK_ID,
				PRICE_CATID,
				PRODUCT_CATID,			
				RECORD_DATE
			FROM
				PROMOTIONS 
			WHERE
				STARTDATE <= #DATEADD('h',session.ep.time_zone,my_date)# AND
				FINISHDATE >= #DATEADD('h',session.ep.time_zone,DATEADD('d',1,my_date))#
		</cfquery>
	</cfif>
	<cfif attributes.target_pos is "-4"><!--- workcube belgesinde ikinci barcode icin --->
		<cfquery name="GET_ALL_BARCODE" datasource="#DSN1#">
			SELECT BARCODE,STOCK_ID FROM STOCKS_BARCODES
		</cfquery>
	</cfif>
	<cf_get_lang no="562.Stok Export İşlemi Başladı">,<cf_get_lang_main no="1480.Lütfen Bekleyiniz"><br/>
	<cfif attributes.price_catid gt 0>
		<cfquery name="GET_PRICES" datasource="#DSN3#">
			SELECT DISTINCT
				0 CHECK_COLUMN,
				P.PRICE,
				P.IS_KDV,
				P.PRICE_KDV,
				P.STARTDATE,
				P.PRICE_DISCOUNT,
				P.PRICE_CATID,
				P.MONEY,				
				PU.ADD_UNIT,
				PU.PRODUCT_UNIT_ID,
				S.STOCK_ID,
				S.PRODUCT_ID				
			FROM
				PRICE P, 
				PRODUCT_UNIT PU,
				STOCKS S,
				STOCKS_BARCODES SB
			WHERE
				P.PRICE_CATID = #attributes.price_catid# AND
			  <cfif isdefined("form.product_name") and isdefined("form.product_id") and len(form.product_name) and len(form.product_id)>
				S.PRODUCT_ID = #form.product_id# AND
			  </cfif>
			  <cfif isdefined("form.company_id") and len(form.company_id)>
				S.COMPANY_ID = #form.company_id# AND
			  </cfif>
			  <cfif isdefined("form.brand_id") and len(form.brand_id)>
				S.BRAND_ID = #form.brand_id# AND
			  </cfif>
			  <cfif isdate(attributes.product_recorddate)>
				(S.UPDATE_DATE >= #attributes.product_recorddate# OR S.RECORD_DATE >= #attributes.product_recorddate#) AND
			  </cfif>
			  <cfif isdate(attributes.price_recorddate)>
				P.RECORD_DATE > #attributes.price_recorddate# AND (P.FINISHDATE >= #simdi_tarih# OR P.FINISHDATE IS NULL) AND
			  <cfelse>
				P.STARTDATE <= #simdi_tarih# AND (P.FINISHDATE >= #simdi_tarih# OR P.FINISHDATE IS NULL) AND
			  </cfif>
			  <cfif isdefined("form.product_cat_id") and len(form.product_cat_id)>
				S.STOCK_CODE LIKE '#form.product_cat_id#%' AND
			  </cfif>
				S.STOCK_ID = SB.STOCK_ID AND
				P.UNIT = SB.UNIT_ID AND
				(P.PRICE+P.PRICE_KDV) > 0 AND
				PU.PRODUCT_UNIT_ID = P.UNIT AND
				S.PRODUCT_ID = P.PRODUCT_ID AND
				((ISNULL(P.STOCK_ID,0) = S.STOCK_ID AND P.STOCK_ID IS NOT NULL) OR (ISNULL(P.STOCK_ID,0) = 0 AND P.STOCK_ID IS NULL)) AND 
				ISNULL(P.SPECT_VAR_ID,0)=0 AND
				S.PRODUCT_ID = PU.PRODUCT_ID AND
				P.PRICE < 10000000 AND
				LEN(SB.BARCODE) > 6 AND
				LEN(SB.BARCODE) < 14
		</cfquery>
		<cfquery name="GET_STOCKS" dbtype="query">
			SELECT DISTINCT
				GET_STOCKS.*,
				GET_PRICES.PRICE_CATID AS PRICE_CATID
			FROM 
				GET_STOCKS,
				GET_PRICES
			WHERE
				GET_STOCKS.STOCK_ID = GET_PRICES.STOCK_ID
			ORDER BY
			<cfif attributes.target_pos is "-4">
				GET_STOCKS.STOCK_CODE,
			</cfif>
				GET_STOCKS.STOCK_ID,
				GET_STOCKS.PRODUCT_UNIT_ID ASC
		</cfquery>
		
		<!--- <cfdump var="#GET_STOCKS#"> --->
		
		<cffunction name="GET_PRICE" returntype="query" output="false">
			<cfargument name="unit_id" type="string" required="true">
			<cfargument name="stock_id" type="string" required="true">
			<cfargument name="price_catid" type="string" required="true">
			<cfquery name="GET_PRICE_END" dbtype="query" maxrows="1">
				SELECT
					PRICE,
					IS_KDV,
					PRICE_KDV,
					ADD_UNIT,
					PRICE_DISCOUNT,
					MONEY
				FROM
					GET_PRICES
				WHERE
					STOCK_ID = #arguments.stock_id# AND
					PRODUCT_UNIT_ID = #arguments.unit_id#
				ORDER BY
					STARTDATE
			</cfquery>
			<cfreturn GET_PRICE_END>
		</cffunction>
	
	</cfif>
	<cfif attributes.target_pos is "-2" and not DirectoryExists("#upload_folder#store#dir_seperator#temp#dir_seperator##session.ep.userid#")>
		<cfdirectory action="create" name="#session.ep.userid#" directory="#upload_folder#store#dir_seperator#temp#dir_seperator##session.ep.userid#">
	</cfif>
	<cfscript>	
	if (attributes.target_pos is "-1")
	{
		upload_folder = "#upload_folder#store#dir_seperator#";
		file_name = "#CreateUUID()#.GTF";
	}
	else if (attributes.target_pos is "-2")
	{
		upload_folder_mpos = "#upload_folder#pos#dir_seperator##listfirst(attributes.department_id,'-')##dir_seperator#";
		upload_folder = "#upload_folder#store#dir_seperator#temp#dir_seperator##session.ep.userid##dir_seperator#";
		
		file_name = "#CreateUUID()#.ZIP";
		if(x_productdate_file_control eq 1 and isdate(attributes.product_recorddate))
		{
			file_name1 = "TEKURUN.DAT";
			file_name2 = "";
			file_name3 = "";
		}
		else
		{
			file_name1 = "URUN.DAT";
			file_name2 = "BARKOD.IDX";
			file_name3 = "PLUNO.IDX";
		}
	}
	else if (attributes.target_pos is "-3" or attributes.target_pos is "-5" or attributes.target_pos is "-8")
	{
		upload_folder = "#upload_folder#store#dir_seperator#";
		file_name = "#CreateUUID()#.DAT";
	}
	else if (attributes.target_pos is "-4")
	{
		upload_folder = "#upload_folder#store#dir_seperator#";
		file_name = "#CreateUUID()#.xml";
	}
	else if (attributes.target_pos is "-6")
	{
		upload_folder = "#upload_folder#store#dir_seperator#";
		file_name = "#CreateUUID()#.DAT";
		add_espos_row = ArrayNew(1);
	}	
	
	if(attributes.target_pos neq "-4")
	{
		// satır atlama karakteri
		CRLF=chr(13)&chr(10);
	
		file_content = ArrayNew(1);
		file_content_file2 = ArrayNew(1); 	// barcode.idx icin olusturuldu.yo27052005
		file_content_file3 = ArrayNew(1); 	// pluno.idx icin olusturuldu.yo27052005

		file_content2 = ArrayNew(1);
		index_array2 = 1;

		aktif_satir = 1; 					//pluno.idx ve barcode.idx de aktif satiri dosyaya yazabilmek icin eklendi.yo27052005
		index_array_pluno = 1; 				//pluno.idx dosyasinda stock_id tekrarini onlemek amacli eklendi.yo27052005
	}
	
	index_array = 1;
	urun_say = 0;
	last_stock_id = ""; 					//pluno.idx dosyasinda stock_id tekrarini onlemek amacli eklendi.yo27052005
	last_product_id=""; 					// workcube dosya formatında bir ust satirdaki urunle aynimi yani cesitmi kontrolu icin
	</cfscript>

	<!--- ilk once dosya eklenir sonra asagida ici doldurulur --->
	<cfif attributes.target_pos is "-1">
		<cffile action="write" output="<SIGNATURE=GNDPLU.GDF><VERSION=0222000>" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
	<cfelseif listfind("-3,-5,-8",attributes.target_pos)>
		<cffile action="write" output="" addnewline="no" file="#upload_folder##file_name#" charset="ISO-8859-9">
	<cfelseif attributes.target_pos is "-2">
		<cffile action="write" output="" addnewline="no" file="#upload_folder##file_name1#" charset="ISO-8859-9">
		<cfif Len(file_name2)><!--- xml e bagli olarak --->
			<cffile action="write" output="" addnewline="no" file="#upload_folder##file_name2#" charset="ISO-8859-9">
			<cffile action="write" output="" addnewline="no" file="#upload_folder##file_name3#" charset="ISO-8859-9">
		</cfif>
	<cfelseif attributes.target_pos is "-6">
		<cffile action="write" output="" addnewline="no" file="#upload_folder##file_name#" charset="ISO-8859-9">
	</cfif>
	<!--- Loop ile file oluşturulur --->
	<cfif attributes.target_pos is "-2">
		<cfset group_id="BARCOD">
		<cfset ALL_BARCODES = QueryNew("BARCOD,NORMAL_SIRA,STOCK_ID","VarChar,Integer,Integer")>
		<cfset ROW_OF_QUERY = 0>
	<cfelse>
		<cfset group_id="STOCK_ID">
	</cfif>
	<cfif attributes.target_pos is "-4">
    	<cfinclude template="workcube_export_stock.cfm">
	<cfelse>
		<cfoutput query="get_stocks" group="#group_id#">	
            <cfif attributes.target_pos is "-1"><!--- Genius --->
                <cfif isdefined("attributes.is_pricecat_control") and (attributes.is_pricecat_control eq 1)>
                    <cfquery name="GET_PROM" dbtype="query" maxrows="1">
                        SELECT
                            DISCOUNT,
                            AMOUNT_DISCOUNT,
                            RECORD_DATE
                        FROM
                            GET_ALL_PROMS
                        WHERE
                        <cfif (attributes.price_catid gt 0) and len(get_stocks.price_catid)>
                            (STOCK_ID = #get_stocks.stock_id# AND PRICE_CATID = #get_stocks.price_catid#)
                        <cfelse>
                            (STOCK_ID = #get_stocks.stock_id# <!---AND PRICE_CATID = -2--->)
                        </cfif>
                        <cfif len(get_stocks.brand_id)>
                            OR BRAND_ID = #get_stocks.brand_id#
                        </cfif>
                        <cfif len(get_stocks.product_catid)>
                            OR PRODUCT_CATID = #get_stocks.product_catid#
                        </cfif>
                        ORDER BY
                            RECORD_DATE DESC
                    </cfquery>
                <cfelse>
                    <cfset get_prom.recordcount = 0>
                </cfif>
                <cfscript>
                satir1 = "01 " & repeatString(" ",850);	
                satir2 = "02" & repeatString(" ",200);		
				
				// xml_stock_detail2 Stok Karti Aciklamasi degeri ürün detayındaki Açıklama2 değerini kullanılsın mı?
				if(xml_stock_detail2 eq 0)
				{
					if (len(property))
						product_name_ = "#product_name# - #property#";
					else
						product_name_ = product_name;
				}
				else
					product_name_ = product_detail2;
				
				
                
                // 1. SATIR (Stok Bilgileri)
                prom_yuzde = "";
                prom_tutar_ind = "";
                fiyat_istenen_fiyat = 0; 				// istenen fiyat listesinde yoksa ürünü alma
                temp_stock_unit_id = product_unit_id;	// asagida barkod output icin gerekli
                if (attributes.price_catid gt 0)		// fiyat listesi isteniyor
                {
				    get_price_end = get_price(unit_id : product_unit_id, stock_id : stock_id, price_catid : attributes.price_catid); // sube fiyatlarini al
                    if (get_price_end.recordcount)
                    {
                        fiyat_istenen_fiyat = 1;
                        stock_unit = get_price_end.add_unit;
                        if (get_price_end.is_kdv is "1")
                            std_satis = get_price_end.price_kdv;
                        else
                            std_satis = wrk_round((get_price_end.price*(100+tax)) / 100);
                        if(len(get_price_end.price_discount) and (get_price_end.price_discount gt 0) and (get_price_end.price_discount lte std_satis)) // Fiyattan tutar indirimi yapilicaksa
                            prom_tutar_ind = wrk_round(get_price_end.price_discount);
                    }
                }
                else
                {
					// standart satis isteniyor
                    fiyat_istenen_fiyat = 1;
                    stock_unit = add_unit;
                    if (is_kdv)
                        std_satis = price_kdv;
                    else
                        std_satis = wrk_round((price*(100+tax)) / 100);
                }
                if (fiyat_istenen_fiyat)
                {
					// Promosyondan gelen yüzde veya tutar indirimi (Fiyattan gelse bile üzerine yazar)
                    if (get_prom.recordcount and len(get_prom.discount))
                    {
                        prom_yuzde = get_prom.discount;
                        prom_tutar_ind = '';
                    }
                    else if(get_prom.recordcount and len(get_prom.amount_discount) and (get_prom.amount_discount lte std_satis))
                        prom_tutar_ind = wrk_round(get_prom.amount_discount);
 
                   	satir1 = yerles(satir1, 0, 5, 1, " ");										// simdilik yeni kayıt olarak export ediyoruz
                    satir1 = yerles(satir1, left("#product_id#.#stock_id#", 24), 6, 24, " ");	// stok kodu
					satir1 = yerles(satir1, left("#product_id#.#stock_id#", 24), 30, 24, " ");	// eski stok kodu
                    satir1 = yerles(satir1, left(product_name_, 40), 54, 40, " ");				// stok karti aciklamasi
                    satir1 = yerles(satir1, left(product_name_, 40), 94, 40, " ");				// ekstra stok karti aciklamasi

                    satir1 = yerles(satir1, left(product_name_, 20), 134, 20, " ");				// pos ekranı aciklamasi
                    satir1 = yerles(satir1, left(product_name_, 20), 154, 20, " ");				// raf etiketi aciklamasi
                    satir1 = yerles(satir1, left(product_name_, 16), 174, 16, " ");				// terazi etiketi aciklamasi
                   				
					//Workcube orjinal hal Bolum(SC006),Reyon(SC007),Tip(SC008)
					if (Listlen(product_code,".") gte 2) 
						satir1 = yerles(satir1, ListGetAt(product_code,1,"."), 190, 8, " ");	// Departman ERSAN icin urun kategorisinin ilk noktadan onceki bolumu  
					else																		// Or:001.002.003 kodlu kategori icin 001 
						satir1 = yerles(satir1, 0, 190, 8, " ");	

					if (Listlen(product_code,".") gte 3)
					{
						reyon1 = ListGetAt(product_code,1,".");
						reyon2 = ListGetAt(product_code,2,".");
						satir1 = yerles(satir1, left(reyon1&reyon2,8), 198, 8, " ");			// Reyon ERSAN icin urun kategorisinin ikinci noktadan onceki bolumu nokta haric
					}																			// Or:001.002.003 kodlu kategori icin 001002 8 karakter siniri eklendi	
					else																		
						satir1 = yerles(satir1, 0, 198, 8, " ");					
						
					if (len(company_id)) 
						satir1 = yerles(satir1, company_id, 206, 8, " ");						// Urun Tipi tedarikci id (SC008)
						
                    unit_id_ = listfindnocase("Adet,kg,metre,litre", stock_unit);
                    unit_id_ = iif(unit_id_ gt 0, unit_id_-1, 6);

					//Birimdeki paket carpan sayisi icin eklendi. sadece Paket,koli,kutu icin kasaya adet gibi gidecek BK 20090403
					if(x_genius_box_price eq 1 and listfindnocase("Paket,Koli,Kutu", stock_unit))
						unit_id_ = 0;
					
					//onceki hali BK 20090408 satir1 = yerles(satir1, replace(left(std_satis ,15),".",","), 356, 15, " "); // satis fiyatı
					
					if(x_genius_box_price eq 0 and not listfindnocase("Paket,Koli,Kutu", stock_unit))
	                    satir1 = yerles(satir1, replace(left(std_satis ,15),".",","), 356, 15, " ");					// satis fiyatı adet ve kg birimleri icin yukardaki fiyat alinir
					else
					{
						temp_std_satis = std_satis / multiplier;
						satir1 = yerles(satir1, replace(left(temp_std_satis ,15),".",","), 356, 15, " ");               // satis fiyatı paket,koli,kutu birimleri icin carpan degeri kullanilarak bulunan fiyat alinir BK 20080415
					}
					
					if(len(prom_tutar_ind))
						std2_satis = std_satis - prom_tutar_ind;
					else
						std2_satis = std_satis;
						satir1 = yerles(satir1, replace(left(std2_satis ,15),".",","), 371, 15, " ");					//Satis fiyati2 alani, indirimli tutari gosterir

                   	//satir1 = yerles(satir1, 1, 386, 15, " ");															// kdv dahil Selam icin altta duzenlendi 20140818
					satir1 = yerles(satir1, 1023, 526, 15, " ");														// kdv dahil fiyat 
					
                    // fiyatlar yerleşir bitti
                
                    // Ürün Birimleri ve bu Birimlerin Çarpanları/Bölenleri alınmalı
                    // daha sonra bu array den Bizim Ürünümüze karşılık gelen ve
                    // Genius da karşılığı olan id ile yazılmalı erk 20040120
                    // abort(prom_tutar_ind & "ddd"&attributes.indirim_grubu);
 
                    if(len(prom_yuzde))
                    {
                        satir1 = yerles(satir1, attributes.indirim_grubu, 214, 8, " ");			// indirim grubu
                        satir1 = yerles(satir1, 3, 222, 1, " ");								// indirip tipi (grup)
                        satir1 = yerles(satir1, prom_yuzde, 223, 15, " ");						// indirim yuzdesi
                    }
                    else if(len(prom_tutar_ind))
                    {
                        satir1 = yerles(satir1, attributes.indirim_grubu, 214, 8, " ");								// indirim grubu
						satir1 = yerles(satir1, 0, 222, 1, " ");													// indirim tipi - indirim yok(promosyon modülü-Kiler kart için doğru)
                        if(not isdefined("std2_satis"))
							satir1 = yerles(satir1, replace(left(prom_tutar_ind ,15),".",","), 238, 15, " ");			// tutar indirimi
						else
							satir1 = yerles(satir1, replace(left(0 ,15),".",","), 238, 15, " ");			// tutar indirimi
                    }
                    
                    satir1 = yerles(satir1, unit_id_, 283, 1, " ");						// birim id {Genius Karşılığı}
                   	// eski hali BK satir1 = yerles(satir1, multiplier, 299, 15, " ");	// birim carpani
 	
					if(x_genius_box_price eq 0 and not listfindnocase("Paket,Koli,Kutu", stock_unit))				
						satir1 = yerles(satir1, multiplier, 299, 15, " ");			// birim carpani birimdeki carpan ifadesi 
					else
						satir1 = yerles(satir1, '1', 299, 15, " ");					// birim carpani default 1 verilir

                    if (unit_id_ eq 1)
                        satir1 = yerles(satir1, "1000", 284, 15, " ");				// kg ise bölen 1000 olacak k
                    else
                        satir1 = yerles(satir1, 1, 284, 15, " ");					// birim boleni  {simdilik 1}
                    
                    // KDV ler
                    satir1 = yerles(satir1, tax_id-1, 532, 3, " ");					// satis kdv grubu
                    satir1 = yerles(satir1, 0, 535, 3, " ");						// alis kdv grubu default 0
                    satir1 = yerles(satir1, 0, 538, 1, " ");						// Kdv grubu {simdilik 0-kendi kdv si}
                    // digerleri
                    satir1 = yerles(satir1, 0, 539, 15, " ");						// izin verilen minimum satis {simdilik 0-kontrol etme}
                    satir1 = yerles(satir1, 0, 554, 15, " ");						// izin verilen maximum satis {simdilik 0-kontrol etme}
                    satir1 = yerles(satir1, 0, 587, 1, " ");						// satıs durumu {0:satilabilir}
                    satir1 = yerles(satir1, 2, 593, 1, " ");						// indirim durumu {2:yapilabilir}
                    satir1 = yerles(satir1, iif(is_terazi, 1, 0), 687, 1, " "); 	// teraziye gider ?

					// SC083 Promosyonda kullanilacak Katsayı 1 alanı Burda ve Ersan icin urundeki ozel kod var sa 1 yoksa 0 yazıldı 
					if (len(product_code_2) and isnumeric(product_code_2))
						if(xml_coefficient eq 0)
							satir1 = yerles(satir1,1, 688, 15, " ");					
						else
							satir1 = yerles(satir1,product_code_2, 688, 15, " ");					
					else
						satir1 = yerles(satir1,0, 688, 15, " ");
						
                    t=0;															// uretim bilgisi
                    if (isdefined("get_stocks.is_worker") and get_stocks.is_worker eq 1) t=4;								// calısan icin 4
                    if (isdefined("get_stocks.is_retired") and get_stocks.is_retired eq 1) t=t+2;							// emekli icin 2
                    if (t neq 0) satir1 = yerles(satir1,t, 823, 1, " ");			// emekli ve calısanin toplami
                    
                    row_count = 0;
                    if (unit_id_ neq 6)
                    {
						urun_say = urun_say + 1;
                        file_content[index_array] = "#satir1#";
                        index_array = index_array+1;
                    }
                    else
                    {
                        file_content2[index_array2] = "#left(satir1,50)# (Genius Birim Sorunu)";
                        index_array2 = index_array2+1;
                    }
                }
                temp_barkod = '';
                </cfscript>
                <cfif (fiyat_istenen_fiyat)>
                    <cfoutput>
                    <cfscript>
	                // 2. SATIR (Barkod Bilgileri)
                    // yukarıda ürün gelir burada çalıştırılacak fonk ile de
                    // bizim her stock_id miz icin genius ta 99 barkod olabilir 20050305
                    is_barkod_price_flag = true;
                    if(temp_stock_unit_id neq product_unit_id and attributes.price_catid gt 0)
                    {/* 20050609 eger cesidin ana birimi kendisine eklenmis ek barkodun biriminden farkli ise ek barkodun birimine ait
                        satis fiyatini ariyoruz, bulursak o fiyati kullanacagiz, bulamazsak bu barkodu atlayacagiz, Genius is mantigini
                        gelistirir ve urunun cesidinin barkodlarinin birimleri de alabilirsek yukadirdaki unit_id_ set eden ifadeler buraya da alinmali*/
                        get_price_end = get_price(unit_id : product_unit_id, stock_id : stock_id, price_catid : attributes.price_catid); // şube fiyatlarını al
                        if (get_price_end.recordcount)
                        {
                            if (get_price_end.is_kdv is "1")
                                std_satis = get_price_end.price_kdv;
                            else
                                std_satis = wrk_round((get_price_end.price*(100+tax)) / 100);
                        }
                        else
                            is_barkod_price_flag = false;
                    }
                    if(is_barkod_price_flag and row_count lte 98)
                    {
                        row_count = row_count + 1;
                        satir2 = yerles(satir2, 0, 5, 1, " ");										// islem turu default 0
                        satir2 = yerles(satir2, left("#product_id#.#stock_id#",24), 6, 24, " ");	// iliskili stok kodr
                        satir2 = yerles(satir2, barcod, 30, 24, " ");								// b
                        satir2 = yerles(satir2, barcod, 54, 24, " ");								// eski barkodarkod

                        // BK 20090415 eski hali satir2 = yerles(satir2, 1, 78, 24, " ");			// birim miktar simdilik 1

						//Birimdeki paket carpan sayisi icin eklendi. sadece Paket,koli,kutu icin BK 20090403
						if(x_genius_box_price eq 0 and not listfindnocase("Paket,koli,kutu", stock_unit))
							satir2 = yerles(satir2, 1, 78, 24, " ");								// Birim miktar simdilik 1
						else
							satir2 = yerles(satir2, multiplier, 78, 24, " ");						// Birim miktar carpan olarak geliyor

                        satir2 = yerles(satir2, 0, 84, 1, " ");										// default 0 bilinmiyor
                        satir2 = yerles(satir2, 0, 85, 1, " ");										// fiyat bilgilerinden hangisi ise default 0
                        satir2 = yerles(satir2, row_count, 86, 2, " ");								// sira numarasi
                        satir2 = yerles(satir2, replace(left(std_satis ,15),".",","), 88, 15, " ");	// barkod fiyatı
                        if (unit_id_ neq 6)
                        {
                            file_content[index_array] = "#satir2#";
                            index_array = index_array+1;
                            //detayli bakmak icin acınız performans adına kapatıldı BK 20080724 writeoutput("<font size=2>#get_stocks.currentrow#:#product_name_#,#BARCOD#</font><br/>");
                        }
                        else
						{
							file_content2[index_array2] = "#left(satir2,50)# (Genius Birim Sorunu)";
							index_array2 = index_array2+1;
						}
                    }
                    else
                    {
                        file_content2[index_array2] = "#product_name_# (#product_id#.#stock_id#) icin fazla barkod veya barkoda ait birime uygun fiyat bulunamadi. Alınamayan barkod:#barcod#";
                        index_array2 = index_array2+1;
                    }
                    </cfscript>
                    </cfoutput>
                </cfif>
			<cfelseif attributes.target_pos is "-3"><!--- NCR --->
                <cfoutput>
                <cfscript>
                satir1 = repeatString(" ",78);
                if (len(property))
                    product_name_ = left("#product_name# - #property#", 20);
                else
                    product_name_ = left(product_name, 20);
                if (attributes.price_catid gt 0)
                {
                    get_price_end = get_price(unit_id : product_unit_id, stock_id : stock_id, price_catid : attributes.price_catid); // şube fiyatlarını al
                    if (get_price_end.recordcount)
                    {
                        stock_unit = get_price_end.add_unit;
                        if (get_price_end.is_kdv is "1")
                            std_satis = get_price_end.price_kdv;
                        else
                            std_satis = round((get_price_end.price*(100+TAX)) / 100);
                    }
                    else
                    {
                        stock_unit = add_unit;
                        if (is_kdv)
                            std_satis = price_kdv;
                        else
                            std_satis = round((price*(100+TAX)) / 100);
                    }
                }
                else
                {
                    stock_unit = add_unit;
                    if (is_kdv)
                        std_satis = price_kdv;
                    else
                        std_satis = round((price*(100+TAX)) / 100);
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
                    //14062005 satir1 = yerles(satir1, "2", 24, 1, " ");// VAT kodu (kilerde 2 ???)
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
			<cfelseif attributes.target_pos is "-5"><!--- NCR AS@R--->
                <cfoutput>
                <cfscript>
                satir1 = repeatString(" ",78);
                if (len(property))
                    product_name_ = left("#product_name# - #property#", 20);
                else
                    product_name_ = left(product_name, 20);
                if (attributes.price_catid gt 0)
                {
                    get_price_end = get_price(unit_id : product_unit_id, stock_id : stock_id, price_catid : attributes.price_catid); // şube fiyatlarını al
                    if (get_price_end.recordcount)
                    {
                        stock_unit = get_price_end.add_unit;
                        if (get_price_end.is_kdv is "1")
                            std_satis = get_price_end.price_kdv;
                        else
                            std_satis = round((get_price_end.price*(100+TAX)) / 100);
                    }
                    else
                    {
                        stock_unit = add_unit;
                        if (is_kdv)
                            std_satis = price_kdv;
                        else
                            std_satis = round((price*(100+TAX)) / 100);
                    }
                }
                else
                {
                    stock_unit = add_unit;
                    if (is_kdv)
                        std_satis = price_kdv;
                    else
                        std_satis = round((price*(100+TAX)) / 100);
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
                    //14062005 satir1 = yerles(satir1, "2", 24, 1, " ");// VAT kodu (kilerde 2 ???)
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
                    satir1 = yerles_saga(satir1, std_satis, 71, 8, "0");	// fiyat
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
                    //detayli bakmak icin acınız performans adına kapatıldı BK 20080724 writeoutput("<font size=2>#get_stocks.currentrow#:#product_name_# BR:#BARCOD#,#stock_unit#</font><br/>");
                }
                else
                {
                    file_content2[index_array2] = ":::#hata_str#_#get_stocks.currentrow#:#product_name_#_Barcod:#BARCOD#_Fiyat:#std_satis#_Birim:#stock_unit#";
                    index_array2 = index_array2+1;
                }
                </cfscript>
                </cfoutput>
            <cfelseif attributes.target_pos eq -2><!--- Inter MPOS --->
                <cfscript>
                    row_count = 0;
                                    
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
                    
                    if (attributes.price_catid gt 0)
                    {
                        get_price_end = get_price(unit_id : product_unit_id, stock_id : stock_id, price_catid : attributes.price_catid); // şube fiyatlarını al
                        if (get_price_end.recordcount)
                        {
                            stock_unit = get_price_end.add_unit;
                            if (get_price_end.is_kdv is "1")
                                std_satis = get_price_end.price_kdv;
                            else
                                std_satis = round((get_price_end.price*(100+tax)) / 100);
                        }
                        else
                        {
                            stock_unit = add_unit;
                            if (is_kdv)
                                std_satis = price_kdv;
                            else
                                std_satis = round((price*(100+tax)) / 100);
                        }
                    }
                    else
                    {
                        stock_unit = add_unit;
                        if (is_kdv)
                            std_satis = price_kdv;
                        else
                            std_satis = round((price*(100+tax)) / 100);
                    }
                        
                    if (ceiling(std_satis) eq std_satis)
                        std_satis = ceiling(std_satis) & '.00';
                    else if ((round(std_satis*10)/10) eq std_satis)
                        std_satis = std_satis & '0';
                        
                    if(len(std_satis) gt 10)
                    {
                        writeoutput('İnter Uyumsuz Fiyat:#product_name_# (#std_satis#)<br/>');
                        break;
                    }
                    switch (stock_unit)
                    {
                        case "adet" : unit_id_ = "AD"; break;
                        case "kg" : unit_id_ = "KG"; break;
                        case "metre" : unit_id_ = "MT"; break;
                        case "litre" : unit_id_ = "LT"; break;
                        case "koli" : unit_id_ = "KL"; break;
						case "paket" : unit_id_ = "PK"; break;
                        default : unit_id_ = "  ";
                    }
                        
                    if (len(tax_id) eq 1)
                        my_kdv_ = "0" & tax_id;
                    else
                        my_kdv_ = tax_id;
    
                    urun_say = urun_say + 1;
    
                    my_stock_id = left(stock_id,6);
                    my_stock_id = repeatString("0",6-len(my_stock_id)) & my_stock_id;
    
                    satir1 = "1" & repeatString("x",63);
    
                    if((stock_id neq last_stock_id)) // bundan onceki satirin stock_id si bu satirinki ile ayni ise pluno.idx dosyasine kayit yazilmaz.yo27052005
                    {
                        satir1file3 = "#my_stock_id#" & repeatString(" ",6);			
                        satir1file3 = yerles_saga(satir1file3,aktif_satir,7,6,"0");
                    }
    
                    satir1 = yerles_saga(satir1,stock_id,2,6,"0");
                    satir1 = yerles(satir1,barcod,8,20," ");
                    satir1 = yerles(satir1,product_name_,28,20," ");
                    satir1 = yerles_saga(satir1,std_satis,48,10,"0");
                    satir1 = yerles(satir1,"#my_kdv_#",58,2,"0");
                    satir1 = yerles(satir1,unit_id_,60,4," ");
                    satir1 = yerles(satir1,terazi_,64,1," ");
    
                    //writeoutput("#aktif_satir#-#satir1#<br/>");
                    file_content[index_array] = "#satir1#";
    
                    if((stock_id neq last_stock_id)) // bundan onceki satirin stock_id si bu satirinki ile ayni ise pluno.idx dosyasine kayit yazilmaz.yo27052005
                    {
                        file_content_file3[index_array_pluno] = "#satir1file3#";
                        index_array_pluno = index_array_pluno+1;
                    }
    
                    ROW_OF_QUERY = ROW_OF_QUERY + 1;
                    QueryAddRow(ALL_BARCODES,1);
                    QuerySetCell(ALL_BARCODES,"BARCOD",barcod,ROW_OF_QUERY);
                    QuerySetCell(ALL_BARCODES,"NORMAL_SIRA",aktif_satir,ROW_OF_QUERY);
                    QuerySetCell(ALL_BARCODES,"STOCK_ID",my_stock_id,ROW_OF_QUERY);
                    
                    last_stock_id = stock_id; // son kayitin stock_id si bi sonraki kayitla karsilastirmak amacli olarak tutulur.yo27052005
                    index_array = index_array+1;
                    aktif_satir = aktif_satir+1;
                </cfscript>
			<cfelseif attributes.target_pos eq -6><!--- ESPOS --->
				<cfoutput>
					<cfscript>
						satir1 = "1" & repeatString(" ",78);	
						if (len(property))
							product_name_ = left("#product_name# - #property#", 20);
						else
							product_name_ = left(product_name, 20);	
							
						if (is_terazi eq 1)
							is_terazi_ = "E";
						else
							is_terazi_ = "H";            	       						
						
						if (attributes.price_catid gt 0)
						{
							get_price_end = get_price(unit_id : product_unit_id, stock_id : stock_id, price_catid : attributes.price_catid); // sube fiyatlarini al
							if (get_price_end.recordcount)
							{
								stock_unit = get_price_end.add_unit;
								if (get_price_end.is_kdv is "1")
								{
									std_satis = wrk_round(get_price_end.price_kdv);
									std_satis_money = get_price_end.money;
								}
								else
								{
									std_satis = wrk_round((get_price_end.price*(100+tax)) / 100);
									std_satis_money = get_price_end.money;
								}
							}
							else
							{
								stock_unit = add_unit;
								std_satis_money = money;
								if (is_kdv)
									std_satis = wrk_round(price_kdv);
								else
									std_satis = wrk_round((price*(100+tax)) / 100);
							}
						}
						else
						{
							stock_unit = add_unit;
							std_satis_money = money;
							if (is_kdv)
								std_satis = wrk_round(price_kdv,2,0);
							else
								std_satis = wrk_round((price*(100+tax)) / 100);
						}
	
						if (len(stock_unit))
							stock_unit_ = left(stock_unit, 4);
							
						satir1 = yerles_saga(satir1,stock_id,2,6,"0");									// Plu No Stock_id 
						satir1 = yerles(satir1, barcod, 8, 20, " ");									// Barkod 
						satir1 = yerles(satir1, product_name_, 28, 20, " ");							// Urun Adi
						
						satir1 = yerles_saga(satir1, replace((std_satis*100),'.',''), 48, 9, "0");		// Fiyat kurus ayari
		
						//ifade 3 karekter ise ornek D01 01 yazılmalı
						satir1 = yerles(satir1, 0, 57, 2, "0");										
						departman_ = 0;	
												
						if((len(product_code_2) eq 3) and isnumeric(mid(product_code_2,2,2)))			// Departman numarasi
						{
							satir1 = yerles_saga(satir1, mid(product_code_2,2,2), 57, 2, "0");
							departman_ = mid(product_code_2,2,2);
						}
						
						satir1 = yerles(satir1, stock_unit_, 59, 4, " ");								// Birim		
						satir1 = yerles(satir1, is_terazi_, 63, 1, " "); 								// Terazi durumu Tartilir veya tartilmaz ?
							
						satir1 = yerles(satir1, '000000', 64, 6, " ");									// Reyon daha sonra kullanilabilir promosyonlar icin
						satir1 = yerles(satir1, '0000000000', 70, 10, " ");								// Ikinci Birim Fiyati
						
						file_content[index_array] = "#satir1#";
						urun_say = urun_say + 1;
						index_array = index_array+1;
					</cfscript>
				</cfoutput>
			<cfelseif attributes.target_pos eq -8><!--- Wincor Nixdorf --->
				<cfset my_date_wincor = year(now())&NumberFormat(month(now()),00)&NumberFormat(day(now()),00)>
				<cfoutput>
					<cfscript>
						ayrac_ = '"';
						ayrac2_ = ',';
						satir1 = '"' & repeatString(" ",733);
						
						if (attributes.price_catid gt 0)
						{
							get_price_end = get_price(unit_id : product_unit_id, stock_id : stock_id, price_catid : attributes.price_catid); // şube fiyatlarını al
							if (get_price_end.recordcount)
							{
								stock_unit = get_price_end.add_unit;
								if (get_price_end.is_kdv is "1")
									std_satis = wrk_round(get_price_end.price_kdv,2);
								else
									std_satis = wrk_round((get_price_end.price*(100+TAX)) / 100,2);
							}
							else
							{
								stock_unit = add_unit;
								if (is_kdv)
									std_satis = wrk_round(price_kdv,2);
								else
									std_satis = wrk_round((price*(100+TAX)) / 100,2);
							}
						}
						else
						{
							stock_unit = add_unit;
							if (is_kdv)
								std_satis = wrk_round(price_kdv,2);
							else
								std_satis = wrk_round((price*(100+TAX)) / 100,2);
						}
						
						std_satis = (std_satis*100); //Fiyat yuz ile carpilir

						if (len(property))
							product_name_ = left("#product_name# - #property#", 30);
						else
							product_name_ = left(product_name, 30);	
							
						if (len(unit_id) eq 1)
							unit_id_ = "0" & unit_id;
						else
							unit_id_ = unit_id;	
				
						if (len(tax) eq 1)
							tax_ = "0" & tax & ".00";
						else
							tax_ = tax & ".00";		
																	
											
						satir1 = yerles(satir1,"#product_id#.#stock_id#",2,20," ");			//stok kodu
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 22, 3," ");	
						satir1 = yerles(satir1,barcod,25,20," ");							//barkod
						satir1 = yerles(satir1,"#ayrac_##ayrac2_#", 45, 2," ");
						satir1 = yerles(satir1,"#unit_id_#", 47, 2,"");						//birim
						satir1 = yerles(satir1,"#ayrac2_##ayrac_#", 49, 2," ");
						satir1 = yerles(satir1,"#product_name_#", 51, 30," ");				//urun adi
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 81, 3," ");	
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 114, 3," ");	
						satir1 = yerles(satir1,"#left(product_name_,20)#", 117, 20," ");	//Fatura aciklama
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 137, 3," ");	
						satir1 = yerles(satir1,"#left(product_name_,13)#", 140, 13," ");	//Fis aciklama
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 153, 3," ");							
						satir1 = yerles(satir1,"#left(product_name_,20)#", 156, 20," ");	//Raf aciklama
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 176, 3," ");							
						satir1 = yerles(satir1,"#left(product_name_,16)#", 179, 16," ");	//Terazi aciklama
						satir1 = yerles(satir1,"#ayrac_##ayrac2_#", 195, 2," ");
						satir1 = yerles(satir1,"00", 197, 2," ");							//Pos Grubu

						satir1 = yerles(satir1,"#ayrac2_#", 199, 1," ");	
						satir1 = yerles(satir1,"1", 200, 1," ");							//Aktif
						satir1 = yerles(satir1,"#ayrac2_##ayrac_#", 201, 2," ");
						
						satir1 = yerles(satir1, ListGetAt(product_code,1,"."), 203, 8, " ");//Ana Departman Kodu
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 211, 3," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 222, 3," ");		
						satir1 = yerles(satir1, ListGetAt(product_code,1,"."), 225, 8, " ");//Reyon Kodu
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 233, 3," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 244, 3," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 255, 3," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 266, 3," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 277, 3," ");		
						satir1 = yerles(satir1, ucase(left(add_unit,8)), 280, 8, " ");		//Ana Birim Kodu
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 288, 3," ");		
						satir1 = yerles(satir1, ucase(left(add_unit,4)), 291, 4, " ");		//Ana Birim Kısa Kodu
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 295, 3," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 306, 3," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_#", 313, 2," ");		
						satir1 = yerles(satir1,"0.000", 318, 5," ");						//Ikinci Birim Carpani						
						satir1 = yerles(satir1,"#ayrac2_##ayrac_#", 323, 2," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 333, 3," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_#", 340, 2," ");		
						satir1 = yerles(satir1,"0.000", 345, 5," ");						//Ucuncu Birim Boleni						
						satir1 = yerles(satir1,"#ayrac2_#", 350, 1," ");		
						satir1 = yerles(satir1,"#ayrac2_#", 357, 1," ");		
						satir1 = yerles(satir1,"0.00", 357, 4," ");							//Birinci Alis Fiyati						
						satir1 = yerles(satir1,"#ayrac2_#", 361, 1," ");		
						satir1 = yerles(satir1,"0.00", 368, 4," ");							//Ikinci Alis Fiyati						
						satir1 = yerles(satir1,"#ayrac2_#", 372, 1," ");		
						satir1 = yerles(satir1,"0.00", 379, 4," ");							//Ucuncu Alis Fiyati						
						satir1 = yerles(satir1,"#ayrac2_#", 383, 1," ");		
						satir1 = yerles(satir1,"#left(std_satis,10)#", 396-len(std_satis), 10," ");	//Birinci Satis Fiyati
						satir1 = yerles(satir1,"#ayrac2_#", 396, 1," ");		
						satir1 = yerles(satir1,"0", 408, 1," ");								//Ikinci Satis Fiyati
						satir1 = yerles(satir1,"#ayrac2_#", 409, 1," ");		
						satir1 = yerles(satir1,"0", 421, 1," ");								//Ucuncu Satis Fiyati
						satir1 = yerles(satir1,"#ayrac2_#", 422, 1," ");		
						satir1 = yerles(satir1,"0.000", 423, 5," ");							//Dovizli Alis Fiyati	
						satir1 = yerles(satir1,"#ayrac2_#", 428, 1," ");						
						satir1 = yerles(satir1,"#left(std_satis,10)#", 441-len(std_satis), 10," ");	//Dovizli Satis Fiyati
						satir1 = yerles(satir1,"#ayrac2_#", 441, 1," ");						
						satir1 = yerles(satir1,"0", 443, 1," ");									//Doviz Kodu TL
						satir1 = yerles(satir1,"#ayrac2_#", 444, 1," ");						
						satir1 = yerles(satir1,"#tax_#", 445, 5," ");								//KDV Oranı
						satir1 = yerles(satir1,"#ayrac2_##ayrac_#", 450, 2," ");		
						satir1 = yerles(satir1,"100000", 452,6," ");								//Fiyat KDV Tipi
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 458, 3," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_#", 471, 2," ");		
						satir1 = yerles(satir1,"0", 475, 1," ");									//Temin Suresi
						satir1 = yerles(satir1,"#ayrac2_#", 476, 1," ");							
						satir1 = yerles(satir1,"0.000", 478,5," ");									//Raf Siparis Seviyesi
						satir1 = yerles(satir1,"#ayrac2_#", 483, 1," ");							
						satir1 = yerles(satir1,"0.000", 485,5," ");									//Raf Kritik Stok Seviyesi
						satir1 = yerles(satir1,"#ayrac2_#", 490, 1," ");							
						satir1 = yerles(satir1,"0.000", 492,5," ");									//Raf Azami Stok Seviyesi
						satir1 = yerles(satir1,"#ayrac2_#", 497, 1," ");							
						satir1 = yerles(satir1,"0.000", 499,5," ");									//Depo Siparis Seviyesi
						satir1 = yerles(satir1,"#ayrac2_#", 504, 1," ");							
						satir1 = yerles(satir1,"0.000", 506,5," ");									//Depo Kritik Stok Seviyesi
						satir1 = yerles(satir1,"#ayrac2_#", 511, 1," ");							
						satir1 = yerles(satir1,"0.000", 513,5," ");									//Depo Azami Stok Seviyesi
						satir1 = yerles(satir1,"#ayrac2_#", 518, 1," ");		
	                    satir1 = yerles(satir1, iif(is_terazi, 1, 0), 519, 1, " "); 				//Mal Kasada tartılır mı
						satir1 = yerles(satir1,"#ayrac2_##ayrac_#", 520, 2," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_#", 542, 2," ");		
						satir1 = yerles(satir1,"01", 544, 2," ");									//Barkod Birimi
						satir1 = yerles(satir1,"#ayrac2_##ayrac_#", 546, 2," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_#", 568, 2," ");		
						satir1 = yerles(satir1,"01", 570, 2," ");	
						satir1 = yerles(satir1,"#ayrac2_#", 572, 1," ");		
						satir1 = yerles(satir1,"0", 573, 1," ");									
								
						satir1 = yerles(satir1,"#ayrac2_#", 574, 1," ");		
						satir1 = yerles(satir1,"0", 575, 1," ");									
						satir1 = yerles(satir1,"#ayrac2_##ayrac_#", 576, 2," ");
						satir1 = yerles(satir1,"#my_date_wincor#", 578, 8," ");						//Fiyat Uygulama Tarihi
						satir1 = yerles(satir1,"#ayrac_##ayrac2_#", 586, 2," ");	
						satir1 = yerles(satir1,"0.00", 590, 4," ");									//Hedef Kar Yuzdesi
						satir1 = yerles(satir1,"#ayrac2_#", 594, 1," ");		

						satir1 = yerles(satir1,"0", 606, 1," ");									//Dorduncu Satis Fiyati
						satir1 = yerles(satir1,"#ayrac2_#", 607, 1," ");		
						satir1 = yerles(satir1,"0", 619, 1," ");									//Besinci Satis Fiyati
						satir1 = yerles(satir1,"#ayrac2_#", 620, 1," ");		

						satir1 = yerles(satir1,"0.00", 623, 4," ");									//Birinci Miktar
						satir1 = yerles(satir1,"#ayrac2_#", 627, 1," ");		
						satir1 = yerles(satir1,"0.00", 630, 4," ");									//Ikinci Miktar
						satir1 = yerles(satir1,"#ayrac2_#", 634, 1," ");		
						satir1 = yerles(satir1,"0.00", 637, 4," ");									//Ucuncu Miktar
						satir1 = yerles(satir1,"#ayrac2_#", 641, 1," ");		
						satir1 = yerles(satir1,"0.00", 644, 4," ");									//Doruncu Miktar
						satir1 = yerles(satir1,"#ayrac2_#", 648, 1," ");		
						satir1 = yerles(satir1,"0.00", 651, 4," ");									//Besinci Miktar
						satir1 = yerles(satir1,"#ayrac2_#", 655, 1," ");		
						satir1 = yerles(satir1,"0.00", 656, 4," ");									//Stok Indirim Yuzdesi
						satir1 = yerles(satir1,"#ayrac2_#", 660, 1," ");		
						
						satir1 = yerles(satir1,"0", 672, 1," ");									//Stok Indirim YTL
						satir1 = yerles(satir1,"#ayrac2_#", 673, 1," ");		
						satir1 = yerles(satir1,"0", 674, 1," ");									//Urun satilabilir mi
						satir1 = yerles(satir1,"#ayrac2_#", 675, 1," ");		
						satir1 = yerles(satir1,"0", 676, 1," ");									//Urun iade alınabilir mi
						satir1 = yerles(satir1,"#ayrac2_#", 677, 1," ");		
						satir1 = yerles(satir1,"0", 678, 1," ");									//Puan Carpani miktara mı tutara mı
						satir1 = yerles(satir1,"#ayrac2_#", 679, 1," ");		
						satir1 = yerles(satir1,"0", 689, 1," ");									//Puan Carpani
						satir1 = yerles(satir1,"#ayrac2_#", 690, 1," ");		
						satir1 = yerles(satir1,"0", 695, 1," ");									//Minimum Satis Miktari
						satir1 = yerles(satir1,"#ayrac2_#", 696, 1," ");		
						satir1 = yerles(satir1,"99999", 697, 5," ");								//Maksimum Satis Miktari
						satir1 = yerles(satir1,"#ayrac2_##ayrac_#", 702, 2," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 712, 3," ");		
						satir1 = yerles(satir1,"#ayrac_##ayrac2_##ayrac_#", 723, 3," ");		
						satir1 = yerles(satir1,"#ayrac_#", 734, 1," ");		

						file_content[index_array] = "#satir1#";
						urun_say = urun_say + 1;
						index_array = index_array+1;
					</cfscript>
				</cfoutput>
            </cfif>
            <cfif (get_stocks.currentrow mod 1000) eq 0><!--- 20041210 performans icin --->
                <!--- daha once yukarida eklenmis dosyanin icerigi doluyor --->
                <cfif attributes.target_pos is "-2" >
                    <cffile action="append" output="#ArraytoList(file_content,CRLF)#" file="#upload_folder##file_name1#" charset="ISO-8859-9">
                    <cffile action="append" output="#ArraytoList(file_content_file3,CRLF)#" file="#upload_folder##file_name3#" charset="ISO-8859-9">
                    <cfset file_content = ArrayNew(1)>
                    <cfset file_content_file3 = ArrayNew(1)>
				<cfelse>
                    <cffile action="append" output="#ArraytoList(file_content,CRLF)#" file="#upload_folder##file_name#" charset="ISO-8859-9">
                    <cfset file_content = ArrayNew(1)>
                </cfif>
                <cfset index_array = 1>
                <cfset index_array_pluno = 1>
            </cfif>
        </cfoutput>
					<!--- <cfdump var="#file_content#">
					<cfdump var="#file_name#">
			<cfabort> --->
        <cfif attributes.target_pos is "-2">
            <cfset index_array = 1>
            <cfquery name="ALL_BARCODES" dbtype="query">
                SELECT * FROM ALL_BARCODES ORDER BY BARCOD ASC
            </cfquery>
            <cfoutput query="ALL_BARCODES">
                <cfscript>
                    satir1file2 = "#left(BARCOD,20)#" & repeatString(" ",(26-len(BARCOD)));
                    satir1file2 = yerles_saga(satir1file2,NORMAL_SIRA,21,6,"0");
                    file_content_file2[index_array] = "#satir1file2#";
                    index_array = index_array+1;
                </cfscript>
				<cfif Len(file_name2)><!--- xml e bagli olarak --->
                <cfif (ALL_BARCODES.currentrow mod 1000) eq 0>
                    <cffile action="append" output="#ArraytoList(file_content_file2,CRLF)#" file="#upload_folder##file_name2#" charset="ISO-8859-9">
                    <cfset file_content_file2 = ArrayNew(1)>
                    <cfset index_array = 1>
                </cfif>
				</cfif>
            </cfoutput>
        </cfif>
    
        <cfif (get_stocks.recordcount mod 1000) eq 0>
            <cfset yeni_satir = 0>
        <cfelse>
            <cfset yeni_satir = 1>
        </cfif>
    	
        <!--- daha once yukarida eklenmis dosyanin icerigi doluyor --->
        <cfif attributes.target_pos is "-2"><!--- MPOS icin --->
            <cffile action="append" output="#ArraytoList(file_content,CRLF)#" addnewline="#yeni_satir#" file="#upload_folder##file_name1#" charset="ISO-8859-9">
           <cfif Len(file_name2)><!--- xml e bagli olarak --->
				<cffile action="append" output="#ArraytoList(file_content_file2,CRLF)#" addnewline="#yeni_satir#" file="#upload_folder##file_name2#" charset="ISO-8859-9">
				<cffile action="append" output="#ArraytoList(file_content_file3,CRLF)#" addnewline="#yeni_satir#" file="#upload_folder##file_name3#" charset="ISO-8859-9">
           </cfif>
		   <cfset file_content_file2 = ''>
            <cfset file_content_file3 = ''>
			<!--- MPOS kasalar icin eklendi Pos klasoru altına olusan dosyayi kopyalar BK 20090519  --->
			<cfif x_mpos_file_copy eq 1>
				<cfif not DirectoryExists("#upload_folder_mpos#")>
					<cfdirectory action="create" name="as" directory="#upload_folder_mpos#" recurse="yes">
				</cfif>
				<cffile action="copy" source="#upload_folder##file_name1#" destination="#upload_folder_mpos#">
				<cfif Len(file_name2)><!--- xml e bagli olarak --->
					<cffile action="copy" source="#upload_folder##file_name2#" destination="#upload_folder_mpos#">
					<cffile action="copy" source="#upload_folder##file_name3#" destination="#upload_folder_mpos#">
				</cfif>
			</cfif>
        <cfelseif attributes.target_pos is "-8">
			<cffile action="append" output="#ArraytoList(file_content,CRLF)#" addnewline="#yeni_satir#" file="#upload_folder##file_name#" charset="ISO-8859-9">
		<cfelse>
            <cffile action="append" output="#ArraytoList(file_content,CRLF)#" addnewline="#yeni_satir#" file="#upload_folder##file_name#" charset="UTF-8"><!--- FBS ISO-8859-9 --->
        </cfif>
        <cfset file_content = ''>
        <hr>
		<!--- eger hatali urun kodu ve birimi varsa --->
		<cfif ArrayLen(file_content2) neq 0>
			<cfif attributes.target_pos is "-1">
			  <!--- Genius icin --->
				<strong><cf_get_lang no="403.Genius"><cf_get_lang no="563.Uyumsuz kayıtlar"> : </strong><br/>
			<cfelseif attributes.target_pos is "-3"><!--- NCR icin --->
				<strong><cf_get_lang no="1666.NCR Uyumsuz kayıtlar"> : </strong><br/>
			<cfelseif attributes.target_pos is "-2"><!--- MPOS icin --->
				<strong><cf_get_lang no="564.Inter Uyumsuz Kayıtlar"> : </strong><br/>
		   <!---  <cfelseif attributes.target_pos is "-4"><!--- Workcube icin --->
				<strong>Workcube Uyumsuz kayıtlar : </strong><br/> --->
			</cfif>
			<font size=2 color=red>
			<cfoutput>#ArraytoList(file_content2, "<br/>")#</cfoutput> 
			</font>
			<hr>
		</cfif>
		
		<cfoutput>&nbsp; <br/>#urun_say# <cf_get_lang no="566.Adet Ürün Dosyaya Eklendi">.<br/></cfoutput> 
        
        <cfif attributes.target_pos is "-2"><!--- MPOS icin --->
            <cfscript>
            	if(len(file_name2))
					ZipFileNew(zipPath:expandPath("/documents/store/#file_name#"),toZip:expandPath("/documents/store/temp/#session.ep.userid#/"),relativeFrom:'#upload_folder#');
				else
					ZipFileNew(zipPath:expandPath("/documents/store/#file_name#"),toZip:expandPath("/documents/store/temp/#session.ep.userid#/#file_name1#"),relativeFrom:'#upload_folder#');
            </cfscript>
            <!--- uzerine yazdigi icin eski dosyayi silmeye gerek duyulmadi YO20050531
			<cffile action="delete" file="#upload_folder##file_name1#">
			<cffile action="delete" file="#upload_folder##file_name2#">
			<cffile action="delete" file="#upload_folder##file_name3#">---> 
			
        </cfif>
    </cfif>
	
	<!--- Dosya Loglanır --->
	<cfquery name="ADD_FILE" datasource="#DSN2#">
		INSERT INTO
			FILE_EXPORTS
		(
			TARGET_SYSTEM,
			PROCESS_TYPE,
			PRODUCT_COUNT,
			FILE_NAME,
			FILE_SERVER_ID,
			DEPARTMENT_ID,
			PRODUCT_RECORD_DATE,
			PRICE_RECORD_DATE,
			IS_PHL,
			FILE_STAGE,
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
			-1,
			#urun_say#, <!--- #get_stocks.recordcount#, --->
			'#FILE_NAME#',
			#fusebox.server_machine#,
		<cfif len(attributes.department_id)>#listfirst(attributes.department_id,"-")#<cfelse>NULL</cfif>,
		<cfif isdate(attributes.product_recorddate)>#attributes.product_recorddate#<cfelse>NULL</cfif>,
		<cfif isdate(attributes.price_recorddate)>#attributes.price_recorddate#<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.is_phl")>1<cfelse>0</cfif>,
			#attributes.process_stage#,
			#now()#,
			'#cgi.remote_addr#',
			#session.ep.userid#
		<cfif attributes.target_pos eq -4 and len(attributes.destination_company_id) and len(attributes.destination_company_name)>
			,#attributes.destination_company_id#
		</cfif>
		)
	</cfquery>
	<cfquery name="GET_MAX_FILE_EXPORT" datasource="#DSN2#">
		SELECT MAX(E_ID) AS E_ID FROM #dsn2_alias#.FILE_EXPORTS
	</cfquery>
	
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='0'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#'
		action_table='FILE_EXPORTS'
		action_column='E_ID'
		action_id='#get_max_file_export.e_id#'
		action_page='#request.self#?fuseaction=retail.list_stock_export'
		warning_description = 'File Export Süreci'>
			
	<script type="text/javascript">
		alert('İşlem Yapıldı !');
		wrk_opener_reload();
	</script>
			
	<input type="button" value="<cf_get_lang_main no='141.Kapat'>" onClick="window.close();">
</cfif>
<cfscript>
	get_stocks = '';
	GET_PRICES = '';
	GET_PRICE_END = '';
</cfscript>
