<cfquery name="get_rows" datasource="#dsn3#">
SELECT
	SERIAL_NO,
	RECORD_DATE,
	GUARANTY_ID
FROM
	SERVICE_GUARANTY_NEW
WHERE
	--PROCESS_CAT IN (110,76,77,82,84,114,115,171) AND
	STOCK_ID = #attributes.stock_id#
	<cfif len(attributes.spect_id)>
		AND SPECT_ID = #attributes.spect_id#
	</cfif>
	AND
		SERIAL_NO NOT IN (SELECT S2.SERIAL_NO FROM SERVICE_GUARANTY_NEW S2 WHERE S2.IS_SALE = 1 AND S2.STOCK_ID = #attributes.stock_id# <cfif len(attributes.spect_id)>AND S2.SPECT_ID = #attributes.spect_id#</cfif>)
	AND
    	SERIAL_NO NOT IN (SELECT SERIAL FROM ORDER_RESULT_QUALITY_ROW WHERE SERIAL IS NOT NULL AND SERIAL <> '')
ORDER BY
	GUARANTY_ID DESC
</cfquery>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="#get_rows.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
<cfset url_str = "">
<cfset url_str = "#url_str#&spect_id=#attributes.spect_id#">
<cfset url_str = "#url_str#&field_serial_no=#attributes.field_serial_no#">
<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='60225.Hızlı Giriş Listesi'>:<cfoutput>#get_product_name(stock_id:attributes.stock_id)#</cfoutput></cfsavecontent>
<cf_box title="#message#" popup_box="1">
<cf_flat_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57637.Seri No'></th>
			<th><cf_get_lang dictionary_id='57628.Giriş Tarihi'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_rows.recordcount>
		<cfform name="add_" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_serial_operations_action">
			<cfoutput>
			</cfoutput>
			<cfoutput query="get_rows" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td><a href="javascript://" class="tableyazi" onclick="send_value(#GUARANTY_ID#,'#serial_no#')">#serial_no#</a></td>
					<td>#dateformat(record_date,dateformat_style)#</td>
				</tr>
			</cfoutput>
		</cfform>
		<cfelse>
		<tr>
			<td colspan="2"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
		</tr>
		</cfif>
	</tbody>
</cf_flat_list>
	<cfif attributes.totalrecords gt attributes.maxrows><cfif isDefined("attributes.draggable") and len(attributes.draggable)>
		<cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
	</cfif>
	
		<cf_paging 
		page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#attributes.fuseaction##url_str#"
		isAjax="#iif(isdefined("attributes.draggable"),1,0)#">	
	</cfif>
</cf_box>
<script type="text/javascript">
	function send_value(id,stock_id)
	{
		<cfoutput>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.#attributes.field_serial_no#.value = stock_id;
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		</cfoutput>
	}
</script>
