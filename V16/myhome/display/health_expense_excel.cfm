<cfif isDefined("attributes.create_excel") and attributes.create_excel eq 1>

    <cfset file_name = "#dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHMMSS')#.xls">
    <cfset workBook = createObject("java","org.apache.poi.hssf.usermodel.HSSFWorkbook").init()/>
    <cfset newSheet = workBook.createSheet()/>
    <cfset workBook.setSheetName(0, "VB Sağlık Harcama Dosyası")/>

    <cfif isDefined("attributes.excel_type_id") and attributes.excel_type_id eq 1>
        <cftry>

            <cfset row = newSheet.createRow(1)/>
            <cfset cell = row.createCell(0)/>
            <cfset cell.setCellValue("Belge No")/>
            <cfset cell = row.createCell(1)/>
            <cfset cell.setCellValue("Çalışan No")/>
            <cfset cell = row.createCell(2)/>
            <cfset cell.setCellValue("Ad Soyad")/>
            <cfset cell = row.createCell(3)/>
            <cfset cell.setCellValue("Tutar")/>

            <cfset satir_ = 1>
            <cfoutput query="GET_EXPENSE">
                <cfif TREATED eq 1>
                    <cfset satir_ = satir_ + 1>
                    <cfscript>
                        belge_no = '#paper_no#';
                        sicil = '#EMPLOYEE_NO#';	
                        ad_soyad = '#trim(EMP_FULLNAME)#';
                        kisi_ucret = '#tlformat(OUR_COMPANY_HEALTH_AMOUNT)#';
                    </cfscript>
                    
                    <cfset row = newSheet.createRow(satir_)/>
                    <cfset cell = row.createCell(0)/>
                    <cfset cell.setCellValue("#belge_no#")/>
                    <cfset cell = row.createCell(1)/>
                    <cfset cell.setCellValue("#sicil#")/>
                    <cfset cell = row.createCell(2)/>
                    <cfset cell.setCellValue("#ad_soyad#")/>
                    <cfset cell = row.createCell(3)/>
                    <cfset cell.setCellValue("#kisi_ucret#")/>
                </cfif>
            </cfoutput>
            <cfset fileOutStream = createObject("java","java.io.FileOutputStream").init("#download_folder#documents#dir_seperator#hr#dir_seperator#eislem#dir_seperator##file_name#")/>
            <cfset workBook.write(fileOutStream)/>
            <cfset fileOutStream.close()/>
            <cfheader name="Content-Disposition" value="attachment;filename=#file_name#">
            <cfcontent file="#download_folder#documents#dir_seperator#hr#dir_seperator#eislem#dir_seperator##file_name#" type="application/octet-stream" deletefile="no"> 
            <cfcatch>
                <script type="text/javascript">
                    alert("Excel Oluşturulurken Bir Hata Oluştu!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
    <cfelseif isDefined("attributes.excel_type_id") and attributes.excel_type_id eq 2>
        <cfif isDefined("attributes.sort_type") and attributes.sort_type eq 1>
            <cfquery name="GET_EXPENSES_WITH_SORT_TYPE" dbtype="query">
                SELECT
                    EMPLOYEE_NO AS MEMBER_ID,
                    SUM(OUR_COMPANY_HEALTH_AMOUNT) AS OUR_COMPANY_HEALTH_AMOUNT
                FROM
                    GET_EXPENSE
                GROUP BY
                    EMPLOYEE_NO
            </cfquery>
        <cfelseif isDefined("attributes.sort_type") and attributes.sort_type eq 2>
            <cfquery name="GET_EXPENSES_WITH_SORT_TYPE" dbtype="query">
                SELECT
                    MEMBER_CODE AS MEMBER_ID,
                    SUM(OUR_COMPANY_HEALTH_AMOUNT) AS OUR_COMPANY_HEALTH_AMOUNT
                FROM
                    GET_EXPENSE
                WHERE
                    MEMBER_TYPE = 'partner'
                GROUP BY
                    MEMBER_CODE
                UNION ALL
                SELECT
                    CNS_MEMBER_CODE AS MEMBER_ID,
                    SUM(OUR_COMPANY_HEALTH_AMOUNT) AS OUR_COMPANY_HEALTH_AMOUNT
                FROM
                    GET_EXPENSE
                WHERE
                    MEMBER_TYPE = 'consumer'
                GROUP BY
                    CNS_MEMBER_CODE
                UNION ALL
                SELECT
                    PARTNER_MEMBER_CODE AS MEMBER_ID,
                    SUM(OUR_COMPANY_HEALTH_AMOUNT) AS OUR_COMPANY_HEALTH_AMOUNT
                FROM
                    GET_EXPENSE
                WHERE
                    MEMBER_TYPE = 'employee'
                GROUP BY
                    PARTNER_MEMBER_CODE
            </cfquery>
        </cfif>
        <cftry>
            <cfset row = newSheet.createRow(0)/>
            <cfset cell = row.createCell(0)/>
            <cfset cell.setCellValue("1-Üye/Çalışan Kodu/Vergi Numarası")/>
            <cfset cell = row.createCell(1)/>
            <cfset cell.setCellValue("2-Tutar")/>
            <cfset cell = row.createCell(2)/>
            <cfset cell.setCellValue("3-Para Birimi")/>
            <cfset cell = row.createCell(3)/>
            <cfset cell.setCellValue("4-Açıklama")/>
            <cfset cell = row.createCell(4)/>
            <cfset cell.setCellValue("5-Proje ID")/>
            <cfset cell = row.createCell(5)/>
            <cfset cell.setCellValue("6-Fiziki Varlık ID")/>
            <cfset cell = row.createCell(6)/>
            <cfset cell.setCellValue("7-Ödeme Tipi ID")/>
            <cfset cell = row.createCell(7)/>
            <cfset cell.setCellValue("8-Masraf Tutarı")/>
            <cfset cell = row.createCell(8)/>
            <cfset cell.setCellValue("9-Masraf Merkezi ID")/>
            <cfset cell = row.createCell(9)/>
            <cfset cell.setCellValue("10-Gider Kalemi ID")/>
            <cfset cell = row.createCell(10)/>
            <cfset cell.setCellValue("11-Cari Hesap Tipi")/>

            <cfset satir_ = 0>
            <cfoutput query="GET_EXPENSES_WITH_SORT_TYPE">
                <cfset satir_ = satir_ + 1>
                
                <cfset row = newSheet.createRow(satir_)/>
                <cfset cell = row.createCell(0)/>
                <cfset cell.setCellValue("#MEMBER_ID#")/>
                <cfset cell = row.createCell(1)/>
                <cfset cell.setCellValue("#TLFormat(OUR_COMPANY_HEALTH_AMOUNT)#")/>
                <cfset cell = row.createCell(2)/>
                <cfset cell.setCellValue("TL")/>
            </cfoutput>
            <cfset fileOutStream = createObject("java","java.io.FileOutputStream").init("#download_folder#documents#dir_seperator#hr#dir_seperator#eislem#dir_seperator##file_name#")/>
            <cfset workBook.write(fileOutStream)/>
            <cfset fileOutStream.close()/>
            <cfheader name="Content-Disposition" value="attachment;filename=#file_name#">
            <cfcontent file="#download_folder#documents#dir_seperator#hr#dir_seperator#eislem#dir_seperator##file_name#" type="application/octet-stream" deletefile="no"> 
            <cfcatch>
                <script type="text/javascript">
                    alert("Excel Oluşturulurken Bir Hata Oluştu!");
                    history.back();
                </script>
                <cfabort>
            </cfcatch>
        </cftry>
    </cfif>
<cfelse>
    <cfquery name="get_comp" datasource="#dsn#">
        SELECT 
            OBR.RELATION_NUMBER,
            OBR.BANK_BRANCH_CODE
        FROM 
            OUR_COMPANY_BANK_RELATION OBR
        WHERE 
            OBR.OUR_COMPANY_ID = #session.ep.company_id# AND 
            OBR.BANK_ID = #attributes.bank_id# AND 
            OBR.RELATION_NUMBER IS NOT NULL
    </cfquery>
    <cfscript>
        file_name = "#dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHMMSS')#.xls";
        firma_kodu = "#get_comp.RELATION_NUMBER#";
        sube_kodu = "#get_comp.BANK_BRANCH_CODE#";
        odeme_zamani = "#dateformat(now(),'DD.MM.YYYY')#";
        odeme_turu = "N";
        doviz = "#session.ep.money#";
    </cfscript>

    <cfset workBook = createObject("java","org.apache.poi.hssf.usermodel.HSSFWorkbook").init()/>
    <cfset newSheet = workBook.createSheet()/>
    <cfset workBook.setSheetName(0, "VB Sağlık Harcama Dosyası")/>

    <cfquery name="GET_EXPENSES_WITH_GROUP" dbtype="query">
        SELECT 
            EMP_ID,
            BANK_ACCOUNT_NO,
            IBAN_NO,
            TC_IDENTY_NO,
            EMP_FULLNAME,
            SUM(OUR_COMPANY_HEALTH_AMOUNT) AS OUR_COMPANY_HEALTH_AMOUNT
        FROM
            GET_EXPENSE
        GROUP BY
            EMP_ID,
            BANK_ACCOUNT_NO,
            IBAN_NO,
            TC_IDENTY_NO,
            EMP_FULLNAME
    </cfquery>

    <cftry>

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
        <cfset cell.setCellValue("#tlformat(GET_EXPENSE.TOTAL_COMP_HEALTH_AMOUNT)#")/>


        <cfset row = newSheet.createRow(3)/>
        <cfset cell = row.createCell(0)/>
        <cfset cell.setCellValue("")/>
        <cfset cell = row.createCell(1)/>
        <cfset cell.setCellValue("Kurum Kodu")/>
        <cfset cell = row.createCell(2)/>
        <cfset cell.setCellValue("#firma_kodu#")/>
        <cfset cell = row.createCell(3)/>
        <cfset cell.setCellValue("#GET_EXPENSES_WITH_GROUP.recordcount#")/>

        <cfset row = newSheet.createRow(4)/>
        <cfset cell = row.createCell(0)/>
        <cfset cell.setCellValue("")/>
        <cfset cell = row.createCell(1)/>
        <cfset cell.setCellValue("Ay")/>
        <cfset cell = row.createCell(2)/>
        <cfset cell.setCellValue("#month(now())#")/>
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
        <cfoutput query="GET_EXPENSES_WITH_GROUP">
        <cfset satir_ = satir_ + 1>
            <cfscript>
                sicil = '#EMP_ID#';
                hesap_no = '#BANK_ACCOUNT_NO#';
                //kisi_banka_kodu = '#BANK_CODE#';
                kisi_iban_no = '#IBAN_NO#';	
                kisi_kimlik_no = '#TC_IDENTY_NO#';		
                ad_soyad = '#trim(EMP_FULLNAME)#';
                kisi_ucret = '#tlformat(OUR_COMPANY_HEALTH_AMOUNT)#';
            </cfscript>
            
            <cfset row = newSheet.createRow(satir_)/>
            <cfset cell = row.createCell(0)/>
            <cfset cell.setCellValue("#ad_soyad#")/>
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
        <cfheader name="Content-Disposition" value="attachment;filename=#file_name#">
        <cfcontent file="#download_folder#documents#dir_seperator#hr#dir_seperator#eislem#dir_seperator##file_name#" type="application/octet-stream" deletefile="no"> 
        <cfcatch>
            <script type="text/javascript">
                alert("Excel Oluşturulurken Bir Hata Oluştu!");
                history.back();
            </script>
            <cfabort>
        </cfcatch>
    </cftry>
</cfif>