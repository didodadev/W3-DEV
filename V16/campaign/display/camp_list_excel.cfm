<!---Select ifadeleri Düzenlendi. 24082012 E.A--->
<cfsetting showdebugoutput="no">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Etiketleme',49431)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfif not isdefined("attributes.print")>
			<cfform name="form1" method="post" action="#request.self#?fuseaction=campaign.emptypopup_camp_list_excel">
				<cf_box_search>
					<cfoutput>
						<input type="hidden" name="camp_id" id="camp_id" value="#attributes.camp_id#">
						<input type="hidden" name="date1" id="date1" value="#attributes.date1#">
						<input type="hidden" name="date2" id="date2" value="#attributes.date2#">
						<input type="hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">
						<input type="hidden" name="employee" id="employee" value="#attributes.employee#">
						<input type="hidden" name="print" id="print" value="">
					</cfoutput>
					<div class="form-group">
						<select name="address_type" id="address_type">
							<option value="0" <cfif isDefined("attributes.address_type") and attributes.address_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='57734.Seçiniz'></option><!--- once detaya bakar boşsa şirket adresini basar --->
							<option value="1" <cfif isDefined("attributes.address_type") and attributes.address_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='49601.Şirket Adresi'></option>
							<option value="2" <cfif isDefined("attributes.address_type") and attributes.address_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='49602.Üye Detay Adresi'></option>
						</select>
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</cf_box_search>
			</cfform>
		<cfelse>
			<cfinclude template="../query/get_tmarket_label_info_camp.cfm">
			<cfif GET_CAMP_LIST_LABEL_INFO.RECORDCOUNT>
				<cfscript>
					county_id_list=listdeleteduplicates( valuelist(GET_CAMP_LIST_LABEL_INFO.COUNTY,','));
					county_id_list=listdeleteduplicates(listappend(county_id_list,valuelist(GET_CAMP_LIST_LABEL_INFO.WORK_COUNTY,','),','));
					city_id_list=listdeleteduplicates(valuelist(GET_CAMP_LIST_LABEL_INFO.CITY,','));
					city_id_list=listdeleteduplicates(listappend(city_id_list,valuelist(GET_CAMP_LIST_LABEL_INFO.WORK_CITY,','),','));
					country_id_list=listdeleteduplicates(valuelist(GET_CAMP_LIST_LABEL_INFO.COUNTRY,','));
					country_id_list=listdeleteduplicates(listappend(country_id_list,valuelist(GET_CAMP_LIST_LABEL_INFO.WORK_COUNTRY,','),','));
				</cfscript>
			<cfelse>
				<cfscript>
					county_id_list='';
					city_id_list='';
					country_id_list='';
				</cfscript>
			</cfif>

			<cfif listlen(county_id_list,',')>
				<cfquery name="GET_COUNTY_ALL" datasource="#DSN#">
					SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN(#county_id_list#)
				</cfquery>
			</cfif>
			<cfif listlen(city_id_list,',')>
				<cfquery name="GET_CITY_ALL" datasource="#DSN#">
					SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN(#city_id_list#)
				</cfquery>
			</cfif>
			<cfif listlen(country_id_list,',')>
				<cfquery name="GET_COUNTRY_ALL" datasource="#DSN#">
					SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN(#country_id_list#)
				</cfquery>
			</cfif>
			
			<cfset filename = "#createuuid()#">
			<cfheader name="Expires" value="#Now()#">
			<cfcontent type="application/vnd.msexcel;charset=utf-8">
			<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
			<cf_flat_list>
				<thead>
					<th><cf_get_lang dictionary_id ='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id ='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='58723.Adres'></th>
					<th><cf_get_lang dictionary_id ='58132.Semt'></th>
					<th><cf_get_lang dictionary_id ='57971.Şehir'></th>
					<th><cf_get_lang dictionary_id ='57499.telefon'></th>
					<th><cf_get_lang dictionary_id='58638.İlçe'></th>
					<th><cf_get_lang dictionary_id ='58219.Ülke'></th>
				</thead>
			<cfoutput query="GET_CAMP_LIST_LABEL_INFO">
				<cfscript>
					if(attributes.address_type eq 0)
					{
						if(len(address) gt 5)//bosluk v.s. koyulmuş olabilir
						{
							label_address=address;
							label_semt=semt;
							label_county=county;
							label_city=city;
							label_country = country;
							label_telcode=telcode;
							label_tel=tel;
						}else
						{
							label_address=work_address;
							label_semt=work_semt;
							label_county=work_county;
							label_city=work_city;
							label_country = work_country;
							label_telcode=work_telcode;
							label_tel=work_tel;
						}
					}else if(attributes.address_type eq 1)
					{
						label_address=work_address;
						label_semt=work_semt;
						label_county=work_county;
						label_city=work_city;
						label_country = work_country;
						label_telcode=work_telcode;
						label_tel=work_tel;
					}else if(attributes.address_type eq 2)
					{
						label_address=address;
						label_semt=semt;
						label_county=county;
						label_city=city;
						label_country = country;
						label_telcode=telcode;
						label_tel=tel;
					}
				</cfscript>
				<cfif len(label_county)>
					<cfquery name="get_county" dbtype="query">
						SELECT * FROM GET_COUNTY_ALL WHERE COUNTY_ID=#label_county#
					</cfquery>
					<cfset bolge = get_county.COUNTY_NAME>
				<cfelse>
					<cfset bolge = "">
				</cfif>
				<cfif len(label_city)>
					<cfquery name="get_city" dbtype="query">
						SELECT * FROM GET_CITY_ALL WHERE CITY_ID=#label_city#
					</cfquery>
					<cfset sehir = get_city.CITY_NAME>
				<cfelse>
					<cfset sehir = "">
				</cfif>
				<cfif len(label_country)>
					<cfquery name="get_country" dbtype="query">
						SELECT * FROM GET_COUNTRY_ALL WHERE COUNTRY_ID=#label_country#
					</cfquery>
					<cfset ulke = get_country.COUNTRY_NAME>
				<cfelse>
					<cfset ulke = "">
				</cfif>
				<tbody>
					<tr>
						<td>#COMPANY#</td>
						<td>#NAME# #SURNAME#</td>
						<td>#label_address#</td>
						<td>#label_semt#</td>
						<td>#sehir#</td>
						<td>&nbsp;</td>
						<td>#bolge#</td>
						<td>#ulke#</td>
					</tr>
				</tbody>
			</cfoutput>
		</cfif>
	</cf_box>
</div>
