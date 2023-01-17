<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>
</cfif>

<cfif isdefined("attributes.finish_date") and len(attributes.finish_date) and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date = dateadd("d",25,attributes.start_date)>
</cfif>

<cfquery name="get_price_types" datasource="#dsn_dev#">
    SELECT
        *
    FROM
        PRICE_TYPES
    ORDER BY
    	IS_STANDART DESC,
    	TYPE_ID ASC
</cfquery>

<cfsavecontent  variable="head"><cf_get_lang dictionary_id='61875.Fiyat Raporu'></cfsavecontent>
<cf_report_list_search title="#head#">
    <cf_report_list_search_area>
        <cfform action="#request.self#?fuseaction=retail.price_report" method="post" name="search_depo">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">	
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cfinput type="text" name="keyword" value="#attributes.keyword#">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61480.Fiyat Tipi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <select name="price_type_search" id="price_type_search">
                                            <option value=""><cf_get_lang dictionary_id='61480.Fiyat Tipi'></option>
                                            <cfloop query="get_price_types">
                                                <cfoutput><option value="#get_price_types.type_id#" <cfif isdefined("attributes.price_type_search") and attributes.price_type_search eq get_price_types.type_id>selected</cfif>>#get_price_types.TYPE_code#</option></cfoutput>
                                            </cfloop>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <cf_wrk_search_button button_type="1" search_function="control_re()">
                        </div>
                    </div>
                </div>
            </div>
        </cfform>
    </cf_report_list_search_area>
</cf_report_list_search>


<script>
function control_re()
{
	if(document.getElementById('price_type_search').value == '')
	{
		alert('<cf_get_lang dictionary_id='62217.Fiyat Tipi Seçiniz'>!');
		return false;	
	}
	return true;
}
</script>
<cfif isdefined("attributes.is_form_submitted")>
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>

<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("m",-3,now())>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = now()>
</cfif>

<cfquery name="get_prices" datasource="#dsn3#">
    SELECT DISTINCT
        ISNULL((
        SELECT
            SUM(PR.COST) AS KARE_B
        FROM
            #DSN_DEV#.PROCESS_ROWS PR
        WHERE
            ISNULL(PR.PROJECT_ID,0) = ISNULL(P.PROJECT_ID,0) AND
            ISNULL(PR.COMPANY_ID,0) = ISNULL(P.COMPANY_ID,0) AND
            PR.PROCESS_STARTDATE >= #attributes.start_date#
        ),0) KARE_BEDELI,
        P.PRODUCT_NAME,
        P.PRODUCT_CODE,
        P.PRODUCT_ID,
        ISNULL(( 
            SELECT TOP 1 
                PT1.NEW_ALIS_KDV
            FROM
                #DSN_DEV#.PRICE_TABLE PT1
            WHERE
                PT1.IS_ACTIVE_P = 1 AND
                PT1.P_STARTDATE <= #bugun_# AND 
                DATEADD("d",-1,PT1.P_FINISHDATE) >= #bugun_# AND
                (PT1.STOCK_ID = S.STOCK_ID OR (PT1.STOCK_ID IS NULL AND PT1.PRODUCT_ID = P.PRODUCT_ID))
            ORDER BY
                PT1.STARTDATE DESC,
                PT1.ROW_ID DESC
        ),PRICE_STANDART.PRICE_KDV) AS LISTE_FIYATI,
        (SELECT TOP 1 ETR.SUB_TYPE_NAME FROM #dsn_dev_alias#.EXTRA_PRODUCT_TYPES_ROWS ETR WHERE P.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#) AS SUB_TYPE_NAME,
        ISNULL(P.DUEDAY,0) AS P_DUEDAY,
        ISNULL(P.MAX_MARGIN,10) AS MAX_MARGIN_DEGER,
        PRICE_STANDART.PRICE PRICE_STANDART,
        PRICE_STANDART.PRICE_KDV PRICE_STANDART_KDV,
        PS2.PRICE STANDART_SALE_PRICE,
        PS2.PRICE_KDV AS STANDART_SALE_PRICE_KDV,
        PT_SATIS.TABLE_CODE,
        PT_SATIS.TABLE_ID,
        PT_SATIS.PRICE_TYPE OZEL_PRICE_TYPE,
        PT_SATIS.NEW_PRICE OZEL_FIYAT_SATIS,
        PT_SATIS.NEW_PRICE_KDV OZEL_FIYAT_SATIS_KDV,
        PT_SATIS.STARTDATE PRICE_START,
        PT_SATIS.FINISHDATE PRICE_FINISH,
        PT_SATIS.IS_ACTIVE_S,
        PT_SATIS.MARGIN,
        PT_SATIS.P_MARGIN
    FROM 
        STOCKS S,
        #dsn1_alias#.PRODUCT P
        LEFT JOIN PRODUCT_UNIT ON P.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID
        LEFT JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID
        LEFT JOIN PRICE_STANDART AS PS2 ON PRODUCT_UNIT.PRODUCT_ID = PS2.PRODUCT_ID
        INNER JOIN #dsn_dev_alias#.PRICE_TABLE AS PT_SATIS ON 
        	(
                P.PRODUCT_ID = PT_SATIS.PRODUCT_ID AND 
                PT_SATIS.STARTDATE >= #attributes.start_date# AND 
                PT_SATIS.FINISHDATE <= #attributes.finish_date# AND
                PT_SATIS.PRICE_TYPE = #attributes.price_type_search# AND
                PT_SATIS.ROW_ID = 
                	(
                    	SELECT TOP 1
                        	PT2.ROW_ID
                        FROM
                        	#dsn_dev_alias#.PRICE_TABLE PT2
                        WHERE
                        	P.PRODUCT_ID = PT2.PRODUCT_ID AND 
                            PT2.STARTDATE >= #attributes.start_date# AND 
                            PT2.FINISHDATE <= #attributes.finish_date# AND
                            PT2.PRICE_TYPE = #attributes.price_type_search#
                        ORDER BY
                        	ISNULL(PT2.IS_ACTIVE_S,0) DESC,
                            PT2.ROW_ID DESC
                    )
            ) 
    WHERE
        S.STOCK_STATUS = 1 AND
        P.PRODUCT_ID = S.PRODUCT_ID AND
        PS2.PRICESTANDART_STATUS = 1 AND
        PS2.PURCHASESALES = 1 AND
        PRODUCT_UNIT.PRODUCT_UNIT_ID = PS2.UNIT_ID AND
        PRICE_STANDART.PURCHASESALES = 0 AND
        PRODUCT_UNIT.IS_MAIN = 1 AND 
        PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
        PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
            <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                (
                P.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#attributes.keyword#%'
                OR
                (
                P.PRODUCT_NAME IS NOT NULL
                    <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
                        <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                            AND
                            P.PRODUCT_NAME + ' ' + S.PROPERTY LIKE '%#kelime_#%'
                    </cfloop>
                ) OR
                S.BARCOD = '#kelime_#' OR
                S.STOCK_CODE = '#kelime_#' OR
                PT_SATIS.TABLE_CODE = '#kelime_#'
                )
            <cfelse>
                P.PRODUCT_NAME IS NOT NULL
            </cfif>
    ORDER BY
        PT_SATIS.TABLE_CODE,
        P.PRODUCT_CODE ASC,
        SUB_TYPE_NAME,
    	P.PRODUCT_NAME
</cfquery>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='61478.Tablo Kodu'></th>
                        <th><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
                        <th><cf_get_lang dictionary_id='58202.Üretici'></th>
                        <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></th>
                        <th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
                        <th style="text-align:right;">SS <cf_get_lang dictionary_id='58084.Fiyat'> <cf_get_lang dictionary_id='57639.KDV'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'> <cf_get_lang dictionary_id='57639.KDV'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='61560.Alış Karı'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='40627.Satış Karı'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='62216.Kare Bedeli'></th>
                        <th><cf_get_lang dictionary_id='30925.Onay Durumu'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="get_prices">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=retail.speed_manage_product&table_code=#table_code#&is_form_submitted=1" class="tableyazi" target="_blank">#table_code#</a></td>
                            <td>#listlast(product_code,'.')#</td>
                            <td>#SUB_TYPE_NAME#</td>
                            <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=retail.popup_detail_product_price&pid=#product_id#','wide2');" class="tableyazi">#product_name#</a></td>
                            <td>#dateformat(PRICE_START,'dd/mm/yyyy')#</td>
                            <td>#dateformat(PRICE_FINISH,'dd/mm/yyyy')#</td>
                            <td style="text-align:right;">#tlformat(STANDART_SALE_PRICE_KDV)#</td>
                            <td style="text-align:right;">#tlformat(OZEL_FIYAT_SATIS)#</td>
                            <td style="text-align:right;">#tlformat(OZEL_FIYAT_SATIS_KDV)#</td>
                            <td style="text-align:right;">#tlformat(p_margin)#</td>
                            <td style="text-align:right;">#tlformat(margin)#</td>
                            <td style="text-align:right;"><cfif not isdefined("karebedeli_#table_id#")>#tlformat(kare_bedeli)#<cfset 'karebedeli_#table_id#' = 1></cfif></td>
                            <td><cfif IS_ACTIVE_S eq 1><cf_get_lang dictionary_id='57616.Onaylı'><cfelse><cf_get_lang dictionary_id='57545.Teklif'></cfif></td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
        </cf_box>
    </div>
</cfif>