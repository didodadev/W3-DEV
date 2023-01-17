<cf_get_lang_set module_name="objects">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.user_code" default="">
<cfparam name="attributes.list_type" default="2">
<cfparam name="attributes.re_count" default="2">

<cfquery name="get_stock_row_control" datasource="#dsn_Dev#">
	SELECT SMT.TABLE_CODE FROM STOCK_MANAGE_TABLES SMT WHERE SMT.ORDER_ID = #attributes.order_id#
</cfquery>

<cfquery name="get_stock_open_import_1" datasource="#DSN_DEV#" result="AAA">
   SELECT	
        (
            SELECT TOP 1
                GA4.ROW_ID
            FROM
                STOCK_COUNT_ORDERS_ROWS GA4
            WHERE
                GA.ORDER_ID = GA4.ORDER_ID AND
                GA.AMOUNT = GA4.AMOUNT AND
                GA.BARCODE = GA4.BARCODE
            ORDER BY
                GA4.ROW_ID ASC
        ) AS MINIMUM,
        GA.ROW_ID
    FROM
        STOCK_COUNT_ORDERS_ROWS GA,
        STOCK_COUNT_ORDERS_ROWS GA2
    WHERE
        GA.ORDER_ID = #attributes.order_id# AND
        GA.ROW_ID <> GA2.ROW_ID AND
        GA.AMOUNT = GA2.AMOUNT AND
        GA.BARCODE = GA2.BARCODE AND
        GA.ORDER_ID = GA2.ORDER_ID
    ORDER BY
        GA.ROW_ID ASC
</cfquery>
<cfif get_stock_open_import_1.recordcount>

<cfset minimum_id_list = VALUELIST(get_stock_open_import_1.MINIMUM)>
<cfset all_id_list = VALUELIST(get_stock_open_import_1.ROW_ID)>

	<cfquery name="get_stock_open_import_min" datasource="#dsn_dev#">
    	SELECT
            0 AS TYPE,
            (
                SELECT
                    COUNT(GA4.ROW_ID)
                FROM
                    STOCK_COUNT_ORDERS_ROWS GA4
                WHERE
                    SCOR.ORDER_ID = GA4.ORDER_ID AND
                    SCOR.AMOUNT = GA4.AMOUNT AND
                    SCOR.BARCODE = GA4.BARCODE
            ) AS SAYIM_SAYISI,
            (
                SELECT
                    COUNT(DISTINCT GA4.USER_CODE)
                FROM
                    STOCK_COUNT_ORDERS_ROWS GA4
                WHERE
                    SCOR.ORDER_ID = GA4.ORDER_ID AND
                    SCOR.AMOUNT = GA4.AMOUNT AND
                    SCOR.BARCODE = GA4.BARCODE
            ) AS KISI_SAYISI,
            SCOR.*,
            T1.PRODUCT_CAT,
            SCOR.STOCK_NAME AS PROPERTY
        FROM 
            STOCK_COUNT_ORDERS_ROWS SCOR
            	LEFT JOIN 
                	(
                    SELECT PC.PRODUCT_CAT,S.STOCK_ID FROM #dsn3_alias#.PRODUCT_CAT PC,#dsn3_alias#.STOCKS S WHERE S.PRODUCT_CATID = PC.PRODUCT_CATID
                    ) T1 ON SCOR.STOCK_ID = T1.STOCK_ID
        WHERE	
            <cfif len(attributes.keyword)>
            (
                SCOR.BARCODE = '#attributes.keyword#' OR
                SCOR.STOCK_NAME LIKE '%#attributes.keyword#%' OR
                SCOR.USER_CODE = '#attributes.keyword#'
            ) AND
            </cfif>
            <cfif len(attributes.user_code)>
               SCOR.USER_CODE = '#attributes.user_code#' AND
            </cfif>
            SCOR.ORDER_ID = #attributes.order_id# AND
            SCOR.ROW_ID IN (#minimum_id_list#)
    </cfquery>
    <cfquery name="get_stock_open_import_other" datasource="#dsn_dev#">
    	SELECT
            1 AS TYPE,
            (
                SELECT
                    COUNT(GA4.ROW_ID)
                FROM
                    STOCK_COUNT_ORDERS_ROWS GA4
                WHERE
                    SCOR.ORDER_ID = GA4.ORDER_ID AND
                    SCOR.AMOUNT = GA4.AMOUNT AND
                    SCOR.BARCODE = GA4.BARCODE
            ) AS SAYIM_SAYISI,
            (
                SELECT
                    COUNT(DISTINCT GA4.USER_CODE)
                FROM
                    STOCK_COUNT_ORDERS_ROWS GA4
                WHERE
                    SCOR.ORDER_ID = GA4.ORDER_ID AND
                    SCOR.AMOUNT = GA4.AMOUNT AND
                    SCOR.BARCODE = GA4.BARCODE
            ) AS KISI_SAYISI,
            SCOR.*,
            T1.PRODUCT_CAT,
            SCOR.STOCK_NAME AS PROPERTY
        FROM 
            STOCK_COUNT_ORDERS_ROWS SCOR
            	LEFT JOIN 
                	(
                    SELECT PC.PRODUCT_CAT,S.STOCK_ID FROM #dsn3_alias#.PRODUCT_CAT PC,#dsn3_alias#.STOCKS S WHERE S.PRODUCT_CATID = PC.PRODUCT_CATID
                    ) T1 ON SCOR.STOCK_ID = T1.STOCK_ID
        WHERE	
            <cfif len(attributes.keyword)>
            (
                SCOR.BARCODE = '#attributes.keyword#' OR
                SCOR.STOCK_NAME LIKE '%#attributes.keyword#%' OR
                SCOR.USER_CODE = '#attributes.keyword#'
            ) AND
            </cfif>
            <cfif len(attributes.user_code)>
               SCOR.USER_CODE = '#attributes.user_code#' AND
            </cfif>
            SCOR.ORDER_ID = #attributes.order_id# AND
            SCOR.ROW_ID IN (#all_id_list#) AND
            SCOR.ROW_ID NOT IN (#minimum_id_list#)
    </cfquery>
    
    <cfquery name="get_stock_open_import" dbtype="query">
    	SELECT * FROM get_stock_open_import_min 
        UNION
        SELECT * FROM get_stock_open_import_other
     ORDER BY
     	PRODUCT_CAT,
        PROPERTY,
        TYPE ASC
    </cfquery>
<cfelse>
	<cfset get_stock_open_import.recordcount = 0>
</cfif>

<cfquery name="get_user_codes" datasource="#dsn_dev#">
	SELECT DISTINCT USER_CODE FROM STOCK_COUNT_ORDERS_ROWS WHERE ORDER_ID = #attributes.order_id#
</cfquery>


<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_stock_open_import.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script>
    function get_product_stock_row(p_id)
    {
        rel_ = "rel='sub_rows'";
        col1 = $("#manage_table tr[" + rel_ + "]");
   
        col1.toggle();
    }
    </script>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_stock_count" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
            <input type="hidden" name="is_submitted" id="is_submitted" value="1">
            <cfinput type="hidden" name="order_id" value="#attributes.order_id#">
            <cf_box_search more="0">
                <div class="form-group">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
                </div>
                <div class="form-group">
                    <select name="user_code" id="user_code">
                    	<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_user_codes">
                        	<option value="#user_code#" <cfif user_code is attributes.user_code>selected</cfif>>#user_code#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group small">
                        <input type="text" name="maxrows" id="maxrows" value="<cfoutput>#attributes.maxrows#</cfoutput>" required="yes" validate="integer" range="1,999" message="<cf_get_lang dictionary_id='43958.Kayıt Sayısı Hatalı'>" maxlength="3" onKeyUp="isNumber (this)"  style="width:25px;">
                    </div>
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray2" href="javascript://" onclick="get_product_stock_row();"><i class="icn-md catalyst-grid" align="absmiddle"></i></a>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Sayım Emirleri Satır Karşılaştırma',62435)#" uidrop="1" hide_table_column="1">
        <cf_grid_list id="manage_table">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='61642.Alt Grup'></th>
                    <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                    <th><cf_get_lang dictionary_id='57633.Barkod'></th>
                    <th><cf_get_lang dictionary_id='57452.Stok'></th>
                    <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                    <th><cf_get_lang dictionary_id='33154.Tekrar'></th>
                    <th><cf_get_lang dictionary_id='29831.Kişi'></th>
                    <th><cf_get_lang dictionary_id='57930.Kullanıcı'></th>
                </tr>
            </thead>
            <tbody>
                <cfset last_group = "-1">
                <cfset count_ = 0>
                <cfif get_stock_open_import.recordcount>
                    <cfoutput query="get_stock_open_import">
                        <cfif last_group is not PRODUCT_CAT>
                            <cfset bg_color = "f5f5f5">
                        <cfelse>
                            <cfset bg_color = "">
                        </cfif>
                        <cfif type eq 0>
                            <cfset count_ = count_ + 1>
                        </cfif>
                        <tr <cfif type eq 1>rel="sub_rows"</cfif> <cfif type eq 1 and not fusebox.fuseaction contains 'autoexcel'>style="display:none;"</cfif>>
                            <td  width="35">#count_#</td>
                            <td ><cfif last_group is not PRODUCT_CAT>#PRODUCT_CAT#<cfset last_group = PRODUCT_CAT></cfif></td>
                            <td >
                                <cfset record_ = dateadd('h',session.ep.time_zone,record_date)>
                                #dateformat(record_,"dd/mm/yyyy")# (#timeformat(record_,'HH:MM')#)</td>
                            <td >#barcode#</td>
                            <td >#property#</td>
                            <td style="text-align:right;">#tlformat(amount,2)#</td>
                            <td style="text-align:right;"><a href="#request.self#?fuseaction=retail.list_stock_count_orders_rows&order_id=#attributes.order_id#&keyword=#barcode#" target="blank" class="tableyazi">#SAYIM_SAYISI#</a></td>
                            <td style="text-align:right;">#KISI_SAYISI#</td>
                            <td >#user_code#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="12"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>


<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">