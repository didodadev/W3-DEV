<!--- Not: GET_ALL_SHIP_RESULT querysindeki degisiklikler mutlaka alttaki iki queryde de yapılmali. BK 20060226 --->
<cfparam name="attributes.module_id_control" default="13">
<cfinclude template="report_authority_control.cfm">
<cfsetting showdebugoutput="no">
<cfparam name="attributes.is_view_graph" default="">
<cfparam name="attributes.graph_type" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.companycat_id" default="">
<cfparam name="attributes.customer_value_id" default="">
<cfparam name="attributes.resource_id" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.sales_county_id" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_name" default="">
<cfparam name="attributes.transport_comp_id" default="">
<cfparam name="attributes.transport_comp_name" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.comp_name" default="">
<cfparam name="attributes.ship_method_id" default="">
<cfparam name="attributes.ship_method_name" default="">
<cfparam name="attributes.city_id" default="">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.is_excel" default="">
<cfsavecontent variable="message"><cf_get_lang no ='536.Müşteri Bazında'></cfsavecontent>
<cfsavecontent variable="message1"><cf_get_lang no ='537.Müşteri Kategori Bazında'></cfsavecontent>
<cfsavecontent variable="message2"><cf_get_lang no ='538.Müşteri Değeri Bazında'></cfsavecontent>
<cfsavecontent variable="message3"><cf_get_lang no ='539.İlişki Şekli Bazında'></cfsavecontent>
<cfsavecontent variable="message4"><cf_get_lang no ='541.Satış Bölgesi Bazında'></cfsavecontent>
<cfsavecontent variable="message5"><cf_get_lang no ='542.Müşteri Temsilci Bazında'></cfsavecontent>
<cfsavecontent variable="message6"><cf_get_lang no ='545.Taşıyıcı Firma Bazında'></cfsavecontent>
<cfsavecontent variable="message7"><cf_get_lang no ='546.Sevkiyat Bazında'></cfsavecontent>
<cfsavecontent variable="message8"><cf_get_lang no ='1556.Şehir Bazında'></cfsavecontent>
<cfif attributes.is_excel eq 0><!--- excel alınırken ColdFusion was unable to add the header hatası nedeniyle bu kontrol eklendi --->
	<cfflush interval="3000">
</cfif>
<cfset list_report_type = "#message#,#message1#,#message2#,#message3#,#message4#,#message5#,#message6#,#message7#,#message8#">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('m',-1,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('m',1,attributes.start_date)>
</cfif>

<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
	SELECT 
		COMPANYCAT_ID, 
		COMPANYCAT 
	FROM 
		COMPANY_CAT
	ORDER BY
		COMPANYCAT
</cfquery>

<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	SELECT
		CUSTOMER_VALUE_ID,
		CUSTOMER_VALUE 
	FROM
		SETUP_CUSTOMER_VALUE
	ORDER BY
		CUSTOMER_VALUE
</cfquery>

<cfquery name="SZ" datasource="#DSN#">
	SELECT
		SZ_ID,
		SZ_NAME
	FROM
		SALES_ZONES
	ORDER BY
		SZ_NAME
</cfquery>

<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT
		CITY_ID,
		CITY_NAME
	FROM 
		SETUP_CITY
	ORDER BY
		CITY_NAME
</cfquery>


<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_ALL_SHIP_RESULT" datasource="#DSN2#">
		SELECT
		  <cfif attributes.report_type eq 1>
		  	'COMPANY_ID' DEGISKEN_TYPE, 
			C.COMPANY_ID DEGISKEN_ID,
			C.FULLNAME DEGISKEN,
		  <cfelseif attributes.report_type eq 2>
		  	'COMPANYCAT_ID' DEGISKEN_TYPE, 
			CC.COMPANYCAT_ID DEGISKEN_ID,
			CC.COMPANYCAT DEGISKEN,
		  <cfelseif attributes.report_type eq 3>
		  	'COMPANY_VALUE_ID' DEGISKEN_TYPE, 
			SCV.CUSTOMER_VALUE_ID DEGISKEN_ID,
			SCV.CUSTOMER_VALUE DEGISKEN,			
		  <cfelseif attributes.report_type eq 4>
		  	'RESOURCE_ID' DEGISKEN_TYPE, 
			CPR.RESOURCE_ID DEGISKEN_ID,
			CPR.RESOURCE DEGISKEN,
		  <cfelseif attributes.report_type eq 5>
		  	'SALES_COUNTY' DEGISKEN_TYPE, 
			SZ.SZ_ID DEGISKEN_ID,
			SZ.SZ_NAME DEGISKEN,
		  <cfelseif attributes.report_type eq 6>
		  	'POSITION_CODE' DEGISKEN_TYPE, 
			EP.POSITION_CODE DEGISKEN_ID,
			EP.EMPLOYEE_NAME + ' ' + EP.EMPLOYEE_SURNAME AS DEGISKEN,
		  <cfelseif attributes.report_type eq 7>
		  	'SERVICE_COMPANY_ID' DEGISKEN_TYPE, 
			C2.COMPANY_ID DEGISKEN_ID,
			C2.FULLNAME DEGISKEN,
		  <cfelseif attributes.report_type eq 9>
		  	'CITY' DEGISKEN_TYPE, 
			SC.CITY_ID DEGISKEN_ID,
			SC.CITY_NAME DEGISKEN,			
		  <cfelseif attributes.report_type eq 8>
		  	'SHIP_RESULT_ID' DEGISKEN_TYPE, 
			SR.SHIP_RESULT_ID DEGISKEN_ID,
			SR.SHIP_FIS_NO DEGISKEN,
			C3.FULLNAME,
			SM.SHIP_METHOD,
			SM.SHIP_METHOD_ID,
		  </cfif>
		  	C.COMPANYCAT_ID,
			C.COMPANY_VALUE_ID,
			C.RESOURCE_ID,
			C.SALES_COUNTY,
			C.CITY,
 			SR.SHIP_RESULT_ID,
		  	SR.COMPANY_ID,
			ISNULL(SR.COST_VALUE,0) COST_VALUE,
			ISNULL(SR.COST_VALUE2,0) COST_VALUE2,
			SR.OUT_DATE,
			SR.DELIVERY_DATE,
			SR.SERVICE_COMPANY_ID,
			ISNULL(SRP.PACKAGE_PIECE,0) PACKAGE_PIECE,	
			ISNULL(SRP.PACKAGE_DIMENTION,0) PACKAGE_DIMENTION,
			ISNULL(SRP.PACKAGE_WEIGHT,0) PACKAGE_WEIGHT
			<cfif attributes.report_type eq 6 or (len(attributes.pos_code) and len(attributes.pos_code_name))>
			,WEP.POSITION_CODE
			</cfif>
		FROM
			#dsn_alias#.COMPANY C,
			<cfif attributes.report_type eq 2>#dsn_alias#.COMPANY_CAT CC,
			<cfelseif attributes.report_type eq 3>#dsn_alias#.SETUP_CUSTOMER_VALUE SCV,
			<cfelseif attributes.report_type eq 4>#dsn_alias#.COMPANY_PARTNER_RESOURCE CPR,
			<cfelseif attributes.report_type eq 5>#dsn_alias#.SALES_ZONES SZ,
			<cfelseif attributes.report_type eq 6>#dsn_alias#.EMPLOYEE_POSITIONS EP,
			<cfelseif attributes.report_type eq 7>#dsn_alias#.COMPANY C2,
			<cfelseif attributes.report_type eq 9>#dsn_alias#.SETUP_CITY SC,
			<cfelseif attributes.report_type eq 8>#dsn_alias#.COMPANY C3,#dsn_alias#.SHIP_METHOD SM,
			</cfif>
			<cfif attributes.report_type eq 6 or (len(attributes.pos_code) and len(attributes.pos_code_name))>
			#dsn_alias#.WORKGROUP_EMP_PAR WEP,
			</cfif>
			SHIP_RESULT SR LEFT JOIN 
			SHIP_RESULT_PACKAGE SRP ON SR.SHIP_RESULT_ID = SRP.SHIP_ID
		WHERE
        	SR.COMPANY_ID = C.COMPANY_ID
			<cfif attributes.report_type eq 6 or (len(attributes.pos_code) and len(attributes.pos_code_name))>
			AND WEP.COMPANY_ID = C.COMPANY_ID
			</cfif>			
			<cfif attributes.report_type eq 2> AND C.COMPANYCAT_ID = CC.COMPANYCAT_ID 
			<cfelseif attributes.report_type eq 3>AND C.COMPANY_VALUE_ID = SCV.CUSTOMER_VALUE_ID
			<cfelseif attributes.report_type eq 4>AND C.RESOURCE_ID = CPR.RESOURCE_ID
			<cfelseif attributes.report_type eq 5>AND C.SALES_COUNTY = SZ.SZ_ID
			<cfelseif attributes.report_type eq 6>AND WEP.POSITION_CODE = EP.POSITION_CODE AND EP.IS_MASTER = 1 AND WEP.IS_MASTER = 1
			<cfelseif attributes.report_type eq 7>AND SR.SERVICE_COMPANY_ID = C2.COMPANY_ID 
			<cfelseif attributes.report_type eq 9>AND C.CITY = SC.CITY_ID 
			<cfelseif attributes.report_type eq 8>AND SR.SERVICE_COMPANY_ID = C3.COMPANY_ID AND	SR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID			
			</cfif>
			<cfif len(attributes.companycat_id)>AND C.COMPANYCAT_ID = #attributes.companycat_id#</cfif>
			<cfif len(attributes.customer_value_id)>AND C.COMPANY_VALUE_ID = #attributes.customer_value_id#</cfif>
			<cfif len(attributes.resource_id)>AND C.RESOURCE_ID = #attributes.resource_id#</cfif>
			<cfif len(attributes.sales_county_id)>AND C.SALES_COUNTY = #attributes.sales_county_id#</cfif>
			<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>AND C.IMS_CODE_ID = #attributes.ims_code_id#</cfif>
			<cfif len(attributes.pos_code) and len(attributes.pos_code_name)>AND WEP.POSITION_CODE = #attributes.pos_code# AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#</cfif>
			<cfif len(attributes.transport_comp_id) and len(attributes.transport_comp_name)>AND SR.SERVICE_COMPANY_ID = #attributes.transport_comp_id#</cfif>
			<cfif len(attributes.ship_method_id) and len(attributes.ship_method_name) and attributes.report_type eq 8>AND SM.SHIP_METHOD_ID = #attributes.ship_method_id#</cfif>
			<cfif len(attributes.comp_id) and len(attributes.comp_name)>AND SR.COMPANY_ID = #attributes.comp_id#</cfif>
			<cfif len(attributes.city_id)>AND C.CITY = #attributes.city_id#</cfif>
			AND SR.OUT_DATE >= #attributes.start_date# AND SR.OUT_DATE <= #attributes.finish_date#			
	</cfquery>
	<!--- Tutarlar icin group by--->
	<cfif get_all_ship_result.recordcount>
		<cfquery name="GET_ALL_SHIP_COST_VALUE" datasource="#DSN2#">
			SELECT
			  <cfif attributes.report_type eq 1>
				C.COMPANY_ID,
			  <cfelseif attributes.report_type eq 2>
				C.COMPANYCAT_ID,
			  <cfelseif attributes.report_type eq 3>
				C.COMPANY_VALUE_ID,
			  <cfelseif attributes.report_type eq 4>
				C.RESOURCE_ID,
			  <cfelseif attributes.report_type eq 5>
				C.SALES_COUNTY,
			  <cfelseif attributes.report_type eq 6>
				WEP.POSITION_CODE,
			  <cfelseif attributes.report_type eq 7>
				SR.SERVICE_COMPANY_ID,
			  <cfelseif attributes.report_type eq 9>
				C.CITY,				
			  <cfelseif attributes.report_type eq 8>
				SR.SHIP_RESULT_ID,
			  </cfif>
				ISNULL(SUM(COST_VALUE),0) COST_VALUE,
				ISNULL(SUM(COST_VALUE2),0) COST_VALUE2
			FROM
				SHIP_RESULT SR,
				#dsn_alias#.COMPANY C
				<cfif attributes.report_type eq 7>,#dsn_alias#.COMPANY C2</cfif>
				<cfif attributes.report_type eq 6>,#dsn_alias#.WORKGROUP_EMP_PAR WEP</cfif>
			WHERE
				SHIP_RESULT_ID IN 
				( 
					SELECT
						SR.SHIP_RESULT_ID
					FROM
						#dsn_alias#.COMPANY C,
						<cfif attributes.report_type eq 2>#dsn_alias#.COMPANY_CAT CC,
						<cfelseif attributes.report_type eq 3>#dsn_alias#.SETUP_CUSTOMER_VALUE SCV,
						<cfelseif attributes.report_type eq 4>#dsn_alias#.COMPANY_PARTNER_RESOURCE CPR,
						<cfelseif attributes.report_type eq 5>#dsn_alias#.SALES_ZONES SZ,
						<cfelseif attributes.report_type eq 6>#dsn_alias#.EMPLOYEE_POSITIONS EP,
						<cfelseif attributes.report_type eq 7>#dsn_alias#.COMPANY C2,
						<cfelseif attributes.report_type eq 9>#dsn_alias#.SETUP_CITY SC2,
						<cfelseif attributes.report_type eq 8>#dsn_alias#.COMPANY C3,#dsn_alias#.SHIP_METHOD SM,
						</cfif>
						<cfif attributes.report_type eq 6 or (len(attributes.pos_code) and len(attributes.pos_code_name))>
						#dsn_alias#.WORKGROUP_EMP_PAR WEP,
						</cfif>
						SHIP_RESULT SR,
						SHIP_RESULT_PACKAGE SRP
					WHERE
                    	SR.COMPANY_ID = C.COMPANY_ID
						<cfif attributes.report_type eq 6 or (len(attributes.pos_code) and len(attributes.pos_code_name))>
						AND WEP.COMPANY_ID = C.COMPANY_ID
						</cfif>						
						<cfif attributes.report_type eq 2> AND C.COMPANYCAT_ID = CC.COMPANYCAT_ID
						<cfelseif attributes.report_type eq 3>AND C.COMPANY_VALUE_ID = SCV.CUSTOMER_VALUE_ID
						<cfelseif attributes.report_type eq 4>AND C.RESOURCE_ID = CPR.RESOURCE_ID
						<cfelseif attributes.report_type eq 5>AND C.SALES_COUNTY = SZ.SZ_ID
						<cfelseif attributes.report_type eq 6>AND WEP.POSITION_CODE = EP.POSITION_CODE AND EP.IS_MASTER = 1 AND WEP.IS_MASTER = 1
						<cfelseif attributes.report_type eq 7>AND SR.SERVICE_COMPANY_ID = C2.COMPANY_ID
						<cfelseif attributes.report_type eq 9>AND C.CITY = SC2.CITY_ID
						<cfelseif attributes.report_type eq 8>AND SR.SERVICE_COMPANY_ID = C3.COMPANY_ID AND	SR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID		
						</cfif>
						AND SR.SHIP_RESULT_ID = SRP.SHIP_ID
						<cfif len(attributes.companycat_id)>AND C.COMPANYCAT_ID = #attributes.companycat_id#</cfif>
						<cfif len(attributes.customer_value_id)>AND C.COMPANY_VALUE_ID = #attributes.customer_value_id#</cfif>
						<cfif len(attributes.resource_id)>AND C.RESOURCE_ID = #attributes.resource_id#</cfif>
						<cfif len(attributes.sales_county_id)>AND C.SALES_COUNTY = #attributes.sales_county_id#</cfif>
						<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>AND C.IMS_CODE_ID = #attributes.ims_code_id#</cfif>
						<cfif len(attributes.pos_code) and len(attributes.pos_code_name)>AND WEP.POSITION_CODE = #attributes.pos_code# AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#</cfif>
						<cfif len(attributes.transport_comp_id) and len(attributes.transport_comp_name)>AND SR.SERVICE_COMPANY_ID = #attributes.transport_comp_id#</cfif>
						<cfif len(attributes.ship_method_id) and len(attributes.ship_method_name) and attributes.report_type eq 8>AND SM.SHIP_METHOD_ID = #attributes.ship_method_id#</cfif>
						<cfif len(attributes.comp_id) and len(attributes.comp_name)>AND SR.COMPANY_ID = #attributes.comp_id#</cfif>
						<cfif len(attributes.city_id)>AND C.CITY = #attributes.city_id#</cfif>
						AND SR.OUT_DATE >= #attributes.start_date# AND SR.OUT_DATE <= #attributes.finish_date#	
				) AND
				SR.COMPANY_ID = C.COMPANY_ID
				<cfif attributes.report_type eq 7>AND SR.SERVICE_COMPANY_ID = C2.COMPANY_ID</cfif>			
			GROUP BY
			  <cfif attributes.report_type eq 1>
				C.COMPANY_ID
			  <cfelseif attributes.report_type eq 2>
				C.COMPANYCAT_ID
			  <cfelseif attributes.report_type eq 3>
				C.COMPANY_VALUE_ID			
			  <cfelseif attributes.report_type eq 4>
				C.RESOURCE_ID
			  <cfelseif attributes.report_type eq 5>
				C.SALES_COUNTY
			  <cfelseif attributes.report_type eq 6>
				WEP.POSITION_CODE
			  <cfelseif attributes.report_type eq 7>
				SR.SERVICE_COMPANY_ID
			  <cfelseif attributes.report_type eq 9>
				C.CITY
			  <cfelseif attributes.report_type eq 8>
				SR.SHIP_RESULT_ID				
			  </cfif>
		</cfquery>
	</cfif>
	<cfif attributes.report_type eq 8><!--- Irsaliyeler icin --->
	  <cfif get_all_ship_result.recordcount>
		<cfquery name="GET_ALL_SHIP_RESULT_ROW" datasource="#DSN2#">
			SELECT
				SRR.SHIP_RESULT_ID,
				SRR.SHIP_ID,
				SRR.SHIP_DATE,
				S.SHIP_NUMBER
			FROM
				SHIP_RESULT_ROW SRR,
				SHIP S
			WHERE
				SRR.SHIP_RESULT_ID IN 
				(
					SELECT
						SR.SHIP_RESULT_ID
					FROM
						#dsn_alias#.COMPANY C,
						<cfif attributes.report_type eq 2>#dsn_alias#.COMPANY_CAT CC,
						<cfelseif attributes.report_type eq 3>#dsn_alias#.SETUP_CUSTOMER_VALUE SCV,
						<cfelseif attributes.report_type eq 4>#dsn_alias#.COMPANY_PARTNER_RESOURCE CPR,
						<cfelseif attributes.report_type eq 5>#dsn_alias#.SALES_ZONES SZ,
						<cfelseif attributes.report_type eq 6>#dsn_alias#.EMPLOYEE_POSITIONS EP,
						<cfelseif attributes.report_type eq 7>#dsn_alias#.COMPANY C2,
						<cfelseif attributes.report_type eq 9>#dsn_alias#.SETUP_CITY ST2,
						<cfelseif attributes.report_type eq 8>#dsn_alias#.COMPANY C3,#dsn_alias#.SHIP_METHOD SM,
						</cfif>
						<cfif attributes.report_type eq 6 or (len(attributes.pos_code) and len(attributes.pos_code_name))>
						#dsn_alias#.WORKGROUP_EMP_PAR WEP,
						</cfif>
						SHIP_RESULT SR LEFT JOIN 
						SHIP_RESULT_PACKAGE SRP ON SR.SHIP_RESULT_ID = SRP.SHIP_ID
					WHERE
						<cfif attributes.report_type eq 6 or (len(attributes.pos_code) and len(attributes.pos_code_name))>
						WEP.COMPANY_ID = C.COMPANY_ID  AND
						</cfif>
						SR.COMPANY_ID = C.COMPANY_ID AND
						<cfif attributes.report_type eq 2>C.COMPANYCAT_ID = CC.COMPANYCAT_ID
						<cfelseif attributes.report_type eq 3>C.COMPANY_VALUE_ID = SCV.CUSTOMER_VALUE_ID 
						<cfelseif attributes.report_type eq 4>C.RESOURCE_ID = CPR.RESOURCE_ID 
						<cfelseif attributes.report_type eq 5>C.SALES_COUNTY = SZ.SZ_ID
						<cfelseif attributes.report_type eq 6>WEP.POSITION_CODE = EP.POSITION_CODE AND EP.IS_MASTER = 1 AND WEP.IS_MASTER = 1
						<cfelseif attributes.report_type eq 7>SR.SERVICE_COMPANY_ID = C2.COMPANY_ID 
						<cfelseif attributes.report_type eq 9>C.CITY_ID = SC2.CITY_ID					
						<cfelseif attributes.report_type eq 8>SR.SERVICE_COMPANY_ID = C3.COMPANY_ID AND	SR.SHIP_METHOD_TYPE = SM.SHIP_METHOD_ID		
						</cfif>
						<cfif len(attributes.companycat_id)>AND C.COMPANYCAT_ID = #attributes.companycat_id#</cfif>
						<cfif len(attributes.customer_value_id)>AND C.COMPANY_VALUE_ID = #attributes.customer_value_id#</cfif>
						<cfif len(attributes.resource_id)>AND C.RESOURCE_ID = #attributes.resource_id#</cfif>
						<cfif len(attributes.sales_county_id)>AND C.SALES_COUNTY = #attributes.sales_county_id#</cfif>
						<cfif len(attributes.ims_code_id) and len(attributes.ims_code_name)>AND C.IMS_CODE_ID = #attributes.ims_code_id#</cfif>
						<cfif len(attributes.pos_code) and len(attributes.pos_code_name)>AND WEP.POSITION_CODE = #attributes.pos_code# AND WEP.IS_MASTER = 1 AND WEP.OUR_COMPANY_ID = #session.ep.company_id#</cfif>
						<cfif len(attributes.transport_comp_id) and len(attributes.transport_comp_name)>AND SR.SERVICE_COMPANY_ID = #attributes.transport_comp_id#</cfif>
						<cfif len(attributes.ship_method_id) and len(attributes.ship_method_name) and attributes.report_type eq 8>AND SM.SHIP_METHOD_ID = #attributes.ship_method_id#</cfif>
						<cfif len(attributes.comp_id) and len(attributes.comp_name)>AND SR.COMPANY_ID = #attributes.comp_id#</cfif>
						<cfif len(attributes.city_id)>AND C.CITY = #attributes.city_id#</cfif>
						AND SR.OUT_DATE >= #attributes.start_date# AND SR.OUT_DATE <= #attributes.finish_date#	
						
				) AND
				<!--- BK 120 gune siline 20070226 SRR.SHIP_RESULT_ID IN (#listdeleteduplicates(valuelist(get_all_ship_result.ship_result_id,','))#) AND --->
				SRR.SHIP_ID = S.SHIP_ID
		</cfquery>
	  </cfif>
	</cfif>	
<cfelse>
	<cfset get_all_ship_result.recordcount = 0>
</cfif>
<cfform name="list_ship_result" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
<cf_report_list_search title="#getLang('report',306)#">
<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='521.Müşteri Kategorisi'></label>
										<div class="col col-12 col-xs-12">
											<select name="companycat_id" id="companycat_id">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="get_companycat">
														<option value="#companycat_id#"<cfif companycat_id eq attributes.companycat_id> selected</cfif>>#companycat#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1140.Müşteri Değeri'></label>
										<div class="col col-12 col-xs-12">
											<select name="customer_value_id" id="customer_value_id">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="get_customer_value">
														<option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value_id> selected</cfif>>#customer_value#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='247.Satış Bölgesi'></label>
										<div class="col col-12 col-xs-12">
											<select name="sales_county_id" id="sales_county_id">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="sz">
														<option value="#sz_id#" <cfif sz_id eq attributes.sales_county_id> selected</cfif>>#sz_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='559.Sehir'></label>
										<div class="col col-12 col-xs-12">
											<select name="city_id" id="city_id">
												<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
												<cfoutput query="get_city">
														<option value="#city_id#" <cfif city_id eq attributes.city_id> selected</cfif>>#city_name#</option>
												</cfoutput>
											</select>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1418.İlişki Şekli'></label>
										<div class="col col-12 col-xs-12">
											<cf_wrk_combo
												name="resource_id"
												query_name="GET_PARTNER_RESOURCE"
												option_name="resource"
												option_value="resource_id"
												value="#attributes.resource_id#"
												width="150">
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1383.Müşteri Temsilci'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#attributes.pos_code#</cfoutput>">
												<input type="text" name="pos_code_name" id="pos_code_name" value="<cfoutput>#attributes.pos_code_name#</cfoutput>">
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_ship_result.pos_code&field_code=list_ship_result.pos_code&field_name=list_ship_result.pos_code_name&select_list=1,9','list');return false"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang no='527.Taşıyıcı Firma'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="transport_comp_id" id="transport_comp_id" value="<cfoutput>#attributes.transport_comp_id#</cfoutput>">
												<input type="text" name="transport_comp_name" id="transport_comp_name" value="<cfoutput>#attributes.transport_comp_name#</cfoutput>">
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=list_ship_result.transport_comp_id&field_comp_name=list_ship_result.transport_comp_name&select_list=2','list');"> </span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1703.Sevkiyat Yöntemi'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="ship_method_id" id="ship_method_id" value="<cfif isdefined("attributes.ship_method_id")><cfoutput>#attributes.ship_method_id#</cfoutput></cfif>">
												<input type="text" name="ship_method_name" id="ship_method_name" value="<cfif isdefined("attributes.ship_method_name")><cfoutput>#attributes.ship_method_name#</cfoutput></cfif>" readonly>
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=list_ship_result.ship_method_name&field_id=list_ship_result.ship_method_id','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='722.Mikro Bölge Kodu'> </label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
												<input type="text" name="ims_code_name" id="ims_code_name" value="<cfoutput>#attributes.ims_code_name#</cfoutput>">
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ims_code&field_name=list_ship_result.ims_code_name&field_id=list_ship_result.ims_code_id','list');"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="comp_id" id="comp_id" value="<cfoutput>#attributes.comp_id#</cfoutput>">
												<input type="text" name="comp_name" id="comp_name" value="<cfoutput>#attributes.comp_name#</cfoutput>">
												<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=list_ship_result.comp_id&field_comp_name=list_ship_result.comp_name&select_list=2','list');"> </span>
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-xs-12">
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='1548.Rapor Tipi'></label>
										<div class="col col-12 col-xs-12">
											<select name="report_type" id="report_type" >
												<option value="1" <cfif attributes.report_type eq 1> selected</cfif>> <cf_get_lang no='536.Müşteri Bazında'></option>
												<option value="2" <cfif attributes.report_type eq 2> selected</cfif>> <cf_get_lang no='537.Müşteri Kategori Bazında'></option>
												<option value="3" <cfif attributes.report_type eq 3> selected</cfif>> <cf_get_lang no='538.Müşteri Değeri Bazında'></option>
												<option value="4" <cfif attributes.report_type eq 4> selected</cfif>> <cf_get_lang no='539.İlişki Şekli Bazında'></option>
												<option value="5" <cfif attributes.report_type eq 5> selected</cfif>> <cf_get_lang no='541.Satış Bölgesi Bazında'></option>
												<option value="6" <cfif attributes.report_type eq 6> selected</cfif>> <cf_get_lang no='542.Müşteri Temsilci Bazında'></option>
												<option value="7" <cfif attributes.report_type eq 7> selected</cfif>> <cf_get_lang no='545.Taşıyıcı Firma Bazında'></option>
												<option value="9" <cfif attributes.report_type eq 9> selected</cfif>> <cf_get_lang no ='1556.Şehir Bazında'></option>
												<option value="8" <cfif attributes.report_type eq 8> selected</cfif>> <cf_get_lang no='546.Sevkiyat Bazında'></option>
											</select>	
										</div>
									</div>
									<div class="form-group">
										<label class="col col-12 col-xs-12"><cf_get_lang_main no='330.Tarih'>*</label>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='641.Başlangıç Tarihi'></cfsavecontent>
												<cfinput type="text" name="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" required="yes" validate="#validate_style#" message="#message#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
											</div>
										</div>
										<div class="col col-6">
											<div class="input-group">
												<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
												<cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" required="yes" validate="#validate_style#" message="#message#">
												<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="col col-12 col-xs-12"></div>
										<div class="col col-12 col-xs-12">
												<select name="graph_type" id="graph_type"<cfif attributes.is_view_graph neq 1> disabled</cfif>>
														<option value="" selected><cf_get_lang_main no='538.Grafik Format'></option>
														<option value="pie" <cfif attributes.graph_type eq 'pie'> selected</cfif>>Pie</option>
														<option value="bar"<cfif attributes.graph_type eq 'bar'> selected</cfif>>Bar</option>
												</select>
										</div>
									</div>
									<div class="form-group">
										<div class="col col-12 col-xs-12"></div>
										<div class="col col-12 col-xs-12">
											<label clas="col col-12"><cf_get_lang_main no ='1284.Grafik'><input type="checkbox" name="is_view_graph" id="is_view_graph" value="1" onClick="disab_enabl()" <cfif attributes.is_view_graph eq 1>checked</cfif>></label>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
						<label><cf_get_lang_main no='446.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
									<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input type="hidden" name="form_submitted" id="form_submitted" value="">
							<cf_wrk_report_search_button button_type='1' is_excel='1' search_function='control()'>
						</div>
					</div>
				</div>
			</div>
</cf_report_list_search_area>
</cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename="ship_result_analyse_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-8">
</cfif>
 <cfif isdefined("attributes.form_submitted")>
<cf_report_list>			
    	<thead>
            <tr>
            <cfif attributes.report_type neq 8>
                <th width="35"><cf_get_lang_main no='75.No'></td>
                <th width="500"><cfif len(attributes.report_type)><cfoutput>#listgetat(list_report_type,attributes.report_type,',')#</cfoutput><cfelse><cf_get_lang no='570.Rapor Tipinde Seçilen Baz'></cfif></th>
                <th width="100"><cf_get_lang no ='1555.Desi'></th>
                <th width="100"><cf_get_lang no ='1888.Kg'></th>
                <th width="100"><cf_get_lang no='556.Paket Sayısı'></th>
                <th width="100"><cf_get_lang_main no='846.Maliyet'> <cfoutput>#session.ep.money#</cfoutput></th>
                <th width="100"><cf_get_lang_main no='846.Maliyet'> USD</th>
            <cfelse>
                <th width="35"><cf_get_lang_main no='75.No'></th>
                <th width="70"><cf_get_lang no='560.Sevk No'></th>
                <th><cf_get_lang no='527.Taşıyıcı Firma'></th>
                <th width="200"><cf_get_lang_main no='726.İrsaliye No'></th>
                <th width="100"><cf_get_lang no='563.Depo Çıkış Tar.'></th>
                <th><cf_get_lang no='565.İrsaliye Tarihleri'></th>
                <th width="100"><cf_get_lang_main no='233.Teslim Tar.'></th>
                <th width="100"><cf_get_lang_main no='1703.Sevk Yöntemi'></th>
                <th width="100"><cf_get_lang no ='1555.Desi'></th>
                <th width="100"><cf_get_lang no ='1888.Kg'></th>
                <th width="100"><cf_get_lang no='556.Paket Sayısı'></th>
                <th width="100"><cf_get_lang_main no='846.Maliyet'> <cfoutput>#session.ep.money#</cfoutput></th>
                <th width="100"><cf_get_lang_main no='846.Maliyet'> USD</th>
            </cfif>
            </tr>
      </thead>
	<cfquery name="GET_SHIP_RESULT" dbtype="query"><!--- diger kriterlere goreyse buraya gir --->
		SELECT DISTINCT
			DEGISKEN_TYPE,
			DEGISKEN_ID,
			DEGISKEN
		FROM
			GET_ALL_SHIP_RESULT
		<!--- ORDER BY
			DEGISKEN --->
	</cfquery>
	<cfset page_desi_total=0>
	<cfset page_weight_total=0>
	<cfset page_piece_total=0>
	<cfset page_cost_total=0>
	<cfset page_cost2_total=0>
	<cfset net_desi_total=0>
	<cfset net_weight_total=0>
	<cfset net_piece_total=0>
	<cfset net_cost_total=0>
	<cfset net_cost2_total=0>		
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default='#get_ship_result.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>		
	<cfif get_ship_result.recordcount>
    <tbody>
	  <cfoutput query="get_ship_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<tr>
        <cfset 'sum_of_total#currentrow#' = 0>
		<td align="center" style="text-align:center;">#currentrow#</td>
		<td align="center" style="text-align:center;">#degisken#</td>
	 <cfif attributes.report_type eq 8>
		<td align="center" style="text-align:center;" width="200">
			<cfquery name="GET_SHIP_RESULT_DATE" dbtype="query" maxrows="1">
				SELECT
					OUT_DATE,
					DELIVERY_DATE,
					FULLNAME,
					SHIP_METHOD
				FROM
					GET_ALL_SHIP_RESULT
				WHERE
					#get_ship_result.degisken_type# = #get_ship_result.degisken_id#
			</cfquery>			  
			#get_ship_result_date.fullname#
		</td>
		<td align="center" style="text-align:center;">
			<cfquery name="GET_SHIP_RESULT_ROW" dbtype="query">
				SELECT
					*
				FROM
					GET_ALL_SHIP_RESULT_ROW
				WHERE
					#get_ship_result.degisken_type# = #get_ship_result.degisken_id#
			</cfquery>
			<cfloop from="1" to="#get_ship_result_row.recordcount#" index="kk">
				#get_ship_result_row.ship_number[kk]#<cfif get_ship_result_row.recordcount neq 1 and (get_ship_result_row.recordcount neq kk)>,</cfif>
			</cfloop>			  
		</td>
		<td align="center" style="text-align:center;" ><cfif len(get_ship_result_date.out_date)>#dateformat(get_ship_result_date.out_date,dateformat_style)#</cfif></td>
		<td align="center" style="text-align:center;"><cfloop from="1" to="#get_ship_result_row.recordcount#" index="mm">#dateformat(get_ship_result_row.ship_date[mm],dateformat_style)#<cfif get_ship_result_row.recordcount neq 1 and (get_ship_result_row.recordcount neq mm)>,</cfif></cfloop></td>
		<td align="center" style="text-align:center;"><cfif len(get_ship_result_date.delivery_date)>#dateformat(get_ship_result_date.delivery_date,dateformat_style)#</cfif></td>
		<td align="center" style="text-align:center;">#get_ship_result_date.ship_method#</td>			
	  </cfif>
		<td align="center" style="text-align:center;">
			<cfquery name="GET_DESI" dbtype="query">
				SELECT
					PACKAGE_PIECE,	
					PACKAGE_DIMENTION
					<cfif attributes.report_type eq 8>
					,FULLNAME
					</cfif>
				FROM
					GET_ALL_SHIP_RESULT
				WHERE
					PACKAGE_DIMENTION IS NOT NULL AND
					#get_ship_result.degisken_type# = #get_ship_result.degisken_id#
			</cfquery>
		 	<cfset satır_desi_total =0>
		 	<cfloop query="GET_DESI">
            	<cfif package_dimention neq 0>
				<cfset satır_desi_total = satır_desi_total +(listgetat(package_dimention,1,'*')* listgetat(package_dimention,2,'*') * listgetat(package_dimention,3,'*')/3000*(package_piece))>
                </cfif>
		  	</cfloop>
		  	#TlFormat(satır_desi_total)#<!--- Desi --->
		  	<cfset page_desi_total = page_desi_total+satır_desi_total>
		</td>
		<td align="center" style="text-align:center;">
		 	<cfquery name="GET_WEIGHT" dbtype="query">
				SELECT
					SUM(PACKAGE_WEIGHT*PACKAGE_PIECE) PACKAGE_WEIGHT
				FROM
					GET_ALL_SHIP_RESULT
				WHERE
					PACKAGE_WEIGHT IS NOT NULL AND
					#get_ship_result.degisken_type# = #get_ship_result.degisken_id#
			</cfquery>
		  	<cfif get_weight.package_weight gt 0>
				#TlFormat(get_weight.package_weight)#
				<cfset page_weight_total = page_weight_total+get_weight.package_weight>
		  	<cfelse>
				#TlFormat(0)#
		  	</cfif>
		</td>
		<td align="center" style="text-align:center;">
			<cfquery name="GET_PIECE" dbtype="query">
				SELECT
					SUM(PACKAGE_PIECE) PACKAGE_PIECE
				FROM
					GET_ALL_SHIP_RESULT
				WHERE
					#get_ship_result.degisken_type# = #get_ship_result.degisken_id#
					</cfquery>
					<cfif get_piece.package_piece gt 0>
					#TlFormat(get_piece.package_piece,0)#
					<cfset page_piece_total = page_piece_total+get_piece.package_piece>
					<cfelse>
					#TlFormat(0)#
			</cfif>
		</td>
		<td align="center" style="text-align:center;">			  
			<cfquery name="GET_SHIP_COST_VALUE" dbtype="query"> <!--- diger kriterlere goreyse buraya gir --->
				SELECT
					COST_VALUE,
					COST_VALUE2						
				FROM
					GET_ALL_SHIP_COST_VALUE
				WHERE
					#get_ship_result.degisken_type# = #get_ship_result.degisken_id#
			</cfquery>
            <cfif len(GET_SHIP_COST_VALUE.cost_value)>
				<cfset 'sum_of_total#currentrow#' = get_ship_cost_value.cost_value>
            <cfelse>
            	<cfset 'sum_of_total#currentrow#' = 0>
            </cfif>
			#TlFormat(get_ship_cost_value.cost_value)#
            <cfif get_ship_cost_value.cost_value gt 0>
			<cfset page_cost_total = page_cost_total + get_ship_cost_value.cost_value>
            </cfif>
		</td>
		<td align="center" style="text-align:center;">
		  	#TlFormat(get_ship_cost_value.cost_value2)#
            <cfif get_ship_cost_value.cost_value2 gt 0>
		  	<cfset page_cost2_total = page_cost2_total+get_ship_cost_value.cost_value2>
            </cfif>
		</td>
	</tr>
  </cfoutput>
    </tbody>
    <tbody>
        <tr>
					<cfoutput>
							<td class="txtbold" style="text-align:right;" <cfif attributes.report_type neq 8>colspan="2"<cfelse>colspan="8"</cfif>><cf_get_lang_main no='80.toplam'></td>
							<td align="center" style="text-align:center;">#TlFormat(page_desi_total)#</td>
							<td align="center" style="text-align:center;">#TlFormat(page_weight_total)#</td>
							<td align="center" style="text-align:center;">#TlFormat(page_piece_total,0)#</td>
							<td align="center" style="text-align:center;">#TlFormat(page_cost_total)#</td>
							<td align="center" style="text-align:center;">#TlFormat(page_cost2_total)#</td>
					</cfoutput>
        </tr>
	<!--- Genel Toplam ifadesini yazdırabilmek icin eklendi BK 20060927 --->
	<cfoutput query="get_ship_result" startrow="1" maxrows="#attributes.startrow+attributes.maxrows-1#">
		<cfquery name="GET_DESI_BLOCK" dbtype="query">
		SELECT
			PACKAGE_PIECE,	
			PACKAGE_DIMENTION
		  <cfif attributes.report_type eq 8>
			,FULLNAME
		  </cfif>
		FROM
			GET_ALL_SHIP_RESULT
		WHERE
			PACKAGE_DIMENTION IS NOT NULL AND
			#get_ship_result.degisken_type# = #get_ship_result.degisken_id#
		</cfquery>
		<cfset block_desi_total =0>
		<cfloop query="GET_DESI_BLOCK">
        	<cfif package_dimention neq 0>
			<cfset block_desi_total = block_desi_total +(listgetat(package_dimention,1,'*')* listgetat(package_dimention,2,'*') * listgetat(package_dimention,3,'*')/3000*(package_piece))>
            </cfif>
		</cfloop>
		<cfset net_desi_total = net_desi_total+block_desi_total>
		<cfquery name="GET_WEIGHT_BLOCK" dbtype="query">
			SELECT
				SUM(PACKAGE_WEIGHT*PACKAGE_PIECE) PACKAGE_WEIGHT
			FROM
				GET_ALL_SHIP_RESULT
			WHERE
				PACKAGE_WEIGHT IS NOT NULL AND
				#get_ship_result.degisken_type# = #get_ship_result.degisken_id#
		</cfquery>
		<cfif get_weight_block.package_weight gt 0>
		<cfset net_weight_total = net_weight_total+get_weight_block.package_weight>
	</cfif>
	
	<cfquery name="GET_PIECE_BLOCK" dbtype="query">
		SELECT
			SUM(PACKAGE_PIECE) PACKAGE_PIECE
		FROM
			GET_ALL_SHIP_RESULT
		WHERE
			#get_ship_result.degisken_type# = #get_ship_result.degisken_id#
	</cfquery>
	
	<cfif get_piece.package_piece gt 0>
		<cfset net_piece_total = net_piece_total+get_piece_block.package_piece>
	</cfif>
	<cfquery name="GET_SHIP_COST_VALUE_BLOCK" dbtype="query"> <!--- diger kriterlere goreyse buraya gir --->
		SELECT
			COST_VALUE,
			COST_VALUE2						
		FROM
			GET_ALL_SHIP_COST_VALUE
		WHERE
			#get_ship_result.degisken_type# = #get_ship_result.degisken_id#
	</cfquery>
    <cfif get_ship_cost_value_block.cost_value gt 0>
	<cfset net_cost_total = net_cost_total+get_ship_cost_value_block.cost_value>
    </cfif>
    <cfif get_ship_cost_value_block.cost_value2 gt 0>
	<cfset net_cost2_total = net_cost2_total+get_ship_cost_value_block.cost_value2>
    </cfif>
	</cfoutput>
	 <tr>
		<cfoutput>
		<td  class="txtbold" style="text-align:right;"  <cfif attributes.report_type neq 8>colspan="2"<cfelse>colspan="8"</cfif>><cf_get_lang_main no='268.Genel Toplam'></td>
		<td align="center" style="text-align:center;">#TlFormat(net_desi_total)#</td>
		<td align="center" style="text-align:center;">#TlFormat(net_weight_total)#</td>
		<td align="center" style="text-align:center;">#TlFormat(net_piece_total,0)#</td>
		<td align="center" style="text-align:center;">#TlFormat(net_cost_total)#</td>
		<td align="center" style="text-align:center;">#TlFormat(net_cost2_total)#</td>
		</cfoutput>
	</tr>
    </tbody>
  <cfelse>
			<tr>
				<td <cfif attributes.report_type neq 8> colspan="7"<cfelse>colspan="13"</cfif>><cf_get_lang_main no='72.Kayıt yok'>!</td>
			</tr>
  </cfif>
</cf_report_list>
<cfif attributes.totalrecords gt attributes.maxrows>
				<cfset adres="#attributes.fuseaction#&report_type=#attributes.report_type#&form_submitted=1">
				<cfset adres="#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
				<cfset adres="#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">	
				<cfif len(attributes.graph_type)>
					<cfset adres = "#adres#&graph_type=#attributes.graph_type#">
				</cfif>
				<cfif len(attributes.is_view_graph)>
					<cfset adres = "#adres#&is_view_graph=#attributes.is_view_graph#">
				</cfif>
				<cfif len(attributes.companycat_id)>
					<cfset adres="#adres#&companycat_id=#attributes.companycat_id#">
				</cfif>
				<cfif len(attributes.customer_value_id)>
					<cfset adres="#adres#&customer_value_id=#attributes.customer_value_id#">
				</cfif>
				<cfif len(attributes.resource_id)>
					<cfset adres="#adres#&resource_id=#attributes.resource_id#">
				</cfif>
				<cfif len(attributes.sales_county_id)>
					<cfset adres="#adres#&sales_county_id=#attributes.sales_county_id#">
				</cfif>
				<cfif len(attributes.companycat_id)>
					<cfset adres="#adres#&companycat_id=#attributes.companycat_id#">
				</cfif>
				<cfif len(attributes.ims_code_name)>
					<cfset adres="#adres#&ims_code_name=#attributes.ims_code_name#&ims_code_id=#attributes.ims_code_id#">
				</cfif>
				<cfif len(attributes.pos_code_name)>
					<cfset adres="#adres#&pos_code_name=#attributes.ims_code_name#&pos_code=#attributes.pos_code#">
				</cfif>
				<cfif len(attributes.transport_comp_name)>
					<cfset adres="#adres#&transport_comp_name=#attributes.transport_comp_name#&transport_comp_id=#attributes.transport_comp_id#">
				</cfif>
				<cfif len(attributes.ship_method_name)>
					<cfset adres="#adres#&ship_method_name=#attributes.ship_method_name#&ship_method_id=#attributes.ship_method_id#">
				</cfif>
				<cfif len(attributes.comp_name)>
					<cfset adres="#adres#&comp_name=#attributes.comp_name#&comp_id=#attributes.comp_id#">
				</cfif>	
				<cfif len(attributes.city_id)>
					<cfset adres="#adres#&city_id=#attributes.city_id#">
				</cfif>			
				<cf_paging page="#attributes.page#" 
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="#adres#">
</cfif>
<!--- Grafik Başlangıç --->
<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
<cfif isdefined("attributes.form_submitted") and attributes.is_view_graph eq 1 and isdefined('get_ship_result.recordcount') and get_ship_result.recordcount>
	<tbody>
				<tr class="nohover">	
				<cfif isDefined("form.graph_type") and len(form.graph_type)>
					<cfset graph_type = form.graph_type>
				<cfelse>
					<cfset graph_type = "bar">
				</cfif>
					<cfoutput query="get_ship_result">
						<cfset item_value = left(degisken,30)>
						<cfset 'item_#currentrow#' = "#item_value#">
						<cfset 'value_#currentrow#' = "#Evaluate('#currentrow#')#">
					</cfoutput>				
				<script src="JS/Chart.min.js" style="width:100%;"></script> 
				<canvas id="myChart"></canvas>
				<script>			
					var ctx = document.getElementById('myChart');
						var myChart = new Chart(ctx, {
							type: '<cfoutput>#graph_type#</cfoutput>',
							data: {
								labels: [<cfloop from="1" to="#get_ship_result.recordcount#" index="jj">
												 <cfoutput>"#evaluate("item_#jj#")#"</cfoutput>,</cfloop>],
								datasets: [{
									label: "Detaylı Sevkiyat Analizi",
									backgroundColor: [<cfloop from="1" to="#get_ship_result.recordcount#" index="jj">'rgba('+Math.floor((Math.random()*255) + 1) + ',' +Math.floor((Math.random()*255) + 1) + ','+ Math.floor((Math.random()*255) + 1)+',0.60)',</cfloop>],
									data: [<cfloop from="1" to="#get_ship_result.recordcount#" index="jj"><cfoutput>#NumberFormat(evaluate("value_#jj#"),'00')#</cfoutput>,</cfloop>],
								}]
							},
							options: {}
					});
				</script>
					<strong><font color="FF0000"> *<cf_get_lang no ='1299.Grafikler'>  <cfoutput>#session.ep.money#</cfoutput><cf_get_lang no ='1300.bazında gösterilmiştir'>.</font></strong>
		</tr>
	</tbody>
</cfif>
</div>	
<!--- Grafik Bitiş --->
</cfif>	
<script type="text/javascript">
function disab_enabl()
{
	if(document.list_ship_result.graph_type.disabled==false)
		document.list_ship_result.graph_type.disabled=true;
	else
		document.list_ship_result.graph_type.disabled=false;
}
function control()
{
	if ((document.list_ship_result.start_date.value != '') && (document.list_ship_result.finish_date.value != '') &&
	    !date_check(list_ship_result.start_date,list_ship_result.finish_date,"<cf_get_lang no ='1093.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
	         return false;
	if(document.list_ship_result.is_excel.checked==false)
		{
			document.list_ship_result.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.ship_result_analyse_report"
			return true;
		}
	else
		document.list_ship_result.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_ship_result_analyse_report</cfoutput>"
}
</script>
