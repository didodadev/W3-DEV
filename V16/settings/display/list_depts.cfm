<cf_get_lang_set module_name="settings">
<cfparam name="attributes.is_active" default=1>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.up_department_id" default="">
<cfparam name="attributes.up_department" default="">
<cfparam name="attributes.is_store" default="">
<cfparam name="attributes.dep_cat" default="">
<cfparam name="attributes.depatment_type" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	dep_type = QueryNew("DEP_TYPE_ID, DEP_TYPE_NAME");
	QueryAddRow(dep_type,3);
	QuerySetCell(dep_type,"DEP_TYPE_ID",1,1);
	QuerySetCell(dep_type,"DEP_TYPE_NAME","#getLang(1351,'Depo',58763)#",1); //depo
	QuerySetCell(dep_type,"DEP_TYPE_ID",2,2);
	QuerySetCell(dep_type,"DEP_TYPE_NAME",'#getLang(160,'Departman',57572)#',2);//departman
	QuerySetCell(dep_type,"DEP_TYPE_ID",3,3);
	QuerySetCell(dep_type,"DEP_TYPE_NAME",'#getLang(1351,'Depo',58763)# ve #getLang(160,'Departman',57572)#',3);//depo ve departman
</cfscript>
<cfif isdefined("attributes.form_submitted")>
<cfquery name="get_depts" datasource="#DSN#">
	SELECT
		D.DEPARTMENT_STATUS,
		D.DEPARTMENT_ID,
		D.HIERARCHY,
		D.HEADQUARTERS_ID,
		D.DEPARTMENT_HEAD,
        D.LEVEL_NO,
        D.HIERARCHY_DEP_ID,
		D.DEPARTMENT_CAT,
		D.DEPARTMENT_TYPE,
        O.NICK_NAME,
		B.BRANCH_NAME,
		D.IS_STORE,
		E.EMPLOYEE_NAME + ' ' +E.EMPLOYEE_SURNAME AS ADMIN1_NAME,
		E2.EMPLOYEE_NAME + ' ' +E2.EMPLOYEE_SURNAME AS ADMIN2_NAME
	FROM
		DEPARTMENT D
		INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
		INNER JOIN OUR_COMPANY O ON B.COMPANY_ID = O.COMP_ID
		LEFT JOIN EMPLOYEE_POSITIONS E ON D.ADMIN1_POSITION_CODE = E.POSITION_CODE AND D.ADMIN1_POSITION_CODE > 0
		LEFT JOIN EMPLOYEE_POSITIONS E2 ON D.ADMIN2_POSITION_CODE = E2.POSITION_CODE AND D.ADMIN2_POSITION_CODE > 0
	WHERE
		<cfif attributes.is_active is 1>
			D.DEPARTMENT_STATUS = 1
		<cfelseif attributes.is_active is 0>
			D.DEPARTMENT_STATUS = 0
		<cfelse>
			D.DEPARTMENT_STATUS IS NOT NULL
		</cfif>	
		<cfif len(attributes.keyword) and (len(attributes.keyword) eq 1)>
			AND D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		<cfelseif len(attributes.keyword) and (len(attributes.keyword) gt 1)>
			AND D.DEPARTMENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI
		</cfif>
		<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
			AND O.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif isDefined("attributes.branch_id") and len(attributes.branch_id)>
			AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
		</cfif>
		<cfif isdefined("attributes.up_department_id") and len(attributes.up_department_id) and isdefined('attributes.up_department') and len(attributes.up_department)>
			AND(D.HIERARCHY_DEP_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%.#attributes.up_department_id#.%"> OR D.HIERARCHY_DEP_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.up_department_id#.%">)
		</cfif> 
		<cfif fusebox.circuit eq 'hr' and not get_module_power_user(67)>
			AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
        <cfif isDefined("attributes.is_store") and len(attributes.is_store)>
        	AND D.IS_STORE IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.is_store#">)
        </cfif>
		<cfif isDefined("attributes.dep_cat") and len(attributes.dep_cat)>
        	AND D.DEPARTMENT_CAT =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dep_cat#">
        </cfif>
		<cfif isDefined("attributes.depatment_type") and len(attributes.depatment_type)>
			AND D.DEPARTMENT_TYPE = <cfqueryparam value="#attributes.depatment_type#" cfsqltype="cf_sql_integer">
		</cfif>
	ORDER BY
		B.BRANCH_NAME,D.DEPARTMENT_HEAD
</cfquery>
	<cfquery name="GET_DEP_EMP_COUNT" datasource="#dsn#">
        SELECT
        	DEPARTMENT_ID,
            COUNT(DEPARTMENT_ID) AS TOTAL 
        FROM 
            EMPLOYEE_POSITIONS 
      	GROUP BY
        	DEPARTMENT_ID
    </cfquery>
<cfelse>
	<cfset get_depts.recordcount=0>
</cfif>
<cfparam name="attributes.totalrecords" default="#get_depts.RecordCount#">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#getLang(48,'Filtre',57460)#">
				</div>
				<cfquery name="GET_COMPANY" datasource="#dsn#">
					SELECT COMPANY_NAME,COMP_ID FROM OUR_COMPANY ORDER BY COMPANY_NAME
				</cfquery>
				<div class="form-group">
					<select name="is_active" id="is_active" style="width:55px;">
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
					<cfif fusebox.circuit neq 'hr'><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></cfif>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-GET_COMPANY">
						<label class="col col-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
						<div class="col col-12">
							<select name="company_id" id="company_id" onchange="Load_Branch(this.value)">
								<option value=""><cf_get_lang dictionary_id='43266.Tüm Şirketler'></option>
								<cfoutput query="GET_COMPANY">
									<option value="#comp_id#" <cfif comp_id eq attributes.company_id>selected</cfif>>#company_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-dep_cat">
						<label class="col col-12"><cf_get_lang dictionary_id='64604.Departman Kategorisi'></label>
						<div class="col col-12">
							<cfquery name="get_dep_cat" datasource="#dsn#">
								SELECT DEPARTMENT_CAT,DEPARTMENT_CAT_ID FROM SETUP_DEPARTMENT_CAT
							</cfquery>
							<select name="dep_cat" id="dep_cat">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_dep_cat">
									<option value="#DEPARTMENT_CAT_ID#" <cfif DEPARTMENT_CAT_ID eq attributes.dep_cat>selected</cfif>>#DEPARTMENT_CAT#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-GET_BRANCH">
						<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-12"> 
							<cfquery name="GET_BRANCH" datasource="#dsn#">
								SELECT 
									BRANCH_NAME,
									BRANCH_ID,
									BRANCH_STATUS 
								FROM 
									BRANCH
								<cfif fusebox.circuit eq 'hr' and not get_module_power_user(67)>
								WHERE
									BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
								</cfif>
								ORDER BY 
									BRANCH_NAME
							</cfquery>
							<select name="branch_id" id="branch_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="GET_BRANCH">
									<option value="#branch_id#" <cfif branch_id eq attributes.branch_id>selected</cfif>><cfif BRANCH_STATUS eq 0>#BRANCH_NAME# - (pasif)<cfelse>#BRANCH_NAME#</cfif></option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-depatment_type">
						<label class="col col-12"><cf_get_lang dictionary_id='64601.Departman Türü'></label>
						<div class="col col-12">
							<cfquery name="get_dep_type" datasource="#dsn#">
								SELECT DEPARTMENT_TYPE,DEPARTMENT_TYPE_ID FROM SETUP_DEPARTMENT_TYPE
							</cfquery>
							<select name="depatment_type" id="depatment_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_dep_type">
									<option value="#DEPARTMENT_TYPE_ID#" <cfif DEPARTMENT_TYPE_ID eq attributes.depatment_type>selected</cfif>>#DEPARTMENT_TYPE#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-up_department">
						<label class="col col-12"><cfoutput>#getLang(352,'Üst Departman',42335)#</cfoutput></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="up_department_id" id="up_department_id" value="<cfif isdefined('attributes.up_department_id')><cfoutput>#attributes.up_department_id#</cfoutput></cfif>">
								<input type="text" name="up_department" id="up_department" value="<cfif isdefined('attributes.up_department_id') and len(attributes.up_department_id) and len(attributes.up_department)><cfoutput>#attributes.up_department#</cfoutput></cfif>">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_departments&field_id=form.up_department_id&field_name=form.up_department</cfoutput>','','ui-draggable-box-small');"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-dep_type">
						<label class="col col-12"><cfoutput>#getLang(218,'Tip',57630)#</cfoutput></label>
						<div class="col col-12"> 
							<cf_multiselect_check 
								query_name="dep_type"  
								name="is_store"
								width="110" 
								option_value="DEP_TYPE_ID"
								option_name="DEP_TYPE_NAME"
								value="#attributes.is_store#"
								option_text="#getLang(322,'Seçiniz',57734)#">
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(132,'Departmanlar',42115)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang dictionary_id='57574.Şirket'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='64604.Departman Kategorisi'></th>
					<th><cf_get_lang dictionary_id='64601.Departman Türü'></th>
					<th><cf_get_lang dictionary_id='57761.Hiararşi'></th>
					<th><cf_get_lang dictionary_id='43091.Kademe Numarası'></th>
					<th><cf_get_lang dictionary_id='42335.Üst Departman'></th>
					<th><cf_get_lang dictionary_id='57630.Tip'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='29511.Yönetici'> 1</th>
					<th><cf_get_lang dictionary_id='29511.Yönetici'> 2</th>
					<th width="30"><cf_get_lang dictionary_id='42613.Çalışan Sayısı'></th>
					<th width="20" class="header_icn_none text-center">
						<a href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts&event=add</cfoutput>"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
					</th>
				</tr>
			</thead>
			<tbody>
				<cfif get_depts.recordcount>
					<cfoutput query="get_depts" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#nick_name#</td>
							<td>#branch_name#</td>
							<td>
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts&event=upd&id=#department_id#" class="tableyazi">#department_head#</a>
							</td>
							<td>
								<cfif len(DEPARTMENT_CAT)>
									<cfquery name="get_dep_cat_name" datasource="#dsn#">
										SELECT DEPARTMENT_CAT,DEPARTMENT_CAT_ID FROM SETUP_DEPARTMENT_CAT WHERE DEPARTMENT_CAT_ID= <cfqueryparam value="#get_depts.DEPARTMENT_CAT#" cfsqltype="cf_sql_integer">
									</cfquery>
									#get_dep_cat_name.DEPARTMENT_CAT#
								</cfif>
							</td>
							<td>
								<cfif len(DEPARTMENT_TYPE)>
									<cfquery name="get_dep_type_name" datasource="#dsn#">
										SELECT DEPARTMENT_TYPE,DEPARTMENT_TYPE_ID FROM SETUP_DEPARTMENT_TYPE WHERE DEPARTMENT_TYPE_ID= <cfqueryparam value="#get_depts.DEPARTMENT_TYPE#" cfsqltype="cf_sql_integer">
									</cfquery>
									#get_dep_type_name.DEPARTMENT_TYPE#
								</cfif>
							</td>
							<td>#hierarchy#</td>
							<td>#level_no#</td>
							<td>
								<cfif listlen(hierarchy_dep_id,'.') gt 1>
									<cfset up_dep=ListGetAt(hierarchy_dep_id,evaluate("#listlen(hierarchy_dep_id,".")#-1"),".") >	
									<cfquery name="departments" datasource="#dsn#">
										SELECT 
											DEPARTMENT_HEAD 
										FROM
											DEPARTMENT
										WHERE 
											DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#up_dep#">
									</cfquery>
									<cfset up_dep_name="#departments.department_head#">
								<cfelse>
									<cfset up_dep_name="">	
								</cfif>
								#up_dep_name#
							</td>
							<td><cfif is_store eq 1><cf_get_lang dictionary_id='58763.Depo'><cfelseif is_store eq 2><cf_get_lang dictionary_id='57572.Departman'><cfelseif is_store eq 3><cf_get_lang dictionary_id='58763.Depo'> ve <cf_get_lang dictionary_id='57572.Departman'></cfif></td>
							<td><cfif department_status eq 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
							<td>#ADMIN1_NAME#</td>
							<td>#ADMIN2_NAME#</td>
							<td>
								<cfquery name="get_emp_count" dbtype="query">
									SELECT
										TOTAL
									FROM
										GET_DEP_EMP_COUNT
									WHERE
										DEPARTMENT_ID = #department_id#  
								</cfquery>
								<cfif get_emp_count.recordcount>#get_emp_count.total#<cfelse>0</cfif>
							</td>
							<td>
								<a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_depts&event=upd&id=#department_id#"><i class="fa fa-pencil" alt="<cf_get_lang dictionary_id='57464.Guncelle'>" title="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a>
							</td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="12"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.form_submitted)>
				<cfset formun_adresi = "#listgetat(attributes.fuseaction,1,'.')#.list_depts&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif len(attributes.is_store)>
				<cfset formun_adresi = "#formun_adresi#&is_store=#attributes.is_store#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#formun_adresi#&keyword=#attributes.keyword#&is_active=#attributes.is_active#&company_id=#attributes.company_id#&branch_id=#attributes.branch_id#&up_department_id=#attributes.up_department_id#&up_department=#attributes.up_department#"> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
<cfif isdefined("attributes.company_id")>
    Load_Branch(<cfoutput>#attributes.company_id#</cfoutput>);
</cfif>
function Load_Branch(company_id)
{
	var option_count_sub = document.getElementById('branch_id').options.length; 
	for(y=option_count_sub;y>=0;y--)
		document.getElementById('branch_id').options[y] = null;
	document.getElementById('branch_id').options.value=0;
	var deger = workdata('get_branch',company_id);
	document.getElementById('branch_id').options[0]=new Option('Şubeler','')
	for(var jj=0;jj<deger.recordcount;jj++)
	{
		if('<cfoutput>#attributes.branch_id#</cfoutput>' == deger.BRANCH_ID[jj])
			var goster=true;
		else 
			var goster=false;	
		document.getElementById('branch_id').options[jj+1]=new Option(deger.BRANCH_NAME[jj],deger.BRANCH_ID[jj],goster,goster);
	}	
}
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
