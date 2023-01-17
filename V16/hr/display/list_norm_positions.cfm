<cfparam name="attributes.norm_year" default="#year('#now()#')#">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.company_id" default="">
<cfscript>
	attributes.startrow = ((attributes.page-1) * attributes.maxrows) + 1;
	if (fuseaction contains "popup")
		is_popup = 1;
	else
		is_popup = 0;
	
	if (not isdefined("attributes.ay"))
		attributes.ay = month(now());
	
	cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
	cmp_pos_cat.dsn = dsn;
	get_position_cats = cmp_pos_cat.get_position_cat(
		position_cat: attributes.keyword
	);
	
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_company_name = cmp_company.get_company();
	
	if (isdefined("form_submitted"))
	{
		cmp_norm_pos = createObject("component","V16.hr.cfc.get_norm_positions");
		cmp_norm_pos.dsn = dsn;
		get_norm_pos = cmp_norm_pos.get_norm_pos(
			keyword: attributes.keyword,
			company_id: attributes.company_id,
			branch_id: '#iif(isdefined("attributes.branch_id") and len(attributes.branch_id),"attributes.branch_id",DE(""))#',
			norm_year: attributes.norm_year,
			position_cat_id: attributes.position_cat_id,
			maxrows: attributes.maxrows,
			startrow: attributes.startrow
		);
	}
	else
	{
		get_norm_pos.query_count = 0;
		get_norm_pos.recordcount = 0;
	}
		
	url_str = '';
	if (isdefined("attributes.keyword") and len(attributes.keyword))
		url_str = '#url_str#&keyword=#attributes.keyword#';
	if (isdefined("attributes.ay") and len(attributes.ay))
		url_str = '#url_str#&ay=#attributes.ay#';
	if (isdefined("attributes.company_id") and len(attributes.company_id))
		url_str = '#url_str#&company_id=#attributes.company_id#';
	if (isdefined("attributes.position_cat_id") and len(attributes.position_cat_id))
		url_str = '#url_str#&position_cat_id=#attributes.position_cat_id#';
	if (isdefined("attributes.norm_year") and len(attributes.norm_year))
		url_str = '#url_str#&norm_year=#attributes.norm_year#';
	if (isdefined("attributes.form_submitted") and len(attributes.form_submitted))
		url_str = '#url_str#&form_submitted=#attributes.form_submitted#';
</cfscript>

<cfparam name="attributes.totalrecords" default='#get_norm_pos.query_count#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search" action="#request.self#?fuseaction=hr.list_norm_positions" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" maxlength="50" id="keyword" value="#attributes.keyword#" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group">
					<cfset bu_yil = "#year('#now()#')#">
					<select name="norm_year" id="norm_year" style="width:50;">
						<cfoutput>
							<cfloop from="-2" to="3" index="i">
							<cfset deger=bu_yil+i>
								<option value="#deger#" <cfif attributes.norm_year eq deger>selected</cfif>>#deger#</option>
							</cfloop>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="ay" id="ay">
						<cfloop from="1" to="12" index="i">
							<option <cfif attributes.ay eq i>selected</cfif> value="<cfoutput>#i#</cfoutput>"><cfoutput>#ListGetAt(ay_list(),i)#</cfoutput></option>
						</cfloop>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-company_id">
						<label class="col col-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
						<div class="col col-12">
							<select name="company_id" id="company_id" style="width:200px;">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfif get_company_name.recordcount>
								<cfoutput query="get_company_name">
									<option value="#comp_id#" <cfif attributes.company_id eq comp_id>selected</cfif>>#nick_name#</option>
								</cfoutput>
							</cfif>
						</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-position_cat_id">
						<label class="col col-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
						<div class="col col-12">
							<select name="position_cat_id" id="position_cat_id" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_position_cats">
									<option value="#position_cat_id#" <cfif isdefined("attributes.position_cat_id") and attributes.position_cat_id eq position_cat_id>selected</cfif>>#position_cat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(126,'Norm Kadrolar',55211)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>    
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57992.Bölge'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th width="35" align="center"><cf_get_lang dictionary_id='55441.Kadro'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_norm_pos.recordcount>
					<cfoutput query="get_norm_pos">
						<tr>
							<td>#rownum#</td>
							<td>#nick_name#</td>
							<td>#zone_name#</td>
							<td>		
								<cfif len(evaluate("employee_count#attributes.ay#"))><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=hr.popup_dsp_norm_staff&branch_id=#branch_id#&norm_year=#attributes.norm_year#','horizantal');">
									#branch_name#</a>
								<cfelse>
									#branch_name#
								</cfif>
							</td>
							<td align="center">#evaluate("employee_count#attributes.ay#")#</td>
							<!-- sil -->
							<td><cfif not len(evaluate("employee_count#attributes.ay#"))>
									<cfset link="#request.self#?fuseaction=hr.list_norm_positions&event=add&branch_id=#branch_id#&norm_year=#attributes.norm_year#">
									<cfset img_link="fa-plus">
									<cfsavecontent variable="link_title"><cf_get_lang dictionary_id='57582.Ekle'></cfsavecontent>
								<cfelse>
									<cfset link="#request.self#?fuseaction=hr.list_norm_positions&event=upd&branch_id=#branch_id#&norm_year=#attributes.norm_year#">
									<cfset img_link="fa-pencil">
									<cfsavecontent variable="link_title"><cf_get_lang dictionary_id='57464.Güncelle'></cfsavecontent>
								</cfif>
								<a href="javascript://"  title="#link_title#" onClick="windowopen('#link#','list_horizantal');"><i class="fa #img_link#"></i></a>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list> 

		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="hr.list_norm_positions#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
