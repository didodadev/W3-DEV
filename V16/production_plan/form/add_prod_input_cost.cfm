<cfquery name="GET_BASIC_INPUT_COST" datasource="#DSN3#">
	SELECT
		*
	FROM
		SETUP_BASIC_INPUT_COST
</cfquery>
<cfinclude template="../query/get_money.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr class="color-border">
    <td valign="top">
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
        <tr class="color-list" height="35">
          <td class="headbold"><cf_get_lang dictionary_id='36334.Temel Girdi Tipi Ekle'></td>
        </tr>
        <tr class="color-row">
          <td valign="top">
            <cfform name="add_energy" action="#request.self#?fuseaction=prod.emptypopup_add_prod_input_costs" method="post">
              <table border="0">
                <tr>
                  <td valign="top" class="title"><cf_get_lang dictionary_id='58194.Zorunlu alan'> : <cf_get_lang dictionary_id='57655.Başlangıç Tarihi'>*</td>
                  <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
					<cfinput required="Yes" message="#message#" type="text" name="start_date" style="width:150px;" validate="#validate_style#">
                    <cf_wrk_date_image date_field="start_date"></td>
                </tr>
                <tr>
                  <td valign="top"><cf_get_lang dictionary_id='36699.Enerji Tipi'> *</td>
                  <td>
                  	<select name="basic_input_type" id="basic_input_type" style="width:150px;">
						<cfoutput query="get_basic_input_cost">
                        	<option value="#basic_input_id#">#basic_input#</option>
                        </cfoutput>
					</select>
                   </td>
                </tr>
				<tr>
				<td><cf_get_lang dictionary_id='57673.Tutar'> *</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu alan'> : <cf_get_lang dictionary_id='57673.Tutar'></cfsavecontent>
				<cfinput type="text" required="yes" value="" name="basic_input_cost" style="width:150px;" message="#message#"></td>
				</tr>
                <tr>
                  <td valign="top"><cf_get_lang dictionary_id='57489.Para Birimi'></td>
                  <td>
                  	<select name="money" id="money" style="width:150px;">
                      <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                      <cfoutput query="get_money">
                        <option value="#money#">#money#</option>
                      </cfoutput>
                    </select>
                  </td>
                </tr>
                <tr>
                  <td height="35" colspan="2" align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                </tr>
              </table>
            </cfform>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function kontrol()
{
	add_energy.basic_input_cost.value = filterNum(add_energy.basic_input_cost.value);
	return true;
}
</script>
