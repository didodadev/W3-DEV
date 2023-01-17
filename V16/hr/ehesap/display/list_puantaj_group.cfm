<cfif isdefined('attributes.is_submit')>
	<cfset cmp = createObject("component","V16.hr.ehesap.cfc.employee_puantaj_group")>
	<cfset cmp.dsn = dsn/>
	<cfset get_groups = cmp.get_groups(keyword:attributes.keyword)>
<cfelse>
	<cfset get_groups.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_groups.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="filter_list_puantaj_group" action="#request.self#?fuseaction=ehesap.list_puantaj_group" method="post">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" placeholder="#place#" maxlength="50">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="47079.Çalışan Grupları"></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id="58969.Grup Adı"></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="JAVASCRIPT://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.popup_add_puantaj_group</cfoutput>','','ui-draggable-box-small')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_groups.recordcount>
					<cfoutput QUERY="get_groups" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td align="center">#currentrow#</td>
							<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_upd_puantaj_group&group_id=#get_groups.group_id#','','ui-draggable-box-small')">#group_name#</a></td>
							<!-- sil -->
							<td align="center"> 
								<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_upd_puantaj_group&group_id=#get_groups.group_id#','','ui-draggable-box-small')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a> 
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="5"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_flat_list>

		<cfset url_str = "">            
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
			<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
		</cfif>            
		<cf_paging page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="ehesap.list_puantaj_group#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
