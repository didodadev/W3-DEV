<cfset discount_manuel = evaluate('attributes.p_discount_manuel_#cc#')>
<cfif len(discount_manuel)>
	<cfset discount_manuel = filternum(discount_manuel,4)>
<cfelse>
	<cfset discount_manuel = 0>
</cfif>
<cfset discount_ilk = evaluate('attributes.sales_discount_#cc#')>

<cfloop from="1" to="10" index="i">
	<cfset 'discount#i#' = 0>
</cfloop>

<cfset i = 0>
<cfloop list="#discount_ilk#" index="dis" delimiters="+">
	<cfset i = i+1>
	<cfset 'discount#i#' = filterNum(dis)>
</cfloop>

<cfset company_id_ = evaluate('attributes.company_id_#cc#')>
<cfset project_id_ = evaluate('attributes.project_id_#cc#')>


<cfif 
	filternum(evaluate('attributes.FIRST_SATIS_PRICE_#cc#'),4) gt 0 and 
	(
		(len(evaluate('attributes.startdate_#cc#')) and len(evaluate('attributes.finishdate_#cc#')))
		or
		(len(evaluate('attributes.p_startdate_#cc#')) and len(evaluate('attributes.p_finishdate_#cc#')))
	)
	>
    
 
	<cfif len(evaluate("attributes.startdate_#cc#"))><cf_date tarih = 'attributes.startdate_#cc#'></cfif>
	<cfif len(evaluate("attributes.finishdate_#cc#"))><cf_date tarih = 'attributes.finishdate_#cc#'></cfif>
	
	<cfif len(evaluate("attributes.p_startdate_#cc#"))><cf_date tarih = 'attributes.p_startdate_#cc#'></cfif>
	<cfif len(evaluate("attributes.p_finishdate_#cc#"))><cf_date tarih = 'attributes.p_finishdate_#cc#'></cfif>
	
    
	<cfset p_alis = filternum(evaluate('attributes.NEW_ALIS_KDVLI_#cc#'),4)>
    <cfset p_satis = filternum(evaluate('attributes.FIRST_SATIS_PRICE_KDV_#cc#'),4)>
    
    <cfset p_start = evaluate('attributes.p_startdate_#cc#')>
    <cfset p_finish_ = evaluate('attributes.p_finishdate_#cc#')>
    
    <cfset start_ = evaluate('attributes.startdate_#cc#')>
    <cfset finish_ = evaluate('attributes.finishdate_#cc#')>
    
    <cfset p_type_ = evaluate('attributes.price_type_#cc#')>
    
    <cfif isdefined("attributes.is_active_s_#cc#") and evaluate('attributes.is_active_s_#cc#') eq 1>
    	<cfset is_active_s_ = 1>
    <cfelse>
    	<cfset is_active_s_ = 0>
    </cfif>
    
    <cfif isdefined("attributes.is_active_p_#cc#") and evaluate('attributes.is_active_p_#cc#') eq 1>
    	<cfset is_active_p_ = 1>
    <cfelse>
    	<cfset is_active_p_ = 0>
    </cfif>
    
    <cfif attributes.update_price_action eq 0>
    	<cfset is_active_s_ = 1>
        <cfset is_active_p_ = 1>
    </cfif>
    
    <cfif attributes.update_price_action eq 2>
    	<cfset is_active_s_ = 0>
        <cfset is_active_p_ = 0>
    </cfif>
    
    <cfset row_id_ =  evaluate('attributes.product_price_change_lastrowid_#cc#')>

    <cfif attributes.update_price_action eq 1 and row_id_ gt 0>
    	  <cfquery name="get_checks" datasource="#dsn_dev#">
          		SELECT
                	ISNULL(IS_ACTIVE_S,0) AS ACTIVE_S,
                    ISNULL(IS_ACTIVE_P,0) AS ACTIVE_P
                FROM
                	PRICE_TABLE
                WHERE
               		ROW_ID = #row_id_#
          </cfquery>
          <cfquery name="add_" datasource="#dsn_dev#" result="aa">
                UPDATE
                    PRICE_TABLE
                SET
                    SALIS = #filternum(evaluate("attributes.STANDART_ALIS_LISTE_#cc#"))#,
                    SALISKDV = #filternum(evaluate("attributes.STANDART_ALIS_KDVLI_#cc#"))#,
                    AKDV = #get_product_info.TAX_PURCHASE#,
                    SSATIS = #filternum(evaluate("attributes.READ_FIRST_SATIS_PRICE_#cc#"))#,
                    SSATISKDV = #filternum(evaluate("attributes.READ_FIRST_SATIS_PRICE_KDV_#cc#"))#,
                    SKDV = #get_product_info.TAX#,
                    DISCOUNT1 = <cfif len(discount1)>#discount1#<cfelse>0</cfif>,
                    DISCOUNT2 = <cfif len(discount2)>#discount2#<cfelse>0</cfif>,
                    DISCOUNT3 = <cfif len(discount3)>#discount3#<cfelse>0</cfif>,
                    DISCOUNT4 = <cfif len(discount4)>#discount4#<cfelse>0</cfif>,
                    DISCOUNT5 = <cfif len(discount5)>#discount5#<cfelse>0</cfif>,
                    DISCOUNT6 = <cfif len(discount6)>#discount6#<cfelse>0</cfif>,
                    DISCOUNT7 = <cfif len(discount7)>#discount7#<cfelse>0</cfif>,
                    DISCOUNT8 = <cfif len(discount8)>#discount8#<cfelse>0</cfif>,
                    DISCOUNT9 = <cfif len(discount9)>#discount9#<cfelse>0</cfif>,
                    DISCOUNT10 = <cfif len(discount10)>#discount10#<cfelse>0</cfif>,
                    MANUEL_DISCOUNT = #discount_manuel#,
                    NEW_ALIS = #filternum(evaluate('attributes.NEW_ALIS_#cc#'),4)#,
                    NEW_ALIS_KDV = #filternum(evaluate('attributes.NEW_ALIS_KDVLI_#cc#'),4)#,
                    NEW_PRICE = #filternum(evaluate('attributes.FIRST_SATIS_PRICE_#cc#'),4)#,
                    NEW_PRICE_KDV = #filternum(evaluate('attributes.FIRST_SATIS_PRICE_KDV_#cc#'),4)#,
                    MARGIN = #filternum(evaluate("attributes.p_ss_marj_#cc#"))#,
                    STARTDATE = <cfif len(evaluate("attributes.startdate_#cc#"))>#evaluate('attributes.startdate_#cc#')#<cfelse>NULL</cfif>,
                    FINISHDATE = <cfif len(evaluate("attributes.finishdate_#cc#"))>#evaluate('attributes.finishdate_#cc#')#<cfelse>NULL</cfif>,
                    TABLE_ID = #attributes.table_id#,
                    TABLE_CODE = '#attributes.table_code#',
                    RECORD_EMP = #session.ep.userid#,
                    RECORD_DATE = #simdiki_zaman_#, 
                    PRODUCT_ID = #CC#,
                    STOCK_ID = NULL,
                    PRICE_TYPE = #evaluate('attributes.price_type_#cc#')#,
                    IS_ACTIVE_S = <cfif is_active_s_ eq 1>1<cfelseif get_checks.ACTIVE_S eq 1>1<cfelse>0</cfif>,
                    IS_ACTIVE_P = <cfif is_active_p_ eq 1>1<cfelseif get_checks.ACTIVE_P eq 1>1<cfelse>0</cfif>,
                    CHANGE_RATE = '#evaluate('attributes.READ_FIRST_SATIS_PRICE_RATE_#cc#')#',
                    P_STARTDATE = <cfif len(evaluate("attributes.p_startdate_#cc#"))>#evaluate('attributes.p_startdate_#cc#')#<cfelse>NULL</cfif>,
                    P_FINISHDATE = <cfif len(evaluate("attributes.p_finishdate_#cc#"))>#evaluate('attributes.p_finishdate_#cc#')#<cfelse>NULL</cfif>,
                    P_MARGIN = <cfif len(evaluate("attributes.p_marj_#cc#"))>#filternum(evaluate("attributes.p_marj_#cc#"))#<cfelse>NULL</cfif>,
                    DUEDAY = <cfif len(evaluate("attributes.p_dueday_#cc#"))>#evaluate("attributes.p_dueday_#cc#")#<cfelse>NULL</cfif>,
                    BRUT_ALIS = #filternum(evaluate('attributes.NEW_ALIS_START_#cc#'),4)#
               WHERE
               		ROW_ID = #row_id_#
            </cfquery>
	<cfelse>
        <cfquery name="control_" datasource="#dsn_dev#">
            SELECT
                *
            FROM
                PRICE_TABLE
            WHERE
                TABLE_ID IS NOT NULL AND
                PRODUCT_ID = #CC#
                <cfif len(p_start)>
                    AND P_STARTDATE = #p_start#
                </cfif>
                <cfif len(p_finish_)>
                    AND P_FINISHDATE = #p_finish_#
                </cfif>
                <cfif len(start_)>
                    AND STARTDATE = #start_#
                </cfif>
                <cfif len(finish_)>
                    AND FINISHDATE = #finish_#
                </cfif>
                <cfif len(p_type_)>
                    AND PRICE_TYPE = #p_type_#
                </cfif>
        </cfquery>

        <cfif not control_.recordcount>
            <cfquery name="add_" datasource="#dsn_dev#" result="aaa">
                INSERT INTO
                    PRICE_TABLE
                    (
                    SALIS,
                    SALISKDV,
                    AKDV,
                    SSATIS,
                    SSATISKDV,
                    SKDV,
                    DISCOUNT1,
                    DISCOUNT2,
                    DISCOUNT3,
                    DISCOUNT4,
                    DISCOUNT5,
                    DISCOUNT6,
                    DISCOUNT7,
                    DISCOUNT8,
                    DISCOUNT9,
                    DISCOUNT10,
                    MANUEL_DISCOUNT,
                    NEW_ALIS,
                    NEW_ALIS_KDV,
                    NEW_PRICE,
                    NEW_PRICE_KDV,
                    MARGIN,
                    STARTDATE,
                    FINISHDATE,
                    TABLE_ID,
                    TABLE_CODE,
                    RECORD_EMP,
                    RECORD_DATE,
                    PRODUCT_ID,
                    STOCK_ID,
                    PRICE_TYPE,
                    IS_ACTIVE_S,
                    IS_ACTIVE_P,
                    CHANGE_RATE,
                    P_STARTDATE,
                    P_FINISHDATE,
                    P_MARGIN,
                    DUEDAY,
                    BRUT_ALIS,
                    COMPANY_ID,
                    PROJECT_ID
                    )
                    VALUES
                    (
                    #filternum(evaluate("attributes.STANDART_ALIS_LISTE_#cc#"))#,
                    #filternum(evaluate("attributes.STANDART_ALIS_KDVLI_#cc#"))#,
                    #get_product_info.TAX_PURCHASE#,
                    #filternum(evaluate("attributes.READ_FIRST_SATIS_PRICE_#cc#"))#,
                    #filternum(evaluate("attributes.READ_FIRST_SATIS_PRICE_KDV_#cc#"))#,
                    #get_product_info.TAX#,
                    <cfif len(discount1)>#discount1#<cfelse>0</cfif>,
                    <cfif len(discount2)>#discount2#<cfelse>0</cfif>,
                    <cfif len(discount3)>#discount3#<cfelse>0</cfif>,
                    <cfif len(discount4)>#discount4#<cfelse>0</cfif>,
                    <cfif len(discount5)>#discount5#<cfelse>0</cfif>,
                    <cfif len(discount6)>#discount6#<cfelse>0</cfif>,
                    <cfif len(discount7)>#discount7#<cfelse>0</cfif>,
                    <cfif len(discount8)>#discount8#<cfelse>0</cfif>,
                    <cfif len(discount9)>#discount9#<cfelse>0</cfif>,
                    <cfif len(discount10)>#discount10#<cfelse>0</cfif>,
                    #discount_manuel#,
                    #filternum(evaluate('attributes.NEW_ALIS_#cc#'),4)#,
                    #filternum(evaluate('attributes.NEW_ALIS_KDVLI_#cc#'),4)#,
                    #filternum(evaluate('attributes.FIRST_SATIS_PRICE_#cc#'),4)#,
                    #filternum(evaluate('attributes.FIRST_SATIS_PRICE_KDV_#cc#'),4)#,
                    #filternum(evaluate("attributes.p_ss_marj_#cc#"))#,
                    <cfif len(evaluate("attributes.startdate_#cc#"))>#evaluate('attributes.startdate_#cc#')#<cfelse>NULL</cfif>,
                    <cfif len(evaluate("attributes.finishdate_#cc#"))>#evaluate('attributes.finishdate_#cc#')#<cfelse>NULL</cfif>,
                    #attributes.table_id#,
                    '#attributes.table_code#',
                    #session.ep.userid#,
                    #simdiki_zaman_#,
                    #CC#,
                    NULL,
                    #evaluate('attributes.price_type_#cc#')#,
                    #is_active_s_#,
                    #is_active_p_#,
                    '#evaluate('attributes.READ_FIRST_SATIS_PRICE_RATE_#cc#')#',
                    <cfif len(evaluate("attributes.p_startdate_#cc#"))>#evaluate('attributes.p_startdate_#cc#')#<cfelse>NULL</cfif>,
                    <cfif len(evaluate("attributes.p_finishdate_#cc#"))>#evaluate('attributes.p_finishdate_#cc#')#<cfelse>NULL</cfif>,
                    <cfif len(evaluate("attributes.p_marj_#cc#"))>#filternum(evaluate("attributes.p_marj_#cc#"))#<cfelse>NULL</cfif>,
                    <cfif len(evaluate("attributes.p_dueday_#cc#"))>#evaluate("attributes.p_dueday_#cc#")#<cfelse>NULL</cfif>,
                    #filternum(evaluate('attributes.NEW_ALIS_START_#cc#'),4)#,
                    <cfif len(company_id_)>#company_id_#<cfelse>NULL</cfif>,
                    <cfif len(project_id_)>#project_id_#<cfelse>NULL</cfif>
                    )
            </cfquery>
         <cfelse>
         	<cfquery name="add_" datasource="#dsn_dev#">
                UPDATE
                    PRICE_TABLE
                SET
                    SALIS = #filternum(evaluate("attributes.STANDART_ALIS_LISTE_#cc#"))#,
                    SALISKDV = #filternum(evaluate("attributes.STANDART_ALIS_KDVLI_#cc#"))#,
                    AKDV = #get_product_info.TAX_PURCHASE#,
                    SSATIS = #filternum(evaluate("attributes.READ_FIRST_SATIS_PRICE_#cc#"))#,
                    SSATISKDV = #filternum(evaluate("attributes.READ_FIRST_SATIS_PRICE_KDV_#cc#"))#,
                    SKDV = #get_product_info.TAX#,
                    DISCOUNT1 = <cfif len(discount1)>#discount1#<cfelse>0</cfif>,
                    DISCOUNT2 = <cfif len(discount2)>#discount2#<cfelse>0</cfif>,
                    DISCOUNT3 = <cfif len(discount3)>#discount3#<cfelse>0</cfif>,
                    DISCOUNT4 = <cfif len(discount4)>#discount4#<cfelse>0</cfif>,
                    DISCOUNT5 = <cfif len(discount5)>#discount5#<cfelse>0</cfif>,
                    DISCOUNT6 = <cfif len(discount6)>#discount6#<cfelse>0</cfif>,
                    DISCOUNT7 = <cfif len(discount7)>#discount7#<cfelse>0</cfif>,
                    DISCOUNT8 = <cfif len(discount8)>#discount8#<cfelse>0</cfif>,
                    DISCOUNT9 = <cfif len(discount9)>#discount9#<cfelse>0</cfif>,
                    DISCOUNT10 = <cfif len(discount10)>#discount10#<cfelse>0</cfif>,
                    MANUEL_DISCOUNT = #discount_manuel#,
                    NEW_ALIS = #filternum(evaluate('attributes.NEW_ALIS_#cc#'),4)#,
                    NEW_ALIS_KDV = #filternum(evaluate('attributes.NEW_ALIS_KDVLI_#cc#'),4)#,
                    NEW_PRICE = #filternum(evaluate('attributes.FIRST_SATIS_PRICE_#cc#'),4)#,
                    NEW_PRICE_KDV = #filternum(evaluate('attributes.FIRST_SATIS_PRICE_KDV_#cc#'),4)#,
                    MARGIN = #filternum(evaluate("attributes.p_ss_marj_#cc#"))#,
                    STARTDATE = <cfif len(evaluate("attributes.startdate_#cc#"))>#evaluate('attributes.startdate_#cc#')#<cfelse>NULL</cfif>,
                    FINISHDATE = <cfif len(evaluate("attributes.finishdate_#cc#"))>#evaluate('attributes.finishdate_#cc#')#<cfelse>NULL</cfif>,
					RECORD_EMP = #session.ep.userid#,
                    RECORD_DATE = #simdiki_zaman_#,
                    PRODUCT_ID = #CC#,
                    STOCK_ID = NULL,
                    PRICE_TYPE = #evaluate('attributes.price_type_#cc#')#,
                    IS_ACTIVE_S = <cfif is_active_s_ eq 1>1<cfelse>0</cfif>,
                    IS_ACTIVE_P = <cfif is_active_p_ eq 1>1<cfelse>0</cfif>,
                    CHANGE_RATE = '#evaluate('attributes.READ_FIRST_SATIS_PRICE_RATE_#cc#')#',
                    P_STARTDATE = <cfif len(evaluate("attributes.p_startdate_#cc#"))>#evaluate('attributes.p_startdate_#cc#')#<cfelse>NULL</cfif>,
                    P_FINISHDATE = <cfif len(evaluate("attributes.p_finishdate_#cc#"))>#evaluate('attributes.p_finishdate_#cc#')#<cfelse>NULL</cfif>,
                    P_MARGIN = <cfif len(evaluate("attributes.p_marj_#cc#"))>#filternum(evaluate("attributes.p_marj_#cc#"))#<cfelse>NULL</cfif>,
                    DUEDAY = <cfif len(evaluate("attributes.p_dueday_#cc#"))>#evaluate("attributes.p_dueday_#cc#")#<cfelse>NULL</cfif>,
                    BRUT_ALIS = #filternum(evaluate('attributes.NEW_ALIS_START_#cc#'),4)#
               WHERE
               		ROW_ID = #control_.row_id#
            </cfquery>
         </cfif>
     </cfif>
</cfif>