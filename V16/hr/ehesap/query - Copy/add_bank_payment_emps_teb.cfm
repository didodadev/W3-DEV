<cfscript>
CRLF = Chr(13) & Chr(10);
dosya = ArrayNew(1);

firma_kodu = "#get_comp.RELATION_NUMBER#";
sube_kodu = "#get_comp.bank_branch_code#";
firma_hesap_no = "#get_comp.bank_account_code#";
sirket_ad = "#get_comp.nick_name#";

if(len(firma_kodu) lt 8)
	firma_kodu = repeatString("0",8-len(firma_kodu)) & "#firma_kodu#";
if(len(firma_kodu) gt 8)
	firma_kodu = "#left(firma_kodu,8)#";
	
if(len(firma_hesap_no) lt 8)
	firma_hesap_no = repeatString("0",8-len(firma_hesap_no)) & "#firma_hesap_no#";
if(len(firma_hesap_no) gt 8)
	firma_hesap_no = "#left(firma_hesap_no,8)#";
	
if(len(sube_kodu) lt 4)
	sube_kodu = repeatString("0",4-len(sube_kodu)) & "#sube_kodu#";
if(len(sube_kodu) gt 4)
	sube_kodu = "#left(sube_kodu,4)#";
	
if(len(sirket_ad) lt 8)
	sirket_ad = "#sirket_ad#" & repeatString("_",8-len(sirket_ad));
if(len(sirket_ad) gt 8)
	sirket_ad = "#left(sirket_ad,8)#";
	
odeme_zamani = "#dateformat(attributes.pay_date,'YYYYMMDD')#";


if(attributes.payment_type eq 1)
	odeme_turu = "1";
else if(attributes.payment_type eq 2)
	odeme_turu = "1";
else if(attributes.payment_type eq 3)
	odeme_turu = "1";
else if(attributes.payment_type eq 4)
	odeme_turu = "1";

upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#";
file_name = "MA#dateformat(now(),'MMDD')##timeformat(now(),'HHMMSS')#G#firma_kodu##sube_kodu##sirket_ad#$.txt";


satir1 = 'H#odeme_turu##dateformat(now(),'YYYYMMDD')#00320#sube_kodu##firma_kodu##firma_hesap_no##odeme_zamani#1200';
ArrayAppend(dosya,satir1);
</cfscript>

<cfoutput query="get_puantajs">
	<cfscript>
		error_ = 0;
		hesap_no = '#BANK_ACCOUNT_NO#';
		if(len(hesap_no) lt 8)
			hesap_no = repeatString("0",8-len(hesap_no)) & "#hesap_no#";
		else
			hesap_no = Left(hesap_no, 8);

		if(len(hesap_no) gt 8)
			error_ = 1;		
			
		sube_no = '#BANK_BRANCH_CODE#';
		if(len(sube_no) lt 5)
			sube_no = repeatString("0",5-len(sube_no)) & "#sube_no#";
		else
			sube_no = Left(sube_no, 5);

		if(len(sube_no) gt 5)
			error_ = 1;	
		
		isim = '#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#';
		if(len(isim) lt 60)
			isim = "#isim#" & repeatString(" ",60-len(isim));
		else
			isim = Left(isim, 60);
				
		sicil_no = '#attributes.detail#';
		if(len(sicil_no) lt 60)
			sicil_no = "#sicil_no#" & repeatString(" ",60-len(sicil_no));
		else
			sicil_no = Left(sicil_no, 60);
		
		f_referans = '';
		if(len(f_referans) lt 20)
			f_referans = "#f_referans#" & repeatString(" ",20-len(f_referans));
		else
			f_referans = Left(f_referans, 20);
				
		iban = repeatString("0",26);
				
		if(error_ eq 0)
			{
				toplam_net_ = toplam_net_ + NET_UCRET;
				kisi_ucret = listgetat(NET_UCRET,1,'.');
					if(len(kisi_ucret) lt 17)
					{
						kisi_ucret = repeatString("0",17-len(kisi_ucret)) & "#kisi_ucret#";
						ucret_len = listlen(NET_UCRET,'.');
						if (ucret_len eq 1)
							kisi_kurus = '00';
						else
						{
							kisi_kurus = listgetat(NET_UCRET,2,'.');
								if(len(kisi_kurus) eq 1)
									kisi_kurus = '#kisi_kurus#0';
								else if (len(kisi_kurus) eq 4)
								{
									kisi_kurus = kisi_kurus / 100;
									kisi_kurus = listgetat(kisi_kurus,1,'.');	
								}
						}
					}
				toplam_kayit = toplam_kayit + 1;
			}
	
		if(error_ eq 0)
			{
			satir1 = 'D0032#sube_no##hesap_no##session.ep.money# #kisi_ucret#.#kisi_kurus##sicil_no##f_referans##isim#';
			ArrayAppend(dosya,satir1);
			}
	</cfscript>
</cfoutput>

<cfscript>
	kayit_sayisi = "#toplam_kayit#";
	
	if(len(kayit_sayisi) lt 12)
		kayit_sayisi = repeatString("0",12-len(kayit_sayisi)) & "#kayit_sayisi#";
		
	son_deger_ = listgetat(toplam_net_,1,'.');
		
			if(len(son_deger_) lt 17)
			{
				son_deger_ = repeatString("0",17-len(son_deger_)) & "#son_deger_#";
				ucret_len = listlen(toplam_net_,'.');
				if(ucret_len eq 1)
					kisi_kurus = '00';
				else
				{
					kisi_kurus = listgetat(toplam_net_,2,'.');
					if(len(kisi_kurus) eq 1)
						kisi_kurus = '#kisi_kurus#0';
					else if (len(kisi_kurus) eq 4)
					{
						kisi_kurus = kisi_kurus / 100;
						kisi_kurus = listgetat(kisi_kurus,1,'.');	
					}
				}
			}
		satir1 = 'T#kayit_sayisi##son_deger_#.#kisi_kurus#';
		ArrayAppend(dosya,satir1);		
</cfscript>
<cffile action="write" output="#ArrayToList(dosya,CRLF)#" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
