<!--- 20130726 SG hsbc dosyası yeniden duzenlendi--->
<cfscript>
	CRLF = Chr(13) & Chr(10);
	dosya = ArrayNew(1);
	
	firma_kodu = "#get_comp.RELATION_NUMBER#";
	
	if(len(firma_kodu) lt 15)
		firma_kodu = repeatString("0",15-len(firma_kodu)) & "#firma_kodu#";
	if(len(firma_kodu) gt 15)
		firma_kodu = "#left(firma_kodu,15)#";
		
	odeme_zamani = "#dateformat(attributes.pay_date,'DDMMYYYY')#";
	
	if(attributes.payment_type eq 1)
		odeme_turu = "00";
	else if(attributes.payment_type eq 2)
		odeme_turu = "00";
	else if(attributes.payment_type eq 3)
		odeme_turu = "05";
	else if(attributes.payment_type eq 4)
		odeme_turu = "00";
		
	upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#";
	file_name = "HSBC_MA#dateformat(now(),'MMDD')##timeformat(now(),'HHMMSS')#G#firma_kodu#.txt";
</cfscript>

<cfset toplam_kayit = get_puantajs.recordcount>
<cfoutput query="get_puantajs">
	<cfset toplam_net_ = toplam_net_ + NET_UCRET>
</cfoutput>
<cfoutput query="get_puantajs">
	<cfscript>
		error_ = 0;
		
		tckn = '#TC_IDENTY_NO#';
		if(len(tckn) lt 11 or len(tckn) gt 11)
			error_ = 1;

		sube_no = '#get_comp.BANK_BRANCH_CODE#';
		if(len(sube_no) lt 3)
			sube_no = repeatString("0",3-len(sube_no)) & "#sube_no#";
		if(len(sube_no) gt 3)
			error_ = 1;	
		
		hesap_no = '#get_comp.BANK_ACCOUNT_CODE#';
		if(len(hesap_no) lt 12)
			hesap_no = repeatString("0",12-len(hesap_no)) & "#hesap_no#";
		
		if(len(hesap_no) gt 12)
			error_ = 1;	

		karsi_sube_no = '#BANK_BRANCH_CODE#';
		if(len(karsi_sube_no) lt 3)
			karsi_sube_no = repeatString("0",3-len(karsi_sube_no)) & "#karsi_sube_no#";
		if(len(karsi_sube_no) gt 3)
			error_ = 1;	
			
		karsi_hesap_no = '#BANK_ACCOUNT_NO#';
		if(len(karsi_hesap_no) lt 12)
			karsi_hesap_no = repeatString("0",12-len(karsi_hesap_no)) & "#karsi_hesap_no#";
		
		if(len(karsi_hesap_no) gt 12)
			error_ = 1;	
		
		alici_adi_ = "#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#";
			alici_adi_ = left(alici_adi_,35);
		if(len(alici_adi_) lt 35)
			alici_adi_ = "#alici_adi_#" & repeatString(" ",35-len(alici_adi_));

		aciklama_ = left(attributes.detail,30);
		if(len(aciklama_) lt 30)
			aciklama_ = "#aciklama_#" & repeatString(" ",30-len(aciklama_));
			
				
		if(error_ eq 0)
			{
				ucret_ = wrk_round(NET_UCRET,2);
				kisi_ucret = listgetat(ucret_,1,'.');
				if(listlen(ucret_,'.') eq 2)	
					kisi_kurus = listgetat(ucret_,2,'.');
				else
					kisi_kurus = '00';
				
				if(len(kisi_ucret) lt 12)
					kisi_ucret = repeatString("0",12-len(kisi_ucret)) & "#kisi_ucret#";
					

				if(len(kisi_kurus) lt 2)
					kisi_kurus = "#kisi_kurus#" & repeatString("0",2-len(kisi_kurus));
			}
	
		if(error_ eq 0)
			{
			satir1 = '#sube_no##hesap_no##karsi_sube_no##karsi_hesap_no##odeme_zamani##alici_adi_##kisi_ucret#,#kisi_kurus##aciklama_##tckn#';
			ArrayAppend(dosya,satir1);
			}
	</cfscript>
</cfoutput>
<cffile action="write" output="#ArrayToList(dosya,CRLF)#" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
