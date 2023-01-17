<cfif fuseaction eq "campaign.list_survey">
	<cfset xfa.upd =  "campaign.form_upd_survey">
	<cfset xfa.lst=  "campaign.list_survey">
	<cfset xfa.list=  "campaign.list_survey">	
<cfelseif fuseaction eq "campaign.popup_add_email_surveys">
	<cfset xfa.upd =  "campaign.add_email_surveys">
	<cfset xfa.lst =  "campaign.popup_add_email_surveys">
	<cfset xfa.list =  "campaign.popup_add_email_surveys">
<cfelseif fuseaction eq "campaign.popup_list_target_surveys">
	<cfset xfa.upd =  "campaign.add_target_surveys">
	<cfset xfa.list =  "campaign.popup_list_target_surveys">
</cfif>
<cfparam name="attributes.start_dates" default="">
<cfparam name="attributes.finish_dates" default="">
<cfparam name="attributes.survey_status" default="">
<cfparam name="attributes.stage_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.camp_id" default="">
<cfif isdefined("attributes.start_dates") and isdate(attributes.start_dates)>
	<cf_date tarih = "attributes.start_dates">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.start_dates=''>
	<cfelse>
		<cfset attributes.start_dates= date_add('m',-1,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.finish_dates") and isdate(attributes.finish_dates)>
	<cf_date tarih = "attributes.finish_dates">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.finish_dates=''>
	<cfelse>
		<cfset attributes.finish_dates= date_add('d',0,wrk_get_today())>
	</cfif>
</cfif>
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_surveys.cfm">
<cfelse>
	<cfset get_surveys.recordcount = 0>   
</cfif>
<cfinclude template="../query/get_survey_stages.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_surveys.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search" method="post" action="#request.self#?fuseaction=#xfa.list#">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<input type="hidden" name="camp_id" id="camp_id" value="<cfoutput>#attributes.camp_id#</cfoutput>">
			<cf_box_search>
				<div class ="form-group">
					<cfinput type="text" name="keyword"  id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class ="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
							<cfinput name="start_dates" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.start_dates,dateformat_style)#" placeholder="#place#" style="width:65px;">
							<cfelse>			
							<cfinput name="start_dates" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.start_dates,dateformat_style)#" placeholder="#place#" style="width:65px;"  required="yes">
						</cfif>
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_dates"></span>
					</div>
				</div>
				<div class ="form-group">
					<div class="input-group">
						<cfsavecontent variable="place2"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
						<cfinput name="finish_dates" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.finish_dates,dateformat_style)#" placeholder="#place2#" style="width:65px;" >			
						<cfelse>
						<cfinput name="finish_dates" validate="#validate_style#" maxlength="10" value="#dateformat(attributes.finish_dates,dateformat_style)#" placeholder="#place2#" style="width:65px;"  required="yes">
						</cfif>
						<span class="input-group-addon">
						<cf_wrk_date_image date_field="finish_dates">
						</span>
					</div>
				</div>
				<div class ="form-group">
					<select name="stage_id" id="stage_id">
						<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
						<cfoutput query="get_survey_stages">
							<option value="#process_row_id#" <cfif attributes.stage_id eq get_survey_stages.process_row_id>selected</cfif>>#get_survey_stages.stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class ="form-group">
					<select name="survey_status" id="survey_status">
						<option value="3" <cfif attributes.survey_status eq 3>selected</cfif>><cf_get_lang dictionary_id ='57708.Tümü'></option>
						<option value="2" <cfif attributes.survey_status eq 2>selected</cfif>><cf_get_lang dictionary_id ='57494.Pasif'></option>
						<option value="1" <cfif attributes.survey_status eq 1>selected</cfif>><cf_get_lang dictionary_id ='57493.Aktif'></option>
					</select>
				</div>
				<div class ="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class ="form-group">
					<cf_wrk_search_button button_type="4" search_function="kontrol()">
					<cfif xfa.upd NEQ "campaign.add_target_surveys">
						<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
					</cfif>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(535,'Anketler',57947)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58662.Anket'></th>
					<th><cf_get_lang dictionary_id='58810.Soru'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<!-- sil -->
					<th class="header_icn_none" nowrap="nowrap"></th>
					<th width="20" class="header_icn_none" nowrap="nowrap">
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=campaign.list_survey&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_surveys.recordcount>
					<cfoutput query="get_surveys" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
								<cfif xfa.upd eq "campaign.add_target_surveys">
								<cfif isdefined("tmarket_id")>
							<td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#survey_id#&tmarket_id=#tmarket_id#','small');">#survey_head#</a></td>
							<td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#survey_id#&tmarket_id=#tmarket_id#','small');">#survey#</a></td>
								<cfelse>
							<td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#survey_id#&camp_id=#attributes.camp_id#','small');">#survey_head#</a></td>
							<td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#survey_id#&camp_id=#attributes.camp_id#','small');">#survey#</a></td>
								</cfif>
								<cfelse>
							<td><a href="#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#survey_id#" class="tableyazi">#survey_head#</a></td>
							<td><a href="#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#survey_id#" class="tableyazi">#survey#</a></td>
								</cfif>
							<td>#stage_name#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium')" class="tableyazi">#employee_name# #employee_surname#</a></td>
							<td>#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)#</td>
							<!-- sil -->
							<td align="center"><a href="#request.self#?fuseaction=campaign.list_survey&event=dashboard&survey_id=#survey_id#"><i class="icon-chart" alt="<cf_get_lang dictionary_id='58135.Sonuçlar'>" title="<cf_get_lang dictionary_id='58135.Sonuçlar'>"></i></a></td>
							<td width="15">
								<cfif xfa.upd eq "campaign.add_target_surveys">
								<cfif isdefined("tmarket_id")>
									<a href="#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#survey_id#&tmarket_id=#tmarket_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								<cfelse>
									<a href="#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#survey_id#&camp_id=#attributes.camp_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								</cfif>
								<cfelse>
									<a href="#request.self#?fuseaction=campaign.list_survey&event=upd&survey_id=#survey_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a> 
								</cfif>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="8"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı '>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif get_surveys.recordcount>
			<cfset url_str = "&is_submit=#attributes.is_submit#&camp_id=#attributes.camp_id#">
			<cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
			<cfif len(attributes.stage_id)><cfset url_str = "#url_str#&stage_id=#attributes.stage_id#"></cfif>
			<cfif len(attributes.start_dates)> <cfset url_str = "#url_str#&start_dates=#dateformat(attributes.start_dates,dateformat_style)#"> </cfif>
			<cfif len(attributes.finish_dates)> <cfset url_str = "#url_str#&finish_dates=#dateformat(attributes.finish_dates,dateformat_style)#"></cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#xfa.list##url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function windowreload()
{
	wrk_opener_reload();
}
function kontrol()
{
	if (!date_check (document.getElementById('start_dates'),document.getElementById('finish_dates'),"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
		return false;
	else
		return true;	
}
</script>
