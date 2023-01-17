<cfset cfc=createObject("component","V16.training_management.cfc.training_survey")> 
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfset get_detail_survey=cfc.GetDetailSurvey(action_type:attributes.action_type,keyword:attributes.keyword,type_id:attributes.type_id)> 
<cfelse>
	<cfset get_detail_survey.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_detail_survey.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="list_detail_survey" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<input type="hidden" name="action_type" id="action_type" value="<cfoutput>#attributes.action_type#</cfoutput>">
			<cf_box_search> 
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" placeholder="#message#" name="keyword" id="keyword" maxlength="100" value="#attributes.keyword#">
				</div>
				<div class="form-group">
					<select name="type_id" id="type_id" style="width:160px;">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfloop list="#attributes.action_type#" delimiters="," index="x">
							<cfoutput>
							<option value="#x#" <cfif isdefined("attributes.type_id") and attributes.type_id eq x>selected</cfif>>
								<cfif x eq 1><cf_get_lang dictionary_id='57612.Fırsat'>
								<cfelseif x eq 2><cf_get_lang dictionary_id='57653.İçerik'>
								<cfelseif x eq 3><cf_get_lang dictionary_id='57446.Kampanya'>
								<cfelseif x eq 4><cf_get_lang dictionary_id='57657.Ürün'>
								<cfelseif x eq 5><cf_get_lang dictionary_id='57416.Proje'>
								<cfelseif x eq 6><cf_get_lang dictionary_id='29776.Deneme Süresi'>
								<cfelseif x eq 7><cf_get_lang dictionary_id='57996.İşe Alım'>
								<cfelseif x eq 8><cf_get_lang dictionary_id='58003.Performans'>
								<cfelseif x eq 9><cf_get_lang dictionary_id='57419.Eğitim'>
								<cfelseif x eq 10><cf_get_lang dictionary_id='29832.İşten Çıkış'>
								<cfelseif x eq 14><cf_get_lang dictionary_id='58662.Anket'>
								</cfif>
							</option>
							</cfoutput>
						</cfloop>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>

	<cfsavecontent variable="message"><cf_get_lang dictionary_id='61026.IK Formlar'></cfsavecontent>
    <cf_box uidrop="1" hide_table_column="1" title="#message#">
		<cf_grid_list>
			<thead>
				<tr>
					<th style="width:30px"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='29768.Formlar'></th>
					<th><cf_get_lang dictionary_id='57771.Detay'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none"><a href="javascript://" onclick=""><img src="images/report_square2.gif" border="0" alt="Sonuç Raporu" title="<cf_get_lang dictionary_id ='57684.Sonuç'> <cf_get_lang dictionary_id ='56858.Raporu'>"></a></th>
					<th width="20" class="header_icn_none text-center"><a href="javascript://" onclick="add_form();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='55185.Form Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_detail_survey.recordcount gt 0>
					<cfoutput query="get_detail_survey" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td nowrap="nowrap">
								<a href="#request.self#?fuseaction=hr.list_detail_survey_report&event=upd&survey_id=#survey_main_id#" class="tableyazi">#survey_main_head#</a>
							</td>
							<td>#survey_main_details#</td>
							<td>
								<cfif type eq 1>
								<cf_get_lang dictionary_id='57612.Fırsat'>
								<cfelseif type eq 2>
									<cf_get_lang dictionary_id='57653.İçerik'>
								<cfelseif type eq 3>
									<cf_get_lang dictionary_id='57446.Kampanya'>
								<cfelseif type eq 4>
									<cf_get_lang dictionary_id='57657.Ürün'>
								<cfelseif type eq 5>
									<cf_get_lang dictionary_id='57416.Proje'>
								<cfelseif type eq 6>
									<cf_get_lang dictionary_id='29776.Deneme Süresi'>
								<cfelseif type eq 7>
									<cf_get_lang dictionary_id='57996.İşe Alım'>
								<cfelseif type eq 8>
									<cf_get_lang dictionary_id='58003.Performans'>
								<cfelseif type eq 9>
									<cf_get_lang dictionary_id='57419.Eğitim'>
								<cfelseif type eq 10>
									<cf_get_lang dictionary_id='29832.İşten Çıkış'>
								<cfelseif type eq 14>
									<cf_get_lang dictionary_id='58662.Anket'>
								</cfif>
							</td>
							<td nowrap="nowrap">#stage#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<!-- sil -->
							<td nowrap="nowrap" style="text-align:center;">
								<a href="#request.self#?fuseaction=hr.list_detail_survey_report&event=report&survey_id=#survey_main_id#&action_type_=#type#"><img src="images/report_square2.gif" border="0" alt="Sonuç Raporu" title="<cf_get_lang dictionary_id ='57684.Sonuç'> <cf_get_lang dictionary_id ='56858.Raporu'>"></a>
							</td>
							<td nowrap="nowrap" style="text-align:center;">
								<a href="#request.self#?fuseaction=hr.list_detail_survey_report&event=upd&survey_id=#survey_main_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput> 
					<cfelse>
						<tr>
							<td colspan="9"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>..</cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.action_type")>
	<cfset url_str = "#url_str#&action_type=#attributes.action_type#">           
</cfif>
<cfif isdefined("attributes.type_id")>
	<cfset url_str = "#url_str#&type_id=#attributes.type_id#">           
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">           
</cfif>
<cf_paging 
    page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#attributes.fuseaction##url_str#"> 
<script language="javascript">
document.getElementById('keyword').focus();
function add_form()
{
	window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_detail_survey_report&event=Add<cfif isdefined("attributes.action_type")>&action_type=#attributes.action_type#</cfif></cfoutput>';
}
</script>
