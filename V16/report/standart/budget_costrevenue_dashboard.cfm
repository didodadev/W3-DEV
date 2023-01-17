
<!---
    File: V16/report/standart/budget_costrevenue_dashboard.cfm
    Author: Workcube-Melek KOCABEY <melekkocabey@workcube.com>
    Date: 15.06.2020
    Controller: WBO/PurchaseDashboardController.cfm
    Description: -
--->
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfif month(now()) neq 1>
    <cfset month = month(now()) -1>
<cfelse>
    <cfset month = month(now())>
</cfif>
<cf_xml_page_edit fuseact="report.budget_costrevenue_dashboard">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.expense_cat" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.budget_name" default="">
<cfparam name="attributes.search_date1" default="1/#month#/#session.ep.period_year#">
<cfparam name="attributes.search_date2" default="#bu_ay_sonu#/#month(now())#/#session.ep.period_year#">
<cfparam name="attributes.general_budget_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.activity_id" default="">
<cfparam name="attributes.control_type" default="16">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.is_excel" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif len(attributes.search_date1)><cf_date tarih='attributes.search_date1'></cfif>
<cfif len(attributes.search_date2)><cf_date tarih='attributes.search_date2'></cfif>
<cfquery name="get_hierarcy" datasource="#dsn2#">
    SELECT 
        D.HIERARCHY_DEP_ID ,
        D.BRANCH_ID,
        EP.EMPLOYEE_ID
    FROM 
        #dsn_alias#.DEPARTMENT D,
        #dsn_alias#.EMPLOYEE_POSITIONS EP 
    WHERE 
        EP.DEPARTMENT_ID = D.DEPARTMENT_ID
        AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfif get_hierarcy.recordcount and listlen(get_hierarcy.HIERARCHY_DEP_ID,'.') gt 1>
    <cfset hierarcy_id_list = valuelist(get_hierarcy.HIERARCHY_DEP_ID,',')>
    <cfset up_dep=ListGetAt(hierarcy_id_list,evaluate("#listlen(hierarcy_id_list,".")#-1"),".") >	
</cfif>
<cfquery name="GET_EXPENSE_BUDGET" datasource="#dsn2#">
    WITH CTE1 AS
    (
        SELECT      
            GEC.EXPENSE_ITEM_ID,
            GEC.EXPENSE_ITEM_NAME,
        <cfif attributes.control_type eq 20>
            GEC.EXPENSE_CAT_NAME,
        <cfelseif attributes.control_type eq 22>
            GEC.ACTIVITY_NAME,
            GEC.ACTIVITY_ID,
        </cfif>
        <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
            GEC.EXPENSE_ID,
            GEC.EXPENSE,
        </cfif>
        ISNULL(ROW_TOTAL_INCOME,0) ROW_TOTAL_INCOME,
        ISNULL(ROW_TOTAL_INCOME_2,0) ROW_TOTAL_INCOME_2,
        ISNULL(ROW_TOTAL_EXPENSE,0) ROW_TOTAL_EXPENSE,
        ISNULL(ROW_TOTAL_EXPENSE_2,0) ROW_TOTAL_EXPENSE_2,
        ISNULL(TOTAL_AMOUNT_BORC,0) AS TOTAL_AMOUNT_BORC,
        ISNULL(TOTAL_AMOUNT_2_BORC,0) AS TOTAL_AMOUNT_BORC_2,
        ISNULL(REZ_TOTAL_AMOUNT_BORC,0) AS REZ_TOTAL_AMOUNT_BORC,
        ISNULL(REZ_TOTAL_AMOUNT_2_BORC,0) AS REZ_TOTAL_AMOUNT_2_BORC,
        ISNULL(REZ_TOTAL_AMOUNT_ALACAK,0) AS REZ_TOTAL_AMOUNT_ALACAK,
        ISNULL(REZ_TOTAL_AMOUNT_2_ALACAK,0) AS REZ_TOTAL_AMOUNT_2_ALACAK,
        ISNULL(TOTAL_AMOUNT_ALACAK,0)  AS TOTAL_AMOUNT_ALACAK,
        ISNULL(TOTAL_AMOUNT_2_ALACAK,0) AS TOTAL_AMOUNT_ALACAK_2
    FROM
        (
            SELECT        
                EI.EXPENSE_ITEM_ID,
                EI.EXPENSE_ITEM_NAME
                <cfif attributes.control_type eq 20>
                    ,EC.EXPENSE_CAT_NAME
                <cfelseif attributes.control_type eq 22>
                    ,STAC.ACTIVITY_NAME
                    ,STAC.ACTIVITY_ID
                </cfif>
                <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    ,ECEN.EXPENSE_ID
                    ,ECEN.EXPENSE
                </cfif>
            FROM                
                EXPENSE_ITEMS AS EI
                <cfif attributes.control_type eq 20>
                    ,EXPENSE_CATEGORY AS EC
                <cfelseif attributes.control_type eq 22>
                    ,#dsn#.SETUP_ACTIVITY AS STAC
                </cfif>
                <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    ,EXPENSE_CENTER AS ECEN   
                </cfif>         
            WHERE 1=1
                <cfif attributes.control_type eq 20>
                    AND EI.EXPENSE_CATEGORY_ID = EC.EXPENSE_CAT_ID
                </cfif>
                <cfif len(attributes.expense_item_id)>
                    AND EI.EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#">
                </cfif>
                <cfif len(attributes.expense_cat)>
                    AND EC.EXPENSE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_cat#">
                </cfif>
                <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    AND ECEN.EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#">
                </cfif>
                <cfif isdefined("x_authorized_branch") and x_authorized_branch eq 1 and len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    AND (EXPENSE_BRANCH_ID IN (SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR (EXPENSE_BRANCH_ID = -1))
                    <cfif get_hierarcy.recordcount and listlen(get_hierarcy.HIERARCHY_DEP_ID,'.') gt 1>
                        AND (EXPENSE_DEPARTMENT_ID IN 
                            (	
                                SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                                UNION ALL 
                                    SELECT 
                                        DEPARTMENT_ID 
                                    FROM
                                        #dsn_alias#.DEPARTMENT
                                    WHERE 
                                        DEPARTMENT_ID = #up_dep#
                            ) 
                            OR ( EXPENSE_DEPARTMENT_ID = -1)
                            )
                    </cfif>
                </cfif>	
            GROUP BY            
                EI.EXPENSE_ITEM_ID,
                EI.EXPENSE_ITEM_NAME
                <cfif attributes.control_type eq 20>
                    ,EC.EXPENSE_CAT_NAME
                <cfelseif attributes.control_type eq 22>
                    ,STAC.ACTIVITY_NAME
                    ,STAC.ACTIVITY_ID
                </cfif>
                <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    ,ECEN.EXPENSE_ID
                    ,ECEN.EXPENSE
                </cfif>
        ) AS GEC 
    JOIN 
        (
            SELECT 
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE),0) ROW_TOTAL_EXPENSE,
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_EXPENSE_2),0) ROW_TOTAL_EXPENSE_2,
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME),0) ROW_TOTAL_INCOME,
                ISNULL(SUM(BUDGET_PLAN_ROW.ROW_TOTAL_INCOME_2),0) ROW_TOTAL_INCOME_2,
                BUDGET_PLAN_ROW.BUDGET_ITEM_ID
                <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    ,BUDGET_PLAN_ROW.EXP_INC_CENTER_ID
                </cfif>                
                <cfif attributes.control_type eq 22>
                    ,BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID
                </cfif>
            FROM
                #DSN_ALIAS#.BUDGET_PLAN,
                #DSN_ALIAS#.BUDGET_PLAN_ROW 
            WHERE 
                BUDGET_PLAN.PROCESS_TYPE <> 161 AND 
                BUDGET_PLAN.BUDGET_PLAN_ID = BUDGET_PLAN_ROW.BUDGET_PLAN_ID 
                <cfif len(attributes.search_date1)>
                    AND BUDGET_PLAN_ROW.PLAN_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
                </cfif>
                <cfif len(attributes.search_date2)>
                    AND BUDGET_PLAN_ROW.PLAN_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.search_date2)#">
                </cfif>
            GROUP BY
                BUDGET_PLAN_ROW.BUDGET_ITEM_ID
                <cfif attributes.control_type eq 22>
                    ,BUDGET_PLAN_ROW.ACTIVITY_TYPE_ID
                </cfif>
                <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    ,BUDGET_PLAN_ROW.EXP_INC_CENTER_ID
                </cfif>  
        ) AS PLANLANAN
    ON PLANLANAN.BUDGET_ITEM_ID = GEC.EXPENSE_ITEM_ID <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>AND PLANLANAN.EXP_INC_CENTER_ID = GEC.EXPENSE_ID</cfif><cfif attributes.control_type eq 22> AND PLANLANAN.ACTIVITY_TYPE_ID = GEC.ACTIVITY_ID</cfif>
    LEFT JOIN
        (
            SELECT
                SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS TOTAL_AMOUNT_BORC,
                SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) AS TOTAL_AMOUNT_2_BORC,
                SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS  TOTAL_AMOUNT_ALACAK,
                SUM( CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) TOTAL_AMOUNT_2_ALACAK,
                EXPENSE_ITEM_ID
                <cfif attributes.control_type eq 22>
                    ,ACTIVITY_TYPE
                </cfif>       
                <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    ,EXPENSE_CENTER_ID
                </cfif>          
            FROM
            (
                SELECT 
                    EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT TOTAL_AMOUNT,
                    EXPENSE_ITEMS_ROWS.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
                    EXPENSE_ITEMS_ROWS.IS_INCOME,
                    EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID,
                    EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE
                    <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    ,EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
                    </cfif> 
                FROM
                    EXPENSE_ITEMS_ROWS
                WHERE
                    TOTAL_AMOUNT > 0
                    <cfif len(attributes.search_date1)>
                        AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.search_date1#">
                    </cfif>
                    <cfif len(attributes.search_date2)>
                        AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.search_date2)#">
                    </cfif>		
            )T1
            GROUP BY
                EXPENSE_ITEM_ID
                <cfif attributes.control_type eq 22>
                    ,ACTIVITY_TYPE
                </cfif>
                <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    ,EXPENSE_CENTER_ID
                </cfif>  
        ) AS GERCEKLESEN  
    ON GEC.EXPENSE_ITEM_ID = GERCEKLESEN.EXPENSE_ITEM_ID <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>AND GERCEKLESEN.EXPENSE_CENTER_ID = GEC.EXPENSE_ID</cfif><cfif attributes.control_type eq 22> AND GERCEKLESEN.ACTIVITY_TYPE = GEC.ACTIVITY_ID</cfif>
    LEFT JOIN
        (
            SELECT
                SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT ELSE 0 END) AS REZ_TOTAL_AMOUNT_BORC,
                SUM(CASE WHEN IS_INCOME = 0 THEN TOTAL_AMOUNT_2 ELSE 0 END) AS REZ_TOTAL_AMOUNT_2_BORC,
                SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT ELSE 0 END) AS REZ_TOTAL_AMOUNT_ALACAK,
                SUM(CASE WHEN IS_INCOME = 1 THEN TOTAL_AMOUNT_2 ELSE 0 END) REZ_TOTAL_AMOUNT_2_ALACAK,
                EXPENSE_ITEM_ID
                <cfif attributes.control_type eq 22>
                    ,ACTIVITY_TYPE
                </cfif>
                <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    ,EXPENSE_CENTER_ID
                </cfif> 
            FROM
            (
                SELECT 
                    ERR.TOTAL_AMOUNT TOTAL_AMOUNT,
                    ERR.OTHER_MONEY_VALUE_2 TOTAL_AMOUNT_2,
                    ERR.IS_INCOME,
                    ERR.EXPENSE_ITEM_ID,
                    ERR.ACTIVITY_TYPE
                    <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                        ,ERR.EXPENSE_CENTER_ID
                    </cfif>
                FROM
                    EXPENSE_RESERVED_ROWS AS ERR
                WHERE
                    TOTAL_AMOUNT > 0					
            )T1
            GROUP BY
                EXPENSE_ITEM_ID
                <cfif attributes.control_type eq 22>
                    ,ACTIVITY_TYPE
                </cfif>
                <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>
                    ,EXPENSE_CENTER_ID
                </cfif> 
        ) AS RESERVED  
    ON GEC.EXPENSE_ITEM_ID = RESERVED.EXPENSE_ITEM_ID <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>AND RESERVED.EXPENSE_CENTER_ID = GEC.EXPENSE_ID </cfif><cfif attributes.control_type eq 22> AND RESERVED.ACTIVITY_TYPE = GEC.ACTIVITY_ID</cfif>
     ),
         CTE2 AS (
				SELECT
					*
				FROM
					CTE1
			)
			SELECT
                ( SELECT SUM(ROW_TOTAL_INCOME) FROM CTE2 ) ALL_ROW_TOTAL_INCOME,
                ( SELECT SUM(ROW_TOTAL_EXPENSE) FROM CTE2 ) ALL_ROW_TOTAL_EXPENSE,
                ( SELECT SUM(ROW_TOTAL_INCOME_2) FROM CTE2 ) ALL_ROW_TOTAL_INCOME_2,
                ( SELECT SUM(ROW_TOTAL_EXPENSE_2) FROM CTE2 ) ALL_ROW_TOTAL_EXPENSE_2,
                ( SELECT SUM(TOTAL_AMOUNT_BORC) FROM CTE2 ) ALL_TOTAL_AMOUNT_BORC,
                ( SELECT SUM(TOTAL_AMOUNT_ALACAK) FROM CTE2 ) ALL_TOTAL_AMOUNT_ALACAK,
                ( SELECT SUM(TOTAL_AMOUNT_BORC_2) FROM CTE2 ) ALL_TOTAL_AMOUNT_BORC_2,
                ( SELECT SUM(TOTAL_AMOUNT_ALACAK_2) FROM CTE2 ) ALL_TOTAL_AMOUNT_ALACAK_2,
                ( SELECT SUM(REZ_TOTAL_AMOUNT_ALACAK) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_ALACAK,
                ( SELECT SUM(REZ_TOTAL_AMOUNT_2_ALACAK) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_2_ALACAK,
                ( SELECT SUM(REZ_TOTAL_AMOUNT_BORC) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_BORC,
                ( SELECT SUM(REZ_TOTAL_AMOUNT_2_BORC) FROM CTE2 ) ALL_REZ_TOTAL_AMOUNT_2_BORC,
				CTE2.*
			FROM
				CTE2                		
</cfquery>
<cfif GET_EXPENSE_BUDGET.recordcount>
	<cfparam name="attributes.totalrecords" default='#GET_EXPENSE_BUDGET.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<div id="div_rows" class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='57524.Bütçeler'>
    </cfsavecontent>
    <cf_box title="#message#">
        <cfform name="frm_search" action="#request.self#?fuseaction=report.budget_costrevenue_dashboard" method="post">
            <input type="hidden" name="is_submitted" id="is_submitted" value="1">
            <div class="ui-form-list flex-list" id="aa">
                <cfif not (isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and len(attributes.expense_center_name))>
                    <cfset attributes.expense_center_id=''>
                </cfif>							
                <div class="form-group">
                    <cf_wrkExpenseCenter fieldId="expense_center_id" x_authorized_branch_department="#x_authorized_branch#" fieldName="expense_center_name" form_name="frm_search" expense_center_id="#attributes.expense_center_id#" expense_center_name="#attributes.expense_center_name#" img_info="plus_thin">
                </div>
                <div class="form-group large">
                    <select name="control_type" id="control_type" onChange="change_month();change_exp();">
                        <option value=""><cf_get_lang dictionary_id='36651.Kontrol Tipi'></option>
                        <option value="16" <cfif attributes.control_type eq 16>selected</cfif>><cf_get_lang dictionary_id='49105.Bütçe Kalemi Bazında'></option>
                        <option value="20" <cfif attributes.control_type eq 20>selected</cfif>><cf_get_lang dictionary_id='36184.Bütçe Kategorisi Bazında'></option>
                        <option value="22" <cfif attributes.control_type eq 22>selected</cfif>><cf_get_lang dictionary_id='49104.Aktivite Tipi Bazında'></option>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <cfinput type="text" name="search_date1" value="#dateformat(attributes.search_date1,dateformat_style)#" maxlength="25" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="search_date1"></span>
                        <span class="input-group-addon no-bg"></span>
                        <cfinput type="text" name="search_date2" value="#dateformat(attributes.search_date2,dateformat_style)#" maxlength="25" validate="#validate_style#">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="search_date2"></span>
                    </div>								
                </div> 
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" onKeyUp="isNumber(this)" maxlength="3" style="width:25px;">
                </div>               
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </div>
        </cfform>
    </cf_box>
    <cfset adres = "report.budget_costrevenue_dashboard">
	<cfif isDefined('attributes.is_submitted') and len(attributes.is_submitted)>
		<cfset adres = '#adres#&is_submitted=1'>
	</cfif>
	<cfif isDefined('attributes.expense_center_id') and len(attributes.expense_center_id)>
		<cfset adres = '#adres#&expense_center_id=#attributes.expense_center_id#'>
	</cfif>
	<cfif isDefined('attributes.expense_center_name') and len(attributes.expense_center_name)>
		<cfset adres = '#adres#&expense_center_name=#attributes.expense_center_name#'>
	</cfif>
	<cfif isDefined('attributes.expense_item_id') and len(attributes.expense_item_id)>
		<cfset adres = '#adres#&expense_item_id=#attributes.expense_item_id#'>
    </cfif>
    <cfif isDefined('attributes.control_type') and len(attributes.control_type)>
		<cfset adres = '#adres#&control_type=#attributes.control_type#'>
    </cfif>
    <cfif isdate(attributes.search_date1)>
		<cfset adres = '#adres#&search_date1=#dateformat(attributes.search_date1,dateformat_style)#'>
	</cfif>
	<cfif isdate(attributes.search_date2)>
		<cfset adres = '#adres#&search_date2=#dateformat(attributes.search_date2,dateformat_style)#'>
	</cfif>
    <cf_box title="#getLang("","",56966)#">
        <cfoutput>
        <div class="col col-6 col-md-6">
            <cfset expense_total = (len(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC) and GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC neq 0 and GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE neq 0) ? (GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE)*100:0>
            <div class="col col-12 col-xs-12">
				<script src="JS/Chart.min.js"></script> 
                <canvas id="myChart7"></canvas>
				<script>
					var ctx = document.getElementById('myChart7');
					var myChart7 = new Chart(ctx, {
						type: 'doughnut',
						data: {
								labels: ["Gider %",""],
								datasets: [{
								label: "Gider",
								backgroundColor: ["red","##93a6a28c"],
								data: [<cfoutput>"#wrk_round(expense_total,2)#","#wrk_round(100-expense_total,2)#"</cfoutput>],
									}]
								},
                                options: {
                                    title:
                                    {
                                    display: true,
                                    position: "top",
                                    text: "% #getLang("","",58678)#",
                                    fontSize: 18,
                                },
                                responsive: true,
                                legend: {
                                display: false
                                }
                            }
                    });
                    Chart.pluginService.register({
                    beforeDraw: function(chart) {
                        var width = chart.chart.width+10,
                            height = chart.chart.height+40,
                            ctx = chart.chart.ctx;

                        ctx.restore();
                        var fontSize = (height / 114).toFixed(2);
                        ctx.font = fontSize + "em sans-serif";
                        ctx.textBaseline = "middle";
                        var text = "%#wrk_round(expense_total,2)#",
                            textX = Math.round((width - ctx.measureText(text).width) / 2),
                            textY = height / 2;

                        ctx.fillText(text, textX, textY);
                        ctx.save();
                    }
                    });
				</script>
			</div>  
        </div>
        <div class="col col-6 col-md-6">           
            <cfset income_total = (len(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK) and GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK neq 0) ? (GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME)*100 :0>
            <div class="col col-12 col-xs-12">
				<script src="JS/Chart.min.js"></script> 
                <canvas id="myChart88"></canvas>
				<script>
					var ctx = document.getElementById('myChart88');
					var myChart88 = new Chart(ctx, {
						type: 'doughnut',
						data: {
								labels: ["Gider %",""],
								datasets: [{
								label: "Gider",
								backgroundColor: ["red","##93a6a28c"],
								data: [<cfoutput>"#wrk_round(income_total,2)#","#wrk_round(100-income_total,2)#"</cfoutput>],
									}]
								},
                                options: {
                                    title:
                                    {
                                    display: true,
                                    position: "top",
                                    text: "% #getLang("","",58677)#",
                                    fontSize: 18,
                                },
                                responsive: true,
                                legend: {
                                display: false
                                }
                            }
                    });
                    Chart.pluginService.register({
                    beforeDraw: function(chart) {
                        var width = chart.chart.width+10,
                            height = chart.chart.height+40,
                            ctx = chart.chart.ctx;

                        ctx.restore();
                        var fontSize = (height / 114).toFixed(2);
                        ctx.font = fontSize + "em sans-serif";
                        ctx.textBaseline = "middle";
                        var text = "%#wrk_round(income_total,2)#",
                            textX = Math.round((width - ctx.measureText(text).width) / 2),
                            textY = height / 2;

                        ctx.fillText(text, textX, textY);
                        ctx.save();
                    }
                    });
				</script>
			</div>
        </div>
        </cfoutput> 
    </cf_box>
    <cf_box  title="#getLang("","",58089)#" uidrop="1" resize="1" collapsable="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <cfif attributes.control_type eq 16><th rowspan="2"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th></cfif>
                    <cfif attributes.control_type eq 20><th rowspan="2"><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></th></cfif>
                    <cfif attributes.control_type eq 22><th rowspan="2"><cf_get_lang dictionary_id='38378.Aktivite Tipi'></th></cfif>
                    <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)><th rowspan="2"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th></cfif>
                    <th colspan="2" class="text-center"><cf_get_lang dictionary_id='58869.Planlanan'></th>
                    <th colspan="2" class="text-center"><cf_get_lang dictionary_id='31491.Gerçekleşen'></th>
                    <th colspan="2" class="text-center"><cf_get_lang dictionary_id='58583.Fark'></th>
                    <th colspan="2">%</th> 
                </tr>
                <tr>
                    <cfloop from="1" to="4" index="i">
                        <th class="text-right"><cfoutput>#session.ep.money#</cfoutput></th>
                        <th class="text-right"><cfoutput>#session.ep.money2#</cfoutput></th>
                    </cfloop>
                </tr>
                <cfif GET_EXPENSE_BUDGET.recordcount gt 0>
                    <tbody>
                        <cfoutput query="GET_EXPENSE_BUDGET" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif (GET_EXPENSE_BUDGET.ROW_TOTAL_INCOME neq 0) or (GET_EXPENSE_BUDGET.TOTAL_AMOUNT_ALACAK neq 0)>
                                <tr>
                                    <cfif attributes.control_type eq 16><td>#EXPENSE_ITEM_NAME#</td></cfif>
                                    <cfif attributes.control_type eq 20><td>#EXPENSE_CAT_NAME#</td></cfif>
                                    <cfif attributes.control_type eq 22><td>#ACTIVITY_NAME#</td></cfif>
                                    <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)><td>#EXPENSE#</td></cfif>
                                    <td class="text-right">#TLFormat(ROW_TOTAL_INCOME)#</td>
                                    <td class="text-right">#TLFormat(ROW_TOTAL_INCOME_2)#</td>
                                    <td class="text-right">#TLFormat(TOTAL_AMOUNT_ALACAK)#</td>
                                    <td class="text-right">#TLFormat(TOTAL_AMOUNT_ALACAK_2)#</td>
                                    <td class="text-right">#TLFormat(ROW_TOTAL_INCOME-TOTAL_AMOUNT_ALACAK)#</td>
                                    <td class="text-right">#TLFormat(ROW_TOTAL_INCOME_2-TOTAL_AMOUNT_ALACAK_2)#</td>
                                    <td class="text-right"><cfif ROW_TOTAL_INCOME neq 0>#TLFormat((TOTAL_AMOUNT_ALACAK/ROW_TOTAL_INCOME)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                                    <td class="text-right"><cfif ROW_TOTAL_INCOME_2 neq 0>#TLFormat((TOTAL_AMOUNT_ALACAK_2/ROW_TOTAL_INCOME_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                                </tr>
                            </cfif>
                        </cfoutput>
                    </tbody>
                    <cfoutput>
                        <tr>
                            <cfif attributes.maxrows*attributes.page gte attributes.totalrecords>
                                <td <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>colspan="2"<cfelse>colspan="1"</cfif>><cf_get_lang_main no='268.Genel Toplam'></td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME_2)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK_2)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME_2-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK_2)#</td>
                                <td class="text-right"><cfif GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME neq 0>#TLFormat((GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                                <td class="text-right"><cfif GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME_2 neq 0>#TLFormat((GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_ALACAK_2/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_INCOME_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                                
                            </cfif>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tbody>
                        <tr>
                            <td colspan="40"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                        </tr>
                    </tbody>
                </cfif>
            </thead>
        </cf_grid_list>
        <cfif isdefined("attributes.totalrecords") and attributes.totalrecords gt attributes.maxrows>
            <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#adres#"
            >
        </cfif>
    </cf_box>
    <cf_box title="#getLang("","",58677)#">
        <div class="col col-12 col-xs-12">              
            <script src="JS/Chart.min.js"></script> 
            <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>
            <canvas id="myChart" width="400" height="400"></canvas>
            <script>
                var ctx = document.getElementById("myChart");
                var myChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: [<cfoutput query="GET_EXPENSE_BUDGET">
                                <cfif attributes.control_type eq 16>"#EXPENSE_ITEM_NAME#"<cfelseif attributes.control_type eq 20>"#EXPENSE_CAT_NAME#"<cfelseif attributes.control_type eq 22>"#ACTIVITY_NAME#"</cfif>,</cfoutput>],
                        datasets: [{
                            label: "<cfif attributes.control_type eq 16><cf_get_lang dictionary_id='49105.Bütçe Kalemi'><cfelseif attributes.control_type eq 20><cf_get_lang dictionary_id='36184.Bütçe Kategorisi'><cfelseif attributes.control_type eq 22><cf_get_lang dictionary_id='49104.Aktivite Tipi'></cfif><cf_get_lang dictionary_id='58869.Planlanan'>%",
                        data: [<cfoutput query="GET_EXPENSE_BUDGET"><cfif ALL_ROW_TOTAL_INCOME neq 0>"#wrk_round(ROW_TOTAL_INCOME*100/ALL_ROW_TOTAL_INCOME)#"<cfelse>"#wrk_round(0)#"</cfif>,</cfoutput>],
                        backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(255, 99, 132, 0.2)'
                        ],
                        borderColor: [
                        'rgba(255,99,132,1)',
                        'rgba(255,99,132,1)',
                        'rgba(255,99,132,1)',
                        'rgba(255,99,132,1)',
                        'rgba(255,99,132,1)',
                        'rgba(255,99,132,1)'
                        ],
                        borderWidth: 2
                    },
                    {
                        label: "<cfif attributes.control_type eq 16><cf_get_lang dictionary_id='49105.Bütçe Kalemi'><cfelseif attributes.control_type eq 20><cf_get_lang dictionary_id='36184.Bütçe Kategorisi'><cfelseif attributes.control_type eq 22><cf_get_lang dictionary_id='49104.Aktivite Tipi'></cfif> <cf_get_lang dictionary_id='31491.Gerçekleşen'>%",
                        data: [<cfoutput query="GET_EXPENSE_BUDGET"><cfif ALL_TOTAL_AMOUNT_ALACAK neq 0>"#wrk_round(TOTAL_AMOUNT_ALACAK*100/ALL_TOTAL_AMOUNT_ALACAK)#"<cfelse>"#wrk_round(0)#"</cfif>,</cfoutput>],
                        backgroundColor: [
                        'rgba(255, 159, 64, 0.2)',
                        'rgba(255, 159, 64, 0.2)',
                        'rgba(255, 159, 64, 0.2)',
                        'rgba(255, 159, 64, 0.2)',
                        'rgba(255, 159, 64, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                        ],
                        borderColor: [
                        'rgba(255, 159, 64, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(255, 159, 64, 1)'
                        ],
                        borderWidth: 2
                    }
                    ]
                },
                options:{
                    responsive: true,
                    legend: {
                        position: "top"
                    },
                    title: {
                        display: true
                    },
                    scales: {
                        xAxes: [{
                            barPercentage: 1,
                            categoryPercentage: 0.6
                            }],
                        yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                        }]
                    }
                }
                });
            </script> 
        </div>
    </cf_box>
    <cf_box  title="#getLang("","",49141)#" uidrop="1" resize="1" collapsable="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <cfif attributes.control_type eq 16><th rowspan="2"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th></cfif>
                    <cfif attributes.control_type eq 20><th rowspan="2"><cf_get_lang dictionary_id='32999.Bütçe Kategorisi'></th></cfif>
                    <cfif attributes.control_type eq 22><th rowspan="2"><cf_get_lang dictionary_id='38378.Aktivite Tipi'></th></cfif>
                    <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)><th rowspan="2"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th></cfif>
                    <th colspan="2" class="text-center"><cf_get_lang dictionary_id='58869.Planlanan'></th>
                    <th colspan="2" class="text-center"><cf_get_lang dictionary_id='58048.Rezerve Edilen'></th>
                    <th colspan="2" class="text-center"><cf_get_lang dictionary_id='29750.Rezerve'><cf_get_lang dictionary_id='59563.Kullanılan'></th>
                    <th colspan="2" class="text-center"><cf_get_lang dictionary_id='31491.Gerçekleşen'></th>
                    <th colspan="2" class="text-center"><cf_get_lang dictionary_id='60705.Serbest Bütçe'></th> 
                    <th colspan="2" class="text-center"><cf_get_lang dictionary_id='58583.Fark'></th>
                    <th colspan="2">%</th>
                </tr>
                <tr>
                    <cfloop from="1" to="7" index="i">
                        <th class="text-right"><cfoutput>#session.ep.money#</cfoutput></th>
                        <th class="text-right"><cfoutput>#session.ep.money2#</cfoutput></th>
                    </cfloop>
                </tr>
                <cfif GET_EXPENSE_BUDGET.recordcount gt 0>
                    <tbody>
                        <cfoutput query="GET_EXPENSE_BUDGET" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif (GET_EXPENSE_BUDGET.ROW_TOTAL_EXPENSE neq 0) or (GET_EXPENSE_BUDGET.TOTAL_AMOUNT_BORC neq 0)>
                                <tr>
                                    <cfif attributes.control_type eq 16><td>#EXPENSE_ITEM_NAME#</td></cfif>
                                    <cfif attributes.control_type eq 20><td>#EXPENSE_CAT_NAME#</td></cfif>
                                    <cfif attributes.control_type eq 22><td>#ACTIVITY_NAME#</td></cfif>
                                    <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)><td>#EXPENSE#</td></cfif>
                                    <td class="text-right">#TLFormat(ROW_TOTAL_EXPENSE)#</td>
                                    <td class="text-right">#TLFormat(ROW_TOTAL_EXPENSE_2)#</td>
                                    <td class="text-right">#TLFormat(REZ_TOTAL_AMOUNT_ALACAK)#</td>
                                    <td class="text-right">#TLFormat(REZ_TOTAL_AMOUNT_2_ALACAK)#</td>
                                    <td class="text-right">#TLFormat(REZ_TOTAL_AMOUNT_BORC)#</td>
                                    <td class="text-right">#TLFormat(REZ_TOTAL_AMOUNT_2_BORC)#</td>
                                    <td class="text-right">#TLFormat(TOTAL_AMOUNT_BORC)#</td>
                                    <td class="text-right">#TLFormat(TOTAL_AMOUNT_BORC_2)#</td>
                                    <td class="text-right">#TLFormat(ROW_TOTAL_EXPENSE - TOTAL_AMOUNT_BORC - (REZ_TOTAL_AMOUNT_ALACAK - REZ_TOTAL_AMOUNT_BORC))#</td>
                                    <td class="text-right">#TLFormat(ROW_TOTAL_EXPENSE_2 - TOTAL_AMOUNT_BORC_2 - (REZ_TOTAL_AMOUNT_2_BORC - REZ_TOTAL_AMOUNT_2_ALACAK))#</td>     
                                    <td class="text-right">#TLFormat(ROW_TOTAL_EXPENSE-TOTAL_AMOUNT_BORC)#</td>
                                    <td class="text-right">#TLFormat(ROW_TOTAL_EXPENSE_2-TOTAL_AMOUNT_BORC_2)#</td>
                                    <td class="text-right"><cfif ROW_TOTAL_EXPENSE neq 0>#TLFormat((TOTAL_AMOUNT_BORC/ROW_TOTAL_EXPENSE)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                                    <td class="text-right"><cfif ROW_TOTAL_EXPENSE_2 neq 0>#TLFormat((TOTAL_AMOUNT_BORC_2/ROW_TOTAL_EXPENSE_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                                </tr>
                            </cfif>
                        </cfoutput>
                    <cfoutput>
                        <tr>
                            <cfif attributes.maxrows*attributes.page gte attributes.totalrecords>
                                <td <cfif len(attributes.expense_center_id) and len(attributes.expense_center_name)>colspan="2"<cfelse>colspan="1"</cfif>><cf_get_lang_main no='268.Genel Toplam'></td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE_2)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_ALACAK)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_2_ALACAK)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_BORC)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_2_BORC)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC_2)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE - GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC - (GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_ALACAK - GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_BORC))#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE_2 - GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC_2 - (GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_2_BORC - GET_EXPENSE_BUDGET.ALL_REZ_TOTAL_AMOUNT_2_ALACAK))#</td>      
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC)#</td>
                                <td class="text-right">#TLFormat(GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE_2-GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC_2)#</td>
                                <td class="text-right"><cfif GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE neq 0>#TLFormat((GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE)*100)#<cfelse>#TLFormat(0)#</cfif></td>
                                <td class="text-right"><cfif GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE_2 neq 0>#TLFormat((GET_EXPENSE_BUDGET.ALL_TOTAL_AMOUNT_BORC_2/GET_EXPENSE_BUDGET.ALL_ROW_TOTAL_EXPENSE_2)*100)#<cfelse>#TLFormat(0)#</cfif></td>              
                            </cfif>
                        </tr>
                    </cfoutput>
                    </tbody>
                <cfelse>
                    <tbody>
                        <tr>
                            <td colspan="40"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                        </tr>
                    </tbody>
                </cfif>
            </thead>
        </cf_grid_list>
        <cfif isdefined("attributes.totalrecords") and attributes.totalrecords gt attributes.maxrows>
            <cf_paging
            page_type="4"
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#adres#">
        </cfif>
    </cf_box>
    <cf_box title="#getLang("","",58678)#">
        <div class="col col-12 col-xs-12">              
            <script src="JS/Chart.min.js"></script> 
            <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.6.0/Chart.min.js"></script>
            <canvas id="myChart1" width="400" height="400"></canvas>
            <script>
                var ctx = document.getElementById("myChart1");
                var myChart1 = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: [<cfoutput query="GET_EXPENSE_BUDGET">
                                <cfif attributes.control_type eq 16>"#EXPENSE_ITEM_NAME#"<cfelseif attributes.control_type eq 20>"#EXPENSE_CAT_NAME#"<cfelseif attributes.control_type eq 22>"#ACTIVITY_NAME#"</cfif>,</cfoutput>],
                        datasets: [{
                            label: "<cfif attributes.control_type eq 16><cf_get_lang dictionary_id='49105.Bütçe Kalemi'><cfelseif attributes.control_type eq 20><cf_get_lang dictionary_id='36184.Bütçe Kategorisi'><cfelseif attributes.control_type eq 22><cf_get_lang dictionary_id='49104.Aktivite Tipi'></cfif><cf_get_lang dictionary_id='58869.Planlanan'>%",
                        data: [<cfoutput query="GET_EXPENSE_BUDGET"><cfif ALL_ROW_TOTAL_EXPENSE neq 0>"#wrk_round(ROW_TOTAL_EXPENSE*100/ALL_ROW_TOTAL_EXPENSE)#"<cfelse>"#wrk_round(0)#"</cfif>,</cfoutput>],
                        backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(255, 99, 132, 0.2)'
                        ],
                        borderColor: [
                        'rgba(255,99,132,1)',
                        'rgba(255,99,132,1)',
                        'rgba(255,99,132,1)',
                        'rgba(255,99,132,1)',
                        'rgba(255,99,132,1)',
                        'rgba(255,99,132,1)'
                        ],
                        borderWidth: 2
                    },
                    {
                        label: "<cfif attributes.control_type eq 16><cf_get_lang dictionary_id='49105.Bütçe Kalemi'><cfelseif attributes.control_type eq 20><cf_get_lang dictionary_id='36184.Bütçe Kategorisi'><cfelseif attributes.control_type eq 22><cf_get_lang dictionary_id='49104.Aktivite Tipi'></cfif> <cf_get_lang dictionary_id='31491.Gerçekleşen'>%",
                        data: [<cfoutput query="GET_EXPENSE_BUDGET"><cfif ALL_TOTAL_AMOUNT_BORC neq 0>"#wrk_round(TOTAL_AMOUNT_BORC*100/ALL_TOTAL_AMOUNT_BORC)#"<cfelse>"#wrk_round(0)#"</cfif>,</cfoutput>],
                        backgroundColor: [
                        'rgba(255, 159, 64, 0.2)',
                        'rgba(255, 159, 64, 0.2)',
                        'rgba(255, 159, 64, 0.2)',
                        'rgba(255, 159, 64, 0.2)',
                        'rgba(255, 159, 64, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                        ],
                        borderColor: [
                        'rgba(255, 159, 64, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(255, 159, 64, 1)'
                        ],
                        borderWidth: 2
                    }
                    ]
                },
                options:{
                    responsive: true,
                    legend: {
                        position: "top"
                    },
                    title: {
                        display: true
                    },
                    scales: {
                        xAxes: [{
                            barPercentage: 1,
                            categoryPercentage: 0.6
                            }],
                        yAxes: [{
                        ticks: {
                            beginAtZero: true
                        }
                        }]
                    }
                }
                });
            </script> 
        </div>
    </cf_box> 
</div>