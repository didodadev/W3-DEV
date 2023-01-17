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
<cfform action="index.cfm?fuseaction=stock.list_warehouse_tasks&event=monthly_report" method="post" name="service_form" lang="en">
<cfinput type="hidden" name="is_submit" value="1">	

<cf_box_search plus="0">
                <div class="form-group"><cfoutput><cf_get_lang dictionary_id="57742.Tarih"></cfoutput></div>
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
			WT.PROJECT_ID,
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
	
	<cfquery name="get_companies" datasource="#dsn3#">
		SELECT DISTINCT
			SUM(CASE WHEN WT.IS_ACTIVE = 1 THEN 1 ELSE 0 END) AS ALL_SERVICE,
			SUM(CASE WHEN WT.WAREHOUSE_IN_OUT = 1 AND WT.IS_ACTIVE = 1 THEN 1 ELSE 0 END) AS SHIP_SERVICE,
			SUM(CASE WHEN WT.WAREHOUSE_IN_OUT = 0 AND WT.IS_ACTIVE = 1 THEN 1 ELSE 0 END) AS REC_SERVICE,
			SUM(CASE WHEN WT.WAREHOUSE_IN_OUT = 2 AND WT.IS_ACTIVE = 1 THEN 1 ELSE 0 END) AS COUNT_SERVICE,
			WT.COMPANY_ID,
			WT.PROJECT_ID,
			C.NICKNAME,
			PP.PROJECT_HEAD
		FROM
			WAREHOUSE_TASKS WT
				LEFT JOIN  #dsn_alias#.PRO_PROJECTS PP ON WT.PROJECT_ID=PP.PROJECT_ID
				LEFT JOIN  #dsn_alias#.COMPANY C ON WT.COMPANY_ID=C.COMPANY_ID
		WHERE 
			WT.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
			WT.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"> AND
			WT.WAREHOUSE_IN_OUT NOT IN (3)
		GROUP BY
			WT.COMPANY_ID,
			WT.PROJECT_ID,
			C.NICKNAME,
			PP.PROJECT_HEAD
		ORDER BY
			C.NICKNAME,
			PP.PROJECT_HEAD
	</cfquery>

	<cfquery name="get_companies_tra" datasource="#dsn3#">
		SELECT DISTINCT
			SUM(1) AS ALL_SERVICE,
			WT.COMPANY_ID,
			WT.PROJECT_ID,
			C.NICKNAME,
			PP.PROJECT_HEAD
		FROM
			WAREHOUSE_TASKS_LOCATION_MANAGEMENT WT
				LEFT JOIN  #dsn_alias#.PRO_PROJECTS PP ON WT.PROJECT_ID=PP.PROJECT_ID
				LEFT JOIN  #dsn_alias#.COMPANY C ON WT.COMPANY_ID=C.COMPANY_ID
		WHERE 
			WT.ACTION_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND
			WT.ACTION_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
		GROUP BY
			WT.COMPANY_ID,
			WT.PROJECT_ID,
			C.NICKNAME,
			PP.PROJECT_HEAD
		ORDER BY
			C.NICKNAME,
			PP.PROJECT_HEAD
	</cfquery>
	
	<cfquery name="get_cancel_all" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE = 0
	</cfquery>
	<cfquery name="get_cancel_rec" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE = 0 AND WAREHOUSE_IN_OUT = 0
	</cfquery>
	<cfquery name="get_cancel_ship" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE = 0 AND WAREHOUSE_IN_OUT = 1
	</cfquery>
	<cfquery name="get_cancel_counting" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE = 0 AND WAREHOUSE_IN_OUT = 2
	</cfquery>
	
	<cfquery name="get_process_all" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE = -1
	</cfquery>
	<cfquery name="get_process_rec" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE = -1 AND WAREHOUSE_IN_OUT = 0
	</cfquery>
	<cfquery name="get_process_ship" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE = -1 AND WAREHOUSE_IN_OUT = 1
	</cfquery>
	<cfquery name="get_process_counting" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE = -1 AND WAREHOUSE_IN_OUT = 2
	</cfquery>
	
	<cfquery name="get_active_all" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE >0 
	</cfquery>
	<cfquery name="get_active_rec" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE = 1 AND WAREHOUSE_IN_OUT = 0
	</cfquery>
	<cfquery name="get_active_ship" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE = 1 AND WAREHOUSE_IN_OUT = 1
	</cfquery>
	<cfquery name="get_active_counting" dbtype="query">
		SELECT * FROM get_all_services WHERE IS_ACTIVE = 1 AND WAREHOUSE_IN_OUT = 2
	</cfquery>
	<cf_box  title="#getlang('','3PL Depo Faaliyet Özeti','64004')#">
	<div class="row myhomeBox">	
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat2">
				<div class="display">
					<div class="number">
						<h4 class="font-green-haze"> 
							<span data-counter="counterup" class="bold"><cfoutput>#TLFormat(get_active_all.recordcount,0)#&nbsp;</cfoutput></span>
							<small class="font-red-haze"></small>
						</h4>
						<small><cf_get_lang dictionary_id="57708.Tümü"></small>
					</div>
					<div class="icon">
						<i class="icon-archive"></i>
					</div>
				</div>
				<div class="progress-info">
					<div class="progress">
						<span style="width: 100%;" class="progress-bar progress-bar-success red-haze">
						</span>
					</div>
					<div class="status">
						<div class="status-title" style="color:red;font-size:11px;"><cfoutput><cf_get_lang dictionary_id="59190.İptal Edildi"> : #get_cancel_all.recordcount#</cfoutput></div>
						<div class="status-number" style="font-size:11px;">
						<b style="color:blue;font-size:11px;"><cf_get_lang dictionary_id="57704.Processing"> : <cfoutput>#TLFormat(get_process_all.recordcount,0)#</cfoutput></b>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<cf_get_lang dictionary_id="57708.Tümü"> : <cfoutput>#TLFormat(get_all_services.recordcount,0)#</cfoutput>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat2">
				<div class="display">
					<div class="number">
						<h4 class="font-blue-sharp"> 
							<span data-counter="counterup" class="bold"><cfoutput>#get_active_ship.recordcount#</cfoutput></span>
							<small class="font-blue-sharp"></small>
						</h4>
						<small><cf_get_lang dictionary_id="63876.Shipment"></small>
					</div>
					<div class="icon">
						<i class="icon-industry"></i>
					</div>
				</div>
				<div class="progress-info">
					<div class="progress">
						<span style="width: 100%;" class="progress-bar progress-bar-success blue-sharp">
						</span>
					</div>
					<div class="status">
						<div class="status-title" style="color:red;font-size:11px;"><cfoutput><cf_get_lang dictionary_id="59190.İptal Edildi"> : #get_cancel_ship.recordcount#</cfoutput></div>
						<div class="status-number" style="font-size:11px;">
						<b style="color:blue;font-size:11px;"><cf_get_lang dictionary_id="57704.Processing"> : <cfoutput>#TLFormat(get_process_ship.recordcount,0)#</cfoutput></b>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<cfoutput><cf_get_lang dictionary_id="63911.Total Shipment"> : #TLFormat(get_active_ship.recordcount + get_cancel_ship.recordcount + get_process_ship.recordcount,0)#</cfoutput>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat2">
				<div class="display">
					<div class="number">
						<h4 class="font-purple-soft"> 
							<span data-counter="counterup" class="bold"><cfoutput>#get_active_rec.recordcount#</cfoutput></span>
							<small class="font-purple-soft"></small>
						</h4>
						<small><cf_get_lang dictionary_id="63877.Receiving"></small>
					</div>
					<div class="icon">
						<i class="icon-cogs"></i>
					</div>
				</div>
				<div class="progress-info">
					<div class="progress">
						<span style="width: 100%;" class="progress-bar progress-bar-success purple-soft">
						</span>
					</div>
					<div class="status">
						<div class="status-title" style="color:red;font-size:11px;"><cfoutput><cf_get_lang dictionary_id="59190.İptal Edildi"> : #get_cancel_rec.recordcount#</cfoutput></div>
						<div class="status-number" style="font-size:11px;">
						<b style="color:blue;font-size:11px;"><cf_get_lang dictionary_id="57704.Processing"> : <cfoutput>#TLFormat(get_process_rec.recordcount,0)#</cfoutput></b>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<cfoutput><cf_get_lang dictionary_id="63913.Total Receiving"> : #TLFormat(get_active_rec.recordcount + get_cancel_rec.recordcount + get_process_rec.recordcount,0)#</cfoutput>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col col-3 col-md-3 col-sm-6 col-xs-12">
			<div class="dashboard-stat2">
				<div class="display">
					<div class="number">
						<h4 class="font-green-sharp"> 
							<span data-counter="counterup" class="bold"><cfoutput>#get_active_counting.recordcount#</cfoutput></span>
							<small class="font-green-sharp"></small>
						</h4>
						<small><cf_get_lang dictionary_id="63875.Sayım"></small>
					</div>
					<div class="icon">
						<i class="icon-branch"></i>
					</div>
				</div>
				<div class="progress-info">
					<div class="progress">
						<span style="width: 100%;" class="progress-bar progress-bar-success green-sharp">
						</span>
					</div>
					<div class="status">
						<div class="status-title"  style="color:red;font-size:11px;"><cfoutput><cf_get_lang dictionary_id="59190.İptal Edildi"> : #get_cancel_counting.recordcount#</cfoutput></div>
                            &nbsp;&nbsp;<div class="status-number" style="font-size:11px;">
						<b style="color:blue;font-size:11px;"><cf_get_lang dictionary_id="57704.Processing"> : <cfoutput>#TLFormat(get_process_counting.recordcount,0)#</cfoutput></b>
						&nbsp;&nbsp;
						<cfoutput><cf_get_lang dictionary_id="63914.Total Counting "> : #TLFormat(get_active_counting.recordcount + get_cancel_counting.recordcount + get_process_counting.recordcount,0)#</cfoutput>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row myhomeBox">	
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<h4><b><cf_get_lang dictionary_id="63915.Müşteri Bazlı Servisler"> </b></h4>
			<br>
			<cf_ajax_list>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id="57457.Müşteri"></th>
						<th><cf_get_lang dictionary_id="57416.Proje"></th>
						<th><cf_get_lang dictionary_id="63876.Shipment"></th>
						<th><cf_get_lang dictionary_id="63877.Receiving"></th>
						<th><cf_get_lang dictionary_id="63875.Sayım"></th>
						<th><cf_get_lang dictionary_id="57492.Toplam"></th>
					</tr>
				</thead>
				<tbody>
				<cfset ship_total = 0>
				<cfset rec_total = 0>
				<cfset count_total = 0>
				<cfset grand_total = 0>
				<cfoutput query="get_companies">
					<tr>
						<td>#nickname#</td>
						<td>#project_head#</td>
						<td>#SHIP_SERVICE#</td>
						<td>#REC_SERVICE#</td>
						<td>#COUNT_SERVICE#</td>
						<td>#ALL_SERVICE#</td>
					</tr>
					<cfset ship_total = ship_total + SHIP_SERVICE>
					<cfset rec_total = rec_total + REC_SERVICE>
					<cfset count_total = count_total + COUNT_SERVICE>
					<cfset grand_total = grand_total + ALL_SERVICE>
				</cfoutput>
				</tbody>
				<tfoot>
					<cfoutput>
					<tr>
						<td><cf_get_lang dictionary_id="57492.Toplam"></td>
						<td></td>
						<td>#ship_total#</td>
						<td>#rec_total#</td>
						<td>#count_total#</td>
						<td>#grand_total#</td>
					</tr>
					</cfoutput>
				</tfoot>
			</cf_ajax_list>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<h4><b><cf_get_lang dictionary_id="63916.Müşteri Bazlı İşlemler"></b></h4>
			<br>
			<cf_ajax_list>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id="57457.Müşteri"></th>
						<th><cf_get_lang dictionary_id="57416.Proje"></th>
						<th><cf_get_lang dictionary_id="57492.Toplam"></th>
					</tr>
				</thead>
				<tbody>
				<cfset ship_total = 0>
				<cfset rec_total = 0>
				<cfset grand_total = 0>
				<cfoutput query="get_companies_tra">
					<tr>
						<td>#nickname#</td>
						<td>#project_head#</td>
						<td><a href="#request.self#?fuseaction=stock.location_management&company_id=#COMPANY_ID#&form_submitted=1&company=#nickname#&start_date=#attributes.start_date#&finish_date=#attributes.finish_date#" class="formbold" target="service_list">#ALL_SERVICE#</a></td>
					</tr>
					<cfset grand_total = grand_total + ALL_SERVICE>
				</cfoutput>
				</tbody>
				<tfoot>
					<cfoutput>
					<tr>
						<td><cf_get_lang dictionary_id="57492.Toplam"></td>
						<td></td>
						<td>#grand_total#</td>
					</tr>
					</cfoutput>
				</tfoot>
			</cf_ajax_list>
		</div>
	</div>
	<div class="row myhomeBox">	
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfchart format="flash" show3d="yes" chartwidth="600" chartheight="500">
				<cfchartseries 
					type="pie" 
					serieslabel="Customer Base All Services"
					>
					<cfoutput query="get_companies">
						<cfchartdata item="#nickname# - #project_head#" value="#ALL_SERVICE#">
					</cfoutput>
				</cfchartseries>
			</cfchart>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
			<cfchart format="flash" show3d="yes" chartwidth="600" chartheight="500">
				<cfchartseries 
					type="pie" 
					serieslabel="Customer Base Transactions"
					>
					<cfoutput query="get_companies_tra">
						<cfchartdata item="#nickname# - #project_head#" value="#ALL_SERVICE#">
					</cfoutput>
				</cfchartseries>
			</cfchart>
		</div>
	</div>
</cf_box>
</cfif>