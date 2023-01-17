<!---Select ifadeleri Düzenlendi.24082012,e.a --->
<cfif isdefined("attributes.submitted")>
	<cfquery name="sticker_" datasource="#dsn#">
		SELECT 
           ROW_NUMBER,
           COLUMN_NUMBER,
           HORIZONTAL_GAP,
           VERTICAL_GAP,
           STICKER_WIDTH,
           STICKER_LENGTH,
           PAGE_TOP_BLANK,
           PAGE_FOT_BLANK,
           PAGE_RIGHT_BLANK,
           PAGE_LEFT_BLANK
        FROM 
        	SETUP_STICKER 
        WHERE 
        	STICKER_ID = #attributes.sticker#
	</cfquery>
	<cfinclude template="../query/get_tmarket_label_info_camp.cfm">
	<cfif isdefined("get_camp_list_label_info") and get_camp_list_label_info.recordcount>
		
		<cfscript>
			county_id_list=listdeleteduplicates(valuelist(get_camp_list_label_info.county,','));
			county_id_list=listdeleteduplicates(listappend(county_id_list,valuelist(get_camp_list_label_info.work_county,','),','));
			city_id_list=listdeleteduplicates(valuelist(get_camp_list_label_info.city,','));
			city_id_list=listdeleteduplicates(listappend(city_id_list,valuelist(get_camp_list_label_info.work_city,','),','));
			country_id_list=listdeleteduplicates(valuelist(get_camp_list_label_info.country,','));
			country_id_list=listdeleteduplicates(listappend(country_id_list,valuelist(get_camp_list_label_info.work_country,','),','));
			//abort('county_id_list=#county_id_list# <br>city_id_list=#city_id_list#<br>country_id_list=#country_id_list#');
		</cfscript>
		<cfif listlen(county_id_list,',')>
			<cfquery name="get_county_all" datasource="#dsn#">
				SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_id_list#)
			</cfquery>
		</cfif>
		<cfif listlen(city_id_list,',')>
			<cfquery name="get_city_all" datasource="#dsn#">
				SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_id_list#)
			</cfquery>
		</cfif>
		<cfif listlen(country_id_list,',')>
			<cfquery name="get_country_all" datasource="#dsn#">
				SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_id_list#)
			</cfquery>
		</cfif>
		
		<cfset xxx = 0>
		<cfset ilce_ = "">
		<cfset il_ = "">
		<cfset tel_ = "">
		<cfdocument
			permissions="allowprinting"
			format="pdf" 
			orientation="portrait"
			pagetype="a4"
			margintop="0"
			marginbottom="0"
			marginright="0"
			marginleft="0"
			encryption="128-bit">
			<link rel='stylesheet' href='css/win_ie_1.css' type='text/css'>
			<style type="text/css">table,td{font-size:12px;font-family:Verdana, Arial, Helvetica, sans-serif;}</style>

			<cfoutput query="get_camp_list_label_info">
				<cfif xxx lte recordcount>
					
					<cfset colspan_ = 3>
					<cfif sticker_.page_left_blank neq 0>
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					<cfif sticker_.page_right_blank neq 0>
						<cfset colspan_ = colspan_ + 1>
					</cfif>
					
					<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
						<tr align="left">
							<td style="height:#sticker_.page_top_blank#mm;" colspan="#colspan_#">&nbsp;</td>
						</tr>
						<cfloop from="1" to="#sticker_.row_number#" index="rw">
						<tr valign="top" align="left">
							<cfif sticker_.page_left_blank neq 0>
								<td style="width:#sticker_.page_left_blank#mm;">&nbsp;</td>
							</cfif>
							<cfloop from="1" to="#sticker_.column_number#" index="cl">
								<cfset xxx = xxx + 1>
								<cfscript>
									if(attributes.address_type eq 0)
									{
										if(len(address[xxx]) gt 5)//bosluk v.s. koyulmuş olabilir
										{
											adres_1 = left(address[xxx],100) & ' ' & semt[xxx] & ' ' & poscode[xxx];
											//label_address=address[xxx];
											//label_semt=semt[xxx];
											label_county=county[xxx];
											label_city=city[xxx];
											//label_poscode=poscode[xxx];
											label_telcode=telcode[xxx];
											label_tel=tel[xxx];
										}else
										{
											adres_1 = left(work_address[xxx],100) & ' ' & work_semt[xxx] & ' ' & work_poscode[xxx];
											//label_address=work_address[xxx];
											//label_semt=work_semt[xxx];
											label_county=work_county[xxx];
											label_city=work_city[xxx];
											//label_poscode=work_poscode[xxx];
											label_telcode=work_telcode[xxx];
											label_tel=work_tel[xxx];
										}
									}else if(attributes.address_type eq 1)
									{
										adres_1 = left(work_address[xxx],100) & ' ' & work_semt[xxx] & ' ' & work_poscode[xxx];
										//label_address=work_address[xxx];
										//label_semt=work_semt[xxx];
										label_county=work_county[xxx];
										label_city=work_city[xxx];
										//label_poscode=work_poscode[xxx];
										label_telcode=work_telcode[xxx];
										label_tel=work_tel[xxx];
									}else if(attributes.address_type eq 2)
									{
										adres_1 = left(address[xxx],100) & ' ' & semt[xxx] & ' ' & poscode[xxx];
										//label_address=address[xxx];
										//label_semt = semt[xxx];
										label_county = county[xxx];
										label_city = city[xxx];
										//label_poscode = poscode[xxx];
										label_telcode=telcode[xxx];
										label_tel=tel[xxx];
									}
								</cfscript>
								<cfif len(label_county)>
									<cfquery name="get_county" dbtype="query">
										SELECT COUNTY_NAME FROM GET_COUNTY_ALL WHERE COUNTY_ID=#label_county#
									</cfquery>
									<cfset ilce_ = get_county.county_name>
								<cfelse>
									<cfset ilce_ = "">
								</cfif>
								<cfif len(label_city)>
									<cfquery name="get_city" dbtype="query">
										SELECT CITY_NAME FROM GET_CITY_ALL WHERE CITY_ID=#label_city#
									</cfquery>
									 <cfset il_ = UCase(get_city.city_name)>
								<cfelse>
									<cfset il_ = "">
								</cfif>
								<cfif len(label_tel)>
									<cfset tel_ = label_telcode & ' - ' & label_tel>
								<cfelse>
									<cfset tel_ = "">
								</cfif>
							<td valign="top" align="left" style="width:#sticker_.sticker_width#mm;height:#sticker_.sticker_length#mm;">
								<table border="0" cellpadding="0" cellspacing="0" align="left" height="100%">
									<tr valign="top">
										<td><strong>#name[xxx]# #surname[xxx]#</strong>&nbsp;</td>
									</tr>
									<tr valign="top">
										<td>#left(company[xxx],50)#&nbsp;</td>
									</tr>
									<tr valign="top" style="height:15mm;">
										<td>#adres_1# #ilce_# #il_#&nbsp;</td>
									</tr>
									<tr valign="top">
										<td>#tel_#&nbsp;</td>
									</tr>
								</table>
								</td>
								<cfif cl neq sticker_.column_number>
									<td style="width:#sticker_.horizontal_gap#mm;"></td>
								</cfif>
							</cfloop>
							<cfif sticker_.page_right_blank neq 0>
								<td style="width:#sticker_.page_right_blank#mm;"></td>
							</cfif>
						</tr>
						<tr style="height:#sticker_.vertical_gap#mm;">
							<td colspan="#colspan_#"></td>
						</tr>
						</cfloop>
						<tr style="height:#sticker_.page_fot_blank#mm;">
							<td colspan="#colspan_#"></td>
						</tr>
					</table>
					<cfif xxx lte recordcount>
						<cfdocumentitem type="pagebreak"></cfdocumentitem>
					</cfif>
				</cfif>
			</cfoutput>
		</cfdocument>
	</cfif>
</cfif>
