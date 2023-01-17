<cfif isdefined("session.ep.userid")>
	Bu sayfa sisteme giriş yapmadan çalışan otomatik bir işlemdir. <br>
	Lütfen sistemden çıkış yaparak tekrar deneyiniz.
	<cfexit method="exittemplate">
	<cfabort>
</cfif>


<cfif isdefined("session.ep")>
	<cfloop collection=#session.ep# item="key_field">
		<cfscript>
			StructDelete(session.ep, key_field);
		</cfscript>
	</cfloop>

	<cfscript>
		StructDelete(session,'ep');
	</cfscript>
</cfif>

<cfset user_id_ = 50>
<cfset company_id_ = 1>

<!---
	1-Finds the published market-place products that have expired and, later, sets them to the unplublishe status.
--->
<cfquery name="GET_MPPROD" datasource="#dsn#">
	SELECT *
	FROM
		MARKET_PLACE_PRODUCT
	WHERE
		IS_PUBLISHED = 1
	AND
		PUBLISH_DATE is not null
</cfquery>
<cfloop query="GET_MPPROD">
	<cfset remainingDays = DateDiff("d",now(),#PUBLISH_DATE#)>
	<cfif remainingDays lte 0>
		<cfquery name="UPD_MPPROD" datasource="#dsn#">
			UPDATE MARKET_PLACE_PRODUCT
			SET IS_PUBLISHED = 0
			WHERE
				PRODUCT_ID = #PRODUCT_ID#
			AND
				IS_PUBLISHED = 1
		</cfquery>
	</cfif>
</cfloop>
<!---
	2-Pulls the orders from a market-place, enrolls them in Database
--->
<cfquery name="MP_SETTS" datasource="#dsn#">
	SELECT
		MARKET_PLACE_ID,
		MARKET_PLACE,
		API_KEY,
		SECRET_KEY,
		ROLE_NAME,
		ROLE_PASS
	FROM
		MARKET_PLACE_SETTINGS
	WHERE
		API_KEY IS NOT NULL
</cfquery>
<cfloop query="MP_SETTS">
	<cfif MARKET_PLACE_ID eq 1> <!--- gittigidiyor --->
		<cfscript>
			SystemTime = GetTickCount();
			APIKey = API_KEY;
			roleName = ROLE_NAME;
			rolePass = ROLE_PASS;
			ggSign = hash(API_KEY & SECRET_KEY & SystemTime);
		</cfscript>
		<cfoutput>gittigidiyor ---> #SystemTime# -- #ggSign#<br></cfoutput>
		<cfsavecontent variable="soapBody">
			<cfoutput>
				<?xml version="1.0" encoding="utf-8"?>
				<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sale="http://sale.individual.ws.listingapi.gg.com">
					<soapenv:Header/>
					<soapenv:Body>
						<sale:getSales>
							<apiKey>#APIKey#</apiKey>
							<sign>#ggSign#</sign>
							<time>#SystemTime#</time>
							<withData>true</withData>
							<byStatus>S</byStatus>
							<byUser></byUser>
							<orderBy>A</orderBy>
							<orderType>A</orderType>
							<pageNumber>1</pageNumber>
							<pageSize>20</pageSize>
							<lang>tr</lang>
						</sale:getSales>
					</soapenv:Body>
				</soapenv:Envelope>
			</cfoutput>
		</cfsavecontent>
		<cfhttp url="http://dev.gittigidiyor.com:8080/listingapi/ws/IndividualSaleService?wsdl"
				method="post"
				port="8080"
				username="#roleName#"
				password="#rolePass#"
				result="httpResponse">
			<cfhttpparam type="header" name="content-type" value="text/xml">
			<cfhttpparam type="header" name="SOAPAction" value="">
			<cfhttpparam type="header" name="content-length" value="#len(soapBody)#">
			<cfhttpparam type="header" name="charset" value="utf-8">
			<cfhttpparam type="xml" value="#Trim(soapBody)#">
		</cfhttp>
		<cfoutput>#httpResponse.fileContent#<br></cfoutput>
		<cfscript>
			soapResponse = xmlParse( httpResponse.fileContent );
			res = soapResponse.XmlRoot["env:body"].XmlChildren[1].XmlChildren[1];

			saleQuery = QueryNew("saleCode, itemId, status, statusCode, productId, productTitle, price, cargoPayment, cargoCode, amount, endDate,
								  buyerUsername, buyerName, buyerSurname, buyerPhone, buyerMobile, buyerAddress, buyerDistrict, buyerCity, buyerZCode, thumbImageLink, lastActionDate,
								  invoiceFullname, invoiceAddress, invoiceDistrict, invoiceCitycode, invoicePhone, invoiceCompany, invoiceTCCert");
			WriteOutput('sales length -----> ' & arraylen(res.sales.xmlchildren));
			if(arraylen(res.sales.xmlchildren) gt 0){
				queryAddRow(saleQuery, arraylen(res.sales.xmlchildren));

				for (i = 1; i lte arraylen(res.sales.xmlchildren); i++){
					sale = res.sales.xmlchildren[i];
					QuerySetCell(saleQuery, "saleCode", isDefined('sale.saleCode.xmlText') ? sale.saleCode.xmlText : '-1', i);
					QuerySetCell(saleQuery, "itemId", isDefined('sale.itemId.xmlText') ? sale.itemId.xmlText : '-1', i);
					QuerySetCell(saleQuery, "status", isDefined('sale.status.xmlText') ? sale.status.xmlText : '-1', i);
					QuerySetCell(saleQuery, "statusCode", isDefined('sale.statusCode.xmlText') ? sale.statusCode.xmlText : '-1', i);
					QuerySetCell(saleQuery, "productId", isDefined('sale.productId.xmlText') ? sale.productId.xmlText : '-1', i);
					QuerySetCell(saleQuery, "productTitle", isDefined('sale.productTitle.xmlText') ? sale.productTitle.xmlText : '-1', i);
					QuerySetCell(saleQuery, "price", isDefined('sale.price.xmlText') ? sale.price.xmlText : '-1', i);
					QuerySetCell(saleQuery, "cargoPayment", isDefined('sale.cargoPayment.xmlText') ? sale.cargoPayment.xmlText : '-1', i);
					QuerySetCell(saleQuery, "cargoCode", isDefined('sale.cargoCode.xmlText') ? sale.cargoCode.xmlText : '-1', i);
					QuerySetCell(saleQuery, "amount", isDefined('sale.amount.xmlText') ? sale.amount.xmlText : '-1', i);
					QuerySetCell(saleQuery, "endDate", isDefined('sale.endDate.xmlText') ? sale.endDate.xmlText : '-1', i);
					QuerySetCell(saleQuery, "buyerUsername", isDefined('sale.buyerInfo.username.xmlText') ? sale.buyerInfo.username.xmlText : '-1', i);
					QuerySetCell(saleQuery, "buyerName", isDefined('sale.buyerInfo.name.xmlText') ? sale.buyerInfo.name.xmlText : '-1', i);
					QuerySetCell(saleQuery, "buyerSurname", isDefined('sale.buyerInfo.surname.xmlText') ? sale.buyerInfo.surname.xmlText : '-1', i);
					QuerySetCell(saleQuery, "buyerPhone", isDefined('sale.buyerInfo.phone.xmlText') ? sale.buyerInfo.phone.xmlText : '-1', i);
					QuerySetCell(saleQuery, "buyerMobile", isDefined('sale.buyerInfo.mobilePhone.xmlText') ? sale.buyerInfo.mobilePhone.xmlText : '-1', i);
					QuerySetCell(saleQuery, "buyerAddress", isDefined('sale.buyerInfo.address.xmlText') ? sale.buyerInfo.address.xmlText : '-1', i);
					QuerySetCell(saleQuery, "buyerDistrict", isDefined('sale.buyerInfo.district.xmlText') ? sale.buyerInfo.district.xmlText : '-1', i);
					QuerySetCell(saleQuery, "buyerCity", isDefined('sale.buyerInfo.city.xmlText') ? sale.buyerInfo.city.xmlText : '-1', i);
					QuerySetCell(saleQuery, "buyerZCode", isDefined('sale.buyerInfo.zipCode.xmlText') ? sale.buyerInfo.zipCode.xmlText : '-1', i);
					QuerySetCell(saleQuery, "thumbImageLink", isDefined('sale.thumbImageLink.xmlText') ? sale.thumbImageLink.xmlText : '-1', i);
					QuerySetCell(saleQuery, "lastActionDate", isDefined('sale.lastActionDate.xmlText') ? sale.lastActionDate.xmlText : '-1', i);
					QuerySetCell(saleQuery, "invoiceFullname", isDefined('sale.invoiceInfo.fullname.xmlText') ? sale.invoiceInfo.fullname.xmlText : '-1', i);
					QuerySetCell(saleQuery, "invoiceAddress", isDefined('sale.invoiceInfo.address.xmlText') ? sale.invoiceInfo.address.xmlText : '-1', i);
					QuerySetCell(saleQuery, "invoiceDistrict", isDefined('sale.invoiceInfo.district.xmlText') ? sale.invoiceInfo.district.xmlText : '-1', i);
					QuerySetCell(saleQuery, "invoiceCitycode", isDefined('sale.invoiceInfo.cityCode.xmlText') ? sale.invoiceInfo.cityCode.xmlText : '-1', i);
					QuerySetCell(saleQuery, "invoicePhone", isDefined('sale.invoiceInfo.phoneNumber.xmlText') ? sale.invoiceInfo.phoneNumber.xmlText : '-1', i);
					QuerySetCell(saleQuery, "invoiceCompany", isDefined('sale.invoiceInfo.companyTitle.xmlText') ? sale.invoiceInfo.companyTitle.xmlText : '-1', i);
					QuerySetCell(saleQuery, "invoiceTCCert", isDefined('sale.invoiceInfo.tcCertificate.xmlText') ? sale.invoiceInfo.tcCertificate.xmlText : '-1', i);
				}
			}

		</cfscript>
		<cfoutput query="saleQuery" >
			<cfquery name="SET_GENERAL_PAPERS" datasource="#dsn#">
				UPDATE
					#dsn#_1.GENERAL_PAPERS
				SET
					ORDER_NUMBER = ORDER_NUMBER+1
				WHERE
					PAPER_TYPE = 0 AND
					ZONE_TYPE = 1
			</cfquery>
			<cfquery name="GET_GENERAL_PAPERS"  datasource="#dsn#">
				SELECT
					ORDER_NO,
					ORDER_NUMBER
				FROM
					#dsn#_1.GENERAL_PAPERS
				WHERE
					PAPER_TYPE = 0 AND
					ZONE_TYPE = 1
			</cfquery>

			<cfsavecontent variable="cargoSoap">
				<cfoutput>
					<?xml version="1.0" encoding="utf-8"?>
					<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:car="http://cargo.individual.ws.listingapi.gg.com">
						<soapenv:Header/>
						<soapenv:Body>
							<car:sendCargoInformation>
								<apiKey>#APIKey#</apiKey>
								<sign>#ggSign#</sign>
								<time>#SystemTime#</time>
								<saleCode>#saleCode#</saleCode>
								<cargoPostCode>#cargoCode#</cargoPostCode>
								<cargoCompany>Aras</cargoCompany>
								<cargoBranch>Kağıthane</cargoBranch>
								<followUpUrl>www.atombilisim.com.tr</followUpUrl>
								<userType>S</userType>
								<lang>tr</lang>
							</car:sendCargoInformation>
						</soapenv:Body>
					</soapenv:Envelope>
				</cfoutput>
			</cfsavecontent>
			<cfhttp url="http://dev.gittigidiyor.com:8080/listingapi/ws/IndividualCargoService?wsdl"
					method="post"
					port="8080"
					username="#roleName#"
					password="#rolePass#"
					result="cargoResponse">
				<cfhttpparam type="header" name="content-type" value="text/xml">
				<cfhttpparam type="header" name="SOAPAction" value="">
				<cfhttpparam type="header" name="content-length" value="#len(cargoSoap)#">
				<cfhttpparam type="header" name="charset" value="utf-8">
				<cfhttpparam type="xml" value="#Trim(cargoSoap)#">
			</cfhttp>
			<cfoutput>#cargoResponse.fileContent#<br></cfoutput>

			<cfset cargo_no = cargoCode>
			<cfset cargo_company = 'Aras'>

			<cfset w_evrak_id = itemId>
			<cfset uye_kod = invoiceTCCert>
			<cfset w_evrak_no = saleCode>
			<cfset w_tarih = Year(now())>

			<cfset uye_ad = invoiceCompany>
			<cfset uye_partner_ad = buyerName & ' ' & buyerSurname>
			<cfset uye_vergi_no = '-1'>
			<cfset uye_vergi_dairesi = '-1'>
			<cfset uye_adres = invoiceAddress & ' ' & invoiceDistrict>
			<cfset uye_tel = buyerPhone>
			<cfset uye_email = '-1'>
			<cfset uye_tck = invoiceTCCert>
			<cfset SevkAdr1 = buyerAddress>
			<cfset SevkAdr2 = buyerDistrict>
			<cfset SevkPosta = buyerZCode>
			<cfset SevkSehir = buyerCity>

			<cfquery name="get_rows" datasource="#dsn#">
				SELECT
					#amount# AS MIKTAR,
					#price / amount# AS BIRIM_FIYAT,
					P_DIS.TAX AS KDV_ORN,
					S.STOCK_ID,
					S.PRODUCT_CODE AS STOK_KOD
				FROM
					#dsn#_1.STOCKS S,
					#dsn#_product.PRODUCT P_DIS
				WHERE
					P_DIS.PRODUCT_ID = S.PRODUCT_ID AND
					P_DIS.PRODUCT_ID = #itemId#
			</cfquery>

			<cfquery name="get_member" datasource="#dsn#">
				SELECT MANAGER_PARTNER_ID,COMPANY_ID,FULLNAME,COMPANY_EMAIL FROM COMPANY WHERE OZEL_KOD = '#uye_kod#'
			</cfquery>
			<cfif not get_member.recordcount>
				<cfinclude template="companyimport.cfm">
			</cfif>
			<cfquery name="get_member" datasource="#dsn#">
				SELECT MANAGER_PARTNER_ID,COMPANY_ID,FULLNAME FROM COMPANY WHERE OZEL_KOD = '#uye_kod#'
			</cfquery>
			<cfinclude template="import_order_parameters.cfm">
			**** #saleCode# -- #productId# -- #productTitle# -- #price# -- #amount# -- #buyerUsername# -- #buyerName# #buyerSurname# -- #buyerAddress# -- #invoiceFullname# ****
		</cfoutput>

	</cfif>
</cfloop>