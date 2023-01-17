<cfset url_str = "">
<cfif isdefined("attributes.startdate")>
	<cfset url_str = "#url_str#&startdate=#attributes.startdate#">
</cfif>
<cfif isdefined("attributes.finishdate")>
	<cfset url_str = "#url_str#&finishdate=#attributes.finishdate#">
</cfif>
<cfif isdefined("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.eventcat_id")>
	<cfset url_str = "#url_str#&eventcat_id=#attributes.eventcat_id#">
</cfif>
<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">

<cfinclude template="../query/get_con_event_search.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.modal_id" default=''>
<cfparam name="attributes.eventcat_id" default=''>
<cfparam name="startdate" default=''>
<cfparam name="finishdate" default=''>
<cfparam name="attributes.totalrecords" default=#get_event_search.recordcount#>  
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Olaylar','30468')#" popup_box="1">
		<cfinclude template="../query/get_event_cats.cfm">
		<cfform name="search" method="post" action="#request.self#?fuseaction=member.popup_list_con_agenda&consumer_id=#attributes.consumer_id#">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" maxlength="100" value="#attributes.keyword#" placeholder="#getLang('','Filtre','57460')#">
				</div>
				<div class="form-group">
					<select name="eventcat_id" id="eventcat_id">
						<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
						<cfoutput query="get_event_cats">
							<option value="#eventcat_id#" <cfif attributes.eventcat_id eq eventcat_id>selected</cfif>>#eventcat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlama Tarihi!'></cfsavecontent>
					<div class="input-group">
						<cfinput type="text" name="startdate" value="#dateformat(startdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi!'></cfsavecontent>
						<cfinput type="text" name="finishdate" value="#dateformat(finishdate,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="loadPopupBox('search','#attributes.modal_id#')">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th height="25" colspan="4" class="txtboldblue"><cf_get_lang dictionary_id='57658.Üye'> : 
					<cfinclude template="../query/get_consumer.cfm">
					<cfoutput>		
						#GET_CONSUMER.consumer_name# #GET_CONSUMER.consumer_surname#
					</cfoutput>
					</th>
				</tr>
				<tr>
					<th width="50"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='57480.Başlık'></th>
					<th width="150"><cf_get_lang dictionary_id='30469.Olay Kategorisi'></th>
					<th width="130"><cf_get_lang dictionary_id='57742.Tarih'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_event_search.recordcount>
					<cfoutput query="get_event_search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#event_id#</td>
							<td>
							<a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=agenda.view_daily&event=upd&event_id=#event_id#';self.close();" class="tableyazi">#event_head#</a>
							</td>
							<td>#eventcat#</td>
							<td>#dateformat(date_add('h',session.ep.time_zone,startdate),dateformat_style)# - #dateformat(date_add('h',session.ep.time_zone,finishdate),dateformat_style)#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
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
			adres="member.popup_list_con_agenda#url_str#"> 
		</cfif>
	</cf_box>
</div>
