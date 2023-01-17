<div id="asset_it_">

	<cfquery name="get_info_asset" datasource="#dsn#">
		SELECT 
			IT_ID, 
			ASSETP_ID, 
			IT_PRO, 
			IT_MEMORY, 
			IT_HDD, 
			IT_CON, 
			IT_PROPERTY1, 
			IT_PROPERTY2, 
			IT_PROPERTY3, 
			IT_PROPERTY4, 
			IT_PROPERTY5,
			RECORD_EMP, 
			RECORD_IP, 
			RECORD_DATE, 
			UPD_EMP, 
			UPD_IP, 
			UPD_DATE,
			ASSET_IP,
			ASSET_MAC_IP,
			USERNAME,
			PASSWORD,
			NUMBER_OF_USERS
		FROM 
			ASSET_P_IT 
		WHERE 
			ASSETP_ID = #asset_id#
	</cfquery>
	<cfparam name="attributes.display" default="">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfform action="#request.self#?fuseaction=assetcare.emptypopup_updit_assetp&assetp_id=#asset_id#" method="post" name="asset_care" id="asset_care">
			<cf_box_elements>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<cf_duxi name='username' class="tableyazi" type="text" value="#get_info_asset.username#" label="57930" gdpr="10">
					<div class="form-group" id="item-pass">
						<cf_duxi name='label_pass' class="col col-4 col-md-4 col-sm-4 col-xs-12" type="label_gdpr"  label="57552" gdpr="10">
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>: <cf_get_lang dictionary_id='57552.Şifre'></cfsavecontent>
								<cf_duxi type="text" name="password" id="password" value="#iIf(len(get_info_asset.PASSWORD),"contentEncryptingandDecodingAES(isEncode:0,content:get_info_asset.password,accountKey:'wrk')",DE(""))#" required="yes" message="#message#" gdpr="10">
								<span id="item_password" class="input-group-addon showPassword" onclick="showPassword('password')"><i class="fa fa-eye"></i></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-number_of_users">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='46464.Öngörülen'><cf_get_lang dictionary_id='59913.Kullanıcı Sayısı'></label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.number_of_users#" name="number_of_users" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-it_pro">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47914.İşlemci'></label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.it_pro#" name="it_pro" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-it_memory">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47916.Bellek'></label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.it_memory#" name="it_memory" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-it_hdd">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47735.Hard Disk'></label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.it_hdd#" name="it_hdd" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-it_con">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47918.Konfigürasyon'></label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.it_con#" name="it_con" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-it_ip">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32421.IP'></label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.asset_ip#" name="asset_ip" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-it_mac_ip">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63457.MAC'><cf_get_lang dictionary_id='32421.IP'></label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.asset_mac_ip#" name="asset_mac_ip" maxlength="100">
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-it_property1">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47915.Ek Özellik'> 1</label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.it_property1#" name="it_property1" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-it_property2">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47915.Ek Özellik'> 2</label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.it_property2#" name="it_property2" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-it_property3">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47915.Ek Özellik'> 3</label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.it_property3#" name="it_property3" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-it_property4">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47915.Ek Özellik'> 4</label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.it_property4#" name="it_property4" maxlength="100">
						</div>
					</div>
					<div class="form-group" id="item-it_property5">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='47915.Ek Özellik'> 5</label>
						<div class="col col-8 col-md-6 col-sm-8 col-xs-12">
							<cfinput type="text" value="#get_info_asset.it_property5#" name="it_property5" maxlength="100">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_info_asset">
				<cf_workcube_buttons type_format='1' is_upd='1' is_delete="0" add_function="kontrol_it()">
					<div style="float:left;" id="show_user_message1"></div>
			</cf_box_footer>
		</cfform>
	</div>             
	<script>
		<cfif isdefined('attributes.isAjax') and attributes.isAjax eq 1>
			$('input[data-gdpr=1]').each(function(){
				$("#item_password").attr("onclick","showPassword('password_')");
			})
		</cfif>
		function kontrol_it() {
			<cfoutput>
				AjaxFormSubmit('asset_care','show_user_message1',0,'&nbsp;Güncelleniyor','&nbsp;Güncellendi','#request.self#?fuseaction=assetcare.popup_upd_it_asset&asset_id=#asset_id#','div_list_it_asset');
				AjaxPageLoad('#request.self#?fuseaction=assetcare.popup_upd_it_asset&asset_id=#asset_id#','asset_it_',1);
			</cfoutput>
		}
	</script>
</div>