<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='1504.Ceza Tipi Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_punishment_type"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
<cfquery name="GET_PUNISHMENT_TYPE" datasource="#DSN#">
	SELECT
		*
	FROM 
		SETUP_PUNISHMENT_TYPE
	WHERE
		PUNISHMENT_TYPE_ID = #attributes.punishment_type_id#
</cfquery>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <cfform name="upd_punishment_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_punishment_type">        
        <input type="hidden" name="punishment_type_id" id="punishment_type_id" value="<cfoutput>#get_punishment_type.punishment_type_id#</cfoutput>">
        <tr class="color-row" valign="top">
          <td width="200"><cfinclude template="../display/list_punishment_type.cfm"></td>
          <td>
            <table border="0">
              <tr>
                <td><cf_get_lang no='1160.Ceza Tip Adı'> *</td>
                <td><cfsavecontent variable="message"><cf_get_lang no='1161.Ceza Tipi Girmelisiniz'> !</cfsavecontent>
                  <cfinput type="text" name="punishment_type_name" value="#trim(get_punishment_type.punishment_type_name)#" maxlength="30" required="yes" message="#message#" style="width:150px;"></td>
              </tr>
		      <tr>
                <td></td>
                <td lign="left" height="35"><cf_workcube_buttons is_upd='1' is_delete='0' is_reset='0'></td>
              </tr>
			  <tr>
				  <td colspan="3"><p><br/>
					<cfoutput>
					<cfif len(get_punishment_type.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_punishment_type.record_emp,0,0)# - #dateformat(get_punishment_type.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(get_punishment_type.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_punishment_type.update_emp,0,0)# - #dateformat(get_punishment_type.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				  </td>
			</tr>
            </table>
          </tr>
		</cfform>        
      </table>
