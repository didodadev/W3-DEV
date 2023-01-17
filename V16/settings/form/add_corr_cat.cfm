<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='42466.Yazışma Şablonları'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_corr_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_corr_cat.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
        <cfform action="#request.self#?fuseaction=settings.emptypopup_corr_cat_add" method="post" name="corr_cat">
        		<cf_box_elements>
          			<div class="col col-8 col-md-8 col-sm-8 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="corrCat">
                            <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12"> 
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='55455.Konu Girmelisiniz'>!</cfsavecontent>
                                    <cfinput type="Text" name="corrCat" value="" maxlength="50" required="Yes" message="#message#">
                            </div>
                        </div>
                        <div class="form-group" id="colour">
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <cfmodule
                                template="/fckeditor/fckeditor.cfm"
                                toolbarSet="WRKContent"
                                basePath="/fckeditor/"
                                instanceName="detail"
                                value=""
                                width="500"
                                height="350">
                            </div>
                        </div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='copyValue()'><!--- OnFormSubmit()&& --->
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>