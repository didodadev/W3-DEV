<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.form_submitted" default="0">
<cfquery name="get_stock_locations" datasource="#dsn#">
	SELECT
		COMMENT,
		DEPARTMENT_ID,
		LOCATION_ID,
		ID
	FROM 
		STOCKS_LOCATION
</cfquery>

<cf_box> 
<cf_box_search more="0">
<cfform name="service_form" method="post" action="#request.self#?fuseaction=stock.location_management&event=det">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
    	<div class="row">
    		<div class="col col-12 form-inline">
            	<div class="form-group">
						<cfinput type="text" placeholder="#getlang('','Filtre','57460')#" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:60px;">
				</div>
				<div class="form-group">
					<select name="location_id" id="location_id" style="width:120px;">
						<option value=""><cf_get_lang dictionary_id='30031.Lokasyon'></option>
						<cfoutput query="get_stock_locations">
							<option value="#ID#" <cfif ID eq attributes.location_id>selected</cfif>>#COMMENT#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
                    <div class="input-group">
                        <cf_wrk_search_button button_type="4">
                    </div>
                </div>
    	</div>           
</cfform>
</cf_box_search>
</cf_box>
<!--- <cfset location_list = valuelist(get_stock_locations.SHELF_CODE)>
<cfset all_location_list = 'REC,SHIP,' & location_list>

 --->
<cfif len(attributes.keyword) OR len(attributes.location_id)>
 <cfset new_list="">
<!---<cfif attributes.keyword is 'REC' and attributes.keyword2 is 'REC'>
	<cfset location_list = 'REC,' & location_list>
<cfelseif attributes.keyword is 'SHIP' and attributes.keyword2 is 'SHIP'>
	<cfset location_list = 'SHIP,' & location_list>
<cfelseif attributes.keyword is 'REC' and attributes.keyword2 is 'SHIP'>
	<cfset location_list = 'REC,SHIP,' & location_list>
<cfelseif attributes.keyword is 'SHIP' and attributes.keyword2 is 'REC'>
	<cfset location_list = 'REC,SHIP,' & location_list>
<cfelseif attributes.keyword is 'REC' and attributes.keyword2 is not 'REC' and attributes.keyword2 is not 'SHIP'>
	<cfset location_list = 'REC,' & location_list>
<cfelseif attributes.keyword is 'SHIP' and attributes.keyword2 is not 'REC' and attributes.keyword2 is not 'SHIP'>
	<cfset location_list = 'SHIP,' & location_list>
</cfif> --->

<cfquery name="get_stock_locations_s" datasource="#dsn#">
	SELECT TOP 200
		*
	FROM
		(
		<cfif listfind(new_list,'REC')>
		SELECT
			0 AS CIKIS,
			1 AS GIRIS,
			'Rec Area' AS COMMENT,
			'REC' AS SHELF_CODE,
			-1 AS PRODUCT_PLACE_ID
			UNION ALL
		</cfif>
		<cfif listfind(new_list,'SHIP')>
		SELECT
			ISNULL((SELECT SUM(AMOUNT) FROM #dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP WHERE WP.FROM_PP_ID = -2),0) AS CIKIS,
			ISNULL((
				SELECT 
					SUM(AMOUNT) 
				FROM 
					#dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP,
					#dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT WM
						LEFT JOIN #dsn3_alias#.WAREHOUSE_TASKS WT ON WT.TASK_ID = WM.TASK_ID
				WHERE 
					WM.MANAGEMENT_ID = WP.MANAGEMENT_ID AND
					(
					WM.TASK_ID IS NULL 
					OR
					(WM.TASK_ID IS NOT NULL AND WT.IS_ACTIVE = -1)
					) AND
					WP.TO_PP_ID = -2),0) AS GIRIS,
			'Ship Area' AS COMMENT,
			'SHIP' AS SHELF_CODE,
			-2 AS PRODUCT_PLACE_ID
			UNION ALL
		</cfif>
		SELECT TOP 200
			ISNULL((SELECT SUM(AMOUNT) FROM #dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP WHERE WP.FROM_PP_ID = PP.PRODUCT_PLACE_ID),0) AS CIKIS,
			ISNULL((SELECT SUM(AMOUNT) FROM #dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP WHERE WP.TO_PP_ID = PP.PRODUCT_PLACE_ID),0) AS GIRIS,
			SL.COMMENT,
			PP.SHELF_CODE,
			PP.PRODUCT_PLACE_ID
		FROM 
			STOCKS_LOCATION SL,
			#dsn3_alias#.PRODUCT_PLACE PP
		WHERE
			SL.LOCATION_ID = PP.LOCATION_ID AND
			SL.DEPARTMENT_ID = PP.STORE_ID
			<cfif len(attributes.location_id)>
			AND SL.ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">
			</cfif>
			<cfif len(attributes.keyword)>
			AND (
			PP.SHELF_CODE LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
			OR SL.COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
			)
			</cfif>
		) T_ALL
	ORDER BY
		COMMENT,
		PRODUCT_PLACE_ID
</cfquery>

<cf_box  title="#getlang('','Raflar','29944')#">
<cf_grid_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th width="50"><cf_get_lang dictionary_id='30031.Lokasyon'></th>
			<th width="50"><cf_get_lang dictionary_id='45539.Raf Kodu'></th>
			<th width="50"><cf_get_lang dictionary_id='30111.Durumu'></th>
			<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_stock_locations_s.recordcount>	
		<cfoutput query="get_stock_locations_s">
			<tr>
				<td width="50" valign="top">#currentrow#</td>
				<td width="50" valign="top">#COMMENT#</td>
				<td width="50" valign="top">#SHELF_CODE#</td>
				<td width="50" valign="top"><cfif CIKIS gte giris><cf_get_lang dictionary_id="36956.Boş"><cfelse><cf_get_lang dictionary_id="36955.Dolu"></cfif></td>
				<td valign="top">
				<cfif PRODUCT_PLACE_ID eq -1>
					<cfquery name="get_veri" datasource="#dsn3#">
					SELECT
						*
					FROM
						(
						SELECT
							P.PRODUCT_ID,
							P.PRODUCT_NAME,
							C.NICKNAME,
							ISNULL((SELECT SUM(WTP.AMOUNT) FROM WAREHOUSE_TASKS_PRODUCTS WTP,ttc_workcube_1.WAREHOUSE_TASKS WT WHERE WT.IS_ACTIVE = 1 AND WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = P.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (0,2)),0) AS STOCK_COUNT_IN,
							ISNULL((SELECT SUM(WTP.AMOUNT) FROM WAREHOUSE_TASKS_PRODUCTS WTP,ttc_workcube_1.WAREHOUSE_TASKS WT WHERE WT.IS_ACTIVE = 1 AND WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = P.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (1)),0)  AS STOCK_COUNT_OUT,
							ISNULL((
								SELECT 
									SUM(AMOUNT) 
								FROM 
									WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP 
								WHERE 
									WP.FROM_PP_ID NOT IN (-1,-2) 
									AND 
									WP.PRODUCT_ID = P.PRODUCT_ID
							),0) AS P_CIKIS,
							ISNULL((
								SELECT 
									SUM(AMOUNT) 
								FROM 
									WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP 
								WHERE 
									WP.TO_PP_ID NOT IN (-1,-2) AND 
									WP.PRODUCT_ID = P.PRODUCT_ID
							),0) AS P_GIRIS,
							ISNULL((
								SELECT 
									SUM(AMOUNT) 
								FROM 
									#dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP,
									#dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT WM
										LEFT JOIN #dsn3_alias#.WAREHOUSE_TASKS WT ON WT.TASK_ID = WM.TASK_ID
								WHERE 
									WM.MANAGEMENT_ID = WP.MANAGEMENT_ID AND
									(
									WM.TASK_ID IS NULL 
									OR
									(WM.TASK_ID IS NOT NULL AND WT.IS_ACTIVE = -1)
									) AND
									WP.TO_PP_ID = -2
									AND WP.PRODUCT_ID = P.PRODUCT_ID
							),0) AS P_SHIP_GIRIS
						FROM
							PRODUCT P
								LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = P.COMPANY_ID
						) T1
					WHERE
						(STOCK_COUNT_IN - STOCK_COUNT_OUT) > 0 OR
						(P_GIRIS - P_CIKIS + P_SHIP_GIRIS) > 0
					ORDER BY
						NICKNAME,
						PRODUCT_NAME
					</cfquery>
					<cfloop query="get_veri">
						<cfif (STOCK_COUNT_IN - STOCK_COUNT_OUT) - (P_GIRIS - P_CIKIS + P_SHIP_GIRIS) gt 0>#PRODUCT_ID# #STOCK_COUNT_IN# #PRODUCT_NAME# (#(STOCK_COUNT_IN - STOCK_COUNT_OUT) - (P_GIRIS - P_CIKIS + P_SHIP_GIRIS)#) - #NICKNAME# <BR/></cfif>
					</cfloop>
				<cfelseif giris gt cikis and PRODUCT_PLACE_ID eq -2>
					<cfquery name="get_veri" datasource="#dsn3#">
						SELECT
							P.PRODUCT_NAME,
							C.NICKNAME,
							ISNULL((
								SELECT SUM(AMOUNT) FROM #dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP WHERE WP.FROM_PP_ID = #PRODUCT_PLACE_ID# AND WP.PRODUCT_ID = P.PRODUCT_ID),0) AS P_CIKIS,
							ISNULL((
								SELECT 
									SUM(AMOUNT) 
								FROM 
									#dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP,
									#dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT WM
										LEFT JOIN #dsn3_alias#.WAREHOUSE_TASKS WT ON WT.TASK_ID = WM.TASK_ID
								WHERE 
									WM.MANAGEMENT_ID = WP.MANAGEMENT_ID AND
									(
									WM.TASK_ID IS NULL 
									OR
									(WM.TASK_ID IS NOT NULL AND WT.IS_ACTIVE = -1)
									) AND
									WP.TO_PP_ID = -2
									AND WP.PRODUCT_ID = P.PRODUCT_ID
							),0) AS P_GIRIS
						FROM
							PRODUCT P
								LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = P.COMPANY_ID
						WHERE
							P.PRODUCT_ID IN (SELECT WP.PRODUCT_ID FROM WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP WHERE FROM_PP_ID = #PRODUCT_PLACE_ID# OR TO_PP_ID = #PRODUCT_PLACE_ID#)
					</cfquery>
					<cfloop query="get_veri">
						<cfif P_GIRIS - P_CIKIS gt 0>#PRODUCT_NAME# (#P_GIRIS - P_CIKIS#) - #NICKNAME# <BR/></cfif>
					</cfloop>
				<cfelseif not listfind('-1,-2',PRODUCT_PLACE_ID) and giris gt cikis>
					<cfquery name="get_veri" datasource="#dsn3#">
						SELECT
							P.PRODUCT_NAME,
							C.NICKNAME,
							ISNULL((SELECT SUM(AMOUNT) FROM #dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP WHERE WP.FROM_PP_ID = #PRODUCT_PLACE_ID# AND WP.PRODUCT_ID = P.PRODUCT_ID),0) AS P_CIKIS,
							ISNULL((SELECT SUM(AMOUNT) FROM #dsn3_alias#.WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP WHERE WP.TO_PP_ID = #PRODUCT_PLACE_ID# AND WP.PRODUCT_ID = P.PRODUCT_ID),0) AS P_GIRIS
						FROM
							PRODUCT P
								LEFT JOIN #dsn_alias#.COMPANY C ON C.COMPANY_ID = P.COMPANY_ID
						WHERE
							P.PRODUCT_ID IN (SELECT WP.PRODUCT_ID FROM WAREHOUSE_TASKS_LOCATION_MANAGEMENT_PRODUCTS WP WHERE FROM_PP_ID = #PRODUCT_PLACE_ID# OR TO_PP_ID = #PRODUCT_PLACE_ID#)
					</cfquery>
					<cfloop query="get_veri">
						<cfif (P_GIRIS - P_CIKIS) neq 0>
							#PRODUCT_NAME# (#P_GIRIS - P_CIKIS#) - #NICKNAME# <BR/>
						</cfif>
					</cfloop>
				</cfif>
				</td>
			</tr>
		</cfoutput>
		</cfif>
	</tbody>
</cf_grid_list>
<cfif not get_stock_locations_s.recordcount>
<div class="ui-info-bottom">
	<p><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !</cfif></p>
</div>
</cfif>
<cfelse>
	<cf_box  title="#getlang('','Raflar','29944')#">
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th width="50"><cf_get_lang dictionary_id='30031.Lokasyon'></th>
				<th width="50"><cf_get_lang dictionary_id='45539.Raf Kodu'></th>
				<th width="50"><cf_get_lang dictionary_id='30111.Durumu'></th>
				<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			</tr>
		</thead>
	</cf_grid_list>
	<cfif not (len(attributes.keyword)) and not len(attributes.location_id)>
	<div class="ui-info-bottom">
		<p><cfif attributes.form_submitted><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
	</div>
</cfif>
</cf_box>
</cfif>