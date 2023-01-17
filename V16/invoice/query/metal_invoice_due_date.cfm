<cfinclude template = "../../objects/query/session_base.cfm">
<!--- database tanimlari --->
<cfscript>
	// BK kontrol edelim sonra 6 aya kaldir 
	new_irsaliye_id_listesi ='';
	min_period = '';
	DSN_METAL='#dsn#'; //workcube_xxxmetal
	DSN5_METAL='#dsn5#'; //workcube_metal
	DSN4_METAL='#dsn4#'; //workcube_metal
	DSN2_METAL='#dsn#_#session_base.period_year#_#session_base.company_id#';//workcube_xxxmetal_2008_1
</cfscript>

<cfif (included_irs eq 1) and len(attributes.ship_ids)><!--- aktif donemdeki irsaliyeler --->
	<cfset min_period = session_base.period_id>
	<cfset new_irsaliye_id_listesi = attributes.ship_ids>
</cfif>
<cfif (included_irs eq 1) and isdefined("pre_period_ships") and len(pre_period_ships)><!--- onceki donemdeki irsaliyeler --->
	<cfset min_period = pre_period_id>
	<cfset new_irsaliye_id_listesi = pre_period_ships>
</cfif>
<cfif len(new_irsaliye_id_listesi) and len(min_period)>
	<cfif min_period neq session_base.period_id>
		<cfquery name="GET_PERIOD" datasource="#DSN_METAL#">
			SELECT  
				PERIOD_ID,
				PERIOD_YEAR
			FROM
				SETUP_PERIOD
			WHERE 
				PERIOD_ID = #min_period# AND
				OUR_COMPANY_ID = #session_base.company_id#
			ORDER BY
				PERIOD_YEAR
		</cfquery>
		<cfset DSN2_METAL = '#dsn#_#get_period.period_year#_#session_base.company_id#'>
	<cfelse>
		<cfset DSN2_METAL = '#dsn#_#session_base.period_year#_#session_base.company_id#'>
	</cfif>

	<cfquery name="GET_DUE_DATE_START" datasource="#DSN2_METAL#" maxrows="1">	
		SELECT
			S.SHIP_ID,
			TSFM.METAL_SHIP_ID,
			TM.SHIP_ID T_SHIP_ID,
			TSR.SHIP_ROW_ID,
			TSR.ORDER_ROW_ID,
			TORD.ORDER_ID,
			TORD.ORDER_NUMBER,
			TORD.ORDER_DATE,
			TORD.DUE_DATE_START
		FROM
			SHIP S,
			#DSN4_METAL#.SHIP_FOR_METAL TSFM,
			#DSN5_METAL#.SHIP TM,
			#DSN5_METAL#.SHIP_ROW TSR,
			#DSN5_METAL#.ORDER_ROW TOR,
			#DSN5_METAL#.ORDERS TORD
		WHERE
			S.SHIP_ID IN (#new_irsaliye_id_listesi#) AND
			S.SHIP_ID = TSFM.WORKCUBE_SHIP_ID AND
			TSFM.PERIOD_ID = #min_period# AND
			TSFM.METAL_SHIP_ID = TM.SHIP_ID AND
			TM.SHIP_ID = TSR.SHIP_ID AND
			TSR.ORDER_ROW_ID = TOR.ORDER_ROW_ID AND
			TOR.ORDER_ID = TORD.ORDER_ID
		ORDER BY
			TORD.ORDER_DATE
	</cfquery>
<cfelse>
	<cfset get_due_date_start.recordcount=0>
</cfif>
<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>
	<cfquery name="PAYMETHOD" datasource="#DSN#">
		SELECT DUE_DAY FROM SETUP_PAYMETHOD WHERE PAYMETHOD_STATUS = 1 AND PAYMETHOD_ID = #attributes.paymethod_id#
	</cfquery>
	<cfset attributes.basket_due_value = paymethod.due_day>
</cfif>

<!--- Recep Aycicek 02.03.2010 --->
<cfif get_due_date_start.recordcount>
	<cfif isDefined("note") and len(note) and not note contains "#GET_DUE_DATE_START.ORDER_NUMBER#">
		<cfset note = "#GET_DUE_DATE_START.ORDER_NUMBER# #note#">
	<cfelseif isDefined("note") and len(note) and note contains "#GET_DUE_DATE_START.ORDER_NUMBER#">
		<cfset note = "#note#">
	<cfelse>
		<cfset note = GET_DUE_DATE_START.ORDER_NUMBER>
	</cfif>
</cfif>
<!--- //Recep Aycicek 02.03.2010 --->

<!--- siparis irsaliye iliskisinde kayit varsa, siparis detayinda ilgili alan checkboxda isaretlenmisse  --->
<cfif get_due_date_start.recordcount and len(get_due_date_start.due_date_start) and get_due_date_start.due_date_start eq 1>
	<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>
		<cfset invoice_due_date = date_add("d",attributes.basket_due_value,get_due_date_start.order_date)>
	</cfif>
	<!--- xml e bağlı olarak hesaplanan vade tarihi fatura tarihinden kucukse fatura tarihi vade tarihi olarak kabul edilir SM --->
	<cfif isdefined("attributes.xml_kontrol_due_date") and attributes.xml_kontrol_due_date eq 1 and datediff('d',attributes.invoice_date,invoice_due_date) lt 0>
		<cfset invoice_due_date = attributes.invoice_date>
	</cfif>
<cfelse>
	<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>
		<cfset invoice_due_date = date_add("d",attributes.basket_due_value,attributes.invoice_date)>
	</cfif>
</cfif>
