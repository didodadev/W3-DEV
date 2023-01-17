<cfinclude template="../display/report_menu.cfm">
<cfset x = structdelete(session,'report')>
<!-- sil -->

<cfparam name="attributes.record_date" default="">
<cfif isdefined("attributes.record_date") and isdate(attributes.record_date)>
	<cf_date tarih="attributes.record_date">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_reports.cfm">
<cfelse>
	<cfset get_reports.recordcount=0>
</cfif>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.report_cat_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.recorder_id" default="">
<cfparam name="attributes.report_status" default="1">
<cfset url_string = "">
<cfset url_string = "#url_string#&report_status=#attributes.report_status#">
<cfif len(attributes.report_cat_id)>
	<cfset url_string = "#url_string#&special_report_cat=#attributes.report_cat_id#">
</cfif>
<cfif len(attributes.keyword)>
	<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.employee_id)>
	<cfset url_string="#url_string#&employee_id=#attributes.employee_id#">
</cfif>
<cfif len(attributes.employee)>
	<cfset url_string="#url_string#&employee=#attributes.employee#">
</cfif>
<cfif isdate(attributes.record_date)>
	<cfset url_string = "#url_string#&record_date=#dateformat(attributes.record_date,dateformat_style)#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
</cfif>

<cfquery name="get_special_report_cats" datasource="#dsn#">
	SELECT
    	REPORT_CAT_ID,
        REPORT_CAT,
        HIERARCHY
    FROM
    	SETUP_REPORT_CAT
    ORDER BY
    	HIERARCHY
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_reports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!-- sil -->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="filter" action="#request.self#?fuseaction=report.list_reports" method="post">
			<cf_box_search>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group">
					<input type="text" name="keyword" id="keyword" style="width:100px;" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" maxlength="255" onKeyDown="if(event.keyCode == 13) {searchButtonFunc()}">
				</div>
				<div class="form-group">
					<select name="report_cat_id" id="report_cat_id" style="width:200px;">
						<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
						<cfoutput query="get_special_report_cats">
							<option value="#report_cat_id#" <cfif report_cat_id eq attributes.report_cat_id>selected</cfif>>
								<cfif ListLen(HIERARCHY,".") neq 1>
									<cfloop from="1" to="#ListLen(HIERARCHY,".")#" index="i">&nbsp;</cfloop>
								</cfif>
								#report_cat#
							</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" maxlength="50" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input type="text" name="employee" id="employee" style="width:200px;" placeholder="<cf_get_lang dictionary_id='49250.Kayıt Yapan'>" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" value="<cfif isdefined("attributes.employee_id") and isdefined("attributes.employee")and len(attributes.employee_id) and len(attributes.employee)><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>" autocomplete="off">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=filter.employee_id&field_name=filter.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.filter.employee.value),'list');"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></cfsavecontent>
						<cfsavecontent variable="alert"><cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='58503.Lütfen Tarih Giriniz '></cfsavecontent>
						<cfinput type="text" name="record_date" id="record_date" placeholder="#place#" maxlength="10" value="#dateformat(attributes.record_date,dateformat_style)#"  validate="#validate_style#" message="#alert#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
					</div>
				</div>
				<div class="form-group"> 
					<select name="report_status" id="report_status">
						<option value='-1'><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value='0'<cfif attributes.report_status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value='1'<cfif attributes.report_status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='58145.Özel Raporlar'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th style="width:350px;"><cf_get_lang dictionary_id='57434.Rapor'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th style="width:150px;"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th style="width:85px;"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<cfif get_module_power_user(33)>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=report.list_reports&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
					</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif get_reports.recordcount>
					<cfoutput query="get_reports" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a class="tableyazi" href="#request.self#?fuseaction=report.<cfif is_file eq 1>emptypopup_</cfif>detail_report&event=det&report_id=#report_id#">#report_name#</a></td>
							<td>#report_detail#</td>
							<td><cfif get_reports.report_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#record_emp#','medium');" class="tableyazi">#employee_name# #employee_surname#</a></td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<cfif get_module_power_user(33)>
								<!-- sil -->
								<td align="center">
									<cfif is_special eq 0>
										<a href="#request.self#?fuseaction=report.list_reports&event=upd&report_id=#report_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
									<cfelse>
										<a href="#request.self#?fuseaction=report.list_reports&event=upd&report_id=#report_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
									</cfif>
								</td>
								<!-- sil -->
							</cfif>
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
			adres="report.list_reports#url_string#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

