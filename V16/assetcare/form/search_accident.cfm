<cfparam name="attributes.assetp_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.accident_id" default="">
<cfparam name="attributes.document_type_id" default="">
<cfparam name="attributes.insurance_status" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfinclude template="../query/get_assetp_cats.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfform name="search_accident" onSubmit="return kontrol();" target="frame_accident_search" method="post" action="#request.self#?fuseaction=assetcare.popup_list_accident_search&is_submitted=1&iframe=1">
  <cf_box_elements>

    <div class="col col-8 col-md-8 col-sm-8 col-xs-12" index="1" type="column" sort="true">
      <div class="col col-4 col-md-4 col-sm-4 col-xs-12"  type="column" sort="true">

        <div class="form-group" id="branch_id">
          <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41443.Plaka'></label>
          <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
              <div class="input-group">
                <input type="hidden" name="assetp_id" id="assetp_id" value="">
                <input type="text" name="assetp_name" id="assetp_name" style="width:130px;" readonly> 
                <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=search_accident.assetp_id&field_name=search_accident.assetp_name&list_select=2','list','popup_list_ship_vehicles');"></span> 
              </div>
          </div>
        </div>

      <div class="form-group" id="branch_id">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
          <div class="input-group">
          <input type="hidden" name="employee_id" id="employee_id" value="">
              <input type="text" name="employee_name" id="employee_name" value="" style="width:130px;"> 
              <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_positions&field_emp_id=search_accident.employee_id&field_name=search_accident.employee_name&select_list=9,1','list','popup_list_all_positions')"></span>
            
          </div>
          </div>
      </div>

      <div class="form-group" id="branch_id">
        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
        <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
          <div class="input-group">

          <input type="hidden" name="branch_id" id="branch_id" value="">
          <input type="text" name="branch_name" id="branch_name" value="" style="width:130px;" readonly>
          <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=search_accident.branch_id&field_branch_name=search_accident.branch_name&select_list=1','list','popup_list_branches')"></span>
       
          </div>
          </div>
      </div>


    </div>

      <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="2" type="column" sort="true">

        <div class="form-group" id="branch_id">
          <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43132.Kaza Tipi'></label>
          <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
            <cf_wrk_combo
            name="accident_type_id"
            query_name="GET_ACCIDENT_TYPE"
            option_name="accident_type_name"
            option_value="accident_type_id"
            option_text=""
            width="130">
          </div>
        </div>

        <div class="form-group" id="branch_id">
          <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58533.Belge Tipi'></label>
          <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
              <select name="document_type_id" id="document_type_id" style="width:130px;">
                <option value=""></option>
                <cfoutput query="get_document_type"> 
                  <option value="#document_type_id#">#document_type_name#</option>
                </cfoutput>
              </select>
          </div>
        </div>

        <div class="form-group" id="branch_id">
          <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
          <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
              <input type="text" name="document_num" id="document_num" style="width:130px;" maxlength="20">
          </div>
        </div>

      </div>
      <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="2" type="column" sort="true">

        <div class="form-group" id="branch_id">
          <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='55658.Kayıt No'></label>
          <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
            <input name="record_num" id="record_num" type="text" style="width:130px;">
          </div>
        </div>

        <div class="form-group" id="branch_id">
          <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
          <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
            <div class="input-group">
            <input type="text" name="start_date" id="start_date" maxlength="10" style="width:130px"> 
						<span class="input-group-addon"  <i class="fa fa-calendar " ><cf_wrk_date_image date_field="start_date" ></i></span>
          </div>
          </div>
        </div>

        <div class="form-group" id="branch_id">
          <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
          <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
            <div class="input-group">
            <input type="text" name="finish_date" id="finish_date" maxlength="10" style="width:130px"> 
						<span class="input-group-addon" <i class="fa fa-calendar"><cf_wrk_date_image date_field="finish_date"  ></i></span>
              <!--- date_form="search_accident"  kaldrıldı ---> 
            </div>
          </div>
        </div>

        <div class="form-group" id="branch_id">
          <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48270.Sigorta Ödemesi'></label>
          <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
            <div class="col"> 
              <cf_get_lang dictionary_id='58081.Hepsi'> 
                <input name="is_insurance_payment" id="is_insurance_payment" type="radio" value="1" checked>
              </div>
              <div class="col"> 
                <cf_get_lang dictionary_id='58564.Var'> 
                  <input name="is_insurance_payment" id="is_insurance_payment" type="radio" value="2">
                </div>
                <div class="col"> 
                  <cf_get_lang dictionary_id='58546.Yok'>
                    <input name="is_insurance_payment" id="is_insurance_payment" type="radio" value="3">
                  </div>
            
          </div>
        </div>
      
      </div>


    </div>

  </cf_box_elements>
    <cf_box_footer>
         <cfsavecontent variable="message"><cf_get_lang dictionary_id='34135.Sayı Hatası Mesaj'></cfsavecontent>
        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
        <input name="submit" type="submit" value="<cf_get_lang dictionary_id='57565.Ara'>">
          <input name="reset" class="ui-wrk-btn ui-wrk-btn-red" style="margin:0.5rem;" type="reset" value="<cf_get_lang dictionary_id='57934.Temizle'>">
          </cf_box_footer>
</cfform>
<script type="text/javascript">
function kontrol()
{
	if(document.search_accident.maxrows.value>200)
	{
		alert("<cf_get_lang dictionary_id ='729.Maxrows Değerini Kontrol Ediniz'> !");
		return false;
	}

	if(!CheckEurodate(document.search_accident.start_date.value,'<cf_get_lang dictionary_id="58053.Başlangıç Tarihi">'))
	{
		return false;
	}
	
	if(!CheckEurodate(document.search_accident.finish_date.value,'<cf_get_lang dictionary_id ="57700.Bitiş Tarihi">'))
	{
		return false;
	}
	
	if ((document.search_accident.start_date.value.length>0) && (document.search_accident.finish_date.value.length>0) && (!date_check(document.search_accident.start_date,document.search_accident.finish_date,"<cf_get_lang dictionary_id='57806.Tarih Aralığını Kontrol Ediniz'>!")) )
	{
		return false;
	}
	return true;
}
</script>
