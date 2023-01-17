<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='42719.Özlük Belge Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_employment_asset_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_employment_asset_cat.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform action="#request.self#?fuseaction=settings.emptypopup_employment_asset_cat_add" method="post" name="driver_licence">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="upper_asset_cat_id">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29736.Üst Kategori'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="upper_asset_cat_id" id="upper_asset_cat_id">
									<option value=""><cf_get_lang dictionary_id='29736.Üst Kategori'></option>
									<cfoutput query="get_upper_cats">
										<option value="#asset_cat_id#">#asset_cat#</option>
									</cfoutput>
								</select>
                            </div>
                        </div>
                        <div class="form-group" id="asset_cat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='55455.Konu Girmelisiniz'>!</cfsavecontent>
								<cfinput type="Text" name="asset_cat" size="20" value="" maxlength="100" required="Yes" message="#message#">
                            </div>
                        </div>
						<div class="form-group" id="SPECIAL_HIERARCHY">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="text" value="" name="SPECIAL_HIERARCHY" id="SPECIAL_HIERARCHY" maxlength="5" >
                            </div>
                        </div>
						<div class="form-group" id="sequence_no">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37624.Sıra no'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="number" value="" name="sequence_no" id="sequence_no">
                            </div>
                        </div>
						<div class="form-group" id="USAGE_YEAR">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42724.Kullanım Süresi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfinput type="Text" name="USAGE_YEAR" value="" validate="integer" maxlength="2"  message="Kullanım Süresi Hatalı!">
                            </div>
                        </div>
						<div class="form-group" id="IS_LAST_YEAR_CONTROL">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42740.Bitiş Yılı'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" value="1" name="IS_LAST_YEAR_CONTROL" id="IS_LAST_YEAR_CONTROL"><cf_get_lang dictionary_id='42748.Kontrol Edilsin'>
                            </div>
                        </div>
						<div class="form-group" id="IS_VIEW_MYHOME">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" value="1" name="IS_VIEW_MYHOME" id="IS_VIEW_MYHOME"> <cf_get_lang dictionary_id='64087.Bilgilerim sayfasında görüntülensin'>
                            </div>
                        </div>
					</div>
				</cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0' add_function="kontrol()">
					</cf_box_footer>
				</div>
			</cfform>
    	</div>
  	</cf_box>
</div>