<cfparam name="attributes.page" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfif isDefined("attributes.form_submitted")>
	<cfset get_inspection_level = createObject("component","V16.settings.cfc.setupInspectionLevel").getInspectionLevel(dsn3:dsn3,keyword:attributes.keyword)>
<cfelse>
	<cfset get_inspection_level.recordcount = 0>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_inspection_level.recordcount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="inspection_level" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" maxlength="50" name="keyword" id="keyword" placeholder="#place#" value="#attributes.keyword#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang_main dictionary_id='57537.Kayit Sayisi Hatali'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" onKeyUp="isNumber(this);" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Muayene Seviyeleri','61278')#" uidrop="1" hide_table_column="1">
		<cf_flat_list><!--- #lang_array.item[1713]# - Muayene Seviyeleri --->
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58585.Kod'></th>
					<th><cf_get_lang dictionary_id='57631.Ad'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_add_inspection_level')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_inspection_level.recordcount>
					<cfoutput query="get_inspection_level" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#currentrow#</td>
							<td>#inspection_level_code#</td>
							<td>#inspection_level_name#</td>
							<td>#description#</td>
							<!-- sil -->
							<td style="text-align:center;" width="20" align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_upd_inspection_level&level_id=#inspection_level_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>	
							<!-- sil -->
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="8"><cfif not isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#attributes.fuseaction#&form_submitted=1&keyword=#attributes.keyword#"> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
