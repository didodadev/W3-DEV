<cfquery name="GET_SOCIAL_SOCIETY" datasource="#dsn#">
	SELECT 
    	SOCIETY_ID, 
        SOCIETY, 
        SOCIETY_DETAIL, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
	    SETUP_SOCIAL_SOCIETY 
    WHERE 
	    SOCIETY_ID = #ATTRIBUTES.SOCIETY_ID#
</cfquery>
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
        <tr class="color-list" valign="middle">
          <td height="35">
		  	<table width="98%" align="center">
              <tr>
                <td width="48%" valign="bottom" class="headbold"><cf_get_lang no='1500.Sosyal Güvenlik Kurumu Güncelle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td colspan="2">
                  <table>
					<cfform action="#request.self#?fuseaction=settings.emptypopup_upd_social_society&society_id=#attributes.society_id#" method="post" name="company_cat">
                      <tr>
                        <td><cf_get_lang no='1123.Kurum Adı'> *</td>
                        <td><cfsavecontent variable="message2"><cf_get_lang no ='1371.Kurum Adı Girmelisiniz'>!</cfsavecontent>
                          <cfinput type="Text" name="society" style="width:200px;" value="#GET_SOCIAL_SOCIETY.SOCIETY#" maxlength="50" required="Yes" message="#message2#"></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang_main no='359.Detay'></td>
                        <td><textarea name="society_detail" id="society_detail" style="width:200px;height:60"><cfoutput>#GET_SOCIAL_SOCIETY.SOCIETY_DETAIL#</cfoutput></textarea></td>
                      </tr>
                      <tr height="35">
                        <td>&nbsp;</td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                      </tr>
						<tr>
						  <td colspan="3"><p><br/>
							<cfoutput>
							<cfif len(get_social_society.record_emp)>
								<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_social_society.record_emp,0,0)# - #dateformat(get_social_society.record_date,dateformat_style)#
							</cfif><br/>
							<cfif len(get_social_society.update_emp)>
								<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_social_society.update_emp,0,0)# - #dateformat(get_social_society.update_date,dateformat_style)#
							</cfif>
							</cfoutput>
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
