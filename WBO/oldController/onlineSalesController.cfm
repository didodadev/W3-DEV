<cf_get_lang_set module_name="sales"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.startdate" default="#now()#">
<cfparam name="attributes.finishdate" default="#dateadd('d',1,now())#">
<cfif isdefined("attributes.is_submitted")>
	<cfif len(attributes.startdate)><cf_date tarih="attributes.startdate"></cfif>
	<cfif len(attributes.finishdate)><cf_date tarih="attributes.finishdate"></cfif>
	<cfquery name="GET_ONLINE_SALES_ALL" datasource="#DSN3#">
		SELECT
			*
		FROM
		(
		SELECT 
			OPR.ORDER_ROW_ID,
			OPR.PRODUCT_ID,
			OPR.STOCK_ID,
			OPR.TAX,
			CP.COMPANY_PARTNER_NAME AS UYE_ADI,
			CP.COMPANY_PARTNER_SURNAME AS UYE_SOYADI,
			C.NICKNAME AS SIRKET,
			'P' + CAST(CP.PARTNER_ID AS CHAR(6)) AS TYPE,
			0 AS TIP,
			C.COMPANY_ID AS MEMBER_COMPANY_ID,
			CP.PARTNER_ID AS MEMBER_ID, 
			OPR.RECORD_DATE,
			OPR.PRODUCT_NAME,
			OPR.QUANTITY,
			OPR.PRICE,
			OPR.PRICE_KDV,
			OPR.PRICE_MONEY,
			OPR.PROM_STOCK_AMOUNT
		FROM
			ORDER_PRE_ROWS OPR,
			#dsn_alias#.COMPANY C,
			#dsn_alias#.COMPANY_PARTNER CP
		WHERE
			C.COMPANY_ID = CP.COMPANY_ID AND
			CP.PARTNER_ID = OPR.RECORD_PAR AND
			<cfif len(attributes.keyword)>OPR.PRODUCT_NAME LIKE '%#attributes.keyword#%' AND</cfif>
			OPR.RECORD_DATE >= #attributes.startdate# AND
			OPR.RECORD_DATE <= #attributes.finishdate# 
			<cfif isdefined("attributes.member_name") and len(attributes.member_name) and attributes.member_type is 'partner' and len(attributes.company_id)>
				AND C.COMPANY_ID = #attributes.company_id#
			<cfelseif isdefined("attributes.member_name") and len(attributes.member_name) and attributes.member_type is 'consumer' and len(attributes.consumer_id)>
				AND C.COMPANY_ID < 0
			</cfif> 
		UNION ALL
		<!--- ( --->
		<!--- secilen temsilcinin kaydettigi siparisler --->
		SELECT 
			OPR.ORDER_ROW_ID,
			OPR.PRODUCT_ID,
			OPR.STOCK_ID,
			OPR.TAX,
			C.CONSUMER_NAME AS UYE_ADI,
			C.CONSUMER_SURNAME AS UYE_SOYADI,
			C.COMPANY AS SIRKET,
			'C' + CAST(C.CONSUMER_ID AS CHAR(6)) AS TYPE,
			1 AS TIP,
			0 AS MEMBER_COMPANY_ID,
			C.CONSUMER_ID AS MEMBER_ID,
			OPR.RECORD_DATE,
			OPR.PRODUCT_NAME,
			OPR.QUANTITY,
			OPR.PRICE,
			OPR.PRICE_KDV,
			OPR.PRICE_MONEY,
			OPR.PROM_STOCK_AMOUNT
		FROM
			ORDER_PRE_ROWS OPR,
			#dsn_alias#.CONSUMER C
		WHERE
			C.CONSUMER_ID = OPR.RECORD_CONS	AND
			<cfif len(attributes.keyword)>OPR.PRODUCT_NAME LIKE '%#attributes.keyword#%' AND</cfif>
			OPR.RECORD_DATE >= #attributes.startdate# AND
			OPR.RECORD_DATE <= #attributes.finishdate#
			<cfif isdefined("attributes.member_name") and len(attributes.member_name) and attributes.member_type is 'partner' and len(attributes.company_id)>
				AND C.CONSUMER_ID < 0
			<cfelseif isdefined("attributes.member_name") and len(attributes.member_name) and attributes.member_type is 'consumer' and len(attributes.consumer_id)>
				AND C.CONSUMER_ID = #attributes.consumer_id#
			</cfif>
		<!--- UNION
		<!--- <!--- secilen temsilcinin siparisleri --->
		SELECT 
			C.CONSUMER_NAME AS UYE_ADI,
			C.CONSUMER_SURNAME AS UYE_SOYADI,
			C.COMPANY AS SIRKET,
			'C' + CAST(C.CONSUMER_ID AS CHAR(6)) AS TYPE,
			1 AS TIP,
			0 AS MEMBER_COMPANY_ID,
			C.CONSUMER_ID AS MEMBER_ID,
			OPR.RECORD_DATE,
			OPR.PRODUCT_NAME,
			OPR.QUANTITY,
			OPR.PRICE,
			OPR.PRICE_KDV,
			OPR.PRICE_MONEY,
			OPR.PROM_STOCK_AMOUNT
		FROM
			ORDER_PRE_ROWS OPR,
			#dsn_alias#.CONSUMER C
		WHERE
			C.CONSUMER_ID = OPR.TO_CONS	AND
			<cfif len(attributes.keyword)>OPR.PRODUCT_NAME LIKE '%#attributes.keyword#%' AND</cfif>
			OPR.RECORD_DATE >= #attributes.startdate# AND
			OPR.RECORD_DATE <= #attributes.finishdate#
			<cfif isdefined("attributes.member_name") and len(attributes.member_name) and attributes.member_type is 'partner' and len(attributes.company_id)>
				AND C.CONSUMER_ID < 0
			<cfelseif isdefined("attributes.member_name") and len(attributes.member_name) and attributes.member_type is 'consumer' and len(attributes.consumer_id)>
				AND C.CONSUMER_ID = #attributes.consumer_id#
			</cfif>	 --->
		)	 --->
		UNION ALL

		SELECT 
			OPR.ORDER_ROW_ID,
			OPR.PRODUCT_ID,
			OPR.STOCK_ID,
			OPR.TAX,
			'Ziyaretçi' UYE_ADI,
			'' AS UYE_SOYADI,
			OPR.RECORD_IP AS SIRKET,
			'Z' + OPR.RECORD_IP AS TYPE,
			2 AS TIP,
			0 AS MEMBER_COMPANY_ID,
			0 AS MEMBER_ID,
			OPR.RECORD_DATE,
			OPR.PRODUCT_NAME,
			OPR.QUANTITY,
			OPR.PRICE,
			OPR.PRICE_KDV,
			OPR.PRICE_MONEY,
			OPR.PROM_STOCK_AMOUNT
		FROM
			ORDER_PRE_ROWS OPR
		WHERE
			OPR.RECORD_GUEST = 1 AND
			<cfif len(attributes.keyword)>OPR.PRODUCT_NAME LIKE '%#attributes.keyword#%' AND</cfif>
			OPR.RECORD_DATE >= #attributes.startdate# AND
			OPR.RECORD_DATE <= #attributes.finishdate# 
			<cfif isdefined("attributes.member_name") and len(attributes.member_name) and attributes.member_type is 'partner' and len(attributes.company_id)>
				AND OPR.RECORD_PAR IS NULL
			<cfelseif isdefined("attributes.member_name") and len(attributes.member_name) and attributes.member_type is 'consumer' and len(attributes.consumer_id)>
				AND OPR.RECORD_CONS IS NULL
			</cfif>
		)T1
		ORDER BY
			RECORD_DATE DESC 
	</cfquery>
	<cfquery name="GET_ONLINE_SALES_TYPES" dbtype="query">
		SELECT DISTINCT
			TYPE,
			UYE_ADI,
			UYE_SOYADI,
			SIRKET,
			TIP,
			MEMBER_COMPANY_ID,
			MEMBER_ID
		FROM 
			GET_ONLINE_SALES_ALL
		ORDER BY
			TIP
	</cfquery>
<cfelse>
	<cfset get_online_sales_types.recordcount = 0>
</cfif>
<cfscript>
	url_str = "keyword=#attributes.keyword#";
</cfscript>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
<cfparam name="attributes.totalrecords" default="#get_online_sales_types.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT 
		COMPANY_ID,
		PERIOD_ID,
		MONEY,
		RATE1,
		RATE2,
		RATEPP2,
		RATEWW2
	FROM 
		SETUP_MONEY
	WHERE 
		PERIOD_ID = #session.ep.period_id#
</cfquery>
<script type="text/javascript">
	$(function (){		
		$('#keyword').focus();
		})
	function hesapla(orrid)
	{  
		st = filterNum(eval('document.getElementById("price'+orrid+'")').value); /* eval('document.getElementById("quantity'+orrid+'")').value;*/
		eval('document.getElementById("price_kdv'+orrid+'")').value = commaSplit(st + (st * (eval('document.getElementById("tax'+orrid+'")').value/100)));
	}
	
	function update_row(crntrow)
	{   
	
		/*AjaxPageLoad('#request.self#?fuseaction=sales.emptypopup_upd_online_sales','upd_row'+crntrow,1);*/
		
		var _r = 'order_form'+crntrow;
		var _t ='SHOW_MESSAGE_'+crntrow;
		var _y ='<cfoutput>#request.self#?fuseaction=sales.emptypopup_upd_online_sales&crrntrow=</cfoutput>' + crntrow;
		
		 AjaxFormSubmit(_r,_t,'1','','',_y );
	}
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
			
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'sales.list_online_sales';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'sales/display/list_online_sales.cfm';
		
</cfscript>
