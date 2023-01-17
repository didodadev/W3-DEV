<cf_catalystHeader>
<cfscript>
    cmp_department = createObject("component","V16.hr.cfc.get_departments");
    cmp_department.dsn = dsn;
    get_department = cmp_department.get_department();
</cfscript>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=hr.emptypopup_upd_content&AUTHORITY_ID=#attributes.AUTHORITY_ID#" method="post" name="position">
            <cfinput type="hidden" name="AUTHORITY_ID" id="AUTHORITY_ID" value="#attributes.AUTHORITY_ID#">
            <cfquery name="POSITIONCATEGORIES" datasource="#dsn#">
                SELECT * FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
            </cfquery>
            <cfquery name="GET_AUTHORITY" datasource="#dsn#">
                SELECT * FROM EMPLOYEE_AUTHORITY WHERE AUTHORITY_ID = #attributes.AUTHORITY_ID#
            </cfquery>
            <cfquery name="GET_NAMES" datasource="#dsn#">
                SELECT POSITION_CAT_ID,POSITION_ID FROM EMPLOYEE_POSITIONS_AUTHORITY WHERE AUTHORITY_ID = #attributes.AUTHORITY_ID#
            </cfquery>
            <cfif len(GET_NAMES.POSITION_ID)>
                <cfquery name="get_pos_name" datasource="#dsn#">
                    SELECT POSITION_NAME FROM EMPLOYEE_POSITION_NAMES WHERE POS_NAME_ID = #GET_NAMES.POSITION_ID#
                </cfquery>
            </cfif>
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-STATUS">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <div class="col col-8 col-xs-12"> 
                            <input type="checkbox" name="STATUS" id="STATUS" value=""<cfif get_authority.STATUS eq 1> checked</cfif>>
                        </div>
                    </div>
                    <div class="form-group" id="item-position_name">
                        <label class="col col-4"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
                        <div class="col col-8">
                            <div class="input-group">
                                <input maxlength="50"  type="hidden" name="position_name_id" id="position_name_id" value="<cfif len(GET_NAMES.position_id)><cfoutput>#GET_NAMES.position_id#</cfoutput></cfif>">
                                <input maxlength="50"  type="Text" name="position_name" id="position_name" value="<cfif len(GET_NAMES.position_id)><cfoutput>#get_pos_name.position_name#</cfoutput></cfif>">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_position_names&field_id=position.position_name_id&field_name=position.position_name','list');"></span>              
                            </div>
                        </div>                
                    </div>
                    <div class="form-group" id="item-position_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                        <div class="col col-8 col-xs-12"> 
                            <cfset pos_cat_list=''>
                            <cfloop query="GET_NAMES">
                                <cfif LEN(pos_cat_list)>
                                    <cfset pos_cat_list='#pos_cat_list#,#POSITION_CAT_ID#'>
                                <cfelse>
                                    <cfset pos_cat_list='#POSITION_CAT_ID#'>
                                </cfif>
                            </cfloop>
                            <cf_multiselect_check
                                name="position_cat"
                                option_name="position_cat"
                                option_value="POSITION_CAT_ID"
                                value="#pos_cat_list#"
                                table_name="SETUP_POSITION_CAT">
                        </div>
                    </div>
                    <div class="form-group" id="item-position_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-8 col-xs-12"> 
                            <cfset department_list=''>
                            <cfloop query="GET_AUTHORITY">
                                <cfif LEN(department_list)>
                                    <cfset department_list='#department_list#,#DEPARTMENT_ID#'>
                                <cfelse>
                                    <cfset department_list='#DEPARTMENT_ID#'>
                                </cfif>
                            </cfloop>
                            <cf_multiselect_check
                            query_name="get_department"  
                            name="department_id"
                            width="140" 
                            option_value="DEPARTMENT_ID"
                            option_name="DEPARTMENT_HEAD"
                            value="#department_list#"
                            option_text="#getLang('main',322)#">
                        </div>
                    </div>
                    <div class="form-group" id="item-CONTENT_HEAD">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50759.Başlık'></label>
                        <div class="col col-8 col-xs-12"> 
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="CONTENT_HEAD" id="CONTENT_HEAD" value="#get_authority.AUTHORITY_HEAD#" required="Yes" message="#message#" maxlength="100" style="width:420px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-editor">
                        <cfmodule
                            template="/fckeditor/fckeditor.cfm"
                            toolbarSet="WRKContent"
                            basePath="/fckeditor/"
                            instanceName="CONTENT_DETAIL"
                            valign="top"
                            value="#get_authority.AUTHORITY_DETAIL#"
                            width="500"
                            height="300">
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>	
                <div class="col col-6"><cf_record_info query_name="get_authority" record_emp="record_member" update_emp="update_member"></div>
                <div class="col col-6">
                    <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_content&AUTHORITY_ID=#attributes.AUTHORITY_ID#'><!---  add_function="OnFormSubmit()" --->
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
