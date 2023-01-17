<cfsetting showdebugoutput="yes">
<cfparam name="attributes.module_id_control" default="20">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.category_id" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.list_type" default="">
<cfparam name="attributes.finishdate" default="#now()#">
<cfparam name="attributes.startdate" default="#date_add('d',-1,attributes.finishdate)#">
<cfparam name="attributes.use_efatura" default="">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset kurumsal = ''>
<cfset bireysel = ''>
<cfif listlen(attributes.category_id)>
	<cfset uzunluk=listlen(attributes.category_id)>
    <cfloop from="1" to="#uzunluk#" index="catyp">
        <cfset eleman = listgetat(attributes.category_id,catyp,',')>
        <cfif listlen(eleman) and listfirst(eleman,'-') eq 1>
            <cfset kurumsal = listappend(kurumsal,listlast(eleman,'-'))>
        <cfelseif listlen(eleman) and listfirst(eleman,'-') eq 2>
            <cfset bireysel = listappend(bireysel,listlast(eleman,'-'))>
        </cfif>
    </cfloop>
</cfif>
<cfset InvoiceSale= createObject("component","V16.report.standart.cfc.invoice_list_sale") />
<cfset get_all_tax=InvoiceSale.GET_ALL_TAX() />
<cfset tax_list=valuelist(get_all_tax.TAX)>
<cfset get_all_otv=InvoiceSale.GET_ALL_OTV() />
<cfset get_all_bsmv=InvoiceSale.GET_ALL_BSMV() />
<cfset get_all_oiv=InvoiceSale.GET_ALL_OIV() />
<cfquery name="get_department" datasource="#dsn#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		BRANCH B,
		DEPARTMENT D 
	WHERE
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
</cfquery>
<cfquery name="get_our_companies" datasource="#dsn#">
	SELECT 
		DISTINCT
		SP.OUR_COMPANY_ID
	FROM
		EMPLOYEE_POSITIONS EP,
		SETUP_PERIOD SP,
		EMPLOYEE_POSITION_PERIODS EPP,
		OUR_COMPANY O
	WHERE 
		SP.OUR_COMPANY_ID = O.COMP_ID AND
		SP.PERIOD_ID = EPP.PERIOD_ID AND
		EP.POSITION_ID = EPP.POSITION_ID AND
		EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<cfquery name="get_comp_category" datasource="#dsn#">
	SELECT
		COMPANYCAT_ID CATEGORY_ID, 
		COMPANYCAT CATEGORY_NAME
	FROM
		COMPANY_CAT
	WHERE
		COMPANYCAT_ID IN (SELECT COMPANYCAT_ID FROM COMPANY_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID IN (#valuelist(get_our_companies.our_company_id,',')#))
</cfquery>
<cfquery name="get_cons_category" datasource="#dsn#">
	SELECT
		CONSCAT_ID CATEGORY_ID, 
		CONSCAT CATEGORY_NAME
	FROM
		CONSUMER_CAT
	WHERE
		CONSCAT_ID IN (SELECT CONSCAT_ID  FROM CONSUMER_CAT_OUR_COMPANY WHERE OUR_COMPANY_ID IN (#valuelist(get_our_companies.our_company_id,',')#))
	ORDER BY
	    HIERARCHY	
</cfquery>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (51,54,55,59,591,592,60,61,63,64,65,68,690,691,601,49,120) ORDER BY PROCESS_CAT
</cfquery>
<cfquery name="get_all_department" datasource="#dsn#">
	SELECT
		DEPARTMENT_ID,
		DEPARTMENT_HEAD
	FROM
		BRANCH B,
		DEPARTMENT D 
	WHERE
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		B.BRANCH_ID = D.BRANCH_ID AND
		D.IS_STORE <> 2 AND
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
</cfquery>
<cfset branch_dep_list=valuelist(get_all_department.department_id,',')>
<cfif isdefined("attributes.form_varmi") and attributes.form_varmi eq 1>
	<cfif isdate(attributes.startdate)>
		<cf_date tarih = "attributes.startdate">
	</cfif>
	<cfif isdate(attributes.finishdate)>
		<cf_date tarih = "attributes.finishdate">
	</cfif>
    <cfquery name="get_add_info_name" datasource="#dsn3#">
            SELECT
                   PROPERTY,PROPERTY_NAME 
                FROM
                (
                    select * from SETUP_PRO_INFO_PLUS_NAMES where OWNER_TYPE_ID = -8
                 ) t
                    UNPIVOT
                    (
                        PROPERTY_NAME FOR PROPERTY IN
                    (
                        <cfloop from="1" to ="40" index="i">
                            PROPERTY#i#_NAME <cfif i neq 40>,</cfif>
                        </cfloop>
                    ) 
                ) AS U
    </cfquery>
    <cfquery name="get_invoice_detail" datasource="#dsn2#">	
        SELECT     
            SERIAL_NUMBER,
            SERIAL_NO
            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,1)>
            ,REF_NO
            </cfif>
            ,INV_PURCHASE.PROCESS_CAT
            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,2)>
            ,DUE_DATE
            </cfif>
            ,ACTION_DATE
            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,3)>
            ,INV_PURCHASE.OZEL_KOD
            </cfif>
            ,Cari_Kod
            ,Cari_Hesap
            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,4)>
            <cfif attributes.report_type eq 2>
                ,CASE WHEN TYPE = 1 THEN NOTE ELSE PRODUCT_NAME2 END AS NOTE
                <cfelse>
                ,CAST (NOTE AS NVARCHAR(200) ) AS NOTE
                </cfif>
            </cfif>
            ,Vergi_Daire
            ,Vergi_No
            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,5)>
            ,TC_IDENTY_NO
            </cfif>
            <cfif attributes.report_type eq 2>
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,6)>
                    ,PRODUCT_CAT
                </cfif>
            </cfif>
            <cfif attributes.report_type eq 1>
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,6)>
                    ,PRODUCTCAT
                </cfif>
            </cfif>
            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,7)>
            ,B.BRANCH_NAME + D.DEPARTMENT_HEAD AS SUBE_DEPO
            </cfif>
            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,10)>
                ,PP.PROJECT_HEAD
            </cfif>
            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                <cfloop from="1" to="40" index="i">
                    ,cast(PROPERTY#i# as nvarchar(100)) as PROPERTY#i#
                </cfloop>
            </cfif>
            <cfif attributes.report_type eq 2>
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                    ,ROW_QUANTITY
                </cfif>
            </cfif>
            <cfif attributes.report_type eq 1>
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                    ,MIKTAR 
                </cfif>
            </cfif> 
            <cfif attributes.report_type eq 2>
                ,ACCOUNT_CODE_PUR 
                ,PRODUCT_NAME
                ,ACC_NAME
            </cfif>
            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>
                <cfloop query="get_all_tax">
                    ,KDV_#filternum(tax)#
                </cfloop>
            </cfif>
            <cfif listfind(attributes.list_type,12)>
                <cfloop query="get_all_otv">
                    ,OTV_#filternum(tax)#
                </cfloop>
            </cfif> 
            <cfif listfind(attributes.list_type,13)>
                <cfloop query="get_all_bsmv">
                    ,BSMV_#filternum(tax)#
                </cfloop>
            </cfif>
            <cfif listfind(attributes.list_type,14)>
                <cfloop query="get_all_oiv">
                    ,OIV_#filternum(tax)#
                </cfloop>
            </cfif>
                <cfif attributes.report_type eq 1>
                    ,MAX(GROSSTOTAL) as GROSSTOTAL
                    ,MAX(SA_DISCOUNT) as SA_DISCOUNT           
                    ,MAX(ROUND_MONEY) as ROUND_MONEY
                    ,ISNULL(SUM(DISCOUNTTOTAL),0) as DISCOUNTTOTAL
                    ,ISNULL((MAX(GROSSTOTAL)-SUM(DISCOUNTTOTAL)),MAX(GROSSTOTAL)) AS INDRIM_SONRASI_KDVSIZ_TOPLAM
                    ,SUM(OTVTOTAL) AS OTVTOTAL
                    ,MAX(IS_TAX_OF_OTV)  AS IS_TAX_OF_OTV
                    ,MAX(TAXTOTAL) AS TAXTOTAL                   
                    ,MAX(BSMVTOTAL) AS BSMVTOTAL
                    ,MAX(OIVTOTAL) AS OIVTOTAL
                    ,MAX(NETTOTAL) AS NETTOTAL
                    
            <cfelseif  attributes.report_type eq 2>
                ,DISCOUNTTOTAL
                ,KDVSIZ_TOPLAM
                ,OTVTOTAL
                ,IS_TAX_OF_OTV
                ,ROW_TAXTOTAL
                ,ROW_BSMVTOTAL
                ,ROW_OIVTOTAL
                ,ISNULL(KDVSIZ_TOPLAM,0) + ISNULL(ROW_TAXTOTAL,0) + ISNULL(ROW_OTVTOTAL,0) + ISNULL(ROW_BSMVTOTAL,0) + ISNULL(ROW_OIVTOTAL,0) AS GENEL_TOPLAM
            </cfif>		
            ,ACTION_ID
            ,INVOICE_CAT
            ,TYPE 
            ,ROW_NUMBER () OVER ( ORDER BY ACTION_DATE DESC, ACTION_ID,Cari_Hesap ) AS ROWNUM
        FROM
        ( 
            SELECT      
                    E.EXPENSE_ID  AS ACTION_ID,
                    E.PAPER_NO AS BELGE_NO,
                    E.SERIAL_NUMBER AS SERIAL_NUMBER,
                    E.SERIAL_NO AS SERIAL_NO,
                    E.EXPENSE_DATE AS ACTION_DATE,
                    E.TOTAL_AMOUNT_KDVLI AS NETTOTAL,
                    E.KDV_TOTAL AS TAXTOTAL,                    
                    E.TOTAL_AMOUNT AS GROSSTOTAL,
                    E.BSMV_TOTAL AS BSMVTOTAL,
                    E.OIV_TOTAL AS OIVTOTAL,                     
                    0 AS IS_TAX_OF_OTV,                   
                    0 AS SA_DISCOUNT,
                    0 AS ROUND_MONEY,
                    <!---ISNULL(E_ROW.AMOUNT_OTV,0) AS OTV_TOTAL,--->
                    E.ACTION_TYPE INVOICE_CAT,
                    E.ACC_DEPARTMENT_ID,
                    ISNULL(E_ROW.AMOUNT_OTV,0) AS OTVTOTAL,
                    E_ROW.OTV_RATE AS OTV_ORAN,              
                    E_ROW.AMOUNT_OTV AS ROW_OTVTOTAL,
                    E_ROW.BSMV_RATE AS BSMV_ORAN,
                    E_ROW.AMOUNT_BSMV AS ROW_BSMVTOTAL,
                    E_ROW.OIV_RATE AS OIV_ORAN,
                    E_ROW.AMOUNT_OIV AS ROW_OIVTOTAL,
                    E_ROW.AMOUNT_KDV AS ROW_TAXTOTAL,
                    CAST(E_ROW.KDV_RATE AS FLOAT) AS TAX,
                    0 AS DISCOUNTTOTAL,
                    (E_ROW.AMOUNT*E_ROW.QUANTITY) AS KDVSIZ_TOPLAM,
                    <cfif attributes.report_type eq 2>
                        ' ' PRODUCT_NAME,
                        ' ' PRODUCT_NAME2,
                        E_ROW.DETAIL NOTE,
                    <cfelse>
                        E.DETAIL NOTE,
                    </cfif>
                    ''Cari_Kod,
                    ''Cari_Hesap,			
                    ''Vergi_Daire,
                    '' Vergi_No,
                    ''OZEL_KOD,
                    '' TC_IDENTY_NO,
                    1 AS TYPE ,
                    SPC.PROCESS_CAT,
                    E.PROJECT_ID,
                    E_ROW.PROJECT_ID ROW_PROJECT_ID,
                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                        <cfloop from="1" to="40" index="i">
                        EXPENSE_ITEM_PLANS_INFO_PLUS.PROPERTY#i#  AS PROPERTY#i#,
                            
                        </cfloop>
                    </cfif>
                    <cfif attributes.report_type eq 2>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                            E_ROW.QUANTITY ROW_QUANTITY,
                        </cfif>
                    </cfif>
                    <cfif attributes.report_type eq 1>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                            BELGE_MIKTAR.MIKTAR MIKTAR,
                        </cfif>
                    </cfif>
                    ISNULL(E_ROW.UNIT,'ADET') AS UNIT, 
                    EXPENSE_ITEMS.EXPENSE_ITEM_ID AS PRODUCT_CATID,
                    <cfif attributes.report_type eq 2>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,6)>
                            EXPENSE_ITEMS.EXPENSE_ITEM_NAME AS PRODUCT_CAT,
                        </cfif>
                    </cfif>
                    <cfif attributes.report_type eq 1>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,6)>
                            BELGE_PRODUCT_CAT.PRODUCTCAT ,
                        </cfif>
                    </cfif>
                    E.SYSTEM_RELATION REF_NO,
                    E.DUE_DATE,
                    0 DUEDATE
                    <cfif attributes.report_type eq 2>
                        ,E_ROW.EXPENSE_ITEM_ID AS PRODUCT_ID
                        ,EXPENSE_ITEMS.ACCOUNT_CODE AS ACCOUNT_CODE_PUR
                        ,ACPL.ACCOUNT_NAME AS ACC_NAME
                    </cfif>
                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>
                        <cfloop query="get_all_tax">
                          ,  TAX_LIST.[#filternum(tax)#] AS KDV_#filternum(tax)#
                        </cfloop> 
                    </cfif>
                    <cfif listfind(attributes.list_type,12)>
                        <cfloop query="get_all_otv">
                          ,  OTV_LIST.[#filternum(tax)#] AS OTV_#filternum(tax)#
                        </cfloop>         
                    </cfif>
                    <cfif listfind(attributes.list_type,13)>
                        <cfloop query="get_all_bsmv">
                          ,  BSMV_LIST.[#filternum(tax)#] AS BSMV_#filternum(tax)#
                        </cfloop>                       
                    </cfif>
                    <cfif listfind(attributes.list_type,14)>
                         <cfloop query="get_all_oiv">
                          ,  OIV_LIST.[#filternum(tax)#] AS OIV_#filternum(tax)#
                        </cfloop>                    
                    </cfif>
                
            FROM
                    EXPENSE_ITEM_PLANS E 
                    JOIN EXPENSE_ITEMS_ROWS E_ROW 
                    ON E.EXPENSE_ID=E_ROW.EXPENSE_ID
                    JOIN EXPENSE_ITEMS 
                    ON E_ROW.EXPENSE_ITEM_ID=EXPENSE_ITEMS.EXPENSE_ITEM_ID
                    JOIN #dsn3_alias#.SETUP_PROCESS_CAT AS spc
                    ON spc.PROCESS_CAT_ID = E.PROCESS_CAT
                    JOIN #dsn2_alias#.ACCOUNT_PLAN ACPL
                    ON ACPL.ACCOUNT_CODE = EXPENSE_ITEMS.ACCOUNT_CODE
                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                        LEFT JOIN EXPENSE_ITEM_PLANS_INFO_PLUS  ON E.EXPENSE_ID=EXPENSE_ITEM_PLANS_INFO_PLUS.EXPENSE_ID
                    </cfif>
                    <cfif len(attributes.use_efatura)>
                        LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
                    </cfif>	
                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>
                        LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                            <cfloop query="get_all_tax">
                            ,  sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop>  
                            FROM
                            (SELECT EXP_ITEM_ROWS_ID,EXPENSE_ID,KDV_RATE,AMOUNT_KDV
                                FROM EXPENSE_ITEMS_ROWS
                        ) AS SourceTable
                            PIVOT
                            (
                            SUM(AMOUNT_KDV)
                            FOR KDV_RATE IN (
                             <cfloop query="get_all_tax">
                                 [#filternum(tax)#] <cfif currentrow neq get_all_tax.recordcount>,</cfif>
                            </cfloop>
                            )
                            ) AS PivotTable
                        group BY
                        <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                        <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                        ) <cfif attributes.report_type eq 1> AS TAX_LIST ON TAX_LIST.EXPENSE_ID = E.EXPENSE_ID </cfif>
                        <cfif attributes.report_type eq 2> AS TAX_LIST ON TAX_LIST.EXP_ITEM_ROWS_ID=E_ROW.EXP_ITEM_ROWS_ID </cfif>
                    </cfif>	
                    <cfif listfind(attributes.list_type,12)>
                        LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1>EXPENSE_ID</cfif>
                            <cfloop query="get_all_otv">
                            ,  sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop>  
                            FROM
                            (SELECT EXP_ITEM_ROWS_ID,EXPENSE_ID,OTV_RATE,AMOUNT_OTV
                                FROM EXPENSE_ITEMS_ROWS
                            ) AS SourceTable
                            <cfif get_all_otv.recordcount>
                            PIVOT
                            (
                            SUM(AMOUNT_OTV) for OTV_RATE IN (
                             <cfloop query="get_all_otv">
                                 [#filternum(tax)#] <cfif currentrow neq get_all_otv.recordcount>,</cfif>
                            </cfloop>
                            )
                            ) AS PivotTable
                            </cfif>
                            group BY
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                        ) <cfif attributes.report_type eq 1>as OTV_LIST ON OTV_LIST.EXPENSE_ID = E.EXPENSE_ID</cfif>
                        <cfif attributes.report_type eq 2>as OTV_LIST ON OTV_LIST.EXP_ITEM_ROWS_ID = E_ROW.EXP_ITEM_ROWS_ID</cfif>
                    </cfif>
                    <cfif listfind(attributes.list_type,13)>
                        LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1>EXPENSE_ID</cfif>
                             <cfloop query="get_all_bsmv">
                            ,  sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop>  
                            FROM
                            (SELECT EXP_ITEM_ROWS_ID,EXPENSE_ID,BSMV_RATE,AMOUNT_BSMV
                                FROM EXPENSE_ITEMS_ROWS
                            ) AS SourceTable
                            <cfif get_all_bsmv.recordcount>
                            PIVOT
                            (
                            SUM(AMOUNT_BSMV)
                            FOR BSMV_RATE IN ( <cfloop query="get_all_bsmv">
                                 [#filternum(tax)#] <cfif currentrow neq get_all_bsmv.recordcount>,</cfif>
                            </cfloop>)
                            ) AS PivotTable
                            </cfif>
                            group BY
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                        ) <cfif attributes.report_type eq 1>as BSMV_LIST ON BSMV_LIST.EXPENSE_ID = E.EXPENSE_ID</cfif>
                        <cfif attributes.report_type eq 2>as BSMV_LIST ON BSMV_LIST.EXP_ITEM_ROWS_ID = E_ROW.EXP_ITEM_ROWS_ID</cfif>
                    </cfif>
                    <cfif listfind(attributes.list_type,14)>
                        LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                             <cfloop query="get_all_oiv">
                            ,  sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop>  
                            FROM
                            (SELECT EXP_ITEM_ROWS_ID,EXPENSE_ID,OIV_RATE,AMOUNT_OIV
                                FROM EXPENSE_ITEMS_ROWS
                        ) AS SourceTable
                        <cfif get_all_oiv.recordcount>
                            PIVOT
                            (
                            SUM(AMOUNT_OIV)
                            FOR OIV_RATE IN  (<cfloop query="get_all_oiv">
                                 [#filternum(tax)#] <cfif currentrow neq get_all_oiv.recordcount>,</cfif>
                            </cfloop>)
                            ) AS PivotTable
                        </cfif>
                        group BY
                        <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                        <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                        ) <cfif attributes.report_type eq 1> AS OIV_LIST ON OIV_LIST.EXPENSE_ID = E.EXPENSE_ID </cfif>
                        <cfif attributes.report_type eq 2> AS OIV_LIST ON OIV_LIST.EXP_ITEM_ROWS_ID=E_ROW.EXP_ITEM_ROWS_ID </cfif>
                    </cfif>	
                    <cfif attributes.report_type eq 1>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                        LEFT JOIN 
                            (
                                SELECT 
                                EXPENSE_ID,
                                STUFF((
                                    SELECT ', ' + CONVERT(NVARCHAR(50),AMOUNT) + ':' + CAST(UNIT AS VARCHAR(MAX))
                                    FROM 
                                    (
                                        SELECT 
                                            EXPENSE_ID,ISNULL(EXPENSE_ITEMS_ROWS.UNIT,'ADET') AS UNIT,SUM(QUANTITY) AS AMOUNT
                                        FROM
                                            EXPENSE_ITEMS_ROWS
                                        GROUP BY EXPENSE_ID,UNIT
                                    ) AS 
                                    EXPENSE_ITEMS_ROWS 
                                    WHERE (EXPENSE_ID = Results.EXPENSE_ID) 
                                    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
                                ,1,2,'') AS MIKTAR
                                FROM (
                                        SELECT 
                                            EXPENSE_ID,ISNULL(EXPENSE_ITEMS_ROWS.UNIT,'ADET') AS UNIT,SUM(QUANTITY) AS AMOUNT
                                        FROM
                                            EXPENSE_ITEMS_ROWS
                                        GROUP BY EXPENSE_ID,ISNULL(EXPENSE_ITEMS_ROWS.UNIT,'ADET') 
                                    ) RESULTS
                                GROUP BY EXPENSE_ID
                            ) as BELGE_MIKTAR ON E.EXPENSE_ID = BELGE_MIKTAR.EXPENSE_ID
                        </cfif>
                    </cfif>
                    <cfif attributes.report_type eq 1>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8) or (listfind(attributes.list_type,6))>
                        LEFT JOIN 
                            (
                                SELECT 
                                EXPENSE_ID,
                                STUFF((
                                    SELECT ', ' + CONVERT(NVARCHAR(50),EXPENSE_ITEM_NAME)
                                    FROM 
                                    (
                                        SELECT 
                                            EXPENSE_ID,EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME  
                                        FROM
                                            EXPENSE_ITEMS_ROWS  JOIN EXPENSE_ITEMS
                                            ON EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID=EXPENSE_ITEMS.EXPENSE_ITEM_ID 
                                        GROUP BY EXPENSE_ID,EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME 
                                    ) AS 
                                    EXPENSE_ROW 
                                    WHERE (EXPENSE_ID = Results.EXPENSE_ID) 
                                    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
                                ,1,2,'') AS PRODUCTCAT
                                FROM (
                                        SELECT 
                                            EXPENSE_ID,EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME 
                                        FROM
                                            EXPENSE_ITEMS_ROWS  JOIN EXPENSE_ITEMS
                                            ON EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID=EXPENSE_ITEMS.EXPENSE_ITEM_ID 
                                        GROUP BY EXPENSE_ID,EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME 
                                    ) RESULTS
                                GROUP BY EXPENSE_ID
                            ) as BELGE_PRODUCT_CAT ON E.EXPENSE_ID = BELGE_PRODUCT_CAT.EXPENSE_ID
                        </cfif>
                    </cfif>
            WHERE
                    <cfif len(attributes.process_type)>
                    E.PROCESS_CAT IN (#attributes.process_type#) AND
                    <cfelse>
                        E.ACTION_TYPE IN (120) AND
                    </cfif>
                    <cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
                        ERD.EXPENSE_ID IS NOT NULL AND
                    <cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
                        ERD.EXPENSE_ID IS NULL AND
                    </cfif>
                    E.CH_COMPANY_ID IS NULL
                    AND E.CH_CONSUMER_ID IS NULL
                    <cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                        AND E.EXPENSE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                    </cfif>	
                    <cfif attributes.report_type eq 2>
                        <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                            AND E_ROW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                        </cfif>
                    <cfelse>
                        <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                            AND E.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                        </cfif>
                    </cfif>
                    <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
                        AND 1 = 2 <!--- şirket boş olanalr geleceğinden şirket seçili ise burdan kayıt gelmesin--->
                    </cfif>
                    <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
                        AND 1 = 2 <!--- şirket boş olanalr geleceğinden şirket seçili ise burdan kayıt gelmesin--->
                    </cfif>
                    <cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(attributes.ship_method_name)>
                        AND 1 = 2
                    </cfif>
                    <cfif len(attributes.category_id)>
                        AND 1 = 2 <!--- şirket boş olanalr geleceğinden kategori seçili ise burdan kayıt gelmesin--->
                    </cfif>
            UNION ALL        
            SELECT 
                    E.EXPENSE_ID  AS ACTION_ID,
                    E.PAPER_NO AS BELGE_NO,
                    E.SERIAL_NUMBER AS SERIAL_NUMBER,
                    E.SERIAL_NO AS SERIAL_NO,
                    E.EXPENSE_DATE AS ACTION_DATE,
                    E.TOTAL_AMOUNT_KDVLI AS NETTOTAL,
                    E.KDV_TOTAL AS TAXTOTAL, 
                    E.TOTAL_AMOUNT AS GROSSTOTAL,
                    E.BSMV_TOTAL AS BSMVTOTAL,
                    E.OIV_TOTAL AS OIVTOTAL,                                     
                    0 AS IS_TAX_OF_OTV,                    
                    0 AS SA_DISCOUNT,
                    0 AS ROUND_MONEY,
                    <!---ISNULL(E_ROW.AMOUNT_OTV,0) AS OTV_TOTAL,--->
                    E.ACTION_TYPE INVOICE_CAT,
                    E.ACC_DEPARTMENT_ID,
                    ISNULL(E_ROW.AMOUNT_OTV,0) AS OTVTOTAL,
                    E_ROW.OTV_RATE AS OTV_ORAN,
                    E_ROW.AMOUNT_OTV AS ROW_OTVTOTAL,
                    E_ROW.BSMV_RATE AS BSMV_ORAN,
                    E_ROW.AMOUNT_BSMV AS ROW_BSMVTOTAL,
                    E_ROW.OIV_RATE AS OIV_ORAN,
                    E_ROW.AMOUNT_OIV AS ROW_OIVTOTAL,
                    E_ROW.AMOUNT_KDV AS ROW_TAXTOTAL,
                    CAST(E_ROW.KDV_RATE AS FLOAT) AS TAX,
                    0 AS DISCOUNTTOTAL,
                    (E_ROW.AMOUNT*E_ROW.QUANTITY) AS KDVSIZ_TOPLAM,
                    <cfif attributes.report_type eq 2>
                        ' ' PRODUCT_NAME,
                        ' ' PRODUCT_NAME2,
                        E_ROW.DETAIL NOTE,
                    <cfelse>
                        E.DETAIL NOTE,
                    </cfif>
                    CASE 
                        WHEN C.COMPANY_ID IS NOT NULL THEN C.MEMBER_CODE
                        WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.MEMBER_CODE
                        else  ''
                    END AS Cari_Kod,
                    CASE 
                        WHEN C.COMPANY_ID IS NOT NULL THEN C.FULLNAME
                        WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.CONSUMER_NAME+ ' ' + CN.CONSUMER_SURNAME
                        else  ''
                    END AS Cari_Heasp,			
                    CASE 
                        WHEN C.COMPANY_ID IS NOT NULL THEN C.TAXOFFICE
                        WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.TAX_OFFICE
                        else  ''
                    END AS Vergi_Daire,
                    CASE 
                        WHEN C.COMPANY_ID IS NOT NULL THEN C.TAXNO
                        WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.TAX_NO
                        else  ''
                    END AS Vergi_No,
                    CASE 
                        WHEN C.COMPANY_ID IS NOT NULL THEN C.OZEL_KOD
                        WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.OZEL_KOD
                        else  ''
                    END AS OZEL_KOD,
                    CASE 
                        WHEN C.COMPANY_ID IS NOT NULL THEN CP.TC_IDENTITY
                        WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.TC_IDENTY_NO
                        else  ''
                    END AS TC_IDENTY_NO,
                    1 AS TYPE ,
                    SPC.PROCESS_CAT,
                    E.PROJECT_ID,
                    E_ROW.PROJECT_ID ROW_PROJECT_ID,
                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                        <cfloop from="1" to="40" index="i">
                        EXPENSE_ITEM_PLANS_INFO_PLUS.PROPERTY#i#  AS PROPERTY#i#,
                        </cfloop>
                    </cfif>
                    <cfif attributes.report_type eq 2>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                            E_ROW.QUANTITY ROW_QUANTITY,
                        </cfif>
                    </cfif>
                    <cfif attributes.report_type eq 1>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                            BELGE_MIKTAR.MIKTAR MIKTAR,
                        </cfif>
                    </cfif>
                    ISNULL(E_ROW.UNIT,'ADET') AS UNIT, 
                    EXPENSE_ITEMS.EXPENSE_ITEM_ID AS PRODUCT_CATID,
                    <cfif attributes.report_type eq 2>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,6)>
                            EXPENSE_ITEMS.EXPENSE_ITEM_NAME AS PRODUCT_CAT,
                        </cfif>
                    </cfif>
                    <cfif attributes.report_type eq 1>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,6)>
                            BELGE_PRODUCT_CAT.PRODUCTCAT ,
                        </cfif>
                    </cfif>
                    E.SYSTEM_RELATION REF_NO,
                    E.DUE_DATE,
                    0 DUEDATE
                    <cfif attributes.report_type eq 2>
                        ,E_ROW.EXPENSE_ITEM_ID AS PRODUCT_ID
                        ,EXPENSE_ITEMS.ACCOUNT_CODE AS ACCOUNT_CODE_PUR
                        ,ACPL.ACCOUNT_NAME AS ACC_NAME
                    </cfif>
                      <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>
                        <cfloop query="get_all_tax">
                          ,  TAX_LIST.[#filternum(tax)#] AS KDV_#filternum(tax)#
                        </cfloop> 
                    </cfif>
                    <cfif listfind(attributes.list_type,12)>
                        <cfloop query="get_all_otv">
                          ,  OTV_LIST.[#filternum(tax)#] AS OTV_#filternum(tax)#
                        </cfloop>         
                    </cfif>
                    <cfif listfind(attributes.list_type,13)>
                        <cfloop query="get_all_bsmv">
                          ,  BSMV_LIST.[#filternum(tax)#] AS BSMV_#filternum(tax)#
                        </cfloop>                       
                    </cfif>
                    <cfif listfind(attributes.list_type,14)>
                         <cfloop query="get_all_oiv">
                          ,  OIV_LIST.[#filternum(tax)#] AS OIV_#filternum(tax)#
                        </cfloop>                    
                    </cfif>
            FROM
                    EXPENSE_ITEM_PLANS E
                    JOIN EXPENSE_ITEMS_ROWS E_ROW
                        ON E.EXPENSE_ID=E_ROW.EXPENSE_ID
                    JOIN EXPENSE_ITEMS 
                        ON E_ROW.EXPENSE_ITEM_ID=EXPENSE_ITEMS.EXPENSE_ITEM_ID
                    LEFT JOIN #dsn_alias#.COMPANY AS c 
                        ON E.CH_COMPANY_ID = C.COMPANY_ID
                    LEFT JOIN #dsn_alias#.CONSUMER AS CN
                        ON CN.CONSUMER_ID = E.CH_CONSUMER_ID
                    JOIN #dsn3_alias#.SETUP_PROCESS_CAT AS spc
                        ON spc.PROCESS_CAT_ID = E.PROCESS_CAT
                    LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP 
                        ON CP.COMPANY_ID = C.COMPANY_ID AND C.MANAGER_PARTNER_ID = CP.PARTNER_ID
                    JOIN #dsn2_alias#.ACCOUNT_PLAN ACPL
                        ON ACPL.ACCOUNT_CODE = EXPENSE_ITEMS.ACCOUNT_CODE
                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                        LEFT JOIN EXPENSE_ITEM_PLANS_INFO_PLUS  ON E.EXPENSE_ID=EXPENSE_ITEM_PLANS_INFO_PLUS.EXPENSE_ID
                    </cfif>
                    <cfif len(attributes.use_efatura)>
                        LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
                    </cfif>
                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>
                        LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                            <cfloop query="get_all_tax">
                            ,  sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop>  
                            FROM
                            (SELECT EXP_ITEM_ROWS_ID,EXPENSE_ID,KDV_RATE,AMOUNT_KDV
                                FROM EXPENSE_ITEMS_ROWS
                        ) AS SourceTable
                            PIVOT
                            (
                            SUM(AMOUNT_KDV)
                            FOR KDV_RATE IN  (<cfloop query="get_all_tax">
                                         [#filternum(tax)#] <cfif currentrow neq get_all_tax.recordcount>,</cfif>
                                        </cfloop>  )
                            ) AS PivotTable
                            group BY
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                        ) <cfif attributes.report_type eq 1> AS TAX_LIST ON TAX_LIST.EXPENSE_ID = E.EXPENSE_ID </cfif>
                        <cfif attributes.report_type eq 2> AS TAX_LIST ON TAX_LIST.EXP_ITEM_ROWS_ID=E_ROW.EXP_ITEM_ROWS_ID </cfif>
                    </cfif>
                    <cfif listfind(attributes.list_type,12)>
                        LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                           <cfloop query="get_all_otv">
                            ,  sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop>  
                            FROM
                            (SELECT EXP_ITEM_ROWS_ID,EXPENSE_ID,OTV_RATE,AMOUNT_OTV
                                FROM EXPENSE_ITEMS_ROWS
                            ) AS SourceTable
                            <cfif get_all_otv.recordcount>
                            PIVOT
                            (
                            SUM(AMOUNT_OTV)
                            FOR OTV_RATE IN (<cfloop query="get_all_otv">
                                         [#filternum(tax)#] <cfif currentrow neq get_all_otv.recordcount>,</cfif>
                                        </cfloop>  )
                            ) AS PivotTable
                            </cfif>
                            group BY
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                        ) <cfif attributes.report_type eq 1>as OTV_LIST ON OTV_LIST.EXPENSE_ID = E.EXPENSE_ID</cfif>
                        <cfif attributes.report_type eq 2>as OTV_LIST ON OTV_LIST.EXP_ITEM_ROWS_ID = E_ROW.EXP_ITEM_ROWS_ID</cfif>
                    </cfif>
                    <cfif listfind(attributes.list_type,13)>
                        LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1>EXPENSE_ID</cfif>
                             <cfloop query="get_all_bsmv">
                            ,  sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop> 
                            FROM
                            (SELECT EXP_ITEM_ROWS_ID,EXPENSE_ID,BSMV_RATE,AMOUNT_BSMV
                                FROM EXPENSE_ITEMS_ROWS
                            ) AS SourceTable
                            <cfif get_all_bsmv.recordcount>
                            PIVOT
                            (
                            SUM(AMOUNT_BSMV)
                            FOR BSMV_RATE IN (<cfloop query="get_all_bsmv">
                                         [#filternum(tax)#] <cfif currentrow neq get_all_bsmv.recordcount>,</cfif>
                                        </cfloop>  )
                            ) AS PivotTable
                            </cfif>
                            group BY
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                        ) <cfif attributes.report_type eq 1>as BSMV_LIST ON BSMV_LIST.EXPENSE_ID = E.EXPENSE_ID</cfif>
                        <cfif attributes.report_type eq 2>as BSMV_LIST ON BSMV_LIST.EXP_ITEM_ROWS_ID = E_ROW.EXP_ITEM_ROWS_ID</cfif>
                    </cfif>
                    <cfif listfind(attributes.list_type,14)>
                        LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                             <cfloop query="get_all_oiv">
                            ,  sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop> 
                            FROM
                            (SELECT EXP_ITEM_ROWS_ID,EXPENSE_ID,OIV_RATE,AMOUNT_OIV
                                FROM EXPENSE_ITEMS_ROWS
                        ) AS SourceTable
                        <cfif get_all_oiv.recordcount>
                            PIVOT
                            (
                            SUM(AMOUNT_OIV)
                            FOR OIV_RATE IN (<cfloop query="get_all_oiv">
                                         [#filternum(tax)#] <cfif currentrow neq get_all_oiv.recordcount>,</cfif>
                                        </cfloop> )
                            ) AS PivotTable
                        </cfif>
                            group BY
                            <cfif attributes.report_type eq 2>EXP_ITEM_ROWS_ID</cfif>
                            <cfif attributes.report_type eq 1> EXPENSE_ID</cfif>
                        ) <cfif attributes.report_type eq 1> AS OIV_LIST ON OIV_LIST.EXPENSE_ID = E.EXPENSE_ID </cfif>
                        <cfif attributes.report_type eq 2> AS OIV_LIST ON OIV_LIST.EXP_ITEM_ROWS_ID=E_ROW.EXP_ITEM_ROWS_ID </cfif>
                    </cfif>
                    <cfif attributes.report_type eq 1>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                        LEFT JOIN
                            (
                                SELECT 
                                EXPENSE_ID,
                                STUFF((
                                    SELECT ', ' + CONVERT(NVARCHAR(50),AMOUNT) + ':' + CAST(UNIT AS VARCHAR(MAX))
                                    FROM 
                                    (
                                        SELECT 
                                            EXPENSE_ID,ISNULL(EXPENSE_ITEMS_ROWS.UNIT,'ADET') AS UNIT,SUM(QUANTITY) AS AMOUNT
                                        FROM
                                            EXPENSE_ITEMS_ROWS
                                        GROUP BY EXPENSE_ID,UNIT
                                    ) AS 
                                    EXPENSE_ITEMS_ROWS 
                                    WHERE (EXPENSE_ID = Results.EXPENSE_ID) 
                                    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
                                ,1,2,'') AS MIKTAR
                                FROM (
                                        SELECT 
                                            EXPENSE_ID,ISNULL(EXPENSE_ITEMS_ROWS.UNIT,'ADET') AS UNIT,SUM(QUANTITY) AS AMOUNT
                                        FROM
                                            EXPENSE_ITEMS_ROWS
                                        GROUP BY EXPENSE_ID,ISNULL(EXPENSE_ITEMS_ROWS.UNIT,'ADET')
                                    ) RESULTS
                                GROUP BY EXPENSE_ID
                            ) as BELGE_MIKTAR ON E.EXPENSE_ID = BELGE_MIKTAR.EXPENSE_ID
                        </cfif>
                    </cfif>
                    <cfif attributes.report_type eq 1>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8) or (listfind(attributes.list_type,6))>
                        LEFT JOIN 
                            (
                                SELECT 
                                EXPENSE_ID,
                                STUFF((
                                    SELECT ', ' + CONVERT(NVARCHAR(50),EXPENSE_ITEM_NAME)
                                    FROM 
                                    (
                                        SELECT 
                                            EXPENSE_ID,EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME  
                                        FROM
                                            EXPENSE_ITEMS_ROWS  JOIN EXPENSE_ITEMS
                                            ON EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID=EXPENSE_ITEMS.EXPENSE_ITEM_ID 
                                        GROUP BY EXPENSE_ID,EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME 
                                    ) AS 
                                    EXPENSE_ROW 
                                    WHERE (EXPENSE_ID = Results.EXPENSE_ID) 
                                    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
                                ,1,2,'') AS PRODUCTCAT
                                FROM (
                                        SELECT 
                                            EXPENSE_ID,EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME 
                                        FROM
                                            EXPENSE_ITEMS_ROWS  JOIN EXPENSE_ITEMS
                                            ON EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID=EXPENSE_ITEMS.EXPENSE_ITEM_ID 
                                        GROUP BY EXPENSE_ID,EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME 
                                    ) RESULTS
                                GROUP BY EXPENSE_ID
                            ) as BELGE_PRODUCT_CAT ON E.EXPENSE_ID = BELGE_PRODUCT_CAT.EXPENSE_ID
                        </cfif>
                    </cfif>
            WHERE
                        <cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
                            ERD.EXPENSE_ID IS NOT NULL AND
                        <cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
                            ERD.EXPENSE_ID IS NULL AND
                        </cfif>
                        <cfif len(attributes.process_type)>
                            E.PROCESS_CAT IN (#attributes.process_type#)
                        <cfelse>
                            E.ACTION_TYPE IN (120)
                        </cfif>
                        <cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                            AND E.EXPENSE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                        </cfif>	
                        <cfif attributes.report_type eq 2>
                            <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                                AND E_ROW.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                            </cfif>
                        <cfelse>
                            <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                                AND E.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                            </cfif>
                        </cfif>
                        
                        <cfif len(attributes.department_id)>
                            AND (
                            <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                (E.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND E.LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                                <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                            </cfloop>  
                            ) 
                        <cfelseif len(branch_dep_list)>
                            AND (E.DEPARTMENT_ID IN(#branch_dep_list#) OR E.DEPARTMENT_ID IS NULL)	
                        </cfif>
                        <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
                            AND E.CH_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                        </cfif>
                        <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
                            AND E.CH_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                        </cfif>
                        <cfif len(kurumsal)>
                            AND C.COMPANYCAT_ID IN (#kurumsal#)
                        </cfif>
                        <cfif len(bireysel)>
                            AND CN.CONSUMER_CAT_ID IN (#bireysel#)
                        </cfif>
                        AND (C.COMPANY_ID IS NOT NULL OR CN.CONSUMER_ID IS NOT NULL )

            UNION ALL                            
            SELECT
                    I.INVOICE_ID AS ACTION_ID,
                    I.INVOICE_NUMBER AS BELGE_NO,
                    I.SERIAL_NUMBER AS SERIAL_NUMBER,
                    I.SERIAL_NO AS SERIAL_NO,
                    I.INVOICE_DATE AS ACTION_DATE,
                    I.NETTOTAL,
                    I.TAXTOTAL,
                    I.GROSSTOTAL,
                    I.BSMV_TOTAL,
                    I.OIV_TOTAL,
                    I.IS_TAX_OF_OTV,                   
                    I.SA_DISCOUNT,
                    I.ROUND_MONEY,
                <!--- I.OTV_TOTAL AS OTV_TOTAL,--->
                    I.INVOICE_CAT,
                    I.ACC_DEPARTMENT_ID,
                    ISNULL(IR.OTVTOTAL,0) AS OTVTOTAL,
                    IR.OTV_ORAN,
                    IR.BSMV_RATE,
                    IR.BSMV_AMOUNT,
                    IR.OIV_RATE,
                    IR.OIV_AMOUNT,
                    CASE WHEN I.SA_DISCOUNT=0 THEN IR.OTVTOTAL ELSE ((1- I.SA_DISCOUNT/(I.NETTOTAL-I.OTV_TOTAL-I.TAXTOTAL+I.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_OTVTOTAL,
                    CASE WHEN I.SA_DISCOUNT=0 THEN IR.TAXTOTAL ELSE ((1- I.SA_DISCOUNT/(I.NETTOTAL-I.OTV_TOTAL-I.TAXTOTAL+I.SA_DISCOUNT))* IR.TAXTOTAL) END AS ROW_TAXTOTAL,
                    IR.TAX,
                    CASE WHEN I.SA_DISCOUNT=0 THEN IR.DISCOUNTTOTAL ELSE ((IR.AMOUNT*IR.PRICE)-((1- I.SA_DISCOUNT/(I.NETTOTAL-I.OTV_TOTAL-I.TAXTOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL)) END AS DISCOUNTTOTAL,
                    CASE WHEN I.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE ( (1- I.SA_DISCOUNT/(I.NETTOTAL-I.OTV_TOTAL-I.TAXTOTAL-I.BSMV_TOTAL-I.OIV_TOTAL+I.SA_DISCOUNT)) * IR.NETTOTAL ) END AS KDVSIZ_TOPLAM,
                    <cfif attributes.report_type eq 2>
                        IR.NAME_PRODUCT AS PRODUCT_NAME,
                        IR.PRODUCT_NAME2 AS PRODUCT_NAME2,
                        ' '  NOTE,
                    <cfelse>
                        I.NOTE NOTE,
                    </cfif>
                    CASE 
                        WHEN C.COMPANY_ID IS NOT NULL THEN C.MEMBER_CODE
                        WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.MEMBER_CODE
                        else  ''
                    END AS Cari_kod,
                    CASE 
                        WHEN C.COMPANY_ID IS NOT NULL THEN C.FULLNAME
                        WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.CONSUMER_NAME+ ' ' + CN.CONSUMER_SURNAME
                        else  ''
                    END AS Cari_Hesap,			
                    CASE 
                        WHEN C.COMPANY_ID IS NOT NULL THEN C.TAXOFFICE
                        WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.TAX_OFFICE
                        else  ''
                    END AS Vergi_Daire,
                    CASE 
                        WHEN C.COMPANY_ID IS NOT NULL THEN C.TAXNO
                        WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.TAX_NO
                        else  ''
                    END AS Vergi_No,
                    CASE 
                            WHEN C.COMPANY_ID IS NOT NULL THEN C.OZEL_KOD
                            WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.OZEL_KOD
                            else  ''
                    END AS OZEL_KOD,
                    CASE 
                            WHEN C.COMPANY_ID IS NOT NULL THEN CP.TC_IDENTITY
                            WHEN CN.CONSUMER_ID IS NOT NULL THEN CN.TC_IDENTY_NO
                            else  ''
                    END AS TC_IDENTY_NO,
                    0 AS TYPE,
                    SPC.PROCESS_CAT,
                    I.PROJECT_ID,
                    IR.ROW_PROJECT_ID,
                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                        <cfloop from="1" to="40" index="i">
                            INVOICE_INFO_PLUS.PROPERTY#i# AS PROPERTY#i#,
                        </cfloop>
                    </cfif>
                    
                    <cfif attributes.report_type eq 2>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                            IR.AMOUNT ROW_QUANTITY,
                        </cfif>
                    </cfif>
                    <cfif attributes.report_type eq 1>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                            BELGE_MIKTAR.MIKTAR MIKTAR,
                        </cfif>
                    </cfif>
                    ISNULL(IR.UNIT,'ADET') AS UNIT,
                    PC.PRODUCT_CATID,
                    <cfif attributes.report_type eq 2>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,6)>
                            PC.PRODUCT_CAT,
                        </cfif>
                    </cfif>
                    <cfif attributes.report_type eq 1>
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,6)>
                            BELGE_PRODUCT_CAT.PRODUCTCAT,
                        </cfif>
                    </cfif>
                    I.REF_NO,
                    I.DUE_DATE,
                    ISNULL(IR.DUE_DATE,0) AS DUEDATE
                    <cfif attributes.report_type eq 2>
                        ,IR.PRODUCT_ID AS PRODUCT_ID
                        ,pp.ACCOUNT_CODE_PUR
                        ,ACPL.ACCOUNT_NAME AS ACC_NAME
                    </cfif>
                     <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>
                        <cfloop query="get_all_tax">
                          ,  TAX_LIST.[#filternum(tax)#] AS KDV_#filternum(tax)#
                        </cfloop> 
                    </cfif>
                    <cfif listfind(attributes.list_type,12)>
                        <cfloop query="get_all_otv">
                          ,  OTV_LIST.[#filternum(tax)#] AS OTV_#filternum(tax)#
                        </cfloop>         
                    </cfif>
                    <cfif listfind(attributes.list_type,13)>
                        <cfloop query="get_all_bsmv">
                          ,  BSMV_LIST.[#filternum(tax)#] AS BSMV_#filternum(tax)#
                        </cfloop>                       
                    </cfif>
                    <cfif listfind(attributes.list_type,14)>
                         <cfloop query="get_all_oiv">
                          ,  OIV_LIST.[#filternum(tax)#] AS OIV_#filternum(tax)#
                        </cfloop>                    
                    </cfif>
            FROM   
                INVOICE  AS I
                JOIN INVOICE_ROW AS IR
                        ON  I.INVOICE_ID = IR.INVOICE_ID
                JOIN #dsn3_alias#.SETUP_PROCESS_CAT AS spc
                        ON  I.PROCESS_CAT = spc.PROCESS_CAT_ID
                LEFT JOIN #dsn_alias#.COMPANY AS C
                        ON C.COMPANY_ID = I.COMPANY_ID
                LEFT JOIN #dsn_alias#.CONSUMER AS CN
                        ON CN.CONSUMER_ID = I.CONSUMER_ID
                LEFT JOIN #dsn3_alias#.PRODUCT AS P
                        ON P.PRODUCT_ID = IR.PRODUCT_ID
                LEFT JOIN #dsn3_alias#.PRODUCT_CAT AS pc
                        ON PC.PRODUCT_CATID = P.PRODUCT_CATID
                LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP 
                        ON CP.COMPANY_ID = C.COMPANY_ID AND C.MANAGER_PARTNER_ID = CP.PARTNER_ID
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                    LEFT JOIN INVOICE_INFO_PLUS  ON I.INVOICE_ID=INVOICE_INFO_PLUS.INVOICE_ID
                </cfif>
                <cfif len(attributes.use_efatura)>
                    LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = I.INVOICE_ID
                </cfif>
                <cfif attributes.report_type eq 2>
                    LEFT JOIN #dsn3_alias#.PRODUCT_PERIOD pp on pp.PRODUCT_ID = IR.PRODUCT_ID AND PP.PERIOD_ID = #session.ep.period_id#
                    LEFT JOIN #dsn2_alias#.ACCOUNT_PLAN ACPL ON ACPL.ACCOUNT_CODE = PP.ACCOUNT_CODE_PUR
                </cfif>
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>
                    LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>INVOICE_ROW_ID</cfif>
                            <cfif attributes.report_type eq 1> INVOICE_ID</cfif>
                           <cfloop query="get_all_tax">
                                , sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop>
                            FROM
                            (SELECT IR.INVOICE_ROW_ID,IR.INVOICE_ID,TAX,CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.TAXTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL+INVOICE.SA_DISCOUNT))* IR.TAXTOTAL) END AS ROW_TAXTOTAL
                                FROM INVOICE_ROW IR JOIN INVOICE ON INVOICE.INVOICE_ID = IR.INVOICE_ID 
                            ) AS SourceTable
                            PIVOT
                            (
                            SUM(ROW_TAXTOTAL)
                            FOR TAX IN (<cfloop query="get_all_tax">
                                         [#filternum(tax)#] <cfif currentrow neq get_all_tax.recordcount>,</cfif>
                                        </cfloop>)
                            ) AS PivotTable
                            group BY
                            <cfif attributes.report_type eq 2>INVOICE_ROW_ID</cfif>
                            <cfif attributes.report_type eq 1> INVOICE_ID</cfif>
                        ) <cfif attributes.report_type eq 1> AS TAX_LIST ON TAX_LIST.INVOICE_ID = I.INVOICE_ID </cfif>
                        <cfif attributes.report_type eq 2> AS TAX_LIST ON TAX_LIST.INVOICE_ROW_ID=IR.INVOICE_ROW_ID </cfif>
                </cfif>
                <cfif listfind(attributes.list_type,12)>
                    LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>INVOICE_ROW_ID</cfif>
                            <cfif attributes.report_type eq 1> INVOICE_ID</cfif>
                            <cfloop query="get_all_otv">
                                , sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop>
                            FROM
                            (SELECT IR.INVOICE_ROW_ID,IR.INVOICE_ID, IR.OTV_ORAN,CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.OTVTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL+INVOICE.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_OTVTOTAL
                                FROM INVOICE_ROW IR JOIN INVOICE ON INVOICE.INVOICE_ID = IR.INVOICE_ID 
                            ) AS SourceTable
                            <cfif get_all_otv.recordcount>
                            PIVOT
                            (
                            SUM(ROW_OTVTOTAL)  FOR OTV_ORAN IN (<cfloop query="get_all_otv">
                                         [#filternum(tax)#] <cfif currentrow neq get_all_otv.recordcount>,</cfif>
                                        </cfloop> )
                        ) AS PivotTable
                        </cfif>
                        group BY
                        <cfif attributes.report_type eq 2>INVOICE_ROW_ID</cfif>
                        <cfif attributes.report_type eq 1> INVOICE_ID</cfif>
                        ) <cfif attributes.report_type eq 1>AS OTV_LIST ON OTV_LIST.INVOICE_ID = I.INVOICE_ID</cfif>
                        <cfif attributes.report_type eq 2>AS OTV_LIST ON OTV_LIST.INVOICE_ROW_ID = IR.INVOICE_ROW_ID</cfif>
                </cfif>
                <cfif listfind(attributes.list_type,13)>
                    LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>INVOICE_ROW_ID</cfif>
                            <cfif attributes.report_type eq 1> INVOICE_ID</cfif>
                            <cfloop query="get_all_bsmv">
                                , sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop>
                            FROM
                            (SELECT IR.INVOICE_ROW_ID,IR.INVOICE_ID, IR.BSMV_RATE,CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.BSMV_AMOUNT ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL+INVOICE.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_BSMVTOTAL
                                FROM INVOICE_ROW IR JOIN INVOICE ON INVOICE.INVOICE_ID = IR.INVOICE_ID 
                            ) AS SourceTable
                            <cfif get_all_bsmv.recordcount>
                            PIVOT
                            (
                            SUM(ROW_BSMVTOTAL)
                            FOR BSMV_RATE IN (<cfloop query="get_all_bsmv">
                                         [#filternum(tax)#] <cfif currentrow neq get_all_bsmv.recordcount>,</cfif>
                                        </cfloop>)
                        ) AS PivotTable
                        </cfif>
                        group BY
                        <cfif attributes.report_type eq 2>INVOICE_ROW_ID</cfif>
                        <cfif attributes.report_type eq 1> INVOICE_ID</cfif>
                        ) <cfif attributes.report_type eq 1>AS BSMV_LIST ON BSMV_LIST.INVOICE_ID = I.INVOICE_ID</cfif>
                        <cfif attributes.report_type eq 2>AS BSMV_LIST ON BSMV_LIST.INVOICE_ROW_ID = IR.INVOICE_ROW_ID</cfif>
                </cfif>
                <cfif listfind(attributes.list_type,14)>
                    LEFT JOIN
                        (
                            SELECT 
                            <cfif attributes.report_type eq 2>INVOICE_ROW_ID</cfif>
                            <cfif attributes.report_type eq 1> INVOICE_ID</cfif>
                            <cfloop query="get_all_oiv">
                                , sum([#filternum(tax)#]) as [#filternum(tax)#]
                            </cfloop>
                            FROM
                            (SELECT IR.INVOICE_ROW_ID,IR.INVOICE_ID, IR.OIV_RATE,CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.OIV_AMOUNT ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL-INVOICE.BSMV_TOTAL-INVOICE.OIV_TOTAL+INVOICE.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_OIVTOTAL
                                FROM INVOICE_ROW IR JOIN INVOICE ON INVOICE.INVOICE_ID = IR.INVOICE_ID 
                            ) AS SourceTable
                            <cfif get_all_oiv.recordcount>
                            PIVOT
                            (
                            SUM(ROW_OIVTOTAL)
                            FOR OIV_RATE IN (<cfloop query="get_all_oiv">
                                         [#filternum(tax)#] <cfif currentrow neq get_all_oiv.recordcount>,</cfif>
                                        </cfloop>)
                        ) AS PivotTable
                        </cfif>
                        group BY
                        <cfif attributes.report_type eq 2>INVOICE_ROW_ID</cfif>
                        <cfif attributes.report_type eq 1> INVOICE_ID</cfif>
                        ) <cfif attributes.report_type eq 1>AS OIV_LIST ON OIV_LIST.INVOICE_ID = I.INVOICE_ID</cfif>
                        <cfif attributes.report_type eq 2>AS OIV_LIST ON OIV_LIST.INVOICE_ROW_ID = IR.INVOICE_ROW_ID</cfif>
                </cfif>
                <cfif attributes.report_type eq 1>
                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                    LEFT JOIN
                        (
                            SELECT 
                            INVOICE_ID,
                            STUFF((
                                SELECT ', ' + CONVERT(NVARCHAR(50),AMOUNT) + ':' + CAST(UNIT AS VARCHAR(MAX)) 
                                FROM 
                                (
                                    SELECT 
                                        INVOICE_ID,ISNULL(INVOICE_ROW.UNIT,'ADET') AS UNIT,SUM(AMOUNT) AS AMOUNT
                                    FROM
                                        INVOICE_ROW
                                    GROUP BY INVOICE_ID,UNIT
                                ) AS 
                                INVOICE_ROW 
                                WHERE (INVOICE_ID = Results.INVOICE_ID) 
                                FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
                            ,1,2,'') AS MIKTAR
                            FROM (
                                    SELECT 
                                        INVOICE_ID,ISNULL(INVOICE_ROW.UNIT,'ADET') AS UNIT,SUM(AMOUNT) AS AMOUNT
                                    FROM
                                        INVOICE_ROW
                                    GROUP BY INVOICE_ID,ISNULL(INVOICE_ROW.UNIT,'ADET')
                                ) RESULTS
                            GROUP BY INVOICE_ID
                        ) as BELGE_MIKTAR ON I.INVOICE_ID = BELGE_MIKTAR.INVOICE_ID
                    </cfif>
                </cfif>
                <cfif attributes.report_type eq 1>
                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8) or (listfind(attributes.list_type,6))>
                    LEFT JOIN 
                        (
                            SELECT 
                            INVOICE_ID,
                            STUFF((
                                SELECT ', ' + CONVERT(NVARCHAR(50),PRODUCT_CAT)
                                FROM 
                                (
                                    SELECT 
                                        INVOICE_ID,INVOICE_ROW.PRODUCT_ID,PRC.PRODUCT_CAT AS PRODUCT_CAT 
                                    FROM
                                        INVOICE_ROW JOIN #dsn3#.PRODUCT P
                                        ON INVOICE_ROW.PRODUCT_ID=P.PRODUCT_ID 
                                        JOIN #dsn3#.PRODUCT_CAT AS PRC
                                        ON P.PRODUCT_CATID=PRC.PRODUCT_CATID
                                    GROUP BY INVOICE_ID,INVOICE_ROW.PRODUCT_ID,PRODUCT_CAT
                                ) AS 
                                INVOICE_ROW 
                                WHERE (INVOICE_ID = Results.INVOICE_ID) 
                                FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
                            ,1,2,'') AS PRODUCTCAT
                            FROM (
                                    SELECT 
                                        INVOICE_ID,INVOICE_ROW.PRODUCT_ID,PRC.PRODUCT_CAT AS PRODUCT_CAT 
                                    FROM
                                        INVOICE_ROW JOIN #dsn3#.PRODUCT P
                                        ON INVOICE_ROW.PRODUCT_ID=P.PRODUCT_ID 
                                        JOIN #dsn3#.PRODUCT_CAT AS PRC
                                        ON P.PRODUCT_CATID=PRC.PRODUCT_CATID
                                    GROUP BY INVOICE_ID,INVOICE_ROW.PRODUCT_ID,PRODUCT_CAT
                                ) RESULTS
                            GROUP BY INVOICE_ID

                        ) as BELGE_PRODUCT_CAT ON I.INVOICE_ID = BELGE_PRODUCT_CAT.INVOICE_ID
                    </cfif>
                </cfif>
            WHERE  
                <cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
                    ERD.INVOICE_ID IS NOT NULL AND 
                <cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
                    ERD.INVOICE_ID IS NULL AND
                </cfif>
                <cfif len(attributes.process_type)>
                    I.PROCESS_CAT IN (#attributes.process_type#)
                <cfelse>
                    I.INVOICE_CAT IN (51 ,54 ,55,59,591 ,592 ,60,61 ,63,64 ,65 ,68,690 ,691 ,601,49,65)
                </cfif>
                <cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
                    AND I.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
                </cfif>
                AND I.IS_IPTAL = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
                <cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                    AND I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                </cfif>	
                <cfif attributes.report_type eq 2>
                    <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                        AND IR.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                    </cfif>
                <cfelse>
                    <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                        AND I.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                    </cfif>
                </cfif>
                <cfif len(attributes.department_id)>
                    AND (
                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                        (I.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND I.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                    </cfloop>  
                    ) 
                <cfelseif len(branch_dep_list)>
                    AND I.DEPARTMENT_ID IN(#branch_dep_list#)	
                </cfif>
                <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
                    AND I.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                </cfif>
                <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
                    AND I.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                </cfif>
                <cfif len(kurumsal)>
                    AND C.COMPANYCAT_ID IN (#kurumsal#)
                </cfif>
                <cfif len(bireysel)>
                    AND CN.CONSUMER_CAT_ID IN (#bireysel#)
                </cfif>
                AND (C.COMPANY_ID IS NOT NULL OR CN.CONSUMER_ID IS NOT NULL )
        
            
        ) AS INV_PURCHASE 
        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,7)>
            LEFT JOIN #dsn_alias#.DEPARTMENT AS D ON D.DEPARTMENT_ID =  INV_PURCHASE.ACC_DEPARTMENT_ID
            LEFT JOIN #dsn_alias#.BRANCH B ON B.BRANCH_ID = D.BRANCH_ID
        </cfif>
        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,10)>
            LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = INV_PURCHASE.PROJECT_ID 
        </cfif>
        <cfif attributes.report_type eq 1>	
        GROUP BY
                SERIAL_NUMBER,
                SERIAL_NO
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,1)>
                    ,REF_NO
                </cfif>
                ,INV_PURCHASE.PROCESS_CAT
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,2)>
                    ,DUE_DATE
                </cfif>
                ,ACTION_DATE
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,3)>
                    ,INV_PURCHASE.OZEL_KOD
                </cfif>
                ,Cari_Kod
                ,Cari_Hesap
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,4)>
                <cfif attributes.report_type eq 2>
                        ,PRODUCT_NAME2
                        ,NOTE
                    <cfelse>
                    ,CAST (NOTE AS NVARCHAR(200) )
                    </cfif>
                </cfif>
                ,Vergi_Daire	
                ,Vergi_No
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,5)>
                    ,TC_IDENTY_NO
                </cfif>
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,6)>
                    ,PRODUCTCAT
                </cfif>
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,7)>
                    ,B.BRANCH_NAME + D.DEPARTMENT_HEAD
                </cfif>
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,10)>
                    ,PP.PROJECT_HEAD
                </cfif>         
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,8)>
                    ,MIKTAR
                </cfif>
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>
                    <cfloop query="get_all_tax">
                        ,KDV_#filternum(tax)#
                    </cfloop>
                </cfif>
                <cfif listfind(attributes.list_type,12)>
                    <cfloop query="get_all_otv">
                        ,OTV_#filternum(tax)#
                    </cfloop>
                </cfif> 
                <cfif listfind(attributes.list_type,13)>
                    <cfloop query="get_all_bsmv">
                        ,BSMV_#filternum(tax)#
                    </cfloop>
                </cfif>
                <cfif listfind(attributes.list_type,14)>
                    <cfloop query="get_all_oiv">
                        ,OIV_#filternum(tax)#
                    </cfloop>
                </cfif>
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                    <cfloop from="1" to="40" index="i">
                        ,cast(PROPERTY#i# as nvarchar(100))
                    </cfloop>
                </cfif>
                ,ACTION_ID
                ,INVOICE_CAT
                ,TYPE                       
        </cfif>
        ORDER BY 
            ACTION_DATE DESC,
            ACTION_ID,
            Cari_Hesap
    </cfquery> 
<cfelse>    
	<cfset get_invoice_detail.recordcount = 0 >
</cfif>
<cfif isdate(attributes.startdate)>
	<cfset attributes.startdate = dateformat(attributes.startdate, dateformat_style)>
</cfif>
<cfif isdate(attributes.finishdate)>
	<cfset attributes.finishdate = dateformat(attributes.finishdate, dateformat_style)>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_invoice_detail.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" action="" method="post">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='39405.Fatura Listesi Alışlar'></cfsavecontent>
<cf_report_list_search title="#title#">
    <cf_report_list_search_area>
        <div class="row">
			<div class="col col-12 col-xs-12">
				<div class="row formContent">
					<div class="row" type="row">
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'></label>
								<div class="col col-12 col-xs-12">
                                        <cfquery name="get_all_location" datasource="#DSN#">
                                            SELECT * FROM STOCKS_LOCATION
                                        </cfquery>						
                                        <select name="department_id" id="department_id" multiple style="width:170px; height:150px;">
                                            <cfoutput query="get_department">
                                            <optgroup label="#department_head#">
                                                <cfquery name="get_location" dbtype="query">
                                                    SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_department.department_id[currentrow]#">
                                                </cfquery>
                                                <cfif get_location.recordcount>
                                                <cfloop from="1" to="#get_location.recordcount#" index="s">
                                                    <option value="#department_id#-#get_location.location_id[s]#" <cfif listfind(attributes.department_id,'#department_id#-#get_location.location_id[s]#',',')>selected</cfif>>&nbsp;&nbsp;#get_location.comment[s]#</option>
                                                </cfloop>
                                                </cfif>
                                            </optgroup>					  
                                            </cfoutput>
                                        </select>
                                </div>
                            </div>
                            <div class="form-group">
                                	<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='39242.Müşteri Kat'></label>
							    <div class="col col-12 col-xs-12">
                                    <select name="category_id" id="category_id" style="width:170px;height:150px;" multiple="multiple">
                                        <optgroup label="<cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'>">
                                            <cfoutput query="get_comp_category">
                                                <option value="1-#category_id#"  <cfif listfind(attributes.category_id,'1-#category_id#')>selected</cfif>>&nbsp;&nbsp;#category_name#</option>
                                            </cfoutput>
                                        </optgroup>
                                        <optgroup label="<cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'>">
                                            <cfoutput query="get_cons_category">
                                                <option value="2-#category_id#"  <cfif listfind(attributes.category_id,'2-#category_id#')>selected</cfif>>&nbsp;&nbsp;#category_name#</option>
                                            </cfoutput>
                                        </optgroup>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
                                <div class="col col-12 col-xs-12">
                                    <select name="process_type" id="process_type" style="width:170px;height:150px;" multiple>
                                        <cfoutput query="get_process_cat">
                                            <option value="#process_cat_id#" <cfif listfind(attributes.process_type,process_cat_id,',')>selected</cfif>>#process_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57509.Liste"> <cf_get_lang dictionary_id="38937.Tipi"></label>
                                <div class="col  col-12 col-xs-12">
                                    <select name="list_type" id="list_type" style="width:170px;height:150px;" multiple>
                                        <option value="1" <cfif listfind(attributes.list_type,1)>selected</cfif>><cf_get_lang dictionary_id='58794.Referans No'></option>
                                        <option value="2" <cfif listfind(attributes.list_type,2)>selected</cfif>><cf_get_lang dictionary_id='57881.Vade Tarihi'></option>
                                        <option value="3" <cfif listfind(attributes.list_type,3)>selected</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'></option>
                                        <option value="4" <cfif listfind(attributes.list_type,4)>selected</cfif>><cf_get_lang dictionary_id='57629.Açıklama'></option>
                                        <option value="5" <cfif listfind(attributes.list_type,5)>selected</cfif>><cf_get_lang dictionary_id='58025.TC Kimlik No'></option>
                                        <option value="6" <cfif listfind(attributes.list_type,6)>selected</cfif>><cf_get_lang dictionary_id='57486.Kategori'></option>
                                        <option value="7" <cfif listfind(attributes.list_type,7)>selected</cfif>><cf_get_lang dictionary_id='38956.Şube /Departman'></option>
                                        <option value="8" <cfif listfind(attributes.list_type,8)>selected</cfif>><cf_get_lang dictionary_id='57635.Miktar'></option>
                                        <option value="9" <cfif listfind(attributes.list_type,9)>selected</cfif>><cf_get_lang dictionary_id='57639.KDV'></option>
                                        <option value="12" <cfif listfind(attributes.list_type,12)>selected</cfif>><cf_get_lang dictionary_id='58021.ÖTV'></option>
                                        <option value="10" <cfif listfind(attributes.list_type,10)>selected</cfif>><cf_get_lang dictionary_id='57416.Proje'></option>
                                        <option value="11" <cfif listfind(attributes.list_type,11)>selected</cfif>><cf_get_lang dictionary_id='57810.Ek Bilgi'></option>
                                        <option value="13" <cfif listfind(attributes.list_type,13)>selected</cfif>><cf_get_lang dictionary_id='50923.BSMV'></option>
                                        <option value="14" <cfif listfind(attributes.list_type,14)>selected</cfif>><cf_get_lang dictionary_id='50982.OIV'></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                <div class="col col-12 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="company_id" id="company_id"  value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                        <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                        <input type="text" name="company" id="company" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','form','3','250');" autocomplete="off" style="width:154px;" value="<cfif isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" >
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=form.company&field_comp_id=form.company_id&field_name=form.company&field_consumer=form.consumer_id&select_list=2,3&keyword='+encodeURIComponent(document.form.company.value),'list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></label>
                                <div class="col col-12 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
                                        <input type="text" name="ship_method_name" id="ship_method_name" style="width:154px;" value="<cfif isdefined("attributes.ship_method_name") and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','125');" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=form.ship_method_name&field_id=form.ship_method_id','list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-12 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                        <input type="text" name="project_head" id="project_head" style="width:154px;" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_head');"> </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
                                <div class="col col-12 col-xs-12">
                                    <select name="report_type" id="report_type" style="width:154px;" onchange="kontrol_report();">
                                        <option value="1"<cfif isDefined('attributes.report_type') and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                                        <option value="2"<cfif isDefined('attributes.report_type') and attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <cfif session.ep.our_company_info.is_efatura>
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29872.E-Fatura'></label>
                                <div class="col col-12 col-xs-12">
                                    <select name="use_efatura" id="use_efatura" style="width:154px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="1" <cfif attributes.use_efatura eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='29492.Kullanıyor'></option>
                                        <option value="0" <cfif attributes.use_efatura eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='29493.Kullanmıyor'></option>
                                    </select>
                                </div>
                                </cfif>	
                            </div>
                            <div class="form-group">
                                    <label class="col  col-12 col-xs-12"><cf_get_lang dictionary_id ='57742.Tarih'>*</label>
                                <div class="col col-6">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                        <cfinput type="text" name="startdate" id="startdate" value="#attributes.startdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                    </div>
                                </div>
                                <div class="col col-6">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                        <cfinput type="text" name="finishdate" id="finishdate" value="#attributes.finishdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                    </div>	
                                </div>
                            </div>
                            <div class="form-group">                
                                <label id="inv_total"<cfif attributes.report_type eq 1>style="display:none;"</cfif>><cf_get_lang dictionary_id ='40652.Fatura Toplam Göster'><input type="checkbox" name="is_inv_total" id="is_inv_total" value="1" <cfif isdefined("attributes.is_inv_total")>checked</cfif>></label>
                                <label id="tevkifat_total" <cfif attributes.report_type eq 2>style="display:none;"</cfif>>
                                    <input type="checkbox" name="is_tevkifat" id="is_tevkifat" value="1" <cfif isdefined("attributes.is_tevkifat")>checked</cfif>><cf_get_lang dictionary_id ='40653.Tevkifat Göster'>				
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row ReportContentBorder">
					<div class="ReportContentFooter">
                        <label><cf_get_lang dictionary_id ='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1"<cfif attributes.is_excel eq 1>selected</cfif>></label>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#"  required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">  
                        <input type="hidden" name="form_varmi" id="form_varmi" value="1">
                        <cf_wrk_report_search_button  insert_info='#message#' is_excel='1' button_type='1' search_function='control()'>
                    </div>
                </div>
            </div>
        </div>
    </cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_invoice_detail.recordcount>
</cfif>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset filename="invoice_list_purchase_new#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="content-type" content="text/html; charset=utf-16">     
</cfif>
<cfif isdefined("attributes.form_varmi")>
    <cfif isdate(attributes.startdate)>
        <cfset attributes.startdate_ = dateformat(attributes.startdate, dateformat_style)>
    </cfif>
    <cfif isdate(attributes.finishdate)>
        <cfset attributes.finishdate_ = dateformat(attributes.finishdate, dateformat_style)>
    </cfif>
    <cfquery name="get_invoice_taxes" datasource="#dsn2#">
        SELECT 
            IT.* 
        FROM 
            INVOICE_TAXES IT,
            INVOICE
        WHERE 
            INVOICE.INVOICE_ID = IT.INVOICE_ID
            <cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
                AND INVOICE.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
            </cfif>
            <cfif isDefined("attributes.startdate_") and isdate(attributes.startdate_) and isDefined("attributes.finishdate_") and isdate(attributes.finishdate_)>
                AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate_#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate_#">
            </cfif>	
            <cfif len(attributes.department_id)>
                AND (
                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                    (INVOICE.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND INVOICE.DEPARTMENT_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                </cfloop>  
                ) 
            <cfelseif len(branch_dep_list)>
                AND INVOICE.DEPARTMENT_ID IN(#branch_dep_list#)	
            </cfif>
    </cfquery>
    <cfscript>
        for(xx=1; xx lte listlen(tax_list); xx=xx+1)
        {
            'beyan_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
            'tevkifat_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
            'expense_tevkifat_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
            'expense_beyan_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
        }
    </cfscript>
    <cfoutput query="get_invoice_taxes">
        <cfset "tax_beyan_#invoice_id#_#tax#" = BEYAN_TUTAR>
        <cfset "tax_tevkifat_#invoice_id#_#tax#" = TEVKIFAT_TUTAR>
    </cfoutput>
    <cf_report_list>
        <thead>
            <cfif isdefined("attributes.is_tevkifat")>
                <tr> 
                    <cfset tevk_head_1 = 8>
                    <cfif listfind(attributes.list_type,1)>
                        <cfset tevk_head_1 = tevk_head_1 + 1>
                    </cfif>
                    <cfif listfind(attributes.list_type,2)>
                        <cfset tevk_head_1 = tevk_head_1 + 1>
                    </cfif>
                    <cfif listfind(attributes.list_type,3)>
                        <cfset tevk_head_1 = tevk_head_1 + 1>
                    </cfif>
                    <cfif listfind(attributes.list_type,4)>
                        <cfset tevk_head_1 = tevk_head_1 + 1>
                    </cfif>
                    <cfif listfind(attributes.list_type,5)>
                        <cfset tevk_head_1 = tevk_head_1 + 1>
                    </cfif>
                    <cfif listfind(attributes.list_type,6)>
                        <cfset tevk_head_1 = tevk_head_1 + 1>
                    </cfif>
                    <cfif listfind(attributes.list_type,7)>
                        <cfset tevk_head_1 = tevk_head_1 + 1>
                    </cfif>
                    <cfif listfind(attributes.list_type,10)>
                        <cfset tevk_head_1 = tevk_head_1 + 1>
                    </cfif>
                    <cfif listfind(attributes.list_type,11)>
                        <cfset tevk_head_1 = tevk_head_1 + get_add_info_name.recordcount>
                    </cfif>
                    <cfif listfind(attributes.list_type,8)>
                        <cfset tevk_head_1 = tevk_head_1 + 1>
                    </cfif>
                    <cfif attributes.report_type eq 2>
                        <cfset tevk_head_1 = tevk_head_1 + 1>
                    </cfif>
                    <cfif listfind(attributes.list_type,9)>
                        <cfset tevk_head_1 = tevk_head_1 + get_all_tax.recordcount>
                    </cfif>
                    <th colspan="<cfoutput>#tevk_head_1#</cfoutput>"></th>
                    <cfif listfind(attributes.list_type,9)>
                        <th colspan = "<cfoutput>#ListLen(tax_list)#</cfoutput>">Tevkifat Tutar</th>
                        <th colspan = "<cfoutput>#ListLen(tax_list)#</cfoutput>">Beyan edilen Tutar</th>
                    </cfif>
                    <cfset tevk_head_2 = 8>                   
                    <cfif listfind(attributes.list_type,12)>
                        <cfset tevk_head_2 = tevk_head_2 + get_all_otv.recordcount>
                    </cfif>
                    <cfif listfind(attributes.list_type,13)>
                        <cfset tevk_head_2 = tevk_head_2 + get_all_bsmv.recordcount>
                    </cfif>
                    <cfif listfind(attributes.list_type,14)>
                        <cfset tevk_head_2 = tevk_head_2 + get_all_oiv.recordcount>
                    </cfif>
                    <cfif attributes.report_type eq 1>
                        <cfset tevk_head_2 = tevk_head_2 + 3>
                    </cfif>
                    <th colspan="<cfoutput>#tevk_head_2#</cfoutput>"></th>
                </tr>
            </cfif>       
            <tr> 
                <cfset colspan = 0>
                <cfif attributes.report_type eq 1>
                    <th ><cf_get_lang dictionary_id='57637.Seri No'></th><cfset colspan = colspan+1>
                    <th ><cf_get_lang dictionary_id='58133.Fatura No'></th><cfset colspan = colspan+1>
                    <cfif listfind(attributes.list_type,1)>
                        <th><cf_get_lang dictionary_id='58794.Referans No'></th>
                        <cfset colspan = colspan+1>
                    </cfif>
                    <th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th><cfset colspan = colspan+1>
                    <cfif listfind(attributes.list_type,2)>
                        <th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th><cfset colspan = colspan+1>
                    </cfif>
                    <th width="150"><cf_get_lang dictionary_id='57742.Tarih'></th><cfset colspan = colspan+1>
                    <cfif listfind(attributes.list_type,3)>
                        <th><cf_get_lang dictionary_id='57789.Özel Kod'></th><cfset colspan = colspan+1>
                    </cfif>
                    <th><cf_get_lang dictionary_id='57519.Cari Hesap'><cf_get_lang dictionary_id='57487.No'></th><cfset colspan = colspan+1>
                    <th><cf_get_lang dictionary_id='57519.Cari Hesap'></th><cfset colspan = colspan+1>
                    <cfif listfind(attributes.list_type,4)>
                        <th><cf_get_lang dictionary_id ='57629.Açıklama'></th><cfset colspan = colspan+1>
                    </cfif>
                    <th><cf_get_lang dictionary_id='58762.Vergi Dairesi'></th><cfset colspan = colspan+1>
                    <th><cf_get_lang dictionary_id='57752.Vergi No'></th><cfset colspan = colspan+1>
                    <cfif listfind(attributes.list_type,5)>
                    <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th><cfset colspan = colspan+1>
                    </cfif>
                    <cfif listfind(attributes.list_type,6)>
                        <th><cf_get_lang dictionary_id ='57486.Kategori'></th><cfset colspan = colspan+1>
                    </cfif>
                    <cfif listfind(attributes.list_type,7)>
                        <th><cf_get_lang dictionary_id='38956.Şube /Departman'></th><cfset colspan = colspan+1>
                    </cfif>
                    <cfif listfind(attributes.list_type,10)>
                        <th><cf_get_lang dictionary_id='57416.Proje'></th><cfset colspan = colspan+1>
                    </cfif>
                    <cfif listfind(attributes.list_type,11)>
                        <cfset list_info_purchase = valuelist(get_add_info_name.property)>
							<cfloop from="1" to="#listlen(list_info_purchase)#" index="i">
								<th width="200">
									<cf_get_lang dictionary_id='57810.Ek Bilgi'><cfoutput>#i#</cfoutput>
								</th><cfset colspan = colspan+1>
                        </cfloop>
                    </cfif>
                    <cfif listfind(attributes.list_type,8)><!--- belge bazında birimlere gore toplu miktarlar getiriliyor --->
                        <th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th><cfset colspan = colspan+1>
                    </cfif>
                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>
                        <cfloop list="#tax_list#" index="tax_t">
                            <th width="60" nowrap="nowrap"><cfoutput>%#NumberFormat(tax_t)#<cf_get_lang dictionary_id='57639.KDV'></cfoutput></th><cfset colspan = colspan+1>
                        </cfloop> 
                        <cfif isdefined("attributes.is_tevkifat")>
                            <cfloop list="#tax_list#" index="tax_t">
                                <th width="60" nowrap="nowrap"><cfoutput>%#NumberFormat(tax_t)#</cfoutput></th>
                                <cfset colspan = colspan+1>
                            </cfloop>
                            <cfloop list="#tax_list#" index="tax_t">
                                <th width="60" nowrap="nowrap"><cfoutput>%#NumberFormat(tax_t)#</cfoutput></th>
                                <cfset colspan = colspan+1>
                            </cfloop>
                        </cfif>              
                    </cfif>
                    <cfif listfind(attributes.list_type,12)>
                        <cfloop query="get_all_otv">
                             <th><cfoutput>%#tax# </cfoutput><cf_get_lang dictionary_id="58021.ötv"></th><cfset colspan = colspan+1>
                        </cfloop>
                    </cfif>
                    <cfif listfind(attributes.list_type,13)>
                         <cfloop query="get_all_bsmv">
                             <th><cfoutput>%#filternum(tax)# </cfoutput><cf_get_lang dictionary_id="50923.BSMV"></th><cfset colspan = colspan+1>
                        </cfloop>
                    </cfif>
                    <cfif listfind(attributes.list_type,14)>
                         <cfloop query="get_all_oiv">
                             <th><cfoutput>%#tax# </cfoutput><cf_get_lang dictionary_id="50982.oiv"></th><cfset colspan = colspan+1>
                        </cfloop>
                    </cfif>
                    <th><cf_get_lang dictionary_id='39067.Kdv siz Toplam'></th>
                    <th><cf_get_lang dictionary_id='57678.Fatura Altı İnd'></th>
                    <th><cf_get_lang dictionary_id='57710.Yuvarlama'></th>
                    <th><cf_get_lang dictionary_id='57649.Toplam İnd'></th>
                    <th><cf_get_lang dictionary_id='39420.İnd Sonrası Kdv siz Toplam'></th>
                    <th><cf_get_lang dictionary_id='58021.ÖTV'><cf_get_lang dictionary_id ='57492.Toplam'></th>
                    <th><cf_get_lang dictionary_id='40374.ÖTV nin KDV Toplamı'></th>
                    <th><cf_get_lang dictionary_id='57643.Kdv Toplam'></th>
                    <th><cf_get_lang dictionary_id='50923.BSMV'><cf_get_lang dictionary_id ='57492.Toplam'></th>
                    <th><cf_get_lang dictionary_id='50982.OIV'><cf_get_lang dictionary_id ='57492.Toplam'></th>
                    <th><cf_get_lang dictionary_id='57680.Genel Toplam'></th>  
                    <cfset col_extra=colspan+11>
                <cfelseif attributes.report_type eq 2>
                    <th><cf_get_lang dictionary_id='57637.Seri No'></th><cfset colspan = colspan+1>
                    <th><cf_get_lang dictionary_id='58133.Fatura No'></th><cfset colspan = colspan+1>
                    <cfif listfind(attributes.list_type,1)>
                        <th><cf_get_lang dictionary_id='58794.Referans No'></th><cfset colspan = colspan+1>
                    </cfif>
                    <th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th><cfset colspan = colspan+1>
                    <cfif listfind(attributes.list_type,2)>
                        <th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th><cfset colspan = colspan+1>
                    </cfif>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th><cfset colspan = colspan+1>
                    <cfif listfind(attributes.list_type,3)>
                        <th><cf_get_lang dictionary_id='57789.Özel Kod'></th><cfset colspan = colspan+1>
                    </cfif>
                    <th><cf_get_lang dictionary_id='57519.Cari Hesap'><cf_get_lang dictionary_id='57487.No'></th><cfset colspan = colspan+1>
                    <th><cf_get_lang dictionary_id='57519.Cari Hesap'></th><cfset colspan = colspan+1>
                    <th><cf_get_lang dictionary_id='58221.Ürün Adı'></th><cfset colspan = colspan+1>
                    <cfif listfind(attributes.list_type,4)>
                        <th><cf_get_lang dictionary_id ='57629.Açıklama'></th><cfset colspan = colspan+1>
                    </cfif>
                    <th><cf_get_lang dictionary_id='58762.Vergi Dairesi'></th><cfset colspan = colspan+1>
                    <th><cf_get_lang dictionary_id='57752.Vergi No'></th><cfset colspan = colspan+1>
                    <cfif listfind(attributes.list_type,5)>
                    <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th><cfset colspan = colspan+1>
                    </cfif>
                    <cfif listfind(attributes.list_type,6)>
                        <th><cf_get_lang dictionary_id ='57486.Kategori'></th><cfset colspan = colspan+1>
                    </cfif>
                    <cfif listfind(attributes.list_type,7)>
                        <th><cf_get_lang dictionary_id='38956.Şube /Departman'></th><cfset colspan = colspan+1>
                    </cfif>
                    <cfif listfind(attributes.list_type,10)>
                        <th><cf_get_lang dictionary_id='57416.Proje'></th><cfset colspan = colspan+1>
                    </cfif>
                    <cfif listfind(attributes.list_type,11)>
                        <cfloop query="get_add_info_name">
                            <th>
                                <cfoutput>#listgetat(PROPERTY,1,'_')#</cfoutput>
                            </th><cfset colspan = colspan+1>
                        </cfloop>
                    </cfif>
                    <cfif listfind(attributes.list_type,8)><!--- belge bazında birimlere gore toplu miktarlar getiriliyor --->
                        <th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th><cfset colspan = colspan+1>
                    </cfif>
                    <th><cf_get_lang dictionary_id ='38889.Hesap Kodu'></th><cfset colspan = colspan+1>
                    <th><cf_get_lang dictionary_id ='38890.Hesap Adı'></th><cfset colspan = colspan+1>
                    <cfif listfind(attributes.list_type,9)>
                        <cfloop list="#tax_list#" index="tax_t">
                            <th width="60" nowrap="nowrap"><cfoutput>%#NumberFormat(tax_t)#<cf_get_lang dictionary_id='57639.KDV'></cfoutput></th><cfset colspan = colspan+1>
                        </cfloop> 
                        <cfif isdefined("attributes.is_tevkifat")>
                            <cfloop list="#tax_list#" index="tax_t">
                                <th width="60" nowrap="nowrap"><cfoutput>%#NumberFormat(tax_t)#</cfoutput></th>
                                <cfset colspan = colspan+1>
                            </cfloop>
                            <cfloop list="#tax_list#" index="tax_t">
                                <th width="60" nowrap="nowrap"><cfoutput>%#NumberFormat(tax_t)#</cfoutput></th>
                                <cfset colspan = colspan+1>
                            </cfloop>
                        </cfif>          
                    </cfif>
                    <cfif listfind(attributes.list_type,12)>
                         <cfloop query="get_all_otv">
                             <th><cfoutput>%#filternum(tax)# </cfoutput><cf_get_lang dictionary_id="58021.ötv"></th><cfset colspan = colspan+1>
                        </cfloop>
                    </cfif>
                    <cfif listfind(attributes.list_type,13)>
                        <cfloop query="get_all_bsmv">
                             <th><cfoutput>%#filternum(tax)# </cfoutput><cf_get_lang dictionary_id="50923.bsmv"></th><cfset colspan = colspan+1>
                        </cfloop>
                    </cfif>
                    <cfif listfind(attributes.list_type,14)>
                         <cfloop query="get_all_oiv">
                             <th><cfoutput>%#filternum(tax)# </cfoutput><cf_get_lang dictionary_id="50982.OIV"></th><cfset colspan = colspan+1>
                        </cfloop>   
                    </cfif>
                    <cfset col_extra=colspan+8>
                    <th><cf_get_lang dictionary_id='57649.Toplam İnd'></th>
                    <th><cf_get_lang dictionary_id='39420.İnd Sonrası Kdv siz Toplam'></th>
                    <th><cf_get_lang dictionary_id='58021.ÖTV'><cf_get_lang dictionary_id ='57492.Toplam'></th>
                    <th><cf_get_lang dictionary_id='40374.ÖTV nin KDV Toplamı'></th>
                    <th><cf_get_lang dictionary_id='57643.Kdv Toplam'></th>
                    <th><cf_get_lang dictionary_id='50923.BSMV'><cf_get_lang dictionary_id ='57492.Toplam'></th>
                    <th><cf_get_lang dictionary_id='50982.OIV'><cf_get_lang dictionary_id ='57492.Toplam'></th>
                    <th><cf_get_lang dictionary_id='57680.Genel Toplam'></th>                   
                </cfif>
            </tr>
        </thead>   
        <tbody>
            <cfif isdefined("attributes.form_varmi")>
                <cfif get_invoice_detail.recordcount>
                    <cfoutput query="get_invoice_detail" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif attributes.report_type eq 1>
                            <tr>
                                <td>#serial_number#</td>
                                <td style='mso-number-format:"\@"'>
                                    <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
                                        #serial_no#
                                    <cfelse>
                                        <cfif invoice_cat eq 592>
                                            <a href="#request.self#?fuseaction=invoice.form_upd_marketplace_bill&iid=#action_id#">#serial_no#</a>
                                        <cfelse>
                                            <cfif invoice_cat eq 65>
                                                <a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#action_id#">#serial_no#</a>
                                            <cfelseif invoice_cat eq 66>            
                                                <a href="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#action_id#">#serial_no#</a>
                                            <cfelseif invoice_cat eq 120>
                                                <a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#action_id#">#serial_no#</a>
                                            <cfelse>
                                                <a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#action_id#">#serial_no#</a>
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </td>
                                <cfif listfind(attributes.list_type,1)><td>#ref_no#</td></cfif>
                                <td>#process_cat#</td>
                                <cfif listfind(attributes.list_type,2)>
                                <td>#dateformat(DUE_DATE,dateformat_style)#</td>
                                </cfif>
                                <td>#dateformat(ACTION_DATE,dateformat_style)#</td>
                                <cfif listfind(attributes.list_type,3)><td>#ozel_kod#</td></cfif>
                                <td>#Cari_Kod#</td>
                                <td width="250">#Cari_Hesap#</td>
                                <cfif listfind(attributes.list_type,4)><td>#note#</td></cfif>
                                <td>#Vergi_Daire#</td>
                                <td>#Vergi_No#</td>
                                <cfif listfind(attributes.list_type,5)><td>#TC_IDENTY_NO#</td></cfif>
                                <cfif listfind(attributes.list_type,6)><td nowrap="nowrap">#PRODUCTCAT#</td></cfif>
                                <cfif listfind(attributes.list_type,7)><td>#SUBE_DEPO#</td></cfif>
                                <cfif listfind(attributes.list_type,10)><td>#PROJECT_HEAD#</td></cfif>
                                <cfif listfind(attributes.list_type,11)>
                                    <cfloop query="get_add_info_name">
                                        <td>
                                            #evaluate("get_invoice_detail.#listgetat(PROPERTY,1,'_')#")#
                                        </td>
                                    </cfloop>
                                </cfif>                        
                                <cfif listfind(attributes.list_type,8)>
                                    <td nowrap="nowrap" width="230" style="text-align:right;"><!--- birim bazında miktar toplamları --->
                                        #MIKTAR#
                                    </td>
                                </cfif>
                                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>       
                                    <cfloop query="get_all_tax">
                                        <td>#tlformat(get_invoice_detail["kdv_#filternum(get_all_tax.tax)#"][get_invoice_detail.currentrow])#</td>
                                    </cfloop>       
                                    <!--- <cfloop list="#tax_list#" index="tax_ii">
                                        <cfset tax_count=NumberFormat(tax_ii)>
                                        <td style="text-align:right" format="numeric">
                                            <cfif isdefined('kdv_toplam_#tax_count#_#action_id#_#type#') and len(evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))>
                                                #TLFormat(evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))#
                                                <cfset 'kdv_genel_toplam_#tax_count#' = evaluate('kdv_genel_toplam_#tax_count#') + (evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))>
                                            </cfif>
                                        </td>
                                    </cfloop> --->
                                    <cfif isdefined("attributes.is_tevkifat")>    
                                        <cfif invoice_cat eq 120>
                                            <cfset get_expense_tevk = InvoiceSale.get_expense_tevk(expense_id : action_id)>
                                            <cfset total_tevkifat = 0>
                                            <cfset total_beyan = 0>
                                            <cfloop query="get_all_tax">
                                                <cfset tax_count=NumberFormat(get_all_tax.tax)>
                                                <td style="text-align:right" format="numeric">
                                                    <cfif len(get_invoice_detail["kdv_#filternum(get_all_tax.tax)#"][get_invoice_detail.currentrow]) and len(get_expense_tevk.TEVKIFAT_ORAN)>
                                                        <cfset 'expense_tevkifat_#tax_count#' = get_invoice_detail["kdv_#filternum(get_all_tax.tax)#"][get_invoice_detail.currentrow]-(get_invoice_detail["kdv_#filternum(get_all_tax.tax)#"][get_invoice_detail.currentrow]*get_expense_tevk.TEVKIFAT_ORAN)>
                                                        #TLFormat(evaluate('expense_tevkifat_#tax_count#'))#
                                                        <cfset 'expense_tevkifat_toplam_#tax_count#' = evaluate('expense_tevkifat_toplam_#tax_count#') + evaluate('expense_tevkifat_#tax#')>                                                       
                                                        
                                                    </cfif>                                                    
                                                </td>
                                            </cfloop>
                                            <cfloop query="get_all_tax">
                                                <td style="text-align:right" format="numeric">
                                                    <cfif len(get_invoice_detail["kdv_#filternum(get_all_tax.tax)#"][get_invoice_detail.currentrow]) and len(get_expense_tevk.TEVKIFAT_ORAN)>
                                                        <cfset 'expense_beyan_#tax_count#' =get_invoice_detail["kdv_#filternum(get_all_tax.tax)#"][get_invoice_detail.currentrow]*get_expense_tevk.TEVKIFAT_ORAN>
                                                        #TLFormat(evaluate('expense_beyan_#tax_count#'))#
                                                        <cfset 'expense_beyan_toplam_#tax_count#' = evaluate('expense_beyan_toplam_#tax_count#') + evaluate('expense_beyan_#tax_count#')>                                                       
                                                    </cfif> 
                                                </td>
                                            </cfloop>  
                                        <cfelse>    
                                            <cfloop list="#tax_list#" index="tax_ii">
                                                <cfset tax_count=NumberFormat(tax_ii)>
                                                <td style="text-align:right" format="numeric">                                           
                                                    <cfif type eq 0 and isdefined('tax_tevkifat_#action_id#_#tax_count#') and len(evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
                                                        #TLFormat(evaluate('tax_tevkifat_#action_id#_#tax_count#'))#
                                                        <cfset 'tevkifat_genel_toplam_#tax_count#' = evaluate('tevkifat_genel_toplam_#tax_count#') + (evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
                                                    </cfif>
                                                </td>
                                            </cfloop>
                                            <cfloop list="#tax_list#" index="tax_ii">
                                                <cfset tax_count=NumberFormat(tax_ii)>
                                                <td style="text-align:right" format="numeric">
                                                    <cfif type eq 0 and isdefined('tax_beyan_#action_id#_#tax_count#') and len(evaluate('tax_beyan_#action_id#_#tax_count#'))>
                                                        <cfif evaluate('tax_beyan_#action_id#_#tax_count#') eq 0 >#TLFormat(evaluate('tax_beyan_#action_id#_#tax_count#'))#<cfelse>#TLFormat(evaluate('tax_beyan_#action_id#_#tax_count#')/100)#</cfif>
                                                        <cfset 'beyan_genel_toplam_#tax_count#' = evaluate('beyan_genel_toplam_#tax_count#') + (evaluate('tax_beyan_#action_id#_#tax_count#'))>
                                                    </cfif>
                                                </td>
                                            </cfloop>
                                        </cfif>
                                    </cfif>      
                                </cfif>	
                                <cfif listfind(attributes.list_type,12)>
                                    <cfloop query="get_all_otv">
                                        <td>#tlformat(get_invoice_detail["otv_#filternum(get_all_otv.tax)#"][get_invoice_detail.currentrow])#<!---#tlformat(OTV_#filternum(tax)#)#---></td>
                                    </cfloop>   
                                </cfif>
                                <cfif listfind(attributes.list_type,13)>
                                     <cfloop query="get_all_bsmv">
                                        <td>#tlformat(get_invoice_detail["bsmv_#filternum(get_all_bsmv.tax)#"][get_invoice_detail.currentrow])#</td>
                                    </cfloop>   
                                </cfif>
                                <cfif listfind(attributes.list_type,14)>
                                    <cfloop query="get_all_oiv">
                                        <td>#tlformat(get_invoice_detail["oiv_#filternum(get_all_oiv.tax)#"][get_invoice_detail.currentrow])#</td>
                                    </cfloop>   
                                </cfif>
                                <td style="text-align:right;">#tlformat(GROSSTOTAL)#</td>
                                <td style="text-align:right;">#tlformat(SA_DISCOUNT)#</td>
                                <td style="text-align:right;">#tlformat(ROUND_MONEY)#</td>
                                <td style="text-align:right;">#tlformat(DISCOUNTTOTAL)#</td>
                                <td style="text-align:right;">#tlformat(INDRIM_SONRASI_KDVSIZ_TOPLAM)#</td>
                                <td style="text-align:right;">#tlformat(OTVTOTAL)#</td>
                                <td style="text-align:right;">#tlformat(IS_TAX_OF_OTV)#</td>
                                <td style="text-align:right;">#tlformat(TAXTOTAL)#</td>
                                <td style="text-align:right;">#tlformat(BSMVTOTAL)#</td>
                                <td style="text-align:right;">#tlformat(OIVTOTAL)#</td>
                                <td style="text-align:right;">#tlformat(NETTOTAL)#</td>                              
                            </tr>
                        <cfelseif attributes.report_type eq 2>
                            <tr>
                                <td>#serial_number#</td>
                                <td style='mso-number-format:"\@"'>
                                    <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
                                        #serial_no#
                                    <cfelse>
                                        <cfif invoice_cat eq 592>
                                            <a href="#request.self#?fuseaction=invoice.form_upd_marketplace_bill&iid=#action_id#">#serial_no#</a>
                                        <cfelse>
                                            <cfif invoice_cat eq 65>
                                                <a href="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#action_id#">#serial_no#</a>
                                            <cfelseif invoice_cat eq 66>
                                                <a href="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#action_id#">#serial_no#</a>
                                            <cfelseif invoice_cat eq 120>
                                                <a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#action_id#">#serial_no#</a>
                                            <cfelse>
                                                <a href="#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid=#action_id#">#serial_no#</a>
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </td>
                                <cfif listfind(attributes.list_type,1)><td>#ref_no#</td></cfif>
                                <td>#process_cat#</td>
                                <cfif listfind(attributes.list_type,2)>
                                    <td>
                                        #dateformat(DUE_DATE,dateformat_style)#
                                    </td>
                                </cfif>
                                <td>#dateformat(ACTION_DATE,dateformat_style)#</td> 
                                <cfif listfind(attributes.list_type,3)>
                                    <td>#ozel_kod#</td>
                                </cfif>
                                <td>#Cari_Kod#</td>
                                <td width="250">#Cari_Hesap#</td>
                                <td>#product_name#</td>
                                <cfif listfind(attributes.list_type,4)>
                                    <td> #NOTE#</td>
                                </cfif>
                                <td>#Vergi_Daire#</td>
                                <td>#Vergi_No#</td>
                                <cfif listfind(attributes.list_type,5)>
                                    <td>#TC_IDENTY_NO#</td>
                                </cfif>
                                <cfif listfind(attributes.list_type,6)>
                                    <td>#PRODUCT_CAT#</td>
                                </cfif>
                                <cfif listfind(attributes.list_type,7)>
                                    <td> #SUBE_DEPO#</td>
                                </cfif>
                            <cfif listfind(attributes.list_type,11)>
                                    <cfloop query="get_add_info_name">
                                        <td>
                                            #evaluate("get_invoice_detail.#listgetat(PROPERTY,1,'_')#")#
                                        </td>
                                    </cfloop>
                                </cfif> 
                                <cfif listfind(attributes.list_type,10)>
                                    <td>
                                        #PROJECT_HEAD#
                                    </td>
                                </cfif>
                                <cfif listfind(attributes.list_type,8)>
                                    <td style="text-align:right;" format="numeric">
                                        <cfif attributes.report_type eq 2>
                                                #ROW_QUANTITY#
                                        </cfif>
                                        <cfif attributes.report_type eq 1>
                                                #MIKTAR#
                                        </cfif>   
                                    </td>
                                </cfif>
                                <td>#ACCOUNT_CODE_PUR#</td>
                                <td>#ACC_NAME#</td>
                                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>
                                     <cfloop query="get_all_tax">
                                        <td>#tlformat(get_invoice_detail["kdv_#filternum(get_all_tax.tax)#"][get_invoice_detail.currentrow])#</td>
                                    </cfloop>          
                                </cfif>	
                                <cfif listfind(attributes.list_type,12)>
                                    <cfloop query="get_all_otv">
                                        <td>#tlformat(get_invoice_detail["otv_#filternum(get_all_otv.tax)#"][get_invoice_detail.currentrow])#<!---#tlformat(OTV_#filternum(tax)#)#---></td>
                                    </cfloop>   
                                </cfif>
                                <cfif listfind(attributes.list_type,13)>
                                     <cfloop query="get_all_bsmv">
                                        <td>#tlformat(get_invoice_detail["bsmv_#filternum(get_all_bsmv.tax)#"][get_invoice_detail.currentrow])#</td>
                                    </cfloop>   
                                </cfif>
                                <cfif listfind(attributes.list_type,14)>
                                    <cfloop query="get_all_oiv">
                                        <td>#tlformat(get_invoice_detail["oiv_#filternum(get_all_oiv.tax)#"][get_invoice_detail.currentrow])#</td>
                                    </cfloop>   
                                </cfif>
                                <td style="text-align:right;">#tlformat(DISCOUNTTOTAL)#</td>
                                <td style="text-align:right;">#tlformat(KDVSIZ_TOPLAM)#</td>                              
                                <td style="text-align:right;">#tlformat(OTVTOTAL)#</td>
                                <td style="text-align:right;">#tlformat(IS_TAX_OF_OTV)#</td>
                                <td style="text-align:right;">#tlformat(ROW_TAXTOTAL)#</td>
                                <td style="text-align:right;">#tlformat(ROW_BSMVTOTAL)#</td>
                                <td style="text-align:right;">#tlformat(ROW_OIVTOTAL)#</td>
                                <td style="text-align:right;">#tlformat(GENEL_TOPLAM)#</td>
                            </tr>
                        </cfif>
                    </cfoutput>	
                <cfelse>
                    <tr>
                        <td colspan="<cfoutput>#col_extra#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt yok'>!</td>
                    </tr>
                </cfif>
            <cfelse>
                <tr>
                    <td colspan="<cfoutput>#col_extra#</cfoutput>"><cf_get_lang dictionary_id='57484.Kayıt yok'>!</td>
                </tr>
            </cfif>
        </tbody>
        <cfif isdefined("attributes.form_varmi")>
            <cfif get_invoice_detail.recordcount>
                <cfoutput>
                    <tfoot>
                        <cfif attributes.page gt 1>
                        <tr> 
                            <td  colspan='#iif(isdefined("attributes.is_tevkifat") and isdefined("attributes.list_type") and listfind(attributes.list_type,9) and attributes.report_type eq 1, colspan- 2* ListLen(tax_list), colspan )#' class="bold" style="text-align:right;"><cf_get_lang dictionary_id='40654.Kümülatif Toplamlar'></td>
                                <cfif attributes.report_type eq 1>
                                    <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>                                    
                                        <cfif isdefined("attributes.is_tevkifat")>
                                            <cfloop list="#tax_list#" index="tax_ii">
                                                <cfset tax_count=NumberFormat(tax_ii)>
                                                <td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('tevkifat_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('tevkifat_genel_toplam_#NumberFormat(tax_ii)#')+evaluate('expense_tevkifat_toplam_#NumberFormat(tax_ii)#'))#</cfif></td>
                                            </cfloop>
                                            <cfloop list="#tax_list#" index="tax_ii">
                                                <cfset tax_count=NumberFormat(tax_ii)>
                                                <td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('beyan_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('beyan_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('beyan_genel_toplam_#NumberFormat(tax_ii)#')/100+(evaluate('expense_beyan_toplam_#NumberFormat(tax_ii)#')))#</cfif></td>
                                            </cfloop>
                                        </cfif>
                                    </cfif>
                                    <cfquery name="get_total" dbtype="query">
                                        SELECT 
                                            SUM(GROSSTOTAL) AS GROSSTOTAL,
                                            SUM(SA_DISCOUNT) AS SA_DISCOUNT,
                                            SUM(ROUND_MONEY) AS ROUND_MONEY,
                                            SUM(DISCOUNTTOTAL) AS DISCOUNTTOTAL,
                                            SUM(INDRIM_SONRASI_KDVSIZ_TOPLAM) AS INDRIM_SONRASI_KDVSIZ_TOPLAM,
                                            SUM(OTVTOTAL) AS OTVTOTAL,
                                            SUM(IS_TAX_OF_OTV) AS IS_TAX_OF_OTV,
                                            SUM(TAXTOTAL) AS TAXTOTAL,
                                            SUM(NETTOTAL) AS NETTOTAL,
                                            SUM(BSMVTOTAL) AS BSMVTOTAL,
                                            SUM(OIVTOTAL) AS OIVTOTAL
                                        FROM get_invoice_detail
                                        WHERE RowNum BETWEEN 1 and #attributes.startrow#+(#attributes.maxrows#-1)
                                    </cfquery>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.GROSSTOTAL)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.SA_DISCOUNT)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.ROUND_MONEY)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.DISCOUNTTOTAL)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.INDRIM_SONRASI_KDVSIZ_TOPLAM)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.OTVTOTAL)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.IS_TAX_OF_OTV)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.TAXTOTAL)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.BSMVTOTAL)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.OIVTOTAL)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.NETTOTAL)#</td>                                
                                <cfelse>
                                    <cfquery name="get_total" dbtype="query">
                                        SELECT 
                                            SUM(DISCOUNTTOTAL) AS DISCOUNTTOTAL,
                                            SUM(KDVSIZ_TOPLAM) AS KDVSIZ_TOPLAM,
                                            SUM(OTVTOTAL) AS OTVTOTAL,
                                            SUM(IS_TAX_OF_OTV) AS IS_TAX_OF_OTV,
                                            SUM(ROW_TAXTOTAL) AS ROW_TAXTOTAL,
                                            SUM(GENEL_TOPLAM) AS GENEL_TOPLAM,
                                            SUM(ROW_BSMVTOTAL) AS ROW_BSMVTOTAL,
                                            SUM(ROW_OIVTOTAL) AS ROW_OIVTOTAL
                                        FROM get_invoice_detail
                                        WHERE RowNum BETWEEN 1 and #attributes.startrow#+(#attributes.maxrows#-1)
                                    </cfquery>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.DISCOUNTTOTAL)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.KDVSIZ_TOPLAM)#</td>                              
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.OTVTOTAL)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.IS_TAX_OF_OTV)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.ROW_TAXTOTAL)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.ROW_BSMVTOTAL)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.ROW_OIVTOTAL)#</td>
                                    <td class="txtbold" style="text-align:right;">#tlformat(get_total.GENEL_TOPLAM)#</td>                                
                                </cfif>	
                            </tr>
                        </cfif>
                        <tr> 
                            
                        <td  colspan='#iif(isdefined("attributes.is_tevkifat") and isdefined("attributes.list_type") and listfind(attributes.list_type,9) and attributes.report_type eq 1, colspan- 2* ListLen(tax_list), colspan )#' class="bold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></td>
                            <cfif attributes.report_type eq 1>
                                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,9)>                                    
                                    <cfif isdefined("attributes.is_tevkifat")>
                                        <cfloop list="#tax_list#" index="tax_ii">
                                            <cfset tax_count=NumberFormat(tax_ii)>
                                            <td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('tevkifat_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('tevkifat_genel_toplam_#NumberFormat(tax_ii)#')+evaluate('expense_tevkifat_toplam_#NumberFormat(tax_ii)#'))#</cfif></td>
                                        </cfloop>
                                        <cfloop list="#tax_list#" index="tax_ii">
                                            <cfset tax_count=NumberFormat(tax_ii)>
                                            <td class="txtbold" style="text-align:right" format="numeric"><cfif isdefined('beyan_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('beyan_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('beyan_genel_toplam_#NumberFormat(tax_ii)#')/100+(evaluate('expense_beyan_toplam_#NumberFormat(tax_ii)#')))#</cfif></td>
                                        </cfloop>
                                    </cfif>
                                </cfif>
                                <cfquery name="get_total" dbtype="query">
                                    SELECT 
                                        SUM(GROSSTOTAL) AS GROSSTOTAL,
                                        SUM(SA_DISCOUNT) AS SA_DISCOUNT,
                                        SUM(ROUND_MONEY) AS ROUND_MONEY,
                                        SUM(DISCOUNTTOTAL) AS DISCOUNTTOTAL,
                                        SUM(INDRIM_SONRASI_KDVSIZ_TOPLAM) AS INDRIM_SONRASI_KDVSIZ_TOPLAM,
                                        SUM(OTVTOTAL) AS OTVTOTAL,
                                        SUM(IS_TAX_OF_OTV) AS IS_TAX_OF_OTV,
                                        SUM(TAXTOTAL) AS TAXTOTAL,
                                        SUM(NETTOTAL) AS NETTOTAL,
                                        SUM(BSMVTOTAL) AS BSMVTOTAL,
                                        SUM(OIVTOTAL) AS OIVTOTAL
                                    FROM get_invoice_detail
                                    WHERE RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
                                </cfquery>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.GROSSTOTAL)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.SA_DISCOUNT)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.ROUND_MONEY)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.DISCOUNTTOTAL)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.INDRIM_SONRASI_KDVSIZ_TOPLAM)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.OTVTOTAL)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.IS_TAX_OF_OTV)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.TAXTOTAL)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.BSMVTOTAL)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.OIVTOTAL)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.NETTOTAL)#</td>                                
                            <cfelse>
                                <cfquery name="get_total" dbtype="query">
                                    SELECT 
                                        SUM(DISCOUNTTOTAL) AS DISCOUNTTOTAL,
                                        SUM(KDVSIZ_TOPLAM) AS KDVSIZ_TOPLAM,
                                        SUM(OTVTOTAL) AS OTVTOTAL,
                                        SUM(IS_TAX_OF_OTV) AS IS_TAX_OF_OTV,
                                        SUM(ROW_TAXTOTAL) AS ROW_TAXTOTAL,
                                        SUM(GENEL_TOPLAM) AS GENEL_TOPLAM,
                                        SUM(ROW_BSMVTOTAL) AS ROW_BSMVTOTAL,
                                        SUM(ROW_OIVTOTAL) AS ROW_OIVTOTAL
                                    FROM get_invoice_detail
                                    WHERE RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
                                </cfquery>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.DISCOUNTTOTAL)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.KDVSIZ_TOPLAM)#</td>                              
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.OTVTOTAL)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.IS_TAX_OF_OTV)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.ROW_TAXTOTAL)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.ROW_BSMVTOTAL)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.ROW_OIVTOTAL)#</td>
                                <td class="txtbold" style="text-align:right;">#tlformat(get_total.GENEL_TOPLAM)#</td>                                
                            </cfif>	
                        </tr>
                    </tfoot>
                </cfoutput>
            </cfif>
        </cfif>
    </cf_report_list>
</cfif>
<cfif get_invoice_detail.recordcount and (attributes.maxrows lt attributes.totalrecords)>
	<cfset adres = "#attributes.fuseaction#&form_varmi=1">	
	<cfif isDefined("attributes.startdate") and len(attributes.startdate)>
		<cfset adres = "#adres#&startdate=#attributes.startdate#">
	</cfif>
	<cfif isDefined("attributes.finishdate") and len(attributes.finishdate)>
		<cfset adres = "#adres#&finishdate=#attributes.finishdate#">
	</cfif>
	<cfif isDefined("attributes.department_id") and len(attributes.department_id)>
		<cfset adres = "#adres#&department_id=#attributes.department_id#">
	</cfif>
	<cfif isDefined("attributes.category_id") and len(attributes.category_id)>
		<cfset adres = "#adres#&category_id=#attributes.category_id#">
	</cfif>
	<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
		<cfset adres = "#adres#&company_id=#attributes.company_id#">
	</cfif>
	<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
		<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#">
	</cfif>
	<cfif isDefined("attributes.company") and len(attributes.company)>
		<cfset adres = "#adres#&company=#attributes.company#">
	</cfif>
	<cfif isDefined("attributes.process_type") and len(attributes.process_type)>
		<cfset adres = "#adres#&process_type=#attributes.process_type#">
	</cfif>    
	<cfif isDefined("attributes.is_inv_total") and len(attributes.is_inv_total)>
		<cfset adres = "#adres#&is_inv_total=#attributes.is_inv_total#">
	</cfif>          
	<cfif isDefined("attributes.is_tevkifat") and len(attributes.is_tevkifat)>
		<cfset adres = "#adres#&is_tevkifat=#attributes.is_tevkifat#">
	</cfif>
	<cfif isDefined("attributes.ship_method_id") and len(attributes.ship_method_id)>
		<cfset adres = "#adres#&ship_method_id=#attributes.ship_method_id#">
	</cfif>
	<cfif isDefined("attributes.ship_method_name") and len(attributes.ship_method_name)>
		<cfset adres = "#adres#&ship_method_name=#attributes.ship_method_name#">
	</cfif> 
	<cfif isDefined("attributes.list_type") and len(attributes.list_type)>
		<cfset adres = "#adres#&list_type=#attributes.list_type#">
	</cfif> 
	<cfif isDefined("attributes.project_id") and len(attributes.project_id)>
		<cfset adres = "#adres#&project_id=#attributes.project_id#">
	</cfif>
	<cfif isDefined("attributes.project_head") and len(attributes.project_head)>
		<cfset adres = "#adres#&project_head=#attributes.project_head#">
	</cfif>
	<cfif isDefined("attributes.report_type") and len(attributes.report_type)>
		<cfset adres = "#adres#&report_type=#attributes.report_type#">
	</cfif>
	<cfif isdefined("attributes.use_efatura") and len(attributes.use_efatura)>
		<cfset adres = "#adres#&use_efatura=#attributes.use_efatura#">
	</cfif>  
	<cf_paging
        page="#attributes.page#" 
        maxrows="#attributes.maxrows#"
        totalrecords="#attributes.totalrecords#"
        startrow="#attributes.startrow#"
        adres="#adres#"></td>
</cfif>
<script>
    function control(){
        if ((document.form.startdate.value != '') && (document.form.finishdate.value != '') &&
        !date_check(form.startdate,form.finishdate,"<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
            return false;
		if(document.form.is_excel.checked==false)
			{
				document.form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.invoice_list_purchase_new"
				return true;
			}
			else
				document.form.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_invoice_list_purchase_new</cfoutput>"
    }
    function kontrol_report()
    {
        if($('#report_type').val()==1)
        {   
            $('#inv_total').hide();
            $('#tevkifat_total').show();
        }
        else
        {
            $('#inv_total').show();
            $('#tevkifat_total').hide();
        }
    }
</script>