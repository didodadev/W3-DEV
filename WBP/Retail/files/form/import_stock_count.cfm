<cf_get_lang_set module_name="objects">
<cf_papers paper_type="STOCK_FIS">
<cf_popup_box title='#lang_array.item [515]#'>
	<cfform name="form_basket" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=retail.popup_add_import_stock_count_display">
	<input  type="hidden" name="html_file" id="html_file" value="<cfoutput>#createUUID()#</cfoutput>.html"> 
		<table>
			<tr>
				<td style="width:120px;"><cf_get_lang no ='1499.Belge Ayracı'></td>
				<td style="width:220px;">
                	<select name="seperator_type" id="seperator_type" style="width:200px;">
						<option value="59"><cf_get_lang no ='484.Noktalı Virgül'></option>
						<option value="44"><cf_get_lang no ='483.Virgül'></option>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no ='221.Barkod'> / <cf_get_lang_main no='106.Stok Kodu'> /<cf_get_lang_main no='377.Özel Kod'></td>
				<td><select name="stock_identity_type" id="stock_identity_type" style="width:200px;">
						<option value="1" selected><cf_get_lang_main no ='221.Barkod'></option>
						<option value="2"><cf_get_lang_main no='106.Stok Kodu'></option>
						<option value="3"><cf_get_lang_main no='377.Özel Kod'></option>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no ='56.Belge'> *</td>
				<td><input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;"></td>
			</tr>
			<tr nowrap="nowrap">
				<td><cf_get_lang_main no='1351.Depo'> / <cf_get_lang_main no ='2234.Lokasyon'> *</td>
				<td><cf_wrkdepartmentlocation
					returnInputValue="location_id,store,department_id,branch_id"
					returnInputQuery="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
					fieldName="store"
					fieldid="location_id"
					department_fldId="department_id"
					user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
					width="200">
				</td>
			</tr>
			<td>Kategori</td>
			<td>
				<input type="hidden" name="product_catid" id="product_catid" value="">
				<input type="text" name="product_cat" id="product_cat" value="" style="width:200px;">
				<a href="javascript://"onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=product_catid&field_name=form_basket.product_cat','list');"><img src="/images/plus_thin.gif" border="0" title="<cf_get_lang no='146.Ürün Kategorisi Ekle'>!" align="absbottom"></a>
			</td>
			<tr>
				<td>Sayım Tipi</td>
				<td>
					<select name="file_type" id="file_type" style="width:200px;">
						<option value="1">1.Sayım</option>
						<option value="2">2.Sayım</option>
						<option value="3">Fark Sayımı</option>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no ='330.Tarih'> *</td>
				<td><cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'> !</cfsavecontent>
					<cfinput type="text" name="process_date" value="" validate="eurodate" required="yes" message="#message#" maxlength="10" style="width:65px;">
					<cf_wrk_date_image date_field="process_date">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no ='1500.Ek Alan'>1</td>
				<td><select name="add_file_format_1" id="add_file_format_1" style="width:200px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						<option value="SPECT_MAIN_ID"><cf_get_lang no ='1900.Spect Main Id'></option>
						<option value="SHELF_CODE"><cf_get_lang no ='1501.RAF'></option>
						<option value="DELIVER_DATE"><cf_get_lang no ='1502.SON KULLANMA TARİHİ'></option>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no ='1500.Ek Alan'>2</td>
				<td><select name="add_file_format_2" id="add_file_format_2" style="width:200px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						<option value="SPECT_MAIN_ID"><cf_get_lang no ='1900.Spect Main Id'></option>
						<option value="SHELF_CODE"><cf_get_lang no ='1501.RAF'></option>
						<option value="DELIVER_DATE"><cf_get_lang no ='1502.SON KULLANMA TARİHİ'></option>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no ='1500.Ek Alan'>3</td>
				<td><select name="add_file_format_3" id="add_file_format_3" style="width:200px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						<option value="SPECT_MAIN_ID"><cf_get_lang no ='1900.Spect Main Id'></option>
						<option value="SHELF_CODE"><cf_get_lang no ='1501.RAF'></option>
						<option value="DELIVER_DATE"><cf_get_lang no ='1502.SON KULLANMA TARİHİ'></option>
					</select>
				</td>
			</tr>
		</table>
		<table>
			<tr>
				<td colspan="2">
					<strong><cf_get_lang no='1901.Devir sayım import işleminde dosya formatı aşağıdaki gibi olmalıdır'>;</strong><br/>
					<cf_get_lang no='1902.Aktarım tipi ( stok kodu, barkod ya da özel kod ) ; Miktar ; Raf  Kodu ( Stok alan yönetiminde raflar listesindeki raf kodu bilgisi ) ; son kullanma tarihi ; main spec ID'> <br/>
					<cf_get_lang no='1903.(Raf, son kullanma tarihi ve main spec ID alanları ek alan olarak tanımlanmıştır Bu alanların hepsinin belgede olması zorunlu değildir ve bu alanlar için belge sıralaması yoktur'> <cf_get_lang no='7.Sadece raf kodu ya da sadece son kullanma tarihi  veya her ikiside belgede olabilir Ek alan kısımlarından seçilme sırasına göre belgeye eklenmelidir)'> <br/>
					<strong><cf_get_lang_main no='1555.Örnek'>;</strong><br/>
					01.01.01.1445;100;75;31/12/2007<br/>
					2110000000059;555;10<br/>
					150;850<br/>
					01.01.01.1445;100;31/12/2007<br/>
					300;500;18<br/>
				</td>
			</tr>
		</table>
		<cf_popup_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">