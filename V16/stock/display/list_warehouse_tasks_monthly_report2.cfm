<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.comp" default="">
<cfif isdefined('attributes.start_date') and isdate(attributes.start_date)>
	<cf_date tarih='attributes.start_date'>
<cfelse>
	<cfset attributes.start_date = now()>
</cfif>	
<cfif isdefined('attributes.finish_date') and isdate(attributes.finish_date)>
	<cf_date tarih='attributes.finish_date'>
<cfelse>
	<cfset attributes.finish_date = now()>
</cfif>
<cf_box>
<cfform action="index.cfm?fuseaction=stock.list_warehouse_tasks&event=monthly_report2" method="post" name="service_form" lang="en">
<cfinput type="hidden" name="is_submit" value="1">	
	<cf_box_search plus="0"><div class="form-group" id="item-date">
       <cfoutput><cf_get_lang dictionary_id="57742.Tarih"></cfoutput>
    </div>
            	<div class="form-group" id="item-date">
                    <div class="col col-12">
                    	<div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
                            <cfinput value="#dateformat(attributes.start_date,dateformat_style)#" type="text" name="start_date" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
                            <span class="input-group-addon no-bg"></span>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
                            <cfinput value="#dateformat(attributes.finish_date,dateformat_style)#" type="text" name="finish_date" validate="#validate_style#" maxlength="10" message="#message#" style="width:65px;">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>						
                    </div>
                </div>
				<div class="form-group">
						<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
						<cf_wrk_search_button button_type="4" search_function="date_check(service_form.start_date,service_form.finish_date,'#message_date#')">
				</div>
	</cf_box_search>
</cfform>
</cf_box>
<cfif isdefined("attributes.is_submit")>
	<cfquery name="get_all_services" datasource="#dsn3#">
		SELECT 
			WT.TASK_ID,
			WT.IS_ACTIVE,
			WT.WAREHOUSE_IN_OUT,
			WT.COMPANY_ID,
			ISNULL(WT.PROJECT_ID,0) AS PROJECT_ID,
			PP.PROJECT_HEAD,
			C.NICKNAME
		FROM 
			WAREHOUSE_TASKS WT
				LEFT JOIN  #dsn_alias#.PRO_PROJECTS PP ON WT.PROJECT_ID=PP.PROJECT_ID
				LEFT JOIN  #dsn_alias#.COMPANY C ON WT.COMPANY_ID=C.COMPANY_ID
		WHERE 
			WT.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
			WT.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
			WT.WAREHOUSE_IN_OUT NOT IN (3)
	</cfquery>
	<cf_box title="#getlang('','Servis Raporu','41718')#">
	<cfquery name="get_customers" dbtype="query">
		SELECT DISTINCT
			COMPANY_ID,
			NICKNAME
		FROM
			get_all_services
		ORDER BY
			NICKNAME
	</cfquery>
	<cfoutput query="get_customers">
		<cfquery name="get_customer_services" dbtype="query">
			SELECT TASK_ID
			FROM
				get_all_services
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
		</cfquery>
		
		<cfquery name="get_rec_rates" datasource="#dsn3#">
		SELECT
			*
		FROM
			(
			SELECT 
				WRR.WAREHOUSE_TASK_TYPE_ID,
				WRR.RATE_CODE,
				WTT.WAREHOUSE_TASK_TYPE,
				WTT.WAREHOUSE_TASK_TYPE_ORDER,
				WRR.RATE_INFO,
				WRR.PRICE,
				ISNULL((
					SELECT 
						SUM(ROW_AMOUNT) 
					FROM 
						WAREHOUSE_TASKS_ROWS WTR,
						WAREHOUSE_TASKS WT
					WHERE 
						WT.TASK_ID = WTR.TASK_ID AND
						WT.WAREHOUSE_IN_OUT = 0 AND 
						WTR.WAREHOUSE_TASK_TYPE_ID = WRR.WAREHOUSE_TASK_TYPE_ID AND 
						WTR.RATE_CODE = WRR.RATE_CODE AND 
						WTR.TASK_ID IN (#valuelist(get_customer_services.TASK_ID)#)),0) AS ROW_AMOUNT
			FROM
				WAREHOUSE_RATES WR,
				WAREHOUSE_RATES_ROWS WRR,
				#dsn_alias#.WAREHOUSE_TASK_TYPES WTT
			WHERE 
				WTT.IS_RECEIVING = 1 AND
				WRR.WAREHOUSE_TASK_TYPE_ID = WTT.WAREHOUSE_TASK_TYPE_ID AND
				WR.RATE_ID = WRR.RATE_ID AND
				WR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
			) T_ALL
		WHERE
			ROW_AMOUNT > 0
		ORDER BY
			WAREHOUSE_TASK_TYPE_ORDER ASC
		</cfquery>
		<cfquery name="get_ship_rates" datasource="#dsn3#">
		SELECT
			*
		FROM
			(
			SELECT 
				WRR.WAREHOUSE_TASK_TYPE_ID,
				WRR.RATE_CODE,
				WTT.WAREHOUSE_TASK_TYPE,
				WTT.WAREHOUSE_TASK_TYPE_ORDER,
				WRR.RATE_INFO,
				WRR.PRICE,
				ISNULL((
					SELECT 
						SUM(ROW_AMOUNT) 
					FROM 
						WAREHOUSE_TASKS_ROWS WTR,
						WAREHOUSE_TASKS WT
					WHERE 
						WT.TASK_ID = WTR.TASK_ID AND
						WT.WAREHOUSE_IN_OUT = 1 AND
						WTR.WAREHOUSE_TASK_TYPE_ID = WRR.WAREHOUSE_TASK_TYPE_ID AND 
						WTR.RATE_CODE = WRR.RATE_CODE AND 
						WTR.TASK_ID IN (#valuelist(get_customer_services.TASK_ID)#)),0) AS ROW_AMOUNT
			FROM
				WAREHOUSE_RATES WR,
				WAREHOUSE_RATES_ROWS WRR,
				#dsn_alias#.WAREHOUSE_TASK_TYPES WTT
			WHERE 
				WTT.IS_SHIPMENT = 1 AND
				WRR.WAREHOUSE_TASK_TYPE_ID = WTT.WAREHOUSE_TASK_TYPE_ID AND
				WR.RATE_ID = WRR.RATE_ID AND
				WR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
			) T_ALL
		WHERE
			ROW_AMOUNT > 0
		ORDER BY
			WAREHOUSE_TASK_TYPE_ORDER ASC
		</cfquery>
		<div class="row myhomeBox">	
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cf_ajax_list>
				<thead>
					<tr>
						<th colspan="4"><h4><b>#NICKNAME#</b></h4></th>
					</tr>
					<tr>
						<th><cf_get_lang dictionary_id="63908.Receiving Service"></th>
						<th width="150"><cf_get_lang dictionary_id="57467.Not"></th>
						<th width="75"><cf_get_lang dictionary_id="58084.Fiyat"></th>
						<th width="75"><cf_get_lang dictionary_id="57635.Miktar"></th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="get_rec_rates">
						<tr>
							<td>#get_rec_rates.WAREHOUSE_TASK_TYPE#</td>
							<td width="150">#get_rec_rates.RATE_INFO#</td>
							<td width="75">#get_rec_rates.PRICE#</td>
							<td width="75">#get_rec_rates.ROW_AMOUNT#</td>
						</tr>
					</cfloop>
				</tbody>
				</cf_ajax_list>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
				<cf_ajax_list>
				<thead>
					<tr>
						<th colspan="4"><h4><b>#NICKNAME#</b></h4></th>
					</tr>
					<tr>
						<th><cf_get_lang dictionary_id="63909.Shipment Service"></th>
						<th width="150"><cf_get_lang dictionary_id="57467.Not"></th>
						<th width="75"><cf_get_lang dictionary_id="58084.Fiyat"></th>
						<th width="75"><cf_get_lang dictionary_id="57635.Miktar"></th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="get_ship_rates">
						<tr>
							<td>#get_ship_rates.WAREHOUSE_TASK_TYPE#</td>
							<td width="150">#get_ship_rates.RATE_INFO#</td>
							<td width="75">#get_ship_rates.PRICE#</td>
							<td width="75">#get_ship_rates.ROW_AMOUNT#</td>
						</tr>
					</cfloop>
				</tbody>
				</cf_ajax_list>
			</div>
		</div>
	</cfoutput>	
</cf_box>
</cfif>