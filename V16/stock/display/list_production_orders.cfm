<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_result" default="1">
<script type="text/javascript">
function ekle(production_order_id,production_order_name)
{
	<cfif isdefined("attributes.field_id")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = production_order_id;
	</cfif>
	<cfif isdefined("attributes.field_name")>
		<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = production_order_name;
	</cfif>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
}
</script>
<cfset url_str = ''>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif len(attributes.keyword) or isdefined('attributes.is_submitted')>
	<cfquery name="GET_PO_DET" datasource="#dsn3#">
		SELECT
			*
		FROM
			PRODUCTION_ORDERS PO,
			STOCKS S,
			PRODUCT P
		WHERE
			PO.STOCK_ID=S.STOCK_ID AND
			S.PRODUCT_ID=P.PRODUCT_ID 
			<cfif isdefined('attributes.stock_id') and len(attributes.stock_id)>
				AND S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
			</cfif>
			<cfif len(attributes.keyword)>
				AND PO.P_ORDER_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
			</cfif>
			<cfif isdefined("attributes.is_result") and attributes.is_result eq 1>
				AND PO.P_ORDER_ID NOT IN (SELECT P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS)	
			</cfif>
	</cfquery>
	<cfset arama_yapilmali=0 >
<cfelse>
	<cfset GET_PO_DET.recordcount=0>
	<cfset arama_yapilmali=1 >
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_PO_DET.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('stock',211)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="prod_orders" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_prod_order#url_str#">
		<input name="is_submitted" id="is_submitted" type="hidden" value="1">
		<input name="is_result" id="is_result" type="hidden" value="<cfoutput>#attributes.is_result#</cfoutput>">
		<cf_box_search more="0">
			<div class="form-group">
				<cfinput type="text" name="keyword" placeholder="Filtre" value="#attributes.keyword#">
			</div>
			<div class="form-group">
				<div class="input-group">
					<input type="hidden" name="stock_id" id="stock_id" <cfif isdefined('attributes.stock_id') and len("attributes.stock_id") and isdefined('attributes.product_name') and len(attributes.product_name)> value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
					<input type="text" name="product_name" id="product_name" value="<cfif isdefined('attributes.stock_id') and len(attributes.stock_id) and isdefined('attributes.product_name') and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" readonly placeholder="<cfoutput><cf_get_lang dictionary_id='57657.Ürün'></cfoutput>">
					<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=prod_orders.stock_id&field_name=prod_orders.product_name&keyword='+encodeURIComponent(document.prod_orders.product_name.value));"></span>
				</div>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" placeholder="#getLang('','Kayıt Sayısı Hatalı',43958)#">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('prod_orders' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang_main no='1677.Emir No'></th>
				<th ><cf_get_lang_main no='245.Ürün'></th>
				<!--- <th width="100"><cf_get_lang no='177.Rota'></th> --->
				<th width="100"><cf_get_lang_main no='1422.İstasyon'></th>
				<th width="90" ><cf_get_lang no='179.Hedef Başlama'></th>
				<th width="90" ><cf_get_lang no='180.Hedef Bitiş'></th>
				<th width="70" align="right" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
				<th width="50"><cf_get_lang_main no='224.Birim'></th>
				<th width="70"><cf_get_lang_main no='70.Aşama'></th>
			</tr>
		</thead>
		<tbody>
			<cfif GET_PO_DET.RECORDCOUNT>
				<cfoutput query="GET_PO_DET" STARTROW="#attributes.startrow#" MAXROWS="#attributes.maxrows#">
					<tr onclick="ekle('#p_order_id#','#p_order_no#');" style="cursor:pointer;">
						<td>#p_order_no#</td>
						<td>#product_name#&nbsp;#property#</td>
						<!--- <td><cfif len(route_id)>#GET_ROUTE_PROD(route_id)#</cfif></td> --->
						<td><cfif len(station_id)>#GET_STATION_PROD(station_id)#</cfif></td>
						<td>
							<cfif len(start_date)>
								#dateformat(date_add('h',session.ep.time_zone,start_date),dateformat_style)#  
								#TimeFormat(date_add('h',session.ep.time_zone,start_date),timeformat_style)#
							</cfif>
						</td>
						<td>
							<cfif len(finish_date)>
								#dateformat(date_add('h',session.ep.time_zone,finish_date),dateformat_style)#  
								#TimeFormat(date_add('h',session.ep.time_zone,finish_date),timeformat_style)#
							</cfif>
						</td>
						<td align="right" style="text-align:right;">#quantity#</td>
						<td> <cfif len(stock_id)>#GET_PRODUCT_PROPERTY_PROD(stock_id,'unit')#</cfif></td>
						<td><cfif len(status_id)>#GET_STATUS_PROD_ORDER(status_id)#</cfif></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr class="color-row" height="20">
					<td colspan="10"><cfif arama_yapilmali><cf_get_lang_main no='289.Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
			<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
		</cfif>
		<cfif isdefined("attributes.product_name") and len(attributes.product_name)>
			<cfset url_str = "#url_str#&product_name=#attributes.product_name#">
		</cfif>
		<cfif isdefined("attributes.is_result") and len(attributes.is_result)>
			<cfset url_str = "#url_str#&is_result=#attributes.is_result#">
		</cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#GET_PO_DET.RECORDCOUNT#"
			startrow="#attributes.startrow#"
			adres="#listgetat(attributes.fuseaction,1,'.')#.popup_list_prod_order#url_str#&is_submitted=1"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
