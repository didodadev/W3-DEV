<cfsetting showdebugoutput="no">
<cfquery name="get_branch" datasource="#DSN#">
	SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #SESSION.EP.COMPANY_ID# 
</cfquery>
<cfquery name="GET_STOCK_NAME" datasource="#DSN3#">
	SELECT
		PRODUCT_NAME,
		STOCK_ID 
	FROM 
		STOCKS 
	WHERE 
		<cfif isdefined("attributes.sid") and len(attributes.sid)>
			STOCK_ID = #attributes.sid#
		<cfelseif isdefined("attributes.pid") and len(attributes.pid)>
			PRODUCT_ID = #attributes.pid#
		<cfelse>
			1=0
		</cfif>
</cfquery>
<cfif GET_STOCK_NAME.RECORDCOUNT eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='58642.Ürün Kaydı Bulunamadı'>");
		window.close;
	</script>
	<cfabort>
</cfif>
<cfscript>
	bugun = CreateDate(year(now()),month(now()),day(now()));
	attributes.son_10_gun = date_add("d",-10,bugun);
	attributes.son_20_gun = date_add("d",-20,bugun);
	attributes.son_30_gun = date_add("d",-30,bugun);
</cfscript>
<cfquery name="GET_STOCK_ALL" datasource="#dsn2#">
	SELECT 
		STOCK_ID,
		STOCK_OUT,
		STOCK_IN,
		D.BRANCH_ID,
		PROCESS_DATE
	FROM
		STOCKS_ROW,
		#DSN_ALIAS#.DEPARTMENT AS D
	WHERE 
		STOCKS_ROW.STORE = D.DEPARTMENT_ID AND 
		<cfif isdefined("attributes.sid") and len(attributes.sid)>
			STOCK_ID = #attributes.sid#
		<cfelseif isdefined("attributes.pid") and len(attributes.pid)>
			PRODUCT_ID = #attributes.pid#
		<cfelse>
			1=0
		</cfif>
		AND PROCESS_TYPE IN (76,761,87) 
		AND PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdate(now())#">
		AND PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.son_30_gun#">
UNION ALL
	SELECT 
		STOCK_ID,
		STOCK_OUT,
		STOCK_IN,
		D.BRANCH_ID,
		PROCESS_DATE
	FROM
		STOCKS_ROW,
		#DSN_ALIAS#.DEPARTMENT AS D
	WHERE 
		STOCKS_ROW.STORE = D.DEPARTMENT_ID AND 
		<cfif isdefined("attributes.sid") and len(attributes.sid)>
			STOCK_ID = #attributes.sid#
		<cfelseif isdefined("attributes.pid") and len(attributes.pid)>
			PRODUCT_ID = #attributes.pid#
		<cfelse>
			1=0
		</cfif>
		AND PROCESS_TYPE IN (78) 
		AND PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdate(now())#">
		AND PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.son_30_gun#">
</cfquery>
<cfif GET_STOCK_ALL.RECORDCOUNT>
	<cfquery name="get_stock_of_10" dbtype="query">
		SELECT 
			STOCK_ID,
			SUM(STOCK_IN-STOCK_OUT) AS AMOUNT,
			BRANCH_ID
		FROM
			GET_STOCK_ALL
		WHERE 
			PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.son_10_gun#">
		GROUP BY
			STOCK_ID,
			BRANCH_ID
	</cfquery>
	<cfquery name="get_stock_of_20" dbtype="query">
		SELECT 
			STOCK_ID,SUM(STOCK_IN-STOCK_OUT) AS AMOUNT,BRANCH_ID
		FROM
			GET_STOCK_ALL
		WHERE  
			PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.son_20_gun#">
		GROUP BY
			STOCK_ID,
			BRANCH_ID
	</cfquery>
	<cfquery name="get_stock_of_30" dbtype="query">
		SELECT 
			STOCK_ID,SUM(STOCK_IN-STOCK_OUT) AS AMOUNT,BRANCH_ID
		FROM
			GET_STOCK_ALL
		WHERE 
			PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.son_30_gun#">
		GROUP BY
			STOCK_ID,
			BRANCH_ID
	</cfquery>
	<cfoutput query="get_stock_of_10">
		<cfset "amount10_#GET_STOCK_NAME.stock_id#_#branch_id#" = AMOUNT>
	</cfoutput>
	<cfoutput query="get_stock_of_20">
		<cfset "amount20_#GET_STOCK_NAME.stock_id#_#branch_id#" = AMOUNT>
	</cfoutput>
	<cfoutput query="get_stock_of_30">
		<cfset "amount30_#GET_STOCK_NAME.stock_id#_#branch_id#" = AMOUNT>
	</cfoutput>
</cfif>
<cfset amount10_total=0>
<cfset amount20_total=0>
<cfset amount30_total=0>
<cf_grid_list>
	<thead>
		<tr>
			<th colspan="4"><cf_get_lang dictionary_id='58037.Alış Durumları'> : <cfoutput>#GET_STOCK_NAME.PRODUCT_NAME#</cfoutput></th>
		</tr>
		<tr>
			<th width="150" class="txtboldblue"><cf_get_lang dictionary_id='57453.Şube'></th>
			<th class="txtboldblue" nowrap="nowrap">10 <cf_get_lang dictionary_id='57490.Gün'></th>
			<th class="txtboldblue" nowrap="nowrap">20 <cf_get_lang dictionary_id='57490.Gün'></th>
			<th class="txtboldblue" nowrap="nowrap">30 <cf_get_lang dictionary_id='57490.Gün'></th>
		</tr>
	</thead>
    <tbody>
		<cfoutput query="get_branch">
			<tr>
				<td width="65">#BRANCH_NAME#</td>
				<td  style="text-align:right;">
				<cfif isdefined('amount10_#GET_STOCK_NAME.stock_id#_#branch_id#')>
					#TLFormat(evaluate('amount10_#GET_STOCK_NAME.stock_id#_#branch_id#'))#
					<cfset amount10_total=amount10_total+evaluate('amount10_#GET_STOCK_NAME.stock_id#_#branch_id#')>
				<cfelse>
					#TLFormat(0)#
				</cfif>
				</td>
				<td  style="text-align:right;">
				<cfif isdefined('amount20_#GET_STOCK_NAME.stock_id#_#branch_id#')>
					#TLFormat(evaluate('amount20_#GET_STOCK_NAME.stock_id#_#branch_id#'))#
					<cfset amount20_total=amount20_total+evaluate('amount20_#GET_STOCK_NAME.stock_id#_#branch_id#')>
				<cfelse>
					#TLFormat(0)#
				</cfif>
				</td>
				<td  style="text-align:right;">
				<cfif isdefined('amount30_#GET_STOCK_NAME.stock_id#_#branch_id#')>
					#TLFormat(evaluate('amount30_#GET_STOCK_NAME.stock_id#_#branch_id#'))#
					<cfset amount30_total=amount30_total+evaluate('amount30_#GET_STOCK_NAME.stock_id#_#branch_id#')>
				<cfelse>
					#TLFormat(0)#
				</cfif>
				</td>
			</tr>
		</cfoutput>
    </tbody>
    <tfoot>
		<tr>
			<td><cf_get_lang dictionary_id='57492.Toplam'></td>
			<td style="text-align:right;"><cfoutput>#TLFormat(amount10_total)#</cfoutput></td>
			<td style="text-align:right;"><cfoutput>#TLFormat(amount20_total)#</cfoutput></td>
			<td style="text-align:right;"><cfoutput>#TLFormat(amount30_total)#</cfoutput></td>
		</tr>
    </tfoot>
</cf_grid_list>

