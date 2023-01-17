<cfquery name="GET_WORKGROUP_TYPE" datasource="#DSN#" maxrows="1">
	SELECT
		WORKGROUP_TYPE_ID
	FROM
		WORK_GROUP
	WHERE
		WORKGROUP_TYPE_ID=#URL.WORKGROUP_TYPE_ID#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no ='1807.İş Grubu Tipi Güncelle'></td>
    <td align="right" style="text-align:right;">
		<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_workgroup_type"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a>
	</td>
  </tr>
</table>
<cfform name="title" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_workgroup_type">
      <table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
        <tr class="color-row">
          <td width="200" valign="top"><cfinclude template="../display/list_workgroup_types.cfm">
          </td>
          <td valign="top">
            <table>
              
                <cfquery name="CATEGORIES" datasource="#dsn#">
					SELECT 
						* 
					FROM 
						SETUP_WORKGROUP_TYPE
					WHERE 
						WORKGROUP_TYPE_ID=#URL.WORKGROUP_TYPE_ID#
                </cfquery>
                <input type="Hidden" name="WORKGROUP_TYPE_ID" id="WORKGROUP_TYPE_ID" value="<cfoutput>#URL.WORKGROUP_TYPE_ID#</cfoutput>">
                <tr>
                  <td width="100"><cf_get_lang_main no='68.Başlık'> *</td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="WORKGROUP_TYPE_NAME" size="40" value="#categories.WORKGROUP_TYPE_NAME#" maxlength="50" required="Yes" message="#message#" style="width:200px;">
                  </td>
                </tr>
                <tr>
                  <td align="right" colspan="2" height="35">
					<cfif GET_WORKGROUP_TYPE.recordcount>
						<cf_workcube_buttons is_upd='1' is_delete='0'> 
					<cfelse>
						<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_workgroup_type&WORKGROUP_TYPE_ID=#url.WORKGROUP_TYPE_ID#'>
					</cfif>
                  </td>
                </tr>
				<tr>
				  <td colspan="3"><p><br/>
					<cfoutput>
					<cfif len(categories.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(categories.record_emp,0,0)# - #dateformat(categories.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(categories.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(categories.update_emp,0,0)# - #dateformat(categories.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				  </td>
				</tr>
              
            </table>
          </td>
        </tr>
      </table>
</cfform>