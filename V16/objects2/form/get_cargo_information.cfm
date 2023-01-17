<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.city_id") and len(attributes.city_id)>
	<cfset sehir_ = attributes.city_id> 
<cfelse>
	<cfif isdefined("session.ww.userid") or isdefined("session.pp.userid")>
		<cfif isdefined("session.pp.userid")>
			<cfquery name="get_sehir_" datasource="#dsn#">
				SELECT CITY FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
			</cfquery>
			<cfif len(get_sehir_.CITY)>
				<cfset sehir_ = get_sehir_.CITY>
			<cfelse>
				<cfset sehir_ = ''>
			</cfif>
		<cfelseif isdefined("session.ww.userid")>
			<cfquery name="get_sehir_" datasource="#dsn#">
				SELECT WORK_CITY_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			</cfquery>
			<cfif len(get_sehir_.WORK_CITY_ID)>
				<cfset sehir_ = get_sehir_.WORK_CITY_ID>
			<cfelse>
				<cfset sehir_ = ''>
			</cfif>	
		</cfif>
	<cfelse>
		<cfset sehir_ = ''>
	</cfif>
</cfif>
<cfquery name="get_cities" datasource="#dsn#">
	SELECT * FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
</cfquery>
<select name="city_id" id="city_id">
	<option value="">Seçiniz</option>
	<cfoutput query="get_cities">
		<option value="#city_id#" <cfif len(sehir_) and sehir_ eq city_id>selected</cfif>>#city_name#</option>
	</cfoutput>
</select>
<input type="button" value="Kargo Hesapla" onClick="gonder_city();">

<cfif not len(sehir_)>

<cfelse>
	<cfquery name="get_city" datasource="#dsn#">
		SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sehir_#">
	</cfquery>
	<br/>
	<br/>
	<cfif len(attributes.cargo_product_id)>
		<cfquery name="get_asil_row" datasource="#dsn1#" maxrows="1">
			SELECT 
				PU.DIMENTION
			FROM
				STOCKS S,
				PRODUCT P,
				PRODUCT_UNIT PU
			WHERE
				S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND
				S.PRODUCT_ID=PU.PRODUCT_ID AND
				S.PRODUCT_ID=P.PRODUCT_ID AND
				S.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cargo_product_id#">
		</cfquery>
		<cfif len(get_asil_row.DIMENTION) and listlen(get_asil_row.DIMENTION,'*') eq 3>
			<cfset urun_desi = (replace(listgetat(get_asil_row.DIMENTION,1,'*'),',','.','all') * replace(listgetat(get_asil_row.DIMENTION,2,'*'),',','.','all') * replace(listgetat(get_asil_row.DIMENTION,3,'*'),',','.','all') / 3000)>
		<cfelse>
			<cfset urun_desi = 0>
		</cfif>
		<cfset toplam_desi = urun_desi>
	<cfelse>
		<cfset urun_desi = 0>
		<cfset toplam_desi = 0>
	</cfif>
	<cfquery name="get_rows" datasource="#dsn3#">
		SELECT 
			OPR.*,
			S.STOCK_CODE,
			S.STOCK_CODE_2,
			PU.DIMENTION,
			P.IS_INVENTORY
		FROM
			ORDER_PRE_ROWS OPR,
			#dsn1_alias#.STOCKS S,
			#dsn1_alias#.PRODUCT_UNIT PU,
			#dsn1_alias#.PRODUCT P
		WHERE
			OPR.STOCK_ID = S.STOCK_ID AND
			S.PRODUCT_UNIT_ID=PU.PRODUCT_UNIT_ID AND
			S.PRODUCT_ID=PU.PRODUCT_ID AND
			S.PRODUCT_ID=P.PRODUCT_ID AND
			<cfif isdefined("session.pp")>
				OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
			<cfelseif isdefined("session.ww.userid")>
				OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			<cfelseif isdefined("session.ep")>
				OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
			<cfelseif not isdefined("session_base.userid")>
				OPR.RECORD_GUEST = 1 AND 
				OPR.RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#"> AND
				OPR.COOKIE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#"> AND
			</cfif>
			OPR.PRODUCT_ID IS NOT NULL
		ORDER BY 
		<cfif isdefined('attributes.is_basket_use_detail_promotion') and attributes.is_basket_use_detail_promotion eq 1>
			ISNULL(OPR.IS_PROM_ASIL_HEDIYE,0) ASC,
			OPR.PRICE_KDV DESC
		<cfelse>
			OPR.ORDER_ROW_ID
		</cfif>
	</cfquery>
	<cfoutput query="get_rows">
		<cfif len(DIMENTION) and listlen(DIMENTION,'*') eq 3>
			<cfset toplam_desi = toplam_desi + (replace(listgetat(DIMENTION,1,'*'),',','.','all') * replace(listgetat(DIMENTION,2,'*'),',','.','all') * replace(listgetat(DIMENTION,3,'*'),',','.','all') / 3000)>
		</cfif>
	</cfoutput>
	<cfquery name="get_cargos1" datasource="#dsn#">
		SELECT DISTINCT
			SMP.COMPANY_ID,
			C.NICKNAME,
			SMP.SHIP_METHOD_PRICE_ID,
			SMP.OTHER_MONEY
		FROM 
			SHIP_METHOD_PRICE SMP,
			SHIP_METHOD_PRICE_ROW SMPR,
			COMPANY C 
		WHERE 
			SMP.CALCULATE_TYPE = 1 AND 
			SMPR.PACKAGE_TYPE_ID = 1 AND 
			SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND 
			SMP.PRODUCT_ID IS NOT NULL AND 
			SMP.COMPANY_ID = C.COMPANY_ID AND 
			SMP.MULTI_CITY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#sehir_#,%"> AND 
			SMPR.CUSTOMER_PRICE > 0
	</cfquery>
	<table width="98%">
		<tr>
			<td colspan="4" class="headbold"><cfoutput>#get_city.CITY_NAME#</cfoutput> ili için kargo bedeli</td>
		</tr>
		<tr bgcolor="666666" style="color:FFFFFF;font-weight:bold;" height="25">
			<td>Gönderici Firma</td>
			<cfif len(attributes.cargo_product_id)><td width="100"  style="text-align:right;">Bu Ürün</td></cfif>
			<td width="100"  style="text-align:right;">Sepet</td>
			<td width="100"  style="text-align:right;">Toplam</td>
		</tr>
	<cfif get_cargos1.recordcount>
		<cfoutput query="get_cargos1">
				<cfset total_tutar_ = 0>
				<cfset urun_tutar_ = 0>
				<cfset sepet_tutar_ = 0>
				
				<cfquery name="get_total" datasource="#dsn#">
					SELECT 
						SMP.COMPANY_ID,
						SMPR.CUSTOMER_PRICE,
						SMPR.OTHER_MONEY,
						C.NICKNAME,
						SMP.SHIP_METHOD_PRICE_ID
					FROM 
						SHIP_METHOD_PRICE SMP,
						SHIP_METHOD_PRICE_ROW SMPR,
						COMPANY C 
					WHERE 
						SMP.CALCULATE_TYPE = 1 AND 
						SMPR.PACKAGE_TYPE_ID = 1 AND 
						SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND 
						SMP.PRODUCT_ID IS NOT NULL AND 
						SMP.COMPANY_ID = C.COMPANY_ID AND 
						SMP.MULTI_CITY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#sehir_#,%"> AND 
						SMPR.CUSTOMER_PRICE > 0 AND
						SMPR.START_VALUE <= <cfqueryparam cfsqltype="cf_sql_integer" value="#toplam_desi#"> AND
						SMPR.FINISH_VALUE >= <cfqueryparam cfsqltype="cf_sql_integer" value="#toplam_desi#"> AND
						SMPR.SHIP_METHOD_PRICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_method_price_id#">
				</cfquery>
				<cfif get_total.recordcount>
					<cfset total_tutar_ = get_total.CUSTOMER_PRICE>
				<cfelse>
					<cfquery name="get_total_types" datasource="#dsn#" maxrows="1">
						SELECT 
							SMP.COMPANY_ID,
							SMPR.CUSTOMER_PRICE,
							SMPR.OTHER_MONEY,
							C.NICKNAME,
							SMP.SHIP_METHOD_PRICE_ID
						FROM 
							SHIP_METHOD_PRICE SMP,
							SHIP_METHOD_PRICE_ROW SMPR,
							COMPANY C 
						WHERE 
							SMP.CALCULATE_TYPE = 1 AND 
							SMPR.PACKAGE_TYPE_ID = 1 AND 
							SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND 
							SMP.PRODUCT_ID IS NOT NULL AND 
							SMP.COMPANY_ID = C.COMPANY_ID AND 
							SMP.MULTI_CITY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#sehir_#,%"> AND 
							SMPR.CUSTOMER_PRICE > 0 AND
							SMPR.FINISH_VALUE < <cfqueryparam cfsqltype="cf_sql_integer" value="#toplam_desi#"> AND
							SMP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
						ORDER BY
							SMPR.FINISH_VALUE DESC
					</cfquery>
					<cfif get_total_types.recordcount>
						<cfquery name="get_total_son" datasource="#dsn#">
							SELECT 
								(#get_total_types.CUSTOMER_PRICE# + (PRICE * (#toplam_desi# - MAX_LIMIT))) AS TUTAR 
							FROM 
								SHIP_METHOD_PRICE SMP						
							WHERE 
								SMP.CALCULATE_TYPE = 1 AND 
								SMP.PRODUCT_ID IS NOT NULL AND 
								SMP.PRICE > 0 AND 
								SMP.MAX_LIMIT <= <cfqueryparam cfsqltype="cf_sql_integer" value="#toplam_desi#"> AND 
								SMP.SHIP_METHOD_PRICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_total_types.ship_method_price_id#">
						</cfquery>
						<cfif get_total_son.recordcount>
							<cfset total_tutar_ = get_total_son.TUTAR>
						</cfif>
					</cfif>
				</cfif>
				
				<cfif get_rows.recordcount>
					<cfquery name="get_sepet" datasource="#dsn#">
						SELECT 
							SMP.COMPANY_ID,
							SMPR.CUSTOMER_PRICE,
							SMPR.OTHER_MONEY,
							C.NICKNAME,
							SMP.SHIP_METHOD_PRICE_ID
						FROM 
							SHIP_METHOD_PRICE SMP,
							SHIP_METHOD_PRICE_ROW SMPR,
							COMPANY C 
						WHERE 
							SMP.CALCULATE_TYPE = 1 AND 
							SMPR.PACKAGE_TYPE_ID = 1 AND 
							SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND 
							SMP.PRODUCT_ID IS NOT NULL AND 
							SMP.COMPANY_ID = C.COMPANY_ID AND 
							SMP.MULTI_CITY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#sehir_#,%"> AND 
							SMPR.CUSTOMER_PRICE > 0 AND
							SMPR.START_VALUE <= <cfqueryparam cfsqltype="cf_sql_integer" value="#toplam_desi-urun_desi#"> AND
							SMPR.FINISH_VALUE >= <cfqueryparam cfsqltype="cf_sql_integer" value="#toplam_desi-urun_desi#"> AND
							SMPR.SHIP_METHOD_PRICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_method_price_id#">
					</cfquery>
					<cfif get_sepet.recordcount>
						<cfset sepet_tutar_ = get_sepet.CUSTOMER_PRICE>
					<cfelse>
						<cfquery name="get_sepet_types" datasource="#dsn#" maxrows="1">
							SELECT 
								SMP.COMPANY_ID,
								SMPR.CUSTOMER_PRICE,
								SMPR.OTHER_MONEY,
								C.NICKNAME,
								SMP.SHIP_METHOD_PRICE_ID
							FROM 
								SHIP_METHOD_PRICE SMP,
								SHIP_METHOD_PRICE_ROW SMPR,
								COMPANY C 
							WHERE 
								SMP.CALCULATE_TYPE = 1 AND 
								SMPR.PACKAGE_TYPE_ID = 1 AND 
								SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND 
								SMP.PRODUCT_ID IS NOT NULL AND 
								SMP.COMPANY_ID = C.COMPANY_ID AND 
								SMP.MULTI_CITY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#sehir_#,%"> AND 
								SMPR.CUSTOMER_PRICE > 0 AND
								SMPR.FINISH_VALUE < <cfqueryparam cfsqltype="cf_sql_integer" value="#toplam_desi - urun_desi#"> AND
								SMP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
							ORDER BY
								SMPR.FINISH_VALUE DESC
						</cfquery>
						<cfif get_sepet_types.recordcount>
							<cfquery name="get_sepet_son" datasource="#dsn#">
								SELECT 
									(#get_sepet_types.CUSTOMER_PRICE# + (PRICE * (#toplam_desi - urun_desi# - MAX_LIMIT))) AS TUTAR 
								FROM 
									SHIP_METHOD_PRICE SMP						
								WHERE 
									SMP.CALCULATE_TYPE = 1 AND 
									SMP.PRODUCT_ID IS NOT NULL AND 
									SMP.PRICE > 0 AND 
									SMP.MAX_LIMIT <= <cfqueryparam cfsqltype="cf_sql_integer" value="#toplam_desi - urun_desi#"> AND 
									SMP.SHIP_METHOD_PRICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_sepet_types.SHIP_METHOD_PRICE_ID#">
							</cfquery>
							<cfif get_sepet_son.recordcount>
								<cfset sepet_tutar_ = get_sepet_son.TUTAR>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
				
				<cfquery name="get_urun" datasource="#dsn#">
					SELECT 
						SMP.COMPANY_ID,
						SMPR.CUSTOMER_PRICE,
						SMPR.OTHER_MONEY,
						C.NICKNAME,
						SMP.SHIP_METHOD_PRICE_ID
					FROM 
						SHIP_METHOD_PRICE SMP,
						SHIP_METHOD_PRICE_ROW SMPR,
						COMPANY C 
					WHERE 
						SMP.CALCULATE_TYPE = 1 AND 
						SMPR.PACKAGE_TYPE_ID = 1 AND 
						SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND 
						SMP.PRODUCT_ID IS NOT NULL AND 
						SMP.COMPANY_ID = C.COMPANY_ID AND 
						SMP.MULTI_CITY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#sehir_#,%"> AND 
						SMPR.CUSTOMER_PRICE > 0 AND
						SMPR.START_VALUE <= <cfqueryparam cfsqltype="cf_sql_integer" value="#urun_desi#"> AND
						SMPR.FINISH_VALUE >= <cfqueryparam cfsqltype="cf_sql_integer" value="#urun_desi#"> AND
						SMPR.SHIP_METHOD_PRICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_method_price_id#">
				</cfquery>
				<cfif get_urun.recordcount>
					<cfset urun_tutar_ = get_urun.CUSTOMER_PRICE>
				<cfelse>
					<cfquery name="get_urun_types" datasource="#dsn#" maxrows="1">
						SELECT 
							SMP.COMPANY_ID,
							SMPR.CUSTOMER_PRICE,
							SMPR.OTHER_MONEY,
							C.NICKNAME,
							SMP.SHIP_METHOD_PRICE_ID
						FROM 
							SHIP_METHOD_PRICE SMP,
							SHIP_METHOD_PRICE_ROW SMPR,
							COMPANY C 
						WHERE 
							SMP.CALCULATE_TYPE = 1 AND 
							SMPR.PACKAGE_TYPE_ID = 1 AND 
							SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND 
							SMP.PRODUCT_ID IS NOT NULL AND 
							SMP.COMPANY_ID = C.COMPANY_ID AND 
							SMP.MULTI_CITY_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#sehir_#,%"> AND 
							SMPR.CUSTOMER_PRICE > 0 AND
							SMPR.FINISH_VALUE < <cfqueryparam cfsqltype="cf_sql_integer" value="#urun_desi#"> AND
							SMP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
						ORDER BY
							SMPR.FINISH_VALUE DESC
					</cfquery>
					<cfif get_urun_types.recordcount>
						<cfquery name="get_urun_son" datasource="#dsn#">
							SELECT 
								(#get_urun_types.CUSTOMER_PRICE# + (PRICE * (#urun_desi# - MAX_LIMIT))) AS TUTAR 
							FROM 
								SHIP_METHOD_PRICE SMP						
							WHERE 
								SMP.CALCULATE_TYPE = 1 AND 
								SMP.PRODUCT_ID IS NOT NULL AND 
								SMP.PRICE > 0 AND 
								SMP.MAX_LIMIT <= <cfqueryparam cfsqltype="cf_sql_integer" value="#urun_desi#"> AND 
								SMP.SHIP_METHOD_PRICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_urun_types.ship_method_price_id#">
						</cfquery>
						<cfif get_urun_son.recordcount>
							<cfset urun_tutar_ = get_urun_son.TUTAR>
						</cfif>
					</cfif>
				</cfif>
			<cfif total_tutar_ gt 0 or sepet_tutar_ gt 0 or urun_tutar_ gt 0>
			<tr bgcolor="f5f5f5">
				<td>#get_cargos1.NICKNAME#</td>
				<cfif len(attributes.cargo_product_id)><td  style="text-align:right;">#TLFORMAT(urun_tutar_)# #get_cargos1.OTHER_MONEY#</td></cfif>
				<td  style="text-align:right;">#tlformat(sepet_tutar_)# #get_cargos1.OTHER_MONEY#</td>
				<td  style="text-align:right;">#tlformat(total_tutar_)# #get_cargos1.OTHER_MONEY#</td>
			</tr>
			</cfif>
		</cfoutput>
	</cfif>
	</table>
</cfif>
