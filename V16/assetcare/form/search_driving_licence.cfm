<!---E.A 17 temmuz 2012 select ifadeleriyle alakalı işlem uygulanmıştır.--->
<cfinclude template="../query/get_fuel_type.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfinclude template="../query/get_branch.cfm">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.driver_licence_type" default="">
<cfparam name="attributes.driver_licence_year" default="">
<cfparam name="attributes.fuel_type" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfquery name="get_licence_type" datasource="#DSN#">
	SELECT LICENCECAT_ID,LICENCECAT FROM SETUP_DRIVERLICENCE ORDER BY LICENCECAT
</cfquery>
<cfform name="search_driving_licence" target="frame_search_driving_licence" method="post" action="#request.self#?fuseaction=assetcare.popup_list_driving_licence&is_submitted=1&iframe=1">
  <cf_box_elements>

    <div class="col col-12" type="column" index="1" sort="true">

    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">

			<div class="form-group" id="item-fuel_num">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
          <div class="col col-8 col-xs-12">
            <div class="input-group">
              <input type="hidden" name="employee_id" id="employee_id" value="">              
              <cfinput type="text" name="employee_name" value="" >
              <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_driving_licence.employee_id&field_name=search_driving_licence.employee_name&select_list=1','list','popup_list_positions')"></span>
            
            </div>
          </div>
			</div>
      <div class="form-group" id="item-department">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
            <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
            <input type="text" name="branch" id="branch" readonly value="<cfoutput>#attributes.branch#</cfoutput>" style="width:130px;">
              <span class="input-group-addon icon-ellipsis"onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=search_driving_licence.branch_id&field_branch_name=search_driving_licence.branch','list','popup_list_branches');"></span>
        
          </div>
				</div>
			</div>

		</div>
    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">

      <div class="form-group" id="item-department">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48345.Ehliyet Tipi'></label>
				<div class="col col-8 col-xs-12">
					<select name="driver_licence_type" id="driver_licence_type" style="width:130px;">
            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
            <cfoutput query="get_licence_type">
              <option value="#licencecat_id#">#licencecat#</option>
            </cfoutput>
            </select>
				</div>
			</div>
      <div class="form-group" id="item-department">
				    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='44319.Ehliyet Yılı'></label>
            <div class="col col-8 col-xs-12">
              <select name="driver_licence_year" id="driver_licence_year" style="width:130px;">
                <option value=""></option>
                <cfloop from="#dateformat(now(),"yyyy")#" to="1970" index="i" step="-1">
                  <option value="<cfoutput>#i#</cfoutput>"><cfoutput>#i#</cfoutput></option>
                </cfloop>
              </select>
            </div>
			</div>

		</div>
		</div>

  </cf_box_elements>

        <cf_box_footer>
              <cfsavecontent variable="message"><cf_get_lang dictionary_id='34135.Sayı Hatası Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
          <input type="submit"  value="<cf_get_lang dictionary_id='57565.Ara'>">
            <input name="reset" class="ui-wrk-btn ui-wrk-btn-red" style="margin:0.5rem;" type="reset" value="<cf_get_lang dictionary_id='57934.Temizle'>">
        </cf_box_footer>
      
 </cfform>
<script type="text/javascript">
function kontrol()
{
	if ((document.search_driving_licence.start_date.value.length>0) && (document.search_driving_licence.finish_date.value.length>0) && (!date_check(document.search_driving_licence.start_date,document.search_driving_licence.finish_date,"<cf_get_lang dictionary_id='57806.Tarih Aralığını Kontrol Ediniz'>!")))
	{
		return false;
	}
	return true;
}
</script>
