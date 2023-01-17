<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="product.form_upd_catalog_promotion">
<cfquery name="GET_CATALOG_PROMOTION_HISTORY" datasource="#DSN3#">
	SELECT
	    CPH.CATALOG_ID,
        CPH.CATALOG_STATUS,
        CPH.CATALOG_HEAD,
        CPH.STARTDATE,
        CPH.FINISHDATE,
		CPH.KONDUSYON_DATE,
        CPH.KONDUSYON_FINISH_DATE,
        CPH.UPDATE_DATE,
        SAS.STAGE_NAME,
        CPH.CATALOG_HISTORY_ID,
        (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=CPH.UPDATE_EMP) AS UPDATE_NAME,
        CAM.CAMP_HEAD
    FROM 
    	CATALOG_PROMOTION_HISTORY CPH
        	LEFT JOIN CAMPAIGNS CAM ON CPH.CAMP_ID = CAM.CAMP_ID
            LEFT JOIN #dsn_alias#.EMPLOYEES EMP ON CPH.UPDATE_EMP = EMP.EMPLOYEE_ID,
        #dsn_alias#.SETUP_ACTION_STAGES SAS
    WHERE 
    	CPH.CATALOG_ID = #attributes.catalog_id# AND
    	SAS.STAGE_ID = CPH.STAGE_ID
    ORDER BY 
	    CATALOG_HISTORY_ID DESC
</cfquery>
<cfquery name="GET_CATALOG_PRODUCT" datasource="#dsn3#">
		SELECT 
       		* 
        FROM 
        	CATALOG_PROMOTION_PRODUCTS_HISTORY
             LEFT JOIN #DSN1_ALIAS#.PRODUCT P ON CATALOG_PROMOTION_PRODUCTS_HISTORY.PRODUCT_ID=P.PRODUCT_ID
            LEFT JOIN #DSN1_ALIAS#.STOCKS S ON CATALOG_PROMOTION_PRODUCTS_HISTORY.STOCK_ID=S.STOCK_ID
        WHERE             
        	CATALOG_ID = #attributes.catalog_id#
        ORDER BY 
            CATALOG_PROMOTION_PRODUCTS_HISTORY.STOCK_ID
</cfquery>
<!---<cfquery name="GET_CATALOG_PRODUCT" datasource="#DSN3#">
	SELECT 
		CPP.* ,
		0 SALE_DISCOUNT1,
		0 SALE_DISCOUNT2,
		0 SALE_DISCOUNT3,
		0 SALE_DISCOUNT4,
		0 SALE_DISCOUNT5,
		0 SALE_DISCOUNT6,
		0 SALE_DISCOUNT7,
		0 SALE_DISCOUNT8,
		0 SALE_DISCOUNT9,
		0 SALE_DISCOUNT10,
		0 PURCHASE_ACTION_PRICE_DISCOUNT,
		0 SALE_REBATE_CASH_1,
		0 SALE_REBATE_RATE,
		0 SALE_EXTRA_PRODUCT_1,
		0 SALE_EXTRA_PRODUCT_2,
		0 SALE_RETURN_DAY,
		0 SALE_RETURN_RATE,
		0 SALE_PRICE_PROTECTION_DAY,
		--CP.IS_APPLIED,
		P.MANUFACT_CODE,
		P.PRODUCT_CODE,
		P.PRODUCT_CODE_2,
		P.BARCOD,
        CASE 
        	WHEN CPP.STOCK_ID IS NOT NULL 
	        	THEN (SELECT P.PRODUCT_NAME+' '+S.PROPERTY FROM #DSN1_alias#.STOCKS S WHERE S.STOCK_ID = CPP.STOCK_ID)
            ELSE
    	        P.PRODUCT_NAME
        END AS 
            PRODUCT_NAME
	FROM 
		CATALOG_PROMOTION_PRODUCTS_HISTORY CPP,
        CATALOG_PROMOTION_PRODUCTS CP,
		#dsn1_alias#.PRODUCT P,
        #dsn1_alias#.STOCKS S
	--	CATALOG_PROMOTION CP
	WHERE
    	CP.CATALOGPRODUCT_ID = CPP.CATALOGPRODUCT_ID AND
    	CPP.PRODUCT_ID=P.PRODUCT_ID AND
		CPP.STOCK_ID=S.STOCK_ID AND
        CPP.CATALOG_ID = #attributes.catalog_id# --AND
		--CPP.PRODUCT_ID = P.PRODUCT_ID AND
		--CP.CATALOG_ID = CPP.CATALOG_ID 
	ORDER BY 
		CPP.STOCK_ID,
		CPP.CATALOGPRODUCT_ID
</cfquery>--->
<cfquery name="GET_MONEYS" datasource="#dsn#">
	SELECT 
		MONEY_ID,
        MONEY,
        RATE1,
        RATE2
	FROM 
		SETUP_MONEY
	WHERE
		PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
		MONEY_STATUS = 1
	ORDER BY 
    	MONEY_ID
</cfquery>
<cfquery name="GET_PAGE_TYPES" datasource="#DSN3#">
	SELECT PAGE_TYPE_ID,PAGE_TYPE,IS_DEFAULT FROM CATALOG_PAGE_TYPES ORDER BY PAGE_TYPE
</cfquery>
<style>
.history_head tr:first-child td{
	background-color:#67bbc9;
	color:white;
	font-weight:bold;
	border:none;
	}
.history_head td {
	text-align:center;
	}	

</style>
<cfif isdefined("extra_price_list") and len(extra_price_list)>
	<cfquery name="get_price_cat_row" datasource="#dsn3#" maxrows="3">
		SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT WHERE PRICE_CATID IN(#extra_price_list#)
	</cfquery>
</cfif>
<cfsavecontent variable="title_"><cf_get_lang dictionary_id='57473.Tarihçe'>: <cfoutput>#GET_CATALOG_PROMOTION_HISTORY.catalog_id#</cfoutput></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#iif(isDefined("attributes.draggable"),"getLang('','Tarihçe',57473)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
        <cfif GET_CATALOG_PROMOTION_HISTORY.recordcount>
            <cfset temp_ = 0>
            <cfoutput query="GET_CATALOG_PROMOTION_HISTORY">
                <cfquery name = "GET_ROW_HISTORY" dbtype="query">
                            SELECT 
                                *
                            FROM 
                                GET_CATALOG_PRODUCT
                            WHERE 
                                CATALOG_ID = #attributes.catalog_id#
                                AND CATALOG_HISTORY_ID = #GET_CATALOG_PROMOTION_HISTORY.CATALOG_HISTORY_ID#                    
                </cfquery>
                <cfquery name="GET_CATALOG_PRICE_LISTS" datasource="#DSN3#">
                    SELECT
                        PRICE_CAT.PRICE_CAT
                    FROM
                        CATALOG_PRICE_LISTS_HISTORY,
                        PRICE_CAT
                    WHERE
                        CATALOG_PROMOTION_ID = #attributes.catalog_id# AND
                        PRICE_CAT.PRICE_CATID = PRICE_LIST_ID
                        AND CATALOG_HISTORY_ID = #GET_CATALOG_PROMOTION_HISTORY.CATALOG_HISTORY_ID#
                </cfquery>
                <cfquery name="GET_COMPANYCAT" datasource="#DSN3#">
                    SELECT
                        COMPANY_CAT.COMPANYCAT
                    FROM
                        CATALOG_PROMOTION_MEMBERS_HISTORY,
                        #dsn_alias#.COMPANY_CAT
                    WHERE
                        CATALOG_PROMOTION_MEMBERS_HISTORY.CATALOG_ID = #attributes.catalog_id# AND
                        CATALOG_PROMOTION_MEMBERS_HISTORY.COMPANYCAT_ID IS NOT NULL AND
                        CATALOG_PROMOTION_MEMBERS_HISTORY.COMPANYCAT_ID = COMPANY_CAT.COMPANYCAT_ID
                        AND CATALOG_PROMOTION_MEMBER_HISTORY_ID = #GET_CATALOG_PROMOTION_HISTORY.CATALOG_HISTORY_ID#
                </cfquery>
                <cfquery name="GET_CONSUMER_CAT" datasource="#DSN3#">
                    SELECT 
                        CONSUMER_CAT.CONSCAT
                    FROM 
                        CATALOG_PROMOTION_MEMBERS_HISTORY,
                        #dsn_alias#.CONSUMER_CAT
                    WHERE 
                        CATALOG_PROMOTION_MEMBERS_HISTORY.CATALOG_ID = #attributes.catalog_id# AND
                        CATALOG_PROMOTION_MEMBERS_HISTORY.CONSCAT_ID = CONSUMER_CAT.CONSCAT_ID
                        AND CATALOG_PROMOTION_MEMBER_HISTORY_ID = #GET_CATALOG_PROMOTION_HISTORY.CATALOG_HISTORY_ID#
                </cfquery>
                <cfset temp_ = temp_ +1>
                <cf_seperator id="history_#temp_#" header="#dateformat(update_date,dateformat_style)# (#timeformat(dateadd('h',session.ep.time_zone,update_date),timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
                <table id="history_#temp_#" style="display:none;" height="10%" width="50%" align="left">
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='57487.no'></td>
                        <td colspan="5">#currentrow#</td>
                    </tr>
                    <tr>     
                        <td class="txtbold"><cf_get_lang dictionary_id='57493.Aktif'></td>
                            <td><cfif catalog_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
                        <td class="txtbold"><cf_get_lang dictionary_id='37210.Aksiyon'></td>	
                            <td>#catalog_head#</td>
                        <td class="txtbold"><cf_get_lang dictionary_id='57482.Aşama'></td>
                            <td>#STAGE_NAME#</td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='58964.Fiyat Listeleri'></td>
                            <td><cfloop query="GET_CATALOG_PRICE_LISTS">
                                #PRICE_CAT#<cfif GET_CATALOG_PRICE_LISTS.currentrow neq GET_CATALOG_PRICE_LISTS.recordcount>,</cfif><br/>
                            </cfloop></td>
                        <td class="txtbold"><cf_get_lang dictionary_id='57446.Kampanya'></td>
                            <td>#CAMP_HEAD#</td>
                        <td class="txtbold"><cf_get_lang dictionary_id='37028.Fiyat Listeleri'></td>
                        <td>
                            <cfloop query="GET_CATALOG_PRICE_LISTS">
                                #PRICE_CAT#<cfif GET_CATALOG_PRICE_LISTS.currentrow neq GET_CATALOG_PRICE_LISTS.recordcount>,</cfif><br/>
                            </cfloop>
                        </td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='58039.Kurumsal Uye Kategorileri'></td>
                        <td>
                            <cfloop query="GET_COMPANYCAT">
                                #COMPANYCAT#<cfif GET_COMPANYCAT.currentrow neq GET_COMPANYCAT.recordcount>,</cfif><br/>
                            </cfloop>
                        </td>
                        <td class="txtbold"><cf_get_lang dictionary_id='58040.Bireysel Uye Kategorileri'></td>
                            <td>
                                <cfloop query="GET_CONSUMER_CAT">
                                    #CONSCAT#<cfif GET_CONSUMER_CAT.currentrow neq GET_CONSUMER_CAT.recordcount>,</cfif><br/>
                                </cfloop>
                            </td>
                    </tr>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='37119.Geçerlilik Tarihi'></td>
                            <td>#dateformat(startdate,dateformat_style)# - #dateformat(finishdate,dateformat_style)#</td>
                        <td class="txtbold"><cf_get_lang dictionary_id='37213.Kondüsyon Tarihi'></td>
                            <td>#dateformat(kondusyon_date,dateformat_style)# - #dateformat(kondusyon_finish_date,dateformat_style)#</td>
                        <td class="txtbold"><cf_get_lang dictionary_id='57627.Kayit Tarihi'></td>
                            <td>
                                <cfset update_date_ = date_add('h',session.ep.time_zone,update_date)>
                                #dateformat(update_date_,dateformat_style)# #timeformat(update_date_,timeformat_style)#
                            </td>
                    </tr> 
                </table>
                <cfset col_span_inf = 1>
                <cfif (isdefined("is_manufact_code") and is_manufact_code eq 1) or (not isdefined("is_manufact_code"))>
                    <cfset col_span_inf = col_span_inf + 1>
                </cfif>
                <cfif (isdefined("is_stock_code") and is_stock_code eq 1) or (not isdefined("is_stock_code"))>
                    <cfset col_span_inf = col_span_inf + 1>
                </cfif>
                <cfif (isdefined("is_stock_code_2") and is_stock_code_2 eq 1) or (not isdefined("is_stock_code_2"))>
                    <cfset col_span_inf = col_span_inf + 1>
                </cfif>
                <cfif (isdefined("is_barcod") and is_barcod eq 1) or (not isdefined("is_barcod"))>
                    <cfset col_span_inf = col_span_inf + 1>
                </cfif>
                <cfif (isdefined("is_unit") and is_unit eq 1) or (not isdefined("is_unit"))>
                    <cfset col_span_inf = col_span_inf + 1>
                </cfif>
                <cfset col_span_inf = col_span_inf + 1>
                <cf_grid_list class="history_head">
                    <cfif GET_ROW_HISTORY.recordcount>
                        <thead>
                            <tr>
                                <th align="center" class="form-title"><cf_get_lang dictionary_id='57487.No'></th>
                                <th colspan="#col_span_inf#"><cf_get_lang dictionary_id='57657.Ürün'></th>
                                <cfif isdefined("is_row_page_type") and is_row_page_type eq 1>
                                    <th class="form-title" colspan="3" nowrap id='main_all_cond'><cf_get_lang dictionary_id='57581.Sayfa'><cf_get_lang dictionary_id='58639.Tipleri'> </th>
                                </cfif>
                                <cfif (isdefined("is_row_price") and is_row_price eq 1) or (not isdefined("is_row_price"))>
                                    <th <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")><cfif isdefined("is_price_kdv") and is_price_kdv eq 1>colspan="4"<cfelse>colspan="3"</cfif><cfelse>colspan="1"</cfif> nowrap><cf_get_lang dictionary_id='37227.standart'></th>
                                </cfif>
                                <cfif isdefined("extra_price_list") and len(extra_price_list) and get_price_cat_row.recordcount>
                                    <cfloop query="get_price_cat_row">
                                        <th class="form-title" nowrap>#get_price_cat_row.price_cat#</th>
                                        <cfif get_price_cat_row.currentrow eq 1>
                                            <th class="form-title" nowrap><cf_get_lang dictionary_id='58258.Maliyet'></th>
                                        <cfelseif get_price_cat_row.currentrow eq 2>
                                            <th class="form-title" nowrap><cf_get_lang dictionary_id='37045.Marj'></th>
                                        </cfif> 
                                    </cfloop>
                                </cfif>
                                <cfif (isdefined("is_row_discount") and is_row_discount eq 1) or (not isdefined("is_row_discount"))>
                                    <th class="form-title" colspan="#discount_count#" nowrap><cf_get_lang dictionary_id='57641.iskonto'>%</th>
                                </cfif>
                                <cfif (isdefined("is_row_cost") and is_row_cost eq 1) or (not isdefined("is_row_cost"))>
                                    <th class="form-title" colspan="2"><cf_get_lang dictionary_id='58258.Maliyet'></th>
                                </cfif>
                                <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
                                    <th class="form-title" colspan="4" nowrap><cf_get_lang dictionary_id='37049.Aksiyon Fiyat'></th>
                                </cfif>
                                <cfif isdefined("is_money_type") and is_money_type eq 1>
                                    <th class="form-title" nowrap><cf_get_lang dictionary_id='57489.Para Br'></th>
                                </cfif>
                                <cfif (isdefined("is_row_return_price") and is_row_return_price eq 1) or (not isdefined("is_row_return_price"))>
                                    <th class="form-title" colspan="3" nowrap><cf_get_lang dictionary_id='57749.Dönüş Fiyatı'></th>
                                </cfif>
                                <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
                                    <th class="form-title" colspan="2" nowrap><cf_get_lang dictionary_id='57639.Kdv'></th>
                                </cfif>
                                <cfif (isdefined("is_row_due") and is_row_due eq 1) or (not isdefined("is_row_due"))>
                                    <th class="form-title" colspan="2" nowrap>&nbsp;</th>
                                </cfif>
                                <cfif (isdefined("is_row_condition") and is_row_condition eq 1) or (not isdefined("is_row_condition"))>
                                    <th class="form-title" colspan="5" nowrap id='main_all_cond'><cf_get_lang dictionary_id ='37537.Tüm Koşullar'></th>
                                </cfif>
                                <cfif isdefined("is_extra_definition") and is_extra_definition eq 1>
                                    <th class="form-title" colspan="2" nowrap><cf_get_lang dictionary_id ='37076.Ek Tanım'></th>
                                </cfif>
                                <cfif isdefined("is_sale_target") and is_sale_target eq 1>
                                    <th class="form-title" colspan="4" nowrap><cf_get_lang dictionary_id='57951.Hedef'></th>
                                </cfif>
                            </tr>
                            <tr>
                                <th class="txtboldblue" nowrap><cf_get_lang dictionary_id='57487.No'></th>
                                <th class="txtboldblue" width="175"><cf_get_lang dictionary_id='57629.Açıklama'></th>
                                <cfif (isdefined("is_manufact_code") and is_manufact_code eq 1) or (not isdefined("is_manufact_code"))>
                                    <th class="txtboldblue" nowrap><cf_get_lang dictionary_id='37481.Ürt Kodu'></th>
                                </cfif>
                                <cfif (isdefined("is_stock_code") and is_stock_code eq 1) or (not isdefined("is_stock_code"))>
                                    <th class="txtboldblue" nowrap><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                                </cfif>
                                <cfif (isdefined("is_stock_code_2") and is_stock_code_2 eq 1) or (not isdefined("is_stock_code_2"))>
                                    <th class="txtboldblue" nowrap><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                                </cfif>
                                <cfif (isdefined("is_barcod") and is_barcod eq 1) or (not isdefined("is_barcod"))>
                                    <th class="txtboldblue" nowrap width="100"><cf_get_lang dictionary_id='57633.Barkod'></th>
                                </cfif>
                                <cfif (isdefined("is_unit") and is_unit eq 1) or (not isdefined("is_unit"))>
                                    <th class="txtboldblue" nowrap width="30"><cf_get_lang dictionary_id='57636.Birim'></th>
                                </cfif>
                                <th class="txtboldblue" nowrap width="50"><cf_get_lang dictionary_id='57489.Para Br'></th>
                                <cfif isdefined("is_row_page_type") and is_row_page_type eq 1>
                                    <th class="txtboldblue" nowrap width="60" id='page_type'><cf_get_lang dictionary_id='53685.Sayfa No'></th>
                                    <th class="txtboldblue" nowrap width="60" id='page_type'><cf_get_lang dictionary_id='58069.Sayfa Tipi'></th>
                                    <th class="txtboldblue" nowrap id='page_type'><cf_get_lang dictionary_id='58067.Döküman Tipi'></th>
                                </cfif>
                                <cfif (isdefined("is_row_price") and is_row_price eq 1) or (not isdefined("is_row_price"))>
                                    <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
                                        <th width="50px" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58176.alis'><br/><cf_get_lang dictionary_id='30024.KDV siz'></th>
                                    <cfif isdefined("is_price_kdv") and is_price_kdv eq 1>
                                        <th width="50px" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58176.alis'><br/><cf_get_lang dictionary_id='58716.KDV li'></th>
                                    </cfif>
                                    </cfif>
                                    <th width="50px" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57448.satis'><br/><cf_get_lang dictionary_id='58716.KDV li'></th>
                                    <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
                                        <th class="txtboldblue" nowrap width="45"><cf_get_lang dictionary_id='37313.S Mrj'></th>
                                    </cfif>
                                </cfif>
                                <cfif isdefined("extra_price_list") and len(extra_price_list)>
                                    <cfloop query="get_price_cat_row">
                                        <th width="60px" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37365.KDV Dahil'></th>
                                        <cfif get_price_cat_row.currentrow eq 1>
                                            <th align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58258.Maliyet'></th>
                                        <cfelseif get_price_cat_row.currentrow eq 2>
                                            <th align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id ='37045.Marj'></th>
                                        </cfif> 
                                    </cfloop>
                                </cfif>
                                <cfif (isdefined("is_row_discount") and is_row_discount eq 1) or (not isdefined("is_row_discount"))>
                                    <cfloop from="1" to="#discount_count#" index="kk">                               
                                            <th class="txtboldblue" nowrap width="20" align="center">#kk#</th>
                                    </cfloop>
                                </cfif>
                                <cfif (isdefined("is_row_cost") and is_row_cost eq 1) or (not isdefined("is_row_cost"))>
                                    <th width="50px" align="right" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58083.Net'></th>
                                    <th width="50px" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58716.KDV li'></th>
                                </cfif>
                                <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
                                    <th class="txtboldblue" nowrap width="45"><cf_get_lang dictionary_id='37048.A Mrj'></th>
                                    <th width="60px" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37753.Kdv Hariç'></th>
                                    <th width="60px" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37365.KDV Dahil'></th>
                                    <th width="60px" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37482.Tutar Ind'></th>
                                </cfif>
                                <cfif isdefined("is_money_type") and is_money_type eq 1>
                                    <th class="txtboldblue" nowrap width="100px"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                                </cfif>
                                <cfif (isdefined("is_row_return_price") and is_row_return_price eq 1) or (not isdefined("is_row_return_price"))>
                                    <th width="60px" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37753.Kdv Hariç'></th>
                                    <th width="60px" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37365.KDV Dahil'></th>
                                    <th width="60px" align="right" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='37482.Tutar Ind'></th>
                                </cfif>
                                <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
                                    <th class="txtboldblue" nowrap width="30"><cf_get_lang dictionary_id='58176.alış'></th> 
                                    <th class="txtboldblue" nowrap width="30"><cf_get_lang dictionary_id='57448.satış'></th>
                                </cfif>
                                <cfif (isdefined("is_row_due") and is_row_due eq 1) or (not isdefined("is_row_due"))>
                                    <th class="txtboldblue" nowrap width="30"><cf_get_lang dictionary_id='57640.Vade'></th>
                                    <th class="txtboldblue" nowrap width="60"><cf_get_lang dictionary_id='37110.Raf Tipi'></th>
                                </cfif>
                                <cfif (isdefined("is_row_condition") and is_row_condition eq 1) or (not isdefined("is_row_condition"))>
                                    <th class="txtboldblue" nowrap width="60" id='back_end_rebate'><cf_get_lang dictionary_id="37755.Back End Rebeta"></th>
                                    <th class="txtboldblue" nowrap width="60" id='back_end_rebate_rate'><cf_get_lang dictionary_id ='37856.Back End Rebate Oran'></th>
                                    <th class="txtboldblue" nowrap width="60" id='extra_product'><cf_get_lang dictionary_id ='37660.Mal Fazlası'></th>
                                    <th class="txtboldblue" nowrap width="60" id='return_day_rate'><cf_get_lang dictionary_id ='37662.İade Gün'> -<cf_get_lang dictionary_id='58456.Oran'> </th>
                                    <th class="txtboldblue" nowrap width="45" id='price_protection_day'><cf_get_lang dictionary_id ='37661.Fiyat Koruma Gün'></th>
                                </cfif>
                                <cfif isdefined("is_extra_definition") and is_extra_definition eq 1>
                                    <th class="txtboldblue" nowrap width="80"><cf_get_lang dictionary_id='57629.Açıklama'>/<cf_get_lang dictionary_id='57467.Not'></th>
                                    <th class="txtboldblue" nowrap width="80"><cf_get_lang dictionary_id='37134.Referans Kod'></th>
                                </cfif>
                                <cfif isdefined("is_sale_target") and is_sale_target eq 1>
                                    <th class="txtboldblue" nowrap width="80"><cf_get_lang dictionary_id='37168.Müşteri Sayısı'></th>
                                    <th class="txtboldblue" nowrap width="80"><cf_get_lang dictionary_id='37150.Birim Satış'></th>
                                    <th class="txtboldblue" nowrap width="120"><cf_get_lang dictionary_id='37151.Toplam Satış Miktarı'></th>
                                    <th class="txtboldblue" nowrap width="80"><cf_get_lang dictionary_id='37215.Satış Tipi'></th>
                                </cfif>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop QUERY="GET_ROW_HISTORY">
                                <tr id="frm_row#currentrow#" title="#product_name#">
                                    <td nowrap>#currentrow#</td>
                                    <td width="220" nowrap="nowrap">#product_name#</td>
                                    <cfif (isdefined("is_manufact_code") and is_manufact_code eq 1) or (not isdefined("is_manufact_code"))>
                                        <td title="Ürt. Kodu/ #product_name#">#manufact_code#</td>
                                    </cfif>
                                    <cfif (isdefined("is_stock_code") and is_stock_code eq 1) or (not isdefined("is_stock_code"))>
                                        <td title="Stok Kodu/ #product_name#">#product_code#</td>
                                    </cfif>
                                    <cfif (isdefined("is_stock_code_2") and is_stock_code_2 eq 1) or (not isdefined("is_stock_code_2"))>
                                        <td title="Özel Kod/ #product_name#" nowrap>#product_code_2#</td>
                                    </cfif>
                                    <cfif (isdefined("is_barcod") and is_barcod eq 1) or (not isdefined("is_barcod"))>
                                        <td title="Barkod/ #product_name#">#barcod#</td>
                                    </cfif>
                                    <cfif (isdefined("is_unit") and is_unit eq 1) or (not isdefined("is_unit"))>
                                        <td title="Birim/ #product_name#">#unit#</td>
                                    </cfif>
                                    <td title="P. Br/ #product_name#">#money#</td>
                                    <cfif isdefined("is_row_page_type") and is_row_page_type eq 1>
                                        <td title="Sayfa No/ #product_name#">#page_no#</td>
                                        <td title="Sayfa Tipi/ #product_name#">
                                            <cfloop query="get_page_types"><cfif get_page_types.page_type_id eq get_catalog_product.page_type_id>#get_page_types.page_type#</cfif></cfloop>
                                        </td>
                                        <td title="Döküman Tipi/ #product_name#">
                                            <cfif paper_type eq 1><cf_get_lang dictionary_id ='37216.Katalog'></cfif>
                                            <cfif paper_type eq 2><cf_get_lang dictionary_id="44844.Insert"></cfif>
                                        </td>
                                    </cfif>
                                    <cfif (isdefined("is_row_price") and is_row_price eq 1) or (not isdefined("is_row_price"))>
                                        <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
                                            <td title="Alis KDV siz/ #product_name#">#TLFormat(PURCHASE_PRICE,session.ep.our_company_info.purchase_price_round_num)#</td>
                                        <cfif isdefined("is_price_kdv") and is_price_kdv eq 1>
                                            <td title="Alis KDV li/ #product_name#">#TLFormat(PURCHASE_PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)#</td>
                                        </cfif>
                                        </cfif>
                                        <td title="Satis/ #product_name#">#TLFormat(SALES_PRICE,session.ep.our_company_info.sales_price_round_num)#</td>
                                        <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
                                            <td title="S.Marj/ #product_name#">#TLFormat(profit_margin)#</td>
                                        </cfif>
                                    </cfif>
                                    <cfif isdefined("extra_price_list") and len(extra_price_list)>
                                        <cfloop query="get_price_cat_row">
                                            <td><cfif len(evaluate("get_catalog_product.EXTRA_PRICEKDV_#get_price_cat_row.currentrow#"))>#tlformat(evaluate("get_catalog_product.EXTRA_PRICEKDV_#get_price_cat_row.currentrow#"),session.ep.our_company_info.sales_price_round_num)#<cfelse>#tlformat(0)#</cfif></td>
                                            <cfif get_price_cat_row.currentrow eq 1>
                                                <td align="right" nowrap class="txtboldblue" style="text-align:right;"><cfif len(get_catalog_product.EXTRA_PRODUCT_COST)>#tlformat(get_catalog_product.EXTRA_PRODUCT_COST,session.ep.our_company_info.sales_price_round_num)#<cfelse>#tlformat(0)#</cfif></td>
                                            <cfelseif get_price_cat_row.currentrow eq 2>
                                                <td align="right" nowrap class="txtboldblue" style="text-align:right;"><cfif len(get_catalog_product.EXTRA_PRODUCT_MARJ)>#tlformat(get_catalog_product.EXTRA_PRODUCT_MARJ)#<cfelse>#tlformat(0)#</cfif></td>
                                            </cfif> 
                                        </cfloop>
                                    </cfif>
                                    <cfif (isdefined("is_row_discount") and is_row_discount eq 1) or (not isdefined("is_row_discount"))>
                                        <cfloop from="1" to="#discount_count#" index="kk">
                                            <td title="İsk.#kk# / #product_name#">#TLFormat(evaluate("DISCOUNT#kk#"))#</td>
                                        </cfloop>
                                    </cfif>
                                    <cfif (isdefined("is_row_cost") and is_row_cost eq 1) or (not isdefined("is_row_cost"))>
                                        <td title="Net Maliyet/ #product_name#">#TLFormat(row_nettotal,session.ep.our_company_info.purchase_price_round_num)#</td>
                                        <td title="KDV li Maliyet/ #product_name#">#TLFormat(row_total,session.ep.our_company_info.purchase_price_round_num)#</td>
                                    </cfif>
                                    <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")> 
                                        <td title="A. Marj/ #product_name#">#TLFormat(action_profit_margin)#</td>
                                        <td nowrap title="KDV Hariç/ #product_name#">#TLFormat(action_price_kdvsiz,session.ep.our_company_info.sales_price_round_num)#</td>
                                        <td title="KDV Dahil/ #product_name#">#TLFormat(action_price,session.ep.our_company_info.sales_price_round_num)#</td>
                                        <td title="Tutar İnd./ #product_name#">#TLFormat(ACTION_PRICE_DISCOUNT,session.ep.our_company_info.sales_price_round_num)#</td>
                                    </cfif>
                                    <cfif isdefined("is_money_type") and is_money_type eq 1>
                                        <td title="Para Birimi/ #product_name#">
                                            <cfloop query="get_moneys">
                                                <cfif money eq get_catalog_product.sale_money_type>#money#</cfif>
                                            </cfloop>
                                        </td>
                                    </cfif>
                                    <cfif (isdefined("is_row_return_price") and is_row_return_price eq 1) or (not isdefined("is_row_return_price"))>
                                        <td nowrap title="KDV Hariç/ #product_name#">#TLFormat(returning_price_kdvsiz,session.ep.our_company_info.sales_price_round_num)#</td>
                                        <td nowrap title="KDV Dahil/ #product_name#">#TLFormat(returning_price,session.ep.our_company_info.sales_price_round_num)#</td>
                                        <td title="Tutar İnd./ #product_name#">#TLFormat(RETURNING_PRICE_DISCOUNT,session.ep.our_company_info.sales_price_round_num)#</td>
                                    </cfif>
                                    <cfif (isdefined("extra_price_list") and not len(extra_price_list)) or not isdefined("extra_price_list")>
                                        <td title="Alıs/ #product_name#">#TLFormat(tax_purchase,0)#</td>
                                        <td title="Satıs/ #product_name#">#TLFormat(tax,0)#</td>
                                    </cfif>
                                    <cfif (isdefined("is_row_due") and is_row_due eq 1) or (not isdefined("is_row_due"))>
                                        <td title="Vade/ #product_name#">#duedate#</td>
                                        <cfif len(shelf_id)>
                                            <cfquery name="GET_SHELF_NAME" datasource="#DSN#">
                                            SELECT
                                                SHELF_NAME
                                            FROM 
                                                SHELF
                                            WHERE
                                                SHELF_MAIN_ID = #shelf_id#
                                            </cfquery>
                                        </cfif>
                                        <td nowrap title="Raf Tipi/ #product_name#"><cfif len(shelf_id)>#GET_SHELF_NAME.SHELF_NAME#</cfif></td>
                                    </cfif>
                                    <cfif (isdefined("is_row_condition") and is_row_condition eq 1) or (not isdefined("is_row_condition"))>
                                        <td title="Back End Rebate/ #product_name#">#TLFormat(REBATE_CASH_1)#</td>
                                        <td title="Back End Rebate Oran/ #product_name#">#TLFormat(REBATE_RATE)#</td>
                                        <td title="Mal Fazlası/ #product_name#">#TLFormat(EXTRA_PRODUCT_1)# #TLFormat(EXTRA_PRODUCT_2)#</td>
                                        <td title="İade Gün - Oran/ #product_name#">#TLFormat(RETURN_DAY)# #TLFormat(RETURN_RATE)#</td>
                                        <td title="Fiyat Koruma Gün/ #product_name#">#TLFormat(PRICE_PROTECTION_DAY)#</td>
                                    </cfif>
                                    <cfif isdefined("is_extra_definition") and is_extra_definition eq 1>
                                        <td>#DETAIL_INFO#</td>
                                        <td>#REFERENCE_CODE#</td>
                                    </cfif>
                                    <cfif isdefined("is_sale_target") and is_sale_target eq 1>
                                        <td><cfif len(unit_sale)>#customer_number#<cfelse>0</cfif></td>
                                        <td><cfif len(unit_sale)>#tlformat(unit_sale)#<cfelse>#tlformat(0)#</cfif></td>
                                        <td><cfif len(total_sale)>#tlformat(total_sale)#<cfelse>#tlformat(0)#</cfif></td>
                                        <td>
                                            <cfswitch expression="sale_type_info">
                                                <cfcase value="1"><cf_get_lang dictionary_id ='37239.Normal Satış'></cfcase>
                                                <cfcase value="2"><cf_get_lang dictionary_id ='37241.Set Bileşeni'></cfcase>
                                                <cfcase value="3"><cf_get_lang dictionary_id ='37242.Promosyon Faydası'></cfcase>
                                                <cfcase value="4"><cf_get_lang dictionary_id ='37265.Promosyon Koşulu'></cfcase>
                                                <cfcase value="5"><cf_get_lang dictionary_id ='37269.Set Ana Ürünü'></cfcase>                                                                                                                                                                
                                            </cfswitch>
                                        </td>
                                    </cfif>
                                </tr>
                            </cfloop>
                        </tbody>
                    </cfif>
                </cf_grid_list>	
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="13"><cf_get_lang dictionary_id="57484.Kayıt Yok"></td> 
            </tr>
        </cfif>
    </cf_box>
</div>
