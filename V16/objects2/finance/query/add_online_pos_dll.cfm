<!---
	9-)YapıKredi,
	11-)Türkiye finans, 
	12-)bankasya (dll Format)
--->
<cfscript>
	if (pos_type eq 9)//YapiKredi
	{
		if(isDefined("vft_code") and len(vft_code))//Vade Farklı Taksitli Satış
		{
			my_doc = XmlNew();
			my_doc.xmlRoot = XmlElemNew(my_doc,"posnetRequest");
			my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"mid");
			my_doc.xmlRoot.XmlChildren[1].XmlText = pos_client_id;
			my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"tid");
			my_doc.xmlRoot.XmlChildren[2].XmlText = pos_terminal_no;
			my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"vftTransaction");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[1] = XmlElemNew(my_doc,"ccno");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[1].XmlText = attributes.card_no;
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[2] = XmlElemNew(my_doc,"cvc");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[2].XmlText = attributes.cvv_no;
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[3] = XmlElemNew(my_doc,"expDate");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[3].XmlText = expire_year & expire_month;
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[4] = XmlElemNew(my_doc,"amount");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[4].XmlText = tutar;
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[5] = XmlElemNew(my_doc,"currencyCode");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[5].XmlText = "YT";		
			
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[6] = XmlElemNew(my_doc,"installment");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[6].XmlText = taksit_sayisi;
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[7] = XmlElemNew(my_doc,"vftCode");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[7].XmlText = vft_code;
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[8] = XmlElemNew(my_doc,"orderID");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[8].XmlText = trim(member_code & "_" & left(wrk_id,23 - len(member_code))) & RepeatString("0",24-len(trim(member_code & "_" & left(wrk_id,23 - len(member_code)))));
			if(isDefined("attributes.joker_options_value") and Len(attributes.joker_options_value))//Joker vada seçimi yapılmışsa
			{
				my_doc.xmlRoot.XmlChildren[3].XmlChildren[9] = XmlElemNew(my_doc,"koiCode");
				my_doc.xmlRoot.XmlChildren[3].XmlChildren[9].XmlText = attributes.joker_options_value;
			}	
		}
		else
		{
			my_doc = XmlNew();
			my_doc.xmlRoot = XmlElemNew(my_doc,"posnetRequest");
			my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"mid");
			my_doc.xmlRoot.XmlChildren[1].XmlText = pos_client_id;
			my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"tid");
			my_doc.xmlRoot.XmlChildren[2].XmlText = pos_terminal_no;
			my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"sale");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[1] = XmlElemNew(my_doc,"amount");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[1].XmlText = tutar;
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[2] = XmlElemNew(my_doc,"ccno");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[2].XmlText = attributes.card_no;
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[3] = XmlElemNew(my_doc,"currencyCode");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[3].XmlText = "YT";
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[4] = XmlElemNew(my_doc,"cvc");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[4].XmlText = attributes.cvv_no;
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[5] = XmlElemNew(my_doc,"expDate");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[5].XmlText = expire_year & expire_month;
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[6] = XmlElemNew(my_doc,"orderID");
			my_doc.xmlRoot.XmlChildren[3].XmlChildren[6].XmlText = trim(member_code & "_" & left(wrk_id,23 - len(member_code))) & RepeatString("0",24-len(trim(member_code & "_" & left(wrk_id,23 - len(member_code))))) ;
			if (taksit_sayisi neq 0)
			{
				my_doc.xmlRoot.XmlChildren[3].XmlChildren[7] = XmlElemNew(my_doc,"installment");//Taksitli işlemse
				my_doc.xmlRoot.XmlChildren[3].XmlChildren[7].XmlText = taksit_sayisi;
				if(isDefined("attributes.joker_options_value") and Len(attributes.joker_options_value))//Joker vada seçimi yapılmışsa
				{
					my_doc.xmlRoot.XmlChildren[3].XmlChildren[8] = XmlElemNew(my_doc,"koiCode");
					my_doc.xmlRoot.XmlChildren[3].XmlChildren[8].XmlText = attributes.joker_options_value;
				}
			}
			else
			{
				if(isDefined("attributes.joker_options_value") and Len(attributes.joker_options_value))//Joker vada seçimi yapılmışsa
				{
					my_doc.xmlRoot.XmlChildren[3].XmlChildren[7] = XmlElemNew(my_doc,"koiCode");
					my_doc.xmlRoot.XmlChildren[3].XmlChildren[7].XmlText = attributes.joker_options_value;
				}
			}		
		}	
		try
		{
			get_approved_info();
			xml_response_node = XmlParse(cfhttp.FileContent);
			response_appr = xml_response_node.posnetResponse.approved.XmlText;
			if (response_appr eq 1)
			{
				response_code = "00";
				ykb_inst_num = xml_response_node.posnetResponse.instInfo.inst1.XmlText;
			}
			else
				response_code = xml_response_node.posnetResponse.respText.XmlText;
		}
		catch(any e)
		{
			abort("Sistem Yoğunluğu Nedeniyle İşleminiz Gerçekleştirilemedi! Lütfen Tekrar Deneyiniz!");
		}
	}
	else if (pos_type eq 11)//Türkiye Finans
	{
		get_approved_info_tfinans();
		xml_response_node = XmlParse(cfhttp.FileContent);
		response_code = left(xml_response_node.string.XmlText,2);
	}
	else if (pos_type eq 12)//Bank Asya
	{
		my_doc = XmlNew(true);
		my_doc.xmlRoot = XmlElemNew(my_doc,"ePaymentMsg");
		my_doc.xmlRoot.XmlAttributes["VersionInfo"]="2.0";
		my_doc.xmlRoot.XmlAttributes["TT"]="Request";
		my_doc.xmlRoot.XmlAttributes["RM"]="Direct";
		my_doc.xmlRoot.XmlAttributes["CT"]="Money";
		my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"Operation");
		my_doc.xmlRoot.XmlChildren[1].XmlAttributes["ActionType"]="Sale";
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1] = XmlElemNew(my_doc,"OpData");
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[1] = XmlElemNew(my_doc,"MerchantInfo");
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlAttributes["MerchantId"] =pos_client_id;//Üye isyeri numarasi
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlAttributes["MerchantPassword"]=pos_user_password;//Üye isyeri numarasi
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2] = XmlElemNew(my_doc,"ActionInfo");
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[1] = XmlElemNew(my_doc,"TrnxCommon");
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[1].XmlAttributes["TrnxID"] = wrk_id;//IslemNumaraBilgisi-unique
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[1].XmlAttributes["Protocol"] = "156";//Islem protocol bilgisi
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[1].XmlChildren[1] = XmlElemNew(my_doc,"AmountInfo");
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[1].XmlChildren[1].XmlAttributes["Amount"] = tutar;
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[1].XmlChildren[1].XmlAttributes["Currency"] = "949";
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[1].XmlChildren[2] = XmlElemNew(my_doc,"ProtocolData");
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[2] = XmlElemNew(my_doc,"PaymentTypeInfo");
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[2].XmlChildren[1] = XmlElemNew(my_doc,"InstallmentInfo");
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlChildren[2].XmlChildren[1].XmlAttributes["NumberOfInstallments"] = taksit_sayisi;
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[3] = XmlElemNew(my_doc,"PANInfo");
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[3].XmlAttributes["PAN"] = attributes.card_no;//kredi karti bilgisi
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[3].XmlAttributes["ExpiryDate"] = attributes.exp_year & expire_month;//son kullanma tarihi
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[3].XmlAttributes["CVV2"] = attributes.cvv_no;//cvv no
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[3].XmlAttributes["BrandID"] = "";//Kart kurulusu VISA vs
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[4] = XmlElemNew(my_doc,"OrgTrnxInfo");
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[4].XmlText = attributes.firma_info;
		my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[5] = XmlElemNew(my_doc,"CustomData");
		try
		{
			get_approved_info_bankasya();
			xml_response_node = XmlParse(cfhttp.FileContent);
			response_code = XmlParse(xml_response_node).ePaymentMsg.Operation.OpData.ActionInfo.HostResponse.xmlAttributes.ResultCode;
		}
		catch(any e)
		{
			abort("Sistem Yogunlugu Nedeniyle Isleminiz Gerçeklestirilemedi! Lütfen Tekrar Deneyiniz!");
		}
	}
</cfscript>
<cffunction name="get_approved_info">
	<cfhttp method="post" url="#post_adress#" timeout="60">
		<cfhttpparam name="xmldata" type="formfield" value="#my_doc#">
	</cfhttp>
</cffunction>
<cffunction name="get_approved_info_bankasya"><!--- bankasya --->
	<cfhttp method="post" url="#post_adress#" charset="iso-8859-9">
		<cfhttpparam name="prmstr" type="formfield" value="#my_doc#" >
	</cfhttp>
</cffunction>
<cffunction name="get_approved_info_tfinans"><!--- türkiye finans desenine göre cfhttp oluştrlr --->
	<cfhttp method="post" url="#post_adress#" timeout="60">
		<cfhttpparam name="pOrgNo" type="formfield" value="#pos_store_key#">
		<cfhttpparam name="pFirmNo" type="formfield" value="#pos_client_id#">
		<cfhttpparam name="pTermNo" type="formfield" value="#pos_terminal_no#">
		<cfhttpparam name="pCardNo" type="formfield" value="#attributes.card_no#">
		<cfhttpparam name="pCvv2No" type="formfield" value="#attributes.cvv_no#">
		<cfhttpparam name="pExpiry" type="formfield" value="#attributes.exp_year##expire_month#">
		<cfhttpparam name="pAmount" type="formfield" value="#tutar#">
		<cfhttpparam name="pTaksit" type="formfield" value="#taksit_sayisi#">
	</cfhttp>
</cffunction>