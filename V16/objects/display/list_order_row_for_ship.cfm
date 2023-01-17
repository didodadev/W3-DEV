<!--- faturaya irsaliye seçme popupında belgenin urunlerini listeyerek seçim yapmak için kullanılıyor. --->
<cfsetting showdebugoutput="no">
<cfif not (isdefined("attributes.order_id_") and isnumeric(attributes.order_id_))>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='60010.Sipariş Seçiniz'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_ORDER_ROW_INFO#attributes.form_crntrow#" datasource="#dsn3#">
	SELECT	
		ORR.QUANTITY AS QUANTITY,
		ISNULL(ORR.CANCEL_AMOUNT,0) AS CANCEL_AMOUNT,
		ISNULL(ORR.WRK_ROW_ID,0) AS WRK_ROW_ID,
		ORD.ORDER_ID,
		ORD.ORDER_NUMBER,
		ORD.ORDER_DATE,
		ORD.COMPANY_ID,
		ORD.CONSUMER_ID,
		ORD.PURCHASE_SALES,
		ORD.ORDER_ZONE,
		ORR.ORDER_ROW_ID,
		ORR.DELIVER_DATE,
		ORR.PRODUCT_ID,
		ORR.STOCK_ID,
		ORR.ORDER_ROW_CURRENCY,
		ORR.RESERVE_TYPE,
		<cfif isdefined('attributes.is_purchase') and attributes.is_purchase eq 1>
		ORD_R.DEPARTMENT_ID AS DELIVER_DEPT,
		<cfelse>
		ORR.DELIVER_DEPT,
		</cfif>
		ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = ORR.SPECT_VAR_ID),0) AS SPECT_VAR_ID,
		S.STOCK_CODE,
		S.PRODUCT_NAME,
		S.PRODUCT_CODE_2,
		ISNULL(S.PROPERTY,'') PROPERTY,
		ORR.SPECT_VAR_NAME
	FROM
		ORDERS ORD,
		ORDER_ROW ORR,
		<cfif isdefined('attributes.is_purchase') and attributes.is_purchase eq 1>
		ORDER_ROW_DEPARTMENTS ORD_R,
		</cfif>
		STOCKS S
	WHERE
		ORD.ORDER_ID=ORR.ORDER_ID
		<cfif isdefined('attributes.is_purchase') and attributes.is_purchase eq 1>
		AND ORR.ORDER_ROW_ID=ORD_R.ORDER_ROW_ID
		</cfif>
		AND ORR.STOCK_ID = S.STOCK_ID
		AND ORD.ORDER_ID = #attributes.order_id_#
	ORDER BY
		ORR.ORDER_ROW_ID
</cfquery>
<cfset q_name="GET_ORDER_ROW_INFO#attributes.form_crntrow#">
<cfif evaluate("#q_name#.recordcount")>
<!--- rezerve --->
	<cfquery name="get_reserved_info" datasource="#dsn3#">
		SELECT
			SUM(RESERVED_AMOUNT) RESERVED_AMOUNT,
			STOCK_ID,
			PRODUCT_ID,
			SPECT_VAR_ID
		FROM
		(
			SELECT
				abs(SUM((RESERVE_STOCK_IN-STOCK_IN)-(RESERVE_STOCK_OUT-STOCK_OUT))) AS RESERVED_AMOUNT,
				STOCK_ID,
				PRODUCT_ID,
				ISNULL((SELECT SP.SPECT_MAIN_ID FROM SPECTS SP WHERE SP.SPECT_VAR_ID = GET_ORDER_ROW_RESERVED.SPECT_VAR_ID),0) AS SPECT_VAR_ID
			FROM
				GET_ORDER_ROW_RESERVED
			WHERE
				ORDER_ID = #attributes.order_id_#
			GROUP BY
				PRODUCT_ID,
				STOCK_ID,
				SPECT_VAR_ID
		)T1
		GROUP BY
			PRODUCT_ID,
			STOCK_ID,
			SPECT_VAR_ID
		ORDER BY STOCK_ID
	</cfquery>
	<cfquery name="get_order_inv_periods" datasource="#dsn3#">
		SELECT DISTINCT PERIOD_ID FROM ORDERS_INVOICE WHERE ORDER_ID =#attributes.order_id_#
	</cfquery>
	<cfif get_order_inv_periods.recordcount>
		<cfset orders_ship_period_list = valuelist(get_order_inv_periods.PERIOD_ID)>
		<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
			<cfquery name="get_processed_amount" datasource="#dsn2#">
				SELECT
					SUM(SHIP_AMOUNT) SHIP_AMOUNT,
					STOCK_ID,
					SPECT_VAR_ID,
					WRK_ROW_RELATION_ID
				FROM
				(
					SELECT
						SUM(IR.AMOUNT) AS SHIP_AMOUNT,
						IR.STOCK_ID,
						ISNULL((SELECT SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS SPECT_VAR_ID,
						ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
					FROM
						INVOICE I,
						INVOICE_ROW IR
					WHERE
						I.INVOICE_ID=IR.INVOICE_ID
						AND IR.ORDER_ID=#attributes.order_id_#
					GROUP BY
						IR.STOCK_ID,
						IR.SPECT_VAR_ID,
						ISNULL(IR.WRK_ROW_RELATION_ID,0)
				)T1
				GROUP BY
					STOCK_ID,
					SPECT_VAR_ID,
					WRK_ROW_RELATION_ID
			</cfquery>
		<cfelse>
			<cfquery name="get_period_dsns" datasource="#dsn#">
				SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
			</cfquery>
			<cfquery name="get_processed_amount" datasource="#dsn2#">
				SELECT
					SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
					A1.STOCK_ID,
					A1.SPECT_VAR_ID,
					A1.WRK_ROW_RELATION_ID
				FROM
				(
				<cfloop query="get_period_dsns">
					SELECT
						SUM(IR.AMOUNT) AS SHIP_AMOUNT,
						IR.STOCK_ID,
						ISNULL((SELECT SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = IR.SPECT_VAR_ID),0) AS SPECT_VAR_ID,
						ISNULL(IR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
					FROM
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE I,
						#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.INVOICE_ROW IR
					WHERE
						I.INVOICE_ID=IR.INVOICE_ID
						AND IR.ORDER_ID=#attributes.order_id_#
					GROUP BY
						IR.STOCK_ID,
						IR.SPECT_VAR_ID,
						ISNULL(IR.WRK_ROW_RELATION_ID,0)
					<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
				</cfloop> ) AS A1
					GROUP BY
						A1.STOCK_ID,
						A1.SPECT_VAR_ID,
						A1.WRK_ROW_RELATION_ID
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery name="get_order_ship_periods" datasource="#dsn3#">
			SELECT DISTINCT PERIOD_ID FROM ORDERS_SHIP WHERE ORDER_ID =#attributes.order_id_#
		</cfquery>
		<cfif get_order_ship_periods.recordcount>
			<cfset orders_ship_period_list = valuelist(get_order_ship_periods.PERIOD_ID)>
			<cfif listlen(orders_ship_period_list) eq 1 and orders_ship_period_list eq session.ep.period_id>
				<cfquery name="get_processed_amount" datasource="#dsn2#">
					SELECT
						SUM(SHIP_AMOUNT) SHIP_AMOUNT,
						STOCK_ID,
						SPECT_VAR_ID,
						WRK_ROW_RELATION_ID
					FROM
					(
						SELECT
							SUM(SR.AMOUNT) AS SHIP_AMOUNT,
							SR.STOCK_ID,
							ISNULL((SELECT SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = SR.SPECT_VAR_ID),0) AS SPECT_VAR_ID,
							ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID 
						FROM
							SHIP S,
							SHIP_ROW SR
						WHERE
							S.SHIP_ID=SR.SHIP_ID
							AND SR.ROW_ORDER_ID=#attributes.order_id_#
						GROUP BY
							SR.STOCK_ID,
							SR.SPECT_VAR_ID,
							ISNULL(SR.WRK_ROW_RELATION_ID,0)
					)T1
					GROUP BY
						STOCK_ID,
						SPECT_VAR_ID,
						WRK_ROW_RELATION_ID
				</cfquery>
				<cfquery name="get_processed_amount_iade" datasource="#dsn2#">
					SELECT
						SUM(SHIP_AMOUNT) SHIP_AMOUNT,
						STOCK_ID,
						SPECT_VAR_ID,
						WRK_ROW_RELATION_ID
					FROM
					(
						SELECT
							SUM(SRR.AMOUNT) AS SHIP_AMOUNT,
							SR.STOCK_ID,
							ISNULL((SELECT SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = SR.SPECT_VAR_ID),0) AS SPECT_VAR_ID,
							ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID 
						FROM
							SHIP S,
							SHIP_ROW SR,
							SHIP_ROW SRR
						WHERE
							S.SHIP_ID=SRR.SHIP_ID
							AND SR.ROW_ORDER_ID=#attributes.order_id_#
							AND SR.WRK_ROW_ID=SRR.WRK_ROW_RELATION_ID
							AND S.SHIP_TYPE <> 81 <!--- İade İşlemlerinden sonra Depolararası Sevk İrsaliyeleri mevcut stokları yükseltiyordu. EY20141611 --->
						GROUP BY
							SR.STOCK_ID,
							SR.SPECT_VAR_ID,
							ISNULL(SR.WRK_ROW_RELATION_ID,0)
					)T1
					GROUP BY
						STOCK_ID,
						SPECT_VAR_ID,
						WRK_ROW_RELATION_ID
				</cfquery>
			<cfelse>
				<!--- 5. siparis farklı periyotlardaki irsaliyelerle iliskili --->
				<cfquery name="get_period_dsns" datasource="#dsn2#">
					SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM #dsn_alias#.SETUP_PERIOD WHERE PERIOD_ID IN (#orders_ship_period_list#)
				</cfquery>
				<cfquery name="get_processed_amount" datasource="#dsn2#">
					SELECT
						SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
						A1.STOCK_ID,
						A1.SPECT_VAR_ID,
						A1.WRK_ROW_RELATION_ID
					FROM
					(
					<cfloop query="get_period_dsns">
						SELECT
							SUM(SR.AMOUNT) AS SHIP_AMOUNT,
							SR.STOCK_ID,
							ISNULL((SELECT SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = SR.SPECT_VAR_ID),0) AS SPECT_VAR_ID,
							ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
						FROM
							#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
							#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR
						WHERE
							S.SHIP_ID=SR.SHIP_ID
							AND SR.ROW_ORDER_ID=#attributes.order_id_#
						GROUP BY
							SR.STOCK_ID,
							SR.SPECT_VAR_ID,
							ISNULL(SR.WRK_ROW_RELATION_ID,0)
						<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
					</cfloop> ) AS A1
						GROUP BY
							A1.STOCK_ID,
							A1.SPECT_VAR_ID,
							A1.WRK_ROW_RELATION_ID
				</cfquery>
				<cfquery name="get_processed_amount_iade" datasource="#dsn2#">
					SELECT
						SUM(A1.SHIP_AMOUNT) AS SHIP_AMOUNT,
						A1.STOCK_ID,
						A1.SPECT_VAR_ID,
						A1.WRK_ROW_RELATION_ID
					FROM
					(
					<cfloop query="get_period_dsns">
						SELECT
							SUM(SRR.AMOUNT) AS SHIP_AMOUNT,
							SR.STOCK_ID,
							ISNULL((SELECT SP.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SP WHERE SP.SPECT_VAR_ID = SR.SPECT_VAR_ID),0) AS SPECT_VAR_ID,
							ISNULL(SR.WRK_ROW_RELATION_ID,0) AS WRK_ROW_RELATION_ID
						FROM
							#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP S,
							#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SR,
							#dsn#_#get_period_dsns.PERIOD_YEAR#_#get_period_dsns.OUR_COMPANY_ID#.SHIP_ROW SRR
						WHERE
							S.SHIP_ID=SRR.SHIP_ID
							AND SR.ROW_ORDER_ID=#attributes.order_id_#
							AND SR.WRK_ROW_ID=SRR.WRK_ROW_RELATION_ID
						GROUP BY
							SR.STOCK_ID,
							SR.SPECT_VAR_ID,
							ISNULL(SR.WRK_ROW_RELATION_ID,0)
						<cfif currentrow neq get_period_dsns.recordcount> UNION ALL </cfif>					
					</cfloop> ) AS A1
						GROUP BY
							A1.STOCK_ID,
							A1.SPECT_VAR_ID,
							A1.WRK_ROW_RELATION_ID
				</cfquery>
			</cfif>
		<cfelse>
			<cfset get_order_ship_periods.recordcount =0>
		</cfif>
	</cfif>
	<cfscript>
		for(inv_k=1; inv_k lte get_reserved_info.recordcount; inv_k=inv_k+1)
			'reserved_amount_#get_reserved_info.STOCK_ID[inv_k]#_#get_reserved_info.SPECT_VAR_ID[inv_k]#' = get_reserved_info.RESERVED_AMOUNT[inv_k];
		if(isdefined("get_processed_amount"))
			for(xxx=1; xxx lte get_processed_amount.recordcount; xxx=xxx+1)
			{
				if(len(get_processed_amount.WRK_ROW_RELATION_ID[xxx]) and get_processed_amount.WRK_ROW_RELATION_ID[xxx] neq 0)
					'row_processed_amount_#get_processed_amount.WRK_ROW_RELATION_ID[xxx]#' = get_processed_amount.SHIP_AMOUNT[xxx];
				else
					'processed_amount_#get_processed_amount.STOCK_ID[xxx]#_#get_processed_amount.SPECT_VAR_ID[xxx]#' = get_processed_amount.SHIP_AMOUNT[xxx];
			}
		if(isdefined("get_processed_amount_iade"))
			for(xxx=1; xxx lte get_processed_amount_iade.recordcount; xxx=xxx+1)
			{
				if(len(get_processed_amount_iade.WRK_ROW_RELATION_ID[xxx]) and get_processed_amount_iade.WRK_ROW_RELATION_ID[xxx] neq 0)
					'row_processed_amount_iade_#get_processed_amount_iade.WRK_ROW_RELATION_ID[xxx]#' = get_processed_amount_iade.SHIP_AMOUNT[xxx];
				else
					'row_processed_amount_iade_#get_processed_amount_iade.STOCK_ID[xxx]#_#get_processed_amount_iade.SPECT_VAR_ID[xxx]#' = get_processed_amount_iade.SHIP_AMOUNT[xxx];
			}
	</cfscript>
<cfelse>
	<cfset get_all_ship_amount.recordcount=0>
</cfif>
<form name="<cfoutput>ship_detail_#attributes.form_crntrow#</cfoutput>" action="<cfoutput>#request.self#?fuseaction=objects.popup_add_order_to_ship</cfoutput>" method="post">
	<cf_ajax_list>
        <tr height="25">
            <td class="formbold" colspan="14"><cfoutput>#evaluate("#q_name#.ORDER_NUMBER")#</cfoutput> Nolu Sipariş Ürünleri</td>
        </tr>
        <tr class="color-list">
            <td class="txtboldblue"><cf_get_lang dictionary_id='57518.Stok Kodu'></td>          
            <cfif isDefined("x_show_product_code_2") and x_show_product_code_2 eq 1><td class="txtboldblue"><cf_get_lang dictionary_id='57657.Ürün'> <cf_get_lang dictionary_id='57789.Özel Kod'></td></cfif>	
            <td class="txtboldblue"><cf_get_lang dictionary_id='57657.Ürün'></td>
            <cfif isDefined("attributes.x_show_spec_info") and attributes.x_show_spec_info><td class="txtboldblue" width="55"><cf_get_lang dictionary_id='34299.Spec'></td></cfif>
            <td class="txtboldblue" width="55"><cf_get_lang dictionary_id='39675.Sipariş Aşaması'></td>
            <td class="txtboldblue" width="55"><cf_get_lang dictionary_id='29750.Rezerve'> <cf_get_lang dictionary_id ='30111.Durumu'></td>
            <td class="txtboldblue" width="55"><cf_get_lang dictionary_id='57645.Teslim Tarihi'></td>
            <td width="55"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='40235.Sipariş Miktarı'></td>
            <td width="55"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58816.İptal Edilen'></td>
            <td width="55"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='60105.İrsaliyeye Çekilen Miktar'></td>
            <td width="55"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='60106.Rezerve Edilen Miktar'></td>
            <td width="55"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='34901.İade Miktarı'></td>
            <td width="55"  class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58444.Kalan'></td>
            <td width="20"></td>
        </tr>
		<input type="hidden" name="from_order_row" id="from_order_row" value="1">
		<input type="hidden" name="is_return" id="is_return" value="<cfoutput>#attributes.is_return#</cfoutput>">
		<cfoutput>
			<input type="hidden" name="is_purchase" id="is_purchase" value="<cfif isdefined('attributes.is_purchase') and len(attributes.is_purchase)>#attributes.is_purchase#</cfif>">
			<input type="hidden" name="dept_id" id="dept_id" value="<cfif isdefined("attributes.department_id") and len(attributes.department_id)>#attributes.department_id#</cfif>">
			<input type="hidden" name="product_id" id="product_id" value="<cfif isdefined("attributes.product_id") and len(attributes.product_id)>#attributes.product_id#</cfif>">
			<input type="hidden" name="product_name" id="product_name" value="<cfif isdefined("attributes.product_name") and len(attributes.product_name)>#attributes.product_name#</cfif>">
			<input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfif isdefined("attributes.spect_main_id") and len(attributes.spect_main_id)>#attributes.spect_main_id#</cfif>">
			<input type="hidden" name="spect_name" id="spect_name" value="<cfif isdefined("attributes.spect_name") and len(attributes.spect_name)>#attributes.spect_name#</cfif>">
			<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#</cfif>">
			<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
			<input type="hidden" name="x_send_order_detail" id="x_send_order_detail" value="<cfif x_send_order_detail eq 1>#x_send_order_detail#</cfif>">
			<input type="hidden" name="xml_order_row_deliverdate_copy_to_ship" id="xml_order_row_deliverdate_copy_to_ship" value="<cfif isdefined('attributes.xml_order_row_deliverdate_copy_to_ship') and len(attributes.xml_order_row_deliverdate_copy_to_ship)>#attributes.xml_order_row_deliverdate_copy_to_ship#</cfif>">
			<input type="hidden" name="related_order_" id="related_order_" value="#attributes.order_id_#">
			<input type="hidden" name="keyword" id="keyword" value="<cfif isdefined("attributes.keyword")><cfoutput>#attributes.keyword#</cfoutput></cfif>">
			<input type="hidden" name="is_from_invoice" id="is_from_invoice" value="<cfif isdefined('attributes.is_from_invoice') and len(attributes.is_from_invoice)>#attributes.is_from_invoice#</cfif>">
			<cfif isdefined('attributes.control') and len(attributes.control)>
				<input type="hidden" name="control" id="control" value="#attributes.control#">
			</cfif>
		</cfoutput>
		<cfif evaluate("#q_name#.recordcount")>
			<cfset total_shelf_amount=0>
			<cfoutput query="#q_name#">
				<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'=(QUANTITY-CANCEL_AMOUNT)>
				<cfif RESERVE_TYPE neq -3>
					<cfset 'add_reserve_amount_#STOCK_ID#_#SPECT_VAR_ID#'=QUANTITY>
				<cfelse>
					<cfset 'add_reserve_amount_#STOCK_ID#_#SPECT_VAR_ID#'=0>
				</cfif>
				<cfif isdefined('row_processed_amount_#WRK_ROW_ID#') and len(evaluate('row_processed_amount_#WRK_ROW_ID#'))>
					<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')-evaluate('row_processed_amount_#WRK_ROW_ID#')>
					<cfset row_dsp_amount_=evaluate('row_processed_amount_#WRK_ROW_ID#')>
				<cfelse>
					<cfset row_dsp_amount_=0>
				</cfif>
				<cfif isdefined('row_processed_amount_iade_#WRK_ROW_ID#') and len(evaluate('row_processed_amount_iade_#WRK_ROW_ID#'))>
					<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')+evaluate('row_processed_amount_iade_#WRK_ROW_ID#')>
					<cfset row_dsp_amount_iade_=evaluate('row_processed_amount_iade_#WRK_ROW_ID#')>
				<cfelse>
					<cfset row_dsp_amount_iade_=0>
				</cfif>
				<cfif isdefined('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#') and len(evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#')) and evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#') gt 0>
					<cfif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') gt 0 and evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#') gte evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset row_dsp_amount_=row_dsp_amount_+evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset 'processed_amount_#STOCK_ID#_#SPECT_VAR_ID#'=evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#')-evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'=0>
					<cfelseif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') gt 0 and evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#') lt evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset row_dsp_amount_=row_dsp_amount_+evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')-evaluate('processed_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset 'processed_amount_#STOCK_ID#_#SPECT_VAR_ID#'=0>
					</cfif>
				</cfif>
				<cfif isdefined('processed_amount_iade_#STOCK_ID#_#SPECT_VAR_ID#') and len(evaluate('processed_amount_iade_#STOCK_ID#_#SPECT_VAR_ID#')) and evaluate('processed_amount_iade_#STOCK_ID#_#SPECT_VAR_ID#') gt 0>
					<cfif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') gt 0 and evaluate('processed_amount_iade_#STOCK_ID#_#SPECT_VAR_ID#') gte evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset row_dsp_amount_iade_=row_dsp_amount_iade_+evaluate('processed_amount_iade_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset 'processed_amount_iade_#STOCK_ID#_#SPECT_VAR_ID#'=evaluate('processed_amount_iade_#STOCK_ID#_#SPECT_VAR_ID#')-evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'=0>
					<cfelseif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') gt 0 and evaluate('processed_amount_iade_#STOCK_ID#_#SPECT_VAR_ID#') lt evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset row_dsp_amount_iade_=row_dsp_amount_iade_+evaluate('processed_amount_iade_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'=evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#')+evaluate('processed_amount_iade_#STOCK_ID#_#SPECT_VAR_ID#')>
						<cfset 'processed_amount_iade_#STOCK_ID#_#SPECT_VAR_ID#'=0>
					</cfif>
				</cfif>
				<cfif (attributes.is_return eq 0 and listfind('-6,-7',ORDER_ROW_CURRENCY)) or (attributes.is_return eq 1 and listfind('-10,-7,-8,-3',ORDER_ROW_CURRENCY))>
					<tr class="color-row">
						<td>#STOCK_CODE#</td>
						<cfif isDefined("x_show_product_code_2") and x_show_product_code_2 eq 1><td>#PRODUCT_CODE_2#</td></cfif>
						<td>#PRODUCT_NAME# #PROPERTY#</td>
						<cfif isDefined("attributes.x_show_spec_info") and attributes.x_show_spec_info><td>#SPECT_VAR_NAME# - #SPECT_VAR_ID#</td></cfif>
						<td><cfswitch expression = "#ORDER_ROW_CURRENCY#">
								<cfcase value="-7"><cf_get_lang dictionary_id='29748.Eksik Teslimat'></cfcase>
								<cfcase value="-8"><cf_get_lang dictionary_id='29749.Fazla Teslimat'></cfcase>
								<cfcase value="-6"><cf_get_lang dictionary_id='58761.Sevk'></cfcase>
								<cfcase value="-5"><cf_get_lang dictionary_id='57456.Üretim'></cfcase>
								<cfcase value="-4"><cf_get_lang dictionary_id='29747.Kısmi Üretim'></cfcase>
								<cfcase value="-3"><cf_get_lang dictionary_id='29746.Kapatıldı'></cfcase>
								<cfcase value="-2"><cf_get_lang dictionary_id='29533.Tedarik'></cfcase>
								<cfcase value="-1"><cf_get_lang dictionary_id='58717.Açık'></cfcase>
							</cfswitch>						
						</td>
						<td><cfswitch expression = "#RESERVE_TYPE#">
								<cfcase value="-4"><cf_get_lang dictionary_id='29753.Rezerve Kapatıldı'></cfcase>
								<cfcase value="-3"><cf_get_lang dictionary_id='29752.Rezerve Degil'></cfcase>
								<cfcase value="-2"><cf_get_lang dictionary_id='29751.Kısmi Rezerve'></cfcase>
								<cfcase value="-1"><cf_get_lang dictionary_id='29750.Rezerve'></cfcase>
							</cfswitch>						
						</td>
						<td width="55"><cfif len(deliver_date)>#dateformat(deliver_date,dateformat_style)#</cfif></td>
						<td width="55"  style="text-align:right;">#TLFormat(QUANTITY)#</td>
						<td width="55"  style="text-align:right;">#TLFormat(CANCEL_AMOUNT)#</td>
						<td width="55"  nowrap="nowrap" style="text-align:right;"><cfif isdefined('row_dsp_amount_')>#TLFormat(row_dsp_amount_)#</cfif></td>
						<td width="55"  style="text-align:right;">
						<cfif not (isdefined('is_full_reserved_#STOCK_ID#_#SPECT_VAR_ID#') and evaluate('is_full_reserved_#STOCK_ID#_#SPECT_VAR_ID#') eq 1) and (isdefined('add_reserve_amount_#STOCK_ID#_#SPECT_VAR_ID#') and evaluate('add_reserve_amount_#STOCK_ID#_#SPECT_VAR_ID#') gt 0)>
							<cfif isdefined('reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#') and len(evaluate('reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#'))>
								<cfif isdefined('non_reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
									<cfset temp_c=evaluate('non_reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
								<cfelse>
									<cfset temp_c=evaluate('reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#')> <!--- kalan toplam reserve miktarı --->
								</cfif>
								<cfif temp_c gte QUANTITY>
									#TLFormat(abs(QUANTITY))#
									<cfset 'non_reserved_amount_#STOCK_ID#_#SPECT_VAR_ID#' = temp_c-QUANTITY>
								<cfelseif temp_c lt evaluate('add_reserve_amount_#STOCK_ID#_#SPECT_VAR_ID#')>
									#TLFormat(abs(temp_c))#
									<cfset 'is_full_reserved_#STOCK_ID#_#SPECT_VAR_ID#'=1>
								</cfif>
							</cfif>
						</cfif>						
						</td>
						<td width="55"  nowrap="nowrap" style="text-align:right;"><cfif isdefined('row_dsp_amount_iade_')>#TLFormat(row_dsp_amount_iade_)#</cfif></td>
						<td  nowrap style="text-align:right;">
						<cfif (attributes.is_return eq 1 and listfind('-10,-7,-8,-3',ORDER_ROW_CURRENCY))>
							<cfset 'add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#' = QUANTITY - CANCEL_AMOUNT>
						</cfif>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='38519.Miktarı Kontrol Ediniz!'></cfsavecontent>
						<input type="text" name="order_add_amount_#ORDER_ID#_#ORDER_ROW_ID#" id="order_add_amount_#ORDER_ID#_#ORDER_ROW_ID#" onkeyup="return(FormatCurrency(this,event,4));" validate="float" class="moneybox" value="<cfif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') gt 0>#TLFormat(evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#'),4)#<cfelse>#TLFormat(0)#</cfif>" range="0,#QUANTITY#" style="width:100%" message="<cfoutput>#message#</cfoutput>">						</td>
						<td width="20" align="center" nowrap>
							<cfif len(COMPANY_ID)>
								<input type="Checkbox" name="company_order_" id="company_order_" value="#ORDER_ROW_ID#;#COMPANY_ID#;<cfif len(DELIVER_DEPT)>#DELIVER_DEPT#<cfelse>0</cfif>" <cfif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') lte 0>disabled</cfif> >
							<cfelse>
								<input type="Checkbox" name="cons_order_" id="cons_order_" value="#ORDER_ROW_ID#;#consumer_id#;<cfif len(DELIVER_DEPT)>#DELIVER_DEPT#<cfelse>0</cfif>" <cfif evaluate('add_product_amount_#STOCK_ID#_#SPECT_VAR_ID#') lte 0>disabled</cfif> >
							</cfif>						
						</td>	
					</tr>
				</cfif> 
			</cfoutput>
			<tr class="color-list">
				<td colspan="14"  style="text-align:right;">
					<div id="ORDER_ROWS_MESSAGE"></div>
					<input type="submit" onClick="<cfoutput>control_ship_amounts('#attributes.form_crntrow#');</cfoutput>" value="Ekle">				
				</td>
			</tr>
		</cfif>
	</cf_ajax_list>
</form>
<script type="text/javascript">
function control_ship_amounts(form_row_no)
{
	var ship_= eval('document.ship_detail_'+form_row_no+'.related_order_').value;
	if(eval('document.ship_detail_'+form_row_no+'.company_order_')!= undefined)
		var checked_item_= eval('document.ship_detail_'+form_row_no+'.company_order_');
	else if(eval('document.ship_detail_'+form_row_no+'.cons_order_') != undefined)
		var checked_item_= eval('document.ship_detail_'+form_row_no+'.cons_order_');
	
	if(checked_item_.length != undefined)
	{
		for(var xx=0; xx < checked_item_.length; xx++)
		{
			if(checked_item_[xx].checked)
			{
				checked_ship_row_id_ = list_getat(checked_item_[xx].value,1,';');
				 eval('document.ship_detail_'+form_row_no+'.order_add_amount_'+ship_+'_'+checked_ship_row_id_).value=filterNum(eval('document.ship_detail_'+form_row_no+'.order_add_amount_'+ship_+'_'+checked_ship_row_id_).value,4);
			}
		}
	}
	else if(checked_item_.checked)
	{
		checked_ship_row_id_ = list_getat(checked_item_.value,1,';');
		 eval('document.ship_detail_'+form_row_no+'.order_add_amount_'+ship_+'_'+checked_ship_row_id_).value=filterNum(eval('document.ship_detail_'+form_row_no+'.order_add_amount_'+ship_+'_'+checked_ship_row_id_).value,4);
	}
	return true;
	AjaxFormSubmit('<cfoutput>ship_detail_#attributes.form_crntrow#</cfoutput>" action="<cfoutput>#request.self#?fuseaction=objects.popup_add_order_to_ship</cfoutput>"','ORDER_ROWS_MESSAGE',1);
}
</script>

