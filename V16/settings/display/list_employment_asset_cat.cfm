<cfquery name="CATEGORIES" datasource="#dsn#">
	SELECT 
		#dsn#.Get_Dynamic_Language(SETUP_EMPLOYMENT_ASSET_CAT.ASSET_CAT_ID,'#session.ep.language#','SETUP_EMPLOYMENT_ASSET_CAT','ASSET_CAT',NULL,NULL,SETUP_EMPLOYMENT_ASSET_CAT.ASSET_CAT) AS ASSET_CAT,
		HIERARCHY,
		ASSET_CAT_ID,
		SPECIAL_HIERARCHY
	FROM
		SETUP_EMPLOYMENT_ASSET_CAT 
	ORDER BY		
		HIERARCHY,
		SPECIAL_HIERARCHY,
		ASSET_CAT
</cfquery>
<cfquery name="get_alts" dbtype="query">
	SELECT 
		ASSET_CAT,
		HIERARCHY,
		ASSET_CAT_ID
	FROM 
		categories
	ORDER BY 
		HIERARCHY,
		ASSET_CAT
</cfquery>
<cfquery name="get_upper_cats" dbtype="query">
	SELECT 
		ASSET_CAT,
		HIERARCHY,
		ASSET_CAT_ID
	FROM 
		categories
	WHERE
		HIERARCHY NOT LIKE '%.%'
	ORDER BY 
		HIERARCHY,
		SPECIAL_HIERARCHY,		
		ASSET_CAT
</cfquery>
<table>
	<cfif get_alts.recordcount>
		<cfoutput query="get_alts">
			<tr>
				<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_employment_asset_cat&ID=#get_alts.asset_cat_id#" class="tableyazi">#get_alts.asset_cat#</a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
	 </cfif>
</table>
