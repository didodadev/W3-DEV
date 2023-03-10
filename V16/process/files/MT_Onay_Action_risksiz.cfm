<!---Main Action File [1] --->
<!--- TolgaS 20070112
Satis Siparisi MT Onay surec kosul dosyası
Siparisteki urunlerden stokta eksik olanlar varsa mesaj verir
--->
<!--- Sevk degeri icin 0 set ediliyor --->
<cfset is_sevk =0>
<!--- hsmagaza il sürec idsi:3--->
<cfset ilk_stage=3><!--- stokta olmama durumunda surec geri aliniyor --->
<cfquery name="GET_ORDER_ROW" datasource="#attributes.data_source#">
	SELECT
		ORR.PRODUCT_ID,
		SUM(ORR.QUANTITY) MIKTAR
	FROM
		#caller.dsn3_alias#.ORDER_ROW ORR,
		#caller.dsn3_alias#.STOCKS S
	WHERE
		ORR.ORDER_ID = #attributes.action_id# AND
		ORR.STOCK_ID = S.STOCK_ID
	GROUP BY 
		ORR.PRODUCT_ID
	ORDER BY
		ORR.PRODUCT_ID
</cfquery>
<cfset urunler = ''>
<cfset product_id_list="">
<cfset product_miktar_list="">
<cfoutput query="GET_ORDER_ROW">
	<cfif len(product_id)>
		<cfset product_id_list = listappend(product_id_list,get_order_row.product_id,',')>
		<cfset product_miktar_list = listappend(product_miktar_list,get_order_row.MIKTAR,',')>
	<cfelse>
		<cfset product_id_list = listappend(product_id_list,0,',')>
		<cfset product_miktar_list = listappend(product_miktar_list,0,',')>
	</cfif>
</cfoutput>

<cfif listlen(product_id_list,',')>
	<cfquery name="GET_STOCK_NUM" datasource="#attributes.data_source#">
		SELECT 
			SUM(T1.PRODUCT_STOCK) STOK,
			P.PRODUCT_ID,
			P.PRODUCT_NAME
		FROM
		(
			SELECT 
				SUM(SR.PRODUCT_STOCK) PRODUCT_STOCK,
				SR.PRODUCT_ID
			FROM 
				#caller.dsn2_alias#.GET_STOCK_PRODUCT SR
			WHERE 
				SR.PRODUCT_ID IN (#product_id_list#)
			GROUP BY
				SR.PRODUCT_ID
		UNION
			SELECT
				SUM(STOCK_ARTIR-STOCK_AZALT) AS PRODUCT_STOCK,
				PRODUCT_ID
			FROM
				GET_STOCK_RESERVED
			WHERE
				PRODUCT_ID IN (#product_id_list#)
			GROUP BY
				PRODUCT_ID
		UNION
			
			SELECT
				SUM(STOCK_ARTIR-STOCK_AZALT ) AS PRODUCT_STOCK,
				PRODUCT_ID
			FROM
				GET_PRODUCTION_RESERVED
			WHERE
				PRODUCT_ID IN (#product_id_list#)
			GROUP BY
				PRODUCT_ID
		UNION
			
			SELECT
				SUM(STOCK_IN - SR.STOCK_OUT) AS PRODUCT_STOCK,
				SR.PRODUCT_ID
			FROM
				#caller.dsn2_alias#.STOCKS_ROW SR,
				#caller.dsn_alias#.STOCKS_LOCATION SL 
			WHERE
				SR.PRODUCT_ID IN (#product_id_list#)
				AND SR.STORE =SL.DEPARTMENT_ID
				AND SR.STORE_LOCATION=SL.LOCATION_ID
				AND NO_SALE = 1
			GROUP BY
				PRODUCT_ID
		) T1,
		PRODUCT P
	WHERE
		P.PRODUCT_ID=T1.PRODUCT_ID
	GROUP BY
		P.PRODUCT_ID,
		P.PRODUCT_NAME
	ORDER BY 
		P.PRODUCT_ID
	</cfquery>
	<cfloop query="get_stock_num">
		<cfset miktar=listgetat(product_miktar_list,listfind(product_id_list,get_stock_num.product_id,','),',')>
		<cfif (get_stock_num.stok) lt 0>
			<cfset urunler=urunler&'\n#get_stock_num.product_name# -- Miktarlar (İstenen:#miktar# Stok:#get_stock_num.stok+miktar#)'>			
		</cfif>
	</cfloop>
	
	<cfif len(urunler)>
		<cfquery name="UPD_ORDER_SEVK" datasource="#attributes.data_source#">
			UPDATE
				#caller.dsn3_alias#.ORDERS
			SET
				ORDER_STAGE  = #ilk_stage#
			WHERE
				ORDER_ID = #attributes.action_id#
		</cfquery>  
		<cfset urunler="Yeterli Stok Olmayan Ürünler"&urunler>
		<script type="text/javascript">
			alert('<cfoutput>#urunler#</cfoutput>');
		</script>
	</cfif>
	
</cfif>
