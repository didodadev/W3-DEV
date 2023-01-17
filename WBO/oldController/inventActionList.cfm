<cfparam name="attributes.belge_no" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.ch_company_id" default="">
<cfparam name="attributes.ch_consumer_id" default="">
<cfparam name="attributes.ch_company" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.branch_id1" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.efatura_type" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined("attributes.form_varmi")>
	<cfif (len(attributes.cat) and listFind("65,66,82,83",attributes.cat)) or not len(attributes.cat)>
		<cfquery name="GET_ACTIONS" datasource="#dsn2#">
			<cfif (len(attributes.cat) and listFind("65,66",attributes.cat)) or not len(attributes.cat)>
				SELECT
					INVOICE.INVOICE_ID AS ACTION_ID,
					INVOICE.INVOICE_NUMBER AS PAPER_NUMBER,
					INVOICE.INVOICE_CAT AS PROCESS_TYPE,
					INVOICE.INVOICE_DATE AS PROCESS_DATE,
					INVOICE.NETTOTAL AS TUTAR,
					INVOICE.OTHER_MONEY_VALUE AS TUTAR_DOVIZ,
					INVOICE.OTHER_MONEY,
					INVOICE.RECORD_DATE,
                    B.BRANCH_NAME ,
					INVOICE.RECORD_EMP,
                    EMPLOYEES.EMPLOYEE_NAME,
                    EMPLOYEES.EMPLOYEE_SURNAME,
                    EMPLOYEES.EMPLOYEE_ID
				FROM
					INVOICE
                    LEFT JOIN #dsn_alias#.DEPARTMENT D  ON INVOICE.DEPARTMENT_ID = D.DEPARTMENT_ID
                    LEFT JOIN #dsn_alias#.BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
                    LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = INVOICE.RECORD_EMP
				WHERE
                	INVOICE_CAT IN (65,66)
				<cfif len(attributes.cat)>
					AND INVOICE_CAT = #attributes.cat#
				</cfif>
				<cfif len(attributes.belge_no)>
					AND (INVOICE_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%')
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND INVOICE_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
				<cfelseif isdate(attributes.start_date)>
					AND INVOICE_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND INVOICE_DATE <= #attributes.finish_date#
				</cfif>
                <cfif len(attributes.branch_id1)>
                	AND B.BRANCH_ID=#attributes.branch_id1#
                </cfif>
				<cfif len(attributes.ch_company_id) and len(attributes.ch_company)>
					AND INVOICE.COMPANY_ID = #attributes.ch_company_id#
				</cfif>
				<cfif len(attributes.ch_consumer_id) and len(attributes.ch_company)>
					AND CONSUMER_ID = #attributes.ch_consumer_id#
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif len(attributes.department_id) and len(attributes.department_name)>
					AND (INVOICE.DEPARTMENT_ID = #attributes.department_id#
					AND DEPARTMENT_LOCATION=#attributes.location_id#)
				</cfif>
				<cfif len(attributes.employee_id) and len(attributes.employee_name)>
					AND SALE_EMP = #attributes.employee_id#
				</cfif>
			</cfif>
			<cfif not len(attributes.cat) and (IsDefined("attributes.efatura_type") and not len(attributes.efatura_type))>
			UNION ALL
			</cfif>
			<cfif (len(attributes.cat) and listFind("82,83",attributes.cat)) or not len(attributes.cat)>		
				SELECT
					SHIP.SHIP_ID AS ACTION_ID,
					SHIP.SHIP_NUMBER AS PAPER_NUMBER,
					SHIP.SHIP_TYPE AS PROCESS_TYPE,
					SHIP.SHIP_DATE AS PROCESS_DATE,
					SHIP.NETTOTAL AS TUTAR,
					SHIP.OTHER_MONEY_VALUE AS TUTAR_DOVIZ,
					SHIP.OTHER_MONEY,
					SHIP.RECORD_DATE,
                    B.BRANCH_NAME,
					SHIP.RECORD_EMP,
                    EMPLOYEES.EMPLOYEE_NAME,
                    EMPLOYEES.EMPLOYEE_SURNAME,
                    EMPLOYEES.EMPLOYEE_ID
				FROM
					SHIP
                    LEFT JOIN #dsn_alias#.DEPARTMENT D  ON ISNULL(SHIP.DELIVER_STORE_ID,SHIP.LOCATION_IN) = D.DEPARTMENT_ID 
                    LEFT JOIN #dsn_alias#.BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
                    LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = SHIP.RECORD_EMP
				WHERE
					SHIP_TYPE IN (82,83)
				<cfif len(attributes.cat)>
					AND SHIP_TYPE = #attributes.cat#
				</cfif>
				<cfif len(attributes.belge_no)>
					AND (SHIP_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%')
				</cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND SHIP_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
				<cfelseif isdate(attributes.start_date)>
					AND SHIP_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND SHIP_DATE <= #attributes.finish_date#
				</cfif>
				<cfif len(attributes.ch_company_id) and len(attributes.ch_company)>
					AND SHIP.COMPANY_ID = #attributes.ch_company_id#
				</cfif>
				<cfif len(attributes.ch_consumer_id) and len(attributes.ch_company)>
					AND CONSUMER_ID = #attributes.ch_consumer_id#
				</cfif>
                 <cfif len(attributes.branch_id1)>
                	AND B.BRANCH_ID=#attributes.branch_id1#
                </cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif len(attributes.department_id) and len(attributes.department_name)>
					AND (SHIP.DEPARTMENT_IN = #attributes.department_id#
					AND LOCATION_IN = #attributes.location_id#)
				</cfif>
				<cfif len(attributes.employee_id) and len(attributes.employee_name)>
					AND SALE_EMP = #attributes.employee_id#
				</cfif>
			</cfif>
			</cfquery>
		</cfif>
		<cfif ((len(attributes.cat) and listFind("118,1182",attributes.cat)) or not len(attributes.cat)) and not len(attributes.ch_company)>		
			<cfquery name="get_ships" datasource="#dsn2#">
				SELECT
					S.FIS_ID AS ACTION_ID,
					S.FIS_NUMBER AS PAPER_NUMBER,
					S.FIS_TYPE AS PROCESS_TYPE,
					S.FIS_DATE AS PROCESS_DATE,
					SUM(SR.NET_TOTAL) AS TUTAR,
					SUM(SR.NET_TOTAL/SM.RATE2) AS TUTAR_DOVIZ,
					SM.MONEY_TYPE AS OTHER_MONEY,
					S.RECORD_DATE,
                    B.BRANCH_NAME,
					S.RECORD_EMP,
                    EMPLOYEES.EMPLOYEE_NAME,
                    EMPLOYEES.EMPLOYEE_SURNAME,
                    EMPLOYEES.EMPLOYEE_ID
				FROM
					STOCK_FIS S
					LEFT JOIN STOCK_FIS_ROW SR ON S.FIS_ID = SR.FIS_ID
					LEFT JOIN STOCK_FIS_MONEY SM ON S.FIS_ID = SM.ACTION_ID AND SM.IS_SELECTED = 1
                    LEFT JOIN #dsn_alias#.DEPARTMENT D  ON S.DEPARTMENT_IN = D.DEPARTMENT_ID OR S.DEPARTMENT_OUT = D.DEPARTMENT_ID
                    LEFT JOIN #dsn_alias#.BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
                    LEFT JOIN #dsn_alias#.EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = S.RECORD_EMP
                WHERE
					S.FIS_TYPE IN (118,1182)
				<cfif len(attributes.cat)>
					AND S.FIS_TYPE = #attributes.cat#
				</cfif>
				<cfif len(attributes.belge_no)>
					AND (S.FIS_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%' 
					OR S.REF_NO LIKE '%#attributes.belge_no#%') 
				</cfif>
                 <cfif len(attributes.branch_id1)>
                	AND B.BRANCH_ID=#attributes.branch_id1#
                </cfif>
				<cfif isdate(attributes.start_date) and isdate(attributes.finish_date)>
					AND S.FIS_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
				<cfelseif isdate(attributes.start_date)>
					AND S.FIS_DATE >= #attributes.start_date#
				<cfelseif isdate(attributes.finish_date)>
					AND S.FIS_DATE <= #attributes.finish_date#
				</cfif>
				<cfif len(attributes.project_id) and len(attributes.project_head)>
					AND S.PROJECT_ID = #attributes.project_id#
				</cfif>
				<cfif len(attributes.employee_id) and len(attributes.employee_name)>
					AND S.EMPLOYEE_ID = #attributes.employee_id#
				</cfif>
				<cfif len(attributes.subscription_id) and len(attributes.subscription_no)>
					AND S.SUBSCRIPTION_ID = #attributes.subscription_id#
				</cfif>
				<cfif len(attributes.department_id) and len(attributes.department_name)>
					AND (S.DEPARTMENT_OUT = #attributes.department_id# 
					AND S.LOCATION_OUT = #attributes.location_id#)
				</cfif>
				GROUP BY
					S.FIS_ID,
					S.FIS_NUMBER,
					S.FIS_TYPE,
					S.FIS_DATE,
					S.RECORD_DATE,
					S.RECORD_EMP,
                    B.BRANCH_NAME,
					SM.MONEY_TYPE,
                    EMPLOYEES.EMPLOYEE_NAME,
                    EMPLOYEES.EMPLOYEE_SURNAME,
                    EMPLOYEES.EMPLOYEE_ID
			</cfquery>	
			</cfif>
            
			<cfquery name="get_all_actions" dbtype="query">
			<cfif (len(attributes.cat) and listFind("65,66,82,83",attributes.cat)) or not len(attributes.cat)>
					SELECT  	
						ACTION_ID,
						PAPER_NUMBER,
						PROCESS_TYPE,
						PROCESS_DATE,
						SUM(TUTAR) AS TUTAR,
						SUM(TUTAR_DOVIZ) AS TUTAR_DOVIZ,
						OTHER_MONEY,
                        BRANCH_NAME,
						RECORD_DATE,
						RECORD_EMP,
                        EMPLOYEE_NAME,
                        EMPLOYEE_SURNAME
					FROM  
						GET_ACTIONS
                        
					<cfif len(attributes.subscription_id) and len(attributes.subscription_no)>
						WHERE 1=0
					</cfif> 
					GROUP BY 
						ACTION_ID,
						PAPER_NUMBER,
						PROCESS_TYPE,
						PROCESS_DATE,
						OTHER_MONEY,
						RECORD_DATE,
                        BRANCH_NAME,
						RECORD_EMP,
                        EMPLOYEE_NAME,
                        EMPLOYEE_SURNAME
				</cfif>
				<cfif not len(attributes.cat) and not len(attributes.ch_company)>
				UNION ALL
				</cfif>
				<cfif (len(attributes.cat) and listFind("118,1182",attributes.cat)) or (not len(attributes.cat) and not len(attributes.ch_company)) and IsDefined("attributes.efatura_type") and  not len(attributes.efatura_type)>	
				
					SELECT  
						ACTION_ID,
						PAPER_NUMBER,
						PROCESS_TYPE,
						PROCESS_DATE,
						SUM(TUTAR) AS TUTAR,
						SUM(TUTAR_DOVIZ) AS TUTAR_DOVIZ,
						OTHER_MONEY,
                        BRANCH_NAME,
						RECORD_DATE,
						RECORD_EMP,
                        EMPLOYEE_NAME,
                        EMPLOYEE_SURNAME
					FROM 
						GET_SHIPS 
                    GROUP BY 
						ACTION_ID,
						PAPER_NUMBER,
						PROCESS_TYPE,
						PROCESS_DATE,
						OTHER_MONEY,
						RECORD_DATE,
                        BRANCH_NAME,
						RECORD_EMP,
                        EMPLOYEE_NAME,
                        EMPLOYEE_SURNAME
				</cfif>
					ORDER BY PROCESS_DATE DESC		
			</cfquery>
            <cfif get_all_actions.recordcount>
                <cfquery name="get_money" datasource="#dsn2#">
                    SELECT 
                        MONEY,
                        RATE2, 
                        PERIOD_ID, 
                        COMPANY_ID, 
                        RECORD_DATE, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        UPDATE_DATE, 
                        UPDATE_EMP, 
                        UPDATE_IP
                    FROM 
                        SETUP_MONEY
                </cfquery>
           </cfif>
		<cfparam name="attributes.totalrecords" default="#get_all_actions.recordcount#">
	<cfelse>
		<cfparam name="attributes.totalrecords" default="0">	
</cfif>
<script type="text/javascript">
	function pencere_ac_cari()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_id=form.ch_company_id&field_member_name=form.ch_company&field_name=form.ch_company&field_consumer=form.ch_consumer_id&keyword='+encodeURIComponent(document.form.ch_company.value),'list');
	}
	function auto_complate_cari()
	{
		AutoComplete_Create('ch_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID','ch_consumer_id,ch_company_id','','3','250');
	}
	function pencere_ac_proje()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head','list');
	}
	function auto_complate_proje()
	{
		AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');
	}
	function pencere_ac_department()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_stores_locations&form_name=form&field_location_id=location_id&field_name=department_name&field_id=department_id&branch_id=branch_id&is_no_sale=1','list');
	}
	function auto_complate_department()
	{
		AutoComplete_Create('department_name','DEPARTMENT_HEAD,COMMENT','DEPARTMENT_NAME','get_department_location','','DEPARTMENT_ID,LOCATION_ID,BRANCH_ID','department_id,location_id,branch_id','','3','200');
	}
	function pencere_ac_emp()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_positions&field_emp_id=form.employee_id&field_name=form.employee_name&select_list=1','list');
	}
	function auto_complate_emp()
	{
		AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','130');
	}
	function pencere_ac_sistem()
	{
		windowopen('index.cfm?fuseaction=objects.popup_list_subscription&field_id=form.subscription_id&field_no=form.subscription_no','list','popup_list_subscription');
	}
	function auto_complate_sistem()
	{
		AutoComplete_Create('subscription_no','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id','','2','100');
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invent.list_actions';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'inventory/display/list_actions.cfm';
	
</cfscript>