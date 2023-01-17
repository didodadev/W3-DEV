<cfinclude template="../query/get_branch.cfm">
<cfinclude template="../query/get_punishment_type.cfm">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.punishment_type_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.assetp_name" default="">
<cfparam name="attributes.assetp_id" default="">
<cfparam name="attributes.accident_relation" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cf_box>
  <cfform name="search_punishment" method="post">
    <cf_box_search>
      <div class="form-group">
        <div class="input-group">
          <cfsavecontent variable="place"><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>
          <cfinput type="hidden" name="branch_id" id="branch_id" value="#attributes.branch_id#">
          <cfinput type="text" name="branch_name" id="branch_name" value="#attributes.branch_name#" placeholder="#place#" style="width:180px;" readonly="yes"> 
          <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=search_punishment.branch_id&field_branch_name=search_punishment.branch_name&select_list=1','list','popup_list_branches')"></span> 
        </div>
      </div>
      <div class="form-group">
        <div class="input-group">
          <cfsavecontent variable="place"><cf_get_lang dictionary_id='29453.Plaka'></cfsavecontent>
          <cfinput type="hidden" name="assetp_id" id="assetp_id" value="#attributes.assetp_id#">
          <cfinput type="text" name="assetp_name" id="assetp_name" value="#attributes.assetp_name#" placeholder="#place#" style="width:120px;"> 
          <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=search_punishment.assetp_id&field_name=search_punishment.assetp_name&list_select=2','list','popup_list_ship_vehicles');"></span> 
        </div>
      </div>
      <div class="form-group">
        <div class="input-group">
          <cfsavecontent variable="place"><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
          <cfinput type="text" name="start_date" id="start_date" placeholder="#place#" maxlength="10" style="width:120px">
          <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
        </div>
      </div>
      <div class="form-group">
        <div class="input-group">
          <cfsavecontent variable="place"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
          <cfinput type="text" name="finish_date" id="finish_date" maxlength="10" placeholder="#place#" validate="#validate_style#" message="#place#" style="width:120px"> 
          <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
        </div>
      </div>
      <div class="form-group">
        <select name="punishment_type_id" id="punishment_type_id" style="width:180px;">
          <option value=""><cf_get_lang dictionary_id='48285.Ceza Tipi'></option>
          <cfoutput query="get_punishment_type"> 
            <option value="#punishment_type_id#">#punishment_type_name#</option>
          </cfoutput>
        </select>
      </div>
      <div class="form-group">
        <div class="input-group">
          <cfsavecontent variable="place"><cf_get_lang dictionary_id='57544.Sorumlu'></cfsavecontent>
          <cfinput type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">
          <cfinput type="text" name="employee_name" id="employee_name" value="#attributes.employee_name#" placeholder="#place#" style="width:120px;"> 
          <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_all_positions&field_emp_id=search_punishment.employee_id&field_name=search_punishment.employee_name&select_list=9,1</cfoutput>','list','popup_list_all_positions');"></span>
        </div>
      </div>
      <div class="form-group small">
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
      </div>
      <div class="form-group">
        <cf_wrk_search_button search_function='kontrol()' button_type="4">
      </div>
    </cf_box_search>
    <cf_box_search_detail>
      <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
        <div class="form-group">
          <label class="col col-6"><cf_get_lang dictionary_id='48287.Ceza Tarihi'></label>
          <div class="col col-6">
            <div class="input-group">
              <input name="date_interval" id="date_interval" type="radio" value="1" checked>
            </div>
          </div>
        </div>
        <div class="form-group">
          <label class="col col-6"><cf_get_lang dictionary_id='48056.Son Ödeme Tarihi'></label>
          <div class="col col-6">
            <div class="input-group">
              <input name="date_interval" id="date_interval" type="radio" value="2">
            </div>
          </div>
        </div>
        <div class="form-group">
          <label class="col col-6"><cf_get_lang dictionary_id='48318.Ödeme Tarihi'></label>
          <div class="col col-6">
            <div class="input-group">
              <input name="date_interval" id="date_interval" type="radio" value="3">
            </div>
          </div>
        </div>
      </div>
      <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
        <div class="form-group">
          <label class="col col-6"><cf_get_lang dictionary_id='48317.Kaza İlşkisi'></label>
          <div class="col col-6">
            <div class="input-group">
              <input name="accident_relation" id="accident_relation" type="radio" value="1" checked>
            </div>
          </div>
        </div>
        <div class="form-group">
          <label class="col col-6"><cf_get_lang dictionary_id='58081.Hepsi'></label>
          <div class="col col-6">
            <div class="input-group">
              <input name="accident_relation" id="accident_relation" type="radio" value="2">
            </div>
          </div>
        </div>
        <div class="form-group">
          <label class="col col-6"><cf_get_lang dictionary_id='48324.Kazalı'><cf_get_lang dictionary_id='48325.Kazasız'></label>
          <div class="col col-6">
            <div class="input-group">
              <input name="accident_relation" id="accident_relation" type="radio" value="3">
            </div>
          </div>
        </div>
      </div>
    </cf_box_search_detail>
  </cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.search_punishment.maxrows.value>200)
		{
			alert("<cf_get_lang dictionary_id ='729.Maxrows Değerini Kontrol Ediniz'>");
			return false;
		}
		return true;
		
		if(!CheckEurodate(document.search_punishment.start_date.value,'<cf_get_lang dictionary_id="641.Başlangıç Tarihi">'))
		{
			return false;
		}
		
		if(!CheckEurodate(document.search_punishment.finish_date.value,'<cf_get_lang dictionary_id ="288.Bitiş Tarihi">'))
		{
			return false;
		}
		
		if ((document.search_punishment.start_date.value.length>0) && (document.search_punishment.finish_date.value.length>0) && (!date_check(document.search_punishment.start_date,document.search_punishment.finish_date,"<cf_get_lang dictionary_id='394.Tarih Aralığını Kontrol Ediniz'>!")) )
		{
			return false;
		}
		return true;
	}
</script>
