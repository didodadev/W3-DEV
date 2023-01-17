<cfparam name="attributes.position_cat_status" default="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_submit" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfscript>
	attributes.startrow = ((attributes.page - 1) * attributes.maxrows) + 1;
	if (fuseaction contains "popup")
		is_popup = 1;
	else
		is_popup = 0;
		
	if (isdefined("attributes.is_submit"))
	{
		cmp_pos_cat = createObject("component","V16.hr.cfc.get_position_cat");
		cmp_pos_cat.dsn = dsn;
		positioncategories = cmp_pos_cat.get_position_cat(
			position_cat_status: attributes.position_cat_status,
			position_cat: attributes.keyword,
			maxrows: attributes.maxrows,
			startrow: attributes.startrow
		);
	}
	else
	{
		positioncategories.query_count = 0;
		positioncategories.recordcount = 0;
	}
	
	url_str = "";
	if (isdefined('attributes.is_submit') and len (attributes.is_submit))
		url_str = "#url_str#&is_submit=#attributes.is_submit#";
	if (len(attributes.keyword))
		url_str = "#url_str#&keyword=#attributes.keyword#";
	if (len(attributes.position_cat_status))
		url_str = "#url_str#&position_cat_status=#attributes.position_cat_status#";
	if (len(attributes.is_submit))
		url_str = "#url_str#&is_submit=#attributes.is_submit#";
</cfscript>

<cfparam name="attributes.totalrecords" default="#positioncategories.query_count#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform action="#request.self#?fuseaction=hr.list_position_cats" method="post" name="filter_status">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" style="width:80px;" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('main',48)#">
				</div>
				<div class="form-group">
					<select name="position_cat_status" id="position_cat_status">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.position_cat_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.position_cat_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Pozisyon Tipleri','57779')#" uidrop="1" hide_table_column="1">
		<cf_grid_list> 
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></th>
					<th width="75"><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					<!-- sil -->
					<th class="text_center">
						<cfif not listfindnocase(denied_pages,'hr.form_add_position_cat')>
							<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_position_cats&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='55139.Pozisyon Tipi Ekle'>"></i></a>
						</cfif>
					</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif positioncategories.recordcount>
					<cfoutput query="positioncategories">
						<tr>
							<td width="35">#rownum#</td>
							<td><a href="#request.self#?fuseaction=hr.list_position_cats&event=upd&position_id=#position_cat_id#" class="tableyazi">#position_cat#</a></td>
							<td>#hierarchy#</td>
							<!-- sil -->
							<td width="15" class="text_center"><a href="#request.self#?fuseaction=hr.list_position_cats&event=upd&position_id=#position_cat_id#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cfif isdefined('attributes.is_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>


             	              
<cf_paging page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="hr.list_position_cats#url_str#">