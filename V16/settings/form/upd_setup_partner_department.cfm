<cfquery name="GET_PARTNER_TITLE" datasource="#DSN#">
	SELECT 
        PARTNER_DEPARTMENT_ID, 
        PARTNER_DEPARTMENT, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
    	SETUP_PARTNER_DEPARTMENT 
    WHERE 
    	PARTNER_DEPARTMENT_ID = #attributes.id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='132.Departmanlar'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_setup_partner_department"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
  </tr>
</table>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <tr>
          <td class="color-row" width="200" valign="top"><cfinclude template="../display/list_partner_department.cfm"></td>
          <td class="color-row" valign="top">
            <cfform  name="add_task" action="#request.self#?fuseaction=settings.emptypopup_upd_setup_partner_department" method="post">
              <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
              <table>
                <tr>
				<td width="80"><cf_get_lang_main no='160.Departman'>*</td>    
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang no='787.departman girmelsisiniz'></cfsavecontent>
				  <cfinput type="text" maxlength="100" name="partner_department" style="width=175;" required="yes" message="Lütfen Görev Tipi Giriniz !" value="#get_partner_title.partner_department#"></td>
                </tr>
				<tr>
				<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  <td><textarea style="width:175;height:40;" name="detail" id="detail" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100"><cfoutput>#get_partner_title.detail#</cfoutput></textarea></td>
				</tr>
                <tr>
				<td></td>
                  <td colspan="2"><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_setup_partner_department&id=#attributes.id#'></td>
			    </tr>
				<tr>
				  <td colspan="3"><p><br/>
					<cfoutput>
					<cfif len(get_partner_title.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_partner_title.record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,get_partner_title.record_date),dateformat_style)#- #timeformat(date_add('h',session.ep.time_zone,get_partner_title.record_date),timeformat_style)#
					</cfif><br/>
					<cfif len(get_partner_title.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_partner_title.update_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,get_partner_title.update_date),dateformat_style)#-#timeformat(date_add('h',session.ep.time_zone,get_partner_title.update_date),timeformat_style)#
					</cfif>
					</cfoutput>
				  </td>
				</tr>
              </table>
            </cfform>
          </td>
        </tr>
      </table>
