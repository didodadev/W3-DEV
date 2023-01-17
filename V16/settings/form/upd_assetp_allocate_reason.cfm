<cfquery name="GET_REASON" datasource="#DSN#">
	SELECT
		REASON_ID, 
		ALLOCATE_REASON, 
		ALLOCATE_REASON_DETAIL,
		RECORD_DATE,
		RECORD_EMP,
		UPDATE_DATE,
		UPDATE_EMP
	FROM
		SETUP_ALLOCATE_REASON
	WHERE
		REASON_ID = #attributes.reason_id# 
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td align="left" class="headbold"><cf_get_lang no='925.Tahsis Nedeni'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_assetp_allocate_reason"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <cfform name="upd_reason" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_assetp_allocate_reason">
		<input type="hidden" name="reason_id" id="reason_id" value="<cfoutput>#get_reason.reason_id#</cfoutput>">
          <tr class="color-row" valign="top">
            <td width="200"><cfinclude template="../display/list_assetp_allocate_reason.cfm"></td>
            <td>
              <table border="0">
                <tr>
                  <td><cf_get_lang no='925.Tahsis Nedeni'>*</td>
                  <td><cfsavecontent variable="message"><cf_get_lang no='1179.Tahsis Nedeni Girmelisiniz!'></cfsavecontent>
					  <cfinput type="text" name="allocate_reason" style="width:150px;" value="#get_reason.allocate_reason#" maxlength="30" required="Yes" message="#message#"></td>
                </tr>
                <tr>
					<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  	<td><textarea name="allocate_reason_detail" id="allocate_reason_detail" style="width=150px;height=75px"><cfoutput>#get_reason.allocate_reason_detail#</cfoutput></textarea></td>
                </tr>
				<tr>
					<td></td>
					<td colspan="3"><cf_workcube_buttons is_upd='1' is_reset='0' is_delete='0'></td>
				</tr>
			  <tr>
				  <td colspan="3"><p><br/>
					<cfoutput>
					<cfif len(get_reason.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_reason.record_emp,0,0)# - #dateformat(get_reason.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(get_reason.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_reason.update_emp,0,0)# - #dateformat(get_reason.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				  </td>
			</tr>
              </table>
          </tr>
        </cfform>
      </table>
