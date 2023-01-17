<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD WHERE PERIOD_YEAR IN (2016,2017)
</cfquery>

<cfquery name="get_price_groups_all" datasource="#DSN_DEV#">
	SELECT *
    FROM
    	PRICE_TABLE
    WHERE
    	<cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
            COMPANY_ID IN (#attributes.company_ids#) AND
        </cfif>
        FINISHDATE >= #attributes.startdate# AND
        FINISHDATE <= #attributes.finishdate# AND
        IS_ACTIVE_S = 1 AND
        STARTDATE IS NOT NULL AND
        FINISHDATE IS NOT NULL AND
        PRICE_TYPE IN (#kasa_cikislar#)
</cfquery>

<cfif get_price_groups_all.recordcount>
    <cfif isdefined("attributes.is_clear_old_rows")>
	   <cfquery name="cont_" datasource="#dsn_dev#">
            DELETE
            FROM
                INVOICE_FF_ROWS
            WHERE
                FF_TYPE = 1 AND
                TABLE_ROW_ID IN 
                (
                	SELECT ROW_ID
                    FROM
                        PRICE_TABLE
                    WHERE
                        <cfif isdefined("attributes.company_ids") and len(attributes.company_ids)>
                            COMPANY_ID IN (#attributes.company_ids#) AND
                        </cfif>
                        FINISHDATE >= #attributes.startdate# AND
                        FINISHDATE <= #attributes.finishdate# AND
                        IS_ACTIVE_S = 1 AND
                        STARTDATE IS NOT NULL AND
                        FINISHDATE IS NOT NULL AND
                        PRICE_TYPE IN (#kasa_cikislar#)
                ) AND
                INVOICE_DATE >= #attributes.startdate# AND
                INVOICE_DATE <= #attributes.finishdate# AND
                ISNULL(FF_PAID,0) = 0
        </cfquery>
    </cfif>
</cfif>

<cfquery name="get_price_groups" dbtype="query">
	SELECT DISTINCT STARTDATE,FINISHDATE FROM get_price_groups_all ORDER BY STARTDATE ASC,FINISHDATE DESC
</cfquery>

<CFOUTPUT query="get_price_groups">
	<cfset gun_ilk_ = STARTDATE>
    <cfset gun_son_ = FINISHDATE>
    <cfquery name="get_" datasource="#dsn_dev#">
    	SELECT 
        	S.STOCK_ID,
            S.PRODUCT_ID,
            S.STOCK_CODE,
            S.PROPERTY,
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
            P.COMPANY_ID,
            P.PROJECT_ID,
            CAST(P.COMPANY_ID AS NVARCHAR) + '_' + CAST(ISNULL(P.PROJECT_ID,0) AS NVARCHAR) AS COMP_CODE
       	FROM 
        	PRICE_TABLE PT,
            #DSN1_ALIAS#.STOCKS S,
            #DSN1_ALIAS#.PRODUCT P
        WHERE
            PT.PRICE_TYPE IN (#kasa_cikislar#) AND
            PT.PRODUCT_ID = S.PRODUCT_ID AND
            PT.PRODUCT_ID = P.PRODUCT_ID AND
            PT.IS_ACTIVE_S = 1 AND
            PT.STARTDATE = #createodbcdatetime(gun_ilk_)# AND
            PT.FINISHDATE = #createodbcdatetime(gun_son_)# AND
            P.COMPANY_ID IS NOT NULL
            AND
            (
            	P.COMPANY_ID = PT.COMPANY_ID
                OR
                PT.COMPANY_ID IS NULL
            )
        ORDER BY
        	PT.ROW_ID DESC
    </cfquery>
    
    <cfif get_.recordcount>
    <cfquery name="get_depts" datasource="#dsn_dev#">
    	SELECT * FROM PRICE_TABLE_DEPARTMENTS WHERE ROW_ID = #get_.ROW_ID#
    </cfquery>
    
    <cfif get_depts.recordcount>
    	<cfset dept_list = valuelist(get_depts.department_id)>
    <cfelse>
    	<cfset dept_list = ''>
    </cfif>
    
    
    <cfset toplam_gun_ = datediff('d',gun_ilk_,gun_son_)>
    <cfloop from="0" to="#toplam_gun_-1#" index="gun">
        <cfset tarihim_ = dateadd('d',gun,gun_ilk_)>
        <cfset p_list = "">
            <cfloop query="get_">
           		<cfset stock_id_ = STOCK_ID>
				<cfif not listfind(p_list,STOCK_ID)>
					<cfset p_list = listappend(p_list,stock_id)>
                    <cfset alis_ = wrk_round(NEW_ALIS,2)>
                    
                    <cfquery name="get_satis" datasource="#dsn2#">
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
                                    MONTH(I.INVOICE_DATE) = #MONTH(tarihim_)# AND
                                    DAY(I.INVOICE_DATE) = #DAY(tarihim_)#
                             UNION ALL
                                SELECT
                                    SUM(IRP.AMOUNT) AS SATIS2
                                FROM
                                    #dsn#_#period_year#_#our_company_id#.INVOICE_ROW IRP,
                                    #dsn#_#period_year#_#our_company_id#.INVOICE I
                                WHERE
                                    <cfif listlen(dept_list)>
                                    I.DEPARTMENT_ID IN (#dept_list#) AND
                                    </cfif>
                                    I.INVOICE_CAT = 52 AND
                                    IRP.STOCK_ID = #stock_id_# AND
                                    IRP.INVOICE_ID = I.INVOICE_ID AND
                                    MONTH(I.INVOICE_DATE) = #MONTH(tarihim_)# AND
                                    DAY(I.INVOICE_DATE) = #DAY(tarihim_)#
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
                                    MONTH(SR.PROCESS_DATE) = #MONTH(tarihim_)# AND
                                    DAY(SR.PROCESS_DATE) = #DAY(tarihim_)#
                        </cfloop>
                        ) T2
                    </cfquery>
                    
                    
                    <cfif get_satis.recordcount and len(get_satis.SATIS)>
                    	<cfif listfindnocase(kasa_cikislar_maliyetsiz,p_type)>
							<cfset o_gun_maliyet = wrk_round(get_daily_cost_price(PRODUCT_ID,year(tarihim_),MONTH(tarihim_),DAY(tarihim_)),2)>
                        <cfelse>
							<cfset o_gun_maliyet = wrk_round(get_daily_maliyet(PRODUCT_ID,STOCK_ID,year(tarihim_),MONTH(tarihim_),DAY(tarihim_)),2)>
                        </cfif>
						
						<cfif o_gun_maliyet gt 0>
							<cfset fark_ = o_gun_maliyet - alis_>
                        <cfelse>
                        	<cfset fark_ = 0>
                        </cfif>
                        <cfif fark_ gt 0>
                            
                            <cfquery name="cont_" datasource="#DSN_DEV#">
                            	SELECT * FROM 
                                	  INVOICE_FF_ROWS WITH(NOLOCK)
                                WHERE
                                	  PRODUCT_ID = #PRODUCT_ID# AND
                                      STOCK_ID = #STOCK_ID# AND
                                      INVOICE_DATE = #tarihim_# AND
                                      <!---
                                      COMPANY_ID = #COMPANY_ID# AND
                                      <cfif len(PROJECT_ID)>PROJECT_ID = #PROJECT_ID# AND</cfif>
									  --->
                                      FF_TYPE = 1
                            </cfquery>
                            
                            <cfif not cont_.recordcount>
                                <cfquery name="add_" datasource="#DSN_DEV#">
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
                                        CODE
                                        )
                                        VALUES
                                        (
                                        #PRODUCT_ID#,
                                        #STOCK_ID#,
                                        #tarihim_#,
                                        #get_satis.SATIS#,
                                        #get_satis.SATIS * alis_#,
                                        #get_satis.SATIS * o_gun_maliyet#,
                                        1,
                                        #COMPANY_ID#,
                                        <cfif len(PROJECT_ID)>#PROJECT_ID#<cfelse>NULL</cfif>,
                                        '#COMP_CODE#',
                                        #fark_ * get_satis.SATIS#,
                                        0,
                                        1,
                                        #P_TYPE#,
                                        #row_id#,
                                        '#TABLE_CODE#',
                                        #o_gun_maliyet#,
                                        '#dateformat(now(),"dd/mm/yyyy")# MANUEL CO (1)'
                                        )
                                </cfquery>
                           <cfelse>
                           	<!--- kayıt var --->
                           </cfif>
                        </cfif>
                    <cfelse>
                    	<!--- <font color="red">#PROPERTY# satışı yok</font><br /> --->
                    </cfif> 
               </cfif>
            </cfloop>
    </cfloop>
    </cfif>
</CFOUTPUT>

<cf_medium_list_search title="Kasa Çıkış Fiyat Farkları Aktarma"></cf_medium_list_search>
<br />
Kasa Çıkış Fiyat Farkları Düzenlendi.