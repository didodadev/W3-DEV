<cfparam name="attributes.view_type" default="m">
<cfparam name="attributes.view_start" default="#month(now())#">
<cfparam name="attributes.view_row" default="12">
<cfparam name="attributes.view_stock_type" default="1">
<cfparam name="attributes.view_stock_type1" default="1">
<cfparam name="attributes.search_department_id" default="">
<cfif not isdefined("attributes.stock_id")>
	<cfquery name="get_stocks" datasource="#dsn3#" result="a1">
        SELECT STOCK_ID,PROPERTY FROM STOCKS WHERE PRODUCT_ID = #attributes.product_id#
    </cfquery>
    <cfset attributes.stock_id = valuelist(get_stocks.stock_id)>
    <cfset attributes.stock_name_list = valuelist(get_stocks.property)>
</cfif>
<cfinclude template="../functions.cfm">
<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#">

<cfset dept_code_list = "'101','102','103','104','105','106','107','108','109','50'">
<cfquery name="get_my_branches" datasource="#dsn#">
	SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfif get_my_branches.recordcount>
	<cfset my_branch_list = valuelist(get_my_branches.BRANCH_ID)>
<cfelse>
	<cfset my_branch_list = '0'>
</cfif>
<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD,HIERARCHY 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (#my_branch_list#) AND        
        HIERARCHY IS NOT NULL AND
        HIERARCHY <> ''
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_stock_info" datasource="#dsn2#" result="get_stock_info_r">
	EXEC get_stock_last_location_function '#attributes.stock_id#'
</cfquery>

<cfquery name="get_last_stock" dbtype="query">
    SELECT SUM(PRODUCT_STOCK) AS SONSTOK FROM get_stock_info WHERE DEPARTMENT_ID NOT IN (#iade_depo_id#)
</cfquery>

<cfquery name="get_depo_stock" dbtype="query">
	SELECT SUM(PRODUCT_STOCK) AS SONSTOK FROM get_stock_info WHERE DEPARTMENT_ID = #merkez_depo_id#
</cfquery>

<cfset ilk_tarih = now()>
<cfset hafta_now = week(now())>
<cfset hafta_basi_ilk = dateadd('d',1,GetDateByWeek(year(now()),hafta_now))>
<cfset hafta_sonu_ilk = dateadd('d',7,GetDateByWeek(year(now()),hafta_now))>

<cfloop from="1" to="#attributes.view_row#" index="mmm">
	<cfif attributes.view_type is 'm'>
    	<cfset ay_ = month(dateadd('m',-(mmm-1),now()))>
        <cfset yil_ = year(dateadd('m',-(mmm-1),now()))>
    	<cfset 'name_#mmm#' = listgetat(ay_list,ay_)>
        <cfset 'yil_#mmm#' = yil_>
        <cfset 'deger_alis_#mmm#' = 0>
        <cfset 'deger_satis_#mmm#' = 0>
        <cfset 'deger_alis_iade_#mmm#' = 0>
        <cfset 'deger_lok_sevk_#mmm#' = 0>
        <cfset 'deger_lok_kabul_#mmm#' = 0>
        <cfset ilk_tarih = createodbcdatetime(createdate(yil_,ay_,1))>
    </cfif>
    
    <cfif attributes.view_type is 'd'>
		<cfset tarih_ = dateadd('d',-(mmm-1),now())>
    	<cfset 'name_#mmm#' = dateformat(tarih_,'dd/mm/yyyy')>
        <cfset 'yil_#mmm#' = dateformat(tarih_,'yyyy')>
        <cfset 'deger_alis_#mmm#' = 0>
        <cfset 'deger_satis_#mmm#' = 0>
        <cfset 'deger_alis_iade_#mmm#' = 0>
        <cfset 'deger_lok_sevk_#mmm#' = 0>
        <cfset 'deger_lok_kabul_#mmm#' = 0>
        <cfset ilk_tarih = tarih_>
    </cfif>
    
    <cfif attributes.view_type is 'w'>
		<cfset tarih1_ = dateadd('d',-(mmm-1) * 7,hafta_basi_ilk)>
        <cfset tarih2_ = dateadd('d',-(mmm-1) * 7,hafta_sonu_ilk)>
    	<cfset 'name_#mmm#' = "#dateformat(tarih1_,'dd/mm/yyyy')#-#dateformat(tarih2_,'dd/mm/yyyy')#">
        <cfset 'yil_#mmm#' = dateformat(tarih1_,'yyyy')>
        <cfset 'deger_alis_#mmm#' = 0>
        <cfset 'deger_satis_#mmm#' = 0>
        <cfset 'deger_alis_iade_#mmm#' = 0>
        <cfset 'deger_lok_sevk_#mmm#' = 0>
        <cfset 'deger_lok_kabul_#mmm#' = 0>
        <cfset ilk_tarih = tarih1_>
    </cfif>
</cfloop>

<cfif attributes.search_department_id is 'undefined'>
	<cfset attributes.search_department_id = ''>
</cfif>

<cfif listfind(attributes.search_department_id,merkez_depo_id)>
	<cfset attributes.search_department_id = listdeleteat(attributes.search_department_id,listfind(attributes.search_department_id,merkez_depo_id))>
</cfif>
<cfif listfind(attributes.search_department_id,0)>
	<cfset attributes.search_department_id = listdeleteat(attributes.search_department_id,listfind(attributes.search_department_id,0))>
</cfif>


<cfif len(attributes.search_department_id)>
	<cfquery name="get_dept_code" dbtype="query">
    	SELECT HIERARCHY,DEPARTMENT_HEAD FROM get_departments_search WHERE DEPARTMENT_ID IN (#attributes.search_department_id#)
    </cfquery>
    <cfset DEPT_CODE = valuelist(get_dept_code.HIERARCHY)>
    <cfset DEPT_NAMES = valuelist(get_dept_code.DEPARTMENT_HEAD)>
    <cfif not get_dept_code.recordcount>
    	<cfset attributes.search_department_id = "">
    </cfif>
</cfif>


<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.company_id#
</cfquery>

<cfquery name="get_hareketler1" datasource="#dsn_dev#" result="aaa">
	SELECT 
       TARIH
      ,BIRIMNO
      ,EMTIANO
      ,BIRIM
      ,BIRIMIK
      ,HARGRUP
      ,HAREKET_TIP
      ,-1*HAREKET_TIP_KOD HAREKET_TIP_KOD,
      0 AS UPPER_HAREKET_TIP_KOD
      ,HAREKET_GRUBU
      ,YIL
      ,AY
      ,GUN
      ,PRODUCT_ID
      ,STOCK_ID
     FROM
     	PRODUCT_ACTIONS
     WHERE
     	<cfif len(attributes.search_department_id)>
        	BIRIMNO IN (#DEPT_CODE#) AND
        </cfif>
        STOCK_ID IN (#attributes.stock_id#) AND
        TARIH >= #ilk_tarih# AND
        TARIH <= '2014-08-31'
    UNION ALL
         SELECT
            SR.PROCESS_DATE TARIH,
            D.HIERARCHY BIRIMNO,
            S.STOCK_CODE_2 EMTIANO,
            NULL BIRIM,
            CASE WHEN SR.STOCK_IN > 0 THEN SR.STOCK_IN ELSE SR.STOCK_OUT END BIRIMIK,
            NULL HARGRUP,
            NULL HAREKET_TIP,
            CASE WHEN SR.PROCESS_TYPE = 81 AND SR.STOCK_IN > 0 THEN  -81
                 ELSE SR.PROCESS_TYPE END HAREKET_TIP_KOD,
            ISNULL(SR.UPPER_PROCESS_TYPE,0) AS UPPER_HAREKET_TIP_KOD,
            NULL HAREKET_GRUBU,
            YEAR(SR.PROCESS_DATE) YIL,
            MONTH(SR.PROCESS_DATE) AY,
            DAY(SR.PROCESS_DATE) GUN,
            S.PRODUCT_ID,
            SR.STOCK_ID
        FROM
            GET_STOCK_ROWS SR INNER JOIN
            #dsn_alias#.DEPARTMENT D ON D.DEPARTMENT_ID = SR.STORE INNER JOIN
            #dsn1_alias#.STOCKS S ON S.STOCK_ID = SR.STOCK_ID
        WHERE
            SR.PROCESS_TYPE NOT IN (-1002) AND
            SR.PROCESS_DATE IS NOT NULL AND 
            SR.PROCESS_DATE > '2014-08-31' AND
            <cfif listlen(attributes.search_department_id)>
                D.HIERARCHY IN (#DEPT_CODE#) AND
            </cfif>
            SR.STOCK_ID IN (#attributes.stock_id#) AND
            SR.PROCESS_DATE >= #ilk_tarih#
</cfquery>

<cfset s_type = "-33,-55,-57,67,52,70,-1003,-1005">

<cfloop from="1" to="#attributes.view_row#" index="mmm">
	<cfif attributes.view_type is 'm'>
    	<cfset ay_ = month(dateadd('m',-(mmm-1),now()))>
        <cfif len(ay_) eq 1>
        	<cfset ay_ = "0#ay_#">
        </cfif>
        <cfset yil_ = year(dateadd('m',-(mmm-1),now()))>
        
    	<cfquery name="get_alis" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE AY = #ay_# AND YIL = #yil_# AND HAREKET_TIP_KOD IN (-1,-17,76)
        </cfquery>
        <cfif get_alis.recordcount and len(get_alis.SAYI)>
        	<cfset 'deger_alis_#mmm#' = get_alis.SAYI>
        </cfif>
               
        <cfquery name="get_satis" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE AY = #ay_# AND YIL = #yil_# AND 
            	(
                	HAREKET_TIP_KOD IN (#s_type#)
                    OR
                 	(
                    	UPPER_HAREKET_TIP_KOD IN (#s_type#) AND 
                        (
                        	(HAREKET_TIP_KOD = -2000 AND BIRIMIK > 0)
                        	OR
                        	(HAREKET_TIP_KOD = -2001 AND BIRIMIK < 0)
                        )
                    )
                )
        </cfquery>
        <cfquery name="get_satis_iade" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE AY = #ay_# AND YIL = #yil_# AND 
            (
                	HAREKET_TIP_KOD IN (-1004) OR 
                 	(UPPER_HAREKET_TIP_KOD IN (-1004) AND HAREKET_TIP_KOD = -2001)
            )
        </cfquery>
        
        <cfif get_satis.recordcount and len(get_satis.SAYI)>
        	<cfset 'deger_satis_#mmm#' = get_satis.SAYI>
        </cfif>
        
        <cfif get_satis_iade.recordcount and len(get_satis_iade.SAYI)>
        	<cfif isdefined('deger_satis_#mmm#')>
				<cfset 'deger_satis_#mmm#' = evaluate('deger_satis_#mmm#') - get_satis_iade.SAYI>
        	<cfelse>
            	<cfset 'deger_satis_#mmm#' = 0 - get_satis_iade.SAYI>
            </cfif>
        </cfif>
        
        <cfquery name="get_alis_iade" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE AY = #ay_# AND YIL = #yil_# AND HAREKET_TIP_KOD IN (-28,-29,78)
        </cfquery>
        <cfif get_alis_iade.recordcount and len(get_alis_iade.SAYI)>
        	<cfset 'deger_alis_iade_#mmm#' = get_alis_iade.SAYI>
        </cfif>
        
        <cfquery name="get_lok_sevk" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE AY = #ay_# AND YIL = #yil_# AND HAREKET_TIP_KOD IN (-6,-25,-44,81)
        </cfquery>
        <cfif get_lok_sevk.recordcount and len(get_lok_sevk.SAYI)>
        	<cfset 'deger_lok_sevk_#mmm#' = get_lok_sevk.SAYI>
        </cfif>
        
        <cfquery name="get_lok_kabul" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE AY = #ay_# AND YIL = #yil_# AND HAREKET_TIP_KOD IN (-27,-5,-35,-45,-60,-81)
        </cfquery>
        <cfif get_lok_kabul.recordcount and len(get_lok_kabul.SAYI)>
        	<cfset 'deger_lok_kabul_#mmm#' = get_lok_kabul.SAYI>
        </cfif>
    </cfif>
    
    <cfif attributes.view_type is 'w'>
    	<cfset tarih1_ = dateadd('d',-(mmm-1) * 7,hafta_basi_ilk)>
        <cfset tarih2_ = dateadd('d',-(mmm-1) * 7,hafta_sonu_ilk)>
        
        <cfset s_tarih_ = tarih1_>
        <cfset s_tarih_2 = tarih2_>

    	<cfquery name="get_alis" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH <= #s_tarih_2# AND HAREKET_TIP_KOD IN (-1,-17,76)
        </cfquery>
        <cfif get_alis.recordcount and len(get_alis.SAYI)>
        	<cfset 'deger_alis_#mmm#' = get_alis.SAYI>
        </cfif>
        
        <cfquery name="get_satis" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH <= #s_tarih_2# AND 
            (
                	HAREKET_TIP_KOD IN (#s_type#)
                    OR
                 	(
                    	UPPER_HAREKET_TIP_KOD IN (#s_type#) AND 
                        (
                        	(HAREKET_TIP_KOD = -2000 AND BIRIMIK > 0)
                        	OR
                        	(HAREKET_TIP_KOD = -2001 AND BIRIMIK < 0)
                        )
                    )
            )
        </cfquery>
        <cfquery name="get_satis_iade" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH <= #s_tarih_2# AND 
            (
                	HAREKET_TIP_KOD IN (-1004) OR 
                 	(UPPER_HAREKET_TIP_KOD IN (-1004) AND HAREKET_TIP_KOD = -2001)
            )
        </cfquery>
        <cfif get_satis.recordcount and len(get_satis.SAYI)>
        	<cfset 'deger_satis_#mmm#' = get_satis.SAYI>
        </cfif>
        <cfif get_satis_iade.recordcount and len(get_satis_iade.SAYI)>
        	<cfif isdefined('deger_satis_#mmm#')>
				<cfset 'deger_satis_#mmm#' = evaluate('deger_satis_#mmm#') - get_satis_iade.SAYI>
        	<cfelse>
            	<cfset 'deger_satis_#mmm#' = 0 - get_satis_iade.SAYI>
            </cfif>
        </cfif>
        
        <cfquery name="get_alis_iade" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH <= #s_tarih_2# AND HAREKET_TIP_KOD IN (-28,-29,78)
        </cfquery>
        <cfif get_alis_iade.recordcount and len(get_alis_iade.SAYI)>
        	<cfset 'deger_alis_iade_#mmm#' = get_alis_iade.SAYI>
        </cfif>
        
        <cfquery name="get_lok_sevk" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH <= #s_tarih_2# AND HAREKET_TIP_KOD IN (-6,-25,-44,81)
        </cfquery>
        <cfif get_lok_sevk.recordcount and len(get_lok_sevk.SAYI)>
        	<cfset 'deger_lok_sevk_#mmm#' = get_lok_sevk.SAYI>
        </cfif>
        <cfquery name="get_lok_kabul" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH <= #s_tarih_2# AND HAREKET_TIP_KOD IN (-27,-5,-35,-45,-60,-81)
        </cfquery>
        <cfif get_lok_kabul.recordcount and len(get_lok_kabul.SAYI)>
        	<cfset 'deger_lok_kabul_#mmm#' = get_lok_kabul.SAYI>
        </cfif>
    </cfif>
    <cfif attributes.view_type is 'd'>
    	<cfset tarih_ = dateadd('d',-(mmm-1),now())>
        <cfset s_tarih_ = createodbcdatetime(createdate(year(tarih_),month(tarih_),day(tarih_)))>

    	<cfquery name="get_alis" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH < #dateadd("d",1,s_tarih_)# AND HAREKET_TIP_KOD IN (-1,-17,76)
        </cfquery>
        <cfif get_alis.recordcount and len(get_alis.SAYI)>
        	<cfset 'deger_alis_#mmm#' = get_alis.SAYI>
        </cfif>
        
        <cfquery name="get_satis" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH < #dateadd("d",1,s_tarih_)#  AND
            (
                HAREKET_TIP_KOD IN (#s_type#)
                    OR
                 	(
                    	UPPER_HAREKET_TIP_KOD IN (#s_type#) AND 
                        (
                        	(HAREKET_TIP_KOD = -2000 AND BIRIMIK > 0)
                        	OR
                        	(HAREKET_TIP_KOD = -2001 AND BIRIMIK < 0)
                        )
                    )
            )
        </cfquery>

        <cfquery name="get_satis_iade" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH < #dateadd("d",1,s_tarih_)# AND 
            (
                	HAREKET_TIP_KOD IN (-1004) OR 
                 	(UPPER_HAREKET_TIP_KOD IN (-1004) AND HAREKET_TIP_KOD = -2001)
            )
        </cfquery>
        
        <cfif get_satis.recordcount and len(get_satis.SAYI)>
        	<cfset 'deger_satis_#mmm#' = get_satis.SAYI>
        </cfif>
        <cfif get_satis_iade.recordcount and len(get_satis_iade.SAYI)>
        	<cfif isdefined('deger_satis_#mmm#')>
				<cfset 'deger_satis_#mmm#' = evaluate('deger_satis_#mmm#') - get_satis_iade.SAYI>
        	<cfelse>
            	<cfset 'deger_satis_#mmm#' = 0 - get_satis_iade.SAYI>
            </cfif>
        </cfif>
        
        <cfquery name="get_alis_iade" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH < #dateadd("d",1,s_tarih_)# AND HAREKET_TIP_KOD IN (-28,-29,78)
        </cfquery>
        <cfif get_alis_iade.recordcount and len(get_alis_iade.SAYI)>
        	<cfset 'deger_alis_iade_#mmm#' = get_alis_iade.SAYI>
        </cfif>
        
        <cfquery name="get_lok_sevk" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH < #dateadd("d",1,s_tarih_)# AND HAREKET_TIP_KOD IN (-6,-25,-44,81)
        </cfquery>
        <cfif get_lok_sevk.recordcount and len(get_lok_sevk.SAYI)>
        	<cfset 'deger_lok_sevk_#mmm#' = get_lok_sevk.SAYI>
        </cfif>
        <cfquery name="get_lok_kabul" dbtype="query">
        	SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE TARIH >= #s_tarih_# AND TARIH < #dateadd("d",1,s_tarih_)# AND HAREKET_TIP_KOD IN (-27,-5,-35,-45,-60,-81)
        </cfquery>
        <cfif get_lok_kabul.recordcount and len(get_lok_kabul.SAYI)>
        	<cfset 'deger_lok_kabul_#mmm#' = get_lok_kabul.SAYI>
        </cfif>
    </cfif>
</cfloop>
    <cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    	<cf_box>
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <cfif len(attributes.search_department_id)>
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62489.Satışı Gösterilen Depolar'> :</label> 
                            <div class="col col-8 col-sm-12">       	
                                <cfoutput>#DEPT_NAMES#</cfoutput>
                            </div>
                        </cfif>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62490.Genel Stok'></label>
                        <div class="col col-8 col-sm-12">
                            <cfoutput>
                                <cfif listlen(wrk_round(get_last_stock.sonstok),'.') eq 2>#tlformat(get_last_stock.sonstok)#<cfelse>#tlformat(get_last_stock.sonstok,0)#</cfif>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62491.Depo Stok'></label>
                        <div class="col col-8 col-sm-12">
                            <cfoutput>
                                <cfif listlen(wrk_round(get_depo_stock.sonstok),'.') eq 2>#tlformat(get_depo_stock.sonstok)#<cfelse>#tlformat(get_depo_stock.sonstok,0)#</cfif>
                            </cfoutput>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
        </cf_box>
        <cf_box>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58455.Yıl'></th>
                        <th>
                            <cfif attributes.view_type is 'm'><cf_get_lang dictionary_id='58724.Ay'></cfif>
                            <cfif attributes.view_type is 'w'><cf_get_lang dictionary_id='58734.Hafta'></cfif>
                            <cfif attributes.view_type is 'd'><cf_get_lang dictionary_id='57490.Gün'></cfif>
                        </th>
                        <th><cf_get_lang dictionary_id='58176.Alış'></th>
                        <th><cf_get_lang dictionary_id='57448.Satış'></th>
                        <th><cf_get_lang dictionary_id='37461.Alış İade'></th>
                        <th><cf_get_lang dictionary_id='62492.L. Sevk'></th>
                        <th><cf_get_lang dictionary_id='62493.L. Kabul'></th>
                        <!---<th>Ort. Satış</th>--->
                    </tr>
                </thead>
                <tbody>
                <cfoutput>
                <cfset deger_alis_toplam = 0>
                <cfset deger_satis_toplam = 0>
                <cfset deger_alis_iade_toplam = 0>
                <cfset deger_lok_sevk_toplam = 0>
                <cfset deger_lok_kabul_toplam = 0>
                <cfloop from="1" to="#attributes.view_row#" index="ccc">
                <cfset deger_alis_toplam = deger_alis_toplam + #evaluate("deger_alis_#ccc#")#>
                <cfset deger_satis_toplam = deger_satis_toplam + #evaluate("deger_satis_#ccc#")#>
                <cfset deger_alis_iade_toplam = deger_alis_iade_toplam + #evaluate("deger_alis_iade_#ccc#")#>
                <cfset deger_lok_sevk_toplam = deger_lok_sevk_toplam + #evaluate("deger_lok_sevk_#ccc#")#>
                <cfset deger_lok_kabul_toplam = deger_lok_kabul_toplam + #evaluate("deger_lok_kabul_#ccc#")#>
                    <tr>
                        <td>#evaluate("yil_#ccc#")#</td>
                        <td>#evaluate("name_#ccc#")#</td>
                        <td style="text-align:right;">#tlformat(evaluate("deger_alis_#ccc#"))#</td>
                        <td style="text-align:right;">#tlformat(evaluate("deger_satis_#ccc#"))#</td>
                        <td style="text-align:right;">#tlformat(evaluate("deger_alis_iade_#ccc#"))#</td>
                        <td style="text-align:right;">#tlformat(evaluate("deger_lok_sevk_#ccc#"))#</td>
                        <td style="text-align:right;">#tlformat(evaluate("deger_lok_kabul_#ccc#"))#</td>
                        <!---<td style="text-align:right;">#tlformat(1000)#</td>--->
                    </tr>
                </cfloop>                    
                </cfoutput>
                <tr>
                    <cfoutput>
                            <td colspan="2"><cf_get_lang dictionary_id='50141.Toplamlar'></td>
                            <td style="text-align:right; ">#tlformat(deger_alis_toplam)#</td>
                            <td style="text-align:right; ">#tlformat(deger_satis_toplam)#</td>
                            <td style="text-align:right; ">#tlformat(deger_alis_iade_toplam)#</td>
                            <td style="text-align:right; ">#tlformat(deger_lok_sevk_toplam)#</td>
                            <td style="text-align:right; ">#tlformat(deger_lok_kabul_toplam)#</td>
                            <!---<td style="text-align:right;">#tlformat(1000)#</td>--->
                    </cfoutput>
                    </tr>
                </tbody>
            </cf_grid_list>
            <cfif attributes.view_stock_type1 eq 0>
                <cfset s_type = "-33,-55,-57,67">
            <cfelseif attributes.view_stock_type1 eq 1>
                <cfset s_type1 = "-33,70,67">
            <cfelse>
                <cfset s_type1 = "-55,-57,67">
            </cfif>
        </cf_box>
        <cf_box>
            <div id="manage_s_tranfer_div" style="width:96%; padding:3px; border:2px solid #F60; margin-bottom:4px; display:none;"></div>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58763.Depo'></th>
                        <th><cf_get_lang dictionary_id='58176.Alış'></th>
                        <th><cf_get_lang dictionary_id='57448.Satış'></th>
                        <th><cf_get_lang dictionary_id='57452.Stok'></th>
                        <th width="20"></th>
                    </tr>
                </thead>
                <tbody>
                <cfset alis_toplam = 0>
                <cfset satis_toplam = 0>
                <cfset son_toplam = 0>
                <cfoutput query="get_departments_search">
                    <tr>
                        <td>#department_head#</td>
                        <td style="text-align:right;">
                            <cfquery name="get_alis" dbtype="query">
                                SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE HAREKET_TIP_KOD IN (-1,-17,76) AND BIRIMNO = #hierarchy#
                            </cfquery>
                            #tlformat(get_alis.SAYI)#
                            <cfif get_alis.recordcount gt 0>
                            <cfset alis_toplam = alis_toplam + #get_alis.SAYI#>
                            </cfif>
                        </td>
                        <td style="text-align:right;">
                            <cfquery name="get_satis" dbtype="query">
                                SELECT SUM(BIRIMIK) AS SAYI FROM get_hareketler1 WHERE HAREKET_TIP_KOD IN (#s_type#) AND BIRIMNO = #hierarchy#
                            </cfquery>
                            #tlformat(get_satis.SAYI)#
                            <cfif get_satis.recordcount gt 0>
                            <cfset satis_toplam =  satis_toplam + #get_satis.SAYI#>
                            </cfif>
                        </td>
                        <td style="text-align:right;">
                        <cfquery name="get_row_stock"  dbtype="query">
                            SELECT 
                                SUM(PRODUCT_STOCK) AS SONSTOK 
                            FROM 
                                get_stock_info
                            WHERE 
                                STOCK_ID IN (#attributes.stock_id#) AND DEPARTMENT_ID = #DEPARTMENT_ID#
                        </cfquery>
                            #tlformat(get_row_stock.SONSTOK)#
                        <cfif get_row_stock.recordcount gt 0>
                            <cfset son_toplam = son_toplam + #get_row_stock.SONSTOK#>
                        </cfif>
                        </td>
                        <td width="20" style="text-align:center;">
                            <cfif listlen(attributes.stock_id) eq 1>
                                <div id="dagitim_#DEPARTMENT_ID#_#attributes.stock_id#" style="width:15px;"></div>
                                <script>
                                    AjaxPageLoad('index.cfm?fuseaction=retail.emptypopup_get_transfer_stock&department_id=#DEPARTMENT_ID#&stock_id=#attributes.stock_id#','dagitim_#DEPARTMENT_ID#_#attributes.stock_id#');	
                                </script>
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
                <tr>
                    <cfoutput>
                    <td style="text-align:left; "><cf_get_lang dictionary_id='50141.Toplamlar'></td>
                    <td style="text-align:right; ">#tlformat(alis_toplam)#</td>
                    <td style="text-align:right; ">#tlformat(satis_toplam)#</td>
                    <td style="text-align:right; ">#tlformat(son_toplam)#</td>
                    <td style="text-align:right; ">
                        <cfif listlen(attributes.stock_id) eq 1>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_detail_transfers_2&stock_id=#attributes.stock_id#','page');"><i class="fa fa-bar-chart"></i></a>
                        </cfif>
                    </td>
                    </cfoutput>
                </tr>
                
                </tbody>
            </cf_grid_list>
        </cf_box>
    </div>
<script>
function manage_s_tranfer_row(sid,did)
{
	show('manage_s_tranfer_div');
	adress_ = 'index.cfm?fuseaction=retail.emptypopup_get_transfer_stock_upd';
	adress_ += '&stock_id=' + sid;
	adress_ += '&department_id=' + did;
	
	AjaxPageLoad(adress_,'manage_s_tranfer_div','1');
}
function getir()
{
	<cfoutput>
		adress_ = 'index.cfm?fuseaction=retail.popup_product_stocks';
		<cfif isdefined("attributes.product_id")>
			adress_ += '&product_id=#attributes.product_id#';
		</cfif>
		<cfif isdefined("attributes.stock_id")>
			adress_ += '&stock_id=#attributes.stock_id#';
		</cfif>
	</cfoutput>
	
	adress_ += '&is_again=1';
	adress_ += '&view_type=' + document.getElementById('view_type_d').value;
	adress_ += '&view_stock_type=' + document.getElementById('view_stock_type_d').value;
	adress_ += '&search_department_id=' + document.getElementById('stock_search_department_id_d').value;
	
	AjaxPageLoad(adress_,'stock_window_inner','1');
}

$(document).ready(function ()
{
	<cfif not isdefined("attributes.is_again")>
		$("#stock_search_department_id").jqxDropDownList({autoDropDownHeight: true,checkboxes: true, width: 125, height: 25 });
		//$("#view_type").jqxDropDownList({autoDropDownHeight: true,checkboxes: false, width: 75, height: 25 });
		//$("#view_stock_type").jqxDropDownList({autoDropDownHeight: true,checkboxes: false, width: 100, height: 25 });
	</cfif>

	$("#stock_search_department_id").on('checkChange', function () 
	{
		tumu_ = document.getElementById('stock_search_department_id_d').value;
		deger_ = args.item.value;
		c_ = args.item.checked;
		
		if(c_ == true && tumu_ == '' && list_find(tumu_,deger_) == 0)
			tumu_ = deger_;
		else if(c_ == true && tumu_ != '' && list_find(tumu_,deger_) == 0)
		{
			tumu_ = tumu_ + ',' + deger_;
		}
		else if(c_ == false)
		{
			sira_ = list_find(tumu_,deger_);
			tumu_ = list_setat(tumu_,sira_,'0');
		}
		document.getElementById('stock_search_department_id_d').value = tumu_;
		getir();
	});
});


function view_stock_type_func()
{
	deger_ = document.getElementById('view_stock_type').value;
	document.getElementById('view_stock_type_d').value = deger_;
	getir();	
}

function view_type_func()
{
	deger_ = document.getElementById('view_type').value;
	if(deger_ == 'm')
		f2_pop = 1;
	else if(deger_ == 'w')
		f2_pop = 2;
	else
		f2_pop = 3;		
	document.getElementById('view_type_d').value = deger_;
	getir();
}
</script>