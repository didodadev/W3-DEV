<cfquery name="GET_ALL_INVENTORY_CATS" datasource="#DSN3#">
	SELECT
		#dsn#.Get_Dynamic_Language(INVENTORY_CAT_ID,'#session.ep.language#','SETUP_INVENTORY_CAT','INVENTORY_CAT',NULL,NULL,INVENTORY_CAT) AS INVENTORY_CAT,
		*
	FROM
		SETUP_INVENTORY_CAT
	ORDER BY 
		HIERARCHY
</cfquery>
<div class="scrollbar" style="max-height:80vh;overflow:auto;">
<table>
	<cfif get_all_inventory_cats.recordcount>
		<cfoutput query="get_all_inventory_cats">
			<tr>
				<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="380"><cfloop from="1" to="#listlen(hierarchy,'.')#" index="i"></cfloop>
                	<a href="#request.self#?fuseaction=settings.form_upd_inventory_cat&inv_cat_id=#get_all_inventory_cats.inventory_cat_id#" class="tableyazi">#inventory_cat#</a>
                </td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</table>
</div>
