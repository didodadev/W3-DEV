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
	16-)ING Bank(xml format)
	18-)Şekerbank
--->
<cfif listfind("7",pos_type,',')>
	<cfhttp method="post" url="#post_adress#" result="vakifResult" timeout="60" charset="utf-8">  <!--- https://3dsecure.vakifbank.com.tr:4443/MPIAPI/MPI_Enrollment.aspx --->
		<cfhttpparam name="MerchantId" type="formfield" value="#pos_user_name#"> <!---üye işyeri numarası --->
		<cfhttpparam name="MerchantPassword" type="formfield" value="#pos_user_password#"> <!---Sifre-banka tarafindan üye isyerine verilir--->
		<cfhttpparam name="VerifyEnrollmentRequestId" type="formfield" value="#wrk_id#">  <!---ÜİY tarafından üretilen işlem numarasıdır.--->
		<cfhttpparam name="Pan" type="formfield" value="#attributes.card_no#"><!--- Kredi kartı numarası --->
		<cfhttpparam name="ExpiryDate" type="formfield" value="#right(expire_year,2)##expire_month#"> <!---Kredi kartı son kullanma tarihi YYAA--->
		<cfhttpparam name="PurchaseAmount" type="formfield" value="#tutar#"> 
		<cfhttpparam name="Currency" type="formfield" value="949">
		<cfhttpparam name="BrandName" type="formfield" value="200"> <!--- 100 visa , 200 mastercard--->
		<cfhttpparam name="SessionInfo" type="formfield" value="">
		<cfhttpparam name="SuccessUrl" type="formfield" value="">
		<cfhttpparam name="FailureUrl" type="formfield" value="">
	</cfhttp>
	<cfset resultarray = xmlparse(vakifResult.filecontent)>
	<cfif isdefined("resultarray.IPaySecure.Message.VERes")>
		<cfset resultarray = resultarray.IPaySecure.Message.VERes>
		<cfset status = resultarray.Status.xmltext>
		<cfif status is 'Y'>
			<cftry>
			<cfset paReq = resultarray.PaReq.xmltext>
			<cfset termUrl = resultarray.TermUrl.xmltext>
			<cfset MD = resultarray.MD.xmltext>
			<cfset acsUrl = resultarray.acsUrl.xmltext>
			<cfform name="sendForm" action="#acsUrl#">
				<cfinput type="text" name="paReq" value="#paReq#">
				<cfinput type="text" name="termUrl" value="#termUrl#">
				<cfinput type="text" name="MD" value="#MD#">
			</cfform>
			<script>
				$("#sendForm").submit();
			</script>
			<cfcatch>
			</cfcatch>
			</cftry>
		<cfelse>
			<script>
				alert('Not supporting');
			</script>
			<cfabort>
		</cfif>
	<cfelse>
		<cfoutput>#resultarray.IPaySecure.errormessage#</cfoutput>
	</cfif>
</cfif>
<cfscript>
	if(listfind("1,2,3,4,5,6,10,13,14,15,16,18",pos_type,','))
	{
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc,"CC5Request");
		my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"Name");//Kullanici adi-banka tarafindan üye isyerine verilir
		my_doc.xmlRoot.XmlChildren[1].XmlText = pos_user_name;
		my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"Password");//Sifre-banka tarafindan üye isyerine verilir
		my_doc.xmlRoot.XmlChildren[2].XmlText = pos_user_password;
		my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"ClientId");//Magaza numarasi-banka tarafindan üye isyerine verilir
		my_doc.xmlRoot.XmlChildren[3].XmlText = pos_client_id;
		my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"IPAddress");
		my_doc.xmlRoot.XmlChildren[4].XmlText = cgi.REMOTE_ADDR;
		my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"Email");
		my_doc.xmlRoot.XmlChildren[5].XmlText = "";
		my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"Mode");
		my_doc.xmlRoot.XmlChildren[6].XmlText = "T";
		my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"OrderId");
		my_doc.xmlRoot.XmlChildren[7].XmlText = attributes.oid;
		my_doc.xmlRoot.XmlChildren[8] = XmlElemNew(my_doc,"GroupId");
		my_doc.xmlRoot.XmlChildren[8].XmlText = "";
		my_doc.xmlRoot.XmlChildren[9] = XmlElemNew(my_doc,"TransId");
		my_doc.xmlRoot.XmlChildren[9].XmlText = "";
		my_doc.xmlRoot.XmlChildren[10] = XmlElemNew(my_doc,"UserId");
		my_doc.xmlRoot.XmlChildren[10].XmlText = "";
		my_doc.xmlRoot.XmlChildren[11] = XmlElemNew(my_doc,"Type");
		my_doc.xmlRoot.XmlChildren[11].XmlText = "Auth";
		my_doc.xmlRoot.XmlChildren[12] = XmlElemNew(my_doc,"Number");
		my_doc.xmlRoot.XmlChildren[12].XmlText = attributes.md;
		my_doc.xmlRoot.XmlChildren[13] = XmlElemNew(my_doc,"Expires");
		my_doc.xmlRoot.XmlChildren[13].XmlText = "";
		my_doc.xmlRoot.XmlChildren[14] = XmlElemNew(my_doc,"Cvv2Val");
		my_doc.xmlRoot.XmlChildren[14].XmlText = "";
		my_doc.xmlRoot.XmlChildren[15] = XmlElemNew(my_doc,"Total");
		my_doc.xmlRoot.XmlChildren[15].XmlText = attributes.amount;
		my_doc.xmlRoot.XmlChildren[16] = XmlElemNew(my_doc,"Currency");
		my_doc.xmlRoot.XmlChildren[16].XmlText = 949;
		my_doc.xmlRoot.XmlChildren[17] = XmlElemNew(my_doc,"Taksit");
		my_doc.xmlRoot.XmlChildren[17].XmlText = attributes.taksit;
		my_doc.xmlRoot.XmlChildren[18] = XmlElemNew(my_doc,"PayerTxnId");
		my_doc.xmlRoot.XmlChildren[18].XmlText = attributes.xid;
		my_doc.xmlRoot.XmlChildren[19] = XmlElemNew(my_doc,"PayerSecurityLevel");
		my_doc.xmlRoot.XmlChildren[19].XmlText = attributes.eci;
		my_doc.xmlRoot.XmlChildren[20] = XmlElemNew(my_doc,"PayerAuthenticationCode");
		my_doc.xmlRoot.XmlChildren[20].XmlText = attributes.cavv;
		my_doc.xmlRoot.XmlChildren[21] = XmlElemNew(my_doc,"CardholderPresentCode");
		my_doc.xmlRoot.XmlChildren[21].XmlText = 13;
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
	else if(pos_type eq 8)
	{		
		if (len(pos_terminal_no) lt 9)
			terminalID_ = repeatString("0",9-len(pos_terminal_no)) & "#pos_terminal_no#";
		else
			terminalID_ = pos_terminal_no;
		
		hashpass = hash("#pos_user_password##terminalID_#",'sha-1');
		hashdata = hash("#attributes.oid##pos_terminal_no##tutar##hashpass#",'sha-1');
		
		my_doc = XmlNew();
		my_doc.xmlRoot = XmlElemNew(my_doc,"GVPSRequest");
		
		my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"Mode");
		my_doc.xmlRoot.XmlChildren[1].XmlText = "PROD";
		
		my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"Version");
		my_doc.xmlRoot.XmlChildren[2].XmlText = "v0.01";
		
		my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"Terminal");
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[1] = XmlElemNew(my_doc,"ProvUserID");//Terminale ait provizyon kullanici kodunun  gönderildigi alandir. Burada Prov kullanicisi, Iptal iade kullanicisi veya OOS  kullanicisi bulunabilir
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[1].XmlText = pos_user_name;
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[2] = XmlElemNew(my_doc,"HashData");
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[2].XmlText = hashdata;//Has Data Gelecek
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[3] = XmlElemNew(my_doc,"UserID");//Islemi yapan kullanicinin (Agent - Satis Temsilcisi) yollandigi alandir. 
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[3].XmlText = "PROVAUT";
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[4] = XmlElemNew(my_doc,"ID");
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[4].XmlText = pos_terminal_no;//terminal no
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[5] = XmlElemNew(my_doc,"MerchantID");
		my_doc.xmlRoot.XmlChildren[3].XmlChildren[5].XmlText = pos_client_id;//isyeri no.
		
		my_doc.xmlRoot.XmlChildren[4] = XmlElemNew(my_doc,"Customer");
		my_doc.xmlRoot.XmlChildren[4].XmlChildren[1] = XmlElemNew(my_doc,"IPAddress");
		my_doc.xmlRoot.XmlChildren[4].XmlChildren[1].XmlText = cgi.REMOTE_ADDR;
		my_doc.xmlRoot.XmlChildren[4].XmlChildren[2] = XmlElemNew(my_doc,"EmailAddress");
		my_doc.xmlRoot.XmlChildren[4].XmlChildren[2].XmlText = ""; //üyenin maili gelecek
		
		my_doc.xmlRoot.XmlChildren[5] = XmlElemNew(my_doc,"Card");
		my_doc.xmlRoot.XmlChildren[5].XmlChildren[1] = XmlElemNew(my_doc,"Number");
		my_doc.xmlRoot.XmlChildren[5].XmlChildren[1].XmlText = '';
		my_doc.xmlRoot.XmlChildren[5].XmlChildren[2] = XmlElemNew(my_doc,"ExpireDate");
		my_doc.xmlRoot.XmlChildren[5].XmlChildren[2].XmlText = "";
		my_doc.xmlRoot.XmlChildren[5].XmlChildren[3] = XmlElemNew(my_doc,"CVV2");
		my_doc.xmlRoot.XmlChildren[5].XmlChildren[3].XmlText = '';
		
		my_doc.xmlRoot.XmlChildren[6] = XmlElemNew(my_doc,"Order");
		my_doc.xmlRoot.XmlChildren[6].XmlChildren[1] = XmlElemNew(my_doc,"OrderID");
		my_doc.xmlRoot.XmlChildren[6].XmlChildren[1].XmlText = attributes.oid;
		my_doc.xmlRoot.XmlChildren[6].XmlChildren[2] = XmlElemNew(my_doc,"GroupID");
		my_doc.xmlRoot.XmlChildren[6].XmlChildren[2].XmlText = "";
		my_doc.xmlRoot.XmlChildren[6].XmlChildren[2] = XmlElemNew(my_doc,"Description");
		my_doc.xmlRoot.XmlChildren[6].XmlChildren[2].XmlText = "";
		
		my_doc.xmlRoot.XmlChildren[7] = XmlElemNew(my_doc,"Transaction");
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[1] = XmlElemNew(my_doc,"Type");
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[1].XmlText = "sales";
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[2] = XmlElemNew(my_doc,"InstallmentCnt");//taksit sayisi
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[2].XmlText = attributes.taksit;
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[3] = XmlElemNew(my_doc,"Amount");
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[3].XmlText = tutar;
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[4] = XmlElemNew(my_doc,"CurrencyCode");
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[4].XmlText = 949;
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[5] = XmlElemNew(my_doc,"CardholderPresentCode");//normal islemler için 0, 3D islemler için 13 girilmesi gerekmektedir.
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[5].XmlText = 13;
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[6] = XmlElemNew(my_doc,"MotoInd");
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[6].XmlText = "H";
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[7] = XmlElemNew(my_doc,"Secure3D");
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[7].XmlChildren[1] = XmlElemNew(my_doc,"AuthenticationCode");
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[7].XmlChildren[1].XmlText = attributes.cavv;
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[7].XmlChildren[2] = XmlElemNew(my_doc,"SecurityLevel");
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[7].XmlChildren[2].XmlText = attributes.eci;
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[7].XmlChildren[3] = XmlElemNew(my_doc,"TxnID");
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[7].XmlChildren[3].XmlText = attributes.xid;
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[7].XmlChildren[4] = XmlElemNew(my_doc,"Md");
		my_doc.xmlRoot.XmlChildren[7].XmlChildren[7].XmlChildren[4].XmlText = attributes.md;
		
		try
		{
			get_approved_info();
			xml_response_node = XmlParse(cfhttp.FileContent);
			response_retrefnum = xml_response_node.GVPSResponse.Transaction.RetrefNum.XmlText;
			response_detail = xml_response_node.GVPSResponse.Transaction.Response.SysErrMsg.XmlText;
			response_code = xml_response_node.GVPSResponse.Transaction.Response.ReasonCode.XmlText;			
		}
		catch(any e)
		{
			abort("Sistem Yogunlugu Nedeniyle Isleminiz Gerçeklestirilemedi! Lütfen Tekrar Deneyiniz!");
		}
	}
</cfscript>

<cffunction name="get_approved_info">
	<cfhttp method="post" url="#post_adress#" timeout="60" charset="utf-8">
		<cfhttpparam name="data" type="formfield" value="#my_doc#">
	</cfhttp>
</cffunction>