<cfset getComponent = createObject('component','V16.callcenter.cfc.call_center')>
<cfset getComponent2 = createObject('component','V16.project.cfc.get_work')>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")> 
<cfset GET_PARTNER = company_cmp.GET_PARTS_EMPS(cpid: session.pp.COMPANY_ID)>
<cfset get_emp = getComponent2.GET_POSITIONS(our_cid : session_base.our_company_id)>
<cfset GET_SERVICE_APPCAT = getComponent.GET_SERVICE_APPCAT()>
<cfset get_process_types = getComponent.get_process_types(faction:'call.list_service')>
<cfset get_subscriptions = getComponent.GET_SUBSCRIPTION()>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='25'>
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.category" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.resp_id" default="">
<cfif isdefined('url.subscription_id') and len(url.subscription_id)>
	<cfset attributes.subscription_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.subscription_id,accountKey:'wrk')>
</cfif>
<form id="search" name="search" method="post" style="margin:0">      
	<input type="hidden" name="is_submitted" id="is_submitted" value="1" />                    
    <div class="in_filter_item"> 
        <div class="form-group col-md-6 col-lg-2 col-xl-2">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='32828.Keyword'></label>
            <input id="keyword" name="keyword" type="text" class="form-control" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cf_get_lang dictionary_id='32828.Keyword'>">
        </div>  
		<div class="form-group col-md-6 col-lg-2 col-xl-2">
			<label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Category'></label>
			<select id="category" name="category" class="form-control">
				<option value="" selected><cf_get_lang dictionary_id='57734.Please Select'></option>
				<cfoutput query="GET_SERVICE_APPCAT">
					<option value="#servicecat_id#"<cfif isdefined("attributes.appcat_id") and (attributes.appcat_id eq servicecat_id)>selected</cfif>>#servicecat#</option>
				</cfoutput>
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
		<div class="form-group col-md-6 col-lg-2 col-xl-2">
			<label class="font-weight-bold"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
			<select class="form-control" id="resp_id" name="resp_id">
				<option value=""><cf_get_lang dictionary_id='57734.Please Select'></option>
				<cfoutput query="GET_PARTNER">
					<option value="#ID_CE#_#TYPE#" <cfif attributes.resp_id eq ID_CE>selected</cfif>>#NAME_SURNAME#</option>
				</cfoutput>
			</select>
		</div>
		<div class="form-group col-md-6 col-lg-2 col-xl-2">
			<label class="font-weight-bold"><cf_get_lang dictionary_id='58832.Subscription'></label>
			<select class="form-control" id="subscription_id" name="subscription_id">
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
				<cfoutput query="get_subscriptions">
					<option value="#SUBSCRIPTION_ID#" #attributes.subscription_id eq SUBSCRIPTION_ID ? 'selected' : ''#>#SUBSCRIPTION_NO# - #SUBSCRIPTION_HEAD#</option>
				</cfoutput>
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
			<button type="submit" class="btn font-weight-bold text-uppercase btn-color-7"><i class="fa fa-search"></i>  <cf_get_lang dictionary_id='57565.Ara'></button>
		</div>
    </div>
</form>          
<script>
	/* Post işlemine bakılacak */
	function control(){
		var data = new FormData();
		var form = $('form[name = search]');
		AjaxControlPostData('/widgetloader?widget_load=cagrilarListe&'+ form.serialize(),data,function(response) {
			$("#search-results").html(response);					
		});
	}
</script>