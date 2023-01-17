<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword_partner" default="">
<cfparam name="attributes.ref_pos_code" default="">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_consumer_cat.cfm">
<cfif session.ep.our_company_info.sales_zone_followup eq 1>
	<cfquery name="GET_HIERARCHIES" datasource="#DSN#">
		SELECT DISTINCT SZ_HIERARCHY FROM SALES_ZONES_ALL_1 WHERE POSITION_CODE = #session.ep.position_code#
	</cfquery>
	<cfset row_block = 500>
</cfif>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset xml_page_control_list ='member_no,ref_no,is_ref_pos_code'>
<cf_xml_page_edit page_control_list="#xml_page_control_list#" default_value="0" fuseact="member.welcome">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box scroll="0">
		<cfform name="form" action="#request.self#?fuseaction=member.form_list_company&form_submitted=1" method="post">
			<input type="hidden" name="form_submit" id="form_submit" value="1">
			<cf_box_search>
					<div class="form-group" id="keyword">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='58585.Kod'>-<cf_get_lang dictionary_id='57574.Şirket'></cfsavecontent>
						<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#place#" >
					</div>
					<div class="form-group" id="calisan">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='30368.Çalışan'>-<cf_get_lang dictionary_id='57571.Ünvan'></cfsavecontent>
						<cfinput type="text" name="keyword_partner" value="#attributes.keyword_partner#" maxlength="255" placeholder="#message#">
					</div>
					<div class="form-group" id="kategori">
					<select name="comp_cat" id="comp_cat" style="width:150">
						<option value=""><cf_get_lang dictionary_id='29536.Tüm Kategoriler'> 
						<cfoutput query="get_companycat">
							<option value="#companycat_id#" <cfif isdefined("attributes.comp_cat") and attributes.comp_cat is companycat_id> selected</cfif>>#companycat#</option>
						</cfoutput>
					</select>
					</div>
					<div class="form-group" id="uye">
						<select name="search_potential" id="search_potential">
						<option value="" selected><cf_get_lang dictionary_id='57658.Üye'> <cf_get_lang dictionary_id='30152.Tipi'></option>
						<option value="1"><cf_get_lang dictionary_id='57577.Potansiyel'></option>
						<option value="0"><cf_get_lang dictionary_id='58061.Cari'></option>   
						</select>             
					</div>
					<div class="form-group" id="calisan">
						<select name="search_type" id="search_type">
						<option value="0" <cfif isDefined('attributes.search_type') and attributes.search_type is 0>selected</cfif>><cf_get_lang dictionary_id='29531.Şirketler'></option>
						<option value="1" <cfif isDefined('attributes.search_type') and attributes.search_type is 1>selected</cfif>><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
						</select>
					</div>
					<div class="form-group" id="aktif">
						<select name="search_status" id="search_status">
						<option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="" <cfif isDefined('attributes.search_status') and not len(attributes.search_status)>selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
						</select>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" >
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
			</cf_box_search>
		</cfform>
	</cf_box>
</div>
<div class="col col-9 col-xs-12 uniqueRow" id="content">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='30147.Kurumsal Üye Başvuruları'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1" > 
		<cf_grid_list is_sort="1">
        	<thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                    <th width="115"><cf_get_lang dictionary_id='57486.Kategori'></th>
                    <th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
                </tr>
            </thead>
			<cfset period_id_list = 0>
			<cfquery name="GET_PERIOD" datasource="#DSN#">
				SELECT
					EPP.PERIOD_ID
				FROM
					EMPLOYEE_POSITION_PERIODS EPP,
					EMPLOYEE_POSITIONS EP
				WHERE 
					EPP.POSITION_ID = EP.POSITION_ID AND
					EP.POSITION_CODE = #session.ep.position_code#
			</cfquery>
			<cfif get_period.recordcount>
				<cfset period_id_list = ValueList(get_period.period_id,',')>
			</cfif>
			<cfquery name="GET_POT_COMPANY" datasource="#DSN#">
				SELECT TOP #attributes.maxrows#
					C.COMPANY_ID, 
					C.FULLNAME,
					C.RECORD_DATE,
					CC.COMPANYCAT
				FROM 
					COMPANY C, 
					COMPANY_CAT CC
				WHERE
					C.COMPANY_ID IN 
					(
					SELECT 
						CP.COMPANY_ID
					FROM
						COMPANY_PERIOD CP
					WHERE
						CP.PERIOD_ID IN (#period_id_list#)
						AND
						C.COMPANY_ID = CP.COMPANY_ID
					)
					AND
					C.COMPANY_STATUS =1 AND 
					C.COMPANYCAT_ID = CC.COMPANYCAT_ID 
				<cfif get_companycat.recordcount>
					AND C.COMPANYCAT_ID IN (#valuelist(get_companycat.companycat_id,',')#)
				<cfelse>
					AND C.COMPANYCAT_ID IS NULL
				</cfif>
				<cfif session.ep.our_company_info.sales_zone_followup eq 1>
					<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
					AND (C.IMS_CODE_ID IN (	SELECT
												IMS_ID
											FROM
												SALES_ZONES_ALL_2
											WHERE
												POSITION_CODE = #session.ep.position_code# 
										 )
					<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
					<cfif get_hierarchies.recordcount>
					OR C.IMS_CODE_ID IN (SELECT
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
															<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
														</cfloop>
														
														)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
												</cfloop>											
										)
					  </cfif>						
					)
				</cfif>
				ORDER BY 
					C.RECORD_DATE DESC
			</cfquery>
            <tbody>
				<cfif get_pot_company.recordcount>
                    <cfoutput query="get_pot_company">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_pot_company.company_id#" class="tableyazi">#fullname#</a></td>
                            <td>#companycat#</td>
                            <td><cfif len(record_date)>#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)#</cfif></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
           </tbody>
		</cf_grid_list>
	</cf_box>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='30148.Bireysel Üye Başvuruları'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1" > 	
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
				<cfif isdefined('member_no') and member_no eq 1>
					<th><cf_get_lang dictionary_id='57558.Üye No'></th>
				</cfif>
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th width="115"><cf_get_lang dictionary_id='57486.Kategori'></th>
				<cfif isdefined('ref_no') and ref_no eq 1>
					<th width="80"><cf_get_lang dictionary_id='30593.Referans Kod'></th>
				</cfif>
				<cfif isdefined('is_ref_pos_code') and is_ref_pos_code eq 1>
					<th width="110"><cf_get_lang dictionary_id='58636.Referans Üye'></th>
				</cfif>
					<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
				</tr>
			</thead>
			<cfquery name="GET_POT_CONSUMER" datasource="#DSN#">
				SELECT TOP #attributes.maxrows#
					C.CONSUMER_ID,
					C.MEMBER_CODE, 
					C.CONSUMER_NAME,
					C.CONSUMER_REFERENCE_CODE,
					C.CONSUMER_SURNAME,
					C.RECORD_DATE,
					C.REF_POS_CODE,
					CC.CONSCAT							
				FROM 
					CONSUMER C,
					CONSUMER_CAT CC
				WHERE				
					C.PERIOD_ID IN (#period_id_list#) AND
					C.CONSUMER_STATUS = 1 AND 
					C.CONSUMER_CAT_ID = CC.CONSCAT_ID
				<cfif get_consumer_cat.recordcount>
					AND C.CONSUMER_CAT_ID IN (#valuelist(get_consumer_cat.conscat_id,',')#)
				<cfelse>
					AND C.CONSUMER_CAT_ID IS NULL
				</cfif>							
				<cfif session.ep.our_company_info.sales_zone_followup eq 1>
					<!--- Satis Takimda Ekip Lideri veya Satıs Takiminda Ekipde ise ilgili IMS ler--->
					AND 
					(
						C.IMS_CODE_ID IN 
						(	
							SELECT
								IMS_ID
							FROM
								SALES_ZONES_ALL_2
							WHERE
								POSITION_CODE = #session.ep.position_code# 
						)
					<!--- Satis bolgeleri ekibinde veya Satis bolgesinde yonetici ise kendisi ve altindaki IMS ler--->			
					<cfif get_hierarchies.recordcount>
					OR C.IMS_CODE_ID IN (	
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
										<cfif (add_stock mod row_block) neq 1> OR</cfif> SZ_HIERARCHY+'.' LIKE '#get_hierarchies.sz_hierarchy[add_stock]#%'
									</cfloop>
									
									)<cfif (ceiling(get_hierarchies.recordcount/row_block))-1 neq page_stock> OR</cfif>													
							</cfloop>											
										)
						</cfif>						
					)
				</cfif>							
				ORDER BY 
					C.RECORD_DATE DESC
			</cfquery>
			<cfset pos_code_list = ''>
			<cfif get_pot_consumer.recordcount>
				<cfoutput query="get_pot_consumer">
					<cfif len(ref_pos_code) and not Listfind(pos_code_list,ref_pos_code,',')>
						<cfset pos_code_list = listAppend(pos_code_list,ref_pos_code,',')>				
					</cfif>
				</cfoutput>
				<cfif len(pos_code_list)>
					<cfset pos_code_list=listsort(pos_code_list,"numeric","ASC",",")>
					<cfquery name="get_cons_name" datasource="#DSN#">
						SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#pos_code_list#) ORDER BY CONSUMER_ID
					</cfquery>
				</cfif>
			</cfif>
			<tbody>
				<cfif get_pot_consumer.recordcount>
					<cfoutput query="get_pot_consumer">
						<tr>
							<td>#currentrow#</td>
						<cfif isdefined('member_no') and member_no eq 1>
							<td>#member_code#</td>
						</cfif>
							<td><a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#consumer_id#" class="tableyazi">#consumer_name# #consumer_surname#</a></td>
							<td>#conscat#</td>
						<cfif isdefined('ref_no') and ref_no eq 1>
							<td>#ref_pos_code#</td>
						</cfif>
						<cfif isdefined('is_ref_pos_code') and is_ref_pos_code eq 1>
							<td width="110">
								<cfif len(ref_pos_code) and len(pos_code_list)>
									#get_cons_name.consumer_name[listfind(pos_code_list,ref_pos_code,',')]# #get_cons_name.consumer_surname[listfind(pos_code_list,ref_pos_code,',')]#
								</cfif>
							</td> 
						</cfif>
							<td width="65">#dateformat(date_add('h',session.ep.time_zone,record_date),dateformat_style)#</td>
						</tr>
					</cfoutput>
				<cfelse>
						<tr>
							<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>     
	</cf_box>     
</div>
<div class="col col-3 col-xs-12 uniqueRow" id="side">
	
		<cfif get_pot_company.recordcount>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="30154.Kurumsal Üye Profili"></cfsavecontent>
		<cf_box 
			closable="0" 
			
			title="#message#"
			box_page="#request.self#?fuseaction=member.popup_comp_graph">
		</cf_box>
		</cfif>

		<cfif get_pot_consumer.recordcount>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id="30159.Bireysel Üye Profili"></cfsavecontent>
		<cf_box 
			closable="0" 
			
			title="#message# "
			box_page="#request.self#?fuseaction=member.popup_cons_graph_ajax">
		</cf_box>
		</cfif>
	</div>
	
</div>
<br/>
<!-- sil -->
<script type="text/javascript">
	document.form.keyword.focus();
</script>
<!-- sil -->
