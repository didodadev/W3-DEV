<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submitted")>
<cfquery name="get_head" datasource="#dsn#">
	SELECT
		HEADQUARTERS_ID,
		NAME
	FROM
		SETUP_HEADQUARTERS
	WHERE
		NAME IS NOT NULL
	<cfif len(attributes.keyword) and (len(attributes.keyword) eq 1)>
		AND NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
	<cfelseif len(attributes.keyword) and (len(attributes.keyword) gt 1)>
		AND NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI 
	</cfif>
	<cfif isdefined("attributes.upper_headquarters_id") and len(attributes.upper_headquarters_id) and len(attributes.upper_headquarters_name)>
		AND UPPER_HEADQUARTERS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_headquarters_id#">
	</cfif>
	ORDER BY
		NAME
</cfquery>
<cfelse>
	<cfset get_head.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_head.RecordCount#">
<cfset url_str = "">
<cfif isdefined("attributes.upper_headquarters_id") and len(attributes.upper_headquarters_id) and len(attributes.upper_headquarters_name)>
	<cfset url_str = "#url_str#&upper_headquarters_id=#attributes.upper_headquarters_id#&upper_headquarters_name=#attributes.upper_headquarters_name#">
</cfif>
<cfif isdefined("attributes.hr")>
	<cfset formun_adresi = 'hr.list_headquarters&hr=1'>
<cfelse>
	<cfset formun_adresi = 'settings.list_headquarters'>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form_head" action="#request.self#?fuseaction=#formun_adresi#" method="post">
			<cf_box_search>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group">
					<div class="input-group">
						<input type="hidden" name="upper_headquarters_id" id="upper_headquarters_id" value="<cfif isdefined("attributes.upper_headquarters_id") and len(attributes.upper_headquarters_id) and len(attributes.upper_headquarters_name)><cfoutput>#attributes.upper_headquarters_id#</cfoutput></cfif>">
						<input type="text" name="upper_headquarters_name" id="upper_headquarters_name" value="<cfif isdefined("attributes.upper_headquarters_id") and len(attributes.upper_headquarters_id) and len(attributes.upper_headquarters_name)><cfoutput>#attributes.upper_headquarters_name#</cfoutput></cfif>" placeholder="<cfoutput>#getLang(1280,'Üst Grup',43263)#</cfoutput>">
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_headquarters&field_name=form_head.upper_headquarters_name&field_id=form_head.upper_headquarters_id</cfoutput>','list');"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<cfif not isdefined("attributes.hr")><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></cfif>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(951,'Üst Düzey birimler',42934)#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr> 
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='42984.Üst Düzey Birim'></th>
					<th width="20" class="header_icn_none text-center">
						<cfif isdefined("attributes.hr")>
							<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_headquarters&event=add&hr=1"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
						<cfelse>
							<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.list_headquarters&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
						</cfif>
					</th>
				</tr>
			</thead>
			<tbody>
				<cfif get_head.RecordCount>
					<cfoutput query="get_head" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td width="15">#currentrow#</td>
							<td><cfif isdefined("attributes.hr")>
									<a href="#request.self#?fuseaction=hr.list_headquarters&event=upd&head_id=#get_head.headquarters_id#&hr=1" class="tableyazi">#name#</a>
								<cfelse>
									<a href="#request.self#?fuseaction=settings.list_headquarters&event=upd&head_id=#get_head.headquarters_id#" class="tableyazi">#name#</a>
								</cfif>
							</td>
							<td>
								<cfif isdefined("attributes.hr")>
									<a href="#request.self#?fuseaction=hr.list_headquarters&event=upd&head_id=#get_head.headquarters_id#&hr=1"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Guncelle'>" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a>
								<cfelse>
									<a href="#request.self#?fuseaction=settings.list_headquarters&event=upd&head_id=#get_head.headquarters_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Guncelle'>" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a>
								</cfif>
							</td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr class="color-row" height="20"> 
						<td colspan="3"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#formun_adresi#&keyword=#attributes.keyword#&url_str=#url_str#"> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
    document.getElementById('keyword').focus();
</script>
