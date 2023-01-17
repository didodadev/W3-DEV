<!--- Rendi mamül üretim takip raporu --->
<cfparam name="attributes.station_id" default="10"><!--- Her firmaya Göre Değişir --->
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.is_report_type" default="">
<cfparam name="attributes.is_puan" default="">
<cfparam name="attributes.is_demand_no" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.maxrows" default="200">
<cfset t_amount =0>
<cfset tk_amount =0>
<cfset s_t_amount =0>
<cfset z_t_amount =0>
<cfset son_row = 0>
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
</cfif>
<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		HIERARCHY
</cfquery>
<cfquery name="GET_W" datasource="#dsn#">
	SELECT 
    	* 
	FROM 
    	#dsn3_alias#.WORKSTATIONS 
	WHERE 
		ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
    	DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
	ORDER BY STATION_NAME ASC
</cfquery>
<cfif isdefined('attributes.is_form_submited')>
	<cfquery name="get_yari_mamul_production" datasource="#dsn3#">
		 SELECT
			PRODUCTION_ORDERS.P_ORDER_ID,
			PRODUCTION_ORDERS.START_DATE,
			PRODUCTION_ORDERS.FINISH_DATE,
			PRODUCTION_ORDERS.P_ORDER_NO,
			PRODUCTION_ORDERS.STOCK_ID,
			PRODUCTION_ORDERS.QUANTITY,
			PRODUCTION_ORDERS.STATION_ID,
			PRODUCTION_ORDERS.PROD_ORDER_STAGE,
            PRODUCTION_ORDERS.IS_STAGE,
            PRODUCTION_ORDERS.DEMAND_NO,
			STOCKS.PRODUCT_CATID,
			STOCKS.PRODUCT_NAME,
			STOCKS.PRODUCT_ID,
			STOCKS.PROPERTY,
            STOCKS.STOCK_CODE,
			STOCKS.SHORT_CODE_ID,
			STOCKS.PRODUCT_UNIT_ID,
			STOCKS.IS_PROTOTYPE,
			PRODUCTION_ORDERS.SPECT_VAR_NAME,
            PRODUCTION_ORDERS.SPECT_VAR_ID,
            ISNULL(
            (
            SELECT     
            	SUM(PORR.AMOUNT) AS AMOUNT
			FROM         
            	PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
               	PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
			WHERE     
            	PORR.TYPE = 1 AND POR.IS_STOCK_FIS = 1 AND POR.P_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
            )
            ,0) AS AMOUNT,
			(
            SELECT     
            	O.ORDER_NUMBER
			FROM         
            	PRODUCTION_ORDERS_ROW AS POR INNER JOIN
            	ORDERS AS O ON POR.ORDER_ID = O.ORDER_ID
			WHERE     
            	POR.TYPE = 1 AND POR.PRODUCTION_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
            )AS ORDER_NUMBER
		FROM
			PRODUCTION_ORDERS,
			STOCKS
		WHERE
			PRODUCTION_ORDERS.STOCK_ID = STOCKS.STOCK_ID
			
			<cfif len(attributes.is_demand_no)>
				AND PRODUCTION_ORDERS.P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.is_demand_no#%">
			</cfif>
			<cfif len(attributes.short_code_id)>
				AND STOCKS.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
			</cfif>
			<cfif len(attributes.cat)>
				 AND(
				 <cfloop from="1" to="#listlen(attributes.cat)#" index="c"> 
					(STOCKS.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListGetAt(attributes.cat,c,',')#.%">)
					 <cfif C neq listlen(attributes.cat)>OR</cfif>
				</cfloop>)
			</cfif>
			<cfif len(attributes.product_id) and len(attributes.product_name)>AND STOCKS.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"></cfif>
			<cfif len(attributes.station_id)>
				<cfif attributes.station_id eq 0>
					AND PRODUCTION_ORDERS.STATION_ID IS NULL
				<cfelse>
					AND PRODUCTION_ORDERS.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.station_id#">
				</cfif>
			</cfif>
			<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
				AND PRODUCTION_ORDERS.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
		    </cfif>
			<cfif isDefined("attributes.finish_date") and isdate(attributes.finish_date)>
				AND PRODUCTION_ORDERS.FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#date_add('d',1,attributes.finish_date)#">
		   </cfif>
           <cfif isdefined('attributes.is_report_type') and len(attributes.is_report_type)>
           		AND 
           		<cfif attributes.is_report_type eq 1>
                     ISNULL(
                        (
                        SELECT     
                            SUM(PORR.AMOUNT) AS AMOUNT
                        FROM         
                            PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
                            PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
                        WHERE     
                            PORR.TYPE = 1 AND POR.IS_STOCK_FIS = 1 AND POR.P_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
                        )
                        ,0) > 0
                <cfelse>
                	                     ISNULL(
                        (
                        SELECT     
                            SUM(PORR.AMOUNT) AS AMOUNT
                        FROM         
                            PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
                            PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
                        WHERE     
                            PORR.TYPE = 1 AND POR.IS_STOCK_FIS = 1 AND POR.P_ORDER_ID = PRODUCTION_ORDERS.P_ORDER_ID
                        )
                        ,0) = 0
                </cfif>
           </cfif>
		 ORDER BY 
		 	PRODUCTION_ORDERS.FINISH_DATE,
            STOCKS.PRODUCT_NAME
	</cfquery>
<cfelse>
	<cfset get_yari_mamul_production.recordcount = 0>
</cfif>
<cfif get_yari_mamul_production.recordcount>
	<cfquery name="stock_list" dbtype="query">
    	SELECT STOCK_ID FROM get_yari_mamul_production GROUP BY STOCK_ID
    </cfquery>
	<cfset stock_id_list = Valuelist(stock_list.STOCK_ID)>
    <cfquery name="product_list" dbtype="query">
    	SELECT PRODUCT_ID FROM get_yari_mamul_production GROUP BY PRODUCT_ID
    </cfquery>
	<cfset product_id_list = Valuelist(product_list.PRODUCT_ID)>
    <cfquery name="get_urun_puan" datasource="#dsn3#">
    	SELECT STOCK_ID,PROPERTY2 FROM PRODUCT_TREE_INFO_PLUS WHERE STOCK_ID IN (#stock_id_list#)
    </cfquery>
    <cfoutput query="get_urun_puan">
    	<cfif len(PROPERTY2)>
    		<cfset 'PROPERTY2_#STOCK_ID#' = PROPERTY2>
       	<cfelse>
        	<cfset 'PROPERTY2_#STOCK_ID#' = 0>
        </cfif>
    </cfoutput>
    <cfoutput query="get_yari_mamul_production">
    	<cfif isdefined('PROPERTY2_#STOCK_ID#')>
    		<cfset s_t_amount = s_t_amount + (Evaluate('PROPERTY2_#STOCK_ID#')*quantity)>
       	</cfif>
    </cfoutput>
    <cfquery name="get_takim_puan" datasource="#dsn3#">
    	SELECT PRODUCT_ID,PROPERTY1 from PRODUCT_INFO_PLUS WHERE PRO_INFO_ID = 2 AND PRODUCT_ID IN (#product_id_list#)
    </cfquery>
    <cfoutput query="get_takim_puan">
    	<cfif len(PROPERTY1)>
    		<cfset 'PROPERTY1_#PRODUCT_ID#' = PROPERTY1>
       	<cfelse>
        	<cfset 'PROPERTY1_#PRODUCT_ID#' = 0>
        </cfif>
    </cfoutput>
    <cfoutput query="get_yari_mamul_production">
    	<cfif isdefined('PROPERTY1_#PRODUCT_ID#')>
    		<cfset z_t_amount = z_t_amount + (Evaluate('PROPERTY1_#PRODUCT_ID#')*quantity)>
       	</cfif>
    </cfoutput>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_yari_mamul_production.recordcount#'>
<cfset attributes.startrow = (((attributes.page-1)*attributes.maxrows)) + 1>
<cfform name="uretim_plan" action="#request.self#?fuseaction=#url.fuseaction#" method="post">
<input name="is_form_submited" id="is_form_submited" type="hidden" value="1">
<cfinput name="master_plan_id" type="hidden" value="#attributes.master_plan_id#">
<input name="type" type="hidden" value="2">

	<cf_big_list_search title="<cf_get_lang_main no='3237.Üretimdeki İş Emirleri'>" collapsed="1">
        <cf_big_list_search_area>
            <table >
                <tr>
                    <td><cf_get_lang_main no='1677.Emir No'></td>
                    <td><input type="text" value="<cfoutput>#attributes.is_demand_no#</cfoutput>" name="is_demand_no" id="is_demand_no" style="width:150px;" /></td>
                    <td width="70"><cf_get_lang_main no='1854.Üretim Sonucu'></td>
                    <td width="170">
                        <select name="is_report_type" id="is_report_type" style=" width:150px;">
                            <option value=""><cf_get_lang_main no='296.Tümü'></option>
                            <option value="1"<cfif attributes.is_report_type eq 1>selected</cfif>><cfoutput>#getLang('prod',587)#</cfoutput></option>
                            <option value="2"<cfif attributes.is_report_type eq 2>selected</cfif>><cfoutput>#getLang('prod',586)#</cfoutput></option>
                        </select>
                    </td>
                    <td><cf_get_lang_main no='245.Ürün'></td>
                    <td>
                        <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                        <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                        <input type="text"   name="product_name"  id="product_name" style="width:150px;"  value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','225');" autocomplete="off">
                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_list.stock_id&product_id=search_list.product_id&field_name=search_list.product_name&keyword='+encodeURIComponent(document.search_list.product_name.value),'list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                    </td>
                    
                    <td><cf_get_lang_main no='330.Tarih'></td>
                    <td><cfinput type="text" name="start_date" maxlength="10" validate="eurodate" style="width:65px;" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#">
                        <cf_wrk_date_image date_field="start_date">
                        <cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#"  validate="eurodate" style="width:65px;">
                        <cf_wrk_date_image date_field="finish_date">
                    </td>
					<!-- sil -->
					<td><cf_wrk_search_button> <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
                    <!-- sil -->
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
	<cf_big_list id="list_product_big_list">
 		<thead>
            <tr>
                <th width="20"><cf_get_lang_main no='75.No'></th>
                <th><cf_get_lang_main no='1469.Plan Tarihi'></th>
                <th><cf_get_lang_main no='799.Sipariş No'></th>
                <th><cf_get_lang_main no='1677.Emir No'></th>
                <th><cf_get_lang_main no='106.Stok Kodu'></th>
                <th><cf_get_lang_main no='809.Ürün Adı'></th>
                <th><cfoutput>#getLang('objects',1535)#</cfoutput></th>
                <th><cf_get_lang_main no='3233.Ür. Puanı'></th>
                <th><cf_get_lang_main no='3234.Tk. Puanı'></th>
                <th width="50"><cf_get_lang_main no='1456.İş Emri'></th>
                <th width="50"><cfoutput>#getLang('prod',295)#</cfoutput></th>
                <th><cf_get_lang_main no='224.Birim'></th>
                <th><cf_get_lang_main no='3235.Ür.Topl.Puan'></th>
                <th><cf_get_lang_main no='3236.Tk.Topl.Puan'></th>
            </tr>
        </thead>
        <tbody>
        <cfif get_yari_mamul_production.recordcount>
            <cfset short_code_id_list = ''>
            <cfset product_cat_id_list = ''>
            <cfset product_unit_id_list = ''>
            <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                <cfset attributes.startrow=1>
                <cfset attributes.maxrows=get_yari_mamul_production.recordcount>
            </cfif>
            <cfoutput query="get_yari_mamul_production" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <cfif len(product_catid) and not listfind(product_cat_id_list,product_catid)>
                    <cfset product_cat_id_list=listappend(product_cat_id_list,product_catid)>
                </cfif>
                <cfif len(product_unit_id) and not listfind(product_unit_id_list,product_unit_id)>
                    <cfset product_unit_id_list=listappend(product_unit_id_list,product_unit_id)>
                </cfif>
            </cfoutput>
            <cfif len(product_cat_id_list)>
                <cfset product_cat_id_list=listsort(product_cat_id_list,"numeric","ASC",",")>
                <cfquery name="get_product_cat" datasource="#dsn1#">
                   SELECT
                        PRODUCT_CATID,
                        HIERARCHY,
                        PRODUCT_CAT
                    FROM
                        PRODUCT_CAT
                    WHERE
                        PRODUCT_CATID IN (#product_cat_id_list#)
                    ORDER BY 
                        PRODUCT_CATID
                </cfquery>
            </cfif>
            <cfif len(product_unit_id_list)>
                <cfset product_unit_id_list=listsort(product_unit_id_list,"numeric","ASC",",")>
                <cfquery name="get_product_unit" datasource="#dsn1#">
                   SELECT
                        PRODUCT_UNIT_ID,
                        ADD_UNIT
                    FROM
                        PRODUCT_UNIT
                    WHERE
                        PRODUCT_UNIT_ID IN (#product_unit_id_list#)
                    ORDER BY 
                        PRODUCT_UNIT_ID
                </cfquery>
            </cfif>
            <cfquery name="get_all_stocks" datasource="#dsn3#">
                SELECT 
                    S.PRODUCT_NAME,
                    S.PRODUCT_ID,
                    PC.PRODUCT_CAT,
                    S.STOCK_ID,
                    S.SHORT_CODE_ID,
                    S.STOCK_CODE
                FROM 
                    STOCKS S,
                    PRODUCT_CAT PC
                WHERE
                    S.PRODUCT_CATID = PC.PRODUCT_CATID
            </cfquery>
            <cfoutput query="get_yari_mamul_production" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr bordercolor="green">
                    <cfset plan_tarih_ = "#dateformat(FINISH_DATE,'dd/mm/yyyy')#">
                    <td>#currentrow#</td>
                    <td>#plan_tarih_#</td>
                    <td>#order_number#</td>
                    <td>#p_order_no#</td>
                    <td>#stock_code#</td>
                    <td>
                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>','large');" class="tableyazi">#product_name#</a> #property#
                    </td>
                    <td>
                        <cfif is_prototype eq 1>
                            #spect_var_name#
                        <cfelse>
                            #spect_var_id#
                        </cfif>

                    </td>
                    <td style="text-align:right;" format="numeric"><cfif isdefined('PROPERTY2_#STOCK_ID#')>#tlformat(Evaluate('PROPERTY2_#STOCK_ID#'),4)#<cfelse>0</cfif></td>
                    <td style="text-align:right;" format="numeric"><cfif isdefined('PROPERTY1_#PRODUCT_ID#')>#tlformat(Evaluate('PROPERTY1_#PRODUCT_ID#'),4)#<cfelse>0</cfif></td>
                    <td style="text-align:right;" format="numeric">#tlformat(quantity)#</td>
                    <td style="text-align:right;" format="numeric">#tlformat(amount)#</td>
                    <td><cfif len(product_unit_id)>#get_product_unit.add_unit[listfind(product_unit_id_list,product_unit_id,',')]#</cfif></td>
                    <td style="text-align:right;" format="numeric"><cfif isdefined('PROPERTY2_#STOCK_ID#')>#tlformat(Evaluate('PROPERTY2_#STOCK_ID#')*quantity,2)#<cfelse>0</cfif></td>
                    <td style="text-align:right;" format="numeric"><cfif isdefined('PROPERTY1_#PRODUCT_ID#')>#tlformat(Evaluate('PROPERTY1_#PRODUCT_ID#')*quantity,2)#<cfelse>0</cfif></td>
                </tr>
                <cfset son_row = currentrow>
                <cfif isdefined('PROPERTY2_#STOCK_ID#')>
                	<cfset t_amount = t_amount + (Evaluate('PROPERTY2_#STOCK_ID#')*quantity)>
                </cfif>
                <cfif isdefined('PROPERTY1_#PRODUCT_ID#')>
                	<cfset tk_amount = tk_amount + (Evaluate('PROPERTY1_#PRODUCT_ID#')*quantity)>
                </cfif>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="14"><cfif isdefined('attributes.is_form_submited')><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no ='289.Filtre Ediniz'> !</cfif></td>
            </tr>
        </cfif>
        </tbody>
        <tfoot>
           	<tr>
              	<cfif isdefined("attributes.is_form_submited") and attributes.totalrecords gt son_row>
					<cfoutput>
                 		<td style="text-align:right;" colspan="12"><cfoutput>#getLang('report',462)#</cfoutput></td>
                      	<td style="text-align:right;">#Tlformat(t_amount,2)#</td>
                        <td style="text-align:right;">#Tlformat(tk_amount,2)#</td>
                 	</cfoutput>
         		<cfelse>
                   	<cfoutput>
                   		<td style="text-align:right;" colspan="12"><cfoutput>#getLang('main',268)#</cfoutput></td>
                		<td style="text-align:right;">#Tlformat(s_t_amount,2)#</td>
                        <td style="text-align:right;">#Tlformat(z_t_amount,2)#</td>
              		</cfoutput>
             	</cfif>     
            </tr>
		</tfoot>
 	</cf_big_list>
</cfform>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "#attributes.fuseaction#">
	<cfif isdefined("attributes.is_form_submited") and len(attributes.is_form_submited)>
		<cfset url_str = "#url_str#&is_form_submited=#attributes.is_form_submited#">
	</cfif>
	<cfif isdefined("attributes.is_report_type") and len(attributes.is_report_type)>
		<cfset url_str = "#url_str#&is_report_type=#attributes.is_report_type#">
	</cfif>
	<cfif isDefined('attributes.is_demand_no') and len(attributes.is_demand_no)>
		<cfset url_str = '#url_str#&is_demand_no=#attributes.is_demand_no#'>
	</cfif>
	<cfif isDefined('attributes.cat') and len(attributes.cat)>
		<cfset url_str = '#url_str#&cat=#attributes.cat#'>
	</cfif>
	<cfif isDefined('attributes.product_id') and len(attributes.product_id)>
		<cfset url_str = '#url_str#&product_id=#attributes.product_id#'>
	</cfif>
	<cfif isDefined('attributes.product_name') and len(attributes.product_name)>
		<cfset url_str = '#url_str#&product_name=#attributes.product_name#'>
	</cfif>
	<cfif isDefined('attributes.station_id') and len(attributes.station_id)>
		<cfset url_str = '#url_str#&station_id=#attributes.station_id#'>
	</cfif>
	<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
		<cfset url_str = '#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#'>
	</cfif>
	<cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
		<cfset url_str = '#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#'>
	</cfif>
	<cfif isDefined('attributes.short_code_id') and len(attributes.short_code_id)>
		<cfset url_str = '#url_str#&short_code_id=#attributes.short_code_id#'>
	</cfif>
	<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
        <tr> 
            <td>
            <cf_pages page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_str#"> 
            </td>
            <!-- sil --><td style="text-align:right;"><cf_get_lang_main no='128.Toplam Kayıt'>:<cfoutput>#attributes.totalrecords#-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
	</table>
</cfif>