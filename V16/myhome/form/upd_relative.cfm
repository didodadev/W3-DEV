<cfquery name="GET_RELATIVE" datasource="#DSN#">
  SELECT
  	*
  FROM
 	EMPLOYEES_RELATIVES
  WHERE
	RELATIVE_ID=#attributes.RELATIVE_ID#
</cfquery>	
<cfquery name="get_edu_level" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_EDUCATION_LEVEL
</cfquery>
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
        <tr class="color-list" valign="middle">
          <td height="35" class="headbold">&nbsp;&nbsp;<cf_get_lang dictionary_id ='31961.Çalışan Yakını Güncelle'></td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td valign="top">
                  <table>
                    <cfform name="upd_relative" method="post" action="#request.self#?fuseaction=myhome.emptypopup_upd_relative">
                      <input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="<cfoutput>#attributes.EMPLOYEE_ID#</cfoutput>">
                      <input type="hidden" name="RELATIVE_ID" id="RELATIVE_ID" value="<cfoutput>#attributes.RELATIVE_ID#</cfoutput>">
                      <tr>
                        <td width="100"><cf_get_lang dictionary_id ='57631.Ad'> *</td>
                        <td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58939.ad girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="NAME" style="width:150px;"  value="#GET_RELATIVE.NAME#" required="yes" message="#message#">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id ='58726.Soyad'> *</td>
                        <td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='29503.soyad girmelisini'></cfsavecontent>
						<cfinput type="text" name="SURNAME" style="width:150px;" value="#GET_RELATIVE.SURNAME#" required="yes" message="#message#">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id ='31277.Yakınlık Derecesi'> *</td>
                        <td>
							<select name="RELATIVE_LEVEL" id="RELATIVE_LEVEL" style="width:150px;">
								<option value="1"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 1> selected</cfif>><cf_get_lang dictionary_id ='31962.Babası'></option>
								<option value="2"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 2> selected</cfif>><cf_get_lang dictionary_id ='31963.Annesi'></option>
								<option value="3"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 3> selected</cfif>><cf_get_lang dictionary_id ='31329.Eşi'></option>
								<option value="4"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 4> selected</cfif>><cf_get_lang dictionary_id ='31330.Oğlu'></option>
								<option value="5"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 5> selected</cfif>><cf_get_lang dictionary_id ='31331.Kızı'></option>
								<option value="5"<cfif GET_RELATIVE.RELATIVE_LEVEL eq 6> selected</cfif>><cf_get_lang dictionary_id ='31449.Kardeşi'></option>
							</select>		
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id='58727.Doğum Tarihi'> *</td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang dictionary_id='31240.doğum tarihi girmelisiniz'></cfsavecontent>
						  <cfinput validate="#validate_style#" type="text" name="BIRTH_DATE" value="#DateFormat(GET_RELATIVE.BIRTH_DATE,dateformat_style)#" style="width:70px;" required="yes" message="#message#">
                          <cf_wrk_date_image date_field="BIRTH_DATE"></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id='57790.Doğum Yeri'> *</td>
                        <td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='31324.doğum yeri girmelisi'></cfsavecontent>
						<cfinput type="text" name="BIRTH_PLACE" style="width:150px;" value="#GET_RELATIVE.BIRTH_PLACE#" required="yes" message="#message#">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id ='58025.TC Kimlik No'> *</td>
                        <td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58687.TC Kimlik Numarası Girmelisiniz'> !</cfsavecontent>
						<cfinput type="text" name="TC_IDENTY_NO" style="width:150px;" value="#GET_RELATIVE.TC_IDENTY_NO#" validate="integer" required="yes" message="#message#">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id='31326.Eğitim Durumu'></td>
                        <td>
							<select name="EDUCATION" id="EDUCATION"  style="width:150px;">
								<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
								<cfoutput query="get_edu_level">
									<option value="#EDU_LEVEL_ID#"  <cfif GET_RELATIVE.EDUCATION eq EDU_LEVEL_ID >selected</cfif>>#EDUCATION_NAME#</option>							
								</cfoutput>
							</select>
							<input type="checkbox" name="education_status" id="education_status" value="1"<cfif GET_RELATIVE.EDUCATION_STATUS eq 1>Checked</cfif>><cf_get_lang dictionary_id ='31332.Okuyor'>
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id ='31278.Meslek'></td>
                        <td><input type="text" name="JOB" id="JOB" style="width:150px;" value="<cfoutput>#GET_RELATIVE.JOB#</cfoutput>">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id ='57574.Şirket'></td>
                        <td><input type="text" name="COMPANY" id="COMPANY" style="width:150px;" value="<cfoutput>#GET_RELATIVE.COMPANY#</cfoutput>">
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang dictionary_id ='58497.Pozisyon'></td>
                        <td><input type="text" name="JOB_POSITION" id="JOB_POSITION" style="width:150px;" value="<cfoutput>#GET_RELATIVE.JOB_POSITION#</cfoutput>">
                        </td>
                      </tr>
                      <tr>
                        <td height="35" colspan="2"  style="text-align:right;">
						<cf_workcube_buttons is_upd='1' insert_alert='' delete_page_url='#request.self#?fuseaction=myhome.emptypopup_del_relative#page_code#'> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
                      </tr>
                    </cfform>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
