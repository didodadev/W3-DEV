<cfparam name="attributes.price_catid" default="">

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
	<tr>
		<td class="headbold"><cf_get_lang no='415.Ürün XML Oluştur'></td>
  	</tr>
</table>
<table cellpadding="2" border="0" width="98%" cellspacing="1" class="color-border" align="center">
	<tr class="color-row">
		<td>
		<cfform name="add_xml" action="#request.self#?fuseaction=objects2.emptypopup_add_product_xml" method="post">
			<table>
				<cfif isdefined("session.ep")>
                    <cfquery name="GET_PRICE_CAT" datasource="#DSN3#">
                        SELECT
                            PRICE_CATID,
                            PRICE_CAT
                        FROM
                            PRICE_CAT
                            <cfif isDefined("attributes.pcat_id") and len(attributes.pcat_id)>
                                WHERE
                                    PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcat_id#">
                            </cfif>
                        ORDER BY
                            PRICE_CAT
                    </cfquery>
					<tr>
						<td><cf_get_lang_main no='1552.Fiyat Listesi'></td>
						<td>
							<select name="price_catid" id="price_catid">
								<option value="-1" selected><cf_get_lang_main no='1310.Standart Alış'></option>
								<option value="-2"><cf_get_lang_main no='1309.Standart Satış'></option>
								<cfoutput query="get_price_cat">
	                                <option value="#price_catid#"<cfif (price_catid is attributes.price_catid)> selected</cfif>>#price_cat#</option>
                                </cfoutput>
							</select>
						</td>
					</tr>
				<cfelseif isdefined("session.pp")>
					<cfquery name="GET_PRICE_CAT" datasource="#DSN#">
						SELECT 
                        	PRICE_CAT 
                        FROM 
                        	COMPANY_CREDIT 
                        WHERE 
                        	COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND 
                            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
					</cfquery>
					<cfif get_price_cat.recordcount  and len(get_price_cat.price_cat)>
						<select name="price_catid" id="price_catid" style="display:none;">
							<option value="<cfoutput>#get_price_cat.price_cat#</cfoutput>" selected><cfoutput>#get_price_cat.price_cat#</cfoutput></option>
						</select>
					<cfelse>
						<cfquery name="GET_COMP_CAT" datasource="#dsn#">
							SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
						</cfquery>
						<cfquery name="GET_PRICE_CAT_COMP" datasource="#dsn3#">
							SELECT
								PRICE_CATID
							FROM
								PRICE_CAT
							WHERE
								COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#GET_COMP_CAT.COMPANYCAT_ID#,%">
						</cfquery>
						<cfif get_price_cat_comp.recordcount and len(get_price_cat_comp.price_catid)>
							<select name="price_catid" id="price_catid" style="display:none;">
								<option value="<cfoutput>#get_price_cat_comp.price_catid#</cfoutput>" selected><cfoutput>#get_price_cat_comp.price_catid#</cfoutput></option>
							</select>
						<cfelse>
							<select name="price_catid" id="price_catid" style="display:none;">
								<option value="-2" selected>-2</option>
							</select>
						</cfif>
					</cfif>
					<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#session.pp.company_id#</cfoutput>">
				</cfif>
				<tr>
					<td></td><td><input type="radio" name="is_xml" id="is_xml" value="is_image_xml"><a href="javascript:gizle_goster(detail1);" class="tableyazi" title="XML İçeriğini Göster"><cf_get_lang no ='1084.İmajlı Ürün Getir'></a></td>
				</tr>
				<tr style="display:none" id="detail1">
			    	<td></td>
			    	<td align="center"><font color="#FF0000"><cf_get_lang no ='1087.XML Data Set İçeriği'></font></td>
			    	<td align="left">
						<b>ITEM_CODE=<cf_get_lang_main no ='106.Stok Kodu'><br/>
						<b>IMAGE_URL=<cf_get_lang no ='1091.Ürün İmajının Serverdaki Yolu'>
					</td>
				</tr>
				<tr>
					<td></td><td><input type="radio" name="is_xml" id="is_xml" value="is_property_xml"><a href="javascript:gizle_goster(detail2);" class="tableyazi" title="XML İçeriğini Göster"><cf_get_lang no ='1085.Özellikli ve Fiyatlı Ürün Getir'></a></td>
				</tr>
				<tr style="display:none" id="detail2">
				   	<td></td>
					<td align="center"><font color="#FF0000">XML Data Set İçeriği</font></td>
					<td align="left">
					   <b>ITEM_CODE=Stok Kodu<br/>
					   <b>ITEM_DESC=Ürün Adı<br/>
					   <b>COMMODITY_CODE=Ürünün Markası<br/>
					   <b>SKU_CODE=Ürünün Kategorisi<br/>
					   <b>QTY=Ürünün Stok Durumu<br/>
					   <b>PRICE=Ürünün Size Özel Fiyatı<br/>
					   <b>USER_PRICE=Ürünün Son Kullanıcı Fiyatı<br/>
					   <b>CURRENCY_CODE=Ürünün Fiyat Para Birimi<br/>
					   <b>IN_USE=Ürünün Satışta Olma Durumu<br/>
					   <b>TITLE=Ürün Özellik<br/>
					   <b>DESC=Ürün Özellik Açıklaması<br/>
					</td>
				</tr>
				<tr>
					<td></td><td><input type="radio" name="is_xml" id="is_xml" value="is_cost_xml"><a href="javascript:gizle_goster(detail3);" class="tableyazi" title="XML İçeriğini Göster"><cf_get_lang no ='1086.Fiyatlı Ürün Getir'></a></td>
				</tr>
				<tr style="display:none" id="detail3">
				   	<td></td>
					<td align="center"><font color="#FF0000"><cf_get_lang no ='1087.XML Data Set İçeriği'></font></td>
					<td align="left">
					   <b>ITEM_CODE=Stok Kodu<br/>
					   <b>ITEM_DESC=Ürün Adı<br/>
					   <b>COMMODITY_CODE=Ürünün Markası<br/>
					   <b>SKU_CODE=Ürünün Kategorisi<br/>
					   <b>QTY=Ürünün Stok Durumu<br/>
					   <b>PRICE=Ürünün Size Özel Fiyatı<br/>
					   <b>USER_PRICE=Ürünün Son Kullanıcı Fiyatı<br/>
					   <b>CURRENCY_CODE=Ürünün Fiyat Para Birimi<br/>
					   <b>IN_USE=Ürünün Satışta Olma Durumu<br/>
				   <td>
				</tr>
				<tr>
					<td></td><td><input type="radio" name="is_xml" id="is_xml" value="is_product_xml"><a href="javascript:gizle_goster(detail4);" class="tableyazi" title="XML İçeriğini Göster"><cf_get_lang no ='1089.Ürünleri Getir'></a></td>
				</tr>
				<tr style="display:none" id="detail4">
				   	<td></td>
					<td align="center"><font color="#FF0000"><cf_get_lang no ='1087.XML Data Set İçeriği'></font></td>
					<td align="left">
						<b>UrunID=Urun ID<br/>
						StokID=Stok ID<br/>
 						UrunAdi=Ürün Adı<br/>
						StokAdedi=Stok Bilgisi adet olarak<br/>
 						OzelFiyat=Ürünün bayinin kendisine özel fiyatı (KDV Hariç Fiyat)<br/>
 						ListeFiyat=Ürünün standart liste satış fiyatı (KDV Hariç Fiyat)<br/>
 						SonKullaniciFiyat=Bayiye satış için önerdiğimiz fiyat (KDV Hariç Fiyat)<br/>
 						Kur=Ürünün satış kuru YTL, USD, EURO, STERLIN, CHF<br/>
 						KDV=Kdv Oranı<br/>
 						KategoriAdi=Kategori Adı<br/>
 						EanCode=Ürün Üretici EAN Kodu<br/>
						Marka=Ürünün Markası<br/>
 						StokGelisTarih=Stokta bulunmuyorsa stoğa geliş tarihi<br/>
 						ImageName1=Ürün Resim ismi.<br/>
 						ImageName2=Ürün Resim ismi (birden fazla resim varsa)<br/>
						ImageName3=Ürün Resim ismi (birden fazla resim varsa)<br/>
 						ImageName4=Ürün Resim ismi (birden fazla resim varsa)<br/>
 						ImageName5=Ürün Resim ismi (birden fazla resim varsa)<br/>
 						UrunAciklamasi=Ürün için açıklama metni<br/>
 						Desi=Ürünün desi (ağırlık,hacim) bilgisi<br/>
 						TedarikSuresi=Ürünün önerilen tedarik süresi.<br/>
 						Garanti=Garanti süresi ay olarak<br/>
 						GarantiAciklama=Garanti bilgisine ek olarak gönderilecek açıklama bilgisi<br/></b>
				   <td>
				</tr>
				<tr>
					<td></td><td><input type="radio" name="is_xml" id="is_xml" value="is_detail_product_xml"><a href="javascript:gizle_goster(detail5);" class="tableyazi" title="XML İçeriğini Göster"><cf_get_lang no ='1088.Detaylı Ürünleri Getir'></a></td>
				</tr>
				<tr style="display:none" id="detail5">
				   	<td></td>
					<td align="center"><font color="#FF0000"><cf_get_lang no ='1087.XML Data Set İçeriği'></font></td>
					<td align="left">
						<b>UrunID=Urun ID<br/>
						StokID=Stok ID<br/>
 						UrunAdi=Ürün Adı<br/>
						StokAdedi=Stok Bilgisi adet olarak<br/>
 						OzelFiyat=Ürünün bayinin kendisine özel fiyatı (KDV Hariç Fiyat)<br/>
 						ListeFiyat=Ürünün standart liste satış fiyatı (KDV Hariç Fiyat)<br/>
 						SonKullaniciFiyat=Bayiye satış için önerdiğimiz fiyat (KDV Hariç Fiyat)<br/>
 						Kur=Ürünün satış kuru YTL, USD, EURO, STERLIN, CHF<br/>
 						KDV=Kdv Oranı<br/>
 						KategoriAdi=Kategori Adı<br/>
 						EanCode=Ürün Üretici EAN Kodu<br/>
						Marka=Ürünün Markası<br/>
 						StokGelisTarih=Stokta bulunmuyorsa stoğa geliş tarihi<br/>
 						ImageName1=Ürün Resim ismi.<br/>
 						ImageName2=Ürün Resim ismi (birden fazla resim varsa)<br/>
						ImageName3=Ürün Resim ismi (birden fazla resim varsa)<br/>
 						ImageName4=Ürün Resim ismi (birden fazla resim varsa)<br/>
 						ImageName5=Ürün Resim ismi (birden fazla resim varsa)<br/>
						ContentID1=Ürünle ilişkili 1. içerik idsi<br/>
						ContentHead1=Ürünle ilişkili 1. içerik başlığı<br/>
						ContentSummary1=Ürünle ilişkili 1. içerik özeti<br/>
						ContentBody1=Ürünle ilişkili 1. içerik detayı<br/>
						ContentID2=Ürünle ilişkili 2. içerik idsi<br/>
						ContentHead2=Ürünle ilişkili 2. içerik başlığı<br/>
						ContentSummary2=Ürünle ilişkili 2. içerik özeti<br/>
						ContentBody2=Ürünle ilişkili 2. içerik detayı<br/>
						ContentID3=Ürünle ilişkili 3. içerik idsi<br/>
						ContentHead3=Ürünle ilişkili 3. içerik başlığı<br/>
						ContentSummary3=Ürünle ilişkili 3. içerik özeti<br/>
						ContentBody3=Ürünle ilişkili 3. içerik detayı<br/>
						ContentID4=Ürünle ilişkili 4. içerik idsi<br/>
						ContentHead4=Ürünle ilişkili 4. içerik başlığı<br/>
						ContentSummary4=Ürünle ilişkili 4. içerik özeti<br/>
						ContentBody4=Ürünle ilişkili 4. içerik detayı<br/>
						ContentID5=Ürünle ilişkili 5. içerik idsi<br/>
						ContentHead5=Ürünle ilişkili 5. içerik başlığı<br/>
						ContentSummary5=Ürünle ilişkili 5. içerik özeti<br/>
						ContentBody5=Ürünle ilişkili 5. içerik detayı<br/>
 						UrunAciklamasi=Ürün için açıklama metni<br/>
 						Desi=Ürünün desi (ağırlık,hacim) bilgisi<br/>
						Birim=Ana Birim Bilgisi (adet,kg)<br/>
 						TedarikSuresi=Ürünün önerilen tedarik süresi.<br/>
 						Garanti=Garanti süresi ay olarak<br/>
 						GarantiAciklama=Garanti bilgisine ek olarak gönderilecek açıklama bilgisi<br/>
						AssetName1=Ürünle ilişkili 1. varlık adı<br/>
						AssetFile1=Ürünle ilişkili 1. varlık yolu<br/>
						AssetName2=Ürünle ilişkili 2. varlık adı<br/>
						AssetFile2=Ürünle ilişkili 2. varlık yolu<br/>
						AssetName3=Ürünle ilişkili 3. varlık adı<br/>
						AssetFile3=Ürünle ilişkili 3. varlık yolu<br/>
						AssetName4=Ürünle ilişkili 4. varlık adı<br/>
						AssetFile4=Ürünle ilişkili 4. varlık yolu<br/>
						AssetName5=Ürünle ilişkili 5. varlık adı<br/>
						AssetFile5=Ürünle ilişkili 5. varlık yolu<br/>
						</b>
				   <td>
				</tr>
				<tr>
					<td></td>
					<td <cfif isdefined("session.pp")>width="200" style="text-align:right;"</cfif>>
						<cfsavecontent variable="message"><cf_get_lang no ='1090.XML Oluştur'></cfsavecontent>
						<cf_workcube_buttons is_upd='0' is_cancel='0' add_function='control()' insert_alert='' insert_info='#message#'>
					</td>
				</tr>
			</table>
		</cfform>
		</td>
	</tr>
</table>

<script>
	function control()
	{
		var selctd = 0;
		for(var k=0;k<document.add_xml.is_xml.length;k++)
			if(document.add_xml.is_xml[k].checked == true) var selctd = 1;
		if(selctd == 0)
		{
			alert("Lütfen bir xml çeşidi seçiniz!");
			return false;
		}
	}
</script>
