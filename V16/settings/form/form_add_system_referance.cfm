<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Abone Referans Durumu','42941')#" add_href="#request.self#?fuseaction=settings.form_add_system_referance" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
            <cfinclude template="../display/list_system_referance_status.cfm">
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="service_app_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_system_referance">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-sales-account-code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">&nbsp</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <label><input type="checkbox" name="is_active" id="is_active" value="1" /><cf_get_lang dictionary_id="57493.aktif"></label>
                            </div>
                        </div>
                        <div class="form-group" id="item-sales-account-code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59660.Referans Durumu'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='61283.Referans Durumu Girmelisiniz'> !</cfsavecontent>
                                <cfinput type="Text" name="referance_status" size="60" maxlength="50" required="Yes" message="#message#">
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                </cf_box_footer>
            </cfform>
        </div>
    </cf_box>
</div>
