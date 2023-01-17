<cfquery name="GET_DET_SALESPARAM" datasource="#dsn#">
	SELECT 
    	SP_ID, 
        EMPLOYEE_ID, 
        START, 
        FINISH, 
        CIRO, 
        MONEY, 
        TERM, 
        PERCENTAGE 
    FROM 
    	SALESPARAM 
    WHERE 
	    EMPLOYEE_ID=#URL.EMPLOYEE_ID# AND START < #NOW()# AND FINISH > #NOW()#
</cfquery>
<cfform name="employe_detail1" method="post" action="#request.self#?fuseaction=ehesap.upd_salesparam" enctype="multipart/form-data">
  <cfif fuseaction contains "popup_">
    <input type="hidden" name="comes_popup" id="comes_popup" value="1">
  </cfif>
  <table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr>
      <td class="headbold"><cf_get_lang dictionary_id='53437.Satış Primi'></td>
    </tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr class="color-border">
      <td> <cfoutput>
        <table width="100%" align="center" cellpadding="2" cellspacing="1" border="0">
          <tr class="color-row">
            <td>
              <table  border="0">
                <tr class="txtboldblue">
                  <td width="200"><cf_get_lang dictionary_id='57576.Çalışan'></td>
                  <td width="150"><cf_get_lang dictionary_id='57501.Başlama'></td>
                  <td width="150"><cf_get_lang dictionary_id='57502.Bitiş'></td>
                </tr>
                <tr>
                  <td><input type="text" name="name" id="name" style="width:200px;" value="#get_emp_info(attributes.employee_id,0,0)#" readonly>
                    <input type="hidden" name="emp_id" id="emp_id" value="#url.employee_id#">
					<input type="hidden" name="in_out_id" id="in_out_id" value="#url.in_out_id#">
                    <input type="hidden" name="id" id="id" value="#get_det_salesparam.SP_ID#">
                  </td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
					<cfinput type="text" required="yes"  message="#message#" validate="#validate_style#" name="start" style="width:120px;" value="#dateformat(get_det_salesparam.start,dateformat_style)#">
                    <cf_wrk_date_image date_field="start"></td>
                  <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
					<cfinput type="text" required="yes"  message="#message#" validate="#validate_style#" name="finish" style="width:120px;" value="#dateformat(get_det_salesparam.finish,dateformat_style)#">
                    <cf_wrk_date_image date_field="finish"></td>
                </tr>
              </table>
              </cfoutput></td>
          </tr>
          <tr>
            <td valign="top" class="color-row">
              <table>
                <tr>
                  <td colspan="6" class="formbold"><cf_get_lang dictionary_id='53438.Ciro Primleri'></td>
                </tr>
                <tr class="txtboldblue">
                  <td width="80"><cf_get_lang dictionary_id='29472.Yöntem'></td>
                  <td width="150"><cf_get_lang dictionary_id='53439.dan Fazla'></td>
                  <td width="150"><cf_get_lang dictionary_id='53310.Periyod'></td>
                  <td width="80">%</td>
                </tr>
                <tr>
                  <td><select name="ciro" id="ciro" style="width:80px;">
                      <option value="1" <cfif get_det_salesparam.start eq  1>selected</cfif>><cf_get_lang dictionary_id='53440.Cirodan'></option>
                      <option value="2" <cfif get_det_salesparam.finish eq  2>selected</cfif>><cf_get_lang dictionary_id='53441.Kardan'></option>
                    </select>
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang dictionary_id='29535.tutar girmelisiniz'></cfsavecontent>
				  <cfinput type="text" name="money"  required="yes" message="#message#" validate="integer" style="width:150px;" value="#get_det_salesparam.money#">
                  </td>
                  <td><select name="term" id="term" style="width:150px;">
                      <option value="1" <cfif get_det_salesparam.term eq 1>selected</cfif>><cf_get_lang dictionary_id='53311.Ayda'> 1</option>
                      <option value="2" <cfif get_det_salesparam.term eq 2>selected</cfif>>3<cf_get_lang dictionary_id='53311.Ayda'> 1</option>
                      <option value="3" <cfif get_det_salesparam.term eq 3>selected</cfif>>6<cf_get_lang dictionary_id='53311.Ayda'> 1</option>
                      <option value="4" <cfif get_det_salesparam.term eq 4>selected</cfif>><cf_get_lang dictionary_id='53312.Yılda'> 1</option>
                    </select>
                  </td>
                  <td>
				  <cfsavecontent variable="message"><cf_get_lang dictionary_id='53443.yüzde girmelisiniz'></cfsavecontent>
				  <cfinput type="text" name="percentage" required="yes" message="#message#" validate="float" style="width:80px;" value="#get_det_salesparam.percentage#">
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td valign="top" class="color-row"><cf_workcube_buttons is_upd='0'></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</cfform>
<br/>
