<cfset attributes.train_id = attributes.id>
<cfset attributes.TRAINING_ID = attributes.train_id>
<cfinclude template="../query/get_training_subject.cfm">
<cfif len(get_training_subject.training_sec_id)>
	<cfset attributes.training_sec_id = get_training_subject.training_sec_id>
	<cfinclude template="../query/get_training_sec.cfm">
<cfelse>
	<cfset attributes.training_sec_id = ''>
</cfif>

<table width="700" align="center">
  <tr>
    <td height="35" class="headbold"><cf_get_lang no='147.Eğitim Konusu'> : <cfoutput>#get_training_subject.train_head#</cfoutput></td>
  </tr>
</table>
			
				<cfoutput>				  
				  <table width="700" align="center">
                    <tr  height="20">
                      <td width="75" class="txtbold"><cf_get_lang_main no='74.Bölüm'></td>
                      <td><cfif len(attributes.training_sec_id)>#get_training_sec.section_name#</cfif></td>
                    </tr>
                    <tr  height="20">
                      <td class="txtbold"><cf_get_lang_main no='344.Durum'></td>
                      <cfif GET_TRAINING_SUBJECT.SUBJECT_STATUS eq 1>
                        <td><cf_get_lang_main no='81.Aktif'></td>
                        <cfelse>
                        <td><cf_get_lang_main no='82.Pasif'></td>
                      </cfif>
                    </tr>
                    <tr  height="20">
                      <td  class="txtbold"><cf_get_lang_main no='70.Aşama'></td>
                        <td> <!---#get_currency.STAGE_NAME#---></td> 
                    </tr>
                    <tr  height="20">
                      <td class="txtbold"><cf_get_lang no='32.Amaç'></td>
                      <td>#get_training_subject.train_objective# </td>
                    </tr>
                    <tr height="20" >
                      <td class="txtbold"><cf_get_lang_main no='1978.Hazırlayan'></td>
                      <td>
                        <cfif len(get_training_subject.RECORD_EMP)>
                          <cfset attributes.employee_id = get_training_subject.RECORD_EMP>
                          <cfinclude template="../query/get_employee.cfm">
       					 #get_employee.employee_name# #get_employee.employee_surname#
                        </cfif>
                        <cfif len(get_training_subject.RECORD_PAR)>
                          <cfset attributes.partner_id = get_training_subject.RECORD_PAR>
                          <cfinclude template="../query/get_partner.cfm">
        					#get_partner.company_partner_name# #get_partner.company_partner_surname#
                        </cfif>
      					- #dateformat(get_training_subject.record_date,dateformat_style)#</td>
                    </tr>
                    <tr height="20" >
                      <td colspan="2" class="txtbold"><hr></td>
                    </tr>
                    <tr height="20">
                      <td colspan="2"> <br/>
                          <cfif len(get_training_subject.train_detail)>
        					#get_training_subject.train_detail#
                          </cfif>
                          <br/>
                      </td>
                    </tr>
                  </table>
				</cfoutput> 
				</td>
              </tr>
            </table>
<br/>
