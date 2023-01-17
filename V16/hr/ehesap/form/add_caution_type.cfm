<cf_catalystHeader>
<cfform action="#request.self#?fuseaction=ehesap.emptypopup_add_caution_type" name="add_caution_type" method="post">
    <input type="hidden" name="counter" id="counter">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-is_active">
                            <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='57493.Aktif'></span></label>
                            <label class="col col-9 col-xs-12">
                                <cf_get_lang dictionary_id='57493.Aktif'> <input type="checkbox" name="is_active" id="is_active" value="1" checked>
                            </label>
                        </div>
                        <div class="form-group" id="item-caution_type">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53103.İhtar Tipi'>*</label>
                            <div class="col col-9 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53307.İhtar Tipi girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="caution_type" style="width:200px;" required="yes" message="#message#" maxlength="100">                        
                            </div>
                        </div>
                        <div class="form-group" id="item-DETAIL">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-9 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karrakter sayısı'></cfsavecontent>
                                <textarea style="width:200px;height:100px;" name="DETAIL" id="DETAIL" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"></textarea>                        
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cf_workcube_buttons is_upd='0'>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfform>
