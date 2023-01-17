<!---
    File: dsp_efatura_detail.cfm
    Folder: V16\e_government\display\
	Controller: 
    Author: 
    Date: 2019-12-21 17:03:01 
    Description:
        efatura görüntüleme sayfası gelen efatura id ye göre xml okunup ekrana basılır 20131113 sm
    History:
		21.12.2019 Gramoni-Mahmut mahmut.cifci@gramoni.com
		Entegrasyon tanımlarında eğer gelen e-farura süreçli kullanılsın işaretlemez isem
		Gelen e-fatura sisteme düştüğünde belge kaydet ve ticari fatura ise reddet butonları gelir.
		Entegrasyon tanımlarında eğer gelen e-fatura süreçli kullanılsın işaretlersem
		Gelen e-fatura sisteme düştüğünde belge kaydet ve ticari fatura ise reddet butonları gelmez güncelle butonları gelir.
		Belgenin kabul edileceği aşamaya gelen efatura action file eklerim.
		Bu aşamaya geldiği zaman belge kaydet ve ticari fatura ise reddet butonları gelir.
		eğer red edersem fatura reddedildi ibaresi yazar.
		kabul edersem fatura kabul edildi ibaresi yazar.
		Kabul ya da red yaptığım durumda butonlar kalkar ve bir daha gelmez.
		İş ID 117279 Nihan Ertuğrul

		Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com 2020-03-27 23:55:34
        E-government standart modüle taşındı
    To Do:

--->

<cf_xml_page_edit fuseact="objects.popup_dsp_efatura_detail,invoice.received_einvoices">
<cfparam name="attributes.print" default="0" />
<cfparam name="attributes.einvoice_id" default="">
<cfparam name="attributes.eEXPENSE_id" default="">
<cfparam name="attributes.eaction_type" default="">
<cfparam name="attributes.einvoice_cat" default="">
<cfparam name="attributes.member_id" default="">
<cfparam name="attributes.einvoice_id" default="">
<cfsavecontent variable="head_text">
<title><cf_get_lang dictionary_id='47112.Gelen E-Fatura'></title>
</cfsavecontent>
<cfhtmlhead text="#head_text#" />
<cfif isDefined("attributes.mode") and attributes.mode eq 'delXslt'> <!--- önizleme için oluşturulan geçici xslt siliniyor --->
	<cffile action="delete" file="#upload_folder##dir_seperator##attributes.xsltFilePath#.xslt">
	<cfabort>
</Cfif>

<cfif attributes.print eq 0>
	<cfsetting showdebugoutput="no">
	<cfif isdefined("attributes.action_id")><cfset attributes.receiving_detail_id = attributes.action_id></cfif>
	<cfquery name="GET_INV_DET" datasource="#DSN2#">
		SELECT
			ERD.PATH,
			ERD.UUID,
			ERD.STATUS,
			ERD.EINVOICE_ID,
			ISNULL(ERD.IS_APPROVE,0) IS_APPROVE,
			ERD.PROCESS_STAGE,
			ERD.BRANCH_ID,
			ERD.DEPARTMENT_ID,
			ERD.RECORD_DATE,
			ERD.RECORD_EMP,
			ERD.UPDATE_DATE,
			ERD.UPDATE_EMP,
			ERD.RECEIVING_DETAIL_ID,
			ERD.DETAIL,
			ERD.IS_PROCESS,
			SH.SHIP_ID,
			SH.SHIP_NUMBER,
			SH.NETTOTAL,
			ERD.EINVOICE_TYPE
		FROM
			EINVOICE_RECEIVING_DETAIL ERD LEFT OUTER JOIN SHIP SH ON ERD.SHIP_ID = SH.SHIP_ID
		WHERE
			ERD.RECEIVING_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.receiving_detail_id#">
	</cfquery>
	<cfif get_inv_det.recordcount eq 0>  
		<cfset hata  = 11>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'>  <cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
		<cfset hata_mesaj  = message>
		<cfinclude template="../../dsp_hata.cfm">
	<cfelse>
		<cffile action="read" file="#upload_folder##dir_seperator##get_inv_det.path#" variable="inv_xml_data" charset="utf-8">
		<cfif not isdefined("attributes.is_display")>
			<cftry>
				<cfscript>
					xml_doc = XmlParse(inv_xml_data);
					adres = '';
					adres_gelen = '';
					//gonderici bilgileri
					if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.PartyName.Name.XmlText"))
						member_name = '#xml_doc.Invoice.AccountingSupplierParty.Party.PartyName.Name.XmlText#';
					else if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.Person.FirstName.XmlText"))
						member_name = '#xml_doc.Invoice.AccountingSupplierParty.Party.Person.FirstName.XmlText# #xml_doc.Invoice.AccountingSupplierParty.Party.Person.FamilyName.XmlText#';					
					else
						member_name = '';
						
					if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.StreetName.XmlText"))			
						adres = '#adres# #xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.StreetName.XmlText#';
					if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.BuildingNumber.XmlText"))
						adres = '#adres# No : #xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.BuildingNumber.XmlText#';
					if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.PostalZone.XmlText"))
						adres = '#adres# #xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.PostalZone.XmlText#';
					adres = '#adres# #xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.CitySubdivisionName.XmlText#';
					adres = '#adres#/#xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.CityName.XmlText#';
					if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.Contact.telephone.XmlText"))
						telefon = 'Tel : #xml_doc.Invoice.AccountingSupplierParty.Party.Contact.telephone.XmlText#';
					else
						telefon = '';
					if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.Contact.Telefax.XmlText"))
						telefon = '#telefon# Fax : #xml_doc.Invoice.AccountingSupplierParty.Party.Contact.Telefax.XmlText#';
						
					if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.Contact.ElectronicMail.XmlText"))
						eposta = 'E-Posta : #xml_doc.Invoice.AccountingSupplierParty.Party.Contact.ElectronicMail.XmlText#';
					else
						eposta = '';
					website = '';
					code_list_name = '';
					code_list_value = '';
					for(kk=1;kk<=arraylen(xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification);kk++)
					{
						if(len(xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlText))
						{
							code_list_name = listappend(code_list_name,xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlAttributes.schemeID);
							code_list_value = listappend(code_list_value,xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlText);
							if(xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlAttributes.schemeID eq 'VKN')
								temp_VKN = 	xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlText;
							else if(xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlAttributes.schemeID eq 'TCKN')
								temp_VKN =  xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlText;

						}					
					}
					if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.PartyTaxScheme.TaxScheme.Name.XmlText"))
						vergi_dairesi = 'Vergi Dairesi : #xml_doc.Invoice.AccountingSupplierParty.Party.PartyTaxScheme.TaxScheme.Name.XmlText#';
					else
						vergi_dairesi= 'Vergi Dairesi: ';
					//alıcı firma bilgileri
					if(StructKeyExists(xml_doc.Invoice.AccountingCustomerParty.Party,'PartyName'))
						member_name_gelen = '#xml_doc.Invoice.AccountingCustomerParty.Party.PartyName.Name.XmlText#';
					else
						member_name_gelen = '';
		
					if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.StreetName.XmlText"))
						adres_gelen = '#adres_gelen# #xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.StreetName.XmlText#';
		
					if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.BuildingNumber.XmlText"))
						adres_gelen = '#adres_gelen# No : #xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.BuildingNumber.XmlText#';
					if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.PostalZone.XmlText"))
						adres_gelen = '#adres_gelen# #xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.PostalZone.XmlText#';
					adres_gelen = '#adres_gelen# #xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.CitySubdivisionName.XmlText#';
					adres_gelen = '#adres_gelen#/#xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.CityName.XmlText#';
					telefon_gelen = '';
					if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.Contact.telephone.XmlText"))
						telefon_gelen = '#telefon_gelen# Tel : #xml_doc.Invoice.AccountingCustomerParty.Party.Contact.telephone.XmlText#';
					if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.Contact.Telefax.XmlText"))
						telefon_gelen = '#telefon_gelen# Fax : #xml_doc.Invoice.AccountingCustomerParty.Party.Contact.Telefax.XmlText#';
					if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.Contact.ElectronicMail.XmlText"))
						eposta_gelen = 'E-Posta : #xml_doc.Invoice.AccountingCustomerParty.Party.Contact.ElectronicMail.XmlText#';
					else
						eposta_gelen = '';
					website_gelen = '';
					vergi_no_gelen = 'VKN : #xml_doc.Invoice.AccountingCustomerParty.Party.PartyIdentification.Id.XmlText#';
					if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.PartyTaxScheme.TaxScheme.Name.XmlText"))
						vergi_dairesi_gelen = 'Vergi Dairesi : #xml_doc.Invoice.AccountingCustomerParty.Party.PartyTaxScheme.TaxScheme.Name.XmlText#';
					else
						vergi_dairesi_gelen= 'Vergi Dairesi: ';
					//Fatura bilgileri
					versiyon_no = '#xml_doc.Invoice.CustomizationID.XmlText#';
					invoice_type = '#xml_doc.Invoice.ProfileID.XmlText#';
					invoice_sale_type = '#xml_doc.Invoice.InvoiceTypeCode.XmlText#';
					invoice_number = '#xml_doc.Invoice.Id.XmlText#';
					invoice_date = '#left(xml_doc.Invoice.IssueDate.XmlText,10)#';
					if(isdefined("xml_doc.Invoice.OrderReference.Id.XmlText"))
					{
						order_no = '#xml_doc.Invoice.OrderReference.Id.XmlText#';
						order_date = '#xml_doc.Invoice.OrderReference.IssueDate.XmlText#';
					}
					else
					{
						order_no = '';
						order_date = '';
					}
					if(isdefined("xml_doc.Invoice.PaymentMeans.PaymentDueDate.XmlText"))
						due_date = '#xml_doc.Invoice.PaymentMeans.PaymentDueDate.XmlText#';
					else
						due_date = '';

					if(isdefined("xml_doc.Invoice.DespatchDocumentReference.Id.XmlText"))
					{
						ship_no = '#xml_doc.Invoice.DespatchDocumentReference.Id.XmlText#';
						ship_date = '#xml_doc.Invoice.DespatchDocumentReference.IssueDate.XmlText#';
					}
					else
					{
						ship_no = '';
						ship_date = '';
					}
					ettn = '#xml_doc.Invoice.UUID.XmlText#';
					detail = '';
					if(isdefined("xml_doc.Invoice.Note.XmlText"))
					{
						for(i=1;i<=arraylen(xml_doc.Invoice.Note);++i){
							if(Not xml_doc.Invoice.Note[i].XmlText Contains '####BARCODE####'){
								detail = '#detail# #xml_doc.Invoice.Note[i].XmlText#<br>';
							}
						}
					}
					if(isdefined("xml_doc.Invoice.PaymentTerms.Id.XmlText"))
						payment_term = '#xml_doc.Invoice.PaymentTerms.XmlText#';
					else
						payment_term = '';
					//fatura satırları
					line_count = '#xml_doc.Invoice.LineCountNumeric.XmlText#';
					invoice_total = '#xml_doc.Invoice.LegalMonetaryTotal.LineExtensionAmount.XmlText#';
					invoice_money = '#xml_doc.Invoice.LegalMonetaryTotal.LineExtensionAmount.XmlAttributes.currencyID#';
					if(isdefined("xml_doc.Invoice.LegalMonetaryTotal.AllowanceTotalAmount.XmlText"))
						discount_total = '#xml_doc.Invoice.LegalMonetaryTotal.AllowanceTotalAmount.XmlText#';
					else
						discount_total = 0;
					all_total = '#xml_doc.Invoice.LegalMonetaryTotal.TaxInclusiveAmount.XmlText#';
					pay_total = '#xml_doc.Invoice.LegalMonetaryTotal.PayableAmount.XmlText#';
					kontrol_xslt=0;
					if(isdefined("xml_doc.Invoice.AdditionalDocumentReference"))
						for(kk=1;kk<=arraylen(xml_doc.Invoice.AdditionalDocumentReference);kk++)
						{
							if(structkeyexists(xml_doc.Invoice.AdditionalDocumentReference[kk],"Attachment") && structkeyexists(xml_doc.Invoice.AdditionalDocumentReference[kk].Attachment,"EmbeddedDocumentBinaryObject"))
							{
								kontrol_xslt=kk;
								break;	
							}					
						}
				</cfscript>
				<cfcatch type="any">
					<cfset error = 'XML Dosyası Okunamadı , Lütfen XML Formatını Kontrol Ediniz !'>
				</cfcatch>
			</cftry>
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
			<cfscript>
				get_efat_id = createObject("component", "V16.e_government.cfc.get_efatura_det");
				get_efatura_detail = get_efat_id.get_efatura_det(receiving_detail_id:attributes.receiving_detail_id);
				
			</cfscript>
			<cfif get_efatura_detail.recordcount>
				<cfset attributes.einvoice_id = get_efatura_detail.invoice_id>
				<cfset attributes.eexpense_id = get_efatura_detail.expense_id>
				<cfset attributes.eaction_type = get_efatura_detail.action_type>
				<cfset attributes.einvoice_cat = get_efatura_detail.invoice_cat>
			</cfif>
			
			<cfif not len(get_inv_det.status)>
				<cfif isdefined('temp_VKN') and len(temp_VKN)>
					<cfset get_member=get_efat_id.get_member(temp_VKN_:temp_VKN)>
					<cfif get_member.recordcount>
						<cfset attributes.member_id=get_member.member_id>
					</cfif>
				</cfif>
			</cfif>
			<cfset attributes.ekontrol_xslt=kontrol_xslt>
			<cfif attributes.fuseaction is 'invoice.received_einvoices'>
				<cf_catalystheader>
			</cfif>
			<!-- sil -->
			<cfform name="form_basket">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='58133.Fatura No'></cfsavecontent>
				<cfsavecontent  variable="rigth">
				<cfoutput>#request.self#?fuseaction=objects.popup_dsp_efatura_detail&is_display=1&receiving_detail_id=#attributes.receiving_detail_id#&type=1&row=#attributes.ekontrol_xslt#
				</cfoutput>
				</cfsavecontent>
				<cfsavecontent variable="edetail"><cf_get_lang dictionary_id="60555.Fatura Detay"></cfsavecontent>
				<cfif attributes.fuseaction is 'invoice.received_einvoices'>
					<cfset rigth = "">
				</cfif>
				<div class="col col-9 col-xs-12">
					<cf_box title="#message#: #get_inv_det.einvoice_id#" closable="0" uidrop="1" bill_href="#rigth#" bill_title="#edetail#">
						<!---<cfif kontrol_xslt neq 0>
							<cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_efatura_detail&is_display=1&receiving_detail_id=#attributes.receiving_detail_id#&type=1&row=#kontrol_xslt#','wide');"> <i class="fa fa-external-link" alt="Fatura Detay"title="Fatura Detay" border="0"></i></a></cfoutput>
						</cfif>
						<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=objects.popup_dsp_efatura_detail&action_name=action_id&action_id=#attributes.receiving_detail_id#','list');"> <i class="fa fa-exclamation" alt="<cf_get_lang_main no='345.Uyarılar'>"title="<cf_get_lang_main no='345.Uyarılar'>" border="0"></i> </a>
							<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' is_ajax='1' trail='0' simple="1"> --->
						<div class="printThis">
							<cfif isdefined("error")>
								<table  width="100%">
									<tr>
										<td><cfoutput>#error#</cfoutput></td>
									</tr>
								</table>
							<cfelse>
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
																			<cfif isdefined('temp_VKN') and len(temp_VKN)>
																				<cfquery name="GET_MEMBER" datasource="#DSN#">
																					SELECT 
																						1 AS TYPE,
																						C.COMPANY_ID AS MEMBER_ID
																					FROM 
																						COMPANY C,
																						COMPANY_PARTNER CP, 
																						COMPANY_CAT CC, 
																						COMPANY_CAT_OUR_COMPANY CCO 
																					WHERE                                                               
																						(C.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp_VKN#"> OR 
																						CP.TC_IDENTITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp_VKN#">) AND
																						CCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
																						C.COMPANY_ID = CP.COMPANY_ID AND
																						C.MANAGER_PARTNER_ID = CP.PARTNER_ID AND
																						C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
																						CC.COMPANYCAT_ID = CCO.COMPANYCAT_ID
																					UNION ALL
																					SELECT 
																						2 AS TYPE,
																						C.CONSUMER_ID AS MEMBER_ID
																					FROM 
																						CONSUMER C, 
																						CONSUMER_CAT CC, 
																						CONSUMER_CAT_OUR_COMPANY CCO 
																					WHERE                                                               
																						C.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp_VKN#"> AND
																						CCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
																						C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
																						CC.CONSCAT_ID = CCO.CONSCAT_ID
																				</cfquery>
																			<cfelse>
																				<cfset get_member.recordcount=0>
																			</cfif>

																			<input type="text" name="comp_name" id="comp_name" readonly value="#member_name#" style="width:300px;">
																			<cfif get_member.recordcount eq 1 and get_member.type eq 1>
																				<input type="hidden" name="company_id" id="company_id" value="#get_member.member_id#">
																				<input type="hidden" name="consumer_id" id="consumer_id" value="">
																			<cfelseif get_member.recordcount eq 1 and get_member.type eq 2>
																				<input type="hidden" name="company_id" id="company_id" value="">
																				<input type="hidden" name="consumer_id" id="consumer_id" value="#get_member.member_id#">                                                        
																			<cfelse>
																				<input type="hidden" name="company_id" id="company_id" value="">
																				<input type="hidden" name="consumer_id" id="consumer_id" value="">
																				<!-- sil --><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id','list');"> <i class="fa fa-ellipsis-v" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></i></a><!-- sil --> 
																				<cfif get_member.recordcount neq 0>
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
																<cfloop list="#code_list_name#" index="kk">
																	<tr>
																		<td>#kk# : #listgetat(code_list_value,listfind(code_list_name,kk))#</td>
																	</tr>
																</cfloop>
																
															</table>
														</td>
														<!--- Logo --->
														<td>
															<table align="right">
																<tr>
																	<td style="text-align:center">
																		<cfoutput><img width="100" height="100" src="#user_domain#images/gib_logo.png"></cfoutput>
																	</td>
																</tr>
																<tr>
																	<td style="text-align:center"><b><cf_get_lang dictionary_id='29872.E-FATURA'></b></td>
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
																	<td   ><b><cf_get_lang dictionary_id='34139.Özelleştirme'><cf_get_lang dictionary_id='57487.NO'></b></td>
																	<td>#versiyon_no#</td>
																</tr>
																<tr>
																	<td   ><b><cf_get_lang dictionary_id='59321.Senaryo'></b></td>
																	<td>#invoice_type#</td>
																</tr>
																<tr>
																	<td   ><b><cf_get_lang dictionary_id='59094.Fatura Tipi'></b></td>
																	<td>#invoice_sale_type#</td>
																</tr>
																<tr>
																	<td   ><b><cf_get_lang dictionary_id='58133.Fatura No'></b></td>
																	<td>#invoice_number#</td>
																</tr>
																<tr>
																	<td   ><b><cf_get_lang dictionary_id='58759.Fatura Tarihi'></b></td>
																	<td style="text-align:left;">#dateformat(invoice_date,'dd-mm-yyyy')#</td>
																</tr>
																<cfif len(due_date)>
																	<tr>
																		<td   ><b><cf_get_lang dictionary_id='57881.Vade Tarihi'></b></td>
																		<td style="text-align:left;">#dateformat(due_date,'dd-mm-yyyy')#</td>
																	</tr>
																</cfif>
																<tr>
																	<td   ><b><cf_get_lang dictionary_id='58211.Sipariş No'></b></td>
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
																	<td   ><b><cf_get_lang dictionary_id='29501.Sipariş Tarihi'></b></td>
																	<td>
																		<div class="ui-form-list ui-form-block">
																			<div class="form-group" id="item-order_date_form">
																				<input type="text" name="order_date" id="order_date" value="#dateformat(order_date,'dd-mm-yyyy')#">
																			</div>
																		</div>
																	</td>
																</tr>
																<tr>
																	<td   ><b><cf_get_lang dictionary_id='58138.İrsaliye No'></b></td>
																	<td align="left"  >
																		<div class="ui-form-list ui-form-block">
																			<div class="form-group">
																				<div class="input-group">
																					<input type="hidden" name="ship_id" id="ship_id" value="#GET_INV_DET.SHIP_ID#" />
																					<input type="hidden" name="ship_amount" id="ship_amount" value="#GET_INV_DET.NETTOTAL#" />
																					<input type="text" name="ship_no" id="ship_no" value="#GET_INV_DET.SHIP_NUMBER#" />
																					<!-- sil --><span class="input-group-addon icon-ellipsis" href="javascript:void(0);" onclick="selectShip();"></span><!-- sil --> 
																				</div>
																			</div>
																		</div>
																	</td>
																</tr>
																<tr>
																	<td   ><b><cf_get_lang dictionary_id='33096.İrsaliye Tarihi'></b></td>
																	<td>#dateformat(ship_date,'dd-mm-yyyy')#</td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
												<table width="100%" border="0" cellpadding="2" cellspacing="0">
													<tr>
														<td><b>ETTN: </b>#ettn#</td>
													</tr>
													<tr>
														<td>
															<table border="1" class="e-fatura" width="100%" cellpadding="2" cellspacing="0" bordercolor="DDDDDD">
																<tr height="20">
																	<td><b><cf_get_lang dictionary_id='31253.Sıra No'></b></td>
																	<td   colspan="2"><b><cf_get_lang dictionary_id='45517.Mal'><cf_get_lang dictionary_id='33283.Hizmet'></b></td>
																	<td><b><cf_get_lang dictionary_id='132.Descriptions'></b></td>
																	<td><b><cf_get_lang dictionary_id='57635.Miktar'></b></td>
																	<td><b><cf_get_lang dictionary_id='57638.Birim Fiyat'></b></td>
																	<td><b><cf_get_lang dictionary_id='38190.İskonto Oranı'></b></td>
																	<td><b><cf_get_lang dictionary_id='34077.İskonto Tutarı'></b></td>
																	<td><b><cf_get_lang dictionary_id='32536.KDV Oranı'></b></td>
																	<td><b><cf_get_lang dictionary_id='33214.KDV Tutarı'></b></td>
																	<cfif x_otv_line eq 1>
																		<td><b><cf_get_lang dictionary_id='38922.ÖTV Oranı'></b></td>
																		<td><b><cf_get_lang dictionary_id='34085.ÖTV Tutarı'></b></td>
																	</cfif>
																	<td><b><cf_get_lang dictionary_id='34078.Diğer Vergiler'></b></td>
																	<td><b><cf_get_lang dictionary_id='45517.Mal'><cf_get_lang dictionary_id='33283.Hizmet'><cf_get_lang dictionary_id='57673.Tutarı'></b></td>
																</tr>
																<cfset line_count = arraylen(xml_doc.Invoice.InvoiceLine)>
																<cfif line_count eq 0><cfset line_count = 1></cfif><!---damga vergisi olduğında satır olarak gelmiyordu o yüzden eklendi.--->
																<input type="hidden" name="line_count" id="line_count" value="#line_count#">
																<cfloop from="1" to="#line_count#" index="kk">
																	<cftry>
																		<cfset discount = '#xml_doc.Invoice.InvoiceLine[kk].AllowanceCharge.MultiplierFactorNumeric.XmlText*100#'>
																		<cfcatch type="any">
																			<cfset discount = 0>
																		</cfcatch>
																	</cftry>
																	<cftry>
																		<cfset discount_amount = '#xml_doc.Invoice.InvoiceLine[kk].AllowanceCharge.Amount.XmlText#'>
																		<cfset discount_money = '#xml_doc.Invoice.InvoiceLine[kk].AllowanceCharge.Amount.XmlAttributes.currencyID#'>
																		<cfcatch type="any">
																			<cfset discount_amount = 0>
																			<cfset discount_money = "">
																		</cfcatch>
																	</cftry>
																	<cfset other_tax_detail_list = ''>
																	<cfset otv = 0>
																	<cfset otv_amount = 0>
																	<cfset tax = 0>
																	<cfset tax_amount = 0>
																	<cfset tax_money = "">
																	<cftry>
																		<cfloop from="1" to="#arraylen(xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal)#" index="jj">
																			<cfif StructKeyExists(xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxCategory.TaxScheme,'TaxTypeCode') and xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxCategory.TaxScheme.TaxTypeCode.XmlText eq 0015><!--- kdv ise --->
																				<cfset tax = '#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].Percent.XmlText#'>
																				<cfset tax_money = '#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlAttributes.currencyID#'>
																				<cfset tax_amount = '#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlText#'>
																			<cfelse>
																				<cfif x_otv_line eq 1 and StructKeyExists(xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj],'CalculationSequenceNumeric') and xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].CalculationSequenceNumeric.XmlText eq 1><!--- ötv ise --->
																					<cfset otv = '#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].Percent.XmlText#'>
																					<cfset otv_amount = '#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlText#'>
																				<cfelse>
																					<cfif len(other_tax_detail_list)>
																						<cfset other_tax_detail_list = '#other_tax_detail_list#<br>#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxCategory.TaxScheme.Name.XmlText# (%#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].Percent.XmlText#)=#tlformat(xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlText)# #xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlAttributes.currencyID#'>
																					<cfelse>
																						<cfset other_tax_detail_list = '#other_tax_detail_list# #xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxCategory.TaxScheme.Name.XmlText# (%#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].Percent.XmlText#)=#tlformat(xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlText)# #xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlAttributes.currencyID#'>
																					</cfif>
																				</cfif>
																			</cfif>
																		</cfloop>
																		<cfcatch type="any">
																			<cfset tax = 0>
																			<cfset tax_amount = 0>
																			<cfset otv = 0>
																			<cfset otv_amount = 0>
																			<cfset tax_money = "">
																		</cfcatch>
																	</cftry>
																	<cftry>
																		<cfset product_name_tax = '#xml_doc.Invoice.InvoiceLine[kk].Item.Name.XmlText#'>
																		<cfcatch type="any">
																			
																			<cfset product_name_tax = "">
																		</cfcatch>
																	</cftry>
																	<cftry>
																		<cfscript>
																			product_name = '#replace(trim(xml_doc.Invoice.InvoiceLine[kk].Item.Name.XmlText),'"','')#';
																			quantity = '#xml_doc.Invoice.InvoiceLine[kk].InvoicedQuantity.XmlText#';
																			unit_code = '#xml_doc.Invoice.InvoiceLine[kk].InvoicedQuantity.XmlAttributes.UnitCode#';
																			price = '#xml_doc.Invoice.InvoiceLine[kk].Price.PriceAmount.XmlText#';
																			money = '#xml_doc.Invoice.InvoiceLine[kk].Price.PriceAmount.XmlAttributes.currencyID#';
																			amount = '#xml_doc.Invoice.InvoiceLine[kk].LineExtensionAmount.XmlText#';
																			if (StructKeyExists(xml_doc.Invoice.InvoiceLine[kk].item,'Description')) {
																				Description = '#xml_doc.Invoice.InvoiceLine[kk].item.Description.XmlText#';
																			}
																			else {
																				Description = '';
																			}
																		</cfscript>
																		<cfcatch type="any">
																			<cfscript>
																				product_name = '';
																				quantity = 0;
																				unit_code = '';
																				price = 0;
																				money = '';
																				amount = 0;
																				Description = '';
																			</cfscript>
																		</cfcatch>
																	</cftry>
																	<cfif len(product_name) or len(product_name_tax) or len(unit_code)>
																	<cfquery name="get_unit_code" datasource="#dsn#">
																		SELECT UNIT FROM SETUP_UNIT WHERE UNIT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unit_code#">
																	</cfquery>
																	<tr>
																		<td>#kk#</td>
																		<td>
																			<cfif len(product_name)>#product_name#<cfelse>#product_name_tax#</cfif>&nbsp;&nbsp;&nbsp;&nbsp;
																			<input type="hidden" name="stock_id_#kk#" id="stock_id_#kk#" value="">
																			<input type="hidden" name="quantity_#kk#" id="quantity_#kk#" value="#quantity#">
																			<input type="hidden" name="price_#kk#" id="price_#kk#" value="#price#">
																			<input type="hidden" name="net_total_#kk#" id="net_total_#kk#" value="#price*quantity#">
																			<input type="hidden" name="discount_#kk#" id="discount_#kk#" value="#discount#">
																			<input type="hidden" name="tax_#kk#" id="tax_#kk#" value="#tax#">
																		</td>
																		<td>
																			<!-- sil -->
																			<cfif not len(get_inv_det.status)>
																				<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id_#kk#&keyword=#product_name#','list');"><i class="fa fa-ellipsis-v"></i></a>
																			</cfif>
																			<!-- sil -->
																		</td>
																		<td>#Description#</td>
																		<td style="text-align:right;"   >#tlformat(quantity)# #get_unit_code.unit#</td>
																		<td style="text-align:right;"   >#tlformat(price)# #money#</td>
																		<td style="text-align:right;"   >% #tlformat(discount)#</td>
																		<td style="text-align:right;"   >#tlformat(discount_amount)# #discount_money#</td>
																		<td style="text-align:right;"   ><cfif tax neq 0>% #tlformat(tax)#</cfif></td>
																		<td style="text-align:right;"><cfif tax_amount neq 0>#tlformat(tax_amount)# #tax_money#</cfif></td>
																		<cfif x_otv_line eq 1>
																			<td style="text-align:right;"   ><cfif otv neq 0>% #tlformat(otv)#</cfif></td>
																			<td style="text-align:right;"><cfif otv_amount neq 0>#tlformat(otv_amount)# #money#</cfif></td>
																		</cfif>
																		<td style="text-align:right;"><cfif len(other_tax_detail_list)>#other_tax_detail_list#</cfif></td>
																		<td style="text-align:right;">#tlformat(amount)#</td>
																	</tr>
																</cfif>
																</cfloop>
																<cfloop from="1" to="#20-line_count#" index="jj">
																	<tr height="20">
																		<td>&nbsp;</td>
																		<td colspan="2">&nbsp;</td>
																		<td>&nbsp;</td>
																		<td>&nbsp;</td>
																		<td>&nbsp;</td>
																		<td>&nbsp;</td>
																		<td>&nbsp;</td>
																		<td>&nbsp;</td>
																		<td>&nbsp;</td>
																		<cfif x_otv_line eq 1>
																			<td>&nbsp;</td>
																			<td>&nbsp;</td>
																		</cfif>
																		<td>&nbsp;</td>
																		<td>&nbsp;</td>
																	</tr>
																</cfloop>
															</table>
														</td>
													</tr>
												</table>
												<table width="100%" border="0" cellpadding="2" cellspacing="0" >
													<tr>
														<td>
															<table align="right" width="300" border="1" class="e-fatura" cellpadding="2" cellspacing="0" bordercolor="DDDDDD">					
																<tr>
																	<td style="text-align:right;"><b><cf_get_lang dictionary_id='34138.Mal Hizmet Toplam Tutarı'></b></td>
																	<td style="text-align:right;"   >#tlformat(invoice_total)# #invoice_money#</td>
																</tr>
																<tr>
																	<td style="text-align:right;"><b><cf_get_lang dictionary_id='57086.Toplam İskonto'></b></td>
																	<td style="text-align:right;"   >#tlformat(discount_total)# #invoice_money#</td>
																</tr>
				
																<cfloop from="1" to="#arraylen(xml_doc.Invoice.TaxTotal.TaxSubtotal)#" index="kk">
																	<cftry>
																		<cfset tax = '#xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].Percent.XmlText#'>
																		<cfset tax_amount = '#xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxAmount.XmlText#'>
																		<cfif StructKeyExists(xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxCategory.TaxScheme,'Name') and len(xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxCategory.TaxScheme.Name.XmlText)>
																			<cfset tax_category = '#xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxCategory.TaxScheme.Name.XmlText#'>
																		<cfelse>
																			<cfset tax_category = ''>
																		</cfif>
																		<cfcatch type="any">
																			<cftry>
																				<cfset tax = 0>
																				<cfset tax_amount = '#xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxAmount.XmlText#'>
																				<cfset tax_category = '#xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxCategory.TaxScheme.Name.XmlText#'>
																				<cfcatch type="any">
																					<cfset tax_amount = 0>
																				</cfcatch>
																			</cftry>
																		</cfcatch>
																	</cftry>
																	<cfif tax_amount gt 0>
																		<tr>
																			<td style="text-align:right;"><b><cf_get_lang dictionary_id='34137.Hesaplanan'> #tax_category#(%#tax#)</b></td>
																			<td style="text-align:right;"   >#tlformat(tax_amount)# #invoice_money#</td>
																		</tr>
																	</cfif>
																</cfloop>
																<cfif StructKeyExists(xml_doc.Invoice,'WithholdingTaxTotal')>
																	<cfloop from="1" to="#arraylen(xml_doc.Invoice.WithholdingTaxTotal.TaxSubtotal)#" index="kk">
																	<cftry>
																		<cfset tax = '#xml_doc.Invoice.WithholdingTaxTotal.TaxSubtotal[kk].Percent.XmlText#'>
																		<cfset tax_amount = '#xml_doc.Invoice.WithholdingTaxTotal.TaxSubtotal[kk].TaxAmount.XmlText#'>
																		<cfset tax_category = '#xml_doc.Invoice.WithholdingTaxTotal.TaxSubtotal[kk].TaxCategory.TaxScheme.Name.XmlText#'>
																		<cfcatch type="any">
																		<cfset tax_amount = 0>
																		</cfcatch>
																	</cftry>
																	<cfif tax_amount gt 0>
																		<tr>
																		<td style="text-align:right;"><b><cf_get_lang dictionary_id='34137.Hesaplanan'><cf_get_lang dictionary_id='57639.KDV'><cf_get_lang dictionary_id='58022.Tevkifat'>(%#tax#)</b></td>
																		<td style="text-align:right;"   >#tlformat(tax_amount)# #invoice_money#</td>
																		</tr>
																	</cfif>
																	</cfloop>
																</cfif>                                        
																<tr>
																	<td style="text-align:right;"><b><cf_get_lang dictionary_id='34100.Vergiler Dahil Toplam Tutar'></b></td>
																	<td style="text-align:right;"   >#tlformat(all_total)# #invoice_money#</td>
																</tr>
																<tr>
																	<td style="text-align:right;"><b><cf_get_lang dictionary_id='34377.Ödenecek Tutar'></b></td>
																	<td style="text-align:right;"   >#tlformat(pay_total)# #invoice_money#</td>
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
																		<b><cf_get_lang dictionary_id='57467.Not'>:</b> #detail#<br>
																		<b><cf_get_lang dictionary_id='34098.Ödeme Koşulu'>:</b> #payment_term#
																	</td>
																	<cfif isdefined("xml_doc.Invoice.TaxExchangeRate")>
																		<td style="text-align:right">
																			<table class="e-fatura">
																				<cfloop from="1" to="#arraylen(xml_doc.Invoice.TaxExchangeRate)#" index="kk">
																					<cftry>
																						<cfset money = '#xml_doc.Invoice.TaxExchangeRate[kk].TargetCurrencyCode.XmlText#'>
																						<cfset rate = '#xml_doc.Invoice.TaxExchangeRate[kk].CalculationRate.XmlText#'>
																						<cfcatch type="any">
																							<cfset money = "">
																							<cfset rate = 0>
																						</cfcatch>
																					</cftry>
																					<cfif rate gt 0>
																						<tr>
																							<td style="text-align:right;"  >#money#</td>
																							<td style="text-align:right;"   >#tlformat(rate,4)#</td>
																						</tr>
																					</cfif>
																				</cfloop>
																			</table>
																		</td>
																	</cfif>
																</tr>
															</table>
														</td>
													</tr>
												</table>					
											</td>
										</tr>
									</table>
								</cfoutput>
							</cfif>
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
											<input type="hidden" name="receiving_detail_id" value="<cfoutput>#get_inv_det.receiving_detail_id#</cfoutput>">
												<input type="hidden" name="related_invoice_type" id="related_invoice_type" value="">
												<input type="hidden" name="related_invoice_id" id="related_invoice_id" value="">
												<input type="text" name="related_invoice_number" id="related_invoice_number" readonly="yes" style="width:200px;" value="" />
												<cfset str_invoice_link="field_bill_type=form_basket.related_invoice_type&field_id=form_basket.related_invoice_id&field_name=form_basket.related_invoice_number&cat=0">
												<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_bills&frm_inventory=2&#str_invoice_link#'</cfoutput>,'list','popup_list_bills');">
												</span>    
										</div>
									</div>
									<div class="form-group">
										<a href="javascript://" onclick="relation_paper();" class="ui-btn ui-btn-success">Belge ilişkilendir</a>
									</div>
										
								</div>
							</div>
						<cfelse>
							<div class="ui-form-list ui-form-block">
								<div class="col col-12">
									<div class="form-group">
										<label><cf_get_lang dictionary_id='57629.Açıklama'></label>
										<textarea name="note" id="note"><cfoutput>#get_inv_det.detail#</cfoutput></textarea><cfif invoice_type is 'TICARIFATURA'><font color="red"><cf_get_lang dictionary_id='34096.Fatura Red işleminde gönderilecek Red Nedeni Açıklama Alanına Girilmelidir.'></font></cfif>
									</div>
									<div class="form-group">
										<label><cf_get_lang dictionary_id="58859.Süreç"></label>
										<cf_workcube_process
											is_upd='0'
											select_value='#get_inv_det.process_stage#'
											is_detail='1'>
									</div>
									<cfif not isdefined("error")>
										<div class="form-group">
											<input type="hidden" name="efatura_action_id" value="<cfoutput>#get_inv_det.receiving_detail_id#</cfoutput>">
											<input type="hidden" name="receiving_detail_id" value="<cfoutput>#get_inv_det.receiving_detail_id#</cfoutput>">
											<label><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
											<select name="invoice_type" id="invoice_type">
												<option value="1" <cfif not len(get_inv_det.status)><cfif isdefined('x_invoice_type') and x_invoice_type eq 1>selected</cfif><cfelse><cfif get_inv_det.EINVOICE_TYPE eq 1>selected</cfif></cfif>><cf_get_lang dictionary_id='32451.Alış Faturası'></option>
												<option value="2" <cfif not len(get_inv_det.status)><cfif isdefined('x_invoice_type') and x_invoice_type eq 2>selected</cfif><cfelse><cfif get_inv_det.EINVOICE_TYPE eq 2>selected</cfif></cfif>><cf_get_lang dictionary_id='58156.Diğer'><cf_get_lang dictionary_id='32451.Alış Faturası'></option>
												<option value="3" <cfif not len(get_inv_det.status)><cfif isdefined('x_invoice_type') and x_invoice_type eq 3>selected</cfif><cfelse><cfif get_inv_det.EINVOICE_TYPE eq 3>selected</cfif></cfif>><cf_get_lang dictionary_id='33604.Sabit Kıymet Alış Faturası'></option>
												<option value="4" <cfif not len(get_inv_det.status)><cfif isdefined('x_invoice_type') and x_invoice_type eq 4>selected</cfif><cfelse><cfif get_inv_det.EINVOICE_TYPE eq 4>selected</cfif></cfif>><cf_get_lang dictionary_id='58064.Masraf Fişi'></option>
												<option value="5" <cfif not len(get_inv_det.status)><cfif isdefined('x_invoice_type') and x_invoice_type eq 5>selected</cfif><cfelse><cfif get_inv_det.EINVOICE_TYPE eq 5>selected</cfif></cfif>><cf_get_lang dictionary_id='33706.Sağlık Harcaması'></option>
											</select>
										</div>
									</cfif>
									<div class="form-group">
										<label><cf_get_lang dictionary_id='57453.Şube'></label>
										<cf_wrkdepartmentbranch fieldid='branch_id_' is_branch='1' is_default='1'  is_deny_control='1' selected_value='#GET_INV_DET.BRANCH_ID#'>
									</div>
									
									<div class="form-group">
										<label><cf_get_lang dictionary_id='57572.Departman'></label>
										<cf_wrkdepartmentbranch fieldid='acc_department_id' is_department='1' is_deny_control='0' selected_value='#GET_INV_DET.DEPARTMENT_ID#' >
									</div>
									
									<cfif get_inv_det.status Eq 1>
										<div class="form-group">
											<font color="009933"><cf_get_lang dictionary_id='57441.Fatura'><cf_get_lang dictionary_id='58699.Onaylandı'></font>
										</div>
									</cfif>
									<cfif get_inv_det.status Eq 0>
										<div class="form-group">
											<font color="red"><cf_get_lang dictionary_id='57441.Fatura'><cf_get_lang dictionary_id='57617.Reddedildi'></font>
										</div>
									</cfif>
									<cfscript>
										get_our_company		= createObject("component","V16.e_government.cfc.einvoice");
										get_our_company.dsn = dsn;
										get_our_company.dsn2= dsn2;
										get_our_company_info= get_our_company.get_our_company_fnc(company_id=session.ep.company_id);
										show_buttons		= 0;
										show_decline_button	= 0;

										if (get_our_company_info.IS_RECEIVING_PROCESS Neq 1 And (Not Len(get_inv_det.IS_PROCESS) Or get_inv_det.IS_PROCESS is 0)) {
											show_buttons	= 1;
											if (invoice_type is 'TICARIFATURA') {
												show_decline_button	= 1;
											}
										}
										else if (get_our_company_info.IS_RECEIVING_PROCESS Eq 1 And (Not Len(get_inv_det.IS_PROCESS) Or get_inv_det.IS_PROCESS is 0)) {
											if(isdefined("x_einvoice_buttons_stage") And len(x_einvoice_buttons_stage) And listFind(x_einvoice_buttons_stage,get_inv_det.process_stage)){
												show_buttons	= 1;
												if (invoice_type is 'TICARIFATURA') {
													show_decline_button	= 1;
												}
											}
										}
									</cfscript>
								</div>
							</div>
							<div class="ui-form-list-btn">
								<cfif show_buttons>
									<cfoutput>
										<div>
											<a class="ui-btn ui-btn-success" href="javascript:void(0);" onclick="add_paper();"><cf_get_lang dictionary_id="60079.Kabul Et"></a>
										</div>
										<cfif show_decline_button>
											<div>
												<a class="ui-btn ui-btn-delete" href="javascript:void(0);" onclick="if(confirm('Faturayı Red Etmek İstiyor Musunuz ?')) windowopen('#request.self#?fuseaction=invoice.popup_chng_inv_stat&receiving_detail_id=#get_inv_det.receiving_detail_id#','small');"><cf_get_lang dictionary_id="58461.Reddet"></a>
											</div>
										</cfif>
									</cfoutput>
								</cfif>
									<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
							
							</div>
						</cfif>
						<cfif not isdefined("error")>
							<div class="ui-info-bottom "><cf_record_info query_name="get_inv_det"></div>
						</cfif>
					</cf_box>
				</div>
			</cfform>
			<cfif invoice_money is 'TRY'>
				<cfset temp_invoice_money = 'TL' />
			<cfelse>
				<cfset temp_invoice_money = invoice_money />
			</cfif>
			<script type="text/javascript">
				var temp_company_id	= 0;
				var temp_consumer_id= 0;

				function selectShip() {
					<cfif not len(get_inv_det.status)>
						<cfif get_member.recordcount eq 1 and get_member.type eq 1>
							temp_company_id = <cfoutput>#get_member.member_id#</cfoutput>;
						<cfelseif get_member.recordcount eq 1 and get_member.type eq 2>
							temp_consumer_id = <cfoutput>#get_member.member_id#</cfoutput>;
						</cfif>
					</cfif>
					if (company_id != '') {
						temp_company_id = company_id.value;
					}
					if (consumer_id != '') {
						temp_consumer_id = consumer_id.value;
					}
					<cfoutput>windowopen('#request.self#?fuseaction=objects.popup_list_choice_ship_receiving_einvoice&id=purchase&company_id=' + temp_company_id + '&consumer_id=' + temp_consumer_id + '&start_date=#dateformat(invoice_date,'dd/mm/yyyy')#&invoice_total=#invoice_total#&invoice_money=#temp_invoice_money#','list');</cfoutput>
				}
				
				function kontrol()
				{
					if(process_cat_control())
					{
						form_basket.action='<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_efatura_xml&efatura_id=#get_inv_det.einvoice_id#&is_upd=1</cfoutput>';
						form_basket.submit();
						return true;
					}
				}

				function add_paper()
				{
					type = document.getElementById('invoice_type').value;
						
					if(type == 1)
						action_page = '<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase&receiving_detail_id=#get_inv_det.receiving_detail_id#</cfoutput>';
					else if(type == 2)
						action_page = '<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_other&receiving_detail_id=#get_inv_det.receiving_detail_id#</cfoutput>';
					else if(type == 3)
						action_page = '<cfoutput>#request.self#?fuseaction=invent.add_invent_purchase&receiving_detail_id=#get_inv_det.receiving_detail_id#</cfoutput>';
					else if(type == 4)
						action_page = '<cfoutput>#request.self#?fuseaction=cost.form_add_expense_cost&receiving_detail_id=#get_inv_det.receiving_detail_id#</cfoutput>';
					else if(type == 5)
						action_page = '<cfoutput>#request.self#?fuseaction=health.expenses&event=add&receiving_detail_id=#get_inv_det.receiving_detail_id#</cfoutput>';						
				
					form_basket.action=action_page;
					form_basket.target='_blank';
					form_basket.submit();
					return true;
				}
				
				//Print Ikonuna Basıldıgı an ajax calisiyor ve print count guncelleniyor. BK20140701
				$('#list_print_button').click(function() {					
					url_ = "/V16/objects/cfc/objects_process.cfc?method=update_print_count&receiving_detail_id=<cfoutput>#attributes.receiving_detail_id#</cfoutput>";
					$.ajax({
						//Ilgili islem onbellek uzerinden yapilmayacak
						cache: false,
						//CFC yeri belirtilir, ilgili degiskenler eklenir.
						url: url_,
						// Geri dönen verinin formati
						dataType: "text",
						//Donus degerine gore uyari veriliyor
						success: function(read_data)
						{
								if(read_data!=1)
									alert("<cf_get_lang dictionary_id='60058.Fatura Print Sayısı Güncellenemedi !'>");
						}
					});
				});

				function relation_paper()
				{
					if(document.getElementById('related_invoice_id').value == '' && document.getElementById('related_invoice_number').value == '')
					{
						alert("<cf_get_lang dictionary_id= '60059.Lütfen İlişkilendirilecek Belge Seçiniz !'>");	
						return false;
					}
					else
					{
						form_basket.action='<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_efatura_xml&efatura_id=#get_inv_det.einvoice_id#&associate=1</cfoutput>';
						form_basket.submit();
						return true;
					}
				}
				
				$(document).keydown(function(e){
					// ESCAPE key pressed
					if (e.keyCode == 27) {
						window.close();
					}
				});
			</script>
		<cfelse>
			<script>
				function displayResult() {
					xml = loadXMLDoc("<cfoutput>documents/#get_inv_det.path#</cfoutput>");
					xsl = loadXMLDoc("<cfoutput>documents/#get_inv_det.uuid#.xslt</cfoutput>");

					if(document.implementation && document.implementation.createDocument) {
						xsltProcessor = new XSLTProcessor();
						xsltProcessor.importStylesheet(xsl);
						resultDocument = xsltProcessor.transformToFragment(xml, document);
						document.getElementById("preview_invoice").appendChild(resultDocument);
						setTimeout( delXslt() , 5000);
					}
				}
				function delXslt(){
					var data = new FormData();
					data.append('xsltFilePath', '<cfoutput>#get_inv_det.uuid#</cfoutput>');
					AjaxControlPostData("<cfoutput>#request.self#?fuseaction=objects.popup_dsp_efatura_detail&is_display=1&receiving_detail_id=#attributes.receiving_detail_id#&type=1&mode=delXslt</cfoutput>" ,data,function(response) {}); 
				}
			</script>
			<cftry>
				<cfscript>
					xml_doc = XmlParse(inv_xml_data);		
					xslt = xml_doc.Invoice.AdditionalDocumentReference[attributes.row].Attachment.EmbeddedDocumentBinaryObject.XmlText;
				</cfscript>
				<cfloop from="1" to="#arraylen(xml_doc.Invoice.AdditionalDocumentReference)#" index="kk">
					<cfif structkeyexists(xml_doc.Invoice.AdditionalDocumentReference[kk],"Attachment") and listlast(xml_doc.Invoice.AdditionalDocumentReference[kk].Attachment.EmbeddedDocumentBinaryObject.xmlattributes.filename,'.') eq 'xslt'>
						<cfset xslt = xml_doc.Invoice.AdditionalDocumentReference[kk].Attachment.EmbeddedDocumentBinaryObject.XmlText>
						<cfbreak>
					</cfif>
				</cfloop>
				<cffile action="write" file="#upload_folder##dir_seperator##get_inv_det.uuid#.xslt" output="#toString(tobinary(xslt))#" charset="utf-8">
				<cffile action="read" file="#upload_folder##dir_seperator##get_inv_det.uuid#.xslt" variable="xslt" charset="utf-8">
				<div id="preview_invoice" />
				<script>
					$(document).ready(function(){
						displayResult();
					});
				</script>
				<!--- cfml tarafında xml gösterimlerinde çok fazla hata gelmeye başladı, js tarafındaki fonksiyonlar ile düzenleme yapıldı.// ilkerA 
					<cfoutput>#XmlTransform(xml_doc, xslt)#</cfoutput> 
				 	<cffile action="delete" file="#upload_folder##dir_seperator##get_inv_det.uuid#.xslt"> --->
				<cfcatch type="any">
					<cf_get_lang dictionary_id='34063.XML Dosyası Okunamadı , Lütfen XML Formatını Kontrol Ediniz !'>
				</cfcatch>
			</cftry>
		</cfif>
	</cfif>
<cfelse>
	<cfquery name="GET_INV_DET" datasource="#DSN2#">
		SELECT
			PATH,
			UUID,
			STATUS,
			EINVOICE_ID,
			ISNULL(IS_APPROVE,0) IS_APPROVE,
			PROCESS_STAGE,
			RECORD_DATE,
			RECORD_EMP,
			UPDATE_DATE,
			UPDATE_EMP,
			RECEIVING_DETAIL_ID,
			DETAIL
		FROM
			EINVOICE_RECEIVING_DETAIL
		WHERE
			RECEIVING_DETAIL_ID IN (#attributes.print_id#)
	</cfquery>
	<cfset attributes.is_display = 1>
	<!--- toplu print alındığında gelen çıktının müşteri formatına göre gelmesi için düzenleme yapıldı id: 118072--->
	<cfif not isdefined("attributes.is_display")>
	<div class="printThis">
	</cfif>
		<cfif get_inv_det.recordcount eq 0>  
			<cfset hata  = 11>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'>  <cf_get_lang dictionary_id='57999.Çalıştığınız Muhasebe Dönemine Ait Böyle Bir Fatura Bulunamadı'> !</cfsavecontent>
			<cfset hata_mesaj  = message>
			<cfinclude template="../../dsp_hata.cfm">
		<cfelse>
			<cfif not isdefined("attributes.is_display")>
			<style type="text/css">
				.e-fatura {
					border-left:1px solid #000000;
					border-right:1px solid #000000;
					border-bottom:1px solid #000000;
					border-top:1px solid #000000;
					border-collapse:collapse;
				}
				.e-fatura tr  {
					border:1px solid #000000;
				}
				.e-fatura tr  td{
					border:1px solid #000000;
					padding:2px;
				}
			</style>
			</cfif>
			<cfoutput query="get_inv_det">
				<cffile action="read" file="#upload_folder##dir_seperator##path#" variable="inv_xml_data" charset="utf-8">
				<cfif not isdefined("attributes.is_display")>
					<cftry>
						<cfscript>
							xml_doc = XmlParse(inv_xml_data);
							adres = '';
							adres_gelen = '';
							//gonderici bilgileri
							if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.PartyName.Name.XmlText"))
								member_name = '#xml_doc.Invoice.AccountingSupplierParty.Party.PartyName.Name.XmlText#';
							else if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.Person.FirstName.XmlText"))
								member_name = '#xml_doc.Invoice.AccountingSupplierParty.Party.Person.FirstName.XmlText# #xml_doc.Invoice.AccountingSupplierParty.Party.Person.FamilyName.XmlText#';					
							else
								member_name = '';
								
							if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.StreetName.XmlText"))			
								adres = '#adres# #xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.StreetName.XmlText#';
							if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.BuildingNumber.XmlText"))
								adres = '#adres# No : #xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.BuildingNumber.XmlText#';
							if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.PostalZone.XmlText"))
								adres = '#adres# #xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.PostalZone.XmlText#';
							adres = '#adres# #xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.CitySubdivisionName.XmlText#';
							adres = '#adres#/#xml_doc.Invoice.AccountingSupplierParty.Party.PostalAddress.CityName.XmlText#';
							if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.Contact.telephone.XmlText"))
								telefon = 'Tel : #xml_doc.Invoice.AccountingSupplierParty.Party.Contact.telephone.XmlText#';
							else
								telefon = '';
							if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.Contact.Telefax.XmlText"))
								telefon = '#telefon# Fax : #xml_doc.Invoice.AccountingSupplierParty.Party.Contact.Telefax.XmlText#';
								
							if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.Contact.ElectronicMail.XmlText"))
								eposta = 'E-Posta : #xml_doc.Invoice.AccountingSupplierParty.Party.Contact.ElectronicMail.XmlText#';
							else
								eposta = '';
							website = '';
							code_list_name = '';
							code_list_value = '';
							for(kk=1;kk<=arraylen(xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification);kk++)
							{
								if(len(xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlText))
								{
									code_list_name = listappend(code_list_name,xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlAttributes.schemeID);
									code_list_value = listappend(code_list_value,xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlText);
									if(xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlAttributes.schemeID eq 'VKN')
										temp_VKN = 	xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlText;
									else if(xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlAttributes.schemeID eq 'TCKN')
										temp_VKN =  xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification[kk].Id.XmlText;

								}					
							}
							if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.PartyTaxScheme.TaxScheme.Name.XmlText"))
								vergi_dairesi = 'Vergi Dairesi : #xml_doc.Invoice.AccountingSupplierParty.Party.PartyTaxScheme.TaxScheme.Name.XmlText#';
							else
								vergi_dairesi= 'Vergi Dairesi: ';
							//alıcı firma bilgileri
							if(StructKeyExists(xml_doc.Invoice.AccountingCustomerParty.Party,'PartyName'))
								member_name_gelen = '#xml_doc.Invoice.AccountingCustomerParty.Party.PartyName.Name.XmlText#';
							else
								member_name_gelen = '';
				
							if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.StreetName.XmlText"))
								adres_gelen = '#adres_gelen# #xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.StreetName.XmlText#';
				
							if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.BuildingNumber.XmlText"))
								adres_gelen = '#adres_gelen# No : #xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.BuildingNumber.XmlText#';
							if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.PostalZone.XmlText"))
								adres_gelen = '#adres_gelen# #xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.PostalZone.XmlText#';
							adres_gelen = '#adres_gelen# #xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.CitySubdivisionName.XmlText#';
							adres_gelen = '#adres_gelen#/#xml_doc.Invoice.AccountingCustomerParty.Party.PostalAddress.CityName.XmlText#';
							telefon_gelen = '';
							if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.Contact.telephone.XmlText"))
								telefon_gelen = '#telefon_gelen# Tel : #xml_doc.Invoice.AccountingCustomerParty.Party.Contact.telephone.XmlText#';
							if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.Contact.Telefax.XmlText"))
								telefon_gelen = '#telefon_gelen# Fax : #xml_doc.Invoice.AccountingCustomerParty.Party.Contact.Telefax.XmlText#';
							if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.Contact.ElectronicMail.XmlText"))
								eposta_gelen = 'E-Posta : #xml_doc.Invoice.AccountingCustomerParty.Party.Contact.ElectronicMail.XmlText#';
							else
								eposta_gelen = '';
							website_gelen = '';
							vergi_no_gelen = 'VKN : #xml_doc.Invoice.AccountingCustomerParty.Party.PartyIdentification.Id.XmlText#';
							if(isdefined("xml_doc.Invoice.AccountingCustomerParty.Party.PartyTaxScheme.TaxScheme.Name.XmlText"))
								vergi_dairesi_gelen = 'Vergi Dairesi : #xml_doc.Invoice.AccountingCustomerParty.Party.PartyTaxScheme.TaxScheme.Name.XmlText#';
							else
								vergi_dairesi_gelen= 'Vergi Dairesi: ';
							//Fatura bilgileri
							versiyon_no = '#xml_doc.Invoice.CustomizationID.XmlText#';
							invoice_type = '#xml_doc.Invoice.ProfileID.XmlText#';
							invoice_sale_type = '#xml_doc.Invoice.InvoiceTypeCode.XmlText#';
							invoice_number = '#xml_doc.Invoice.Id.XmlText#';
							invoice_date = '#left(xml_doc.Invoice.IssueDate.XmlText,10)#';
							if(isdefined("xml_doc.Invoice.OrderReference.Id.XmlText"))
							{
								order_no = '#xml_doc.Invoice.OrderReference.Id.XmlText#';
								order_date = '#xml_doc.Invoice.OrderReference.IssueDate.XmlText#';
							}
							else
							{
								order_no = '';
								order_date = '';
							}
							if(isdefined("xml_doc.Invoice.PaymentMeans.PaymentDueDate.XmlText"))
								due_date = '#xml_doc.Invoice.PaymentMeans.PaymentDueDate.XmlText#';
							else
								due_date = '';

							if(isdefined("xml_doc.Invoice.DespatchDocumentReference.Id.XmlText"))
							{
								ship_no = '#xml_doc.Invoice.DespatchDocumentReference.Id.XmlText#';
								ship_date = '#xml_doc.Invoice.DespatchDocumentReference.IssueDate.XmlText#';
							}
							else
							{
								ship_no = '';
								ship_date = '';
							}
							ettn = '#xml_doc.Invoice.UUID.XmlText#';
							detail = '';
							if(isdefined("xml_doc.Invoice.Note.XmlText"))
							{
							for(i=1;i<=arraylen(xml_doc.Invoice.Note);++i)
								detail = '#detail# #xml_doc.Invoice.Note[i].XmlText#<br>';
							}
							if(isdefined("xml_doc.Invoice.PaymentTerms.Id.XmlText"))
								payment_term = '#xml_doc.Invoice.PaymentTerms.XmlText#';
							else
								payment_term = '';
							//fatura satırları
							line_count = '#xml_doc.Invoice.LineCountNumeric.XmlText#';
							invoice_total = '#xml_doc.Invoice.LegalMonetaryTotal.LineExtensionAmount.XmlText#';
							invoice_money = '#xml_doc.Invoice.LegalMonetaryTotal.LineExtensionAmount.XmlAttributes.currencyID#';
							if(isdefined("xml_doc.Invoice.LegalMonetaryTotal.AllowanceTotalAmount.XmlText"))
								discount_total = '#xml_doc.Invoice.LegalMonetaryTotal.AllowanceTotalAmount.XmlText#';
							else
								discount_total = 0;
							all_total = '#xml_doc.Invoice.LegalMonetaryTotal.TaxInclusiveAmount.XmlText#';
							pay_total = '#xml_doc.Invoice.LegalMonetaryTotal.PayableAmount.XmlText#';
							kontrol_xslt=0;
							if(isdefined("xml_doc.Invoice.AdditionalDocumentReference"))
								for(kk=1;kk<=arraylen(xml_doc.Invoice.AdditionalDocumentReference);kk++)
								{
									if(structkeyexists(xml_doc.Invoice.AdditionalDocumentReference[kk],"Attachment") && structkeyexists(xml_doc.Invoice.AdditionalDocumentReference[kk].Attachment,"EmbeddedDocumentBinaryObject"))
									{
										kontrol_xslt=kk;
										break;	
									}					
								}
						</cfscript>
						<cfcatch type="any">
							<cfset error = 'XML Dosyası Okunamadı, Lütfen XML Formatını Kontrol Ediniz!'>
						</cfcatch>
					</cftry>
					<cfif isdefined("error")>
						<table style="width:210mm;">
							<tr>
								<td>#error#</td>
							</tr>
						</table>
					<cfelse>
						<table style="width:210mm;" border="0">
							<tr>
								<!---Gönderici Üye Bilgileri --->
								<td width="80%">
									<table width="100%">
										<tr><td><hr></td></tr>
										<tr>
											<td>
												<cfif not len(status)>
													<cfif isdefined('temp_VKN') and len(temp_VKN)>
														<cfquery name="GET_MEMBER" datasource="#DSN#">
															SELECT 
																1 AS TYPE,
																C.COMPANY_ID AS MEMBER_ID
															FROM 
																COMPANY C,
																COMPANY_PARTNER CP, 
																COMPANY_CAT CC, 
																COMPANY_CAT_OUR_COMPANY CCO 
															WHERE                                                               
																(C.TAXNO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp_VKN#"> OR 
																CP.TC_IDENTITY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp_VKN#">) AND
																CCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
																C.COMPANY_ID = CP.COMPANY_ID AND
																C.MANAGER_PARTNER_ID = CP.PARTNER_ID AND
																C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
																CC.COMPANYCAT_ID = CCO.COMPANYCAT_ID
															UNION ALL
															SELECT 
																2 AS TYPE,
																C.CONSUMER_ID AS MEMBER_ID
															FROM 
																CONSUMER C, 
																CONSUMER_CAT CC, 
																CONSUMER_CAT_OUR_COMPANY CCO 
															WHERE                                                               
																C.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#temp_VKN#"> AND
																CCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
																C.CONSUMER_CAT_ID = CC.CONSCAT_ID AND
																CC.CONSCAT_ID = CCO.CONSCAT_ID
														</cfquery>
													<cfelse>
														<cfset get_member.recordcount=0>
													</cfif>
													
													<div class="input-group"><input type="text" name="comp_name" id="comp_name" readonly value="#member_name#" style="width:300px;">
													<cfif get_member.recordcount eq 1 and get_member.type eq 1>
														<input type="hidden" name="company_id" id="company_id" value="#get_member.member_id#">
														<input type="hidden" name="consumer_id" id="consumer_id" value="">
													<cfelseif get_member.recordcount eq 1 and get_member.type eq 2>
														<input type="hidden" name="company_id" id="company_id" value="">
														<input type="hidden" name="consumer_id" id="consumer_id" value="#get_member.member_id#">                                                        
													<cfelse>
														<input type="hidden" name="company_id" id="company_id" value="">
														<input type="hidden" name="consumer_id" id="consumer_id" value="">
														<!-- sil --><span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&select_list=2,3&field_comp_name=form_basket.comp_name&field_comp_id=form_basket.company_id&field_consumer=form_basket.consumer_id','list');"> </span><!-- sil --> 
														<cfif get_member.recordcount neq 0>
															<font color="red"><cf_get_lang dictionary_id='33966.Vergi Numarası veya TC Kimlik Numarası İle İle Eşleşen Birden Fazla Üye Kaydı Mevcut.'><cf_get_lang dictionary_id='34146.Lütfen Üye Seçiniz !'></font>
														<cfelse>
															<font color="red"><cf_get_lang dictionary_id='34143.Vergi Numarası veya TC Kimlik Numarası İle Eşleşen Üye Kaydı Bulunamadı.'><cf_get_lang dictionary_id='34146.Lütfen Üye Seçiniz !'></font>
														</cfif>
													</cfif>
													</div>
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
										<cfloop list="#code_list_name#" index="kk">
											<tr>
												<td>#kk# : #listgetat(code_list_value,listfind(code_list_name,kk))#</td>
											</tr>
										</cfloop>
										<tr><td><hr></td></tr>
									</table>
								</td>
								<!--- Logo --->
								<td>
									<table width="100%" align="center">
										<tr>
											<td style="text-align:center">
												<img style="height:25mm; width:25mm;" src="images/gib_logo.png">
											</td>
										</tr>
										<tr>
											<td style="text-align:center"  ><cf_get_lang dictionary_id='29872.E-FATURA'></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<!--- Alıcı Üye Bilgileri --->
								<td valign="top">
									<table width="100%">
										<tr><td><hr></td></tr>
										<tr><td  ><cf_get_lang dictionary_id='58780.SAYIN'></td></tr>
										<tr>
											<td>#member_name_gelen#</td>
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
										<tr><td><hr></td></tr>
									</table>
								</td>
								<td>&nbsp;</td>
								<!--- fatura bilgileri --->
								<td valign="top">
									<table border="1" class="e-fatura" width="250"  style="float:right"cellpadding="2" cellspacing="0" bordercolor="000000">
										<tr>
											<td     ><cf_get_lang dictionary_id='34139.Özelleştirme'><cf_get_lang dictionary_id='57487.NO'>:</td>
											<td>#versiyon_no#</td>
										</tr>
										<tr>
											<td     ><cf_get_lang dictionary_id='59321.Senaryo'>:</td>
											<td>#invoice_type#</td>
										</tr>
										<tr>
											<td     ><cf_get_lang dictionary_id='59094.Fatura Tipi'>:</td>
											<td>#invoice_sale_type#</td>
										</tr>
										<tr>
											<td     ><cf_get_lang dictionary_id='58133.Fatura No'>:</td>
											<td>#invoice_number#</td>
										</tr>
										<tr>
											<td     ><cf_get_lang dictionary_id='58759.Fatura Tarihi'>:</td>
											<td style="text-align:left;">#dateformat(invoice_date,'dd-mm-yyyy')#</td>
										</tr>
										<cfif len(due_date)>
											<tr>
												<td     ><cf_get_lang dictionary_id='57881.Vade Tarihi'>:</td>
												<td style="text-align:left;">#dateformat(due_date,'dd-mm-yyyy')#</td>
											</tr>
										</cfif>
										<tr>
											<td     ><cf_get_lang dictionary_id='58211.Sipariş No'>:</td>
											<td>#order_no#</td>
										</tr>
										<tr>
											<td     ><cf_get_lang dictionary_id='29501.Sipariş Tarihi'>:</td>
											<td>#dateformat(order_date,'dd-mm-yyyy')#</td>
										</tr>
										<tr>
											<td     ><cf_get_lang dictionary_id='58138.İrsaliye No'>:</td>
											<td>#ship_no#</td>
										</tr>
										<tr>
											<td     ><cf_get_lang dictionary_id='33096.İrsaliye Tarihi'>:</td>
											<td>#dateformat(ship_date,'dd-mm-yyyy')#</td>
										</tr>
									</table>
								</td>
							</tr>
							<!--- Fatura satırları --->
							<tr>
								<td colspan="3">
									<table>
										<tr>
											<td  >ETTN:</td>
											<td>#ettn#</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<table border="1" class="e-fatura" width="100%" cellpadding="2" cellspacing="0" bordercolor="000000">
										<tr height="20">
											<td  ><cf_get_lang dictionary_id='31253.Sıra No'></td>
											<td   colspan="2"><cf_get_lang dictionary_id='45517.Mal'><cf_get_lang dictionary_id='33283.Hizmet'></td>
											<td  ><cf_get_lang dictionary_id='57635.Miktar'></td>
											<td  ><cf_get_lang dictionary_id='57638.Birim Fiyat'></td>
											<td  ><cf_get_lang dictionary_id='38190.İskonto Oranı'></td>
											<td  ><cf_get_lang dictionary_id='34077.İskonto Tutarı'></td>
											<td  ><cf_get_lang dictionary_id='32536.KDV Oranı'></td>
											<td  ><cf_get_lang dictionary_id='33214.KDV Tutarı'></td>
											<cfif x_otv_line eq 1>
												<td  ><cf_get_lang dictionary_id='38922.ÖTV Oranı'></td>
												<td  ><cf_get_lang dictionary_id='34085.ÖTV Tutarı'></td>
											</cfif>
											<td  ><cf_get_lang dictionary_id='34078.Diğer Vergiler'></td>
											<td  ><cf_get_lang dictionary_id='45517.Mal'><cf_get_lang dictionary_id='33283.Hizmet'><cf_get_lang dictionary_id='57673.Tutarı'></td>
										</tr>
										<cfset line_count = arraylen(xml_doc.Invoice.InvoiceLine)>
										<cfif line_count eq 0><cfset line_count = 1></cfif><!---damga vergisi olduğında satır olarak gelmiyordu o yüzden eklendi.--->
										<input type="hidden" name="line_count" id="line_count" value="#line_count#">
										<cfloop from="1" to="#line_count#" index="kk">
											<cftry>
												<cfset discount = '#xml_doc.Invoice.InvoiceLine[kk].AllowanceCharge.MultiplierFactorNumeric.XmlText*100#'>
												<cfcatch type="any">
													<cfset discount = 0>
												</cfcatch>
											</cftry>
											<cftry>
												<cfset discount_amount = '#xml_doc.Invoice.InvoiceLine[kk].AllowanceCharge.Amount.XmlText#'>
												<cfset discount_money = '#xml_doc.Invoice.InvoiceLine[kk].AllowanceCharge.Amount.XmlAttributes.currencyID#'>
												<cfcatch type="any">
													<cfset discount_amount = 0>
													<cfset discount_money = "">
												</cfcatch>
											</cftry>
											<cfset other_tax_detail_list = ''>
											<cfset otv = 0>
											<cfset otv_amount = 0>
											<cfset tax = 0>
											<cfset tax_amount = 0>
											<cfset tax_money = "">
											<cftry>
												<cfloop from="1" to="#arraylen(xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal)#" index="jj">
													<cfif StructKeyExists(xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxCategory.TaxScheme,'TaxTypeCode') and xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxCategory.TaxScheme.TaxTypeCode.XmlText eq 0015><!--- kdv ise --->
														<cfset tax = '#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].Percent.XmlText#'>
														<cfset tax_money = '#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlAttributes.currencyID#'>
														<cfset tax_amount = '#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlText#'>
													<cfelse>
														<cfif x_otv_line eq 1 and StructKeyExists(xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj],'CalculationSequenceNumeric') and xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].CalculationSequenceNumeric.XmlText eq 1><!--- ötv ise --->
															<cfset otv = '#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].Percent.XmlText#'>
															<cfset otv_amount = '#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlText#'>
														<cfelse>
															<cfif len(other_tax_detail_list)>
																<cfset other_tax_detail_list = '#other_tax_detail_list#<br>#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxCategory.TaxScheme.Name.XmlText# (%#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].Percent.XmlText#)=#tlformat(xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlText)# #xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlAttributes.currencyID#'>
															<cfelse>
																<cfset other_tax_detail_list = '#other_tax_detail_list# #xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxCategory.TaxScheme.Name.XmlText# (%#xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].Percent.XmlText#)=#tlformat(xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlText)# #xml_doc.Invoice.InvoiceLine[kk].TaxTotal.TaxSubtotal[jj].TaxAmount.XmlAttributes.currencyID#'>
															</cfif>
														</cfif>
													</cfif>
												</cfloop>
												<cfcatch type="any">
													<cfset tax = 0>
													<cfset tax_amount = 0>
													<cfset otv = 0>
													<cfset otv_amount = 0>
													<cfset tax_money = "">
												</cfcatch>
											</cftry>
											<cftry>
												<cfset product_name_tax = '#xml_doc.Invoice.InvoiceLine[kk].Item.Name.XmlText#'>
												<cfcatch type="any">
													
													<cfset product_name_tax = "">
												</cfcatch>
											</cftry>
											<cftry>
												<cfscript>
													product_name = '#replace(trim(xml_doc.Invoice.InvoiceLine[kk].Item.Name.XmlText),'"','')#';
													quantity = '#xml_doc.Invoice.InvoiceLine[kk].InvoicedQuantity.XmlText#';
													unit_code = '#xml_doc.Invoice.InvoiceLine[kk].InvoicedQuantity.XmlAttributes.UnitCode#';
													price = '#xml_doc.Invoice.InvoiceLine[kk].Price.PriceAmount.XmlText#';
													money = '#xml_doc.Invoice.InvoiceLine[kk].Price.PriceAmount.XmlAttributes.currencyID#';
													amount = '#xml_doc.Invoice.InvoiceLine[kk].LineExtensionAmount.XmlText#';
												</cfscript>
												<cfcatch type="any">
													<cfscript>
														product_name = '';
														quantity = '';
														unit_code = '';
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
											<tr>
												<td>#kk#</td>
												<td>
													<cfif len(product_name)>#product_name#<cfelse>#product_name_tax#</cfif>&nbsp;&nbsp;&nbsp;&nbsp;
													<input type="hidden" name="stock_id_#kk#" id="stock_id_#kk#" value="">
													<input type="hidden" name="quantity_#kk#" id="quantity_#kk#" value="#quantity#">
													<input type="hidden" name="price_#kk#" id="price_#kk#" value="#price#">
													<input type="hidden" name="net_total_#kk#" id="net_total_#kk#" value="#price*quantity#">
													<input type="hidden" name="discount_#kk#" id="discount_#kk#" value="#discount#">
													<input type="hidden" name="tax_#kk#" id="tax_#kk#" value="#tax#">
												</td>
												<td>
													<!-- sil -->
													<cfif not len(status)>
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id_#kk#&keyword=#product_name#','list');"><i class="fa fa-ellipsis-v"></i></a>
													</cfif>
													<!-- sil -->
												</td>
												<td style="text-align:right;"   >#tlformat(quantity)# #get_unit_code.unit#</td>
												<td style="text-align:right;"   >#tlformat(price)# #money#</td>
												<td style="text-align:right;"   >% #tlformat(discount)#</td>
												<td style="text-align:right;"   >#tlformat(discount_amount)# #discount_money#</td>
												<td style="text-align:right;"   ><cfif tax neq 0>% #tlformat(tax)#</cfif></td>
												<td style="text-align:right;"><cfif tax_amount neq 0>#tlformat(tax_amount)# #tax_money#</cfif></td>
												<cfif x_otv_line eq 1>
													<td style="text-align:right;"   ><cfif otv neq 0>% #tlformat(otv)#</cfif></td>
													<td style="text-align:right;"><cfif otv_amount neq 0>#tlformat(otv_amount)# #money#</cfif></td>
												</cfif>
												<td style="text-align:right;"><cfif len(other_tax_detail_list)>#other_tax_detail_list#</cfif></td>
												<td style="text-align:right;">#tlformat(amount)#</td>
											</tr>
										</cfif>
										</cfloop>
										<cfloop from="1" to="#20-line_count#" index="jj">
											<tr height="20">
												<td>&nbsp;</td>
												<td colspan="2">&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
												<cfif x_otv_line eq 1>
													<td>&nbsp;</td>
													<td>&nbsp;</td>
												</cfif>
												<td>&nbsp;</td>
												<td>&nbsp;</td>
											</tr>
										</cfloop>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
								<td>
									<table border="1" class="e-fatura" cellpadding="2" cellspacing="0" bordercolor="000000" style="padding:0; margin-left:95px; width:280px;">					
										<tr>
											<td style="text-align:right;"><cf_get_lang dictionary_id='34138.Mal Hizmet Toplam Tutarı'></td>
											<td style="text-align:right;"   >#tlformat(invoice_total)# #invoice_money#</td>
										</tr>
										<tr>
											<td style="text-align:right;"><cf_get_lang dictionary_id='57086.Toplam İskonto'></td>
											<td style="text-align:right;"   >#tlformat(discount_total)# #invoice_money#</td>
										</tr>

										<cfloop from="1" to="#arraylen(xml_doc.Invoice.TaxTotal.TaxSubtotal)#" index="kk">
											<cftry>
												<cfset tax = '#xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].Percent.XmlText#'>
												<cfset tax_amount = '#xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxAmount.XmlText#'>
												<cfif StructKeyExists(xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxCategory.TaxScheme,'Name') and len(xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxCategory.TaxScheme.Name.XmlText)>
													<cfset tax_category = '#xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxCategory.TaxScheme.Name.XmlText#'>
												<cfelse>
													<cfset tax_category = ''>
												</cfif>
												<cfcatch type="any">
													<cftry>
														<cfset tax = 0>
														<cfset tax_amount = '#xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxAmount.XmlText#'>
														<cfset tax_category = '#xml_doc.Invoice.TaxTotal.TaxSubtotal[kk].TaxCategory.TaxScheme.Name.XmlText#'>
														<cfcatch type="any">
															<cfset tax_amount = 0>
														</cfcatch>
													</cftry>
												</cfcatch>
											</cftry>
											<cfif tax_amount gt 0>
												<tr>
													<td style="text-align:right;"><cf_get_lang dictionary_id='34137.Hesaplanan'> #tax_category#(%#tax#)</td>
													<td style="text-align:right;"   >#tlformat(tax_amount)# #invoice_money#</td>
												</tr>
											</cfif>
										</cfloop>
										<cfif StructKeyExists(xml_doc.Invoice,'WithholdingTaxTotal')>
											<cfloop from="1" to="#arraylen(xml_doc.Invoice.WithholdingTaxTotal.TaxSubtotal)#" index="kk">
											<cftry>
												<cfset tax = '#xml_doc.Invoice.WithholdingTaxTotal.TaxSubtotal[kk].Percent.XmlText#'>
												<cfset tax_amount = '#xml_doc.Invoice.WithholdingTaxTotal.TaxSubtotal[kk].TaxAmount.XmlText#'>
												<cfset tax_category = '#xml_doc.Invoice.WithholdingTaxTotal.TaxSubtotal[kk].TaxCategory.TaxScheme.Name.XmlText#'>
												<cfcatch type="any">
												<cfset tax_amount = 0>
												</cfcatch>
											</cftry>
											<cfif tax_amount gt 0>
												<tr>
												<td style="text-align:right;"><cf_get_lang dictionary_id='60060.Hesaplanan KDV Tevkifat'>(%#tax#)</td>
												<td style="text-align:right;"   >#tlformat(tax_amount)# #invoice_money#</td>
												</tr>
											</cfif>
											</cfloop>
										</cfif>                                        
										<tr>
											<td style="text-align:right;"><cf_get_lang dictionary_id='34100.Vergiler Dahil Toplam Tutar'></td>
											<td style="text-align:right;"   >#tlformat(all_total)# #invoice_money#</td>
										</tr>
										<tr>
											<td style="text-align:right;"><cf_get_lang dictionary_id='34377.Ödenecek Tutar'></td>
											<td style="text-align:right;"   >#tlformat(pay_total)# #invoice_money#</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<table style="width:208mm;height:15mm; margin:4px; page-break-after:always;-webkit-region-break-after: always;" border="1" cellpadding="2" cellspacing="0" bordercolor="000000" class="e-fatura">
							<tr>
								<td>
									<b><cf_get_lang dictionary_id='57467.Not'>:</b> #detail#<br>
									<b><cf_get_lang dictionary_id='34098.Ödeme Koşulu'>:</b> #payment_term#
								</td>
								<cfif isdefined("xml_doc.Invoice.TaxExchangeRate")>
									<td style="text-align:right">
										<table class="e-fatura">
											<cfloop from="1" to="#arraylen(xml_doc.Invoice.TaxExchangeRate)#" index="kk">
												<cftry>
													<cfset money = '#xml_doc.Invoice.TaxExchangeRate[kk].TargetCurrencyCode.XmlText#'>
													<cfset rate = '#xml_doc.Invoice.TaxExchangeRate[kk].CalculationRate.XmlText#'>
													<cfcatch type="any">
														<cfset money = "">
														<cfset rate = 0>
													</cfcatch>
												</cftry>
												<cfif rate gt 0>
													<tr>
														<td style="text-align:right;"  >#money#</td>
														<td style="text-align:right;"   >#tlformat(rate,4)#</td>
													</tr>
												</cfif>
											</cfloop>
										</table>
									</td>
								</cfif>
							</tr>
						</table>
					</cfif>				
				<cfelse>
					<cftry>
						<cfscript>
							xml_doc = XmlParse(inv_xml_data);		
							// xslt = xml_doc.Invoice.AdditionalDocumentReference[attributes.row].Attachment.EmbeddedDocumentBinaryObject.XmlText;
							kontrol_xslt=0;
							if(isdefined("xml_doc.Invoice.AdditionalDocumentReference"))
								for(kk=1;kk<=arraylen(xml_doc.Invoice.AdditionalDocumentReference);kk++)
								{
									if(structkeyexists(xml_doc.Invoice.AdditionalDocumentReference[kk],"Attachment") && structkeyexists(xml_doc.Invoice.AdditionalDocumentReference[kk].Attachment,"EmbeddedDocumentBinaryObject"))
									{
										kontrol_xslt=kk;
										break;	
									}					
								}
							xslt = xml_doc.Invoice.AdditionalDocumentReference[kontrol_xslt].Attachment.EmbeddedDocumentBinaryObject.XmlText;
						</cfscript>
						<cfloop from="1" to="#arraylen(xml_doc.Invoice.AdditionalDocumentReference)#" index="kk">
							<cfif structkeyexists(xml_doc.Invoice.AdditionalDocumentReference[kk],"Attachment") and listlast(xml_doc.Invoice.AdditionalDocumentReference[kk].Attachment.EmbeddedDocumentBinaryObject.xmlattributes.filename,'.') eq 'xslt'>
								<cfset xslt = xml_doc.Invoice.AdditionalDocumentReference[kk].Attachment.EmbeddedDocumentBinaryObject.XmlText>
								<cfbreak>
							</cfif>
						</cfloop>
						<cffile action="write" file="#upload_folder##dir_seperator##uuid#.xslt" output="#toString(tobinary(xslt))#" charset="utf-8">
						<cffile action="read" file="#upload_folder##dir_seperator##uuid#.xslt" variable="xslt" charset="utf-8">
						<script>
							$(document).ready(function(){
								displayResult('#path#', '#uuid#');
							});
						</script>
						<div id="xx" />
						<!--- #XmlTransform(xml_doc, xslt)# cfml tarafında bazı xmller parse edilemiyor, js tarafına çevrildi.
						<cffile action="delete" file="#upload_folder##dir_seperator##uuid#.xslt"> 
						<cfif RECEIVING_DETAIL_ID[currentrow] neq RECEIVING_DETAIL_ID[currentrow-1]>
							<div id="pt" style="width:208mm;height:15mm; margin:4px; page-break-after:always;-webkit-region-break-after: always;display:none;"></div>
						</cfif> --->
						<cfquery name="UPD_PRINT_COUNT" datasource="#dsn2#">
							UPDATE EINVOICE_RECEIVING_DETAIL SET PRINT_COUNT = ISNULL(PRINT_COUNT,0) + 1 WHERE RECEIVING_DETAIL_ID = #RECEIVING_DETAIL_ID#
						</cfquery>
						<cfcatch type="any">
							<cf_get_lang dictionary_id='34063.XML Dosyası Okunamadı , Lütfen XML Formatını Kontrol Ediniz !'>
						</cfcatch>
					</cftry>
				</cfif>
			</cfoutput>
		</cfif>	
	<cfif not isdefined("attributes.is_display")>
	</div>
	</cfif>	
	<script type="text/javascript">
		window.print();
		function displayResult(Xmlpath, XsltPath) {
			xml = loadXMLDoc('documents/'+Xmlpath);
			xsl = loadXMLDoc('documents/'+XsltPath+".xslt");

			if(document.implementation && document.implementation.createDocument) {
				xsltProcessor = new XSLTProcessor();
				xsltProcessor.importStylesheet(xsl);
				resultDocument = xsltProcessor.transformToFragment(xml, document);
				document.getElementById("xx").appendChild(resultDocument);
				$("<div>").css({ "width": "208mm", "height" : "15mm",  "margin" : "4px", "page-break-after" : "always" }).appendTo( $("#xx") );
				setTimeout( delXslt(XsltPath) , 5000);
			}
		}
		function delXslt(XsltPath){
			var data = new FormData();
			data.append('xsltFilePath', XsltPath);
			AjaxControlPostData("<cfoutput>#request.self#?fuseaction=objects.popup_dsp_efatura_detail&print=1&type=1&mode=delXslt</cfoutput>" ,data,function(response) {}); 
		}
	</script>
</cfif>
<script type="text/javascript">
	function add_order(){	
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
	function loadXMLDoc(filename) {
		if (window.ActiveXObject) {/*  */
			xhttp = new ActiveXObject("Msxml2.XMLHTTP");
		}
		else {
			xhttp = new XMLHttpRequest();
		}
		xhttp.open("GET", filename, false);
		try { xhttp.responseType = "msxml-document" } catch (err) { } // Helping IE11
		xhttp.send("");
		return xhttp.responseXML;
	}
</script>