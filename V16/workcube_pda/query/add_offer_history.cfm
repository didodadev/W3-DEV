<cfset Pronet_IT = dsn3>
<cfif cgi.HTTP_HOST contains 'pronet'>
	<cfset Pronet_IT = 'Pronet_IT'>
</cfif>
<cfquery name="OFFER" datasource="#DSN3#">
	SELECT
		*
	FROM
		OFFER
	WHERE
		OFFER_ID = #attributes.offer_id#
</cfquery>

<cfquery name="OFFER_ROWS" datasource="#DSN3#">
	SELECT
		*
	FROM
		OFFER_ROW
	WHERE
		OFFER_ID = #attributes.offer_id#
</cfquery>
<cfquery name="GET_OFFER_PDA" datasource="#Pronet_IT#">
	SELECT
		*
	FROM
		OFFER_PDA
	WHERE
		OFFER_ID = #attributes.offer_id#
</cfquery>
<cfquery name="ADD_OFFER_PDA_HISTORY" datasource="#Pronet_IT#">
	INSERT INTO
		OFFER_PDA_HISTORY
		(
			OFFER_ID,
			MONTAGE_END_UNIT_NO,
			MONTAGE_CABLE_BY_CLIENT,
			OFFER_TYPE_ID
		)
	VALUES
		(
			<cfif len(GET_OFFER_PDA.OFFER_ID)>#GET_OFFER_PDA.OFFER_ID#<cfelse>NULL</cfif>,
			<cfif len(GET_OFFER_PDA.montage_end_unit_no)>#GET_OFFER_PDA.montage_end_unit_no#<cfelse>NULL</cfif>,
			<cfif len(GET_OFFER_PDA.montage_cable_by_client)>#GET_OFFER_PDA.montage_cable_by_client#<cfelse>NULL</cfif>,
			<cfif len(GET_OFFER_PDA.offer_type_id)>#GET_OFFER_PDA.offer_type_id#<cfelse>NULL</cfif>
		)
</cfquery>

<cfif len(offer.startdate)>
	<cfset attributes.history_start_date = dateformat(offer.startdate,"dd/mm/yyyy")>
	<cf_date tarih="attributes.history_start_date">
</cfif>
<cfif len(offer.deliverdate)>
	<cfset attributes.history_deliver_date = dateformat(offer.deliverdate,"dd/mm/yyyy")>
	<cf_date tarih="attributes.history_deliver_date">
</cfif>
<cfif len(offer.finishdate)>
	<cfset attributes.history_finish_date = dateformat(offer.finishdate,"dd/mm/yyyy")>
	<cf_date tarih="attributes.history_finish_date">
</cfif>
<cfif len(offer.offer_date)>
	<cfset attributes.history_offer_date = dateformat(offer.offer_date,"dd/mm/yyyy")>
	<cf_date tarih="attributes.history_offer_date">
</cfif>

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
		OFFER_DATE,
		STARTDATE,
		DELIVERDATE,
		DELIVER_PLACE,
		FINISHDATE,
		PRICE,
		TAX,
		SA_DISCOUNT,
		OTV_TOTAL,
		OTHER_MONEY,
		PAYMETHOD,
		COMMETHOD_ID,
		IS_PROCESSED,
		IS_PARTNER_ZONE,
		IS_PUBLIC_ZONE,
		INCLUDED_KDV,
		SHIP_METHOD,
		SHIP_ADDRESS,
		PROJECT_ID,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP		
	)
	VALUES
	(
		#attributes.OFFER_ID#,
		<cfif len(offer.opp_id)>#offer.opp_id#<cfelse>NULL</cfif>,
		'#offer.offer_number#',
		#offer.offer_status#,
		<cfif len(offer.offer_currency)>#offer.offer_currency#<cfelse>NULL</cfif>,
		#offer.purchase_sales#,
		#offer.offer_zone#,
		<cfif len(offer.priority_id)>#offer.priority_id#<cfelse>NULL</cfif>,
		'#offer.offer_head#',
		'#offer.offer_detail#',
		<cfif len(offer.guest)>#offer.guest#<cfelse>NULL</cfif>,
		<cfif len(offer.company_cat)>'#offer.company_cat#'<cfelse>NULL</cfif>,
		<cfif len(offer.consumer_cat)>'#offer.consumer_cat#'<cfelse>NULL</cfif>,
		<cfif len(offer.offer_to)>'#offer.offer_to#'<cfelse>NULL</cfif>,
		<cfif len(offer.offer_to_partner)>'#offer.offer_to_partner#'<cfelse>NULL</cfif>,
		<cfif len(offer.consumer_id)>#offer.consumer_id#<cfelse>NULL</cfif>,
		<cfif len(offer.company_id)>#offer.company_id#<cfelse>NULL</cfif>,
		<cfif len(offer.partner_id)>#offer.partner_id#<cfelse>NULL</cfif>,
		<cfif len(offer.employee_id)>#offer.employee_id#<cfelse>NULL</cfif>,
		<cfif len(offer.sales_partner_id)>#offer.SALES_PARTNER_ID#<cfelse>NULL</cfif>,
		<cfif len(offer.sales_emp_id)>#offer.SALES_EMP_ID#<cfelse>NULL</cfif>,
		<cfif len(offer.nettotal)>#offer.NETTOTAL#<cfelse>NULL</cfif>,
		<cfif len(offer.offer_date)>#attributes.history_offer_date#<cfelse>NULL</cfif>,
		<cfif len(offer.startdate)>#attributes.history_start_date#<cfelse>NULL</cfif>,
		<cfif len(offer.deliverdate)>#attributes.history_deliver_date#<cfelse>NULL</cfif>,
		<cfif len(offer.deliver_place)>#offer.DELIVER_PLACE#<cfelse>NULL</cfif>,
		<cfif len(offer.finishdate)>#attributes.history_finish_date#,<cfelse>NULL,</cfif>
		<cfif len(offer.price)>#offer.PRICE#<cfelse>NULL</cfif>,
		<cfif len(offer.tax)>#offer.TAX#<cfelse>NULL</cfif>,
		<cfif len(offer.sa_discount)>#offer.sa_discount#<cfelse>NULL</cfif>,
		<cfif len(offer.otv_total)>#offer.otv_total#<cfelse>NULL</cfif>,
		<cfif len(offer.other_money)>'#offer.OTHER_MONEY#'<cfelse>NULL</cfif>,
		<cfif len(offer.paymethod)>#offer.PAYMETHOD#<cfelse>NULL</cfif>,
		<cfif len(offer.commethod_id)>#offer.COMMETHOD_ID#<cfelse>NULL</cfif>,
		#offer.is_processed#,
		<cfif len(offer.is_partner_zone)>#offer.IS_PARTNER_ZONE#<cfelse>NULL</cfif>,
		<cfif len(offer.is_public_zone)>#offer.IS_PUBLIC_ZONE#<cfelse>NULL</cfif>,
		<cfif len(offer.included_kdv)>#offer.INCLUDED_KDV#<cfelse>NULL</cfif>,
		<cfif len(offer.ship_method)>#offer.SHIP_METHOD#<cfelse>NULL</cfif>,
		<cfif len(offer.ship_address)>'#OFFER.SHIP_ADDRESS#'<cfelse>NULL</cfif>,
		<cfif len(offer.project_id)>#offer.PROJECT_ID#<cfelse>NULL</cfif>,
		#session.pda.userid#,
		#now()#,
		'#cgi.remote_addr#'
	)
</cfquery>

<cfloop query="OFFER_ROWS">
	<cfquery name="ADD_OFFER_ROW_HISTORY" datasource="#DSN3#">
		INSERT INTO
			OFFER_ROW_HISTORY
		(
			OFFER_ID,
			OFFER_ROW_ID,
			PRODUCT_ID,
			STOCK_ID,
			QUANTITY,
			UNIT,
			PRICE,
			TAX,
			DUEDATE,
			PRODUCT_NAME,
			DESCRIPTION,
			PAY_METHOD_ID,
			PARTNER_ID,
			DELIVER_DATE,
			DELIVER_DEPT,
		<cfif len(DISCOUNT_1)>
			DISCOUNT_1,
		</cfif>
		<cfif len(DISCOUNT_2)>
			DISCOUNT_2,
		</cfif>
		<cfif len(DISCOUNT_3)>
			DISCOUNT_3,
		</cfif>
		<cfif len(DISCOUNT_4)>
			DISCOUNT_4,
		</cfif>
		<cfif len(DISCOUNT_5)>
			DISCOUNT_5,
		</cfif>
		<cfif len(DISCOUNT_COST)>
			DISCOUNT_COST,
		</cfif>
			OTHER_MONEY,
			OTHER_MONEY_VALUE,
			PRICE_OTHER,
			NET_MALIYET,
			MARJ,
			UNIQUE_RELATION_ID,
			PRODUCT_NAME2,
			AMOUNT2,
			UNIT2,
			EXTRA_PRICE,
			EXTRA_PRICE_TOTAL,
			EXTRA_PRICE_OTHER_TOTAL,
			SHELF_NUMBER,
			PRODUCT_MANUFACT_CODE,
			BASKET_EXTRA_INFO_ID,
			SELECT_INFO_EXTRA,
            DETAIL_INFO_EXTRA,
			OTV_ORAN,
			OTVTOTAL,
			WIDTH_VALUE,
			DEPTH_VALUE,
			HEIGHT_VALUE,
			ROW_PROJECT_ID
		)
		VALUES
		(
			#attributes.offer_id#,
			#OFFER_ROW_ID#,
			#PRODUCT_ID#,
			#STOCK_ID#,
			#QUANTITY#,
			<cfif len(UNIT)>'#UNIT#'<cfelse>NULL</cfif>,
			<cfif len(PRICE)>#PRICE#<cfelse>NULL</cfif>,
			<cfif len(TAX)>#TAX#<cfelse>NULL</cfif>,
			<cfif len(DUEDATE)>#DUEDATE#<cfelse>NULL</cfif>,
			<cfif len(PRODUCT_NAME)>'#PRODUCT_NAME#'<cfelse>NULL</cfif>,
			<cfif len(DESCRIPTION)>'#DESCRIPTION#'<cfelse>NULL</cfif>,
			<cfif len(PAY_METHOD_ID)>#PAY_METHOD_ID#<cfelse>NULL</cfif>,
			<cfif len(PARTNER_ID)>#PARTNER_ID#<cfelse>NULL</cfif>,
			<cfif len(DELIVER_DATE)>#createodbcdatetime(DELIVER_DATE)#<cfelse>NULL</cfif>,
			<cfif len(DELIVER_DEPT)>#DELIVER_DEPT#<cfelse>NULL</cfif>,
			<cfif len(DISCOUNT_1)>#DISCOUNT_1#,</cfif>
			<cfif len(DISCOUNT_2)>#DISCOUNT_2#,</cfif>
			<cfif len(DISCOUNT_3)>#DISCOUNT_3#,</cfif>
			<cfif len(DISCOUNT_4)>#DISCOUNT_4#,</cfif>
			<cfif len(DISCOUNT_5)>#DISCOUNT_5#,</cfif>
			<cfif len(DISCOUNT_COST)>#DISCOUNT_COST#,</cfif>
			<cfif len(OTHER_MONEY)>'#OTHER_MONEY#'<cfelse>NULL</cfif>,
			<cfif len(OTHER_MONEY_VALUE)>#OTHER_MONEY_VALUE#<cfelse>NULL</cfif>,
			<cfif len(PRICE_OTHER)>#PRICE_OTHER#<cfelse>0</cfif>,
			<cfif len(NET_MALIYET)>#NET_MALIYET#<cfelse>0</cfif>,
			<cfif len(MARJ)>#MARJ#<cfelse>0</cfif>	,
			<cfif len(UNIQUE_RELATION_ID)>'#UNIQUE_RELATION_ID#'<cfelse>NULL</cfif>,	
			<cfif len(PRODUCT_NAME2)>'#PRODUCT_NAME2#'<cfelse>NULL</cfif>,	
			<cfif len(AMOUNT2)>#AMOUNT2#<cfelse>NULL</cfif>,	
			<cfif len(UNIT2)>'#UNIT2#'<cfelse>NULL</cfif>,	
			<cfif len(EXTRA_PRICE)>#EXTRA_PRICE#<cfelse>NULL</cfif>,	
			<cfif len(EXTRA_PRICE_TOTAL)>#EXTRA_PRICE_TOTAL#<cfelse>NULL</cfif>,
			<cfif len(EXTRA_PRICE_OTHER_TOTAL)>#EXTRA_PRICE_OTHER_TOTAL#<cfelse>NULL</cfif>,	
			<cfif len(SHELF_NUMBER)>'#SHELF_NUMBER#'<cfelse>NULL</cfif>,
			<cfif len(PRODUCT_MANUFACT_CODE)>'#PRODUCT_MANUFACT_CODE#'<cfelse>NULL</cfif>,
			<cfif len(BASKET_EXTRA_INFO_ID)>#BASKET_EXTRA_INFO_ID#<cfelse>NULL</cfif>,
			<cfif len(SELECT_INFO_EXTRA)>#SELECT_INFO_EXTRA#<cfelse>NULL</cfif>,
			<cfif len(DETAIL_INFO_EXTRA)>'#DETAIL_INFO_EXTRA#'<cfelse>NULL</cfif>,
			<cfif len(OTV_ORAN)>#OTV_ORAN#<cfelse>NULL</cfif>,
			<cfif len(OTVTOTAL)>#OTVTOTAL#<cfelse>NULL</cfif>,
			<cfif len(WIDTH_VALUE)>#WIDTH_VALUE#<cfelse>NULL</cfif>,
			<cfif len(DEPTH_VALUE)>#DEPTH_VALUE#<cfelse>NULL</cfif>,
			<cfif len(HEIGHT_VALUE)>#HEIGHT_VALUE#<cfelse>NULL</cfif>,
			<cfif len(ROW_PROJECT_ID)>#ROW_PROJECT_ID#<cfelse>NULL</cfif>
		)
	</cfquery>
</cfloop>
