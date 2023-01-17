<cfif isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfinclude template="../query/get_assetps.cfm">
<cfinclude template="../query/get_assetp_cats.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_assetps.recordcount#>
<cfparam name="attributes.keyword" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="33612.Ortak Kullanım"></cfsavecontent>
<div class="col col-12">
	<cf_box title="#message#" uidrop="1" hide_table_column="1"> 
		<cfform name="search_asset" action="#request.self#?fuseaction=asset.list_assetp" method="post">
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<!--Fiziki varliklari kategori ve lokasyonlarina göre listeleyecegiz. -->
			<cf_box_search more="0">
					<!--- Arama --->
					<cfset extra_code = "">
					<cfset url_str = "">
				
					<cfif len(attributes.keyword)>
						<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
						<cfset extra_code = "#extra_code#&keyword=#attributes.keyword#">
					</cfif>
					<cfif isdefined("attributes.asset_cat") and len(attributes.asset_cat)>
						<cfset url_str = "#url_str#&asset_cat=#attributes.asset_cat#">
					</cfif>
					<cfif isdefined("attributes.assetp_state") and len(attributes.assetp_state)>
						<cfset url_str = "#url_str#&assetp_state=#attributes.assetp_state#">
					</cfif>
					<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
						<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
					</cfif>
					<cfif isdefined("attributes.asset_physical_status") and len(attributes.asset_physical_status)>
						<cfset url_str = "#url_str#&asset_physical_status=#attributes.asset_physical_status#">
					</cfif>
					<cfset url_str = "#url_str#&is_form_submitted=1">
					<div class="form-group" id="form_ul_keyword">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
						<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#message#">
					</div>
					<div class="form-group" id="item-asset_physical_status">
						<select name="asset_physical_status" id="asset_physical_status">
							<option value=""><cf_get_lang_main no='482.Statu'></option>
							<option value="1"<cfif isDefined("attributes.asset_physical_status") and (attributes.asset_physical_status eq 1)> selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
							<option value="0"<cfif isDefined("attributes.asset_physical_status") and (attributes.asset_physical_status eq 0)> selected</cfif>><cf_get_lang_main no='82.Pasif'></option>				
						</select>
					</div>		
					<div class="form-group" id="item-asset_cat">
						<select name="asset_cat" id="asset_cat">
							<option value="0"><cf_get_lang_main no='74.Kategori'> 
							<cfoutput query="get_assetp_cats">
							<option value="#assetp_catid#" <cfif isdefined("attributes.asset_cat")><cfif attributes.asset_cat eq assetp_catid>selected</cfif></cfif>>#assetp_cat# 
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-department">
						<select name="DEPARTMENT_ID" id="DEPARTMENT_ID" style="width:280px">
							<option value=""><cf_get_lang_main no='160.Departman'>
							<cfoutput query="dep">
							<option value="#department_id#" <cfif isdefined("attributes.DEPARTMENT_ID")><cfif attributes.DEPARTMENT_ID eq department_id>selected</cfif></cfif>>#BRANCH_NAME# / #DEPARTMENT_HEAD# 
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="item-status_assetp">
						<cfsavecontent variable="text"><cf_get_lang_main no ='344.Durum'></cfsavecontent>
						<cf_wrk_combo
							name="assetp_state"
							query_name="GET_ASSET_STATE"
							option_name="ASSET_STATE"
							option_value="ASSET_STATE_ID"
							value="#iif(isdefined("attributes.assetp_state"),'attributes.assetp_state',DE(''))#"
							option_text="#text#"
							width=120>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
					</div>
					<div class="form-group">
						<cf_wrk_search_button  button_type="4">
					</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang_main no='1165.Sıra'></th>
					<cfoutput>
						<cfif isDefined("attributes.click_count") and (attributes.click_count eq 0)>
							<cfset attributes.click_count = 1>
						<cfelse>
							<cfset attributes.click_count = 0>			
						</cfif>		
						<th class="header_icn_none"></th>
						<!--- <th><a style="cursor:pointer;" onclick="window.location.href='#request.self#?fuseaction=asset.list_assetp&order_assetp_name=&click_count=#attributes.click_count#&type=0#extra_code#'"><cf_get_lang_main no='1655.Varlık'></a></th> --->
						<th><a style="cursor:pointer;"><cf_get_lang_main no='1655.Varlık'></a></th>
						<th><cf_get_lang_main no='74.Kategori'></th>
						<th><cf_get_lang_main no ='344.Durum'></th>
						<th><cf_get_lang_main no='2234.Lokasyon'></th>
						<th><cf_get_lang_main no='132.Sorumlu'></th>
					</cfoutput>
				</tr>
			</thead>
			<tbody>
				<cfif get_assetps.recordcount and form_varmi eq 1>
					<cfoutput query="get_assetps" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfset attributes.assetp_id = assetp_id>
						<cfinclude template="../query/get_assetp_reserve.cfm">
						<tr>
							<td>#currentrow#</td>
							<cfquery name="GET_ASS_P_RESERVE" datasource="#dsn#">
								SELECT
									*
								FROM
									ASSET_P_RESERVE
								WHERE
									ASSETP_ID = #get_assetps.ASSETP_ID#
							</cfquery>
							<!-- sil -->
							<td>
								<cfif (NOW() GTE GET_ASS_P_RESERVE.STARTDATE) AND (NOW() LTE GET_ASS_P_RESERVE.FINISHDATE )>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=asset.popup_list_assetp_rezerve&asset_id=#assetp_id#');"  alt="<cf_get_lang dictionary_id='54670.Rezerve Edildi'>" title="<cf_get_lang dictionary_id='54670.Rezerve Edildi'>"><i class='fa fa-flag'></i></a>				
								<cfelse>
									<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=asset.popup_list_assetp_rezerve&asset_id=#assetp_id#');" alt="<cf_get_lang dictionary_id='54670.Rezerve Edildi'>" title="<cf_get_lang dictionary_id='54670.Rezerve Edildi'>"><i class='fa fa-flag'></i></a>				
								</cfif>
							</td>
							<!-- sil -->
							<td>
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=asset.popup_dsp_assetp&ASSETP_ID=#assetp_id#','medium')" >#assetp#</a>
							</td>
							<td>#assetp_cat#</td>
							<td>
								<cfif len(ASSETP_STATUS)>
									<cfquery name="get_assetp_STATE" datasource="#dsn#">
										SELECT ASSET_STATE FROM ASSET_STATE WHERE ASSET_STATE_ID = #ASSETP_STATUS#
									</cfquery>
									#get_assetp_STATE.ASSET_STATE#
								</cfif>
							</td>
							<td>#zone_name# / #branch_name# / #department_head#</td>
							<td>
								<cfquery name="get_emp_info" datasource="#dsn#">
								SELECT 
									EMPLOYEE_POSITIONS.EMPLOYEE_ID,
									EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
									EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
								FROM 
									ASSET_P,
									BRANCH,
									EMPLOYEE_POSITIONS
								WHERE
									BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) 
									AND ASSET_P.POSITION_CODE = EMPLOYEE_POSITIONS.POSITION_CODE 
									AND BRANCH.BRANCH_ID = #branch_id#
									AND ASSET_P.ASSETP_ID = #assetp_id# 
								</cfquery>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_emp_info.employee_id#','medium')">#get_emp_info.employee_name# #get_emp_info.employee_surname# </a>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="10"><cfif form_varmi eq 0><cf_get_lang_main no='289. Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>
		<cfif form_varmi eq 1>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="asset.list_assetp#url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
