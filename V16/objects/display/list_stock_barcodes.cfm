<cfquery name="STOCKS_BARCODE" datasource="#dsn1#">
	SELECT BARCOD FROM STOCKS WHERE STOCK_ID=#attributes.STOCK_ID#
</cfquery>
<cfparam  name="attributes.modal_id" default="1">
<cfquery name="STOCKS_BARCODES" datasource="#dsn1#">
	SELECT
		BARCODE,
		PU.MAIN_UNIT,
		PU.ADD_UNIT
	FROM
		PRODUCT_UNIT PU,
		STOCKS_BARCODES SB
	WHERE
		PU.PRODUCT_UNIT_ID = SB.UNIT_ID AND
		STOCK_ID=#attributes.STOCK_ID#
		<!---  AND BARCODE<>'#STOCKS_BARCODE.BARCOD#' --->
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_grid_list>
		<thead>
			<tr>
				<th colspan="2"><cf_get_lang dictionary_id='32821.Diğer Barkodları'></th>
				<th><cf_get_lang dictionary_id='57636.Birim'></th>
			</tr>
		</thead>
		<tbody>
			<cfif (STOCKS_BARCODES.recordcount) or (STOCKS_BARCODE.recordcount)>
				<cfoutput query="STOCKS_BARCODE">
					<tr>
						<td width="20"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_barcode&barcod=#BARCOD#&is_terazi=#attributes.is_terazi#','#attributes.modal_id#','','ui-draggable-box-small' )"><i class="fa fa-barcode"   border="0"></i></a></td>
						<td>#BARCOD#</td>
						<td>&nbsp;</td>
					</tr>
				</cfoutput>
				<cfoutput query="STOCKS_BARCODES">
					<tr>
						<td width="20"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_barcode&barcod=#BARCODE#&is_terazi=#attributes.is_terazi#','#attributes.modal_id#','','ui-draggable-box-small')"><i class="fa fa-barcode"  border="0"></i></a></td>
						<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_upd_stock_barcode&barcode=#BARCODE#&is_terazi=#attributes.is_terazi#','#attributes.modal_id#')" >#BARCODE#</a></td>
						<td>#ADD_UNIT#&nbsp;</td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
</div>