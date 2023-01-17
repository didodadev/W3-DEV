<cfquery name="get_in_out" datasource="#DSN#">
SELECT * FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = #attributes.ID#
</cfquery>
<cfform name="cari" action="#request.self#?fuseaction=hr.emptypopup_upd_fire" method="post">
<input type="hidden" name="counter" id="counter">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
    <tr class="color-border">
      <td>
        <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
               <tr class="color-list"> 
      <td class="headbold" height="35">&nbsp;&nbsp;<cf_get_lang dictionary_id='55748.İşten Çıkarma'></td>
    </tr>
		  <tr class="color-row">
            <td valign="top">
              <table>
               <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.ID#</cfoutput>">
			    <tr>
                  <td width="5"></td>
                  <td width="100"><cf_get_lang dictionary_id='57576.Çalışan'></td>
                  <td class="txtbold">
			 <cfset attributes.employee_id = get_in_out.EMPLOYEE_ID>
			 <cfset attributes.position_code = "">
			<cfinclude template="../query/get_employee.cfm">
			<cfoutput>#get_employee.employee_name# #get_employee.employee_surname#</cfoutput>
				  </td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang dictionary_id='57628.Giriş Tarihi'></td>
                  <td class="txtbold"><cfoutput query="get_in_out">#dateformat(START_DATE,dateformat_style)#</cfoutput></td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></td>
                  <td class="txtbold"><cfoutput query="get_in_out">#dateformat(FINISH_DATE,dateformat_style)#</cfoutput></td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang dictionary_id='55751.Kıdem Tazminatı'></td>
                  <td class="txtbold"><cfoutput query="get_in_out">#TLFormat(KIDEM_AMOUNT)#</cfoutput></td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang dictionary_id='55752.İhbar Tazminatı'></td>
                  <td class="txtbold"><cfoutput query="get_in_out">#TLFormat(IHBAR_AMOUNT)#</cfoutput></td>
                </tr>
                <tr>
                  <td></td>
                  <td valign="top"><cf_get_lang dictionary_id='55550.Gerekçe'></td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
				  <textarea name="fire_detail" id="fire_detail" maxlength="300" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:150px;height:60px;"><cfoutput query="get_in_out">#detail#</cfoutput></textarea>
				  </td>
                </tr>
                <tr>
                  <td></td>
                  <td><cf_get_lang dictionary_id='57500.Onay'></td>
                  <td>
				   <cfset attributes.position_code = GET_IN_OUT.VALID_EMP>
				   <cfset attributes.employee_id = "">
				  <cfinclude template="../query/get_position.cfm">
				  <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#GET_IN_OUT.VALID_EMP#</cfoutput>">
				  <cfINPUT type="text" name="employee" value="#get_position.employee_name# #get_position.employee_surname#" style="width:150px;"  required="yes" message="<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='68.Onay Verecek Kişi'>"> 
				  <a href="javascript://" onClick=" windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_code=cari.position_code&field_name=cari.employee</cfoutput>','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>    
				  </td>
                </tr>
                 <tr>
						<td></td>
						<td height="20" colspan="2" class="txtbold"> 
						<cf_get_lang dictionary_id='57483.Kayıt'> :
						<cfif len(get_in_out.update_emp)>
									<cfoutput>#get_emp_info(get_in_out.update_emp,0,0)#</cfoutput> - 
									<cfoutput> #dateformat(date_add('h',session.ep.time_zone,get_in_out.update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,get_in_out.update_date),timeformat_style)#)</cfoutput>
						<cfelseif len(get_in_out.record_emp)>
								<cfoutput>#get_emp_info(get_in_out.record_emp,0,0)#</cfoutput> - 
								<cfoutput> #dateformat(date_add('h',session.ep.time_zone,get_in_out.record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,get_in_out.record_date),timeformat_style)#)</cfoutput>
						</cfif>
						</td>
						</tr>
				<tr>
                  <td style="text-align:right;" height="35" colspan="3">
				  		<cf_workcube_buttons is_upd='1'  delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_fire&id=#attributes.id#' delete_alert='İşten Çıkarmayı Siliyorsunuz! Emin misiniz?'>
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
