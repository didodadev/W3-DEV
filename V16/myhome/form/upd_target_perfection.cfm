<cfparam name="attributes.period" default="">
<cfquery name="GET_POSITION" datasource="#dsn#">
	SELECT POSITION_CODE,DEPARTMENT_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfscript>
	if (get_position.recordcount){
		position_list = valuelist(get_position.position_code,',');
		department_list = valuelist(get_position.department_id,',');
	}
	else{
		position_list = session.ep.position_code;
		department_list = 0;
	}
</cfscript>
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		COMPANY_NAME,
		COMP_ID,
		NICK_NAME,
		MANAGER_POSITION_CODE,
		MANAGER_POSITION_CODE2
	FROM 
		OUR_COMPANY 
		<cfif not session.ep.ehesap>WHERE MANAGER_POSITION_CODE IN (#position_list#)</cfif>
	ORDER BY 
		COMPANY_NAME
</cfquery>
<cfquery name="GET_PERFECTION" datasource="#dsn#">
	SELECT * FROM OUR_COMPANY_TARGET  WHERE OUR_COMPANY_TARGET_ID = #attributes.target_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57951.Hedef'> <cf_get_lang dictionary_id='57907.Yetkinlik'></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="add_notes" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_target_perfection">
<input type="hidden" name="target_id" id="target_id" value="<cfoutput>#attributes.target_id#</cfoutput>">
    <table>
        <tr>
            <td><cf_get_lang dictionary_id='57574.Şirket'></td>
            <td><select name="company_id" id="company_id" style="width:250;">
                    <option value=""><cf_get_lang dictionary_id='57574.Şirket'></option>
                    <cfoutput query="get_company">
                        <option value="#comp_id#" <cfif comp_id eq get_perfection.company_id>selected</cfif>>#company_name#</option>
                    </cfoutput>
            	</select>
            </td>
        </tr>
        <tr>
            <td width="70"><cf_get_lang dictionary_id='58472.Dönem'></td>
            <td><select name="period" id="period" style="width:250">
                    <cfloop from="#year(now())-2#" to="#year(now())+2#" index="i">
                        <cfoutput><option value="#i#" <cfif i eq get_perfection.period>selected</cfif>>#i#</option></cfoutput>
                    </cfloop>
            	</select>
            </td>
        </tr>
            <tr>
                <td width="80"><cf_get_lang dictionary_id='31599.Hedef Ağırlığı'>*</td>
                <td><input type="text" name="target_size" id="target_size" style="width:250;" readonly="" value="<cfoutput>#get_perfection.target_size#</cfoutput>" maxlength="2" onKeyup="return(FormatCurrency(this,event));"></td>
            </tr>
        <tr>
            <td valign="top"><cf_get_lang dictionary_id='57758.Vizyon'></td>
            <td><textarea name="vizyon" id="vizyon" style="width:250;height:80;"><cfoutput>#get_perfection.vizyon#</cfoutput></textarea></td>
        </tr>
        <tr>
            <td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
            <td><textarea name="detail" id="detail" style="width:250;height:80;"><cfoutput>#get_perfection.detail#</cfoutput></textarea></td>
        </tr>
        <cfoutput>
            <tr>
                <td><b><cf_get_lang dictionary_id='57483.Kayıt'></b></td>
                <td>: #get_emp_info(get_perfection.record_emp,0,0)# - #dateformat(get_perfection.record_date,dateformat_style)#</td>
            </tr>
            <cfif len(get_perfection.update_emp)>
                <tr>
                    <td><b><cf_get_lang dictionary_id='57703.Güncelleme'></b></td>
                    <td>: #get_emp_info(get_perfection.update_emp,0,0)# - #dateformat(get_perfection.update_date,dateformat_style)#</td>
                </tr>
            </cfif>
        </cfoutput>
    </table>
    <cf_popup_box_footer>
       <cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' add_function='kontrol()'>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script language="JavaScript">
function kontrol()
{
	x = document.add_notes.company_id.selectedIndex;
	if (document.add_notes.company_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='57574.Şirket'>!");
		return false;
	}
	return true;
}
</script>
