<cfquery name="GET_TARGET_CAT" datasource="#dsn#">
	SELECT 
    	TARGETCAT_ID, 
        #dsn#.Get_Dynamic_Language(TARGETCAT_ID,'#session.ep.language#','TARGET_CAT','TARGETCAT_NAME',NULL,NULL,TARGETCAT_NAME) AS TARGETCAT_NAME, 
        #dsn#.Get_Dynamic_Language(TARGETCAT_ID,'#session.ep.language#','TARGET_CAT','DETAIL',NULL,NULL,DETAIL) AS DETAIL, 
        TARGETCAT_WEIGHT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP,
        IS_ACTIVE
    FROM 
	    TARGET_CAT 
    WHERE 
    	TARGETCAT_ID=#attributes.targetcat_id#
</cfquery>
<cfquery name="GET_TARGET_COUNT" datasource="#dsn#">
	SELECT COUNT(TARGET_ID) AS TARGET_COUNT FROM TARGET WHERE TARGETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.targetcat_id#">
</cfquery>


           

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="add_target_cat" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_target_cat">
            <input type="hidden" name="targetcat_id" id="targetcat_id" value="<cfoutput>#attributes.targetcat_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-3 col-md-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-aktif">    
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang dictionary_id ='57493.Aktif'>
                            <input type="checkbox" name="is_active" id="is_active" <cfif GET_TARGET_CAT.is_active eq 1>checked</cfif> value="1">
                        </label>
                    </div>
                    <div class="form-group" id="item-kategori">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang dictionary_id ='57486.Kategori'>*
                        </label>
                        <div class="col col-8 col-xs-12">  
                            <div class="input-group">
                                <cfinput type="text" name="targetcat_name" value="#GET_TARGET_CAT.TARGETCAT_NAME#" maxlength="150" required="Yes">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="TARGET_CAT" 
                                    column_name="TARGETCAT_NAME" 
                                    column_id_value="#url.targetcat_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="TARGETCAT_ID" 
                                    control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group" id="item-aciklama">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang dictionary_id ='57629.Açıklama'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="targetcat_detail" id="targetcat_detail" value="#GET_TARGET_CAT.DETAIL#" maxlength="150" required="Yes">
                                <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="TARGET_CAT" 
                                    column_name="DETAIL" 
                                    column_id_value="#url.targetcat_id#" 
                                    maxlength="500" 
                                    datasource="#dsn#" 
                                    column_id="TARGETCAT_ID" 
                                    control_type="0">
                                </span>
                            </div>
                        </div>
                    </div>

                    <div class="form-group" id="item-agirlik">
                        <label class="col col-4 col-xs-12">
                            <cf_get_lang dictionary_id ='29784.Ağırlık'>
                        </label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="targetcat_weight" value="#GET_TARGET_CAT.TARGETCAT_WEIGHT#" maxlength="5" validate="float" range="0,100" >
                        </div>
                    </div>
                </div>
                <div class="col col-12 col-md-12 col-xs-12" type="column" index="2" sort="true">
                   
                    <div class="form-group" id="iliskiler">
                        <label class="col" style="display:none"><cf_get_lang dictionary_id="29718.İlişkiler"></label>
                        <div class="ListContent" >
                            <cf_relation_segment
                                is_upd='1'
                                is_form='1'
                                field_id='#attributes.targetcat_id#'
                                table_name='TARGET_CAT'
                                year_value='2005'
                                action_table_name='RELATION_SEGMENT'
                                select_list='1,2,3,4,5,6,7,8'>
                        </div>
                    
                    </div>
                </div> 
            </cf_box_elements> <cf_box_footer>
                <div class="col col-12">
                <cf_record_info query_name="GET_TARGET_CAT">
            </div>
           
                <div class="col col-12">
                
                <cfif GET_TARGET_COUNT.TARGET_COUNT gt 0>
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
                <cfelseif GET_TARGET_COUNT.TARGET_COUNT eq 0>
                    <cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_target_cat&target_cat_id=#attributes.targetcat_id#' add_function='kontrol()'>
                </cfif>
            
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

<script type="text/javascript"> 
	function kontrol()
	{
        if( $("textarea[name='targetcat_detail']").val().length > 250 ){
            alert("259");
            return false;
        }
        if( $("input[name='targetcat_name']").val().length == 0){
            return false;
        }
        return true;
    }
</script>
