<!--- ALIS SATISTAN --->
<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_YEAR IN (2016,2017)
</cfquery>

<cfquery name="get_price_groups_all" datasource="#dsn_dev#" result="get_price_groups_all_r">
	SELECT 
    	*
    FROM
    	PRICE_TABLE
    WHERE
        <cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
            (
            COMPANY_ID IN (#attributes.company_ids#) OR
            OLD_COMPANY_ID IN (#attributes.company_ids#)
            )
            AND
        </cfif>
        --PRODUCT_ID = 6277 AND
        --ACTION_CODE = '00134189' AND
        FINISHDATE >= #attributes.startdate# AND
        FINISHDATE <= #attributes.finishdate# AND
        IS_ACTIVE_S = 1 AND
        STARTDATE IS NOT NULL AND
        FINISHDATE IS NOT NULL AND
        PRICE_TYPE IN (#kasa_cikis_olmayanlar#)
</cfquery>


<cfif get_price_groups_all.recordcount>
    <cfif isdefined("attributes.is_clear_old_rows")>
    	     
        <cfquery name="cont_" datasource="#dsn_dev#" result="aaa">
            DELETE
            FROM
                INVOICE_FF_ROWS
            WHERE
                INVOICE_ID IS NULL AND
                FF_TYPE = 2 AND
                TABLE_ROW_ID IN 
                	(
                    	SELECT 
                        	ROW_ID
                        FROM
                            PRICE_TABLE
                        WHERE
                            <cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
                                (
                                COMPANY_ID IN (#attributes.company_ids#) OR
                                OLD_COMPANY_ID IN (#attributes.company_ids#)
                                )
                                AND
                            </cfif>
                            FINISHDATE >= #attributes.startdate# AND
                            FINISHDATE <= #attributes.finishdate# AND
                            IS_ACTIVE_S = 1 AND
                            STARTDATE IS NOT NULL AND
                            FINISHDATE IS NOT NULL AND
                            PRICE_TYPE IN (#kasa_cikis_olmayanlar#)
                    ) AND
                INVOICE_DATE >= #attributes.startdate# AND
                INVOICE_DATE <= #attributes.finishdate# AND
                ISNULL(FF_PAID,0) = 0
        </cfquery>
   	</cfif>
</cfif>


<cfquery name="get_price_groups" dbtype="query">
	SELECT DISTINCT 
    	STARTDATE,
        FINISHDATE,
        P_STARTDATE,
        P_FINISHDATE
   	FROM 
    	get_price_groups_all 
    ORDER BY 
    	STARTDATE ASC,
        FINISHDATE DESC
</cfquery>



<CFOUTPUT query="get_price_groups">
	<cfset gun_ilk_ = STARTDATE>
    <cfset gun_son_ = FINISHDATE>
    
    <cfset gun_ilk_alis_ = P_STARTDATE>
    <cfset gun_son_alis_ = P_FINISHDATE>
    <cfquery name="get_" datasource="#dsn_dev#">
    	SELECT 
        	S.STOCK_ID,
            S.PRODUCT_ID,
            S.STOCK_CODE,
            S.PROPERTY,
            PT.PRICE_TYPE,
            PT.BRUT_ALIS,
            PT.NEW_ALIS,
            PT.DISCOUNT1,
            PT.DISCOUNT2,
            PT.DISCOUNT3,
            PT.DISCOUNT4,
            PT.DISCOUNT5,
            ISNULL(PT.PRICE_TYPE,-1) AS P_TYPE,
            PT.TABLE_CODE,
            PT.ROW_ID,
            ISNULL(PT.COMPANY_ID,P.COMPANY_ID) AS COMPANY_ID,
            P.PROJECT_ID,
            PT.P_STARTDATE,
            PT.P_FINISHDATE,
            CAST(ISNULL(PT.COMPANY_ID,P.COMPANY_ID) AS NVARCHAR) + '_' + CAST(ISNULL(P.PROJECT_ID,0) AS NVARCHAR) AS COMP_CODE
       	FROM 
        	PRICE_TABLE PT,
            #DSN1_ALIAS#.STOCKS S,
            #DSN1_ALIAS#.PRODUCT P
        WHERE
            P.COMPANY_ID IS NOT NULL AND
            PT.PRICE_TYPE IN (#kasa_cikis_olmayanlar#) AND
            PT.PRODUCT_ID = S.PRODUCT_ID AND
            PT.PRODUCT_ID = P.PRODUCT_ID AND
            PT.IS_ACTIVE_S = 1 AND
            PT.STARTDATE = #createodbcdatetime(STARTDATE)# AND
            PT.FINISHDATE = #createodbcdatetime(FINISHDATE)# AND
            PT.IS_ACTIVE_P = 1 AND
            PT.P_STARTDATE = #createodbcdatetime(P_STARTDATE)# AND
            PT.P_FINISHDATE = #createodbcdatetime(P_FINISHDATE)#
            --AND PT.PRODUCT_ID = 6277
            --AND PT.ACTION_CODE = '00134189'
            <!---
            AND
            (
            	P.COMPANY_ID = PT.COMPANY_ID
                OR
                PT.COMPANY_ID IS NULL
            )
			--->
            AND
            (
            P.COMPANY_ID = PT.COMPANY_ID 
            OR
            P.PRODUCT_ID IN (SELECT CCC.PRODUCT_ID FROM #dsn3_alias#.CONTRACT_PURCHASE_PROD_DISCOUNT CCC WHERE COMPANY_ID = PT.COMPANY_ID)
            )
        ORDER BY
        	PT.ROW_ID DESC
    </cfquery>
 
    <cfif get_.recordcount>
        <cfquery name="cont_before" dbtype="query">
            SELECT * FROM get_price_groups_all WHERE PRODUCT_ID = #get_.PRODUCT_ID# AND P_STARTDATE <= #createodbcdatetime(gun_ilk_alis_)# AND P_FINISHDATE >= #createodbcdatetime(gun_son_alis_)# AND ROW_ID <> #get_.ROW_ID#
        </cfquery>
    <cfelse>
    	<cfset cont_before.recordcount = 0>
    </cfif>
        
    <cfif get_.recordcount and not cont_before.recordcount>
        <cfquery name="get_depts" datasource="#dsn_dev#">
            SELECT * FROM PRICE_TABLE_DEPARTMENTS WHERE ROW_ID = #get_.ROW_ID#
        </cfquery>
        
        <cfif get_depts.recordcount>
            <cfset dept_list = valuelist(get_depts.department_id)>
        <cfelse>
            <cfset dept_list = ''>
        </cfif>
    
        <cfset p_list = "">
            <cfloop query="get_">
           		<cfif not listfind(p_list,STOCK_ID)>
					<cfset p_list = listappend(p_list,stock_id)>
                    <cfset stock_id_ = STOCK_ID>
                    <cfset COMPANY_ID_ = COMPANY_ID>
                    <cfquery name="get_satis" datasource="#dsn#">
                    SELECT
                    	SUM(SATIS1) AS SATIS
                    FROM
                    	(
                             <cfset count_ = 0>
                             <cfloop query="get_periods">
                             <cfset count_ = count_ + 1>
                              <cfif count_ neq 1>
                             		UNION ALL
                              </cfif>
                                SELECT
                                    SUM(IRP.AMOUNT) AS SATIS1
                                FROM
                                    #dsn#_#period_year#_#our_company_id#.INVOICE_ROW_POS IRP,
                                    #dsn#_#period_year#_#our_company_id#.INVOICE I
                                WHERE
                                    <cfif listlen(dept_list)>
                                        I.DEPARTMENT_ID IN (#dept_list#) AND
                                    </cfif>
                                    IRP.STOCK_ID = #stock_id_# AND
                                    IRP.INVOICE_ID = I.INVOICE_ID AND
                                    I.INVOICE_DATE BETWEEN #createodbcdatetime(gun_ilk_)# AND #createodbcdatetime(gun_son_)#
                                UNION ALL
                                SELECT
                                    SUM(IRP.AMOUNT) AS SATIS1
                                FROM
                                    #dsn#_#period_year#_#our_company_id#.INVOICE_ROW IRP,
                                    #dsn#_#period_year#_#our_company_id#.INVOICE I
                                WHERE
                                    <cfif listlen(dept_list)>
                                        I.DEPARTMENT_ID IN (#dept_list#) AND
                                    </cfif>
                                    I.INVOICE_CAT = 52 AND
                                    I.PROCESS_CAT = 93 AND
                                    IRP.STOCK_ID = #stock_id_# AND
                                    IRP.INVOICE_ID = I.INVOICE_ID AND
                                    I.INVOICE_DATE >= #createodbcdatetime(gun_ilk_)# AND
                                    I.INVOICE_DATE < #dateadd('d',1,createodbcdatetime(gun_son_))#
                               UNION ALL
                                SELECT
                                    SUM(SR.STOCK_OUT - SR.STOCK_IN) AS SATIS2
                                FROM
                                    #dsn#_#period_year#_#our_company_id#.STOCKS_ROW SR
                                WHERE
                                    <cfif listlen(dept_list)>
                            			SR.STORE IN (#dept_list#) AND
                            		</cfif>
                                    SR.PROCESS_TYPE IN (-1003,-1004,-1005) AND
                                    SR.STOCK_ID = #stock_id_# AND
                                    SR.PROCESS_DATE >= #createodbcdatetime(gun_ilk_)# AND
                                    SR.PROCESS_DATE  < #dateadd('d',1,createodbcdatetime(gun_son_))#                                
                            </cfloop>
                        ) AS T1
                    </cfquery>
                    
                    <cfquery name="get_alislar" datasource="#dsn#">
                            SELECT
                                SUM(T1.NETTOTAL) ALIS_TUTARLAR,
                                SUM(T1.AMOUNT) ALISLAR
                            FROM
                                (
                                 <cfset count_ = 0>
                                 <cfloop query="get_periods">
                                 <cfset count_ = count_ + 1>
								  <cfif count_ neq 1>
                                        UNION ALL
                                  </cfif>
                                        SELECT
                                            IR.NETTOTAL,
                                            IR.AMOUNT,
                                            IC_TABLE.SHIP_DATE,
                                            I.INVOICE_DATE
                                        FROM
                                            #dsn#_#period_year#_#our_company_id#.INVOICE I,
                                            #dsn#_#period_year#_#our_company_id#.INVOICE_ROW IR
                                                LEFT JOIN
                                                    (
                                                        SELECT
                                                            S.SHIP_DATE,
                                                            SR.WRK_ROW_ID,
                                                            ISS.INVOICE_ID
                                                        FROM
                                                            #dsn#_#period_year#_#our_company_id#.INVOICE_SHIPS ISS,
                                                            #dsn#_#period_year#_#our_company_id#.SHIP S,
                                                            #dsn#_#period_year#_#our_company_id#.SHIP_ROW SR
                                                        WHERE
                                                            ISS.SHIP_ID = S.SHIP_ID AND
                                                            S.SHIP_ID = SR.SHIP_ID
                                                    ) IC_TABLE ON (IR.WRK_ROW_RELATION_ID = IC_TABLE.WRK_ROW_ID AND IC_TABLE.INVOICE_ID = IR.INVOICE_ID)
                                        WHERE
                                            <cfif listlen(dept_list)>
                                                I.DEPARTMENT_ID IN (#dept_list#) AND
                                            </cfif>
                                            I.COMPANY_ID = #COMPANY_ID_# AND
                                            IR.STOCK_ID = #stock_id_# AND
                                            I.INVOICE_ID = IR.INVOICE_ID AND
                                            ISNULL(I.IS_IPTAL,0) = 0 AND
                                            I.PROCESS_CAT NOT IN (#dahil_olmayan_tipler#) AND
                                            I.PURCHASE_SALES = 0
                                 </cfloop>
                                 ) T1
                            WHERE
                            	(
                                SHIP_DATE IS NOT NULL AND
                                SHIP_DATE <= INVOICE_DATE AND 
                                ISNULL(SHIP_DATE,INVOICE_DATE) BETWEEN #createodbcdatetime(gun_ilk_alis_)# AND #createodbcdatetime(gun_son_alis_)#
                                )
                                OR
                                (
                                SHIP_DATE > INVOICE_DATE AND 
                                INVOICE_DATE BETWEEN #createodbcdatetime(gun_ilk_alis_)# AND #createodbcdatetime(gun_son_alis_)#
                                )
                    </cfquery>
                    
                    <cfif get_satis.recordcount and len(get_satis.SATIS)>
                    	<cfset alis_ = wrk_round(NEW_ALIS,2)>
						<cfif listlen(dept_list)>
							<cfset o_gun_maliyet = wrk_round(get_daily_maliyet_dept('#dept_list#',PRODUCT_ID,STOCK_ID,year(gun_son_),MONTH(gun_son_),DAY(gun_son_)),2)>
                        <cfelse>
                        	<cfset o_gun_maliyet = wrk_round(get_daily_maliyet(PRODUCT_ID,STOCK_ID,year(gun_son_),MONTH(gun_son_),DAY(gun_son_)),2)>
                        </cfif>
                        
						<cfset fark = o_gun_maliyet - alis_>
                        
                        <cfif not len(get_alislar.ALISLAR)>
                        	<cfset alis_adedi_ = 0>
                            <cfset alis_tutari_ = 0>
                        <cfelse>
                        	<cfset alis_adedi_ = get_alislar.ALISLAR>
                            <cfset alis_tutari_ = get_alislar.ALIS_TUTARLAR>
                        </cfif>
                        
                        <cfquery name="get_dusulecek_satislar" datasource="#dsn_dev#"> 
                        	SELECT 
                            	SUM(AMOUNT) AS TOTAL
                            FROM 
                            	INVOICE_FF_ROWS WITH(NOLOCK)
                            WHERE 
                                FF_TYPE = 1 AND
                                PRODUCT_ID = #PRODUCT_ID# AND
                                STOCK_ID = #STOCK_ID# AND
                                INVOICE_DATE BETWEEN #createodbcdatetime(gun_ilk_)# AND #createodbcdatetime(gun_son_)# 
                                <!------>
                                AND
                                <cfif len(PROJECT_ID)>PROJECT_ID = #PROJECT_ID# AND</cfif>
                                COMPANY_ID = #COMPANY_ID#
								<!------>
                        </cfquery>
                        
                        <cfif get_dusulecek_satislar.recordcount and len(get_dusulecek_satislar.TOTAL)>
                        	<cfset alis_adedi_ = alis_adedi_ + get_dusulecek_satislar.TOTAL>
                        </cfif>
                        
                        <cfif get_satis.SATIS gt alis_adedi_>
                            <cfif fark gt 0>
                                <cfset miktar_fark_ = get_satis.SATIS - alis_adedi_>
                                <cfset ff_net = miktar_fark_ * fark>
                                <cfset ff_gross = o_gun_maliyet>
                                <cfset ff_base = alis_>
                                <cfset row_id_ = get_.row_id>
                                <cfset p_type_ = get_.PRICE_TYPE>
                                <cfset table_code_ = get_.table_code>
                                
                                <cfquery name="cont_" datasource="#dsn_dev#">
                                    SELECT * FROM 
                                          INVOICE_FF_ROWS WITH(NOLOCK) 
                                    WHERE
                                          FF_TYPE = 2 AND
                                          PRODUCT_ID = #PRODUCT_ID# AND
                                          STOCK_ID = #STOCK_ID# AND
                                          INVOICE_DATE = #CREATEODBCDATETIME(gun_son_)# AND
                                          <!------>
                                          COMPANY_ID = #COMPANY_ID# AND
                                          <cfif len(PROJECT_ID)>PROJECT_ID = #PROJECT_ID# AND</cfif>
										  <!------>
                                          PRICE_TYPE = #p_type_#
                                </cfquery>
                                
                                <cfif not cont_.recordcount>
                                    <cfquery name="add_" datasource="#dsn_dev#">
                                        INSERT INTO
                                            INVOICE_FF_ROWS           
                                            (
                                            PRODUCT_ID,
                                            STOCK_ID,
                                            INVOICE_DATE,
                                            AMOUNT,
                                            FF_GROSS,
                                            FF_BASE,
                                            PERIOD_ID,
                                            COMPANY_ID,
                                            PROJECT_ID,
                                            COMP_CODE,
                                            FF_NET,
                                            FF_PAID,
                                            FF_TYPE,
                                            PRICE_TYPE,
                                            TABLE_ROW_ID,
                                            TABLE_CODE,
                                            FF_DAILY_COST,
                                            FF_DAILY_NET,
                                            FF_DAILY_AMOUNT,
                                            CODE
                                            )
                                            VALUES
                                            (
                                            #PRODUCT_ID#,
                                            #STOCK_ID#,
                                            #CREATEODBCDATETIME(gun_son_)#,
                                            #get_satis.SATIS#,
                                            #ff_gross#,
                                            #ff_base#,
                                            1,
                                            #COMPANY_ID#,
                                            <cfif len(PROJECT_ID)>#PROJECT_ID#<cfelse>NULL</cfif>,
                                            '#COMP_CODE#',
                                            #ff_net#,
                                            0,
                                            2,
                                            #p_type_#,
                                            #row_id_#,
                                            '#table_code_#',
                                            #o_gun_maliyet#,
                                            #ff_net#,
                                            #miktar_fark_#,
                                            '#dateformat(now(),"dd/mm/yyyy")# MANUEL PS (2)'
                                            )
                                    </cfquery>
                               </cfif>
                            </cfif>
                       <cfelse>
                       		<!--- <font color="red">#PROPERTY# alış baskın alış : #alis_adedi_# Satış:#get_satis.SATIS#</font><br /> --->
                       </cfif>
                    <cfelse>
                    	<!--- <font color="red">#PROPERTY# satışı yok</font><br /> --->
                    </cfif> 
               </cfif>
            </cfloop>
     </cfif>
</CFOUTPUT>

<cf_medium_list_search title="Alış Satış Fiyat Farkları Aktarma"></cf_medium_list_search>
<br />
Fiyat Farkları Düzenlendi.