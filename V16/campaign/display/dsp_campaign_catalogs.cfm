<cfsetting showdebugoutput="no">
<cfquery name="GET_ACTIONS" datasource="#DSN3#">
	SELECT CATALOG_STATUS,CATALOG_HEAD,CATALOG_ID,CAT_PROM_NO,CATALOG_DETAIL,STARTDATE,FINISHDATE,RECORD_EMP,UPDATE_EMP FROM CATALOG_PROMOTION WHERE CAMP_ID IS NOT NULL AND CAMP_ID= #attributes.camp_id#
</cfquery>
<cf_grid_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang dictionary_id ='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='49586.Aksiyon'></th>
			<th><cf_get_lang dictionary_id ='57487.No'></th>
			<th><cf_get_lang dictionary_id ='57771.Detay'></th>
			<th><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></th>
			<th><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></th>
			<th><cf_get_lang dictionary_id ='57756.durum'></th>
			<th><cf_get_lang dictionary_id ='57483.Kayıt'></th>
			<th><cf_get_lang dictionary_id ='57703.Güncelleme'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_actions.recordcount GT 0>
		<cfoutput query="GET_ACTIONS">
			<tr>		
				<td>#GET_ACTIONS.CURRENTROW#</td>
				<cfif get_module_user(5)>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.list_catalog_promotion&event=upd&id=#catalog_id#','wide');" style="cursor:pointer;">#GET_ACTIONS.CATALOG_HEAD#</a></td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.list_catalog_promotion&event=upd&id=#catalog_id#','wide');" style="cursor:pointer;">#GET_ACTIONS.CAT_PROM_NO#</a></td>
				<cfelse>
					<td>#GET_ACTIONS.CATALOG_HEAD#</td>
					<td>#GET_ACTIONS.CAT_PROM_NO#</td>	
				</cfif>
				<td>#GET_ACTIONS.CATALOG_DETAIL#</td>
				<td>#DateFormat(GET_ACTIONS.STARTDATE,'DD:MM:YYYY')#</td>
				<td>#DateFormat(GET_ACTIONS.FINISHDATE,'DD:MM:YYYY')#</td>
				<td><cfif catalog_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
				<td>#get_emp_info(GET_ACTIONS.RECORD_EMP,0,0)#</td>
				<td>#get_emp_info(GET_ACTIONS.UPDATE_EMP,0,0)#</td>
			</tr>
		</cfoutput>
		<cfelse>
			<tr>
				<td colspan="9"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_grid_list>	
