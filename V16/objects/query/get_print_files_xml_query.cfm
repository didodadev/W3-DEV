<!--- 	Design Paper Queryleri
		Types;
			10	Fatura
			30	Irsaliye
			31	Stok Fisi
			70	Satis Teklifi
			73	Satis Siparisi
			90	Satinalma Teklifi
			91	Satinalma Siparisi
 --->

<cfset ShipMemberAddress = "">
<cfset ReferenceNumber = "">
<cfset DocumentDate = "">
<cfset DocumentNumber = "">
<cfset RelatedOrderNumber = "">
<cfset RelatedShipNumber = "">
<cfset RelatedShipDate = "">
<cfset RelatedShipAddress = "">
<cfset RecordDate = "">
<cfset RecordEmp = "">
<cfset DueDate = "">

<cfset ShipMethod = "">
<cfset PaymentMethod = "">
<cfset ProjectName = "">
<cfset ReferenceNumber = "">

<cfsavecontent variable="companylogo"><cfinclude template="/objects/display/view_company_logo.cfm"></cfsavecontent>

<cfif isdefined("PrintDesignType") and len(PrintDesignType)>
	<!--- Bazi modullerde iid,id, yada action_id geliyor, standart action_id yapiyorum --->
	<cfif isdefined("attributes.id")><cfset attributes.action_id = attributes.id></cfif>
	<cfif isdefined("attributes.iid")><cfset attributes.action_id = attributes.iid></cfif>

	<cfif PrintDesignType eq 10>
		<!--- Fatura --->
		<cfquery name="GetMainInfo" datasource="#dsn2#">
			SELECT
				COMPANY_ID CompanyId,
				CONSUMER_ID ConsumerId,
				SHIP_METHOD ShipMethodId,
				PAY_METHOD PaymentMethodId,
				PROJECT_ID ProjectId,
				SHIP_ADDRESS ShipMemberAddress,
				REF_NO ReferenceNumber,
				INVOICE_NUMBER DocumentNumber,
				INVOICE_DATE DocumentDate,
				DUE_DATE DueDate,
				RECORD_DATE RecordDate,
				RECORD_EMP RecordEmp,
				
				GROSSTOTAL SubTotal,
				SA_DISCOUNT SaDiscount,
				'0' DiscountTotal,
				TAXTOTAL TaxTotal,
				OTV_TOTAL OtvTotal,
				NETTOTAL NetTotal,
				OTHER_MONEY_VALUE OtherMoneyValue,
				CASE WHEN OTHER_MONEY IS NULL THEN '#session.ep.money2#' ELSE OTHER_MONEY END AS OtherMoney,
				DELIVER_EMP DELIVER_EMP,
				NOTE Note
			FROM
				INVOICE
			WHERE
				INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>
		<cfquery name="GetRowInfo" datasource="#dsn2#">
			SELECT
				S.STOCK_CODE StockCode,
				(SELECT TOP 1 SHELF_CODE FROM #dsn3_alias#.PRODUCT_PLACE WHERE PRODUCT_ID =IROW.PRODUCT_ID) UrunRafKodu,
				(SELECT PRODUCT_CODE_2 FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = IROW.PRODUCT_ID) UrunOzelKod,
				S.BARCOD Barcod,
				NAME_PRODUCT NameProduct,
				PRODUCT_NAME2 ProductName2,
				AMOUNT Amount,
				AMOUNT2 Amount2,
				UNIT Unit,
				UNIT2 Unit2,
				PRICE RowPrice,
				OTHER_MONEY RowOtherMoney,
				PRICE_OTHER RowPriceOther,
				DISCOUNT1 RowDiscount1,
				DISCOUNT2 RowDiscount2,
				DISCOUNT3 RowDiscount3,
				DISCOUNT4 RowDiscount4,
				DISCOUNT5 RowDiscount5,
				DISCOUNT6 RowDiscount6,
				DISCOUNT7 RowDiscount7,
				DISCOUNT8 RowDiscount8,
				DISCOUNT9 RowDiscount9,
				DISCOUNT10 RowDiscount10,
				DISCOUNTTOTAL RowDiscounttotal,
				IROW.TAX RowTax,
				TAXTOTAL RowTaxtotal,
				OTV_ORAN RowOtvOran,
				OTVTOTAL RowOtvtotal,
				(NETTOTAL+DISCOUNTTOTAL) RowTotal,
				NETTOTAL RowNettotal,
				GROSSTOTAL RowGrosstotal,
				MARGIN RowMargin,
				COST_PRICE RowCostPrice,
				EXTRA_PRICE RowExtraPrice,
				LIST_PRICE RowListPrice,
				(SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = KARMA_PRODUCT_ID) RowKarmaKoliAdi,
				DELIVER_DATE RowDeliverDate,
				'0' RowDevirDipToplam,
				'0' RowDevredenToplam
			FROM
				INVOICE_ROW IROW,
				#dsn3_alias#.STOCKS S
			WHERE
				S.STOCK_ID = IROW.STOCK_ID AND
				IROW.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
			ORDER BY
				IROW.INVOICE_ROW_ID
		</cfquery>
		
		<!--- Iliskili Irsaliye --->
		<cfquery name="GetRelatedShipInfo" datasource="#dsn2#">
			SELECT 
				S.SHIP_DATE,
				S.SHIP_NUMBER,
				S.ADDRESS
			FROM 
				INVOICE_SHIPS ISH,
				SHIP S
			WHERE
				S.SHIP_ID = ISH.SHIP_ID AND
				ISH.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
				SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		</cfquery>
		<cfset RelatedShipNumber = GetRelatedShipInfo.ship_number>
		<cfset RelatedShipAddress = GetRelatedShipInfo.address>
		<cfset RelatedShipDate = DateFormat(GetRelatedShipInfo.Ship_Date,dateformat_style)>
		
		<!--- Iliskili Siparis --->
		<cfquery name="GetRelatedOrderInfo" datasource="#dsn3#">
			SELECT
				(SELECT ORDER_NUMBER FROM ORDERS WHERE ORDER_ID = OI.ORDER_ID) ORDER_NUMBER
			FROM 
				ORDERS_INVOICE OI
			WHERE 
				OI.INVOICE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
				OI.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
		</cfquery>
		<cfset RelatedOrderNumber = GetRelatedOrderInfo.order_number>

	<cfelseif PrintDesignType eq 30>
		<!--- Irsaliye --->
		<cfquery name="GetMainInfo" datasource="#dsn2#">
			SELECT
				COMPANY_ID CompanyId,
				CONSUMER_ID ConsumerId,
				SHIP_METHOD ShipMethodId,
				PAYMETHOD_ID PaymentMethodId,
				PROJECT_ID ProjectId,
				ADDRESS ShipMemberAddress,
				REF_NO ReferenceNumber,
				SHIP_NUMBER DocumentNumber,
				SHIP_DATE DocumentDate,
				DUE_DATE DueDate,
				RECORD_DATE RecordDate,
				RECORD_EMP RecordEmp,
				
				GROSSTOTAL SubTotal,
				SA_DISCOUNT SaDiscount,
				'0' DiscountTotal,
				TAXTOTAL TaxTotal,
				OTV_TOTAL OtvTotal,
				NETTOTAL NetTotal,
				OTHER_MONEY_VALUE OtherMoneyValue,
				CASE WHEN OTHER_MONEY IS NULL THEN '#session.ep.money2#' ELSE OTHER_MONEY END AS OtherMoney,
				DELIVER_EMP DELIVER_EMP,
				SHIP_DETAIL Note
			FROM
				SHIP
			WHERE
				SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>
		<cfquery name="GetRowInfo" datasource="#dsn2#">
			SELECT
				S.STOCK_CODE StockCode,
				(SELECT TOP 1 SHELF_CODE FROM #dsn3_alias#.PRODUCT_PLACE WHERE PRODUCT_ID =SROW.PRODUCT_ID) UrunRafKodu,
				(SELECT PRODUCT_CODE_2 FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = SROW.PRODUCT_ID) UrunOzelKod,
				S.BARCOD Barcod,
				SROW.NAME_PRODUCT NameProduct,
				PRODUCT_NAME2 ProductName2,
				AMOUNT Amount,
				AMOUNT2 Amount2,
				UNIT Unit,
				UNIT2 Unit2,
				PRICE RowPrice,
				OTHER_MONEY RowOtherMoney,
				PRICE_OTHER RowPriceOther,
				DISCOUNT RowDiscount1,
				DISCOUNT2 RowDiscount2,
				DISCOUNT3 RowDiscount3,
				DISCOUNT4 RowDiscount4,
				DISCOUNT5 RowDiscount5,
				DISCOUNT6 RowDiscount6,
				DISCOUNT7 RowDiscount7,
				DISCOUNT8 RowDiscount8,
				DISCOUNT9 RowDiscount9,
				DISCOUNT10 RowDiscount10,
				DISCOUNTTOTAL RowDiscounttotal,
				SROW.TAX RowTax,
				TAXTOTAL RowTaxtotal,
				OTV_ORAN RowOtvOran,
				OTVTOTAL RowOtvtotal,
				(NETTOTAL+DISCOUNTTOTAL) RowTotal,
				NETTOTAL RowNettotal,
				GROSSTOTAL RowGrosstotal,
				MARGIN RowMargin,
				COST_PRICE RowCostPrice,
				EXTRA_PRICE RowExtraPrice,
				LIST_PRICE RowListPrice,
				(SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = KARMA_PRODUCT_ID) RowKarmaKoliAdi,
				DELIVER_DATE RowDeliverDate,
				'0' RowDevirDipToplam,
				'0' RowDevredenToplam
			FROM
				SHIP_ROW SROW,
				#dsn3_alias#.STOCKS S
			WHERE
				S.STOCK_ID = SROW.STOCK_ID AND
				SROW.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
			ORDER BY
				SROW.SHIP_ROW_ID
		</cfquery>
	<cfelseif (PrintDesignType eq 73) or (PrintDesignType eq 91)>
		<!--- Satis Siparisi & Satinalma Siparisi --->
		<cfquery name="GetMainInfo" datasource="#dsn3#">
			SELECT
				COMPANY_ID CompanyId,
				CONSUMER_ID ConsumerId,
				SHIP_METHOD ShipMethodId,
				PAYMETHOD PaymentMethodId,
				PROJECT_ID ProjectId,
				SHIP_ADDRESS ShipMemberAddress,
				REF_NO ReferenceNumber,
				ORDER_NUMBER DocumentNumber,
				ORDER_DATE DocumentDate,
				DUE_DATE DueDate,
				RECORD_DATE RecordDate,
				RECORD_EMP RecordEmp,
				
				GROSSTOTAL SubTotal,
				SA_DISCOUNT SaDiscount,
				'0' DiscountTotal,
				TAXTOTAL TaxTotal,
				OTV_TOTAL OtvTotal,
				NETTOTAL NetTotal,
				OTHER_MONEY_VALUE OtherMoneyValue,
				CASE WHEN OTHER_MONEY IS NULL THEN '#session.ep.money2#' ELSE OTHER_MONEY END AS OtherMoney,
				ORDER_EMPLOYEE_ID DeliverEmp,
				ORDER_DETAIL Note
			FROM
				ORDERS
			WHERE
				ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>
		<cfquery name="GetRowInfo" datasource="#dsn3#">
			SELECT
				S.STOCK_CODE StockCode,
				(SELECT TOP 1 SHELF_CODE FROM PRODUCT_PLACE WHERE PRODUCT_ID =OROW.PRODUCT_ID) UrunRafKodu,
				(SELECT PRODUCT_CODE_2 FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OROW.PRODUCT_ID) UrunOzelKod,
				S.BARCOD Barcod,
				OROW.PRODUCT_NAME NameProduct,
				PRODUCT_NAME2 ProductName2,
				QUANTITY Amount,
				'0' Amount2,
				UNIT Unit,
				UNIT2 Unit2,
				PRICE RowPrice,
				OTHER_MONEY RowOtherMoney,
				PRICE_OTHER RowPriceOther,
				DISCOUNT_1 RowDiscount1,
				DISCOUNT_2 RowDiscount2,
				DISCOUNT_3 RowDiscount3,
				DISCOUNT_4 RowDiscount4,
				DISCOUNT_5 RowDiscount5,
				DISCOUNT_6 RowDiscount6,
				DISCOUNT_7 RowDiscount7,
				DISCOUNT_8 RowDiscount8,
				DISCOUNT_9 RowDiscount9,
				DISCOUNT_10 RowDiscount10,
				ISNULL(ROW_DISCOUNTTOTAL,0) RowDiscounttotal,
				OROW.TAX RowTax,
				(OROW.TAX*PRICE) RowTaxtotal,
				OTV_ORAN RowOtvOran,
				OTVTOTAL RowOtvtotal,
				(NETTOTAL+ISNULL(ROW_DISCOUNTTOTAL,0)) RowTotal,
				NETTOTAL RowNettotal,
				((PRICE + (PRICE*OROW.TAX/100)+(PRICE*OTV_ORAN/100))*QUANTITY) RowGrosstotal,
				MARJ RowMargin,
				COST_PRICE RowCostPrice,
				EXTRA_PRICE RowExtraPrice,
				LIST_PRICE RowListPrice,
				(SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = KARMA_PRODUCT_ID) RowKarmaKoliAdi,
				DELIVER_DATE RowDeliverDate,
				'0' RowDevirDipToplam,
				'0' RowDevredenToplam
			FROM
				ORDER_ROW OROW,
				STOCKS S
			WHERE
				S.STOCK_ID = OROW.STOCK_ID AND
				OROW.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
			ORDER BY
				OROW.ORDER_ROW_ID
		</cfquery>
	<cfelseif (PrintDesignType eq 70) or (PrintDesignType eq 90)>
		<!--- Satis Teklifi & Satinalma Teklifi --->
		<cfquery name="GetMainInfo" datasource="#dsn3#">
			SELECT
				CASE WHEN PURCHASE_SALES = 1 AND OFFER_ZONE = 0 THEN COMPANY_ID ELSE '' END CompanyId,
				CASE WHEN PURCHASE_SALES = 1 AND OFFER_ZONE = 0 THEN CONSUMER_ID ELSE '' END ConsumerId,
				SHIP_METHOD ShipMethodId,
				PAYMETHOD PaymentMethodId,
				PROJECT_ID ProjectId,
				SHIP_ADDRESS ShipMemberAddress,
				REF_NO ReferenceNumber,
				OFFER_NUMBER DocumentNumber,
				OFFER_DATE DocumentDate,
				DUE_DATE DueDate,
				RECORD_DATE RecordDate,
				RECORD_MEMBER RecordEmp,
				'0' SubTotal,
				SA_DISCOUNT SaDiscount,
				'0' DiscountTotal,
				'0' TaxTotal,
				OTV_TOTAL OtvTotal,
				ISNULL(NETTOTAL,PRICE) NetTotal,
				OTHER_MONEY_VALUE OtherMoneyValue,
				CASE WHEN OTHER_MONEY IS NULL THEN '#session.ep.money2#' ELSE OTHER_MONEY END AS OtherMoney,
				SALES_EMP_ID DeliverEmp,
				OFFER_DETAIL Note
			FROM
				OFFER
			WHERE
				OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>
		<cfquery name="GetRowInfo" datasource="#dsn3#">
			SELECT
				S.STOCK_CODE StockCode,
				(SELECT TOP 1 SHELF_CODE FROM PRODUCT_PLACE WHERE PRODUCT_ID =OROW.PRODUCT_ID) UrunRafKodu,
				(SELECT PRODUCT_CODE_2 FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = OROW.PRODUCT_ID) UrunOzelKod,
				S.BARCOD Barcod,
				OROW.PRODUCT_NAME NameProduct,
				PRODUCT_NAME2 ProductName2,
				QUANTITY Amount,
				AMOUNT2 Amount2,
				UNIT Unit,
				UNIT2 Unit2,
				PRICE RowPrice,
				OTHER_MONEY RowOtherMoney,
				PRICE_OTHER RowPriceOther,
				DISCOUNT_1 RowDiscount1,
				DISCOUNT_2 RowDiscount2,
				DISCOUNT_3 RowDiscount3,
				DISCOUNT_4 RowDiscount4,
				DISCOUNT_5 RowDiscount5,
				DISCOUNT_6 RowDiscount6,
				DISCOUNT_7 RowDiscount7,
				DISCOUNT_8 RowDiscount8,
				DISCOUNT_9 RowDiscount9,
				DISCOUNT_10 RowDiscount10,
				'000000' RowDiscounttotal,
				OROW.TAX RowTax,
				(QUANTITY*PRICE*OROW.TAX/100) RowTaxtotal,
				OTV_ORAN RowOtvOran,
				OTVTOTAL RowOtvtotal,
				'0' RowTotal,
				'0' RowNettotal,
				'0' RowGrosstotal,
				MARJ RowMargin,
				'0' RowCostPrice,
				EXTRA_PRICE RowExtraPrice,
				LIST_PRICE RowListPrice,
				(SELECT PRODUCT_NAME FROM #dsn1_alias#.PRODUCT WHERE PRODUCT_ID = KARMA_PRODUCT_ID) RowKarmaKoliAdi,
				DELIVER_DATE RowDeliverDate,
				'0' RowDevirDipToplam,
				'0' RowDevredenToplam
			FROM
				OFFER_ROW OROW,
				STOCKS S
			WHERE
				S.STOCK_ID = OROW.STOCK_ID AND
				OROW.OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
			ORDER BY
				OROW.OFFER_ROW_ID
		</cfquery>
	</cfif>

	<cfset CompanyId = GetMainInfo.CompanyId>
	<cfset DiscountTotal = GetMainInfo.DiscountTotal>	
	<cfset SaDiscount = GetMainInfo.SaDiscount>	
	<cfset SubTotal = GetMainInfo.SubTotal>	
	<cfset OtvTotal = GetMainInfo.OtvTotal>	
	<cfset TaxTotal = GetMainInfo.TaxTotal>
	<cftry>
		<cfset DeliverEmp = GetMainInfo.DELIVER_EMP><!--- Teklif'te yok --->
    <cfcatch></cfcatch>
    </cftry>
	<cfset NetTotal = GetMainInfo.NetTotal>
	<cfset NetTotal2 = GetMainInfo.NetTotal>		
	<cfset OtherMoneyValue = GetMainInfo.OtherMoneyValue>
	<cfset OtherMoney = GetMainInfo.OtherMoney>	
	<cfset RowDevredenToplam = 0>
	<cfsavecontent variable="kontrol"><cf_n2txt number=#NetTotal#></cfsavecontent>
	<cfset TotalWithWrite = kontrol>
	<cfsavecontent variable="kontrol"><cf_n2txt number=#NetTotal#></cfsavecontent>
	<cfset TotalWithWriteEng = kontrol>
	
	<cfset ShipMemberAddress = GetMainInfo.ShipMemberAddress>
	<cfset ReferenceNumber = GetMainInfo.ReferenceNumber>
	<cfset DocumentNumber = GetMainInfo.DocumentNumber>
	<cfset DocumentDate = DateFormat(GetMainInfo.DocumentDate,dateformat_style)>
	<cfset RecordDate = DateFormat(GetMainInfo.RecordDate,dateformat_style)>
	<cfset DueDate = DateFormat(GetMainInfo.DueDate,dateformat_style)>
	<cfset RecordEmp = get_emp_info(GetMainInfo.RecordEmp,0,0)>
	
	<!--- Sevk Yontemi --->
	<cfif len(GetMainInfo.ShipMethodId)>
		<cfquery name="GetShipMethodName" datasource="#dsn#">
			SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetMainInfo.ShipMethodId#">
		</cfquery>
		<cfset ShipMethod = GetShipMethodName.Ship_Method>
	</cfif>
	<!--- Odeme Yontemi --->
	<cfif len(GetMainInfo.PaymentMethodId)>
		<cfquery name="GetPaymentMethodName" datasource="#dsn#">
			SELECT PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetMainInfo.PaymentMethodId#">
		</cfquery>
		<cfset PaymentMethod = GetPaymentMethodName.PayMethod>
	</cfif>
	<!--- Proje --->
	<cfif len(GetMainInfo.ProjectId)>
		<cfquery name="GetProjectName" datasource="#dsn#">
			SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetMainInfo.ProjectId#">
		</cfquery>
		<cfset ProjectName = GetProjectName.Project_Head>
	</cfif>

	<!--- Uye Bilgileri --->
	<cfset MemberCode = "">
	<cfset MemberCompanyName = "">
	<cfset MemberPartnerName = "">
	<cfset MemberAddress ="">
	<cfset MemberCountry = "">
	<cfset MemberCity = "">
	<cfset MemberCounty = "">
	<cfset MemberMainDistrict = "">
	<cfset MemberPostcode = "">
	<cfset MemberTaxnumber = "">
	<cfset MemberTaxoffice = "">
	<cfset MemberTelcode = "">
	<cfset MemberTelnumber = "">
	<cfset MemberRemainder = "">
	<cfset MemberIms = "">
	<cfif len(GetMainInfo.CompanyId)>
		<cfquery name="GetMemberInfo" datasource="#dsn#">
			SELECT
				MEMBER_CODE MemberCode,
				FULLNAME MemberCompanyName,
				(SELECT COMPANY_PARTNER_NAME + ' ' +  COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = MANAGER_PARTNER_ID) MemberPartnerName,
				COMPANY_ADDRESS MemberAddress,
				COUNTRY MemberCountry,
				CITY MemberCity,
				COUNTY MemberCounty,
				SEMT MemberMainDistrict,
				COMPANY_POSTCODE MemberPostcode,
				TAXNO MemberTaxnumber,
				TAXOFFICE MemberTaxoffice,
				COMPANY_TELCODE MemberTelcode,
				COMPANY_TEL1 MemberTelnumber,
				IMS_CODE_ID MemberIms
			FROM
				COMPANY
			WHERE 
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetMainInfo.CompanyId#">
		</cfquery>
		<cfquery name="GetMemberRemainder" datasource="#dsn2#">
			SELECT BAKIYE3 FROM COMPANY_REMAINDER_MONEY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetMainInfo.CompanyId#"> AND OTHER_MONEY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetMainInfo.OtherMoney#">
		</cfquery>
	<cfelseif len(GetMainInfo.ConsumerId)>
		<cfquery name="GetMemberInfo" datasource="#dsn#">
			SELECT
				MEMBER_CODE MemberCode,
				'' MemberCompanyName,
				CONSUMER_NAME + ' ' + CONSUMER_SURNAME MemberPartnerName,
				TAX_ADRESS MemberAddress,
				TAX_COUNTRY_ID MemberCountry,
				TAX_CITY_ID MemberCity,
				TAX_COUNTY_ID MemberCounty,
				TAX_SEMT MemberMainDistrict,
				TAX_POSTCODE MemberPostcode,
				TAX_NO MemberTaxnumber,
				TAX_OFFICE MemberTaxoffice,
				CONSUMER_WORKTELCODE MemberTelcode,
				CONSUMER_WORKTEL MemberTelnumber,
				IMS_CODE_ID MemberIms
			FROM 
				CONSUMER
			WHERE 
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetMainInfo.ConsumerId#">
		</cfquery>
		<cfquery name="GetMemberRemainder" datasource="#dsn2#">
			SELECT BAKIYE3 FROM CONSUMER_REMAINDER_MONEY WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetMainInfo.ConsumerId#"> AND OTHER_MONEY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#GetMainInfo.OtherMoney#">
		</cfquery>
	</cfif>
	<cfif isdefined("GetMemberInfo") and GetMemberInfo.recordcount>
		<cfset MemberCode = GetMemberInfo.MemberCode>
		<cfset MemberCompanyName = GetMemberInfo.MemberCompanyName>
		<cfset MemberPartnerName = GetMemberInfo.MemberPartnerName>
		<cfset MemberAddress =GetMemberInfo.MemberAddress>
		<cfset MemberMainDistrict = GetMemberInfo.MemberMainDistrict>
		<cfif len(GetMemberInfo.MemberCountry)>
			<cfquery name="GetCountry" datasource="#dsn#">
				SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetMemberInfo.MemberCountry#">
			</cfquery>
			<cfset MemberCountry = ucase(GetCountry.Country_Name)>
		</cfif>
		<cfif len(GetMemberInfo.MemberCity)>
			<cfquery name="GetCity" datasource="#dsn#">
				SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetMemberInfo.MemberCity#">
			</cfquery>
			<cfset MemberCity = ucase(GetCity.City_Name)>
		</cfif>
		<cfif len(GetMemberInfo.MemberCounty)>
			<cfquery name="GetCounty" datasource="#dsn#">
				SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetMemberInfo.MemberCounty#">
			</cfquery>
			<cfset MemberCounty = GetCounty.County_Name>
		</cfif>
		<cfif len(GetMemberInfo.MemberIms)>
			<cfquery name="GetImsCode" datasource="#dsn#">
				SELECT IMS_CODE_NAME FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetMemberInfo.MemberIms#">
			</cfquery>
			<cfset MemberIms = GetImsCode.Ims_Code_Name>
		</cfif>
		<cfset MemberPostcode = GetMemberInfo.MemberPostcode>
		<cfset MemberTaxnumber = GetMemberInfo.MemberTaxnumber>
		<cfset MemberTaxoffice = GetMemberInfo.MemberTaxoffice>
		<cfset MemberTelcode = GetMemberInfo.MemberTelcode>
		<cfset MemberTelnumber = GetMemberInfo.MemberTelnumber>
		<cfset MemberRemainder = TLFormat(GetMemberRemainder.Bakiye3)>
	</cfif>
	<!--- //Uye bilgileri --->
</cfif>
