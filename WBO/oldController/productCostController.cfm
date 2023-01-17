<cf_get_lang_set module_name="product">
<!--- action sayfalarda bulunan kontroller burada kontrol ediliyor --->
<cfif isdefined('attributes.formSubmittedController') and attributes.formSubmittedController eq 1 and isdefined('attributes.event') and listFind('add,upd,det',attributes.event)>
	<!--- Subeye Ait Fiyat Listesinin kontrolu --->
	<cfif IsDefined("attributes.event") and ListFindNoCase("add,upd,addcostsuggest",attributes.event)>
        <cfif FORM.ACTION_PERIOD_ID neq session.ep.period_id>
            <script type="text/javascript">
                alertObject({message: "<cf_get_lang no ='886.Döneminiz uygun değil ! Kayıt yapamazsınız'>..."});
            </script>
            <cfabort>
        </cfif>
        <cfif session.ep.isBranchAuthorization><!--- store maliyeti ise mevcut genel maliyet alınır ve o degismemesi için kaydedilir --->
            <cfquery name="GET_GENERAL_COST" datasource="#DSN3#">
                SELECT
                    START_DATE,
                    COST_TYPE_ID,
                    PRODUCT_COST,
                    MONEY,
                    STANDARD_COST,
                    STANDARD_COST_MONEY,
                    STANDARD_COST_RATE,
                    PURCHASE_NET,
                    PURCHASE_NET_MONEY,
                    PURCHASE_EXTRA_COST,
                    PRICE_PROTECTION,
                    PRICE_PROTECTION_MONEY,
                    PURCHASE_NET_SYSTEM,
                    PURCHASE_NET_SYSTEM_MONEY,
                    PURCHASE_EXTRA_COST_SYSTEM,
                    PRODUCT_COST_SYSTEM,
                    PURCHASE_NET_SYSTEM_2,
                    PURCHASE_NET_SYSTEM_MONEY_2,
                    PURCHASE_EXTRA_COST_SYSTEM_2,
                    AVAILABLE_STOCK,
                    PARTNER_STOCK,
                    ACTIVE_STOCK,
                    IS_STANDARD_COST,
                    IS_ACTIVE_STOCK,
                    IS_PARTNER_STOCK,
                    DUE_DATE,
                    PHYSICAL_DATE,
                    DUE_DATE_LOCATION,
                    PHYSICAL_DATE_LOCATION
                FROM
                    PRODUCT_COST
                WHERE
                    PRODUCT_ID=#attributes.product_id#
                    AND ACTION_PERIOD_ID = #session.ep.period_id#
                    AND START_DATE <= #attributes.start_date#
                    <cfif len(attributes.spect_main_id)>
                        AND SPECT_MAIN_ID=#attributes.spect_main_id#
                    <cfelse>
                        AND IS_SPEC=0
                    </cfif>
                ORDER BY 
                    START_DATE DESC,
                    RECORD_DATE DESC
            </cfquery>
            <cfif not GET_GENERAL_COST.RECORDCOUNT>
                <script type="text/javascript">
                    alertObject({message: "<cf_get_lang no ='887.Şube lokasyon maliyeti ekleyebilmek için genel maliyet kaydının olması gerekmektedir'>!"});
                </script>
                <cfabort>
            </cfif>
        </cfif>
    <cfelseif isdefined("attributes.event") and attributes.event is 'del'>
    	<!--- bu maliyete daha once bir fiyat koruma yapilmis mi --->
        <cfquery name="GET_COMPARISON" datasource="#dsn1#">
            SELECT
                CONTRACT_COMPARISON_ROW_ID,
                COMPANY_ID,
                DIFF_INVOICE_ID
            FROM
                #dsn2_alias#.INVOICE_CONTRACT_COMPARISON
            WHERE
                COST_ID=#attributes.cost_id#
        </cfquery>
        <cfif GET_COMPARISON.RECORDCOUNT>
            <script type="text/javascript">
                 alertObject({message: "<cf_get_lang no ='893.Fiyat Koruma Girilmiş Maliyeti Silemezsiniz! Öncelikle Fiyat Korumalarını Siliniz'>!"});
            </script>
            <cfabort>
        </cfif>
    </cfif>
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfparam name="attributes.cat" default="">
    <cfparam name="attributes.brand_id" default="">
    <cfparam name="attributes.brand_name" default="">
    <cfparam name="attributes.keyword" default="">
    <cfif session.ep.our_company_info.unconditional_list>
      <cfif isdefined("attributes.is_form_submitted")>
        <cfscript>
            get_product_cost_action = createObject("component", "product.cfc.get_product_cost");
            get_product_cost_action.dsn3 = dsn3;
            get_product_cost_action.dsn2 = dsn2;
            get_product_cost_action.dsn3_alias = dsn3_alias;
            get_product_cost_action.dsn_alias = dsn_alias;
            get_product_cost = get_product_cost_action.get_product_cost_fnc(
                module_name : '#fusebox.circuit#',
                product_status : '#iif(isdefined("attributes.product_status"),"attributes.product_status",DE(""))#',
                product_types : '#iif(isdefined("attributes.product_types"),"attributes.product_types",DE(""))#',
                pos_code : '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#',
                company_id : '#iif(isdefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                brand_id : '#iif(isdefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
                brand_name : '#iif(isdefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
                cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
                keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                special_code : '#iif(isdefined("attributes.special_code"),"attributes.special_code",DE(""))#',
                inventory_calc_type : '#iif(isdefined("attributes.inventory_calc_type"),"attributes.inventory_calc_type",DE(""))#'
            );
        </cfscript>
        <cfset arama_yapilmali=0>
      <cfelse>
        <cfset get_product_cost.recordcount=0>
        <cfset arama_yapilmali=1>
      </cfif>
    <cfelse>
      <cfif isdefined("attributes.is_form_submitted") and 
        (
            (isdefined("attributes.keyword") and len(attributes.keyword)) or 
            (isdefined("attributes.cat") and len(attributes.cat)) or
            (isdefined("attributes.inventory_calc_type") and len(attributes.inventory_calc_type)) or 
            (isdefined("attributes.brand_id") and len(attributes.brand_id) and isdefined("attributes.brand_name") and len(attributes.brand_name)) or 
            (isdefined("attributes.pos_code") and len(attributes.pos_code) and isdefined("attributes.pos_manager") and len(attributes.pos_manager)) or 
            (isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company))
        )>
        <cfscript>
            get_product_cost_action = createObject("component", "product.cfc.get_product_cost");
            get_product_cost_action.dsn3 = dsn3;
            get_product_cost_action.dsn2 = dsn2;
            get_product_cost_action.dsn3_alias = dsn3_alias;
            get_product_cost_action.dsn_alias = dsn_alias;
            get_product_cost = get_product_cost_action.get_product_cost_fnc(
                module_name : '#fusebox.circuit#',
                product_status : '#iif(isdefined("attributes.product_status"),"attributes.product_status",DE(""))#',
                product_types : '#iif(isdefined("attributes.product_types"),"attributes.product_types",DE(""))#',
                pos_code : '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#',
                company_id : '#iif(isdefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                brand_id : '#iif(isdefined("attributes.brand_id"),"attributes.brand_id",DE(""))#',
                brand_name : '#iif(isdefined("attributes.brand_name"),"attributes.brand_name",DE(""))#',
                cat : '#iif(isdefined("attributes.cat"),"attributes.cat",DE(""))#',
                keyword : '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#',
                special_code : '#iif(isdefined("attributes.special_code"),"attributes.special_code",DE(""))#',
                inventory_calc_type : '#iif(isdefined("attributes.inventory_calc_type"),"attributes.inventory_calc_type",DE(""))#'
            );
        </cfscript>
        <cfset arama_yapilmali=0>
      <cfelse>
        <cfset get_product_cost.recordcount=0>
        <cfset arama_yapilmali=1>
      </cfif>
    </cfif>
    <cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
        SELECT 
            COMPETITIVE_ID
        FROM
            PRODUCT_COMP_PERM 
        WHERE 
            POSITION_CODE = #session.ep.position_code#
    </cfquery>
    <cfset COMPETITIVE_LIST = ValueList(get_competitive_list.competitive_id)>
    <cfinclude template="../product/query/get_price_cat.cfm">
    <cfparam name="attributes.page" default=1>
    <cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
      <cfset attributes.maxrows = session.ep.maxrows>
    </cfif>
    <cfparam name="attributes.totalrecords" default='#get_product_cost.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfinclude template="../product/query/get_product_cat.cfm">
    <cfquery name="get_periods" datasource="#dsn#">
        SELECT 
            INVENTORY_CALC_TYPE	 
        FROM 
            SETUP_PERIOD
        WHERE
            PERIOD_ID = #session.ep.period_id#
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'costdetail'>
    <cf_xml_page_edit fuseact="product.form_add_product_cost">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.graph_type" default="">
    <cfparam name="attributes.start_date" default="">
    <cfparam name="attributes.finish_date" default="">
    <!--- Tarih Filitresindeki Verilerin gg/aa/yyyy şeklinde gelmesi için kullanıldı.Created by MCP 20130917 --->
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih="attributes.start_date">
    <cfelse>
        <cfparam name="attributes.start_date" default="">
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
        <cf_date tarih="attributes.finish_date">
    <cfelse>
        <cfparam name="attributes.finish_date" default="">
    </cfif>
    <!--- Sayfalamada, Filitrede seçilen verilerini diğer sayfaya aktarması için kullanıldı.Created by MCP 20130917 --->
    <cfset adres = url.fuseaction>
    <cfset adres = "#adres#&product.popup_list_product_cost_detail&pid=#attributes.pid#&department_id=#attributes.department_id#&graph_type=#attributes.graph_type#">
    <cfinclude template="../stock/query/get_stores.cfm">
    <cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
        SELECT DEPARTMENT_ID, LOCATION_ID, COMMENT, STATUS FROM STOCKS_LOCATION ORDER BY COMMENT
    </cfquery>
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
    <cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
    <cfif not session.ep.isBranchAuthorization>
        <cfquery name="GET_PRODUCT_COST" datasource="#DSN3#">
            SELECT 
                (SELECT S.STOCK_CODE FROM STOCKS S WHERE S.STOCK_ID = PRODUCT_COST.STOCK_ID) STOCK_CODE,
                ACTION_PERIOD_ID,
                ACTION_TYPE,
                ACTION_PROCESS_TYPE,
                ACTION_ID,
                ACTION_ROW_ID,
                PRODUCT_COST_ID,
                ISNULL(STANDARD_COST_LOCATION,0) STANDARD_COST_LOCATION,
                ISNULL(STANDARD_COST_MONEY_LOCATION,0) STANDARD_COST_MONEY_LOCATION,
                ISNULL(STANDARD_COST,0) STANDARD_COST,
                ISNULL(STANDARD_COST_MONEY,0) STANDARD_COST_MONEY,
                ISNULL(STANDARD_COST_RATE,0) STANDARD_COST_RATE,
                ISNULL(STANDARD_COST_RATE_LOCATION,0) STANDARD_COST_RATE_LOCATION,
                ISNULL(PRICE_PROTECTION,0) PRICE_PROTECTION,
                ISNULL(PRICE_PROTECTION_LOCATION,0) PRICE_PROTECTION_LOCATION,
                ISNULL(PRICE_PROTECTION_MONEY,0) PRICE_PROTECTION_MONEY,
                ISNULL(PRICE_PROTECTION_MONEY_LOCATION,0) PRICE_PROTECTION_MONEY_LOCATION,
                ISNULL(SPECT_MAIN_ID,0) SPECT_MAIN_ID,
                START_DATE,
                MONTH(START_DATE) MONTH_START_DATE,
                ISNULL(PURCHASE_NET,0) PURCHASE_NET,
                ISNULL(PURCHASE_NET_LOCATION,0) PURCHASE_NET_LOCATION,
                ISNULL(PURCHASE_NET_MONEY,0) PURCHASE_NET_MONEY,
                ISNULL(PURCHASE_NET_MONEY_LOCATION,0) PURCHASE_NET_MONEY_LOCATION,
                ISNULL(PURCHASE_EXTRA_COST,0) PURCHASE_EXTRA_COST,
                ISNULL(PURCHASE_EXTRA_COST_LOCATION,0) PURCHASE_EXTRA_COST_LOCATION,
                ISNULL(PRODUCT_COST,0) PRODUCT_COST,
                ISNULL(PRODUCT_COST_LOCATION,0) PRODUCT_COST_LOCATION,
                MONEY,
                MONEY_LOCATION,
                ISNULL(PURCHASE_NET_SYSTEM,0) AS PURCHASE_NET_SYSTEM,
                ISNULL(PURCHASE_NET_SYSTEM_LOCATION,0) PURCHASE_NET_SYSTEM_LOCATION,
                ISNULL(PURCHASE_NET_SYSTEM_MONEY,0) PURCHASE_NET_SYSTEM_MONEY,
                ISNULL(PURCHASE_NET_SYSTEM_MONEY_LOCATION,0) PURCHASE_NET_SYSTEM_MONEY_LOCATION,
                ISNULL(PURCHASE_EXTRA_COST_SYSTEM,0) PURCHASE_EXTRA_COST_SYSTEM,
                ISNULL(PURCHASE_EXTRA_COST_SYSTEM_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
                ISNULL(PURCHASE_NET_SYSTEM_2,0) PURCHASE_NET_SYSTEM_2,
                ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION,0) PURCHASE_NET_SYSTEM_2_LOCATION,
                ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,
                ISNULL(PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
                AVAILABLE_STOCK,
                AVAILABLE_STOCK_LOCATION,
                PARTNER_STOCK,
                PARTNER_STOCK_LOCATION,
                ACTIVE_STOCK,
                ACTIVE_STOCK_LOCATION,
                DUE_DATE,
                DUE_DATE_LOCATION,
                PHYSICAL_DATE,
                PHYSICAL_DATE_LOCATION,
                PRODUCT_ID,
                '' DEPARTMENT,
                ISNULL(PURCHASE_NET_ALL,0) PURCHASE_NET_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_ALL,0) PURCHASE_NET_SYSTEM_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_2_ALL,0) PURCHASE_NET_SYSTEM_2_ALL,
                ISNULL(PURCHASE_NET_LOCATION_ALL,0) PURCHASE_NET_LOCATION_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_LOCATION_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_2_LOCATION_ALL,
                PRODUCT_COST.INVENTORY_CALC_TYPE
            FROM 
                PRODUCT_COST 
            WHERE 
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
                <cfif isdefined('attributes.location')>
                    AND DEPARTMENT_ID IS NULL
                </cfif>
                <cfif isdefined("attributes.department_id") and len(attributes.department_id)>
                    AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.department_id,1,'-')#">
                    <cfif listlen(attributes.department_id,'-') eq 2>
                        AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.department_id,2,'-')#">
                    </cfif>
                </cfif>
                <cfif isdefined('attributes.start_date') and len(attributes.start_date)>
                AND PRODUCT_COST.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"><!---#attributes.start_date#--->
                </cfif>
                <cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
                AND PRODUCT_COST.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"><!---#attributes.finish_date#--->
                </cfif>
            <cfif isdefined('attributes.location')>
            UNION
                SELECT 
                    (SELECT S.STOCK_CODE FROM STOCKS S WHERE S.STOCK_ID = PC.STOCK_ID) STOCK_CODE,
                    PC.ACTION_PERIOD_ID,
                    PC.ACTION_TYPE,
                    PC.ACTION_PROCESS_TYPE,
                    PC.ACTION_ID,
                    PC.ACTION_ROW_ID,
                    PC.PRODUCT_COST_ID,
                    ISNULL(PC.STANDARD_COST_LOCATION,0) STANDARD_COST_LOCATION,
                    ISNULL(PC.STANDARD_COST_MONEY_LOCATION,0) STANDARD_COST_MONEY_LOCATION,
                    ISNULL(PC.STANDARD_COST,0) STANDARD_COST,
                    ISNULL(PC.STANDARD_COST_MONEY,0) STANDARD_COST_MONEY,
                    ISNULL(PC.STANDARD_COST_RATE,0) STANDARD_COST_RATE,
                    ISNULL(PC.STANDARD_COST_RATE_LOCATION,0) STANDARD_COST_RATE_LOCATION,
                    ISNULL(PC.PRICE_PROTECTION,0) PRICE_PROTECTION,
                    ISNULL(PC.PRICE_PROTECTION_LOCATION,0) PRICE_PROTECTION_LOCATION,
                    ISNULL(PC.PRICE_PROTECTION_MONEY,0) PRICE_PROTECTION_MONEY,
                    ISNULL(PC.PRICE_PROTECTION_MONEY_LOCATION,0) PRICE_PROTECTION_MONEY_LOCATION,
                    ISNULL(PC.SPECT_MAIN_ID,0) SPECT_MAIN_ID,
                    PC.START_DATE,
                    MONTH(START_DATE) MONTH_START_DATE,
                    ISNULL(PC.PURCHASE_NET,0) PURCHASE_NET,
                    ISNULL(PC.PURCHASE_NET_LOCATION,0) PURCHASE_NET_LOCATION,
                    ISNULL(PC.PURCHASE_NET_MONEY,0) PURCHASE_NET_MONEY,
                    ISNULL(PC.PURCHASE_NET_MONEY_LOCATION,0) PURCHASE_NET_MONEY_LOCATION,
                    ISNULL(PC.PURCHASE_EXTRA_COST,0) PURCHASE_EXTRA_COST,
                    ISNULL(PC.PURCHASE_EXTRA_COST_LOCATION,0) PURCHASE_EXTRA_COST_LOCATION,
                    ISNULL(PC.PRODUCT_COST,0) PRODUCT_COST,
                    ISNULL(PC.PRODUCT_COST_LOCATION,0) PRODUCT_COST_LOCATION,
                    PC.MONEY,
                    PC.MONEY_LOCATION,
                    ISNULL(PC.PURCHASE_NET_SYSTEM,0) PURCHASE_NET_SYSTEM,
                    ISNULL(PC.PURCHASE_NET_SYSTEM_LOCATION,0) PURCHASE_NET_SYSTEM_LOCATION,
                    ISNULL(PC.PURCHASE_NET_SYSTEM_MONEY,0) PURCHASE_NET_SYSTEM_MONEY,
                    ISNULL(PC.PURCHASE_NET_SYSTEM_MONEY_LOCATION,0) PURCHASE_NET_SYSTEM_MONEY_LOCATION,
                    ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM,0) PURCHASE_EXTRA_COST_SYSTEM,
                    ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
                    ISNULL(PC.PURCHASE_NET_SYSTEM_2,0) PURCHASE_NET_SYSTEM_2,
                    ISNULL(PC.PURCHASE_NET_SYSTEM_2_LOCATION,0) PURCHASE_NET_SYSTEM_2_LOCATION,
                    ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,
                    ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
                    PC.AVAILABLE_STOCK,
                    PC.AVAILABLE_STOCK_LOCATION,
                    PC.PARTNER_STOCK,
                    PC.PARTNER_STOCK_LOCATION,
                    PC.ACTIVE_STOCK,
                    PC.ACTIVE_STOCK_LOCATION,
                    PC.DUE_DATE,
                    PC.DUE_DATE_LOCATION,
                    PC.PHYSICAL_DATE,
                    PC.PHYSICAL_DATE_LOCATION,
                    PC.PRODUCT_ID,
                    DEPARTMENT_HEAD
                    <cfif database_type is 'MSSQL'>+'-'+<cfelseif database_type is 'DB2'> ||'-'||</cfif> SL.COMMENT AS DEPARTMENT,
                    ISNULL(PURCHASE_NET_ALL,0) PURCHASE_NET_ALL,
                    ISNULL(PURCHASE_NET_SYSTEM_ALL,0) PURCHASE_NET_SYSTEM_ALL,
                    ISNULL(PURCHASE_NET_SYSTEM_2_ALL,0) PURCHASE_NET_SYSTEM_2_ALL,
                    ISNULL(PURCHASE_NET_LOCATION_ALL,0) PURCHASE_NET_LOCATION_ALL,
                    ISNULL(PURCHASE_NET_SYSTEM_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_LOCATION_ALL,
                    ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_2_LOCATION_ALL,
                    PC.INVENTORY_CALC_TYPE
                FROM 
                    PRODUCT_COST PC,
                    #DSN_ALIAS#.STOCKS_LOCATION SL,
                    #DSN_ALIAS#.DEPARTMENT D
                WHERE 
                    PC.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
                    AND PC.ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    AND SL.LOCATION_ID = PC.LOCATION_ID
                    AND SL.DEPARTMENT_ID = PC.DEPARTMENT_ID
                    AND D.DEPARTMENT_ID = SL.DEPARTMENT_ID
            </cfif>
            ORDER BY 
                START_DATE DESC,
                RECORD_DATE DESC,
                PRODUCT_COST_ID DESC
        </cfquery>
    <cfelse>
        <cfquery name="GET_PRODUCT_COST" datasource="#DSN3#">
            SELECT 
                (SELECT S.STOCK_CODE FROM STOCKS S WHERE S.STOCK_ID = PC.STOCK_ID) STOCK_CODE,
                PC.ACTION_PERIOD_ID,
                PC.ACTION_TYPE,
                PC.ACTION_PROCESS_TYPE,
                PC.ACTION_ID,
                PC.ACTION_ROW_ID,
                PC.PRODUCT_COST_ID,
                ISNULL(PC.STANDARD_COST_LOCATION,0) STANDARD_COST_LOCATION,
                ISNULL(PC.STANDARD_COST_MONEY_LOCATION,0) STANDARD_COST_MONEY_LOCATION,
                ISNULL(PC.STANDARD_COST,0) STANDARD_COST,
                ISNULL(PC.STANDARD_COST_MONEY,0) STANDARD_COST_MONEY,
                ISNULL(PC.STANDARD_COST_RATE,0) STANDARD_COST_RATE,
                ISNULL(PC.STANDARD_COST_RATE_LOCATION,0) STANDARD_COST_RATE_LOCATION,
                ISNULL(PC.PRICE_PROTECTION,0) PRICE_PROTECTION,
                ISNULL(PC.PRICE_PROTECTION_LOCATION,0) PRICE_PROTECTION_LOCATION,
                ISNULL(PC.PRICE_PROTECTION_MONEY,0) PRICE_PROTECTION_MONEY,
                ISNULL(PC.PRICE_PROTECTION_MONEY_LOCATION,0) PRICE_PROTECTION_MONEY_LOCATION,
                ISNULL(PC.SPECT_MAIN_ID,0) SPECT_MAIN_ID,
                PC.START_DATE,
                MONTH(PC.START_DATE) MONTH_START_DATE,
                ISNULL(PC.PURCHASE_NET,0) PURCHASE_NET,
                ISNULL(PC.PURCHASE_NET_LOCATION,0) PURCHASE_NET_LOCATION,
                ISNULL(PC.PURCHASE_NET_MONEY,0) PURCHASE_NET_MONEY,
                ISNULL(PC.PURCHASE_NET_MONEY_LOCATION,0) PURCHASE_NET_MONEY_LOCATION,
                ISNULL(PC.PURCHASE_EXTRA_COST,0) PURCHASE_EXTRA_COST,
                ISNULL(PC.PURCHASE_EXTRA_COST_LOCATION,0) PURCHASE_EXTRA_COST_LOCATION,
                ISNULL(PC.PRODUCT_COST,0) PRODUCT_COST,
                ISNULL(PC.PRODUCT_COST_LOCATION,0) PRODUCT_COST_LOCATION,
                PC.MONEY,
                PC.MONEY_LOCATION,
                ISNULL(PC.PURCHASE_NET_SYSTEM,0) PURCHASE_NET_SYSTEM,
                ISNULL(PC.PURCHASE_NET_SYSTEM_LOCATION,0) PURCHASE_NET_SYSTEM_LOCATION,
                ISNULL(PC.PURCHASE_NET_SYSTEM_MONEY,0) PURCHASE_NET_SYSTEM_MONEY,
                ISNULL(PC.PURCHASE_NET_SYSTEM_MONEY_LOCATION,0) PURCHASE_NET_SYSTEM_MONEY_LOCATION,
                ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM,0) PURCHASE_EXTRA_COST_SYSTEM,
                ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_LOCATION,
                ISNULL(PC.PURCHASE_NET_SYSTEM_2,0) PURCHASE_NET_SYSTEM_2,
                ISNULL(PC.PURCHASE_NET_SYSTEM_2_LOCATION,0) PURCHASE_NET_SYSTEM_2_LOCATION,
                ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM_2,0) PURCHASE_EXTRA_COST_SYSTEM_2,
                ISNULL(PC.PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,0) PURCHASE_EXTRA_COST_SYSTEM_2_LOCATION,
                PC.AVAILABLE_STOCK,
                PC.AVAILABLE_STOCK_LOCATION,
                PC.PARTNER_STOCK,
                PC.PARTNER_STOCK_LOCATION,
                PC.ACTIVE_STOCK,
                PC.ACTIVE_STOCK_LOCATION,
                PC.DUE_DATE,
                PC.DUE_DATE_LOCATION,
                PC.PHYSICAL_DATE,
                PC.PHYSICAL_DATE_LOCATION,
                PC.PRODUCT_ID,
                DEPARTMENT_HEAD
                <cfif database_type is 'MSSQL'>+'-'+<cfelseif database_type is 'DB2'>||'-'||</cfif> SL.COMMENT AS DEPARTMENT,
                ISNULL(PURCHASE_NET_ALL,0) PURCHASE_NET_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_ALL,0) PURCHASE_NET_SYSTEM_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_2_ALL,0) PURCHASE_NET_SYSTEM_2_ALL,
                ISNULL(PURCHASE_NET_LOCATION_ALL,0 PURCHASE_NET_LOCATION_ALL),
                ISNULL(PURCHASE_NET_SYSTEM_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_LOCATION_ALL,
                ISNULL(PURCHASE_NET_SYSTEM_2_LOCATION_ALL,0) PURCHASE_NET_SYSTEM_2_LOCATION_ALL,
                PC.INVENTORY_CALC_TYPE
            FROM 
                PRODUCT_COST PC,
                #DSN_ALIAS#.STOCKS_LOCATION SL,
                #DSN_ALIAS#.DEPARTMENT D
            WHERE 
                PC.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
                AND SL.LOCATION_ID = PC.LOCATION_ID
                AND SL.DEPARTMENT_ID = PC.DEPARTMENT_ID
                AND D.DEPARTMENT_ID = SL.DEPARTMENT_ID
                <cfif isdefined('attributes.location')>
                AND PC.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,'-')#">)
                </cfif>
            ORDER BY 
                START_DATE DESC,
                RECORD_DATE DESC,
                PRODUCT_COST_ID DESC
        </cfquery>
    </cfif>
    <cfquery name="get_product" datasource="#dsn3#"><!--- Burada ürün ismi ve calc_type getiriliyor --->
        SELECT 
            PRODUCT_NAME,
            IS_PRODUCTION,
            PRODUCT_CODE
        FROM 
            PRODUCT 
        WHERE 
            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
    </cfquery>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default="#get_product_cost.recordcount#">
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif get_product_cost.recordcount and Len(attributes.graph_type)>
    	<cfif attributes.graph_type eq 0>
        	<cfquery name="get_price_standart" datasource="#dsn3#">
                SELECT
                    MONTH(START_DATE) MONTH_START_DATE,
                    PRICE PRODUCT_COST,
                    0 SPECT_MAIN_ID
                FROM
                    PRICE_STANDART
                WHERE
                    PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
                    AND PURCHASESALES = 0
            </cfquery>
            <cfquery name="get_last_product_cost" dbtype="query">
                SELECT
                    MONTH_START_DATE,
                    START_DATE,
                    PRODUCT_COST,
                    SPECT_MAIN_ID
                FROM 
                    GET_PRODUCT_COST 
                WHERE 
                    ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                GROUP BY
                    MONTH_START_DATE,
                    PRODUCT_COST,
                    SPECT_MAIN_ID,
                    START_DATE
                ORDER BY
                    SPECT_MAIN_ID,
                    START_DATE
            </cfquery>
        <cfelse>
        <cfquery name="get_price_standart" datasource="#dsn3#">
            SELECT
                START_DATE,
                PRICE PRODUCT_COST,
                0 SPECT_MAIN_ID
            FROM
                PRICE_STANDART
            WHERE
                PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
                AND PURCHASESALES = 0
        </cfquery>
        <cfquery name="get_last_product_cost" dbtype="query">
            SELECT
                START_DATE,
                PRODUCT_COST,
                SPECT_MAIN_ID
            FROM 
                GET_PRODUCT_COST 
            WHERE 
                ACTION_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
            GROUP BY
                START_DATE,
                PRODUCT_COST,
                SPECT_MAIN_ID
            ORDER BY
                SPECT_MAIN_ID
        </cfquery>
        </cfif>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cf_xml_page_edit fuseact="product.form_add_product_cost">
    <cfquery name="get_periods" datasource="#dsn#">
        SELECT 
            INVENTORY_CALC_TYPE	 
        FROM 
            SETUP_PERIOD
        WHERE
            PERIOD_ID = #session.ep.period_id#
    </cfquery>
    
    <!--- Maliyet Önerileri --->
    <cfquery name="GET_PRODUCT_COST_SUGGESTION" DATASOURCE="#DSN1#" MAXROWS="5"><!---Ürün tutarları ve para birimi  --->
        SELECT 
            *
        FROM 
            PRODUCT_COST_SUGGESTION
        WHERE 
            COST_SUGGESTION_STATUS = 0 AND 
            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
        ORDER BY 
            START_DATE DESC,
            RECORD_DATE DESC
    </cfquery>
    <!--- Süreç'e yetkisi yoksa önerilerini maliye çevir butonunu göstermeycez.  --->
    <cfquery name="get_faction_control" datasource="#DSN#"><!--- Sistem ekleme sürecine yetkisi olup olmadığını kontrol eder. --->
        SELECT 
            DISTINCT
                PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
                PROCESS_TYPE_ROWS.STAGE,
                PROCESS_TYPE_ROWS.LINE_NUMBER,
                PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
            FROM
                PROCESS_TYPE PROCESS_TYPE,
                PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
                PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS,
                PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID,
                EMPLOYEE_POSITIONS EMPLOYEE_POSITIONS
            WHERE
                PROCESS_TYPE.IS_ACTIVE = 1 AND
                PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
                PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
                PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                <cfif database_type is 'MSSQL'>
                    CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE '%product.form_add_product_cost,%' AND
                <cfelseif database_type is 'DB2'>
                    CAST(PROCESS_TYPE.FACTION AS VARGRAPHIC(2500))||',' LIKE '%product.form_add_product_cost,%'AND
                </cfif>
                EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
                PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
                EMPLOYEE_POSITIONS.POSITION_ID = PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID
        UNION
            SELECT DISTINCT
                PROCESS_TYPE_ROWS.PROCESS_ROW_ID,
                PROCESS_TYPE_ROWS.STAGE,
                PROCESS_TYPE_ROWS.LINE_NUMBER,
                PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
            FROM 	
                PROCESS_TYPE  AS PROCESS_TYPE,
                PROCESS_TYPE_OUR_COMPANY PROCESS_TYPE_OUR_COMPANY,
                PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS,
                PROCESS_TYPE_ROWS_WORKGRUOP AS PROCESS_TYPE_ROWS_WORKGRUOP,
                PROCESS_TYPE_ROWS_POSID AS PROCESS_TYPE_ROWS_POSID
            WHERE 
                PROCESS_TYPE.IS_ACTIVE = 1 AND
                PROCESS_TYPE_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND
                PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_OUR_COMPANY.PROCESS_ID AND
                PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                <cfif database_type is 'MSSQL'>
                    CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE '%product.form_add_product_cost,%' AND
                <cfelseif database_type is 'DB2'>
                    CAST(PROCESS_TYPE.FACTION AS VARGRAPHIC(2500))||',' LIKE '%product.form_add_product_cost,%'AND
                </cfif>													
                 PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID  AND 
                 PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID IS NOT NULL AND 
                 PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID AND 
                 PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.POSITION_CODE#">)
            ORDER BY 
                PROCESS_TYPE_ROWS.LINE_NUMBER
    </cfquery>
    <!--- //Süreç'e yetkisi yoksa önerilerini maliye çevir butonunu göstermeycez.  --->
    <cfparam name="attributes.period_id" default="#session.ep.period_id#">
    <cfparam name="attributes.act_id" default="">
    <cfparam name="attributes.act_type" default="1">
    <cfparam name="attributes.cost_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cf_date tarih = 'attributes.cost_date'>
    <cfinclude template="../product/query/get_product_cost_param.cfm">
    <cfinclude template="../product/query/get_money.cfm"><!--- SETUP MNYDEN ALINIYOR AMA ELLE MALİYET GİRİLECEĞİNDE TARİHTEDKİ STOKDA KURLARDA O ZAMANDAN ALINMALI --->
    <cfscript>
        if(session.ep.isBranchAuthorization and listlen(session.ep.user_location,"-") eq 3)
        {
            departmetn_id = ListGetAt(session.ep.user_location,1,"-");
            location_id = ListGetAt(session.ep.user_location,3,"-");
        }else
        {
            departmetn_id = '';//GET_PRODUCT_COST.DEPARTMENT_ID;
            location_id = '';//GET_PRODUCT_COST.LOCATION_ID;
        }
        spec_main_id = GET_PRODUCT_COST.SPECT_MAIN_ID;
        if(not session.ep.isBranchAuthorization)
        {
            reference_money = GET_PRODUCT_COST.MONEY;
            alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET;
            alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
            alis_net_fiyat_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
            alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST;
            alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
            alis_ek_maliyet_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
            son_st_maliyet = get_product_cost.STANDARD_COST;
            son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY;
            son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE;
            fiziksel_yas = get_product_cost.PHYSICAL_DATE;
            finansal_yas = get_product_cost.DUE_DATE;
        }
        else
        {
            reference_money = GET_PRODUCT_COST.MONEY_LOCATION;
            purchase_net_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION;
            alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET_LOCATION;
            alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION;
            alis_net_fiyat_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION;
            alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_LOCATION;
            alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_LOCATION;
            alis_ek_maliyet_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION;
            son_st_maliyet = get_product_cost.STANDARD_COST_LOCATION;
            son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY_LOCATION;
            son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE_LOCATION;
            fiziksel_yas = get_product_cost.PHYSICAL_DATE_LOCATION;
            finansal_yas = get_product_cost.DUE_DATE_LOCATION;
        }
        if (session.ep.period_year gt 2008 and reference_money  is 'YTL')
            reference_money = 'TL';
    </cfscript>
    <cfquery name="GET_STOCK" datasource="#DSN3#">
		SELECT
			STOCK_ID,
			STOCK_CODE
		FROM
			STOCKS
		WHERE
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfquery>
    <cfif len(departmetn_id)>
        <cfquery name="GET_DEPARTMENT" datasource="#DSN#">
            SELECT DEPARTMENT_HEAD FROM  DEPARTMENT WHERE DEPARTMENT_ID = #departmetn_id#
        </cfquery>
        <cfif len(location_id)>
            <cfquery name="GET_LOCATION" datasource="#DSN#">
                SELECT COMMENT FROM STOCKS_LOCATION WHERE LOCATION_ID = #location_id# AND DEPARTMENT_ID = #departmetn_id#
            </cfquery>
        </cfif>
    </cfif>
    <cfif len(spec_main_id)>
        <cfquery name="GET_SPECT_MAIN_NAME" datasource="#DSN3#">
            SELECT SPECT_MAIN_ID, SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spec_main_id#">
        </cfquery>
    </cfif>
    <cfquery name="GET_COST_TYPE" datasource="#DSN#">
        SELECT COST_TYPE_ID,COST_TYPE_NAME FROM SETUP_COST_TYPE 
    </cfquery>
    <cfquery name="product_total_stock" datasource="#dsn2#">
        SELECT
            SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK
        FROM
            STOCKS_ROW SR
        WHERE
            SR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
            PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.cost_date#">
            <cfif len(spec_main_id)>
                AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spec_main_id#">
            </cfif>
    </cfquery>
    <cfif product_total_stock.recordcount and len(product_total_stock.product_total_stock)>
        <cfset mevcut_son_alislar = product_total_stock.product_total_stock>
    <cfelse>
        <cfset mevcut_son_alislar = 0>
    </cfif>
    <!--- //ANLAŞMA --->
    <cfquery name="get_sevk" datasource="#DSN2#">
        SELECT 
            SUM(STOCK_OUT-STOCK_IN) AS MIKTAR 
        FROM 
            STOCKS_ROW 
        WHERE
            PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
            PROCESS_TYPE = 81
            <cfif len(spec_main_id)>
                AND SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#spec_main_id#">
            </cfif>
    </cfquery>
    <cfif get_sevk.recordcount and len(get_sevk.MIKTAR)>
        <cfset yoldaki_stoklar = get_sevk.MIKTAR>
    <cfelse>
        <cfset yoldaki_stoklar = 0>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cf_get_lang_set module_name="product"><!--- sayfanin en altinda kapanisi var --->
    <cf_xml_page_edit fuseact="product.popup_form_upd_product_cost">
    <cfquery name="get_product_cost" datasource="#dsn3#">
        SELECT PROCESS_STAGE,PRODUCT_COST_ID,PRODUCT_ID,SPECT_MAIN_ID,* FROM PRODUCT_COST WHERE PRODUCT_COST_ID = <cfqueryparam value="#attributes.pcid#">
    </cfquery>
    <cfif not get_product_cost.recordcount>
        <script type="text/javascript">
			alertObject({message: "Kayıtlı bir maliyet bulunamadı!"});
            window.close;
        </script>
        <cfabort>
    </cfif>
    <!--- maliyet için bir fiyat koruma yapıldı mı --->
    <cfquery name="get_comparison" datasource="#dsn2#">
        SELECT CONTRACT_COMPARISON_ROW_ID, COMPANY_ID FROM INVOICE_CONTRACT_COMPARISON WHERE COST_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcid#">
    </cfquery>
    
    <!--- hangi belge ise o belgeden kur bilgilerini alıyor --->
    <cfquery name="get_per" datasource="#dsn#">
        SELECT PERIOD_YEAR, OUR_COMPANY_ID FROM SETUP_PERIOD WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.action_period_id#">
    </cfquery>
    <cfset per_dsn='#dsn#_#get_per.PERIOD_YEAR#_#get_per.OUR_COMPANY_ID#'>
    <cfif get_product_cost.action_type eq 1>
        <cfquery name="get_money" datasource="#per_dsn#">
            SELECT RATE1, RATE2, MONEY_TYPE MONEY FROM INVOICE_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.action_id#">
        </cfquery>
    <cfelseif get_product_cost.action_type eq 2>
        <cfquery name="get_money" datasource="#per_dsn#">
            SELECT  RATE1, RATE2, MONEY_TYPE MONEY FROM SHIP_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.action_id#">
        </cfquery>
    <cfelseif get_product_cost.action_type eq 3>
        <cfquery name="get_money" datasource="#per_dsn#">
            SELECT RATE1, RATE2, MONEY_TYPE MONEY FROM STOCK_FIS_MONEY WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.action_id#">
        </cfquery>
    <cfelse>
        <cfquery name="get_money_history" datasource="#dsn#">
            SELECT RATE2, RATE1, MONEY, VALIDATE_DATE, MONEY_HISTORY_ID FROM MONEY_HISTORY WHERE VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDate(get_product_cost.start_date)#">
        </cfquery>
    </cfif>
    <cfif not isdefined('get_money') or not get_money.recordcount>
        <cfinclude template="../product/query/get_money.cfm">
    </cfif>
    <cfif get_money.recordcount>
        <cfset rate=get_money.rate2/get_money.rate1>
    <cfelse>
        <cfset rate=1>
    </cfif>
    <cfquery name="get_unit" datasource="#dsn#">
        SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.unit_id#">
    </cfquery>
    <cfoutput query="get_money">
        <cfif isdefined('get_money_history')>
            <cfquery name="get_mny" dbtype="query" maxrows="1">
                SELECT 
                    RATE2,
                    RATE1
                FROM 
                    GET_MONEY_HISTORY
                WHERE
                    VALIDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateOdbcDate(get_product_cost.start_date)#"> AND
                    MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#MONEY#"> AND
                    RATE2 IS NOT NULL
                ORDER BY 
                    VALIDATE_DATE DESC,
                    MONEY_HISTORY_ID DESC
            </cfquery>
            <cfset rate2_=get_mny.rate2>
            <cfset rate1_=get_mny.rate1>
        </cfif>
        <cfif not isdefined('get_money_history') or not get_mny.recordcount>
            <cfset rate2_=rate2>
            <cfset rate1_=rate1>
        </cfif>
        <cfset "money_#money#" = "#wrk_round(rate2_/rate1_,4)#">
    </cfoutput>
    <cfquery name="get_stock" datasource="#dsn3#">
        SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_cost.product_id#">
    </cfquery>
    <cfscript>
        department_id = GET_PRODUCT_COST.DEPARTMENT_ID;
        location_id = GET_PRODUCT_COST.LOCATION_ID;
        spec_main_id = GET_PRODUCT_COST.SPECT_MAIN_ID;
		process_stage = GET_PRODUCT_COST.PROCESS_STAGE;
        if(not session.ep.isBranchAuthorization)
        {
            total_maliyet = GET_PRODUCT_COST.PRODUCT_COST;
            total_maliyet_money = GET_PRODUCT_COST.MONEY;
            reference_money = GET_PRODUCT_COST.PURCHASE_NET_MONEY;
            alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET;
            alis_net_fiyat_money = "#reference_money#";
            alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
            alis_net_fiyat2_money = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY;
            alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST;
            alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
            alis_net_fiyat2_loc = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
            alis_ek_maliyet_money = "#reference_money#";
            son_st_maliyet = get_product_cost.STANDARD_COST;
            son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY;
            son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE;
            mevcut_stok = GET_PRODUCT_COST.AVAILABLE_STOCK;
            partner_stok = GET_PRODUCT_COST.PARTNER_STOCK;
            yoldaki_stok = GET_PRODUCT_COST.ACTIVE_STOCK;
            fiyat_koruma = GET_PRODUCT_COST.PRICE_PROTECTION;
            fiyat_koruma_money = GET_PRODUCT_COST.PRICE_PROTECTION_MONEY;
            fiyat_koruma_loc = GET_PRODUCT_COST.PRICE_PROTECTION_LOCATION;
            fiyat_koruma_money_loc = GET_PRODUCT_COST.PRICE_PROTECTION_MONEY_LOCATION;
            fiziksel_yas = get_product_cost.PHYSICAL_DATE;
            finansal_yas = get_product_cost.DUE_DATE;
        }
        else
        {
            total_maliyet = GET_PRODUCT_COST.PRODUCT_COST_LOCATION;
            total_maliyet_money = GET_PRODUCT_COST.MONEY_LOCATION;
            reference_money=GET_PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION;
            alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET_LOCATION;
            alis_net_fiyat_money = "#reference_money#";
            alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION;
            alis_net_fiyat2_money = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_MONEY_LOCATION;
            alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_LOCATION;
            alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_LOCATION;
            alis_net_fiyat2_loc = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION;
            alis_ek_maliyet_money = "#reference_money#";
            son_st_maliyet = get_product_cost.STANDARD_COST_LOCATION;
            son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY_LOCATION;
            son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE_LOCATION;
            mevcut_stok = GET_PRODUCT_COST.AVAILABLE_STOCK_LOCATION;
            partner_stok = GET_PRODUCT_COST.PARTNER_STOCK_LOCATION;
            yoldaki_stok = GET_PRODUCT_COST.ACTIVE_STOCK_LOCATION;
            fiyat_koruma = GET_PRODUCT_COST.PRICE_PROTECTION_LOCATION;
            fiyat_koruma_money = GET_PRODUCT_COST.PRICE_PROTECTION_MONEY_LOCATION;
            fiziksel_yas = get_product_cost.PHYSICAL_DATE_LOCATION;
            finansal_yas = get_product_cost.DUE_DATE_LOCATION;
        }
    </cfscript>
	<cfif len(department_id)>
        <cfquery name="get_department" datasource="#dsn#">
            SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
        </cfquery>
        <cfif len(location_id)>
            <cfquery name="get_location" datasource="#dsn#">
                SELECT COMMENT FROM STOCKS_LOCATION WHERE LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#location_id#"> AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
            </cfquery>
        </cfif>
    </cfif>
    <cfif len(spec_main_id)>
        <cfquery name="GET_SPECT_MAIN_NAME" datasource="#dsn3#">
            SELECT SPECT_MAIN_ID, SPECT_MAIN_NAME FROM SPECT_MAIN WHERE SPECT_MAIN_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#spec_main_id#">
        </cfquery>
    </cfif>
    <cfquery name="GET_COST_TYPE" datasource="#dsn#">
        SELECT COST_TYPE_ID,COST_TYPE_NAME FROM SETUP_COST_TYPE 
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'convertcost'>
    <cfparam name="attributes.FORM_CRNTROW" default="1">
    <cfparam name="attributes.surece_yetki" default="0">
    <cfparam name="attributes.period_id" default="#session.ep.period_id#">
    <cfparam name="attributes.act_id" default="">
    <cfparam name="attributes.act_type" default="1">
    <cfinclude template="../product/query/get_money.cfm"><!--- SETUP MNYDEN ALINIYOR AMA ELLE MALİYET GİRİLECEĞİNDE TARİHTEDKİ STOKDA KURLARDA O ZAMANDAN ALINMALI --->
    <cfquery name="GET_PRODUCT_COST_SUGGESTION" datasource="#dsn1#">
        SELECT * FROM PRODUCT_COST_SUGGESTION WHERE PRODUCT_COST_SUGGESTION_ID = #attributes.suggest_id#
    </cfquery>
    <cfscript>
        departmetn_id = GET_PRODUCT_COST_SUGGESTION.DEPARTMENT_ID;
        location_id = GET_PRODUCT_COST_SUGGESTION.LOCATION_ID;
        spec_main_id = GET_PRODUCT_COST_SUGGESTION.SPECT_MAIN_ID;
        if(not session.ep.isBranchAuthorization)
        {
            total_maliyet = GET_PRODUCT_COST_SUGGESTION.PRODUCT_COST;
            total_maliyet_money = GET_PRODUCT_COST_SUGGESTION.MONEY;
            reference_money = GET_PRODUCT_COST_SUGGESTION.MONEY;
            alis_net_fiyat = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET;
            alis_net_fiyat_money = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_MONEY;
            alis_net_fiyat2 = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM;
            alis_net_fiyat2_money = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM_MONEY;
            alis_ek_maliyet = GET_PRODUCT_COST_SUGGESTION.PURCHASE_EXTRA_COST;
            alis_ek_maliyet2 = GET_PRODUCT_COST_SUGGESTION.PURCHASE_EXTRA_COST_SYSTEM;
            alis_net_fiyat2_loc = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM;
            alis_ek_maliyet_money = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_MONEY;
            son_st_maliyet = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST;
            son_st_maliyet_money = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST_MONEY;
            son_st_maliyet_oran = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST_RATE;
            mevcut_stok = GET_PRODUCT_COST_SUGGESTION.AVAILABLE_STOCK;
            partner_stok = GET_PRODUCT_COST_SUGGESTION.PARTNER_STOCK;
            yoldaki_stok = GET_PRODUCT_COST_SUGGESTION.ACTIVE_STOCK;
            fiyat_koruma = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION;
            fiyat_koruma_money = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION_MONEY;
            fiyat_koruma_loc = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION_LOCATION;
            fiyat_koruma_money_loc = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION_MONEY_LOCATION;
            
        }else
        {
            total_maliyet = GET_PRODUCT_COST_SUGGESTION.PRODUCT_COST_LOCATION;
            total_maliyet_money = GET_PRODUCT_COST_SUGGESTION.MONEY_LOCATION;
            reference_money=GET_PRODUCT_COST_SUGGESTION.MONEY_LOCATION;
            alis_net_fiyat = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_LOCATION;
            alis_net_fiyat_money = GET_PRODUCT_COST_SUGGESTION.MONEY_LOCATION;
            alis_net_fiyat2 = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM_LOCATION;
            alis_net_fiyat2_money = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM_MONEY_LOCATION;
            alis_ek_maliyet = GET_PRODUCT_COST_SUGGESTION.PURCHASE_EXTRA_COST_LOCATION;
            alis_ek_maliyet2 = GET_PRODUCT_COST_SUGGESTION.PURCHASE_EXTRA_COST_SYSTEM_LOCATION;
            alis_net_fiyat2_loc = GET_PRODUCT_COST_SUGGESTION.PURCHASE_NET_SYSTEM_LOCATION;
            alis_ek_maliyet_money = GET_PRODUCT_COST_SUGGESTION.MONEY_LOCATION;
            son_st_maliyet = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST_LOCATION;
            son_st_maliyet_money = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST_MONEY_LOCATION;
            son_st_maliyet_oran = GET_PRODUCT_COST_SUGGESTION.STANDARD_COST_RATE_LOCATION;
            mevcut_stok = GET_PRODUCT_COST_SUGGESTION.AVAILABLE_STOCK_LOCATION;
            partner_stok = GET_PRODUCT_COST_SUGGESTION.PARTNER_STOCK_LOCATION;
            yoldaki_stok = GET_PRODUCT_COST_SUGGESTION.ACTIVE_STOCK_LOCATION;
            fiyat_koruma = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION_LOCATION;
            fiyat_koruma_money = GET_PRODUCT_COST_SUGGESTION.PRICE_PROTECTION_MONEY_LOCATION;
        }
    </cfscript>
    <cfif len(spec_main_id)>
        <cfquery name="GET_SPECT_MAIN_NAME" datasource="#DSN3#">
            SELECT
                SPECT_MAIN_ID,
                SPECT_MAIN_NAME
            FROM
                SPECT_MAIN
            WHERE
                SPECT_MAIN_ID = #spec_main_id#
        </cfquery>
    </cfif>
    <cfif len(departmetn_id)>
        <cfquery name="GET_DEPARTMENT" datasource="#DSN#">
            SELECT
                DEPARTMENT_HEAD
            FROM 
                DEPARTMENT
            WHERE
                DEPARTMENT_ID = #departmetn_id#
        </cfquery>
        <cfif len(location_id)>
            <cfquery name="GET_LOCATION" datasource="#DSN#">
                SELECT
                    COMMENT
                FROM
                    STOCKS_LOCATION
                WHERE
                    LOCATION_ID = #location_id# AND
                    DEPARTMENT_ID = #departmetn_id#
            </cfquery>
        </cfif>
    </cfif>
    <cfquery name="GET_COST_TYPE" datasource="#DSN#">
        SELECT COST_TYPE_ID,COST_TYPE_NAME FROM SETUP_COST_TYPE 
    </cfquery>
<cfelseif isdefined("attributes.event") and attributes.event is 'addcostsuggest'>
    <cfparam name="attributes.period_id" default="#session.ep.period_id#">
    <cfparam name="attributes.act_id" default="">
    <cfparam name="attributes.act_type" default="1">
    <cfparam name="attributes.cost_date" default="#dateformat(now(),'dd/mm/yyyy')#">
    <cf_date tarih = 'attributes.cost_date'>
    <cfquery name="GET_SETUP_PERIOD" datasource="#DSN#">
        SELECT PERIOD_ID,INVENTORY_CALC_TYPE FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #session.ep.COMPANY_ID#
    </cfquery>
    <cfset period_id_list = ValueList(GET_SETUP_PERIOD.PERIOD_ID,',')>
    <cfinclude template="../product/query/get_product_cost_param.cfm">
    <cfinclude template="../product/query/get_money.cfm"><!--- SETUP MNYDEN ALINIYOR AMA ELLE MALİYET GİRİLECEĞİNDE TARİHTEDKİ STOKDA KURLARDA O ZAMANDAN ALINMALI --->
    <cfif not len(GET_SETUP_PERIOD.inventory_calc_type)>
        <script type="text/javascript">
			alertObject({message: "<cf_get_lang no ='729.Bu sayfayı kullanabilmek için önce ilgili ürünün detayında envanter yöntemi seçmelisiniz'> !"});
            window.close();
        </script>
        <cfabort>
    </cfif>
    <cfscript>
        if(session.ep.isBranchAuthorization and listlen(session.ep.user_location,"-") eq 3)
        {
            departmetn_id = ListGetAt(session.ep.user_location,1,"-");
            location_id = ListGetAt(session.ep.user_location,3,"-");
        }else
        {
            departmetn_id = '';//GET_PRODUCT_COST.DEPARTMENT_ID;
            location_id = '';//GET_PRODUCT_COST.LOCATION_ID;
        }
        spec_main_id = GET_PRODUCT_COST.SPECT_MAIN_ID;
        if(not session.ep.isBranchAuthorization)
        {
            reference_money=GET_PRODUCT_COST.PURCHASE_NET_MONEY;
            alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET;
            alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM;
            alis_net_fiyat_money = "#reference_money#";
            alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST;
            alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM;
            alis_ek_maliyet_money = "#reference_money#";
            son_st_maliyet = get_product_cost.STANDARD_COST;
            son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY;
            son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE;
        }else
        {
            reference_money=GET_PRODUCT_COST.PURCHASE_NET_MONEY_LOCATION;
            alis_net_fiyat = GET_PRODUCT_COST.PURCHASE_NET_LOCATION;
            alis_net_fiyat2 = GET_PRODUCT_COST.PURCHASE_NET_SYSTEM_LOCATION;
            alis_net_fiyat_money = "#reference_money#";
            alis_ek_maliyet = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_LOCATION;
            alis_ek_maliyet2 = GET_PRODUCT_COST.PURCHASE_EXTRA_COST_SYSTEM_LOCATION;
            alis_ek_maliyet_money = "#reference_money#";
            son_st_maliyet = get_product_cost.STANDARD_COST_LOCATION;
            son_st_maliyet_money = get_product_cost.STANDARD_COST_MONEY_LOCATION;
            son_st_maliyet_oran = get_product_cost.STANDARD_COST_RATE_LOCATION;
        }
    </cfscript>
    <cfquery name="GET_STOCK" datasource="#DSN3#">
        SELECT
            STOCK_ID,
            STOCK_CODE
        FROM
            STOCKS
        WHERE
            PRODUCT_ID=#attributes.pid#
    </cfquery>
    <cfif session.ep.period_year gt 2008 and alis_net_fiyat_money  is 'YTL'><cfset alis_net_fiyat_money = 'TL'></cfif>
    <cfif session.ep.period_year gt 2008 and son_st_maliyet_money  is 'YTL'><cfset son_st_maliyet_money = 'TL'></cfif>
    <cfif len(spec_main_id)>
        <cfquery name="GET_SPECT_MAIN_NAME" datasource="#DSN3#">
            SELECT
                SPECT_MAIN_ID,
                SPECT_MAIN_NAME
            FROM
                SPECT_MAIN
            WHERE
                SPECT_MAIN_ID = #spec_main_id#
        </cfquery>
    </cfif>
     <cfif len(departmetn_id)>
        <cfquery name="GET_DEPARTMENT" datasource="#DSN#">
            SELECT
                DEPARTMENT_HEAD
            FROM 
                DEPARTMENT
            WHERE
                DEPARTMENT_ID = #departmetn_id#
        </cfquery>
        <cfif len(location_id)>
            <cfquery name="GET_LOCATION" datasource="#DSN#">
                SELECT
                    COMMENT
                FROM
                    STOCKS_LOCATION
                WHERE
                    LOCATION_ID = #location_id# AND
                    DEPARTMENT_ID = #departmetn_id#
            </cfquery>
        </cfif>
    </cfif>
    <cfquery name="GET_COST_TYPE" datasource="#DSN#">
        SELECT COST_TYPE_ID,COST_TYPE_NAME FROM SETUP_COST_TYPE 
    </cfquery>
</cfif>  
<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")> 
		$( document ).ready(function() 
		{
		 $('#keyword').focus();
		});		
		function input_control()
		{
			if(search_product.brand_name.value.length == 0) search_product.brand_id.value = '';
			if(search_product.company.value.length == 0) search_product.company_id.value = '';
			if(search_product.pos_manager.value.length == 0) search_product.pos_code.value = '';
			<cfif not session.ep.our_company_info.unconditional_list>
				if(search_product.keyword.value.length == 0 && search_product.cat.value.length == 0 && search_product.inventory_calc_type.value.length == 0 && (search_product.brand_id.value.length == 0 || search_product.brand_name.value.length == 0) && (search_product.pos_code.value.length == 0 || search_product.pos_manager.value.length == 0) && (search_product.company_id.value.length == 0 || search_product.company.value.length == 0) )
				{
					alertObject({message: "<cf_get_lang_main no='1538.En az bir alanda filtre etmelisiniz '>!"});
					return false;
				}
				else
					return true;
			<cfelse>
				return true;
			</cfif>
		}
	<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
		$( document ).ready(function() 
		{
			validate().set();
			round_number = document.getElementById('round_number').value;
			ses_period_year = <cfoutput>#session.ep.period_year#</cfoutput>;//ytl tl sorunu olmasın daha sonra kaldırılacak...
			document.getElementById('available_stock').value = '<cfoutput>#tlformat(mevcut_son_alislar)#</cfoutput>';
			document.getElementById('active_stock').value = '<cfoutput>#tlformat(yoldaki_stoklar)#</cfoutput>';
			document.getElementById('price_prot_amount').value='<cfoutput>#tlformat(mevcut_son_alislar+yoldaki_stoklar)#</cfoutput>';
			document.getElementById('total_stock').value='<cfoutput>#tlformat(mevcut_son_alislar+yoldaki_stoklar)#</cfoutput>';
			hesapla();
		});	

		function cevir(){
			document.getElementById('purchase_net_system').value =  parseFloat(filterNum(document.getElementById('purchase_net_system').value,round_number));
			document.getElementById('purchase_extra_cost_system').value =  parseFloat(filterNum(document.getElementById('purchase_extra_cost_system').value,round_number));
			document.getElementById('purchase_net_system_location').value =  parseFloat(filterNum(document.getElementById('purchase_net_system_location').value,round_number));
		}
		function open_spec_popup(frm_name)
		{
			if (frm_name == undefined)
			{
				var _form_name_ = 'product_cost';
				var _field_main_id_ = 'product_cost.spect_main_id';
				var _field_name_ = 'product_cost.spect_name';
			}	
			else
			{
				var _form_name_ = frm_name;
				var _field_main_id_ =_form_name_+'.spect_main_id';
				var _field_name_ =_form_name_+'.spect_name';
			}
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=' + _field_main_id_ + '&field_name=' + _field_name_+ '&is_display=1&stock_id=<cfoutput>#GET_STOCK.STOCK_ID#</cfoutput>&function_name=get_stock&function_form_name='+ _form_name_ +'','list');
		}
		function history_money(frm_name)
		{
			if (frm_name == undefined)
			{
				var _form_name_ = 'product_cost';
			}	
			else
			{
				var _form_name_ = frm_name;
			}
			var h_date=js_date(document.getElementById('start_date').value);
			<cfoutput query="GET_MONEY">
				var get_his_rate=wrk_query("SELECT (RATE2/RATE1) RATE,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE <= "+h_date+" AND MONEY = '#money#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE DESC,MONEY_HISTORY_ID DESC","dsn");
				if(get_his_rate.recordcount)
					document.getElementById('money_#money#').value=get_his_rate.RATE[0];
				else
					document.getElementById('money_#money#').value=#wrk_round(rate2/rate1,'#session.ep.our_company_info.rate_round_num#')#;
			</cfoutput>
			hesapla();
			return true;
		}
		function hesapla(frm_name)
		{	
			document.getElementById('purchase_net_system').value =  parseFloat(filterNum(document.getElementById('purchase_net_system').value,round_number));
			document.getElementById('purchase_extra_cost_system').value =  parseFloat(filterNum(document.getElementById('purchase_extra_cost_system').value,round_number));
			document.getElementById('purchase_net_system_location').value =  parseFloat(filterNum(document.getElementById('purchase_net_system_location').value,round_number));
			if (frm_name == undefined)
				var _form_name_ = 'product_cost';
			else
				var _form_name_ = frm_name;
			var t1 = parseFloat(filterNum(document.getElementById('purchase_net').value,round_number));
			var t2 = parseFloat(filterNum(document.getElementById('purchase_extra_cost').value,round_number));
			var t3 = parseFloat(filterNum(document.getElementById('standard_cost').value,round_number));
			var t4 = parseFloat(filterNum(document.getElementById('standard_cost_rate').value,round_number));
			var t5 = parseFloat(filterNum(document.getElementById('price_protection').value,round_number));
			
			if(document.getElementById('price_protection_type')!=undefined)
				t5 = t5*document.getElementById('price_protection_type').value;
			
			if (isNaN(t1)) {t1 = 0; document.getElementById('purchase_net').value = 0;}
			if (isNaN(t2)) {t2 = 0; document.getElementById('purchase_extra_cost').value = 0;}
			if (isNaN(t3)) {t3 = 0; document.getElementById('standard_cost').value = 0;}
			if (isNaN(t4)) {t4 = 0;	document.getElementById('standard_cost_rate').value = 0;}
			if (isNaN(t5)) {t5 = 0; document.getElementById('price_protection').value = 0;}
			var q=0;
			if(document.getElementById('reference_money').value != '' && (document.getElementById('money_'+document.getElementById('reference_money').value))!=undefined)
				q=eval(document.getElementById('money_'+document.getElementById('reference_money').value)).value;
			if(document.getElementById('purchase_net_money').value != '' && document.getElementById('money_'+document.getElementById('purchase_net_money').value)!=undefined)
				purchase_money_rate=document.getElementById('money_'+document.getElementById('purchase_net_money').value).value;
			if(!q>0)q=1;
			t1 = (t1 * document.getElementById('money_'+document.getElementById('purchase_net_money').value).value) / q;
			t2 = (t2 * document.getElementById('money_'+document.getElementById('purchase_net_money').value).value) / q;
			t3 = (t3 * document.getElementById('money_'+document.getElementById('standard_cost_money').value).value) / q;
			t5 = (t5 * document.getElementById('money_'+document.getElementById('price_protection_money').value).value) / q;
			var t1_ = parseFloat(filterNum(document.getElementById('purchase_net').value,round_number));
			var t2_ = parseFloat(filterNum(document.getElementById('purchase_extra_cost').value,round_number));
			var t3_ = parseFloat(filterNum(document.getElementById('standard_cost').value,round_number));
			var t4_ = parseFloat(filterNum(document.getElementById('standard_cost_rate').value,round_number));
			var t5_ = parseFloat(filterNum(document.getElementById('price_protection').value,round_number));
			available_stock = filterNum(document.getElementById('available_stock').value);
			price_prot_amount = filterNum(document.getElementById('price_prot_amount').value);
			if(available_stock != 0)
				t5 = t5*price_prot_amount/available_stock;
			else
				t5 = 0;
			order_total = t1_+t2_+t3_+((t1_*t4_)/100)-t5_;
			document.getElementById('product_cost_').value = commaSplit(order_total,round_number);// input product_cost idi, getElementById ile alindignda form adiyla ayni oldugu icin karistiriyordu.  input adina "_" ekledik. hgul
			document.getElementById('purchase_net_system').value = commaSplit((t1-t5)*q,round_number);
			document.getElementById('purchase_extra_cost_system').value = commaSplit((t2+t3+(t1*t4)/100)*q,round_number);//TolgaS 20070410 Ömer Turhan isteği ile muhasebede sorun olacak diye ek maliyete sabit maliyetler eklendi daha once alış maliyetine idi
			
			<cfif not session.ep.isBranchAuthorization>
				var t5_location = parseFloat(filterNum(document.getElementById('price_protection_location').value,round_number));
				if (isNaN(t5_location)) {t5_location = 0; document.getElementById('price_protection_location').value = 0;}
				if(document.getElementById('money_'+document.getElementById('price_protection_money_location').value) != undefined)
					t5_location = (t5_location * document.getElementById('money_'+document.getElementById('price_protection_money_location').value).value) / q;
				document.getElementById('purchase_net_system_location').value = commaSplit((t1-t5_location)*q,round_number);
			</cfif>
		}
		function temizle_virgul(frm_name)
		{
			var formName = 'product_cost',
			form = $('form[name="'+ formName +'"]');
			var form_date_year = list_getat(form.find('input#start_date').val(),3,'/');
			if(form_date_year != ses_period_year){
				validateMessage('notValid',form.find('input#start_date'),1);
						return false;
			}else{
					validateMessage('valid',form.find('input#start_date'));
				}
			if (frm_name != undefined)
				var _form_name_ = frm_name;
			else
				var _form_name_ = product_cost;
			<cfif session.ep.isBranchAuthorization>
				if (form.find('input#department').val() == '' || form.find('input#department_id').val() == '' || form.find('input#location_id').val() == ''){
						validateMessage('notValid',form.find('input#department_message'),0 );
						return false;
					}else{
							validateMessage('valid',form.find('input#department_message') );
						}
			</cfif>
			if(process_cat_control() == false) return false;
			if(parseFloat(filterNum(document.getElementById('price_protection').value)) > 0 && price_protection_control())//fiyat koruma yapilsinmi
			{
				if (form.find('input#td_company').val() == '' || form.find('input#td_company_id').val() == ''){
					validateMessage('notValid',form.find('input#td_company'),0 );
					return false;
				}else{
						validateMessage('valid',form.find('input#td_company') );
					}
				
				document.getElementById('cost_control').value=1;
			}
			else 
			{
				document.getElementById('cost_control').value=0;
			}
	
			if(document.getElementById('standard_cost').value == '')
				document.getElementById('standard_cost').value = 0;
			if(document.getElementById('purchase_net').value == '')
				document.getElementById('purchase_net').value = 0;
			if(document.getElementById('standard_cost_rate').value == '')
				document.getElementById('standard_cost_rate').value = 0;
			if(document.getElementById('purchase_extra_cost').value == '')
				document.getElementById('purchase_extra_cost').value = 0;
			if(document.getElementById('price_protection').value == '')
				document.getElementById('price_protection').value = 0;
			if(document.getElementById('purchase_net_system').value == '')
				document.getElementById('purchase_net_system').value = 0;
			if(document.getElementById('purchase_extra_cost_system').value == '')
				document.getElementById('purchase_extra_cost_system').value = 0;
			if(document.getElementById('purchase_net_system_location').value == '')
				document.getElementById('purchase_net_system_location').value = 0;
	
			document.getElementById('standard_cost').value = filterNum(document.getElementById('standard_cost').value,round_number);
			document.getElementById('purchase_net').value = filterNum(document.getElementById('purchase_net').value,round_number);
			document.getElementById('available_stock').value = filterNum(document.getElementById('available_stock').value);
			document.getElementById('standard_cost_rate').value = filterNum(document.getElementById('standard_cost_rate').value);
			document.getElementById('purchase_extra_cost').value = filterNum(document.getElementById('purchase_extra_cost').value,round_number);
			document.getElementById('partner_stock').value = filterNum(document.getElementById('partner_stock').value);
			document.getElementById('price_protection').value = filterNum(document.getElementById('price_protection').value,round_number);
			document.getElementById('active_stock').value = filterNum(document.getElementById('active_stock').value);
			document.getElementById('product_cost_').value = filterNum(document.getElementById('product_cost_').value);
			document.getElementById('purchase_net_system').value = filterNum(document.getElementById('purchase_net_system').value,round_number);
			document.getElementById('purchase_extra_cost_system').value = filterNum(document.getElementById('purchase_extra_cost_system').value,round_number);
			document.getElementById('purchase_net_system_location').value = filterNum(document.getElementById('purchase_net_system_location').value,round_number);
			
			if(document.getElementById('price_protection_location')!=undefined)
			{
				if(document.getElementById('price_protection_location').value == '')document.getElementById('price_protection_location').value = 0;
				document.getElementById('price_protection_location').value = filterNum(document.getElementById('price_protection_location').value,round_number);
			}
			if(document.getElementById('total_price_prot')!=undefined)
			{
				if(document.getElementById('total_price_prot').value == '') document.getElementById('total_price_prot').value = 0;
				document.getElementById('total_price_prot').value = filterNum(document.getElementById('total_price_prot').value,round_number);
				if(document.getElementById('price_prot_amount').value == '') document.getElementById('price_prot_amount').value = 0;
				document.getElementById('price_prot_amount').value = filterNum(document.getElementById('price_prot_amount').value,round_number);
			}
			document.getElementById('inventory_calc_type').disabled = false;
			document.getElementById('product_cost_money').disabled = false;
			return true;
		}
		function price_protection_control(frm_name)
		{
			if(confirm("<cf_get_lang no ='724.Fiyat Koruma için Fiyat Farkı Faturası Emri Verilsin mı'>?"))
				return true;
			else
				return false;
		}
		function get_stock(frm_name)
		{
		if (frm_name == undefined)
			var _form_name_ = 'product_cost';
		else
			var _form_name_ = frm_name;
			<cfif session.ep.isBranchAuthorization>
				var dep_sql='AND STORE ='+ document.getElementById("department_id").value +' AND STORE_LOCATION ='+ document.getElementById("location_id").value;
			<cfelse>
				var dep_sql='';
			</cfif>
			if(document.getElementById('spect_main_id').value!="" && document.getElementById('spect_name').value!="")
				var spec_query='AND SPECT_VAR_ID='+document.getElementById('spect_main_id').value;
			else
				var spec_query='';
			var gt_stoc=wrk_query('SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK FROM STOCKS_ROW SR WHERE SR.PRODUCT_ID = <cfoutput>#attributes.pid#</cfoutput> AND PROCESS_DATE <='+js_date(document.getElementById('start_date').value)+' '+spec_query+' '+dep_sql,'dsn2');
			if(gt_stoc.PRODUCT_TOTAL_STOCK=="")gt_stoc.PRODUCT_TOTAL_STOCK=0;
			if(gt_stoc.recordcount)
				document.getElementById('available_stock').value = commaSplit(gt_stoc.PRODUCT_TOTAL_STOCK);
			else
				document.getElementById('available_stock').value = '<cfoutput>#tlformat(0)#</cfoutput>';
			
			var get_sevk=wrk_query('SELECT SUM(STOCK_OUT-STOCK_IN) AS MIKTAR FROM STOCKS_ROW WHERE PRODUCT_ID = <cfoutput>#attributes.pid#</cfoutput> AND PROCESS_TYPE = 81 AND PROCESS_DATE <='+js_date(document.getElementById('start_date').value)+' '+spec_query+' '+dep_sql,'dsn2')
			if(get_sevk.MIKTAR=="")get_sevk.MIKTAR=0;
			if(get_sevk.recordcount)
				document.getElementById('active_stock').value= commaSplit(get_sevk.MIKTAR);
			else
				document.getElementById('active_stock').value ='<cfoutput>#tlformat(0)#</cfoutput>';
			document.product_cost.price_prot_amount.value=commaSplit(parseFloat(get_sevk.MIKTAR)+parseFloat(gt_stoc.PRODUCT_TOTAL_STOCK));
			return history_money();
		}
		
		function stock_total()
		{
			document.getElementById('total_stock').value=commaSplit(parseFloat(filterNum(document.getElementById('available_stock').value))+parseFloat(filterNum(document.getElementById('active_stock').value))+parseFloat(filterNum(document.getElementById('partner_stock').value)),2);
		}
		function total_price_protection_hesapla(type)
		{
			if(document.getElementById('price_prot_amount').value=="" || document.getElementById('price_prot_amount').value==0) 
				document.getElementById('price_prot_amount').value = 1;
			document.getElementById('price_prot_amount').value=filterNum(document.getElementById('price_prot_amount').value,round_number);
			document.getElementById('total_price_prot').value=filterNum(document.getElementById('total_price_prot').value,round_number);
			document.getElementById('price_protection').value=filterNum(document.getElementById('price_protection').value,round_number);
			if(type == 1)
			{
				 document.getElementById('price_protection').value = document.getElementById('total_price_prot').value / document.getElementById('price_prot_amount').value;
			}else if(type == 2)
			{
				if(document.getElementById('total_price_prot').value!="")
					document.getElementById('price_protection').value = document.getElementById('total_price_prot').value / document.getElementById('price_prot_amount').value;
				else if(document.getElementById('price_protection').value!="")
					document.getElementById('total_price_prot').value = document.getElementById('price_protection').value * document.getElementById('price_prot_amount').value;
			}else if(type == 3)
			{
				if(document.getElementById('price_protection').value!="")
					document.getElementById('total_price_prot').value = document.getElementById('price_protection').value * document.getElementById('price_prot_amount').value;
			}
			document.getElementById('price_prot_amount').value= (isNaN(document.getElementById('price_prot_amount').value))?0:commaSplit(document.getElementById('price_prot_amount').value,round_number);
			document.getElementById('price_protection').value=(isNaN(document.getElementById('price_protection').value))?0:commaSplit(document.getElementById('price_protection').value,round_number);
			document.getElementById('total_price_prot').value=(isNaN(document.getElementById('total_price_prot').value))?0:commaSplit(document.getElementById('total_price_prot').value,round_number);
			hesapla();
		}
	<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
		$( document ).ready(function() 
		{
			validate().set();
			stock_total();
		});	
		function open_spec_popup()
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=product_cost.spect_main_id&field_name=product_cost.spect_name&is_display=1&stock_id=<cfoutput>#GET_STOCK.STOCK_ID#</cfoutput>&function_name=get_stock','list');
		}
		function history_money(){
			var round_number = $('#round_number').val();
			var h_date=js_date(document.product_cost.start_date.value);
			<cfoutput query="GET_MONEY">
				var get_his_rate=wrk_query("SELECT (RATE2/RATE1) RATE,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE <= "+h_date+" AND MONEY = '#money#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE DESC,MONEY_HISTORY_ID DESC","dsn");
				if(get_his_rate.recordcount)
					eval('document.product_cost.money_#money#').value=get_his_rate.RATE[0];
				else
					eval('document.product_cost.money_#money#').value=#wrk_round(rate2/rate1,round_number)#;
			</cfoutput>
			hesapla();
			return true;
		}
		function open_action(type,pid)
		{
			if(type == 1)
			{
				<cfif get_product_cost.action_process_type eq 62>
				opener.window.location='<cfoutput>#request.self#?fuseaction=invoice.detail_invoice_sale&iid=#get_product_cost.action_id#</cfoutput>';
				<cfelse>
				opener.window.location='<cfoutput>#request.self#?fuseaction=invoice.detail_invoice_purchase&iid=#get_product_cost.action_id#</cfoutput>';
				</cfif>
			}
			else if(type == 2)
				opener.window.location='<cfoutput>#request.self#?fuseaction=stock.form_upd_purchase&ship_id=#get_product_cost.action_id#</cfoutput>';
			else if(type == 12)
				opener.window.location='<cfoutput>#request.self#?fuseaction=stock.upd_stock_in_from_customs&ship_id=#get_product_cost.action_id#</cfoutput>';
			else if(type == 13)
				opener.window.location='<cfoutput>#request.self#?fuseaction=stock.upd_ship_dispatch&ship_id=#get_product_cost.action_id#</cfoutput>';
			else if(type == 3)
				opener.window.location='<cfoutput>#request.self#?fuseaction=stock.form_upd_open_fis&upd_id=#get_product_cost.action_id#</cfoutput>';
			else if(type == 9)
				opener.window.location='<cfoutput>#request.self#?fuseaction=stock.form_upd_fis&upd_id=#get_product_cost.action_id#</cfoutput>';
			else if(type == 10)
				opener.window.location='<cfoutput>#request.self#?fuseaction=invent.upd_invent_stock_fis&fis_id=#get_product_cost.action_id#</cfoutput>';
			else if(type == 11)
				opener.window.location='<cfoutput>#request.self#?fuseaction=invent.upd_invent_stock_fis_return&fis_id=#get_product_cost.action_id#</cfoutput>';
			else if(type == 7)
				opener.window.location='<cfoutput>#request.self#?fuseaction=stock.form_upd_stock_exchange&exchange_id=#get_product_cost.action_id#</cfoutput>';
			else if(type == 8)//fiyat farkı ekranından...
				opener.window.location='<cfoutput>#request.self#?fuseaction=invoice.detail_invoice_sale&iid=#get_product_cost.action_id#</cfoutput>';
			else if(type == 4)
			{
			var p_orderid = pid;
			opener.window.location='<cfoutput>#request.self#?fuseaction=prod.upd_prod_order_result&p_order_id='+ p_orderid +'&pr_order_id=#get_product_cost.action_id#</cfoutput>';
			}
		}
		function hesapla()
		{ 
			var round_number = $('#round_number').val();
			var t1 = parseFloat(filterNum(document.getElementById('purchase_net').value,round_number));
			var t2 = parseFloat(filterNum(document.getElementById('purchase_extra_cost').value,round_number));
			var t3 = parseFloat(filterNum(document.getElementById('standard_cost').value,round_number));
			var t4 = parseFloat(filterNum(document.getElementById('standard_cost_rate').value,round_number));
			var t5 = parseFloat(filterNum(document.getElementById('price_protection').value,round_number));
			
			if(document.getElementById('price_protection_type')!=undefined)
				t5 = t5*document.getElementById('price_protection_type').value;
				
			if (isNaN(t1)) {t1 = 0; document.getElementById('purchase_net').value = 0;}
			if (isNaN(t2)) {t2 = 0; document.getElementById('purchase_extra_cost').value = 0;}
			if (isNaN(t3)) {t3 = 0; document.getElementById('standard_cost').value = 0;}
			if (isNaN(t4)) {t4 = 0; document.getElementById('standard_cost_rate').value = 0;}	
			if (isNaN(t5)) {t5 = 0; document.getElementById('price_protection').value = 0;}
			t1 = (t1 * document.getElementById('money_'+document.getElementById('purchase_net_money').value).value) / document.getElementById('money_'+document.getElementById('reference_money').value).value;
			t2 = (t2 * document.getElementById('money_'+document.getElementById('purchase_net_money').value).value) / document.getElementById('money_'+document.getElementById('reference_money').value).value;
			t3 = (t3 * document.getElementById('money_'+document.getElementById('standard_cost_money').value).value) / document.getElementById('money_'+document.getElementById('reference_money').value).value;
			t5 = (t5 * document.getElementById('money_'+document.getElementById('price_protection_money').value).value) / document.getElementById('money_'+document.getElementById('reference_money').value).value;
			
			order_total = t1+t2+t3+((t1*t4)/100)-t5;
			document.getElementById('product_cost_').value = commaSplit(order_total,round_number);
			document.getElementById('purchase_net_system').value = commaSplit((t1-t5)*document.getElementById('money_'+document.getElementById('reference_money').value).value,round_number);
			document.getElementById('purchase_extra_cost_system').value = commaSplit((t2+t3+(t1*t4)/100)*document.getElementById('money_'+document.getElementById('reference_money').value).value,round_number);
			<cfif not session.ep.isBranchAuthorization>
				var t5_location = parseFloat(filterNum(document.getElementById('price_protection_location').value,round_number));
				if (isNaN(t5_location)) {t5_location = 0; document.getElementById('price_protection_location').value = 0;}
				t5_location = (t5_location * document.getElementById('money_'+document.getElementById('price_protection_money_location').value).value) / document.getElementById('money_'+document.getElementById('reference_money').value).value;
				document.getElementById('purchase_net_system_location').value = commaSplit((t1-t5_location)* document.getElementById('money_'+document.getElementById('reference_money').value).value,round_number);
			</cfif>
		}
	
		function temizle_virgul1()
		{
			var formName = 'product_cost',
			form = $('form[name="'+ formName +'"]');
			var round_number = $('#round_number').val();
			<cfif session.ep.isBranchAuthorization>
				if (form.find('input#department').val() == '' || form.find('input#department_id').val() == '' || form.find('input#location_id').val() == ''){
					validateMessage('notValid',form.find('input#department_message'),0 );
					return false;
				}else{
						validateMessage('valid',form.find('input#department_message') );
					}
			</cfif>
			if(typeof(process_cat_control) == 'function' && process_cat_control() == false) return false;
			if(parseFloat(filterNum(document.getElementById('price_protection').value)) > 0 && price_protection_control())//fiyat koruma yapilsinmi
			{
				if (form.find('input#td_company').val() == '' || form.find('input#td_company_id').val() == ''){
					validateMessage('notValid',form.find('input#td_company'),0 );
					return false;
				}else{
						validateMessage('valid',form.find('input#td_company') );
					}
				document.getElementById('cost_control').value=1;
			}
			else 
			{
				document.getElementById('cost_control').value=0;
			}
			
			if(document.getElementById('standard_cost').value == '')
				document.getElementById('standard_cost').value = 0;
			if(document.getElementById('purchase_net').value == '')
				document.getElementById('purchase_net').value = 0;
			if(document.getElementById('standard_cost_rate').value == '')
				document.getElementById('standard_cost_rate').value = 0;
			if(document.getElementById('purchase_extra_cost').value == '')
				document.getElementById('purchase_extra_cost').value = 0;
			if(document.getElementById('price_protection').value == '')
				document.getElementById('price_protection').value = 0;
			if(document.getElementById('purchase_net_system').value == '')
				document.getElementById('purchase_net_system').value = 0;
			if(document.getElementById('purchase_extra_cost_system').value == '')
				document.getElementById('purchase_extra_cost_system').value = 0;
	
			document.getElementById('standard_cost').value = filterNum(document.getElementById('standard_cost').value,round_number);
			document.getElementById('purchase_net').value = filterNum(document.getElementById('purchase_net').value,round_number);
			document.getElementById('available_stock').value = filterNum(document.getElementById('available_stock').value);
			document.getElementById('standard_cost_rate').value = filterNum(document.getElementById('standard_cost_rate').value);
			document.getElementById('purchase_extra_cost').value = filterNum(document.getElementById('purchase_extra_cost').value,round_number);
			document.getElementById('partner_stock').value = filterNum(document.getElementById('partner_stock').value);
			document.getElementById('price_protection').value = filterNum(document.getElementById('price_protection').value,round_number);
			document.getElementById('active_stock').value = filterNum(document.getElementById('active_stock').value);
			document.getElementById('product_cost_').value = filterNum(document.getElementById('product_cost_').value);
			document.getElementById('purchase_net_system').value = filterNum(document.getElementById('purchase_net_system').value,round_number);
			document.getElementById('purchase_extra_cost_system').value = filterNum(document.getElementById('purchase_extra_cost_system').value,round_number);
			document.getElementById('purchase_net_system_location').value = filterNum(document.getElementById('purchase_net_system_location').value,round_number);
			if(document.getElementById('price_protection_location')!=undefined)
			{
				if(document.getElementById('price_protection_location').value == '') document.getElementById('price_protection_location').value = 0;
				document.getElementById('price_protection_location').value = filterNum(document.getElementById('price_protection_location').value,round_number);
			}
			
			if(document.getElementById('total_price_prot')!=undefined)
			{
				if(document.getElementById('total_price_prot').value == '') document.getElementById('total_price_prot').value = 0;
				document.getElementById('total_price_prot').value = filterNum(document.getElementById('total_price_prot').value,round_number);
				if(document.getElementById('price_prot_amount').value == '') document.getElementById('price_prot_amount').value = 0;
				document.getElementById('price_prot_amount').value = filterNum(document.getElementById('price_prot_amount').value,round_number);
			}
			document.getElementById('inventory_calc_type').disabled = false;
			document.getElementById('product_cost_money').disabled = false;
	
			return true;
		}
		function get_stock()
		{
			<cfif session.ep.isBranchAuthorization>
				var dep_sql='AND STORE ='+ document.getElementById("department_id").value +' AND STORE_LOCATION ='+ document.getElementById("location_id").value;
			<cfelse>
				var dep_sql='';
			</cfif>
			if(document.getElementById('spect_main_id').value!="" && document.getElementById('spect_name').value!="")
				var spec_query='AND SPECT_VAR_ID='+document.getElementById("spect_main_id").value;
			else
				var spec_query='';
			var gt_stoc=wrk_query('SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK FROM STOCKS_ROW SR WHERE SR.PRODUCT_ID = <cfoutput>#get_product_cost.product_id#</cfoutput> AND PROCESS_DATE <='+js_date(document.getElementById("start_date").value)+' '+spec_query+' '+dep_sql,'dsn2');
			if(gt_stoc.recordcount)
				document.getElementById('available_stock').value = commaSplit(gt_stoc.PRODUCT_TOTAL_STOCK);
			else
				document.getElementById('available_stock').value = '<cfoutput>#tlformat(0)#</cfoutput>';
			
			var get_sevk=wrk_query('SELECT SUM(STOCK_OUT-STOCK_IN) AS MIKTAR FROM STOCKS_ROW WHERE PRODUCT_ID = <cfoutput>#get_product_cost.product_id#</cfoutput> AND PROCESS_TYPE = 81 AND PROCESS_DATE <='+js_date(document.getElementById("start_date").value)+' '+spec_query+' '+dep_sql,'dsn2')
			if(get_sevk.recordcount)
				document.getElementById('active_stock').value= commaSplit(get_sevk.MIKTAR);
			else
				document.getElementById('active_stock').value ='<cfoutput>#tlformat(0)#</cfoutput>';
	
			return history_money()
		}
		
		function price_protection_control()
		{
			if(confirm("<cf_get_lang no ='724.Fiyat Koruma için Fiyat Farkı Faturası Emri Verilsin mı'>?"))
				return true;
			else
				return false;
		}
		
		function total_price_protection_hesapla(type)
		{    
			var round_number = $('#round_number').val(); 
			if(document.getElementById('price_prot_amount').value=="" || document.getElementById('price_prot_amount').value==0) document.getElementById('price_prot_amount').value = 1;
			document.getElementById('price_prot_amount').value=filterNum(document.getElementById('price_prot_amount').value,round_number);
			document.getElementById('price_protection').value=filterNum(document.getElementById('price_protection').value,round_number);
			document.getElementById('total_price_prot').value=filterNum(document.getElementById('total_price_prot').value,round_number);
			if(type == 1)
			{
				 document.getElementById('price_protection').value = document.getElementById('total_price_prot').value / document.getElementById('price_prot_amount').value;
			}else if(type == 2)
			{
				if(document.getElementById('total_price_prot').value!="")
					document.getElementById('price_protection').value = document.getElementById('total_price_prot').value / document.getElementById('price_prot_amount').value;
				else if(document.getElementById('price_protection').value!="")
					document.getElementById('total_price_prot').value = document.getElementById('price_protection').value * document.getElementById('price_prot_amount').value;
			}else if(type == 3)
			{
				if(document.getElementById('price_protection').value!="")
					document.getElementById('total_price_prot').value = document.getElementById('price_protection').value * document.getElementById('price_prot_amount').value;
			}
			document.getElementById('price_prot_amount').value= commaSplit(document.getElementById('price_prot_amount').value,round_number);
			document.getElementById('price_protection').value=commaSplit(document.getElementById('price_protection').value,round_number);
			document.getElementById('total_price_prot').value=commaSplit(document.getElementById('total_price_prot').value,round_number);
		}
		function stock_total()
		{
			document.getElementById('total_stock').value=commaSplit(filterNum(document.getElementById('available_stock').value)+filterNum(document.getElementById('active_stock').value)+filterNum(document.getElementById('partner_stock').value),2);
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'convertcost'>
		$( document ).ready(function() 
			{
				validate().set();
				ses_period_year = <cfoutput>#session.ep.period_year#</cfoutput>;
			});	
		function temizle_virgul1(frm_name)
			{	
			var formName = 'frm_name',
			form = $('form[name="'+ formName +'"]');
			$('form[name = "'+frm_name+'"] #price_protection_location').val(filterNum($('form[name = "'+frm_name+'"] #price_protection_location').val(),4));		
			var form_date_year = list_getat($('form[name = "'+frm_name+'"] #start_date').val(),3,'/');
		
			if(form_date_year != ses_period_year){
				validateMessage('notValid',form.find('input#start_date'),1);
						return false;
			}else{
					validateMessage('valid',form.find('input#start_date'));
				}
			if (frm_name != undefined)
				var _form_name_ = frm_name;
			else
				var _form_name_ = product_cost_y;
			<cfif session.ep.isBranchAuthorization>
				if($('form[name = "'+frm_name+'"] #department').val() == '' || $('form[name = "'+frm_name+'"] #department_id').val() == '' || $('form[name = "'+frm_name+'"] #location_id').val() == '')
				{
					validateMessage('notValid',form.find('input#department'),0 );
					return false;
				}else{
						validateMessage('valid',form.find('input#department') );
					}
			</cfif>
			
			if(typeof(process_cat_control) == 'function' && process_cat_control() == false) return false;
			if(parseFloat(filterNum($('form[name = "'+frm_name+'"] #price_protection').val())) > 0 && price_protection_control())//fiyat koruma yapilsinmi
			{
				if($('form[name = "'+frm_name+'"] #td_company').val() == '' || 	$('form[name = "'+frm_name+'"] #td_company_id').val() == '')
				{
					validateMessage('notValid',form.find('input#td_company'),0 );
					return false;
				}else{
						validateMessage('valid',form.find('input#td_company') );
					}
				$('form[name = "'+frm_name+'"] #cost_control').val(1);
			}
			else 
			{
				$('form[name = "'+frm_name+'"] #cost_control').val(0);
			}
	
	
			if($('form[name = "'+frm_name+'"] #standard_cost').val() == '')
				$('form[name = "'+frm_name+'"] #standard_cost').val(0);
			if($('form[name = "'+frm_name+'"] #purchase_net').val() == '')
				$('form[name = "'+frm_name+'"] #purchase_net').val(0);
			if($('form[name = "'+frm_name+'"] #standard_cost_rate').val() == '')
				$('form[name = "'+frm_name+'"] #standard_cost_rate').val(0);
			if($('form[name = "'+frm_name+'"] #purchase_extra_cost').val() == '')
				$('form[name = "'+frm_name+'"] #purchase_extra_cost').val(0);
			if($('form[name = "'+frm_name+'"] #price_protection').val() == '')
				$('form[name = "'+frm_name+'"] #price_protection').val(0);
			if($('form[name = "'+frm_name+'"] #purchase_net_system').val() == '')
				$('form[name = "'+frm_name+'"] #purchase_net_system').val(0);
			if($('form[name = "'+frm_name+'"] #purchase_extra_cost_system').val() == '')
				$('form[name = "'+frm_name+'"] #purchase_extra_cost_system').val(0);
			if($('form[name = "'+frm_name+'"] #purchase_net_system_location').val() == '')
				$('form[name = "'+frm_name+'"] #purchase_net_system_location').val(0);
	
			$('form[name = "'+frm_name+'"] #standard_cost_rate').val(filterNum($('form[name = "'+frm_name+'"] #standard_cost_rate').val(),4));
			$('form[name = "'+frm_name+'"] #standard_cost').val(filterNum($('form[name = "'+frm_name+'"] #standard_cost').val(),4));
			$('form[name = "'+frm_name+'"] #purchase_extra_cost').val(filterNum($('form[name = "'+frm_name+'"] #purchase_extra_cost').val(),4));
			$('form[name = "'+frm_name+'"] #purchase_net').val(filterNum($('form[name = "'+frm_name+'"] #purchase_net').val(),4));
			$('form[name = "'+frm_name+'"] #purchase_extra_cost_system').val(filterNum($('form[name = "'+frm_name+'"] #purchase_extra_cost_system').val(),4));
			$('form[name = "'+frm_name+'"] #purchase_net_system').val(filterNum($('form[name = "'+frm_name+'"] #purchase_net_system').val(),4));
			$('form[name = "'+frm_name+'"] #purchase_net_system_location').val(filterNum($('form[name = "'+frm_name+'"] #purchase_net_system_location').val(),4));
			$('form[name = "'+frm_name+'"] #partner_stock').val(filterNum($('form[name = "'+frm_name+'"] #partner_stock').val(),4));
			$('form[name = "'+frm_name+'"] #available_stock').val(filterNum($('form[name = "'+frm_name+'"] #available_stock').val(),4));
			$('form[name = "'+frm_name+'"] #active_stock').val(filterNum($('form[name = "'+frm_name+'"] #active_stock').val(),4));
			$('form[name = "'+frm_name+'"] #price_protection').val(filterNum($('form[name = "'+frm_name+'"] #price_protection').val(),4));
			$('form[name = "'+frm_name+'"] #product_cost').val(filterNum($('form[name = "'+frm_name+'"] #product_cost').val(),4));
			$('form[name = "'+frm_name+'"] #price_protection_location').val(filterNum($('form[name = "'+frm_name+'"] #price_protection_location').val(),4));

			return true;
		}
		function price_protection_control(frm_name)
		{
			if(confirm("<cf_get_lang no ='724.Fiyat Koruma için Fiyat Farkı Faturası Emri Verilsin mı'>?"))
				return true;
			else
				return false;
		}
		function hesapla(frm_name)
		{	
			if (frm_name == undefined)
				var _form_name_ = 'product_cost';
			else
				var _form_name_ = frm_name;
				
		var t1 = parseFloat(filterNum($('form[name = "'+frm_name+'"] #purchase_net').val(),4));
			var t2 = parseFloat(filterNum($('form[name = "'+frm_name+'"] #purchase_extra_cost').val(),4));
			var t3 = parseFloat(filterNum($('form[name = "'+frm_name+'"] #standard_cost').val(),4));
			var t4 = parseFloat(filterNum($('form[name = "'+frm_name+'"] #standard_cost_rate').val(),4));
			var t5 = parseFloat(filterNum($('form[name = "'+frm_name+'"] #price_protection').val(),4));
			
			if($('form[name = "'+frm_name+'"] #price_protection_type') != undefined)
				t5 = t5*$('form[name = "'+frm_name+'"] #price_protection_type').val();
			
			if (isNaN(t1)) {t1 = 0; $('form[name = "'+frm_name+'"] #purchase_net').val(0);}
			if (isNaN(t2)) {t2 = 0; $('form[name = "'+frm_name+'"] #purchase_extra_cost').val(0);}
			if (isNaN(t3)) {t3 = 0; $('form[name = "'+frm_name+'"] #standard_cost').val(0);}
			if (isNaN(t4)) {t4 = 0;	$('form[name = "'+frm_name+'"] #standard_cost_rate').val(0);}
			if (isNaN(t5)) {t5 = 0; $('form[name = "'+frm_name+'"] #price_protection').val(0);}
			var q=0;
			if($('form[name = "'+frm_name+'"] #reference_money').val() != '' && ($('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #reference_money').val())) != undefined)
						q=$('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #reference_money').val()).val();
			if(!q>0)q=1;
			
		
			t1 = (t1 * $('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #purchase_net_money').val()).val())/ q;
			t2 = (t2 * $('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #purchase_net_money').val()).val()) / q;
			t3 = (t3 * $('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #standard_cost_money').val()).val()) / q;
			t5 = (t5 * $('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #price_protection_money').val()).val()) / q;
			order_total = t1+t2+t3+((t1*t4)/100)-t5;
			
			$('form[name = "'+frm_name+'"] #product_cost').val(commaSplit(order_total,4));
			$('form[name = "'+frm_name+'"] #purchase_net_system').val(commaSplit((t1-t5)*q,4));
			$('form[name = "'+frm_name+'"] #purchase_extra_cost_system').val(commaSplit((t2+t3+(t1*t4)/100)*q,4));
					
			<cfif not session.ep.isBranchAuthorization>
				var t5_location = parseFloat(filterNum($('form[name = "'+frm_name+'"] #price_protection').val(),4));
				if (isNaN(t5_location)) {t5_location = 0; //product_cost_y.price_protection_location.value = 0;
				}
				t5_location = (t5_location * $('form[name = "'+frm_name+'"] #money_'+$('form[name = "'+frm_name+'"] #price_protection_money_location').val()).val()) / q;
				$('form[name = "'+frm_name+'"] #purchase_net_system_location').val(commaSplit((t1-t5_location)*q,4));
	
			</cfif>
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'addcostsuggest'>
		$( document ).ready(function() 
			{
				ses_period_year = <cfoutput>#session.ep.period_year#</cfoutput>;
				validate().set();
				hesapla();
			});	
		<cfif not session.ep.isBranchAuthorization>
			function location_price_protec()
			{
				if($('form[name = "product_cost_y"] #department_id').val() != "" && $('form[name = "product_cost_y"] #department').val() != "" && $('form[name = "product_cost_y"] #location_id').val() != "")
				{
					goster(price_protec_td1);
					goster(price_protec_td2);
				}
				else
				{
					gizle(price_protec_td1);
					gizle(price_protec_td2);
				}
			}
		</cfif>
		
		function open_spec_popup()
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=product_cost_y.spect_main_id&field_name=product_cost_y.spect_name&is_display=1&stock_id=<cfoutput>#GET_STOCK.STOCK_ID#</cfoutput>&function_name=get_stock','list');
		}
	
		function history_money(){
			var h_date=js_date(document.product_cost_y.start_date.value);
			<cfoutput query="GET_MONEY">
				var get_his_rate=wrk_query("SELECT (RATE2/RATE1) RATE,MONEY MONEY_TYPE FROM MONEY_HISTORY WHERE VALIDATE_DATE <= "+h_date+" AND MONEY = '#money#' AND PERIOD_ID = #session.ep.period_id# ORDER BY VALIDATE_DATE DESC,MONEY_HISTORY_ID DESC","dsn");
				if(get_his_rate.recordcount)
					eval('document.product_cost_y.money_#money#').value=get_his_rate.RATE[0];
				else
					eval('document.product_cost_y.money_#money#').value=#wrk_round(rate2/rate1,4)#;
			</cfoutput>
			hesapla();
			return true;
		}
		function hesapla()
		{
			var t1 = parseFloat(filterNum($('form[name = "product_cost_y"] #purchase_net').val(),4));
			var t2 = parseFloat(filterNum($('form[name = "product_cost_y"] #purchase_extra_cost').val(),4));
			var t3 = parseFloat(filterNum($('form[name = "product_cost_y"] #standard_cost').val(),4));
			var t4 = parseFloat(filterNum($('form[name = "product_cost_y"] #standard_cost_rate').val(),4));
			var t5 = parseFloat(filterNum($('form[name = "product_cost_y"] #price_protection').val(),4));
			
			if($('form[name = "product_cost_y"] #price_protection_type') != undefined)
				t5 = t5*$('form[name = "product_cost_y"] #price_protection_type').val();
			if (isNaN(t1)) {t1 = 0; $('form[name = "product_cost_y"] #purchase_net').val(0);}
			if (isNaN(t2)) {t2 = 0; $('form[name = "product_cost_y"] #purchase_extra_cost').val(0);}
			if (isNaN(t3)) {t3 = 0; $('form[name = "product_cost_y"] #standard_cost').val(0);}
			if (isNaN(t4)) {t4 = 0;	$('form[name = "product_cost_y"] #standard_cost_rate').val(0);}
			if (isNaN(t5)) {t5 = 0; $('form[name = "product_cost_y"] #price_protection').val(0);}
			var q=0;
			if($('form[name = "product_cost_y"] #reference_money').val() != '' && ($('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #reference_money').val())) != undefined)
						q=$('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #reference_money').val()).val();
			if(!q>0)q=1;
			
			t1 = (t1 * $('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #purchase_net_money').val()).val())/ q;
			t2 = (t2 * $('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #purchase_net_money').val()).val()) / q;
			t3 = (t3 * $('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #standard_cost_money').val()).val()) / q;
			t5 = (t5 * $('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #price_protection_money').val()).val()) / q;
			order_total = t1+t2+t3+((t1*t4)/100)-t5;
			
			$('form[name = "product_cost_y"] #product_cost').val(commaSplit(order_total,4));
			$('form[name = "product_cost_y"] #purchase_net_system').val(commaSplit((t1-t5)*q,4));
			$('form[name = "product_cost_y"] #purchase_extra_cost_system').val(commaSplit((t2+t3+(t1*t4)/100)*q,4));
			
			if(parseFloat(filterNum($('form[name = "product_cost_y"] #price_protection').val())) > 0)
				goster(tr_1);
			else
				gizle(tr_1);
			<cfif not session.ep.isBranchAuthorization>
				location_price_protec();			
				var t5_location = parseFloat(filterNum($('form[name = "product_cost_y"] #price_protection_location').val(),4));
				if (isNaN(t5_location)) {t5_location = 0; //product_cost_y.price_protection_location.value = 0;
				}
				t5_location = (t5_location * $('form[name = "product_cost_y"] #money_'+$('form[name = "product_cost_y"] #price_protection_money_location').val()).val()) / q;
				$('form[name = "product_cost_y"] #purchase_net_system_location').val(commaSplit((t1-t5_location)*q,4));
	
			</cfif>
			return true;
		}
		
		function temizle_virgul()
		{
			var formName = 'product_cost_y',
			form = $('form[name="'+ formName +'"]');
			

	$('form[name = "product_cost_y"] #product_cost').val(filterNum($('form[name = "product_cost_y"] #product_cost').val(),4));
		var form_date_year = list_getat($('form[name = "product_cost_y"] #start_date').val(),3,'/');
			if(form_date_year != ses_period_year){
				validateMessage('notValid',form.find('input#start_date'),1);
						return false;
			}else{
					validateMessage('valid',form.find('input#start_date'));
				}
				var _form_name_ = product_cost_y;
			<cfif session.ep.isBranchAuthorization>
				if($('form[name = "product_cost_y"] #department').val() == '' || $('form[name = "product_cost_y"] #department_id').val() == '' || $('form[name = "product_cost_y"] #location_id').val() == '')
				{
					validateMessage('notValid',form.find('input#department'),0 );
					return false;
				}else{
						validateMessage('valid',form.find('input#department') );
					}
			</cfif>
			
			if(parseFloat(filterNum($('form[name = "product_cost_y"] #price_protection').val())) > 0 && price_protection_control())//fiyat koruma yapilsinmi
			{
				if($('form[name = "product_cost_y"] #td_company').val() == '' || 	$('form[name = "product_cost_y"] #td_company_id').val() == '')
				{
					validateMessage('notValid',form.find('input#td_company'),0 );
					return false;
				}else{
						validateMessage('valid',form.find('input#td_company') );
					}
				$('form[name = "product_cost_y"] #cost_control').val(1);
			}
			else 
			{
				$('form[name = "product_cost_y"] #cost_control').val(0);
			}
	
	
			if($('form[name = "product_cost_y"] #standard_cost').val() == '')
				$('form[name = "product_cost_y"] #standard_cost').val(0);
			if($('form[name = "product_cost_y"] #purchase_net').val() == '')
				$('form[name = "product_cost_y"] #purchase_net').val(0);
			if($('form[name = "product_cost_y"] #standard_cost_rate').val() == '')
				$('form[name = "product_cost_y"] #standard_cost_rate').val(0);
			if($('form[name = "product_cost_y"] #purchase_extra_cost').val() == '')
				$('form[name = "product_cost_y"] #purchase_extra_cost').val(0);
			if($('form[name = "product_cost_y"] #price_protection').val() == '')
				$('form[name = "product_cost_y"] #price_protection').val(0);
			if($('form[name = "product_cost_y"] #purchase_net_system').val() == '')
				$('form[name = "product_cost_y"] #purchase_net_system').val(0);
			if($('form[name = "product_cost_y"] #purchase_extra_cost_system').val() == '')
				$('form[name = "product_cost_y"] #purchase_extra_cost_system').val(0);
			if($('form[name = "product_cost_y"] #purchase_net_system_location').val() == '')
				$('form[name = "product_cost_y"] #purchase_net_system_location').val(0);
	
	
			$('form[name = "product_cost_y"] #standard_cost_rate').val(filterNum($('form[name = "product_cost_y"] #standard_cost_rate').val(),4));
			$('form[name = "product_cost_y"] #standard_cost').val(filterNum($('form[name = "product_cost_y"] #standard_cost').val(),4));
			$('form[name = "product_cost_y"] #purchase_extra_cost').val(filterNum($('form[name = "product_cost_y"] #purchase_extra_cost').val(),4));
			$('form[name = "product_cost_y"] #purchase_net').val(filterNum($('form[name = "product_cost_y"] #purchase_net').val(),4));
			$('form[name = "product_cost_y"] #purchase_extra_cost_system').val(filterNum($('form[name = "product_cost_y"] #purchase_extra_cost_system').val(),4));
			$('form[name = "product_cost_y"] #purchase_net_system').val(filterNum($('form[name = "product_cost_y"] #purchase_net_system').val(),4));
			$('form[name = "product_cost_y"] #purchase_net_system_location').val(filterNum($('form[name = "product_cost_y"] #purchase_net_system_location').val(),4));
			$('form[name = "product_cost_y"] #partner_stock').val(filterNum($('form[name = "product_cost_y"] #partner_stock').val(),4));
			$('form[name = "product_cost_y"] #available_stock').val(filterNum($('form[name = "product_cost_y"] #available_stock').val(),4));
			$('form[name = "product_cost_y"] #active_stock').val(filterNum($('form[name = "product_cost_y"] #active_stock').val(),4));
			$('form[name = "product_cost_y"] #price_protection').val(filterNum($('form[name = "product_cost_y"] #price_protection').val(),4));
			$('form[name = "product_cost_y"] #product_cost').val(filterNum($('form[name = "product_cost_y"] #product_cost').val(),4));
			$('form[name = "product_cost_y"] #price_protection_location').val(filterNum($('form[name = "product_cost_y"] #price_protection_location').val(),4));
	
			return true;
		}
		function price_protection_control()
		{
			if(confirm("<cf_get_lang no ='724.Fiyat Koruma için Fiyat Farkı Faturası Emri Verilsin mi'>?"))
				return true;
			else
				return false;
		}
		function get_stock()
		{
			<cfif session.ep.isBranchAuthorization>
				var dep_sql='AND STORE ='+ document.product_cost_y.department_id.value +' AND STORE_LOCATION ='+ document.product_cost_y.location_id.value;
			<cfelse>
				var dep_sql='';
			</cfif>
			if(document.product_cost_y.spect_main_id.value!="" && document.product_cost_y.spect_name.value!="")
				var spec_query='AND SPECT_VAR_ID='+document.product_cost_y.spect_main_id.value;
			else
				var spec_query='';
			var gt_stoc=wrk_query('SELECT SUM(SR.STOCK_IN - SR.STOCK_OUT) AS PRODUCT_TOTAL_STOCK FROM STOCKS_ROW SR WHERE SR.PRODUCT_ID = <cfoutput>#attributes.pid#</cfoutput> AND PROCESS_DATE <='+js_date(document.product_cost_y.start_date.value)+' '+spec_query+' '+dep_sql,'dsn2');
			if(gt_stoc.recordcount)
				product_cost_y.available_stock.value = commaSplit(gt_stoc.PRODUCT_TOTAL_STOCK);
			else
				product_cost_y.available_stock.value = '<cfoutput>#tlformat(0)#</cfoutput>';
			
			var get_sevk=wrk_query('SELECT SUM(STOCK_OUT-STOCK_IN) AS MIKTAR FROM STOCKS_ROW WHERE PRODUCT_ID = <cfoutput>#attributes.pid#</cfoutput> AND PROCESS_TYPE = 81 AND PROCESS_DATE <='+js_date(document.product_cost_y.start_date.value)+' '+spec_query+' '+dep_sql,'dsn2')
			if(get_sevk.recordcount)
				product_cost_y.active_stock.value= commaSplit(get_sevk.MIKTAR);
			else
				product_cost_y.active_stock.value ='<cfoutput>#tlformat(0)#</cfoutput>';
			return history_money();
		}
	<cfelseif isdefined("attributes.event") and attributes.event is 'costdetail'>
	<!--- //Grafik Bolumu --->
		function open_action(type,process_id,pid)
		{
			if(type == 1)
				windowopen('<cfoutput>#request.self#?fuseaction=invoice.form_add_bill_purchase&event=upd&iid='+process_id+'</cfoutput>','wide');
			else if(type == 2)
				windowopen('<cfoutput>#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id='+process_id+'</cfoutput>','wide');
			else if(type == 3)
				windowopen('<cfoutput>#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id='+process_id+'</cfoutput>','wide');
	
			else if(type == 4)
			{
				var p_orderid = pid;
				windowopen('<cfoutput>#request.self#?fuseaction=prod.list_results&event=upd&p_order_id='+p_orderid +'&pr_order_id='+process_id+'</cfoutput>','wide');
			}
			else if(type == 5)
				windowopen('<cfoutput>#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid='+process_id+'</cfoutput>','wide');
			else if(type == 6)
				windowopen('<cfoutput>#request.self#?fuseaction=stock.add_stock_in_from_customs&event=upd&ship_id='+process_id+'</cfoutput>','wide');
			else if(type == 8)
				windowopen('<cfoutput>#request.self#?fuseaction=invoice.form_add_bill&event=upd&iid='+process_id+'</cfoutput>','wide');
			else if(type == 7)
				windowopen('<cfoutput>#request.self#?fuseaction=stock.form_upd_stock_exchange&exchange_id='+process_id+'</cfoutput>','wide');
			else if(type == 9)
				windowopen('<cfoutput>#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id='+process_id+'</cfoutput>','wide');
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'product.list_product_cost';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'product/display/list_product_cost.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
	
	WOStruct['#attributes.fuseaction#']['systemObject'] = structNew();
	if(not (attributes.event is 'addcostsuggest' or attributes.event is 'list' or attributes.event is 'costdetail'))
	WOStruct['#attributes.fuseaction#']['systemObject']['processStage'] = true;
	
	if(attributes.event contains 'upd')
	WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = get_product_cost.process_stage;
	else
	WOStruct['#attributes.fuseaction#']['systemObject']['processStageSelected'] = '';
	
	WOStruct['#attributes.fuseaction#']['systemObject']['isTransaction'] = false;
	WOStruct['#attributes.fuseaction#']['systemObject']['dataSourceName'] = dsn1;
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'product.form_add_product_cost';
	if(attributes.event is 'add' and get_periods.inventory_calc_type eq 3){
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/form_add_product_cost_gpa.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'product/query/add_product_cost.cfm';
	}
	else if(attributes.event is 'add' and get_periods.inventory_calc_type eq 1){
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'product/form/form_add_product_cost_fifo.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '';
	}
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'product.list_product_cost&event=add&pid=';
	WOStruct['#attributes.fuseaction#']['add']['formName'] = 'product_cost';
	
	WOStruct['#attributes.fuseaction#']['add']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['add']['buttons']['saveFunction'] = 'temizle_virgul() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['addcostsuggest'] = structNew();
	WOStruct['#attributes.fuseaction#']['addcostsuggest']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['addcostsuggest']['fuseaction'] = 'product.popup_add_product_cost_suggestion';
	WOStruct['#attributes.fuseaction#']['addcostsuggest']['filePath'] = 'product/form/add_product_cost_suggestion.cfm';
	WOStruct['#attributes.fuseaction#']['addcostsuggest']['queryPath'] = 'product/query/add_product_cost_suggestion.cfm';
	WOStruct['#attributes.fuseaction#']['addcostsuggest']['nextEvent'] = 'product.list_product_cost&event=add&pid=';
	WOStruct['#attributes.fuseaction#']['addcostsuggest']['formName'] = 'product_cost_y';
	
	WOStruct['#attributes.fuseaction#']['addcostsuggest']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['addcostsuggest']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['addcostsuggest']['buttons']['saveFunction'] = 'temizle_virgul() && validate().check()';
	
	WOStruct['#attributes.fuseaction#']['costdetail'] = structNew();
	WOStruct['#attributes.fuseaction#']['costdetail']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['costdetail']['fuseaction'] = 'product.popup_list_product_cost_detail';
	WOStruct['#attributes.fuseaction#']['costdetail']['filePath'] = 'product/display/list_product_cost_detail.cfm';
	WOStruct['#attributes.fuseaction#']['costdetail']['queryPath'] = 'product/display/list_product_cost_detail.cfm';
	WOStruct['#attributes.fuseaction#']['costdetail']['nextEvent'] = 'product.list_product_cost&event=costdetail&pid=';
	
	if(attributes.event is 'convertcost'){
	WOStruct['#attributes.fuseaction#']['convertcost'] = structNew();
	WOStruct['#attributes.fuseaction#']['convertcost']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['convertcost']['fuseaction'] = 'product.popup_convert_suggest';
	WOStruct['#attributes.fuseaction#']['convertcost']['filePath'] = 'product/display/convert_suggest_add_cost.cfm';
	WOStruct['#attributes.fuseaction#']['convertcost']['queryPath'] = 'product/query/add_product_cost.cfm';
	WOStruct['#attributes.fuseaction#']['convertcost']['nextEvent'] = 'product.list_product_cost&event=add&pid=';
	WOStruct['#attributes.fuseaction#']['convertcost']['formName'] = 'product_cost_suggest#attributes.form_crntrow#';
	
	WOStruct['#attributes.fuseaction#']['convertcost']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['convertcost']['buttons']['save'] = 1;
	WOStruct['#attributes.fuseaction#']['convertcost']['buttons']['saveFunction'] = "temizle_virgul1('product_cost_suggest#attributes.form_crntrow#') && validate().check()";
	
	WOStruct['#attributes.fuseaction#']['convertcost']['buttons']['delete'] = 1;
	WOStruct['#attributes.fuseaction#']['convertcost']['buttons']['deleteEvent'] = 'delcostsuggest';
	WOStruct['#attributes.fuseaction#']['convertcost']['buttons']['deleteUrl'] = '#request.self#?fuseaction=product.list_product_cost&event=delcostsuggest';
	}

	if(isdefined("attributes.event") and (attributes.event is 'convertcost' or attributes.event is 'delcostsuggest'))       
	{
		WOStruct['#attributes.fuseaction#']['delcostsuggest'] = structNew();
		WOStruct['#attributes.fuseaction#']['delcostsuggest']['window'] = 'emptypopup';
		if(not isdefined('attributes.formSubmittedController'))
		WOStruct['#attributes.fuseaction#']['delcostsuggest']['fuseaction'] = 'product.emptypopup_del_suggest&suggest_id=#attributes.suggest_id#';
		WOStruct['#attributes.fuseaction#']['delcostsuggest']['filePath'] = 'product/query/del_suggest_cost.cfm';
		WOStruct['#attributes.fuseaction#']['delcostsuggest']['queryPath'] = 'product/query/del_suggest_cost.cfm';
		WOStruct['#attributes.fuseaction#']['delcostsuggest']['nextEvent'] = 'product.list_product_cost&event=add&pid';
	}

	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'product.popup_form_upd_product_cost';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'product/form/upd_product_cost.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'product/query/upd_product_cost.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'product.list_product_cost&event=upd&pcid=';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'pcid=##attributes.pcid##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.pcid##';
	WOStruct['#attributes.fuseaction#']['upd']['recordQuery'] = 'get_product_cost';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryRecordEmp'] = 'record_emp';
	WOStruct['#attributes.fuseaction#']['upd']['recordQueryIsConsumer'] = '1';	
	WOStruct['#attributes.fuseaction#']['upd']['formName'] = 'product_cost';
	
	if(isdefined("attributes.event") and attributes.event is 'upd'){
	WOStruct['#attributes.fuseaction#']['upd']['buttons'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['update'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['updateFunction'] = 'temizle_virgul1() && validate().check()';
	if (not len(get_product_cost.action_type)){
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['delete'] = 1;
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteEvent'] = 'del';
	WOStruct['#attributes.fuseaction#']['upd']['buttons']['deleteUrl'] = '#request.self#?fuseaction=product.list_product_cost&event=del';
	}
	}
	if(isdefined("attributes.event") and (attributes.event is 'upd' or attributes.event is 'del'))       
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		if(not isdefined('attributes.formSubmittedController'))
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'product.emptypopup_del_product_cost&cost_id=#get_product_cost.PRODUCT_COST_ID#&product_id=#get_product_cost.PRODUCT_ID#&spec_main_id=#get_product_cost.SPECT_MAIN_ID#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'product/query/del_product_cost.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'product/query/del_product_cost.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'product.list_product_cost&event=add&pid';
	}
	
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	if(isdefined("attributes.event") and attributes.event is 'add')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'] = structNew();
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['text'] = '#lang_array.item[121]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][0]['href'] = "#request.self#?fuseaction=stock.list_stock&event=upd&pid=#attributes.pid#";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['text'] = '#lang_array_main.item[1352]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][1]['href'] = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_product&event=det&pid=#attributes.pid#";
		i=2;
		if (get_product.is_production is 1)
		{
			if(get_stock.recordcount)
			{
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][i]['text'] = '#lang_array.item[93]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][i]['href'] = "#request.self#?fuseaction=prod.list_product_tree&event=add&stock_id=#get_stock.STOCK_ID#";
				i=i+1;
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][i]['text'] = '#lang_array.item[74]#';
				tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=prod.popup_list_prod_tree_costs&stock_id=#get_stock.stock_id#','wide');";
				i=i+1;																			
			}		
		}
		if(not listfindnocase(denied_pages,'product.detail_product_price')){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][i]['text'] = '#lang_array.item[105]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][i]['href'] = "#request.self#?fuseaction=product.detail_product_price&pid=#attributes.pid#";
			i=i+1;
		}
		if(not session.ep.isBranchAuthorization){
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][i]['text'] = '#lang_array.item[281]#';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['menus'][i]['onClick'] = "windowopen('#request.self#?fuseaction=product.list_product_cost&event=costdetail&pid=#attributes.pid#','list');";
			i=i+1;
		}
	}
	
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCT_COST';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRODUCT_COST_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-start_date','item-inventory_calc_type']";
	
	if(isdefined("attributes.event") and (attributes.event is 'addcostsuggest' or attributes.event is 'convertcost')) {
	WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] = true;
	WOStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList'] = 'addcostsuggest,convertcost';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageTableName'] = 'PRODUCT_COST_SUGGESTION';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageIdentityColumn'] = 'PRODUCT_COST_SUGGESTION_ID';
	WOStruct['#attributes.fuseaction#']['systemObject']['pageSettings'] = "['item-inventory_calc_type','item-start_date']";
	}
</cfscript>