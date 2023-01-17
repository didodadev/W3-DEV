<!---
    File: netbook_digital_planet.cfm
    Folder: V16\e_government\query
    Author: Fatih Ayık
    Date:
    Description:
        Digital Planet e-defter web servis
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
    To Do:

--->

<cfset file_name = "#get_our_company.tax_no#_#dateformat(attributes.start_date,'ddmmyyyy')#_#dateformat(attributes.finish_date,'ddmmyyyy')#_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHmmss')#.xml">

<cfif not (Day(attributes.start_date) eq 1 and Day(attributes.finish_date) eq DaysInMonth(attributes.finish_date))>
	<cfset attributes.partial_book = 1> <!--- Kısmi defter mi değil mi onu kontrol ediyoruz --->
</cfif>
<cfset setLocale("tr_TR")>
<cfset ilk = getTickCount()>
<cfsavecontent variable="firstData">
<cfoutput><?xml version="1.0" encoding="UTF-8"?>
<Edefter xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <MuhasebeKayitlari>
        <DokumanBilgisi>
            <DonemBaslangicTarihi>#dateformat(attributes.start_date,'yyyy-mm-dd')#</DonemBaslangicTarihi>
            <DonemBitisTarihi>#dateformat(attributes.finish_date,'yyyy-mm-dd')#</DonemBitisTarihi>
        </DokumanBilgisi>
        <FirmaBilgisi>
            <Aktif>true</Aktif>
            <VKN>#get_our_company.tax_no#</VKN>
            <FirmaTelNo>
                <TelefonNoTanimi>main</TelefonNoTanimi>
                <TelefonNo>#get_our_company.tel_code##get_our_company.tel#</TelefonNo>
            </FirmaTelNo>
            <FirmaFaksNoYapisi>
                <FaksNo>#get_our_company.tel_code##get_our_company.fax#</FaksNo>
            </FirmaFaksNoYapisi>
            <FirmaEmailAdresYapisi>
                <EmailAdres>#get_our_company.email#</EmailAdres>
            </FirmaEmailAdresYapisi>
            <FirmaUnvanBilgisi>
                <Unvan>#get_our_company.company_name#</Unvan>
                <UnvanTanimi>Kurum Unvanı</UnvanTanimi>
            </FirmaUnvanBilgisi>
            <FirmaAdresBilgisi>
                <BinaKapiNo>#get_our_company.BUILDING_NUMBER#</BinaKapiNo>
                <CaddeAdi>#get_our_company.street_name#</CaddeAdi>
                <DigerAdresDetay>#get_our_company.address#</DigerAdresDetay>
                <Sehir>#get_our_company.city#</Sehir>
                <PostaKodu>#get_our_company.postal_code#</PostaKodu>
                <Ulke>#get_our_company.country#</Ulke>
            </FirmaAdresBilgisi>
            <FirmaWebSitesi>
                <WebSiteAdresi>#get_our_company.web#</WebSiteAdresi>
            </FirmaWebSitesi>
            <FirmaNaceKodu>#get_our_company.nace_code#</FirmaNaceKodu>
            <HesapDonemiBaslangici>#session.ep.period_start_date#</HesapDonemiBaslangici>
            <HesapDonemiSonu>#session.ep.period_finish_date#</HesapDonemiSonu>
            <MuhasebeciBilgisi>
                <Aktif>true</Aktif>
                <MuhasebeciAdi>#get_our_company.ACCOUNTANT_NAME#</MuhasebeciAdi>
                <MuhasebeciAdresBilgisi>
                    <MuhasebeciBinaKapiNo></MuhasebeciBinaKapiNo>
                    <MuhasebeciCaddeAdi></MuhasebeciCaddeAdi>
                    <MuhasebeciDigerAdresDetay>#get_our_company.ACCOUNTANT_ADDRESS#</MuhasebeciDigerAdresDetay>
                    <MuhasebeciSehir>#get_our_company.ACCOUNTANT_CITY#</MuhasebeciSehir>
                    <MuhasebeciUlke>#get_our_company.ACCOUNTANT_COUNTRY#</MuhasebeciUlke>
                    <MuhasebeciPostaKodu>#get_our_company.ACCOUNTANT_POSTCODE#</MuhasebeciPostaKodu>
                </MuhasebeciAdresBilgisi>
                <MuhasebeciSozlesmeTipiAciklamasi>Sözleşme No: #get_our_company.CONTRACT_NO# Sözleşem Tarihi : #dateformat(get_our_company.CONTRACT_DATE,'dd/mm/yyyy')#</MuhasebeciSozlesmeTipiAciklamasi>
                <MuhasebeciIrtibatBilgisi>
                    <MuhasebeciTelefonBilgisi>
                        <MuhasebeciTelefonTanimi>bookkeeper</MuhasebeciTelefonTanimi>
                        <MuhasebeciTelefonNo>#get_our_company.ACCOUNTANT_TEL#</MuhasebeciTelefonNo>
                    </MuhasebeciTelefonBilgisi>
                    <MuhasebeciFaksBilgisi>
                        <MuhasebeciFaksNo>#get_our_company.ACCOUNTANT_FAX#</MuhasebeciFaksNo>
                    </MuhasebeciFaksBilgisi>
                    <MuhasebeciEmailBilgisi>
                        <MuhasebeciEmailAdres>#get_our_company.ACCOUNTANT_EMAIL#</MuhasebeciEmailAdres>
                    </MuhasebeciEmailBilgisi>
                </MuhasebeciIrtibatBilgisi>
            </MuhasebeciBilgisi>
        </FirmaBilgisi>
      </cfoutput>
</cfsavecontent>

<cfset runtime = createObject("java","java.lang.Runtime").getRuntime()>
<cfset objSys = createObject("java","java.lang.System")/>
<cfset dosya = expandPath("#file_name#")>
<cfset fileOb = fileOpen(dosya, "append","UTF-8")>
<cfset fileWriteLine(fileOb, firstData)>
<cfset fileClose(fileOb)>

<cfset fileOb = fileOpen(dosya, "append","UTF-8")>
<cfoutput query="getAccountCard" group="CARD_ID">
	<cfset card_detail_ = REReplaceNoCase(getAccountCard.CARD_DETAIL, "<[\/]?[^>]*>", "", "ALL")> 
    <cfset card_detail_ = Replace(card_detail_, chr(24),"","all")>
    <cfset card_detail_ = Replace(card_detail_, chr(9),"","all")>
    <cfset card_detail_ = Replace(card_detail_, chr(2),"","all")>
    <cfset card_detail_ = Replace(card_detail_, chr(13),"","all")>
	<cfset card_detail_ = Replace(card_detail_, chr(4),"","all")>
    <cfset bill_no_ = REReplaceNoCase(getAccountCard.bill_no, "<[\/]?[^>]*>", "", "ALL")> 
    <cfset bill_no_ = Replace(bill_no_, chr(24),"","all")>
	<cfset bill_no_ = Replace(bill_no_, chr(9),"","all")>
	<cfset bill_no_ = Replace(bill_no_, chr(2),"","all")>
    <cfset bill_no_ = Replace(bill_no_, chr(13),"","all")>
	<cfset bill_no_ = Replace(bill_no_, chr(4),"","all")>
    <cfsavecontent variable="midData">
        <MuhasebeKaydi>
            <Girisci>#getAccountCard.record_name#</Girisci>
            <GirisTarihi>#dateformat(getAccountCard.action_date,'yyyy-mm-dd')#</GirisTarihi>
            <MuhasebeFisNo>#getAccountCard.card_type_no#</MuhasebeFisNo>
            <KayitAciklamasi><![CDATA[#card_detail_#]]></KayitAciklamasi>
            <YevmiyeMaddeNo>#bill_no_#</YevmiyeMaddeNo>
            <OpsiyonelAlan1>#getAccountCard.card_id#</OpsiyonelAlan1>
            <cfoutput>
            	<cfset row_detail_ = REReplaceNoCase(getAccountCard.ROW_DETAIL, "<[\/]?[^>]*>", "", "ALL")>
                <cfset row_detail_ = Replace(row_detail_, chr(24),"","all")>
                <cfset row_detail_ = Replace(row_detail_, chr(9),"","all")>
                <cfset row_detail_ = Replace(row_detail_, chr(2),"","all")>
                <cfset row_detail_ = Replace(row_detail_, chr(13),"","all")>
				<cfset row_detail_ = Replace(row_detail_, chr(4),"","all")>
                <KayitDetayi>
                    <SatirYevmiyeMaddeNo>#bill_no_#</SatirYevmiyeMaddeNo>
                    <hesap>
                        <AnaHesapNo><![CDATA[#getAccountCard.ANA_HESAP#]]></AnaHesapNo>
                        <AnaHesapAdi><![CDATA[#getAccountCard.ANA_HESAP_DETAY#]]></AnaHesapAdi>
                        <AltHesap>
                            <cfif len(getAccountCard.ALT_HESAP)>
                                <AltHesapAdi><![CDATA[#getAccountCard.ALT_HESAP_DETAY#]]></AltHesapAdi>
                                <AltHesapNo><![CDATA[#getAccountCard.ALT_HESAP#]]></AltHesapNo>
                            </cfif>
                        </AltHesap>
                    </hesap>
                    <Tutar>#lsnumberFormat(getAccountCard.amount,'__.00')#</Tutar>
                    <BorcAlacakKodu>#getAccountCard.DEBIT_CREDIT_CODE#</BorcAlacakKodu>
                    <YevmiyeTarihi>#dateformat(getAccountCard.action_date,'yyyy-mm-dd')#</YevmiyeTarihi>
                    <BelgeReferansi>#getAccountCard.card_type_no#</BelgeReferansi>
                    <BelgeTipi><![CDATA[#getAccountCard.DOCUMENT_TYPE#]]></BelgeTipi>
                    <cfif listfind("-1,-2,-3",getAccountCard.DOCUMENT_TYPE_ID,',') or len(getAccountCard.DOCUMENT_TYPE_DEFINITION)><!--- cek,senet,fatura ve diger islemlerde belge no ve belge tarihi zorunludur --->
                        <BelgeNo><![CDATA[#getAccountCard.paper_no#]]></BelgeNo>
                        <cfif len(getAccountCard.DUE_DATE)><!--- cek ve senet ise vade tarihi gonderiliyor --->
                            <BelgeTarihi>#dateformat(getAccountCard.due_date,'yyyy-mm-dd')#</BelgeTarihi>
                        <cfelse>
                            <BelgeTarihi>#dateformat(getAccountCard.action_date,'yyyy-mm-dd')#</BelgeTarihi>
                        </cfif>
                    </cfif>
                    <cfif len(getAccountCard.DOCUMENT_TYPE_DEFINITION)>
                        <BelgeTipiTanimi><![CDATA[#getAccountCard.DOCUMENT_TYPE_DEFINITION#]]></BelgeTipiTanimi>
                    </cfif>
                    <cfif len(getAccountCard.PAYMENT_TYPE)><!---len(getAccountRow.DOCUMENT_TYPE) and  belge tipi ve odeme tipi alanı gonderilir --->
                        <OdemeTipi><![CDATA[#getAccountCard.PAYMENT_TYPE#]]></OdemeTipi>
                    </cfif>
                    <SatirAciklamasi><![CDATA[#row_detail_#]]></SatirAciklamasi>
                    <OpsiyonelAlan1>#getAccountCard.CARD_ROW_ID#</OpsiyonelAlan1>
                </KayitDetayi>
            </cfoutput>
        </MuhasebeKaydi>
    </cfsavecontent>
    <cfset fileWriteLine(fileOb, midData)>    
</cfoutput>
<cfset fileClose(fileOb)>

<cfset fileOb = fileOpen(dosya, "append","UTF-8")>
<cfsavecontent variable="lastData">
    <cfoutput>
            </MuhasebeKayitlari>
        </Edefter>
    </cfoutput>
</cfsavecontent>

<cfset fileWriteLine(fileOb, lastData)>
<cfset fileClose(fileOb)>
<cfset objSys.gc() />
<cfset objSys.runFinalization()/>

<!--- dosya ilgili dizine tasınıyor --->
<cfif len(get_our_company.netbook_ftp_server) and len(get_our_company.netbook_ftp_username) and len(get_our_company.netbook_ftp_password)>
	<cfset providerMethods = CreateObject ('java', 'java.security.Security')>
	<cfset jSafeProvider = providerMethods.getProvider('JsafeJCE')>
	<cfset providerMethods.removeProvider('JsafeJCE')>
	<!--- ftp ile cloud ortama dosya atılır --->
    <cfftp
        action="open"
        server="#get_our_company.netbook_ftp_server#"
        port="#get_our_company.netbook_ftp_port#"
        username="#get_our_company.netbook_ftp_username#"
        password="#get_our_company.netbook_ftp_password#"
        connection = "myConnection" 
        stopOnError = "Yes" secure="yes" timeout="60000">
   
    <cfif isdefined('attributes.partial_book')>
		<cfset remoteFilePath = "Kist">
	<cfelse>
		<cfset remoteFilePath = "">
	</cfif>
	
	<cfftp action="putFile" connection = "myConnection" passive="YES" localfile="#download_folder##file_name#" remotefile="#remoteFilePath#/#file_name#">

    
    <!--- olusturulan .part dosya siliniyor --->
    <cffile action="delete" file="#download_folder##file_name#">
    
    <!--- ftp baglantısı kapatilir --->
    <cfftp action = "close" connection = "myConnection" stopOnError = "Yes"> 
<cfelse>
	<cfif isdefined('attributes.partial_book')>
		<cfset defter_path = "#netbook_folder#\#get_our_company.tax_no#\kist\">
	<cfelse>
		<cfset defter_path = "#netbook_folder#\#get_our_company.tax_no#\">
	</cfif>
	<cfset FileMove("#download_folder##file_name#","#defter_path##file_name#")>
</cfif>

<cfset son = getTickCount() - ilk>
Toplam Süre: <cfoutput>#son#</cfoutput> ms