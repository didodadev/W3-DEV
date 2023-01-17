<cfscript>
CRLF = Chr(13) & Chr(10);
dosya = ArrayNew(1);

//888:YTL, 001:USD, 036:EUR


firma_kodu = "#get_comp.RELATION_NUMBER#";
sube_kodu = "#get_comp.bank_branch_code#";
firma_hesap_no = "#get_comp.IBAN_NO#";
sirket_ad = "#get_comp.nick_name#";
doviz_kodu = "888";

if(len(firma_kodu) lt 7)
	firma_kodu = repeatString("0",7-len(firma_kodu)) & "#firma_kodu#";
if(len(firma_kodu) gt 7)
	firma_kodu = "#left(firma_kodu,7)#";
	
if(len(firma_hesap_no) lt 26)
	firma_hesap_no = repeatString("0",26-len(firma_hesap_no)) & "#firma_hesap_no#";
if(len(firma_hesap_no) gt 26)
	firma_hesap_no = "#left(firma_hesap_no,26)#";
	
if(len(sube_kodu) lt 4)
	sube_kodu = repeatString("0",4-len(sube_kodu)) & "#sube_kodu#";
if(len(sube_kodu) gt 4)
	sube_kodu = "#left(sube_kodu,4)#";
	
if(len(sirket_ad) lt 8)
	sirket_ad = "#sirket_ad#" & repeatString("_",8-len(sirket_ad));
if(len(sirket_ad) gt 8)
	sirket_ad = "#left(sirket_ad,8)#";
	
odeme_zamani = "#dateformat(attributes.pay_date,'YYMMDD')#";

if(attributes.payment_type eq 1)
	odeme_turu = "00";
else if(attributes.payment_type eq 2)
	odeme_turu = "05";
else if(attributes.payment_type eq 3)
	odeme_turu = "00";
else if(attributes.payment_type eq 4)
	odeme_turu = "00";
	
odeme_ay = "#attributes.pay_mon#";
if(len(odeme_ay) lt 2)
	odeme_ay = repeatString("0",2-len(odeme_ay)) & "#odeme_ay#";
	
odeme_yil = "#attributes.pay_year#";
vk = "           "; // ellemeyin
durum_kodu = " "; // ellemeyin

upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#";
file_name = "MA#dateformat(now(),'MMDD')##timeformat(now(),'HHMMSS')#G#firma_kodu##sube_kodu##sirket_ad#$.txt";
</cfscript>

<cfset hareket_sayisi = get_puantajs.recordcount>

<cfoutput query="get_puantajs">
	<cfset toplam_net_ = toplam_net_ + NET_UCRET>
	<cfset toplam_kayit = toplam_kayit + 1>
</cfoutput>
<cfscript>
	toplam_net_ = wrk_round(toplam_net_,2);
	toplam_ucret_odenecek_ = listfirst(toplam_net_,'.');

	if(listlen(toplam_net_,'.') eq 2)
		toplam_kurus_ = listlast(toplam_net_,'.');
	else
		toplam_kurus_ = '00';

	if(len(toplam_kurus_) eq 1)
		toplam_kurus_ = '#toplam_kurus_#0';
		
	if(len(toplam_ucret_odenecek_) lt 13)
		toplam_ucret_odenecek_ = repeatString("0",13-len(toplam_ucret_odenecek_)) & "#toplam_ucret_odenecek_#";

	if(len(toplam_kayit) lt 5)
		toplam_kayit = repeatString("0",5-len(toplam_kayit)) & "#toplam_kayit#";
		
	if(len(durum_kodu) lt 42)
		durum_kodu = repeatString(" ",42-len(durum_kodu)) & "#durum_kodu#";
	
	satir1 = '#firma_kodu#0#odeme_zamani#0#sube_kodu##doviz_kodu##firma_hesap_no##odeme_turu##odeme_ay##odeme_yil##vk##toplam_ucret_odenecek_##toplam_kurus_##toplam_kayit##durum_kodu#';
	ArrayAppend(dosya,satir1);
</cfscript>

<cfoutput query="get_puantajs">
<cfif len (IBAN_NO)>
	<cfset IBAN_NO_ = IBAN_NO>
<cfelse>
	<cfset IBAN_NO_ = BANK_ACCOUNT_NO>
</cfif>
	<cfscript>
		error_ = 0;
		hesap_no = '#trim(IBAN_NO_)#';
		if(len(hesap_no) lt 26)
			hesap_no = repeatString("0",26-len(hesap_no)) & "#hesap_no#";
		
		if(len(hesap_no) gt 26)
			error_ = 1;		
			
		sube_no = '#BANK_BRANCH_CODE#';
		if(len(sube_no) lt 4)
			sube_no = repeatString("0",4-len(sube_no)) & "#sube_no#";
		if(len(sube_no) gt 4)
			error_ = 1;	

		aciklama_kodu = "  ";
		vk = "#tc_identy_no#"; // ellemeyin
		kisi_durum_kodu = " "; // ellemeyin
		kisi_durum_kodu_aciklama = " "; // ellemeyin
		
		if(len(hareket_sayisi) lt 5)
			hareket_sayisi = repeatString("0",5-len(hareket_sayisi)) & "#hareket_sayisi#";
		
		if(len(kisi_durum_kodu) lt 2)
			kisi_durum_kodu = repeatString(" ",2-len(kisi_durum_kodu)) & "#kisi_durum_kodu#";
			
		if(len(kisi_durum_kodu_aciklama) lt 40)
			kisi_durum_kodu_aciklama = repeatString(" ",40-len(kisi_durum_kodu_aciklama)) & "#kisi_durum_kodu_aciklama#";
		alici_adi_ = "#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#";
			alici_adi_ = left(alici_adi_,20);
		if(len(alici_adi_) lt 20)
			alici_adi_ = "#alici_adi_#" & repeatString(" ",20-len(alici_adi_));
				
		if(error_ eq 0)
			{
				ucret_ = wrk_round(NET_UCRET,2);
				kisi_ucret = listgetat(ucret_,1,'.');
				if(listlen(ucret_,'.') eq 2)	
					kisi_kurus = listgetat(ucret_,2,'.');
				else
					kisi_kurus = '00';
				
				if(len(kisi_ucret) lt 13)
					kisi_ucret = repeatString("0",13-len(kisi_ucret)) & "#kisi_ucret#";
					

				if(len(kisi_kurus) lt 2)
					kisi_kurus = "#kisi_kurus#" & repeatString("0",2-len(kisi_kurus));
			}
	
		if(error_ eq 0)
			{
			satir1 = '#firma_kodu#1#odeme_zamani#0#sube_no##doviz_kodu##hesap_no##aciklama_kodu##odeme_ay##odeme_yil##vk##kisi_ucret##kisi_kurus#00000#kisi_durum_kodu##kisi_durum_kodu_aciklama##alici_adi_#';
			ArrayAppend(dosya,satir1);
			}
	</cfscript>
</cfoutput>
<cffile action="write" output="#ArrayToList(dosya,CRLF)#" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
