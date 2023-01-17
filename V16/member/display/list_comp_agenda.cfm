<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.eventcat_id" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.modal_id" default="">
<cfset url_str = "&company_id=#attributes.company_id#">
<cfif isDefined("attributes.partner_id") and Len(attributes.partner_id)>
	<cfset url_str = "#url_str#&partner_id=#attributes.partner_id#&member_type=partner">
</cfif>
<cfif isdate(attributes.startdate)>
	<cfset url_str = "#url_str#&startdate=#attributes.startdate#">
</cfif>
<cfif isdate(attributes.finishdate)>
	<cfset url_str = "#url_str#&finishdate=#attributes.finishdate#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.eventcat_id)>
	<cfset url_str = "#url_str#&eventcat_id=#attributes.eventcat_id#">
</cfif>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>
<cfinclude template="../query/get_comp_event_search.cfm">
<cfinclude template="../query/get_event_cats.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_event_search.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cf_box title="#getLang('','Olaylar',30468)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_agenda" method="post" action="#request.self#?fuseaction=member.popup_list_comp_agenda&company_id=#attributes.company_id#">
		<cf_box_search more="0">
			<input type="hidden" name="partner_id" value="<cfif isDefined("attributes.partner_id") and Len(attributes.partner_id)><cfoutput>#attributes.partner_id#</cfoutput></cfif>" />
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<div class="form-group" id="keyword">
				<cfinput type="text" name="keyword" maxlength="50" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
			</div>         
			<div class="form-group" id="eventcat_id">
				<select name="eventcat_id" id="eventcat_id">
					<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
					<cfoutput query="get_event_cats">
						<option value="#eventcat_id#" <cfif attributes.eventcat_id eq eventcat_id>selected</cfif>>#eventcat#</option>
					</cfoutput>
				</select>
			</div>   
			<div class="form-group" id="item-startdate">
				<div class="input-group"> 
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlama Tarihi!'></cfsavecontent>
					<cfif isdate(attributes.startdate)>                
						<cfinput type="text" name="startdate" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
					<cfelse>
						<cfinput type="text" name="startdate" value="" validate="#validate_style#" maxlength="10" message="#message#">
					</cfif>
					<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
				</div>
			</div>  
			<div class="form-group" id="item-finishdate">
				<div class="input-group"> 
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi!'></cfsavecontent>
					<cfif isdate(attributes.finishdate)>
						<cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
					<cfelse>
						<cfinput type="text" name="finishdate" value="" validate="#validate_style#" maxlength="10" message="#message#">
					</cfif>
					<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
				</div>
			</div>  
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">		
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_agenda' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th colspan="5"><cf_get_lang dictionary_id ='57574.Şirket'>:<cfoutput>#get_company_partners.fullname#</cfoutput></th>
			</tr>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='57480.Başlık'></th>
				<th width="150"><cf_get_lang dictionary_id='30469.Olay Kategorisi'></th>
				<th width="130"><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th width="20"><a href="<cfoutput>#request.self#?fuseaction=agenda.view_daily&event=add&is_popup=1<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>&partner_id=#attributes.partner_id#</cfif></cfoutput>&member_type=partner"  target="_blank"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='58496.Olay Ekle'>"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_event_search.recordcount and form_varmi eq 1>
				<cfoutput query="get_event_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#event_id#</td>
					<td><a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#" target="_blank">#event_head#</a></td>
					<td>#eventcat#</td>
					<td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)#</td>
					<td class="text-center"><a href="#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
				</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="5"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="member.popup_list_comp_agenda#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
