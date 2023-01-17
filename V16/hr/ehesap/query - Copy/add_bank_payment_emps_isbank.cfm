<cfscript>
CRLF = Chr(13) & Chr(10);
dosya = ArrayNew(1);

sabit_deger = "106";

sube_kodu = "#get_comp.bank_branch_code#";
firma_kodu = "#get_comp.RELATION_NUMBER#";
firma_hesap_no = "#get_comp.bank_account_code#";
sirket_ad = "#get_comp.nick_name#";


if(len(sube_kodu) lt 4)
	sube_kodu = repeatString("0",4-len(sube_kodu)) & "#sube_kodu#";
if(len(sube_kodu) gt 4)
	sube_kodu = "#left(sube_kodu,4)#";

if(len(firma_kodu) lt 12)
	firma_kodu = repeatString("0",12-len(firma_kodu)) & "#firma_kodu#";
if(len(firma_kodu) gt 12)
	firma_kodu = "#left(firma_kodu,12)#";
	
if(len(firma_hesap_no) lt 8)
	firma_hesap_no = repeatString("0",8-len(firma_hesap_no)) & "#firma_hesap_no#";
if(len(firma_hesap_no) gt 8)
	firma_hesap_no = "#left(firma_hesap_no,8)#";
	
if(len(sirket_ad) lt 25)
	sirket_ad = "#sirket_ad#" & repeatString(" ",25-len(sirket_ad));
if(len(sirket_ad) gt 25)
	sirket_ad = "#left(sirket_ad,25)#";
	
odeme_zamani = "#dateformat(attributes.pay_date,'YYYYMMDD')#";
para_birimi = "TRY";
aciklama_tipi = "F"; // aciklama tipi F olursa bizim bi onceki ekrandan girdigimiz aciklama cikar


if(attributes.payment_type eq 1)
	odeme_turu = "1";
else if(attributes.payment_type eq 2)
	odeme_turu = "1";
else if(attributes.payment_type eq 3)
	odeme_turu = "1";
else if(attributes.payment_type eq 4)
	odeme_turu = "1";

upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#";
file_name = "MA#dateformat(now(),'MMDD')##timeformat(now(),'HHMMSS')#G#firma_kodu##sube_kodu#.txt";
iban_no = "#get_comp.iban_no#";

satir1 = '#sabit_deger##sube_kodu##firma_kodu##sirket_ad##para_birimi##aciklama_tipi##iban_no#';
ArrayAppend(dosya,satir1);
</cfscript>

<cfoutput query="get_puantajs">
	<cfscript>
		error_ = 0;
		
		sube_no = '#BANK_BRANCH_CODE#';
		if(len(sube_no) lt 4)
			sube_no = repeatString(" ",4-len(sube_no)) & "#sube_no#";
		if(len(sube_no) gt 4)
			error_ = 1;	
			
		
		hesap_no = '#BANK_ACCOUNT_NO#';
		if(len(hesap_no) lt 7)
			hesap_no = repeatString("0",7-len(hesap_no)) & "#hesap_no#";
		
		if(len(hesap_no) gt 7)
			error_ = 1;		
			
		isim = '#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#';
			if(len(isim) lt 25)
				isim = "#isim#" & repeatString(" ",25-len(isim));
			else if(len(isim) gt 25)
				isim = "#left(isim,25)#";
				
		sicil_no = '#attributes.detail#';
			if(len(sicil_no) lt 70)
				sicil_no = "#sicil_no#" & repeatString(" ",70-len(sicil_no));
			else if(len(sicil_no) gt 70)
				sicil_no = "#left(sicil_no,70)#";
		
		if(error_ eq 0)
			{
				toplam_net_ = toplam_net_ + NET_UCRET;
				kisi_ucret = listgetat(NET_UCRET,1,'.');
					if(len(kisi_ucret) lt 12)
					{
						kisi_ucret = repeatString("0",12-len(kisi_ucret)) & "#kisi_ucret#";
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
			satir1 = '2H#sube_no##hesap_no# #kisi_ucret#,#kisi_kurus##isim##sicil_no#  #iban_no#'; // en bastaki 2 bu tip icin sabit deger -- H ise hesap no uzerinden islem yap demektir
			ArrayAppend(dosya,satir1);
			}
	</cfscript>
</cfoutput>
<cfscript>
	kayit_sayisi = "#toplam_kayit#";
	
	if(len(kayit_sayisi) lt 18)
		kayit_sayisi = repeatString("0",18-len(kayit_sayisi)) & "#kayit_sayisi#";
		
	son_deger_ = listgetat(toplam_net_,1,'.');
		
			if(len(son_deger_) lt 12)
			{
				son_deger_ = repeatString("0",12-len(son_deger_)) & "#son_deger_#";
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
		satir1 = '3#kayit_sayisi##son_deger_#.#kisi_kurus#'; // en bastaki 3 bu dosya tipi icin sabit degerdir. 
		ArrayAppend(dosya,satir1);		
</cfscript>
<cffile action="write" output="#ArrayToList(dosya,CRLF)#" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
