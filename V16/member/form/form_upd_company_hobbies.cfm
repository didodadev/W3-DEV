<cfquery name="get_hobby" datasource="#DSN#">
  SELECT 
  	* 
  FROM 
  	SETUP_HOBBY
</cfquery>
<cfquery name="get_company_member_hobbies" datasource="#dsn#"> 
	SELECT HOBBY_ID
	FROM COMPANY_PARTNER_HOBBY
	WHERE PARTNER_ID=#attributes.pid#
</cfquery>
<cfset liste = valuelist(get_company_member_hobbies.hobby_id)>
      <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
      	<tr>
		<td class="headbold" height="35"><cf_get_lang dictionary_id='30648.Hobiler'></td>
      </tr>
</table>
	  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
		<tr class="color-border">
          <td valign="top">
            <table width="100%" border="0" cellpadding="2" cellspacing="1">
			   
			    <tr class="color-header">
				<td class="form-title" height="22"><cf_get_lang dictionary_id='30509.Hobi'></td>
				<td class="form-title"><cf_get_lang dictionary_id='58693.Seç'></td>
				</tr>
				<cfform action="#request.self#?fuseaction=member.emptypopup_consumer_hobbies_upd&company_partner_id=#attributes.pid#" method="post" name="hobby">
			  <cfoutput query="get_hobby">
				<tr class="color-row">
				  <td>#get_hobby.HOBBY_NAME#</td>
				  <td width="20">
				  <input type="checkbox" name="HOBBY" id="HOBBY" value="#get_hobby.HOBBY_ID#"<cfif liste contains HOBBY_ID>checked</cfif>>
				  </td>
				</tr>
			</cfoutput>
            </table>
          </td>
        </tr>
</table>
	  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td height="35"  class="headbold" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
        </tr>
		</cfform>
		</table>

