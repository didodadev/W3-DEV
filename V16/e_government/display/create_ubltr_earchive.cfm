<!---
    File: create_ubltr_earchive.cfm
    Folder: V16\e_government\display
    Author:
    Date:
    Description:
        E-arşiv fatura UBL oluşturma
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
         13.04.21 farklı session değerleriyle kayıt atılacağız için tüm ep değerleri session base e çevirildi
    To Do:

--->

<cfquery name="get_tevkifat" dbtype="query">
	SELECT * FROM GET_INVOICE_KDV WHERE TYPE = 3
</cfquery>

<cfif get_tevkifat.recordcount and len(get_tevkifat.tax_amount)>
	<cfset tevkifat_amount = get_tevkifat.tax_amount>
<cfelse>
	<cfset tevkifat_amount = 0>
</cfif>

<cfset save_folder      = "#upload_folder#e_government#dir_seperator#xslt#dir_seperator#" />
<cfset old_save_folder  = "#index_folder#objects#dir_seperator#xslt#dir_seperator#" />

<cfif get_invoice.is_internet eq 0>
    <cfif len(get_our_company.template_filename_base64)>
        <cfif fileExists('#save_folder##get_our_company.template_filename_base64#')>
            <cfif (get_comp_info.TAX_NO Eq '1234567899' Or get_comp_info.TAX_NO Eq '1800449175') And get_invoice.taxno Eq '2222222222'><!--- BIST için geçici olarak eklendi, ekranlar hazır olduğunda kaldırılacak mcifci 07.12.2019--->
                <cfset preview_invoice_template = 'V16/e_government/display/BIST_earsiv_ingilizce_1.xslt' />
                <cfset temp_earchive_template   = FileRead("#index_folder#e_government#dir_seperator#display#dir_seperator#BIST_earsiv_ingilizce_base64_1.xslt","utf-8") />
            <cfelse>
                <cfset preview_invoice_template = 'documents/e_government/xslt/#get_our_company.template_filename#' />
                <cfset temp_earchive_template   = FileRead("#save_folder##get_our_company.template_filename_base64#","utf-8") />
            </cfif>
        <cfelseif fileExists('#old_save_folder##get_our_company.template_filename_base64#')>
            <cfset preview_invoice_template = 'V16/objects/xslt/#get_our_company.template_filename#' />
            <cfset temp_earchive_template   = FileRead("#old_save_folder##get_our_company.template_filename_base64#","utf-8") />
        <cfelse>
            <cfthrow type="Application" errorcode="FileNotFound" message="Şablon dosyası bulunamadı!" detail="Özel şablon dosyası bulunamadı!" />
        </cfif>
    <cfelse>
        <cfset preview_invoice_template     = 'V16/objects/xslt/earchive_internet_template.xslt' />
        <cfif fileExists('#save_folder#earchive_template_base64_default_#get_our_company.earchive_integration_type#.xslt')>
            <cfset temp_earchive_template   = FileRead("#save_folder#earchive_template_base64_default_#get_our_company.earchive_integration_type#.xslt","utf-8") />
        <cfelse>
            <cfset temp_earchive_template   = FileRead("#old_save_folder#earchive_template_base64_default_#get_our_company.earchive_integration_type#.xslt","utf-8") />
        </cfif>
    </cfif>
<cfelse>
    <cfif len(get_our_company.template_filename_internet_base64)>
        <cfif fileExists('#save_folder##get_our_company.template_filename_internet_base64#')>
            <cfset preview_invoice_template = 'documents/e_government/xslt/#get_our_company.template_filename_internet#' />
            <cfset temp_earchive_template   = FileRead("#save_folder##get_our_company.template_filename_internet_base64#","utf-8") />
        <cfelse>
            <cfset preview_invoice_template = 'V16/objects/xslt/#get_our_company.template_filename_internet#' />
            <cfset temp_earchive_template   = FileRead("#old_save_folder##get_our_company.template_filename_internet_base64#","utf-8") />
        </cfif>
    <cfelse>
        <cfset preview_invoice_template     = 'V16/objects/xslt/earchive_internet_template.xslt' />
        <cfif fileExists('#save_folder#earchive_internet_template_base64_default_#get_our_company.earchive_integration_type#.xslt')>
            <cfset temp_earchive_template   = FileRead("#save_folder#earchive_internet_template_base64_default_#get_our_company.earchive_integration_type#.xslt","utf-8")>
        <cfelse>
            <cfset temp_earchive_template   = FileRead("#old_save_folder#earchive_internet_template_base64_default_#get_our_company.earchive_integration_type#.xslt","utf-8")>
        </cfif>
    </cfif>
</cfif>

<cfif len(get_our_company.ATTACHMENT_FILE)>
    <cfif fileExists('#save_folder##get_our_company.ATTACHMENT_FILE#')>
        <cffile action="readbinary" file="#save_folder##get_our_company.ATTACHMENT_FILE#" variable="attachmentFile" charset="utf-8" />
    <cfelse>
        <cffile action="readbinary" file="#old_save_folder##get_our_company.ATTACHMENT_FILE#" variable="attachmentFile" charset="utf-8" />
    </cfif>
    <cfset attachmentFileBase64 = ToBase64(attachmentFile) />
</cfif>

<cfset paymethod_name = get_invoice.PAYMETHOD />

<cfif get_invoice.taxno Eq '2222222222' And Len(get_invoice.PAY_METHOD)>
    <cfquery name="get_paymethod_name" datasource="#dsn#">
        SELECT
            ITEM
        FROM
            SETUP_LANGUAGE_INFO
        WHERE
            UNIQUE_COLUMN_ID = #get_invoice.PAY_METHOD# AND
            TABLE_NAME = 'SETUP_PAYMETHOD' AND
            COLUMN_NAME = 'PAYMETHOD' AND
            LANGUAGE = 'eng'
    </cfquery>
    <cfif get_paymethod_name.recordCount>
        <cfset paymethod_name = get_paymethod_name.ITEM />
    </cfif>
</cfif>

<cfquery name="get_invoice_kdv" dbtype="query">
    SELECT * FROM GET_INVOICE_KDV WHERE TYPE != 3
</cfquery>

<cfset total_nettotal = 0 />
<cfloop query="get_invoice_kdv">
	<cfset total_nettotal = total_nettotal + nettotal />
</cfloop>
<cfset my_lang = session_base.language />
<cfif get_invoice.taxno Eq '2222222222'><cfset session_base.language = 'ENG' /></cfif>
<cf_n2txt number="mynumber1" para_birimi="#get_invoice.money#">
<cfset session_base.language = my_lang />

<cfsavecontent variable="invoice_data"><cfoutput>
<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:xades="http://uri.etsi.org/01903/v1.3.2##" xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:ubltr="urn:oasis:names:specification:ubl:schema:xsd:TurkishCustomizationExtensionComponents" xmlns:ds="http://www.w3.org/2000/09/xmldsig##">
<ext:UBLExtensions>
<ext:UBLExtension><ext:ExtensionContent/></ext:UBLExtension>
</ext:UBLExtensions>
	<cbc:UBLVersionID>#get_our_company.ublversionid#</cbc:UBLVersionID>
	<cbc:CustomizationID>#get_our_company.customizationid#</cbc:CustomizationID>
	<cbc:ProfileID>TEMELFATURA</cbc:ProfileID>
	<cbc:ID>#invoice_number#</cbc:ID>
	<cbc:CopyIndicator>false</cbc:CopyIndicator>
	<cbc:UUID>#GUIDStr#</cbc:UUID>
	<cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:IssueTime>#timeformat(dateadd('h',session_base.time_zone,now()),'HH:MM:SS')#</cbc:IssueTime>
	<cbc:InvoiceTypeCode>#temp_InvoiceTypeCode#</cbc:InvoiceTypeCode>
    <cbc:Note><![CDATA[#trim(get_invoice.note)#]]></cbc:Note>
    <cfif get_invoice.is_internet eq 1><cbc:Note>Bu satış İnternet üzerinden yapılmıştır.</cbc:Note></cfif>
    <cfif get_invoice.earchive_sending_type eq 1 and get_our_company.earchive_integration_type neq 3><cbc:Note>E-Arşiv izni kapsamında elektronik ortamda iletilmiştir.</cbc:Note><cfelse><cbc:Note>İrsaliye yerine geçer.</cbc:Note></cfif>
    <cfif isdefined('temp_agent')><cbc:Note><cfif get_agent.recordcount><![CDATA[#trim(get_agent.name)#]]></cfif></cbc:Note></cfif>
	<cbc:DocumentCurrencyCode listAgencyName="United Nations Economic Commission for Europe" listID="ISO 4217 Alpha" listName="Currency" listVersionID="2001">#get_invoice.currency_code#</cbc:DocumentCurrencyCode>
	<cbc:LineCountNumeric>#get_invoice_row.recordcount#</cbc:LineCountNumeric>
	<cfif isdefined("get_related_order")>
		<cfloop query="get_related_order">
			<cac:OrderReference>
				<cbc:ID>#get_related_order.order_number#</cbc:ID>
				<cbc:IssueDate>#dateformat(get_related_order.order_date,'yyyy-mm-dd')#</cbc:IssueDate>
			</cac:OrderReference>
		</cfloop>
	</cfif>
	<cfif isdefined("get_related_ship")>
		<cfloop query="get_related_ship">
			<cac:DespatchDocumentReference>
				<cbc:ID>#get_related_ship.ship_number#</cbc:ID>
				<cbc:IssueDate>#dateformat(get_related_ship.ship_date,'yyyy-mm-dd')#</cbc:IssueDate>
			</cac:DespatchDocumentReference>
		</cfloop>
	</cfif>
  <cfif get_invoice.is_internet eq 1>
  <cfif get_our_company.earchive_integration_type eq 3><cac:Delivery>
  	<cac:CarrierParty>
    	<cfif len(internet_CarrierParty_VKN) eq 10><cac:PartyIdentification>
        	<cbc:ID schemeID="VKN">#internet_CarrierParty_VKN#</cbc:ID><!--- Tasıyıcı VKN --->
        </cac:PartyIdentification><cfelse><cac:PartyIdentification>
        	<cbc:ID schemeID="TCKN">#internet_CarrierParty_VKN#</cbc:ID><!--- Tasıyıcı TCKN --->
        </cac:PartyIdentification>
        <cac:Person>
            <cbc:FirstName></cbc:FirstName>
            <cbc:FamilyName></cbc:FamilyName>
        </cac:Person></cfif>
        <cac:PartyName>
        	<cbc:Name>#internet_CarrierParty_Name#</cbc:Name><!--- Tasıyıcı Unvan --->
        </cac:PartyName>
        <cac:PostalAddress>
        <cbc:ID />
        <cbc:CitySubdivisionName />
        <cbc:CityName />
        <cac:Country>
          <cbc:Name></cbc:Name>
        </cac:Country>
      </cac:PostalAddress>
    </cac:CarrierParty>
    <cac:Despatch>
        <cbc:ActualDespatchDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:ActualDespatchDate><!--- Gönderim Tarihi --->
    </cac:Despatch>
  </cac:Delivery><cfelse>
  <cac:AdditionalDocumentReference>
  	<cbc:ID>#invoice_number#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentTypeCode>WebURL</cbc:DocumentTypeCode>
    <cbc:DocumentType>#internet_WebsiteURI#</cbc:DocumentType><!--- web adresi yazilacak. --->
  </cac:AdditionalDocumentReference>
  <cac:AdditionalDocumentReference>
  	<cbc:ID>#invoice_number#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentTypeCode>SendingDate</cbc:DocumentTypeCode>
    <cbc:DocumentType>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:DocumentType>
  </cac:AdditionalDocumentReference>
  <cac:AdditionalDocumentReference>
  	<cbc:ID>#invoice_number#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentTypeCode>IdentificationType</cbc:DocumentTypeCode>
    <cbc:DocumentType>VKN</cbc:DocumentType><!--- VKN yada TCKN yazılacak.(DP) --->
  </cac:AdditionalDocumentReference>
  <cac:AdditionalDocumentReference>
  	<cbc:ID>#invoice_number#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentTypeCode>IdentificationValue</cbc:DocumentTypeCode>
    <cbc:DocumentType>#internet_CarrierParty_VKN#</cbc:DocumentType><!--- Tasıyıcı(VKN)/(TCKN) degeri--->
  </cac:AdditionalDocumentReference>
  <cac:AdditionalDocumentReference>
    <cbc:ID>#invoice_number#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentTypeCode>PartyName</cbc:DocumentTypeCode>
    <cbc:DocumentType>#internet_CarrierParty_Name#</cbc:DocumentType><!--- Tasıyıcı Firma--->
  </cac:AdditionalDocumentReference></cfif></cfif>
	<cfif get_our_company.earchive_integration_type eq 1><cac:AdditionalDocumentReference>
  	<cbc:ID><cfif get_invoice.earchive_sending_type eq 0>KAGIT<cfelse>ELEKTRONIK</cfif></cbc:ID>
  	<cbc:issuedate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:issuedate>
  	<cbc:DocumentTypeCode>EREPSENDT</cbc:DocumentTypeCode><!--- Gonderim Tipi--->
  </cac:AdditionalDocumentReference>
  <cfelseif get_our_company.earchive_integration_type eq 2><cac:AdditionalDocumentReference>
  	<cbc:ID>#invoice_number#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentTypeCode>SendingType</cbc:DocumentTypeCode>
    <cbc:DocumentType><cfif get_invoice.earchive_sending_type eq 0>KAGIT<cfelse>ELEKTRONIK</cfif></cbc:DocumentType>
  </cac:AdditionalDocumentReference>
  <cfelse><cac:AdditionalDocumentReference>
  	<cbc:ID>SendType</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentType><cfif get_invoice.earchive_sending_type eq 0>KAGIT<cfelse>ELEKTRONIK</cfif></cbc:DocumentType>
  </cac:AdditionalDocumentReference>
  <cac:AdditionalDocumentReference>
  	<cbc:ID>IsInternetSale</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentType><cfif get_invoice.is_internet eq 1>true<cfelse>false</cfif></cbc:DocumentType>
  </cac:AdditionalDocumentReference>		
  </cfif>
  <cac:AdditionalDocumentReference>
    <cbc:ID>#invoice_number#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentType>XSLT</cbc:DocumentType>
    <cac:Attachment><cbc:EmbeddedDocumentBinaryObject mimeCode="application/xml" filename="#invoice_number#.xslt" encodingCode="Base64" characterSetCode="UTF-8">#temp_earchive_template#</cbc:EmbeddedDocumentBinaryObject></cac:Attachment>
  </cac:AdditionalDocumentReference>
  <cfif len(get_our_company.ATTACHMENT_FILE)>
      <cac:AdditionalDocumentReference>
		<cbc:ID>1</cbc:ID>
		<cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
		<cac:Attachment>
			<cbc:EmbeddedDocumentBinaryObject characterSetCode="UTF-8" encodingCode="Base64" filename="#get_our_company.ATTACHMENT_FILE_NAME#" mimeCode="application/pdf">#attachmentFileBase64#</cbc:EmbeddedDocumentBinaryObject>
		</cac:Attachment>
	</cac:AdditionalDocumentReference>
  </cfif>
  <cac:AdditionalDocumentReference>
  <cbc:ID>#mynumber1#</cbc:ID>
  <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
  <cbc:DocumentType>TR_NET_STR</cbc:DocumentType>
  </cac:AdditionalDocumentReference>
  <cac:AdditionalDocumentReference>
  <cbc:ID>#mynumber1#</cbc:ID>
  <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
  <cbc:DocumentType>TOTAL_NET_STR</cbc:DocumentType>
  </cac:AdditionalDocumentReference>
    <cfloop query="get_bank_accounts">
    <cac:AdditionalDocumentReference>
       <cbc:ID>#IBAN# (#BANK_NAME# #ACCOUNT_CURRENCY_ID#)</cbc:ID>
       <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
       <cbc:DocumentType>BANK_ACCOUNT_INFO</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    </cfloop>
    <cfloop query="get_bank_accounts">
    <cac:AdditionalDocumentReference>
        <cbc:ID>Bank Name: #BANK_NAME#</cbc:ID>
        <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
        <cbc:DocumentType>BANK_ACCOUNT_INFO2</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    <cac:AdditionalDocumentReference>
    <cbc:ID>Bank Branch: #BANK_BRANCH_NAME#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentType>BANK_ACCOUNT_INFO2</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    <cac:AdditionalDocumentReference>
        <cbc:ID>IBAN: #IBAN# #ACCOUNT_CURRENCY_ID#</cbc:ID>
        <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
        <cbc:DocumentType>BANK_ACCOUNT_INFO2</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    <cac:AdditionalDocumentReference>
        <cbc:ID>Sort Key/Routing number(Swift): #SWIFT_CODE#</cbc:ID>
        <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
        <cbc:DocumentType>BANK_ACCOUNT_INFO2</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    <cac:AdditionalDocumentReference>
        <cbc:ID>Bank Address: #BANK_BRANCH_ADDRESS#</cbc:ID>
        <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
        <cbc:DocumentType>BANK_ACCOUNT_INFO2</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    <cac:AdditionalDocumentReference>
        <cbc:ID></cbc:ID>
        <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
        <cbc:DocumentType>BANK_ACCOUNT_INFO2</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    </cfloop>
    <cfloop query="get_bank_accounts">
    <cac:AdditionalDocumentReference>
        <cbc:ID>IBAN: #IBAN# (#BANK_NAME# #ACCOUNT_CURRENCY_ID#)</cbc:ID>
        <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
        <cbc:DocumentType>BANK_ACCOUNT_INFO3</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    <cac:AdditionalDocumentReference>
        <cbc:ID>Swift Code: #SWIFT_CODE#</cbc:ID>
        <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
        <cbc:DocumentType>BANK_ACCOUNT_INFO3</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    <cac:AdditionalDocumentReference>
    <cbc:ID></cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentType>BANK_ACCOUNT_INFO3</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    </cfloop>
    <cfif isdefined("get_owner_customer_no")>
    <cac:AdditionalDocumentReference>
        <cbc:ID>IBAN: #get_owner_customer_no.ACCOUNT_OWNER_CUSTOMER_NO# (#get_owner_customer_no.BANK_NAME#-#get_owner_customer_no.BANK_BRANCH_NAME#-#get_owner_customer_no.ACCOUNT_CURRENCY_ID#)</cbc:ID>
        <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
        <cbc:DocumentType>BANK_ACCOUNT_INFO4</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    </cfif>
    <cac:AdditionalDocumentReference>
    <cbc:ID>#LegalMonetaryTotal.PayableAmountTL#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentType>PAYABLEAMOUNT</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    <cac:AdditionalDocumentReference>
    <cbc:ID>#CUSTOMER_NO#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentType>CUSTOMER_NO</cbc:DocumentType>
    </cac:AdditionalDocumentReference>
    <cac:Signature>
        <cbc:ID schemeID="VKN_TCKN">#get_comp_info.tax_no#</cbc:ID>
        <cac:SignatoryParty>
            <cac:PartyIdentification>
                <cbc:ID schemeID="VKN">#get_comp_info.tax_no#</cbc:ID>
            </cac:PartyIdentification>
            <cac:PostalAddress>
                <cbc:Room></cbc:Room>
                <cbc:StreetName>#get_comp_info.address#</cbc:StreetName>
                <cbc:BuildingNumber></cbc:BuildingNumber>
                <cbc:CitySubdivisionName>#get_comp_info.county_name#</cbc:CitySubdivisionName>
                <cbc:CityName>#get_comp_info.city_name#</cbc:CityName>
                <cbc:PostalZone>#get_comp_info.postal_code#</cbc:PostalZone>
                <cbc:Region/>
                <cac:Country>
                    <cbc:Name>#get_comp_info.country_name#</cbc:Name>
                </cac:Country>
            </cac:PostalAddress>
        </cac:SignatoryParty>
        <cac:DigitalSignatureAttachment>
            <cac:ExternalReference>
                <cbc:URI>##Signature_#invoice_number#</cbc:URI>
            </cac:ExternalReference>
        </cac:DigitalSignatureAttachment>
    </cac:Signature>
    <cac:AccountingSupplierParty>
        <cac:Party>
        	<cbc:WebsiteURI><cfif get_invoice.is_internet eq 1>#internet_WebsiteURI#<cfelse>#get_comp_info.web#</cfif></cbc:WebsiteURI>
            <cac:PartyIdentification>
                <cbc:ID schemeID="VKN">#get_comp_info.tax_no#</cbc:ID>
            </cac:PartyIdentification>
            <cfif len(get_comp_info.t_no)>
                <cac:PartyIdentification>
                    <cbc:ID schemeID="TICARETSICILNO">#get_comp_info.t_no#</cbc:ID>               
                </cac:PartyIdentification>
            </cfif>
			<cfif len(get_comp_info.mersis_no)>
                <cac:PartyIdentification>
                    <cbc:ID schemeID="MERSISNO">#get_comp_info.mersis_no#</cbc:ID>               
                </cac:PartyIdentification>
            </cfif>
            <cac:PartyName>
                <cbc:Name>#get_comp_info.company_name#</cbc:Name>
            </cac:PartyName>
            <cac:PostalAddress>
            	<cbc:Room/>
                <cbc:StreetName>#get_comp_info.address#</cbc:StreetName>
                <cbc:BuildingNumber></cbc:BuildingNumber>
                <cbc:CitySubdivisionName>#get_comp_info.county_name#</cbc:CitySubdivisionName>
                <cbc:CityName>#get_comp_info.city_name#</cbc:CityName>
                <cbc:PostalZone>#get_comp_info.postal_code#</cbc:PostalZone>
                <cbc:Region/>
                <cac:Country>
                    <cbc:Name>#get_comp_info.country_name#</cbc:Name>
                </cac:Country>
            </cac:PostalAddress>
            <cac:PartyTaxScheme>
                <cac:TaxScheme>
                    <cbc:Name>#get_comp_info.tax_office#</cbc:Name>
                </cac:TaxScheme>
            </cac:PartyTaxScheme>
            <cac:Contact>
				<cbc:Telephone>(#get_comp_info.tel_code#) #get_comp_info.tel#</cbc:Telephone>
				<cbc:Telefax>(#get_comp_info.tel_code#) #get_comp_info.fax#</cbc:Telefax>
				<cbc:ElectronicMail>#get_comp_info.email#</cbc:ElectronicMail>
            </cac:Contact>
        </cac:Party>
    </cac:AccountingSupplierParty>
    <cac:AccountingCustomerParty>
        <cac:Party>
            <cac:PartyIdentification>
                <cbc:ID schemeID="<cfif not get_invoice.is_person>VKN<cfelse>TCKN</cfif>">#trim(member_tno)#</cbc:ID>
            </cac:PartyIdentification>
            <cfif len(get_invoice.compbranch_code)>
            <cac:PartyIdentification>
                <cbc:ID schemeID="BAYINO">#get_invoice.compbranch_code#</cbc:ID>               
            </cac:PartyIdentification>
            </cfif>
            <!--- <cfif not get_invoice.is_person> --->
            <cac:PartyName>
                <cbc:Name><![CDATA[#trim(get_invoice.fullname)#]]></cbc:Name>
            </cac:PartyName>
            <!--- </cfif> --->
            <cac:PostalAddress>
                <cbc:Room/>
                <cbc:StreetName><![CDATA[<cfif len(get_invoice.ADDRESS2)>#get_invoice.ADDRESS2#<cfelse>#get_invoice.company_address#</cfif>]]></cbc:StreetName>
                <cbc:BuildingName></cbc:BuildingName>
                <cbc:BuildingNumber></cbc:BuildingNumber>
                <cbc:CitySubdivisionName><![CDATA[<cfif len(get_invoice.COUNTY_NAME2)>#trim(get_invoice.COUNTY_NAME2)#<cfelse>#trim(get_invoice.county_name)#</cfif>]]></cbc:CitySubdivisionName>
                <cbc:CityName><![CDATA[<cfif len(get_invoice.CITY_NAME2)>#trim(get_invoice.CITY_NAME2)#<cfelse>#trim(get_invoice.city_name)#</cfif>]]></cbc:CityName>
                <cbc:PostalZone><cfif len(get_invoice.COMPANY_POSTCODE2)>#get_invoice.COMPANY_POSTCODE2#<cfelse>#get_invoice.company_postcode#</cfif></cbc:PostalZone>
                <cbc:Region/>
                <cac:Country>
                    <cbc:Name><cfif len(get_invoice.COUNTRY_NAME2)>#get_invoice.COUNTRY_NAME2#<cfelse>#get_invoice.country_name#</cfif></cbc:Name>
                </cac:Country>
            </cac:PostalAddress>
            <cac:PartyTaxScheme>
                <cac:TaxScheme>
                    <cbc:Name>#get_invoice.taxoffice#</cbc:Name>
                </cac:TaxScheme>
            </cac:PartyTaxScheme>
            <cac:Contact>
            	 <cbc:Telephone>(#get_invoice.COMPANY_TELCODE#) #get_invoice.company_tel#</cbc:Telephone>
				 <cbc:Telefax>(#get_invoice.COMPANY_TELCODE#) #get_invoice.company_fax#</cbc:Telefax>
				 <cbc:ElectronicMail>#invoice_emails#</cbc:ElectronicMail>
			</cac:Contact>
            <cfif get_invoice.is_person>
            	<cac:Person>
                    <cbc:FirstName><![CDATA[#trim(get_invoice.company_partner_name)#]]></cbc:FirstName>
                    <cbc:FamilyName><![CDATA[#trim(get_invoice.company_partner_surname)#]]></cbc:FamilyName>
                    <cbc:Title><![CDATA[#trim(get_invoice.fullname)#]]></cbc:Title>
                    <cbc:MiddleName></cbc:MiddleName>
                    <cbc:NameSuffix></cbc:NameSuffix>
                </cac:Person></cfif>
            <cfif len(get_invoice.ship_address_id) and get_invoice.ship_address_id neq -1>
			<cac:AgentParty>
				<cac:PartyIdentification>
                	<cfif not get_invoice.is_person><cbc:ID schemeID="VKN">#get_invoice.taxno#</cbc:ID><cfelse><cbc:ID schemeID="TCKN">#get_invoice.taxno#</cbc:ID></cfif>
				</cac:PartyIdentification>
                <cac:PostalAddress>
                    <cbc:Room/>
                    <cbc:StreetName><![CDATA[#trim(get_invoice.address2)#]]></cbc:StreetName>
                    <cbc:BuildingName></cbc:BuildingName>
                    <cbc:BuildingNumber></cbc:BuildingNumber>
                    <cbc:CitySubdivisionName>#get_invoice.county_name2#</cbc:CitySubdivisionName>
                    <cbc:CityName>#get_invoice.city_name2#</cbc:CityName>
                    <cbc:PostalZone>#get_invoice.company_postcode2#</cbc:PostalZone>
                    <cbc:Region/>
                    <cac:Country>
                        <cbc:Name>#get_invoice.country_name2#</cbc:Name>
                    </cac:Country>
                </cac:PostalAddress>
			</cac:AgentParty></cfif>
        </cac:Party>
    </cac:AccountingCustomerParty>
	<cfif get_invoice.is_internet eq 1>
		<cac:PaymentMeans>
			<cbc:PaymentMeansCode>#internet_PaymentMeansCode#</cbc:PaymentMeansCode>
			<cfif len(get_invoice.due_date)><cbc:PaymentDueDate>#dateformat(get_invoice.due_date,'yyyy-mm-dd')#</cbc:PaymentDueDate></cfif>
            <cbc:InstructionNote><cfif listfind('1,97',internet_PaymentMeansCode)><![CDATA[#paymethod_name#]]> - <![CDATA[#trim(get_invoice.note)#]]></cfif></cbc:InstructionNote><!--- Odeme Alicisi ve Diger Internet satislarinda --->
		</cac:PaymentMeans>
	<cfelse>
		<cac:PaymentMeans>
			<cbc:PaymentMeansCode>#get_invoice.payment_means_code#</cbc:PaymentMeansCode>
			<cfif len(get_invoice.due_date)><cbc:PaymentDueDate>#dateformat(get_invoice.due_date,'yyyy-mm-dd')#</cbc:PaymentDueDate></cfif>
            <cfif len(get_invoice.paymethod)><cbc:InstructionNote><![CDATA[#paymethod_name#]]> - <![CDATA[#trim(get_invoice.note)#]]></cbc:InstructionNote></cfif>
		</cac:PaymentMeans>
    </cfif>
	<cfif get_invoice.currency_code neq 'TRY'>
        <cac:PricingExchangeRate>
            <cbc:SourceCurrencyCode>#get_invoice.currency_code#</cbc:SourceCurrencyCode>
            <cbc:TargetCurrencyCode>TRY</cbc:TargetCurrencyCode>
            <cbc:CalculationRate>#NumberFormat(get_invoice.rate2,"_.0000")#</cbc:CalculationRate>
            <cbc:Date>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:Date>
        </cac:PricingExchangeRate>
 	</cfif>
    <cfquery name="get_tax_rows" dbtype="query">
        SELECT * FROM GET_INVOICE_TAX_ROW WHERE INVOICE_ROW_ID = #get_invoice_row.invoice_row_id#
    </cfquery>
    <cac:TaxTotal>
        <cbc:TaxAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice.taxtotal,"_.00")#</cbc:TaxAmount>
        <cfloop query="get_invoice_kdv">
            <cac:TaxSubtotal>
                <cbc:TaxableAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_kdv.nettotal - get_invoice.sa_discount,"_.00")#</cbc:TaxableAmount>
                <cbc:TaxAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_kdv.tax_amount,"_.00")#</cbc:TaxAmount>
                <cbc:CalculationSequenceNumeric>#get_invoice_kdv.type#</cbc:CalculationSequenceNumeric>
                <cbc:Percent>#get_invoice_kdv.tax#</cbc:Percent>
                <cac:TaxCategory>
                <cfif temp_InvoiceTypeCode eq 'ISTISNA' and get_invoice_kdv.tax eq 0>
                    <cbc:TaxExemptionReasonCode>#get_invoice_tax_row.reason_code[1]#</cbc:TaxExemptionReasonCode>
                    <cbc:TaxExemptionReason>#get_invoice_tax_row.reason_name[1]#</cbc:TaxExemptionReason>
                <cfelseif (temp_InvoiceTypeCode eq 'ISTISNA' and listfind(list_ReasonTax,get_invoice_kdv.tax)) or (get_invoice_kdv.tax_amount eq 0)>
                    <cbc:TaxExemptionReasonCode>351</cbc:TaxExemptionReasonCode>
                    <cbc:TaxExemptionReason>İstisna Olmayan Diğer</cbc:TaxExemptionReason>
                </cfif>
                    <cac:TaxScheme>
                        <cbc:Name>#get_invoice_kdv.tax_code_name#</cbc:Name>
                        <cbc:TaxTypeCode>#get_invoice_kdv.tax_code#</cbc:TaxTypeCode>
                    </cac:TaxScheme>
                </cac:TaxCategory>
            </cac:TaxSubtotal>
        </cfloop>
    </cac:TaxTotal>
    <cfif isdefined('get_tevkifat_kdv') and get_tevkifat_kdv.recordcount>
        <cac:WithholdingTaxTotal>
            <cbc:TaxAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_tevkifat_kdv.tax_amount,"_.00")#</cbc:TaxAmount>
            <cac:TaxSubtotal>
                <cbc:TaxableAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_taxamount.tax_amount,"_.00")#</cbc:TaxableAmount>
                <cbc:TaxAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_tevkifat_kdv.tax_amount,"_.00")#</cbc:TaxAmount>
                <cbc:Percent>#get_tevkifat_kdv.tax#</cbc:Percent>
                <cac:TaxCategory>
                <cac:TaxScheme>
                    <cbc:Name>#get_tevkifat_kdv.tax_code_name#</cbc:Name>
                    <cbc:TaxTypeCode>#get_tevkifat_kdv.tax_code#</cbc:TaxTypeCode>
                </cac:TaxScheme>
                </cac:TaxCategory>
            </cac:TaxSubtotal>
        </cac:WithholdingTaxTotal>
    </cfif>
    <cac:LegalMonetaryTotal>
        <cbc:LineExtensionAmount currencyID="#get_invoice.currency_code#">#NumberFormat(LegalMonetaryTotal.LineExtensionAmount,"_.00")#</cbc:LineExtensionAmount>
        <cbc:TaxExclusiveAmount currencyID="#get_invoice.currency_code#">#NumberFormat(LegalMonetaryTotal.TaxExclusiveAmount,"_.00")#</cbc:TaxExclusiveAmount>
        <cbc:TaxInclusiveAmount currencyID="#get_invoice.currency_code#">#NumberFormat(LegalMonetaryTotal.TaxInclusiveAmount,"_.00")#</cbc:TaxInclusiveAmount>
        <cbc:AllowanceTotalAmount currencyID="#get_invoice.currency_code#">#NumberFormat(LegalMonetaryTotal.AllowanceTotalAmount,"_.00")#</cbc:AllowanceTotalAmount>
        <cbc:PayableAmount currencyID="#get_invoice.currency_code#">#NumberFormat(LegalMonetaryTotal.PayableAmount,"_.00")#</cbc:PayableAmount>
    </cac:LegalMonetaryTotal>
    <cfset loop_count = 0>
    <cfloop query="GET_INVOICE_ROW">
    <cfset loop_count = loop_count + 1>
    <cac:InvoiceLine>
        <cbc:ID>#loop_count#</cbc:ID>
        <cbc:InvoicedQuantity unitCode="#get_invoice_row.unit_code#">#get_invoice_row.amount#</cbc:InvoicedQuantity>
        <cbc:LineExtensionAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_row.nettotal,"_.00")#</cbc:LineExtensionAmount>
		<cfif len(discounttotal) and discounttotal neq 0>
            <cac:AllowanceCharge>
                <cbc:ChargeIndicator>false</cbc:ChargeIndicator><!--- Zorunlu - Iskonto ise "false", artırım ise "true" ---><cfif isdefined('temp_charge_reason')>
                <cbc:AllowanceChargeReason><cfloop from="1" to="5" index="reason_i">#evaluate('get_invoice_row.discount#reason_i#')#!##</cfloop></cbc:AllowanceChargeReason></cfif>	
                <cbc:MultiplierFactorNumeric>#NumberFormat(((100*get_invoice_row.discounttotal)/(get_invoice_row.price*get_invoice_row.amount)/100),"_.0000")#</cbc:MultiplierFactorNumeric><!--- Seçimli - Iskonto/ Artırım Oranı --->
                <cbc:Amount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_row.discounttotal,"_.00")#</cbc:Amount><!--- Zorunlu - Iskonto/ Artırım Tutarı --->
                <cbc:BaseAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_row.price*get_invoice_row.amount,"_.00")#</cbc:BaseAmount><!--- Seçimli - İskonto veya artırımın uygulandığı tutar --->
            </cac:AllowanceCharge>
        </cfif>
        <cfquery name="get_tax_rows" dbtype="query">
        	SELECT * FROM GET_INVOICE_TAX_ROW WHERE INVOICE_ROW_ID = #get_invoice_row.invoice_row_id#
		</cfquery>
        <cac:TaxTotal>
            <cbc:TaxAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_row.taxtotal,"_.00")#</cbc:TaxAmount>
            <cfloop query="get_tax_rows">
            <cac:TaxSubtotal>
                <cbc:TaxableAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_row.nettotal+get_invoice_row.discounttotal,"_.00")#</cbc:TaxableAmount>
                <cbc:TaxAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_tax_rows.tax_total,"_.00")#</cbc:TaxAmount>
                <cbc:CalculationSequenceNumeric>#get_tax_rows.type#</cbc:CalculationSequenceNumeric>
                <cbc:Percent>#get_tax_rows.tax#</cbc:Percent>
                <cac:TaxCategory>
            	<cfif temp_InvoiceTypeCode eq 'ISTISNA' and get_tax_rows.tax eq 0>
                	<cbc:TaxExemptionReasonCode>#get_tax_rows.reason_code#</cbc:TaxExemptionReasonCode>
                    <cbc:TaxExemptionReason>#get_tax_rows.reason_name#</cbc:TaxExemptionReason>
                <cfelseif (temp_InvoiceTypeCode eq 'ISTISNA' and listfind(list_ReasonTax,get_invoice_kdv.tax)) or (get_tax_rows.tax_total eq 0)>
                    <cbc:TaxExemptionReasonCode>351</cbc:TaxExemptionReasonCode>
                    <cbc:TaxExemptionReason>İstisna Olmayan Diğer</cbc:TaxExemptionReason>
            	</cfif>
                    <cac:TaxScheme>
                        <cbc:Name>#get_tax_rows.tax_code_name#</cbc:Name>
                        <cbc:TaxTypeCode>#get_tax_rows.tax_code#</cbc:TaxTypeCode>
                    </cac:TaxScheme>
                </cac:TaxCategory>
            </cac:TaxSubtotal>
            </cfloop>
        </cac:TaxTotal>
        <cfset product_name = get_invoice_row.name_product />
        <cfif get_invoice.taxno Eq '2222222222' And Len(get_invoice_row.PRODUCT_ID)>
            <cfquery name="get_product_name_eng" datasource="#dsn#">
                SELECT
                    ITEM
                FROM
                    SETUP_LANGUAGE_INFO
                WHERE
                    UNIQUE_COLUMN_ID = #get_invoice_row.PRODUCT_ID# AND
                    TABLE_NAME = 'PRODUCT' AND
                    COLUMN_NAME = 'PRODUCT_NAME' AND
                    LANGUAGE = 'eng'
            </cfquery>
            <cfif Len(get_product_name_eng.ITEM)>
                <cfset product_name = get_product_name_eng.ITEM />
            </cfif>
        </cfif>
        <cac:Item>
            <cbc:Description><![CDATA[#trim(get_invoice_row.product_name2)#]]></cbc:Description>
            <cbc:Name><![CDATA[#trim(product_name)#]]></cbc:Name>
            <cfif isdefined('temp_is_stock_code') and len(get_invoice_row.product_code)>
            <cac:SellersItemIdentification>
                <cbc:ID><![CDATA[#trim(get_invoice_row.product_code)#]]></cbc:ID>
            </cac:SellersItemIdentification>
            </cfif>
            <cfif isdefined('temp_product_name2') and len(get_invoice_row.product_code_2)>
            <cac:SellersItemIdentification>
                <cbc:ID><![CDATA[#trim(get_invoice_row.product_code_2)#]]></cbc:ID>
            </cac:SellersItemIdentification>
            </cfif>
            <cfif isdefined('get_invoice_row.company_stock_code') and Len(get_invoice_row.company_stock_code)>
            <cac:BuyersItemIdentification>
                <cbc:ID><![CDATA[#trim(get_invoice_row.company_stock_code)#]]></cbc:ID>
            </cac:BuyersItemIdentification>
            </cfif>
            <cfif isdefined('get_invoice_row.weight') and len(get_invoice_row.weight)>
                <cbc:Keyword><![CDATA[#trim(get_invoice_row.weight)#]]></cbc:Keyword>   
            </cfif>
            <cfif isdefined('temp_is_barcod') and len(get_invoice_row.barcod)>
            <cac:ManufacturersItemIdentification>
                <cbc:ID><![CDATA[#trim(get_invoice_row.barcod)#]]></cbc:ID>
            </cac:ManufacturersItemIdentification>
            </cfif>
            <cac:ItemInstance>
                <cfif isdefined("get_invoice_row.company_stock_code") and len(get_invoice_row.company_stock_code)> 
                    <cbc:AdditionalItemProperty><![CDATA[#trim(get_invoice_row.company_stock_code)#]]></cbc:AdditionalItemProperty>
                </cfif>
                <cbc:ProductTraceID><![CDATA[#trim(get_invoice_row.stock_code)#]]></cbc:ProductTraceID>
            </cac:ItemInstance>       
        </cac:Item>
        <cac:Price>
            <cbc:PriceAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_row.price,"_.00")#</cbc:PriceAmount><!--- Zorunlu - Mal/hizmetin birim fiyatı girilir. --->
        </cac:Price>
    </cac:InvoiceLine>
    </cfloop>
</Invoice></cfoutput>
</cfsavecontent>