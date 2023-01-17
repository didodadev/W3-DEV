<cfparam name="attributes.date1" default="#dateformat('01/01/#session_base.period_year#','dd/mm/yyyy')#">
<cfparam name="attributes.date2" default="#dateformat('31/12/#session_base.period_year#','dd/mm/yyyy')#">
<cfparam name="attributes.maxrows" default="25" />
<cfif not isdefined("attributes.is_camp_info")><cfset attributes.is_camp_info= 0></cfif>
<cfif not isdefined("attributes.is_process_type")><cfset attributes.is_process_type= 0></cfif>

<cfif attributes.is_process_type eq 1>
	<cfset attributes.is_process_cat = 1>
</cfif>
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT 
		MONEY 
	FROM 
		SETUP_MONEY 
	WHERE 
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"> AND MONEY_STATUS = 1
</cfquery>
<cfset session_base_money = session_base.money>
<cfset session_base_money2 = session_base.money2>

<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
    <cfset date1 = attributes.date1>
<cfelse>
	<cfset date1 = "01/01/#session_base.period_year#">
</cfif>
<cfif isdefined('attributes.date2') and isdate(attributes.date2)>
    <cfset date2 = attributes.date2>
<cfelse>
	<cfset date2 = "31/12/#session_base.period_year#">
</cfif>
<cfset attributes.selected_company = isdefined("attributes.selected_company") and len(attributes.selected_company) and isNumeric(attributes.selected_company)?attributes.selected_company:session_base.our_company_id>
<cfset yilbasi = createodbcdatetime('#session_base.period_year#-01-01')>
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.other_money" default="">
<cfparam name="attributes.form_submit" default="1">

<div class="col-lg-12">
    <cfform name="list_ekstre" method="post" action="#GET_PAGE.FRIENDLY_URL#">
            <cfquery name="get_comp_name" datasource="#dsn#">
                SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.selected_company#">
            </cfquery>
            <p><cfoutput>#get_comp_name.COMPANY_NAME#</cfoutput></p>
        <div class="form-row align-items-center">
            <input type="hidden" name="form_submit" id="form_submit" value="1">
            <input type="hidden" name="ap" id="ap" value="9">
            <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#session_base.company_id#</cfoutput>">
            <input type="hidden" name="company" id="company" readonly="yes" value="<cfoutput><cfif isdefined("session.pp")>#get_par_info(session.pp.company_id,1,0,0)#<cfelseif isdefined("session.ww")>#get_cons_info(session.ww.userid,0,0)#</cfif></cfoutput>">
            <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("session.ww.userid")><cfoutput>#session.ww.userid#</cfoutput></cfif>">
            <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and isdefined("attributes.member_type") and len(attributes.member_type) and attributes.member_type is 'employee'><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
            <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("session.pp")>partner<cfelseif isdefined("session.ww")>consumer</cfif>">
            		

            <div class="col-auto pb-2">
                <label class="sr-only" for="camp_name"></label>
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang no='101.Baslangiç Tarihi Girmelisiniz !'></cfsavecontent>
                    <cfinput type="text" name="date1" id="date1" class="form-control none-border-r" style=" width: 110px; " value="#date1#" required="yes" validate="eurodate" message="#message#">
                    <div class="input-group-text append-icon">
                        <cf_wrk_date_image date_field="date1">
                    </div>
                </div>
            </div>				
            <div class="col-auto pb-2">
                <label class="sr-only" for="camp_name"></label>
                <div class="input-group">
                    <cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi Girmelisiniz !'></cfsavecontent>
                    <cfinput type="text" name="date2" id="date2" class="form-control none-border-r" style=" width: 110px; " value="#date2#" required="yes" validate="eurodate" message="#message#">
                    <div class="input-group-text append-icon">
                        <cf_wrk_date_image date_field="date2">
                    </div>
                </div>
            </div>
            <div class="col-auto pb-2">
                <label class="sr-only" for="camp_name"></label>
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" id="maxrows" class="form-control" value="#attributes.maxrows#" required="yes" validate="integer" range="1,500" message="#message#" maxlength="3" style="width:50px;">
            </div>
            <div class="col-auto pb-2">
                <input type="checkbox" class="" name="is_doviz" id="is_doviz" <cfif isdefined('attributes.is_doviz')>checked</cfif>>
                <label class="form-check-label" for="is_doviz"><cf_get_lang_main no='383.İşlem Dövizli'></label>
            </div>
            <div class="col-auto">
                <input class="btn btn-color-2 mb-2" type="button" value="<cf_get_lang dictionary_id='57650.Dök'>" onclick="kontrol();">
            </div>
        </div>		
    </cfform>  
    <cfif isdefined('attributes.form_submit')>
        <cfif isdefined('session.pp')>
            <cfparam name="attributes.company_id" default="#session_base.company_id#">
            <cfparam name="attributes.company" default="#get_par_info(session_base.company_id,1,0,0)#">
            <cfset member_type ="partner">
        <cfelseif isdefined("session.ww")>
            <cfset member_type ="consumer">
        </cfif>
        <cfquery name="GET_PERIODS" datasource="#DSN#">
            SELECT 
                PERIOD_ID,
                PERIOD_YEAR,
                OUR_COMPANY_ID
            FROM 
                SETUP_PERIOD 
            WHERE 
                OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.selected_company#"> AND
                PERIOD_YEAR >= #dateformat(attributes.date1,'yyyy')# AND 
                PERIOD_YEAR <= #dateformat(attributes.date2,'yyyy')#
            ORDER BY 
                OUR_COMPANY_ID,
                PERIOD_YEAR 
        </cfquery> 
        <cfif not get_periods.recordcount>
            <script type="text/javascript">
                alert("<cf_get_lang_main no ='447.Dönem Kaydı Bulunmamaktadır'>!");
            </script>
            <cfabort>
        </cfif>
        <cfloop query="get_periods">
            <cfset new_period = get_periods.period_id>
            <cfset new_dsn = '#dsn#_#get_periods.period_year#_#get_periods.our_company_id#'>
            <cfif isdefined('attributes.form_submit')>	
                <cfquery name="CARI_ROWS" datasource="#new_dsn#">
                    SELECT 
                        ACTION_ID,
                        ACTION_TYPE_ID,
                        CARI_ACTION_ID,
                        ACTION_TABLE,
                        OTHER_MONEY,
                        PAPER_NO,
                        ACTION_NAME,
                        PROCESS_CAT,
                        TO_CMP_ID,
                        TO_CONSUMER_ID,
                        DUE_DATE,
                        ACTION_DETAIL,
                        ACTION_DATE AS ACTION_DATE, 
                        0 AS BORC, 
                        0 AS BORC2,
                        0 AS BORC_OTHER,
                        ACTION_VALUE AS ALACAK,
                        ACTION_VALUE_2 AS ALACAK2,
                        OTHER_CASH_ACT_VALUE AS ALACAK_OTHER,
                        0 AS PAY_METHOD,
                        IS_PROCESSED,
                        (SELECT TOP 1 CAMP_HEAD FROM #dsn3_alias#.CAMPAIGNS CC WHERE CC.CAMP_STARTDATE <= CARI_ROWS.ACTION_DATE AND CC.CAMP_FINISHDATE >= CARI_ROWS.ACTION_DATE) AS CAMP_HEAD
                    FROM 
                        CARI_ROWS
                    WHERE
                        <cfif isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner'>
                            FROM_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
                        <cfelseif isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer'>
                            FROM_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
                        <cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
                            FROM_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
                        </cfif>
                        <cfif isDefined("attributes.action_type") and len(attributes.action_type)>
                            ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#"> AND 
                        </cfif>
                        <cfif isDefined("attributes.other_money") and len(attributes.other_money)>
                            OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money#"> AND 
                        </cfif>
                        1=1				
                    UNION
                    
                    SELECT
                        ACTION_ID,
                        ACTION_TYPE_ID,
                        CARI_ACTION_ID,
                        ACTION_TABLE,
                        OTHER_MONEY,
                        PAPER_NO,
                        ACTION_NAME,
                        PROCESS_CAT,
                        TO_CMP_ID,
                        TO_CONSUMER_ID,
                        DUE_DATE,
                        ACTION_DETAIL,
                        ACTION_DATE AS ACTION_DATE, 
                        ACTION_VALUE AS BORC,
                        ACTION_VALUE_2 AS BORC2,
                        OTHER_CASH_ACT_VALUE AS BORC_OTHER,
                        0 AS ALACAK,
                        0 AS ALACAK2,
                        0 AS ALACAK_OTHER,
                        0 AS PAY_METHOD,
                        IS_PROCESSED,
                        (SELECT TOP 1 CAMP_HEAD FROM #dsn3_alias#.CAMPAIGNS CC WHERE CC.CAMP_STARTDATE <= CARI_ROWS.ACTION_DATE AND CC.CAMP_FINISHDATE >= CARI_ROWS.ACTION_DATE) AS CAMP_HEAD
                    FROM 
                        CARI_ROWS
                    WHERE
                        <cfif isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner'>
                            TO_CMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
                        <cfelseif isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer'>
                            TO_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
                        <cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
                            TO_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND
                        </cfif>
                        <cfif isDefined("attributes.action_type") and len(attributes.action_type)>
                            ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type#"> AND
                        </cfif>
                        <cfif isDefined("attributes.other_money") and len(attributes.other_money)>
                            OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money#">  AND
                        </cfif>
                        1=1 
                    ORDER BY
                        ACTION_DATE,
                        ACTION_ID
                </cfquery>
                <cfquery name="CARI_ROWS_ALL" dbtype="query">
                    SELECT
                        ACTION_ID,
                        ACTION_TYPE_ID,
                        CARI_ACTION_ID,
                        ACTION_TABLE,
                        OTHER_MONEY,
                        PAPER_NO,
                        ACTION_NAME,
                        PROCESS_CAT,
                        TO_CMP_ID,
                        TO_CONSUMER_ID,
                        DUE_DATE,
                        ACTION_DETAIL,
                        ACTION_DATE, 
                        BORC,
                        BORC2,
                        BORC_OTHER,
                        ALACAK,
                        ALACAK2,
                        ALACAK_OTHER,
                        PAY_METHOD,
                        IS_PROCESSED,
                        CAMP_HEAD
                    FROM 
                        CARI_ROWS
                    WHERE
                        ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> 
                    <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
                        AND ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
                    </cfif>
                </cfquery>
            <cfelse>
                <cfset cari_rows_all.recordcount = 0>
            </cfif>
            <cfparam name="attributes.page" default = "1">
            <cfparam name="attributes.totalrecords" default = "#cari_rows_all.recordcount#">
            <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
            <h5 class="mb-4"><cfoutput>#get_periods.period_year#</cfoutput> - <cf_get_lang dictionary_id='30075.Cari Hareketler'></h5>			
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr class="color-header main-bg-color" style="height:22px;">
                            <th class="form-title"><cf_get_lang_main no='75.No'></th>
                            <th class="form-title"><cf_get_lang_main no='330.Tarih'></th>
                            <cfif isdefined('attributes.is_due_date') and attributes.is_due_date eq 1>
                                <th class="form-title"><cf_get_lang no='117.Ortalama'><cf_get_lang_main no='228.Vade'></th>
                            </cfif>
                            <cfif isdefined('attributes.is_paper_no') and attributes.is_paper_no eq 1> 
                                <th class="form-title"><cf_get_lang_main no='56.Belge'></th>
                            </cfif>
                            <th class="form-title"><cf_get_lang_main no='280.İşlem'></th>
                            <th class="form-title" style="text-align:right;"><cf_get_lang_main no='175.Borç'></th>
                            <th class="form-title" style="text-align:right;"><cf_get_lang_main no='176.Alacak'></th>
                            <cfif isdefined('attributes.is_doviz')>	
                                <th align="right" class="form-title" style="text-align:right;"><cf_get_lang_main no='709.İşlem Dövizi'><cf_get_lang_main no='175.Borç'></th>
                                <th align="right" class="form-title" style="text-align:right;"><cf_get_lang_main no='709.İşlem Dövizi'><cf_get_lang_main no='176.Alacak'></th>
                                <th align="right" class="form-title" style="text-align:right;"><cf_get_lang_main no ='236.Kur'></th>
                            </cfif>
                            <th class="form-title" style="text-align:right;"><cf_get_lang_main no='177.Bakiye'></th>
                        </tr>
                    
                        <cfset money_list_borc_2 = ''>
                        <cfset money_list_borc_1 = ''>
                        <cfset money_list_alacak_2 = ''>
                        <cfset money_list_alacak_1 = ''>
                        <cfscript>
                            devir_total = 0;
                            devir_borc = 0;
                            devir_alacak = 0;
                            bakiye = 0;
                            devir_total_2 = 0;
                            devir_borc_2 = 0;
                            devir_alacak_2 = 0;
                            bakiye_2 = 0;
                            gen_borc_top = 0;
                            gen_ala_top = 0;
                            gen_bak_top = 0;
                            gen_bak_top_2 = 0;
                            gen_borc_top_2 = 0;
                            gen_ala_top_2 = 0;
                            gen_borc_top_other = 0;
                            gen_ala_top_other = 0;
                        </cfscript>	
                        <cfoutput query="get_money">
                            <cfset 'devir_borc_#money#' = 0>
                            <cfset 'devir_alacak_#money#' = 0>
                        </cfoutput>
                        <cfif datediff('d',yilbasi,date1) neq 0>
                            <cfquery name="GET_TARIH_DEVIR" dbtype="query">
                                SELECT
                                    SUM(BORC) BORC,
                                    SUM(ALACAK) ALACAK,
                                    SUM(BORC-ALACAK) DEVIR_TOTAL,
                                    SUM(BORC2) BORC2,

                                    SUM(ALACAK2) ALACAK2,
                                    SUM(BORC2-ALACAK2) DEVIR_TOTAL2
                                FROM
                                    CARI_ROWS
                                WHERE
                                    ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                            </cfquery>
                            <cfquery name="GET_TARIH_DEVIR_OTHER" dbtype="query">
                                SELECT
                                    SUM(BORC_OTHER) BORC_OTHER,
                                    SUM(ALACAK_OTHER) ALACAK_OTHER,
                                    OTHER_MONEY
                                    <cfif isdefined("attributes.is_doviz")>
                                        ,SUM(BORC_OTHER-ALACAK_OTHER) DEVIR_TOTAL_OTHER
                                    </cfif>
                                FROM
                                    CARI_ROWS
                                WHERE
                                    ACTION_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#">
                                    <cfif isdefined("attributes.is_doviz")>
                                        <cfif attributes.other_money is 'YTL' or attributes.other_money is 'TL'>
                                            AND (OTHER_MONEY = 'YTL' OR OTHER_MONEY = 'TL')
                                        <cfelse>
                                            AND OTHER_MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.other_money#">
                                        </cfif>
                                    </cfif>
                                GROUP BY
                                    OTHER_MONEY
                            </cfquery>
                            <cfif get_tarih_devir.recordcount>
                                <cfset devir_borc = get_tarih_devir.borc>
                                <cfset devir_alacak = get_tarih_devir.alacak>
                                <cfset devir_total = get_tarih_devir.devir_total>
                                <cfset devir_borc_2 = get_tarih_devir.borc2>
                                <cfset devir_alacak_2 = get_tarih_devir.alacak2>
                                <cfset devir_total_2 = get_tarih_devir.devir_total2>
                            </cfif>
                            <cfif get_tarih_devir_other.recordcount>
                                <cfoutput query="get_tarih_devir_other">
                                    <cfset 'devir_borc_#other_money#' = evaluate('devir_borc_#other_money#') +borc_other>
                                    <cfset 'devir_alacak_#other_money#' = evaluate('devir_alacak_#other_money#') +alacak_other>
                                </cfoutput>
                            </cfif>
                        </cfif>
                        <cfif attributes.page gt 1>
                            <cfset max_=(attributes.page-1)*attributes.maxrows>
                            <cfoutput query="cari_rows_all" startrow="1" maxrows="#max_#">
                                <cfset devir_borc = devir_borc + borc>
                                <cfset devir_alacak = devir_alacak + alacak>
                                <cfset devir_total = devir_borc - devir_alacak>
                                <cfif len(borc2)><cfset devir_borc_2 = devir_borc_2 + borc2></cfif>
                                <cfif len(alacak2)><cfset devir_alacak_2 = devir_alacak_2 + alacak2></cfif>
                                <cfset devir_total_2 = devir_borc_2 - devir_alacak_2>
                                <cfset 'devir_borc_#other_money#' = evaluate('devir_borc_#other_money#') +borc_other>
                                <cfset 'devir_alacak_#other_money#' = evaluate('devir_alacak_#other_money#') +alacak_other>
                            </cfoutput>
                        </cfif>
                        <cfoutput>
                            <cfif (isdefined('attributes.is_paper_no') and attributes.is_paper_no eq 1) and (isdefined('attributes.is_due_date') and attributes.is_due_date eq 1)>
                                <cfset col_say = 5>
                            <cfelseif (not isdefined('attributes.is_paper_no') or (isdefined('attributes.is_paper_no') and attributes.is_paper_no neq 1)) and (not isdefined('attributes.is_due_date') or (isdefined('attributes.is_due_date') and attributes.is_due_date neq 1))>
                                <cfset col_say = 3>
                            <cfelse>
                                <cfset col_say = 4>
                            </cfif>
                            <tr class="color-row" style="height:20px;">
                                <td colspan="#col_say#"  style="text-align:right;"><b><cf_get_lang_main no='452.Devir'></b></td>
                                <td  style="text-align:right;">#TLFormat(devir_borc)# #session_base.money#</td>
                                <td  style="text-align:right;">#TLFormat(devir_alacak)# #session_base.money#</td>
                                <cfif isdefined('attributes.is_doviz')>
                                    <td align="right" style="text-align:right;">
                                        <cfloop query="get_money">
                                            <cfif evaluate('devir_borc_#get_money.money#') gt 0>#TLFormat(evaluate('devir_borc_#get_money.money#'))# #get_money.money#<br></cfif>
                                        </cfloop>
                                    </td>
                                    <td align="right" style="text-align:right;">
                                        <cfloop query="get_money">
                                            <cfif evaluate('devir_alacak_#get_money.money#') gt 0>#TLFormat(evaluate('devir_alacak_#get_money.money#'))# #get_money.money#<br></cfif>
                                        </cfloop>
                                    </td>
                                    <td></td>
                                </cfif>
                                <td  style="text-align:right;">#TLFormat(ABS(devir_total))# #session_base.money# <cfif devir_borc gt devir_alacak>- (B)<cfelseif devir_borc lt devir_alacak>- (A)</cfif></td> 
                            </tr>
                        </cfoutput>
                    </thead>
                    <cfif cari_rows_all.recordcount>
                        <!--- banka talimatlarındaki odeme tarihine gore listelemek icin--->
                        <cfset bank_order_list="">
                        <cfoutput query="cari_rows_all">
                            <cfif (cari_rows_all.action_type_id eq 260)>
                                <cfset bank_order_list=listappend(bank_order_list,cari_rows_all.action_id)>
                            </cfif>
                        </cfoutput>
                        <cfif len(bank_order_list)>
                            <cfset bank_order_list=listsort(bank_order_list,"numeric","desc",",")>
                            <cfquery name="GET_BANK_ORDER" datasource="#new_dsn#">
                                SELECT 
                                    BANK_ORDER_ID,
                                    PAYMENT_DATE
                                FROM
                                    BANK_ORDERS
                                WHERE
                                    BANK_ORDER_ID IN (#bank_order_list#)
                                ORDER BY
                                    BANK_ORDER_ID DESC
                            </cfquery>
                        </cfif>
                        <!--- //banka talimatlarındaki odeme tarihine gore listelemek icin --->
                        <cfif get_periods.recordcount eq 1><!--- tek donem kaydi dokumu alinirsa sayfalama yapmak icin konuldu. (2 donem arasi kayitlar alinirsa alt alta listelenir. ) --->
                            <cfset process_cat_id_list = ''><!--- islem tipi  --->
                            <cfif isdefined('attributes.is_process_cat')><!--- islem tipi seçilmişse --->
                                <cfoutput query="cari_rows_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                    <cfif len(process_cat) and process_cat neq 0 and not listfind(process_cat_id_list,process_cat)>
                                        <cfset process_cat_id_list = Listappend(process_cat_id_list,process_cat)>
                                    </cfif>
                                </cfoutput>  	
                                <cfif len(process_cat_id_list)>
                                    <cfset process_cat_id_list=listsort(process_cat_id_list,"numeric","ASC",",")>			
                                    <cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
                                        SELECT PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY PROCESS_CAT_ID
                                    </cfquery>
                                    <cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat.process_cat_id,',')),'numeric','ASC',',')>
                                </cfif>
                            </cfif>
                            <tbody>
                                <cfoutput query="cari_rows_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                                    <cfif len(borc_other)>
                                        <cfset bakiye_borc_2 = borc_other>
                                        <cfset bakiye_borc_1 = borc>
                                    <cfelse>
                                        <cfset bakiye_borc_2 = 0>
                                        <cfset bakiye_borc_1 = 0>
                                    </cfif>
                                    <cfif len(alacak_other)>
                                        <cfset bakiye_alacak_2 = alacak_other>
                                        <cfset bakiye_alacak_1 = alacak>
                                    <cfelse>
                                        <cfset bakiye_alacak_2 = 0>
                                        <cfset bakiye_alacak_1 = 0>
                                    </cfif>
                                    <cfset money_2 = other_money>
                                    <cfset money_1 = session_base.money>
                                    <cfif bakiye_borc_2 gt 0>
                                        <cfset money_list_borc_2 = listappend(money_list_borc_2,'#bakiye_borc_2#;#money_2#',',')>
                                        <cfset money_list_borc_1 = listappend(money_list_borc_1,'#bakiye_borc_1#;#money_1#',',')>
                                    </cfif>	
                                    <cfif bakiye_alacak_2 gt 0>
                                        <cfset money_list_alacak_2 = listappend(money_list_alacak_2,'#bakiye_alacak_2#;#money_2#',',')>
                                        <cfset money_list_alacak_1 = listappend(money_list_alacak_1,'#bakiye_alacak_1#;#money_1#',',')>
                                    </cfif>
                                    <cfset type="">
                                    <cfswitch expression = "#action_type_id#">
                                        <cfcase value="40"><!--- cari acilis fisi --->
                                            <cfset type="&period_id=#encrypt(encrypt(get_periods.period_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="24"><!--- gelen havale --->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="25"><!--- giden havale --->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="34"><!---alış f. kapama--->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="35"><!---satış f. kapama--->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="241"><!--- kredi kartı tahsilat --->
                                            <cfset type="&s=">
                                        </cfcase>
                                        <cfcase value="242"><!--- kredi karti odeme --->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="245"><!--- kredi kartı tahsilat --->
                                            <cfset type="&s=">
                                        </cfcase>
                                        <cfcase value="31"><!---tahsilat--->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="32"><!---ödeme--->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <!--- BK kaldirdi 20130912 6 aya kaldirilsin <cfcase value="36">
                                            <cfset type="objects2.popup_list_cash_expense&period_id=#encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase> --->	
                                        <cfcase value="41,42"><!--- borc/alacak dekontu --->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="43"><!--- cari virman --->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="90"><!--- çek giriş bordrosu --->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="91"><!--- çek çıkış bordrosu(ciro) --->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="94"><!--- Çek İade çıkış bordrosu --->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="95"><!--- Çek iade giriş bordrosu --->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="98,101,97,108"><!--- Senet Çıkış bordrosu --->
                                            <cfset type="&type=#action_type_id#&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="120"><!--- masraf fisi --->
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="121"><!--- gelir fisi --->
                                            <cfset type="&is_income=1&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <cfcase value="50,51,52,53,531,54,55,56,57,58,59,591,60,61,62,63,64,65,66,690,601,561,48,49">
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                        <!--- Gelen ve Giden Banka Talimatı --->
                                        <cfcase value="260,251">
                                            <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                        </cfcase>
                                    </cfswitch>		
                                    <cfif listfind('24,25,26,27,31,32,34,35,40,41,42,43,241,242,177,245,250,260,251',action_type_id,',')>
                                        <cfset page_type = 'small'>
                                    <cfelse>
                                        <cfset page_type = 'page'>
                                    </cfif>
                                    <tr>
                                        <td>#currentrow#</td>
                                        <td>#dateformat(action_date,'dd/mm/yyyy')#</td>
                                        <cfif isdefined('attributes.is_due_date') and attributes.is_due_date eq 1>
                                            <td>#dateformat(due_date,'dd/mm/yyyy')#</td>
                                        </cfif>
                                        <cfif isdefined('attributes.is_paper_no') and attributes.is_paper_no eq 1>
                                            <td>#paper_no# <cfif attributes.is_camp_info eq 1 and len(camp_head) and action_table is 'invoice'>(#camp_head#)</cfif></td>
                                        </cfif>
                                        <td>
                                            <cfif not len(type)><!--- display sayfası olmayan tipler için --->
                                                #action_name#
                                                <cfif isdefined('attributes.is_action_detail')><td>#action_detail#</td></cfif>
                                            <cfelse>
                                                <cfif listfind("291,292",action_type_id) and attributes.is_process_type eq 1><!--- Kredi Odemesi ,Kredi Tahsilat --->
                                                    <a class="tableyazi" href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=bankStatementListTypes&isbox=1&style=maxi#type#&id=#action_id#&period_id=#session.ep.period_id#&our_company_id=#session.ep.company_id#');">
                                                <cfelseif action_table is 'cheque' and attributes.is_process_type eq 1>
                                                    <a class="tableyazi" href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=bankStatementListTypes&isbox=1&style=maxi&action_type_id=102&id=#encrypt(encrypt(action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#')">
                                                <cfelseif attributes.is_process_type eq 1>
                                                    <a class="tableyazi" href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=bankStatementListTypes&isbox=1&style=maxi&action_type_id=#action_type_id##type#&id=#encrypt(encrypt(action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#&cari_act_id=#encrypt(encrypt(cari_action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#&table_name=#action_table#');">
                                                </cfif>
                                                <cfif isdefined('attributes.is_process_cat')>
                                                    <cfif listfind(process_cat_id_list,process_cat,',')>
                                                        #get_process_cat.process_cat[listfind(process_cat_id_list,process_cat,',')]#
                                                    <cfelse>
                                                        #action_name#
                                                    </cfif>
                                                <cfelse>
                                                    #action_name#
                                                </cfif>
                                                </a>
                                            </cfif>
                                        </td>
                                        <td  style="text-align:right;">#TLFormat(borc)# #session_base.money#</td>
                                        <td  style="text-align:right;">#TLFormat(alacak)# #session_base.money#</td>
                                        <cfif isdefined('attributes.is_doviz')><!--- Dovizli secili --->	
                                            <td align="right" style="text-align:right;">
                                                <cfif isdefined('attributes.is_color')>
                                                    <cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc_other)# #other_money#</font>
                                                <cfelse>
                                                    #TLFormat(borc_other)# #other_money#
                                                </cfif>
                                            </td>
                                            <td align="right" style="text-align:right;">
                                                <cfif isdefined('attributes.is_color')>
                                                    <cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak_other)# #other_money#</font>
                                                <cfelse>
                                                    #TLFormat(alacak_other)# #other_money#
                                                </cfif>
                                            </td>
                                            <cfif (borc_other gt 0 or alacak_other gt 0)>
                                                <cfif borc_other gt 0>
                                                    <cfset other_tutar = borc_other>
                                                    <cfset tutar = borc>
                                                <cfelse>
                                                    <cfset other_tutar = alacak_other>
                                                    <cfset tutar = alacak>
                                                </cfif>
                                                <td align="right" style="text-align:right;">
                                                <cfif other_money neq session_base.money>
                                                    <cfif isdefined('attributes.is_color')>
                                                        <cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(tutar/other_tutar,4)#</font>
                                                    <cfelse>
                                                        #TLFormat(tutar/other_tutar,4)#
                                                    </cfif>
                                                <cfelse>
                                                &nbsp;
                                                </cfif>
                                                </td>
                                            </cfif>
                                        </cfif>
                                        <td  style="text-align:right;">
                                            <cfif (currentrow mod attributes.maxrows) eq 1>
                                                <cfset bakiye = devir_total + borc - alacak>
                                                <cfset gen_borc_top = devir_borc + borc + gen_borc_top>
                                                <cfset gen_ala_top = devir_alacak + alacak + gen_ala_top>
                                                <cfif len(borc2) and len(alacak2)><cfset bakiye_2 = devir_total_2 + borc2 - alacak2></cfif>
                                                <cfif len(borc2)><cfset gen_borc_top_2 = devir_borc_2 + borc2 + gen_borc_top_2></cfif>
                                                <cfif len(alacak2)><cfset gen_ala_top_2 = devir_alacak_2 + alacak2 + gen_ala_top_2></cfif>
                                            <cfelse>
                                                <cfset bakiye = borc - alacak >
                                                <cfset gen_borc_top = borc + gen_borc_top>
                                                <cfset gen_ala_top = alacak + gen_ala_top>
                                                <cfif len(borc2) and len(alacak2)><cfset bakiye_2 = borc2 - alacak2></cfif>
                                                <cfif len(borc2)><cfset gen_borc_top_2 = borc2 + gen_borc_top_2></cfif>
                                                <cfif len(alacak2)><cfset gen_ala_top_2 = alacak2 + gen_ala_top_2></cfif>
                                            </cfif>
                                            <cfset gen_bak_top = bakiye + gen_bak_top>
                                            <cfset gen_bak_top_2 = bakiye_2 + gen_bak_top_2>
                                            #TLFormat(abs(gen_bak_top))# #session_base.money# <cfif gen_bak_top gt 0>- (B)<cfelse>- (A)</cfif>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        <cfelse> <!--- get_periods.recordcount neq 1 (2 donem kaydi aliniyorsa(2005-2006))--->
                            <cfoutput query="cari_rows_all">		  	
                                <cfset type="">
                                <cfswitch expression = "#action_type_id#">
                                    <cfcase value="40"><!--- cari acilis fisi --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="24"><!--- gelen havale --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="25"><!--- giden havale --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="34"><!---alış f. kapama--->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="35"><!---satış f. kapama--->
                                        <cfset type="&period_id=#new_period#">
                                    </cfcase>
                                    <cfcase value="241"><!--- kredi kartı tahsilat --->
                                        <cfset type="&s=">
                                    </cfcase>
                                    <cfcase value="242"><!--- kredi karti odeme --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="245"><!--- kredi kartı tahsilat --->
                                        <cfset type="&s=">
                                    </cfcase>
                                    <cfcase value="31"><!---tahsilat--->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="32"><!---ödeme--->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="41,42"><!--- borc/alacak dekontu --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="43"><!--- cari virman --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="90"><!--- çek giriş bordrosu --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="91"><!--- çek çıkış bordrosu(ciro) --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="94"><!--- Çek İade çıkış bordrosu --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="95"><!--- Çek iade giriş bordrosu --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="120"><!--- masraf fisi --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="121"><!--- gelir fisi --->
                                        <cfset type="&is_income=1&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="50,51,52,53,531,54,55,56,57,58,59,591,60,61,62,63,64,65,66,690"><!--- Gelen ve Giden Banka Talimatı --->
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                    <cfcase value="260,251">
                                        <cfset type="&period_id=#encrypt(encrypt(new_period,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#">
                                    </cfcase>
                                </cfswitch>		
                                <cfif listfind('24,25,26,27,31,32,34,35,40,41,42,43,241,242,177,250,260,245,251',action_type_id,',')>
                                    <cfset page_type = 'small'>
                                <cfelse>
                                    <cfset page_type = 'page'>
                                </cfif>
                                <cfif len(borc_other)>
                                    <cfset bakiye_borc_2 = borc_other>
                                    <cfset bakiye_borc_1 = borc>
                                <cfelse>
                                    <cfset bakiye_borc_2 = 0>
                                    <cfset bakiye_borc_1 = 0>
                                </cfif>
                                <cfif len(alacak_other)>
                                    <cfset bakiye_alacak_2 = alacak_other>
                                    <cfset bakiye_alacak_1 = alacak>
                                <cfelse>
                                    <cfset bakiye_alacak_2 = 0>
                                    <cfset bakiye_alacak_1 = 0>
                                </cfif>
                                <cfset money_2 = other_money>
                                <cfset money_1 = session_base.money>
                                <cfif bakiye_borc_2 gt 0>
                                    <cfset money_list_borc_2 = listappend(money_list_borc_2,'#bakiye_borc_2#;#money_2#',',')>
                                    <cfset money_list_borc_1 = listappend(money_list_borc_1,'#bakiye_borc_1#;#money_1#',',')>
                                </cfif>	
                                <cfif bakiye_alacak_2 gt 0>
                                    <cfset money_list_alacak_2 = listappend(money_list_alacak_2,'#bakiye_alacak_2#;#money_2#',',')>
                                    <cfset money_list_alacak_1 = listappend(money_list_alacak_1,'#bakiye_alacak_1#;#money_1#',',')>
                                </cfif>	
                                <tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
                                    <td>#currentrow#</td>
                                    <td>#dateformat(action_date,'dd/mm/yyyy')#</td>
                                    <td>#paper_no# <cfif attributes.is_camp_info eq 1 and len(camp_head) and action_table is 'invoice'>(#camp_head#)</cfif></td>
                                    <td>
                                        <cfif not len(type)><!--- display sayfası olmayan tipler için --->
                                            #action_name#
                                        <cfelse>
                                            <cfif listfind("291,292",action_type_id)><!--- Kredi Odemesi ,Kredi Tahsilat --->
                                                <a class="tableyazi" href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=bankStatementListTypes&isbox=1&style=maxi#type#&id=#action_id#&period_id=#session.ep.period_id#&our_company_id=#session.ep.company_id#');">
                                            <cfelseif action_table is 'cheque'>
                                                <a class="tableyazi" href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=bankStatementListTypes&isbox=1&style=maxi&action_type_id=102&id=#encrypt(encrypt(action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#')">
                                            <cfelse>
                                                <a class="tableyazi" href="javascript://" onclick="openBoxDraggable('widgetloader?widget_load=bankStatementListTypes&isbox=1&style=maxi&action_type_id=#action_type_id##type#&id=#encrypt(encrypt(action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#&cari_act_id=#encrypt(encrypt(cari_action_id,session_base.userid,"CFMX_COMPAT","Hex"),session_base.userid,"CFMX_COMPAT","Hex")#&table_name=#action_table#');">
                                            </cfif>
                                                #action_name#
                                            </a>
                                        </cfif>
                                    </td>
                                    <td  style="text-align:right;">
                                        #TLFormat(borc)# #session_base.money#
                                    </td>
                                    <td  style="text-align:right;">
                                        #TLFormat(alacak)# #session_base.money#
                                    </td>
                                    <cfif isdefined('attributes.is_doviz')><!--- Dovizli secili --->	
                                        <td align="right" style="text-align:right;">
                                            <cfif isdefined('attributes.is_color')>
                                                <cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(borc_other)# #other_money#</font>
                                            <cfelse>
                                                #TLFormat(borc_other)# #other_money#
                                            </cfif>
                                        </td>
                                        <td align="right" style="text-align:right;">
                                            <cfif isdefined('attributes.is_color')>
                                                <cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(alacak_other)# #other_money#</font>
                                            <cfelse>
                                                #TLFormat(alacak_other)# #other_money#
                                            </cfif>
                                        </td>
                                        <cfif (borc_other gt 0 or alacak_other gt 0)>
                                            <cfif borc_other gt 0>
                                                <cfset other_tutar = borc_other>
                                                <cfset tutar = borc>
                                            <cfelse>
                                                <cfset other_tutar = alacak_other>
                                                <cfset tutar = alacak>
                                            </cfif>
                                            <td align="right" style="text-align:right;">
                                            <cfif other_money neq session_base.money>
                                                <cfif isdefined('attributes.is_color')>
                                                    <cfif len(to_cmp_id) or len(to_consumer_id)><font color="red"><cfelse><font color="0033CC"></cfif>#TLFormat(tutar/other_tutar,4)#</font>
                                                <cfelse>
                                                    #TLFormat(tutar/other_tutar,4)#
                                                </cfif>
                                            <cfelse>
                                            &nbsp;
                                            </cfif>
                                            </td>
                                        </cfif>
                                    </cfif>
                                    <td  style="text-align:right;">
                                        <cfif (currentrow mod attributes.maxrows) eq 1>
                                            <cfset bakiye = devir_total + borc - alacak>
                                            <cfset gen_borc_top = devir_borc + borc + gen_borc_top>
                                            <cfset gen_ala_top = devir_alacak + alacak + gen_ala_top>
                                            <cfif len(borc2) and len(alacak2)><cfset bakiye_2 = devir_total_2 + borc2 - alacak2></cfif>
                                            <cfif len(borc2)><cfset gen_borc_top_2 = devir_borc_2 + borc2 + gen_borc_top_2></cfif>
                                            <cfif len(alacak2)><cfset gen_ala_top_2 = devir_alacak_2 + alacak2 + gen_ala_top_2></cfif>
                                        <cfelse>
                                            <cfset bakiye = borc - alacak >
                                            <cfset gen_borc_top = borc + gen_borc_top>
                                            <cfset gen_ala_top = alacak + gen_ala_top>
                                            <cfif len(borc2) and len(alacak2)><cfset bakiye_2 = borc2 - alacak2></cfif>
                                            <cfif len(borc2)><cfset gen_borc_top_2 = borc2 + gen_borc_top_2></cfif>
                                            <cfif len(alacak2)><cfset gen_ala_top_2 = alacak2 + gen_ala_top_2></cfif>
                                        </cfif>
                                        <cfset gen_bak_top = bakiye + gen_bak_top>
                                        <cfset gen_bak_top_2 = bakiye_2 + gen_bak_top_2>
                                        #TLFormat(abs(gen_bak_top))# #session_base.money# <cfif gen_bak_top gt 0>- B<cfelse>- A</cfif>
                                    </td>
                                </tr>
                            </cfoutput>
                        </cfif>
                        <tfoot>
                            <tr class="color-row" style="height:20px;">
                                <td colspan="<cfoutput>#col_say#</cfoutput>"  style="text-align:right;"><b><cf_get_lang_main no='268.Genel Toplam'></b></td>
                                <td style="text-align:right;"><cfoutput>#TLFormat(gen_borc_top)# #session_base.money#</cfoutput></td>
                                <td style="text-align:right;"><cfoutput>#TLFormat(gen_ala_top)# #session_base.money#</cfoutput></td>
                                <cfif isdefined('attributes.is_doviz') or  isDefined("attributes.is_doviz_group")>
                                    <cfquery name="GET_MONEY_RATE" datasource="#DSN#">
                                        SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#"> AND MONEY_STATUS = 1
                                    </cfquery>
                                    <td align="right" style="width:125px;text-align:right;">
                                        <cfoutput query="get_money_rate">
                                            <cfset toplam_ara_2 = 0>
                                            <cfloop list="#money_list_borc_2#" index="i">
                                                <cfset tutar_ = listfirst(i,';')>
                                                <cfset money_ = listgetat(i,2,';')>
                                                <cfif money_ eq money>
                                                    <cfset toplam_ara_2 = toplam_ara_2 + tutar_>
                                                </cfif>
                                            </cfloop>
                                            <cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_borc_#money#')>
                                            <cfif toplam_ara_2 neq 0>
                                                #TLFormat(ABS(toplam_ara_2))# #money#<br>
                                            </cfif>
                                        </cfoutput>  
                                    </td>
                                    <td align="right" style="width:125px;text-align:right;">
                                        <cfoutput query="get_money_rate">
                                            <cfset toplam_ara_2 = 0>
                                            <cfloop list="#money_list_alacak_2#" index="i">
                                                <cfset tutar_ = listfirst(i,';')>
                                                <cfset money_ = listgetat(i,2,';')>
                                                <cfif money_ eq money>
                                                    <cfset toplam_ara_2 = toplam_ara_2 + tutar_>
                                                </cfif>
                                            </cfloop>
                                            <cfset toplam_ara_2 = toplam_ara_2 + evaluate('devir_alacak_#money#') >
                                            <cfif toplam_ara_2 neq 0>
                                                #TLFormat(ABS(toplam_ara_2))# #money#<br>
                                            </cfif>
                                        </cfoutput>  
                                    </td>
                                    <td>&nbsp;</td>
                                </cfif>
                                <td style="text-align:right;"> 
                                    <cfoutput>
                                        #TLFormat(abs(gen_bak_top))# #session_base.money# <cfif gen_bak_top gt 0> - (B)<cfelse> - (A)</cfif>
                                    </cfoutput>
                                </td>
                            </tr>
                        </tfoot>		  	       
                    </cfif>
                </table>
            </div>		
        </cfloop>
    </cfif>
    <cfif isDefined("attributes.totalrecords") and attributes.totalrecords gt attributes.maxrows>
        <table class="table table-striped">
            <tr> 
                <td>
                    <cfset adres="#GET_PAGE.FRIENDLY_URL#">
                    <cfset adres = adres & "&date1=#dateformat(attributes.date1,'dd/mm/yyyy')#">					
                    <cfset adres = "#adres#&date2=#dateformat(attributes.date2,'dd/mm/yyyy')#">
                    <cfif isdefined("attributes.company_id")>
                        <cfset adres = adres & "&company_id=#attributes.company_id#">					
                    </cfif>
                    <cfif isdefined("attributes.consumer_id")>
                        <cfset adres = adres & "&consumer_id=#attributes.consumer_id#">					
                    </cfif>
                    <cfif isdefined("attributes.form_submit")>
                        <cfset adres = "#adres#&form_submit=#attributes.form_submit#">
                    </cfif>
                    <cfif isdefined("attributes.company") and len(attributes.company)>
                        <cfset adres = "#adres#&company=#attributes.company#">
                    </cfif>
                    <cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
                        <cfset adres = "#adres#&employee_id=#attributes.employee_id#">
                    </cfif>
                    <cfif isdefined("attributes.member_type") and len(attributes.member_type)>
                        <cfset adres = "#adres#&member_type=#attributes.member_type#">
                    </cfif>
                    <cfif isdefined("attributes.action_type") and len(attributes.action_type)>
                        <cfset adres = "#adres#&action_type=#attributes.action_type#">
                    </cfif>
                    <cfif isdefined("attributes.other_money")>
                        <cfset adres = "#adres#&other_money=#attributes.other_money#">
                    </cfif>
                    <cfif isDefined("attributes.is_doviz")>
                        <cfset adres = "#adres#&is_doviz=#attributes.is_doviz#">
                    </cfif>
                    <cf_paging page="#attributes.page#" 
                        maxrows="#attributes.maxrows#"
                        totalrecords="#attributes.totalrecords#"
                        startrow="#attributes.startrow#"
                        adres="#adres#"> 
                </td>
            </tr>
        </table>
    </cfif> 
</div>
<script type="text/javascript">
	function kontrol(){
        if(datediff(document.list_ekstre.date1.value,document.list_ekstre.date2.value,1) < 0){
            alert("<cf_get_lang dictionary_id='57806.Please Check the Date Range'>!");
            return false;
        }
        $( "form[name=list_ekstre]" ).submit();
	}
</script>