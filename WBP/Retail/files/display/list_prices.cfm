<cfparam name="attributes.form_submitted" default="1">
<cfparam name="attributes.onay_tipi" default="1">
<cfset bugun_ = now()>
<cfset base_date_ = bugun_>
<cfif isdefined("attributes.startdate") and len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
<cfelse>
	<cfset attributes.startdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfif isdefined("attributes.finishdate") and len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
<cfelse>
	<cfset attributes.finishdate = createodbcdatetime('#year(base_date_)#-#month(base_date_)#-#day(base_date_)#')>	
</cfif>

<cfparam name="attributes.action_code" default="">
<cfparam name="attributes.table_code" default="">
<cfset attributes.table_code = replace(attributes.table_code,',','+','all')>
<cfset attributes.action_code = replace(attributes.action_code,',','+','all')>

<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.price_status" default="">
<cfparam name="attributes.new_price_type" default="1">
<cfparam name="attributes.is_main" default="2">
<cfparam name="attributes.keyword" default="">


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>


<cfquery name="get_table_codes" datasource="#dsn_dev#" result="aaa">
    SELECT DISTINCT
        ISNULL((SELECT COUNT(DISTINCT PRODUCT_ID) FROM PRICE_TABLE PT2 WHERE PT2.ACTION_CODE = A1.ACTION_CODE AND PT2.TABLE_CODE = A1.TABLE_CODE),0) AS URUN_SAYISI,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        ST.TABLE_CODE,
        ST.TABLE_INFO,
        PT.TYPE_NAME,
        A1.*
    FROM
        (
        SELECT DISTINCT 
            ISNULL(PRICE_TYPE,0) AS PRICE_TYPE,
            P_STARTDATE,
            P_FINISHDATE,
            STARTDATE,
            FINISHDATE,
            TABLE_CODE,
            ACTION_CODE,
            RECORD_EMP,
            IS_ACTIVE_S,
            IS_ACTIVE_P
        FROM
            PRICE_TABLE,
			#DSN1_ALIAS#.PRODUCT P
        WHERE
        	P.PRODUCT_ID = PRICE_TABLE.PRODUCT_ID AND
			(P.IS_SALES = 1 OR P.IS_PURCHASE = 1) AND
			P.PRODUCT_STATUS = 1 AND
            ROW_ID > 0
        <cfif attributes.new_price_type eq 1>	
        	AND
            P.PRODUCT_ID NOT IN 
            (
                SELECT 
                    PT2.PRODUCT_ID
                FROM
                    PRICE_TABLE PT2
                WHERE
                    PT2.STARTDATE <= #DATEADD('d',1,attributes.finishdate)# AND
                    PT2.FINISHDATE > #DATEADD('d',1,attributes.finishdate)# AND
                    PT2.ROW_ID <> PRICE_TABLE.ROW_ID AND
                    (PT2.IS_ACTIVE_S = #attributes.onay_tipi#) AND
                    PT2.ROW_ID NOT IN (SELECT PTD.ROW_ID FROM PRICE_TABLE_DEPARTMENTS PTD)
            )
        </cfif>
        ) AS A1,
        SEARCH_TABLES ST,
        #dsn_alias#.EMPLOYEES E,
        PRICE_TYPES PT
    WHERE
        <cfif attributes.is_main eq 1>
        	ST.IS_MAIN = 1 AND
        </cfif>
        A1.IS_ACTIVE_S = #attributes.onay_tipi# AND
        A1.PRICE_TYPE = PT.TYPE_ID AND
        A1.TABLE_CODE = ST.TABLE_CODE AND
        <cfif len(attributes.keyword)>
            ST.TABLE_INFO LIKE '%#attributes.keyword#%' AND
        </cfif>
        <cfif len(attributes.action_code)>
            <cfif listlen(attributes.action_code,'+') eq 1>
                A1.ACTION_CODE LIKE '%#attributes.action_code#%' AND
            <cfelse>
                (
                    <cfloop from="1" to="#listlen(attributes.action_code,'+')#" index="ccc">
                        <cfset code_ = listgetat(attributes.action_code,ccc,'+')>
                        A1.ACTION_CODE LIKE '%#code_#'
                        <cfif ccc neq listlen(attributes.action_code,'+')>OR</cfif>
                    </cfloop>
                )
                AND
            </cfif>
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
            A1.RECORD_EMP = #attributes.record_emp_id#
            OR
            A1.UPDATE_EMP = #attributes.record_emp_id#
            ) 
            AND
        </cfif>
        (
        	DATEADD("d",-1,A1.FINISHDATE) = #attributes.finishdate#
        ) 
        AND
        A1.RECORD_EMP = E.EMPLOYEE_ID
   ORDER BY
    A1.TABLE_CODE ASC
</cfquery>
<cfquery name="get_table_codes_alis" datasource="#dsn_dev#">
    SELECT DISTINCT
        ISNULL((SELECT COUNT(ROW_ID) FROM PRICE_TABLE PT2 WHERE PT2.ACTION_CODE = A1.ACTION_CODE AND PT2.TABLE_CODE = A1.TABLE_CODE),0) AS URUN_SAYISI,
        E.EMPLOYEE_NAME,
        E.EMPLOYEE_SURNAME,
        ST.TABLE_CODE,
        ST.TABLE_INFO,
        PT.TYPE_NAME,
        A1.*
    FROM
        (
        SELECT DISTINCT 
            ISNULL(PRICE_TYPE,0) AS PRICE_TYPE,
            P_STARTDATE,
            P_FINISHDATE,
            STARTDATE,
            FINISHDATE,
            TABLE_CODE,
            ACTION_CODE,
            RECORD_EMP,
            IS_ACTIVE_S,
            IS_ACTIVE_P
        FROM
            PRICE_TABLE,
			#DSN1_ALIAS#.PRODUCT P
        WHERE
        	P.PRODUCT_ID = PRICE_TABLE.PRODUCT_ID AND
			(P.IS_SALES = 1 OR P.IS_PURCHASE = 1) AND
			P.PRODUCT_STATUS = 1 AND
            ROW_ID > 0
		<cfif attributes.new_price_type eq 1>
        AND
        	P.PRODUCT_ID NOT IN 
            (
                SELECT 
                    PT2.PRODUCT_ID
                FROM
                    PRICE_TABLE PT2
                WHERE
                    PT2.P_STARTDATE <= #DATEADD('d',1,attributes.finishdate)# AND
                    PT2.P_FINISHDATE > #DATEADD('d',1,attributes.finishdate)# AND
                    PT2.ROW_ID <> PRICE_TABLE.ROW_ID AND
                    (PT2.IS_ACTIVE_P = #attributes.onay_tipi#) AND
                    PT2.ROW_ID NOT IN (SELECT PTD.ROW_ID FROM PRICE_TABLE_DEPARTMENTS PTD)
            )
        </cfif>
        ) AS A1,
        SEARCH_TABLES ST,
        #dsn_alias#.EMPLOYEES E,
        PRICE_TYPES PT
    WHERE
        <cfif attributes.is_main eq 1>
        	ST.IS_MAIN = 1 AND
        </cfif>
        A1.IS_ACTIVE_P = #attributes.onay_tipi# AND
        A1.PRICE_TYPE = PT.TYPE_ID AND
        A1.TABLE_CODE = ST.TABLE_CODE AND
        <cfif len(attributes.keyword)>
            ST.TABLE_INFO LIKE '%#attributes.keyword#%' AND
        </cfif>
        <cfif len(attributes.action_code)>
            <cfif listlen(attributes.action_code,'+') eq 1>
                A1.ACTION_CODE LIKE '%#attributes.action_code#%' AND
            <cfelse>
                (
                    <cfloop from="1" to="#listlen(attributes.action_code,'+')#" index="ccc">
                        <cfset code_ = listgetat(attributes.action_code,ccc,'+')>
                        A1.ACTION_CODE LIKE '%#code_#'
                        <cfif ccc neq listlen(attributes.action_code,'+')>OR</cfif>
                    </cfloop>
                )
                AND
            </cfif>
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
            A1.RECORD_EMP = #attributes.record_emp_id#
            OR
            A1.UPDATE_EMP = #attributes.record_emp_id#
            ) 
            AND
        </cfif>
        (
        	DATEADD("d",-1,A1.P_FINISHDATE) = #attributes.finishdate#
        ) 
        AND
        A1.RECORD_EMP = E.EMPLOYEE_ID
   ORDER BY
    A1.TABLE_CODE ASC
</cfquery>

<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search_form" method="post" action="#request.self#?fuseaction=retail.list_prices">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='61483.Tablo No'></cfsavecontent>
                    <cfinput type="text" placeholder="#message#" name="table_code" id="table_code" style="width:75px;" value="#attributes.table_code#" maxlength="500">
                </div>
                <div class="form-group">
                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='58772.İşlem No'></cfsavecontent>
                    <cfinput type="text" placeholder="#message#" name="action_code" id="action_code" style="width:75px;" value="#attributes.action_code#" maxlength="500">
                </div>
                <div class="form-group">
                    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" placeholder="#message#" name="keyword" id="keyword" style="width:75px;" value="#attributes.keyword#" maxlength="500">
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                        <input name="record_emp_name" type="text" id="record_emp_name" style="width:100px;" onfocus="AutoComplete_Create('record_emp_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','','3','130');" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" maxlength="255" autocomplete="off" placeholder="<cfoutput>#getLang("","Kaydeden",57899)#</cfoutput>">
                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_form.record_emp_id&field_name=search_form.record_emp_name&select_list=1&is_form_submitted=1','list','popup_list_positions');"><img src="/images/plus_thin.gif"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57501.Başlangıç'></cfsavecontent>
                        <cfinput type="text" name="startdate" value="#dateformat(attributes.startdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57502.Bitiş'></cfsavecontent>
                        <cfinput type="text" name="finishdate" value="#dateformat(attributes.finishdate, 'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" required="yes" style="width:65px;">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" required="yes" message="#message#" range="1,250" style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group">
                        <select name="new_price_type">
                            <option value="1" <cfif attributes.new_price_type eq 1>selected</cfif>><cf_get_lang dictionary_id='61553.Yeni Fiyat Yapılanlar Gelmesin'></option>
                            <option value="0" <cfif attributes.new_price_type eq 0>selected</cfif>><cf_get_lang dictionary_id='61554.Tüm Ürünler Gelsin'></option>
                        </select>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group">
                        <select name="is_main">
                            <option value="1" <cfif attributes.is_main eq 1>selected</cfif>><cf_get_lang dictionary_id='61555.Sadece Ana Listeler'></option>
                            <option value="2" <cfif attributes.is_main eq 2>selected</cfif>><cf_get_lang dictionary_id='37305.Tüm Listeler'></option>
                        </select>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group">
                        <select name="onay_tipi">
                            <option value="1" <cfif attributes.onay_tipi eq 1>selected</cfif>><cf_get_lang dictionary_id='61556.Onaylılar'></option>
                            <option value="0" <cfif attributes.onay_tipi eq 0>selected</cfif>><cf_get_lang dictionary_id='61557.Onaysızlar'></option>
                        </select>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfsavecontent variable="head"><cf_get_lang dictionary_id='61562.Satış Bitenler'></cfsavecontent>
    <cf_box title="#head#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="25"><input type="checkbox" name="full_action_code_list" id="full_action_code_list" checked="checked" onclick="wrk_select_all('full_action_code_list','action_code_list');"/></th>
                    <th><cf_get_lang dictionary_id='48886.İşlem Kodu'></th>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='61478.Tablo Kodu'></th>
                    <th><cf_get_lang dictionary_id='61480.Fiyat Tipi'></th>
                    <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='44019.Ürün'></th>
                    <th>A</th>
                    <th><cf_get_lang dictionary_id='61533.Alış Başlangıç'></th>
                    <th><cf_get_lang dictionary_id='61534.Alış Bitiş'></th>
                    <th><cf_get_lang dictionary_id='61535.Satış Başlangıç'></th>
                    <th><cf_get_lang dictionary_id='61536.Satış Bitiş'></th>
                    <th>S</th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                </tr> 
            </thead>
            <tbody>
                <cfif get_table_codes.recordcount>
                <cfquery name="get_all_alts" datasource="#dsn_dev#" result="alts_all">
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
                        PT.ACTION_CODE IN ('#replace(valuelist(get_table_codes.action_code),",","','","all")#') AND
                        (PT.IS_ACTIVE_S = #attributes.onay_tipi# AND DATEADD("d",-1,PT.FINISHDATE) = #attributes.finishdate#) AND
                        PT.PRODUCT_ID = P.PRODUCT_ID AND
                        PT.STARTDATE IS NOT NULL AND
                        PT.FINISHDATE IS NOT NULL
                        <cfif attributes.new_price_type eq 1>
                        AND PT.PRODUCT_ID NOT IN 
                            (
                                SELECT 
                                    PT2.PRODUCT_ID
                                FROM
                                    PRICE_TABLE PT2
                                WHERE
                                    PT2.STARTDATE <= #DATEADD('d',1,attributes.finishdate)# AND
                                    PT2.FINISHDATE > #DATEADD('d',1,attributes.finishdate)# AND
                                    PT2.ROW_ID <> PT.ROW_ID AND
                                    (PT2.IS_ACTIVE_S = #attributes.onay_tipi#) AND
                                    PT2.ROW_ID NOT IN (SELECT PTD.ROW_ID FROM PRICE_TABLE_DEPARTMENTS PTD)
                            )
                        </cfif>
                    ORDER BY
                        PT.FINISHDATE DESC,
                        PT.STARTDATE DESC,
                        PT.ROW_ID DESC
                </cfquery>
                <cfoutput query="get_table_codes">
                    <cfquery name="get_alts" dbtype="query">
                        SELECT * FROM get_all_alts WHERE ACTION_CODE = '#ACTION_CODE#' AND TABLE_CODE = '#TABLE_CODE#'
                    </cfquery>
                    <tr>
                        <td><input type="checkbox" name="action_code_list" id="action_code_list" value="#action_code#" checked="checked"/></td>
                        <td><a href="#request.self#?fuseaction=retail.speed_manage_product_new&action_code=#action_code#&table_code=#table_code#&is_form_submitted=1&search_selected_product_list=#valuelist(get_alts.product_id)#&calc_type=3" class="tableyazi">#action_code#</a></td>
                        <td>#currentrow#</td>
                        <td><a href="#request.self#?fuseaction=retail.speed_manage_product_new&action_code=#action_code#&table_code=#table_code#&is_form_submitted=1&search_selected_product_list=#valuelist(get_alts.product_id)#&calc_type=3" class="tableyazi">#TABLE_CODE#</a></td>
                        <td>#TYPE_NAME#</td>
                        <td>#table_info#</td>
                        <td style="text-align:right;"><a href="javascript://" onclick="$('##srow_#currentrow#').toggle();" class="tableyazi">#get_alts.RECORDCOUNT#</a></td>
                        <td><cfif is_active_s eq 1>1<cfelse>0</cfif></td>
                        <td>#dateformat(P_STARTDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(P_FINISHDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(STARTDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(FINISHDATE,'dd/mm/yyyy')#</td>
                        <td><cfif is_active_s eq 1>1<cfelse>0</cfif></td>
                        <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                    </tr>
                    <tr id="srow_#currentrow#" style="display:none;">
                        <td colspan="14" style="background-color:##F63">&nbsp;
                        <input type="hidden" name="action_code_product_list_#action_code#" value="#valuelist(get_alts.product_id)#"/>
                            <table width="100%">
                                <thead>
                                <tr class="formbold">
                                    <td><cf_get_lang dictionary_id='44019.Ürün'></td>
                                    <td>St. O.</td>
                                    <td><cf_get_lang dictionary_id='61535.Satış Başlangıç'></td>				
                                    <td><cf_get_lang dictionary_id='61536.Satış Bitiş'></td>
                                    <td><cf_get_lang dictionary_id='32763.Satış Fiyatı'></td>
                                    <td><cf_get_lang dictionary_id='44224.satış fiyatı (kdvli fiyat)'></td>				              
                                    <td>Al. O.</td>
                                    <td><cf_get_lang dictionary_id='61533.Alış Başlangıç'></td>
                                    <td><cf_get_lang dictionary_id='61534.Alış Bitiş'></td>
                                    <td><cf_get_lang dictionary_id='37632.Brüt Alış'></td>
                                    <td>% <cf_get_lang dictionary_id='58560.İndirim'></td>
                                    <td><cf_get_lang dictionary_id='61558.manuel indirim'></td>
                                    <td><cf_get_lang dictionary_id='32526.Alış Fiyatı'></td>
                                    <td><cf_get_lang dictionary_id='61559.Alış fiyatı (KDVli)'></td>
                                    <td><cf_get_lang dictionary_id='40627.Satış Karı'></td>
                                    <td><cf_get_lang dictionary_id='61560.Alış Karı'></td>
                                    <td><cf_get_lang dictionary_id='57640.Vade'></td>
                                    <td><cf_get_lang dictionary_id='30631.Tarih'></td>
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
                                        <td style="background-color:##DEB887; color:white;"><cfif get_alts.IS_ACTIVE_S eq 0 and get_alts.IS_ACTIVE_P eq 0><cf_get_lang dictionary_id='57545.Teklif'><cfelseif IS_ACTIVE_S eq 1>1</cfif></td>
                                        <td style="background-color:##DEB887; color:white;">#dateformat(get_alts.startdate,'dd/mm/yyyy')#</td>                
                                        <td style="background-color:##DEB887; color:white;">#dateformat(get_alts.finishdate,'dd/mm/yyyy')#</td>                
                                        <td style="background-color:##DEB887; color:white;">#TLFormat(get_alts.NEW_PRICE_2,session.ep.our_company_info.sales_price_round_num)#</td>
                                        <td style="background-color:##DEB887; color:white;">#TLFormat(get_alts.NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#</td>
                                        <td><cfif get_alts.IS_ACTIVE_S eq 0 and get_alts.IS_ACTIVE_P eq 0><cf_get_lang dictionary_id='57545.Teklif'><cfelseif get_alts.IS_ACTIVE_P eq 1>1</cfif></td>
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
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="14"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
    <cfsavecontent variable="head_"><cf_get_lang dictionary_id='61561.Alış Bitenler'></cfsavecontent>
    <cf_box title="#head_#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="25"><input type="checkbox" name="full_p_action_code_list" id="full_p_action_code_list" checked="checked" onclick="wrk_select_all('full_p_action_code_list','p_action_code_list');"/></th>
                    <th><cf_get_lang dictionary_id='48886.İşlem Kodu'></th>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='61478.Tablo Kodu'></th>
                    <th><cf_get_lang dictionary_id='61480.Fiyat Tipi'></th>
                    <th><cf_get_lang dictionary_id='36199.Açıklama'></th>
                    <th><cf_get_lang dictionary_id='44019.Ürün'></th>
                    <th>A</th>
                    <th><cf_get_lang dictionary_id='61533.Alış Başlangıç'></th>
                    <th><cf_get_lang dictionary_id='61534.Alış Bitiş'></th>
                    <th><cf_get_lang dictionary_id='61535.Satış Başlangıç'></th>
                    <th><cf_get_lang dictionary_id='61536.Satış Bitiş'></th>
                    <th>S</th>
                    <th><cf_get_lang dictionary_id='57483.Kayıt'></th>
                </tr> 
            </thead>
            <tbody>
                <cfif get_table_codes_alis.recordcount>
                <cfquery name="get_all_alts_alis" datasource="#dsn_dev#" result="alts_all_alis">
                    SELECT
                        PT.*,
                        ISNULL(PT.IS_ACTIVE_P,0) AS IS_ACTIVE_P_,
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
                        PT.ACTION_CODE IN ('#replace(valuelist(get_table_codes.action_code),",","','","all")#') AND
                        (PT.IS_ACTIVE_P = #attributes.onay_tipi# AND DATEADD("d",-1,PT.P_FINISHDATE) = #attributes.finishdate#) AND
                        PT.PRODUCT_ID = P.PRODUCT_ID AND
                        PT.STARTDATE IS NOT NULL AND
                        PT.FINISHDATE IS NOT NULL 
                        <cfif attributes.new_price_type eq 1>
                        AND
                        PT.PRODUCT_ID NOT IN 
                            (
                                SELECT 
                                    PT2.PRODUCT_ID
                                FROM
                                    PRICE_TABLE PT2
                                WHERE
                                    PT2.P_STARTDATE <= #DATEADD('d',1,attributes.finishdate)# AND
                                    PT2.P_FINISHDATE > #DATEADD('d',1,attributes.finishdate)# AND
                                    PT2.ROW_ID <> PT.ROW_ID AND
                                    (PT2.IS_ACTIVE_P = #attributes.onay_tipi#) AND
                                    PT2.ROW_ID NOT IN (SELECT PTD.ROW_ID FROM PRICE_TABLE_DEPARTMENTS PTD)
                            )
                        </cfif>
                    ORDER BY
                        PT.P_FINISHDATE DESC,
                        PT.P_STARTDATE DESC,
                        PT.ROW_ID DESC
                </cfquery>
                <cfoutput query="get_table_codes_alis">
                    <cfquery name="get_alts" dbtype="query">
                        SELECT * FROM get_all_alts_alis WHERE ACTION_CODE = '#ACTION_CODE#' AND TABLE_CODE = '#TABLE_CODE#'
                    </cfquery>
                    <tr>
                        <td><input type="checkbox" name="p_action_code_list" id="p_action_code_list" value="#action_code#" checked="checked"/></td>
                        <td><a href="#request.self#?fuseaction=retail.speed_manage_product_new&action_code=#action_code#&table_code=#table_code#&is_form_submitted=1&search_selected_product_list=#valuelist(get_alts.product_id)#&calc_type=3" class="tableyazi">#action_code#</a></td>
                        <td>#currentrow#</td>
                        <td><a href="#request.self#?fuseaction=retail.speed_manage_product_new&action_code=#action_code#&table_code=#table_code#&is_form_submitted=1&search_selected_product_list=#valuelist(get_alts.product_id)#&calc_type=3" class="tableyazi">#TABLE_CODE#</a></td>
                        <td>#TYPE_NAME#</td>
                        <td>#table_info#</td>
                        <td style="text-align:right;"><a href="javascript://" onclick="$('##arow_#currentrow#').toggle();" class="tableyazi">#get_alts.RECORDCOUNT#</a></td>
                        <td><cfif is_active_s eq 1>1<cfelse>0</cfif></td>
                        <td>#dateformat(P_STARTDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(P_FINISHDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(STARTDATE,'dd/mm/yyyy')#</td>
                        <td>#dateformat(FINISHDATE,'dd/mm/yyyy')#</td>
                        <td><cfif is_active_s eq 1>1<cfelse>0</cfif></td>
                        <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                    </tr>
                    <tr id="arow_#currentrow#" style="display:none;">
                        <td colspan="14" style="background-color:##F63">&nbsp;
                            <input type="text" name="p_action_code_product_list_#action_code#" value="#valuelist(get_alts.product_id)#"/>
                            <table width="100%">
                                <thead>
                                <tr class="formbold">
                                    <td><cf_get_lang dictionary_id='44019.Ürün'></td>
                                    <td>St. O.</td>
                                    <td><cf_get_lang dictionary_id='61535.Satış Başlangıç'></td>				
                                    <td><cf_get_lang dictionary_id='61536.Satış Bitiş'></td>
                                    <td><cf_get_lang dictionary_id='32763.Satış Fiyatı'></td>
                                    <td><cf_get_lang dictionary_id='44224.satış fiyatı (kdvli fiyat)'></td>				              
                                    <td>Al. O.</td>
                                    <td><cf_get_lang dictionary_id='61533.Alış Başlangıç'></td>				
                                    <td><cf_get_lang dictionary_id='61534.Alış Bitiş'></td>
                                    <td><cf_get_lang dictionary_id='37632.Brüt Alış'></td>
                                    <td>% <cf_get_lang dictionary_id='58560.İndirim'></td>
                                    <td><cf_get_lang dictionary_id='61558.manuel indirim'></td>
                                    <td><cf_get_lang dictionary_id='32526.Alış Fiyatı'></td>
                                    <td><cf_get_lang dictionary_id='61559.Alış fiyatı (KDVli)'></td>
                                    <td><cf_get_lang dictionary_id='40627.Satış Karı'></td>
                                    <td><cf_get_lang dictionary_id='61560.Alış Karı'></td>
                                    <td><cf_get_lang dictionary_id='57640.Vade'></td>
                                    <td><cf_get_lang dictionary_id='30631.Tarih'></td>
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
                                        <td style="background-color:##DEB887; color:white;"><cfif get_alts.IS_ACTIVE_S eq 0 and get_alts.IS_ACTIVE_P eq 0><cf_get_lang dictionary_id='57545.Teklif'><cfelseif IS_ACTIVE_S eq 1>1</cfif></td>
                                        <td style="background-color:##DEB887; color:white;">#dateformat(get_alts.startdate,'dd/mm/yyyy')#</td>                
                                        <td style="background-color:##DEB887; color:white;">#dateformat(get_alts.finishdate,'dd/mm/yyyy')#</td>                
                                        <td style="background-color:##DEB887; color:white;">#TLFormat(get_alts.NEW_PRICE_2,session.ep.our_company_info.sales_price_round_num)#</td>
                                        <td style="background-color:##DEB887; color:white;">#TLFormat(get_alts.NEW_PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#</td>
                                        <td><cfif get_alts.IS_ACTIVE_S eq 0 and get_alts.IS_ACTIVE_P eq 0><cf_get_lang dictionary_id='57545.Teklif'><cfelseif get_alts.IS_ACTIVE_P eq 1>1</cfif></td>
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
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="14"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
    <cf_box>
        <cfform action="#request.self#?fuseaction=retail.speed_manage_product_new" method="post" name="form1" target="blank">
            <cfinput type="hidden" name="is_from_price_change" value="1">
            <cfinput type="hidden" name="calc_type" value="3">
            <cfinput type="hidden" name="action_code_type" value="0">
            <cfinput type="hidden" name="finishdate" value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
            <input type="submit" name="gonder" value="Satışı Bitenleri Bir Tabloda Topla" onclick="document.getElementById('action_code_type').value = '0';">
            <input type="submit" name="gonder2" value="Alışı Bitenleri Bir Tabloda Topla" onclick="document.getElementById('action_code_type').value = '1';">
            <input type="submit" name="gonder3" value="Tümünü Bir Tabloda Topla" onclick="document.getElementById('action_code_type').value = '2';">
        </cfform>
    </cf_box>
</div>
<!---
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
    <cfset url_string = ''>
    <cfif len(attributes.table_code)>
        <cfset url_string = '#url_string#&table_code=#attributes.table_code#'>
    </cfif>
    <cfif len(attributes.keyword)>
        <cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
    </cfif>
    <cfif len(attributes.startdate)>
        <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,"dd/mm/yyyy")#'>
    </cfif>
    <cfif len(attributes.finishdate)>
        <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,"dd/mm/yyyy")#'>
    </cfif>
    <cfif isdefined("attributes.form_submitted")>
        <cfset url_string = '#url_string#&form_submitted=#attributes.form_submitted#'>
    </cfif>	
    <cfif isdefined("attributes.record_emp_id")>
        <cfset url_string = '#url_string#&record_emp_id=#attributes.record_emp_id#'>
    </cfif>	
    <cfif isdefined("attributes.record_emp_name")>
        <cfset url_string = '#url_string#&record_emp_name=#attributes.record_emp_name#'>
    </cfif>
    <cfif isdefined("attributes.action_code")>
        <cfset url_string = '#url_string#&action_code=#attributes.action_code#'>
    </cfif>
    <table width="98%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
        <tr>
            <td>
                <cf_pages page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="retail.list_prices#url_string#">
            </td>
            <!-- sil -->
            <td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
            <!-- sil -->
        </tr>
    </table>
</cfif>
--->