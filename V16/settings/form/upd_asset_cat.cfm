<cf_xml_page_edit fuseact="settings.asset_cat">
<cfquery name="GET_CONTENT_PROPERTY" datasource="#DSN#">
	SELECT 
		CONTENT_PROPERTY_ID,
		NAME
	FROM 
		CONTENT_PROPERTY
	ORDER BY
		NAME
</cfquery>
<cfset popup = "">
<cfif attributes.fuseaction contains 'popup'><cfset popup = "&popup=1"></cfif>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id='42575.Update Digital Asset Category'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#head#" closable="1" draggable="1" add_href="#request.self#?fuseaction=objects.popup_add_asset_cat">
            <div class="col col-4 col-md-4 col-xs-12" id="cat-bar">
                <cfinclude template="../../objects/display/ajax_get_asset_cat.cfm">
                <script>
                    $(function(){
                        $("#cat-bar").css({"margin-top":"0px"}).show();
                    });
                    function chooseCat(catid,catName){
                        <cfif attributes.fuseaction contains 'popup'> 
                            document.location = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_upd_asset_cat&ID='+catid+'&mainCatName='+catName;
                        <cfelse>
                            document.location = '<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_upd_asset_cat&ID='+catid+'&mainCatName='+catName;
                        </cfif>
                    }
                </script>
            </div>
            <div class="col col-8 col-md-8 col-xs-12">
                <cfform action="#request.self#?fuseaction=settings.emptypopup_asset_cat_upd#popup#" method="post" name="asset_cat">
                    <cf_box_elements vertical="1">
                        <cfquery name="CATEGORY" datasource="#DSN#">
                            SELECT 
                                ASSETCAT_ID,
                                ASSETCAT_MAIN_ID,
                                #dsn#.Get_Dynamic_Language(ASSETCAT_ID,'#session.ep.language#','ASSET_CAT','ASSETCAT',NULL,NULL,ASSETCAT) AS ASSETCAT,
                                ASSETCAT_PATH,
                                #dsn#.Get_Dynamic_Language(ASSETCAT_ID,'#session.ep.language#','ASSET_CAT','ASSETCAT_DETAIL',NULL,NULL,ASSETCAT_DETAIL) AS ASSETCAT_DETAIL,
                                CONTENT_PROPERTY_ID,
                                IS_INTERNET,
                                IS_EXTRANET
                            FROM 
                                ASSET_CAT 
                            WHERE 
                                ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ID#">
                        </cfquery>
                        <div class="col col-12 col-md-12 col-xs-12">
                            <input type="hidden" name="assetcat_id" id="assetcat_id" value="<cfoutput>#attributes.ID#</cfoutput>">
                            <cfif category.ASSETCAT_ID gt -1>
                                <div class="form-group" id="item-top_cat">
                                    <label><cf_get_lang dictionary_id='52581'></label>
                                    <!---<cf_wrk_selectlang
                                        name="assettopcat_id"
                                        option_name="assetcat"
                                        option_value="assetcat_id"
                                        table_name="ASSET_CAT"
                                        condition=""
                                        value="#CATEGORY.ASSETCAT_MAIN_ID#"
                                        sort_type="assetcat">
                                        --->
                                    <div class="input-group">
                                        <input type="hidden" name="assettopcat_id" id="assettopcat_id" <cfif isdefined('attributes.ID') and len(attributes.ID)> value="<cfoutput>#attributes.ID#</cfoutput>"</cfif>>
                                        <input type="text" name="mainCatName" id="mainCatName" style="width:125px;" <cfif isdefined('attributes.mainCatName') and len(attributes.mainCatName)> value="<cfoutput>#attributes.mainCatName#</cfoutput>"</cfif> onfocus="AutoComplete_Create('mainCatName','ASSETCAT','ASSETCAT_PATH','get_asset_cat','0','ASSETCAT_ID','assettopcat_id','','3','130');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat&chooseCat=1&form_name=asset_cat&field_id=assettopcat_id&field_name=mainCatName','list');"></span>			
                                    </div>
                                    <label class="col col-12"><cf_get_lang dictionary_id='48526'></label>
                                </div>
                            </cfif>
                            <div class="form-group" id="item-assetCat">
                                <label><cf_get_lang no='316.Varlık Adı' module_name='settings'>*</label>
                                <cfsavecontent variable="message"><cf_get_lang no='727.Varlık Adı girmelisiniz' module_name='settings'></cfsavecontent>
                                <div class="input-group">
                                    <cfinput type="Text" name="assetCat" size="60" value="#category.assetcat#" maxlength="50" required="Yes" message="#message#">
                                    <span class="input-group-addon">
                                    <cf_language_info 
                                        table_name="ASSET_CAT" 
                                        column_name="ASSETCAT" 
                                        column_id_value="#url.id#" 
                                        maxlength="500" 
                                        datasource="#dsn#" 
                                        column_id="ASSETCAT_ID" 
                                        control_type="0">
                                    </span> 
                                </div>
                            </div>
                            <div class="form-group" id="item-assetcat_path">
                                <label><cf_get_lang no='317.Klasör' module_name='settings'>*</label>
                                <cfsavecontent variable="message"><cf_get_lang no='721.Klasör girmelisiniz' module_name='settings'></cfsavecontent>
                                <cfif attributes.ID lt 0>
                                    <cfinput type="text" name="assetcat_path" id="assetcat_path" size="30" value="#category.assetcat_path#" onkeyup="textClear(this)" maxlength="25" required="Yes" message="#message#" readonly="yes">
                                <cfelse>
                                    <cfif len(CATEGORY.ASSETCAT_MAIN_ID)>
                                        <cfset assetPath = listLast(CATEGORY.ASSETCAT_PATH,"/")>
                                    <cfelse>
                                        <cfset assetPath = CATEGORY.ASSETCAT_PATH>
                                    </cfif>
                                    <cfinput type="text" name="assetcat_path" id="assetcat_path" size="30" value="#assetPath#" maxlength="25" onkeyup="textClear(this)" required="Yes" message="#message#">
                                </cfif>
                            </div>
                            <div class="form-group" id="item-assetcat_detail">
                                <label><cf_get_lang_main no='217.Açıklama' module_name='settings'></label>
                                <div class="input-group">   
                                    <input type="text" name="assetcat_detail" id="assetcat_detail" value="<cfoutput>#category.assetcat_detail#</cfoutput>" style="width:150px;" maxlength="50" onkeyup="return ismaxlength(this)" onblur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 50">
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                            table_name="ASSET_CAT" 
                                            column_name="ASSETCAT_DETAIL" 
                                            column_id_value="#url.id#" 
                                            maxlength="500" 
                                            datasource="#dsn#" 
                                            column_id="ASSETCAT_ID" 
                                            control_type="0">
                                    </span> 
                                </div>
                            </div>
                            <cfif isdefined("x_show_by_digital_asset_group") and x_show_by_digital_asset_group eq 1>
                            <div class="form-group" id="item-content_property_id">
                                <label><cf_get_lang dictionary_id="47693"></label>
                                    <cfquery name="GROUP_IDS" datasource="#DSN#">
                                        SELECT GROUP_ID FROM DIGITAL_ASSET_GROUP_PERM WHERE ASSETCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#category.ASSETCAT_ID#">
                                    </cfquery>
                                    <cfset groupids="">
                                    <cfif GROUP_IDS.recordcount>
                                        <cfoutput query = "GROUP_IDS">
                                            <cfset groupids = "#groupids##GROUP_ID#,">
                                        </cfoutput>
                                        <cfset groupids = left(groupids,len(groupids)-1)>
                                    </cfif>
                                    <cf_multiselect_check 
                                        table_name="DIGITAL_ASSET_GROUP"
                                        name="digital_asset_group_id"
                                        width="150" 
                                        height="100"
                                        option_value="GROUP_ID"
                                        value="#groupids#"
                                        option_name="GROUP_NAME">	
                            </div>
                            </cfif>
                            <div class="form-group" id="item-top_cat">
                                <label class="col col-6 col-md-6 col-xs-6">
                                    <input type="checkbox" name="is_internet" id="is_internet" <cfif category.is_internet eq 1>checked</cfif>>
                                    <cf_get_lang_main no='667.İnternet'>
                                </label>
                                <label class="col col-6 col-md-6 col-xs-6">
                                    <input type="checkbox" name="is_extranet" id="is_extranet" <cfif category.is_extranet eq 1>checked</cfif>>
                                    <cf_get_lang_main no='607.Extranet'>                                 
                                </label>
                            </div>
                        </div>
                        <!---
                        <div class="col col-4 col-md-12 col-xs-12">
                            <cfsavecontent variable="txt_1"><cf_get_lang no='700.Yetkili Pozisyonlar'></cfsavecontent>
                            <cf_workcube_to_cc 
                                is_update="1" 
                                to_dsp_name="#txt_1#" 
                                form_name="asset_cat" 
                                str_list_param="1,2" 
                                action_dsn="#DSN#"
                                str_action_names = "ASSETCAT_ID ASSCAT,POSITION_CODE TO_POS_CODE"
                                action_table="DIGITAL_ASSET_GROUP_PERM"
                                action_id_name="ASSETCAT_ID"
                                data_type="2"
                                action_id="#attributes.ID#">
                        </div>
                        --->
                    </cf_box_elements>
                    <cf_box_footer>
                        <div class="col col-6">
                            <cf_record_info query_name="category">
                        </div>
                        <div class="col col-6">
                            <cfinclude template="../query/get_asset_cat_used.cfm">
                            <cfif (asset_cat_used.recordcount) or (category.assetcat_id lt 0)>
                                <cf_workcube_buttons is_upd='1' is_delete='0'>
                            <cfelse>
                                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_asset_cat_del#popup#&assetcat_id=#attributes.id#'>
                            </cfif>
                        </div>
                    </cf_box_footer>
                </cfform>
            </div>
    </cf_box>
</div>
<script>
	function textClear(textInput){
		textInput.value = textInput.value.replace(/[`~!@#$%^&*()_|+\-=?;:'",.<>\{\}\[\]\\\/]/gi, '');
	}
</script>