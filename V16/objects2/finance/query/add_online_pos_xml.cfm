<!---
	1-)Akbank,
	2-)Fortis,
	3-İşBank,
	4-)DenizBank,
	5-)Finansbank,
	6-)HSBC,
	7-)Vakıfbank,
	8-)Garanti,
	10-)Halkbank,
	13-)Citibank,
	14-)TEB,
	15-)Ziraat
	16-)ING Bank
	17-)Odea Bank(xml format)
	18-)Şekerbank
--->
<cfif pos_type eq 15>
	<cfxml variable="ziraat">
		<cfoutput>
		<?xml version="1.0" encoding="utf-8"?>
		<PosRequest>
		  <Originator>
			<Acquirer ID="1" />
			<Merchant HostMerchantId="#pos_terminal_no#" Password="#pos_user_password#" />
		  </Originator>
		  <Trnx Type="Sale" ID="#wrk_id#" TrnxIsReversalType="None" />
		  <Payment>
			<PAN PAN="#attributes.card_no#" Expiry="#attributes.exp_year##attributes.expire_month#" CVV2="#attributes.cvv_no#" Brand="Visa" />
			<Amount Amount="#tutar#" Type="1" Code="949" />
			 <cfif taksit_sayisi neq 0>
			  <Options><Item Name="Instalment" Value="#taksit_sayisi#"/></Options>
		  </cfif>
		  </Payment>
		</PosRequest>
		</cfoutput>
	</cfxml>
	<cfscript>
		try
		{
			get_approved_info_ziraat();
            soapResponse = xmlParse(httpResponse.fileContent);
			soapResponse = xmlParse(soapResponse.string.xmltext);
			response_code = soapResponse.PosResponse.Result.Code.xmltext;
			response_detail = soapResponse.PosResponse.Result.ErrorMessage.xmltext;
		}
		catch(any e)
		{
			abort("Sistem Yoğunluğu Nedeniyle İşleminiz Gerçekleştirilemedi! Lütfen Tekrar Deneyiniz!");
		}
	</cfscript>
<cfelse>
	<cfscript>
        if (listfind("1,2,3,4,5,6,10,13,14,15,16,18",pos_type,','))
        {
            my_doc = XmlNew();
            my_doc.xmlRoot = XmlElemNew(my_doc,"CC5Request");
            
            my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"Name");//Kullanici adi-banka tarafindan üye isyerine verilir
            my_doc.xmlRoot.XmlChildren[1].XmlText = pos_user_name;
            my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"Password");//Sifre-banka tarafindan üye isyerine verilir
            my_doc.xmlRoot.XmlChildren[2].XmlText = pos_user_password;
            my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"ClientId");//Magaza numarasi-banka tarafindan üye isyerine verilir
            my_doc.xmlRoot.XmlChildren[3].XmlText = pos_client_id;
            my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"Mode");//Sabit
            my_doc.xmlRoot.XmlChildren[4].XmlText = "P";
            my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"OrderId");//Siparis numarasi
            my_doc.xmlRoot.XmlChildren[5].XmlText = wrk_id;
            my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"Type");//Islem tipi(Provizyon  ve isyeri onayi islemlerini ayni anda yapar)
            my_doc.xmlRoot.XmlChildren[6].XmlText = "Auth";
            my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"Number");//Kredi karti numarasi
            my_doc.xmlRoot.XmlChildren[7].XmlText = attributes.card_no;
            my_doc.xmlRoot.XmlChildren[8] = XmlElemNew(my_doc,"Expires");//Son kullanma tarihi MM/YY
            my_doc.xmlRoot.XmlChildren[8].XmlText = expire_month & "/" & expire_year;
            my_doc.xmlRoot.XmlChildren[9] = XmlElemNew(my_doc,"Cvv2Val");//Güvenlik numarasi CVV No
            my_doc.xmlRoot.XmlChildren[9].XmlText = attributes.cvv_no;
            my_doc.xmlRoot.XmlChildren[10] = XmlElemNew(my_doc,"Total");//Islem yapilacak toplam tutar
            my_doc.xmlRoot.XmlChildren[10].XmlText = tutar;
            if (taksit_sayisi neq 0)
                {
                my_doc.xmlRoot.XmlChildren[11] = XmlElemNew(my_doc,"Taksit");
                my_doc.xmlRoot.XmlChildren[11].XmlText = taksit_sayisi;//Taksit Sayisi
                my_doc.xmlRoot.XmlChildren[12] = XmlElemNew(my_doc,"Currency");//Para birimi - TL
                my_doc.xmlRoot.XmlChildren[12].XmlText = "949";
                my_doc.xmlRoot.XmlChildren[13] = XmlElemNew(my_doc,"UserId");
                my_doc.xmlRoot.XmlChildren[13].XmlText = "";
                my_doc.xmlRoot.XmlChildren[14] = XmlElemNew(my_doc,"email");//Müsterinin e-mail adresi
                my_doc.xmlRoot.XmlChildren[14].XmlText = "";
                my_doc.xmlRoot.XmlChildren[15] = XmlElemNew(my_doc,"BillTo");//Müşteri
                my_doc.xmlRoot.XmlChildren[15].XmlChildren[1] = XmlElemNew(my_doc,"Name");
                my_doc.xmlRoot.XmlChildren[15].XmlChildren[1].XmlText = attributes.firma_info;
                }
            else
                {
                my_doc.xmlRoot.XmlChildren[11] = XmlElemNew(my_doc,"Currency");//Para birimi - TL
                my_doc.xmlRoot.XmlChildren[11].XmlText = "949";
                my_doc.xmlRoot.XmlChildren[12] = XmlElemNew(my_doc,"UserId");
                my_doc.xmlRoot.XmlChildren[12].XmlText = "";
                my_doc.xmlRoot.XmlChildren[13] = XmlElemNew(my_doc,"email");//Müsterinin e-mail adresi
                my_doc.xmlRoot.XmlChildren[13].XmlText = "";
                my_doc.xmlRoot.XmlChildren[14] = XmlElemNew(my_doc,"BillTo");//Müşteri
                my_doc.xmlRoot.XmlChildren[14].XmlChildren[1] = XmlElemNew(my_doc,"Name");
                my_doc.xmlRoot.XmlChildren[14].XmlChildren[1].XmlText = attributes.firma_info;
            }
            try
            {
                get_approved_info();
                xml_response_node = XmlParse(cfhttp.FileContent);
                response_detail = xml_response_node.CC5Response.Response.XmlText;
                response_code = xml_response_node.CC5Response.ProcReturnCode.XmlText;
            }
            catch(any e)
            {
                abort("Sistem Yoğunluğu Nedeniyle İşleminiz Gerçekleştirilemedi! Lütfen Tekrar Deneyiniz!");
            }
        }
         else if (pos_type eq 7)//Vakıfbank
        {
            my_doc = XmlNew();
            my_doc.xmlRoot = XmlElemNew(my_doc,"VposRequest");
            
            my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"MerchantId");//Magaza numarasi-banka tarafindan üye isyerine verilir
            my_doc.xmlRoot.XmlChildren[1].XmlText = pos_client_id;
			
            my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"Password");//Sifre-banka tarafindan üye isyerine verilir
            my_doc.xmlRoot.XmlChildren[2].XmlText = pos_user_password;
			
            my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"TerminalNo");//Magaza numarasi-banka tarafindan üye isyerine verilir
            my_doc.xmlRoot.XmlChildren[3].XmlText = pos_terminal_no;
			
            my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"TransactionType");//Sabit
            my_doc.xmlRoot.XmlChildren[4].XmlText = "Sale";
			
            my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"TransactionId");//Siparis numarasi
            my_doc.xmlRoot.XmlChildren[5].XmlText = wrk_id;
			
            my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"CurrencyAmount");//tutar
            my_doc.xmlRoot.XmlChildren[6].XmlText = tutar;
           
		    my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"CurrencyCode");//tutar kodu
            my_doc.xmlRoot.XmlChildren[7].XmlText = "949";
			
            my_doc.xmlRoot.XmlChildren[8] = XmlElemNew(my_doc,"Pan");//kart numarası
            my_doc.xmlRoot.XmlChildren[8].XmlText = attributes.card_no;
			
            my_doc.xmlRoot.XmlChildren[9] = XmlElemNew(my_doc,"Cvv");//Güvenlik numarasi CVV No
            my_doc.xmlRoot.XmlChildren[9].XmlText = attributes.cvv_no;
			
            my_doc.xmlRoot.XmlChildren[10] = XmlElemNew(my_doc,"Expiry");//son kullanım tarihi
            my_doc.xmlRoot.XmlChildren[10].XmlText = expire_year & expire_month;
			
			my_doc.xmlRoot.XmlChildren[11] = XmlElemNew(my_doc,"OrderId");//IP 
            my_doc.xmlRoot.XmlChildren[11].XmlText = wrk_id;
			
			my_doc.xmlRoot.XmlChildren[12] = XmlElemNew(my_doc,"ClientIp");//IP 
            my_doc.xmlRoot.XmlChildren[12].XmlText = cgi.REMOTE_ADDR;
			
			my_doc.xmlRoot.XmlChildren[13] = XmlElemNew(my_doc,"CardHoldersName");//IP 
            my_doc.xmlRoot.XmlChildren[13].XmlText = attributes.firma_info;
			
			my_doc.xmlRoot.XmlChildren[14] = XmlElemNew(my_doc,"Location");//lokasyon?
            my_doc.xmlRoot.XmlChildren[14].XmlText = 1;
			
	   		my_doc.xmlRoot.XmlChildren[15] = XmlElemNew(my_doc,"TransactionDeviceSource");//son kullanım tarihi
            my_doc.xmlRoot.XmlChildren[15].XmlText = "0";
			
            if (taksit_sayisi neq 0)
                {
                my_doc.xmlRoot.XmlChildren[16] = XmlElemNew(my_doc,"NumberOfInstallments");
                my_doc.xmlRoot.XmlChildren[16].XmlText = taksit_sayisi;//Taksit Sayisi
                }
           try
            {
                get_approved_info_vakif();
                xml_response_node = XmlParse(cfhttp.FileContent);
                response_detail = xml_response_node.VposResponse.ResultDetail.XmlText;
                response_code = xml_response_node.VposResponse.ResultCode.XmlText;
           }
            catch(any e)
            {
                abort("Sistem Yoğunluğu Nedeniyle İşleminiz Gerçekleştirilemedi! Lütfen Tekrar Deneyiniz!");
            }
        }
        else if (pos_type eq 8)//garanti
        {
            if (len(pos_terminal_no) lt 9)
                terminalID_ = repeatString("0",9-len(pos_terminal_no)) & "#pos_terminal_no#";
            else
                terminalID_ = pos_terminal_no;
            
            hashpass = hash("#pos_user_password##terminalID_#",'sha-1');
            hashdata = hash("#wrk_id##pos_terminal_no##attributes.card_no##tutar##hashpass#",'sha-1');
            
            my_doc = XmlNew();
            my_doc.xmlRoot = XmlElemNew(my_doc,"GVPSRequest");
            
            my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"Mode");
            my_doc.xmlRoot.XmlChildren[1].XmlText = "PROD";
            
            my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"Version");
            my_doc.xmlRoot.XmlChildren[2].XmlText = "v0.01";
            
            my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"ChannelCode");
            my_doc.xmlRoot.XmlChildren[3].XmlText = "";
            
            my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"Terminal");
            my_doc.xmlRoot.XmlChildren[4].XmlChildren[1] = XmlElemNew(my_doc,"ProvUserID");//Terminale ait provizyon kullanici kodunun  gönderildigi alandir. Burada Prov kullanicisi, Iptal iade kullanicisi veya OOS  kullanicisi bulunabilir
            my_doc.xmlRoot.XmlChildren[4].XmlChildren[1].XmlText = pos_user_name;
            my_doc.xmlRoot.XmlChildren[4].XmlChildren[2] = XmlElemNew(my_doc,"HashData");
            my_doc.xmlRoot.XmlChildren[4].XmlChildren[2].XmlText = hashdata;//Has Data Gelecek
            my_doc.xmlRoot.XmlChildren[4].XmlChildren[3] = XmlElemNew(my_doc,"UserID");//Islemi yapan kullanicinin (Agent - Satis Temsilcisi) yollandigi alandir. 
            my_doc.xmlRoot.XmlChildren[4].XmlChildren[3].XmlText = "PROVAUT";//Tam olarak anlamadim...
            my_doc.xmlRoot.XmlChildren[4].XmlChildren[4] = XmlElemNew(my_doc,"ID");
            my_doc.xmlRoot.XmlChildren[4].XmlChildren[4].XmlText = pos_terminal_no;//terminal no
            my_doc.xmlRoot.XmlChildren[4].XmlChildren[5] = XmlElemNew(my_doc,"MerchantID");
            my_doc.xmlRoot.XmlChildren[4].XmlChildren[5].XmlText = pos_client_id;//isyeri no.
            
            my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"Customer");
            my_doc.xmlRoot.XmlChildren[5].XmlChildren[1] = XmlElemNew(my_doc,"IPAddress");
            my_doc.xmlRoot.XmlChildren[5].XmlChildren[1].XmlText = cgi.REMOTE_ADDR;
            my_doc.xmlRoot.XmlChildren[5].XmlChildren[2] = XmlElemNew(my_doc,"EmailAddress");
            my_doc.xmlRoot.XmlChildren[5].XmlChildren[2].XmlText = ""; //üyenin maili gelecek
            
            my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"Card");
            my_doc.xmlRoot.XmlChildren[6].XmlChildren[1] = XmlElemNew(my_doc,"Number");
            my_doc.xmlRoot.XmlChildren[6].XmlChildren[1].XmlText = attributes.card_no;
            my_doc.xmlRoot.XmlChildren[6].XmlChildren[2] = XmlElemNew(my_doc,"ExpireDate");
            my_doc.xmlRoot.XmlChildren[6].XmlChildren[2].XmlText = "#expire_month##expire_year#";
            my_doc.xmlRoot.XmlChildren[6].XmlChildren[3] = XmlElemNew(my_doc,"CVV2");
            my_doc.xmlRoot.XmlChildren[6].XmlChildren[3].XmlText = attributes.cvv_no;
            
            my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"Order");
            my_doc.xmlRoot.XmlChildren[7].XmlChildren[1] = XmlElemNew(my_doc,"OrderID");
            my_doc.xmlRoot.XmlChildren[7].XmlChildren[1].XmlText = wrk_id;
            my_doc.xmlRoot.XmlChildren[7].XmlChildren[2] = XmlElemNew(my_doc,"GroupID");
            my_doc.xmlRoot.XmlChildren[7].XmlChildren[2].XmlText = "";
            
            my_doc.xmlRoot.XmlChildren[8] = XmlElemNew(my_doc,"Transaction");
            my_doc.xmlRoot.XmlChildren[8].XmlChildren[1] = XmlElemNew(my_doc,"Type");
            my_doc.xmlRoot.XmlChildren[8].XmlChildren[1].XmlText = "sales";
            if(taksit_sayisi neq 0)
            {
                my_doc.xmlRoot.XmlChildren[8].XmlChildren[2] = XmlElemNew(my_doc,"InstallmentCnt");//taksit sayisi
                my_doc.xmlRoot.XmlChildren[8].XmlChildren[2].XmlText = taksit_sayisi;
            }
            else
            {
                my_doc.xmlRoot.XmlChildren[8].XmlChildren[2] = XmlElemNew(my_doc,"InstallmentCnt");//taksit sayisi
                my_doc.xmlRoot.XmlChildren[8].XmlChildren[2].XmlText = '';
            }
            my_doc.xmlRoot.XmlChildren[8].XmlChildren[3] = XmlElemNew(my_doc,"Amount");
            my_doc.xmlRoot.XmlChildren[8].XmlChildren[3].XmlText = tutar;
            my_doc.xmlRoot.XmlChildren[8].XmlChildren[4] = XmlElemNew(my_doc,"CurrencyCode");
            my_doc.xmlRoot.XmlChildren[8].XmlChildren[4].XmlText = 949;
            my_doc.xmlRoot.XmlChildren[8].XmlChildren[5] = XmlElemNew(my_doc,"CardholderPresentCode");//normal islemler için 0, 3D islemler için 13 girilmesi gerekmektedir.
            my_doc.xmlRoot.XmlChildren[8].XmlChildren[5].XmlText = 0;
            my_doc.xmlRoot.XmlChildren[8].XmlChildren[6] = XmlElemNew(my_doc,"MotoInd");//Y ve N degerlerini alir. Ecommerce islemler için N gönderilir. Moto islem statüsündeki islemler için Y gönderilir.
            my_doc.xmlRoot.XmlChildren[8].XmlChildren[6].XmlText = "N";
            
            try
            {
                get_approved_info();
                xml_response_node = XmlParse(cfhttp.FileContent);
                response_retrefnum = xml_response_node.GVPSResponse.Transaction.RetrefNum.XmlText;
                response_detail = xml_response_node.GVPSResponse.Transaction.Response.ErrorMsg.XmlText;
                response_code = xml_response_node.GVPSResponse.Transaction.Response.ReasonCode.XmlText;			
            }
            catch(any e)
            {
                abort("Sistem Yogunlugu Nedeniyle Isleminiz Gerçeklestirilemedi! Lütfen Tekrar Deneyiniz!");
            }
        }
		else if(pos_type eq 17)//Odea Bank
		{
			my_doc = XmlNew();
            my_doc.xmlRoot = XmlElemNew(my_doc,"PayforRequest");
            
            my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"MbrId");//Kurum no
            my_doc.xmlRoot.XmlChildren[1].XmlText = pos_terminal_no;
			my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"PurchAmount");//tutar
            my_doc.xmlRoot.XmlChildren[2].XmlText = tutar;
			my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"Currency");//Para birimi - TL
            my_doc.xmlRoot.XmlChildren[3].XmlText = "949";
			my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"OrderId");//Siparis numarasi
            my_doc.xmlRoot.XmlChildren[4].XmlText = wrk_id;
			my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"InstallmentCount");
            my_doc.xmlRoot.XmlChildren[5].XmlText = taksit_sayisi;//Taksit Sayisi
			my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"TxnType");//Islem tipi(Provizyon  ve isyeri onayi islemlerini ayni anda yapar)
            my_doc.xmlRoot.XmlChildren[6].XmlText = "Auth";
			my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"UserCode");//Kullanici adi-banka tarafindan üye isyerine verilir
            my_doc.xmlRoot.XmlChildren[7].XmlText = pos_user_name;
			my_doc.xmlRoot.XmlChildren[8] = XmlElemNew(my_doc,"UserPass");//Sifre-banka tarafindan üye isyerine verilir
            my_doc.xmlRoot.XmlChildren[8].XmlText = pos_user_password;
			my_doc.xmlRoot.XmlChildren[9] = XmlElemNew(my_doc,"OrgOrderId");//Siparis numarasi
            my_doc.xmlRoot.XmlChildren[9].XmlText = "";
			my_doc.xmlRoot.XmlChildren[10] = XmlElemNew(my_doc,"Pan");//Kredi karti numarasi
            my_doc.xmlRoot.XmlChildren[10].XmlText = attributes.card_no;
			my_doc.xmlRoot.XmlChildren[11] = XmlElemNew(my_doc,"Expiry");//Son kullanma tarihi MM/YY
            my_doc.xmlRoot.XmlChildren[11].XmlText = "#expire_month##expire_year#";
			my_doc.xmlRoot.XmlChildren[12] = XmlElemNew(my_doc,"Cvv2");//Güvenlik numarasi CVV No
            my_doc.xmlRoot.XmlChildren[12].XmlText = attributes.cvv_no;
			my_doc.xmlRoot.XmlChildren[13] = XmlElemNew(my_doc,"Lang");//Dil
            my_doc.xmlRoot.XmlChildren[13].XmlText = "TR";
			my_doc.xmlRoot.XmlChildren[14] = XmlElemNew(my_doc,"MOTO");//Sabit
            my_doc.xmlRoot.XmlChildren[14].XmlText = 1;
			my_doc.xmlRoot.XmlChildren[15] = XmlElemNew(my_doc,"MerchantId");//Üye İşyeri Numarası
            my_doc.xmlRoot.XmlChildren[15].XmlText = pos_client_id;
			my_doc.xmlRoot.XmlChildren[14] = XmlElemNew(my_doc,"SecureType");//Sabit
            my_doc.xmlRoot.XmlChildren[14].XmlText = "NonSecure";
			
            try
            {
                get_approved_info_odea();
                xml_response_node = XmlParse(cfhttp.FileContent);
                response_detail = xml_response_node.PayforResponse.ErrMsg.XmlText;
                response_code = xml_response_node.PayforResponse.ProcReturnCode.XmlText;
            }
            catch(any e)
            {
                abort("Sistem Yoğunluğu Nedeniyle İşleminiz Gerçekleştirilemedi! Lütfen Tekrar Deneyiniz!");
            }
		}
    </cfscript>
</cfif>
<cffunction name="get_approved_info">
	<cfhttp method="post" url="#post_adress#" timeout="60" charset="utf-8">
		<cfhttpparam name="data" type="formfield" value="#my_doc#">
	</cfhttp>
</cffunction>

<cffunction name="get_approved_info_ziraat">
  <cfhttp url="#post_adress#" method="post" result="httpResponse">
    <cfhttpparam name="xmlRequest" type="formfield" value="#ziraat#"/>
  </cfhttp>
</cffunction>

<cffunction name="get_approved_info_odea">
	<cfhttp method="post" url="#post_adress#" timeout="60" charset="utf-8">
		<cfhttpparam name="data" type="xml" value="#my_doc#">
	</cfhttp>
</cffunction>

<cffunction name="get_approved_info_vakif">
	<cfhttp method="post" url="#post_adress#" timeout="60" charset="utf-8">
		<cfhttpparam name="prmstr" type="formfield" value="#my_doc#">
	</cfhttp>
</cffunction>