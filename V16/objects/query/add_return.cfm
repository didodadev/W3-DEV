<cfquery name="GET_STAGE" datasource="#DSN#" maxrows="1">
	SELECT
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
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.add_return%">
	ORDER BY
		PTR.PROCESS_ROW_ID ASC
</cfquery>
<cfif not get_stage.recordcount>
	<script type="text/javascript">
		alert("Servis Durumu Bulunamadı! Müşteri Hizmetlerine Başvurunuz!");
		history.back();
	</script>
	<cfabort>
</cfif>
<cfloop list="#attributes.invoice_row_list#" index="i">
	<cfif isdefined("attributes.is_check#i#")>
		<cfquery name="KONTROL_" datasource="#DSN3#">
			SELECT 
				SUM(AMOUNT) TOTAL_AMOUNT
			FROM 
				SERVICE_PROD_RETURN_ROWS SPRR,
				SERVICE_PROD_RETURN SPR 
			WHERE 
				SPRR.RETURN_ID = SPR.RETURN_ID AND 
				SPRR.INVOICE_ROW_ID = #evaluate('attributes.invoice_row_id#i#')# AND
				SPR.PERIOD_ID = #attributes.period_id# AND
				SPRR.STOCK_ID = #evaluate('attributes.stock_id#i#')#
			<!---BK--->
			<cfif is_return_control eq 1>
				AND SPRR.RETURN_ACT_TYPE = 1
			</cfif>				
		</cfquery>
		
		<cfif kontrol_.recordcount and len(kontrol_.total_amount)>
			<cfset my_sayi_ = kontrol_.total_amount + evaluate('amount#i#')>
			<cfif my_sayi_ gt evaluate('invoice_amount#i#')>
				<script type="text/javascript">
					alert("Toplam Satıştan Fazla İade Alamazsınız!");
					history.back();
				</script>
				<cfabort>
			</cfif>
		</cfif>
	</cfif>
</cfloop>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
	<cfquery name="ADD_RETURN" datasource="#DSN3#" result="MAX_ID">
		INSERT INTO
			SERVICE_PROD_RETURN
		(
			INVOICE_ID,
			PAPER_NO,
			PERIOD_ID,
			SERVICE_COMPANY_ID,
			SERVICE_PARTNER_ID,
			SERVICE_CONSUMER_ID,
			SERVICE_EMPLOYEE_ID,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
		)
		VALUES
		(
			#attributes.invoice_id#,
			'#attributes.paper_no#',
			#attributes.period_id#,
			<cfif len(attributes.service_company_id)>#attributes.service_company_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.service_partner_id)>#attributes.service_partner_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.service_consumer_id)>#attributes.service_consumer_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.service_employee_id)>#attributes.service_employee_id#<cfelse>NULL</cfif>,
			#now()#,
			'#cgi.remote_addr#',
			#session.ep.userid#
		)
	</cfquery>
    <cfset GET_MAX.MAX_ID = MAX_ID.IDENTITYCOL>
	<cfloop list="#attributes.invoice_row_list#" index="i">
		<cfif isdefined("attributes.is_check#i#")>
			<cfset detail= URLEncodedFormat(evaluate("attributes.detail#i#"))>
			<cfquery name="ADD_RETURN_ROWS" datasource="#DSN3#" result="MAX_ID_">
				INSERT INTO
					SERVICE_PROD_RETURN_ROWS
				(
					RETURN_ID,
					STOCK_ID,
					RETURN_TYPE,
					RETURN_ACT_TYPE,
					DETAIL,
					ACCESSORIES,
					PACKAGE,
					AMOUNT,
					INVOICE_ROW_ID,
					RETURN_STAGE
				)
				VALUES
				(
					#get_max.max_id#,
					#evaluate('stock_id#i#')#,
					#evaluate('returncat#i#')#,
					<cfif isdefined("attributes.return_act_type#i#") and len(evaluate('attributes.return_act_type#i#'))>#evaluate('attributes.return_act_type#i#')#<cfelse>NULL</cfif>,
					'#detail#',
					<cfif isdefined("attributes.accessories#i#")>#evaluate('attributes.accessories#i#')#<cfelse>NULL</cfif>,
					#evaluate('package#i#')#,
					#evaluate('amount#i#')#,
					#i#,
					#get_stage.process_row_id#
				)
			</cfquery>
			<cfquery name="GET_MAX_ROW" datasource="#DSN3#">
				SELECT MAX(RETURN_ROW_ID) AS MAX_ID FROM SERVICE_PROD_RETURN_ROWS
			</cfquery>
			<!--- degisim ise ve xml de takip eklensin secili ise uyeye bir takip kaydi yapiyor --->
			<!--- fazla urun ise stogun bloke stok miktari 1 arttirilir--->
			<cfif isdefined("attributes.return_act_type#i#") and len(evaluate('attributes.return_act_type#i#')) and evaluate('attributes.return_act_type#i#') eq 3>
				<cfquery name="UPD_STOCK_STRATEGY" datasource="#DSN3#">
					UPDATE
						STOCK_STRATEGY
					SET
						BLOCK_STOCK_VALUE = ISNULL(BLOCK_STOCK_VALUE,0) + #evaluate('amount#i#')#,
						RETURN_BLOCK_VALUE = #evaluate('amount#i#')#
					WHERE
						STOCK_ID = #evaluate('stock_id#i#')# AND
						STRATEGY_TYPE = 0
				</cfquery>
			</cfif>
			
		</cfif>
	</cfloop>
	</cftransaction>
</cflock>
<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#get_stage.process_row_id#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='SERVICE_PROD_RETURN'
	action_column = 'RETURN_ID'
	action_id='#get_max.max_id#'
	action_page='#request.self#?fuseaction=service.product_return&event=upd&return_id=#get_max.max_id#' 
	warning_description='İade : #get_max.max_id#'>
	<cfloop list="#attributes.invoice_row_list#" index="i">
		<cfif isdefined("attributes.is_check#i#")>
			<cf_workcube_process 
				is_upd='1' 
				old_process_line='0'
				process_stage='#get_stage.process_row_id#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_table='SERVICE_PROD_RETURN_ROWS'
				action_column = 'RETURN_ROW_ID'
				action_id='#GET_MAX_ROW.max_id#'
				action_page='#request.self#?fuseaction=service.product_return&event=upd&return_id=#get_max.max_id#' 
				warning_description='İade Satır: #GET_MAX_ROW.max_id#'>
		</cfif>
	</cfloop>
<script type="text/javascript">
	window.location.href ="<cfoutput>#request.self#?fuseaction=service.product_return&event=upd&return_id=#get_max.max_id#</cfoutput>";
</script>
