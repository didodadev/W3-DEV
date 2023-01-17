<cf_catalystHeader>
<cfquery name="get_row" datasource="#dsn_dev#">
	SELECT
		SCOR.*,
        L1.PROPERTY
	FROM 
		STOCK_COUNT_ORDERS_ROWS SCOR
        	LEFT JOIN 
            	(
                	SELECT
                    	S.STOCK_CODE PROPERTY,
                        SB.BARCODE
                    FROM
                    	#dsn1_alias#.STOCKS S,
                        #dsn1_alias#.STOCKS_BARCODES SB
                    WHERE
                    	S.STOCK_ID = SB.STOCK_ID
                ) L1 ON L1.BARCODE = SCOR.BARCODE
	WHERE	
        SCOR.ROW_ID = #attributes.row_id#
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_form" action="">
			<cfinput type="hidden" name="row_id" value="#attributes.row_id#">
			<cfoutput query="get_row">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-promotion_head">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57633.Barkod'></label>
							<div class="col col-8 col-sm-12">
								<input type="text" name="barcode" value="#BARCODE#" style="width:100px;"/>
							</div>
						</div>
						<div class="form-group" id="item-promotion_head">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57452.Stok'></label>
							<div class="col col-8 col-sm-12">
								<input type="text" value="#property#" style="width:300px;" readonly="readonly"/>
							</div>
						</div>
						<div class="form-group" id="item-promotion_head">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
							<div class="col col-8 col-sm-12">
								<cfinput type="text" name="amount" value="#tlformat(amount)#" style="width:100px;" required="yes" message="Miktar Girmelisiniz!" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));"/>
							</div>
						</div>
					</div>
				</cf_box_elements>
			</cfoutput>
			<cf_box_footer>
				<cf_workcube_buttons is_upd="1" delete_page_url="#request.self#?fuseaction=retail.list_stock_count_orders_rows&event=del&row_id=#attributes.row_id#">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
