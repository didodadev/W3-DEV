<cfquery name="get_rel" datasource="#DSN#">
  SELECT 
  	* 
  FROM 
  	SETUP_PARTNER_RELATION
</cfquery>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
          <tr height="35" class="color-list">
    <td class="headbold">&nbsp;<cf_get_lang no='37.Kurumsal Üye İlişki Ekle'></td>
  </tr>
		<tr class="color-row">
          <td valign="top">
            <table border="0">
             <tr class="txtboldblue" height="25">
			 <td></td>
			 <td><cf_get_lang_main no='173.Kurumsal Üye'></td>
			 <td><cf_get_lang_main no='1268.İlişki'></td>
			 </tr>
			  <cfform action="#request.self#?fuseaction=crm.emptypopup_par_rel_add&company_id=#url.company_id#" method="post" name="relation">
			   <cfloop index="i" from="1" to="10"> 
			    <tr>
				  <td></td>
				  <td width="185">
				   <cfoutput>
				   <input type="hidden" name="partner_company_id#i#" id="partner_company_id#i#" value="">
				   <input type="text" name="partner_company_name#i#" id="partner_company_name#i#" value="" style="width:150px;">
				  </cfoutput>
				   <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=relation.partner_company_id#i#&field_comp_name=relation.partner_company_name#i#&is_crm_module=1&select_list=2,6</cfoutput>','list');"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
				  </td>
				 <td>
				   <select name="get_rel<cfoutput>#i#</cfoutput>" id="get_rel<cfoutput>#i#</cfoutput>">
				     <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
					 <cfif get_rel.recordcount>
					   <cfoutput query="get_rel">
					     <option value="#PARTNER_RELATION_ID#">#PARTNER_RELATION#</option>
					   </cfoutput>
					 </cfif>
				   </select>
				 </td>
				</tr>
			</cfloop>
                <tr>
                  <td style="text-align:right;" colspan="3" height="35" >
				  <cf_workcube_buttons is_upd='0'>
					 </td>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
