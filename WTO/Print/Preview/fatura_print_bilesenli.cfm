<!--- Faturayi Urunun spec ve urun agacindaki tüm bilesenleri ile birlikte basan print --->
<cfquery name="Get_Invoice" datasource="#dsn2#">
	SELECT * FROM INVOICE WHERE <cfif not isDefined("attributes.ID")>INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.IID#"><cfelse>INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#"></cfif>
</cfquery>
<cfquery name="Get_Sale_Order" datasource="#dsn2#">
	SELECT 
		O.ORDER_NUMBER,
		O.ORDER_ID
	FROM 
		INVOICE I,
		INVOICE_SHIPS ISH,
		#dsn3_alias#.ORDERS_SHIP OS,
		#dsn3_alias#.ORDERS O
	WHERE
	  <cfif not isDefined("attributes.id")>
		I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
	  <cfelse>
		I.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	  </cfif>
	  	AND I.INVOICE_ID = ISH.INVOICE_ID
		AND ISH.SHIP_ID = OS.SHIP_ID
		AND O.ORDER_ID = OS.ORDER_ID
		AND OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
</cfquery>
<cfset Member_Code = "">
<cfset Member_Name = "">
<cfset Member_Mail = "">
<cfset Member_TaxOffice = "">
<cfset Member_TaxNo = "">
<cfset Member_TelCode = "">
<cfset Member_Tel = "">
<cfset Member_Fax = "">
<cfset Member_Address = "">
<cfset Member_Semt = "">
<cfset Member_County = "">
<cfset Member_City = "">
<cfset Member_Country = "">
<cfset Member_Tc_No = "">
<cfset comp = "comp">
<cfif isdefined("Get_Invoice.Company_Id") and Len(Get_Invoice.Company_Id)>
	<cfquery name="Get_Member_Info" datasource="#dsn#">
		SELECT
            C.COMPANY_ID MEMBER_ID,
            C.MEMBER_CODE MEMBER_CODE,
            C.FULLNAME MEMBER_NAME,
            C.COMPANY_EMAIL MEMBER_EMAIL,
            C.TAXOFFICE MEMBER_TAXOFFICE,
            C.TAXNO MEMBER_TAXNO,
            C.COMPANY_TELCODE MEMBER_TELCODE,
            C.COMPANY_TEL1 MEMBER_TEL,
            C.COMPANY_FAX MEMBER_FAX,
            C.COMPANY_ADDRESS MEMBER_ADDRESS,
            C.SEMT MEMBER_SEMT,
            C.COUNTY MEMBER_COUNTY,
            C.CITY MEMBER_CITY,
            C.COUNTRY MEMBER_COUNTRY,
            C.IS_PERSON,
            CP.TC_IDENTITY
        FROM
            COMPANY C LEFT JOIN COMPANY_PARTNER CP ON C.COMPANY_ID = CP.COMPANY_ID
        WHERE
            C.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.Company_Id#">
	</cfquery>
<cfelseif isdefined("Get_Invoice.Consumer_Id") and Len(Get_Invoice.Consumer_Id)>
	<cfquery name="Get_Member_Info" datasource="#dsn#">
    	SELECT
        	CONSUMER_ID MEMBER_ID,
            MEMBER_CODE MEMBER_CODE,
            CONSUMER_NAME + ' ' + CONSUMER_SURNAME MEMBER_NAME,
            CONSUMER_EMAIL MEMBER_EMAIL,
            TAX_OFFICE MEMBER_TAXOFFICE,
            TAX_NO MEMBER_TAXNO,
            CONSUMER_WORKTELCODE MEMBER_TELCODE,
            CONSUMER_WORKTEL MEMBER_TEL,
            CONSUMER_FAXCODE + '' + CONSUMER_FAX MEMBER_FAX,
            WORKADDRESS MEMBER_ADDRESS,
            WORKSEMT MEMBER_SEMT,
            WORK_COUNTY_ID MEMBER_COUNTY,
            WORK_CITY_ID MEMBER_CITY,
            WORK_COUNTRY_ID MEMBER_COUNTRY
        FROM
        	CONSUMER
        WHERE
        	CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Invoice.Consumer_Id#">
    </cfquery>
</cfif>
<cfif isdefined("Get_Member_Info") and Get_Member_Info.RecordCount>
	<cfset Member_Code = Get_Member_Info.Member_Code>
    <cfset Member_Name = Get_Member_Info.Member_Name>
    <cfset Member_Mail = Get_Member_Info.Member_Email>
    <cfset Member_TaxOffice = Get_Member_Info.Member_TaxOffice>
    <cfset Member_TaxNo = Get_Member_Info.Member_TaxNo>
    <cfset Member_TelCode = Get_Member_Info.Member_TelCode>
    <cfset Member_Tel = Get_Member_Info.Member_Tel>
    <cfset Member_Fax = Get_Member_Info.Member_Fax>
    <cfset Member_Address = Get_Member_Info.Member_Address>
    <cfset Member_Semt = Get_Member_Info.Member_Semt>
    <cfset Member_Tc_No = Get_Member_Info.Tc_Identity>
	<cfif Len(Get_Member_Info.Member_County)>
		<cfquery name="Get_County_Name" datasource="#dsn#">
			SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_County#">
		</cfquery>
		<cfset Member_County = Get_County_Name.County_Name>
	</cfif>
	<cfif Len(Get_Member_Info.Member_City)>
		<cfquery name="Get_City_Name" datasource="#dsn#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_City#">
		</cfquery>
		<cfset Member_City = Get_City_Name.City_Name>
	</cfif>
	<cfif Len(Get_Member_Info.Member_Country)>
		<cfquery name="Get_Country_Name" datasource="#dsn#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Get_Member_Info.Member_Country#">
		</cfquery>
		<cfset Member_Country = Get_Country_Name.Country_Name>
	</cfif>
</cfif>
<cfquery name="Get_Invoice_Row" datasource="#dsn3#">
	SELECT
		IR.*,
		0 SPECT_ROW_ID,
		S.PROPERTY,
		S.STOCK_CODE,
		S.BARCOD,
		S.MANUFACT_CODE,
		S.IS_INVENTORY,
		S.IS_PRODUCTION,
		'' SPECT_NAME,
		0 SPECT_AMOUNT,
		'' PRODUCT_DETAIL
	FROM
		#dsn2_alias#.INVOICE_ROW IR,
		STOCKS S
	WHERE
	<cfif not isdefined('attributes.id')>
    	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
    <cfelse>
    	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
    </cfif>
    	AND IR.STOCK_ID = S.STOCK_ID
	
	UNION ALL
	
	SELECT
			IR.*,
			SR.SPECT_ROW_ID,
			S.PROPERTY,
			S.STOCK_CODE,
			S.BARCOD,
			S.MANUFACT_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			SR.PRODUCT_NAME ,
			SR.AMOUNT_VALUE SPECT_AMOUNT,
			S.PRODUCT_DETAIL
		FROM
			#dsn2_alias#.INVOICE_ROW IR,
			STOCKS S,
			SPECTS_ROW SR
		WHERE
			SR.SPECT_ID = IR.SPECT_VAR_ID AND 
			<cfif not isdefined('attributes.id')>
            	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
            <cfelse>
            	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
            </cfif>
			AND SR.STOCK_ID = S.STOCK_ID
	UNION ALL
	
	 SELECT
			IR.*,
			1 SPECT_ROW_ID,
			S.PROPERTY,
			S.STOCK_CODE,
			S.BARCOD,
			S.MANUFACT_CODE,
			S.IS_INVENTORY,
			S.IS_PRODUCTION,
			S.PRODUCT_NAME ,
			PT.AMOUNT SPECT_AMOUNT,
			S.PRODUCT_DETAIL
		FROM
			#dsn2_alias#.INVOICE_ROW IR,
			STOCKS S,
			PRODUCT_TREE PT
		WHERE
			PT.STOCK_ID=IR.STOCK_ID
			AND IR.SPECT_VAR_ID IS NULL	AND 
			<cfif not isdefined('attributes.id')>
            	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.iid#">
            <cfelse>
            	IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
            </cfif>
			AND PT.RELATED_ID = S.STOCK_ID
	ORDER BY 
		IR.INVOICE_ROW_ID,
		SPECT_ROW_ID
</cfquery>
<cfset Row_Start = 1>
<cfset Row_End = 23>
<cfif Get_Invoice_Row.RecordCount><cfset Page_Count = Ceiling(Get_Invoice_Row.RecordCount/Row_End)><cfelse><cfset Page_Count = 1></cfif>

<cfset kdv_total = 0>
<cfset sayfa_toplam = 0>
<cfset toplam_indirim = 0>
<cfset satir_indirim_toplami = 0>
<cfloop from="1" to="#Page_Count#" index="i">
    <cfoutput>
        <cf_woc_header>
        <cf_woc_elements>
            <cf_wuxi id="ttt-id" data="&nbsp;" label="" type="cell">
            <cf_wuxi id="member_name" data="#Member_Name# #Get_Invoice.Ship_Address#" label="57519" type="cell">
            <cf_wuxi id="member_tax_office" data="#Member_TaxOffice#" label="58762" type="cell">
            <cfsavecontent variable="tax_no">
                <cfif get_member_info.is_person eq 1 and len(get_member_info.tc_identity) and not len(get_member_info.member_taxno)>
                    #Member_Tc_No#
                <cfelse>
                    #Member_TaxNo#
                </cfif>
            </cfsavecontent>
            <cf_wuxi id="member_tc_no" data="#tax_no#" label="58762" type="cell">
            <cf_wuxi id="member_code" data="#Member_Code#" label="39290" type="cell">
            <cf_wuxi id="invoice_date" data="#dateformat(Get_Invoice.Invoice_Date,'dd.mm.yyyy')#" label="58759" type="cell">
            <cf_wuxi id="invoice_number" data="#Get_Invoice.Invoice_Number#" label="58133" type="cell">
            <cf_wuxi id="order_number" data="&nbsp;#Get_Sale_Order.Order_Number#" label="58211" type="cell"> 
            
        </cf_woc_elements>
        <cf_woc_list id="aaa">
            <thead>
                <tr>
                    <cf_wuxi label="57518" type="cell" is_row="0" id="wuxi_57518"> 
                    <cf_wuxi label="58221" type="cell" is_row="0" id="wuxi_58221"> 
                    <cf_wuxi label="57635" type="cell" is_row="0" id="wuxi_57635"> 
                    <cf_wuxi label="58084" type="cell" is_row="0" id="wuxi_58084"> 
                    <cf_wuxi label="57397" type="cell" is_row="0" id="wuxi_57397">  
                </tr>
            </thead>
            <tbody>
                <tr>
                    <cf_wuxi data="#Get_Invoice_Row.Stock_Code#" type="cell" is_row="0"> 
                    <cf_wuxi data="#Get_Invoice_Row.Name_Product#" type="cell" is_row="0"> 
                    <cf_wuxi data="#Get_Invoice_Row.Amount#" type="cell" is_row="0"> 
                    <cf_wuxi data="#TLFormat(Get_Invoice_Row.Price)#" type="cell" is_row="0"> 
                    <cf_wuxi data="#TLFormat(Get_Invoice_Row.Amount * Get_Invoice_Row.Price)#" type="cell" is_row="0">

                </tr>
            </tbody>
        </cf_woc_list>
    </cfoutput>
<cfset Row_Start = Page_Count + Row_Start>
</cfloop>
<cf_woc_footer>