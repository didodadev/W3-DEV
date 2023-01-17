<cfquery name="get_fuels" datasource="#dsn#">
	SELECT 
		FUEL_ID,
		FUEL_NAME, 
		FUEL_DETAIL,
		RECORD_DATE,
		RECORD_EMP,
		UPDATE_DATE,
		UPDATE_EMP
	FROM 
		SETUP_FUEL_TYPE 
	WHERE 
		FUEL_ID = #attributes.fuel_id# 
	ORDER BY FUEL_ID
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td align="left" class="headbold"><cf_get_lang no='1154.Yakıt Tipi'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_fuel_type"><img src="/images/plus1.gif" border="0" align="absmiddle" alt=<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center">
  <tr>
    <td class="color-border">
      <table border="0" cellspacing="1" cellpadding="2" width="100%">
        <cfform name="upd_fuel" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_fuel_type&fuel_id=#fuel_id#">
          <tr class="color-row" valign="top">
            <td width="200"><cfinclude template="../display/list_fuel_type.cfm"></td>
            <td>
              <table border="0">
                <tr>
                  <td><cf_get_lang no='1154.Yakıt Tipi'> *</td>
                  <td><cfsavecontent variable="message"><cf_get_lang no='1155.Yakıt Tipi Girmelisiniz!'></cfsavecontent>
					  <cfinput type="text" name="fuel_name" style="width:150px;" value="#get_fuels.fuel_name#" maxlength="20" required="Yes" message="#message#"></td>
                </tr>
                <tr>
					<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                  	<td><textarea name="fuel_detail" id="fuel_detail" style="width=150px;height=75px"><cfoutput>#get_fuels.fuel_detail#</cfoutput></textarea></td>
                </tr>
				<tr>
					<td colspan="3" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='1'></td>
				</tr>
			  <tr>
				  <td colspan="3"><p><br/>
					<cfoutput>
					<cfif len(get_fuels.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_fuels.record_emp,0,0)# - #dateformat(get_fuels.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(get_fuels.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_fuels.update_emp,0,0)# - #dateformat(get_fuels.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				  </td>
			</tr>
              </table>
          </tr>
        </cfform>
      </table>
    </td>
  </tr>
</table>
