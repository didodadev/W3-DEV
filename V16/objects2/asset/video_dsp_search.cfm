<cfquery name="GET_ASSET_CATS" datasource="#DSN#">
	SELECT 
		ASSETCAT_ID,
		ASSETCAT,
		ASSETCAT_PATH
	FROM 
		ASSET_CAT
	WHERE
		<cfif isdefined("session.ww.userid")>
			IS_INTERNET = 1
		<cfelseif isdefined("session.pp.userid")>
			IS_EXTRANET = 1
		<cfelse>
			IS_INTERNET = 1
		</cfif>
	ORDER BY
		ASSETCAT
</cfquery>
<table class="text_table">
	<cfform name="video_search_" method="post" action="#request.self#?fuseaction=objects2.list_videos">
		<tr>
			<td width="60"><cf_get_lang_main no='74.Kategori'></td>
			<td width="150">
				<select name="search_assetcat_id" id="search_assetcat_id" style="width:140px;">
					<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
					<cfoutput query="get_asset_cats"> 
					<option value="#assetcat_id#"<cfif isdefined('attributes.search_assetcat_id') and attributes.search_assetcat_id eq assetcat_id>selected</cfif>>#assetcat#</option>
					</cfoutput> 
				</select>
			</td>
			<td width="90">Anahtar Kelime</td>
			<td width="150">
				<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
					<cfinput type="text" name="keyword" value="#attributes.keyword#">
				<cfelse>
					<cfinput type="text" name="keyword" value="">
				</cfif>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no ='330.Tarih'></td>
			<td nowrap="nowrap">
				<cfif isdefined('attributes.record_date') and len(attributes.record_date)>
					<cfinput type="text" name="record_date" validate="eurodate" value="#attributes.record_date#" style="width:120px;"><cf_wrk_date_image date_field="record_date">
				<cfelse>
					<cfinput type="text" name="record_date" validate="eurodate" value="" style="width:120px;"><cf_wrk_date_image date_field="record_date">
				</cfif>
			</td>
			<td>Kişiler</td>
			<td><cfif isdefined('attributes.add_member') and len(attributes.add_member)>
					<input type="text" name="add_member" id="add_member" style="width:120px;" value="<cfoutput>#attributes.add_member#</cfoutput>" />
				<cfelse>
					<input type="text" name="add_member" id="add_member" style="width:120px;" value="" />
				</cfif>
			</td>
		</tr>
		<tr>
			<td colspan="3"></td>
			<td><input type="submit" name="video_submit" id="video_submit" style="width:120px;" value="<cf_get_lang_main no='153.Ara'>" /></td>
		</tr>
	</cfform>
</table>
