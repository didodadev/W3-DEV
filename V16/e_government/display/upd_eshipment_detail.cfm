<cfsavecontent variable="head_text">
<title><cf_get_lang dictionary_id="60919.Gelen E-irsaliye"></title>
</cfsavecontent>
<cfhtmlhead text="#head_text#" />

<cfparam name="attributes.print" default="0" />
<cfset soap = createObject("Component","V16.e_government.cfc.eirsaliye.soap")>
<cfset soap.init()>
<cfset eshipment = createObject("Component","V16.e_government.cfc.eirsaliye.common")>
<cfset eshipment.dsn = dsn>
<cfset eshipment.dsn2 = dsn2>
<cfset parser = createObject("Component","V16.e_government.cfc.eirsaliye.parser")>
<cfif attributes.print eq 0>
    <cfset GET_ESHIPMENT_DET = eshipment.GET_ESHIPMENT_DETAIL(receiving_detail_id:attributes.receiving_detail_id)>
<cfelse>
    <cfset GET_ESHIPMENT_DET = eshipment.GET_ESHIPMENT_DETAIL(print_id:attributes.print_id)>
</cfif>
<cfloop query="GET_ESHIPMENT_DET">
<cfset ship_control = eshipment.SHIPMENT_CONTROL( ship_id : GET_ESHIPMENT_DET.ESHIPMENT_ID )>
<cfif GET_ESHIPMENT_DET.recordcount eq 0>
    <cfset hata  = 11>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'>  <cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
    <cfset hata_mesaj  = message>
    <cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cfif GET_ESHIPMENT_DET.PATH eq ''>
        İLGİLİ İRSALİYENİN DOSYA YOLU BOŞ!
    <cfelse>
        <cffile action="read" file="#upload_folder#eshipment_received#dir_seperator##GET_ESHIPMENT_DET.PATH#" variable="eshipment_xml_data" charset="utf-8">
        <cfif not isdefined("attributes.is_display")>
            <cfset resultdata = parser.get_eirsaliye(ubl_file:'#upload_folder#eshipment_received#dir_seperator##GET_ESHIPMENT_DET.PATH#')>
            <cfset temp_VKN = ''>
            <cfset member_name = ''>
            <cfset adres = ''>
            <cfset telefon = ''>
            <cfset website = ''>
            <cfset eposta = ''>
            <cfset vergi_dairesi = ''>
            <cfset member_name_gelen = ''>
            <cfset adres_gelen = ''>
            <cfset telefon_gelen = ''>
            <cfset website_gelen = ''>
            <cfset eposta_gelen = ''>
            <cfset vergi_dairesi_gelen = ''>
            <cfset vergi_no_gelen = ''>
            <cfset order_no = ''>
            <cfset order_date = ''>
            <cfset sevk_tarihi = ''>
            <cfset sevk_saati = ''>
            <cfset detail = ''>
            <cfset noteXML = ''>
            <cfset toplam_tutar = ''>
            <cfset para_birimi = ''>

            <cfif isDefined("resultdata.despatchsupplierparty.party.partyidentification.vkn") and len(resultdata.despatchsupplierparty.party.partyidentification.vkn)>
                <cfset temp_VKN = resultdata.despatchsupplierparty.party.partyidentification.vkn>
            </cfif>
            <cfif isDefined("resultdata.despatchsupplierparty.party.partyname.name") and len(resultdata.despatchsupplierparty.party.partyname.name)>
                <cfset member_name = resultdata.despatchsupplierparty.party.partyname.name>
            </cfif>
            <cfif isdefined("resultdata.despatchsupplierparty.party.postaladdress.streetname")>
                <cfset adres = '#adres# #resultdata.despatchsupplierparty.party.postaladdress.streetname#'>
            </cfif>
            <cfif isdefined("resultdata.despatchsupplierparty.party.postaladdress.buildingnumber")>
                <cfset adres = '#adres# No : #resultdata.despatchsupplierparty.party.postaladdress.buildingnumber#'>
            </cfif>
            <cfif isdefined("resultdata.despatchsupplierparty.party.postaladdress.citysubdivisionname")>
                <cfset adres = '#adres# #resultdata.despatchsupplierparty.party.postaladdress.citysubdivisionname#'>
            </cfif>
            <cfif isdefined("resultdata.despatchsupplierparty.party.postaladdress.cityname")>
                <cfset adres = '#adres#/#resultdata.despatchsupplierparty.party.postaladdress.cityname#'>
            </cfif>
            <cfif isdefined("resultdata.despatchsupplierparty.party.postaladdress.postalzone")>
                <cfset adres = '#adres# #resultdata.despatchsupplierparty.party.postaladdress.postalzone#'>
            </cfif>
            <cfif isdefined("resultdata.despatchsupplierparty.party.postaladdress.country")>
                <cfset adres = '#adres# #resultdata.despatchsupplierparty.party.postaladdress.country#'>
            </cfif>
            <cfif isdefined("resultdata.despatchsupplierparty.party.contact.telephone")>
                <cfset telefon = 'Tel : #resultdata.despatchsupplierparty.party.contact.telephone# '>
            </cfif>
            <cfif isdefined("resultdata.despatchsupplierparty.party.contact.telefax")>
                <cfset telefon = '#telefon# Fax : #resultdata.despatchsupplierparty.party.contact.telefax#'>
            </cfif>
            <cfif isdefined("resultdata.despatchsupplierparty.party.contact.electronicmail")>
                <cfset eposta = 'E-Posta : #resultdata.despatchsupplierparty.party.contact.electronicmail#'>
            </cfif>
            <cfif isDefined("resultdata.despatchsupplierparty.party.partytaxscheme.taxscheme.name")>
                <cfset vergi_dairesi = 'Vergi Dairesi : #resultdata.despatchsupplierparty.party.partytaxscheme.taxscheme.name#'>
            </cfif>
            <cfif isDefined("resultdata.deliverycustomerparty.party.partyname.name")>
                <cfset member_name_gelen = resultdata.deliverycustomerparty.party.partyname.name>
            </cfif>
            <cfif isdefined("resultdata.deliverycustomerparty.party.postaladdress.streetname")>
                <cfset adres_gelen = '#adres_gelen# #resultdata.deliverycustomerparty.party.postaladdress.streetname#'>
            </cfif>
            <cfif isdefined("resultdata.deliverycustomerparty.party.postaladdress.buildingnumber")>
                <cfset adres_gelen = '#adres_gelen# No : #resultdata.deliverycustomerparty.party.postaladdress.buildingnumber#'>
            </cfif>
            <cfif isdefined("resultdata.deliverycustomerparty.party.postaladdress.citysubdivisionname")>
                <cfset adres_gelen = '#adres_gelen# #resultdata.deliverycustomerparty.party.postaladdress.citysubdivisionname#'>
            </cfif>
            <cfif isdefined("resultdata.deliverycustomerparty.party.postaladdress.cityname")>
                <cfset adres_gelen = '#adres_gelen#/#resultdata.deliverycustomerparty.party.postaladdress.cityname#'>
            </cfif>
            <cfif isdefined("resultdata.deliverycustomerparty.party.postaladdress.postalzone")>
                <cfset adres_gelen = '#adres_gelen# #resultdata.deliverycustomerparty.party.postaladdress.postalzone#'>
            </cfif>
            <cfif isdefined("resultdata.deliverycustomerparty.party.postaladdress.country")>
                <cfset adres_gelen = '#adres_gelen# #resultdata.deliverycustomerparty.party.postaladdress.country#'>
            </cfif>
            <cfif isdefined("resultdata.deliverycustomerparty.party.contact.telephone")>
                <cfset telefon_gelen = 'Tel : #resultdata.deliverycustomerparty.party.contact.telephone# '>
            </cfif>
            <cfif isdefined("resultdata.deliverycustomerparty.party.contact.telefax")>
                <cfset telefon_gelen = '#telefon_gelen# Fax : #resultdata.deliverycustomerparty.party.contact.telefax#'>
            </cfif>
            <cfif isdefined("resultdata.deliverycustomerparty.party.contact.electronicmail")>
                <cfset eposta_gelen = 'E-Posta : #resultdata.deliverycustomerparty.party.contact.electronicmail#'>
            </cfif>
            <cfif isDefined("resultdata.deliverycustomerparty.party.partytaxscheme.taxscheme.name")>
                <cfset vergi_dairesi_gelen = 'Vergi Dairesi : #resultdata.deliverycustomerparty.party.partytaxscheme.taxscheme.name#'>
            </cfif>
            <cfif isDefined("resultdata.deliverycustomerparty.party.partyidentification.vkn")>
                <cfset vergi_no_gelen = 'VKN : #resultdata.deliverycustomerparty.party.partyidentification.vkn#'>
            </cfif>
            <cfif isdefined("resultdata.orderreference.id")>
                <cfset order_no = resultdata.orderreference.id>
                <cfset order_date = resultdata.orderreference.issuedate>
            </cfif>
            <cfif isDefined("resultdata.shipment.delivery.despatch.actualdespatchdate")>
                <cfset sevk_tarihi = resultdata.shipment.delivery.despatch.actualdespatchdate>
			</cfif>
			<cfif isDefined("resultdata.shipment.delivery.despatch.actualdespatchtime")>
                <cfset sevk_saati = listFirst(resultdata.shipment.delivery.despatch.actualdespatchtime,'.')>
            </cfif>
            <cfif isDefined("resultdata.shipment.goodsitem.valueamount.value")>
                <cfset toplam_tutar = resultdata.shipment.goodsitem.valueamount.value>
                <cfset para_birimi = resultdata.shipment.goodsitem.valueamount.currencyid>
            </cfif>	
            <cfif isdefined("resultdata.note")>
                <cfset noteXML = resultdata.note>
            </cfif>

            <style>
				.printThis_box td a > i{width: 25px;color: #555555;font-size: 14px;height: 25px;background: #f9f9f9;border: 1px solid #eaeaea;text-align: center;line-height: 25px!important;}
				.printThis_box span.wrkFileACtions i{margin:0!important;}
				.printThis_box span.wrkFileACtions{margin:0 0 0 5px!important;}
				.printThis_box{max-width:80%;border:0;box-shadow: 0 0 5px #eee!important;border:1px solid #eaeaea;padding:15px;margin:20px auto;letter-spacing:1px;}
				.printThis_box .popup_box_header{box-shadow:inherit!important;height:inherit!important;border:0!important;}
				.printThis_box .popup_box_header td{padding:4px!important;}
				.printThis_box font{display:inline-block;margin-top:3px;font-weight:bold;font-size:10px;}
				.printThis_box table{border-spacing:0;}
				.printThis_box table td{padding:2px!important;}
				/*.printThis_box table td textarea, .printThis_box table td input, .printThis_box table td select{width:100%!important;border:1px solid #ddd;}*/
				.printThis_box table td textarea{resize:none;border:1px solid #ddd;height:60px;}
				.printThis_box_not > tbody > tr > td{padding:0 2px!important;}
				.e-fatura {border:1px solid #DDDDDD;border-collapse:collapse;}
				.e-fatura tr  td{border:1px solid #DDDDDD;padding:4px!important;}
            </style>
            <cfif not len(GET_ESHIPMENT_DET.STATUS)>
				<cfif isdefined('temp_VKN') and len(temp_VKN)>
					<cfset control_member = eshipment.CONTROL_MEMBER(temp_VKN : temp_VKN)>
                <cfelse>
                    <cfset control_member.recordcount = 0>
                </cfif>
            <cfelse>
                <cfset control_member.recordcount = 0>
            </cfif>
        <cfif attributes.print eq 0>
            <cf_catalystheader>
            <cfform name="form_basket">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58138.İrsaliye No'></cfsavecontent>
                <div class="col col-9 col-xs-12">
                    <cf_box title="#message#: #GET_ESHIPMENT_DET.ESHIPMENT_ID#" closable="0" uidrop="1">
                        <div class="printThis">
                            <cfoutput>
                                <table bigList width="100%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td>
                                            <table width="100%" border="0">
                                                <tr>
                                                    <!---Gönderici Üye Bilgileri --->
                                                    <td>
                                                        <table width="100%">
                                                            <tr>
                                                                <td>
                                                                    <input type="text" name="comp_name" id="comp_name" readonly value="#member_name#" style="width:300px;">
                                                                    <cfif control_member.recordcount eq 1 and control_member.type eq 1>
                                                                        <input type="hidden" name="company_id" id="company_id" value="#control_member.member_id#">
																		<input type="hidden" name="partner_id" id="partner_id" value="#control_member.partner_id#">
                                                                        <input type="hidden" name="partner_name" id="partner_name" value="#control_member.partner_name#">
                                                                        <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                                                    <cfelseif control_member.recordcount eq 1 and control_member.type eq 2>
                                                                        <input type="hidden" name="company_id" id="company_id" value="">
																		<input type="hidden" name="partner_id" id="partner_id" value="">
                                                                        <input type="hidden" name="partner_name" id="partner_name" value="">
                                                                        <input type="hidden" name="consumer_id" id="consumer_id" value="#control_member.member_id#">                                                        
                                                                    <cfelse>
                                                                        <input type="hidden" name="company_id" id="company_id" value="">
																		<input type="hidden" name="partner_id" id="partner_id" value="">
                                                                        <input type="hidden" name="partner_name" id="partner_name" value="">
                                                                        <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                                                        <!-- sil --><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id','list');"> <i class="fa fa-ellipsis-v" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></i></a><!-- sil --> 
                                                                        <cfif control_member.recordcount neq 0>
                                                                            <font color="red"><cf_get_lang dictionary_id='33966.Vergi Numarası veya TC Kimlik Numarası İle İle Eşleşen Birden Fazla Üye Kaydı Mevcut.'><cf_get_lang dictionary_id='34146.Lütfen Üye Seçiniz !'></font>
                                                                        <cfelse>
                                                                            <font color="red"><cf_get_lang dictionary_id='34143.Vergi Numarası veya TC Kimlik Numarası İle Eşleşen Üye Kaydı Bulunamadı.'><cf_get_lang dictionary_id='34146.Lütfen Üye Seçiniz !'></font>
                                                                        </cfif>
                                                                    </cfif>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>#adres#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>#telefon#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>#website#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>#eposta#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>#vergi_dairesi#</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <!--- Logo --->
                                                    <td>
                                                        <table align="right">
                                                            <tr>
                                                                <td style="text-align:center">
                                                                    <cfoutput><img width="100" height="100" src="images/gib_logo.png"></cfoutput>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td style="text-align:center"><b><cf_get_lang dictionary_id='60911.E-İrsaliye'></b></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <!--- Alıcı Üye Bilgileri --->
                                                    <td>
                                                        <table width="250px">
                                                            <tr>
                                                                <td><b><cf_get_lang dictionary_id='58780.SAYIN'>#member_name_gelen#</b></td>
                                                            </tr>
                                                            <tr>
                                                                <td>#adres_gelen#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>#telefon_gelen#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>#website_gelen#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>#eposta_gelen#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>#vergi_dairesi_gelen#</td>
                                                            </tr>
                                                            <tr>
                                                                <td>#vergi_no_gelen#</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                    <!--- fatura bilgileri --->
                                                    <td>
                                                        <table border="1" class="e-fatura" width="100%" cellpadding="2" cellspacing="0" bordercolor="DDDDDD">
                                                            <tr>
                                                                <td><b><cf_get_lang dictionary_id='34139.Özelleştirme'><cf_get_lang dictionary_id='57487.NO'></b></td>
                                                                <td>#resultdata.customizationid#</td>
                                                            </tr>
                                                            <tr>
                                                                <td><b><cf_get_lang dictionary_id='59321.Senaryo'></b></td>
                                                                <td>#resultdata.profileid#</td>
                                                            </tr>
                                                            <tr>
                                                                <td><b><cf_get_lang dictionary_id='29430.İrsaliye Tipi'></b></td>
                                                                <td>#resultdata.despatchadvicetypecode#</td>
                                                            </tr>
                                                            <tr>
                                                                <td><b><cf_get_lang dictionary_id='58138.İrsaliye No'></b></td>
                                                                <td>#resultdata.id#</td>
                                                            </tr>
                                                            <tr>
                                                                <td><b><cf_get_lang dictionary_id='33096.İrsaliye Tarihi'></b></td>
                                                                <td style="text-align:left;">#dateformat(resultdata.issuedate, dateformat_style)#</td>
                                                            </tr>
                                                            <tr>
                                                                <td><b><cf_get_lang dictionary_id='57773.İrsaliye'><cf_get_lang dictionary_id='41697.Zamanı'></b></td>
                                                                <td style="text-align:left;">#timeformat(listFirst(resultdata.issuetime,'.'), timeformat_style)#</td>
                                                            </tr>
                                                            <tr>
                                                                <td><b><cf_get_lang dictionary_id='34797.Sevk Tarihi'></b></td>
                                                                <td style="text-align:left;">#dateformat(sevk_tarihi, dateformat_style)#</td>
                                                            </tr>
                                                            <tr>
                                                                <td><b><cf_get_lang dictionary_id='58761.Sevk'><cf_get_lang dictionary_id='41697.Zamanı'></b></td>
                                                                <td style="text-align:left;">#timeformat(sevk_saati, timeformat_style)#</td>
                                                            </tr>
                                                            <tr>
                                                                <td><b><cf_get_lang dictionary_id='58211.Sipariş No'></b></td>
                                                                <td>
                                                                    <div class="ui-form-list ui-form-block">
                                                                        <div class="form-group" id="item-order_id_form">
                                                                            <div class="input-group">
                                                                                <input type="hidden" name="order_id_listesi" id="order_id_listesi" value="">
                                                                                <input type="hidden" name="order_create_from_row" id="order_create_from_row" value="">
                                                                                <input type="hidden" name="order_create_row_list" id="order_create_row_list" value="">
                                                                                <input type="text" name="order_id_form" id="order_id_form" value="#order_no#">
                                                                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="add_order();"></span>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td><b><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></b></td>
                                                                <td>
                                                                    <div class="ui-form-list ui-form-block">
                                                                        <div class="form-group" id="item-order_date_form">
                                                                            <input type="text" name="order_date" id="order_date" value="#dateformat(order_date,'dd-mm-yyyy')#">
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table width="100%" border="0" cellpadding="2" cellspacing="0">
                                                <tr>
                                                    <td><b>ETTN: </b>#resultdata.uuid#</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <table border="1" class="e-fatura" width="100%" cellpadding="2" cellspacing="0" bordercolor="DDDDDD">
                                                            <tr height="20">
                                                                <td><b><cf_get_lang dictionary_id='31253.Sıra No'></b></td>
                                                                <td colspan="2"><b><cf_get_lang dictionary_id='45517.Mal'></b></td>
                                                                <td><b><cf_get_lang dictionary_id='57635.Miktar'></b></td>
                                                                <td><b><cf_get_lang dictionary_id='57638.Birim Fiyat'></b></td>
                                                                <td><b><cf_get_lang dictionary_id='60930.Sonradan Gönderilecek Miktar'></b></td>
                                                                <td><b><cf_get_lang dictionary_id='57673.Tutar'></b></td>
                                                            </tr>
                                                            <input type="hidden" name="line_count" id="line_count" value="#arraylen(resultdata.despatchline)#">
                                                            <cfif arraylen(resultdata.despatchline) gt 0>
                                                                <cfloop from="1" to="#arraylen(resultdata.despatchline)#" index="kk">
                                                                    <cftry>
                                                                        <cfset product_name_tax = '#resultdata.despatchline[kk].item.name#'>
                                                                        <cfcatch type="any">
                                                                            <cfset product_name_tax = "">
                                                                        </cfcatch>
                                                                    </cftry>
                                                                    <cfscript>
                                                                        product_name = '';
                                                                        quantity = '';
                                                                        unit_code = '';
                                                                        out_quantity = '';
                                                                        out_unit_code = '';
                                                                        price = 0;
                                                                        money = '';
                                                                        amount = '';
                                                                    </cfscript>
                                                                    <cftry>
                                                                            <cfset product_name = '#replace(trim(resultdata.despatchline[kk].item.name),'"','')#'>
                                                                            <!--- Ürün adında enter varsa ürün popupı açılmıyor o yüzden yeni satır karakterleri replace edildi --->
                                                                            <cfset product_name = '#replace(replace(product_name,"#chr(13)#"," "),"#chr(10)#"," ")#'>
                                                                            <cfif structkeyexists(resultdata.despatchline[kk], 'deliveredquantity')>
                                                                                <cfset quantity = '#resultdata.despatchline[kk].deliveredquantity.value#'>
                                                                                <cfset unit_code = '#resultdata.despatchline[kk].deliveredquantity.unitcode#'>
                                                                            </cfif>
                                                                            <cfif structkeyexists(resultdata.despatchline[kk], 'outstandingquantity')>
                                                                                <cfset out_quantity = '#resultdata.despatchline[kk].outstandingquantity.value#'>
                                                                                <cfset out_unit_code = '#resultdata.despatchline[kk].outstandingquantity.unitcode#'>
                                                                            </cfif>
                                                                            <cfif structkeyexists(resultdata.despatchline[kk], 'shipment.goodsitem.invoiceline.price.priceamount')>
                                                                                <cfset price = '#resultdata.despatchline[kk].shipment.goodsitem.invoiceline.price.priceamount#'>
                                                                                <cfset money = '#resultdata.despatchline[kk].shipment.goodsitem.invoiceline.price.currencyid#'>
                                                                            </cfif>
                                                                            <cfif structkeyexists(resultdata.despatchline[kk], 'shipment.goodsitem.invoiceline.lineextensionamount.value')>
                                                                                <cfset amount = '#resultdata.despatchline[kk].shipment.goodsitem.invoiceline.lineextensionamount.value#'>
                                                                            </cfif>
                                                                        <cfcatch type="any">
                                                                            <cfscript>
                                                                                product_name = '';
                                                                                quantity = '';
                                                                                unit_code = '';
                                                                                out_quantity = '';
                                                                                out_unit_code = '';
                                                                                price = '';
                                                                                money = '';
                                                                                amount = '';
                                                                            </cfscript>
                                                                        </cfcatch>
                                                                    </cftry>
                                                                    <cfif len(product_name) or len(product_name_tax)>
                                                                        <cfquery name="get_unit_code" datasource="#dsn#">
                                                                            SELECT UNIT FROM SETUP_UNIT WHERE UNIT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unit_code#">
                                                                        </cfquery>
                                                                        <cfquery name="get_out_unit_code" datasource="#dsn#">
                                                                            SELECT UNIT FROM SETUP_UNIT WHERE UNIT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#out_unit_code#">
                                                                        </cfquery>
                                                                        <tr>
                                                                            <td>#kk#</td>
                                                                            <td>
                                                                                <cfif len(product_name)>#product_name#<cfelse>#product_name_tax#</cfif>&nbsp;&nbsp;&nbsp;&nbsp;
                                                                                <input type="hidden" name="stock_id_#kk#" id="stock_id_#kk#" value="">
                                                                                <input type="hidden" name="quantity_#kk#" id="quantity_#kk#" value="#quantity#">
                                                                            </td>
                                                                            <td>
                                                                                <!-- sil -->
                                                                                <cfif not len(GET_ESHIPMENT_DET.status)>
                                                                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id_#kk#&keyword=#product_name#','list');"><i class="fa fa-ellipsis-v"></i></a>
                                                                                </cfif>
                                                                                <!-- sil -->
                                                                            </td>
                                                                            <td style="text-align:right;">#tlformat(quantity)# #get_unit_code.unit#</td>
                                                                            <td style="text-align:right;">#tlformat(out_quantity)# #get_out_unit_code.unit#</td>
                                                                            <td style="text-align:right;">#tlformat(price)# #money#</td>
                                                                            <td style="text-align:right;">#tlformat(amount)#</td>
                                                                        </tr>
                                                                    </cfif>
                                                                </cfloop>
                                                                <cfloop from="1" to="#20-arraylen(resultdata.despatchline)#" index="jj">
                                                                    <tr height="20">
                                                                        <td>&nbsp;</td>
                                                                        <td colspan="2">&nbsp;</td>
                                                                        <td>&nbsp;</td>
                                                                        <td>&nbsp;</td>
                                                                        <td>&nbsp;</td>
                                                                        <td>&nbsp;</td>
                                                                    </tr>
                                                                </cfloop>
                                                            </cfif>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table width="100%" border="0" cellpadding="2" cellspacing="0" >
                                                <tr>
                                                    <td>
                                                        <table align="right" width="300" border="1" class="e-fatura" cellpadding="2" cellspacing="0" bordercolor="DDDDDD">					
                                                            <tr>
                                                                <td style="text-align:right;"><b><cf_get_lang dictionary_id='29534.Toplam Tutar'></b></td>
                                                                <td style="text-align:right;">#tlformat(toplam_tutar)# #para_birimi#</td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>
                                            <table width="100%" border="0" cellpadding="2" cellspacing="0">
                                                <tr>
                                                    <td>
                                                        <table width="100%" border="1" cellpadding="2" cellspacing="0" class="e-fatura" bordercolor="DDDDDD">
                                                            <tr>
                                                                <td>
                                                                    <b><cf_get_lang dictionary_id="46408.Açıklamalar"></b><br>
                                                                    &nbsp;&nbsp;<b><cf_get_lang dictionary_id='57467.Not'>:</b> #noteXML#<br>
                                                                    &nbsp;&nbsp;<b><cf_get_lang dictionary_id='33211.Teslim Eden'>:</b> #isDefined("resultdata.despatchsupplierparty.despatchcontact.name") ? resultdata.despatchsupplierparty.despatchcontact.name : ""#
                                                                </td>
                                                                <td>
                                                                    <b><cf_get_lang dictionary_id="60931.Taşıyıcı Bilgileri"></b><br>
                                                                    &nbsp;&nbsp;<b><cf_get_lang dictionary_id="39248.Taşıyıcı Firma">:</b>
                                                                        <cfif isDefined("resultdata.shipment.delivery.carrierparty.partyidentification.vkn")> VKN : #resultdata.shipment.delivery.carrierparty.partyidentification.vkn#</cfif>
                                                                        <cfif isDefined("resultdata.shipment.delivery.carrierparty.partyname.name")>, #resultdata.shipment.delivery.carrierparty.partyname.name#</cfif>
                                                                        <br>
                                                                    <cfif isDefined("resultdata.shipment.shipmentstage.roadtransport") and arrayLen(resultdata.shipment.shipmentstage.roadtransport)>
                                                                        <cfloop array="#resultdata.shipment.shipmentstage.roadtransport#" index="roadtransport">
                                                                            &nbsp;&nbsp;<b><cf_get_lang dictionary_id="60932.Araç Plaka numarası">:</b> #roadtransport.licenseplateid#<br>
                                                                        </cfloop>
                                                                    </cfif>
                                                                    <cfif isDefined("resultdata.shipment.shipmentstage.driverperson") and arrayLen(resultdata.shipment.shipmentstage.driverperson)>
                                                                        <cfloop array="#resultdata.shipment.shipmentstage.driverperson#" index="driverperson">
                                                                            &nbsp;&nbsp;<b><cf_get_lang dictionary_id="60933.Şoför">:</b> #driverperson.firstname# #driverperson.familyname#, TCKN : #driverperson.nationalityid#<br>
                                                                        </cfloop>
                                                                    </cfif>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </table>					
                                        </td>
                                    </tr>
                                </table>
                            </cfoutput>
                        </div>
                    </cf_box>
                </div>
                <cfsavecontent variable="upd_"><cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
                <div class="col col-3 col-xs-12">
                    <cf_box title="#upd_#" closable="0">
                        <cfif isdefined('attributes.associate') and attributes.associate eq 1>
                            <div class="ui-form-list ui-form-block">
                                <div class="col col-12">
                                    <div class="form-group">
                                        <label><cf_get_lang dictionary_id='57468.Belge'></label>
                                        <div class="input-group">
                                            <input type="hidden" name="receiving_detail_id" value="<cfoutput>#GET_ESHIPMENT_DET.receiving_detail_id#</cfoutput>">
                                            <input type="hidden" name="associate" value="1">
                                            <input type="hidden" name="related_ship_type" id="related_ship_type" value="">
                                            <input type="hidden" name="related_ship_id" id="related_ship_id" value="">
                                            <input type="text" name="related_ship_number" id="related_ship_number" readonly="yes" value="" />
                                            <cfset str_invoice_link="ship_type=form_basket.related_ship_type&ship_id=form_basket.related_ship_id&ship_number=form_basket.related_ship_number&eshipment_associate=1">
                                            <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=stock.popup_list_ship_details&#str_invoice_link#'</cfoutput>,'list','popup_list_bills');">
                                            </span>    
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <a href="javascript://" onclick="relation_paper();" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id='64268.Belge ilişkilendir'></a>
                                    </div>
                                        
                                </div>
                            </div>
                        <cfelse>
                            <div class="ui-form-list ui-form-block">
                                <div class="col col-12">
                                    <!--- <div class="form-group">
                                        <label><cf_get_lang dictionary_id="58859.Süreç"></label>
                                        <cf_workcube_process
                                            is_upd='0'
                                            select_value='#GET_ESHIPMENT_DET.process_stage#'
                                            is_detail='1'>
                                    </div> --->
                                    <cfset get_vkn = eshipment.get_our_company_fnc(session.ep.company_id)>
                                    <div class="form-group">
                                        <input type="hidden" name="eshipment_action_id" value="<cfoutput>#GET_ESHIPMENT_DET.receiving_detail_id#</cfoutput>">
                                        <input type="hidden" name="receiving_detail_id" value="<cfoutput>#GET_ESHIPMENT_DET.receiving_detail_id#</cfoutput>">
                                        <label><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
                                        <select name="shipment_type" id="shipment_type">
                                            <option value="1"><cf_get_lang dictionary_id='30097.Alış İrsaliye'></option>
                                            <cfif GET_ESHIPMENT_DET.SENDER_TAX_ID eq get_vkn.TAX_NO>
                                            <option value="2"><cf_get_lang dictionary_id='29587.Sevk İrsaliyesi'></option>
                                            </cfif>
                                        </select>
                                    </div>                                
                                    <cfif GET_ESHIPMENT_DET.status Eq 1>
                                        <div class="form-group">
                                            <font color="009933"><cf_get_lang dictionary_id='57773.İrsaliye'><cf_get_lang dictionary_id='58699.Onaylandı'></font>
                                        </div>
                                    </cfif>
                                    <cfif GET_ESHIPMENT_DET.status Eq 0>
                                        <div class="form-group">
                                            <font color="red"><cf_get_lang dictionary_id='57773.İrsaliye'><cf_get_lang dictionary_id='57617.Reddedildi'></font>
                                        </div>
                                    </cfif>
                                    <cfscript>
                                        show_buttons		= 0;
                                        show_decline_button	= 0;

                                        if ((Not Len(GET_ESHIPMENT_DET.IS_PROCESS) Or GET_ESHIPMENT_DET.IS_PROCESS is 0)) {
                                            show_buttons	= 1;
                                            show_decline_button	= 1;
                                        }
                                    </cfscript>
                                </div>
                            </div>
                            <div class="ui-form-list-btn">
                                <cfif show_buttons>
                                    <cfoutput>
                                        <div>
                                            <a class="ui-btn ui-btn-success" href="javascript://" onclick="add_paper();"><cf_get_lang dictionary_id="60079.Kabul Et"></a>
                                        </div>
                                        <cfif show_decline_button>
                                            <div>
                                                <a class="ui-btn ui-btn-delete" href="javascript://" onclick="if(confirm('İrsaliyeyi Red Etmek İstiyor Musunuz ?')) windowopen('#request.self#?fuseaction=stock.popup_reject_despatch&receiving_detail_id=#attributes.receiving_detail_id#','small');"><cf_get_lang dictionary_id="58461.Reddet"></a>
                                            </div>
                                        </cfif>
                                    </cfoutput>
                                </cfif>
                                <!--- <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'> --->
                            </div>
                        </cfif>
                        <div class="ui-info-bottom "><cf_record_info query_name="GET_ESHIPMENT_DET"></div>
                    </cf_box>
                </div>
            </cfform>
        <cfelse>
            <cfoutput>
                <div class="printThis" style="page-break-after:always;-webkit-region-break-after: always;background:##fff">
                    <table bigList style="width:210mm;" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <table width="100%" border="0">
                                    <tr>
                                        <!---Gönderici Üye Bilgileri --->
                                        <td>
                                            <table width="100%">
                                                <tr>
                                                    <td>
                                                        <input type="text" name="comp_name" id="comp_name" readonly value="#member_name#" style="width:300px;">
                                                        <cfif control_member.recordcount eq 1 and control_member.type eq 1>
                                                            <input type="hidden" name="company_id" id="company_id" value="#control_member.member_id#">
                                                            <input type="hidden" name="partner_id" id="partner_id" value="#control_member.partner_id#">
                                                            <input type="hidden" name="partner_name" id="partner_name" value="#control_member.partner_name#">
                                                            <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                                        <cfelseif control_member.recordcount eq 1 and control_member.type eq 2>
                                                            <input type="hidden" name="company_id" id="company_id" value="">
                                                            <input type="hidden" name="partner_id" id="partner_id" value="">
                                                            <input type="hidden" name="partner_name" id="partner_name" value="">
                                                            <input type="hidden" name="consumer_id" id="consumer_id" value="#control_member.member_id#">                                                        
                                                        <cfelse>
                                                            <input type="hidden" name="company_id" id="company_id" value="">
                                                            <input type="hidden" name="partner_id" id="partner_id" value="">
                                                            <input type="hidden" name="partner_name" id="partner_name" value="">
                                                            <input type="hidden" name="consumer_id" id="consumer_id" value="">
                                                            <!-- sil --><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id','list');"> <i class="fa fa-ellipsis-v" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></i></a><!-- sil --> 
                                                            <cfif control_member.recordcount neq 0>
                                                                <font color="red"><cf_get_lang dictionary_id='33966.Vergi Numarası veya TC Kimlik Numarası İle İle Eşleşen Birden Fazla Üye Kaydı Mevcut.'><cf_get_lang dictionary_id='34146.Lütfen Üye Seçiniz !'></font>
                                                            <cfelse>
                                                                <font color="red"><cf_get_lang dictionary_id='34143.Vergi Numarası veya TC Kimlik Numarası İle Eşleşen Üye Kaydı Bulunamadı.'><cf_get_lang dictionary_id='34146.Lütfen Üye Seçiniz !'></font>
                                                            </cfif>
                                                        </cfif>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>#adres#</td>
                                                </tr>
                                                <tr>
                                                    <td>#telefon#</td>
                                                </tr>
                                                <tr>
                                                    <td>#website#</td>
                                                </tr>
                                                <tr>
                                                    <td>#eposta#</td>
                                                </tr>
                                                <tr>
                                                    <td>#vergi_dairesi#</td>
                                                </tr>
                                            </table>
                                        </td>
                                        <!--- Logo --->
                                        <td>
                                            <table align="right">
                                                <tr>
                                                    <td style="text-align:center">
                                                        <cfoutput><img width="100" height="100" src="images/gib_logo.png"></cfoutput>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align:center"><b><cf_get_lang dictionary_id='60911.E-İrsaliye'></b></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <!--- Alıcı Üye Bilgileri --->
                                        <td>
                                            <table width="250px">
                                                <tr>
                                                    <td><b><cf_get_lang dictionary_id='58780.SAYIN'>#member_name_gelen#</b></td>
                                                </tr>
                                                <tr>
                                                    <td>#adres_gelen#</td>
                                                </tr>
                                                <tr>
                                                    <td>#telefon_gelen#</td>
                                                </tr>
                                                <tr>
                                                    <td>#website_gelen#</td>
                                                </tr>
                                                <tr>
                                                    <td>#eposta_gelen#</td>
                                                </tr>
                                                <tr>
                                                    <td>#vergi_dairesi_gelen#</td>
                                                </tr>
                                                <tr>
                                                    <td>#vergi_no_gelen#</td>
                                                </tr>
                                            </table>
                                        </td>
                                        <!--- fatura bilgileri --->
                                        <td>
                                            <table border="1" class="e-fatura" width="100%" cellpadding="2" cellspacing="0" bordercolor="DDDDDD">
                                                <tr>
                                                    <td><b><cf_get_lang dictionary_id='34139.Özelleştirme'><cf_get_lang dictionary_id='57487.NO'></b></td>
                                                    <td>#resultdata.customizationid#</td>
                                                </tr>
                                                <tr>
                                                    <td><b><cf_get_lang dictionary_id='59321.Senaryo'></b></td>
                                                    <td>#resultdata.profileid#</td>
                                                </tr>
                                                <tr>
                                                    <td><b><cf_get_lang dictionary_id='29430.İrsaliye Tipi'></b></td>
                                                    <td>#resultdata.despatchadvicetypecode#</td>
                                                </tr>
                                                <tr>
                                                    <td><b><cf_get_lang dictionary_id='58138.İrsaliye No'></b></td>
                                                    <td>#resultdata.id#</td>
                                                </tr>
                                                <tr>
                                                    <td><b><cf_get_lang dictionary_id='33096.İrsaliye Tarihi'></b></td>
                                                    <td style="text-align:left;">#dateformat(resultdata.issuedate, dateformat_style)#</td>
                                                </tr>
                                                <tr>
                                                    <td><b><cf_get_lang dictionary_id='57773.İrsaliye'><cf_get_lang dictionary_id='41697.Zamanı'></b></td>
                                                    <td style="text-align:left;">#timeformat(listFirst(resultdata.issuetime,'.'), timeformat_style)#</td>
                                                </tr>
                                                <tr>
                                                    <td><b><cf_get_lang dictionary_id='34797.Sevk Tarihi'></b></td>
                                                    <td style="text-align:left;">#dateformat(sevk_tarihi, dateformat_style)#</td>
                                                </tr>
                                                <tr>
                                                    <td><b><cf_get_lang dictionary_id='58761.Sevk'><cf_get_lang dictionary_id='41697.Zamanı'></b></td>
                                                    <td style="text-align:left;">#timeformat(sevk_saati, timeformat_style)#</td>
                                                </tr>
                                                <tr>
                                                    <td><b><cf_get_lang dictionary_id='58211.Sipariş No'></b></td>
                                                    <td>
                                                        <div class="ui-form-list ui-form-block">
                                                            <div class="form-group" id="item-order_id_form">
                                                                <div class="input-group">
                                                                    <input type="hidden" name="order_id_listesi" id="order_id_listesi" value="">
                                                                    <input type="text" name="order_id_form" id="order_id_form" value="#order_no#">
                                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="add_order();"></span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><b><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></b></td>
                                                    <td>
                                                        <div class="ui-form-list ui-form-block">
                                                            <div class="form-group" id="item-order_date_form">
                                                                <input type="text" name="order_date" id="order_date" value="#dateformat(order_date,'dd-mm-yyyy')#">
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <table width="100%" border="0" cellpadding="2" cellspacing="0">
                                    <tr>
                                        <td><b>ETTN: </b>#resultdata.uuid#</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table border="1" class="e-fatura" width="100%" cellpadding="2" cellspacing="0" bordercolor="DDDDDD">
                                                <tr height="20">
                                                    <td><b><cf_get_lang dictionary_id='31253.Sıra No'></b></td>
                                                    <td colspan="2"><b><cf_get_lang dictionary_id='45517.Mal'></b></td>
                                                    <td><b><cf_get_lang dictionary_id='57635.Miktar'></b></td>
                                                    <td><b><cf_get_lang dictionary_id='57638.Birim Fiyat'></b></td>
                                                    <td><b><cf_get_lang dictionary_id='60930.Sonradan Gönderilecek Miktar'></b></td>
                                                    <td><b><cf_get_lang dictionary_id='57673.Tutar'></b></td>
                                                </tr>
                                                <input type="hidden" name="line_count" id="line_count" value="#arraylen(resultdata.despatchline)#">
                                                <cfif arraylen(resultdata.despatchline) gt 0>
                                                    <cfloop from="1" to="#arraylen(resultdata.despatchline)#" index="kk">
                                                        <cftry>
                                                            <cfset product_name_tax = '#resultdata.despatchline[kk].item.name#'>
                                                            <cfcatch type="any">
                                                                <cfset product_name_tax = "">
                                                            </cfcatch>
                                                        </cftry>
                                                        <cfscript>
                                                            product_name = '';
                                                            quantity = '';
                                                            unit_code = '';
                                                            out_quantity = '';
                                                            out_unit_code = '';
                                                            price = 0;
                                                            money = '';
                                                            amount = '';
                                                        </cfscript>
                                                        <cftry>
                                                                <cfset product_name = '#replace(trim(resultdata.despatchline[kk].item.name),'"','')#'>
                                                                <!--- Ürün adında enter varsa ürün popupı açılmıyor o yüzden yeni satır karakterleri replace edildi --->
                                                                <cfset product_name = '#replace(replace(product_name,"#chr(13)#"," "),"#chr(10)#"," ")#'>
                                                                <cfif structkeyexists(resultdata.despatchline[kk], 'deliveredquantity')>
                                                                    <cfset quantity = '#resultdata.despatchline[kk].deliveredquantity.value#'>
                                                                    <cfset unit_code = '#resultdata.despatchline[kk].deliveredquantity.unitcode#'>
                                                                </cfif>
                                                                <cfif structkeyexists(resultdata.despatchline[kk], 'outstandingquantity')>
                                                                    <cfset out_quantity = '#resultdata.despatchline[kk].outstandingquantity.value#'>
                                                                    <cfset out_unit_code = '#resultdata.despatchline[kk].outstandingquantity.unitcode#'>
                                                                </cfif>
                                                                <cfif structkeyexists(resultdata.despatchline[kk], 'shipment.goodsitem.invoiceline.price.priceamount')>
                                                                    <cfset price = '#resultdata.despatchline[kk].shipment.goodsitem.invoiceline.price.priceamount#'>
                                                                    <cfset money = '#resultdata.despatchline[kk].shipment.goodsitem.invoiceline.price.currencyid#'>
                                                                </cfif>
                                                                <cfif structkeyexists(resultdata.despatchline[kk], 'shipment.goodsitem.invoiceline.lineextensionamount.value')>
                                                                    <cfset amount = '#resultdata.despatchline[kk].shipment.goodsitem.invoiceline.lineextensionamount.value#'>
                                                                </cfif>
                                                            <cfcatch type="any">
                                                                <cfscript>
                                                                    product_name = '';
                                                                    quantity = '';
                                                                    unit_code = '';
                                                                    out_quantity = '';
                                                                    out_unit_code = '';
                                                                    price = '';
                                                                    money = '';
                                                                    amount = '';
                                                                </cfscript>
                                                            </cfcatch>
                                                        </cftry>
                                                        <cfif len(product_name) or len(product_name_tax)>
                                                            <cfquery name="get_unit_code" datasource="#dsn#">
                                                                SELECT UNIT FROM SETUP_UNIT WHERE UNIT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unit_code#">
                                                            </cfquery>
                                                            <cfquery name="get_out_unit_code" datasource="#dsn#">
                                                                SELECT UNIT FROM SETUP_UNIT WHERE UNIT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#out_unit_code#">
                                                            </cfquery>
                                                            <tr>
                                                                <td>#kk#</td>
                                                                <td>
                                                                    <cfif len(product_name)>#product_name#<cfelse>#product_name_tax#</cfif>&nbsp;&nbsp;&nbsp;&nbsp;
                                                                    <input type="hidden" name="stock_id_#kk#" id="stock_id_#kk#" value="">
                                                                    <input type="hidden" name="quantity_#kk#" id="quantity_#kk#" value="#quantity#">
                                                                </td>
                                                                <td>
                                                                    <!-- sil -->
                                                                    <cfif not len(GET_ESHIPMENT_DET.status)>
                                                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id_#kk#&keyword=#product_name#','list');"><i class="fa fa-ellipsis-v"></i></a>
                                                                    </cfif>
                                                                    <!-- sil -->
                                                                </td>
                                                                <td style="text-align:right;">#tlformat(quantity)# #get_unit_code.unit#</td>
                                                                <td style="text-align:right;">#tlformat(out_quantity)# #get_out_unit_code.unit#</td>
                                                                <td style="text-align:right;">#tlformat(price)# #money#</td>
                                                                <td style="text-align:right;">#tlformat(amount)#</td>
                                                            </tr>
                                                        </cfif>
                                                    </cfloop>
                                                    <cfloop from="1" to="#20-arraylen(resultdata.despatchline)#" index="jj">
                                                        <tr height="20">
                                                            <td>&nbsp;</td>
                                                            <td colspan="2">&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                            <td>&nbsp;</td>
                                                        </tr>
                                                    </cfloop>
                                                </cfif>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <table width="100%" border="0" cellpadding="2" cellspacing="0" >
                                    <tr>
                                        <td>
                                            <table align="right" width="300" border="1" class="e-fatura" cellpadding="2" cellspacing="0" bordercolor="DDDDDD">					
                                                <tr>
                                                    <td style="text-align:right;"><b><cf_get_lang dictionary_id='29534.Toplam Tutar'></b></td>
                                                    <td style="text-align:right;">#tlformat(toplam_tutar)# #para_birimi#</td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                                <table width="100%" border="0" cellpadding="2" cellspacing="0">
                                    <tr>
                                        <td>
                                            <table width="100%" border="1" cellpadding="2" cellspacing="0" class="e-fatura" bordercolor="DDDDDD">
                                                <tr>
                                                    <td>
                                                        <b><cf_get_lang dictionary_id="46408.Açıklamalar"></b><br>
                                                        &nbsp;&nbsp;<b><cf_get_lang dictionary_id='57467.Not'>:</b> #noteXML#<br>
                                                        &nbsp;&nbsp;<b><cf_get_lang dictionary_id='33211.Teslim Eden'>:</b> #isDefined("resultdata.despatchsupplierparty.despatchcontact.name") ? resultdata.despatchsupplierparty.despatchcontact.name : ""#
                                                    </td>
                                                    <td>
                                                        <b><cf_get_lang dictionary_id="60931.Taşıyıcı Bilgileri"></b><br>
                                                        &nbsp;&nbsp;<b><cf_get_lang dictionary_id="39248.Taşıyıcı Firma">:</b>
                                                            <cfif isDefined("resultdata.shipment.delivery.carrierparty.partyidentification.vkn")> VKN : #resultdata.shipment.delivery.carrierparty.partyidentification.vkn#</cfif>
                                                            <cfif isDefined("resultdata.shipment.delivery.carrierparty.partyname.name")>, #resultdata.shipment.delivery.carrierparty.partyname.name#</cfif>
                                                            <br>
                                                        <cfif isDefined("resultdata.shipment.shipmentstage.roadtransport") and arrayLen(resultdata.shipment.shipmentstage.roadtransport)>
                                                            <cfloop array="#resultdata.shipment.shipmentstage.roadtransport#" index="roadtransport">
                                                                &nbsp;&nbsp;<b><cf_get_lang dictionary_id="60932.Araç Plaka numarası">:</b> #roadtransport.licenseplateid#<br>
                                                            </cfloop>
                                                        </cfif>
                                                        <cfif isDefined("resultdata.shipment.shipmentstage.driverperson") and arrayLen(resultdata.shipment.shipmentstage.driverperson)>
                                                            <cfloop array="#resultdata.shipment.shipmentstage.driverperson#" index="driverperson">
                                                                &nbsp;&nbsp;<b><cf_get_lang dictionary_id="60933.Şoför">:</b> #driverperson.firstname# #driverperson.familyname#, TCKN : #driverperson.nationalityid#<br>
                                                            </cfloop>
                                                        </cfif>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>					
                            </td>
                        </tr>
                    </table>
                </div>
            </cfoutput>
        </cfif>
			<script type="text/javascript">
				var temp_company_id	= 0;
				var temp_consumer_id = 0;
				
				<!--- function kontrol()
				{
					if(process_cat_control())
					{
						form_basket.action='<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_efatura_xml&efatura_id=#get_inv_det.einvoice_id#&is_upd=1</cfoutput>';
						form_basket.submit();
						return true;
					}
				} --->

				function add_paper()
				{
                    type = document.getElementById('shipment_type').value;
                    <cfif attributes.print eq 0>
                        if(type == 1)
                            action_page = '<cfoutput>#request.self#?fuseaction=stock.form_add_purchase&receiving_detail_id=#attributes.receiving_detail_id#</cfoutput>';
                        else
                            action_page = '<cfoutput>#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=#ship_control.ship_id#&receiving_detail_id=#attributes.receiving_detail_id#</cfoutput>';
                    </cfif>
					form_basket.action = action_page;
					form_basket.target = '_blank';
					form_basket.submit();
					return true;
				}
			</script>
        <cfelse>
            <cftry>
				<cfscript>
                    xml_doc = XmlParse(eshipment_xml_data);
                    kontrol_xslt=0;
                    if(isdefined("xml_doc.DespatchAdvice.AdditionalDocumentReference"))
                        for(kk=1;kk<=arraylen(xml_doc.DespatchAdvice.AdditionalDocumentReference);kk++)
                        {
                            if(structkeyexists(xml_doc.DespatchAdvice.AdditionalDocumentReference[kk],"Attachment") && structkeyexists(xml_doc.DespatchAdvice.AdditionalDocumentReference[kk].Attachment,"EmbeddedDocumentBinaryObject"))
                            {
                                kontrol_xslt=kk;
                                break;	
                            }					
                        }
                    xslt = xml_doc.DespatchAdvice.AdditionalDocumentReference[kontrol_xslt].Attachment.EmbeddedDocumentBinaryObject.XmlText;
				</cfscript>
				<cfloop from="1" to="#arraylen(xml_doc.DespatchAdvice.AdditionalDocumentReference)#" index="kk">
					<cfif structkeyexists(xml_doc.DespatchAdvice.AdditionalDocumentReference[kk],"Attachment") and listlast(xml_doc.DespatchAdvice.AdditionalDocumentReference[kk].Attachment.EmbeddedDocumentBinaryObject.xmlattributes.filename,'.') eq 'xslt'>
						<cfset xslt = xml_doc.DespatchAdvice.AdditionalDocumentReference[kk].Attachment.EmbeddedDocumentBinaryObject.XmlText>
						<cfbreak>
					</cfif>
				</cfloop>
				<cffile action="write" file="#upload_folder##dir_seperator##GET_ESHIPMENT_DET.UUID#.xslt" output="#toString(tobinary(xslt))#" charset="utf-8">
				<cffile action="read" file="#upload_folder##dir_seperator##GET_ESHIPMENT_DET.UUID#.xslt" variable="xslt" charset="utf-8">
				<cfoutput>#XmlTransform(xml_doc, xslt)#</cfoutput>
				<cffile action="delete" file="#upload_folder##dir_seperator##GET_ESHIPMENT_DET.UUID#.xslt">
				<cfcatch type="any">
					<cf_get_lang dictionary_id='34063.XML Dosyası Okunamadı , Lütfen XML Formatını Kontrol Ediniz !'>
				</cfcatch>
			</cftry>
        </cfif>
    </cfif>
</cfif>
</cfloop>
<cfif attributes.print eq 1>
    <cfquery name="UPD_PRINT_COUNT" datasource="#dsn2#">
        UPDATE ESHIPMENT_RECEIVING_DETAIL SET PRINT_COUNT = ISNULL(PRINT_COUNT,0) + 1 WHERE RECEIVING_DETAIL_ID IN (#attributes.print_id#)
    </cfquery>
    <script type="text/javascript">
        window.print();
    </script>
</cfif>
<script type="text/javascript">
    function add_order()
    {	
        var is_purchase = 1;
        var is_return = 0;
    
        if((form_basket.company_id.value.length!="" && form_basket.company_id.value!="") || (form_basket.consumer_id.value.length!="" && form_basket.consumer_id.value!="")  )
        {	
            str_irslink = '&is_from_invoice=1&control=1&order_id_liste=' + form_basket.order_id_listesi.value + '&is_purchase='+is_purchase+'&is_return='+is_return+'&company_id='+form_basket.company_id.value + '&consumer_id='+form_basket.consumer_id.value<cfif session.ep.isBranchAuthorization>+'&is_sale_store='+1</cfif>; 
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_orders_for_ship' + str_irslink , 'list_horizantal');
            return true;
        }
        else{
            alert("<cfoutput><cf_get_lang dictionary_id='50081.Lütfen Cari Hesap seçiniz'></cfoutput>");
        }
    }
    function relation_paper()
    {
        if(document.getElementById('related_ship_id').value == '' && document.getElementById('related_ship_number').value == '')
        {
            alert("<cf_get_lang dictionary_id= '60059.Lütfen İlişkilendirilecek Belge Seçiniz !'>");	
            return false;
        }
        else
        {
            form_basket.action='V16/e_government/query/add_eshipment_xml.cfm';
            form_basket.submit();
            return true;
        }
    }
</script>
