<!---E.A 20072012 select ifadeleri düzenlendi.---> 
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.form_exist" default="0">
<cfif attributes.form_exist>
	<cfquery name="GET_SCENARIOS" datasource="#DSN#">
		SELECT 
			SCENARIO_ID,
			#dsn#.Get_Dynamic_Language(SCENARIO_ID,'#session.ep.language#','SETUP_SCENARIO','SCENARIO',NULL,NULL,SCENARIO) AS SCENARIO
		FROM 
			SETUP_SCENARIO <cfif len(attributes.keyword)>WHERE SCENARIO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
	</cfquery>
<cfelse>
    <cfset get_scenarios.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_scenarios.recordcount#>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="form" action="#request.self#?fuseaction=budget.list_scenarios" method="post">
			<cf_box_search>
					<input type="hidden" name="form_exist" id="form_exist" value="1">
					<div class="form-group">
						<cfinput type="text" name="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#" maxlength="50">
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='34135.Sayı Hatası Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" maxlength="3">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('budget',79)#">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='59321.Senaryo'></th>
					<!-- sil -->
					<th width="35"> 
						<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=budget.list_scenarios&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='31179.Senaryo Tanımı Ekle'>" title="<cf_get_lang dictionary_id='31179.Senaryo Tanımı Ekle'>"></i></a>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_scenarios.recordcount>
					<cfoutput query="get_scenarios" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
						<tr>
							<td>#currentrow#</td>
							<td>#scenario#</td>
							<!-- sil --><td width="15"><a href="#request.self#?fuseaction=budget.list_scenarios&event=upd&id=#get_scenarios.scenario_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='54567.Senaryo Tanımı Güncelle'>" title="<cf_get_lang dictionary_id='54567.Senaryo Tanımı Güncelle'>"></i></a></td><!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
					<tr>
						<cfif attributes.form_exist>
							<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
						<cfelse>
							<td colspan="3"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
						</cfif>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfset url_str = "">
		<cfif isdefined ("attributes.form_exist") and len (attributes.form_exist)>
			<cfset url_str = "#url_str#&form_exist=#attributes.form_exist#">
		</cfif>
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="budget.list_scenarios#url_str#">
	</cf_box>
</div>

<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
