<!---
    File: StockActions.cfc
    Author: Gramoni-Mahmut <mahmut.cifci@gramoni.com>
    Date: 05.10.2019
    Description:
        Gönderilen parametreler ile stok hareket fişi kayıt etmek için kullanılan sınıf
        Eklenen belgenin fiş IDsini döndürür
    History:
        
    To Do:
        
    Usage:
        110 Üretimden Çıkış Fişi
        111 Sarf fişi
        112 Fire fişi

        include '../V16/add_options/cfc/StockActions.cfc';

        action_rows             = arrayNew(1);
        action_rows[1]          = structNew();
        action_rows[1].stock_id = 151;
        action_rows[1].amount   = 3;
        action_rows[1].lot_no   = 3312;
        action_rows[2]          = structNew();
        action_rows[2].stock_id = 39;
        action_rows[2].amount   = 1;
        action_rows[2].lot_no   = 3314;

        add_action_id = addStockAction(
            action_type=110, //Belge türü
            process_cat=85, //İşlem kategori ID
            action_date=Now(), //Belge tarihi
            location_in=1, //Giriş lokasyon
            department_in=13, //Giriş depo
            location_out=1, //Çıkış lokasyon
            department_out=13, //Çıkış depo
            employee_id=session.ep.userid, //Teslim alan-İşlemi yapan (Belgeyi kayıt eden değil)
            detail='test stok fişi', //Açıklama
            action_rows=action_rows //Malzeme satırları
        );
--->

<cfcomponent displayname="StockActions" hint="Gönderilen parametreler ile stok hareket fişi kayıt etmek için kullanılan sınıf" output="false">

    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn1="#dsn#_product">
	<cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cfset dsn3="#dsn#_#session.ep.company_id#">
    <cfset dsn_alias = dsn>
    <cfset dsn1_alias = dsn1>
    <cfset dsn2_alias = dsn2>
    <cfset dsn3_alias = dsn3>

    <cffunction name="init" access="public" returntype="any" output="false" hint="constructor">
        <cfreturn this />
    </cffunction>
    
    <cffunction name="addStockAction" access="public" returntype="numeric">
        <cfargument name="action_type" type="numeric" required="true" hint="Stok belgesi işlem türü, 110,111,112 gönderilebilir" />
        <cfargument name="process_cat" type="numeric" required="true" />
        <cfargument name="action_date" type="date" required="false" default="#Now()#" />
        <cfargument name="location_out" type="numeric" required="false" default="-1" />
        <cfargument name="department_out" type="numeric" required="false" default="-1" />
        <cfargument name="location_in" type="numeric" required="false" default="-1" />
        <cfargument name="department_in" type="numeric" required="false" default="-1" />
        <cfargument name="detail" type="string" required="false" default="" />
        <cfargument name="employee_id" type="numeric" required="true" />
        <cfargument name="action_rows" type="array" required="true" hint="Stok fiş satırları array tipinde gönderilmelidir" />

        <cfobject name="fnc" component="WMO.functions">
        <cfobject name="fafnc" component="cfc.fafunctions">
        <cfset muhasebeci = fafnc.muhasebeci>

        <cfscript>
            new_comp_id             = session.ep.company_id;
            new_dsn1_group          = dsn1;
            new_dsn2_group          = dsn2;
            new_dsn3_group          = dsn3;
            new_dsn1_group_alias    = dsn1_alias;
            new_dsn2_group_alias    = dsn2_alias;
            new_dsn3_group_alias    = dsn3_alias;
            new_period_id           = session.ep.period_id;
            attributes.action_type  = arguments.action_type;
            attributes.location_out = arguments.location_out;
            attributes.department_out= arguments.department_out;
            attributes.location_in  = arguments.location_in;
            attributes.department_in= arguments.department_in;
            attributes.detail       = arguments.detail;
        </cfscript>
        
        <cfquery name="get_process_type" datasource="#dsn2#">
            SELECT 
                PROCESS_TYPE,
                PROCESS_CAT_ID,
                IS_CARI,
                IS_ACCOUNT,
                IS_STOCK_ACTION,
                IS_ACCOUNT_GROUP,
                IS_PROJECT_BASED_ACC,
                IS_COST,
                ACTION_FILE_NAME,
                ACTION_FILE_SERVER_ID,
                ACTION_FILE_FROM_TEMPLATE,
                ISNULL(IS_ADD_INVENTORY,0) IS_ADD_INVENTORY,
                ISNULL(IS_DEPT_BASED_ACC,0) IS_DEPT_BASED_ACC
             FROM 
                 #new_dsn3_group_alias#.SETUP_PROCESS_CAT 
            WHERE 
                PROCESS_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_cat#" />
        </cfquery>

        <cf_papers paper_type="STOCK_FIS">
        <cfset system_paper_no = paper_code & '-' & paper_number />
        <cfset system_paper_no_add = paper_number />
        <cfset attributes.fis_no= system_paper_no />

        <cflock name="#CreateUUID()#" timeout="60">
            <cftransaction>

                <cfquery name="add_stock_fis" datasource="#dsn2#">
                    INSERT INTO
                        #new_dsn2_group_alias#.STOCK_FIS
                    (
                        FIS_TYPE,
                        PROCESS_CAT,
                    <cfif listFind('111,112',arguments.action_type)>
                        DEPARTMENT_OUT,
                        LOCATION_OUT,
                    </cfif>
                        FIS_NUMBER,
                    <cfif arguments.action_type Eq 110>
                        DEPARTMENT_IN,
                        LOCATION_IN,
                    </cfif>
                        FIS_DATE,
                        DELIVER_DATE,
                        EMPLOYEE_ID,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP,
                        FIS_DETAIL
                    )
                    OUTPUT INSERTED.FIS_ID
                    VALUES
                    (
                        #arguments.action_type#,
                        #arguments.process_cat#,
                        <cfif listFind('111,112',arguments.action_type)>
                        <cfif arguments.department_out Neq -1>#arguments.department_out#<cfelse>NULL</cfif>,
                        <cfif arguments.location_out Neq -1>#arguments.location_out#<cfelse>NULL</cfif>,						
                        </cfif>
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fis_no#" />,
                        <cfif arguments.action_type Eq 110>
                        <cfif arguments.department_in Neq -1>#arguments.department_in#<cfelse>NULL</cfif>,
                        <cfif arguments.location_in Neq -1>#arguments.location_in#<cfelse>NULL</cfif>,
                        </cfif>
                        #arguments.action_date#,
                        #arguments.action_date#,
                        #arguments.employee_id#,
                        #now()#,
                        #session.ep.userid#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#" />,
                        <cfif Len(arguments.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.detail#" /><cfelse>NULL</cfif>
                    )
                </cfquery>

                <cfloop from="1" to="#arrayLen(arguments.action_rows)#" index="i">
                    <cfquery name="get_unit" datasource="#dsn2#">
                            SELECT
                                PU.MAIN_UNIT,
                                PU.PRODUCT_UNIT_ID,
                                s.PRODUCT_ID
                            FROM
                                #new_dsn3_group_alias#.PRODUCT_UNIT AS PU
                                INNER JOIN #new_dsn1_group_alias#.STOCKS AS s ON s.PRODUCT_ID = PU.PRODUCT_ID
                            WHERE
                                s.STOCK_ID = #arguments.action_rows[i].stock_id#
                                AND PU.IS_MAIN = 1
                                AND PU.PRODUCT_UNIT_STATUS = 1
                    </cfquery>

                    <cfset 'attributes.action_rows#i#.product_id' = get_unit.PRODUCT_ID />
                    <cfset wrk_id_new = 'WRK#round(rand()*65)##dateformat(now(),'YYYYMMDD')##timeformat(now(),'HHmmssL')##session.ep.userid##round(rand()*100)#' />

                    <cfquery name="add_stock_fis_row" datasource="#dsn2#">
                        INSERT INTO
                            #new_dsn2_group_alias#.STOCK_FIS_ROW
                        (
                            FIS_ID,
                            FIS_NUMBER,
                            TOTAL,
                            TOTAL_TAX,
                            NET_TOTAL,
                            STOCK_ID,
                            AMOUNT,
                            UNIT,
                            UNIT_ID,
                            PRICE,
                            TAX,
                            DISCOUNT1,
                            DISCOUNT2,
                            DISCOUNT3,
                            DISCOUNT4,
                            DISCOUNT5,
                            LOT_NO,
                            OTHER_MONEY,
                            PRICE_OTHER,
                            COST_PRICE,
                            EXTRA_COST,
                            AMOUNT2,
                            UNIT2,
                            EXTRA_PRICE,
                            EXTRA_PRICE_TOTAL,
                            DISCOUNT_COST,
                            WRK_ROW_ID
                        )
                        VALUES
                        (
                            #add_stock_fis.FIS_ID#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.fis_no#" />,
                            0,
                            0,
                            0,
                            #arguments.action_rows[i].stock_id#,
                            #arguments.action_rows[i].amount#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_unit.MAIN_UNIT#" />,
                            #get_unit.PRODUCT_UNIT_ID#,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            0,
                            <cfif isdefined('arguments.action_rows#i#.lot_no') and len(arguments.action_rows[i].lot_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.action_rows[i].lot_no#" /><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#" />,
                            0,
                            <cfif isdefined('arguments.action_rows#i#.net_maliyet') and len(arguments.action_rows[i].net_maliyet)>#arguments.action_rows[i].net_maliyet#<cfelse>0</cfif>,
                            0,
                            #arguments.action_rows[i].amount#,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_unit.MAIN_UNIT#" />,
                            0,
                            0,
                            0,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_id_new#" />
                        )
                    </cfquery>

                    <cfquery name="get_product" datasource="#dsn2#">
                        SELECT * FROM #new_dsn1_group_alias#.PRODUCT WHERE PRODUCT_ID = #get_unit.PRODUCT_ID#
                    </cfquery>

                    <cfif get_product.IS_INVENTORY Eq 1 And get_process_type.IS_STOCK_ACTION eq 1>
                        <cfif arguments.action_type Eq 110>
                            <cfquery name="add_stock_row" datasource="#dsn2#">
                                INSERT INTO 
                                    #new_dsn2_group_alias#.STOCKS_ROW
                                (
                                    UPD_ID,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    PROCESS_TYPE,
                                    STOCK_IN,
                                    STORE,
                                    STORE_LOCATION,
                                    PROCESS_DATE,
                                    PROCESS_TIME,
                                    LOT_NO,
                                    DELIVER_DATE,
                                    AMOUNT2,
                                    UNIT2
                                )
                                VALUES
                                (
                                    #add_stock_fis.FIS_ID#,
                                    #get_unit.PRODUCT_ID#,
                                    #arguments.action_rows[i].stock_id#,
                                    #arguments.action_type#,
                                    #arguments.action_rows[i].amount#,
                                    #arguments.department_in#,
                                    #arguments.location_in#,
                                    #arguments.action_date#,
                                    #arguments.action_date#,
                                    <cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#" /><cfelse>NULL</cfif>,
                                    #arguments.action_date#,
                                    #arguments.action_rows[i].amount#,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_unit.MAIN_UNIT#" />
                                )
                            </cfquery>
                        <cfelseif listfind('111,112',arguments.action_type)>
                            <cfquery name="add_stock_row" datasource="#dsn2#">
                                INSERT INTO 
                                    #new_dsn2_group_alias#.STOCKS_ROW
                                (
                                    UPD_ID,
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    PROCESS_TYPE,
                                    STOCK_OUT,
                                    STORE,
                                    STORE_LOCATION,
                                    PROCESS_DATE,
                                    PROCESS_TIME,
                                    LOT_NO,
                                    DELIVER_DATE,
                                    AMOUNT2,
                                    UNIT2
                                )
                                VALUES
                                (
                                    #add_stock_fis.FIS_ID#,
                                    #get_unit.PRODUCT_ID#,
                                    #arguments.action_rows[i].stock_id#,
                                    #arguments.action_type#,
                                    #arguments.action_rows[i].amount#,
                                    #arguments.department_out#,
                                    #arguments.location_out#,
                                    #arguments.action_date#,
                                    #arguments.action_date#,
                                    <cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.lot_no#i#')#" /><cfelse>NULL</cfif>,
                                    #arguments.action_date#,
                                    #arguments.action_rows[i].amount#,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_unit.MAIN_UNIT#" />
                                )
                            </cfquery>
                        </cfif>
                    </cfif>
                </cfloop>

                <cfscript>
                    if (get_process_type.IS_ACCOUNT) {
                        branch_id_in    = '';
                        branch_id_out   = '';
                        if( listfind("111,112",arguments.action_type) ) //sarf ve fire fişi için çıkış depo lokasyon tipi belirleniyor 
                        {
                            location_info = arguments.location_out;
                            department_info = arguments.department_out;
                            if( len(location_info) and len(department_info)) 
                            {
                                LOCATION_OUT= queryExecute("SELECT SL.LOCATION_TYPE,D.BRANCH_ID,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION SL, #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND SL.DEPARTMENT_ID=#department_info# AND SL.LOCATION_ID=#location_info#", {}, {datasource:"#dsn2#"});
                                location_type_out = LOCATION_OUT.LOCATION_TYPE;
                                branch_id_out = LOCATION_OUT.BRANCH_ID;
                                is_scrap_out = LOCATION_OUT.IS_SCRAP;
                            }
                            else
                            {
                                location_type_out ='';
                                is_scrap_out='';
                            }
                        }

                        if(arguments.action_type eq 111)
                            detail = fnc.getLang('main',1831);
                        else if(attributes.action_type eq 112)
                            detail = fnc.getLang('main',1832);
                        else
                            detail = fnc.getLang('main',2701);
                        
                        detail_row = "#detail#" & iif(isDefined("arguments.detail") and Len(arguments.detail),de("-#arguments.detail#"),de(""));

                        str_borclu_hesaplar     = '';
                        str_alacakli_hesaplar   = '';
                        borc_alacak_tutar       = '';
                        str_dovizli_tutarlar    = '';
                        str_doviz_currency      = '';
                        is_project_acc          = 0;
                        acc_project_list_alacak = '';
                        acc_project_list_borc   = '';
                        currency_multiplier     = '';
                        is_project_based_acc    = get_process_type.is_project_based_acc;

                        if(isDefined('attributes.kur_say') and len(attributes.kur_say)){
                            for(mon=1;mon lte attributes.kur_say;mon=mon+1){
                                if(evaluate("attributes.hidden_rd_money_#mon#") is session.ep.money2){
                                    currency_multiplier = evaluate('attributes.txt_rate2_#mon#/attributes.txt_rate1_#mon#');
                                }
                            }
                        }
                        if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))	// proje bazlı muhasebe islemi yapılacaksa
                        {
                            main_product_account_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_CODE_PUR,'' SCRAP_CODE,OVER_COUNT FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #attributes.project_id# AND PERIOD_ID = #session.ep.period_id# ");
                        }
                        if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.project_id_in") and len(attributes.project_id_in) and len(attributes.project_head_in))	// proje bazlı muhasebe islemi yapılacaksa
                        {
                            main_product_account_codes_in=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_CODE_PUR,'' SCRAP_CODE,OVER_COUNT FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #attributes.project_id_in# AND PERIOD_ID = #session.ep.period_id# ");
                        }

                        for(i=1;i lte arrayLen(arguments.action_rows);i=i+1)
                        {
                            if(isdefined('location_type_in') and len(location_type_in)) //giris depo lokasyonu tipi kontrol ediliyor
                            {
                                if(get_process_type.is_dept_based_acc eq 1)
                                {
                                    
                                        dept_id = attributes.department_in;
                                        loc_id  = attributes.location_in;
                                        
                                        product_account_codes = get_product_account(prod_id:evaluate('attributes.action_rows#i#.product_id'),period_id:new_period_id,product_account_db:dsn2,product_alias_db:new_dsn3_group_alias,department_id:dept_id,location_id:loc_id);
                                        if(is_scrap_in eq 1)
                                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.SCRAP_CODE, ",");
                                        else if(location_type_in eq 1) //giriş depo hammadde lokasyon 
                                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.MATERIAL_CODE, ",");		
                                        else if(location_type_in eq 3) //giriş depo mamul lokasyon 
                                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.PRODUCTION_COST, ",");		
                                        else //giriş mal depo 
                                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");	
                                    
                                }
                                else
                                {
                                    dept_id = 0;
                                    loc_id  = 0;
                                    
                                    if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
                                    {
                                        product_account_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_CODE_PUR,'' SCRAP_CODE,OVER_COUNT FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #evaluate("attributes.row_project_id#i#")# AND PERIOD_ID = #session.ep.period_id# ");
                                        is_project_acc=1;
                                    }
                                    else if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
                                    {
                                        product_account_codes=main_product_account_codes;
                                        is_project_acc=1;
                                    }
                                    else
                                        product_account_codes = get_product_account(prod_id:evaluate("attributes.action_rows#i#.product_id"),period_id:new_period_id,product_account_db:dsn2,product_alias_db:new_dsn3_group_alias,department_id:dept_id,location_id:loc_id);
                                    
                                    if(attributes.fis_type eq 111) //sarf fisi 
                                        str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_EXPENDITURE, ",");
                                    else if (attributes.fis_type eq 112) //fire fisi 
                                        str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_LOSS, ",");
                                }
                            }
                            if(isdefined('location_type_out') and len(location_type_out)) //çıkış depo lokasyonu tipi kontrol ediliyor
                            {
                                if(get_process_type.is_dept_based_acc eq 1)
                                {
                                    
                                        dept_id = attributes.department_out;
                                        loc_id  = attributes.location_out;
                                        
                                        product_account_codes = get_product_account(prod_id:evaluate("attributes.action_rows#i#.product_id"),period_id:new_period_id,product_account_db:dsn2,product_alias_db:new_dsn3_group_alias,department_id:dept_id,location_id:loc_id);
                                        if(is_scrap_out eq 1)
                                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.SCRAP_CODE, ",");
                                        else if(location_type_out eq 1) //çıkış depo hammadde lokasyon
                                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.MATERIAL_CODE, ",");
                                        else if(location_type_out eq 3) //çıkış depo mamul lokasyon
                                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.PRODUCTION_COST, ",");
                                        else //giriş mal depo
                                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");
                                }
                                else
                                {
                                    dept_id = 0;
                                    loc_id  = 0;
                                    if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
                                    {
                                        product_account_codes=cfquery(datasource:"#new_dsn2_group#",sqlstring:"SELECT ACCOUNT_EXPENDITURE,ACCOUNT_LOSS,MATERIAL_CODE,PRODUCTION_COST,ACCOUNT_CODE_PUR,'' SCRAP_CODE,OVER_COUNT FROM #dsn3_alias#.PROJECT_PERIOD WHERE PROJECT_ID = #evaluate("attributes.row_project_id#i#")# AND PERIOD_ID = #session.ep.period_id# ");
                                        is_project_acc=1;
                                    }
                                    else if(is_project_based_acc eq 1 and session.ep.our_company_info.project_followup eq 1 and isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
                                    {
                                        product_account_codes=main_product_account_codes;
                                        is_project_acc=1;
                                    }
                                    else
                                        product_account_codes = get_product_account(prod_id:evaluate("attributes.action_rows#i#.product_id"),period_id:new_period_id,product_account_db:dsn2,product_alias_db:new_dsn3_group_alias,department_id:dept_id,location_id:loc_id);
                                        
                                        if(attributes.fis_type eq 111) //sarf fisi 
                                        str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_EXPENDITURE, ",");
                                        else if (attributes.fis_type eq 112) //fire fisi 
                                            str_borclu_hesaplar = ListAppend(str_borclu_hesaplar, product_account_codes.ACCOUNT_LOSS, ",");
                                }
                                if(is_project_acc eq 1 and isdefined("main_product_account_codes"))
                                {
                                    if(location_type_out eq 1) //cikis depo hammadde lokasyon 
                                        str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, main_product_account_codes.MATERIAL_CODE, ",");		
                                    else if(location_type_out eq 3) //cikis depo mamul lokasyon 
                                        str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, main_product_account_codes.PRODUCTION_COST, ",");		
                                    else //cikis depo mal lokasyon 
                                        str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, main_product_account_codes.ACCOUNT_CODE_PUR, ",");		
                                }
                                else
                                {
                                    if(is_scrap_out eq 1)
                                        str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.SCRAP_CODE, ",");
                                    else if(location_type_out eq 1) //cikis depo hammadde lokasyon 
                                        str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.MATERIAL_CODE, ",");		
                                    else if(location_type_out eq 3) //cikis depo mamul lokasyon 
                                        str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.PRODUCTION_COST, ",");		
                                    else //cikis depo mal lokasyon 
                                        str_alacakli_hesaplar = ListAppend(str_alacakli_hesaplar, product_account_codes.ACCOUNT_CODE_PUR, ",");	
                                        
                                }		
                            }
                            else
                            {
                                dept_id = 0;
                                loc_id  = 0;	
                            }

                            if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
                                acc_project_list_borc = ListAppend(acc_project_list_borc,evaluate("attributes.row_project_id#i#"),",");
                            else if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
                                acc_project_list_borc = ListAppend(acc_project_list_borc,attributes.project_id,",");
                            else
                                acc_project_list_borc = ListAppend(acc_project_list_borc,0,",");

                            if(isdefined("attributes.row_project_id#i#") and len(evaluate("attributes.row_project_id#i#")) and len(evaluate("attributes.row_project_name#i#")))
                                acc_project_list_alacak = ListAppend(acc_project_list_alacak,evaluate("attributes.row_project_id#i#"),",");
                            else if(isdefined("attributes.project_id") and len(attributes.project_id) and len(attributes.project_head))
                                acc_project_list_alacak = ListAppend(acc_project_list_alacak,attributes.project_id,",");
                            else
                                acc_project_list_alacak = ListAppend(acc_project_list_alacak,0,",");
                            if(isdefined("attributes.x_cost_acc") and attributes.x_cost_acc eq 1)
                            {
                                if(not len(evaluate("attributes.extra_cost#i#"))) "attributes.extra_cost#i#" = 0;
                                if(not len(evaluate("attributes.net_maliyet#i#"))) "attributes.net_maliyet#i#" = 0;
                                borc_alacak_tutar = ListAppend(borc_alacak_tutar, wrk_round(evaluate("attributes.amount#i#")*(evaluate("attributes.net_maliyet#i#")+evaluate("attributes.extra_cost#i#"))), ",");
                                str_dovizli_tutarlar = ListAppend(str_dovizli_tutarlar,wrk_round(evaluate("attributes.amount#i#")*(evaluate("attributes.net_maliyet#i#")+evaluate("attributes.extra_cost#i#"))),",");
                                str_doviz_currency = ListAppend(str_doviz_currency,session.ep.money,",");
                            }
                            /* else
                            {
                                borc_alacak_tutar = ListAppend(borc_alacak_tutar, wrk_round(evaluate("attributes.row_nettotal#i#")), ",");
                                if(isdefined("attributes.other_money_#i#") and  isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#")) )
                                {
                                    str_dovizli_tutarlar = ListAppend(str_dovizli_tutarlar,wrk_round(evaluate("attributes.other_money_value_#i#")),",");
                                    str_doviz_currency = ListAppend(str_doviz_currency,evaluate("attributes.other_money_#i#"),",");
                                }
                            } */
                        }

                        muhasebeci(
                            action_id               : add_stock_fis.FIS_ID,
                            workcube_process_type   : attributes.action_type,
                            workcube_process_cat    : arguments.process_cat,
                            muhasebe_db_alias       : new_dsn2_group_alias,
                            account_card_type       : 13,
                            islem_tarihi            : arguments.action_date,
                            borc_hesaplar           : str_borclu_hesaplar,
                            borc_tutarlar           : borc_alacak_tutar,
                            other_amount_borc       : str_dovizli_tutarlar,
                            other_currency_borc     : str_doviz_currency,
                            alacak_hesaplar         : str_alacakli_hesaplar,
                            alacak_tutarlar         : borc_alacak_tutar,
                            other_amount_alacak     : str_dovizli_tutarlar,
                            other_currency_alacak   : str_doviz_currency,
                            from_branch_id          : branch_id_out,
                            to_branch_id            : branch_id_in,
                            fis_detay               : detail,
                            fis_satir_detay         : detail_row,
                            belge_no                : attributes.fis_no,
                            is_account_group        : get_process_type.is_account_group,
                            currency_multiplier     : currency_multiplier,
                            acc_project_list_alacak : acc_project_list_alacak,
                            acc_project_list_borc   : acc_project_list_borc
                        );
                    }

                    if (get_process_type.IS_COST) {
                        //cost_action(action_type:3,action_id:add_stock_fis.FIS_ID,query_type:1)
                    }
                </cfscript>

                <cf_workcube_process_cat 
                    process_cat="#arguments.process_cat#"
                    action_id = "#add_stock_fis.FIS_ID#"
                    action_table="STOCK_FIS"
                    action_column="FIS_ID"
                    is_action_file = 1
                    action_page='#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=#add_stock_fis.FIS_ID#'
                    action_file_name='#get_process_type.action_file_name#'
                    action_db_type = '#dsn2#'
                    is_template_action_file = '#get_process_type.action_file_from_template#'>

                <cf_add_log employee_id="#session.ep.userid#" log_type="1" action_id="#add_stock_fis.FIS_ID#" action_name="#attributes.fis_no# Eklendi" paper_no="#attributes.fis_no#"  period_id="#session.ep.period_id#" process_type="#get_process_type.PROCESS_TYPE#" data_source="#dsn2#">

            </cftransaction>
        </cflock>

        <cfquery name="UPD_GEN_PAP" datasource="#DSN3#">
            UPDATE 
                GENERAL_PAPERS
            SET
                STOCK_FIS_NUMBER = #system_paper_no_add#
            WHERE
                STOCK_FIS_NUMBER IS NOT NULL
        </cfquery>

        <cfreturn add_stock_fis.FIS_ID />
    </cffunction>

</cfcomponent>