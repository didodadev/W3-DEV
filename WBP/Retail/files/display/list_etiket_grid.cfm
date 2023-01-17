<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
</cfif>

<cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
</cfif>

<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>

<cfif datediff("d",bugun_,attributes.finish_date) gte 1>
	<cfset attributes.start_date = attributes.finish_date>
</cfif>

<cfset onceki_fiyat_finish = dateadd("d",-1,attributes.finish_date)>


<cfparam name="attributes.barcode_list_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.table_code" default="">
<cfparam name="attributes.price_type_search" default="">

<cfquery name="get_price_types" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        PRICE_TYPES
    ORDER BY
    	IS_STANDART DESC,
    	TYPE_ID ASC
</cfquery>

<cfquery name="get_departments_search" datasource="#dsn#">
	SELECT 
    	DEPARTMENT_ID,DEPARTMENT_HEAD 
    FROM 
    	DEPARTMENT D
    WHERE
    	D.IS_STORE IN (1,3) AND
        ISNULL(D.IS_PRODUCTION,0) = 0 AND
        BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
    ORDER BY 
    	DEPARTMENT_HEAD
</cfquery>

<cfquery name="get_barcode_lists" datasource="#dsn_dev#">
	SELECT * FROM BARCODE_PRINT_NO
</cfquery>

<cfif isdefined("attributes.form_submitted")>
	<cfif len(attributes.start_clock) and attributes.start_clock neq 0>
    	<cfset saat_ = listfirst(attributes.start_clock,':')>
        <cfset dakika_ = listlast(attributes.start_clock,':')>
		<cfset attributes.rec_date = attributes.start_date>
		<cfset attributes.rec_date = dateadd('h',saat_,attributes.rec_date)>
        <cfset attributes.rec_date = dateadd('n',dakika_,attributes.rec_date)>
        <cfset attributes.rec_date = dateadd('h',-2,attributes.rec_date)>
    </cfif>
	<cfquery name="get_etikets1" datasource="#DSN1#" result="my_result">
    SELECT DISTINCT
    	*
    FROM
    	(
        SELECT
        	 <cfif len(attributes.barcode_list_id)>
            	ISNULL((SELECT TOP 1 BPL.AMOUNT FROM #DSN_DEV#.BARCODE_PRINT_LIST BPL WHERE BPL.PRINT_NO = '#attributes.barcode_list_id#' AND SB.BARCODE = BPL.BARCODE),1) AS PRINT_COUNT,
                ISNULL((SELECT TOP 1 BPL.TABLE_ID FROM #DSN_DEV#.BARCODE_PRINT_LIST BPL WHERE BPL.PRINT_NO = '#attributes.barcode_list_id#' AND SB.BARCODE = BPL.BARCODE),0) AS ROW_NUMBER,
            <cfelse>
            	NULL AS PRINT_COUNT,
                0 AS ROW_NUMBER,
            </cfif>
            ISNULL(( 
                SELECT TOP 1 
                    PT1.READ_FIRST_SATIS_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE_STANDART PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STANDART_S_STARTDATE < #attributes.finish_date# AND
                    PT1.PRODUCT_ID = P.PRODUCT_ID
                ORDER BY
                    PT1.STANDART_S_STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PRICE_KDV) AS ONCEKI_STANDART_FIYAT,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.READ_FIRST_SATIS_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE_STANDART PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STANDART_S_STARTDATE <= #attributes.finish_date# AND
                    PT1.PRODUCT_ID = P.PRODUCT_ID
                ORDER BY
                    PT1.STANDART_S_STARTDATE DESC,
					PT1.ROW_ID DESC
            ),PRICE_KDV) AS TARIH_STANDART_FIYAT,
             ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #onceki_fiyat_finish# AND
                    PT1.FINISHDATE >= #onceki_fiyat_finish#
                    AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                ORDER BY
                    PT1.STARTDATE DESC,
                	PT1.FINISHDATE DESC,
					PT1.ROW_ID DESC
            ),PRICE_KDV) AS ONCEKI_FIYAT,
            ISNULL(( 
                SELECT TOP 1 
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #attributes.finish_date# AND 
                    DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ),'-1') AS LISTE_FIYATI,
            ( 
                SELECT TOP 1 
                    PT1.STARTDATE
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #attributes.finish_date# AND 
                    DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ) AS LISTE_FIYATI_START,
            ( 
                SELECT TOP 1 
                    PT1.FINISHDATE
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #attributes.finish_date# AND 
                    DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                ORDER BY
                	PT1.STARTDATE DESC,
			PT1.ROW_ID DESC
            ) AS LISTE_FIYATI_FINISH,
            ( 
                SELECT TOP 1 
                    PT.TYPE_NAME
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1,
                    #DSN_DEV#.PRICE_TYPES PT
                WHERE
                    PT1.PRICE_TYPE = PT.TYPE_ID AND
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #attributes.finish_date# AND 
                    DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                ORDER BY
                	PT1.STARTDATE DESC,
			PT1.ROW_ID DESC
            ) AS LISTE_FIYATI_TIPI,
            ( 
                SELECT TOP 1 
                    PT.TYPE_ID
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1,
                    #DSN_DEV#.PRICE_TYPES PT
                WHERE
                    PT1.PRICE_TYPE = PT.TYPE_ID AND
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #attributes.finish_date# AND 
                    DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                ORDER BY
                	PT1.STARTDATE DESC,
				PT1.ROW_ID DESC
            ) AS LISTE_FIYATI_TIP,
             ( 
                SELECT TOP 1 
                    PT1.TABLE_CODE
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    PT1.STARTDATE <= #attributes.finish_date# AND 
                    DATEADD("d",-1,PT1.FINISHDATE) >= #attributes.finish_date# AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
                ORDER BY
                	PT1.STARTDATE DESC,
					PT1.ROW_ID DESC
            ) AS TABLO_KODU,
            (SELECT PB.BRAND_NAME FROM PRODUCT_BRANDS PB WHERE PB.BRAND_ID = P.BRAND_ID) AS BRAND_NAME,
            P.PRODUCT_NAME,
            P.PRODUCT_ID,
            P.PRODUCT_CODE,	
            P.BRAND_ID,		
            P.IS_TERAZI,
            P.RECORD_DATE,
            P.PRODUCT_CATID,
            P.COMPANY_ID,
            P.PRODUCT_CODE_2,
            P.PRODUCT_DETAIL2,
            S.STOCK_ID,
            S.STOCK_CODE_2,
            S.PROPERTY,
            PU.ADD_UNIT,
            PU.UNIT_ID,
            PU.IS_MAIN,
            PU.MULTIPLIER,
            SB.UNIT_ID PRODUCT_UNIT_ID,
            SB.BARCODE BARCOD,
            PS.PRICE_KDV,
            PS.PRICE,
            PS.IS_KDV,
            PS.MONEY
        FROM 
            PRODUCT P, 
            STOCKS S, 
            PRODUCT_UNIT PU,
            STOCKS_BARCODES SB,
            PRICE_STANDART PS
        WHERE
			P.PRODUCT_ID = S.PRODUCT_ID AND
            P.PRODUCT_ID = PS.PRODUCT_ID AND
            P.PRODUCT_ID = PU.PRODUCT_ID AND
            SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND
            SB.STOCK_ID = S.STOCK_ID AND
            P.PRODUCT_STATUS = 1 AND
            PS.PURCHASESALES = 1 AND
            PS.PRICESTANDART_STATUS = 1 AND
            LEN(SB.BARCODE) > 3 AND
            LEN(SB.BARCODE) < 14 AND
            PS.PRICE < 10000000 AND
            <cfif not len(attributes.barcode_list_id)>
                P.IS_INVENTORY = 1 AND
                P.IS_SALES = 1 AND
            </cfif>
			<cfif len(attributes.barcode_list_id)>
            SB.BARCODE = (SELECT TOP 1 BPL2.BARCODE FROM #DSN_DEV#.BARCODE_PRINT_LIST BPL2 WHERE BPL2.PRINT_NO = '#attributes.barcode_list_id#' AND S.STOCK_ID = BPL2.STOCK_ID) AND
            <cfelse>
            SB.BARCODE = (SELECT TOP 1 SB2.BARCODE FROM STOCKS_BARCODES SB2 WHERE SB2.STOCK_ID = SB.STOCK_ID) AND
            </cfif>
            <cfif not len(attributes.barcode_list_id) and not isdefined("attributes.search_product_id")>
            (
                S.PRODUCT_ID IN 
                (
                    SELECT 
                        PRODUCT_ID
                    FROM
                        #DSN_DEV#.PRICE_TABLE
                    WHERE
                        IS_ACTIVE_S = 1 AND
                        (
                        STARTDATE BETWEEN #attributes.start_date# AND #attributes.finish_date# OR
                        FINISHDATE BETWEEN #attributes.start_date# AND #attributes.finish_date# OR
                        FINISHDATE = #attributes.finish_date#
                        )
                        <cfif isdefined("attributes.rec_date")>
                            AND 
                            (
                            RECORD_DATE >= #attributes.rec_date#
                            OR
                            STARTDATE >= #attributes.rec_date#
                            )
                        </cfif>
                )
                OR
                	(
                    P.RECORD_DATE BETWEEN #attributes.start_date# AND #dateadd('d',1,attributes.finish_date)#
                    <cfif isdefined("attributes.rec_date")>
                    AND 
                    	P.RECORD_DATE >= #attributes.rec_date#
                    </cfif>
                    )
                OR
                (
                PS.START_DATE >= #attributes.start_date# AND
                PS.START_DATE < #dateadd('d',1,attributes.finish_date)#
                <cfif isdefined("attributes.rec_date")>
                	AND PS.RECORD_DATE >= #attributes.rec_date#
                </cfif>
                )
            )
            AND
            </cfif>
            (PS.PRICE <> 0 OR PS.PRICE_KDV <> 0)
            <cfif len(attributes.table_code)>
            	AND S.PRODUCT_ID IN (SELECT STP.PRODUCT_ID FROM #DSN_DEV#.SEARCH_TABLES_PRODUCTS STP WHERE STP.TABLE_CODE = '#attributes.table_code#')
            </cfif>
            <cfif len(attributes.barcode_list_id)>
            	AND S.STOCK_ID IN (SELECT BPL.STOCK_ID FROM #DSN_DEV#.BARCODE_PRINT_LIST BPL WHERE BPL.PRINT_NO = '#attributes.barcode_list_id#')
            </cfif>
            <cfif isdefined("attributes.search_product_id") and len(attributes.search_product_id)>
            	AND P.PRODUCT_ID IN (#attributes.search_product_id#)
            </cfif>
            <cfif len(attributes.keyword)>
            	AND
                (
                P.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#attributes.keyword#%'
                    OR
                    (
                        P.PRODUCT_NAME IS NOT NULL
                        <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
                            <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                                AND
                                (
                                P.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#kelime_#%' OR
                                P.PRODUCT_CODE_2 = '#kelime_#' OR
                                S.BARCOD = '#kelime_#' OR    
                                S.STOCK_CODE = '#kelime_#' OR
                                S.STOCK_CODE_2 = '#kelime_#'                                
                                )
                        </cfloop>
                    )
               )
            <cfelse>
                AND P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
            </cfif>
        ) T1
    WHERE
        PRODUCT_NAME IS NOT NULL
        <cfif isdefined("attributes.price_type_search") and len(attributes.price_type_search)>
        	AND LISTE_FIYATI_TIP IN (#attributes.price_type_search#)
        </cfif>
		<cfif not len(attributes.barcode_list_id) and not isdefined("attributes.search_product_id") and not len(attributes.table_code)>
           AND
            (
           T1.ONCEKI_FIYAT <> T1.LISTE_FIYATI AND
            T1.ONCEKI_FIYAT > -1
            OR
            (T1.ONCEKI_FIYAT = T1.LISTE_FIYATI AND T1.PRICE_KDV = T1.LISTE_FIYATI AND T1.PRICE_KDV <> ONCEKI_STANDART_FIYAT)
            OR
            T1.PRODUCT_CODE LIKE '58.%'
            )
        </cfif>
    ORDER BY
	<cfif len(attributes.barcode_list_id)>
        ROW_NUMBER ASC
    <cfelse>
    	PRODUCT_NAME ASC
    </cfif>
    </cfquery>
<cfelse>
	<cfset get_etikets1.recordcount = 0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_etikets1.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.branch_id" default="">


<cf_big_list_search title="Etiketler"> 
    <cf_big_list_search_area>
     <cfform name="search_form" method="post" action="#request.self#?fuseaction=retail.list_etiket_grid">
     <input type="hidden" name="form_submitted" id="form_submitted" value="">
        <table>
            <tr>
                <td><cf_get_lang_main no='48.Filtre'></td>
                <td><cfinput type="text" name="keyword" id="keyword" style="width:90px;" value="#attributes.keyword#" maxlength="500"></td>
                <td>Tablo Kodu</td>
                <td><cfinput type="text" name="table_code" id="table_code" style="width:90px;" value="#attributes.table_code#" maxlength="500"></td>
                <td>Fiyat Tipi</td>
                <td>
                	<cf_multiselect_check 
                        query_name="get_price_types"  
                        name="price_type_search"
                        option_text="Fiyat Tipleri" 
                        width="180"
                        option_name="TYPE_NAME" 
                        option_value="TYPE_ID"
                        value="#attributes.price_type_search#">
                </td>
                <td>Liste</td>
                <td>
                	<cfinput type="text" name="barcode_list_id" id="barcode_list_id" style="width:90px;" value="" maxlength="8">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=retail.popup_select_tickets','list');"><img src="/images/plus_thin.gif" /></a>
                </td>
                <td>
                    <select name="department_id" id="department_id">
                        <option value="">Tüm Depolar</option>
                        <cfoutput query="get_departments_search">
                            <option value="#department_id#" <cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
                        </cfoutput>
                    </select>
                </td>
                <td>
                    <cfsavecontent variable="message">BaŞlangıç Tarihi Girmelisiniz</cfsavecontent>
                    <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                    <cf_wrk_date_image date_field="start_date">
                    <select name="start_clock" id="start_clock" style="width:60px;">
                        <option value="0"><cf_get_lang_main no='79.Saat'></option>
                        <cfloop from="1" to="23" index="i">
                        	<cfset saat = '#NumberFormat(i,00)#:00'>
                            <option value="<cfoutput>#saat#</cfoutput>" <cfif isDefined("attributes.start_clock") and attributes.start_clock eq saat>selected</cfif>><cfoutput>#saat#</cfoutput></option>
                        	
                            <cfset saat = '#NumberFormat(i,00)#:15'>
                            <option value="<cfoutput>#saat#</cfoutput>" <cfif isDefined("attributes.start_clock") and attributes.start_clock eq saat>selected</cfif>><cfoutput>#saat#</cfoutput></option>
                            
                            <cfset saat = '#NumberFormat(i,00)#:30'>
                            <option value="<cfoutput>#saat#</cfoutput>" <cfif isDefined("attributes.start_clock") and attributes.start_clock eq saat>selected</cfif>><cfoutput>#saat#</cfoutput></option>
                            
                            <cfset saat = '#NumberFormat(i,00)#:45'>
                            <option value="<cfoutput>#saat#</cfoutput>" <cfif isDefined("attributes.start_clock") and attributes.start_clock eq saat>selected</cfif>><cfoutput>#saat#</cfoutput></option>
                        </cfloop>
                    </select>
                </td>
                <td>
                    <cfsavecontent variable="message">Bitiş Tarihi</cfsavecontent>
                    <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                    <cf_wrk_date_image date_field="finish_date">
                </td>
                <td>
                	<select name="price_type">
                    	<option value="0" <cfif isdefined("attributes.price_type") and attributes.price_type eq 0>selected</cfif>>Hepsi</option>
                        <option value="1" <cfif isdefined("attributes.price_type") and attributes.price_type eq 1>selected</cfif>>Özel Fiyat</option>
                        <option value="2" <cfif isdefined("attributes.price_type") and attributes.price_type eq 2>selected</cfif>>Genel Fiyat</option>
                    </select>
                </td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" maxlength="3" onKeyUp="isNumber(this)" range="1,250" required="yes" message="#message#" style="width:25px;">
                </td>
                <td>
                	<cf_wrk_search_button search_function="kontrol()">
                	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=retail.popup_select_rival_products</cfoutput>','list');"><img src="/images/plus.gif" /></a>
                </td>
            </tr>
        </table>
        <br />
        <div id="product_div"></div>
       </cfform>
    </cf_big_list_search_area>
</cf_big_list_search>
<cfif get_etikets1.recordcount>
    <cf_form_box nofooter="1" title="">
    <table>
        <tr>
            <td>
                <cfquery name="GET_DET_FORM" datasource="#DSN#">
                    SELECT 
                        SPF.TEMPLATE_FILE,
                        SPF.FORM_ID,
                        SPF.IS_DEFAULT,
                        SPF.NAME,
                        SPF.PROCESS_TYPE,
                        SPF.MODULE_ID,
                        SPFC.PRINT_NAME
                    FROM 
                        #dsn3_alias#.SETUP_PRINT_FILES SPF,
                        SETUP_PRINT_FILES_CATS SPFC,
                        MODULES MOD
                    WHERE
                        SPF.ACTIVE = 1 AND
                        SPF.MODULE_ID = MOD.MODULE_ID AND
                        SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
                        SPFC.PRINT_TYPE = 193
                    ORDER BY
                        SPF.NAME
                </cfquery>
                <select name="form_type" id="form_type" style="width:200px">
                    <option value=""><cf_get_lang_main no='380.Modül İçi Yazıcı Belgeleri'></option>
                    <cfoutput query="GET_DET_FORM">
                        <option value="#form_id#" <cfif (isdefined("attributes.form_type") and attributes.form_type eq form_id) or (not isdefined("attributes.form_type") and IS_DEFAULT eq 1)>selected</cfif>>#name# - #print_name#</option>
                    </cfoutput>
                </select>                            
                <select name="print_count" id="print_count">
                    <cfloop from="1" to="15" index="ccc">
                    <cfoutput>
                        <option value="#ccc#">#ccc#</option>
                    </cfoutput>
                    </cfloop>
                </select>
           </td>
           <td>
                <a href="javascript://" onClick="return gonder_print();"><img src="/images/print.gif" title="Yazdır" align="absbottom" border="0"></a>
           </td>
        </tr>
    </table>
    </cf_form_box>
<div id="control_h"></div>  
<div id='jqxWidget'>
<style>
	.propertycss{background-color:#E0FFFF; color:#000000 !important;}
	.durumcss{background-color:#FC6; color:#000000 !important;}
	.faturacss{background-color:#CF3; color:#000000 !important;}
	.irsaliyecss{background-color:#FAEBD7; color:#000000 !important;}
</style>
    <div id="jqxgrid_ic">
    </div>
</div>    

<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.base.css" />
<link rel="stylesheet" type="text/css" href="/wbp/retail/files/js/jqwidgets/jqwidgets/styles/jqx.energyblue.css" />
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdata.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxbuttons.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxscrollbar.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxmenu.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.edit.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.selection.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsresize.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.columnsreorder.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.filter.js"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxnumberinput_new.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxinput.js"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxlistbox.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxcheckbox.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxtooltip.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxdropdownlist.js"></script>


<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.grouping.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/jqxgrid.aggregates.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/scripts/demos.js"></script>
<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/demos/jqxgrid/localization.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>

<script type="text/javascript" src="/wbp/retail/files/js/jqwidgets/jqwidgets/globalization/globalize.culture.tr-TR.js?version=<cfoutput>#CreateUUID()#</cfoutput>"></script>


<script type="text/javascript">
$(document).ready(function () {
	var source1 =
	{
		localdata: [
		<cfoutput query="get_etikets1">
		<cfif len(LISTE_FIYATI) and LISTE_FIYATI gt 0>
			<cfset new_price = LISTE_FIYATI>
		<cfelseif TARIH_STANDART_FIYAT neq PRICE_KDV>
			<cfset new_price = TARIH_STANDART_FIYAT>
		<cfelse>
			<cfset new_price = PRICE_KDV>
		</cfif>   
			["#currentrow#",
			"#stock_id#",
			"#barcod#",
			"<a href='#request.self#?fuseaction=product.form_upd_product&pid=#product_id#' class='tableyazi' target='_blank'><cfif len(PROPERTY)>#PROPERTY#<cfelse>#product_name#</cfif></a>",
			"#PRICE_KDV#",
			"<cfif len(tablo_kodu)><a href='#request.self#?fuseaction=retail.speed_manage_product_new&table_code=#tablo_kodu#&is_form_submitted=1' class='tableyazi' target='_blank'>#LISTE_FIYATI_TIPI#</a></cfif>",      
			"<cfif len(ONCEKI_FIYAT)><cfif ONCEKI_FIYAT eq PRICE_KDV and ONCEKI_STANDART_FIYAT neq PRICE_KDV>#ONCEKI_STANDART_FIYAT#<cfelse>#ONCEKI_FIYAT#</cfif><cfelse>#PRICE_KDV#</cfif>",
			"#new_price#",
			"#wrk_round(100 - (new_price * 100 / PRICE_KDV))#",
			"<cfif len(LISTE_FIYATI_START)>#dateformat(LISTE_FIYATI_START,'dd/mm/yyyy')#</cfif>-<cfif len(LISTE_FIYATI_FINISH)>#dateformat(LISTE_FIYATI_FINISH,'dd/mm/yyyy')#</cfif>",
			"1",
			"true"
			]<cfif currentrow neq get_etikets1.recordcount>,</cfif>
		</cfoutput>
		],
		datafields: [
			{ name: 'row_number', type: 'number', map: '0'},
			{ name: 'stock_id', type: 'number', map: '1'},
			{ name: 'barcode', type: 'string', map: '2'},
			{ name: 'stock_name', type: 'string', map: '3'},
			{ name: 'standart_satis', type: 'float', map: '4'},
			{ name: 'fiyat_tipi', type: 'string', map: '5'},
			{ name: 'onceki_fiyat', type: 'float', map: '6'},
			{ name: 'fiyat', type: 'float', map: '7'},
			{ name: 'oran', type: 'float', map: '8'},
			{ name: 'tarihler', type: 'string', map: '9'},
			{ name: 'print_c', type: 'string', map: '10'},
			{ name: 'active', type: 'bool', map: '11'}
		],
		datatype: "array"
	};
	var dataAdapter1 = new $.jqx.dataAdapter(source1);
	
	foot_ = parseInt(600);
	head_ = parseInt(50);
	
   jheight = foot_ - head_ - 120;
   jwidth = window.innerWidth - 30;

	$("#jqxgrid_ic").jqxGrid(
	{
		theme: 'energyblue',
		width: jwidth,
		height: jheight,
		columnsheight:'50px',
		source: dataAdapter1,
		columnsresize: true,
		showfilterrow: true,
		selectionmode:'singlerow',
		filterable: true,
		filtermode: 'excel',
		editable:true,
		localization: getLocalization('tr'),
		sortable: false,
		columns: [
		  { text: 'Sıra', datafield: 'row_number', width: 20,filterable:false,editable:false},
		  { text: 'Stok Kodu', datafield: 'stock_id', width: 50,filterable:true,editable:false},
		  { text: 'Barkod', datafield: 'barcode', width: 110,filterable:true,editable:false},
		  { text: 'Stok Adı', datafield: 'stock_name', width: 200,filterable:true,editable:false},
		  { text: 'Standart Satış', datafield: 'standart_satis', width: 75,filterable:true,editable:true,cellsalign:'right',cellsformat:'c2',filtertype:'number'},
		  { text: 'Fiyat Tipi', datafield: 'fiyat_tipi', width: 170,filterable:true,editable:false},
		  { text: 'Önceki Fiyat', datafield: 'onceki_fiyat', width: 50,filterable:true,editable:false,cellsalign:'right',cellsformat:'c2',filtertype:'number'},
		  { text: 'Fiyat', datafield: 'fiyat', width: 50,filterable:true,editable:false,cellsalign:'right',cellsformat:'c2',filtertype:'number'},
		  { 
		  	text: 'Oran', datafield: 'oran', width: 50,filterable:true,editable:false,cellsalign:'right',cellsformat:'c2',filtertype:'number',
		  cellsrenderer: function (index, datafield, value, defaultvalue, column, rowdata) 
			  {
				  var rate_ = wrk_round(100 - (rowdata.fiyat * 100 / rowdata.standart_satis));
				  return "<div style='margin: 4px;' class='jqx-right-align'>" + commaSplit(rate_) + "</div>";
			  }
		  },
		  { text: 'Tarih', datafield: 'tarihler', width: 155,filterable:false,editable:false},
		  { text: 'P', datafield: 'print_c', width:20,filterable:false,editable:false},
		  { text: '', datafield: 'active', width:20,columntype:'checkbox',filterable:true,editable:true,filtertype:'bool'}
		]
	});
});
</script>
</cfif>
<script type="text/javascript">
function add_row(pid_,pname_,psales_)
{
	icerik_ = '<div id="selected_product_' + pid_ + '">';
	icerik_ += '<a href="javascript://" onclick="del_row_p(' + pid_ +')">';
	icerik_ += '<img src="/images/delete_list.gif">';
	icerik_ += '</a>';
	icerik_ += '<input type="hidden" name="search_product_id" value="' + pid_ + '">';
	icerik_ += pname_;
	icerik_ += '</div>';
	
	$('#product_div').append(icerik_);
}

function del_row_p(pid_)
{
	$("#selected_product_" + pid_).remove();	
}

function gonder_print()
{
	if(document.add_.form_type.value == '')
	{
		alert('Yazdırma Şekli Seçiniz!');
		return false;	
	}
	windowopen('','page','print_popup_etiket');
	document.add_.target = 'print_popup_etiket';
	add_.submit();
}

function hesapla_oran(stock_id)
{
	np_ = filterNum(document.getElementById('new_price_' + stock_id).value);
	price_kdv_ = document.getElementById('ss_price_' + stock_id).value;	
	
	if(price_kdv_ != '')
		price_kdv_ = filterNum(price_kdv_);
		
	rate_ = wrk_round(100 - (np_ * 100 / price_kdv_));
	
	document.getElementById('change_rate_' + stock_id).value = rate_;
}
function kontrol()
{
	return date_check(document.search_form.start_date,document.search_form.finish_date,"Bitiş Tarihi Başlangıç Tarihinden Küçük!");
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->