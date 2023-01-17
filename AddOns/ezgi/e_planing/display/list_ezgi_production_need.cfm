<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_txt" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_code" default="">
<cfparam name="attributes.product_cat_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.report_type" default="4">
<cfparam name="attributes.unit_type" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.uretim_ay" default="0">
<cfparam name="attributes.yontem" default="1">
<cfset satirlar_stock_is_list = ''>
<cfset stock_id_list = ''>
<cfset t_real_stock = 0>
<cfset s_t_real_stock = 0>
<cfset son_row = 0>
<cfset this_year_max_month = Month(now())>
<cfset this_year_min_month = 1>
<cfset last_year_max_month = 12>
<cfset last_year_min_month = this_year_max_month>
<cfset this_year = Year(now())>
<cfset last_year = this_year -1>
<cfquery name="get_last_period" datasource="#dsn#">
	SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR = #last_year#
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfquery name="get_unit" datasource="#dsn#">
	SELECT UNIT_ID, UNIT FROM SETUP_UNIT
</cfquery>
<cfoutput query="get_unit">
	<cfset 'UNIT_#UNIT_ID#' = UNIT>
</cfoutput>
<cfset satirlar.recordcount=0>
<cfif isdefined("attributes.is_submitted")>
	<cfif Len(attributes.product_code) and Len(attributes.product_cat)>
        <cfquery name="GET_CATEGORIES" datasource="#DSN1#">
            SELECT PRODUCT_ID FROM PRODUCT WHERE PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_code#.%">
        </cfquery>
    </cfif>
    <cfif attributes.branch_id neq ''>
    	<cfset attributes.list_with_store = 1>
        <cfquery name="get_departments" datasource="#DSN#">
        	SELECT        
            	CAST(DEPARTMENT_ID AS NVARCHAR)+'-'+CAST(LOCATION_ID AS NVARCHAR) AS DEPARTMENT_ID 
			FROM            
           		STOCKS_LOCATION
			WHERE        
            	DEPARTMENT_ID IN
                             	(
                                	SELECT        
                                    	DEPARTMENT_ID
                               		FROM            
                                    	DEPARTMENT
                               		WHERE        
                                    	BRANCH_ID = #attributes.branch_id# AND 
                                        DEPARTMENT_STATUS = 1 AND 
                                        IS_STORE IN (2, 3)
                               	)
			ORDER BY 
            	DEPARTMENT_ID, 
                LOCATION_ID
        </cfquery>
        <cfset attributes.department_id = ValueList(get_departments.DEPARTMENT_ID)>
    </cfif>
    <cfinclude template="../query/get_ezgi_stock_last_location_karma_koli.cfm">
    <cfif len(attributes.unit_type)>
      	<cfquery name="GET_EZGI_STOCK_LAST_LOCATION_KARMA_KOLI" dbtype="query">
          	SELECT * FROM GET_EZGI_STOCK_LAST_LOCATION_KARMA_KOLI WHERE UNIT_ID = #attributes.unit_type#
     	</cfquery>
  	</cfif>
    <cfif GET_EZGI_STOCK_LAST_LOCATION_KARMA_KOLI.recordcount>
    	<cfset stock_id_list = Valuelist(GET_EZGI_STOCK_LAST_LOCATION_KARMA_KOLI.STOCK_ID)>
        <cfset product_id_list = Valuelist(GET_EZGI_STOCK_LAST_LOCATION_KARMA_KOLI.PRODUCT_ID)>
        <cfquery name="get_production_amount" datasource="#dsn3#">
        	SELECT        
            	SUM(PO.QUANTITY - ISNULL(TBL.AMOUNT, 0)) AS URETIM_PLANI, 
                S.STOCK_ID
			FROM            
          		PRODUCTION_ORDERS AS PO INNER JOIN
            	#dsn1_alias#.KARMA_PRODUCTS AS KP ON PO.STOCK_ID = KP.STOCK_ID INNER JOIN
            	STOCKS AS S ON KP.KARMA_PRODUCT_ID = S.PRODUCT_ID LEFT OUTER JOIN
             	(
                	SELECT        
                    	POR.P_ORDER_ID, 
                        SUM(PORR.AMOUNT) AS AMOUNT
          			FROM        
                    	PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
                    	PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
                	WHERE        
                    	PORR.TYPE = 1 AND 
                        POR.IS_STOCK_FIS = 1
                	GROUP BY 
                    	POR.P_ORDER_ID
            	) AS TBL ON PO.P_ORDER_ID = TBL.P_ORDER_ID
			WHERE        
            	PO.IS_DEMONTAJ = 0 AND 
                PO.STATUS = 1 AND 
                PO.IS_STOCK_RESERVED = 1 AND
                S.STOCK_ID IN (#stock_id_list#)
			GROUP BY 
            	S.STOCK_ID
        </cfquery>
        <cfoutput query="get_production_amount">
        	<cfset 'URETIM_PLANI_#STOCK_ID#' = URETIM_PLANI>
        </cfoutput>
        <cfquery name="get_karma" datasource="#dsn1#">
        	SELECT PRODUCT_ID, ISNULL(IS_KARMA, 0) AS IS_KARMA FROM PRODUCT WHERE PRODUCT_ID IN (#product_id_list#)
        </cfquery>
        <cfoutput query="get_karma">
        	<cfset 'IS_KARMA_#PRODUCT_ID#' = IS_KARMA> 
        </cfoutput>
        <cfif attributes.report_type neq 3>
            <cfquery name="get_all_sales" datasource="#dsn2#">
                SELECT
                    YIL,
                    AY,
                    STOCK_ID,
                    SUM(SATIS) AS SATIS
                FROM
                    (
                    SELECT     
                    	CASE WHEN I.PURCHASE_SALES = 0 THEN IR.AMOUNT * - 1 ELSE IR.AMOUNT END AS SATIS, 
                        MONTH(I.INVOICE_DATE) AS AY, 
                        YEAR(I.INVOICE_DATE) AS YIL, 
                      	IR.STOCK_ID
					FROM         
                    	INVOICE AS I INNER JOIN
                      	INVOICE_ROW AS IR ON I.INVOICE_ID = IR.INVOICE_ID
                    WHERE
                        I.IS_IPTAL = 0 AND 
                        ISNULL(IR.IS_PROMOTION, 0) <> 1 AND 
                        <cfif isdefined('attributes.ihr_sat') and len(attributes.ihr_sat)>
                        	I.INVOICE_CAT IN (52,53,54,55,531) AND
                        <cfelse>
                        	I.INVOICE_CAT IN (52,53,54,55) AND
                        </cfif>
                        IR.STOCK_ID IN (#stock_id_list#) AND
                        MONTH(I.INVOICE_DATE) >= #this_year_min_month# AND 
                        MONTH(I.INVOICE_DATE) <= #this_year_max_month# AND
                        MONTH(I.INVOICE_DATE) <> #month(now())#
                    <cfif get_last_period.recordcount>
                    	UNION ALL
                        SELECT     
                            CASE WHEN I.PURCHASE_SALES = 0 THEN IR.AMOUNT * - 1 ELSE IR.AMOUNT END AS SATIS, 
                            MONTH(I.INVOICE_DATE) AS AY, 
                            YEAR(I.INVOICE_DATE) AS YIL, 
                            IR.STOCK_ID
                        FROM         
                            #dsn#_#last_year#_#session.ep.company_id#.INVOICE AS I INNER JOIN
                            #dsn#_#last_year#_#session.ep.company_id#.INVOICE_ROW AS IR ON I.INVOICE_ID = IR.INVOICE_ID
                        WHERE
                            I.IS_IPTAL = 0 AND 
                            ISNULL(IR.IS_PROMOTION, 0) <> 1 AND 
                            <cfif isdefined('attributes.ihr_sat') and len(attributes.ihr_sat)>
                                I.INVOICE_CAT IN (52,53,54,55,531) AND
                            <cfelse>
                                I.INVOICE_CAT IN (52,53,54,55) AND
                            </cfif>
                            IR.STOCK_ID IN (#stock_id_list#) AND
                            MONTH(I.INVOICE_DATE) >= #last_year_min_month#  AND 
                            MONTH(I.INVOICE_DATE) <= #LAST_year_max_month# 
                    </cfif>
                    ) AS TBL
                GROUP BY
                    YIL,
                    AY,
                    STOCK_ID
                ORDER BY
                    STOCK_ID,
                    YIL,
                    AY
            </cfquery>
            <cfloop list="#stock_id_list#" index="i">
                <cfquery name="get_info" dbtype="query">
                    SELECT * FROM get_all_sales WHERE STOCK_ID = #i# AND SATIS >0
                </cfquery>
                <cfquery name="get_info_total" dbtype="query">
                    SELECT sum(SATIS) AS SATIS FROM get_info
                </cfquery>
                <cfif get_info.recordcount>
                	<cfif attributes.yontem eq 1> 
                    	<cfset 'ortalama_#i#' = get_info_total.SATIS/get_info.recordcount>
                  	<cfelseif attributes.yontem eq 2>
                    	<cfset 'ortalama_#i#' = get_info_total.SATIS/12>
                    </cfif>
                    <cfif isdefined('attributes.calc_method') and len(attributes.calc_method)>
						<cfset 'sapma_#i#' = 0>
                        <cfloop query="get_info">
                            <cfset 'sapma_#i#' = Evaluate('sapma_#i#') + (get_info.satis-Evaluate('ortalama_#i#'))^2>
                        </cfloop>
                        <cfif Evaluate('sapma_#i#') gt 0>
                            <cfset 'sapma_#i#' = SQR(Evaluate('sapma_#i#')/(get_info.recordcount-1))>
                            <cfset 'sapma_#i#' = Evaluate('sapma_#i#') + Evaluate('ortalama_#i#')>
                        <cfelse>
                        	<cfset 'sapma_#i#' = Evaluate('ortalama_#i#')>
                        </cfif>
                    <cfelse>
                    	<cfloop query="get_info">
                            <cfset 'sapma_#i#' = Evaluate('ortalama_#i#')>
                        </cfloop>
                    </cfif>
                </cfif>
            </cfloop>
       	</cfif>
    </cfif>
<cfelse>
	<cfset GET_EZGI_STOCK_LAST_LOCATION_KARMA_KOLI.recordcount=0>
</cfif>
<cfif GET_EZGI_STOCK_LAST_LOCATION_KARMA_KOLI.recordcount>
  	<cfset satirlar = queryNew("stock_id, product_id,product_code,product_name,manufact_code,unit,RESERVED_PROD_STOCK,real_stock,RESERVE_PURCHASE_ORDER_STOCK, RESERVE_SALE_ORDER_STOCK,PRODUCTION_ORDER_STOCK,IS_KARMA,URETIM_PLANI,TALEP,SALEABLE_STOCK,RESERVED_STOCK,sapma,SHIP_INTERNAL_STOCK","integer,integer,VarChar,VarChar,VarChar,VarChar,Decimal,Decimal,Decimal,Decimal,Decimal,Bit,Decimal,Decimal,Decimal,Decimal,Decimal,Decimal") />
  	<cfoutput query="GET_EZGI_STOCK_LAST_LOCATION_KARMA_KOLI">
		<cfset Temp = QueryAddRow(satirlar)>
   		<cfset Temp = QuerySetCell(satirlar, "stock_id", stock_id)> 
		<cfset Temp = QuerySetCell(satirlar, "product_id", product_id)>
    	<cfset Temp = QuerySetCell(satirlar, "product_code", product_code)>
     	<cfset Temp = QuerySetCell(satirlar, "product_name", product_name)>
   		<cfset Temp = QuerySetCell(satirlar, "manufact_code", manufact_code)>
     	<cfset Temp = QuerySetCell(satirlar, "unit", Evaluate('UNIT_#UNIT_ID#'))> 
    	<cfset Temp = QuerySetCell(satirlar, "RESERVED_PROD_STOCK", RESERVED_PROD_STOCK)>
      	<cfset Temp = QuerySetCell(satirlar, "real_stock", real_stock)> 
      	<cfset Temp = QuerySetCell(satirlar, "RESERVE_PURCHASE_ORDER_STOCK", RESERVE_PURCHASE_ORDER_STOCK)> 
     	<cfset Temp = QuerySetCell(satirlar, "RESERVE_SALE_ORDER_STOCK", RESERVE_SALE_ORDER_STOCK)>
     	<cfset Temp = QuerySetCell(satirlar, "PRODUCTION_ORDER_STOCK", PRODUCTION_ORDER_STOCK)>
      	<cfset Temp = QuerySetCell(satirlar, "RESERVED_STOCK", RESERVED_STOCK)>
        <cfset Temp = QuerySetCell(satirlar, "SHIP_INTERNAL_STOCK", SHIP_INTERNAL_STOCK)>
     	<cfset Temp = QuerySetCell(satirlar, "IS_KARMA", Evaluate('IS_KARMA_#PRODUCT_ID#'))>
      	<cfif isdefined('URETIM_PLANI_#STOCK_ID#')>
         	<cfset Temp = QuerySetCell(satirlar, "URETIM_PLANI", Evaluate('URETIM_PLANI_#STOCK_ID#'))> 
      	<cfelse>
       		<cfset Temp = QuerySetCell(satirlar, "URETIM_PLANI", 0)> 
      	</cfif>
       	<cfset Temp = QuerySetCell(satirlar, "TALEP", TALEP)> 
        <cfif isdefined('attributes.is_production') and len(attributes.is_production)>
      		<cfset Temp = QuerySetCell(satirlar, "SALEABLE_STOCK", SALEABLE_STOCK-PRODUCTION_ORDER_STOCK)> 
        <cfelse>
        	<cfset Temp = QuerySetCell(satirlar, "SALEABLE_STOCK", SALEABLE_STOCK)> 
        </cfif>
     	<cfif isdefined('sapma_#STOCK_ID#')>
        	<cfif not len(attributes.uretim_ay) or not isnumeric(attributes.uretim_ay)>
            	<cfset attributes.uretim_ay =0>
            </cfif>
          	<cfset Temp = QuerySetCell(satirlar, "sapma", round(Evaluate('sapma_#STOCK_ID#'))*attributes.uretim_ay)> 
      	<cfelse>
         	<cfset Temp = QuerySetCell(satirlar, "sapma", 0)>
     	</cfif>
 	</cfoutput>
 	<cfif satirlar.recordcount>
     	<cfquery name="satirlar" dbtype="query">
          	SELECT
          		*
          	FROM
            	satirlar
           	WHERE
             	1=1
         		<cfif attributes.report_type eq 1>
                    <cfif isdefined('attributes.is_production') and len(attributes.is_production)>
                        AND REAL_STOCK+RESERVED_STOCK+TALEP-SAPMA+PRODUCTION_ORDER_STOCK < 0
                 	<cfelse>
                    	AND REAL_STOCK+RESERVED_STOCK+TALEP-SAPMA < 0
                    </cfif>
               	</cfif>
             	<cfif attributes.report_type eq 2>
					<cfif isdefined('attributes.is_production') and len(attributes.is_production)>
                    	AND REAL_STOCK+RESERVED_STOCK+TALEP-SAPMA+PRODUCTION_ORDER_STOCK > 0
                 	<cfelse>
                    	AND REAL_STOCK+RESERVED_STOCK+TALEP-SAPMA > 0
                    </cfif>
             	</cfif> 
                
          	ORDER BY
            	MANUFACT_CODE,
             	PRODUCT_NAME
      	</cfquery>
        <cfif satirlar.recordcount>
        	<cfquery name="satirlar_karma" dbtype="query">
        		SELECT STOCK_ID,PRODUCT_ID FROM satirlar WHERE IS_KARMA = 1
            </cfquery>
            <cfset karma_stock_id_list = ValueList(satirlar_karma.STOCK_ID)>
            <cfset karma_product_id_list = ValueList(satirlar_karma.PRODUCT_ID)>
            <cfif listlen(karma_product_id_list)>
            	<cfquery name="get_karma_paket" datasource="#DSN1#">
                    SELECT  
                    	KARMA_PRODUCT_ID,      
                        (SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = k.PRODUCT_ID) AS PRODUCT_NAME,
                        (SELECT BARCOD FROM PRODUCT WHERE PRODUCT_ID = k.PRODUCT_ID) AS BARCOD,
                        PRODUCT_AMOUNT, 
                        PRODUCT_ID,
                        STOCK_ID,
                        (SELECT TOP (1) PACKAGE_IS_MASTER FROM #dsn3_alias#.EZGI_DESIGN_PACKAGE_ROW WHERE PACKAGE_RELATED_ID = K.STOCK_ID) AS PACKAGE_IS_MASTER,
                        (SELECT PRODUCT_CODE FROM PRODUCT WHERE PRODUCT_ID = k.PRODUCT_ID) AS PRODUCT_CODE,
                        (SELECT MANUFACT_CODE FROM PRODUCT WHERE PRODUCT_ID = k.PRODUCT_ID) AS MANUFACT_CODE,
                        (SELECT MAIN_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_ID = k.PRODUCT_ID AND PRODUCT_UNIT_STATUS = 1 AND IS_MAIN = 1) AS MAIN_UNIT,
                        ISNULL((SELECT SUM(STOCK_IN - STOCK_OUT) AS REAL_STOCK FROM #dsn2_alias#.STOCKS_ROW GROUP BY PRODUCT_ID HAVING PRODUCT_ID = K.PRODUCT_ID),0) AS REAL_STOCK,
                        ISNULL((SELECT SUM(PURCHASE_PROD_STOCK) AS PURCHASE_PROD_STOCK FROM #dsn2_alias#.GET_STOCK_LAST_PROFILE WHERE STOCK_ID = K.STOCK_ID),0) AS URETIM,
                        ISNULL((SELECT SUM(RESERVE_SALE_ORDER_STOCK) AS RESERVE_SALE_ORDER_STOCK FROM #dsn3_alias#.EZGI_SALE_ORDER_RESERVED_LOCATION_DEMONTE WHERE STOCK_ID = K.STOCK_ID GROUP BY STOCK_ID),0) AS SIPARIS
                    FROM            
                        KARMA_PRODUCTS AS K
                    WHERE        
                        KARMA_PRODUCT_ID IN (#karma_product_id_list#)
                    ORDER BY 
                        ENTRY_ID
                </cfquery>
            </cfif>
        </cfif>
  	</cfif>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default="#satirlar.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_big_list_search title="#getLang('main',3075)#">
<cfform name="list_order" method="post" action="#request.self#?fuseaction=prod.popup_list_ezgi_production_need">
	<cf_big_list_search_area>
		<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cfif isdefined('attributes.upd_id')>
            	<cfinput type="hidden" name="upd_id" value="#attributes.upd_id#">
            </cfif>
            <br />
			<table>
				<tr>
                	<td>&nbsp;</td>
					<td width="30" align="right"><cf_get_lang_main no='48.Filtre'></td>
					<td width="85"><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:80px;"></td>
                    <td width="160">
                    	<select name="report_type" id="report_type" style=" width:150px; height:20px" onChange="report_type_chng();">
                        	<option value=""><cf_get_lang_main no='296.Tümü'></option>
                            <option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang_main no='3080.İhtiyacı Karşılamayanlar'></option>
                            <option value="2" <cfif attributes.report_type eq 2>selected</cfif>><cf_get_lang_main no='3081.İhtiyaç Fazlası Olanlar'></option>
                            <option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang_main no='3082.Net Bakiye'></option>
                            <option value="4" <cfif attributes.report_type eq 4>selected</cfif>><cf_get_lang_main no='3083.Üretim Talebi Hesaplama'></option>
                        </select>
                    </td>
                    <td width="60px">
                    	<select name="unit_type" id="unit_type" style="50px; height:20px">
                        	<option value=""><cf_get_lang_main no='224.Birim'></option>
                            <cfoutput query="get_unit">
                            	<option value="#UNIT_ID#" <cfif attributes.unit_type eq UNIT_ID>selected</cfif>>#UNIT#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td width="60px">
                    	<select name="branch_id" id="branch_id" style="70px; height:20px">
                        	<option value=""><cf_get_lang_main no='1698.Tüm Şubeler'></option>
                            <cfoutput query="get_branch">
                            	<option value="#BRANCH_ID#" <cfif attributes.branch_id eq BRANCH_ID>selected</cfif>>#BRANCH_NAME#</option>
                            </cfoutput>
                        </select>
                    </td>
                    <td width="130px">
                    	<select name="yontem" id="yontem" style="width:120px; height:20px">
                        	<option value="1" <cfif attributes.yontem eq 1>selected</cfif>><cfoutput>#getLang('main',1639)#</cfoutput></option>
                            <option value="2" <cfif attributes.yontem eq 2>selected</cfif>><cfoutput>#getLang('objects',224)#</cfoutput></option>
                        </select>
                    </td>
                    <td id="ihr_sat_td" align="right" nowrap="nowrap">
                    	<cf_get_lang_main no='3084.İhracaat Satışlarını Dahil Et'> 
                        <input id="ihr_sat" name="ihr_sat" value="1" type="checkbox" <cfif isdefined('attributes.ihr_sat') and len(attributes.ihr_sat)>checked</cfif>>
                  	</td>
                    
                    <td id="sapma_td" align="right" nowrap="nowrap">
                    	<cfoutput>#getLang('report',1333)#</cfoutput>
                        <input id="calc_method" name="calc_method" value="1" type="checkbox" <cfif isdefined('attributes.calc_method') and len(attributes.calc_method)>checked</cfif>>
                  	</td>
                    <td id="uretim_td" align="right" nowrap="nowrap">
                    	<cfoutput>#getLang('main',44)#</cfoutput> <cfoutput>#getLang('assetcare',342)#</cfoutput>
                        <input id="is_production" name="is_production" value="1" type="checkbox" <cfif isdefined('attributes.is_production') and len(attributes.is_production)>checked</cfif>>
                    </td>
                    <td id="uretim_ay_td" align="right" nowrap="nowrap">
                    	<cf_get_lang_main no='3085.Stoklama Zamanı'> (<cf_get_lang_main no='1312.Ay'>) :
                        <cfinput type="text" name="uretim_ay" id="uretim_ay" value="#attributes.uretim_ay#" style="width:20px; text-align:center">
                    </td>
                    
                    <cfoutput>
                        <td style="width:50px;" align="right"><cf_get_lang_main no='74.Kategori'></td>
                        <td width="180"><input type="hidden" name="product_code" id="product_code" value="<cfif len(attributes.product_cat) and len(attributes.product_code)>#attributes.product_code#</cfif>">
                            <input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif len(attributes.product_cat) and len(attributes.product_cat_id)>#attributes.product_cat_id#</cfif>">
                            <input type="text" name="product_cat" id="product_cat" style="width:160px;" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','0','PRODUCT_CATID,HIERARCHY','product_cat_id,product_code','','3','175','','1');" value="<cfif len(attributes.product_cat) and len(attributes.product_code)>#attributes.product_cat#</cfif>" autocomplete="off">
                            <a href="javascript://"onClick="windowopen('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=list_order.product_cat_id&field_code=list_order.product_code&field_name=list_order.product_cat&keyword='+encodeURIComponent(document.list_order.product_cat.value),'list');"><img src="/images/plus_thin.gif" style=" vertical-align:top" title="Ürün Kategorisi Ekle!"></a>
                        </td>
                   	</cfoutput>
					<td width="25"><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfset maxrows_ = 999>
						<cfinput type="text" name="maxrows" maxlength="3" onKeyUp="isNumber(this)" id="maxrows" value="#attributes.maxrows#" validate="integer" range="1,#maxrows_#" required="yes" message="#message#" style="width:25px;">
					</td>
                    <td style="width:50px; vertical-align: middle">
                    	<cf_wrk_search_button search_function='input_control()'><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
					</td>
                </tr>
			</table>
    </cf_big_list_search_area>
</cfform>
</cf_big_list_search> 
    <cf_big_list>
        <table class="detail_basket_list">
            <thead>
                <tr>
                    <th width="30"><cfoutput>#getLang('main',1165)#</cfoutput></th>
                    <th width="100"><cfoutput>#getLang('main',106)#</cfoutput></th>
                    <th width="70"><cfoutput>#getLang('main',222)#</cfoutput></th>
                    <th <cfif attributes.branch_id eq ''>onclick="seviyelendir();"</cfif>><cfoutput>#getLang('main',245)#</cfoutput></th>
                    <th width="40"><cfoutput>#getLang('main',224)#</cfoutput></th>
                    <th width="50"><cfoutput>#getLang('main',708)#</cfoutput></th>
                    <cfif attributes.report_type neq 3>
                        <th width="50"><cfoutput>#getLang('stock',624)#</cfoutput></th>
                        <th width="50"><cfoutput>#getLang('main',3086)#</cfoutput></th>
                     	<th width="50"><cfoutput>#getLang('prod',75)#</cfoutput></th>
                   	</cfif>	
                  	<th width="50"><cfoutput>#getLang('main',3087)#</cfoutput></th>
                    <th width="50"><cfoutput>#getLang('report',1503)#</cfoutput></th>
                    <cfif attributes.branch_id neq ''>
                    	<th width="50"><cfoutput>#getLang('stock',348)#</cfoutput></th>
                    </cfif>
                    <th width="50"><cfoutput>#getLang('main',3088)#</cfoutput></th>
                    <th width="50"><cfoutput>#getLang('main',3089)#</cfoutput></th>
                    <cfif attributes.report_type eq 3>
                    	<th width="50"><cfoutput>#getLang('main',3082)#</cfoutput></th>
                   	<cfelse>
                    	<th width="50"><cfoutput>#getLang('stock',64)#</cfoutput></th>
                    </cfif>
              		<th width="50"><cfoutput>#getLang('main',1060)# #getLang('prod',124)#</cfoutput></th>
                    <cfif attributes.report_type neq 3>
                        <th width="50"><cfoutput>#getLang('prod',124)#</cfoutput></th>
                        <th style="text-align:center; width:15px">
                            <input type="checkbox" style="text-align:center;" alt="<cf_get_lang_main no='3009.Hepsini Seç'>" onClick="grupla(-1);">
                        </th>
                    </cfif>
                </tr>
            </thead>
            <tbody>
                <cfif satirlar.recordcount>
                	<cfoutput query="satirlar">
						<cfset s_t_real_stock = s_t_real_stock + REAL_STOCK>
                    </cfoutput>
                    
                    <cfoutput query="satirlar"  startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    	<cfset satirlar_stock_is_list = ListAppend(satirlar_stock_is_list,stock_id)>
                        <tr id="satir_gizle_#satirlar.currentrow#">
                            <td style="text-align:right;cursor:pointer" onclick="satir_gizle(#satirlar.currentrow#,#STOCK_ID#);">
                            	<button name="buton_" style="width:30px; height:20px">#currentrow#</button>
                            </td>
                            <td>
                               <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&sid=#stock_id#','list');" class="tableyazi">
                               #PRODUCT_CODE#
                               </a>
                            </td>
                            <td>#MANUFACT_CODE#</td>
                            <td>
                            	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.list_product&event=det&pid=#product_id#','longpage');" class="tableyazi">
                            	#PRODUCT_NAME#
                                </a>
                            </td>
                            <td>#UNIT#</td>
                            <td style="text-align:right;">
                            	<cfif IS_KARMA eq 1>
                            		<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_karma_koli&pid=#product_id#','page');">
                                <cfelse>
                                	<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=stock.detail_store_stock_popup&stock_id=#stock_id#&product_id=#product_id#','page');">
                                </cfif>
                                	#Amountformat(REAL_STOCK,0)#
                              	</a>
                          	</td>
                            <cfif attributes.report_type neq 3>
                            <td style="text-align:right;">
                            	<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#product_id#','medium');">
                                	#Amountformat(RESERVE_PURCHASE_ORDER_STOCK,0)#
                                	
                              	</a>
                            </td>
                            <td style="text-align:right;">
                            	<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_reserved_production_orders&type=1&pid=#product_id#','medium');">
                                	<cfif PRODUCTION_ORDER_STOCK gt 0>
                                    	<cfif URETIM_PLANI neq PRODUCTION_ORDER_STOCK>
                                        	<span style="color:red; font-weight:bold">#AmountFormat(PRODUCTION_ORDER_STOCK,0)#</span>
                                      	<cfelse>
                                        	#AmountFormat(PRODUCTION_ORDER_STOCK,0)#
                                        </cfif>
                                   	<cfelse>
										<cfif URETIM_PLANI gt 0>
                                            <span style="color:red; font-weight:bold">0</span>
                                        <cfelse>
                                        	0
                                        </cfif>
                                 	</cfif>
                                </a>
                            </td>
                         	<td style="text-align:right;">
                              	<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=prod.popup_dsp_ezgi_production_demand&sid=#STOCK_id#','medium');">#AmountFormat(TALEP,0)#</a>
                          	</td>
                            <td style="text-align:right;">
                            	<strong>
                                	<cfif isdefined('attributes.is_production') and len(attributes.is_production)>
                                    	#Amountformat(REAL_STOCK+RESERVE_PURCHASE_ORDER_STOCK+PRODUCTION_ORDER_STOCK+TALEP-PRODUCTION_ORDER_STOCK,0)#
                                    <cfelse>
                            			#Amountformat(REAL_STOCK+RESERVE_PURCHASE_ORDER_STOCK+PRODUCTION_ORDER_STOCK+TALEP,0)#
                                    </cfif>
                              	</strong>
                           	</td>	
                            <cfelse>
                            	<td style="text-align:right;"><strong>#Amountformat(REAL_STOCK,0)#</strong></td>
                            </cfif>
                            <td style="text-align:right;">
                            	<cfif IS_KARMA eq 1>
                            		<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=prod.popup_dsp_ezgi_planning_reserved_orders&taken=1&pid=#product_id#&sale_order=#RESERVE_SALE_ORDER_STOCK#&is_karma=1','medium');">#Amountformat(RESERVE_SALE_ORDER_STOCK,0)#</a>
                                <cfelse>
                                	<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=prod.popup_dsp_ezgi_planning_reserved_orders&taken=1&pid=#product_id#','medium');">#Amountformat(RESERVE_SALE_ORDER_STOCK,0)#</a>
                                </cfif>
                            </td>
                            <cfif attributes.branch_id neq ''>
                            	<td style="text-align:right;">#AmountFormat(SHIP_INTERNAL_STOCK,0)#</td>
                            </cfif>
                            <td style="text-align:right;">
                            	<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_reserved_production_orders&type=2&pid=#product_id#','medium');">#AmountFormat(RESERVED_PROD_STOCK,0)#</a>
                            </td>
                            <td style="text-align:right;"><strong>#Amountformat(RESERVED_PROD_STOCK+RESERVE_SALE_ORDER_STOCK+SHIP_INTERNAL_STOCK,0)#</strong></td>
                            <cfif attributes.report_type eq 3>
                            	<td style="text-align:right;"><strong>#Amountformat(REAL_STOCK - RESERVE_SALE_ORDER_STOCK - RESERVED_PROD_STOCK,0)#</strong></td>
                            <cfelse>
                            	<td style="text-align:right;"><strong>#Amountformat(SALEABLE_STOCK,0)#</strong></td>
                                <td style="text-align:right;">
                                  	<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=prod.popup_dsp_ezgi_production_need&sid=#STOCK_id#<cfif isdefined('attributes.ihr_sat')>&ihr_sat=#attributes.ihr_sat#</cfif>&uretim_ay=#attributes.uretim_ay#','small');">
                                		#TlFormat(sapma,0)#
                                	</a>  
                                </td>
                            </cfif>
                            <cfset need_stock = 0>
                            <cfif attributes.report_type neq 3>
                                <td style="text-align:right;">
                                    <cfif SALEABLE_STOCK - round(sapma) lt 0>
                                     	<cfset need_stock = SALEABLE_STOCK - round(sapma)>
                                      	<cfif need_stock lt 0>
                                        	<cfset need_stock = need_stock * -1>
                                     	</cfif>
                                    <cfelse>
                                  		<cfset need_stock = SALEABLE_STOCK - round(sapma)>
                                     	<cfif need_stock lt 0>
                                        	<cfset need_stock = need_stock * -1>
                                      	<cfelse>
                                         	<cfset need_stock = 0>
                                   		</cfif>
                                    </cfif>
                                    <span style="color:white; font-size:7px">#need_stock#</span>
                                    <input type="text" name="need_stock_#STOCK_ID#"  id="need_stock_#STOCK_ID#" value="#need_stock#" style="text-align:right; width:50px" class="box" >
                                </td>
                                <td style="text-align:center;">
                                    <input type="checkbox" name="select_production_#STOCK_ID#" id="select_production_#STOCK_ID#" value="1">
                                </td>
                            </cfif>
                            <cfset son_row = currentrow>
                        </tr>
                        <cfif isdefined('get_karma_paket') and get_karma_paket.recordcount and satirlar.IS_KARMA eq 1 and attributes.report_type neq 3>
                        	<cfquery name="get_sub_satirlar" dbtype="query">
                            	SELECT * FROM get_karma_paket WHERE KARMA_PRODUCT_ID = #satirlar.PRODUCT_ID# ORDER BY PRODUCT_NAME
                            </cfquery>
                            <cfif get_sub_satirlar.recordcount>
                            	<cfloop query="get_sub_satirlar">
                                	<cfif isdefined('sub_satirlar_stock_id_list_#satirlar.STOCK_ID#')>
                                		<cfset 'sub_satirlar_stock_id_list_#satirlar.STOCK_ID#' = ListAppend(Evaluate('sub_satirlar_stock_id_list_#satirlar.STOCK_ID#'),get_sub_satirlar.stock_id)>
                                    <cfelse>
                                    	<cfset 'sub_satirlar_stock_id_list_#satirlar.STOCK_ID#' = get_sub_satirlar.stock_id>
                                    </cfif>
                            		<tr id="demonte_1_#satirlar.currentrow#_#get_sub_satirlar.currentrow#" style="display:none" >
                                    	<td style="background-color:Gainsboro"></td>
                                        <td style="background-color:Gainsboro">#get_sub_satirlar.PRODUCT_CODE#</td>
                                        <td style="background-color:Gainsboro">#BARCOD#</td>
                                        <td style="background-color:Gainsboro<cfif get_sub_satirlar.PACKAGE_IS_MASTER eq 1>;color:red; font-weight:bold</cfif>">#get_sub_satirlar.PRODUCT_NAME#</td>
                                        <td style="background-color:Gainsboro">#get_sub_satirlar.MAIN_UNIT#</td>
                                        <td style="text-align:right;background-color:Gainsboro">#AmountFormat(get_sub_satirlar.REAL_STOCK,0)#</td>
                                        <td style="text-align:right;background-color:Gainsboro"></td>
                                        
                                        <td style="text-align:right;background-color:Gainsboro">
                                        	<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=prod.popup_dsp_ezgi_reserved_production_orders&type=1&pid=#get_sub_satirlar.product_id#','medium');">
                                            	#AmountFormat(get_sub_satirlar.URETIM,0)#
                                        	</a>
                                        
                                        </td>
                                        <td style="text-align:right;background-color:Gainsboro"></td>
                                        <cfif isdefined('attributes.is_production') and len(attributes.is_production)>
                                        	<td style="text-align:right;background-color:Gainsboro"><b>#AmountFormat(get_sub_satirlar.REAL_STOCK,0)#</b></td>
                                        <cfelse>
                                        	<td style="text-align:right;background-color:Gainsboro"><b>#AmountFormat(get_sub_satirlar.REAL_STOCK+get_sub_satirlar.URETIM,0)#</b></td>
                                        </cfif>
                                        <td style="text-align:right;background-color:Gainsboro">#AmountFormat(get_sub_satirlar.SIPARIS,0)#</td>
                                        <td style="text-align:right;background-color:Gainsboro"></td>
                                        <td style="text-align:right;background-color:Gainsboro"><b>#AmountFormat(get_sub_satirlar.SIPARIS,0)#</b></td>
                                        <cfif attributes.branch_id neq ''>
                                        	<td style="text-align:right;background-color:Gainsboro"></td>
                                        </cfif>
                                        <cfif isdefined('attributes.is_production') and len(attributes.is_production)>
                                         	<td style="text-align:right;background-color:Gainsboro;<cfif get_sub_satirlar.REAL_STOCK-get_sub_satirlar.SIPARIS lt 0>color:red</cfif>"><b>#AmountFormat(get_sub_satirlar.REAL_STOCK-get_sub_satirlar.SIPARIS,0)#</b></td>
                                         <cfelse>
                                        	<td style="text-align:right;background-color:Gainsboro;<cfif get_sub_satirlar.REAL_STOCK+get_sub_satirlar.URETIM-get_sub_satirlar.SIPARIS lt 0>color:red</cfif>"><b>#AmountFormat(get_sub_satirlar.REAL_STOCK+get_sub_satirlar.URETIM-get_sub_satirlar.SIPARIS,0)#</b></td>
                                        </cfif>
                                        <td style="background-color:Gainsboro"></td>
                                        <cfif isdefined('attributes.is_production') and len(attributes.is_production)>
                                        	<cfif get_sub_satirlar.REAL_STOCK-get_sub_satirlar.SIPARIS lt 0>
                                                <cfset need_sub_stock = (get_sub_satirlar.REAL_STOCK-get_sub_satirlar.SIPARIS)*-1>
                                            <cfelse>
                                                <cfset need_sub_stock = 0>
                                            </cfif>
                                        <cfelse>
											<cfif get_sub_satirlar.REAL_STOCK+get_sub_satirlar.URETIM-get_sub_satirlar.SIPARIS lt 0>
                                                <cfset need_sub_stock = (get_sub_satirlar.REAL_STOCK+get_sub_satirlar.URETIM-get_sub_satirlar.SIPARIS)*-1>
                                            <cfelse>
                                                <cfset need_sub_stock = 0>
                                            </cfif>
                                        </cfif>
                                        <td style="background-color:Gainsboro; text-align:right">
                                        	<span style="color:Gainsboro; font-size:7px">#need_stock#</span>
                                        	<input type="text" name="need_sub_stock_#satirlar.STOCK_ID#_#STOCK_ID#"  id="need_sub_stock_#satirlar.STOCK_ID#_#get_sub_satirlar.STOCK_ID#" value="#TlFormat(need_sub_stock,0)#" style="text-align:right; width:50px" class="box">
                                        </td>
                                        <td style="background-color:Gainsboro;text-align:center">
                                        	<input type="checkbox" name="select_sub_production_#satirlar.STOCK_ID#_#STOCK_ID#" id="select_sub_production_#satirlar.STOCK_ID#_#get_sub_satirlar.STOCK_ID#" value="#satirlar.STOCK_ID#_#get_sub_satirlar.STOCK_ID#" onchange="sub_select(this.value);">
                                        </td>
                                 	</tr>
                              	</cfloop>
                                <input name="sub_satirlar_stock_id_list_#satirlar.STOCK_ID#" id="sub_satirlar_stock_id_list_#satirlar.STOCK_ID#" type="hidden" value="#Evaluate('sub_satirlar_stock_id_list_#satirlar.STOCK_ID#')#">
                          	</cfif>
                        <cfelse>
                        	<cfset 'sub_satirlar_stock_id_list_#satirlar.STOCK_ID#' = 0>
                            <input name="sub_satirlar_stock_id_list_#satirlar.STOCK_ID#" id="sub_satirlar_stock_id_list_#satirlar.STOCK_ID#" type="hidden" value="0">
                        </cfif>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="21" class="color-row"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no='72.Kayıt Yok'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </cfif>
                <cfif isdefined("attributes.is_submitted")>
                <tfoot>
               		<tr>
                    	<cfif attributes.report_type eq 3><cfset colspan_value = 6><cfelse><cfset colspan_value = 9></cfif>
                    	<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt son_row>
							<cfoutput>
                                <td style="text-align:right;" colspan="5"><cfoutput>#getLang('budget',88)#</cfoutput></td>
                                <td style="text-align:right;">#AmountFormat(t_real_stock,0)#</td>
                                <td colspan="#colspan_value#"></td>
                                <cfif attributes.report_type neq 3>
                                <td style="text-align:center;" colspan="2">
                                	<input type="button" value="#getLang('main',3090)#" id="product_demand" onClick="grupla(-2);">
                                </td>
                                </cfif>
                            </cfoutput>
                       	<cfelse>
                        	<cfoutput>
                                <td style="text-align:right;" colspan="5"><strong><cfoutput>#getLang('main',268)#</cfoutput></strong></td>
                                <td style="text-align:right;"><strong>#AmountFormat(s_t_real_stock,0)#</strong></td>
                                <td colspan="#colspan_value#"></td>
                                <cfif attributes.report_type neq 3>
                                <td style="text-align:center;" colspan="2">
                                	<input type="button" value="#getLang('main',3090)#" id="product_demand" onClick="grupla(-2);">
                                </td>
                                </cfif>
                            </cfoutput>
                        </cfif>     
                	</tr>
            	</tfoot>
                </cfif>
            </tbody>
      	</table>

   	<!-- sil -->     
</cf_big_list>

<cfif isdefined("attributes.is_submitted") and attributes.totalrecords gt attributes.maxrows>
	<cfset adres="prod.popup_list_ezgi_production_need&is_submitted=1">
    <cfif len(attributes.keyword)>
		<cfset adres = "#adres#&keyword=#attributes.keyword#">
   	</cfif>
    <cfif isdefined('attributes.report_type') and len(attributes.report_type)>
       	<cfset adres = "#adres#&report_type=#attributes.report_type#">
    </cfif>
    <cfif Len(attributes.product_code)>
		<cfset adres = "#adres#&product_code=#attributes.product_code#">
    </cfif>
    <cfif Len(attributes.product_cat)>
		<cfset adres = "#adres#&product_cat=#attributes.product_cat#">
    </cfif>
    <cfif isdefined('attributes.upd_id') and len(attributes.upd_id)>
		<cfset adres = "#adres#&upd_id=#attributes.upd_id#">
  	</cfif>
    <cfif isdefined('attributes.ihr_sat') and len(attributes.ihr_sat)>
		<cfset adres = "#adres#&ihr_sat=#attributes.ihr_sat#">
  	</cfif>
    <cfif isdefined('attributes.calc_method') and len(attributes.calc_method)>
		<cfset adres = "#adres#&calc_method=#attributes.calc_method#">
  	</cfif>
    <cfif isdefined('attributes.is_production') and len(attributes.is_production)>
		<cfset adres = "#adres#&is_production=#attributes.is_production#">
  	</cfif>
    <cfif isdefined('attributes.yontem') and len(attributes.yontem)>
		<cfset adres = "#adres#&yontem=#attributes.yontem#">
  	</cfif>
    <cfif isdefined('attributes.unit_type') and len(attributes.unit_type)>
		<cfset adres = "#adres#&unit_type=#attributes.unit_type#">
  	</cfif>
    <cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
		<cfset adres = "#adres#&branch_id=#attributes.branch_id#">
  	</cfif>
    <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#adres#">
</cfif>

<script language="javascript">
	function grupla(type)
	{
		stock_id_list = '';
		<cfloop list="#satirlar_stock_is_list#" index="i">
			<cfoutput>
				stockid = #i#;
			</cfoutput>
			row_sub_id_list = document.getElementById('sub_satirlar_stock_id_list_'+stockid).value;
			if(row_sub_id_list != 0)
			{
				list_uzunluk = list_len(row_sub_id_list,',');
				for(i=1;i<=list_uzunluk;i++)
				{
					aranan_sub_id = list_getat(row_sub_id_list,i,',');
					if(eval('document.all.select_sub_production_'+stockid+'_'+aranan_sub_id).checked==true)
					{
						if(document.getElementById('need_sub_stock_'+stockid+'_'+aranan_sub_id).value > 0)
							stock_id_list +=aranan_sub_id+'_'+document.getElementById('need_sub_stock_'+stockid+'_'+aranan_sub_id).value+',';
						else
						{
							alert("<cfoutput>#getLang('prod',46)#</cfoutput>");
							document.getElementById('need_sub_stock_'+stockid+'_'+aranan_sub_id).focus();
							return false;
						}
					}
				}
			}
			if(eval('document.all.select_production_'+stockid).checked==true)
			{
				stock_id_list +=stockid+'_'+document.getElementById('need_stock_'+stockid).value+',';
				
			}
			if(type == -1)
			{//hepsini seç denilmişse	
				if(eval('document.all.select_production_'+stockid).checked==true)
					document.getElementById('select_production_'+stockid).checked = false;
				else
					document.getElementById('select_production_'+stockid).checked = true;
			}
		</cfloop>
		if(type == -2)
		{
			stock_id_list = stock_id_list.substr(0,stock_id_list.length-1);//sondaki virgülden kurtarıyoruz.
			if(stock_id_list!='')
			{
				document.getElementById('product_demand').disabled = true;
				<cfif isdefined('attributes.upd_id')>
					window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_upd_ezgi_production_demand&upd_id=#attributes.upd_id#&stock_id_list=</cfoutput>"+stock_id_list;
				<cfelse>
					windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.add_ezgi_production_demand&stock_id_list='+stock_id_list,'longpage');
				</cfif>
			}
		}
	}
	function input_control()
	{
		return true;
	}
	function seviyelendir()
	{
		<cfif isdefined("attributes.is_submitted") and satirlar.recordcount>
			<cfoutput query="satirlar" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				seviyelendir_demonte(#currentrow#);
			</cfoutput>
		</cfif>
	}
	function seviyelendir_demonte(row_count)
	{

		for(i=1;i<=1000;i++)
		{
			if(document.getElementById('demonte_1_'+row_count+'_'+i) != undefined)
			{	
				if (document.getElementById('demonte_1_'+row_count+'_'+i).style.display == 'none')
				{
					document.getElementById('demonte_1_'+row_count+'_'+i).style.display = '';
				}
				else
				{
					document.getElementById('demonte_1_'+row_count+'_'+i).style.display = 'none';
				}
			}
		}
	}
	function sub_select(satir)
	{
		satir_stock_id = list_getat(satir,1,'_');
		sub_satir_stock_id = list_getat(satir,2,'_');
		<cfif isdefined("attributes.is_submitted") and satirlar.recordcount>
			<cfoutput query="satirlar" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				if(satir_stock_id != #satirlar.stock_id#)
					sub_select_disble(#satirlar.stock_id#,sub_satir_stock_id);
			</cfoutput>
		</cfif>
	}
	function sub_select_disble(row_id,sub_id)
	{
		row_sub_id_list = document.getElementById('sub_satirlar_stock_id_list_'+row_id).value;
		buldunmu = list_find(row_sub_id_list,sub_id,',');
		if(buldunmu > 0)
			document.getElementById('select_sub_production_'+row_id+'_'+sub_id).disabled = true;
	}
	function satir_gizle(current_row_id,stock_id)
	{
		document.getElementById('satir_gizle_'+current_row_id).style.display='none';
		row_sub_id_list = document.getElementById('sub_satirlar_stock_id_list_'+stock_id).value;
		list_uzunluk = list_len(row_sub_id_list,',');
		for(i=1;i<=list_uzunluk;i++)
		{
			document.getElementById('demonte_1_'+current_row_id+'_'+i).style.display = 'none';
		}
	}
</script>