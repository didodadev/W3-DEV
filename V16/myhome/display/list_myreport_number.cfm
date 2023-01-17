<cfinclude template="../query/my_sett.cfm">
<cfif isdefined("attributes.employee_id")>
  <cfquery name="get_employee_name" datasource="#DSN#">
	  SELECT 
		  EMPLOYEE_NAME , 
		  EMPLOYEE_SURNAME 
	  FROM 
		  EMPLOYEES 
	  WHERE 	
	  	  EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
  </cfquery>
</cfif>
<table border="0" cellspacing="1" cellpadding="2" width="100%" height="100%">
	<tr>
		<td valign="top" width="350">
			<cfform name="me" action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=center_down" method="POST">
				<cfif isdefined("attributes.employee_id")>
					<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
				</cfif>
                <cfif fusebox.use_period eq 1>
                    <cfquery DATASOURCE="#DSN3#" NAME="GET_NUMBERS">
                        SELECT 
                            * 
                        FROM 
                            PAPERS_NO 
                        WHERE
                            <cfif isdefined("attributes.employee_id")>
                                EMPLOYEE_ID=#attributes.employee_id#
                            <cfelse>
                                EMPLOYEE_ID=#SESSION.EP.USERID#
                            </cfif>
                    </cfquery>
              	</cfif>
				<table width="100%" border="0">
					<tr>
						<td colspan="2" class="txtboldblue"><cf_get_lang dictionary_id='31068.Belge No Ayarları'></td>
					</tr>
				</table>
				<cfif fusebox.use_period eq 1>
					<cfoutput>
						<table width="100%" border="0">
							<cfif (not (get_module_user(16) eq 0) and (get_module_user(16) lte 4))  or (not (get_module_user(32) eq 0) and (get_module_user(32) lte 4))>
								<tr>
									<td width="120"><cf_get_lang dictionary_id='31069.Tahsilat Makbuzu No'></td>
									<td>
										<input type="Text" name="revenue_receipt_no" id="revenue_receipt_no" maxlength="50" value="#get_numbers.revenue_receipt_no#" style="width:58px;">
										<cfinput type="Text" name="revenue_receipt_number" maxlength="50" value="#get_numbers.revenue_receipt_number#" onkeyup="isNumber(this);" size="4" style="width:90px;" validate="integer">					
									</td>
								</tr>
							</cfif>
							<cfif (not (get_module_user(20) eq 0) and (get_module_user(20) lte 4)) or  (not (get_module_user(32) eq 0) and (get_module_user(32) lte 4))>
								<tr>
									<td><cf_get_lang dictionary_id='58133.Fatura No'></td>
									<td>
										<input type="Text" name="invoice_no" id="invoice_no" maxlength="50" value="#get_numbers.invoice_no#" style="width:58px;">
										<cfinput type="Text" name="invoice_number"  maxlength="50" value="#get_numbers.invoice_number#" onkeyup="isNumber(this);" size="4" style="width:90px;" validate="integer">					
									</td>
								</tr>
							</cfif>
							<cfif session.ep.our_company_info.is_efatura and ((not (get_module_user(20) eq 0) and (get_module_user(20) lte 4)) or  (not (get_module_user(32) eq 0) and (get_module_user(32) lte 4)))>
								<tr>
									<td>E-<cf_get_lang dictionary_id='58133.Fatura No'></td>
									<td>
										<input type="Text" name="e_invoice_no" id="e_invoice_no" maxlength="3" value="#get_numbers.e_invoice_no#" style="width:58px;">
										<cfinput type="Text" name="e_invoice_number"  maxlength="13" value="#numberformat(get_numbers.e_invoice_number,0000000000000)#" onkeyup="isNumber(this);" size="4" style="width:90px;" validate="integer">					
									</td>
								</tr>
							</cfif>
							<cfif (not (get_module_user(13) eq 0) and (get_module_user(13) lte 4)) or  (not (get_module_user(32) eq 0) and (get_module_user(32) lte 4))>
								<tr>
									<td><cf_get_lang dictionary_id='58138.İrsaliye No'></td>
									<td>
										<input type="Text" name="ship_no" id="ship_no" maxlength="50"  value="#get_numbers.ship_no#" style="width:58px;">
										<cfinput type="Text" name="ship_number" value="#get_numbers.ship_number#"  style="width:90px;" onkeyup="isNumber(this);" size="4" validate="integer">
									</td>
								</tr>
							</cfif>
							<tr>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
								<td><div id="SHOW_INFO" style="float:left; margin-top:3px; width:90px;"></div><input type="button" name="button1" id="button1" value="<cf_get_lang dictionary_id='57464.Güncelle'>" onClick="return control();"></td>
							</tr>
						</table>
					</cfoutput>
                </cfif>
			</cfform>
		</td>
	</tr>
</table>
<script type="text/javascript">
	function control()
	{
		<cfif session.ep.our_company_info.is_efatura and ((not (get_module_user(20) eq 0) and (get_module_user(20) lte 4)) or  (not (get_module_user(32) eq 0) and (get_module_user(32) lte 4)))>
			if( document.getElementById('e_invoice_no').value.length !=0 ||  document.getElementById('e_invoice_number').value.length !=0)
			{
				if( document.getElementById('e_invoice_no').value.length < 3 )
				{
					alert('<cf_get_lang dictionary_id="59943.E-Fatura Ön Eki 3 Karakter Olmalıdır"> !');
					document.getElementById('e_invoice_no').focus();
					return false;
				} 
				if( document.getElementById('e_invoice_number').value.length <13)
				{
					alert('<cf_get_lang dictionary_id="59944.E-Fatura Numarası 13 Karakter Olmalıdır"> !');
					document.getElementById('e_invoice_number').focus();
					return false;
				} 
			}
		</cfif>
        AjaxFormSubmit('me','SHOW_INFO',1,'Güncelleniyor','Güncellendi');
	}
</script>

