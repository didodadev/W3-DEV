<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='1349.Sistem Özel Tanım Güncelle'></td>
    <td align="right" class="headbold" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_subscription_add_option"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a>
    </td>
  </tr>
</table>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <tr class="color-row" valign="top">
          <td width="200"><cfinclude template="../display/list_subscription_add_options.cfm">
          </td>
          <td>
            <table>
              <cfform name="form" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_subscription_add_option">
			  <input type="hidden" name="subs_option_id" id="subs_option_id" value="<cfoutput>#attributes.subs_option_id#</cfoutput>">
                <cfquery name="SUBS_OPTIONS" datasource="#dsn3#">
					SELECT 
						* 
					FROM 
						SETUP_SUBSCRIPTION_ADD_OPTIONS
					WHERE 
						SUBSCRIPTION_ADD_OPTION_ID = #attributes.subs_option_id#
                </cfquery>
                <tr>
                  <td width="110"><cf_get_lang no='1348.Sistem Özel Tanım'><font color=black>*</font></td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no ='1092.Özel Tanım Giriniz'></cfsavecontent>
                    <cfinput type="text" required="yes" message="#message#" name="add_option_name" maxlength="50" value="#SUBS_OPTIONS.SUBSCRIPTION_ADD_OPTION_NAME#" style="width:150px;">
                  </td>
                </tr>
				<tr>
                  <td valign="top" ><cf_get_lang_main no='217.Açıklama'></td>
                  <td>
                    <textarea name="add_option_detail" id="add_option_detail" style="width:150px;height:40px;"><cfoutput>#SUBS_OPTIONS.DETAIL#</cfoutput></textarea>
                  </td>
                </tr>
                <tr>
				<td align="right">&nbsp;</td>
			    <td align="right" height="35">
			   		<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_subscription_add_option&subs_option_id=#attributes.subs_option_id#'>
			    </td>
				<tr>
                  <td colspan="3"><p><br/>
				  	<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(SUBS_OPTIONS.RECORD_EMP,0,0)# - #dateformat(SUBS_OPTIONS.RECORD_DATE,dateformat_style)#<br/>
				 	<cfif len(SUBS_OPTIONS.UPDATE_EMP)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(SUBS_OPTIONS.UPDATE_EMP,0,0)# - #dateformat(SUBS_OPTIONS.UPDATE_DATE,dateformat_style)#
					</cfif>
					</cfoutput>
			      </td>
				</tr>
                </tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>

