<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
<cfquery name="GET_SALES_ZONES_TEAM" datasource="#dsn#">
	SELECT
		SALES_ZONES_TEAM.TEAM_ID,
		SALES_ZONES.SZ_ID,
		SALES_ZONES_TEAM.TEAM_NAME,
		SALES_ZONES.SZ_NAME
	FROM
		SALES_ZONES_TEAM,
		SALES_ZONES
	WHERE
		SALES_ZONES.SZ_ID = SALES_ZONES_TEAM.SALES_ZONES
	<cfif len(attributes.keyword)>
		AND
		(
		SALES_ZONES_TEAM.TEAM_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR
		SALES_ZONES.SZ_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		)
	</cfif>
	ORDER BY
		SALES_ZONES_TEAM.TEAM_NAME
</cfquery>
<cfelse>
	<cfset get_sales_zones_team.recordcount=0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.form_submitted" default="0">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_sales_zones_team.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" action="#request.self#?fuseaction=salesplan.list_sales_team" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<div class="input-group ">
						<cfinput type="text" id="keyword" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder = "#getLang('main',48)#">
					</div>
				</div>
				<div class="form-group">
					<div class="input-group small">
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='57803.Satış Takımları'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='41478.Satış Takımı'></th>
					<th><cf_get_lang dictionary_id='57659.satis bölgesi'></th>
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=salesplan.list_sales_team&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_sales_zones_team.recordcount>
					<cfoutput query="get_sales_zones_team" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_company_info&team_id=#team_id#','list');" class="tableyazi">#team_name#</a></td>
							<td>#sz_name#</td>
							<!-- sil -->
							<td style="text-align:center;"><a href="#request.self#?fuseaction=salesplan.list_sales_team&event=upd&sz_id=#sz_id#&team_id=#team_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cfif isdefined("attributes.form_submitted") and attributes.form_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset url_str = "salesplan.list_sales_team">
		<cfif isdefined("attributes.form_submitted")>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cf_paging
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#url_str#">
	</cf_box>
</div>

<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>