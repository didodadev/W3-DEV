<cfif isdefined("attributes.aktarim_kaynak_period")>
	<cfset dsn3 = '#dsn#_#attributes.aktarim_kaynak_company#'>
	<cfset dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
	<cfset dsn3_alias = '#dsn#_#attributes.aktarim_kaynak_company#'>
	<cfset dsn2_alias = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
	<cfset kaynak_dsn3 = '#dsn#_#attributes.aktarim_kaynak_company#'>
	<cfset kaynak_dsn2 = '#dsn#_#attributes.aktarim_kaynak_year#_#attributes.aktarim_kaynak_company#'>
	<cfif isdefined('attributes.aktarim_date1') or not len(attributes.aktarim_date1)>
		<cf_date tarih='attributes.aktarim_date1'>
	</cfif>
	<cfif isdefined('attributes.aktarim_date2') or not len(attributes.aktarim_date2)>
		<cf_date tarih='attributes.aktarim_date2'>
    </cfif>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
    <div class="ui-info-text">
	<!--- silme işlemi --->
	<cfif attributes.step eq 1>
		<br/><b>1. Stok Hareketi Kapamalarının Silinmesi</b><br/><br/>
		<cfquery name="del_stock_close" datasource="#kaynak_dsn2#">
			DELETE FROM 
				STOCKS_ROW_CLOSED 
			WHERE
				1 = 1
				<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
					AND PRODUCT_ID = #attributes.aktarim_product_id#
				</cfif>
				<cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
					AND	
					(
						(
							1=1
							<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
								AND STOCKS_ROW_CLOSED.PROCESS_DATE_OUT >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
							</cfif>
							<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
								AND STOCKS_ROW_CLOSED.PROCESS_DATE_OUT <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
							</cfif>
						)
					)
				</cfif> 
		</cfquery>
		<form action="" name="form1_" id="step1" method="post">		
			<cfif isdefined("attributes.is_fifo")>
				<input type="hidden" name="is_fifo" id="is_fifo" value="1" />
			</cfif>
             <cfif isdefined("attributes.is_oto")>
        		<input type="hidden" name="is_oto" id="is_oto" value="1" />
        	</cfif>
			<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#attributes.aktarim_kaynak_period#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#attributes.aktarim_kaynak_year#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#attributes.aktarim_kaynak_company#</cfoutput>">
			<input type="hidden" name="aktarim_date1" id="aktarim_date1" value="<cfif isdate(attributes.aktarim_date1)><cfoutput>#dateformat(attributes.aktarim_date1,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_date2" id="aktarim_date2" value="<cfif isdate(attributes.aktarim_date2)><cfoutput>#dateformat(attributes.aktarim_date2,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_product_name" id="aktarim_product_name" value="<cfoutput>#attributes.aktarim_product_name#</cfoutput>">
			<input type="hidden" name="aktarim_product_id" id="aktarim_product_id" value="<cfoutput>#attributes.aktarim_product_id#</cfoutput>">
			<input type="hidden" name="session_userid" id="session_userid" value="<cfoutput>#attributes.session_userid#</cfoutput>">
			<input type="hidden" name="session_period_id" id="session_period_id" value="<cfoutput>#attributes.session_period_id#</cfoutput>">
			<input type="hidden" name="session_money" id="session_money" value="<cfoutput>#attributes.session_money#</cfoutput>">
			<input type="hidden" name="session_money2" id="session_money2" value="<cfoutput>#attributes.session_money2#</cfoutput>">
			<cfif isdefined('attributes.aktarim_is_cost_again') and len(attributes.aktarim_is_cost_again)>
            	<input type="hidden" name="aktarim_is_cost_again" id="aktarim_is_cost_again" value="<cfoutput>#attributes.aktarim_is_cost_again#</cfoutput>">
            </cfif>
			<cfif isdefined('attributes.aktarim_is_invent_again') and len(attributes.aktarim_is_invent_again)>
            	<input type="hidden" name="aktarim_is_invent_again" id="aktarim_is_invent_again" value="<cfoutput>#attributes.aktarim_is_invent_again#</cfoutput>">
            </cfif>
			<cfif isdefined('attributes.aktarim_is_date_kontrol') and len(attributes.aktarim_is_date_kontrol)>
            	<input type="hidden" name="aktarim_is_date_kontrol" id="aktarim_is_date_kontrol" value="<cfoutput>#attributes.aktarim_is_date_kontrol#</cfoutput>">
            </cfif>
			<cfif isdefined('attributes.aktarim_is_location_based_cost') and len(attributes.aktarim_is_location_based_cost)>
            	<input type="hidden" name="aktarim_is_location_based_cost" id="aktarim_is_location_based_cost" value="<cfoutput>#attributes.aktarim_is_location_based_cost#</cfoutput>">
            </cfif>
			<cf_get_lang no ='2028.Kaynak Veri Tabanı'>: <cfoutput>#attributes.aktarim_kaynak_period# (#attributes.aktarim_kaynak_year#)</cfoutput><br/>
			<br /><br />
            <cfif toplam_kayit gt son_deger>
                <input type="text" name="page" id="page" value="<cfoutput>#(attributes.page+1)#</cfoutput>">
                <input type="hidden" name="step" id="step" value="1">
                <input type="button" value="part_<cfoutput>#attributes.page#</cfoutput>" onClick="basamak_2();">
            <cfelse>
            	<input type="hidden" name="step" id="step" value="2">
                <b><font color="FF0000">Sonraki İşlem : Stok Hareketi Kapamalarının Eklenmesi</font> </b><br />
				<input type="button" value="<cf_get_lang no ='2114.Devam Et'>" onClick="basamak_2();">
            </cfif>           
		</form>
	</cfif>
	<br />
	<cfif attributes.step eq 2>
    	<cfloop from="#attributes.from_count#" to="#attributes.loop_count#" index="kk_index">
        <cfif kk_index neq attributes.loop_count>
            <cfquery name="del_stock_close" datasource="#kaynak_dsn2#">
                DELETE FROM 
                    STOCKS_ROW_CLOSED 
                WHERE
                    1 = 1
                    <cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
                        AND PRODUCT_ID = #attributes.aktarim_product_id#
                    </cfif>
                    <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
                        AND	
                        (
                            (
                                1=1
                                <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                    AND STOCKS_ROW_CLOSED.PROCESS_DATE_OUT >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                </cfif>
                                <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                    AND STOCKS_ROW_CLOSED.PROCESS_DATE_OUT <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                </cfif>
                            )
                        )
                    </cfif> 
            </cfquery>
        </cfif>
		<!--- kapama islemi --->
        <cfif kk_index eq attributes.loop_count>
		<br/><b>2. Stok Hareketi Kapamalarının Eklenmesi</b><br/><br/>
        </cfif>
        <cfloop from="1" to="2" index="prod_index"><!---Hesaplamaları iki kere yapıyoruz , ikincisinde sadece virmandan stok girişi olan ürünler çalıştırılacak--->
            <cfquery name="get_stocks_row_all" datasource="#kaynak_dsn2#">
                SELECT DISTINCT
                    SR.PRODUCT_ID,
                    S.PRODUCT_NAME,
                    S.STOCK_CODE
                    <cfif is_stock_based_cost eq 1>
                        ,SR.STOCK_ID
                    </cfif>
                    <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                        ,SR.SPECT_VAR_ID
                    </cfif>
                FROM
                    STOCKS_ROW SR,
                    #kaynak_dsn3#.STOCKS S
                WHERE
                    SR.STOCK_ID = S.STOCK_ID
                    <cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
                        AND SR.PRODUCT_ID = #attributes.aktarim_product_id#
                    </cfif>
                    <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
                        AND	
                        (
                                (
                                    1=1
                                    <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                        AND SR.PROCESS_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                    <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                        AND SR.PROCESS_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                )
                        )
                    </cfif>
                    <cfif prod_index eq 2>
                        AND SR.STOCK_ID IN
                        (
                            SELECT 
                                SE.STOCK_ID 
                            FROM 
                                STOCK_EXCHANGE SE 
                            WHERE
                                1=1
                                <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                    AND SR.PROCESS_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                </cfif>
                                <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                    AND SR.PROCESS_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                </cfif>
                        )
                        AND SR.STOCK_ID NOT IN
                        (
                            SELECT 
                                SE.EXIT_STOCK_ID 
                            FROM 
                                STOCK_EXCHANGE SE 
                            WHERE
                                1=1
                                <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                    AND SR.PROCESS_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                </cfif>
                                <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                    AND SR.PROCESS_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                </cfif>
                        )
                    </cfif>
            </cfquery>
			<cfoutput query="get_stocks_row_all">
                <cfif kk_index eq attributes.loop_count>Stok Kodu : #stock_code# Ürün : #product_name# Hesaplandı. <br></cfif>
                <cfset control_stock = 0><!---Ürün eksiye düştüğünde 1 set edilip hesaplama yapılmayacak--->
                <cfif prod_index neq 2>
                    <cfquery name="del_stock_close" datasource="#kaynak_dsn2#">
                        DELETE FROM 
                            STOCKS_ROW_CLOSED 
                        WHERE
                            PRODUCT_ID = #get_stocks_row_all.PRODUCT_ID#
                            <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
                                AND	
                                (
                                    (
                                        1=1
                                        <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                            AND STOCKS_ROW_CLOSED.PROCESS_DATE_OUT >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                        </cfif>
                                        <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                            AND STOCKS_ROW_CLOSED.PROCESS_DATE_OUT <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                        </cfif>
                                    )
                                )
                            </cfif> 
                    </cfquery>
                </cfif>
                <cfset row_product_id = get_stocks_row_all.product_id>
                <cfif is_stock_based_cost eq 1>
                    <cfset row_stock_id = get_stocks_row_all.stock_id>
                </cfif>
                <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                    <cfset row_spect_main_id = get_stocks_row_all.spect_var_id>
                </cfif>
                <!--- kapama yapıldıktan sonra açık kalan girişler tekrar tabloya yazılacak --->
                <cfquery name="delete_GET_PROD" datasource="#kaynak_dsn3#">
                    IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_STOCK_CLOSED_#session.ep.userid#')
                    DROP TABLE ####GET_STOCK_CLOSED_#session.ep.userid#
                </cfquery>
                <cfquery name="get_stocks_closed" datasource="#kaynak_dsn2#">
                    SELECT
                        SRR.*
                    INTO ####GET_STOCK_CLOSED_#session.ep.userid#
                    FROM
                        STOCKS_ROW_CLOSED SRR
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND UPD_ID_OUT IS NOT NULL
                        <cfif is_stock_based_cost eq 1>
                            AND STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SPECT_MAIN_ID = #row_spect_main_id#
                        </cfif>
                </cfquery>
                <cfquery name="delete_GET_PROD" datasource="#kaynak_dsn3#">
                    IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_STOCKS_ROW_#session.ep.userid#')
                    DROP TABLE ####GET_STOCKS_ROW_#session.ep.userid#
                </cfquery>
                <cfquery name="get_stocks_all" datasource="#kaynak_dsn2#">
                    SELECT
                        SRR.*
                    INTO ####GET_STOCKS_ROW_#session.ep.userid#
                    FROM
                        STOCKS_ROW SRR
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        <cfif is_stock_based_cost eq 1>
                            AND STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                </cfquery>
                <cfquery name="delete_GET_PROD" datasource="#kaynak_dsn3#">
                    IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_STOCK_CLOSED_#session.ep.userid#')
                    DROP TABLE ####GET_STOCK_CLOSED_#session.ep.userid#
                </cfquery>
                <cfquery name="get_stocks_closed" datasource="#kaynak_dsn2#">
                    SELECT
                        SRR.*
                    INTO ####GET_STOCK_CLOSED_#session.ep.userid#
                    FROM
                        STOCKS_ROW_CLOSED SRR
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND UPD_ID_OUT IS NOT NULL
                        <cfif is_stock_based_cost eq 1>
                            AND STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SPECT_MAIN_ID = #row_spect_main_id#
                        </cfif>
                </cfquery>
                <cfquery name="get_stocks_row" datasource="#kaynak_dsn2#">
                    <!--- çıkışlar --->
                    SELECT
                        PRODUCT_ID,
                        SUM(AMOUNT) AMOUNT,
                        SUM(CLOSED_AMOUNT) CLOSED_AMOUNT,
                        SUM(PRICE) PRICE,
                        SUM(EXTRA_COST) AS EXTRA_COST,<!--- TODO --->
                        STORE,
                        STORE_LOCATION,
                        PROCESS_DATE,
                        UPD_ID,
                        PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SPECT_VAR_ID
                        </cfif>,
                        TYPE
                    FROM
                    (
                    SELECT DISTINCT
                        SRR.PRODUCT_ID,
                        IR.AMOUNT AMOUNT,
                        ISNULL(SUM(GS.AMOUNT),0) CLOSED_AMOUNT,
                        (IR.NETTOTAL / IR.AMOUNT * (CASE I.GROSSTOTAL WHEN 0 THEN 0 ELSE (1 - (ISNULL(I.SA_DISCOUNT,0) / I.GROSSTOTAL)) END)) PRICE,
                        ISNULL(IR.EXTRA_COST,0) AS EXTRA_COST,<!--- TODO --->
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>,
                        0 AS TYPE
                    FROM
                        INVOICE I,
                        INVOICE_ROW IR,
                        STOCKS_ROW SRR
                        LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_OUT = SRR.UPD_ID AND PROCESS_TYPE_OUT = SRR.PROCESS_TYPE
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND SRR.UPD_ID = I.INVOICE_ID
                        AND SRR.PROCESS_TYPE = I.INVOICE_CAT
                        AND I.INVOICE_ID = IR.INVOICE_ID
                        AND SRR.STOCK_ID = IR.STOCK_ID
                        AND STOCK_OUT > 0
                        <cfif is_stock_based_cost eq 1>
                            AND SRR.STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                        <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
							<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                AND SRR.PROCESS_DATE >= #attributes.aktarim_date1#
                            </cfif>
                            <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                AND SRR.PROCESS_DATE <= #attributes.aktarim_date2#
                            </cfif>
                        </cfif> 
                    GROUP BY
                        SRR.PRODUCT_ID,
                        SRR.STOCK_OUT,
                        IR.NETTOTAL,
                        IR.AMOUNT,
                        I.GROSSTOTAL,
                        IR.EXTRA_COST,<!--- TODO --->
                        I.SA_DISCOUNT,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>				
                    UNION ALL
                    SELECT DISTINCT
                        SRR.PRODUCT_ID,
                        IR.AMOUNT AMOUNT,
                        ISNULL(SUM(GS.AMOUNT),0) CLOSED_AMOUNT,
                        (IR.NETTOTAL / IR.AMOUNT) PRICE,
                        ISNULL(IR.EXTRA_COST,0) AS EXTRA_COST, <!--- TODO --->
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>,
                        0 AS TYPE
                    FROM
                        SHIP I,
                        SHIP_ROW IR,
                        STOCKS_ROW SRR
                        LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_OUT = SRR.UPD_ID AND PROCESS_TYPE_OUT = SRR.PROCESS_TYPE
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND SRR.UPD_ID = I.SHIP_ID
                        AND SRR.PROCESS_TYPE = I.SHIP_TYPE
                        AND I.SHIP_ID = IR.SHIP_ID
                        AND SRR.STOCK_ID = IR.STOCK_ID
                        AND STOCK_OUT > 0
                        AND SHIP_TYPE NOT IN(81,811)
                        <cfif is_stock_based_cost eq 1>
                            AND SRR.STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                        <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
							<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                AND SRR.PROCESS_DATE >= #attributes.aktarim_date1#
                            </cfif>
                            <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                AND SRR.PROCESS_DATE <= #attributes.aktarim_date2#
                            </cfif>
                        </cfif> 
                    GROUP BY
                        SRR.PRODUCT_ID,
                        SRR.STOCK_OUT,
                        IR.NETTOTAL,
                        IR.EXTRA_COST,
                        IR.AMOUNT,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>
                    UNION ALL
                    SELECT DISTINCT
                        SRR.PRODUCT_ID,
                        IR.AMOUNT AMOUNT,
                        ISNULL(SUM(GS.AMOUNT),0) CLOSED_AMOUNT,
                        (IR.NET_TOTAL / IR.AMOUNT) PRICE,
                        ISNULL(IR.EXTRA_COST,0) AS EXTRA_COST, <!--- TODO --->
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>,
                        0 AS TYPE
                    FROM
                        STOCK_FIS I,
                        STOCK_FIS_ROW IR,
                        STOCKS_ROW SRR
                        LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_OUT = SRR.UPD_ID AND PROCESS_TYPE_OUT = SRR.PROCESS_TYPE
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND SRR.UPD_ID = I.FIS_ID
                        AND SRR.PROCESS_TYPE = I.FIS_TYPE
                        AND I.FIS_ID = IR.FIS_ID
                        AND SRR.STOCK_ID = IR.STOCK_ID
                        AND STOCK_OUT > 0
                        <cfif is_stock_based_cost eq 1>
                            AND SRR.STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                        <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
							<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                AND SRR.PROCESS_DATE >= #attributes.aktarim_date1#
                            </cfif>
                            <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                AND SRR.PROCESS_DATE <= #attributes.aktarim_date2#
                            </cfif>
                        </cfif> 
                    GROUP BY
                        SRR.PRODUCT_ID,
                        SRR.STOCK_OUT,
                        IR.NET_TOTAL,
                        IR.EXTRA_COST,
                        IR.AMOUNT,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>
                    UNION ALL
                    SELECT DISTINCT
                        SRR.PRODUCT_ID,
                        SRR.STOCK_OUT AMOUNT,
                        ISNULL(SUM(GS.AMOUNT),0) CLOSED_AMOUNT,
                        0 PRICE,
                        0 EXTRA_COST,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>,
                        0 AS TYPE
                    FROM
                        STOCK_EXCHANGE IR,
                        STOCKS_ROW SRR
                        LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_IN = SRR.UPD_ID AND PROCESS_TYPE_IN = SRR.PROCESS_TYPE
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND SRR.UPD_ID = IR.STOCK_EXCHANGE_ID
                        AND SRR.PROCESS_TYPE = IR.PROCESS_TYPE
                        AND SRR.STOCK_ID = IR.EXIT_STOCK_ID
                        AND STOCK_OUT > 0
                        <cfif is_stock_based_cost eq 1>
                            AND SRR.STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                        <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
							<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                AND SRR.PROCESS_DATE >= #attributes.aktarim_date1#
                            </cfif>
                            <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                AND SRR.PROCESS_DATE <= #attributes.aktarim_date2#
                            </cfif>
                        </cfif>
                    GROUP BY
                        SRR.PRODUCT_ID,
                        SRR.STOCK_OUT,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>
                    <!--- girişler --->

                    UNION ALL
                    SELECT DISTINCT
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN AMOUNT,
                        ISNULL(SUM(GS.AMOUNT),0) CLOSED_AMOUNT,
                        (IR.NETTOTAL / IR.AMOUNT * (CASE I.GROSSTOTAL WHEN 0 THEN 0 ELSE (1 - (ISNULL(I.SA_DISCOUNT,0) / I.GROSSTOTAL)) END)) PRICE,
                        ISNULL(IR.EXTRA_COST,0) AS EXTRA_COST, <!--- TODO --->
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>,
                        1 AS TYPE
                    FROM
                        INVOICE I,
                        INVOICE_ROW IR,
                        STOCKS_ROW SRR
                        LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_IN = SRR.UPD_ID AND PROCESS_TYPE_IN = SRR.PROCESS_TYPE
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND SRR.UPD_ID = I.INVOICE_ID
                        AND SRR.PROCESS_TYPE = I.INVOICE_CAT
                        AND I.INVOICE_ID = IR.INVOICE_ID
                        AND SRR.STOCK_ID = IR.STOCK_ID
                        AND STOCK_IN > 0
                        <cfif is_stock_based_cost eq 1>
                            AND SRR.STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                        <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
							<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                AND SRR.PROCESS_DATE <= #attributes.aktarim_date2#
                            </cfif>
                        </cfif> 
                    GROUP BY
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN,
                        IR.NETTOTAL,
                        IR.AMOUNT,
                        I.GROSSTOTAL,
                        IR.EXTRA_COST, <!--- TODO --->
                        I.SA_DISCOUNT,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>	
                    HAVING
                    	ISNULL(SUM(GS.AMOUNT),0) <> SRR.STOCK_IN			
                    UNION ALL
                    SELECT DISTINCT
                        PRODUCT_ID,
                        AMOUNT,
                        ISNULL(SUM(CLOSED_AMOUNT),0) CLOSED_AMOUNT,
                        ISNULL(SUM(NETTOTAL)/SUM(I_AMOUNT),0) PRICE,
                        ISNULL(SUM(EXTRA_COST),0) EXTRA_COST,
                        STORE,
                        STORE_LOCATION,
                        PROCESS_DATE,
                        UPD_ID,
                        PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SPECT_VAR_ID
                        </cfif>,
                        TYPE
                    FROM
                    (
                        SELECT
                            SRR.PRODUCT_ID,
                            SRR.STOCK_IN AMOUNT,
                            GS.AMOUNT CLOSED_AMOUNT,
                            --ISNULL((IRR.NETTOTAL / IRR.AMOUNT * (CASE II.GROSSTOTAL WHEN 0 THEN 0 ELSE (1 - (ISNULL(II.SA_DISCOUNT,0) / II.GROSSTOTAL)) END)) , (IR.NETTOTAL / IR.AMOUNT)) PRICE,
                            ISNULL((IRR.NETTOTAL * (CASE II.GROSSTOTAL WHEN 0 THEN 0 ELSE (1 - (ISNULL(II.SA_DISCOUNT,0) / II.GROSSTOTAL)) END)) , (IR.NETTOTAL )) NETTOTAL,
							ISNULL((IRR.AMOUNT) , (IR.AMOUNT)) I_AMOUNT,
                            CASE WHEN IR.EXTRA_COST IS NOT NULL THEN ISNULL(IR.EXTRA_COST,0) ELSE ISNULL(IRR.EXTRA_COST,0) END AS EXTRA_COST,<!--- TODO --->
                            SRR.STORE,
                            SRR.STORE_LOCATION,
                            SRR.PROCESS_DATE,
                            SRR.UPD_ID,
                            SRR.PROCESS_TYPE
                            <cfif is_stock_based_cost eq 1>
                                ,SRR.STOCK_ID
                            </cfif>
                            <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                                ,SRR.SPECT_VAR_ID
                            </cfif>,
                            1 AS TYPE
                        FROM
                            SHIP I,
                            SHIP_ROW IR
                            LEFT JOIN INVOICE_ROW IRR ON IR.WRK_ROW_RELATION_ID = IRR.WRK_ROW_ID
                            LEFT JOIN INVOICE II ON II.INVOICE_ID = IRR.INVOICE_ID,
                            STOCKS_ROW SRR
                            LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_IN = SRR.UPD_ID AND PROCESS_TYPE_IN = SRR.PROCESS_TYPE
                        WHERE
                            SRR.PRODUCT_ID = #row_product_id#
                            AND SRR.UPD_ID = I.SHIP_ID
                            AND SRR.PROCESS_TYPE = I.SHIP_TYPE
                            AND I.SHIP_ID = IR.SHIP_ID
                            AND SRR.STOCK_ID = IR.STOCK_ID
                            AND STOCK_IN > 0
                            AND SHIP_TYPE NOT IN(81,811)
                            <cfif is_stock_based_cost eq 1>
                                AND SRR.STOCK_ID = #row_stock_id#
                            </cfif>
                            <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                                AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                            </cfif>
                            <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
								<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                    AND SRR.PROCESS_DATE <= #attributes.aktarim_date2#
                                </cfif>
                            </cfif> 
                    )T2
                    GROUP BY
                        PRODUCT_ID,
                        AMOUNT,
                        STORE,
                        STORE_LOCATION,
                        PROCESS_DATE,
                        UPD_ID,
                        PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SPECT_VAR_ID
                        </cfif>,
                        TYPE
                    HAVING
                    	ISNULL(SUM(CLOSED_AMOUNT),0) <> AMOUNT   
                    UNION ALL
                    SELECT
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN AMOUNT,
                        ISNULL(SUM(GS.AMOUNT),0) CLOSED_AMOUNT,
                        (IR.COST_PRICE) PRICE,
                        ISNULL(IR.EXTRA_COST,0) AS EXTRA_COST, <!--- TODO --->
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>,
                        1 AS TYPE
                    FROM
                        STOCK_FIS I,
                        STOCK_FIS_ROW IR,
                        STOCKS_ROW SRR
                        LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_IN = SRR.UPD_ID AND PROCESS_TYPE_IN = SRR.PROCESS_TYPE
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND SRR.UPD_ID = I.FIS_ID
                        AND SRR.PROCESS_TYPE = I.FIS_TYPE
                        AND I.FIS_ID = IR.FIS_ID
                        AND SRR.STOCK_ID = IR.STOCK_ID
                        AND STOCK_IN > 0
                        <cfif is_stock_based_cost eq 1>
                            AND SRR.STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                        <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
							<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                AND SRR.PROCESS_DATE <= #attributes.aktarim_date2#
                            </cfif>
                        </cfif> 
                    GROUP BY
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN,
                        IR.COST_PRICE,
                        IR.EXTRA_COST,
                        IR.AMOUNT,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>
                    HAVING
                    	ISNULL(SUM(GS.AMOUNT),0) <> SRR.STOCK_IN
                    UNION ALL
                    SELECT
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN AMOUNT,
                        ISNULL(SUM(GS.AMOUNT),0) CLOSED_AMOUNT,
                        ISNULL((
                             SELECT
                                SUM(COST_PRICE*AMOUNT)/SUM(IR.AMOUNT)
                            FROM 
                                #dsn2_alias#.STOCKS_ROW_CLOSED WITH (NOLOCK)
                            WHERE 
                                PRODUCT_ID = IR.EXIT_PRODUCT_ID
                                AND UPD_ID_OUT = SRR.UPD_ID
                                AND PROCESS_TYPE_OUT = SRR.PROCESS_TYPE
                        ),0) PRICE,
                        ISNULL((
                             SELECT
                                SUM(COST_EXTRA_PRICE*AMOUNT)/SUM(IR.AMOUNT)
                            FROM 
                                #dsn2_alias#.STOCKS_ROW_CLOSED WITH (NOLOCK)
                            WHERE 
                                PRODUCT_ID = IR.EXIT_PRODUCT_ID
                                AND UPD_ID_OUT = SRR.UPD_ID
                                AND PROCESS_TYPE_OUT = SRR.PROCESS_TYPE
                        ),0) EXTRA_COST,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>,
                        1 AS TYPE
                    FROM
                        STOCK_EXCHANGE IR,
                        STOCKS_ROW SRR
                        LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_IN = SRR.UPD_ID AND PROCESS_TYPE_IN = SRR.PROCESS_TYPE
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND SRR.UPD_ID = IR.STOCK_EXCHANGE_ID
                        AND SRR.PROCESS_TYPE = IR.PROCESS_TYPE
                        AND SRR.STOCK_ID = IR.STOCK_ID
                        AND STOCK_IN > 0
                        <cfif is_stock_based_cost eq 1>
                            AND SRR.STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                        <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
							<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                AND SRR.PROCESS_DATE <= #attributes.aktarim_date2#
                            </cfif>
                        </cfif>
                    GROUP BY
                        IR.AMOUNT,
                        IR.EXIT_AMOUNT,
                        IR.EXIT_PRODUCT_ID,
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>
                    HAVING
                    	ISNULL(SUM(GS.AMOUNT),0) <> SRR.STOCK_IN
                    )T1
                    GROUP BY
                        PRODUCT_ID,
                        STORE,
                        STORE_LOCATION,
                        PROCESS_DATE,
                        UPD_ID,
                        PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SPECT_VAR_ID
                        </cfif>,
                        TYPE	
                </cfquery>
                <!---<cfdump var="#get_stocks_row#"><br />--->
                <cfquery name="get_stock_exchange_in" dbtype="query">
                    SELECT * FROM get_stocks_row WHERE PROCESS_TYPE = 116 AND TYPE = 1
                </cfquery>
                <cfquery name="get_stock_exchange_out" dbtype="query">
                    SELECT * FROM get_stocks_row WHERE PROCESS_TYPE = 116 AND TYPE = 0
                </cfquery>
                <cfif kk_index eq attributes.loop_count and get_stock_exchange_in.recordcount and get_stock_exchange_out.recordcount>
                    <font color="##FF0000">Stok Kodu : #stock_code# Ürün : #product_name# İlgili Ürün Stok Virman Belgelerinde Giriş ve Stok Belge olarak kullanıldığı için kapama işlemi yapılamamıştır.</font><br />
                <cfelse>     
                <cfquery name="get_stocks_row_in" dbtype="query">
                    SELECT
                        *
                    FROM
                        get_stocks_row
                    WHERE
                        AMOUNT - CLOSED_AMOUNT > 0
                        AND TYPE = 1
                    ORDER BY
                        PROCESS_DATE
                </cfquery>
                <cfquery name="get_stocks_row_out" dbtype="query">
                    SELECT
                        *
                    FROM
                        get_stocks_row
                    WHERE
                        AMOUNT - CLOSED_AMOUNT > 0
                        AND TYPE = 0
                    ORDER BY
                        PROCESS_DATE
                </cfquery>
                <cfset used_price = 0>
                <cfloop query="get_stocks_row_out">
                    <cfif control_stock eq 0>
                        <cfquery name="get_last_stock" datasource="#kaynak_dsn2#">
                            SELECT SUM(STOCK_IN-STOCK_OUT) LAST_STOCK FROM ####GET_STOCKS_ROW_#session.ep.userid# WHERE PROCESS_DATE <= #createodbcdatetime(get_stocks_row_out.process_date)#
                        </cfquery>
                        <cfif len(get_last_stock.last_stock) and get_last_stock.last_stock gte 0>
							<cfif len(get_last_stock.last_stock)><cfset last_stock_ = get_last_stock.last_stock><cfelse><cfset last_stock_ = 0></cfif>
                            <cfif not isdefined("closed_amount_#prod_index#_#kk_index#_#get_stocks_row_out.product_id#_#get_stocks_row_out.upd_id#_#get_stocks_row_out.process_type#")>
                                <cfset kalan_miktar = get_stocks_row_out.amount - get_stocks_row_out.closed_amount>
                            <cfelseif len(get_stocks_row_in.closed_amount) and len(get_stocks_row_in.amount)>
                                <cfset kalan_miktar = (get_stocks_row_in.amount - get_stocks_row_in.closed_amount)-evaluate("closed_amount_#prod_index#_#kk_index#_#get_stocks_row_out.product_id#_#get_stocks_row_out.upd_id#_#get_stocks_row_out.process_type#")>
                            <cfelse>
                                <cfset kalan_miktar = 0>
                            </cfif>
                            <cfquery name="get_stocks_row_in_row" dbtype="query">
                                SELECT * FROM get_stocks_row_in WHERE PROCESS_DATE <=#createodbcdatetime(get_stocks_row_out.process_date)#
                            </cfquery>
                            <cfloop query="get_stocks_row_in_row">
                                <cfquery name="control_row" datasource="#kaynak_dsn2#">
                                    SELECT LAST_TOTAL_PRICE,LAST_COST_PRICE FROM STOCKS_ROW_CLOSED GS WHERE GS.PRODUCT_ID = #get_stocks_row_in_row.product_id# AND UPD_ID_IN=#get_stocks_row_in_row.UPD_ID# AND PROCESS_TYPE_IN=#get_stocks_row_in_row.PROCESS_TYPE# ORDER BY PROCESS_DATE_OUT DESC
                                </cfquery>
                                <cfif control_row.recordcount eq 0>
                                    <cfquery name="get_row_closed" datasource="#kaynak_dsn2#">
                                        SELECT LAST_TOTAL_PRICE,LAST_TOTAL_AMOUNT FROM STOCKS_ROW_CLOSED GS WHERE GS.PRODUCT_ID = #get_stocks_row_in_row.product_id# AND PROCESS_DATE_OUT <= #createodbcdatetime(get_stocks_row_in_row.process_date)# ORDER BY PROCESS_DATE_OUT DESC,STOCKS_ROW_CLOSED_ID DESC
                                    </cfquery>
                                    <cfset kalan_row = (get_stocks_row_in_row.amount - get_stocks_row_in_row.closed_amount)>
                                    <cfset row_price = get_stocks_row_in_row.price>
                                    <cfset row_extra_price = get_stocks_row_in_row.extra_cost><!--- TODO --->
                                    <cfif kalan_row gt 0>
                                        <cfquery name="add_stock_closed" datasource="#kaynak_dsn2#">
                                            INSERT INTO
                                                STOCKS_ROW_CLOSED
                                            (
                                                PRODUCT_ID,
                                                <cfif is_stock_based_cost eq 1>
                                                    STOCK_ID,
                                                </cfif>
                                                <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                                                    SPECT_MAIN_ID,
                                                </cfif>
                                                AMOUNT,
                                                COST_PRICE,
                                                MONEY_TYPE,
                                                COST_EXTRA_PRICE, <!--- TODO --->
                                                STORE,
                                                STORE_LOCATION,
                                                UPD_ID_IN,
                                                PROCESS_TYPE_IN,
                                                PROCESS_DATE_IN,
                                                PROCESS_DATE_OUT,
                                                LAST_TOTAL_AMOUNT,
                                                LAST_COST_PRICE,
                                                LAST_TOTAL_PRICE,
                                                RECORD_DATE,
                                                RECORD_IP,
                                                RECORD_EMP
                                            )
                                            VALUES
                                            (
                                                #get_stocks_row_in_row.product_id#,
                                                <cfif is_stock_based_cost eq 1>
                                                    #get_stocks_row_in_row.stock_id#,
                                                </cfif>
                                                <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                                                    #get_stocks_row_in_row.spect_var_id#,
                                                </cfif>
                                                #kalan_row#,
                                                #row_price#,
                                                '#session.ep.money#',
                                                #row_extra_price#,
                                                #get_stocks_row_in_row.store#,
                                                #get_stocks_row_in_row.store_location#,
                                                #get_stocks_row_in_row.upd_id#,
                                                #get_stocks_row_in_row.process_type#,
                                                #createodbcdatetime(get_stocks_row_in_row.process_date)#,
                                                #createodbcdatetime(get_stocks_row_in_row.process_date)#,
                                                <cfif get_row_closed.recordcount>
                                                    <cfif get_row_closed.LAST_TOTAL_AMOUNT+kalan_row gt 0>
                                                        #get_row_closed.LAST_TOTAL_AMOUNT+kalan_row#,
                                                        #wrk_round((row_price*get_stocks_row_in_row.amount+get_row_closed.last_total_price)/(get_row_closed.LAST_TOTAL_AMOUNT+kalan_row),8)#,
                                                        #wrk_round((row_price*get_stocks_row_in_row.amount+get_row_closed.last_total_price),2)#,
                                                    <cfelse>
                                                        0,
                                                        0,
                                                        0,
                                                    </cfif>
                                                <cfelse>
                                                    <cfif last_stock_ gt 0>
                                                        #kalan_row#	,
                                                        #wrk_round((row_price*get_stocks_row_in_row.amount)/kalan_row,8)#,
                                                        #wrk_round((row_price*get_stocks_row_in_row.amount),2)#,
                                                    <cfelse>
                                                        0,
                                                        0,
                                                        0,
                                                    </cfif>
                                                </cfif>
                                                #now()#,
                                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                            )
                                        </cfquery>
                                    </cfif>
                                </cfif>
                            </cfloop>
                            <cfif kalan_miktar gt 0>
                                <cfloop query="get_stocks_row_in">
                                    <cfquery name="get_row_closed" datasource="#kaynak_dsn2#" maxrows="1">
                                        SELECT LAST_TOTAL_PRICE,LAST_TOTAL_AMOUNT FROM STOCKS_ROW_CLOSED GS WHERE GS.PRODUCT_ID = #get_stocks_row_out.product_id# AND PROCESS_DATE_OUT < =#createodbcdatetime(get_stocks_row_out.process_date)# ORDER BY PROCESS_DATE_OUT DESC,STOCKS_ROW_CLOSED_ID DESC
                                    </cfquery>
                                    <cfif not isdefined("used_amount_#prod_index#_#kk_index#_#get_stocks_row_in.product_id#_#get_stocks_row_in.upd_id#_#get_stocks_row_in.process_type#")>
                                        <cfset kalan_row = (get_stocks_row_in.amount - get_stocks_row_in.closed_amount)>
                                    <cfelse>
                                        <cfset kalan_row = (get_stocks_row_in.amount - get_stocks_row_in.closed_amount)-evaluate("used_amount_#prod_index#_#kk_index#_#get_stocks_row_in.product_id#_#get_stocks_row_in.upd_id#_#get_stocks_row_in.process_type#")>
                                    </cfif>
                                    <cfif kalan_row gt 0>
                                        <cfif kalan_miktar gte kalan_row>
                                            <cfset kalan_miktar = kalan_miktar - kalan_row>
                                            <cfset row_amount = kalan_row>
                                        <cfelse>
                                            <cfset row_amount = kalan_miktar>
                                            <cfset kalan_miktar = 0>
                                        </cfif>
                                        <cfif row_amount gt 0>
                                            <cfif not isdefined("used_amount_#prod_index#_#kk_index#_#get_stocks_row_in.product_id#_#get_stocks_row_in.upd_id#_#get_stocks_row_in.process_type#")>
                                                <cfset "used_amount_#prod_index#_#kk_index#_#get_stocks_row_in.product_id#_#get_stocks_row_in.upd_id#_#get_stocks_row_in.process_type#" = row_amount>
                                            <cfelse>
                                                <cfset "used_amount_#prod_index#_#kk_index#_#get_stocks_row_in.product_id#_#get_stocks_row_in.upd_id#_#get_stocks_row_in.process_type#" = evaluate("used_amount_#prod_index#_#kk_index#_#get_stocks_row_in.product_id#_#get_stocks_row_in.upd_id#_#get_stocks_row_in.process_type#")+row_amount>
                                            </cfif>
                                            <cfif not isdefined("closed_amount_#prod_index#_#kk_index#_#get_stocks_row_out.product_id#_#get_stocks_row_out.upd_id#_#get_stocks_row_out.process_type#")>
                                                <cfset "closed_amount_#prod_index#_#kk_index#_#get_stocks_row_out.product_id#_#get_stocks_row_out.upd_id#_#get_stocks_row_out.process_type#" = row_amount>
                                            <cfelse>
                                                <cfset "closed_amount_#prod_index#_#kk_index#_#get_stocks_row_out.product_id#_#get_stocks_row_out.upd_id#_#get_stocks_row_out.process_type#" = evaluate("closed_amount_#prod_index#_#kk_index#_#get_stocks_row_out.product_id#_#get_stocks_row_out.upd_id#_#get_stocks_row_out.process_type#")+row_amount>
                                            </cfif>
                                            <cfset row_price = get_stocks_row_in.price>
                                            <cfset row_extra_price = get_stocks_row_in.extra_cost>
                                            <cfset used_price = used_price + row_price*row_amount>
                                            <cfif kk_index eq attributes.loop_count and (createodbcdatetime(get_stocks_row_in.process_date) gt createodbcdatetime(get_stocks_row_out.process_date))>
                                                <cfset control_stock = 1>
                                                <font color="##FF0000">Stok Kodu : #get_stocks_row_all.stock_code# Ürün : #get_stocks_row_all.product_name# #dateformat(get_stocks_row_out.process_date,dateformat_style)# Tarihinde Negatif Stok Oluştuğu İçin Hesaplama Yapılmamaktadır.</font><br />
                                            <cfelse>	
                                                <cfquery name="add_stock_closed" datasource="#kaynak_dsn2#">
                                                    INSERT INTO
                                                        STOCKS_ROW_CLOSED
                                                    (
                                                        PRODUCT_ID,
                                                        <cfif is_stock_based_cost eq 1>
                                                            STOCK_ID,
                                                        </cfif>
                                                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                                                            SPECT_MAIN_ID,
                                                        </cfif>
                                                        AMOUNT,
                                                        COST_PRICE,
                                                        MONEY_TYPE,
                                                        COST_EXTRA_PRICE,
                                                        STORE,
                                                        STORE_LOCATION,
                                                        UPD_ID_IN,
                                                        PROCESS_TYPE_IN,
                                                        PROCESS_DATE_IN,
                                                        UPD_ID_OUT,
                                                        PROCESS_TYPE_OUT,
                                                        PROCESS_DATE_OUT,
                                                        LAST_TOTAL_AMOUNT,
                                                        LAST_COST_PRICE,
                                                        LAST_TOTAL_PRICE,
                                                        RECORD_DATE,
                                                        RECORD_IP,
                                                        RECORD_EMP
                                                    )
                                                    VALUES
                                                    (
                                                        #get_stocks_row_out.product_id#,
                                                        <cfif is_stock_based_cost eq 1>
                                                            #get_stocks_row_out.stock_id#,
                                                        </cfif>
                                                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                                                            #get_stocks_row_out.spect_var_id#,
                                                        </cfif>
                                                        #row_amount#,
                                                        #row_price#,
                                                        '#session.ep.money#',
                                                        #row_extra_price#,
                                                        #get_stocks_row_in.store#,
                                                        #get_stocks_row_in.store_location#,
                                                        #get_stocks_row_in.upd_id#,
                                                        #get_stocks_row_in.process_type#,
                                                        #createodbcdatetime(get_stocks_row_in.process_date)#,
                                                        #get_stocks_row_out.upd_id#,
                                                        #get_stocks_row_out.process_type#,
                                                        #createodbcdatetime(get_stocks_row_out.process_date)#,
                                                        <cfif get_row_closed.recordcount and get_row_closed.LAST_TOTAL_AMOUNT-row_amount gt 0>
                                                            #get_row_closed.LAST_TOTAL_AMOUNT-row_amount#,
                                                            #wrk_round((get_row_closed.last_total_price-row_amount*row_price)/(get_row_closed.LAST_TOTAL_AMOUNT-row_amount),8)#,
                                                            #wrk_round((get_row_closed.last_total_price-row_amount*row_price),2)#,
                                                        <cfelse>
                                                            0,
                                                            0,
                                                            0,	
                                                        </cfif>
                                                        #now()#,
                                                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                                                    )
                                                </cfquery>
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </cfloop>
                            <cfelse>
                                <cfset control_stock = 1>
                                <cfif kk_index eq attributes.loop_count>
                                <font color="##FF0000">Stok Kodu : #get_stocks_row_all.stock_code# Ürün : #get_stocks_row_all.product_name# #dateformat(get_stocks_row_out.process_date,dateformat_style)# Tarihinde Negatif Stok Oluştuğu İçin Hesaplama Yapılmamaktadır.</font><br />
                            	</cfif>
                            </cfif>
                        <cfelse>
                        	<cfset control_stock = 1>
                            <cfif kk_index eq attributes.loop_count>
                            <font color="##FF0000">Stok Kodu : #get_stocks_row_all.stock_code# Ürün : #get_stocks_row_all.product_name# #dateformat(get_stocks_row_out.process_date,dateformat_style)# Tarihinde Negatif Stok Oluştuğu İçin Hesaplama Yapılmamaktadır.</font><br />
                        	</cfif>
                        </cfif>
                    </cfif>
                </cfloop>
                
                <!--- kapama yapıldıktan sonra açık kalan girişler tekrar tabloya yazılacak  --->
                <cfquery name="delete_GET_PROD" datasource="#kaynak_dsn3#">
                    IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_STOCK_CLOSED_#session.ep.userid#')
                    DROP TABLE ####GET_STOCK_CLOSED_#session.ep.userid#
                </cfquery>
                <cfquery name="get_stocks_closed" datasource="#kaynak_dsn2#">
                    SELECT
                        SRR.*
                    INTO ####GET_STOCK_CLOSED_#session.ep.userid#
                    FROM
                        STOCKS_ROW_CLOSED SRR
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND UPD_ID_OUT IS NOT NULL
                        <cfif is_stock_based_cost eq 1>
                            AND STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SPECT_MAIN_ID = #row_spect_main_id#
                        </cfif>
                </cfquery>
                <cfquery name="get_stocks_row_in" datasource="#kaynak_dsn2#">
                    SELECT
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN AMOUNT,
                        ISNULL(SUM(GS.AMOUNT),0) CLOSED_AMOUNT,
                        (IR.NETTOTAL / IR.AMOUNT * (CASE I.GROSSTOTAL WHEN 0 THEN 0 ELSE (1 - (ISNULL(I.SA_DISCOUNT,0) / I.GROSSTOTAL)) END)) PRICE,
                        ISNULL(IR.EXTRA_COST,0) AS EXTRA_COST,<!--- TODO --->
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID

                        </cfif>,
                        1 AS TYPE
                    FROM
                        INVOICE I,
                        INVOICE_ROW IR,
                        STOCKS_ROW SRR
                        LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_IN = SRR.UPD_ID AND PROCESS_TYPE_IN = SRR.PROCESS_TYPE
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND SRR.UPD_ID = I.INVOICE_ID
                        AND SRR.PROCESS_TYPE = I.INVOICE_CAT
                        AND I.INVOICE_ID = IR.INVOICE_ID
                        AND SRR.STOCK_ID = IR.STOCK_ID
                        AND STOCK_IN > 0
                        <cfif is_stock_based_cost eq 1>
                            AND SRR.STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                        <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
							<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                AND SRR.PROCESS_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                            </cfif>
                            <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                AND SRR.PROCESS_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                            </cfif>
                        </cfif> 
                    GROUP BY
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN,
                        IR.NETTOTAL,
                        IR.AMOUNT,
                        I.GROSSTOTAL,
                        IR.EXTRA_COST,<!--- TODO --->
                        I.SA_DISCOUNT,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>				
                    UNION ALL
                    SELECT
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN AMOUNT,
                        ISNULL(SUM(GS.AMOUNT),0) CLOSED_AMOUNT,
                        (IR.NETTOTAL / IR.AMOUNT) PRICE,
                        ISNULL(IR.EXTRA_COST,0) AS EXTRA_COST,<!--- TODO --->
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>,
                        1 AS TYPE
                    FROM
                        SHIP I,
                        SHIP_ROW IR,
                        STOCKS_ROW SRR
                        LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_IN = SRR.UPD_ID AND PROCESS_TYPE_IN = SRR.PROCESS_TYPE
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND SRR.UPD_ID = I.SHIP_ID
                        AND SRR.PROCESS_TYPE = I.SHIP_TYPE
                        AND I.SHIP_ID = IR.SHIP_ID
                        AND SRR.STOCK_ID = IR.STOCK_ID
                        AND STOCK_IN > 0
                        AND SHIP_TYPE NOT IN(81,811)
                        <cfif is_stock_based_cost eq 1>
                            AND SRR.STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                        <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
							<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                AND SRR.PROCESS_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                            </cfif>
                            <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                AND SRR.PROCESS_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                            </cfif>
                        </cfif> 
                    GROUP BY
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN,
                        IR.NETTOTAL,
                        IR.AMOUNT,
                        IR.EXTRA_COST,<!--- TODO --->
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>
                    UNION ALL
                    SELECT
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN AMOUNT,
                        ISNULL(SUM(GS.AMOUNT),0) CLOSED_AMOUNT,
                        (IR.COST_PRICE) PRICE,
                        ISNULL(IR.EXTRA_COST,0) AS EXTRA_COST,<!--- TODO --->
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>,
                        1 AS TYPE
                    FROM
                        STOCK_FIS I,
                        STOCK_FIS_ROW IR,
                        STOCKS_ROW SRR
                        LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_IN = SRR.UPD_ID AND PROCESS_TYPE_IN = SRR.PROCESS_TYPE
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND SRR.UPD_ID = I.FIS_ID
                        AND SRR.PROCESS_TYPE = I.FIS_TYPE
                        AND I.FIS_ID = IR.FIS_ID
                        AND SRR.STOCK_ID = IR.STOCK_ID
                        AND STOCK_IN > 0
                        <cfif is_stock_based_cost eq 1>
                            AND SRR.STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                        <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
							<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                AND SRR.PROCESS_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                            </cfif>
                            <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                AND SRR.PROCESS_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                            </cfif>
                        </cfif> 
                    GROUP BY
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN,
                        IR.COST_PRICE,
                        IR.EXTRA_COST,<!--- TODO --->
                        IR.AMOUNT,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>
                    UNION ALL
                    SELECT
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN AMOUNT,
                        ISNULL(SUM(GS.AMOUNT),0) CLOSED_AMOUNT,
                        ISNULL((
                             SELECT
                                SUM(COST_PRICE*AMOUNT)/SUM(IR.AMOUNT)
                            FROM 
                                #dsn2_alias#.STOCKS_ROW_CLOSED WITH (NOLOCK)
                            WHERE 
                                PRODUCT_ID = IR.EXIT_PRODUCT_ID
                                AND UPD_ID_OUT = SRR.UPD_ID
                                AND PROCESS_TYPE_OUT = SRR.PROCESS_TYPE
                        ),0) PRICE,
                        ISNULL((
                             SELECT
                                SUM(COST_EXTRA_PRICE*AMOUNT)/SUM(IR.AMOUNT)
                            FROM 
                                #dsn2_alias#.STOCKS_ROW_CLOSED WITH (NOLOCK)
                            WHERE 
                                PRODUCT_ID = IR.EXIT_PRODUCT_ID
                                AND UPD_ID_OUT = SRR.UPD_ID
                                AND PROCESS_TYPE_OUT = SRR.PROCESS_TYPE
                        ),0) EXTRA_COST, <!---TODO --->
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>,
                        1 AS TYPE
                    FROM
                        STOCK_EXCHANGE IR,
                        STOCKS_ROW SRR
                        LEFT JOIN ####GET_STOCK_CLOSED_#session.ep.userid# GS ON UPD_ID_IN = SRR.UPD_ID AND PROCESS_TYPE_IN = SRR.PROCESS_TYPE
                    WHERE
                        SRR.PRODUCT_ID = #row_product_id#
                        AND SRR.UPD_ID = IR.STOCK_EXCHANGE_ID
                        AND SRR.PROCESS_TYPE = IR.PROCESS_TYPE
                        AND SRR.STOCK_ID = IR.STOCK_ID
                        AND STOCK_IN > 0
                        <cfif is_stock_based_cost eq 1>
                            AND SRR.STOCK_ID = #row_stock_id#
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            AND SRR.SPECT_VAR_ID = #row_spect_main_id#
                        </cfif>
                        <cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
                            AND	
                            (
                                (
                                    1=1
                                    <cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
                                        AND SRR.PROCESS_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                    <cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
                                        AND SRR.PROCESS_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
                                    </cfif>
                                )
                            )
                        </cfif>
                    GROUP BY
                        IR.AMOUNT,
                        IR.EXIT_PRODUCT_ID,
                        SRR.PRODUCT_ID,
                        SRR.STOCK_IN,
                        SRR.STORE,
                        SRR.STORE_LOCATION,
                        SRR.PROCESS_DATE,
                        SRR.UPD_ID,
                        SRR.PROCESS_TYPE
                        <cfif is_stock_based_cost eq 1>
                            ,SRR.STOCK_ID
                        </cfif>
                        <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                            ,SRR.SPECT_VAR_ID
                        </cfif>		
                </cfquery>	
                <cfloop query="get_stocks_row_in">
                    <cfquery name="get_row_closed" datasource="#kaynak_dsn2#">
                        SELECT LAST_COST_PRICE,LAST_TOTAL_PRICE,LAST_TOTAL_AMOUNT FROM STOCKS_ROW_CLOSED GS WHERE GS.PRODUCT_ID = #get_stocks_row_in.product_id# ORDER BY PROCESS_DATE_OUT DESC,STOCKS_ROW_CLOSED_ID DESC
                    </cfquery>
                    <cfset kalan_row = (get_stocks_row_in.amount - get_stocks_row_in.closed_amount)>
                    <cfset row_price = get_stocks_row_in.price>
                    <cfset row_extra_price = get_stocks_row_in.extra_cost>
                    <cfif kalan_row gt 0>
                        <cfquery name="add_stock_closed" datasource="#kaynak_dsn2#">
                            INSERT INTO
                                STOCKS_ROW_CLOSED
                            (
                                PRODUCT_ID,
                                <cfif is_stock_based_cost eq 1>
                                    STOCK_ID,
                                </cfif>
                                <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                                    SPECT_MAIN_ID,
                                </cfif>
                                AMOUNT,
                                COST_PRICE,
                                MONEY_TYPE,
                                COST_EXTRA_PRICE,
                                STORE,
                                STORE_LOCATION,
                                UPD_ID_IN,
                                PROCESS_TYPE_IN,
                                PROCESS_DATE_IN,
                                PROCESS_DATE_OUT,
                                LAST_TOTAL_AMOUNT,
                                LAST_COST_PRICE,
                                LAST_TOTAL_PRICE,
                                RECORD_DATE,
                                RECORD_IP,
                                RECORD_EMP
                            )
                            VALUES
                            (
                                #get_stocks_row_in.product_id#,
                                <cfif is_stock_based_cost eq 1>
                                    #get_stocks_row_in.stock_id#,
                                </cfif>
                                <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                                    #get_stocks_row_in.spect_var_id#,
                                </cfif>
                                #kalan_row#,
                                #row_price#,
                                '#session.ep.money#',
                                #row_extra_price#,
                                #get_stocks_row_in.store#,
                                #get_stocks_row_in.store_location#,
                                #get_stocks_row_in.upd_id#,
                                #get_stocks_row_in.process_type#,
                                #createodbcdatetime(get_stocks_row_in.process_date)#,
                                #attributes.aktarim_date2#,
                                <cfif get_row_closed.recordcount>
                                    #kalan_row#,
                                    #wrk_round((row_price*kalan_row+get_row_closed.last_total_price)/kalan_row,8)#,
                                    #wrk_round((row_price*kalan_row+get_row_closed.last_total_price),2)#,
                                <cfelse>
                                    <cfif kalan_row gt 0>
                                        #kalan_row#	,
                                        #wrk_round((row_price*get_stocks_row_in.amount)/kalan_row,8)#,
                                        #wrk_round((row_price*get_stocks_row_in.amount),2)#,
                                    <cfelse>
                                        0,
                                        0,
                                        0,
                                    </cfif>
                                </cfif>
                                #now()#,
                                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                            )
                        </cfquery>
                    </cfif>
                </cfloop>
                </cfif>
            </cfoutput>
        </cfloop>
        <cfif kk_index eq attributes.loop_count>
		<br/><b>3. Üretim Maliyetlerinin Güncellenmesi</b><br/><br/>
        </cfif>
		<!--- Üretim maliyetlerinin güncellenmesi --->
		<cfquery name="GET_PROCESS_CAT" datasource="#kaynak_dsn3#">
			SELECT
				PROCESS_CAT_ID,
				PROCESS_TYPE,
				IS_COST
			FROM 
				SETUP_PROCESS_CAT
			WHERE 
				IS_COST = 1
		</cfquery>
		<cfset proc_list=valuelist(GET_PROCESS_CAT.PROCESS_CAT_ID,',')>
		<cfquery name="delete_GET_PROD" datasource="#kaynak_dsn3#">
       		IF EXISTS (SELECT * FROM tempdb.sys.tables where name='####GET_PROD_#session.ep.userid#')
        	DROP TABLE ####GET_PROD_#session.ep.userid#
        </cfquery>
        <cfquery name="GET_PROD_INSERT" datasource="#kaynak_dsn3#">
			SELECT
				4 ACTION_TYPE,
				2 QUERY_TYPE,
				PORR.PR_ORDER_ID ACTION_ID,
				POR.FINISH_DATE ACTION_DATE,
				PR_ORDER_ROW_ID,
				POR.PRODUCTION_ORDER_NO,
				POR.RESULT_NO,
				PORR.AMOUNT,
				PORR.PRODUCT_ID,
				PORR.STOCK_ID,
				PORR.KDV_PRICE TAX,
				POR.START_DATE,
                POR.FINISH_DATE,
				ISNULL(PORR.STATION_REFLECTION_COST_SYSTEM,0) STATION_REFLECTION_COST_SYSTEM,
				ISNULL(PORR.LABOR_COST_SYSTEM,0) LABOR_COST_SYSTEM
			INTO ####GET_PROD_#session.ep.userid#
            FROM 
				PRODUCTION_ORDERS PO,
				PRODUCTION_ORDER_RESULTS POR,
				PRODUCTION_ORDER_RESULTS_ROW PORR,
				#dsn1_alias#.STOCKS STOCKS,
				#dsn1_alias#.PRODUCT PRODUCT
			WHERE
				POR.PROCESS_ID IN (#proc_list#) AND
				PO.P_ORDER_ID = POR.P_ORDER_ID AND
                PO.STOCK_ID = PORR.STOCK_ID AND
				POR.PR_ORDER_ID = PORR.PR_ORDER_ID AND
				STOCKS.STOCK_ID = PORR.STOCK_ID AND
				STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
				PRODUCT.IS_COST = 1 AND
				PORR.TYPE = 1 AND
				PO.IS_DEMONTAJ <> 1 AND
				ISNULL(PORR.IS_FREE_AMOUNT,0) <> 1 AND
				POR.IS_STOCK_FIS=1
				<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
					AND PRODUCT.PRODUCT_ID = #attributes.aktarim_product_id#
				</cfif>
				<cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
					AND	(
							<cfif not(isdefined("x_is_prod_record_date") and x_is_prod_record_date eq 1)>
								(
									1=1
									<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
										AND POR.RECORD_DATE >= #attributes.aktarim_date1#
									</cfif>
									<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
										AND POR.RECORD_DATE <= #dateadd('d',1,attributes.aktarim_date2)#
									</cfif>
								)
								OR
							</cfif>
							(
								1=1
								<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
									AND POR.FINISH_DATE >= #attributes.aktarim_date1#
								</cfif>
								<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
									AND POR.FINISH_DATE < #dateadd('d',1,attributes.aktarim_date2)#
								</cfif>
							)
					)
				</cfif>
			ORDER BY
				POR.FINISH_DATE,
                ISNULL((SELECT TOP 1 PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PRODUCT_ID = PORR.PRODUCT_ID AND TYPE=2),0) DESC,
				POR.RECORD_DATE DESC
        </cfquery>
        <cfquery name="GET_PROD" datasource="#kaynak_dsn3#">        
            WITH CTE1 AS (
            SELECT 
                * 
            FROM 
                ####GET_PROD_#session.ep.userid#
            ),
                CTE2 AS (
                    SELECT
                        CTE1.*,
                            ROW_NUMBER() OVER (ORDER BY FINISH_DATE) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
        </cfquery>
		<!---<cfdump var="#GET_PROD#"><br />--->
		<cfoutput query="GET_PROD">
			<cfsavecontent variable="text_123">#currentrow#-
				<!--- SARF VE FİRE SATIRLARINI ALIYORUZ --->
                <cfquery name="GET_RESULT_SARF" datasource="#kaynak_dsn3#">
                    SELECT 
                        PRODUCTION_ORDER_RESULTS.P_ORDER_ID,
                        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID,
                        PRODUCTION_ORDER_RESULTS.START_DATE,
                        PRODUCTION_ORDER_RESULTS.FINISH_DATE,
                        PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ROW_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.PRODUCT_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID,
                        PRODUCTION_ORDER_RESULTS_ROW.AMOUNT,
                        PRODUCTION_ORDER_RESULTS_ROW.KDV_PRICE TAX,
                        ISNULL(PRODUCTION_ORDER_RESULTS_ROW.SPEC_MAIN_ID,0) SPECT_MAIN_ID,
                        PRODUCT.IS_PRODUCTION,
                        ISNULL(IS_MANUAL_COST,0) AS IS_MANUAL_COST,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_SYSTEM_TOTAL,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_EXTRA_COST_SYSTEM,
                        PRODUCTION_ORDER_RESULTS_ROW.PURCHASE_NET_SYSTEM
                    FROM
                        PRODUCTION_ORDERS,
                        PRODUCTION_ORDER_RESULTS,
                        PRODUCTION_ORDER_RESULTS_ROW,
                        #dsn1_alias#.STOCKS STOCKS,
                        #dsn1_alias#.PRODUCT PRODUCT
                    WHERE
                        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = #ACTION_ID# AND
                        IS_DEMONTAJ <> 1 AND
                        PRODUCTION_ORDER_RESULTS_ROW.TYPE IN(2,3)<!--- 2 SARF 3 FİRE ---> AND
                        STOCKS.STOCK_ID = PRODUCTION_ORDER_RESULTS_ROW.STOCK_ID AND
                        STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                        PRODUCTION_ORDERS.P_ORDER_ID = PRODUCTION_ORDER_RESULTS.P_ORDER_ID AND 
                        PRODUCTION_ORDER_RESULTS.PR_ORDER_ID = PRODUCTION_ORDER_RESULTS_ROW.PR_ORDER_ID
                </cfquery>
				<!---<cfdump var="#GET_RESULT_SARF#"><br />--->
                <cfset purchase_net_sarf_total=0>
                <cfset purchase_extra_sarf_total=0>
                <cfset purchase_extra_sarf_total_=0>
				<cfset extra_cost_total__=GET_PROD.STATION_REFLECTION_COST_SYSTEM+GET_PROD.LABOR_COST_SYSTEM>
                <cfloop query="GET_RESULT_SARF">
                    <cfquery name="GET_COST" datasource="#kaynak_dsn2#">
                        SELECT 
                            SUM(SR.AMOUNT*SR.COST_PRICE)/SUM(SR.AMOUNT) AS PURCHASE_NET_SYSTEM,
                            ISNULL(SUM(SR.AMOUNT*SR.COST_EXTRA_PRICE)/SUM(SR.AMOUNT),0) AS PURCHASE_EXTRA_COST_SYSTEM,
							0 PURCHASE_EXTRA_COST,
							'#session.ep.money#' PURCHASE_NET_SYSTEM_MONEY
                        FROM 
                            STOCKS_ROW_CLOSED SR, 
                            STOCK_FIS_ROW,
                            STOCK_FIS SF
                        WHERE 
                            SF.FIS_ID = STOCK_FIS_ROW.FIS_ID AND
                            SF.PROD_ORDER_RESULT_NUMBER = #PR_ORDER_ID# AND
                            SR.UPD_ID_OUT = STOCK_FIS_ROW.FIS_ID
                            AND SR.PRODUCT_ID = (SELECT S.PRODUCT_ID FROM #kaynak_dsn3#.STOCKS S WHERE S.STOCK_ID = STOCK_FIS_ROW.STOCK_ID)
                            AND SR.PROCESS_TYPE_OUT IN (111,112)
                            AND STOCK_FIS_ROW.STOCK_ID=#STOCK_ID#
                            AND STOCK_FIS_ROW.AMOUNT=#AMOUNT#
                            <cfif session.ep.our_company_info.is_prod_cost_type eq 0>
                                AND ISNULL(SPECT_MAIN_ID,0)<cfif GET_RESULT_SARF.SPECT_MAIN_ID gte 0>=#GET_RESULT_SARF.SPECT_MAIN_ID#<cfelse> IS NULL</cfif>
                            </cfif>
                            <cfif session.ep.our_company_info.is_stock_based_cost eq 1>
                                AND SR.STOCK_ID = STOCK_FIS_ROW.STOCK_ID
                            </cfif>
                    </cfquery>
                    <!---<cfdump var="#GET_COST#"><cfabort>--->
                    <cfif GET_COST.RECORDCOUNT and len(GET_COST.PURCHASE_NET_SYSTEM)>
                        <cfset amount_=AMOUNT>
                        <cfif GET_RESULT_SARF.IS_MANUAL_COST eq 0>
                        	<cfset price_=GET_COST.PURCHASE_NET_SYSTEM>
							<cfset extra_cost_=GET_COST.PURCHASE_EXTRA_COST_SYSTEM>
                            <cfset extra_cost_total_=GET_COST.PURCHASE_EXTRA_COST_SYSTEM*AMOUNT>
                            <cfset price_other_=GET_COST.PURCHASE_NET_SYSTEM>
                            <cfset total_=GET_COST.PURCHASE_NET_SYSTEM*AMOUNT>
                        <cfelse>
                        	<cfset price_=GET_RESULT_SARF.PURCHASE_NET_SYSTEM>
                        	<cfset extra_cost_=GET_RESULT_SARF.PURCHASE_EXTRA_COST_SYSTEM>
                            <cfset extra_cost_total_=GET_RESULT_SARF.PURCHASE_EXTRA_COST_SYSTEM*AMOUNT>
                            <cfset price_other_=GET_RESULT_SARF.PURCHASE_NET_SYSTEM>
                            <cfset total_=GET_RESULT_SARF.PURCHASE_NET_SYSTEM*AMOUNT>
                        </cfif>
                        <cfset other_money_=session.ep.money>
                        <cfset other_total_=price_other_*AMOUNT>
                        <cfif TAX gt 0>
                            <cfset total_tax_=((price_*AMOUNT)*TAX)/100>
                        <cfelse>
                            <cfset total_tax_=0>
                        </cfif>
                        <cfquery name="UPD_FIS" datasource="#kaynak_dsn2#">
                            UPDATE
                                STOCK_FIS_ROW
                            SET
                                TOTAL=#total_#,
                                TOTAL_TAX=#total_tax_#,
                                NET_TOTAL=#total_#,
                                PRICE=#price_#,
                                TAX=#TAX#,
                                OTHER_MONEY='#other_money_#',
                                PRICE_OTHER=#price_other_#,
                                COST_PRICE=#price_#,
                                EXTRA_COST=#extra_cost_#
                            WHERE
                                FIS_ID IN (
                                		SELECT 
                                            STOCK_FIS.FIS_ID
                                        FROM 
                                            STOCK_FIS,
                                            #kaynak_dsn3#.PRODUCTION_ORDER_RESULTS_ROW PRR
                                        WHERE 
                                            ISNULL(PRR.IS_MANUAL_COST,0) <> 1 AND
                                            PRR.PR_ORDER_ID = STOCK_FIS.PROD_ORDER_RESULT_NUMBER AND
                                            STOCK_FIS_ROW.STOCK_ID = PRR.STOCK_ID AND
                                            STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#PR_ORDER_ID#
                                            AND FIS_TYPE IN (111,112)
                                           )
                                AND STOCK_ID=#STOCK_ID#
                                AND AMOUNT=#AMOUNT#
                        </cfquery>
                        <cfquery name="UPD_RESULT_ROW" datasource="#kaynak_dsn3#">
                            UPDATE
                                PRODUCTION_ORDER_RESULTS_ROW
                            SET
                                PURCHASE_NET_SYSTEM=#price_#,
                                PURCHASE_NET_SYSTEM_MONEY='#GET_COST.PURCHASE_NET_SYSTEM_MONEY#',
                                PURCHASE_EXTRA_COST_SYSTEM=#extra_cost_#,
                                PURCHASE_NET_SYSTEM_TOTAL=#total_#,
                                PURCHASE_NET=#price_other_#,
                                PURCHASE_NET_MONEY='#other_money_#',
                                PURCHASE_EXTRA_COST=#extra_cost_#,<!--- todo --->
                                PURCHASE_NET_TOTAL=#other_total_#
                            WHERE
                                ISNULL(IS_MANUAL_COST,0) <> 1 AND <!---üretim sonuc satirinda maliyeti güncellenmesin secilenlerin maliyetleri guncellenmeyecek --->
                                PR_ORDER_ROW_ID=#PR_ORDER_ROW_ID#
                        </cfquery>
						<cfset purchase_net_sarf_total=purchase_net_sarf_total+total_>
                        <cfset purchase_extra_sarf_total=purchase_extra_sarf_total+extra_cost_total_>
                        <cfset purchase_extra_sarf_total_=purchase_extra_sarf_total_+extra_cost_total__>
                    <cfelse>
                        <font color="red"><cf_get_lang no ='2110.Üretim satırındaki Ürünün Kayıtlı Maliyeti Yok:'> Üretim Emri:#evaluate('GET_PROD.PRODUCTION_ORDER_NO[#GET_PROD.CURRENTROW#]')# <cf_get_lang no ='2112.Üretim Sonuç'>  ID:#evaluate('GET_PROD.RESULT_NO[#GET_PROD.CURRENTROW#]')# <cf_get_lang_main no='245.Ürün'> ID:#GET_RESULT_SARF.PRODUCT_ID# <cfif GET_RESULT_SARF.SPECT_MAIN_ID gt 0>Main Spec ID:#GET_RESULT_SARF.SPECT_MAIN_ID#</cfif></font><br/>
                        <cfquery name="UPD_FIS" datasource="#kaynak_dsn2#">
                            UPDATE
                                STOCK_FIS_ROW
                            SET
                                TOTAL=0,
                                TOTAL_TAX=0,
                                NET_TOTAL=0,
                                PRICE=0,
                                TAX=#TAX#,
                                PRICE_OTHER=0,
                                COST_PRICE=0,
                                EXTRA_COST=0
                            WHERE
                                FIS_ID IN(SELECT 
                                            STOCK_FIS.FIS_ID
                                        FROM 
                                            STOCK_FIS,
                                            #kaynak_dsn3#.PRODUCTION_ORDER_RESULTS_ROW PRR
                                        WHERE 
                                            ISNULL(PRR.IS_MANUAL_COST,0) <> 1 AND
                                            PRR.PR_ORDER_ID = STOCK_FIS.PROD_ORDER_RESULT_NUMBER AND
                                            STOCK_FIS_ROW.STOCK_ID = PRR.STOCK_ID AND
                                            STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#PR_ORDER_ID#
                                            AND FIS_TYPE IN (111,112)
                                         )
                                AND STOCK_ID=#STOCK_ID#
                        </cfquery>
                        <cfquery name="UPD_RESULT_ROW" datasource="#kaynak_dsn3#">
                            UPDATE
                                PRODUCTION_ORDER_RESULTS_ROW
                            SET
                                PURCHASE_NET_SYSTEM=0,
                                PURCHASE_NET_SYSTEM_MONEY='#session_money#',
                                PURCHASE_EXTRA_COST_SYSTEM=0,
                                PURCHASE_NET_SYSTEM_TOTAL=0,
                                PURCHASE_NET=0,
                                PURCHASE_EXTRA_COST=0,
                                PURCHASE_NET_TOTAL=0
                            WHERE
                                ISNULL(IS_MANUAL_COST,0) <> 1 AND <!---üretim sonuc satirinda maliyeti güncellenmesin secilenlerin maliyetleri guncellenmeyecek --->
                                PR_ORDER_ROW_ID=#PR_ORDER_ROW_ID#
                        </cfquery>
                    </cfif>
                </cfloop>
                <cfquery name="GET_STANDART_COST_MONEY_PURCHASE" datasource="#kaynak_dsn3#">
                    SELECT 
                        MAX(PRICE) AS PRICE,
                        MONEY 
                    FROM
                        PRICE_STANDART
                    WHERE
                        PRODUCT_ID=#GET_PROD.PRODUCT_ID# AND
                        PURCHASESALES=0 AND
                        PRICESTANDART_STATUS=1
                    GROUP BY MONEY
                </cfquery>
                <cfif GET_STANDART_COST_MONEY_PURCHASE.RECORDCOUNT and GET_STANDART_COST_MONEY_PURCHASE.PRICE>
                    <cfset cost_money = GET_STANDART_COST_MONEY_PURCHASE.MONEY>
                <cfelse>
                    <cfset cost_money = session.ep.money>
                </cfif>
                <cfif cost_money neq session_money>
                    <cfquery name="GET_MONEY" datasource="#dsn#">
                        SELECT
                            (RATE2/RATE1) AS RATE,MONEY 
                        FROM 
                            MONEY_HISTORY
                        WHERE 
                            VALIDATE_DATE <= #CreateODBCDate(GET_PROD.ACTION_DATE)#
                            AND PERIOD_ID = #session_period_id#
                            AND MONEY = '#cost_money#'
                        ORDER BY 
                            MONEY_HISTORY_ID DESC
                    </cfquery>
                    <cfif GET_MONEY.RECORDCOUNT and len(GET_MONEY.RATE)>
                        <cfset rate_=GET_MONEY.RATE>
                    <cfelse>
                        <cfquery name="GET_MONEY" datasource="#kaynak_dsn2#">
                            SELECT
                                (RATE2/RATE1) AS RATE,MONEY 
                            FROM 
                                SETUP_MONEY
                            WHERE
                                PERIOD_ID = #session_period_id#
                                AND MONEY = '#cost_money#'
                        </cfquery>
                        <cfset rate_=GET_MONEY.RATE>
                    </cfif>
                <cfelse>
                    <cfset rate_=1>
                </cfif>
                <cfif purchase_net_sarf_total gt 0 AND GET_PROD.AMOUNT gt 0 AND rate_ gt 0>
                    <cfset total_net=(purchase_net_sarf_total/GET_PROD.AMOUNT)/rate_>
                <cfelse>
                    <cfset total_net=0>
                </cfif>
                <cfif purchase_extra_sarf_total gt 0 AND GET_PROD.AMOUNT gt 0 AND rate_ gt 0>
                    <cfset total_extra=(purchase_extra_sarf_total/GET_PROD.AMOUNT)/rate_>
                <cfelse>
                    <cfset total_extra=0>
                </cfif>
                <cfquery name="UPD_RESULT_ROW" datasource="#kaynak_dsn3#">
                    UPDATE
                        PRODUCTION_ORDER_RESULTS_ROW
                    SET
                        COST_ID=NULL,
                        PURCHASE_NET_SYSTEM=#purchase_net_sarf_total/GET_PROD.AMOUNT#,
                        PURCHASE_NET_SYSTEM_MONEY='#session.ep.money#',
                        PURCHASE_EXTRA_COST_SYSTEM=#purchase_extra_sarf_total/GET_PROD.AMOUNT#,
                        PURCHASE_NET_SYSTEM_TOTAL=#purchase_net_sarf_total#,
                        PURCHASE_NET=#total_net#,
                        PURCHASE_NET_MONEY='#cost_money#',
                        PURCHASE_EXTRA_COST=#total_extra#,
                        PURCHASE_NET_TOTAL=#total_net#*#GET_PROD.AMOUNT#
                    WHERE
                        PR_ORDER_ROW_ID=#GET_PROD.PR_ORDER_ROW_ID#
                </cfquery>
                <cfif GET_PROD.TAX gt 0>
                    <cfset total_tax_=((purchase_net_sarf_total/GET_PROD.AMOUNT)*GET_PROD.TAX)/100>
                <cfelse>
                    <cfset total_tax_=0>
                </cfif>
                <cfquery name="UPD_FIS" datasource="#kaynak_dsn2#">
                    UPDATE
                        STOCK_FIS_ROW
                    SET
                        TOTAL=#purchase_net_sarf_total#,
                        TOTAL_TAX=#total_tax_#,
                        NET_TOTAL=#purchase_net_sarf_total#,
                        PRICE=#purchase_net_sarf_total/GET_PROD.AMOUNT#,
                        TAX=#GET_PROD.TAX#,
                        OTHER_MONEY='#cost_money#',
                        PRICE_OTHER=#total_net#,
                        COST_PRICE=#(purchase_net_sarf_total+purchase_extra_sarf_total)/GET_PROD.AMOUNT#,
                        EXTRA_COST=#extra_cost_total__#,
                        COST_ID=NULL
                    WHERE
                        FIS_ID IN(SELECT 
                                    STOCK_FIS.FIS_ID
                                FROM 
                                    STOCK_FIS
                                WHERE 
                                    STOCK_FIS.PROD_ORDER_RESULT_NUMBER=#ACTION_ID#
                                    AND FIS_TYPE=110)
                        AND STOCK_ID=#GET_PROD.STOCK_ID#
                        AND AMOUNT=#GET_PROD.AMOUNT#
                </cfquery>
                Üretim Emri No:#PRODUCTION_ORDER_NO# Üretim Sonuç No:#GET_PROD.RESULT_NO# <cf_get_lang_main no ='330.Tarih'> :#dateformat(ACTION_DATE,'dd:mm:yyyy')#<br />
				<cfset son_deger = GET_PROD.rownum >
                <cfset toplam_kayit = GET_PROD.QUERY_COUNT>
            </cfsavecontent>
			<cfif kk_index eq attributes.loop_count>#text_123#</cfif>
		</cfoutput>
        </cfloop>
		<form action="" name="form1_" id="step2" method="post">		
			<cfif isdefined("attributes.is_fifo")>
				<input type="hidden" name="is_fifo" id="is_fifo" value="1" />
			</cfif>
            <cfif isdefined("attributes.is_oto")>
        		<input type="hidden" name="is_oto" id="is_oto" value="1" />
        	</cfif>
			<input type="hidden" name="aktarim_kaynak_period" id="aktarim_kaynak_period" value="<cfoutput>#attributes.aktarim_kaynak_period#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_year" id="aktarim_kaynak_year" value="<cfoutput>#attributes.aktarim_kaynak_year#</cfoutput>">
			<input type="hidden" name="aktarim_kaynak_company" id="aktarim_kaynak_company" value="<cfoutput>#attributes.aktarim_kaynak_company#</cfoutput>">
			<input type="hidden" name="aktarim_date1" id="aktarim_date1" value="<cfif isdate(attributes.aktarim_date1)><cfoutput>#dateformat(attributes.aktarim_date1,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_date2" id="aktarim_date2" value="<cfif isdate(attributes.aktarim_date2)><cfoutput>#dateformat(attributes.aktarim_date2,dateformat_style)#</cfoutput></cfif>">
			<input type="hidden" name="aktarim_product_name" id="aktarim_product_name" value="<cfoutput>#attributes.aktarim_product_name#</cfoutput>">
			<input type="hidden" name="aktarim_product_id" id="aktarim_product_id" value="<cfoutput>#attributes.aktarim_product_id#</cfoutput>">
			<input type="hidden" name="session_userid" id="session_userid" value="<cfoutput>#attributes.session_userid#</cfoutput>">
			<input type="hidden" name="session_period_id" id="session_period_id" value="<cfoutput>#attributes.session_period_id#</cfoutput>">
			<input type="hidden" name="session_money" id="session_money" value="<cfoutput>#attributes.session_money#</cfoutput>">
			<input type="hidden" name="session_money2" id="session_money2" value="<cfoutput>#attributes.session_money2#</cfoutput>">
			<cfif isdefined('attributes.aktarim_is_cost_again') and len(attributes.aktarim_is_cost_again)>
            	<input type="hidden" name="aktarim_is_cost_again" id="aktarim_is_cost_again" value="<cfoutput>#attributes.aktarim_is_cost_again#</cfoutput>">
            </cfif>
			<cfif isdefined('attributes.aktarim_is_invent_again') and len(attributes.aktarim_is_invent_again)>
            	<input type="hidden" name="aktarim_is_invent_again" id="aktarim_is_invent_again" value="<cfoutput>#attributes.aktarim_is_invent_again#</cfoutput>">
            </cfif>
			<cfif isdefined('attributes.aktarim_is_date_kontrol') and len(attributes.aktarim_is_date_kontrol)>
            	<input type="hidden" name="aktarim_is_date_kontrol" id="aktarim_is_date_kontrol" value="<cfoutput>#attributes.aktarim_is_date_kontrol#</cfoutput>">
            </cfif>
			<cfif isdefined('attributes.aktarim_is_location_based_cost') and len(attributes.aktarim_is_location_based_cost)>
            	<input type="hidden" name="aktarim_is_location_based_cost" id="aktarim_is_location_based_cost" value="<cfoutput>#attributes.aktarim_is_location_based_cost#</cfoutput>">
            </cfif>
			<cf_get_lang no ='2028.Kaynak Veri Tabanı'>: <cfoutput>#attributes.aktarim_kaynak_period# (#attributes.aktarim_kaynak_year#)</cfoutput><br/>
			<br /><br />
            <cfif toplam_kayit gt son_deger>
                <input type="text" name="page" id="page" value="<cfoutput>#(attributes.page+1)#</cfoutput>">
                <input type="hidden" name="step" id="step" value="2">
                <input type="button" value="part_<cfoutput>#attributes.page#</cfoutput>" onClick="basamak_2();">
			<cfelseif attributes.loop_count lt 5 >
            	<cfset attributes.loop_count = attributes.loop_count +1>
                <cfset attributes.from_count = attributes.from_count +1>
            	 <input type="text" name="step" id="step" value="2">
                 <input type="hidden" name="loop_count" id="loop_count" value="<cfoutput>#attributes.loop_count#</cfoutput>">
                 <input type="hidden" name="from_count" id="from_count" value="<cfoutput>#attributes.from_count#</cfoutput>">
                 <input type="button" value="part_<cfoutput>#attributes.from_count#</cfoutput>" onClick="basamak_2();">
			<cfelseif x_is_upd_inv eq 1>
				<input type="hidden" name="step" id="step" value="4">
				<br /><br />
				<b><font color="FF0000">Sonraki İşlem : Satış Faturaları ve Satış İrsaliyelerin Güncellenmesi</font></b><br />
				<input type="button" value="<cf_get_lang no ='2114.Devam Et'>" onClick="basamak_2();">
            <cfelse>
				<b><br /><br /><cf_get_lang no ='2109.Maliyet İşlemi Tamamlanmıştır'>!</b><cfabort>
            </cfif>           
		</form>
	</cfif>
	<!--- Satış faturası ve irsaliyelerinin güncellenmesi --->
	<cfif attributes.step eq 4>
		<cfif x_is_prod_cost eq 1>
			<br/><b>4. Satış Faturaları ve Satış İrsaliyelerin Güncellenmesi</b><br/>
		<cfelse>
			<br/><b>3. Satış Faturaları ve Satış İrsaliyelerin Güncellenmesi</b><br/>
		</cfif>
		<cfquery name="UPD_INV_COST" datasource="#dsn2#">
			UPDATE
				INVOICE_ROW
			SET
				COST_PRICE=ISNULL((SELECT
										SUM(SR.AMOUNT*SR.COST_PRICE)
									FROM
										STOCKS_ROW_CLOSED SR,
										INVOICE_SHIPS ISS,
										SHIP_ROW
									WHERE
										SR.UPD_ID_OUT = SHIP_ROW.SHIP_ID
										AND ISS.INVOICE_ID = INVOICE_ROW.INVOICE_ID
										AND ISS.SHIP_ID = SHIP_ROW.SHIP_ID
										AND SR.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID
										AND INVOICE_ROW.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
										AND SR.PROCESS_TYPE_OUT = (SELECT SHIP_TYPE FROM SHIP INV WHERE INV.SHIP_ID=SHIP_ROW.SHIP_ID)
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #kaynak_dsn3#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=INVOICE_ROW.SPECT_VAR_ID),0)
										</cfif>
										<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
											AND SR.STOCK_ID = INVOICE_ROW.STOCK_ID
										</cfif>
									),0)/INVOICE_ROW.AMOUNT,
               EXTRA_COST=ISNULL((SELECT 
               							 SUM(SR.AMOUNT*SR.COST_EXTRA_PRICE)
									FROM
										STOCKS_ROW_CLOSED SR,
										INVOICE_SHIPS ISS,
										SHIP_ROW
									WHERE
										SR.UPD_ID_OUT = SHIP_ROW.SHIP_ID
										AND ISS.INVOICE_ID = INVOICE_ROW.INVOICE_ID
										AND ISS.SHIP_ID = SHIP_ROW.SHIP_ID
										AND SR.PRODUCT_ID = INVOICE_ROW.PRODUCT_ID
										AND INVOICE_ROW.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
										AND SR.PROCESS_TYPE_OUT = (SELECT SHIP_TYPE FROM SHIP INV WHERE INV.SHIP_ID=SHIP_ROW.SHIP_ID)
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #kaynak_dsn3#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=INVOICE_ROW.SPECT_VAR_ID),0)
										</cfif>
										<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
											AND SR.STOCK_ID = INVOICE_ROW.STOCK_ID
										</cfif>
									),0)/INVOICE_ROW.AMOUNT
			WHERE
				INVOICE_ID IN (SELECT INVOICE_ID FROM INVOICE INV WHERE INV.PURCHASE_SALES=1 
				<cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
					<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
						AND INV.INVOICE_DATE >= #attributes.aktarim_date1#
					</cfif>
					<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
						AND INV.INVOICE_DATE <= #attributes.aktarim_date2#
					</cfif>
				</cfif>
				)
				<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
					AND INVOICE_ROW.PRODUCT_ID = #attributes.aktarim_product_id#
				</cfif>
		</cfquery>
		<cfquery name="UPD_SHIP_COST" datasource="#dsn2#">
			UPDATE
				SHIP_ROW
			SET
				COST_PRICE=ISNULL((SELECT
										SUM(SR.AMOUNT*SR.COST_PRICE)
									FROM
										STOCKS_ROW_CLOSED SR
									WHERE
										SR.UPD_ID_OUT = SHIP_ROW.SHIP_ID
										AND SR.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
										AND SR.PROCESS_TYPE_OUT = (SELECT SHIP_TYPE FROM SHIP INV WHERE INV.SHIP_ID=SHIP_ROW.SHIP_ID)
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #kaynak_dsn3#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=SHIP_ROW.SPECT_VAR_ID),0)
										</cfif>
										<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
											AND SR.STOCK_ID = SHIP_ROW.STOCK_ID
										</cfif>
									),0)/SHIP_ROW.AMOUNT,
                 EXTRA_COST=ISNULL((SELECT 
                 						SUM(SR.AMOUNT*SR.COST_EXTRA_PRICE)
									FROM
										STOCKS_ROW_CLOSED SR
									WHERE
										SR.UPD_ID_OUT = SHIP_ROW.SHIP_ID
										AND SR.PRODUCT_ID = SHIP_ROW.PRODUCT_ID
										AND SR.PROCESS_TYPE_OUT = (SELECT SHIP_TYPE FROM SHIP INV WHERE INV.SHIP_ID=SHIP_ROW.SHIP_ID)
										<cfif session.ep.our_company_info.is_prod_cost_type eq 0>
											AND ISNULL(SR.SPECT_MAIN_ID,0) = ISNULL((SELECT SPECTS.SPECT_MAIN_ID FROM #kaynak_dsn3#.SPECTS SPECTS WHERE SPECTS.SPECT_VAR_ID=SHIP_ROW.SPECT_VAR_ID),0)
										</cfif>
										<cfif session.ep.our_company_info.is_stock_based_cost eq 1>
											AND SR.STOCK_ID = SHIP_ROW.STOCK_ID
										</cfif>
									),0)/SHIP_ROW.AMOUNT
			WHERE
				SHIP_ID IN (SELECT SHIP_ID FROM SHIP INV WHERE INV.PURCHASE_SALES=1 AND SHIP_TYPE <> 811
				<cfif (isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5) or (isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5)>
					<cfif isdefined('attributes.aktarim_date1') and len(attributes.aktarim_date1) gt 5>
						AND INV.SHIP_DATE >= <cfqueryparam value="#attributes.aktarim_date1#" cfsqltype="cf_sql_timestamp">
					</cfif>
					<cfif isdefined('attributes.aktarim_date2') and len(attributes.aktarim_date2) gt 5>
						AND INV.SHIP_DATE <= <cfqueryparam value="#attributes.aktarim_date2#" cfsqltype="cf_sql_timestamp">
					</cfif>
				</cfif>
				)
				<cfif len(attributes.aktarim_product_name) and len(attributes.aktarim_product_id)>
					AND SHIP_ROW.PRODUCT_ID = #attributes.aktarim_product_id#
				</cfif>
		</cfquery>
		<b><br /><br /><cf_get_lang no ='2109.Maliyet İşlemi Tamamlanmıştır'>!</b><cfabort>
    </cfif>
    </div>
    </cf_box>
    </div>
</cfif>
