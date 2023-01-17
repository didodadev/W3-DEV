<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
    <cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
    <cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
    <cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
    <cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
    <cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
    <cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
    <cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
    <cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
    <cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
    <cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
    <cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
    <cfset ay_list = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
    <cfset attributes.process_id = session.ep.userid>
    <cfset attributes.plan_year = session.ep.period_year>
    <cfif len(session.ep.money2) and session.ep.money2 neq session.ep.money>
        <cfset attributes.is_doviz2 = 1>
    </cfif> 
    <cfset month_list=''>
    <cfloop from="1" to="#month(now())#" index="i">
        <cfset month_list=listappend(month_list,i)>
    </cfloop>
    <cfquery name="get_all_quotas" datasource="#dsn#" cachedwithin="#fusebox.general_cached_time#">
        SELECT 
            SUM(ROW_TOTAL) ROW_TOTAL,
            SUM(ROW_PROFIT) ROW_PROFIT,
            SUM(NET_TOTAL) NET_TOTAL,
            SUM(NET_KAR) NET_KAR,
            <cfif isdefined("attributes.is_doviz2")>
                SUM(ROW_TOTAL2) ROW_TOTAL2,
                SUM(NET_TOTAL2) NET_TOTAL2,
            </cfif>
            EMPLOYEE_ID,
            MONTH_VALUE
        FROM
        (
            SELECT 
                SQR.ROW_TOTAL,
                SQR.ROW_PROFIT,
                0 AS NET_TOTAL,
                0 AS NET_KAR,
                <cfif isdefined("attributes.is_doviz2")>
                    SQR.ROW_TOTAL2,
                    0 AS NET_TOTAL2,
                </cfif>
                SQR.EMPLOYEE_ID EMPLOYEE_ID,
                SQR.QUOTE_MONTH AS MONTH_VALUE
            FROM
                SALES_QUOTES_GROUP SQ,
                SALES_QUOTES_GROUP_ROWS SQR
            WHERE
                SQ.SALES_QUOTE_ID = SQR.SALES_QUOTE_ID
                AND SQ.IS_PLAN = 1
                <cfif isdefined("attributes.process_id") and len(attributes.process_id)>
                    AND SQR.EMPLOYEE_ID = #attributes.process_id#
                <cfelse>
                    AND SQR.EMPLOYEE_ID IS NOT NULL
                </cfif>
                AND SQR.QUOTE_MONTH IN (#month_list#)
                AND SQ.QUOTE_YEAR = #attributes.plan_year#
        UNION ALL
            SELECT
                0 AS ROW_TOTAL,
                0 AS ROW_PROFIT,
                CASE WHEN INVOICE_CAT IN(54,55,49,51,63) THEN -1*((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) ELSE ((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL) END AS NET_TOTAL,
                CASE WHEN INVOICE_CAT IN(54,55,49,51,63) THEN 
                    -1*ISNULL((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL - 
                        ISNULL((
                                SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM
                                )+ISNULL(PROM_COST,0)
                            FROM 
                                #dsn3_alias#.PRODUCT_COST PRODUCT_COST
                            WHERE 
                                PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
                                ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
                                PRODUCT_COST.START_DATE <= I.INVOICE_DATE
                            ORDER BY
                                PRODUCT_COST.START_DATE DESC,
                                PRODUCT_COST.RECORD_DATE DESC,
                                PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
                            ),0)
                    ,0) 
                ELSE 
                    ISNULL((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL - 
                        ISNULL((
                                SELECT TOP 1 IR.AMOUNT*(PURCHASE_NET_SYSTEM+PURCHASE_EXTRA_COST_SYSTEM
                                )+ISNULL(PROM_COST,0)
                            FROM 
                                #dsn3_alias#.PRODUCT_COST PRODUCT_COST
                            WHERE 
                                PRODUCT_COST.PRODUCT_ID=IR.PRODUCT_ID AND
                                ISNULL(PRODUCT_COST.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=IR.SPECT_VAR_ID),0) AND
                                PRODUCT_COST.START_DATE <= I.INVOICE_DATE
                            ORDER BY
                                PRODUCT_COST.START_DATE DESC,
                                PRODUCT_COST.RECORD_DATE DESC,
                                PRODUCT_COST.PURCHASE_NET_SYSTEM DESC
                            ),0)
                    ,0)
                END AS NET_KAR,
                <cfif isdefined("attributes.is_doviz2")>
                    0 AS ROW_TOTAL2,
                    CASE WHEN INVOICE_CAT IN(54,55,49,51,63) THEN -1*(((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(INV_M.RATE2/INV_M.RATE1)) ELSE (((1- I.SA_DISCOUNT/(I.NETTOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)/(INV_M.RATE2/INV_M.RATE1)) END AS NET_TOTAL2,
                </cfif>
                #session.ep.userid# AS  EMPLOYEE_ID,
                MONTH(I.INVOICE_DATE) AS MONTH_VALUE
            FROM
                #dsn2_alias#.INVOICE I,
                #dsn2_alias#.INVOICE_ROW IR
                <cfif isdefined("attributes.is_doviz2")>
                    ,#dsn2_alias#.INVOICE_MONEY INV_M
                </cfif>
            WHERE
                IR.INVOICE_ID = I.INVOICE_ID
                AND I.INVOICE_CAT IN (50,52,53,531,58,561,54,55,51,63,48,49)
                AND I.IS_IPTAL = 0
                AND I.NETTOTAL > 0 
                <cfif isdefined("attributes.is_doviz2")>
                    AND I.INVOICE_ID = INV_M.ACTION_ID 
                    AND INV_M.MONEY_TYPE = '#session.ep.money2#' 
                </cfif>
                <cfif isdefined("attributes.process_id") and len(attributes.process_id)>
                    <cfif isdefined("attributes.kontrol_type") and attributes.kontrol_type eq 2>
                        AND
                        ( 
                        (I.COMPANY_ID IS NOT NULL AND I.COMPANY_ID IN (SELECT WEP.COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE WEP.POSITION_CODE = #session.ep.position_code# AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID= #session.ep.company_id# AND WEP.COMPANY_ID IS NOT NULL))
                        OR
                        (I.CONSUMER_ID IS NOT NULL AND I.CONSUMER_ID IN (SELECT WEP.CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WEP WHERE WEP.POSITION_CODE = #session.ep.position_code# AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID= #session.ep.company_id# AND WEP.CONSUMER_ID IS NOT NULL))
                        )
                    <cfelse>
                        AND I.SALE_EMP = #attributes.process_id#
                    </cfif>
                <cfelse>
                    AND I.SALE_EMP IS NOT NULL
                </cfif>
                AND MONTH(I.INVOICE_DATE) IN (#month_list#)
                AND YEAR(I.INVOICE_DATE) = #attributes.plan_year#
            )T1
        GROUP BY
            EMPLOYEE_ID,
            MONTH_VALUE
    </cfquery>
    <cfquery name="get_total_quota" dbtype="query">
        SELECT SUM(NET_TOTAL) NET_TOTAL,SUM(ROW_TOTAL) ROW_TOTAL  FROM get_all_quotas 
    </cfquery>
    <cfset genel_toplam = 0>
    <cfset genel_toplam2 = 0>
    <cfset g_genel_toplam = 0>
    <cfset g_genel_toplam2 = 0>
    <cfloop list="#month_list#" index="k">
		<cfquery name="get_quota_#k#" dbtype="query">
			SELECT * FROM get_all_quotas WHERE MONTH_VALUE = #k# 
		</cfquery>
		<cfset 'ay_cat_list_#k#' = ''>
		<cfset 'toplam_ay_#k#' = 0>
		<cfset 'toplam_ay_2_#k#' = 0>
		<cfset 'g_toplam_ay_#k#' = 0>
		<cfset 'g_toplam_ay_2_#k#' = 0>
		<cfset quota_query = evaluate('get_quota_#k#')>
		<cfif quota_query.recordcount>
			<cfset 'ay_cat_list_#k#' = listsort(valuelist(quota_query.employee_id,','),'numeric','ASC',',')>
		</cfif>
	</cfloop>
</cfif>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_quotas';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_my_quotas.cfm';
	
</cfscript>
