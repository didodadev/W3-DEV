<cfquery name="GET_SER_SUBSTATUS" datasource="#DSN3#">
	SELECT
		SERVICE_SUBSTATUS_ID
	FROM
		SERVICE
	WHERE
		SERVICE_SUBSTATUS_ID=#URL.ID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='645.Servis Alt Durumu Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_service_substatus"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <tr class="color-row" valign="top">
          <td width="200"><cfinclude template="../display/list_service_substatus.cfm">
          </td>
          <td>
            <table border="0">
              <cfform name="service_substatus" method="post" action="#request.self#?fuseaction=settings.emptypopup_service_substatus_upd">
                <cfquery name="CATEGORY" datasource="#dsn3#">
					SELECT 
						* 
					FROM 
						SERVICE_SUBSTATUS 
					WHERE 
						SERVICE_SUBSTATUS_ID=#URL.ID#
                </cfquery>
                <input type="Hidden" name="service_SubStatus_ID" id="service_SubStatus_ID" value="<cfoutput>#URL.ID#</cfoutput>">
                <tr>
                  <td width="100"><cf_get_lang_main no='74.Kategori'>*</td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang_main no='10.Kategori girmelisiniz'></cfsavecontent>
				  <cfinput type="Text" name="service_SubStatus" style="width:150px;" value="#category.service_SubStatus#" maxlength="50" required="Yes" message="#message#">
                  </td>
                </tr>
                <tr height="35">
                  <td colspan="2" align="right" style="text-align:right;">
				  <cfif get_ser_substatus.recordcount>
				  <cf_workcube_buttons is_upd='1' is_delete='0'>
				  <cfelse>
				   <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_service_substatus_del&service_substatus_id=#URL.ID#'>
                  </cfif>
				  </td>
                </tr>
				<tr>
				  <td colspan="3" align="left"><p><br/>
					<cfoutput>
					<cfif len(category.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(category.record_emp,0,0)# - #dateformat(category.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(category.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(category.update_emp,0,0)# - #dateformat(category.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				  </td>
				</tr>
              </cfform>
            </table>
          </td>
        </tr>
      </table>
