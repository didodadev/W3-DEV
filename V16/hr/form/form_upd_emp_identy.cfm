<cf_xml_page_edit fuseact="hr.form_upd_emp_identy">
<cfif not isdefined("get_emp_detail")>
  <cfinclude template="../query/get_emp_identy.cfm">
</cfif>
<cfquery name="get_country" datasource="#dsn#">
	SELECT COUNTRY_ID,COUNTRY_NAME,IS_DEFAULT FROM SETUP_COUNTRY ORDER BY COUNTRY_NAME
</cfquery>
<cfquery name="get_city" datasource="#dsn#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55127.Kimlik Bilgileri"></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
  <cf_box title="#message#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
      <cfform action="#request.self#?fuseaction=hr.emptypopup_upd_emp_identy" method="post" name="employee_identy">
        <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
        <cf_box_elements>
          <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
            <div class="form-group" id="item-nationality">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56135.Uyruğu'></label>
              <div class="col col-8 col-xs-12">
                <select name="nationality" id="nationality" style="width:150px;">
                  <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                  <cfoutput query="get_country">
                    <option value="#country_id#" <cfif get_country.country_id eq get_emp_identy.nationality or (not len(get_emp_identy.nationality) and is_default eq 1)>selected</cfif>>#country_name#</option>
                  </cfoutput>
                </select>
              </div>
            </div>
            <div class="form-group" id="item-tc_identy_no">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55636.Cüzdan SeriNo'></label>
              <div class="col col-8 col-xs-12">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                  <cfinput type="text" name="series" style="width:50px;" maxlength="20" value="#get_emp_identy.series#">
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                  <cfinput type="text" name="number" style="width:95px;" maxlength="50" value="#get_emp_identy.number#">
                </div>
              </div>
            </div>
            <div class="form-group" id="item-father">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58033.Baba Adı'></label>
              <div class="col col-8 col-xs-12">
                <cfinput name="father" type="text" value="#get_emp_identy.father#" maxlength="75" style="width:150px;">
              </div>
            </div>
            <div class="form-group" id="item-birth_date">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
              <div class="col col-8 col-xs-12">
                <div class="input-group">
                  <cfsavecontent variable="message"><cf_get_lang dictionary_id='55788.Doğum Tarihi girmelisiniz'></cfsavecontent>
                  <cfinput type="text" style="width:150px;" name="birth_date" value="#dateformat(get_emp_identy.birth_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                  <span class="input-group-addon"><cf_wrk_date_image date_field="birth_date"></span>
                </div>
              </div>
            </div>
            <div class="form-group" id="item-birth_place">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" style="width:150px;" name="birth_place" maxlength="100" value="#get_emp_identy.birth_place#">
              </div>
            </div>
            <div class="form-group" id="item-birth_city">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'> <cf_get_lang dictionary_id='58608.İl'></label>
              <div class="col col-8 col-xs-12">
                <select name="birth_city" id="birth_city" style="width:150px;">
                  <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                  <cfoutput query="get_city">
                    <option value="#city_id#"<cfif get_emp_identy.birth_city eq city_id>selected</cfif>>#city_name#</option>
                  </cfoutput>
                </select>	
              </div>
            </div>
            <div class="form-group" id="item-last_surname">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55640.Önceki Soyadı'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="LAST_SURNAME" style="width:150px;" maxlength="100" value="#get_emp_identy.LAST_SURNAME#">
              </div>
            </div>
          </div>
          <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
            <div class="form-group" id="item-tc_no">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58025.TC Kimlik'> *</label>
              <div class="col col-8 col-xs-12">
                <cfquery name="geT_employee" datasource="#dsn#">
                  SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #attributes.employee_id#
                </cfquery>
                <input type="Hidden" name="name" id="name" value="<cfoutput>#geT_employee.employee_name#</cfoutput>">
                <input type="Hidden" name="surname" id="surname" value="<cfoutput>#geT_employee.employee_surname#</cfoutput>">
                <cf_wrkTcNumber fieldId="TC_IDENTY_NO" tc_identity_required="#is_tc_number#" width_info='150' is_verify='1' consumer_name='name' consumer_surname='surname' birth_date='birth_date' tc_identity_number='#get_emp_identy.TC_IDENTY_NO#'>
              </div>
            </div>
            <div class="form-group" id="item-mother">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58440.Ana Adı'></label>
              <div class="col col-8 col-xs-12">
                <cfinput name="mother" type="text" value="#get_emp_identy.mother#" maxlength="75" style="width:150px;">
              </div>
            </div>
            <div class="form-group" id="item-religion">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55651.Dini'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="religion" style="width:150px;" maxlength="50" value="#get_emp_identy.religion#">
              </div>
            </div>
            <div class="form-group" id="item-blood_type">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58441.Kan Grubu'></label>
              <div class="col col-8 col-xs-12">
                  <!---<cfinput type="text" name="BLOOD_TYPE" style="width:50px;" maxlength="5" value="#get_emp_identy.BLOOD_TYPE#">--->
                  <select name="BLOOD_TYPE" id="BLOOD_TYPE" style="width:150px;">
                    <option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
                    <option value="0"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 0)>SELECTED</cfif>>0 Rh+</option>
                    <option value="1"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 1)>SELECTED</cfif>>0 Rh-</option>
                    <option value="2"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 2)>SELECTED</cfif>>A Rh+</option>
                    <option value="3"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 3)>SELECTED</cfif>>A Rh-</option>
                    <option value="4"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 4)>SELECTED</cfif>>B Rh+</option>
                    <option value="5"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 5)>SELECTED</cfif>>B Rh-</option>
                    <option value="6"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 6)>SELECTED</cfif>>AB Rh+</option>
                    <option value="7"<cfif LEN(get_emp_identy.BLOOD_TYPE) AND (get_emp_identy.BLOOD_TYPE EQ 7)>SELECTED</cfif>>AB Rh-</option>
                </select>
              </div>
            </div>
            <div class="form-group" id="item-tax_number">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="Text" name="tax_number" value="#get_emp_identy.tax_number#" style="width:150px;" maxlength="50">
              </div>
            </div>
            <div class="form-group" id="item-tax_office">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="tax_office" value="#get_emp_identy.tax_office#" style="width:150px;" maxlength="50">
              </div>
            </div>
            <div class="form-group" id="item-married">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55654.Medeni Durum'></label>
              <div class="col col-4 col-xs-12">
                <input type="radio" name="married" id="married" value="0" <cfif get_emp_identy.married EQ 0>checked</cfif>><cf_get_lang dictionary_id='55744.Bekar'>
              </div>
              <div class="col col-4 col-xs-12">
                <input type="radio" name="married" id="married" value="1" <cfif get_emp_identy.married EQ 1>checked</cfif>><cf_get_lang no='658.Evli'>
              </div>
            </div>
          </div>
          <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
            <div class="form-group" id="item-registered_city">
              <label class="col col-4 col-xs-12"><STRONG><cf_get_lang dictionary_id='55641.Nüfusa Kayıtlı Olduğu'></STRONG></label>
              <div class="col col-8 col-xs-12">
              </div>
            </div>
            <cfif xml_is_socialsec_no eq 1>
              <div class="form-group" id="item-socialsec_no">
                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56606.Sosyal Güvenlik No'></label>
                <div class="col col-8 col-xs-12">
                  <cfinput type="text" name="socialsec_no" style="width:150px" maxlength="50" value="#get_emp_identy.SOCIALSECURITY_NO#">
                </div>
              </div>
            </cfif>
            <div class="form-group" id="item-city">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58608.İl'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="CITY" style="width:150px;" maxlength="100" value="#get_emp_identy.CITY#">
              </div>
            </div>
            <div class="form-group" id="item-county">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="COUNTY" style="width:150px;" maxlength="100" value="#get_emp_identy.COUNTY#">
              </div>
            </div>
            <div class="form-group" id="item-ward">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58735.Mahalle'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="WARD" style="width:150px;" maxlength="100" value="#get_emp_identy.WARD#">
              </div>
            </div>
            <div class="form-group" id="item-village">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55645.Köy'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="VILLAGE" style="width:150px;" maxlength="100" value="#get_emp_identy.VILLAGE#">
              </div>
            </div>
            <div class="form-group" id="item-binding">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55655.Cilt No'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="BINDING" style="width:150px;" maxlength="20" value="#get_emp_identy.BINDING#">
              </div>
            </div>
            <div class="form-group" id="item-family">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55656.Aile Sıra No'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="FAMILY" style="width:150px;" maxlength="20" value="#get_emp_identy.FAMILY#">
              </div>
            </div>
            <div class="form-group" id="item-cue">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55657.Sıra No'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="CUE" style="width:150px;" maxlength="20" value="#get_emp_identy.CUE#">
              </div>
            </div>
          </div>
          <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
            <div class="form-group" id="item-id_information">
              <label class="col col-4 col-xs-12"><STRONG><cf_get_lang dictionary_id='55646.Cüzdanın'></STRONG></label>
              <div class="col col-8 col-xs-12">
              </div>
            </div>
            <div class="form-group" id="item-given_place">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55647.Verildiği Yer'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="GIVEN_PLACE" style="width:150px;" maxlength="100" value="#get_emp_identy.GIVEN_PLACE#">
              </div>
            </div>
            <div class="form-group" id="item-given_reason">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55648.Veriliş Nedeni'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="GIVEN_REASON" style="width:150px;" maxlength="300" value="#get_emp_identy.GIVEN_REASON#">
              </div>
            </div>
            <div class="form-group" id="item-record_number">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55658.Kayıt No'></label>
              <div class="col col-8 col-xs-12">
                <cfinput type="text" name="RECORD_NUMBER" style="width:150px;" maxlength="50" value="#get_emp_identy.RECORD_NUMBER#">
              </div>
            </div>
            <div class="form-group" id="item-given_date">
              <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55659.Veriliş Tarihi'></label>
              <div class="col col-8 col-xs-12">
                <div class="input-group">
                  <cfsavecontent variable="message"><cf_get_lang dictionary_id='55790.Veriliş Tarihi girmelisiniz'></cfsavecontent>
                  <cfinput type="text" style="width:150px;" name="GIVEN_DATE" value="#dateformat(get_emp_identy.GIVEN_DATE,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
                  <span class="input-group-addon"><cf_wrk_date_image date_field="GIVEN_DATE"></span>
                </div>
              </div>
            </div>
          </div>
        </cf_box_elements>
        <cf_box_footer>
          <cf_record_info query_name="get_emp_identy">
          <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </cf_box_footer>
      </cfform>
    </cf_box>
</div>
<script type="text/javascript">
<cfif isdefined("is_tc_number")>
	var is_tc_number = '<cfoutput>#is_tc_number#</cfoutput>';
<cfelse>
	var is_tc_number = 0;
</cfif>

function kontrol()
{
	if(is_tc_number == 1)
	{
		if(!isTCNUMBER(document.getElementById('TC_IDENTY_NO'))) return false;
	}
	if (document.getElementById('TC_IDENTY_NO').value.length < 11) 
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='58025.TC Kimlik No'>");
		return false;
	}
  <cfoutput>
    #iif(isdefined("attributes.draggable"),DE("loadPopupBox('employee_identy' , #attributes.modal_id#)"),DE(""))#
  </cfoutput>
}
</script>
