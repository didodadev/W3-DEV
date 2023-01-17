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

<cfset onceki_fiyat_start = dateadd("d",-1,attributes.start_date)>
<cfset onceki_fiyat_finish = dateadd("d",-1,onceki_fiyat_start)>


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
                    PT1.NEW_PRICE_KDV
                FROM
                    #DSN_DEV#.PRICE_TABLE PT1
                WHERE
                    PT1.IS_ACTIVE_S = 1 AND
                    (
                    PT1.STARTDATE < #attributes.start_date#
                    OR
                    DATEADD("d",-1,PT1.FINISHDATE) = #attributes.start_date#
                    ) AND
                    (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID)) AND
                    PT1.ROW_ID <>
                    	ISNULL((
                        	SELECT TOP 1 
                                PT1.ROW_ID
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
                        ),0)
                ORDER BY
                	PT1.FINISHDATE DESC,
                    PT1.STARTDATE DESC,
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
            ),PRICE_KDV) AS LISTE_FIYATI,
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
            <cfif session.ep.username is 'admin1'>
            P.PRODUCT_ID = 1391 AND
            </cfif>
			<cfif len(attributes.barcode_list_id)>
            SB.BARCODE = (SELECT TOP 1 BPL2.BARCODE FROM #DSN_DEV#.BARCODE_PRINT_LIST BPL2 WHERE BPL2.PRINT_NO = '#attributes.barcode_list_id#' AND S.STOCK_ID = BPL2.STOCK_ID) AND
            <cfelse>
            SB.BARCODE = (SELECT TOP 1 SB2.BARCODE FROM STOCKS_BARCODES SB2 WHERE SB2.STOCK_ID = SB.STOCK_ID) AND
            </cfif>
            <cfif not len(attributes.barcode_list_id)>
            P.IS_INVENTORY = 1 AND
            P.IS_SALES = 1 AND
            </cfif>
            P.PRODUCT_STATUS = 1 AND
            PS.PURCHASESALES = 1 AND
            PS.PRICESTANDART_STATUS = 1 AND
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
                            AND RECORD_DATE >= #attributes.rec_date#
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
                <!---
                OR
                	(
                	P.UPDATE_DATE BETWEEN #attributes.start_date# AND #dateadd('d',1,attributes.finish_date)#
                    <cfif isdefined("attributes.rec_date")>
                    AND 
                    	P.UPDATE_DATE >= #attributes.rec_date#
                    </cfif>
                    )
				--->
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
            P.PRODUCT_ID = S.PRODUCT_ID AND
            SB.UNIT_ID = PU.PRODUCT_UNIT_ID AND
            SB.STOCK_ID = S.STOCK_ID AND
            SB.UNIT_ID = PS.UNIT_ID AND
            LEN(SB.BARCODE) > 3 AND
            LEN(SB.BARCODE) < 14 AND
            PS.PRICE < 10000000 AND
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
		<!---
		<cfif not len(attributes.barcode_list_id) and not isdefined("attributes.search_product_id") and not len(attributes.table_code)>
           AND
            (
            T1.ONCEKI_FIYAT <> T1.LISTE_FIYATI
            OR
            T1.PRODUCT_CODE LIKE '58.%'
            )
        </cfif>
		--->
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
     <cfform name="search_form" method="post" action="#request.self#?fuseaction=retail.list_etiket">
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

<cfform name="add_" method="post" action="#request.self#?fuseaction=retail.popup_print_etiket&iframe=1">
<table id="manage_table" cellpadding="2" cellspacing="1" class="color-border" width="99%" align="center">
        <tr class="color-header">
        	<th width="35" class="form-title">Sıra</th>
            <th class="form-title">Özel Kod</th>
            <th width="100" class="form-title">Barkod</th>
            <th class="form-title">Ürün</th>
            <th style="text-align:right;" class="form-title">Standart Satış</th>
            <th class="form-title">Fiyat Tipi</th>
            <th style="text-align:right;" class="form-title">Önceki Fiyat</th>
            <th style="text-align:right;" class="form-title">Fiyat</th>
            <th style="text-align:right;" class="form-title">Oran</th>
            <cfif len(attributes.barcode_list_id) or isdefined("attributes.search_product_id")>
            	<th>Sayı</th>
            </cfif>
            <th width="120" class="form-title">Geçerlilik Tarihi</th>
            <th class="form-title"><cfif get_etikets1.recordcount><input type="checkbox" name="is_all_tickets" id="is_all_tickets" value="1" checked="checked" onclick="check_all_special();"/></cfif></th>
        </tr>
        <cfif get_etikets1.recordcount>
        <tr class="color-list">
        	<th colspan="12">
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
            </th>
        </tr>
        </cfif>
        <cfif get_etikets1.recordcount>
        	<cfset count_ = 0>
            <cfoutput query="get_etikets1">            
                <cfif attributes.price_type eq 0 or (attributes.price_type eq 1 and len(LISTE_FIYATI_START)) or (attributes.price_type eq 2 and not len(LISTE_FIYATI_START))>
                <cfset count_ = count_ + 1>
                <tr id="row_#count_#" class="color-row">
                	<td>#currentrow#</td>
                    <td>#STOCK_CODE_2#</td>
                    <td style="text-align:right;"><input type="text" value="#barcod#" name="barcode_#stock_id#" id="barcode_#stock_id#" style="width:100px; text-align:right;" readonly="readonly"/></td>
                    <td><a href="#request.self#?fuseaction=product.form_upd_product&pid=#product_id#" class="tableyazi" target="_blank">#product_name# #PROPERTY#</a></td>
                    <td style="text-align:right;"><input type="text" value="#tlformat(PRICE_KDV)#" name="ss_price_#stock_id#" id="ss_price_#stock_id#" style="width:75px; text-align:right;"  onkeyup="FormatCurrency(this,event,4);" onblur="hesapla_oran('#stock_id#');"/></td>
                    <td><cfif len(tablo_kodu)><a href="#request.self#?fuseaction=retail.speed_manage_product&table_code=#tablo_kodu#&is_form_submitted=1" class="tableyazi" target="_blank">#LISTE_FIYATI_TIPI#</a></cfif></td>
                    <td style="text-align:right;"><cfif len(ONCEKI_FIYAT)>#tlformat(ONCEKI_FIYAT)#<cfelse>#tlformat(PRICE_KDV)#</cfif></td>
                    <td style="text-align:right;">
						<cfif len(LISTE_FIYATI)>
                            <cfset new_price = LISTE_FIYATI>
                        <cfelse>
                            <cfset new_price = PRICE_KDV>
                        </cfif>
                        <input type="text" value="#tlformat(new_price)#" name="new_price_#stock_id#" id="new_price_#stock_id#" style="width:50px; text-align:right;" readonly="readonly"/>
                    </td>
                    <td style="text-align:right;">
                    	<input type="text" value="#wrk_round(100 - (new_price * 100 / PRICE_KDV))#" name="change_rate_#stock_id#" id="change_rate_#stock_id#" style="width:50px; text-align:right;" readonly="readonly"/>
                    </td>
                    <cfif len(attributes.barcode_list_id) or isdefined("attributes.search_product_id")>
                        <td style="text-align:right;"><input type="text" name="print_count_#stock_id#" id="print_count_#stock_id#" value="#PRINT_COUNT#" style="width:35px;"/></td>
                    </cfif>
                    <td>
                    	<cfif len(LISTE_FIYATI_START)>
                        	#dateformat(LISTE_FIYATI_START,'dd/mm/yyyy')#
                        </cfif>
                        -
                        <cfif len(LISTE_FIYATI_FINISH)>
                        	#dateformat(LISTE_FIYATI_FINISH,'dd/mm/yyyy')#
                        </cfif>
                    </td>
                    <td>
                    	<input type="checkbox" name="select_stock" id="select_stock" value="#stock_id#" checked="checked"/>
                    </td>
                </tr>
                </cfif>
            </cfoutput>
        <cfelse>
            <tr class="color-row">
                <td colspan="12"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
            </tr>
        </cfif>
</table>
</cfform> 
<script type="text/javascript">
$("input").focus(function() 
	{
		input_ = $(this);
		setTimeout(function ()
		  {
			input_.select();
		  },30);
	}
	);

$("input").keydown(function(e)
{
  kod_ = e.keyCode;
	if(kod_ == 40)
	{
	   input_ = $(this);
	   td_ = input_.closest('td');
	   tr_ = td_.closest('tr');
	   myRow = tr_.index();
	   myCol = td_.index();
	   myall = $('#manage_table tr').length;
	   
	   
	   myRow_real = myRow + 1;
	   next_row = myRow + 1;
	   
		if(myRow_real == myall)
		{
			//alert('Zaten En Alttasınız!');
			return false;
		}
		else
		{
			$('#manage_table tr:eq(' + (next_row+1) + ') td:eq(' + myCol + ')').children().focus();
		}
	   
	}
	else if(kod_ == 38)
	{
	input_ = $(this);
	   td_ = input_.closest('td');
	   tr_ = td_.closest('tr');
	   myRow = tr_.index();
	   myCol = td_.index();
	   myall = 0;
	   
	   myRow_real = myRow;
	   
	   next_row = myRow - 1;
	   
		if(myRow_real == myall)
		{
			//alert('Zaten En Üsttesiniz!');
			return false;
		}
		else
		{
			$('#manage_table tr:eq(' + (next_row+1) + ') td:eq(' + myCol + ')').children().focus();
		}
	}
});	
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

function check_all_special()
{
	<cfif get_etikets1.recordcount>
	if(document.getElementById('is_all_tickets').checked == true)
	{
		<cfif get_etikets1.recordcount eq 1>
			document.add_.select_stock.checked = true;
		<cfelse>
			sayi_ = <cfoutput>#get_etikets1.recordcount#</cfoutput>;
			for (var m=1; m <= sayi_; m++)
			{
				document.add_.select_stock[m-1].checked = true;
			}
		</cfif>
	}
	else
	{
		<cfif get_etikets1.recordcount eq 1>
			document.add_.select_stock.checked = false;
		<cfelse>
			sayi_ = <cfoutput>#get_etikets1.recordcount#</cfoutput>;
			for (var m=1; m <= sayi_; m++)
			{
				document.add_.select_stock[m-1].checked = false;
			}
		</cfif>
	}
	</cfif>
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