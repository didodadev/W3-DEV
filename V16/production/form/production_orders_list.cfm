<!--- üretim emirleri ---><!--- düzenleme yapılacak. wrk_row_idyle --->
<cfsetting showdebugoutput="no">
<cfquery name="get_order_list" datasource="#dsn3#">
	SELECT DISTINCT
		POO.P_ORDER_ID,
		PO.P_ORDER_NO,
		S.PRODUCT_NAME
	FROM
		PRODUCTION_ORDERS PO,
		STOCKS S,
		PRODUCTION_ORDER_OPERATIONS POO
	WHERE
		PO.P_ORDER_ID = POO.P_ORDER_ID AND
		POO.RECORD_EMP = #session.ep.userid# AND
		S.STOCK_ID = PO.STOCK_ID AND
		PO.P_ORDER_ID NOT IN (
								SELECT 
									POR.P_ORDER_ID
								FROM 
									PRODUCTION_ORDER_RESULTS POR,
									PRODUCTION_ORDER_RESULTS_ROW PORR
								WHERE
									POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
									POR.P_ORDER_ID = PO.P_ORDER_ID AND
									PORR.TYPE = 1 AND
									PORR.STOCK_ID = PO.STOCK_ID
								GROUP BY
									POR.P_ORDER_ID
								HAVING
									SUM(PORR.AMOUNT) = PO.QUANTITY
						) AND
		POO.WRK_ROW_ID NOT IN (SELECT WRK_ROW_ID FROM PRODUCTION_ORDER_OPERATIONS WHERE TYPE = 2) AND
		POO.TYPE <> 2
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='38091.Üretim Emirleri'></cfsavecontent>
<cf_box title="#message#" closable=1 collapsed=1 popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_box_elements border="0" width="300" cellpadding="2" cellspacing="1">
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<div>
				<label><cf_get_lang dictionary_id="30049.Üretim Emri"></label>
				<label><cf_get_lang dictionary_id="49884.Üretim Emri"></label>
			</div>
			<cfoutput query="get_order_list">
				<div >
					<div><a href="#request.self#?fuseaction=production.form_add_production_order&upd=#p_order_id#" class="tableyazi">#P_ORDER_NO#</a></div>
					<div>#PRODUCT_NAME#</div>
				</div>
			</cfoutput>
		</div>
		
	</cf_box_elements>
</cf_box>