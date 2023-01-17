<cfsetting showdebugoutput="no">
<cfquery name="get_station_times" datasource="#dsn#">
    SELECT TOP 1 * FROM SETUP_SHIFTS WHERE IS_PRODUCTION = 1 AND FINISHDATE > #DATEADD('h',session.ep.TIME_ZONE,now())#
</cfquery>
<cfif get_station_times.recordcount>
	<cfset _shift_id_ = get_station_times.SHIFT_ID>
<cfelse>
    <cfset _shift_id_ = 1>
</cfif>
<!--- Bu sayfa sipariş ekleme sayfasından geliyor,sayfadan listeler gönderilirken gruplanarak gönderilecek! --->
<cfinclude template="../../workdata/get_main_spect_id.cfm">
<!---<cfinclude template="../../objects/functions/get_production_times.cfm">--->
<cfparam name="attributes.row_id" default="1">
<div id="kisit_teo">
    <cf_box id="deliver_date_info#attributes.row_id#" title="#getLang('','Termin',36798)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfif stock_id_list eq ""><font color="#_font_#"><cf_get_lang dictionary_id="57734.Seçiniz"></font><cf_get_lang dictionary_id="29467.Üretilen Ürün">
        <cfelse>
            <cf_grid_list>
                <cfloop list="#stock_id_list#" index="s_s_m"><!--- Stok_Spec_Miktar --->
                    <cfset n_now = ''>
                    <cfset 'startdate_fn0' =''>
                    <thead>
                        <tr>
                            <th colspan="5" nowrap>  
                                <!--- stock_id_list +=n_stock_id+'-'+n_spect_id+'-'+n_amount+'-'+n_is_production+','; --->
                                <cfset production_row_count = 0>
                                <cfset stock_id = ListGetAt(s_s_m,1,'-')>
                                <cfif len(ListGetAt(s_s_m,2,'-'))>
                                    <cfset spect_id = ListGetAt(s_s_m,2,'-')>
                                <cfelse>
                                    <cfset spect_id = 0>    
                                </cfif>
                                <cfif len(ListGetAt(s_s_m,3,'-'))>
                                    <cfset order_amount = ListGetAt(s_s_m,3,'-')>
                                <cfelse>
                                    <cfset order_amount = 0>    
                                </cfif>
                                <cfset is_production = ListGetAt(s_s_m,4,'-')>
                                <cfset production_row_count = 0>
                                    <cfif is_production eq 1><!--- Üretilen Bir Ürün İse --->
                                        <!--- Üretim Siparişler Sayfasından Geliyorsa--->
                                        <cfif isdefined('attributes.from_p_order_list') and not isdefined("attributes.is_from_order")><!--- Üretim Siparişler Sayfasından Geliyorsa Spect_main_id gelir,siparişte ise gelirse spect_var_id gelir. --->
                                            <cfif len(ListGetAt(s_s_m,2,'-')) or spect_id eq 0><!--- Eğerki Main Spec Varsa.. --->
                                                <cfset attributes.spect_main_id = ListGetAt(s_s_m,2,'-')>
                                            <cfelse>
                                                <cfset _new_main_spec_id_ = get_main_spect_id(stock_id)>
                                                <cfset attributes.spect_main_id = _new_main_spec_id_.SPECT_MAIN_ID>
                                            </cfif>
                                        <cfelse><!--- Satış Siparişlerden Geliyorsa. --->
                                            <cfif not len(spect_id) or spect_id eq 0><!--- Spect Seçilmemiş ise Ürüne --->
                                                <cfset _new_main_spec_id_ = get_main_spect_id(stock_id)>
                                                <cfset attributes.spect_main_id = _new_main_spec_id_.SPECT_MAIN_ID>
                                            <cfelse>
                                                <cfquery name="GET_SPECT_MAIN_ID" datasource="#dsn3#">
                                                    SELECT SPECT_MAIN_ID FROM SPECTS WHERE SPECT_VAR_ID = #spect_id# 
                                                </cfquery>
                                                <cfset attributes.spect_main_id = GET_SPECT_MAIN_ID.SPECT_MAIN_ID>
                                            </cfif>
                                        </cfif>
                                        <cfquery name="get_station_id0" datasource="#dsn3#"><!--- ana ürünün istasyonu --->
                                            SELECT  
                                                TOP 1 
                                                WS_P_ID,
                                                STATION_ID
                                            FROM 
                                                WORKSTATIONS_PRODUCTS WSP,
                                                WORKSTATIONS WS 
                                            WHERE 
                                                WS.STATION_ID = WSP.WS_ID AND 
                                                WSP.STOCK_ID = #stock_id#
                                        </cfquery>
                                        <cfif get_station_id0.recordcount>
                                            <cfset product_values0 = '#stock_id#,#spect_id#,0,0,#attributes.spect_main_id#'>
                                            <cfset product_amount0= '#order_amount#'>
                                            <cfset station_id0=get_station_id0.STATION_ID>
                                            <cfscript>
                                                stations_list = '';
                                                stock_and_spect_list ='';
                                                deep_level = 0;
                                            function get_subs(spect_main_id)
                                                {
                                                    SQLStr = '
                                                            SELECT
                                                                S.STOCK_CODE,
                                                                ISNULL(S.IS_PURCHASE,0) IS_PURCHASE,
                                                                ISNULL(S.IS_PRODUCTION,0)IS_PRODUCTION,
                                                                ISNULL(SMR.RELATED_MAIN_SPECT_ID,0)AS RELATED_ID,
                                                                SMR.STOCK_ID,
                                                                SMR.AMOUNT,
                                                                S.PRODUCT_NAME 
                                                            FROM 
                                                                SPECT_MAIN_ROW SMR,
                                                                STOCKS S
                                                            WHERE 
                                                                S.STOCK_ID = SMR.STOCK_ID AND
                                                                SPECT_MAIN_ID = #spect_main_id#
                                                            ORDER BY
                                                                SMR.LINE_NUMBER,
                                                                S.PRODUCT_NAME			
                                                        ';
                                                    query1 = cfquery(SQLString : SQLStr, Datasource : dsn3);
                                                    stock_id_ary='';
                                                    for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
                                                    {
                                                        stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'█');
                                                        stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
                                                        stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_NAME[str_i],'§');
                                                        stock_id_ary=listappend(stock_id_ary,query1.AMOUNT[str_i],'§');
                                                        stock_id_ary=listappend(stock_id_ary,query1.IS_PRODUCTION[str_i],'§');
                                                        stock_id_ary=listappend(stock_id_ary,query1.IS_PURCHASE[str_i],'§');
                                                        stock_id_ary=listappend(stock_id_ary,query1.STOCK_CODE[str_i],'§');
                                                    }
                                                    return stock_id_ary;
                                                }
                                                function writeRow(_next_spect_main_id_,_next_stock_id_,_next_product_name_,_next_stock_amount_,deep_level,_next_is_production_,_next_is_purchase_,_next_stock_code_){
                                                    if(deep_level eq 1)
                                                        'product_amount#deep_level#' = '#order_amount#*#_next_stock_amount_#';// satır bazında malzeme ihtiyaçları
                                                    else
                                                        'product_amount#deep_level#' = '#Evaluate('product_amount#deep_level-1#')#*#_next_stock_amount_#';
                                                    //writeoutput('#_next_stock_id_#---#Evaluate("product_amount#deep_level#")#<br/>');
                                                    //ürün bazında malzeme ihtiyaçları başlangıç
                                                    if(not isdefined('product_spect_total_amount_#_next_stock_id_#'))//genel anlamda malzeme ihtiyaçları
                                                        {
                                                        'product_spect_total_amount_#_next_stock_id_#' = Evaluate(Evaluate('product_amount#deep_level#'));//ürününlerin miktarı
                                                        stock_and_spect_list = ListAppend(stock_and_spect_list,'#_next_stock_id_#_#_next_spect_main_id_#_#_next_is_production_#_#_next_is_purchase_#',',');//ürünlerimizin listesi
                                                        }
                                                    else
                                                        {
                                                        //eğer aynı ürün ağaç içinde birden fazla kullanılmış ise ürünü kendi içinde topluyoruz.
                                                        'product_spect_total_amount_#_next_stock_id_#' = Evaluate('product_spect_total_amount_#_next_stock_id_#') + Evaluate(Evaluate('product_amount#deep_level#'));
                                                        }
                                                    /*if(not isdefined('product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#'))//genel anlamda malzeme ihtiyaçları
                                                        {
                                                        'product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#' = Evaluate(Evaluate('product_amount#deep_level#'));//ürününlerin miktarı
                                                        stock_and_spect_list = ListAppend(stock_and_spect_list,'#_next_stock_id_#_#_next_spect_main_id_#_#_next_is_production_#_#_next_is_purchase_#',',');//ürünlerimizin listesi
                                                        }
                                                    else
                                                        {
                                                        //eğer aynı ürün ağaç içinde birden fazla kullanılmış ise ürünü kendi içinde topluyoruz.
                                                        'product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#' = Evaluate('product_spect_total_amount_#_next_stock_id_#_#_next_spect_main_id_#') + Evaluate(Evaluate('product_amount#deep_level#'));
                                                        }
                                                    */	
                                                    //ürün bazında malzeme ihtiyaçları bitiş
                                                    if(_next_is_production_ eq 1){
                                                        production_row_count = production_row_count+1;
                                                        'product_values#production_row_count#' ='#_next_stock_id_#,#_next_spect_main_id_#,#deep_level#,#production_row_count#';
                                                        'product_amount#production_row_count#' ='#Evaluate(Evaluate("product_amount#deep_level#"))#';
                                                        SQL_PRODUCT_STATION_ID ='SELECT  TOP 1 WS_P_ID,STATION_ID,STATION_NAME,PRODUCTION_TYPE,MIN_PRODUCT_AMOUNT,SETUP_TIME FROM WORKSTATIONS_PRODUCTS WSP,WORKSTATIONS WS WHERE WS.STATION_ID = WSP.WS_ID AND WSP.STOCK_ID = #_next_stock_id_#';
                                                        GET_PRODUCT_STATION_ID = cfquery(SQLString : SQL_PRODUCT_STATION_ID, Datasource : dsn3);
                                                        "station_id#production_row_count#" = "#GET_PRODUCT_STATION_ID.STATION_ID#,#GET_PRODUCT_STATION_ID.PRODUCTION_TYPE#,#GET_PRODUCT_STATION_ID.MIN_PRODUCT_AMOUNT#,#GET_PRODUCT_STATION_ID.SETUP_TIME#,#GET_PRODUCT_STATION_ID.WS_P_ID#";
                                                    }	 
                                                }
                                                function writeTree(next_spect_main_id)
                                                {
                                                    var i = 1;
                                                    var sub_products = get_subs(next_spect_main_id);
                                                    deep_level = deep_level + 1;
                                                    for (i=1; i lte listlen(sub_products,'█'); i = i+1)
                                                    {
                                                        leftSpace = RepeatString('&nbsp;', deep_level*5);
                                                        _next_spect_main_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
                                                        _next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
                                                        _next_product_name_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
                                                        _next_stock_amount_ = ListGetAt(ListGetAt(sub_products,i,'█'),4,'§');
                                                        _next_is_production_ = ListGetAt(ListGetAt(sub_products,i,'█'),5,'§');
                                                        _next_is_purchase_ = ListGetAt(ListGetAt(sub_products,i,'█'),6,'§');
                                                        _next_stock_code_ = ListGetAt(ListGetAt(sub_products,i,'█'),7,'§');
                                                        writeRow(_next_spect_main_id_,_next_stock_id_,_next_product_name_,_next_stock_amount_,deep_level,_next_is_production_,_next_is_purchase_,_next_stock_code_);
                                                        if(_next_spect_main_id_ gt 0 and _next_is_production_ eq 1)
                                                            writeTree(_next_spect_main_id_);
                                                    }
                                                        deep_level = deep_level-1;
                                                }
                                                if(attributes.spect_main_id gt 0)
                                                    writeTree(attributes.spect_main_id);//fonksiyon burada çağırılıyor 
                                            </cfscript>
                                            <!---//////////////////////////// Alt Üretim Emirleri Sıralanıyor.//////////////////// --->
                                            <cfset xxx_list = ''><!--- Bu liste iç içe kırılımı olan ürünlerde alttaki ürünlerin daha önce üretilmesi için kullanılıyor. --->
                                            <cfset new_production_row_count_list = ''><!--- Bu değişken ise ürünlerin hangi sırada üretileceğini tutar --->
                                            <cfloop  to="#production_row_count#" from="1" index="indexx">
                                                <cfif (ListGetAt(Evaluate('product_values#indexx#'),3,',') eq 1  and len(xxx_list))><!--- 1.ci kırılımdaki ürünler ise --->
                                                    <cfif ListLen(xxx_list,'-')>
                                                        <cfloop  from="#ListLen(xxx_list,'-')#" to="1" index="real_index" step="-1"><!--- burdaki loop'u listeyi tersine çevirmek için kullanıyoruz. --->
                                                            <cfset new_production_row_count_list = ListAppend(new_production_row_count_list,ListGetAt(xxx_list,real_index,'-'),',')>
                                                        </cfloop>
                                                    </cfif>
                                                    <cfset xxx_list =''><!--- 1.ci kırılımdaki ürüne denk geldiğinde bu listeyi sıfırlıyoruz,sonraki 1.ci kırılım ürünleride kendi içinde gruplasın diye! --->
                                                </cfif>
                                                <cfset xxx_list = ListAppend(xxx_list,'#ListGetAt(Evaluate('product_values#indexx#'),4,',')#','-')>
                                                <cfif indexx eq production_row_count><!--- Son Kırılımdaki üründe eğer üretiliyorsa onuda ekliyoruz. --->
                                                    <cfset new_production_row_count_list = ListAppend(new_production_row_count_list,indexx,',')>
                                                </cfif>
                                            </cfloop>
                                            <cfset new_production_row_count_list = ListAppend(new_production_row_count_list,0,',')><!--- Son olarak ana ürün üretileceği için onun numarası olan 0'ı ekliyoruz. --->
                                            <!---//////////////////////////// Alt Üretim Emirleri Sıralanıyor./////////////////////Sıralandı! --->
                                            <!--- *******Üretim Zamanları Oluştuluyor************ --->
                                            
                                            <cfloop list="#new_production_row_count_list#" index="indexx">
                                                <cfif listlen(Evaluate('station_id#indexx#'),',') eq 4><!--- bu kontrol sonrada kalkacak! --->
                                                    <cfset setup_time = ListGetAt(Evaluate('station_id#indexx#'),4,',')>
                                                <cfelse>
                                                    <cfset setup_time = 0 >
                                                </cfif>
                                                <cfif isdefined('station_id#indexx#') and listlen(Evaluate('station_id#indexx#'),',')><!--- Ürünlerin üretileceği istasyonlar var ise! --->
                                                    <cfscript> 
                                                        'production_times#indexx#'=get_production_times(
                                                            station_id : ListGetAt(Evaluate('station_id#indexx#'),1,','),
                                                            shift_id : _shift_id_,
                                                            stock_id : ListGetAt(Evaluate('product_values#indexx#'),1,','),
                                                            amount : Evaluate(Evaluate('product_amount#indexx#')),
                                                            production_type : 0,
                                                            setup_time_min : setup_time,
                                                            _now_ : n_now
                                                            
                                                        );
                                                    </cfscript>
                                                    <cfset x_now_ = date_add('h',session.ep.TIME_ZONE,now())>
                                                    <cfif not isdefined('production_times#indexx#')><!--- Olası bir hata olduğunda zamanı ayarlasın --->
                                                        <cfset 'production_times#indexx#' = "#DateFormat(x_now_,'YYYYMMDD')#,#TimeFormat(x_now_,timeformat_style)#,#DateFormat(date_add('h',1,x_now_),'YYYYMMDD')#,#TimeFormat(date_add('h',1,x_now_),timeformat_style)#">
                                                    </cfif>
                                                    <cfset s_yil = Left(ListGetAt(Evaluate('production_times#indexx#'),1,','),4)>
                                                    <cfset s_ay =  mid(ListGetAt(Evaluate('production_times#indexx#'),1,','),5,2)>
                                                    <cfset s_gun = mid(ListGetAt(Evaluate('production_times#indexx#'),1,','),7,2)>
                                                    <cfset s_saat =ListFirst(ListGetAt(Evaluate('production_times#indexx#'),2,','),':')>
                                                    <cfset s_dakika =ListLast(ListGetAt(Evaluate('production_times#indexx#'),2,','),':')>
                                                    
                                                    <cfset f_yil = Left(ListGetAt(Evaluate('production_times#indexx#'),3,','),4)>
                                                    <cfset f_ay =  mid(ListGetAt(Evaluate('production_times#indexx#'),3,','),5,2)>
                                                    <cfset f_gun = mid(ListGetAt(Evaluate('production_times#indexx#'),3,','),7,2)>
                                                    <cfset f_saat =ListFirst(ListGetAt(Evaluate('production_times#indexx#'),4,','),':')>
                                                    <cfset f_dakika =ListLast(ListGetAt(Evaluate('production_times#indexx#'),4,','),':')>
                                                    
                                                    <cfset 'startdate_fn#indexx#' = CreateDateTime(s_yil,s_ay,s_gun,s_saat,s_dakika,0)>
                                                    <cfset 'finishdate_fn#indexx#' = CreateDateTime(f_yil,f_ay,f_gun,f_saat,f_dakika,0)>
                                                    
                                                    <cfif isdefined('XYZ') and XYZ gt ListGetAt(Evaluate('product_values#indexx#'),3,',') ><!--- <font color="red">*</font> --->
                                                        <cfset n_now = '' >
                                                    <cfelse>
                                                    <cfset n_now = Evaluate('finishdate_fn#indexx#') >
                                                    </cfif>
                                                    <cfset XYZ = ListGetAt(Evaluate('product_values#indexx#'),3,',')>
                                                    <cfquery name="ADD_PRODUCTION_ORDER_CASH" datasource="#DSN3#">
                                                        INSERT INTO
                                                            PRODUCTION_ORDERS_CASH
                                                            (
                                                                START_DATE,
                                                                FINISH_DATE,
                                                                STATION_ID
                                                            )
                                                        VALUES
                                                            (
                                                                #Evaluate('startdate_fn#indexx#')#,
                                                                #Evaluate('finishdate_fn#indexx#')#,
                                                                #ListGetAt(Evaluate('station_id#indexx#'),1,',')#
                                                            )
                                                    </cfquery>
                                                </cfif>
                                            </cfloop>
                                            <cfoutput>
                                                <cfquery name="get_stocks" datasource="#dsn3#">
                                                    SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #ListGetAt(Evaluate('product_values#indexx#'),1,',')#
                                                </cfquery>
                                                <cfif isdefined('startdate_fn0') and len(Evaluate('startdate_fn0'))>
                                                    <b>#get_stocks.PRODUCT_NAME#</b> <a style="cursor:pointer;text-align:left;" onclick="gonder_date('#DateFormat(Evaluate('finishdate_fn0'),dateformat_style)#','#DateFormat(Evaluate('startdate_fn0'),dateformat_style)#','#trim(s_saat)#','#trim(s_dakika)#','#trim(f_saat)#','#trim(f_dakika)#')">#DateFormat(Evaluate('finishdate_fn0'),dateformat_style)# - #TimeFormat(Evaluate('finishdate_fn0'),timeformat_style)#</a>
                                                <cfelse>
                                                    <b>#get_stocks.PRODUCT_NAME#</b> <cf_get_lang dictionary_id='60385.Ürününde Ya da Alt Ürünlerinde İstasyonlar Seçilmemiş'> !
                                                </cfif>
                                            </cfoutput>
                                            <!--- <cfoutput>#Evaluate('startdate_fn0')#</cfoutput><br/> --->
                                            <!--- *******Üretim Zamanları Oluştuluyor************Oluşturuldu! --->
                                        <cfelse>
                                            <cfquery name="get_stocks_" datasource="#dsn3#">
                                                SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #stock_id#
                                            </cfquery>
                                            <font color="red"><b><cfoutput>#get_stocks_.PRODUCT_NAME#</cfoutput></b></font><cf_get_lang dictionary_id="36793.Ürünün Üretileceği İstasyon Tanımlanmamış!">  
                                        </cfif>
                                    <cfelseif isdefined("attributes.offer_date")><!--- Üretilmeyen bir üründe tedarik süresi gelecek --->
                                        <cfquery name="get_strategy" datasource="#dsn3#">
                                            SELECT PROVISION_TIME FROM STOCK_STRATEGY WHERE STOCK_ID = #stock_id# AND DEPARTMENT_ID IS NULL
                                        </cfquery>
                                        <cfif get_strategy.recordcount and len(get_strategy.provision_time)>
                                            <cfquery name="get_stocks" datasource="#dsn3#">
                                                SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #stock_id#
                                            </cfquery>
                                            <cfset finishdate_fn0 = dateadd('d',get_strategy.provision_time,dateformat(createodbcdatetime(attributes.offer_date),dateformat_style))>
                                            <cfif not isdefined("max_finish_date") or (isdefined("max_finish_date") and finishdate_fn0 gt max_finish_date)>
                                                <cfset max_finish_date = finishdate_fn0>
                                            </cfif>
                                            <cfset startdate_fn0 = attributes.offer_date>
                                            <cfset s_dakika = 0>
                                            <cfset f_dakika = 0>
                                            <cfset f_saat = 0>
                                            <cfset s_saat = 0>
                                            <cfoutput>
                                                <b>#get_stocks.PRODUCT_NAME#</b> <a style="cursor:pointer;" onclick="gonder_date('#DateFormat(Evaluate('finishdate_fn0'),dateformat_style)#','#DateFormat(Evaluate('startdate_fn0'),dateformat_style)#','#trim(s_saat)#','#trim(s_dakika)#','#trim(f_saat)#','#trim(f_dakika)#')">#DateFormat(finishdate_fn0,dateformat_style)#</a>
                                            </cfoutput>
                                        <cfelse>
                                            <cfquery name="get_stocks_" datasource="#dsn3#">
                                                SELECT PRODUCT_NAME FROM STOCKS WHERE STOCK_ID = #stock_id#
                                            </cfquery>
                                            <font color="red"><b><cfoutput>#get_stocks_.PRODUCT_NAME#</cfoutput></b></font><cf_get_lang dictionary_id="36796.Ürünün Tedarik Süreci Tanımlanmamış">!   
                                        </cfif>
                                    </cfif>
                            </th>
                        </tr>
                    </thead>
                </cfloop>
                <cfquery name="DELETE_PRODUCTION_ORDER_CASH" datasource="#DSN3#">
                    DELETE FROM PRODUCTION_ORDERS_CASH
                </cfquery>
                <!--- Sayfa Üretim Sipariş Listesinden GEliyorsa Kısıt Teorisine Göre Ürünün Birleşenlerinden Eksik Olanlar Varsa Hesaplanacak. --->
                <cfif isdefined('attributes.from_p_order_list')>
                    <thead>
                        <tr>
                            <th colspan="5" class="form-title"><cf_get_lang dictionary_id='60384.Malzeme Kısıtı'></th>
                        </tr>
                        <tr>
                            <th><cf_get_lang dictionary_id="57657.Ürün"></th>
                            <th><cf_get_lang dictionary_id="57647.Spec"></th>
                            <th>E.S</th>
                            <th>E.S.</th>
                            <th>T.Tar.</th>
                        </tr>
                    </thead>
                        <cfif isdefined('stock_and_spect_list') and  ListLen(stock_and_spect_list,',')><!--- Oluşan yeni listemizde her ürünümüz ve spect'imiz bir kere bulunuyor. --->
                        <cfquery name="_PRODUCT_TOTAL_STOCK_" datasource="#DSN2#"><!--- Ürünlerin stock durumlarını liste yöntemi ile alıyoruz. --->
                            SELECT 
                                ISNULL(SUM(PRODUCT_STOCK),0) AS PRODUCT_STOCK,
                                STOCK_ID
                            FROM 
                                GET_STOCK
                            WHERE
                            <cfloop list="#stock_and_spect_list#" index="fff">
                                (STOCK_ID = #ListGetAt(fff,1,'_')#)
                                <cfif listlast(stock_and_spect_list) neq fff > OR</cfif> 
                            </cfloop>
                            GROUP BY STOCK_ID 
                        </cfquery>
                        <cfquery name="getStockStrategy" datasource="#dsn3#">
                            SELECT
                                DISTINCT
                                SS.STOCK_ID,
                                ISNULL(SS.PROVISION_TIME,0) AS PROVISION_TIME 
                            FROM
                                STOCK_STRATEGY SS
                            WHERE
                                SS.STOCK_ID IN(<cfloop list="#stock_and_spect_list#" index="jjj">#ListGetAt(jjj,1,'_')#<cfif listlast(stock_and_spect_list) neq jjj >,</cfif></cfloop>) AND
                                ISNULL(SS.DEPARTMENT_ID,0)=0
                        </cfquery>
                        <cfscript>
                        max_provision_time =0;
                        for(strteg_ind=1;strteg_ind lte getStockStrategy.recordcount;strteg_ind=strteg_ind+1)
                            'stock_strategy#getStockStrategy.STOCK_ID[strteg_ind]#'='#getStockStrategy.PROVISION_TIME[strteg_ind]#';
                        </cfscript>
                        <cfquery name="_GET_STOCK_RESERVED_" datasource="#DSN3#"><!--- Ürünün rezerve durumlarını liste yöntemi ile çekiyoruz. --->
                            SELECT
                                ISNULL(SUM(STOCK_ARTIR),0) AS ARTAN,
                                ISNULL(SUM(STOCK_AZALT),0) AS AZALAN,
                                STOCK_ID<!--- ,ISNULL(SPECT_MAIN_ID,0) AS SPECT_MAIN_ID --->
                            FROM
                                GET_STOCK_RESERVED<!--- _SPECT --->
                            WHERE
                                <cfloop list="#stock_and_spect_list#" index="ccc">
                                (STOCK_ID = #ListGetAt(ccc,1,'_')#
                                <!--- <cfif ListGetAt(ccc,2,'_') GT 0>
                                    AND SPECT_MAIN_ID =  #ListGetAt(ccc,2,'_')#
                                <cfelse>
                                    AND(SPECT_MAIN_ID IS NULL OR  SPECT_MAIN_ID = 0)
                                </cfif> --->
                                )
                                <cfif listlast(stock_and_spect_list) neq ccc > OR</cfif>
                            </cfloop>
                            GROUP BY STOCK_ID<!--- ,SPECT_MAIN_ID --->
                        </cfquery>
                        <cfquery name="_GET_PROD_RESERVED_" datasource="#DSN3#"><!--- Ürünün rezerve durumlarını liste yöntemi ile çekiyoruz. --->
                            SELECT
                                ISNULL(SUM(STOCK_ARTIR),0) AS ARTAN,
                                ISNULL(SUM(STOCK_AZALT),0) AS AZALAN,
                                STOCK_ID<!---,ISNULL(SPECT_MAIN_ID,0)  AS SPECT_MAIN_ID --->
                            FROM
                                GET_PRODUCTION_RESERVED<!--- _SPECT --->
                            WHERE
                                <cfloop list="#stock_and_spect_list#" index="ccc">
                                (STOCK_ID = #ListGetAt(ccc,1,'_')#
                                <!--- <cfif ListGetAt(ccc,2,'_') GT 0>
                                    AND SPECT_MAIN_ID =  #ListGetAt(ccc,2,'_')#
                                <cfelse>
                                    AND(SPECT_MAIN_ID IS NULL OR  SPECT_MAIN_ID = 0)
                                </cfif> --->
                                )
                                <cfif listlast(stock_and_spect_list) neq ccc > OR</cfif>
                            </cfloop>
                            GROUP BY STOCK_ID<!--- ,SPECT_MAIN_ID --->
                        </cfquery>
                        <cfquery name="_location_based_total_stock_" datasource="#dsn2#">
                            SELECT
                                STOCK_ID,
                                SUM(STOCK_IN - SR.STOCK_OUT) AS TOTAL_LOCATION_STOCK
                            FROM
                                STOCKS_ROW SR,
                                #dsn_alias#.STOCKS_LOCATION SL 
                            WHERE
                                (
                                <cfloop list="#stock_and_spect_list#" index="ccc">
                                STOCK_ID = #ListGetAt(ccc,1,'_')# <cfif listlast(stock_and_spect_list) neq ccc > OR</cfif>
                                </cfloop>
                                )
                                AND
                                SR.STORE = SL.DEPARTMENT_ID AND
                                SR.STORE_LOCATION = SL.LOCATION_ID AND
                                NO_SALE = 1
                        GROUP BY STOCK_ID
                        </cfquery>
                        <cfscript>
                            for(sayac=1; sayac lte _location_based_total_stock_.recordcount; sayac=sayac+1)//stock durumların için çektiğimiz quey'den gelen değerler set ediliyor
                            {
                                if(len(_location_based_total_stock_.TOTAL_LOCATION_STOCK[sayac]))
                                    'location_based_total_stock_amount#_location_based_total_stock_.STOCK_ID[sayac]#' = _location_based_total_stock_.TOTAL_LOCATION_STOCK[sayac];
                                else
                                    'location_based_total_stock_amount#_location_based_total_stock_.STOCK_ID[sayac]#' = 0;	
                            }
                            for(sayac=1; sayac lte _PRODUCT_TOTAL_STOCK_.recordcount; sayac=sayac+1)//stock durumların için çektiğimiz quey'den gelen değerler set ediliyor
                            {
                                if(len(_PRODUCT_TOTAL_STOCK_.PRODUCT_STOCK[sayac]))
                                    'prod_stock_#_PRODUCT_TOTAL_STOCK_.STOCK_ID[sayac]#' = _PRODUCT_TOTAL_STOCK_.PRODUCT_STOCK[sayac];
                                else
                                    'prod_stock_#_PRODUCT_TOTAL_STOCK_.STOCK_ID[sayac]#' = 0;	
                            }
                            for(index=1; index lte _GET_STOCK_RESERVED_.recordcount; index=index+1)//Rezerve durumları için çektiğimiz quey'den gelen değerler set ediliyor
                            {
                                if(len(_GET_STOCK_RESERVED_.ARTAN[index]))
                                'PRODUCT_ARTAN_#_GET_STOCK_RESERVED_.STOCK_ID[index]#' = _GET_STOCK_RESERVED_.ARTAN[index];
                                else
                                'PRODUCT_ARTAN_#_GET_STOCK_RESERVED_.STOCK_ID[index]#' = 0;
                                if(len(_GET_STOCK_RESERVED_.AZALAN[index]))
                                    'PRODUCT_AZALAN_#_GET_STOCK_RESERVED_.STOCK_ID[index]#' = _GET_STOCK_RESERVED_.AZALAN[index];
                                else
                                    'PRODUCT_AZALAN_#_GET_STOCK_RESERVED_.STOCK_ID[index]#' = 0;
                            }
                            for(index=1; index lte _GET_PROD_RESERVED_.recordcount; index=index+1)//üRETİM Rezerve durumları için çektiğimiz quey'den gelen değerler set ediliyor
                            {
                                if(len(_GET_PROD_RESERVED_.ARTAN[index]))
                                'PROD_PRODUCT_ARTAN_#_GET_PROD_RESERVED_.STOCK_ID[index]#' = _GET_PROD_RESERVED_.ARTAN[index];
                                else
                                'PROD_PRODUCT_ARTAN_#_GET_PROD_RESERVED_.STOCK_ID[index]#' = 0;
                                if(len(_GET_PROD_RESERVED_.AZALAN[index]))
                                'PROD_PRODUCT_AZALAN_#_GET_PROD_RESERVED_.STOCK_ID[index]#' = _GET_PROD_RESERVED_.AZALAN[index];
                                else
                                'PROD_PRODUCT_AZALAN_#_GET_PROD_RESERVED_.STOCK_ID[index]#' = 0;
                            }
                        </cfscript>
                        <cfif listlen(stock_and_spect_list)><!--- Stock ve spect isimleri ise bildiğimzi lisletelem yöntemi ile yapılıyor. --->
                        <cfset stock_id_lists_new = ''>
                        <cfset spect_id_lists_new = ''>
                        <cfloop list="#stock_and_spect_list#" index="jjj">
                            <cfset stock_id_lists_new =  ListAppend(stock_id_lists_new,ListGetAt(ListFirst(jjj),1,'_'),',')>
                            <cfif ListGetAt(ListFirst(jjj),2,'_') gt 0>
                                <cfset spect_id_lists_new = ListAppend(spect_id_lists_new,ListGetAt(ListFirst(jjj),2,'_'),',')>
                            </cfif>
                        </cfloop>
                        <cfset stock_id_lists_new = listsort(listdeleteduplicates(stock_id_lists_new),'numeric','ASC',',')>
                        <cfset spect_id_lists_new = listsort(listdeleteduplicates(spect_id_lists_new),'numeric','ASC',',')>
                        <cfquery name="get_stocks_name" datasource="#dsn3#">
                            SELECT PRODUCT_NAME,STOCK_ID FROM STOCKS WHERE STOCK_ID IN (#stock_id_lists_new#) ORDER BY STOCK_ID
                        </cfquery>
                        <cfset _stocks_name_list_ = listsort(listdeleteduplicates(valuelist(get_stocks_name.STOCK_ID,',')),'numeric','ASC',',')>
                        <cfif listlen(spect_id_lists_new)>
                            <cfquery name="get_spect_name" datasource="#dsn3#">
                                SELECT SPECT_MAIN_NAME,SPECT_MAIN_ID FROM SPECT_MAIN WHERE SPECT_MAIN_ID IN (#spect_id_lists_new#) ORDER BY SPECT_MAIN_ID
                            </cfquery>
                            <cfset _spect_name_list_ = listsort(listdeleteduplicates(valuelist(get_spect_name.SPECT_MAIN_ID,',')),'numeric','ASC',',')>
                        </cfif>
                        </cfif>
                        <tbody>
                            <!--- Bu kısım yazdırma kısmı --->
                            <cfloop list="#stock_and_spect_list#" index="sss" delimiters=","><!--- stock ve spect id'ye göre gruplanan ürünlerin listesi döndürlmeye başlıyor. --->
                            <!--- #sss# == stock_id,spect_id,is_production,is_purchase,stock_code değerlerini tutan 5li bir liste--->
                            <cfoutput>
                                <cfif ListGetAt(sss,2,'_') gt 0><cfset _font_ = 'red'><cfelse><cfset _font_ = 'black'></cfif>
                                <cfset my_value = '#ListGetAt(sss,1,'_')#'>
                                <cfif isdefined('prod_stock_#my_value#') and len(evaluate("prod_stock_#my_value#"))>
                                    <cfset SATILABILIR_STOCK = evaluate("prod_stock_#my_value#") >
                                <cfelse>
                                    <cfset SATILABILIR_STOCK = 0 >
                                </cfif>
                                <cfif isdefined('PRODUCT_ARTAN_#ListGetAt(sss,1,'_')#')>
                                    <cfset SATILABILIR_STOCK = SATILABILIR_STOCK +  Evaluate('PRODUCT_ARTAN_#ListGetAt(sss,1,'_')#')>
                                </cfif>
                                <cfif isdefined('PRODUCT_AZALAN_#ListGetAt(sss,1,'_')#')>
                                    <cfset SATILABILIR_STOCK = SATILABILIR_STOCK -  Evaluate('PRODUCT_AZALAN_#ListGetAt(sss,1,'_')#')>
                                </cfif>
                                <cfif isdefined('PROD_PRODUCT_ARTAN_#ListGetAt(sss,1,'_')#')>
                                    <cfset SATILABILIR_STOCK = SATILABILIR_STOCK +  Evaluate('PROD_PRODUCT_ARTAN_#ListGetAt(sss,1,'_')#')>
                                </cfif>
                                <cfif isdefined('PROD_PRODUCT_AZALAN_#ListGetAt(sss,1,'_')#')>
                                    <cfset SATILABILIR_STOCK = SATILABILIR_STOCK -  Evaluate('PROD_PRODUCT_AZALAN_#ListGetAt(sss,1,'_')#')>
                                </cfif>
                                <cfif isdefined('location_based_total_stock_amount#ListGetAt(sss,1,'_')#') >
                                    <cfset SATILABILIR_STOCK = SATILABILIR_STOCK - Evaluate('location_based_total_stock_amount#ListGetAt(sss,1,'_')#')>
                                </cfif>                    
                                <!--- Satılabilir Stoğa Göre Eksik Stok. --->
                                <cfset ss_eksik_stok =Evaluate("product_spect_total_amount_#my_value#")-SATILABILIR_STOCK>
                                <cfif isdefined('prod_stock_#my_value#')>
                                    <cfset GERCEK_STOK = Evaluate('prod_stock_#my_value#')>
                                <cfelse>
                                    <cfset GERCEK_STOK = 0>
                                </cfif>
                                <cfset eksik_stok =Evaluate("product_spect_total_amount_#my_value#")-GERCEK_STOK>
                                <cfif eksik_stok gt 0><cfset eksik_stok_font ='red'><cfelse><cfset eksik_stok_font ='black'></cfif>
                                <cfif eksik_stok gt 0 or ss_eksik_stok gt 0>
                                    <tr>
                                        <td width="100">
                                            <!--- #ListGetAt(sss,1,'_')# === stock_id anlamına geliyor. --->
                                            <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&sid=#ListGetAt(sss,1,'_')#','list');">
                                                <font color="#_font_#">#get_stocks_name.PRODUCT_NAME[listfind(_stocks_name_list_,ListGetAt(sss,1,'_'),',')]#</font>
                                            </a>
                                        </td>
                                        <td width="100">
                                            <cfif ListGetAt(ListFirst(sss),2,'_') gt 0>
                                                <!--- ListGetAt(ListFirst(sss),2,'_') SPECT_ID ANLAMINA GELİYOR. --->
                                                <cfif isdefined('get_spect_name')>
                                                    <a href="javascript://"  class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_spect_main&spect_main_id=#ListGetAt(sss,2,'_')#','list');">
                                                        #get_spect_name.SPECT_MAIN_NAME[listfind(_spect_name_list_,ListGetAt(sss,2,'_'),',')]#
                                                    </a>
                                                </cfif>
                                            </cfif>
                                        </td>
                                        <td align="right" style="text-align:right;"><cfif eksik_stok gt 0><font color="#eksik_stok_font#">#tlformat(eksik_stok)#</font></cfif></td>
                                        <cfif isdefined('stock_strategy#ListGetAt(sss,1,'_')#')><!--- Ürün için stok stratejisi var ise,bu değer 9,8,8 gibi bir ifade döndürür burda 1.minumumstok,2.tedarik süresi ve 3.Min.Sipariş Miktarı'nı ifade eder. --->
                                        <cfset _provision_time__ = Evaluate('stock_strategy#ListGetAt(sss,1,'_')#')><cfelse><cfset _provision_time__ = 0></cfif>   
                                        <td align="right" style="text-align:right;"><cfif ss_eksik_stok gt 0><font color="red">#tlformat(ss_eksik_stok)#</font></cfif></td>
                                        <td align="right" style="text-align:right;" alt="En Uzun Tedarik Süresi">
                                            #DateFormat(date_add('d',_provision_time__,now()),dateformat_style)#
                                        </td>
                                    </tr>
                                </cfif>
                            </cfoutput>
                            </cfloop>
                        </tbody>
                        </cfif>
                    </cfif>
            </cf_grid_list>
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
	function gonder_date(gelen_Tarih,gelen_Tarih_Start,s_saat,s_dakika,f_saat,f_dakika)
	{
		<cfif not (isdefined('attributes.from_p_order_list')) or isdefined("attributes.is_from_order")><!--- Sayfa hem satış sipariş detayından hemde Üretim-Siparişler listesinden çağırılıyor bu sebeb ile üretim-siparişlerden geliyorsa sadece göstersin function bir işlem görmesin. --->
			<cfif isdefined("attributes.offer_date") and isdefined("max_finish_date")>
				if(document.getElementById('deliverdate') != undefined)
					document.getElementById('deliverdate').value = <cfoutput>"#dateformat(max_finish_date,dateformat_style)#"</cfoutput>;
			<cfelse>	
				if(document.getElementById('deliverdate') != undefined)
					document.getElementById('deliverdate').value =gelen_Tarih;
			</cfif>
			if(document.getElementById('finish_date') != undefined)
				document.getElementById('finish_date').value =gelen_Tarih;
			if(gelen_Tarih_Start != undefined && document.getElementById('start_date') != undefined)
			{
				document.getElementById('start_date').value =gelen_Tarih_Start;
				document.getElementById('start_h').value =s_saat;
				document.getElementById('start_m').value =s_dakika;
				document.getElementById('finish_h').value =f_saat;
				document.getElementById('finish_m').value =f_dakika;
			}
			<cfif not isdefined("attributes.is_from_order")>
				<cfoutput>
					document.getElementById('deliver_date_info#attributes.row_id#').style.display='none';
				</cfoutput>
			<cfelse>
				document.getElementById('deliver_date_info').style.display='none';
			</cfif>
		</cfif>
	}
</script>
<cfabort>