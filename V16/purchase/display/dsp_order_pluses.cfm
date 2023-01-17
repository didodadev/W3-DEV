<!--- dsp_order_pluses.cfm --->
<cfinclude template="../query/get_order_pluses.cfm">
<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
        <tr class="color-list" height="22">
          <td>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td height="22" class="headbold"><cf_get_lang dictionary_id='38497.Takipler'></td>
                <td width="30" align="right" style="text-align:right;"><a href="#" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=sales.popup_form_add_order_plus&order_ID=<cfoutput>#order_ID#</cfoutput>','medium');"><img src="/images/plus_list.gif"  border="0"></a></td>
              </tr>
            </table>
          </td>
        </tr>
        <cfoutput query="get_order_pluses">
          <tr class="color-row">
            <td height="50" colspan="2"> <a href="##" onclick="windowopen('#request.self#?fuseaction=sales.popup_form_upd_order_plus&order_plus_ID=#order_plus_ID#','medium');"><img src="/images/update_list.gif" border="0"></a> <b><cf_get_lang dictionary_id='57742.Tarih'>:</b> #dateformat(plus_date,dateformat_style)# <br/>
              <b>&nbsp;&nbsp;<cf_get_lang dictionary_id='57569.Görevli'>:</b>
              <cfif len(employee_id)>#get_emp_info(employee_id,0,0)#</cfif>
              <br/>
			  &nbsp;&nbsp;<b><cf_get_lang dictionary_id='58090.İletişim Yöntemi'>:</b>
              <cfif len(commethod_id)>
                <cfset attributes.commethod_id = commethod_id>
                <cfinclude template="../query/get_commethod.cfm">
                #get_commethod.commethod#<br/>
              </cfif>
              <br/>#plus_content#</td>
          </tr>
        </cfoutput>
      </table>
    </td>
  </tr>
</table>
