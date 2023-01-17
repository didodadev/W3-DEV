<cfinclude template="../query/get_empapp.cfm">
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="GET_NOTICE" datasource="#dsn#">
	SELECT NOTICE_HEAD, NOTICE_NO FROM NOTICES WHERE NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.notice_id#">
</cfquery>
  <cfform name="add_app_pos" method="post">
    <cfif isDefined('session.cp.userid')>
    	<input type="hidden" value="<cfoutput>#session.cp.userid#</cfoutput>" name="empapp_id" id="empapp_id">
    </cfif>
    <table>
        <tr>
            <input type="hidden" name="app_pos_status" id="app_pos_status" value="1">
            <td width="150" class=""><cf_get_lang dictionary_id='35072.Job Posting'></td>
            <td colspan="3" class="txtbold">
                <input type="hidden" name="notice_id" id="notice_id" value="<cfoutput>#attributes.NOTICE_ID#</cfoutput>">
                <input type="hidden" name="notice_no" id="notice_no" value="<cfoutput>#GET_NOTICE.NOTICE_NO#</cfoutput>">
                <input type="hidden" name="notice_head" id="notice_head" value="<cfoutput>#GET_NOTICE.NOTICE_HEAD#</cfoutput>">
                <cfoutput>#GET_NOTICE.NOTICE_HEAD# (#GET_NOTICE.NOTICE_NO#)</cfoutput> 
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='34789.Application Date'>: </td>
            <td class="txtbold"><input type="hidden" name="date_now" id="date_now" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>"><cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput></td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='35073.Date you can start work'></td>
            <td><cfsavecontent variable="messages"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                <cfinput type="text" name="startdate_if_accepted" value="" style="width:100px;" validate="eurodate" message="#messages#">
                <cf_wrk_date_image date_field="startdate_if_accepted">
            </td>
        </tr>
        <tr>
            <td><cf_get_lang dictionary_id='35074.Requested Salary'><br/>(<cf_get_lang dictionary_id='35075.Monthly Average Gross Salary'>)</td>
            <td width="165">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='35076.Please Enter the Salary You Request'></cfsavecontent>
                <cfinput type="text" name="salary_wanted" message="#message#!" style="width:100px;" passthrough = "onkeyup=""return(formatcurrency(this,event));""" value="" class="moneybox">
                <select name="salary_wanted_money" id="salary_wanted_money" style="width:48px;">
                    <cfoutput query="get_moneys">
                    <option value="#money#" <cfif session.cp.money eq get_moneys.money>selected</cfif>>#money#</option>
                    </cfoutput>
                </select>
            </td>
        </tr>
        <tr>
            <td valign="top"><cf_get_lang_main no='1237.Ön Yazı'></td>
            <td colspan="3"><textarea name="detail_app" id="detail_app" style="width:220px;height:100px;"></textarea></td>
        </tr>
        <tr>
            <td colspan="2" style="text-align:right;">
                <!---<cf_workcube_buttons is_upd='0' add_function='kontrol()'>---->
                <cfsavecontent variable="button_t"><cf_get_lang dictionary_id='59031.Save'></cfsavecontent>
                <cf_workcube_buttons is_insert='1' insert_info="#button_t#" data_action="/V16/objects2/career/cfc/notice:add_app_pos" next_page="welcome" add_function='kontrol()'>
            </td>
        </tr>
    </table>
  </cfform>
<script type="text/javascript">
function kontrol()
{
	var tarih_ = fix_date_value(document.add_app_pos.startdate_if_accepted.value);
	if(tarih_.substr(6,4) < 1900)
	{
		alert("<cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!");
		return false;
	}
	document.add_app_pos.salary_wanted.value = filterNum(document.add_app_pos.salary_wanted.value);
	if(document.add_app_pos.detail_app.value != '' && document.add_app_pos.detail_app.value.length>1000)
	{
		alert("<cf_get_lang dictionary_id='35078.Cover Letter cannot be more than 1000 characters!'> !");
		return false;
	}
	return true;
}
</script>
