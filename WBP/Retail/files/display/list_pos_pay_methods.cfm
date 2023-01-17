<cfquery name="get_types" datasource="#dsn_dev#">
	SELECT * FROM SETUP_POS_PAYMETHODS ORDER BY CAST(CODE AS INTEGER) ASC 
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id='61487.Ödeme Tipleri'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr> 
					<th ><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th ><cf_get_lang dictionary_id='58585.Kod'></th>
					<th><cf_get_lang dictionary_id='36199.Açıklama'></th>
					<th width="20"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.list_pos_pay_methods&event=add</cfoutput>','list');"><i class="fa fa-plus"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_types.recordcount>
					<cfoutput query="get_types">
						<tr>
							<td>#currentrow#</td>
							<td>#CODE#</td>
							<td>#header#</td>
							<td>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.list_pos_pay_methods&event=upd&row_id=#row_id#','list');"><i class="fa fa-pencil"></i></a>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.list_pos_pay_methods&event=copy&row_id=#row_id#','list');"/><img src="/images/transfer.gif" /></a>
							</td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr>
						<td colspan="4"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>

</div>

