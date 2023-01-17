<cfinclude template="../query/get_insurance_payment.cfm">
<cfform name="form_add" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_insurance_payments" onsubmit="return UnformatFields();">
<input type="hidden" name="ins_pay_id" id="ins_pay_id" value="<cfoutput>#attributes.ins_pay_id#</cfoutput>">
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
	<tr class="color-border">
    	<td valign="middle">
        <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        	<tr class="color-list" valign="middle">
            	<td height="35" class="headbold"><cf_get_lang dictionary_id='53059.Sigorta Primine Esas Ücret Düzenle'></td>
          	</tr>
          	<tr class="color-row" valign="top">
            	<td>             
				<table>
					<tr>
						<td width="100"><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'>*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi girmelisiniz'></cfsavecontent>
							<cfinput value="#dateformat(get_insurance_payment.startdate,dateformat_style)#" type="text" name="startdate" style="width:150px;" validate="#validate_style#" required="yes" message="#message#">
							<cf_wrk_date_image date_field="startdate">
						</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi girmelisiniz'></cfsavecontent>
							<cfinput type="text" value="#dateformat(get_insurance_payment.finishdate,dateformat_style)#" name="finishdate" style="width:150px;" validate="#validate_style#" required="yes" message="#message#">
							<cf_wrk_date_image date_field="finishdate">
						</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='53047.Taban'>*</td>
						<td><cfinput type="text" name="minimum" value="#TLFormat(get_insurance_payment.min_payment)#" style="width:150px;" required="yes"  message="Taban Fiyatı Girmelisiniz!" onkeyup="return(FormatCurrency(this,event));"></td>
					</tr>
					<tr>
						<td><cf_get_lang ndictionary_ido='53048.Tavan'>*</td>
						<td><cfinput type="text" name="maximum" style="width:150px;" value="#TLFormat(get_insurance_payment.max_payment)#" required="yes" message="Tavan Fiyat Girmelisiniz!" onkeyup="return(FormatCurrency(this,event));"></td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='52979.Asgari Brüt Ücret'> (<cf_get_lang dictionary_id='53043.Normal'>)*</td>
						
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57613.Girmelisiniz'><cf_get_lang dictionary_id ='52979.Asgari Brüt Ücret'>(<cf_get_lang dictionary_id='53043.Normal'>)</cfsavecontent>
							<cfinput type="text" name="min_gross_payment_normal" value="#tlformat(get_insurance_payment.min_gross_payment_normal)#" required="yes"  message="#message#" style="width:150px;" onkeyup="return(FormatCurrency(this,event));">
						</td>
					</tr>
					<tr>
						<td><cf_get_lang dictionary_id='52979.Asgari Brüt Ücret'> (16)*</td>
						<td>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57613.Girmelisiniz'><cf_get_lang dictionary_id ='52979.Asgari Brüt Ücret'> (16) </cfsavecontent>
							<cfinput type="text" name="min_gross_payment_16" style="width:150px;"  value="#tlformat(get_insurance_payment.min_gross_payment_16)#" required="yes" message="#message#" onkeyup="return(FormatCurrency(this,event));">
						</td>
					</tr>
					<tr>
						<td height="20" colspan="2" class="txtbold"> 
							<cf_get_lang dictionary_id='57483.Kayıt'> :
							<cfif len(get_insurance_payment.record_emp)>
							<cfset attributes.employee_id = get_insurance_payment.record_emp>
							<cfinclude template="../query/get_employee_name.cfm">
							<cfoutput>#GET_EMPLOYEE_NAME.employee_name# #GET_EMPLOYEE_NAME.employee_surname#</cfoutput> - 
							<cfoutput> #dateformat(date_add('h',session.ep.time_zone,get_insurance_payment.record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,get_insurance_payment.record_date),timeformat_style)#)</cfoutput>
							</cfif>
						</td>
					</tr>
					<tr>
						<td height="35" colspan="2" style="text-align:right;">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='54016.Kayıtlı Sigorta Primine Esas Ücreti Siliyorsunuz Emin misiniz'></cfsavecontent>
						<cf_workcube_buttons is_upd='1'  delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_insurance_payments&ins_pay_id=#attributes.ins_pay_id#' delete_alert='#message#'> 
						</td>
					</tr>
				</table>
                </td>
        	</tr>
        </table>
    	</td>
	</tr>
</table>
</cfform>
<br/>
<script type="text/javascript">
	function UnformatFields()
	{
		form_add.minimum.value = filterNum(form_add.minimum.value);
		form_add.maximum.value = filterNum(form_add.maximum.value);
		form_add.min_gross_payment_normal.value = filterNum(form_add.min_gross_payment_normal.value);
		form_add.min_gross_payment_16.value = filterNum(form_add.min_gross_payment_16.value);
	}
</script>
