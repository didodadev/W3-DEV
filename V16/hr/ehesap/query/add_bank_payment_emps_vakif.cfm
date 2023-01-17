<cfquery name="get_total_p" dbtype="query">
	SELECT SUM(NET_UCRET) AS TOTAL FROM get_puantajs
</cfquery>

<cfscript>
CRLF = Chr(13) & Chr(10);
dosya = ArrayNew(1);
file_name = "#attributes.pay_year#_#attributes.pay_mon#_#listlast(attributes.bank_id,';')#_#dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHMMSS')#.xls";

firma_kodu = "#get_comp.RELATION_NUMBER#";
sube_kodu = "#get_comp.BANK_BRANCH_CODE#";
sube_hesap_kodu = "#get_comp.BANK_ACCOUNT_CODE#";

toplam_kayit = get_puantajs.recordcount;
toplam_net_ = get_total_p.TOTAL;


odeme_zamani = "#dateformat(attributes.pay_date,'DD.MM.YYYY')#";

if(attributes.payment_type eq 1)
	odeme_turu = "M";
else if(attributes.payment_type eq 2)
	odeme_turu = "N";
else if(attributes.payment_type eq 3)
	odeme_turu = "R";
else if(attributes.payment_type eq 4)
	odeme_turu = "Z";
doviz = "#session.ep.money#";
</cfscript>

<cfset workBook = createObject("java","org.apache.poi.hssf.usermodel.HSSFWorkbook").init()/>
<cfset newSheet = workBook.createSheet()/>
<cfset workBook.setSheetName(0, "VB Yeni Maaş Dosyası")/>

<cfset row = newSheet.createRow(1)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("VB Müşteri Numarası")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("Ödeme Tarihi")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("#odeme_zamani#")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("Toplam Ödenecek Tutar ve Personel Sayısı")/>

<cfset row = newSheet.createRow(2)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("Sube Kodu")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("#sube_kodu#")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("#tlformat(get_total_p.total)#")/>


<cfset row = newSheet.createRow(3)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("Kurum Kodu")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("#firma_kodu#")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("#get_puantajs.recordcount#")/>

<cfset row = newSheet.createRow(4)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("Ay")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("#attributes.pay_mon#")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("Para Birimi")/>

<cfset row = newSheet.createRow(5)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("Ödeme Türü")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("#odeme_turu#")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("TL")/>


<cfset row = newSheet.createRow(8)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Personel Adı Soyadı")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("Personel Hesap No")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("Personel Sicil No")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("Meblağ")/>
<cfset cell = row.createCell(4)/>
<cfset cell.setCellValue("Personel Iban No")/>

<cfset satir_ = 9>
<cfoutput query="get_puantajs">
<cfset satir_ = satir_ + 1>
	<cfscript>
		sicil = '#EMPLOYEE_NO#';
		hesap_no = '#BANK_ACCOUNT_NO#';
		kisi_banka_kodu = '#BANK_CODE#';
		kisi_sube_kodu = '#BANK_BRANCH_CODE#';
		kisi_iban_no = '#IBAN_NO#';	
		kisi_kimlik_no = '#TC_IDENTY_NO#';		
		isim = '#trim(left(EMPLOYEE_NAME,12))#';
		soyisim = '#trim(left(EMPLOYEE_SURNAME,13))#';
		aciklama = '#trim(left(attributes.detail,13))#';
		kisi_ucret = '#tlformat(net_ucret)#';
	</cfscript>
	
	<cfset row = newSheet.createRow(satir_)/>
	<cfset cell = row.createCell(0)/>
	<cfset cell.setCellValue("#isim# #soyisim#")/>
	<cfset cell = row.createCell(1)/>
	<cfset cell.setCellValue("#hesap_no#")/>
	<cfset cell = row.createCell(2)/>
	<cfset cell.setCellValue("#kisi_kimlik_no#")/>
	<cfset cell = row.createCell(3)/>
	<cfset cell.setCellValue("#kisi_ucret#")/>
	<cfset cell = row.createCell(4)/>
	<cfset cell.setCellValue("#kisi_iban_no#")/>
</cfoutput>
<cfset fileOutStream = createObject("java","java.io.FileOutputStream").init("#download_folder#documents#dir_seperator#hr#dir_seperator#eislem#dir_seperator##file_name#")/>
<cfset workBook.write(fileOutStream)/>
<cfset fileOutStream.close()/>
