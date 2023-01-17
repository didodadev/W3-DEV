<!--- <cfparam name="attributes.from_production_result_detail" default="1"> ---> 
<!---
Workcube Implementasyon : Şu An İleriki Kayıtları Almamak İçin process_date <= now() Kontrolu Var
Çunku Teknik Olarak Mal Girmemiş veya Çıkmamış Oluyor Hepsini Aldırıyoruz
--->
<cfsetting showdebugoutput="no">
<cfif not isdefined("attributes.spect_main_id")><cfset attributes.spect_main_id = 0></cfif>
<cfparam name="attributes.department_id" default="">
<cfquery name="GET_PRODUCT" datasource="#DSN3#">
	SELECT 
		PU.MAIN_UNIT,
		PU.PRODUCT_ID,
		S.PRODUCT_NAME
	FROM 
		PRODUCT_UNIT PU,
		STOCKS S
	WHERE 
		S.PRODUCT_ID = PU.PRODUCT_ID AND
		<cfif isdefined("attributes.pid")>
			S.PRODUCT_ID = #attributes.pid# 
		<cfelse>
			S.STOCK_ID = #attributes.stock_id#
		</cfif>
</cfquery>
<cfquery name="GET_STOCKS_ALL" datasource="#DSN2#">
	SELECT 
		SUM(SR.STOCK_IN-SR.STOCK_OUT) TOPLAM, 
		SR.SPECT_VAR_ID AS SPECT_MAIN_ID,
        (SELECT SM.SPECT_MAIN_NAME FROM #dsn3_alias#.SPECT_MAIN SM WHERE SM.SPECT_MAIN_ID = SR.SPECT_VAR_ID) AS SPECT_MAIN_NAME,
		SR.PRODUCT_ID PRODUCT_ID,
		P.PRODUCT_NAME
        <cfif isdefined('attributes.from_production_result_detail')>,SR.STORE,SR.STORE_LOCATION</cfif>
	FROM
		STOCKS_ROW AS SR,
		#dsn1_alias#.PRODUCT P
	WHERE
		P.PRODUCT_ID = SR.PRODUCT_ID AND 
		SR.PROCESS_TYPE IS NOT NULL 
		<cfif isdefined('attributes.stock_id')>
            AND SR.STOCK_ID = #attributes.stock_id# 
        <cfelseif isdefined('attributes.pid')>
            AND SR.PRODUCT_ID = #attributes.pid# 
        </cfif>
		<cfif isdefined("attributes.spect_main_id") and len(attributes.spect_main_id) and attributes.spect_main_id neq 0>
			AND SR.SPECT_VAR_ID = #attributes.spect_main_id#
		</cfif>
		<cfif len(attributes.department_id)>
            <cfif listlen(attributes.department_id,'-') eq 1>
                AND SR.STORE = #attributes.department_id#
            <cfelse>
                AND (SR.STORE =  #listfirst(attributes.department_id,'-')# AND SR.STORE_LOCATION = #listlast(attributes.department_id,'-')#)
            </cfif>
        </cfif>
	GROUP BY 
		SR.PRODUCT_ID,SR.SPECT_VAR_ID,P.PRODUCT_NAME
        <cfif isdefined('attributes.from_production_result_detail')><!--- Eğer Üretim Sonuç Detayından Geliyorsa.. --->
		,SR.STORE,SR.STORE_LOCATION
            ORDER BY SR.STORE,SR.STORE_LOCATION,SR.PRODUCT_ID,SR.SPECT_VAR_ID
		</cfif>
</cfquery>
<cfif isdefined('attributes.from_production_result_detail')>
	<cfsetting showdebugoutput="no">
	<cfset store_list = listdeleteduplicates(ValueList(GET_STOCKS_ALL.STORE,','))>
    <cfset location_list = listdeleteduplicates(ValueList(GET_STOCKS_ALL.STORE_LOCATION,','))>
<cfelse>
	<cfif not len(attributes.department_id)>
      <cfquery name="GET_SPECTS_RESERVED" datasource="#dsn3#"><!--- Alınan Siparis/Rezerve degerini bulmak icin kullanildi. --->
        SELECT 
            SUM(STOCK_AZALT) STOCK_AZALT,
            SPECT_MAIN_ID
        FROM
            GET_STOCK_RESERVED_SPECT
        WHERE
            <cfif isdefined('attributes.stock_id')>
                STOCK_ID = #attributes.stock_id# 
            <cfelseif isdefined('attributes.pid')>
                PRODUCT_ID = #attributes.pid# 
            </cfif>
        GROUP BY
            SPECT_MAIN_ID
      </cfquery>
      <cfquery name="GET_SPECTS_RESERVED_2" datasource="#dsn3#"><!--- Alınan Siparis/Rezerve degerini bulmak icin kullanildi. --->
        SELECT 
            SUM(STOCK_ARTIR) STOCK_ARTIR,
            SPECT_MAIN_ID
        FROM
            GET_STOCK_RESERVED_SPECT
        WHERE
            <cfif isdefined('attributes.stock_id')>
                STOCK_ID = #attributes.stock_id# 
            <cfelseif isdefined('attributes.pid')>
                PRODUCT_ID = #attributes.pid# 
            </cfif>
        GROUP BY
            SPECT_MAIN_ID
      </cfquery>
    </cfif>
    <cfquery name="GET_SPECTS_PROD_RESERVED" datasource="#DSN3#"><!--- Uretimde Rezerve --->
        SELECT
            SUM(STOCK_AZALT) AS AZALAN,
            SUM(STOCK_ARTIR) AS ARTAN,
            SPECT_MAIN_ID SPECT_VAR_ID
        FROM
            GET_PRODUCTION_RESERVED_SPECT
        WHERE
        <cfif isdefined('attributes.stock_id')>
            STOCK_ID = #attributes.stock_id# 
        <cfelseif isdefined('attributes.pid')>
            PRODUCT_ID = #attributes.pid# 
        </cfif>
        GROUP BY
            SPECT_MAIN_ID	
    </cfquery>
</cfif>    
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
    SELECT DEPARTMENT_ID,LOCATION_ID,COMMENT FROM STOCKS_LOCATION <cfif isdefined('store_list') and len(store_list)>WHERE DEPARTMENT_ID IN(#store_list#)</cfif>
</cfquery>
<cfinclude template="../query/get_stores.cfm">
<cfparam name="attributes.page" default=1>
<cfif not isdefined('attributes.from_production_result_detail')>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#get_stocks_all.recordcount#'>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_stocks_all.recordcount#'>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('stock',58)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfif not isdefined('attributes.from_production_result_detail')>
		<cfset table_class="color-border">
		<cfset body_class = "color-row">
		<cfset body2_class = "color-list">
		<cfset tr_class="color-header">
		<cfset td_class="txtboldblue">
			
		<cfset url_str="">
		<cfif isdefined('attributes.stock_id') and len(attributes.stock_id)>
			<cfset url_str="#url_str#&stock_id=#attributes.stock_id#">
		</cfif>
		<cfif isdefined('attributes.pid') and len(attributes.pid)>
			<cfset url_str="#url_str#&pid=#attributes.pid#">
		</cfif>
		<cfform name="list_stock_spec" method="post" action="#request.self#?fuseaction=stock.popup_list_product_spects#url_str#">
			<cf_box_search more="0">
				<div class="form-group" id="item-department_id">
					<select name="department_id" id="department_id">
						<option value=""><cf_get_lang dictionary_id='45910.Tüm Depolar'></option>
						<cfoutput query="stores">
							<option value="#department_id#"<cfif attributes.department_id eq department_id>selected</cfif>>#department_head#</option>
							<cfquery name="GET_LOCATION" dbtype="query">
								SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = #stores.department_id[currentrow]#
							</cfquery>		 
							<cfif get_location.recordcount>
								<cfloop from="1" to="#get_location.recordcount#" index="s">
									<option value="#department_id#-#get_location.location_id[s]#" <cfif attributes.department_id eq '#department_id#-#get_location.location_id[s]#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#get_location.comment[s]#</option>
								</cfloop>
							</cfif>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" onKeyUp="isNumber(this)" maxlength="3" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_stock_spec' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<!--- <cf_workcube_file_action mail='1' print='1'> --->
			</cf_box_search>
		</cfform>
	<cfelse>
		<cfset body_class = "body">
		<cfset body2_class = "body">
		<cfset table_class="pod_box">
		<cfset tr_class="header">
		<cfset td_class="txtboldblue">
	<cfscript>
		for(li=1;li lte GET_ALL_LOCATION.recordcount;li=li+1)
			'location_#GET_ALL_LOCATION.DEPARTMENT_ID[li]#_#GET_ALL_LOCATION.LOCATION_ID[li]#' = '#GET_ALL_LOCATION.COMMENT[li]#' ;
		for(si=1;si lte STORES.recordcount;si=si+1)
			'department_#STORES.DEPARTMENT_ID[si]#' ='#STORES.DEPARTMENT_HEAD[si]#';	
	</cfscript>    
	</cfif>
	<cf_grid_list>
		<thead>
			<tr>
				<th colspan="5">
					<cfoutput>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_product.product_id#','medium');">#get_product.product_name#</a>
					</cfoutput>
					<cfif isdefined('attributes.from_production_result_detail') and not isdefined("attributes.is_from_spect")>
						<a href="javascript://" onClick="gizle(prod_stock_and_spec_detail_div);"><img style="cursor:pointer;" src="images/pod_close.gif"></a>
						<cfelseif isdefined("attributes.is_from_spect")>
						<a href="javascript://" onClick="hide('prod_stock_and_spec_detail_div_row_<cfoutput>#attributes.spect_main_id#</cfoutput>');"><img style="cursor:pointer;" src="images/pod_close.gif"></a>
					</cfif>
				</th>
			</tr>
			<tr>
				<th><cf_get_lang dictionary_id='57647.Spec'><cf_get_lang dictionary_id='58527.ID'></th>
				<cfif isdefined('attributes.from_production_result_detail')>
					<th><cf_get_lang dictionary_id='58763.Depo'>-<cf_get_lang dictionary_id='30031.Lokasyon'></th>
				</cfif>
				<cfif not isdefined('attributes.from_production_result_detail') and isDefined("attributes.department_id") and not len(attributes.department_id)>
					<th><cf_get_lang dictionary_id='40224.Alınan Sipariş'> / <cf_get_lang dictionary_id='29750.Rezerve'></th>
					<th><cf_get_lang dictionary_id='32696.Verilen Sipariş'> / <cf_get_lang dictionary_id='29750.Rezerve'></th>
					<th><cf_get_lang dictionary_id='49884.Üretim Emri'> / <cf_get_lang dictionary_id='58119.Beklenen'></th>
				</cfif>
				<th style="text-align:right;"><cf_get_lang dictionary_id='57635.Miktar'>-<cf_get_lang dictionary_id='57636.Birim'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_stocks_all.recordcount>
				<cfoutput query="get_stocks_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td><cfif Len(spect_main_id)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_spec&id=#spect_main_id#','medium');">#spect_main_id#-#SPECT_MAIN_NAME#</a><cfelse>#spect_main_id#-#SPECT_MAIN_NAME#</cfif></td>
					<cfif isdefined('attributes.from_production_result_detail')>
						<td>
							<cfif len(STORE_LOCATION) and isdefined("department_#STORE#") and isdefined("location_#STORE#_#STORE_LOCATION#")>
								#Evaluate("department_#STORE#")# -#Evaluate("location_#STORE#_#STORE_LOCATION#")#
							</cfif>
						</td>
					</cfif>
					<cfif not isdefined('attributes.from_production_result_detail') and isDefined("attributes.department_id") and not len(attributes.department_id)>
						<td style="text-align:right;">
							<cfquery name="SPECTS_RESERVED_ROW" dbtype="query">
								SELECT STOCK_AZALT FROM GET_SPECTS_RESERVED WHERE SPECT_MAIN_ID <cfif len(get_stocks_all.spect_main_id)>= #get_stocks_all.spect_main_id#<cfelse>IS NULL</cfif>
							</cfquery>
							<cfif spects_reserved_row.recordcount and isDefined("attributes.pid")>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_orders&taken=1&pid=#attributes.pid#&spect_main_id=#spect_main_id#');">
								#TLFormat(spects_reserved_row.stock_azalt)#
							</a>
							#get_product.main_unit#</cfif>
						</td>
						<td style="text-align:right;">
							<cfquery name="SPECTS_RESERVED_ROW_2" dbtype="query">
								SELECT STOCK_ARTIR FROM GET_SPECTS_RESERVED_2 WHERE SPECT_MAIN_ID <cfif len(get_stocks_all.spect_main_id)>= #get_stocks_all.spect_main_id#<cfelse>IS NULL</cfif>
							</cfquery>
							<cfif spects_reserved_row_2.recordcount and isDefined("attributes.pid")>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_reserved_orders&taken=0&pid=#attributes.pid#&nosale_order_location=0&spect_main_id=#spect_main_id#');">
								#TLFormat(spects_reserved_row_2.stock_artır)#
							</a>
							#get_product.main_unit#</cfif>
						</td>
						<td style="text-align:right;">
							<cfquery name="SPECTS_PROD_RESERVED_ROW" dbtype="query">
								SELECT ARTAN FROM GET_SPECTS_PROD_RESERVED WHERE SPECT_VAR_ID <cfif len(get_stocks_all.spect_main_id)>= #get_stocks_all.spect_main_id#<cfelse>IS NULL</cfif>
							</cfquery>
							<cfif spects_prod_reserved_row.recordcount>#TLFormat(spects_prod_reserved_row.artan)# #get_product.main_unit#</cfif>
						</td>
					</cfif>
					<td style="text-align:right;">
									<cfif not isdefined("attributes.is_from_spect")>
										<cfif not len(get_stocks_all.spect_main_id)><cfset spect_main_id_ = 0><cfelse><cfset spect_main_id_ = get_stocks_all.spect_main_id></cfif>
										<a href="javascript://" onClick="get_stok_spec_detail_ajax_row_#attributes.spect_main_id#('#product_id#','#spect_main_id_#');">
											#TLFormat(toplam,4)#
										</a>
										#get_product.main_unit#
										<div id="prod_stock_and_spec_detail_div_row_#spect_main_id_#" style="position:absolute;width:300px; height:150; overflow:auto;z-index:1;"></div>
									<cfelse>
										#TLFormat(toplam,4)#
										#get_product.main_unit#
									</cfif>
					</td>
				</tr>
				</cfoutput>
			</cfif>
			<cfif not get_stocks_all.recordcount>
				<tr>
					<td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif not isdefined('attributes.from_production_result_detail')>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset adres="stock.popup_list_product_spects">
			<cfif isDefined('attributes.stock_id') and len(attributes.stock_id)>
				<cfset adres = "#adres#&stock_id=#attributes.stock_id#">
			</cfif>
			<cfif isDefined('attributes.pid') and len(attributes.pid)>
				<cfset adres = "#adres#&pid=#attributes.pid#">
			</cfif>
			<cfif isDefined('attributes.department_id') and len(attributes.department_id)>
				<cfset adres = "#adres#&department_id=#attributes.department_id#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cfif>
</cf_box>
<script type="text/javascript">
	function get_stok_spec_detail_ajax_row_<cfoutput>#attributes.spect_main_id#</cfoutput>(product_id,spect_main_id){
			new_div_id = 'prod_stock_and_spec_detail_div_row_'+spect_main_id;
			show(new_div_id);
			tempX = event.clientX + document.body.scrollLeft;
			tempY = event.clientY + document.body.scrollTop;
			document.getElementById(new_div_id).style.left = tempX-300;
			document.getElementById(new_div_id).style.top = tempY;
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=stock.popup_list_product_spects&is_from_spect=1&from_production_result_detail=1&pid='+product_id+'&spect_main_id='+spect_main_id+'</cfoutput>',new_div_id,1)	
		}
</script>
