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
	16-)ING Bank,
	17-)Odea Bank(xml format)
--->
<cfscript>
	if (listfind("1,2,3,4,5,6,10,13,14,16",pos_type,','))
	{
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc,"CC5Request");
		
		my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"Name");//Kullanici adi-banka tarafindan üye isyerine verilir
		my_doc.xmlRoot.XmlChildren[1].XmlText = pos_user_name;
		my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"Password");//Sifre-banka tarafindan üye isyerine verilir
		my_doc.xmlRoot.XmlChildren[2].XmlText = pos_user_password;
		my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"ClientId");//Magaza numarasi-banka tarafindan üye isyerine verilir
		my_doc.xmlRoot.XmlChildren[3].XmlText = pos_client_id;
		my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"Mode");//Magaza numarasi-banka tarafindan üye isyerine verilir
		my_doc.xmlRoot.XmlChildren[4].XmlText = "p";
		my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"OrderId");//Siparis numarasi
		my_doc.xmlRoot.XmlChildren[5].XmlText = attributes.relation_wrk_id;
		my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"Type");//Islem tipi(Provizyon  ve isyeri onayi islemlerini ayni anda yapar)
		if(is_iptal eq 1)
			my_doc.xmlRoot.XmlChildren[6].XmlText = "Void";
		else
			my_doc.xmlRoot.XmlChildren[6].XmlText = "Credit";
			
		if(is_iptal eq 0)
		{
			my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"Total");//Islem yapilacak toplam tutar
			my_doc.xmlRoot.XmlChildren[7].XmlText = tutar;
			my_doc.xmlRoot.XmlChildren[8] = XmlElemNew(my_doc,"Currency");//Para birimi - TL
			my_doc.xmlRoot.XmlChildren[8].XmlText = "949";
		}
			
		try
		{
			get_approved_info();
			xml_response_node = XmlParse(cfhttp.FileContent);
			response_detail = xml_response_node.CC5Response.ErrMsg.XmlText;
			response_code = xml_response_node.CC5Response.ProcReturnCode.XmlText;
		}
		catch(any e)
		{
			abort("Sistem Yoğunluğu Nedeniyle İşleminiz Gerçekleştirilemedi! Lütfen Tekrar Deneyiniz!");
		}
	}
	else if (pos_type eq 7)//vakıfbank
	{
		 	my_doc = XmlNew();
            my_doc.xmlRoot = XmlElemNew(my_doc,"VposRequest");
            
            my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"MerchantId");//Magaza numarasi-banka tarafindan üye isyerine verilir
            my_doc.xmlRoot.XmlChildren[1].XmlText = pos_client_id;
			
            my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"Password");//Sifre-banka tarafindan üye isyerine verilir
            my_doc.xmlRoot.XmlChildren[2].XmlText = pos_user_password;
			
        	my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"TransactionType");//Sabit
            my_doc.xmlRoot.XmlChildren[3].XmlText = "Cancel";
			
            my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"ReferenceTransactionId");//Siparis numarasi
            my_doc.xmlRoot.XmlChildren[4].XmlText = attributes.relation_wrk_id;
			
			my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"ClientIp");//IP 
            my_doc.xmlRoot.XmlChildren[5].XmlText = cgi.REMOTE_ADDR;
			
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
		if(len(pos_terminal_no) lt 9)
			terminalID_ = repeatString("0",9-len(pos_terminal_no)) & "#pos_terminal_no#";
		else
			terminalID_ = pos_terminal_no;
		
		hashpass = hash("#pos_user_password##terminalID_#",'sha-1');
		hashdata = hash("#attributes.relation_wrk_id##pos_terminal_no##tutar##hashpass#",'sha-1');
		
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc,"GVPSRequest");
		
		my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"Mode");
		my_doc.xmlRoot.XmlChildren[1].XmlText = "PROD";
		
		my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"Version");
		my_doc.xmlRoot.XmlChildren[2].XmlText = "v0.01";
		
		my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"Terminal");
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[1] = XmlElemNew(my_doc,"ProvUserID");//Terminale ait provizyon kullanici kodunun  gönderildigi alandir. Burada Prov kullanicisi, Iptal iade kullanicisi veya OOS  kullanicisi bulunabilir
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[1].XmlText = "PROVRFN";
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[2] = XmlElemNew(my_doc,"HashData");
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[2].XmlText = hashdata;//Has Data Gelecek
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[3] = XmlElemNew(my_doc,"UserID");//Islemi yapan kullanicinin (Agent - Satis Temsilcisi) yollandigi alandir. 
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[3].XmlText = "PROVRFN";
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[4] = XmlElemNew(my_doc,"ID");
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[4].XmlText = pos_terminal_no;//terminal no
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[5] = XmlElemNew(my_doc,"MerchantID");
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[5].XmlText = pos_client_id;//isyeri no.
		
		my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"Customer");
		my_doc.xmlRoot.XmlChildren[4].XmlChildren[1] = XmlElemNew(my_doc,"IPAddress");
		my_doc.xmlRoot.XmlChildren[4].XmlChildren[1].XmlText = cgi.REMOTE_ADDR;
		
		my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"Order");
		my_doc.xmlRoot.XmlChildren[5].XmlChildren[1] = XmlElemNew(my_doc,"OrderID");
		my_doc.xmlRoot.XmlChildren[5].XmlChildren[1].XmlText = attributes.relation_wrk_id;
		
		my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"Transaction");
		if(is_iptal eq 1)
		{
			my_doc.xmlRoot.XmlChildren[6].XmlChildren[1] = XmlElemNew(my_doc,"Type");
			my_doc.xmlRoot.XmlChildren[6].XmlChildren[1].XmlText = "void";
			/*my_doc.xmlRoot.XmlChildren[6].XmlChildren[2] = XmlElemNew(my_doc,"OriginalRetrefNum");
			my_doc.xmlRoot.XmlChildren[6].XmlChildren[2].XmlText = attributes.relation_wrk_id;*/
		}
		else
		{
			my_doc.xmlRoot.XmlChildren[6].XmlChildren[1] = XmlElemNew(my_doc,"Type");
			my_doc.xmlRoot.XmlChildren[6].XmlChildren[1].XmlText = "refund";
		}
		my_doc.xmlRoot.XmlChildren[6].XmlChildren[2] = XmlElemNew(my_doc,"Amount");
		my_doc.xmlRoot.XmlChildren[6].XmlChildren[2].XmlText = tutar;
		my_doc.xmlRoot.XmlChildren[6].XmlChildren[3] = XmlElemNew(my_doc,"CurrencyCode");
		my_doc.xmlRoot.XmlChildren[6].XmlChildren[3].XmlText = 949;
		try
		{
			get_approved_info();
			xml_response_node = XmlParse(cfhttp.FileContent);
			response_detail = xml_response_node.GVPSResponse.Transaction.Response.SysErrMsg.XmlText;
			response_code = xml_response_node.GVPSResponse.Transaction.Response.ReasonCode.XmlText;
		}
		catch(any e)
		{
			abort("Sistem Yogunlugu Nedeniyle Isleminiz Gerçeklestirilemedi! Lütfen Tekrar Deneyiniz!");
		}
	}
	else if (pos_type eq 9)//YapiKredi
	{
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc,"posnetRequest");
		my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"mid");
		my_doc.xmlRoot.XmlChildren[1].XmlText = pos_client_id;
		my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"tid");
		my_doc.xmlRoot.XmlChildren[2].XmlText = pos_terminal_no;
		if(is_iptal eq 0)
		{
			my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"reserve");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[1] = XmlElemNew(my_doc,"transaction");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[1].XmlText = "pointUsage";
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[2] = XmlElemNew(my_doc,"orderID");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[2].XmlText = trim(member_code & "_" & left(attributes.relation_wrk_id,23 - len(member_code))) & RepeatString("0",24-len(trim(member_code & "_" & left(attributes.relation_wrk_id,23 - len(member_code)))));
		}
		else
		{
			my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"return");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[1] = XmlElemNew(my_doc,"amount");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[1].XmlText = tutar;
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[2] = XmlElemNew(my_doc,"currencyCode");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[2].XmlText = "YT";
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[3] = XmlElemNew(my_doc,"orderID");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[3].XmlText = trim(member_code & "_" & left(attributes.relation_wrk_id,23 - len(member_code))) & RepeatString("0",24-len(trim(member_code & "_" & left(attributes.relation_wrk_id,23 - len(member_code)))));
		}
		try
		{
			get_approved_info_ykb();
			xml_response_node = XmlParse(cfhttp.FileContent);
			response_appr = xml_response_node.posnetResponse.approved.XmlText;
			if (response_appr eq 1)
			{
				response_code = "00";
				ykb_inst_num = xml_response_node.posnetResponse.instInfo.inst1.XmlText;
			}
			else
			{
				response_code = xml_response_node.posnetResponse.respText.XmlText;
				response_detail = 'İşleminiz onay almamıştır.';
			}
		}
		catch(any e)
		{
			abort("Sistem Yoğunluğu Nedeniyle İşleminiz Gerçekleştirilemedi! Lütfen Tekrar Deneyiniz!");
		}
	}
	else if(pos_type eq 17)
	{
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc,"PayforRequest");
		
		my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"MbrId");//Kurum no
		my_doc.xmlRoot.XmlChildren[1].XmlText = pos_terminal_no;
		my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"PurchAmount");//tutar
		if(is_iptal eq 1)
			my_doc.xmlRoot.XmlChildren[2].XmlText = "";
		else
			my_doc.xmlRoot.XmlChildren[2].XmlText = tutar;//iade yapilacagi zaman tutar gonderiliyor
		my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"Currency");//Para birimi - TL
		my_doc.xmlRoot.XmlChildren[3].XmlText = "949";
		my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"OrderId");//Siparis numarasi
		my_doc.xmlRoot.XmlChildren[4].XmlText = "";
		my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"InstallmentCount");
		my_doc.xmlRoot.XmlChildren[5].XmlText = "";//Taksit Sayisi
		my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"TxnType");//Islem tipi(Provizyon  ve isyeri onayi islemlerini ayni anda yapar)
		if(is_iptal eq 1)
			my_doc.xmlRoot.XmlChildren[6].XmlText = "Void";//iptal
		else
			my_doc.xmlRoot.XmlChildren[6].XmlText = "Refund";//iade
		my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"UserCode");//Kullanici adi-banka tarafindan üye isyerine verilir
		my_doc.xmlRoot.XmlChildren[7].XmlText = pos_user_name;
		my_doc.xmlRoot.XmlChildren[8] = XmlElemNew(my_doc,"UserPass");//Sifre-banka tarafindan üye isyerine verilir
		my_doc.xmlRoot.XmlChildren[8].XmlText = pos_user_password;
		my_doc.xmlRoot.XmlChildren[9] = XmlElemNew(my_doc,"OrgOrderId");//Siparis numarasi
		my_doc.xmlRoot.XmlChildren[9].XmlText = attributes.relation_wrk_id;
		my_doc.xmlRoot.XmlChildren[10] = XmlElemNew(my_doc,"Pan");//Kredi karti numarasi
		my_doc.xmlRoot.XmlChildren[10].XmlText = "";
		my_doc.xmlRoot.XmlChildren[11] = XmlElemNew(my_doc,"Expiry");//Son kullanma tarihi MM/YY
		my_doc.xmlRoot.XmlChildren[11].XmlText = "";
		my_doc.xmlRoot.XmlChildren[12] = XmlElemNew(my_doc,"Cvv2");//Güvenlik numarasi CVV No
		my_doc.xmlRoot.XmlChildren[12].XmlText = "";
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
	else
	{
		abort("Geçerli Pos Tipinize Ait İptal Entegrasyonu Yapılmamıştır! Tahsilat İptal İşlemi Yapılamaz.");	
	}
</cfscript>

<cffunction name="get_approved_info">
  <cfhttp method="post" url="#post_adress#" timeout="60" charset="utf-8">
    <cfhttpparam name="data" type="formfield" value="#my_doc#">
  </cfhttp>
</cffunction>

<cffunction name="get_approved_info_ykb">
	<cfhttp method="post" url="#post_adress#" timeout="60">
		<cfhttpparam name="xmldata" type="formfield" value="#my_doc#">
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