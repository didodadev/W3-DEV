<cfinclude template="../query/get_fuseactions.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td valign="top">
      <cfparam name="attributes.page" default=1>
      <cfparam name="attributes.keyword" default=''>
      <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
      <cfparam name="attributes.totalrecords" default=#get_fuseaction.recordcount#>
      <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
      <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" height="35">
        <cfform name="form1" method="post" action="#request.self#?fuseaction=dev.list_faction">
          <tr>
            <td class="headbold"><cf_get_lang no='4.FuseActions'></td>
            <td  style="text-align:right;">
              <table>
                <tr>
                  <td><cf_get_lang_main no='48.Filtre'>:</td>
				<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
                  <td>
                    <select name="module" id="module">
                      <option value="" selected><cf_get_lang no='40.Moduls'></option>
                      <cfoutput query="get_modules">
                        <option value="#MODULE_ID#" <cfif isDefined('attributes.module') and get_modules.MODULE_ID eq attributes.module>selected</cfif>>#MODULE_SHORT_NAME#</option>
                      </cfoutput>
                    </select>
                  </td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                  </td>
                  <td><cf_wrk_search_button></td>
                </tr>
              </table>
            </td>
          </tr>
        </cfform>
      </table>
            <table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
              <tr height="22" class="color-header">
                <td class="form-title"><cf_get_lang no='77.WorkCube Object'></td>
                <td width="90" class="form-title"><cf_get_lang no='44.Modul'></td>
                <td width="125" class="form-title"><cf_get_lang no='66.FuseAction'></td>
                <td width="125" class="form-title"><cf_get_lang no='78.Author'></td>
                <td width="80" class="form-title"><cf_get_lang no='43.Status'></td>
                <td width="80"  class="form-title"><cf_get_lang no='42.Version'></td>
                <td width="15"></td>
                <td width="15"></td>
                <td width="15"><!--- <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=dev.popup_add_faction</cfoutput>','small');"><img src="/images/plus_square.gif" border="0" align="absmiddle" alt="Ekle" ></a> ---></td>
              </tr>
              <cfif get_fuseaction.RECORDCOUNT>
                <cfoutput query="get_fuseaction" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                    <td>
                      <cfif LEN(FUSEACTION_HEAD)>
                        #FUSEACTION_HEAD#
                      </cfif>
                    </td>
                    <td>#MODUL_NAME#</td>
                    <td>#FUSEACTION#</td>
                    <td>
                      <cfif LEN(PARTNER_ID)>
                        <cfquery name="GET_PARTNER" datasource="#DSN#">
							SELECT 
								COMPANY_PARTNER_NAME,
								COMPANY_PARTNER_SURNAME 
							FROM
								COMPANY_PARTNER 
							WHERE 
								PARTNER_ID = #PARTNER_ID#
                        </cfquery>
                        #GET_PARTNER.COMPANY_PARTNER_NAME# #GET_PARTNER.COMPANY_PARTNER_SURNAME#
                      </cfif>
                      <cfif LEN(EMPLOYEE_ID)>
					    
                        <cfquery name="GET_EMP" datasource="#DSN#">
							SELECT 
								EMPLOYEE_NAME, 
								EMPLOYEE_SURNAME 
							FROM 
								EMPLOYEES
							WHERE 
								EMPLOYEE_ID = #EMPLOYEE_ID#
                        </cfquery>
                        #GET_EMP.EMPLOYEE_NAME# #GET_EMP.EMPLOYEE_SURNAME#
                      </cfif>
                    </td>
                    <td>
                      <cfif LEN(STAGE_ID)>
                        <cfquery name="GET_STAGE" datasource="#DSN_DEV#">
							SELECT 
								STAGE 
							FROM 
								STAGE 
							WHERE 
								STAGE_ID = #STAGE_ID#
                        </cfquery>
                        #GET_STAGE.STAGE#
                      </cfif>
                    </td>
                    <td>
                      <cfif LEN(VERSION_CAT_ID)>
                        <cfquery name="GET_VERSION" datasource="#DSN_DEV#">
							SELECT 
								VERSION 
							FROM 
								VERSION_CAT 
							WHERE 
								VERSION_ID = #VERSION_CAT_ID#
                        </cfquery>
                        #GET_VERSION.VERSION#
                      </cfif>
                    </td>
                    <td><a href="#request.self#?fuseaction=dev.dsp_faction&faction_id=#fuseaction_id#"><img src="/images/d.gif" alt="<cf_get_lang no='45.Detail'>" border="0" title="<cf_get_lang no='45.Detail'>"></a></td>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=dev.popup_list_checklist&faction_ID=#fuseaction_id#&cont=1&version_cat_id=#VERSION_CAT_ID#','medium');"><img src="/images/c.gif" alt="<cf_get_lang no='34.Check List'>" border="0" title="<cf_get_lang no='34.Check List'>"></a></td>
                    <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=dev.popup_buglist&faction_ID=#fuseaction_id#&cont=1','page');"><img src="/images/b.gif" border="0" alt="<cf_get_lang no='79.Bug List'>" title="<cf_get_lang no='79.Bug List'>"></a></td>
                  </tr>
                </cfoutput>
                <cfelse>
                <tr class="color-row" height="20">
                  <td colspan="9"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
              </cfif>
            </table>
      <cfif attributes.maxrows lt attributes.totalrecords>
       
              <cfset adres = "#attributes.fuseaction#">
              <cfif len(attributes.keyword)>
                <cfset adres = "#adres#&keyword=#attributes.keyword#">
              </cfif>
              <cfif isDefined('attributes.module') and len(attributes.module)>
                <cfset adres = "#adres#&module=#attributes.module#">
              </cfif>
				<cf_paging
					page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#adres#">
      </cfif>
    </td>
  </tr>
</table>

