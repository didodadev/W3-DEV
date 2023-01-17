<cfsetting showdebugoutput="no">
<cf_xml_page_edit>
<cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no) and (isdefined("attributes.seri_stock_id") or isdefined("attributes.only_service"))>
	<cfif isdefined("attributes.seri_stock_id")>
		<cfquery name="get_search_results_" datasource="#dsn3#">
			SELECT 
				SG.GUARANTY_ID,
				SG.RECORD_DATE,
				SG.STOCK_ID,
				SG.PROCESS_ID,
				SG.SERIAL_NO,
				SG.REFERENCE_NO,
                SG.LOT_NO,
				SG.IS_SALE,
				SG.PROCESS_CAT,
				CASE 
                    WHEN SG.PROCESS_CAT IN (1719) THEN (SELECT RESULT_NO FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = SG.PROCESS_ID) 
                    ELSE SG.PROCESS_NO
                END AS PROCESS_NO,
				SG.SALE_CONSUMER_ID,
				SG.SALE_COMPANY_ID,
				SG.PURCHASE_GUARANTY_CATID,
				SG.SALE_GUARANTY_CATID,
				SG.SALE_START_DATE,
				SG.SALE_FINISH_DATE,
				SG.PURCHASE_START_DATE,
				SG.PURCHASE_FINISH_DATE,
				SG.PURCHASE_COMPANY_ID,
				SG.IS_PURCHASE,
				SG.IN_OUT,
				SG.IS_RETURN,
				SG.IS_RMA,
				SG.IS_SERVICE,
				SG.IS_TRASH,
				SG.PURCHASE_CONSUMER_ID,
				SG.MAIN_STOCK_ID,
				SG.IS_SERI_SONU,
				SG.DEPARTMENT_ID,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				S.STOCK_CODE,
				S.PRODUCT_NAME,
				S.PROPERTY,
				S.PRODUCT_ID
			FROM 
				SERVICE_GUARANTY_NEW SG,
				STOCKS S,
				#DSN_ALIAS#.EMPLOYEES E
			WHERE 
				SG.RECORD_EMP = E.EMPLOYEE_ID AND 
				SG.STOCK_ID = S.STOCK_ID AND 
				SG.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.seri_stock_id#"> AND
				(
                	SG.SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#"> 
                	OR SG.REFERENCE_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">
                    OR SG.LOT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">
                )
				<cfif isdefined("attributes.is_store")>
					AND ( SG.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">))
				</cfif>
			ORDER BY 
				SG.UPDATE_DATE DESC,
				SG.RECORD_DATE DESC
		</cfquery>
	<cfelse>
		<cfset get_search_results_.recordcount = 0>
	</cfif>
	<cfif isdefined("attributes.company_send_form") and get_search_results_.recordcount>
		<script type="text/javascript">
			<cfoutput>
				opener.#attributes.company_send_form#.service_product_id.value = '#get_search_results_.PRODUCT_ID#';
				opener.#attributes.company_send_form#.stock_id.value = '#get_search_results_.STOCK_ID#';
				opener.#attributes.company_send_form#.service_product.value = '#get_search_results_.PRODUCT_NAME#  #get_search_results_.PROPERTY#';
				opener.#attributes.company_send_form#.is_check_product_serial_number.value = 1;
	
				<cfif len(get_search_results_.sale_consumer_id)>
					opener.#attributes.company_send_form#.company_id.value = '';
					opener.#attributes.company_send_form#.company_name.value = '';
					opener.#attributes.company_send_form#.service_address.value = '';
					opener.#attributes.company_send_form#.member_id.value = '#get_search_results_.sale_consumer_id#';
					opener.#attributes.company_send_form#.member_type.value = 'consumer';
					opener.#attributes.company_send_form#.member_name.value = '#get_cons_info(get_search_results_.sale_consumer_id,1,0)#';
				<cfelseif len(get_search_results_.purchase_consumer_id)>
					opener.#attributes.company_send_form#.company_id.value = '';
					opener.#attributes.company_send_form#.company_name.value = '';
					opener.#attributes.company_send_form#.service_address.value = '';
					opener.#attributes.company_send_form#.member_id.value = '#get_search_results_.purchase_consumer_id#';
					opener.#attributes.company_send_form#.member_type.value = 'consumer';
					opener.#attributes.company_send_form#.member_name.value = '#get_cons_info(get_search_results_.purchase_consumer_id,1,0)#';
				<cfelseif len(get_search_results_.sale_company_id)>
					<cfquery name="get_par_comp" datasource="#dsn#">
						SELECT 
							C.FULLNAME,
							CP.COMPANY_PARTNER_NAME,
							CP.COMPANY_PARTNER_SURNAME,
							C.MANAGER_PARTNER_ID,
							C.COMPANY_ADDRESS
						FROM
							COMPANY C,
							COMPANY_PARTNER CP
						WHERE
							C.MANAGER_PARTNER_ID = CP.PARTNER_ID AND 
							C.COMPANY_ID = #get_search_results_.sale_company_id# AND
							C.COMPANY_ID = CP.COMPANY_ID
					</cfquery>
					opener.#attributes.company_send_form#.company_id.value = '#get_search_results_.sale_company_id#';
					opener.#attributes.company_send_form#.company_name.value = '#get_par_comp.FULLNAME#';
					opener.#attributes.company_send_form#.service_address.value = "#replace(get_par_comp.COMPANY_ADDRESS,chr(13)&chr(10),' ','all')#";
					opener.#attributes.company_send_form#.member_id.value = '#get_par_comp.MANAGER_PARTNER_ID#';
					opener.#attributes.company_send_form#.member_type.value = 'partner';
					opener.#attributes.company_send_form#.member_name.value = '#get_par_comp.COMPANY_PARTNER_NAME# #get_par_comp.COMPANY_PARTNER_SURNAME#';
				<cfelseif len(get_search_results_.purchase_company_id)>
					<cfquery name="get_par_comp_2" datasource="#dsn#">
						SELECT
							C.MANAGER_PARTNER_ID,
							CP.COMPANY_PARTNER_NAME,
							CP.COMPANY_PARTNER_SURNAME,
							CP.COMPANY_PARTNER_EMAIL,
							CB.COMPBRANCH_TELCODE,
							CB.COMPBRANCH_TEL1,
							CB.COMPBRANCH_ADDRESS,
							CB.COUNTY_ID,
							CB.CITY_ID,
							SC.COUNTY_NAME,
							C.FULLNAME,
							S_C.CITY_NAME,
							S.COUNTRY_NAME,
							SZ.SZ_ID
						FROM
							COMPANY_BRANCH AS CB 
							LEFT JOIN SETUP_COUNTY AS SC ON SC.COUNTY_ID = CB.COUNTY_ID 
							LEFT JOIN SETUP_CITY AS S_C ON S_C.CITY_ID = CB.CITY_ID
							LEFT JOIN SETUP_COUNTRY AS S ON S.COUNTRY_ID = CB.COUNTRY_ID,
							COMPANY_PARTNER AS CP,
							COMPANY AS C LEFT JOIN SALES_ZONES AS SZ ON SZ.SZ_ID = C.SALES_COUNTY
						WHERE
							CB.COMPANY_ID = #get_search_results_.purchase_company_id#
							AND CP.COMPANY_ID = CB.COMPANY_ID
							AND C.COMPANY_ID = CB.COMPANY_ID
					</cfquery>					
					opener.#attributes.company_send_form#.company_id.value = '#get_search_results_.purchase_company_id#';
					opener.#attributes.company_send_form#.company_name.value = '#get_par_comp_2.FULLNAME#';
					opener.#attributes.company_send_form#.member_id.value = '#get_par_comp_2.MANAGER_PARTNER_ID#';
					opener.#attributes.company_send_form#.member_type.value = 'partner';
					opener.#attributes.company_send_form#.member_name.value = '#get_par_comp_2.COMPANY_PARTNER_NAME# #get_par_comp_2.COMPANY_PARTNER_SURNAME#';
					opener.#attributes.company_send_form#.bring_tel_no.value = '#get_par_comp_2.COMPBRANCH_TELCODE##get_par_comp_2.COMPBRANCH_TEL1#';
					opener.#attributes.company_send_form#.bring_email.value = '#get_par_comp_2.COMPANY_PARTNER_EMAIL#';
					opener.#attributes.company_send_form#.service_address.value = '#replace(get_par_comp_2.COMPBRANCH_ADDRESS,chr(13)&chr(10)," ","all")# #get_par_comp_2.COUNTY_NAME# #get_par_comp_2.CITY_NAME# #get_par_comp_2.COUNTRY_NAME#';
					opener.#attributes.company_send_form#.service_city_id.value = '#get_par_comp_2.CITY_ID#';
					opener.#attributes.company_send_form#.service_county_id.value = '#get_par_comp_2.COUNTY_ID#';
					opener.#attributes.company_send_form#.service_county_name.value = '#get_par_comp_2.COUNTY_NAME#';
					opener.#attributes.company_send_form#.applicator_comp_name.value = '#get_par_comp_2.FULLNAME#';
					opener.#attributes.company_send_form#.sales_zone_id.value = '#get_par_comp_2.SZ_ID#';
				</cfif>
			</cfoutput>
		</script>
	</cfif>
	<cfif isdefined("attributes.seri_stock_id")>
		<cfquery name="get_search_results_ilk" dbtype="query" maxrows="1">
			SELECT * FROM get_search_results_ ORDER BY GUARANTY_ID DESC
		</cfquery>
	<cfelse>
		<cfset get_search_results_ilk.recordcount = 0>
	</cfif>
	<cfif get_search_results_.recordcount and len(get_search_results_.PROCESS_ID)>
		<cfquery name="get_related_results_" datasource="#dsn3#">
			SELECT 
				SG.*,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				D.DEPARTMENT_HEAD,
				S.STOCK_CODE,
				S.PRODUCT_NAME
			FROM 
				SERVICE_GUARANTY_NEW SG,
				STOCKS S,
				#DSN_ALIAS#.EMPLOYEES E,
				#DSN_ALIAS#.DEPARTMENT D
			WHERE 
				SG.RECORD_EMP = E.EMPLOYEE_ID
				AND SG.DEPARTMENT_ID = D.DEPARTMENT_ID
				AND SG.STOCK_ID = S.STOCK_ID
				AND RETURN_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_search_results_.serial_no#">
				AND RETURN_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_search_results_.stock_id#">
				AND RETURN_PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_search_results_.PROCESS_ID#">
				<cfif isdefined("attributes.is_store")>
					AND  ( SG.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">))
				</cfif>
			ORDER BY GUARANTY_ID DESC
		</cfquery>
	</cfif>
</cfif>



<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'det';

	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'objects.serial_no&event=det';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'objects/display/dsp_serial_number_result.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = '';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'objects.serial_no&event=det';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = '';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '';
</cfscript>


<script type="text/javascript">
	function open_add_specify_(serial_no,stock_id)
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_new_specify&stock_id='+stock_id+'&serial_no='+serial_no ,'add_specify_','1');
	}
	function open_update_specify(guaranty_id,serial_no,stock_id)
	{ 
		AjaxPageLoad( '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_upd_specify_settings&guaranty_id='+guaranty_id+'&serial_no='+serial_no+'&stock_id='+stock_id ,'add_specify_','1');
	}
</script>
