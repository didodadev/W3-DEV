<!--- Sayfa :İthalat Faturası Ürünlerinin, hangi ithal mal girişine hangi miktarda cekildigini gosterir. OZDEN20060414  --->
<cfif not isdefined("url.invoice_id")>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='45732.Fatura No Belirtilmemiş'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_PERIOD" datasource="#dsn#">
	SELECT PERIOD_ID, PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery> 
<cfquery name="CHECK_INVOICE" datasource="#dsn2#">
	SELECT 
		INVOICE.COMPANY_ID,
		INVOICE.PARTNER_ID,
		INVOICE.CONSUMER_ID,
		INVOICE.INVOICE_NUMBER,
		INVOICE.INVOICE_DATE,
		INVOICE.INVOICE_ID,
		INVOICE.DEPARTMENT_ID,
		INVOICE.DEPARTMENT_LOCATION,
		RELSHIP.SHIP_NUMBER,
		RELSHIP.SHIP_ID,
		ISNULL(RELSHIP.SHIP_AMOUNT,0) SHIP_AMOUNT,
		ISNULL(INVOICE_ROW.AMOUNT,0) AMOUNT,
		INVOICE_ROW.STOCK_ID,
		INVOICE_ROW.NAME_PRODUCT,
		INVOICE_ROW.PRICE,
		INVOICE_ROW.UNIT
	FROM 
		INVOICE,
		INVOICE_ROW	
			LEFT JOIN
			(
				SELECT
					PRODUCT_ID,STOCK_ID,SUM(SHIP_AMOUNT) AS SHIP_AMOUNT,IMPORT_INVOICE_ID,SHIP_NUMBER,SHIP_ID
				FROM
					(
						SELECT 
							PRODUCT_ID,STOCK_ID,SUM(AMOUNT) AS SHIP_AMOUNT,INVOICE_SHIPS.IMPORT_INVOICE_ID,SHIP.SHIP_NUMBER,SHIP.SHIP_ID
						FROM 
							SHIP,
							SHIP_ROW,
							INVOICE_SHIPS
						WHERE
							SHIP.SHIP_ID=INVOICE_SHIPS.SHIP_ID
							AND SHIP.SHIP_ID=SHIP_ROW.SHIP_ID
							AND SHIP_ROW.IMPORT_INVOICE_ID=INVOICE_SHIPS.IMPORT_INVOICE_ID
							AND INVOICE_SHIPS.IMPORT_PERIOD_ID = #session.ep.period_id#
						GROUP BY
							PRODUCT_ID,STOCK_ID,INVOICE_SHIPS.IMPORT_INVOICE_ID,SHIP.SHIP_NUMBER,SHIP.SHIP_ID
						<cfif GET_PERIOD.recordcount>
						<cfloop query="GET_PERIOD">
							UNION ALL
							SELECT 
								PRODUCT_ID,STOCK_ID,SUM(AMOUNT) AS SHIP_AMOUNT,INVOICE_SHIPS.IMPORT_INVOICE_ID,SHIP.SHIP_NUMBER,SHIP.SHIP_ID
							FROM 
								#dsn#_#get_period.period_year#_#get_period.our_company_id#.SHIP SHIP,
								#dsn#_#get_period.period_year#_#get_period.our_company_id#.SHIP_ROW SHIP_ROW,
								#dsn#_#get_period.period_year#_#get_period.our_company_id#.INVOICE_SHIPS INVOICE_SHIPS
							WHERE
								SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID
								AND SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
								AND SHIP_ROW.IMPORT_INVOICE_ID = INVOICE_SHIPS.IMPORT_INVOICE_ID
								AND INVOICE_SHIPS.IMPORT_PERIOD_ID = #session.ep.period_id#
							GROUP BY
								PRODUCT_ID,STOCK_ID,INVOICE_SHIPS.IMPORT_INVOICE_ID,SHIP.SHIP_NUMBER,SHIP.SHIP_ID
						</cfloop>
						</cfif>
					) AS XXX
				GROUP BY
					PRODUCT_ID,STOCK_ID,IMPORT_INVOICE_ID,SHIP_NUMBER,SHIP_ID
			) RELSHIP ON RELSHIP.IMPORT_INVOICE_ID = INVOICE_ROW.INVOICE_ID AND RELSHIP.STOCK_ID = INVOICE_ROW.STOCK_ID
	WHERE 
		INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND 
		INVOICE.INVOICE_CAT = 591 AND 
		INVOICE.INVOICE_ID = #url.invoice_id#
	ORDER BY
		INVOICE_ROW_ID
</cfquery>
<cfif not CHECK_INVOICE.recordcount>
	<table width="95%" height="30" align="center">
		<tr class="color-list">
			<td class="headbold" align="center"><cf_get_lang dictionary_id='60075.İthalat Faturası Kaydı Bulunamadı'>!</td>
		</tr>
	</table>
	<cfexit method="exittemplate">
<cfelse>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='58749.Fatura Bilgileri'></cfsavecontent>
	<cf_popup_box title="#message#"><!---Fatura Bilgileri--->
		<cf_medium_list>
			<thead>
				<cfoutput>
					<tr>
					  <th colspan="7">
						<b>Cari Hesap:</b>
						<cfif len(check_invoice.COMPANY_ID)>
							#get_par_info(check_invoice.COMPANY_ID,1,1,0)#
							<cfif len(CHECK_INVOICE.PARTNER_ID)>- #get_par_info(CHECK_INVOICE.PARTNER_ID,0,-1,0)#</cfif> 
						<cfelseif len(check_invoice.CONSUMER_ID)>
							#get_cons_info(check_invoice.CONSUMER_ID,1,0)#
						<cfelseif Len(check_invoice.employee_id)>
							#get_emp_info(check_invoice.employee_id,0,0)#
						</cfif>
						
						&nbsp;&nbsp;
						<b><cf_get_lang dictionary_id='58133.Fatura No'>:</b> #CHECK_INVOICE.INVOICE_NUMBER#<br/>
						<b><cf_get_lang dictionary_id='58759.Fatura Tarihi'>:</b> #dateformat(CHECK_INVOICE.INVOICE_DATE,dateformat_style)#
						&nbsp;&nbsp;
						<b><cf_get_lang dictionary_id='58763.Depo'>:</b> 
						<cfif len(CHECK_INVOICE.DEPARTMENT_ID) and len(CHECK_INVOICE.DEPARTMENT_LOCATION)>
							<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
								SELECT 
									D.DEPARTMENT_HEAD,
									SL.COMMENT
								FROM 
									DEPARTMENT D,
									STOCKS_LOCATION SL
								WHERE 
									D.DEPARTMENT_ID=SL.DEPARTMENT_ID
									AND D.DEPARTMENT_ID = #CHECK_INVOICE.DEPARTMENT_ID#
									AND SL.LOCATION_ID=#CHECK_INVOICE.DEPARTMENT_LOCATION# 
							</cfquery>
							#GET_DEPARTMENT.DEPARTMENT_HEAD#-#GET_DEPARTMENT.COMMENT#
						</cfif>
						</th>
					</tr>
				</cfoutput>
				<tr>
				  <th><cf_get_lang dictionary_id="57880.Belge No"></th>
				  <th><cf_get_lang dictionary_id="57657.Ürün"></th>          
				  <th width="100" style="text-align:right;"><cf_get_lang dictionary_id="57673.Tutar"></th>
				  <th width="50" style="text-align:right;"><cf_get_lang dictionary_id="57636.Birim"></th>	  
				  <th width="55" style="text-align:right;"><cf_get_lang dictionary_id="32557.Fatura Miktarı"></th>
				  <th width="55" style="text-align:right;"><cf_get_lang dictionary_id="32558.Çekilen Miktar"></th>
				  <th width="55" style="text-align:right;"><cf_get_lang dictionary_id="32727.Kalan Miktar"></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="CHECK_INVOICE">
					<cfif not isDefined("diff_amount_#stock_id#")><cfset "diff_amount_#stock_id#" = CHECK_INVOICE.AMOUNT></cfif>
					<tr>
						<td><a href="#request.self#?fuseaction=stock.add_stock_in_from_customs&event=upd&ship_id=#ship_id#" class="tableyazi" target="_blank">#check_invoice.ship_number#</a></td>
						<td>#check_invoice.name_product#</td>
						<td style="text-align:right;">#TLFormat(CHECK_INVOICE.PRICE,4)#</td>
						<td style="text-align:right;">#CHECK_INVOICE.UNIT#</td>
						<td style="text-align:right;">#TLFormat(CHECK_INVOICE.AMOUNT)#</td>
						<td style="text-align:right;">#TLFormat(ship_amount)#</td>
						<cfset "diff_amount_#stock_id#" = Evaluate("diff_amount_#stock_id#") - ship_amount>
						<td style="text-align:right;">#TLFormat(Evaluate("diff_amount_#stock_id#"))#</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_medium_list>
	</cf_popup_box>	
</cfif>
