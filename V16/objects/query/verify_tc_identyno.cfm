<!--- Gelen ad,soyad,tc no ve doğum tarihi bilgilerine göre web servis ile doğrulama yapar. SM 20110228--->
<!--- 9 ile başlayan yabancı uyruklu kişilerin sorgulaması için yeni servis eklendi. EY20201016--->
<cfsetting showdebugoutput="no">
<cfif left(attributes.tc_number,1) eq 9><!--- Yabancı uyruklu --->
	<cfoutput>
		<cfscript>
			my_doc = XmlNew();
			my_doc.xmlRoot = XmlElemNew(my_doc,"soap:Envelope");
				my_doc.xmlRoot.XmlAttributes["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance";
				my_doc.xmlRoot.XmlAttributes["xmlns:xsd"] = "http://www.w3.org/2001/XMLSchema";
				my_doc.xmlRoot.XmlAttributes["xmlns:soap"] = "http://schemas.xmlsoap.org/soap/envelope/";
					my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"soap:Body");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1] = XmlElemNew(my_doc,"YabanciKimlikNoDogrula");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlAttributes["xmlns"] = "http://tckimlik.nvi.gov.tr/WS";
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[1] = XmlElemNew(my_doc,"KimlikNo");
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlText =  attributes.tc_number;
			
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2] = XmlElemNew(my_doc,"Ad");
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlText = UCASETR(attributes.consumer_name);
			
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[3] = XmlElemNew(my_doc,"Soyad");
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[3].XmlText = UCASETR(attributes.consumer_surname);
							
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[4] = XmlElemNew(my_doc,"DogumGun");
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[4].XmlText = day(attributes.birth_date);
							
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[5] = XmlElemNew(my_doc,"DogumAy");
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[5].XmlText = month(attributes.birth_date);
							
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[6] = XmlElemNew(my_doc,"DogumYil");
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[6].XmlText = year(attributes.birth_date);
		</cfscript>
	</cfoutput>
	<cfhttp url="https://tckimlik.nvi.gov.tr/Service/KPSPublicYabanciDogrula.asmx" method="post">
		<cfhttpparam type="header" name="content-type" value="text/xml;charset=utf-8">
		<cfhttpparam type="header" name="content-length" value="#len(my_doc)#">
		<cfhttpparam type="header" name="charset" value="utf-8">
		<cfhttpparam type="xml" name="message" value="#trim(my_doc)#">
	</cfhttp>
<cfelse>
	<cfoutput>
		<cfscript>
			my_doc = XmlNew();
			my_doc.xmlRoot = XmlElemNew(my_doc,"soap:Envelope");
				my_doc.xmlRoot.XmlAttributes["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance";
				my_doc.xmlRoot.XmlAttributes["xmlns:xsd"] = "http://www.w3.org/2001/XMLSchema";
				my_doc.xmlRoot.XmlAttributes["xmlns:soap"] = "http://schemas.xmlsoap.org/soap/envelope/";
					my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"soap:Body");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1] = XmlElemNew(my_doc,"TCKimlikNoDogrula");
						my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlAttributes["xmlns"] = "http://tckimlik.nvi.gov.tr/WS";
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[1] = XmlElemNew(my_doc,"TCKimlikNo");
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[1].XmlText =  attributes.tc_number;
			
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2] = XmlElemNew(my_doc,"Ad");
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[2].XmlText = UCASETR(attributes.consumer_name);
			
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[3] = XmlElemNew(my_doc,"Soyad");
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[3].XmlText = UCASETR(attributes.consumer_surname);
							
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[4] = XmlElemNew(my_doc,"DogumYili");
							my_doc.xmlRoot.XmlChildren[1].XmlChildren[1].XmlChildren[4].XmlText = year(attributes.birth_date);
		</cfscript>
	</cfoutput>
	<cfhttp url="https://tckimlik.nvi.gov.tr/Service/KPSPublic.asmx" method="post">
		<cfhttpparam type="header" name="content-type" value="text/xml;charset=utf-8">
		<cfhttpparam type="header" name="content-length" value="#len(my_doc)#">
		<cfhttpparam type="header" name="charset" value="utf-8">
		<cfhttpparam type="xml" name="message" value="#trim(my_doc)#">
	</cfhttp>
</cfif>
<cftry>
	<cfset xmlDoc = XmlParse(cfhttp.FileContent)>
	<cfif arraylen(xmlDoc.xmlroot.xmlChildren[1].xmlChildren[1].xmlChildren) gt 1>
		<cfset verify_info=xmlDoc.xmlroot.xmlChildren[1].xmlChildren[1].xmlChildren[2].XmlText>
	<cfelse>
		<cfset verify_info=xmlDoc.xmlroot.xmlChildren[1].xmlChildren[1].xmlChildren[1].XmlText>
	</cfif>
	<cfif verify_info is 'true'>
		<script>
		 	document.getElementById('is_verify').value = 1;
		</script>
		<font color="009900">TC Kimlik No Geçerli</font>
	<cfelse>
		<script>
		 	document.getElementById('is_verify').value = 0;
		</script>
		<font color="FF0000">TC Kimlik No Geçersiz</font>
	</cfif>
	<cfcatch type="any">
		<font color="FF0000">Bağlantı Hatası</font>
	</cfcatch>
</cftry>
<cfabort>
