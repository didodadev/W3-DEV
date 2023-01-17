<cfquery name="DETAIL_PAR" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER_EMAIL,
		COMPANY_PARTNER_USERNAME,
		COMPANY_ID,
		PARTNER_ID,
		MISSION,
		MEMBER_CODE,
		IMCAT_ID,
		IM,
		MOBIL_CODE,
		MOBILTEL,
		COMPANY_PARTNER_TELCODE,
		COMPANY_PARTNER_TEL,
		COMPANY_PARTNER_TEL_EXT,
		COMPANY_PARTNER_FAX,
		TITLE,
		HOMEPAGE,
		PHOTO,
		PHOTO_SERVER_ID,
		SEMT,
		COUNTY,
		CITY,
		COUNTRY
	FROM
		COMPANY_PARTNER
	WHERE	
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.par_id#">
</cfquery>
<cfset attributes.company_id = detail_par.company_id>
<cfquery name="GET_COMP_NAME" datasource="#DSN#">
	SELECT NICKNAME,FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
</cfquery>
<cfinclude template="../query/get_representative.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfif len(detail_par.imcat_id)>
	<cfset attributes.imcat_id = detail_par.imcat_id>
	<cfinclude template="../query/get_imcat.cfm">
</cfif>
<table cellpadding="2" cellspacing="1" width="100%" height="100%" class="color-border">
	<tr height="35" class="color-list">
  		<td class="headbold">
			<table width="100%">
	  			<tr>
					<td class="headbold">&nbsp;<cfoutput>#detail_par.member_code#-#detail_par.company_partner_name# #detail_par.company_partner_surname#</cfoutput></td>
	  			</tr>
			</table>
  		</td>
	</tr>
	<tr valign="top" class="color-row">
  		<td>
			<table cellspacing="1" cellpadding="2" width="100%" border="0">
	  			<cfoutput>
					<tr height="22">
						<td width="75" class="txtbold"><cf_get_lang_main no='75.No'></td>
					  	<td width="150">#detail_par.member_code#</td>
					  	<td width="75">&nbsp;</td>
					  	<td width="150">&nbsp;</td>
					  	<td rowspan="9"  valign="top" style="text-align:right;">
							<cfif len(detail_par.photo)>
								<cf_get_server_file output_file="member/#detail_par.photo#" output_server="#detail_par.photo_server_id#" image_width="125" imageheight="150" output_type="0" alt="#getLang('main',668)#" title="#getLang('main',668)#">
							</cfif>
						</td>
					</tr>
					<tr height="22">
		  				<td class="txtbold"><cf_get_lang_main no='219.Ad'></td>
						<td>#detail_par.company_partner_name#</td>
						<td class="txtbold"><cf_get_lang_main no='16.e mail'></td>
						<td><a href="mailto:#detail_par.company_partner_email#" class="tableyazi">#detail_par.company_partner_email#</a></td>
					</tr>
					<tr height="22">
				  		<td class="txtbold"><cf_get_lang_main no='1314.Soyad'></td>
						<td>#detail_par.company_partner_surname#</td>
				  		<td class="txtbold">Ins Mesaj</td>
						<td>
							<cfif len(detail_par.imcat_id)>
			  					#get_imcat.imcat#
							</cfif>
							- #detail_par.im#
						</td>
					</tr>
					<tr height="22">
				  		<td class="txtbold"><cf_get_lang_main no='159.Ünvan'></td>
				  		<td>#detail_par.title#</td>
				  		<td class="txtbold"><cf_get_lang_main no='87.Telefon'></td>
				  		<td> #detail_par.company_partner_telcode# - #detail_par.company_partner_tel# </td>
					</tr>
					<tr height="22">
		 				<td class="txtbold"><cf_get_lang_main no='161.Görev'></td>
		  				<td>
							<cfif len(detail_par.mission)>
								<cfquery name="GET_MISSION" dbtype="query">
									SELECT * FROM GET_PARTNER_POSITIONS WHERE PARTNER_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_par.mission#">
								</cfquery>
								#get_mission.partner_position#
							</cfif>
		  				</td>
		  				<td class="txtbold"><cf_get_lang no='231.Dahili'></td>
		  				<td>#detail_par.company_partner_tel_ext# </td>
					</tr>
					<tr height="22">
				  		<td class="txtbold"><cf_get_lang_main no='162.Şirket'></td>
				 	 	<td>#get_comp_name.fullname#</td>
				  		<td class="txtbold"><cf_get_lang_main no='76.Fax'></td>
				 	 	<td>#detail_par.company_partner_fax#</td>
					</tr>
					<tr height="22">
		  				<td class="txtbold"><cf_get_lang_main no='496.Temsilci'></td>
					  	<td>#get_representative.employee_name#&nbsp;#get_representative.employee_surname#</td>
					  	<td class="txtbold">&nbsp;</td>
					  	<td>&nbsp;</td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang_main no='1070.Mobil Tel'></td>
						<td>#detail_par.mobil_code# - #detail_par.mobiltel#
							<cfif isdefined("session.ep.userid")>
								<cfif (len(detail_par.mobil_code) is 3) and (len(detail_par.mobiltel) is 7) and  (session.ep.our_company_info.sms eq 1)>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=partner&member_id=#detail_par.partner_id#&sms_action=#attributes.fuseaction#','small');">
								</cfif>
							</cfif>
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang_main no='720.Semt'></td>
						<td><cfif len(detail_par.semt)>#detail_par.semt#</cfif></td>
						<td class="txtbold"><cf_get_lang_main no='1226.İlçe'></td>
						<td>
							<cfif len(detail_par.county)>
								<cfquery name="GET_COUNTY_NAME" datasource="#DSN#">
									SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_par.county#">
								</cfquery>
								<cfif get_county_name.recordcount>
									#get_county_name.county_name#
								</cfif>
							</cfif>
						</td>
					</tr>
					<tr>
						<td class="txtbold"><cf_get_lang_main no='559.İl'></td>
						<td>
							<cfif len(detail_par.city)>
								<cfquery name="GET_CITY_NAME" datasource="#DSN#">
									SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_par.city#">
								</cfquery>
								<cfif get_city_name.recordcount>
									#get_city_name.city_name#
								</cfif>
							</cfif>
						</td>
						<td class="txtbold"><cf_get_lang_main no='807.Ülke'></td>
						<td>
							<cfif len(detail_par.country)>
								<cfquery name="GET_COUNTRY_NAME" datasource="#DSN#">
									SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#detail_par.country#">
								</cfquery>
								<cfif get_country_name.recordcount>
									#get_country_name.country_name#
								</cfif>
							</cfif>
						</td>
					</tr>
	  			</cfoutput>
			</table>
  		</td>
	</tr>
</table>

