<cfquery name="get_total_p" dbtype="query">
	SELECT SUM(NET_UCRET) AS TOTAL FROM get_puantajs
</cfquery>

<cfscript>
CRLF = Chr(13) & Chr(10);
dosya = ArrayNew(1);
file_name = "#attributes.pay_year#_#attributes.pay_mon#_#listlast(attributes.bank_id,';')#_#dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHMMSS')#.xlsx";

firma_kodu = "#get_comp.RELATION_NUMBER#";
sube_kodu = "#get_comp.BANK_BRANCH_CODE#";
sube_hesap_kodu = "#get_comp.BANK_ACCOUNT_CODE#";

toplam_kayit = get_puantajs.recordcount;
toplam_net_ = get_total_p.TOTAL;


odeme_zamani = "#dateformat(attributes.pay_date,'DDMMYYYY')#";

if(attributes.payment_type eq 1)
	odeme_turu = "M";
else if(attributes.payment_type eq 2)
	odeme_turu = "N";
else if(attributes.payment_type eq 3)
	odeme_turu = "R";
else if(attributes.payment_type eq 4)
	odeme_turu = "M";
doviz = "#session.ep.money#";
</cfscript>

<cfset workBook = createObject("java","org.apache.poi.xssf.usermodel.XSSFWorkbook").init()/>
<cfset newSheet = workBook.createSheet()/>
<cfset workBook.setSheetName(0, "TGB Yeni Maaş Dosyası")/>

<cfset row = newSheet.createRow(0)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Kurum Kodu")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("#firma_kodu#")/>

<cfset row = newSheet.createRow(1)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Sube Kodu")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("#sube_kodu#")/>

<cfset row = newSheet.createRow(2)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Hesap")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("#sube_hesap_kodu#")/>

<cfset row = newSheet.createRow(3)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Toplam Adet")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("#get_puantajs.recordcount#")/>

<cfset row = newSheet.createRow(4)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Toplam Tutar")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("#tlformat(get_total_p.total)#")/>

<cfset row = newSheet.createRow(5)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Döviz Kodu")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("TL")/>

<cfset row = newSheet.createRow(6)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Ödeme Tarihi")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("#odeme_zamani#")/>

<cfset row = newSheet.createRow(7)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Ödeme Tipi")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("#odeme_turu#")/>

<cfset row = newSheet.createRow(8)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Borç Izahat")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("Maaş Ödemesi")/>

<cfset row = newSheet.createRow(9)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("")/>

<cfset row = newSheet.createRow(10)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("")/>

<cfset row = newSheet.createRow(11)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Isim")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("TCKN")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("Banka Kodu")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("Sube Kodu")/>
<cfset cell = row.createCell(4)/>
<cfset cell.setCellValue("Hesap")/>
<cfset cell = row.createCell(5)/>
<cfset cell.setCellValue("IBAN")/>
<cfset cell = row.createCell(6)/>
<cfset cell.setCellValue("Tutar")/>
<cfset cell = row.createCell(7)/>
<cfset cell.setCellValue("Borç Izahat")/>
<cfset cell = row.createCell(8)/>
<cfset cell.setCellValue("Alacak Izahat")/>

<cfset satir_ = 11>
<cfoutput query="get_puantajs">
<cfset satir_ = satir_ + 1>
	<cfscript>
		hesap_no = '#BANK_ACCOUNT_NO#';
		kisi_banka_kodu = '#BANK_CODE#';
		kisi_sube_kodu = '#BANK_BRANCH_CODE#';
		kisi_iban_no = '#IBAN_NO#';	
		kisi_kimlik_no = '#TC_IDENTY_NO#';		
		isim = '#trim(EMPLOYEE_NAME)#';
		soyisim = '#trim(EMPLOYEE_SURNAME)#';
		aciklama = '#trim(left(attributes.detail,13))#';
		kisi_ucret = '#tlformat(net_ucret)#';
	</cfscript>
	
	<cfset row = newSheet.createRow(satir_)/>
	<cfset cell = row.createCell(0)/>
	<cfset cell.setCellValue("#isim# #soyisim#")/>
	<cfset cell = row.createCell(1)/>
	<cfset cell.setCellValue("#kisi_kimlik_no#")/>
	<cfset cell = row.createCell(2)/>
	<cfset cell.setCellValue("#kisi_banka_kodu#")/>
	<cfset cell = row.createCell(3)/>
	<cfset cell.setCellValue("#kisi_sube_kodu#")/>
	<cfset cell = row.createCell(4)/>
	<cfset cell.setCellValue("#hesap_no#")/>
	<cfset cell = row.createCell(5)/>
	<cfset cell.setCellValue("#kisi_iban_no#")/>
	<cfset cell = row.createCell(6)/>
	<cfset cell.setCellValue("#kisi_ucret#")/>
	<cfset cell = row.createCell(7)/>
	<cfset cell.setCellValue("Maaş Ödemesi")/>
	<cfset cell = row.createCell(8)/>
	<cfset cell.setCellValue("Maaş Ödemesi")/>	
</cfoutput>
<cfset fileOutStream = createObject("java","java.io.FileOutputStream").init("#upload_folder#hr#dir_seperator#eislem#dir_seperator##file_name#")/>
<cfset workBook.write(fileOutStream)/>
<cfset fileOutStream.close()/>
