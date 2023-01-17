<cfquery name="get_pos_name" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<cfquery name="get_user_groups" datasource="#dsn#">
	SELECT USER_GROUP_ID,USER_GROUP_NAME FROM USER_GROUP ORDER BY USER_GROUP_NAME
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="add_form" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_perm_faction1">
    <cf_box>
		<cf_box_search more="0">
			<cfset list=''> 
			<div class="form-group">
				<cfinput type="text" name="modul_name" placeholder="#getLang('main',169)#" value="" required="yes" message="#getLang('','Modül Adı Giriniz','43955')#">
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfinput type="text" name="faction" placeholder="#getLang('settings',159)#" value="" required="yes" message="#getLang('','Fuseaction Adı Girmelisiniz','43956')#">
					<input type="hidden" name="faction_id" id="faction_id" value="">
					<cfif not listfindnocase(denied_pages,'settings.popup_faction_list')>	
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=settings.popup_faction_list&field_faction_id=add_form.faction_id&field_faction=add_form.faction&field_modul=add_form.modul_name</cfoutput>');"></span>
					</cfif>
				</div>
			</div>
			<div class="form-group">
				<label><cf_get_lang dictionary_id='43435.İzin Sistemi'></label>
				<input type="Checkbox" name="denied_type" id="denied_type" value="1"><font color="FF0000">(<cf_get_lang dictionary_id='43957.Seçili ise İzin Ayarlar Seçili değil ise Yasak Ayarlar'>...)</font>
			</div>
		</cf_box_search>
	</cf_box>
	<cf_box>
        <cfset list=''> 
        <cf_grid_list>
            <thead>
                <tr class="color-row">
                    <th colspan="2"><cf_get_lang dictionary_id='33746.Hepsini Seç'></th>
                    <th><input type="Checkbox" name="all_view" id="all_view" value="1" onclick="hepsi_view('all');"></th>
                    <th><input type="Checkbox" name="all_insert" id="all_insert" value="1" onclick="hepsi_insert('all');"></th>
                    <th><input type="Checkbox" name="all_delete" id="all_delete" value="1" onclick="hepsi_delete('all');"></th>
                </tr>
            </thead>
            <thead>
                <tr>
					<th width="30"><i class="fa fa-plus" align="absmiddle" border="0"></i></th>
                    <th><cf_get_lang dictionary_id='30397.Kullanıcı Grubu'></th>
                    <th class="text-center"><cf_get_lang dictionary_id='44843.View'><input type="Checkbox" name="all_group_view" id="all_group_view" value="1" onclick="hepsi_view('group');"></th>                    
                    <th class="text-center"><cf_get_lang dictionary_id='44844.Insert'><input type="Checkbox" name="all_group_insert" id="all_group_insert" value="1" onclick="hepsi_insert('group');"></th> 
                    <th class="text-center"><cf_get_lang dictionary_id='44845.Delete'><input type="Checkbox" name="all_group_delete" id="all_group_delete" value="1" onclick="hepsi_delete('group');"></th> 
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_user_groups">
                    <tr>
						<td class="text-center"><span href="javascript://" onClick="gonder_popup2('#user_group_id#');return false"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>" align="absmiddle" border="0"></i></span></td>
                        <td>#user_group_name#</td>
                        <td align="center"><input type="checkbox" name="is_view_group_" id="is_view_group_" value="#user_group_id#"></td>
                        <td align="center"><input type="checkbox" name="is_insert_group_" id="is_insert_group_" value="#user_group_id#"></td>
                        <td align="center"><input type="checkbox" name="is_delete_group_" id="is_delete_group_" value="#user_group_id#"> </td>                    
                    </tr>
                </cfoutput>
            </tbody>
            <thead>
                <tr>
					<th><i class="fa fa-plus" border="0" align="absmiddle"></i></th>
                    <th><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></th>
					<th class="text-center"><cf_get_lang dictionary_id='44843.View'><input type="Checkbox" name="all_pos_view" id="all_pos_view" value="1" onclick="hepsi_view('pos');"></th>                    
					<th class="text-center"><cf_get_lang dictionary_id='44844.Insert'><input type="Checkbox" name="all_pos_insert" id="all_pos_insert" value="1" onclick="hepsi_insert('pos');"></th> 
					<th class="text-center"><cf_get_lang dictionary_id='44845.Delete'><input type="Checkbox" name="all_pos_delete" id="all_pos_delete" value="1" onclick="hepsi_delete('pos');"></th> 
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_pos_name">
                    <tr>
						<td class="text-center"><span href="javascript://" onClick="gonder_popup('#position_cat_id#');return false"><i class="fa fa-plus" border="0" align="absmiddle" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></span></td>
                        <td>#position_cat#</td>
                        <td align="center"><input type="checkbox" name="is_view_" id="is_view_" value="#position_cat_id#"></td>
                        <td align="center"><input type="checkbox" name="is_insert_" id="is_insert_" value="#position_cat_id#"></td>
                        <td align="center"><input type="checkbox" name="is_delete_" id="is_delete_" value="#position_cat_id#"></td>                    
                    </tr>
                </cfoutput>	
            </tbody>
            <input type="hidden" name="list" id="list" value="<cfoutput>#valuelist(get_pos_name.position_cat_id)#</cfoutput>">
            <input type="hidden" name="list_group" id="list_group" value="<cfoutput>#valuelist(get_user_groups.user_group_id)#</cfoutput>">
            <input type="hidden" name="id" id="id" value="">
        </cf_grid_list>
        <cf_box_footer>
			<cf_workcube_buttons is_upd='0' type_format="1" add_function="control()">
		</cf_box_footer>
	</cf_box>
</cfform>
</div>
<script type="text/javascript">
function hepsi_view(temp_view)
{
	if(temp_view == 'all')
	{
		if(document.add_form.all_view.checked)
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_view_.length;i++)
				document.add_form.is_view_[i].checked = true;
			<cfelse>
				document.add_form.is_view_.checked = true;				
			</cfif>
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.add_form.is_view_group_.length;i++)
				document.add_form.is_view_group_[i].checked = true;
			<cfelse>
				document.add_form.is_view_group_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_pos_name.recordcount gt 1>
				for(i=0;i<document.add_form.is_view_.length;i++)
				document.add_form.is_view_[i].checked = false;
			<cfelse>
				document.add_form.is_view_.checked = false;
			</cfif>
			<cfif get_user_groups.recordcount gt 1>	
				for(i=0;i<document.add_form.is_view_group_.length;i++)
				document.add_form.is_view_group_[i].checked = false;
			<cfelse>
				document.add_form.is_view_group_.checked = false;
			</cfif>
		}
	}
	else if(temp_view == 'group')
	{
		if(document.add_form.all_group_view.checked)
			<cfif get_user_groups.recordcount gt 1>		
				for(i=0;i<document.add_form.is_view_group_.length;i++)
				document.add_form.is_view_group_[i].checked = true;
			<cfelse>
				document.add_form.is_view_group_.checked = true;
			</cfif>
		else
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_view_group_.length;i++)
				document.add_form.is_view_group_[i].checked = false;
			<cfelse>
				document.add_form.is_view_group_.checked = false;
			</cfif>
	}
	else if(temp_view == 'pos')
	{
		if(document.add_form.all_pos_view.checked)
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_view_.length;i++)
				document.add_form.is_view_[i].checked = true;
			<cfelse>
				document.add_form.is_view_.checked = true;
			</cfif>
		else
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_view_.length;i++)
				document.add_form.is_view_[i].checked = false;
			<cfelse>
				document.add_form.is_view_.checked = false;
			</cfif>
	}
}

function hepsi_insert(temp_view)
{
	if(temp_view == 'all')
	{
		if(document.add_form.all_insert.checked) 
		{
			
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_insert_.length;i++)
				document.add_form.is_insert_[i].checked = true;
			<cfelse>
				document.add_form.is_insert_.checked = true;
			</cfif>
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.add_form.is_insert_group_.length;i++)
				document.add_form.is_insert_group_[i].checked = true;
			<cfelse>
				document.add_form.is_insert_group_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_insert_.length;i++)
				document.add_form.is_insert_[i].checked = false;
			<cfelse>
				document.add_form.is_insert_.checked = false;
			</cfif>
			<cfif get_user_groups.recordcount gt 1>	
				for(i=0;i<document.add_form.is_insert_group_.length;i++)
				document.add_form.is_insert_group_[i].checked = false;
			<cfelse>
				document.add_form.is_insert_group_.checked = false;
			</cfif>
		 }
	}
	else if(temp_view == 'group')
	{
		if(document.add_form.all_group_insert.checked) 
		{
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.add_form.is_insert_group_.length;i++)
				document.add_form.is_insert_group_[i].checked = true;
			<cfelse>
				document.add_form.is_insert_group_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_user_groups.recordcount gt 1>	
			for(i=0;i<document.add_form.is_insert_group_.length;i++)
				document.add_form.is_insert_group_[i].checked = false;
			<cfelse>
				document.add_form.is_insert_group_.checked = false;
		 	</cfif>
		 }
	}
	else if(temp_view == 'pos')
	{
		if(document.add_form.all_pos_insert.checked) 
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_insert_.length;i++)
				document.add_form.is_insert_[i].checked = true;
			<cfelse>
				document.add_form.is_insert_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_insert_.length;i++)
				document.add_form.is_insert_[i].checked = false;
			<cfelse>
				document.add_form.is_insert_.checked = false;
			</cfif>
		 }
	}
		
}
 
function hepsi_delete(temp_view)
{
	if(temp_view == 'all')
	{
		if (document.add_form.all_delete.checked)
		{	
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_delete_.length;i++)
				document.add_form.is_delete_[i].checked = true;
			<cfelse>
				document.add_form.is_delete_.checked = true;
			</cfif>
			<cfif get_user_groups.recordcount gt 1>
			for(i=0;i<document.add_form.is_delete_group_.length;i++)
				document.add_form.is_delete_group_[i].checked = true;
			<cfelse>
				document.add_form.is_delete_group_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_delete_.length;i++)
				document.add_form.is_delete_[i].checked = false;
			<cfelse>
				document.add_form.is_delete_.checked = false;
			</cfif>
			<cfif get_user_groups.recordcount gt 1>		
			for(i=0;i<document.add_form.is_delete_group_.length;i++)
				document.add_form.is_delete_group_[i].checked = false;
			<cfelse>
				document.add_form.is_delete_group_.checked = false;
			</cfif>
		}
	}
	else if(temp_view == 'group')
	{
		if (document.add_form.all_group_delete.checked)
		{	
			<cfif get_user_groups.recordcount gt 1>		
			for(i=0;i<document.add_form.is_delete_group_.length;i++)
				document.add_form.is_delete_group_[i].checked = true;
			<cfelse>
				document.add_form.is_delete_group_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_user_groups.recordcount gt 1>		
			for(i=0;i<document.add_form.is_delete_group_.length;i++)
				document.add_form.is_delete_group_[i].checked = false;
			<cfelse>
				document.add_form.is_delete_group_.checked = false;
			</cfif>
		}
	}
	else if(temp_view == 'pos')
	{
		if (document.add_form.all_pos_delete.checked)
		{	
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_delete_.length;i++)
				document.add_form.is_delete_[i].checked = true;
			<cfelse>
				document.add_form.is_delete_.checked = true;
			</cfif>
		}
		else
		{
			<cfif get_pos_name.recordcount gt 1>
			for(i=0;i<document.add_form.is_delete_.length;i++)
				document.add_form.is_delete_[i].checked = false;
			<cfelse>
				document.add_form.is_delete_.checked = false;
			</cfif>
		}
	}
	
}
function gonder_popup(position_cat_id)
{
	if(add_form.modul_name.value != "" && add_form.faction.value != "")
  		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_user_denied&id=' + position_cat_id + '&modul_name=' + add_form.modul_name.value + '&faction=' + add_form.faction.value);
	else
		alert("<cf_get_lang dictionary_id='43436.Module İsmini Seçiniz'>!");
}

function gonder_popup2(user_group_id)
{
	if(add_form.modul_name.value != "" && add_form.faction.value != "")
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_user_denied&user_group_id=' + user_group_id + '&modul_name=' + add_form.modul_name.value + '&faction=' + add_form.faction.value);
	else
		alert("<cf_get_lang dictionary_id='43436.Module İsmini Seçiniz'>!");
}
function control(){
	if((!$("input#is_view_").is(":checked") && !$("input#is_insert_").is(":checked") && !$("input#is_delete_").is(":checked") && !$("input#is_view_group_").is(":checked") && !$("input#is_insert_group_").is(":checked") && !$("input#is_delete_group_").is(":checked") )){
		alert("<cf_get_lang dictionary_id='48965.Seçim Yapmadınız'>"); return false;
	}
}
</script>
