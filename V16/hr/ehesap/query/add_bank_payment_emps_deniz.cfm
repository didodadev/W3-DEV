<cfscript>
CRLF = Chr(13) & Chr(10);
dosya = ArrayNew(1);


sube_kodu = "";
musteri_no = "";
musteri_hesap_ek_no = "";
musteri_iban_no = "#get_comp.iban_no#";
musteri_bank_code = "0134";
dosya_tarihi = "#dateformat(now(),'yyyymmdd')#";
odeme_tarihi = "#dateformat(now(),'yyyymmdd')#";
kayit_tipi = "H";

if(len(sube_kodu) lt 4)
	sube_kodu = repeatString(" ",4-len(sube_kodu)) & "#sube_kodu#";
	
if(len(musteri_no) lt 8)
	musteri_no = repeatString(" ",8-len(musteri_no)) & "#musteri_no#";
	
if(len(musteri_hesap_ek_no) lt 5)
	musteri_hesap_ek_no = repeatString(" ",5-len(musteri_hesap_ek_no)) & "#musteri_hesap_ek_no#";
	
if(len(musteri_iban_no) lt 26)
	musteri_iban_no = repeatString("0",26-len(musteri_iban_no)) & "#musteri_iban_no#";

satir_baslik = '#kayit_tipi##dosya_tarihi##musteri_bank_code##sube_kodu##musteri_no##musteri_hesap_ek_no##odeme_tarihi##musteri_iban_no#';
ArrayAppend(dosya,satir_baslik);
	
upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#";
file_name = "DMA#dateformat(now(),'MMDD')##timeformat(now(),'HHMMSS')##sube_kodu#.txt";
</cfscript>

<cfoutput query="get_puantajs">
	<cfscript>
		error_ = 0;

		kayit_tipi_kisi = "D";
		kisi_iban_no_ = "#left(iban_no,26)#";
	
		if(len(kisi_iban_no_) neq 26)
			error_ = 1;
			
		if(error_ eq 0)
		{
			hedef_banka_ = '#mid(kisi_iban_no_,1,4)#';
			hedef_sube_ = '#mid(kisi_iban_no_,5,5)#';
			hedef_hesap_ = '#mid(kisi_iban_no_,10,26)#';
			para_kodu_ = 'TRY';
			
			if(len(hedef_hesap_) lt 18)
				hedef_hesap_ = "#hedef_hesap_#" & repeatString(" ",18-len(hedef_hesap_));
		
			isim = '#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#';
			if(len(isim) lt 50)
				isim = "#isim#" & repeatString(" ",50-len(isim));
			else if(len(isim) gt 50)
				isim = "#left(isim,50)#";
				
			aciklama = '#attributes.detail#';
			if(len(aciklama) lt 60)
				aciklama = "#aciklama#" & repeatString(" ",60-len(aciklama));
			else if(len(aciklama) gt 60)
				aciklama = "#left(aciklama,60)#";
		}
		
		if(error_ eq 0)
		{
			toplam_net_ = toplam_net_ + NET_UCRET;
			kisi_ucret_ilk = listgetat(NET_UCRET,1,'.');
			if(len(kisi_ucret_ilk) lt 15)
				kisi_ucret = repeatString("0",15-len(kisi_ucret_ilk)) & "#kisi_ucret_ilk#";
			
			if(listlen(NET_UCRET,'.') eq 2)
				kisi_kurus = left(listlast(NET_UCRET,'.'),2);
			else
				kisi_kurus = '00';
				
			if(len(kisi_kurus) lt 2)
				kisi_kurus = "#kisi_kurus#" & repeatString("0",2-len(kisi_kurus));
			
			toplam_kayit = toplam_kayit + 1;
		}
			
		firma_referans_ = "EXC" & repeatString(" ",27);
		alici_vergi_no_ = "          ";
		alici_tc_kimlik_no_ = "#tc_identy_no#";
		durum_kodu_ = "00";
		islem_referans = "0000000000";
	
		if(error_ eq 0)
			{
			satir1 = '#kayit_tipi_kisi##hedef_banka_##hedef_sube_##hedef_hesap_##kisi_ucret#.#kisi_kurus##para_kodu_##aciklama##isim##firma_referans_##alici_vergi_no_##alici_tc_kimlik_no_##durum_kodu_##islem_referans#';
			ArrayAppend(dosya,satir1);
			}
	</cfscript>
</cfoutput>
<cfscript>
	bitis_kodu_ = "T";
	if(len(toplam_kayit) lt 5)
		toplam_kayit = repeatString("0",5-len(toplam_kayit)) & "#toplam_kayit#";
		
	toplam_ucret_ilk = listgetat(toplam_net_,1,'.');
		if(len(toplam_ucret_ilk) lt 15)
			toplam_ucret = repeatString("0",15-len(toplam_ucret_ilk)) & "#toplam_ucret_ilk#";
		
		if(listlen(toplam_net_,'.') eq 2)
			toplam_kurus = left(listlast(toplam_net_,'.'),2);
		else
			toplam_kurus = '00';
			
		if(len(toplam_kurus) lt 2)
			toplam_kurus = "#toplam_kurus#" & repeatString("0",2-len(toplam_kurus));

	satir_toplam = '#bitis_kodu_##toplam_kayit##toplam_ucret#.#toplam_kurus#';
	ArrayAppend(dosya,satir_toplam);
</cfscript>
<cffile action="write" output="#ArrayToList(dosya,CRLF)#" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
