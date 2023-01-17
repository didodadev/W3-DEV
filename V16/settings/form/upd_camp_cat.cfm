<cfquery name="GET_CAMPAIGN_CAT" datasource="#DSN3#" maxrows="1">
	SELECT CAMP_CAT_ID FROM CAMPAIGNS WHERE CAMP_CAT_ID = #attributes.id#
</cfquery>
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
<cfquery name="CATEGORY" datasource="#dsn3#">
	SELECT 
    	CAMP_CAT_ID, 
        CAMP_CAT_NAME, 
        CAMP_TYPE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP  
    FROM 
    	CAMPAIGN_CATS 
    WHERE 
	    CAMP_CAT_ID = #attributes.id#
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='42902.Kampanya Alt Kategorileri'></cfsavecontent>
    <cf_box title="#head#" add_href="#request.self#?fuseaction=settings.form_add_camp_cat" is_blank="0">
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
            <cfinclude template="../display/list_camp_cat.cfm">
        </div>
        <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
            <cfform action="#request.self#?fuseaction=settings.emptypopup_camp_cat_upd" method="post" name="mobil_cat">
                <cfinput type="hidden" name="camp_cat_id" id="camp_cat_id" value="#attributes.id#">
                <cf_box_elements>
          			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column">
                        <div class="form-group" id="item-cat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="camp_type" id="camp_type" style="width:150px;">
                                    <cfoutput query="get_type">
                                        <option value="#camp_type_id#" <cfif camp_type_id eq category.camp_type>selected</cfif>>#camp_type#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-sub-cat">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43130.Alt Kategori'>*</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58555.Kategori Adı Girmelisiniz'>!</cfsavecontent>
                                    <cfinput type="Text" name="camp_Cat_name" size="20" value="#category.camp_cat_name#" maxlength="100" required="Yes" message="#message#" style="width:150px;">
                                    <span class="input-group-addon">
                                        <cf_language_info
                                        table_name="CAMPAIGN_CATS"
                                        column_name="CAMP_CAT_NAME"
                                        column_id_value="#attributes.id#"
                                        maxlength="500"
                                        datasource="#dsn3#" 
                                        column_id="CAMP_CAT_ID" 
                                        control_type="2">
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_record_info query_name="category">
                    <cfif get_campaign_cat.recordcount>
                        <cf_workcube_buttons is_upd='1' is_delete='0'>
                    <cfelse>
                        <cfif url.id lte 0>
                            <cf_workcube_buttons is_upd='1' is_delete='0'>
                        <cfelse>
                            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_camp_cat_del&camp_cat_id=#URL.ID#'>
                        </cfif>
                    </cfif>
                </cf_box_footer>
            </cfform>
        </div>
    </cf_box>
</div>