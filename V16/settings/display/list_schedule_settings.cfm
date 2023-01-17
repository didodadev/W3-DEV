<cf_get_lang_set module_name="settings">
<cfif attributes.fuseaction is 'bank.list_pos_operation_schedule'><cfset is_pos_operation = 1><cfelse><cfset is_pos_operation = 0></cfif>
<cfif isdefined("attributes.is_form_submitted")>
    <cfinclude template="../query/get_schedules.cfm">
<cfelse>
	<cfset get_schedules.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_schedules.recordcount#">
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif not isdefined("attributes.draggable")>
<cf_catalystHeader>
</cfif>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='42522.Zaman Ayarlı Görevler'></cfsavecontent>
<cf_box title="#title#" uidrop="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_form">
		<cf_box_search more='0'>
				<input type="hidden" name="is_form_submitted" value="1" />
				<div class="form-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
				<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" placeholder='#message#'/>
				</div>
				<div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" style="width:25px;" maxlength="3" onKeyUp="isNumber(this)" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#">
				</div>
                <div class="form-group"><cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_form' , #attributes.modal_id#)"),DE(""))#"></div>
		</cf_box_search>
	</cfform>
	<cf_flat_list> 		  
  		<thead>
			<tr> 
            	<th style="width:20px;"><cf_get_lang dictionary_id="58577.Sıra"></th>
				<th><cf_get_lang dictionary_id='49674.Görev'> <cf_get_lang dictionary_id='57897.Adı'></th>
				<th><cf_get_lang dictionary_id='29761.URL'></th>
				<th><cf_get_lang dictionary_id='57501.Başlangıç'></th>
				<th><cf_get_lang dictionary_id='57502.Bitiş'></th>
				<th><cf_get_lang dictionary_id='42674.Peryod'></th>
				<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<th style="width:20px;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_schedule_settings&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_schedules.recordcount>
				<cfoutput query="get_schedules" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
					<tr>
						<td>#currentrow#</td>
						<td><a href="#request.self#?fuseaction=settings.list_schedule_settings&event=upd&schedule_id=#replace(SCHEDULE_ID,",","","ALL")#" class="tableyazi">#SCHEDULE_NAME#</a></td>
						<td>#SCHEDULE_URL#</td>				
						<td>#dateformat(SCHEDULE_STARTDATE,dateformat_style)#</td>
						<td>#dateformat(SCHEDULE_FINISHDATE,dateformat_style)#</td>
						<td>
							<cfif isnumeric(SCHEDULE_INTERVAL)>
								<cfset hours = Int(SCHEDULE_INTERVAL / 3600)>
								<cfset mins = Int((SCHEDULE_INTERVAL - (hours * 3600)) / 60)>
								<cfset secs = Int(SCHEDULE_INTERVAL - (hours * 3600) - (mins * 60))>
								#hours# <cf_get_lang dictionary_id='57491.Saat'> #mins# <cf_get_lang dictionary_id='58127.Dakika'>
							<cfelse>
								#SCHEDULE_INTERVAL#											
						  </cfif>
						</td>
						<td>#SCHEDULE_DESC#</td>
						<td><a href="#request.self#?fuseaction=settings.list_schedule_settings&event=upd&schedule_id=#replace(SCHEDULE_ID,",","","ALL")#" class="tableyazi"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="8"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif> !</td> 
				</tr>
			</cfif> 
		</tbody>
	</cf_flat_list>
</cf_box>
    <cfset url_str = "">
    <cfif len(attributes.keyword)>
    	<cfset url_str = '#url_str#&keyword=#attributes.keyword#'>
    </cfif>
    <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="settings.list_schedule_settings#url_str#&is_form_submitted=1">
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
