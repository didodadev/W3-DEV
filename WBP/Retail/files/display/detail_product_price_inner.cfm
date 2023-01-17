<br />
<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
<cfquery name="get_stocks" datasource="#dsn3#" result="a1">
    SELECT STOCK_ID,PROPERTY FROM STOCKS WHERE PRODUCT_ID = #attributes.pid#
</cfquery>
<cfset attributes.stock_id = valuelist(get_stocks.stock_id)>
<cfset attributes.stock_name_list = valuelist(get_stocks.property)>

<cfquery name="get_periods" datasource="#dsn#">
	SELECT * FROM SETUP_PERIOD
</cfquery>
<cfquery name="get_bu_yil_period" dbtype="query">
	SELECT PERIOD_ID FROM get_periods WHERE OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR = #session.ep.period_year#
</cfquery>
<cfset bu_yil_period = get_bu_yil_period.PERIOD_ID>

<cfquery name="get_gecen_yil_period" dbtype="query">
	SELECT PERIOD_ID FROM get_periods WHERE OUR_COMPANY_ID = #session.ep.company_id# AND PERIOD_YEAR = #session.ep.period_year-1#
</cfquery>
<cfif get_gecen_yil_period.recordcount>
	<cfset gecen_yil_period = get_gecen_yil_period.PERIOD_ID>
<cfelse>
	<cfset gecen_yil_period = 0>
</cfif>

<cfquery name="get_ships_all" datasource="#dsn2#">
SELECT
    *
FROM
    (
    <cfoutput query="get_periods">
    <cfif currentrow neq 1>
        UNION ALL
    </cfif>
    <cfset dsn_ozel_ = "#dsn#_#get_periods.period_year#_#session.ep.company_id#">
    SELECT
        OSS.ORDER_ID,
        S.SHIP_ID,
        (SELECT PROPERTY FROM #dsn3_alias#.STOCKS WHERE STOCK_ID = SR.STOCK_ID ) AS NAME_PRODUCT,
        S.SHIP_TYPE,
        S.SHIP_NUMBER,
        S.DEPARTMENT_IN,
        S.SHIP_DATE,
        SR.AMOUNT,
        SR.PRICE,
        SR.PRODUCT_ID,
        D.DEPARTMENT_HEAD,
        C.FULLNAME,
        SR.STOCK_ID,
        S.COMPANY_ID,
        ISNULL(S.PROJECT_ID,0) AS PROJECT_ID,
        (SELECT INVOICE_ID FROM #dsn_ozel_#.INVOICE_SHIPS WHERE SHIP_ID = SR.SHIP_ID) AS INVOICE_ID,
        (SELECT INVOICE_NUMBER FROM #dsn_ozel_#.INVOICE WHERE INVOICE_ID = (SELECT INVOICE_ID FROM #dsn_ozel_#.INVOICE_SHIPS WHERE SHIP_ID = SR.SHIP_ID)) AS INVOICE_NUMBER,
        (SELECT TOP 1 (NETTOTAL / AMOUNT) FROM #dsn_ozel_#.INVOICE_ROW WHERE SHIP_ID = SR.SHIP_ID AND INVOICE_ID = (SELECT INVOICE_ID FROM #dsn_ozel_#.INVOICE_SHIPS WHERE SHIP_ID = SR.SHIP_ID) AND STOCK_ID = SR.STOCK_ID) AS INVOICE_PRICE,
        (SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = S.PROJECT_ID) AS PROJECT_HEAD
    FROM
        #dsn_ozel_#.SHIP_ROW AS SR,
        #dsn_ozel_#.SHIP AS S,
        #dsn_alias#.DEPARTMENT D,
        #dsn_alias#.COMPANY C,
        #dsn3_alias#.ORDERS_SHIP OSS
    WHERE
        S.SHIP_TYPE <> 74 AND
        S.COMPANY_ID = C.COMPANY_ID AND
        S.DEPARTMENT_IN = D.DEPARTMENT_ID AND
        SR.SHIP_ID = S.SHIP_ID AND
        SR.PRODUCT_ID = #attributes.pid# AND                    
        S.SHIP_DATE >= #dateadd('yyyy',-1,now())# AND
        S.SHIP_DATE < #dateadd('d',1,now())# AND
        S.SHIP_ID = OSS.SHIP_ID AND
        OSS.PERIOD_ID = #period_id#
   </cfoutput>
    ) AS T1
ORDER BY
        SHIP_DATE DESC            
</cfquery>


<cfquery name="get_orders" datasource="#dsn3#" result="o1">
	SELECT
    	O.ORDER_NUMBER,
        O.ORDER_DATE,
        DATEDIFF("d",ORDER_DATE,#now()#) AS IS_CLOSED,
        O.ORDER_ID,
        ORR.NETTOTAL,
        ORR.QUANTITY,
        ORR.STOCK_ID,
        ORR.PRODUCT_ID,
        ORR.ORDER_ROW_CURRENCY,
        D.DEPARTMENT_HEAD,
        C.FULLNAME,
        PP.PROJECT_HEAD,
        O.COMPANY_ID,
        ISNULL(O.PROJECT_ID,0) AS PROJECT_ID
    FROM
        #dsn_alias#.DEPARTMENT D,
        #dsn_alias#.COMPANY C,
        ORDER_ROW ORR,
    	ORDERS O
        	LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON (PP.PROJECT_ID = O.PROJECT_ID)
    WHERE
        O.ORDER_ID = ORR.ORDER_ID AND
        ORR.PRODUCT_ID = #attributes.pid# AND
        O.COMPANY_ID = C.COMPANY_ID AND
        O.DELIVER_DEPT_ID = D.DEPARTMENT_ID AND
        O.ORDER_DATE >= #dateadd('yyyy',-1,now())#
    ORDER BY
    	O.ORDER_DATE DESC
</cfquery>

<cfsavecontent variable="header_">Alım Hareketleri</cfsavecontent>
<cf_medium_list_search title="#header_#"></cf_medium_list_search>
<div id='jqxWidget'>
<style>
	.propertycss{background-color:#E0FFFF; color:#000000 !important;}
	.durumcss{background-color:#FC6; color:#000000 !important;}
	.faturacss{background-color:#CF3; color:#000000 !important;}
	.irsaliyecss{background-color:#FAEBD7; color:#000000 !important;}
</style>
    <div id="jqxgrid_ic">
    </div>
</div>
<cfquery name="get_ship" datasource="#dsn2#">
SELECT
    *
FROM
    (
    <cfoutput query="get_periods">
    <cfif currentrow neq 1>
        UNION ALL
    </cfif>
    <cfset dsn_ozel_ = "#dsn#_#get_periods.period_year#_#session.ep.company_id#">
    SELECT
        S.SHIP_ID,
        (SELECT PROPERTY FROM #dsn3_alias#.STOCKS WHERE STOCK_ID = SR.STOCK_ID ) AS NAME_PRODUCT,
        S.SHIP_TYPE,
        S.SHIP_NUMBER,
        S.DEPARTMENT_IN,
        S.SHIP_DATE,
        SR.AMOUNT,
        SR.PRICE,
        SR.PRODUCT_ID,
        D.DEPARTMENT_HEAD,
        C.FULLNAME,
        SR.STOCK_ID,
        S.COMPANY_ID,
        ISNULL(S.PROJECT_ID,0) AS PROJECT_ID,
        (SELECT INVOICE_ID FROM #dsn_ozel_#.INVOICE_SHIPS WHERE SHIP_ID = SR.SHIP_ID) AS INVOICE_ID,
        (SELECT INVOICE_NUMBER FROM #dsn_ozel_#.INVOICE WHERE INVOICE_ID = (SELECT INVOICE_ID FROM #dsn_ozel_#.INVOICE_SHIPS WHERE SHIP_ID = SR.SHIP_ID)) AS INVOICE_NUMBER,
        (SELECT TOP 1 (NETTOTAL / AMOUNT) FROM #dsn_ozel_#.INVOICE_ROW IR_IC WHERE IR_IC.INVOICE_ID = (SELECT IS_IC.INVOICE_ID FROM #dsn_ozel_#.INVOICE_SHIPS IS_IC WHERE IS_IC.SHIP_ID = SR.SHIP_ID) AND IR_IC.STOCK_ID = SR.STOCK_ID) AS INVOICE_PRICE,
        (SELECT PROJECT_HEAD FROM #dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = S.PROJECT_ID) AS PROJECT_HEAD
    FROM
        #dsn_ozel_#.SHIP_ROW AS SR,
        #dsn_ozel_#.SHIP AS S,
        #dsn_alias#.DEPARTMENT D,
        #dsn_alias#.COMPANY C
    WHERE
        S.SHIP_TYPE <> 74 AND
        S.COMPANY_ID = C.COMPANY_ID AND
        S.DEPARTMENT_IN = D.DEPARTMENT_ID AND
        SR.SHIP_ID = S.SHIP_ID AND
        SR.PRODUCT_ID = #attributes.pid# AND                    
        S.SHIP_DATE >= #dateadd('yyyy',-1,now())# AND
        S.SHIP_DATE < #dateadd('d',1,now())# AND
        ISNULL(SR.ROW_ORDER_ID,0) = 0
   </cfoutput>
    ) AS T1
ORDER BY
        SHIP_DATE DESC            
</cfquery> 

<script type="text/javascript">
$(document).ready(function () {
	var source1 =
	{
		localdata: [
		<cfoutput query="get_orders">   
			<cfset irsaliye_toplam = 0> 
			<cfquery name="ships" dbtype="query">
				SELECT 
					*
				FROM 
					get_ships_all
				WHERE 
					STOCK_ID = #GET_ORDERS.STOCK_ID# AND
					ORDER_ID = #GET_ORDERS.ORDER_ID#
			</cfquery> 
			<cfset baz_maliyet = wrk_round(NETTOTAL / QUANTITY)>
			<cfset baz_maliyet_new = get_daily_cost_price(product_id,year(order_date),month(order_date),day(order_date),COMPANY_ID,PROJECT_ID)>
			
			<cfif baz_maliyet_new lt baz_maliyet>
				<cfset baz_maliyet = baz_maliyet_new>
			</cfif>
			<cfif ships.recordcount>
				<cfloop query="ships">
					<cfset new_baz_maliyet = get_daily_cost_price(get_orders.product_id,year(ships.SHIP_DATE),month(ships.SHIP_DATE),day(ships.SHIP_DATE),get_orders.COMPANY_ID,0)>
					<cfif new_baz_maliyet lt baz_maliyet>
						<cfset baz_maliyet = new_baz_maliyet>
					</cfif>
				</cfloop>
			</cfif> 
			["<cfset sira_ = listfind(attributes.stock_id,GET_ORDERS.STOCK_ID)>#listgetat(attributes.stock_name_list,sira_)#",
			"#department_head#",
			"#dateformat(order_date,'dd/mm/yyyy')#",
			"<cfif ships.recordcount gt 0><cfloop query='ships'>#dateformat(ships.SHIP_DATE,'dd/mm/yyyy')#<BR /></cfloop><cfelse><cfif IS_CLOSED GTE 15>KPL #IS_CLOSED#</cfif></cfif>",
			"<cfif len(order_row_currency)>#listgetat(order_row_currency_name_list,listfind(order_row_currency_id_list,order_row_currency))#</cfif>",
			"#quantity#",      
			"<cfloop query='ships'><cfset irsaliye_toplam = irsaliye_toplam+ships.AMOUNT>#ships.AMOUNT#<BR /></cfloop>",
			"#quantity-irsaliye_toplam#",
			"<cfloop query='ships'>#wrk_round(ships.INVOICE_PRICE)#<BR /></cfloop>",
			"#wrk_round(baz_maliyet)#",
			"#wrk_round(NETTOTAL / QUANTITY)#",
			"<cfif ships.INVOICE_PRICE gt 0>#wrk_round(ships.INVOICE_PRICE - baz_maliyet)#</cfif>",
			"<cfif ships.INVOICE_PRICE gt 0>#wrk_round((ships.INVOICE_PRICE - baz_maliyet) * quantity)#</cfif>",
			"<a href='index.cfm?fuseaction=retail.speed_manage_product_new&order_id=#order_id#' target='blank'>#order_number#</a>",
			"<cfloop query='ships'>#ships.SHIP_NUMBER#<BR /></cfloop>",
			"<cfloop query='ships'>#ships.INVOICE_NUMBER#<BR /></cfloop>",
			"#FULLNAME# #PROJECT_HEAD#"
			]<cfif currentrow neq get_orders.recordcount or (currentrow eq get_orders.recordcount and get_ship.recordcount)>,</cfif>
		</cfoutput>
		<cfoutput query="get_ship">
		<cfset anlasilan_f = get_daily_cost_price(product_id,year(SHIP_DATE),month(SHIP_DATE),day(SHIP_DATE),COMPANY_ID,PROJECT_ID)>
			["#name_product#","#department_head#","","#dateformat(SHIP_DATE,'dd/mm/yyyy')#","","",
			"#AMOUNT#","",
			"#wrk_round(INVOICE_PRICE)#",
			"#wrk_round(get_daily_cost_price(product_id,year(SHIP_DATE),month(SHIP_DATE),day(SHIP_DATE),COMPANY_ID,PROJECT_ID))#","",
			"<cfif INVOICE_PRICE gt 0><cfset invoice_f = INVOICE_PRICE>#wrk_round(invoice_f-anlasilan_f)#</cfif>",
			"<cfif INVOICE_PRICE gt 0><cfif invoice_f gt anlasilan_f>#wrk_round((invoice_f-anlasilan_f) * AMOUNT)#</cfif></cfif>","",
			"#SHIP_NUMBER#",
			"#INVOICE_NUMBER#",
			"#FULLNAME# #PROJECT_HEAD#"]<cfif currentrow neq get_ship.recordcount>,</cfif>
		</cfoutput>
		],
		datafields: [
			{ name: 'property1', type: 'string', map: '0'},
			{ name: 'department_head1', type: 'string', map: '1'},
			{ name: 'siparis_tarih1', type: 'string', map: '2'},
			{ name: 'teslim_tarih1', type: 'string', map: '3'},
			{ name: 'durum1', type: 'string', map: '4'},
			{ name: 'siparis_miktar1', type: 'number', map: '5'},
			{ name: 'teslim_miktar1', type: 'number', map: '6'},
			{ name: 'kalan_siparis1', type: 'number', map: '7'},
			{ name: 'fatura_fiyat1', type: 'number', map: '8'},
			{ name: 'anlasilan_fiyat1', type: 'number', map: '9'},
			{ name: 'siparis_fiyat1', type: 'number', map: '10'},
			{ name: 'k_fiyat_farki1', type: 'number', map: '11'},
			{ name: 'k_fiyat_farki_tutar1', type: 'number', map: '12'},
			{ name: 'siparis_no1', type: 'string', map: '13'},
			{ name: 'irsaliye_kol1', type: 'string', map: '14'},
			{ name: 'fatura_kol1', type: 'string', map: '15'},
			{ name: 'cari_kol1', type: 'string', map: '16'}
		],
		datatype: "array"
	};
	var dataAdapter1 = new $.jqx.dataAdapter(source1);

	$("#jqxgrid_ic").jqxGrid(
	{
		theme: 'energyblue',
		width: screen.width - 160,
		height: 200,
		source: dataAdapter1,
		columnsresize: true,
		showfilterrow: true,
		filterable: true,
		filtermode: 'excel',
		localization: getLocalization('tr'),
		sortable: false,
		columns: [
		  { text: 'Ürün', datafield: 'property1', width: 200,cellclassname:'propertycss'},
		  { text: 'Şube', datafield: 'department_head1', width: 100,cellclassname:'propertycss'},
		  { text: 'Sip. Tarih', datafield: 'siparis_tarih1', width: 75,cellclassname:'propertycss'},
		  { text: 'Tes. Tarih', datafield: 'teslim_tarih1', width: 75,cellclassname:'propertycss'},
		  { text: 'Durum', datafield: 'durum1', width: 75,cellclassname:'durumcss'},
		  { text: 'Sip miktar', datafield: 'siparis_miktar1', width: 70,cellclassname:'durumcss', cellsalign: 'right', align: 'right',cellsformat:'c2',filtertype:'number'},
		  { text: 'Teslim', datafield: 'teslim_miktar1', width: 70,cellclassname:'durumcss', cellsalign: 'right', align: 'right',cellsformat:'c2',filtertype:'number'},
		  { text: 'Kalan', datafield: 'kalan_siparis1', width: 70,cellclassname:'durumcss', cellsalign: 'right', align: 'right',cellsformat:'c2',filtertype:'number'},
		  { text: 'Fatura F', datafield: 'fatura_fiyat1', width: 70,cellclassname:'faturacss', cellsalign: 'right', align: 'right',cellsformat:'c2',filtertype:'number'},
		  { text: 'Anlaşılan F', datafield: 'anlasilan_fiyat1', width: 70, cellsalign: 'right', align: 'right',cellsformat:'c2',filtertype:'number'},
		  { text: 'Sipariş F', datafield: 'siparis_fiyat1', width: 70,cellclassname:'faturacss', cellsalign: 'right', align: 'right',cellsformat:'c2',filtertype:'number'},
		  { text: 'K. Fiy. Farkı', datafield: 'k_fiyat_farki1', width: 50,cellclassname:'faturacss', cellsalign: 'right', align: 'right',cellsformat:'c2',filtertype:'number'},
		  { text: 'K. Fiy. F. T.', datafield: 'k_fiyat_farki_tutar1', width: 50,cellclassname:'faturacss', cellsalign: 'right', align: 'right',cellsformat:'c2',filtertype:'number'},
		  { text: 'Sipariş No', datafield: 'siparis_no1' , width: 75,cellclassname:'irsaliyecss'},
		  { text: 'İrsaliye', datafield: 'irsaliye_kol1', width: 75,cellclassname:'irsaliyecss'},
		  { text: 'Fatura', datafield: 'fatura_kol1', width:110,cellclassname:'irsaliyecss'},
		  { text: 'Cari', datafield: 'cari_kol1', width: 200}
		]
	});
});
</script>