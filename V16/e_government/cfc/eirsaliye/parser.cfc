<!---
    File :          parser.cfc
    Author :        Halit Yurttaş <halityurttas@gmail.com>
    Date :          29.05.2020
    Description :   UBL parser
    Notes :         
--->

<cfcomponent>

    <cffunction name="get_eirsaliye" access="public" hint="Gelen eirsaliye dosyasını dönüştürür">
        <cfargument name="ubl_file">

        <cffile action="read" file="#arguments.ubl_file#" variable="ublcontent" charset="utf-8">
        <cfxml variable="ublxml"><cfoutput>#ublcontent#</cfoutput></cfxml>

        <!--- Root path --->
        <cfset ubldoc = ublxml.DespatchAdvice>
        <cfset resultdata = structNew()>

        <!--- 
        resultdata
        profileid               : prfil id
        id                      : id
        uuid                    : unique id
        issuedate               : düzenleme tarihi
        issuetime               : düzenleme saati
        despatchadvicetypecode  : irsaliye işlem kodu
        --->

        <cfset resultdata.customizationid = ubldoc.CustomizationID.XmlText>
        <cfset resultdata.profileid = ubldoc.ProfileID.XmlText>
        <cfset resultdata.id = ubldoc.ID.XmlText>
        <cfset resultdata.uuid = ubldoc.UUID.XmlText>
        <cfset resultdata.issuedate = ubldoc.IssueDate.XmlText>
        <cfset resultdata.issuetime = ubldoc.IssueTime.XmlText>
        <cfset resultdata.despatchadvicetypecode = ubldoc.DespatchAdviceTypeCode.XmlText>
        
        <cfif isDefined("ubldoc.Note")>
            <cfset resultdata.note = ubldoc.Note.XmlText>
        </cfif>

        <!--- 
        .orderreference             : sipariş referansı
        id                          : sipariş id
        issuedate                   : düzenleme tarihi
        --->

        <cfif isDefined("ubldoc.OrderReference.ID")>
            <cfset resultdata.orderreference = structNew()>
            <cfset orderreference = ubldoc.OrderReference>
            <cfset resultdata.orderreference.id = orderreference.ID.XmlText>
            <cfset resultdata.orderreference.issuedate = orderreference.IssueDate.XmlText>
        </cfif>
    
        <!--- 
        --- Bu alan sadece ek döküman gönderildiğinde işlenir aksi halde xml de bulunmaz ---

        .additionaldocumentreference            : ek döküman bilgileri
        id                                      : döküman id
        issue date                              : düzenleme tarihi
        documenttype                            : döküman tipi
        documenttypedescription                 : döküman tipi açıklaması
        --->

        <cfif isDefined("ubldoc.AdditionalDocumentReference")>
            <cfset resultdata.additionaldocumentreference = structNew()>
            <cfset additionalref = ubldoc.AdditionalDocumentReference>
            <cfset resultdata.additionaldocumentreference.id = additionalref.ID.XmlText>
            <cfset resultdata.additionaldocumentreference.issuedate = additionalref.IssueDate.XmlText>
            <cfif isDefined("additionalref.documenttype")>
                <cfset resultdata.additionaldocumentreference.documenttype = additionalref.DocumentType.XmlText>
            </cfif>
            <cfif isDefined("additionalref.DocumentDescription")>
                <cfset resultdata.additionaldocumentreference.documentdescription = additionalref.DocumentDescription.XmlText>
            </cfif>
        </cfif>

        <!--- 
        .signature                                  : dijital imza bilgileri
        id                                          : id
            .signatoryparty                         : parti bilgisi (imzalanan firmaya ait)
                .partyidentification                : tanım bilgileri
                vkn                                 : vergi kimlik no

                .postaladdress                      : posta adresi bilgileri
                streetname                          : sokak (opsiyonel)
                buildingnumber                      : bina no (opsiyonel)
                citysubdivisionname                 : ilçe/semt (opsiyonel)
                cityname                            : il
                postalzone                          : posta kodu
                country                             : ülke

        digitalsignatureattachment                  : dijital imza eki url adresi
        --->

        <cfif isDefined("ubldoc.Signature.ID")>
            <cfset resultdata.signature = structNew()>
            <cfset signature = ubldoc.Signature>
            <cfset resultdata.signature.id = signature.ID.XmlText>
            <cfif isDefined("signature.SignatoryParty")>
                <cfset resultdata.signature.signatoryparty = structNew()>
                <cfset signatoryparty = signature.SignatoryParty>
                <cfif isDefined("signatoryparty.PartyIdentification")>
                    <cfset resultdata.signature.signatoryparty.partyidentification = structNew()>
                    <cfset resultdata.signature.signatoryparty.partyidentification.vkn = getPartyIdentification(xmlparent:signatoryparty, scheme:"VKN")>
                </cfif>
                <cfif isDefined("signatoryparty.PostalAddress")>
                    <cfset resultdata.signature.postaladdress = getAddress(signatoryparty.PostalAddress)>
                </cfif>
            </cfif>
            <cfif isDefined("signature.DigitalSignatureAttachment.ExternalReference")>
                <cfset resultdata.signature.digitalsignatureattachment = signature.DigitalSignatureAttachment.ExternalReference.XmlText>
            </cfif>
        </cfif>

        <!--- 
        .despatchsupplierparty                          : nakiye sağlayıcı parti bilgileri (Malların Sevkiyatını Sağlayan)
            .party                                      : parti bilgileri
            websiteurl                                  : web sitesi
                .partyidentification                    : parti tanım bilgisi
                id                                      : id (vkn)
                
                .partyname                              : parti adı bilgileri
                name                                    : parti adı (firma adı)
            
                .postaladres                            : posta adres bilgileri
                id                                      : id
                streetname                              : sokak ismi (opsiyonel)
                buildingnumber                          : bina no (opsiyonel)
                citysubdivisionname                     : ilçe/semt (opsiyonel)
                cityname                                : il
                postalzone                              : posta kodu
                country                                 : ülke

                .physicalLocation                       : Fiziksel lokasyon bilgileri
                id                                      : id
                    .address                            : Adres bilgileri
                    id                                  : id
                    streetname                          : sokak adı (opsiyonel)
                    buildingnumber                      : bina no (opsiyonel)
                    citysubdivisionname                 : ilçe/semt
                    cityname                            : il
                    postalzone                          : posta kodu
                    country                             : ülke

                .partytaxscheme                         : Parti Vergi Şablonu
                    .taxscheme                          : Vergi Şablonu
                    name                                : adı (vergi dairesi)

                .contact                                : İletişim bilgileri
                telephone                               : telefon (opsiyonel)
                telefax                                 : telefax (opsionel)
                electronicmail                          : e-posta (opsiyonel)

            .despatchcontact                            : kontakt bilgileri
            name                                        : adı
        --->

        <cfif isDefined("ubldoc.DespatchSupplierParty")>
            <cfset resultdata.despatchsupplierparty = structNew()>
            <cfset despatchsupplierparty = ubldoc.DespatchSupplierParty>
            <cfif isDefined("despatchsupplierparty.Party")>
                <cfset resultdata.despatchsupplierparty.party = structNew()>
                <cfset party = despatchsupplierparty.Party>
                <cfif isDefined("party.WebsiteURI")>
                    <cfset resultdata.despatchsupplierparty.party.websiteuri = party.WebsiteURI.XmlText>
                </cfif>
                <cfif isDefined("party.PartyIdentification")>
                    <cfset resultdata.despatchsupplierparty.party.partyidentification = structNew()>
                    <cfset resultdata.despatchsupplierparty.party.partyidentification.vkn = getPartyIdentification(party, "VKN")>
                </cfif>
                <cfif isDefined("party.PartyName.Name")>
                    <cfset resultdata.despatchsupplierparty.party.partyname = structnew()>
                    <cfset resultdata.despatchsupplierparty.party.partyname.name = party.PartyName.Name.XmlText>
                </cfif>
                
                <cfif isDefined("party.PostalAddress")>
                    <cfset resultdata.despatchsupplierparty.party.postaladdress = getAddress(party.PostalAddress)>
                </cfif>
                
                <cfif isDefined("party.PhysicalLocation")>
                    <cfset resultdata.despatchsupplierparty.party.physicallocation = structNew()>
                    <cfset physicallocation = party.PhysicalLocation>
					<cfif isDefined("physicallocation.ID")>
                    	<cfset resultdata.despatchsupplierparty.party.id = physicallocation.ID.XmlText>
                    </cfif>
					<cfif isDefined("physicallocation.Address")>
                        <cfset resultdata.despatchsupplierparty.party.physicallocation.address = getAddress(physicallocation.Address)>
                    </cfif>
                </cfif>

                <cfif isDefined("party.PartyTaxScheme")>
                    <cfset resultdata.despatchsupplierparty.party.partytaxscheme = structNew()>
                    <cfset partytaxscheme = party.PartyTaxScheme>
                    <cfif isDefined("partytaxscheme.TaxScheme")>
                        <cfset resultdata.despatchsupplierparty.party.partytaxscheme.taxscheme = structNew()>
                        <cfset taxscheme = partytaxscheme.TaxScheme>
                        <cfset resultdata.despatchsupplierparty.party.partytaxscheme.taxscheme.name = taxscheme.Name.XmlText>
                    </cfif>
                </cfif>

                <cfif isDefined("party.Contact")>
                    <cfset resultdata.despatchsupplierparty.party.contact = getContact(party.Contact)>
                </cfif>
            </cfif>
            <cfif isDefined("despatchsupplierparty.DespatchContact")>
                <cfset resultdata.despatchsupplierparty.despatchcontact = structNew()>
                <cfset despatchcontact = despatchsupplierparty.DespatchContact>
                <cfif isDefined("despatchcontact.Name")>
                    <cfset resultdata.despatchsupplierparty.despatchcontact.name = despatchcontact.Name.XmlText>
                </cfif>
            </cfif>
        </cfif>

        <!--- 
        .deliverycustomerparty                          : teslimat parti bilgileri (Malları Teslim Alan)
            .party                                      : parti bilgileri
            websiteuri                                  : website adresi

                .partyidentification                    : parti kimlik verileri
                vkn                                     : vergi kimlik no
                musterino                               : müşteri no

                .partyname                              : parti adı bilgileri
                name                                    : firma adı

                .postaladdress                          : posta adres bilgileri
                id                                      : id
                streetname                              : sokak ismi (opsiyonel)
                buildingnumber                          : bina no (opsiyonel)
                citysubdivisionname                     : ilçe/semt (opsiyonel)
                cityname                                : il
                postalzone                              : posta kodu
                country                                 : ülke

                .partytaxscheme                         : Parti Vergi Şablonu
                    .taxscheme                          : Vergi Şablonu
                    name                                : adı (vergi dairesi)

                .contact                                : İletişim bilgileri
                telephone                               : telefon (opsiyonel)
                telefax                                 : telefax (opsionel)
                electronicmail                          : e-posta (opsiyonel)
        --->

        <cfif isDefined("ubldoc.DeliveryCustomerParty")>
            <cfset resultdata.deliverycustomerparty = structNew()>
            <cfset deliverycustomerparty = ubldoc.DeliveryCustomerParty>
            <cfif isDefined("deliverycustomerparty.Party")>
                <cfset resultdata.deliverycustomerparty.party = structNew()>
                <cfset party = deliverycustomerparty.Party>
                
                <cfif isDefined("party.WebsiteURI")>
                    <cfset resultdata.deliverycustomerparty.party.websiteuri = party.WebsiteURI.XmlText>
                </cfif>

                <cfif isDefined("party.PartyIdentification")>
                    <cfset resultdata.deliverycustomerparty.party.partyidentification = structNew()>
                    <cfset resultdata.deliverycustomerparty.party.partyidentification.vkn = getPartyIdentification(party, "VKN")>
                    <cfset resultdata.deliverycustomerparty.party.partyidentification.musterino = getPartyIdentification(party, "MUSTERINO")>
                </cfif>

                <cfif isDefined("party.PartyName.Name")>
                    <cfset resultdata.deliverycustomerparty.party.partyname = structnew()>
                    <cfset resultdata.deliverycustomerparty.party.partyname.name = party.PartyName.Name.XmlText>
                </cfif>

                <cfif isDefined("party.PostalAddress")>
                    <cfset resultdata.deliverycustomerparty.party.postaladdress = getAddress(party.PostalAddress)>                  
                </cfif>

                <cfif isDefined("party.PartyTaxScheme")>
                    <cfset resultdata.deliverycustomerparty.party.partytaxscheme = structNew()>
                    <cfset partytaxscheme = party.PartyTaxScheme>
                    <cfif isDefined("partytaxscheme.TaxScheme")>
                        <cfset resultdata.deliverycustomerparty.party.partytaxscheme.taxscheme = structNew()>
                        <cfset taxscheme = partytaxscheme.TaxScheme>
                        <cfset resultdata.deliverycustomerparty.party.partytaxscheme.taxscheme.name = taxscheme.Name.XmlText>
                    </cfif>
                </cfif>

                <cfif isDefined("party.Contact")>
                    <cfset resultdata.deliverycustomerparty.party.contact = getContact(party.Contact)>
                </cfif>
            </cfif>
        </cfif>

        <!--- 
        .buyercustomerparty                             : satın alma parti bilgileri (Malların Satın Alımını Sağlayan)
            .party                                      : parti bilgileri
            websiteuri                                  : website adresi

                .partyidentification                    : parti kimlik verileri
                vkn                                     : vergi kimlik no
                musterino                               : müşteri no

                .partyname                              : parti adı bilgileri
                name                                    : firma adı

                .postaladdress                          : posta adres bilgileri
                id                                      : id
                streetname                              : sokak ismi (opsiyonel)
                buildingnumber                          : bina no (opsiyonel)
                citysubdivisionname                     : ilçe/semt (opsiyonel)
                cityname                                : il
                postalzone                              : posta kodu
                country                                 : ülke

                .partytaxscheme                         : Parti Vergi Şablonu
                    .taxscheme                          : Vergi Şablonu
                    name                                : adı (vergi dairesi)

                .contact                                : İletişim bilgileri
                telephone                               : telefon (opsiyonel)
                telefax                                 : telefax (opsionel)
                electronicmail                          : e-posta (opsiyonel)
        --->

        <cfif isDefined("ubldoc.BuyerCustomerParty")>
            <cfset resultdata.buyercustomerparty = structNew()>
            <cfset buyercustomerparty = ubldoc.BuyerCustomerParty>
            <cfif isDefined("buyercustomerpaty.Party")>
                <cfset resultdata.buyercustomerparty.party = structNew()>
                <cfset party = buyercustomerparty.Party>
                <cfif isDefined("party.WebsiteURI")>
                    <cfset resultdata.buyercustomerparty.party.websiteuri = party.WebsiteURI.XmlText>
                </cfif>
                <cfif isDefined("party.PartyIdentification")>
                    <cfset resultdata.buyercustomerparty.party.partyidentification = structNew()>
                    <cfset resultdata.buyercustomerparty.party.partyidentification.vkn = getPartyIdentification(party, "VKN")>
                </cfif>
                <cfif isDefined("party.PartyName.Name")>
                    <cfset resultdata.buyercustomerparty.party.partyname = structnew()>
                    <cfset resultdata.buyercustomerparty.party.partyname.name = party.PartyName.Name.XmlText>
                </cfif>
                
                <cfif isDefined("party.PostalAddress")>
                    <cfset resultdata.buyercustomerparty.party.postaladdress = getAddress(party.PostalAddress)>
                </cfif>

                <cfif isDefined("party.PartyTaxScheme")>
                    <cfset resultdata.buyercustomerparty.party.partytaxscheme = structNew()>
                    <cfset partytaxscheme = party.PartyTaxScheme>
                    <cfif isDefined("partytaxscheme.TaxScheme")>
                        <cfset resultdata.buyercustomerparty.party.partytaxscheme.taxscheme = structNew()>
                        <cfset taxscheme = partytaxscheme.TaxScheme>
                        <cfset resultdata.buyercustomerparty.party.partytaxscheme.taxscheme.name = taxscheme.Name.XmlText>
                    </cfif>
                </cfif>

                <cfif isDefined("party.Contact")>
                    <cfset resultdata.buyercustomerparty.party.contact = getContact(party.Contact)>
                </cfif>
            </cfif>
        </cfif>

        <!--- 
        .originatorcustomerparty                        : satın alma parti bilgileri (Tüm sürecin başlamasını Sağlayan Alıcı)
            .party                                      : parti bilgileri
            websiteuri                                  : website adresi

                .partyidentification                    : parti kimlik verileri
                vkn                                     : vergi kimlik no
                musterino                               : müşteri no

                .partyname                              : parti adı bilgileri
                name                                    : firma adı

                .postaladdress                          : posta adres bilgileri
                id                                      : id
                streetname                              : sokak ismi (opsiyonel)
                buildingnumber                          : bina no (opsiyonel)
                citysubdivisionname                     : ilçe/semt (opsiyonel)
                cityname                                : il
                postalzone                              : posta kodu
                country                                 : ülke

                .partytaxscheme                         : Parti Vergi Şablonu
                    .taxscheme                          : Vergi Şablonu
                    name                                : adı (vergi dairesi)

                .contact                                : İletişim bilgileri
                telephone                               : telefon (opsiyonel)
                telefax                                 : telefax (opsionel)
                electronicmail                          : e-posta (opsiyonel)
        --->

        <cfif isDefined("ubldoc.OriginatorCustomerParty")>
            <cfset resultdata.originatorcustomerparty = structNew()>
            <cfset originatorcustomerparty = ubldoc.OriginatorCustomerParty>
            <cfif isDefined("originatorcustomerparty.Party")>
                <cfset resultdata.originatorcustomerparty.party = structNew()>
                <cfset party = originatorcustomerparty.Party>
                <cfif isDefined("party.WebsiteURI")>
                    <cfset resultdata.originatorcustomerparty.party.websiteuri = party.WebsiteURI.XmlText>
                </cfif>
                <cfif isDefined("party.PartyIdentification")>
                    <cfset resultdata.originatorcustomerparty.party.partyidentification = structNew()>
                    <cfset resultdata.originatorcustomerparty.party.partyidentification.vkn = getPartyIdentification(party, "VKN")>
                </cfif>
                <cfif isDefined("party.PartyName.Name")>
                    <cfset resultdata.originatorcustomerparty.party.partyname = structnew()>
                    <cfset resultdata.originatorcustomerparty.party.partyname.name = party.PartyName.Name.XmlText>
                </cfif>
                
                <cfif isDefined("party.PostalAddress")>
                    <cfset resultdata.originatorcustomerparty.party.postaladdress = getAddress(party.PostalAddress)>
                </cfif>

                <cfif isDefined("party.PartyTaxScheme")>
                    <cfset resultdata.originatorcustomerparty.party.partytaxscheme = structNew()>
                    <cfset partytaxscheme = party.PartyTaxScheme>
                    <cfif isDefined("partytaxscheme.TaxScheme")>
                        <cfset resultdata.originatorcustomerparty.party.partytaxscheme.taxscheme = structNew()>
                        <cfset taxscheme = partytaxscheme.TaxScheme>
                        <cfset resultdata.originatorcustomerparty.party.partytaxscheme.taxscheme.name = taxscheme.Name.XmlText>
                    </cfif>
                </cfif>

                <cfif isDefined("party.Contact")>
                    <cfset resultdata.originatorcustomerparty.party.contact = getContact(party.Contact)>
                </cfif>
            </cfif>
        </cfif>

        <!--- 
        .shipment                               : nakliye bilgileri
        id                                      : id (opsiyonel)

            .goodsitem                          : kıymet bilgileri (faturalı durumlarda oluşur aksi halde xml de bulunmaz)
            value                               : tutar
            currencyid                          : parabirimi sembolü

            -shipmentstage                      : nakil durum bilgileri listesi
            
                -transportmeans                 : taşıyıcı araç listesi (opsiyonel)
                    .roadtransport              : yolda taşıyıcı bilgileri
                    licenseplateid              : plaka

                .driverperson                   : Sürücü bilgileri
                firstname                       : adı
                familyname                      : soyadı
                title                           : ünvan
                nationalityid                   : tckimlik

            .delivery                           : teslimat bilgileri
                .carrierparty                   : taşıyıcı parti bilgileri
                    .partyidentification        : parti tanım bilgileri
                    vkn                         : vergi kimlik no

                    .partyname                  : parti adı bilgisi
                    name                        : adı (firma adı)

                    .postaladdress              : adres bilgileri
                    id                          : id
                    streetname                  : sokak ismi (opsiyonel)
                    buildingnumber              : bina no (opsiyonel)
                    citysubdivisionname         : ilçe/semt (opsiyonel)
                    cityname                    : il
                    postalzone                  : posta kodu
                    country                     : ülke

                .despatch                       : irsaliye bilgileri
                actualdespatchdate              : irsaliye tarihi
                actualdespatchtime              : İrsaliye saati

            -transporthandlingunit              : taşıyıcı birimleri listesi
                .transportequipment             : taşıyıcı birim bilgileri
                id                              : id (örn: 34AB123)
                schemeid                        : şema adı (örn: DORSEPLAKA)

        --->

        <cfif isDefined("ubldoc.Shipment")>
            <cfset resultdata.shipment = structNew()>
            <cfset shipment = ubldoc.Shipment>
            <cfset resultdata.shipment.id = shipment.ID.XmlText>
            
            <cfif isDefined("shipment.GoodsItem")>
                <cfset resultdata.shipment.goodsitem = structNew()>
                <cfset goodsitem = shipment.GoodsItem>
                <cfif isDefined("goodsitem.ValueAmount")>
                    <cfset resultdata.shipment.goodsitem.valueamount = structNew()>
                    <cfset valueamount = goodsitem.ValueAmount>
                    <cfset resultdata.shipment.goodsitem.valueamount.value = valueamount.XmlText>
                    <cfset resultdata.shipment.goodsitem.valueamount.currencyid = valueamount.XmlAttributes.currencyID>
                </cfif>
            </cfif>

            <cfif isDefined("shipment.ShipmentStage")>
                <cfset resultdata.shipment.shipmentstage = arrayNew(1)>
                <cfloop array="#shipment.ShipmentStage.XmlChildren#" index="child">
                    <cfset shipmentstageitem = getShipmentStage(child)>
                    <cfif isDefined("shipmentstageitem")>
                        <cfset arrayAppend( resultdata.shipment.shipmentstage, shipmentstageitem )>
                    </cfif>
                </cfloop>
            </cfif>
            
            <cfif isDefined("shipment.Delivery")>
                <cfset resultdata.shipment.delivery = structNew()>
                <cfset delivery = shipment.Delivery>
                
                <cfif isDefined("delivery.CarrierParty")>
                    <cfset resultdata.shipment.delivery.carrierparty = structNew()>
                    <cfset carrierparty = delivery.CarrierParty>

                    <cfif isDefined("carrierparty.PartyIdentification") and Len(carrierparty.PartyIdentification.ID.XmlText)>
                        <cfset resultdata.shipment.delivery.carrierparty.partyidentification = structNew()>
                        <cfset resultdata.shipment.delivery.carrierparty.partyidentification.vkn = getPartyIdentification(delivery.CarrierParty, "VKN")>
                    </cfif>
                    
                    <cfif isDefined("carrierparty.PartyName")>
                        <cfset resultdata.shipment.delivery.carrierparty.partyname = structNew()>
                        <cfset partyname = carrierparty.PartyName>
                        <cfset resultdata.shipment.delivery.carrierparty.partyname.name = partyname.Name.XmlText>
                    </cfif>
                    
                    <cfif isDefined("carrierparty.PostalAddress")>
                        <cfset resultdata.shipment.delivery.carrierparty.postaladdress = getAddress(carrierparty.PostalAddress)>
                    </cfif>
                </cfif>

                <cfif isDefined("delivery.Despatch")>
                    <cfset resultdata.shipment.delivery.despatch = structNew()>
                    <cfset despatch = delivery.Despatch>
                    <cfset resultdata.shipment.delivery.despatch.actualdespatchdate = despatch.ActualDespatchDate.XmlText>
                    <cfif isdefined("despatch.ActualDespatchTime")>
                        <cfset resultdata.shipment.delivery.despatch.actualdespatchtime = despatch.ActualDespatchTime.XmlText>
                    </cfif>
                </cfif>
            </cfif>

            <cfif isDefined("shipment.TransportHandlingUnit")>
                <cfset resultdata.shipment.transporthandlingunit = arrayNew(1)>
                <cfset transporthandlingunit = shipment.TransportHandlingUnit>
                <cfloop array="#transporthandlingunit.XmlChildren#" index="child">
                    <cfset transportequipment = structNew()>
                    <cfif isdefined("child.ID")>
                        <cfset transportequipment.id = child.ID.XmlText>
                    </cfif>
                    <cfif isdefined("child.XmlAttributes.schemeID")>
                        <cfset transportequipment.schemeid = child.XmlAttributes.schemeID>
                    </cfif>
                    <cfset arrayAppend( resultdata.shipment.transporthandlingunit, transportequipment )>
                </cfloop>
            </cfif>
        </cfif>

        <!--- 
        -despatchline                           : irsaliye satır listesi
        .despatchlineitem                       : irsaliye satır bilgileri
        id                                      : satır no
        outstandingreason                       : sonra gönderilme açıklaması

            .deliveryquantity                   : nakil miktarı bilgileri
            value                               : nakil miktarı
            unitcode                            : birim kodu
            
            .outstandingquantity                : daha sonra nakledilecek miktar bilgileri
            value                               : nakil miktarı
            unitcode                            : birim kodu

            .orderlinereference                 : sipariş satır referans bilgileri
            lineid                              : satır id

            .item                               : ürün bilgileri
            name                                : ürün adı
                .selleritemidentification       : satıcı ürün tanım bilgileri
                id                              : ürün id

            .shipment                           : taşıma bilgileri
            id                                  : id
                .goodsitem                      : değerli varlık bilgileri
                    .invoiceline                : fatura satırı bilgileri
                    id                          : id
                    invoicequantity             : miktar
                        .lineextensionamount    : satır tutar bilgileri
                        value                   : tutar
                        currencyid              : para birimi sembolü

                        .item                   : ürün bilgileri
                        name                    : adı
                    
                        .price                  : fiyat bilgileri
                        priceamount             : fiyat
                        currencyid              : para birimi sembolü

        --->
        
        <cfif isDefined("ubldoc.DespatchLine")>
            <cfset resultdata.despatchline = arrayNew(1)>
            <cfscript>
                despatchlines = arrayFilter(ubldoc.XmlChildren, function(item) {
                    return item.XmlName eq "cac:DespatchLine";
                });
            </cfscript>
            <cfloop array="#despatchlines#" index="despatchline">
                <cfset despatchlineitem = structNew()>
                <cfset despatchlineitem.id = despatchline.ID.XmlText>
                
                <cfif isDefined("despatchline.DeliveredQuantity")>
                    <cfset despatchlineitem.deliveredquantity = structNew()>
                    <cfset despatchlineitem.deliveredquantity.value = despatchline.DeliveredQuantity.XmlText>
                    <cfset despatchlineitem.deliveredquantity.unitcode = despatchline.DeliveredQuantity.XmlAttributes.unitCode>
                </cfif>

                <cfif isDefined("despatchline.OutstandingQuantity")>
                    <cfset despatchlineitem.outstandingquantity = structNew()>
                    <cfset despatchlineitem.outstandingquantity.value = despatchline.OutstandingQuantity.XmlText>
                    <cfset despatchlineitem.outstandingquantity.unitcode = despatchline.OutstandingQuantity.XmlAttributes.unitCode>
                </cfif>

                <cfif isDefined("despatchline.OutstandingReason")>
                    <cfset despatchlineitem.outstandingreason = despatchline.OutstandingReason.XmlText>
                </cfif>

                <cfif isDefined("despatchline.OrderLineReference")>
                    <cfset despatchlineitem.orderlinereference = structNew()>
                    <cfset despatchlineitem.orderlinereference.lineid = despatchline.OrderLineReference.LineID.XmlText>
                </cfif>

                <cfset despatchlineitem.item = structNew()>
                <cfset despatchlineitem.item.name = despatchline.Item.Name.XmlText>
                
                <cfif isDefined('despatchline.Item.SellersItemIdentification')>
                    <cfset despatchlineitem.item.sellersitemidentification = structNew()>
                    <cfset despatchlineitem.item.sellersitemidentification.id = despatchline.Item.SellersItemIdentification.ID.XmlText>
                </cfif>

                <cfif isDefined("despatchline.Shipment")>
                    <cfset despatchlineitem.shipment = structNew()>
                    <cfset shipment = despatchline.Shipment>
                    <cfset despatchlineitem.shipment.id = shipment.ID.XmlText>
                    
                    <cfif isDefined("shipment.GoodsItem")>
                        <cfset despatchlineitem.shipment.goodsitem = structNew()>
                        <cfset goodsitem = shipment.GoodsItem>

                        <cfif isDefined("goodsitem.InvoiceLine")>
                            <cfset despatchlineitem.shipment.goodsitem.invoiceline = structNew()>
                            <cfset invoiceline = goodsitem.InvoiceLine>
                            
                            <cfif isDefined("invoiceline.ID")>
                                <cfset despatchlineitem.shipment.goodsitem.invoiceline.id = invoiceline.ID.XmlText>
                            </cfif>
                            
                            <cfif isDefined("invoiceline.InvoicedQuantity")>
                                <cfset despatchlineitem.shipment.goodsitem.invoiceline.invoicedquantity = invoiceline.InvoicedQuantity.XmlText>
                            </cfif>
                            
                            <cfif isDefined("invoiceline.LineExtensionAmount")>
                                <cfset despatchlineitem.shipment.goodsitem.invoiceline.lineextensionamount = structNew()>
                                <cfset despatchlineitem.shipment.goodsitem.invoiceline.lineextensionamount.value = invoiceline.LineExtensionAmount.XmlText>
                                <cfset despatchlineitem.shipment.goodsitem.invoiceline.lineextensionamount.currencyid = invoiceline.LineExtensionAmount.XmlAttributes.currencyID>
                            </cfif>
                            
                            <cfif isDefined("invoiceline.Item")>
                                <cfset despatchlineitem.shipment.goodsitem.invoiceline.item = structNew()>
                                <cfset despatchlineitem.shipment.goodsitem.invoiceline.item.name = invoiceline.Item.Name.XmlText>
                            </cfif>

                            <cfif isDefined("invoiceline.Price")>
                                <cfset despatchlineitem.shipment.goodsitem.invoiceline.price = structNew()>
                                <cfset despatchlineitem.shipment.goodsitem.invoiceline.price.priceamount = invoiceline.Price.PriceAmount.XmlText>
                                <cfset despatchlineitem.shipment.goodsitem.invoiceline.price.currencyid = invoiceline.Price.PriceAmount.XmlAttributes.currencyID>
                            </cfif>


                        </cfif>
                    </cfif>
                </cfif>

                <cfset arrayAppend( resultdata.despatchline, despatchlineitem )>
            </cfloop>
        </cfif>

        <cfreturn resultdata>
    </cffunction>

    <cffunction name="get_eirsaliye_yanit" access="public" hint="Gelen irsaliye yanıtı dosyasını dönüştürür">
        <cfargument name="ubl_file">

        <cffile action="read" file="#arguments.ubl_file#" variable="ublcontent" charset="utf-8">
        <cfxml variable="ublxml"><cfoutput>#ublcontent#</cfoutput></cfxml>

        <!--- Root path --->
        <cfset ubldoc = ublxml.ReceiptAdvice>
        <cfset resultdata = structNew()>

        <!--- 
        resultdata
        profileid               : prfil id
        id                      : id
        uuid                    : unique id
        issuedate               : düzenleme tarihi
        issuetime               : düzenleme saati
        despatchadvicetypecode  : irsaliye işlem kodu
        --->

        <cfset resultdata.profileid = ubldoc.ProfileID.XmlText>
        <cfset resultdata.id = ubldoc.ID.XmlText>
        <cfset resultdata.uuid = ubldoc.UUID.XmlText>
        <cfset resultdata.issuedate = ubldoc.IssueDate.XmlText>
        <cfif isDefined("ubldoc.IssueTime")>
            <cfset resultdata.issuetime = ubldoc.IssueTime.XmlText>
        </cfif>
        <cfif isDefined("ubldoc.ReceiptAdviceTypeCode")>
            <cfset resultdata.despatchadvicetypecode = ubldoc.ReceiptAdviceTypeCode.XmlText>
        </cfif>
        <cfif isDefined("ubldoc.Note")>
            <cfset resultdata.note = ubldoc.Note.XmlText>
        </cfif>

        <!--- 
        .orderreference             : sipariş referansı
        id                          : sipariş id
        issuedate                   : düzenleme tarihi
        --->

        <cfif isDefined("ubldoc.OrderReference.ID")>
            <cfset resultdata.orderreference = structNew()>
            <cfset orderreference = ubldoc.OrderReference>
            <cfset resultdata.orderreference.id = orderreference.ID.XmlText>
            <cfset resultdata.orderreference.issuedate = orderreference.IssueDate.XmlText>
        </cfif>

        <!--- 
        .despatchdocumentreference          : irsaliye döküman referansı
        id                                  : id
        issuedate                           : kayıt tarihi
        --->

        <cfif isDefined("ubldoc.DespatchDocumentReference")>
            <cfset resultdata.despatchdocumentreference = structNew()>
            <cfset despatchdocumentreference = ubldoc.DespatchDocumentReference>
            <cfset resultdata.despatchdocumentreference.id = despatchdocumentreference.ID.XmlText>
            <cfset resultdata.despatchdocumentreference.issuedate = despatchdocumentreference.IssueDate.XmlText>
        </cfif>

        <!---
        .additionaldocumentreference            : ek döküman bilgileri
        id                                      : döküman id
        issue date                              : düzenleme tarihi
        documenttype                            : döküman tipi
        documenttypedescription                 : döküman tipi açıklaması
        --->

        <cfif isDefined("ubldoc.AdditionalDocumentReference")>
            <cfset resultdata.additionaldocumentreference = structNew()>
            <cfset additionalref = ubldoc.AdditionalDocumentReference>
            <cfset resultdata.additionaldocumentreference.id = additionalref.ID.XmlText>
            <cfset resultdata.additionaldocumentreference.issuedate = additionalref.IssueDate.XmlText>
            <cfset resultdata.additionaldocumentreference.documenttype = additionalref.DocumentType.XmlText>
            <cfset resultdata.additionaldocumentreference.documentdescription = additionalref.DocumentDescription.XmlText>
        </cfif>

        <!--- 
        .signature                                  : dijital imza bilgileri
        id                                          : id
            .signatoryparty                         : parti bilgisi (imzalanan firmaya ait)
                .partyidentification                : tanım bilgileri
                vkn                                 : vergi kimlik no

                .postaladdress                      : posta adresi bilgileri
                streetname                          : sokak (opsiyonel)
                buildingnumber                      : bina no (opsiyonel)
                citysubdivisionname                 : ilçe/semt (opsiyonel)
                cityname                            : il
                postalzone                          : posta kodu
                country                             : ülke

        digitalsignatureattachment                  : dijital imza eki url adresi
        --->

        <cfif isDefined("ubldoc.Signature.ID")>
            <cfset resultdata.signature = structNew()>
            <cfset signature = ubldoc.Signature>
            <cfset signature.id = signature.ID.XmlText>
            <cfif isDefined("signature.SignatoryParty")>
                <cfset resultdata.signature.signatoryparty = structNew()>
                <cfset signatoryparty = signature.SignatoryParty>
                <cfif isDefined("signatoryparty.PartyIdentification")>
                    <cfset resultdata.signature.signatoryparty.partyidentification = structNew()>
                    <cfset resultdata.signature.signatoryparty.partyidentification.vkn = getPartyIdentification(signatoryparty, "VKN")>
                </cfif>
                <cfif isDefined("signatoryparty.PostalAddress")>
                    <cfset resultdata.signature.postaladdress = getAddress(signatoryparty.PostalAddress)>
                </cfif>
            </cfif>
            <cfif isDefined("signature.DigitalSignatureAttachment.ExternalReference")>
                <cfset resultdata.signature.digitalsignatureattachment = signature.DigitalSignatureAttachment.ExternalReference.XmlText>
            </cfif>
        </cfif>

        <!--- 
        .despatchsupplierparty                          : nakiye sağlayıcı parti bilgileri (Malların Sevkiyatını Sağlayan)
            .party                                      : parti bilgileri
            websiteurl                                  : web sitesi
                .partyidentification                    : parti tanım bilgisi
                id                                      : id (vkn)
                
                .partyname                              : parti adı bilgileri
                name                                    : parti adı (firma adı)
            
                .postaladres                            : posta adres bilgileri
                id                                      : id
                streetname                              : sokak ismi (opsiyonel)
                buildingnumber                          : bina no (opsiyonel)
                citysubdivisionname                     : ilçe/semt (opsiyonel)
                cityname                                : il
                postalzone                              : posta kodu
                country                                 : ülke

                .physicalLocation                       : Fiziksel lokasyon bilgileri
                id                                      : id
                    .address                            : Adres bilgileri
                    id                                  : id
                    streetname                          : sokak adı (opsiyonel)
                    buildingnumber                      : bina no (opsiyonel)
                    citysubdivisionname                 : ilçe/semt
                    cityname                            : il
                    postalzone                          : posta kodu
                    country                             : ülke

                .partytaxscheme                         : Parti Vergi Şablonu
                    .taxscheme                          : Vergi Şablonu
                    name                                : adı (vergi dairesi)

                .contact                                : İletişim bilgileri
                telephone                               : telefon (opsiyonel)
                telefax                                 : telefax (opsionel)
                electronicmail                          : e-posta (opsiyonel)

            .despatchcontact                            : kontakt bilgileri
            name                                        : adı
        --->

        <cfif isDefined("ubldoc.DespatchSupplierParty")>
            <cfset resultdata.despatchsupplierparty = structNew()>
            <cfset despatchsupplierparty = ubldoc.DespatchSupplierParty>
            <cfif isDefined("despatchsupplierparty.Party")>
                <cfset resultdata.despatchsupplierparty.party = structNew()>
                <cfset party = despatchsupplierparty.Party>
                <cfif isDefined("party.WebsiteURI")>
                    <cfset resultdata.despatchsupplierparty.party.websiteuri = party.WebsiteURI.XmlText>
                </cfif>
                <cfif isDefined("party.PartyIdentification")>
                    <cfset resultdata.despatchsupplierparty.party.partyidentification = structNew()>
                    <cfset resultdata.despatchsupplierparty.party.partyidentification.vkn = getPartyIdentification(party, "VKN")>
                </cfif>
                <cfif isDefined("party.PartyName.Name")>
                    <cfset resultdata.despatchsupplierparty.party.partyname = structnew()>
                    <cfset resultdata.despatchsupplierparty.party.partyname.name = party.PartyName.Name.XmlText>
                </cfif>
                
                <cfif isDefined("party.PostalAddress")>
                    <cfset resultdata.despatchsupplierparty.party.postaladdress = getAddress(party.PostalAddress)>
                </cfif>
                
                <cfif isDefined("party.PhysicalLocation")>
                    <cfset resultdata.despatchsupplierparty.party.physicallocation = structNew()>
                    <cfset physicallocation = party.PhysicalLocation>
					<cfif isDefined("physicallocation.ID")>
                    	<cfset resultdata.despatchsupplierparty.party.id = physicallocation.ID.XmlText>
					</cfif>
                    <cfif isDefined("physicallocation.Address")>
                        <cfset resultdata.despatchsupplierparty.party.physicallocation.address = getAddress(physicallocation.Address)>
                    </cfif>
                </cfif>

                <cfif isDefined("party.PartyTaxScheme")>
                    <cfset resultdata.despatchsupplierparty.party.partytaxscheme = structNew()>
                    <cfset partytaxscheme = party.PartyTaxScheme>
                    <cfif isDefined("partytaxscheme.TaxScheme")>
                        <cfset resultdata.despatchsupplierparty.party.partytaxscheme.taxscheme = structNew()>
                        <cfset taxscheme = partytaxscheme.TaxScheme>
                        <cfset resultdata.despatchsupplierparty.party.partytaxscheme.taxscheme.name = taxscheme.Name.XmlText>
                    </cfif>
                </cfif>

                <cfif isDefined("party.Contact")>
                    <cfset resultdata.despatchsupplierparty.party.contact = getContact(party.Contact)>
                </cfif>
            </cfif>
            <cfif isDefined("despatchsupplierparty.DespatchContact")>
                <cfset resultdata.despatchsupplierparty.despatchcontact = structNew()>
                <cfset despatchcontact = despatchsupplierparty.DespatchContact>
                <cfset resultdata.despatchsupplierparty.despatchcontact.name = despatchcontact.Name.XmlText>
            </cfif>
        </cfif>

        <!--- 
        .deliverycustomerparty                          : teslimat parti bilgileri (Malları Teslim Alan)
            .party                                      : parti bilgileri
            websiteuri                                  : website adresi

                .partyidentification                    : parti kimlik verileri
                vkn                                     : vergi kimlik no
                musterino                               : müşteri no

                .partyname                              : parti adı bilgileri
                name                                    : firma adı

                .postaladdress                          : posta adres bilgileri
                id                                      : id
                streetname                              : sokak ismi (opsiyonel)
                buildingnumber                          : bina no (opsiyonel)
                citysubdivisionname                     : ilçe/semt (opsiyonel)
                cityname                                : il
                postalzone                              : posta kodu
                country                                 : ülke

                .partytaxscheme                         : Parti Vergi Şablonu
                    .taxscheme                          : Vergi Şablonu
                    name                                : adı (vergi dairesi)

                .contact                                : İletişim bilgileri
                telephone                               : telefon (opsiyonel)
                telefax                                 : telefax (opsionel)
                electronicmail                          : e-posta (opsiyonel)
        --->

        <cfif isDefined("ubldoc.DeliveryCustomerParty")>
            <cfset resultdata.deliverycustomerparty = structNew()>
            <cfset deliverycustomerparty = ubldoc.DeliveryCustomerParty>
            <cfif isDefined("deliverycustomerparty.Party")>
                <cfset resultdata.deliverycustomerparty.party = structNew()>
                <cfset party = deliverycustomerparty.Party>
                
                <cfif isDefined("party.WebsiteURI")>
                    <cfset resultdata.deliverycustomerparty.party.websiteuri = party.WebsiteURI.XmlText>
                </cfif>

                <cfif isDefined("party.PartyIdentification")>
                    <cfset resultdata.deliverycustomerparty.party.partyidentification = structNew()>
                    <cfset resultdata.deliverycustomerparty.party.partyidentification.vkn = getPartyIdentification(party, "VKN")>
                    <cfset resultdata.deliverycustomerparty.party.partyidentification.musterino = getPartyIdentification(party, "MUSTERINO")>
                </cfif>

                <cfif isDefined("party.PartyName.Name")>
                    <cfset resultdata.deliverycustomerparty.party.partyname = structnew()>
                    <cfset resultdata.deliverycustomerparty.party.partyname.name = party.PartyName.Name.XmlText>
                </cfif>

                <cfif isDefined("party.PostalAddress")>
                    <cfset resultdata.deliverycustomerparty.party.postaladdress = getAddress(party.PostalAddress)>                  
                </cfif>

                <cfif isDefined("party.PartyTaxScheme")>
                    <cfset resultdata.deliverycustomerparty.party.partytaxscheme = structNew()>
                    <cfset partytaxscheme = party.PartyTaxScheme>
                    <cfif isDefined("partytaxscheme.TaxScheme")>
                        <cfset resultdata.deliverycustomerparty.party.partytaxscheme.taxscheme = structNew()>
                        <cfset taxscheme = partytaxscheme.TaxScheme>
                        <cfset resultdata.deliverycustomerparty.party.partytaxscheme.taxscheme.name = taxscheme.Name.XmlText>
                    </cfif>
                </cfif>

                <cfif isDefined("party.Contact")>
                    <cfset resultdata.deliverycustomerparty.party.contact = getContact(party.Contact)>
                </cfif>
            </cfif>
        </cfif>

        <!--- 
        .shipment                               : nakliye bilgileri
        id                                      : id (opsiyonel)

            .goodsitem                          : kıymet bilgileri (faturalı durumlarda oluşur aksi halde xml de bulunmaz)
            value                               : tutar
            currencyid                          : parabirimi sembolü

            -shipmentstage                      : nakil durum bilgileri listesi
            
                -transportmeans                 : taşıyıcı araç listesi (opsiyonel)
                    .roadtransport              : yolda taşıyıcı bilgileri
                    licenseplateid              : plaka

                .driverperson                   : Sürücü bilgileri
                firstname                       : adı
                familyname                      : soyadı
                title                           : ünvan
                nationalityid                   : tckimlik

            .delivery                           : teslimat bilgileri
                .carrierparty                   : taşıyıcı parti bilgileri
                    .partyidentification        : parti tanım bilgileri
                    vkn                         : vergi kimlik no

                    .partyname                  : parti adı bilgisi
                    name                        : adı (firma adı)

                    .postaladdress              : adres bilgileri
                    id                          : id
                    streetname                  : sokak ismi (opsiyonel)
                    buildingnumber              : bina no (opsiyonel)
                    citysubdivisionname         : ilçe/semt (opsiyonel)
                    cityname                    : il
                    postalzone                  : posta kodu
                    country                     : ülke

                .despatch                       : irsaliye bilgileri
                actualdespatchdate              : irsaliye tarihi
                actualdespatchtime              : İrsaliye saati

            -transporthandlingunit              : taşıyıcı birimleri listesi
                .transportequipment             : taşıyıcı birim bilgileri
                id                              : id (örn: 34AB123)
                schemeid                        : şema adı (örn: DORSEPLAKA)

        --->

        <cfif isDefined("ubldoc.Shipment")>
            <cfset resultdata.shipment = structNew()>
            <cfset shipment = ubldoc.Shipment>
            <cfset resultdata.shipment.id = shipment.ID.XmlText>
            
            <cfif isDefined("shipment.GoodsItem")>
                <cfset resultdata.shipment.goodsitem = structNew()>
                <cfset goodsitem = shipment.GoodsItem>
                <cfif isDefined("goodsitem.ValueAmount")>
                    <cfset resultdata.shipment.goodsitem.valueamount = structNew()>
                    <cfset valueamount = goodsitem.ValueAmount>
                    <cfset resultdata.shipment.goodsitem.valueamount.value = valueamount.XmlText>
                    <cfset resultdata.shipment.goodsitem.valueamount.currencyid = valueamount.XmlAttributes.currencyID>
                </cfif>
            </cfif>

            <cfif isDefined("shipment.ShipmentStage")>
                <cfset resultdata.shipment.shipmentstage = arrayNew(1)>
                <cfloop array="#shipment.ShipmentStage.XmlChildren#" index="child">
                    <cfset shipmentstageitem = getShipmentStage(child)>
                    <cfif isDefined("shipmentstageitem")>
                        <cfset arrayAppend( resultdata.shipment.shipmentstage, shipmentstageitem )>
                    </cfif>
                </cfloop>
            </cfif>
            
            <cfif isDefined("shipment.Delivery")>
                <cfset resultdata.shipment.delivery = structNew()>
                <cfset delivery = shipment.Delivery>
                
                <cfif isDefined("delivery.CarrierParty")>
                    <cfset resultdata.shipment.delivery.carrierparty = structNew()>
                    <cfset carrierparty = delivery.CarrierParty>

                    <cfif isDefined("carrierparty.PartyIdentification")>
                        <cfset resultdata.shipment.delivery.carrierparty.partyidentification = structNew()>
                        <cfset resultdata.shipment.delivery.carrierparty.partyidentification.vkn = getPartyIdentification(delivery.CarrierParty, "VKN")>
                    </cfif>
                    
                    <cfif isDefined("carrierparty.PartyName")>
                        <cfset resultdata.shipment.delivery.carrierparty.partyname = structNew()>
                        <cfset partyname = carrierparty.PartyName>
                        <cfset resultdata.shipment.delivery.carrierparty.partyname.name = partyname.Name.XmlText>
                    </cfif>
                    
                    <cfif isDefined("carrierparty.PostalAddress")>
                        <cfset resultdata.shipment.delivery.carrierparty.postaladdress = getAddress(carrierparty.PostalAddress)>
                    </cfif>
                </cfif>

                <cfif isDefined("delivery.Despatch")>
                    <cfset resultdata.shipment.delivery.despatch = structNew()>
                    <cfset despatch = delivery.Despatch>
                    <cfset resultdata.shipment.delivery.despatch.actualdespatchdate = despatch.ActualDespatchDate.XmlText>
                    <cfif isdefined("despatch.ActualDespatchTime")>
                        <cfset resultdata.shipment.delivery.despatch.actualdespatchtime = despatch.ActualDespatchTime.XmlText>
                    </cfif>
                </cfif>
            </cfif>

            <cfif isDefined("shipment.TransportHandlingUnit")>
                <cfset resultdata.shipment.transporthandlingunit = arrayNew(1)>
                <cfset transporthandlingunit = shipment.TransportHandlingUnit>
                <cfloop array="#transporthandlingunit.XmlChildren#" index="child">
                    <cfset transportequipment = structNew()>
                    <cfset transportequipment.id = child.ID.XmlText>
                    <cfset transportequipment.schemeid = child.XmlAttributes.schemeID>
                    <cfset arrayAppend( resultdata.shipment.transporthandlingunit, transportequipment )>
                </cfloop>
            </cfif>
        </cfif>


        <!--- 
        -receiptline                            : irsaliye satır listesi
        .receiptlineitem                        : irsaliye satır bilgileri
        id                                      : satır no
        outstandingreason                       : sonra gönderilme açıklaması

            .receivedquantity                   : nakil miktarı bilgileri
            value                               : nakil miktarı
            unitcode                            : birim kodu
            
            .orderlinereference                 : sipariş satır referans bilgileri
            lineid                              : satır id

            .item                               : ürün bilgileri
            name                                : ürün adı
                .selleritemidentification       : satıcı ürün tanım bilgileri
                id                              : ürün id

            .shipment                           : taşıma bilgileri
            id                                  : id
                .goodsitem                      : değerli varlık bilgileri
                    .invoiceline                : fatura satırı bilgileri
                    id                          : id
                    invoicequantity             : miktar
                        .lineextensionamount    : satır tutar bilgileri
                        value                   : tutar
                        currencyid              : para birimi sembolü

                        .item                   : ürün bilgileri
                        name                    : adı
                    
                        .price                  : fiyat bilgileri
                        priceamount             : fiyat
                        currencyid              : para birimi sembolü

        --->
        
        <cfif isDefined("ubldoc.ReceiptLine")>
            <cfset resultdata.receiptlines = arrayNew(1)>
            <cfscript>
                receiptlines = arrayFilter(ubldoc.XmlChildren, function(item) {
                    return item.XmlName eq "cac:ReceiptLine";
                });
            </cfscript>
            <cfloop array="#receiptlines#" index="receiptline">
                <cfset receiptlineitem = structNew()>
                <cfset receiptlineitem.id = receiptline.ID.XmlText>
                
                <cfif isDefined("receiptline.ReceivedQuantity")>
                    <cfset receiptlineitem.receivedquantity = structNew()>
                    <cfset receiptlineitem.receivedquantity.value = receiptline.ReceivedQuantity.XmlText>
                    <cfset receiptlineitem.receivedquantity.unitcode = receiptline.ReceivedQuantity.XmlAttributes.unitCode>
                </cfif>

                <cfif isDefined("receiptline.OrderLineReference")>
                    <cfset receiptlineitem.orderlinereference = structNew()>
                    <cfset receiptlineitem.orderlinereference.lineid = receiptline.OrderLineReference.LineID.XmlText>
                </cfif>

                <cfset receiptlineitem.item = structNew()>
                <cfset receiptlineitem.item.name = despatchline.Item.Name.XmlText>
                <cfset receiptlineitem.item.sellersitemidentification = structNew()>
                <cfset receiptlineitem.item.sellersitemidentification.id = receiptline.Item.SellersItemIdentification.ID.XmlText>

                <cfif isDefined("receiptline.Shipment")>
                    <cfset receiptlineitem.shipment = structNew()>
                    <cfset shipment = receiptline.Shipment>
                    <cfset receiptlineitem.shipment.id = shipment.ID.XmlText>
                    
                    <cfif isDefined("shipment.GoodsItem")>
                        <cfset receiptlineitem.shipment.goodsitem = structNew()>
                        <cfset goodsitem = shipment.GoodsItem>

                        <cfif isDefined("goodsitem.InvoiceLine")>
                            <cfset receiptlineitem.shipment.goodsitem.invoiceline = structNew()>
                            <cfset invoiceline = goodsitem.InvoiceLine>
                            
                            <cfif isDefined("invoiceline.ID")>
                                <cfset receiptlineitem.shipment.goodsitem.invoiceline.id = invoiceline.ID.XmlText>
                            </cfif>
                            
                            <cfif isDefined("invoiceline.InvoicedQuantity")>
                                <cfset receiptlineitem.shipment.goodsitem.invoiceline.invoicedquantity = invoiceline.InvoicedQuantity.XmlText>
                            </cfif>
                            
                            <cfif isDefined("invoiceline.LineExtensionAmount")>
                                <cfset receiptlineitem.shipment.goodsitem.invoiceline.lineextensionamount = structNew()>
                                <cfset receiptlineitem.shipment.goodsitem.invoiceline.lineextensionamount.value = invoiceline.LineExtensionAmount.XmlText>
                                <cfset receiptlineitem.shipment.goodsitem.invoiceline.lineextensionamount.currencyid = invoiceline.LineExtensionAmount.XmlAttributes.currencyID>
                            </cfif>
                            
                            <cfif isDefined("invoiceline.Item")>
                                <cfset receiptlineitem.shipment.goodsitem.invoiceline.item = structNew()>
                                <cfset receiptlineitem.shipment.goodsitem.invoiceline.item.name = invoiceline.Item.Name.XmlText>
                            </cfif>

                            <cfif isDefined("invoiceline.Price")>
                                <cfset receiptlineitem.shipment.goodsitem.invoiceline.price = structNew()>
                                <cfset receiptlineitem.shipment.goodsitem.invoiceline.price.priceamount = invoiceline.Price.PriceAmount.XmlText>
                                <cfset receiptlineitem.shipment.goodsitem.invoiceline.price.currencyid = invoiceline.Price.PriceAmount.XmlAttributes.currencyID>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfif>

            </cfloop>
        </cfif>

        <cfreturn resultdata>
    </cffunction>

    <!--- Custom helpers --->

    <!--- 
    .address                                : adres bilgileri
    id                                      : id
    streetname                              : sokak ismi (opsiyonel)
    buildingnumber                          : bina no (opsiyonel)
    citysubdivisionname                     : ilçe/semt (opsiyonel)
    cityname                                : il
    postalzone                              : posta kodu
    country                                 : ülke
    --->
    <cffunction name="getAddress" access="private">
        <cfargument name="xmlelement">

        <cfset address = structNew()>

        <cfif isDefined("arguments.xmlelement.ID")>
            <cfset address.id = arguments.xmlelement.ID.XmlText>
        </cfif>
        <cfif isDefined("arguments.xmlelement.StreetName")>
            <cfset address.streetname = arguments.xmlelement.StreetName.XmlText>
        </cfif>
        <cfif isDefined("arguments.xmlelement.BuildingNumber")>
            <cfset address.buildingnumber = arguments.xmlelement.BuildingNumber.XmlText>
        </cfif>
        <cfif isDefined("arguments.xmlelement.CitySubdivisionName")>
            <cfset address.citysubdivisionname = arguments.xmlelement.CitySubdivisionName.XmlText>
        </cfif>
        <cfset address.cityname = arguments.xmlelement.CityName.XmlText>
        <cfif isDefined("arguments.xmlelement.PostalZone")>
            <cfset address.postalzone = arguments.xmlelement.PostalZone.XmlText>
        </cfif>
        <cfif isDefined("arguments.xmlelement.Country")>
            <cfset address.country = arguments.xmlelement.Country.Name.XmlText>
        </cfif>

        <cfreturn address>
    </cffunction>

    <!--- 
    .contact                                : İletişim bilgileri
    telephone                               : telefon (opsiyonel)
    telefax                                 : telefax (opsionel)
    electronicmail                          : e-posta (opsiyonel)
    --->
    <cffunction name="getContact" access="private">
        <cfargument name="xmlelement">

        <cfset contact = structNew()>

        <cfif isDefined("arguments.xmlelement.Telephone")>
            <cfset contact.telephone = arguments.xmlelement.Telephone.XmlText>
        </cfif>
        <cfif isDefined("arguments.xmlelement.Telefax")>
            <cfset contact.telefax = arguments.xmlelement.Telefax.XmlText>
        </cfif>
        <cfif isDefined("arguments.xmlelement.ElectronicMail")>
            <cfset contact.electronicmail = arguments.xmlelement.ElectronicMail.XmlText>
        </cfif>

        <cfreturn contact>
    </cffunction>

    <!--- Shipment stage parser factory --->
    <cffunction name="getShipmentStage" access="private">
        <cfargument name="xmlelement">

        <cfswitch expression="#arguments.xmlelement.XmlName#">
            <cfcase value="cac:TransportMeans">
                <cfreturn getShipmentStageAsTransportMeans(arguments.xmlelement)>
            </cfcase>
            <cfcase value="cac:DriverPerson">
                <cfreturn getShipmentStageAsDriverPerson(arguments.xmlelement)>
            </cfcase>
        </cfswitch>
    </cffunction>

    <!--- 
    -transportmeans                     : taşıyıcı araçları
        .roadtransport                  : yolda taşıyıcı bilgileri
        licenseplateid                  : plaka
    --->
    <cffunction name="getShipmentStageAsTransportMeans" access="private">
        <cfargument name="xmlelement">

        <cfset transportmeans = arrayNew(1)>
        <cfloop array="#arguments.xmlelement.XmlChildren#" index="child">
            <cfset roadtransport = structNew()>
            <cfset roadtransport.licenseplateid = child.LicensePlateID.XmlText>
            <cfset arrayAppend( transportmeans, roadtransport )>
        </cfloop>
        <cfreturn transportmeans>
    </cffunction>

    <!--- 
    .driverperson                       : Sürücü bilgileri
    firstname                           : adı
    familyname                          : soyadı
    title                               : ünvan
    nationalityid                       : tckimlik
    --->
    <cffunction name="getShipmentStageAsDriverPerson" access="private">
        <cfargument name="xmlelement">

        <cfset driverperson = structNew()>
        <cfset driverperson.firstname = arguments.xmlelement.FirstName.XmlText>
        <cfset driverperson.familyname = arguments.xmlelement.FamilyName.XmlText>
        <cfif isdefined("arguments.xmlelement.Title")>
            <cfset driverperson.title = arguments.xmlelement.Title.XmlText>
        </cfif>
		<cfif isdefined("arguments.xmlelement.NationalityID")>
			<cfset driverperson.nationalityid = arguments.xmlelement.NationalityID.XmlText>
		</cfif>
        <cfreturn driverperson>
    </cffunction>

    <!--- Get party identification from parent xml element when multiple tag used --->
    <cffunction name="getPartyIdentification" access="private">
        <cfargument name="xmlparent">
        <cfargument name="scheme">
        <cfset schema = arguments.scheme>
        <cfscript>
            filter_identification = arrayFilter(arguments.xmlparent.XmlChildren, function(item) { 
                return arguments.item.XmlName eq 'cac:PartyIdentification' and arguments.item.ID.XmlAttributes.schemeID eq schema;
            });
            if ( arrayLen(filter_identification) ) {
                return filter_identification[1].XmlChildren[1].XmlText;
            } else {
                return "";
            }
        </cfscript>
    </cffunction>


</cfcomponent>