<cfif (not isdefined("attributes.id")) and (not isdefined("attributes.user_group_id"))>
	<cfexit method="exittemplate">
</cfif>
<cfparam name="attributes.modal_id" default="">
<cfif isdefined("attributes.id")>
	<cfquery name="get_pos_code" datasource="#DSN#">
	  SELECT 
		  POSITION_CAT_ID, 
		  IS_MASTER, 
		  POSITION_CODE, 
		  EMPLOYEE_ID, 
		  EMPLOYEE_NAME, 
		  EMPLOYEE_SURNAME, 
		  POSITION_NAME, 
		  USER_GROUP_ID
	  FROM 
		  EMPLOYEE_POSITIONS 
	  WHERE 
		  POSITION_CAT_ID =  #attributes.id#
	</cfquery>
<cfelse>
	<cfquery name="get_pos_code" datasource="#DSN#">
		SELECT 
			POSITION_CAT_ID, 
			IS_MASTER, 
			POSITION_CODE, 
			EMPLOYEE_ID, 
			EMPLOYEE_NAME, 
			EMPLOYEE_SURNAME, 
			POSITION_NAME, 
			USER_GROUP_ID
		FROM 
			EMPLOYEE_POSITIONS 
		WHERE 
			USER_GROUP_ID =  #attributes.USER_GROUP_ID#
	</cfquery>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Yetki Grupları','42144')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="user_pd_form" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_pos_code_denied&faction=#faction#">
            <cf_box_search>
                <div class="form-group">
                    <td><cf_get_lang dictionary_id='57581.Sayfa'></td>
                    <td><input type="text" name="modul_name" id="modul_name" value="<cfoutput>#attributes.modul_name#</cfoutput>" style="width:100px;" readonly="yes"></td>
                </div>
                <div class="form-group">
                    <input type="text" name="faction" id="faction" value="<cfoutput>#attributes.faction#</cfoutput>" style="width:160px;" readonly="yes">
                    <input type="hidden" name="faction_id" id="faction_id" value="">
                </div>
                <div class="form-group">
                    <cfset denied_page_ = "#attributes.modul_name#.#attributes.faction#">
                    <cfquery name="get_denied_type" datasource="#dsn#" maxrows="1">
                        SELECT 
                            DENIED_TYPE,
                            RECORD_EMP,
                            RECORD_DATE
                        FROM 
                            EMPLOYEE_POSITIONS_DENIED
                        WHERE 
                            DENIED_PAGE = '#denied_page_#'
                        ORDER BY 
                            RECORD_DATE DESC
                    </cfquery>
                    <cfif get_denied_type.recordcount>
                        <cfif len(get_denied_type.DENIED_TYPE) and get_denied_type.DENIED_TYPE eq 1>
                            <input type="hidden" name="denied_type" id="denied_type" value="1">
                            <cf_get_lang dictionary_id='43065.Bu Sayfa İzin Sistemine Göre Çalışır'>.
                        <cfelse>
                            <cf_get_lang dictionary_id='43080.Bu Sayfa Yasak Sistemine Göre Çalışır'>.
                        </cfif>
                    <cfelse>
                        <font color="FF0000">(<cf_get_lang dictionary_id='43085.Seçili ise İzin Ayarlar,Seçili değil ise Yasak Ayarlar'>...)</font><input type="Checkbox" name="denied_type" id="denied_type" value="1"><cf_get_lang dictionary_id='43435.İzin Sistemi'>
                    </cfif>
                </div>
            </cf_box_search>
            <cf_grid_list>
                <thead>
                    <tr class="color-row">
                        <td colspan="2"><cf_get_lang dictionary_id='58081.Hepsi'></td>
                        <td><input type="Checkbox" name="all_view" id="all_view" value="1" onclick="hepsi_view();"></td>
                        <td><input type="Checkbox" name="all_insert" id="all_insert" value="1" onclick="hepsi_insert();"></td>
                        <td><input type="Checkbox" name="all_delete" id="all_delete" value="1" onclick="hepsi_delete();"></td>
                    </tr>
                </thead>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='31358.Pozisyonlar'></th>
                        <th><cf_get_lang dictionary_id='30370.Çalışanlar'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='44843.View'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='44844.Insert'></th>
                        <th class="text-center"><cf_get_lang dictionary_id='44845.Delete'></th>
                    </tr>
                </thead>
                <cfif get_pos_code.RECORDCOUNT>
                    <tbody>
                        <cfoutput query="get_pos_code">
                            <cfquery name="GET_NAME" datasource="#DSN#">
                                SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,POSITION_NAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #POSITION_CODE#
                            </cfquery>
                            <cfset faction1 = '#attributes.modul_name#.#attributes.faction#'>
                            <cfquery name="CONTROL" datasource="#DSN#">
                                SELECT 
                                    DENIED_PAGE_ID, 
                                    POSITION_CODE, 
                                    POSITION_CAT_ID, 
                                    MODULE_ID,
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
                                    POSITION_CODE = #POSITION_CODE# AND  DENIED_PAGE ='#faction1#' AND  (POSITION_CAT_ID IS NULL AND USER_GROUP_ID IS NULL)
                            </cfquery>
                            <tr>
                                <td height="20">#GET_NAME.POSITION_NAME#</td>
                                <td height="20"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#GET_NAME.employee_id#','medium')" class="tableyazi">#GET_NAME.EMPLOYEE_NAME# #GET_NAME.EMPLOYEE_SURNAME#</a></td>
                                <td>
                                    <input type="checkbox" name="is_view_" id="is_view_" value="#POSITION_CODE#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_VIEW EQ 1)>checked </cfif>>
                                </td>
                                <td>
                                    <input type="checkbox" name="is_insert_" id="is_insert_" value="#POSITION_CODE#" <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_INSERT EQ 1)>checked</cfif>>
                                </td>
                                <td>
                                    <input type="checkbox" name="is_delete_" id="is_delete_" value="#POSITION_CODE#"  <cfif (CONTROL.RECORDCOUNT) AND (CONTROL.IS_DELETE EQ 1)>checked </cfif>>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>
                    <input type="hidden" name="LIST" id="LIST" value="<cfoutput>#valuelist(get_pos_code.POSITION_CODE)#</cfoutput>">			
                    <cfif isdefined("attributes.id")>
                        <input type="hidden" name="position_cat_id" id="position_cat_id" value="<cfoutput>#attributes.id#</cfoutput>">	
                    <cfelse>
                        <input type="hidden" name="user_group_id" id="user_group_id" value="<cfoutput>#attributes.user_group_id#</cfoutput>">
                    </cfif>						
                </cfif>
            </cf_grid_list>
            <cf_box_footer>
                <cf_record_info query_name="get_denied_type">
                <cf_workcube_buttons button_type="4" add_function="controlPageType()" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('user_pd_form' , #attributes.modal_id#)"),DE(""))#">
            </cf_box_footer>
    </cfform>
</cf_box>
</div>
<script type="text/javascript">
function hepsi_view()
{
	if (document.user_pd_form.all_view.checked)
		{
		for(i=0;i<document.user_pd_form.is_view_.length;i++)
			document.user_pd_form.is_view_[i].checked = true;
	     }
	 else
	     {
		  for(i=0;i<document.user_pd_form.is_view_.length;i++)
			document.user_pd_form.is_view_[i].checked = false;
		 }
}
 function hepsi_insert()
 {
   
    if (document.user_pd_form.all_insert.checked) 
		{
		for(i=0;i<document.user_pd_form.is_insert_.length;i++)
			document.user_pd_form.is_insert_[i].checked = true;
        }
	 else
	     {
		  for(i=0;i<document.user_pd_form.is_insert_.length;i++)
			document.user_pd_form.is_insert_[i].checked = false;
		 }
 }
 
 function hepsi_delete()
 {
		
	if (document.user_pd_form.all_delete.checked)
	    {	
		for(i=0;i<document.user_pd_form.is_delete_.length;i++)
			document.user_pd_form.is_delete_[i].checked = true;
		}
	else
		{
		for(i=0;i<document.user_pd_form.is_delete_.length;i++)
			document.user_pd_form.is_delete_[i].checked = false;

		}
}

function controlPageType() 
{
    <cfif not isdefined("attributes.draggable")>
        window.close();
    <cfelse>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
    </cfif> 
}
</script>
