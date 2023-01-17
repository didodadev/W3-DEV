<cfif not  isdefined('attributes.MONEY_ID')>
  <cfset attributes.MONEY_ID='TL'>
  <cfset MONEY_TYPE='TL'>
  <cfelse>
  <cfset MONEY_TYPE=attributes.MONEY_ID>
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr>
    <td height="35">
      <table width="100%" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td class="headbold"><cf_get_lang dictionary_id='31021.Aylık Şube Bütçe Planı'></td>
		  <!-- sil -->
          <td>
            <table  style="text-align:right;">
              <cfform action="#request.self#?fuseaction=myhome.popup_list_frm_expense_branch_monthly" target="iframe" method="post"  name="dsp_expense">
                <tr>
                  <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
                  <cfinclude template="../query/get_moneys.cfm">
                  <td><select name="MONEY_ID" id="MONEY_ID">
                      <option  value="" selected><cf_get_lang dictionary_id='57489.Para Br'> 
                      <cfoutput query="get_moneys">
                        <option value="#MONEY#" <cfif attributes.MONEY_ID eq MONEY>Selected</cfif>>#MONEY#</option>
                      </cfoutput>
                    </select>
                  </td>
                  <td><select name="budget_year" id="budget_year">
                      <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                      <cfloop index="i" from="2003" to="2020" >
                        <option value="<cfoutput>#i#</cfoutput>" <cfif isdefined('attributes.year') and year eq i > Selected </cfif>> <cfoutput>#i#</cfoutput></option>
                      </cfloop>
                    </select>
                  </td>
                  <td><cf_wrk_search_button></td><td> 
				  <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </tr>
              </cfform>
            </table>
          </td>
		  <!-- sil -->
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td><iframe src="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_frm_expense_branch_monthly&iframe=1" width="100%" height="100%" frameborder="0" scrolling="auto" name="iframe" id="iframe"></iframe>
    </td>
  </tr>
</table>

