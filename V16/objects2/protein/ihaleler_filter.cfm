<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfset getComponent = createObject('component','V16.objects2.protein.data.tender_data')>

<cfparam name="attributes.form_submitted" default="1">
<cfparam name="attributes.category" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.deliverdate" default="">
<cfparam name="attributes.keyword" default="">

<cfif isdefined('attributes.form_submitted')>
  <cfset get_offer = getComponent.GET_OFFER(
    keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(''))#',
    category : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(''))#',
    process_stage : '#IIf(IsDefined("attributes.process_stage"),"attributes.process_stage",DE(''))#',
    deliverdate : '#IIf(IsDefined("attributes.deliverdate"),"attributes.deliverdate",DE(''))#',
    is_partner : '#IIf(IsDefined("attributes.is_partner") and attributes.is_partner eq 1,"attributes.is_partner",DE(''))#'
  )>
  <cfset get_offer_cat = getComponent.GET_OFFER_CAT( category : '#IIf(IsDefined("attributes.category"),"attributes.category",DE(''))#')>
  <cfset get_process_types = getComponent.get_process_type()>
<cfelse>
	<cfset get_offer.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfif isdefined("session.pp.maxrows")>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_offer.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset url_str = "#GET_PAGE.FRIENDLY_URL#">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.category)>
	<cfset url_str = "#url_str#&category=#attributes.category#">
</cfif>
<cfif len(attributes.process_stage)>
	<cfset url_str = "#url_str#&process_stage=#dateformat(attributes.process_stage,'dd/mm/yyyy')#">
</cfif>
<cfif len(attributes.deliverdate)>
	<cfset url_str = "#url_str#&deliverdate=#dateformat(attributes.deliverdate,'dd/mm/yyyy')#">
</cfif>

<cfif isdefined("attributes.form_submitted")>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>

<form name="list_tender" method="post">
    <div class="in_filter_item">
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">

            <div class="in_filter_item_header form-group col-lg-2">
              <cf_get_lang dictionary_id='61892.?'>                          
            </div>                

            <div class="form-group col-md-6 col-lg-3 col-xl-2">
              <label class="font-weight-bold"><cf_get_lang dictionary_id='57460.Filtre'></label>
              <input type="text" class="form-control" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>">
            </div>

            <div class="form-group col-md-6 col-lg-3 col-xl-2">
              <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Category'></label>
              <select class="form-control" name="category" id="category">
                <option value=""><cf_get_lang dictionary_id='57486.Category'></option>         
                    <cfloop query="get_offer_cat">
                      <cfif listFind(OUR_COMPANY_ID,session.pp.our_company_id) gt 0>
                      <option value="<cfoutput>#WORK_CAT_ID#</cfoutput>" <cfif isdefined('attributes.category') and (attributes.category eq WORK_CAT_ID)> selected</cfif>><cfoutput>#WORK_CAT#</cfoutput></option>
                      </cfif>
                    </cfloop>
              </select>
            </div>
            <div class="form-group col-md-6 col-lg-2 col-xl-2">
              <label class="font-weight-bold"><cf_get_lang dictionary_id='58054.Process - Stage'></label>
              <select id="process_stage" name="process_stage" class="form-control">
                <option value="" selected><cf_get_lang dictionary_id='57734.Please Select'></option>
                <cfoutput query="get_process_types">
                  <option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
                </cfoutput>
              </select>
           </div> 
            <div class="form-group col-md-6 col-lg-3 col-xl-2">
              <label class="font-weight-bold"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
              <div class="input-group">					
                <cfsavecontent variable="message">Termin Tarihini Kontrol Ediniz</cfsavecontent>
                <input type="text" class="form-control" name="deliverdate" id="deliverdate" value="<cfoutput>#dateformat(attributes.deliverdate,'dd/mm/yyyy')#</cfoutput>" validate="eurodate" maxlength="10" message="#message#">
                  <div class="input-group-append">
                     <span class="input-group-text"><cf_wrk_date_image date_field="deliverdate"> </span>
                  </div>	
              </div>
            </div>

            <div class="form-group col-md-6 col-lg-3 col-xl-1">
              <label class="font-weight-bold"><cf_get_lang dictionary_id='58829.Kayıt Sayısı'></label>
              <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
              <input type="text" class="form-control" name="maxrows" id="maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
            </div>          

            <div class="in_filter_item_btn form-group col-lg-2 col-xl-1">            
              <button type="submit" class="btn font-weight-bold text-uppercase btn-color-7"><i class="fa fa-search"></i>  <cf_get_lang dictionary_id='57565.Ara'></button>
            </div>        
    </div>
</form>