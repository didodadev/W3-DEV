<cfif isdefined("attributes.record_date_start") and isdate(attributes.record_date_start)>
	<cf_date tarih = "attributes.record_date_start">
<cfelseif not isdefined("attributes.record_date_start") and not isdefined("attributes.form_submitted")>
	<cfset attributes.record_date_start = date_add('d',-7,now())>
<cfelse>
	<cfparam name="attributes.record_date_start" default="">
</cfif>
<cfif isdefined("attributes.record_date_finish") and isdate(attributes.record_date_finish)>
	<cf_date tarih = "attributes.record_date_finish">
<cfelseif not isdefined("attributes.record_date_finish") and not isdefined("attributes.form_submitted")>
	<cfset attributes.record_date_finish = now()>
<cfelse>
	<cfparam name="attributes.record_date_finish" default="">
</cfif>
<cfif isdefined("attributes.process_date_start") and isdate(attributes.process_date_start)>
	<cf_date tarih = "attributes.process_date_start">
<cfelse>
	<cfparam name="attributes.process_date_start" default="">
</cfif>
<cfif isdefined("attributes.process_date_finish") and isdate(attributes.process_date_finish)>
	<cf_date tarih = "attributes.process_date_finish">
<cfelse>
	<cfparam name="attributes.process_date_finish" default="">
</cfif>

<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfparam name="attributes.start_date" default="">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfparam name="attributes.finish_date" default="">
</cfif>
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.invoice_status" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_process" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.profile" default="">
<cfparam name="attributes.order_type" default="1">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfquery name="get_process_type" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID,
		PT.PROCESS_NAME,
		PT.PROCESS_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects.popup_dsp_efatura_detail%">
	ORDER BY
		PT.PROCESS_NAME,
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_efatura_det" datasource="#dsn2#">
		WITH CTE1 AS (
			SELECT 
            	ERD.RECEIVING_DETAIL_ID,
				ERD.EINVOICE_ID, 
				ERD.INVOICE_TYPE_CODE, 
				ERD.SENDER_TAX_ID, 
				ERD.PROFILE_ID, 
				ERD.PAYABLE_AMOUNT, 
				ERD.PAYABLE_AMOUNT_CURRENCY, 
				ERD.ISSUE_DATE, 
				ERD.PARTY_NAME, 
				ERD.RECORD_DATE,
				ERD.UPDATE_DATE,
				ERD.STATUS,
                ERD.ORDER_NUMBER, 
                ERD.PRINT_COUNT,                
				ISNULL(ERD.IS_MANUEL,0) IS_MANUEL,                
				ISNULL(ERD.IS_PROCESS,0) IS_PROCESS,
				'' COMPANY_ID,
				I.INVOICE_ID,
				I.INVOICE_NUMBER,
				I.INVOICE_CAT,
				EIP.EXPENSE_ID,
				EIP.PAPER_NO,
                PTR.STAGE,
                O.ORDER_ID
			FROM 
				EINVOICE_RECEIVING_DETAIL ERD
				LEFT JOIN INVOICE I ON ERD.INVOICE_ID = I.INVOICE_ID
				LEFT JOIN EXPENSE_ITEM_PLANS EIP ON ERD.EXPENSE_ID = EIP.EXPENSE_ID
				LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = ERD.PROCESS_STAGE
				LEFT JOIN #dsn3_alias#.ORDERS O ON O.ORDER_NUMBER = ERD.ORDER_NUMBER AND O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 0
			WHERE
				1=1
				<cfif len(attributes.start_date)>
					AND	ERD.ISSUE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> 
				</cfif>
				<cfif len(attributes.finish_date)>
					AND	ERD.ISSUE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.finish_date)#"> 
				</cfif>
				<cfif len(attributes.process_date_start)>
					AND	ERD.UPDATE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date_start#"> 
				</cfif>
				<cfif len(attributes.process_date_finish)>
					AND	ERD.UPDATE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.process_date_finish#"> 
				</cfif>
				<cfif len(attributes.record_date_start)>
					AND	ERD.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date_start#"> 
				</cfif>
				<cfif len(attributes.record_date_finish)>
					AND	ERD.RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd('d',1,attributes.record_date_finish)#"> 
				</cfif>
				<cfif len(attributes.is_process)>
					AND ISNULL(ERD.IS_PROCESS,0) = #attributes.is_process#
				</cfif>
				<cfif len(attributes.profile)>
					AND ERD.PROFILE_ID = '#attributes.profile#'
				</cfif>
				<cfif len(attributes.invoice_status)>
					AND STATUS = #attributes.invoice_status#
				</cfif>
				<cfif Len(attributes.process_stage)>
					AND ERD.PROCESS_STAGE = #attributes.process_stage#
				</cfif>
				<cfif isDefined('attributes.process_type') and len(attributes.process_type)>
					AND ERD.INVOICE_TYPE_CODE = '#attributes.process_type#'
				</cfif>
				<cfif len(attributes.keyword)>
					<cfif len(trim(attributes.keyword)) lte 3>
					AND (
							ERD.SENDER_TAX_ID = '#trim(attributes.keyword)#' OR 
							ERD.EINVOICE_ID LIKE '#trim(attributes.keyword)#%' OR 
							ERD.PARTY_NAME LIKE '#trim(attributes.keyword)#%' OR
                            (I.INVOICE_NUMBER = '#trim(attributes.keyword)#' AND ERD.INVOICE_ID IS NOT NULL) OR
							ERD.ORDER_NUMBER = '#trim(attributes.keyword)#%'
							                           
						)
					<cfelseif len(trim(attributes.keyword)) gt 3>
					AND (
							ERD.PARTY_NAME LIKE '%#trim(attributes.keyword)#%' OR
							ERD.SENDER_TAX_ID = '#trim(attributes.keyword)#'  OR 
							ERD.EINVOICE_ID LIKE '%#trim(attributes.keyword)#%' OR
                            (I.INVOICE_NUMBER = '#trim(attributes.keyword)#' AND ERD.INVOICE_ID IS NOT NULL) OR 
							ERD.ORDER_NUMBER = '%#trim(attributes.keyword)#%'  
							                       
						)
					</cfif>
				</cfif>
			),
			CTE2 AS (
			SELECT
				CTE1.*,
				ROW_NUMBER() OVER ( ORDER BY <cfif attributes.order_type eq 1>ISSUE_DATE DESC<cfelseif attributes.order_type eq 2>RECORD_DATE DESC<cfelseif attributes.order_type eq 3>UPDATE_DATE DESC<cfelseif attributes.order_type eq 4>EINVOICE_ID<cfelseif attributes.order_type eq 5>PARTY_NAME</cfif>) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
			FROM
				CTE1
		)
		SELECT
			CTE2.*
		FROM
			CTE2
		WHERE
			RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)                        
	</cfquery>
	<cfif get_efatura_det.recordcount>
		<cfparam name="attributes.totalrecords" default="#get_efatura_det.query_count#">
	<cfelse>
		<cfparam name="attributes.totalrecords" default="0">
	</cfif>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">	
	<cfset get_efatura_det.recordcount = 0>
</cfif>

<cfif isDefined("attributes.event") and attributes.event is 'add'>
	<cfscript>
        get_efatura_control_tmp= createObject("component","objects.cfc.einvoice");
        get_efatura_control_tmp.dsn = dsn;
        get_efatura_control = get_efatura_control_tmp.get_efatura_control_fnc(company_id:session.ep.company_id);
    </cfscript>
</cfif>

<script type="text/javascript">	
	<cfif isDefined("attributes.event") and attributes.event is 'add'>
		function ekle_form_action()
		{
			if(document.getElementById('uploaded_file').value == "")
			{
				alert("Belge Seçmelisiniz !");
				return false;
			}
			return process_cat_control();
		}
	<cfelseif not isDefined("attributes.event") or attributes.event is 'list'>
		function kontrol_et(yol)
		{
			document.getElementById('keyword').value = yol;
			document.execCommand('SaveAs','false',yol);
		}
		
	</cfif>	
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'invoice.received_einvoices';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'invoice/display/received_einvoices.cfm';
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'invoice.received_einvoices&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'invoice/form/add_efatura_xml.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'objects/query/add_efatura_xml.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'invoice.received_einvoices&event=list';
	
</cfscript>
