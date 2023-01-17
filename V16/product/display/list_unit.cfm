<cfquery name="GET_SETUP_UNIT" datasource="#DSN#">
  	SELECT 
		#dsn#.Get_Dynamic_Language(UNIT_ID,'#session.ep.language#','SETUP_UNIT','UNIT',NULL,NULL,UNIT) AS UNIT,
		UNIT_ID,
		#dsn#.Get_Dynamic_Language(UNIT_ID,'#session.ep.language#','SETUP_UNIT','UNECE_NAME',NULL,NULL,UNECE_NAME) AS UNECE_NAME,
		UNIT_CODE 
	FROM 
		SETUP_UNIT
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='37031.Birimler'></cfsavecontent>
	<cf_box title="#title#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sira'></th>
					<th><cf_get_lang dictionary_id='57636.Birim'></th>
					<th><cf_get_lang dictionary_id='59289.UNECE standardı'></th>
					<th><cf_get_lang dictionary_id='51014.UNECE Kodu'> </th>
					<th class="header_icn_none text-center" width="20"><cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.list_unit&event=add','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='37032.Birim Ekle'>"></i></a></cfoutput></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_setup_unit.recordcount>
					<cfoutput query="get_setup_unit">
						<tr>
							<td>#currentrow#</td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.list_unit&event=upd&ID=#unit_ID#','medium');" clasS="tableyazi">#unit#</a></td>
							<td>#unece_name#</td>
							<td>#unit_code#</td>
							<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.list_unit&event=upd&ID=#unit_ID#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='37197.Birim Güncelle'>"></i></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>