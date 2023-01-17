<cfset attributes.offer_date = #now()#>
<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>
	<cfset offer_due_date = date_add("d",attributes.basket_due_value,attributes.offer_date)>
<cfelse>
	<cfset offer_due_date = #now()#>
</cfif> 
<cfquery name="GET_PROCESS" datasource="#DSN#" maxrows="1">
	SELECT TOP 1
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		<cfif isdefined("session.pp")>
			PTR.IS_PARTNER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
		<cfelseif isdefined("session.ww")>
			PTR.IS_CONSUMER = 1 AND
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
		<cfelse>
			PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		</cfif>
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects2.add_offer%">
	ORDER BY 
		PTR.PROCESS_ROW_ID
</cfquery>
<cfinclude template="../query/get_basket_rows.cfm">

<cfif not GET_PROCESS.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='33.İşlem Tipleri Tanımlı Değil! Lütfen Müşteri Temsilcinize Başvurun'>.");
		history.back();
	</script>
	<cfabort>
</cfif>

<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="GET_OFFER_CODE" datasource="#DSN3#">
		SELECT 
			OFFER_NO, 
			OFFER_NUMBER 
		FROM
			GENERAL_PAPERS
		WHERE 
			PAPER_TYPE = 0 
			AND ZONE_TYPE = 0
	</cfquery>
	<cfquery name="UPD_OFFER_CODE" datasource="#DSN3#">
		UPDATE 
			GENERAL_PAPERS 
		SET 
			OFFER_NUMBER = OFFER_NUMBER+1
		WHERE 
			PAPER_TYPE = 0 AND ZONE_TYPE = 0
	</cfquery>
	<cfquery name="ADD_OFFER" datasource="#DSN3#" result="MAX_ID">
		INSERT INTO 
			OFFER 
		(
			CONSUMER_ID,
			PARTNER_ID,
			COMPANY_ID,
			OFFER_ZONE,
			OFFER_STATUS,
			OFFER_CURRENCY,
			OFFER_NUMBER,
			PAYMETHOD,						
			OFFER_TO,
			OFFER_TO_PARTNER,
			INCLUDED_KDV,
			DELIVERDATE,
			DELIVER_PLACE,
			LOCATION_ID,
			PURCHASE_SALES,
			STARTDATE,
			FINISHDATE,
			IS_PUBLIC_ZONE,
			IS_PARTNER_ZONE, 
			OFFER_HEAD,
			OFFER_DETAIL,
			OFFER_STAGE,
			OFFER_DATE,
			PRIORITY_ID,
			PRICE,
			SHIP_METHOD,
			CARD_PAYMETHOD_ID,
			CARD_PAYMETHOD_RATE,
			SHIP_ADDRESS,
			DUE_DATE,
			CITY_ID,
			COUNTY_ID,
			RECORD_DATE,
			RECORD_IP,
			RECORD_CONS,
			RECORD_PAR
		)
		VALUES 
		(
			<cfif isdefined("session.ww")>
				#session.ww.userid#,
				NULL,
				NULL,
			<cfelse>
				NULL,
				#session.pp.userid#,
				#session.pp.company_id#,
			</cfif>
			1,
			1,
			-2,
			'#GET_OFFER_CODE.OFFER_NO#-#GET_OFFER_CODE.OFFER_NUMBER#',
			<cfif len(attributes.paymethod_id) and len(attributes.paymethod)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
			<cfif isdefined("session.pp")>
			',#session.pp.company_id#,',
			',#session.pp.userid#,',
			<cfelse>
			'',
			'',
			</cfif>
			0,
			#now()#,
			0,
			NULL,	
			0,
			NULL,
			NULL,
			<cfif isdefined("session.ww")>1,<cfelse>0,</cfif>
			<cfif isDefined("session.pp")>1,<cfelse>0,</cfif> 
			'#attributes.offer_head#',
			<cfif isdefined("attributes.offer_detail") and len(attributes.offer_detail)>'#attributes.offer_detail#'<cfelse>NULL</cfif>,
			#GET_PROCESS.PROCESS_ROW_ID#,
			#now()#,
			NULL,
			0,
			NULL,
			<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
				#attributes.card_paymethod_id#,
				<cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>#attributes.commission_rate#,<cfelse>NULL,</cfif>
			<cfelse>
				NULL,
				NULL,
			</cfif>
			'#attributes.ship_address#',
			#now()#,
			<cfif isdefined("attributes.city_id") and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
			#now()#,
			'#cgi.remote_addr#',
			<cfif isdefined("session.ww")>
			#session.ww.userid#
			NULL,
			<cfelse>
			NULL,
			#session.pp.userid#
			</cfif>
			
			)
	</cfquery>
	<cfoutput query="get_rows">
        <cfquery name="ADD_PRODUCT_TO_OFFER" datasource="#DSN3#">
            INSERT INTO 
                OFFER_ROW 
                (
                OFFER_ID, 
                PRODUCT_ID,
                STOCK_ID,
                QUANTITY,
                UNIT,
                UNIT_ID,
                PRICE,
                TAX,
                PRODUCT_NAME,
                DELIVER_DATE
                )
            VALUES 
                (
                #MAX_ID.IDENTITYCOL#,
                #product_id#,
                #stock_id#,
                #quantity#,
                'adet',
                #PRODUCT_UNIT_ID#,					
                #price#,
                #tax#,
                '#PRODUCT_NAME#',
                #now()#
                )
        </cfquery>
	</cfoutput>
	<cfscript>basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:4,process_type:0);</cfscript>
	</cftransaction>
</cflock>

<cfquery name="del_rows" datasource="#dsn3#">
	DELETE FROM
		ORDER_PRE_ROWS
	WHERE
		<cfif isdefined("session.pp")>
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
		<cfelseif isdefined("session.ww.userid")>
			RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
		</cfif>
		PRODUCT_ID IS NOT NULL
</cfquery>
<cfif isDefined("get_rows.order_row_id") and len(get_rows.order_row_id)>
	<cfquery name="del_rows" datasource="#dsn3#">
		DELETE FROM
			ORDER_PRE_ROWS_SPECS
		WHERE
			MAIN_ORDER_ROW_ID IN (#valuelist(get_rows.order_row_id)#)
	</cfquery>
</cfif>
<cfif isDefined("session.pp")>
	<cfquery name="del_rows" datasource="#dsn3#">
		DELETE FROM
			ORDER_PRE_ROWS_SPECIAL
		WHERE
			RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	</cfquery>
</cfif>

<script type="text/javascript">
	alert("<cf_get_lang no ='1430.Teklif Talebiniz Basariyla Alinmistir Sizinle En Kisa Zamanda Temasa Geçilecektir'>!");
	window.location.href='<cfoutput>#request.self#?fuseaction=objects2.view_list_offer&form_submitted=1</cfoutput>';
</script>
