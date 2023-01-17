-<!--- BK 20070108
Satis Siparisi MT Onay surec kosul dosyası
Siparisteki urunlerden stokta eksik olanlar varsa mesaj verir
eksik urun yoksa risk kontrolleri baslar

modified: TolgaS20070111
--->
<!--- Sevk degeri icin 0 set ediliyor --->
<cfset is_sevk =0>
<!--- hsmagaza Finans Onay sureci idsi:21--->
<cfset finans_onay_stage=21>
<cfset ilk_stage=20><!--- stokta olmama durumunda surec geri aliniyor --->
<cfquery name="GET_ORDER_ROW" datasource="#caller.dsn3#">
	SELECT
		ORR.PRODUCT_ID,
		SUM(ORR.QUANTITY) MIKTAR
	FROM
		ORDER_ROW ORR,
		STOCKS S
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
	<cfquery name="GET_STOCK_NUM" datasource="#caller.dsn3#">
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
</cfif>
<!--- Stokda bulunmayan urunlar var ise --->
<cfif not len(urunler)>
  <cfif caller.attributes.member_type eq 'partner'>
	<cfquery name="GET_COMPANY_RISK" datasource="#caller.dsn3#">
		SELECT
			BAKIYE,
			CEK_ODENMEDI,
			CEK_KARSILIKSIZ,
			SENET_ODENMEDI,
			SENET_KARSILIKSIZ,
			OPEN_ACCOUNT_RISK_LIMIT,
			TOTAL_RISK_LIMIT,
			COMPANY_ID
		FROM
			#caller.dsn2_alias#.COMPANY_RISK
		WHERE
			COMPANY_ID = #caller.attributes.company_id#
	</cfquery>
	<cfif get_company_risk.recordcount>
	  <!--- open_risk: acik hesap risk limiti --->
	  <cfset open_risk = get_company_risk.open_account_risk_limit - get_company_risk.bakiye>
	  <!--- usable_risk: kullanilabilir risk limiti  --->
	  <cfset usable_risk = get_company_risk.total_risk_limit - get_company_risk.bakiye  - (get_company_risk.cek_odenmedi+ get_company_risk.senet_odenmedi + get_company_risk.cek_karsiliksiz + get_company_risk.senet_karsiliksiz)>
	  	<cfquery name="GET_COMPANY_ORDERS" datasource="#caller.dsn3#">
			SELECT
				SUM(NETTOTAL) NETTOTAL,
				COMPANY_ID
			FROM
				ORDERS
			WHERE
				IS_PAID <> 1 AND
				IS_PROCESSED <> 1 AND
				((ORDERS.PURCHASE_SALES=1 AND ORDERS.ORDER_ZONE=0) OR (ORDERS.PURCHASE_SALES=0 AND ORDERS.ORDER_ZONE=1 )) AND
				COMPANY_ID = #caller.attributes.company_id#
			GROUP BY
				COMPANY_ID
		</cfquery>
	  	<cfif get_company_orders.recordcount>
		  <cfset open_risk = open_risk - get_company_orders.nettotal>
		  <cfset usable_risk = usable_risk - get_company_orders.nettotal>
		</cfif>
	</cfif>
	  <cfif not GET_COMPANY_RISK.RECORDCOUNT or (open_risk lt 0 or usable_risk lt 0)>
		<!--- Riske Takildi Finans Onay Yetkililerine Uyarı Gönderilmeli --->		
		<cfquery name="GET_WARNING_EMP" datasource="#caller.dsn3#">
			SELECT 
				EMPLOYEES.EMPLOYEE_NAME EMPLOYEE_NAME,
				EMPLOYEES.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				EMPLOYEES.EMPLOYEE_EMAIL EMPLOYEE_EMAIL,
				EMPLOYEES.MOBILCODE MOBILCODE,
				EMPLOYEES.MOBILTEL MOBILTEL,
				EMPLOYEE_POSITIONS.EMPLOYEE_ID EMPLOYEE_ID,
				EMPLOYEE_POSITIONS.POSITION_CODE,
				PROCESS_TYPE_ROWS_WORKGRUOP.WORKGROUP_ID,
				PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID PRO_POSITION_ID
			FROM 
				#process_db#EMPLOYEES EMPLOYEES,
				#process_db#EMPLOYEE_POSITIONS EMPLOYEE_POSITIONS,
				#process_db#PROCESS_TYPE_ROWS_WORKGRUOP PROCESS_TYPE_ROWS_WORKGRUOP,
				#process_db#PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID
			WHERE
				PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = #finans_onay_stage# AND
				PROCESS_TYPE_ROWS_WORKGRUOP.WORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID AND
				EMPLOYEE_POSITIONS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
				EMPLOYEE_POSITIONS.POSITION_ID = PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID
		</cfquery>
			
		<cfif get_warning_emp.recordcount>
		  <cfoutput query="get_warning_emp">
			<cfset max_warning_date = attributes.record_date>
			
			<cfquery name="ADD_WARNING" datasource="#caller.dsn3#" result="GET_WARNINGS">
				INSERT INTO
					#process_db#PAGE_WARNINGS
				(
					URL_LINK,
					WARNING_HEAD,
					SETUP_WARNING_ID,
					WARNING_DESCRIPTION,
					SMS_WARNING_DATE,
					EMAIL_WARNING_DATE,
					LAST_RESPONSE_DATE,
					RECORD_DATE,
					IS_ACTIVE,
					IS_PARENT,
					RESPONSE_ID,
					RECORD_IP,
					RECORD_EMP,
					POSITION_CODE,
					WARNING_PROCESS
				)
				VALUES
				(
					'#attributes.action_page#',
					'#get_process_type.process_name# - #get_process_type.stage#',
					#get_process_type.process_row_id#,
					'<cfif len(get_process_type.detail)>#get_process_type.detail# - </cfif>#attributes.warning_description#',
					#max_warning_date#,
					#max_warning_date#,
					#max_warning_date#,
					#attributes.record_date#,
					1,
					1,
					0,
					'#cgi.remote_addr#',
					#session.ep.userid#,
					#get_warning_emp.position_code#,
					1
				)
			</cfquery>
			<cfquery name="UPD_WARNINGS" datasource="#caller.dsn3#">
				UPDATE #process_db#PAGE_WARNINGS SET PARENT_ID = #GET_WARNINGS.IDENTITYCOL# WHERE W_ID = #GET_WARNINGS.IDENTITYCOL#			
			</cfquery>
		  </cfoutput>
		</cfif>
	  <cfelse>
		<!--- Risk Kaydı Sıfırdan Buyuk sevk yap --->
		<cfset is_sevk =1>
	  </cfif>
  <cfelse>
  	<!--- Secilen uye consumer sevk yap --->
	<cfset is_sevk =1>
  </cfif>
  <cfif is_sevk eq 1>
	<cfquery name="UPD_ORDER_SEVK" datasource="#caller.dsn3#">
		UPDATE
			ORDER_ROW
		SET
			ORDER_ROW_CURRENCY  = -6
		WHERE
			ORDER_ID = #attributes.action_id#
	</cfquery>  
  </cfif>
<cfelse>
	<cfquery name="UPD_ORDER_SEVK" datasource="#caller.dsn3#">
		UPDATE
			ORDERS
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



