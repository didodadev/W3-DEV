<!--- ING Bankası ödeme dosyası--->
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
	odeme_turu = "M";
doviz = "#session.ep.money#";
</cfscript>

<cfset workBook = createObject("java","org.apache.poi.hssf.usermodel.HSSFWorkbook").init()/>
<cfset newSheet = workBook.createSheet()/>
<cfset workBook.setSheetName(0, "ING Yeni Maaş Dosyası")/>
<cfset row = newSheet.createRow(0)/>
<cfset cell = row.createCell(0)/>
<cfset cell.setCellValue("Şube Kodu")/>
<cfset cell = row.createCell(1)/>
<cfset cell.setCellValue("C")/>
<cfset cell = row.createCell(2)/>
<cfset cell.setCellValue("Hesap No")/>
<cfset cell = row.createCell(3)/>
<cfset cell.setCellValue("MY")/>
<cfset cell = row.createCell(4)/>
<cfset cell.setCellValue("")/>
<cfset cell = row.createCell(5)/>
<cfset cell.setCellValue("Ad")/>
<cfset cell = row.createCell(6)/>
<cfset cell.setCellValue("Soyad")/>
<cfset cell = row.createCell(7)/>
<cfset cell.setCellValue("Tutar")/>
<cfset cell = row.createCell(8)/>
<cfset cell.setCellValue("IBAN")/>

<cfset satir_ = 1>
<cfoutput query="get_puantajs">
	<cfscript>
		hesap_no = '#BANK_ACCOUNT_NO#';
		kisi_banka_kodu = '#BANK_CODE#';
		kisi_sube_kodu = '#BANK_BRANCH_CODE#';
		kisi_iban_no = '#IBAN_NO#';	
		kisi_kimlik_no = '#TC_IDENTY_NO#';		
		if(len(trim(JOIN_ACCOUNT_NAME)))
		{
			isim = '#trim(EMPLOYEE_NAME)#/#trim(JOIN_ACCOUNT_NAME)#';
		}
		else
		{
			isim = '#trim(EMPLOYEE_NAME)#';	
		}
		if(len(trim(JOIN_ACCOUNT_SURNAME)) and trim(EMPLOYEE_SURNAME) neq trim(JOIN_ACCOUNT_SURNAME))
		{
			soyisim = '#trim(EMPLOYEE_SURNAME)#/#trim(JOIN_ACCOUNT_SURNAME)#';
		}
		else
		{
			soyisim = '#trim(EMPLOYEE_SURNAME)#';
		}
		aciklama = '#trim(left(attributes.detail,13))#';
		kisi_ucret = '#tlformat(net_ucret)#';
	</cfscript>
	
	<cfset row = newSheet.createRow(satir_)/>
	<cfset cell = row.createCell(0)/>
	<cfset cell.setCellValue("#kisi_sube_kodu#")/>
	<cfset cell = row.createCell(1)/>
	<cfset cell.setCellValue("C")/>
	<cfset cell = row.createCell(2)/>
	<cfset cell.setCellValue("#hesap_no#")/>
	<cfset cell = row.createCell(3)/>
	<cfset cell.setCellValue("MY")/>
	<cfset cell = row.createCell(4)/>
	<cfset cell.setCellValue("1")/>
	<cfset cell = row.createCell(5)/>
	<cfset cell.setCellValue("#isim#")/>
	<cfset cell = row.createCell(6)/>
	<cfset cell.setCellValue("#soyisim#")/>
	<cfset cell = row.createCell(7)/>
	<cfset cell.setCellValue("#kisi_ucret#")/>
	<cfset cell = row.createCell(8)/>
	<cfset cell.setCellValue("#kisi_iban_no#")/>
	<cfset satir_ = satir_ + 1>
</cfoutput>
<cfset fileOutStream = createObject("java","java.io.FileOutputStream").init("#upload_folder#hr#dir_seperator#eislem#dir_seperator##file_name#")/>
<cfset workBook.write(fileOutStream)/>
<cfset fileOutStream.close()/>
