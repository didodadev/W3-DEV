<cfif not listlen(attributes.product_id_list)>
    <br /><br />
    Ürün Bulunamadı!
    <cfexit method="exittemplate">
</cfif>

<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfparam name="attributes.new_page" default="0">
<cfquery name="get_prices_all" datasource="#dsn_dev#">
SELECT
	PT.*,
    ISNULL(PT.IS_ACTIVE_S,0) AS IS_ACTIVE_S_,
    P.PRODUCT_NAME,
    (SELECT TOP 1 ETR.SUB_TYPE_NAME FROM EXTRA_PRODUCT_TYPES_ROWS ETR WHERE PT.PRODUCT_ID = ETR.PRODUCT_ID AND ETR.TYPE_ID = #uretici_type_id#) AS SUB_TYPE_NAME,
    ISNULL(PT.NEW_PRICE,(PT.NEW_PRICE_KDV/(1+SKDV/100))) NEW_PRICE_2,
    ISNULL(PTY.TYPE_NAME,'AKTARIM') TYPE_NAME,
    (SELECT COUNT(STP.PRODUCT_ID) FROM SEARCH_TABLES_PRODUCTS STP WHERE STP.TABLE_CODE = PT.TABLE_CODE) AS URUN_SAYISI              
FROM
    #dsn1_alias#.PRODUCT P,
    PRICE_TABLE PT
    LEFT JOIN PRICE_TYPES PTY ON PT.PRICE_TYPE = PTY.TYPE_ID
WHERE
    PT.PRODUCT_ID = P.PRODUCT_ID AND
    PT.PRODUCT_ID IN (#attributes.product_id_list#) AND
    PT.STARTDATE IS NOT NULL AND
    PT.FINISHDATE IS NOT NULL
ORDER BY
    PT.FINISHDATE DESC,
    PT.STARTDATE DESC,
    PT.ROW_ID DESC
</cfquery>

<cfif get_prices_all.recordcount>
    <cfquery name="get_prices_departments_all" datasource="#dsn_dev#">
    SELECT
        PTD.*
    FROM
        PRICE_TABLE_DEPARTMENTS PTD
    WHERE
        PTD.ROW_ID IN 
            (
                SELECT
                    PT.ROW_ID             
                FROM
                    #dsn1_alias#.PRODUCT P,
                    PRICE_TABLE PT
                WHERE
                    PT.PRODUCT_ID = P.PRODUCT_ID AND
                    PT.PRODUCT_ID IN (#attributes.product_id_list#) AND
                    PT.STARTDATE IS NOT NULL AND
                    PT.FINISHDATE IS NOT NULL
            )
    </cfquery>
</cfif>

<cfquery name="get_price_groups" dbtype="query" maxrows="200">
	SELECT
    	COUNT(PRODUCT_ID) AS ROW_INDIRIMLI_URUN_SAYISI,
        WRK_ID,
        PRICE_TYPE,
        STARTDATE,
        FINISHDATE,
        TYPE_NAME,
        TABLE_CODE,
        ACTION_CODE,
        IS_ACTIVE_S_ AS IS_ACTIVE_S,
        SUB_TYPE_NAME,
        URUN_SAYISI
    FROM
    	get_prices_all
    GROUP BY
    	WRK_ID,
    	PRICE_TYPE,
    	STARTDATE,
        FINISHDATE,
        TYPE_NAME,
        TABLE_CODE,
        ACTION_CODE,
        IS_ACTIVE_S_,
        SUB_TYPE_NAME,
        URUN_SAYISI
    ORDER BY
    	STARTDATE DESC,
        FINISHDATE DESC
</cfquery>

<cfquery name="get_price_groups_onayli" dbtype="query" maxrows="50">
	SELECT
    	COUNT(PRODUCT_ID) AS ROW_INDIRIMLI_URUN_SAYISI,
        PRICE_TYPE,
        STARTDATE,
        FINISHDATE,
        TYPE_NAME,
        TABLE_CODE,
        ACTION_CODE,
        IS_ACTIVE_S_ AS IS_ACTIVE_S,
        SUB_TYPE_NAME,
        URUN_SAYISI
    FROM
    	get_prices_all
    WHERE
    	IS_ACTIVE_S_ = 1
    GROUP BY
    	PRICE_TYPE,
    	STARTDATE,
        FINISHDATE,
        TYPE_NAME,
        TABLE_CODE,
        ACTION_CODE,
        IS_ACTIVE_S_,
        SUB_TYPE_NAME,
        URUN_SAYISI
    ORDER BY
    	STARTDATE DESC,
        FINISHDATE DESC
</cfquery>

<table class="dph">
  <tr>
    <td class="dpht">
    	Eski Fiyatlar
    </td>
    <td style="text-align:right;">
    <script>
	group_can_start = 1;	
	function send_price_group_control(is_active,start_,finish_,sub_type_name,price_type,table_code,secililer,grup_row,action_code)
	{
		if(grup_row == 1)
			group_can_start = 0;
				
		if(grup_row == 1 || group_can_start == 1)
		{
			adress_ = 'index.cfm?fuseaction=retail.popup_send_price_group';
			adress_ += '&is_active=' + is_active;
			adress_ += '&start_=' + start_;
			adress_ += '&finish_=' + finish_;
			adress_ += '&sub_type_name=' + sub_type_name;
			adress_ += '&price_type=' + price_type;
			adress_ += '&table_code=' + table_code;
			adress_ += '&action_code=' + action_code;
			if(secililer == '0')
				adress_ += '&is_selected=0';
			else
				adress_ += '&is_selected=1';
			adress_ += '&is_close=0';
			adress_ += '&is_group=1';
			adress_ += '<cfoutput>&product_id_list=#attributes.product_id_list#</cfoutput>';
			adress_ += '<cfoutput>&new_page=#attributes.new_page#</cfoutput>';
			AjaxPageLoad(adress_,'speed_action_div');
		}
		else
		{
			setTimeout(function(){send_price_group_control(is_active,start_,finish_,sub_type_name,price_type,table_code,secililer,grup_row)},2000);
		}	
	}
	
	function send_bir_iki_liste(secililer)
	{
    	<cfset count_ = 0>
		<cfloop from="#get_price_groups_onayli.recordcount#" to="1" index="mmk" step="-1">
		<cfoutput>
			<cfset s_bugun_fark = datediff('d',get_price_groups_onayli.startdate[mmk],bugun_)>
            <cfset f_bugun_fark = datediff('d',dateadd("d",-1,get_price_groups_onayli.finishdate[mmk]),bugun_)>
            <cfif s_bugun_fark gte 0 and f_bugun_fark lte 0>
            	<cfset count_ = count_ + 1>
				send_price_group_control('#get_price_groups_onayli.IS_ACTIVE_S[mmk]#','#dateformat(get_price_groups_onayli.startdate[mmk],"dd/mm/yyyy")#','#dateformat(get_price_groups_onayli.finishdate[mmk],"dd/mm/yyyy")#','#URLEncodedFormat(get_price_groups_onayli.SUB_TYPE_NAME[mmk])#','#get_price_groups_onayli.PRICE_TYPE[mmk]#','#get_price_groups_onayli.table_code[mmk]#',secililer,'#count_#');
			</cfif>
		</cfoutput>
		</cfloop>
	}
	</script>
    <input type="button" onclick="send_bir_iki_liste('0');" value="Standart ve İndirimlileri Getir"/>
    <input type="button" onclick="send_bir_iki_liste('1');" value="Sadece İndirimlileri Getir"/>
    </td>
  </tr>
</table>
<div id="speed_action_div"></div>
<table class="medium_list" align="center"> 
<thead>             
	<tr> 
		<th width="25"><cf_get_lang_main no='75.No'></th>
		<th>Tablo Kodu</th>
        <th>Ana İşlem Kodu</th>
        <th>İşlem Kodu</th>
        <th>Fiyat Tipi</th>
		<th>Onay</th>
        <th>Üretici</th>
        <th style="text-align:right;">Ürün S.</th>
        <th style="text-align:right;">İnd. Ürün S.</th>
		<th>St. Baş.</th>				
		<th>St. Bitiş</th>
        <th></th>
	  </tr>
	  </thead>
	  <tbody>
	  <cfoutput query="get_price_groups">
        <cfset s_bugun_fark = datediff('d',startdate,bugun_)>
        <cfset f_bugun_fark = datediff('d',dateadd("d",-1,finishdate),bugun_)>
        <cfquery name="get_alts" dbtype="query">
            SELECT DISTINCT
                * 
            FROM 
                get_prices_all 
            WHERE
                TABLE_CODE = '#table_code#' AND
                ACTION_CODE = '#action_code#' AND
                <cfif len(SUB_TYPE_NAME)>
                    SUB_TYPE_NAME = '#SUB_TYPE_NAME#' AND
                <cfelse>
                    (SUB_TYPE_NAME IS NULL OR SUB_TYPE_NAME = '') AND
                </cfif>
                TYPE_NAME = '#TYPE_NAME#' AND
                STARTDATE = #createodbcdatetime(STARTDATE)# AND
                <cfif len(FINISHDATE) and isdate(FINISHDATE)>
                    FINISHDATE = #createodbcdatetime(FINISHDATE)# AND
                </cfif>
                IS_ACTIVE_S = #IS_ACTIVE_S#
        </cfquery>
        <cfset row_list = valuelist(get_alts.row_id)>
        <cfif get_prices_departments_all.recordcount and get_alts.recordcount>
        	<cfquery name="get_group_d" dbtype="query">
            	SELECT ROW_ID FROM get_prices_departments_all WHERE ROW_ID IN (#row_list#)
            </cfquery>
            <cfif get_group_d.recordcount>
            	<cfset alt_row_list = valuelist(get_group_d.ROW_ID)>
            <cfelse>
            	<cfset alt_row_list = "">
            </cfif>
        <cfelse>
        	<cfset alt_row_list = "">
        </cfif>
        <tr>
            <td>#currentrow#</td>
            <td><a href="javascript://" onclick="send_price_group_table('#table_code#');" class="tableyazi"  style="<cfif s_bugun_fark gte 0 and f_bugun_fark lte 0>color:##F39; font-weight:bold;<cfelse></cfif>">#table_code#</a></td>
            <td><a href="javascript://" onclick="send_price_group_table_w('#table_code#','#wrk_id#');" class="tableyazi">#wrk_id#</a></td>
            <td><a href="javascript://" onclick="send_price_group_table_a('#table_code#','#action_code#');" class="tableyazi"  style="<cfif s_bugun_fark gte 0 and f_bugun_fark lte 0>color:##F39; font-weight:bold;<cfelse></cfif>">#action_code#</a></td>
            <td><a href="javascript://" onclick="send_price_group_table_p('#table_code#','#price_type#');" class="tableyazi">#TYPE_NAME#</a></td>
            <td style="<cfif IS_ACTIVE_S eq 1>color:green;<cfelse>color:red;</cfif>"><cfif IS_ACTIVE_S eq 1>Onaylı<cfelse>Onaysız</cfif></td>
            <td><a href="javascript://" onclick="$('##row_#currentrow#').toggle();" class="tableyazi"><cfif len(SUB_TYPE_NAME)>#SUB_TYPE_NAME#<cfelse><font color="red">Üretici Girilmemiş</font></cfif></a></td>
            <td style="text-align:right;">#URUN_SAYISI#</td>
            <td style="text-align:right;">#ROW_INDIRIMLI_URUN_SAYISI#</td>
            <td>#dateformat(startdate,'dd/mm/yyyy')#</td>
            <td style="<cfif f_bugun_fark lte 0>background-color:##0F6;</cfif>"><a href="javascript://" onclick="send_price_group('#IS_ACTIVE_S#','#dateformat(startdate,'dd/mm/yyyy')#','#dateformat(finishdate,'dd/mm/yyyy')#','#URLEncodedFormat(SUB_TYPE_NAME)#','#PRICE_TYPE#','#table_code#');" class="tableyazi">#dateformat(finishdate,'dd/mm/yyyy')#</a></td>
       		<td <cfif listlen(alt_row_list)>title="Mağaza Bazlı Fiyatlandırma Var!"</cfif>><cfif listlen(alt_row_list)>MB</cfif></td>
       </tr>
       <tr id="row_#currentrow#" style="display:none;">
       		<td colspan="12" style="background-color:##F63">
                <table width="100%">
                	<thead>
                	<tr class="formbold">
                    	<td>Ürün</td>
                        <td>St. O.</td>
                        <td>St. Baş.</td>				
                        <td>St. Bitiş</td>
                        <td>St. Fiyat</td>
                        <td>St. KDVli</td>				              
                        <td>Al. O.</td>
                        <td>Al. Baş.</td>				
                        <td>Al. Bitiş</td>
                        <td>Br. Alış</td>
                        <td>% İnd.</td>
                        <td>M. İnd.</td>
                        <td>Al. Fiyat</td>
                        <td>Al. KDVli</td>
                        <td>St. Kar</td>
                        <td>Al. Kar</td>
                        <td>Vade</td>
                        <td>Tarih</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody>
                    <cfloop query="get_alts">
                    <cfset discount_list = "">
                    <cfloop from="1" to="10" index="ccc">
                        <cfif len(evaluate("get_alts.discount#ccc#")) and evaluate("get_alts.discount#ccc#") neq 0>
                            <cfset discount_list = listappend(discount_list,tlformat(evaluate("get_alts.discount#ccc#")),'+')>
                        </cfif>
                    </cfloop>
                    	<tr>
                            <td>#get_alts.product_name#</td>
                            <td style="background-color:##DEB887; color:white;"><cfif get_alts.IS_ACTIVE_S eq 0 and get_alts.IS_ACTIVE_P eq 0>Teklif<cfelseif IS_ACTIVE_S eq 1>1</cfif></td>
                            <td style="background-color:##DEB887; color:white;">#dateformat(get_alts.startdate,'dd/mm/yyyy')#</td>                
                            <td style="background-color:##DEB887; color:white;">#dateformat(get_alts.finishdate,'dd/mm/yyyy')#</td>                
                            <td style="background-color:##DEB887; color:white;">#TLFormat(get_alts.NEW_PRICE_2,session.ep.our_company_info.sales_price_round_num)#</td>
                            <td style="background-color:##DEB887; color:white;">#TLFormat(get_alts.NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#</td>
                            <td><cfif get_alts.IS_ACTIVE_S eq 0 and get_alts.IS_ACTIVE_P eq 0>Teklif<cfelseif get_alts.IS_ACTIVE_P eq 1>1</cfif></td>
                            <td>#dateformat(get_alts.p_startdate,'dd/mm/yyyy')#</td>                
                            <td>#dateformat(get_alts.p_finishdate,'dd/mm/yyyy')#</td>
                            <td>#tlformat(get_alts.brut_alis)#</td>
                            <td>#discount_list#</td>
                            <td>#tlformat(get_alts.manuel_discount)#</td>
                            <td>#TLFormat(get_alts.new_alis,session.ep.our_company_info.sales_price_round_num)#</td>
                            <td>#TLFormat(get_alts.new_alis_kdv,session.ep.our_company_info.sales_price_round_num)#</td>
                            <td>#get_alts.margin#</td>
                            <td>#get_alts.p_margin#</td>
                            <td>#get_alts.dueday#</td>
                            <td>#dateformat(get_alts.record_date,'dd/mm/yyyy')#</td>
                            <td <cfif listlen(alt_row_list) and listfind(alt_row_list,get_alts.row_id)>title="Mağaza Bazlı Fiyatlandırma Var!"</cfif>><cfif listlen(alt_row_list) and listfind(alt_row_list,get_alts.row_id)>MB</cfif></td>
                        </tr>
                    </cfloop>
                    </tbody>
                </table>
            </td>
       </tr>			  
	  </cfoutput> 
	</tbody>
</table>
<script>
function send_price_group(is_active,start_,finish_,sub_type_name,price_type,table_code)
{
	adress_ = 'index.cfm?fuseaction=retail.popup_send_price_group';
	adress_ += '&is_active=' + is_active;
	adress_ += '&start_=' + start_;
	adress_ += '&finish_=' + finish_;
	adress_ += '&sub_type_name=' + sub_type_name;
	adress_ += '&price_type=' + price_type;
	adress_ += '&table_code=' + table_code;
	adress_ += '&is_selected=1';
	adress_ += '&is_close=0';
	adress_ += '<cfoutput>&product_id_list=#attributes.product_id_list#</cfoutput>';
	adress_ += '<cfoutput>&new_page=#attributes.new_page#</cfoutput>';
	AjaxPageLoad(adress_,'speed_action_div');
}

function send_price_group_table(table_code)
{
	adress_ = 'index.cfm?fuseaction=retail.popup_send_price_group';
	adress_ += '&table_code=' + table_code;
	adress_ += '&is_selected=1';
	adress_ += '&is_close=0';
	adress_ += '<cfoutput>&product_id_list=#attributes.product_id_list#</cfoutput>';
	adress_ += '<cfoutput>&new_page=#attributes.new_page#</cfoutput>';
	AjaxPageLoad(adress_,'speed_action_div');
}

function send_price_group_table_p(table_code,price_type)
{
	adress_ = 'index.cfm?fuseaction=retail.popup_send_price_group';
	adress_ += '&table_code=' + table_code;
	adress_ += '&price_type=' + price_type;
	adress_ += '&is_selected=1';
	adress_ += '&is_close=0';
	adress_ += '<cfoutput>&product_id_list=#attributes.product_id_list#</cfoutput>';
	adress_ += '<cfoutput>&new_page=#attributes.new_page#</cfoutput>';
	AjaxPageLoad(adress_,'speed_action_div');
}

function send_price_group_table_w(table_code,wrk_id)
{
	adress_ = 'index.cfm?fuseaction=retail.popup_send_price_group';
	adress_ += '&wrk_id=' + wrk_id;
	adress_ += '&is_selected=1';
	adress_ += '&is_close=0';
	adress_ += '&table_code=' + table_code;
	adress_ += '<cfoutput>&product_id_list=#attributes.product_id_list#</cfoutput>';
	adress_ += '<cfoutput>&new_page=#attributes.new_page#</cfoutput>';
	AjaxPageLoad(adress_,'speed_action_div');
}

function send_price_group_table_a(table_code,action_code)
{
	adress_ = 'index.cfm?fuseaction=retail.popup_send_price_group';
	adress_ += '&table_code=' + table_code;
	adress_ += '&action_code=' + action_code;
	adress_ += '&is_selected=1';
	adress_ += '&is_close=0';
	adress_ += '<cfoutput>&product_id_list=#attributes.product_id_list#</cfoutput>';
	adress_ += '<cfoutput>&new_page=#attributes.new_page#</cfoutput>';
	AjaxPageLoad(adress_,'speed_action_div');
}
</script>