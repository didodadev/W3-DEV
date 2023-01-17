<cfif isdefined('url.pid')>
	<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
		SELECT
			PRODUCT_NAME
		FROM
			PRODUCT
		WHERE
			PRODUCT_ID = #attributes.pid#
	</cfquery>
	<cfinclude template="../query/get_stocks.cfm">
<cfsavecontent variable="title"><cf_get_lang dictionary_id='58166.Stoklar'>: <cfoutput>#get_product_name.product_name#</cfoutput></cfsavecontent>
<cfsavecontent variable="right"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=stock.popup_list_product_spects&pid=#attributes.pid#</cfoutput>','medium')"><img src="/images/assortment.gif" title="<cf_get_lang dictionary_id='34299.Spec'>" border="0"></a></cfsavecontent>
<cf_box title="#title#" right_iamges="#right#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<thead>
			<tr>
				<th height="22"><cf_get_lang dictionary_id='58763.Depo'></th>
				<th><cf_get_lang dictionary_id ='57632.Özellik'></th>
				<th width="75" style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th width="25" align="center"></th>
			</tr>
		</thead>
		<tbody>
		<cfif get_stocks_all.recordcount>
			<cfoutput query="get_stocks_all">
			<tr>
				<td>#department_head#</td>
				<td>#get_product_name.product_name# #property#</td>
				<td style="text-align:right;">
				<cfif product_stock lt 0>
					<font color="red">#TLFormat(product_stock)#</font>
				<cfelse>
					#TLFormat(product_stock)#
				</cfif>
				</td>
				<td align="center"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=stock.detail_store_stock_popup&stock_id=#stock_id#&department=#department_id#&product_id=#attributes.pid#')"><img src="/images/cuberelation.gif" title="<cf_get_lang dictionary_id='32884.Lokasyonlara Göre Stoklar'>" border="0"></a></td>
			</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
		</tbody>
	</cf_grid_list>
<br/>
	<!--- satış durumları --->
		<cfinclude template="popup_sales_info.cfm">
	<!--- //satış durumları --->
	<br/>
	<!--- alış durumları --->
		<cfinclude template="popup_purchase_info.cfm">
	<!--- //alış durumları --->
</cf_box>
<cfelse>
	<cfexit method="exittemplate">
</cfif>

