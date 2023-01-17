<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_special_report_categories.cfm">
<cfelse>
	<cfset get_special_report_categories.recordcount=0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfset url_string = "">
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_special_report_categories.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!-- sil -->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="filter" action="#request.self#?fuseaction=report.list_special_report_categories" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="Text" maxlength="50" placeholder="#place#" value="#attributes.keyword#" name="keyword" id="keyword">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='38928.Özel Rapor Kategorileri'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=report.form_add_special_report_category"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_special_report_categories.recordcount>
					<cfoutput query="get_special_report_categories" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="15">#currentrow#</td>
							<td>
								<cfif ListLen(HIERARCHY,".") neq 1>
									<cfloop from="1" to="#ListLen(HIERARCHY,".")#" index="i">&nbsp;</cfloop>
								</cfif>
								<a href="#request.self#?fuseaction=report.form_upd_special_report_category&report_cat_id=#report_cat_id#">#report_cat#</a>
							</td>
							<td>#detail#</td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<!-- sil -->
							<td align="center">
								<a href="#request.self#?fuseaction=report.form_upd_special_report_category&report_cat_id=#report_cat_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="report.list_special_report_categories#url_string#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
