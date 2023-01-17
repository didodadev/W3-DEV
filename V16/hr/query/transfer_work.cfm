<cf_get_lang_set module_name="myhome">
	<cf_date tarih="attributes.startdate">
	<cf_date tarih="attributes.finishdate">
	
	<cfset attributes.startdate=date_add("h", attributes.START_HOUR - session.ep.TIME_ZONE, attributes.startdate)>
	<cfset attributes.finishdate=date_add("h", attributes.FINISH_HOUR - session.ep.TIME_ZONE, attributes.finishdate)>
	
	<cfquery name="get_old_emp_detail" datasource="#dsn#">
		SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_emp_id#">
	</cfquery> 
	
	<cfquery name="get_emp_detail" datasource="#dsn#">
		SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
	</cfquery>
	<cfif isdefined("attributes.works")>
		<cfquery name="get_works" datasource="#dsn#">
			SELECT DISTINCT
				WORK_ID		
			FROM 
				PRO_WORKS
			WHERE 
				PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_emp_id#"> AND 
				REAL_FINISH IS NULL AND 
				TARGET_START >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND 
				TARGET_FINISH < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND 
				WORK_STATUS = 1
		</cfquery>
		<cfset work_list = valuelist(get_works.work_id)>
		<cfif not len(work_list)>
			<cfoutput><cf_get_lang no='1593.Aktarılacak Proje İş Kaydı Yok'>!</cfoutput><br/>
		<cfelse>
			<cfloop list="#work_list#" index="i">
			  <cfquery name="get_work" datasource="#DSN#">SELECT * FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#"></cfquery>
				<cfquery name="ADD_WORK_HISTORY" datasource="#dsn#">
					INSERT INTO
						PRO_WORKS_HISTORY
					(
						WORK_CAT_ID,
						WORK_ID,
					<cfif len(get_work.RELATED_WORK_ID)>RELATED_WORK_ID,</cfif>
						PROJECT_EMP_ID,
					<cfif len(get_work.project_id)>PROJECT_ID,</cfif>
					<cfif len(get_work.COMPANY_ID)>COMPANY_ID,</cfif>
					<cfif len(get_work.COMPANY_PARTNER_ID)>COMPANY_PARTNER_ID,</cfif>
						TARGET_START,
						TARGET_FINISH,
						WORK_CURRENCY_ID,
						WORK_PRIORITY_ID,
					<cfif len(get_work.OUTSRC_PARTNER_ID)>OUTSRC_CMP_ID,OUTSRC_PARTNER_ID,</cfif>
						UPDATE_DATE,
						UPDATE_AUTHOR				
					)
						VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.work_cat_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.work_id#">,
						<cfif len(get_work.RELATED_WORK_ID)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_work.related_work_id#">,</cfif>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">,
						<cfif len(get_work.project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.project_id#">,</cfif>
						<cfif len(get_work.COMPANY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.company_id#">,</cfif>
						<cfif len(get_work.COMPANY_PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.company_partner_id#">,</cfif>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_work.target_start)#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_work.target_finish)#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.work_currency_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.work_priority_id#">,
						<cfif len(get_work.OUTSRC_PARTNER_ID)>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.outsrc_cmp_id#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_work.outsrc_partner_id#">,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
					)
				</cfquery>
			 </cfloop>
				<cfquery name="update_work" datasource="#dsn#">
					UPDATE
						PRO_WORKS
					SET
						PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
					WHERE
						WORK_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#work_list#">)
				</cfquery>
			 <cfif listlen(work_list)><cfoutput>#listlen(work_list,',')# <cf_get_lang_main no='670.Adet'> <cf_get_lang no='1594.Proje İş Kaydının Aktarımı Yapıldı'></cfoutput><br/></cfif>
		</cfif>
	</cfif>
	<cfif isdefined("attributes.opportunity")>
	<cfquery datasource="#DSN3#" name="get_opportunities">
	  <!--- Fırsat Teklifleri --->  
		SELECT   
			OPP_ID
		FROM 
			OPPORTUNITIES
		WHERE  
			OPP_STATUS = 1 AND 
			SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_emp_id#"> AND 
			RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
	</cfquery>
		<cfset opp_list = valuelist(get_opportunities.OPP_ID)>
		<cfif not listlen(opp_list)>
			<cfoutput><cf_get_lang no='1596.Aktarılacak fırsat kaydı yok'></cfoutput><br/>
		<cfelse>
			<cfquery name="update_opportunities" datasource="#dsn3#">
				UPDATE  
					OPPORTUNITIES 
				SET 
					SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> 
				WHERE 
					OPP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#opp_list#">)
			</cfquery>
			<cfoutput>#listlen(opp_list,',')# <cf_get_lang_main no='670.Adet'> <cf_get_lang no='1597.Fırsat İş Kaydı Aktarıldı'></cfoutput><br/>		
		</cfif>
	</cfif>
	<cfif isdefined("attributes.sales_offer")>
		<!--- Satış Teklifler --->		
		<cfquery name="get_sales_offer" datasource="#DSN3#">
				SELECT
					*		
				FROM
					OFFER
				WHERE
					SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_emp_id#"> AND 
					OFFER_ZONE = 0 AND 
					PURCHASE_SALES = 1 AND 
					OFFER_STATUS = 1 AND 
					IS_PROCESSED = 0 AND 
					OFFER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND 
					OFFER_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">	
				
				UNION ALL
				
				SELECT
					*	
				FROM
					OFFER O
				WHERE
					SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_emp_id#"> AND 
					OFFER_ZONE=1 AND 
					PURCHASE_SALES=0 AND 
					OFFER_STATUS = 1 AND 
					IS_PROCESSED=0 AND 
					OFFER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND 
					OFFER_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">	
		</cfquery>
		<cfset sales_offer_list = valuelist(get_sales_offer.OFFER_ID)>
			<cfif not len(sales_offer_list)>
				<cfoutput><cf_get_lang no='1595.Aktarılacak satış teklifi yok'>!</cfoutput><br/>
			<cfelse>
				<cfloop list="#sales_offer_list#" index="c">
					<cfquery name="get_offersales_id" datasource="#DSN3#">SELECT * FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#c#"></cfquery>
					<cfquery name="ADD_SALES_OFFER_HISTORY" datasource="#DSN3#">
						INSERT INTO
							OFFER_HISTORY
							(
							OFFER_ID,
							OPP_ID,
							OFFER_NUMBER,
							OFFER_STATUS,
							OFFER_CURRENCY,
							PURCHASE_SALES,
							OFFER_ZONE,
							PRIORITY_ID,
							OFFER_HEAD,
							OFFER_DETAIL,
							GUEST,
							COMPANY_CAT,
							CONSUMER_CAT,
							OFFER_TO,
							OFFER_TO_PARTNER,
							CONSUMER_ID,
							COMPANY_ID,
							PARTNER_ID,
							EMPLOYEE_ID,
							SALES_PARTNER_ID,
							SALES_EMP_ID,
							NETTOTAL,
							STARTDATE,
							OFFER_DATE,
							DELIVER_PLACE,
							FINISHDATE,
							PRICE,
							TAX,
							OTHER_MONEY,
							PAYMETHOD,
							COMMETHOD_ID,
							IS_PROCESSED,
							IS_PARTNER_ZONE,
							IS_PUBLIC_ZONE,
							INCLUDED_KDV,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP,
							SHIP_METHOD,
							SHIP_ADDRESS,
							PROJECT_ID
							)
						VALUES
							(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_offersales_id.offer_id#">,
							<cfif len(get_sales_offer.OPP_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.opp_id#">,<cfelse>NULL,</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_sales_offer.offer_number#">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="#get_sales_offer.offer_status#">,
							<cfif len(get_sales_offer.OFFER_CURRENCY)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.offer_currency#">,<cfelse>NULL,</cfif>
							<cfqueryparam cfsqltype="cf_sql_bit" value="#get_sales_offer.purchase_sales#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.offer_zone#">,
							<cfif len(get_sales_offer.PRIORITY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.priority_id#">,<cfelse>NULL,</cfif>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_sales_offer.offer_head#">,
							'#get_sales_offer.OFFER_DETAIL#',
							<cfif len(get_sales_offer.GUEST)><cfqueryparam cfsqltype="cf_sql_bit" value="#get_sales_offer.guest#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.COMPANY_CAT)>'#get_sales_offer.COMPANY_CAT#',<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.CONSUMER_CAT)>'#get_sales_offer.CONSUMER_CAT#',<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.OFFER_TO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_sales_offer.offer_to#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.OFFER_TO_PARTNER)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_sales_offer.offer_to_partner#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.CONSUMER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.consumer_id#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.COMPANY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.company_id#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.partner_id#">,<cfelse>NULL,</cfif>
							<cfif len(get_emp_detail.EMPLOYEE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_detail.employee_id#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.SALES_PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.sales_partner_id#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.SALES_EMP_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.NETTOTAL)><cfqueryparam cfsqltype="cf_sql_float" value="#get_sales_offer.nettotal#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.STARTDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdate(get_sales_offer.startdate)#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.DELIVERDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdate(get_sales_offer.deliverdate)#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.DELIVER_PLACE)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.deliver_place#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.FINISHDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdate(get_sales_offer.finishdate)#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.PRICE)><cfqueryparam cfsqltype="cf_sql_float" value="#get_sales_offer.price#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.TAX)><cfqueryparam cfsqltype="cf_sql_float" value="#get_sales_offer.tax#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.OTHER_MONEY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_sales_offer.other_money#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.PAYMETHOD)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.paymethod#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.COMMETHOD_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.commethod_id#">,<cfelse>NULL,</cfif>
							<cfqueryparam cfsqltype="cf_sql_bit" value="#get_sales_offer.is_processed#">,
							<cfif len(get_sales_offer.IS_PARTNER_ZONE)><cfqueryparam cfsqltype="cf_sql_bit" value="#get_sales_offer.is_partner_zone#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.IS_PUBLIC_ZONE)><cfqueryparam cfsqltype="cf_sql_bit" value="#get_sales_offer.is_public_zone#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.INCLUDED_KDV)><cfqueryparam cfsqltype="cf_sql_bit" value="#get_sales_offer.included_kdv#">,<cfelse>NULL,</cfif>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							<cfif len(get_sales_offer.SHIP_METHOD)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.ship_method#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.SHIP_ADDRESS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_sales_offer.ship_address#">,<cfelse>NULL,</cfif>
							<cfif len(get_sales_offer.PROJECT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_sales_offer.project_id#"><cfelse>NULL</cfif>
							)
				</cfquery>
				<cfquery name="update_sales_offer" datasource="#dsn3#">
					UPDATE 
						OFFER
					SET 
						SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> 
					WHERE 
						OFFER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#sales_offer_list#">)
				</cfquery>
			</cfloop>
			<cfoutput>#listlen(sales_offer_list,',')# <cf_get_lang_main no='670.Adet'> <cf_get_lang no='1598.Satış İş Kaydı Aktarıldı'></cfoutput><br/>		
		</cfif>			
	</cfif>
	<!--- Sipariş  Teklifleri ---> 
	<cfif isdefined("attributes.orders")>
		<!--- Sipariş Aktarılacak--->		
		<cfquery name="get_orders" datasource="#DSN3#">
		SELECT
			ORDER_ID
		FROM  
			ORDERS
		WHERE 
			ORDER_STATUS=1 AND
			ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_emp_id#"> AND
			RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		</cfquery>
		<cfset order_list = valuelist(get_orders.ORDER_ID)>
		<cfif not listlen(order_list)>
			<cfoutput><cf_get_lang no='1599.Aktarılacak sipariş kaydı yok'>!</cfoutput><br/>
		<cfelse>
			<cfquery name="update_orders" datasource="#dsn3#"><!--- #attributes.position_code# PK 02022006 --->
				UPDATE
					 ORDERS 
				SET 
					ORDER_EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
				WHERE ORDER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#order_list#">)
			</cfquery>	
				<cfoutput>#listlen(order_list,',')# <cf_get_lang_main no='670.Adet'> <cf_get_lang no='1603.Sipariş Kaydı Aktarıldı'></cfoutput><br/>			
		</cfif>
	</cfif>
	
	<!---      Üye'nin Müşteri Temsilcisi --->
	<cfif isdefined("attributes.consumer")>
		<cfquery name="consumer_record_count" datasource="#dsn#">
		SELECT 
			POSITION_CODE
		FROM
			WORKGROUP_EMP_PAR
		WHERE
			POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_position_code#">
		</cfquery>
	<!---      Üye'nin Müşteri Temsilcisi Aktar --->
		 <cfquery name="update_consumer" datasource="#dsn#">
			UPDATE
				WORKGROUP_EMP_PAR
			SET
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
			WHERE
				POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_position_code#">
		 </cfquery>
		 <cfif consumer_record_count.recordcount gt 0><cfoutput>#consumer_record_count.recordcount# Adet Müşteri Temsilci Aktarımı Yapıldı.</cfoutput><br/></cfif>
		 <cfif consumer_record_count.recordcount eq 0>
			<cfoutput><cf_get_lang no='1600.Çalışana ait Müşteri Temsilciliği Bulunamadı'></cfoutput><br/>
		 </cfif>
	</cfif>
	<cfif isdefined("attributes.offer_purchase")>
		<!--- satınalma teklif --->
		<cfquery datasource="#DSN3#" name="get_purchase_offer">
			SELECT
				*
			FROM
				OFFER O
			WHERE			 
				<!--- EMPLOYEE_ID = #attributes.old_emp_id# AND  --->
				SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_emp_id#"> AND
				OFFER_ZONE = 0 AND 
				PURCHASE_SALES = 0 AND 
				OFFER_STATUS = 1 AND 
				IS_PROCESSED = 0 AND 
				RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND 
				RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">	
		UNION ALL
			SELECT
				*
			FROM
				OFFER
			WHERE
				<!--- EMPLOYEE_ID = #attributes.old_emp_id# AND  --->
				SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_emp_id#"> AND
				OFFER_ZONE = 1 AND 
				PURCHASE_SALES = 1 AND 
				OFFER_STATUS = 1 AND
				IS_PROCESSED = 0 AND 
				RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND 
				RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">	
		</cfquery>
		<cfset offer_list = valuelist(get_purchase_offer.OFFER_ID)>
			<cfif not len(offer_list)>
				<cfoutput><cf_get_lang no='1601.Çalışana Ait Aktarılacak Satınalma Kaydı Yok'>!</cfoutput><br/>
			<cfelse>
			<cfloop list="#offer_list#" index="a">
				<cfquery name="get_offerp" datasource="#DSN3#">
					SELECT * FROM OFFER WHERE OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#a#">
				</cfquery>
				<cfquery name="ADD_OFFER_HISTORY" datasource="#DSN3#">
					INSERT INTO
						OFFER_HISTORY
						(
						OFFER_ID,
						OPP_ID,
						OFFER_NUMBER,
						OFFER_STATUS,
						OFFER_CURRENCY,
						PURCHASE_SALES,
						OFFER_ZONE,
						PRIORITY_ID,
						OFFER_HEAD,
						OFFER_DETAIL,
						GUEST,
						COMPANY_CAT,
						CONSUMER_CAT,
						OFFER_TO,
						OFFER_TO_PARTNER,
						CONSUMER_ID,
						COMPANY_ID,
						PARTNER_ID,
						EMPLOYEE_ID,
						SALES_PARTNER_ID,
						SALES_EMP_ID,
						NETTOTAL,
						STARTDATE,
						DELIVERDATE,
						DELIVER_PLACE,
						FINISHDATE,
						PRICE,
						TAX,
						OTHER_MONEY,
						PAYMETHOD,
						COMMETHOD_ID,
						IS_PROCESSED,
						IS_PARTNER_ZONE,
						IS_PUBLIC_ZONE,
						INCLUDED_KDV,
						RECORD_EMP,
						RECORD_DATE,
						RECORD_IP,
						SHIP_METHOD,
						SHIP_ADDRESS,
						PROJECT_ID
						)
					VALUES
						(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_offerp.offer_id#">,
						<cfif len(get_purchase_offer.OPP_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.opp_id#">,<cfelse>NULL,</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_purchase_offer.offer_number#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#get_purchase_offer.offer_status#">,
						<cfif len(get_purchase_offer.OFFER_CURRENCY)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.offer_currency#">,<cfelse>NULL,</cfif>
						<cfqueryparam cfsqltype="cf_sql_bit" value="#get_purchase_offer.purchase_sales#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.offer_zone#">,
						<cfif len(get_purchase_offer.PRIORITY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.priority_id#">,<cfelse>NULL,</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#get_purchase_offer.offer_head#">,
						'#get_purchase_offer.OFFER_DETAIL#',
						<cfif len(get_purchase_offer.GUEST)><cfqueryparam cfsqltype="cf_sql_bit" value="#get_purchase_offer.guest#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.COMPANY_CAT)>'#get_purchase_offer.COMPANY_CAT#',<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.CONSUMER_CAT)>'#get_purchase_offer.CONSUMER_CAT#',<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.OFFER_TO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_purchase_offer.offer_to#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.OFFER_TO_PARTNER)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_purchase_offer.offer_to_partner#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.CONSUMER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.consumer_id#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.COMPANY_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.company_id#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.partner_id#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.EMPLOYEE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.employee_id#">,<cfelse>NULL,</cfif><!--- <cfif len(get_emp_detail.EMPLOYEE_ID)>#get_emp_detail.EMPLOYEE_ID#,<cfelse>NULL,</cfif> --->
						<cfif len(get_purchase_offer.SALES_PARTNER_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.sales_partner_id#">,<cfelse>NULL,</cfif>
						<cfif len(get_emp_detail.EMPLOYEE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_detail.employee_id#">,<cfelse>NULL,</cfif><!--- <cfif len(get_purchase_offer.SALES_EMP_ID )>#get_purchase_offer.SALES_EMP_ID#,<cfelse>NULL,</cfif> --->
						<cfif len(get_purchase_offer.NETTOTAL)><cfqueryparam cfsqltype="cf_sql_float" value="#get_purchase_offer.nettotal#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.STARTDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdate(get_purchase_offer.startdate)#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.DELIVERDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdate(get_purchase_offer.deliverdate)#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.DELIVER_PLACE)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.deliver_place#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.FINISHDATE)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdate(get_purchase_offer.finishdate)#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.PRICE)><cfqueryparam cfsqltype="cf_sql_float" value="#get_purchase_offer.price#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.TAX)><cfqueryparam cfsqltype="cf_sql_float" value="#get_purchase_offer.tax#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.OTHER_MONEY)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_purchase_offer.other_money#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.PAYMETHOD)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.paymethod#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.COMMETHOD_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.commethod_id#">,<cfelse>NULL,</cfif>
						<cfqueryparam cfsqltype="cf_sql_bit" value="#get_purchase_offer.is_processed#">,
						<cfif len(get_purchase_offer.IS_PARTNER_ZONE)><cfqueryparam cfsqltype="cf_sql_bit" value="#get_purchase_offer.is_partner_zone#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.IS_PUBLIC_ZONE)><cfqueryparam cfsqltype="cf_sql_bit" value="#get_purchase_offer.is_public_zone#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.INCLUDED_KDV)><cfqueryparam cfsqltype="cf_sql_bit" value="#get_purchase_offer.included_kdv#">,<cfelse>NULL,</cfif>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
						<cfif len(get_purchase_offer.SHIP_METHOD)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.ship_method#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.SHIP_ADDRESS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_purchase_offer.ship_address#">,<cfelse>NULL,</cfif>
						<cfif len(get_purchase_offer.PROJECT_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_purchase_offer.project_id#"><cfelse>NULL</cfif>
						)
			</cfquery>
			<cfquery name="update_offerp" datasource="#dsn3#">
				UPDATE
					OFFER
				SET
					SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
				WHERE 
					OFFER_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#offer_list#">)
			</cfquery>
		</cfloop>
		<cfoutput>#listlen(offer_list,',')# <cf_get_lang_main no='670.Adet'> <cf_get_lang no='1602.Satınalma Teklifi Aktarımı Yapıldı'></cfoutput><br/>
	  </cfif>			
	</cfif>
	<!---Fiziki varlık sorumlusu --->
	<cfif isdefined("attributes.assetp")>
		<cfquery name="get_assetp" datasource="#dsn#">
			SELECT 
				ASSETP_ID
			FROM
				ASSET_P
			WHERE
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_emp_id#"> AND
				STATUS = 1 AND
				RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		</cfquery>
		<cfset asset_list = valuelist(get_assetp.ASSETP_ID)>
		<cfif not len(asset_list)>
			<cfoutput><cf_get_lang no='789.Çalışana Ait Aktarılacak Fiziki Varlık Kaydı Yok'>!</cfoutput><br/>
		<cfelse>
			<cfloop list="#asset_list#" index="assetp_id">
				<cf_wrk_get_history datasource= "#dsn#" source_table="ASSET_P" target_table= "ASSET_P_HISTORY" record_id="#assetp_id#"  record_name="ASSETP_ID">
			</cfloop>
			<cfquery name="upd_assetp" datasource="#dsn#">
				UPDATE 
					ASSET_P
				SET
					EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">,
					POSITION_CODE = <cfif len(attributes.position_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#"><cfelse>NULL</cfif>,
					UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				WHERE
					ASSETP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#asset_list#">)
			</cfquery>
		</cfif>
	</cfif>
	<script type="text/javascript">
		location.href = document.referrer;	
	</script>
