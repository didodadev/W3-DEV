<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','IM Kategorileri','42104')#" add_href="#request.self#?fuseaction=settings.form_add_im_cat" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12 scrollContent scroll-x3">
            <cfinclude template="../display/list_im_cat.cfm">
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform enctype="multipart/form-data" action="#request.self#?fuseaction=settings.emptypopup_im_cat_add" method="post" name="im_cat">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-sales-account-code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='20.Kategori Adı'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="Text" name="imCat" value="" maxlength="50" required="Yes" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-sales-account-code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41986.Simge'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='41986.Simge'></cfsavecontent>
                                <cfinput type="file" name="imicon" value="" required="Yes" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="item-sales-account-code">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41994.Link Tipi'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                                <cfinput type="Text" name="imLinkType" value="" maxlength="40">
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
