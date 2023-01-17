<cf_xml_page_edit fuseact="objects.popup_emp_det">
<cfinclude template="../query/get_emp.cfm">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_emp_events.cfm">
<cfelse>
	<cfset emp_events.recordcount=0>
</cfif>
<cfinclude template="../query/get_emp_det.cfm">
<cfif not isdefined("attributes.startdate")>
	<cfset attributes.startdate = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
</cfif>
<cfif not isdefined("attributes.finishdate")>
	<cfset attributes.finishdate = date_add('d',7,attributes.startdate)>
</cfif>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default=1>
<cfparam name="attributes.totalrecords" default='#emp_events.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="Takvim" popup_box="1">

<cfform name="get_events" method="post" action="#request.self#?fuseaction=objects.emptypopup_ajax_emp_events">
	<input type="hidden" name="form_submitted" id="form_submitted" value="1">
	<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#attributes.emp_id#</cfoutput>">
	<input type="hidden" name="pos_id" id="pos_id" value="<cfoutput>#get_emp_pos.position_code#</cfoutput>">					
	<cfif isdefined("session.ep.userid")>
		<cfif not isdefined("attributes.startdate")>
			<cfset attributes.startdate = "">
		</cfif>
		<cfif not isdefined("attributes.finishdate")>
			<cfset attributes.finishdate = "">
		</cfif>
		<cf_box_search>
			<div class="form-group">
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Giriniz !'></cfsavecontent>
					<cfinput type="text" name="startdate" required="Yes" message="#message#" validate="#validate_style#" value="#dateformat(attributes.startdate, dateformat_style)#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfsavecontent variable="message2"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
					<cfinput type="text" name="finishdate" required="Yes" message="#message2#" validate="#validate_style#" value="#dateformat(attributes.finishdate, dateformat_style)#"> 
					<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
				</div>
			</div>
			
			<div class="form-group">
				<cf_wrk_search_button search_function="loadPopupBox('get_events','#attributes.modal_id#')" button_type="4">
			</div>
		</cf_box_search>
		<div id="div_emp_info"></div>
	</cfif> 
</cfform>
<table class="ajax_list">
	<tbody>
		<cfif emp_events.recordcount neq 0>

			<cfoutput query="emp_events" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>
						<!--- <cfif type eq 1><cf_get_lang dictionary_id='57415.Ajanda'>
						<cfelseif type eq 2><cf_get_lang dictionary_id='58445.İş'>
						<cfelseif type eq 3><cf_get_lang dictionary_id='58575.İzin'>
						<cfelseif type eq 4><cf_get_lang dictionary_id='58576.Vizite'>
						<cfelseif type eq 5><cf_get_lang dictionary_id='57438.Call Center'>
						<cfelseif type eq 6><cf_get_lang dictionary_id='57656.Servis'>
						<cfelseif type eq 7><cf_get_lang dictionary_id='57419.Eğitim'>
						</cfif> :  ---> 
					#name#
					</td>
					<td>#dateformat(date_add("h",session.ep.time_zone,target_start),'dd/mm/yyyy')#,#timeformat(date_add("h",session.ep.time_zone,target_start),timeformat_style)#</td>
					<td>#dateformat(date_add("h",session.ep.time_zone,target_finish),'dd/mm/yyyy')#,#timeformat(date_add("h",session.ep.time_zone,target_finish),timeformat_style)#</td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>
		</cfif>
	</tbody>
</table>
<cfif emp_events.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<cf_paging 
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="objects.emptypopup_ajax_emp_events&startdate=#startdate#&finishdate=#finishdate#&emp_id=#emp_id#">
</cfif>
</cf_box>
