<cfif isdefined("attribute.date_cont") and len(attribute.date_cont)>
	<cf_date tarih= "attributes.date_cont">
</cfif>
<cfif attributes.valid_type eq 1 or not LEN(attributes.valid_type) >
	<cfquery name="MY_VALIDS_1" datasource="#DSN#" >
		
			SELECT 
				'' AS DETAIL,
				EVENT.EVENT_HEAD AS HEAD,
				EVENT.VALIDATOR_POSITION_CODE AS VALIDATOR,
				1 AS VAL_TYPE,
				EVENT.RECORD_DATE,
				EVENT.RECORD_EMP,
				''  AS RECORD_EMP_STR,
				1 AS RECORD_TYPE,		
				'Ajanda' AS MODULE_TYPE,
				'agenda.form_upd_event'  as LINK,
				'event_id' AS LINK2,
				1 AS LINK_TYPE,
				EVENT_ID AS ID
			FROM 
				EVENT as EVENT
			WHERE 
				EVENT.VALIDATOR_POSITION_CODE= #SESSION.EP.POSITION_CODE# AND 
				VALID IS NULL AND 
				LINK_ID IS NULL
			
	</cfquery>
</cfif>
<!--- <cfif (attributes.valid_type gte 2 and attributes.valid_type lte 5) or not len(attributes.valid_type)>
<cfquery name="MY_VALIDS_2" datasource="#DSN3#" >
	<cfif attributes.valid_type eq 2 or not len(attributes.valid_type)>
	
		SELECT
			'' AS DETAIL,
			O.OFFER_HEAD AS HEAD,
			0 AS VALIDATOR,<!---PK 14032006 30güne silinsin  O.VALIDATOR_POSITION_CODE AS VALIDATOR, --->
			1 AS VAL_TYPE,
			O.RECORD_DATE,
			O.RECORD_MEMBER AS RECORD_EMP,
			''  AS RECORD_EMP_STR,
			1 AS RECORD_TYPE,
			'Satış Teklifi' AS MODULE_TYPE,
			'sales.detail_offer_tv'  AS LINK,
			'offer_id' AS LINK2,
			1 AS LINK_TYPE,
			O.OFFER_ID AS ID
		FROM
			OFFER O
		WHERE
			<!--- O.VALIDATOR_POSITION_CODE= #SESSION.EP.POSITION_CODE# AND
			VALID IS NULL AND  --->
			OFFER_ZONE=0 AND 
			PURCHASE_SALES=1
	
	UNION  ALL
	
		SELECT
			'' AS DETAIL,
			O.OFFER_HEAD AS HEAD,
			0 AS VALIDATOR,<!--- O.VALIDATOR_POSITION_CODE AS VALIDATOR, --->
			1 AS VAL_TYPE,
			O.RECORD_DATE,
			O.RECORD_MEMBER AS RECORD_EMP,
			''  AS RECORD_EMP_STR,
			2 AS RECORD_TYPE,
			'Satış Teklifi' AS MODULE_TYPE,
			'sales.detail_offer_pta&offer_id='  AS LINK,
			'offer_id' AS LINK2,
			1 AS LINK_TYPE,
			O.OFFER_ID AS ID
		FROM
			OFFER O
		WHERE
			<!--- O.VALIDATOR_POSITION_CODE=#SESSION.EP.POSITION_CODE# AND
			VALID IS NULL AND  --->
			OFFER_ZONE=1 AND 
			PURCHASE_SALES=0
	
	</cfif>

<cfif not len(attributes.valid_type)>
	UNION ALL		
</cfif>

	<cfif attributes.valid_type eq 3 or  not len(attributes.valid_type)>
			
				SELECT
					'' AS DETAIL,
					O.OFFER_HEAD AS HEAD,
					0 AS VALIDATOR,<!--- O.VALIDATOR_POSITION_CODE AS VALIDATOR, --->
					1 AS VAL_TYPE,
					O.RECORD_DATE,
					O.RECORD_MEMBER AS RECORD_EMP,
					''  AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'Satınalma Teklifi' AS MODULE_TYPE,
					'purchase.detail_offer_ta'  AS LINK,
					'offer_id' AS LINK2,
					1 AS LINK_TYPE,
					O.OFFER_ID AS ID
				FROM
					OFFER O
				WHERE
					<!--- O.VALIDATOR_POSITION_CODE=#SESSION.EP.POSITION_CODE# AND
					VALID IS NULL AND  --->
					OFFER_ZONE=0 AND 
					PURCHASE_SALES=0
			
		UNION ALL
			
				SELECT
					'' AS DETAIL,
					O.OFFER_HEAD AS HEAD,
					0 AS VALIDATOR,<!--- O.VALIDATOR_POSITION_CODE AS VALIDATOR, --->
					1 AS VAL_TYPE,
					O.RECORD_DATE,
					O.RECORD_MEMBER AS RECORD_EMP,
					''  AS RECORD_EMP_STR,
					2 AS RECORD_TYPE,
					'Satınalma Teklifi' AS MODULE_TYPE,
					'purchase.detail_offer_ptv'  AS LINK,
					'offer_id' AS LINK2,
					1 AS LINK_TYPE,
					O.OFFER_ID AS ID
				FROM
					OFFER O
				WHERE
					<!--- O.VALIDATOR_POSITION_CODE=#SESSION.EP.POSITION_CODE# AND
					VALID IS NULL AND  --->
					OFFER_ZONE=1 AND 
					PURCHASE_SALES=1
			
	</cfif>	

<cfif not len(attributes.valid_type)>
	UNION ALL		
</cfif>

	<cfif attributes.valid_type eq 4 or not len(attributes.valid_type)>
		
			SELECT
				'' AS DETAIL,
				O.ORDER_HEAD AS HEAD,
				0 AS VALIDATOR,<!--- O.VALIDATOR_POSITION_CODE AS VALIDATOR, --->
				1 AS VAL_TYPE,
				O.RECORD_DATE,
				O.RECORD_EMP,
				''  AS RECORD_EMP_STR,
				1 AS RECORD_TYPE,
				'Satış Siparişi' AS MODULE_TYPE,
				'sales.detail_order'  AS LINK,
				'order_id' AS LINK2,
				1 AS LINK_TYPE,
				O.ORDER_ID AS ID
			FROM
				ORDERS O
			WHERE
				<!--- O.VALIDATOR_POSITION_CODE=#SESSION.EP.POSITION_CODE# AND
				VALID IS NULL AND  --->
				ORDER_ZONE=0 AND 
				PURCHASE_SALES=1 AND 
				ORDER_STATUS=1
		
	UNION ALL
		
			SELECT
				'' AS DETAIL,
				O.ORDER_HEAD AS HEAD,
				0 AS VALIDATOR,<!--- O.VALIDATOR_POSITION_CODE AS VALIDATOR, --->
				1 AS VAL_TYPE,
				O.RECORD_DATE,
				O.RECORD_EMP,
				''  AS RECORD_EMP_STR,
				2 AS RECORD_TYPE,
				'Satış Siparişi' AS MODULE_TYPE,
				'sales.detail_order_psv'  AS LINK,
				'order_id' AS LINK2,
				1 AS LINK_TYPE,
				O.ORDER_ID AS ID
			FROM
				ORDERS O
			WHERE
				<!--- O.VALIDATOR_POSITION_CODE=#SESSION.EP.POSITION_CODE# AND
				VALID IS NULL AND  --->
				ORDER_ZONE=1 AND 
				PURCHASE_SALES=0 AND 
				ORDER_STATUS=1
		
	</cfif>

<cfif not len(attributes.valid_type)>
	UNION ALL
</cfif>

	<cfif attributes.valid_type eq 5 or not len(attributes.valid_type)>
		
			SELECT
				'' AS DETAIL,
				O.ORDER_HEAD AS HEAD,
				0 AS VALIDATOR,<!--- O.VALIDATOR_POSITION_CODE AS VALIDATOR, --->
				1 AS VAL_TYPE,
				O.RECORD_DATE,
				O.RECORD_EMP,
				''  AS RECORD_EMP_STR,
				1 AS RECORD_TYPE,
				'Satınalma Siparişi' AS MODULE_TYPE,
				'purchase.detail_order'  AS LINK,
				'ORDER_ID' AS LINK2,
				1 AS LINK_TYPE,
				O.ORDER_ID AS ID
			FROM
				ORDERS O
			WHERE
				<!--- O.VALIDATOR_POSITION_CODE= #SESSION.EP.POSITION_CODE# AND
				VALID IS NULL AND  --->
				ORDER_ZONE=0 AND 
				PURCHASE_SALES=0
		
</cfif>
	</cfquery>
</cfif> 
<cfif attributes.valid_type eq 6 or not len(attributes.valid_type)>
	<cfquery name="MY_VALIDS_3" datasource="#DSN3#" >
		
			SELECT
				'' AS DETAIL,
				C.CAMP_HEAD AS HEAD,
				C.VALIDATOR_POSITION_CODE AS VALIDATOR,
				1 AS VAL_TYPE,
				C.RECORD_DATE,
				C.RECORD_EMP,
				''  AS RECORD_EMP_STR,
				1 AS RECORD_TYPE,
				'Kampanya ' AS MODULE_TYPE,
				'campaign.list_campaign&event=upd'  AS LINK,
				'camp_id' AS LINK2,
				1 AS LINK_TYPE,
				C.CAMP_ID AS ID
			FROM
				CAMPAIGNS C
			WHERE
				C.VALIDATOR_POSITION_CODE= #SESSION.EP.POSITION_CODE# AND
				VALID IS NULL
			
		</cfquery>
	</cfif>--->
	
	<cfif attributes.valid_type eq 7 or  not LEN(attributes.valid_type) >
		<cfquery name="MY_VALIDS_4" datasource="#DSN3#" >
			
				SELECT
					'' AS DETAIL,
					C.CATALOG_HEAD AS HEAD,
					C.VALIDATOR_POSITION_CODE AS VALIDATOR,
					1 AS VAL_TYPE,
					C.RECORD_DATE,
					C.RECORD_PAR AS RECORD_EMP,
					''  AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'Ürün Katalog ' AS MODULE_TYPE,
					'product.form_upd_catalog'  AS LINK,
					'id' AS LINK2,
					1 AS LINK_TYPE,
					C.CATALOG_ID AS ID
				FROM
					CATALOG C
				WHERE
					C.VALIDATOR_POSITION_CODE= #SESSION.EP.POSITION_CODE# AND						
					VALID IS NULL
			
		</cfquery>
	</cfif>
	<cfif attributes.valid_type eq 8 or  not LEN(attributes.valid_type) >
		<cfquery name="MY_VALIDS_5" datasource="#DSN3#" >
			
				SELECT
					'' AS DETAIL,
					P.PROM_HEAD AS HEAD,
					P.VALIDATOR_POSITION_CODE AS VALIDATOR,
					1 AS VAL_TYPE,
					P.RECORD_DATE,
					P.RECORD_EMP,
					''  AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'Ürün Promosyonlar ' AS MODULE_TYPE,
					'objects.form_upd_prom_popup'  AS LINK,
					'prom_id' AS LINK2,
					2 AS LINK_TYPE,
					P.PROM_ID AS ID
				FROM
					PROMOTIONS P
				WHERE
					P.VALIDATOR_POSITION_CODE= #SESSION.EP.POSITION_CODE# AND						
					VALID IS NULL
			
		</cfquery>
	</cfif>
	<cfif (attributes.valid_type gte 9 and attributes.valid_type lte 16 ) or  not LEN(attributes.valid_type) > 
	<cfquery name="MY_VALIDS_6" datasource="#DSN#" >
		<cfif attributes.valid_type eq 9 or  not LEN(attributes.valid_type) >
			
				SELECT
					'-' AS DETAIL,
					P.ACIKLAMA1 AS HEAD,
					P.VALID_MEMBER AS VALIDATOR,
					1 AS VAL_TYPE,
					UPDATE_DATE AS RECORD_DATE,
					-1000 AS RECORD_EMP,
					''  AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'İK Pozisyonlar ' AS MODULE_TYPE,
					'hr.form_upd_position'  AS LINK,
					'position_id' AS LINK2,
					1 AS LINK_TYPE,
					P.POSITION_ID AS ID
				FROM
					EMPLOYEE_POSITIONS P
				WHERE
					P.VALID_MEMBER= #SESSION.EP.POSITION_CODE# AND
					VALID IS NULL AND
					POSITION_STATUS <> 1
			
		</cfif>
		<cfif not len(attributes.valid_type)>
			UNION ALL
		</cfif>
		<cfif attributes.valid_type eq 10 or not len(attributes.valid_type)>
			
				SELECT
					'' AS DETAIL,
					'' AS HEAD,
					P.VALIDATOR_POSITION_CODE AS VALIDATOR,
					1 AS VAL_TYPE,
					RECORD_DATE,
					RECORD_EMP,
					''  AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'İK İş Başvuruları ' AS MODULE_TYPE,
					'hr.form_upd_app'  AS LINK,
					'empapp_id' AS LINK2,
					1 AS LINK_TYPE,
					P.EMPAPP_ID AS ID
				FROM
					EMPLOYEES_APP P
				WHERE
					P.VALIDATOR_POSITION_CODE= #SESSION.EP.POSITION_CODE# AND				
					VALID IS NULL
			
	</cfif>		
	<cfif not len(attributes.valid_type)>
		UNION ALL
	</cfif>		
	<cfif attributes.valid_type eq 11 or not len(attributes.valid_type)>
			
				SELECT
					'' AS DETAIL,
					'' HEAD,
					VALIDATOR_POS_1 AS VALIDATOR,
					1 AS VAL_TYPE,
					RECORD_DATE,
					 -1 AS RECORD_EMP,
					RECORD_KEY AS 	RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'İK Yedekler  ' AS MODULE_TYPE,
					'hr.form_upd_standby'  AS LINK,
					'sb_id' AS LINK2,
					1 AS LINK_TYPE,
					SB_ID  AS ID
				FROM
					EMPLOYEE_POSITIONS_STANDBY as EMPLOYEE_POSITIONS_STANDBY
				WHERE
					VALIDATOR_POS_1= #SESSION.EP.POSITION_CODE# AND				
					VALID_1 IS NULL
			UNION ALL 
				SELECT
					'' AS DETAIL,
					'' HEAD,
					VALIDATOR_POS_2 AS VALIDATOR,
					1 AS VAL_TYPE,
					RECORD_DATE,
					-1 AS RECORD_EMP,
					RECORD_KEY AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'İK Yedekler  ' AS MODULE_TYPE,
					'hr.form_upd_standby'  AS LINK,
					'sb_id' AS LINK2,
					1 AS LINK_TYPE,
					SB_ID  AS ID
				FROM
					EMPLOYEE_POSITIONS_STANDBY as EMPLOYEE_POSITIONS_STANDBY
				WHERE
					VALIDATOR_POS_2= #SESSION.EP.POSITION_CODE# AND	
					VALID_2 IS NULL
			
	</cfif>
	<cfif not len(attributes.valid_type)>
		UNION ALL
	</cfif>		
	<cfif attributes.valid_type eq 12 or not len(attributes.valid_type)>
			
				SELECT
					DETAIL,
					'' AS HEAD,
					P.VALIDATOR_POSITION_CODE AS VALIDATOR,
					1 AS VAL_TYPE,
					RECORD_DATE,
					RECORD_EMP,
					''  AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'İK İzin Talebi ' AS MODULE_TYPE,
					'myhome.form_upd_offtime_popup'  AS LINK,
					'offtime_id' AS LINK2,
					2 AS LINK_TYPE,
					P.OFFTIME_ID AS ID
				FROM
					OFFTIME P
				WHERE
					P.VALIDATOR_POSITION_CODE= #SESSION.EP.POSITION_CODE# AND					
					VALID IS NULL
			
	</cfif>
	<cfif not len(attributes.valid_type)>
		UNION ALL
	</cfif>		
	<cfif attributes.valid_type eq 13 or not len(attributes.valid_type)>
			
				SELECT
					'' AS DETAIL,
					NOTICE_HEAD AS HEAD,
					P.VALIDATOR_POSITION_CODE AS VALIDATOR,
					1 AS VAL_TYPE,
					RECORD_DATE,
					RECORD_EMP,
					''  AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'İK İlanlar ' AS MODULE_TYPE,
					'hr.form_upd_notice'  AS LINK,
					'notice_id' AS LINK2,
					1 AS LINK_TYPE,
					P.NOTICE_ID AS ID
				FROM
					NOTICES P
				WHERE
					P.VALIDATOR_POSITION_CODE= #SESSION.EP.POSITION_CODE# AND		
					VALID IS NULL
				
	</cfif>

<cfif not len(attributes.valid_type)>
	UNION ALL
</cfif>		

	<cfif attributes.valid_type eq 14 or not len(attributes.valid_type)>
			
				SELECT 
					'' AS DETAIL,
					'' AS HEAD,
					MANAGER_1_POS  AS VALIDATOR,
					1 AS VAL_TYPE,
					RECORD_DATE,
					-1 AS RECORD_EMP,
					RECORD_KEY AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'İK Performans ' AS MODULE_TYPE,
					'hr.form_upd_perf_emp'  AS LINK,
					'per_id' AS LINK2,
					1 AS LINK_TYPE,
					PER_ID AS ID
				FROM 
					EMPLOYEE_PERFORMANCE AS EMPLOYEE_PERFORMANCE
				WHERE
					EMPLOYEE_PERFORMANCE.MANAGER_1_POS = #SESSION.EP.POSITION_CODE# AND
					EMPLOYEE_PERFORMANCE.VALID_1 IS NULL AND
					EMP_ID IS NOT NULL
			
		UNION ALL		
			
				SELECT 
					'' AS DETAIL,
					'Performans Degerlendirme Testleri' AS HEAD,
					MANAGER_2_POS  AS VALIDATOR,
					1 AS VAL_TYPE,
					RECORD_DATE,
					-1 AS RECORD_EMP,
					RECORD_KEY AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'İK Performans ' AS MODULE_TYPE,
					'hr.form_upd_performance'  AS LINK,
					'per_id' AS LINK2,
					1 AS LINK_TYPE,
					PER_ID AS ID
				FROM 
					EMPLOYEE_PERFORMANCE as EMPLOYEE_PERFORMANCE
				WHERE
					EMPLOYEE_PERFORMANCE.MANAGER_2_POS = #SESSION.EP.POSITION_CODE# AND
					EMPLOYEE_PERFORMANCE.VALID_2 IS NULL AND
					EMP_ID IS NOT NULL	 
			
	UNION ALL
			
				SELECT 
					'' AS DETAIL,
					'' AS HEAD,
					MANAGER_1_POS  AS VALIDATOR,
					1 AS VAL_TYPE,
					RECORD_DATE,
					-1 AS RECORD_EMP,
					RECORD_KEY AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'İK Performans ' AS MODULE_TYPE,
					'hr.form_upd_app_performance'  AS LINK,
					'per_id' AS LINK2,
					1 AS LINK_TYPE,
					PER_ID AS ID
				FROM 
					EMPLOYEE_PERFORMANCE as  EMPLOYEE_PERFORMANCE
				WHERE
					EMPLOYEE_PERFORMANCE.MANAGER_1_POS = #SESSION.EP.POSITION_CODE# AND
					EMPLOYEE_PERFORMANCE.VALID_1 IS NULL AND
					EMP_ID IS NULL	
			
		UNION ALL
			
				SELECT 
					'' AS DETAIL,
					'Performans Değerlendirme Testleri' AS HEAD,
					MANAGER_2_POS  AS VALIDATOR,
					1 AS VAL_TYPE,
					RECORD_DATE,
					-1 AS RECORD_EMP,
					RECORD_KEY AS RECORD_EMP_STR,
					1 AS RECORD_TYPE,
					'İK Performans ' AS MODULE_TYPE,
					'hr.form_upd_app_performance'  AS LINK,
					'per_id' AS LINK2,
					1 AS LINK_TYPE,
					PER_ID AS ID
				 FROM 
					EMPLOYEE_PERFORMANCE as EMPLOYEE_PERFORMANCE
				 WHERE
					EMPLOYEE_PERFORMANCE.MANAGER_2_POS = #SESSION.EP.POSITION_CODE# AND
					EMPLOYEE_PERFORMANCE.VALID_2 IS NULL AND
					EMP_ID IS NULL	   
					
	</cfif>

<cfif not len(attributes.valid_type)>
	UNION ALL
</cfif>						 

	<cfif attributes.valid_type eq 15 or not len(attributes.valid_type)>
		
			SELECT
				'' AS DETAIL,
				SETUP_OFFTIME.OFFTIMECAT AS HEAD,
				#SESSION.EP.USERID# AS VALIDATOR,
				1 AS VAL_TYPE,
				OFFTIME.RECORD_DATE,
				OFFTIME.RECORD_EMP,
				''  AS RECORD_EMP_STR,
				1 AS RECORD_TYPE,
				'İzin Talepleri ' AS MODULE_TYPE,
				'myhome.form_upd_offtime_popup'  AS LINK,
				'offtime_id' AS LINK2,
				2 AS LINK_TYPE,
				OFFTIME.OFFTIME_ID AS ID
			FROM
				OFFTIME,
				SETUP_OFFTIME
			WHERE
				VALID IS NULL AND
				VALIDATOR_POSITION_CODE =#SESSION.EP.POSITION_CODE# AND
				OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID	
			
	</cfif>					  

<cfif not len(attributes.valid_type)>
	UNION ALL
</cfif>						 

	<cfif attributes.valid_type eq 16 or not len(attributes.valid_type)>
		
			SELECT
				'' AS DETAIL,
				DETAIL AS HEAD,
				#SESSION.EP.USERID# AS VALIDATOR,
				1 AS VAL_TYPE,
				RECORD_DATE,
				RECORD_EMP,
				''  AS RECORD_EMP_STR,
				1 AS RECORD_TYPE,
				'Viziteler Talepleri ' AS MODULE_TYPE,
				'ehesap.popup_upd_ssk_fee_self'  AS LINK,
				'fee_id' AS LINK2,
				2 AS LINK_TYPE,
				FEE_ID AS ID
			FROM
				EMPLOYEES_SSK_FEE 
			WHERE
				VALID_EMP =#SESSION.EP.USERID#
		UNION 
			SELECT
				'' AS DETAIL,
				'Çalışan Yakını Vizite Onayı ' AS HEAD,
				#SESSION.EP.USERID# AS VALIDATOR,
				1 AS VAL_TYPE,
				RECORD_DATE,
				RECORD_EMP,
				''  AS RECORD_EMP_STR,
				1 AS RECORD_TYPE,
				'Çalışan Yakını Viziteler Talepleri ' AS MODULE_TYPE,
				'ehesap.popup_upd_ssk_fee_relative'  AS LINK,
				'fee_id' AS LINK2,
				2 AS LINK_TYPE,
				FEE_ID AS ID
			FROM
				EMPLOYEES_SSK_FEE_RELATIVE 
			WHERE
				VALID_EMP =#SESSION.EP.USERID#
			
	</cfif>			
		  
</cfquery>
</cfif>		

<!--- <cfif attributes.valid_type eq 17 or  not LEN(attributes.valid_type) >
	<cfquery name="MY_VALIDS_7" datasource="#DSN3#">
		
			SELECT
				'' AS DETAIL,
				CONTRACT_HEAD AS HEAD,
				#SESSION.EP.USERID# AS VALIDATOR,
				1 AS VAL_TYPE,
				RECORD_DATE,
				RECORD_EMP,
				''  AS RECORD_EMP_STR,
				1 AS RECORD_TYPE,
				'Anlaşmalar ' AS MODULE_TYPE,
				'contract.detail_contract_form'  AS LINK,
				'contract_id' AS LINK2,
				1 AS LINK_TYPE,
				P.CONTRACT_ID AS ID
			FROM
				CONTRACT P
			WHERE
				P.EMPLOYEE LIKE  '%,#SESSION.EP.USERID#,%' AND		
				EMPLOYEE_VALID  IS NULL
			
	</cfquery>
</cfif>	
 --->
<cfquery name="qe1" dbtype="query">  
	
	<cfloop from="1" to="7" index="k">
	<cfif k eq 2><cfset k=3></cfif>
		<cfif attributes.valid_type gte 2 and attributes.valid_type lte 5>
			<cfset s = 2 >
		<cfelseif attributes.valid_type gte 9 and attributes.valid_type lt 17>
			<cfset s = 6 >
		<cfelseif attributes.valid_type eq 17>
			<cfset s = 7 >
		<cfelse>
			<cfset s = k>
		</cfif>
		<cfif not len(attributes.valid_type) and k neq 1>
			UNION 
		</cfif>
		<cfif s eq k and isdefined("MY_VALIDS_#s#") >
				 
				SELECT 
					* 
				FROM 
					MY_VALIDS_#k#
				<cfif isdefined("attributes.date_cont") and len(attributes.date_cont) and isdate(attributes.date_cont)>
				WHERE
					RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.date_cont#">
				</cfif>
				
		</cfif>
	</cfloop> 
	
	ORDER BY 
		RECORD_DATE
</cfquery>
