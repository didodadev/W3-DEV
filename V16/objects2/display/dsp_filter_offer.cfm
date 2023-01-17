<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfset offer = createObject("component","V16.objects2.sale.cfc.offer")>
<cfparam name="attributes.offer_stage" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
<cfif isdefined('attributes.form_submitted')>
	<cfset GET_OFFER_LIST = offer.GET_OFFER_LIST(
													offer_stage : '#IIf(IsDefined("attributes.offer_stage"),"attributes.offer_stage",DE(''))#',
													keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(''))#',
													status : '#IIf(IsDefined("attributes.status"),"attributes.status",DE(''))#',
													start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(''))#',	
													finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(''))#'
												)>
<cfelse>
	<cfset get_offer_list.recordcount = 0>
</cfif>

<cfparam name="attributes.page" default="1">
<cfif isdefined("session.pp.maxrows")>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_offer_list.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.offer_stage)>
	<cfset url_str = "#url_str#&offer_stage=#attributes.offer_stage#">
</cfif>
<cfif len(attributes.status)>
	<cfset url_str = "#url_str#&status=#attributes.status#">
</cfif>

<cfif len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>

<cfform name="list_order" method="post" action="#request.self#">
	<div class="in_filter_item">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<div class="form-group col-md-6 col-lg-3 col-xl-2">
			<label><cf_get_lang dictionary_id='57460.Filtre'></label>
			<cfinput type="text" class="form-control" name="keyword" id="keyword" value="#attributes.keyword#">
		</div>
		<div class="form-group col-md-6 col-lg-3 col-xl-2">
			<label><cf_get_lang dictionary_id='57756.Durum'></label>
			<select class="form-control" name="status" id="status">
				<option value=""><cf_get_lang_main no='344.Durum'></option>
				<option value="0"<cfif isdefined('attributes.status') and (attributes.status eq 0)> selected</cfif>><cf_get_lang_main no="82.Pasif"></option>
				<option value="1"<cfif isdefined('attributes.status') and (attributes.status eq 1)> selected</cfif>><cf_get_lang_main no="81.Aktif"></option>
			</select>
		</div>
		<div class="form-group col-md-6 col-lg-3 col-xl-2">
			<label><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
			<div class="input-group">					
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='30122.Başlangıç Tarihini Kontrol Ediniz'></cfsavecontent>
				<cfinput type="text" class="form-control" name="start_date" id="start_date"  value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
					<div class="input-group-append">
						<span class="input-group-text"><cf_wrk_date_image date_field="start_date"> </span>
					</div>	
			</div>
		</div>
		<div class="form-group col-md-6 col-lg-3 col-xl-2">
			<label><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
			<div class="input-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='30123.Bitiş Tarihini Kontrol Ediniz'></cfsavecontent>
				<cfinput type="text" class="form-control" name="finish_date" id="finish_date"  value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#">
				<div class="input-group-append">
					<span class="input-group-text"><cf_wrk_date_image date_field="finish_date"></span>
				</div>
			</div>
		</div>
		<div class="form-group col-md-6 col-lg-3 col-xl-2">
			<label><cf_get_lang dictionary_id='58829.Kayıt Sayısı'></label>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
			<cfinput type="text" class="form-control" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
		</div>
		<div class="in_filter_item_btn form-group col-lg-2 col-xl-2">  
			<cf_wrk_search_button>
		</div>
	</div>
</cfform>