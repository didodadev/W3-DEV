<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ödül Tipleri','53504')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform action="#request.self#?fuseaction=ehesap.emptypopup_add_prize_type" name="add_prize_type" method="post">
            <input type="hidden" name="counter" id="counter">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp;</label>
                        <label class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_get_lang dictionary_id='57493.Aktif'> <input type="checkbox" name="is_active" id="is_active" value="1" checked>
                        </label>
                    </div>
                    <div class="form-group" id="item-prize_type">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='53122.Ödül Tipi'> *</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='53342.Ödül Tipi girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="prize_type" required="yes" message="#message#" maxlength="75">
                        </div>
                    </div>
                    <div class="form-group" id="item-DETAIL">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                            <textarea name="DETAIL" id="DETAIL" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>