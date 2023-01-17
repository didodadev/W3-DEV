<cfset list_middle_info = "					
					StockCode-Stok Kodu,
					UrunRafKodu-Ürün Raf Kodu,
					UrunOzelKod-Özel Kod,
					Barcod-Barkod,
					NameProduct-Ürün Adı, 
					ProductName2-Ürün Adı 2,
					Amount-Miktar,
					Amount2-Miktar 2,
					Unit-Birim,
					Unit2-Birim 2,
					RowPrice-#session.ep.money# Birim Fiyat,
					RowOtherMoney-Döviz,
					RowPriceOther-Döviz Fiyat,
					RowDiscount1-İsk 1,
					RowDiscount2-İsk 2,
					RowDiscount3-İsk 3,
					RowDiscount4-İsk 4,
					RowDiscount5-İsk 5,
					RowDiscount6-İsk 6,
					RowDiscount7-İsk 7,
					RowDiscount8-İsk 8,
					RowDiscount9-İsk 9,
					RowDiscount10-İsk 10,
					RowDiscounttotal-İsk Toplam,
					RowTax-Kdv,
					RowTaxtotal-Kdv Toplam,
					RowOtvOran-Ötv,
					RowOtvtotal-Ötv Toplam,
					RowTotal-Satır Toplam,
					RowNettotal-Net Satır Toplam,
					RowGrosstotal-Son Toplam,
					RowMargin-Marj,
					RowCostPrice-Net Maliyet,
					RowExtraPrice-Ek Maliyet,
					RowListPrice-Liste Fiyatı,
					RowKarmaKoliAdi-Karma Koli Adı,
					RowDeliverDate-Teslim Tarihi,
					RowDevirDipToplam-Devir Dip Toplam
					">
<cfset list_bottom_info = "
					SubTotal-Ara Toplam,
					SaDiscount-Fatura Altı İndirim,
					DiscountTotal-İskonto Toplam,
					TaxTotal-Kdv Toplam,
					OtvTotal-Ötv Toplam,
					NetTotal-Genel Toplam,
					NetTotal2-Genel Toplam2,					
					OtherMoneyValue-Döviz Toplam,
					OtherMoney-Döviz,
					DeliverEmp-Teslim Alan,
					Note-Açıklama,
					TotalWithWrite-Yazıyla,
					TotalWithWriteEng-Yazıyla İngilizce,
					RowDevredenToplam-Devreden Toplam
					">
<cfset list_top_info = "
					CompanyLogo-Şirket Logosu,
					MemberCode-Müşteri Kodu,
					MemberCompanyName-Müşteri Adı,
					MemberPartnerName-Yetkili,
					MemberAddress-Adres,
					MemberCountry-Ülke,
					MemberCity-Şehir,
					MemberCounty-İlçe,
					MemberMainDistrict-Semt,
					MemberPostcode-Posta Kodu,
					MemberTaxnumber-Vergi No,
					MemberTaxoffice-Vergi Dairesi,
					MemberTelcode-Telefon Kodu,
					MemberTelnumber-Telefon No,
					MemberRemainder-Bakiye,
					MemberIms-Bölge Kodu,
					ShipMemberAddress-Fatura Sevk Adresi,
					DocumentNumber-Belge No,
					DocumentDate-Belge Tarihi,
					RelatedShipDate-İlşk Sevk Tarihi,
					RelatedShipNumber-İlşk İrsaliye No,
					RelatedShipAddress-İlşk İrsaliye Adresi,
					RelatedOrderNumber-İlşk Sipariş No,
					ShipMethod-Sevk Yöntemi,
					PaymentMethod-Ödeme Yöntemi,
					ProjectName-Proje Adı,
					ReferenceNumber-Referans No,
					DueDate-Vade Tarihi,
					RecordDate-Kayıt Tarihi,
					RecordEmp-Kaydeden,
					PFileAddInfo-EkBilgi1,
					PFileAddInfo2-EkBilgi2,
					PFileAddInfo3-EkBilgi3															
					">
<cfparam name="attributes.PrintDesignName" default="">
<cfsetting showdebugoutput="no">
<cfquery name="get_design_paper_form" datasource="#dsn3#">
	SELECT 
    	FORM_ID, 
        PROCESS_TYPE, 
        MODULE_ID, 
        ACTIVE, 
        NAME, 
        TEMPLATE_FILE, 
        DETAIL, 
        IS_DEFAULT,
        TEMPLATE_FILE_SERVER_ID, 
        IS_STANDART, 
        IS_PARTNER, 
        IS_XML, 
        IMAGE_FILE, 
        IMAGE_FILE_SERVER_ID, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_PRINT_FILES 
    WHERE 
	    ACTIVE = 1 AND IS_XML = 1 AND FORM_ID = #attributes.design_id#
</cfquery>

<cfset XmlFolderName = "#upload_folder#settings#dir_seperator##get_design_paper_form.template_file#">
<cfparam name="MyDocument" default="">
<cfif FileExists("#XmlFolderName#")>
	<cffile action="read" file="#XmlFolderName#" variable="XmlDosyam" charset="UTF-8">
	<cfscript>
		 Dosyam = XmlParse(XmlDosyam);
		 MyDocument = Dosyam.DesignPaper[1];
	</cfscript>
</cfif>

<table cellpadding="0" cellspacing="0" align="center" width="98%">
	<tr>
		<td height="35" class="headbold"><cf_get_lang no='1278.Şablon Tasarımları'></td>
	</tr>
</table>
<cfform name="FormDesignPaper" action="#request.self#?fuseaction=settings.design_paper" method="post" enctype="multipart/form-data">
	<table id="main_table" cellspacing="1" cellpadding="2" style="width:210mm;height:300mm;" align="left" border="0">
        <input type="hidden" name="IsSubmit" id="IsSubmit" value="1">
		<input type="hidden" name="Design_Id" id="Design_Id" value="<cfoutput>#url.design_id#</cfoutput>">	
		<tr valign="top">
			<td valign="top">
			<cfoutput>
			<table class="color-header" cellpadding="2" cellspacing="1" border="0" style="width:260px">
				<!--- Sayfa Ozellikleri --->
				<tr class="color-list">
					<td class="txtboldblue" height="20" colspan="2">
						<a href="javascript://" onClick="gizle_goster_img(document.getElementById('img1_prp'),document.getElementById('img2_prp'),_page_properties_);"><img src="/images/listele.gif" border="0" align="absmiddle" id="img1_prp" style="display:;cursor:pointer;"></a>
						<a href="javascript://" onClick="gizle_goster_img(document.getElementById('img1_prp'),document.getElementById('img2_prp'),_page_properties_);"><img src="/images/listele_down.gif" border="0" align="absmiddle" id="img2_prp" style="display:none;cursor:pointer;"></a>
						<a style="cursor:pointer;" onClick="gizle_goster_img(document.getElementById('img1_prp'),document.getElementById('img2_prp'),_page_properties_);"><cf_get_lang no='2693.Sayfa Özellikleri'></a>
					</td>
				</tr>
				<tr valign="top" id="_page_properties_" class="color-row">
					<td height="250" colspan="2">
					<table border="0" style="position:absolute;z-index:88;overflow:auto;">
						<tr>
							<td nowrap><cf_get_lang no='455.Sayfa Adı'> *</td>
							<td colspan="3"><input type="text" name="PrintDesignName" id="PrintDesignName" value="<cfif len(MyDocument)>#MyDocument.XmlAttributes.PrintDesignName#</cfif>" style="width:40mm"></td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='657.Sayfa Tipi'> *</td>
							<td colspan="3">
								<select name="PrintDesignType" id="PrintDesignType">
									<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
									<option value="10-20" <cfif len(MyDocument) and MyDocument.XmlAttributes.PrintDesignType eq '10-20'>selected</cfif>><cf_get_lang_main no='29.Fatura'></option>
									<option value="30-13" <cfif len(MyDocument) and MyDocument.XmlAttributes.PrintDesignType eq '30-13'>selected</cfif>><cf_get_lang_main no='361.İrsaliye'></option>
									<option value="31-13" <cfif len(MyDocument) and MyDocument.XmlAttributes.PrintDesignType eq '31-13'>selected</cfif>><cf_get_lang no='2116.Stok Fişi'></option>
									<option value="70-11" <cfif len(MyDocument) and MyDocument.XmlAttributes.PrintDesignType eq '70-11'>selected</cfif>><cf_get_lang no='86.Satış Teklifi'></option>
									<option value="73-11" <cfif len(MyDocument) and MyDocument.XmlAttributes.PrintDesignType eq '73-11'>selected</cfif>><cf_get_lang no='87.Satış Siparişi'></option>
									<option value="90-12" <cfif len(MyDocument) and MyDocument.XmlAttributes.PrintDesignType eq '90-12'>selected</cfif>><cf_get_lang no='88.Satınalma Teklifi'></option>
									<option value="91-12" <cfif len(MyDocument) and MyDocument.XmlAttributes.PrintDesignType eq '91-12'>selected</cfif>><cf_get_lang no='71.Satınalma Siparişi'></option>
								</select>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='1228.Şablon'></td>
							<td colspan="3">
								<input type="file" name="include_template" id="include_template" value="" style="width:40mm;">
								<cfif len(get_design_paper_form.image_file)>
									<a href="javascript://" onClick="show_hide_background();"><img name="reload_img" title="Arka Plan Resmini Gizle/ Göster" src="/images/reload_page.gif" border="0" align="absmiddle"></a>
									<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.emptypopup_del_background_files&Design_Id=#attributes.design_id#&type=IMAGE_FILE&type_server_id=IMAGE_FILE_SERVER_ID</cfoutput>','small');"><img src="/images/delete_list.gif" border="0" align="absmiddle"></a>
								</cfif>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='283.Genişlik'></td>
							<td><input type="text" name="PageWidth" id="PageWidth" value="<cfif len(MyDocument)>#MyDocument.XmlAttributes.PageWidth#</cfif>" onChange="page_style(this.value,'width');" style="width:10mm;" onKeyUp="isNumber(this);" maxlength="3"></td>
							<td width="45"><cf_get_lang_main no='284.Yükseklik'></td>
							<td><input type="text" name="PageHeight" id="PageHeight" value="<cfif len(MyDocument)>#MyDocument.XmlAttributes.PageHeight#</cfif>" onChange="page_style(this.value,'height');" style="width:10mm;" onKeyUp="isNumber(this);" maxlength="3"></td>
						</tr>
						<cfif not isdefined("MyDocument.XmlAttributes.PageFontType")>
							<cfset MyDocument = ''>
						</cfif>
						<tr height="20">
							<td colspan="4" class="txtboldblue">Varsayılan <cf_get_lang no='2694.Font Özellikleri'></td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='218.Type'></td>
							<td colspan="3">
								<select name="PageFontType" id="PageFontType" onChange="document.execCommand('FontName',false,document.FormDesignPaper.PageFontType.value)">
									<option value="Arial" <cfif len(MyDocument)and MyDocument.XmlAttributes.PageFontType is 'Arial'>selected</cfif>> Arial</option>
									<option value="Verdana" <cfif len(MyDocument)and MyDocument.XmlAttributes.PageFontType is 'Verdana'>selected</cfif>> Verdana</option>
									<option value="Geneva" <cfif len(MyDocument)and MyDocument.XmlAttributes.PageFontType is 'Geneva'>selected</cfif>> Geneva</option>
									<option value="Times New Roman" <cfif len(MyDocument)and MyDocument.XmlAttributes.PageFontType is 'Times New Roman'>selected</cfif>> Times New Roman</option>
									<option value="Courier New" <cfif len(MyDocument)and MyDocument.XmlAttributes.PageFontType is 'Courier New'>selected</cfif>> Courier New</option>
									<option value="Georgia" <cfif len(MyDocument)and MyDocument.XmlAttributes.PageFontType is 'Georgia'>selected</cfif>> Georgia</option>
								</select>
							</td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='301.Boyut'></td>
							<td colspan="3">
								<select name="PageFontSize" id="PageFontSize" style="width:12mm;" onChange="document.execCommand('FontSize',false,document.FormDesignPaper.PageFontSize.value)">
									<cfloop from="8" to="36" index="_px_">
										<option value="#_px_#" <cfif len(MyDocument)and MyDocument.XmlAttributes.PageFontSize eq _px_>selected</cfif>>#_px_# px</option>
									</cfloop>
								</select>
							</td>
						</tr>
						<tr height="20">
							<td colspan="4" class="txtboldblue"> Kolon Yapısı</td>
						</tr>
						<tr>
							<td><cf_get_lang_main no='283.Genişlik'></td>
							<td><input type="text" id="ColumnWidth" name="ColumnWidth" value="<cfif len(MyDocument)>#MyDocument.XmlAttributes.ColumnWidth#</cfif>" style="width:10mm;" onKeyUp="isNumber(this);" maxlength="3"></td>
							<td><cf_get_lang_main no='284.Yükseklik'></td>
							<td><input type="text" id="ColumnHeight" name="ColumnHeight" value="<cfif len(MyDocument)>#MyDocument.XmlAttributes.ColumnHeight#</cfif>" style="width:10mm;" onKeyUp="isNumber(this);" maxlength="3"></td>
						</tr>
						<tr>
							<td><cf_get_lang no='2440.Satır Sayısı'></td>
							<td colspan="3"><input type="text" name="RowCount" id="RowCount" value="<cfif len(MyDocument)>#MyDocument.XmlAttributes.RowCount#</cfif>" style="width:10mm;" onKeyUp="isNumber(this);" maxlength="3"></td>
						</tr>
					</table>
					</td>
				</tr>
				<!--- Üst Kısım --->
				<tr class="color-list">
					<td class="txtboldblue" height="20" colspan="2">
						<a href="javascript://" onClick="gizle_goster_img(document.getElementById('img3_prp'),document.getElementById('img4_prp'),_top_properties_);"><img src="/images/listele.gif" border="0" align="absmiddle" id="img3_prp" style="display:;cursor:pointer;"></a>
						<a href="javascript://" onClick="gizle_goster_img(document.getElementById('img3_prp'),document.getElementById('img4_prp'),_top_properties_);"><img src="/images/listele_down.gif" border="0" align="absmiddle" id="img4_prp" style="display:none;cursor:pointer;"></a>
						<a style="display:;cursor:pointer;" onClick="gizle_goster_img(document.getElementById('img3_prp'),document.getElementById('img4_prp'),_top_properties_);"> <!---<cf_get_lang no='3152.Ust Kısım'>--->Üst Kısım</a>
					</td>
				</tr>                     
				<tr valign="top" id="_top_properties_" class="color-row">
					<td colspan="2">
						<div style="position:relative; height:150px; z-index:88; overflow:auto;">
						<table border="0">
							<tr align="center">
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<cfset top_line_ = 0>
							<cfset top_input_ = "">
							<cfloop list="#list_top_info#" index="x" delimiters=",">
							<cfset top_line_ = top_line_ + 1>
							<cfset top_input_ = "x_#listfirst(trim(x),'-')#">
							<cfset XmlValue = listfirst(trim(x),'-')>
						   <tr id="#top_input_#">
								<td><input type="text" name="#top_input_#_#top_line_#" id="#top_input_#_#top_line_#" onChange="design_div_position(this,'value',#top_line_#,'#top_input_#','x');" value="<cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlText")>#Evaluate('MyDocument.Top.#XmlValue#.XmlText')#<cfelse>#listlast(trim(x),'-')#</cfif>" style="width:50mm;"></td>										
								<td style="display:none">
									<table>
										<tr>
											<td><input type="text" name="#top_input_#_FontType_#top_line_#" id="#top_input_#_FontType_#top_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.FontType")>#Evaluate('MyDocument.Top.#XmlValue#.XmlAttributes.FontType')#<cfelse>Arial</cfif>" style="width:7mm;"></td>
											<td><input type="text" name="#top_input_#_FontSize_#top_line_#" id="#top_input_#_FontSize_#top_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.FontSize")>#Evaluate('MyDocument.Top.#XmlValue#.XmlAttributes.FontSize')#<cfelse>10</cfif>" style="width:7mm;"></td>										
											<td><input type="text" name="#top_input_#_Width_#top_line_#" id="#top_input_#_Width_#top_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.Width")>#Evaluate('MyDocument.Top.#XmlValue#.XmlAttributes.Width')#<cfelse>50</cfif>" onKeyUp="isNumber(this);" maxlength="3"></td>
											<td><input type="text" name="#top_input_#_Height_#top_line_#" id="#top_input_#_Height_#top_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.Height")>#Evaluate('MyDocument.Top.#XmlValue#.XmlAttributes.Height')#<cfelse>50</cfif>" onKeyUp="isNumber(this);" maxlength="3"></td>																		
											<td><input type="text" name="#top_input_#_TopMargin_#top_line_#" id="#top_input_#_TopMargin_#top_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.TopMargin")>#Evaluate('MyDocument.Top.#XmlValue#.XmlAttributes.TopMargin')#<cfelse>5</cfif>" style="width:7mm;" onKeyUp="isNumber(this);" maxlength="3"></td>
											<td><input type="text" name="#top_input_#_LeftMargin_#top_line_#" id="#top_input_#_LeftMargin_#top_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.LeftMargin")>#Evaluate('MyDocument.Top.#XmlValue#.XmlAttributes.LeftMargin')#<cfelse>5</cfif>" style="width:7mm;" onKeyUp="isNumber(this);" maxlength="3"></td>											
											<td><input type="checkbox" name="#top_input_#_Bold_#top_line_#" id="#top_input_#_Bold_#top_line_#" onClick="document.execCommand('Bold');" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.Bold") and Evaluate("MyDocument.Top.#XmlValue#.XmlAttributes.Bold") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#top_input_#_Italic_#top_line_#" id="#top_input_#_Italic_#top_line_#" onClick="document.execCommand('Italic');" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.Italic") and Evaluate("MyDocument.Top.#XmlValue#.XmlAttributes.Italic") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#top_input_#_Underline_#top_line_#" id="#top_input_#_Underline_#top_line_#" onClick="document.execCommand('Underline');" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.Underline") and Evaluate("MyDocument.Top.#XmlValue#.XmlAttributes.Underline") eq 1>checked="checked"</cfif>></td>						
											<td><input type="checkbox" name="#top_input_#_JustifyLeft_#top_line_#" id="#top_input_#_JustifyLeft_#top_line_#" onClick="document.execCommand('justifyleft');" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.JustifyLeft") and Evaluate("MyDocument.Top.#XmlValue#.XmlAttributes.JustifyLeft") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#top_input_#_JustifyCenter_#top_line_#" id="#top_input_#_JustifyCenter_#top_line_#" onClick="document.execCommand('justifycenter');" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.JustifyCenter") and Evaluate("MyDocument.Top.#XmlValue#.XmlAttributes.JustifyCenter") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#top_input_#_JustifyRight_#top_line_#" id="#top_input_#_JustifyRight_#top_line_#" onClick="document.execCommand('justifyright');" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlAttributes.JustifyRight") and Evaluate("MyDocument.Top.#XmlValue#.XmlAttributes.JustifyRight") eq 1>checked="checked"</cfif>></td>
										</tr>
									</table>
								</td>
								<td><input type="checkbox" name="#top_input_#_Check_#top_line_#" id="#top_input_#_Check_#top_line_#" onClick="add_to_appendchild(this,document.getElementById('#top_input_#_Width_#top_line_#').value,document.getElementById('#top_input_#_Height_#top_line_#').value,document.getElementById('#top_input_#_TopMargin_#top_line_#').value,document.getElementById('#top_input_#_LeftMargin_#top_line_#').value,document.getElementById('#top_input_#_FontType_#top_line_#').value,document.getElementById('#top_input_#_FontSize_#top_line_#').value,document.getElementById('#top_input_#_#top_line_#').value,'x');" value="#top_line_#" <cfif len(MyDocument) and IsDefined("MyDocument.Top.#XmlValue#.XmlText")>checked="checked"</cfif> /></td>
							</tr>
							</cfloop>
						</table>
						</div>
					</td>
				</tr>
				<!--- Orta Kısım --->
				<tr class="color-list">
					<td class="txtboldblue" height="20" colspan="2">
						<a href="javascript://" onClick="gizle_goster_img(document.getElementById('img5_prp'),document.getElementById('img6_prp'),_middle_properties_);"><img src="/images/listele.gif" border="0" align="absmiddle" id="img5_prp" style="display:;cursor:pointer;"></a>
						<a href="javascript://" onClick="gizle_goster_img(document.getElementById('img5_prp'),document.getElementById('img6_prp'),_middle_properties_);"><img src="/images/listele_down.gif" border="0" align="absmiddle" id="img6_prp" style="display:none;cursor:pointer;"></a>
						<a style="cursor:pointer;" onClick="gizle_goster_img(document.getElementById('img5_prp'),document.getElementById('img6_prp'),_middle_properties_);"><!---<cf_get_lang no='3153.Orta Kısım'>--->Orta Kısım<div id="mouse"></div></a>
					</td>
				</tr>
				<tr valign="top" id="_middle_properties_" class="color-row">
					<td colspan="2">
					<div style="position:relative;height:150px;z-index:88;overflow-y:auto; overflow-x: hidden">
					<table border="0">
						<cfset middle_line_ = 0>
						<cfset middle_input_ = "">
						<cfloop list="#list_middle_info#" index="y" delimiters=",">
						<cfset middle_line_ = middle_line_ + 1>
						<cfset middle_input_ = "y_#listfirst(trim(y),'-')#">
						<cfset XmlValue = listfirst(trim(y),'-')>
							<tr id="#middle_input_#">     
								<td><input type="text" name="#middle_input_#_#middle_line_#" id="#middle_input_#_#middle_line_#" onChange="design_div_position2(this,'value',#middle_line_#,'#middle_input_#','x');" value="<cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlText")>#Evaluate('MyDocument.Middle.#XmlValue#.XmlText')#<cfelse>#listlast(trim(y),'-')#</cfif>" style="width:50mm;"></td>										
								<td style="display:none">
									<table>
										<tr>
											<td><input type="text" name="#middle_input_#_FontType_#middle_line_#" id="#middle_input_#_FontType_#middle_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.FontType")>#Evaluate('MyDocument.Middle.#XmlValue#.XmlAttributes.FontType')#<cfelse>Arial</cfif>" style="width:7mm;"></td>
											<td><input type="text" name="#middle_input_#_FontSize_#middle_line_#" id="#middle_input_#_FontSize_#middle_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.FontSize")>#Evaluate('MyDocument.Middle.#XmlValue#.XmlAttributes.FontSize')#<cfelse>10</cfif>" style="width:7mm;"></td>										
											<td><input type="text" name="#middle_input_#_Width_#middle_line_#" id="#middle_input_#_Width_#middle_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.Width")>#Evaluate('MyDocument.Middle.#XmlValue#.XmlAttributes.Width')#<cfelse>50</cfif>" style="width:7mm;"></td>
											<td><input type="text" name="#middle_input_#_Height_#middle_line_#" id="#middle_input_#_Height_#middle_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.Height")>#Evaluate('MyDocument.Middle.#XmlValue#.XmlAttributes.Height')#<cfelse>50</cfif>" style="width:7mm;"></td>																		
											<td><input type="text" name="#middle_input_#_TopMargin_#middle_line_#" id="#middle_input_#_TopMargin_#middle_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.TopMargin")>#Evaluate('MyDocument.Middle.#XmlValue#.XmlAttributes.TopMargin')#<cfelse>100</cfif>" style="width:7mm;"></td>
											<td><input type="text" name="#middle_input_#_LeftMargin_#middle_line_#" id="#middle_input_#_LeftMargin_#middle_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.LeftMargin")>#Evaluate('MyDocument.Middle.#XmlValue#.XmlAttributes.LeftMargin')#<cfelse>5</cfif>" style="width:7mm;"></td>											
											<td><input type="checkbox" name="#middle_input_#_Bold_#middle_line_#" id="#middle_input_#_Bold_#middle_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.Bold") and Evaluate("MyDocument.Middle.#XmlValue#.XmlAttributes.Bold") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#middle_input_#_Italic_#middle_line_#" id="#middle_input_#_Italic_#middle_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.Italic") and Evaluate("MyDocument.Middle.#XmlValue#.XmlAttributes.Italic") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#middle_input_#_Underline_#middle_line_#" id="#middle_input_#_Underline_#middle_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.Underline") and Evaluate("MyDocument.Middle.#XmlValue#.XmlAttributes.Underline") eq 1>checked="checked"</cfif>></td>						
											<td><input type="checkbox" name="#middle_input_#_JustifyLeft_#middle_line_#" id="#middle_input_#_JustifyLeft_#middle_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.JustifyLeft") and Evaluate("MyDocument.Middle.#XmlValue#.XmlAttributes.JustifyLeft") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#middle_input_#_JustifyCenter_#middle_line_#" id="#middle_input_#_JustifyCenter_#middle_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.JustifyCenter") and Evaluate("MyDocument.Middle.#XmlValue#.XmlAttributes.JustifyCenter") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#middle_input_#_JustifyRight_#middle_line_#" id="#middle_input_#_JustifyRight_#middle_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlAttributes.JustifyRight") and Evaluate("MyDocument.Middle.#XmlValue#.XmlAttributes.JustifyRight") eq 1>checked="checked"</cfif>></td>
										</tr>
									</table>
								</td>
								<td><input type="checkbox" name="#middle_input_#_Check_#middle_line_#" id="#middle_input_#_Check_#middle_line_#" onClick="add_to_appendchild(this,document.getElementById('#middle_input_#_Width_#middle_line_#').value,document.getElementById('#middle_input_#_Height_#middle_line_#').value,document.getElementById('#middle_input_#_TopMargin_#middle_line_#').value,document.getElementById('#middle_input_#_LeftMargin_#middle_line_#').value,document.getElementById('#middle_input_#_FontType_#middle_line_#').value,document.getElementById('#middle_input_#_FontSize_#middle_line_#').value,document.getElementById('#middle_input_#_#middle_line_#').value,'y');" value="#middle_line_#" <cfif len(MyDocument) and IsDefined("MyDocument.Middle.#XmlValue#.XmlText")>checked="checked"</cfif> /></td>								
							</tr>
						</cfloop>
					</table>
					</div>
					</td>
				</tr>
				<!--- Alt Kısım --->
				<tr class="color-list">
					<td class="txtboldblue" height="20" colspan="2">
						<a href="javascript://" onClick="gizle_goster_img(document.getElementById('img7_prp'),document.getElementById('img8_prp'),_bottom_properties_);"><img src="/images/listele.gif" border="0" align="absmiddle" id="img7_prp" style="display:;cursor:pointer;"></a>
						<a href="javascript://" onClick="gizle_goster_img(document.getElementById('img7_prp'),document.getElementById('img8_prp'),_bottom_properties_);"><img src="/images/listele_down.gif" border="0" align="absmiddle" id="img8_prp" style="display:none;cursor:pointer;"></a>
						<a style="cursor:pointer;" onClick="gizle_goster_img(document.getElementById('img7_prp'),document.getElementById('img8_prp'),_bottom_properties_);"><!---<cf_get_lang no='3154.Alt Kısım'>--->Alt Kısım</a>
					</td>
				</tr>
				<tr  valign="top" id="_bottom_properties_" class="color-row">
					<td height="150" colspan="2">
					<table border="0">
						<tr align="center">
							<td>&nbsp;</td>						
							<td>&nbsp;</td>
						</tr>
						<cfset bottom_line_ = 0>
						<cfset bottom_input_ = "">
						<cfloop list="#list_bottom_info#" index="z" delimiters=",">
							<cfset bottom_line_ = bottom_line_ + 1>
							<cfset bottom_input_ = "z_#listfirst(trim(z),'-')#">
							<cfset XmlValue = listfirst(trim(z),'-')>
							<tr id="#bottom_input_#">
								<td><input type="text" name="#bottom_input_#_#bottom_line_#" id="#bottom_input_#_#bottom_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlText")>#Evaluate('MyDocument.Bottom.#XmlValue#.XmlText')#<cfelse>#listlast(trim(z),'-')#</cfif>" style="width:55mm;"></td>
								<td style="display:none">
									<table>
										<tr>
											<td><input type="text" name="#bottom_input_#_FontType_#bottom_line_#" id="#bottom_input_#_FontType_#bottom_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.FontType")>#Evaluate('MyDocument.Bottom.#XmlValue#.XmlAttributes.FontType')#<cfelse>Arial</cfif>" style="width:7mm;"></td>
											<td><input type="text" name="#bottom_input_#_FontSize_#bottom_line_#" id="#bottom_input_#_FontSize_#bottom_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.FontSize")>#Evaluate('MyDocument.Bottom.#XmlValue#.XmlAttributes.FontSize')#<cfelse>10</cfif>" style="width:7mm;"></td>
											<td><input type="text" name="#bottom_input_#_Width_#bottom_line_#" id="#bottom_input_#_Width_#bottom_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.Width")>#Evaluate('MyDocument.Bottom.#XmlValue#.XmlAttributes.Width')#<cfelse>50</cfif>"></td>
											<td><input type="text" name="#bottom_input_#_Height_#bottom_line_#" id="#bottom_input_#_Height_#bottom_line_#" value="<cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.Height")>#Evaluate('MyDocument.Bottom.#XmlValue#.XmlAttributes.Height')#<cfelse>50</cfif>"></td>											
											<td><input type="text" name="#bottom_input_#_TopMargin_#bottom_line_#" id="#bottom_input_#_TopMargin_#bottom_line_#" onChange="design_div_position(this,'top',#bottom_line_#,'#bottom_input_#','z');" value="<cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.TopMargin")>#Evaluate('MyDocument.Bottom.#XmlValue#.XmlAttributes.TopMargin')#<cfelse>200</cfif>" style="width:7mm;" onKeyUp="isNumber(this);" maxlength="3"></td>
											<td><input type="text" name="#bottom_input_#_LeftMargin_#bottom_line_#" id="#bottom_input_#_LeftMargin_#bottom_line_#" onChange="design_div_position(this,'left',#bottom_line_#,'#bottom_input_#','z');" value="<cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.LeftMargin")>#Evaluate('MyDocument.Bottom.#XmlValue#.XmlAttributes.LeftMargin')#<cfelse>5</cfif>" style="width:7mm;" onKeyUp="isNumber(this);" maxlength="3"></td>
											<td><input type="checkbox" name="#bottom_input_#_Bold_#bottom_line_#" id="#bottom_input_#_Bold_#bottom_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.Bold") and Evaluate("MyDocument.Bottom.#XmlValue#.XmlAttributes.Bold") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#bottom_input_#_Italic_#bottom_line_#" id="#bottom_input_#_Italic_#bottom_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.Italic") and Evaluate("MyDocument.Bottom.#XmlValue#.XmlAttributes.Italic") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#bottom_input_#_Underline_#bottom_line_#" id="#bottom_input_#_Underline_#bottom_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.Underline") and Evaluate("MyDocument.Bottom.#XmlValue#.XmlAttributes.Underline") eq 1>checked="checked"</cfif>></td>						
											<td><input type="checkbox" name="#bottom_input_#_JustifyLeft_#bottom_line_#" id="#bottom_input_#_JustifyLeft_#bottom_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.JustifyLeft") and Evaluate("MyDocument.Bottom.#XmlValue#.XmlAttributes.JustifyLeft") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#bottom_input_#_JustifyCenter_#bottom_line_#" id="#bottom_input_#_JustifyCenter_#bottom_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.JustifyCenter") and Evaluate("MyDocument.Bottom.#XmlValue#.XmlAttributes.JustifyCenter") eq 1>checked="checked"</cfif>></td>
											<td><input type="checkbox" name="#bottom_input_#_JustifyRight_#bottom_line_#" id="#bottom_input_#_JustifyRight_#bottom_line_#" value="1" <cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlAttributes.JustifyRight") and Evaluate("MyDocument.Bottom.#XmlValue#.XmlAttributes.JustifyRight") eq 1>checked="checked"</cfif>></td>
										</tr>
									</table>
								</td>
								<td><input type="checkbox" name="#bottom_input_#_Check_#bottom_line_#" id="#bottom_input_#_Check_#bottom_line_#" value="#bottom_line_#" onClick="add_to_appendchild(this,document.getElementById('#bottom_input_#_Width_#bottom_line_#').value,document.getElementById('#bottom_input_#_Height_#bottom_line_#').value,document.getElementById('#bottom_input_#_TopMargin_#bottom_line_#').value,document.getElementById('#bottom_input_#_LeftMargin_#bottom_line_#').value,document.getElementById('#bottom_input_#_FontType_#bottom_line_#').value,document.getElementById('#bottom_input_#_FontSize_#bottom_line_#').value,document.getElementById('#bottom_input_#_#bottom_line_#').value,'z');" <cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#XmlValue#.XmlText")>checked="checked"</cfif> /></td>
							</tr>
						</cfloop>
					</table>
					</td>
				</tr>
				<tr valign="top" class="color-list">
					<td colspan="2" align="right" style="text-align:right;">
						<cf_workcube_buttons is_upd='1' is_cancel='1' is_delete='1' delete_page_url="#request.self#?fuseaction=settings.design_paper&design_id=#attributes.design_id#&is_delete=1" insert_alert='' add_function='submit_control()'>
					</td>
				</tr>
			</table>
			</cfoutput>
			</td>
			<td align="center" width="650">
				<table align="left" style="font-size:10pt" width="650" border="0">
					<tr>
						<td width="25" valign="top" height="25">&nbsp;<input type="image" name="Bold" id="Bold" value="Bold" onClick="if (selected_div=='') return false;checkboxselection(this);<!---document.execCommand('Bold')--->apply_changes(selected_div);return false;" src="images/editor_images/Bold.gif"/></td>
						<td width="25" valign="top">&nbsp;<input type="image" name="Italic" id="Italic" value="Italic" onClick="if (selected_div=='') return false;checkboxselection(this);<!---document.execCommand('Italic');--->apply_changes(selected_div);return false;" src="images/editor_images/Italics.gif"/></td>
						<td width="25" valign="top">&nbsp;<input type="image" name="Underline" id="Underline" value="Underline" onClick="if (selected_div=='') return false;checkboxselection(this);<!---document.execCommand('Underline');--->apply_changes(selected_div);return false;" src="images/editor_images/underline.gif"/></td>
						<td width="25" valign="top">&nbsp;<input type="image" name="JustifyLeft" id="JustifyLeft" value="JustifyLeft" onClick="if (selected_div=='') return false;checkboxselection(this);<!---document.execCommand('justifyleft');--->apply_changes(selected_div); return false;" src="images/editor_images/left.gif" /></td>
						<td width="25" valign="top">&nbsp;<input type="image" name="JustifyCenter" id="JustifyCenter" value="JustifyCenter" onClick="if (selected_div=='') return false;checkboxselection(this);<!---document.execCommand('justifycenter');--->apply_changes(selected_div); return false;" src="images/editor_images/centre.gif" /></td>
						<td width="25" valign="top">&nbsp;<input type="image" name="JustifyRight" id="JustifyRight" value="JustifyRight" onClick="if (selected_div=='') return false;checkboxselection(this);<!---document.execCommand('justifyright');--->apply_changes(selected_div); return false;" src="images/editor_images/right.gif"/></td>
						<td width="125" valign="top">
							<select name="FontType" id="FontType" style="width:25mm;" onChange="if (selected_div=='') return false;checkboxselection(this);<!---document.execCommand('FontName',false,this.value);--->change_font_type(selected_div)">
								<option value="Arial" > Arial</option>
								<option value="Verdana" > Verdana</option>
								<option value="Geneva" > Geneva</option>
								<option value="Times New Roman" > Times New Roman</option>
								<option value="Courier New" > Courier New</option>
								<option value="Georgia" > Georgia</option>
							</select>
						</td>
						<td width="100" valign="top">
							<select name="FontSize" id="FontSize" style="width:15mm;" onChange="if (selected_div=='') return false;checkboxselection(this);<!---apply_changes(selected_div)--->change_font_size(selected_div)">
							<cfoutput>
								<cfloop from="8" to="36" index="_px_">
									<option value="#_px_#">#_px_# px</option>
								</cfloop>
							</cfoutput>
							</select>
						</td>
						<td width="90%" align="right" style="text-align:right;" valign="top"><cf_workcube_buttons is_upd='1' is_cancel='1' is_delete='1' delete_page_url="#request.self#?fuseaction=settings.design_paper&design_id=#attributes.design_id#&is_delete=1" insert_alert='' add_function='submit_control()'></td>
					</tr>
					<tr>
						<td colspan="10">
							<div id="main_div" style="left:280px;width:210mm;height:297mm; border:1px solid black;position:absolute;opacity:.50;filter: alpha(opacity=50);">
								<img id="template_img" name="template_img" src="\images\bar_white.gif" width="100%" height="100%" border="0" align="absmiddle">					
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
</table>
</cfform>
<!--- Sürükle Bırak --->
<script type="text/javascript">
function change_font_size(selected_div){

	var spltinnerHTML = document.getElementById(selected_div).innerHTML.split('>');
	var spltinnerHTML2 = spltinnerHTML[1].split('<');
	document.getElementById(selected_div).style.fontSize = document.getElementById("FontSize").value + 'px';
	document.getElementById(selected_div).innerHTML = '<p style="font-size:'+document.getElementById("FontSize").value+'px">'+spltinnerHTML2[0]+'</p>';
}

function change_font_type(selected_div){

	var spltinnerHTML = document.getElementById(selected_div).innerHTML.split('>');
	var spltinnerHTML2 = spltinnerHTML[1].split('<');
	document.getElementById(selected_div).style.fontFamily = document.getElementById("FontType").value;
	document.getElementById(selected_div).innerHTML = '<p style="font-family'+document.getElementById("FontType").value+'px">'+spltinnerHTML2[0]+'</p>';
}

function openPanel(obj){
	id = obj.id.substring(0,obj.id.length-5);
	document.getElementById(id+'_move').style.visibility = 'visible';
	document.getElementById(id+'_resize').style.visibility = 'visible';
}

function closePanel(obj){
	id = obj.id.substring(0,obj.id.length-5);
	document.getElementById(id+'_move').style.visibility = 'hidden';
	document.getElementById(id+'_resize').style.visibility = 'hidden';
}

function checkboxselection(obj)
{
	//Bold,Italic,Underline,JustifyLeft,JustifyCenter,JustifyRight
	fnSelect(selected_div);
	var spltArr = selected_div.split('_');
	if (obj.name == 'FontType')
	{
		id = spltArr[1]+'_'+spltArr[2]+'_FontType_'+spltArr[4];
		document.getElementById(id).value = obj.value;
		return;
	}
	else if (obj.name == 'FontSize')
	{
		id = spltArr[1]+'_'+spltArr[2]+'_FontSize_'+spltArr[4];
		document.getElementById(id).value = obj.value;
		return;	
	}
	
	if (obj.value=='JustifyLeft' || obj.value=='JustifyCenter' || obj.value=='JustifyRight')
	{
		var arr = ['JustifyLeft','JustifyCenter','JustifyRight'];
		for (var i=0;i<arr.length;i++)
		{
			id = spltArr[1]+'_'+spltArr[2]+'_'+arr[i]+'_'+spltArr[4];
			document.getElementById(id).checked = '';	
			document.getElementById(arr[i]).style.border = '';		
		}
	}
	

	id = spltArr[1]+'_'+spltArr[2]+'_'+obj.value+'_'+spltArr[4];
	nesne = document.getElementById(id);
	
	nesne.checked=!nesne.checked;
	
	if (nesne.checked == true)
		obj.style.border = 'solid 1px silver';
	else
		obj.style.border = '';
}

function apply_changes(selected_div)
{
//obj: bold,italic gibi imajları taşıyor
//selected_div: seçili olan divi getiriyor.
		var spltArr = selected_div.split('_');
		var arr = ['Bold','Italic','Underline','JustifyLeft','JustifyCenter','JustifyRight'];
		
		<!---alert(obj.checked);--->
		for (var i=0;i<arr.length;i++)
		{
			obj = document.getElementById(spltArr[1]+'_'+spltArr[2]+'_'+arr[i]+'_'+spltArr[4]);
			if(selected_div)
			{
				if(arr[i] == 'Bold' && obj.checked == true)
					document.getElementById(selected_div).style.fontWeight = 'bold';
				if(arr[i] == 'Bold' && obj.checked == false)
					document.getElementById(selected_div).style.fontWeight = 'normal';
				if(arr[i] == 'Italic' && obj.checked == true)
					document.getElementById(selected_div).style.fontStyle = 'italic';
				if(arr[i] == 'Italic' && obj.checked == false)
					document.getElementById(selected_div).style.fontStyle = 'normal';
				if(arr[i] == 'Underline' && obj.checked == true)
					document.getElementById(selected_div).style.textDecoration = 'underline';
				if(arr[i] == 'Underline' && obj.checked == false)
					document.getElementById(selected_div).style.textDecoration = 'none';
				if(arr[i] == 'JustifyLeft' && obj.checked == true)
					document.getElementById(selected_div).style.textAlign = 'left';	
				if(arr[i] == 'JustifyCenter' && obj.checked == true)
					document.getElementById(selected_div).style.textAlign = 'center';
				if(arr[i] == 'JustifyRight' && obj.checked == true)
					document.getElementById(selected_div).style.textAlign = 'right';
			}
		}		
}

function submit_control()
{
	if(document.getElementById('PrintDesignName').value == "")
	{
		alert("<cf_get_lang no='2691.Sayfa Adı Girmelisiniz'>");
		return false;
	}
	if(document.getElementById('PrintDesignType').value == "")
	{
		alert("<cf_get_lang no='2692.Sayfa Tipi Seçmelisiniz'>");
		return false;
	}
}

function page_style(_value_,property){
	if(property == 'width'){
		document.getElementById('main_div').style.width = _value_+'mm';
		document.getElementById('main_table').style.width = _value_+'mm';
	}	
	else if(property == 'height'){
		document.getElementById('main_div').style.height =  _value_+'mm';
		document.getElementById('main_table').style.height =parseInt(3+parseInt(_value_))+'mm';
	}	
}
//inputlardaki degisikliklerin divlere yansimasi islemi, tip gonderilerek tek yerden kontrol saglandi
function design_div_position(obj,type,row_count,input,part)
{

	if(row_count == 'all_TopMargin' || row_count == 'all_Height')
	{
		var little_length = document.getElementsByName('middle_objs').length;
		for(lind=0;lind<little_length;lind++){
			var xlind =lind+1; 
			var input = list_getat(document.getElementsByName('middle_objs')[lind].name,2,'_');
			if(document.getElementsByName('middle_objs')[lind].checked == true){
				if(row_count == 'all_Height')
					document.getElementById('div_y_'+input+'_Check_'+xlind).style.height = obj.value;
				if(row_count == 'all_TopMargin'){
					document.getElementById('div_y_'+input+'_Check_'+xlind).style.top = obj.value;
					document.getElementById('div_y_'+input+'_Check_'+xlind).onmousedown= function () {Drag.init(document.getElementById('y_'+input+'_Check_'+xlind), 15, 180,filterNum(obj.value),filterNum(obj.value))}
					Drag.init(document.getElementById('div_y_'+input+'_Check_'+xlind), 15, 180, filterNum(obj.value),filterNum(obj.value));
				}	
			}	
		}
	}
	else
	{
		if(document.getElementById('div_'+input+'_Check_'+row_count))
		{
			if(type=='width')
				document.getElementById('div_'+input+'_Check_'+row_count).style.width = obj.value;
			if(type=='height')
				document.getElementById('div_'+input+'_Check_'+row_count).style.height = obj.value;
			if(type=='top')
				document.getElementById('div_'+input+'_Check_'+row_count).style.top = obj.value;
			if(type=='left')
				document.getElementById('div_'+input+'_Check_'+row_count).style.left = obj.value;
			if(type=='value'){
				var tmp = document.getElementById('div_'+input+'_Check_'+row_count);
				var i=0;
				while(tmp.childNodes.length>0){
					tmp = tmp.childNodes[0];
				}
				tmp.parentNode.innerHTML = obj.value;	
			}
		}	
	}
}

//move
var Drag = {

	obj : null,
	init : function(o, minX, maxX, minY, maxY)
	{
		o = document.getElementById(o.id.substring(0,o.id.length-5)+'_main');
		o.onmousedown	= Drag.start;

		o.minX	= 0;
		o.minY	= -5;		
		o.maxX	= parseInt(document.getElementById('main_div').offsetWidth);
		o.maxY	= parseInt(document.getElementById('main_div').offsetHeight) - parseInt(o.offsetHeight)+20;
		
		o.onDragStart = new Function();
		o.onDragEnd = new Function();
		o.onDrag = new Function();		

	},

	start : function(e)
	{
		var o = Drag.obj = this;
		e = Drag.fixE(e);

		document.onmousemove = Drag.drag;
		document.onmouseup = Drag.end;
		
		o.maxX = document.getElementById('main_div').offsetWidth-50;
		o.maxY = document.getElementById('main_div').offsetHeight;
		
		return false;
	},

	drag : function(e)
	{

		e = Drag.fixE(e);
		var o = Drag.obj;

		var ey	= e.offsetY;
		var ex	= e.clientX;

		ex -= parseInt(document.getElementById('main_div').offsetLeft);
<!---		ey -= parseInt(document.getElementById('main_div').offsetTop) - document.body.scrollTop;--->
				
		ex = Math.max(ex, o.minX);
		ex = Math.min(ex, o.maxX);	
		ey = Math.max(ey, o.minY);
		ey = Math.min(ey, o.maxY);
		
		sayfaHareketi(o,false);

		document.getElementById(Drag.obj.id).style.left = ex;
		document.getElementById(Drag.obj.id).style.top = ey;
		
		return false;
	},

	end : function()
	{
		
		var arr = Drag.obj.id.split('_');
		check_obj_input = arr[1]+'_'+arr[2];
		check_obj_number = arr[4];
		
		document.getElementById(check_obj_input+'_LeftMargin_'+check_obj_number).value = filterNum(Drag.obj.style.left);
		document.getElementById(check_obj_input+'_TopMargin_'+check_obj_number).value = filterNum(Drag.obj.style.top);

		document.onmousemove = null;
		document.onmouseup   = null;
		
		Drag.obj.onDragEnd = null;		
		Drag.obj = null;
	},

	fixE : function(e)
	{
		if (typeof e == 'undefined') e = window.event;
		if (typeof e.layerX == 'undefined') e.layerX = e.offsetX;
		if (typeof e.layerY == 'undefined') e.layerY = e.offsetY;
		return e;
	}
};

var resizeDrag = {

	obj : null,
	lastX : 0,
	lastY : 0,
	divID : null,
	init : function(o)
	{
		o = document.getElementById(o.id.substring(0,o.id.length-7)+'_main');
		o.onmousedown	= resizeDrag.start;
	},

	start : function(e)
	{
		var o = resizeDrag.obj = this;
		e = resizeDrag.fixE(e);
		
		divID = resizeDrag.obj.id.substring(0,resizeDrag.obj.id.length-5);

		lastX = o.offsetLeft +  document.getElementById('main_div').offsetLeft;
		lastY = o.offsetTop +  document.getElementById('main_div').offsetTop + document.getElementById(divID+'_resize').offsetHeight;

				
		document.onmousemove = resizeDrag.drag;
		document.onmouseup = resizeDrag.end;

		return false;	

	},

	drag : function(e)
	{
		e = resizeDrag.fixE(e);
		var o = resizeDrag.obj;

		var ey	= e.offsetY;
		var ex	= e.clientX;

		ex -= lastX;
<!---		ey -= lastY + document.body.scrollTop;--->
		
		ex = Math.max(ex, 5);
		ey = Math.max(ey, 5);	
		
		//sayfaHareketi(o,ey);
		
		document.getElementById(divID).style.width = ex;
		document.getElementById(divID).style.height = ey ;
		document.getElementById(divID+'_resize').style.width = ex;
		document.getElementById(divID+'_resize').style.height = ey;
		
		return false;
	},

	end : function()
	{
		
		var arr = divID.split('_');
		check_obj_input = arr[1]+'_'+arr[2];
		check_obj_number = arr[4];
		
		w = document.getElementById(divID).style.width;
		h = document.getElementById(divID).style.height;
		
		document.getElementById(check_obj_input+'_Width_'+check_obj_number).value = filterNum(w);
		document.getElementById(check_obj_input+'_Height_'+check_obj_number).value = filterNum(h);

		document.onmousemove = null;
		document.onmouseup   = null;			
		
		resizeDrag.obj = null;
	},

	fixE : function(e)
	{
		if (typeof e == 'undefined') e = window.event;
		if (typeof e.layerX == 'undefined') e.layerX = e.offsetX;
		if (typeof e.layerY == 'undefined') e.layerY = e.offsetY;
		return e;
	}
};

function sayfaHareketi(o,resize){
	var sayfaUstSinir = document.body.scrollTop;
	var sayfaAltSinir = sayfaUstSinir + document.body.offsetHeight;
	var nesneUstSinir = o.offsetTop +  document.getElementById('main_div').offsetTop;
	var nesneAltSinir = nesneUstSinir + o.offsetHeight;

	if (nesneAltSinir > sayfaAltSinir)
		document.body.scrollTop += nesneAltSinir - sayfaAltSinir;
	else if (nesneUstSinir < sayfaUstSinir && resize == false)		
		document.body.scrollTop = nesneUstSinir;	
	else if (nesneAltSinir < sayfaUstSinir && resize)		
		document.body.scrollTop = nesneAltSinir-document.body.offsetHeight;		
}

</script>
<!--- //Sürükle Bırak --->
<script type="text/javascript">
	var selected_div ='';
	var selected_tr ='';
	var sayac = 0;
	var div = document.getElementById(selected_div+'_main');
	function div_control(){//yön tuşlarını kullanarak seçilen divi haraket ettirmek için yapıldı...
		//event.keyCode : 40 aşağı,39 sağ,37 sol,38 yukarı anlamına geliyor...
		//document.body.scrollTop -> o anki sayfanın üstten boyutu
		//document.body.scrollHeight -> tüm sayfa boyutu
		//document.body.offsetHeight -> per page	
		var div = document.getElementById(selected_div+'_main');
		if(selected_div != ""){//seçili olan bir div var ise..
		
			var sayfaUstSinir = document.body.scrollTop;
			var sayfaAltSinir = sayfaUstSinir + document.body.offsetHeight;
			var nesneUstSinir = div.offsetTop +  document.getElementById('main_div').offsetTop;
			var nesneAltSinir = nesneUstSinir + div.offsetHeight;
			
			if (nesneAltSinir > sayfaAltSinir){
				document.body.style.overflow='';
				document.body.scrollTop += nesneAltSinir - sayfaAltSinir;
			}
			else if (nesneUstSinir < sayfaUstSinir)	{	
				document.body.style.overflow='';
				document.body.scrollTop = nesneUstSinir;			
			}else
				document.body.style.overflow='hidden';
							
			var arr = selected_div.split('_');
			var part = arr[1];//x,y,z mi?
			var field_name = arr[2];
			var field_number = arr[4];
			var input_left = part+'_'+field_name+'_LeftMargin_'+field_number;
			var input_top = part+'_'+field_name+'_TopMargin_'+field_number;	
			if(event.keyCode == 37 || event.keyCode == 38 || event.keyCode == 39 || event.keyCode == 40)
			{				
				if(event.keyCode == 37){ //sol tusa basılıyorsa...					
					if(filterNum(div.style.left) > 5)
					{
						div.style.left = filterNum(div.style.left)- 2 + "px";
						document.getElementById(input_left).value = parseInt(filterNum(div.style.left)) - 2;
					}
				}else if(event.keyCode == 39){//sağ tusa basılıyorsa...		
					if(parseInt(filterNum(div.style.left)) < (795 - filterNum(div.style.width) - 10))
					{	
						div.style.left = parseInt(filterNum(div.style.left)) + 2 + "px";
						document.getElementById(input_left).value = parseInt(filterNum(div.style.left)) + 2;
					}
				}else if(event.keyCode == 40 && part != 'y'){ //asağı tusuna basılıyorsa...
					if(filterNum(div.style.top) < (1100 - filterNum(div.style.height) - 20))
					{
						div.style.top = parseInt(filterNum(div.style.top)) + 2 + "px";
						document.getElementById(input_top).value = parseInt(filterNum(div.style.top)) + 2;					
					}
				}else if(event.keyCode == 38 && part != 'y'){ //yukarı tusuna basılıyorsa...
					if(filterNum(div.style.top) > -10)
					{			
						div.style.top = filterNum(div.style.top) - 2 + "px";
						document.getElementById(input_top).value = parseInt(filterNum(div.style.top)) - 2;					
					}
				}
			return false;
			}		
		}
	}
	document.body.onkeydown = function () { div_control() };

	function select_div_border(div_id){
		var part = list_getat(div_id,2,'_');
		var tr_id = list_getat(div_id,3,'_');
		if(selected_div != ""){
			document.getElementById(selected_tr).style.backgroundColor ='';
			document.getElementById(selected_div).style.border = '1px solid black';
		}
		document.getElementById(part+'_'+tr_id).style.backgroundColor ='FF9933';	
		document.getElementById(div_id).style.border = '1px solid red';
		selected_div = div_id;
		selected_tr = part+'_'+tr_id;
		fnSelect(selected_div); 
		
		/////////////
		var spltArr = div_id.split('_');
		var arr = ['Bold','Italic','Underline','JustifyLeft','JustifyCenter','JustifyRight'];
		
		for (var i=0;i<arr.length;i++){
			editorObj = document.getElementById(arr[i]);
			obj = document.getElementById(spltArr[1]+'_'+spltArr[2]+'_'+arr[i]+'_'+spltArr[4]);
			if(obj != null)
			{
				if (obj.checked == true)
					editorObj.style.border = 'solid 1px silver';
				else
					editorObj.style.border = '';
			}
		}		
		
		
		/////////////
		fontObj = document.getElementById('FontType');
		sizeObj = document.getElementById('FontSize');	
		fontValue = document.getElementById(spltArr[1]+'_'+spltArr[2]+'_FontType_'+spltArr[4]).value;
		sizeValue = document.getElementById(spltArr[1]+'_'+spltArr[2]+'_FontSize_'+spltArr[4]).value;
				
		for (var i=0;i<fontObj.options.length;i++){
			if (fontObj.options[i].value == fontValue)
				fontObj.selectedIndex = i;
		}
		
		for (var i=0;i<sizeObj.options.length;i++){
			if (sizeObj.options[i].value == sizeValue)
				sizeObj.selectedIndex = i;
		}
	}
	
	var middle_top_value = 0;
	var middle_top_value_kontrol = 0;
	
	function add_to_appendchild(checked_status,width,height,top,left,fontType,fontSize,name,part)
	{	
		var div_content_name = name;					
		if(checked_status.checked==true)
		{
			sayac++;	
			div_name= 'div_'+checked_status.name;
			var mdiv = document.createElement('div');	
			
			if(part == 'y'){	
				middle_top_value_kontrol = middle_top_value_kontrol + 1;
				if(middle_top_value_kontrol > 1){
					top = middle_top_value;
					mdiv.style.top = top;
					}
				else{
					middle_top_value = top + "px";
					mdiv.style.top = middle_top_value;
					}
				}
			else
				{
					middle_top_value = top + "px";
					mdiv.style.top = middle_top_value;
				}
				
			mdiv.id = div_name + '_main';	
			mdiv.style.position = 'absolute';	
			mdiv.style.zIndex=999;			
			mdiv.style.left = left + "px"; //div sol margin													
			
			mdiv.style.width = width + "px"; //div genisligi		
			mdiv.style.height = height+ "px"; //div yuksekligi						
			mdiv.onmouseover = function () {openPanel(this)}		
			mdiv.onmouseout = function () {closePanel(this)}								
			var newdiv = document.createElement('div');						
			newdiv.setAttribute('id',div_name);			
			if(part == 'x')
				newdiv.style.backgroundColor = '#0099FF';
			else if(part == 'y')
				newdiv.style.backgroundColor = '#FF6600';			
			else
				newdiv.style.backgroundColor = '#CD5C5C';	
							
			//Bold,Italic,Underline,JustifyLeft,JustifyCenter,JustifyRight
			var spltArr = checked_status.name.split('_');			
<!---			var arr = [['Bold','<b>','</b>'],
				['Italic','<i>','</i>'],
				['Underline','<u>','</u>'],
				['JustifyLeft','<p align=left>','</p>'],
				['JustifyCenter','<p align=center>','</p>'],
				['JustifyRight','<p align=right>','</p>']
				];	--->	

			var j = 0;	

			var arr = ['Bold','Italic','Underline','JustifyLeft','JustifyCenter','JustifyRight'];
			
			<!---alert(obj.checked);--->
			for (var i = 0;i<arr.length;i++){			
				divObj = document.getElementById(spltArr[0]+'_'+spltArr[1]+'_'+arr[i]+'_'+spltArr[3]);	
				if(divObj != null)
				{			
<!---					if(divObj.checked==true)
					{--->
						newdiv.innerHTML = name;					
						if(arr[i] == 'Bold' && divObj.checked == true)
							newdiv.style.fontWeight = 'bold';
						if(arr[i] == 'Bold' && divObj.checked == false)
							newdiv.style.fontWeight = 'normal';
						if(arr[i] == 'Italic' && divObj.checked == true)
							newdiv.style.fontStyle = 'italic';
						if(arr[i] == 'Italic' && divObj.checked == false)
							newdiv.style.fontStyle = 'normal';
						if(arr[i] == 'Underline' && divObj.checked == true)
							newdiv.style.textDecoration = 'underline';
						if(arr[i] == 'Underline' && divObj.checked == false)
							newdiv.style.textDecoration = 'none';
						if(arr[i] == 'JustifyLeft' && divObj.checked == true)
							newdiv.style.textAlign = 'left';
						if(arr[i] == 'JustifyCenter' && divObj.checked == true)
							newdiv.style.textAlign = 'center';	
						if(arr[i] == 'JustifyRight' && divObj.checked == true)
							newdiv.style.textAlign = 'right';
				}
			}				
			
			newdiv.style.border = '1px solid black'; 
			newdiv.style.width = width + "px"; //div genisligi
			newdiv.style.height = height + "px"; //div yuksekligi
			newdiv.style.fontSize = fontSize + "px";
			newdiv.style.fontFamily = fontType;
<!---			if (j==0)
				newdiv.innerHTML = name;	--->					
			//newdiv.innerHTML = '<font face="'+fontType+'">'+newdiv.innerHTML+'</font>';
			newdiv.onclick = function () {select_div_border(newdiv.id);return false;}			
			newdiv.innerHTML = '<p style="font-size:'+fontSize+'px; font-family:'+fontType+';">'+name+'</p>';					
				
			newdiv.onmousedown = function () {return false;}
			newdiv.onmouseup = function () {return false;}
								
			var div1 = document.createElement('div');
			div1.style.width = width + "px";
			div1.id = div_name + '_move';
			div1.style.marginBottom = -2 +"px";
			div1.align = 'left';
				var a1 = document.createElement('a');
				a1.href = '#';	
				a1.innerHTML = '<img src="../../images/drag.gif" style="border:0px" />';
				a1.style.textDecoration = 'none';
				a1.onmousedown= function () {Drag.init(this.parentNode, 5, 180, 200, 600)}
				//a1.style.visibility='hidden';	
			div1.appendChild(a1);
			
			var div2 = document.createElement('div');
			div2.style.width = width + "px";
			div2.id = div_name + '_resize';		
			div2.align = 'right';
				var a2 = document.createElement('a');
				a2.href = '#';	
				a2.innerHTML = '<img src="../../images/resize.gif" style="border:0px" />';
				a2.style.textDecoration = 'none';
				a2.onmousedown= function () {resizeDrag.init(this.parentNode)}				
				//a2.style.visibility='hidden';						
				
			div2.appendChild(a2);			
			
			
			mdiv.appendChild(div1);
			mdiv.appendChild(newdiv);
			mdiv.appendChild(div2);					

			document.getElementById('main_div').appendChild(mdiv);			
			closePanel(mdiv);			
			
		}
		else{
			if(part == 'y')
				middle_top_value_kontrol = middle_top_value_kontrol - 1;						
			document.getElementById('main_div').removeChild(document.getElementById('div_'+checked_status.name+ '_main')); 
			}
		return;
	}
	
	function fnSelect(objId) {
		fnDeSelect();

		if (document.selection) {
		var range = document.body.createTextRange();
 	        range.moveToElementText(document.getElementById(objId));
		range.select();
		}
		else if (window.getSelection) {
		var range = document.createRange();
		range.selectNode(document.getElementById(objId));
		window.getSelection().addRange(range);
		}
	}
		
	function fnDeSelect() {
		if (document.selection) document.selection.empty(); 
		else if (window.getSelection)
                window.getSelection().removeAllRanges();
	}
	
	document.onclick = function(){
		document.body.style.overflow='';
	}
	
	window.onmousewheel = document.onmousewheel = function(){
		document.body.style.overflow='';
	}
</script>
<!--- Sayfa yuklendiginde divin kendiliginden calismasini saglayacak --->
<cfoutput>
<cfset top_line_ = 0>
<cfset top_input_ = "">
<cfloop list="#list_top_info#" index="x" delimiters=",">
	<cfset top_line_ = top_line_ + 1>
	<cfset top_input_ = "x_#listfirst(trim(x),'-')#">
	<cfif len(MyDocument) and IsDefined("MyDocument.Top.#listfirst(trim(x),'-')#.XmlText")>
		<script type="text/javascript">		
			add_to_appendchild(document.getElementById('#top_input_#_Check_#top_line_#'),document.getElementById('#top_input_#_Width_#top_line_#').value,document.getElementById('#top_input_#_Height_#top_line_#').value,document.getElementById('#top_input_#_TopMargin_#top_line_#').value,document.getElementById('#top_input_#_LeftMargin_#top_line_#').value,document.getElementById('#top_input_#_FontType_#top_line_#').value,document.getElementById('#top_input_#_FontSize_#top_line_#').value,document.getElementById('#top_input_#_#top_line_#').value,'x');
		</script>
	</cfif>
</cfloop>


<cfset middle_line_ = 0>
<cfset middle_input_ = "">
<cfloop list="#list_middle_info#" index="y" delimiters=",">
	<cfset middle_line_ = middle_line_ + 1>
	<cfset middle_input_ = "y_#listfirst(trim(y),'-')#">
	<cfif len(MyDocument) and IsDefined("MyDocument.Middle.#listfirst(trim(y),'-')#.XmlText")>
		<script type="text/javascript">	
			add_to_appendchild(document.getElementById('#middle_input_#_Check_#middle_line_#'),document.getElementById('#middle_input_#_Width_#middle_line_#').value,document.getElementById('#middle_input_#_Height_#middle_line_#').value,document.getElementById('#middle_input_#_TopMargin_#middle_line_#').value,document.getElementById('#middle_input_#_LeftMargin_#middle_line_#').value,document.getElementById('#middle_input_#_FontType_#middle_line_#').value,document.getElementById('#middle_input_#_FontSize_#middle_line_#').value,document.getElementById('#middle_input_#_#middle_line_#').value,'y');
		</script>
	</cfif>
</cfloop>

<cfset bottom_line_ = 0>
<cfset bottom_input_ = "">
<cfloop list="#list_bottom_info#" index="z" delimiters=",">
	<cfset bottom_line_ = bottom_line_ + 1>
	<cfset bottom_input_ = "z_#listfirst(trim(z),'-')#">
	<cfif len(MyDocument) and IsDefined("MyDocument.Bottom.#listfirst(trim(z),'-')#.XmlText")>
		<script type="text/javascript">
			add_to_appendchild(document.getElementById('#bottom_input_#_Check_#bottom_line_#'),document.getElementById('#bottom_input_#_Width_#bottom_line_#').value,document.getElementById('#bottom_input_#_Height_#bottom_line_#').value,document.getElementById('#bottom_input_#_TopMargin_#bottom_line_#').value,document.getElementById('#bottom_input_#_LeftMargin_#bottom_line_#').value,document.getElementById('#bottom_input_#_FontType_#bottom_line_#').value,document.getElementById('#bottom_input_#_FontSize_#bottom_line_#').value,document.getElementById('#bottom_input_#_#bottom_line_#').value,'z');
		</script>
	</cfif>
</cfloop>
</cfoutput>
<!--- //Sayfa yuklendiginde divin kendiliginden calismasini saglayacak --->


<script type="text/javascript">
var palette, color = ''; 
function setColor(c){ 
    eval(color+'="'+c+'"'); 
} 
function showPalette(el, prop){ 
    color = document.getElementById(selected_div).style.color; 
    palette.style.left = getObjX(el) + 57; 
    palette.style.top = getObjY(el); 
    palette.style.visibility = 'visible'; 
} 
function getObj(name) { 
    return (document.getElementById && document.getElementById(name))||document[name]||(document.all && document.all[name]); 
} 
function getObjX(el){ 
    var left = 0; 
    if(el.offsetParent){ 
        while(1){ 
            left += el.offsetLeft; 
            if(!el.offsetParent)break; 
            el = el.offsetParent; 
        } 
    }else if(el.x)left += el.x; 
    return left; 
} 

function getObjY(el){ 
    var top = 0; 
    if(el.offsetParent){ 
        while(1){ 
            top += el.offsetTop; 
            if(!el.offsetParent)break; 
            el = el.offsetParent; 
        } 
    }else if(el.y)top += el.y; 
    return top; 
} 
function init(){ 
    palette = getObj('palette'); 
	divPreview = Obj("divPreview"); 
} 
</script>
<script type="text/JavaScript"> 

var colours = new Array("#FFFFFF", "#FFCCCC", "#FFCC99", "#FFFF99", "#FFFFCC", "#99FF99", "#99FFFF", "#CCFFFF", "#CCCCFF", "#FFCCFF", "#CCCCCC", "#FF6666", "#FF9966", "#FFFF66", "#FFFF33", "#66FF99", "#33FFFF", "#66FFFF", "#9999FF", "#FF99FF", "#C0C0C0", "#FF0000", "#FF9900", "#FFCC66", "#FFFF00", "#33FF33", "#66CCCC", "#33CCFF", "#6666CC", "#CC66CC", "#999999", "#CC0000", "#FF6600", "#FFCC33", "#FFCC00", "#33CC00", "#00CCCC", "#3366FF", "#6633FF", "#CC33CC", "#666666", "#990000", "#CC6600", "#CC9933", "#999900", "#009900", "#339999", "#3333FF", "#6600CC", "#993399", "#333333", "#660000", "#993300", "#996633", "#666600", "#006600", "#336666", "#000099", "#333399", "#663366", "#000000", "#330000", "#663300", "#663333", "#333300", "#003300", "#003333", "#000066", "#330099", "#330033"); 
var divPreview; 
function mouseOver(el, Colour){ 
  divPreview.style.background = Colour; 
  document.frmColour.ColorHex.value = Colour; 
  el.style.borderColor = '#FFFFFF'; 
} 
function mouseOut(el){ 
  el.style.borderColor = '#666666'; 
} 
function mouseDown(Colour){ 
 setColor(Colour); 
 palette.style.visibility = 'hidden'; 
} 
function Obj(name) { 
    return document[name]||(document.all && document.all[name])||(document.getElementById && document.getElementById(name)); 
} 
</script>

<div name="palette" id="palette" style="position:absolute;visibility:hidden;width:150;height:115"> 
<table border=0 cellspacing=0 cellpadding=0 width="100%" height="100%"> 
<tr><td valign="middle" style="width:55px;height:25px;background:#FFFFFF;"> 
<center><div name="divPreview" id="divPreview" style="height:20px;width:50px;border:1px #000000 solid;"></div></center></td> 
<td bgcolor="#FFFFFF" valign="middle" style=""><form name="frmColour" style="padding:0px;margin:0px;"> 
<input readonly type="text" name="ColorHex" id="ColorHex" value="" size=10 style="width:80px;font-size: 12px"></form></td> 
  <td bgcolor="#FFFFFF"><img src="close.gif" onClick=" self.parent.palette.style.visibility = 'hidden';" width="13" height="13" border="0" alt="Close" title='Close Palette'></td> 
</tr> 
<tr><td style="width:100%" colspan="3" id="icerik"> 
</td></tr> 
</table>
</div>

<script type="text/javascript">
code = "<table class='tblPalette' cellpadding='0' cellspacing='1' border='0'>"; 
for (i = 0;i < 70; i++){ 
    if((i)%10 == 0)code += "<tr>"; 
    code += "<td id='el_"+i+"' bgcolor="+colours[i]+" onMouseOver=\"mouseOver(this, '"+colours[i]+"');\" onMouseOut='mouseOut(this)' onClick=\"mouseDown('"+colours[i]+"');\">&nbsp;</td>\n"; 
    if((i+1)%10 == 0)code += "</tr>\n"; 
} 
document.getElementById('icerik').innerHTML = code+"</table>"; 
 init();
 
bg_off = 1;
function show_hide_background()
{
	if(bg_off == 1)
		{
		img_ = '/documents/settings/<cfoutput>#get_design_paper_form.image_file#</cfoutput>'
		document.getElementById('main_div').style.backgroundImage= 'url('+img_+')';
		bg_off = 0;
		}
	else
		{
		document.getElementById('main_div').style.backgroundImage= '';
		bg_off = 1;
		}
}
</script>
