<cfscript>
CRLF = Chr(13) & Chr(10);
dosya = ArrayNew(1);

upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#";
file_name = "#attributes.pay_year#_#attributes.pay_mon#_#listlast(attributes.bank_id,';')#_#dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHMMSS')#.txt";
firma_kodu = "#get_comp.RELATION_NUMBER#";
	if(len(firma_kodu) lt 10)
		firma_kodu = "#firma_kodu#" & repeatString(" ",10-len(firma_kodu));
	if(len(firma_kodu) gt 10)
		firma_kodu = "#left(firma_kodu,10)#";
odeme_zamani = "#dateformat(attributes.pay_date,'DDMMYYYY')#";
if(attributes.payment_type eq 1)
	odeme_turu = "M";
else if(attributes.payment_type eq 2)
	odeme_turu = "A";
else if(attributes.payment_type eq 3)
	odeme_turu = "P";
else if(attributes.payment_type eq 4)
	odeme_turu = "M";
doviz = "#session.ep.money#";


satir1 = '#firma_kodu##odeme_zamani##odeme_turu##doviz#';
ArrayAppend(dosya,satir1);
</cfscript>
<cfoutput query="get_puantajs">
	<cfscript>
		hesap_no = '#BANK_ACCOUNT_NO#';
			if(len(hesap_no) lt 8)
				hesap_no = repeatString("0",8-len(hesap_no)) & "#hesap_no#";
		
		isim = '#trim(left(EMPLOYEE_NAME,12))#';
			if(len(isim) lt 12)
				isim = "#isim#" & repeatString(" ",12-len(isim));
				
		soyisim = '#trim(left(EMPLOYEE_SURNAME,13))#';
			if(len(soyisim) lt 13)
				soyisim = "#soyisim#" & repeatString(" ",13-len(soyisim));
				
		sicil_no = '#left(attributes.detail,9)#';
			if(len(sicil_no) lt 9)
				sicil_no = repeatString(" ",9-len(sicil_no)) & "#sicil_no#";
				
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
					if (len(kisi_kurus) eq 1)
						kisi_kurus = '#kisi_kurus#0';
					else if (len(kisi_kurus) eq 4)
					{
						kisi_kurus = kisi_kurus / 100;
						kisi_kurus = listgetat(kisi_kurus,1,'.');	
					}
				}
			}
		toplam_net_ = toplam_net_ + NET_UCRET;
		toplam_kayit = toplam_kayit + 1;
		satir1 = '#hesap_no##isim##soyisim##sicil_no##kisi_ucret#.#kisi_kurus#';
		ArrayAppend(dosya,satir1);
	</cfscript>	
</cfoutput>
<cffile action="write" output="#ArrayToList(dosya,CRLF)#" addnewline="yes" file="#upload_folder##file_name#" charset="ISO-8859-9">
