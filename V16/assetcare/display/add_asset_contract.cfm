<cf_box title="#getLang('assetcare',55)#">
	<cfform name="asset_contract" action="#request.self#?fuseaction=assetcare.emptypopup_add_asset_contract" method="post" enctype="multipart/form-data">
		<cf_box_elements vertical="1">
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang_main no='68.Başlık'> *</label>
				<cfsavecontent variable="messages"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.Başlık'>!</cfsavecontent>
				<cfinput type="text"  name="contract_head" maxlength="100" required="yes" message="#messages#">
				
			</div>
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
				<label width="100"><cf_get_lang_main no='1655.Varlık'> *</label>				
				<cfquery name="get_asset_name" datasource="#DSN#">
					SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #URL.ASSET_ID#
				</cfquery>
				<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#url.asset_id#</cfoutput>">
				<input type="text" name="asset_name"  id="asset_name" value="<cfoutput>#GET_ASSET_NAME.ASSETP#</cfoutput>"  readonly>
			</div>
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang no='56.Destek Firması'></label>
				<div class="input-group">
					<input type="hidden" name="company_id"  id="company_id">
					<input type="text" name="support_company_id" id="support_company_id" value=""  readonly>
					<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=asset_contract.authorized_id&field_comp_name=asset_contract.support_company_id&field_name=asset_contract.support_authorized_id&field_comp_id=asset_contract.company_id&select_list=2,3,5,6','list');"></span>
				</div>				
			</div>
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang no='57.Destek Yetkili'></label>
				<input type="hidden" name="authorized_id" id="authorized_id">
				<input type="text" name="support_authorized_id" id="support_authorized_id" value=""  readonly>
			</div>
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang no='244.Sorumlu Çalışan'></label>
				<div class="input-group">
					<input type="hidden" name="employee_id" id="employee_id">
					<input type="text" name="employee" id="employee" value=""  readonly>
					<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=asset_contract.employee_id&field_name=asset_contract.employee&select_list=1','list');"></span>
				</div>
				
			</div>
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang no='59.Destek Başlangıç'></label>
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='59.Destek Başlangıç !'></cfsavecontent>
					<cfinput type="text" name="support_start_date" validate="#validate_style#" maxlength="10"  message="#message#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="support_start_date"></span>	
				</div>				
			</div>
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang no='60.Destek Bitiş'></label>
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='60.Destek Bitiş !'></cfsavecontent>
					<cfinput type="text" name="support_finish_date" validate="#validate_style#" maxlength="10"  message="#message#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="support_finish_date"></span>					
				</div>
				
				
			</div>
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang no='61.Destek Belgesi Ekle'></label>
				<input type="file" name="document" id="document" >
			</div>
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang no='62.Destek Kategorisi'></label>
				<cf_wrk_combo
					name="support_cat"
					query_name="GET_ASSET_TAKE_SUPPORT_CAT"
					option_name="TAKE_SUP_CAT"
					option_value="TAKE_SUP_CATID"
					width="150">
			</div>
			<div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
				<label><cf_get_lang_main no='217.Açıklama'></label>
				<textarea style="width:220;height:180" name="detail" id="detail"></textarea>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0'>
		</cf_box_footer>
	</cfform>
</cf_box>

