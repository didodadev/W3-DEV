<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT,POSITION_CAT_ID FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<script type="text/javascript">
function tumunu_sec_(obj,kontrol_number)
{
	// kontrol_number ifadesini en altta gelen kimse görmesin özelliği için eklenmiştir.. 1 geldiği zaman en alttaki checkbox seçilmiştir.
	if(kontrol_number == 0)
	{
		if(obj.name == 'is_view_all')
			var view_deneme = document.getElementsByName('is_view_').length;
		else
			var update_deneme = document.getElementsByName('is_update_').length;
			
		if(obj.name == 'is_view_all')
		{
			for(var i=0; i<view_deneme-1; i++)
			{
				if(document.all.is_view_[i].checked == true)
					document.all.is_view_[i].checked = false;
				else
					document.all.is_view_[i].checked = true;
			}
			document.all.is_view_[view_deneme-1].checked = false;
		}
		else
		{
			for(var i=0; i<update_deneme-1; i++)
			{
				if(document.all.is_update_[i].checked == true)
					document.all.is_update_[i].checked = false;
				else
					document.all.is_update_[i].checked = true;
			}
			document.all.is_update_[update_deneme-1].checked = false;
		}
	}
	else
	{
		if(obj.name == 'is_view_')
		{
			var view_deneme = document.getElementsByName('is_view_').length;
			if(document.all.is_view_[view_deneme-1].checked == true)
			{
				for(var i=0; i<view_deneme-1; i++)
					document.all.is_view_[i].checked = false;
			}
			document.all.is_view_all.checked = false;
		}
		else
		{
			var update_deneme = document.getElementsByName('is_update_').length;
			if(document.all.is_update_[update_deneme-1].checked == true)
			{
				for(var i=0; i<update_deneme-1; i++)
					document.all.is_update_[i].checked = false;
			}
			document.all.is_update_all.checked = false;
		}
	}
}
</script>
<table>
    <tr>
        <td class="formbold"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></td>
        <td><input type="checkbox" name="is_view_all" id="is_view_all" value="1" onclick="tumunu_sec_(this,0);" <cfif listLen(view_p_list) eq GET_POSITION_CATS.recordcount>checked</cfif>><cf_get_lang dictionary_id='32477.Görsün'></td>
        <td nowrap="nowrap"><input type="checkbox" name="is_update_all" id="is_update_all" value="1" onclick="tumunu_sec_(this,0);" <cfif listLen(update_p_list) eq GET_POSITION_CATS.recordcount>checked</cfif>><cf_get_lang dictionary_id='32479.Güncellesin'></td>
    </tr>
    <cfoutput query="GET_POSITION_CATS">
        <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';">
            <td><a href="javascript://" onClick="open_employees('#position_cat_id#');return false"><img border="0"  src="/images/plus_list.gif" align="absmiddle"></a>#position_cat#</td>
            <td align="center"><input type="checkbox" id="is_view_" name="is_view_" value="#position_cat_id#" <cfif listfindnocase(view_p_list,position_cat_id)>checked</cfif>></td>
            <td align="center"><input type="checkbox" id="is_update_" name="is_update_" value="#position_cat_id#" <cfif listfindnocase(update_p_list,position_cat_id)>checked</cfif>></td>
        </tr>           
    </cfoutput>
    <tr>
        <td>&nbsp;</td>
        <td align="center"><cf_get_lang dictionary_id='44751.Görmesin'></td>
        <td align="center"><cf_get_lang dictionary_id='60033.Güncellemesin'></td>
    </tr>
    <tr>
        <td><cf_get_lang dictionary_id='32480.Hiçkimse'></td>
        <td align="center"><input type="checkbox" name="is_view_" id="is_view_" value="0" onclick="tumunu_sec_(this,1);" <cfif listfindnocase(view_p_list,'0')>checked</cfif>></td>
        <td align="center"><input type="checkbox" name="is_update_" id="is_update_" value="0" onclick="tumunu_sec_(this,1);" <cfif listfindnocase(update_p_list,'0')>checked</cfif>></td>
    </tr>
    <tr>
        <td valign="top" colspan="3" style="text-align:right">
            <cf_workcube_buttons is_upd='0'>
        </td>
    </tr>
</table>
