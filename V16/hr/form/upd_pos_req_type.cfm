<cf_xml_page_edit fuseact="hr.add_pos_req_type"> 
<cfquery name="get_type" datasource="#dsn#">
	SELECT IS_ACTIVE,PERFECTION_YEAR,#dsn#.Get_Dynamic_Language(REQ_TYPE_ID,'#session.ep.language#','POSITION_REQ_TYPE','REQ_TYPE',NULL,NULL,REQ_TYPE) AS REQ_TYPE,DETAIL,IS_GROUP,IS_COACH,IS_DEP_ADMIN,IS_STANDART FROM POSITION_REQ_TYPE WHERE REQ_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.req_type_id#">
</cfquery>
<cfquery name="get_chapter" datasource="#dsn#">
	SELECT CHAPTER_ID FROM EMPLOYEE_QUIZ_CHAPTER WHERE REQ_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.req_type_id#">
</cfquery>
<cfquery name="get_req_fill" datasource="#dsn#">
	SELECT 
		IS_FILL
	FROM
		RELATION_SEGMENT
	WHERE
		IS_FILL=1 AND
		RELATION_TABLE = 'POSITION_REQ_TYPE' AND
		RELATION_FIELD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.req_type_id#">
</cfquery>
<cf_catalystHeader>
<cfform action="#request.self#?fuseaction=hr.emptypopup_upd_pos_req_type" name="add_req_type_relation" method="post">
    <input type="hidden" name="is_fill" id="is_fill" value="<cfoutput>#GET_REQ_FILL.RECORDCOUNT#</cfoutput>">
    <cf_box>
		<cf_box_elements>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-perfection_year">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='58472.Dönem'></label>
                        <div class="col col-9 col-xs-12">
                            <select name="perfection_year"  id="perfection_year" <cfif GET_REQ_FILL.RECORDCOUNT>disabled</cfif>>
                                <cfloop from="#year(now())-3#" to="#year(now())+2#" index="j">
                                    <cfoutput><option value="#j#" <cfif get_type.PERFECTION_YEAR eq j>selected</cfif>>#j#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-REQ_TYPE">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'> *</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfif GET_REQ_FILL.RECORDCOUNT>
                                    <cfoutput>#get_type.REQ_TYPE#</cfoutput>
                                    <input type="hidden" name="req_type_id" id="req_type_id" value="<cfoutput>#attributes.req_type_id#</cfoutput>">
                                <cfelse>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
                                    <cfinput type="text" name="REQ_TYPE" id="REQ_TYPE" style="width:200px;" value="#get_type.REQ_TYPE#" required="yes" message="#message#" maxlength="50">
                                    <input type="hidden" name="req_type_id" id="req_type_id" value="<cfoutput>#attributes.req_type_id#</cfoutput>">
                                    <span class="input-group-addon">
                                        <cf_language_info 
                                            table_name="POSITION_REQ_TYPE" 
                                            column_name="REQ_TYPE" 
                                            column_id_value="#attributes.req_type_id#" 
                                            maxlength="500" 
                                            datasource="#dsn#" 
                                            column_id="REQ_TYPE_ID" 
                                            control_type="0">
                                    </span>				  
                                </cfif>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-9 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                            <textarea name="detail" id="detail" style="width:300px;height:45px;" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>"><cfoutput>#get_type.DETAIL#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
                
                <div class="col col-3" type="column" index="2" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-12"><cf_get_lang dictionary_id ='57493.Aktif'><input type="checkbox" name="is_active" id="is_active" value="1" <cfif GET_TYPE.IS_ACTIVE eq 1>checked</cfif> <cfif GET_REQ_FILL.RECORDCOUNT>disabled</cfif>></label>
                    </div>
                    <cfif xml_view_opt eq 1>
                    <div class="form-group" id="item-is_group_req_type">
                        <label class="col col-12"><cf_get_lang dictionary_id ='56552.Grup Yetkinliği'><input id="is_group_req_type" type="checkbox" <cfif get_type.is_group eq 1>checked</cfif> <cfif GET_REQ_FILL.RECORDCOUNT>disabled</cfif> name="is_group_req_type" value="1"></label>
                    </div>
                    </cfif>
                    <cfif xml_view_opt eq 1>
                    <div class="form-group" id="item-is_coach">
                        <label class="col col-12"><cf_get_lang dictionary_id ='56553.Koçluk'><input type="checkbox" name="is_coach" id="is_coach" value="1" <cfif GET_TYPE.IS_COACH eq 1>checked</cfif> <cfif GET_REQ_FILL.RECORDCOUNT>disabled</cfif>></label>
                    </div>
                    </cfif>
                    <div class="form-group" id="item-is_dep_admin">
                        <label class="col col-12"><cf_get_lang dictionary_id ='56554.Departman Yöneticisi'><input type="checkbox" name="is_dep_admin" id="is_dep_admin" value="1" <cfif GET_TYPE.IS_DEP_ADMIN eq 1>checked</cfif> <cfif GET_REQ_FILL.RECORDCOUNT>disabled</cfif>></label>
                    </div>
                    <div class="form-group" id="item-is_standart">
                        <label class="col col-12"><cf_get_lang dictionary_id ='56555.Standart Yeterlilik'><input type="checkbox" name="is_standart" id="is_standart" value="1" <cfif GET_TYPE.IS_STANDART eq 1>checked</cfif> <cfif GET_REQ_FILL.RECORDCOUNT>disabled</cfif>></label>
                    </div>
                </div>
        <div class="row formContentFooter">
            <div class="col col-6 col-xs-12">
                <cf_record_info query_name="get_type">
            </div>
            <div class="col col-6 col-xs-12">
                <cfif GET_REQ_FILL.RECORDCOUNT>
                    <cf_workcube_buttons is_upd='0' is_delete='0' is_cancel="0" is_insert="0">
                <cfelse>
                    <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_pos_req_type&REQ_TYPE_ID=#attributes.REQ_TYPE_ID#'>
                </cfif>
            </div>
        </div>
		</cf_box_elements>	
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="55638.Performans Form Kullanım Alanları: Yetkinlik Hangi birim, pozisyon, üyelerde ve yıllarda geçerli?"></cfsavecontent>
    <cf_box title="#message#">
        <cf_relation_segment
            is_upd='1'
            is_form='1'
            field_id='#attributes.req_type_id#'
            table_name='POSITION_REQ_TYPE'
            action_table_name='RELATION_SEGMENT'
            select_list='1,2,3,4,5,6,7,8,10'>
    </cf_box>
</cfform>
        <div class="row">
            <div class="col col-12 uniqueRow">
                <div class="row formContent">
                    <cfif get_chapter.recordcount>
                    	<cfloop query="get_chapter">
							<cfset attributes.CHAPTER_ID = GET_CHAPTER.CHAPTER_ID>
                            <cfset attributes.is_fill=GET_REQ_FILL.RECORDCOUNT>
                            <cfinclude template="form_chapter_question.cfm">
                        </cfloop>
                    </cfif>
                </div>
            </div>
        </div>
    </div> 
 </div>