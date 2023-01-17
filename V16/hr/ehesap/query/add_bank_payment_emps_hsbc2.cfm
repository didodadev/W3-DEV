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


odeme_zamani = "#dateformat(attributes.pay_date,'DDMMYYYY')#";

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
<cfset workBook.setSheetName(0, "HSBC Yeni Maaş Dosyası")/>

<cfset row = newSheet.createRow(0)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Toplam Tutar")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("#tlformat(get_total_p.total)#")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("Üye Kodu:")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("#firma_kodu#")/>

<cfset row = newSheet.createRow(1)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("Borçlu Hesap No:")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("#sube_hesap_kodu#")/>

<cfset row = newSheet.createRow(2)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("Ödeme Tarihi:")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("#dateformat(attributes.pay_date,'DDMMYYYY')#")/>

<cfset row = newSheet.createRow(3)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Personel Hesap No")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("Maaş Tutarı")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("Ad Soyad")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("Açıklama")/>

<cfset satir_ = 3>
<cfoutput query="get_puantajs">
<cfset satir_ = satir_ + 1>
	<cfscript>
		hesap_no = '#BANK_ACCOUNT_NO#';
		kisi_banka_kodu = '#BANK_CODE#';
		kisi_sube_kodu = '#BANK_BRANCH_CODE#';
		kisi_iban_no = '#IBAN_NO#';	
		kisi_kimlik_no = '#TC_IDENTY_NO#';		
		isim = '#trim(left(EMPLOYEE_NAME,12))#';
		soyisim = '#trim(left(EMPLOYEE_SURNAME,13))#';
		aciklama = '#trim(attributes.detail)#';
		kisi_ucret = '#tlformat(net_ucret)#';
	</cfscript>
    <cfquery name="get_bank_account" datasource="#dsn#">
        SELECT RIGHT(BANK_BRANCH_CODE,3) AS BRANCH_CODE FROM EMPLOYEES_BANK_ACCOUNTS WHERE BANK_ACCOUNT_NO = '#trim(hesap_no)#'
    </cfquery>
	<cfset row = newSheet.createRow(satir_)/>
	<cfset cell = row.createCell(0)/>
	<cfset cell.setCellValue("#get_bank_account.branch_code##hesap_no#27000")/>
	<cfset cell = row.createCell(1)/>
	<cfset cell.setCellValue("#kisi_ucret#")/>
	<cfset cell = row.createCell(2)/>
	<cfset cell.setCellValue("#isim# #soyisim#")/>
	<cfset cell = row.createCell(3)/>
	<cfset cell.setCellValue("#aciklama#")/>
	
</cfoutput>
<cfset fileOutStream = createObject("java","java.io.FileOutputStream").init("#upload_folder#hr#dir_seperator#eislem#dir_seperator##file_name#")/>
<cfset workBook.write(fileOutStream)/>
<cfset fileOutStream.close()/>
