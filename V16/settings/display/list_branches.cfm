<cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
<cfset get_api_key = googleapi.get_api_key()>
<cf_get_lang_set module_name="settings">
	<cfparam name="attributes.is_active" default=1>
	<cfparam name="attributes.company_ids" default=''>
	<cfparam name="attributes.branch_cat" default=''>
	<cfparam name="attributes.keyword" default=''>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_branches" datasource="#dsn#">
		SELECT
			BRANCH.BRANCH_STATUS,
			BRANCH.HIERARCHY,
			BRANCH.HIERARCHY2,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			BRANCH.EXPENSE_UNIT_CODE1,
			BRANCH.EXPENSE_UNIT_CODE2,
			BRANCH.EXPENSE_UNIT_CODE3,
			BRANCH.EXPENSE_UNIT_CODE4,
			BRANCH.EXPENSE_UNIT_CODE5,
			BRANCH.ISKUR_BRANCH_NO,
			BRANCH.COORDINATE_1,
			BRANCH.COORDINATE_2,
			OUR_COMPANY.COMP_ID,
			OUR_COMPANY.COMPANY_NAME,
			#dsn#.Get_Dynamic_Language(SETUP_BRANCH_CAT.BRANCH_CAT_ID,'#session.ep.language#','SETUP_BRANCH_CAT','BRANCH_CAT',NULL,NULL,SETUP_BRANCH_CAT.BRANCH_CAT) AS BRANCH_CAT
		FROM
			BRANCH LEFT JOIN SETUP_BRANCH_CAT ON SETUP_BRANCH_CAT.BRANCH_CAT_ID = BRANCH.BRANCH_CAT_ID,
			OUR_COMPANY
		WHERE
			BRANCH.BRANCH_ID IS NOT NULL
			AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID 
			<cfif len(attributes.company_ids) and (attributes.company_ids neq -1)>
				AND BRANCH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_ids#">
			</cfif>
			<cfif len(attributes.branch_cat)>
				AND BRANCH.BRANCH_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_cat#">
			</cfif>
			<cfif len(attributes.keyword) and (len(attributes.keyword) eq 1)>
				AND BRANCH.BRANCH_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			<cfelseif len(attributes.keyword) and (len(attributes.keyword) gt 1)>
				AND BRANCH.BRANCH_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
			</cfif>
			<cfif attributes.is_active is 1>
				AND BRANCH.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_active#">
			<cfelseif attributes.is_active is 0>
				AND BRANCH.BRANCH_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.is_active#">
			</cfif>
			<cfif fusebox.circuit eq 'hr' and not get_module_power_user(67)>
				AND BRANCH.BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
			</cfif>
		ORDER BY
			OUR_COMPANY.NICK_NAME,
			BRANCH.BRANCH_NAME
	</cfquery>
	<cfelse>
		<cfset get_branches.recordcount=0>
	</cfif>
	<cfquery name="get_comps" datasource="#dsn#">
		SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY ORDER BY NICK_NAME
	</cfquery>
	<cfquery name="GET_BRANCH_CAT" datasource="#DSN#">
		SELECT BRANCH_CAT_ID,BRANCH_CAT FROM SETUP_BRANCH_CAT ORDER BY BRANCH_CAT
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_branches.RecordCount#">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cfform name="form" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches" method="post">
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<cf_box_search>
					<div class="form-group">
						<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang(48,'Filtre',57460)#">
					</div>
					<div class="form-group">
						<select name="is_active" id="is_active" style="width:75px;">
							<option value="1" <cfif attributes.is_active is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
							<option value="0" <cfif attributes.is_active is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
							<option value="2" <cfif attributes.is_active is 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'>
						</select>
					</div>
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
					</div>
					<cfif isdefined("attributes.form_submitted") and len(get_api_key.GOOGLE_API_KEY)>
                        <cfset branchId = arrayNew(1)>
						<div class="form-group">
							<cfloop query="get_branches">
								<cfif len(coordinate_1) and len(coordinate_2)>
									<cfset ArrayAppend(branchId, BRANCH_ID) />
								</cfif>
							</cfloop>
							<cfoutput>
                                <a class="ui-btn ui-btn-green" target="_blank" href="#request.self#?fuseaction=hr.list_branches&event=googleMap&zoom=6&type=list&branchId=#encodeForURL(branchId.toString())#" title="<cf_get_lang dictionary_id='64582.Şubeleri haritada göster'>"><i class="fa fa-map-marker"></i></a>
                            </cfoutput>
						</div>
					</cfif>
				</cf_box_search>
				<cf_box_search_detail>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-company_ids">
							<label class="col col-12"><cfoutput>#getLang(162,'Şirket',57574)#</cfoutput></label>
							<div class="col col-12">
								<select name="company_ids" id="company_ids" style="width:200px;">
									<option value="-1" <cfif len(attributes.company_ids) and (attributes.company_ids eq -1)>selected</cfif>><cf_get_lang dictionary_id='43266.Tüm Şirketler'></option>
									<cfoutput query="get_comps">
										<option value="#COMP_ID#" <cfif len(attributes.company_ids) and (attributes.company_ids eq COMP_ID)>selected</cfif>>#NICK_NAME#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-branch_cat">
							<label class="col col-12"><cfoutput>#getLang(1261,'Şube Tipi',43244)#</cfoutput></label>
							<div class="col col-12"> 
								<select name="branch_cat" id="branch_cat" style="width:153px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_branch_cat">
										<option value="#branch_cat_id#" <cfif len(attributes.branch_cat) and (attributes.branch_cat eq branch_cat_id)>selected</cfif>>#branch_cat#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
				</cf_box_search_detail>
			</cfform>
		</cf_box>
		<cf_box title="#getLang(1637,'Şubeler',29434)#" uidrop="1" hide_table_column="1">
			<cf_flat_list>
				<thead>
					<tr>
						<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='57574.Şirket'></th>
						<th><cf_get_lang dictionary_id='57453.Şube'></th>
						<th><cf_get_lang dictionary_id='43244.Sube Tipi'></th>
						<th><cf_get_lang dictionary_id='57894.Statü'></th>
						<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
						<th><cf_get_lang dictionary_id='57789.Özel Kod'>2</th>
						<th><cf_get_lang dictionary_id='51532.Harcama'><cf_get_lang dictionary_id='57636.Birim'><cf_get_lang dictionary_id='50905.Kodu'></th>
						<th><cf_get_lang dictionary_id='62977.İşkur No'></th>
						<!-- sil -->
						<th width="20" class="header_icn_none text-center"></th>
						<th width="20" class="header_icn_none text-center"></th>
						<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_branches&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
					</tr>
				</thead>
				<tbody>
					<cfif get_branches.RecordCount>
						<cfoutput query="get_branches" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
							<tr>
								<td>#currentrow#</td>
								<td>#company_name#</td>
								<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches&event=upd&id=#BRANCH_ID#" class="tableyazi">#branch_name#</a></td>
								<td>#branch_cat#</td>
								<td><cfif BRANCH_STATUS eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
								<td>#hierarchy#</td>
								<td>#hierarchy2#</td>
								<td><cfif EXPENSE_UNIT_CODE1 neq "" and EXPENSE_UNIT_CODE2 neq "" and EXPENSE_UNIT_CODE3 neq "" and EXPENSE_UNIT_CODE4  neq "" and EXPENSE_UNIT_CODE5 neq "">#EXPENSE_UNIT_CODE1#-#EXPENSE_UNIT_CODE2#-#EXPENSE_UNIT_CODE3#-#EXPENSE_UNIT_CODE4#-#EXPENSE_UNIT_CODE5#</cfif></td>
								<td>#ISKUR_BRANCH_NO#</td>
								<!-- sil -->
								<td><a href="javascript:openBoxDraggable('#request.self#?fuseaction=settings.list_branches&event=upd_ssk&ID=#branch_id#&upd_control=1','medium')"><i class="fa fa-bank" alt="<cf_get_lang dictionary_id='42354.SSK Bilgileri'>" title="<cf_get_lang dictionary_id='42354.SSK Bilgileri'>"></i></a></td>
								<td><a href="javascript:openBoxDraggable('#request.self#?fuseaction=hr.list_branches&event=addPeriod&branch_id=#branch_id#')"><i class="fa fa-table" alt="<cf_get_lang dictionary_id='57447.Muhasebe'>" title="<cf_get_lang dictionary_id='57447.Muhasebe'>"></i></a></td>
								<td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches&event=upd&id=#branch_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
							</tr>
						</cfoutput> 
					<cfelse>
						<tr> 
							<td colspan="11"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
						</tr>
					</cfif>
				</tbody>
			</cf_flat_list>
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfif len(attributes.form_submitted)>
					<cfset formun_adresi = "#listgetat(attributes.fuseaction,1,'.')#.list_branches&form_submitted=#attributes.form_submitted#">
				</cfif>
				<cf_paging page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#formun_adresi#&keyword=#attributes.keyword#&is_active=#attributes.is_active#&company_ids=#attributes.company_ids#&branch_cat=#attributes.branch_cat#&form_submitted=#form_submitted#"> 
			</cfif>
		</cf_box>
	</div>
	
	<script type="text/javascript">
		  document.getElementById('keyword').focus();
	</script>
	<cf_get_lang_set module_name="#fusebox.circuit#">
	