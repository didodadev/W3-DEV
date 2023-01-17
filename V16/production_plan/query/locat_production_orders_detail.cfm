<cfif len(attributes.search_production_result_no)>
	<cfquery name="get_po_result" datasource="#dsn3#">
		SELECT P_ORDER_ID,PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE RESULT_NO ='#attributes.search_production_result_no#'
	</cfquery>
	<cfif get_po_result.recordcount>
		<cflocation url="#request.self#?fuseaction=prod.upd_prod_order_result&p_order_id=#get_po_result.p_order_id#&pr_order_id=#get_po_result.PR_ORDER_ID#" addtoken="no">
	<cfelse>
		<cfquery name="get_po_result_second" datasource="#dsn3#">
			SELECT P_ORDER_ID,PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE RESULT_NO LIKE '%#attributes.search_production_result_no#'
		</cfquery>
		<cfif get_po_result_second.recordcount>
			<cflocation url="#request.self#?fuseaction=prod.upd_prod_order_result&p_order_id=#get_po_result.p_order_id#&pr_order_id=#get_po_result.PR_ORDER_ID#" addtoken="no">
		<cfelse>	
			<script type="text/javascript">
				history.back();
			</script>
		</cfif>
	</cfif>
<cfelse>
	<script type="text/javascript">
		history.back();
	</script>
</cfif>
