<cfquery name="get_periods" datasource="#dsn#">
	SELECT 
		SP.*,
		OC.COMPANY_NAME 
	FROM 
		SETUP_PERIOD SP,
		OUR_COMPANY OC
	WHERE
		SP.OUR_COMPANY_ID = OC.COMP_ID
</cfquery>
<cfquery name="get_companies" datasource="#dsn#">
	SELECT 
    	COMP_ID, 
        COMPANY_NAME
    FROM 
	    OUR_COMPANY 
</cfquery>
<cfsavecontent variable = "title">
	<cf_get_lang no ='2062.Ciro Edilmiş Senet Dönem Aktarım'>
</cfsavecontent>
<cf_form_box title="#title#">
	<cf_area width="50%">
			<cfform name="copy_cheque" action="#request.self#?fuseaction=settings.emptypopup_endorsement_voucher_copy" method="post">
			<table>
				<tr>
					<td><cf_get_lang_main no='469.Vade Tarihi'> </td>
					<td>
					<cfinput type="text" name="due_date" value="" style="width:70px;" validate="#validate_style#" maxlength="10" required="yes">
					<cf_wrk_date_image date_field="due_date"> '<cf_get_lang no ='2063.den sonraki senetleri'></td>
				</tr>
				<tr>
					<td><cf_get_lang no='1592.Hangi Şirketten'></td>
					<td>
				  	<select name="kaynak_period_1" id="kaynak_period_1" style="width:300px;" onchange="show_periods_departments(1)">
							<cfoutput query="get_companies">
								<option value="#COMP_ID#" <cfif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option>
							</cfoutput>
						</select>
        	</td> 
					<td>
							<div id="source_div">
								<select name="from_cmp" id="from_cmp" style="width:220px;">

								</select>
							</div>
					</td>
        </tr>
				<tr>
				  <td><cf_get_lang no='1593.Hangi Şirkete'></td>
          <td>
				  	<select name="hedef_period_1" id="hedef_period_1" style="width:300px;" onchange="show_periods_departments(2)">
							<cfoutput query="get_companies">
								<option value="#COMP_ID#" <cfif comp_id eq session.ep.company_id>selected</cfif>>#COMPANY_NAME#</option>
							</cfoutput>
						</select>
          </td>
					<td>
							<div id="target_div">
								 <select name="to_cmp" id="to_cmp" style="width:220px;">

								 </select>
							</div>
						</td>
				</tr>
        <tr>
					<td colspan="2">
					<table width="100%">
						<tr>
							<td><input type="checkbox" name="is_cheque_based_action" id="is_cheque_based_action"><cf_get_lang no ='2061.Satır Bazında Carileştir'></td>
							<td align="right" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function="control()"></td>
						</tr>
					</table>
					</td>
        </tr>
			
            </table> 
			<b><cf_get_lang dictionary_id='58597.Önemli Uyarı'> !</b><br>
				<cf_get_lang dictionary_id='43579.Ciro Edilmiş Müşteri Senetleri Dönem AktarımıSadece Dönem Başı İşlemi Olarak Kullanılmalıdır​'>
			</cfform>  
	</cf_area>         
  <cf_area width="50%">
		<table>
				<tr height="30">
					<td class="headbold" valign="top"><cf_get_lang_main no='21.Yardım'></td>
				</tr>    
				<tr>
					<td valign="top"><cfset getImportExpFormat("turnovernotes") /></td>

				</tr>
			</table>
	</cf_area>
</cf_form_box>  
<script type="text/javascript">
function control(){
	if(document.getElementById('due_date').value == ''){
			alert('<cf_get_lang no ='2059.Vade Tarihi Girmelisiniz'>');
			return false;
	}
	return true;
}
	$(document).ready(function(){
			var company_id = document.getElementById('kaynak_period_1').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'from_cmp',1,'Dönemler');
		}
	)
	function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('kaynak_period_1').value != '')
			{
				var company_id = document.getElementById('kaynak_period_1').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'from_cmp',1,'Dönemler');
			}
		}
		else if(number == 2)
		{
			if(document.getElementById('hedef_period_1').value != '')
			{
				var company_id = document.getElementById('hedef_period_1').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'to_cmp',1,'Dönemler');
			}
		}
	}
	$(document).ready(function(){
			var company_id = document.getElementById('hedef_period_1').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_ajax_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'to_cmp',1,'Dönemler');
		}
	)
</script>
