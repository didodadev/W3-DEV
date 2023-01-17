<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang_main no='52.Güncelle'><cf_get_lang no='1235.Aktivite'> </td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_activity"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="Ekle"></a></td>
  </tr>
</table>
<cfquery name="GET_ACTIVITYS" datasource="#DSN#">
	SELECT
		*
	FROM 
		SETUP_ACTIVITY
	WHERE
		ACTIVITY_ID = #attributes.activity_id#
</cfquery>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <cfform name="upd_activity" method="post"  action="#request.self#?fuseaction=settings.emptypopup_upd_activity">        
        <input type="hidden" name="activity_id" id="activity_id" value="<cfoutput>#get_activitys.activity_id#</cfoutput>">
        <tr class="color-row" valign="top">
          <td width="200"><cfinclude template="../display/list_activity.cfm"></td>
          <td>
            <table border="0">
			  <tr>
			  	<td>&nbsp;</td>
			  	<td><input type="checkbox" name="activity_status" id="activity_status" value="1" <cfif get_activitys.activity_status eq 1>checked</cfif>><cf_get_lang_main no='81.Aktif'></td>
			  </tr>
              <tr>
                <td><cf_get_lang no='1235.Aktivite'> *</td>
                <td><cfsavecontent variable="message"><cf_get_lang no='1236.Aktivite Adı Girmelisiniz'>!</cfsavecontent>
                  <cfinput type="text" name="activity_name" value="#trim(get_activitys.activity_name)#" maxlength="50" required="yes" message="#message#" style="width:150px;"></td>
              </tr>
			  <tr>
                <td></td>
                <td lign="left" height="35"><cf_workcube_buttons is_upd='1' is_delete='0'></td>
              </tr>
			 <tr>
				<td colspan="3" align="left"><p><br/>
				  <cfoutput>
				  <cfif len(get_activitys.record_emp)>
					<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_activitys.record_emp,0,0)# - #dateformat(get_activitys.record_date,dateformat_style)#
				  </cfif><br/>
				  <cfif len(get_activitys.update_emp)>
					<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_activitys.update_emp,0,0)# - #dateformat(get_activitys.update_date,dateformat_style)#
				  </cfif>
				  </cfoutput>
				</td>
			  </tr>
            </table>
          </tr>
		</cfform>        
      </table>
