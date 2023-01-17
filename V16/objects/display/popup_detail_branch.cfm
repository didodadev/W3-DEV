<cfquery name="GET_BRANCH_DEP_COUNT" datasource="#dsn#">
	SELECT 
		BRANCH_ID, 
		COUNT(DEPARTMENT_ID) AS TOTAL
	FROM 
		DEPARTMENT
	WHERE 
		BRANCH_ID = #attributes.ID#
	GROUP BY
		BRANCH_ID
</cfquery>
<cfquery name="OUR_COMPANY" datasource="#dsn#">
	SELECT 
		COMP_ID,
		COMPANY_NAME 
	FROM 
		OUR_COMPANY
	ORDER BY 
		COMPANY_NAME
</cfquery>
<cfquery name="CATEGORY" datasource="#DSN#">
	SELECT 
		*	
	FROM 
		BRANCH 
	WHERE 
		BRANCH_ID = #URL.ID#
</cfquery>
<cfquery name="ZONES" datasource="#DSN#">
	 SELECT 
		ZONE_NAME,
		ZONE_ID
	 FROM 
		ZONE
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>
<cf_box title="#message# : #category.branch_name#" resize="0" closable="1" draggable="1">
	<cf_flat_list>
		<cfoutput>
			<input type="Hidden" name="branch_ID" id="branch_ID" value="#URL.ID#">
		</cfoutput>
		<tr>
			<td width="80" class="txtbold"><cf_get_lang dictionary_id='57756.Durum'></td>
			<td width="150">
				<cfif category.branch_status><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'>
				</cfif>
			</td>
			<td width="80" class="txtbold"><cf_get_lang dictionary_id='32407.Tel Kod'>1</td>                  
			<td>
				<cfoutput>
					#category.branch_telcode#-#category.branch_tel1#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang dictionary_id='57574.Şirket'></td>
			<td>
			<cfif our_company.recordcount>
				<cfoutput query="our_company">
					<cfif category.company_id eq our_company.comp_id>#company_name#</cfif>
				</cfoutput>
			</cfif>
			</td>
			<td class="txtbold"><cf_get_lang dictionary_id='57499.Telefon'> 2</td>
			<td>
				<cfoutput>
					#category.branch_tel2#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang dictionary_id='57992.Bölge'></td>
			<td>
				<cfif category.recordcount GTE 1>
					<cfoutput query="zones">
						<cfif category.zone_ID EQ zones.zone_ID>#zone_name#</cfif> 
					</cfoutput>
				</cfif>
			</td>
			<td class="txtbold"><cf_get_lang dictionary_id='57499.Telefon'> 3</td>
			<td>
				<cfoutput>
					#category.branch_tel3#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="txtboldblue" colspan="2"><cf_get_lang dictionary_id='32790.Yöneticiler'></td>
			<td class="txtbold"><cf_get_lang dictionary_id='57488.Fax'></td>
			<td><cfoutput>
				#category.branch_fax#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang dictionary_id='29511.Yönetici'> 1</td>
			<td>
				<cfif len(category.admin1_position_code)>
					<cfset attributes.employee_id = "">
					<cfset attributes.position_code = category.admin1_position_code>
					<cfinclude template="../query/get_position.cfm">
					<cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>
				</cfif>
			</td>
			<td class="txtbold"><cf_get_lang dictionary_id='57428.E-mail'></td>
			<td><cfoutput>#category.branch_email#</cfoutput></td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang dictionary_id='29511.Yönetici'> 2</td>
			<td>
				<cfif len(category.admin2_position_code)>
					<cfset attributes.employee_id = "">
					<cfset attributes.position_code = category.admin2_position_code>
					<cfinclude template="../query/get_position.cfm">
					<cfoutput>#get_position.employee_name# #get_position.employee_surname#</cfoutput>
				</cfif>
			</td>
			<td class="txtbold"><cf_get_lang dictionary_id='58723.Adres'></td>
			<td><cfoutput>#category.branch_address#</cfoutput></td>
		</tr>
		<tr>
			<td colspan="2"  class="txtboldblue"><cf_get_lang dictionary_id='32796.Görünüm'> </td>
			<td class="txtbold"><cf_get_lang dictionary_id='57472.Posta Kodu'></td>
			<td>
				<cfoutput>#category.branch_postcode#</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang dictionary_id='32792.Dış Görünüm'></td>
			<td>
				<cfif len(CATEGORY.asset_file_name1)>
					<cf_get_server_file output_file="settings/#category.asset_file_name1#" output_server="#CATEGORY.asset_file_name1_server_id#" output_type="2" small_image="/images/branch_plus.gif" image_link="1">
				</cfif>
			</td>
			<td class="txtbold"><cf_get_lang dictionary_id='58638.İlçe'></td>
			<td>	
				<cfoutput>
					#category.branch_county#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang dictionary_id='32794.Kroki'></td>
			<td>
				<cfif len(CATEGORY.asset_file_name2)>
					<cf_get_server_file output_file="settings/#category.asset_file_name2#" output_server="#CATEGORY.asset_file_name2_server_id#" output_type="2" small_image="/images/branch_black.gif" image_link="1">
				</cfif>
			</td>
			<td class="txtbold"><cf_get_lang dictionary_id='32795.Şehir-Ülke'></td>
			<td>
				<cfoutput>
					#category.branch_city#/#category.branch_country#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang dictionary_id ='33778.SSK Şubesi'></td>
			<td><cfoutput>#category.ssk_office#</cfoutput></td>
			<td class="txtbold"><cf_get_lang dictionary_id ='33779.SSK No'></td>
			<td>
				<cfoutput query="CATEGORY">
					#ssk_m# #ssk_job# #ssk_branch# #ssk_no# #ssk_city# #ssk_country#
				</cfoutput>
			</td>				
		</tr>
	</cf_flat_list>
</cf_box>
