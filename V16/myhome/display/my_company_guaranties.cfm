<cfsetting showdebugoutput="no">
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfquery name="get_guaranties" datasource="#dsn3#">
	SELECT
		S.PRODUCT_NAME,
		SGN.SERIAL_NO,
		SGN.PROCESS_NO,
		SGN.SALE_START_DATE,
		SGN.SALE_FINISH_DATE
	FROM
		SERVICE_GUARANTY_NEW SGN,
		STOCKS S
	WHERE
		S.STOCK_ID = SGN.STOCK_ID AND
		SGN.PROCESS_CAT IN (70,71,72,83) AND
		SGN.SALE_COMPANY_ID = #attributes.cpid# AND
		SGN.SALE_START_DATE <= #now()# AND
		SGN.SALE_FINISH_DATE >= #now()#
</cfquery>
<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id="57657.Urun"></td>
			<th width="125"><cf_get_lang dictionary_id="57637.Seri No"></th>
			<th width="90"><cf_get_lang dictionary_id="58772.İşlem No"></th>
			<th width="65"><cf_get_lang dictionary_id="57501.Başlangıç"></th>
			<th width="65"><cf_get_lang dictionary_id="57502.Bitiş"></th>
		</tr>
	</thead>
    <tbody>
	<cfif get_guaranties.recordcount>
		<cfoutput query="get_guaranties" startrow="1" maxrows="#attributes.maxrows#">
			<tr>
				<td>#product_name#</td>
				<td>#SERIAL_NO#</td>
				<td>#PROCESS_NO#</td>
				<td>#dateformat(SALE_START_DATE,dateformat_style)#</td>
				<td>#dateformat(SALE_FINISH_DATE,dateformat_style)#</td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
		</tr> 
	</cfif>
	</tbody>
</cf_ajax_list>
