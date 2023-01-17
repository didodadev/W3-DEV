<cfsetting showdebugoutput="no">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.request_type_id" default="">
<cfparam name="attributes.status" default="">
<cfif len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfif len(attributes.is_submitted)>
	<cfquery name="GET_REQUESTS" datasource="#DSN#">
		SELECT
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID,
			ASSET_P_REQUEST_ROWS.EMPLOYEE_ID,
			ASSET_P_REQUEST.REQUEST_ID,
			ASSET_P_REQUEST.REQUEST_TYPE_ID,
			ASSET_P_REQUEST.REQUEST_DATE,
			ASSET_P_REQUEST_ROWS.BRAND_TYPE_ID,
			ASSET_P_REQUEST_ROWS.REQUEST_STATE,
			ASSET_P_REQUEST_ROWS.UPDATE_EMP,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			BRANCH.BRANCH_NAME,
			PROCESS_TYPE_ROWS.STAGE
		FROM
			ASSET_P_REQUEST,
			ASSET_P_REQUEST_ROWS,
			EMPLOYEES,
			BRANCH,
			PROCESS_TYPE_ROWS
		WHERE
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID IS NOT NULL
			<!--- Sadece yetkili olunan şubeler gözüksün. --->
			AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
			<cfif len(attributes.branch)>AND BRANCH.BRANCH_ID= #attributes.branch_id#</cfif>
			<cfif len(attributes.request_type_id)>AND ASSET_P_REQUEST.REQUEST_TYPE_ID = #attributes.request_type_id#</cfif>
			<cfif len(attributes.start_date)>AND ASSET_P_REQUEST.REQUEST_DATE >= #attributes.start_date#</cfif>
			<cfif len(attributes.finish_date)>AND ASSET_P_REQUEST.REQUEST_DATE <= #attributes.finish_date#</cfif>
			<cfif len(attributes.status)>AND ASSET_P_REQUEST_ROWS.REQUEST_STATE = #attributes.status#</cfif>
			AND ASSET_P_REQUEST.BRANCH_ID = BRANCH.BRANCH_ID
			AND ASSET_P_REQUEST.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
			AND ASSET_P_REQUEST.REQUEST_ID = ASSET_P_REQUEST_ROWS.REQUEST_ID
			AND PROCESS_TYPE_ROWS.PROCESS_ROW_ID = ASSET_P_REQUEST_ROWS.REQUEST_STATE
		ORDER BY 
			ASSET_P_REQUEST.REQUEST_ID DESC,
			ASSET_P_REQUEST_ROWS.REQUEST_ROW_ID DESC
	</cfquery>	
<cfelse>
	<cfset get_requests.recordcount = 0>
</cfif> 
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_requests.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_grid_list>
	<thead>
        <tr>
            <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
            <th><cf_get_lang dictionary_id='48035.Talep No'></th>
            <th><cf_get_lang dictionary_id='57453.Şube'></th>
            <th><cf_get_lang dictionary_id='47953.Talep Eden'></th>
            <th><cf_get_lang dictionary_id='47972.Talep Tipi'></th>
            <th><cf_get_lang dictionary_id='47994.Talep Tarihi'></th>
            <th><cf_get_lang dictionary_id='58859.Aşama'></th>
            <th><cf_get_lang dictionary_id='57891.Güncelleyen'></th>
            <th><cf_get_lang dictionary_id='58847.Marka'> /<cf_get_lang dictionary_id='30041.Marka Tipi'></th>
            <!-- sil --><th width="20" class="header_icn_none text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th><!-- sil -->
        </tr>
    </thead>
	<tbody>
		<cfif get_requests.recordCount>
			<cfset update_ip_list = "">
			<cfset brand_type_id_list = ""> 
			<cfoutput query="get_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(update_emp) and not ListFind(update_ip_list,update_emp,',')>
						<cfset update_ip_list = ListAppend(update_ip_list,update_emp,',')>
					</cfif>
					<cfif len(brand_type_id) and not ListFind(brand_type_id_list,brand_type_id,',')>
						<cfset brand_type_id_list = ListAppend(brand_type_id_list,brand_type_id,',')>
					</cfif>
			</cfoutput>
			<cfif ListLen(update_ip_list)>
				<cfquery name="GET_UPDATERS" datasource="#DSN#">
					SELECT EMPLOYEE_ID,EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#update_ip_list#)
				</cfquery>
			</cfif>
			<cfif ListLen(brand_type_id_list)>
				<cfquery name="GET_BRAND_TYPE" datasource="#DSN#">
					SELECT 
						SETUP_BRAND_TYPE.BRAND_TYPE_ID,
						SETUP_BRAND_TYPE.BRAND_TYPE_NAME,
						SETUP_BRAND.BRAND_ID,
						SETUP_BRAND.BRAND_NAME
					FROM
						SETUP_BRAND,
						SETUP_BRAND_TYPE
					WHERE 
						SETUP_BRAND_TYPE.BRAND_ID = SETUP_BRAND.BRAND_ID AND
						SETUP_BRAND_TYPE.BRAND_TYPE_ID IN (#brand_type_id_list#)
				</cfquery>
			</cfif>
			<cfoutput query="get_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td>#request_id#</td>
					<td>#branch_name#</td>
					<td>#employee_name# #employee_surname#</td>
					<td>
						<cfswitch expression="#request_type_id#">
							<cfcase value="1"><cf_get_lang dictionary_id='58176.Alış Talebi'></cfcase>
							<cfcase value="0"><cf_get_lang dictionary_id='57448.Satış Talebi'></cfcase>
							<cfcase value="2"><cf_get_lang dictionary_id='29418.İade Talebi'></cfcase>
							<cfcase value="3"><cf_get_lang dictionary_id='48011.Değiştirme Talebi'></cfcase>
						</cfswitch>
					</td>
					<td>#dateFormat(request_date,dateformat_style)#</td>
					<td>#stage#</td>
					<td><cfif len(update_emp)>
							<cfquery name="GET_UPDATER" dbtype="query">
								SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM get_updaters WHERE EMPLOYEE_ID = #UPDATE_EMP#
							</cfquery>
							<a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#update_emp#','medium','popup_emp_det');">#get_updater.employee_name# #get_updater.employee_surname#</a>
						</cfif>
					</td>
					<td>
					<cfif len(brand_type_id)>
						<cfquery name="GET_BRAND" dbtype="query">
							SELECT BRAND_NAME, BRAND_TYPE_NAME FROM get_brand_type WHERE BRAND_TYPE_ID = #brand_type_id#   
						</cfquery>
						#get_brand.brand_name# - #get_brand.brand_type_name#
					</cfif>
					</td>
					<!-- sil -->
					<td>
						<cfswitch expression="#request_type_id#">
							<cfcase value="1"><a href="javascript://" onClick="window.parent.location.href='#request.self#?fuseaction=assetcare.upd_vehicle_purchase_request&request_id=#request_id#&request_row_id=#request_row_id#';"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></cfcase>
							<cfcase value="0"><a href="javascript://" onClick="window.parent.location.href='#request.self#?fuseaction=assetcare.upd_vehicle_sales_request&request_id=#request_id#&request_row_id=#request_row_id#';"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></cfcase>
							<cfcase value="2"><a href="javascript://" onClick="window.parent.location.href='#request.self#?fuseaction=assetcare.upd_vehicle_return_request&request_id=#request_id#&request_row_id=#request_row_id#';"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></cfcase>
							<cfcase value="3"><a href="javascript://" onClick="window.parent.location.href='#request.self#?fuseaction=assetcare.upd_vehicle_exchange_request&request_id=#request_id#&request_row_id=#request_row_id#';"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></cfcase>
						</cfswitch>
					</td>
					<!-- sil -->			   
				</tr>
			</cfoutput>
		<cfelse>
			<tr class="color-row">
				<td colspan="11" height="20"><cfif len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
			</tr>
		</cfif>
    </tbody>
</cf_grid_list>
<cfif len(attributes.is_submitted) and attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif len(attributes.is_submitted)>
	  	<cfset url_str = "#url_str#&is_submitted=1">
	</cfif>
	<cfif isdefined("attributes.branch_id")>
	  	<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("attributes.branch")>
	  	<cfset url_str = "#url_str#&branch=#attributes.branch#">
	</cfif>
	<cfif isdefined("attributes.request_type_id")>
	  	<cfset url_str = "#url_str#&request_type_id=#attributes.request_type_id#">
	</cfif>
	<cfif isdefined("attributes.status")>
	  	<cfset url_str = "#url_str#&status=#attributes.status#">
	</cfif>
	<cfif isdefined("attributes.start_date")>
	  	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date)#">
	</cfif>
	<cfif isdefined("attributes.finish_date")>
	  	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date)#">
	</cfif>	
	<!-- sil -->
	<cf_paging 
		page="#attributes.page#"
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="assetcare.popup_list_vehicle_request_search#url_str#"></td>
  	<!-- sil -->
</cfif>
