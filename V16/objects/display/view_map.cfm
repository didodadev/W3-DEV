<!--- 
Google Maps JavaScript API V3
coordinate_1 : Girilmesi Zorunlu. Koordinat 1
coordinate_2 : Girilmesi Zorunlu. Koordinat 2
Title : Istege Bagli. Pointer in üzerine gelindigi zaman gosterilecek aciklama. 
type : 1 kurumsal üyeler 2 aboneler 3 projeler
 --->
<!---<cf_popup_box>--->
<cfsetting showdebugoutput="no">
<cfif IsDefined('attributes.allmap') and len(attributes.allmap) and IsDefined("attributes.type") and attributes.type eq 1>
	<cfif session.ep.our_company_info.sales_zone_followup eq 1>
		<cfquery name="GET_HIERARCHIES" datasource="#this.DSN#">
			SELECT DISTINCT SZ_HIERARCHY FROM SALES_ZONES_ALL_1 WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
	</cfif>
	<cfquery name="get_all" datasource="#DSN#">
		SELECT
			NICKNAME,
			COORDINATE_1,
			COORDINATE_2,
            COMPANYCAT_ID
		FROM
        	<cfif IsDefined("attributes.keyword_partner") and len(attributes.keyword_partner) or IsDefined("attributes.tc_identity") and len(attributes.tc_identity)>COMPANY_PARTNER WITH (NOLOCK),</cfif>
			<cfif IsDefined("attributes.module_name") and session.ep.isBranchAuthorization and IsDefined("attributes.is_store_followup") and attributes.is_store_followup eq 1>COMPANY_BRANCH_RELATED WITH (NOLOCK),</cfif>
			<cfif IsDefined('attributes.responsible_branch_id') and len(attributes.responsible_branch_id)>SALES_ZONES WITH (NOLOCK),</cfif>
			<cfif IsDefined('attributes.period_id') and len(attributes.period_id)>COMPANY_PERIOD WITH (NOLOCK),</cfif>
			COMPANY
		WHERE
			(COORDINATE_1 IS NOT NULL AND COORDINATE_1 <> '') AND
			(COORDINATE_2 IS NOT NULL AND COORDINATE_2 <> '') AND
			COMPANY.COMPANY_ID IS NOT NULL
			<cfif IsDefined("attributes.module_name") and session.ep.isBranchAuthorization and IsDefined("attributes.is_store_followup") and attributes.is_store_followup eq 1>
				AND COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID
				AND COMPANY_BRANCH_RELATED.DEPOT_DAK IS NULL
				AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (#ListGetAt(session.ep.user_location,2,'-')#)
				AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif IsDefined("attributes.blacklist_status") and len(attributes.blacklist_status)>
				AND COMPANY.COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_CREDIT WHERE IS_BLACKLIST = 1)
			</cfif>
            <cfif IsDefined("attributes.tax_no") and len(attributes.tax_no)>
            	AND COMPANY.TAXNO LIKE   <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_no#%">
            </cfif>
			<cfif IsDefined("attributes.period_id") and len(attributes.period_id)>
				AND COMPANY_PERIOD.COMPANY_ID = COMPANY.COMPANY_ID
				<cfif listgetat(period_id,2,',') eq 1>
					AND COMPANY_PERIOD.PERIOD_ID = #listgetat(attributes.period_id,4,',')#
				<cfelse>
					AND COMPANY_PERIOD.PERIOD_ID IN (SELECT PERIOD_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #listgetat(attributes.period_id,3,',')#)
				</cfif>
			</cfif>
			<cfif IsDefined("attributes.process_stage_type") and len(attributes.process_stage_type)>
				AND COMPANY.COMPANY_STATE = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_stage_type#">
			</cfif>
			<cfif IsDefined("attributes.record_emp") and len(attributes.record_emp) and IsDefined("attributes.record_name") and len(attributes.record_name)>
				AND COMPANY.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#record_emp#">
			</cfif>
		  	<cfif IsDefined("attributes.city") and len(city)>AND COMPANY.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city#"></cfif>
		  	<cfif IsDefined("attributes.sales_zones") and len(attributes.sales_zones)><!--- Kendisi ve alt kirilimlarinin da gelmesi icin --->
				<cfset sales_zones = replace(attributes.sales_zones,'_','')>
				AND COMPANY.SALES_COUNTY IN (SELECT SZ_ID FROM SALES_ZONES WHERE (SZ_HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sales_zones#"> OR SZ_HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.sales_zones#.%">))
		  	</cfif>
            <cfif IsDefined("attributes.sector_cat_id") and len(attributes.sector_cat_id)>
	            AND (
                        COMPANY.COMPANY_ID IN (
                        						SELECT 
                                                	COMPANY_ID 
                                                FROM 
                                                	COMPANY_SECTOR_RELATION CSR1 
                                                WHERE 
                                                	CSR1.SECTOR_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sector_cat_id#">
                                             )
	                )
            </cfif>
		  	<cfif IsDefined("attributes.pos_code") and len(attributes.pos_code) and IsDefined("attributes.pos_code_text") and len(attributes.pos_code_text)>
				AND COMPANY.COMPANY_ID IN 
				(SELECT COMPANY_ID FROM WORKGROUP_EMP_PAR WHERE POSITION_CODE= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#"> AND IS_MASTER=1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND COMPANY_ID IS NOT NULL)
		  	</cfif>
		  	<cfif IsDefined("attributes.search_potential") and len(attributes.search_potential)>AND COMPANY.ISPOTANTIAL = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_potential#"></cfif>
		  	<cfif IsDefined("attributes.is_related_company") and len(attributes.is_related_company)>AND COMPANY.IS_RELATED_COMPANY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_related_company#"></cfif>
		  	<cfif IsDefined("attributes.comp_cat") and len(attributes.comp_cat)>AND COMPANY.COMPANYCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.comp_cat#"></cfif>
		  	<cfif IsDefined('attributes.search_status') and len(attributes.search_status)>AND COMPANY.COMPANY_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.search_status#"></cfif>
		  	<cfif IsDefined("attributes.customer_value") and len(attributes.customer_value)> AND COMPANY.COMPANY_VALUE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.customer_value#"></cfif>
		  	<cfif IsDefined('attributes.country_id') and len(attributes.country_id)>AND COMPANY.COUNTRY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#"></cfif>
		  	<cfif IsDefined('attributes.city_id') and len(attributes.city_id)>AND COMPANY.CITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#"></cfif>
		  	<cfif IsDefined('attributes.county_id') and len(attributes.county_id)>AND COMPANY.COUNTY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#"></cfif>
		  	<cfif IsDefined('attributes.keyword') and len(attributes.keyword)>
				<cfif IsDefined("attributes.is_fulltext_search") and attributes.is_fulltext_search eq 1 >
					AND CONTAINS(COMPANY.*,'"#attributes.keyword#*"')
				<cfelse>
							AND
						(
							<cfif len(attributes.keyword) gt 2>
								COMPANY.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
								COMPANY.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
								COMPANY.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
								COMPANY.OZEL_KOD_1 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
								COMPANY.OZEL_KOD_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
								COMPANY.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">	
							<cfelse>
								COMPANY.FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
								COMPANY.NICKNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
								COMPANY.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
								COMPANY.OZEL_KOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
								COMPANY.OZEL_KOD_1 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
								COMPANY.OZEL_KOD_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> OR
								COMPANY.MEMBER_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
							</cfif>
						)
				</cfif>
		  	</cfif>
		  	<cfif IsDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 1>
				AND COMPANY.IS_BUYER = 1
		  	<cfelseif IsDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 2>
				AND COMPANY.IS_SELLER = 1
		  	</cfif>
		  	<cfif IsDefined("attributes.keyword_partner") and len(attributes.keyword_partner) or IsDefined("attributes.tc_identity") and len(attributes.tc_identity)>
				AND COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID 
				AND (
                	<cfif len(attributes.keyword_partner)>
                        (COMPANY_PARTNER.TITLE LIKE '<cfif len(attributes.keyword_partner) gt 1>%</cfif>#attributes.keyword_partner#%' OR
                        COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER.COMPANY_PARTNER_SURNAME LIKE '<cfif len(attributes.keyword_partner) gt 1>%</cfif>#attributes.keyword_partner#%')
 						<cfif len(attributes.tc_identity)>
                      		<cfif len(attributes.keyword_partner)> AND </cfif>COMPANY_PARTNER.TC_IDENTITY LIKE '<cfif len(attributes.tc_identity) gt 1>%</cfif>#attributes.tc_identity#%'
                    	</cfif>
                    <cfelseif len(attributes.tc_identity)>
                    	  COMPANY_PARTNER.TC_IDENTITY LIKE '<cfif len(attributes.tc_identity) gt 1>%</cfif>#attributes.tc_identity#%'                    
                    </cfif>
                   
                    )                    
			</cfif>
			<cfif session.ep.our_company_info.sales_zone_followup eq 1>
				<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
				AND (COMPANY.IMS_CODE_ID IN ( 
					SELECT
						 IMS_ID 
					FROM 
						SALES_ZONES_ALL_2
					 WHERE 
						POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">  
						AND (COMPANY_CAT_IDS IS NULL OR (COMPANY_CAT_IDS IS NOT NULL AND ','+COMPANY_CAT_IDS+',' LIKE '%,'+CAST(COMPANY.COMPANYCAT_ID AS NVARCHAR)+',%'))
				)
				<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
				<cfif get_hierarchies.recordcount>
					OR COMPANY.IMS_CODE_ID IN (
												SELECT
													IMS_ID
												FROM
													SALES_ZONES_ALL_1
												WHERE											
													<cfloop index="page_stock" from="0" to="#(ceiling(get_hierarchies.recordcount/row_block))-1#">
														<cfset start_row=(page_stock*row_block)+1>	
														<cfset end_row=start_row+(row_block-1)>
														<cfif (end_row) gte get_hierarchies.recordcount>
															<cfset end_row=get_hierarchies.recordcount>
														</cfif>
															(
															<cfloop index="add_stock" from="#start_row#" to="#end_row#">
																<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#.%'
															</cfloop>
															
															)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
													</cfloop>											
												)
				</cfif>						
				)
			</cfif>
            <cfif IsDefined("attributes.use_efatura") and len(attributes.use_efatura)>
            	AND COMPANY.USE_EFATURA = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.use_efatura#">
            </cfif>
        ORDER BY
        	COMPANYCAT_ID
	</cfquery>
<cfelse>
	<cfset get_all.recordcount = 0>    
</cfif>

<cfif IsDefined('attributes.allmap') and len(attributes.allmap) and IsDefined("attributes.type") and attributes.type eq 3><!---pROJELER --->
	<cfquery name="get_all" datasource="#DSN#">
        SELECT
            DISTINCT 
            SMC.MAIN_PROCESS_CAT_ID,
            SMC.MAIN_PROCESS_CAT,
            PRO_PROJECTS.COORDINATE_1,
			PRO_PROJECTS.COORDINATE_2,
            PRO_PROJECTS.PROJECT_ID,
            PRO_PROJECTS.PROJECT_HEAD,
            PRO_PROJECTS.PROJECT_NUMBER
        FROM 
        	PRO_PROJECTS LEFT JOIN 
            SETUP_MAIN_PROCESS_CAT SMC ON
            PRO_PROJECTS.PROCESS_CAT = SMC.MAIN_PROCESS_CAT_ID,
            SETUP_MAIN_PROCESS_CAT_ROWS SMR,
            EMPLOYEE_POSITIONS
        WHERE
        	(PRO_PROJECTS.COORDINATE_1 IS NOT NULL AND PRO_PROJECTS.COORDINATE_1 <> '') AND
			(PRO_PROJECTS.COORDINATE_2 IS NOT NULL AND PRO_PROJECTS.COORDINATE_2 <> '') AND
            SMC.MAIN_PROCESS_CAT_ID = SMR.MAIN_PROCESS_CAT_ID AND
            PRO_PROJECTS.PROJECT_STATUS = 1 AND
            EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
            (EMPLOYEE_POSITIONS.POSITION_CAT_ID = SMR.MAIN_POSITION_CAT_ID OR EMPLOYEE_POSITIONS.POSITION_CODE = SMR.MAIN_POSITION_CODE)
			<cfif IsDefined("attributes.subs_type_id") and len(attributes.subs_type_id)>
                AND SMC.MAIN_PROCESS_CAT_ID = #attributes.subs_type_id#
            </cfif>
	</cfquery>
    <cfquery name="GET_PROCESS_CAT" datasource="#DSN#">
        SELECT
           DISTINCT 
           SMC.MAIN_PROCESS_CAT_ID,
           SMC.MAIN_PROCESS_CAT
        FROM 
           SETUP_MAIN_PROCESS_CAT SMC,
           SETUP_MAIN_PROCESS_CAT_ROWS SMR,
           EMPLOYEE_POSITIONS
        WHERE
           SMC.MAIN_PROCESS_CAT_ID = SMR.MAIN_PROCESS_CAT_ID AND
           EMPLOYEE_POSITIONS.POSITION_CODE =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND 
           (EMPLOYEE_POSITIONS.POSITION_CAT_ID = SMR.MAIN_POSITION_CAT_ID OR EMPLOYEE_POSITIONS.POSITION_CODE = SMR.MAIN_POSITION_CODE)
    </cfquery>
<cfelse>
	<cfset get_all.recordcount = 0>    
</cfif>

<cfif IsDefined('attributes.allmap') and len(attributes.allmap) and IsDefined("attributes.type") and attributes.type eq 2><!--- Aboneler --->
	<cfquery name="get_all" datasource="#DSN3#">
		SELECT 
            REPLACE(SC.SUBSCRIPTION_HEAD,'''',' ') SUBSCRIPTION_HEAD,
            SC.SHIP_COORDINATE_1,
            SC.SHIP_COORDINATE_2,
            SC.SUBSCRIPTION_TYPE_ID,
            SST.ICON_COLOR,
            SST.ICON_FILE,
            SC.SUBSCRIPTION_ID,
            SC.SUBSCRIPTION_NO
        FROM 
            SUBSCRIPTION_CONTRACT SC
            	LEFT JOIN SETUP_SUBSCRIPTION_TYPE SST ON SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID
        WHERE
        	<cfif IsDefined('session.pp.userid')>
				(
					COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
					INVOICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
				) AND
			</cfif>
            (SHIP_COORDINATE_1 IS NOT NULL AND SHIP_COORDINATE_2 IS NOT NULL AND SHIP_COORDINATE_1 <> '' AND SHIP_COORDINATE_2 <> '') 
			<cfif IsDefined("attributes.subs_type_id") and len(attributes.subs_type_id)>
                AND SC.SUBSCRIPTION_TYPE_ID = #attributes.subs_type_id#
            </cfif>
            <cfif len(attributes.status)>
                AND IS_ACTIVE = #attributes.status#
            </cfif>
	</cfquery>
    <cfquery name="get_setup_subs" datasource="#dsn3#">
    	SELECT SUBSCRIPTION_TYPE_ID,SUBSCRIPTION_TYPE FROM SETUP_SUBSCRIPTION_TYPE ORDER BY SUBSCRIPTION_TYPE
    </cfquery>
<cfelse>    
	<cfset get_all.recordcount = 0>
</cfif>
<br/>
<cfif IsDefined("get_setup_subs") and get_setup_subs.recordcount>
	<cfoutput query="get_setup_subs">
    <!--- <div style="background-color:##6699cc; float:right; width:150px; color:##FFF; margin-right:10px;"> --->
	    <input type="checkbox" name="subscription_type_name" id="subscription_type_name_#SUBSCRIPTION_TYPE_ID#" value="#SUBSCRIPTION_TYPE_ID#" <cfif IsDefined("attributes.subs_type_id") and attributes.subs_type_id eq SUBSCRIPTION_TYPE_ID>checked="checked"</cfif> onClick="javascript:if(document.getElementById('subscription_type_name_#SUBSCRIPTION_TYPE_ID#').checked)
window.location.href='#request.self#?fuseaction=objects.popup_view_map&allmap=1&type=2&status=1&subs_type_id=#SUBSCRIPTION_TYPE_ID#'
else
window.location.href='#request.self#?fuseaction=objects.popup_view_map&allmap=1&type=2&status=1'
">#SUBSCRIPTION_TYPE#
<!--- </div> --->
    </cfoutput>
<cfelseif IsDefined("GET_PROCESS_CAT") and GET_PROCESS_CAT.recordcount>
	<cfoutput query="GET_PROCESS_CAT">
                <input type="checkbox" name="subscription_type_name" id="subscription_type_name_#MAIN_PROCESS_CAT_ID#" value="#MAIN_PROCESS_CAT_ID#" <cfif IsDefined("attributes.subs_type_id") and attributes.subs_type_id eq MAIN_PROCESS_CAT_ID>checked="checked"</cfif> onClick="javascript:if(document.getElementById('subscription_type_name_#MAIN_PROCESS_CAT_ID#').checked)
        window.location.href='#request.self#?fuseaction=objects.popup_view_map&allmap=1&type=3&subs_type_id=#MAIN_PROCESS_CAT_ID#'
        else
        window.location.href='#request.self#?fuseaction=objects.popup_view_map&allmap=1&type=3'
        ">#MAIN_PROCESS_CAT#
    </cfoutput>
</cfif>
<!DOCTYPE html>
<html>
	<head>
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<style type="text/css"> 
	  html { height: 100% }
	  body { height: 100%; margin: 0px; padding: 0px }
	  #map_canvas { height:93%;width:98%; margin-left:7px; border:2px solid #666; }
	</style>
	<title></title>
    
	<script type="text/javascript"> 
		window.onload = loadScript;
		function initialize() 
		{
			<cfif IsDefined('attributes.allmap') and len(attributes.allmap) and get_all.recordcount and IsDefined("attributes.type") and attributes.type eq 1><!--- kurumsal uyeler listesi icin eklendi --->
				var myLatlng = new google.maps.LatLng(38.963745,35.243322);<!--- Turkiye koordinatları --->
				var myOptions = {zoom: 6,center: myLatlng,mapTypeId: google.maps.MapTypeId.ROADMAP} 
				map = new google.maps.Map(document.getElementById("map_canvas"), myOptions); 
				
				<cfoutput query="get_all">
				
					<cfif get_all.currentrow eq 1 or get_all.COMPANYCAT_ID[currentrow-1] neq get_all.COMPANYCAT_ID[currentrow]>
					var pinColor = get_random_color();
					</cfif>
					var pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor,
						new google.maps.Size(21, 34),
						new google.maps.Point(0,0),
						new google.maps.Point(10, 34));
					var coordinate_1 = #coordinate_1#;
					var coordinate_2 = #coordinate_2#;
					var title = "#nickname#";
					var myLatlng = new google.maps.LatLng(coordinate_1,coordinate_2);
					var marker = new google.maps.Marker({position: myLatlng,map: map,title: title,icon: pinImage}); 
				</cfoutput>
				<!--- aboneler listesi --->
			<cfelseif IsDefined('attributes.allmap') and len(attributes.allmap) and get_all.recordcount and IsDefined("attributes.type") and attributes.type eq 2>
					var pinColor= 'FDE200'
					var markers = [
					<cfoutput query="get_all">['<h3 style="text-align:left"><a href="javascript:show_detail_window(#SUBSCRIPTION_ID#)">#SUBSCRIPTION_NO# : #SUBSCRIPTION_HEAD#</a></h2>',#SHIP_COORDINATE_1#,#SHIP_COORDINATE_2#,
					new google.maps.MarkerImage(<cfif len(get_all.ICON_FILE)>"http://#listfirst(employee_url,';')#/documents/settings/#get_all.ICON_FILE#"<cfelse>"http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|<cfif len(ICON_COLOR)>#ICON_COLOR#<cfelse>000000</cfif>"</cfif>,new google.maps.Size(34, 34),new google.maps.Point(0,0),new google.maps.Point(10, 34))
					]<cfif currentrow neq get_all.recordcount>,
					</cfif>
					</cfoutput>];
					
						var latlng = new google.maps.LatLng(38.963745,35.243322);
						var myOptions = {
							zoom: 6,
							center: latlng,
							mapTypeId: google.maps.MapTypeId.ROADMAP,
							mapTypeControl: false
						};
						var map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
						var infowindow = new google.maps.InfoWindow(), marker, i;
						for (i = 0; i < markers.length; i++) {  
								marker = new google.maps.Marker({
								position: new google.maps.LatLng(markers[i][1], markers[i][2]),
								map: map,
								icon: markers[i][3]
							});
							google.maps.event.addListener(marker, 'click', (function(marker, i) {
								return function() {
									infowindow.setContent(markers[i][0]);
									infowindow.open(map, marker);
								}
							})(marker, i));
						}
						
			<cfelseif IsDefined('attributes.allmap') and len(attributes.allmap) and get_all.recordcount and IsDefined("attributes.type") and attributes.type eq 3>
					var pinColor= 'FDE200'
					var markers = [
					<cfoutput query="get_all">['<h3 style="text-align:left"><a href="javascript:show_detail_window_project(#PROJECT_ID#)">#PROJECT_NUMBER# : #PROJECT_HEAD#</a></h2>',#COORDINATE_1#,#COORDINATE_2#,
					new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor,
					new google.maps.Size(34, 34),
					new google.maps.Point(0,0),
					new google.maps.Point(10, 34))
					]<cfif currentrow neq get_all.recordcount>,
					</cfif>
					</cfoutput>];
					
						var latlng = new google.maps.LatLng(38.963745,35.243322);
						var myOptions = {
							zoom: 6,
							center: latlng,
							mapTypeId: google.maps.MapTypeId.ROADMAP,
							mapTypeControl: false
						};
						var map = new google.maps.Map(document.getElementById("map_canvas"),myOptions);
						var infowindow = new google.maps.InfoWindow(), marker, i;
						for (i = 0; i < markers.length; i++) {  
								marker = new google.maps.Marker({
								position: new google.maps.LatLng(markers[i][1], markers[i][2]),
								map: map,
								icon: markers[i][3]
							});
							google.maps.event.addListener(marker, 'click', (function(marker, i) {
								return function() {
									infowindow.setContent(markers[i][0]);
									infowindow.open(map, marker);
								}
							})(marker, i));
						}

			<cfelseif IsDefined('attributes.allmap') and len(attributes.allmap) and not get_all.recordcount>
				var myLatlng = new google.maps.LatLng(38.963745,35.243322);<!--- Turkiye koordinatları --->
				var myOptions = {zoom: 6,center: myLatlng,mapTypeId: google.maps.MapTypeId.ROADMAP} 
				map = new google.maps.Map(document.getElementById("map_canvas"), myOptions); 
			<cfelse><!--- Bir tek kordinat kullanılacaksa --->
				<cfif len(attributes.title)>
					var title = "<cfoutput>#attributes.title#</cfoutput>";
				<cfelse>
					var title = coordinate_1 + "," + coordinate_2;
				</cfif>
				var coordinate_1 = <cfoutput>#attributes.coordinate_1#</cfoutput>;
				var coordinate_2 = <cfoutput>#attributes.coordinate_2#</cfoutput>;
				var myLatlng = new google.maps.LatLng(coordinate_1,coordinate_2);
				var myOptions = {zoom: 14,center: myLatlng,mapTypeId: google.maps.MapTypeId.ROADMAP}
				var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
				var marker = new google.maps.Marker({position: myLatlng,map: map,title: title}); 
			</cfif>
		}
		
		function loadScript() 
		{
			var script = document.createElement("script");
			script.type = "text/javascript";
			script.src = "http://maps.google.com/maps/api/js?sensor=false&callback=initialize&";
			document.body.appendChild(script);
		}
		function get_random_color() 
		{
			var letters = '0123456789ABCDEF'.split('');
			var color = '';
			for (var i = 0; i < 6; i++ ) 
			{
				color += letters[Math.round(Math.random() * 15)];
			}
			return color;
		}
		function show_detail_window(subcription_id)
		{
			<cfif IsDefined('session.ep.userid')>
				window.open("<cfoutput>#request.self#</cfoutput>?fuseaction=sales.list_subscription_contract&event=upd&subscription_id="+subcription_id);
			<cfelseif IsDefined('session.pp.userid')>
				window.open("<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.dsp_subscription&subscription_id="+subcription_id);			
			</cfif>
		}
		
		function show_detail_window_project(project_id)
		{
			<cfif IsDefined('session.ep.userid')>
				window.open("<cfoutput>#request.self#</cfoutput>?fuseaction=project.projects&event=det&id="+project_id);
			</cfif>
		}
		
	</script>
	</head>
	<body>
    	<div id="map_canvas" style="text-align:right;"></div>
	</body>
</html>
<!---</cf_popup_box>--->
