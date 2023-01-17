<cfquery name="GET_DENIED_PAGE" datasource="#DSN#">
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
	    DENIED_PAGE = '#URL.FACTION#' AND (POSITION_CAT_ID IS NOT NULL OR USER_GROUP_ID IS NOT NULL OR POSITION_CODE IS NOT NULL) 
    ORDER BY 
    	RECORD_DATE DESC
</cfquery>
<cfquery name="GET_USER_GROUPS" datasource="#DSN#">
	SELECT USER_GROUP_ID,USER_GROUP_NAME FROM USER_GROUP ORDER BY USER_GROUP_NAME
</cfquery> 
<cfquery name="GET_POS_NAME" datasource="#DSN#">
	SELECT POSITION_CAT,POSITION_CAT_ID FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery> 
<cfquery name="CONTROL_POS" datasource="#DSN#">
	SELECT 
		EP.POSITION_CAT_ID,
		EP.USER_GROUP_ID
	FROM 
		EMPLOYEE_POSITIONS_DENIED EPD,
		EMPLOYEE_POSITIONS EP
	WHERE 
		EPD.DENIED_PAGE = '#URL.FACTION#' AND
		EPD.POSITION_CODE IS NOT NULL AND
		EPD.POSITION_CODE = EP.POSITION_CODE
</cfquery>
<cfif control_pos.recordcount>
	<cfset position_position_cat_list = listdeleteduplicates(valuelist(control_pos.position_cat_id))>
	<cfset position_user_group_list = listdeleteduplicates(valuelist(control_pos.user_group_id))>
<cfelse>
	<cfset position_position_cat_list = ''>
	<cfset position_user_group_list = ''>
</cfif>
<cfset list=''>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="upd_form" action="#request.self#?fuseaction=settings.emptypopup_upd_denied&faction_old=#get_denied_page.denied_page#" method="post">
		<cf_box>
			<cf_box_search more="0">
				<div class="form-group">
					<cf_get_lang dictionary_id='57581.Sayfa'>
				</div>
				<div class="form-group">
					<cfinput type="text" name="modul_name" value="#listfirst(faction,".")#" required="yes" message="#getLang('','Modül Adı Girmelisiniz','43955')#">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfinput type="text" name="faction" value="#listlast(attributes.faction,".")#" required="yes" message="#getLang('','Fuseaction Adı Girmelisiniz','43956')#">
						<input type="hidden" name="faction_id" id="faction_id" value="">
						<cfinput type="hidden" name="faction_old" id="faction_old" value="#get_denied_page.denied_page#">

						<cfif not listfindnocase(denied_pages,'settings.popup_faction_list')>
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.popup_faction_list&field_faction_id=upd_form.faction_id&field_faction=upd_form.faction&field_modul=upd_form.modul_name</cfoutput>');"></span>
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<cfset denied_page_ = "#attributes.faction#">
					<cfquery name="GET_DENIED_TYPE" datasource="#DSN#" maxrows="1">
						SELECT DENIED_TYPE FROM EMPLOYEE_POSITIONS_DENIED WHERE DENIED_PAGE = '#denied_page_#'
					</cfquery>
					<cfif get_denied_type.recordcount>
						<cfif len(get_denied_type.DENIED_TYPE) and get_denied_type.DENIED_TYPE eq 1>
							<input type="hidden" name="denied_type" id="denied_type" value="1">
							<cf_get_lang dictionary_id='43961.Bu Sayfa'><font color="FF0000"><b><cf_get_lang dictionary_id='58575.İzin'></b></font> <cf_get_lang dictionary_id='43962.Sistemine Göre Çalışır'>
						<cfelse>
							<cf_get_lang dictionary_id='43961.Bu Sayfa'><font color="FF0000"><b><cf_get_lang dictionary_id='43963.Yasak'></b></font> <cf_get_lang dictionary_id='43962.Sistemine Göre Çalışır'>
						</cfif>
					<cfelse>
						<font color="FF0000">(<cf_get_lang dictionary_id='43620.Seçili ise İzin Ayarlar'>,<cf_get_lang dictionary_id='43621.Seçili değil ise Yasak Ayarlar'>...)</font><input type="Checkbox" name="denied_type" id="denied_type" value="1"><cf_get_lang dictionary_id='43435.İzin Sistemi'>
					</cfif>
				</div>
			</cf_box_search>
		</cf_box>
		<cf_box>
			<cf_grid_list>
				<thead>
					<tr class="color-row">
						<td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id='33746.Hepsini Seç'></td>
						<td align="center"><input type="Checkbox" name="all_view" id="all_view" value="1" onclick="hepsi_view('all');"></td>
						<td align="center"><input type="Checkbox" name="all_insert" id="all_insert" value="1" onclick="hepsi_insert('all');"></td>
						<td align="center"><input type="Checkbox" name="all_delete" id="all_delete" value="1" onclick="hepsi_delete('all');"></td>
					</tr>
					<tr class="color-row">
						<td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id='57734.Seçiniz'></td>
						<td align="center"><input type="Checkbox" name="all_group_view" id="all_group_view" value="1" onclick="hepsi_view('group');"></td>
						<td align="center"><input type="Checkbox" name="all_group_insert" id="all_group_insert" value="1" onclick="hepsi_insert('group');"></td>
						<td align="center"><input type="Checkbox" name="all_group_delete" id="all_group_delete" value="1" onclick="hepsi_delete('group');"></td>
					</tr>
				</thead>
				<thead>
					<tr>
						<th width="30"><i class="fa fa-plus" align="absmiddle" border="0"></i></th>
						<th><cf_get_lang dictionary_id='42144.Yetki Grupları'></th>
						<th class="text-center"><cf_get_lang dictionary_id='44843.View'></th>                    
						<th class="text-center"><cf_get_lang dictionary_id='44844.Insert'></th> 
						<th class="text-center"><cf_get_lang dictionary_id='44845.Delete'></th> 
					</tr>
				</thead>
				<tbody>
					<cfoutput query="get_user_groups">
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td class="text-center"><span href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_user_denied1&user_group_id=#user_group_id#&faction=#listlast(faction,".")#&modul_name=#listfirst(faction,".")#');return false"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'> align="absmiddle" border="0""></i></span> </td>
							<td>							
								#user_group_name# <cfif listlen(position_user_group_list) and listfindnocase(position_user_group_list,user_group_id)>(*)</cfif>
							</td>
							<td align="center">
								<cfquery name="GET_POS_CAT_CONTROL2" dbtype="query">
									SELECT * FROM GET_DENIED_PAGE WHERE DENIED_PAGE = '#url.faction#' AND USER_GROUP_ID = #get_user_groups.user_group_id#
								</cfquery>
								<input type="checkbox" name="is_view_group_" id="is_view_group_" value="#get_user_groups.user_group_id#"  <cfif (get_pos_cat_control2.recordcount) and (get_pos_cat_control2.is_view eq 1)> checked</cfif>>
							</td>
							<td align="center">
								<input type="checkbox" name="is_insert_group_" id="is_insert_group_" value="#get_user_groups.user_group_id#" <cfif (get_pos_cat_control2.recordcount) and (get_pos_cat_control2.is_insert eq 1)> checked</cfif>>
							</td>
							<td align="center">
								<input type="checkbox" name="is_delete_group_" id="is_delete_group_" value="#get_user_groups.user_group_id#" <cfif (get_pos_cat_control2.recordcount) and (get_pos_cat_control2.is_delete eq 1)> checked</cfif>> 
							</td>                    
						</tr>
					</cfoutput>
				</tbody>
				<thead>
					<tr class="color-row">
						<td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id='57734.Seçiniz'></td>
						<td align="center"><input type="Checkbox" name="all_pos_view" id="all_pos_view" value="1" onclick="hepsi_view('pos');"></td>
						<td align="center"><input type="Checkbox" name="all_pos_insert" id="all_pos_insert" value="1" onclick="hepsi_insert('pos');"></td>
						<td align="center"><input type="Checkbox" name="all_pos_delete" id="all_pos_delete" value="1" onclick="hepsi_delete('pos');"></td>
					</tr>
					<tr>
						<th><i class="fa fa-plus" align="absmiddle" border="0"></i></th>
						<th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
						<th class="text-center"><cf_get_lang dictionary_id='44843.View'></th>                    
						<th class="text-center"><cf_get_lang dictionary_id='44844.Insert'></th> 
						<th class="text-center"><cf_get_lang dictionary_id='44845.Delete'></th> 
					</tr>
				</thead>
				<tbody>
					<cfoutput query="get_pos_name">
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td class="text-center"><span href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_user_denied1&id=#position_cat_id#&faction=#listlast(faction,".")#&modul_name=#listfirst(faction,".")#');return false"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" align="absmiddle" border="0"></i></span></td>
							<td>#position_cat# <cfif listlen(position_position_cat_list) and listfindnocase(position_position_cat_list,position_cat_id)>(*)</cfif></td>
							<td align="center">
								<cfquery name="GET_POS_CAT_CONTROL" dbtype="query">
									SELECT * FROM get_denied_page WHERE DENIED_PAGE = '#url.faction#' AND POSITION_CAT_ID = #position_cat_id#
								</cfquery>
								<input type="checkbox" name="is_view_" id="is_view_" value="#position_cat_id#"  <cfif (get_pos_cat_control.recordcount) and (get_pos_cat_control.is_view eq 1)> checked</cfif>>
							</td>
							<td align="center"><input type="checkbox" name="is_insert_" id="is_insert_" value="#position_cat_id#" <cfif (get_pos_cat_control.recordcount) and (get_pos_cat_control.is_insert eq 1)> checked</cfif>></td>
							<td align="center"><input type="checkbox" name="is_delete_" id="is_delete_" value="#position_cat_id#" <cfif (get_pos_cat_control.recordcount) and (get_pos_cat_control.is_delete eq 1)> checked</cfif>></td>                    
						</tr>
					</cfoutput>	
				</tbody>
				<input type="hidden" name="list" id="list" value="<cfoutput>#valuelist(get_pos_name.position_cat_id)#</cfoutput>">
				<input type="hidden" name="list_group" id="list_group" value="<cfoutput>#valuelist(get_user_groups.user_group_id)#</cfoutput>">
				<input type="hidden" name="id" id="id" value="">
			</cf_grid_list>
			<cf_box_footer>
				<cfif len(get_denied_page.record_emp)>
					<cf_record_info query_name="get_denied_page">
				</cfif>
				<cfif get_denied_page.recordcount>
					<cf_workcube_buttons 
						is_upd='1'
						is_delete='1'
						delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_denied_page&deny_page=#url.faction#&denied_page_id=#get_denied_page.denied_page_id#'>
				<cfelse>
					<cf_workcube_buttons is_upd='0'>
				</cfif>
			</cf_box_footer>
		</cf_box>
</cfform>

</div>
<script type="text/javascript">
function hepsi_view(temp_view)
{
	if(temp_view == 'all')
	{
		if(document.upd_form.all_view.checked)
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.upd_form.is_view_.length;i++)
				document.upd_form.is_view_[i].checked = true;
			<cfelse>
				document.upd_form.is_view_.checked = true;
			</cfif>
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.upd_form.is_view_group_.length;i++)
				document.upd_form.is_view_group_[i].checked = true;
			<cfelse>
				document.upd_form.is_view_group_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.upd_form.is_view_.length;i++)
				document.upd_form.is_view_[i].checked = false;
			<cfelse>
				document.upd_form.is_view_.checked = false;
			</cfif>
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.upd_form.is_view_group_.length;i++)
				document.upd_form.is_view_group_[i].checked = false;
			<cfelse>
				document.upd_form.is_view_group_.checked = false;
			</cfif>
		}
	}
	else if(temp_view == 'group')
	{
		if(document.upd_form.all_group_view.checked)
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.upd_form.is_view_group_.length;i++)
				document.upd_form.is_view_group_[i].checked = true;
			<cfelse>
				document.upd_form.is_view_group_.checked = true;
			</cfif>
		else
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.upd_form.is_view_group_.length;i++)
				document.upd_form.is_view_group_[i].checked = false;
			<cfelse>
				document.upd_form.is_view_group_.checked = false;
			</cfif>
	}
	else if(temp_view == 'pos')
	{
		if(document.upd_form.all_pos_view.checked)
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.upd_form.is_view_.length;i++)
				document.upd_form.is_view_[i].checked = true;
			<cfelse>
				document.upd_form.is_view_.checked = true;
			</cfif>
		else
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.upd_form.is_view_.length;i++)
				document.upd_form.is_view_[i].checked = false;
			<cfelse>
				document.upd_form.is_view_.checked = false;
			</cfif>
	}
}

function hepsi_insert(temp_view)
{
	if(temp_view == 'all')
	{
		if(document.upd_form.all_insert.checked) 
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.upd_form.is_insert_.length;i++)
				document.upd_form.is_insert_[i].checked = true;
			<cfelse>
				document.upd_form.is_insert_.checked = true;
			</cfif>
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.upd_form.is_insert_group_.length;i++)
				document.upd_form.is_insert_group_[i].checked = true;
			<cfelse>
				document.upd_form.is_insert_group_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_pos_name.recordcount gt 1>
				for(i=0;i<document.upd_form.is_insert_.length;i++)
				document.upd_form.is_insert_[i].checked = false;
			<cfelse>
				document.upd_form.is_insert_.checked = false;
			</cfif>
			<cfif get_user_groups.recordcount gt 1>
				for(i=0;i<document.upd_form.is_insert_group_.length;i++)
				document.upd_form.is_insert_group_[i].checked = false;
			<cfelse>
				document.upd_form.is_insert_group_.checked = false;
			</cfif>
		 }
	}
	else if(temp_view == 'group')
	{
		if(document.upd_form.all_group_insert.checked) 
		{
			<cfif get_user_groups.recordcount gt 1>
			for(i=0;i<document.upd_form.is_insert_group_.length;i++)
				document.upd_form.is_insert_group_[i].checked = true;
			<cfelse>
				document.upd_form.is_insert_group_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_user_groups.recordcount gt 1>
			for(i=0;i<document.upd_form.is_insert_group_.length;i++)
				document.upd_form.is_insert_group_[i].checked = false;
			<cfelse>
				document.upd_form.is_insert_group_.checked = false;
			</cfif>
		 }
	}
	else if(temp_view == 'pos')
	{
		if(document.upd_form.all_pos_insert.checked) 
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.upd_form.is_insert_.length;i++)
				document.upd_form.is_insert_[i].checked = true;
			<cfelse>
				document.upd_form.is_insert_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.upd_form.is_insert_.length;i++)
				document.upd_form.is_insert_[i].checked = false;
			<cfelse>
				document.upd_form.is_insert_.checked = false;
			</cfif>
		 }
	}
		
}
 
function hepsi_delete(temp_view)
{
	if(temp_view == 'all')
	{
		if (document.upd_form.all_delete.checked)
		{	
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.upd_form.is_delete_.length;i++)
				document.upd_form.is_delete_[i].checked = true;
			<cfelse>
				document.upd_form.is_delete_.checked = true;
			</cfif>
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.upd_form.is_delete_group_.length;i++)
				document.upd_form.is_delete_group_[i].checked = true;
			<cfelse>
				document.upd_form.is_delete_group_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.upd_form.is_delete_.length;i++)
				document.upd_form.is_delete_[i].checked = false;
			<cfelse>
				document.upd_form.is_delete_.checked = false;
			</cfif>
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.upd_form.is_delete_group_.length;i++)
				document.upd_form.is_delete_group_[i].checked = false;
			<cfelse>
				document.upd_form.is_delete_group_.checked = false;
			</cfif>
		}
	}
	else if(temp_view == 'group')
	{
		if (document.upd_form.all_group_delete.checked)
		{	
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.upd_form.is_delete_group_.length;i++)
				document.upd_form.is_delete_group_[i].checked = true;
			<cfelse>
				document.upd_form.is_delete_group_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_user_groups.recordcount gt 1>
			for(i=0;i<document.upd_form.is_delete_group_.length;i++)
				document.upd_form.is_delete_group_[i].checked = false;
			<cfelse>
				document.upd_form.is_delete_group_.checked = false;
			</cfif>
		}
	}
	else if(temp_view == 'pos')
	{
		if (document.upd_form.all_pos_delete.checked)
		{	
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.upd_form.is_delete_.length;i++)
				document.upd_form.is_delete_[i].checked = true;
			<cfelse>
				document.upd_form.is_delete_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.upd_form.is_delete_.length;i++)
				document.upd_form.is_delete_[i].checked = false;
			<cfelse>
				document.upd_form.is_delete_.checked = false;
			</cfif>
		}
	}
}
</script>












