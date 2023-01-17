<cfset save_folder      = "#upload_folder#e_government#dir_seperator#xslt#dir_seperator#" />
<cfset old_save_folder  = "#index_folder#objects#dir_seperator#xslt#dir_seperator#" />

<cfif len(getCompInfo.template_filename_base64)><!--- ozel sablon dosyasi--->
    <cfif fileExists('#save_folder##getCompInfo.template_filename_base64#')>
        <cfset preview_producer_template     = 'documents/e_government/xslt/#getCompInfo.template_filename#' />
        <cfset temp_eproducer_template_base64= FileRead("#save_folder##getCompInfo.template_filename_base64#","utf-8") />
    <cfelse>
        <cfthrow type="Application" errorcode="FileNotFound" message="Şablon Dosyası Bulunamadı" detail="Özel Şablon Dosyası Bulunamadı" />
    </cfif>
<cfelse>
    <cfset preview_producer_template = 'V16/objects/xslt/eproducer_template.xslt' />
    <cfset temp_eproducer_template_base64= FileRead("#old_save_folder#eproducer_template_base64.xslt","utf-8")>
</cfif>
<cfsavecontent variable="eproducer_data">
    <cfoutput>
    <CreditNote xmlns="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" 
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" 
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" 
    xmlns:ds="http://www.w3.org/2000/09/xmldsig##" xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" 
    xmlns:ns10="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2" 
    xmlns:ns11="urn:oasis:names:specification:ubl:schema:xsd:ReceiptAdvice-2" 
    xmlns:ns8="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2" xmlns:ns9="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2" xmlns:xades="http://uri.etsi.org/01903/v1.3.2##" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2 UBL-CreditNote-2.1.xsd">
	<ext:UBLExtensions>
		<ext:UBLExtension>
			<ext:ExtensionContent>
			</ext:ExtensionContent>
		</ext:UBLExtension>
	</ext:UBLExtensions>
	<cbc:UBLVersionID>2.1</cbc:UBLVersionID>
	<cbc:CustomizationID>TR1.2.1</cbc:CustomizationID>
	<cbc:ProfileID>EARSIVBELGE</cbc:ProfileID>
	<cbc:ID>#producer_receipt_number#</cbc:ID>
	<cbc:CopyIndicator>false</cbc:CopyIndicator>
	<cbc:UUID>#GUIDStr#</cbc:UUID>
	<cbc:IssueDate>#dateformat(now(),'yyyy-mm-dd')#</cbc:IssueDate>
	<cbc:IssueTime>#timeformat(dateadd('h',session.ep.time_zone-2,now()),'HH:MM:SS')#</cbc:IssueTime>
    <cfif Len(get_producer.note)><cbc:Note>#HTMLEditFormat(trim(get_producer.note))#</cbc:Note></cfif>
	<cbc:LineCountNumeric>#get_producer_row.recordcount#</cbc:LineCountNumeric>
	<cac:AdditionalDocumentReference>
		<cbc:ID>#producer_receipt_number#</cbc:ID>
		<cbc:IssueDate>#dateformat(get_producer.invoice_date,'yyyy-mm-dd')#</cbc:IssueDate>
		<cbc:DocumentType>XSLT</cbc:DocumentType>
		<cac:Attachment>
			<cbc:EmbeddedDocumentBinaryObject characterSetCode="UTF-8" encodingCode="Base64" filename="#producer_receipt_number#.xslt" mimeCode="application/xml">#temp_eproducer_template_base64#</cbc:EmbeddedDocumentBinaryObject>
		</cac:Attachment>
	</cac:AdditionalDocumentReference>
	<cac:Signature>
		<cbc:ID schemeID="VKN_TCKN">#getCompAddress.TAX_NO#</cbc:ID>
		<cac:SignatoryParty>
			<cac:PartyIdentification>
				<cbc:ID schemeID="VKN">#getCompAddress.TAX_NO#</cbc:ID>
			</cac:PartyIdentification>
			<cac:PartyName>
				<cbc:Name></cbc:Name>
			</cac:PartyName>
			<cac:PostalAddress>
				<cbc:BuildingNumber>#getCompAddress.BUILDING_NUMBER#</cbc:BuildingNumber>
				<cbc:CitySubdivisionName>#getCompAddress.COUNTY_NAME#</cbc:CitySubdivisionName>
				<cbc:CityName>#getCompAddress.CITY_NAME#</cbc:CityName>
				<cbc:PostalZone>#getCompAddress.POSTAL_CODE#</cbc:PostalZone>
				<cac:Country>
					<cbc:Name>#getCompAddress.COUNTRY_NAME#</cbc:Name>
				</cac:Country>
			</cac:PostalAddress>
		</cac:SignatoryParty>
		<cac:DigitalSignatureAttachment>
			<cac:ExternalReference>
				<cbc:URI>##Signature_#producer_receipt_number#</cbc:URI>
			</cac:ExternalReference>
		</cac:DigitalSignatureAttachment>
	</cac:Signature>
	<cac:AccountingSupplierParty>
		<cac:Party>
            <cfif len(getCompInfo.mersis_no)>
            <cac:PartyIdentification>
                <cbc:ID schemeID="MERSISNO">#getCompInfo.mersis_no#</cbc:ID>
            </cac:PartyIdentification>
            </cfif>
			<cac:PartyIdentification>
				<cbc:ID schemeID="VKN">#getCompInfo.tax_no#</cbc:ID>
			</cac:PartyIdentification>
            <cfif len(getCompInfo.t_no)>
            <cac:PartyIdentification>
                <cbc:ID schemeID="TICARETSICILNO">#getCompInfo.t_no#</cbc:ID>            
            </cac:PartyIdentification>
            </cfif>
			<cac:PartyName>
				<cbc:Name>#HTMLEditFormat(trim(getCompAddress.COMPANY_NAME))#</cbc:Name>
			</cac:PartyName>
			<cac:PostalAddress>
				<cbc:Room/>
				<cbc:StreetName>#HTMLEditFormat(getCompAddress.DISTRICT_NAME)# #HTMLEditFormat(getCompAddress.STREET_NAME)#</cbc:StreetName>
				<cbc:BuildingNumber>#getCompAddress.BUILDING_NUMBER#</cbc:BuildingNumber>
				<cbc:CitySubdivisionName>#getCompAddress.COUNTY_NAME#</cbc:CitySubdivisionName>
				<cbc:CityName>#getCompAddress.CITY_NAME#</cbc:CityName>
				<cbc:PostalZone>#getCompAddress.POSTAL_CODE#</cbc:PostalZone>
				<cac:Country>
					<cbc:Name>#getCompAddress.COUNTRY_NAME#</cbc:Name>
				</cac:Country>
			</cac:PostalAddress>
			<cac:PartyTaxScheme>
				<cac:TaxScheme>
					<cbc:Name>#getCompAddress.tax_office#</cbc:Name>
				</cac:TaxScheme>
			</cac:PartyTaxScheme>
		</cac:Party>
	</cac:AccountingSupplierParty>
	<cac:AccountingCustomerParty>
		<cac:Party>
			<cbc:WebsiteURI></cbc:WebsiteURI>
			<cac:PartyIdentification>
				<cbc:ID schemeID="TCKN">#get_producer.TC_IDENTITY#</cbc:ID>
			</cac:PartyIdentification>
            <cfif len(get_producer.compbranch_code)>
                <cac:PartyIdentification>
                    <cbc:ID schemeID="BAYINO">#get_producer.compbranch_code# <cfif len(get_producer.compbranch__name)>/ #get_producer.compbranch__name#</cfif></cbc:ID>               
                </cac:PartyIdentification>
            </cfif>
            <cac:PartyName>
                <cbc:Name>#HTMLEditFormat(get_producer.fullname)#</cbc:Name>
            </cac:PartyName>
			<cac:PostalAddress>
				<cbc:Room/>
				<cbc:StreetName>#HTMLEditFormat(get_producer.address)#</cbc:StreetName>
				<cbc:BuildingName></cbc:BuildingName>
				<cbc:BuildingNumber></cbc:BuildingNumber>
				<cbc:CitySubdivisionName>#get_producer.county_name#</cbc:CitySubdivisionName>
				<cbc:CityName>#get_producer.city_name#</cbc:CityName>
				<cbc:PostalZone>#get_producer.company_postcode#</cbc:PostalZone>
				<cac:Country>
					<cbc:Name>#get_producer.country_name#</cbc:Name>
				</cac:Country>
			</cac:PostalAddress>
			<cac:Contact>
				<cbc:Telephone>(#get_producer.COMPANY_TELCODE#) #get_producer.company_tel#</cbc:Telephone>
			</cac:Contact>
			<cac:Person>
				<cbc:FirstName>#HTMLEditFormat(get_producer.COMPANY_PARTNER_NAME)#</cbc:FirstName>
				<cbc:FamilyName>#HTMLEditFormat(get_producer.COMPANY_PARTNER_SURNAME)#</cbc:FamilyName>
			</cac:Person>
		</cac:Party>
	</cac:AccountingCustomerParty>
	<cac:Delivery/>
	<cac:TaxTotal>
		<cbc:TaxAmount currencyID="#get_producer.currency_code#">#NumberFormat(get_producer.taxtotal,"_.00")#</cbc:TaxAmount>
        <cfloop query="get_producer_kdv">
            <cac:TaxSubtotal>
                <cbc:TaxableAmount currencyID="#get_producer.currency_code#">#NumberFormat(get_producer_kdv.nettotal - get_producer.sa_discount,"_.00")#</cbc:TaxableAmount>
                <cbc:TaxAmount currencyID="#get_producer.currency_code#">#NumberFormat(get_producer_kdv.tax_amount,"_.00")#</cbc:TaxAmount>
                <cbc:Percent>#get_producer_kdv.tax#</cbc:Percent>
                <cac:TaxCategory>
                    <cac:TaxScheme>
                        <cbc:Name>#get_producer_kdv.tax_code_name#</cbc:Name>
                        <cbc:TaxTypeCode>#get_producer_kdv.tax_code#</cbc:TaxTypeCode>
                    </cac:TaxScheme>
                </cac:TaxCategory>
            </cac:TaxSubtotal>
        </cfloop>
	</cac:TaxTotal>
	<cac:LegalMonetaryTotal>
		<cbc:LineExtensionAmount currencyID="#get_producer.currency_code#">#NumberFormat(LegalMonetaryTotal.LineExtensionAmount,"_.00")#</cbc:LineExtensionAmount>
		<cbc:TaxExclusiveAmount currencyID="#get_producer.currency_code#">#NumberFormat(LegalMonetaryTotal.TaxExclusiveAmount,"_.00")#</cbc:TaxExclusiveAmount>
		<cbc:TaxInclusiveAmount currencyID="#get_producer.currency_code#">#NumberFormat(LegalMonetaryTotal.TaxInclusiveAmount,"_.00")#</cbc:TaxInclusiveAmount>
		<cbc:PayableAmount currencyID="#get_producer.currency_code#">#NumberFormat(LegalMonetaryTotal.PayableAmount,"_.00")#</cbc:PayableAmount>
	</cac:LegalMonetaryTotal>
    <cfloop query="get_producer_row">
        <cac:CreditNoteLine>
            <cbc:ID>#get_producer_row.currentrow#</cbc:ID>
            <cbc:CreditedQuantity unitCode="#get_producer_row.unit_code#">#get_producer_row.amount#</cbc:CreditedQuantity>
            <cbc:LineExtensionAmount currencyID="#get_producer.currency_code#">#NumberFormat(get_producer_row.nettotal,"_.00")#</cbc:LineExtensionAmount>
            <cfquery name="get_tax_rows" dbtype="query">
                SELECT * FROM get_producer_tax_row WHERE INVOICE_ROW_ID = #get_producer_row.invoice_row_id#
            </cfquery>
            <cac:TaxTotal>
                <cbc:TaxAmount currencyID="#get_producer.currency_code#">#NumberFormat(get_producer_row.taxtotal,"_.00")#</cbc:TaxAmount>
                <cfloop query="get_tax_rows">
                    <cac:TaxSubtotal>
                        <cbc:TaxableAmount currencyID="#get_producer.currency_code#">#NumberFormat(get_producer_row.nettotal,"_.00")#</cbc:TaxableAmount>
                        <cbc:TaxAmount currencyID="#get_producer.currency_code#">#NumberFormat(get_tax_rows.tax_total,"_.00")#</cbc:TaxAmount>
                        <cbc:Percent>#get_tax_rows.tax#</cbc:Percent>
                        <cac:TaxCategory>
                            <cac:TaxScheme>
                                <cbc:Name>#get_tax_rows.tax_code_name#</cbc:Name>
                                <cbc:TaxTypeCode>#get_tax_rows.tax_code#</cbc:TaxTypeCode>
                            </cac:TaxScheme>
                        </cac:TaxCategory>
                    </cac:TaxSubtotal>
                </cfloop>
            </cac:TaxTotal>
            <cac:Item>
                <cbc:Name>#HTMLEditFormat(get_producer_row.name_product)#</cbc:Name>
            </cac:Item>
            <cac:Price>
                <cbc:PriceAmount currencyID="#get_producer.currency_code#">#NumberFormat(get_producer_row.price,"_.00000")#</cbc:PriceAmount>
            </cac:Price>
        </cac:CreditNoteLine>
    </cfloop>
    </CreditNote>
    </cfoutput>
</cfsavecontent>