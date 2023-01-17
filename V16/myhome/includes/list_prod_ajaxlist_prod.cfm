<cfsetting showdebugoutput="no">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="10">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<cfquery name="get_prod" datasource="#DSN3#">
	WITH CTE1 AS
    (
    SELECT
        DISTINCT 
        S.PROPERTY,
        S.PRODUCT_NAME,
        S.PRODUCT_ID,
        POR.P_ORDER_ID,
        POR.START_DATE
    FROM
        STOCKS S,
        PRODUCTION_ORDERS POR
    WHERE
        POR.STOCK_ID=S.STOCK_ID AND
        START_DATE> = #NOW()#
	),
   CTE2 AS (
        SELECT
            CTE1.*,
            ROW_NUMBER() OVER (ORDER BY START_DATE DESC) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
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
<cfset adres="myhome.emptypopup_list_prod_ajaxlist_prod">
<cfif get_prod.recordcount>
	<cfparam name="attributes.totalrecords" default="#get_prod.QUERY_COUNT#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cf_flat_list>
	<cfif get_prod.recordcount>
		<thead>
			<tr>
				<th><cf_get_lang_main no="1165.Sıra"></th>
				<th><cf_get_lang_main no="245.ürün"></th>
				<th><cf_get_lang_main no="330.tarih"></th>
			</tr>
		</thead>
		<tbody>
		<cfoutput query="get_prod">
			<tr>
				<td width="25">#ROWNUM#</td>
				<td><a href="#request.self#?fuseaction=prod.order&event=upd&upd=#P_ORDER_ID#" clasS="tableyazi">#PRODUCT_NAME#-#PROPERTY#</a></td>
				<td width="75">#dateformat(START_DATE,dateformat_style)#</td>
			</tr>
		</cfoutput>
		</tbody>
	<cfelse>
		<tbody>
			<tr>
				<td><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
			</tr>
		</tbody>
	</cfif>
</cf_flat_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cf_paging
		name="my_prod"
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="#adres#"
		isAjax="1"
		target="body_product_orders"
		>
</cfif>
