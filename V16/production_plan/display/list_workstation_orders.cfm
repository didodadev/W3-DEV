<cfparam name="attributes.result" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfquery name="GET_ORDER" datasource="#DSN3#">
	SELECT
		W.STATION_NAME,
		PO.*,
		S.PROPERTY,
		P.PRODUCT_NAME,
		ISNULL((SELECT
					SUM(POR_.AMOUNT) ORDER_AMOUNT
				FROM
					PRODUCTION_ORDER_RESULTS_ROW POR_,
					PRODUCTION_ORDER_RESULTS POO
				WHERE
					POR_.PR_ORDER_ID = POO.PR_ORDER_ID AND 
					POO.P_ORDER_ID = PO.P_ORDER_ID AND 
					POR_.TYPE = 1 AND 
					POO.IS_STOCK_FIS = 1
				),0) RESULT_AMOUNT
	FROM
		WORKSTATIONS W,
		PRODUCTION_ORDERS PO,
		PRODUCT P,
		STOCKS S
	WHERE	
		W.STATION_ID=PO.STATION_ID AND
		S.PRODUCT_ID=P.PRODUCT_ID AND
		PO.STOCK_ID=S.STOCK_ID AND
		PO.STATION_ID = #attributes.STATION_ID#
		<cfif len(attributes.keyword)>
		 AND
			(
				P_ORDER_NO LIKE '%#attributes.keyword#%'
				OR 
				P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
				OR 
				S.PROPERTY LIKE '%#attributes.keyword#%'
			)
		</cfif>
		<cfif isdefined('attributes.result') and attributes.result eq 1>
			AND PO.P_ORDER_ID IN (SELECT PRODUCTION_ORDER_RESULTS.P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS)
		<cfelseif isdefined('attributes.result') and attributes.result eq 0>
			AND PO.P_ORDER_ID NOT IN (SELECT PRODUCTION_ORDER_RESULTS.P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS)
		<cfelseif isdefined('attributes.result') and attributes.result eq 2>
			AND ISNULL((SELECT
					SUM(POR_.AMOUNT) ORDER_AMOUNT
				FROM
					PRODUCTION_ORDER_RESULTS_ROW POR_,
					PRODUCTION_ORDER_RESULTS POO
				WHERE
					POR_.PR_ORDER_ID = POO.PR_ORDER_ID AND 
					POO.P_ORDER_ID = PO.P_ORDER_ID AND 
					POR_.TYPE = 1 AND 
					POO.IS_STOCK_FIS = 1
				),0) < PO.QUANTITY
		</cfif>
		<cfif len(attributes.start_date)>
			<cf_date tarih="attributes.start_date">
			AND START_DATE >= #attributes.start_date#
		</cfif>
		<cfif len(attributes.finish_date)>
			<cf_date tarih="attributes.finish_date">
			AND FINISH_DATE <= #attributes.finish_date#
		</cfif>
</cfquery>
<cfparam name="attributes.totalrecords" default='#get_order.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.modal_id" default="">
<cfset adres = "prod.popup_list_workstation_orders&station_id=#attributes.station_id#&result=#attributes.result#">
<cfsavecontent variable="title_">
	<cfoutput>#get_order.STATION_NAME#</cfoutput>
</cfsavecontent>

<cf_box title="#getLang('','İstasyon Yükü',36671)# : #title_#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="stock_search" action="#request.self#?fuseaction=prod.popup_list_workstation_orders&station_id=#attributes.station_id#" method="post">
		<cf_box_search more="0">
			<div class="form-group">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfinput maxlength="10" validate="#validate_style#" type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" message="#getLang('','Başlangıç Tarihi',58053)#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfinput maxlength="10" validate="#validate_style#" type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" message="#getLang('','Bitiş Tarihi',57700)#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
				</div>
			</div>
			<div class="form-group">
				<select name="result" id="result">
					<option value=""><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
					<option value="1"<cfif attributes.result eq 1>selected</cfif>><cf_get_lang dictionary_id ='36900.Girilenler'></option>
					<option value="0"<cfif attributes.result eq 0>selected</cfif>><cf_get_lang dictionary_id ='36899.Girilmeyenler'></option>
					<option value="2"<cfif attributes.result eq 2>selected</cfif>><cf_get_lang dictionary_id ="34298.Kalanı Olanlar"></option>
				</select>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#!" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('stock_search' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>				
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='29474.Emir No'></th>
				<th><cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></th>
				<th><cf_get_lang dictionary_id='36606.Hedef Bitiş'></th>
				<th><cf_get_lang dictionary_id='57657.Ürün'></th>
				<th><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th><cf_get_lang dictionary_id='36608.Üretilen'></th>
				<th><cf_get_lang dictionary_id='58444.Kalan'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_order.recordcount>
				<cfoutput query="get_order" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">				
				<cfset STARTDATE=date_add('h',SESSIOn.EP.TIME_ZONE,START_DATE)>
				<cfset FINISHDATE=date_add('h',SESSIOn.EP.TIME_ZONE,FINISH_DATE)>
					<tr>
						<td>#P_ORDER_NO#</td>
						<td>#dateformat(STARTDATE,dateformat_style)#  #timeformat(STARTDATE,timeformat_style)#</td>
						<td>#dateformat(FINISHDATE,dateformat_style)# #timeformat(FINISHDATE,timeformat_style)#</td>
						<td>#PRODUCT_NAME# #PROPERTY#</td>
						<td>#tlformat(QUANTITY)#</td>
						<td><cfif len(RESULT_AMOUNT)>#tlformat(RESULT_AMOUNT)#<cfelse>#tlformat(0)#</cfif></td>
						<td><cfif len(RESULT_AMOUNT)>#tlformat(QUANTITY-RESULT_AMOUNT)#<cfelse>#tlformat(QUANTITY)#</cfif></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="7">
						<cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!								
					</td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>
	<cfif attributes.maxrows lt attributes.totalrecords>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
</cf_box>
