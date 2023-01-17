<cf_get_lang_set module_name="objects">
	<cfif fusebox.circuit eq 'cost' and isdefined("attributes.event") and attributes.event eq 'list'>
	<cf_xml_page_edit fuseact="cost.list_my_expense_requests">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.search_date1" default=''>
<cfparam name="attributes.search_date2" default=''>
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.expense_employee" default="">
<cfparam name="attributes.form_exist" default="">
<cfparam name="attributes.document_type" default="">
<cfparam name="attributes.date_filter" default="1">
<cfparam name="attributes.stage_filter" default="">
<cfparam name="attributes.to_transforming" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.listing_type" default="1">
<cfparam name="attributes.expense_center_name" default="">
<cfparam name="attributes.expense_center_id" default="">
<cfparam name="attributes.expense_item_name" default="">
<cfparam name="attributes.expense_item_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfif isdefined("attributes.search_date1") and isdate(attributes.search_date1)>
	<cf_date tarih = "attributes.search_date1">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.search_date1=''>
	<cfelse>
		<cfset attributes.search_date1 = dateadd('d',-7,wrk_get_today())>	
	</cfif>
</cfif>
<cfif isdefined("attributes.search_date2") and isdate(attributes.search_date2)>
	<cf_date tarih = "attributes.search_date2">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.search_date2=''>
	<cfelse>
		<cfset attributes.search_date2 = dateadd('d',7,attributes.search_date1)>
	</cfif>
</cfif>
<cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
	SELECT EXPENSE_ID,EXPENSE_CODE,EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
	SELECT
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
		SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
	FROM
		SETUP_DOCUMENT_TYPE,
		SETUP_DOCUMENT_TYPE_ROW
	WHERE
		SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
		SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE '%#fuseaction#%'
	ORDER BY
		DOCUMENT_TYPE_NAME
</cfquery>
<cfquery name="get_service_stage" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_expense_requests%">
</cfquery>
<cfif  len(attributes.form_exist)>
	<!---<cfoutput ><pre>---><cfquery name="GET_EXPENSE" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
    WITH CTE1 AS(
		SELECT
			EXPENSE_ITEM_PLAN_REQUESTS.RECORD_EMP,
			EXPENSE_ITEM_PLAN_REQUESTS.PAPER_NO,
			EXPENSE_ITEM_PLAN_REQUESTS.RECORD_DATE,
			EXPENSE_ITEM_PLAN_REQUESTS.EMP_ID,
            EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_DATE,
            <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXP_ITEM_ROWS_ID,
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS.AMOUNT,
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS.DETAIL,
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS.TOTAL_AMOUNT,
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS.AMOUNT_KDV,
                E_C.EXPENSE,
                E_I.EXPENSE_ITEM_NAME,
           <cfelse>
                EXPENSE_ITEM_PLAN_REQUESTS.TOTAL_AMOUNT,
                EXPENSE_ITEM_PLAN_REQUESTS.NET_KDV_AMOUNT,
                EXPENSE_ITEM_PLAN_REQUESTS.NET_TOTAL_AMOUNT,
            </cfif> 
			EXPENSE_ITEM_PLAN_REQUESTS.INVOICE_NO,	
			EXPENSE_ITEM_PLAN_REQUESTS.PAPER_TYPE,
			EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID,
			EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_STAGE,
			EXPENSE_ITEM_PLAN_REQUESTS.SALES_COMPANY_ID,
			EXPENSE_ITEM_PLAN_REQUESTS.SALES_CONSUMER_ID,
            CONSUMER.CONSUMER_NAME,
            CONSUMER.CONSUMER_SURNAME,
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME,
            EMP.EMPLOYEE_NAME,
            EMP.EMPLOYEE_SURNAME,
            C.FULLNAME,
            PTR.STAGE
		FROM
			EXPENSE_ITEM_PLAN_REQUESTS
            	LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = EXPENSE_ITEM_PLAN_REQUESTS.SALES_CONSUMER_ID
                LEFT JOIN #dsn_alias#.SETUP_DOCUMENT_TYPE ON SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID = EXPENSE_ITEM_PLAN_REQUESTS.PAPER_TYPE
                LEFT JOIN #dsn_alias#.EMPLOYEES EMP on EMP.EMPLOYEE_ID =EXPENSE_ITEM_PLAN_REQUESTS.EMP_ID
                LEFT JOIN #dsn_alias#.COMPANY C on C.COMPANY_ID=EXPENSE_ITEM_PLAN_REQUESTS.SALES_COMPANY_ID
                LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR on PTR.PROCESS_ROW_ID=EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_STAGE
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                    LEFT JOIN EXPENSE_ITEM_PLAN_REQUESTS_ROWS on EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID = EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ID
                    LEFT JOIN EXPENSE_ITEMS E_I on E_I.EXPENSE_ITEM_ID=EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID
                    LEFT JOIN EXPENSE_CENTER E_C on E_C.EXPENSE_ID=EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID
            </cfif>
		WHERE
			<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                 EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID = EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ID AND 
            </cfif>  
                EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_STAGE IN (<cfif get_service_stage.recordcount>#valuelist(get_service_stage.process_row_id,',')#<cfelse>0</cfif>)
            <cfif len(attributes.to_transforming) and attributes.to_transforming eq 1>
                    AND EXPENSE_ITEM_PLAN_REQUESTS.IS_APPROVE = 1
                    AND EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID IN (SELECT REQUEST_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ITEM_PLANS.REQUEST_ID = EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID)
            <cfelseif  len(attributes.to_transforming) and attributes.to_transforming eq 0>
                    AND EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID NOT IN (SELECT REQUEST_ID FROM EXPENSE_ITEM_PLANS WHERE EXPENSE_ITEM_PLANS.REQUEST_ID = EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_ID)
            </cfif>
            <cfif len(attributes.keyword)>
                AND 
                (
                    EXPENSE_ITEM_PLAN_REQUESTS.PAPER_NO LIKE '%#attributes.keyword#%' 
                    OR 
                    EXPENSE_ITEM_PLAN_REQUESTS.SYSTEM_RELATION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
                )
            </cfif>
        	 <cfif xml_expense_center_is_popup eq 1>
            	<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_center_id') and len(attributes.expense_center_id) and len(attributes.expense_center_name))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"></cfif>
				<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_item_id') and len(attributes.expense_item_id) and len(attributes.expense_item_name))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"></cfif>
			<cfelse>
            	<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_center_id') and len(attributes.expense_center_id) )>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"></cfif>
				<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_item_id') and len(attributes.expense_item_id) )>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"></cfif>
            </cfif>
			<cfif len(attributes.search_date1)>AND EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_DATE >=<cfqueryparam  cfsqltype="cf_sql_date" value="#attributes.search_date1#"></cfif>
			<cfif len(attributes.search_date2)>AND EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_DATE <=<cfqueryparam cfsqltype="cf_sql_date" value="#attributes.search_date2#"></cfif>
			<cfif len(attributes.expense_employee) and len(attributes.employee_id)>AND EXPENSE_ITEM_PLAN_REQUESTS.EMP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"></cfif>
			<cfif len(attributes.document_type)>AND EXPENSE_ITEM_PLAN_REQUESTS.PAPER_TYPE =<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.document_type#"></cfif>
			<cfif len(attributes.stage_filter)>AND EXPENSE_ITEM_PLAN_REQUESTS.EXPENSE_STAGE =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stage_filter#"></cfif>
			<cfif len(attributes.record_emp_id) and len(attributes.record_emp_name)>AND EXPENSE_ITEM_PLAN_REQUESTS.RECORD_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#"></cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			</cfif>
		 ),
         CTE2 AS (
				SELECT
					CTE1.*,
						ROW_NUMBER() OVER (
                        					ORDER BY  
												<cfif len(attributes.date_filter) and attributes.date_filter eq 2>
                                                    EXPENSE_DATE
                                                <cfelseif len(attributes.date_filter) and attributes.date_filter eq 1>
                                                    EXPENSE_DATE DESC,EXPENSE_ID
                                                </cfif>
            ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
				FROM
					CTE1
			)
			SELECT
				CTE2.*
			FROM
				CTE2
			WHERE
				RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)               
	</cfquery><!---</pre></cfoutput><cfabort>--->
	<cfparam name="attributes.totalrecords" default="#get_expense.QUERY_COUNT#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<script type="text/javascript">
	$( document ).ready(function() {
		window.onload = show_filter;
		document.getElementById('keyword').focus();
	});
	function kontrol()
	{
		if (!date_check (document.getElementById('search_date1'),document.getElementById('search_date2'),"<cf_get_lang_main no='1450.Başlangıç Tarihi Bitiş Tarihinden Küçük Olamaz'>!") )
			return false;
		else
			return true;	
	}
	function show_filter()
	{
		if(document.getElementById('listing_type').value==2)
		{
			document.getElementById('exp_cen_1').style.display="";
			exp_cen_2.style.display="";
			exp_it_1.style.display="";
			exp_it_2.style.display="";
		}	
		else
		{
			exp_cen_1.style.display="none";
			exp_cen_2.style.display="none";
			exp_it_1.style.display="none";
			exp_it_2.style.display="none";
		}
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cost.list_expense_requests';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cost/display/list_expense_requests.cfm';
</cfscript>


</cfif>
<cfif fusebox.circuit eq 'myhome' and ((isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event"))>
    <cf_xml_page_edit>
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.search_date1" default='#dateformat(date_add("d", -1, now()),"dd/mm/yyyy")#'>
    <cfparam name="attributes.search_date2" default='#dateformat(now(),"dd/mm/yyyy")#'>
    <cfparam name="attributes.employee_id" default="">
    <cfparam name="attributes.expense_employee" default="">
    <cfparam name="attributes.record_emp" default="">
    <cfparam name="attributes.record_emp_name" default="">
    <cfparam name="attributes.form_exist" default="">
    <cfparam name="attributes.document_type" default="">
    <cfparam name="attributes.date_filter" default="1">
    <cfparam name="attributes.document_result" default="">
    <cfparam name="attributes.expense_stage" default="">
    <cfparam name="attributes.listing_type" default="1">
    <cfparam name="attributes.expense_center_name" default="">
    <cfparam name="attributes.expense_center_id" default="">
    <cfparam name="attributes.expense_item_name" default="">
    <cfparam name="attributes.expense_item_id" default="">
    <cfif len(attributes.search_date1)><cf_date tarih='attributes.search_date1'></cfif>
    <cfif len(attributes.search_date2)><cf_date tarih='attributes.search_date2'></cfif>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
    <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
        SELECT EXPENSE_ID,EXPENSE_CODE,EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
    </cfquery>
    <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
        SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
    </cfquery>
    <cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
        SELECT
            SDT.DOCUMENT_TYPE_ID,
            SDT.DOCUMENT_TYPE_NAME
        FROM
            SETUP_DOCUMENT_TYPE SDT,
            SETUP_DOCUMENT_TYPE_ROW SDTR
        WHERE
            SDTR.DOCUMENT_TYPE_ID = SDT.DOCUMENT_TYPE_ID AND
            SDTR.FUSEACTION LIKE '%#fuseaction#%'
        ORDER BY
            SDT.DOCUMENT_TYPE_NAME
    </cfquery>
    <cfquery name="get_process_type" datasource="#dsn#">
        SELECT
            PTR.STAGE,
            PTR.PROCESS_ROW_ID
        FROM
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO,
            PROCESS_TYPE PT
        WHERE
            PT.IS_ACTIVE = 1 AND
            PTR.PROCESS_ID = PT.PROCESS_ID AND
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.form_upd_expense_plan_request%">
        ORDER BY
            PTR.LINE_NUMBER
    </cfquery>
    
    <cfif  isdefined("attributes.form_exist")>
        <cfquery name="GET_EXPENSE" datasource="#dsn2#"><!---<cfoutput ><pre>--->
            WITH CTE1 AS(
            SELECT <cfif not (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>DISTINCT</cfif>
                EIPR.RECORD_EMP,
                EIPR.PAPER_NO,
                EIPR.RECORD_DATE,
                EIPR.EMP_ID,
                EIPR.EXPENSE_DATE,
           <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXP_ITEM_ROWS_ID,
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS.AMOUNT,
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS.DETAIL,
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS.TOTAL_AMOUNT,
                EXPENSE_ITEM_PLAN_REQUESTS_ROWS.AMOUNT_KDV,
                E_C.EXPENSE,
                E_I.EXPENSE_ITEM_NAME,
           <cfelse>
                EIPR.TOTAL_AMOUNT,
                EIPR.NET_KDV_AMOUNT,
                EIPR.NET_TOTAL_AMOUNT,
            </cfif> 
                EIPR.INVOICE_NO,
                EIPR.PAPER_TYPE,
                EIPR.EXPENSE_ID,
                EIPR.EXPENSE_STAGE,
                EIPR.SALES_COMPANY_ID,
                EIPR.SALES_CONSUMER_ID,
                CONSUMER.CONSUMER_NAME,
                CONSUMER.CONSUMER_SURNAME,
                SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME,
                EMP.EMPLOYEE_NAME,
                EMP.EMPLOYEE_SURNAME,
                C.FULLNAME,
                PTR.STAGE
            FROM
                EXPENSE_ITEM_PLAN_REQUESTS EIPR
                LEFT JOIN #dsn_alias#.CONSUMER ON CONSUMER.CONSUMER_ID = EIPR.SALES_CONSUMER_ID
                LEFT JOIN #dsn_alias#.SETUP_DOCUMENT_TYPE ON SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID = EIPR.PAPER_TYPE
                LEFT JOIN #dsn_alias#.EMPLOYEES EMP on EMP.EMPLOYEE_ID =EIPR.EMP_ID
                LEFT JOIN #dsn_alias#.COMPANY C on C.COMPANY_ID=EIPR.SALES_COMPANY_ID
                LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR on PTR.PROCESS_ROW_ID=EIPR.EXPENSE_STAGE
                LEFT JOIN EXPENSE_ITEM_PLAN_REQUESTS_ROWS on EIPR.EXPENSE_ID = EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ID
            <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
                LEFT JOIN EXPENSE_ITEMS E_I on E_I.EXPENSE_ITEM_ID=EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID
                LEFT JOIN EXPENSE_CENTER E_C on E_C.EXPENSE_ID=EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID
            </cfif>
            WHERE
                ((
                    <cfif isDefined("xml_show_chief_requests") and xml_show_chief_requests eq 1>
                        EIPR.RECORD_EMP IN
                        (	SELECT
                                EP.EMPLOYEE_ID
                            FROM
                                #dsn_alias#.EMPLOYEE_POSITIONS EP
                            WHERE
                                EP.UPPER_POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> <!---'#session.ep.position_code#'---> OR
                                EP.UPPER_POSITION_CODE2 = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> <!---'#session.ep.position_code#'--->
                        ) OR
                    </cfif>
                    EIPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><!---'#session.ep.userid#'--->
                ) OR EXPENSE_ITEM_PLAN_REQUESTS_ROWS.COMPANY_PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">)
                <cfif len(attributes.keyword)>
                    AND 
                    (
                        EIPR.PAPER_NO LIKE '%#attributes.keyword#%'
                        OR 
                        EIPR.SYSTEM_RELATION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><!---'%#attributes.keyword#%'--->
                    )
                </cfif>
                <cfif xml_expense_center_is_popup eq 1>
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_center_id') and len(attributes.expense_center_id) and len(attributes.expense_center_name))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"></cfif>
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_item_id') and len(attributes.expense_item_id) and len(attributes.expense_item_name))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"></cfif>
                 <cfelse>
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_center_id') and len(attributes.expense_center_id))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_CENTER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_center_id#"></cfif>
                    <cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) and (isdefined('attributes.expense_item_id') and len(attributes.expense_item_id))>AND EXPENSE_ITEM_PLAN_REQUESTS_ROWS.EXPENSE_ITEM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"></cfif>
                 </cfif>   
                <cfif len(attributes.search_date1)>AND EIPR.EXPENSE_DATE >= #attributes.search_date1#</cfif>
                <cfif len(attributes.search_date2)>AND EIPR.EXPENSE_DATE <= #attributes.search_date2#</cfif>
                <cfif len(attributes.expense_employee) and len(attributes.employee_id)>AND EIPR.EMP_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><!---'#attributes.employee_id#'---></cfif>
                <cfif len(attributes.record_emp_name) and len(attributes.record_emp)>AND EIPR.RECORD_EMP =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp#"><!---'#attributes.record_emp#'---></cfif>
                <cfif len(attributes.document_type)>AND EIPR.PAPER_TYPE = #attributes.document_type#</cfif>
                <cfif Len(attributes.document_result)>
                    <cfif attributes.document_result eq 2><!--- Islenmeyenler --->
                        AND ISNULL(EIPR.IS_APPROVE,1) != 0
                        AND EIPR.EXPENSE_ID NOT IN (SELECT EIP.REQUEST_ID FROM EXPENSE_ITEM_PLANS EIP WHERE EIP.REQUEST_ID = EIPR.EXPENSE_ID)
                    <cfelseif attributes.document_result eq 1><!--- Masrafa Donusenler --->
                        AND EIPR.EXPENSE_ID IN (SELECT EIP.REQUEST_ID FROM EXPENSE_ITEM_PLANS EIP WHERE EIP.REQUEST_ID = EIPR.EXPENSE_ID)
                    <cfelseif attributes.document_result eq 0><!--- Reddedilenler --->
                        AND EIPR.IS_APPROVE = 0
                    </cfif>
                </cfif>
                <cfif Len(attributes.expense_stage)>AND EIPR.EXPENSE_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_stage#"><!---'#attributes.expense_stage#'---></cfif>
        
                ),
             CTE2 AS (
                    SELECT
                        CTE1.*,
                            ROW_NUMBER() OVER (
                                                ORDER BY  
                                                <cfif len(attributes.date_filter) and attributes.date_filter eq 2>
                                                    EXPENSE_DATE
                                                <cfelseif len(attributes.date_filter) and attributes.date_filter eq 1>
                                                    EXPENSE_DATE DESC,EXPENSE_ID
                                                </cfif>
                ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)     
        </cfquery><!---</pre></cfoutput><cfabort>--->
        <cfparam name="attributes.totalrecords" default="#get_expense.query_count#">
    <cfelse>
        <cfparam name="attributes.totalrecords" default="0">
    </cfif>
	<cfscript>
        url_str = "" ;
        if ( len(attributes.keyword) )
            url_str = "#url_str#&keyword=#attributes.keyword#";
        if ( len(attributes.search_date1) )
            url_str = "#url_str#&search_date1=#dateformat(attributes.search_date1,'dd/mm/yyyy')#";
        if ( len(attributes.search_date2) )
            url_str = "#url_str#&search_date2=#dateformat(attributes.search_date2,'dd/mm/yyyy')#";
        if ( len(attributes.employee_id) and len(attributes.expense_employee))
            url_str = "#url_str#&expense_employee=#attributes.expense_employee#&employee_id=#attributes.employee_id#";
        if ( len(attributes.record_emp_name) and Len(attributes.record_emp))
            url_str = "#url_str#&record_emp_name=#attributes.record_emp_name#&record_emp=#attributes.record_emp#";
        if ( len(attributes.form_exist) )
            url_str = "#url_str#&form_exist=#attributes.form_exist#";
        if ( len(attributes.date_filter) )
            url_str = "#url_str#&date_filter=#attributes.date_filter#";
        if ( len(attributes.document_result) )
            url_str = "#url_str#&document_result=#attributes.document_result#";
        if ( len(attributes.expense_stage) )
            url_str = "#url_str#&expense_stage=#attributes.expense_stage#";
        if (len(attributes.listing_type))
        url_str = "#url_str#&listing_type=#attributes.listing_type#";
        if (len(attributes.expense_center_name))
        url_str = "#url_str#&expense_center_name=#attributes.expense_center_name#";
        if (len(attributes.expense_center_id))
        url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#";
        if (len(attributes.expense_item_id))
        url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#";
        if (len(attributes.expense_item_name))
        url_str = "#url_str#&expense_item_name=#attributes.expense_item_name#";
        if (len(attributes.expense_center_id))
        url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#";
        if (len(attributes.expense_item_id))
        url_str = "#url_str#&expense_item_id=#attributes.expense_item_id#";
    </cfscript>
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
    <cf_xml_page_edit fuseact="objects.expense_request">
    <cf_papers paper_type="EXPENDITURE_REQUEST">
    <cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
        SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
        SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 AND IS_ACTIVE=1 ORDER BY EXPENSE_ITEM_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
        SELECT EXPENSE_ID,EXPENSE_CODE,EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
    </cfquery>
    <cfquery name="GET_MONEY" datasource="#dsn#">
        SELECT *, 0 AS IS_SELECTED FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1 ORDER BY MONEY_ID
    </cfquery>
    <!--- <cfquery name="GET_PAYMETHOD" datasource="#dsn#">
        SELECT * FROM SETUP_PAYMETHOD ORDER BY PAYMETHOD
    </cfquery> --->
    <cfquery name="GET_TAX"  datasource="#dsn2#">
        SELECT * FROM SETUP_TAX ORDER BY TAX
    </cfquery>
    <cfif isdefined("attributes.opp_id") and len(attributes.opp_id)>
        <cfquery name="GET_OPPORTUNITY" datasource="#DSN3#">
            SELECT OPP_ID,OPP_HEAD FROM OPPORTUNITIES WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_id#">
        </cfquery>
    </cfif>
    <cfif isdefined("attributes.work_id") and len(attributes.work_id)>
    <cfquery name="GET_WORK" datasource="#DSN#">
        SELECT WORK_ID,WORK_HEAD FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
    </cfquery>
    </cfif>
    <cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
        SELECT
            SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
            SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
        FROM
            SETUP_DOCUMENT_TYPE,
            SETUP_DOCUMENT_TYPE_ROW
        WHERE
            SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
            SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE '%#fuseaction#%'
        ORDER BY
            DOCUMENT_TYPE_NAME
    </cfquery>
    <cfif isdefined("attributes.request_id") and len(attributes.request_id)><!--- kopyalama --->
        <cfquery name="GET_EXPENSE" datasource="#dsn2#">
            SELECT 
            	EIPR.*,
                SP.PAYMETHOD 
            FROM 
            	EXPENSE_ITEM_PLAN_REQUESTS EIPR
                LEFT JOIN SETUP_PAYMETHOD ON SP.PAYMETHOD_ID = EIPR.PAYMETHOD_ID
            WHERE 
            	EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
        </cfquery>
        <cfquery name="GET_ROWS" datasource="#dsn2#">
            SELECT * FROM EXPENSE_ITEM_PLAN_REQUESTS_ROWS WHERE EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
        </cfquery>
    </cfif>
    <cfif isdefined("attributes.request_id")>
			<cfset work_head_list = "">
			<cfset opp_head_list = "">
			<cfset pyschical_asset_list = "">
			<cfset expense_center_list = "">
			<cfset expense_item_list = "">
			<cfoutput query="get_rows">
				<cfif len(expense_center_id) and not listfind(expense_center_list,expense_center_id)>
					<cfset expense_center_list=listappend(expense_center_list,expense_center_id)>
				</cfif>
				<cfif len(expense_item_id) and not listfind(expense_item_list,expense_item_id)>
					<cfset expense_item_list=listappend(expense_item_list,expense_item_id)>
				</cfif>
				<cfif len(work_id) and not listfind(work_head_list,work_id)>
					<cfset work_head_list=listappend(work_head_list,work_id)>
				</cfif>
				<cfif len(opp_id) and not listfind(opp_head_list,opp_id)>
					<cfset opp_head_list=listappend(opp_head_list,opp_id)>
				</cfif>
				<cfif len(pyschical_asset_id) and not listfind(pyschical_asset_list,pyschical_asset_id)>
					<cfset pyschical_asset_list=listappend(pyschical_asset_list,pyschical_asset_id)>
				</cfif>
			</cfoutput>
			<cfif len(work_head_list)>
				<cfset work_head_list=listsort(work_head_list,"numeric","ASC",",")>
				<cfquery name="get_work" datasource="#dsn#">
					SELECT WORK_ID,WORK_HEAD FROM PRO_WORKS WHERE WORK_ID IN (#work_head_list#) ORDER BY WORK_ID
				</cfquery>
				<cfset work_head_list = ListSort(ListDeleteDuplicates(ValueList(get_work.work_id)),'numeric','ASC',',')>
			</cfif>
			<cfif len(opp_head_list)>
				<cfset opp_head_list=listsort(opp_head_list,"numeric","ASC",",")>
				<cfquery name="get_opportunities" datasource="#DSN3#">
					SELECT OPP_ID,OPP_HEAD FROM OPPORTUNITIES WHERE OPP_ID IN (#opp_head_list#) ORDER BY OPP_ID
				</cfquery>
				<cfset opp_head_list = ListSort(ListDeleteDuplicates(ValueList(get_opportunities.opp_id)),'numeric','ASC',',')>
			</cfif>
			<cfif len(pyschical_asset_list)>
				<cfset pyschical_asset_list=listsort(pyschical_asset_list,"numeric","ASC",",")>
				<cfquery name="GET_ASSETP_NAME" datasource="#dsn#">
					SELECT ASSETP_ID,ASSETP FROM ASSET_P WHERE ASSETP_ID IN (#pyschical_asset_list#) ORDER BY ASSETP_ID
				</cfquery>
				<cfset pyschical_asset_list = ListSort(ListDeleteDuplicates(ValueList(GET_ASSETP_NAME.ASSETP_ID)),'numeric','ASC',',')>
			</cfif>
			<cfif ListLen(expense_center_list)>
				<cfquery name="get_expense_center_list" datasource="#dsn2#">
					SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_center_list#) ORDER BY EXPENSE_ID
				</cfquery>
				<cfset expense_center_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_center_list.expense_id)),'numeric','ASC',',')>
			</cfif>
			<cfif ListLen(expense_item_list)>
				<cfquery name="get_expense_item" datasource="#dsn2#">
					SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#expense_item_list#) ORDER BY EXPENSE_ITEM_ID
				</cfquery>
				<cfset expense_item_list = ListSort(ListDeleteDuplicates(ValueList(get_expense_item.expense_item_id)),'numeric','ASC',',')>
			</cfif>
    </cfif>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')> 
    <cf_xml_page_edit fuseact="objects.expense_request">
    <!--gündem den çağrılan sayfalarda id encrypt li gönderildiği için eklendi GSÖ 20131021 --->
    <cfif fusebox.circuit eq 'myhome'>
        <cfset attributes.request_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.request_id,accountKey:'wrk')>
    </cfif>
    <input type="hidden" name="control_field_value" id="control_field_value" value="">
    <cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
        SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
        SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
    </cfquery>
    <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
        SELECT EXPENSE_ID,EXPENSE_CODE,EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
    </cfquery>
    <cfquery name="GET_MONEY" datasource="#dsn2#">
        SELECT MONEY_TYPE AS MONEY,* FROM EXPENSE_ITEM_PLAN_REQUESTS_MONEY WHERE ACTION_ID = #attributes.request_id#
    </cfquery>
    <cfif not GET_MONEY.recordcount>
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT MONEY,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
        </cfquery>
    </cfif>
    <cfquery name="GET_EXPENSE" datasource="#dsn2#">
        SELECT 
            EIPR.*,
            SP.PAYMETHOD,
            C.CONSUMER_NAME,
            C.CONSUMER_SURNAME,
            C.COMPANY
        FROM 
            EXPENSE_ITEM_PLAN_REQUESTS EIPR
            LEFT JOIN #dsn_alias#.SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = EIPR.PAYMETHOD_ID
            LEFT JOIN #dsn_alias#.CONSUMER C ON C.CONSUMER_ID = EIPR.CONSUMER_ID
        WHERE 
            EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_id#">
    </cfquery>
    <cfif GET_EXPENSE.RECORDCOUNT eq 0 or (isdefined('attributes.active_company') and attributes.active_company neq session.ep.company_id)>
        <script type="text/javascript">
            alert("<cf_get_lang_main no ='1531.Böyle Bir Kayıt Bulunmamaktadır'>");
            history.go(-1);
        </script>
        <cfabort>
    </cfif>
    <cfquery name="GET_TAX"  datasource="#dsn2#">
        SELECT * FROM SETUP_TAX ORDER BY TAX
    </cfquery>
    <cfquery name="GET_DOCUMENT_TYPE" datasource="#dsn#">
        SELECT
            SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
            SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
        FROM
            SETUP_DOCUMENT_TYPE,
            SETUP_DOCUMENT_TYPE_ROW
        WHERE
            SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID =  SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
            SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE '%#fuseaction#%'
        ORDER BY
            DOCUMENT_TYPE_NAME
    </cfquery>
    <cfquery name="GET_ROWS" datasource="#dsn2#">
        SELECT * FROM EXPENSE_ITEM_PLAN_REQUESTS_ROWS WHERE EXPENSE_ID = #attributes.request_id#
    </cfquery>
    <cfquery name="GET_KONTROL" datasource="#dsn2#">
        SELECT REQUEST_ID,PAPER_NO,EXPENSE_ID FROM EXPENSE_ITEM_PLANS WHERE REQUEST_ID = #attributes.request_id#
    </cfquery>
</cfif>

<script type="text/javascript">
//Event : list
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	window.onload = show_filter;
        document.getElementById('keyword').focus();
        function show_filter()
        {
            if(document.getElementById('listing_type').value==2)
            {
                document.getElementById('exp_cen_1').style.display="";
                exp_cen_2.style.display="";
                exp_it_1.style.display="";
                exp_it_2.style.display="";
            }	
            else
            {
                exp_cen_1.style.display="none";
                exp_cen_2.style.display="none";
                exp_it_1.style.display="none";
                exp_it_2.style.display="none";
            }
        }
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
	<cfif isdefined("get_rows") and get_rows.recordcount>
		row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>

	function sil(sy)
	{
		var my_element=eval("add_costplan.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function add_row(row_detail,exp_center,exp_item,activity,exp_stock_id,exp_product_id,exp_product_name,exp_stock_unit,exp_stock_unit_id,exp_tax_rate,exp_money_id,expense_date,exp_member_type,exp_member_id,exp_company_id,exp_authorized,exp_company,exp_project_id,exp_project,exp_asset_id,exp_asset,row_work_id,row_work_head,exp_opp_id,exp_opp_head,exp_center_name,exp_item_name)
	{
		//Normal satır eklerken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
		if (row_detail == undefined)row_detail ="";
		if (exp_center == undefined){exp_center =""; exp_center_name="";}
		if (exp_item == undefined){exp_item =""; exp_item_name="";}
		if (activity == undefined)activity ="";
		if (exp_member_type == undefined)exp_member_type ="";
		if (exp_member_id == undefined)exp_member_id ="";
		if (exp_member_id == undefined)exp_member_id ="";
		if (exp_company_id == undefined)exp_company_id ="";
		if (exp_authorized == undefined)exp_authorized ="";
		if (exp_company == undefined)exp_company ="";
		if (exp_stock_id == undefined)exp_stock_id ="";
		if (exp_product_id == undefined)exp_product_id ="";
		if (exp_product_name == undefined)exp_product_name ="";
		if (exp_stock_unit == undefined)exp_stock_unit ="";
		if (exp_stock_unit_id == undefined) exp_stock_unit_id ="";
		if (exp_project_id == undefined)exp_project_id ="";
		if (exp_project == undefined)exp_project ="";
		if (expense_date == undefined)expense_date = document.getElementById("expense_date").value;
		if (exp_asset_id == undefined)exp_asset_id ="";
		if (exp_asset == undefined)exp_asset ="";
		if (exp_tax_rate == undefined)exp_tax_rate ="0";
		if (exp_money_id == undefined)exp_money_id ="";
		if (row_work_id == undefined) row_work_id ="";
		if (row_work_head == undefined) row_work_head ="";
		
		<cfif isdefined("attributes.work_id") and len(attributes.work_id)>
			row_work_id = "<cfoutput>#get_work.work_id#</cfoutput>";
			row_work_head = "<cfoutput>#get_work.work_head#</cfoutput>";
		</cfif>
		if (exp_opp_id == undefined) exp_opp_id ="";
		if (exp_opp_head == undefined) exp_opp_head ="";
		<cfif isdefined("attributes.opp_id") and len(attributes.opp_id)>
			exp_opp_id = "<cfoutput>#attributes.opp_id#</cfoutput>";
			exp_opp_head = "<cfoutput>#get_opportunity.opp_head#</cfoutput>";
		</cfif>
		
		rate_round_num_ = "<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>";
		if(rate_round_num_ == "") rate_round_num_ = "2";
		
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.add_costplan.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute("nowrap","nowrap");
		newCell.innerHTML = '<input  type="hidden"  value="1" name="row_kontrol' + row_count +'"  id="row_kontrol' + row_count +'" ><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="Satır Kopyala"><img  src="images/copy_list.gif" border="0"></a>';
		<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),3) or x_is_project_priority eq 1>
			newCell.innerHTML += '<input type="hidden" name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" value="'+exp_center+'"><input type="hidden" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" value="'+exp_center+'">';
		</cfif>
		<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),4) or x_is_project_priority eq 1>
			newCell.innerHTML += '<input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+exp_item+'"><input type="hidden" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item+'">';
		</cfif>
		<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),7)>
			newCell.innerHTML += '<input type="hidden" name="quantity' + row_count +'" id="quantity' + row_count +'" value="'+1+'">';
		</cfif>
		<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
			<cfswitch expression="#xlr#">
				<cfcase value="1">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.setAttribute("id","expense_date" + row_count + "_td");
					newCell.innerHTML = '<input type="text" name="expense_date' + row_count +'" id="expense_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="' +expense_date +'"> ';
					wrk_date_image('expense_date' + row_count);
				</cfcase>
				<cfcase value="2">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" style="width:140px;" class="boxtext" value="'+row_detail+'">';
				</cfcase>
				<cfcase value="3">
					<cfif x_is_project_priority eq 0>
						<cfif xml_expense_center_is_popup eq 1>
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" value="'+exp_center+'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="AutoComplete_Create(\'expense_center_name' + row_count +'\',\'EXPENSE,EXPENSE_CODE\',\'EXPENSE,EXPENSE_CODE\',\'get_expense_center\',\'0\',\'EXPENSE_ID\',\'expense_center_id' + row_count +'\',\'add_costplan\',1);" value="'+exp_center_name+'" style="width:180px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
						<cfelse>
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							a = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:200px;" class="boxtext"><option value=""><cf_get_lang_main no='1048.Masraf Merkezi'></option>';
							<cfoutput query="get_expense_center">
								if('#expense_id#' == exp_center)
									a += '<option value="#expense_id#" selected>#expense#</option>';
								else
									a += '<option value="#expense_id#">#expense#</option>';
							</cfoutput>
							newCell.innerHTML =a+ '</select>';
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="4">
					<cfif x_is_project_priority eq 0>
						<cfif xml_expense_center_is_popup eq 1>
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							newCell.innerHTML ='<input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+exp_item+'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item_name+'" style="width:233px;" onFocus="AutoComplete_Create(\'expense_item_name' + row_count +'\',\'EXPENSE_ITEM_NAME\',\'EXPENSE_ITEM_NAME\',\'get_expense_item\',\'<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>\',\'EXPENSE_ITEM_ID,ACCOUNT_CODE,TAX_CODE\',\'expense_item_id' + row_count +',account_code' + row_count +',tax_code' + row_count +'\',\'add_costplan\',1);"  class="boxtext"><a href="javascript://" onClick="pencere_ac_item('+ row_count +',<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
						<cfelse>
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							a = '<select name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:200px;" class="boxtext"><option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option>';
							<cfoutput query="get_expense_item">
								if('#expense_item_id#' == exp_item)
									a += '<option value="#expense_item_id#" selected>#replace(expense_item_name,"'","\'")#</option>';
								else
									a += '<option value="#expense_item_id#">#replace(expense_item_name,"'","\'")#</option>';
							</cfoutput>
							newCell.innerHTML =a+ '</select>';
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="5">	
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input  type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+exp_product_id+'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+exp_stock_id+'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext" onFocus="AutoComplete_Create(\'product_name'+ row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME\',\'get_product\',\'0\',\'STOCK_ID,PRODUCT_ID,PRODUCT_NAME\',\'stock_id' + row_count +',product_id' + row_count +',product_name'+ row_count +'\',\'\',3,150);" maxlength="50" style="width:150px;" <!--- onFocus="hesapla(' + row_count +');"  --->value="'+exp_product_name+'">';
					newCell.innerHTML += '<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=all.product_id" + row_count + "&field_id=all.stock_id" + row_count + "&field_product_cost=all.total"+row_count +"&field_unit_name= all.stock_unit"+row_count +"&field_unit= all.stock_unit_id"+row_count+"&run_function=hesapla&run_function_param="+row_count+"&expense_date='+document.all.expense_date.value+'&field_name=all.product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
					newCell.innerHTML += '<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_detail_product</cfoutput>&pid='+document.getElementById('product_id"+row_count+"').value+'&sid='+document.getElementById('stock_id"+row_count+"').value+'','list');"+'"><img src="/images/plus_thin_p.gif" border="0" align="absbottom" alt="<cf_get_lang no="458.Ürün Detay">" style="display:none;" id="product_info'+row_count+'"></a>';
				</cfcase>
				<cfcase value="6">	
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="stock_unit_id' + row_count +'" id="stock_unit_id' + row_count +'" value="'+exp_stock_unit_id+'"><input type="text" name="stock_unit' + row_count +'" id="stock_unit' + row_count +'"  value="'+exp_stock_unit+'" style="width:90px;" class="boxtext" readonly>';
				</cfcase>
				<cfcase value="7">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" style="width:90px;" class="box" value="'+ commaSplit(1,rate_round_num_)+ '" onBlur="hesapla(\'quantity\',' + row_count +');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">';
				</cfcase>
				<cfcase value="8">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="total' + row_count +'"  id="total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;" onBlur="hesapla(\'total\','+row_count+');" class="box">';
				</cfcase>
				<cfcase value="9">
					newCell = newRow.insertCell(newRow.cells.length);
					xx = '<select name="tax_rate'+ row_count +'" id="tax_rate'+ row_count +'" style="width:100%;" class="box" onChange="hesapla(\'tax_rate\','+row_count+');">';
					<cfoutput query="get_tax">
					if('#tax#' == exp_tax_rate)
						xx += '<option value="#tax#" selected>#tax#</option>';
					else
						xx += '<option value="#tax#">#tax#</option>';
					</cfoutput>
					newCell.innerHTML =xx + '</select>';
				</cfcase>
				<cfcase value="10">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="kdv_total'+ row_count +'" id="kdv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;;" onBlur="hesapla(\'kdv_total\','+row_count+',1);" class="box">';
				</cfcase>
				<cfcase value="11">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="net_total' + row_count +'" id="net_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;;" onBlur="hesapla(\'net_total\',' + row_count +',2);" class="box">';
				</cfcase>
				<cfcase value="12">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					yy = '<select name="money_id' + row_count  +'" id="money_id' + row_count  +'" style="width:60px;" class="boxtext" onChange="other_calc('+ row_count +');">';
					<cfoutput query="get_money">
					if('#money#,#rate1#,#rate2#' == exp_money_id)
						yy += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
					else
						yy += '<option value="#money#,#rate1#,#rate2#">#money#</option>';
					</cfoutput>
					newCell.innerHTML =yy + '</select>';
				</cfcase>
				<cfcase value="13">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="other_net_total' + row_count +'" id="other_net_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;" class="box" onBlur="other_calc('+row_count+',2);">';
				</cfcase>
				<cfcase value="14">	
					newCell = newRow.insertCell(newRow.cells.length);
					a = '<select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:90px;" class="boxtext"><option value=""><cf_get_lang no='777.Aktivite Tipi'></option>';
					<cfoutput query="get_activity_types">
					if('#activity_id#' == activity)
						a += '<option value="#activity_id#" selected>#activity_name#</option>';
					else
						a += '<option value="#activity_id#">#activity_name#</option>';
					</cfoutput>
					newCell.innerHTML =a+ '</select>';
				</cfcase>
				<cfcase value="15">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="work_id' + row_count +'" id="work_id'+ row_count +'" value="'+row_work_id+'"><input type="text" name="work_head' + row_count +'" id="work_head'+ row_count +'" value="'+row_work_head+'" onFocus="AutoComplete_Create(\'work_head'+ row_count +'\',\'WORK_HEAD\',\'WORK_HEAD\',\'get_work\',\'\',\'WORK_ID\',\'work_id'+ row_count +'\',\'\',3,200,\'\');" style="width:139px;" class="boxtext">';
					newCell.innerHTML +='<a href="javascript://" onClick="pencere_ac_work('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
				</cfcase>
				<cfcase value="16">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="opp_id' + row_count +'" id="opp_id'+ row_count +'" value="'+exp_opp_id+'"><input type="text" name="opp_head' + row_count +'" id="opp_head'+ row_count +'" value="'+exp_opp_head+'" onFocus="AutoComplete_Create(\'opp_head'+ row_count +'\',\'OPP_HEAD\',\'OPP_HEAD\',\'get_opportunity\',\'\',\'OPP_ID\',\'opp_id'+ row_count +'\',\'\',3,200,\'\');" style="width:110px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_oppotunity('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
				</cfcase>
				<cfcase value="17">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value="'+exp_member_type+'"><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'" value="'+exp_member_id+'"><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value="'+exp_company_id+'"><input type="text" style="width:110px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="'+exp_authorized+'" class="boxtext" onFocus="auto_company('+ row_count +');" autocomplete="off">&nbsp;<input type="text" name="company'+ row_count +'" id="company'+ row_count +'" value="'+exp_company+'"  style="width:110px;" class="boxtext" readonly><a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
				</cfcase>
				<cfcase value="18">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value="'+exp_asset_id+'"><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="'+exp_asset+'" style="width:120px;" class="boxtext" onFocus="autocomp_assetp('+ row_count +');"><a href="javascript://" onClick="pencere_ac_asset('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
				</cfcase>
				<cfcase value="19">	
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+exp_project_id+'"><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="'+exp_project+'" style="width:120px;" class="boxtext" onFocus="AutoComplete_Create(\'project'+ row_count +'\',\'PROJECT_HEAD\',\'PROJECT_HEAD\',\'get_project\',\'\',\'PROJECT_ID\',\'project_id'+ row_count +'\',\'\',3,200,\'\');"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
				</cfcase>
			</cfswitch>
		</cfloop>
	}
	
	function autocomp_assetp(no)
	{
		<cfif isdefined("xml_exp_center_from_assetp") and xml_exp_center_from_assetp eq 1>
			AutoComplete_Create('asset'+ row_count +'','ASSETP','ASSETP','get_assetp_autocomplete','\'\',1','ASSETP_ID,EMPLOYEE_ID,EMP_NAME,MEMBER_TYPE,EXPENSE_CENTER_ID,EXPENSE_CODE_NAME','asset_id'+no+',member_id'+no+',authorized'+no+',member_type'+no+',expense_center_id'+no+'','',3,130);
		<cfelse>
			AutoComplete_Create('asset'+ row_count +'','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID','asset_id'+no+'',3,130);
		</cfif>
	}
	function pencere_ac_oppotunity(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_opportunities&field_opp_id=all.opp_id' + no +'&field_opp_head=all.opp_head' + no ,'list');
	}
	function auto_company(no)
	{
		AutoComplete_Create('authorized'+no,'MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','MEMBER_TYPE,PARTNER_ID2,COMPANY_ID,MEMBER_NAME2','member_type'+no+',member_id'+no+',company_id'+no+',company'+no+'','','3','250');
	}
	function pencere_ac_work(no)
	{
		p_id_ = document.getElementById("project_id" + no).value;
		p_name_ = document.getElementById("project" + no).value;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=all.work_id' + no +'&field_name=all.work_head' + no +'&project_id=' + p_id_ + '&project_head=' + p_name_ +'&field_pro_id=all.project_id' +no + '&field_pro_name=all.project' +no,'list');
	}
	function pencere_ac_company(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=all.member_id' + no +'&field_emp_id=all.member_id' + no +'&field_comp_name=all.company' + no +'&field_name=all.authorized' + no +'&field_comp_id=all.company_id' + no + '&field_type=all.member_type' + no + '&select_list=1,2,3,5,6','list');
	}
	function pencere_ac_asset(no)
	{
		adres = '<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps';
		adres += '&field_id=all.asset_id' + no +'&field_name=all.asset' + no +'&event_id=0&motorized_vehicle=0';
		<cfif x_is_add_position_to_asset_list eq 1>
			adres += '&member_type=all.member_type' + no;
			adres += '&employee_id=all.member_id' + no;
			adres += '&position_employee_name=all.authorized' + no;	
		</cfif>
		<cfif isdefined("xml_exp_center_from_assetp") and xml_exp_center_from_assetp eq 1>
			adres += '&exp_center_id=all.expense_center_id' + no;	
		</cfif>
		windowopen(adres,'list');
	}
	function pencere_ac_project(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=all.project_id' + no +'&project_head=all.project' + no,'list');
	}
	function pencere_ac_campaign(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_campaigns&field_id=all.campaign_id' + no +'&field_name=all.campaign' + no,'list');
	}
	<cfoutput>
	function hesapla(field_name,satir,hesap_type,extra_type)
	{
		if(satir == undefined)
		{
			satir = field_name;
			field_name = 'total';
		}
		if(field_name != '' && field_name!= 'product_id')
		{
			var input_name_ = field_name+satir;
			field_changed_value = filterNum(document.getElementById(input_name_).value);
		}
		else
			field_changed_value = '-1';
			
		if(field_changed_value == '-1' || document.getElementById("control_field_value") == undefined || (document.getElementById("control_field_value") != undefined && field_changed_value != document.getElementById("control_field_value").value))
		{
			var toplam_dongu_0 = 0;//satir toplam
			if(document.getElementById('row_kontrol'+satir).value==1)
			{
				deger_total = document.getElementById('total'+satir);//tutar
				deger_kdv_total= document.getElementById('kdv_total'+satir);//kdv tutarı
				deger_net_total = document.getElementById('net_total'+satir);//kdvli tutar
				deger_tax_rate = document.getElementById('tax_rate'+satir);//kdv oranı
				if(document.getElementById('quantity'+satir) != undefined) 
					deger_quantity =  document.getElementById('quantity'+satir).value; 
				else 
					deger_quantity ="";//miktar
				if(document.getElementById('other_net_total'+satir) != undefined) deger_other_net_total = document.getElementById('other_net_total'+satir); else deger_other_net_total ="";//dovizli tutar kdv dahil
				if(deger_total.value == "") deger_total.value = 0;
				if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
				if(deger_net_total.value == "") deger_net_total.value = 0;
				deger_money_id = document.getElementById('money_id'+satir);
				deger_money_id =  list_getat(deger_money_id.value,1,',');
				for(s=1;s<=add_costplan.kur_say.value;s++)
				{
					money_deger =list_getat(add_costplan.rd_money[s-1].value,1,',');
					if(money_deger == deger_money_id)
					{
						deger_diger_para_satir = document.add_costplan.rd_money[s-1];
						form_value_rate_satir = document.getElementById('txt_rate2_'+s);
					}
				}
				deger_para_satir = list_getat(deger_diger_para_satir.value,3,',');
				deger_total.value = filterNum(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
				if(deger_quantity != "") deger_quantity = filterNum(deger_quantity,'#session.ep.our_company_info.rate_round_num#'); else deger_quantity = 1;
				deger_kdv_total.value = filterNum(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_net_total.value = filterNum(deger_net_total.value,'#session.ep.our_company_info.rate_round_num#');
				if(document.getElementById('other_net_total'+satir) != undefined)
					deger_other_net_total.value = filterNum(deger_other_net_total.value,'#session.ep.our_company_info.rate_round_num#');		
				if(hesap_type == undefined)
				{
					if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = (parseFloat(deger_total.value) * parseFloat(deger_quantity) * deger_tax_rate.value)/100;
				}
				else if(hesap_type == 2)
				{
					deger_total.value = ((parseFloat(deger_net_total.value)/ parseFloat(deger_quantity))*100) / (parseFloat(deger_tax_rate.value)+100);
					deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity * deger_tax_rate.value))/100;
				}
				toplam_dongu_0 = parseFloat(deger_total.value * deger_quantity);
				if(deger_kdv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_kdv_total.value);
				if(extra_type != 2)
					 if(deger_other_net_total != "") deger_other_net_total.value = ((toplam_dongu_0) * parseFloat(deger_para_satir) / (parseFloat(form_value_rate_satir.value)));
				deger_net_total.value = commaSplit(toplam_dongu_0,'#session.ep.our_company_info.rate_round_num#');
				deger_total.value = commaSplit(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_quantity = commaSplit(deger_quantity,'#session.ep.our_company_info.rate_round_num#');
				
				deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
				if(deger_other_net_total != undefined)
					deger_other_net_total.value = commaSplit(deger_other_net_total.value,'#session.ep.our_company_info.rate_round_num#');
			}
			if(extra_type == 2 || extra_type == undefined)
				toplam_hesapla(extra_type);
		}
	}
	function toplam_hesapla(type)
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		if(type != 2)
			doviz_hesapla();
		for(r=1;r<=add_costplan.record_num.value;r++)
		{
			if(document.getElementById('row_kontrol'+r).value==1)
			{
				deger_total = document.getElementById('total'+r);//tutar
				deger_quantity =  document.getElementById('quantity'+r).value; //miktar
				deger_kdv_total= document.getElementById('kdv_total'+r);//kdv tutarı
				deger_net_total = document.getElementById('net_total'+r);//kdvli tutar
				deger_tax_rate = document.getElementById('tax_rate'+r);//kdv oranı
				if(document.getElementById('other_net_total'+r) != undefined) deger_other_net_total = document.getElementById('other_net_total'+r); else deger_other_net_total="";//dovizli tutar kdv dahil
				deger_total.value = filterNum(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_quantity = filterNum(deger_quantity,'#session.ep.our_company_info.rate_round_num#');
				deger_kdv_total.value = filterNum(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_net_total.value = filterNum(deger_net_total.value,'#session.ep.our_company_info.rate_round_num#');
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_quantity);
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value);
				toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_quantity) + parseFloat(deger_kdv_total.value));
				deger_net_total.value = commaSplit(deger_net_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_quantity = commaSplit(deger_quantity,'#session.ep.our_company_info.rate_round_num#');
				deger_total.value = commaSplit(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
			}
		}
		document.add_costplan.total_amount.value = commaSplit(toplam_dongu_1,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.kdv_total_amount.value = commaSplit(toplam_dongu_2,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.net_total_amount.value = commaSplit(toplam_dongu_3,'#session.ep.our_company_info.rate_round_num#');
		for(s=1;s<=add_costplan.kur_say.value;s++)
		{
			form_txt_rate2_ = document.getElementById('txt_rate2_'+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(add_costplan.kur_say.value == 1)
			for(s=1;s<=add_costplan.kur_say.value;s++)
			{
				if(document.add_costplan.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_costplan.rd_money;
					form_txt_rate2_ = document.getElementById('txt_rate2_'+s);
				}
			}
		else 
			for(s=1;s<=add_costplan.kur_say.value;s++)
			{
				if(document.add_costplan.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_costplan.rd_money[s-1];
					form_txt_rate2_ = document.getElementById('txt_rate2_'+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_2 = list_getat(deger_diger_para.value,2,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#session.ep.our_company_info.rate_round_num#');
	
		document.add_costplan.tl_value1.value = deger_money_id_1;
		document.add_costplan.tl_value2.value = deger_money_id_1;
		document.add_costplan.tl_value3.value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
	}
	function doviz_hesapla(type)
	{
		for(k=1;k<=add_costplan.record_num.value;k++)
		{		
			deger_money_id = document.getElementById('money_id'+k);
			deger_money_id =  list_getat(deger_money_id.value,1,',');
			for (var t=1; t<=add_costplan.kur_say.value; t++)
			{
			money_deger =list_getat(add_costplan.rd_money[t-1].value,1,',');
			if(money_deger == deger_money_id)	
				{		
					rate2_value = filterNum(document.getElementById('txt_rate2_'+t).value,'#session.ep.our_company_info.rate_round_num#')/filterNum(document.getElementById("txt_rate1_"+t).value,'#session.ep.our_company_info.rate_round_num#');
					if(document.getElementById('other_net_total'+k) != undefined)
						document.getElementById('other_net_total'+k).value = commaSplit(filterNum(document.getElementById('net_total'+k).value,'#session.ep.our_company_info.rate_round_num#')/rate2_value,'#session.ep.our_company_info.rate_round_num#');
				}
			}
		}
	}
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	function unformat_fields()
	{
		for(r=1;r<=add_costplan.record_num.value;r++)
		{		
			document.getElementById('total'+r).value = filterNum(document.getElementById('total'+r).value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('kdv_total'+r).value = filterNum(document.getElementById('kdv_total'+r).value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('net_total'+r).value = filterNum(document.getElementById('net_total'+r).value,'#session.ep.our_company_info.rate_round_num#');
			if(document.getElementById('other_net_total'+r) != undefined)
				document.getElementById('other_net_total'+r).value = filterNum(document.getElementById('other_net_total'+r).value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('quantity'+r).value = filterNum(document.getElementById('quantity'+r).value,'#session.ep.our_company_info.rate_round_num#');	
		}
		document.add_costplan.total_amount.value = filterNum(document.add_costplan.total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.kdv_total_amount.value = filterNum(document.add_costplan.kdv_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.net_total_amount.value = filterNum(document.add_costplan.net_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_total_amount.value = filterNum(document.add_costplan.other_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_kdv_total_amount.value = filterNum(document.add_costplan.other_kdv_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_net_total_amount.value = filterNum(document.add_costplan.other_net_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		for(s=1;s<=add_costplan.kur_say.value;s++)
		{
			eval('add_costplan.txt_rate2_' + s).value = filterNum(eval('add_costplan.txt_rate2_' + s).value,'#session.ep.our_company_info.rate_round_num#');
			eval('add_costplan.txt_rate1_' + s).value = filterNum(eval('add_costplan.txt_rate1_' + s).value,'#session.ep.our_company_info.rate_round_num#');
		}
		<cfif not (browserdetect() contains 'MSIE') or (browserdetect() contains 'MSIE' and browserdetect() contains '9.')>
			for(i=1;i<=document.all.record_num.value;i++)
			{
				var satir_ = i;
				document.add_costplan.appendChild(eval("document.all.row_kontrol" + satir_));
				document.add_costplan.appendChild(eval("document.all.row_detail" + satir_));
				document.add_costplan.appendChild(eval("document.all.expense_center_id" + satir_));
				document.add_costplan.appendChild(eval("document.all.expense_item_id" + satir_));
				if(document.getElementById('product_id'+satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.product_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.stock_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.product_name" + satir_));
				}
				if(document.getElementById('stock_unit'+satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.stock_unit" + satir_));
					document.add_costplan.appendChild(eval("document.all.stock_unit_id" + satir_));
				}
				document.add_costplan.appendChild(eval("document.all.quantity" + satir_));
				if(document.getElementById('total'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.total" + satir_));
				if(document.getElementById('tax_rate'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.tax_rate" + satir_));
				if(document.getElementById('kdv_total'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.kdv_total" + satir_));
				if(document.getElementById('net_total'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.net_total" + satir_));
				if(document.getElementById('money_id'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.money_id" + satir_));
				if(document.getElementById('other_net_total'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.other_net_total" + satir_));
				if(document.getElementById('activity_type'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.activity_type" + satir_));
				if(document.getElementById('member_type'+satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.member_type" + satir_));
					document.add_costplan.appendChild(eval("document.all.member_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.company_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.authorized" + satir_));
					document.add_costplan.appendChild(eval("document.all.company" + satir_));
				}
				if(document.getElementById('asset_id'+satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.asset_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.asset" + satir_));
				}
				if(document.getElementById('project_id'+satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.project_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.project" + satir_));
				}
				if(eval("document.all.expense_date" + satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.expense_date" + satir_));
				if(eval("document.all.work_id" + satir_) != undefined && eval("document.all.work_head" + satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.work_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.work_head" + satir_));
				}
				if(eval("document.all.opp_id" + satir_) != undefined && eval("document.all.opp_head" + satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.opp_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.opp_head" + satir_));
				}
			}
		</cfif>
	}
	function copy_row(no_info)
	{
		if(document.getElementById('row_detail'+no_info) != undefined)
			row_detail = document.getElementById('row_detail'+no_info).value;
		else
			row_detail = '';
		if(document.getElementById('expense_center_id'+no_info) != undefined)
			exp_center = document.getElementById('expense_center_id'+no_info).value;
		else
			exp_center = '';
			
		<cfif xml_expense_center_is_popup eq 1>
			if(document.getElementById('expense_center_name'+no_info) != undefined)
				exp_center_name = document.getElementById('expense_center_name'+no_info).value;
			else
				exp_center_name = '';
		<cfelse>
			exp_center_name = '';
		</cfif>
			
		if(document.getElementById('expense_item_id'+no_info) != undefined)
			exp_item = document.getElementById('expense_item_id'+no_info).value;
		else
			exp_item = '';
			
		<cfif xml_expense_center_is_popup eq 1>
			if(document.getElementById('expense_item_name'+no_info) != undefined)
				exp_item_name = document.getElementById('expense_item_name'+no_info).value;
			else
				exp_item_name = '';
		<cfelse>
			exp_item_name = '';
		</cfif>	
		
		if(document.getElementById('activity_type'+no_info) != undefined)
			activity = document.getElementById('activity_type'+no_info).value;
		else
			activity = '';
		if(document.getElementById('stock_id'+no_info) != undefined)
		{
			exp_stock_id = document.getElementById('stock_id'+no_info).value;  
			exp_product_id = document.getElementById('product_id'+no_info).value;
			exp_product_name = document.getElementById('product_name'+no_info).value;
		}
		else
		{
			exp_stock_id = '';
			exp_product_id = '';
			exp_product_name = '';
		}
		if (document.getElementById('stock_unit' + no_info) == undefined) exp_stock_unit =""; else exp_stock_unit = document.getElementById('stock_unit' + no_info).value;
		if (document.getElementById('stock_unit_id' + no_info) == undefined) exp_stock_unit_id =""; else exp_stock_unit_id = document.getElementById('stock_unit_id' + no_info).value;
		if(document.getElementById('tax_rate'+no_info) != undefined)
			exp_tax_rate = document.getElementById('tax_rate'+no_info).value; 
		else
		{
			exp_tax_rate = '';
		}
		exp_money_id = document.getElementById('money_id'+no_info).value;
		if(document.getElementById('member_type'+no_info) != undefined)
		{
			exp_member_type = document.getElementById('member_type'+no_info).value;
			exp_member_id = document.getElementById('member_id'+no_info).value;
			exp_company_id = document.getElementById('company_id'+no_info).value;
			exp_authorized = document.getElementById('authorized'+no_info).value;
			exp_company = document.getElementById('company'+no_info).value;
		}
		else
		{
			exp_member_type = '';
			exp_member_id = '';
			exp_company_id = '';
			exp_authorized = '';
			exp_company = '';
		}
		if(document.getElementById('project_id'+no_info) != undefined)
		{
			exp_project_id = document.getElementById('project_id'+no_info).value;
			exp_project = document.getElementById('project'+no_info).value;
		}
		else
		{
			exp_project_id = '';
			exp_project = '';
		}
		if(document.getElementById('asset_id'+no_info) != undefined)
		{
			exp_asset_id = document.getElementById('asset_id'+no_info).value;
			exp_asset = document.getElementById('asset'+no_info).value;
		}
		else
		{
			exp_asset_id = '';
			exp_asset = '';
		}
		if( document.getElementById('expense_date'+no_info) != undefined)
			exp_date = document.getElementById('expense_date'+no_info).value;
		else
			exp_date = '';
		if( document.getElementById('work_id'+no_info) != undefined)
		{
			row_work_id =  document.getElementById('work_id'+no_info).value;
			row_work_head =  document.getElementById('work_head'+no_info).value;
		}
		else
		{
			row_work_id = '';
			row_work_head = '';
		}	
		if( document.getElementById('opp_id'+no_info) != undefined)
		{
			exp_opp_id = document.getElementById('opp_id'+no_info).value; 
			exp_opp_head =  document.getElementById('opp_head'+no_info).value;
		}
		else
		{
			exp_opp_id = '';	
			exp_opp_head = '';
		}
		
		add_row(row_detail,exp_center,exp_item,activity,exp_stock_id,exp_product_id,exp_product_name,exp_stock_unit,exp_stock_unit_id,exp_tax_rate,exp_money_id,exp_date,exp_member_type,exp_member_id,exp_company_id,exp_authorized,exp_company,exp_project_id,exp_project,exp_asset_id,exp_asset,row_work_id,row_work_head,exp_opp_id,exp_opp_head,exp_center_name,exp_item_name);
	}
	</cfoutput>
	function add_kontrol()
	{
		if(!paper_control(add_costplan.paper_number,'EXPENDITURE_REQUEST')) return false;
		if(document.all.process_stage.value == "")
		{
			alert("<cf_get_lang_main no='564.Lütfen Süreçlerinizi Tanimlayiniz ve/veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'>!");
			return false;
		}
		if(document.getElementById('expense_date').value == "")
		{
			alert("<cf_get_lang no='1064.Lütfen Harcama Tarihi Giriniz'> !");
			return false;
		}
		if(document.getElementById('expense_employee').value == "")
		{
			alert("<cf_get_lang no='1062.Lütfen Ödeme Yapan Giriniz'>!");
			return false;
		}
		record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
		for(r=1;r<=add_costplan.record_num.value;r++)
		{
			deger_row_kontrol = document.getElementById('row_kontrol'+r);
			deger_expense_center_id = document.getElementById('expense_center_id'+r);
			deger_expense_item_id = document.getElementById('expense_item_id'+r);
			deger_total = document.getElementById('total'+r);
			deger_row_detail = document.getElementById('row_detail'+r);
			if(document.getElementById('work_head'+r) != undefined) work_name = document.getElementById('work_head'+r).value; else work_name = "";
			if(document.getElementById("project_id"+r) != undefined) deger_project = document.getElementById("project_id"+r).value;
			if(document.getElementById("project"+r) != undefined) project_name = document.getElementById("project"+r).value;
			if(document.getElementById("work_id"+r) != undefined) deger_work = document.getElementById("work_id"+r).value;
			
			if(deger_row_kontrol.value == 1)
			{
				record_exist=1;
				if (document.getElementById('expense_date'+r)!= undefined && document.getElementById('expense_date'+r).value == "")
				{ 
					alert ("<cf_get_lang_main no='810.Lütfen Tarih giriniz'>  !");
					return false;
				}		
				<cfif x_is_project_priority eq 1>
					if (deger_project == "" || project_name == "")
					{ 
						alert ("Lütfen Proje Seçiniz !");
						return false;
					}	
					var get_proje_ = wrk_safe_query("obj_get_project_period","dsn3","1",deger_project);
					var proje_record_ = get_proje_.recordcount;
					if(proje_record_<1 || get_proje_.EXPENSE_CENTER_ID =='' || get_proje_.EXPENSE_CENTER_ID==undefined)
					{
						alert("Proje Masraf Merkezi Bulunamadı!");
						return false;
					}
					else
					{
						document.getElementById("expense_center_id"+r).value = get_proje_.EXPENSE_CENTER_ID;
					}
					if(proje_record_<1 || get_proje_.EXPENSE_ITEM_ID =='' || get_proje_.EXPENSE_ITEM_ID==undefined)
					{
						alert("Proje Gider Kalemi Bulunamadı !");
						return false;
					}
					else
					{
						document.getElementById("expense_item_id"+r).value = get_proje_.EXPENSE_ITEM_ID;
					}			
				</cfif>		
				<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),2) and x_is_project_priority eq 0>
					if (deger_expense_center_id.value == "")
					{ 
						alert ("<cf_get_lang no='1069.Lütfen Masraf Merkezi Seçiniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
						return false;
					}
				</cfif>
				<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),3) and x_is_project_priority eq 0>
					if (deger_expense_item_id.value == "")
					{ 
						alert ("<cf_get_lang no='1071.Lütfen Gider Kalemi Seçiniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
						return false;
					}	
				</cfif>
				if (deger_row_detail.value == "")
				{ 
					alert ("<cf_get_lang no='1073.Lütfen Açıklama Giriniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
					return false;
				}	
				if (filterNum(deger_total.value) == 0 || deger_total.value == "")
				{ 
					alert ("<cf_get_lang_main no='1738.Lütfen Tutar giriniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
					return false;
				}
				if(document.getElementById("xml_select_project").value ==1) {		
					if (deger_project == "" || project_name == "")
					{ 
						alert ("Lütfen Proje Seçiniz !");
						return false;
					}	
				}	
				if(document.getElementById("xml_select_work").value ==1) {
					if (deger_work == "" || work_name == "")
					{ 
						alert ("Lutfen İş Seçiniz !");
						return false;
					}
				}					
			}
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang no='1432.Lütfen Satır Ekleyiniz'>");
			return false;
		}
		unformat_fields();
		process_cat_control();
		return true;
	}
	<cfif x_is_show_paymethod eq 1>
		change_due_date();
	</cfif>
	function change_due_date(type)
	{
		if (type==1)
			document.getElementById("basket_due_value").value = datediff(document.getElementById("expense_date").value,document.getElementById("basket_due_value_date_").value,0);
		else
		{
			if(isNumber(document.getElementById("basket_due_value"))!= false && (document.getElementById("basket_due_value").value != 0))
				document.getElementById("basket_due_value_date_").value = date_add('d',+document.getElementById("basket_due_value").value,document.getElementById("expense_date").value);
			else
				document.getElementById("basket_due_value_date_").value = document.getElementById("expense_date").value;
		}
	}
	<cfoutput>
		function other_calc(row_info,type_info)
		{
			if(row_info != undefined)
			{
				if(document.getElementById('row_kontrol'+row_info).value==1)
				{
					deger_money_id = list_getat(document.getElementById('money_id'+row_info).value,1,',');
					for(kk=1;kk<=document.add_costplan.kur_say.value;kk++)
					{
						money_deger =list_getat(document.add_costplan.rd_money[kk-1].value,1,',');
						if(money_deger == deger_money_id)
						{
							deger_diger_para_satir = document.add_costplan.rd_money[kk-1];
							form_value_rate_satir = document.getElementById('txt_rate2_'+kk);
						}
					}
					if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#session.ep.our_company_info.rate_round_num#');
					if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = document.getElementById("other_net_total"+row_info).value*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
					if(document.getElementById("other_net_total"+row_info) != undefined ) document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#session.ep.our_company_info.rate_round_num#');
					if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#session.ep.our_company_info.rate_round_num#');
				}
				if(type_info==undefined)
					hesapla('other_net_total',row_info,2);
				else
					hesapla('other_net_total',row_info,2,type_info);
				/*
				if(type_info==undefined)
					hesapla(row_info,2);
				else
					hesapla(row_info,2,type_info);
				*/
			}
			else
			{
				for(yy=1;yy<=document.add_costplan.record_num.value;yy++)
				{	
					if(document.getElementById('row_kontrol'+yy).value==1)
					{
						other_calc(yy,1);
					}
				}
				toplam_hesapla();
			}
		}
		function pencere_ac_exp(no)
		{
			windowopen('#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=all.expense_center_id' + no +'&field_name=all.expense_center_name' + no,'list');
		}
		function pencere_ac_item(no,inc)
		{
			if(inc == 1) inc_ = "&is_income=1"; else inc_ = "";
			windowopen('#request.self#?fuseaction=objects.popup_list_exp_item&field_id=all.expense_item_id' + no +'&field_name=all.expense_item_name' + no + inc_,'list');
		}
	</cfoutput>
<cfelseif (isdefined("attributes.event") and attributes.event is 'upd')>
	row_count=<cfoutput>#get_rows.recordcount#</cfoutput>;
	function sil(sy)
	{
		eval("add_costplan.row_kontrol"+sy).value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
		toplam_hesapla();
	}
	function copy_row(no_info)
	{
		if(document.getElementById('no_info'+no_info) != undefined)
			row_detail = document.getElementById('row_detail'+no_info).value;
		else
			row_detail = '';
			
		if(document.getElementById('expense_center_id'+no_info) != undefined)
			exp_center = document.getElementById('expense_center_id'+no_info).value;
		else
			exp_center = '';
			
		<cfif xml_expense_center_is_popup eq 1>
			if(document.getElementById('expense_center_name'+no_info) != undefined)
				exp_center_name = document.getElementById('expense_center_name'+no_info).value;
			else
				exp_center_name = '';
		<cfelse>
			exp_center_name = '';
		</cfif>
			
		if(document.getElementById('expense_item_id'+no_info) != undefined)
			exp_item = document.getElementById('expense_item_id'+no_info).value;
		else
			exp_item = '';
			
		<cfif xml_expense_center_is_popup eq 1>
			if(document.getElementById('expense_item_name'+no_info) != undefined)
				exp_item_name = document.getElementById('expense_item_name'+no_info).value;
			else
				exp_item_name = '';
		<cfelse>
			exp_item_name = '';
		</cfif>
			
		if(document.getElementById('activity_type'+no_info) != undefined)
			activity = document.getElementById('activity_type'+no_info).value;
		else
			activity = '';
		if(document.getElementById('stock_id'+no_info) != undefined)
		{
			exp_stock_id = document.getElementById('stock_id'+no_info).value;  
			exp_product_id = document.getElementById('product_id'+no_info).value;
			exp_product_name = document.getElementById('product_name'+no_info).value;
		}
		else
		{
			exp_stock_id = '';
			exp_product_id = '';
			exp_product_name = '';
		}
		if (document.getElementById('stock_unit' + no_info) == undefined) exp_stock_unit =""; else exp_stock_unit = document.getElementById('stock_unit' + no_info).value;
		if (document.getElementById('stock_unit_id' + no_info) == undefined) exp_stock_unit_id =""; else exp_stock_unit_id = document.getElementById('stock_unit_id' + no_info).value;
		if(document.getElementById('tax_rate'+no_info) != undefined)
			exp_tax_rate = document.getElementById('tax_rate'+no_info).value; 
		else
		{
			exp_tax_rate = '';
		}
		exp_money_id = document.getElementById('money_id'+no_info).value;
		if(document.getElementById('member_type'+no_info) != undefined)
		{
			exp_member_type = document.getElementById('member_type'+no_info).value;
			exp_member_id = document.getElementById('member_id'+no_info).value;
			exp_company_id = document.getElementById('company_id'+no_info).value;
			exp_authorized = document.getElementById('authorized'+no_info).value;
			exp_company = document.getElementById('company'+no_info).value;
		}
		else
		{
			exp_member_type = '';
			exp_member_id = '';
			exp_company_id = '';
			exp_authorized = '';
			exp_company = '';
		}
		if(document.getElementById('project_id'+no_info) != undefined)
		{
			exp_project_id = document.getElementById('project_id'+no_info).value;
			exp_project = document.getElementById('project'+no_info).value;
		}
		else
		{
			exp_project_id = '';
			exp_project = '';
		}
		if(document.getElementById('asset_id'+no_info) != undefined)
		{
			exp_asset_id = document.getElementById('asset_id'+no_info).value;
			exp_asset = document.getElementById('asset'+no_info).value;
		}
		else
		{
			exp_asset_id = '';
			exp_asset = '';
		}
		if( document.getElementById('expense_date'+no_info) != undefined)
			exp_date = document.getElementById('expense_date'+no_info).value;
		else
			exp_date = '';
		if( document.getElementById('work_id'+no_info) != undefined)
		{
			row_work_id =  document.getElementById('work_id'+no_info).value;
			row_work_head =  document.getElementById('work_head'+no_info).value;
		}
		else
		{
			row_work_id = '';
			row_work_head = '';
		}	
		if( document.getElementById('opp_id'+no_info) != undefined)
		{
			exp_opp_id = document.getElementById('opp_id'+no_info).value; 
			exp_opp_head =  document.getElementById('opp_head'+no_info).value;
		}
		else
		{
			exp_opp_id = '';	
			exp_opp_head = '';
		}
		
		add_row(row_detail,exp_center,exp_item,activity,exp_stock_id,exp_product_id,exp_product_name,exp_stock_unit,exp_stock_unit_id,exp_tax_rate,exp_money_id,exp_date,exp_member_type,exp_member_id,exp_company_id,exp_authorized,exp_company,exp_project_id,exp_project,exp_asset_id,exp_asset,row_work_id,row_work_head,exp_opp_id,exp_opp_head,exp_center_name,exp_item_name);
	}
	function add_row(row_detail,exp_center,exp_item,activity,exp_stock_id,exp_product_id,exp_product_name,exp_stock_unit,exp_stock_unit_id,exp_tax_rate,exp_money_id,expense_date,exp_member_type,exp_member_id,exp_company_id,exp_authorized,exp_company,exp_project_id,exp_project,exp_asset_id,exp_asset,row_work_id,row_work_head,exp_opp_id,exp_opp_head,exp_center_name,exp_item_name)
	{
		//Normal satır eklerken değişkenler olmadığı için boşluk atıyor,kopyalarken değişkenler geliyor
		if (row_detail == undefined)row_detail ="";
		if (exp_center == undefined){exp_center =""; exp_center_name="";}
		if (exp_item == undefined){exp_item =""; exp_item_name="";}
		if (activity == undefined)activity ="";
		if (exp_member_type == undefined)exp_member_type ="";
		if (exp_member_id == undefined)exp_member_id ="";
		if (exp_company_id == undefined)exp_company_id ="";
		if (exp_authorized == undefined)exp_authorized ="";
		if (exp_company == undefined)exp_company ="";
		if (exp_stock_id == undefined)exp_stock_id ="";
		if (exp_product_id == undefined)exp_product_id ="";
		if (exp_product_name == undefined)exp_product_name ="";
		if (exp_stock_unit == undefined)exp_stock_unit ="";
		if (exp_stock_unit_id == undefined) exp_stock_unit_id ="";
		if (exp_project_id == undefined)exp_project_id ="";
		if (exp_project == undefined)exp_project ="";
		if (expense_date == undefined)expense_date = document.getElementById("expense_date").value;
		if (exp_asset_id == undefined)exp_asset_id ="";
		if (exp_asset == undefined)exp_asset ="";
		if (exp_tax_rate == undefined)exp_tax_rate ="0";
		if (exp_money_id == undefined)exp_money_id ="";
		if (row_work_id == undefined) row_work_id ="";
		if (row_work_head == undefined) row_work_head ="";
		if (exp_opp_id == undefined) exp_opp_id ="";
		if (exp_opp_head == undefined) exp_opp_head ="";
		
		rate_round_num_ = "<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>";
		if(rate_round_num_ == "") rate_round_num_ = "2";
		
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		newRow.className = 'color-row';
		document.add_costplan.record_num.value=row_count;
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a><a style="cursor:pointer" onclick="copy_row('+row_count+');" title="<cf_get_lang_main no='1560.Satır Kopyala'>"><img  src="images/copy_list.gif" border="0"></a>';
		<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),3) or x_is_project_priority eq 1>
			newCell.innerHTML += '<input type="hidden" name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" value="'+exp_center+'"><input type="hidden" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" value="'+exp_center+'">';
		</cfif>
		<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),4) or x_is_project_priority eq 1>
			newCell.innerHTML += '<input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+exp_item+'"><input type="hidden" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item+'">';
		</cfif>
		<cfif not ListFind(ListDeleteDuplicates(xml_order_list_rows),7)>
			newCell.innerHTML += '<input type="hidden" name="quantity' + row_count +'" id="quantity' + row_count +'" value="'+1+'">';
		</cfif>
		<cfloop list="#ListDeleteDuplicates(xml_order_list_rows)#" index="xlr">
			<cfswitch expression="#xlr#">
				<cfcase value="1">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.setAttribute("id","expense_date" + row_count + "_td");
					newCell.innerHTML = '<input type="text" name="expense_date' + row_count +'" id="expense_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="' +expense_date +'"> ';
					wrk_date_image('expense_date' + row_count);
				</cfcase>
				<cfcase value="2">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count +'" style="width:140px;" class="boxtext" value="'+row_detail+'">';
				</cfcase>
				<cfcase value="3">
					<cfif x_is_project_priority eq 0>
						<cfif xml_expense_center_is_popup eq 1>
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							newCell.innerHTML ='<input type="hidden" name="expense_center_id' + row_count +'" id="expense_center_id' + row_count +'" value="'+exp_center+'"><input type="text" id="expense_center_name' + row_count +'" name="expense_center_name' + row_count +'" onFocus="AutoComplete_Create(\'expense_center_name' + row_count +'\',\'EXPENSE,EXPENSE_CODE\',\'EXPENSE,EXPENSE_CODE\',\'get_expense_center\',\'0\',\'EXPENSE_ID\',\'expense_center_id' + row_count +'\',\'add_costplan\',1);" value="'+exp_center_name+'" style="width:184px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_exp('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
						<cfelse>
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							a = '<select name="expense_center_id' + row_count  +'" id="expense_center_id' + row_count  +'" style="width:200px;" class="boxtext"><option value=""><cf_get_lang_main no='1048.Masraf Merkezi'></option>';
							<cfoutput query="get_expense_center">
								if('#expense_id#' == exp_center)
									a += '<option value="#expense_id#" selected>#expense#</option>';
								else
									a += '<option value="#expense_id#">#expense#</option>';
							</cfoutput>
							newCell.innerHTML =a+ '</select>';
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="4">
					<cfif x_is_project_priority eq 0>
						<cfif xml_expense_center_is_popup eq 1>
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							newCell.innerHTML ='<input type="hidden" name="expense_item_id' + row_count +'" id="expense_item_id' + row_count +'" value="'+exp_item+'"><input type="text" id="expense_item_name' + row_count +'" name="expense_item_name' + row_count +'" value="'+exp_item_name+'" style="width:233px;" onFocus="AutoComplete_Create(\'expense_item_name' + row_count +'\',\'EXPENSE_ITEM_NAME\',\'EXPENSE_ITEM_NAME\',\'get_expense_item\',\'<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>\',\'EXPENSE_ITEM_ID,ACCOUNT_CODE,TAX_CODE\',\'expense_item_id' + row_count +',account_code' + row_count +',tax_code' + row_count +'\',\'add_costplan\',1);"  class="boxtext"><a href="javascript://" onClick="pencere_ac_item('+ row_count +',<cfif isDefined("is_income") and is_income eq 1>1<cfelse>0</cfif>);"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
						<cfelse>
							newCell = newRow.insertCell(newRow.cells.length);
							newCell.setAttribute("nowrap","nowrap");
							a = '<select name="expense_item_id' + row_count  +'" id="expense_item_id' + row_count  +'" style="width:200px;" class="boxtext"><option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option>';
							<cfoutput query="get_expense_item">
								if('#expense_item_id#' == exp_item)
									a += '<option value="#expense_item_id#" selected>#expense_item_name#</option>';
								else
									a += '<option value="#expense_item_id#">#expense_item_name#</option>';
							</cfoutput>
							newCell.innerHTML =a+ '</select>';
						</cfif>
					</cfif>
				</cfcase>
				<cfcase value="5">	
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input  type="hidden" name="product_id' + row_count +'" id="product_id' + row_count +'" value="'+exp_product_id+'"><input  type="hidden" name="stock_id' + row_count +'" id="stock_id' + row_count +'" value="'+exp_stock_id+'"><input type="text" name="product_name' + row_count +'" id="product_name' + row_count +'" class="boxtext" onFocus="AutoComplete_Create(\'product_name'+ row_count +'\',\'PRODUCT_NAME\',\'PRODUCT_NAME\',\'get_product\',\'0\',\'STOCK_ID,PRODUCT_ID,PRODUCT_NAME\',\'stock_id' + row_count +',product_id' + row_count +',product_name'+ row_count +'\',\'\',3,150);" maxlength="50" style="width:150px;" <!--- onFocus="hesapla(' + row_count +');"  --->value="'+exp_product_name+'">';
					newCell.innerHTML += '<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=all.product_id" + row_count + "&field_id=all.stock_id" + row_count + "&field_product_cost=all.total"+row_count +"&field_unit_name= all.stock_unit"+row_count +"&field_unit= all.stock_unit_id"+row_count+"&run_function=hesapla&run_function_param="+row_count+"&expense_date='+document.all.expense_date.value+'&field_name=all.product_name" + row_count + "','list');"+'"><img src="/images/plus_thin.gif" border="0" align="absbottom"></a>';
					newCell.innerHTML += '<a href="javascript://" onClick="windowopen('+"'<cfoutput>#request.self#?fuseaction=objects.popup_detail_product</cfoutput>&pid='+document.getElementById('product_id"+row_count+"').value+'&sid='+document.getElementById('stock_id"+row_count+"').value+'','list');"+'"><img src="/images/plus_thin_p.gif" border="0" align="absbottom" alt="<cf_get_lang no="458.Ürün Detay">" style="display:none;" id="product_info'+row_count+'"></a>';
				</cfcase>
				<cfcase value="6">	
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="stock_unit_id' + row_count +'" id="stock_unit_id' + row_count +'" value="'+exp_stock_unit_id+'"><input type="text" name="stock_unit' + row_count +'" id="stock_unit' + row_count +'"  value="'+exp_stock_unit+'" style="width:90px;" class="boxtext" readonly>';
				</cfcase>
				<cfcase value="7">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="quantity' + row_count +'" id="quantity' + row_count +'" style="width:90px;" class="box" value="'+ commaSplit(1,rate_round_num_)+ '" onBlur="hesapla(\'quantity\',' + row_count +');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));">';
				</cfcase>
				<cfcase value="8">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="total' + row_count +'"  id="total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;" onBlur="hesapla(\'total\',' + row_count +');" class="box">';
				</cfcase>
				<cfcase value="9">
					newCell = newRow.insertCell(newRow.cells.length);
					xx = '<select name="tax_rate'+ row_count +'" id="tax_rate'+ row_count +'" style="width:100%;" class="box" onChange="hesapla(\'tax_rate\','+ row_count +');">';
					<cfoutput query="get_tax">
					if('#tax#' == exp_tax_rate)
						xx += '<option value="#tax#" selected>#tax#</option>';
					else
						xx += '<option value="#tax#">#tax#</option>';
					</cfoutput>
					newCell.innerHTML =xx + '</select>';
				</cfcase>
				<cfcase value="10">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="kdv_total'+ row_count +'" id="kdv_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;;" onBlur="hesapla(\'kdv_total\',' + row_count +',1);" class="box">';
				</cfcase>
				<cfcase value="11">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="net_total' + row_count +'" id="net_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;;" onBlur="hesapla(\'net_total\',' + row_count +',2);" class="box">';
				</cfcase>
				<cfcase value="12">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					yy = '<select name="money_id' + row_count  +'" id="money_id' + row_count  +'" style="width:60px;" class="boxtext" onChange="other_calc('+ row_count +');">';
					<cfoutput query="get_money">
						if('#money#,#rate1#,#rate2#' == exp_money_id)
							yy += '<option value="#money#,#rate1#,#rate2#" selected>#money#</option>';
						else
							yy += '<option value="#money#,#rate1#,#rate2#">#money#</option>';
					</cfoutput>
					newCell.innerHTML =yy+ '</select>';
				</cfcase>
				<cfcase value="13">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="text" name="other_net_total' + row_count +'" id="other_net_total' + row_count +'" value="0" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>));" style="width:90px;" class="box" onBlur="other_calc('+row_count+',2);">';
				</cfcase>
				<cfcase value="14">	
					newCell = newRow.insertCell(newRow.cells.length);
					a = '<select name="activity_type' + row_count  +'" id="activity_type' + row_count  +'" style="width:90px;" class="boxtext"><option value=""><cf_get_lang no='777.Aktivite Tipi'></option>';
					<cfoutput query="get_activity_types">
						if('#activity_id#' == activity)
							a += '<option value="#activity_id#" selected>#activity_name#</option>';
						else
							a += '<option value="#activity_id#">#activity_name#</option>';
					</cfoutput>
					newCell.innerHTML =a+ '</select>';
				</cfcase>
				<cfcase value="15">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="work_id' + row_count +'" id="work_id'+ row_count +'" value="'+row_work_id+'"><input type="text" name="work_head' + row_count +'" id="work_head'+ row_count +'" value="'+row_work_head+'" onFocus="AutoComplete_Create(\'work_head'+ row_count +'\',\'WORK_HEAD\',\'WORK_HEAD\',\'get_work\',\'\',\'WORK_ID\',\'work_id'+ row_count +'\',\'\',3,200,\'\');" style="width:139px;" class="boxtext">';
					newCell.innerHTML +='<a href="javascript://" onClick="pencere_ac_work('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
				</cfcase>
				<cfcase value="16">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="opp_id' + row_count +'" id="opp_id'+ row_count +'" value="'+exp_opp_id+'"><input type="text" name="opp_head' + row_count +'" id="opp_head'+ row_count +'" value="'+exp_opp_head+'" onFocus="AutoComplete_Create(\'opp_head'+ row_count +'\',\'OPP_HEAD\',\'OPP_HEAD\',\'get_opportunity\',\'\',\'OPP_ID\',\'opp_id'+ row_count +'\',\'\',3,200,\'\');" style="width:110px;" class="boxtext"><a href="javascript://" onClick="pencere_ac_oppotunity('+ row_count +');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>';
				</cfcase>
				<cfcase value="17">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="member_type'+ row_count +'" id="member_type'+ row_count +'" value="'+exp_member_type+'"><input type="hidden" name="member_id'+ row_count +'" id="member_id'+ row_count +'" value="'+exp_member_id+'"><input type="hidden" name="company_id'+ row_count +'" id="company_id'+ row_count +'" value="'+exp_company_id+'"><input type="text" style="width:110px;" name="authorized'+ row_count +'" id="authorized'+ row_count +'" value="'+exp_authorized+'" class="boxtext" onFocus="auto_company('+ row_count +');" autocomplete="off">&nbsp;<input type="text" name="company'+ row_count +'" id="company'+ row_count +'" value="'+exp_company+'"  style="width:110px;" class="boxtext" readonly><a href="javascript://" onClick="pencere_ac_company('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
				</cfcase>
				<cfcase value="18">
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="asset_id'+ row_count +'" id="asset_id'+ row_count +'" value="'+exp_asset_id+'"><input type="text" name="asset'+ row_count +'" id="asset'+ row_count +'" value="'+exp_asset+'" style="width:120px;" class="boxtext" onFocus="autocomp_assetp('+ row_count +');"><a href="javascript://" onClick="pencere_ac_asset('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
				</cfcase>
				<cfcase value="19">	
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.setAttribute("nowrap","nowrap");
					newCell.innerHTML = '<input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value="'+exp_project_id+'"><input type="text" name="project'+ row_count +'" id="project'+ row_count +'" value="'+exp_project+'" style="width:120px;" class="boxtext" onFocus="AutoComplete_Create(\'project'+ row_count +'\',\'PROJECT_HEAD\',\'PROJECT_HEAD\',\'get_project\',\'\',\'PROJECT_ID\',\'project_id'+ row_count +'\',\'\',3,200,\'\');"><a href="javascript://" onClick="pencere_ac_project('+ row_count +');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
				</cfcase>
			</cfswitch>
		</cfloop>
	}
	function autocomp_assetp(no)
	{
		<cfif isdefined("xml_exp_center_from_assetp") and xml_exp_center_from_assetp eq 1>
			AutoComplete_Create('asset'+ row_count +'','ASSETP','ASSETP','get_assetp_autocomplete','\'\',1','ASSETP_ID,EMPLOYEE_ID,EMP_NAME,MEMBER_TYPE,EXPENSE_CENTER_ID,EXPENSE_CODE_NAME','asset_id'+no+',member_id'+no+',authorized'+no+',member_type'+no+',expense_center_id'+no+'','',3,130);
		<cfelse>
			AutoComplete_Create('asset'+ row_count +'','ASSETP','ASSETP','get_assetp_autocomplete','','ASSETP_ID','asset_id'+no+'',3,130);
		</cfif>
	}
	function auto_company(no)
	{
		AutoComplete_Create('authorized'+no,'MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','MEMBER_TYPE,PARTNER_ID2,COMPANY_ID,MEMBER_NAME2','member_type'+no+',member_id'+no+',company_id'+no+',company'+no+'','','3','250');
	}
	function pencere_ac_oppotunity(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_opportunities&field_opp_id=all.opp_id' + no +'&field_opp_head=all.opp_head' + no ,'list');
	}
	function pencere_detail_work(no)
	{	
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=project.popup_updwork&id='+eval("document.all.work_id"+no).value,'list');
	}
	function pencere_ac_work(no)
	{
		p_id_ = document.getElementById("project_id" + no).value;
		p_name_ = document.getElementById("project" + no).value;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=all.work_id' + no +'&field_name=all.work_head' + no +'&project_id=' + p_id_ + '&project_head=' + p_name_ +'&field_pro_id=all.project_id' +no + '&field_pro_name=all.project' +no,'list');
	}
	function pencere_ac_company(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=all.member_id' + no +'&field_emp_id=all.member_id' + no +'&field_comp_name=all.company' + no +'&field_name=all.authorized' + no +'&field_comp_id=all.company_id' + no + '&field_type=all.member_type' + no + '&select_list=1,2,3,5,6','list');
	}
	function pencere_ac_asset(no)
	{
		adres = '<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_list_assetps';
		adres += '&field_id=all.asset_id' + no +'&field_name=all.asset' + no +'&event_id=0&motorized_vehicle=0';
		<cfif x_is_add_position_to_asset_list eq 1>
			adres += '&member_type=all.member_type' + no;
			adres += '&employee_id=all.member_id' + no;
			adres += '&position_employee_name=all.authorized' + no;	
		</cfif>
		<cfif isdefined("xml_exp_center_from_assetp") and xml_exp_center_from_assetp eq 1>
			adres += '&exp_center_id=all.expense_center_id' + no;	
		</cfif>
		windowopen(adres,'list');
	}
	function pencere_ac_project(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=all.project_id' + no +'&project_head=all.project' + no,'list');
	}
	function pencere_ac_campaign(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_campaigns&field_id=all.campaign_id' + no +'&field_name=all.campaign' + no,'list');
	}
	<cfoutput>
	function hesapla(field_name,satir,hesap_type,extra_type)
	{
		if(satir == undefined)
		{
			satir = field_name;
			field_name = 'total';
		}
		if(field_name != '' && field_name != 'product_id' && field_name != 'product_name')
		{
			var input_name_ = field_name+satir;
			field_changed_value = filterNum(document.getElementById(input_name_).value,'#session.ep.our_company_info.rate_round_num#');
		}
		else
			field_changed_value = '-1';
		if(field_changed_value == '-1' || document.getElementById("control_field_value") == undefined || (document.getElementById("control_field_value") != undefined && field_changed_value != document.getElementById("control_field_value").value))
		{
			var toplam_dongu_0 = 0;//satir toplam
			if(document.getElementById('row_kontrol'+satir).value==1)
			{
				deger_total = document.getElementById('total'+satir);//tutar
				deger_kdv_total= document.getElementById('kdv_total'+satir);//kdv tutarı
				deger_net_total = document.getElementById('net_total'+satir);//kdvli tutar
				deger_tax_rate = document.getElementById('tax_rate'+satir);//kdv oranı
				if(document.getElementById('quantity'+satir) != undefined) 
					deger_quantity =  document.getElementById('quantity'+satir).value; 
				else 
					deger_quantity ="";//miktar
				if(document.getElementById("other_net_total"+satir) != undefined) deger_other_net_total = document.getElementById("other_net_total"+satir); else deger_other_net_total="";//dovizli tutar kdv dahil
				if(deger_total.value == "") deger_total.value = 0;
				if(deger_kdv_total.value == "") deger_kdv_total.value = 0;
				if(deger_net_total.value == "") deger_net_total.value = 0;
				deger_money_id = document.getElementById('money_id'+satir);
				deger_money_id =  list_getat(deger_money_id.value,1,',');
				for(s=1;s<=add_costplan.kur_say.value;s++)
				{
					money_deger =list_getat(add_costplan.rd_money[s-1].value,1,',');
					if(money_deger == deger_money_id)
					{
						deger_diger_para_satir = document.add_costplan.rd_money[s-1];
						form_value_rate_satir = document.getElementById('txt_rate2_'+s);
					}
				}
				deger_para_satir = list_getat(deger_diger_para_satir.value,3,',');
				deger_total.value = filterNum(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
				if(deger_quantity != "") deger_quantity = filterNum(deger_quantity,'#session.ep.our_company_info.rate_round_num#'); else deger_quantity = 1;
				deger_kdv_total.value = filterNum(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_net_total.value = filterNum(deger_net_total.value,'#session.ep.our_company_info.rate_round_num#');
				if(document.getElementById('other_net_total'+satir) != undefined)
					deger_other_net_total.value = filterNum(deger_other_net_total.value,'#session.ep.our_company_info.rate_round_num#');
				if(hesap_type == undefined)
				{
					if(deger_kdv_total != "" && deger_total != "") deger_kdv_total.value = (parseFloat(deger_total.value) * parseFloat(deger_quantity) * deger_tax_rate.value)/100;
				}
				else if(hesap_type == 2)
				{
					deger_total.value = ((parseFloat(deger_net_total.value)/ parseFloat(deger_quantity))*100) / (parseFloat(deger_tax_rate.value)+100);
					deger_kdv_total.value = (parseFloat(deger_total.value * deger_quantity * deger_tax_rate.value))/100;
				}
				toplam_dongu_0 = parseFloat(deger_total.value * deger_quantity);
				if(deger_kdv_total != "") toplam_dongu_0 = toplam_dongu_0 + parseFloat(deger_kdv_total.value);
				//if(document.getElementById('other_net_total'+satir) != undefined) deger_other_net_total.value = ((parseFloat(deger_total.value) + parseFloat(deger_kdv_total.value)) * parseFloat(deger_para_satir) / (parseFloat(form_value_rate_satir.value)));
				if(extra_type != 2)
					if(deger_other_net_total != "") deger_other_net_total.value = ((toplam_dongu_0) * parseFloat(deger_para_satir) / (parseFloat(form_value_rate_satir.value)));
				deger_net_total.value = commaSplit(toplam_dongu_0,'#session.ep.our_company_info.rate_round_num#');
				deger_total.value = commaSplit(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_quantity = commaSplit(deger_quantity,'#session.ep.our_company_info.rate_round_num#');
				
				deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
				if(document.getElementById('other_net_total'+satir) != undefined)
					deger_other_net_total.value = commaSplit(deger_other_net_total.value,'#session.ep.our_company_info.rate_round_num#');
			}
			if(extra_type == 2 || extra_type == undefined)
				toplam_hesapla(extra_type);
		}
	}
	function toplam_hesapla(type)
	{
		var toplam_dongu_1 = 0;//tutar genel toplam
		var toplam_dongu_2 = 0;// kdv genel toplam
		var toplam_dongu_3 = 0;// kdvli genel toplam
		if(type != 2)
			doviz_hesapla();
		for(r=1;r<=add_costplan.record_num.value;r++)
		{
			if(document.getElementById('row_kontrol'+r).value==1)
			{
				deger_total = document.getElementById('total'+r);//tutar
				deger_quantity =  document.getElementById('quantity'+r).value; //miktar
				deger_kdv_total= document.getElementById('kdv_total'+r);//kdv tutarı
				deger_net_total = document.getElementById('net_total'+r);//kdvli tutar
				deger_tax_rate = document.getElementById('tax_rate'+r);//kdv oranı
				if(document.getElementById('other_net_total'+r) != undefined) deger_other_net_total = document.getElementById('other_net_total'+r); else deger_other_net_total="";//dovizli tutar kdv dahil
				deger_total.value = filterNum(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_quantity = filterNum(deger_quantity,'#session.ep.our_company_info.rate_round_num#');
				deger_kdv_total.value = filterNum(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_net_total.value = filterNum(deger_net_total.value,'#session.ep.our_company_info.rate_round_num#');
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value * deger_quantity);
				toplam_dongu_2 = toplam_dongu_2 + parseFloat(deger_kdv_total.value);
				toplam_dongu_3 = toplam_dongu_3 + (parseFloat(deger_total.value * deger_quantity) + parseFloat(deger_kdv_total.value));
				deger_net_total.value = commaSplit(deger_net_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_quantity = commaSplit(deger_quantity,'#session.ep.our_company_info.rate_round_num#');
				deger_total.value = commaSplit(deger_total.value,'#session.ep.our_company_info.rate_round_num#');
				deger_kdv_total.value = commaSplit(deger_kdv_total.value,'#session.ep.our_company_info.rate_round_num#');
			}
		}
		document.add_costplan.total_amount.value = commaSplit(toplam_dongu_1,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.kdv_total_amount.value = commaSplit(toplam_dongu_2,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.net_total_amount.value = commaSplit(toplam_dongu_3,'#session.ep.our_company_info.rate_round_num#');
		for(s=1;s<=add_costplan.kur_say.value;s++)
		{
			form_txt_rate2_ = document.getElementById('txt_rate2_'+s);
			if(form_txt_rate2_.value == "")
				form_txt_rate2_.value = 1;
		}
		if(add_costplan.kur_say.value == 1)
			for(s=1;s<=add_costplan.kur_say.value;s++)
			{
				if(document.add_costplan.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_costplan.rd_money;
					form_txt_rate2_ = document.getElementById('txt_rate2_'+s);
				}
			}
		else 
			for(s=1;s<=add_costplan.kur_say.value;s++)
			{
				if(document.add_costplan.rd_money[s-1].checked == true)
				{
					deger_diger_para = document.add_costplan.rd_money[s-1];
					form_txt_rate2_ = document.getElementById('txt_rate2_'+s);
				}
			}
		deger_money_id_1 = list_getat(deger_diger_para.value,1,',');
		deger_money_id_2 = list_getat(deger_diger_para.value,2,',');
		deger_money_id_3 = list_getat(deger_diger_para.value,3,',');
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_total_amount.value = commaSplit(toplam_dongu_1 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_kdv_total_amount.value = commaSplit(toplam_dongu_2 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_net_total_amount.value = commaSplit(toplam_dongu_3 * parseFloat(deger_money_id_3) / (parseFloat(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#')),'#session.ep.our_company_info.rate_round_num#');
	
		document.add_costplan.tl_value1.value = deger_money_id_1;
		document.add_costplan.tl_value2.value = deger_money_id_1;
		document.add_costplan.tl_value3.value = deger_money_id_1;
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'#session.ep.our_company_info.rate_round_num#');
	}
	function doviz_hesapla()
	{
		for(k=1;k<=add_costplan.record_num.value;k++)
		{		
			deger_money_id = document.getElementById('money_id'+k);
			deger_money_id =  list_getat(deger_money_id.value,1,',');
			for (var t=1; t<=add_costplan.kur_say.value; t++)
			{
			money_deger =list_getat(add_costplan.rd_money[t-1].value,1,',');
			if(money_deger == deger_money_id)	
				{		
					rate2_value = filterNum(document.getElementById('txt_rate2_'+t).value,'#session.ep.our_company_info.rate_round_num#')/filterNum(document.getElementById("txt_rate1_"+t).value,'#session.ep.our_company_info.rate_round_num#');
					if(document.getElementById('other_net_total'+k) != undefined)
						document.getElementById('other_net_total'+k).value = commaSplit(filterNum(document.getElementById('net_total'+k).value,'#session.ep.our_company_info.rate_round_num#')/rate2_value,'#session.ep.our_company_info.rate_round_num#');
				}
			}
		}
	}
	record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
	row_count_ilk = row_count;
	function unformat_fields()
	{
		for(r=1;r<=add_costplan.record_num.value;r++)
		{
			document.getElementById('total'+r).value = filterNum(document.getElementById('total'+r).value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('kdv_total'+r).value = filterNum(document.getElementById('kdv_total'+r).value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('net_total'+r).value = filterNum(document.getElementById('net_total'+r).value,'#session.ep.our_company_info.rate_round_num#');
			if(document.getElementById('other_net_total'+r) != undefined)
				document.getElementById('other_net_total'+r).value = filterNum(document.getElementById('other_net_total'+r).value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('quantity'+r).value = filterNum(document.getElementById('quantity'+r).value,'#session.ep.our_company_info.rate_round_num#');	
		}
		document.add_costplan.total_amount.value = filterNum(document.add_costplan.total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.kdv_total_amount.value = filterNum(document.add_costplan.kdv_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.net_total_amount.value = filterNum(document.add_costplan.net_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_total_amount.value = filterNum(document.add_costplan.other_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_kdv_total_amount.value = filterNum(document.add_costplan.other_kdv_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		document.add_costplan.other_net_total_amount.value = filterNum(document.add_costplan.other_net_total_amount.value,'#session.ep.our_company_info.rate_round_num#');
		
		for(s=1;s<=add_costplan.kur_say.value;s++)
		{
			document.getElementById('txt_rate2_'+s).value = filterNum(document.getElementById('txt_rate2_'+s).value,'#session.ep.our_company_info.rate_round_num#');
			document.getElementById('txt_rate1_'+s).value = filterNum(document.getElementById('txt_rate1_'+s).value,'#session.ep.our_company_info.rate_round_num#');
		}
		<cfif not (browserdetect() contains 'MSIE') or (browserdetect() contains 'MSIE' and browserdetect() contains '9.')>
			for(i=1;i<=document.all.record_num.value;i++)
			{
				var satir_ = i;
				document.add_costplan.appendChild(eval("document.all.row_kontrol" + satir_));
				document.add_costplan.appendChild(eval("document.all.row_detail" + satir_));
				document.add_costplan.appendChild(eval("document.all.expense_center_id" + satir_));
				document.add_costplan.appendChild(eval("document.all.expense_item_id" + satir_));
				if(document.getElementById('product_id'+satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.product_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.stock_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.product_name" + satir_));
				}
				if(document.getElementById('stock_unit'+satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.stock_unit" + satir_));
					document.add_costplan.appendChild(eval("document.all.stock_unit_id" + satir_));
				}
				document.add_costplan.appendChild(eval("document.all.quantity" + satir_));
				if(document.getElementById('total'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.total" + satir_));
				if(document.getElementById('tax_rate'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.tax_rate" + satir_));
				if(document.getElementById('kdv_total'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.kdv_total" + satir_));
				if(document.getElementById('net_total'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.net_total" + satir_));
				if(document.getElementById('money_id'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.money_id" + satir_));
				if(document.getElementById('other_net_total'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.other_net_total" + satir_));
				if(document.getElementById('activity_type'+satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.activity_type" + satir_));
				if(document.getElementById('member_type'+satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.member_type" + satir_));
					document.add_costplan.appendChild(eval("document.all.member_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.company_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.authorized" + satir_));
					document.add_costplan.appendChild(eval("document.all.company" + satir_));
				}
				if(document.getElementById('asset_id'+satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.asset_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.asset" + satir_));
				}
				if(document.getElementById('project_id'+satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.project_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.project" + satir_));
				}
				if(eval("document.all.expense_date" + satir_) != undefined)
					document.add_costplan.appendChild(eval("document.all.expense_date" + satir_));
				if(eval("document.all.work_id" + satir_) != undefined && eval("document.all.work_head" + satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.work_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.work_head" + satir_));
				}
				if(eval("document.all.opp_id" + satir_) != undefined && eval("document.all.opp_head" + satir_) != undefined)
				{
					document.add_costplan.appendChild(eval("document.all.opp_id" + satir_));
					document.add_costplan.appendChild(eval("document.all.opp_head" + satir_));
				}
			}
		</cfif>
	}
	</cfoutput>
	function approve_control()
	{
		//Belge Acikken Masraf Yonetiminden Onaylanabilir, Bu Durumda Kontrol Edilerek Guncelleme Yapilmasini Engeller
		<cfif ListFirst(attributes.fuseaction,'.') is 'myhome'>
		var get_approve_control = wrk_safe_query("obj_expense_request_approve_control","dsn2",1,document.getElementById("request_id").value);
		if(get_approve_control.IS_APPROVE != "" && get_approve_control.IS_APPROVE == 1)
		{
			alert("Talep Onaylanmıştır, Belge Üzerinde İşlem Yapamazsınız. Lüften Sayfayı Yenileyiniz!");
			return false;	
		}
		else if(get_approve_control.IS_APPROVE != "" && get_approve_control.IS_APPROVE == 0)
		{
			alert("Talep Reddedilmiştir, Belge Üzerinde İşlem Yapamazsınız. Lüften Sayfayı Yenileyiniz!");
			return false;	
		}
		</cfif>
		return true;
	}
	function upd_kontrol()
	{
		if(document.getElementById('paper_number').value == "")
		{
			alert("Lütfen Belge Numarası Giriniz!");
			return false;
		}
		if(add_costplan.expense_date.value == "")
		{
			alert("<cf_get_lang no='1064.Lütfen Harcama Tarihi Giriniz'>");
			return false;
		}
		record_exist=0;//Row_kontrol değeri 1 olan yani silinmemiş satırların varlığını kontrol ediyor
		for(r=1;r<=add_costplan.record_num.value;r++)
		{
			deger_row_kontrol =  document.getElementById('row_kontrol'+r);
			deger_expense_center_id = document.getElementById('expense_center_id'+r);
			deger_expense_item_id = document.getElementById('expense_item_id'+r);
			deger_total = document.getElementById('total'+r);
			deger_row_detail = document.getElementById('row_detail'+r);
			if(document.getElementById('work_head'+r) != undefined) work_name = document.getElementById('work_head'+r).value; else work_name = "";
			if(document.getElementById("project_id"+r) != undefined) deger_project = document.getElementById("project_id"+r).value;
			if(document.getElementById("project"+r) != undefined) project_name = document.getElementById("project"+r).value;
			if(document.getElementById("work_id"+r) != undefined) deger_work = document.getElementById("work_id"+r).value;
	
			if(deger_row_kontrol.value == 1)
			{
				record_exist=1;
				if (document.getElementById('expense_date'+r)!= undefined && document.getElementById('expense_date'+r).value == "")
				{ 
					alert ("<cf_get_lang_main no='810.Lütfen Tarih giriniz'>");
					return false;
				}
				<cfif x_is_project_priority eq 1>
					if (deger_project == "" || project_name == "")
					{ 
						alert ("Lütfen Proje Seçiniz !");
						return false;
					}
					var get_proje_ = wrk_safe_query("obj_get_project_period","dsn3","1",deger_project);
					var proje_record_ = get_proje_.recordcount;
					if(proje_record_<1 || get_proje_.EXPENSE_CENTER_ID =='' || get_proje_.EXPENSE_CENTER_ID==undefined)
					{
						alert("Proje Masraf Merkezi Bulunamadı!");
						return false;
					}
					else
					{
						document.getElementById("expense_center_id"+r).value = get_proje_.EXPENSE_CENTER_ID;
					}
					if(proje_record_<1 || get_proje_.EXPENSE_ITEM_ID =='' || get_proje_.EXPENSE_ITEM_ID==undefined)
					{
						alert("Proje Gider Kalemi Bulunamadı !");
						return false;
					}
					else
					{
						document.getElementById("expense_item_id"+r).value = get_proje_.EXPENSE_ITEM_ID;
					}			
				</cfif>
				<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),2) and x_is_project_priority eq 0>
					if (deger_expense_center_id.value == "")
					{ 
						alert ("<cf_get_lang no='1069.Lütfen Masraf Merkezi Seçiniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
						return false;
					}
				</cfif>
				<cfif ListFind(ListDeleteDuplicates(xml_order_list_rows),3) and x_is_project_priority eq 0>
					if (deger_expense_item_id.value == "")
					{ 
						alert ("<cf_get_lang no='1071.Lütfen Gider Kalemi Seçiniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
						return false;
					}	
				</cfif>
				if (deger_row_detail.value == "")
				{ 
					alert ("<cf_get_lang no='1073.Lütfen Açıklama Giriniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
					return false;
				}	
				if (filterNum(deger_total.value) == 0 || deger_total.value == "")
				{ 
					alert ("<cf_get_lang_main no='1738.Lütfen Tutar giriniz'>!<cf_get_lang_main no='818.Satir No'>:"+r);
					return false;
				}
				if(document.getElementById("xml_select_project").value ==1) {		
					if (deger_project == "" || project_name == "")
					{ 
						alert ("Lütfen Proje Seçiniz !");
						return false;
					}	
				}	
				if(document.getElementById("xml_select_work").value ==1) {
					if (deger_work == "" || work_name == "")
					{ 
						alert ("Lutfen İş Seçiniz !");
						return false;
					}
				}			
			}
		}
		if (record_exist == 0) 
		{
			alert("<cf_get_lang no='1432.Lütfen Satır Ekleyiniz'>");
			return false;
		}
		unformat_fields();
		if(approve_control())
			return process_cat_control();
		else
			return false;
	}
	<cfif x_is_show_paymethod eq 1>
		change_due_date();
	</cfif>
	function change_due_date(type)
	{
		if (type==1)
			document.getElementById("basket_due_value").value = datediff(document.getElementById("expense_date").value,document.getElementById("basket_due_value_date_").value,0);
		else
		{
			if(isNumber(document.getElementById("basket_due_value"))!= false && (document.getElementById("basket_due_value").value != 0))
				document.getElementById("basket_due_value_date_").value = date_add('d',+document.getElementById("basket_due_value").value,document.getElementById("expense_date").value);
			else
				document.getElementById("basket_due_value_date_").value = document.getElementById("expense_date").value;
		}
	}
	<cfoutput>
		function other_calc(row_info,type_info)
		{
			if(row_info != undefined)
			{
				if(document.getElementById('row_kontrol'+row_info).value==1)
				{
					deger_money_id = list_getat(document.getElementById('money_id'+row_info).value,1,',');
					for(kk=1;kk<=document.add_costplan.kur_say.value;kk++)
					{
						money_deger =list_getat(document.all.rd_money[kk-1].value,1,',');
						if(money_deger == deger_money_id)
						{
							deger_diger_para_satir = document.add_costplan.rd_money[kk-1];
							form_value_rate_satir = document.getElementById('txt_rate2_'+kk);
						}
					}
					if(document.getElementById("other_net_total"+row_info) != undefined) document.getElementById("other_net_total"+row_info).value = filterNum(document.getElementById("other_net_total"+row_info).value,'#session.ep.our_company_info.rate_round_num#');
					if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = document.getElementById("other_net_total"+row_info).value*filterNum(form_value_rate_satir.value,'#session.ep.our_company_info.rate_round_num#');
					if(document.getElementById("other_net_total"+row_info) != undefined ) document.getElementById("other_net_total"+row_info).value = commaSplit(document.getElementById("other_net_total"+row_info).value,'#session.ep.our_company_info.rate_round_num#');
					if(document.getElementById("net_total"+row_info) != undefined) document.getElementById("net_total"+row_info).value = commaSplit(document.getElementById("net_total"+row_info).value,'#session.ep.our_company_info.rate_round_num#');
				}
				if(type_info==undefined)
					hesapla('other_net_total',row_info,2);
				else
					hesapla('other_net_total',row_info,2,type_info);
			}
			else
			{
				for(yy=1;yy<=document.add_costplan.record_num.value;yy++)
				{	
					if(document.getElementById('row_kontrol'+yy).value==1)
					{
						other_calc(yy,1);
					}
				}
				toplam_hesapla();
			}
		}
		function pencere_ac_exp(no)
		{
			windowopen('#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=all.expense_center_id' + no +'&field_name=all.expense_center_name' + no,'list');
		}
		function pencere_ac_item(no,inc)
		{
			if(inc == 1) inc_ = "&is_income=1"; else inc_ = "";
			windowopen('#request.self#?fuseaction=objects.popup_list_exp_item&field_id=all.expense_item_id' + no +'&field_name=all.expense_item_name' + no + inc_,'list');
		}

	</cfoutput>
</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	
	if(fusebox.circuit eq 'myhome')
	{
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_expense_requests';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_my_expense_requests.cfm';
	}
	else
	{
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'cost.list_expense_requests';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'cost/display/list_expense_requests.cfm';
	}
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'objects.expense_request';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'objects/form/form_add_expense_plan_request.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'objects/query/add_expense_plan_request.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_my_expense_requests&event=upd';

	if(fusebox.circuit eq 'myhome')
	{
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.list_my_expense_requests';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'objects/form/form_upd_expense_plan_request.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'objects/query/upd_expense_plan_request.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.list_my_expense_requests&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'request_id=##attributes.request_id##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.request_id##';
	}
	else
	{
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'objects.expense_request';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'objects/form/form_upd_expense_plan_request.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'objects/query/upd_expense_plan_request.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'cost.list_expense_requests&event=upd';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'request_id=##attributes.request_id##';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.request_id##';
	}
	
	if(IsDefined("attributes.event") && (attributes.event is 'upd' || attributes.event is 'del'))
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#request.self#?fuseaction=objects.del_expense_plan_request&request_id=#attributes.request_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'objects/query/del_expense_plan_request.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'objects/query/del_expense_plan_request.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'myhome.list_my_expense_requests';
	}
		
		
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	
	// Upd //	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		

		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = '<cf_get_workcube_related_acts period_id="#session.ep.period_id#" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id="49" action_section="REQUEST_ID" action_id="#attributes.request_id#">';


		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['href'] = "#request.self#?fuseaction=myhome.list_my_expense_requests&event=add";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['text'] = '#lang_array_main.item[64]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['href'] = '#request.self#?fuseaction=myhome.list_my_expense_requests&event=add&request_id=#attributes.request_id#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['copy']['target'] = "_blank";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&print_type=231&action_id=#attributes.request_id#','page','workcube_print');";


		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'listMyExpenseRequest';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EXPENSE_ITEM_PLAN_REQUESTS';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item1','item2','item3','item11','item12','item13']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
