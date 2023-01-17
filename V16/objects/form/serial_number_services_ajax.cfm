<cfquery name="get_service" datasource="#dsn3#">
	SELECT
		SERVICE.SERVICE_EMPLOYEE_ID,
		SERVICE.SERVICE_CONSUMER_ID,
		SERVICE.SERVICE_PARTNER_ID,
		SERVICE.APPLY_DATE,		
		SERVICE.SERVICE_ID,
		SERVICE.SERVICE_HEAD,
		SERVICE.PRODUCT_NAME,
		SERVICE_APPCAT.SERVICECAT,
		SP.PRIORITY,
		SP.COLOR,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		SERVICE,
		SERVICE_APPCAT,
		#dsn_alias#.SETUP_PRIORITY AS SP,
		#dsn_alias#.PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS
	WHERE 		
		<cfif isDefined("attributes.seri_stock_id") and Len(attributes.seri_stock_id)>
			(STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.seri_stock_id#"> OR STOCK_ID IS NULL) AND
		</cfif>
		SERVICE.SERVICECAT_ID = SERVICE_APPCAT.SERVICECAT_ID AND
		SP.PRIORITY_ID = SERVICE.PRIORITY_ID AND
		SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
		(PRO_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#"> OR MAIN_SERIAL_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.product_serial_no#">)
	ORDER BY
		SERVICE.RECORD_DATE DESC
</cfquery>
<cf_ajax_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='57742.Tarih'></th>
            <th><cf_get_lang dictionary_id='57482.Aşama'></th>
            <th><cf_get_lang dictionary_id='57480.Konu'></th>
            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
            <th><cf_get_lang dictionary_id='57486.Kategori'></th>
            <th><cf_get_lang dictionary_id='33773.Başvuru Sahibi'></th>
        </tr>
    </thead>
    <tbody>
    <cfif get_service.recordcount>
        <cfparam name="attributes.page" default=1>
        <cfif isDefined('session.ep.userid')>
            <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfelseif isDefined('session.pp.userid')>
            <cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
        </cfif>
        <cfparam name="attributes.totalrecords" default="#get_service.recordcount#">
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        <cfoutput query="get_service" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        <tr>
            <cfif len(APPLY_DATE)>
              <cfset h=datepart("h",APPLY_DATE)>
            </cfif>
            <td><cfif len(APPLY_DATE)>
                    #dateformat(APPLY_DATE,dateformat_style)# #h#:00
                </cfif>
            </td>
            <td>#STAGE#</td>
            <td><a href="#request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service.service_id#" class="tableyazi">#service_HEAD# </a> </td>
            <td>#PRODUCT_NAME#</td>
            <td> #serviceCAT# </td>
            <td><cfif len(get_service.SERVICE_PARTNER_ID[currentrow]) and (get_service.SERVICE_PARTNER_ID[currentrow] NEQ 0)>
                    <cfset attributes.partner_id=get_service.SERVICE_PARTNER_ID>
                    <cfinclude template="../query/get_partner_detail.cfm">
                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_partner_detail.PARTNER_ID#','medium');" class="tableyazi">#get_partner_detail.COMPANY_PARTNER_NAME# #get_partner_detail.COMPANY_PARTNER_SURNAME#</a>
                </cfif>
                <cfif len(get_service.SERVICE_CONSUMER_ID[currentrow]) and  get_service.SERVICE_CONSUMER_ID[currentrow] NEQ 0>
                    <cfset attributes.consumer_id=get_service.SERVICE_CONSUMER_ID>
                    <cfinclude template="../query/get_consumer_detail.cfm">
                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_consumer_detail.CONSUMER_ID#','medium');" class="tableyazi">#get_consumer_detail.CONSUMER_NAME# #get_consumer_detail.CONSUMER_SURNAME#-#get_consumer_detail.COMPANY#</a>
                </cfif>
                <cfif len(get_service.SERVICE_EMPLOYEE_ID[currentrow]) and (get_service.SERVICE_EMPLOYEE_ID[currentrow] NEQ 0)>
                    <cfset emp_id=get_service.SERVICE_EMPLOYEE_ID>
                    <cfinclude template="../query/get_service_pos.cfm">
                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#emp_id#','medium');" class="tableyazi">#get_Service_pos.EMPLOYEE_NAME# #get_service_pos.EMPLOYEE_SURNAME#</a>
                </cfif>
            </td>
            <cfset COL=COLOR>
        </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
  </cfif>
  </tbody>
</cf_ajax_list>
