<cfquery name="BRANCHES" datasource="#DSN#">
	SELECT 
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH 
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfparam name="attributes.modal_id" default="">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#iif(isDefined("attributes.draggable"),"getLang('','Yazar Kasa Ekle',54593)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
		<cfform name="add_pos" id="add_pos" method="post" action="#request.self#?fuseaction=retail.emptypopup_add_pos">
			<cf_box_elements>
                <div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-equipment_name">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='49775.Kasa Adı'> *</label>
                        <div class="col col-9 col-xs-12">
                            <cfinput type="text" name="equipment" id="equipment_name" maxlength="100" required="yes" message="#getLang('','Kasa Girmelisiniz',54596)#">
                        </div>
                    </div>
					<div class="form-group" id="item-equipment_code">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='49778.Kasa Kodu'> *</label>
                        <div class="col col-9 col-xs-12">
							<cfinput type="text" name="equipment_code" id="equipment_code" maxlength="50" required="yes" message="#getLang('','Kasa Kodu Girmelisiniz',62623)#!">
                        </div>
                    </div>
					<div class="form-group" id="item-branch_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-9 col-xs-12">
                            <cfselect name="branch_id" id="branch_id" required="yes" message="Şube Seçiniz!">
								<option value=""><cf_get_lang_main no='322.Seciniz'></option>
								<cfoutput query="branches">
									<option value="#branch_id#" <cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
								</cfoutput>
							</cfselect>
                        </div>
                    </div>
					<div class="form-group" id="item-pos_code3">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='47708.Path'> *</label>
                        <div class="col col-9 col-xs-12">
                            <cfinput type="text" name="path" id="path" maxlength="200" required="yes" message="#getLang('','Path Girmelisiniz',43428)#!">
                        </div>
                    </div>
					<div class="form-group" id="item-pos_code3">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='62624.Offline Path'> *</label>
                        <div class="col col-9 col-xs-12">
                            <cfinput type="text" name="offline_path" id="offline_path" maxlength="200" required="yes" message="#getLang('','Offline Path Girmelisiniz',62625)#!">
                        </div>
                    </div>
					<div class="form-group" id="item-pos_code3">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='62626.Filename'> *</label>
                        <div class="col col-9 col-xs-12">
							<cfinput type="text" name="filename" id="filename" maxlength="100" required="yes" message="#getLang('','Filename Girmelisiniz',62627)#!">
                        </div>
                    </div>
					<div class="form-group" id="item-pos_code3">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='52735.Type'></label>
                        <div class="col col-9 col-xs-12">
							<cfinput type="text" name="type" id="type" maxlength="100">
                        </div>
                    </div>
				</div>
				<div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-assetp_id">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="assetp_id" id="assetp_id" value="">
                                <input type="text" name="assetp" id="assetp">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_assets&field_id=add_pos.assetp_id&field_name=add_pos.assetp&event_id=0','list');return false"></span>
                            </div>
                        </div>
                    </div>
					<div class="form-group" id="item-pos_code3">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='62628.Seri Numarası'></label>
                        <div class="col col-9 col-xs-12">
							<cfinput type="text" name="serial_number" maxlength="100">
                        </div>
                    </div>
					<div class="form-group" id="item-pos_code3">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='62629.Mali No'></label>
                        <div class="col col-9 col-xs-12">
							<cfinput type="text" name="mali_no" maxlength="100">
                        </div>
                    </div>
					<div class="form-group" id="item-pos_code1">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 1</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_code1" id="pos_code1" value="">
                                <input type="text" name="pos_code_text1" id="pos_code_text1" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code1&field_name=add_pos.pos_code_text1&select_list=1','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code2">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 2</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_code2" id="pos_code2" value="">
                                <input type="text" name="pos_code_text2" id="pos_code_text2" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code2&field_name=add_pos.pos_code_text2&select_list=1','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-pos_code3">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='54577.Kasiyer'> 3</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="pos_code3" id="pos_code3" value="">
                                <input type="text" name="pos_code_text3" id="pos_code_text3" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_pos.pos_code3&field_name=add_pos.pos_code_text3&select_list=1','list');return false"></span>
                            </div>
                        </div>
                    </div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol(){
        if(document.getElementById('equipment_name').value == ''){
            alert("<cf_get_lang dictionary_id='54596.Kasa Girmelisiniz'>"); 
            return false;
        }
        if(document.getElementById('equipment_code').value == ''){
            alert("<cf_get_lang dictionary_id='62623.Kasa Kodu Girmelisiniz'>"); 
            return false;
        }
        if(document.getElementById('path').value == ''){
            alert("<cf_get_lang dictionary_id='43428.Path Girmelisiniz'>"); 
            return false;
        }

        if(document.getElementById('offline_path').value == ''){
            alert("<cf_get_lang dictionary_id='62625.Offline Path Girmelisiniz'>");
            return false;
        }

        if(document.getElementById('filename').value == ''){
            alert("<cf_get_lang dictionary_id='62627.Filename Girmelisiniz'>");
            return false;
        }

		<cfif isdefined("attributes.draggable")>loadPopupBox('add_pos' , <cfoutput>#attributes.modal_id#</cfoutput>);<cfelse>return true;</cfif>
	}
</script>