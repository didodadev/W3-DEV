<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_status" default="1">
<cfparam name="attributes.search_type" default="1">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.start_dates" default="">
<cfparam name="attributes.finish_dates" default="">
<cfif len(attributes.start_dates) and isdate(attributes.start_dates)>
	<cf_date tarih = "attributes.start_dates">
</cfif>
<cfif len(attributes.finish_dates) and isdate(attributes.finish_dates)>
	<cf_date tarih = "attributes.finish_dates">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_member_analysiss.cfm">
<cfelse>
	<cfset get_member_analysis.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_member_analysis.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_analysis" method="post" action="#request.self#?fuseaction=member.list_analysis">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">			
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
					<cfinput type="text" name="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#message#">
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id"  id="employee_id" value="<cfif len(attributes.employee_id) and len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57899.Kaydeden"></cfsavecontent>
						<input name="employee" type="text" id="employee" style="width:135px;" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" value="<cfif len(attributes.employee_id) and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255" autocomplete="off" placeholder="<cfoutput>#message#</cfoutput>">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_analysis.employee_id&field_name=list_analysis.employee&select_list=1','list','popup_list_positions');"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57738.Başlama Tarihi Girmelisiniz'>!</cfsavecontent>
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput name="start_dates" id="start_dates" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.start_dates,dateformat_style)#" message="#message#" style="width:65px;" placeholder="#place#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_dates"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'> !</cfsavecontent>
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput name="finish_dates" id="finish_dates" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.finish_dates,dateformat_style)#" message="#message#" style="width:65px;" placeholder="#place#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_dates"></span>
					</div>
				</div>
				<div class="form-group large">
					<select name="search_type" id="search_type">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.search_type is 1> selected</cfif>><cf_get_lang dictionary_id='30412.Yayınlanıyor'></option>
						<option value="0" <cfif attributes.search_type is 0> selected</cfif>><cf_get_lang dictionary_id='30413.Yayınlanmıyor'></option>
					</select>
				</div>
				<div class="form-group medium">
					<select name="search_status" id="search_status">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.search_status is 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.search_status is 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function='control2()' button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=member.list_analysis&event=add"><i class="fa fa-plus"></i></a>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id="29913.Üye Analiz Formları"></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th width="250"><cf_get_lang dictionary_id='29764.Form'></th>
					<th width="350"><cf_get_lang dictionary_id='30277.Amaç'></th>
					<th ><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='29479.Yayın Durumu'></th>					
					<th class="header_icn_none" width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=member.list_analysis&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></th>					
				</tr>
			</thead>
			<tbody>
				<cfif get_member_analysis.recordcount>
					<cfoutput query="get_member_analysis" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#currentrow#</td>	
							<td height="22"><a href="#request.self#?fuseaction=member.list_analysis&event=det&analysis_id=#analysis_id#">#analysis_head#</a></td>
							<td>#analysis_objective#</td>
							<td>#get_emp_info(get_member_analysis.record_emp,0,1)#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<td><cfif is_active><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<td><cfif is_published><cf_get_lang dictionary_id='30412.Yayınlanıyor'><cfelse><cf_get_lang dictionary_id='30413.Yayınlanmıyor'></cfif></td>
							<td width="20"><a href="#request.self#?fuseaction=member.list_analysis&event=upd&analysis_id=#analysis_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput> 
					<cfelse>
						<tr> 
							<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.search_type")>
			<cfset url_str = "#url_str#&search_type=#attributes.search_type#">
		</cfif> 
		<cfif isdefined("attributes.search_status")>
			<cfset url_str = "#url_str#&search_status=#attributes.search_status#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif> 
		<cfif len(attributes.start_dates)>
			<cfset url_str="#url_str#&start_dates=#dateformat(attributes.start_dates,dateformat_style)#">
		</cfif>
		<cfif len(attributes.finish_dates)>
			<cfset url_str="#url_str#&finish_dates=#dateformat(attributes.finish_dates,dateformat_style)#">
		</cfif>
		<cfif len(attributes.employee)>
			<cfset url_str="#url_str#&employee=#attributes.employee#">
			<cfset url_str="#url_str#&employee_id=#attributes.employee_id#">
		</cfif>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="member.list_analysis#url_str#">
 	</cf_box>
</div>			
<script type="text/javascript">
document.getElementById('keyword').focus();
function control2()
{
	if( !date_check(document.getElementById('start_dates'),document.getElementById('finish_dates'), "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
		return false;
	else
		return true;
}
</script>
