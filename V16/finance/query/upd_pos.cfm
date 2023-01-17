<cfquery name="UPD_POS" datasource="#DSN3#">
	UPDATE
		POS_EQUIPMENT
	SET
		EQUIPMENT = '#attributes.equipment#',
		EQUIPMENT_CODE = '#attributes.EQUIPMENT_CODE#',
        PATH = '#attributes.PATH#',
        OFFLINE_PATH = '#attributes.OFFLINE_PATH#',
        FILENAME = '#attributes.FILENAME#',
		IS_STATUS = <cfif isdefined("attributes.is_status")>1<cfelse>0</cfif>,
		BRANCH_ID = <cfif len(attributes.branch_id)>#attributes.branch_id#<cfelse>NULL</cfif>,
		CASHIER1 = <cfif isdefined("attributes.pos_code1") and len(attributes.pos_code1)>'#attributes.pos_code1#'<cfelse>NULL</cfif>,
		CASHIER2 = <cfif isdefined("attributes.pos_code2") and len(attributes.pos_code2)>'#attributes.pos_code2#'<cfelse>NULL</cfif>,
		CASHIER3 = <cfif isdefined("attributes.pos_code3") and len(attributes.pos_code3)>'#attributes.pos_code3#'<cfelse>NULL</cfif>,
		TYPE = '#attributes.type#',
        SERIAL_NUMBER = '#attributes.SERIAL_NUMBER#',
        MALI_NO = '#attributes.MALI_NO#',
		ASSETP_ID = <cfif len(attributes.assetp_id) and len(attributes.assetp)>#attributes.assetp_id#<CFELSE>NULL</cfif>,
		<cfif attributes.type eq 1>
		USE_FOREIGN_CURRENCY = <cfif isDefined("attributes.USE_FOREIGN_CURRENCY") and attributes.USE_FOREIGN_CURRENCY eq 1 ><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		USE_CATEGORY_ICON = <cfif isDefined("attributes.USE_CATEGORY_ICON") and attributes.USE_CATEGORY_ICON eq 1 ><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		USE_PRODUCT_IMAGE = <cfif isDefined("attributes.USE_PRODUCT_IMAGE") and attributes.USE_PRODUCT_IMAGE eq 1 ><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		USE_CUSTOMER_RECORD = <cfif isDefined("attributes.USE_CUSTOMER_RECORD") and attributes.USE_CUSTOMER_RECORD eq 1 ><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		USE_LOYALTY_CARD = <cfif isDefined("attributes.USE_LOYALTY_CARD") and attributes.USE_LOYALTY_CARD eq 1 ><cfqueryparam cfsqltype="cf_sql_smallint" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_smallint" value="0"></cfif>,
		</cfif>
		CUSTOMER_ID = <cfif isDefined("attributes.customer_id") and len(attributes.customer_id)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.customer_id#"><cfelse>NULL</cfif>,
		AMOUNT_ROUND = <cfif isDefined("attributes.amount_round") and len(attributes.amount_round)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.amount_round#"><cfelse>NULL</cfif>,
		PRICE_ROUND = <cfif isDefined("attributes.price_round") and len(attributes.price_round)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_round#"><cfelse>NULL</cfif>,
		USE_SERIAL_NO = <cfif isDefined("attributes.USE_SERIAL_NO") and len(attributes.USE_SERIAL_NO)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.USE_SERIAL_NO#"><cfelse>NULL</cfif>,
		USE_LOT_NO = <cfif isDefined("attributes.USE_LOT_NO") and len(attributes.USE_LOT_NO)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.USE_LOT_NO#"><cfelse>NULL</cfif>,
		POS_PROCESS_CAT = <cfif isDefined("attributes.pos_process_cat") and len(attributes.pos_process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_process_cat#"><cfelse>NULL</cfif>,
		PRICE_CAT_ID = <cfif isDefined("attributes.price_cat_id") and len(attributes.price_cat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_cat_id#"><cfelse>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		POS_ID = #attributes.pos_id#
</cfquery>

<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		self.close();
	<cfelseif isdefined("attributes.draggable")>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
	</cfif>
	window.location.href = '<cfoutput>#request.self#?fuseaction=finance.list_pos_equipment</cfoutput>';
</script>
