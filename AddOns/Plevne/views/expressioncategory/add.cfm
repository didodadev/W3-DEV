<cfinclude template="../../config.cfm" runonce="true">
<cfinclude template="../../models/types.cfm" runonce="true">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Kurumsal Üyeler',29408)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_form" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-title">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58233.Tanım"></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="title" required>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57982.Tür"></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                            <select name="kind" id="kind">
                                <option value="#plevne_kinds.REQUEST_FILTER#">Request Filter</option>
                            </select>
                            </cfoutput>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-status">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57756.Durum"></label>
                        <div class="col col-8 col-xs-12">
                            <select name="status" id="status">
                                <option value="1"><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option value="0"><cf_get_lang dictionary_id='57494.Pasif'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function="kontrol()">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
    function kontrol() {
        return document.getElementById("add_form").checkValidity();
        <cfif isdefined("attributes.draggable")>loadPopupBox('add_form' , <cfoutput>#attributes.modal_id#</cfoutput>);</cfif>
    }
</script>