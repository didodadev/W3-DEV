<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="formexport" method="post" action="#request.self#?fuseaction=retail.emptypopup_export_terazi">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-product_recorddate">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='32867.Ürün Kayıt Tarihi Girmelisiniz'></cfsavecontent>
								<cfinput type="text" message="#message#" validate="eurodate" name="product_recorddate" maxlength="10" style="width:100px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="product_recorddate"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-price_cat_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
						<div class="col col-8 col-sm-12">
							<select name="price_cat_id" id="price_cat_id" style="width:255px;">
								<option value="-3"><cf_get_lang dictionary_id='61881.Şube Tanımlı Fiyat'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-product_code">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
						<div class="col col-8 col-sm-12">
							<div class="input-group">
								<input type="hidden" name="product_code" id="product_code" value="">
								<cfinput type="text" name="product_cat" value="" passthrough="readonly=yes" style="width:255px;">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&field_code=formexport.product_code&field_name=formexport.product_cat&is_sub_category=1</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="middle"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-file_name">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29800.Dosya Adı'></label>
						<div class="col col-4 col-sm-12">
							<cfsavecontent variable="message"><cf_get_lang no='684.Dosya girmelisiniz'></cfsavecontent>
							<cfinput type="text" name="file_name" value="sube_terazi_dosyasi" required="yes" message="#message#" style="width:150px;">
						</div>
						<div class="col col-4 col-sm-12">
							<select name="ext" id="ext" style="width:102px;">
								<option value="-2"><cf_get_lang dictionary_id='61882.Bizerba.dat'></option>
							</select>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer><cf_workcube_buttons is_upd='0'></cf_box_footer>
		</cfform>
	</cf_box>
</div>
