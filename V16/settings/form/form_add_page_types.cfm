<div class="col col-2 col-md-2 col-sm-2 col-xs-12" type="column" index="1" sort="true">
    <cfinclude template="../display/list_page_types.cfm">
</div>
<div class="col col-10 col-md-10 col-sm-10 col-xs-12">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='42557.Sayfa Tipi Ekle'></cfsavecontent>
    <cf_box title="#title#" is_blank="0">
        <cfform action="#request.self#?fuseaction=settings.emptypopup_add_page_types" method="post" name="page_type">
            <cf_box_elements>	
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="page_type" style="width:300px;" value="" maxlength="50" required="Yes" message="#message#">
                        </div>
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43477.İlişkili Şirket'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cf_multiselect_check
                            name="our_company_ids"
                            option_name="nick_name"
                            option_value="comp_id"
                            width="226"
                            table_name="OUR_COMPANY">
                        </div>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">         
                    <div class="form-group">
                        <div class="col col-12 col-xs-12">
                            <cfmodule
                            template="/fckeditor/fckeditor.cfm"
                            toolbarSet="WRKContent"
                            basePath="/fckeditor/"
                            instanceName="detail"
                            valign="top"
                            value=""
                            width="650"
                            height="350">
                        </div>
                    </div>
                </div>            
            </cf_box_elements>
        <cf_form_box_footer><cf_workcube_buttons is_upd='0'></cf_form_box_footer>
        </cfform>
    </cf_box>
</div>

     
  

