<!--- COMPANYCAT_ID degerinin her firma icin ayri olacagi dusunulerek eklendi. Ep icin Kasa Müşterileri (20) degerine sahip. 
Alttaki ifade tüm firmalarda degismeli. Farklı calısacak firmalarda add_options olmalı BK 20090416 --->
<cf_xml_page_edit fuseact="objects.popup_export_customer_type">
<cfsetting showdebugoutput="no">
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

<cfscript>
	if(attributes.target_pos eq -1 and xml_consumer_card_detail eq 0)
		file_name = "GNDCUST.txt";
	else if(attributes.target_pos eq -2)
	{
		upload_folder = "#upload_folder#store#dir_seperator#temp#dir_seperator##session.ep.userid#_cari#dir_seperator#";
		
		//file_name = "CARI.DAT";
		file_name = "DATA.ZIP";
		file_name1 = "CARI.DAT";
		file_name2 = "CARINO.IDX";
		file_name3 = "CARIKOD.IDX";
	}
	else if(attributes.target_pos eq -1 and xml_consumer_card_detail eq 1)
	{
		wrk_id = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmm')#";
		file_name = "CUST#wrk_id#.TXT";
	}
	else
		file_name = "GNDCUST.GTF";

	CRLF=chr(13)&chr(10);
	file_content = ArrayNew(1);
	file_content_2 = ArrayNew(1);
	file_content_3 = ArrayNew(1);
	index_array = 1;
	index_array_2 = 1;
	index_array_3 = 1;
	
</cfscript>

<cfquery name="GET_MEMBER" datasource="#DSN#">
	SELECT 
		C.COMPANY_ID,
		C.FULLNAME,
		C.OZEL_KOD,
		CASE WHEN LEN(C.COMPANY_ADDRESS) < 1 THEN '  ' ELSE C.COMPANY_ADDRESS END COMPANY_ADDRESS,
		C.SEMT,
		C.COMPANY_TELCODE,
		C.COMPANY_TEL1,
		C.COMPANY_TEL2,
		C.COMPANY_FAX,
		CASE WHEN LEN(C.TAXOFFICE) < 1 THEN 'BULUNAMADI' ELSE C.TAXOFFICE END TAXOFFICE, 
		CASE WHEN LEN(C.TAXNO) < 5 THEN '1111111111' ELSE C.TAXNO END TAXNO,
		C.START_DATE
	FROM 
		COMPANY C,
		COMPANY_BRANCH_RELATED CBR
	WHERE
		C.COMPANY_ID IS NOT NULL AND
		C.OZEL_KOD IS NOT NULL AND		
		<cfif len(xml_member_cat_id)>
		C.COMPANYCAT_ID IN (#xml_member_cat_id#) AND
		</cfif>
		CBR.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')# AND
		C.COMPANY_ID = CBR.COMPANY_ID AND
		LEN(OZEL_KOD) > 0
	ORDER BY
		C.COMPANY_ID
</cfquery>

<cfif attributes.target_pos eq -1 and xml_consumer_card_detail eq 0>
	<cfloop query="get_member">
		<cfscript>
			satir1 = "01" & repeatString(" ",467);													// Satir isareti 01
			satir1 = yerles(satir1, "1", 5, 1, " ");												// Islem Turu 1 Degistir
			satir1 = yerles(satir1, left(ozel_kod,24), 6, 24, " ");									// Cari Kodu
			satir1 = yerles(satir1, left(ozel_kod,24), 30, 24, " ");								// Eski Cari Kodu
			satir1 = yerles(satir1, ucase(left(fullname,30)), 54, 30, " ");							// Musteri Adi
			satir1 = yerles(satir1, '100', 84, 8, " ");												// Grup Kodu 
			satir1 = yerles(satir1, '1', 92, 8, " ");												// Müsteri Kodu 
	
			satir1 = yerles(satir1, '0000', 106, 4, " ");											// Taksit Odeme Metodu Default 0000
			satir1 = yerles(satir1, ucase(left(company_address,30)), 124, 30, " ");					// Adres 1
			if(len(company_address) gt 30)
			{
				temp_deger = (len(company_address)-30);
				if(temp_deger gt 30)
					temp_deger = 30;
				satir1 = yerles(satir1, ucase(mid(company_address,31,temp_deger)), 154, 30, " ");	// Adres 2
			}
	
			satir1 = yerles(satir1, ucase(left(semt,30)), 184, 30, " ");							// Adres 3
	
			satir1 = yerles(satir1, left(company_telcode,3), 244, 3, " ");							// Telefon 1 Kod
			satir1 = yerles(satir1, left(company_tel1,7), 248, 7, " ");								// Telefon 1 Tel	
	
			satir1 = yerles(satir1, left(company_telcode,3), 269, 3, " ");							// Telefon 2 Kod
			satir1 = yerles(satir1, left(company_tel2,7), 273, 7, " ");								// Telefon 1 Tel
	
			satir1 = yerles(satir1, left(company_telcode,3), 294, 3, " ");							// Fax Kod
			satir1 = yerles(satir1, left(company_fax,7), 298, 7, " ");								// Fax Tel
	
			satir1 = yerles(satir1, left(taxoffice,20), 394, 20, " ");								// Vergi Dairesi
			satir1 = yerles(satir1, left(taxno,12), 414, 12, " ");									// Vergi No
			
			satir1 = yerles(satir1, '000000000000001', 446, 15, " ");								// Musterinin Kredi Limiti Default 000000000000001
			satir1 = yerles(satir1, '000,00', 461, 6, " ");											// Uygulanan Iskonto Yuzdesi Default 000,00
	
			satir1 = yerles(satir1, '1', 467, 1, " ");												// Indirimi Tipi Default Sadece Kredili Alimlarda 1
			satir1 = yerles(satir1, '0', 468, 1, " ");												// Reserved Default 0
			satir1 = yerles(satir1, '0', 469, 1, " ");												// Satis Fiyati Index Bilgisi Default 0
	
			satir2 = "02" & repeatString(" ",135);
			satir2 = yerles(satir2, "1", 5, 1, " ");												// Islem Turu 1 Degistir
			satir2 = yerles(satir2, left(ozel_kod,24), 6, 24, " ");									// Kart Kodu
			satir2 = yerles(satir2, left(ozel_kod,24), 30, 24, " ");								// Eski Kart Kodu
			satir2 = yerles(satir2, left(ozel_kod,24), 54, 24, " ");								// Cari Kodu
			satir2 = yerles(satir2, ucase(left(fullname,30)), 78, 30, " ");							// Kart Uzerindeki Isim
			satir2 = yerles(satir2, '0', 108, 1, " ");												// Kart Tipi Default 0 Asil Kart
			satir2 = yerles(satir2, dateformat(start_date,'dd.mm.yyyy'), 123, 14, " ");				// Kartin Verilis Tarihi
			satir2 = yerles(satir2, '2', 137, 1, " ");												// Kartin Durumu Default 2 Gecerli
	
			file_content[index_array] = satir1;
			index_array = index_array+1;
			file_content[index_array] = satir2;
			index_array = index_array+1;
		</cfscript>
	</cfloop>
<cfheader name="Expires" value="#Now()#">
<cfcontent type="text/vnd.plain;charset=UTF-8">
<cfheader name="Content-Disposition" value="attachment; filename=#file_name#"> 
<cfoutput><SIGNATURE=GNDCSTMERS.GDF><VERSION=0225000>
#ArraytoList(file_content,CRLF)#<cfabort></cfoutput>
<cfelseif attributes.target_pos eq -2>
	<cfif attributes.target_pos is "-2" and not DirectoryExists("#upload_folder#")><!--- store#dir_seperator#temp#dir_seperator##session.ep.userid#_cari --->
		<cfdirectory action="create" name="#session.ep.userid#_cari" directory="#upload_folder#">
	</cfif>
	<!--- ilk once dosya eklenir sonra asagida ici doldurulur --->
	<cffile action="write" output="" addnewline="no" file="#upload_folder##file_name1#" charset="UTF-8">
	<cffile action="write" output="" addnewline="no" file="#upload_folder##file_name2#" charset="UTF-8">
	<cffile action="write" output="" addnewline="no" file="#upload_folder##file_name3#" charset="UTF-8">
	<cfset GET_MEMBER_ALL = QueryNew("COMPANY_ID,NORMAL_SIRA,OZEL_KOD","Integer,Integer,VarChar")>
	<cfset ROW_OF_QUERY = 0>
	<cfloop query="get_member">
		<cfscript>
			satir1 = "1" & repeatString(" ",160);													// Flag Normal
			satir1 = yerles_saga(satir1,company_id , 2, 6, "0");									// Musteri Numarasi
			satir1 = yerles(satir1,left(ozel_kod,20) , 8, 20, " ");									// Musteri Cari Kodu (Ozel Kod)
			satir1 = yerles(satir1, ucase(left(fullname,30)), 28, 30, " ");							// Musteri Adi	
			satir1 = yerles(satir1, ucase(left(company_address,40)), 58, 50, " ");					// Adres 
			satir1 = yerles(satir1, ucase(left(taxoffice,15)), 108, 15, " ");						// Vergi Dairesi
			satir1 = yerles(satir1, left(taxno,12), 123, 15, " ");									// Vergi No
			satir1 = yerles(satir1, '0001', 138, 4, " ");											// Musteri Indirim Oranı

			file_content[index_array] = "#satir1#";
			index_array = index_array+1;

			satir2 = repeatString(" ",12);															// Musteri Cari Kodu (Ozel Kod)
			satir2 = yerles_saga(satir2,company_id,1,6,"0");										// Musteri Cari Kodunun CARI.DAT daki yeri
			satir2 = yerles_saga(satir2,currentrow,7,6,"0");										// Musteri Cari Kodunun CARI.DAT daki yeri

			file_content_2[index_array_2] = "#satir2#";
			index_array_2 = index_array_2+1;

			ROW_OF_QUERY = ROW_OF_QUERY + 1;
			QueryAddRow(GET_MEMBER_ALL,1);
			QuerySetCell(GET_MEMBER_ALL,"COMPANY_ID",company_id,ROW_OF_QUERY);
			QuerySetCell(GET_MEMBER_ALL,"NORMAL_SIRA",currentrow,ROW_OF_QUERY);
			QuerySetCell(GET_MEMBER_ALL,"OZEL_KOD",ozel_kod,ROW_OF_QUERY);
		</cfscript>
	</cfloop>
	<cfquery name="GET_MEMBER_CARIKOD" dbtype="query">
		SELECT * FROM GET_MEMBER_ALL ORDER BY OZEL_KOD
	</cfquery>
	<cfloop query="get_member_carikod">
		<cfscript>
			satir3 =  ozel_kod & repeatString(" ",(26-len(left(ozel_kod,25))));						// Musteri Cari Kodu (Ozel Kod)
			satir3 = yerles_saga(satir3,normal_sira , 21, 6, "0");									// Musteri Cari Kodunun CARI.DAT daki yeri

			file_content_3[index_array_3] = "#satir3#";
			index_array_3 = index_array_3+1;
		</cfscript>
	</cfloop>
 	<cffile action="append" output="#ArraytoList(file_content,CRLF)#" file="#upload_folder##file_name1#" charset="UTF8">
	<cffile action="append" output="#ArraytoList(file_content_2,CRLF)#" file="#upload_folder##file_name2#" charset="UTF8">
	<cffile action="append" output="#ArraytoList(file_content_3,CRLF)#" file="#upload_folder##file_name3#" charset="UTF8">
	
	<cfif xml_paper_not_zip eq 1>
		<script type="text/javascript">
			alert("Dosyalar İlgili Klasör Altına Oluşturuldu...");
			window.close();
		</script>
	<cfelse>
		<cfscript>
			ZipFileNew(zipPath:expandPath("/documents/store/#file_name#"),toZip:expandPath("/documents/store/temp/#session.ep.userid#_cari/"),relativeFrom:'#upload_folder#');
		</cfscript>
		<cfheader name="Content-Disposition" value="attachment;filename=DATA.ZIP">
		<cfcontent file="#download_folder#documents#dir_seperator#store#dir_seperator##file_name#" type="application/octet-stream" deletefile="yes">
	</cfif>
<cfelseif attributes.target_pos eq -1 and xml_consumer_card_detail eq 1>
	<cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
		SELECT 
			ISNULL(CC.CARD_NO,' ') CARD_NO,
			LEFT(CONSUMER_NAME + ' ' + CONSUMER_SURNAME,40) NAME,
			ISNULL(IDENTYCARD_NO,'') IDENTYCARD_NO,
			ISNULL(TAX_OFFICE,' ') TAX_OFFICE,
			ISNULL(TAX_NO,' ') TAX_NO,
			ISNULL(SOCIAL_SECURITY_NO,' ') SOCIAL_SECURITY_NO,
			ISNULL(FATHER,' ') FATHER,
			ISNULL(MOTHER,' ') MOTHER,
			ISNULL(BIRTHDATE,' ') BIRTHDATE,
			ISNULL(BIRTHPLACE,' ') BIRTHPLACE,
			ISNULL(SEX,' ') SEX,
			ISNULL(MARRIED,' ') MARRIED,
			ISNULL(TAX_CITY_ID,' ') TAX_CITY_ID,
			ISNULL(BIRTHDATE,' ') ID_GIVEN_DATE,
			ISNULL(TC_IDENTY_NO,'0') TC_IDENTY_NO,
			ISNULL(HOMEADDRESS,' ') HOMEADDRESS,
			ISNULL(TAX_ADRESS,' ') TAX_ADRESS,
			ISNULL(CONSUMER_WORKTELCODE+CONSUMER_WORKTEL,'0') WORKTEL, 
			ISNULL(MOBIL_CODE+MOBILTEL,'0') CELL_PHONE,
			ISNULL(CONSUMER_HOMETELCODE+CONSUMER_HOMETEL,' ') HOMETEL,
			ISNULL(TAX_POSTCODE,' ') TAX_POSTCODE,
			ISNULL(CONSUMER_FAXCODE+CONSUMER_FAX,'') FAX
		FROM 
			CONSUMER C,
			CUSTOMER_CARDS CC
		WHERE
			CC.ACTION_TYPE_ID = 'CONSUMER_ID' AND
			CC.ACTION_ID = C.CONSUMER_ID AND
			CC.CARD_STATUS = 1
	</cfquery>
	
<cfset CRLF = "#chr(13)&chr(10)#">
<cfset CRSPC = "#chr(32)#">
<cfheader name="Expires" value="#Now()#">
<cfcontent type="text/vnd.plain;charset=ISO-8859-9">
<cfheader name="Content-Disposition" value="attachment; filename=#file_name#">
<cfoutput query="get_consumer_detail">

	<cfset satir1 = "1;">																	<!--- Satır No --->
	<cfset satir1 = "#satir1##card_no# ;">													<!--- Kart numarası --->
	<cfset satir1 = "#satir1##name#;">														<!--- Bireysel Ad-soyad --->
	<cfset satir1 = "#satir1#0;">															<!--- DISCOUNT_LIMIT --->
	<cfset satir1 = "#satir1#0;">															<!--- DISCOUNT_PERCENT --->
	<cfset satir1 = "#satir1#2;">															<!--- DISCOUNT_FLAG --->
	<cfset satir1 = "#satir1#1;">															<!--- CK_STOCK_PRICE_NO --->
	<cfset satir1 = "#satir1#000000000000000#CRLF#">										<!--- BONUS --->
	
	<cfset satir2 = "2;">																	<!--- Satır No --->
	<cfset satir2 = "#satir2##CRSPC#;">														<!--- CUST_PARAMETER --->
	<cfset satir2 = "#satir2##tax_office#;">												<!--- Vergi Dairesi --->
	<cfset satir2 = "#satir2##tax_no#;">													<!--- Vergi Numarası --->
	<cfset satir2 = "#satir2##social_security_no#;">										<!--- SSK_NO --->
	<cfset satir2 = "#satir2##father#;">													<!--- Baba Adı --->
	<cfset satir2 = "#satir2##mother#;">													<!--- Ana Adı --->
	<cfset satir2 = "#satir2##CRSPC#;">														<!--- MAIDEN_NAME --->
	<cfset satir2 = "#satir2##dateformat(birthdate,'dd.mm.yyyy')#;">						<!--- Doğum Tarihi --->
	<cfset satir2 = "#satir2##birthplace#;">												<!--- Doğum Yeri --->
	<cfset satir2 = "#satir2##sex#;">														<!--- Cinsiyet --->
	<cfset satir2 = "#satir2##married#;">													<!--- Medeni Durumu Evli = 1 , bekar =0--->
	<cfset satir2 = "#satir2##CRSPC#;">														<!--- internet --->
	<cfset satir2 = "#satir2#0;">															<!--- FK_ACADEMY --->
	<cfset satir2 = "#satir2#0;">															<!--- FK_JOB --->
	<cfset satir2 = "#satir2##CRSPC#;">														<!--- ID_GIVEN_PLACE --->
	<cfset satir2 = "#satir2##tax_city_id#;">												<!--- Fatura bilgilerindeki şehir alanındaki şehrin ID --->
	<cfset satir2 = "#satir2#0;">															<!--- ID_TOWN --->
	<cfset satir2 = "#satir2#0;">															<!--- ID_VILLAGE --->									
	<cfset satir2 = "#satir2#0;">															<!--- ID_REGISTER_NO --->
	<cfset satir2 = "#satir2#0;">															<!--- ID_CILT_NO --->
	<cfset satir2 = "#satir2#0;">															<!--- ID_AILESIRA_NO --->
	<cfset satir2 = "#satir2#0;">															<!--- ID_SIRA_NO --->
	<cfset satir2 = "#satir2##dateformat(birthdate,'dd.mm.yyyy')#;">						<!--- Dogum tarihi --->
	<cfset satir2 = "#satir2##identycard_no#;">												<!--- kimlik kart no alanından veri gelecek  --->
	<cfset satir2 = "#satir2#0;">															<!--- NOTES --->
	<cfset satir2 = "#satir2#0;">															<!--- CUSTOMER_MESSAGE_1 --->
	<cfset satir2 = "#satir2#0;">															<!--- CUSTOMER_MESSAGE_2 --->
	<cfset satir2 = "#satir2#1;">															<!--- LETTER_ADDRESS --->
	<cfset satir2 = "#satir2##left(tax_adress,80)#;">										<!--- Fatura bilgilerindeki adres --->
	<cfset satir2 = "#satir2##worktel#;">													<!--- İş telefonu --->
	<cfset satir2 = "#satir2##cell_phone##CRLF#">											<!--- ilk mobil telefon --->
	
																
	<cfset satir3 = "3;">																	<!--- Satır No --->
	<cfset satir3 = "#satir3#1;">															<!--- NUM --->
	<cfset satir3 = "#satir3#1;">															<!--- DEPENDENT_TYPE_CODE --->
	<cfset satir3 = "#satir3##CRSPC#;">														<!--- NAME --->
	<cfset satir3 = "#satir3#1;">															<!--- SEX --->
	<cfset satir3 = "#satir3##CRSPC#;">														<!--- DATE_OF_BIRTH --->
	<cfset satir3 = "#satir3#0;">															<!--- ACADEMY_CODE --->
	<cfset satir3 = "#satir3##CRSPC#;">														<!--- ACADEMY_DESC --->
	<cfset satir3 = "#satir3#0;">															<!--- FK_JOB --->
	<cfset satir3 = "#satir3##CRSPC#;">														<!--- JOB_DESC --->
	<cfset satir3 = "#satir3##CRSPC#;">														<!--- JOB_ACTIVITY --->
	<cfset satir3 = "#satir3##CRSPC#;#CRLF#">												<!--- JOB_TITLE --->
	
	<cfif len(tax_adress) gt 30>
		<cfset tax_adress_1 ="#left(tax_adress,30)#">
		<cfset tax_adress_2 ="#mid(tax_adress,30,60)#">
		<cfif tax_adress gt 60>
			<cfset tax_adress_3 ="#mid(tax_adress,60,90)#">
		<cfelse>
			<cfset tax_adress_3 =" ">	
		</cfif>
	<cfelse>
		<cfset tax_adress_1 = "#tax_adress#">
		<cfset tax_adress_2 = " ">
		<cfset tax_adress_3 = " ">
	</cfif>
	
	<cfset satir4 = "4;">																	<!--- Satır No --->
	<cfset satir4 = "#satir4#1;">															<!--- ADDRESS_TYPE --->
	<cfset satir4 = "#satir4##card_no#;">													<!--- Kart No --->
	<cfset satir4 = "#satir4##homeaddress#;">												<!--- EV ADRESI --->
	<cfset satir4 = "#satir4##tax_adress_1#;">												<!--- FATURA ADRES ALANINDAKİ İLK 30 KARAKTER --->
	<cfset satir4 = "#satir4##tax_adress_2#;">												<!--- FATURA ADRES ALANINDAKİ İKİNCİ 30 KARAKTER --->
	<cfset satir4 = "#satir4##tax_adress_3#;">												<!--- FATURA ADRES ALANINDAKİ ÜÇÜNCÜ 30 KARAKTER --->
	<cfset satir4 = "#satir4##tax_postcode#;">												<!--- FATURA BİLGİLERİNDEKİ POSTA KODU --->
	<cfset satir4 = "#satir4##tax_city_id#;">												<!--- FATURA BİLGİlERİNDEKİ ŞEHİR ID --->
	<cfset satir4 = "#satir4#1;">															<!--- FK_COUNTRY --->
	<cfset satir4 = "#satir4##hometel#;">													<!--- ev telefonu --->
	<cfset satir4 = "#satir4##worktel#;">													<!--- iş telefonu --->
	<cfset satir4 = "#satir4##fax#;">														<!--- Fax Numarası --->
	<cfset satir4 = "#satir4##cell_phone##CRLF#">											<!--- ilk mobil alandaki mobil telefon numarası --->

	<cfset satir5 = "5;">																	<!--- Satır No --->
	<cfset satir5 = "#satir5##card_no#;">													<!--- Kart No --->
	<cfset satir5 = "#satir5##CRSPC#;">														<!--- PASSWORD --->
	<cfset satir5 = "#satir5#31.12.2020;">													<!--- Son Kullanma tarihi --->	
	<cfset satir5 = "#satir5##CRSPC#;">														<!--- Kart Verilme Tarihi --->
	<cfset satir5 = "#satir5#2;">															<!--- STATUS --->
	<cfset satir5 = "#satir5#0;">															<!--- BONUS --->
	<cfset satir5 = "#satir5#1;#CRLF#">														<!--- CAMPAIGN_PROCESS_TYPE --->
				
	#satir1#
	#satir2#
	#satir3#
	#satir4#
	#satir5#

</cfoutput>
</cfif>
