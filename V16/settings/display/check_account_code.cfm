<!--- Sistemde kullanilan hesap kodlarinin nerelerde oldugu bilgisini verir FBS 20100625
	  Standarda aldım. Durgan20150817
 --->
 <cfsetting showdebugoutput="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.Period_Year" default="#session.ep.period_year#">
<cfparam name="attributes.Company_Id" default="#session.ep.company_id#">
<cfparam name="attributes.page" default="1">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset new_dsn2 = "#dsn#_#attributes.Period_Year#_#attributes.Company_Id#">
<cfset new_dsn3 = "#dsn#_#attributes.Company_Id#">
<cfif isDefined("attributes.form_varmi")>
	<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
        <cfquery name="Get_Acc_Process" datasource="#dsn#">
			SELECT
				TYPE,
				ACCOUNT_CODE,
				PROCESS_ID,
				PROCESS_NAME,
                PROCESS_CAT,
                ACTION_ID
			FROM
			(
			<!--- Fis Islemleri --->
			SELECT
				'FIS ISLEMLERI' TYPE,
				ACCOUNT_CARD_ROWS.ACCOUNT_ID ACCOUNT_CODE,
				ACCOUNT_CARD_ROWS.CARD_ID PROCESS_ID,
				ACCOUNT_CARD_ROWS.DETAIL AS PROCESS_NAME,
                ACCOUNT_CARD.ACTION_TYPE PROCESS_CAT,
                ACCOUNT_CARD.ACTION_ID
			FROM
				#new_dsn2#.ACCOUNT_CARD_ROWS
                	LEFT JOIN #new_dsn2#.ACCOUNT_CARD ON ACCOUNT_CARD.CARD_ID = ACCOUNT_CARD_ROWS.CARD_ID
			WHERE
				(ACCOUNT_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">)
		UNION ALL
			<!--- Kurumsal Uye --->
            SELECT 
				'KURUMSAL UYE' TYPE,
				ACCOUNT_CODE ACCOUNT_CODE,
				C.COMPANY_ID PROCESS_ID,
                C.FULLNAME AS PROCESS_NAME,
                0 AS PROCESS_CAT,
                0 AS ACTION_ID
            FROM 
            	COMPANY C,
                COMPANY_PERIOD CP
            WHERE 
                 C.COMPANY_ID = CP.COMPANY_ID AND
           		(ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_CODE LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">)
		UNION ALL
			<!--- Bireysel Uye --->
			SELECT
				'BIREYSEL UYE' TYPE,
				ACCOUNT_CODE ACCOUNT_CODE,
				C.CONSUMER_ID PROCESS_ID,
				(C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME) AS PROCESS_NAME,
                0 AS PROCESS_CAT,
                0 AS ACTION_ID
			FROM
				CONSUMER C,
				CONSUMER_PERIOD CP
			WHERE
				C.CONSUMER_ID = CP.CONSUMER_ID AND
				(ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_CODE LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">)
		UNION ALL
			<!--- Urun --->
            SELECT
				'URUN' TYPE,
                ((CASE WHEN ACCOUNT_CODE LIKE '#attributes.keyword#%' THEN ACCOUNT_CODE + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_CODE_PUR LIKE '#attributes.keyword#%' THEN ACCOUNT_CODE_PUR + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_DISCOUNT LIKE '#attributes.keyword#%' THEN ACCOUNT_DISCOUNT + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_PRICE LIKE '#attributes.keyword#%' THEN ACCOUNT_PRICE + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_PUR_IADE LIKE '#attributes.keyword#%' THEN ACCOUNT_PUR_IADE + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_IADE LIKE '#attributes.keyword#%' THEN ACCOUNT_IADE + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_YURTDISI LIKE '#attributes.keyword#%' THEN ACCOUNT_YURTDISI + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_YURTDISI_PUR LIKE '#attributes.keyword#%' THEN ACCOUNT_YURTDISI_PUR + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_DISCOUNT_PUR LIKE '#attributes.keyword#%' THEN ACCOUNT_DISCOUNT_PUR + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_EXPENDITURE LIKE '#attributes.keyword#%' THEN ACCOUNT_EXPENDITURE + ',' ELSE '' END) +
                (CASE WHEN OVER_COUNT LIKE '#attributes.keyword#%' THEN OVER_COUNT + ',' ELSE '' END) +
                (CASE WHEN UNDER_COUNT LIKE '#attributes.keyword#%' THEN UNDER_COUNT + ',' ELSE '' END) +
                (CASE WHEN PRODUCTION_COST LIKE '#attributes.keyword#%' THEN PRODUCTION_COST + ',' ELSE '' END) +
                (CASE WHEN HALF_PRODUCTION_COST LIKE '#attributes.keyword#%' THEN HALF_PRODUCTION_COST + ',' ELSE '' END) +
                (CASE WHEN SALE_PRODUCT_COST LIKE '#attributes.keyword#%' THEN SALE_PRODUCT_COST + ',' ELSE '' END) +
                (CASE WHEN MATERIAL_CODE LIKE '#attributes.keyword#%' THEN MATERIAL_CODE + ',' ELSE '' END) +
                (CASE WHEN KONSINYE_PUR_CODE LIKE '#attributes.keyword#%' THEN KONSINYE_PUR_CODE + ',' ELSE '' END) +
                (CASE WHEN KONSINYE_SALE_CODE LIKE '#attributes.keyword#%' THEN KONSINYE_SALE_CODE + ',' ELSE '' END) +
                (CASE WHEN KONSINYE_SALE_NAZ_CODE LIKE '#attributes.keyword#%' THEN KONSINYE_SALE_NAZ_CODE + ',' ELSE '' END) +
                (CASE WHEN DIMM_CODE LIKE '#attributes.keyword#%' THEN DIMM_CODE + ',' ELSE '' END) +
                (CASE WHEN DIMM_YANS_CODE LIKE '#attributes.keyword#%' THEN DIMM_YANS_CODE + ',' ELSE '' END) +
                (CASE WHEN PROMOTION_CODE LIKE '#attributes.keyword#%' THEN PROMOTION_CODE + ',' ELSE '' END))
                AS ACCOUNT_CODE,
                P.PRODUCT_ID PROCESS_ID,
				P.PRODUCT_NAME AS PROCESS_NAME,
                0 AS PROCESS_CAT,
                0 AS ACTION_ID
            FROM 
                #new_dsn3#.PRODUCT_PERIOD PP,
                #dsn1_alias#.PRODUCT P
            WHERE 
                PP.PRODUCT_ID = P.PRODUCT_ID AND
                (
					(ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_CODE LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_CODE_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_CODE_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_DISCOUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_DISCOUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_PRICE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_PRICE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_PUR_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_PUR_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_YURTDISI LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_YURTDISI LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_YURTDISI_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_YURTDISI_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_DISCOUNT_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_DISCOUNT_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_LOSS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_LOSS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_EXPENDITURE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_EXPENDITURE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(OVER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR OVER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(UNDER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR UNDER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(HALF_PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR HALF_PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(SALE_PRODUCT_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR SALE_PRODUCT_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(MATERIAL_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR MATERIAL_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(KONSINYE_PUR_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR KONSINYE_PUR_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(KONSINYE_SALE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR KONSINYE_SALE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(KONSINYE_SALE_NAZ_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR KONSINYE_SALE_NAZ_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(DIMM_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR DIMM_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(DIMM_YANS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR DIMM_YANS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(PROMOTION_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR PROMOTION_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">)
                )
		UNION ALL
			<!--- Proje --->
            SELECT  
                'PROJE' TYPE,
                ((CASE WHEN ACCOUNT_CODE LIKE '#attributes.keyword#%' THEN ACCOUNT_CODE + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_CODE_PUR LIKE '#attributes.keyword#%' THEN ACCOUNT_CODE_PUR + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_DISCOUNT LIKE '#attributes.keyword#%' THEN ACCOUNT_DISCOUNT + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_PRICE LIKE '#attributes.keyword#%' THEN ACCOUNT_PRICE + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_PUR_IADE LIKE '#attributes.keyword#%' THEN ACCOUNT_PUR_IADE + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_IADE LIKE '#attributes.keyword#%' THEN ACCOUNT_IADE + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_YURTDISI LIKE '#attributes.keyword#%' THEN ACCOUNT_YURTDISI + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_YURTDISI_PUR LIKE '#attributes.keyword#%' THEN ACCOUNT_YURTDISI_PUR + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_DISCOUNT_PUR LIKE '#attributes.keyword#%' THEN ACCOUNT_DISCOUNT_PUR + ',' ELSE '' END) +
                (CASE WHEN ACCOUNT_EXPENDITURE LIKE '#attributes.keyword#%' THEN ACCOUNT_EXPENDITURE + ',' ELSE '' END) +
                (CASE WHEN OVER_COUNT LIKE '#attributes.keyword#%' THEN OVER_COUNT + ',' ELSE '' END) +
                (CASE WHEN UNDER_COUNT LIKE '#attributes.keyword#%' THEN UNDER_COUNT + ',' ELSE '' END) +
                (CASE WHEN PRODUCTION_COST LIKE '#attributes.keyword#%' THEN PRODUCTION_COST + ',' ELSE '' END) +
                (CASE WHEN HALF_PRODUCTION_COST LIKE '#attributes.keyword#%' THEN HALF_PRODUCTION_COST + ',' ELSE '' END) +
                (CASE WHEN SALE_PRODUCT_COST LIKE '#attributes.keyword#%' THEN SALE_PRODUCT_COST + ',' ELSE '' END) +
                (CASE WHEN MATERIAL_CODE LIKE '#attributes.keyword#%' THEN MATERIAL_CODE + ',' ELSE '' END) +
                (CASE WHEN KONSINYE_PUR_CODE LIKE '#attributes.keyword#%' THEN KONSINYE_PUR_CODE + ',' ELSE '' END) +
                (CASE WHEN KONSINYE_SALE_CODE LIKE '#attributes.keyword#%' THEN KONSINYE_SALE_CODE + ',' ELSE '' END) +
                (CASE WHEN KONSINYE_SALE_NAZ_CODE LIKE '#attributes.keyword#%' THEN KONSINYE_SALE_NAZ_CODE + ',' ELSE '' END) +
                (CASE WHEN DIMM_CODE LIKE '#attributes.keyword#%' THEN DIMM_CODE + ',' ELSE '' END) +
                (CASE WHEN DIMM_YANS_CODE LIKE '#attributes.keyword#%' THEN DIMM_YANS_CODE + ',' ELSE '' END) +
                (CASE WHEN PROMOTION_CODE LIKE '#attributes.keyword#%' THEN PROMOTION_CODE + ',' ELSE '' END))
                AS ACCOUNT_CODE,
				P.PROJECT_ID PROCESS_ID,
				P.PROJECT_HEAD AS PROCESS_NAME,
                0 AS PROCESS_CAT,
                0 AS ACTION_ID
            FROM 
                #dsn3_alias#.PROJECT_PERIOD PP,
                #dsn_alias#.PRO_PROJECTS P
            WHERE
            	PP.PROJECT_ID = P.PROJECT_ID AND
                (
					(ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_CODE_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_CODE_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_DISCOUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_DISCOUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_PRICE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_PRICE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_PUR_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_PUR_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_YURTDISI LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_YURTDISI LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_YURTDISI_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_YURTDISI_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_DISCOUNT_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_DISCOUNT_PUR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_LOSS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_LOSS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(ACCOUNT_EXPENDITURE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR ACCOUNT_EXPENDITURE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(OVER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR OVER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(UNDER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR UNDER_COUNT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(KONSINYE_PUR_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR KONSINYE_PUR_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(KONSINYE_SALE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR KONSINYE_SALE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(KONSINYE_SALE_NAZ_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR KONSINYE_SALE_NAZ_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(HALF_PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR HALF_PRODUCTION_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(SALE_PRODUCT_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR SALE_PRODUCT_COST LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(MATERIAL_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR MATERIAL_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(DIMM_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR DIMM_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(DIMM_YANS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR DIMM_YANS_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
					(PROMOTION_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR PROMOTION_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">)
                )
			UNION ALL
			<!--- Kdv --->
            SELECT 
				'KDV' TYPE,
				(SALE_CODE + ', ' + PURCHASE_CODE + ', ' + SALE_CODE_IADE + ', ' + PURCHASE_CODE_IADE) AS ACCOUNT_CODE,
                TAX_ID PROCESS_ID,
				DETAIL PROCESS_NAME,
                0 AS PROCESS_CAT,
                0 AS ACTION_ID
            FROM 
                <!--- Musterilerde sirkette tutuluyor, yeni yapilan bir duzenleme, ileri versiyonlarda geri alinabilir. #new_dsn2#.SETUP_TAX  --->
				#new_dsn2#.SETUP_TAX
            WHERE 
				(SALE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR SALE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
				(PURCHASE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR PURCHASE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
				(SALE_CODE_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR SALE_CODE_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">) OR
				(PURCHASE_CODE_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#"> OR PURCHASE_CODE_IADE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#.%">)
			) QUERY_
		GROUP BY
			TYPE,
			ACCOUNT_CODE,
			PROCESS_ID,
			PROCESS_NAME,
            PROCESS_CAT,
            ACTION_ID
		ORDER BY
			PROCESS_NAME,
			TYPE
		</cfquery>
   </cfif>
<cfelse>
	<cfset Get_Acc_Process.RecordCount = 0>
</cfif>
<cfset attributes.totalrecords=Get_Acc_Process.recordcount>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_report" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
			<input type="hidden" name="form_varmi" id="form_varmi" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" style="width:90px;" value="#attributes.keyword#" maxlength="50"> 
				</div>
				<div class="form-group small">                           
					<cfinput type="text" name="maxrows" id="maxrows" style="width:25px;" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" onKeyUp="isNumber(this)">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4"  search_function='kontrol()'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('settings',1357)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="40"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='47299.hesap kodu'></th>
					<th><cf_get_lang dictionary_id='57692.işlem'></th>
					<th><cf_get_lang dictionary_id='58527.Id'></th>
					<th><cf_get_lang dictionary_id='61806.İşlem Tipi'></th>
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_varmi") and Get_Acc_Process.recordcount>
					<cfoutput query="Get_Acc_Process" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfswitch expression="#type#">
							<cfcase value="PROJE">
								<cfset fuseact = 'project.projects&event=det&id=#process_id#'>
							</cfcase>
							<cfcase value="FIS ISLEMLERI">
								<cfif len(action_id)>
									<cfset fuseact = 'account.popup_list_card_rows&action_id=#action_id#&process_cat=#process_cat#'>
								<cfelse>
									<cfset fuseact = 'account.popup_list_card_rows&card_id=#process_id#'>
								</cfif>
							</cfcase>
							<cfcase value="URUN">
								<cfset fuseact = 'product.list_product&event=det&pid=#process_id#'>
							</cfcase>
							<cfcase value="BIREYSEL UYE">
								<cfset fuseact = 'member.consumer_list&event=det&cid=#process_id#'>
							</cfcase>
							<cfcase value="KURUMSAL UYE">
								<cfset fuseact = 'member.form_list_company&event=upd&cpid=#process_id#'>
							</cfcase>
							<cfcase value="KDV">
								<cfset fuseact = 'settings.list_tax&event=upd&tid=#process_id#'>
							</cfcase>
							<cfdefaultcase>
								<cfset fuseact = ''>
							</cfdefaultcase>
						</cfswitch>
						<tr>
							<td>#currentrow#</td>
							<td>#listDeleteDuplicates(account_code)#</td>
							<td>#process_name#</td>
							<td>
								<cfif len(fuseact)>
									<a href="#request.self#?fuseaction=#fuseact#" class="tableyazi" target="_blank">#process_id#</a>
								<cfelse>
									#process_id#
								</cfif>
							</td>
							<td>#type#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="5"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>	 
			</tbody>
		</cf_grid_list>
		<cfset adres="settings.#listlast(attributes.fuseaction,'.')#">
		<cfif isdefined("attributes.keyword")>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.form_varmi")>
			<cfset adres = "#adres#&form_varmi=#attributes.form_varmi#">
		</cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#"> 
	</cf_box>
</div>
<script language="javascript">
	function kontrol()
	{
		if(document.search_report.keyword.value == '')
		{
			alert("Aranacak Hesap Kodunu Giriniz!");
			return false;
		}
		return true;
	}
</script>
