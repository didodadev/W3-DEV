<cfinclude template="../query/get_branch.cfm">
<cfinclude template="../query/get_zone.cfm">
<cfinclude template="../query/get_our_company.cfm">

<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.zone_id" default="">
<cfparam name="attributes.depot_type" default="0">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
  <cfform name="search_depot" method="post" action="" onsubmit="return(kontrol());" >
      <input id="is_submitted" type="hidden" name="is_submitted" value="1">
      <cf_box_elements>
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="2" type="column" sort="true">
          <div class="form-group" id="item-assetp_cat_name">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                <select name="company_id" id="company_id">
                    <option value="" <cfif attributes.company_id eq ''>selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_our_company"> 
                      <option value="#comp_id#" <cfif attributes.company_id eq comp_id>selected</cfif>>#nick_name#</option>
                    </cfoutput>
                </select>
            </div>
          </div>
          <div class="form-group" id="item-assetp_cat_name">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57992.Bölge'></label>
              <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                <select name="zone_id" id="zone_id">
                  <option value="" <cfif attributes.zone_id eq ''>selected</cfif>><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                    <cfoutput query="get_zone"> 
                      <option value="#zone_id#" <cfif attributes.zone_id eq zone_id>selected</cfif>>#zone_name#</option>
                    </cfoutput>
                </select>
              </div>
          </div>
        </div>  
        <div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="3" type="column" sort="true">
          <div class="form-group" id="item-assetp_cat_name">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                <div class="input-group">
                    <input type="hidden" name="branch_id" id="branch_id" value="">
                    <input type="text" name="branch_name" id="branch_name" value="" readonly="yes"> 
                    <span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_id=search_depot.branch_id&field_branch_name=search_depot.branch_name&select_list=1&is_get_all</cfoutput>')"></span>
                </div>
            </div>
          </div>   
          <div class="form-group" id="item-assetp_cat_name">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"></label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
              <div class="col"> 
                <cf_get_lang dictionary_id='58573.Merkez'> 
                <input name="depot_type" id="depot_type" type="radio" value="1" <cfif attributes.depot_type eq 1>checked</cfif>>
              </div>
              <div class="col"> 
                    <cf_get_lang dictionary_id='48365.Cep Şube'>
                    <input name="depot_type"  id="depot_type" type="radio" value="2" <cfif attributes.depot_type eq 2>checked</cfif>>
              </div>
              <div class="col"> 
                    <cf_get_lang dictionary_id='58081.Hepsi'> 
                    <input name="depot_type" id="depot_type" type="radio" value="0" <cfif attributes.depot_type eq 0>checked</cfif>> 
              </div>
            </div>
          </div>
        </div>  
      </cf_box_elements>
      <cf_box_footer>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='34135.Sayı Hatası Mesaj'></cfsavecontent>
        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:50px;padding:0px 5px 0px 5px;min-height:30px!important;color:##555;border:1px solid ##ddd;">
        <input type="submit"  value="<cf_get_lang dictionary_id='57565.Ara'>">
        <input name="reset" class="ui-wrk-btn ui-wrk-btn-red" style="margin:0.5rem;" type="reset" value="<cf_get_lang dictionary_id='57934.Temizle'>">
      </cf_box_footer>
  </cfform>
<script type="text/javascript">
	function kontrol()
	{	
		if(document.search_depot.maxrows.value>200)
		{
			alert('Maxrows Değerini Kontrol Ediniz !');
			return false;
		}
		return true;
	}
</script>
