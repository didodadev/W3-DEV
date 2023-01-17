<cfparam name="attributes.is_statu" default="1">
<cfparam name="attributes.is_special" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.pbs_cat_id" default="">
<cfparam name="attributes.sub_pbscode" default="-1">
<cfif isdefined('attributes.form_submit')>
	<cfquery name="GET_PBS" datasource="#dsn3#">
		SELECT
			SPC.*,
			SPCAT.PBS_CAT_NAME
		FROM
			SETUP_PBS_CODE SPC
			LEFT JOIN SETUP_PBS_CAT SPCAT ON SPC.PBS_CAT_ID = SPCAT.PBS_CAT_ID
		WHERE	
			SPC.PBS_ID IS NOT NULL
			<cfif attributes.is_statu eq 1>AND SPC.IS_ACTIVE = 1<cfelseif attributes.is_statu eq 0>AND SPC.IS_ACTIVE = 0</cfif>
			<cfif attributes.is_special eq 1>AND SPC.IS_SPECIAL = 1<cfelseif attributes.is_special eq 0>AND SPC.IS_SPECIAL = 0</cfif>
			<cfif len(attributes.pbs_cat_id)>
				AND SPC.PBS_CAT_ID = #attributes.pbs_cat_id#
			</cfif>
			<cfif len(attributes.keyword)>
				AND SPC.PBS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				SPC.PBS_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				SPC.PBS_DETAIL2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif>
			<cfif attributes.sub_pbscode neq -1>
				AND len(replace(SPC.PBS_CODE, '.', '.' + ' ')) - len(SPC.PBS_CODE) <= #attributes.sub_pbscode# 
			</cfif>
		ORDER BY
			PBS_CODE
	</cfquery>
<cfelse>
	<cfset get_pbs.recordcount=0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_pbs.recordcount#'>
<cfquery name="get_pbs_cat" datasource="#dsn3#">
	SELECT PBS_CAT_ID,PBS_CAT_NAME FROM SETUP_PBS_CAT
</cfquery>
<cfquery name="get_max_len" datasource="#dsn3#">
	SELECT ISNULL(MAX(len(replace(SETUP_PBS_CODE.PBS_CODE, '.', '.' + ' ')) - len(SETUP_PBS_CODE.PBS_CODE)),0) MAX_LEN FROM SETUP_PBS_CODE
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37058.PBS Kodları'></cfsavecontent>
<cf_box title="#message#" uidrop="1" hide_table_column="1" collapsable="0" resize="0">
	<cfform name="form" action="#request.self#?fuseaction=product.list_pbs_code" method="post">
		<input type="hidden" name="form_submit" id="form_submit" value="1">
		<cf_box_search more="0">
			<div class="form-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
				<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
			</div>
			<div class="form-group">
				<select name="pbs_cat_id" id="pbs_cat_id">
					<option value=""><cf_get_lang dictionary_id='37088.PBS Kategorisi'></option>
					<cfoutput query="get_pbs_cat">
						<option value="#pbs_cat_id#" <cfif pbs_cat_id eq attributes.pbs_cat_id>selected</cfif>>#pbs_cat_name#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<select name="sub_pbscode" id="sub_pbscode">
					<option value="0" <cfif attributes.sub_pbscode eq 0>selected</cfif>><cf_get_lang dictionary_id='37113.Üst Kırılımlar'></option>
					<cfloop from="1" to="#get_max_len.max_len#" index="kk">
						<option value="<cfoutput>#kk#</cfoutput>" <cfif attributes.sub_pbscode eq kk>selected</cfif>><cfoutput>#kk#</cfoutput>.<cf_get_lang dictionary_id='37450.Kırılımlar'></option>
					</cfloop>
					<option value="-1" <cfif attributes.sub_pbscode eq -1>selected</cfif>><cf_get_lang dictionary_id='37108.Tüm Kırılımlar'></option>
				</select>
			</div>
			<div class="form-group">
				<select name="is_special" id="is_special">
					<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
					<option value="1"<cfif attributes.is_special eq 1>selected</cfif>><cf_get_lang dictionary_id='57979.Özel'></option>
					<option value="0"<cfif attributes.is_special eq 0>selected</cfif>><cf_get_lang dictionary_id='29954.Genel'></option>
				</select>
			</div>
			<div class="form-group">
				<select name="is_statu" id="is_statu">
					<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
					<option value="1"<cfif attributes.is_statu eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					<option value="0"<cfif attributes.is_statu eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
				</select>
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
			</div>
			<div class="form-group"><cf_wrk_search_button button_type="4"></div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='37058.PBS_Kodu'></th>
				<th><cf_get_lang dictionary_id='37088.PBS Kategori'></th>
				<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<th><cf_get_lang dictionary_id='57629.Açıklama'> 2</th>
				<th width="20" class="header_icn_none"> <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_pbs_code&event=add');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_pbs.recordcount>
				<cfoutput query="get_pbs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td><cfif ListLen(pbs_code,".") neq 1>
								<cfloop from="1" to="#ListLen(pbs_code,".")#" index="i"></cfloop>
							</cfif>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_pbs_code&event=upd&pbs_id=#pbs_id#');" class="tableyazi">#pbs_code#</a>
						</td>
						<td>#pbs_cat_name#</td>
						<td>#pbs_detail#</td>
						<td>#pbs_detail2#</td>
						<!-- sil -->
						<td> 
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.list_pbs_code&event=upd&pbs_id=#pbs_id#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
						</td>
						<!-- sil -->
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="6"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfset adres = "product.list_pbs_code">
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		<cfset adres = "#adres#&keyword=#attributes.keyword#">
	</cfif>
	<cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
		<cfset adres = "#adres#&form_submit=#attributes.form_submit#">
	</cfif>
	<cfif isdefined("attributes.is_statu") and len(attributes.is_statu)>
		<cfset adres = "#adres#&is_statu=#attributes.is_statu#">
	</cfif>
	<cfif isdefined("attributes.is_special") and len(attributes.is_special)>
		<cfset adres = "#adres#&is_special=#attributes.is_special#">
	</cfif>
	<cfif isdefined("attributes.pbs_cat_id") and len(attributes.pbs_cat_id)>
		<cfset adres = "#adres#&pbs_cat_id=#attributes.pbs_cat_id#">
	</cfif>
	<cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="#adres#">
</cf_box>
<script type="text/javascript">
    document.getElementById('keyword').focus();
</script>
