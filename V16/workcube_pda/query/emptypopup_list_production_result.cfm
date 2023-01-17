<cfsetting showdebugoutput="no">
<cfif isDate(attributes.start_date)><cf_date tarih='attributes.start_date'><cfelse><cfset attributes.start_date = ""></cfif>
<cfif isDate(attributes.start_date2)><cf_date tarih='attributes.start_date2'><cfelse><cfset attributes.start_date2 = ""></cfif>
<cfif isDate(attributes.finish_date)><cf_date tarih='attributes.finish_date'><cfelse><cfset attributes.finish_date = ""></cfif>
<cfif isDate(attributes.finish_date2)><cf_date tarih='attributes.finish_date2'><cfelse><cfset attributes.finish_date2 = ""></cfif>
<cfquery name="GET_PERIOD" datasource="#DSN#">
	SELECT PERIOD_YEAR,OUR_COMPANY_ID,PERIOD_ID FROM SETUP_PERIOD
</cfquery>
<cfquery name="GET_PRODUCTION_RESULTS" datasource="#DSN3#">
	SELECT
		PORR.TYPE,
		POR.P_ORDER_ID,
		PORR.AMOUNT,
		PORR.FIRE_AMOUNT,
		POR.PR_ORDER_ID,
		POR.RESULT_NO,
		POR.START_DATE,
		POR.FINISH_DATE,
		P.PRODUCT_ID,
		P.PRODUCT_NAME
	FROM
		PRODUCTION_ORDER_RESULTS POR,
		PRODUCTION_ORDER_RESULTS_ROW PORR,
		#dsn1_alias#.STOCKS AS S,
		#dsn1_alias#.PRODUCT AS P
	WHERE
		POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
		PORR.TYPE <> 2 AND <!--- Sarflar Gelmeyecek --->
		PORR.STOCK_ID IS NOT NULL AND
		S.STOCK_ID = PORR.STOCK_ID AND
		P.PRODUCT_ID = S.PRODUCT_ID
		<cfif len(attributes.station_id)>
			AND POR.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#">
		<cfelseif len(authority_station_id_list)><!--- eğer istasyon seçilmemiş ise,sadece yetkili istasyonlar gelsin. --->
			AND POR.STATION_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#authority_station_id_list#" list="yes">)
		</cfif>
		<cfif len(attributes.product_id) and len(attributes.product_name)>
			AND P.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		</cfif>
		<cfif len(attributes.start_date)>
			AND POR.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		</cfif>
		<cfif len(attributes.start_date2)>
			<cfset attributes.start_date2 = CreateDateTime(dateformat(attributes.start_date2,'YYYY'),dateformat(attributes.start_date2,'MM'),dateformat(attributes.start_date2,'DD'),23,59,00)>
			AND POR.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date2#">
		</cfif>
		<cfif len(attributes.finish_date)>
			AND POR.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		</cfif>
		<cfif len(attributes.finish_date2)>
			<cfset attributes.finish_date2 = CreateDateTime(dateformat(attributes.finish_date2,'YYYY'),dateformat(attributes.finish_date2,'MM'),dateformat(attributes.finish_date2,'DD'),23,59,00)>
			AND POR.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date2#">
		</cfif>
		<cfif len(attributes.stock_fis_type)>
			<cfif attributes.stock_fis_type eq 1>
				AND POR.PR_ORDER_ID IN
				(
					<cfloop query="get_period">
						SELECT SF.PROD_ORDER_RESULT_NUMBER FROM #dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#.STOCK_FIS SF WHERE SF.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
						<cfif currentrow neq get_period.recordcount> UNION ALL </cfif> 
					</cfloop>	
				)
			<cfelse>
				AND POR.PR_ORDER_ID NOT IN
				(
					<cfloop query="get_period">
						SELECT SF.PROD_ORDER_RESULT_NUMBER FROM #dsn#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#.STOCK_FIS SF WHERE SF.PROD_ORDER_RESULT_NUMBER = POR.PR_ORDER_ID
						<cfif currentrow neq get_period.recordcount> UNION ALL </cfif> 
					</cfloop>	
				)
			</cfif>
		</cfif>
	ORDER BY
		POR.PR_ORDER_ID DESC
</cfquery>
<cf_box title="Üretim Sonuçları" body_style="overflow-y:scroll;height:100px;width:250px;">
<table width="98%" cellpadding="2" cellspacing="1" border="0" class="color-border" align="center">
	<tr class="color-header">
		<td class="form-title">No</td>
		<td class="form-title">Tarih</td>
		<td class="form-title">Ürün</td>
		<td class="form-title" style="text-align:right;">Miktar</td>
	</tr>
	<cfif get_production_results.recordcount>
		<cfoutput query="get_production_results">
			<tr class="color-row">
				<td><a href="#request.self#?fuseaction=pda.form_upd_production_result&p_order_id=#p_order_id#&pr_order_id=#pr_order_id#" class="tableyazi">#result_no#</a></td>
				<td>#DateFormat(start_date,'dd/mm/yy')# - #DateFormat(finish_date,'dd/mm/yy')#</td>
				<td>#Left(product_name,10)#</td>
				<td style="text-align:right;">#amount#</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row">
			<td colspan="5">Kayıt Yok!</td>
		</tr>
	</cfif>
</table>
</cf_box>
