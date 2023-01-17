<div class="col col-12 col-md-12 col-sm-12 col-xs-12" id="add_asset_it">
	<cfform action="#request.self#?fuseaction=assetcare.emptypopup_addit_assetp&assetp_id=#asset_id#" method="post" name="add_asset_care">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<cf_duxi name='username' class="tableyazi" type="text" value="" label="57930" gdpr="10">
				<div class="form-group" id="item-pass">
					<cf_duxi name='label_pass' class="col col-4 col-md-4 col-sm-4 col-xs-12" type="label_gdpr"  label="57552" gdpr="10">
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cf_duxi name='password' class="tableyazi" type="text" value="">
					</div>
				</div>
				<div class="form-group" id="item-number_of_users">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46464.Öngörülen'><cf_get_lang dictionary_id='59913.Kullanıcı Sayısı'></label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="number_of_users" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-it_pro">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47914.İşlemci'></label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="it_pro" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-it_memory">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47916.Bellek'></label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="it_memory" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-it_hdd">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47735.Hard Disk'></label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="it_hdd" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-it_con">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47918.Konfigürasyon'></label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="it_con" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-it_ip">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32421.IP'></label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="asset_ip" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-it_mac_ip">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63457.MAC'><cf_get_lang dictionary_id='32421.IP'></label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="asset_mac_ip" maxlength="100">
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">
				<div class="form-group" id="item-it_property1">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47915.Ek Özellik'> 1</label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="it_property1" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-it_property2">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47915.Ek Özellik'> 2</label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="it_property2" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-it_property3">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47915.Ek Özellik'> 3</label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="it_property3" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-it_property4">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47915.Ek Özellik'> 4</label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="it_property4" maxlength="100">
					</div>
				</div>
				<div class="form-group" id="item-it_property5">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47915.Ek Özellik'> 5</label>
					<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
						<cfinput type="text" value="" name="it_property5" maxlength="100">
					</div>
				</div>
				
			</div>
		</cf_box_elements>
		<cf_box_footer><cf_workcube_buttons type_format='1' is_upd='0'add_function="add_kontrol_it()">
			<div style="float:left;" id="show_user_message1"></div>
		</cf_box_footer>
	</cfform>
</div>
<script>
	function add_kontrol_it() {
		<cfoutput>
			AjaxFormSubmit('add_asset_care','show_user_message1',0,'&nbsp;Kaydediyor','&nbsp;Kaydedildi','#request.self#?fuseaction=assetcare.popup_add_it_asset&asset_id=#asset_id#','div_list_it_asset');
			AjaxPageLoad('#request.self#?fuseaction=assetcare.popup_upd_it_asset&asset_id=#asset_id#','add_asset_it',1);
		</cfoutput>
	}
</script>