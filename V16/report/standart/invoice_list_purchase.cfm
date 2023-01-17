<cfsetting showdebugoutput="yes">
<cfparam name="attributes.module_id_control" default="20">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact="report.invoice_list_purchase">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.category_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.finishdate" default="#now()#">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.list_type" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.startdate" default="#date_add('d',-1,attributes.finishdate)#">
<cfparam name="attributes.use_efatura" default="">
<cfset gun_farki = 0>
<cfquery name="get_process_cat" datasource="#dsn3#">
	SELECT PROCESS_CAT_ID,PROCESS_CAT,PROCESS_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (51,54,55,59,591,592,60,61,63,64,65,68,690,691,601,49,120) ORDER BY PROCESS_CAT
</cfquery>
<cfquery name="get_all_tax" datasource="#dsn2#">
	SELECT TAX FROM SETUP_TAX
</cfquery>
<cfquery name="get_all_otv" datasource="#dsn3#">
	SELECT TAX FROM SETUP_OTV WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfset tax_list=valuelist(get_all_tax.tax)>
<cfset otv_list=valuelist(get_all_otv.tax)>
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
        <cfif x_show_pasive_departments eq 0>
            D.DEPARTMENT_STATUS = 1 AND
        </cfif>
		B.BRANCH_ID IN(SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
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
<cfprocessingdirective suppresswhitespace="yes">
<cfif isdefined("attributes.form_varmi")>
	<cfif isdate(attributes.startdate)>
		<cf_date tarih = "attributes.startdate">
	</cfif>
	<cfif isdate(attributes.finishdate)>
		<cf_date tarih = "attributes.finishdate">
	</cfif>
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
                         PROPERTY1_NAME,
                         PROPERTY2_NAME, 
                         PROPERTY3_NAME, 
                         PROPERTY4_NAME,
                         PROPERTY5_NAME,
                         PROPERTY6_NAME,
                         PROPERTY7_NAME,
                         PROPERTY8_NAME,
                         PROPERTY9_NAME,
                         PROPERTY10_NAME,
                         PROPERTY11_NAME,
                         PROPERTY12_NAME,
                         PROPERTY13_NAME,
                         PROPERTY14_NAME,
                         PROPERTY15_NAME,
                         PROPERTY16_NAME,
                         PROPERTY17_NAME,
                         PROPERTY18_NAME,
                         PROPERTY19_NAME,
                         PROPERTY20_NAME
                ) 
            ) AS U
    </cfquery>
	<cfquery name="get_invoice_detail" datasource="#dsn2#">
		SELECT 
			E.EXPENSE_ID  AS ACTION_ID,
			E.PAPER_NO AS BELGE_NO,
			E.SERIAL_NUMBER AS SERIAL_NUMBER,
			E.SERIAL_NO AS SERIAL_NO,
			E.EXPENSE_DATE AS ACTION_DATE,
			E.TOTAL_AMOUNT_KDVLI AS NETTOTAL,
			E.KDV_TOTAL AS TAXTOTAL,
			E.TOTAL_AMOUNT AS GROSSTOTAL,
            0 AS IS_TAX_OF_OTV,
			0 AS SA_DISCOUNT,
			0 AS ROUND_MONEY,
			E.ACTION_TYPE INVOICE_CAT,
			E.ACC_DEPARTMENT_ID,
            ISNULL(E_ROW.AMOUNT_OTV,0) AS OTVTOTAL,
            E_ROW.OTV_RATE AS OTV_ORAN,
			E_ROW.AMOUNT_OTV AS ROW_OTVTOTAL,
			E_ROW.AMOUNT_KDV AS ROW_TAXTOTAL,
			CAST(E_ROW.KDV_RATE AS FLOAT) AS TAX,
			0 AS DISCOUNTTOTAL,
			(E_ROW.AMOUNT*E_ROW.QUANTITY) AS KDVSIZ_TOPLAM,
			<cfif attributes.report_type eq 2>
				E_ROW.PRODUCT_NAME AS PRODUCT_NAME,
                ' ' PRODUCT_NAME2,
				E_ROW.DETAIL NOTE,
			<cfelse>
				E.DETAIL NOTE,
			</cfif>
			'' FULLNAME,
			'' MEMBER_CODE,
			'' OZEL_KOD,
			'' TAXOFFICE,
			'' TAXNO,
			'' TC_IDENTY_NO,
			1 AS TYPE,
			E.PROJECT_ID,
			E_ROW.PROJECT_ID ROW_PROJECT_ID,
			E.PROCESS_CAT,
            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
            	<cfloop from="1" to="20" index="i">
					EXPENSE_ITEM_PLANS_INFO_PLUS.PROPERTY#i#,
                </cfloop>
            </cfif>
			E_ROW.EXPENSE_ITEM_ID AS PRODUCT_ID,
			E_ROW.QUANTITY ROW_QUANTITY,
			ISNULL(E_ROW.UNIT,'Adet') AS UNIT, <!--- ürün secilmemiş satırlarda birim null geliyor --->
			EXPENSE_ITEMS.EXPENSE_ITEM_ID AS PRODUCT_CATID,
			EXPENSE_ITEMS.EXPENSE_ITEM_NAME AS PRODUCT_CAT,
			E.SYSTEM_RELATION REF_NO,
			E.DUE_DATE,
			0 DUEDATE
		FROM
			EXPENSE_ITEM_PLANS E
            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                LEFT JOIN EXPENSE_ITEM_PLANS_INFO_PLUS  ON E.EXPENSE_ID=EXPENSE_ITEM_PLANS_INFO_PLUS.EXPENSE_ID
            </cfif>
			<cfif len(attributes.use_efatura)>
				LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
			</cfif>,
			EXPENSE_ITEMS_ROWS E_ROW,
			EXPENSE_ITEMS
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
			E.EXPENSE_ID=E_ROW.EXPENSE_ID
			AND E_ROW.EXPENSE_ITEM_ID=EXPENSE_ITEMS.EXPENSE_ITEM_ID
			AND E.CH_COMPANY_ID IS NULL
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
			<cfif not(len(bireysel) and not len(kurumsal)) and not(isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company))>
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
                        0 AS IS_TAX_OF_OTV,
                        0 AS SA_DISCOUNT,
                        0 AS ROUND_MONEY,
                        E.ACTION_TYPE INVOICE_CAT,
                        E.ACC_DEPARTMENT_ID,
                        ISNULL(E_ROW.AMOUNT_OTV,0) AS OTVTOTAL,
                        E_ROW.OTV_RATE AS OTV_ORAN,
                        E_ROW.AMOUNT_OTV AS ROW_OTVTOTAL,
                        E_ROW.AMOUNT_KDV AS ROW_TAXTOTAL,
                        CAST(E_ROW.KDV_RATE AS FLOAT) AS TAX,
                        0 AS DISCOUNTTOTAL,
                        (E_ROW.AMOUNT*E_ROW.QUANTITY) AS KDVSIZ_TOPLAM,
                        <cfif attributes.report_type eq 2>
                            E_ROW.PRODUCT_NAME AS PRODUCT_NAME,
                            ' ' PRODUCT_NAME2,
                            E_ROW.DETAIL NOTE,
                        <cfelse>
                            E.DETAIL NOTE,
                        </cfif>
                        C.FULLNAME,
                        C.MEMBER_CODE,
                        C.OZEL_KOD,
                        C.TAXOFFICE,
                        C.TAXNO,
                        CP.TC_IDENTITY TC_IDENTY_NO,
                        1 AS TYPE,
                        E.PROJECT_ID,
                        E_ROW.PROJECT_ID ROW_PROJECT_ID,
                        E.PROCESS_CAT,
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                            <cfloop from="1" to="20" index="i">
                                EXPENSE_ITEM_PLANS_INFO_PLUS.PROPERTY#i#,
                            </cfloop>
                    	</cfif>
                        E_ROW.EXPENSE_ITEM_ID AS PRODUCT_ID,
                        E_ROW.QUANTITY ROW_QUANTITY,
                        ISNULL(E_ROW.UNIT,'Adet') AS UNIT, <!--- ürün secilmemiş satırlarda birim null geliyor --->
                        EXPENSE_ITEMS.EXPENSE_ITEM_ID AS PRODUCT_CATID,
                        EXPENSE_ITEMS.EXPENSE_ITEM_NAME AS PRODUCT_CAT,
                        E.SYSTEM_RELATION REF_NO,
                        E.DUE_DATE,
                        0 DUEDATE
                    FROM
                        EXPENSE_ITEM_PLANS E
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                            LEFT JOIN EXPENSE_ITEM_PLANS_INFO_PLUS  ON E.EXPENSE_ID=EXPENSE_ITEM_PLANS_INFO_PLUS.EXPENSE_ID
                        </cfif>
                        <cfif len(attributes.use_efatura)>
                            LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
                        </cfif>,
                        EXPENSE_ITEMS_ROWS E_ROW,
                        #dsn_alias#.COMPANY C
                            LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.COMPANY_ID = C.COMPANY_ID AND C.MANAGER_PARTNER_ID = CP.PARTNER_ID,
                        EXPENSE_ITEMS
                    WHERE
                        <cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
                            ERD.EXPENSE_ID IS NOT NULL AND
                        <cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
                            ERD.EXPENSE_ID IS NULL AND
                        </cfif>
                        E.CH_COMPANY_ID = C.COMPANY_ID
                        AND E.EXPENSE_ID=E_ROW.EXPENSE_ID
                        AND E_ROW.EXPENSE_ITEM_ID = EXPENSE_ITEMS.EXPENSE_ITEM_ID
                        <cfif len(attributes.process_type)>
                            AND E.PROCESS_CAT IN (#attributes.process_type#)
                        <cfelse>
                            AND E.ACTION_TYPE IN (120)
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
                        <cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                            AND E.EXPENSE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
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
                        <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
                            AND E.CH_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                        </cfif>
                        <cfif len(kurumsal)>
                            AND C.COMPANYCAT_ID IN (#kurumsal#)
                        </cfif>
			</cfif>
			<cfif not(len(kurumsal) and not len(bireysel)) and not (isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company))>
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
                        0 AS IS_TAX_OF_OTV,
						0 AS SA_DISCOUNT,
						0 AS ROUND_MONEY,
						E.ACTION_TYPE INVOICE_CAT,
						E.ACC_DEPARTMENT_ID,
                        ISNULL(E_ROW.AMOUNT_OTV,0) AS OTVTOTAL,
                        E_ROW.OTV_RATE AS OTV_ORAN,
						E_ROW.AMOUNT_OTV AS ROW_OTVTOTAL,
						E_ROW.AMOUNT_KDV AS ROW_TAXTOTAL,
						CAST(E_ROW.KDV_RATE AS FLOAT) AS TAX,
						0 AS DISCOUNTTOTAL,
						(E_ROW.AMOUNT*E_ROW.QUANTITY) AS KDVSIZ_TOPLAM,
						<cfif attributes.report_type eq 2>
							E_ROW.PRODUCT_NAME AS PRODUCT_NAME,
                            ' ' PRODUCT_NAME2,
							E_ROW.DETAIL NOTE,
						<cfelse>
							E.DETAIL NOTE,
						</cfif>
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
						C.MEMBER_CODE,
						C.OZEL_KOD,
						C.TAX_OFFICE TAXOFFICE,
						C.TAX_NO TAXNO,
						C.TC_IDENTY_NO,
						1 AS TYPE,
						E.PROJECT_ID,
						E_ROW.PROJECT_ID ROW_PROJECT_ID,
						E.PROCESS_CAT,
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
							<cfloop from="1" to="20" index="i">
								EXPENSE_ITEM_PLANS_INFO_PLUS.PROPERTY#i#,
							</cfloop>
						</cfif>
						E_ROW.EXPENSE_ITEM_ID AS PRODUCT_ID,
						E_ROW.QUANTITY ROW_QUANTITY,
						ISNULL(E_ROW.UNIT,'Adet') AS UNIT, <!--- ürün secilmemiş satırlarda birim null geliyor --->
						EXPENSE_ITEMS.EXPENSE_ITEM_ID AS PRODUCT_CATID,
						EXPENSE_ITEMS.EXPENSE_ITEM_NAME AS PRODUCT_CAT,
						E.SYSTEM_RELATION REF_NO,
						E.DUE_DATE,
						0 DUEDATE
					FROM
						EXPENSE_ITEM_PLANS E
                         <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                             LEFT JOIN EXPENSE_ITEM_PLANS_INFO_PLUS  ON E.EXPENSE_ID=EXPENSE_ITEM_PLANS_INFO_PLUS.EXPENSE_ID
                         </cfif>
						 <cfif len(attributes.use_efatura)>
							LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.EXPENSE_ID = E.EXPENSE_ID
						</cfif>,
						EXPENSE_ITEMS_ROWS E_ROW,
						#dsn_alias#.CONSUMER C,
						EXPENSE_ITEMS
					WHERE
						<cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
							ERD.EXPENSE_ID IS NOT NULL AND
						<cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
							ERD.EXPENSE_ID IS NULL AND
						</cfif>
						E.CH_CONSUMER_ID = C.CONSUMER_ID
						AND E.EXPENSE_ID=E_ROW.EXPENSE_ID
						AND E_ROW.EXPENSE_ITEM_ID=EXPENSE_ITEMS.EXPENSE_ITEM_ID
						<cfif len(attributes.process_type)>
							AND E.PROCESS_CAT IN (#attributes.process_type#)
						<cfelse>
							AND E.ACTION_TYPE IN (120)
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
						<cfif len(bireysel)>
							AND C.CONSUMER_CAT_ID IN (#bireysel#)
						</cfif>
				</cfif>
				<cfif not(len(bireysel) and not len(kurumsal)) and not(isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company))>
                    UNION ALL
                    SELECT 
                        INVOICE.INVOICE_ID AS ACTION_ID,
                        INVOICE.INVOICE_NUMBER AS BELGE_NO,
                        INVOICE.SERIAL_NUMBER AS SERIAL_NUMBER,
                        INVOICE.SERIAL_NO AS SERIAL_NO,
                        INVOICE.INVOICE_DATE AS ACTION_DATE,
                        INVOICE.NETTOTAL,
                        INVOICE.TAXTOTAL,
                        INVOICE.GROSSTOTAL,
                        INVOICE.IS_TAX_OF_OTV,
                        INVOICE.SA_DISCOUNT,
                        INVOICE.ROUND_MONEY,
                        INVOICE.INVOICE_CAT,
                        INVOICE.ACC_DEPARTMENT_ID,
                        ISNULL(IR.OTVTOTAL,0) AS OTVTOTAL,
                        IR.OTV_ORAN,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.OTVTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_OTVTOTAL,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.TAXTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT))* IR.TAXTOTAL) END AS ROW_TAXTOTAL,
                        IR.TAX,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.DISCOUNTTOTAL ELSE ((IR.AMOUNT*IR.PRICE)-((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT)) * IR.NETTOTAL)) END AS DISCOUNTTOTAL,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE ( (1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT)) * IR.NETTOTAL ) END AS KDVSIZ_TOPLAM,
                        <cfif attributes.report_type eq 2>
                            IR.NAME_PRODUCT AS PRODUCT_NAME,
                            IR.PRODUCT_NAME2 AS PRODUCT_NAME2,
                            ' '  NOTE,
                        <cfelse>
                            INVOICE.NOTE NOTE,
                        </cfif>
                        C.FULLNAME,
                        C.MEMBER_CODE,
                        C.OZEL_KOD,
                        C.TAXOFFICE,
                        C.TAXNO,
                        CP.TC_IDENTITY TC_IDENTY_NO,
                        0 AS TYPE,
                        INVOICE.PROJECT_ID,
                        IR.ROW_PROJECT_ID,
                        INVOICE.PROCESS_CAT,
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                            <cfloop from="1" to="20" index="i">
                                INVOICE_INFO_PLUS.PROPERTY#i#,
                            </cfloop>
                        </cfif>
                        IR.PRODUCT_ID,
                        IR.AMOUNT ROW_QUANTITY,
                        ISNULL(IR.UNIT,'Adet') AS UNIT,
                        PC.PRODUCT_CATID,
                        PC.PRODUCT_CAT,
                        INVOICE.REF_NO,
                        INVOICE.DUE_DATE,
                        ISNULL(IR.DUE_DATE,0) AS DUEDATE
                    FROM
                        INVOICE
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                            LEFT JOIN INVOICE_INFO_PLUS  ON INVOICE.INVOICE_ID=INVOICE_INFO_PLUS.INVOICE_ID
                        </cfif>
                        <cfif len(attributes.use_efatura)>
                            LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = INVOICE.INVOICE_ID
                        </cfif>,
                        INVOICE_ROW IR,
                        #dsn_alias#.COMPANY C
                            LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.COMPANY_ID = C.COMPANY_ID AND C.MANAGER_PARTNER_ID = CP.PARTNER_ID,
                        #dsn3_alias#.PRODUCT P,
                        #dsn3_alias#.PRODUCT_CAT PC
                    WHERE
                        <cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
                            ERD.INVOICE_ID IS NOT NULL AND
                        <cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
                            ERD.INVOICE_ID IS NULL AND
                        </cfif>
                        INVOICE.COMPANY_ID = C.COMPANY_ID
                        AND INVOICE.INVOICE_ID = IR.INVOICE_ID
                        AND IR.PRODUCT_ID=P.PRODUCT_ID
                        AND PC.PRODUCT_CATID=P.PRODUCT_CATID
                        <cfif len(attributes.process_type)>
                            AND INVOICE.PROCESS_CAT IN (#attributes.process_type#)
                        <cfelse>
                            AND INVOICE.INVOICE_CAT IN (51,54,55,59,591,592,60,61,63,64,65,68,690,691,601,49)
                        </cfif>
                        <cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_id) and len(ship_method_name)>
                            AND INVOICE.SHIP_METHOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_method_id#">
                        </cfif>
                        <cfif attributes.report_type eq 2>
                            <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                                AND IR.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                            </cfif>
                        <cfelse>
                            <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                                AND INVOICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                            </cfif>
                        </cfif>
                        AND INVOICE.IS_IPTAL = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
                        <cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                            AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
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
                        <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
                            AND INVOICE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                        </cfif>
                        <cfif len(kurumsal)>
                            AND C.COMPANYCAT_ID IN (#kurumsal#)
                        </cfif>
                </cfif>
                <cfif not(len(bireysel) and not len(kurumsal)) and not(isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company))>
                    UNION ALL
                        SELECT 
                            INVOICE.INVOICE_ID AS ACTION_ID,
                            INVOICE.INVOICE_NUMBER  AS BELGE_NO,
                            INVOICE.SERIAL_NUMBER AS SERIAL_NUMBER,
                            INVOICE.SERIAL_NO AS SERIAL_NO,
                            INVOICE.INVOICE_DATE AS ACTION_DATE,
                            INVOICE.NETTOTAL,
                            INVOICE.TAXTOTAL,
                            INVOICE.GROSSTOTAL,
                            INVOICE.IS_TAX_OF_OTV,
                            INVOICE.SA_DISCOUNT,
                            INVOICE.ROUND_MONEY,
                            INVOICE.INVOICE_CAT,
                            INVOICE.ACC_DEPARTMENT_ID,
                            ISNULL(IR.OTVTOTAL,0) AS OTVTOTAL,
                            IR.OTV_ORAN,
                            CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.OTVTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_OTVTOTAL,
                            CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.TAXTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT))* IR.TAXTOTAL) END AS ROW_TAXTOTAL,
                            IR.TAX,
                            CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.DISCOUNTTOTAL ELSE ((IR.AMOUNT*IR.PRICE)-((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT)) * IR.NETTOTAL)) END AS DISCOUNTTOTAL,
                            CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE ( (1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT)) * IR.NETTOTAL ) END AS KDVSIZ_TOPLAM,
                            <cfif attributes.report_type eq 2>
                                IR.NAME_PRODUCT AS PRODUCT_NAME,
                                IR.PRODUCT_NAME2 AS PRODUCT_NAME2,
                                ' '  NOTE,
                            <cfelse>
                                INVOICE.NOTE NOTE,
                            </cfif>
                            C.FULLNAME,
                            C.MEMBER_CODE,
                            C.OZEL_KOD,
                            C.TAXOFFICE,
                            C.TAXNO,
                            CP.TC_IDENTITY TC_IDENTY_NO,
                            0 AS TYPE,
                            INVOICE.PROJECT_ID,
                            IR.ROW_PROJECT_ID,
                            INVOICE.PROCESS_CAT,
                            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                            <cfloop from="1" to="20" index="i">
                                INVOICE_INFO_PLUS.PROPERTY#i#,
                            </cfloop>
                        </cfif>
                            0 AS PRODUCT_ID,
                            IR.AMOUNT ROW_QUANTITY,
                            ISNULL(IR.UNIT,'Adet') AS UNIT,
                            0 AS PRODUCT_CATID,
                            NULL AS PRODUCT_CAT,
                            INVOICE.REF_NO,
                            INVOICE.DUE_DATE,
                            ISNULL(IR.DUE_DATE,0) AS DUEDATE
                        FROM
                            INVOICE 
                            <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                                LEFT JOIN INVOICE_INFO_PLUS  ON INVOICE.INVOICE_ID=INVOICE_INFO_PLUS.INVOICE_ID
                            </cfif>
                            <cfif len(attributes.use_efatura)>
                                LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = INVOICE.INVOICE_ID
                            </cfif>,
                            INVOICE_ROW IR,
                            #dsn_alias#.COMPANY C
                                LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON CP.COMPANY_ID = C.COMPANY_ID AND C.MANAGER_PARTNER_ID = CP.PARTNER_ID
                        WHERE
                            <cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
                                ERD.INVOICE_ID IS NOT NULL AND
                            <cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
                                ERD.INVOICE_ID IS NULL AND
                            </cfif>
                            INVOICE.COMPANY_ID = C.COMPANY_ID
                            AND INVOICE.INVOICE_ID = IR.INVOICE_ID
                            AND IR.PRODUCT_ID IS NULL
                            <cfif len(attributes.process_type)>
                                AND INVOICE.PROCESS_CAT IN (#attributes.process_type#)
                            <cfelse>
                                AND INVOICE.INVOICE_CAT IN (65)
                            </cfif>
                            AND INVOICE.IS_IPTAL = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
                            <cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                                AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                            </cfif>	
                            <cfif attributes.report_type eq 2>
                                <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                                    AND IR.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                                </cfif>
                            <cfelse>
                                <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                                    AND INVOICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                                </cfif>
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
                            <cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
                                AND INVOICE.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                            </cfif>
                            <cfif len(kurumsal)>
                                AND C.COMPANYCAT_ID IN (#kurumsal#)
                            </cfif>
				</cfif>
				<cfif not(len(kurumsal) and not len(bireysel)) and not(isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company))>
                    UNION ALL
                    SELECT 
                        INVOICE.INVOICE_ID AS ACTION_ID,
                        INVOICE.INVOICE_NUMBER  AS BELGE_NO,
                        INVOICE.SERIAL_NUMBER AS SERIAL_NUMBER,
                        INVOICE.SERIAL_NO AS SERIAL_NO,
                        INVOICE.INVOICE_DATE AS ACTION_DATE,
                        INVOICE.NETTOTAL,
                        INVOICE.TAXTOTAL,
                        INVOICE.GROSSTOTAL,
                        INVOICE.IS_TAX_OF_OTV,
                        INVOICE.SA_DISCOUNT,
                        INVOICE.ROUND_MONEY,
                        INVOICE.INVOICE_CAT,
                        INVOICE.ACC_DEPARTMENT_ID,
                        ISNULL(IR.OTVTOTAL,0) AS OTVTOTAL,
                        IR.OTV_ORAN,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.OTVTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_OTVTOTAL,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.TAXTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT))* IR.TAXTOTAL) END AS ROW_TAXTOTAL,
                        IR.TAX,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.DISCOUNTTOTAL ELSE ((IR.AMOUNT*IR.PRICE)-((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT)) * IR.NETTOTAL)) END AS DISCOUNTTOTAL,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE ( (1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT)) * IR.NETTOTAL ) END AS KDVSIZ_TOPLAM,
                        <cfif attributes.report_type eq 2>
                            IR.NAME_PRODUCT AS PRODUCT_NAME,
                            IR.PRODUCT_NAME2 AS PRODUCT_NAME2,
                            ' '  NOTE,
                        <cfelse>
                            INVOICE.NOTE NOTE,
                        </cfif>
                        C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
                        C.MEMBER_CODE,
                        C.OZEL_KOD,
                        C.TAX_OFFICE TAXOFFICE,
                        C.TAX_NO TAXNO,
                        C.TC_IDENTY_NO,
                        0 AS TYPE,
                        INVOICE.PROJECT_ID,
                        IR.ROW_PROJECT_ID,
                        INVOICE.PROCESS_CAT,
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                        <cfloop from="1" to="20" index="i">
                            INVOICE_INFO_PLUS.PROPERTY#i#,
                        </cfloop>
                    </cfif>
                        IR.PRODUCT_ID,
                        IR.AMOUNT ROW_QUANTITY,
                        ISNULL(IR.UNIT,'Adet') AS UNIT,
                        PC.PRODUCT_CATID,
                        PC.PRODUCT_CAT,
                        INVOICE.REF_NO,
                        INVOICE.DUE_DATE,
                        ISNULL(IR.DUE_DATE,0) AS DUEDATE
                    FROM
                        INVOICE
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                            LEFT JOIN INVOICE_INFO_PLUS  ON INVOICE.INVOICE_ID=INVOICE_INFO_PLUS.INVOICE_ID
                        </cfif>
                        <cfif len(attributes.use_efatura)>
                            LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = INVOICE.INVOICE_ID
                        </cfif>,
                        INVOICE_ROW IR,
                        #dsn_alias#.CONSUMER C,
                        #dsn3_alias#.PRODUCT P,
                        #dsn3_alias#.PRODUCT_CAT PC
                    WHERE
                        <cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
                            ERD.INVOICE_ID IS NOT NULL AND
                        <cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
                            ERD.INVOICE_ID IS NULL AND
                        </cfif>
                        INVOICE.CONSUMER_ID = C.CONSUMER_ID
                        AND INVOICE.INVOICE_ID = IR.INVOICE_ID
                        AND IR.PRODUCT_ID=P.PRODUCT_ID
                        AND PC.PRODUCT_CATID=P.PRODUCT_CATID
                        <cfif len(attributes.process_type)>
                            AND INVOICE.PROCESS_CAT IN (#attributes.process_type#)
                        <cfelse>
                            AND INVOICE.INVOICE_CAT IN (51,54,55,59,591,592,60,61,63,64,65,68,690,691,601,49)
                        </cfif>
                        AND INVOICE.IS_IPTAL = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
                        <cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                            AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                        </cfif>	
                        <cfif attributes.report_type eq 2>
                            <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                                AND IR.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                            </cfif>
                        <cfelse>
                            <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                                AND INVOICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                            </cfif>
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
                        <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
                            AND INVOICE.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                        </cfif>
                        <cfif len(bireysel)>
                            AND C.CONSUMER_CAT_ID IN (#bireysel#)
                        </cfif>
                </cfif>
				<cfif not(len(kurumsal) and not len(bireysel)) and not(isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company))>
                	UNION ALL
                    SELECT 
                        INVOICE.INVOICE_ID AS ACTION_ID,
                        INVOICE.INVOICE_NUMBER  AS BELGE_NO,
                        INVOICE.SERIAL_NUMBER AS SERIAL_NUMBER,
                        INVOICE.SERIAL_NO AS SERIAL_NO,
                        INVOICE.INVOICE_DATE AS ACTION_DATE,
                        INVOICE.NETTOTAL,
                        INVOICE.TAXTOTAL,
                        INVOICE.GROSSTOTAL,
                        INVOICE.IS_TAX_OF_OTV,
                        INVOICE.SA_DISCOUNT,
                        INVOICE.ROUND_MONEY,
                        INVOICE.INVOICE_CAT,
                        INVOICE.ACC_DEPARTMENT_ID,
                        ISNULL(IR.OTVTOTAL,0) AS OTVTOTAL,
                        IR.OTV_ORAN,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.OTVTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT))* IR.OTVTOTAL) END AS ROW_OTVTOTAL,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.TAXTOTAL ELSE ((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT))* IR.TAXTOTAL) END AS ROW_TAXTOTAL,
                        IR.TAX,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.DISCOUNTTOTAL ELSE ((IR.AMOUNT*IR.PRICE)-((1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT)) * IR.NETTOTAL)) END AS DISCOUNTTOTAL,
                        CASE WHEN INVOICE.SA_DISCOUNT=0 THEN IR.NETTOTAL ELSE ( (1- INVOICE.SA_DISCOUNT/(INVOICE.NETTOTAL-INVOICE.OTV_TOTAL-INVOICE.TAXTOTAL+INVOICE.SA_DISCOUNT)) * IR.NETTOTAL ) END AS KDVSIZ_TOPLAM,
                        <cfif attributes.report_type eq 2>
                            IR.NAME_PRODUCT AS PRODUCT_NAME,
                            IR.PRODUCT_NAME2 AS PRODUCT_NAME2,
                            ' '  NOTE,
                        <cfelse>
                            INVOICE.NOTE NOTE,
                        </cfif>
                        C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
                        C.MEMBER_CODE,
                        C.OZEL_KOD,
                        C.TAX_OFFICE TAXOFFICE,
                        C.TAX_NO TAXNO,
                        C.TC_IDENTY_NO,
                        0 AS TYPE,
                        INVOICE.PROJECT_ID,
                        IR.ROW_PROJECT_ID,
                        INVOICE.PROCESS_CAT,
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                            <cfloop from="1" to="20" index="i">
                                INVOICE_INFO_PLUS.PROPERTY#i#,
                            </cfloop>
                        </cfif>
                        0 AS PRODUCT_ID,
                        IR.AMOUNT ROW_QUANTITY,
                        ISNULL(IR.UNIT,'Adet') AS UNIT,
                        0 AS PRODUCT_CATID,
                        NULL AS PRODUCT_CAT,
                        INVOICE.REF_NO,
                        INVOICE.DUE_DATE,
                        ISNULL(IR.DUE_DATE,0) AS DUEDATE
                    FROM
                        INVOICE
                        <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                            LEFT JOIN INVOICE_INFO_PLUS  ON INVOICE.INVOICE_ID=INVOICE_INFO_PLUS.INVOICE_ID
                        </cfif>
                        <cfif len(attributes.use_efatura)>
                            LEFT JOIN EINVOICE_RECEIVING_DETAIL ERD ON ERD.INVOICE_ID = INVOICE.INVOICE_ID
                        </cfif>,
                        INVOICE_ROW IR,
                        #dsn_alias#.CONSUMER C
                    WHERE
                        <cfif len(attributes.use_efatura) and attributes.use_efatura eq 1>
                            ERD.INVOICE_ID IS NOT NULL AND
                        <cfelseif len(attributes.use_efatura) and attributes.use_efatura eq 0>
                            ERD.INVOICE_ID IS NULL AND
                        </cfif>
                        INVOICE.CONSUMER_ID = C.CONSUMER_ID
                        AND INVOICE.INVOICE_ID = IR.INVOICE_ID
                        AND IR.PRODUCT_ID IS NULL
                        <cfif len(attributes.process_type)>
                            AND INVOICE.PROCESS_CAT IN (#attributes.process_type#)
                        <cfelse>
                            AND INVOICE.INVOICE_CAT IN (65)
                        </cfif>
                        AND INVOICE.IS_IPTAL = <cfqueryparam cfsqltype="cf_sql_smallint" value="0">
                        <cfif isDefined("attributes.startdate") and isdate(attributes.startdate) and isDefined("attributes.finishdate") and isdate(attributes.finishdate)>
                            AND INVOICE.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
                        </cfif>	
                        <cfif attributes.report_type eq 2>
                            <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                                AND IR.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                            </cfif>
                        <cfelse>
                            <cfif isdefined('attributes.project_id') and len(attributes.project_head) and len(attributes.project_id)>
                                AND INVOICE.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
                            </cfif>
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
                        <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
                            AND INVOICE.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
                        </cfif>
                        <cfif len(bireysel)>
                            AND C.CONSUMER_CAT_ID IN (#bireysel#)
                        </cfif>
                </cfif>
	</cfquery>
	<cfset unit_list = ''>
	<cfloop query="get_invoice_detail">
    	<cfset unit_ = filterSpecialChars(get_invoice_detail.unit)>
		<cfset unit_list=ListDeleteDuplicatesNoCase(ListAppend(unit_list,unit_))>
	</cfloop><!--- Unit Listesi --->
	<cfloop list="#unit_list#" index="tt">
		<cfset 'last_total_amount_#tt#' = 0>
	</cfloop>
<cfelse>
	<cfset get_invoice_detail.recordcount=0>
</cfif>
<cfif get_invoice_detail.recordcount>
	<cfquery name="GET_INVOICE" dbtype="query">
		SELECT 
			<cfif attributes.report_type eq 2> <!--- satır bazında --->
				*
			<cfelse>
				DISTINCT
				ACTION_ID,
				SERIAL_NUMBER,
				SERIAL_NO,
				BELGE_NO,
				ACTION_DATE,
				NETTOTAL,
				TAXTOTAL,
				GROSSTOTAL,
                SUM(DISCOUNTTOTAL) AS INV_DISCOUNTTOTAL,
                IS_TAX_OF_OTV,
				SA_DISCOUNT,
				ROUND_MONEY,
				INVOICE_CAT,
				ACC_DEPARTMENT_ID,
                SUM(OTVTOTAL) OTVTOTAL,
                SUM(OTV_ORAN) OTV_ORAN,
				NOTE,
				FULLNAME,
				MEMBER_CODE,
				OZEL_KOD,
				TAXOFFICE,
				TAXNO,
				TC_IDENTY_NO,
				TYPE,
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                    <cfloop from="1" to="20" index="i">
                        PROPERTY#i#,
                    </cfloop>
            	</cfif>
				PROJECT_ID,
				REF_NO,
				DUE_DATE
			</cfif>,
			PROCESS_CAT
		FROM
			GET_INVOICE_DETAIL
        <cfif attributes.report_type eq 1>
			GROUP BY
				ACTION_ID,
				SERIAL_NUMBER,
				SERIAL_NO,
				BELGE_NO,
				ACTION_DATE,
				NETTOTAL,
				TAXTOTAL,
				GROSSTOTAL,
                IS_TAX_OF_OTV,
				SA_DISCOUNT,
				ROUND_MONEY,
				INVOICE_CAT,
				ACC_DEPARTMENT_ID,
				NOTE,
				FULLNAME,
				MEMBER_CODE,
				OZEL_KOD,
				TAXOFFICE,
				TAXNO,
				TC_IDENTY_NO,
				TYPE,
                <cfif isdefined("attributes.list_type") and listfind(attributes.list_type,11)>
                    <cfloop from="1" to="20" index="i">
                        PROPERTY#i#,
                    </cfloop>
            	</cfif>
				PROJECT_ID,
				REF_NO,
				DUE_DATE
                ,
			PROCESS_CAT
		</cfif>
		ORDER BY 
			ACTION_DATE DESC,
			ACTION_ID,
			FULLNAME,
			ACTION_ID
	</cfquery>
	<cfset unit_list_=''>
<cfelse>
	<cfset get_invoice.recordcount=0>
</cfif>
<cfif isdate(attributes.startdate)>
	<cfset attributes.startdate = dateformat(attributes.startdate, dateformat_style)>
</cfif>
<cfif isdate(attributes.finishdate)>
	<cfset attributes.finishdate = dateformat(attributes.finishdate, dateformat_style)>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_invoice.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="99%" align="center">
	<tr>
		<td class="detailhead"><a href="javascript:gizle_goster_ikili('gizli','invoice_basket');" >&raquo;</a><cf_get_lang dictionary_id='39405.Fatura Listesi Alışlar'></td>
		<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>	
	</tr>
</table>
<cfform name="form" action="" method="post">
<cf_basket_form id="gizli">
<table>
    <tr>
        <input type="hidden" name="form_varmi" id="form_varmi" value="1">
        <td rowspan="6" valign="top"><cf_get_lang dictionary_id='58763.Depo'></td>
        <td rowspan="6" valign="top" width="180">
            <cfquery name="get_all_location" datasource="#DSN#">
                SELECT * FROM STOCKS_LOCATION <cfif x_show_pasive_departments eq 0>WHERE STATUS = 1</cfif>
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
        </td>
        <td rowspan="6" valign="top"><cf_get_lang dictionary_id ='39242.Müşteri Kat'></td>
        <td rowspan="6" valign="top" width="180">
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
        </td>
        <td rowspan="3" valign="top"><cf_get_lang dictionary_id='57800.İşlem Tipi'></td>
        <td rowspan="3" valign="top" width="180">
            <select name="process_type" id="process_type" style="width:170px; height:75px;" multiple>
				<cfoutput query="get_process_cat">
                    <option value="#process_cat_id#" <cfif listfind(attributes.process_type,process_cat_id,',')>selected</cfif>>#process_cat#</option>
                </cfoutput>
            </select>
        </td>
        <td><cf_get_lang dictionary_id='57519.Cari Hesap'></td>
        <td style="width:180px;">
            <input type="hidden" name="company_id" id="company_id"  value="<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
            <input type="text" name="company" id="company" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'0\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','form','3','250');" autocomplete="off" style="width:154px;" value="<cfif isDefined("attributes.company") and len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" >
            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=form.company&field_comp_id=form.company_id&field_name=form.company&field_consumer=form.consumer_id&select_list=2,3&keyword='+encodeURIComponent(document.form.company.value),'list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
         </td>
    </tr>
    <tr>
        <td><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></td>
        <td><input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined('attributes.ship_method_id') and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
            <input type="text" name="ship_method_name" id="ship_method_name" style="width:154px;" value="<cfif isdefined("attributes.ship_method_name") and len(attributes.ship_method_name)><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('ship_method_name','SHIP_METHOD','SHIP_METHOD','get_ship_method','','SHIP_METHOD_ID','ship_method_id','','3','125');" autocomplete="off">
            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=form.ship_method_name&field_id=form.ship_method_id','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>					
        </td>
    </tr>
    <tr>
        <td><cf_get_lang dictionary_id='57416.Proje'></td>	
        <td>
            <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('attributes.project_id')><cfoutput>#attributes.project_id#</cfoutput></cfif>">
            <input type="text" name="project_head" id="project_head" style="width:154px;" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)><cfoutput>#attributes.project_head#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
            <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=rapor.project_id&project_head=rapor.project_head');"> <img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>                    
        </td>
    </tr>
    <tr>
        <td rowspan="3" valign="top"><cf_get_lang dictionary_id="57509.Liste"> <cf_get_lang dictionary_id="38937.Tipi"></td>
        <td rowspan="3" valign="top" width="180">
            <select name="list_type" id="list_type" style="width:170px;height:75px;" multiple>
                <option value="1" <cfif listfind(attributes.list_type,1)>selected</cfif>><cf_get_lang dictionary_id='58794.Referans No'></option>
                <option value="2" <cfif listfind(attributes.list_type,2)>selected</cfif>><cf_get_lang dictionary_id='57881.Vade Tarihi'></option>
                <option value="3" <cfif listfind(attributes.list_type,3)>selected</cfif>><cf_get_lang dictionary_id='57789.Özel Kod'></option>
                <option value="4" <cfif listfind(attributes.list_type,4)>selected</cfif>><cf_get_lang dictionary_id='57629.Açıklama'></option>
                <option value="5" <cfif listfind(attributes.list_type,5)>selected</cfif>><cf_get_lang dictionary_id='58025.TC Kimlik No'></option>
                <option value="6" <cfif listfind(attributes.list_type,6)>selected</cfif>><cf_get_lang dictionary_id='57486.Kategori'></option>
                <option value="13" <cfif listfind(attributes.list_type,13)>selected</cfif>><cf_get_lang dictionary_id='57657.Ürün'></option>
                <option value="7" <cfif listfind(attributes.list_type,7)>selected</cfif>><cf_get_lang dictionary_id='38956.Şube /Departman'></option>
                <option value="8" <cfif listfind(attributes.list_type,8)>selected</cfif>><cf_get_lang dictionary_id='57635.Miktar'></option>
                <option value="9" <cfif listfind(attributes.list_type,9)>selected</cfif>><cf_get_lang dictionary_id='57639.KDV'></option>
                <option value="12" <cfif listfind(attributes.list_type,12)>selected</cfif>><cf_get_lang dictionary_id='58021.ÖTV'></option>
                <option value="10" <cfif listfind(attributes.list_type,10)>selected</cfif>><cf_get_lang dictionary_id='57416.Proje'></option>
           	    <option value="11" <cfif listfind(attributes.list_type,11)>selected</cfif>><cf_get_lang dictionary_id='57810.Ek Bilgi'></option>
            </select>
        </td>
        <td><cf_get_lang dictionary_id='57742.Tarih'></td>
        <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
            <cfinput type="text" name="startdate" id="startdate" style="width:65px;" value="#attributes.startdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
            <cf_wrk_date_image date_field="startdate">
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
            <cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" value="#attributes.finishdate#" validate="#validate_style#" message="#message#" maxlength="10" required="yes">
            <cf_wrk_date_image date_field="finishdate"> 
        </td>
    </tr>
    <tr>
        <td><cf_get_lang dictionary_id='58960.Rapor Tipi'></td>
        <td><select name="report_type" id="report_type" style="width:154px;" onchange="kontrol_report();">
                <option value="1"<cfif isDefined('attributes.report_type') and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                <option value="2"<cfif isDefined('attributes.report_type') and attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
            </select>		
        </td>
    </tr>
	<cfif session.ep.our_company_info.is_efatura>
		<tr>
			<td><cf_get_lang dictionary_id='29872.E-Fatura'></td>
			<td>
				<select name="use_efatura" id="use_efatura" style="width:154px;">
					<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<option value="1" <cfif attributes.use_efatura eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='29492.Kullanıyor'></option>
					<option value="0" <cfif attributes.use_efatura eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='29493.Kullanmıyor'></option>
				</select>
			</td>
		</tr>
	</cfif>
    <tr>	
		<cfif session.ep.our_company_info.is_efatura>
			<td colspan="6">&nbsp;</td>
		</cfif>					
        <td colspan="3" nowrap="nowrap" align="center" valign="bottom">
            <table>
                <tr>
                    <td id="inv_total" <cfif attributes.report_type eq 1>style="display=none;"</cfif>>
                        <input type="checkbox" name="is_inv_total" id="is_inv_total" value="1" <cfif isdefined("attributes.is_inv_total")>checked</cfif>><cf_get_lang dictionary_id ='40652.Fatura Toplam Göster'>			
                    </td>
                    <td id="tevkifat_total" <cfif attributes.report_type eq 2>style="display=none;"</cfif>>
                        <input type="checkbox" name="is_tevkifat" id="is_tevkifat" value="1" <cfif isdefined("attributes.is_tevkifat")>checked</cfif>><cf_get_lang dictionary_id ='40653.Tevkifat Göster'>				
                    </td>
                    <td>
                        <input type="checkbox" name="is_excel" id="is_excel" value="1"<cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id ='57858.Excel Getir'>						
                    </td>
                </tr>
            </table>
        </td>
    </tr>    
</table>
<cf_basket_form_button margintop="1">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
    <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
    <cfelse>
        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
    </cfif>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>&nbsp;
    <cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message#' insert_alert='' type_format="1"></cf_basket_form_button>
</cf_basket_form>
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows=get_invoice.recordcount>	
<cfelse>
	<cfset type_ = 0>
</cfif>
<cf_basket id="invoice_basket">
    <cf_wrk_html_table class="basket_list" table_draw_type="#type_#" filename="invoice_list_purchase_#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
        <cf_wrk_html_thead>
        <cfif isdefined("attributes.is_tevkifat")>
            <cf_wrk_html_tr> 
                <cf_wrk_html_th></cf_wrk_html_th>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cfif listfind(attributes.list_type,1)>
                    <cf_wrk_html_th></cf_wrk_html_th>
                </cfif>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cfif listfind(attributes.list_type,2)>
                    <cf_wrk_html_th></cf_wrk_html_th>
                </cfif>
                <cfif listfind(attributes.list_type,3)>
                    <cf_wrk_html_th></cf_wrk_html_th>
                </cfif>
                <cfif listfind(attributes.list_type,4)>
                    <cf_wrk_html_th></cf_wrk_html_th>
                </cfif>
                <cfif listfind(attributes.list_type,5)>
                    <cf_wrk_html_th></cf_wrk_html_th>
                </cfif>
                <cfif listfind(attributes.list_type,6)>
                    <cf_wrk_html_th></cf_wrk_html_th>
                </cfif>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cfif listfind(attributes.list_type,7)>
                    <cf_wrk_html_th></cf_wrk_html_th>
                </cfif>
                <cfif listfind(attributes.list_type,10)>
                    <cf_wrk_html_th></cf_wrk_html_th>
                </cfif>
                <cfif listfind(attributes.list_type,11)>
                    <cfloop query="get_add_info_name">
                        <cf_wrk_html_th></cf_wrk_html_th>
                    </cfloop>
                </cfif>
                <cfif listfind(attributes.list_type,8)>
                    <cf_wrk_html_th></cf_wrk_html_th>
                </cfif>
                <cfif attributes.report_type eq 2>
                    <cf_wrk_html_th></cf_wrk_html_th>
                </cfif>
                <cfif listfind(attributes.list_type,9)>
                    <cfloop list="#tax_list#" index="tax_t">
                        <cf_wrk_html_th width="150"></cf_wrk_html_th>
                    </cfloop>
                    <cfif isdefined("attributes.is_tevkifat")>
                     <cf_wrk_html_th style="text-align:center;" colspan="#listlen(tax_list)#"><cf_get_lang dictionary_id='58024.Beyan Edilen'><cf_get_lang dictionary_id='57673.Tutar'></cf_wrk_html_th>
                     <cf_wrk_html_th style="text-align:center;" colspan="#listlen(tax_list)#"><cf_get_lang dictionary_id='40655.Tevkikat Tutarı'></cf_wrk_html_th> 
                    </cfif>
                </cfif>
                <cfif listfind(attributes.list_type,12)>
                    <cfloop list="#otv_list#" index="otv_t">
                        <cf_wrk_html_th width="150"></cf_wrk_html_th>
                    </cfloop>
                </cfif>
                <cfif attributes.report_type eq 1>
                    <cf_wrk_html_th width="150"></cf_wrk_html_th>
                    <cf_wrk_html_th width="150"></cf_wrk_html_th>
                    <cf_wrk_html_th width="75"></cf_wrk_html_th>
                </cfif>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cf_wrk_html_th></cf_wrk_html_th>
                <cf_wrk_html_th></cf_wrk_html_th>
            </cf_wrk_html_tr>
        </cfif>
        <cf_wrk_html_tr> 
            <cf_wrk_html_th width="20"><cf_get_lang dictionary_id='57637.Seri No'></cf_wrk_html_th>
            <cf_wrk_html_th width="20"><cf_get_lang dictionary_id='58133.Fatura No'></cf_wrk_html_th>
            <cfif listfind(attributes.list_type,1)>
                <cf_wrk_html_th width="40"><cf_get_lang dictionary_id='58794.Referans No'></cf_wrk_html_th>
            </cfif>
            <cf_wrk_html_th><cf_get_lang dictionary_id='57800.İşlem Tipi'></cf_wrk_html_th>
            <cfif listfind(attributes.list_type,2)>
                <cf_wrk_html_th><cf_get_lang dictionary_id='57881.Vade Tarihi'></cf_wrk_html_th>
            </cfif>
            <cf_wrk_html_th width="150"><cf_get_lang dictionary_id='57742.Tarih'></cf_wrk_html_th>
            <cfif listfind(attributes.list_type,3)>
                <cf_wrk_html_th><cf_get_lang dictionary_id='57789.Özel Kod'></cf_wrk_html_th>
            </cfif>
            <cf_wrk_html_th><cf_get_lang dictionary_id='57519.Cari Hesap'><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_th>
            <cf_wrk_html_th><cf_get_lang dictionary_id='57519.Cari Hesap'></cf_wrk_html_th>
            <cfif listfind(attributes.list_type,4)>
                <cf_wrk_html_th><cf_get_lang dictionary_id ='57629.Açıklama'></cf_wrk_html_th>
            </cfif>
            <cf_wrk_html_th><cf_get_lang dictionary_id='58762.Vergi Dairesi'></cf_wrk_html_th>
            <cf_wrk_html_th><cf_get_lang dictionary_id='57752.Vergi No'></cf_wrk_html_th>
            <cfif listfind(attributes.list_type,5)>
                <cf_wrk_html_th><cf_get_lang dictionary_id='58025.TC Kimlik No'></cf_wrk_html_th>
            </cfif>
            <cfif listfind(attributes.list_type,6)>
                <cf_wrk_html_th><cf_get_lang dictionary_id ='57486.Kategori'></cf_wrk_html_th>
            </cfif>
            <cfif listfind(attributes.list_type,13)>
                <cf_wrk_html_th><cf_get_lang dictionary_id ='57657.Ürün'></cf_wrk_html_th>
            </cfif>
            <cfif listfind(attributes.list_type,7)>
                <cf_wrk_html_th><cf_get_lang dictionary_id='38956.Şube /Departman'></cf_wrk_html_th>
            </cfif>
            <cfif listfind(attributes.list_type,10)>
                <cf_wrk_html_th><cf_get_lang dictionary_id='57416.Proje'></cf_wrk_html_th>
            </cfif>
            <cfif listfind(attributes.list_type,11)>
                <cfloop query="get_add_info_name">
                    <cf_wrk_html_th>
                        <cfoutput>#listgetat(PROPERTY,1,'_')#</cfoutput>
                    </cf_wrk_html_th>
                </cfloop>
            </cfif>
            <cfif listfind(attributes.list_type,8)><!--- belge bazında birimlere gore toplu miktarlar getiriliyor --->
                <cf_wrk_html_th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></cf_wrk_html_th>
            </cfif>
            <cfif attributes.report_type eq 2>
                <cf_wrk_html_th width="150"><cf_get_lang dictionary_id ='38889.Hesap Kodu'></cf_wrk_html_th>
            </cfif>
            <cfif listfind(attributes.list_type,9)>
                <cfloop list="#tax_list#" index="tax_t">
                    <cf_wrk_html_th width="150"><cfoutput>%#NumberFormat(tax_t)#</cfoutput><cf_get_lang dictionary_id='57639.KDV'></cf_wrk_html_th>
                </cfloop>
                <cfif isdefined("attributes.is_tevkifat")>
                    <cfloop list="#tax_list#" index="tax_t">
                        <cf_wrk_html_th width="60"><cfoutput>%#NumberFormat(tax_t)#</cfoutput></cf_wrk_html_th>
                    </cfloop>
                    <cfloop list="#tax_list#" index="tax_t">
                        <cf_wrk_html_th width="60"><cfoutput>%#NumberFormat(tax_t)#</cfoutput></cf_wrk_html_th>
                    </cfloop>
                </cfif>
            </cfif>
            <cfif listfind(attributes.list_type,12)>
                <cfloop list="#otv_list#" index="otv_t">
                    <cf_wrk_html_th width="140"><cfoutput>%#NumberFormat(otv_t)#</cfoutput><cf_get_lang dictionary_id="58021.ötv"></cf_wrk_html_th>
                </cfloop>
            </cfif>
            <cfif attributes.report_type eq 1>
                <cf_wrk_html_th width="150"><cf_get_lang dictionary_id='39067.Kdv siz Toplam'></cf_wrk_html_th>
                <cf_wrk_html_th width="150"><cf_get_lang dictionary_id='57678.Fatura Altı İnd'></cf_wrk_html_th>
                <cf_wrk_html_th width="75"><cf_get_lang dictionary_id='57710.Yuvarlama'></cf_wrk_html_th>
            </cfif>
            <cf_wrk_html_th width="150"><cf_get_lang dictionary_id='57649.Toplam İnd'></cf_wrk_html_th>
            <cf_wrk_html_th width="150"><cf_get_lang dictionary_id='39420.İnd Sonrası Kdv siz Toplam'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id ='58021.ÖTV'><cf_get_lang dictionary_id ='57492.Toplam'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id ='40374.ÖTV nin KDV Toplamı'></cf_wrk_html_th>
            <cf_wrk_html_th width="150"><cf_get_lang dictionary_id='57643.Kdv Toplam'></cf_wrk_html_th>
            <cf_wrk_html_th width="150"><cf_get_lang dictionary_id='57680.Kdv li Toplam'></cf_wrk_html_th>
        </cf_wrk_html_tr>
        </cf_wrk_html_thead>
        <cfscript>
            devir_toplam_miktar = 0;
            toplam_miktar = 0;
			general_otv_total_=0;
            kdvsiz_toplam = 0;
            kdv_toplam = 0;
            kdvli_toplam = 0;
			otv_toplam = 0;
            otvli_toplam = 0;
            devir_toplam = 0;
            devir_genel_toplam=0;
            devir_kdvsiz_toplam_ind=0;
            devir_kdvsiz_tolam=0;
            devir_toplam_indirim=0;
            devir_round_money_total=0;
            devir_fatalti_ind=0;
            fatalti_ind = 0;
            round_money_total = 0;
            toplam_indirim = 0;
            indli_kdvsiz_toplam = 0;
            ind_sonrası_kdvsiz_toplam = 0;
            for(xx=1; xx lte listlen(tax_list); xx=xx+1)
            {
                'kdv_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
                'devir_kdv_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
                'inv_kdv_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
                'beyan_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
                'devir_beyan_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
                'tevkifat_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
                'devir_tevkifat_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
            }
			for(xx=1; xx lte listlen(otv_list); xx=xx+1)
            {
                'otv_genel_toplam_#NumberFormat(listgetat(otv_list,xx))#'=0;
                'devir_otv_genel_toplam_#NumberFormat(listgetat(otv_list,xx))#'=0;
                'inv_otv_genel_toplam_#NumberFormat(listgetat(otv_list,xx))#'=0;
                'otv_devir_beyan_genel_toplam_#NumberFormat(listgetat(otv_list,xx))#'=0;
            }
            inv_toplam_miktar = 0;
            inv_toplam_indirim = 0;
            inv_indli_kdvsiz_toplam = 0;
            inv_kdv_toplam = 0;
            inv_kdvli_toplam = 0;
        </cfscript>
        <cfset product_list = "">
        <cfset expense_list = "">
        <cfset process_cat_id_list = ''>
        <cfset action_id_list = ''>
        <cfset action_id_list2 = ''>
        <cfset action_id_list3 = ''>
        <cfset department_id_list=''>
        <cfset dep_branch_id_list=''>
        <cfset project_id_list = ''>
        <cfset expense_id_list = ''>
        <cfif get_invoice.recordcount>
         	
            <cfif attributes.report_type eq 2>
                <cfoutput query="get_invoice" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif (type eq 0) and len(product_id) and not listfind(product_list,product_id,',')>
                        <cfset product_list = listappend(product_list,product_id,',')>
                    </cfif>
                    <cfif (type eq 1) and len(product_id) and not listfind(expense_list,product_id,',')>
                        <cfset expense_list = listappend(expense_list,product_id,',')>
                    </cfif>
                     <cfif type eq 1 and not listfind(expense_id_list,action_id)>
                        <cfset expense_id_list = Listappend(expense_id_list,action_id)>
                    </cfif>
                    <cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
                        <cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
                    </cfif>
                    <cfif len(acc_department_id) and not listfind(department_id_list,acc_department_id)>
                        <cfset department_id_list = Listappend(department_id_list,acc_department_id)>
                    </cfif>
                    <cfif len(row_project_id) and not listfind(project_id_list,row_project_id)>
                        <cfset project_id_list = Listappend(project_id_list,row_project_id)>
                    </cfif>
                    <cfif type eq 0 and not listfind(action_id_list,action_id)>
                        <cfset action_id_list = Listappend(action_id_list,action_id)>
                    </cfif>
                </cfoutput>
            <cfelse>
                <cfoutput query="get_invoice" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
                        <cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
                    </cfif>
                    <cfif type eq 0 and not listfind(action_id_list,action_id)>
                        <cfset action_id_list = Listappend(action_id_list,action_id)>
                    </cfif>
                    <cfif type eq 1 and not listfind(expense_id_list,action_id)>
                        <cfset expense_id_list = Listappend(expense_id_list,action_id)>
                    </cfif>
                    <cfif len(acc_department_id) and not listfind(department_id_list,acc_department_id)>
                        <cfset department_id_list = Listappend(department_id_list,acc_department_id)>
                    </cfif>
                    <cfif len(project_id) and not listfind(project_id_list,project_id)>
                        <cfset project_id_list = Listappend(project_id_list,project_id)>
                    </cfif>
                </cfoutput>
            </cfif>
            <cfif len(expense_list)>
                <cfset expense_list = listsort(expense_list,"numeric","ASC",",")>
                <cfquery name="get_account_expense" datasource="#dsn2#">
                    SELECT * FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#expense_list#) ORDER BY EXPENSE_ITEM_ID
                </cfquery>
                <cfset expense_list = listsort(listdeleteduplicates(valuelist(get_account_expense.expense_item_id,',')),"numeric","ASC",",")>
            </cfif>
            <cfif len(expense_id_list)>
                <cfquery name="get_invoice_taxes" datasource="#dsn2#">
                    SELECT * FROM INVOICE_TAXES WHERE EXPENSE_ID IN (#expense_id_list#) ORDER BY EXPENSE_ID
                </cfquery>
                <cfoutput query="get_invoice_taxes">
                    <cfset "ex_tax_beyan_#expense_id#_#tax#" = BEYAN_TUTAR>
                    <cfset "ex_tax_tevkifat_#expense_id#_#tax#" = TEVKIFAT_TUTAR>
                </cfoutput>
            </cfif>
            <cfif len(action_id_list)>
                <cfquery name="get_invoice_taxes" datasource="#dsn2#">
                    SELECT * FROM INVOICE_TAXES WHERE INVOICE_ID IN (#action_id_list#) ORDER BY INVOICE_ID
                </cfquery>
                <cfoutput query="get_invoice_taxes">
                    <cfset "tax_beyan_#invoice_id#_#tax#" = TEVKIFAT_TUTAR>
                    <cfset "tax_tevkifat_#invoice_id#_#tax#" = BEYAN_TUTAR>
                </cfoutput>
            </cfif>
            <cfif len(project_id_list)>
                <cfset project_id_list = listsort(project_id_list,"numeric","ASC",",")>
                <cfquery name="get_project" datasource="#dsn#">
                    SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id_list#) ORDER BY PROJECT_ID
                </cfquery>
                <cfset project_id_list = listsort(listdeleteduplicates(valuelist(get_project.PROJECT_ID,',')),"numeric","ASC",",")>
            </cfif>
            <cfif len(department_id_list)>
                <cfquery name="get_department_info" datasource="#dsn#">
                    SELECT
                        B.BRANCH_NAME,
                        D.DEPARTMENT_HEAD,
                        D.DEPARTMENT_ID
                    FROM 
                        BRANCH B,
                        DEPARTMENT D
                    WHERE
                        D.DEPARTMENT_ID IN (#department_id_list#) AND
                        B.BRANCH_ID = D.BRANCH_ID
                </cfquery>
            <cfset department_id_list=listsort(listdeleteduplicates(valuelist(get_department_info.department_id,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(process_cat_id_list)>
                <cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")>			
                <cfquery name="get_process_cat" datasource="#DSN3#">
                    SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
                </cfquery>
                <cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat.PROCESS_CAT_ID,',')),'numeric','ASC',',')>
            </cfif>
            <cfif len(product_list)>
                <cfset product_list = listsort(product_list,"numeric","ASC",",")>
                <cfquery name="get_account_product" datasource="#dsn3#">
                    SELECT 
                    	* 
                    FROM 
                    	#dsn2_alias#.ACCOUNT_PLAN AC LEFT JOIN PRODUCT_PERIOD PP ON AC.ACCOUNT_CODE = PP.ACCOUNT_CODE
                    WHERE 
                    	PERIOD_ID = #session.ep.period_id# 
                        AND PRODUCT_ID IN (#product_list#) 
                    ORDER BY 
                    	PRODUCT_ID
                </cfquery>
                <cfset product_list = listsort(listdeleteduplicates(valuelist(get_account_product.product_id,',')),"numeric","ASC",",")>
            </cfif>
           
            <cfif attributes.page gt 1>
                <cfif attributes.report_type eq 1>
                <!---Belge Bazında--->
                    <cfif isdefined("attributes.is_tevkifat")>
                        <cfoutput query="get_invoice" startrow="1" maxrows="#attributes.startrow-1#">
                            <cfif type eq 0 and not listfind(action_id_list2,action_id)>
                                <cfset action_id_list2 = Listappend(action_id_list2,action_id)>
                            </cfif>
                            <cfif type eq 1 and not listfind(action_id_list3,action_id)>
                                <cfset action_id_list3 = Listappend(action_id_list3,action_id)>
                            </cfif>
                        </cfoutput>
                    </cfif>
                    <cfif len(action_id_list2)>
                        <cfquery name="get_invoice_taxes" datasource="#dsn2#">
                            SELECT * FROM INVOICE_TAXES WHERE INVOICE_ID IN (#action_id_list2#) ORDER BY INVOICE_ID
                        </cfquery>
                        <cfoutput query="get_invoice_taxes">
                            <cfset "tax_beyan_#invoice_id#_#tax#" = BEYAN_TUTAR>
                            <cfset "tax_tevkifat_#invoice_id#_#tax#" = TEVKIFAT_TUTAR>
                        </cfoutput>
                    </cfif>
                    <cfif len(action_id_list3)>
                        <cfquery name="get_invoice_taxes" datasource="#dsn2#">
                            SELECT * FROM INVOICE_TAXES WHERE EXPENSE_ID IN (#action_id_list3#) ORDER BY EXPENSE_ID
                        </cfquery>
                        <cfoutput query="get_invoice_taxes">
                            <cfset "ex_tax_beyan_#expense_id#_#tax#" = BEYAN_TUTAR>
                            <cfset "ex_tax_tevkifat_#expense_id#_#tax#" = TEVKIFAT_TUTAR>
                        </cfoutput>
                    </cfif>
                    <cfoutput query="get_invoice" startrow="1" maxrows="#attributes.startrow-1#">
                        <cfquery name="get_inv_rows" dbtype="query">
                            SELECT 
                                ACTION_ID,
                                ROW_TAXTOTAL,
                                ROW_OTVTOTAL,
                                TAX,
                                DISCOUNTTOTAL,
                                OTVTOTAL,
                                OTV_ORAN,
                                GROSSTOTAL,
                                IS_TAX_OF_OTV,
                                SA_DISCOUNT,
                                ROUND_MONEY
                            FROM 
                                get_invoice_detail 
                            WHERE 
                                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.action_id#">
                                AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.type#">
                        </cfquery>
                        <cfscript>
                            paper_total_discount=0;
							kdv_of_otv_total = 0;
							otv_toplam = 0;
                            for(tt=1; tt lte GET_INV_ROWS.recordcount; tt=tt+1) // satırlardan hesaplananlar
                            {
								if( isdefined ("INV_DISCOUNTTOTAL") and len(INV_DISCOUNTTOTAL) and (GROSSTOTAL - INV_DISCOUNTTOTAL) neq 0)
									oran_2 = ((GROSSTOTAL - INV_DISCOUNTTOTAL) - SA_DISCOUNT) / (GROSSTOTAL - INV_DISCOUNTTOTAL);
								else
								oran_2 = 1;
                                if(isdefined('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') and len(evaluate('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#')))
                                    'kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' = evaluate('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') + GET_INV_ROWS.ROW_TAXTOTAL[tt];
                                else
                                    'kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' =GET_INV_ROWS.ROW_TAXTOTAL[tt];
                                //otv hesaplama
								if(isdefined('otv_toplam_#GET_INV_ROWS.OTV_ORAN[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') and len(evaluate('otv_toplam_#GET_INV_ROWS.OTV_ORAN[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#')))
                                    'otv_toplam_#GET_INV_ROWS.OTV_ORAN[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' = evaluate('otv_toplam_#GET_INV_ROWS.OTV_ORAN[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') + GET_INV_ROWS.ROW_OTVTOTAL[tt];
                                else
                                    'otv_toplam_#GET_INV_ROWS.OTV_ORAN[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' =GET_INV_ROWS.ROW_OTVTOTAL[tt];
								
								if(len(GET_INV_ROWS.DISCOUNTTOTAL[tt])) // fatura altı indirim dahil
                                {
                                    if(isdefined('paper_total_discount') and len(paper_total_discount))
                                        paper_total_discount = paper_total_discount + GET_INV_ROWS.DISCOUNTTOTAL[tt];
                                    else
                                        paper_total_discount = GET_INV_ROWS.DISCOUNTTOTAL[tt];
                                }
								if(isdefined('otv_toplam') and len(otv_toplam) )
									otv_toplam = otv_toplam + wrk_round((GET_INV_ROWS.OTVTOTAL[tt]*oran_2),4);
								else
									otv_toplam =wrk_round((GET_INV_ROWS.OTVTOTAL[tt]*oran_2),4);
								
								if(len(GET_INVOICE.IS_TAX_OF_OTV) and GET_INVOICE.IS_TAX_OF_OTV eq 1 and GET_INV_ROWS.TAX[tt] neq 0 and GET_INV_ROWS.OTV_ORAN[tt] neq 0)
								{
									if(isdefined('kdv_of_otv_total') and len(kdv_of_otv_total) )
										kdv_of_otv_total = kdv_of_otv_total+((GET_INV_ROWS.OTVTOTAL[tt]*GET_INV_ROWS.TAX[tt])/100);
									else
										kdv_of_otv_total = (GET_INV_ROWS.OTVTOTAL[tt]*GET_INV_ROWS.TAX[tt])/100;
								}
                            }				
                            //if(len(GET_INV_ROWS.GROSSTOTAL))
                                //kdvsiz_toplam = kdvsiz_toplam + wrk_round(GET_INV_ROWS.GROSSTOTAL);
                            if(len(GET_INV_ROWS.SA_DISCOUNT))
                                fatalti_ind=fatalti_ind + wrk_round(GET_INV_ROWS.SA_DISCOUNT);
                                paper_total_discount = paper_total_discount + wrk_round(GET_INV_ROWS.SA_DISCOUNT);
                            if(len(GET_INV_ROWS.ROUND_MONEY))
                                round_money_total=round_money_total + wrk_round(GET_INV_ROWS.ROUND_MONEY);				
                    
                            devir_toplam =devir_toplam + TAXTOTAL;
                            devir_genel_toplam =devir_genel_toplam + NETTOTAL;
                            devir_kdvsiz_tolam =devir_kdvsiz_tolam +(GROSSTOTAL-(paper_total_discount));
                            devir_toplam_indirim=devir_toplam_indirim+wrk_round(paper_total_discount);
                            
                            if(attributes.report_type eq 1)
                            {
                                devir_kdvsiz_toplam_ind=(devir_kdvsiz_toplam_ind+ wrk_round(GET_INV_ROWS.GROSSTOTAL));
                                if(len(GET_INV_ROWS.SA_DISCOUNT))
                                    devir_fatalti_ind=devir_fatalti_ind+wrk_round(GET_INV_ROWS.SA_DISCOUNT);
                                if(len(GET_INV_ROWS.ROUND_MONEY))
                                    devir_round_money_total=devir_round_money_total+ wrk_round(GET_INV_ROWS.ROUND_MONEY);
                            }
                            if(attributes.report_type eq 2)
                                devir_toplam_miktar = (devir_toplam_miktar+ROW_QUANTITY);
                        </cfscript>
                        <cfloop list="#tax_list#" index="tax_ii">
                            <cfset tax_count=NumberFormat(tax_ii)>
                            <cfif isdefined('kdv_toplam_#tax_count#_#action_id#_#type#') and len(evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))>
                                <cfset 'devir_kdv_genel_toplam_#tax_count#' = evaluate('devir_kdv_genel_toplam_#tax_count#') + (evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))>
                            </cfif>
                            <cfif isdefined("attributes.is_tevkifat")>
                                <cfif type eq 0 and isdefined('tax_tevkifat_#action_id#_#tax_count#') and len(evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
                                    <cfset 'devir_tevkifat_genel_toplam_#tax_count#' = evaluate('devir_tevkifat_genel_toplam_#tax_count#') + (evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
                                </cfif>
                                <cfif type eq 1 and isdefined('ex_tax_tevkifat_#action_id#_#tax_count#') and len(evaluate('ex_tax_tevkifat_#action_id#_#tax_count#'))>
                                    <cfset 'devir_tevkifat_genel_toplam_#tax_count#' = evaluate('devir_tevkifat_genel_toplam_#tax_count#') + (evaluate('ex_tax_tevkifat_#action_id#_#tax_count#'))>
                                </cfif>
                                <cfif type eq 0 and isdefined('tax_beyan_#action_id#_#tax_count#') and len(evaluate('tax_beyan_#action_id#_#tax_count#'))>
                                    <cfset 'devir_beyan_genel_toplam_#tax_count#' = evaluate('devir_beyan_genel_toplam_#tax_count#') + (evaluate('tax_beyan_#action_id#_#tax_count#'))>
                                </cfif>
                                <cfif type eq 1 and isdefined('ex_tax_beyan_#action_id#_#tax_count#') and len(evaluate('ex_tax_beyan_#action_id#_#tax_count#'))>
                                    <cfset 'devir_beyan_genel_toplam_#tax_count#' = evaluate('devir_beyan_genel_toplam_#tax_count#') + (evaluate('ex_tax_beyan_#action_id#_#tax_count#'))>
                                </cfif>
                            </cfif>
                        </cfloop>
                        <cfloop list="#otv_list#" index="otv_ii">
                            <cfset otv_count=NumberFormat(otv_ii)>
                            <cfif isdefined('kdv_toplam_#otv_count#_#action_id#_#type#') and len(evaluate('kdv_toplam_#otv_count#_#action_id#_#type#'))>
                                <cfset 'devir_kdv_genel_toplam_#otv_count#' = evaluate('devir_kdv_genel_toplam_#otv_count#') + (evaluate('kdv_toplam_#otv_count#_#action_id#_#type#'))>
                            </cfif>
                        </cfloop>
                    </cfoutput>
                <cfelse>
                    <cfoutput query="get_invoice" startrow="1" maxrows="#attributes.startrow-1#">
                        <cfset temp_row_tax_total_=0>
                        <cfset row_grosstotal_=0>
                        <cfif (get_invoice.currentrow eq 1 or get_invoice.ACTION_ID[currentrow] neq get_invoice.ACTION_ID[currentrow-1] or not isdefined('temp_disc_total')) and get_invoice.SA_DISCOUNT neq 0>
                            <cfquery name="GET_INV_ROWS" dbtype="query">
                                SELECT 
                                    ACTION_ID,SUM(DISCOUNTTOTAL) AS INV_DISCOUNTTOTAL
                                FROM 
                                    get_invoice_detail
                                WHERE 
                                    ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.action_id#">
                                    AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.type#">
                                GROUP BY
                                    ACTION_ID
                            </cfquery>
                            <cfset temp_disc_total =GET_INV_ROWS.INV_DISCOUNTTOTAL>
                        </cfif>
                        <cfif get_invoice.SA_DISCOUNT neq 0>
                            <cfset oran_2 = ((GROSSTOTAL - temp_disc_total) - SA_DISCOUNT) / (GROSSTOTAL - temp_disc_total)>
                        <cfelse>
                            <cfset oran_2 =1>
                        </cfif>
                        <cfloop list="#tax_list#" index="tax_ii">
                            <cfset tax_count=NumberFormat(tax_ii)>
                            <cfif NumberFormat(get_invoice.TAX eq tax_count)>
                                <cfif len(get_invoice.ROW_TAXTOTAL)>
                                    <cfset temp_row_tax_total_ = wrk_round(get_invoice.ROW_TAXTOTAL*oran_2)>
                                    <cfif isdefined('devir_kdv_genel_toplam_#tax_count#') and len(evaluate('devir_kdv_genel_toplam_#tax_count#'))>
                                        <cfset 'devir_kdv_genel_toplam_#tax_count#' = evaluate('devir_kdv_genel_toplam_#tax_count#') + (get_invoice.ROW_TAXTOTAL*oran_2)>
                                    <cfelse>
                                        <cfset 'devir_kdv_genel_toplam_#tax_count#' = (get_invoice.ROW_TAXTOTAL*oran_2)>
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cfloop>
                         <cfloop list="#otv_list#" index="otv_ii">
                            <cfset otv_count=NumberFormat(otv_ii)>
                            <cfif NumberFormat(get_invoice.OTV_ORAN eq otv_count)>
                                <cfif len(get_invoice.ROW_OTVTOTAL)>
                                    <cfset temp_row_otv_total_ = wrk_round(get_invoice.ROW_OTVTOTAL*oran_2)>
                                    <cfif isdefined('devir_otv_genel_toplam_#otv_count#') and len(evaluate('devir_otv_genel_toplam_#otv_count#'))>
                                        <cfset 'devir_otv_genel_toplam_#otv_count#' = evaluate('devir_otv_genel_toplam_#otv_count#') + (get_invoice.ROW_OTVTOTAL*oran_2)>
                                    <cfelse>
                                        <cfset 'devir_otv_genel_toplam_#otv_count#' = (get_invoice.ROW_OTVTOTAL*oran_2)>
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cfloop>
                        <cfset devir_toplam_miktar = devir_toplam_miktar+ROW_QUANTITY>
                        <cfif len(get_invoice.DISCOUNTTOTAL)><cfset devir_toplam_indirim=devir_toplam_indirim+(get_invoice.DISCOUNTTOTAL+(get_invoice.DISCOUNTTOTAL*(1-oran_2)))></cfif>
                        <cfif len(get_invoice.KDVSIZ_TOPLAM)>
                            <cfset devir_kdvsiz_tolam = devir_kdvsiz_tolam + (get_invoice.KDVSIZ_TOPLAM*oran_2)>
                            <cfset devir_row_grosstotal_=temp_row_tax_total_+(get_invoice.KDVSIZ_TOPLAM*oran_2)>
                            <cfset devir_genel_toplam = devir_genel_toplam + devir_row_grosstotal_>
                        </cfif>
                        <cfset devir_toplam = devir_toplam + temp_row_tax_total_>
                    </cfoutput>			 
                </cfif>
            </cfif>
        
            <cfoutput query="get_invoice" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif attributes.report_type eq 1>
                <!--- Belge Bazında --->
                    <cfquery name="get_inv_rows" dbtype="query">
                        SELECT 
                            ACTION_ID,
                            ROW_TAXTOTAL,
                            ROW_OTVTOTAL,
                            TAX,
                            DISCOUNTTOTAL,
                            GROSSTOTAL,
                            IS_TAX_OF_OTV,
                            SA_DISCOUNT,
                            OTVTOTAL,
                            OTV_ORAN,
                            ROUND_MONEY,
                            PRODUCT_CAT,
                            PRODUCT_CATID,
                            UNIT,
                            ROW_QUANTITY
                        FROM 
                            GET_INVOICE_DETAIL 
                        WHERE 
                            ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.action_id#">
                            AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.type#">
                    </cfquery>
                 
                    <cfscript>
                        paper_total_discount=0;
                        product_cat_list='';
                        product_cat_id_list='';
						kdv_of_otv_total = 0;
						otv_toplam = 0;
                        for(tt=1; tt lte GET_INV_ROWS.recordcount; tt=tt+1) // satırlardan hesaplananlar
                        {
							if(len(INV_DISCOUNTTOTAL) and (GROSSTOTAL - INV_DISCOUNTTOTAL) neq 0)
								oran_2 = ((GROSSTOTAL - INV_DISCOUNTTOTAL) - SA_DISCOUNT) / (GROSSTOTAL - INV_DISCOUNTTOTAL);
							else
								oran_2 = 1;
                            if(isdefined('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') and len(evaluate('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#')))
                                'kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' = evaluate('kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') + GET_INV_ROWS.ROW_TAXTOTAL[tt];
                            else
                                'kdv_toplam_#GET_INV_ROWS.TAX[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' =GET_INV_ROWS.ROW_TAXTOTAL[tt];
                             
							//otv hesaplama
							if(isdefined('otv_toplam_#GET_INV_ROWS.OTV_ORAN[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') and len(evaluate('otv_toplam_#GET_INV_ROWS.OTV_ORAN[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#')))
								'otv_toplam_#GET_INV_ROWS.OTV_ORAN[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' = evaluate('otv_toplam_#GET_INV_ROWS.OTV_ORAN[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#') + GET_INV_ROWS.ROW_OTVTOTAL[tt];
							else
								'otv_toplam_#GET_INV_ROWS.OTV_ORAN[tt]#_#GET_INV_ROWS.ACTION_ID[tt]#_#get_invoice.type#' =GET_INV_ROWS.ROW_OTVTOTAL[tt];
							   
							if(isdefined('otv_toplam') and len(otv_toplam) )
								otv_toplam = otv_toplam + wrk_round((GET_INV_ROWS.OTVTOTAL[tt]*oran_2),4);
							else
								otv_toplam =wrk_round((GET_INV_ROWS.OTVTOTAL[tt]*oran_2),4);

							   
							 if(len(GET_INVOICE.IS_TAX_OF_OTV) and GET_INVOICE.IS_TAX_OF_OTV eq 1 and GET_INV_ROWS.TAX[tt] neq 0 and GET_INV_ROWS.OTV_ORAN[tt] neq 0)
								{
									if(isdefined('kdv_of_otv_total') and len(kdv_of_otv_total) )
										kdv_of_otv_total = kdv_of_otv_total+((GET_INV_ROWS.OTVTOTAL[tt]*GET_INV_ROWS.TAX[tt])/100);
									else
										kdv_of_otv_total = (GET_INV_ROWS.OTVTOTAL[tt]*GET_INV_ROWS.TAX[tt])/100;
								}  
							  
                            if(len(GET_INV_ROWS.DISCOUNTTOTAL[tt])) // fatura altı indirim dahil
                            {
                                if(isdefined('paper_total_discount') and len(paper_total_discount))
                                    paper_total_discount = paper_total_discount + GET_INV_ROWS.DISCOUNTTOTAL[tt];
                                else
                                    paper_total_discount = GET_INV_ROWS.DISCOUNTTOTAL[tt];
                            }
                            if(len(GET_INV_ROWS.PRODUCT_CATID[tt]) and len(GET_INV_ROWS.PRODUCT_CAT[tt]) and not listfind(product_cat_id_list,GET_INV_ROWS.PRODUCT_CATID[tt]))
                            {
                                product_cat_id_list=listappend(product_cat_id_list,GET_INV_ROWS.PRODUCT_CATID[tt]);
                                product_cat_list=listappend(product_cat_list,GET_INV_ROWS.PRODUCT_CAT[tt],'§'); //alt+789
                            }
                            if(len(GET_INV_ROWS.UNIT[tt])) //birimlere gore miktar toplamı alınıyor
                            {
                                //list=("#chr(176)#,#chr(178)#,#chr(179)#,/, ,.,%,',(,),Ç,ç,İ,-");
                                //list2=("o,2,3,,,,,,,,C,c,i,");
                                unit_=filterSpecialChars(GET_INV_ROWS.UNIT[tt]);
                                if(not listfind(unit_list_,unit_) )
                                {
                                    unit_list_=listappend(unit_list_,unit_);
                                    'total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#_#get_invoice.type#'=GET_INV_ROWS.ROW_QUANTITY[tt];
                                    
                                }
                                else if(isdefined('total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#_#get_invoice.type#') and len(evaluate('total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#_#get_invoice.type#')) )
                                {
                                    'total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#_#get_invoice.type#'=evaluate('total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#_#get_invoice.type#')+GET_INV_ROWS.ROW_QUANTITY[tt];
                                }
                                else
                                {
                                    'total_amount_#GET_INV_ROWS.ACTION_ID[tt]#_#unit_#_#get_invoice.type#'= GET_INV_ROWS.ROW_QUANTITY[tt];
                                }
                            }
                        }
                        if(len(GET_INV_ROWS.GROSSTOTAL))
                            kdvsiz_toplam = kdvsiz_toplam + wrk_round(GET_INV_ROWS.GROSSTOTAL);
                        if(len(GET_INV_ROWS.SA_DISCOUNT))
                            fatalti_ind=fatalti_ind + wrk_round(GET_INV_ROWS.SA_DISCOUNT);
                        if(len(GET_INV_ROWS.ROUND_MONEY))
                            round_money_total=round_money_total + wrk_round(GET_INV_ROWS.ROUND_MONEY);
                    </cfscript>
                    <cf_wrk_html_tbody>
                    <cf_wrk_html_tr>
                        <cf_wrk_html_td>#serial_number#</cf_wrk_html_td>
                        <cf_wrk_html_td>
                            <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
                                #serial_no#
                            <cfelse>
                                <cfif invoice_cat eq 592>
                                    <a href="#request.self#?fuseaction=invoice.form_upd_marketplace_bill&iid=#action_id#" class="tableyazi">#serial_no#</a>
                                <cfelse>
                                    <cfif invoice_cat eq 65>
                                        <a href="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#action_id#" class="tableyazi">#serial_no#</a>
                                    <cfelseif invoice_cat eq 66>
                                        <a href="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#action_id#" class="tableyazi">#serial_no#</a>
                                    <cfelseif invoice_cat eq 120>
                                        <a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#action_id#" class="tableyazi">#serial_no#</a>
                                    <cfelse>
                                        <a href="#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid=#action_id#" class="tableyazi">#serial_no#</a>
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cf_wrk_html_td>
                        <cfif listfind(attributes.list_type,1)><cf_wrk_html_td>#ref_no#</cf_wrk_html_td></cfif>
                        <cf_wrk_html_td width="100"><cfif len(process_cat)>#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</cfif></cf_wrk_html_td>
                        <cfif listfind(attributes.list_type,2)><cf_wrk_html_td format="date">#dateformat(DUE_DATE,dateformat_style)#</cf_wrk_html_td></cfif>
                        <cf_wrk_html_td format="date">#dateformat(ACTION_DATE,dateformat_style)#</cf_wrk_html_td>
                        <cfif listfind(attributes.list_type,3)>
                            <cf_wrk_html_td>#ozel_kod#</cf_wrk_html_td>
                        </cfif>
                        <cf_wrk_html_td>#member_code#</cf_wrk_html_td>
                        <cf_wrk_html_td width="250">#FULLNAME#</cf_wrk_html_td>
                        <cfif listfind(attributes.list_type,4)>
                            <cf_wrk_html_td>#note#</cf_wrk_html_td>
                        </cfif>
                        <cf_wrk_html_td>#TAXOFFICE#</cf_wrk_html_td>
                        <cf_wrk_html_td>#TAXNO#</cf_wrk_html_td>
                        <cfif listfind(attributes.list_type,5)>
                            <cf_wrk_html_td>#TC_IDENTY_NO#</cf_wrk_html_td>
                        </cfif>
                        <cfif listfind(attributes.list_type,6)>
                            <cf_wrk_html_td nowrap="nowrap"><!--- urun kategorileri --->
                            <cfloop list="#product_cat_id_list#" index="cat_ii">
                                #listgetat(product_cat_list,listfind(product_cat_id_list,cat_ii),'§')#
                                <cfif cat_ii neq listlast(product_cat_id_list)>,<cfif attributes.is_excel neq 1> <br/></cfif></cfif>
                            </cfloop>
                            </cf_wrk_html_td>
                        </cfif>
                         <!---<cfif listfind(attributes.list_type,13)>
                            <cf_wrk_html_td nowrap="nowrap">
                           		#product_name#
                            </cf_wrk_html_td>
                        </cfif>--->
                        <cfif listfind(attributes.list_type,7)>
                            <cf_wrk_html_td>
                                 <cfif len(acc_department_id)>#get_department_info.BRANCH_NAME[listfind(department_id_list,acc_department_id,',')]#  - #get_department_info.department_head[listfind(department_id_list,acc_department_id,',')]#</cfif>
                            </cf_wrk_html_td>
                        </cfif>
                        <cfif listfind(attributes.list_type,11)>
                            <cfset get_value.recordcount = 0>
                            <cfset get_type.recordcount = 0>
                            <cfloop query="get_add_info_name">
                                <cf_wrk_html_td>
                                    <cfset my_kolon = replace(PROPERTY,'_NAME','')>
                                    <cfset my_kolon1 = replace(PROPERTY,'_NAME','')>
                                    <cfset my_kolon1 = replace(my_kolon1,'PROPERTY','')>
                                    <cfset my_kolon2 = replace(PROPERTY,'_NAME','')>
                                    <cfset my_kolon2 = my_kolon2&'_TYPE'>
                                    <cfquery name="get_type" datasource="#dsn3#">
                                        SELECT  #my_kolon2# FROM SETUP_PRO_INFO_PLUS_NAMES where #my_kolon2# = 'select' and OWNER_TYPE_ID =-8
                                    </cfquery>
                                    <cfif isnumeric(evaluate('get_invoice.#my_kolon#')) and get_type.recordcount >
                                        <cfquery name="get_value" datasource="#dsn3#">
                                            SELECT SELECT_VALUE,PROPERTY_NO FROM SETUP_PRO_INFO_PLUS_VALUES WHERE PROPERTY_NO = <cfqueryparam cfsqltype="cf_sql_integer" value="#my_kolon1#"> AND INFO_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('get_invoice.#my_kolon#')#">
                                        </cfquery>
                                    <cfelse>
                                        <cfset get_value.recordcount = 0 >
                                    </cfif>
                                    <cfif get_value.recordcount and get_type.recordcount>
                                        #get_value.SELECT_VALUE# 
                                    <cfelse>
                                        #evaluate('get_invoice.#my_kolon#')#
                                    </cfif>
                                    <cfset get_value.recordcount = 0>
                                </cf_wrk_html_td>
                               <cfset get_value.SELECT_VALUE =''>
                            </cfloop>
                             <cfset get_value.SELECT_VALUE =''>
                        </cfif>
                        <cfif listfind(attributes.list_type,10)>
                            <cf_wrk_html_td>
                                <cfif len(project_id)>#get_project.PROJECT_HEAD[listfind(project_id_list,project_id,',')]#</cfif>
                            </cf_wrk_html_td>
                        </cfif>
                        <cfif listfind(attributes.list_type,8)>
                            <cf_wrk_html_td nowrap="nowrap" width="230" style="text-align:right;"><!--- birim bazında miktar toplamları --->
                                <cfloop list="#unit_list_#" index="unit_ii">
                                    <cfif isdefined('total_amount_#action_id#_#unit_ii#_#type#') and len(evaluate('total_amount_#action_id#_#unit_ii#_#type#'))>
                                        #TLFormat(evaluate('total_amount_#action_id#_#unit_ii#_#type#'))# #unit_ii# <br />
                                        <cfset 'last_total_amount_#unit_ii#' = evaluate('last_total_amount_#unit_ii#') + evaluate('total_amount_#action_id#_#unit_ii#_#type#')>
                                    </cfif>
                                </cfloop>
                            </cf_wrk_html_td>
                        </cfif>
                        <cfif listfind(attributes.list_type,9)>
                            <cfloop list="#tax_list#" index="tax_ii">
                                <cfset tax_count=NumberFormat(tax_ii)>
                                <cf_wrk_html_td style="text-align:right;" format="numeric">
                                    <cfif isdefined('kdv_toplam_#tax_count#_#action_id#_#type#') and len(evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))>
                                        #TLFormat(evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))#
                                        <cfset 'kdv_genel_toplam_#tax_count#' = evaluate('kdv_genel_toplam_#tax_count#') + (evaluate('kdv_toplam_#tax_count#_#action_id#_#type#'))>
                                    </cfif>
                                </cf_wrk_html_td>
                            </cfloop>
                            <cfif isdefined("attributes.is_tevkifat")>
                                <cfloop list="#tax_list#" index="tax_ii">
                                    <cfset tax_count=NumberFormat(tax_ii)>
                                    <cf_wrk_html_td style="text-align:right;" format="numeric">
                                        <cfif type eq 0 and isdefined('tax_tevkifat_#action_id#_#tax_count#') and len(evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
                                           <cfif evaluate('tax_tevkifat_#action_id#_#tax_count#') eq 0> #TLFormat(evaluate('tax_tevkifat_#action_id#_#tax_count#'))#<cfelse>#TLFormat(evaluate('tax_tevkifat_#action_id#_#tax_count#')/100)#</cfif>
                                            <cfset 'tevkifat_genel_toplam_#tax_count#' = evaluate('tevkifat_genel_toplam_#tax_count#') + (evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
                                        </cfif>
                                        <cfif type eq 1 and isdefined('ex_tax_tevkifat_#action_id#_#tax_count#') and len(evaluate('ex_tax_tevkifat_#action_id#_#tax_count#'))>
                                            #TLFormat(evaluate('ex_tax_tevkifat_#action_id#_#tax_count#'))#
                                            <cfset 'tevkifat_genel_toplam_#tax_count#' = evaluate('tevkifat_genel_toplam_#tax_count#') + (evaluate('ex_tax_tevkifat_#action_id#_#tax_count#'))>
                                        </cfif>
                                    </cf_wrk_html_td>
                                </cfloop>
                                <cfloop list="#tax_list#" index="tax_ii">
                                    <cfset tax_count=NumberFormat(tax_ii)>
                                    <cf_wrk_html_td style="text-align:right;" format="numeric">
                                        <cfif type eq 0 and isdefined('tax_beyan_#action_id#_#tax_count#') and len(evaluate('tax_beyan_#action_id#_#tax_count#'))>
                                            #TLFormat(evaluate('tax_beyan_#action_id#_#tax_count#'))#
                                            <cfset 'beyan_genel_toplam_#tax_count#' = evaluate('beyan_genel_toplam_#tax_count#') + (evaluate('tax_beyan_#action_id#_#tax_count#'))>
                                        </cfif>
                                        <cfif type eq 1 and isdefined('ex_tax_beyan_#action_id#_#tax_count#') and len(evaluate('ex_tax_beyan_#action_id#_#tax_count#'))>
                                            #TLFormat(evaluate('ex_tax_beyan_#action_id#_#tax_count#'))#
                                            <cfset 'beyan_genel_toplam_#tax_count#' = evaluate('beyan_genel_toplam_#tax_count#') + (evaluate('ex_tax_beyan_#action_id#_#tax_count#'))>
                                        </cfif>
                                    </cf_wrk_html_td>
                                </cfloop>
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.list_type,12)>
                            <cfloop list="#otv_list#" index="otv_ii">
                                <cfset otv_count=NumberFormat(otv_ii)>
                                <cf_wrk_html_td style="text-align:right;" format="numeric">
                                    <cfif isdefined('otv_toplam_#otv_count#_#action_id#_#type#') and len(evaluate('otv_toplam_#otv_count#_#action_id#_#type#'))>
                                        #TLFormat(evaluate('otv_toplam_#otv_count#_#action_id#_#type#'))#
                                        <cfset 'otv_genel_toplam_#otv_count#' = evaluate('otv_genel_toplam_#otv_count#') + (evaluate('otv_toplam_#otv_count#_#action_id#_#type#'))>
                                    </cfif>
                                </cf_wrk_html_td>
                            </cfloop>
                        </cfif>
                        <cf_wrk_html_td style="text-align:right;" format="numeric"><cfif len(grosstotal)>#TlFormat(GROSSTOTAL)#</cfif></cf_wrk_html_td>
                        <cf_wrk_html_td style="text-align:right;" format="numeric">#TlFormat(SA_DISCOUNT)#</cf_wrk_html_td>
                        <cf_wrk_html_td style="text-align:right;" format="numeric"><cfif len(ROUND_MONEY)>#TLFormat(ROUND_MONEY)#</cfif></cf_wrk_html_td>
                        <cf_wrk_html_td style="text-align:right;" format="numeric"><cfif len(paper_total_discount)>#TLFormat(paper_total_discount)#<cfset toplam_indirim=toplam_indirim+wrk_round(paper_total_discount)></cfif></cf_wrk_html_td><!--- FATURA ALTI INDIRIM DAHIL --->
                        <cf_wrk_html_td style="text-align:right;" format="numeric"><cfset ind_sonrası_kdvsiz_toplam = GROSSTOTAL-(paper_total_discount)>#TLFormat(ind_sonrası_kdvsiz_toplam)#</cf_wrk_html_td>
                        <cfset indli_kdvsiz_toplam = indli_kdvsiz_toplam + ind_sonrası_kdvsiz_toplam>
                        <cf_wrk_html_td style="text-align:right" format="numeric"><cfif isdefined('otv_toplam') and len(otv_toplam)><cfset general_otv_total_ = general_otv_total_+wrk_round(otv_toplam)>#TLFormat(otv_toplam)#</cfif></cf_wrk_html_td>
                        <cf_wrk_html_td style="text-align:right" format="numeric"><cfif isdefined('kdv_of_otv_total') and len(kdv_of_otv_total)>#TLFormat(kdv_of_otv_total)#</cfif></cf_wrk_html_td>
                        <cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(TAXTOTAL)#<cfset kdv_toplam = kdv_toplam + TAXTOTAL></cf_wrk_html_td>
                        <cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(NETTOTAL)#<cfset kdvli_toplam = kdvli_toplam + NETTOTAL></cf_wrk_html_td>
                    </cf_wrk_html_tr>	
                    </cf_wrk_html_tbody>	
                <cfelse>
                	<!--- Satır Bazında --->
                		<cfquery name="GET_INV_ROWS_" dbtype="query">
                            SELECT 
                                ACTION_ID,
                                SUM(ROW_TAXTOTAL) AS TOTAL_AMOUNT_KDV,
                                SUM(ROW_OTVTOTAL) AS TOTAL_AMOUNT_OTV
                            FROM 
                                get_invoice_detail
                            WHERE 
                                ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.action_id#">
                                AND TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_invoice.type#">
                            GROUP BY
                                ACTION_ID
                        </cfquery>
                    <cfset temp_row_tax_total_=0>
                    <cfif len(get_invoice.ROW_OTVTOTAL)>
                        <cfset row_grosstotal_=get_invoice.ROW_OTVTOTAL>
                    <cfelse>
                        <cfset row_grosstotal_=0>
                    </cfif>
                    <cfif get_invoice.SA_DISCOUNT neq 0 and (GROSSTOTAL - temp_disc_total) neq 0>
						<cfset oran_2 = ((GROSSTOTAL - temp_disc_total) - SA_DISCOUNT) / (GROSSTOTAL - temp_disc_total)>
                    <cfelse>
                        <cfset oran_2 =1>
                    </cfif>
                    <cf_wrk_html_tbody>
                        <cf_wrk_html_tr>
                            <cf_wrk_html_td>#get_invoice.serial_number#</cf_wrk_html_td>
                            <cf_wrk_html_td style="mso-number-format:\@;">
                                <cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
                                    #serial_no#
                                <cfelse>
                                    <cfif invoice_cat eq 592>
                                        <a href="#request.self#?fuseaction=invoice.form_upd_marketplace_bill&iid=#action_id#" class="tableyazi">#serial_no#</a>
                                    <cfelse>
                                        <cfif invoice_cat eq 65>
                                            <a href="#request.self#?fuseaction=invent.upd_purchase_invent&invoice_id=#action_id#" class="tableyazi">#serial_no#</a>
                                        <cfelseif invoice_cat eq 66>
                                            <a href="#request.self#?fuseaction=invent.upd_invent_sale&invoice_id=#action_id#" class="tableyazi">#serial_no#</a>
                                        <cfelseif invoice_cat eq 120>
                                            <a href="#request.self#?fuseaction=cost.form_add_expense_cost&event=upd&expense_id=#action_id#" class="tableyazi">#serial_no#</a>
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=invoice.form_add_bill_purchas&event=upd&iid=#action_id#" class="tableyazi">#serial_no#</a>
                                        </cfif>
                                    </cfif>
                                </cfif>
                            </cf_wrk_html_td>
                            <cfif listfind(attributes.list_type,1)><cf_wrk_html_td>#ref_no#</cf_wrk_html_td></cfif>
                            <cf_wrk_html_td width="100"><cfif len(process_cat)>#get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#</cfif></cf_wrk_html_td>
                            <cfif listfind(attributes.list_type,2)>
                                <cf_wrk_html_td format="date">
                                    #dateformat(DATE_ADD('d',DUEDATE,ACTION_DATE),dateformat_style)#
                                </cf_wrk_html_td>
                            </cfif>
                            <cf_wrk_html_td format="date">#dateformat(get_invoice.ACTION_DATE,dateformat_style)#</cf_wrk_html_td>
                            <cfif listfind(attributes.list_type,3)>
                                <cf_wrk_html_td>#ozel_kod#</cf_wrk_html_td>
                            </cfif>
                            <cf_wrk_html_td>#get_invoice.member_code#</cf_wrk_html_td>
                            <cf_wrk_html_td width="250">#get_invoice.FULLNAME#</cf_wrk_html_td>
                            <cfif listfind(attributes.list_type,4)>
                                <cf_wrk_html_td>
                                    <cfif type eq 1>
                                        #note#
                                    <cfelse>
                                        <cfif type eq 0>
                                            #get_invoice.PRODUCT_NAME2#
                                        <cfelseif type eq 1>
                                            #get_account_expense.expense_item_name[listfind(expense_list,product_id,',')]#
                                        </cfif>
                                    </cfif>
                                </cf_wrk_html_td>
                            </cfif>
                            <cf_wrk_html_td>#get_invoice.TAXOFFICE#</cf_wrk_html_td>
                            <cf_wrk_html_td>#get_invoice.TAXNO#</cf_wrk_html_td>
                            <cfif listfind(attributes.list_type,5)>
                                <cf_wrk_html_td>#TC_IDENTY_NO#</cf_wrk_html_td>
                            </cfif>
                            <cfif listfind(attributes.list_type,6)>
                                <cf_wrk_html_td>#get_invoice.PRODUCT_CAT#</cf_wrk_html_td>
                            </cfif>
                            <cfif listfind(attributes.list_type,13)>
                                <cf_wrk_html_td>#get_invoice.PRODUCT_NAME#</cf_wrk_html_td>
                            </cfif>
                            <cfif listfind(attributes.list_type,7)>
                                <cf_wrk_html_td>
                                     <cfif len(acc_department_id)>#get_department_info.BRANCH_NAME[listfind(department_id_list,acc_department_id,',')]#  - #get_department_info.department_head[listfind(department_id_list,acc_department_id,',')]#</cfif>
                                </cf_wrk_html_td>
                            </cfif>
                            <cfif listfind(attributes.list_type,11)>
                                <cfif listfind(attributes.list_type,11)>
                                    <cfloop query="get_add_info_name">
                                        <cf_wrk_html_td>
                                            <cfset my_kolon = replace(PROPERTY,'_NAME','')>
                                            <cfset my_kolon1 = replace(PROPERTY,'_NAME','')>
                                            <cfset my_kolon1 = replace(my_kolon1,'PROPERTY','')>
                                            <cfset my_kolon2 = replace(PROPERTY,'_NAME','')>
                                            <cfset my_kolon2 = my_kolon2&'_TYPE'>
                                            <cfquery name="get_type" datasource="#dsn3#">
                                                SELECT  #my_kolon2# FROM SETUP_PRO_INFO_PLUS_NAMES where #my_kolon2# = 'select' and OWNER_TYPE_ID =-8
                                            </cfquery>
                                            <cfif isnumeric(evaluate('get_invoice.#my_kolon#')) and get_type.recordcount >
                                                <cfquery name="get_value" datasource="#dsn3#">
                                                        SELECT SELECT_VALUE,PROPERTY_NO FROM SETUP_PRO_INFO_PLUS_VALUES WHERE PROPERTY_NO = #my_kolon1# AND INFO_ROW_ID=#evaluate('get_invoice.#my_kolon#')#
                                                </cfquery>
                                            <cfelse>
                                                <cfset get_value.recordcount = 0 >
                                            </cfif>
                                            <cfif get_value.recordcount and get_type.recordcount>
                                                #get_value.SELECT_VALUE# 
                                            <cfelse>
                                                #evaluate('get_invoice.#my_kolon#')#
                                            </cfif>
                                            <cfset get_value.recordcount = 0>
                                        </cf_wrk_html_td>
                                    </cfloop>
                                </cfif>
                            </cfif>
                            <cfif listfind(attributes.list_type,10)>
                                <cf_wrk_html_td>
                                    <cfif len(row_project_id)>#get_project.PROJECT_HEAD[listfind(project_id_list,row_project_id,',')]#</cfif>
                                </cf_wrk_html_td>
                            </cfif>
                            <cfif listfind(attributes.list_type,8)>
                                <cf_wrk_html_td style="text-align:right;" format="numeric">
                                    <cfset inv_toplam_miktar = inv_toplam_miktar+ROW_QUANTITY>
                                    <cfset toplam_miktar = toplam_miktar+ROW_QUANTITY>
                                    <cfset devir_toplam_miktar = devir_toplam_miktar+ROW_QUANTITY>
                                    #TLFormat(ROW_QUANTITY)#
                                </cf_wrk_html_td>
                            </cfif>
                            <cf_wrk_html_td>
								<cfif type eq 0 and len(product_list)>
                                    <cfif invoice_cat eq 63><!--- Alinan fiyat farki --->
                                        #get_account_product.account_price_pur[listfind(product_list,product_id,',')]# - #get_account_product.account_name[listfind(product_list,product_id,',')]#
                                     <cfelseif invoice_cat eq 55><!--- Alim iade --->
                                        #get_account_product.account_iade[listfind(product_list,product_id,',')]# - #get_account_product.account_name[listfind(product_list,product_id,',')]#
                                     <cfelseif invoice_cat eq 591><!--- Ihracat --->
                                        #get_account_product.account_yurtdisi_pur[listfind(product_list,product_id,',')]# - #get_account_product.account_name[listfind(product_list,product_id,',')]#
                                     <cfelse><!--- Digerleri (alis oluyor) --->
                                        #get_account_product.account_code_pur[listfind(product_list,product_id,',')]# - #get_account_product.account_name[listfind(product_list,product_id,',')]#
                                     </cfif>
                                 <cfelseif type eq 1 and len(expense_list) and attributes.report_type eq 1><!--- gelir ve masraf iade fisi --->
                                        #get_account_expense.account_code[listfind(expense_list,product_id,',')]#
                                </cfif>
                            </cf_wrk_html_td>
                            <cfloop list="#tax_list#" index="tax_i">
                                <cfset tax_count=NumberFormat(tax_i)>
                                <cfif NumberFormat(get_invoice.TAX eq tax_count)>
                                    <cfif len(get_invoice.ROW_TAXTOTAL)>
                                        <cfset temp_row_tax_total_ = wrk_round(get_invoice.ROW_TAXTOTAL)>
                                    </cfif>
                                </cfif>
                            </cfloop>
                            <cfif listfind(attributes.list_type,9)>
                                <cfloop list="#tax_list#" index="tax_ii">
                                    <cfset tax_count=NumberFormat(tax_ii)>
                                    <cfif NumberFormat(get_invoice.TAX eq tax_count)>
                                        <cf_wrk_html_td style="text-align:right;" format="numeric">
                                        <cfif len(get_invoice.ROW_TAXTOTAL)>
                                            <cfif isdefined('kdv_genel_toplam_#tax_count#') and len(evaluate('kdv_genel_toplam_#tax_count#'))>
                                                <cfset 'kdv_genel_toplam_#tax_count#' = evaluate('kdv_genel_toplam_#tax_count#') + get_invoice.ROW_TAXTOTAL>
                                                <cfset 'inv_kdv_genel_toplam_#tax_count#' = evaluate('inv_kdv_genel_toplam_#tax_count#') + get_invoice.ROW_TAXTOTAL>
                                            <cfelse>
                                                <cfset 'kdv_genel_toplam_#tax_count#' = get_invoice.ROW_TAXTOTAL>
                                                <cfset 'inv_kdv_genel_toplam_#tax_count#' = get_invoice.ROW_TAXTOTAL>
                                            </cfif>
                                            #TLFormat(get_invoice.ROW_TAXTOTAL)#
                                        </cfif></cf_wrk_html_td>
                                    <cfelse>
                                        <cf_wrk_html_td style="text-align:right;"></cf_wrk_html_td>
                                    </cfif>
                                </cfloop>
                                <cfif isdefined("attributes.is_tevkifat")>
                                <cfloop list="#tax_list#" index="tax_ii">
                                    <cfset tax_count=NumberFormat(tax_ii)>
                                    <cf_wrk_html_td style="text-align:right;" format="numeric">
                                        <cfif type eq 0 and isdefined('tax_tevkifat_#action_id#_#tax_count#') and len(evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
                                           <cfif evaluate('tax_tevkifat_#action_id#_#tax_count#') eq 0>#TLFormat((ROW_TAXTOTAL/get_inv_rows_.total_amount_kdv)*evaluate('tax_tevkifat_#action_id#_#tax_count#'))#<cfelse>#TLFormat((ROW_TAXTOTAL/get_inv_rows_.total_amount_kdv)*evaluate('tax_tevkifat_#action_id#_#tax_count#')/100)#</cfif> 
                                            <cfset 'tevkifat_genel_toplam_#tax_count#' = evaluate('tevkifat_genel_toplam_#tax_count#') + ((ROW_TAXTOTAL/get_inv_rows_.total_amount_kdv)*evaluate('tax_tevkifat_#action_id#_#tax_count#'))>
                                        </cfif>
                                        <cfif type eq 1 and isdefined('ex_tax_tevkifat_#action_id#_#tax_count#') and len(evaluate('ex_tax_tevkifat_#action_id#_#tax_count#'))>
                                            #TLFormat((ROW_TAXTOTAL/get_inv_rows_.total_amount_kdv)*evaluate('ex_tax_tevkifat_#action_id#_#tax_count#'))#
                                            <cfset 'tevkifat_genel_toplam_#tax_count#' = evaluate('tevkifat_genel_toplam_#tax_count#') + ((ROW_TAXTOTAL/get_inv_rows_.total_amount_kdv)*evaluate('ex_tax_tevkifat_#action_id#_#tax_count#'))>
                                        </cfif>
                                    </cf_wrk_html_td>
                                </cfloop>
                                <cfloop list="#tax_list#" index="tax_ii">
                                    <cfset tax_count=NumberFormat(tax_ii)>
                                    <cf_wrk_html_td style="text-align:right;" format="numeric">
                                    	 <cfif type eq 0 and isdefined('tax_beyan_#action_id#_#tax_count#') and len(evaluate('tax_beyan_#action_id#_#tax_count#'))>
                                            #TLFormat((ROW_TAXTOTAL/get_inv_rows_.total_amount_kdv)*evaluate('tax_beyan_#action_id#_#tax_count#'))#
                                            <cfset 'beyan_genel_toplam_#tax_count#' = evaluate('beyan_genel_toplam_#tax_count#') + ((ROW_TAXTOTAL/get_inv_rows_.total_amount_kdv)*evaluate('tax_beyan_#action_id#_#tax_count#'))>
                                         </cfif>
										 <cfif type eq 1 and isdefined('ex_tax_beyan_#action_id#_#tax_count#') and len(evaluate('ex_tax_beyan_#action_id#_#tax_count#'))>
                                            #TLFormat((ROW_TAXTOTAL/get_inv_rows_.total_amount_kdv)*evaluate('ex_tax_beyan_#action_id#_#tax_count#'))#
                                            <cfset 'beyan_genel_toplam_#tax_count#' = evaluate('beyan_genel_toplam_#tax_count#') + ((ROW_TAXTOTAL/get_inv_rows_.total_amount_kdv)*evaluate('ex_tax_beyan_#action_id#_#tax_count#'))>
                                         </cfif>
                                    </cf_wrk_html_td>
                                </cfloop>
                            </cfif>	
                            </cfif>		
                            <cfif listfind(attributes.list_type,12)>
                                <cfloop list="#otv_list#" index="otv_ii">
                                    <cfset otv_count=NumberFormat(otv_ii)>
                                    <cfif NumberFormat(get_invoice.otv_oran eq otv_count)>
                                        <cf_wrk_html_td style="text-align:right;" format="numeric">
                                        <cfif len(get_invoice.ROW_OTVTOTAL)>
                                            <cfif isdefined('otv_genel_toplam_#otv_count#') and len(evaluate('otv_genel_toplam_#otv_count#'))>
                                                <cfset 'otv_genel_toplam_#otv_count#' = evaluate('otv_genel_toplam_#otv_count#') + get_invoice.ROW_OTVTOTAL>
                                                <cfset 'inv_otv_genel_toplam_#otv_count#' = evaluate('inv_otv_genel_toplam_#otv_count#') + get_invoice.ROW_OTVTOTAL>
                                            <cfelse>
                                                <cfset 'otv_genel_toplam_#otv_count#' = get_invoice.ROW_OTVTOTAL>
                                                <cfset 'inv_otv_genel_toplam_#otv_count#' = get_invoice.ROW_OTVTOTAL>
                                            </cfif>
                                            #TLFormat(get_invoice.ROW_OTVTOTAL)#
                                        </cfif></cf_wrk_html_td>
                                    <cfelse>
                                        <cf_wrk_html_td style="text-align:right;"></cf_wrk_html_td>
                                    </cfif>
                                </cfloop>
                            </cfif>		
                            <cf_wrk_html_td style="text-align:right;" format="numeric">
								<cfif isdefined("get_inv_rows.grosstotal") and len(get_inv_rows.grosstotal)>
                                    <cfset kdvsiz_toplam = kdvsiz_toplam + wrk_round(get_inv_rows.grosstotal)>
                                </cfif>
                                <cfif len(get_invoice.DISCOUNTTOTAL)>
                                    #TLFormat(get_invoice.DISCOUNTTOTAL)#
                                    <cfset toplam_indirim=toplam_indirim+wrk_round(get_invoice.DISCOUNTTOTAL)>
                                    <cfset inv_toplam_indirim=inv_toplam_indirim+wrk_round(get_invoice.DISCOUNTTOTAL)>
                                </cfif>
                            </cf_wrk_html_td><!--- fatura altı indirimin satır indirimlerine yansıtılmıs hali --->
                            <cf_wrk_html_td style="text-align:right;" format="numeric">
								<cfif len(get_invoice.KDVSIZ_TOPLAM)>
                                    #TLFormat(get_invoice.KDVSIZ_TOPLAM)#
                                    <cfset indli_kdvsiz_toplam = indli_kdvsiz_toplam + get_invoice.KDVSIZ_TOPLAM>
                                    <cfset inv_indli_kdvsiz_toplam = inv_indli_kdvsiz_toplam + get_invoice.KDVSIZ_TOPLAM>
                                    <cfset row_grosstotal_=row_grosstotal_+temp_row_tax_total_+get_invoice.KDVSIZ_TOPLAM>
                                </cfif>
                            </cf_wrk_html_td>
                            <cf_wrk_html_td style="text-align:right" format="numeric">
                            <cfif len(get_invoice.OTVTOTAL)>					
                                <cfset row_grosstotal_=row_grosstotal_+ (get_invoice.OTVTOTAL*oran_2)>
                                <cfset general_otv_total_ = general_otv_total_+ (get_invoice.OTVTOTAL*oran_2)>
                                #TLFormat(get_invoice.OTVTOTAL*oran_2)#
                            </cfif></cf_wrk_html_td>
                            <cf_wrk_html_td style="text-align:right" format="numeric"><cfif len(get_invoice.IS_TAX_OF_OTV) and get_invoice.IS_TAX_OF_OTV eq 1 and len(get_invoice.TAX) and len(get_invoice.OTVTOTAL) and get_invoice.TAX neq 0>#TLFormat((get_invoice.OTVTOTAL*get_invoice.TAX)/100)#<cfelse>#TLFormat(0)#</cfif></cf_wrk_html_td>
                            <cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(temp_row_tax_total_)#<cfset kdv_toplam = kdv_toplam + temp_row_tax_total_><cfset inv_kdv_toplam = inv_kdv_toplam + temp_row_tax_total_></cf_wrk_html_td>
                            <cf_wrk_html_td style="text-align:right;" format="numeric">#TLFormat(row_grosstotal_)#<cfset kdvli_toplam = kdvli_toplam + wrk_round(row_grosstotal_)><cfset inv_kdvli_toplam = inv_kdvli_toplam + wrk_round(row_grosstotal_)></cf_wrk_html_td>
                        </cf_wrk_html_tr>
                    </cf_wrk_html_tbody>
					<cfif isdefined("attributes.is_inv_total") and (get_invoice.action_id[currentrow] neq get_invoice.action_id[currentrow+1] or get_invoice.process_cat[currentrow] neq get_invoice.process_cat[currentrow+1] or currentrow eq attributes.maxrows)>
                        <cf_wrk_html_tfoot>
                            <cf_wrk_html_tr>
                                <cfset cols_ = 8>
                                <cfif listfind(attributes.list_type,1)><cfset cols_ = cols_ + 1></cfif>	
                                <cfif listfind(attributes.list_type,2)><cfset cols_ = cols_ + 1></cfif>
                                <cfif listfind(attributes.list_type,3)><cfset cols_ = cols_ + 1></cfif>	
                                <cfif listfind(attributes.list_type,4)><cfset cols_ = cols_ + 1></cfif>	
                                <cfif listfind(attributes.list_type,5)><cfset cols_ = cols_ + 1></cfif>	
                                <cfif listfind(attributes.list_type,6)><cfset cols_ = cols_ + 1></cfif>	
                                <cfif listfind(attributes.list_type,13)><cfset cols_ = cols_ + 1></cfif>	
                                <cfif listfind(attributes.list_type,7)><cfset cols_ = cols_ + 1></cfif>	
                                <cfif listfind(attributes.list_type,10)><cfset cols_ = cols_ + 1></cfif>
                                <cfif listfind(attributes.list_type,11)>
                                    <cfloop query="get_add_info_name">
                                            <cf_wrk_html_td></cf_wrk_html_td>
                                    </cfloop>
                                </cfif>
								<cfif type_ eq 1>	
                                    <cfset cols_ = cols_ - 1>				
                                    <cfloop index="aa" from="1" to="#cols_#">
                                        <cf_wrk_html_td></cf_wrk_html_td>
                                    </cfloop>
                                    <cfset cols_ = 1>						
                                </cfif>							
                                <cf_wrk_html_td colspan="#cols_#" height="20" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57441.Fatura'><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
                                <cfif listfind(attributes.list_type,8)>
                                    <cf_wrk_html_td height="20" class="txtbold" style="text-align:right;" format="numeric">#TLFormat(inv_toplam_miktar)#</cf_wrk_html_td>
                                </cfif>		
                                <cf_wrk_html_td></cf_wrk_html_td>
                                <cfif listfind(attributes.list_type,9)>
                                    <cfloop list="#tax_list#" index="tax_ii">
                                        <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">
                                            <cfif isdefined('inv_kdv_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('inv_kdv_genel_toplam_#NumberFormat(tax_ii)#'))>
                                                #TLFormat(evaluate('inv_kdv_genel_toplam_#NumberFormat(tax_ii)#'))#
                                            </cfif>
                                        </cf_wrk_html_td>
                                    </cfloop>
                                </cfif>
                                <cfif listfind(attributes.list_type,12)>
                                    <cfloop list="#otv_list#" index="otv_ii">
                                        <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">
                                            <cfif isdefined('inv_otv_genel_toplam_#NumberFormat(otv_ii)#') and len(evaluate('inv_otv_genel_toplam_#NumberFormat(otv_ii)#'))>
                                                #TLFormat(evaluate('inv_otv_genel_toplam_#NumberFormat(otv_ii)#'))#
                                            </cfif>
                                        </cf_wrk_html_td>
                                    </cfloop>
                                </cfif>
                                <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric"><cfif len(inv_toplam_indirim)>#TLFormat(inv_toplam_indirim)#</cfif></cf_wrk_html_td>
                                <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(inv_indli_kdvsiz_toplam)#</cf_wrk_html_td>
                                <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(inv_kdv_toplam)#</cf_wrk_html_td>
                                <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(inv_kdvli_toplam)#</cf_wrk_html_td>
                            </cf_wrk_html_tr>
                        </cf_wrk_html_tfoot>
                        <cfscript>
                            inv_toplam_miktar = 0;
                            inv_toplam_indirim = 0;
                            inv_indli_kdvsiz_toplam = 0;
                            inv_kdv_toplam = 0;
                            inv_kdvli_toplam = 0;
                            for(xx=1; xx lte listlen(tax_list); xx=xx+1)
                            {
                                'inv_kdv_genel_toplam_#NumberFormat(listgetat(tax_list,xx))#'=0;
                            }
                        </cfscript>
                    </cfif>
                </cfif>
            </cfoutput>
            <cf_wrk_html_tfoot>
                <cf_wrk_html_tr>
					<cfoutput>
                        <cfif attributes.report_type eq 2>
                            <cfset cols_ = 8>
                            <cfif listfind(attributes.list_type,1)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,2)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,3)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,4)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,5)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,6)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,13)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,7)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,10)><cfset cols_ = cols_ + 1></cfif>
                            <cfif listfind(attributes.list_type,11)>
                                <cfloop query="get_add_info_name">
                                	<cf_wrk_html_td></cf_wrk_html_td>
                                </cfloop>
                            </cfif>
                            <cfif type_ eq 1>
                                <cfset cols_ = cols_ - 1>					
                                <cfloop index="aa" from="1" to="#cols_#">
                                    <cf_wrk_html_td></cf_wrk_html_td>
                                </cfloop>
                                <cfset cols_ = 1>
                            </cfif>				
                            <cf_wrk_html_td colspan="#cols_#" height="20" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
                            <cfif listfind(attributes.list_type,8)>
                                <cf_wrk_html_td height="20" style="text-align:right;" class="txtbold" format="numeric">#TLFormat(toplam_miktar)#</cf_wrk_html_td>
                            </cfif>	
                            <cf_wrk_html_td></cf_wrk_html_td>
                        <cfelse>
                            <cfset cols_ = 8>
                            <cfif listfind(attributes.list_type,1)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,2)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,3)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,4)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,5)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,6)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,13)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,7)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,10)><cfset cols_ = cols_ + 1></cfif>
                            <cfif listfind(attributes.list_type,11)>
                                <cfloop query="get_add_info_name">
                                	<cf_wrk_html_td></cf_wrk_html_td>
                                </cfloop>
                            </cfif>
                            <cfif type_ eq 1>		
                                <cfset cols_ = cols_ - 1>							
                                <cfloop index="aa" from="1" to="#cols_#">
                                    <cf_wrk_html_td></cf_wrk_html_td>
                                </cfloop>
                                <cfset cols_ = 1>
                            </cfif>
                            <cf_wrk_html_td colspan="#cols_#" height="20" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'></cf_wrk_html_td>
                            <cfif listfind(attributes.list_type,8)>
                                <cf_wrk_html_td class="txtbold" style="text-align:right;" nowrap="nowrap">
                                    <cfloop list="#unit_list#" index="tt">
                                        <cfif evaluate('last_total_amount_#tt#') gt 0>
                                            #Tlformat(evaluate('last_total_amount_#tt#'))# #tt#<br/>
                                        </cfif>
                                    </cfloop>
                                </cf_wrk_html_td>				
                            </cfif>
                        </cfif>
                        <cfif listfind(attributes.list_type,9)>
                            <cfloop list="#tax_list#" index="tax_ii">
                                <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">
                                    <cfif isdefined('kdv_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('kdv_genel_toplam_#NumberFormat(tax_ii)#'))>
                                        #TLFormat(evaluate('kdv_genel_toplam_#NumberFormat(tax_ii)#'))#
                                    </cfif>
                                </cf_wrk_html_td>
                            </cfloop>
                            <cfif isdefined("attributes.is_tevkifat")>
                                <cfloop list="#tax_list#" index="tax_ii">
                                    <cfset tax_count=NumberFormat(tax_ii)>
                                    <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric"><cfif isdefined('tevkifat_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('tevkifat_genel_toplam_#NumberFormat(tax_ii)#')/100)#</cfif></cf_wrk_html_td>
                                </cfloop>
                                <cfloop list="#tax_list#" index="tax_ii">
                                    <cfset tax_count=NumberFormat(tax_ii)>
                                    <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric"><cfif isdefined('beyan_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('beyan_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('beyan_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></cf_wrk_html_td>
                                </cfloop>
                            </cfif>
                        </cfif>
                         <cfif listfind(attributes.list_type,12)>
                            <cfloop list="#otv_list#" index="otv_ii">
                                <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">
                                    <cfif isdefined('otv_genel_toplam_#NumberFormat(otv_ii)#') and len(evaluate('otv_genel_toplam_#NumberFormat(otv_ii)#'))>
                                        #TLFormat(evaluate('otv_genel_toplam_#NumberFormat(otv_ii)#'))#
                                    </cfif>
                                </cf_wrk_html_td>
                            </cfloop>
                        </cfif>
                        <cfif attributes.report_type eq 1>
                            <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(kdvsiz_toplam)#</cf_wrk_html_td>
                            <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(fatalti_ind)#</cf_wrk_html_td>
                            <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric"><cfif len(round_money_total)>#TLFormat(round_money_total)#</cfif></cf_wrk_html_td>
                        </cfif>
                        <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric"><cfif len(toplam_indirim)>#TLFormat(toplam_indirim)#</cfif></cf_wrk_html_td>
                        <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric"><!---#TLFormat(kdvsiz_toplam-toplam_indirim)#--->#TLFormat(indli_kdvsiz_toplam)#</cf_wrk_html_td>
                        <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(general_otv_total_)#</cf_wrk_html_td>
                        <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(otvli_toplam)#</cf_wrk_html_td>
                        <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(kdv_toplam)#</cf_wrk_html_td>
                        <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(kdvli_toplam)#</cf_wrk_html_td>
                    </cfoutput>
                </cf_wrk_html_tr>
            </cf_wrk_html_tfoot>
            <cfif attributes.page gt 1>
                <cfset devir_toplam =devir_toplam + kdv_toplam>
                <cfset devir_genel_toplam =devir_genel_toplam + kdvli_toplam>
                <cfset devir_kdvsiz_tolam =devir_kdvsiz_tolam +indli_kdvsiz_toplam>
                <cfset devir_toplam_indirim =devir_toplam_indirim +toplam_indirim> 
                <cfif attributes.report_type eq 1>
                    <cfset devir_round_money_total=devir_round_money_total+round_money_total>
                    <cfset devir_fatalti_ind=devir_fatalti_ind+fatalti_ind>
                    <cfset devir_kdvsiz_toplam_ind=devir_kdvsiz_toplam_ind+ kdvsiz_toplam>
                </cfif>
                <cfoutput>
                <cf_wrk_html_tfoot>
                	<cf_wrk_html_tr>
						<cfif attributes.report_type eq 2>
                            <cfset cols_ = 8>
                            <cfif listfind(attributes.list_type,1)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,2)><cfset cols_ = cols_ + 1></cfif>
                            <cfif listfind(attributes.list_type,3)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,4)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,5)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,6)><cfset cols_ = cols_ + 1></cfif>
                            <cfif listfind(attributes.list_type,13)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,7)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,10)><cfset cols_ = cols_ + 1></cfif>
                            <cfif listfind(attributes.list_type,11)>
                                <cfloop query="get_add_info_name">
                                    <cf_wrk_html_td></cf_wrk_html_td>
                                </cfloop>
                            </cfif>
                            <cfif type_ eq 1>					
                                <cfset cols_ = cols_ - 1>						
                                <cfloop index="aa" from="1" to="#cols_#">
                                    <cf_wrk_html_td></cf_wrk_html_td>
                                </cfloop>
                                <cfset cols_ = 1>						
                            </cfif>	
                            <cf_wrk_html_td colspan="#cols_#" height="20" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='40654.Kümülatif Toplamlar'></cf_wrk_html_td>
                            <cfif listfind(attributes.list_type,8)>
                                <cf_wrk_html_td height="20" class="txtbold" style="text-align:right;" format="numeric">#TLFormat(devir_toplam_miktar)#</cf_wrk_html_td>
                            </cfif>	
                            <cf_wrk_html_td format="numeric"></cf_wrk_html_td>
                    	<cfelse>
							<cfset cols_ = 8>
                            <cfif listfind(attributes.list_type,1)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,2)><cfset cols_ = cols_ + 1></cfif>
                            <cfif listfind(attributes.list_type,3)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,4)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,5)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,6)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,13)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,7)><cfset cols_ = cols_ + 1></cfif>	
                            <cfif listfind(attributes.list_type,10)><cfset cols_ = cols_ + 1></cfif>
                            <cfif listfind(attributes.list_type,11)>
                            <cfloop query="get_add_info_name">
                            	<cf_wrk_html_td></cf_wrk_html_td>
                            </cfloop>
                    	</cfif>
                        <cfif type_ eq 1>					
                            <cfset cols_ = cols_ - 1>						
                            <cfloop index="aa" from="1" to="#cols_#">
                                <cf_wrk_html_td></cf_wrk_html_td>
                            </cfloop>
                            <cfset cols_ = 1>						
                        </cfif>	
                        <cf_wrk_html_td colspan="#cols_#" height="20" class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id='40654.Kümülatif Toplamlar'></cf_wrk_html_td>
                        <cfif listfind(attributes.list_type,8)><cf_wrk_html_td format="numeric"></cf_wrk_html_td></cfif>	
                    </cfif>
                    <cfif listfind(attributes.list_type,9)>
                        <cfloop list="#tax_list#" index="tax_ii">
                            <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">
                                <cfif isdefined('kdv_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('kdv_genel_toplam_#NumberFormat(tax_ii)#'))>
                                    <cfif isdefined('devir_kdv_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('devir_kdv_genel_toplam_#NumberFormat(tax_ii)#'))>
                                        #TLFormat(evaluate("kdv_genel_toplam_#NumberFormat(tax_ii)#") + evaluate("devir_kdv_genel_toplam_#NumberFormat(tax_ii)#"))#
                                    <cfelse>
                                        #TLFormat(evaluate("kdv_genel_toplam_#NumberFormat(tax_ii)#"))#
                                    </cfif>
                                <cfelseif isdefined('devir_kdv_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('devir_kdv_genel_toplam_#NumberFormat(tax_ii)#'))>
                                    #TLFormat(evaluate("devir_kdv_genel_toplam_#NumberFormat(tax_ii)#"))#
                                </cfif>				
                            </cf_wrk_html_td>
                        </cfloop>
                        <cfif isdefined("attributes.is_tevkifat")>
                            <cfloop list="#tax_list#" index="tax_ii">
                                <cfset tax_count=NumberFormat(tax_ii)>
                                <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric"><cfif isdefined('devir_tevkifat_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('devir_tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('devir_tevkifat_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></cf_wrk_html_td>
                            </cfloop>
                            <cfloop list="#tax_list#" index="tax_ii">
                                <cfset tax_count=NumberFormat(tax_ii)>
                                <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric"><cfif isdefined('devir_beyan_genel_toplam_#NumberFormat(tax_ii)#') and len(evaluate('devir_beyan_genel_toplam_#NumberFormat(tax_ii)#'))>#TLFormat(evaluate('devir_beyan_genel_toplam_#NumberFormat(tax_ii)#'))#</cfif></cf_wrk_html_td>
                            </cfloop>
                        </cfif>
                    </cfif>
                     <cfif listfind(attributes.list_type,12)>
                        <cfloop list="#otv_list#" index="otv_ii">
                            <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">
                                <cfif isdefined('otv_genel_toplam_#NumberFormat(otv_ii)#') and len(evaluate('otv_genel_toplam_#NumberFormat(otv_ii)#'))>
                                    <cfif isdefined('devir_otv_genel_toplam_#NumberFormat(otv_ii)#') and len(evaluate('devir_otv_genel_toplam_#NumberFormat(otv_ii)#'))>
                                        #TLFormat(evaluate("otv_genel_toplam_#NumberFormat(otv_ii)#") + evaluate("devir_otv_genel_toplam_#NumberFormat(otv_ii)#"))#
                                    <cfelse>
                                        #TLFormat(evaluate("otv_genel_toplam_#NumberFormat(otv_ii)#"))#
                                    </cfif>
                                <cfelseif isdefined('devir_otv_genel_toplam_#NumberFormat(otv_ii)#') and len(evaluate('devir_otv_genel_toplam_#NumberFormat(otv_ii)#'))>
                                    #TLFormat(evaluate("devir_otv_genel_toplam_#NumberFormat(otv_ii)#"))#
                                </cfif>				
                            </cf_wrk_html_td>
                        </cfloop>
                    </cfif>
                    <cfif attributes.report_type eq 1>
                        <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(devir_kdvsiz_toplam_ind)#</cf_wrk_html_td>
                        <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(devir_fatalti_ind)#</cf_wrk_html_td>
                        <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric"><cfif len(round_money_total)>#TLFormat(devir_round_money_total)#</cfif></cf_wrk_html_td>
                    </cfif>
                    <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric"><cfif len(toplam_indirim)>#TLFormat(devir_toplam_indirim)#</cfif></cf_wrk_html_td>
                    <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(devir_kdvsiz_tolam)#</cf_wrk_html_td>
                    <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(devir_toplam)#</cf_wrk_html_td>
                    <cf_wrk_html_td class="txtbold" style="text-align:right;" format="numeric">#TLFormat(devir_genel_toplam)#</cf_wrk_html_td>
                </cf_wrk_html_tr>
                </cf_wrk_html_tfoot>
                </cfoutput>
            </cfif>
        <cfelse>
            <cfset colspan_ = 12>
            <cfif listfind(attributes.list_type,1)>
                <cfset colspan_ = colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.list_type,2)>
                <cfset colspan_ = colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.list_type,3)>
                <cfset colspan_ = colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.list_type,4)>
                <cfset colspan_ = colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.list_type,5)>
                <cfset colspan_ = colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.list_type,6)>
                <cfset colspan_ = colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.list_type,13)>
                <cfset colspan_ = colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.list_type,7)>
                <cfset colspan_ = colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.list_type,10)>
                <cfset colspan_ = colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.list_type,8)><!--- belge bazında birimlere gore toplu miktarlar getiriliyor --->
                <cfset colspan_ = colspan_ + 1>
            </cfif>
            <cfif attributes.report_type eq 2>
                <cfset colspan_ = colspan_ + 1>
            </cfif>
            <cfif listfind(attributes.list_type,9)>
                <cfloop list="#tax_list#" index="tax_t">
                    <cfset colspan_ = colspan_ + 1>
                </cfloop>
                <cfif isdefined("attributes.is_tevkifat")>
                    <cfloop list="#tax_list#" index="tax_t">
                        <cfset colspan_ = colspan_ + 1>
                    </cfloop>
                    <cfloop list="#tax_list#" index="tax_t">
                        <cfset colspan_ = colspan_ + 1>
                    </cfloop>
                </cfif>
            </cfif>
            <cfif listfind(attributes.list_type,12)>
                <cfloop list="#otv_list#" index="otv_t">
                    <cfset colspan_ = colspan_ + 1>
                </cfloop>
            </cfif>
            <cfif attributes.report_type eq 1>
                <cfset colspan_ = colspan_ + 3>
            </cfif>
            <cf_wrk_html_tr>
				<cfif isdefined("attributes.form_varmi")>
                    <cfset no_ = '72.Kayıt Yok'>
                <cfelse>
                    <cfset no_ = '289.Filtre Ediniz'>
                </cfif>
                <cf_wrk_html_td colspan="#colspan_#" height="20"><cf_get_lang dictionary_id='#no_#'>!</cf_wrk_html_td>
            </cf_wrk_html_tr>
        </cfif>
    </cf_wrk_html_table>
</cf_basket>
<cfset adres = "">
<cfif get_invoice.recordcount and (attributes.maxrows lt attributes.totalrecords)>
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
	<table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
		<tr>
			<td><cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"></td>
			<!-- sil -->
			<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
		</tr>
	</table>
</cfif>
</cfprocessingdirective>
<script type="text/javascript">
	function kontrol_report()
	{
		/*deger = form.report_type.options[form.report_type.selectedIndex].value;
		if(deger == 2)
		{
			inv_total.style.display = '';
			tevkifat_total.style.display = 'none';
		}
		else
		{
			inv_total.style.display = 'none';
			tevkifat_total.style.display = '';
		}*/
	}
</script>