<cfif isdefined("session.pp")>
    <cfset session_base = evaluate('session.pp')>
    <cfset session_base.period_is_integrated = 0>
<cfelseif isdefined("session.ep")>
    <cfset session_base = evaluate('session.ep')>
<cfelseif isdefined("session.cp")>
    <cfset session_base = evaluate('session.cp')>
<cfelseif isdefined("session.ww")>
    <cfset session_base = evaluate('session.ww')>
</cfif>
<cfset getComponentSer = createObject('component','V16.callcenter.cfc.call_center')>
<cfset getComponent = createObject('component','V16.project.cfc.get_work')>
<cfset ProjectCmp =createObject("component", "V16/project/cfc/projectData")>
<cfset get_process_types = getComponentSer.get_process_types(faction:'project.works')>
<cfset get_project = ProjectCmp.get_projects()>
<cfset get_work_cat = getComponent.GET_WORK_CAT()>
<cfset get_emp = getComponent.GET_POSITIONS(our_cid : session_base.our_company_id)>
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.work_my" default="1">
<cfparam name="attributes.work_status" default="1">
<cfparam name="attributes.maxrows" default='25'>
<form name="sendWork" method="post" style="margin:0;">
  <input type="hidden" name="is_submit" id="is_submit" value="1" />   
    <div class="in_filter_item">
      <div class="form-group col-md-6 col-lg-2 col-xl-2">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='32828.Keyword'></label>
        <input type="text" id="keyword" name="keyword" class="form-control" placeholder="<cf_get_lang dictionary_id='32828.Keyword'>" value="<cfif isdefined("attributes.keyword") and len(attributes.keyword) ><cfoutput>#attributes.keyword#</cfoutput></cfif>">
      </div>
      <div class="form-group col-md-6 col-lg-2 col-xl-2">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57416.Project'></label>
          <select class="form-control" id="project_id" name="project_id">
              <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
              <cfoutput query="get_project">
                  <option value="#project_id#" <cfif isDefined('attributes.project_id') and attributes.project_id eq project_id>selected</cfif>>#project_head#</option>
              </cfoutput>
          </select>
      </div>
      <div class="form-group col-md-6 col-lg-2 col-xl-2">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Category'></label>
        <select class="form-control" id="pro_work_cat" name="pro_work_cat">
           <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
            <cfoutput query="get_work_cat">
                <option value="#work_cat_id#"<cfif isDefined('attributes.pro_work_cat') and attributes.pro_work_cat eq work_cat_id>selected</cfif>>#work_cat#</option>
            </cfoutput>
        </select>
      </div>
      <div class="form-group col-md-6 col-lg-2 col-xl-2">
        <label for="inputPassword4" class="font-weight-bold"><cf_get_lang dictionary_id='58054.Process - Stage'></label>
        <cf_workcube_process is_upd="0" is_detail="0" is_select_text="1">
      </div>
      <div class="form-group col-md-4 col-lg-2 col-xl-1">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57756.Durum'></label>
        <select class="form-control" name="work_status" id="work_status">
          <option value="1" <cfif attributes.work_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
          <option value="-1" <cfif attributes.work_status eq -1>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
          <option value="0" <cfif attributes.work_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
        </select>
      </div>
      <div class="form-group col-md-6 col-lg-2 col-xl-1">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57569.Staff'></label>
        <select class="form-control" name="work_my" id="work_my">
          <option value="1" <cfif attributes.work_my eq 1>selected</cfif>><cf_get_lang dictionary_id='33399.İşlerim'></option>
          <option value="0" <cfif attributes.work_my eq 0>selected</cfif>><cf_get_lang dictionary_id='575.Tüm'></option>
        </select>
      </div>
      <div class="form-group col-md-2 col-lg-2 col-xl-1">
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
      var form = $('form[name = sendWork]');
      data.append("project_id", $("#project_id").val());
      data.append("pro_work_cat", $("#pro_work_cat").val());
      data.append("process_stage", $("#process_stage").val());
      data.append("keyword", $("#keyword").val());
      data.append("is_submit", "1");
      AjaxControlPostData('/widgetloader?widget_load=gorevlerListe&'+ form.serialize(),data,function(response) {
          $("#search-results").html(response);
                  
    });
    }
</script>