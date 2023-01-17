<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='1503.Kusur Oranı Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_fault_ratio"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="Ekle"></a></td>
  </tr>
</table>
<cfquery name="GET_FAULT_RATIO" datasource="#DSN#">
	SELECT
		*
	FROM 
		SETUP_FAULT_RATIO
	WHERE
		FAULT_RATIO_ID = #attributes.fault_ratio_id#
</cfquery>
      <table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
        <cfform name="upd_fault_ratio" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_fault_ratio">        
        <input type="hidden" name="fault_ratio_id" id="fault_ratio_id" value="<cfoutput>#get_fault_ratio.fault_ratio_id#</cfoutput>">
        <tr class="color-row" valign="top">
          <td width="200"><cfinclude template="../display/list_fault_ratio.cfm"></td>
          <td>
            <table border="0">
              <tr>
                <td><cf_get_lang no='1157.Kusur Oranı Adı'> *</td>
                <td><cfsavecontent variable="message"><cf_get_lang no='1158.Kusur Oranı Girmelisiniz'> !</cfsavecontent>
                  <cfinput type="text" name="fault_ratio_name" value="#trim(get_fault_ratio.fault_ratio_name)#" maxlength="20" required="yes" message="#message#" style="width:150px;"></td>
              </tr>
		      <tr>
                <td></td>
                <td lign="left" height="35"><cf_workcube_buttons is_upd='1' is_delete='0' is_reset='0'></td>
              </tr>
			  <tr>
				  <td colspan="3"><p><br/>
					<cfoutput>
					<cfif len(get_fault_ratio.record_emp)>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_fault_ratio.record_emp,0,0)# - #dateformat(get_fault_ratio.record_date,dateformat_style)#
					</cfif><br/>
					<cfif len(get_fault_ratio.update_emp)>
						<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_fault_ratio.update_emp,0,0)# - #dateformat(get_fault_ratio.update_date,dateformat_style)#
					</cfif>
					</cfoutput>
				  </td>
			</tr>
            </table>
          </tr>
		</cfform>        
      </table>
