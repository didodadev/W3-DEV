<cfquery name="ADD_POS" datasource="#DSN3#">
	INSERT INTO
		POS_EQUIPMENT
	(
		EQUIPMENT,
		EQUIPMENT_CODE,
        PATH,
        OFFLINE_PATH,
        FILENAME,
		BRANCH_ID,
		ASSETP_ID,
		CASHIER1,
		CASHIER2,
		CASHIER3,
		TYPE,
        SERIAL_NUMBER,
        MALI_NO,
		IS_STATUS,
		USE_FOREIGN_CURRENCY,
		USE_CATEGORY_ICON,
		USE_PRODUCT_IMAGE,
		USE_CUSTOMER_RECORD,
		USE_LOYALTY_CARD,
		CUSTOMER_ID,
		AMOUNT_ROUND,
		USE_SERIAL_NO,
		USE_LOT_NO,
		POS_PROCESS_CAT,
		PRICE_CAT_ID,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP
	)
	VALUES
	(
		'#attributes.equipment#',
		'#attributes.EQUIPMENT_CODE#',
        '#attributes.PATH#',
        '#attributes.OFFLINE_PATH#',
        '#attributes.FILENAME#',
		<cfif len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.assetp_id) and len(attributes.assetp)>#attributes.assetp_id#<CFELSE>NULL</cfif>,
		<cfif isdefined("attributes.pos_code_1") and len(attributes.pos_code1)>'#attributes.pos_code1#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.pos_code_2") and len(attributes.pos_code2)>'#attributes.pos_code2#'<cfelse>NULL</cfif>,
		<cfif isdefined("attributes.pos_code_3") and len(attributes.pos_code3)>'#attributes.pos_code3#'<cfelse>NULL</cfif>,
		'#attributes.TYPE#',
        '#attributes.SERIAL_NUMBER#',
        '#attributes.MALI_NO#',
		1,
		<cfif attributes.type eq 1>
		<cfif isDefined("attributes.USE_FOREIGN_CURRENCY") and attributes.USE_FOREIGN_CURRENCY eq 1 ><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		<cfif isDefined("attributes.USE_CATEGORY_ICON") and attributes.USE_CATEGORY_ICON eq 1 ><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		<cfif isDefined("attributes.USE_PRODUCT_IMAGE") and attributes.USE_PRODUCT_IMAGE eq 1 ><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		<cfif isDefined("attributes.USE_CUSTOMER_RECORD") and attributes.USE_CUSTOMER_RECORD eq 1 ><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		<cfif isDefined("attributes.USE_LOYALTY_CARD") and attributes.USE_LOYALTY_CARD eq 1 ><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		<cfelse>
		0,
		0,
		0,
		0,
		0,
		</cfif>
		<cfif isDefined("attributes.customer_id") and len(attributes.customer_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.customer_id#"><cfelse>NULL</cfif>,
		<cfif isdefined("attributes.amount_round") and len(attributes.amount_round)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.amount_round#"><cfelse>NULL</cfif>,
		<cfif isDefined("attributes.USE_SERIAL_NO") and len(attributes.USE_SERIAL_NO)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.USE_SERIAL_NO#"><cfelse>NULL</cfif>,
		<cfif isDefined("attributes.USE_LOT_NO") and len(attributes.USE_LOT_NO)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.USE_LOT_NO#"><cfelse>NULL</cfif>,
		<cfif isDefined("attributes.pos_process_cat") and len(attributes.pos_process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_process_cat#"><cfelse>NULL</cfif>,
		<cfif isDefined("attributes.price_cat_id") and len(attributes.price_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_cat_id#"><cfelse>NULL</cfif>,
		#session.ep.userid#,
		#now()#,
		'#cgi.remote_addr#'
	)
</cfquery>
<script type="text/javascript">
	<cfif isDefined("attributes.draggable")>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
	<cfelse>
		self.close();
	</cfif>
	window.location.href = '<cfoutput>#request.self#?fuseaction=finance.list_pos_equipment</cfoutput>';
</script>
