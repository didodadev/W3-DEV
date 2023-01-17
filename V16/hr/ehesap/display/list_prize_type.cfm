<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_prize_type.cfm">
<cfelse>
	<cfset GET_PRIZE_TYPE.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_PRIZE_TYPE.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform action="#request.self#?fuseaction=ehesap.list_prize_type" method="post" name="filter_list_prize_type">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<cf_box_search plus="0">
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</div>
				<div class="form-group" id="item-add-button">
					<a href="javascript://" class="ui-btn ui-btn-gray" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.list_prize_type&event=add</cfoutput>','','ui-draggable-box-medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                </div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Ödül Tipleri','53504')#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th width="35"><cf_get_lang dictionary_id='57493.Aktif'>/<cf_get_lang dictionary_id='57494.Pasif'></th>
					<th width="100%"><cf_get_lang dictionary_id='57630.Tip'></th>
					<!-- sil -->
					<th class="header_icn_none">
					<a href="JAVASCRIPT://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.list_prize_type&event=add</cfoutput>','','ui-draggable-box-medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif GET_PRIZE_TYPE.recordcount>
					<cfoutput QUERY="GET_PRIZE_TYPE" <!---  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" --->>
						<tr>
							<td align="center">#currentrow#</td>
							<td><cfif is_active eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<td><a href="JAVASCRIPT://" onClick="windowopen('#request.self#?fuseaction=ehesap.list_prize_type&event=upd&prize_type_id=#prize_type_id#','small')" class="tableyazi">#prize_type#</a></td>
							<!-- sil -->
							<td align="center"> 
								<a href="JAVASCRIPT://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_prize_type&event=upd&prize_type_id=#prize_type_id#','','ui-draggable-box-medium')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a> 
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cfif not isdefined('attributes.is_submit')><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !<cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
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
	adres="ehesap.list_prize_type#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
