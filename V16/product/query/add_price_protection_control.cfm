<cfquery name="GET_PRODUCT_COST" datasource="#DSN3#">
	SELECT * FROM PRODUCT_COST WHERE PRODUCT_COST_ID = #attributes.cost_id#
</cfquery>
<cfif not GET_PRODUCT_COST.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang no ='874.İlgili Maliyet Kaydı Bulunamadı'>!");
		history.go(-1);
	</script>
	<cfabort>
</cfif>

<!--- bu maliyete daha once bir fiyat koruma yapilmis mi --->
<cfquery name="GET_COMPARISON" datasource="#dsn2#">
	SELECT
		CONTRACT_COMPARISON_ROW_ID,
		COMPANY_ID,
		DIFF_INVOICE_ID
	FROM
		INVOICE_CONTRACT_COMPARISON
	WHERE
		COST_ID=#attributes.cost_id#
</cfquery>
<!--- bu maliyete daha once bir fiyat koruma yapilmis mi --->

<cfif GET_PRODUCT_COST.ACTION_TYPE eq 1><!--- FATURA İSE FATURADAN GEREKLİ BİLGİLER ALINIYOR --->
	<cfquery name="GET_INV" datasource="#dsn2#">
		SELECT 
			INVOICE_NUMBER,
			INVOICE_DATE,
			COMPANY_ID,
			DEPARTMENT_ID,
			DEPARTMENT_LOCATION,
			INVOICE_ROW.STOCK_ID,
			INVOICE_ROW.TAX
		FROM 
			INVOICE,
			INVOICE_ROW
		WHERE 
			INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
			INVOICE.INVOICE_ID = #GET_PRODUCT_COST.ACTION_ID# AND
			INVOICE_ROW.PRODUCT_ID = #GET_PRODUCT_COST.PRODUCT_ID#
	</cfquery>
	<cfif not GET_INV.RECORDCOUNT>
		<script type="text/javascript">
			alert("<cf_get_lang no ='875.İlgili Maliyetin Fatura Kaydı Bulunamadı Faturayı Kontrol ediniz'>!");
			history.go(-1);
		</script>
		<cfabort>
	</cfif>
	
	<cfif isdefined('GET_INV') and GET_INV.RECORDCOUNT>
		<cfset attributes.invoice_date = dateformat(GET_INV.INVOICE_DATE,dateformat_style)>
	<cfelse>
		<cfset attributes.invoice_date = ''>
	</cfif>
	<cf_date tarih='attributes.invoice_date'>
	<cfset attributes.action_date = dateformat(GET_PRODUCT_COST.START_DATE,dateformat_style)>
	<cf_date tarih='attributes.action_date'>
	
	<cfquery name="GET_PRODUCT_STOCK" datasource="#dsn2#">
		SELECT
			SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK
		FROM
			STOCKS_ROW SR
		WHERE
			SR.PRODUCT_ID = #GET_PRODUCT_COST.PRODUCT_ID# AND
			PROCESS_DATE <= #attributes.action_date#
	</cfquery>
	
<cfelseif not len(GET_PRODUCT_COST.ACTION_TYPE) or GET_PRODUCT_COST.ACTION_TYPE eq 0><!--- elle eklenmiş olabilir bu yüzden degerler aliniyor --->
	<cfset GET_PRODUCT_STOCK.PRODUCT_TOTAL_STOCK=attributes.available_stock>
	<cfif not len(GET_PRODUCT_STOCK.PRODUCT_TOTAL_STOCK)><cfset GET_PRODUCT_STOCK.PRODUCT_TOTAL_STOCK=0></cfif>
	<cfif attributes.partner_stock gt 0>
		<cfset GET_PRODUCT_STOCK.PRODUCT_TOTAL_STOCK=GET_PRODUCT_STOCK.PRODUCT_TOTAL_STOCK + attributes.partner_stock>
	</cfif>
	<cfif attributes.active_stock gt 0>
		<cfset GET_PRODUCT_STOCK.PRODUCT_TOTAL_STOCK=GET_PRODUCT_STOCK.PRODUCT_TOTAL_STOCK + attributes.active_stock>
	</cfif>
	<cfquery name="GET_PROD_DT" datasource="#dsn3#" maxrows="1"><!--- MALİYETTE SADECE PRODUCT_ID OLDUGUNDAN BURDA DOGRU STOCK_ID YAKALAMA SANSIMIZ YOK --->
		SELECT TAX_PURCHASE,STOCK_ID FROM STOCKS WHERE PRODUCT_ID = #GET_PRODUCT_COST.PRODUCT_ID#
	</cfquery>
	<cfset attributes.invoice_date=attributes.start_date>
	<cfset attributes.action_date = attributes.invoice_date>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='876.Faturadan Eklenmeyen Maliyetlere Fiyat Koruma Yapamazsınız'>!");
		window.close();
	</script>
	<cfabort>
</cfif>


<cfif GET_PRODUCT_STOCK.PRODUCT_TOTAL_STOCK gt 0>
	<cfset total_diff=GET_PRODUCT_COST.PRICE_PROTECTION*GET_PRODUCT_STOCK.PRODUCT_TOTAL_STOCK>
	<cfset diff_money=GET_PRODUCT_COST.PRICE_PROTECTION_MONEY>
	<cfif diff_money neq session.ep.money>
		<cfquery name="GET_MONEY" datasource="#dsn#">
			SELECT (RATE2/RATE1) RATE FROM SETUP_MONEY WHERE MONEY='#diff_money#' AND PERIOD_ID = #session.ep.period_id#
		</cfquery>
		<cfset total_diff_system=total_diff*GET_MONEY.RATE>
	<cfelse>
		<cfset total_diff_system=total_diff>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='877.Maliyet Tarihinde Mevcut Stok 0'> !");
		history.go(-1);
	</script>
	<cfabort>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
<cftransaction>
<cfif not GET_COMPARISON.RECORDCOUNT>
	<cfquery name="add_in_con" datasource="#DSN2#">
		INSERT INTO 
			INVOICE_CONTROL
			(
				INVOICE_NUMBER,
				INVOICE_ID,
				COST_ID,
				COMPANY_ID,
				CONSUMER_ID,
				MONEY,
				RETURN_MONEY_VALUE,				
				IS_CONTROL,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE
			)
		VALUES
			(	
				<cfif isdefined('GET_INV') and len(GET_INV.INVOICE_NUMBER)>'#GET_INV.INVOICE_NUMBER#'<cfelse>NULL</cfif>,
				<cfif GET_PRODUCT_COST.ACTION_TYPE eq 1>#GET_PRODUCT_COST.ACTION_ID#<cfelse>NULL</cfif>,
				#attributes.cost_id#,
				<cfif isdefined('attributes.td_company_id') and len(attributes.td_company_id)>#attributes.td_company_id#<cfelse>NULL</cfif>,
				NULL,
				'#session.ep.money#',
				0,
				1,
				#SESSION.EP.USERID#,
				'#CGI.REMOTE_ADDR#',
				#NOW()#
			)
	</cfquery>

<!--- fiyat farkı --->
	<cfquery name="add_in_com" datasource="#DSN2#">
		INSERT INTO 
			INVOICE_CONTRACT_COMPARISON
		(
			COST_ID,
			COST_DATE,
			MAIN_INVOICE_ID,
			MAIN_INVOICE_DATE,
			MAIN_INVOICE_NUMBER,
			MAIN_INVOICE_ROW_ID,
			COMPANY_ID,
			MAIN_PRODUCT_ID,
			MAIN_STOCK_ID,
			
			AMOUNT,
			DIFF_RATE,
			DIFF_AMOUNT,
			DIFF_AMOUNT_OTHER,
			OTHER_MONEY,
			IS_DIFF_DISCOUNT,
			IS_DIFF_PRICE,
			DIFF_TYPE,
			TAX,
			DEPARTMENT_ID,
			LOCATION_ID,
			INVOICE_TYPE,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
		VALUES
		(
			#attributes.cost_id#,
			#attributes.action_date#,
			<cfif GET_PRODUCT_COST.ACTION_TYPE eq 1>#GET_PRODUCT_COST.ACTION_ID#<cfelse>NULL</cfif>,
			#attributes.invoice_date#,
			<cfif isdefined('GET_INV') and len(GET_INV.INVOICE_NUMBER)>'#GET_INV.INVOICE_NUMBER#'<cfelse>NULL</cfif>,
			<cfif GET_PRODUCT_COST.ACTION_TYPE eq 1>#GET_PRODUCT_COST.ACTION_ROW_ID#<cfelse>NULL</cfif>,
			<cfif isdefined('attributes.td_company_id') and len(attributes.td_company_id)>#attributes.td_company_id#<cfelseif isdefined('GET_INV') and len(GET_INV.COMPANY_ID)>'#GET_INV.COMPANY_ID#'<cfelse>NULL</cfif>,
			#GET_PRODUCT_COST.PRODUCT_ID#,
			<cfif isdefined('GET_INV') and len(GET_INV.STOCK_ID)>'#GET_INV.STOCK_ID#'<cfelseif isdefined('GET_PROD_DT') and len(GET_PROD_DT.STOCK_ID)>#GET_PROD_DT.STOCK_ID#<cfelse>NULL</cfif>,
			
			#GET_PRODUCT_STOCK.PRODUCT_TOTAL_STOCK#,
			NULL,
			#total_diff_system#,
			#total_diff#,
			'#diff_money#',
			0,
			0,
			6,<!--- fiyat koruma farkı --->
			<cfif isdefined('GET_INV') and len(GET_INV.TAX)>'#GET_INV.TAX#'<cfelseif isdefined('GET_PROD_DT') and len(GET_PROD_DT.TAX_PURCHASE)>#GET_PROD_DT.TAX_PURCHASE#<cfelse>NULL</cfif>,
			<cfif isdefined('GET_INV') and len(GET_INV.DEPARTMENT_ID)>'#GET_INV.DEPARTMENT_ID#'<cfelse>NULL</cfif>,
			<cfif isdefined('GET_INV') and len(GET_INV.DEPARTMENT_LOCATION)>'#GET_INV.DEPARTMENT_LOCATION#'<cfelse>NULL</cfif>,
			<cfif not isdefined('attributes.price_protection_type') or attributes.price_protection_type eq 1>0<cfelse>1</cfif>,
			#SESSION.EP.USERID#,
			'#CGI.REMOTE_ADDR#',
			#NOW()#
		)
	</cfquery>
<cfelse><!--- daha once bir fiyat koruma yapilmissa guncellenecek --->
	
	<cfquery name="add_in_con" datasource="#DSN2#">
		UPDATE
			INVOICE_CONTROL
		SET
			INVOICE_NUMBER=<cfif isdefined('GET_INV') and len(GET_INV.INVOICE_NUMBER)>'#GET_INV.INVOICE_NUMBER#'<cfelse>NULL</cfif>,
			INVOICE_ID=<cfif GET_PRODUCT_COST.ACTION_TYPE eq 1>#GET_PRODUCT_COST.ACTION_ID#<cfelse>NULL</cfif>,
			COMPANY_ID=<cfif isdefined('attributes.td_company_id') and len(attributes.td_company_id)>#attributes.td_company_id#<cfelse>NULL</cfif>,
			CONSUMER_ID=NULL,
			MONEY='#session.ep.money#',
			RETURN_MONEY_VALUE=0,
			IS_CONTROL=1,
			RECORD_EMP=#SESSION.EP.USERID#,
			RECORD_IP='#CGI.REMOTE_ADDR#',
			RECORD_DATE=#NOW()#
		WHERE
			COST_ID=#attributes.cost_id#
	</cfquery>

	<!--- fiyat farkı --->
	<cfquery name="add_in_com" datasource="#DSN2#">
		UPDATE
			INVOICE_CONTRACT_COMPARISON
		SET
			COST_ID=#attributes.cost_id#,
			COST_DATE=#attributes.action_date#,
			MAIN_INVOICE_ID=<cfif GET_PRODUCT_COST.ACTION_TYPE eq 1>#GET_PRODUCT_COST.ACTION_ID#<cfelse>NULL</cfif>,
			MAIN_INVOICE_DATE=#attributes.invoice_date#,
			MAIN_INVOICE_NUMBER=<cfif isdefined('GET_INV') and len(GET_INV.INVOICE_NUMBER)>'#GET_INV.INVOICE_NUMBER#'<cfelse>NULL</cfif>,
			MAIN_INVOICE_ROW_ID=<cfif GET_PRODUCT_COST.ACTION_TYPE eq 1>#GET_PRODUCT_COST.ACTION_ROW_ID#<cfelse>NULL</cfif>,
			COMPANY_ID=<cfif isdefined('attributes.td_company_id') and len(attributes.td_company_id)>#attributes.td_company_id#<cfelseif isdefined('GET_INV') and len(GET_INV.COMPANY_ID)>'#GET_INV.COMPANY_ID#'<cfelse>NULL</cfif>,
			MAIN_PRODUCT_ID=#GET_PRODUCT_COST.PRODUCT_ID#,
			MAIN_STOCK_ID=<cfif isdefined('GET_INV') and len(GET_INV.STOCK_ID)>'#GET_INV.STOCK_ID#'<cfelseif isdefined('GET_PROD_DT') and len(GET_PROD_DT.STOCK_ID)>#GET_PROD_DT.STOCK_ID#<cfelse>NULL</cfif>,
			AMOUNT=#GET_PRODUCT_STOCK.PRODUCT_TOTAL_STOCK#,
			DIFF_RATE=NULL,
			DIFF_AMOUNT=#total_diff_system#,
			DIFF_AMOUNT_OTHER=#total_diff#,
			OTHER_MONEY='#diff_money#',
			IS_DIFF_DISCOUNT=0,
			IS_DIFF_PRICE=0,
			DIFF_TYPE=6,<!--- fiyat koruma farkı --->
			TAX=<cfif isdefined('GET_INV') and len(GET_INV.TAX)>'#GET_INV.TAX#'<cfelseif isdefined('GET_PROD_DT') and len(GET_PROD_DT.TAX_PURCHASE)>#GET_PROD_DT.TAX_PURCHASE#<cfelse>NULL</cfif>,
			DEPARTMENT_ID=<cfif isdefined('GET_INV') and len(GET_INV.DEPARTMENT_ID)>'#GET_INV.DEPARTMENT_ID#'<cfelse>NULL</cfif>,
			LOCATION_ID=<cfif isdefined('GET_INV') and len(GET_INV.DEPARTMENT_LOCATION)>'#GET_INV.DEPARTMENT_LOCATION#'<cfelse>NULL</cfif>,
			INVOICE_TYPE=<cfif not isdefined('attributes.price_protection_type') or attributes.price_protection_type eq 1>0<cfelse>1</cfif>,
			RECORD_EMP=#SESSION.EP.USERID#,
			RECORD_IP='#CGI.REMOTE_ADDR#',
			RECORD_DATE=#NOW()#
		WHERE
			CONTRACT_COMPARISON_ROW_ID=#GET_COMPARISON.CONTRACT_COMPARISON_ROW_ID#
	</cfquery>
</cfif>
</cftransaction>
</cflock>
<cfif not isdefined('attributes.cost_control')><!--- direk maliyet eklemeden geliyorsa attributes.cost_control geliyor ve kapatmamalı --->
	<script type="text/javascript">window.close();</script>
</cfif>
