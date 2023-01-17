<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.form_submitted" default="1">

<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.start_date=''>
	<cfelse>
		<cfset attributes.start_date=wrk_get_today()>
	</cfif>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.finish_date=''>
	<cfelse>
	<cfset attributes.finish_date = date_add('d',1,now())>
	</cfif>
</cfif>

<cfif isdefined("attributes.form_submitted")>
	<cfscript>
 		get_warehouse_rates_action = createObject("component", "V16.settings.cfc.get_warehouse_rates");
        get_warehouse_rates_action.dsn3 = dsn3;
        get_warehouse_rates_action.dsn_alias = dsn_alias;
        get_warehouse_rates = get_warehouse_rates_action.get_warehouse_rates_fnc(
			 ship_number : '#IIf(IsDefined("attributes.ship_number"),"attributes.ship_number",DE(""))#',
			 keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			 process_stage_type : '#IIf(IsDefined("attributes.process_stage_type"),"attributes.process_stage_type",DE(""))#',
			 start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			 finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			 task_type_name : '#IIf(IsDefined("attributes.task_type_name"),"attributes.task_type_name",DE(""))#',
			 task_type_id : '#IIf(IsDefined("attributes.task_type_id"),"attributes.task_type_id",DE(""))#',
			 employee_name : '#IIf(IsDefined("attributes.employee_name"),"attributes.employee_name",DE(""))#',
			 employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
			 department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
			 department_name : '#IIf(IsDefined("attributes.department_name"),"attributes.department_name",DE(""))#',
			 company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			 company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#'
		);
	</cfscript>
<cfelse>
	<cfset get_warehouse_rates.recordCount = 0>
</cfif>


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_warehouse_rates.recordcount#'>
<cfform name="form" method="post" action="#request.self#?fuseaction=settings.list_warehouse_rates">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cf_big_list_search title="WareHouse Rates"> 
	<cf_big_list_search_area>
    	<div class="row">
    		<div class="col col-12 form-inline">
            	<div class="form-group">
                	<div class="input-group">
						<cfinput type="text" placeholder="#getLang('main',48)#" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:60px;">
                	</div>
                </div>
                
				<div class="form-group" id="item-company">
                	<label class="col col-12"><cf_get_lang_main no='107.Cari Hesap'></label>
                    <div class="col col-12">
                    	<div class="input-group">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
                            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                            <input type="text" name="company" id="company" value="<cfoutput>#attributes.company#</cfoutput>" style="width:130px;">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_comp_id=form.company_id&field_comp_name=form.company&field_consumer=form.consumer_id&field_member_name=form.company&select_list=2,3','list','popup_list_all_pars');"></span>
                        </div>
                    </div>
                </div>
				<div class="form-group" id="item-date">
                	<label class="col col-12"><cfoutput>Action Date</cfoutput></label>
                    <div class="col col-12">
                    	<div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang_main no ='370.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
                            <cfinput value="#dateformat(attributes.start_date,dateformat_style)#" type="text" name="start_date" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                            <span class="input-group-addon no-bg"></span>
                            <cfsavecontent variable="message"><cf_get_lang_main no ='370.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
                            <cfinput value="#dateformat(attributes.finish_date,dateformat_style)#" type="text" name="finish_date" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>
                </div>
				<div class="form-group">
                    <div class="input-group x-3_5">
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                </div>				
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message_date"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
                        <cf_wrk_search_button search_function="date_check(form.start_date,form.finish_date,'#message_date#')">
                    </div>
                </div>
            </div>
    	</div>           
	</cf_big_list_search_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang_main no='1165.Sıra'></th>
			<th>Rate No</th>
			<th>Customer</th>
			<th>Employee</th>
			<th>Date</th>
            <!-- sil --><th class="header_icn_none"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_warehouse_rates&event=add"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170. Ekle'>"></a></th><!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_warehouse_rates.recordcount>	
		<cfoutput query="get_warehouse_rates" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr>
				<td>#currentrow#</td>
				<td><a href="#request.self#?fuseaction=settings.list_warehouse_rates&event=upd&rate_id=#rate_id#" class="tableyazi">#rate_id#</a></td>
				<td>#NICKNAME#</td>
				<td>#ACTION_MAN#</td>
				<td>#dateformat(ACTION_DATE,dateformat_style)#</td>
				<!-- sil --><td class="header_icn_none"><a href="#request.self#?fuseaction=settings.list_warehouse_rates&event=upd&rate_id=#rate_id#"><img src="images/update_list.gif" title="<cf_get_lang_main no='52. Guncelle'>"></a></td><!-- sil -->
			</tr>
		</cfoutput>
		<cfelse>
			<tr>
				<td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
</tbody>
</cf_big_list>
<cfset url_str="settings.list_warehouse_rates">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
</cfif>
<cfif len(attributes.company_id)>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif len(attributes.consumer_id)>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif len(attributes.company)>
	<cfset url_str = "#url_str#&company=#attributes.company#">
</cfif>
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#url_str#">