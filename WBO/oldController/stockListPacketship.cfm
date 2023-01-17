<cf_get_lang_set module_name="stock">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	<cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.ship_number" default="">
    <cfparam name="attributes.ship_method" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.consumer_id" default="">
    <cfparam name="attributes.company" default="">
    <cfparam name="attributes.ship_method_id" default="">
    <cfparam name="attributes.ship_method_name" default="">
    <cfparam name="attributes.ship_stage" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.department_name" default="">
    <cfparam name="attributes.transport_comp_id" default="">
    <cfparam name="attributes.transport_comp_name" default="">
    <cfparam name="attributes.city_id" default="">
    <cfparam name="attributes.city" default="">
    <cfparam name="attributes.county" default="">
    <cfparam name="attributes.county_id" default="">
    <cfparam name="attributes.process_stage_type" default="">
    <cfparam name="attributes.project_id" default=""><!--- #67836 numaraları iş gereği MCP tarafından EKLENDİ. --->
    <cfparam name="attributes.project_head" default=""><!--- #67836 numaraları iş gereği MCP tarafından EKLENDİ. --->
    <cf_xml_page_edit fuseact="stock.list_packetship">
    <cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
        <cf_date tarih='attributes.start_date'>
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.start_date=''>
        <cfelse>
            <cfset attributes.start_date=wrk_get_today()>
        </cfif>
    </cfif>	
    <cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
        <cf_date tarih='attributes.finish_date'>
    <cfelse>
        <cfif session.ep.our_company_info.unconditional_list>
            <cfset attributes.finish_date=''>
        <cfelse>
        <cfset attributes.finish_date = date_add('d',1,now())>
        </cfif>
    </cfif>
    <cfquery name="GET_SHIP_STAGE" datasource="#DSN#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID 
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_packetship%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    <cfif isdefined("attributes.form_submitted")>
        <cfscript>
            get_ship_result_action = createObject("component", "stock.cfc.get_ship_result");
            get_ship_result_action.dsn2 = dsn2;
            get_ship_result_action.dsn_alias = dsn_alias;
            GET_SHIP_RESULT = get_ship_result_action.get_ship_result_fnc(
                 ship_number : '#IIf(IsDefined("attributes.ship_number"),"attributes.ship_number",DE(""))#',
                 keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                 process_stage_type : '#IIf(IsDefined("attributes.process_stage_type"),"attributes.process_stage_type",DE(""))#',
                 start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
                 finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
                 ship_method_name : '#IIf(IsDefined("attributes.ship_method_name"),"attributes.ship_method_name",DE(""))#',
                 ship_method_id : '#IIf(IsDefined("attributes.ship_method_id"),"attributes.ship_method_id",DE(""))#',
                 department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
                 department_name : '#IIf(IsDefined("attributes.department_name"),"attributes.department_name",DE(""))#',
                 transport_comp_id : '#IIf(IsDefined("attributes.transport_comp_id"),"attributes.transport_comp_id",DE(""))#',
                 transport_comp_name : '#IIf(IsDefined("attributes.transport_comp_name"),"attributes.transport_comp_name",DE(""))#',
                 company_id : '#IIf(IsDefined("attributes.deliver_company_id"),"attributes.deliver_company_id",DE(""))#',
                 company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
                 consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
                 county_id : '#IIf(IsDefined("attributes.county_id"),"attributes.county_id",DE(""))#',
                 county : '#IIf(IsDefined("attributes.county"),"attributes.county",DE(""))#',
                 city_id : '#IIf(IsDefined("attributes.city_id"),"attributes.city_id",DE(""))#',
                 city : '#IIf(IsDefined("attributes.city"),"attributes.city",DE(""))#',
                 project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                 project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#'
            );
        </cfscript>
    <cfelse>
        <cfset get_ship_result.recordCount = 0>
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfparam name="attributes.totalrecords" default='#get_ship_result.recordcount#'>

<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="stock.popup_add_packetship">
	<!--- 
        BK 20060418
        Bu sayfada ki is_logistic emirler listesinden gelen parametre olup, is_logistic2 parametresi satis irsaliyesi guncelleme sayfasından gelen parametredir.
     --->
    <cf_papers paper_type="ship_fis" form_name="add_packet_ship" form_field="transport_no1">
    <cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
    <cfinclude template="../stock/query/get_moneys.cfm">
    <cfinclude template="../stock/query/get_package_type.cfm">
    <cfinclude template="../stock/query/get_country.cfm">
    <cfquery name="get_ship" datasource="#dsn2#">
        SELECT OTHER_MONEY_VALUE,OTHER_MONEY FROM SHIP_RESULT
    </cfquery>
    <cfif isdefined("attributes.assetp_id")>
        <cfquery name="GET_ASSETP" datasource="#DSN#">
            SELECT ASSETP, POSITION_CODE FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
        </cfquery>
    </cfif>
    <cfif isdefined("attributes.is_logistic") and len(attributes.is_logistic)>
        <cfquery name="get_ship_id" datasource="#dsn3#">
            SELECT SHIP_ID FROM ORDERS_SHIP WHERE ORDER_ID IN (#attributes.is_logistic#)
        </cfquery>
        <cfquery name="ADD_LOGISTIC" datasource="#DSN2#">
            SELECT
                LOCATION,
                COMPANY_ID,
                PARTNER_ID,
                CONSUMER_ID,
                SHIP_ID,
                SHIP_NUMBER,
                SHIP_DATE,
                SHIP_METHOD,
                ADDRESS,
                ORDER_ID,
                DELIVER_STORE_ID,
                IS_DISPATCH,
                (SELECT DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = DELIVER_STORE_ID) DEPARTMENT_HEAD
            FROM 
                SHIP
            WHERE
                <cfif get_ship_id.recordcount>
                    SHIP_ID IN (#valuelist(get_ship_id.ship_id)#)
                <cfelse>
                    1 = 0	
                </cfif>
        </cfquery>
        <cfquery name="ADD_LOGISTIC_MAIN" dbtype="query" maxrows="1">
            SELECT * FROM ADD_LOGISTIC ORDER BY SHIP_ID
        </cfquery>
        <cfif len(add_logistic_main.company_id)>
            <cfquery name="GET_COMPANY_SEVK" datasource="#DSN#">
                SELECT 
                    TRANSPORT_COMP_ID,
                    TRANSPORT_DELIVER_ID
                FROM 
                    COMPANY_CREDIT 
                WHERE 
                    COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#add_logistic_main.company_id#"> AND 
                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            </cfquery>
        </cfif>
        <cfquery name="GET_TRANSPORT_INFO" datasource="#DSN3#">
            SELECT 
                LOCATION_ID,
                DELIVER_DEPT_ID,
                (SELECT DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = DELIVER_DEPT_ID) AS DEPARTMENT_HEAD,
                (SELECT BRANCH_ID FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = DELIVER_DEPT_ID) AS BRANCH_ID,
                SHIP_METHOD AS SHIP_METHOD_ID,
                (SELECT SHIP_METHOD FROM #dsn_alias#.SHIP_METHOD WHERE SHIP_METHOD_ID = ORDERS.SHIP_METHOD) AS SHIP_METHOD
            FROM
                ORDERS
            WHERE 
                ORDER_ID IN (#attributes.is_logistic#)
        </cfquery>
        <cfif get_transport_info.recordcount>
            <cfset attributes.branch_id = get_transport_info.branch_id>	
            <cfif len(add_logistic.deliver_store_id)>
                <cfset attributes.department_id = add_logistic.deliver_store_id>
            <cfelse>
                <cfset attributes.department_id = get_transport_info.deliver_dept_id>
            </cfif>
            <cfif len(add_logistic.location)>
                <cfset attributes.location_id = add_logistic.location>
            <cfelse>
                <cfset attributes.location_id = get_transport_info.location_id>
            </cfif>
            <cfset attributes.ship_method_id = get_transport_info.ship_method_id>
            <cfset attributes.ship_method_name = get_transport_info.ship_method>
            <cfif len(add_logistic.deliver_store_id)>
                <cfset attributes.department_name = add_logistic.department_head>
            <cfelse>
                <cfset attributes.department_name = get_transport_info.department_head>
            </cfif>
            <cfif isdefined('attributes.location_id') and len(attributes.location_id) and isdefined('attributes.department_id')and len(attributes.department_id)>
                <cfquery name="get_location" datasource="#DSN#">
                    SELECT COMMENT FROM STOCKS_LOCATION WHERE STATUS = 1 AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"> AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
                </cfquery>
                <cfset attributes.department_name = '#attributes.department_name#-#get_location.comment#'>	
            </cfif>
        </cfif> 
        <cfif isdefined('get_company_sevk') and  get_company_sevk.recordcount>
            <cfset attributes.transport_comp_id = get_company_sevk.transport_comp_id>
            <cfset attributes.transport_deliver_id = get_company_sevk.transport_deliver_id>
        </cfif>
        <cfif len(add_logistic_main.partner_id) and len(add_logistic_main.company_id)>
            <cfset attributes.deliver_company = get_par_info(add_logistic_main.partner_id,0,1,0)>
            <cfset attributes.member_name = get_par_info(add_logistic_main.partner_id,0,2,0)>
            <cfset attributes.deliver_company_id = add_logistic_main.company_id>
            <cfset attributes.deliver_partner_id = add_logistic_main.partner_id>
        <cfelseif len(add_logistic_main.company_id)>
            <cfset attributes.deliver_company = get_par_info(add_logistic_main.company_id,1,1,0)>
            <cfset attributes.deliver_company_id = add_logistic_main.company_id>
        <cfelseif len(add_logistic_main.consumer_id)>
            <cfset attributes.member_name = get_cons_info(add_logistic_main.consumer_id,0,0)>
            <cfset attributes.deliver_consumer_id = add_logistic_main.consumer_id>
        </cfif>
        <cfset company_list=''>
        <cfset consumer_list=''>
        <cfoutput query="add_logistic">
            <cfif len(company_id) and not listfind(company_list,company_id)>
                <cfset company_list = Listappend(company_list,company_id)>
            </cfif>
            <cfif len(consumer_id) and not listfind(consumer_list,consumer_id)>
                <cfset consumer_list = Listappend(consumer_list,consumer_id)>
            </cfif>
        </cfoutput>
        <cfif len(company_list)>
            <cfset company_list=listsort(company_list,"numeric","ASC",",")>			
            <cfquery name="GET_COMPANY" datasource="#DSN#">
                SELECT COMPANY_ID, NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
            </cfquery>
            <cfset main_company_list = listsort(listdeleteduplicates(valuelist(get_company.company_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfif len(consumer_list)>
            <cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>			
            <cfquery name="GET_CONSUMER" datasource="#DSN#">
                SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
            </cfquery>
            <cfset main_consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
        </cfif>
        <cfquery name="GET_CONTROL_" dbtype="query">
            SELECT SHIP_NUMBER FROM ADD_LOGISTIC WHERE IS_DISPATCH = 1
        </cfquery>
    </cfif>
    <cfif isdefined("attributes.is_logistic2")>
        <cfif not len(attributes.consumer_id)>
            <!--- Kurumsal uyeler icin --->
            <cfquery name="ADD_LOGISTIC2" datasource="#DSN2#">
                SELECT
                    C.NICKNAME MEMBER_NAME,
                    S.SHIP_ID,
                    S.SHIP_NUMBER,
                    S.SHIP_DATE,
                    S.SHIP_METHOD,
                    S.ADDRESS,
                    S.COMPANY_ID,
                    S.SHIP_METHOD SHIP_METHOD_ID,
                    S.SHIP_NUMBER,
                    S.IS_DISPATCH,
                    (SELECT SHIP_METHOD FROM #dsn_alias#.SHIP_METHOD WHERE SHIP_METHOD_ID = S.SHIP_METHOD) SHIP_METHOD
                FROM 
                    SHIP S,
                    #dsn_alias#.COMPANY C
                WHERE
                    S.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_logistic2#"> AND
                    C.COMPANY_ID = S.COMPANY_ID
                ORDER BY
                    S.SHIP_ID
            </cfquery>
            <!--- Tasiyici firmaya ulasmak icin --->
            <cfquery name="GET_TRANSPORT" datasource="#DSN#">
                SELECT 
                    TRANSPORT_COMP_ID,
                    TRANSPORT_DELIVER_ID
                FROM
                    COMPANY_CREDIT 
                WHERE
                    COMPANY_CREDIT.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_logistic2.company_id#"> AND
                    COMPANY_CREDIT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                    TRANSPORT_COMP_ID IS NOT NULL AND
                    TRANSPORT_DELIVER_ID IS NOT NULL
            </cfquery>
            <cfif get_transport.recordcount> 
                <cfset attributes.transport_comp_id = get_transport.transport_comp_id>
                <cfset attributes.transport_deliver_id = get_transport.transport_deliver_id>		
            </cfif>
        <cfelse>
            <!--- Bireysel uyeler icin --->
            <cfquery name="ADD_LOGISTIC2" datasource="#DSN2#">
                SELECT
                    <cfif database_type is "MSSQL">
                        C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME MEMBER_NAME,
                    <cfelseif database_type is "DB2">
                        C.CONSUMER_NAME||' '||C.CONSUMER_SURNAME MEMBER_NAME,
                    </cfif>		
                    S.SHIP_ID,
                    S.SHIP_NUMBER,
                    S.SHIP_DATE,
                    S.SHIP_METHOD,
                    S.SHIP_NUMBER,
                    S.IS_DISPATCH,
                    S.ADDRESS,
                    S.CONSUMER_ID
                FROM 
                    SHIP S,
                    #dsn_alias#.CONSUMER C
                WHERE
                    S.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_logistic2#"> AND
                    C.CONSUMER_ID = S.CONSUMER_ID
                ORDER BY
                    S.SHIP_ID
            </cfquery>
            <!--- Tasiyici firmaya ulasmak icin --->
            <cfquery name="GET_TRANSPORT" datasource="#DSN#">
                SELECT 
                    TRANSPORT_COMP_ID,
                    TRANSPORT_DELIVER_ID
                FROM
                    COMPANY_CREDIT 
                WHERE
                    COMPANY_CREDIT.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_logistic2.consumer_id#"> AND
                    COMPANY_CREDIT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                    TRANSPORT_COMP_ID IS NOT NULL AND
                    TRANSPORT_DELIVER_ID IS NOT NULL
            </cfquery>
            <cfif get_transport.recordcount> 
                <cfset attributes.transport_comp_id = get_transport.transport_comp_id>
                <cfset attributes.transport_deliver_id = get_transport.transport_deliver_id>
            </cfif>		
        </cfif>
        <cfquery name="GET_CONTROL_" dbtype="query">
            SELECT SHIP_NUMBER FROM ADD_LOGISTIC2 WHERE IS_DISPATCH = 1
        </cfquery>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cf_xml_page_edit fuseact="stock.popup_add_packetship">
    <!--- Not: SHIP_RESULT tablosundaki IS_TYPE alani siparis datayindaki Sevkiyat popup'dan atılan kayıtlarda (sadece bu kayitlarda) 2 set edilir.
        O yuzden ekleme ve silme işlemi su an yapilamamakta BK 20070405
     --->
    <cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
    <cfinclude template="../stock/query/get_moneys.cfm">
    <cfinclude template="../stock/query/get_package_type.cfm">
    <cfinclude template="../stock/query/get_country.cfm">
    <cfquery name="GET_MONEY" datasource="#DSN#">
        SELECT MONEY,RATE2,RATE1 FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
    </cfquery>
    <cfquery name="GET_SHIP_RESULT" datasource="#DSN2#">
        SELECT
            SR.SHIP_RESULT_ID,
            SR.SHIP_METHOD_TYPE,
            SR.SERVICE_COMPANY_ID,
            SR.SERVICE_MEMBER_ID,
            SR.ASSETP_ID,
            SR.DELIVER_EMP,
            SR.ASSETP,
            SR.DELIVER_EMP_NAME,
            SR.PLATE,
            SR.NOTE,
            SR.SHIP_FIS_NO,
            SR.DELIVER_PAPER_NO,
            SR.REFERENCE_NO,
            SR.OUT_DATE,
            SR.DELIVERY_DATE,
            SR.DELIVER_POS,
            SR.DEPARTMENT_ID,
            SR.SHIP_STAGE,
            SR.COST_VALUE,
            SR.COST_VALUE2,
            SR.CALCULATE_TYPE,
            SR.COMPANY_ID,
            SR.PARTNER_ID,
            SR.CONSUMER_ID,
            SR.IS_TYPE,
            SR.SENDING_ADDRESS,
            SR.SENDING_POSTCODE,
            SR.SENDING_SEMT,
            SR.SENDING_COUNTY_ID,
            SR.SENDING_CITY_ID,
            SR.SENDING_COUNTRY_ID,
            SR.LOCATION_ID,
            SR.RECORD_EMP,
            SR.RECORD_IP,
            SR.RECORD_DATE,
            SR.UPDATE_EMP,
            SR.UPDATE_IP,
            SR.UPDATE_DATE,
            SR.INSURANCE_COMP_ID,
            SR.INSURANCE_COMP_PART,
            SR.DUTY_COMP_ID,
            SR.DUTY_COMP_PARTNER,
            SR.WAREHOUSE_ENTRY_DATE,
            SR.OTHER_MONEY_VALUE,
            SR.OTHER_MONEY,
            SM.SHIP_METHOD,
            ASSET_P.ASSETP,
            DEPARTMENT.DEPARTMENT_HEAD,
            SETUP_COUNTY.COUNTY_NAME,
            SETUP_CITY.CITY_NAME
        FROM
            SHIP_RESULT SR
            LEFT JOIN #DSN_ALIAS#.ASSET_P ON ASSET_P.ASSETP_ID = SR.ASSETP_ID
            LEFT JOIN #DSN_ALIAS#.DEPARTMENT ON DEPARTMENT.DEPARTMENT_ID = SR.DEPARTMENT_ID
            LEFT JOIN #DSN_ALIAS#.SETUP_COUNTY ON SETUP_COUNTY.COUNTY_ID = SR.SENDING_COUNTY_ID
            LEFT JOIN #DSN_ALIAS#.SETUP_CITY ON SETUP_CITY.CITY_ID = SR.SENDING_CITY_ID
            ,#dsn_alias#.SHIP_METHOD SM
        WHERE
            SR.SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#"> AND
            SR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID AND
            SR.MAIN_SHIP_FIS_NO IS NULL 
    </cfquery>
    <cfif len(get_ship_result.delivery_date)>
		<cfset delivery_hour = hour(get_ship_result.delivery_date)>
        <cfset delivery_minute = minute(get_ship_result.delivery_date)>
    <cfelse>
        <cfset delivery_hour = ''>
        <cfset delivery_minute = ''>
    </cfif>
    <cfif not get_ship_result.recordcount or not len(get_ship_result.service_company_id)>
        <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Kayıt Bulunmamaktadır'>!</font>
        <cfexit method="exittemplate">
    </cfif>
    <cfif is_show_cost eq 1>
        <cfquery name="GET_SHIP_METHOD_PRICE" datasource="#DSN#">
            SELECT * FROM SHIP_METHOD_PRICE WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ship_result.service_company_id#">
        </cfquery>
        <!--- Eger ilgili hesap yontemine ait kayit yoksa --->
        <cfif not get_ship_method_price.recordcount>
            <script type="text/javascript">
                alert('<cfoutput>#get_par_info(get_ship_result.service_company_id,1,0,0)#</cfoutput>'+ " <cf_get_lang no ='478.Şirketine Ait Bir Taşıyıcı Kaydı Yok,Lütfen Kayıtlarınızı Kontrol Ediniz'>" );
                window.location.href="<cfoutput>#request.self#?</cfoutput>fuseaction=stock.list_packetship"
            </script>
        </cfif>
        <!--- Tasiyici Bilgisi Degistirilirse,yeni tasiyici icin sevk fiyatı verilip verilmedigini kontrol etmek icssin  --->
        <cfquery name="GET_SHIP_METHOD_PRICE_" datasource="#DSN#">
            SELECT * FROM SHIP_METHOD_PRICE
        </cfquery>
    
        <!--- Tasiyici Firma Sadece 1 kez secilsin. --->
        <cfset transport_selected=ValueList(get_ship_method_price_.company_id,',')>
        <cfif len(get_ship_result.ship_method_type)>
            <cfquery name="GET_ROWS" datasource="#DSN2#">
                SELECT
                    PACKAGE_PIECE,
                    PACKAGE_DIMENTION,
                    PACKAGE_WEIGHT
                FROM
                    SHIP_RESULT_PACKAGE
                WHERE
                    SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#">
            </cfquery>
            <cfset toplam_kg = 0>
            <cfset toplam_desi = 0>
        </cfif>
    </cfif>
    <cfif is_show_cost eq 1>
        <cfquery name="GET_PACKAGE" datasource="#DSN2#">
            SELECT
                SRP.*,
                '' PACK_NAME
                ,SP.PACKAGE_TYPE
                ,SP.DIMENTION 
            FROM
                SHIP_RESULT_PACKAGE SRP
                LEFT JOIN #DSN_ALIAS#.SETUP_PACKAGE_TYPE SP ON SP.PACKAGE_TYPE_ID = ISNULL(SRP.PACKAGE_TYPE,0)
            WHERE 
                SRP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#"> AND
                PACK_EMP_ID IS NULL
                
            UNION ALL
                
            SELECT
                SRP.*,
                <cfif (database_type is 'MSSQL')>
                EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME PACK_NAME
                <cfelseif (database_type is 'DB2')>
                EMPLOYEES.EMPLOYEE_NAME ||' '|| EMPLOYEES.EMPLOYEE_SURNAME PACK_NAME
                </cfif>
                ,SP.PACKAGE_TYPE
                ,SP.DIMENTION 
            FROM
                SHIP_RESULT_PACKAGE SRP
                LEFT JOIN #DSN_ALIAS#.SETUP_PACKAGE_TYPE SP ON SP.PACKAGE_TYPE_ID = ISNULL(SRP.PACKAGE_TYPE,0)
                ,
                #dsn_alias#.EMPLOYEES EMPLOYEES
            WHERE 
                SRP.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#"> AND
                SRP.PACK_EMP_ID = EMPLOYEES.EMPLOYEE_ID
        </cfquery>
     </cfif>
     <cfquery name="GET_ROW" datasource="#DSN2#">
        SELECT 
        	SHIP_RESULT_ROW.*,
            <cfif get_ship_result.is_type neq 2>
                (SELECT SHIP_NUMBER FROM SHIP WHERE SHIP_ID = SHIP_RESULT_ROW.SHIP_ID) AS SHIP_NUMBER
            <cfelse>		
                (SELECT ORDER_NUMBER SHIP_NUMBER FROM #dsn3_alias#.ORDERS WHERE ORDER_ID = SHIP_RESULT_ROW.SHIP_ID) AS SHIP_NUMBER
            </cfif>
        FROM 
        	SHIP_RESULT_ROW 
        WHERE 
        	SHIP_RESULT_ROW.SHIP_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_result_id#">
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'detail'>
	<cfsetting showdebugoutput="yes">
	<cfset xml_page_control_list = 'is_calculate_to_product_tree,is_show_amount'>
    <cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="1">
    <cfparam name="attributes.add_other_amount" default="1">
    <cfparam name="attributes.del_other_amount" default="1">
    <cfset product_barcode_list = ''>
    <cfquery name="GET_SHIP_PACKAGE_LIST" datasource="#dsn1#">
        SELECT
            BARCOD,
            STOCK_CODE,
            PRODUCT_NAME,
            SUM(PAKETSAYISI) AS PAKETSAYISI,
            ISNULL(STOCK_ID,0) STOCK_ID
        FROM
            (	SELECT
                    #dsn1_alias#.STOCKS.STOCK_CODE,
                    #dsn1_alias#.PRODUCT.BARCOD,
                    #dsn1_alias#.PRODUCT.PRODUCT_NAME,
                    DERIVEDTBL.PAKETSAYISI,
                    #dsn1_alias#.STOCKS.STOCK_ID
                FROM
                    #dsn1_alias#.STOCKS RIGHT OUTER JOIN
                    #dsn1_alias#.PRODUCT ON
                    #dsn1_alias#.STOCKS.PRODUCT_ID = #dsn1_alias#.PRODUCT.PRODUCT_ID RIGHT OUTER JOIN
                    (	SELECT
                            DERIVEDTBL.SHIP_ID,
                            DERIVEDTBL.AMOUNT
                            *
                            #dsn3_alias#.PRODUCT_TREE.AMOUNT AS PAKETSAYISI, 
                            #dsn3_alias#.PRODUCT_TREE.RELATED_ID
                        FROM
                            #dsn1_alias#.PRODUCT INNER JOIN
                            (	SELECT
                                    #dsn2_alias#.SHIP_ROW.SHIP_ID,
                                    #dsn2_alias#.SHIP_ROW.AMOUNT, 
                                    #dsn1_alias#.KARMA_PRODUCTS.PRODUCT_ID
                                FROM
                                    #dsn1_alias#.KARMA_PRODUCTS RIGHT OUTER JOIN
                                    #dsn1_alias#. PRODUCT ON
                                    #dsn1_alias#.KARMA_PRODUCTS.KARMA_PRODUCT_ID = #dsn1_alias#.PRODUCT.PRODUCT_ID RIGHT OUTER JOIN
                                    #dsn2_alias#.SHIP_ROW ON
                                    #dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn2_alias#.SHIP_ROW.PRODUCT_ID
                                WHERE
                                    (#dsn2_alias#.SHIP_ROW.SHIP_ID = #attributes.process_id#) AND (#dsn1_alias#.PRODUCT .IS_KARMA = 1)
                            ) DERIVEDTBL ON 
                            #dsn1_alias#.PRODUCT .PRODUCT_ID = DERIVEDTBL.PRODUCT_ID LEFT OUTER JOIN
                            #dsn3_alias#.PRODUCT_TREE RIGHT OUTER JOIN
                            #dsn1_alias#.STOCKS ON 
                            #dsn3_alias#.PRODUCT_TREE.STOCK_ID = #dsn1_alias#.STOCKS.STOCK_ID ON 
                            DERIVEDTBL.PRODUCT_ID = #dsn1_alias#.STOCKS.PRODUCT_ID
                        WHERE      
                            (#dsn1_alias#.PRODUCT.PACKAGE_CONTROL_TYPE = 2)
                    ) DERIVEDTBL ON 
                    #dsn1_alias#.PRODUCT .PRODUCT_ID = DERIVEDTBL.RELATED_ID
            UNION ALL
                SELECT
                    #dsn1_alias#.STOCKS.STOCK_CODE,
                    #dsn1_alias#.PRODUCT .BARCOD,
                    #dsn1_alias#.PRODUCT .PRODUCT_NAME,
                    DERIVEDTBL.PAKETSAYISI, 
                    #dsn1_alias#.STOCKS.STOCK_ID
                FROM
                    #dsn1_alias#.STOCKS RIGHT OUTER JOIN
                    #dsn1_alias#.PRODUCT ON 
                    #dsn1_alias#.STOCKS.PRODUCT_ID = #dsn1_alias#.PRODUCT .PRODUCT_ID RIGHT OUTER JOIN
                    (	SELECT
                            #dsn3_alias#.PRODUCT_TREE.RELATED_ID, 
                            #dsn3_alias#.PRODUCT_TREE.AMOUNT
                            *
                            #dsn2_alias#.SHIP_ROW.AMOUNT AS PAKETSAYISI
                        FROM
                            #dsn1_alias#.PRODUCT LEFT OUTER JOIN
                            #dsn3_alias#.PRODUCT_TREE RIGHT OUTER JOIN
                            #dsn1_alias#.STOCKS ON 
                            #dsn3_alias#.PRODUCT_TREE.STOCK_ID = #dsn1_alias#.STOCKS.STOCK_ID ON 
                            #dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn1_alias#.STOCKS.PRODUCT_ID RIGHT OUTER JOIN
                            #dsn2_alias#.SHIP_ROW ON #dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn2_alias#.SHIP_ROW.PRODUCT_ID
                        WHERE
                            (#dsn1_alias#.PRODUCT .IS_KARMA = 0) AND (#dsn2_alias#.SHIP_ROW.SHIP_ID = #attributes.process_id#) AND 
                            (#dsn1_alias#.PRODUCT .PACKAGE_CONTROL_TYPE = 2)
                    ) DERIVEDTBL ON 
                    #dsn1_alias#.PRODUCT .PRODUCT_ID = DERIVEDTBL.RELATED_ID
            UNION ALL
                SELECT
                    #dsn1_alias#.STOCKS.STOCK_CODE,
                    #dsn1_alias#.PRODUCT.BARCOD,
                    #dsn1_alias#.PRODUCT.PRODUCT_NAME,
                    #dsn2_alias#.SHIP_ROW.AMOUNT, 
                    #dsn1_alias#.STOCKS.STOCK_ID
                FROM
                    #dsn1_alias#.PRODUCT LEFT OUTER JOIN
                    #dsn1_alias#.STOCKS ON 
                    #dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn1_alias#.STOCKS.PRODUCT_ID RIGHT OUTER JOIN
                    #dsn2_alias#.SHIP_ROW ON #dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn2_alias#.SHIP_ROW.PRODUCT_ID AND #dsn2_alias#.SHIP_ROW.STOCK_ID = #dsn1_alias#.STOCKS.STOCK_ID
                WHERE
                    (#dsn1_alias#.PRODUCT .IS_KARMA = 0) AND (#dsn2_alias#.SHIP_ROW.SHIP_ID = #attributes.process_id#) AND 
                    (#dsn1_alias#.PRODUCT .PACKAGE_CONTROL_TYPE = 1)
            UNION ALL
                SELECT
                    #dsn1_alias#.STOCKS.STOCK_CODE,
                    #dsn1_alias#.PRODUCT.BARCOD,
                    #dsn1_alias#.PRODUCT.PRODUCT_NAME,
                    DERIVEDTBL.PAKETSAYISI, 
                    #dsn1_alias#.STOCKS.STOCK_ID
                FROM
                    #dsn1_alias#.PRODUCT LEFT OUTER JOIN
                    #dsn1_alias#.STOCKS ON 
                    #dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn1_alias#.STOCKS.PRODUCT_ID RIGHT OUTER JOIN
                    (	SELECT
                            #dsn1_alias#.KARMA_PRODUCTS.PRODUCT_ID, 
                            KARMA_PRODUCTS.STOCK_ID,
                            #dsn2_alias#.SHIP_ROW.AMOUNT
                            *
                            #dsn1_alias#.KARMA_PRODUCTS.PRODUCT_AMOUNT AS PAKETSAYISI
                        FROM
                            #dsn1_alias#.KARMA_PRODUCTS RIGHT OUTER JOIN
                            #dsn1_alias#.PRODUCT ON 
                            #dsn1_alias#.KARMA_PRODUCTS.KARMA_PRODUCT_ID = #dsn1_alias#.PRODUCT .PRODUCT_ID RIGHT OUTER JOIN
                            #dsn2_alias#.SHIP_ROW ON #dsn1_alias#.PRODUCT .PRODUCT_ID = #dsn2_alias#.SHIP_ROW.PRODUCT_ID
                        WHERE
                            (#dsn1_alias#.PRODUCT .IS_KARMA = 1) AND (#dsn2_alias#.SHIP_ROW.SHIP_ID = #attributes.process_id#)
                    ) DERIVEDTBL ON 
                    #dsn1_alias#.PRODUCT .PRODUCT_ID = DERIVEDTBL.PRODUCT_ID AND DERIVEDTBL.STOCK_ID = #dsn1_alias#.STOCKS.STOCK_ID
                WHERE
                    (#dsn1_alias#.PRODUCT .PACKAGE_CONTROL_TYPE = 1)
            ) DERIVEDTBL
        WHERE
            DERIVEDTBL.STOCK_ID IS NOT NULL
        GROUP BY
            BARCOD,
            STOCK_CODE,
            PRODUCT_NAME,
            STOCK_ID
    </cfquery>
    <cfquery name="get_detail_package_list" datasource="#dsn2#">
        SELECT 
            STOCK_ID,
            CONTROL_AMOUNT
        FROM 
            SHIP_PACKAGE_LIST
        WHERE
            SHIP_ID = #attributes.PROCESS_ID# 
    </cfquery>
    <cfoutput query="get_detail_package_list">
        <cfset 'control_amount#STOCK_ID#' = CONTROL_AMOUNT>
    </cfoutput>
    <cfset stock_id_list = ListSort(ListDeleteDuplicates(ValueList(GET_SHIP_PACKAGE_LIST.STOCK_ID,',')),"numeric","asc",",")>
    <cfif len(stock_id_list)>
        <cfquery name="get_property_product" datasource="#dsn3#"><!--- Donat İçin Eklendi,Ürün Özelliklerinden Değerler Alınıyor. --->
            SELECT
                S.STOCK_ID,
                P.PRODUCT_CODE_2,
                ISNULL(PIP.PROPERTY7,0) AS PAKET_NO,
                ISNULL(PIP.PROPERTY8,0) AS TOPLAM_PAKET_ADI
            FROM
                STOCKS S,
                PRODUCT P,
                PRODUCT_INFO_PLUS PIP
            WHERE
                P.PRODUCT_ID = S.PRODUCT_ID 
                AND PIP.PRODUCT_ID = S.PRODUCT_ID
                AND S.STOCK_ID IN (#stock_id_list#)
        </cfquery>
        <cfif get_property_product.recordcount>
            <cfscript>
                for(ppi=1;ppi lte get_property_product.recordcount;ppi=ppi+1)
                {
                    'product_prop_name_#get_property_product.STOCK_ID[ppi]#' = '#get_property_product.PRODUCT_CODE_2[ppi]#-#get_property_product.TOPLAM_PAKET_ADI[ppi]# /  #get_property_product.PAKET_NO[ppi]#';
                }
            </cfscript>
        </cfif>
    </cfif>
</cfif>
<script type="text/javascript">
<cfif not isdefined("attributes.event") or attributes.event is 'list'>
	$(document).ready(function()
	{document.getElementById('keyword').focus();
	});
	function pencere_ac()
	{
		if((listPacketship.city_id.value != "") && (listPacketship.city.value != ""))
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=listPacketship.county_id&field_name=listPacketship.county&city_id=' + document.listPacketship.city_id.value,'small');
		else
			alert("<cf_get_lang no='314.Lütfen İl Seçiniz'> !");
	}
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	$(document).ready(function()
	{
		calculate_type_deger = 1;
		row_count = 0;
		row_count2 = 0;
		money_list = "<cfoutput>#valuelist(moneys.money,',')#</cfoutput>";
		rate1_list = "<cfoutput>#valuelist(moneys.rate1,',')#</cfoutput>";
		rate2_list = "<cfoutput>#valuelist(moneys.rate2,',')#</cfoutput>";
	});
	
	function add_adress(adress_type)
	{
		if(!(document.getElementById("partner_id").value=="") || !(document.getElementById("consumer_id").value==""))
		{	
			if(document.getElementById("partner_id").value!="")
			{
				str_adrlink = '&field_adres=add_packet_ship.sending_address&field_city=add_packet_ship.sending_city_id&field_city_name=add_packet_ship.sending_city&field_county=add_packet_ship.sending_county_id&field_county_name=add_packet_ship.sending_county&field_postcode=add_packet_ship.sending_postcode&field_semt=add_packet_ship.sending_semt'; 
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(add_packet_ship.company.value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				str_adrlink = '&field_adres=add_packet_ship.sending_address&field_city=add_packet_ship.sending_city_id&field_city_name=add_packet_ship.sending_city&field_county=add_packet_ship.sending_county_id&field_county_name=add_packet_ship.sending_county&field_postcode=add_packet_ship.sending_postcode&field_semt=add_packet_ship.sending_semt'; 
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(add_packet_ship.member_name.value)+''+ str_adrlink , 'list');
				return true;
			}
		}
		else
		{
			alert("<cf_get_lang no ='131.Cari Hesap Seçiniz'> !");
			return false;
		}		
	}
	
	function pencere_ac(no)
	{
		if(document.getElementById("member_name").value !='')
		{
			document.getElementById("ship_id_list").value  ='';
			for(r=1; r<=document.getElementById("record_num").value; r++)
			{
				deger_row_kontrol = document.getElementById('row_kontrol'+r);
				//deger_ship_id = document.getElementById('ship_id'+r);
				if(deger_row_kontrol.value == 1)
				{
					if(document.getElementById("ship_id_list").value == '')
					{
						if(document.getElementById('ship_id'+r).value != '')
							document.getElementById("ship_id_list").value = document.getElementById('ship_id'+r).value;
					}
					else
					{
						if(document.getElementById('ship_id'+r).value != '')
							document.getElementById("ship_id_list").value += ','+document.getElementById('ship_id'+r).value;
					}	
				}
			}
			windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + add_packet_ship.ship_id_list.value + '&ship_id=ship_id'+no+'&ship_number=ship_number'+no+'&ship_date=ship_date'+no+'&ship_deliver=ship_deliver'+no+'&ship_type=ship_type'+no+'&ship_adress=ship_adress'+no+'&is_gonder=1&deliver_company_id='+document.getElementById("deliver_company_id").value,'project');//&deliver_company_id='+add_packet_ship.service_company_id.value
		}
		else
		{
			alert("<cf_get_lang no='131.Cari Hesap Seçiniz'>!");
		}
	}
	
	function pencere_ac2_main()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_packet_ship.pack_emp_id0&field_name=add_packet_ship.pack_emp_name0&select_list=1&call_function=hepsi()','list','popup_list_positions');
	}
	
	function pencere_ac2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_packet_ship.pack_emp_id'+ no +'&field_name=add_packet_ship.pack_emp_name'+ no+'&select_list=1','list','popup_list_positions');
	}
	
	function sil(sy)
	{
		var my_element = document.getElementById("row_kontrol"+sy);
		my_element.value = 0;
		var my_element = eval("frm_row"+sy);
		my_element.style.display = "none";
	}
	
	function sil_other(sy)
	{
		var my_element = document.getElementById("row_kontrol_other"+sy);
		my_element.value = 0;
		var my_element = eval("frm_row_other"+sy);
		my_element.style.display = "none";
		if(document.getElementsByName('calculate_type')[1].checked)
			return kur_hesapla();
		else
			degistir(sy);
	}
	
	function add_row()
	{
		<cfif is_department_required eq 1>
			if((document.getElementById("department_id").value=="") || (document.getElementById("department_name").value==""))
			{
				alert("Çıkış Depo Seçiniz !");
				return false;
			}
		</cfif>

		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.getElementById("record_num").value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"> <a style="cursor:pointer" onclick="sil(' + row_count + ');"> <i class="icon-trash-o"  align="absmiddle"></i></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'" value=""><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'" value="" readonly  style="width:105px;"> <a href="javascript://" onClick="pencere_ac('+ row_count +');"> <i class="icon-ellipsis"  align="absmiddle"></i> </a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="" readonly style="width:70px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="" readonly style="width:120px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly style="width:180px;">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="" readonly style="width:300px;">';
	}
	
	function transport_control()
	{
		if(document.getElementById("transport_comp_id").value != "" )
		{
			var GET_MAX_LIMIT = wrk_safe_query('stk_get_max_limit','dsn',0,document.getElementById("transport_comp_id").value);//Seçilen taşıyıcıya ait yapılmış bir tanımlama değeri varsa.
			document.getElementById("max_limit").value = GET_MAX_LIMIT.MAX_LIMIT;
			if(GET_MAX_LIMIT.CALCULATE_TYPE == 1)
			{
				document.getElementsByName('calculate_type')[0].checked=true;
				document.getElementById('options_kontrol').value = 1;/*Form'u kontrol etmek için,*/
			}
			else if	(GET_MAX_LIMIT.CALCULATE_TYPE == 2)
			{
				document.getElementsByName('calculate_type')[1].checked = true;
				document.getElementById('options_kontrol').value = 1;/*Form'u kontrol etmek için,*/
			}
			if(GET_MAX_LIMIT.MAX_LIMIT == undefined)
			{
				alert("<cf_get_lang no ='471.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini Kontrol Ediniz (Fiyat Listesi)'>!");
				document.getElementsByName('calculate_type')[0].checked = false;
				document.getElementsByName('calculate_type')[1].checked = false;
				document.getElementById('options_kontrol').value = 0;
				document.getElementById("max_limit").value = 0;
				return false;	
			}
		}
	}
	function add_row_other()
	{
		if(document.getElementById("ship_method_id").value == "")
		{
			alert("<cf_get_lang no='305.Lütfen Sevk Yöntemi Seçiniz'> !");
			return false;
		}
		
		if(document.getElementById("transport_comp_id").value == "")
		{
			alert("<cf_get_lang no='318.Taşıyıcı Seçiniz'> !");
			return false;
		}
		transport_control();/*Satır eklerkende taşıyıcıyı kontrol etsin.*/
		row_count2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		newRow.setAttribute("name","frm_row_other" + row_count2);
		newRow.setAttribute("id","frm_row_other" + row_count2);		
		newRow.setAttribute("NAME","frm_row_other" + row_count2);
		newRow.setAttribute("ID","frm_row_other" + row_count2);		
		document.getElementById('record_num_other').value=row_count2;
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_other' + row_count2 +'" id="row_kontrol_other' + row_count2 +'" value="1"><a style="cursor:pointer" onclick="sil_other(' + row_count2 + ');"><i class="icon-trash-o"  align="absmiddle"></i></a>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="quantity' + row_count2 +'" id="quantity' + row_count2 +'" onblur="degistir( ' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event,0));" value="<cfoutput>#tlformat(1,0)#</cfoutput>" class="moneybox" style="width:40px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<select name="package_type' + row_count2 +'" id="package_type' + row_count2 +'" onchange="degistir( ' + row_count2 + ');" style="width:130px;"><option value=""><cf_get_lang_main no ='322.Seçiniz'></option><cfoutput query="get_package_type"><option value="#package_type_id#,#dimention#,#calculate_type_id#">#package_type#</option></cfoutput></select>'; //add_general_prom();
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_ebat' + row_count2 +'" id="ship_ebat' + row_count2 +'" value="" readonly style="width:90px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_agirlik' + row_count2 +'" id="ship_agirlik' + row_count2 +'" value="" onBlur="degistir(' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:75px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="total_price' + row_count2 +'" id="total_price' + row_count2 +'" value="" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:75px;"><input type="hidden" name="other_money' + row_count2 +'" id="other_money' + row_count2 +'" value="" class="moneybox" readonly style="width:50px;"><input type="text" name="ship_barcod' + row_count2 +'" id="ship_barcod' + row_count2 +'" value="" style="width:120px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="pack_emp_id' + row_count2 +'" id="pack_emp_id' + row_count2 +'" value=""><input type="text" name="pack_emp_name' + row_count2 +'" id="pack_emp_name' + row_count2 +'" value="" style="width:150px;"> <a href="javascript://" onClick="pencere_ac2('+ row_count2 +');"><i class="icon-ellipsis"  align="absmiddle"></i></a>';
	}
	
	function degistir(id)
	{
		if(document.getElementById('row_kontrol_other'+id).value == 1)
		{
			if(trim(document.getElementById('quantity'+id).value).length == 0)
				document.getElementById('quantity'+id).value = 1;
		}
		if(document.getElementsByName('calculate_type')[1].checked)
		{
			var temp_package_type = document.getElementById('package_type'+id);
			var temp_ship_ebat = document.getElementById('ship_ebat'+id);
			var temp_total_price = document.getElementById('total_price'+id);
			var temp_quantity = document.getElementById('quantity'+id);
			var temp_other_money = document.getElementById('other_money'+id);
			var temp_ship_agirlik = document.getElementById('ship_agirlik'+id);
			
			temp_desi = list_getat(temp_package_type.value,2,',');
			temp_package_type_id = list_getat(temp_package_type.value,3,',');
			if(temp_package_type_id==1) //Desi
			{
				temp_ship_ebat.value = temp_desi;
				temp_ship_agirlik.value = '';
				desi_1 = list_getat(temp_desi,1,'*');
				desi_2 = list_getat(temp_desi,2,'*');
				desi_3 = list_getat(temp_desi,3,'*');
				desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000);
				if(desi_hesap<document.getElementById("max_limit").value)
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + desi_hesap;
					var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" +  document.getElementById("max_limit").value + "*" + document.getElementById("max_limit").value;
					var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
			}
			else if(temp_package_type_id==2) 
			{	
				temp_ship_agirlik_ = parseFloat(filterNum(temp_ship_agirlik.value))*parseFloat(temp_quantity.value);
				if(temp_ship_agirlik_>document.getElementById("max_limit").value)
					temp_ship_agirlik_ = Math.ceil(temp_ship_agirlik_);
				if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
				{
					if(temp_ship_agirlik_<document.getElementById("max_limit").value)
					{
						var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + temp_ship_agirlik_;
						var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					else
					{
						var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
						var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
				}	
			}	
			else if(temp_package_type_id==3)  //Zarf ise
			{
				var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value;
				var GET_PRICE = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
			}
			if(GET_PRICE != undefined)
			{
				if(GET_PRICE.recordcount==0)
				{
					alert("<cf_get_lang no ='471.Lütfen Hesaplama için Sevk Yöntemi, Tasıyıcı Firma, Paket Tipini Kontrol Ediniz (Fiyat Listesi)'>!");
					temp_ship_ebat.value = "";
					temp_total_price.value = "";
					temp_other_money.value = "";
				}
				else
				{
					if(temp_package_type_id==1)//Desi ise
					{
						temp_ship_agirlik.value = "";
						if(desi_hesap < document.getElementById("max_limit").value)
						{
							temp_total_price.value = commaSplit(GET_PRICE.PRICE*temp_quantity.value);/*Toplam atanıyor.*/
						}
						else
						{
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
							desi_remain = parseFloat((parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3))/(3000)-<cfoutput>document.getElementById("max_limit").value</cfoutput>);
							temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value));
							
						}
					}
					if(temp_package_type_id==2)//Kg ise
					{
						temp_ship_ebat.value = "";
						if(temp_ship_agirlik_<document.getElementById("max_limit").value)
						{
							temp_total_price.value = commaSplit(GET_PRICE.PRICE);
						}
						else
						{
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
							kg_remain = parseFloat(temp_ship_agirlik_-document.getElementById("max_limit").value);
							temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain));
						}
					}				
					
					else if(temp_package_type_id==3)//Zarf ise
					{
						temp_ship_agirlik = '';
						temp_ship_ebat.value = '';
						temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value));
					}
					temp_other_money.value = GET_PRICE.OTHER_MONEY;
				}
			}
			else
			{
				temp_total_price.value = "";
				temp_other_money.value = "";	
			}
		}
		else
		{
			count_desi = 0;
			count_kg = 0;
			count_envelope = 0;
			desi_sum = 0;
			kg_sum = 0;
			desi_price_sum = 0;
			kg_price_sum = 0;
			envelope_price_sum = 0;
			
			for(r=1;r<=document.getElementById('record_num_other').value;r++)
			{
				if(document.getElementById("row_kontrol_other"+r).value == 1)
				{
					var temp_package_type = document.getElementById("package_type"+r);
					var temp_ship_ebat = document.getElementById("ship_ebat"+r);
					var temp_quantity = document.getElementById("quantity"+r);
					var temp_ship_agirlik = document.getElementById("ship_agirlik"+r);
	
					temp_desi = list_getat(temp_package_type.value,2,',');
					temp_package_type_id = list_getat(temp_package_type.value,3,',');
					if(temp_package_type_id==1) //Desi
					{
						count_desi += 1;
						temp_ship_ebat.value = temp_desi;
						temp_ship_agirlik.value = '';
						desi_1 = list_getat(temp_desi,1,'*');
						desi_2 = list_getat(temp_desi,2,'*');
						desi_3 = list_getat(temp_desi,3,'*');
						desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000*parseFloat(temp_quantity.value));
						desi_sum +=desi_hesap;
					}
					else if(temp_package_type_id==2)//Kg
					{
						count_kg += 1;
						temp_ship_ebat.value = "";
						if(trim(document.getElementById("ship_agirlik"+r).value).length == 0)
							document.getElementById("ship_agirlik"+r).value = 1;
						temp_ship_agirlik_ = filterNum(temp_ship_agirlik.value);
						if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
							kg_sum +=parseFloat(temp_ship_agirlik_)*parseFloat(temp_quantity.value);
					}	
					else if(temp_package_type_id==3)//Zarf ise
					{
						count_envelope += 1;
						temp_ship_agirlik.value = '';
						temp_ship_ebat.value = '';
						var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value;
						var GET_PRICE3 = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
						if(GET_PRICE3 != undefined)
						{
							if(GET_PRICE3.recordcount==0)
								alert("<cf_get_lang no ='472.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Zarf) Kontrol Ediniz (Fiyat Listesi)'>!");
							else
								envelope_price_sum += GET_PRICE3.PRICE * parseFloat(temp_quantity.value);
						}					
					}
				}
			}
	
			if(count_desi != 0)
			{
				if(desi_sum<document.getElementById("max_limit").value)
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + desi_sum;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				
				if(GET_PRICE1 != undefined)
				{
					if(GET_PRICE1.recordcount==0)
						alert("<cf_get_lang no ='473.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Desi) Kontrol Ediniz (Fiyat Listesi)'>!");
					else
					{
						if(desi_sum<document.getElementById("max_limit").value)
						{
							desi_price_sum = GET_PRICE1.PRICE;
						}
						else
						{					
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
							desi_remain2 = parseFloat(desi_sum-document.getElementById("max_limit").value);
							desi_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*desi_remain2);
						}
					}
				}
			}
			if(count_kg != 0)
			{
				if(kg_sum<document.getElementById("max_limit").value)
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + kg_sum;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				
				if(GET_PRICE1 != undefined)
				{
					if(GET_PRICE1.recordcount==0)
						alert("<cf_get_lang no ='474.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
					else
					{
						if(kg_sum<document.getElementById("max_limit").value)
						{
							kg_price_sum = parseFloat(GET_PRICE1.PRICE);
						}
						else
						{	
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30_2','dsn',0,document.getElementById("transport_comp_id").value);
							kg_remain2 = parseFloat(kg_sum-document.getElementById("max_limit").value);
							kg_remain2 = Math.ceil(kg_remain2);
							kg_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain2);
						}
					}
				}
			}
			document.getElementById("total_cost_value").value = commaSplit(parseFloat(desi_price_sum)+parseFloat(kg_price_sum)+parseFloat(envelope_price_sum));
		}
		return kur_hesapla();
	}
	
	function control()
	{
		var deger_zarf_kontrol = 0;	
		<cfif is_show_cost eq 1>
		if(document.getElementById('options_kontrol').value==0 || document.getElementById('options_kontrol').value == "")
		{	
			alert("<cf_get_lang no ='474.Lütfen Hesaplama için Sevk Yöntemi, Tasıyıcı Firma, Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
			return false;
		}
		</cfif>
		if(document.getElementById('deliver_company_id').value=="" && document.getElementById('deliver_consumer_id').value=="")
		{
			alert("<cf_get_lang no='131.Cari Hesap Seçiniz'>!");
			return false;
		}	
		
		if(document.getElementById('ship_method_id').value == "")	
		{
			alert("<cf_get_lang no='305.Lütfen Sevk Yöntemi Seçiniz'> !");
			return false;
		}
		
		if(document.getElementById('transport_comp_id').value == "")	
		{
			alert("<cf_get_lang no='318.Taşıyıcı Seçiniz'> !");
			return false;
		}
		//Irsaliye kontrolleri
		for(r=1;r<=document.getElementById('record_num').value;r++)
		{
			deger_row_kontrol = document.getElementById('row_kontrol'+r);
			//deger_ship_id = document.getElementById('ship_id'+r);
			if(deger_row_kontrol.value == 1)
			{
				if(document.getElementById('ship_id'+r).value == "")
				{
					alert("<cf_get_lang no='306.Lütfen İrsaliye Seçiniz'> !");
					return false;
				}
			}
		}
		
		//Zarf ise sevkiyat adresi zorunlu
		if(deger_zarf_kontrol == 1)
		{
			if(document.getElementById('sending_address').value == "")
			{
				alert("<cf_get_lang no ='475.Zarf Gönderilerinde Sevkiyat Adresi Seçilmelidir'>!")
				return false;
			}
		}
		if(document.getElementById('sending_address').value.length > 300)
		{
			alert("<cf_get_lang no ='476.Sevkiyat Adresi 300 Karakterden Fazla Olamaz'>!");
			return false;
		}
		<cfif is_show_cost eq 1>
			// Paket kontrolleri
			for(r=1;r<=document.getElementById('record_num_other').value;r++)
			{
				if(document.getElementById("row_kontrol_other"+r).value == 1)
				{
					if(document.getElementById("package_type"+r).value == "")
					{
						alert("<cf_get_lang no='307.Lütfen Paket Tipi Seçiniz'>!");
						return false;
					}
					if(list_getat(document.getElementById("package_type"+r).value,3) == 3)
						deger_zarf_kontrol = 1;
				}
			}
			if (document.getElementById("record_num_other").value == 0)
			{
				alert("Paketleme Tipi Seçiniz!");
				return false;	
			}
			else 
				unformat_fields();
		</cfif>
		
		if (document.getElementById("record_num").value == 0)
		{
			alert("İrsaliye Seçiniz!");
			return false;	
		}
			
		/*for(i=1;i<=document.getElementById('record_num').value;++i)
		{
			document.getElementById('add_packet_ship').appendChild(document.getElementById('row_kontrol' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_id' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_number' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_date' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_deliver' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_type' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_adress' + i));
		}
		
		for(i=1;i<=document.getElementById('record_num_other').value;++i)
		{
			document.getElementById('add_packet_ship').appendChild(document.getElementById('package_type' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_ebat' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('total_price' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('quantity' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('other_money' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_agirlik' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('row_kontrol_other' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_barcod' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('pack_emp_id' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('pack_emp_name' + i));
		}*/
		document.add_packet_ship.ship_price.value = filterNum(document.add_packet_ship.ship_price.value);		
		if(process_cat_control())
		{
			return paper_control(document.getElementById("transport_no1"),'SHIP_FIS');
		}
		else
			return false;	
	}
	
	function kur_hesapla()
	{
		total_cost_value = 0;
		if(document.getElementsByName('calculate_type')[1].checked)
		{		
			for(r=1;r<=document.getElementById('record_num_other').value;r++)
			{
				if(document.getElementById("row_kontrol_other"+r).value == 1)
				{
					var temp_other_money = document.getElementById("other_money"+r);
					var temp_total_price = document.getElementById("total_price"+r);
					
					if(temp_total_price.value != '')
					{
						temp_sira = list_find(money_list,temp_other_money.value);				
						temp_rate1 = list_getat(rate1_list,temp_sira);
						temp_rate2 = list_getat(rate2_list,temp_sira);
						temp_deger = parseFloat(parseFloat(filterNum(temp_total_price.value)) / (parseFloat(temp_rate1) / parseFloat(temp_rate2)));
						total_cost_value = parseFloat(total_cost_value) + parseFloat(temp_deger);
					}
				}
			}
			temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
			temp2_rate1 = list_getat(rate1_list,temp2_sira);
			temp2_rate2 = list_getat(rate2_list,temp2_sira);
			total_cost2_value = total_cost_value * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
			
			document.getElementById("total_cost_value").value = commaSplit(total_cost_value);
			document.getElementById("total_cost2_value").value = commaSplit(total_cost2_value);
		}
		else
		{
			temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
			temp2_rate1 = list_getat(rate1_list,temp2_sira);
			temp2_rate2 = list_getat(rate2_list,temp2_sira);
			total_cost2_value = filterNum(document.getElementById("total_cost_value").value) * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
			document.getElementById("total_cost2_value").value = commaSplit(total_cost2_value);
		}
		return true;
	}
	
	function unformat_fields()
	{
		for(r=1;r<=document.getElementById('record_num_other').value;r++)
		{
			if(document.getElementById("row_kontrol_other"+r).value == 1)
			{
				document.getElementById("quantity"+r).value = filterNum(document.getElementById("quantity"+r).value);
				document.getElementById("ship_agirlik"+r).value = filterNum(document.getElementById("ship_agirlik"+r).value);
				document.getElementById("total_price"+r).value = filterNum(document.getElementById("total_price"+r).value);
				//document.getElementById("ship_price"+r).value = filterNum(document.getElementById("ship_price"+r).value);
			}
		}
		document.getElementById("total_cost_value").value = filterNum(document.getElementById("total_cost_value").value);
		document.getElementById("total_cost2_value").value = filterNum(document.getElementById("total_cost2_value").value);
	}
	
	function change_packet(calculate_type_value)
	{		
		if(row_count2!=0)
		{
			if(calculate_type_deger!=calculate_type_value)
			{
				if(calculate_type_value == 2)
				{
					for(r=1;r<=document.getElementById('record_num_other').value;r++)
					{
						if(document.getElementById("row_kontrol_other"+r).value == 1)
						{
							document.getElementById("package_type"+r).value = '';
							document.getElementById("ship_ebat"+r).value = '';
							document.getElementById("ship_agirlik"+r).value = '';
							document.getElementById("total_price"+r).value = '';
							document.getElementById("other_money"+r).value = '';
						}					
					}
					document.getElementById("total_cost_value").value = commaSplit(0);
					document.getElementById("total_cost2_value").value = commaSplit(0);				
				}
				else
				{
					degistir(1);
				}
			}
		}
		calculate_type_deger = calculate_type_value;
		return true;
	}
	
	function hepsi()
	{
		deger = document.getElementById("pack_emp_name0").value;
		deger2 = document.getElementById("pack_emp_id0").value;
	
		for(var i=1;i<=document.getElementById('record_num_other').value;i++)
		{
			nesne_ = document.getElementById("pack_emp_name"+i);
			nesne_.value = deger;
			nesne2_ = document.getElementById("pack_emp_id"+i);
			nesne2_.value = deger2;
		}
	}
	
	function pencere_ac_(no)
	{
		if (document.getElementById("sending_country_id").value == "")
		{
			alert("<cf_get_lang no ='477.İlk Olarak Ülke Seçiniz'> !");
		}	
		else if(document.getElementById("sending_city_id").value == "")
		{
			alert("<cf_get_lang no ='314.İl Seçiniz'> !");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_packet_ship.sending_county_id&field_name=add_packet_ship.sending_county&city_id=' + document.getElementById("sending_city_id").value,'small');
			document.getElementById("sending_county_id").value = '';
			document.getElementById("sending_county").value = '';
		}
	}
	
	function pencere_ac_city()
	{
		if (document.getElementById("sending_country_id").value == "")
		{
			alert("<cf_get_lang no ='477.İlk Olarak Ülke Seçiniz'> !");
		}	
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_packet_ship.sending_city_id&field_name=add_packet_ship.sending_city&country_id=' + document.getElementById("sending_country_id").value,'small');
		}
		return remove_adress('2');
	}
	
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.getElementById("sending_city_id").value = '';
			document.getElementById("sending_city").value = '';
			document.getElementById("sending_county_id").value = '';
			document.getElementById("sending_county").value = '';
		}
		else
		{
			document.getElementById("sending_county_id").value = '';
			document.getElementById("sending_county").value = '';
		}	
	}
	<cfif isdefined("attributes.is_logistic") and len(attributes.is_logistic)>
		<cfoutput query="add_logistic">
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			document.getElementById("record_num").value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'"  id="row_kontrol' + row_count +'" value="1"> <a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="icon-trash-o"  align="absmiddle"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'" value="#ship_id#"><input type="text" name="ship_number' + row_count +'" value="#ship_number#" readonly style="width:105px;">&nbsp;<a href="javascript://" onClick="pencere_ac('+ row_count +');"><i class="icon-ellipsis"  align="absmiddle"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="#dateformat(ship_date,"dd/mm/yyyy")#" readonly style="width:70px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			<cfif len(company_id)>
				newCell.innerHTML = '<input type="text" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="#get_company.nickname[listfind(main_company_list,company_id,',')]#" readonly style="width:120px;">';
			<cfelse>
				newCell.innerHTML = '<input type="text" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="#get_consumer.consumer_name[listfind(main_consumer_list,consumer_id,',')]# #get_consumer.consumer_surname[listfind(main_consumer_list,consumer_id,',')]#" readonly style="width:120px;">';
			</cfif>
			<cfif len(ship_method)>
				<cfquery name="GET_SHIP_METHOD" datasource="#dsn#"> 
					SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #ship_method#
				</cfquery>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="#get_ship_method.ship_method#" readonly style="width:180px;">';
			<cfelse>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly style="width:180px;">';
			</cfif>
			<cfset temp_ = Replace(address,"'","","")>;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="#temp_#" readonly style="width:300px;">';
		</cfoutput>
		<cfif get_control_.recordcount>
			alert('<cf_get_lang no ="588.Daha Önce Sevk Edilmiş Kayıtlar"> : <cfoutput>#valuelist(get_control_.ship_number)#</cfoutput>');
		</cfif>
	</cfif>
	<cfif isdefined("attributes.is_logistic2")>
		<cfoutput query="add_logistic2">
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			document.getElementById("record_num").value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="icon-trash-o"  align="absmiddle"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="ship_id' + row_count +'"  id="ship_id' + row_count +'" value="#ship_id#"><input type="text" name="ship_number' + row_count +'" value="#ship_number#" readonly style="width:110px;"><a href="javascript://" onClick="pencere_ac('+ row_count +');" ><i class="icon-ellipsis"  align="absmiddle"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="#dateformat(ship_date,"dd/mm/yyyy")#" readonly style="width:70px;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="#member_name#" readonly style="width:120px;">';
			<cfif len(ship_method)>
				<cfquery name="GET_SHIP_METHOD" datasource="#DSN#"> 
					SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #ship_method#
				</cfquery>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="#get_ship_method.ship_method#" readonly style="width:180px;">';
			<cfelse>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly style="width:180px;">';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="#address#" readonly style="width:300px;">';
		</cfoutput>
		<cfif get_control_.recordcount>
			alert('<cf_get_lang no ='588.Daha Önce Sevk Edilmiş Kayıtlar'> : <cfoutput>#valuelist(get_control_.ship_number)#</cfoutput>');
		</cfif>
	</cfif>	
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
	$(document).ready(function()
	{
		<cfif is_show_cost eq 1>
			calculate_type_deger=<cfoutput>#get_ship_method_price.calculate_type#</cfoutput>;
			row_count2=<cfoutput>#get_package.recordcount#</cfoutput>;
		</cfif>
		row_count=<cfoutput>#get_row.recordcount#</cfoutput>;
		money_list = "<cfoutput>#valuelist(moneys.money,',')#</cfoutput>";
		rate1_list = "<cfoutput>#valuelist(moneys.rate1,',')#</cfoutput>";
		rate2_list = "<cfoutput>#valuelist(moneys.rate2,',')#</cfoutput>";	
	});
	
	function add_adress(adress_type)
	{
		if(!(upd_packet_ship.partner_id.value=="") || !(upd_packet_ship.consumer_id.value==""))
		{	
			if(upd_packet_ship.partner_id.value!="")
			{
				str_adrlink = '&field_adres=upd_packet_ship.sending_address&field_city=upd_packet_ship.sending_city_id&field_city_name=upd_packet_ship.sending_city&field_county=upd_packet_ship.sending_county_id&field_county_name=upd_packet_ship.sending_county&field_postcode=upd_packet_ship.sending_postcode&field_semt=upd_packet_ship.sending_semt'; 
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(upd_packet_ship.company.value)+''+ str_adrlink , 'list');
				return true;
			}
			else
			{
				str_adrlink = '&field_adres=upd_packet_ship.sending_address&field_city=upd_packet_ship.sending_city_id&field_city_name=upd_packet_ship.sending_city&field_county=upd_packet_ship.sending_county_id&field_county_name=upd_packet_ship.sending_county&field_country=upd_packet_ship.sending_country_id&field_country_name=upd_packet_ship.sending_country&field_postcode=upd_packet_ship.sending_postcode&field_semt=upd_packet_ship.sending_semt'; 
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(upd_packet_ship.member_name.value)+''+ str_adrlink , 'list');
				return true;
			}
		}
		else
		{
			alert("<cf_get_lang no ='131.Cari Hesap Seçiniz'> !");
			return false;
		}		
	}
	
	function pencere_ac(no)
	{	
		if(document.getElementById('member_name').value !='')
		{
			document.getElementById('ship_id_list').value  ='';
			for(r=1;r<=upd_packet_ship.record_num.value;r++)
			{
				deger_row_kontrol = document.getElementById("row_kontrol"+r);
				deger_ship_id = document.getElementById("ship_id"+r);
				if(deger_row_kontrol.value == 1)
				{
					if(document.getElementById('ship_id_list').value == '')
					{
						if(deger_ship_id.value != '')
							document.getElementById('ship_id_list').value = deger_ship_id.value;
					}
					else
					{
						if(deger_ship_id.value != '')
							document.getElementById('ship_id_list').value += ','+deger_ship_id.value;
					}	
				}
			}		
			windowopen('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,".")#.popup_list_ship_details</cfoutput>&ship_id_list=' + document.getElementById("ship_id_list").value + '&ship_id=ship_id'+no+'&ship_number=ship_number'+no+'&ship_date=ship_date'+no+'&ship_deliver=ship_deliver'+no+'&ship_type=ship_type'+no+'&ship_adress=ship_adress'+no+'&is_gonder=1&deliver_company_id='+document.getElementById("deliver_company_id").value,'project');//&deliver_company_id='+upd_packet_ship.service_company_id.value
		}
		else
		{
			alert("<cf_get_lang no='131.Cari Hesap Seçiniz'>!");
		}
	}
	
	function pencere_ac2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_packet_ship.pack_emp_id'+ no +'&field_name=upd_packet_ship.pack_emp_name'+ no+'&select_list=1','list','popup_list_positions');
	}
	
	function pencere_ac2_main()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_packet_ship.pack_emp_id0&field_name=upd_packet_ship.pack_emp_name0&select_list=1&call_function=hepsi()','list','popup_list_positions');
	}
	
	function sil(sy)
	{
		var my_element=document.getElementById("row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function sil_other(sy)
	{
		var my_element2=document.getElementById("row_kontrol_other"+sy);
		my_element2.value=0;
		var my_element2=eval("frm_row_other"+sy);
		my_element2.style.display="none";
		if(document.getElementById('calculate_type_2').checked)/*Paket ise*/
			return kur_hesapla();
		else
			degistir(sy);
	}
	
	function add_row()
	{
		<cfif is_department_required eq 1>
			if((document.getElementById("department_id").value=="") || (document.getElementById("department_name").value==""))
			{
				alert("Çıkış Depo Seçiniz !");
				return false;
			}
		</cfif>
			
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.getElementById('record_num').value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden" value="" name="ship_result_row_id' + row_count +'" id="ship_result_row_id' + row_count +'"><input  type="hidden" value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="icon-trash-o"  align="absmiddle"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'"><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'" value="" readonly style="width:110px;"><a href="javascript://" onClick="pencere_ac('+ row_count +');"><i class="icon-ellipsis"  align="absmiddle"></i></a>';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="" readonly style="width:70px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="" readonly style="width:120px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly style="width:180px;">';
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="" readonly style="width:300px;">';
	}
	
	function add_row_other()
	{
		row_count2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		newRow.setAttribute("name","frm_row_other" + row_count2);
		newRow.setAttribute("id","frm_row_other" + row_count2);		
		newRow.setAttribute("NAME","frm_row_other" + row_count2);
		newRow.setAttribute("ID","frm_row_other" + row_count2);		
		document.getElementById('record_num_other').value=row_count2;
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="ship_result_package_id' + row_count2 +'" id="ship_result_package_id' + row_count2 +'" value=""><input type="hidden" value="1" name="row_kontrol_other' + row_count2 +'" id="row_kontrol_other' + row_count2 +'"><a style="cursor:pointer" onclick="sil_other(' + row_count2 + ');"><i class="icon-trash-o"  align="absmiddle"></i></a>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="quantity' + row_count2 +'" id="quantity' + row_count2 +'" onblur="degistir( ' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event,0));" value="<cfoutput>#tlformat(1,0)#</cfoutput>" class="moneybox" style="width:40px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<select name="package_type' + row_count2 +'" id="package_type' + row_count2 +'" onchange="degistir( ' + row_count2 + ');" style="width:130px;"><option value="">Seçiniz</option><cfoutput query="get_package_type"><option value="#package_type_id#,#dimention#,#calculate_type_id#">#package_type#</option></cfoutput></select>'; //add_general_prom();
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_ebat' + row_count2 +'" id="ship_ebat' + row_count2 +'" value="" readonly style="width:90px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="text" name="ship_agirlik' + row_count2 +'" id="ship_agirlik' + row_count2 +'" value="" onBlur="degistir(' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event));" class="moneybox" style="width:90px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="total_price' + row_count2 +'" id="total_price' + row_count2 +'" value="" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly style="width:75px;"><input type="hidden" name="other_money' + row_count2 +'" id="other_money' + row_count2 +'" value="" class="moneybox" readonly style="width:50px;"><input type="text" name="ship_barcod' + row_count2 +'" id="ship_barcod' + row_count2 +'" value="" style="width:90px;">';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input type="hidden" name="pack_emp_id' + row_count2 +'" id="pack_emp_id' + row_count2 +'" value=""><input type="text" name="pack_emp_name' + row_count2 +'" id="pack_emp_name' + row_count2 +'" value="" style="width:150px;"><a href="javascript://" onClick="pencere_ac2('+ row_count2 +');"><i class="icon-ellipsis"  align="absmiddle"></i></a>';
		
	}
	<cfif is_show_cost eq 1>
		function degistir(id)
		{
			if(document.getElementById("row_kontrol_other"+id).value == 1)
			{
				if(trim(document.getElementById("quantity"+id).value).length == 0)
					document.getElementById("quantity"+id).value = 1;
			}
			if(document.getElementById('calculate_type_2').checked)/*Paket ise*/
			{
				var temp_package_type = document.getElementById("package_type"+id);
				var temp_ship_ebat = document.getElementById("ship_ebat"+id);
				var temp_total_price = document.getElementById("total_price"+id);
				var temp_quantity = document.getElementById("quantity"+id);
				var temp_other_money = document.getElementById("other_money"+id);
				var temp_ship_agirlik = document.getElementById("ship_agirlik"+id);
				
				temp_desi = list_getat(temp_package_type.value,2,',');
				temp_package_type_id = list_getat(temp_package_type.value,3,',');
				if(temp_package_type_id==1) //Desi
				{	
					temp_ship_ebat.value = temp_desi;
					desi_1 = list_getat(temp_desi,1,'*');
					desi_2 = list_getat(temp_desi,2,'*');
					desi_3 = list_getat(temp_desi,3,'*');
					desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000);
					if(desi_hesap<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
					{	
						var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + desi_hesap;
						var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					else 
					{
						var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + "<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>";
						var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
				}
				else if(temp_package_type_id==2) 
				{	
					temp_ship_agirlik_ = parseFloat(filterNum(temp_ship_agirlik.value))*parseFloat(temp_quantity.value);
					//burdaki ifadenin ust limiti asmasi durumunda rakam uste yuvarlanir Or: 31,5 degeri 32 olur
					if(temp_ship_agirlik_><cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
						temp_ship_agirlik_ = Math.ceil(temp_ship_agirlik_);
					if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
					{
						if(temp_ship_agirlik_<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
						{
							var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + temp_ship_agirlik_;
							var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
						else
						{
							var listPAram = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + "<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>";
							var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
						}
					}	
				}	
				else if(temp_package_type_id==3)  //Zarf ise
				{
					var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value;
					var GET_PRICE = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
				}
				if(GET_PRICE != undefined)
				{
					if(GET_PRICE.recordcount==0)
					{
						alert("<cf_get_lang no ='471.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini Kontrol Ediniz (Fiyat Listesi)'>!"+GET_PRICE.recordcount);
						temp_ship_ebat.value = "";
						temp_total_price.value = "";
						temp_other_money.value = "";
					}
					else
					{
						if(temp_package_type_id==1)//Desi ise
						{
							temp_ship_agirlik.value = "";
							if(desi_hesap<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
							{
								temp_total_price.value = commaSplit(GET_PRICE.PRICE*temp_quantity.value);/*Toplam atanıyor.*/
							}
							else 
							{
								var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById('transport_comp_id').value);
								desi_remain = parseFloat((parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3))/(3000)-<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>);
								temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value));
							}
						}
						if(temp_package_type_id==2)//Kg ise
						{
							temp_ship_ebat.value = "";
							if(temp_ship_agirlik_<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
							{
								temp_total_price.value = commaSplit(GET_PRICE.PRICE);
							}
							else
							{
								var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById('transport_comp_id').value);
								kg_remain = parseFloat(temp_ship_agirlik_-<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>);
								temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain));
							}
						}				
						
						else if(temp_package_type_id==3)//Zarf ise
						{
							temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value));
						}
						temp_other_money.value = GET_PRICE.OTHER_MONEY;
					}
				}
				else
				{
					temp_total_price.value = "";
					temp_other_money.value = "";	
				}
			}
			else
			{
				count_desi = 0;
				count_kg = 0;
				count_envelope = 0;
				desi_sum = 0;
				kg_sum = 0;
				desi_price_sum = 0;
				kg_price_sum = 0;
				envelope_price_sum = 0;
				
				for(r=1;r<=upd_packet_ship.record_num_other.value;r++)
				{
					if(document.getElementById("row_kontrol_other"+r).value == 1)
					{
						var temp_package_type = document.getElementById("package_type"+r);
						var temp_ship_ebat = document.getElementById("ship_ebat"+r);
						var temp_quantity = document.getElementById("quantity"+r);
						temp_desi = list_getat(temp_package_type.value,2,',');
						temp_package_type_id = list_getat(temp_package_type.value,3,',');
						if(temp_package_type_id==1) //Desi
						{
							
							count_desi += 1;
							temp_ship_ebat.value = temp_desi;
							desi_1 = list_getat(temp_desi,1,'*');
							desi_2 = list_getat(temp_desi,2,'*');
							desi_3 = list_getat(temp_desi,3,'*');
							desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000*parseFloat(temp_quantity.value));
							desi_sum +=desi_hesap;
						}
						else if(temp_package_type_id==2)//Kg
						{
							count_kg += 1;
							temp_ship_ebat.value = "";
							if(trim(document.getElementById("ship_agirlik"+r).value).length == 0)
								document.getElementById("ship_agirlik"+r).value = 1;
							temp_ship_agirlik = document.getElementById("ship_agirlik"+r);
							temp_ship_agirlik_ = filterNum(temp_ship_agirlik.value);
							if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
								kg_sum +=parseFloat(temp_ship_agirlik_)*parseFloat(temp_quantity.value);
						}	
						else if(temp_package_type_id==3)//Zarf ise
						{
							count_envelope += 1;
							var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value;
							var GET_PRICE3 = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
							if(GET_PRICE3 != undefined)
							{
								if(GET_PRICE3.recordcount==0)
									alert("<cf_get_lang no ='472.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Zarf) Kontrol Ediniz (Fiyat Listesi)'>!");
								else
									envelope_price_sum += GET_PRICE3.PRICE * parseFloat(temp_quantity.value);
							}					
						}
					}
				}
		
				if(count_desi != 0)
				{
					if(desi_sum<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
					{
						var listParam = +document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + desi_sum;
						var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					else
					{
						var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + "<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>";
						var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					
					if(GET_PRICE1 != undefined)
					{
						if(GET_PRICE1.recordcount==0)
							alert("<cf_get_lang no ='473.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Desi) Kontrol Ediniz (Fiyat Listesi)'>!");
						else
						{
							if(desi_sum<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
							{
								desi_price_sum = GET_PRICE1.PRICE;
							}
							else
							{					
								var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById('transport_comp_id').value);
								desi_remain2 = parseFloat(desi_sum-<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>);
								desi_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*desi_remain2);
							}
						}
					}
				}
				if(count_kg != 0)
				{
					if(kg_sum<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
					{
						var listParam = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + kg_sum;
						var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					else
					{
						var listPAram = document.getElementById('transport_comp_id').value + "*" + document.getElementById('ship_method_id').value + "*" + "<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>";
						var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					
					if(GET_PRICE1 != undefined)
					{
						if(GET_PRICE1.recordcount==0)
							alert("<cf_get_lang no ='474.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
						else
						{
							if(kg_sum<<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>)
							{
								kg_price_sum = GET_PRICE1.PRICE;
							}
							else
							{					
								var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById('transport_comp_id').value);
								kg_remain2 = parseFloat(kg_sum-<cfoutput>#get_ship_method_price.MAX_LIMIT#</cfoutput>);
								kg_remain2 = Math.ceil(kg_remain2);
								kg_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain2);
							}
						}
					}
				}
				document.getElementById('total_cost_value').value = commaSplit(parseFloat(desi_price_sum)+parseFloat(kg_price_sum)+parseFloat(envelope_price_sum));
			}
			return kur_hesapla();
		}
	</cfif>
	function fiyat_hesapla(satir)
	{
		if(trim(document.getElementById("quantity"+satir).value).length == 0)
			document.getElementById("quantity"+satir).value = 1;
		
		if(document.getElementById("price"+satir).value.length != 0)
			document.getElementById("total_price"+satir).value = commaSplit(filterNum(document.getElementById("quantity"+satir).value) * filterNum(document.getElementById("price"+satir).value));
			
		return kur_hesapla();
	}
	
	function control()
	{
		document.upd_packet_ship.ship_price.value = filterNum(document.upd_packet_ship.ship_price.value);
		deger_zarf_kontrol = 0;	
		<cfif is_show_cost eq 1>
			if(document.getElementById('transport_comp_id').value != document.getElementById('transport_comp_id_').value)//Taşıyıcı firma değiştirildiyse	
			{	
				if(!(list_find(<cfoutput>'#transport_selected#'</cfoutput>,document.getElementById('transport_comp_id').value,',')))//Taşıyıcı firmanın dışında seçilen firma daha önceden seçilmiş mi?
				{
					alert("<cf_get_lang no='373.Bu Taşıyıcı Firmaya Ait Fiyat Listesi Yok'>!!");
					return false;
				}
			}
		</cfif>
		if((upd_packet_ship.deliver_company_id.value=="") && (upd_packet_ship.deliver_consumer_id.value==""))
		{
			alert("<cf_get_lang no='131.Cari Hesap Seçiniz'>");
			return false;
		}
	
		if(upd_packet_ship.ship_method_id.value == "" || upd_packet_ship.ship_method_name.value == "")	
		{
			alert("<cf_get_lang no='305.Lütfen Sevk Yöntemi Seçiniz'> !");
			return false;
		}
		
		//Irsaliye kontrolleri	
		for(r=1;r<=upd_packet_ship.record_num.value;r++)
		{
			deger_row_kontrol = document.getElementById("row_kontrol"+r);
			deger_ship_id = document.getElementById("ship_id"+r);
			if(deger_row_kontrol.value == 1)
			{
				if(deger_ship_id.value == "")
				{
					alert("<cf_get_lang no='306.Lütfen İrsaliye Seçiniz'> !");
					return false;
				}
			}
		}
		
		//Zarf ise sevkiyat adresi zorunlu
		if(deger_zarf_kontrol == 1)
		{
			if(document.getElementById('sending_address').value == "")
			{
				alert("<cf_get_lang no ='475.Zarf Gönderilerinde Sevkiyat Adresi Seçilmelidir'>!")
				return false;
			}
		}	
		
		if(document.getElementById('sending_address').value.length > 300)
		{
			alert("<cf_get_lang no ='476.Sevkiyat Adresi 300 Karakterden Fazla Olamaz'>!");
			return false;
		}
		<cfif is_show_cost eq 1>
			// Paket kontrolleri
			for(r=1; r<=document.getElementById("record_num_other").value; r++)
			{
				if(document.getElementById("row_kontrol_other"+r).value == 1)
				{
					if( document.getElementById("package_type"+r).value == "")
					{
						alert("<cf_get_lang no='307.Lütfen Paket Tipi Seçiniz'> !");
						return false;
					}
					if(list_getat( document.getElementById("package_type"+r).value,3) == 3)
						deger_zarf_kontrol = 1;			
				}
			}
			
			if (document.getElementById("record_num_other").value == 0)
			{
				alert("Paketleme Tipi Seçiniz!");
				return false;	
			}
			else 
				unformat_fields();
		</cfif>	
		
		if (document.getElementById("record_num").value == 0)
		{
			alert("İrsaliye Seçiniz!");
			return false;	
		}
		/*
		for(i=1;i<=document.getElementById('record_num').value;++i)
		{
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('row_kontrol' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_id' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_number' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_date' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_deliver' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_type' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_adress' + i));
		}
		for(i=1;i<=document.getElementById('record_num_other').value;++i)
		{
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('package_type' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_ebat' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('total_price' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('quantity' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('other_money' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_agirlik' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('row_kontrol_other' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('ship_barcod' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('pack_emp_id' + i));
			document.getElementById('upd_packet_ship').appendChild(document.getElementById('pack_emp_name' + i));
		}
		*/
		return true;
	}
	
	function kur_hesapla()
	{
		total_cost_value = 0;
		if(document.getElementById('calculate_type_2').checked)/*Paket ise*/
		{		
			for(r=1; r<=document.getElementById('record_num_other').value; r++)
			{
				if(document.getElementById("row_kontrol_other"+r).value == 1)
				{
					var temp_other_money = document.getElementById("other_money"+r);
					var temp_total_price = document.getElementById("total_price"+r);
					
					if(temp_total_price.value != '')
					{
						temp_sira = list_find(money_list,temp_other_money.value);				
						temp_rate1 = list_getat(rate1_list,temp_sira);
						temp_rate2 = list_getat(rate2_list,temp_sira);
						temp_deger = parseFloat(parseFloat(filterNum(temp_total_price.value)) / (parseFloat(temp_rate1) / parseFloat(temp_rate2)));
						total_cost_value = parseFloat(total_cost_value) + parseFloat(temp_deger);
					}
				}
			}
			temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
			temp2_rate1 = list_getat(rate1_list,temp2_sira);
			temp2_rate2 = list_getat(rate2_list,temp2_sira);
			total_cost2_value = total_cost_value * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
			
			document.getElementById('total_cost_value').value = commaSplit(total_cost_value);
			document.getElementById('total_cost2_value').value = commaSplit(total_cost2_value);
		}
		else
		{
			temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
			temp2_rate1 = list_getat(rate1_list,temp2_sira);
			temp2_rate2 = list_getat(rate2_list,temp2_sira);
			total_cost2_value = filterNum(document.getElementById('total_cost_value').value) * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
			document.getElementById('total_cost2_value').value = commaSplit(total_cost2_value);
		}
		return true;
	}
	function change_packet(calculate_type_value)
	{
		if(row_count2!=0)
		{
			if(calculate_type_deger!=calculate_type_value)
			{
				if(calculate_type_value == 2)/*Satır ise*/
				{
					for(r=1;r<=document.getElementById("record_num_other").value;r++)
					{
						if(document.getElementById("row_kontrol_other"+r).value == 1)
						{
							document.getElementById("package_type"+r).value = '';
							document.getElementById("ship_ebat"+r).value = '';
							document.getElementById("ship_agirlik"+r).value = '';
							document.getElementById("total_price"+r).value = '';
							document.getElementById("other_money"+r).value = '';
						}
					}
					document.getElementById('total_cost_value').value = commaSplit(0);
					document.getElementById('total_cost2_value').value = commaSplit(0);				
				}
				else
				{
					degistir(1);
				}
			}
		}
		calculate_type_deger = calculate_type_value;
		return true;
	}
	function unformat_fields()
	{
		for(r=1; r<=document.getElementById('record_num_other').value; r++)
		{
			if(document.getElementById("row_kontrol_other"+r).value == 1)
			{
				document.getElementById("quantity"+r).value = filterNum(document.getElementById("quantity"+r).value);
				document.getElementById("ship_agirlik"+r).value = filterNum(document.getElementById("ship_agirlik"+r).value);
				document.getElementById("total_price"+r).value = filterNum(document.getElementById("total_price"+r).value);
				
			}
		}
		document.getElementById('total_cost_value').value = filterNum(document.getElementById('total_cost_value').value);
		document.getElementById('total_cost2_value').value = filterNum(document.getElementById('total_cost2_value').value);
	}
	
	function hepsi()
	{
		deger = document.getElementById('pack_emp_name0').value;
		deger2 = document.getElementById('pack_emp_id0').value;
	
		for(var i=1;i<=document.getElementById('record_num_other').value;i++)
		{
			nesne_ = document.getElementById("pack_emp_name"+i);
			nesne_.value = deger;
			nesne2_ = document.getElementById("pack_emp_id"+i);
			nesne2_.value = deger2;
		}
	}
	
	function pencere_ac_(no)
	{
		if (document.getElementById('sending_country_id').value == "")
		{
			alert("<cf_get_lang no ='477.İlk Olarak Ülke Seçiniz'> !");
		}	
		else if(document.getElementById('sending_city_id').value == "")
		{
			alert("<cf_get_lang no ='314.İl Seçiniz'>!");
		}
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=upd_packet_ship.sending_county_id&field_name=upd_packet_ship.sending_county&city_id=' + document.getElementById('sending_city_id').value,'small');
			document.getElementById('sending_county_id').value = '';
			document.getElementById('sending_county').value = '';
		}
	}
	function pencere_ac_city()
	{
		if (document.getElementById('sending_country_id').value == "")
		{
			alert("<cf_get_lang no ='477.İlk Olarak Ülke Seçiniz'> !");
		}	
		else
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=upd_packet_ship.sending_city_id&field_name=upd_packet_ship.sending_city&country_id=' + document.getElementById('sending_country_id').value,'small');
		}
		return remove_adress('2');
	}
	
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.getElementById('sending_city_id').value = '';
			document.getElementById('sending_city').value = '';
			document.getElementById('sending_county_id').value = '';
			document.getElementById('sending_county').value = '';
		}
		else
		{
			document.getElementById('sending_county_id').value = '';
			document.getElementById('sending_county').value = '';
		}	
	}
<cfelseif isdefined("attributes.event") and attributes.event is 'detail'>
	function add_product_to_barkod(barcode,amount,type)
	{
		var amount = filterNum(amount,3)
		if(list_find('<cfoutput>#product_barcode_list#</cfoutput>',barcode,','))
		{
			var get_product = wrk_safe_query('stk_get_prodct','dsn1',0,barcode);
				if(document.getElementById('control_amount'+get_product.STOCK_ID)==undefined)
					alert("<cf_get_lang no ='514.Ürünün Barkodlarında Sorun Var'>")		
				else
				{
					if(document.add_package.changed_stock_id.value != "")//daha önceden bir satır eklenmişse alan dolmuş demektir ve yeni eklenecek alan için satırı renklendiyoruz bir alt satırda
						eval('row'+document.all.changed_stock_id.value).style.background='<cfoutput>#colorrow#</cfoutput>';
					if(type==1)//ekleme ise
					{		
						document.getElementById('control_amount'+get_product.STOCK_ID).value = commaSplit(parseFloat(parseFloat(document.getElementById('control_amount'+get_product.STOCK_ID).value)+parseFloat(amount)),3);	
						if(parseFloat(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3)) > parseFloat(document.getElementById('amount'+get_product.STOCK_ID).value))
							alert(document.getElementById('PRODUCT_NAME'+get_product.STOCK_ID).value+"<cf_get_lang no ='513.Ürününde Fazla Çıkış Var'> ");
					}			
					else if(type==0)//silme ise	
						if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) == 0 )
							alert("<cf_get_lang no ='512.Çıkan Ürünlerin Sayısı 0 dan küçük olamaz'>");
						else		
							document.getElementById('control_amount'+get_product.STOCK_ID).value = commaSplit(parseFloat(parseFloat(document.getElementById('control_amount'+get_product.STOCK_ID).value)-parseFloat(amount)),3);
								
								if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) == document.getElementById('amount'+get_product.STOCK_ID).value)
								{eval('document.all.is_ok'+get_product.STOCK_ID).style.display='';
								eval('document.all.is_error'+get_product.STOCK_ID).style.display='none';}	
								if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) > document.getElementById('amount'+get_product.STOCK_ID).value)
								{eval('document.all.is_ok'+get_product.STOCK_ID).style.display='none';
								eval('document.all.is_error'+get_product.STOCK_ID).style.display='';}
								if(filterNum(document.getElementById('control_amount'+get_product.STOCK_ID).value,3) < document.getElementById('amount'+get_product.STOCK_ID).value)
									eval('document.all.is_ok'+get_product.STOCK_ID).style.display='none';
				document.add_package.add_other_barcod.value='';
				document.add_package.del_other_barcod.value='';
				document.add_package.changed_stock_id.value = get_product.STOCK_ID;
				eval('row'+get_product.STOCK_ID).style.background='FFCCCC';
				}	
			}
		else
			alert("<cf_get_lang no ='511.Kayıtlı Barkod Yok'>!")
	}
	function kontrol()
	{
		<cfloop list="#stock_id_list#" index="kk"><cfoutput>
		if(document.getElementById('amount#kk#').value != filterNum(commaSplit(document.getElementById('control_amount#kk#').value,3)) )
			{
				alert(document.getElementById('PRODUCT_NAME#kk#').value +", #kk# <cf_get_lang no ='510.Satırdaki Ürün Sayısında Sorun Var'>!");
				return false;
			}
			
		document.getElementById('control_amount#kk#').value	= filterNum(document.getElementById('control_amount#kk#').value,3);
		</cfoutput>		
		</cfloop>
		return true;
		
		//document.add_package.submit();
	}
<cfelseif isdefined("attributes.event") and attributes.event is 'list_detail'>
	document.getElementById('keyword').focus();
	function gonder(ship_id,ship_number,ship_date,ship_deliver,ship_type,ship_address)
	{
		<cfif isDefined('attributes.ship_id')>
			window.opener.document.getElementById('<cfoutput>#attributes.ship_id#</cfoutput>').value=ship_id;
		</cfif>
		<cfif isDefined('attributes.ship_number')>
			window.opener.document.getElementById('<cfoutput>#attributes.ship_number#</cfoutput>').value=ship_number;
		</cfif>
		<cfif isDefined('attributes.ship_date')>
			window.opener.document.getElementById('<cfoutput>#attributes.ship_date#</cfoutput>').value=ship_date;
		</cfif>
		<cfif isDefined('attributes.ship_deliver')>
			window.opener.document.getElementById('<cfoutput>#attributes.ship_deliver#</cfoutput>').value=ship_deliver;
		</cfif>
		<cfif isDefined('attributes.ship_type')>
			window.opener.document.getElementById('<cfoutput>#attributes.ship_type#</cfoutput>').value=ship_type;
		</cfif>
		<cfif isDefined('attributes.ship_adress')>
			window.opener.document.getElementById('<cfoutput>#attributes.ship_adress#</cfoutput>').value=ship_address;
		</cfif>
		window.close();
	}
	function add_mon()
	{
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="project_id'+row_count+'" id="project_id'+row_count+'" value="<cfoutput>#attributes.project_id#</cfoutput>"> <input type="text" name="project_head'+ row_count+'" id="project_head'+ row_count+'" onFocus="autocomp_man('+row_count+');" value="" style="width:160px;" autocomplete="off">';
	}
	function autocomp_man()
	{
		AutoComplete_Create("project_head","project_head","project_head","get_opp","","project_id","","3","130");
	}
	function connectAjax(crtrow,ship_id)
	{
		var bb = '<cfoutput>#request.self#?fuseaction=stock.list_products_from_ship&ship_id=</cfoutput>'+ship_id;
		AjaxPageLoad(bb,'SHIP_DETAIL_INFO'+crtrow,1);
	}
</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'stock.list_packetship';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'stock/display/list_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'stock.popup_add_packetship';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'stock/form/add_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'stock/query/add_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'stock.list_packetship&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'stock.list_packetship';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'stock/form/upd_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'stock/query/upd_packetship.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'stock.list_packetship&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'ship_result_id=##attributes.ship_result_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.ship_result_id##';
	
	WOStruct['#attributes.fuseaction#']['detail'] = structNew();
	WOStruct['#attributes.fuseaction#']['detail']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['detail']['fuseaction'] = 'stock.list_packetship';
	WOStruct['#attributes.fuseaction#']['detail']['filePath'] = 'stock/form/ship_package_detail.cfm';
	WOStruct['#attributes.fuseaction#']['detail']['queryPath'] = 'stock/query/add_ship_package.cfm';
	WOStruct['#attributes.fuseaction#']['detail']['nextEvent'] = 'stock.list_packetship&event=upd';
	
	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=stock.emptypopup_del_packetship&multi_packet_ship=0&ship_result_id=#attributes.ship_result_id#&head=#get_ship_result.ship_fis_no#&is_type=#get_ship_result.is_type#&event=del';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'stock/query/del_packetship.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'stock/query/del_packetship.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'stock.list_packetship';
	}
	
	if(attributes.event is 'upd')
	{				
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		if(get_ship_result.is_type eq 2)
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = "<font color='red'>( * #lang_array.item[372]# )</font> #lang_array_main.item[1966]#";

		}
		else
		{
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		}
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-24' module_id='13' action_section='SHIP_RESULT_ID' action_id='#attributes.ship_result_id#'>";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array_main.item[345]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=#listgetat(attributes.fuseaction,1,'.')#.list_packetship&event=upd&action_name=ship_result_id&action_id=#attributes.ship_result_id#&relation_papers_type=SHIP_RESULT_ID','list')";

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array.item[511]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=stock.list_packetship&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array.item[511]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.ship_result_id#&print_type=32','list')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	if(attributes.event is 'detail')
	{				
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'][0]['text'] = '#lang_array_main.item[61]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['detail']['menus'][0]['onClick'] = "gizle_goster(PACKAGE_LIST_HISTORY);AjaxPageLoad('#request.self#?fuseaction=stock.popup_ajax_ship_package_history&SHIP_ID=#attributes.PROCESS_ID#','PACKAGE_LIST_HISTORY_INFO',1)";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}

	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'stockListPacketship';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'SHIP_RESULT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-deliver_company_id','item-member_name','item-ship_method_id','item-transport_comp_id','item-transport_no1','item-process_stage','item-department_id']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
