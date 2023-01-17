<cfparam name="attributes.form_submitted" default="1">
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')>	
</cfif>

<cfparam name="attributes.table_code" default="">
<cfset attributes.table_code = replace(attributes.table_code,',','+','all')>

<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_table_codes" datasource="#dsn_dev#" result="my_result">
    	SELECT TOP 5
        	E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            (SELECT COUNT(STP.ROW_ID) AS SAYI FROM SEARCH_TABLES_PRODUCTS STP WHERE STP.TABLE_ID = ST.TABLE_ID) AS URUN_SAYISI,
            (
            	SELECT 
                	COUNT(DISTINCT PT2.PRODUCT_ID) AS SAYI 
                FROM 
                	PRICE_TABLE PT2 
                WHERE 
                	PT2.TABLE_ID = ST.TABLE_ID AND
                    (
                        (PT2.IS_ACTIVE_S = 1 AND DATEADD("d",-1,PT2.FINISHDATE) = #attributes.finishdate#)
                    )
            ) AS FIYAT_URUN_SAYISI,
            (
            	SELECT 
                	COUNT(DISTINCT PT2.PRODUCT_ID) AS SAYI 
                FROM 
                	PRICE_TABLE PT2 
                WHERE 
                	PT2.TABLE_ID = ST.TABLE_ID AND
                    (
                        (PT2.IS_ACTIVE_P = 1 AND PT2.P_FINISHDATE = #attributes.finishdate#)
                    )
            ) AS FIYAT_URUN_SAYISI_ALIS,
            (SELECT E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E2 WHERE E2.EMPLOYEE_ID = ST.UPDATE_EMP) AS GUNCELLEYEN,
            ST.*
        FROM
        	SEARCH_TABLES ST,
            #dsn_alias#.EMPLOYEES E
        WHERE
			ST.TABLE_ID IN
            (
               SELECT
               		PT.TABLE_ID
               FROM
               		PRICE_TABLE PT
               WHERE
                (
                    (PT.IS_ACTIVE_S = 1 AND DATEADD("d",-1,PT.FINISHDATE) = #attributes.finishdate#)
                ) 
           	)
            AND
			<cfif len(attributes.keyword)>
            	ST.TABLE_INFO LIKE '%#attributes.keyword#%' AND
            </cfif>
			<cfif len(attributes.table_code)>
            	<cfif listlen(attributes.table_code,'+') eq 1>
            		ST.TABLE_CODE LIKE '%#attributes.table_code#%' AND
                <cfelse>
                	(
                    	<cfloop from="1" to="#listlen(attributes.table_code,'+')#" index="ccc">
                        	<cfset code_ = listgetat(attributes.table_code,ccc,'+')>
                        	ST.TABLE_CODE LIKE '%#code_#'
                        	<cfif ccc neq listlen(attributes.table_code,'+')>OR</cfif>
                        </cfloop>
                    )
                    AND
                </cfif>
            </cfif>
            <cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>
            	(
                ST.RECORD_EMP = #attributes.record_emp_id#
                OR
                ST.UPDATE_EMP = #attributes.record_emp_id#
                ) 
                AND
            </cfif>
        	ST.RECORD_EMP = E.EMPLOYEE_ID
    </cfquery>
<cfelse>
	<cfset get_table_codes.recordcount=0>
</cfif>

<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_table_codes_alis" datasource="#dsn_dev#" result="my_result">
    	SELECT TOP 5
        	E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
            (SELECT COUNT(STP.ROW_ID) AS SAYI FROM SEARCH_TABLES_PRODUCTS STP WHERE STP.TABLE_ID = ST.TABLE_ID) AS URUN_SAYISI,
            (
            	SELECT 
                	COUNT(DISTINCT PT2.PRODUCT_ID) AS SAYI 
                FROM 
                	PRICE_TABLE PT2 
                WHERE 
                	PT2.TABLE_ID = ST.TABLE_ID AND
                    (
                        (PT2.IS_ACTIVE_S = 1 AND DATEADD("d",-1,PT2.FINISHDATE) = #attributes.finishdate#)
                    )
            ) AS FIYAT_URUN_SAYISI,
            (
            	SELECT 
                	COUNT(DISTINCT PT2.PRODUCT_ID) AS SAYI 
                FROM 
                	PRICE_TABLE PT2 
                WHERE 
                	PT2.TABLE_ID = ST.TABLE_ID AND
                    (
                        (PT2.IS_ACTIVE_P = 1 AND PT2.P_FINISHDATE = #attributes.finishdate#)
                    )
            ) AS FIYAT_URUN_SAYISI_ALIS,
            (SELECT E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME FROM #dsn_alias#.EMPLOYEES E2 WHERE E2.EMPLOYEE_ID = ST.UPDATE_EMP) AS GUNCELLEYEN,
            ST.*
        FROM
        	SEARCH_TABLES ST,
            #dsn_alias#.EMPLOYEES E
        WHERE
			ST.TABLE_ID IN
            (
               SELECT
               		PT.TABLE_ID
               FROM
               		PRICE_TABLE PT
               WHERE
                (
                    (PT.IS_ACTIVE_P = 1 AND DATEADD("d",-1,PT.FINISHDATE) = #attributes.finishdate#)
                ) 
           	)
            AND
			<cfif len(attributes.keyword)>
            	ST.TABLE_INFO LIKE '%#attributes.keyword#%' AND
            </cfif>
			<cfif len(attributes.table_code)>
            	<cfif listlen(attributes.table_code,'+') eq 1>
            		ST.TABLE_CODE LIKE '%#attributes.table_code#%' AND
                <cfelse>
                	(
                    	<cfloop from="1" to="#listlen(attributes.table_code,'+')#" index="ccc">
                        	<cfset code_ = listgetat(attributes.table_code,ccc,'+')>
                        	ST.TABLE_CODE LIKE '%#code_#'
                        	<cfif ccc neq listlen(attributes.table_code,'+')>OR</cfif>
                        </cfloop>
                    )
                    AND
                </cfif>
            </cfif>
            <cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>
            	(
                ST.RECORD_EMP = #attributes.record_emp_id#
                OR
                ST.UPDATE_EMP = #attributes.record_emp_id#
                ) 
                AND
            </cfif>
        	ST.RECORD_EMP = E.EMPLOYEE_ID
    </cfquery>
<cfelse>
	<cfset get_table_codes_alis.recordcount=0>
</cfif>

<cfset all_product_list = "">
<cfset sale_all_product_list = "">
<cfset purchase_all_product_list = "">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_table_codes.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="header_">Fiyat Değişimleri</cfsavecontent>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=retail.list_price_changes">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
    <cf_big_list_search title="#header_#"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td>Tablo No</td>
                    <td><cfinput type="text" name="table_code" id="table_code" style="width:75px;" value="#attributes.table_code#" maxlength="500"></td>
                    <td>Filtre</td>
                    <td><cfinput type="text" name="keyword" id="keyword" style="width:75px;" value="#attributes.keyword#" maxlength="500"></td>
                    <td><cf_get_lang_main no='487.Kaydeden'></td>
					<td>
						<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
						<input name="record_emp_name" type="text" id="record_emp_name" style="width:100px;" onfocus="AutoComplete_Create('record_emp_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','','3','130');" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" maxlength="255" autocomplete="off">
						<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_form.record_emp_id&field_name=search_form.record_emp_name&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.record_emp_name.value),'list','popup_list_positions');"><img src="/images/plus_thin.gif"></a>
					</td>
                    <td>
                        <cfsavecontent variable="message">Bitiş</cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <cf_wrk_date_image date_field="finishdate">
                    </td>
                    <td>
                        <cfsavecontent variable="message">Sayi_Hatasi_Mesaj</cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                    </td>
                    <td><cf_wrk_search_button></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>

<table width="99%" align="center">
	<tr>
    	<td class="formbold" height="30">Satış Bitenler</td>
    </tr>
</table>
<table class="big_list"> 
    <thead>
        <tr>
            <th width="25"></th>
            <th>Tablo Kodu</th>
            <th>Açıklama</th>
            <th width="65">Ürün Sayısı</th>
            <th width="65">Fiyalandırılacak Sayı</th>
            <th width="65">Kayıt</th>
            <th width="80">Kayıt Tarihi</th>
            <th width="65">Son Güncelleme</th>
            <th width="80">Güncelleme Tarihi</th>
        </tr> 
    </thead>
    <tbody>
        <cfif get_table_codes.recordcount>
		<cfoutput query="get_table_codes">
            <cfquery name="get_alts" datasource="#dsn_dev#">
               SELECT
                    PT.*,
                    ISNULL(PT.IS_ACTIVE_S,0) AS IS_ACTIVE_S_,
                    P.PRODUCT_NAME,
                    ISNULL(PT.NEW_PRICE,(PT.NEW_PRICE_KDV/(1+SKDV/100))) NEW_PRICE_2,
                    ISNULL(PTY.TYPE_NAME,'AKTARIM') TYPE_NAME,
                    (SELECT COUNT(STP.PRODUCT_ID) FROM SEARCH_TABLES_PRODUCTS STP WHERE STP.TABLE_CODE = PT.TABLE_CODE) AS URUN_SAYISI              
                FROM
                    #dsn1_alias#.PRODUCT P,
                    PRICE_TABLE PT
                    LEFT JOIN PRICE_TYPES PTY ON PT.PRICE_TYPE = PTY.TYPE_ID
                WHERE
                    PT.TABLE_CODE = '#TABLE_CODE#' AND
                     (
                        (PT.IS_ACTIVE_S = 1 AND DATEADD("d",-1,PT.FINISHDATE) = #attributes.finishdate#)
                    )  
                    AND
                    PT.PRODUCT_ID = P.PRODUCT_ID AND
                    PT.STARTDATE IS NOT NULL AND
                    PT.FINISHDATE IS NOT NULL AND
                    PT.PRODUCT_ID NOT IN 
                    	(
                        	SELECT 
                            	PT2.PRODUCT_ID
                            FROM
                            	PRICE_TABLE PT2
                            WHERE
                            	PT2.STARTDATE <= #DATEADD('d',1,attributes.finishdate)# AND
								PT2.FINISHDATE > #DATEADD('d',1,attributes.finishdate)# AND
                                PT2.ROW_ID <> PT.ROW_ID AND
                                (PT2.IS_ACTIVE_S = 1)
                        )
                ORDER BY
                    PT.FINISHDATE DESC,
                    PT.STARTDATE DESC,
                    PT.ROW_ID DESC
            </cfquery>

           <cfset p_list_ = valuelist(get_alts.product_id)>
           <cfif get_alts.recordcount>
           <cfset all_product_list = listappend(all_product_list,valuelist(get_alts.product_id))>
           <cfset sale_all_product_list = listappend(sale_all_product_list,valuelist(get_alts.product_id))>
            <tr>
                <td><input type="checkbox" name="sale_all_product_list" id="sale_all_product_list" value="#valuelist(get_alts.product_id)#" checked="checked"/></td>
                <td><a href="#request.self#?fuseaction=retail.speed_manage_product_new&table_code=#table_code#&is_form_submitted=1&calc_type=3&search_selected_product_list=#p_list_#" class="tableyazi">#TABLE_CODE#</a></td>
                <td>#table_info#</td>
                <td>#URUN_SAYISI#</td>
                <td><a href="javascript://" onclick="$('##row_#currentrow#').toggle();" class="tableyazi">#listlen(p_list_)#</a></td>
                <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                <td>
                	<cfset record_ = dateadd("h",session.ep.time_zone,record_Date)>
                    #dateformat(record_,'dd/mm/yyyy')# #timeformat(record_,'HH:MM')#
                </td>
                <td>#GUNCELLEYEN#</td>
                <td>#dateformat(update_Date,'dd/mm/yyyy')#</td>
            </tr>
            <tr id="row_#currentrow#" style="display:none;">
       		<td colspan="10" style="background-color:##F63">
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
                        </tr>
                    </cfloop>
                    </tbody>
                </table>
            </td>
       </tr>		
       </cfif>
        </cfoutput>
        <cfelse>
            <tr>
                <td colspan="10"><cfif isdefined("attributes.form_submitted")>Kayıt Bulunamadı !<cfelse>Filtre Ediniz !</cfif></td>
            </tr>
        </cfif>
    </tbody>
</table> 
<br /> 

<cfif listlen(sale_all_product_list)>
    <cfform action="#request.self#?fuseaction=retail.speed_manage_product_new" method="post" name="form1">
        <cfinput type="hidden" name="is_from_price_change" value="1">
        <cfinput type="hidden" name="calc_type" value="3">
        <cfinput type="hidden" name="finishdate" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
        <cfinput type="hidden" name="selected_product_id" value="#listdeleteduplicates(sale_all_product_list)#">
        <input type="submit" name="gonder" value="Satışı Bitenleri Bir Tabloda Topla">
    </cfform>
</cfif>
<br /> 

<table width="99%" align="center">
	<tr>
    	<td class="formbold" height="30">Alış Bitenler</td>
    </tr>
</table>
<table class="big_list">
    <thead>
        <tr>
            <th width="25"></th>
            <th>Tablo Kodu</th>
            <th>Açıklama</th>
            <th width="65">Ürün Sayısı</th>
            <th width="65">Fiyalandırılacak Sayı</th>
            <th width="65">Kayıt</th>
            <th width="80">Kayıt Tarihi</th>
            <th width="65">Son Güncelleme</th>
            <th width="80">Güncelleme Tarihi</th>
        </tr> 
    </thead>
    <tbody>
        <cfif get_table_codes_alis.recordcount>
		<cfoutput query="get_table_codes_alis">
            <cfquery name="get_alts" datasource="#dsn_dev#">
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
                    PT.TABLE_CODE = '#TABLE_CODE#' AND
                   (PT.IS_ACTIVE_P = 1 AND DATEADD("d",-1,PT.P_FINISHDATE) = #attributes.finishdate#) AND
                    PT.PRODUCT_ID = P.PRODUCT_ID AND
                    PT.STARTDATE IS NOT NULL AND
                    PT.FINISHDATE IS NOT NULL AND
                    PT.PRODUCT_ID NOT IN 
                    	(
                        	SELECT 
                            	PT2.PRODUCT_ID
                            FROM
                            	PRICE_TABLE PT2
                            WHERE
                            	PT2.STARTDATE <= #DATEADD('d',1,attributes.finishdate)# AND
								PT2.FINISHDATE > #DATEADD('d',1,attributes.finishdate)# AND
                                PT2.ROW_ID <> PT.ROW_ID AND
                                (PT2.IS_ACTIVE_P = 1)
                        )
                ORDER BY
                    PT.FINISHDATE DESC,
                    PT.STARTDATE DESC,
                    PT.ROW_ID DESC
            </cfquery>

            <cfset p_list_ = valuelist(get_alts.product_id)>
           <cfif get_alts.recordcount>
           <cfset all_product_list = listappend(all_product_list,valuelist(get_alts.product_id))>
           <cfset purchase_all_product_list = listappend(purchase_all_product_list,valuelist(get_alts.product_id))>
            <tr>
                <td><input type="checkbox" name="purchase_all_product_list" id="purchase_all_product_list" value="#valuelist(get_alts.product_id)#" checked="checked"/></td>
                <td><a href="#request.self#?fuseaction=retail.speed_manage_product&table_code=#table_code#&is_form_submitted=1&calc_type=3&search_selected_product_list=#p_list_#" class="tableyazi" target="_blank">#TABLE_CODE#</a></td>
                <td>#table_info#</td>
                <td>#URUN_SAYISI#</td>
                <td><a href="javascript://" onclick="$('##arow_#currentrow#').toggle();" class="tableyazi">#listlen(p_list_)#</a></td>
                <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                <td>
                	<cfset record_ = dateadd("h",session.ep.time_zone,record_Date)>
                    #dateformat(record_,'dd/mm/yyyy')# #timeformat(record_,'HH:MM')#
                </td>
                <td>#GUNCELLEYEN#</td>
                <td>#dateformat(update_Date,'dd/mm/yyyy')#</td>
            </tr>
            <tr id="arow_#currentrow#" style="display:none;">
       		<td colspan="10" style="background-color:##F63">
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
                        </tr>
                    </cfloop>
                    </tbody>
                </table>
            </td>
       </tr>		
       </cfif>
        </cfoutput>
        <cfelse>
            <tr>
                <td colspan="10"><cfif isdefined("attributes.form_submitted")>Kayıt Bulunamadı !<cfelse>Filtre Ediniz !</cfif></td>
            </tr>
        </cfif>
    </tbody>
</table>
<br />
<cfif listlen(purchase_all_product_list)>
    <cfform action="#request.self#?fuseaction=retail.speed_manage_product_new" method="post" name="form1">
        <cfinput type="hidden" name="is_from_price_change" value="1">
        <cfinput type="hidden" name="calc_type" value="3">
        <cfinput type="hidden" name="finishdate" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
        <cfinput type="hidden" name="selected_product_id" value="#listdeleteduplicates(purchase_all_product_list)#">
        <input type="submit" name="gonder" value="Alışı Bitenleri Bir Tabloda Topla">
    </cfform>
</cfif>
<br /> 
<hr />
<br />
<cfif listlen(all_product_list)>
    <cfform action="#request.self#?fuseaction=retail.speed_manage_product_new" method="post" name="form1">
        <cfinput type="hidden" name="is_from_price_change" value="1">
        <cfinput type="hidden" name="calc_type" value="3">
        <cfinput type="hidden" name="finishdate" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
        <cfinput type="hidden" name="selected_product_id" value="#listdeleteduplicates(all_product_list)#">
        <input type="submit" name="gonder" value="Tüm Ürünleri Bir Tabloda Topla">
    </cfform>
</cfif>