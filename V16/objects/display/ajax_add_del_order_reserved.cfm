<cfsetting showdebugoutput="no">
<script type="text/javascript">
	document.getElementById('_detailss_<cfoutput>#attributes.CRNT_ROW#</cfoutput>').style.display ='none';
</script>
<cfif isdefined('attributes.type') and attributes.type is 'del'>
	<!--- satır iptal sipariş satırına kaydediliyor --->
	<cfquery name="UPD_ORDER_ROW" datasource="#dsn3#">
		UPDATE
			ORDER_ROW
		SET
		<cfif isdefined('attributes.cancel_type_') and len(attributes.cancel_type_)>
			CANCEL_TYPE_ID = #attributes.cancel_type_#
		<cfelse>
			CANCEL_TYPE_ID = NULL
		</cfif>
		<cfif isdefined('attributes.c_amount') and len(attributes.c_amount)>
			,CANCEL_AMOUNT = #attributes.c_amount#
		</cfif>
		WHERE
			ORDER_ID = #attributes.R_ORDER_ID# AND 
			WRK_ROW_ID = '#attributes.wrk_row_id#' AND
			STOCK_ID = #attributes.R_STOCK_ID#
	</cfquery>
</cfif>
<cfif isdefined('attributes.R_AMOUNT') and len(attributes.R_AMOUNT) gt 0 or isdefined('attributes.c_amount') and len(attributes.c_amount)>
	<cfscript>
		add_reserve_row
		(
			reserve_wrk_row_id: attributes.wrk_row_id,
			reserve_order_id : attributes.R_ORDER_ID,
			reserve_product_id :attributes.R_PRODUCT_ID,
			reserve_stock_id :attributes.R_STOCK_ID ,
			reserve_spect_id : attributes.R_SPECT_ID,
			reserve_amount : iif((len(attributes.R_AMOUNT)),de('#attributes.R_AMOUNT#'),de('0')),
			cancel_amount : iif((isdefined('attributes.c_amount') and len(attributes.c_amount)),de('#attributes.c_amount#'),de('')),
			is_order_process :3,
			is_purchase_sales : attributes.IS_PURCHASE_SALES,
			reserve_action_type:iif((attributes.type is 'del'),3,0)
		);
	</cfscript>
	<cfif isdefined('attributes.type') and attributes.type is 'del'>
		<cfquery name="get_row_amount" datasource="#dsn3#">
			SELECT QUANTITY AMOUNT FROM ORDER_ROW WHERE ORDER_ID=#attributes.R_ORDER_ID# AND WRK_ROW_ID='#attributes.wrk_row_id#' AND STOCK_ID=#attributes.R_STOCK_ID#
		</cfquery>
		<!--- satır iptal sipariş satırına kaydediliyor --->
		<cfquery name="UPD_ORDER_ROW" datasource="#dsn3#">
			UPDATE
				ORDER_ROW
			SET
			<cfif isdefined('attributes.c_amount') and len(attributes.c_amount)>
				<cfif isdefined('attributes.pro_amount_') and len(attributes.pro_amount_) and get_row_amount.recordcount and (attributes.pro_amount_ + attributes.c_amount) eq get_row_amount.amount>
				ORDER_ROW_CURRENCY= - 9
				<cfelseif isdefined('attributes.pro_amount_') and len(attributes.pro_amount_) and get_row_amount.recordcount and (attributes.pro_amount_ + attributes.c_amount) lt get_row_amount.amount>
				ORDER_ROW_CURRENCY= - 6	
				</cfif>
			</cfif>
			WHERE
				ORDER_ID = #attributes.R_ORDER_ID# AND 
				WRK_ROW_ID = '#attributes.wrk_row_id#' AND 
				STOCK_ID = #attributes.R_STOCK_ID#
		</cfquery>
	</cfif>
	<script type="text/javascript">
		var kalan = eval('document.all.__kalan__'+<cfoutput>'#attributes.CRNT_ROW#'</cfoutput>).value;
		var rezerve_edilen =eval('document.all.rezerve_edilen_' + <cfoutput>'#attributes.CRNT_ROW#'</cfoutput>).value ;
			if(<cfoutput>#attributes.R_AMOUNT# <= #max_reserve_amount#</cfoutput>)
		{
			 if(<cfoutput>'#attributes.CRNT_ROW#' <= '#max_reserve_amount#'</cfoutput> == "")
				{var max_reserve_amount = 0 ;}
			else
				{var max_reserve_amount = <cfoutput>'#max_reserve_amount#'</cfoutput> ;}
			if(<cfoutput>'#attributes.type#'</cfoutput> == 'add'  <!--- || <cfoutput>'#attributes.event#'</cfoutput> == 'add'----->)
			{
				eval('document.all.rezerve_edilen_'+<cfoutput>'#attributes.CRNT_ROW#'</cfoutput>).value = parseFloat(rezerve_edilen)+parseFloat(<cfoutput>#attributes.R_AMOUNT#</cfoutput>)
				eval('document.all.kalan_'+<cfoutput>'#attributes.CRNT_ROW#'</cfoutput>).value = parseFloat(kalan)-parseFloat(<cfoutput>#attributes.R_AMOUNT#</cfoutput>)
				eval('document.all.__kalan__'+<cfoutput>'#attributes.CRNT_ROW#'</cfoutput>).value = eval('document.all.kalan_'+<cfoutput>'#attributes.CRNT_ROW#'</cfoutput>).value;
			}
			else
			{
				eval('document.all.rezerve_edilen_'+<cfoutput>'#attributes.CRNT_ROW#'</cfoutput>).value = parseFloat(rezerve_edilen)-parseFloat(<cfoutput>#attributes.R_AMOUNT#</cfoutput>)
				eval('document.all.kalan_'+<cfoutput>'#attributes.CRNT_ROW#'</cfoutput>).value = parseFloat(kalan)+parseFloat(<cfoutput>#attributes.R_AMOUNT#</cfoutput>)
				eval('document.all.__kalan__'+<cfoutput>'#attributes.CRNT_ROW#'</cfoutput>).value = eval('document.all.kalan_'+<cfoutput>'#attributes.CRNT_ROW#'</cfoutput>).value;
			}
		}
	</script>
</cfif>
