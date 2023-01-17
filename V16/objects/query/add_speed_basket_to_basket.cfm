<cfsetting showdebugoutput="no">
<cfquery name="GET_PRODUCT_" datasource="#dsn3#">
	SELECT
		SUM(OPR.QUANTITY) AS MIKTAR,
		OPR.PRODUCT_ID,
		OPR.STOCK_ID,
		OPR.PRODUCT_NAME,
		S.STOCK_CODE,
		S.BARCOD,
		S.MANUFACT_CODE,
		PU.MAIN_UNIT AS UNIT,
		PU.MAIN_UNIT_ID AS UNIT_ID
	FROM
		#dsn_alias#.ORDER_PRE_ROWS AS OPR,
		STOCKS S,
		PRODUCT_UNIT PU
	WHERE
		S.PRODUCT_STATUS = 1 AND
		S.STOCK_STATUS = 1 AND
		PU.IS_MAIN = 1 AND
		S.PRODUCT_UNIT_ID = PU.PRODUCT_UNIT_ID AND
		S.STOCK_ID = OPR.STOCK_ID AND
		OPR.EMPLOYEE_ID = #session.ep.userid#
		<cfif isdefined("attributes.stock_list") and listlen(attributes.stock_list)>
			AND OPR.STOCK_ID IN (#attributes.stock_list#)
		</cfif>
	GROUP BY
		OPR.PRODUCT_ID,
		OPR.STOCK_ID,
		OPR.PRODUCT_NAME,
		S.STOCK_CODE,
		S.BARCOD,
		S.MANUFACT_CODE,
		PU.MAIN_UNIT,
		PU.MAIN_UNIT_ID
</cfquery>
<cfoutput query="get_product_">
	<cfset amount_ = evaluate("attributes.amount_#stock_id#")>
	<script type="text/javascript">
		toplam_hesap=<cfif currentrow eq get_product_.recordcount>1<cfelse>0</cfif>;
		opener.add_basket_row('#product_id#', '#stock_id#', '#stock_code#', '#barcod#', '#manufact_code#', '#PRODUCT_NAME#', '#unit_id#', '#unit#', '', '', '0','0','0','','0','0','0','0','0','0','0','0','0','0','','','','','TL','','#amount_#','',0,0,0,'#TLFormat(0)#','#wrk_round(0,4)#','','','0','0','0','','0','','','','','','','',toplam_hesap,'0','','','','','0','','','','','','','','','','','','','',0,'','');
	</script>
</cfoutput>
<script type="text/javascript">
	window.location.href='<cfoutput>#request.self#?fuseaction=objects.popup_list_speed_basket</cfoutput>';
</script>

