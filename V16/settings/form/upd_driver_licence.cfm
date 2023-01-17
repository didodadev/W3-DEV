<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
    <td class="headbold"><cf_get_lang no='628.Sürücü Belgesi Kategorisi Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_driver_licence"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
      <table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
        <tr class="color-row">
          <td width="200" valign="top">
            <cfinclude template="../display/list_driver_licence.cfm">
          </td>
          <td valign="top">
            <table>
              <cfform action="#request.self#?fuseaction=settings.emptypopup_driver_licence_upd" method="post" name="driver_licence" >
                <cfquery name="CATEGORY" datasource="#dsn#">
                	SELECT 
        	            LICENCECAT_ID, 
                        LICENCECAT, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        RECORD_DATE, 
                        UPDATE_EMP, 
                        UPDATE_IP, 
                        UPDATE_DATE, 
                        IS_LAST_YEAR_CONTROL, 
                        USAGE_YEAR
                    FROM 
    	                SETUP_DRIVERLICENCE 
                    WHERE 
	                    LICENCECAT_ID=#URL.ID#
                </cfquery>
                <input type="Hidden" name="licencecat_id" id="licencecat_id" value="<cfoutput>#url.id#</cfoutput>">
                <tr>
                  <td width="100"><cf_get_lang_main no='68.Başlık'>*</td>
                  <td><cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                      <cfinput type="Text" name="licencecat" size="20" value="#category.licencecat#" maxlength="10" required="Yes" message="#message#" style="width:150px;"></td>
                </tr>
				<tr>
					<td><cf_get_lang no='741.Kullanım Süresi'></td>
						<cfsavecontent variable="message"><cf_get_lang no='1400.Kullanım Süresi Hatalı'></cfsavecontent>
					<td><cfinput type="Text" name="USAGE_YEAR" value="#category.USAGE_YEAR#" validate="integer" maxlength="2"  message="#message#" style="width:150px;"></td>
				</tr>
				<tr>
					<td><cf_get_lang no='757.Bitiş Yılı'></td>
					<td><input type="checkbox" value="1" name="IS_LAST_YEAR_CONTROL" id="IS_LAST_YEAR_CONTROL" <cfif category.IS_LAST_YEAR_CONTROL eq 1>checked</cfif>><cf_get_lang no='765.Kontrol Edilsin'></td>
				</tr>
				<tr>
				<td align="right"></td>
                  <td align="right" colspan="2" height="35"><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_driver_licence_del&licencecat_id=#url.id#'></td>
                </tr>
                <tr>
				<td colspan="2"><cf_get_lang_main no='71.Kayıt'> :
				<cfoutput>
					<cfif len(category.record_emp)>#get_emp_info(category.record_emp,0,0)#</cfif>
					<cfif len(category.record_date)> - #dateformat(category.record_date,dateformat_style)#</cfif><br/>
					<cfif  len(category.update_emp)>
					<cf_get_lang_main no='479.Güncelleyen'> :
						#get_emp_info(category.update_emp,0,0)# - #dateformat(category.update_date,dateformat_style)#
					
					</cfif>
				</cfoutput>
				</td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
