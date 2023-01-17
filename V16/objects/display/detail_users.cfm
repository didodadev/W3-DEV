<cfset attributes.GROUP_ID=url.group_id>
<cfinclude template="../query/get_users.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32550.İletişim Grubu'></cfsavecontent>
<cf_popup_box title="#message# : <cfoutput>#GET_USERS.GROUP_NAME#</cfoutput>">
    <table>
        <tr>
        <td width="75" class="txtbold"><cf_get_lang dictionary_id='58969.Grup Adı'></td>
            <td>: <cfoutput>#GET_USERS.GROUP_NAME#</cfoutput></td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='32552.Herkes İçin'></td>
            <td>:
              <cfif GET_USERS.to_all eq 1>
                <cf_get_lang dictionary_id='57495.Evet'>
                <cfelse>
                <cf_get_lang dictionary_id='57496.Hayır'>
              </cfif>
            </td>
        </tr>
        <tr>
            <td class="txtboldblue"><cf_get_lang dictionary_id='32553.Kişiler'></td>
            <td>&nbsp;</td>
        </tr>
    </table>
    <table>
      <tr>
        <td>
          <cfif len(GET_USERS.positions)>
            <STRONG><cf_get_lang dictionary_id='58875.Çalışanlar'>:</STRONG>
            <cfset attributes.position_codes = get_users.positions>
            <cfinclude template="../../settings/query/get_users_pos.cfm">
            <cfoutput query="get_users_pos"> #employee_name# #employee_surname#, </cfoutput> <br/>
            <br/>
          </cfif>
          <cfif len(get_users.partners)>
            <STRONG><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'>:</STRONG>
            <cfset attributes.partner_ids = get_users.partners>
            <cfinclude template="../../settings/query/get_users_pars.cfm">
            <cfoutput query="get_users_pars"> #company_partner_name# #company_partner_surname#, </cfoutput> <br/>
            <br/>
          </cfif>
          <cfif len(get_users.consumers)>
            <STRONG><cf_get_lang dictionary_id='29406.Bireysel Üyeler'>:</STRONG>
            <cfset attributes.consumer_ids = get_users.consumers>
            <cfinclude template="../../settings/query/get_users_cons.cfm">
            <cfoutput query="GET_USERS_CONS"> #CONSUMER_NAME# #CONSUMER_SURNAME#, </cfoutput>
          </cfif>
        </td>
      </tr>
    </table>
</cf_popup_box>

