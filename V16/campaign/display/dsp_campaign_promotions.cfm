<cfsetting showdebugoutput="no">
<cfquery name="GET_PROMOTIONS" datasource="#DSN3#">
	SELECT PROM_STATUS,PROM_HEAD,PROM_NO,PROM_ID,PROM_DETAIL,STARTDATE,FINISHDATE,RECORD_EMP,UPDATE_EMP,PROM_RELATION_ID,IS_DETAIL FROM PROMOTIONS WHERE CAMP_ID IS NOT NULL AND CAMP_ID = #attributes.camp_id#
</cfquery>
<table style="text-align:right;">
	<tr>
		<td  colspan="9" style="text-align:right">
		<cfoutput>
						  					  
			
		</cfoutput>
		</td>		
	</tr>
</table>
<cf_grid_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang dictionary_id ='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id ='49584.Promosyon'></th>
			<th><cf_get_lang dictionary_id ='57487.No'></th>
			<th><cf_get_lang dictionary_id ='57771.Detay'></th>
			<th><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></th>
			<th><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></th>
			<th><cf_get_lang dictionary_id ='57756.durum'></th>
			<th><cf_get_lang dictionary_id ='57483.Kayıt'></th>
			<th><cf_get_lang dictionary_id ='57703.Güncelleme'></th>
			<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=product.list_promotions&event=add&camp_id=#attributes.camp_id#</cfoutput>" target="blank_" ><i class="fa fa-plus" alt="<cf_get_lang dictionary_id ='58785.Detaylı'> <cf_get_lang dictionary_id ='49371.Promosyon Ekle'>" title="<cf_get_lang dictionary_id ='58785.Detaylı'> <cf_get_lang dictionary_id ='49371.Promosyon Ekle'>"></i></a></th>
			<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=product.list_promotions&event=addCollacted&camp_id=#attributes.camp_id#</cfoutput>" target="blank_" ><i class="icon-plus-square" alt="<cf_get_lang dictionary_id ='49583.Toplu Promosyon Ekle'>" title="<cf_get_lang dictionary_id ='49583.Toplu Promosyon Ekle'>"></i></a></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_promotions.recordcount GT 0>
		<cfoutput query="GET_PROMOTIONS">
			<tr>		
				<td>#GET_PROMOTIONS.CURRENTROW#</td>
				<td>
					<cfif get_module_user(5)>
						<cfif len(get_promotions.prom_relation_id)>
							<a class="tableyazi" onClick="windowopen('#request.self#?fuseaction=product.list_promotions&event=updCollacted&prom_rel_id=#prom_relation_id#','wide');" style="cursor:pointer;">#GET_PROMOTIONS.PROM_HEAD#</a>
						<cfelseif len(get_promotions.is_detail) and get_promotions.is_detail eq 1>
							<a class="tableyazi" onClick="windowopen('#request.self#?fuseaction=product.form_upd_detail_prom&prom_id=#prom_id#','wide');" style="cursor:pointer;">#GET_PROMOTIONS.PROM_HEAD#</a>
						<cfelse>
							<a class="tableyazi" onClick="windowopen('#request.self#?fuseaction=product.form_upd_prom&prom_id=#prom_id#','wide');" style="cursor:pointer;">#GET_PROMOTIONS.PROM_HEAD#</a>
						</cfif>
					<cfelse>
						#GET_PROMOTIONS.PROM_HEAD#
					</cfif>
				</td>
				<td>#GET_PROMOTIONS.PROM_NO#</td>
				<td>#GET_PROMOTIONS.PROM_DETAIL#</td>
				<td>#DateFormat(GET_PROMOTIONS.STARTDATE,dateformat_style)#</td>
				<td>#DateFormat(GET_PROMOTIONS.FINISHDATE,dateformat_style)#</td>
				<td><cfif prom_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
				<td>#get_emp_info(GET_PROMOTIONS.RECORD_EMP,0,0)#</td>
				<td>#get_emp_info(GET_PROMOTIONS.UPDATE_EMP,0,0)#</td>
				<td colspan="2"></td>
			</tr>
		</cfoutput>
		<cfelse>
		<tr>
			<td colspan="11"><cf_get_lang dictionary_id ='57484.Kayıt Yok'> !</td>
		</tr>
		</cfif>
	</tbody>
</cf_grid_list>
