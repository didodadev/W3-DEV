<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='44491.Blok Grupları'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_block_group" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_block_group.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="user_group" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_block_group">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="block_group_name">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='44485.Blok Grubu'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='44556.Blok Grubu Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="text" name="block_group_name" id="block_group_name" size="60" value="" maxlength="50" required="Yes" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="level_id_1">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="level_id_1" id="level_id_1" value="1"><cf_get_lang dictionary_id='44557.Sadece Kredi Kartıyla Sipariş Verebilir'>
                            </div>
                        </div>
                        <div class="form-group" id="level_id_2">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="level_id_2" id="level_id_2" value="1"><cf_get_lang dictionary_id='44558.Sipariş Veremez'>
                            </div>
                        </div>
                        <div class="form-group" id="level_id_3">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="level_id_3" id="level_id_3" value="1"><cf_get_lang dictionary_id='43809.Prim Alamaz'>
                            </div>
                        </div>
                        <div class="form-group" id="level_id_4">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="level_id_4" id="level_id_4" value="1"><cf_get_lang dictionary_id='44488.Kayıt Yapamaz'>
                            </div>
                        </div>
                        <div class="form-group" id="level_id_5">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="level_id_5" id="level_id_5" value="1"><cf_get_lang dictionary_id='44489.Grubu Adına Sipariş Veremez'>
                            </div>
                        </div>
                        <div class="form-group" id="level_id_6">
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</div>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <input type="checkbox" name="level_id_6" id="level_id_6" value="1"><cf_get_lang dictionary_id='44490.Tanımlı Sitelerde Giriş Yapamaz'>
                            </div>
                        </div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'><!--- OnFormSubmit()&& --->
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>