<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT,POSITION_CAT_ID FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="get_employee_position_denied" datasource="#dsn#">
	SELECT 
        DENIED_PAGE, 
        FORM_DEFINE, 
        COMPANY_ID, 
        POSITION_CAT_ID, 
        IS_VIEW, 
        IS_UPDATE, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP,
        TYPE_ID
    FROM 
    	EMPLOYEE_POSITIONS_DENIED_FORM 
    WHERE 
    	DENIED_PAGE = '#attributes.fusename#' 
    	AND FORM_DEFINE = '#attributes.form_define#' 
		AND COMPANY_ID = #attributes.company_id#
        <cfif isdefined("attributes.type_id")>
        	AND TYPE_ID = #attributes.type_id#
        </cfif>
</cfquery>
<cfset view_p_list = ''>
<cfset update_p_list = ''>
<cfoutput query="get_employee_position_denied">
	<cfif is_view eq 1>
    	<cfset view_p_list = listappend(view_p_list,POSITION_CAT_ID)>
    </cfif>
    <cfif is_update eq 1>
    	<cfset update_p_list = listappend(update_p_list,POSITION_CAT_ID)>
    </cfif>
</cfoutput>
<script type="text/javascript">
function select_all(obj,kontrol_number)
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
			if(obj.checked == true)
			{
				for(var i=0; i<view_deneme-1; i++)
					document.all.is_view_[i].checked = true;
			}
			else
			{
				for(var i=0; i<view_deneme-1; i++)
					document.all.is_view_[i].checked = false;
			}
			document.all.is_view_[view_deneme-1].checked = false;
		}
		else
		{
			if(obj.checked == true)
			{
				for(var i=0; i<update_deneme-1; i++)
					document.all.is_update_[i].checked = true;
			}
			else
			{
				for(var i=0; i<update_deneme-1; i++)
					document.all.is_update_[i].checked = false;
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
<table class="medium_list">
	<thead>
    <tr>
        <th class="formbold"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></th>
        <th><input type="checkbox" name="is_view_all" id="is_view_all" value="1" onclick="select_all(this,0);" <cfif listLen(view_p_list) eq GET_POSITION_CATS.recordcount>checked</cfif>><cf_get_lang dictionary_id='32477.Görsün'></th>
        <th nowrap="nowrap"><input type="checkbox" name="is_update_all" id="is_update_all" value="1" onclick="select_all(this,0);" <cfif listLen(update_p_list) eq GET_POSITION_CATS.recordcount>checked</cfif>><cf_get_lang dictionary_id='32479.Güncellesin'></th>
    </tr>
    </thead>
    <tbody>
    <cfoutput query="GET_POSITION_CATS">
        <tr>
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
        <td align="center"><input type="checkbox" name="is_view_" id="is_view_" value="0" onclick="select_all(this,1);" <cfif listfindnocase(view_p_list,'0')>checked</cfif>></td>
        <td align="center"><input type="checkbox" name="is_update_" id="is_update_" value="0" onclick="select_all(this,1);" <cfif listfindnocase(update_p_list,'0')>checked</cfif>></td>
    </tr>
    </tbody>
    <tfoot>
    <tr>
        <td colspan="3">
        	<cf_record_info query_name="get_employee_position_denied">
            <cf_workcube_buttons is_upd='0' type_format="1">
        </td>
    </tr>
    </tfoot>
</table>
