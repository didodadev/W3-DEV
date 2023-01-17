<!---
    File: create_ubltr.cfm
    Folder: V16\e_government\display
    Author:
    Date:
    Description:
        E-fatura UBL oluşturma
    History:
        12.10.2019 Gramoni-Mahmut Çifçi - E-Government standart modüle taşındı
        2021-04-30 00:28:55 Gramoni-Mahmut - Üye bazlı şablon özelliği eklendi.
    To Do:

--->

<cfset save_folder      = "#upload_folder#e_government#dir_seperator#xslt#dir_seperator#" />
<cfset old_save_folder  = "#index_folder#objects#dir_seperator#xslt#dir_seperator#" />
<!--- Üye bazlı şablon kontrolü --->
<cfquery name="get_member_template" datasource="#dsn3#">
    SELECT
        TEMPLATE_PATH
    FROM
        EINVOICE_TEMPLATES
    WHERE
        <cfif Len(get_invoice.company_id)>COMPANY_ID = #get_invoice.company_id#</cfif>
		<cfif Len(get_invoice.consumer_id)>CONSUMER_ID = #get_invoice.consumer_id#</cfif>
</cfquery>

<cfif get_our_company.einvoice_type_alias eq 'dp'>
    <cfset round_format = "_.00000">
<cfelseif get_our_company.einvoice_type_alias eq 'dgn' or get_our_company.einvoice_type_alias eq 'spr'>
    <cfset round_format = "_.00">
</cfif>

<cfif get_member_template.recordCount>
	<cfset preview_invoice_template     = 'documents/e_government/xslt/#get_member_template.TEMPLATE_PATH#.xslt' />
	<cfset temp_einvoice_template_base64= FileRead("#save_folder##get_member_template.TEMPLATE_PATH#_base64.xslt","utf-8") />
<cfelse>
	<cfif len(get_our_company.template_filename_base64)><!--- özel şablon dosyası eklendiğinde--->
		<cfif fileExists('#save_folder##get_our_company.template_filename_base64#')>
			<cfset preview_invoice_template     = 'documents/e_government/xslt/#get_our_company.template_filename#' />
			<cfset temp_einvoice_template_base64= FileRead("#save_folder##get_our_company.template_filename_base64#","utf-8") />
		<cfelseif fileExists('#old_save_folder##get_our_company.template_filename_base64#')>
			<cfset preview_invoice_template     = 'V16/objects/xslt/#get_our_company.template_filename#' />
			<cfset temp_einvoice_template_base64= FileRead("#old_save_folder##get_our_company.template_filename_base64#","utf-8") />
		<cfelse>
			<cfthrow type="Application" errorcode="FileNotFound" message="Şablon dosyası bulunamadı!" detail="Özel şablon dosyası bulunamadı!" />
		</cfif>
	<cfelse>
		<cfset preview_invoice_template = 'V16/objects/xslt/einvoice_template.xslt' />
		<cfif fileExists('#save_folder#einvoice_template_base64.xslt')>
			<cfset temp_einvoice_template_base64= FileRead("#save_folder#einvoice_template_base64.xslt","utf-8")>
		<cfelse>
			<cfset temp_einvoice_template_base64= FileRead("#old_save_folder#einvoice_template_base64.xslt","utf-8")>
		</cfif>
	</cfif>
</cfif>
<cfquery name="get_invoice_kdv" dbtype="query">
    SELECT * FROM GET_INVOICE_KDV WHERE TYPE != 3
</cfquery>

<cfset total_nettotal = 0>
<cfloop query="get_invoice_kdv">
	<cfset total_nettotal = total_nettotal + nettotal>
</cfloop>
<cf_n2txt number="mynumber1" para_birimi="#get_invoice.money#">

<cfsavecontent variable="invoice_data"><cfoutput>
<Invoice xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" xmlns:xades="http://uri.etsi.org/01903/v1.3.2##" xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2" xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" xmlns:ccts="urn:un:unece:uncefact:documentation:2" xmlns:ubltr="urn:oasis:names:specification:ubl:schema:xsd:TurkishCustomizationExtensionComponents" xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDatatypes-2" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" xmlns:ds="http://www.w3.org/2000/09/xmldsig##" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2 UBL-Invoice-#get_our_company.ublversionid#.xsd">																																																																																																																																																																																													
<ext:UBLExtensions>
<ext:UBLExtension><ext:ExtensionContent/></ext:UBLExtension>
</ext:UBLExtensions>
	<cbc:UBLVersionID>#get_our_company.ublversionid#</cbc:UBLVersionID>
	<cbc:CustomizationID>#get_our_company.customizationid#</cbc:CustomizationID>
	<cbc:ProfileID><cfif listfind('BEDELSIZIHRACAT',get_invoice.profile_id)>IHRACAT<cfelse>#get_invoice.profile_id#</cfif></cbc:ProfileID>
	<cbc:ID><cfif not listfind("6,8",get_our_company.einvoice_type)><cfif isdefined('attributes.resend') and get_our_company.einvoice_type eq 7>#chk_einvoice_relation_md.integration_id#<cfelse>#invoice_number#</cfif></cfif></cbc:ID>
	<cbc:CopyIndicator>false</cbc:CopyIndicator>
	<cbc:UUID>#GUIDStr#</cbc:UUID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:IssueTime>#timeformat(dateadd('h',session_base.time_zone,now()),'HH:MM:SS')#</cbc:IssueTime>
	<cbc:InvoiceTypeCode>#temp_InvoiceTypeCode#</cbc:InvoiceTypeCode>
    <cfif Len(get_invoice.note)><cbc:Note><![CDATA[#trim(get_invoice.note)#]]></cbc:Note></cfif>
    <cfif listfind('BEDELSIZIHRACAT',get_invoice.profile_id)><cbc:Note>İhracat faturası BEDELSİZ olarak kesilmiştir.</cbc:Note></cfif>
    <cfif isdefined("temp_last_shipping_date")><cbc:Note>#dateformat(temp_last_shipping_date,'yyyy-mm-dd')#</cbc:Note></cfif>
    <cfif GET_INVOICE_TAX_REASON_CODE.recordcount><cfloop query="GET_INVOICE_TAX_REASON_CODE"><cfif GET_INVOICE_TAX_REASON_CODE.currentrow Neq 1><cbc:Note>#REASON_CODE# - #REASON_NAME#</cbc:Note></cfif></cfloop></cfif>
	<cbc:DocumentCurrencyCode listAgencyName="United Nations Economic Commission for Europe" listID="ISO 4217 Alpha" listName="Currency" listVersionID="2001">#get_invoice.currency_code#</cbc:DocumentCurrencyCode>
	<cbc:PaymentCurrencyCode listAgencyName="United Nations Economic Commission for Europe" listID="ISO 4217 Alpha" listName="Currency" listVersionID="2001">#get_invoice.currency_code#</cbc:PaymentCurrencyCode>
	<cbc:LineCountNumeric>#get_invoice_row.recordcount#</cbc:LineCountNumeric>
	<cfif isdefined("get_related_order")>
		<cfloop query="get_related_order">
			<cac:OrderReference>
				<cfif Len(get_related_order.ref_no)>
                	<cbc:ID>#get_related_order.ref_no#</cbc:ID>
                <cfelse>
                	<cbc:ID>#get_related_order.order_number#</cbc:ID>
				</cfif>
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
		</cfloop><cfif isdefined('temp_document_type_irsaliye')>
        <cfloop query="get_related_ship">
			<cac:AdditionalDocumentReference>
				<cbc:ID>#get_related_ship.ship_number#</cbc:ID>
                <cbc:DocumentType>#temp_document_type_irsaliye#</cbc:DocumentType>
				<cbc:IssueDate>#dateformat(get_related_ship.ship_date,'yyyy-mm-dd')#</cbc:IssueDate>
			</cac:AdditionalDocumentReference>
		</cfloop></cfif>
	</cfif>
    <cfif isdefined("get_related_order") and isdefined('temp_musteri_siparis_no') and len(get_related_order.ref_no)>
    	<cfloop query="get_related_order">
        	<cac:AdditionalDocumentReference>
				<cbc:ID>#get_related_order.ref_no#</cbc:ID>
                <cbc:DocumentType>#temp_document_type_siparis#</cbc:DocumentType>
				<cbc:IssueDate>#dateformat(get_related_order.order_date,'yyyy-mm-dd')#</cbc:IssueDate>
			</cac:AdditionalDocumentReference>
        </cfloop>
    </cfif>
  <cfif get_our_company.einvoice_type eq 8>
  <cac:AdditionalDocumentReference>
 	<cbc:ID>#invoice_number#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentTypeCode>CUST_INV_ID</cbc:DocumentTypeCode>
  </cac:AdditionalDocumentReference>
  </cfif>
  <cac:AdditionalDocumentReference>
    <cbc:ID>#invoice_number#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentType>XSLT</cbc:DocumentType>
    <cac:Attachment> <cbc:EmbeddedDocumentBinaryObject mimeCode="application/xml" filename="#invoice_number#.xslt" encodingCode="Base64" characterSetCode="UTF-8">#temp_einvoice_template_base64#</cbc:EmbeddedDocumentBinaryObject> 
	</cac:Attachment>
  </cac:AdditionalDocumentReference><cfif isdefined("temp_document_type")>
  <cac:AdditionalDocumentReference>
    <cbc:ID>#faturakodlist#</cbc:ID>
    <cbc:IssueDate>#dateformat(get_invoice.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
    <cbc:DocumentType>#temp_document_type#</cbc:DocumentType>
 </cac:AdditionalDocumentReference></cfif>
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
<cfif isdefined("get_owner_customer_no") and isdefined("get_invoice.BANK_ID") And get_invoice.BANK_ID Gt 0>
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
                <cbc:StreetName>#get_comp_info.district_name# #get_comp_info.street_name#</cbc:StreetName>
                <cbc:BuildingNumber>#get_comp_info.building_number#</cbc:BuildingNumber>
                <cbc:CitySubdivisionName>#get_comp_info.county_name#</cbc:CitySubdivisionName>
                <cbc:CityName>#get_comp_info.city_name#</cbc:CityName> 
                <cbc:PostalZone>#get_comp_info.postal_code#</cbc:PostalZone>
                <cbc:Region>#get_comp_info.city_subdivision_name#</cbc:Region>
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
        	<cbc:WebsiteURI>#get_comp_info.web#</cbc:WebsiteURI>
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
            <cfif isdefined('temp_is_musterino')>
            <cac:PartyIdentification>
                <cbc:ID schemeID="MUSTERINO">#temp_is_musterino#</cbc:ID>           
            </cac:PartyIdentification>
			</cfif>
            <cac:PartyName>
                <cbc:Name><![CDATA[#trim(get_comp_info.company_name)#]]></cbc:Name>
            </cac:PartyName>
            <cac:PostalAddress>
            	<cbc:Room/>
                <cbc:StreetName><![CDATA[#trim(get_comp_info.district_name)# #trim(get_comp_info.street_name)#]]></cbc:StreetName>
                <cbc:BuildingNumber>#get_comp_info.building_number#</cbc:BuildingNumber>
                <cbc:CitySubdivisionName>#get_comp_info.county_name#</cbc:CitySubdivisionName>
                <cbc:CityName>#get_comp_info.city_name#</cbc:CityName>
                <cbc:PostalZone>#get_comp_info.postal_code#</cbc:PostalZone>
                <cbc:Region>#get_comp_info.city_subdivision_name#</cbc:Region>
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
            <cac:Person>
                    <cbc:FirstName></cbc:FirstName>
                    <cbc:FamilyName></cbc:FamilyName>
                    <cbc:Title></cbc:Title>
                    <cbc:MiddleName></cbc:MiddleName>
                    <cbc:NameSuffix></cbc:NameSuffix>
                </cac:Person>
        </cac:Party>
    </cac:AccountingSupplierParty>
    <cfif not listfind('IHRACAT,YOLCUBERABERFATURA,BEDELSIZIHRACAT',get_invoice.profile_id)>
        <cac:AccountingCustomerParty>
            <cac:Party>
                <cac:PartyIdentification>
                    <cfif not get_invoice.is_person><cbc:ID schemeID="VKN">#get_invoice.taxno#</cbc:ID><cfelse><cbc:ID schemeID="TCKN">#get_invoice.tc_identity#</cbc:ID></cfif>
                </cac:PartyIdentification>
                <cfif len(get_invoice.compbranch_code)>
                <cac:PartyIdentification>
                    <cbc:ID schemeID="BAYINO">#get_invoice.compbranch_code# <cfif len(get_invoice.compbranch__name)>/ #get_invoice.compbranch__name#</cfif></cbc:ID>               
                </cac:PartyIdentification>
                </cfif>
                <cac:PartyName>
                    <cbc:Name><![CDATA[#get_invoice.fullname#]]></cbc:Name>
                </cac:PartyName>
                <cac:PostalAddress>
                    <cbc:Room/>
                    <cbc:StreetName><![CDATA[#trim(get_invoice.address)#]]></cbc:StreetName>
                    <cbc:BuildingName></cbc:BuildingName>
                    <cbc:BuildingNumber></cbc:BuildingNumber>
                    <cbc:CitySubdivisionName>#get_invoice.county_name#</cbc:CitySubdivisionName>
                    <cbc:CityName>#get_invoice.city_name#</cbc:CityName>
                    <cbc:PostalZone>#get_invoice.company_postcode#</cbc:PostalZone>
                    <cbc:Region/>
                    <cac:Country>
                        <cbc:Name>#get_invoice.country_name#</cbc:Name>
                    </cac:Country>
                </cac:PostalAddress>
                <cfif not get_invoice.is_person>
                <cac:PartyTaxScheme>
                    <cac:TaxScheme>
                        <cbc:Name>#get_invoice.taxoffice#</cbc:Name>
                    </cac:TaxScheme>
                </cac:PartyTaxScheme>
                </cfif>
                <cac:Contact>
                    <cbc:Telephone>(#get_invoice.COMPANY_TELCODE#) #get_invoice.company_tel#</cbc:Telephone>
                    <cbc:Telefax>(#get_invoice.COMPANY_TELCODE#) #get_invoice.company_fax#</cbc:Telefax>
                    <cbc:ElectronicMail>#get_invoice.company_email#</cbc:ElectronicMail>
                </cac:Contact><cfif get_invoice.is_person>
                <cac:Person>
                    <cbc:FirstName><![CDATA[#get_invoice.company_partner_name#]]></cbc:FirstName>
                    <cbc:FamilyName><![CDATA[#get_invoice.company_partner_surname#]]></cbc:FamilyName>
                    <cbc:Title></cbc:Title>
                </cac:Person></cfif>
                <cfif len(get_invoice.ship_address_id) and get_invoice.ship_address_id neq -1>
                <cac:AgentParty>
                    <cac:PartyIdentification>
                        <cfif not get_invoice.is_person><cbc:ID schemeID="VKN">#get_invoice.taxno#</cbc:ID><cfelse><cbc:ID schemeID="TCKN">#get_invoice.tc_identity#</cbc:ID></cfif>
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
    <cfelse>
        <cac:AccountingCustomerParty>
            <cac:Party>
                <cbc:WebsiteURI/>
                <cac:PartyIdentification>
                	<cbc:ID schemeID="VKN">1460415308</cbc:ID>
                </cac:PartyIdentification>
                <cac:PartyName>
                	<cbc:Name>Gümrük ve Ticaret Bakanlığı</cbc:Name>
                </cac:PartyName>
                <cac:PostalAddress>
                    <cbc:Room/>
                    <cbc:StreetName>Üniversiteler Mahallesi Dumlupınar Bulvarı</cbc:StreetName>
                    <cbc:BuildingName/>
                    <cbc:BuildingNumber>151</cbc:BuildingNumber>
                    <cbc:CitySubdivisionName>Çankaya</cbc:CitySubdivisionName>
                    <cbc:CityName>Ankara</cbc:CityName>
                    <cbc:PostalZone/>
                    <cbc:Region/>
                    <cac:Country>
                    	<cbc:Name>Türkiye</cbc:Name>
                    </cac:Country>
                </cac:PostalAddress>
                <cac:PartyTaxScheme>
                    <cac:TaxScheme>
                    	<cbc:Name>Ulus</cbc:Name>
                    </cac:TaxScheme>
                </cac:PartyTaxScheme>
            </cac:Party>
        </cac:AccountingCustomerParty>
    	<cfif listfind('IHRACAT,YOLCUBERABERFATURA,BEDELSIZIHRACAT',get_invoice.profile_id)>
            <cac:BuyerCustomerParty>
                <cac:Party>
                    <cac:PartyIdentification>
                        <cbc:ID schemeID="PARTYTYPE"><cfif listfind('IHRACAT,BEDELSIZIHRACAT',get_invoice.profile_id)>EXPORT<cfelse>TAXFREE</cfif></cbc:ID>
                    </cac:PartyIdentification>
                    <cac:PartyName>
                        <cbc:Name><![CDATA[#get_invoice.fullname#]]></cbc:Name>
                    </cac:PartyName>
                    <cac:PostalAddress>
                        <cbc:Room/>
                        <cbc:StreetName><![CDATA[#trim(get_invoice.address)#]]></cbc:StreetName>
                        <cbc:BuildingName></cbc:BuildingName>
                        <cbc:BuildingNumber></cbc:BuildingNumber>
                        <cbc:CitySubdivisionName>#get_invoice.county_name#</cbc:CitySubdivisionName>
                        <cbc:CityName>#get_invoice.city_name#</cbc:CityName>
                        <cbc:PostalZone>#get_invoice.company_postcode#</cbc:PostalZone>
                        <cbc:Region/>
                        <cac:Country>
                            <cbc:Name>#get_invoice.country_name#</cbc:Name>
                        </cac:Country>
                    </cac:PostalAddress>
                    <cfif not get_invoice.is_person>
                    <cac:PartyTaxScheme>
                        <cac:TaxScheme>
                            <cbc:Name>#get_invoice.taxoffice#</cbc:Name>
                        </cac:TaxScheme>
                    </cac:PartyTaxScheme>
                    </cfif>
                    <cac:PartyLegalEntity>
                        <cbc:RegistrationName><![CDATA[#get_invoice.fullname#]]></cbc:RegistrationName><!-- Malı alan kurumun resmi ünvanı -->
                        <cbc:CompanyID><cfif not get_invoice.is_person>#get_invoice.taxno#<cfelse>#get_invoice.tc_identity#</cfif></cbc:CompanyID> <!-- Malı alan kurumun ülkesindeki vergi numarası -->
                        <cac:CorporateRegistrationScheme>
                            <cbc:ID/>
                            <cbc:Name/>
                        </cac:CorporateRegistrationScheme>
                    </cac:PartyLegalEntity>
                    <cac:Contact>
                        <cbc:Telephone>#get_invoice.company_tel#</cbc:Telephone>
                        <cbc:Telefax>#get_invoice.company_fax#</cbc:Telefax>
                        <cbc:ElectronicMail>#get_invoice.company_email#</cbc:ElectronicMail>
                    </cac:Contact>
					<cfif get_invoice.is_person or get_invoice.profile_id eq 'YOLCUBERABERFATURA'>         
                        <cac:Person>
                            <cbc:FirstName><![CDATA[#get_invoice.company_partner_name#]]></cbc:FirstName>
                            <cbc:FamilyName><![CDATA[#get_invoice.company_partner_surname#]]></cbc:FamilyName>
                            <cbc:Title></cbc:Title>
                            <cfif get_invoice.profile_id eq 'YOLCUBERABERFATURA'>
                            	<cfquery name="getIP" datasource="#dsn3#">
                                    SELECT
                                        *
                                    FROM
                                        #dsn3_alias#.SETUP_PRO_INFO_PLUS_NAMES SPI
                                    WHERE
                                        SPI.OWNER_TYPE_ID = -8
                                </cfquery>
                                <cfloop from="1" to="20" index="i">
                                	<cfset colname = evaluate("getIP.property#i#_name")>
                                    
                                    <cfif Find('YBF1',colname) gt 0>
                                    	<cfset uyrukcolumn = 'property#i#'>
                                    </cfif>
                                    <cfif Find('YBF2',colname) gt 0>
                                    	<cfset passnocolumn = 'property#i#'>
                                    </cfif>
                                    <cfif Find('YBF3',colname) gt 0>
                                    	<cfset passdatecolumn = 'property#i#'>
                                    </cfif>
                                </cfloop>
                                <cfquery name="getIIP" datasource="#dsn2#">
                                	SELECT
                                    	#uyrukcolumn# AS UYRUK,
                                        #passnocolumn# AS PASSNO,
                                        #passdatecolumn# AS PASSDATE
                                    FROM
	                                    INVOICE_INFO_PLUS IIP
                                	WHERE
                                    	IIP.INVOICE_ID = #get_invoice.invoice_id#
                                </cfquery>
                                <cbc:NationalityID>#getIIP.UYRUK#</cbc:NationalityID>
                                <cac:FinancialAccount>
                                    <cbc:ID></cbc:ID>
                                    <cbc:CurrencyCode>#get_invoice.currency_code#</cbc:CurrencyCode>
                                    <cbc:PaymentNote></cbc:PaymentNote>
                                    <cac:FinancialInstitutionBranch>
                                        <cbc:Name></cbc:Name>
                                        <cac:FinancialInstitution>
                                        	<cbc:Name></cbc:Name>
                                        </cac:FinancialInstitution>
                                    </cac:FinancialInstitutionBranch>
                                </cac:FinancialAccount>
                                <cac:IdentityDocumentReference>
                                    <cbc:ID>#getIIP.PASSNO#</cbc:ID>
                                    <cbc:IssueDate>#dateformat(getIIP.PASSDATE,'yyyy-mm-dd')#</cbc:IssueDate>
                                </cac:IdentityDocumentReference> 
                            </cfif>
                        </cac:Person>
                    </cfif>
                    <cfif len(get_invoice.ship_address_id) and get_invoice.ship_address_id neq -1>
                    <cac:AgentParty>
                        <cac:PartyIdentification>
                            <cfif not get_invoice.is_person><cbc:ID schemeID="VKN">#get_invoice.taxno#</cbc:ID><cfelse><cbc:ID schemeID="TCKN">#get_invoice.tc_identity#</cbc:ID></cfif>
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
            </cac:BuyerCustomerParty>
        </cfif>
    </cfif>
    <cfif get_invoice.IS_CIVIL eq 1 and listfind('KAMU',get_invoice.profile_id)>
        <cac:BuyerCustomerParty>
            <cac:Party>
                <cac:PartyIdentification>
                    <cbc:ID schemeID="VKN">#get_payment_company_info.taxno#</cbc:ID>
                </cac:PartyIdentification>
                <cac:PartyName>
                    <cbc:Name><![CDATA[#get_payment_company_info.fullname#]]></cbc:Name>
                </cac:PartyName>
                <cac:PostalAddress>
                    <cbc:ID/>
                    <cbc:CitySubdivisionName>#get_payment_company_info.county_name#</cbc:CitySubdivisionName>
                    <cbc:CityName>#get_payment_company_info.city_name#</cbc:CityName>
                    <cac:Country>
                        <cbc:Name>#get_payment_company_info.country_name#</cbc:Name>
                    </cac:Country>
                </cac:PostalAddress>
                <cac:PartyTaxScheme>
                    <cac:TaxScheme>
                        <cbc:Name>#get_payment_company_info.taxoffice#</cbc:Name>
                    </cac:TaxScheme>
                </cac:PartyTaxScheme>
                <cac:Contact>
                    <cbc:Telephone/>
                </cac:Contact>
            </cac:Party>
        </cac:BuyerCustomerParty>
    </cfif>

	<cfif len(get_invoice.due_date) and get_invoice.IS_CIVIL neq 1>
		<cac:PaymentMeans>
			<cbc:PaymentMeansCode>#get_invoice.payment_means_code#</cbc:PaymentMeansCode>
			<cbc:PaymentDueDate>#dateformat(get_invoice.due_date,'yyyy-mm-dd')#</cbc:PaymentDueDate>
            <cfif len(get_invoice.paymethod)><cbc:InstructionNote><![CDATA[#get_invoice.paymethod#]]></cbc:InstructionNote></cfif>
            <cfif isdefined("get_owner_customer_no") and isdefined("get_invoice.BANK_ID") And get_invoice.BANK_ID Gt 0>
                <cac:PayeeFinancialAccount>
                    <cbc:ID>#get_owner_customer_no.ACCOUNT_OWNER_CUSTOMER_NO#</cbc:ID>
                    <cbc:CurrencyCode>#get_invoice.currency_code#</cbc:CurrencyCode>
                </cac:PayeeFinancialAccount>
            </cfif>
        </cac:PaymentMeans>
    <cfelseif get_invoice.IS_CIVIL eq 1 and listfind('KAMU',get_invoice.profile_id) and isdefined("get_owner_customer_no") and isdefined("get_invoice.BANK_ID") and get_invoice.BANK_ID Gt 0>
        <cac:PaymentMeans>
            <cbc:PaymentMeansCode>#get_invoice.payment_means_code#</cbc:PaymentMeansCode>
            <cac:PayeeFinancialAccount>
                <cbc:ID>#get_owner_customer_no.ACCOUNT_OWNER_CUSTOMER_NO#</cbc:ID>
                <cbc:CurrencyCode>#get_invoice.currency_code#</cbc:CurrencyCode>
            </cac:PayeeFinancialAccount>
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
    <cac:TaxTotal>
        <cbc:TaxAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice.taxtotal,"_.00")#</cbc:TaxAmount>
		<cfloop query="get_invoice_kdv">
        <cac:TaxSubtotal>
            <cfif get_invoice_kdv.type Eq 2>
                <cbc:TaxableAmount currencyID="#get_invoice.currency_code#">#NumberFormat((get_invoice_kdv.nettotal - get_invoice.sa_discount) + get_invoice.OTV_TOTAL,round_format)#</cbc:TaxableAmount>
            <cfelse>
                <cbc:TaxableAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_kdv.nettotal - get_invoice.sa_discount,round_format)#</cbc:TaxableAmount>
            </cfif>
            <cbc:TaxAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_kdv.tax_amount,round_format)#</cbc:TaxAmount>
            <cbc:Percent>#get_invoice_kdv.tax#</cbc:Percent>
			<cac:TaxCategory>
			<cfif (temp_InvoiceTypeCode eq 'ISTISNA' and get_invoice_kdv.tax eq 0) Or (temp_InvoiceTypeCode Eq 'IHRACKAYITLI')>
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
        <cbc:LineExtensionAmount currencyID="#get_invoice.currency_code#">#NumberFormat(LegalMonetaryTotal.LineExtensionAmount,round_format)#</cbc:LineExtensionAmount>
        <cbc:TaxExclusiveAmount currencyID="#get_invoice.currency_code#">#NumberFormat(LegalMonetaryTotal.TaxExclusiveAmount,round_format)#</cbc:TaxExclusiveAmount>
        <cbc:TaxInclusiveAmount currencyID="#get_invoice.currency_code#">#NumberFormat(LegalMonetaryTotal.TaxInclusiveAmount,round_format)#</cbc:TaxInclusiveAmount>
        <cbc:AllowanceTotalAmount currencyID="#get_invoice.currency_code#">#NumberFormat(LegalMonetaryTotal.AllowanceTotalAmount,round_format)#</cbc:AllowanceTotalAmount>
        <cbc:PayableAmount currencyID="#get_invoice.currency_code#"><cfif listfind('BEDELSIZIHRACAT',get_invoice.profile_id)>0.00<cfelse>#NumberFormat(LegalMonetaryTotal.PayableAmount,round_format)#</cfif></cbc:PayableAmount>
    </cac:LegalMonetaryTotal>
    <cfloop query="get_invoice_row">
    <cac:InvoiceLine>
        <cbc:ID>#get_invoice_row.currentrow#</cbc:ID>
        <cbc:Note><cfif isdefined("InvoiceLineNote")><![CDATA[#trim(get_invoice_row.product_name2)#]]><cfelseif isdefined("InvoiceLineAmount2")>#get_invoice_row.amount2#</cfif></cbc:Note>
        <cbc:InvoicedQuantity unitCode="#get_invoice_row.unit_code#"><cfif isdefined('xml_get_unit2') and xml_get_unit2 eq 1>#get_invoice_row.amount2#<cfelse>#get_invoice_row.amount#</cfif></cbc:InvoicedQuantity>
        <cbc:LineExtensionAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_row.nettotal,"_.00")#</cbc:LineExtensionAmount>
        <cfif listfind('IHRACAT,BEDELSIZIHRACAT',get_invoice.profile_id)>
		<cac:Delivery>
			<cac:DeliveryAddress><!-- Eşyanın teslim ve bedelinin ödeme yeri -->
				<cbc:ID/>
				<cbc:CitySubdivisionName>#get_invoice_row.delivery_county#</cbc:CitySubdivisionName>
				<cbc:CityName>#get_invoice_row.delivery_city#</cbc:CityName>
				<cac:Country>
					<cbc:Name>#get_invoice_row.delivery_country#</cbc:Name>
				</cac:Country>
			</cac:DeliveryAddress>
			<cac:DeliveryTerms>
				<cbc:ID schemeID="INCOTERMS">#get_invoice_row.delivery_condition#</cbc:ID> <!-- Teslim Şartı -->
			</cac:DeliveryTerms>
			<cac:Shipment>
				<cbc:ID>1</cbc:ID>
				<cac:GoodsItem>
					<cbc:RequiredCustomsID>#get_invoice_row.gtip_number#</cbc:RequiredCustomsID><!-- GTİP No -->
				</cac:GoodsItem>
				<cac:ShipmentStage>
					<cbc:TransportModeCode>#get_invoice_row.delivery_type#</cbc:TransportModeCode><!-- Eşyanın gönderilme şekli -->
				</cac:ShipmentStage>
				<cac:TransportHandlingUnit>
					<cac:ActualPackage>
						<cbc:ID>#get_invoice_row.container_number#</cbc:ID><!-- Eşyanın bulunduğu kabın numarası,seçimlidir -->
						<cbc:Quantity>#get_invoice_row.container_quantity#</cbc:Quantity><!-- Eşyanın bulunduğu kabın adedi,seçimlidir -->
						<cbc:PackagingTypeCode>#get_invoice_row.container_type#</cbc:PackagingTypeCode><!-- Eşyanın bulunduğu kabın cinsi/nevi ,seçimlidir-->
					</cac:ActualPackage>
				</cac:TransportHandlingUnit>
			</cac:Shipment>
		</cac:Delivery>
        </cfif>
        <cfif len(discounttotal) and discounttotal neq 0>
            <cac:AllowanceCharge>
                <cbc:ChargeIndicator>false</cbc:ChargeIndicator><!--- Zorunlu - Iskonto ise “false”, artırım ise “true” ---><cfif isdefined('temp_charge_reason')>
                <cbc:AllowanceChargeReason>ISK:<cfloop from="1" to="5" index="reason_i">#evaluate('get_invoice_row.discount#reason_i#')#!##</cfloop></cbc:AllowanceChargeReason></cfif>	
                <cbc:MultiplierFactorNumeric>#NumberFormat(((100*get_invoice_row.discounttotal)/(get_invoice_row.price*get_invoice_row.amount)/100),"_.0000")#</cbc:MultiplierFactorNumeric><!--- Seçimli - Iskonto/ Artırım Oranı --->
                <cbc:Amount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_row.discounttotal,"_.00")#</cbc:Amount>
                <cbc:BaseAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_row.price*get_invoice_row.amount,"_.00")#</cbc:BaseAmount><!--- Seçimli - İskonto veya artırımın uygulandığı tutar --->
            </cac:AllowanceCharge>
        </cfif>
        <cfquery name="get_tax_rows" dbtype="query">
        	SELECT * FROM GET_INVOICE_TAX_ROW WHERE INVOICE_ROW_ID = #get_invoice_row.invoice_row_id#
		</cfquery>
        <cfif isdefined('xml_get_unit2') and xml_get_unit2 eq 1 and len(get_invoice_row.amount2)><cfset satir_toplam = get_invoice_row.price * get_invoice_row.amount><cfset price2 = satir_toplam / get_invoice_row.amount2><cfelse><cfset price2 = 0></cfif>
        <cac:TaxTotal><!--- tax amount virgülden sonra 4hane 2 haneye düşürüldü py --->
            <cbc:TaxAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_row.taxtotal,"_.00")#</cbc:TaxAmount>
            <cfloop query="get_tax_rows">
            <cac:TaxSubtotal>
                <cbc:TaxableAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_invoice_row.nettotal,"_.00")#</cbc:TaxableAmount>
                <cbc:TaxAmount currencyID="#get_invoice.currency_code#">#NumberFormat(get_tax_rows.tax_total,"_.00")#</cbc:TaxAmount>
                <cbc:CalculationSequenceNumeric>#get_tax_rows.type#</cbc:CalculationSequenceNumeric>
                <cbc:Percent>#get_tax_rows.tax#</cbc:Percent>
                <cac:TaxCategory>
            	<cfif (temp_InvoiceTypeCode eq 'ISTISNA' and get_tax_rows.tax eq 0) Or (temp_InvoiceTypeCode Eq 'IHRACKAYITLI')>
                	<cbc:TaxExemptionReasonCode>#get_tax_rows.reason_code#</cbc:TaxExemptionReasonCode>
                    <cbc:TaxExemptionReason>#get_tax_rows.reason_name#</cbc:TaxExemptionReason>
                <cfelseif get_tax_rows.tax_total eq 0>
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
        <cac:Item>
            <cbc:Description><![CDATA[#trim(get_invoice_row.product_name2)#]]></cbc:Description>
            <cbc:Name><![CDATA[#trim(get_invoice_row.name_product)#]]></cbc:Name>
            <cfif isdefined('temp_is_stock_code') and len(get_invoice_row.product_code)>
                <cac:SellersItemIdentification>
                    <cbc:ID><![CDATA[#trim(get_invoice_row.product_code)#]]></cbc:ID>
                </cac:SellersItemIdentification>
            </cfif>
            <cfif isdefined("get_invoice_row.product_code_2") and len(get_invoice_row.product_code_2)>
                <cac:SellersItemIdentification>
                    <cbc:ID><![CDATA[#trim(get_invoice_row.product_code_2)#]]></cbc:ID>
                </cac:SellersItemIdentification>
            </cfif>
            <cfif isdefined("get_invoice_row.company_stock_code") and Len(get_invoice_row.company_stock_code)>
                <cac:BuyersItemIdentification>
                    <cbc:ID><![CDATA[#trim(get_invoice_row.company_stock_code)#]]></cbc:ID>
                </cac:BuyersItemIdentification>
            </cfif>
            <cfif get_our_company.einvoice_type_alias eq 'dp' or get_our_company.einvoice_type_alias eq 'dgn'>
                <cfif isdefined('get_invoice_row.weight') and len(get_invoice_row.weight)>
                    <cbc:Keyword><![CDATA[#trim(get_invoice_row.weight)#]]></cbc:Keyword>        
                </cfif> 
            </cfif>
            <cfif isdefined('temp_is_barcod') and len(get_invoice_row.barcod)>
                <cac:ManufacturersItemIdentification>
                    <cbc:ID><![CDATA[#trim(get_invoice_row.barcod)#]]></cbc:ID>
                </cac:ManufacturersItemIdentification>
            </cfif>
            <cfif get_our_company.einvoice_type_alias eq 'dp' or get_our_company.einvoice_type_alias eq 'spr'>
                <cfif isdefined("get_invoice_row.company_stock_code") and Len(get_invoice_row.company_stock_code)>
                    <cac:ItemInstance>
                        <cbc:ProductTraceID><![CDATA[#trim(get_invoice_row.company_stock_code)#]]></cbc:ProductTraceID>
                        <cbc:AdditionalItemProperty><![CDATA[#trim(get_invoice_row.stock_code)#]]></cbc:AdditionalItemProperty>
                    </cac:ItemInstance> 
                </cfif>
                <cfif get_invoice.IS_CIVIL eq 1 and listfind('KAMU',get_invoice.profile_id) and len(get_invoice_row.ORIGIN_ID) and len(get_invoice_row.COUNTRY_CODE)>
                    <cac:OriginCountry>
                        <cbc:IdentificationCode><![CDATA[#trim(get_invoice_row.COUNTRY_CODE)#]]></cbc:IdentificationCode>
                        <cbc:Name><![CDATA[#trim(get_invoice_row.COUNTRY_NAME)#]]></cbc:Name>
                    </cac:OriginCountry>
                </cfif>
                <cfif get_invoice.IS_CIVIL eq 1 and listfind('KAMU',get_invoice.profile_id) and len(get_invoice_row.gtip_number)>
                    <cac:CommodityClassification>
                        <cbc:ItemClassificationCode listName="CPA" listVersionID="Rev.2.1">#get_invoice_row.gtip_number#</cbc:ItemClassificationCode>
                    </cac:CommodityClassification>     
                </cfif>
            </cfif>
        </cac:Item>
        <cac:Price> 
            <cbc:PriceAmount currencyID="#get_invoice.currency_code#"><cfif isdefined('xml_get_unit2') and xml_get_unit2 eq 1>#NumberFormat(price2,round_format)#<cfelse>#NumberFormat(get_invoice_row.price,round_format)#</cfif></cbc:PriceAmount><!--- Zorunlu - Mal/hizmetin birim fiyatı girilir. --->
        </cac:Price>
    </cac:InvoiceLine>
    </cfloop>
</Invoice>
</cfoutput>	
</cfsavecontent>