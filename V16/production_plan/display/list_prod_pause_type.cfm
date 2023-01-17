<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_active" default="0">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_prod_pause_type" datasource="#dsn3#">
		SELECT 
			#dsn#.Get_Dynamic_Language(PROD_PAUSE_CAT_ID,'#session.ep.language#','SETUP_PROD_PAUSE_TYPE','PROD_PAUSE_TYPE',NULL,NULL,PROD_PAUSE_TYPE) AS PROD_PAUSE_TYPE,
			* 
		FROM 
			SETUP_PROD_PAUSE_TYPE
		WHERE
			1=1
			<cfif isdefined("attributes.is_active") and attributes.is_active eq 1>
				AND IS_ACTIVE = 1
			<cfelseif  isdefined("attributes.is_active") and attributes.is_active eq 2>
				AND IS_ACTIVE = 0
			<cfelse>
				AND IS_ACTIVE IN (1,0)
			</cfif>
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND PROD_PAUSE_TYPE LIKE '%#attributes.keyword#%'
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_prod_pause_type.recordcount = 0>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_prod_pause_type.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="pause_type" method="post" action="#request.self#?fuseaction=prod.list_prod_pause_type">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class ="form-group">
					<cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
				</div>
				<div class ="form-group">
					<select name="is_active" id="is_active">
						<option value="0"><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="2" <cfif attributes.is_active eq 2>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class ="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class ="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Duraklama Tipleri',36738)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id="36478.Duraklama Kodu"></th>
					<th><cf_get_lang dictionary_id="36986.Duraklama Tipi"></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><a onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=prod.list_prod_pause_type&event=add</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_prod_pause_type.recordcount>
					<cfoutput query="get_prod_pause_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#prod_pause_type_code#</td>
							<td>#prod_pause_type#</td>
							<!-- sil --><td width="20"><a onclick="openBoxDraggable('#request.self#?fuseaction=prod.list_prod_pause_type&event=upd&prod_pause_type_id=#prod_pause_type_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->																					
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_prod_pause_type">
		<cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined ("attributes.is_active") and len(attributes.is_active)>
			<cfset adres = "#adres#&is_active=#attributes.is_active#">
		</cfif>
		<cfif isdefined ("attributes.form_submitted") and len (attributes.form_submitted)>
			<cfset adres = "#adres#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
