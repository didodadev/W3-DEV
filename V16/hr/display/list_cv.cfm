<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfif len(attributes.startdate) gt 5>
	<cf_date tarih="attributes.startdate">
<cfelse>
	<cfset attributes.startdate = "">
</cfif>
<cfif len(attributes.finishdate) gt 5>
	<cf_date tarih="attributes.finishdate">
<cfelse>
	<cfset attributes.finishdate="">
</cfif>
<cfif not isdefined("attributes.keyword")>
	<cfset filtered = 0>
<cfelse>
	<cfset filtered = 1>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.emp_app_type" default="">
<cfparam name="attributes.cv_status" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfscript>
	attributes.startrow = ((attributes.page - 1) * attributes.maxrows) + 1;
	cmp_process = createObject("component","V16.hr.cfc.get_process_rows");
	cmp_process.dsn = dsn;
	get_process_stage = cmp_process.get_process_type_rows(
		faction: "%hr.list_cv%"
	);
	if (isdefined("filtered"))
	{
		cmp_cv = createObject("component","V16.hr.cfc.get_cv");
		cmp_cv.dsn = dsn;
		get_cv = cmp_cv.get_cv(
			keyword: attributes.keyword,
			cv_status: attributes.cv_status,
			status: attributes.status,
			emp_app_type: attributes.emp_app_type,
			startdate: attributes.startdate,
			finishdate: attributes.finishdate,
			maxrows: attributes.maxrows,
			startrow: attributes.startrow,
			process_stage: attributes.process_stage
		);
	}
	else
		get_cv.recordcount = 0;
	url_str = "";
	if (isdefined("attributes.keyword"))
		url_str = "#url_str#&keyword=#attributes.keyword#";
	if (isdefined("attributes.status"))
		url_str = "#url_str#&status=#attributes.status#";
	if (isdefined("attributes.emp_app_type"))
		url_str = "#url_str#&emp_app_type=#attributes.emp_app_type#";
	if (isdefined('attributes.cv_status') and len(attributes.cv_status))
		url_str="#url_str#&cv_status=#cv_status#";
	if (len(attributes.startdate) gt 5)
		url_str = "#url_str#&startdate=#dateformat(attributes.startdate,dateformat_style)#";
	if (len(attributes.finishdate) gt 5)
		url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#";
	if (isdefined("attributes.process_stage") and len(attributes.process_stage))
		url_str="#url_str#&process_stage=#attributes.process_stage#";
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="form" action="#request.self#?fuseaction=hr.list_cv" method="post">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(219,'Ad',57631)# #getLang(1314,'Soyad',58726)#">
				</div>
				<div class="form-group">
					<select name="status" id="status">
						<option value="" <cfif attributes.status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>	
						<option value="1" <cfif attributes.status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
						<option value="0" <cfif attributes.status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>			                        
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)"  required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
					<cf_wrk_search_button button_type="4" search_function="date_check(form.startdate,form.finishdate,'#message_date#')">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-date">
						<label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
						<div class="input-group">
							<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56704.Tarih Hatalı'></cfsavecontent>
							<cfif len(attributes.startdate) gt 5>
								<cfinput type="text" name="startdate" maxlength="10" value="#dateformat(attributes.startdate,dateformat_style)#" validate="#validate_style#" message="#alert#">
							<cfelse>
								<cfinput type="text" name="startdate" maxlength="10" value="" validate="#validate_style#" message="#alert#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-date2">
						<label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="input-group">
							<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56704.Tarih Hatalı'></cfsavecontent>
							<cfif len(attributes.finishdate) gt 5>
								<cfinput type="text" name="finishdate" maxlength="10" value="#dateformat(attributes.finishdate,dateformat_style)#" validate="#validate_style#" message="#alert#">
							<cfelse>
								<cfinput type="text" name="finishdate" maxlength="10" value="" validate="#validate_style#" message="#alert#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-emp_app_type">
						<label class="col col-12"><cfoutput>#getLang(31,'Başvuru',55116)# #getLang(1239,'Türü',58651)#</cfoutput></label>
						<div class="col col-12">
							<select name="emp_app_type" id="emp_app_type">
								<option value="" <cfif attributes.emp_app_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>	
								<option value="1" <cfif attributes.emp_app_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='56492.İK Arşivi'>
								<option value="0" <cfif attributes.emp_app_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='56493.İnternet Başvuruları'>			                        
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-get_process_stage">
						<label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
						<div class="col col-12">
							<select name="process_stage" id="process_stage">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_process_stage">
									<option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='49821.Özgeçmiş'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list> 
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th width="30"><i class="fa fa-camera"></i></th>
					<th><cf_get_lang dictionary_id ='55911.Okul / Bölüm'></th>
					<th><cf_get_lang dictionary_id ='56494.Son İş Tecrübesi'></th>
					<th><cf_get_lang dictionary_id='55745.Yaş'></th>
					<!-- sil -->
					<th class="text-center" width="40"><cf_get_lang dictionary_id='58143.İletişim'></th>
					<!-- sil -->
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<th class="text-center" width="100"><cf_get_lang dictionary_id='57756.Durum'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_cv&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<th width="20" class="header_icn_none text-center"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_cv.recordcount>
					<cfset attributes.totalrecords = get_cv.query_count>
					<cfoutput query="get_cv">
						<tr>
							<td><a href="#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#empapp_id#" class="tableyazi">#rownum#</a></td>
							<td><a href="#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#empapp_id#" class="tableyazi">#name# #surname#</a></td>
							<td>
								<cfif len(get_cv.photo)>
									<a href="javascript://" onclick="windowopen('#file_web_path#hr/#photo#');"><i class="fa fa-camera"></i></a>
								</cfif>
							</td>
							<td><cfif len(edu_name) or len(edu_part_name)> #edu_name# / #edu_part_name#</cfif></td>
							<td>#exp#<br/>#exp_position#</td>
							<td>
								<cfif len(birth_date)>
									<cfset yas = datediff("yyyy",birth_date,now())>
									<cfif yas neq 0>
										#yas#
									</cfif>	
								</cfif>
							</td>
							<!-- sil -->
							<td class="text-center"><label><cfif len(email)><a href="mailto:#get_cv.email#"><i class="fa fa-envelope" title="#get_cv.email#"></i></a>&nbsp;</cfif>
								<cfif ((len(mobilcode) and len(mobil)) or (len(mobilcode2) and len(mobil2))) and (session.ep.our_company_info.sms eq 1)>
									<a href="tel://#get_cv.mobilcode##get_cv.mobil#"><i title="( #get_cv.mobilcode# ) #get_cv.mobil#" class="fa fa-mobile-phone"></i></a>&nbsp;
								</cfif>
								<cfif len(hometelcode) and len(hometel)><a href="tel://#hometelcode##hometel#"><i title="( #hometelcode# ) #hometel#" class="fa fa-phone"></i></a></cfif></label>
							</td>
							<!-- sil -->
							<td>#dateformat(record_date,dateformat_style)#</td>
							<td align="center">
								<cf_workcube_process type="color-status" process_stage="#CV_STAGE#">
							</td>
							<!-- sil -->
							<td width="20"><a href="#request.self#?fuseaction=hr.list_cv&event=upd&empapp_id=#empapp_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<td width="20"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#empapp_id#&print_type=170','print_page','workcube_print');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="10"><cfif not isdefined("filtered")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="hr.list_cv#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
