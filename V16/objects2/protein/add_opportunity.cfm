<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfset getComponent = createObject('component','V16.member.cfc.member_company')>
<cfparam name="attributes.opportunity_type_id" default="">
<cfset get_opportunity_type = opportunitiesCFC.GET_OPPORTUNITY_TYPE(opportunity_type_id : attributes.opportunity_type_id, is_internet: 1)>
<cfset get_opp_currencies = opportunitiesCFC.GET_OPP_CURRENCIES()>
<cfset get_moneys = opportunitiesCFC.GET_MONEYS()>
<cfset get_probability_rate = opportunitiesCFC.GET_PROBABILITY_RATE()>
<cfset get_emp = getComponent.GET_HIER_PARTNER(cpid : session_base.company_id, GET_PARTNER:1)>
<cfif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
	<cfquery name="get_help_" datasource="#dsn#">
		SELECT
			COMPANY_ID,
			PARTNER_ID,
			CONSUMER_ID,
			SUBJECT,
			SUBSCRIPTION_ID,
			APP_CAT
		FROM
			CUSTOMER_HELP
		WHERE
			CUS_HELP_ID = #attributes.cus_help_id#
	</cfquery>
	<cfif len(get_help_.company_id)>
		<cfset attributes.cpid = get_help_.company_id>
		<cfset attributes.member_id = get_help_.partner_id>
		<cfset attributes.member_type = "partner">
	<cfelseif len(get_help_.consumer_id)>
		<cfset attributes.cpid = "">
		<cfset attributes.member_id = get_help_.consumer_id>
		<cfset attributes.member_type = "consumer">
	</cfif>
	<cfif len(get_help_.subscription_id)>
		<cfquery name="GET_SUB_NO" datasource="#dsn3#">
			SELECT SUBSCRIPTION_NO,PROJECT_ID FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_help_.subscription_id#">
		</cfquery>
		<cfset attributes.project_id = get_sub_no.project_id>
	</cfif>
	<cfset attributes.opp_detail = get_help_.subject>
	<cfset attributes.commethod_id = get_help_.app_cat>
<cfelseif isdefined('url.service_id')>
	 <cfquery name="GET_SERVICE" datasource="#DSN#">
		SELECT
			SERVICE_HEAD,
			PROJECT_ID,
			SERVICE_CONSUMER_ID,
			SERVICE_COMPANY_ID,
			SERVICE_PARTNER_ID
		FROM
			G_SERVICE
		WHERE
			SERVICE_ID = #url.service_id#
	</cfquery>
	<cfset attributes.project_id = get_service.project_id>
<cfelseif isdefined("attributes.project_id") and len(attributes.project_id)>
	<cfquery name="get_project_info" datasource="#dsn#">
		SELECT COMPANY_ID,PARTNER_ID,CONSUMER_ID,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
	<cfif len(get_project_info.company_id)>
		<cfset attributes.cpid = get_project_info.company_id>
		<cfset attributes.member_id = get_project_info.partner_id>
		<cfset attributes.member_type = "partner">
	<cfelseif len(get_project_info.consumer_id)>
		<cfset attributes.cpid = "">
		<cfset attributes.member_id = get_project_info.consumer_id>
		<cfset attributes.member_type = "consumer">
	</cfif>
</cfif>
<cfform name="add_opp" method="post" onsubmit="return (unformat_fields());">
<div class="row ui-scroll">
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <div class="form-group">
            <label class="font-weight-bold"><cf_get_lang dictionary_id='58820.Başlık'></label>
            <cfif isdefined('url.service_id')>
                <input type="text" name="opp_head" id="opp_head" class="form-control" value="<cfoutput>#get_service.service_head#</cfoutput>" required="yes" message="#message#">
            <cfelseif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
                <cfsavecontent variable="opp_head_"><cf_get_lang dictionary_id ='40817.Etkileşim'>: <cfoutput>#attributes.cus_help_id#</cfoutput></cfsavecontent>
                <input type="text" name="opp_head" id="opp_head" class="form-control" value="<cfoutput>#opp_head_#</cfoutput>">
            <cfelse>
                <input type="text" name="opp_head" id="opp_head" class="form-control" value="">
            </cfif>
        </div>                
    </div>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57771.Detay'></label>
        <textarea class="form-control" id="opp_detail" name="opp_detail"></textarea>
    </div>
    <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57457.Müşteri'>*</label>
        <input type="hidden" name="country_id" id="country_id" value="">
        <input type="hidden" name="sales_zone_id" id="sales_zone_id" value="">
        <div class="input-group">
        <cfsavecontent  variable="title"><cf_get_lang dictionary_id='33182.Search Customer'></cfsavecontent>
            <cfif isdefined ('url.service_id')>                
                <cfif len(get_service.service_company_id)>                       
                        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_service.service_company_id#</cfoutput>">
                        <input type="hidden" name="member_type" id="member_type" value="partner">
                        <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_service.service_partner_id#</cfoutput>">
                    <div class="input-group">
                        <input type="text" name="company" id="company" style="width:140px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" value="<cfoutput>#get_par_info(get_service.service_company_id,1,0,0)#</cfoutput>" autocomplete="off">
                        <div class="input-group-append">
                            <span class="input-group-text btnPointer icon-ellipsis" onclick="openBoxDraggable('widgetloader?widget_load=listPars&isbox=1&title=<cfoutput>#title#</cfoutput>&style=maxi&draggable=1&field_partner=add_opp.member_id&field_consumer=add_opp.member_id&field_comp_id=add_opp.company_id&field_comp_name=add_opp.company&field_name=add_opp.member&field_type=add_opp.member_type&select_list=7&function_name=fill_country&account_period=1');"></span>
                        </div>
                    </div>
                <cfelse>
                        <input type="hidden" name="company_id" id="company_id" value="">
                        <input type="hidden" name="member_type" id="member_type" value="consumer">
                        <input type="hidden" name="member_id" id="member_id" value="<cfoutput>#get_service.service_consumer_id#</cfoutput>">
                    <div class="input-group">
                        <input type="text" name="company" id="company" style="width:140px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" value="<cfoutput>#get_cons_info(get_service.service_consumer_id,2,0)#</cfoutput>" autocomplete="off">
                        <div class="input-group-append">
                            <span class="input-group-text btnPointer icon-ellipsis" onclick="openBoxDraggable('widgetloader?widget_load=listPars&isbox=1&title=<cfoutput>#title#</cfoutput>&style=maxi&draggable=1&field_partner=add_opp.member_id&field_consumer=add_opp.member_id&field_comp_id=add_opp.company_id&field_comp_name=add_opp.company&field_name=add_opp.member&field_type=add_opp.member_type&select_list=7&function_name=fill_country&account_period=1');"></span>
                        </div>
                    </div>
                </cfif>
            <cfelseif isdefined('attributes.member_id')>
                <cfoutput>
                    <input type="hidden" name="company_id" id="company_id" value="#attributes.cpid#">
                    <input type="hidden" name="member_type" id="member_type" value="#attributes.member_type#">
                    <input type="hidden" name="member_id" id="member_id" value="#attributes.member_id#">
                    <div class="input-group">
                        <input type="text" name="company" id="company"  value="#get_par_info(attributes.member_id,0,1,0)#" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
                        <div class="input-group-append">
                            <span class="input-group-text btnPointer icon-ellipsis" onclick="openBoxDraggable('widgetloader?widget_load=listPars&isbox=1&title=<cfoutput>#title#</cfoutput>&style=maxi&draggable=1&field_partner=add_opp.member_id&field_consumer=add_opp.member_id&field_comp_id=add_opp.company_id&field_comp_name=add_opp.company&field_name=add_opp.member&field_type=add_opp.member_type&select_list=7&function_name=fill_country&account_period=1');"></span>
                        </div>
                    </div>
                </cfoutput>
            <cfelse>
                <input type="hidden" name="company_id" id="company_id" value="">
                <input type="hidden" name="member_type" id="member_type" value="">
                <input type="hidden" name="member_id" id="member_id" value="">
                <div class="input-group">
                    <input name="company" type="text" id="company" class="form-control" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE,PARTNER_CODE,MEMBER_PARTNER_NAME2','company_id,member_type,member_id,member','','3','250',true,'fill_country(0,0)');" autocomplete="off">
                    <div class="input-group-append">
                        <span class="input-group-text btnPointer icon-ellipsis" onclick="openBoxDraggable('widgetloader?widget_load=listPars&isbox=1&title=<cfoutput>#title#</cfoutput>&style=maxi&draggable=1&is_period_kontrol=0&field_partner=add_opp.member_id&field_consumer=add_opp.member_id&field_comp_id=add_opp.company_id&field_comp_name=add_opp.company&function_name=fill_country&field_name=add_opp.member&field_type=add_opp.member_type&select_list=7');"></span>
                    </div>
                </div>
            </cfif>            
        </div>
    </div>
    <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57578.Yetkili'></label>
        <cfif isdefined ('url.service_id')>
            <cfif len(get_service.service_company_id)>
                <input type="text" class="form-control" id="member" name="member" value="<cfoutput>#get_par_info(get_service.service_partner_id,0,-1,0)#</cfoutput>" readonly>
            <cfelse>
                <input type="text" class="form-control" id="member" name="member" value="<cfoutput>#get_cons_info(get_service.service_consumer_id,0,0)#</cfoutput>" readonly>
            </cfif>
        <cfelse>
            <cfif isdefined('attributes.member_id') and len(attributes.member_id) and attributes.member_type eq 'partner'>
                <input type="text" class="form-control" id="member" name="member" value="<cfoutput>#get_par_info(attributes.member_id,0,-1,0)#</cfoutput>" readonly>
            <cfelseif isdefined('attributes.member_id') and len(attributes.member_id) and attributes.member_type eq 'consumer' >
                <input type="text" class="form-control" id="member" name="member" value="<cfoutput>#get_cons_info(attributes.member_id,0,0)#</cfoutput>" readonly>
            <cfelse>
                <input type="text" class="form-control" id="member" name="member" value="" readonly>
            </cfif>
        </cfif>
    </div>
    
    <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
        <select class="form-control input-color-6" name="opportunity_type_id" id="opportunity_type_id" required>
            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
            <cfoutput query="get_opportunity_type">
                <option value="#opportunity_type_id#">#opportunity_type#</option>
            </cfoutput>
        </select>
    </div>
    <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='61836.Kontak'></label>
        <select class="form-control" id="sales_emp_id" name="sales_emp_id">
            <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
            <cfoutput query="get_emp">
                <option value="#PARTNER_ID#">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</option>
            </cfoutput>
        </select>
    </div>
   <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4">       
        <label class="font-weight-bold"><cf_get_lang dictionary_id='32575.İş Ortağı'>*</label>
        <input type="hidden" name="sales_member_type" id="sales_member_type" value="partner">
        <select class="form-control" id="sales_member_id" name="sales_member_id">
            <option value="" selected="selected"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
            <cfoutput query="get_emp">
                <option value="#PARTNER_ID#">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</option>
            </cfoutput>
        </select>    
    </div>
  <!---   <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='57482.Aşama'></label>
            <select class="form-control" name="opp_currency_id" id="opp_currency_id">
                <option value=""><cf_get_lang dictionary_id ='57734.Seciniz'></option>
                <cfoutput query="get_opp_currencies">
                    <option value="#opp_currency_id#">#opp_currency#</option>
                </cfoutput>
            </select>      
    </div> --->
    <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='61880.Gelir Potansiyeli'></label>        
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='40991.Gelir Girmelisiniz'></cfsavecontent>
        <div class="row">
            <div class="col-8 col-md-8 col-sm-8 col-lg-8 col-xl-8">   
                <input type="text" id="income" name="income" class="form-control text-right" value="" message="#message#" onkeyup="return(formatcurrency(this,event));">
            </div>
            <div class="col-4 col-md-4 col-sm-4 col-lg-4 col-xl-4 pl-0">
                <select class="form-control" name="money" id="money" style="background-color">
                    <cfoutput query="get_moneys">
                        <option value="#money#"<cfif money eq session_base.money>selected</cfif>>#money#</option>
                    </cfoutput>
                </select>               
            </div>
         </div>
    </div>
            
    
        
    
    <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='58652.Olasılık'></label>
        <select name="probability" id="probability" class="form-control">
            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
            <cfoutput query="get_probability_rate">
                <option value="#probability_rate_id#" <cfif isdefined('attributes.probability_rate_id') and len(attributes.probability_rate_id) and attributes.probability_rate_id eq probability_rate_id>selected</cfif>> #get_probability_rate.probability_name# </option>
            </cfoutput>
        </select>
    </div> 
    <div class="col-12 col-md-4 col-sm-4 col-lg-4 col-xl-4">
        <label class="font-weight-bold"><cf_get_lang dictionary_id='58859.Süreç'> *</label>        
        <cf_workcube_process is_upd='0' is_detail='0'>       
    </div>   
</div> 
    <div class="draggable-footer">
        <cf_workcube_buttons is_insert="1" data_action="V16/objects2/protein/data/opportunities_data:ADD_OPPORTUNITY" next_page="#site_language_path#/opportunities">
    </div>
</cfform> 

<script>
    ClassicEditor
        .create( document.querySelector( '#opp_detail' ) )
        .then( editor => {
            console.log( 'Editor was initialized', editor );
            myEditor = editor;
        } )
        .catch( err => {
            console.error( err.stack );
        } );
    function kontrol(){
        var myEditor;
        document.getElementById('opp_detail').value = myEditor.instances.opp_detail.getData();	
        console.log(myEditor);
    }      
    function fill_country(member_id,type)
    {
		if(member_id==0)
		{
			if(document.getElementById('member_type').value=='partner')
			{
				member_id=document.getElementById('company_id').value;
				type=1;
			}
			else if(document.getElementById('member_type').value=='consumer')
			{
				member_id=document.getElementById('member_id').value;
				type=2;
			}
		}
		document.getElementById('country_id').value='';
		document.getElementById('sales_zone_id').value='';
		if(type == 1)
		{
			var sql = "SELECT COUNTRY,SALES_COUNTY FROM COMPANY WHERE COMPANY_ID = " + member_id;
			get_country = wrk_query(sql,'dsn');
			if(get_country.COUNTRY!='' && get_country.COUNTRY!=undefined)
				document.getElementById('country_id').value=get_country.COUNTRY;
			if(get_country.SALES_COUNTY!='' && get_country.SALES_COUNTY!=undefined)
				document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;
		}
		else if(type == 2)
		{
			var sql = "select SALES_COUNTY,TAX_COUNTRY_ID from CONSUMER WHERE CONSUMER_ID = " + member_id;
			get_country= wrk_query(sql,'dsn');
			if(get_country.TAX_COUNTRY_ID!='' && get_country.TAX_COUNTRY_ID!=undefined)
				document.getElementById('country_id').value=get_country.TAX_COUNTRY_ID;
			if(get_country.SALES_COUNTY!='' && get_country.TAX_COUNTRY_ID!=undefined)
				document.getElementById('sales_zone_id').value=get_country.SALES_COUNTY;
		}
    }      
</script>