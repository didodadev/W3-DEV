<cfparam name="attributes.opportunity_type_id" default="">
<cfparam name="attributes.maxrows" default='25'>
<cfparam name="attributes.opp_status" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.get_emp" default="">
<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfset getComponent = createObject('component','V16.callcenter.cfc.call_center')>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
<cfset get_opportunity_type = opportunitiesCFC.GET_OPPORTUNITY_TYPE(opportunity_type_id : attributes.opportunity_type_id)>
<cfset get_opp_currencies = opportunitiesCFC.GET_OPP_CURRENCIES()>
<cfset get_opportunities = opportunitiesCFC.GET_OPPORTUNITIES()>
<cfset get_emp = opportunitiesCFC.GET_POSITIONS(our_cid : session_base.our_company_id)>
<cfset GET_PARTNER = company_cmp.GET_PARTNER_EMP(cpid: session.pp.COMPANY_ID)>
<cfset get_process_type = getComponent.get_process_types(faction:'sales.list_opportunity')>
<form name="sendOpportunity" method="post">                            
  <div class="in_filter_item">  
        <div class="form-group col-md-3 col-lg-2 col-xl-2">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='32828.Keyword'></label>
            <input type="text" id="keyword" name="keyword" class="form-control" placeholder="<cf_get_lang dictionary_id='32828.Keyword'>" value="<cfoutput>#attributes.keyword#</cfoutput>">
        </div>  
        <div class="form-group col-md-3 col-lg-2 col-xl-2">
          <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'></label>
            <select class="form-control" id="opportunity_type_id" name="opportunity_type_id">
              <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
              <cfoutput query="get_opportunity_type">
                  <option value="#opportunity_type_id#" <cfif isDefined('attributes.opportunity_type_id') and attributes.opportunity_type_id eq opportunity_type_id>selected</cfif>>#opportunity_type#</option>
              </cfoutput>
          </select>
        </div>
        <div class="form-group col-md-3 col-lg-2 col-xl-2">
          <label class="font-weight-bold"><cf_get_lang dictionary_id='58054.Süreç - Aşama'></label>
            <select id="process_stage" name="process_stage" class="form-control">
              <option value="" selected><cf_get_lang dictionary_id='57734.Please Select'></option>
              <cfoutput query="get_process_type">
                <option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
              </cfoutput>
            </select>
        </div>
        <div class="form-group col-md-3 col-lg-2 col-xl-2">
          <label class="font-weight-bold"><cf_get_lang dictionary_id='57569.Görevli'></label>
            <select class="form-control" id="get_emp" name="get_emp">
              <option value="" selected><cf_get_lang dictionary_id='57734.Please Select'></option>
              <cfoutput query="GET_PARTNER">
                <option value="#PARTNER_ID#" <cfif attributes.get_emp eq PARTNER_ID>selected</cfif>>#company_partner_name# #company_partner_surname#</option>
              </cfoutput>
            </select>
        </div>    
        <div class="form-group col-md-4 col-lg-2 col-xl-1">
          <label class="font-weight-bold"><cf_get_lang dictionary_id='57756.Durum'></label>
          <select class="form-control" name="opp_status" id="opp_status">
            <option value="1" <cfif attributes.opp_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
            <option value="0" <cfif attributes.opp_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
            <option value="" <cfif attributes.opp_status eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
          </select>
        </div>  
        <div class="form-group col-md-4 col-lg-2 col-xl-1">
          <label class="font-weight-bold"><cf_get_lang dictionary_id='58829.Number of Records'></label>
          <select class="form-control" name="maxrows">
            <option value="10" <cfif attributes.maxrows eq 10>selected</cfif>>10</option>
            <option value="25"<cfif attributes.maxrows eq 25>selected</cfif>>25</option>
            <option value="50"<cfif attributes.maxrows eq 50>selected</cfif>>50</option>
            <option value="100"<cfif attributes.maxrows eq 100>selected</cfif>>100</option>
          </select>
        </div>   
        <div class="in_filter_item_btn form-group col-md-4 col-lg-2 col-xl-1">            
          <button type="submit" class="btn font-weight-bold text-uppercase btn-color-7" onclick="control()"><i class="fa fa-search"></i>  <cf_get_lang dictionary_id='57565.Ara'></button>
        </div>
    </div>
</form>       

<script>
  function control(){
      var data = new FormData();
      data.append("opportunity_type_id", $("#opportunity_type_id").val());      
      data.append("get_emp", $("#get_emp").val());
      data.append("keyword", $("#keyword").val());
      data.append("is_submit", "1");
      data.append("widget_load", "firsatlar_list");
      AjaxControlPostData('/widgetloader',data,function(response) {
        $("#search-results").html(response);
                  
    });
        
        }
</script>