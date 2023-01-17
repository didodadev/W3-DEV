<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_sales_zones.cfm">
<cfelse>
	<cfset get_sales_zones.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_active" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_sales_zones.recordcount#'>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.form_submitted" default="">
<cfparam name="attributes.keyword" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT 
		BRANCH_NAME,
		BRANCH_ID
	FROM
		BRANCH
	WHERE
		BRANCH_ID IN(
					SELECT
						BRANCH_ID
					FROM
						EMPLOYEE_POSITION_BRANCHES
					WHERE
						POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
					)
	ORDER BY
		BRANCH_NAME
</cfquery> 
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_sales_plan" method="post" action="#request.self#?fuseaction=salesplan.list_plan">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#place#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="branch_id" id="branch_id">
						<option value=""><cf_get_lang dictionary_id='30126.Şube Seçiniz'></option>
						<cfoutput query="get_branch">
							<option value="#branch_id#" <cfif attributes.branch_id eq branch_id>selected</cfif>>
								#branch_name#
							</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="is_active" id="is_active">
						<option value="2"<cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='30111.Durumu'></option>
						<option value="1"<cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0"<cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1" />
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='57767.Satış Bölgeleri'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<th><cf_get_lang dictionary_id='57992.Bölge'></th>
					<th><cf_get_lang dictionary_id='41448.Üst Bölge'></th>
					<th><cf_get_lang dictionary_id='41457.İlgili Şube'></th>
					<th><cf_get_lang dictionary_id='29511.Yönetici'></th>
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=salesplan.list_plan&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>          
				</tr>
			</thead>
			<tbody>
				<cfif get_sales_zones.recordcount>
					<cfoutput query="get_sales_zones" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr> 
							<td>#currentrow#</td>
							<td>#ozel_kod#</a></td>
							<td>
								<a href="#request.self#?fuseaction=salesplan.list_plan&event=upd&sz_id=#sz_id#" class="tableyazi">
								<cfloop from="1" to="#listlen(sz_hierarchy,".")-2#" index="i">&nbsp;&nbsp;&nbsp;</cfloop>#sz_name#</a>
							</td>
							<td>
								<cfif listlen(sz_hierarchy,".") gt 2>
								<cfset attributes.hierarchy = listdeleteat(sz_hierarchy,listlen(sz_hierarchy,"."),".")>
								<cfinclude template="../query/get_upper_sz_name.cfm">
								<a href="#request.self#?fuseaction=salesplan.list_plan&event=upd&sz_id=#get_upper_sz_name.sz_id#" class="tableyazi">#get_upper_sz_name.sz_name#</a><cfelse>-</cfif>
							</td>
							<td>#branch_name#</td>
							<td>
								<a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#&POS_ID=#position_code#&DEPARTMENT_ID=#DEPARTMENT_ID#','medium');" class="tableyazi">#employee_name# #employee_surname#</a> 
								<cfif len(responsible_company_id)> /
								<cfset attributes.company_id = responsible_company_id>
								<cfinclude template="../query/get_company_name.cfm">
								<a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#attributes.company_id#','medium');" class="tableyazi">#get_company_name.nickname#</a>
								</cfif>
								<cfif len(responsible_par_id)> -
								<cfset attributes.partner_id = responsible_par_id>
								<cfinclude template="../query/get_partner_name.cfm">
								<a href="javascript://"  onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#attributes.partner_id#','medium');" class="tableyazi">#get_partner_name.COMPANY_PARTNER_NAME# #get_partner_name.COMPANY_PARTNER_SURNAME#</a>			
								</cfif>
							</td>
							<td width="15"><a href="#request.self#?fuseaction=salesplan.list_plan&event=upd&sz_id=#sz_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr> 
						<td colspan="9"><cfif attributes.form_submitted neq 1><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "">
		<cfif isdefined("attributes.form_submitted") and len (attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.branch_id)>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif len(attributes.form_submitted)>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="salesplan.list_plan&#url_str#"> 
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
