<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch" default="">
<cfparam name="attributes.is_status" default="">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_FUEL_KM" datasource="#DSN#">
		SELECT
			AP.ASSETP,
			AP.STATUS,
			AP.POSITION_CODE,
			AP.DEPARTMENT_ID,
			APKM.KM_CONTROL_ID,
			APKM.EMPLOYEE_ID,
			APKM.START_DATE,
			APKM.FINISH_DATE,
			APKM.KM_START,
			APKM.KM_FINISH,
			APF.TOTAL_AMOUNT,
			APF.TOTAL_CURRENCY,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			(SELECT MAX(KM_FINISH) FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = AP.ASSETP_ID) AS AA_KM_LAST,
			(SELECT MAX(KM_CONTROL_ID) FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = AP.ASSETP_ID) AS KM_CONTROL_ID_LAST	
		FROM
			ASSET_P AP,
			ASSET_P_KM_CONTROL APKM,
			ASSET_P_FUEL APF,
			DEPARTMENT D,
			BRANCH B,
			ZONE Z
		WHERE
			APKM.FUEL_ID IS NOT NULL AND
			<!--- Misir ATS icin yapilan KM Sayac Degeri degistirmek icin onlar gelmesin BK 20080813 --->
			<cfif database_type is 'MSSQL'>
				ISNULL(APKM.IS_COUNTER_CHANGE,0) <> 1 AND
			<cfelseif database_type is 'DB2'>
				COALESCE(APKM.IS_COUNTER_CHANGE,0) <> 1 AND
			</cfif>			
			<cfif len(attributes.keyword)>
				AP.ASSETP LIKE '%#attributes.keyword#%' AND
			</cfif>
			<cfif len(attributes.branch_id) and len(attributes.branch)>
				B.BRANCH_ID = #attributes.branch_id# AND
			</cfif>
			<cfif len(attributes.is_status)>
				AP.STATUS = #attributes.is_status# AND
			</cfif>
			AP.ASSETP_ID = APKM.ASSETP_ID AND
			D.DEPARTMENT_ID = APKM.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND
			B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) AND
			B.ZONE_ID = Z.ZONE_ID AND
			APF.FUEL_ID = APKM.FUEL_ID
	</cfquery>
	<cfparam name="attributes.totalrecords" default="#get_fuel_km.recordCount#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_fuel_km" action="#request.self#?fuseaction=assetcare.list_fuel_km" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="">
			<cf_box_search more="0">	
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="Text" name="keyword" maxlength="50" placeholder="#place#" value="#attributes.keyword#" style="width:120px;">
				</div>	
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='57453.Şube'></cfsavecontent>
						<cfinput type="hidden" name="branch_id" value="#attributes.branch_id#"> 
						<cfinput type="text" name="branch" placeholder="#place#" value="#attributes.branch#" style="width:120px;"> 
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_fuel_km.branch&field_branch_id=search_fuel_km.branch_id','list','popup_list_branches')"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="is_status" id="is_status" style="width:65px;">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.is_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(685,'Yakıt-KM',48556)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='29453.Plaka'></th>
					<th ><cf_get_lang dictionary_id='57544.Sorumlu'></th>
					<th><cf_get_lang dictionary_id='30031.Lokasyon'></th>
					<th><cf_get_lang dictionary_id='57655.Baş Tarihi'></th>
					<th><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='48228.Önceki KM'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='48090.Son KM'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='58583.Fark'></th>
					<th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<!-- sil -->
					<th width="20" class="header_icn_none text-center"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_fuel_km','project','popup_add_fuel_km');"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_submitted") and get_fuel_km.recordcount>
				<cfset employee_list = "">
					<cfoutput query="get_fuel_km" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(employee_id) and not listfind(employee_list,employee_id)>
							<cfset employee_list = Listappend(employee_list,employee_id)>
						</cfif>
					</cfoutput>
					<cfif len(employee_list)>
						<cfquery name="GET_EMPLOYEE" datasource="#DSN#">
							SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#) ORDER BY EMPLOYEE_ID
						</cfquery>
						<cfset employee_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_fuel_km" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#assetp#</td>
							<td>#get_employee.employee_name[listfind(employee_list,employee_id,',')]# #get_employee.employee_surname[listfind(employee_list,employee_id,',')]#</td>
							<td>#branch_name# / #department_head#</td>
							<td>#dateformat(start_date,dateformat_style)#</td>
							<td>#dateformat(finish_date,dateformat_style)#</td>
							<td style="text-align:right;">#km_start#</td>
							<td style="text-align:right;">#km_finish#</td>
							<td style="text-align:right;">#km_finish - km_start#</td>
							<td style="text-align:right;">#TLFormat(total_amount)# #total_currency#</td>
							<!-- sil -->
							<td>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=assetcare.popup_upd_fuel_km&km_control_id=#km_control_id#','project','popup_upd_fuel_km');">
								<!--- <cfif aa_km_last eq km_finish> --->
								<cfif km_control_id_last eq km_control_id>
									<i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								<cfelse>
									<i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='48264.Yakıt Güncelle'>" title="<cf_get_lang dictionary_id='48264.Yakıt Güncelle'>"></i></a>
								</cfif>
							</td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>	
					<tr>
						<td colspan="17"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfset url_str = "">
		<cfif isdefined("form_submitted")>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.branch_id) and len(attributes.branch)>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
			<cfset url_str = "#url_str#&branch=#attributes.branch#">
		</cfif>
		<cfif len(attributes.is_status)>
			<cfset url_str = "#url_str#&is_status=#attributes.is_status#">
		</cfif>
		<cf_paging
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="assetcare.list_fuel_km#url_str#">
	</cf_box>
</div>
