<cfset url_str = "">
<cfif isdefined("attributes.action_id")>
	<cfset url_str = "#url_str#&action_id=#attributes.action_id#">
</cfif>
<cfif isdefined("attributes.action_section")>
	<cfset url_str = "#url_str#&action_section=#attributes.action_section#">
</cfif>
<cfif isdefined("attributes.event_id")>
	<cfset url_str = "#url_str#&event_id=#attributes.event_id#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date_events" default="">
<cfparam name="attributes.finish_date_events" default="">
<cfparam name="attributes.event_cat" default="">
<cfparam name="attributes.url_str" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.consumer" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_id" default="">
<cfif IsDefined("attributes.is_submitted")>
	<cfinclude template="../query/get_events.cfm">
<cfelse>
	<cfset get_event.recordcount = 0> 
</cfif>		
<cfquery name="get_event_cat" datasource="#dsn#">
	SELECT * FROM EVENT_CAT WHERE IS_VIP <> 1
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_event.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('','Ajanda',57415)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="list_events" method="post" action="#request.self#?fuseaction=objects.popup_list_events#url_str#">
		<cf_box_search>
			<div class="form-group" id="keyword">
				<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" maxlength="50" value="#attributes.keyword#">
			</div>   
			<div class="form-group" id="keyword">
				<select name="event_cat" id="event_cat" >
				<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_event_cat">
						<option value="#eventcat_id#" <cfif attributes.event_cat eq eventcat_id>selected</cfif>>#eventcat#</option>
					</cfoutput>
				</select>
			</div>  
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" >
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("date_check(list_events.start_date_events,list_events.finish_date_events,'#getLang('','Tarih Değerini Kontrol Ediniz',57782)#') && loadPopupBox('list_events' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
		<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_events' , #attributes.modal_id#)"),DE(""))#">
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<input type="hidden" name="is_submitted" id="is_submitted" value="1">
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="project_id"  id="project_id" value="<cfif len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57416.Proje'></cfsavecontent>
						<input type="text" name="project_head" placeholder="<cfoutput>#message#</cfoutput>" id="project_head" value="<cfif len(attributes.project_id) and len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onFocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','120');" autocomplete="off">
						<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head');"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfif len(attributes.member_id) and attributes.member_type eq 'c'>
							<cfset attributes.consumer_id = attributes.member_id>
							<cfset attributes.member_type = 'consumer'>
						<cfelseif len(attributes.member_id) and attributes.member_type eq 'comp'>
							<cfset attributes.company_id = attributes.member_id>
							<cfset attributes.member_type = 'partner'>
						</cfif>
						<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id) and attributes.member_type eq 'consumer'>
							<cfquery name="get_consumer_name" datasource="#dsn#">
								SELECT CONSUMER_NAME +' ' + CONSUMER_SURNAME AS MEMBER_NAME FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
							</cfquery>
							<cfset attributes.company = get_consumer_name.member_name>
						<cfelseif isdefined('attributes.company_id') and len(attributes.company_id) and attributes.member_type eq 'partner'>
							<cfquery name="get_company_name" datasource="#dsn#">
								SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
							</cfquery>
							<cfset attributes.company = get_company_name.nickname>
						</cfif> 
						<cfoutput>
							<input type="hidden" name="consumer_id"   id="consumer_id" value="<cfif len(attributes.consumer_id) and attributes.member_type eq 'consumer'>#attributes.consumer_id#</cfif>">			
							<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id) and attributes.member_type eq 'partner'>#attributes.company_id#</cfif>">
							<input type="hidden" name="partner_id"  id="partner_id" value="<cfif len(attributes.company)>#attributes.partner_id#</cfif>">
							<input type="hidden" name="member_type"  id="member_type" <cfif len(attributes.member_type)>value="#attributes.member_type#"</cfif>>
							<input type="text" name="company"  placeholder="<cfoutput>#getLang('','Üye',57658)#</cfoutput>" id="company"  value="<cfif len(attributes.company)>#attributes.company#</cfif> " onFocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID,PARTNER_ID,MEMBER_TYPE','consumer_id,company_id,partner_id,member_type','','3','250');" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_all_pars&select_list=7,8&field_comp_name=list_events.company&field_comp_id=list_events.company_id&field_partner=list_events.partner_id&field_consumer=list_events.consumer_id&field_member_name=list_events.company&field_type=list_events.member_type')"></span>
						</cfoutput>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfif isdefined("attributes.start_date_events")>
							<cfinput type="text" name="start_date_events" value="#dateFormat(attributes.start_date_events,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
						<cfelse>
							<cfinput type="text" name="start_date_events" value="" validate="#validate_style#" maxlength="10" message="#alert#">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date_events"></span>
					</div>
				</div>   
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="alert2"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></cfsavecontent>
						<cfif isdefined("attributes.finish_date_events")>
							<cfinput type="text" name="finish_date_events" value="#dateFormat(attributes.finish_date_events,dateformat_style)#"  validate="#validate_style#" maxlength="10" message="#alert2#">
						<cfelse>
							<cfinput type="text" name="finish_date_events" value="" validate="#validate_style#" maxlength="10" message="#alert2#">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date_events"></span> 
					</div>
				</div>
			</div>
		</cf_box_search_detail>  
		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='29510.Olay'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='57590.Katılımcılar'></th>
					<th><cf_get_lang dictionary_id='57416.Proje'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>  
				</tr>
			</thead>
			<tbody>
				<cfset project_name_list = ''>
				<cfif get_event.recordcount>
					<cfoutput query="get_event" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(project_id) and not listfind(project_name_list,project_id)>
							<cfset project_name_list = Listappend(project_name_list,project_id)>
						</cfif>
					</cfoutput>
					<cfif len(project_name_list)>
						<cfquery name="get_project_name" datasource="#dsn#">
							SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_name_list#) ORDER BY PROJECT_ID
						</cfquery>
						<cfset project_name_list = listsort(listdeleteduplicates(valuelist(get_project_name.project_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfquery name="get_eventcat_id" datasource="#dsn#">
						SELECT EVENTCAT,EVENTCAT_ID FROM EVENT_CAT ORDER BY EVENTCAT_ID
					</cfquery>
					<cfset eventcat_id_list=ValueList(GET_EVENTCAT_ID.EVENTCAT_ID,',')>
					<cfoutput query="get_event" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(event_to_pos)>
							<cfquery name="detail_event_to_pos" datasource="#dsn#">
								SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#listsort(event_to_pos,'numeric')#)
							</cfquery>
						</cfif> 
						<cfif len(event_to_par)>
							<cfquery name="detail_event_to_par" datasource="#dsn#">
								SELECT * FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#listsort(event_to_par,'numeric')#)
							</cfquery>
						</cfif> 
						<cfif len(event_to_con)>
							<cfquery name="detail_event_to_con" datasource="#dsn#">
								SELECT * FROM CONSUMER WHERE CONSUMER_ID IN (#listsort(event_to_con,'numeric')#)
							</cfquery>
						</cfif>
						<tr>
							<td>
								<cfif isdefined("attributes.action_id")>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.emptypopup_relate_event&action_id=#attributes.action_id#&action_section=#attributes.action_section#&event_id=#event_id#&type=#TYPE#<cfif isdefined('EVENT_ROW_ID') and len(EVENT_ROW_ID)>&event_row_id=#EVENT_ROW_ID#</cfif>')">#get_event.event_head#</a>
								<cfelse>
									<a href="##" onClick="add_notes2('#event_id#','#replace(event_head," "," ","all")#');">#get_event.event_head#</a><!--- '#replace(event_head,"'"," ","all")#' --->
								</cfif>
							</td>
							<td>#get_event.eventcat#</td>
							<td><cfif len(event_to_par)>
									<cfloop query="detail_event_to_par">
										#detail_event_to_par.company_partner_name#&nbsp;#detail_event_to_par.company_partner_surname#,
									</cfloop>
								</cfif>
								<cfif Len(event_to_pos)>
									<cfloop query="detail_event_to_pos">
										#detail_event_to_pos.employee_name#&nbsp;#detail_event_to_pos.employee_surname#,
									</cfloop>
								</cfif>
								<cfif Len(event_to_con)>
									<cfloop query="detail_event_to_con">
										#detail_event_to_con.consumer_name#&nbsp;#detail_event_to_con.consumer_surname#,
									</cfloop>
								</cfif>
							</td>
							<td>
								<cfif len(project_id) and project_id neq 0>
									<a href="#request.self#?fuseaction=project.projects&event=det&id=#get_project_name.project_id[listfind(project_name_list,project_id,',')]#" class="tableyazi">#get_project_name.project_head[listfind(project_name_list,project_id,',')]#</a></td>
								<cfelse>
									<cf_get_lang dictionary_id='58459.projesiz'>
								</cfif>
							</td>
							<td width="15%">
								<cfif isdefined("session.pp.time_zone")>
									<cfset event_startdate = date_add('h', session.pp.time_zone, get_event.startdate)>
									<cfset event_finishdate = date_add('h', session.pp.time_zone, get_event.finishdate)>
									#dateformat(event_startdate,dateformat_style)#&nbsp;#timeformat(event_startdate,timeformat_style)# - #dateformat(event_finishdate,dateformat_style)#&nbsp; #timeformat(event_finishdate,timeformat_style)#
								</cfif>
								<cfif isdefined("session.ep.time_zone")>
									<cfset event_startdate = date_add('h', session.ep.time_zone, get_event.startdate)>
									<cfset event_finishdate = date_add('h', session.ep.time_zone, get_event.finishdate)>
									#dateformat(event_startdate,dateformat_style)#&nbsp;#timeformat(event_startdate,timeformat_style)# - #dateformat(event_finishdate,dateformat_style)#&nbsp; #timeformat(event_finishdate,timeformat_style)#
								</cfif>
							</td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="5"><cfif IsDefined("attributes.is_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cfform>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif isdefined("attributes.start_date_events")>
		<cfset url_str = "#url_str#&start_date_events=#dateformat(attributes.start_date_events)#">
		</cfif>
		<cfif isdefined("attributes.finish_date_events")>
			<cfset url_str = "#url_str#&finish_date_events=#dateformat(attributes.finish_date_events)#">
		</cfif>
		<cfif isdefined("attributes.project_id")>
			<cfset url_str = "#url_str#&project_id=#attributes.project_id#&project_head=#URLDecode(attributes.project_head)#">
		</cfif>
		<cfif isdefined("attributes.event_cat")>
			<cfset url_str = "#url_str#&event_cat=#attributes.event_cat#">
		</cfif>
		<cfif isdefined("attributes.event_head")>
			<cfset url_str = "#url_str#&event_head=#URLDecode(attributes.event_head)#">
		</cfif>
		<cfif isdefined("attributes.is_submitted")>
			<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
		</cfif>
		<cfif Len(attributes.company_id) and Len(attributes.company)>
			<cfset url_str = "#url_str#&company_id=#attributes.company_id#&company=#attributes.company#">
		<cfelseif Len(attributes.consumer_id) and Len(attributes.company)>
			<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
		</cfif>
		<cfif isdefined("attributes.member_type")>
			<cfset url_str = "#url_str#&member_type=#attributes.member_type#">
		</cfif>
		<cfif isdefined("attributes.partner_id")>
			<cfset url_str = "#url_str#&partner_id=#attributes.partner_id#">
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_list_events#url_str#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
$(document).ready(function(){

    $( "form[name=list_events] #keyword" ).focus();

});

function add_notes2(id,head)
{
	<cfoutput>
		<cfif isdefined("attributes.field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_id#.value = id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_name#.value = head;
		</cfif>
	</cfoutput>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
