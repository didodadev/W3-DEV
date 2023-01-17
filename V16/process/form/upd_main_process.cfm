<cfquery name="get_main_process" datasource="#DSN#">
	SELECT #dsn#.Get_Dynamic_Language(PROCESS_MAIN_ID,'#session.ep.language#','PROCESS_MAIN','PROCESS_MAIN_HEADER',NULL,NULL,PROCESS_MAIN_HEADER) AS PROCESS_NAME,* FROM PROCESS_MAIN WHERE PROCESS_MAIN_ID = #attributes.process_id#
</cfquery>
<cfquery name="get_process_type" datasource="#dsn#">
	SELECT
        PMR.PROCESS_MAIN_ROW_ID,
        PMR.PROCESS_ID,
        PMR.PROCESS_CAT_ID,
        #dsn#.Get_Dynamic_Language(PROCESS_MAIN_ROW_ID,'#session.ep.language#','PROCESS_MAIN_ROWS','DESIGN_TITLE',NULL,NULL,DESIGN_TITLE) AS DESIGN_TITLE,
        PMR.DESIGN_OBJECT_TYPE,
		CASE WHEN (PMR.PROCESS_ID IS NOT NULL) 
            THEN
                (SELECT #dsn#.Get_Dynamic_Language(PROCESS_ID,'#session.ep.language#','PROCESS_TYPE','PROCESS_NAME',NULL,NULL,PROCESS_NAME) AS PROCESS_NAME FROM PROCESS_TYPE WHERE PROCESS_ID = PMR.PROCESS_ID)
            ELSE
                (SELECT #dsn#.Get_Dynamic_Language(PROCESS_CAT_ID,'#session.ep.language#','#dsn3_alias#.SETUP_PROCESS_CAT','PROCESS_CAT',NULL,NULL,PROCESS_CAT) AS PROCESS_CAT FROM #dsn3_alias#.SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID = PMR.PROCESS_CAT_ID)
            END AS title,
        CASE WHEN (PMR.PROCESS_ID IS NOT NULL) 
            THEN
                (SELECT IS_ACTIVE FROM PROCESS_TYPE WHERE PROCESS_ID = PMR.PROCESS_ID)
            ELSE
                1
            END AS is_active
    FROM
        PROCESS_MAIN_ROWS PMR
    WHERE
        PMR.PROCESS_MAIN_ID = #attributes.process_id#
    ORDER BY
    	RECORD_DATE
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="upd_process" method="post" action="#request.self#?fuseaction=process.emptypopup_upd_main_process">
            <input type="hidden" name="process_id" id="process_id" value="<cfoutput>#attributes.process_id#</cfoutput>">
            <cf_box_elements vertical="1">
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_name">
                        <label><cf_get_lang dictionary_id='36294.Süreç Adı'>*</label>
                        <div class="input-group">
                            <cfinput type="Text" name="process_name" value="#get_main_process.PROCESS_NAME#" maxlength="200">
                            <span class="input-group-addon">
                                <cf_language_info
                                    table_name="PROCESS_MAIN"
                                    column_name="PROCESS_MAIN_HEADER"
                                    column_id_value="#attributes.process_id#"
                                    maxlength="500"
                                    datasource="#dsn#"
                                    column_id="PROCESS_MAIN_ID"
                                    control_type="0">
                            </span>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">    
                    <div class="form-group" id="item-project_id">
                        <label><cf_get_lang dictionary_id='57416.Proje'></label>
                        <div class="input-group">
                            <cfoutput>
                            <input type="hidden" name="project_id" id="project_id" value="<cfif len(get_main_process.project_id)>#get_main_process.project_id#</cfif>">
                            <input name="project_head" type="text" id="project_head" value="<cfif len(get_main_process.project_id)>#get_project_name(get_main_process.project_id)#</cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_head=upd_process.project_head&project_id=upd_process.project_id');"></span>				
                            </cfoutput>
                        </div>                       
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">    
                    <div class="form-group" id="item-detail">
                        <label><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <textarea name="detail" id="detail"><cfoutput>#get_main_process.PROCESS_MAIN_DETAIL#</cfoutput></textarea>
                    </div>
                </div>
                
            </cf_box_elements> 

            <cf_box_footer>
                <cfif get_process_type.recordcount neq 0>
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function='check()'>
                <cfelse>
                    <cf_workcube_buttons is_upd='1' is_delete='1'  delete_page_url='#request.self#?fuseaction=process.emptypopup_upd_main_process&process_id=#attributes.process_id#&action_type=1' add_function='check()'>
                </cfif>
            </cf_box_footer>
        </cfform>
        <cfsavecontent  variable="head"><cf_get_lang dictionary_id='32509.Süreçler'> </cfsavecontent>
        <cf_seperator title="#head#" id="stages_part">
            <div id="stages_part">
            <cf_flat_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58859.Süreç'></th>  
                        <th><cf_get_lang dictionary_id='36202.Aşamalar'></th>
                        <th><cf_get_lang dictionary_id='57756.Durum'></th>
                        <th width="20"><i class="fa fa-sitemap"></i></th>
                        <th width="20" class="header_icn_none"><a href="<cfoutput>#request.self#?fuseaction=process.list_process&event=add<cfif isdefined('attributes.process_id') and len(attributes.process_id)>&process_id=#attributes.process_id#</cfif></cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_process_type.recordcount>
                        <cfoutput query="get_process_type">                 
                            <tr>
                                <td valign="top" nowrap>
                                    <cfif DESIGN_OBJECT_TYPE eq 0>
                                        <a href="#request.self#?fuseaction=process.list_process&event=upd&process_id=#process_id#" class="tableyazi">#title#</a></td>
                                            <cfquery name="GET_STAGES" datasource="#DSN#">
                                                SELECT #dsn#.Get_Dynamic_Language(PROCESS_ROW_ID,'#session.ep.language#','PROCESS_TYPE_ROWS','STAGE',NULL,NULL,STAGE) AS STAGE,LINE_NUMBER FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID = #PROCESS_ID# ORDER BY LINE_NUMBER
                                            </cfquery>
                                    <cfelseif DESIGN_OBJECT_TYPE eq 1>
                                        <a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_form_upd_process_cat&process_cat_id=#PROCESS_CAT_ID#','wide');">#title#</a></td>
                                    <cfelse>
                                        #DESIGN_TITLE#
                                    </cfif>
                                </td>
                                <td>
                                    <cfif DESIGN_OBJECT_TYPE eq 0>
                                        <cfloop query="get_stages">
                                            <cfif line_number eq 1>
                                                <cfset style="background-color:rgba(93,120,255,.1);color:##5d78ff;margin-right:5px">
                                            <cfelseif line_number eq 2>
                                                <cfset style="background-color:rgba(255,184,34,.1);color:##ffb822;margin-right:5px">
                                            <cfelseif  line_number eq 3>
                                                <cfset style="background-color:rgba(10,187,135,.1);color:##0abb87;margin-right:5px">
                                            <cfelseif line_number eq 4>
                                                <cfset style="background-color:rgba(253,57,122,.1);color:##fd397a;margin-right:5px">
                                            <cfelseif  line_number eq 5>
                                                <cfset style="background-color:rgba(147,112,210,.1);;color:##673ab7;margin-right:5px">
                                            <cfelse>
                                                <cfset style="background-color:rgba(112,219,232,0.1);;color:##0d99d8;margin-right:5px;">
                                            </cfif>
                                            <span class="ui-stage" style="#style#"> #stage# </span>
                                        </cfloop><br />
                                    <cfelseif DESIGN_OBJECT_TYPE eq 1>
                                        <cf_get_lang dictionary_id='36305.İşlem Kategorisi'>
                                    <cfelse>
                                        <cf_get_lang dictionary_id='36306.Ek Fonksiyon'>
                                    </cfif>
                                </td>
                                <td><cfif get_process_type.is_active is 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                                <td>
                                    <cfif DESIGN_OBJECT_TYPE eq 0>
                                        <a href="#request.self#?fuseaction=process.visual_designer&process_id=#process_id#"><i class="fa fa-sitemap" alt="<cf_get_lang dictionary_id='36170.Visual Designer'>" title="<cf_get_lang dictionary_id='36170.Visual Designer'>"></i></a>
                                    </cfif>
                                </td>
                                <td>
                                    <cfif DESIGN_OBJECT_TYPE eq 0>
                                        <a href="#request.self#?fuseaction=process.list_process&event=upd&process_id=#process_id#"><i class="fafa-pencil" title="<cf_get_lang dictionary_id ='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                    <cfelseif DESIGN_OBJECT_TYPE eq 1>
                                        <a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_form_upd_process_cat&process_cat_id=#PROCESS_CAT_ID#','wide');"><i class="fa fa-pencil"></i></a></td>
                                    </cfif>
                                </td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_flat_list>
        </div>
    </cf_box>
    <cfset action_section = "PROCESS_MAIN">
    <cfset relative_id = attributes.process_id>
    <cfinclude template="../../process/display/list_designer.cfm"> 
    <cf_get_workcube_content action_type ='MAIN_PROCESS_ID' style="box-shadow:none;" action_type_id ='#attributes.process_id#' design='1' come_project='1'>
</div>
<script type="text/javascript">
	function check()
	{
		if (document.upd_process.process_name.value == '')
		{
			alert("<cf_get_lang dictionary_id='36208.Süreç Adı Girmelisiniz'> !");
			return false;
		} 
		else
		return true;
	}
</script>
