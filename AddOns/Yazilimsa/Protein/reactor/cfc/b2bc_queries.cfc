<cfcomponent extends="cfc.queryJSONConverter">
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn_company_id = 1>
	<cfset dsn3 = "#dsn#_#dsn_company_id#">
	<cfset dsn3_alias = "#dsn#_#dsn_company_id#">
	<cfset dsn1_alias = "#dsn#_product">
	<cfset dsn2_alias = "#dsn#_#year(now())#_#dsn_company_id#">
	<cfset attributes.price_cat_id = 0>
	
	<cfif isdefined("session.pp.userid")>
		<cfquery name="get_comp_credit" datasource="#dsn#">
			SELECT PRICE_CAT FROM COMPANY_CREDIT WHERE COMPANY_ID = #session.pp.company_id#
		</cfquery>
		<cfif get_comp_credit.recordcount and len(get_comp_credit.PRICE_CAT)>
			<cfset attributes.price_cat_id = get_comp_credit.PRICE_CAT>
		</cfif>
	</cfif>
	
	<cfset wrk_round = application.functions.wrk_round>
	
	<cfif isdefined('session.pp.userid')>
		<cfset session_base = session.pp>
	<cfelse>
		<cfset session_base = session.ww>
	</cfif>
    <!--- Genel --->
    <cffunction name="get_product_cats" access="remote" returntype="query">
        <cfquery name="get_product_cats_query" datasource="#DSN#">
            SELECT
                *
            FROM
            	#dsn3_alias#.PRODUCT_CAT
			WHERE
				IS_PUBLIC = 1 AND
				HIERARCHY IS NOT NULL AND HIERARCHY <> ''
            ORDER BY
				HIERARCHY ASC
        </cfquery>
        <cfreturn get_product_cats_query>
	</cffunction>
	
	<!--- Kendisine gelen parametreye göre sayıyı düzenler. Sayının değeri ile yuvarlama katsayısı farklıysa farklı sayının yuvarlaması büyükse yuvarlar tersi durumda 0'lar ekler. --->
    <cffunction name="filterNum" returntype="string" output="false" hint="filternum">
        <!--- 
        by Ozden Ozturk 20070316
        notes :
            float veya integer alanların temizliği için kullanılır, js filterNum fonksiyonuyla aynı işlevi gorur
        parameters :
            1) str:formatlı yazdırılacak sayı (int veya float)
            2) no_of_decimal:ondalikli hane sayisi (int)
        usage : 
            filternum('124587,787',4)
            veya
            filternum(attributes.money,4)
         --->
        <cfargument name="str" required="yes">
        <cfargument name="no_of_decimal" required="no" default="2">	
        <cfscript>
        
        if((isdefined("moneyformat_style") and moneyformat_style eq 0) or (not isdefined("moneyformat_style")) or not isdefined("session.ep"))
        {
            if (not len(arguments.str)) return '';
            strCheck = '-;0;1;2;3;4;5;6;7;8;9;,';
            newStr = '';
            for(f_ind_i=1; f_ind_i lte len(arguments.str); f_ind_i=f_ind_i+1 )
            {
                if(listfind(strCheck, mid(arguments.str,f_ind_i,1),';'))
                    newStr = newStr&mid(arguments.str,f_ind_i,1);
            }
            newStr = replace(newStr,',','.','all');
            newStr = replace(newStr,',',' ','all');
        }
        else
        {
            if (not len(arguments.str)) return '';
            strCheck = '-;0;1;2;3;4;5;6;7;8;9;';
            newStr = '';
            for(f_ind_i=1; f_ind_i lte len(arguments.str); f_ind_i=f_ind_i+1 )
            {
                if(listfind(strCheck, mid(arguments.str,f_ind_i,1),';'))
                    newStr = newStr&mid(arguments.str,f_ind_i,1);
            }
            newStr = replace(str,',','','all');
        }
        </cfscript>
        <cfreturn wrk_round(newStr,no_of_decimal)>
    </cffunction>

	<cffunction name="get_products" access="remote" returntype="query">
		<cfargument name="hierarchy" default="">
		<cfargument name="product_id_list" default="">
		<cfargument name="variation_select" default="">
		<cfargument name="brand_id" default="">
		<cfargument name="keyword" default="">
		<cfargument name="price_value_up" default="">
		<cfargument name="price_value_low" default="">
		<cfargument name="price_money" default="USD">
		<cfargument name="kategori" default="">
		<cfargument name="show_stock_only" default="1">
		<cfargument name="order_type" default="0">

		<cfif len(arguments.price_value_up)>
			<cfset arguments.price_value_up = filterNum(arguments.price_value_up)>
		</cfif>
		<cfif len(arguments.price_value_low)>
			<cfset arguments.price_value_low = filterNum(arguments.price_value_low)>
		</cfif>

		<cfif isdefined("arguments.variation_select") and listlen(arguments.variation_select)>
			<cfset attributes.list_variation_id = ''>
			<cfset attributes.list_property_id = ''>
			<cfset liste_uzunluk = listlen(arguments.variation_select,',')>
			<cfloop from="1" to="#liste_uzunluk#" index="ccm">
				<cfset degisken = listgetat(arguments.variation_select,ccm,',')>
				<cfif not listfindnocase(degisken,listgetat(degisken,2,'*'))>
					<cfset attributes.list_variation_id = listappend(attributes.list_variation_id,listgetat(degisken,2,'*'),',')>
				</cfif>
				<cfif not listfindnocase(degisken,listgetat(degisken,1,'*'))>
					<cfset attributes.list_property_id = listappend(attributes.list_property_id,listgetat(degisken,1,'*'),',')>
				</cfif>
			</cfloop>
		</cfif>

		<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id)>
			<cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_ind">
				<cfset pid = ListGetAt(attributes.list_property_id,pro_ind,",")>
				<cfset vid = ListGetAt(attributes.list_variation_id,pro_ind,",")>

				<cfif isdefined('p_list_#pid#')>
					<cfset 'p_list_#pid#' = listappend(Evaluate('p_list_#pid#'),vid)>
				<cfelse>
					<cfset 'p_list_#pid#' = vid>
				</cfif>
			</cfloop>
			
			<cfquery name="getPropertyProduct" datasource="#DSN#">
				SELECT 
					PRODUCT_ID 
				FROM 
					#dsn1_alias#.PRODUCT 
				WHERE 
					<cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_ind">
						<cfset p_list = Evaluate('p_list_#ListGetAt(attributes.list_property_id,pro_ind,",")#')>
						PRODUCT_ID IN (
							SELECT 
								PRODUCT_ID 
							FROM 
								#dsn1_alias#.PRODUCT_DT_PROPERTIES 
							WHERE
								PROPERTY_ID = #ListGetAt(attributes.list_property_id,pro_ind,",")# AND 
								(
									<cfloop from="1" to="#listlen(p_list)#" index="a">
										<cfset vid = ListGetAt(p_list,a,",")>
										VARIATION_ID = #vid# 
										<cfif a neq listlen(p_list)> OR </cfif>
									</cfloop>
								)
					) <cfif pro_ind lt listlen(attributes.list_property_id,',')>AND</cfif> 
					</cfloop>
			</cfquery>
		</cfif>
		
		<cfquery name="get_products_query" datasource="#DSN#">
			WITH CTE_STOCKS AS (
				SELECT
					ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0) AS TOTAL_STOCK,
					SR.STOCK_ID
				FROM
					#dsn2_alias#.STOCKS_ROW SR
				GROUP BY
					SR.STOCK_ID
				HAVING
					ISNULL(SUM(SR.STOCK_IN - SR.STOCK_OUT),0) > 0
			)
            SELECT DISTINCT
				1 AS ALT_URUN_SAYISI,
				CS.TOTAL_STOCK,
				P_CON.*
			FROM
					(
					SELECT
						P_DIS.PRODUCT_CODE_2,
						S.PRODUCT_ID,
						S.PRODUCT_DETAIL2,
						S.PRODUCT_NAME,
						CASE WHEN (PRC.PRICE IS NOT NULL AND PRC.PRICE > 0) THEN PRC.PRICE ELSE PS.PRICE END AS PRICE,
						CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE_KDV ELSE PS.PRICE_KDV END AS PRICE_KDV,
						CASE 
						WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
							PRC.PRICE_KDV * (SM_ALL.RATE2/SM_ALL.RATE1)
						ELSE
							PS.PRICE_KDV * (SM_ALL_STD.RATE2/SM_ALL_STD.RATE1)
						END AS PRICE_KDV_TL,
						CASE 
							WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
								PRC.PRICE * (SM_ALL.RATE2/SM_ALL.RATE1)
							ELSE
								PS.PRICE * (SM_ALL_STD.RATE2/SM_ALL_STD.RATE1)
						END AS PRICE_TL,
						PS.MONEY,
						S.STOCK_ID,
						S.PRODUCT_CODE,
						PC.HIERARCHY,
						PC.IMAGE_CAT,
						(SELECT TOP 1 PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = S.PRODUCT_ID AND PI.IMAGE_SIZE = 2 ORDER BY PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI,
						(SELECT TOP 1 VIDEO_PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = S.PRODUCT_ID AND PI.IMAGE_SIZE = 2 ORDER BY PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI_YOLU,
						(ISNULL((SELECT SALEABLE_STOCK FROM  #dsn2_alias#.GET_STOCK_LAST GSL WHERE S.STOCK_ID=GSL.STOCK_ID),0) + ISNULL((SELECT TOP 1 CASE WHEN (PIP.PROPERTY1 = '' OR PIP.PROPERTY1 IS NULL) THEN 0 ELSE PIP.PROPERTY1 END AS PROPERTY1 FROM #dsn3_alias#.PRODUCT_INFO_PLUS PIP WHERE S.PRODUCT_ID=PIP.PRODUCT_ID),0)) AS STOK_DURUMU						
					FROM
						#dsn3_alias#.PRODUCT P_DIS,
						#dsn3_alias#.PRODUCT_CAT PC,
						#dsn3_alias#.PRICE_STANDART PS
							LEFT JOIN SETUP_MONEY SM_ALL_STD ON 
								(
								SM_ALL_STD.MONEY = PS.MONEY AND
								SM_ALL_STD.MONEY_STATUS = 1 AND
								SM_ALL_STD.PERIOD_ID = #session_base.period_id#
								)
						,
						#dsn3_alias#.STOCKS S
							LEFT JOIN #dsn3_alias#.PRICE PRC ON 
								(
								PRC.PRODUCT_ID = S.PRODUCT_ID AND 
								PRC.PRICE_CATID = #attributes.price_cat_id# AND
								(PRC.FINISHDATE IS NULL OR PRC.FINISHDATE > #NOW()#)
								)
							LEFT JOIN SETUP_MONEY SM_ALL ON 
								(
								SM_ALL.MONEY = PRC.MONEY AND
								SM_ALL.MONEY_STATUS = 1 AND
								SM_ALL.PERIOD_ID = #session_base.period_id#
								)
					WHERE
						P_DIS.PRODUCT_ID = S.PRODUCT_ID AND
						PS.PRODUCT_ID = S.PRODUCT_ID AND
						PS.PRICESTANDART_STATUS = 1 AND
						PS.PURCHASESALES = 1 AND
						S.PRODUCT_CATID = PC.PRODUCT_CATID
						<cfif isdefined('session.pp.userid')>
							AND P_DIS.IS_EXTRANET = 1
						<cfelse>
							AND P_DIS.IS_INTERNET = 1
						</cfif>
						<cfif len(arguments.keyword)>
							AND 
								(
								P_DIS.PRODUCT_NAME LIKE '%#arguments.keyword#%'
								OR
								P_DIS.PRODUCT_CODE_2 LIKE '%#arguments.keyword#%'
								OR
								P_DIS.PRODUCT_CODE LIKE '%#arguments.keyword#%'
								)
						</cfif>
						<cfif len(arguments.hierarchy)>
							AND P_DIS.PRODUCT_CODE LIKE '#arguments.hierarchy#.%'
						</cfif>
						<cfif len(arguments.product_id_list)>
							AND P_DIS.PRODUCT_ID IN (#arguments.product_id_list#)
						</cfif>
						<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id)>
							<cfif getPropertyProduct.recordcount>
								AND P_DIS.PRODUCT_ID IN (#listremoveduplicates(ValueList(getPropertyProduct.product_id,','))#)
							<cfelse>
								AND P_DIS.PRODUCT_ID IN (0)
							</cfif>
						</cfif>
						<cfif len(arguments.brand_id)>
							AND P_DIS.BRAND_ID IN (#arguments.brand_id#)
						</cfif>
						<cfif isdefined("arguments.kategori") and len(arguments.kategori)>
							AND 
							(
								<cfloop from="1" to="#listlen(arguments.kategori)#" index="deger">
									<cfset this_hie=listgetat(arguments.kategori,deger)>
									
									P_DIS.PRODUCT_CODE LIKE '#this_hie#.%'
									<cfif deger neq listlen(arguments.kategori)> OR </cfif> 
								</cfloop>
							)  
						</cfif>
					) 
					P_CON
						LEFT JOIN CTE_STOCKS CS ON CS.STOCK_ID = P_CON.STOCK_ID
			WHERE			
				 P_CON.PRODUCT_ID IS NOT NULL
				 <cfif arguments.show_stock_only eq 1>
					AND P_CON.STOK_DURUMU > 0
				 </cfif>
				 <cfif arguments.show_stock_only eq 0>
					AND P_CON.STOK_DURUMU <= 0
				 </cfif>
				 
				<cfif isdefined("arguments.price_value_up") and len(arguments.price_value_up) and isdefined("arguments.price_value_low") and len(arguments.price_value_low)>
					AND 
					(						
							<cfif arguments.price_money eq 'TL'>P_CON.PRICE_KDV_TL<cfelse>P_CON.PRICE_KDV</cfif> BETWEEN <cfqueryparam cfsqltype = "cf_sql_float" value="#arguments.price_value_low#"> AND <cfqueryparam cfsqltype = "cf_sql_float" value="#arguments.price_value_up#"> 			
					)  
				<cfelseif isdefined("arguments.price_value_up") and len(arguments.price_value_up)>
					AND( <cfif arguments.price_money eq 'TL'>P_CON.PRICE_KDV_TL<cfelse>P_CON.PRICE_KDV</cfif> <= <cfqueryparam cfsqltype = "cf_sql_float" value="#arguments.price_value_up#"> )
				<cfelseif isdefined("arguments.price_value_low") and len(arguments.price_value_low)>
					AND( <cfif arguments.price_money eq 'TL'>P_CON.PRICE_KDV_TL<cfelse>P_CON.PRICE_KDV</cfif> >= <cfqueryparam cfsqltype = "cf_sql_float" value="#arguments.price_value_low#">)
				</cfif>	
			ORDER BY
				<cfif arguments.order_type eq 2>
				P_CON.PRICE_KDV_TL DESC,
				<cfelseif arguments.order_type eq 1>
				P_CON.PRICE_KDV_TL ASC,
				<cfelse>
					CS.TOTAL_STOCK DESC,
				</cfif>
				P_CON.HIERARCHY ASC,
				P_CON.PRODUCT_NAME
		</cfquery>
        <cfreturn get_products_query>
    </cffunction>
	 
	<cffunction name="get_products_single" access="remote" returntype="query">
		<cfargument name="hierarchy" default="">
        <cfquery name="get_products_query" datasource="#DSN#">
            SELECT TOP 18
                P.*,
				PS.PRICE_KDV,
				PS.MONEY,
				(SELECT TOP 1 PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = P.PRODUCT_ID AND PI.IMAGE_SIZE = 0 ORDER BY  PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI
            FROM
            	#dsn3_alias#.PRODUCT P,
				#dsn3_alias#.PRODUCT_CAT PC,
				#dsn3_alias#.PRICE_STANDART PS
			WHERE
				PS.PRODUCT_ID = P.PRODUCT_ID AND
				PS.PRICESTANDART_STATUS = 1 AND
				PS.PURCHASESALES = 1 AND
				P.PRODUCT_CATID = PC.PRODUCT_CATID
				<cfif len(arguments.hierarchy)>
					AND P.PRODUCT_CODE LIKE '#arguments.hierarchy#.%'
				</cfif>
		</cfquery>
        <cfreturn get_products_query>
    </cffunction>

	<cffunction name="get_max_min_product_price" access="remote" returntype="query">
		<cfargument name="hierarchy" default="">
        <cfquery name="get_max_product_price_query" datasource="#DSN#">
            SELECT 
				MAX(PS.PRICE_KDV) as max_fiyat,
				MIN(PS.PRICE_KDV) as min_fiyat
            FROM
            	#dsn3_alias#.PRODUCT P,
				#dsn3_alias#.PRODUCT_CAT PC,
				#dsn3_alias#.PRICE_STANDART PS
			WHERE
				PS.PRODUCT_ID = P.PRODUCT_ID AND
				PS.PRICESTANDART_STATUS = 1 AND
				PS.PURCHASESALES = 1 AND
				P.PRODUCT_CATID = PC.PRODUCT_CATID
				<cfif len(arguments.hierarchy)>
					AND P.PRODUCT_CODE LIKE '#arguments.hierarchy#.%'
				</cfif>
        </cfquery>
        <cfreturn get_max_product_price_query>
    </cffunction>
	 
	<cffunction name="get_product_info" access="remote" returntype="query">
			<cfargument name="product_id" default="">
			
		<cfquery name="get_product_query" datasource="#DSN#">
			SELECT 
				(SELECT COUNT(P_IC.PRODUCT_ID) FROM #dsn3_alias#.STOCKS P_IC WHERE P_IC.PRODUCT_ID = P.PRODUCT_ID) AS ALT_URUN_SAYISI,
                P.PRODUCT_NAME,
				P.PRODUCT_CODE,
				P.PRODUCT_CODE_2,
				P.PRODUCT_DETAIL,
				P.PRODUCT_ID,
				P.PRODUCT_DETAIL2,
				PC.PRODUCT_CAT,
				PC.HIERARCHY,
				CASE WHEN (PRC.PRICE IS NOT NULL AND PRC.PRICE > 0) THEN PRC.PRICE ELSE PS.PRICE END AS PRICE,
				CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE_KDV ELSE PS.PRICE_KDV END AS PRICE_KDV,
				CASE 
				WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
					PRC.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
				ELSE
					PS.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
				END AS PRICE_KDV_TL,
				CASE 
					WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
						PRC.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
					ELSE
						PS.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
				END AS PRICE_TL,
				PS.MONEY,
				PB.BRAND_NAME,
				ISNULL((SELECT SUM(SALEABLE_STOCK) FROM  #dsn2_alias#.GET_STOCK_LAST GSL WHERE P.PRODUCT_ID=GSL.PRODUCT_ID),0) AS PRODUCT_TOTAL_STOCK,
				ISNULL((SELECT CASE WHEN PROPERTY1 = '' OR PROPERTY1 IS NULL THEN 0 ELSE PROPERTY1 END AS PROPERTY1 FROM #dsn3_alias#.PRODUCT_INFO_PLUS PIP WHERE P.PRODUCT_ID=PIP.PRODUCT_ID),0) AS PRODUCT_TOTAL_STOCK_B2B,
				(SELECT TOP 1 VIDEO_PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = P.PRODUCT_ID AND PI.IMAGE_SIZE = 2 ORDER BY PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI_YOLU,
				(SELECT TOP 1 PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = P.PRODUCT_ID AND PI.IMAGE_SIZE = 2 ORDER BY  PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI,
				ISNULL((SELECT TOP 1 PROPERTY5 FROM #dsn3_alias#.PRODUCT_INFO_PLUS WHERE PRODUCT_ID=P.PRODUCT_ID),'UCRETLI') AS KARGO_BILGI,
				ISNULL((SELECT TOP 1 SS.PROVISION_TIME
				 FROM 
					#dsn3_alias#.STOCK_STRATEGY SS,
					#dsn3_alias#.STOCKS S
				 WHERE
					SS.STOCK_ID=S.STOCK_ID AND
					S.PRODUCT_ID=P.PRODUCT_ID),-1) AS TEDARIK_SURE,
				ISNULL(C_REL.CONT_BODY,P.PRODUCT_DETAIL) AS P_BIG_INFO
            FROM
            	#dsn3_alias#.PRODUCT P
					LEFT JOIN #dsn3_alias#.PRODUCT_BRANDS PB ON PB.BRAND_ID = P.BRAND_ID
					LEFT JOIN 
					(
						SELECT
							C.CONT_BODY,
							CR.ACTION_TYPE_ID
						FROM
							CONTENT C,
							CONTENT_RELATION CR
						WHERE
							C.CONTENT_ID = CR.CONTENT_ID AND
							CR.ACTION_TYPE = 'PRODUCT_ID'
					) C_REL ON (C_REL.ACTION_TYPE_ID = P.PRODUCT_ID)
					LEFT JOIN #dsn3_alias#.PRICE PRC ON 
								(
								PRC.PRODUCT_ID = P.PRODUCT_ID AND 
								PRC.PRICE_CATID = #attributes.price_cat_id# AND
								(PRC.FINISHDATE IS NULL OR PRC.FINISHDATE > #NOW()#)
								) 
				,
				#dsn3_alias#.PRODUCT_CAT PC,
				#dsn3_alias#.PRICE_STANDART PS
			WHERE
				PS.PRODUCT_ID = P.PRODUCT_ID AND
				PS.PRICESTANDART_STATUS = 1 AND
				PS.PURCHASESALES = 1 AND
				P.PRODUCT_CATID = PC.PRODUCT_CATID
				<cfif len(arguments.product_id)>
					AND P.PRODUCT_ID = #arguments.product_id#
				</cfif>
			</cfquery>
	    <cfreturn get_product_query>
	</cffunction>
	
	<cffunction name="get_related_product" access="remote" returntype="query">
			<cfargument name="product_id" default="">
			
		<cfquery name="get_related_product_query" datasource="#DSN#">
			SELECT 
                P.PRODUCT_NAME,
				P.PRODUCT_CODE,
				P.PRODUCT_CODE_2,
				P.PRODUCT_DETAIL,
				P.PRODUCT_DETAIL2,
				PS.PRICE,
				PS.PRICE_KDV,
				PS.MONEY,
				S.STOCK_ID,
				GPS.PRODUCT_TOTAL_STOCK,
				(SELECT TOP 1 PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = P.PRODUCT_ID AND PI.IMAGE_SIZE = 0 ORDER BY  PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI,
				ISNULL(C_REL.CONT_BODY,P.PRODUCT_DETAIL) AS P_BIG_INFO
            FROM
            	#dsn3_alias#.PRODUCT P
					LEFT JOIN 
					(
						SELECT
							C.CONT_BODY,
							CR.ACTION_TYPE_ID
						FROM
							CONTENT C,
							CONTENT_RELATION CR
						WHERE
							C.CONTENT_ID = CR.CONTENT_ID AND
							CR.ACTION_TYPE = 'PRODUCT_ID'
					) C_REL ON (C_REL.ACTION_TYPE_ID = P.PRODUCT_ID)
				,
				#dsn3_alias#.PRODUCT_CAT PC,
				#dsn3_alias#.PRICE_STANDART PS,
				#dsn2_alias#.GET_PRODUCT_STOCK GPS,
				#dsn3_alias#.RELATED_PRODUCT RP,
				#dsn1_alias#.STOCKS S
			WHERE
				PS.PRODUCT_ID = P.PRODUCT_ID AND
				S.PRODUCT_ID = P.PRODUCT_ID AND
				GPS.PRODUCT_ID =  P.PRODUCT_ID AND
				PS.PRICESTANDART_STATUS = 1 AND
				PS.PURCHASESALES = 1 AND
				P.PRODUCT_CATID = PC.PRODUCT_CATID
				<cfif len(arguments.product_id)>
					AND RP.PRODUCT_ID = #arguments.product_id#
					AND RP.RELATED_PRODUCT_ID=P.PRODUCT_ID
				</cfif>
				
			</cfquery>
	    <cfreturn get_related_product_query>
	</cffunction>
	
	<cffunction name="get_product_img" access="remote" returntype="query">
		<cfargument name="product_id" default="">
		<cfargument name="image_size" default="">
			<cfquery name="get_product_query" datasource="#DSN#">
				SELECT 
					PI.PATH ,
					PI.IMAGE_SIZE,
					PI.VIDEO_PATH
				FROM
					#dsn1_alias#.PRODUCT_IMAGES PI
				WHERE
					 PI.PRODUCT_ID = #arguments.product_id#
					 <cfif len(arguments.image_size)>
						AND PI.IMAGE_SIZE = #arguments.image_size#
					</cfif>
				 ORDER BY  PI.PRODUCT_IMAGEID ASC
			</cfquery>
			
		<cfreturn get_product_query>
	</cffunction>
	
	<cffunction name="get_bestsellers_product" access="remote" returntype="query">
			
		<cfquery name="get_bestsellers_product_query" datasource="#DSN#">
			SELECT TOP 4 P.PRODUCT_DETAIL2,P.PRODUCT_NAME,P.PRODUCT_ID,PS.PRICE_KDV,PS.MONEY,PC.PRODUCT_CAT,
					(SELECT TOP 1 PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI 
					WHERE PI.PRODUCT_ID = P.PRODUCT_ID AND PI.IMAGE_SIZE = 0 ORDER BY  PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI
			FROM 
					(
						SELECT top 4 ORW.PRODUCT_ID, sum(QUANTITY) as SUM
						FROM #dsn3_alias#.ORDER_ROW ORW 
						GROUP BY ORW.PRODUCT_ID,QUANTITY
						ORDER BY SUM  DESC) AS BEST,				 
					 #dsn3_alias#.PRODUCT P,
					 #dsn3_alias#.PRICE_STANDART PS,
					 #dsn3_alias#.PRODUCT_CAT PC
					 
			WHERE	
					P.PRODUCT_ID=BEST.PRODUCT_ID AND
					BEST.PRODUCT_ID=PS.PRODUCT_ID AND
					PS.PRICESTANDART_STATUS = 1 AND
					PS.PURCHASESALES = 1 AND
					P.PRODUCT_CATID = PC.PRODUCT_CATID 
					
					
			</cfquery>
	    <cfreturn get_bestsellers_product_query>
	</cffunction>
	
	<cffunction name="get_product_properties" access="remote" returntype="query">
		<cfargument name="product_id" default="">	
		<cfquery name="get_product_properties_query" datasource="#DSN#">
			SELECT 
				PP.PROPERTY, PPD.PROPERTY_DETAIL,P.PRODUCT_ID,PPD.PROPERTY_DETAIL_ID,PP.PROPERTY_ID
			FROM
				#dsn1_alias#.PRODUCT_PROPERTY PP,
				#dsn3_alias#.PRODUCT P,
				#dsn1_alias#.PRODUCT_DT_PROPERTIES PDP,
				#dsn1_alias#.PRODUCT_PROPERTY_DETAIL PPD
			WHERE
				PP.PROPERTY_ID=PDP.PROPERTY_ID AND
				PDP.PRODUCT_ID=P.PRODUCT_ID	AND
				PPD.PRPT_ID=PP.PROPERTY_ID AND
				PDP.VARIATION_ID=PPD.PROPERTY_DETAIL_ID AND
				
				P.PRODUCT_CODE_2 IN
									(
										SELECT 
											P.PRODUCT_CODE_2
										FROM
											#dsn3_alias#.PRODUCT P
										WHERE
											<cfif len(arguments.product_id)>
												P.PRODUCT_ID = #arguments.product_id#
											</cfif>
									)
				
			GROUP BY PP.PROPERTY, PPD.PROPERTY_DETAIL,P.PRODUCT_ID,PPD.PROPERTY_DETAIL_ID,PP.PROPERTY_ID
		
		</cfquery>
	    <cfreturn get_product_properties_query>
	</cffunction>
	
	<cffunction name="get_product_properties_1" access="remote" returntype="query">
		<cfargument name="product_id" default="">	
		<cfquery name="get_product_properties_query_1" datasource="#DSN#">
			SELECT 
				PP.PROPERTY, PPD.PROPERTY_DETAIL
			FROM
				#dsn1_alias#.PRODUCT_PROPERTY PP,
				#dsn3_alias#.PRODUCT P,
				#dsn1_alias#.PRODUCT_DT_PROPERTIES PDP,
				#dsn1_alias#.PRODUCT_PROPERTY_DETAIL PPD
			WHERE
				PP.PROPERTY_ID=PDP.PROPERTY_ID AND
				PDP.PRODUCT_ID=P.PRODUCT_ID	AND
				PPD.PRPT_ID=PP.PROPERTY_ID AND
				PDP.VARIATION_ID=PPD.PROPERTY_DETAIL_ID AND
					
				<cfif len(arguments.product_id)>
					P.PRODUCT_ID = #arguments.product_id#
				</cfif>						
		
			GROUP BY PP.PROPERTY, PPD.PROPERTY_DETAIL
		
		</cfquery>
	    <cfreturn get_product_properties_query_1>
	</cffunction>
	
	<cffunction name="get_product_properties_2" access="remote" returntype="query">
		<cfargument name="hierarchy" default="">
		<cfargument name="kategori" default="">
		<cfquery name="get_product_properties_query_2" datasource="#DSN#">
			SELECT 
				DISTINCT PP.PROPERTY_CODE, PP.PROPERTY, PPD.PROPERTY_DETAIL_CODE, PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID,PP.PROPERTY_ID
			FROM
				#dsn1_alias#.PRODUCT_PROPERTY PP,
				#dsn3_alias#.PRODUCT P,
				#dsn1_alias#.PRODUCT_DT_PROPERTIES PDP,
				#dsn1_alias#.PRODUCT_PROPERTY_DETAIL PPD
			WHERE
				PP.PROPERTY_ID=PDP.PROPERTY_ID AND
				PDP.PRODUCT_ID=P.PRODUCT_ID	AND
				PPD.PRPT_ID=PP.PROPERTY_ID AND
				PDP.VARIATION_ID=PPD.PROPERTY_DETAIL_ID
				<cfif isdefined("arguments.kategori") and len(arguments.kategori)>
					AND 
					(
						<cfloop from="1" to="#listlen(arguments.kategori)#" index="deger">
							<cfset this_hie=listgetat(arguments.kategori,deger)>
							
							P.PRODUCT_CODE LIKE '#this_hie#.%'
							<cfif deger neq listlen(arguments.kategori)> OR </cfif> 
						</cfloop>
					)  
				<cfelseif len(arguments.hierarchy)>
					AND P.PRODUCT_CODE LIKE '#arguments.hierarchy#.%'
				</cfif>
			GROUP BY PP.PROPERTY_CODE, PP.PROPERTY, PPD.PROPERTY_DETAIL_CODE, PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID,PP.PROPERTY_ID
			ORDER BY PP.PROPERTY_CODE, PP.PROPERTY, PPD.PROPERTY_DETAIL_CODE, PPD.PROPERTY_DETAIL
		</cfquery>
	    <cfreturn get_product_properties_query_2>
	</cffunction>
	
	<cffunction name="get_product_likes" access="remote" returntype="query">
		<cfargument name="product_id" default="">
		<cfquery name="GET_PRODUCT_LIKE" datasource="#DSN#">
			SELECT 
				PRODUCT_ID,
				NAME,
				SURNAME
			FROM 
				#dsn3_alias#.PROTEIN_PRODUCT_LIKE 
			WHERE	
				<cfif len(arguments.product_id)>
					 PRODUCT_ID = #arguments.product_id#
				</cfif>
			GROUP BY 
				PRODUCT_ID,
				NAME,
				SURNAME
		</cfquery>
		<cfreturn GET_PRODUCT_LIKE>
	</cffunction>

	<cffunction name="get_high_rated_products" access="remote" returntype="query">
		<cfquery name="GET_HIGH_PRODUCT_LIKE" datasource="#DSN#">
			SELECT	
				TOP 4
				PPL.PRODUCT_ID,
				PPL.NAME,
				PPL.SURNAME,
				PPL.STAR,
				P.PRODUCT_NAME,
				P.PRODUCT_DETAIL2,
				(SELECT TOP 1 PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = P.PRODUCT_ID AND PI.IMAGE_SIZE = 0 ORDER BY  PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI,
				PC.PRODUCT_CAT
			FROM 
				#dsn3_alias#.PROTEIN_PRODUCT_LIKE PPL 
				LEFT JOIN #dsn3_alias#.PRODUCT P ON P.PRODUCT_ID=PPL.PRODUCT_ID
				LEFT JOIN #dsn3_alias#.PRODUCT_CAT PC ON P.PRODUCT_CATID=PC.PRODUCT_CATID

			ORDER BY PPL.STAR DESC	
		</cfquery>
		<cfreturn GET_HIGH_PRODUCT_LIKE>
	</cffunction>	
		
	<cffunction name="get_product_brands" access="remote" returntype="query">
		<cfargument name="hierarchy" default="">
		<cfquery name="get_product_brands_query" datasource="#DSN#">
				SELECT 
					DISTINCT PB.BRAND_NAME,PB.BRAND_ID
				FROM				
					#dsn3_alias#.PRODUCT_BRANDS PB,
					#dsn3_alias#.PRODUCT P
				WHERE
					PB.BRAND_ID=P.BRAND_ID 
					<cfif len(arguments.hierarchy)>
						AND P.PRODUCT_CODE LIKE '#arguments.hierarchy#.%'
					</cfif>
				
		</cfquery>
		<cfreturn get_product_brands_query>
	</cffunction>

	<cffunction name="get_product_comments" access="remote" returntype="query">
		<cfargument name="product_id" default="">
		<cfquery name="GET_PRODUCT_COMMENT" datasource="#DSN#">
			SELECT 
				PC.NAME,
				PC.SURNAME,
				PC.PRODUCT_COMMENT_POINT,
				PC.PRODUCT_COMMENT,
				PC.RECORD_DATE
			FROM
				#dsn3_alias#.PRODUCT_COMMENT PC 
			WHERE
				PC.STAGE_ID = -2
				<cfif len(arguments.hierarchy)>
				AND PRODUCT_ID = #arguments.product_id#
				</cfif>
			ORDER BY
				PC.RECORD_DATE DESC
		</cfquery>
		<cfreturn GET_PRODUCT_COMMENT >

	</cffunction>

	<cffunction name="get_product_vote" acsess="remote" returntype="query">
		<cfargument name="product_id" default="">
		<cfif isdefined('attributes.is_comment_graph') and attributes.is_comment_graph eq 1>
		<cfquery name="GET_PRODUCT_VOTE" datasource="#DSN#">
			SELECT 
				PRODUCT_COMMENT_POINT,
				COUNT(PRODUCT_COMMENT_POINT) AS PUAN
			FROM 
				#dsn3_alias#.PRODUCT_COMMENT 
			WHERE
				STAGE_ID = -2
			<cfif len(arguments.hierarchy)>			
				AND PRODUCT_ID = #arguments.product_id#
			</cfif>				
			
			GROUP BY 
				PRODUCT_COMMENT_POINT
		</cfquery>
		</cfif>
		<cfreturn GET_PRODUCT_VOTE >

	</cffunction>
	
	<cffunction name="get_banners" access="remote" returntype="query">
		<cfargument name="banner_area" default="">
		<cfargument name="product_catid" default="">
		<cfargument name="product_id" default="">
		<cfargument name="homepage" default="">
		<cfargument name="record" default="10">
        <cfquery name="get_banners_query" datasource="#DSN#">
            SELECT TOP #arguments.record#
                BANNER_FILE,
				BANNER_NAME,
				DETAIL,
				SEQUENCE,
				URL
            FROM
            	CONTENT_BANNERS
			WHERE
				IS_ACTIVE = 1 AND
				START_DATE <= #NOW()# AND
				FINISH_DATE >= #NOW()# AND
				BANNER_AREA_ID = #arguments.banner_area#
				<cfif len(arguments.product_catid)>
					AND BANNER_PRODUCTCAT_ID = #arguments.product_catid#
				</cfif>
				<cfif len(arguments.product_id)>
					AND BANNER_PRODUCT_ID = #arguments.product_id#
				</cfif>
				<cfif len(arguments.homepage)>
					AND IS_HOMEPAGE = #arguments.homepage#
				</cfif>
			ORDER BY 
				ISNULL(SEQUENCE,999) ASC
        </cfquery>
        <cfreturn get_banners_query>
    </cffunction>
	
	<cffunction name="get_company_info" access="remote" returntype="query">
		<cfquery name="query_company_info" datasource="#DSN#">
			SELECT * 
			FROM OUR_COMPANY
		</cfquery>
		<cfreturn query_company_info>
	</cffunction>
	
	<cffunction name="set_product_comments" access="remote" returntype="any">
		<cfargument name="name" default="">
		<cfargument name="surname" default="">
		<cfargument name="email" default="">
		<cfargument name="product_id" default="">
		<cfquery name="SET_PRODUCT_COMMENT" datasource="#DSN#">
			INSERT INTO		
				#dsn3_alias#.PRODUCT_COMMENT(NAME,SURNAME,MAIL_ADDRESS,PRODUCT_ID)
			VALUES 
			(
				<cfif isDefined('arguments.name') and len(arguments.name)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
				</cfif>
				<cfif isDefined('arguments.surname') and len(arguments.surname)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.surname#">,
				</cfif>
				<cfif isDefined('arguments.email') and len(arguments.email)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">,
				</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_id#">
			)
		</cfquery>
		<cfreturn "1">
	</cffunction>
	
	<cffunction name="del_all_product_from_basket" access="remote" returntype="any">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="">
		
		<cfquery name="add_p" datasource="#DSN#">
			DELETE FROM #dsn3_alias#.ORDER_PRE_ROWS
				WHERE
					<cfif len(arguments.consumer_id)>
						(RECORD_CONS = #arguments.consumer_id# OR COOKIE_NAME = '#arguments.cookie_name#')
					<cfelseif len(arguments.partner_id)>
						(RECORD_PAR  = #arguments.partner_id# OR COOKIE_NAME = '#arguments.cookie_name#')
					<cfelse>
						COOKIE_NAME = '#arguments.cookie_name#'
					</cfif>
		</cfquery>
				
		<cfreturn "1">
	</cffunction>
	
	<cffunction name="del_product_from_basket" access="remote" returntype="any">
		<cfargument name="product_id" default="">
		<cfargument name="stock_id" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="">
		
		<cfquery name="add_p" datasource="#DSN#">
			DELETE FROM #dsn3_alias#.ORDER_PRE_ROWS
				WHERE
					PRODUCT_ID = #arguments.product_id# AND
					STOCK_ID = #arguments.stock_id# AND
					<cfif len(arguments.consumer_id)>
						(RECORD_CONS = #arguments.consumer_id# OR COOKIE_NAME = '#arguments.cookie_name#')
					<cfelseif len(arguments.partner_id)>
						(RECORD_PAR  = #arguments.partner_id# OR COOKIE_NAME = '#arguments.cookie_name#')
					<cfelse>
						COOKIE_NAME = '#arguments.cookie_name#'
					</cfif>
		</cfquery>
				
		<cfreturn "1">
	</cffunction>
	
	<cffunction name="upd_product_count" access="remote" returntype="any">
		<cfargument name="stock_id" default="">
		<cfargument name="product_count" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="">
		
		<cfquery name="add_p" datasource="#DSN#">
			UPDATE
				#dsn3_alias#.ORDER_PRE_ROWS
			SET
				QUANTITY = #product_count#
			WHERE
				STOCK_ID = #arguments.stock_id# AND
				<cfif len(arguments.consumer_id)>
					(RECORD_CONS = #arguments.consumer_id# OR COOKIE_NAME = '#arguments.cookie_name#')
				<cfelseif len(arguments.partner_id)>
					(RECORD_PAR  = #arguments.partner_id# OR COOKIE_NAME = '#arguments.cookie_name#')
				<cfelse>
					COOKIE_NAME = '#arguments.cookie_name#'
				</cfif>
		</cfquery>
				
		<cfreturn "1">
	</cffunction>
	
	<cffunction name="del_cargo" access="remote" returntype="any">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="">
		
		<cfquery name="add_p" datasource="#DSN#">
			DELETE FROM
				#dsn3_alias#.ORDER_PRE_ROWS
			WHERE
				IS_CARGO = 1
				<cfif len(arguments.consumer_id)>
					AND RECORD_CONS = #arguments.consumer_id#
				<cfelseif len(arguments.partner_id)>
					AND RECORD_PAR = #arguments.partner_id#
				<cfelse>
					AND COOKIE_NAME = '#arguments.cookie_name#'
				</cfif>
		</cfquery>
		
		<cfquery name="add_act" datasource="#DSN#">
			UPDATE
				#dsn3_alias#.ORDER_PRE_ROWS
			SET
				SHIPMENT_ID = NULL
			WHERE				
				<cfif len(arguments.consumer_id)>
					(RECORD_CONS = #arguments.consumer_id# OR COOKIE_NAME = '#arguments.cookie_name#')
				<cfelseif len(arguments.partner_id)>
					(RECORD_PAR  = #arguments.partner_id# OR COOKIE_NAME = '#arguments.cookie_name#')
				<cfelse>
					COOKIE_NAME = '#arguments.cookie_name#'
				</cfif>
		</cfquery>
		
		<cfreturn "1">
	</cffunction>
	
	<cffunction name="add_cargo_to_basket" access="remote" returntype="any">
		<cfargument name="product_id" default="">
		<cfargument name="stock_id" default="">
		<cfargument name="quantity" default="">
		<cfargument name="price" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="">
		
		<cfset DONUS_DEGERI = 0>
		
		<cftry>
			<cfquery name="check_" datasource="#DSN#">
				SELECT QUANTITY,ORDER_ROW_ID FROM #dsn3_alias#.ORDER_PRE_ROWS
				WHERE
					IS_CARGO = 1
					<cfif len(arguments.consumer_id)>
						AND RECORD_CONS = #arguments.consumer_id#
					<cfelseif len(arguments.partner_id)>
						AND RECORD_PAR = #arguments.partner_id#
					<cfelse>
						AND COOKIE_NAME = '#arguments.cookie_name#'
					</cfif>
			</cfquery>
			
			<cfif check_.recordcount>
				<cfquery name="add_p" datasource="#DSN#">
					DELETE FROM
						#dsn3_alias#.ORDER_PRE_ROWS
					WHERE
						IS_CARGO = 1
						<cfif len(arguments.consumer_id)>
							AND RECORD_CONS = #arguments.consumer_id#
						<cfelseif len(arguments.partner_id)>
							AND RECORD_PAR = #arguments.partner_id#
						<cfelse>
							AND COOKIE_NAME = '#arguments.cookie_name#'
						</cfif>
				</cfquery>
			</cfif>
			<cfif arguments.price gt 0>
				<cfquery name="add_p" datasource="#DSN#">
					INSERT INTO #dsn3_alias#.ORDER_PRE_ROWS
						(
						PRODUCT_ID,
						STOCK_ID,
						QUANTITY,
						PRICE,
						IS_CARGO,
						RECORD_CONS,
						RECORD_PAR,
						COOKIE_NAME,
						RECORD_DATE
						)
					VALUES 
						(
						#arguments.product_id#,
						#arguments.stock_id#,
						#arguments.quantity#,
						#arguments.price#,
						1,
						<cfif len(arguments.consumer_id)>#arguments.consumer_id#<cfelse>NULL</cfif>,
						<cfif len(arguments.partner_id)>#arguments.partner_id#<cfelse>NULL</cfif>,
						'#arguments.cookie_name#',
						#now()#
						)
				</cfquery>
			</cfif>
		
			<cfset DONUS_DEGERI = 1>
			<cfcatch type="any">
				<cfset DONUS_DEGERI = -1>
			</cfcatch>
		</cftry>
		<cfreturn "#DONUS_DEGERI#">
	</cffunction>
	
	<cffunction name="add_commission_to_basket" access="remote" returntype="any">
		<cfargument name="product_id" default="">
		<cfargument name="stock_id" default="">
		<cfargument name="quantity" default="">
		<cfargument name="price" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="">
		
		<cfset DONUS_DEGERI = 0>
		
		<cftry>
			<cfquery name="check_" datasource="#DSN#">
				SELECT QUANTITY,ORDER_ROW_ID FROM #dsn3_alias#.ORDER_PRE_ROWS
				WHERE
					IS_COMMISSION = 1
					<cfif len(arguments.consumer_id)>
						AND RECORD_CONS = #arguments.consumer_id#
					<cfelseif len(arguments.partner_id)>
						AND RECORD_PAR = #arguments.partner_id#
					<cfelse>
						AND COOKIE_NAME = '#arguments.cookie_name#'
					</cfif>
			</cfquery>
			
			<cfif check_.recordcount>
				<cfquery name="add_p" datasource="#DSN#">
					DELETE FROM
						#dsn3_alias#.ORDER_PRE_ROWS
					WHERE
						IS_COMMISSION = 1
						<cfif len(arguments.consumer_id)>
							AND RECORD_CONS = #arguments.consumer_id#
						<cfelseif len(arguments.partner_id)>
							AND RECORD_PAR = #arguments.partner_id#
						<cfelse>
							AND COOKIE_NAME = '#arguments.cookie_name#'
						</cfif>
				</cfquery>
			</cfif>
			
			<cfquery name="get_price" datasource="#DSN3#">
				SELECT 
					PRICE,
					PRICE_KDV
				FROM 
					PRICE_STANDART PS
				WHERE 
					PS.PRICESTANDART_STATUS = 1 AND
					PS.PURCHASESALES = 1 AND
					PS.PRODUCT_ID = #arguments.product_id#
			</cfquery>
			
			<cfquery name="add_p" datasource="#DSN#">
				INSERT INTO #dsn3_alias#.ORDER_PRE_ROWS
					(
					PRODUCT_ID,
					STOCK_ID,
					QUANTITY,
					PRICE,
					PRICE_KDV,
					IS_COMMISSION,
					RECORD_CONS,
					RECORD_PAR,
					COOKIE_NAME,
					RECORD_DATE
					)
				VALUES 
					(
					#arguments.product_id#,
					#arguments.stock_id#,
					#arguments.quantity#,
					#get_price.price#,
					#get_price.price_kdv#,
					1,
					<cfif len(arguments.consumer_id)>#arguments.consumer_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.partner_id)>#arguments.partner_id#<cfelse>NULL</cfif>,
					'#arguments.cookie_name#',
					#now()#
					)
			</cfquery>
		
			<cfset DONUS_DEGERI = 1>
			<cfcatch type="any">
				<cfset DONUS_DEGERI = -1>
			</cfcatch>
		</cftry>
		<cfreturn "#DONUS_DEGERI#">
	</cffunction>
	
	<cffunction name="del_commission_to_basket" access="remote" returntype="any">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="">
		
		<cfquery name="del_com" datasource="#DSN#">
			DELETE FROM #dsn3_alias#.ORDER_PRE_ROWS
				WHERE
					IS_COMMISSION = 1 AND
					<cfif len(arguments.consumer_id)>
						(RECORD_CONS = #arguments.consumer_id# OR COOKIE_NAME = '#arguments.cookie_name#')
					<cfelseif len(arguments.partner_id)>
						(RECORD_PAR  = #arguments.partner_id# OR COOKIE_NAME = '#arguments.cookie_name#')
					<cfelse>
						COOKIE_NAME = '#arguments.cookie_name#'
					</cfif>
		</cfquery>
				
		<cfreturn "1">
	</cffunction>	
	
	<cffunction name="add_product_to_basket" access="remote" returntype="string" returnFormat="json">>
		<cfargument name="product_id" default="">
		<cfargument name="stock_id" default="">
		<cfargument name="quantity" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="#CFTOKEN#">
		<cfscript>
			StructAppend(arguments,deserializeJSON(getHttpRequestData().content),true);
		</cfscript>	
		<cfdump var="#arguments#">
		<cfset result.code = 0>
		
		<cftry>
			<cfquery name="check_" datasource="#DSN#">
				SELECT QUANTITY,ORDER_ROW_ID FROM #dsn3_alias#.ORDER_PRE_ROWS
				WHERE
					STOCK_ID = #arguments.stock_id#
					<cfif len(arguments.consumer_id)>
						AND RECORD_CONS = #arguments.consumer_id#
					<cfelseif len(arguments.partner_id)>
						AND RECORD_PAR = #arguments.partner_id#
					<cfelse>
						AND COOKIE_NAME = '#arguments.cookie_name#'
					</cfif>
			</cfquery>
			
			<cfif check_.recordcount>
				<cfset old_deger_ = check_.QUANTITY>
			<cfelse>
				<cfset old_deger_ = 0>
			</cfif>
			<cfset son_deger_ = old_deger_ + arguments.quantity>
			
			<cfquery name="get_stock_last" datasource="#dsn#">
				SELECT 
					(SALEABLE_STOCK + ISNULL((SELECT CASE WHEN PROPERTY1 = '' OR PROPERTY1 IS NULL THEN 0 ELSE PROPERTY1 END AS PROPERTY1 FROM #dsn3_alias#.PRODUCT_INFO_PLUS PIP WHERE GSL.PRODUCT_ID=PIP.PRODUCT_ID),0)) AS SALEABLE_STOCK
				FROM  
					#dsn2_alias#.GET_STOCK_LAST GSL	
				WHERE GSL.STOCK_ID = #arguments.stock_id#
			</cfquery>
			
			<cfif get_stock_last.recordcount and get_stock_last.SALEABLE_STOCK gte son_deger_>			
					<cfif check_.recordcount>
						<cfquery name="add_p" datasource="#DSN#">
						UPDATE
							#dsn3_alias#.ORDER_PRE_ROWS
						SET
							QUANTITY = QUANTITY + #arguments.quantity#
						WHERE
							ORDER_ROW_ID = #check_.ORDER_ROW_ID#
						</cfquery>
					<cfelse>
						<cfquery name="add_p" datasource="#DSN#">
							INSERT INTO #dsn3_alias#.ORDER_PRE_ROWS
								(
								PRODUCT_ID,
								STOCK_ID,
								QUANTITY,
								RECORD_CONS,
								RECORD_PAR,
								COOKIE_NAME,
								RECORD_DATE
								)
							VALUES 
								(
								#arguments.product_id#,
								#arguments.stock_id#,
								#arguments.quantity#,
								<cfif len(arguments.consumer_id)>#arguments.consumer_id#<cfelse>NULL</cfif>,
								<cfif len(arguments.partner_id)>#arguments.partner_id#<cfelse>NULL</cfif>,
								'#arguments.cookie_name#',
								#now()#
								)
						</cfquery>
					</cfif>
					<cfset result.code = 1>
			<cfelse>
				<cfset result.code = -2>
				<cfset result.error = "Yetersiz Stok" >
			</cfif>
			<cfset result.status = true>
            <cfset result.identitycol = #arguments.stock_id#>
            <cfcatch type="any">
                <cfset result.status = false>
				<cfset result.code = -3>
                <cfset result.error = cfcatch.message >
            </cfcatch>
		</cftry>
		<cfreturn Replace(SerializeJSON(result),'//','')>    
	</cffunction>
	
	<cffunction name="get_product_to_basket" access="remote" returntype="any">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="#CFTOKEN#">
		
		
			<cfif len(arguments.consumer_id)>
				<cfquery name="upd_" datasource="#DSN#">
					UPDATE
						#dsn3_alias#.ORDER_PRE_ROWS
					SET
						RECORD_CONS = #arguments.consumer_id#
					WHERE
						RECORD_CONS IS NULL AND
						COOKIE_NAME = '#arguments.cookie_name#'
				</cfquery>
			</cfif>
			
			<cfquery name="get_products" datasource="#DSN#">
				SELECT
					(
					SELECT TOP 1
						CM.NICKNAME
					FROM 
						SHIP_METHOD_PRICE SMP,
						SHIP_METHOD_PRICE_ROW SMPR,
						COMPANY CM
					WHERE
						SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND
						SMP.COMPANY_ID = CM.COMPANY_ID AND
						SMPR.SHIP_METHOD_ID = OPR.SHIPMENT_ID						
					) AS SHIPMENT_COMP,
					(SELECT C.CONSUMER_EMAIL FROM CONSUMER C WHERE C.CONSUMER_ID = OPR.RECORD_CONS) AS CONSUMER_EMAIL,
					OPR.QUANTITY,
					OPR.PRODUCT_ID,
					OPR.STOCK_ID,
					CASE 
						WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
							OPR.QUANTITY * PRC.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
						ELSE
							OPR.QUANTITY * PS.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
					END AS PRICE_KDV_TL,
					CASE 
						WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
							OPR.QUANTITY * PRC.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
						ELSE
							OPR.QUANTITY * PS.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
					END AS PRICE_TL,
					OPR.DELIVER_ID,
					OPR.INVOICE_DELIVER_ID,
					OPR.PAYMENT_ID,
					OPR.SHIPMENT_ID,
					OPR.IS_CARGO,
					OPR.ORDER_ROW_ID,
					CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE_KDV ELSE PS.PRICE_KDV END AS PRICE_KDV,
					CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE ELSE PS.PRICE END AS PRICE,
					CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.MONEY ELSE PS.MONEY END AS MONEY,
					OPR.PRICE AS PRICE_CARGO,					
					S.PRODUCT_NAME,
					S.STOCK_CODE_2,
					S.PROPERTY,
					(SELECT TOP 1 PI.PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = OPR.PRODUCT_ID AND PI.IMAGE_SIZE = 2 ORDER BY  PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI,
					ISNULL((SELECT SALEABLE_STOCK FROM  #dsn2_alias#.GET_STOCK_LAST GSL WHERE OPR.STOCK_ID=GSL.STOCK_ID),0) AS STOK_DURUMU,
					ISNULL((SELECT CASE WHEN (PIP.PROPERTY1 = '' OR PIP.PROPERTY1 IS NULL) THEN 0 ELSE PIP.PROPERTY1 END AS PROPERTY1 FROM #dsn3_alias#.PRODUCT_INFO_PLUS PIP WHERE S.PRODUCT_ID=PIP.PRODUCT_ID),0) AS PRODUCT_TOTAL_STOCK_B2B,
					(SELECT DIMENTION FROM #dsn3_alias#.PRODUCT_UNIT PU WHERE PU.PRODUCT_ID = OPR.PRODUCT_ID) AS DESI
				FROM 
					#dsn3_alias#.ORDER_PRE_ROWS OPR
						LEFT JOIN #dsn1_alias#.PRICE_STANDART PS ON PS.PRODUCT_ID=OPR.PRODUCT_ID
						LEFT JOIN #dsn3_alias#.STOCKS S ON S.PRODUCT_ID=OPR.PRODUCT_ID
						LEFT JOIN #dsn3_alias#.PRICE PRC ON 
								(
								PRC.PRODUCT_ID = OPR.PRODUCT_ID AND 
								PRC.PRICE_CATID = #attributes.price_cat_id# AND
								(PRC.FINISHDATE IS NULL OR PRC.FINISHDATE > #NOW()#)
								) 
				WHERE
					PS.PURCHASESALES=1 AND
					PS.PRICESTANDART_STATUS=1
					<cfif len(arguments.consumer_id)>
						AND RECORD_CONS = #arguments.consumer_id#
					<cfelseif len(arguments.partner_id)>
						AND RECORD_PAR = #arguments.partner_id#
					<cfelse>
						AND COOKIE_NAME = '#arguments.cookie_name#'
					</cfif>
			</cfquery>
		<cfreturn get_products>
	</cffunction>
	
	<cffunction name="get_pre_order_products" access="remote" returntype="any">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="#CFTOKEN#">
		
			<cfif len(arguments.consumer_id)>
				<cfquery name="upd_" datasource="#DSN#">
					UPDATE
						#dsn3_alias#.ORDER_PRE_ROWS
					SET
						RECORD_CONS = #arguments.consumer_id#
					WHERE
						RECORD_CONS IS NULL AND
						COOKIE_NAME = '#arguments.cookie_name#'
				</cfquery>
			</cfif>
			
			<cfquery name="get_products" datasource="#DSN#">
				SELECT
					(
					SELECT TOP 1
						CM.NICKNAME
					FROM 
						SHIP_METHOD_PRICE SMP,
						SHIP_METHOD_PRICE_ROW SMPR,
						COMPANY CM
					WHERE
						SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND
						SMP.COMPANY_ID = CM.COMPANY_ID AND
						SMPR.SHIP_METHOD_ID = OPR.SHIPMENT_ID						
					) AS SHIPMENT_COMP,
					(SELECT C.CONSUMER_EMAIL FROM CONSUMER C WHERE C.CONSUMER_ID = OPR.RECORD_CONS) AS CONSUMER_EMAIL,
					OPR.QUANTITY,
					OPR.PRODUCT_ID,
					OPR.STOCK_ID,
					CASE 
						WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
							OPR.QUANTITY * PRC.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
						ELSE
							OPR.QUANTITY * PS.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
					END AS PRICE_KDV_TL,
					CASE 
						WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
							OPR.QUANTITY * PRC.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
						ELSE
							OPR.QUANTITY * PS.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
					END AS PRICE_TL,
					CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE_KDV ELSE PS.PRICE_KDV END AS PRICE_KDV,
					CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE ELSE PS.PRICE END AS PRICE,
					CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.MONEY ELSE PS.MONEY END AS MONEY,
					OPR.DELIVER_ID,
					OPR.INVOICE_DELIVER_ID,
					OPR.PAYMENT_ID,
					OPR.SHIPMENT_ID,
					OPR.ACCOUNT_ID,
					OPR.IS_CARGO,
					OPR.ORDER_ROW_ID,
					OPR.HAVALE_BANKA,
					OPR.HAVALE_TARIH,
					OPR.HAVALE_NO,
					OPR.ORDER_DETAIL,
					OPR.PRICE AS PRICE_CARGO,
					OPR.RECORD_CONS,
					OPR.RECORD_PAR,
					OPR.SPEC_VAR_ID,
					OPR.IS_SPEC,
					OPR.DISCOUNT1,
					OPR.DISCOUNT2,
					OPR.DISCOUNT3,
					OPR.DISCOUNT4,
					OPR.DISCOUNT5,					
					S.PRODUCT_NAME,
					S.PROPERTY,
					S.TAX,
					PU.MAIN_UNIT,
					PU.PRODUCT_UNIT_ID,
					NULL AS SPEC_VAR_ID,
					ISNULL(OPR.PROM_STOCK_AMOUNT,1) AS PROM_STOCK_AMOUNT,
					OPR.PROM_AMOUNT_DISCOUNT,
					OPR.PROM_DISCOUNT,
					0 AS PRICE_OLD,
					0 AS PROM_COST,
					OPR.PROM_ID,
					OPR.IS_PROM_ASIL_HEDIYE,
					OPR.IS_COMMISSION,
					OPR.IS_PRODUCT_PROMOTION_NONEFFECT,
					OPR.IS_GENERAL_PROM,
					OPR.LOT_NO,
					OPR.DEMAND_ID,
					(SELECT TOP 1 PI.PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = OPR.PRODUCT_ID AND PI.IMAGE_SIZE = 2 ORDER BY  PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI,
					ISNULL((SELECT SALEABLE_STOCK FROM  #dsn2_alias#.GET_STOCK_LAST GSL WHERE OPR.STOCK_ID=GSL.STOCK_ID),0) AS STOK_DURUMU,
					(SELECT DIMENTION FROM #dsn3_alias#.PRODUCT_UNIT PU WHERE PU.PRODUCT_ID = OPR.PRODUCT_ID) AS DESI
				FROM 
					#dsn3_alias#.ORDER_PRE_ROWS OPR
						LEFT JOIN #dsn1_alias#.PRICE_STANDART PS ON PS.PRODUCT_ID=OPR.PRODUCT_ID
						LEFT JOIN #dsn3_alias#.STOCKS S ON S.PRODUCT_ID=OPR.PRODUCT_ID
						LEFT JOIN #dsn3_alias#.PRODUCT_UNIT PU ON S.PRODUCT_ID=PU.PRODUCT_ID
						LEFT JOIN #dsn3_alias#.PRICE PRC ON 
								(
								PRC.PRODUCT_ID = OPR.PRODUCT_ID AND 
								PRC.PRICE_CATID = #attributes.price_cat_id# AND
								(PRC.FINISHDATE IS NULL OR PRC.FINISHDATE > #NOW()#)
								) 
				WHERE
					PU.IS_MAIN = 1 AND
					PS.PURCHASESALES=1 AND
					PS.PRICESTANDART_STATUS=1
					<cfif len(arguments.consumer_id)>
						AND RECORD_CONS = #arguments.consumer_id#
					<cfelseif len(arguments.partner_id)>
						AND RECORD_PAR = #arguments.partner_id#
					<cfelse>
						AND COOKIE_NAME = '#arguments.cookie_name#'
					</cfif>
				ORDER BY 
					OPR.IS_CARGO ASC
			</cfquery>
		<cfreturn get_products>
	</cffunction>	
	
	<cffunction name="add_order_detail_to_basket" access="remote" returntype="any">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="">
		<cfargument name="order_detail" default="">
		
			<cfquery name="upd_order_detail" datasource="#DSN#">
				UPDATE
					#dsn3_alias#.ORDER_PRE_ROWS
				SET
					ORDER_DETAIL = '#arguments.order_detail#'
				WHERE
					<cfif len(arguments.consumer_id)>
						 RECORD_CONS = #arguments.consumer_id#
					<cfelseif len(arguments.partner_id)>
						 RECORD_PAR = #arguments.partner_id#
					<cfelse>
						 COOKIE_NAME = '#arguments.cookie_name#'
					</cfif>
			</cfquery>
			<cfreturn '1'>
	</cffunction>
	
	<cffunction name="get_product_to_basket_info" access="remote" returntype="any">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="">
		
			<cfquery name="get_products_info" datasource="#DSN#">
				SELECT
					OPR.QUANTITY,
					OPR.PRODUCT_ID,
					OPR.STOCK_ID,
					CASE 
						WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
							OPR.QUANTITY * PRC.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
						ELSE
							OPR.QUANTITY * PS.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
					END AS PRICE_KDV_TL,
					CASE 
						WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
							OPR.QUANTITY * PRC.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
						ELSE
							OPR.QUANTITY * PS.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
					END AS PRICE_TL,
					CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE_KDV ELSE PS.PRICE_KDV END AS PRICE_KDV,
					CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE ELSE PS.PRICE END AS PRICE,
					CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.MONEY ELSE PS.MONEY END AS MONEY,
					OPR.DELIVER_ID,
					OPR.INVOICE_DELIVER_ID,
					OPR.PAYMENT_ID,
					OPR.SHIPMENT_ID,
					OPR.IS_CARGO,
					PS.PRICE_KDV,
					PS.PRICE,
					OPR.PRICE AS PRICE_CARGO,
					PS.MONEY,					
					S.PRODUCT_NAME,
					S.PROPERTY,
					(SELECT TOP 1 PI.PATH FROM #dsn1_alias#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = OPR.PRODUCT_ID AND PI.IMAGE_SIZE = 0 ORDER BY  PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI,
					ISNULL((SELECT SALEABLE_STOCK FROM  #dsn2_alias#.GET_STOCK_LAST GSL WHERE OPR.STOCK_ID=GSL.STOCK_ID),0) AS STOK_DURUMU
				FROM 
					#dsn3_alias#.ORDER_PRE_ROWS OPR 
						LEFT JOIN #dsn1_alias#.PRICE_STANDART PS ON PS.PRODUCT_ID=OPR.PRODUCT_ID
						LEFT JOIN #dsn3_alias#.STOCKS S ON S.PRODUCT_ID=OPR.PRODUCT_ID
						LEFT JOIN #dsn3_alias#.PRICE PRC ON 
								(
								PRC.PRODUCT_ID = OPR.PRODUCT_ID AND 
								PRC.PRICE_CATID = #attributes.price_cat_id# AND
								(PRC.FINISHDATE IS NULL OR PRC.FINISHDATE > #NOW()#)
								) 
				WHERE
					PS.PURCHASESALES=1 AND
					PS.PRICESTANDART_STATUS=1
					<cfif len(arguments.consumer_id)>
						AND RECORD_CONS = #arguments.consumer_id#
					<cfelseif len(arguments.partner_id)>
						AND RECORD_PAR = #arguments.partner_id#
					<cfelse>
						AND COOKIE_NAME = '#arguments.cookie_name#'
					</cfif>
			</cfquery>
			
		
		<cfreturn get_products_info>
	</cffunction>
	
	<cffunction name="add_action_to_basket" access="remote" returntype="any">
		<cfargument name="action_type" default="">
		<cfargument name="action_id" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="">
		
		<cfquery name="add_act" datasource="#DSN#">
			UPDATE
				#dsn3_alias#.ORDER_PRE_ROWS
			SET
				<cfif arguments.action_type is 'deliver_id'>
					DELIVER_ID = #arguments.action_id#
				</cfif>
				<cfif arguments.action_type is 'invoice_deliver_id'>
					INVOICE_DELIVER_ID = #arguments.action_id#
				</cfif>
				<cfif arguments.action_type is 'paymethod_id'>
					PAYMENT_ID = #listgetat(arguments.action_id,2,'-')#,
					ACCOUNT_ID = <cfif listlen(arguments.action_id,'-') gte 3 and listgetat(arguments.action_id,3,'-') neq 0>#listgetat(arguments.action_id,3,'-')#<cfelse>NULL</cfif>,
					BANKA_ID = <cfif listlen(arguments.action_id,'-') gte 4 and listgetat(arguments.action_id,4,'-') neq 0>#listgetat(arguments.action_id,4,'-')#<cfelse>NULL</cfif>,
					PAYMENT_COUNT = <cfif listlen(arguments.action_id,'-') gte 5 and listgetat(arguments.action_id,5,'-') neq 0>#listgetat(arguments.action_id,5,'-')#<cfelse>1</cfif>
				</cfif>
				<cfif arguments.action_type is 'shipment_id'>
					SHIPMENT_ID = #arguments.action_id#	
				</cfif>
				<cfif arguments.action_type is 'havale_banka'>
					HAVALE_BANKA = '#arguments.action_id#'	
				</cfif>
				<cfif arguments.action_type is 'havale_tarih'>
					HAVALE_TARIH = '#arguments.action_id#'	
				</cfif>
				<cfif arguments.action_type is 'havale_no'>
					HAVALE_NO = '#arguments.action_id#'	
				</cfif>
			WHERE				
				<cfif len(arguments.consumer_id)>
					(RECORD_CONS = #arguments.consumer_id# OR COOKIE_NAME = '#arguments.cookie_name#')
				<cfelseif len(arguments.partner_id)>
					(RECORD_PAR  = #arguments.partner_id# OR COOKIE_NAME = '#arguments.cookie_name#')
				<cfelse>
					COOKIE_NAME = '#arguments.cookie_name#'
				</cfif>
		</cfquery>
		<cfreturn "1">
	</cffunction>

	<cffunction name="del_actions" access="remote" returntype="any">
		<cfargument name="action_type" default="">
		<cfargument name="action_id" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfargument name="cookie_name" default="">
		
		<cfif arguments.action_type is 'consumer_deliver'>
			<cfif isdefined('session.pp.userid')>
			<cfquery name="del_adres" datasource="#DSN#">
				DELETE FROM COMPANY_BRANCH
				
				WHERE
						COMPBRANCH_ID=#arguments.action_id#
			</cfquery>
			<cfelse>
			<cfquery name="del_adres" datasource="#DSN#">
				DELETE FROM CONSUMER_BRANCH
				
				WHERE
						CONTACT_ID=#arguments.action_id#
			</cfquery>
			</cfif>
		</cfif>		
		<cfreturn "1">
	</cffunction>
	
	<cffunction name="add_order_func" access="remote" returntype="any">		
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
		<cfinclude template="../query/add_order_query.cfm">
		<cfreturn "1">		
		
	</cffunction>

	<cffunction name="get_stok_func" access="remote" returntype="query">
		<cfargument name="product_id" default="">
		<cfquery name="get_stok" datasource="#DSN#">
			SELECT 
				S.STOCK_ID,
				S.PRODUCT_ID
			FROM 
				#dsn1_alias#.STOCKS S
			WHERE 
				S.PRODUCT_ID = #arguments.product_id#
		</cfquery>
		<cfreturn get_stok>	
	</cffunction>

	<cffunction name="get_consumer_func" access="remote" returntype="query">
		<cfargument name="consumer_id" default="">
		<cfquery name="get_consumer" datasource="#DSN#">
			SELECT 
				C.*,
				HC.COUNTY_NAME AS HOME_COUNTY_NAME,
				HCITY.CITY_NAME AS HOME_CITY_NAME,
				WC.COUNTY_NAME AS WORK_COUNTY_NAME,
				WCITY.CITY_NAME AS WORK_CITY_NAME
			FROM 
				CONSUMER C
					LEFT JOIN SETUP_COUNTY AS HC ON (HC.COUNTY_ID = C.HOME_COUNTY_ID)
					LEFT JOIN SETUP_CITY AS HCITY ON (HCITY.CITY_ID = C.HOME_CITY_ID)
					LEFT JOIN SETUP_COUNTY AS WC ON (WC.COUNTY_ID = C.WORK_COUNTY_ID)
					LEFT JOIN SETUP_CITY AS WCITY ON (WCITY.CITY_ID = C.WORK_CITY_ID)
			WHERE 
				C.CONSUMER_ID = #arguments.consumer_id#
		</cfquery>
		<cfreturn get_consumer>	
	</cffunction>
	
	<cffunction name="get_consumer_branch_func" access="remote" returntype="query">
		<cfargument name="consumer_id" default="">
		<cfargument name="adres_id" default="">
		<cfquery name="get_consumer_branch" datasource="#DSN#">
			SELECT 
				CB.*,HC.COUNTY_NAME,HCITY.CITY_NAME,HC.COUNTY_ID,HCITY.CITY_ID
			FROM 
				CONSUMER_BRANCH CB
					LEFT JOIN SETUP_COUNTY AS HC ON (HC.COUNTY_ID = CB.CONTACT_CITY_ID)
					LEFT JOIN SETUP_CITY AS HCITY ON (HCITY.CITY_ID = CB.CONTACT_COUNTY_ID)
			WHERE 
				CB.CONSUMER_ID = #arguments.consumer_id#
				<cfif len(arguments.adres_id)>
					CB.CONTACT_ID = #arguments.adres_id#
				</cfif>
		</cfquery>
		<cfreturn get_consumer_branch>	
	</cffunction>

	<cffunction name="get_company_func" access="remote" returntype="query">
		<cfargument name="company_id" default="">
		<cfquery name="get_company" datasource="#DSN#">
			SELECT 
				C.*,
				C.COMPANY_ADDRESS AS WORKADDRESS,
				C.COMPANY_POSTCODE AS WORKPOSTCODE,
				C.CITY AS WORK_CITY_ID ,
				C.COUNTY AS WORK_COUNTY_ID ,
				'' AS HOMEADDRESS,
				'' AS HOME_COUNTY_NAME,
				'' AS HOME_CITY_NAME,
				WC.COUNTY_NAME AS WORK_COUNTY_NAME,
				WCITY.CITY_NAME AS WORK_CITY_NAME,
				C.TAXNO AS TAX_NO,
				C.TAXOFFICE AS TAX_OFFICE,
				C.COMPANY_EMAIL AS CONSUMER_EMAIL
			FROM 
				COMPANY C
					LEFT JOIN SETUP_COUNTY AS WC ON (WC.COUNTY_ID = C.COUNTY)
					LEFT JOIN SETUP_CITY AS WCITY ON (WCITY.CITY_ID = C.CITY)
			WHERE 
				C.COMPANY_ID = #arguments.company_id#
		</cfquery>
		<cfreturn get_company>	
	</cffunction>
	
	<cffunction name="get_company_branch_func" access="remote" returntype="query">
		<cfargument name="company_id" default="">
		<cfargument name="adres_id" default="">
		<cfquery name="get_company_branch" datasource="#DSN#">
			SELECT 
				CB.*,HC.COUNTY_NAME,HCITY.CITY_NAME,HC.COUNTY_ID,HCITY.CITY_ID,
				CB.COMPBRANCH__NAME AS CONTACT_NAME,
				CB.COMPBRANCH_ID AS CONTACT_ID,
				CB.COMPBRANCH_ADDRESS AS CONTACT_ADDRESS,
				CB.COMPBRANCH_POSTCODE AS CONTACT_POSTCODE 
			FROM 
				COMPANY_BRANCH CB
					LEFT JOIN SETUP_COUNTY AS HC ON (HC.COUNTY_ID = CB.COUNTY_ID)
					LEFT JOIN SETUP_CITY AS HCITY ON (HCITY.CITY_ID = CB.CITY_ID)
			WHERE 
				CB.COMPANY_ID = #arguments.company_id#
				<cfif len(arguments.adres_id)>
					AND CB.COMPBRANCH_ID = #arguments.adres_id#
				</cfif>
		</cfquery>
		<cfreturn get_company_branch>	
	</cffunction>
</cfcomponent>