<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cf_xml_page_edit fuseact="stock.list_command">
    <cf_get_lang_set module_name="stock">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfif x_currency_is_ship eq 1>
        <cfparam name="attributes.currency_id" default="-6">
    <cfelse>
        <cfparam name="attributes.currency_id" default="">
    </cfif>
    <cfparam name="attributes.cat" default="">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.ref_no" default="">
    <cfparam name="attributes.ord_stage" default="">
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.date1" default="">
    <cfparam name="attributes.date2" default="">
    <cfparam name="attributes.documentdate1" default="">
    <cfparam name="attributes.documentdate2" default="">
    <cfparam name="attributes.ship_method" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department_txt" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.stock_id" default="">
    <cfparam name="attributes.product_id" default="">
    <cfparam name="attributes.product_name" default="">
    <cfparam name="attributes.spect_main_id" default="">
    <cfparam name="attributes.spect_main_name" default="">
    <cfparam name="attributes.order_stage" default="">
    <cfparam name="attributes.sale_add_option" default="">
    <cfparam name="attributes.product_code" default="">
    <cfparam name="attributes.product_cat_id" default="">
    <cfparam name="attributes.product_cat" default="">
    <cfparam name="attributes.city_id" default="">
    <cfparam name="attributes.city" default="">
    <cfparam name="attributes.county_id" default="">
    <cfparam name="attributes.county" default="">
    <cfparam name="attributes.product_brand_id" default="">
    <cfparam name="attributes.product_brand_name" default="">
    <cfparam name="attributes.product_model_id" default="">
    <cfparam name="attributes.product_model_name" default="">
    <cfparam name="attributes.subscription_id" default="">
    <cfparam name="attributes.subscription_no" default="">
    <cfparam name="attributes.our_comp_id" default="#session.ep.company_id#">
    <cfparam name="attributes.record_emp_id" default="">
    <cfparam name="attributes.record_emp_name" default="">
    <cfparam name="attributes.deliver_emp_id" default="">
    <cfparam name="attributes.deliver_emp_name" default="">
    <cfparam name="attributes.zone_id" default="">
    <cfif x_equipment_planning_info eq 1>
        <cfparam name="attributes.listing_type" default="3">
    <cfelse>
        <cfparam name="attributes.listing_type" default="1">
    </cfif>
    <cfif isDate(attributes.date1)><cf_date tarih="attributes.date1"></cfif>
    <cfif isDate(attributes.date2)><cf_date tarih="attributes.date2"></cfif>
    <cfif isDate(attributes.documentdate1)><cf_date tarih="attributes.documentdate1"></cfif>
    <cfif isDate(attributes.documentdate2)><cf_date tarih="attributes.documentdate2"></cfif>
    <cfif not (isDate(attributes.date1) or isDate(attributes.date2) or isDate(attributes.documentdate1) or isDate(attributes.documentdate2))>
        <cfquery name="GET_PERIOD_DATE" datasource="#DSN#">
            SELECT PERIOD_YEAR FROM SETUP_PERIOD WHERE PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year-1#"> ORDER BY PERIOD_YEAR
        </cfquery>
        <cfif Len(get_period_date.period_year)>
            <cfset period_startdate_ = '#get_period_date.period_year#-01-01'>
        <cfelse>
            <cfset period_startdate_ = '#session.ep.period_year#-01-01'>
        </cfif>
        <cfset period_finishdate_ = '#session.ep.period_year#-12-31'>
        <!--- Tarih Araliginin 7 Gunden Fazla Olmamasi icin sadece asagidaki functionda uyari veriliyor, uygun degerleri kullanici belirler --->
        <cfif x_is_startdate_diff_period_documentdate eq 1 and x_is_finishdate_diff_period_documentdate eq 1>
            <!--- Donem Basi, Donem Sonu; Donem Basi ve Donem Sonu --->
            <cfif not isDate(attributes.documentdate1)><cfset attributes.documentdate1 = period_startdate_></cfif>
            <cfif not isDate(attributes.documentdate2)><cfset attributes.documentdate2 = period_finishdate_></cfif>
        <cfelseif x_is_startdate_diff_period_documentdate eq 1 and x_is_finishdate_diff_period_documentdate eq 0>
            <!--- Donem Basi, Donem Sonu Degil; Donem Basi ve Bir Hafta Sonrasi --->
            <cfif not isDate(attributes.documentdate1)><cfset attributes.date1 = period_startdate_>
            <cfif not isDate(attributes.documentdate2)><cfset attributes.documentdate1 = date_add('ww',1,period_startdate_)></cfif>
        <cfelseif x_is_startdate_diff_period_documentdate eq 0 and x_is_finishdate_diff_period_documentdate eq 1></cfif>
            <!--- Donem Basi Degil, Donem Sonu; Donem Sonu ve Bir Hafta Oncesi --->
            <cfif not isDate(attributes.documentdate1)><cfset attributes.documentdate1 = date_add('ww',-1,period_finishdate_)></cfif>
            <cfif not isDate(attributes.documentdate2)><cfset attributes.documentdate2 = period_finishdate_></cfif>
        <cfelseif x_is_date_diff_documentdate eq 1>
            <!--- Donem Basi Degil, Donem Sonu Degil; Bugun ve Bir Hafta Oncesi --->
            <cfif not isDate(attributes.documentdate1)><cfset attributes.documentdate1 = date_add("ww",-1,wrk_get_today())></cfif>
            <cfif not isDate(attributes.documentdate2)><cfset attributes.documentdate2 = wrk_get_today()></cfif>
        </cfif>
        <cfif x_is_startdate_diff_period eq 1 and x_is_finishdate_diff_period eq 1>
            <!--- Donem Basi, Donem Sonu; Donem Basi ve Donem Sonu --->
            <cfif not isDate(attributes.date1)><cfset attributes.date1 = period_startdate_></cfif>
            <cfif not isDate(attributes.date2)><cfset attributes.date2 = period_finishdate_></cfif>
        <cfelseif x_is_startdate_diff_period eq 1 and x_is_finishdate_diff_period eq 0>
            <!--- Donem Basi, Donem Sonu Degil; Donem Basi ve Bir Hafta Sonrasi --->
            <cfif not isDate(attributes.date1)><cfset attributes.date1 = period_startdate_>
            <cfif not isDate(attributes.date2)><cfset attributes.date2 = date_add('ww',1,period_startdate_)></cfif>
        <cfelseif x_is_startdate_diff_period eq 0 and x_is_finishdate_diff_period eq 1></cfif>
            <!--- Donem Basi Degil, Donem Sonu; Donem Sonu ve Bir Hafta Oncesi --->
            <cfif not isDate(attributes.date1)><cfset attributes.date1 = date_add('ww',-1,period_finishdate_)></cfif>
            <cfif not isDate(attributes.date2)><cfset attributes.date2 = period_finishdate_></cfif>
        <cfelseif x_is_date_diff eq 1>
            <!--- Donem Basi Degil, Donem Sonu Degil; Bugun ve Bir Hafta Oncesi --->
            <cfif not isDate(attributes.date1)><cfset attributes.date1 = date_add("ww",-1,wrk_get_today())></cfif>
            <cfif not isDate(attributes.date2)><cfset attributes.date2 = wrk_get_today()></cfif>
        </cfif>
    </cfif>
    <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
        <cfparam name="attributes.planning_status" default="">
        <!--- Planlama bazinda ekip tarih bilgileri belirleniyor --->
        <cfparam name="attributes.planning_date" default="#dateFormat(now(),'dd/mm/yyyy')#">
        <cf_date tarih="attributes.planning_date">
        <cfquery name="GET_PLANNING_INFO" datasource="#DSN3#">
            SELECT
                PLANNING_ID,
                PLANNING_DATE,
                TEAM_CODE,
                RELATION_COMP_ID,
                RELATION_CONS_ID
            FROM
                DISPATCH_TEAM_PLANNING
            WHERE
                PLANNING_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">
        </cfquery>
        <!--- Basketteki Miktar Yuvarlamalari Getiriliyor 4SatisSip,6SatinalmaSip,10SatisIrs,11AlimIrs,31SevkIrs, --->
        <cfquery name="GET_BASKET_AMOUNT_ROUND" datasource="#DSN3#">
            SELECT BASKET_ID, ISNULL(AMOUNT_ROUND,0) AMOUNT_ROUND FROM SETUP_BASKET WHERE B_TYPE = 1 AND  BASKET_ID IN (4,6) ORDER BY BASKET_ID
        </cfquery>
        <cfloop query="get_basket_amount_round">
            <cfset "basket_amount_round_#basket_id#" = amount_round>
        </cfloop>
    </cfif>
    <cfquery name="GET_BRANCHES" datasource="#DSN#">
        SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> ORDER BY BRANCH_NAME
    </cfquery>
    <cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
        SELECT SHIP_METHOD_ID,SHIP_METHOD FROM SHIP_METHOD ORDER BY SHIP_METHOD
    </cfquery>
    <cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
        SELECT
            SP.OUR_COMPANY_ID OUR_COMP_ID,
            O.NICK_NAME OUR_COMP_NAME
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
        GROUP BY
            SP.OUR_COMPANY_ID,
            O.NICK_NAME
        ORDER BY
            O.NICK_NAME
    </cfquery>
    <cfquery name="GET_PROCESS" datasource="#DSN#"><!--- siparis, depo sevk asamalari --->
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID,
            PT.PROCESS_NAME,
            PT.PROCESS_ID
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            (	
                <cfif x_equipment_planning_info neq 1>
                    PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%stock.upd_dispatch_internaldemand%"> OR
                </cfif>
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.detail_order_sa%"> OR
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.detail_order%"> OR
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.add_fast_sale%">
            )
        ORDER BY
            PT.PROCESS_NAME,
            PTR.LINE_NUMBER
    </cfquery>
    <cfif x_is_our_company eq 1><!--- Sirket Gorunsun --->
        <cfquery name="GET_OUR_COMP_NAME" datasource="#DSN#">
            SELECT NICK_NAME FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_comp_id#">
        </cfquery>
    </cfif>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif isdefined("attributes.is_submitted")>
        <cfinclude template="../stock/query/get_order_list.cfm">
    <cfelse>
        <cfset get_order_list.recordcount=0>
    </cfif>
    <cfif get_order_list.recordcount>
        <cfparam name="attributes.totalrecords" default='#get_order_list.query_count#'>
    <cfelse>
        <cfparam name="attributes.totalrecords" default='0'>
    </cfif>
     <cfif session.ep.our_company_info.subscription_contract eq 1>
            <cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
                SELECT SALES_ADD_OPTION_ID, SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS
            </cfquery>
        </cfif>
	<cfif x_multiple_process_type_selected eq 1><!--- Coklu Secim Yapilabilsin Secili ise --->
        <cfsavecontent variable="cat_1"><cf_get_lang no='137.Verilen Siparişler'></cfsavecontent>
        <cfsavecontent variable="cat_2"><cf_get_lang no='136.Alınan Siparişler'></cfsavecontent>
        <cfsavecontent variable="cat_3"><cf_get_lang no='256.İşlenen Sevk Talepleri'></cfsavecontent>
        <cfsavecontent variable="cat_4"><cf_get_lang no='270.İşlenmeyen Sevk Talepleri'></cfsavecontent>
        <cfsavecontent variable="cat_5"><cf_get_lang no='345.Teslim Alınan İrsaliyeler'></cfsavecontent>
        <cfsavecontent variable="cat_6"><cf_get_lang no='346.Teslim Alınmayan İrsaliyeler'></cfsavecontent>
        <cfscript>
            CAT_QUERY = QueryNew("CAT_ID, CAT_NAME");
            if(x_equipment_planning_info eq 0 or attributes.listing_type neq 3)
                QueryAddRow(CAT_QUERY,6);
            else
                QueryAddRow(CAT_QUERY,2);
            QuerySetCell(CAT_QUERY,"CAT_ID",1,1);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_1#",1);
            QuerySetCell(CAT_QUERY,"CAT_ID",2,2);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_2#",2);
            if(x_equipment_planning_info eq 0 or attributes.listing_type neq 3)
            {
                QuerySetCell(CAT_QUERY,"CAT_ID",3,3);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_3#",3);
                QuerySetCell(CAT_QUERY,"CAT_ID",4,4);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_4#",4);
                QuerySetCell(CAT_QUERY,"CAT_ID",5,5);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_5#",5);
                QuerySetCell(CAT_QUERY,"CAT_ID",6,6);QuerySetCell(CAT_QUERY,"CAT_NAME","#cat_6#",6);
            }
        </cfscript>		
 	</cfif>
     <cfif get_order_list.recordcount>
     		<cfset company_id_list=''>
            <cfset consumer_id_list=''>
            <cfset partner_id_list=''>
            <cfset priority_list=''>
            <cfset department_list=''>
            <cfset location_list = ''>
            <cfset action_id_list=''>
            <cfset relation_ship_list=''>
            <cfset Complete_List=''>
            <cfset order_row_id_list=''>
            <cfset record_emp_id_list=''>
     <cfoutput query="get_order_list" >
			<cfif isdefined("islem_row_id") and len(islem_row_id) and not listfind(order_row_id_list,islem_row_id)>
                <cfset order_row_id_list=listappend(order_row_id_list,islem_row_id)>
            </cfif>
            <cfif len(company_id) and not listfind(company_id_list,company_id)>
                <cfset company_id_list=listappend(company_id_list,company_id)>
            </cfif>
            <cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
                <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
            </cfif>
            <cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
                <cfset partner_id_list=listappend(partner_id_list,partner_id)>
            </cfif>
            <cfif len(priority_id) and not listfind(priority_list,priority_id)>
                <cfset priority_list=listappend(priority_list,priority_id)>
            </cfif>
            <cfif len(record_emp) and not listfind(record_emp_id_list,record_emp)>
                <cfset record_emp_id_list=listappend(record_emp_id_list,record_emp)>
            </cfif>
            <cfif len(dept_in) and not listfind(department_list,dept_in)>
                <cfset department_list=listappend(department_list,dept_in)>
            </cfif>
            <cfif len(dept_out) and not listfind(department_list,dept_out)>
                <cfset department_list=listappend(department_list,dept_out)>
            </cfif>
            <cfif len("#dept_in#-#loc_in#") and not listfind(location_list,"#dept_in#-#loc_in#")>
                <cfset location_list=listappend(location_list,"#dept_in#-#loc_in#")>
            </cfif>
            <cfif len("#dept_out#-#loc_out#") and not listfind(location_list,"#dept_out#-#loc_out#")>
                <cfset location_list=listappend(location_list,"#dept_out#-#loc_out#")>
            </cfif>
            <cfif type_id eq 1 and len(islem_id) and not listfind(action_id_list,islem_id)><!--- sadece siparislerin order_id leri toplanıyor --->
                <cfset action_id_list=listappend(action_id_list,islem_id)>
            </cfif>
            <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
                <cfif islem_id and not listfind(relation_ship_list,islem_id)>
                    <cfset relation_ship_list = ListAppend(relation_ship_list,islem_id,',')>
                </cfif>
            </cfif>
        </cfoutput>
        <cfif not len(attributes.cat) or listfind(attributes.cat,1) or listfind(attributes.cat,2)><!--- Sadece siparisler icin --->
            <cfif listlen(action_id_list)>
                <cfquery name="GET_SHIPS" datasource="#DSN3#">
                    SELECT
                        OS.ORDER_ID,
                        OS.SHIP_ID,
                        S.SHIP_TYPE,
                        S.SHIP_NUMBER
                    FROM
                        ORDERS_SHIP OS,
                        #dsn2_alias#.SHIP S
                    WHERE 
                        S.SHIP_ID = OS.SHIP_ID AND
                        OS.ORDER_ID IN (<cfqueryparam list="yes" value="#action_id_list#">)
                </cfquery>
            </cfif>
        </cfif>
        <cfif len(priority_list)>
            <cfset priority_list=listsort(priority_list,'numeric','asc',',')>
            <cfquery name="GET_COMMETHOD" datasource="#DSN#">
                SELECT PRIORITY_ID,PRIORITY,COLOR FROM SETUP_PRIORITY WHERE PRIORITY_ID IN (<cfqueryparam list="yes" value="#priority_list#">) ORDER BY PRIORITY_ID
            </cfquery>
            <cfset priority_list = listsort(listdeleteduplicates(valuelist(get_commethod.priority_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(record_emp_id_list)>
            <cfset record_emp_id_list=listsort(record_emp_id_list,'numeric','asc',',')>
            <cfquery name="get_rec_emp" datasource="#DSN#">
                SELECT EMPLOYEE_ID,EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME EMPLOYEE FROM EMPLOYEES WHERE EMPLOYEE_ID IN (<cfqueryparam list="yes" value="#record_emp_id_list#">) ORDER BY EMPLOYEE_ID
            </cfquery>
            <cfset record_emp_id_list = listsort(listdeleteduplicates(valuelist(get_rec_emp.employee_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(department_list)>
            <cfset department_list=listsort(department_list,'numeric','asc',',')>
            <cfquery name="GET_DEPT_NAME" datasource="#DSN#">
                SELECT DEPARTMENT_HEAD,DEPARTMENT_ID,BRANCH_ID FROM DEPARTMENT WHERE DEPARTMENT_ID IN (<cfqueryparam list="yes" value="#department_list#">) AND IS_STORE <> 2 ORDER BY DEPARTMENT_ID
            </cfquery>
            <cfset main_department_list = listsort(listdeleteduplicates(valuelist(get_dept_name.department_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif ListLen(location_list,',')>
            <cfset location_list=listsort(location_list,'text','asc',',')>
            <cfquery name="get_location" datasource="#dsn#">
                SELECT
                    SL.COMMENT,
                    CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) DEPARTMENT_LOCATIONS_
                FROM
                    DEPARTMENT D,
                    STOCKS_LOCATION SL
                WHERE
                    D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
                    D.IS_STORE <> 2 AND
                    CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10)) IN (#ListQualify(location_list,"'",",")#)
                ORDER BY
                    CAST(D.DEPARTMENT_ID AS NVARCHAR(10)) + CAST('-' AS NVARCHAR(1)) + CAST(SL.LOCATION_ID AS NVARCHAR(10))
            </cfquery>
            <cfset location_list = ListSort(ListDeleteDuplicates(ValueList(get_location.department_locations_,',')),"text","asc",",")>
        </cfif>
        <cfif listlen(company_id_list)>
            <cfset company_id_list=listsort(company_id_list,"numeric","asc",",")>
            <cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
                SELECT FULLNAME,COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (<cfqueryparam list="yes" value="#company_id_list#">) ORDER BY COMPANY_ID
            </cfquery>
            <cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(consumer_id_list)>
            <cfset consumer_id_list=listsort(consumer_id_list,"numeric","asc",",")>
            <cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
                SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID IN (<cfqueryparam list="yes" value="#consumer_id_list#">) ORDER BY CONSUMER_ID
            </cfquery>
            <cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif listlen(partner_id_list)>
            <cfset partner_id_list=listsort(partner_id_list,"numeric","asc",",")>
            <cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
                SELECT
                    CP.COMPANY_PARTNER_NAME,
                    CP.COMPANY_PARTNER_SURNAME,
                    C.NICKNAME,
                    CP.PARTNER_ID
                FROM
                    COMPANY_PARTNER CP,
                    COMPANY C
                WHERE 
                    CP.PARTNER_ID IN (<cfqueryparam list="yes" value="#partner_id_list#">) AND
                    CP.COMPANY_ID = C.COMPANY_ID
                ORDER BY
                    CP.PARTNER_ID
            </cfquery>
            <cfset partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif ListLen(relation_ship_list)>
            <cfquery name="GET_SETUP_PERIOD" datasource="#DSN#">
                SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            </cfquery>
            <cfquery name="GET_RELATION_SHIP" datasource="#DSN3#">
                <cfloop query="get_setup_period">
                    SELECT
                        SHIP_ROW.WRK_ROW_RELATION_ID, 
                        SHIP_ROW.AMOUNT
                    FROM
                        #dsn#_#get_setup_period.period_year#_#get_setup_period.our_company_id#.SHIP_ROW SHIP_ROW,
                        ORDERS_SHIP OS,
                        ORDER_ROW ORR
                    WHERE
                        OS.SHIP_ID = SHIP_ROW.SHIP_ID
                        AND OS.ORDER_ID = ORR.ORDER_ID
                        AND SHIP_ROW.WRK_ROW_RELATION_ID=ORR.WRK_ROW_ID
                        AND OS.ORDER_ID IN (<cfqueryparam list="yes" value="#relation_ship_list#">)
                    <cfif currentrow neq get_setup_period.recordcount>
                    UNION ALL
                    </cfif>
                </cfloop>
                ORDER BY WRK_ROW_RELATION_ID
            </cfquery>
            <cfif not GET_RELATION_SHIP.recordcount>
                <!--- Irsaliye yoksa direkt faturaya da cekilmis olabilir --->
                <cfquery name="GET_RELATION_SHIP" datasource="#DSN3#">
                    <cfloop query="get_setup_period">
                        SELECT
                            INVOICE_ROW.WRK_ROW_RELATION_ID, 
                            INVOICE_ROW.AMOUNT
                        FROM
                            #dsn#_#get_setup_period.period_year#_#get_setup_period.our_company_id#.INVOICE_ROW INVOICE_ROW,
                            ORDERS_INVOICE OS,
                            ORDER_ROW ORR
                        WHERE
                            OS.INVOICE_ID = INVOICE_ROW.INVOICE_ID
                            AND OS.ORDER_ID = ORR.ORDER_ID
                            AND INVOICE_ROW.WRK_ROW_RELATION_ID=ORR.WRK_ROW_ID
                            AND OS.ORDER_ID IN (<cfqueryparam list="yes" value="#relation_ship_list#">)
                        <cfif currentrow neq get_setup_period.recordcount>
                        UNION ALL
                        </cfif>
                    </cfloop>
                    ORDER BY WRK_ROW_RELATION_ID
                </cfquery>
            </cfif>
        </cfif>
        <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
            <cfquery name="GET_MULTISHIP_PLANNING_INFO" datasource="#DSN2#"><!--- Planlama Miktarlari --->
                SELECT
                    SR.OUT_DATE,
                    SR.SHIP_RESULT_ID,
                    SR.EQUIPMENT_PLANNING_ID,
                    SRR.SHIP_RESULT_ROW_ID,
                    SRR.ORDER_ROW_AMOUNT,
                    SRR.ORDER_ROW_ID,
                    SRR.WRK_ROW_ID
                FROM
                    SHIP_RESULT SR,
                    SHIP_RESULT_ROW SRR
                WHERE
                    SR.SHIP_RESULT_ID = SRR.SHIP_RESULT_ID
                    AND SRR.ORDER_ROW_ID IN (<cfqueryparam list="yes" value="#order_row_id_list#">)
                ORDER BY
                    SR.SHIP_RESULT_ID DESC
            </cfquery>
            <cfquery name="GET_DEPT_AMOUNT_SPEC_PROD" datasource="#DSN3#"><!--- Spec- Depo Üretim Emri Miktari --->
                SELECT 
                    ISNULL(SUM(PORR.AMOUNT),0) AS QUANTITY,
                    POR.ORDER_ROW_ID
                FROM 
                    PRODUCTION_ORDERS PO,
                    PRODUCTION_ORDERS_ROW POR,
                    PRODUCTION_ORDER_RESULTS PORS,
                    PRODUCTION_ORDER_RESULTS_ROW PORR
                WHERE
                    PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID
                    AND PO.P_ORDER_ID = PORS.P_ORDER_ID
                    AND PORS.PR_ORDER_ID = PORR.PR_ORDER_ID
                    AND PORR.STOCK_ID = PO.STOCK_ID
                    AND POR.ORDER_ROW_ID IN (<cfqueryparam list="yes" value="#order_row_id_list#">)
                    AND PORS.PR_ORDER_ID IN(SELECT SF.PROD_ORDER_RESULT_NUMBER FROM #dsn2_alias#.STOCK_FIS SF WHERE SF.PROD_ORDER_RESULT_NUMBER IS NOT NULL AND SF.PROD_ORDER_RESULT_NUMBER = PORS.PR_ORDER_ID)
                GROUP BY 
                    POR.ORDER_ROW_ID
            </cfquery>
            <cfquery name="GET_PRODUCTION_DATE_INFO_ALL" datasource="#DSN3#">
                SELECT
                    PO.FINISH_DATE,
                    POR.ORDER_ROW_ID,
                    PO.STOCK_ID
                FROM
                    PRODUCTION_ORDERS PO,
                    PRODUCTION_ORDERS_ROW POR						
                WHERE
                    PO.P_ORDER_ID = POR.PRODUCTION_ORDER_ID AND
                    POR.ORDER_ROW_ID IN (<cfqueryparam list="yes" value="#order_row_id_list#">) AND
                    IS_STAGE <> -1
                ORDER BY
                    STOCK_ID,
                    FINISH_DATE DESC
            </cfquery>
            <cfquery name="GET_COMPLETE" datasource="#DSN2#"><!--- Problemli Sevkiyat Kayitlari --->
                SELECT WRK_ROW_RELATION_ID FROM SHIP_RESULT_ROW_COMPLETE WHERE PROBLEM_RESULT_ID = 1
            </cfquery>
            <cfset Complete_List = ValueList(Get_Complete.Wrk_Row_Relation_Id,',')>
        </cfif>
        <!--- Plan Bilgisi; Ekip Tarihinde Planlanmis Urunlerin Toplamlari --->
        <cfif x_equipment_planning_info eq 1 and attributes.listing_type eq 3>
            <cfquery name="GET_PLANNING_RELATION_ROW" datasource="#DSN3#">
                SELECT
                    SUM(ISNULL(SRR.ORDER_ROW_AMOUNT,0)) RESULT_AMOUNT,
                    ORR.STOCK_ID,
                    (SELECT SPECT_MAIN_ID FROM SPECTS S WHERE S.SPECT_VAR_ID = ORR.SPECT_VAR_ID) SPECT_MAIN_ID
                FROM
                    ORDER_ROW ORR,
                    #dsn2_alias#.SHIP_RESULT_ROW SRR
                WHERE
                    ORR.WRK_ROW_ID = SRR.WRK_ROW_RELATION_ID AND
                    SRR.SHIP_RESULT_ID IN (SELECT SHIP_RESULT_ID FROM #dsn2_alias#.SHIP_RESULT WHERE OUT_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.planning_date#">)
                GROUP BY
                    ORR.STOCK_ID,
                    ORR.SPECT_VAR_ID
            </cfquery>
        </cfif>
        <!--- //Plan Bilgisi --->
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'detail'>
	<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
	<cfif isdefined("attributes.id")>
      <cfset attributes.order_id=attributes.id>
    </cfif>
    <cfscript>session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,process_type:1);</cfscript>
    <cfinclude template="../stock/query/get_priorities.cfm">
    <cfinclude template="../stock/query/get_order_detail.cfm">
    <cfif not GET_ZONE_TYPE.recordcount>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfquery name="GET_ORDERS_SHIP" datasource="#dsn3#">
        SELECT 
            ORDER_SHIP_ID, 
            ORDER_ID, 
            SHIP_ID, 
            PERIOD_ID, 
            CHANGE_RESERVE_STATUS, 
            ADD_FLAG 
        FROM 
            ORDERS_SHIP 
        WHERE 
            ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID = #session.ep.period_id#
    </cfquery>
    <cfquery name="GET_ORDERS_INVOICE" datasource="#dsn3#">
        SELECT 
            ORDER_INVOICE_ID, 
            INVOICE_ID, 
            INVOICE_NUMBER, 
            ORDER_ID, 
            ORDER_NUMBER, 
            PERIOD_ID, 
            CHANGE_RESERVE_STATUS, 
            ADD_FLAG 
        FROM 
            ORDERS_INVOICE 
        WHERE 
            ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID = #session.ep.period_id#
    </cfquery>	
	<cfif len(get_order_detail.offer_id)>
		<cfset attributes.offer_id = get_order_detail.offer_id>
        <cfinclude template="../stock/query/get_offer_head.cfm">
    </cfif>
    <cfif len(get_order_detail.subscription_id)>
        <cfquery name="GET_SUB" datasource="#DSN3#">
            SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #get_order_detail.subscription_id#
        </cfquery>
    </cfif>
	<cfif len(get_order_detail.ship_method)>
        <cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
            SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #get_order_detail.ship_method#
        </cfquery>
    </cfif>
    <cfif len(get_order_detail.project_id)>
        <cfquery name="GET_PROJECT" datasource="#DSN#">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_order_detail.project_id#
        </cfquery>
	</cfif>
	<cfset attributes.basket_id = 14>
    <cfset attributes.is_view= 1 >
<cfelseif isdefined("attributes.event") and attributes.event is 'detail2'>
	<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
	<cfif isdefined("attributes.id")>
        <cfset attributes.order_id=attributes.id>
    </cfif>
    <cfscript>session_basket_kur_ekle(action_id=attributes.order_id,table_type_id:3,process_type:1);</cfscript>
    <cfinclude template="../stock/query/get_priorities.cfm">
    <cfset order_purchase=1>
    <cfinclude template="../stock/query/get_order_detail.cfm">
    <cfinclude template="../stock/query/get_stores.cfm">
    <cfquery name="GET_ORDERS_SHIP" datasource="#dsn3#">
        SELECT * FROM ORDERS_SHIP WHERE ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID = #session.ep.period_id#
    </cfquery>
    <cfquery name="GET_ORDERS_INVOICE" datasource="#dsn3#">
        SELECT * FROM ORDERS_INVOICE WHERE ORDER_ID = #get_order_detail.order_id# AND PERIOD_ID = #session.ep.period_id#
    </cfquery>	
    <cfif session.ep.our_company_info.project_followup eq 1 and len(get_order_detail.project_id)>
        <cfquery name="GET_PROJECT" datasource="#dsn#">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_order_detail.project_id#
        </cfquery>
    </cfif>
	<cfif len(get_order_detail.offer_id) and (get_order_detail.offer_id neq 0)>
		<cfset attributes.offer_id = get_order_detail.offer_id>
        <cfinclude template="../stock/query/get_offer_head.cfm">
	</cfif>
    <cfif len(get_order_detail.SHIP_METHOD)>
        <cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
            SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID=#get_order_detail.SHIP_METHOD#
        </cfquery>
    </cfif>
	<cfset attributes.basket_id = 15 >
	<cfset attributes.is_view = 1 > 
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<script type="text/javascript">
		$(document).ready(
		function(){
      			document.getElementById('keyword').focus();
			});
		function show_order_detail(row_id,product_id,stock_id,spect_var_id,purchase_sales)
		{
			document.getElementById('show_rezerved_orders_detail'+row_id+'').style.display='block';
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_reserved_orders&is_from_stock=1&taken='+purchase_sales+'&spect_var_id='+spect_var_id+'&pid='+product_id+'&sid='+stock_id+'&row_id='+row_id+'','show_rezerved_orders_detail'+row_id+'',1);
		}
		
		function contrl_funcs(my_val)
		{
			
		if(my_val==3)
		{document.list_order.cat.value=2;}	
		else
			$('#records_problems').attr('readonly', true);
		}
		function temizle(x)
		{
			if (x == 1)
				if(list_order.county.value.length == 0) list_order.county_id.value='';
			else
				if(list_order.city.value.length == 0) list_order.city_id.value='';
		}
		
		function input_control()
		{
			<cfif x_is_date_diff eq 1>
				if(datediff(document.getElementById('date1').value,document.getElementById('date2').value,0) >= 8)
				{
					alert("<cf_get_lang no ='549.Tarih Aralığı En Fazla 7 Gün Olmalıdır'>!")
					return false;
				}
			</cfif>
			<cfif x_is_date_diff_documentdate eq 1>
				if(datediff(document.getElementById('documentdate1').value,document.getElementById('documentdate2').value,0) >= 8)
				{
					alert("<cf_get_lang no ='549.Tarih Aralığı En Fazla 7 Gün Olmalıdır'>!")
					return false;
				}
			</cfif>
			if( document.getElementById('records_problems') != undefined && document.getElementById('records_problems').checked==true && document.getElementById("listing_type").value != 3)
			{
				alert('Sorunlu Kayıtlar Filtresi Yalnızca Sevkiyat Bazında Filtrelenir')	;
				return false; 
			}
		
			<cfif not session.ep.our_company_info.unconditional_list>
				if(list_order.project_head.value.length==0) 
					list_order.project_id.value='';
				if(list_order.keyword.value.length==0 && list_order.cat.value.length==0 && list_order.ship_method.value.length==0 && (list_order.company.value.length == 0 || (list_order.consumer_id.value.length == 0 && list_order.company_id.value.length == 0)) && list_order.project_head.value.length==0 && list_order.ord_stage.value.length==0
				&& (list_order.city_id.value.length == 0 || list_order.city.value.length == 0) && (list_order.county_id.value.length == 0 || list_order.county.value.length == 0) && (list_order.date1.value.length == 0) && (list_order.date2.value.length == 0)) 
				{
				   alert ("<cf_get_lang_main no='114.En Az Bir Alanda Filtre Etmelisiniz'>!"); 
				   return false;
				}
				else
					return true;
			<cfelse>
				return true;
			</cfif>
		}
		
		<cfif attributes.listing_type eq 3>
		function kontrol_sevk()
		{
			if(document.getElementById("process_stage").value == '')
			{
				alert("<cf_get_lang_main no='564.Lütfen Süreçlerinizi Tanımlayınız ve/veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'>");
				return false;
			}
			var order_row_list_ = '';
			var row_equipment_control_ = 0;
			
			var ekip_list_ = '0';
			var ekip_cus_list_ = '0';
		
			<cfif get_order_list.recordcount>
				<cfoutput query="get_order_list" >
					//Xmlde Ekip planlamada Cari iliskisi kurulsun secilir ise, ayni sevkiyat icerisine birden fazla cari eklenmemesi gerekiyor
					<cfif x_equipment_planning_relation_member eq 1>
						if(document.getElementById("equipment_planning_#islem_row_id#").value != '')
						{	
							ekip_id_ = document.getElementById("equipment_planning_#islem_row_id#").value;
							var get_equipment_comp = wrk_query("SELECT PLANNING_ID FROM DISPATCH_TEAM_PLANNING WHERE (RELATION_COMP_ID IS NOT NULL OR RELATION_CONS_ID IS NOT NULL) AND PLANNING_ID = " +  ekip_id_,"dsn3");
							if(get_equipment_comp.recordcount)
							{
								ekip_list_ = ekip_list_ + ',' + ekip_id_;
								<cfif len(company_id)>
									ekip_cus_list_ = ekip_cus_list_ + ',' + 'comp-#company_id#';
								<cfelse>
									ekip_cus_list_ = ekip_cus_list_ + ',' + 'cons-#consumer_id#';
								</cfif>
							}
						}
					</cfif>
					
					if(document.getElementById("equipment_planning_#islem_row_id#").value != '' || document.getElementById("old_equipment_planning_#islem_row_id#").value != '')
						var order_row_list_ = order_row_list_  + '#islem_row_id#,';
		
					if((document.getElementById("equipment_planning_#islem_row_id#").value != '' && filterNum(document.getElementById("diff_amount_#islem_row_id#").value) == 0))
						row_equipment_control_ = 1;
				</cfoutput>
				document.getElementById("order_row_list_").value = order_row_list_;
		
				//Xmlde Ekip planlamada Cari iliskisi kurulsun secilir ise, ayni sevkiyat icerisine birden fazla cari eklenmemesi gerekiyor
				<cfif x_equipment_planning_relation_member eq 1>
					//Formdaki ekipler kontrol ediliyor
					for(xx=2;xx<=list_len(ekip_list_);xx++)
					{
						this_ekip_ = list_getat(ekip_list_,xx);
						this_musteri_ = list_getat(ekip_cus_list_,xx);
						for(yy=2;yy<=list_len(ekip_list_);yy++)
						{
							if(xx != yy)
							{
								second_ekip_ = list_getat(ekip_list_,yy);
								second_musteri_ = list_getat(ekip_cus_list_,yy);
								if(this_ekip_ == second_ekip_ &&  this_musteri_ != second_musteri_)
								{
									alert("<cf_get_lang no='586.Aynı Ekibe Farklı Müşteriler Tanımlayamazsınız!'>");
									return false;
								}
							}
						}				
					}
					//Daha onceden planlanmis ekip- sevkiyatlar kontrol ediliyor
					for(xx=2;xx<=list_len(ekip_list_);xx++)
					{
						this_ekip_ = list_getat(ekip_list_,xx);
						this_musteri_ = list_getat(ekip_cus_list_,xx);
						var listParam = "<cfoutput>#dsn3_alias#</cfoutput>" + "*" + this_ekip_;
						var get_relation_multiship = wrk_safe_query("stk_get_relation_multiship","dsn2",0,listParam);
						if(get_relation_multiship.recordcount)
						{
							for(mm=0; mm < get_relation_multiship.recordcount; mm++)
							{
								if(get_relation_multiship.COMPANY_ID[mm] != '')
								{
									second_musteri_ = 'comp-' + get_relation_multiship.COMPANY_ID[mm];
								}
								else
								{
									second_musteri_ = 'cons-' + get_relation_multiship.CONSUMER_ID[mm];
								}
								if(this_musteri_ != second_musteri_)
								{
									alert("<cf_get_lang no='585.Bu Ekip Daha Önce Farklı Bir Müşteri İçin Seçilmiş'>");
									return false;
								}
							}
						}
					}
				</cfif>
			</cfif>
			if(order_row_list_ == '')
			{
				alert("<cf_get_lang no ='584.En Az Bir Ekip Seçmelisiniz!'>");
				return false;
			}
			if(row_equipment_control_ == 1)
			{
				alert("<cf_get_lang no ='583.Lütfen Ekiplerin Sevk Edilecek Miktarlarını Kontrol Ediniz !'>");
				return false;
			}
			
			<cfif get_order_list.recordcount>
				<cfoutput query="get_order_list" >
					if(document.getElementById("equipment_planning_#islem_row_id#").value != '' || document.getElementById("old_equipment_planning_#islem_row_id#").value != '')
						document.getElementById("diff_amount_#islem_row_id#").value = filterNum(document.getElementById("diff_amount_#islem_row_id#").value);
				</cfoutput>
			</cfif>
			if(!process_cat_control()) return false;
		
			document.add_ship.action='<cfoutput>#request.self#</cfoutput>?fuseaction=stock.emptypopup_add_multi_packetship';
			document.add_ship.submit();
			return false;	
		}
		
		function equipment_all()
		{
			<cfif get_order_list.recordcount>
			<cfoutput query="get_order_list" >
				document.getElementById("equipment_planning_#islem_row_id#").value = document.getElementById("equipment_planning_all").value;
			</cfoutput>
			</cfif>
		}
		
		function change_deliverdate(xx,yy)
		{
			if(xx != '')
			{
				updrowdeliverdate_div = 'update_row_deliver_date_'+yy;
				var send_address = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.emptypopup_upd_order_row_deliver_date&row_order_id=' + yy + '&row_deliver_date=' + xx;
				AjaxPageLoad(send_address,updrowdeliverdate_div ,1);
			}
			else
			{
				alert("<cf_get_lang no ='582.Tarih Alanı Boş Olmamalıdır !'>");
				return false;
			}
		}
		</cfif>
		
		function kontrol()
		{
			var my_lengt = document.getElementsByName('logistic_company_id').length;
			kontrol_deger = 0;
			kontrol_deger2= 0;
			
			//checkbox birden fazla ise sayfada
			if (document.getElementById("is_logistic") != undefined)
			{
				for(xx=0;xx<my_lengt;xx++)
				{
					if(document.all.is_logistic[xx] !=undefined && document.all.is_logistic[xx].checked==true)
					{
						kontrol_deger2+=1;
						if(kontrol_deger == 0)
						{
							if(document.all.logistic_company_id[xx].value != '')
							{
								kontrol_deger =1;
								kontrol_member =document.all.logistic_company_id[xx].value;
							}
							else if(document.all.logistic_consumer_id[xx].value != '')
							{
								kontrol_deger =2;
								kontrol_member = document.all.logistic_consumer_id[xx].value;
							}
						}
						else
						{
							if(document.all.logistic_company_id[xx].value != '')
							{
								if((kontrol_member != document.all.logistic_company_id[xx].value != '' && kontrol_deger == 1) || kontrol_deger != 1 )
								{
									alert("<cf_get_lang no ='412.Paketlenecek Carileri Kontrol Ediniz '>!");
									return false;
								}
							}
							else if(document.all.logistic_consumer_id[xx].value != '')
							{
								if((kontrol_member != document.all.logistic_consumer_id[xx].value != '' && kontrol_deger == 2) || kontrol_deger != 2)
								{
									alert("<cf_get_lang no ='412.Paketlenecek Carileri Kontrol Ediniz '>!");
									return false;
								}
			
							}
						}
					}
				}
			}
			else
			{				
				if(document.getElementById("is_logistic") != undefined && document.getElementById("is_logistic").checked==true)
				{
					kontrol_deger2+=1;
					if(document.getElementById("logistic_company_id").value != '' && document.getElementById("logistic_consumer_id").value != '')
					{
						alert("<cf_get_lang no ='412.Paketlenecek Carileri Kontrol Ediniz '>!");
						return false;
					}
				}
			}	
			//BK
			if(kontrol_deger2 == 0)
			{
				alert("<cf_get_lang no ='412.Paketlenecek Carileri Kontrol Ediniz '> !");
				return false;
			}
			
			add_ship.action='<cfoutput>#request.self#?fuseaction=stock.form_add_packetship</cfoutput>';
			add_ship.submit();
			return true;
		}
		
		function kontrol2()
		{
			var my_lengt = document.getElementsByName('is_logistic').length;
			kontrol_deger2= 0;
		
			if (document.getElementById("is_logistic") != undefined)
				for(xx=0;xx<my_lengt;xx++)
					if(document.all.is_logistic[xx].checked==true)
						kontrol_deger2+=1;
		
			if(kontrol_deger2 < 2)
			{
				alert("<cf_get_lang no ='412.Paketlenecek Carileri Kontrol Ediniz '>!");
				return false;
			}
		
			add_ship.action='<cfoutput>#request.self#?fuseaction=stock.form_add_multi_packetship</cfoutput>';
			add_ship.submit();
			return true;
		}
		
		function product_control()
		{
			if(document.getElementById('stock_id').value=="" || document.getElementById('product_name').value == "" )
			{
				alert("<cf_get_lang no ='462.Spect Seçmek İçin Öncelikle Ürün Seçmeniz Gerekmektedir'>!");
				return false;
			}
			else
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=list_order.spect_main_id&field_name=list_order.spect_main_name&is_display=1&stock_id='+document.getElementById('stock_id').value,'list');
		}
    </script>
<cfelseif isdefined("attributes.event") and attributes.event is 'detail2'>
	<script type="text/javascript">
		function go_approve(incoming)
		{
			window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.approve_order&id=" + incoming;
		}
		
		function go_del(incoming)
		{
			window.location.href = "<cfoutput>#request.self#?fuseaction=purchase.del_order&order_id=#attributes.order_id#</cfoutput>";
		}
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_command';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_command.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['detail'] = structNew();
	WOStruct['#attributes.fuseaction#']['detail']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['detail']['fuseaction'] = 'stock.list_command&event=detail';
	WOStruct['#attributes.fuseaction#']['detail']['filePath'] = 'stock/display/detail_order.cfm';
	WOStruct['#attributes.fuseaction#']['detail']['js'] = "javascript:gizle_goster_ikili('detail_order','detail_order_bask')";	
	WOStruct['#attributes.fuseaction#']['detail']['parameters'] = '&order_id=##attributes.order_id##';
	WOStruct['#attributes.fuseaction#']['detail']['Identity'] = '##attributes.order_id##';
	
	WOStruct['#attributes.fuseaction#']['detail2'] = structNew();
	WOStruct['#attributes.fuseaction#']['detail2']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['detail2']['fuseaction'] = 'stock.list_command&event=detail2';
	WOStruct['#attributes.fuseaction#']['detail2']['filePath'] = 'stock/display/detail_orderp.cfm';
	WOStruct['#attributes.fuseaction#']['detail2']['js'] = "javascript:gizle_goster_basket(detail_orderp)";
	WOStruct['#attributes.fuseaction#']['detail2']['parameters'] = '&order_id=##attributes.order_id##';
	WOStruct['#attributes.fuseaction#']['detail2']['Identity'] = '##attributes.order_id##';
	
	if(attributes.event is 'detail')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'][0]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee','project')";
		if(not GET_ORDERS_INVOICE.recordcount)
		{
			if(get_order_detail.order_zone eq 1 and get_order_detail.purchase_sales eq 0)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'][1]['text'] = '#lang_array_main.item[2597]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'][1]['href'] = "#request.self#?fuseaction=#fusebox.circuit#.form_add_purchase&order_id=#attributes.order_id#";
			}
			else
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'][1]['text'] = '#lang_array_main.item[2598]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'][1]['href'] = "#request.self#?fuseaction=#fusebox.circuit#.form_add_sale&order_id=#attributes.order_id#";
			}
	    }
		if(not GET_ORDERS_SHIP.recordcount or GET_ORDERS_INVOICE.recordcount neq 0)
		{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'][2]['text'] = '#lang_array_main.item[2596]#';
				if(session.ep.isBranchAuthorization eq 1)
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'][2]['href'] = "#request.self#?fuseaction=store.add_sale_invoice_from_order&order_id=#attributes.order_id#";
				else
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'][2]['href'] = "#request.self#?fuseaction=invoice.add_sale_invoice_from_order&order_id=#attributes.order_id#";
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.order_id#&print_type=73','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if(attributes.event is 'detail2')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2']['menus'][0]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2']['menus'][0]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_list_order_history&order_id=#url.ORDER_ID#&portal_type=employee','page')";
		if(not GET_ORDERS_INVOICE.recordcount)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2']['menus'][1]['text'] = '#lang_array_main.item[2597]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2']['menus'][1]['href'] = "#request.self#?fuseaction=#fusebox.circuit#.form_add_purchase&order_id=#attributes.order_id#";
	    }
		if(not GET_ORDERS_SHIP.recordcount or GET_ORDERS_INVOICE.recordcount neq 0)
		{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2']['menus'][2]['text'] = '#lang_array_main.item[2596]#';
				if(session.ep.isBranchAuthorization eq 1)
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2']['menus'][2]['href'] = "#request.self#?fuseaction=store.add_sale_invoice_from_order&order_id=#attributes.order_id#";
				else
					tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2']['menus'][2]['href'] = "#request.self#?fuseaction=invoice.add_sale_invoice_from_order&order_id=#attributes.order_id#";

		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail2']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.order_id#&print_type=91','page')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>