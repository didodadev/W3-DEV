<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='44549.CV  Değerlendirme Kategorileri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.add_cv_color_format" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
            <cfinclude template="../display/list_cv_color_format.cfm">
        </div> 
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform name="form"  method="post" enctype="multipart/form-data" action="#request.self#?fuseaction=settings.emptypopup_add_cv_color_format">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-status">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57756.Durum'> *</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57736.Durum Adı Girmelisiniz'> !</cfsavecontent>
                                <cfinput type="Text" name="status" value="" required="yes" message="#message#" maxlength="50">
                            </div>	
                        </div>
                        <div class="form-group" id="item-image">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29762.İmaj'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfsavecontent variable="msg"><cf_get_lang dictionary_id='43718.Image Seçmelisiniz'> !</cfsavecontent>
                                <cfinput type="file" name="icon" value="" message="#msg#">
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <textarea name="detail" id="detail" maxlength="100"></textarea>
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
