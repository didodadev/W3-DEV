<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','','58134')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=settings.emptypopup_ims_codes_add" method="post" name="content_cat">
        <cf_box_elements>
            <input type="hidden" name="modal_id" id="modal_id" value="<cfoutput>#attributes.modal_id#</cfoutput>">
            <div class="col col-8 col-md-8 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45857.IMS Bölge Adı'> (1001)*</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message1"><cf_get_lang no='1365.IMS Bölge Adı Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="Text" name="ims_name"   maxlength="50" required="Yes" message="#message1#">
                    </div>
                </div>
                <div class="form-group"  id="item-">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49657.IMS Bölge Kodu'> (1001)*</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message2"><cf_get_lang no='1367.IMS Bölge Kodu Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="Text" name="ims_code"   maxlength="50" required="Yes" message="#message2#">
                    </div>
                </div>
                <div class="form-group"  id="item-">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45857.IMS Bölge Adı'> (501)*</label>
                    <div class="col col-8 col-xs-12"><cfinput type="Text" name="ims_name_501"   maxlength="50" required="Yes" message="#message1#"></div>
                </div>
                <div class="form-group"  id="item-">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49657.IMS Bölge Kodu'> (501)*</label>
                    <div class="col col-8 col-xs-12"><cfinput type="Text" name="ims_code_501"   maxlength="50" required="Yes" message="#message2#"></div>                                </div>
                <div class="form-group"  id="item-">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52254.IMS'><cf_get_lang dictionary_id='57771.Detay'></label>
                    <div class="col col-8 col-xs-12"><textarea name="ims_desc" id="ims_desc" ></textarea></div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0'>
        </cf_box_footer>
    </cfform>
</cf_box>
