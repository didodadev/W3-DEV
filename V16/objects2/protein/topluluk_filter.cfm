<cfset getComponent = createObject('component','V16.objects2.protein.data.community_data')>
<cfset get_all_certificates = getComponent.GET_ALL_CERTIFICATES()>

<cfset get_hr = getComponent.GET_HR(
  keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(''))#',
  certificate_filter : '#IIf(IsDefined("attributes.certificate_filter"),"attributes.certificate_filter",DE(''))#'
)>
<cfparam name="attributes.form_submitted" default="1">
<cfparam name="attributes.certificate_filter" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='25'>
<cfform id="search_topluluk" name="search_topluluk" method="post" style="margin:0" action="community">  
    <div class="in_filter_item">  
        <div class="form-group col-md-6 col-lg-2 col-xl-2">
          <label class="font-weight-bold"><cf_get_lang dictionary_id='57570.Name  Last name'></label>
            <cfinput type="text" class="form-control" name="keyword" id="keyword" value="#attributes.keyword#">
        </div>
        <div class="form-group col-md-6 col-lg-2 col-xl-2">
          <label class="font-weight-bold"><cf_get_lang dictionary_id='29693.Certificates'></label>
              <select class="form-control" name="certificate_filter" id="certificate_filter">
              <option value="0">Seçiniz</option>
              <cfloop query="get_all_certificates">
                  <option value="<cfoutput>#CERTIFICATE_ID#</cfoutput>" <cfif isdefined("attributes.certificate_filter") and (attributes.certificate_filter eq CERTIFICATE_ID)>selected</cfif>><cfoutput>#CERTIFICATE_NAME#</cfoutput></option>
              </cfloop>
            </select>
        </div>
        <!---<div class="form-group col-md-6 col-lg-3 col-xl-2">
            <label ><cf_get_lang dictionary_id='61942.Sektör Uzmanlığı'></label>
            <select class="form-control">
                <option>1</option>
                <option>2</option>
                <option>3</option>
                <option>4</option>
                <option>5</option>
              </select>
        </div>   --->
        <div class="form-group col-md-4 col-lg-2 col-xl-1">
          <label class="font-weight-bold"><cf_get_lang dictionary_id='58829.Number of Records'></label>
          <select class="form-control" name="maxrows">
            <option value="10" <cfif attributes.maxrows eq 10>selected</cfif>>10</option>
            <option value="25"<cfif attributes.maxrows eq 25>selected</cfif>>25</option>
            <option value="50"<cfif attributes.maxrows eq 50>selected</cfif>>50</option>
            <option value="100"<cfif attributes.maxrows eq 100>selected</cfif>>100</option>
          </select>
        </div>                   
        <div class="in_filter_item_btn form-group col-lg-2 col-xl-2">            
          <button type="submit" class="btn font-weight-bold text-uppercase btn-color-7" onclick="control()"><i class="fa fa-search"></i>  <cf_get_lang dictionary_id='57565.Ara'></button>
        </div>
    </div>
</cfform>
<script>
	function control(){
		var data = new FormData();
		var form = $('form[name = search_topluluk]');
		AjaxControlPostData('/widgetloader?widget_load=toplulukİcerik&'+ form.serialize(),data,function(response) {
			$(".user_list").html(response);					
		});
	}
</script>