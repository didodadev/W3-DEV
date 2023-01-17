<cfquery name="BRANCHES" datasource="#dsn#">
	SELECT 
		BRANCH_ID, 
		BRANCH_NAME 
	FROM 
		BRANCH 
	ORDER BY	
		BRANCH_NAME
</cfquery>
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td valign="middle">
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35" class="headbold">&nbsp;<cf_get_lang dictionary_id ='53159.Denetim Ekle'></td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table>
              <cfform name="add_audit" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_add_audit"  onsubmit="return UnformatFields();">
                <tr>
                  <td><cf_get_lang dictionary_id='53095.Denetlenen Şube'>*</td>
                  <td colspan="3">
                    <select name="AUDIT_BRANCH_ID" id="AUDIT_BRANCH_ID" style="width:400px;">
                      <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                      <cfoutput query="branches">
                        <option value="#BRANCH_ID#">#branch_name#</option>
                      </cfoutput>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang dictionary_id='53160.Denetleyen Adı Soyadı'>*</td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='53160.Denetleyen Adı Soyadı'></cfsavecontent>
                    <cfinput type="text" name="AUDITOR" value="" required="yes" message="#message#" maxlength="100" style="width:150px;">
                  </td>
                  <td><cf_get_lang dictionary_id='53164.Pozisyonu'>*</td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='53160.Denetleyen Pozisyonu'></cfsavecontent>
                    <cfinput type="text" name="AUDITOR_POSITION" value="" required="yes" message="#message#" maxlength="100" style="width:175px;">
                  </td>
                </tr>
                <tr>
                  <td><cf_get_lang dictionary_id='57742.Tarih'>*</td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57742.Tarih'></cfsavecontent>
                    <cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="AUDIT_DATE" style="width:130px;">
                    <cf_wrk_date_image date_field="AUDIT_DATE"></td>
                  <td><cf_get_lang dictionary_id='53165.Denetim Tipi'></td>
                  <td>
				    <input type="radio" name="AUDIT_TYPE" id="AUDIT_TYPE" value="1" checked><cf_get_lang dictionary_id='58561.İç'>&nbsp;&nbsp;
                     <input type="radio" name="AUDIT_TYPE" id="AUDIT_TYPE" value="0"><cf_get_lang dictionary_id='58562.Dış'>
                  </td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang dictionary_id='53161.Eksik Giderilme Tarihi'></td>
                  <td>
                    <cfsavecontent variable="message1"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='53161.Eksik Giderilme Tarihi'></cfsavecontent>
                    <cfinput validate="#validate_style#" message="#message1#" type="text" name="AUDIT_RECHECK_DATE" style="width:130px;">
                    <cf_wrk_date_image date_field="AUDIT_RECHECK_DATE">
					</td>
					<td><cf_get_lang dictionary_id='53166.Para Cezası'></td>
				  	<td>
					<cfinclude template="../query/get_moneys.cfm">
				  	<input type="text" name="punishment_money" id="punishment_money" onkeyup="return(FormatCurrency(this,event));">
					<select name="punishment_money_type" id="punishment_money_type" style="width=50;">
					<cfoutput query="GET_MONEYS">
					<option value="#money_id#">#money#</option>
					</cfoutput>
					</select>
					</td>

                </tr>
				<tr>
				<td><cf_get_lang dictionary_id='57640.Vade'></td>
				<td>
				<cfinput validate="#validate_style#" type="text" name="TERM_DATE" style="width:130px;">
				<cf_wrk_date_image date_field="TERM_DATE">
				</tr>
				 <tr>
                  <td valign="top"><cf_get_lang dictionary_id='53162.Görülen Eksikler'></td>
                  <td colspan="3"><textarea type="text" name="AUDIT_MISSINGS" id="AUDIT_MISSINGS" style="width:400px;height:80px;"></textarea>
                  </td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
                  <td colspan="3">
                    <textarea type="text" name="AUDIT_DETAIL" id="AUDIT_DETAIL" style="width:400px;height:80px;"></textarea>
                  </td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang dictionary_id='57684.Sonuç'></td>
                  <td colspan="3">
                    <textarea type="text" name="AUDIT_RESULT" id="AUDIT_RESULT" style="width:400px;height:80px;"></textarea>
                  </td>
                </tr>
                <tr>
                  <td height="35" colspan="4"  style="text-align:right;">
				  <cf_workcube_buttons is_upd='0' add_function='control()'>
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
<script type="text/javascript">
	function control()
	{
		x = document.add_audit.AUDIT_BRANCH_ID.selectedIndex;
		if (document.add_audit.AUDIT_BRANCH_ID[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='57453.Şube'>");
			return false;
		}
	}
	function UnformatFields()
	{
		add_audit.punishment_money.value = filterNum(add_audit.punishment_money.value);
	}

</script>

