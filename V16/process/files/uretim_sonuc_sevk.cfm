<!---  .Acik ve uretimde olanlari sevk asamasina getirecek digerlerini getirmeyecek !! --->
<cfif isdefined("caller.p_order_id")>
	<cfquery name="GET_ROWS" datasource="#attributes.data_source#">
	SELECT
		 ORDER_ROW_ID
	FROM
		 #caller.dsn3_alias#.PRODUCTION_ORDERS_ROW
	WHERE
		PRODUCTION_ORDER_ID = #caller.p_order_id#
	</cfquery>
	<cfoutput query="get_rows">
		 <cfquery name="UPDATE_ORDER_ROW" datasource="#attributes.data_source#">
			   UPDATE
					 #caller.dsn3_alias#.ORDER_ROW
			   SET
				  ORDER_ROW_CURRENCY = -6
			 WHERE
				   ORDER_ROW_ID = #get_rows.order_row_id# AND
				   (ORDER_ROW_CURRENCY = -5  OR ORDER_ROW_CURRENCY = -1)
		</cfquery>
	</cfoutput>
</cfif>












































