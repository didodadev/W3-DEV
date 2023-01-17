<cfset uuidLibObj = createobject("java", "java.util.UUID")>
<cfset GUIDStr = uuidLibObj.randomUUID().toString()>
<cfset get_ship_number = eshipment.GetShipNumber()>

<cfset shipment_number = "#get_ship_number.eshipment_prefix##session.ep.period_year#0#left('00000000',8-len(get_ship.ship_id))##get_ship.ship_id#">
<cfsavecontent variable="eshipment_data"><cfoutput>
<ReceiptAdvice xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:ReceiptAdvice-2 ../xsdrt/maindoc/UBL-ReceiptAdvice-2.1.xsd"
    xmlns="urn:oasis:names:specification:ubl:schema:xsd:ReceiptAdvice-2"
    xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    xmlns:n4="http://www.altova.com/samplexml/other-namespace">
	<ext:UBLExtensions>
		<ext:UBLExtension>
			<ext:ExtensionContent/>
		</ext:UBLExtension>
	</ext:UBLExtensions>
	<cbc:UBLVersionID>2.1</cbc:UBLVersionID>
	<cbc:CustomizationID>TR1.2.1</cbc:CustomizationID>
	<cbc:ProfileID>TEMELIRSALIYE</cbc:ProfileID>
	<cbc:ID>#shipment_number#</cbc:ID>
	<cbc:CopyIndicator>false</cbc:CopyIndicator>
	<cbc:UUID>#GUIDStr#</cbc:UUID>
	<cbc:IssueDate>#dateformat(now(),'yyyy-mm-dd')#</cbc:IssueDate>
	<cbc:IssueTime>#timeformat(dateadd('h',session.ep.time_zone-2,now()),'HH:MM:SS')#</cbc:IssueTime>
	<cbc:ReceiptAdviceTypeCode>SEVK</cbc:ReceiptAdviceTypeCode>
	<cbc:Note>Bütün ürünler kabul edildi.</cbc:Note>
	<cac:AdditionalDocumentReference>
		<cbc:ID>#GET_ESHIPMENT_DET.ESHIPMENT_ID#</cbc:ID> <!-- Yanıt olarak verilen irsaliye ID -->
		<cbc:IssueDate>#dateformat(GET_ESHIPMENT_DET.ISSUE_DATE,'yyyy-mm-dd')#</cbc:IssueDate> <!-- Yanıt olarak verilen irsaliyenin tarihi -->
		<cbc:DocumentTypeCode>DespatchAdviceID</cbc:DocumentTypeCode> <!-- Referansın irsaliye ID ile ilgili olduğunu gösteren kod -->
		<cbc:DocumentType>DespatchAdviceID</cbc:DocumentType>
	</cac:AdditionalDocumentReference>
	<cac:Signature>
		<cbc:ID schemeID="VKN_TCKN">#getCompAddress.TAX_NO#</cbc:ID>
		<cac:SignatoryParty>
			<cac:PartyIdentification>
				<cbc:ID schemeID="VKN">#getCompAddress.TAX_NO#</cbc:ID>
			</cac:PartyIdentification>
			<cac:PostalAddress>
				<cbc:StreetName>#HTMLEditFormat(getCompAddress.DISTRICT_NAME)# #HTMLEditFormat(getCompAddress.STREET_NAME)#</cbc:StreetName>
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
				<cbc:URI>##Signature_#shipment_number#</cbc:URI>
			</cac:ExternalReference>
		</cac:DigitalSignatureAttachment>
	</cac:Signature>
	<cac:DeliveryCustomerParty>
		<cac:Party>
			<cbc:WebsiteURI>#getCompAddress.WEB#</cbc:WebsiteURI>
			<cac:PartyIdentification>
				<cbc:ID schemeID="VKN">#getCompAddress.TAX_NO#</cbc:ID>
			</cac:PartyIdentification>
			<cfif len(getCompAddress.T_NO)>
				<cac:PartyIdentification>
					<cbc:ID schemeID="TICARETSICILNO">#getCompAddress.T_NO#</cbc:ID>            
				</cac:PartyIdentification>
			</cfif>
			<cfif len(getCompAddress.MERSIS_NO)>
				<cac:PartyIdentification>
					<cbc:ID schemeID="MERSISNO">#getCompAddress.MERSIS_NO#</cbc:ID>           
				</cac:PartyIdentification>
			</cfif>
			<cac:PartyName>
				<cbc:Name>#HTMLEditFormat(trim(getCompAddress.COMPANY_NAME))#</cbc:Name>
			</cac:PartyName>
			<cac:PostalAddress>
                <cbc:ID>#getCompAddress.TAX_NO#</cbc:ID>
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
					<cbc:Name>#getCompAddress.TAX_OFFICE#</cbc:Name>
				</cac:TaxScheme>
			</cac:PartyTaxScheme>
			<cac:Contact>
                <cbc:Telephone>(#getCompAddress.TEL_CODE#) #getCompAddress.TEL#</cbc:Telephone>
                <cbc:Telefax>(#getCompAddress.TEL_CODE#) #getCompAddress.FAX#</cbc:Telefax>
                <cbc:ElectronicMail>#getCompAddress.EMAIL#</cbc:ElectronicMail>
			</cac:Contact>
		</cac:Party>
		<cac:DeliveryContact>
			<cbc:Name></cbc:Name>
		</cac:DeliveryContact>			
	</cac:DeliveryCustomerParty>
	<cac:DespatchSupplierParty>
		<cac:Party>
			<cbc:WebsiteURI/>
			<cac:PartyIdentification>
                <cfif not get_ship.is_person>
                    <cbc:ID schemeID="VKN">#get_ship.TAXNO#</cbc:ID>
                <cfelse>
                    <cbc:ID schemeID="TCKN"><cfif len(get_ship.TC_IDENTITY)>#get_ship.TC_IDENTITY#<cfelse>11111111111</cfif></cbc:ID>
                </cfif>
            </cac:PartyIdentification>
			<cac:PartyName>
                <cbc:Name>#HTMLEditFormat(get_ship.fullname)#</cbc:Name>
            </cac:PartyName> 
			<cac:PostalAddress>
                <cbc:ID>1234567890</cbc:ID>
                <cbc:StreetName>#HTMLEditFormat(trim(get_ship.address))#</cbc:StreetName>
                <cbc:BuildingNumber></cbc:BuildingNumber>
                <cbc:CitySubdivisionName>#get_ship.county_name#</cbc:CitySubdivisionName>
                <cbc:CityName>#get_ship.city_name#</cbc:CityName>
                <cbc:PostalZone>#get_ship.company_postcode#</cbc:PostalZone>
                <cac:Country>
                    <cbc:Name>#get_ship.country_name#</cbc:Name>
                </cac:Country>
            </cac:PostalAddress>
			<cac:PhysicalLocation>
                <cbc:ID>#HTMLEditFormat(get_ship.COMPBRANCH__NAME)#</cbc:ID>
                <cac:Address>
                    <cbc:ID>#get_ship.CBID#</cbc:ID>
                    <cbc:StreetName>#HTMLEditFormat(get_ship.ADDRESS2)#</cbc:StreetName>
                    <cbc:BuildingNumber></cbc:BuildingNumber>
                    <cbc:CitySubdivisionName>#get_ship.COUNTY_NAME2#</cbc:CitySubdivisionName>
                    <cbc:CityName>#get_ship.CITY_NAME2#</cbc:CityName>
                    <cbc:PostalZone>#get_ship.COMPANY_POSTCODE2#</cbc:PostalZone>
                    <cac:Country>
                        <cbc:Name>#get_ship.COUNTRY_NAME2#</cbc:Name>
                    </cac:Country>
                </cac:Address>
            </cac:PhysicalLocation>
            <cac:PartyTaxScheme>
                <cac:TaxScheme>
                    <cbc:Name>#get_ship.taxoffice#</cbc:Name>
                </cac:TaxScheme>
            </cac:PartyTaxScheme>
			<cac:Contact>
                <cbc:Telephone>(#get_ship.TEL_CODE_2#) #get_ship.TEL_2#</cbc:Telephone>
                <cbc:Telefax>(#get_ship.TEL_CODE_2#) #get_ship.FAX_2#</cbc:Telefax>
                <cbc:ElectronicMail>#get_ship.EMAIL_2#</cbc:ElectronicMail>
            </cac:Contact>
		</cac:Party>
		<cac:DespatchContact>
			<cbc:Name></cbc:Name>
		</cac:DespatchContact>
	</cac:DespatchSupplierParty>
	<cac:Shipment>
		<cbc:ID></cbc:ID>
		<cac:Delivery>
			<cbc:ActualDeliveryDate>#dateformat(now(),'yyyy-mm-dd')#</cbc:ActualDeliveryDate>
			<cbc:ActualDeliveryTime>#timeformat(dateadd('h',session.ep.time_zone-2,now()),'HH:MM:SS')#</cbc:ActualDeliveryTime>
		</cac:Delivery>
	</cac:Shipment>
    <cfloop query="get_ship_row">
        <cac:ReceiptLine>
            <cbc:ID>#get_ship_row.currentrow#</cbc:ID>
            <cbc:ReceivedQuantity unitCode="#get_ship_row.UNIT_CODE#">#get_ship_row.AMOUNT#</cbc:ReceivedQuantity>
            <cac:OrderLineReference>
                <cbc:LineID>#get_ship_row.currentrow#</cbc:LineID>
            </cac:OrderLineReference>
            <cac:Item>
                <cbc:Name>#HTMLEditFormat(trim(get_ship_row.name_product))#</cbc:Name>
                <cac:SellersItemIdentification>
                    <cbc:ID>#HTMLEditFormat(trim(get_ship_row.product_code))#</cbc:ID>
                </cac:SellersItemIdentification>
            </cac:Item>
        </cac:ReceiptLine>			
    </cfloop>
</ReceiptAdvice>
</cfoutput>
</cfsavecontent>