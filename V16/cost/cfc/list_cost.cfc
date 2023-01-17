<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn2= "#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cffunction name="GET_EXPENSE_ITEM" access="public" returntype="query">
        <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
            SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
        </cfquery>
        <cfreturn get_expense_item>
    </cffunction>
    <cffunction name="GET_EXPENSE_CENTER" access="public" returntype="query">
        <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
            SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
        </cfquery>
        <cfreturn get_expense_center>
    </cffunction>
    <cffunction name="GET_ACTIVITY_TYPES" access="public" returntype="query">
        <cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
            SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
        </cfquery>
        <cfreturn get_activity_types>
    </cffunction>
	<cffunction name="GET_EXPENSE_ITEM_ROW_ALL1" access="public" returntype="query">
        <cfargument name="keyword" type="string" default="">
        <cfargument name="search_date1" type="date" default="#dateformat(dateadd("d", -1, now()),dateformat_style)#">
        <cfargument name="search_date2" type="date" default="#dateformat(now(),dateformat_style)#">
        <cfargument name="member_type" type="any" default="">
        <cfargument name="expense_part_id" type="any" default="">
        <cfargument name="expense_cons_id" type="any" default="">
        <cfargument name="expense_emp_id" type="any" default="">
        <cfargument name="recorder_name" type="string" default="">
        <cfargument name="expense_item_id" type="any" default=""> 
        <cfargument name="expense_center_id" type="any" default="">
        <cfargument name="activity_type" type="any" default="">
        <cfargument name="asset_id" type="any" default="">
        <cfargument name="asset" type="string" default="">
        <cfargument name="project_id" type="any" default="">
        <cfargument name="project" type="string" default="">

        <cfquery name="GET_EXPENSE_ITEM_ROW_ALL1" datasource="#dsn2#">
            SELECT			
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                SUM(EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT) AS TOPLAM,
                EXPENSE_ITEMS.EXPENSE_ITEM_ID	
            FROM 
                EXPENSE_ITEMS_ROWS, 
                EXPENSE_ITEMS,
                EXPENSE_CENTER
            WHERE 
                EXPENSE_ITEMS_ROWS.IS_INCOME = 0 AND
                EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID AND
                EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID
                <cfif len(arguments.keyword)>AND EXPENSE_ITEMS_ROWS.PAPER_TYPE LIKE '%#arguments.keyword#%'</cfif>
                <cfif len(arguments.search_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #arguments.search_date1#</cfif>
                <cfif len(arguments.search_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < #dateadd("d",1,arguments.search_date2)#</cfif>
                <cfif len(arguments.expense_item_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID = #arguments.expense_item_id#</cfif>
                <cfif len(arguments.expense_center_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID = #arguments.expense_center_id#</cfif>
                <cfif len(arguments.activity_type)>AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #arguments.activity_type#</cfif>
                <cfif len(arguments.asset) and len(arguments.asset_id)>AND EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = #arguments.asset_id#</cfif>
                <cfif len(arguments.project) and len(arguments.project_id)>AND EXPENSE_ITEMS_ROWS.PROJECT_ID = #arguments.project_id#</cfif>
                <cfif arguments.member_type is 'partner' and len(arguments.expense_part_id) and len(arguments.recorder_name)>
                    AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'partner'
                    AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_part_id#
                <cfelseif arguments.member_type is 'consumer' and len(arguments.expense_cons_id) and len(arguments.recorder_name)>
                    AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'consumer'
                    AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_cons_id#
                <cfelseif arguments.member_type is 'employee' and len(arguments.expense_emp_id) and len(arguments.recorder_name)>
                    AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'employee'
                    AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_emp_id#
                </cfif>
            GROUP BY
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
                EXPENSE_ITEMS.EXPENSE_ITEM_ID
            ORDER BY
                EXPENSE_ITEMS.EXPENSE_ITEM_NAME
        </cfquery>
        <cfreturn get_expense_item_row_all1>
    </cffunction>
    <cffunction name="GET_EXPENSE_ITEM_ROW_ALL2" access="public" returntype="query">
        <cfargument name="keyword" type="string" default="">
        <cfargument name="search_date1" type="date" default="#dateformat(dateadd("d", -1, now()),dateformat_style)#">
        <cfargument name="search_date2" type="date" default="#dateformat(now(),dateformat_style)#">
        <cfargument name="member_type" type="any" default="">
        <cfargument name="expense_part_id" type="any" default="">
        <cfargument name="expense_cons_id" type="any" default="">
        <cfargument name="expense_emp_id" type="any" default="">
        <cfargument name="recorder_name" type="string" default="">
        <cfargument name="expense_item_id" type="any" default=""> 
        <cfargument name="expense_center_id" type="any" default="">
        <cfargument name="activity_type" type="any" default="">
        <cfargument name="asset_id" type="any" default="">
        <cfargument name="asset" type="string" default="">
        <cfargument name="project_id" type="any" default="">
        <cfargument name="project" type="string" default="">
        <cfquery name="GET_EXPENSE_ITEM_ROW_ALL2" datasource="#dsn2#">
                SELECT 		
                    EXPENSE_CENTER.EXPENSE,
                    SUM(EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT) AS TOPLAM,
                    EXPENSE_CENTER.EXPENSE_ID
                FROM 
                    EXPENSE_ITEMS_ROWS, 
                    EXPENSE_CENTER,
                    EXPENSE_ITEMS
                WHERE 
                    EXPENSE_ITEMS_ROWS.IS_INCOME = 0 AND
                    EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID AND
                    EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID
                    <cfif len(arguments.keyword)>AND EXPENSE_ITEMS_ROWS.PAPER_TYPE LIKE '%#arguments.keyword#%'</cfif>
                    <cfif len(arguments.search_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #arguments.search_date1#</cfif>
                    <cfif len(arguments.search_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < #dateadd("d",1,arguments.search_date2)#</cfif>			
                    <cfif len(arguments.expense_item_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID = #arguments.expense_item_id#</cfif>
                    <cfif len(arguments.expense_center_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID = #arguments.expense_center_id#</cfif>
                    <cfif len(arguments.activity_type)>AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #arguments.activity_type#</cfif>
                    <cfif len(arguments.asset) and len(arguments.asset_id)>AND EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = #arguments.asset_id#</cfif>
                    <cfif len(arguments.project) and len(arguments.project_id)>AND EXPENSE_ITEMS_ROWS.PROJECT_ID = #arguments.project_id#</cfif>
                    <cfif arguments.member_type is 'partner' and len(arguments.expense_part_id) and len(arguments.recorder_name)>
                        AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'partner'
                        AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_part_id#
                    <cfelseif arguments.member_type is 'consumer' and len(arguments.expense_cons_id) and len(arguments.recorder_name)>
                        AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'consumer'
                        AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_cons_id#
                    <cfelseif arguments.member_type is 'employee' and len(arguments.expense_emp_id) and len(arguments.recorder_name)>
                        AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'employee'
                        AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_emp_id#
                    </cfif>
                GROUP BY
                    EXPENSE_CENTER.EXPENSE,
                    EXPENSE_CENTER.EXPENSE_ID
                ORDER BY
                    EXPENSE_CENTER.EXPENSE
        </cfquery>
        <cfreturn get_expense_item_row_all2>
    </cffunction>
    <cffunction name="GET_EXPENSE_ITEM_ROW_ALL3" access="public" returntype="query">
        <cfargument name="keyword" type="string" default="">
        <cfargument name="search_date1" type="date" default="#dateformat(dateadd("d", -1, now()),dateformat_style)#">
        <cfargument name="search_date2" type="date" default="#dateformat(now(),dateformat_style)#">
        <cfargument name="member_type" type="string" default="">
        <cfargument name="expense_part_id" type="any" default="">
        <cfargument name="expense_cons_id" type="any" default="">
        <cfargument name="expense_emp_id" type="any" default="">
        <cfargument name="recorder_name" type="string" default="">
        <cfargument name="expense_item_id" type="any" default=""> 
        <cfargument name="expense_center_id" type="any" default="">
        <cfargument name="activity_type" type="any" default="">
        <cfargument name="asset_id" type="any" default="">
        <cfargument name="asset" type="string" default="">
        <cfargument name="project_id" type="any" default="">
        <cfargument name="project" type="string" default="">
        <cfquery name="GET_EXPENSE_ITEM_ROW_ALL3" datasource="#dsn2#">
                SELECT 			
                    EXPENSE_CATEGORY.EXPENSE_CAT_NAME,
                    SUM(EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT) AS TOPLAM,
                    EXPENSE_CATEGORY.EXPENSE_CAT_ID
                FROM 
                    EXPENSE_ITEMS_ROWS, 
                    EXPENSE_CENTER,
                    EXPENSE_ITEMS,
                    EXPENSE_CATEGORY
                WHERE 
                    EXPENSE_ITEMS_ROWS.IS_INCOME = 0 AND
                    EXPENSE_CATEGORY.EXPENSE_CAT_ID = EXPENSE_ITEMS.EXPENSE_CATEGORY_ID AND
                    EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID AND
                    EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID
                    <cfif len(arguments.keyword)>AND EXPENSE_ITEMS_ROWS.PAPER_TYPE LIKE '%#arguments.keyword#%'</cfif>
                    <cfif len(arguments.search_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #arguments.search_date1#</cfif>
                    <cfif len(arguments.search_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < #dateadd("d",1,arguments.search_date2)#</cfif>
                    <cfif len(arguments.expense_item_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID = #arguments.expense_item_id#</cfif>
                    <cfif len(arguments.expense_center_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID = #arguments.expense_center_id#</cfif>
                    <cfif len(arguments.activity_type)>AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #arguments.activity_type#</cfif>
                    <cfif len(arguments.asset) and len(arguments.asset_id)>AND EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = #arguments.asset_id#</cfif>
                    <cfif len(arguments.project) and len(arguments.project_id)>AND EXPENSE_ITEMS_ROWS.PROJECT_ID = #arguments.project_id#</cfif>
                    <cfif arguments.member_type is 'partner' and len(arguments.expense_part_id) and len(arguments.recorder_name)>
                        AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'partner'
                        AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_part_id#
                    <cfelseif arguments.member_type is 'consumer' and len(arguments.expense_cons_id) and len(arguments.recorder_name)>
                        AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'consumer'
                        AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_cons_id#
                    <cfelseif arguments.member_type is 'employee' and len(arguments.expense_emp_id) and len(arguments.recorder_name)>
                        AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'employee'
                        AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_emp_id#
                    </cfif>
                GROUP BY
                    EXPENSE_CATEGORY.EXPENSE_CAT_NAME,
                    EXPENSE_CATEGORY.EXPENSE_CAT_ID
                ORDER BY
                    EXPENSE_CATEGORY.EXPENSE_CAT_NAME
        </cfquery>
        <cfreturn get_expense_item_row_all3>
    </cffunction>
     <cffunction name="GET_EXPENSE_ITEM_ROW_ALL4" access="public" returntype="query">
        <cfargument name="keyword" type="string" default="">
        <cfargument name="search_date1" type="date" default="#dateformat(dateadd("d", -1, now()),dateformat_style)#">
        <cfargument name="search_date2" type="date" default="#dateformat(now(),dateformat_style)#">
        <cfargument name="member_type" type="any" default="">
        <cfargument name="expense_part_id" type="any" default="">
        <cfargument name="expense_cons_id" type="any" default="">
        <cfargument name="expense_emp_id" type="any" default="">
        <cfargument name="recorder_name" type="string" default="">
        <cfargument name="expense_item_id" type="any" default=""> 
        <cfargument name="expense_center_id" type="any" default="">
        <cfargument name="activity_type" type="any" default="">
        <cfargument name="asset_id" type="any" default="">
        <cfargument name="asset" type="string" default="">
        <cfargument name="project_id" type="any" default="">
        <cfargument name="project" type="string" default="">
        <cfquery name="GET_EXPENSE_ITEM_ROW_ALL4" datasource="#dsn2#">
                SELECT 		
                    EXPENSE_CENTER.ACTIVITY_ID,
                    SUM(EXPENSE_ITEMS_ROWS.TOTAL_AMOUNT) AS TOPLAM,
                    SETUP_ACTIVITY.ACTIVITY_NAME
                FROM 
                    EXPENSE_ITEMS_ROWS, 
                    EXPENSE_CENTER,
                    EXPENSE_ITEMS,
                    #dsn#.SETUP_ACTIVITY
                WHERE 
                    EXPENSE_ITEMS_ROWS.IS_INCOME = 0 AND
                    EXPENSE_CENTER.EXPENSE_ID = EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID AND
                    EXPENSE_ITEMS.EXPENSE_ITEM_ID = EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID AND 
                    EXPENSE_CENTER.ACTIVITY_ID=EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE AND
                    SETUP_ACTIVITY.ACTIVITY_ID=EXPENSE_CENTER.ACTIVITY_ID
                    <cfif len(arguments.keyword)>AND EXPENSE_ITEMS_ROWS.PAPER_TYPE LIKE '%#arguments.keyword#%'</cfif>
                    <cfif len(arguments.search_date1)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE >= #arguments.search_date1#</cfif>
                    <cfif len(arguments.search_date2)>AND EXPENSE_ITEMS_ROWS.EXPENSE_DATE < #dateadd("d",1,arguments.search_date2)#</cfif>			
                    <cfif len(arguments.expense_item_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_ITEM_ID = #arguments.expense_item_id#</cfif>
                    <cfif len(arguments.expense_center_id)>AND EXPENSE_ITEMS_ROWS.EXPENSE_CENTER_ID = #arguments.expense_center_id#</cfif>
                    <cfif len(arguments.activity_type)>AND EXPENSE_ITEMS_ROWS.ACTIVITY_TYPE = #arguments.activity_type#</cfif>
                    <cfif len(arguments.asset) and len(arguments.asset_id)>AND EXPENSE_ITEMS_ROWS.PYSCHICAL_ASSET_ID = #arguments.asset_id#</cfif>
                    <cfif len(arguments.project) and len(arguments.project_id)>AND EXPENSE_ITEMS_ROWS.PROJECT_ID = #arguments.project_id#</cfif>
                    <cfif arguments.member_type is 'partner' and len(arguments.expense_part_id) and len(arguments.recorder_name)>
                        AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'partner'
                        AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_part_id#
                    <cfelseif arguments.member_type is 'consumer' and len(arguments.expense_cons_id) and len(arguments.recorder_name)>
                        AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'consumer'
                        AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_cons_id#
                    <cfelseif arguments.member_type is 'employee' and len(arguments.expense_emp_id) and len(arguments.recorder_name)>
                        AND EXPENSE_ITEMS_ROWS.MEMBER_TYPE = 'employee'
                        AND EXPENSE_ITEMS_ROWS.COMPANY_PARTNER_ID = #arguments.expense_emp_id#
                    </cfif>
                GROUP BY
                     EXPENSE_CENTER.ACTIVITY_ID,
                     SETUP_ACTIVITY.ACTIVITY_NAME
                ORDER BY
                    EXPENSE_CENTER.ACTIVITY_ID
        </cfquery>
        <cfreturn get_expense_item_row_all4>
    </cffunction>
</cfcomponent>