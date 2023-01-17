<!--- 
    İlker Altındal 01062020
    e-irsaliye işin ubl giydirme işlemi burada yapilir
--->

<cfset save_folder      = "#upload_folder#e_government#dir_seperator#xslt#dir_seperator#" />
<cfset old_save_folder  = "#index_folder#objects#dir_seperator#xslt#dir_seperator#" />

<cfif len(getCompInfo.template_filename_base64)><!--- ozel sablon dosyasi--->
    <cfif fileExists('#save_folder##getCompInfo.template_filename_base64#')>
        <cfset preview_shipment_template     = 'documents/e_government/xslt/#getCompInfo.template_filename#' />
        <cfset temp_eshipment_template_base64= FileRead("#save_folder##getCompInfo.template_filename_base64#","utf-8") />
    <cfelse>
        <cfthrow type="Application" errorcode="FileNotFound" message="Åžablon dosyasÄ± bulunamadÄ±!" detail="Ã–zel ÅŸablon dosyasÄ± bulunamadÄ±!" />
    </cfif>
<cfelse>
    <cfset preview_shipment_template = 'V16/objects/xslt/eshipment_template.xslt' />
    <cfset temp_eshipment_template_base64= FileRead("#old_save_folder#eshipment_template_base64.xslt","utf-8")>
</cfif>
<cfsavecontent variable="eshipment_data"><cfoutput>
<DespatchAdvice xmlns="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2"
	xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
	xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:DespatchAdvice-2 ../xsdrt/maindoc/UBL-DespatchAdvice-#getCompInfo.UBLVERSIONID#.xsd"
	xmlns:n4="http://www.altova.com/samplexml/other-namespace">
	<ext:UBLExtensions>
		<ext:UBLExtension>
			<ext:ExtensionContent/>
		</ext:UBLExtension>
	</ext:UBLExtensions>
	<cbc:UBLVersionID>#getCompInfo.UBLVERSIONID#</cbc:UBLVersionID>
	<cbc:CustomizationID>#getCompInfo.CUSTOMIZATIONID#</cbc:CustomizationID>
	<cbc:ProfileID>TEMELIRSALIYE</cbc:ProfileID>
	<cbc:ID>#shipment_number#</cbc:ID>
	<cbc:CopyIndicator>false</cbc:CopyIndicator>
	<cbc:UUID>#GUIDStr#</cbc:UUID>
	<cbc:IssueDate>#dateformat(now(),'yyyy-mm-dd')#</cbc:IssueDate>
	<cbc:IssueTime>#timeformat(dateadd('h',session.ep.time_zone-2,now()),'HH:MM:SS')#</cbc:IssueTime>
	<cbc:DespatchAdviceTypeCode>SEVK</cbc:DespatchAdviceTypeCode>
	<cbc:Note>#HTMLEditFormat(get_ship.SHIP_DETAIL)#</cbc:Note>
	<cfif get_ship_orders.recordcount gt 0>
	<cac:OrderReference>
		<cfif len(get_ship_orders.ref_no)>
			<cbc:ID>#valueList(get_ship_orders.ref_no)#</cbc:ID>
		<cfelse>
			<cbc:ID>#valueList(get_ship_orders.order_number)#</cbc:ID>
		</cfif>
		<cbc:IssueDate>#dateformat(get_ship_orders.order_date,'yyyy-mm-dd')#</cbc:IssueDate>
	</cac:OrderReference>
	</cfif>
	<cac:AdditionalDocumentReference>
		<cbc:ID>#shipment_number#</cbc:ID>
		<cbc:IssueDate>#dateformat(get_ship.ship_date,'yyyy-mm-dd')#</cbc:IssueDate>
		<cbc:DocumentType>XSLT</cbc:DocumentType>
		<cac:Attachment><cbc:EmbeddedDocumentBinaryObject mimeCode="application/xml" filename="#shipment_number#.xslt" encodingCode="Base64" characterSetCode="UTF-8">#temp_eshipment_template_base64#</cbc:EmbeddedDocumentBinaryObject>
		</cac:Attachment>
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
	<cac:DespatchSupplierParty>
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
			<cfif action_type is 'SHIP'>
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
				<!--- branch adresi varsa fiziksel lokasyon olarak eklenir --->
				<cfif isDefined("get_ship.DEPO_NAME") and len("#get_ship.DEPO_NAME#")>
				<cac:PhysicalLocation>
					<cbc:ID>#HTMLEditFormat(get_ship.DEPO_NAME)#</cbc:ID>
					<cac:Address>
						<cbc:ID>#get_ship.DEPO_ID#</cbc:ID>
						<cbc:StreetName>#HTMLEditFormat(get_ship.DEPO_ADRES)#</cbc:StreetName>
						<cbc:BuildingNumber></cbc:BuildingNumber>
						<cbc:CitySubdivisionName>#get_ship.DEPO_COUNTY#</cbc:CitySubdivisionName>
						<cbc:CityName>#get_ship.DEPO_CITY#</cbc:CityName>
						<cbc:PostalZone>#get_ship.DEPO_POSTCODE#</cbc:PostalZone>
						<cac:Country>
							<cbc:Name>#get_ship.DEPO_COUNTRY#</cbc:Name>
						</cac:Country>
					</cac:Address>
				</cac:PhysicalLocation>
				</cfif>
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
			<cfelse>
				<cac:PostalAddress>
					<cbc:ID>#getCompAddress.TAX_NO#</cbc:ID>
					<cbc:StreetName>#HTMLEditFormat(location_out.BRANCH_ADDRESS)#</cbc:StreetName>
					<!--- <cbc:BuildingNumber></cbc:BuildingNumber> --->
					<cbc:CitySubdivisionName>#location_out.BRANCH_COUNTY#</cbc:CitySubdivisionName>
					<cbc:CityName>#location_out.BRANCH_CITY#</cbc:CityName>
					<cbc:PostalZone>#location_out.BRANCH_POSTCODE#</cbc:PostalZone>
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
					<cbc:Telephone>(#location_out.BRANCH_TELCODE#) #location_out.BRANCH_TEL1#</cbc:Telephone>
					<cbc:Telefax>(#location_out.BRANCH_TELCODE#) #location_out.BRANCH_TEL2#</cbc:Telefax>
					<cbc:ElectronicMail>#location_out.BRANCH_EMAIL#</cbc:ElectronicMail>
				</cac:Contact>
			</cfif>
		</cac:Party>
	</cac:DespatchSupplierParty>
	<cac:DeliveryCustomerParty>
		<cfif action_type is 'SHIP'>
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
				<!--- alıcı depo --->
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
                <cfif get_ship.is_person>
					<cac:Person>
						<cbc:FirstName>#HTMLEditFormat(get_ship.COMPANY_PARTNER_NAME)#</cbc:FirstName>
						<cbc:FamilyName>#HTMLEditFormat(get_ship.COMPANY_PARTNER_SURNAME)#</cbc:FamilyName>
					</cac:Person>
				</cfif>
			</cac:Party>
		<cfelse>
			<cac:Party>
				<cbc:WebsiteURI>#getCompAddress.WEB#</cbc:WebsiteURI>
				<cac:PartyIdentification>
					<cbc:ID schemeID="VKN">#getCompAddress.TAX_NO#</cbc:ID>
				</cac:PartyIdentification>
				<cac:PartyName>
					<cbc:Name>#HTMLEditFormat(trim(getCompAddress.COMPANY_NAME))#</cbc:Name>
				</cac:PartyName>
				<cac:PostalAddress>
					<cbc:ID>#getCompAddress.TAX_NO#</cbc:ID>
					<cbc:StreetName>#HTMLEditFormat(location_in.BRANCH_ADDRESS)#</cbc:StreetName>
					<!--- <cbc:BuildingNumber></cbc:BuildingNumber> --->
					<cbc:CitySubdivisionName>#location_in.BRANCH_COUNTY#</cbc:CitySubdivisionName>
					<cbc:CityName>#location_in.BRANCH_CITY#</cbc:CityName>
					<cbc:PostalZone>#location_in.BRANCH_POSTCODE#</cbc:PostalZone>
					<cac:Country>
						<cbc:Name>#location_in.BRANCH_COUNTRY#</cbc:Name>
					</cac:Country>
				</cac:PostalAddress>
					<cac:PartyTaxScheme>
						<cac:TaxScheme>
							<cbc:Name>#getCompAddress.TAX_OFFICE#</cbc:Name>
						</cac:TaxScheme>
					</cac:PartyTaxScheme>
				<cac:Contact>
					<cbc:Telephone>(#location_in.BRANCH_TELCODE#) #location_in.BRANCH_TEL1#</cbc:Telephone>
					<cbc:Telefax>(#location_in.BRANCH_TELCODE#) #location_in.BRANCH_TEL2#</cbc:Telefax>
					<cbc:ElectronicMail>#location_in.BRANCH_EMAIL#</cbc:ElectronicMail>
				</cac:Contact>
			</cac:Party>
		</cfif>
	</cac:DeliveryCustomerParty>
	<cac:Shipment>
		<cbc:ID>#get_ship_result.SHIP_RESULT_ID#</cbc:ID>
		<cfif len(get_ship_result.PLATE) or len(get_ship_result.EMPLOYEE_NAME)>
		<cac:ShipmentStage>
			<cfif len(get_ship_result.PLATE) or len(get_ship_result.ASSETP)>
			<cac:TransportMeans>
				<cac:RoadTransport>
					<cbc:LicensePlateID schemeID="PLAKA">#len(get_ship_result.ASSETP_ID)?get_ship_result.ASSETP:get_ship_result.PLATE#</cbc:LicensePlateID>
				</cac:RoadTransport>
			</cac:TransportMeans>
			</cfif>
			<cfif len(get_ship_result.EMPLOYEE_NAME)>
			<cac:DriverPerson>
				<cbc:FirstName>#get_ship_result.EMPLOYEE_NAME#</cbc:FirstName>
				<cbc:FamilyName>#get_ship_result.EMPLOYEE_SURNAME#</cbc:FamilyName>
				<cbc:Title>#Replace(get_ship_result.POSITION_NAME,'&','','all')#</cbc:Title>
				<cbc:NationalityID>#get_ship_result.TC_IDENTY_NO#</cbc:NationalityID>
			</cac:DriverPerson>
			<cfelseif len(get_ship_result.DELIVER_EMP_NAME)>
			<cac:DriverPerson>
				<cbc:FirstName>#listFirst(get_ship_result.DELIVER_EMP_NAME, " ")#</cbc:FirstName>
				<cbc:FamilyName>#listLast(get_ship_result.DELIVER_EMP_NAME, " ")#</cbc:FamilyName>
				<cbc:Title>Şoför</cbc:Title>
				<cbc:NationalityID>#get_ship_result.DELIVER_EMP_TC#</cbc:NationalityID>
			</cac:DriverPerson>
			</cfif>
		</cac:ShipmentStage>
		</cfif>
		<cac:Delivery>
			<cac:DeliveryAddress>
				<cbc:StreetName>#HTMLEditFormat(get_ship_result.SENDING_ADDRESS)#</cbc:StreetName>
				<cbc:CitySubdivisionName>#get_ship_result.DELIVERY_COUNTY#</cbc:CitySubdivisionName>
				<cbc:CityName>#get_ship_result.DELIVERY_CITY#</cbc:CityName>
				<cbc:PostalZone>#get_ship_result.SENDING_POSTCODE#</cbc:PostalZone>
				<cac:Country>
					<cbc:Name>#get_ship_result.DELIVERY_COUNTRY#</cbc:Name>
				</cac:Country>
			</cac:DeliveryAddress>
			<cfif getCompInfo.eshipment_type_alias eq 'dp' or getCompInfo.eshipment_type_alias eq 'dgn'>
				<cfif len(get_ship_result.CARRIER_NAME)>
					<cac:CarrierParty>
						<cfif len(get_ship_result.CARIER_TAXNO)>
							<cac:PartyIdentification>
								<cbc:ID schemeID="VKN">#get_ship_result.CARIER_TAXNO#</cbc:ID>
							</cac:PartyIdentification>
						<cfelseif len(get_ship_result.TCKN)>
							<cac:PartyIdentification>
								<cbc:ID schemeID="TCKN">#get_ship_result.TCKN#</cbc:ID>
							</cac:PartyIdentification>
						</cfif>
						<cac:PartyName>
							<cbc:Name>#HTMLEditFormat(get_ship_result.CARRIER_NAME)#</cbc:Name>
						</cac:PartyName>
						<cac:PostalAddress>
							<cbc:CitySubdivisionName>#get_ship_result.CARIER_COUNTY#</cbc:CitySubdivisionName>
							<cbc:CityName>#get_ship_result.CARIER_CITY#</cbc:CityName>
							<cac:Country>
								<cbc:Name>#get_ship_result.CARIER_COUNTRY#</cbc:Name>
							</cac:Country>
						</cac:PostalAddress>
					</cac:CarrierParty>
				<cfelseif len(get_ship_result.CONS_NAME)>
					<cac:CarrierParty>
						<cfif len(get_ship_result.CONS_TAX)>
							<cac:PartyIdentification>
								<cbc:ID schemeID="VKN">#get_ship_result.CONS_TAX#</cbc:ID>
							</cac:PartyIdentification>
						<cfelseif len(get_ship_result.CONS_TC)>
							<cac:PartyIdentification>
								<cbc:ID schemeID="TCKN">#get_ship_result.CONS_TC#</cbc:ID>
							</cac:PartyIdentification>
						</cfif>
						<cac:PartyName>
							<cbc:Name>#HTMLEditFormat(get_ship_result.CONS_NAME)#</cbc:Name>
						</cac:PartyName>
						<cac:PostalAddress>
							<cbc:CitySubdivisionName>#get_ship_result.CARIER_COUNTY#</cbc:CitySubdivisionName>
							<cbc:CityName>#get_ship_result.CARIER_CITY#</cbc:CityName>
							<cac:Country>
								<cbc:Name>#get_ship_result.CARIER_COUNTRY#</cbc:Name>
							</cac:Country>
						</cac:PostalAddress>
					</cac:CarrierParty>
				</cfif>
			</cfif>
			<cac:Despatch>
				<cbc:ActualDespatchDate>#dateformat(get_ship.DELIVER_DATE,'yyyy-mm-dd')#</cbc:ActualDespatchDate>
				<cbc:ActualDespatchTime>#timeformat(get_ship.DELIVER_DATE,'HH:MM:SS')#</cbc:ActualDespatchTime>
			</cac:Despatch>
		</cac:Delivery>
		<cfif len(get_ship_result.PLATE2)>
		<cac:TransportHandlingUnit>
			<cac:TransportEquipment>
				<cbc:ID schemeID="DORSEPLAKA">#get_ship_result.PLATE2#</cbc:ID>
			</cac:TransportEquipment>
		</cac:TransportHandlingUnit>
		</cfif>
	</cac:Shipment>
	<cfloop query="get_ship_row">
	<cac:DespatchLine>
		<cbc:ID>#get_ship_row.currentrow#</cbc:ID>
		<cbc:DeliveredQuantity unitCode="#get_ship_row.UNIT_CODE#">#get_ship_row.AMOUNT#</cbc:DeliveredQuantity>
		<cac:OrderLineReference>
			<cbc:LineID>#get_ship_row.currentrow#</cbc:LineID>
		</cac:OrderLineReference>
		<cac:Item>
			<cbc:Name>#HTMLEditFormat(trim(get_ship_row.name_product))#</cbc:Name>
			<cac:SellersItemIdentification>
				<cbc:ID>#HTMLEditFormat(trim(get_ship_row.product_code))#</cbc:ID>
			</cac:SellersItemIdentification>
			<cac:ItemInstance>
				<cbc:ProductTraceID>#HTMLEditFormat(trim(get_ship_row.LOT_NO))#</cbc:ProductTraceID>
				<cbc:RegistrationID>#HTMLEditFormat(trim(get_ship_row.PRODUCT_CODE_2))#</cbc:RegistrationID>
				<cbc:SerialID>#HTMLEditFormat(trim(get_ship_row.BARCOD))#</cbc:SerialID>
			</cac:ItemInstance>
		</cac:Item>
	</cac:DespatchLine>
</cfloop>
</DespatchAdvice>
</cfoutput>
</cfsavecontent>