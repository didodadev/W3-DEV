<cfif (not isdefined("attributes.id")) and (not isdefined("attributes.user_group_id"))>
	<cfexit method="exittemplate">
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("attributes.user_group_id")>
	<cfquery name="get_user_group" datasource="#dsn#">
		SELECT 
			POSITION_CODE,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_ID 
		FROM 
			EMPLOYEE_POSITIONS
		WHERE 
			USER_GROUP_ID = #attributes.USER_GROUP_ID# ORDER BY EMPLOYEE_NAME
	</cfquery>
<cfelse>
	<cfquery name="get_pos_code" datasource="#dsn#">
		SELECT 
			POSITION_CODE,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_ID 
		FROM 
			EMPLOYEE_POSITIONS
		WHERE 
			POSITION_CAT_ID = #attributes.id# ORDER BY EMPLOYEE_NAME
	</cfquery>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfform name="add_faction" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_perm_pos_code">
        <cf_box title="#getLang('','Yetki Grupları','42144')#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
            <cf_box_search more="0">
                <div class="form-group">
                    <input type="text" name="modul_name" id="modul_name" placeholder="<cfoutput>#getLang('','Report','52714')#</cfoutput>" value="<cfoutput>#attributes.modul_name#</cfoutput>" readonly="yes">
                </div>
                <div class="form-group">
                    <input type="text" name="faction" id="faction" placeholder="<cfoutput>#getLang('','Fuseaction','36185')#</cfoutput>" value="<cfoutput>#attributes.faction#</cfoutput>" readonly="yes">
                    <input type="hidden" name="faction_id" id="faction_id" value="">
                </div>
                <div class="form-group">
                    <div class="input-group"> 
                        <cfset denied_page_ = "#attributes.modul_name#.#attributes.faction#">
                        <cfquery name="get_denied_type" datasource="#dsn#" maxrows="1">
                            SELECT 
                                DENIED_TYPE 
                            FROM 
                                EMPLOYEE_POSITIONS_DENIED
                            WHERE 
                                DENIED_PAGE = '#denied_page_#'
                        </cfquery>
                        <cfif get_denied_type.recordcount>
                            <cfif len(get_denied_type.DENIED_TYPE) and get_denied_type.DENIED_TYPE eq 1>
                                <input type="hidden" name="denied_type" id="denied_type" value="1">
                                <cf_get_lang dictionary_id='43065.Bu Sayfa İzin Sistemine Göre Çalışır'>
                            <cfelse>
                                <cf_get_lang dictionary_id='43080.Bu Sayfa Yasak Sistemine Göre Çalışır'>
                            </cfif>
                        <cfelse>
                        </cfif>
                    </div>
                </div>
                <div class="form-group">
                    <label>
                        <cf_get_lang dictionary_id='43435.İzin Sistemi'>
                        <input type="Checkbox" name="denied_type" id="denied_type" value="1">
                    </label>
                    <font color="FF0000">(<cf_get_lang dictionary_id='43085.Seçili ise İzin Ayarlar,Seçili değil ise Yasak Ayarlar'>...)</font>
                </div>
            </cf_box_search>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='31358.Pozisyonlar'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='44843.View'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='44844.Insert'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='44845.Delete'></th>
                    </tr>
                </thead>
                <thead>
                    <tr class="color-row">
                        <td class="txtboldblue"><cf_get_lang dictionary_id='58081.Hepsi'></td>
                        <td align="center"><input type="Checkbox" name="all_view" id="all_view" value="1" onclick="hepsi_view();"></td>
                        <td align="center"><input type="Checkbox" name="all_insert" id="all_insert" value="1" onclick="hepsi_insert();"></td>
                        <td align="center"><input type="Checkbox" name="all_delete" id="all_delete" value="1" onclick="hepsi_delete();"></td>
                    </tr>
                </thead>
                <cfset faction1 = '#attributes.modul_name#.#attributes.faction#'>
                <cfif isdefined("get_pos_code.RECORDCOUNT") and get_pos_code.RECORDCOUNT>
                    <tbody>
                        <cfoutput query="get_pos_code">
                            <cfif len(EMPLOYEE_NAME) and len(EMPLOYEE_SURNAME)>
                                <cfquery name="CONTROL" datasource="#DSN#">
                                    SELECT 
                                        DENIED_PAGE_ID, 
                                        POSITION_CODE, 
                                        POSITION_CAT_ID, 
                                        MODULE_ID, 
                                        FUSEACTION_ID, 
                                        DENIED_PAGE, 
                                        IS_VIEW, 
                                        IS_DELETE, 
                                        IS_INSERT, 
                                        USER_GROUP_ID, 
                                        DENIED_TYPE, 
                                        RECORD_EMP, 
                                        RECORD_DATE, 
                                        RECORD_IP
                                    FROM 
                                        EMPLOYEE_POSITIONS_DENIED 
                                    WHERE 
                                        POSITION_CODE = #get_pos_code.POSITION_CODE# AND  DENIED_PAGE ='#faction1#' AND (POSITION_CAT_ID IS NULL AND USER_GROUP_ID IS NULL)
                                </cfquery>
                                <tr>
                                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium')" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                                    <td align="center"><input type="checkbox" name="is_view_" id="is_view_" value="#POSITION_CODE#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_VIEW EQ 1)>checked </cfif>>
                                    </td>
                                    <td align="center"><input type="checkbox" name="is_insert_" id="is_insert_" value="#POSITION_CODE#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_INSERT EQ 1)>checked </cfif>>
                                    </td>
                                    <td align="center"><input type="checkbox" name="is_delete_" id="is_delete_" value="#POSITION_CODE#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_DELETE EQ 1)>checked </cfif>>
                                    </td>
                                </tr>
                            </cfif>
                        </cfoutput>
                    </tbody>
                    <input type="hidden" name="LIST" id="LIST" value="<cfoutput>#valuelist(get_pos_code.POSITION_CODE)#</cfoutput>">
                    <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
                <cfelseif isdefined("get_user_group.RECORDCOUNT") and get_user_group.recordcount>
                    <cfoutput query="get_user_group">
                        <cfif len(EMPLOYEE_NAME) and len(EMPLOYEE_SURNAME)>
                            <cfquery name="CONTROL" datasource="#DSN#">
                                SELECT 
                                    DENIED_PAGE_ID, 
                                    POSITION_CODE, 
                                    POSITION_CAT_ID, 
                                    MODULE_ID, 
                                    FUSEACTION_ID, 
                                    DENIED_PAGE, 
                                    IS_VIEW, 
                                    IS_DELETE, 
                                    IS_INSERT, 
                                    USER_GROUP_ID, 
                                    DENIED_TYPE, 
                                    RECORD_EMP, 
                                    RECORD_DATE, 
                                    RECORD_IP
                                FROM 
                                    EMPLOYEE_POSITIONS_DENIED 
                                WHERE 
                                    POSITION_CODE = #get_user_group.POSITION_CODE# AND  DENIED_PAGE ='#faction1#' AND (POSITION_CAT_ID IS NULL AND USER_GROUP_ID IS NULL)
                            </cfquery>
                            <tr>
                                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium')" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></td>
                                <td align="center"><input type="checkbox" name="is_view_" id="is_view_" value="#POSITION_CODE#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_VIEW EQ 1)>checked </cfif>>
                                </td>
                                <td align="center"><input type="checkbox" name="is_insert_" id="is_insert_" value="#POSITION_CODE#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_INSERT EQ 1)>checked </cfif>>
                                </td>
                                <td align="center"><input type="checkbox" name="is_delete_" id="is_delete_" value="#POSITION_CODE#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_DELETE EQ 1)>checked </cfif>>
                                </td>
                            </tr>
                        </cfif>
                    </cfoutput>
                    <input type="hidden" name="LIST" id="LIST" value="<cfoutput>#valuelist(get_user_group.POSITION_CODE)#</cfoutput>">
                    <input type="hidden" name="user_group_id" id="user_group_id" value="<cfoutput>#attributes.user_group_id#</cfoutput>">
                </cfif>
            </cf_grid_list>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cf_box>
    </cfform>
</div>
<script type="text/javascript">
 function hepsi_view()
{
	if (document.add_faction.all_view.checked)
		{
		/*document.add_faction.survey_guest.checked = true;*/
		for(i=0;i<document.add_faction.is_view_.length;i++)
			document.add_faction.is_view_[i].checked = true;
	     }
	 else
	     {
		  for(i=0;i<document.add_faction.is_view_.length;i++)
			document.add_faction.is_view_[i].checked = false;
		 }
}
 function hepsi_insert()
 {
   
    if (document.add_faction.all_insert.checked) 
		{
		for(i=0;i<document.add_faction.is_insert_.length;i++)
			document.add_faction.is_insert_[i].checked = true;
        }
	 else
	     {
		  for(i=0;i<document.add_faction.is_insert_.length;i++)
			document.add_faction.is_insert_[i].checked = false;
		 }
 }
 
 function hepsi_delete()
 {
		
	if (document.add_faction.all_delete.checked)
	    {	
		for(i=0;i<document.add_faction.is_delete_.length;i++)
			document.add_faction.is_delete_[i].checked = true;
		}
	else
		{
		/*document.add_faction.survey_guest.checked = false;*/
		for(i=0;i<document.add_faction.is_delete_.length;i++)
			document.add_faction.is_delete_[i].checked = false;

		}
}
</script>
