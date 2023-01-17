<cfquery name="GET_MY_DEPARTMENT" datasource="#DSN#">
	SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
</cfquery>
<cfif (listFind("70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,88,761,85,86,140,141,118,1182",listfirst(attributes.cat,'-'))) or not len (attributes.cat) or (not (len(attributes.consumer_id) or len(attributes.company_id) or len(attributes.invoice_action)) and listFind("110,111,112,113,114,115,116,119,1131",listfirst(attributes.cat,'-')))>
	<cfquery name="GET_SHIP_FIS" datasource="#DSN2#">
		<cfif (len(attributes.cat) and listFind("70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,88,761,85,86,140,141",listfirst(attributes.cat,'-'))) or not len(attributes.cat)>
			<cfif len(attributes.invoice_action)><!--- faturali mi veya faturasiz mi soruldugu icin INVOICE_SHIPS iliskisi her halukarda aranacak --->
				SELECT
					1 TABLE_TYPE,
					SHIP.PROCESS_CAT PROCESS_CAT,
					SHIP.PROJECT_ID,
                    (SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = SHIP.PROJECT_ID_IN) PROJECT_HEAD_IN,
				<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme yapılıyorsa --->
					SHIP_ROW.NAME_PRODUCT,
					STOCKS.STOCK_CODE,
					SHIP_ROW.PRODUCT_ID,
					SHIP_ROW.AMOUNT,
					SHIP_ROW.PRICE,
					NULL LOT_NO,
				</cfif>
					SHIP.PURCHASE_SALES,
					SHIP.SHIP_ID ISLEM_ID,
					SHIP.SHIP_NUMBER BELGE_NO,
					SHIP.REF_NO REFERANS,
					SHIP.SHIP_TYPE ISLEM_TIPI,
					SHIP.SHIP_DATE ISLEM_TARIHI,
					SHIP.COMPANY_ID,
					SHIP.CONSUMER_ID,
					SHIP.PARTNER_ID,
					SHIP.EMPLOYEE_ID,
					SHIP.DEPARTMENT_IN DEPARTMENT_ID,
					SHIP.LOCATION_IN LOCATION,
					SHIP.DELIVER_STORE_ID DEPARTMENT_ID_2,
					SHIP.LOCATION LOCATION_2,
				  <cfif attributes.invoice_action eq 2>
					NULL INVOICE_NUMBER,
				  <cfelse>
					INVOICE_SHIPS.INVOICE_NUMBER AS INVOICE_NUMBER,
				  </cfif>
					SHIP.DELIVER_EMP,
					SHIP.RECORD_DATE,
					0 IS_STOCK_TRANSFER,
					0 STOCK_EXCHANGE_TYPE
				FROM 	
					SHIP WITH (NOLOCK)
					<cfif attributes.invoice_action eq 1>
						,INVOICE_SHIPS WITH (NOLOCK)
					</cfif>
					<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme yapılıyorsa --->
						,SHIP_ROW WITH (NOLOCK)
						,#dsn3_alias#.STOCKS STOCKS WITH (NOLOCK)
					</cfif>
				WHERE 
				<cfif attributes.invoice_action eq 1>
					SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID
					AND INVOICE_SHIPS.SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
				<cfelse>
					SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
				</cfif>
				<cfif isdefined('attributes.lot_no') and Len(attributes.lot_no)>
					<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme --->
						AND SHIP_ROW.LOT_NO LIKE '<cfif len(attributes.lot_no) gt 3>%</cfif>#attributes.lot_no#%'
					<cfelse>
						AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW SFR WHERE SFR.SHIP_ID = SHIP.SHIP_ID AND SFR.LOT_NO LIKE '<cfif len(attributes.lot_no) gt 3>%</cfif>#attributes.lot_no#%')
					</cfif>
				</cfif>
				<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme yapılıyorsa --->
					AND SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
					AND SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID
					AND SHIP_ROW.PRODUCT_ID = STOCKS.PRODUCT_ID
				</cfif>
				<cfif len(attributes.cat) and listlast(attributes.cat,'-') eq 0>
					AND SHIP.SHIP_TYPE = #listfirst(attributes.cat,'-')#
				<cfelseif len(attributes.cat) and listlast(attributes.cat,'-') neq 0>
					AND SHIP.PROCESS_CAT = #listlast(attributes.cat,'-')#
				<cfelse>
					AND SHIP.SHIP_ID IS NOT NULL
				</cfif>
				<cfif isdate(attributes.record_date)>
					AND SHIP.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">
					AND SHIP.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.record_date)#">
				</cfif>
				<cfif len(attributes.date1) and len(attributes.date2)>
					AND SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif len(attributes.department_id)>
					<cfif listlen(attributes.department_id,'-') eq 1>
						AND (SHIP.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> OR SHIP.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">)
					<cfelse>
						AND ((SHIP.DEPARTMENT_IN =  #listfirst(attributes.department_id,'-')# AND SHIP.LOCATION_IN = #listlast(attributes.department_id,'-')#) OR
							(SHIP.DELIVER_STORE_ID = #listfirst(attributes.department_id,'-')# AND SHIP.LOCATION = #listlast(attributes.department_id,'-')#))	
					</cfif>
				<cfelseif session.ep.isBranchAuthorization>
					AND 
					(
					  <cfif (isDefined("attributes.cat") and len(attributes.cat) and listFind("73,74,75,76,77,80,81,82,84,761",listfirst(attributes.cat,'-'))) or not(isDefined("attributes.cat") and len(attributes.cat))>
						(SHIP.DEPARTMENT_IN IN (#valuelist(get_my_department.department_id)#))
					  </cfif>
					  <cfif not(isDefined("attributes.cat") and len(attributes.cat))>
						OR
					  </cfif>
					  <cfif (isDefined("attributes.cat") and len(attributes.cat) and listFind("70,71,72,78,79,83,88",listfirst(attributes.cat,'-'))) or not(isDefined("attributes.cat") and len(attributes.cat))>
						(SHIP.DELIVER_STORE_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">))
					  </cfif>
					)	
				</cfif>	
				<cfif len(attributes.belge_no)>
					AND ((SHIP.SHIP_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%') OR
						(SHIP.REF_NO LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%'))
				</cfif>
				<cfif len(attributes.project_id)>
					AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
					AND SHIP.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
				</cfif>
				<cfif len(attributes.employee_id) and attributes.employee_id gt 0>
					AND SHIP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				<cfelseif len(attributes.consumer_id) and attributes.consumer_id gt 0>
					AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				<cfelseif len(attributes.company_id) and attributes.company_id gt 0>
					AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif len(attributes.iptal_stocks)>
					AND SHIP.IS_SHIP_IPTAL = #attributes.iptal_stocks#
				</cfif>
				<cfif len(attributes.stock_id) and len(attributes.product_name)>
					<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme yapılıyorsa --->
						AND SHIP_ROW.STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
					<cfelse>
						AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">)
					</cfif>
				</cfif>
				<cfif len(attributes.product_cat_code) and len(attributes.product_cat_name)>
					<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme yapılıyorsa --->
						AND SHIP_ROW.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT P WHERE P.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%')
					<cfelse>
						AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW SR, #dsn1_alias#.PRODUCT P WHERE P.PRODUCT_ID = SR.PRODUCT_ID AND P.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%')
					</cfif>
				</cfif>
				<cfif len(attributes.delivered) and attributes.delivered eq 1>
					AND SHIP.IS_DELIVERED = 1
				<cfelseif len(attributes.delivered) and attributes.delivered eq 0>
					AND ( SHIP.IS_DELIVERED = 0 OR SHIP.IS_DELIVERED IS NULL )
					AND SHIP.SHIP_TYPE IN (81,811)
				</cfif>
				<cfif (isdefined('attributes.deliver_emp') and len(attributes.deliver_emp)) or (isdefined('attributes.deliver_emp_id') and len(attributes.deliver_emp_id))>
					AND(
						<cfif isdefined('attributes.deliver_emp') and len(attributes.deliver_emp)>
							 (SHIP.PURCHASE_SALES = 1 AND SHIP.DELIVER_EMP LIKE '<cfif len(attributes.deliver_emp) gt 3>%</cfif>#attributes.deliver_emp#%')
						</cfif>
						<cfif isdefined('attributes.deliver_emp_id') and len(attributes.deliver_emp_id)>
							<cfif len(attributes.deliver_emp)>OR</cfif>(SHIP.PURCHASE_SALES = 0 AND (SHIP.DELIVER_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.deliver_emp_id#">))
						</cfif>
					)
				</cfif>
                <cfif len(attributes.company_id_2) and len(attributes.member_name)>
                	AND SHIP.COMPANY_ID = #attributes.company_id_2#
                <cfelseif len(attributes.consumer_id_2) and len(attributes.member_name)>
                    AND SHIP.CONSUMER_ID = #attributes.consumer_id_2#
                <cfelseif len(attributes.employee_id_2) and len(attributes.member_name)>
                   AND SHIP.EMPLOYEE_ID = #attributes.employee_id_2#
                </cfif>
			<cfelse>
				SELECT
					1 TABLE_TYPE,
					SHIP.PROCESS_CAT PROCESS_CAT,
					SHIP.PROJECT_ID,
                    (SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = SHIP.PROJECT_ID_IN) PROJECT_HEAD_IN,
				<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme yapılıyorsa --->
					SHIP_ROW.NAME_PRODUCT,
					STOCKS.STOCK_CODE,
					SHIP_ROW.PRODUCT_ID,
					SHIP_ROW.AMOUNT,
					SHIP_ROW.PRICE,
					NULL LOT_NO,
				</cfif>
					SHIP.PURCHASE_SALES ,
					SHIP.SHIP_ID ISLEM_ID,
					SHIP_NUMBER BELGE_NO,
					SHIP.REF_NO REFERANS,
					SHIP_TYPE ISLEM_TIPI,
					SHIP.SHIP_DATE ISLEM_TARIHI,
					SHIP.COMPANY_ID,
					SHIP.CONSUMER_ID,
					SHIP.PARTNER_ID,
					SHIP.EMPLOYEE_ID,
					DEPARTMENT_IN DEPARTMENT_ID,
					LOCATION_IN LOCATION,
					DELIVER_STORE_ID DEPARTMENT_ID_2,
					LOCATION LOCATION_2,
					NULL INVOICE_NUMBER, 
					DELIVER_EMP,
					SHIP.RECORD_DATE,
					0 IS_STOCK_TRANSFER,
					0 STOCK_EXCHANGE_TYPE
				FROM 	
					SHIP WITH (NOLOCK)
				<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme yapılıyorsa --->
					,SHIP_ROW WITH (NOLOCK)
					,#dsn3_alias#.STOCKS STOCKS WITH (NOLOCK)
				</cfif>
				WHERE 
				<cfif len(attributes.cat) and listlast(attributes.cat,'-') eq 0>
					SHIP.SHIP_TYPE = #listfirst(attributes.cat,'-')#
				<cfelseif len(attributes.cat) and listlast(attributes.cat,'-') neq 0>
					SHIP.PROCESS_CAT = #listlast(attributes.cat,'-')#
				<cfelse>
					SHIP.SHIP_ID IS NOT NULL
				</cfif>
				<cfif isdefined('attributes.lot_no') and Len(attributes.lot_no)>
					<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme --->
						AND SHIP_ROW.LOT_NO LIKE '<cfif len(attributes.lot_no) gt 3>%</cfif>#attributes.lot_no#%'
					<cfelse>
						AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW SFR WHERE SFR.SHIP_ID = SHIP.SHIP_ID AND SFR.LOT_NO LIKE '<cfif len(attributes.lot_no) gt 3>%</cfif>#attributes.lot_no#%')
					</cfif>
				</cfif>
				<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme yapılıyorsa --->
					AND SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
					AND SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID
					AND SHIP_ROW.PRODUCT_ID = STOCKS.PRODUCT_ID
				</cfif>
				<cfif isdate(attributes.record_date)>
					AND SHIP.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">
					AND SHIP.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.record_date)#">
				</cfif>
				<cfif len(attributes.date1) and  len(attributes.date2)>
					AND SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif len(attributes.department_id)>
				  <cfif listlen(attributes.department_id,'-') eq 1>
					AND (DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> OR DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">)
				  <cfelse>
					AND ((DEPARTMENT_IN =  #listfirst(attributes.department_id,'-')# AND LOCATION_IN = #listlast(attributes.department_id,'-')#) OR
						(DELIVER_STORE_ID = #listfirst(attributes.department_id,'-')# AND LOCATION = #listlast(attributes.department_id,'-')#))	
				  </cfif>
				<cfelseif session.ep.isBranchAuthorization>
					AND 
					(
					  <cfif (isDefined("attributes.cat") and len(attributes.cat) and listFind("73,74,75,76,77,80,81,82,84,761,811",listfirst(attributes.cat,'-'))) or not(isDefined("attributes.cat") and len(attributes.cat))>
						(SHIP.DEPARTMENT_IN IN (#valuelist(get_my_department.department_id)#))
					  </cfif>
					  <cfif not(isDefined("attributes.cat") and len(attributes.cat))>
						OR
					  </cfif>
					  <cfif (isDefined("attributes.cat") and len(attributes.cat) and listFind("70,71,72,78,79,83,88",listfirst(attributes.cat,'-'))) or not(isDefined("attributes.cat") and len(attributes.cat))>
						(SHIP.DELIVER_STORE_ID IN (#valuelist(get_my_department.department_id)#))
					  </cfif>
					)	
				</cfif>	
				<cfif len(attributes.belge_no)>
					AND ((SHIP.SHIP_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%') OR
						(SHIP.REF_NO LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%'))
				</cfif>
				<cfif len(attributes.project_id)>
					AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
				</cfif>
				<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
					AND SHIP.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
				</cfif>
				<cfif len(attributes.employee_id) and attributes.employee_id gt 0>
					AND SHIP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				<cfelseif len(attributes.consumer_id) and attributes.consumer_id gt 0>
					AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				<cfelseif len(attributes.company_id) and attributes.company_id gt 0>
					AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
				</cfif>
				<cfif len(attributes.iptal_stocks)>
					AND SHIP.IS_SHIP_IPTAL = #attributes.iptal_stocks#
				</cfif>
				<cfif len(attributes.stock_id) and len(attributes.product_name)>
					<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
						AND SHIP_ROW.STOCK_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
					<cfelse>
						AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">)
					</cfif>
				</cfif>
				<cfif len(attributes.product_cat_code) and len(attributes.product_cat_name)>
					<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme --->
						AND SHIP_ROW.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT P WHERE P.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%')
					<cfelse>
						AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW SR, #dsn1_alias#.PRODUCT P WHERE P.PRODUCT_ID = SR.PRODUCT_ID AND P.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%')
					</cfif>
				</cfif>
				<cfif len(attributes.delivered) and attributes.delivered eq 1>
					AND SHIP.IS_DELIVERED = 1
				<cfelseif  len(attributes.delivered) and attributes.delivered eq 0>
					AND (
						SHIP.IS_DELIVERED = 0 
						OR SHIP.IS_DELIVERED IS NULL
					)
					AND SHIP.SHIP_TYPE IN (81,811)
				</cfif>
				<cfif (isdefined("attributes.deliver_emp") and len(attributes.deliver_emp))>
					AND(
					<cfif len(attributes.deliver_emp)>
						(SHIP.PURCHASE_SALES = 1 AND SHIP.DELIVER_EMP LIKE '<cfif len(attributes.deliver_emp) gt 3>%</cfif>#attributes.deliver_emp#%')
					</cfif>
					<cfif len(attributes.deliver_emp_id)>
					<cfif len(attributes.deliver_emp)>OR</cfif>(SHIP.PURCHASE_SALES = 0 AND (SHIP.DELIVER_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.deliver_emp_id#">))
					</cfif>
					)
				</cfif>
                <cfif len(attributes.company_id_2) and len(attributes.member_name)>
                    AND SHIP.COMPANY_ID = #attributes.company_id_2#
                <cfelseif len(attributes.consumer_id_2) and len(attributes.member_name)>
                    AND SHIP.CONSUMER_ID = #attributes.consumer_id_2#
                <cfelseif len(attributes.employee_id_2) and len(attributes.member_name)>
                   AND SHIP.EMPLOYEE_ID = #attributes.employee_id_2#
                </cfif>
			</cfif>
		</cfif>
		<cfif not (len(attributes.consumer_id) or len(attributes.company_id) or len(attributes.invoice_action) or attributes.iptal_stocks eq 1)>
			<cfif not len(attributes.cat)>
			UNION ALL
			</cfif>
			<cfif (len(attributes.cat) and listFind("110,111,112,113,114,115,119,1131,118,1182",listfirst(attributes.cat,'-'))) or not len(attributes.cat)>
				SELECT
					2 TABLE_TYPE,
					STOCK_FIS.PROCESS_CAT PROCESS_CAT,
					STOCK_FIS.PROJECT_ID,
                    (SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = STOCK_FIS.PROJECT_ID_IN) PROJECT_HEAD_IN,
				<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme yapılıyorsa --->
					STOCKS.PRODUCT_NAME NAME_PRODUCT,
					STOCKS.STOCK_CODE,
					STOCKS.PRODUCT_ID,
					STOCK_FIS_ROW.AMOUNT,
					STOCK_FIS_ROW.PRICE,
					STOCK_FIS_ROW.LOT_NO LOT_NO,
				</cfif>
					-1 PURCHASE_SALES,
					STOCK_FIS.FIS_ID ISLEM_ID,
					STOCK_FIS.FIS_NUMBER BELGE_NO,
					STOCK_FIS.REF_NO REFERANS,
					FIS_TYPE ISLEM_TIPI,
					FIS_DATE ISLEM_TARIHI,
					STOCK_FIS.COMPANY_ID ,
					STOCK_FIS.CONSUMER_ID,
					STOCK_FIS.PARTNER_ID,
					STOCK_FIS.EMPLOYEE_ID,
					DEPARTMENT_IN DEPARTMENT_ID,
					LOCATION_IN LOCATION,
					DEPARTMENT_OUT DEPARTMENT_ID_2,
					LOCATION_OUT LOCATION_2,
					'' INVOICE_NUMBER,
					'' DELIVER_EMP,
					STOCK_FIS.RECORD_DATE,
					IS_STOCK_TRANSFER,
					0 STOCK_EXCHANGE_TYPE
				FROM
					STOCK_FIS WITH (NOLOCK)
				<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme yapılıyorsa --->
					,STOCK_FIS_ROW WITH (NOLOCK)
					,#dsn3_alias#.STOCKS STOCKS WITH (NOLOCK)
				</cfif>
				WHERE 
					<cfif len(attributes.cat) and listlast(attributes.cat,'-') eq 0>
						STOCK_FIS.FIS_TYPE = #listfirst(attributes.cat,'-')#
					<cfelseif len(attributes.cat) and listlast(attributes.cat,'-') neq 0>
						STOCK_FIS.PROCESS_CAT = #listlast(attributes.cat,'-')#
					<cfelse>
						STOCK_FIS.FIS_ID IS NOT NULL
					</cfif>
					AND STOCK_FIS.FIS_ID IN(SELECT SRR.UPD_ID FROM STOCKS_ROW SRR WHERE SRR.PROCESS_TYPE = STOCK_FIS.FIS_TYPE)
					<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme yapılıyorsa --->
						AND STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID
						AND STOCK_FIS_ROW.STOCK_ID = STOCKS.STOCK_ID
					</cfif>
					<cfif isdefined('attributes.lot_no') and Len(attributes.lot_no)>
						<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme --->
							AND STOCK_FIS_ROW.LOT_NO LIKE '<cfif len(attributes.lot_no) gt 3>%</cfif>#attributes.lot_no#%'
						<cfelse>
							AND STOCK_FIS.FIS_ID IN (SELECT FIS_ID FROM STOCK_FIS_ROW SFR WHERE SFR.FIS_ID = STOCK_FIS.FIS_ID AND SFR.LOT_NO LIKE '<cfif len(attributes.lot_no) gt 3>%</cfif>#attributes.lot_no#%')
						</cfif>
					</cfif>
					<cfif len(attributes.product_cat_code) and len(attributes.product_cat_name)>
						<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Satır bazında listeleme --->
							AND STOCKS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT P WHERE P.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%')
						<cfelse>
							AND STOCK_FIS.FIS_ID IN (SELECT FIS_ID FROM STOCK_FIS_ROW SFR, #dsn1_alias#.PRODUCT P, #dsn1_alias#.STOCKS S WHERE S.STOCK_ID = SFR.STOCK_ID AND P.PRODUCT_ID = S.PRODUCT_ID AND P.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%')
						</cfif>
					</cfif>
					<cfif len(attributes.record_date)>
						AND STOCK_FIS.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">
						AND STOCK_FIS.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.record_date)#">
					</cfif>
					<cfif len(attributes.date1) and len(attributes.date2)>
						AND STOCK_FIS.FIS_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
					</cfif>
					<cfif len(attributes.department_id)>
						<cfif listlen(attributes.department_id,'-') eq 1>
							AND (DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> OR DEPARTMENT_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">)
						<cfelse>
							AND ((DEPARTMENT_IN =  #listfirst(attributes.department_id,'-')# AND LOCATION_IN = #listlast(attributes.department_id,'-')#) OR
							(DEPARTMENT_OUT = #listfirst(attributes.department_id,'-')# AND LOCATION_OUT = #listlast(attributes.department_id,'-')#))						
						</cfif>
				
					<cfelseif session.ep.isBranchAuthorization>
						AND 
						(
							DEPARTMENT_IN IN (#valuelist(get_my_department.department_id)#) OR
							DEPARTMENT_OUT IN (#valuelist(get_my_department.department_id)#)
						)		
					</cfif>				  
					<cfif len(attributes.belge_no)>
						AND ((STOCK_FIS.FIS_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%') OR
						(STOCK_FIS.REF_NO LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%'))
					</cfif>
					<cfif len(attributes.project_id)>
						AND STOCK_FIS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
					</cfif>
					<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
						AND STOCK_FIS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
					</cfif>
					<cfif len(attributes.stock_id) and len(attributes.product_name)>
						<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
							AND STOCK_FIS_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
						<cfelse>
							AND STOCK_FIS.FIS_ID IN (SELECT FIS_ID FROM STOCK_FIS_ROW WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">)
						</cfif>
					</cfif>
                    <cfif len(attributes.company_id_2) and len(attributes.member_name)>
                        AND STOCK_FIS.COMPANY_ID = #attributes.company_id_2#
                    <cfelseif len(attributes.consumer_id_2) and len(attributes.member_name)>
						AND STOCK_FIS.CONSUMER_ID = #attributes.consumer_id_2#
                    <cfelseif len(attributes.employee_id_2) and len(attributes.member_name)>
                       AND STOCK_FIS.EMPLOYEE_ID = #attributes.employee_id_2#
                    </cfif>
					<cfif len(attributes.delivered)>
						AND 1 = 2
					</cfif>	
			</cfif>
			<cfif not len(attributes.cat) and not len(attributes.project_id)><!--- FBS 20080407 proje STOCK_EXCHANGE de olmadigindan bu kosula girmemeli --->
				UNION ALL
			</cfif>
			<cfif (len(attributes.cat) and listFind("116",listfirst(attributes.cat,'-'))) or not len(attributes.cat) and not len(attributes.project_id)><!--- FBS 20080407 proje STOCK_EXCHANGE de olmadigindan bu kosula girmemeli --->
				SELECT
					3 TABLE_TYPE,
					STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
					'' PROJECT_ID,
                    '' PROJECT_HEAD_IN,
				<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
					'' NAME_PRODUCT,
					'' STOCK_CODE,
					0 PRODUCT_ID,
					0 AMOUNT,
					0 PRICE,
					NULL LOT_NO,
				</cfif>
					-1 PURCHASE_SALES,
					STOCK_EXCHANGE_ID ISLEM_ID,
					EXCHANGE_NUMBER BELGE_NO,
					'' REFERANS,
					PROCESS_TYPE ISLEM_TIPI,
					PROCESS_DATE ISLEM_TARIHI,
					0 COMPANY_ID,
					0 CONSUMER_ID,
					0 PARTNER_ID,
					0 EMPLOYEE_ID,
					DEPARTMENT_ID DEPARTMENT_ID,
					LOCATION_ID LOCATION,
					EXIT_DEPARTMENT_ID DEPARTMENT_ID_2,
					EXIT_LOCATION_ID LOCATION_2,
					'' INVOICE_NUMBER,
					'' DELIVER_EMP,
					RECORD_DATE,
					0 IS_STOCK_TRANSFER,
					STOCK_EXCHANGE_TYPE
				FROM
					STOCK_EXCHANGE WITH (NOLOCK)
				WHERE 
				<cfif len(attributes.cat) and listlast(attributes.cat,'-') eq 0>
					STOCK_EXCHANGE.PROCESS_TYPE = #listfirst(attributes.cat,'-')#
				<cfelseif len(attributes.cat) and listlast(attributes.cat,'-') neq 0>
					STOCK_EXCHANGE.PROCESS_CAT = #listlast(attributes.cat,'-')#
				<cfelse>
					STOCK_EXCHANGE.STOCK_EXCHANGE_ID IS NOT NULL
				</cfif>
				<cfif isdefined('attributes.lot_no') and Len(attributes.lot_no)>
					AND 1 = 0
				</cfif>
				<cfif len(attributes.product_cat_code) and len(attributes.product_cat_name)>
					AND STOCK_EXCHANGE.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #dsn1_alias#.PRODUCT P WHERE P.PRODUCT_CODE LIKE '#attributes.product_cat_code#.%')
				</cfif>
				<cfif len(attributes.record_date)>
					AND STOCK_EXCHANGE.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">
					AND STOCK_EXCHANGE.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,attributes.record_date)#">
				</cfif>
				<cfif len(attributes.date1) and  len(attributes.date2)>
					AND STOCK_EXCHANGE.PROCESS_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.date2#">
				</cfif>
				<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
					AND STOCK_EXCHANGE.STOCK_EXCHANGE_ID = -1<!--- Böyle bir kayıt olamaz, sisteme göre filtrelediğinde bu kayıtları getirmesn diye eklendi --->
				</cfif>
				<cfif len(attributes.department_id)>
					<cfif listlen(attributes.department_id,'-') eq 1>
						AND (DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> OR EXIT_DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">)
					<cfelse>
						AND ((DEPARTMENT_ID =  #listfirst(attributes.department_id,'-')# AND LOCATION_ID = #listlast(attributes.department_id,'-')#) OR
						(EXIT_DEPARTMENT_ID = #listfirst(attributes.department_id,'-')# AND EXIT_LOCATION_ID = #listlast(attributes.department_id,'-')#))						
					</cfif>
				<cfelseif session.ep.isBranchAuthorization>
					AND 
					(
						DEPARTMENT_ID IN (#valuelist(get_my_department.department_id)#) OR
						EXIT_DEPARTMENT_ID IN (#valuelist(get_my_department.department_id)#)
					)		
				</cfif>				  
				<cfif len(attributes.belge_no)>
					AND (EXCHANGE_NUMBER LIKE '<cfif len(attributes.belge_no) gt 3>%</cfif>#attributes.belge_no#%')
				</cfif>
				<cfif len(attributes.stock_id) and len(attributes.product_name)>
					AND STOCK_EXCHANGE.STOCK_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
				</cfif>
				<cfif len(attributes.delivered)>
					AND 1 = 2
				</cfif>	
				<cfif (isdefined("attributes.deliver_emp_id") and len(attributes.deliver_emp_id)) and (isdefined("attributes.deliver_emp") and len(attributes.deliver_emp))>AND 1 = 0</cfif>
			</cfif>
		</cfif>
		<cfif attributes.oby eq 2>
			ORDER BY ISLEM_TARIHI
		<cfelseif attributes.oby eq 3>
			ORDER BY BELGE_NO
		<cfelseif attributes.oby eq 4>
			ORDER BY BELGE_NO DESC
		<cfelse>
			ORDER BY ISLEM_TARIHI DESC
		</cfif>	
	 </cfquery> 
<cfelse>
	<cfset get_ship_fis.recordcount=0>
</cfif>
