<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='42466.Yazışma Şablonları'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_corr_cat" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_corr_cat.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform action="#request.self#?fuseaction=settings.emptypopup_corr_cat_upd" method="post" name="im_cat">
                <input type="Hidden" ID="clicked" name="clicked" value="">
                <cfquery name="CATEGORY" datasource="#dsn#">
                    SELECT 
                        * 
                    FROM 
                        SETUP_CORR 
                    WHERE 
                        CORRCAT_ID=#URL.ID#
                </cfquery>
                <input type="Hidden" name="corrCat_ID" id="corrCat_ID" value="<cfoutput>#URL.ID#</cfoutput>">
        		<cf_box_elements>
          			<div class="col col-8 col-md-8 col-sm-8 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="corrCat">
                            <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'>*</label>
                            <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='55455.Konu Girmelisiniz'>!</cfsavecontent>
                                    <cfinput type="Text" name="corrCat" value="#category.corrCat#" maxlength="50" required="Yes" message="#message#">    
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                        table_name="SETUP_CORR" 
                                        column_name="CORRCAT" 
                                        column_id_value="#URL.ID#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="CORRCAT_ID" 
                                        control_type="0">
                                    </span>
                                </div>
                                
                            </div>
                        </div>
                        <div class="form-group" id="colour">
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                <cfmodule
                                template="/fckeditor/fckeditor.cfm"
                                toolbarSet="WRKContent"
                                basePath="/fckeditor/"
                                instanceName="detail"
                                width="500"
                                height="350">
                            </div>
                        </div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
                    <cf_record_info query_name="category">
                    <cf_workcube_buttons is_upd='1' add_function='copyValue()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_corr_cat_del&corrcat_id=#url.id#'>
				</cf_box_footer>
			</cfform>
    	</div>
  	</cf_box>
</div>
<script type="text/javascript">
    document.im_cat.detail.value = '<cfoutput>#category.DETAIL#</cfoutput>';
</script>