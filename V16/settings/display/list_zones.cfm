<cf_get_lang_set module_name="settings">
<cfparam name="attributes.is_active" default=1>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submitted")>
<cfquery name="get_zones" datasource="#dsn#">
	SELECT
		HIERARCHY,
		ZONE_STATUS,
		ZONE_ID,
		ZONE_NAME
	FROM
		ZONE
	WHERE
		ZONE_ID IS NOT NULL
	<cfif len(attributes.keyword) and (len(attributes.keyword) eq 1)>
		AND ZONE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
	<cfelseif len(attributes.keyword) and (len(attributes.keyword) gt 1)>
		AND ZONE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
	</cfif>
	<cfif attributes.is_active is 1>
		AND ZONE_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_active#">
	<cfelseif attributes.is_active is 0>
		AND ZONE_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_active#">
	</cfif>
	ORDER BY
		ZONE_NAME
</cfquery>
<cfelse>
	<cfset get_zones.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_zones.RecordCount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_zones" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search> 
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group">
					<select name="is_active" id="is_active">
						<option value="1" <cfif attributes.is_active is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
						<option value="0" <cfif attributes.is_active is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
						<option value="2" <cfif attributes.is_active is 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cfif not fusebox.circuit eq 'hr'><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></cfif>
				</div>
			</cf_box_search> 
		</cfform>
	</cf_box>
	<cf_box title="#getLang(158,'Bölgeler',42141)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>		
					<th><cf_get_lang dictionary_id='42529.Bölge Adı'></th>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<th><cf_get_lang dictionary_id='43152.Statüsü'></th>
					<th width="20" class="header_icn_none text-center">
						<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_zones&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</th>
				</tr>
			</thead>
			<tbody>
				<cfif get_zones.RecordCount>
					<cfoutput query="get_zones" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_zones&event=upd&id=#ZONE_ID#" class="tableyazi">#ZONE_NAME#</a></td>
							<td>#hierarchy#</td>
							<td><cfif ZONE_STATUS eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<td class="text-center"><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_zones&event=upd&id=#ZONE_ID#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Guncelle'>" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a></td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="6"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.form_submitted)>
				<cfset formun_adresi = "#listgetat(attributes.fuseaction,1,'.')#.list_zones&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#formun_adresi#&keyword=#attributes.keyword#&is_active=#attributes.is_active#&form_submitted=#attributes.form_submitted#"> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
   	document.getElementById('keyword').focus();
</script>
<br/>
<cf_get_lang_set module_name="#fusebox.circuit#">
