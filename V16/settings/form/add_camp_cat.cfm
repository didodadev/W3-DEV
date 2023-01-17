<cfquery name="GET_TYPE" datasource="#dsn3#">
	SELECT 
	    CAMP_TYPE_ID, 
        CAMP_TYPE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP,
        UPDATE_IP 
    FROM 
    	CAMPAIGN_TYPES
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='42902.Kampanya Alt Kategorileri'></cfsavecontent>
    <cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_camp_cat" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
            <cfinclude template="../display/list_camp_cat.cfm">
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform action="#request.self#?fuseaction=settings.emptypopup_camp_cat_add" method="post" name="camp_cat">
                <cf_box_elements>
          			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column">
                        <div class="form-group" id="item-cat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="camp_type" id="camp_type">
                                    <cfoutput query="get_type">
                                        <option value="#camp_type_id#">#camp_type#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-sub-cat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43130.Alt Kategori'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="Text" name="camp_cat_name" size="20" value="" maxlength="100" required="Yes" message="#message#">
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </cf_box_footer>
            </cfform>
        </div>
    </cf_box>
</div>