<cfquery name="get_comp" datasource="#dsn#">
	SELECT COMP_ID, NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
</cfquery>
<cfquery name="get_periods" datasource="#dsn#">
	SELECT PERIOD_ID, PERIOD FROM SETUP_PERIOD ORDER BY PERIOD
</cfquery>
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT,POSITION_CAT_ID FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="get_employee_position_denied" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_POSITIONS_DENIED_FORM WHERE DENIED_PAGE = '#attributes.fusename#' AND FORM_DEFINE = '#attributes.form_define#' AND COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfif get_employee_position_denied.recordcount>
	<script type="text/javascript">
    	document.getElementById("update_table_").value = 1;
    </script>
<cfelse>
	<script type="text/javascript">
    	document.getElementById("update_table_").value = 0;
    </script>
</cfif>

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
<table width="99%" id="table_form_list2">
    <tr>
        <td colspan="3" class="formbold"><cf_get_lang dictionary_id='32471.Alan Adı'> : <cfoutput>#attributes.form_define#</cfoutput></td>
    </tr>
    <input type="hidden" name="number" id="number" value="<cfoutput>#get_position_cats.recordcount#</cfoutput>" />
    <input type="hidden" name="form_define" id="form_defined" value="<cfoutput>#attributes.form_define#</cfoutput>" />
    <input type="hidden" name="view_p_list" id="view_p_list" value="<cfoutput>#view_p_list#</cfoutput>" />
    <input type="hidden" name="update_p_list" id="update_p_list" value="<cfoutput>#update_p_list#</cfoutput>" />
    <tr id="company_list">
        <td valign="top">
        	<table>
	            <tr>
                	<td>
                    	<select name="our_company_id" id="our_company_id" onchange="show_positions();">
	                        <cfoutput query="get_comp">
								<option value="#comp_id#" <cfif get_comp.comp_id eq session.ep.company_id> selected = "selected"</cfif>>#get_comp.NICK_NAME#</option>
                            </cfoutput>
                        </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<div id="denied_form_objects_ajax"></div>
<script type="text/javascript">
function open_employees(position_cat_id)
{
  	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_get_denied_form_object&id=' + position_cat_id);
}
function show_positions()
{
	comp_id= document.getElementById('our_company_id').value;
	view_p_list= document.getElementById('view_p_list').value;
	update_p_list= document.getElementById('update_p_list').value;
	<cfif isdefined("attributes.type_id")>
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.popup_denied_form_objects_ajax&fusename=#attributes.fusename#&form_define=#attributes.form_define#</cfoutput>&company_id='+comp_id+'&type_id=<cfoutput>#attributes.type_id#</cfoutput>','denied_form_objects_ajax',1);
	<cfelse>
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.popup_denied_form_objects_ajax&fusename=#attributes.fusename#&form_define=#attributes.form_define#</cfoutput>&company_id='+comp_id,'denied_form_objects_ajax',1);
	</cfif>
}
show_positions();
</script>
