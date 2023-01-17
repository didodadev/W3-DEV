<cfset list_company = "">
<cfset list_consumer = "">
<cfif len(attributes.member_cat_type)>
	<cfloop from="1" to="#listlen(attributes.member_cat_type,',')#" index="ix">
		<cfset list_getir = listgetat(attributes.member_cat_type,ix,',')>
		<cfif listfirst(list_getir,'-') eq 1 and listlast(list_getir,'-') neq 0>
			<cfset list_company = listappend(list_company,listlast(list_getir,'-'),'-')>
		<cfelseif listfirst(list_getir,'-') eq 2 and listlast(list_getir,'-') neq 0>
			<cfset list_consumer = listappend(list_consumer,listlast(list_getir,'-'),'-')>
		</cfif>
		<cfset list_company = listsort(listdeleteduplicates(replace(list_company,"-",",","all"),','),'numeric','ASC',',')>
		<cfset list_consumer = listsort(listdeleteduplicates(replace(list_consumer,"-",",","all"),','),'numeric','ASC',',')>
	</cfloop>
</cfif>
<cfif not len(attributes.member_cat_value) or (attributes.member_cat_value eq 2 and (listfind(attributes.member_cat_type,'2-0',',') or  len(list_consumer) or not len(attributes.member_cat_type))) or (attributes.member_cat_value eq 1 and (listfind(attributes.member_cat_type ,'1-0',',') or len(list_company) or not len(attributes.member_cat_type)))>
	<cfquery name="get_total_purchase_1" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		<cfif attributes.member_cat_value neq 2>
			<!--- kurumsal üyeler --->
			<cfif listfind(attributes.member_cat_type ,'1-0',',') or len(list_company) or not len(attributes.member_cat_type)>
				SELECT
					<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
						SUM(I.NETTOTAL) NETTOTAL,
						SUM(I.NETTOTAL/IM.RATE2) NETTOTAL_DOVIZ,
						0 AS IADE_TOPLAM,
						0 AS IADE_TOPLAM_DOVIZ,
					<cfelse>
						0 AS IADE_TOPLAM,
						SUM(I.NETTOTAL) NETTOTAL,
					</cfif>
						ROUND(CR.BAKIYE,5) BAKIYE,
						ROUND(CR.BAKIYE2,5) BAKIYE2,
						ROUND(CR.BORC,5) BORC,
						ROUND(CR.BORC2,5) BORC2,
						ROUND(CR.ALACAK,5) ALACAK,
						ROUND(CR.ALACAK2,5) ALACAK2,
						ROUND(CR.VADE_BORC_NEW,5) VADE_BORC_NEW,
						ROUND(CR.VADE_ALACAK_NEW,5) VADE_ALACAK_NEW,
						ROUND(CR.OPEN_ACCOUNT_RISK_LIMIT,5) OPEN_ACCOUNT_RISK_LIMIT,
						ROUND(CR.TOTAL_RISK_LIMIT,5) TOTAL_RISK_LIMIT,
						ROUND(CR.FORWARD_SALE_LIMIT,5) FORWARD_SALE_LIMIT,
						ROUND(CR.CEK_KARSILIKSIZ,5) CEK_KARSILIKSIZ,
						ROUND(CR.CEK_KARSILIKSIZ2,5) CEK_KARSILIKSIZ2,
						ROUND(CR.SENET_KARSILIKSIZ,5) SENET_KARSILIKSIZ,
						ROUND(CR.SENET_KARSILIKSIZ2,5) SENET_KARSILIKSIZ2,
						ROUND(CR.CEK_ODENMEDI,5) CEK_ODENMEDI,
						ROUND(CR.CEK_ODENMEDI2,5) CEK_ODENMEDI2,
						ROUND(CR.SENET_ODENMEDI,5) SENET_ODENMEDI,
						ROUND(CR.SENET_ODENMEDI2,5) SENET_ODENMEDI2,
						ROUND(CR.SECURE_TOTAL_TAKE,5) SECURE_TOTAL_TAKE,
						ROUND(CR.SECURE_TOTAL_TAKE2,5) SECURE_TOTAL_TAKE2,
						ROUND(CR.SECURE_TOTAL_GIVE,5) SECURE_TOTAL_GIVE,
						ROUND(CR.SECURE_TOTAL_GIVE2,5) SECURE_TOTAL_GIVE2,	
						ROUND(CR.VADE_BORC-CR.VADE_ALACAK,5) VADE_PER,
						ROUND(CR.VADE_BORC_NEW-CR.VADE_ALACAK_NEW,5) VADE_PER_ORT,
						1 KONTROL,
					<cfif attributes.report_type eq 1>
						C.FULLNAME,
						C.COMPANY_ID PROCESS_ID,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.COUNTRY,
						C.CITY
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY PROCESS_ID
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID  PROCESS_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(I.CUSTOMER_VALUE_ID,0)  PROCESS_ID
					<cfelseif attributes.report_type eq 5> 
						WP.POSITION_CODE  PROCESS_ID
					<cfelseif attributes.report_type eq 7> 
						C.COMPANYCAT_ID  PROCESS_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(CITY,0)  PROCESS_ID
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,CR.OTHER_MONEY
						,ROUND(CR.FORWARD_SALE_LIMIT3,5) FORWARD_SALE_LIMIT3
						,ROUND(CR.OPEN_ACCOUNT_RISK_LIMIT3,5) OPEN_ACCOUNT_RISK_LIMIT3
					</cfif>
				FROM
					INVOICE I,	
					<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
						INVOICE_MONEY IM,
					</cfif>
						#dsn_alias#.COMPANY C,
					<cfif attributes.report_type eq 3>
						#dsn_alias#.SETUP_IMS_CODE SIC,
					<cfelseif attributes.report_type eq 5>
						#dsn_alias#.WORKGROUP_EMP_PAR WP,
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						COMPANY_RISK_MONEY CR
					<cfelse>
						COMPANY_RISK CR
					</cfif>
				WHERE
					I.PURCHASE_SALES = 1 AND
					I.IS_IPTAL = 0 AND
					I.NETTOTAL > 0 AND
					<cfif not isDefined("attributes.is_all_member")>
						(CR.BAKIYE+CR.CEK_KARSILIKSIZ+CR.CEK_ODENMEDI+CR.SENET_ODENMEDI+CR.SENET_KARSILIKSIZ) > 0 AND
					</cfif>
					<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
						IM.ACTION_ID = I.INVOICE_ID AND
						<cfif isdefined("attributes.is_money3")>
							IM.MONEY_TYPE = I.OTHER_MONEY AND
							IM.MONEY_TYPE = CR.OTHER_MONEY AND
						<cfelse>
							IM.MONEY_TYPE = '#session.ep.money2#' AND
						</cfif>
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						I.COMPANY_ID = #attributes.company_id# AND
					</cfif>
					<cfif len(list_company)>
						C.COMPANYCAT_ID IN(#list_company#) AND
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND OUR_COMPANY_ID = #session.ep.company_id# AND IS_MASTER=1) AND
					</cfif>
						I.COMPANY_ID = C.COMPANY_ID AND
					<cfif attributes.report_type eq 2>
						C.SALES_COUNTY IS NOT NULL AND
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID = SIC.IMS_CODE_ID AND
					<cfelseif attributes.report_type eq 5>
						I.COMPANY_ID = WP.COMPANY_ID AND
						WP.IS_MASTER = 1 AND
						WP.OUR_COMPANY_ID = #session.ep.company_id# AND 
					</cfif>
						I.INVOICE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.date1#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.date2#"> AND
						I.COMPANY_ID = CR.COMPANY_ID
					<cfif isdefined("attributes.customer_value_id") and len(attributes.customer_value_id)>
						AND I.CUSTOMER_VALUE_ID = #attributes.customer_value_id#
					</cfif>
					<cfif isdefined("attributes.resource_id") and len(attributes.resource_id)>
						AND I.RESOURCE_ID = #attributes.resource_id#
					</cfif>
					<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND I.IMS_CODE_ID = #attributes.ims_code_id#
					</cfif>
					<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
						AND C.SALES_COUNTY = #attributes.zone_id#
					</cfif>
					<cfif isdefined("attributes.member_status") and attributes.member_status gte 0>
						AND C.COMPANY_STATUS = #attributes.member_status#
					</cfif>
				GROUP BY
					BAKIYE,
					BAKIYE2,
					BORC,
					BORC2,
					ALACAK,
					ALACAK2,
					OPEN_ACCOUNT_RISK_LIMIT,
					TOTAL_RISK_LIMIT,
					FORWARD_SALE_LIMIT,
					CEK_KARSILIKSIZ,
					CEK_KARSILIKSIZ2,
					SENET_KARSILIKSIZ,
					SENET_KARSILIKSIZ2,
					CEK_ODENMEDI,
					CEK_ODENMEDI2,
					SENET_ODENMEDI,
					SENET_ODENMEDI2,
					SECURE_TOTAL_TAKE,
					SECURE_TOTAL_TAKE2,
					SECURE_TOTAL_GIVE,
					SECURE_TOTAL_GIVE2,	
					VADE_BORC,
					VADE_ALACAK,
					VADE_BORC_NEW,
					VADE_ALACAK_NEW,
					<cfif attributes.report_type eq 1>
						C.FULLNAME,
						C.COMPANY_ID,
						C.MEMBER_CODE,
						C.COUNTRY,
						C.CITY
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(I.CUSTOMER_VALUE_ID,0)
					<cfelseif attributes.report_type eq 5>
						WP.POSITION_CODE
					<cfelseif attributes.report_type eq 7>
						C.COMPANYCAT_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(CITY,0)
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,CR.OTHER_MONEY
						,FORWARD_SALE_LIMIT3
						,OPEN_ACCOUNT_RISK_LIMIT3
					</cfif>
				UNION ALL
				SELECT
					<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
						0 AS NETTOTAL,
						0 AS NETTOTAL_DOVIZ,
						0 AS IADE_TOPLAM,
						0 AS IADE_TOPLAM_DOVIZ,
					<cfelse>
						0 AS IADE_TOPLAM,
						0 AS NETTOTAL,
					</cfif>
						ROUND(CR.BAKIYE,5) BAKIYE,
						ROUND(CR.BAKIYE2,5) BAKIYE2,
						ROUND(CR.BORC,5) BORC,
						ROUND(CR.BORC2,5) BORC2,
						ROUND(CR.ALACAK,5) ALACAK,
						ROUND(CR.ALACAK2,5) ALACAK2,
						ROUND(CR.VADE_BORC_NEW,5) VADE_BORC_NEW,
						ROUND(CR.VADE_ALACAK_NEW,5) VADE_ALACAK_NEW,
						ROUND(CR.OPEN_ACCOUNT_RISK_LIMIT,5) OPEN_ACCOUNT_RISK_LIMIT,
						ROUND(CR.TOTAL_RISK_LIMIT,5) TOTAL_RISK_LIMIT,
						ROUND(CR.FORWARD_SALE_LIMIT,5) FORWARD_SALE_LIMIT,
						ROUND(CR.CEK_KARSILIKSIZ,5) CEK_KARSILIKSIZ,
						ROUND(CR.CEK_KARSILIKSIZ2,5) CEK_KARSILIKSIZ2,
						ROUND(CR.SENET_KARSILIKSIZ,5) SENET_KARSILIKSIZ,
						ROUND(CR.SENET_KARSILIKSIZ2,5) SENET_KARSILIKSIZ2,
						ROUND(CR.CEK_ODENMEDI,5) CEK_ODENMEDI,
						ROUND(CR.CEK_ODENMEDI2,5) CEK_ODENMEDI2,
						ROUND(CR.SENET_ODENMEDI,5) SENET_ODENMEDI,
						ROUND(CR.SENET_ODENMEDI2,5) SENET_ODENMEDI2,
						ROUND(CR.SECURE_TOTAL_TAKE,5) SECURE_TOTAL_TAKE,
						ROUND(CR.SECURE_TOTAL_TAKE2,5) SECURE_TOTAL_TAKE2,
						ROUND(CR.SECURE_TOTAL_GIVE,5) SECURE_TOTAL_GIVE,
						ROUND(CR.SECURE_TOTAL_GIVE2,5) SECURE_TOTAL_GIVE2,	
						ROUND(CR.VADE_BORC-CR.VADE_ALACAK,5) VADE_PER,
						ROUND(CR.VADE_BORC_NEW-CR.VADE_ALACAK_NEW,5) VADE_PER_ORT,
						1 KONTROL,
					<cfif attributes.report_type eq 1>
						C.FULLNAME,
						C.COMPANY_ID PROCESS_ID,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.COUNTRY,
						C.CITY
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY PROCESS_ID
					<cfelseif attributes.report_type eq 3>
						C.IMS_CODE_ID PROCESS_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(C.COMPANY_VALUE_ID,0) PROCESS_ID
					<cfelseif attributes.report_type eq 5> 
						WP.POSITION_CODE PROCESS_ID
					<cfelseif attributes.report_type eq 7> 
						C.COMPANYCAT_ID PROCESS_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(CITY,0) PROCESS_ID
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,CR.OTHER_MONEY
						,ROUND(CR.FORWARD_SALE_LIMIT3,5) FORWARD_SALE_LIMIT3
						,ROUND(CR.OPEN_ACCOUNT_RISK_LIMIT3,5) OPEN_ACCOUNT_RISK_LIMIT3
					</cfif>
				FROM
					#dsn_alias#.COMPANY C,
					<cfif attributes.report_type eq 3>
						#dsn_alias#.SETUP_IMS_CODE SIC,
					<cfelseif attributes.report_type eq 5>
						#dsn_alias#.WORKGROUP_EMP_PAR WP,
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						COMPANY_RISK_MONEY CR
					<cfelse>
						COMPANY_RISK CR
					</cfif>
				WHERE
					<cfif not isDefined("attributes.is_all_member")>
						(CR.BAKIYE+CR.CEK_KARSILIKSIZ+CR.CEK_ODENMEDI+CR.SENET_ODENMEDI+CR.SENET_KARSILIKSIZ) > 0 AND
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						CR.COMPANY_ID = #attributes.company_id# AND
					</cfif>
					<cfif len(list_company)>
						C.COMPANYCAT_ID IN(#list_company#) AND
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						CR.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND OUR_COMPANY_ID = #session.ep.company_id# AND IS_MASTER=1) AND
					</cfif>
					CR.COMPANY_ID = C.COMPANY_ID AND
					<cfif attributes.report_type eq 2>
						C.SALES_COUNTY IS NOT NULL AND
					<cfelseif attributes.report_type eq 3>
						C.IMS_CODE_ID = SIC.IMS_CODE_ID AND
					<cfelseif attributes.report_type eq 5>
						C.COMPANY_ID = WP.COMPANY_ID AND
						WP.IS_MASTER = 1 AND
						WP.OUR_COMPANY_ID = #session.ep.company_id# AND 
					</cfif>
					CR.COMPANY_ID NOT IN(SELECT COMPANY_ID FROM INVOICE WHERE INVOICE_DATE BETWEEN #attributes.date1# AND #attributes.date2# AND COMPANY_ID IS NOT NULL AND IS_IPTAL = 0 AND NETTOTAL >0 AND PURCHASE_SALES = 1 <cfif isdefined("attributes.is_money3")>AND OTHER_MONEY = CR.OTHER_MONEY</cfif>)
					<cfif isdefined("attributes.customer_value_id") and len(attributes.customer_value_id)>
						AND C.COMPANY_VALUE_ID = #attributes.customer_value_id#
					</cfif>
					<cfif isdefined("attributes.resource_id") and len(attributes.resource_id)>
						AND C.RESOURCE_ID = #attributes.resource_id#
					</cfif>
					<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND C.IMS_CODE_ID = #attributes.ims_code_id#
					</cfif>
					<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
						AND C.SALES_COUNTY = #attributes.zone_id#
					</cfif>
					<cfif isdefined("attributes.member_status") and attributes.member_status gte 0>
						AND C.COMPANY_STATUS = #attributes.member_status#
					</cfif>
				GROUP BY
					BAKIYE,
					BAKIYE2,
					BORC,
					BORC2,
					ALACAK,
					ALACAK2,
					OPEN_ACCOUNT_RISK_LIMIT,
					TOTAL_RISK_LIMIT,
					FORWARD_SALE_LIMIT,
					CEK_KARSILIKSIZ,
					CEK_KARSILIKSIZ2,
					SENET_KARSILIKSIZ,
					SENET_KARSILIKSIZ2,
					CEK_ODENMEDI,
					CEK_ODENMEDI2,
					SENET_ODENMEDI,
					SENET_ODENMEDI2,
					SECURE_TOTAL_TAKE,
					SECURE_TOTAL_TAKE2,
					SECURE_TOTAL_GIVE,
					SECURE_TOTAL_GIVE2,	
					VADE_BORC,
					VADE_ALACAK,
					VADE_BORC_NEW,
					VADE_ALACAK_NEW,
					<cfif attributes.report_type eq 1>
						C.FULLNAME,
						C.COMPANY_ID,
						C.MEMBER_CODE,
						C.COUNTRY,
						C.CITY
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY
					<cfelseif attributes.report_type eq 3>
						C.IMS_CODE_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(C.COMPANY_VALUE_ID,0)
					<cfelseif attributes.report_type eq 5>
						WP.POSITION_CODE
					<cfelseif attributes.report_type eq 7>
						C.COMPANYCAT_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(CITY,0)
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,CR.OTHER_MONEY
						,FORWARD_SALE_LIMIT3
						,OPEN_ACCOUNT_RISK_LIMIT3
					</cfif>
			</cfif>
		</cfif>
		<cfif attributes.member_cat_value neq 1 and attributes.member_cat_value neq 2>
			<cfif not len(attributes.member_cat_type) or ((listfind(attributes.member_cat_type,'1-0',',') or len(list_company)) and (listfind(attributes.member_cat_type,'2-0',',') or len(list_consumer)))>
				UNION ALL
			</cfif>
		</cfif>
		<cfif attributes.member_cat_value neq 1>
			<!--- bireysel üyeler --->
			<cfif listfind(attributes.member_cat_type,'2-0',',') or  len(list_consumer) or not len(attributes.member_cat_type)>
				SELECT
					<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
						SUM(I.NETTOTAL) NETTOTAL,
						SUM(I.NETTOTAL/IM.RATE2) NETTOTAL_DOVIZ,
						0 AS IADE_TOPLAM,
						0 AS IADE_TOPLAM_DOVIZ,
					<cfelse>
						0 AS IADE_TOPLAM,
						SUM(I.NETTOTAL) NETTOTAL,
					</cfif>
						ROUND(CR.BAKIYE,5) BAKIYE,
						ROUND(CR.BAKIYE2,5) BAKIYE2,
						ROUND(CR.BORC,5) BORC,
						ROUND(CR.BORC2,5) BORC2,
						ROUND(CR.ALACAK,5) ALACAK,
						ROUND(CR.ALACAK2,5) ALACAK2,
						ROUND(CR.VADE_BORC_NEW,5) VADE_BORC_NEW,
						ROUND(CR.VADE_ALACAK_NEW,5) VADE_ALACAK_NEW,
						ROUND(CR.OPEN_ACCOUNT_RISK_LIMIT,5) OPEN_ACCOUNT_RISK_LIMIT,
						ROUND(CR.TOTAL_RISK_LIMIT,5) TOTAL_RISK_LIMIT,
						ROUND(CR.FORWARD_SALE_LIMIT,5) FORWARD_SALE_LIMIT,
						ROUND(CR.CEK_KARSILIKSIZ,5) CEK_KARSILIKSIZ,
						ROUND(CR.CEK_KARSILIKSIZ2,5) CEK_KARSILIKSIZ2,
						ROUND(CR.SENET_KARSILIKSIZ,5) SENET_KARSILIKSIZ,
						ROUND(CR.SENET_KARSILIKSIZ2,5) SENET_KARSILIKSIZ2,
						ROUND(CR.CEK_ODENMEDI,5) CEK_ODENMEDI,
						ROUND(CR.CEK_ODENMEDI2,5) CEK_ODENMEDI2,
						ROUND(CR.SENET_ODENMEDI,5) SENET_ODENMEDI,
						ROUND(CR.SENET_ODENMEDI2,5) SENET_ODENMEDI2,
						ROUND(CR.SECURE_TOTAL_TAKE,5) SECURE_TOTAL_TAKE,
						ROUND(CR.SECURE_TOTAL_TAKE2,5) SECURE_TOTAL_TAKE2,
						ROUND(CR.SECURE_TOTAL_GIVE,5) SECURE_TOTAL_GIVE,
						ROUND(CR.SECURE_TOTAL_GIVE2,5) SECURE_TOTAL_GIVE2,	
						ROUND(CR.VADE_BORC-CR.VADE_ALACAK,5) VADE_PER,
						ROUND(CR.VADE_BORC_NEW-CR.VADE_ALACAK_NEW,5) VADE_PER_ORT,
						0 KONTROL,
					<cfif attributes.report_type eq 1>
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FULLNAME,
						C.CONSUMER_ID PROCESS_ID,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.TAX_COUNTRY_ID COUNTRY,
						C.TAX_CITY_ID CITY
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY PROCESS_ID
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID PROCESS_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(I.CUSTOMER_VALUE_ID,0) PROCESS_ID
					<cfelseif attributes.report_type eq 5> 
						WP.POSITION_CODE PROCESS_ID
					<cfelseif attributes.report_type eq 7> 
						C.CONSUMER_CAT_ID PROCESS_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(C.WORK_CITY_ID,0) PROCESS_ID
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,CR.OTHER_MONEY
						,ROUND(CR.FORWARD_SALE_LIMIT3,5) FORWARD_SALE_LIMIT3
						,ROUND(CR.OPEN_ACCOUNT_RISK_LIMIT3,5) OPEN_ACCOUNT_RISK_LIMIT3
					</cfif>
				FROM
					INVOICE I,	
					<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
						INVOICE_MONEY IM,
					</cfif>
						#dsn_alias#.CONSUMER C,
					<cfif attributes.report_type eq 3>
						#dsn_alias#.SETUP_IMS_CODE SIC,
					<cfelseif attributes.report_type eq 5>
						#dsn_alias#.WORKGROUP_EMP_PAR WP,
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						CONSUMER_RISK_MONEY CR
					<cfelse>
						CONSUMER_RISK CR
					</cfif>
				WHERE
					I.PURCHASE_SALES = 1 AND
					I.IS_IPTAL = 0 AND
					I.NETTOTAL > 0 AND
					<cfif not isDefined("attributes.is_all_member")>
						(CR.BAKIYE+CR.CEK_KARSILIKSIZ+CR.CEK_ODENMEDI+CR.SENET_ODENMEDI+CR.SENET_KARSILIKSIZ) > 0 AND
					</cfif>
					<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
						IM.ACTION_ID = I.INVOICE_ID AND
						<cfif isdefined("attributes.is_money3")>
							IM.MONEY_TYPE = I.OTHER_MONEY AND
							IM.MONEY_TYPE = CR.OTHER_MONEY AND
						<cfelse>
							IM.MONEY_TYPE = '#session.ep.money2#' AND
						</cfif>
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
						I.CONSUMER_ID = #attributes.consumer_id# AND
					</cfif>
					<cfif len(list_consumer)>
						C.CONSUMER_CAT_ID IN(#list_consumer#) AND
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND OUR_COMPANY_ID = #session.ep.company_id# AND IS_MASTER=1) AND
					</cfif>
						I.CONSUMER_ID = C.CONSUMER_ID AND
					<cfif attributes.report_type eq 2>
						C.SALES_COUNTY IS NOT NULL AND
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID = SIC.IMS_CODE_ID AND
					<cfelseif attributes.report_type eq 5>
						I.CONSUMER_ID = WP.CONSUMER_ID AND
						WP.IS_MASTER = 1 AND
						WP.OUR_COMPANY_ID = #session.ep.company_id# AND 
					</cfif>
						I.INVOICE_DATE BETWEEN #attributes.date1# AND #attributes.date2# AND
						I.CONSUMER_ID = CR.CONSUMER_ID
					<cfif len(attributes.customer_value_id)>
						AND I.CUSTOMER_VALUE_ID = #attributes.customer_value_id#
					</cfif>
					<cfif len(attributes.resource_id)>
						AND I.RESOURCE_ID = #attributes.resource_id#
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND I.IMS_CODE_ID = #attributes.ims_code_id#
					</cfif>
					<cfif len(attributes.zone_id)>
						AND C.SALES_COUNTY = #attributes.zone_id#
					</cfif>
					<cfif attributes.member_status gte 0>
						AND C.CONSUMER_STATUS = #attributes.member_status#
					</cfif>
				GROUP BY
					BAKIYE,
					BAKIYE2,
					BORC,
					BORC2,
					ALACAK,
					ALACAK2,
					OPEN_ACCOUNT_RISK_LIMIT,
					TOTAL_RISK_LIMIT,
					FORWARD_SALE_LIMIT,
					CEK_KARSILIKSIZ,
					CEK_KARSILIKSIZ2,
					SENET_KARSILIKSIZ,
					SENET_KARSILIKSIZ2,
					CEK_ODENMEDI,
					CEK_ODENMEDI2,
					SENET_ODENMEDI,
					SENET_ODENMEDI2,
					SECURE_TOTAL_TAKE,
					SECURE_TOTAL_TAKE2,
					SECURE_TOTAL_GIVE,
					SECURE_TOTAL_GIVE2,	
					VADE_BORC,
					VADE_ALACAK,
					VADE_BORC_NEW,
					VADE_ALACAK_NEW,
					<cfif attributes.report_type eq 1>
						C.CONSUMER_NAME,
						C.CONSUMER_SURNAME,
						C.CONSUMER_ID,
						C.MEMBER_CODE,
						C.TAX_COUNTRY_ID,
						C.TAX_CITY_ID
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID,
						IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(I.CUSTOMER_VALUE_ID,0)
					<cfelseif attributes.report_type eq 5>
						WP.POSITION_CODE
					<cfelseif attributes.report_type eq 7>
						C.CONSUMER_CAT_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(C.WORK_CITY_ID,0)
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,CR.OTHER_MONEY
						,FORWARD_SALE_LIMIT3
						,OPEN_ACCOUNT_RISK_LIMIT3
					</cfif>
				UNION ALL
				SELECT
					<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
						0 AS NETTOTAL,
						0 AS NETTOTAL_DOVIZ,
						0 AS IADE_TOPLAM,
						0 AS IADE_TOPLAM_DOVIZ,
					<cfelse>
						0 AS IADE_TOPLAM,
						0 AS NETTOTAL,
					</cfif>
						ROUND(CR.BAKIYE,5) BAKIYE,
						ROUND(CR.BAKIYE2,5) BAKIYE2,
						ROUND(CR.BORC,5) BORC,
						ROUND(CR.BORC2,5) BORC2,
						ROUND(CR.ALACAK,5) ALACAK,
						ROUND(CR.ALACAK2,5) ALACAK2,
						ROUND(CR.VADE_BORC_NEW,5) VADE_BORC_NEW,
						ROUND(CR.VADE_ALACAK_NEW,5) VADE_ALACAK_NEW,
						ROUND(CR.OPEN_ACCOUNT_RISK_LIMIT,5) OPEN_ACCOUNT_RISK_LIMIT,
						ROUND(CR.TOTAL_RISK_LIMIT,5) TOTAL_RISK_LIMIT,
						ROUND(CR.FORWARD_SALE_LIMIT,5) FORWARD_SALE_LIMIT,
						ROUND(CR.CEK_KARSILIKSIZ,5) CEK_KARSILIKSIZ,
						ROUND(CR.CEK_KARSILIKSIZ2,5) CEK_KARSILIKSIZ2,
						ROUND(CR.SENET_KARSILIKSIZ,5) SENET_KARSILIKSIZ,
						ROUND(CR.SENET_KARSILIKSIZ2,5) SENET_KARSILIKSIZ2,
						ROUND(CR.CEK_ODENMEDI,5) CEK_ODENMEDI,
						ROUND(CR.CEK_ODENMEDI2,5) CEK_ODENMEDI2,
						ROUND(CR.SENET_ODENMEDI,5) SENET_ODENMEDI,
						ROUND(CR.SENET_ODENMEDI2,5) SENET_ODENMEDI2,
						ROUND(CR.SECURE_TOTAL_TAKE,5) SECURE_TOTAL_TAKE,
						ROUND(CR.SECURE_TOTAL_TAKE2,5) SECURE_TOTAL_TAKE2,
						ROUND(CR.SECURE_TOTAL_GIVE,5) SECURE_TOTAL_GIVE,
						ROUND(CR.SECURE_TOTAL_GIVE2,5) SECURE_TOTAL_GIVE2,	
						ROUND(CR.VADE_BORC-CR.VADE_ALACAK,5) VADE_PER,
						ROUND(CR.VADE_BORC_NEW-CR.VADE_ALACAK_NEW,5) VADE_PER_ORT,
						0 KONTROL,
					<cfif attributes.report_type eq 1>
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FULLNAME,
						C.CONSUMER_ID PROCESS_ID,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.TAX_COUNTRY_ID COUNTRY,
						C.TAX_CITY_ID CITY
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY PROCESS_ID
					<cfelseif attributes.report_type eq 3>
						C.IMS_CODE_ID PROCESS_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(C.CUSTOMER_VALUE_ID,0) PROCESS_ID
					<cfelseif attributes.report_type eq 5> 
						WP.POSITION_CODE PROCESS_ID
					<cfelseif attributes.report_type eq 7> 
						C.CONSUMER_CAT_ID PROCESS_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(C.WORK_CITY_ID,0) PROCESS_ID
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,CR.OTHER_MONEY
						,ROUND(CR.FORWARD_SALE_LIMIT3,5) FORWARD_SALE_LIMIT3
						,ROUND(CR.OPEN_ACCOUNT_RISK_LIMIT3,5) OPEN_ACCOUNT_RISK_LIMIT3
					</cfif>
				FROM
					#dsn_alias#.CONSUMER C,
					<cfif attributes.report_type eq 3>
						#dsn_alias#.SETUP_IMS_CODE SIC,
					<cfelseif attributes.report_type eq 5>
						#dsn_alias#.WORKGROUP_EMP_PAR WP,
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						CONSUMER_RISK_MONEY CR
					<cfelse>
						CONSUMER_RISK CR
					</cfif>
				WHERE
					<cfif not isDefined("attributes.is_all_member")>
						(CR.BAKIYE+CR.CEK_KARSILIKSIZ+CR.CEK_ODENMEDI+CR.SENET_ODENMEDI+CR.SENET_KARSILIKSIZ) > 0 AND
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
						CR.CONSUMER_ID = #attributes.consumer_id# AND
					</cfif>
					<cfif len(list_consumer)>
						C.CONSUMER_CAT_ID IN(#list_consumer#) AND
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						CR.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND OUR_COMPANY_ID = #session.ep.company_id# AND IS_MASTER=1) AND
					</cfif>
					CR.CONSUMER_ID = C.CONSUMER_ID AND
					<cfif attributes.report_type eq 2>
						C.SALES_COUNTY IS NOT NULL AND
					<cfelseif attributes.report_type eq 3>
						C.IMS_CODE_ID = SIC.IMS_CODE_ID AND
					<cfelseif attributes.report_type eq 5>
						C.CONSUMER_ID = WP.CONSUMER_ID AND
						WP.IS_MASTER = 1 AND
						WP.OUR_COMPANY_ID = #session.ep.company_id# AND 
					</cfif>
					CR.CONSUMER_ID NOT IN(SELECT CONSUMER_ID FROM INVOICE WHERE INVOICE_DATE BETWEEN #attributes.date1# AND #attributes.date2# AND CONSUMER_ID IS NOT NULL AND IS_IPTAL = 0 AND NETTOTAL >0 AND PURCHASE_SALES = 1 <cfif isdefined("attributes.is_money3")>AND OTHER_MONEY = CR.OTHER_MONEY</cfif>)
					<cfif len(attributes.customer_value_id)>
						AND C.CUSTOMER_VALUE_ID = #attributes.customer_value_id#
					</cfif>
					<cfif len(attributes.resource_id)>
						AND C.RESOURCE_ID = #attributes.resource_id#
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND C.IMS_CODE_ID = #attributes.ims_code_id#
					</cfif>
					<cfif len(attributes.zone_id)>
						AND C.SALES_COUNTY = #attributes.zone_id#
					</cfif>
					<cfif attributes.member_status gte 0>
						AND C.CONSUMER_STATUS = #attributes.member_status#
					</cfif>
				GROUP BY
					BAKIYE,
					BAKIYE2,
					BORC,
					BORC2,
					ALACAK,
					ALACAK2,
					OPEN_ACCOUNT_RISK_LIMIT,
					TOTAL_RISK_LIMIT,
					FORWARD_SALE_LIMIT,
					CEK_KARSILIKSIZ,
					CEK_KARSILIKSIZ2,
					SENET_KARSILIKSIZ,
					SENET_KARSILIKSIZ2,
					CEK_ODENMEDI,
					CEK_ODENMEDI2,
					SENET_ODENMEDI,
					SENET_ODENMEDI2,
					SECURE_TOTAL_TAKE,
					SECURE_TOTAL_TAKE2,
					SECURE_TOTAL_GIVE,
					SECURE_TOTAL_GIVE2,	
					VADE_BORC,
					VADE_ALACAK,
					VADE_BORC_NEW,
					VADE_ALACAK_NEW,
					<cfif attributes.report_type eq 1>
						C.CONSUMER_NAME,
						C.CONSUMER_SURNAME,
						C.CONSUMER_ID,
						C.MEMBER_CODE,
						C.TAX_COUNTRY_ID,
						C.TAX_CITY_ID
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY
					<cfelseif attributes.report_type eq 3>
						C.IMS_CODE_ID,
						IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(C.CUSTOMER_VALUE_ID,0)
					<cfelseif attributes.report_type eq 5>
						WP.POSITION_CODE
					<cfelseif attributes.report_type eq 7>
						C.CONSUMER_CAT_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(C.WORK_CITY_ID,0)
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,CR.OTHER_MONEY
						,FORWARD_SALE_LIMIT3
						,OPEN_ACCOUNT_RISK_LIMIT3
					</cfif>
			</cfif>
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_total_purchase_1.recordcount = 0>
</cfif>
<cfif not len(attributes.member_cat_value) or (attributes.member_cat_value eq 2 and (listfind(attributes.member_cat_type,'2-0',',') or  len(list_consumer) or not len(attributes.member_cat_type))) or (attributes.member_cat_value eq 1 and (listfind(attributes.member_cat_type ,'1-0',',') or len(list_company) or not len(attributes.member_cat_type)))>
	<cfquery name="get_total_purchase_2" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
		<!--- kurumsal üyeler iade --->
		<cfif attributes.member_cat_value neq 2>
			<cfif listfind(attributes.member_cat_type ,'1-0',',') or len(list_company) or not len(attributes.member_cat_type)>
				SELECT
				<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
					0 AS NETTOTAL,
					0 AS NETTOTAL_DOVIZ,
					SUM(I.NETTOTAL) IADE_TOPLAM,
					SUM(I.NETTOTAL/IM.RATE2) IADE_TOPLAM_DOVIZ,
				<cfelse>
					0 AS NETTOTAL,
					SUM(I.NETTOTAL) IADE_TOPLAM,
				</cfif>
					0 AS BAKIYE,
					0 AS BAKIYE2,
					0 AS BORC,
					0 AS BORC2,
					0 AS ALACAK,
					0 AS ALACAK2,
					0 AS VADE_BORC_NEW,
					0 AS VADE_ALACAK_NEW,
					0 AS OPEN_ACCOUNT_RISK_LIMIT,
					0 AS TOTAL_RISK_LIMIT,
					0 AS FORWARD_SALE_LIMIT,
					0 AS CEK_KARSILIKSIZ,
					0 AS CEK_KARSILIKSIZ2,
					0 AS SENET_KARSILIKSIZ,
					0 AS SENET_KARSILIKSIZ2,
					0 AS CEK_ODENMEDI,
					0 AS CEK_ODENMEDI2,
					0 AS SENET_ODENMEDI,
					0 AS SENET_ODENMEDI2,
					0 AS SECURE_TOTAL_TAKE,
					0 AS SECURE_TOTAL_TAKE2,
					0 AS SECURE_TOTAL_GIVE,
					0 AS SECURE_TOTAL_GIVE2,	
					0 AS VADE_PER,
					0 AS VADE_PER_ORT,
					1 KONTROL,
					<cfif attributes.report_type eq 1>
						C.FULLNAME,
						C.COMPANY_ID PROCESS_ID,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.COUNTRY,
						C.CITY
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY PROCESS_ID
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID PROCESS_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(I.CUSTOMER_VALUE_ID,0) PROCESS_ID
					<cfelseif attributes.report_type eq 5> 
						WP.POSITION_CODE PROCESS_ID
					<cfelseif attributes.report_type eq 7> 
						C.COMPANYCAT_ID PROCESS_ID
					<cfelseif attributes.report_type eq 8> 
						ISNULL(CITY,0) PROCESS_ID
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,I.OTHER_MONEY
						,0 AS FORWARD_SALE_LIMIT3
						,0 AS OPEN_ACCOUNT_RISK_LIMIT3
					</cfif>
				FROM
					INVOICE I,
					#dsn_alias#.COMPANY C
				<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
					,INVOICE_MONEY IM
				</cfif>
				<cfif attributes.report_type eq 3>
					,#dsn_alias#.SETUP_IMS_CODE SIC
				<cfelseif attributes.report_type eq 5>
					,#dsn_alias#.WORKGROUP_EMP_PAR WP
				</cfif>
				WHERE
					I.INVOICE_CAT IN (55,54,51,63) AND
					I.IS_IPTAL = 0 AND
					I.NETTOTAL > 0 AND
					<cfif not isDefined("attributes.is_all_member")>
						 I.COMPANY_ID IN (SELECT CR.COMPANY_ID FROM COMPANY_RISK CR WHERE (CR.BAKIYE+CR.CEK_KARSILIKSIZ+CR.CEK_ODENMEDI+CR.SENET_ODENMEDI+CR.SENET_KARSILIKSIZ) > 0) AND
					</cfif>
					<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
						IM.ACTION_ID = I.INVOICE_ID AND
						<cfif isdefined("attributes.is_money3")>
							IM.MONEY_TYPE = I.OTHER_MONEY AND
						<cfelse>
							IM.MONEY_TYPE = '#session.ep.money2#' AND
						</cfif>
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.company_id)>
						I.COMPANY_ID = #attributes.company_id# AND
					</cfif>
					<cfif len(list_company)>
						C.COMPANYCAT_ID IN(#list_company#) AND
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
						I.CONSUMER_ID = #attributes.consumer_id# AND
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						I.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND OUR_COMPANY_ID = #session.ep.company_id# AND IS_MASTER=1) AND
					</cfif>
						I.COMPANY_ID = C.COMPANY_ID AND
					<cfif attributes.report_type eq 2>
						C.SALES_COUNTY IS NOT NULL AND
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID = SIC.IMS_CODE_ID AND
					<cfelseif attributes.report_type eq 5>
						I.COMPANY_ID = WP.COMPANY_ID AND
						WP.IS_MASTER = 1 AND
						WP.OUR_COMPANY_ID = #session.ep.company_id# AND 
					</cfif>
						I.INVOICE_DATE BETWEEN #attributes.date1# AND #attributes.date2#
					<cfif isdefined("attributes.customer_value_id") and len(attributes.customer_value_id)>
						AND I.CUSTOMER_VALUE_ID = #attributes.customer_value_id#
					</cfif>
					<cfif isdefined("attributes.resource_id") and len(attributes.resource_id)>
						AND I.RESOURCE_ID = #attributes.resource_id#
					</cfif>
					<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND I.IMS_CODE_ID = #attributes.ims_code_id#
					</cfif>
					<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
						AND C.SALES_COUNTY = #attributes.zone_id#
					</cfif>
					<cfif isdefined("attributes.member_status") and attributes.member_status gte 0>
						AND C.COMPANY_STATUS = #attributes.member_status#
					</cfif>
				GROUP BY
					<cfif attributes.report_type eq 1>
						C.FULLNAME,
						C.COMPANY_ID,
						C.MEMBER_CODE,
						C.COUNTRY,
						C.CITY
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID,
						IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(I.CUSTOMER_VALUE_ID,0)
					<cfelseif attributes.report_type eq 5>
						WP.POSITION_CODE
					<cfelseif attributes.report_type eq 7>
						C.COMPANYCAT_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(CITY,0)
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,I.OTHER_MONEY
					</cfif>
			</cfif>
		</cfif>
		<cfif attributes.member_cat_value neq 1 and attributes.member_cat_value neq 2>
			<cfif not len(attributes.member_cat_type) or ((listfind(attributes.member_cat_type,'1-0',',') or len(list_company)) and (listfind(attributes.member_cat_type,'2-0',',') or len(list_consumer)))>
				UNION ALL
			</cfif>
		</cfif>
		<!--- bireysel üyeler iade --->
		<cfif attributes.member_cat_value neq 1>
			<cfif listfind(attributes.member_cat_type ,'2-0',',') or len(list_consumer) or not len(attributes.member_cat_type)>
				SELECT
				<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
					0 AS NETTOTAL,
					0 AS NETTOTAL_DOVIZ,
					SUM(I.NETTOTAL) IADE_TOPLAM,
					SUM(I.NETTOTAL/IM.RATE2) IADE_TOPLAM_DOVIZ,
				<cfelse>
					0 AS NETTOTAL,
					SUM(I.NETTOTAL) IADE_TOPLAM,
				</cfif>
					0 AS BAKIYE,
					0 AS BAKIYE2,
					0 AS BORC,
					0 AS BORC2,
					0 AS ALACAK,
					0 AS ALACAK2,
					0 AS VADE_BORC_NEW,
					0 AS VADE_ALACAK_NEW,
					0 AS OPEN_ACCOUNT_RISK_LIMIT,
					0 AS TOTAL_RISK_LIMIT,
					0 AS FORWARD_SALE_LIMIT,
					0 AS CEK_KARSILIKSIZ,
					0 AS CEK_KARSILIKSIZ2,
					0 AS SENET_KARSILIKSIZ,
					0 AS SENET_KARSILIKSIZ2,
					0 AS CEK_ODENMEDI,
					0 AS CEK_ODENMEDI2,
					0 AS SENET_ODENMEDI,
					0 AS SENET_ODENMEDI2,
					0 AS SECURE_TOTAL_TAKE,
					0 AS SECURE_TOTAL_TAKE2,
					0 AS SECURE_TOTAL_GIVE,
					0 AS SECURE_TOTAL_GIVE2,	
					0 AS VADE_PER,
					0 AS VADE_PER_ORT,
					0 KONTROL,
					<cfif attributes.report_type eq 1>
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME FULLNAME,
						C.CONSUMER_ID PROCESS_ID,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.TAX_COUNTRY_ID COUNTRY,
						C.TAX_CITY_ID CITY
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(I.CUSTOMER_VALUE_ID,0) CUSTOMER_VALUE_ID
					<cfelseif attributes.report_type eq 5> 
						WP.POSITION_CODE
					<cfelseif attributes.report_type eq 7> 
						C.CONSUMER_CAT_ID
					<cfelseif attributes.report_type eq 8> 
						ISNULL(C.WORK_CITY_ID,0) CITY
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,I.OTHER_MONEY
						,0 AS FORWARD_SALE_LIMIT3
						,0 AS OPEN_ACCOUNT_RISK_LIMIT3
					</cfif>
				FROM
					INVOICE I,
					#dsn_alias#.CONSUMER C
				<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
					,INVOICE_MONEY IM
				</cfif>
				<cfif attributes.report_type eq 3>
					,#dsn_alias#.SETUP_IMS_CODE SIC
				<cfelseif attributes.report_type eq 5>
					,#dsn_alias#.WORKGROUP_EMP_PAR WP
				</cfif>
				WHERE
					I.INVOICE_CAT IN (55,54,51,63) AND
					I.IS_IPTAL = 0 AND
					I.NETTOTAL > 0 AND
					<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
						IM.ACTION_ID = I.INVOICE_ID AND
						<cfif isdefined("attributes.is_money3")>
							IM.MONEY_TYPE = I.OTHER_MONEY AND
						<cfelse>
							IM.MONEY_TYPE = '#session.ep.money2#' AND
						</cfif>
					</cfif>
					<cfif not isDefined("attributes.is_all_member")>
						 I.CONSUMER_ID IN (SELECT CR.CONSUMER_ID FROM CONSUMER_RISK CR WHERE (CR.BAKIYE+CR.CEK_KARSILIKSIZ+CR.CEK_ODENMEDI+CR.SENET_ODENMEDI+CR.SENET_KARSILIKSIZ) > 0) AND
					</cfif>
					<cfif len(trim(attributes.company)) and len(attributes.consumer_id)>
						I.CONSUMER_ID = #attributes.consumer_id# AND
					</cfif>
					<cfif len(list_consumer)>
						C.CONSUMER_CAT_ID IN(#list_consumer#) AND
					</cfif>
					<cfif len(trim(attributes.pos_code_text)) and len(attributes.pos_code)>
						I.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND OUR_COMPANY_ID = #session.ep.company_id# AND IS_MASTER=1) AND
					</cfif>
						I.CONSUMER_ID = C.CONSUMER_ID AND
					<cfif attributes.report_type eq 2>
						C.SALES_COUNTY IS NOT NULL AND
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID = SIC.IMS_CODE_ID AND
					<cfelseif attributes.report_type eq 5>
						I.CONSUMER_ID = WP.COMPANY_ID AND
						WP.IS_MASTER = 1 AND
						WP.OUR_COMPANY_ID = #session.ep.company_id# AND 
					</cfif>
						I.INVOICE_DATE BETWEEN #attributes.date1# AND #attributes.date2#
					<cfif len(attributes.customer_value_id)>
						AND I.CUSTOMER_VALUE_ID = #attributes.customer_value_id#
					</cfif>
					<cfif len(attributes.resource_id)>
						AND I.RESOURCE_ID = #attributes.resource_id#
					</cfif>
					<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>
						AND I.IMS_CODE_ID = #attributes.ims_code_id#
					</cfif>
					<cfif len(attributes.zone_id)>
						AND C.SALES_COUNTY = #attributes.zone_id#
					</cfif>
					<cfif attributes.member_status gte 0>
						AND C.CONSUMER_STATUS = #attributes.member_status#
					</cfif>
				GROUP BY
					<cfif attributes.report_type eq 1>
						C.CONSUMER_NAME,
						C.CONSUMER_SURNAME,
						C.CONSUMER_ID,
						C.MEMBER_CODE,
						C.TAX_COUNTRY_ID,
						C.TAX_CITY_ID
					<cfelseif attributes.report_type eq 2>
						C.SALES_COUNTY
					<cfelseif attributes.report_type eq 3>
						I.IMS_CODE_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(I.CUSTOMER_VALUE_ID,0)
					<cfelseif attributes.report_type eq 5>
						WP.POSITION_CODE
					<cfelseif attributes.report_type eq 7>
						C.CONSUMER_CAT_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(C.WORK_CITY_ID,0)
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,I.OTHER_MONEY
					</cfif>
			</cfif>
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_total_purchase_2.recordcount = 0>
</cfif>
<cfquery name="get_total_purchase_1" dbtype="query">
	SELECT
		 *
	FROM
		get_total_purchase_1
	ORDER BY
		<cfif attributes.report_sort eq 1>
			NETTOTAL DESC
		<cfelseif attributes.report_sort eq 2>
			BAKIYE DESC
		<cfelseif attributes.report_sort eq 3>
			VADE_PER DESC
		<cfelse>
			PROCESS_ID,
			KONTROL			
		</cfif>
</cfquery>
<cfset process_id_list=''>
<cfset process_id_list1=''>
<cfset process_id_list2=''>
<cfoutput query="get_total_purchase_1">
	<cfif len(PROCESS_ID) and not listfind(process_id_list,PROCESS_ID)>
		<cfset process_id_list=listappend(process_id_list,PROCESS_ID)>
	</cfif>
	<cfif kontrol eq 1>
		<cfif len(PROCESS_ID) and not listfind(process_id_list1,PROCESS_ID)>
			<cfset process_id_list1=listappend(process_id_list1,PROCESS_ID)>
		</cfif>
	<cfelse>
		<cfif len(PROCESS_ID) and not listfind(process_id_list2,PROCESS_ID)>
			<cfset process_id_list2=listappend(process_id_list2,PROCESS_ID)>
		</cfif>
	</cfif>
</cfoutput>
<cfif attributes.report_type eq 5>
	<cfif len(process_id_list)>
		<cfset process_id_list=listsort(process_id_list,"numeric","ASC",",")>
		<cfquery name="get_emp_info" datasource="#dsn#">
			SELECT 
				EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID
			FROM
				EMPLOYEE_POSITIONS
			WHERE 
				POSITION_CODE IN (#process_id_list#) 
			ORDER BY
				POSITION_CODE
		</cfquery>
	</cfif>
<cfelseif attributes.report_type eq 7>
	<cfif len(process_id_list)>
		<cfset process_id_list=listsort(process_id_list,"numeric","ASC",",")>
		<cfquery name="get_comp_cat" datasource="#dsn#">
			SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_ID IN (#process_id_list#) ORDER BY COMPANYCAT_ID
		</cfquery>
	</cfif>
<cfelseif attributes.report_type eq 8>
	<cfif len(process_id_list)>
		<cfset process_id_list=listsort(process_id_list,"numeric","ASC",",")>
		<cfquery name="get_city" datasource="#dsn#">
			SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#process_id_list#) ORDER BY CITY_ID
		</cfquery>
	</cfif>
</cfif>
<cfif len(process_id_list1) or len(process_id_list2) and listfind('7,8',attributes.report_dsp_type)>
	<cfif isdefined("check_company_risk_type") and check_company_risk_type.recordcount neq 0 and check_company_risk_type.IS_DETAILED_RISK_INFO eq 1>
		<cfquery name="get_open_order" datasource="#dsn#">
			SELECT
				SUM(ORDER_TOTAL) ORDER_TOTAL,
				SUM(ORDER_TOTAL2) ORDER_TOTAL2,
				SUM(SHIP_TOTAL) SHIP_TOTAL,
				SUM(SHIP_TOTAL2) SHIP_TOTAL2,
				KONTROL,
				PROCESS_ID
				<cfif attributes.report_type eq 3>
				,IMS_CODE_NAME
				</cfif>
				<cfif attributes.report_type eq 1>
					,FULLNAME
                    ,CONVERT(varchar(50), MEMBER_CODE) MEMBER_CODE
					,COUNTRY
					,CITY
				</cfif>
				<cfif isdefined("attributes.is_money3")>
					,OTHER_MONEY
				</cfif>
			FROM
			(					
			<cfif len(process_id_list1)>
				SELECT
					((ORD_ROW.QUANTITY - ISNULL(ORD_ROW.CANCEL_AMOUNT,0) - ((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID))) * (((1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_ROW.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100))))/ORD_ROW.QUANTITY)) ORDER_TOTAL,
					<cfif len(session_base.money2)>
						((ORD_ROW.QUANTITY - ISNULL(ORD_ROW.CANCEL_AMOUNT,0) - ((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID))) * (((1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_ROW.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100))))/RATE2/ORD_ROW.QUANTITY)) ORDER_TOTAL2
					<cfelse>
						0 ORDER_TOTAL2
					</cfif>,
					0 SHIP_TOTAL,
					0 SHIP_TOTAL2,
					1 KONTROL,
					<cfif attributes.report_type eq 1>
						C.COMPANY_ID AS PROCESS_ID,
						C.FULLNAME,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.COUNTRY,
						C.CITY
					<cfelseif attributes.report_type eq 2>
						SALES_COUNTY AS PROCESS_ID
					<cfelseif attributes.report_type eq 3>
						C.IMS_CODE_ID AS PROCESS_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(COMPANY_VALUE_ID,0) AS PROCESS_ID
					<cfelseif attributes.report_type eq 5>
						POSITION_CODE AS PROCESS_ID
					<cfelseif attributes.report_type eq 7>
						COMPANYCAT_ID AS PROCESS_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(CITY,0) AS PROCESS_ID
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,O.OTHER_MONEY
					</cfif>
				FROM
					COMPANY C,
					#dsn3_alias#.ORDERS O,
					#dsn3_alias#.ORDER_ROW ORD_ROW
					<cfif len(session_base.money2)>
						,#dsn3_alias#.ORDER_MONEY OM
					</cfif>
					<cfif attributes.report_type eq 3>
						,#dsn_alias#.SETUP_IMS_CODE SIC
					</cfif>
					<cfif attributes.report_type eq 5>
						,WORKGROUP_EMP_PAR WP
					</cfif>
				WHERE
					ISNULL(IS_MEMBER_RISK,1)=1 
					AND ORDER_STATUS = 1 
					AND ((O.PURCHASE_SALES=1 
					AND O.ORDER_ZONE=0) OR (O.PURCHASE_SALES=0 AND O.ORDER_ZONE=1)) 
					AND IS_PAID<>1
					AND O.COMPANY_ID = C.COMPANY_ID
					AND O.ORDER_ID = ORD_ROW.ORDER_ID
					AND ((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT) > 0
					AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)
					<cfif len(session_base.money2)>
						AND O.ORDER_ID = OM.ACTION_ID
						<cfif isdefined("attributes.is_money3")>
							AND OM.MONEY_TYPE = O.OTHER_MONEY
						<cfelse>
							AND OM.MONEY_TYPE = '#session_base.money2#'
						</cfif>
					</cfif>
					<cfif attributes.report_type eq 1>
						AND C.COMPANY_ID IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 2>
						AND SALES_COUNTY IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 3>
						AND C.IMS_CODE_ID IN(#process_id_list1#)
						AND C.IMS_CODE_ID = SIC.IMS_CODE_ID
					<cfelseif attributes.report_type eq 4>
						AND COMPANY_VALUE_ID IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 5>
						AND C.COMPANY_ID = WP.COMPANY_ID
						AND WP.IS_MASTER = 1
						AND WP.OUR_COMPANY_ID = #session.ep.company_id# 
						AND WP.POSITION_CODE IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 7>
						AND COMPANYCAT_ID IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 8>
						AND CITY IN(#process_id_list1#)
					</cfif>
				UNION ALL
				SELECT
					0 ORDER_TOTAL,
					0 ORDER_TOTAL2,
					((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW IR WHERE IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) SHIP_TOTAL,
					<cfif len(session_base.money2)>
						((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW IR WHERE IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT/RATE2) SHIP_TOTAL2
					<cfelse>
						0 SHIP_TOTAL2
					</cfif>,
					1 KONTROL,
					<cfif attributes.report_type eq 1>
						C.COMPANY_ID AS PROCESS_ID,
						C.FULLNAME,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.COUNTRY,
						C.CITY
					<cfelseif attributes.report_type eq 2>
						SALES_COUNTY AS PROCESS_ID
					<cfelseif attributes.report_type eq 3>
						C.IMS_CODE_ID AS PROCESS_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(COMPANY_VALUE_ID,0) AS PROCESS_ID
					<cfelseif attributes.report_type eq 5>
						POSITION_CODE AS PROCESS_ID
					<cfelseif attributes.report_type eq 7>
						COMPANYCAT_ID AS PROCESS_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(CITY,0) AS PROCESS_ID
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,S.OTHER_MONEY
					</cfif>
				FROM
					COMPANY C,
					#dsn2_alias#.SHIP S,
					#dsn2_alias#.SHIP_ROW SR
					<cfif len(session_base.money2)>
						,#dsn2_alias#.SHIP_MONEY SM
					</cfif>
					<cfif attributes.report_type eq 3>
						,#dsn_alias#.SETUP_IMS_CODE SIC
					</cfif>
					<cfif attributes.report_type eq 5>
						,WORKGROUP_EMP_PAR WP
					</cfif>
				WHERE
					S.SHIP_ID=SR.SHIP_ID 
					AND ISNULL(S.SHIP_STATUS,0) = 1
					AND S.PURCHASE_SALES = 1
					AND S.IS_WITH_SHIP=0 
					AND ISNULL(S.IS_SHIP_IPTAL,0)=0
					AND S.COMPANY_ID =C.COMPANY_ID
					AND SR.NETTOTAL > 0
					AND (SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #dsn2_alias#.INVOICE_ROW IR,#dsn2_alias#.INVOICE I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = S.PURCHASE_SALES AND I.IS_IPTAL = 0 AND IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID)) > 0
					<cfif len(session_base.money2)>
						AND S.SHIP_ID = SM.ACTION_ID
						<cfif isdefined("attributes.is_money3")>
							AND SM.MONEY_TYPE = S.OTHER_MONEY
						<cfelse>
							AND SM.MONEY_TYPE = '#session_base.money2#'
						</cfif>
					</cfif>
					<cfif attributes.report_type eq 1>
						AND C.COMPANY_ID IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 2>
						AND SALES_COUNTY IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 3>
						AND C.IMS_CODE_ID IN (#process_id_list1#)
						AND C.IMS_CODE_ID = SIC.IMS_CODE_ID
					<cfelseif attributes.report_type eq 4>
						AND COMPANY_VALUE_ID IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 5>
						AND C.COMPANY_ID = WP.COMPANY_ID
						AND WP.IS_MASTER = 1
						AND WP.OUR_COMPANY_ID = #session.ep.company_id# 
						AND WP.POSITION_CODE IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 7>
						AND COMPANYCAT_ID IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 8>
						AND CITY IN(#process_id_list1#)
					</cfif>
			</cfif>
			<cfif len(process_id_list1) and len(process_id_list2)>
				UNION ALL
			</cfif>
			<cfif len(process_id_list2)>
				SELECT
					((ORD_ROW.QUANTITY - ISNULL(ORD_ROW.CANCEL_AMOUNT,0) - ((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID))) * (((1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_ROW.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100))))/ORD_ROW.QUANTITY)) ORDER_TOTAL,
					<cfif len(session_base.money2)>
						((ORD_ROW.QUANTITY - ISNULL(ORD_ROW.CANCEL_AMOUNT,0) - ((SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_SHIP_ROW SR WHERE SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID)+(SELECT ISNULL(SUM(SR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW SR WHERE  SR.WRK_ROW_RELATION_ID = ORD_ROW.WRK_ROW_ID))) * (((1- (O.SA_DISCOUNT)/((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT)) * (ORD_ROW.NETTOTAL) + (((((1- (O.SA_DISCOUNT)/(O.NETTOTAL-O.TAXTOTAL+O.SA_DISCOUNT))*( ORD_ROW.NETTOTAL)*ORD_ROW.TAX)/100))))/RATE2/ORD_ROW.QUANTITY)) ORDER_TOTAL2
					<cfelse>
						0 ORDER_TOTAL2
					</cfif>,
					0 SHIP_TOTAL,
					0 SHIP_TOTAL2,
					0 KONTROL,
					<cfif attributes.report_type eq 1>
						C.CONSUMER_ID AS PROCESS_ID,
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.TAX_COUNTRY_ID COUNTRY,
						C.TAX_CITY_ID CITY
					<cfelseif attributes.report_type eq 2>
						SALES_COUNTY AS PROCESS_ID
					<cfelseif attributes.report_type eq 3>
						C.IMS_CODE_ID AS PROCESS_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(C.CUSTOMER_VALUE_ID,0) AS PROCESS_ID
					<cfelseif attributes.report_type eq 5>
						POSITION_CODE AS PROCESS_ID
					<cfelseif attributes.report_type eq 7>
						CONSUMER_CAT_ID AS PROCESS_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(C.WORK_CITY_ID,0) AS PROCESS_ID
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,O.OTHER_MONEY
					</cfif>
				FROM
					CONSUMER C,
					#dsn3_alias#.ORDERS O,
					#dsn3_alias#.ORDER_ROW ORD_ROW
					<cfif len(session_base.money2)>
						,#dsn3_alias#.ORDER_MONEY OM
					</cfif>
					<cfif attributes.report_type eq 3>
						,#dsn_alias#.SETUP_IMS_CODE SIC
					</cfif>
					<cfif attributes.report_type eq 5>
						,WORKGROUP_EMP_PAR WP
					</cfif>
				WHERE
					ISNULL(IS_MEMBER_RISK,1)=1 
					AND ORDER_STATUS = 1 
					AND ((O.PURCHASE_SALES=1 
					AND O.ORDER_ZONE=0) OR (O.PURCHASE_SALES=0 AND O.ORDER_ZONE=1)) 
					AND IS_PAID<>1
					AND O.CONSUMER_ID = C.CONSUMER_ID
					AND ORD_ROW.ORDER_ID = O.ORDER_ID
					AND ((O.NETTOTAL)-O.TAXTOTAL+O.SA_DISCOUNT) > 0
					AND ORD_ROW.ORDER_ROW_CURRENCY NOT IN(-8,-9,-10,-3)
					<cfif len(session_base.money2)>
						AND O.ORDER_ID = OM.ACTION_ID
						<cfif isdefined("attributes.is_money3")>
							AND OM.MONEY_TYPE = O.OTHER_MONEY
						<cfelse>
							AND OM.MONEY_TYPE = '#session_base.money2#'
						</cfif>
					</cfif>
					<cfif attributes.report_type eq 1>
						AND C.CONSUMER_ID IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 2>
						AND SALES_COUNTY IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 3>
						AND C.IMS_CODE_ID IN(#process_id_list2#)
						AND C.IMS_CODE_ID = SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						AND C.CUSTOMER_VALUE_ID IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 5>
						AND C.CONSUMER_ID = WP.CONSUMER_ID
						AND WP.IS_MASTER = 1
						AND WP.OUR_COMPANY_ID = #session.ep.company_id# 
						AND WP.POSITION_CODE IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 7>
						AND CONSUMER_CAT_ID IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 8>
						AND WORK_CITY_ID IN(#process_id_list2#)
					</cfif>
				UNION ALL
				SELECT
					0 ORDER_TOTAL,
					0 ORDER_TOTAL2,
					((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW IR WHERE IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT) SHIP_TOTAL,
					<cfif len(session_base.money2)>
						((SR.AMOUNT - (SELECT ISNULL(SUM(IR.AMOUNT),0) FROM #dsn3_alias#.GET_ALL_INVOICE_ROW IR WHERE IR.WRK_ROW_RELATION_ID = SR.WRK_ROW_ID))) * (SR.GROSSTOTAL/SR.AMOUNT/RATE2) SHIP_TOTAL2
					<cfelse>
						0 SHIP_TOTAL2
					</cfif>,
					0 KONTROL,
					<cfif attributes.report_type eq 1>
						C.CONSUMER_ID AS PROCESS_ID,
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.TAX_COUNTRY_ID COUNTRY,
						C.TAX_CITY_ID CITY
					<cfelseif attributes.report_type eq 2>
						SALES_COUNTY AS PROCESS_ID
					<cfelseif attributes.report_type eq 3>
						C.IMS_CODE_ID AS PROCESS_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(C.CUSTOMER_VALUE_ID,0) AS PROCESS_ID
					<cfelseif attributes.report_type eq 5>
						POSITION_CODE AS PROCESS_ID
					<cfelseif attributes.report_type eq 7>
						CONSUMER_CAT_ID AS PROCESS_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(C.WORK_CITY_ID,0) AS PROCESS_ID
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,S.OTHER_MONEY
					</cfif>
				FROM
					CONSUMER C,
					#dsn2_alias#.SHIP S,
					#dsn2_alias#.SHIP_ROW SR
					<cfif len(session_base.money2)>
						,#dsn2_alias#.SHIP_MONEY SM
					</cfif>
					<cfif attributes.report_type eq 3>
						,#dsn_alias#.SETUP_IMS_CODE SIC
					</cfif>
					<cfif attributes.report_type eq 5>
						,WORKGROUP_EMP_PAR WP
					</cfif>
				WHERE
					S.SHIP_ID=SR.SHIP_ID 
					AND ISNULL(S.SHIP_STATUS,0) = 1
					AND S.PURCHASE_SALES = 1
					AND S.IS_WITH_SHIP=0 
					AND ISNULL(S.IS_SHIP_IPTAL,0)=0
					AND S.CONSUMER_ID = C.CONSUMER_ID
					AND SR.NETTOTAL > 0
					<cfif len(session_base.money2)>
						AND S.SHIP_ID = SM.ACTION_ID
						<cfif isdefined("attributes.is_money3")>
							AND SM.MONEY_TYPE = S.OTHER_MONEY
						<cfelse>
							AND SM.MONEY_TYPE = '#session_base.money2#'
						</cfif>
					</cfif>
					<cfif attributes.report_type eq 1>
						AND C.CONSUMER_ID IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 2>
						AND SALES_COUNTY IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 3>
						AND C.IMS_CODE_ID IN (#process_id_list2#)
						AND C.IMS_CODE_ID = SIC.IMS_CODE_ID
					<cfelseif attributes.report_type eq 4>
						AND C.CUSTOMER_VALUE_ID IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 5>
						AND C.CONSUMER_ID = WP.CONSUMER_ID
						AND WP.IS_MASTER = 1
						AND WP.OUR_COMPANY_ID = #session.ep.company_id# 
						AND WP.POSITION_CODE IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 7>
						AND CONSUMER_CAT_ID IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 8>
						AND WORK_CITY_ID IN(#process_id_list2#)
					</cfif>
			</cfif>
			)T1
			GROUP BY
				PROCESS_ID,
				KONTROL
				<cfif attributes.report_type eq 3>
				,IMS_CODE_NAME
				</cfif>
				<cfif attributes.report_type eq 1>
					,FULLNAME
					,MEMBER_CODE
					,COUNTRY
					,CITY
				</cfif>
				<cfif isdefined("attributes.is_money3")>
					,OTHER_MONEY
				</cfif>
		</cfquery>
	<cfelse>
		<cfquery name="get_open_order" datasource="#dsn#">
			SELECT
				SUM(ORDER_TOTAL) ORDER_TOTAL,
				SUM(ORDER_TOTAL2) ORDER_TOTAL2,
				SUM(SHIP_TOTAL) SHIP_TOTAL,
				SUM(SHIP_TOTAL2) SHIP_TOTAL2,
				KONTROL,
				PROCESS_ID
				<cfif attributes.report_type eq 3>
					,IMS_CODE_NAME
				</cfif>
				<cfif isdefined("attributes.is_money3")>
					,OTHER_MONEY
				</cfif>
				<cfif attributes.report_type eq 1>
					,FULLNAME
					,CONVERT(varchar(50), MEMBER_CODE) MEMBER_CODE
					,COUNTRY
					,CITY
				</cfif>
			FROM
			(					
			<cfif len(process_id_list1)>
				SELECT
					SUM(O.NETTOTAL) ORDER_TOTAL,
					<cfif len(session_base.money2)>
						SUM(O.NETTOTAL/OM.RATE2) ORDER_TOTAL2,
					<cfelse>
						0 ORDER_TOTAL2,
					</cfif>
					0 SHIP_TOTAL,
					0 SHIP_TOTAL2,
					1 KONTROL,
					<cfif attributes.report_type eq 1>
						C.COMPANY_ID AS PROCESS_ID,
						C.FULLNAME,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.COUNTRY,
						C.CITY
					<cfelseif attributes.report_type eq 2>
						SALES_COUNTY AS PROCESS_ID
					<cfelseif attributes.report_type eq 3>
						O.IMS_CODE_ID AS PROCESS_ID,
						SIC.IMS_CODE_NAME AS IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(COMPANY_VALUE_ID,0) AS PROCESS_ID
					<cfelseif attributes.report_type eq 5>
						POSITION_CODE AS PROCESS_ID
					<cfelseif attributes.report_type eq 7>
						COMPANYCAT_ID AS PROCESS_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(CITY,0) AS PROCESS_ID
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,O.OTHER_MONEY
					</cfif>
				FROM
					COMPANY C,
					#dsn3_alias#.ORDERS O
					<cfif len(session_base.money2)>
						,#dsn3_alias#.ORDER_MONEY OM
					</cfif>
					<cfif attributes.report_type eq 5>
						,WORKGROUP_EMP_PAR WP
					<cfelseif attributes.report_type eq 3>
						,SETUP_IMS_CODE SIC
					</cfif>
				WHERE
					O.ORDER_STATUS = 1 
					AND ISNULL(O.IS_MEMBER_RISK,1)=1
					AND O.ORDER_ID NOT IN(SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_INVOICE) 
					AND O.ORDER_ID NOT IN(SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP) 
					AND ((O.PURCHASE_SALES=1 AND O.ORDER_ZONE=0) OR (O.PURCHASE_SALES=0 AND O.ORDER_ZONE=1)) 
					AND O.IS_PAID<>1 
					AND O.COMPANY_ID = C.COMPANY_ID
					<cfif len(session_base.money2)>
						AND O.ORDER_ID = OM.ACTION_ID
						<cfif isdefined("attributes.is_money3")>
							AND OM.MONEY_TYPE = O.OTHER_MONEY
						<cfelse>
							AND OM.MONEY_TYPE = '#session_base.money2#'
						</cfif>
					</cfif>
					<cfif attributes.report_type eq 1>
						AND C.COMPANY_ID IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 2>
						AND SALES_COUNTY IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 3>
						AND O.IMS_CODE_ID = SIC.IMS_CODE_ID
					<cfelseif attributes.report_type eq 4>
						AND COMPANY_VALUE_ID IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 5>
						AND C.COMPANY_ID = WP.COMPANY_ID
						AND WP.IS_MASTER = 1
						AND WP.OUR_COMPANY_ID = #session.ep.company_id# 
						AND WP.POSITION_CODE IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 7>
						AND COMPANYCAT_ID IN(#process_id_list1#)
					<cfelseif attributes.report_type eq 8>
						AND CITY IN(#process_id_list1#)
					</cfif>
				GROUP BY
					<cfif attributes.report_type eq 1>
						C.COMPANY_ID,
						C.FULLNAME,
						C.MEMBER_CODE,
						C.COUNTRY,
						C.CITY
					<cfelseif attributes.report_type eq 2>
						SALES_COUNTY
					<cfelseif attributes.report_type eq 3>
						O.IMS_CODE_ID,
						SIC.IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						COMPANY_VALUE_ID
					<cfelseif attributes.report_type eq 5>
						POSITION_CODE
					<cfelseif attributes.report_type eq 7>
						COMPANYCAT_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(CITY,0)
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,O.OTHER_MONEY
					</cfif>
			</cfif>
			<cfif len(process_id_list1) and len(process_id_list2)>
				UNION ALL
			</cfif>
			<cfif len(process_id_list2)>
				SELECT
					SUM(O.NETTOTAL) ORDER_TOTAL,
					<cfif len(session_base.money2)>
						SUM(O.NETTOTAL/OM.RATE2) ORDER_TOTAL2,
					<cfelse>
						0 ORDER_TOTAL2,
					</cfif>
					0 SHIP_TOTAL,
					0 SHIP_TOTAL2,
					0 KONTROL,
					<cfif attributes.report_type eq 1>
						C.CONSUMER_ID AS PROCESS_ID,
						C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS FULLNAME,
						CONVERT(varchar(50), c.MEMBER_CODE) MEMBER_CODE,
						C.TAX_COUNTRY_ID COUNTRY,
						C.TAX_CITY_ID CITY
					<cfelseif attributes.report_type eq 2>
						SALES_COUNTY AS PROCESS_ID
					<cfelseif attributes.report_type eq 3>
						O.IMS_CODE_ID AS PROCESS_ID,,
						SIC.IMS_CODE_NAME AS IMS_CODE_NAME
					<cfelseif attributes.report_type eq 4>
						ISNULL(C.CUSTOMER_VALUE_ID,0) AS PROCESS_ID
					<cfelseif attributes.report_type eq 5>
						POSITION_CODE AS PROCESS_ID
					<cfelseif attributes.report_type eq 7>
						CONSUMER_CAT_ID AS PROCESS_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(C.WORK_CITY_ID,0) AS PROCESS_ID
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,O.OTHER_MONEY
					</cfif>
				FROM
					CONSUMER C,
					#dsn3_alias#.ORDERS O
					<cfif len(session_base.money2)>
						,#dsn3_alias#.ORDER_MONEY OM
					</cfif>
					<cfif attributes.report_type eq 3>
						,SETUP_IMS_CODE SIC
					</cfif>
					<cfif attributes.report_type eq 5>
						,WORKGROUP_EMP_PAR WP
					</cfif>
				WHERE
					O.ORDER_STATUS = 1 
					AND ISNULL(O.IS_MEMBER_RISK,1)=1
					AND O.ORDER_ID NOT IN(SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_INVOICE) 
					AND O.ORDER_ID NOT IN(SELECT ORDER_ID FROM #dsn3_alias#.ORDERS_SHIP) 
					AND ((O.PURCHASE_SALES=1 AND O.ORDER_ZONE=0) OR (O.PURCHASE_SALES=0 AND O.ORDER_ZONE=1)) 
					AND O.IS_PAID<>1 
					AND O.CONSUMER_ID = C.CONSUMER_ID
					<cfif len(session_base.money2)>
						AND O.ORDER_ID = OM.ACTION_ID
						<cfif isdefined("attributes.is_money3")>
							AND OM.MONEY_TYPE = O.OTHER_MONEY
						<cfelse>
							AND OM.MONEY_TYPE = '#session_base.money2#'
						</cfif>
					</cfif>
					<cfif attributes.report_type eq 1>
						AND C.CONSUMER_ID IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 2>
						AND SALES_COUNTY IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 3>
						AND O.IMS_CODE_ID IN(#process_id_list2#)
						AND O.IMS_CODE_ID = SIC.IMS_CODE_ID
					<cfelseif attributes.report_type eq 4>
						AND C.CUSTOMER_VALUE_ID IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 5>
						AND C.COMPANY_ID = WP.COMPANY_ID
						AND WP.IS_MASTER = 1
						AND WP.OUR_COMPANY_ID = #session.ep.company_id# 
						AND WP.POSITION_CODE IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 7>
						AND CONSUMER_CAT_ID IN(#process_id_list2#)
					<cfelseif attributes.report_type eq 8>
						AND WORK_CITY_ID IN(#process_id_list2#)
					</cfif>
				GROUP BY
					<cfif attributes.report_type eq 1>
						C.CONSUMER_ID,
						C.CONSUMER_NAME,
						C.CONSUMER_SURNAME,
						C.MEMBER_CODE,
						C.TAX_COUNTRY_ID,
						C.TAX_CITY_ID
					<cfelseif attributes.report_type eq 2>
						SALES_COUNTY
					<cfelseif attributes.report_type eq 3>
						O.IMS_CODE_ID
					<cfelseif attributes.report_type eq 4>
						ISNULL(C.CUSTOMER_VALUE_ID,0)
					<cfelseif attributes.report_type eq 5>
						POSITION_CODE
					<cfelseif attributes.report_type eq 7>
						CONSUMER_CAT_ID
					<cfelseif attributes.report_type eq 8>
						ISNULL(C.WORK_CITY_ID,0)
					</cfif>
					<cfif isdefined("attributes.is_money3")>
						,O.OTHER_MONEY
					</cfif>
			</cfif>
			)T1
			GROUP BY
				PROCESS_ID,
				<cfif attributes.report_type eq 3>
					IMS_CODE_NAME,
				</cfif>
				KONTROL
				<cfif isdefined("attributes.is_money3")>
					,OTHER_MONEY
				</cfif>
				<cfif attributes.report_type eq 1>
					,FULLNAME
					,MEMBER_CODE
					,COUNTRY
					,CITY
				</cfif>
		</cfquery>
	</cfif>
	<cfoutput query="get_open_order">
		<cfif isdefined("attributes.is_money3")>
			<cfset "total_order_#kontrol#_#process_id#_#other_money#" = ORDER_TOTAL>
			<cfset "total_order_2_#kontrol#_#process_id#_#other_money#" = ORDER_TOTAL2>
			<cfset "total_ship_#kontrol#_#process_id#_#other_money#" = SHIP_TOTAL>
			<cfset "total_ship_2_#kontrol#_#process_id#_#other_money#" = SHIP_TOTAL2>
		<cfelse>
			<cfset "total_order_#kontrol#_#process_id#" = ORDER_TOTAL>
			<cfset "total_order_2_#kontrol#_#process_id#" = ORDER_TOTAL2>
			<cfset "total_ship_#kontrol#_#process_id#" = SHIP_TOTAL>
			<cfset "total_ship_2_#kontrol#_#process_id#" = SHIP_TOTAL2>
		</cfif>
	</cfoutput>
</cfif>
<cfif (isdefined("get_total_purchase_1") and get_total_purchase_1.recordcount) or (isdefined("get_total_purchase_2") and get_total_purchase_2.recordcount)>
	<cfquery name="get_total_purchase_3" dbtype="query">
		<cfif isdefined("get_total_purchase_1") and get_total_purchase_1.recordcount>
			SELECT * FROM get_total_purchase_1
			<cfif isdefined("get_total_purchase_2") and get_total_purchase_2.recordcount> UNION ALL</cfif> 
		</cfif>
		<cfif isdefined("get_total_purchase_2") and get_total_purchase_2.recordcount>
			SELECT * FROM get_total_purchase_2
		</cfif> 
		<cfif isdefined("get_open_order") and get_open_order.recordcount and isdefined("attributes.is_money3")>
			UNION ALL
			SELECT 
				0 IADE_TOPLAM,
				0 NETTOTAL,
				<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
					0 NETTOTAL_DOVIZ,
					0 AS IADE_TOPLAM_DOVIZ,
				</cfif>
				0 BAKIYE,
				0 BAKIYE2,
				0 BORC,
				0 BORC2,
				0 ALACAK,
				0 ALACAK2,
				0 VADE_BORC_NEW,
				0 VADE_ALACAK_NEW,
				0 OPEN_ACCOUNT_RISK_LIMIT,
				0 TOTAL_RISK_LIMIT,
				0 FORWARD_SALE_LIMIT,
				0 CEK_KARSILIKSIZ,
				0 CEK_KARSILIKSIZ2,
				0 SENET_KARSILIKSIZ,
				0 SENET_KARSILIKSIZ2,
				0 CEK_ODENMEDI,
				0 CEK_ODENMEDI2,
				0 SENET_ODENMEDI,
				0 SENET_ODENMEDI2,
				0 SECURE_TOTAL_TAKE,
				0 SECURE_TOTAL_TAKE2,
				0 SECURE_TOTAL_GIVE,
				0 SECURE_TOTAL_GIVE2,
				0 VADE_PER,
				0 VADE_PER_ORT,
				KONTROL,
				<cfif attributes.report_type eq 1>
					FULLNAME,
					PROCESS_ID,
					MEMBER_CODE,
					COUNTRY,
					CITY
				<cfelseif attributes.report_type eq 3>
					PROCESS_ID,
					IMS_CODE_NAME
				<cfelse>
					PROCESS_ID
				</cfif>
				,OTHER_MONEY
				,0 AS FORWARD_SALE_LIMIT3
				,0 AS OPEN_ACCOUNT_RISK_LIMIT3
			 FROM 
				 get_open_order	
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_total_purchase_3.recordcount=0>
</cfif>
<cfif get_total_purchase_3.recordcount>
	<cfquery name="get_total_purchase" dbtype="query">
		SELECT 
			SUM(get_total_purchase_3.NETTOTAL - get_total_purchase_3.IADE_TOPLAM) AS NETTOTAL,
		<cfif listfind(attributes.report_dsp_type,1) or listfind(attributes.report_dsp_type,2) or listfind(attributes.report_dsp_type,3) or listfind(attributes.report_dsp_type,5)>
			SUM(get_total_purchase_3.NETTOTAL_DOVIZ - get_total_purchase_3.IADE_TOPLAM_DOVIZ) NETTOTAL_DOVIZ,
		</cfif>
			SUM(BAKIYE) BAKIYE,
			SUM(BAKIYE2) BAKIYE2,
			SUM(BORC) BORC,
			SUM(BORC2) BORC2,
			SUM(ALACAK) ALACAK,
			SUM(ALACAK2) ALACAK2,
			SUM(VADE_BORC_NEW) VADE_BORC_NEW,
			SUM(VADE_ALACAK_NEW) VADE_ALACAK_NEW,
			SUM(OPEN_ACCOUNT_RISK_LIMIT) OPEN_ACCOUNT_RISK_LIMIT,
			SUM(TOTAL_RISK_LIMIT) TOTAL_RISK_LIMIT,
			SUM(FORWARD_SALE_LIMIT) FORWARD_SALE_LIMIT,
			SUM(CEK_KARSILIKSIZ) CEK_KARSILIKSIZ,
			SUM(CEK_KARSILIKSIZ2) CEK_KARSILIKSIZ2,
			SUM(SENET_KARSILIKSIZ) SENET_KARSILIKSIZ,
			SUM(SENET_KARSILIKSIZ2) SENET_KARSILIKSIZ2,
			SUM(CEK_ODENMEDI) CEK_ODENMEDI,
			SUM(CEK_ODENMEDI2) CEK_ODENMEDI2,
			SUM(SENET_ODENMEDI) SENET_ODENMEDI,
			SUM(SENET_ODENMEDI2) SENET_ODENMEDI2,
			SUM(SECURE_TOTAL_TAKE) SECURE_TOTAL_TAKE,
			SUM(SECURE_TOTAL_TAKE2) SECURE_TOTAL_TAKE2,
			SUM(SECURE_TOTAL_GIVE) SECURE_TOTAL_GIVE,
			SUM(SECURE_TOTAL_GIVE2) SECURE_TOTAL_GIVE2,
			SUM(VADE_PER) VADE_PER,
			KONTROL,
		<cfif attributes.report_type eq 1>				
			FULLNAME,
			PROCESS_ID,
			 MEMBER_CODE,
			COUNTRY,
			CITY
		<cfelseif attributes.report_type eq 3>	
			IMS_CODE_NAME,
			PROCESS_ID
		<cfelse>
			PROCESS_ID
		</cfif>
		<cfif isdefined("attributes.is_money3")>
			,OTHER_MONEY
			,SUM(FORWARD_SALE_LIMIT3) FORWARD_SALE_LIMIT3
			,SUM(OPEN_ACCOUNT_RISK_LIMIT3) OPEN_ACCOUNT_RISK_LIMIT3
		</cfif>
		FROM
			get_total_purchase_3
		GROUP BY
		KONTROL,
		PROCESS_ID,
		<cfif attributes.report_type eq 1>				
			FULLNAME,
			PROCESS_ID,
			MEMBER_CODE,
			COUNTRY,
			CITY
		<cfelseif attributes.report_type eq 3>	
			IMS_CODE_NAME,
			PROCESS_ID
		<cfelse>
			PROCESS_ID
		</cfif>
		<cfif isdefined("attributes.is_money3")>
			,OTHER_MONEY
		</cfif>
		ORDER BY
			<cfif attributes.report_sort eq 1>
				NETTOTAL DESC
			<cfelseif attributes.report_sort eq 2>
				BAKIYE DESC
			<cfelseif attributes.report_sort eq 3>
				VADE_PER DESC
			<cfelse>
				PROCESS_ID,
				KONTROL
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_total_purchase.recordcount= 0>
</cfif>
<cfif get_total_purchase.recordcount>
	<cfquery name="get_all_total" dbtype="query">
		SELECT SUM(NETTOTAL) AS NETTOTAL FROM get_total_purchase
	</cfquery>
	<cfif len(get_all_total.NETTOTAL)>
		<cfset butun_toplam = get_all_total.NETTOTAL >
	<cfelse>
		<cfset butun_toplam = 1 >
	</cfif>
<cfelse>
	<cfset get_total_purchase.recordcount=0>
	<cfset butun_toplam = 1>
</cfif>
<cfquery name="GET_MONEY_INFO" datasource="#dsn#">
	SELECT (RATE1/RATE2) RATE FROM SETUP_MONEY WHERE MONEY = '#session.ep.money2#' AND MONEY_STATUS = 1 AND PERIOD_ID = #session.ep.period_id# AND COMPANY_ID = #session.ep.company_id#
</cfquery>
<cfif get_total_purchase.recordcount>
	<cfset process_id_list=''>
	<cfset process_id_list1=''>
	<cfset process_id_list2=''>
	<cfoutput query="get_total_purchase">
		<cfif len(PROCESS_ID) and not listfind(process_id_list,PROCESS_ID)>
			<cfset process_id_list=listappend(process_id_list,PROCESS_ID)>
		</cfif>
		<cfif kontrol eq 1>
			<cfif len(PROCESS_ID) and not listfind(process_id_list1,PROCESS_ID)>
				<cfset process_id_list1=listappend(process_id_list1,PROCESS_ID)>
			</cfif>
		<cfelse>
			<cfif len(PROCESS_ID) and not listfind(process_id_list2,PROCESS_ID)>
				<cfset process_id_list2=listappend(process_id_list2,PROCESS_ID)>
			</cfif>
		</cfif>
	</cfoutput>
	<cfif attributes.report_type eq 5>
		<cfif len(process_id_list)>
			<cfset process_id_list=listsort(process_id_list,"numeric","ASC",",")>
			<cfquery name="get_emp_info" datasource="#dsn#">
				SELECT 
					EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID
				FROM
					EMPLOYEE_POSITIONS
				WHERE 
					POSITION_CODE IN (#process_id_list#) 
				ORDER BY
					POSITION_CODE
			</cfquery>
		</cfif>
	<cfelseif attributes.report_type eq 7>
		<cfif len(process_id_list)>
			<cfset process_id_list=listsort(process_id_list,"numeric","ASC",",")>
			<cfquery name="get_comp_cat" datasource="#dsn#">
				SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_ID IN (#process_id_list#) ORDER BY COMPANYCAT_ID
			</cfquery>
		</cfif>
	<cfelseif attributes.report_type eq 8>
		<cfif len(process_id_list)>
			<cfset process_id_list=listsort(process_id_list,"numeric","ASC",",")>
			<cfquery name="get_city" datasource="#dsn#">
				SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#process_id_list#) ORDER BY CITY_ID
			</cfquery>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.is_tem_detail")>
		<cfif len(process_id_list1) or len(process_id_list2)>
			<cfquery name="get_tem_detail" datasource="#dsn#">
				SELECT
					SUM(TOTAL_TAKE) TOTAL_TAKE,
					SUM(TOTAL_TAKE2) TOTAL_TAKE2,
					SUM(TOTAL_GIVE) TOTAL_GIVE,
					SUM(TOTAL_GIVE2) TOTAL_GIVE2,
					<cfif isdefined("is_group_date")>
						RETURN_DATE,
					</cfif>
					CAT_ID,
					PROCESS_ID,
					KONTROL
					<cfif isdefined("attributes.is_money3")>
						,OTHER_MONEY
					</cfif>
				FROM
				(					
				<cfif len(process_id_list1)>
					SELECT
						SUM(CS.ACTION_VALUE) TOTAL_TAKE,
						<cfif isdefined("attributes.is_money3")>
							SUM(CS.SECUREFUND_TOTAL) TOTAL_TAKE2,
						<cfelse>
							SUM(CS.ACTION_VALUE2) TOTAL_TAKE2,
						</cfif>
						0 TOTAL_GIVE,
						0 TOTAL_GIVE2,
						<cfif isdefined("is_group_date")>
							ISNULL(CS.RETURN_DATE,CS.FINISH_DATE) RETURN_DATE,
						</cfif>
						SECUREFUND_CAT_ID CAT_ID,
						1 KONTROL,
						<cfif attributes.report_type eq 1>
							C.COMPANY_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 2>
							SALES_COUNTY AS PROCESS_ID
						<cfelseif attributes.report_type eq 3>
							C.IMS_CODE_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 4>
							ISNULL(COMPANY_VALUE_ID,0) AS PROCESS_ID
						<cfelseif attributes.report_type eq 5>
							POSITION_CODE AS PROCESS_ID
						<cfelseif attributes.report_type eq 7>
							COMPANYCAT_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 8>
							ISNULL(CITY,0) AS PROCESS_ID
						</cfif>
						<cfif isdefined("attributes.is_money3")>
							,CS.MONEY_CAT OTHER_MONEY
						</cfif>
					FROM
						COMPANY_SECUREFUND CS,
						COMPANY C
						<cfif attributes.report_type eq 5>
							,WORKGROUP_EMP_PAR WP
						</cfif>
					WHERE
						CS.GIVE_TAKE = 0 AND
						ISNULL(CS.RETURN_DATE,CS.FINISH_DATE) > GETDATE() AND
						CS.OUR_COMPANY_ID =#session.ep.company_id#  AND
						CS.SECUREFUND_STATUS = 1 AND
						CS.COMPANY_ID = C.COMPANY_ID AND
						ISNULL(CS.IS_RETURN,0) = 0
						<cfif attributes.report_type eq 1>
							AND C.COMPANY_ID IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 2>
							AND SALES_COUNTY IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 3>
							AND C.IMS_CODE_ID IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 4>
							AND COMPANY_VALUE_ID IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 5>
							AND C.COMPANY_ID = WP.COMPANY_ID
							AND WP.IS_MASTER = 1
							AND WP.OUR_COMPANY_ID = #session.ep.company_id# 
							AND WP.POSITION_CODE IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 7>
							AND COMPANYCAT_ID IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 8>
							AND CITY IN(#process_id_list1#)
						</cfif>
					GROUP BY
						SECUREFUND_CAT_ID,
						<cfif isdefined("is_group_date")>
							ISNULL(CS.RETURN_DATE,CS.FINISH_DATE),
						</cfif>
						<cfif attributes.report_type eq 1>
							C.COMPANY_ID
						<cfelseif attributes.report_type eq 2>
							SALES_COUNTY
						<cfelseif attributes.report_type eq 3>
							C.IMS_CODE_ID
						<cfelseif attributes.report_type eq 4>
							COMPANY_VALUE_ID
						<cfelseif attributes.report_type eq 5>
							POSITION_CODE
						<cfelseif attributes.report_type eq 7>
							COMPANYCAT_ID
						<cfelseif attributes.report_type eq 8>
							ISNULL(CITY,0)
						</cfif>
						<cfif isdefined("attributes.is_money3")>
							,CS.MONEY_CAT
						</cfif>
					UNION ALL
					SELECT
						0 TOTAL_TAKE,
						0 TOTAL_TAKE2,
						SUM(CS.ACTION_VALUE) TOTAL_GIVE,
						<cfif isdefined("attributes.is_money3")>
							SUM(CS.SECUREFUND_TOTAL) TOTAL_GIVE2,
						<cfelse>
							SUM(CS.ACTION_VALUE2) TOTAL_GIVE2,
						</cfif>
						<cfif isdefined("is_group_date")>
							ISNULL(CS.RETURN_DATE,CS.FINISH_DATE) RETURN_DATE,
						</cfif>
						SECUREFUND_CAT_ID CAT_ID,
						1 KONTROL,
						<cfif attributes.report_type eq 1>
							C.COMPANY_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 2>
							SALES_COUNTY AS PROCESS_ID
						<cfelseif attributes.report_type eq 3>
							IMS_CODE_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 4>
							ISNULL(COMPANY_VALUE_ID,0) AS PROCESS_ID
						<cfelseif attributes.report_type eq 5>
							POSITION_CODE AS PROCESS_ID
						<cfelseif attributes.report_type eq 7>
							COMPANYCAT_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 8>
							ISNULL(CITY,0) AS PROCESS_ID
						</cfif>
						<cfif isdefined("attributes.is_money3")>
							,CS.MONEY_CAT OTHER_MONEY
						</cfif>
					FROM
						COMPANY_SECUREFUND CS,
						COMPANY C
						<cfif attributes.report_type eq 5>
							,WORKGROUP_EMP_PAR WP
						</cfif>
					WHERE
						CS.GIVE_TAKE = 1 AND
						ISNULL(CS.RETURN_DATE,CS.FINISH_DATE) > GETDATE() AND
						CS.OUR_COMPANY_ID =#session.ep.company_id#  AND
						CS.SECUREFUND_STATUS = 1 AND
						CS.COMPANY_ID = C.COMPANY_ID AND
						ISNULL(CS.IS_RETURN,0) = 0
						<cfif attributes.report_type eq 1>
							AND C.COMPANY_ID IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 2>
							AND SALES_COUNTY IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 3>
							AND IMS_CODE_ID IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 4>
							AND COMPANY_VALUE_ID IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 5>
							AND C.COMPANY_ID = WP.COMPANY_ID
							AND WP.IS_MASTER = 1
							AND WP.OUR_COMPANY_ID = #session.ep.company_id# 
							AND WP.POSITION_CODE IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 7>
							AND COMPANYCAT_ID IN(#process_id_list1#)
						<cfelseif attributes.report_type eq 8>
							AND CITY IN(#process_id_list1#)
						</cfif>
					GROUP BY
						SECUREFUND_CAT_ID,
						<cfif isdefined("is_group_date")>
							ISNULL(CS.RETURN_DATE,CS.FINISH_DATE),
						</cfif>
						<cfif attributes.report_type eq 1>
							C.COMPANY_ID
						<cfelseif attributes.report_type eq 2>
							SALES_COUNTY
						<cfelseif attributes.report_type eq 3>
							IMS_CODE_ID
						<cfelseif attributes.report_type eq 4>
							COMPANY_VALUE_ID
						<cfelseif attributes.report_type eq 5>
							POSITION_CODE
						<cfelseif attributes.report_type eq 7>
							COMPANYCAT_ID
						<cfelseif attributes.report_type eq 8>
							ISNULL(CITY,0)
						</cfif>
						<cfif isdefined("attributes.is_money3")>
							,CS.MONEY_CAT
						</cfif>
				</cfif>
				<cfif len(process_id_list1) and len(process_id_list2)>
					UNION ALL
				</cfif>
				<cfif len(process_id_list2)>
					SELECT
						SUM(CS.ACTION_VALUE) TOTAL_TAKE,
						<cfif isdefined("attributes.is_money3")>
							SUM(CS.SECUREFUND_TOTAL) TOTAL_TAKE2,
						<cfelse>
							SUM(CS.ACTION_VALUE2) TOTAL_TAKE2,
						</cfif>
						0 TOTAL_GIVE,
						0 TOTAL_GIVE2,
						<cfif isdefined("is_group_date")>
							ISNULL(CS.RETURN_DATE,CS.FINISH_DATE) RETURN_DATE,
						</cfif>
						SECUREFUND_CAT_ID CAT_ID,
						0 KONTROL,
						<cfif attributes.report_type eq 1>
							C.CONSUMER_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 2>
							SALES_COUNTY AS PROCESS_ID
						<cfelseif attributes.report_type eq 3>
							IMS_CODE_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 4>
							ISNULL(C.CUSTOMER_VALUE_ID,0) AS PROCESS_ID
						<cfelseif attributes.report_type eq 5>
							POSITION_CODE AS PROCESS_ID
						<cfelseif attributes.report_type eq 7>
							CONSUMER_CAT_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 8>
							ISNULL(C.WORK_CITY_ID,0) AS PROCESS_ID
						</cfif>
						<cfif isdefined("attributes.is_money3")>
							,CS.MONEY_CAT OTHER_MONEY
						</cfif>
					FROM
						COMPANY_SECUREFUND CS,
						CONSUMER C
						<cfif attributes.report_type eq 5>
							,WORKGROUP_EMP_PAR WP
						</cfif>
					WHERE
						CS.GIVE_TAKE = 0 AND
						ISNULL(CS.RETURN_DATE,CS.FINISH_DATE) > GETDATE() AND
						CS.OUR_COMPANY_ID =#session.ep.company_id#  AND
						CS.SECUREFUND_STATUS = 1 AND
						CS.CONSUMER_ID = C.CONSUMER_ID AND
						ISNULL(CS.IS_RETURN,0) = 0
						<cfif attributes.report_type eq 1>
							AND C.CONSUMER_ID IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 2>
							AND SALES_COUNTY IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 3>
							AND IMS_CODE_ID IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 4>
							AND C.CUSTOMER_VALUE_ID IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 5>
							AND C.CONSUMER_ID = WP.CONSUMER_ID
							AND WP.IS_MASTER = 1
							AND WP.OUR_COMPANY_ID = #session.ep.company_id# 
							AND WP.POSITION_CODE IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 7>
							AND CONSUMER_CAT_ID IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 8>
							AND WORK_CITY_ID IN(#process_id_list2#)
						</cfif>
					GROUP BY
						SECUREFUND_CAT_ID,
						<cfif isdefined("is_group_date")>
							ISNULL(CS.RETURN_DATE,CS.FINISH_DATE),
						</cfif>
						<cfif attributes.report_type eq 1>
							C.CONSUMER_ID
						<cfelseif attributes.report_type eq 2>
							SALES_COUNTY
						<cfelseif attributes.report_type eq 3>
							IMS_CODE_ID
						<cfelseif attributes.report_type eq 4>
							ISNULL(C.CUSTOMER_VALUE_ID,0)
						<cfelseif attributes.report_type eq 5>
							POSITION_CODE
						<cfelseif attributes.report_type eq 7>
							CONSUMER_CAT_ID
						<cfelseif attributes.report_type eq 8>
							ISNULL(C.WORK_CITY_ID,0)
						</cfif>
						<cfif isdefined("attributes.is_money3")>
							,CS.MONEY_CAT
						</cfif>
					UNION ALL
					SELECT
						0 TOTAL_TAKE,
						0 TOTAL_TAKE2,
						SUM(CS.ACTION_VALUE) TOTAL_GIVE,
						<cfif isdefined("attributes.is_money3")>
							SUM(CS.SECUREFUND_TOTAL) TOTAL_GIVE2,
						<cfelse>
							SUM(CS.ACTION_VALUE2) TOTAL_GIVE2,
						</cfif>
						<cfif isdefined("is_group_date")>
							ISNULL(CS.RETURN_DATE,CS.FINISH_DATE) RETURN_DATE,
						</cfif>
						SECUREFUND_CAT_ID CAT_ID,
						0 KONTROL,
						<cfif attributes.report_type eq 1>
							C.CONSUMER_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 2>
							SALES_COUNTY AS PROCESS_ID
						<cfelseif attributes.report_type eq 3>
							IMS_CODE_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 4>
							ISNULL(C.CUSTOMER_VALUE_ID,0) AS PROCESS_ID
						<cfelseif attributes.report_type eq 5>
							POSITION_CODE AS PROCESS_ID
						<cfelseif attributes.report_type eq 7>
							CONSUMER_CAT_ID AS PROCESS_ID
						<cfelseif attributes.report_type eq 8>
							ISNULL(C.WORK_CITY_ID,0) AS PROCESS_ID
						</cfif>
						<cfif isdefined("attributes.is_money3")>
							,CS.MONEY_CAT OTHER_MONEY
						</cfif>
					FROM
						COMPANY_SECUREFUND CS,
						CONSUMER C
						<cfif attributes.report_type eq 5>
							,WORKGROUP_EMP_PAR WP
						</cfif>
					WHERE
						CS.GIVE_TAKE = 1 AND
						ISNULL(CS.RETURN_DATE,CS.FINISH_DATE) > GETDATE() AND
						CS.OUR_COMPANY_ID =#session.ep.company_id# AND
						CS.SECUREFUND_STATUS = 1 AND
						CS.CONSUMER_ID = C.CONSUMER_ID AND
						ISNULL(CS.IS_RETURN,0) = 0
						<cfif attributes.report_type eq 1>
							AND C.CONSUMER_ID IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 2>
							AND SALES_COUNTY IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 3>
							AND IMS_CODE_ID IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 4>
							AND C.CUSTOMER_VALUE_ID IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 5>
							AND C.CONSUMER_ID = WP.CONSUMER_ID
							AND WP.IS_MASTER = 1
							AND WP.OUR_COMPANY_ID = #session.ep.company_id# 
							AND WP.POSITION_CODE IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 7>
							AND CONSUMER_CAT_ID IN(#process_id_list2#)
						<cfelseif attributes.report_type eq 8>
							AND WORK_CITY_ID IN(#process_id_list2#)
						</cfif>
					GROUP BY
						SECUREFUND_CAT_ID,
						<cfif isdefined("is_group_date")>
							ISNULL(CS.RETURN_DATE,CS.FINISH_DATE),
						</cfif>
						<cfif attributes.report_type eq 1>
							C.CONSUMER_ID
						<cfelseif attributes.report_type eq 2>
							SALES_COUNTY
						<cfelseif attributes.report_type eq 3>
							IMS_CODE_ID
						<cfelseif attributes.report_type eq 4>
							ISNULL(C.CUSTOMER_VALUE_ID,0)
						<cfelseif attributes.report_type eq 5>
							POSITION_CODE
						<cfelseif attributes.report_type eq 7>
							CONSUMER_CAT_ID
						<cfelseif attributes.report_type eq 8>
							ISNULL(C.WORK_CITY_ID,0)
						</cfif>
						<cfif isdefined("attributes.is_money3")>
							,CS.MONEY_CAT
						</cfif>
				</cfif>
				)T1
				GROUP BY
					CAT_ID,
					PROCESS_ID,
					<cfif isdefined("is_group_date")>
						RETURN_DATE,
					</cfif>
					KONTROL
					<cfif isdefined("attributes.is_money3")>
						,OTHER_MONEY
					</cfif>
			</cfquery>
			<cfoutput query="get_tem_detail">
				<cfif isdefined("attributes.is_money3")>
					<cfif isdefined("total_take_#kontrol#_#cat_id#_#process_id#_#other_money#")>
						<cfset "total_take_#kontrol#_#cat_id#_#process_id#_#other_money#" = evaluate("total_take_#kontrol#_#cat_id#_#process_id#_#other_money#")+total_take>
						<cfset "total_take_2_#kontrol#_#cat_id#_#process_id#_#other_money#" = evaluate("total_take_2_#kontrol#_#cat_id#_#process_id#_#other_money#")+total_take2>
					<cfelse>
						<cfset "total_take_#kontrol#_#cat_id#_#process_id#_#other_money#" = total_take>
						<cfset "total_take_2_#kontrol#_#cat_id#_#process_id#_#other_money#" = total_take2>
					</cfif>
					<cfset "total_give_#kontrol#_#cat_id#_#process_id#_#other_money#" = total_give>
					<cfset "total_give_2_#kontrol#_#cat_id#_#process_id#_#other_money#" = total_give2>
					<cfif isdefined("is_group_date")>
						<cfset "finish_date_#kontrol#_#cat_id#_#process_id#_#other_money#" = return_date>
					</cfif>
				<cfelse>
					<cfset "total_take_#kontrol#_#cat_id#_#process_id#" = total_take>
					<cfset "total_take_2_#kontrol#_#cat_id#_#process_id#" = total_take2>
					<cfset "total_give_#kontrol#_#cat_id#_#process_id#" = total_give>
					<cfset "total_give_2_#kontrol#_#cat_id#_#process_id#" = total_give2>
				</cfif>
			</cfoutput>
		</cfif>
	</cfif>
</cfif>
