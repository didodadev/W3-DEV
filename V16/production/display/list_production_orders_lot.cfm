<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.station_id" default="">
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date= wrk_get_today()>
</cfif>
<cfquery name="GET_W" datasource="#dsn3#">
	SELECT 
		* 
	FROM 
		WORKSTATIONS W
	WHERE 
		W.DEPARTMENT IN (SELECT DEPARTMENT_ID FROM #dsn#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		STATION_NAME
</cfquery>
<cfif len(attributes.is_submitted)>
	<cfquery name="get_production_orders_lots" datasource="#dsn3#">
		SELECT
			CAST(COUNT(LOT_NO) AS NVARCHAR(2500)) AS TOPLU_URETIM,
			LOT_NO,
			START_DATE,
			FINISH_DATE,
			DETAIL,
			STATION_ID,
			IS_STAGE,
			(select STATION_NAME from WORKSTATIONS W  WHERE W.STATION_ID= PRODUCTION_ORDERS.STATION_ID ) STATION_NAME
		FROM
			PRODUCTION_ORDERS
		WHERE
			1=1
			<cfif len(attributes.station_id)>
				AND STATION_ID = #attributes.station_id#
			</cfif>
			<cfif len(attributes.start_date) and isdate(start_date)>
				AND START_DATE >= #DATEADD('D',-1,CreateODBCDateTime(attributes.start_date))#
				AND START_DATE <= #DATEADD('D',1,CreateODBCDateTime(attributes.start_date))#
			</cfif>                  
			AND IS_GROUP_LOT = 1
			AND IS_STAGE IS NOT NULL
		GROUP BY
			LOT_NO,
			START_DATE,
			FINISH_DATE,
			DETAIL,
			STATION_ID,
			IS_STAGE
		UNION ALL
		SELECT
			P_ORDER_NO AS TOPLU_URETIM,
			LOT_NO,
			START_DATE,
			FINISH_DATE,
			DETAIL,
			STATION_ID,
			IS_STAGE,
			(select STATION_NAME from WORKSTATIONS W  WHERE W.STATION_ID= PRODUCTION_ORDERS.STATION_ID ) STATION_NAME
		FROM
			PRODUCTION_ORDERS
		WHERE
			1=1
			<cfif len(attributes.station_id)>
				AND STATION_ID = #attributes.station_id#
			</cfif>
			<cfif len(attributes.start_date) and isdate(start_date)>
				AND START_DATE >= #DATEADD('D',-1,CreateODBCDateTime(attributes.start_date))#
				AND START_DATE <= #DATEADD('D',1,CreateODBCDateTime(attributes.start_date))#
			</cfif>
			AND IS_GROUP_LOT = 0
			AND IS_STAGE IS NOT NULL  
	</cfquery>
	
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_list" action="#request.self#?fuseaction=production.order_lot" method="post">
			<cf_box_search more="0">			
				<input type="hidden" name="is_submitted" id="is_submitted" value="1">
				<div class="form-group large">
					<input name="lot_number" id="lot_number" type="text" placeHolder="<cfoutput>#getLang("","",38026)#</cfoutput>" value="" onKeyDown="if(event.keyCode == 13) {return location_production_detail(trim(this.value));}">
				</div>
				<div class="form-group large">
					<input name="name" id="name" type="text" placeHolder="<cfoutput>#session.ep.name# #session.ep.surname# #session.ep.position_name#</cfoutput>" value="" readonly="yes">
				</div>
				<div class="form-group">
					<select name="station_id" id="station_id" onChange="window.location='<cfoutput>#request.self#?fuseaction=production.order_lot&is_submitted=1&start_date='+document.getElementById('start_date').value+'&station_id='+this.value+'</cfoutput>'">
						<option value=""><cf_get_lang dictionary_id='38035.Tüm İstasyonlar'></option>
						<cfoutput query="get_w">
							<option value="#station_id#"<cfif attributes.station_id eq station_id>selected</cfif>>#station_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.baslama girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="start_date" id="start_date"  value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10" onKeyDown="if(event.keyCode == 13) search_list.submit();">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>          
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>				
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang("","",63592)#" uidrop="1" hide_table_column="1" responsive_table="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="25"><cf_get_lang dictionary_id ='57487.No'></th>
					<th><cf_get_lang dictionary_id ='38031.Parti-Emir'></th>
					<th><cf_get_lang dictionary_id ='57655.Başlama'></th>
					<th><cf_get_lang dictionary_id ='57700.Bitiş'></th>
					<th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
					<th><cfoutput>#getLang("","",58834)#</cfoutput></th>
					<th class="header_icn_none text-center"><cf_get_lang dictionary_id ='57756.Durum'></th>
				</tr>
			</thead>
			<tbody>
				<cfif len(attributes.is_submitted)>
					<cfif get_production_orders_lots.recordcount>
						<cfoutput query="get_production_orders_lots">
							<tr>
								<td>#currentrow#</td>
								<cfsavecontent variable="production_detail_info">&event=upd&p_order_no=#TOPLU_URETIM#&lot_no=#lot_no#&station_id=#STATION_ID# </cfsavecontent>
								<input type="hidden" value="#production_detail_info#" id="#lot_no#" name="#lot_no#">
								<td><a href="#request.self#?fuseaction=production.order_operator#production_detail_info#" target="_blank">#lot_no#&nbsp;&nbsp;#TOPLU_URETIM#</a></td>
								<td>#dateformat(start_date,dateformat_style)# #TimeFormat(start_date,'HH')#:#TimeFormat(start_date,'MM')#</td>
								<td>#dateformat(finish_date,dateformat_style)# #TimeFormat(finish_date,'HH')#:#TimeFormat(finish_date,'MM')#</td>
								<td>#DETAIL#</td>
								<td>#STATION_NAME#</td>
								<td align="center">
									<cfif not len(IS_STAGE)>
										<img src="/images/blue_glob.gif" title="<cf_get_lang dictionary_id='38034.Başlamadı'>!">
									<cfelseif IS_STAGE eq 0>
										<img src="/images/yellow_glob.gif" title="<cf_get_lang dictionary_id='38036.Operatöre Gönderildi'>!">
									<cfelseif IS_STAGE eq 1>
										<img src="/images/green_glob.gif" title="<cf_get_lang dictionary_id='38037.Başladı'>!">
									<cfelseif IS_STAGE eq 2>
										<img src="/images/red_glob.gif" title="<cf_get_lang dictionary_id='38038.Bitti'>!">
									<cfelseif IS_STAGE eq 3>
										<img src="/images/grey_glob.gif" title="<cf_get_lang dictionary_id='38034.Başlamadı'>!">
									</cfif>
								</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr class="color-row" height="20">
							<td colspan="15"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>
				<cfelse>
					<tr class="color-row" height="20">
						<td colspan="15"><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
	</cf_box>
</div>
<script language="javascript" type="text/javascript">
	document.getElementById('lot_number').value="";
	document.getElementById('lot_number').focus();
</script>
<script type="text/javascript">
	function location_production_detail(lot_no)
	{
		if(document.getElementById(lot_no))
			window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=production.order_operator"+document.getElementById(lot_no).value+""
		else
			alert("<cf_get_lang dictionary_id='38028.Lot No İle Uyuşan Üretim Yok'>!");	
	}
</script>
