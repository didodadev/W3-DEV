<!--- Sayfa :İthalat Faturası Ürünlerini İthal Mal Girişi İrsaliyesine Ekler. --->
<cfif not (isdefined("url.invoice_number") and len(url.invoice_number))>
	<script type="text/javascript">
		alert("<cf_get_lang no ='553.Fatura No Belirtilmemiş'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfset invoice_period=session.ep.period_id>
<cfquery name="check_invoice" datasource="#dsn2#">
	SELECT 
		INVOICE.COMPANY_ID,
		INVOICE.PARTNER_ID,
		INVOICE.CONSUMER_ID,
		INVOICE.INVOICE_NUMBER,
		INVOICE.INVOICE_DATE,
		INVOICE.INVOICE_ID,
		INVOICE.DEPARTMENT_ID,
		INVOICE.DEPARTMENT_LOCATION,
		STOCKS.STOCK_CODE,
		STOCKS.BARCOD,
		#session.ep.period_id# INVOICE_PERIOD,
		INVOICE_ROW.INVOICE_ROW_ID,
		INVOICE_ROW.WRK_ROW_ID,
		INVOICE_ROW.PRODUCT_ID,
		INVOICE_ROW.AMOUNT,
		INVOICE_ROW.NAME_PRODUCT,
		INVOICE_ROW.PRICE,
		INVOICE_ROW.UNIT,
		INVOICE_ROW.UNIT2,
		INVOICE_ROW.AMOUNT2
	FROM 
		INVOICE,
		INVOICE_ROW,
		#dsn3_alias#.STOCKS STOCKS
	WHERE 
		INVOICE.INVOICE_ID = INVOICE_ROW.INVOICE_ID AND
		INVOICE.INVOICE_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="591"> AND
		INVOICE.INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.invoice_number#"> AND
		STOCKS.STOCK_ID = INVOICE_ROW.STOCK_ID
	ORDER BY
		INVOICE.INVOICE_ID,
		INVOICE_ROW_ID
</cfquery>
<cfquery name="get_period" datasource="#dsn#" maxrows="3">
	SELECT
		PERIOD_ID,
		PERIOD_YEAR,
		OUR_COMPANY_ID
	FROM
		SETUP_PERIOD
	WHERE
		PERIOD_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> AND
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY
		PERIOD_YEAR DESC
</cfquery> 
<cfif not check_invoice.recordcount>
	<!--- Bu doneme ait kayit yoksa onceki doneme bakilir --->
	<cfif get_period.recordcount>
		<cfquery name="check_invoice" datasource="#dsn2#">
			<cfloop query="get_period">
				<cfset onceki_donem = '#dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#'>
				SELECT 
					INVOICE.COMPANY_ID,
					INVOICE.PARTNER_ID,
					INVOICE.CONSUMER_ID,
					INVOICE.INVOICE_NUMBER,
					INVOICE.INVOICE_DATE,
					INVOICE.INVOICE_ID,
					INVOICE.DEPARTMENT_ID,
					INVOICE.DEPARTMENT_LOCATION,
					STOCKS.STOCK_CODE,
					STOCKS.BARCOD,
					#get_period.PERIOD_ID# INVOICE_PERIOD,
					INVOICE_ROW.INVOICE_ROW_ID,
					INVOICE_ROW.WRK_ROW_ID,
					INVOICE_ROW.PRODUCT_ID,
					INVOICE_ROW.AMOUNT,
					INVOICE_ROW.NAME_PRODUCT,
					INVOICE_ROW.PRICE,
					INVOICE_ROW.UNIT
				FROM 
					#onceki_donem#.INVOICE,
					#onceki_donem#.INVOICE_ROW,
					#dsn3_alias#.STOCKS STOCKS
				WHERE 
					INVOICE.INVOICE_ID=INVOICE_ROW.INVOICE_ID AND
					INVOICE.INVOICE_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="591"> AND
					INVOICE.INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.invoice_number#"> AND
					STOCKS.STOCK_ID = INVOICE_ROW.STOCK_ID
				<cfif get_period.currentrow neq get_period.recordcount>UNION ALL</cfif>
			</cfloop>
			ORDER BY
				INVOICE.INVOICE_ID,
				INVOICE_ROW_ID
		</cfquery>
	</cfif>
</cfif>
<cfif not check_invoice.recordcount>
	<table width="95%" height="50" align="center">
		<tr class="color-list">
			<td class="headbold" align="center"><cf_get_lang no ='554.Fatura Kaydı Bulunamadı! Lütfen fatura no girerek tekrar arayınız!'></td>
		</tr>
	</table>
	<cfexit method="exittemplate">
</cfif>
<cfif check_invoice.recordcount>
	<cfquery name="GET_SHIP_AMOUNT" datasource="#dsn2#">
		SELECT
			SUM(SHIP_AMOUNT) SHIP_AMOUNT,
			PRODUCT_ID,
			STOCK_ID,
            WRK_ROW_ID,
			IMPORT_INVOICE_ID
		FROM
		(
			SELECT 
				PRODUCT_ID,
				STOCK_ID,
                WRK_ROW_RELATION_ID WRK_ROW_ID,
				SUM(AMOUNT) AS SHIP_AMOUNT,
				INVOICE_SHIPS.IMPORT_INVOICE_ID
			FROM 
				SHIP,
				SHIP_ROW,
				INVOICE_SHIPS
			WHERE
				SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID AND
				SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
				SHIP_ROW.IMPORT_INVOICE_ID = INVOICE_SHIPS.IMPORT_INVOICE_ID AND
				INVOICE_SHIPS.IMPORT_INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#check_invoice.invoice_id#"> AND
				INVOICE_SHIPS.IMPORT_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#check_invoice.INVOICE_PERIOD#">
			GROUP BY
				PRODUCT_ID,
                WRK_ROW_RELATION_ID,
				STOCK_ID,
				INVOICE_SHIPS.IMPORT_INVOICE_ID
			<cfloop query="get_period">
				<cfset onceki_donem = '#dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#'>
				UNION ALL
				SELECT 
					PRODUCT_ID,
					STOCK_ID,
                    WRK_ROW_RELATION_ID WRK_ROW_ID,
					SUM(AMOUNT) AS SHIP_AMOUNT,
					INVOICE_SHIPS.IMPORT_INVOICE_ID
				FROM 
					#onceki_donem#.SHIP,
					#onceki_donem#.SHIP_ROW,
					#onceki_donem#.INVOICE_SHIPS
				WHERE
					SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID AND
					SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
					SHIP_ROW.IMPORT_INVOICE_ID = INVOICE_SHIPS.IMPORT_INVOICE_ID AND
					INVOICE_SHIPS.IMPORT_INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#check_invoice.invoice_id#"> AND
					INVOICE_SHIPS.IMPORT_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#check_invoice.INVOICE_PERIOD#">
				GROUP BY
					PRODUCT_ID,STOCK_ID,
                    WRK_ROW_RELATION_ID,
					INVOICE_SHIPS.IMPORT_INVOICE_ID
			</cfloop>
		)T1
		GROUP BY
			PRODUCT_ID,
			STOCK_ID,
            WRK_ROW_ID,
			IMPORT_INVOICE_ID
	</cfquery>
	<cfscript>
		for(amount_k=1; amount_k lte GET_SHIP_AMOUNT.recordcount; amount_k=amount_k+1)
		{
			'used_ship_amount_#GET_SHIP_AMOUNT.IMPORT_INVOICE_ID[amount_k]#_#GET_SHIP_AMOUNT.WRK_ROW_ID[amount_k]#' = GET_SHIP_AMOUNT.SHIP_AMOUNT[amount_k];
		}
	</cfscript>
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
	<tr height="35">
		<td class="headbold"><cf_get_lang_main no ='1337.Fatura Bilgileri'></td>
	</tr>
	<cfform name="invoice_product_list" action="#request.self#?fuseaction=stock.popup_add_product_to_ship" method="post">	
		<cfoutput>
		<input type="hidden" name="invoice_id" id="invoice_id" value="#ListDeleteDuplicates(ValueList(check_invoice.INVOICE_ID))#">
		<input type="hidden" name="import_invoice_period" id="import_invoice_period" value="<cfif check_invoice.recordcount>#check_invoice.invoice_period#</cfif>">
		<input type="hidden" name="invoice_departmen" id="invoice_departmen" value="#check_invoice.DEPARTMENT_ID#">
		<input type="hidden" name="invoice_location" id="invoice_location" value="#check_invoice.DEPARTMENT_LOCATION#">
		<input type="hidden" name="inv_row_ids" id="inv_row_ids" value="">
		</cfoutput>
		<cfset head_count = 0>
		<cfoutput query="check_invoice" group="INVOICE_ID">
			<tr>
				<td valign="top">
				<table cellpadding="2" cellspacing="1" border="0" width="100%" class="color-border">
					<tr class="color-list" height="35">
						<td colspan="10">
							<b><cf_get_lang_main no ='107.Cari Hesap'>:</b>
							<cfif len(check_invoice.COMPANY_ID)>
								#get_par_info(check_invoice.COMPANY_ID,1,1,0)#
							<cfelseif len(check_invoice.CONSUMER_ID)>
								#get_cons_info(check_invoice.CONSUMER_ID,1,0)#
							</cfif>
							<cfif len(check_invoice.PARTNER_ID)>- #get_par_info(check_invoice.PARTNER_ID,0,-1,0)#</cfif> 
							&nbsp;&nbsp;<b><cf_get_lang_main no='721.Fatura No'>:</b> #check_invoice.INVOICE_NUMBER#<br/>
							<b><cf_get_lang_main no ='1347.Fatura Tarihi'>:</b> #dateformat(check_invoice.INVOICE_DATE,dateformat_style)#
							&nbsp;&nbsp;<b><cf_get_lang_main no='1351.Depo'>:</b> 
							<cfif len(check_invoice.DEPARTMENT_ID) and len(check_invoice.DEPARTMENT_LOCATION)>
								<cfquery name="GET_DEPARTMENT" datasource="#dsn#">
									SELECT 
										D.DEPARTMENT_HEAD,
										SL.COMMENT
									FROM 
										DEPARTMENT D,
										STOCKS_LOCATION SL
									WHERE 
										D.DEPARTMENT_ID=SL.DEPARTMENT_ID
										AND D.DEPARTMENT_ID = #check_invoice.DEPARTMENT_ID#
										AND SL.LOCATION_ID=#check_invoice.DEPARTMENT_LOCATION# 
								</cfquery>
								#GET_DEPARTMENT.DEPARTMENT_HEAD#-#GET_DEPARTMENT.COMMENT#
							</cfif>
						</td>
					</tr>
					<tr class="color-header" height="22">
						<td class="form-title"><cf_get_lang_main no ='106.Stok Kodu'></td>
						<td class="form-title"><cf_get_lang_main no ='221.Barkod'></td>
						<td class="form-title"><cf_get_lang_main no ='245.Ürün'></td>
						<td width="100" align="right" class="form-title" style="text-align:right;"><cf_get_lang_main no ='261.Tutar'></td>
						<td width="50" align="right" class="form-title" style="text-align:right;"><cf_get_lang_main no ='224.Birim'></td>
						<td width="50" align="right" class="form-title" style="text-align:right;"><cf_get_lang_main no ='224.Birim'> 2</td>
						<td width="55" align="right" class="form-title" style="text-align:right;"><cf_get_lang no ='555.Fatura Miktarı'></td>
						<td width="55" align="right" class="form-title" style="text-align:right;"><cf_get_lang no ='555.Fatura Miktarı'> 2</td>
						<td width="55" align="right" class="form-title" style="text-align:right;"><cf_get_lang no ='556.Çekilen Miktar'></td>
						<td width="55" align="right" class="form-title" style="text-align:right;"><cf_get_lang no ='557.Kalan Miktar'></td>
						<td width="20"><cfif head_count eq 0><input type="checkbox" name="inv_row_ids_all" id="inv_row_ids_all" onclick="all_check();" value=""></cfif></td>
					</tr>
					<cfset input_value = 0>
					<cfif check_invoice.recordcount>
						<cfoutput>
						<cfquery name="INV_ROW_AMOUNT" dbtype="query">
							SELECT SHIP_AMOUNT FROM GET_SHIP_AMOUNT WHERE IMPORT_INVOICE_ID = #check_invoice.invoice_id# AND WRK_ROW_ID='#check_invoice.WRK_ROW_ID#' AND PRODUCT_ID = #check_invoice.PRODUCT_ID#
						</cfquery>
						<cfset 'add_product_amount_#INVOICE_ID#_#WRK_ROW_ID#'=check_invoice.AMOUNT>
						<cfset temp_b=0>
						<tr class="color-row">
							<td>#check_invoice.stock_code#</td>
							<td>#check_invoice.barcod#</td>
							<td>#check_invoice.NAME_PRODUCT#</td>		
							<td align="right" style="text-align:right;">#TLFormat(check_invoice.PRICE,4)#</td>
							<td align="right" style="text-align:right;">#check_invoice.UNIT#</td>
							<td align="right" style="text-align:right;">#check_invoice.UNIT2#</td>
							<td align="right" style="text-align:right;">#check_invoice.AMOUNT#</td>
							<td align="right" style="text-align:right;">#check_invoice.AMOUNT2#</td>
							<td align="right" style="text-align:right;">
								<cfif not (isdefined('is_finish_inv_#INVOICE_ID#_#WRK_ROW_ID#') and evaluate('is_finish_inv_#INVOICE_ID#_#WRK_ROW_ID#') eq 1)>
									<cfif isdefined('used_ship_amount_#INVOICE_ID#_#WRK_ROW_ID#') and len(evaluate('used_ship_amount_#INVOICE_ID#_#WRK_ROW_ID#'))>
										<cfif isdefined('left_product_inv_amount_#INVOICE_ID#_#WRK_ROW_ID#')>
											<cfset temp_a=evaluate('left_product_inv_amount_#INVOICE_ID#_#WRK_ROW_ID#')>
										<cfelse>
											<cfset temp_a=evaluate('used_ship_amount_#INVOICE_ID#_#WRK_ROW_ID#')>
										</cfif>
										<cfif temp_a gte evaluate('add_product_amount_#INVOICE_ID#_#WRK_ROW_ID#')>
											#evaluate('add_product_amount_#INVOICE_ID#_#WRK_ROW_ID#')#
											<cfset temp_b = evaluate('add_product_amount_#INVOICE_ID#_#WRK_ROW_ID#')>
											<cfset 'left_product_inv_amount_#INVOICE_ID#_#WRK_ROW_ID#' = temp_a-evaluate('add_product_amount_#INVOICE_ID#_#WRK_ROW_ID#')>
											<cfset 'add_product_amount_#INVOICE_ID#_#WRK_ROW_ID#'=evaluate('add_product_amount_#INVOICE_ID#_#WRK_ROW_ID#')-temp_a>
										<cfelseif temp_a lt evaluate('add_product_amount_#INVOICE_ID#_#WRK_ROW_ID#')>
											#temp_a#
											<cfset temp_b = temp_a>
											<cfset 'add_product_amount_#INVOICE_ID#_#WRK_ROW_ID#'=evaluate('add_product_amount_#INVOICE_ID#_#WRK_ROW_ID#')-temp_a>
											<cfset 'is_finish_inv_#INVOICE_ID#_#WRK_ROW_ID#'=1>
										</cfif>
									</cfif>
								</cfif>
							</td>
							<td align="right" style="text-align:right;">
								<cfset input_value = check_invoice.AMOUNT-temp_b>
								<cfif input_value gt 0>
									<cfsavecontent variable="message"><cf_get_lang no ='557.Kalan Miktar'></cfsavecontent>
									<cfinput type="text" name="inv_amount_#check_invoice.INVOICE_ROW_ID#" validate="float" class="moneybox" value="#input_value#" range="0,#check_invoice.amount#" style="width:100%" message="#message#">
								<cfelse>
									#input_value#
								</cfif>
							</td>
							<td width="20" align="center"><input type="checkbox" name="inv_row_ids_#currentrow#" id="inv_row_ids_#currentrow#" value="#check_invoice.invoice_row_id#" <cfif evaluate('add_product_amount_#INVOICE_ID#_#WRK_ROW_ID#') lte 0>disabled</cfif>></td>
						</tr>
						</cfoutput>
					</cfif>
				</table>
				<br />
				</td>
			</tr>
			<cfset head_count = head_count + 1>
		</cfoutput>
		<tr>
			<td style="text-align:right;">
				<cfsavecontent variable="message"><cf_get_lang no ='558.İthal Giriş Ekle'></cfsavecontent>
				<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message#' add_function='kontrol()'>
			</td>
		</tr>
	</cfform>
</table>
<script type="text/javascript">
	function kontrol()
	{
		var inv_row_ids='0';
		for(i=1;i<=<cfoutput>#check_invoice.recordcount#</cfoutput>;i++)
		{
			if(document.getElementById("inv_row_ids_"+i).checked == true)
			{
				if(inv_row_ids==0)
					inv_row_ids=document.getElementById('inv_row_ids_'+i).value;
				else
					inv_row_ids +="," +document.getElementById('inv_row_ids_'+i).value;
			}
			if(inv_row_ids!=0)
			{
				document.getElementById('inv_row_ids').value=inv_row_ids;
			}
		}
	}
	function all_check()
	{
		for(i=1;i<=<cfoutput>#check_invoice.recordcount#</cfoutput>;i++)
		if(document.getElementById("inv_row_ids_"+i).disabled==false)
		{
			document.getElementById("inv_row_ids_"+i).checked = document.getElementById('inv_row_ids_all').checked;
		}
	}
</script>
