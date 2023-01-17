<cfscript>
	bugun = CreateDate(year(now()),month(now()),day(now()));
	attributes.son_10_gun = date_add("d",-10,bugun);
	attributes.son_20_gun = date_add("d",-20,bugun);
	attributes.son_30_gun = date_add("d",-30,bugun);
	table_array = ArrayNew(1);
	stok_list = "";
	proname_list = "";
	product_ids = "";
	spect_var_id_list = "";
	spect_var_name_list = "";
	is_production_list = "";
</cfscript>
<cfinclude template="../query/get_order_stock_details.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32444.Sipariş Stok Raporu'></cfsavecontent>
<cf_box title="#message#:#GET_ORDER_HEAD.ORDER_HEAD#">
<cfset height1 = (ListLen(stok_list)*50+50)>
	<cf_grid_list> 
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57452.Stok'></th>
				<th width="45" ><cf_get_lang dictionary_id='58120.Gerçek Stok'></th>
				<th width="65" ><cf_get_lang dictionary_id='32544.Kullanılabilir'></th>
				<th width="50" ><cf_get_lang dictionary_id='29750.Rezerve'></th>
				<th width="50" ><cf_get_lang dictionary_id='29750.Beklenen'></th>
				<cfoutput query="get_departments">
					<th width="65" >#department_head#</th>
				</cfoutput> 
			</tr>
		</thead>
		<tbody>
			<cfloop from="1" to="#ListLen(stok_list)#" index="i">
			<cfoutput>
				<tr>
					<td>#ListGetAt(proname_list,i,';')#<br/>
					</td>
					<!--- gerçek stok --->
					<td class="moneybox">
					<cfquery name="getStockprofile" dbtype="query">
						SELECT 
							SALEABLE_STOCK,
							REAL_STOCK,
							RESERVE_SALE_ORDER_STOCK,
							RESERVE_PURCHASE_ORDER_STOCK
						FROM 
							get_stock_profile
						WHERE 
							STOCK_ID = #ListGetAt(stok_list,i)#
					</cfquery>	
					#Tlformat(getStockprofile.real_stock)#
					</td>
					<!--- kullanılabilir stok --->
					<td class="moneybox">
					<cfif len(getStockprofile.saleable_stock)>
						#Tlformat(getStockprofile.saleable_stock)#
					</cfif>
					</td>
					<!--- alınan sipariş --->
					<td class="moneybox">#Tlformat(getStockprofile.reserve_sale_order_stock)#</td>
					<!--- verilen sipariş --->
					<td class="moneybox">#Tlformat(getStockprofile.reserve_purchase_order_stock)#</td>
					<cfloop query="get_departments">
						<td class="moneybox">
						<cfquery name="get_pro_stok" dbtype="query">
							SELECT PRODUCT_STOCK FROM GET_STOCKS_ALL WHERE PRODUCT_ID = #ListGetAt(PRODUCT_IDS,i)# AND STOCK_ID = #ListGetAt(stok_list,i)# AND DEPARTMENT_ID = #DEPARTMENT_ID#
						</cfquery>
						#Tlformat(get_pro_stok.product_stock)#
						</td>
					</cfloop> 
				</tr>
			</cfoutput>
			<cfoutput>
			<cfif listlen(spect_var_id_list) gte i and len(listgetat(spect_var_id_list,i,',')) and (listgetat(spect_var_id_list,i,',') neq 0)>
			<tr>
				<td colspan="26">Spec : #listgetat(spect_var_name_list,i,';')#</td>
			</tr>
			<cfquery name="GET_SPECT" datasource="#dsn3#">
				SELECT
					SPECTS.SPECT_VAR_NAME,
					SPECTS_ROW.PRODUCT_NAME,
					SPECTS_ROW.PRODUCT_ID
				FROM
					SPECTS,
					SPECTS_ROW
				WHERE
					SPECTS.SPECT_VAR_ID = SPECTS_ROW.SPECT_ID AND
					SPECTS_ROW.SPECT_ID = #listgetat(spect_var_id_list,i,',')# AND
					SPECTS_ROW.PRODUCT_ID IS NOT NULL
			</cfquery>
			<cfset spect_list_product = "">
			<cfloop query="get_spect">
				<cfset spect_list_product = ListAppend(spect_list_product,get_spect.product_id,",")>
			</cfloop>
			<cfset spect_list_product = listSort(ListDeleteDuplicates(spect_list_product),"numeric","asc",",")>
			<cfquery name="GET_STOCKS_ALL_SPEC" datasource="#DSN2#">
				SELECT 
					SUM(GSB.PRODUCT_STOCK) AS PRODUCT_STOCK,
					D.DEPARTMENT_ID,
					GSB.PRODUCT_ID,
					D.DEPARTMENT_HEAD
				FROM
					GET_STOCK_PRODUCT GSB,
					#dsn_alias#.DEPARTMENT D
				WHERE
			<cfif len(spect_list_product)>
				GSB.PRODUCT_ID IN (#spect_list_product#) AND
			</cfif>
			GSB.STOCK_ID IN (#stok_list#) AND 
			D.DEPARTMENT_ID = GSB.DEPARTMENT_ID
			GROUP BY
			D.DEPARTMENT_ID, GSB.PRODUCT_ID, D.DEPARTMENT_HEAD
			</cfquery>
			<cfquery name='get_stock_reserved_azalan_spec' datasource="#dsn3#">
				SELECT 
				SUM(STOCK_AZALT) AS AZALAN,SUM(STOCK_ARTIR) AS ARTAN,PRODUCT_ID 
				FROM 
				GET_STOCK_RESERVED 
				WHERE
				<cfif len(spect_list_product)>
				PRODUCT_ID IN (#spect_list_product#) AND
				</cfif>
				STOCK_ID IN (#stok_list#)
				GROUP BY
				PRODUCT_ID		
			</cfquery>
			<cfquery name="GET_PRODUCT_TOTAL_STOCK_SPEC" datasource="#dsn2#">
				SELECT 
					PRODUCT_TOTAL_STOCK,PRODUCT_ID
				FROM 
					GET_PRODUCT_STOCK 
				WHERE
					<cfif len(spect_list_product)>
						PRODUCT_ID IN (#spect_list_product#)
					<cfelse>
						1=2
					</cfif>
			</cfquery>
			<cfloop query="get_spect">
			<tr>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_spect.product_name#</td>
				<td>
					<cfquery name="get_gs_spec" dbtype="query">
						SELECT PRODUCT_TOTAL_STOCK FROM GET_PRODUCT_TOTAL_STOCK_SPEC WHERE PRODUCT_ID = #get_spect.product_id# 
					</cfquery>
					<cfquery name="get_as_spec" dbtype="query">
						SELECT * FROM get_stock_reserved_azalan_spec WHERE PRODUCT_ID = #get_spect.product_id# 
					</cfquery>
					<cfquery name="get_vs_spec" dbtype="query">
						SELECT * FROM get_stock_reserved_azalan_spec WHERE PRODUCT_ID = #get_spect.product_id# 
					</cfquery>
					<cfquery name="get_stock_ks_spec" dbtype="query">
						SELECT SUM(PRODUCT_STOCK)  AS PRODUCT_STOCK FROM  GET_STOCKS_ALL_SPEC WHERE PRODUCT_ID = #get_spect.product_id# 
					</cfquery>
					<cfquery name="get_pro_spec" dbtype="query">
						SELECT SUM(PRODUCT_STOCK)  AS PRODUCT_STOCK FROM  GET_STOCKS_ALL_SPEC WHERE PRODUCT_ID = #get_spect.product_id# 
					</cfquery>				
					#get_gs_spec.product_total_stock#		
				</td>
				<td>
					<cfif len(get_pro_spec.PRODUCT_STOCK)>
					<cfset total_stk=get_pro_spec.PRODUCT_STOCK>
					<cfif len(get_as_spec.AZALAN)><cfset total_stk=total_stk-get_as_spec.AZALAN></cfif>
					<cfif len(get_vs_spec.ARTAN)><cfset total_stk=total_stk-get_vs_spec.ARTAN></cfif>
						#total_stk#
					</cfif>
				</td>
				<td>#get_as_spec.azalan#</td>
				<td>#get_vs_spec.artan#</td>
					<cfset value_product_id = get_spect.product_id>
					<cfloop query="get_departments">
				<td>
					<cfquery name="get_pro_stok_spec" dbtype="query">
						SELECT PRODUCT_STOCK FROM  GET_STOCKS_ALL_SPEC WHERE PRODUCT_ID = #value_product_id#  AND DEPARTMENT_ID = #DEPARTMENT_ID#
					</cfquery>#get_pro_stok_spec.product_stock#
				</td>
				</cfloop> 
			</tr>
			</cfloop>
			</tr>
			<cfelse>
			<cfquery name="GET_SUB_PRODUCTS" datasource="#dsn3#">
				(
				SELECT 
					S.PRODUCT_NAME,
					S.PRODUCT_ID
				FROM 
					PRODUCT_TREE,
					STOCKS S
				WHERE 
					S.COMPANY_ID IS NULL AND
					PRODUCT_TREE.STOCK_ID = #listgetat(stok_list,i,',')# AND 
					S.STOCK_ID=PRODUCT_TREE.RELATED_ID AND 
					( S.IS_PURCHASE=1 OR S.IS_PRODUCTION=1 )
					)
						UNION
					(
				SELECT 
					S.PRODUCT_NAME,
					S.PRODUCT_ID
				FROM 
					PRODUCT_TREE,
					STOCKS S,
					#dsn_alias#.COMPANY C
				WHERE 
					C.COMPANY_ID=S.COMPANY_ID AND
					PRODUCT_TREE.STOCK_ID = #listgetat(stok_list,i,',')# AND 
					S.STOCK_ID=PRODUCT_TREE.RELATED_ID AND
					( S.IS_PURCHASE=1 OR S.IS_PRODUCTION=1 )
					)
			</cfquery>
			<cfset material_list_product = "">
			<cfloop query="get_sub_products">
				<cfset material_list_product = ListAppend(material_list_product,get_sub_products.product_id,",")>
			</cfloop>
			<cfif listlen(material_list_product)>
				<cfquery name="GET_STOCKS_ALL_MAT" datasource="#DSN2#">
					SELECT 
						SUM(GSB.PRODUCT_STOCK) AS PRODUCT_STOCK,
						D.DEPARTMENT_ID,
						GSB.PRODUCT_ID,
						D.DEPARTMENT_HEAD
					FROM
						GET_STOCK_PRODUCT GSB,
						#dsn_alias#.DEPARTMENT D
					WHERE
						GSB.PRODUCT_ID IN (#material_list_product#)
						AND D.DEPARTMENT_ID = GSB.DEPARTMENT_ID
					GROUP BY
						D.DEPARTMENT_ID, GSB.PRODUCT_ID, D.DEPARTMENT_HEAD
				</cfquery>
				<cfquery name='get_stock_reserved_azalan_mat' datasource="#dsn3#">
					SELECT 
						SUM(STOCK_AZALT) AS AZALAN,SUM(STOCK_ARTIR) AS ARTAN,PRODUCT_ID 
					FROM 
						GET_STOCK_RESERVED 
					WHERE 
						PRODUCT_ID IN (#material_list_product#)
					GROUP BY
						PRODUCT_ID		
				</cfquery>
				<cfquery name="GET_PRODUCT_TOTAL_STOCK_MAT" datasource="#dsn2#">
					SELECT 
						PRODUCT_TOTAL_STOCK,PRODUCT_ID
					FROM 
						GET_PRODUCT_STOCK 
					WHERE 
						PRODUCT_ID IN (#material_list_product#)
				</cfquery>
				<cfloop query="get_sub_products">
				<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;#get_sub_products.product_name#</td>
					<td>
						<cfquery name="get_gs_mat" dbtype="query">
							SELECT PRODUCT_TOTAL_STOCK FROM GET_PRODUCT_TOTAL_STOCK_MAT WHERE PRODUCT_ID = #get_sub_products.product_id# 
						</cfquery>
						<cfquery name="get_as_mat" dbtype="query">
							SELECT * FROM get_stock_reserved_azalan_mat WHERE PRODUCT_ID = #get_sub_products.product_id# 
						</cfquery>
						<cfquery name="get_vs_mat" dbtype="query">
							SELECT * FROM get_stock_reserved_azalan_mat WHERE PRODUCT_ID = #get_sub_products.product_id# 
						</cfquery>
						<cfquery name="get_stock_ks_mat" dbtype="query">
							SELECT SUM(PRODUCT_STOCK)  AS PRODUCT_STOCK FROM  GET_STOCKS_ALL_MAT WHERE PRODUCT_ID = #get_sub_products.product_id# 
						</cfquery>
						<cfquery name="get_pro_mat" dbtype="query">
							SELECT SUM(PRODUCT_STOCK)  AS PRODUCT_STOCK FROM  GET_STOCKS_ALL_MAT WHERE PRODUCT_ID = #get_sub_products.product_id# 
						</cfquery>				
						#get_gs_mat.product_total_stock#		
					</td>
					<td>
						<cfif len(get_pro_mat.PRODUCT_STOCK)>
							<cfset total_stk=get_pro_mat.PRODUCT_STOCK>
						<cfif len(get_as_mat.AZALAN)><cfset total_stk=total_stk-get_as_mat.AZALAN></cfif>
						<cfif len(get_vs_mat.ARTAN)><cfset total_stk=total_stk-get_vs_mat.ARTAN></cfif>
							#total_stk#
						</cfif>
					</td>
					<td>#get_as_mat.azalan#</td>
					<td>#get_vs_mat.artan#</td>
						<cfset value_product_id_sub = get_sub_products.product_id>
						<cfloop query="get_departments">
							<td>
								<cfquery name="get_pro_stok_mat" dbtype="query">
									SELECT PRODUCT_STOCK FROM  GET_STOCKS_ALL_MAT WHERE PRODUCT_ID = #value_product_id_sub#  AND DEPARTMENT_ID = #get_departments.DEPARTMENT_ID#
								</cfquery>#get_pro_stok_mat.product_stock#
							</td>
						</cfloop> 
				</tr>
			</tbody>
		</cfloop>
		</cfif>
		</cfif>
		</cfoutput>
		</cfloop>
	<cf_grid_list>
 <cfif len(stok_list)>
	<cfquery name="get_stock_of_10" datasource="#dsn2#">
		SELECT 
			STOCK_ID,SUM(STOCK_OUT) AS AMOUNT,D.BRANCH_ID
		FROM
			STOCKS_ROW, #DSN_ALIAS#.DEPARTMENT AS D
		WHERE 
			STOCKS_ROW.STORE = D.DEPARTMENT_ID 
			AND STOCK_OUT > 0
			AND STOCK_ID IN (#stok_list#)
			AND PROCESS_TYPE IN (67,70,71) 
			AND PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.son_10_gun#">
		GROUP BY
			STOCK_ID,
			BRANCH_ID
	</cfquery>
	<cfquery name="get_stock_of_20" datasource="#dsn2#">
		SELECT 
			STOCK_ID,SUM(STOCK_OUT) AS AMOUNT,D.BRANCH_ID
		FROM
			STOCKS_ROW, #DSN_ALIAS#.DEPARTMENT AS D
		WHERE 
			STOCKS_ROW.STORE = D.DEPARTMENT_ID 
			AND STOCK_OUT > 0
			AND STOCK_ID IN (#stok_list#)
			AND PROCESS_TYPE IN (67,70,71) 
			AND PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.son_20_gun#">
		GROUP BY
			STOCK_ID,
			BRANCH_ID
	</cfquery>
	<cfquery name="get_stock_of_30" datasource="#dsn2#">
		SELECT 
			STOCK_ID,SUM(STOCK_OUT) AS AMOUNT,D.BRANCH_ID
		FROM
			STOCKS_ROW, #DSN_ALIAS#.DEPARTMENT AS D
		WHERE 
			STOCKS_ROW.STORE = D.DEPARTMENT_ID 
			AND STOCK_OUT > 0
			AND STOCK_ID IN (#stok_list#)
			AND PROCESS_TYPE IN (67,70,71) 
			AND PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.son_30_gun#">
		GROUP BY
			STOCK_ID,
			BRANCH_ID
	</cfquery>
	<cfoutput query="get_stock_of_10">
		<cfset "amount10_#stock_id#_#branch_id#" = AMOUNT>
	</cfoutput>
	<cfoutput query="get_stock_of_20">
		<cfset "amount20_#stock_id#_#branch_id#" = AMOUNT>
	</cfoutput>
	<cfoutput query="get_stock_of_30">
		<cfset "amount30_#stock_id#_#branch_id#" = AMOUNT>
	</cfoutput>
</cfif>
  <cfset height2 = (ListLen(stok_list)*100+50)>
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='32574.Satışlar'></th>
				<cfoutput query="get_branch">
					<th class="text-center" colspan="3">#BRANCH_NAME#</th>
				</cfoutput>
			</tr>
			<tr>
				<th></th>
				<cfoutput query="get_branch">
					<th>10 <cf_get_lang dictionary_id='57490.Gün'></th>
					<th>20 <cf_get_lang dictionary_id='57490.Gün'></th>
					<th>30 <cf_get_lang dictionary_id='57490.Gün'></th>
				</cfoutput>
			</tr>
		</thead>
		<tbody>
			<cfloop from="1" to="#ListLen(stok_list)#" index="i">
			<cfoutput>
				<tr>
			</cfoutput>
					<td><cfoutput>#ListGetAt(proname_list,i,';')#</cfoutput></td>
					<cfoutput query="get_branch">
						<td> <!--- 10 --->
						<cfif isdefined("amount10_#ListGetAt(stok_list,i)#_#branch_id#")>
							#evaluate('amount10_#ListGetAt(stok_list,i)#_#branch_id#')#
						</cfif>
						</td> 
						<td><!--- 20 --->
						<cfif isdefined("amount20_#ListGetAt(stok_list,i)#_#branch_id#")>
							#evaluate('amount20_#ListGetAt(stok_list,i)#_#branch_id#')#
						</cfif>				
						</td>
						<td><!--- 30 --->
						<cfif isdefined("amount30_#ListGetAt(stok_list,i)#_#branch_id#")>
							#evaluate('amount30_#ListGetAt(stok_list,i)#_#branch_id#')#
						</cfif>				
						</td>
					</cfoutput>
				</tr>
			</cfloop>
		</tbody>
	</cf_grid_list>
</cf_box>
