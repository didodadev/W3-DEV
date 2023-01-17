<cf_xml_page_edit fuseact="stock.popup_add_packetship">
<!--- 
	BK 20060418
	Bu sayfada ki is_logistic emirler listesinden gelen parametre olup, is_logistic2 parametresi satis irsaliyesi guncelleme sayfasından gelen parametredir.
 --->
 <cfset xml_all_depo = iif(isdefined("xml_location_auth"),xml_location_auth,DE('-1'))>
<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="../query/get_moneys.cfm">
<cfinclude template="../query/get_package_type.cfm">
<cfinclude template="../query/get_country.cfm">
<!---<cfinclude template="../query/get_money.cfm">--->
<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
	<cfquery name="GET_ORDER" datasource="#DSN3#">
        SELECT 
            ORDERS.ORDER_NUMBER,
            ORDERS.ORDER_DATE,
            ORDERS.SHIP_METHOD,
            ORDERS.SHIP_ADDRESS,
            ORDERS.COMPANY_ID,
            ORDERS.PARTNER_ID,
            ORDERS.CONSUMER_ID,
            COMPANY_CREDIT.SHIP_METHOD_ID SHIP_METHOD_ID,
            COMPANY_CREDIT.TRANSPORT_COMP_ID TRANSPORT_COMP_ID,
            COMPANY_CREDIT.TRANSPORT_DELIVER_ID TRANSPORT_DELIVER_ID
        FROM
            ORDERS
                LEFT JOIN #dsn_alias#.COMPANY_CREDIT COMPANY_CREDIT ON ORDERS.COMPANY_ID = COMPANY_CREDIT.COMPANY_ID AND COMPANY_CREDIT.OUR_COMPANY_ID = #session.ep.company_id#
        WHERE
            ORDERS.ORDER_ID = #attributes.order_id#
    </cfquery>
    <cfif len(get_order.ship_method) or len(get_order.ship_method_id)>
        <cfquery name="GET_SHIP_METHOD" datasource="#DSN#">
            SELECT SHIP_METHOD,SHIP_METHOD_ID FROM SHIP_METHOD WHERE SHIP_METHOD_ID =<cfif len(get_order.ship_method)>#get_order.ship_method#<cfelse>#get_order.SHIP_METHOD_ID#</cfif> 
        </cfquery>
    </cfif>
</cfif>
<cfif isdefined("attributes.is_logistic") and len(attributes.is_logistic)>
	<cfquery name="get_ship_id" datasource="#dsn3#">
		SELECT SHIP_ID FROM ORDERS_SHIP WHERE ORDER_ID IN (#attributes.is_logistic#)
	</cfquery>
	<cfquery name="ADD_LOGISTIC" datasource="#DSN2#">
		SELECT
			LOCATION,
			COMPANY_ID,
			PARTNER_ID,
			CONSUMER_ID,
			SHIP_ID,
			SHIP_NUMBER,
			SHIP_DATE,
			SHIP_METHOD,
			ADDRESS,
			ORDER_ID,
			DELIVER_STORE_ID,
			IS_DISPATCH,
			(SELECT DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = DELIVER_STORE_ID) DEPARTMENT_HEAD
		FROM 
			SHIP
		WHERE
			<cfif get_ship_id.recordcount>
				SHIP_ID IN (#valuelist(get_ship_id.ship_id)#)
			<cfelse>
				1 = 0
			</cfif>
	</cfquery>
	<cfquery name="ADD_LOGISTIC_MAIN" dbtype="query" maxrows="1">
		SELECT * FROM ADD_LOGISTIC ORDER BY SHIP_ID
	</cfquery>
	<cfif len(add_logistic_main.company_id)>
		<cfquery name="GET_COMPANY_SEVK" datasource="#DSN#">
			SELECT 
				TRANSPORT_COMP_ID,
				TRANSPORT_DELIVER_ID
			FROM 
				COMPANY_CREDIT 
			WHERE 
				COMPANY_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#add_logistic_main.company_id#"> AND 
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
	</cfif>
	<cfquery name="GET_TRANSPORT_INFO" datasource="#DSN3#">
		SELECT 
			LOCATION_ID,
			DELIVER_DEPT_ID,
			(SELECT DEPARTMENT_HEAD FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = DELIVER_DEPT_ID) AS DEPARTMENT_HEAD,
			(SELECT BRANCH_ID FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = DELIVER_DEPT_ID) AS BRANCH_ID,
			SHIP_METHOD AS SHIP_METHOD_ID,
			(SELECT SHIP_METHOD FROM #dsn_alias#.SHIP_METHOD WHERE SHIP_METHOD_ID = ORDERS.SHIP_METHOD) AS SHIP_METHOD
		FROM
			ORDERS
		WHERE 
			ORDER_ID IN (#attributes.is_logistic#)
	</cfquery>
	<cfif get_transport_info.recordcount>
		<cfset attributes.branch_id = get_transport_info.branch_id>	
		<cfif len(add_logistic.deliver_store_id)>
			<cfset attributes.department_id = add_logistic.deliver_store_id>
		<cfelse>
			<cfset attributes.department_id = get_transport_info.deliver_dept_id>
		</cfif>
		<cfif len(add_logistic.location)>
			<cfset attributes.location_id = add_logistic.location>
		<cfelse>
			<cfset attributes.location_id = get_transport_info.location_id>
		</cfif>
		<cfset attributes.ship_method_id = get_transport_info.ship_method_id>
		<cfset attributes.ship_method_name = get_transport_info.ship_method>
		<cfif len(add_logistic.deliver_store_id)>
			<cfset attributes.department_name = add_logistic.department_head>
		<cfelse>
			<cfset attributes.department_name = get_transport_info.department_head>
		</cfif>
		<cfif isdefined('attributes.location_id') and len(attributes.location_id) and isdefined('attributes.department_id')and len(attributes.department_id)>
			<cfquery name="get_location" datasource="#DSN#">
				SELECT COMMENT FROM STOCKS_LOCATION WHERE STATUS = 1 AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#"> AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
			</cfquery>
			<cfset attributes.department_name = '#attributes.department_name#-#get_location.comment#'>	
		</cfif>
	</cfif> 
	<cfif isdefined('get_company_sevk') and  get_company_sevk.recordcount>
		<cfset attributes.transport_comp_id = get_company_sevk.transport_comp_id>
		<cfset attributes.transport_deliver_id = get_company_sevk.transport_deliver_id>
	</cfif>
	<cfif len(add_logistic_main.partner_id) and len(add_logistic_main.company_id)>
		<cfset attributes.company = get_par_info(add_logistic_main.partner_id,0,1,0)>
		<cfset attributes.member_name = get_par_info(add_logistic_main.partner_id,0,2,0)>
		<cfset attributes.company_id = add_logistic_main.company_id>
		<cfset attributes.partner_id = add_logistic_main.partner_id>
	<cfelseif len(add_logistic_main.company_id)>
		<cfset attributes.company = get_par_info(add_logistic_main.company_id,1,1,0)>
		<cfset attributes.company_id = add_logistic_main.company_id>
		<cfelseif len(add_logistic_main.consumer_id)>
		<cfset attributes.member_name = get_cons_info(add_logistic_main.consumer_id,0,0)>
		<cfset attributes.consumer_id = add_logistic_main.consumer_id>
	</cfif>
	<cfset company_list=''>
	<cfset consumer_list=''>
	<cfoutput query="add_logistic">
		<cfif len(company_id) and not listfind(company_list,company_id)>
			<cfset company_list = Listappend(company_list,company_id)>
		</cfif>
			<cfif len(consumer_id) and not listfind(consumer_list,consumer_id)>
			<cfset consumer_list = Listappend(consumer_list,consumer_id)>
		</cfif>
	</cfoutput>
	<cfif len(company_list)>
		<cfset company_list=listsort(company_list,"numeric","ASC",",")>			
		<cfquery name="GET_COMPANY" datasource="#DSN#">
			SELECT COMPANY_ID, NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_list#) ORDER BY COMPANY_ID
		</cfquery>
		<cfset main_company_list = listsort(listdeleteduplicates(valuelist(get_company.company_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(consumer_list)>
			<cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>			
		<cfquery name="GET_CONSUMER" datasource="#DSN#">
				SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
		</cfquery>
		<cfset main_consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfquery name="GET_CONTROL_" dbtype="query">
		SELECT SHIP_NUMBER FROM ADD_LOGISTIC WHERE IS_DISPATCH = 1
	</cfquery>
</cfif>
<cfif isdefined("city_id") and len(city_id)>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_ID, CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#city_id#">
	</cfquery>
	
</cfif>
<cfif isdefined("county_id") and len(county_id)>
	<cfquery name="GET_COUNTY" datasource="#DSN#">
		SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#county_id#">
	</cfquery>
	
</cfif>
<cfif isdefined("attributes.is_logistic2")>
	<cfif not len(attributes.consumer_id)>
		<!--- Kurumsal uyeler icin --->
		<cfquery name="ADD_LOGISTIC2" datasource="#DSN2#">
			SELECT
				C.NICKNAME MEMBER_NAME,
				S.SHIP_ID,
				S.SHIP_NUMBER,
				S.SHIP_DATE,
				S.SHIP_METHOD,
				S.ADDRESS,
				S.COMPANY_ID,
				S.SHIP_METHOD SHIP_METHOD_ID,
				S.SHIP_NUMBER,
					S.IS_DISPATCH,
				(SELECT SHIP_METHOD FROM #dsn_alias#.SHIP_METHOD WHERE SHIP_METHOD_ID = S.SHIP_METHOD) SHIP_METHOD
			FROM 
				SHIP S
				LEFT OUTER JOIN #dsn_alias#.COMPANY C ON S.COMPANY_ID = C.COMPANY_ID
			WHERE
				S.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_logistic2#">
			ORDER BY
				S.SHIP_ID
		</cfquery>
		<!--- Tasiyici firmaya ulasmak icin --->
		<cfquery name="GET_TRANSPORT" datasource="#DSN#">
			SELECT 
				TRANSPORT_COMP_ID,
				TRANSPORT_DELIVER_ID
			FROM
				COMPANY_CREDIT 
			WHERE
				COMPANY_CREDIT.COMPANY_ID = #len(add_logistic2.company_id)?add_logistic2.company_id:0# AND
				COMPANY_CREDIT.OUR_COMPANY_ID = #session.ep.company_id# AND
				TRANSPORT_COMP_ID IS NOT NULL AND
				TRANSPORT_DELIVER_ID IS NOT NULL
		</cfquery>
		<cfif get_transport.recordcount> 
			<cfset attributes.transport_comp_id = get_transport.transport_comp_id>
			<cfset attributes.transport_deliver_id = get_transport.transport_deliver_id>		
		</cfif>
	<cfelse>
		<!--- Bireysel uyeler icin --->
		<cfquery name="ADD_LOGISTIC2" datasource="#DSN2#">
			SELECT
				<cfif database_type is "MSSQL">
					C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME MEMBER_NAME,
				<cfelseif database_type is "DB2">
					C.CONSUMER_NAME||' '||C.CONSUMER_SURNAME MEMBER_NAME,
				</cfif>		
				S.SHIP_ID,
				S.SHIP_NUMBER,
				S.SHIP_DATE,
				S.SHIP_METHOD,
				S.SHIP_NUMBER,
				S.IS_DISPATCH,
				S.ADDRESS,
				S.CONSUMER_ID
			FROM 
				SHIP S,
				#dsn_alias#.CONSUMER C
			WHERE
				S.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_logistic2#"> AND
				C.CONSUMER_ID = S.CONSUMER_ID
			ORDER BY
				S.SHIP_ID
		</cfquery>
		<!--- Tasiyici firmaya ulasmak icin --->
		<cfquery name="GET_TRANSPORT" datasource="#DSN#">
			SELECT 
				TRANSPORT_COMP_ID,
				TRANSPORT_DELIVER_ID
			FROM
				COMPANY_CREDIT 
			WHERE
				COMPANY_CREDIT.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#add_logistic2.consumer_id#"> AND
				COMPANY_CREDIT.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
				TRANSPORT_COMP_ID IS NOT NULL AND
				TRANSPORT_DELIVER_ID IS NOT NULL
		</cfquery>
		<cfif get_transport.recordcount> 
			<cfset attributes.transport_comp_id = get_transport.transport_comp_id>
			<cfset attributes.transport_deliver_id = get_transport.transport_deliver_id>
		</cfif>		
	</cfif>
	<cfquery name="GET_CONTROL_" dbtype="query">
		SELECT SHIP_NUMBER FROM ADD_LOGISTIC2 WHERE IS_DISPATCH = 1
	</cfquery>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','','47178')#">
		<cfform name="add_packet_ship" id="add_packet_ship" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_packetship">
			<cf_papers paper_type="ship_fis" form_name="add_packet_ship" form_field="transport_no1">
			<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
				<input type="hidden" name="is_type" id="is_type" value="<cfoutput>#attributes.is_type#</cfoutput>">
				<input type="hidden" name="order_comp" id="order_comp" value="<cfoutput>#get_par_info(get_order.company_id,1,0,0)#</cfoutput>">
				<input type="hidden" name="order_cons" id="order_cons" value="<cfoutput>#get_cons_info(get_order.consumer_id,1,0,0)#</cfoutput>">
				<input type="hidden" name="order_number" id="order_number" value="<cfoutput>#get_order.order_number#</cfoutput>">
				<cfif len(get_order.ship_address)>
					<input type="hidden" name="order_adress" id="order_adress" value="<cfoutput>#get_order.ship_address#</cfoutput>">
				<cfelse>
					<input type="hidden" name="order_adress" id="order_adress" value="">
				</cfif>
				<cfif len(get_order.ship_method)>
					<input type="hidden" name="order_type" id="order_type" value="<cfoutput>#get_ship_method.ship_method#</cfoutput>">
				<cfelse>
					<input type="hidden" name="order_type" id="order_type" value="">
				</cfif>
				<input type="hidden" name="order_date" id="order_date" value="<cfoutput>#dateformat(get_order.order_date,dateformat_style)#</cfoutput>">
			</cfif>
			<cf_box_elements>
				
				<cfif isdefined("attributes.is_logistic2") and len(attributes.is_logistic2)>
					<cfinput type="hidden" name="ship_id" id="ship_id" value="#is_logistic2#">
				</cfif>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-process_cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"> *</label>
						<div class="col col-8 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'></div>
					</div>
					<div class="form-group" id="item-company">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
									<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_order.consumer_id#</cfoutput>">
									<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_order.company_id#</cfoutput>">
									<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_order.partner_id#</cfoutput>">
									<input type="text" name="company" id="company" value="<cfoutput>#get_par_info(get_order.company_id,1,0,0)#</cfoutput>" readonly>
								<cfelseif isDefined("attributes.is_sevk") and attributes.is_sevk eq "1">
									<input type="hidden" name="consumer_id" id="consumer_id" value="">
									<input type="hidden" name="company_id" id="company_id" value="">
									<input type="hidden" name="partner_id" id="partner_id" value="">
									<input type="text" name="company" id="company" value="" readonly>
								<cfelse>
									<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
									<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
									<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id")><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
									<input type="text" name="company" id="company" value="<cfif isdefined("attributes.company")><cfoutput>#attributes.company#</cfoutput></cfif>" readonly>
								</cfif>
								<cfset str_linke_ait="&field_comp_id=add_packet_ship.company_id&field_partner=add_packet_ship.partner_id&field_consumer=add_packet_ship.consumer_id&field_comp_name=add_packet_ship.company&field_name=add_packet_ship.member_name&ship_method_id=add_packet_ship.ship_method_id&ship_method_name=add_packet_ship.ship_method_name&field_trans_comp_id=add_packet_ship.transport_comp_id&field_trans_comp_name=add_packet_ship.transport_comp_name&field_trans_deliver_id=add_packet_ship.transport_deliver_id&field_trans_deliver_name=add_packet_ship.transport_deliver_name&field_long_address=add_packet_ship.sending_address">
								<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8');"></span>
								<cfelse>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput><cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=7,8');"></span>
								</cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-member_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
						<div class="col col-8 col-xs-12">
							<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
								<input type="text" name="member_name" id="member_name" value="<cfoutput>#get_par_info(get_order.partner_id,0,-1,0)#</cfoutput>" readonly>
							<cfelse>
								<input type="text" name="member_name" id="member_name" value="<cfif isdefined("attributes.member_name")><cfoutput>#attributes.member_name#</cfoutput></cfif>" readonly>
							</cfif>
						</div>
					</div>
					<div class="form-group" id="item-ship_method_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29500.Sevk Yöntemi'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined("attributes.ship_method_id")><cfoutput>#attributes.ship_method_id#</cfoutput><cfelseif isdefined('get_ship_method')><cfoutput>#get_ship_method.ship_method_id#</cfoutput></cfif>">
								<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined("attributes.ship_method_name")><cfoutput>#attributes.ship_method_name#</cfoutput><cfelseif isdefined('get_ship_method')><cfoutput>#get_ship_method.ship_method#</cfoutput></cfif>" readonly>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=add_packet_ship.ship_method_name&field_id=add_packet_ship.ship_method_id&is_form_submitted=1','','ui-draggable-box-small');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-transport_comp_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="transport_comp_id" id="transport_comp_id" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id)><cfif len(get_order.transport_comp_id)><cfoutput>#get_order.transport_comp_id#</cfoutput></cfif><cfelseif isdefined('attributes.transport_comp_id') and len(attributes.transport_comp_id)><cfoutput>#attributes.transport_comp_id#</cfoutput></cfif>"> 
								<input type="hidden" name="transport_cons_id" id="transport_cons_id"> 
								<input type="text" name="transport_comp_name" id="transport_comp_name" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id)><cfif len(get_order.transport_comp_id)><cfoutput>#get_par_info(get_order.transport_comp_id,1,0,0)#</cfoutput></cfif><cfelseif isdefined('attributes.transport_comp_id') and len(attributes.transport_comp_id)><cfoutput>#get_par_info(attributes.transport_comp_id,1,0,0)#</cfoutput></cfif>" readonly>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_packet_ship.transport_comp_id&field_consumer=add_packet_ship.transport_cons_id&field_id=add_packet_ship.transport_cons_deliver_id&field_comp_name=add_packet_ship.transport_comp_name&field_partner=add_packet_ship.transport_deliver_id&field_name=add_packet_ship.transport_deliver_name<cfif isdefined("attributes.order_id") and len(attributes.order_id)><cfelseif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-transport_deliver_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45460.Taşıyıcı Yetkilisi'></label>
						<div class="col col-8 col-xs-12">
							<input type="hidden" name="transport_deliver_id" id="transport_deliver_id" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id)><cfif len(get_order.transport_comp_id)><cfoutput>#get_order.transport_deliver_id#</cfoutput></cfif><cfelseif isdefined('attributes.transport_deliver_id') and len(attributes.transport_deliver_id)><cfoutput>#attributes.transport_deliver_id#</cfoutput></cfif>">
							<input type="hidden" name="transport_cons_deliver_id" id="transport_cons_deliver_id">
							<input type="text" name="transport_deliver_name" id="transport_deliver_name" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id)><cfif len(get_order.transport_comp_id)><cfoutput>#get_par_info(get_order.transport_deliver_id,0,-1,0)#</cfoutput></cfif><cfelseif isdefined('attributes.transport_deliver_id') and len(attributes.transport_deliver_id)><cfoutput>#get_par_info(attributes.transport_deliver_id,0,-1,0)#</cfoutput></cfif>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-assetp_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64078.Araç'></label>
						<div class="col col-8 col-xs-12">
							<cfif is_manuel_asset eq 0>
								<div class="input-group">
									<cfif isdefined("attributes.assetp_id")>
										<cfquery name="GET_ASSETP" datasource="#DSN#">
											SELECT ASSETP, POSITION_CODE FROM ASSET_P WHERE ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
										</cfquery>
										<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
									<cfelse>
										<input type="hidden" name="assetp_id" id="assetp_id">
										<input type="text" name="assetp_name" id="assetp_name" value="">
									</cfif>
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_packet_ship.assetp_id&field_name=add_packet_ship.assetp_name&field_emp_id=add_packet_ship.vehicle_emp_id&field_emp_name=add_packet_ship.vehicle_emp_name');"></span>
								</div>
								<cfelse>
									<input type="text" name="assetp_name" id="assetp_name" value="" maxlength="50">
								</cfif>
						</div>
					</div>	
					<div class="form-group" id="item-vehicle_emp_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45466.Araç Yetkilisi'></label>
						<div class="col col-8 col-xs-12">
							<cfif is_manuel_asset eq 0>
								<div class="input-group">
									<cfif isdefined("attributes.assetp_id")>
										<input type="hidden" name="vehicle_emp_id" id="vehicle_emp_id" value="<cfif len(get_assetp.position_code)><cfoutput>#get_assetp.position_code#</cfoutput></cfif>">
										<input type="text" name="vehicle_emp_name" id="vehicle_emp_name" value="<cfif len(get_assetp.position_code)><cfoutput>#get_emp_info(get_assetp.position_code,1,0)#</cfoutput></cfif>">
									<cfelse>
										<input type="hidden" name="vehicle_emp_id" id="vehicle_emp_id" value="">
										<input type="text" name="vehicle_emp_name" id="vehicle_emp_name">
									</cfif>
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=add_packet_ship.vehicle_emp_name&field_emp_id=add_packet_ship.vehicle_emp_id&select_list=1');"></span>
								</div>
								<cfelse>
									<input type="text" name="vehicle_emp_name" id="vehicle_emp_name" maxlength="150">
								</cfif>
						</div>
					</div>
					<cfif is_manuel_asset neq 0>
					<div class="form-group" id="item-vehicle_emp_tc">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45466.Araç Yetkilisi'> TC</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="vehicle_emp_tc" id="vehicle_emp_tc" maxlength="11">
						</div>
					</div>
					<div class="form-group" id="item-plate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29453.Plaka'></label>
						<div class="col col-8 col-xs-12"><input type="text" name="plate" id="plate" maxlength="50"></div>
					</div>
					</cfif>
					<div class="form-group" id="item-vehicle2">
						<label class="col col-4 col-xs-12">2. <cf_get_lang dictionary_id='29453.Plaka'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="plate2" id="plate2" maxlength="150">
						</div>	
					</div>
					<cfif is_show_insurance_comp eq 1>
						<div class="form-group" id="item-insurance_comp_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45234.Sigorta Firması'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="insurance_comp_id" id="insurance_comp_id" value="">
									<input type="text" name="insurance_comp_name"  id="insurance_comp_name" value="" readonly>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_packet_ship.insurance_comp_id&field_comp_name=add_packet_ship.insurance_comp_name&field_partner=add_packet_ship.insurance_comp_partner_id&field_name=add_packet_ship.insurance_comp_partner_name&select_list=2');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-insurance_comp_partner_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45240.Sigorta Yetkilisi'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="insurance_comp_partner_id" id="insurance_comp_partner_id" value="">
								<input type="text" name="insurance_comp_partner_name" id="insurance_comp_partner_name" value="" readonly>
							</div>
						</div>
					</cfif>
					<cfif is_show_duty_comp eq 1>
						<div class="form-group" id="item-duty_comp_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45238.Gümrük Firması'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="duty_comp_id" id="duty_comp_id" value="">
									<input type="text" name="duty_comp_name" id="duty_comp_name" value="" readonly>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_packet_ship.duty_comp_id&field_comp_name=add_packet_ship.duty_comp_name&field_partner=add_packet_ship.duty_comp_partner_id&field_name=add_packet_ship.duty_comp_partner_name&select_list=2');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-duty_comp_partner_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45251.Gümrük Yetkilisi'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="duty_comp_partner_id" id="duty_comp_partner_id" value="">
								<input type="text" name="duty_comp_partner_name" id="duty_comp_partner_name" value="" readonly>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-ship_price">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="45184.Nakliye Bedeli"></label>
						<div class="col col-8 col-xs-12">
							<cfquery name="get_ship" datasource="#dsn2#">
								SELECT OTHER_MONEY_VALUE,OTHER_MONEY FROM SHIP_RESULT
							</cfquery>
							<div class="input-group">
								<input type="text" name="ship_price" id="ship_price" value="<cfoutput>#tlFormat(get_ship.other_money_value)#</cfoutput>" class="moneybox" onkeyup="return(FormatCurrency(this,event,2));">
								<span class="input-group-addon width">
									<select name="ship_price_name" id="ship_price_name">
										<cfoutput query="get_moneys"> 
											<option value="#money#" 
												<cfif isdefined('attributes.ship_result_id')>
													<cfif money eq get_ship.other_money>selected</cfif>
												<cfelse>
												<cfif money eq session.ep.money>selected</cfif></cfif>>#money#</option>
										</cfoutput>
									</select>
								</span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-transport_no1">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45458.Sevkiyat No'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="transport_no1" id="transport_no1" value="<cfoutput>#paper_code & '-' & paper_number#</cfoutput>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-transport_paper_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57716.Taşıyıcı'> <cf_get_lang dictionary_id='57880.Belge No'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="transport_paper_no" id="transport_paper_no" maxlength="25">
						</div>
					</div>
					<div class="form-group" id="item-reference_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58794.Referans No'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="reference_no" id="reference_no" value="" maxlength="25">
						</div>
					</div>
					<cfif is_show_warehouse_date eq 1>
						<div class="form-group" id="item-warehouse_entry_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45227.Depo Giris'></label>
							<div class="col col-4 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="warehouse_entry_date" id="warehouse_entry_date" validate="#validate_style#" value="#dateformat(now(),dateformat_style)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="warehouse_entry_date"></span>
								</div>
							</div>
							<div class="col col-2 col-xs-12">
								<cf_wrkTimeFormat name="warehouse_entry_h" id="warehouse_entry_h" value="0">	
							</div>
							<div class="col col-2 col-xs-12">
								<select name="warehouse_entry_m" id="warehouse_entry_m">
									<cfoutput>
										<cfloop from="0" to="59" index="i">
											<option value="#numberformat(i,00)#">#numberformat(i,00)#</option>
										</cfloop>
									</cfoutput>
								</select>
							</div>
						</div>
					</cfif>
					<cfoutput>
						<div class="form-group" id="item-action_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45463.Depo Çıkış'></label>
							<div class="col col-4 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="action_date" id="action_date" validate="#validate_style#" required="Yes" message="#getLang('','Depo Çıkış Tarih Girmelisiniz',45464)#" value="#dateformat(now(),dateformat_style)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="action_date"></span>
								</div>
							</div>
							<div class="col col-2 col-xs-12">
								<cf_wrkTimeFormat name="start_h" id="start_h" value="0">	
							</div>
							<div class="col col-2 col-xs-12">
								<select name="start_m" id="start_m">
									<cfloop from="0" to="59" index="i">
										<option value="#numberformat(i,00)#">#numberformat(i,00)#</option>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-deliver_date">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarih'></label>
							<div class="col col-4 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="deliver_date" id="deliver_date" value="" validate="#validate_style#" message="#getLang('','Lütfen Teslim Tarihi Formatını Doğru Giriniz',45647)#">
									<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="deliver_date"></span>
								</div>
							</div>
							<div class="col col-2 col-xs-12">
								<cf_wrkTimeFormat name="deliver_h" id="deliver_h" value="0">
							</div>
							<div class="col col-2 col-xs-12">
								<select name="deliver_m" id="deliver_m">
									<cfloop from="0" to="59" index="i">
										<option value="#numberformat(i,00)#">#numberformat(i,00)#</option>
									</cfloop>
								</select>
							</div>
						</div>
					</cfoutput>
					<div class="form-group" id="item-deliver_id2">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45470.Teslim Eden'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="deliver_id2" id="deliver_id2" value="<cfoutput>#session.ep.userid#</cfoutput>">
								<input type="text" name="deliver_name2" id="deliver_name2" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" readonly>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=add_packet_ship.deliver_id2&field_name=add_packet_ship.deliver_name2&select_list=1');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-location_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29428.Çıkış Depo'><cfif is_department_required eq 1> *</cfif></label>
						<div class="col col-8 col-xs-12">
							<cfif isdefined("attributes.location_id")>
								<cf_wrkdepartmentlocation
									returnInputValue="location_id,department_name,department_id,branch_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="department_name"
									fieldid="location_id"
									department_fldId="department_id"
									branch_fldId="branch_id"
									branch_id="#attributes.branch_id#"
									xml_all_depo = "#xml_all_depo#"
									department_id="#attributes.department_id#"
									location_id="#attributes.location_id#"
									user_level_control="#session.ep.our_company_info.is_location_follow#"
									width="170">
							<cfelse>
								<cf_wrkdepartmentlocation
									returnInputValue="location_id,department_name,department_id,branch_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="department_name"
									fieldid="location_id"
									xml_all_depo = "#xml_all_depo#"
									department_fldId="department_id"
									branch_fldId="branch_id"
									user_level_control="#session.ep.our_company_info.is_location_follow#"
									width="170">
							</cfif>
						</div>
					</div>
					<cfif is_show_cost eq 1>
						<div class="form-group" id="item-calculate_type">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45546.Hes Yöntemi'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="max_limit" id="max_limit" value="">
								<input type="hidden" name="options_kontrol" id="options_kontrol" value=""><!--- Bu alan disabled olan asagidaki radio butonlarin secilip secilmadegini kontrol etmek icin kullaniliyor --->
								<label><input type="radio" name="calculate_type" id="calculate_type" value="1" onclick="change_packet(1);" disabled="disabled"><cf_get_lang dictionary_id='45547.Kümülatif'>&nbsp;</label>
								<label><input type="radio" name="calculate_type" id="calculate_type" value="2" onclick="change_packet(2);" disabled="disabled"><cf_get_lang dictionary_id='45548.Paket'></label><!--- onblur="change_packet(2);" --->
							</div>
						</div>
						<div class="form-group" id="item-total_cost_value">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='45493.Maliyet Tutarı'></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="total_cost_value" id="total_cost_value" value="<cfoutput>#TlFormat(0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly>
									<span class="input-group-addon"><cfoutput>#session.ep.money#</cfoutput></span>
									<input type="text" name="total_cost2_value" id="total_cost2_value" value="<cfoutput>#TlFormat(0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly>
									<span class="input-group-addon"><cfoutput>#session.ep.money2#</cfoutput></span>
								</div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-sending_address">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='45646.Sevkiyat Adresi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<textarea name="sending_address" id="sending_address"><cfif isdefined("attributes.sending_address")><cfoutput>#attributes.sending_address#</cfoutput></cfif></textarea>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="add_adress(3);"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-sending_postcode">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57472.Posta Kodu'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="sending_postcode" id="sending_postcode" value="" maxlength="30">
						</div>
					</div>
					<div class="form-group" id="item-sending_semt">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58132.Semt'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="sending_semt" id="sending_semt" value="" maxlength="30">
						</div>
					</div>
					<div class="form-group" id="item-sending_county">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58638.İlçe'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isdefined("county_id") and len(county_id)>
									
								<cfinput type="hidden" name="sending_county_id" id="sending_county_id" value="#county_id#">
								<cfinput type="text" name="sending_county" id="sending_county" value="#get_county.COUNTY_NAME#" readonly>	
								<cfelse>
									<input type="hidden" name="sending_county_id" id="sending_county_id" value="">
									<input type="text" name="sending_county" id="sending_county" value="" readonly>	
								</cfif>
											
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_();"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-sending_city">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57971.Şehir'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isdefined("city_id") and len(city_id)>
									<cfinput type="hidden" name="sending_city_id" id="sending_city_id" value="#city_id#">
									<cfinput type="text" name="sending_city" id="sending_city" value="#GET_CITY.CITY_NAME#" readonly>
								<cfelse>
									<cfinput type="hidden" name="sending_city_id" id="sending_city_id" value="">
									<cfinput type="text" name="sending_city" id="sending_city" value="" readonly>
								</cfif>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac_city();"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-sending_country">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58219.Ülke'></label>
						<div class="col col-8 col-xs-12">
							<select name="sending_country_id" id="sending_country_id" onChange="remove_adress('1');">
								<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
								<cfif isdefined("country_id") and len(country_id)>
									<cfoutput query="get_country">
										<option value="#country_id#" <cfif attributes.country_id eq get_country.country_id>selected</cfif>>#country_name#</option>
									</cfoutput>
								<cfelse>
									<cfoutput query="get_country">
										<option value="#country_id#" <cfif get_country.is_default eq 1>selected</cfif>>#country_name#</option>
									</cfoutput>
								</cfif>
							</select>												
						</div>
					</div>
					<div class="form-group" id="item-note">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="note" id="note" style="width:150px;height:45px;"></textarea>											
						</div>
					</div>
				</div>
			</cf_box_elements>
			<div class="col col-12 col-md-12 col-xs-12">
				<cf_seperator id="paket_" title="#getLang('stock',183)#">
				<cf_grid_list id="paket_">
					<thead>
						<tr>
							<th width="20">
								<input type="hidden" name="record_num" id="record_num" value="0">
								<input type="hidden" name="ship_id_list" id="ship_id_list" value="">
								<a onClick="add_row();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
							</th>
							<th><cf_get_lang dictionary_id='58138.İrsaliye No'></th>
							<th><cf_get_lang dictionary_id='57742.Tarih'></th>
							<th><cf_get_lang dictionary_id='64077.Alıcı'></th>
							<th><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></th>
							<th><cf_get_lang dictionary_id='58723.Adres'></th>
						</tr>
					</thead>
					<tbody <!---id="frm_row"---> id="table1"></tbody>  
				</cf_grid_list> 
			<br>
			<div class="col col-9 col-md-12 col-xs-12">
				<cfif is_show_cost eq 1>
					<cf_seperator id="paket_2" title="#getLang('stock','Sevkiyatı Yapılan Paketlemeler','45367')#">
					<cf_box_elements>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold"><cf_get_lang dictionary_id='35781.Paketleyen'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="pack_emp_id0" id="pack_emp_id0" value="">
									<cfinput type="text" name="pack_emp_name0" id="pack_emp_name0" value="" onfocus="hepsi();" readonly>
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac2_main();"></span>
								</div>
							</div>
						</div>
					</cf_box_elements>
					<cf_grid_list id="paket_2">
						<thead>
							<tr>
								<th width="20" nowrap="nowrap"><input name="record_num_other" id="record_num_other" type="hidden" value="0"><a onClick="add_row_other();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
								<th width="35"><cf_get_lang dictionary_id='58082.Adet'> *</th>
								<th width="200"><cf_get_lang dictionary_id='45477.Paket Tipi'> *</th>
								<th><cf_get_lang dictionary_id='45478.Ebat'></th>
								<th><cf_get_lang dictionary_id='29784.Ağırlık'> (<cf_get_lang dictionary_id='45766.kg'>)</th>
								<th><cf_get_lang dictionary_id='57633.Barkod'></th>
								<th><cf_get_lang dictionary_id='45545.Paketleyen'></th>
							</tr>
						</thead>
						<tbody id="table2" ></tbody><!---id="frm_row_other"--->
					</cf_grid_list>
				</cfif>
			</div>
		</div>

			<div class="row formContentFooter">
				<div class="col col-12">
					<cfif is_show_cost eq 1>
						<cf_workcube_buttons is_upd='0' add_function='transport_control(),control()'>
					<cfelse>
						<cf_workcube_buttons is_upd='0' add_function='control()'>
					</cfif>
				</div>
			</div>   
		</cfform>
	</cf_box>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
<script type="text/javascript">
	calculate_type_deger = 1;
	row_count = 0;
	row_count2 = 0;
	
	money_list = "<cfoutput>#valuelist(moneys.money,',')#</cfoutput>";
	rate1_list = "<cfoutput>#valuelist(moneys.rate1,',')#</cfoutput>";
	rate2_list = "<cfoutput>#valuelist(moneys.rate2,',')#</cfoutput>";
	
	function add_adress(adress_type)
	{
		if(!(document.getElementById("partner_id").value=="") || !(document.getElementById("consumer_id").value==""))
		{	
			if(document.getElementById("partner_id").value!="")
			{
				str_adrlink = '&field_adres=add_packet_ship.sending_address&field_city=add_packet_ship.sending_city_id&field_city_name=add_packet_ship.sending_city&field_county=add_packet_ship.sending_county_id&field_county_name=add_packet_ship.sending_county&field_postcode=add_packet_ship.sending_postcode&field_semt=add_packet_ship.sending_semt'; 
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=1&keyword='+encodeURIComponent(add_packet_ship.company.value)+''+ str_adrlink);
				return true;
			}
			else
			{
				str_adrlink = '&field_adres=add_packet_ship.sending_address&field_city=add_packet_ship.sending_city_id&field_city_name=add_packet_ship.sending_city&field_county=add_packet_ship.sending_county_id&field_county_name=add_packet_ship.sending_county&field_postcode=add_packet_ship.sending_postcode&field_semt=add_packet_ship.sending_semt'; 
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_member_address&is_comp=0&keyword='+encodeURIComponent(add_packet_ship.member_name.value)+''+ str_adrlink);
				return true;
			}
		}
		<cfif not (isDefined("attributes.is_sevk") and attributes.is_sevk eq "1")>
		else
		{
			alert("<cf_get_lang dictionary_id ='45308.Cari Hesap Seçiniz'> !");
			return false;
		}
		</cfif>
	}
	
	function pencere_ac(no)
	{
		if(document.getElementById("member_name").value !='')
		{
			document.getElementById("ship_id_list").value  ='';
			for(r=1; r<=document.getElementById("record_num").value; r++)
			{
				deger_row_kontrol = document.getElementById('row_kontrol'+r);
				//deger_ship_id = document.getElementById('ship_id'+r);
				if(deger_row_kontrol.value == 1)
				{
					if(document.getElementById("ship_id_list").value == '')
					{
						if(document.getElementById('ship_id'+r).value != '')
							document.getElementById("ship_id_list").value = document.getElementById('ship_id'+r).value;
					}
					else
					{
						if(document.getElementById('ship_id'+r).value != '')
							document.getElementById("ship_id_list").value += ','+document.getElementById('ship_id'+r).value;
					}	
				}
			}
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_ship_details</cfoutput>&ship_id_list=' + add_packet_ship.ship_id_list.value + '&ship_id=add_packet_ship.ship_id'+no+'&ship_number=add_packet_ship.ship_number'+no+'&ship_date=add_packet_ship.ship_date'+no+'&ship_deliver=add_packet_ship.ship_deliver'+no+'&ship_type=add_packet_ship.ship_type'+no+'&ship_adress=add_packet_ship.ship_adress'+no+'&is_gonder=1&deliver_company_id='+document.getElementById("company_id").value);//&deliver_company_id='+add_packet_ship.service_company_id.value
		}
		<cfif not (isDefined("attributes.is_sevk") and attributes.is_sevk eq "1")>
		else
		{
			alert("<cf_get_lang dictionary_id='45308.Cari Hesap Seçiniz'>!");
		}
		</cfif>
	}
	
	function pencere_ac2_main()
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_packet_ship.pack_emp_id0&field_name=add_packet_ship.pack_emp_name0&select_list=1&call_function=hepsi()');
	}
	
	function pencere_ac2(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_packet_ship.pack_emp_id'+ no +'&field_name=add_packet_ship.pack_emp_name'+ no+'&select_list=1');
	}
	
	function sil(sy)
	{
		var my_element = document.getElementById("row_kontrol"+sy);
		my_element.value = 0;
		var my_element = eval("frm_row"+sy);
		my_element.style.display = "none";
	}
	
	function sil_other(sy)
	{
		var my_element = document.getElementById("row_kontrol_other"+sy);
		my_element.value = 0;
		var my_element = eval("frm_row_other"+sy);
		my_element.style.display = "none";
		if(document.getElementsByName('calculate_type')[1].checked)
			return kur_hesapla();
		else
			degistir(sy);
	}
	
	function add_row()
	{
		<cfif is_department_required eq 1>
			if((document.getElementById("department_id").value=="") || (document.getElementById("department_name").value==""))
			{
				alert("<cf_get_lang dictionary_id='51278.Çıkış Depo Seçiniz'> !");
				return false;
			}
		</cfif>

		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);		
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);		
		document.getElementById("record_num").value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"> <a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="Sil"></i></a>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'" value=""><input type="text" name="ship_number' + row_count +'" id="ship_number' + row_count +'" value="" readonly> <span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac('+ row_count +');"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="" readonly></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="" readonly></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="" readonly></div>';
	}
	
	function transport_control()
	{
		if(document.getElementById("transport_comp_id").value != "" )
		{
			var GET_MAX_LIMIT = wrk_safe_query('stk_get_max_limit','dsn',0,document.getElementById("transport_comp_id").value);//Seçilen taşıyıcıya ait yapılmış bir tanımlama değeri varsa.
			document.getElementById("max_limit").value = GET_MAX_LIMIT.MAX_LIMIT;
			if(GET_MAX_LIMIT.CALCULATE_TYPE == 1)
			{
				document.getElementsByName('calculate_type')[0].checked=true;
				document.getElementById('options_kontrol').value = 1;/*Form'u kontrol etmek için,*/
			}
			else if	(GET_MAX_LIMIT.CALCULATE_TYPE == 2)
			{
				document.getElementsByName('calculate_type')[1].checked = true;
				document.getElementById('options_kontrol').value = 1;/*Form'u kontrol etmek için,*/
			}
			if(GET_MAX_LIMIT.MAX_LIMIT == undefined)
			{
				alert("<cf_get_lang dictionary_id ='45648.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini Kontrol Ediniz (Fiyat Listesi)'>!");
				document.getElementsByName('calculate_type')[0].checked = false;
				document.getElementsByName('calculate_type')[1].checked = false;
				document.getElementById('options_kontrol').value = 0;
				document.getElementById("max_limit").value = 0;
				return false;	
			}
		}
	}
	function add_row_other()
	{
		if(document.getElementById("ship_method_id").value == "")
		{
			alert("<cf_get_lang dictionary_id='45482.Lütfen Sevk Yöntemi Seçiniz'> !");
			return false;
		}
		/*
		if(document.getElementById("transport_comp_id").value == "")
		{
			alert("<cf_get_lang dictionary_id='318.Taşıyıcı Seçiniz'> !");
			return false;
		}
		*/
		transport_control();/*Satır eklerkende taşıyıcıyı kontrol etsin.*/
		row_count2++;
		var newRow;
		var newCell;
		newRow = document.getElementById("table2").insertRow(document.getElementById("table2").rows.length);
		newRow.setAttribute("name","frm_row_other" + row_count2);
		newRow.setAttribute("id","frm_row_other" + row_count2);		
		newRow.setAttribute("NAME","frm_row_other" + row_count2);
		newRow.setAttribute("ID","frm_row_other" + row_count2);		
		document.getElementById('record_num_other').value=row_count2;
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="hidden" name="row_kontrol_other' + row_count2 +'" id="row_kontrol_other' + row_count2 +'" value="1"><a onclick="sil_other(' + row_count2 + ');"><i class="fa fa-minus" title="Sil"></i></a>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="quantity' + row_count2 +'" id="quantity' + row_count2 +'" onblur="degistir( ' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event,0));" value="<cfoutput>#tlformat(1,0)#</cfoutput>" class="moneybox" style="width:35px"></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><select name="package_type' + row_count2 +'" id="package_type' + row_count2 +'" onchange="degistir( ' + row_count2 + ');"><option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option><cfoutput query="get_package_type"><option value="#package_type_id#,#dimention#,#calculate_type_id#">#package_type#</option></cfoutput></select></div>'; //add_general_prom();
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_ebat' + row_count2 +'" id="ship_ebat' + row_count2 +'" value=""></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_agirlik' + row_count2 +'" id="ship_agirlik' + row_count2 +'" value="" onBlur="degistir(' + row_count2 + ');" onKeyup="return(FormatCurrency(this,event));" class="moneybox"></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="total_price' + row_count2 +'" id="total_price' + row_count2 +'" value="" onKeyup="return(FormatCurrency(this,event));" class="moneybox" readonly><input type="hidden" name="other_money' + row_count2 +'" id="other_money' + row_count2 +'" value="" class="moneybox" readonly><input type="text" name="ship_barcod' + row_count2 +'" id="ship_barcod' + row_count2 +'" value=""></div>';
	
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="pack_emp_id' + row_count2 +'" id="pack_emp_id' + row_count2 +'" value=""><input type="text" name="pack_emp_name' + row_count2 +'" id="pack_emp_name' + row_count2 +'" value=""> <span class="input-group-addon btnPointer icon-ellipsis" onClick="pencere_ac2('+ row_count2 +');"></span></div></div>';
	}
	
	function degistir(id)
	{
		if(document.getElementById('row_kontrol_other'+id).value == 1)
		{
			if(trim(document.getElementById('quantity'+id).value).length == 0)
				document.getElementById('quantity'+id).value = 1;
		}
		if(document.getElementsByName('calculate_type')[1].checked)
		{
			var temp_package_type = document.getElementById('package_type'+id);
			var temp_ship_ebat = document.getElementById('ship_ebat'+id);
			var temp_total_price = document.getElementById('total_price'+id);
			var temp_quantity = document.getElementById('quantity'+id);
			var temp_other_money = document.getElementById('other_money'+id);
			var temp_ship_agirlik = document.getElementById('ship_agirlik'+id);
			
			temp_desi = list_getat(temp_package_type.value,2,',');
			temp_package_type_id = list_getat(temp_package_type.value,3,',');
			if(temp_package_type_id==1) //Desi
			{
				temp_ship_ebat.value = temp_desi;
				temp_ship_agirlik.value = '';
				desi_1 = list_getat(temp_desi,1,'*');
				desi_2 = list_getat(temp_desi,2,'*');
				desi_3 = list_getat(temp_desi,3,'*');
				desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000);
				if(desi_hesap<document.getElementById("max_limit").value)
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + desi_hesap;
					var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" +  document.getElementById("max_limit").value + "*" + document.getElementById("max_limit").value;
					var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
			}
			else if(temp_package_type_id==2) 
			{	
				temp_ship_agirlik_ = parseFloat(filterNum(temp_ship_agirlik.value))*parseFloat(temp_quantity.value);
				if(temp_ship_agirlik_>document.getElementById("max_limit").value)
					temp_ship_agirlik_ = Math.ceil(temp_ship_agirlik_);
				if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
				{
					if(temp_ship_agirlik_<document.getElementById("max_limit").value)
					{
						var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + temp_ship_agirlik_;
						var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
					else
					{
						var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
						var GET_PRICE = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
					}
				}	
			}	
			else if(temp_package_type_id==3)  //Zarf ise
			{
				var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value;
				var GET_PRICE = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
			}
			if(GET_PRICE != undefined)
			{
				if(GET_PRICE.recordcount==0)
				{
					alert("<cf_get_lang dictionary_id ='45648.Lütfen Hesaplama için Sevk Yöntemi, Tasıyıcı Firma, Paket Tipini Kontrol Ediniz (Fiyat Listesi)'>!");
					temp_ship_ebat.value = "";
					temp_total_price.value = "";
					temp_other_money.value = "";
				}
				else
				{
					if(temp_package_type_id==1)//Desi ise
					{
						temp_ship_agirlik.value = "";
						if(desi_hesap < document.getElementById("max_limit").value)
						{
							temp_total_price.value = commaSplit(GET_PRICE.PRICE*temp_quantity.value);/*Toplam atanıyor.*/
						}
						else
						{
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
							desi_remain = parseFloat((parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3))/(3000)-<cfoutput>document.getElementById("max_limit").value</cfoutput>);
							temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE*temp_quantity.value)+parseFloat(GET_PRICE_30.PRICE*desi_remain*temp_quantity.value));
							
						}
					}
					if(temp_package_type_id==2)//Kg ise
					{
						temp_ship_ebat.value = "";
						if(temp_ship_agirlik_<document.getElementById("max_limit").value)
						{
							temp_total_price.value = commaSplit(GET_PRICE.PRICE);
						}
						else
						{
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
							kg_remain = parseFloat(temp_ship_agirlik_-document.getElementById("max_limit").value);
							temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain));
						}
					}				
					
					else if(temp_package_type_id==3)//Zarf ise
					{
						temp_ship_agirlik = '';
						temp_ship_ebat.value = '';
						temp_total_price.value = commaSplit(parseFloat(GET_PRICE.PRICE) * parseFloat(temp_quantity.value));
					}
					temp_other_money.value = GET_PRICE.OTHER_MONEY;
				}
			}
			else
			{
				temp_total_price.value = "";
				temp_other_money.value = "";	
			}
		}
		else
		{
			count_desi = 0;
			count_kg = 0;
			count_envelope = 0;
			desi_sum = 0;
			kg_sum = 0;
			desi_price_sum = 0;
			kg_price_sum = 0;
			envelope_price_sum = 0;
			
			for(r=1;r<=document.getElementById('record_num_other').value;r++)
			{
				if(document.getElementById("row_kontrol_other"+r).value == 1)
				{
					var temp_package_type = document.getElementById("package_type"+r);
					var temp_ship_ebat = document.getElementById("ship_ebat"+r);
					var temp_quantity = document.getElementById("quantity"+r);
					var temp_ship_agirlik = document.getElementById("ship_agirlik"+r);
	
					temp_desi = list_getat(temp_package_type.value,2,',');
					temp_package_type_id = list_getat(temp_package_type.value,3,',');
					if(temp_package_type_id==1) //Desi
					{
						count_desi += 1;
						temp_ship_ebat.value = temp_desi;
						temp_ship_agirlik.value = '';
						desi_1 = list_getat(temp_desi,1,'*');
						desi_2 = list_getat(temp_desi,2,'*');
						desi_3 = list_getat(temp_desi,3,'*');
						desi_hesap = (parseInt(desi_1)*parseInt(desi_2)*parseInt(desi_3)/3000*parseFloat(temp_quantity.value));
						desi_sum +=desi_hesap;
					}
					else if(temp_package_type_id==2)//Kg
					{
						count_kg += 1;
						temp_ship_ebat.value = "";
						if(trim(document.getElementById("ship_agirlik"+r).value).length == 0)
							document.getElementById("ship_agirlik"+r).value = 1;
						temp_ship_agirlik_ = filterNum(temp_ship_agirlik.value);
						if(temp_ship_agirlik.value !="" && temp_ship_agirlik.value !=0)
							kg_sum +=parseFloat(temp_ship_agirlik_)*parseFloat(temp_quantity.value);
					}	
					else if(temp_package_type_id==3)//Zarf ise
					{
						count_envelope += 1;
						temp_ship_agirlik.value = '';
						temp_ship_ebat.value = '';
						var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value;
						var GET_PRICE3 = wrk_safe_query("stk_GET_PRICE_2",'dsn',0,listParam);
						if(GET_PRICE3 != undefined)
						{
							if(GET_PRICE3.recordcount==0)
								alert("<cf_get_lang dictionary_id ='45649.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Zarf) Kontrol Ediniz (Fiyat Listesi)'>!");
							else
								envelope_price_sum += GET_PRICE3.PRICE * parseFloat(temp_quantity.value);
						}					
					}
				}
			}
	
			if(count_desi != 0)
			{
				if(desi_sum<document.getElementById("max_limit").value)
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + desi_sum;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				
				if(GET_PRICE1 != undefined)
				{
					if(GET_PRICE1.recordcount==0)
						alert("<cf_get_lang dictionary_id ='45650.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Desi) Kontrol Ediniz (Fiyat Listesi)'>!");
					else
					{
						if(desi_sum<document.getElementById("max_limit").value)
						{
							desi_price_sum = GET_PRICE1.PRICE;
						}
						else
						{					
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30','dsn',0,document.getElementById("transport_comp_id").value);
							desi_remain2 = parseFloat(desi_sum-document.getElementById("max_limit").value);
							desi_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*desi_remain2);
						}
					}
				}
			}
			if(count_kg != 0)
			{
				if(kg_sum<document.getElementById("max_limit").value)
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + kg_sum;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				else
				{
					var listParam = document.getElementById("transport_comp_id").value + "*" + document.getElementById("ship_method_id").value + "*" + document.getElementById("max_limit").value;
					var GET_PRICE1 = wrk_safe_query("stk_GET_PRICE",'dsn',0,listParam);
				}
				
				if(GET_PRICE1 != undefined)
				{
					if(GET_PRICE1.recordcount==0)
						alert("<cf_get_lang dictionary_id ='45651.Lütfen Hesaplama için Sevk Yöntemi Tasıyıcı Firma Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
					else
					{
						if(kg_sum<document.getElementById("max_limit").value)
						{
							kg_price_sum = parseFloat(GET_PRICE1.PRICE);
						}
						else
						{	
							var GET_PRICE_30 = wrk_safe_query('stk_get_prc_30_2','dsn',0,document.getElementById("transport_comp_id").value);
							kg_remain2 = parseFloat(kg_sum-document.getElementById("max_limit").value);
							kg_remain2 = Math.ceil(kg_remain2);
							kg_price_sum = parseFloat(GET_PRICE1.PRICE)+parseFloat(GET_PRICE_30.PRICE*kg_remain2);
						}
					}
				}
			}
			document.getElementById("total_cost_value").value = commaSplit(parseFloat(desi_price_sum)+parseFloat(kg_price_sum)+parseFloat(envelope_price_sum));
		}
		return kur_hesapla();
	}
	
	function control()
	{
		var deger_zarf_kontrol = 0;	
		<cfif is_show_cost eq 1>
		if(document.getElementById('options_kontrol').value==0 || document.getElementById('options_kontrol').value == "")
		{	
			alert("<cf_get_lang dictionary_id ='45651.Lütfen Hesaplama için Sevk Yöntemi, Tasıyıcı Firma, Paket Tipini(Kg) Kontrol Ediniz (Fiyat Listesi)'>!");
			return false;
		}
		</cfif>
		<cfif not (isDefined("attributes.is_sevk") and attributes.is_sevk eq "1")>
		if(document.getElementById('company_id').value=="" && document.getElementById('consumer_id').value=="")
		{
			alert("<cf_get_lang dictionary_id='45308.Cari Hesap Seçiniz'>!");
			return false;
		}	
		</cfif>
		if(document.getElementById('ship_method_id').value == "")	
		{
			alert("<cf_get_lang dictionary_id='45482.Lütfen Sevk Yöntemi Seçiniz'> !");
			return false;
		}
		/*
		if(document.getElementById('transport_comp_id').value == "")	
		{
			alert("<cf_get_lang dictionary_id='318.Taşıyıcı Seçiniz'> !");
			return false;
		}
		*/
		//Irsaliye kontrolleri
		for(r=1;r<=document.getElementById('record_num').value;r++)
		{
			deger_row_kontrol = document.getElementById('row_kontrol'+r);
			//deger_ship_id = document.getElementById('ship_id'+r);
			if(deger_row_kontrol.value == 1)
			{
				if(document.getElementById('ship_id'+r).value == "")
				{
					alert("<cf_get_lang dictionary_id='45483.Lütfen İrsaliye Seçiniz'> !");
					return false;
				}
			}
		}
		
		//Zarf ise sevkiyat adresi zorunlu
		if(deger_zarf_kontrol == 1)
		{
			if(document.getElementById('sending_address').value == "")
			{
				alert("<cf_get_lang dictionary_id ='45652.Zarf Gönderilerinde Sevkiyat Adresi Seçilmelidir'>!")
				return false;
			}
		}
		if(document.getElementById('sending_address').value.length > 300)
		{
			alert("<cf_get_lang dictionary_id ='45653.Sevkiyat Adresi 300 Karakterden Fazla Olamaz'>!");
			return false;
		}
		<cfif is_show_cost eq 1>
			// Paket kontrolleri
			for(r=1;r<=document.getElementById('record_num_other').value;r++)
			{
				if(document.getElementById("row_kontrol_other"+r).value == 1)
				{
					if(document.getElementById("package_type"+r).value == "")
					{
						alert("<cf_get_lang dictionary_id='45484.Lütfen Paket Tipi Seçiniz'>!");
						return false;
					}
					if(list_getat(document.getElementById("package_type"+r).value,3) == 3)
						deger_zarf_kontrol = 1;
				}
			}
			if (document.getElementById("record_num_other").value == 0)
			{
				alert("<cf_get_lang dictionary_id='61196.Paketleme Tipi Seçiniz'>!");
				return false;	
			}
			else 
				unformat_fields();
		</cfif>
		
	/*	if (document.getElementById("record_num").value == 0)
		{
			alert("İrsaliye Seçiniz!");
			return false;	
		}
			
		for(i=1;i<=document.getElementById('record_num').value;++i)
		{
			document.getElementById('add_packet_ship').appendChild(document.getElementById('row_kontrol' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_id' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_number' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_date' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_deliver' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_type' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_adress' + i));
		}
		
		for(i=1;i<=document.getElementById('record_num_other').value;++i)
		{
			document.getElementById('add_packet_ship').appendChild(document.getElementById('package_type' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_ebat' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('total_price' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('quantity' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('other_money' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_agirlik' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('row_kontrol_other' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('ship_barcod' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('pack_emp_id' + i));
			document.getElementById('add_packet_ship').appendChild(document.getElementById('pack_emp_name' + i));
		}*/
		document.add_packet_ship.ship_price.value = filterNum(document.add_packet_ship.ship_price.value);		
		if(process_cat_control())
		{
			return paper_control(document.getElementById("transport_no1"),'SHIP_FIS');
		}
		else
			return false;	
	}
	
	function kur_hesapla()
	{
		total_cost_value = 0;
		if(document.getElementsByName('calculate_type')[1].checked)
		{		
			for(r=1;r<=document.getElementById('record_num_other').value;r++)
			{
				if(document.getElementById("row_kontrol_other"+r).value == 1)
				{
					var temp_other_money = document.getElementById("other_money"+r);
					var temp_total_price = document.getElementById("total_price"+r);
					
					if(temp_total_price.value != '')
					{
						temp_sira = list_find(money_list,temp_other_money.value);				
						temp_rate1 = list_getat(rate1_list,temp_sira);
						temp_rate2 = list_getat(rate2_list,temp_sira);
						temp_deger = parseFloat(parseFloat(filterNum(temp_total_price.value)) / (parseFloat(temp_rate1) / parseFloat(temp_rate2)));
						total_cost_value = parseFloat(total_cost_value) + parseFloat(temp_deger);
					}
				}
			}
			temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
			temp2_rate1 = list_getat(rate1_list,temp2_sira);
			temp2_rate2 = list_getat(rate2_list,temp2_sira);
			total_cost2_value = total_cost_value * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
			
			document.getElementById("total_cost_value").value = commaSplit(total_cost_value);
			document.getElementById("total_cost2_value").value = commaSplit(total_cost2_value);
		}
		else
		{
			temp2_sira = list_find(money_list,<cfoutput>'#session.ep.money2#'</cfoutput>); 
			temp2_rate1 = list_getat(rate1_list,temp2_sira);
			temp2_rate2 = list_getat(rate2_list,temp2_sira);
			total_cost2_value = filterNum(document.getElementById("total_cost_value").value) * (parseFloat(temp2_rate1) / parseFloat(temp2_rate2));
			document.getElementById("total_cost2_value").value = commaSplit(total_cost2_value);
		}
		return true;
	}
	
	function unformat_fields()
	{
		for(r=1;r<=document.getElementById('record_num_other').value;r++)
		{
			if(document.getElementById("row_kontrol_other"+r).value == 1)
			{
				document.getElementById("quantity"+r).value = filterNum(document.getElementById("quantity"+r).value);
				document.getElementById("ship_agirlik"+r).value = filterNum(document.getElementById("ship_agirlik"+r).value);
				document.getElementById("total_price"+r).value = filterNum(document.getElementById("total_price"+r).value);
				//document.getElementById("ship_price"+r).value = filterNum(document.getElementById("ship_price"+r).value);
			}
		}
		document.getElementById("total_cost_value").value = filterNum(document.getElementById("total_cost_value").value);
		document.getElementById("total_cost2_value").value = filterNum(document.getElementById("total_cost2_value").value);
	}
	
	function change_packet(calculate_type_value)
	{		
		if(row_count2!=0)
		{
			if(calculate_type_deger!=calculate_type_value)
			{
				if(calculate_type_value == 2)
				{
					for(r=1;r<=document.getElementById('record_num_other').value;r++)
					{
						if(document.getElementById("row_kontrol_other"+r).value == 1)
						{
							document.getElementById("package_type"+r).value = '';
							document.getElementById("ship_ebat"+r).value = '';
							document.getElementById("ship_agirlik"+r).value = '';
							document.getElementById("total_price"+r).value = '';
							document.getElementById("other_money"+r).value = '';
						}					
					}
					document.getElementById("total_cost_value").value = commaSplit(0);
					document.getElementById("total_cost2_value").value = commaSplit(0);				
				}
				else
				{
					degistir(1);
				}
			}
		}
		calculate_type_deger = calculate_type_value;
		return true;
	}
	
	function hepsi()
	{
		deger = document.getElementById("pack_emp_name0").value;
		deger2 = document.getElementById("pack_emp_id0").value;
	
		for(var i=1;i<=document.getElementById('record_num_other').value;i++)
		{
			nesne_ = document.getElementById("pack_emp_name"+i);
			nesne_.value = deger;
			nesne2_ = document.getElementById("pack_emp_id"+i);
			nesne2_.value = deger2;
		}
	}
	
	function pencere_ac_(no)
	{
		if (document.getElementById("sending_country_id").value == "")
		{
			alert("<cf_get_lang dictionary_id ='45654.İlk Olarak Ülke Seçiniz'> !");
		}	
		else if(document.getElementById("sending_city_id").value == "")
		{
			alert("<cf_get_lang dictionary_id ='45491.İl Seçiniz'> !");
		}
		else
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=add_packet_ship.sending_county_id&field_name=add_packet_ship.sending_county&city_id=' + document.getElementById("sending_city_id").value,'','ui-draggable-box-small');
			document.getElementById("sending_county_id").value = '';
			document.getElementById("sending_county").value = '';
		}
	}
	
	function pencere_ac_city()
	{
		if (document.getElementById("sending_country_id").value == "")
		{
			alert("<cf_get_lang dictionary_id ='45654.İlk Olarak Ülke Seçiniz'> !");
		}	
		else
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_city&field_id=add_packet_ship.sending_city_id&field_name=add_packet_ship.sending_city&country_id=' + document.getElementById("sending_country_id").value,'','ui-draggable-box-small');
		}
		return remove_adress('2');
	}
	
	function remove_adress(parametre)
	{
		if(parametre==1)
		{
			document.getElementById("sending_city_id").value = '';
			document.getElementById("sending_city").value = '';
			document.getElementById("sending_county_id").value = '';
			document.getElementById("sending_county").value = '';
		}
		else
		{
			document.getElementById("sending_county_id").value = '';
			document.getElementById("sending_county").value = '';
		}	
	}
	<cfif isdefined("attributes.is_logistic") and len(attributes.is_logistic)>
		<cfoutput query="add_logistic">
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			document.getElementById("record_num").value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'"  id="row_kontrol' + row_count +'" value="1"> <a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="ship_id' + row_count +'" id="ship_id' + row_count +'" value="#ship_id#"><div class="form-group"><div class="input-group"><input type="text" name="ship_number' + row_count +'" value="#ship_number#" readonly><span class="input-group-addon icon-ellipsis" onClick="pencere_ac('+ row_count +');"></span></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="#dateformat(ship_date,dateformat_style)#" readonly></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			<cfif len(company_id)>
				newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="#get_company.nickname[listfind(main_company_list,company_id,',')]#" readonly></div>';
			<cfelse>
				newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="#get_consumer.consumer_name[listfind(main_consumer_list,consumer_id,',')]# #get_consumer.consumer_surname[listfind(main_consumer_list,consumer_id,',')]#" readonly></div>';
			</cfif>
			<cfif len(ship_method)>
				<cfquery name="GET_SHIP_METHOD" datasource="#dsn#"> 
					SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #ship_method#
				</cfquery>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="#get_ship_method.ship_method#" readonly></div>';
			<cfelse>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly></div>';
			</cfif>
			<cfset temp_ = Replace(address,"'","","")>;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="#temp_#" readonly></div>';
		</cfoutput>
		<cfif get_control_.recordcount>
			alert('<cf_get_lang dictionary_id ="45767.Daha Önce Sevk Edilmiş Kayıtlar"> : <cfoutput>#valuelist(get_control_.ship_number)#</cfoutput>');
		</cfif>
	</cfif>
	<cfif isdefined("attributes.is_logistic2")>
		<cfoutput query="add_logistic2">
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);		
			document.getElementById("record_num").value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input  type="hidden" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'" value="1"><a onclick="sil(' + row_count + ');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="hidden" name="ship_id' + row_count +'"  id="ship_id' + row_count +'" value="#ship_id#"><div class="form-group"><div class="input-group"><input type="text" name="ship_number' + row_count +'" value="#ship_number#" readonly><span class="input-group-addon icon-ellipsis" onClick="pencere_ac('+ row_count +');"></span></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="ship_date' + row_count +'" id="ship_date' + row_count +'" value="#dateformat(ship_date,dateformat_style)#" readonly></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_deliver' + row_count +'" id="ship_deliver' + row_count +'" value="#member_name#" readonly></div>';
			<cfif len(ship_method)>
				<cfquery name="GET_SHIP_METHOD" datasource="#DSN#"> 
					SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = #ship_method#
				</cfquery>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="#get_ship_method.ship_method#" readonly></div>';
			<cfelse>
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_type' + row_count +'" id="ship_type' + row_count +'" value="" readonly></div>';
			</cfif>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><input type="text" name="ship_adress' + row_count +'" id="ship_adress' + row_count +'" value="#address#" readonly></div>';
		</cfoutput>
		<cfif get_control_.recordcount>
			alert('<cf_get_lang dictionary_id ='45767.Daha Önce Sevk Edilmiş Kayıtlar'> : <cfoutput>#valuelist(get_control_.ship_number)#</cfoutput>');
		</cfif>
	</cfif>	
</script>
