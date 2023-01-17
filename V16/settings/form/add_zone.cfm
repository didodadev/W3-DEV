<cf_get_lang_set module_name="settings">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_zone_add" method="post" name="zone_form">
			<cf_box_elements>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-zone_status">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57756.durum'></label>
						<div class="col col-8 col-xs-12"> 
							<label><input type="Checkbox" name="zone_status" id="zone_status" value="1" checked><cf_get_lang dictionary_id='57493.Aktif'></label> 
							<label><input type="Checkbox" name="is_organization" id="is_organization" value="1" checked><cf_get_lang dictionary_id='42936.Org Şemada Göster'></label>
						</div>
					</div>
					<div class="form-group" id="item-zone_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42529.Bölge Adı'>*</label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='42031.Bölge Adı girmelisiniz'></cfsavecontent>
							<cfinput required="Yes" message="#message#" type="Text" name="zone_name" id="zone_name" size="30" value="" maxlength="20">
						</div>
					</div>
					<div class="form-group" id="item-zone_detail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.açıklama'></label>
						<div class="col col-8 col-xs-12"> 
							<textarea name="zone_detail" id="zone_detail" style="width:150px;height:40px;"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-admin1_position">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'> 1</label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<input type="Hidden" name="admin1_position_code" id="admin1_position_code" value="">
								<input type="text" name="admin1_position" id="admin1_position"  value="">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=zone_form.admin1_position_code&field_name=zone_form.admin1_position');return false"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-admin2_position">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'> 2</label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<input type="Hidden" name="admin2_position_code" id="admin2_position_code" value="">
								<input type="text" name="admin2_position" id="admin2_position" value="">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=zone_form.admin2_position_code&field_name=zone_form.admin2_position');return false"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-zone_tel1">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42364.Tel Kod - Tel'>1</label>
						<div class="col col-2 col-xs-12"> 
							<input type="Text" name="zone_telcode" id="zone_telcode" size="10" value="" maxlength="10" onkeyup="isNumber(this);">
						</div>
						<div class="col col-6 col-xs-12"> 
							<input type="Text" name="zone_tel1" id="zone_tel1" size="10" value="" maxlength="10" onkeyup="isNumber(this);">
						</div>
					</div>
					<div class="form-group" id="item-zone_tel2">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 2</label>
						<div class="col col-8 col-xs-12"> 
							<input type="Text" name="zone_tel2" id="zone_tel2" size="10" value="" maxlength="10" onkeyup="isNumber(this);">
						</div>
					</div>
					<div class="form-group" id="item-zone_tel3">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57499.Telefon'> 3</label>
						<div class="col col-8 col-xs-12"> 
							<input type="Text" name="zone_tel3" id="zone_tel3"  value="" maxlength="10" onkeyup="isNumber(this);">
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-zone_fax">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57488.Faks'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="Text" name="zone_fax" id="zone_fax"  value="" maxlength="10" onkeyup="isNumber(this);">
						</div>
					</div>	
					<div class="form-group" id="item-zone_email">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-mail'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="Text" name="zone_email" id="zone_email" size="60" value="" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-zone_address">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
						<div class="col col-8 col-xs-12"> 
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
							<textarea name="zone_address" id="zone_address" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:150px;height:40px;"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-postcode">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="Text" name="postcode" id="postcode" size="6" value="" maxlength="5" onkeyup="isNumber(this);">
						</div>
					</div>
					<div class="form-group" id="item-county">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="Text" name="county" id="county" size="30" value="" maxlength="20">
						</div>
					</div>
					<div class="form-group" id="item-City">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57971.Şehir'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="Text" name="City" id="City" size="30" value="" maxlength="20">
						</div>
					</div>
					<div class="form-group" id="item-country">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="Text" name="country" id="country"  value="" maxlength="30">
						</div>
					</div>
					<div class="form-group" id="item-hierarchy">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57761.Hiyerarşi'></label>
						<div class="col col-8 col-xs-12"> 
							<input type="Text" name="hierarchy" id="hierarchy" value="" maxlength="75">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format="1" is_upd='0'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<cf_get_lang_set module_name="#fusebox.circuit#">
