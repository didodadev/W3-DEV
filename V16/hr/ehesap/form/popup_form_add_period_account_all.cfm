<style>
	#btnNext, #btnPrev, #btnNextLast, #btnPrevLast { display:none; }
</style>
<cfscript>
	CreateCompenent = createObject("component", "/V16/workdata/get_branches");
	get_all_branches = CreateCompenent.get_branches_fnc(is_comp_branch : 0, is_pos_branch: 0, is_branch_status: 0,modul: '<cfoutput>#fusebox.circuit#</cfoutput>');
</cfscript>

<cfset payroll_accounts= createObject("component","V16.hr.ehesap.cfc.payroll_accounts_code") />
<cfset get_code_cat=payroll_accounts.GET_CODE_CAT(payroll_id : iif(isdefined("get_position.ACCOUNT_BILL_TYPE"),"get_position.ACCOUNT_BILL_TYPE",DE('')))/>
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
	cmp = createObject("component","V16.hr.ehesap.cfc.periods_to_in_out");
	get_acc_type = cmp.setup_acc_type();
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');
	attributes.startrow=((attributes.page-1)*attributes.maxrows)+1;
</cfscript>
<cfparam name="attributes.startdate" default="#date_add('m',-1,bu_ay_basi)#">
<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
<cfif isdefined("attributes.is_submit") and len(attributes.branch_id)>
	<cf_date tarih="attributes.startdate">
	<cf_date tarih="attributes.finishdate">
	<cfquery name="get_position" datasource="#dsn#">
		SELECT
			REPLACE(REPLACE(E.EMPLOYEE_NAME, CHAR(13), ''), CHAR(9), '') + ' ' + REPLACE(REPLACE(E.EMPLOYEE_SURNAME, CHAR(13), ''), CHAR(9), '') AS EMPLOYEE_NAME,
			E.EMPLOYEE_ID,
			EIO.IN_OUT_ID,
			REPLACE(REPLACE(D.DEPARTMENT_HEAD, CHAR(13), ''), CHAR(9), '') AS DEPARTMENT_HEAD,
			REPLACE(REPLACE(B.BRANCH_NAME, CHAR(13), ''), CHAR(9), '') AS BRANCH_NAME,
			REPLACE(REPLACE(ISNULL(EP.POSITION_NAME,''), CHAR(13), ''), CHAR(9), '') AS POSITION_NAME,
			ISNULL(EIOP.ACCOUNT_BILL_TYPE,'') ACCOUNT_BILL_TYPE,
			ISNULL(EIOP.EXPENSE_CENTER_ID,'') EXPENSE_CENTER_ID,
			REPLACE(REPLACE(ISNULL(EIOP.EXPENSE_CODE,''), CHAR(13), ''), CHAR(9), '') AS EXPENSE_CODE,
			REPLACE(REPLACE(ISNULL(EIOP.EXPENSE_CODE_NAME,''), CHAR(13), ''), CHAR(9), '') AS EXPENSE_CODE_NAME,
			ISNULL(EIOP.EXPENSE_ITEM_ID,'') EXPENSE_ITEM_ID,
			REPLACE(REPLACE(ISNULL(EIOP.EXPENSE_ITEM_NAME,''), CHAR(13), ''), CHAR(9), '') AS EXPENSE_ITEM_NAME,
			ISNULL(EIOP.ACTIVITY_TYPE_ID,'') ACTIVITY_TYPE_ID
			<cfif get_acc_type.recordcount>
				<cfoutput query="get_acc_type">
					,REPLACE(REPLACE(ISNULL(ACC_CODE_#currentrow#.ACCOUNT_CODE,''), CHAR(13), ''), CHAR(9), '') AS ACCOUNT_CODE_#currentrow#
					,REPLACE(REPLACE(ISNULL(ACC_CODE_#currentrow#.ACCOUNT_NAME,''), CHAR(13), ''), CHAR(9), '') AS ACCOUNT_NAME_#currentrow#
					,ISNULL(ACC_CODE_#currentrow#.ACC_TYPE_ID,'#acc_type_id#') AS ACC_TYPE_ID_#currentrow#
				</cfoutput>
			</cfif>
		FROM
			EMPLOYEES_IN_OUT EIO
			INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID=EIO.EMPLOYEE_ID
			LEFT JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.IS_MASTER = 1
			INNER JOIN DEPARTMENT D ON D.DEPARTMENT_ID=EIO.DEPARTMENT_ID
			INNER JOIN BRANCH B ON D.BRANCH_ID=B.BRANCH_ID
			LEFT JOIN EMPLOYEES_IN_OUT_PERIOD EIOP ON EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
			<cfif get_acc_type.recordcount>
				<cfoutput query="get_acc_type">
					LEFT JOIN (
						SELECT AP.ACCOUNT_CODE,AP.ACCOUNT_NAME,EA.IN_OUT_ID,EA.EMPLOYEE_ID,EA.ACC_TYPE_ID FROM <cfif fusebox.use_period>#dsn2_alias#.ACCOUNT_PLAN<cfelse>ACCOUNT_PLAN</cfif> AP INNER JOIN EMPLOYEES_ACCOUNTS EA ON AP.ACCOUNT_CODE = EA.ACCOUNT_CODE WHERE EA.PERIOD_ID = #session.ep.period_id# AND EA.ACC_TYPE_ID = #get_acc_type.acc_type_id#
					) AS ACC_CODE_#currentrow# ON ACC_CODE_#currentrow#.IN_OUT_ID = EIO.IN_OUT_ID AND ACC_CODE_#currentrow#.EMPLOYEE_ID = E.EMPLOYEE_ID
				</cfoutput>
			</cfif>
		WHERE
			(
				<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
					<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
					(
						(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
						EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						)
						OR
						(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
						EIO.FINISH_DATE IS NULL
						)
					)
					<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
					(
						(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
						EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						)
						OR
						(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
						EIO.FINISH_DATE IS NULL
						)
					)
					<cfelse>
					(
						(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
						EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						)
						OR
						(
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
						EIO.FINISH_DATE IS NULL
						)
						OR
						(
						EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
						EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						)
						OR
						(
						EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
						EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						)
					)
					</cfif>
				<cfelse>
					EIO.FINISH_DATE IS NULL
				</cfif>
			)
			AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			<cfif len(attributes.department)>
				AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
			</cfif>
		ORDER BY
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
	</cfquery>
<cfelse>
	<cfset get_position.recordcount=0>
</cfif>
<cfscript>
	attributes.totalrecords = get_position.recordcount;
	position_json = '';
	
	if (get_position.recordcount)
	{
		position_json = replace(serializeJson(get_position),'//','');
		position_array = deserializeJSON(position_json).data;
		colList = ArrayToList(deserializeJSON(position_json).COLUMNS);
		inoutid_idx = ListFind(colList, "IN_OUT_ID");
		empname_idx = ListFind(colList, "EMPLOYEE_NAME");
		empid_idx = ListFind(colList, "EMPLOYEE_ID");
		posname_idx = ListFind(colList, "POSITION_NAME");
		accbilltype_idx = ListFind(colList, "ACCOUNT_BILL_TYPE");
		expcenterid_idx = ListFind(colList, "EXPENSE_CENTER_ID");
		expcode_idx = ListFind(colList, "EXPENSE_CODE");
		expcodename_idx = ListFind(colList, "EXPENSE_CODE_NAME");
		expitemid_idx = ListFind(colList, "EXPENSE_ITEM_ID");
		expitemname_idx = ListFind(colList, "EXPENSE_ITEM_NAME");
		activityid_idx = ListFind(colList, "ACTIVITY_TYPE_ID");
		if (get_acc_type.recordcount)
		{
			for (i=1;i lte get_acc_type.recordcount; i++)
			{
				"acccode#i#_idx" = ListFind(colList, "ACCOUNT_CODE_#i#");
				"accname#i#_idx" = ListFind(colList, "ACCOUNT_NAME_#i#");
				"acctypeid#i#_idx" = ListFind(colList, "ACC_TYPE_ID_#i#");
			}
		}
	}
	else
	{
		empname_idx = '';
		posname_idx = '';
		accbilltype_idx = '';
		expcodename_idx = '';
		expitemname_idx = '';
		expcenterid_idx = '';
		expitemid_idx = '';
		expcode_idx = '';
		activityid_idx = '';
		if (get_acc_type.recordcount)
		{
			for (i=1;i lte get_acc_type.recordcount; i++)
			{
				"acccode#i#_idx" = '';
				"accname#i#_idx" = '';
				"acctypeid#i#_idx" = '';
			}
		}
	}
</cfscript>
<script type="text/javascript">
	<cfif isdefined("attributes.is_submit")>
		row_count=<cfoutput>#get_position.recordcount#</cfoutput>;
	<cfelse>
		row_count=0;
	</cfif>
</script>
<cfset getActivity = createobject("component","workdata.get_activity_types").getActivity()>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="add_period_search_form" action="#request.self#?fuseaction=ehesap.form_add_period_account_all" method="post">
			<input type="hidden" name="is_submit" id="is_submit" value="1">
			<cf_box_search>
				<div class="form-group">
					<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
						<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
						<cfoutput query="get_all_branches" group="nick_name">
							<optgroup label="#nick_name#"></optgroup>
							<cfoutput>
								<option value="#get_all_branches.branch_id#"<cfif attributes.branch_id eq get_all_branches.branch_id> selected</cfif>>#branch_name# <cfif not get_all_branches.branch_status>(Pasif)</cfif></option>
							</cfoutput>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" maxlength="3" onKeyUp="isNumber(this)" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="search_kontrol()" is_excel="0">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="DEPARTMENT_PLACE">
						<label class="col col-12"><cf_get_lang dictionary_id="57572.Departman"></label>
						<div class="col col-12">
							<select name="department" id="department">
								<option value=""><cf_get_lang dictionary_id="57572.Departman"></option>
								<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
									<cfoutput query="get_department">
										<option value="#department_id#"<cfif isdefined('attributes.department') and (attributes.department eq department_id)>selected</cfif>>#get_department.department_head#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-startdate">
						<label class="col col-12"><cf_get_lang dictionary_id="57742.Tarih"></label>
						<div class="col col-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
								<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
									<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#"  value="#dateformat(attributes.startdate,dateformat_style)#">
								<cfelse>
									<cfinput type="text" name="startdate" id="startdate" maxlength="10" validate="#validate_style#" message="#message#">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								<span class="input-group-addon no-bg"></span>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
								<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
									<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
								<cfelse>
									<cfinput type="text" name="finishdate" id="finishdate" maxlength="10" validate="#validate_style#" message="#message#">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Çalışan Muhasebe Tanımları | İK',54299)#" uidrop="1">
		<cf_grid_list id="tblBasket">
			<thead>
				<tr>
					<th width="35">No</th>
					<th><cf_get_lang dictionary_id ='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id ='58497.Pozisyon'></th>
					<th><cf_get_lang dictionary_id ='54117.Muhasebe Kod Grubu'></th>
					<th><cf_get_lang dictionary_id ='58460.Masraf Merkezi'></th>
					<th><cf_get_lang dictionary_id ='58551.Gider Kalemi'></th>
					<th><cf_get_lang dictionary_id ="49184.Aktivite tipi"></th>
					<cfif get_acc_type.recordcount>
						<cfoutput query="get_acc_type">
							<th>#acc_type_name#</th>
						</cfoutput>
					</cfif>
				</tr>
				<cfif get_position.recordcount>
					<tr>
						<th></th>
						<th></th>
						<th></th>
						<th>
							<select name="period_code_cat" id="period_code_cat" onchange="hepsi(row_count,'period_code_cat',<cfoutput>#accbilltype_idx#</cfoutput>);">
								<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
								<cfoutput query="get_code_cat">
									<option value="#payroll_id#">#definition#</option>
								</cfoutput>
							</select>
						</th>
						<input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_position.recordcount#</cfoutput>">
						<th nowrap>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" id="expense_center_id" name="expense_center_id" value="">
									<input type="hidden" id="expense_code" name="expense_code" value="">
									<input type="text" id="expense_code_name" name="expense_code_name" value="">
									<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&is_invoice=1&field_id=expense_center_id&field_code=expense_code&field_acc_code_name=expense_code_name&call_function=expense_code_doldur&call_function_parameter=#expcode_idx#,#expcodename_idx#,#expcenterid_idx#</cfoutput>');"></span>
									<a href="javascript://" onclick="if (confirm('<cf_get_lang dictionary_id="64657.Alanları boşaltmak istediğinizden emin misiniz? ">')) expense_code_bosalt(<cfoutput>#expcode_idx#,#expcodename_idx#,#expcenterid_idx#</cfoutput>); else return false;">
										<i title="<cf_get_lang dictionary_id='63620.Hepsini Boşalt'>" class="fa fa-minus"></i>
									</a>
								</div>
							</div>
						</th>
						<th nowrap>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" id="expense_item_id" name="expense_item_id" value="">
									<input type="text" id="expense_item_name" name="expense_item_name" value="">
									<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_exp_item&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&field_id=expense_item_id&field_acc_name=expense_item_name&function_name=expense_item_doldur&function_name_parameter=#expitemid_idx#,#expitemname_idx#'</cfoutput>);"></span>
									<a href="javascript://" onclick="if (confirm('<cf_get_lang dictionary_id="64657.Alanları boşaltmak istediğinizden emin misiniz? ">')) expense_item_bosalt(<cfoutput>#expitemid_idx#,#expitemname_idx#</cfoutput>); else return false;">
										<i title="<cf_get_lang dictionary_id='63620.Hepsini Boşalt'>" class="fa fa-minus"></i>
									</a>
								</div>
							</div>
						</th>
						<th>
							<select name="activity_id" id="activity_id" onchange="hepsi(row_count,'activity_id',<cfoutput>#activityid_idx#</cfoutput>);">
								<option value=""><cf_get_lang dictionary_id ="51319.Aktivite tipi"></option>
									<cfoutput  query="getActivity">
										<option value="#activity_id#">#activity_name#</option>
									</cfoutput> 
							</select>
						</th>
						<cfif get_acc_type.recordcount>
							<cfoutput query="get_acc_type">
								<th nowrap>
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="account_code_#get_acc_type.currentrow#_" id="account_code_#get_acc_type.currentrow#_" value="">
											<input type="text" name="account_name_#get_acc_type.currentrow#_" id="account_name_#get_acc_type.currentrow#_" value="">
											<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#&field_name=account_name_#get_acc_type.currentrow#_&field_id=account_code_#get_acc_type.currentrow#_&function_name=account_code_doldur(#get_acc_type.currentrow#,#evaluate('acccode#get_acc_type.currentrow#_idx')#,#evaluate('accname#get_acc_type.currentrow#_idx')#);','list')"></span>
											<a href="javascript://" onclick="if (confirm('<cf_get_lang dictionary_id="64657.Alanları boşaltmak istediğinizden emin misiniz? ">')) account_code_bosalt(#get_acc_type.currentrow#,#evaluate('acccode#get_acc_type.currentrow#_idx')#,#evaluate('accname#get_acc_type.currentrow#_idx')#); else return false;">
												<i title="<cf_get_lang dictionary_id='63620.Hepsini Boşalt'>" class="fa fa-minus"></i>
											</a>
										</div>
									</div>
								</th>
							</cfoutput>
						</cfif>
					</tr>
				<cfelse>
					<cfset colspan = 7+get_acc_type.recordcount>
					<tr><th colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.is_submit")><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></th></tr>
				</cfif>
			</thead>
			<cfoutput>
				<table id="basketItemBase" style="display:none; width:99%;">
					<tr ItemRow>
						<td><span id="rowNr"></span></td>
						<td><span id="empName"></span></td>
						<td><span id="posName"></span></td>
						<td >
							<div class="form-group">
								<select name="period_code_cat" id="period_code_cat">
									<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
									<cfloop query="get_code_cat">
										<option value="#payroll_id#">#definition#</option>
									</cfloop>
								</select>
							</div>
						</td>
						<td nowrap>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="expense_center_id" id="expense_center_id" value="">
									<input type="hidden" name="expense_code" id="expense_code" value="">
									<input type="text" id="expense_code_name" name="expense_code_name" value="">
									<span class="input-group-addon icon-ellipsis" href="javascript://" id="exp_code_img" name="exp_code_img"></span>
								</div>
							</div>
						</td>
						<td nowrap>
							<div class="form-group">
								<div class="input-group">
									<input type="hidden" name="expense_item_id" id="expense_item_id" value="">
									<input type="text" name="expense_item_name" id="expense_item_name" value="">
									<span class="input-group-addon icon-ellipsis" href="javascript://" id="exp_item_img" name="exp_item_img"></span>
								</div>
							</div>
						</td>
						<td>
							<div class="form-group">
								<select name="activity_id" id="activity_id">
									<option value=""><cf_get_lang dictionary_id ="51319.Aktivite tipi"></option>
										<cfloop  query="getActivity">
											<option value="#activity_id#">#activity_name#</option>
										</cfloop> 
								</select>
							</div>
						</td>
						<cfif get_acc_type.recordcount>
							<cfloop query="get_acc_type">
								<td nowrap="nowrap">
									<div class="form-group">
										<div class="input-group">
											<input type="hidden" name="acc_type_id_#currentrow#" id="acc_type_id_#currentrow#" value="">
											<input type="hidden" name="account_code_#currentrow#" id="account_code_#currentrow#" value="">
											<input type="text" name="account_name_#currentrow#" id="account_name_#currentrow#" value="">
											<span class="input-group-addon icon-ellipsis" href="javascript://" id="acc_code_img_#currentrow#_" name="acc_code_img_#currentrow#_"></span>
										</div>
									</div>
								</td>
							</cfloop>
						</cfif>
					</tr>
				</table>
			</cfoutput>
		</cf_grid_list>
		<cfif get_position.recordcount>
			<cf_box_footer>
				<div class="col col-6 col-xs-12">
					<input type="button" value="<cf_get_lang dictionary_id='57461.Kaydet'>" style="float:right;" onclick="send_json();">
					<input type="button" value="<cf_get_lang dictionary_id='57462.Vazgeç'>" style="float:right;" onclick="window.location = '<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.form_add_period_account_all';">
				</div>
			</cf_box_footer>
		</cfif>

		<cfset url_str="bank.list_assign_order">
		<cf_paging 
			name="add_period_search_form"
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#url_str#"
			is_form="1">
	</cf_box>
</div>
<script>
	$(document).ready(function(){
		$("#btnNext,#btnNextLast, #btnPrev, #btnPrevLast").bind("click", showBasketItems);
		jsonData = jQuery.parseJSON('<cfoutput>#position_json#</cfoutput>');
		if (jsonData)
		{
			jsonData.scrollIndex = 0;
			jsonData.pageSize = parseFloat('<cfoutput>#attributes.maxrows#</cfoutput>');
			showBasketItems();
		}
	});
	
	function send_json()
	{
		$.ajax({
			type:"post",
			url: "/V16/hr/ehesap/cfc/add_period_account_all.cfc?method=add_period",
			data: JSON.stringify(jsonData),
			cache:false,
			async: false,
			contentType: "application/json;charset=UTF-8",
			success: function(dataread) {
				if (dataread)
					location.reload();
			},
	        error: function(xhr, opt, err)
			{
				alert(err.toString());
			}
        });
	}
	
	function change_value(row,column,val)
	{
		jsonData.DATA[row][column-1] = val;
	}
	
	function change_cell(row,column,id,column2,id2,column3,id3)
	{
		change_value(row,column,$('#'+id+row).val());
		if (column2 > 0 && id2.length)
			change_value(row,column2,$('#'+id2+row).val());
		if (column3 > 0 && id3.length)
			change_value(row,column3,$('#'+id3+row).val());
	}
	
	function hepsi(satir,nesne,column,baslangic)
	{
		deger=$('#'+nesne);
		for(var i=jsonData.scrollIndex;i<Math.min(jsonData.DATA.length, jsonData.scrollIndex + jsonData.pageSize);i++)
		{
			nesne_=$('#'+nesne+i);
			nesne_.val(deger.val());
			jsonData.DATA[i][column-1] = deger.val();
		}
	}
	
	function expense_code_doldur(expcode_idx,expcodename_idx,expcenterid_idx)
	{
		if(document.getElementById('expense_center_id').value != "" && document.getElementById('expense_code').value != "" && document.getElementById('expense_code_name').value != "")
		{
			hepsi(row_count,'expense_code',expcode_idx);
			hepsi(row_count,'expense_code_name',expcodename_idx);
			hepsi(row_count,'expense_center_id',expcenterid_idx);
		}
	}
	
	function expense_code_bosalt(expcode_idx,expcodename_idx,expcenterid_idx)
	{
		document.getElementById('expense_center_id').value = '';
		document.getElementById('expense_code').value = '';
		document.getElementById('expense_code_name').value = '';
		hepsi(row_count,'expense_code',expcode_idx);
		hepsi(row_count,'expense_code_name',expcodename_idx);
		hepsi(row_count,'expense_center_id',expcenterid_idx);
	}
	
	function expense_item_doldur(expitemid_idx,expitemname_idx)
	{
		if(document.getElementById('expense_item_id').value != "" && document.getElementById('expense_item_name').value != "")
		{
			hepsi(row_count,'expense_item_id',expitemid_idx);
			hepsi(row_count,'expense_item_name',expitemname_idx);
		}
	}
	
	function expense_item_bosalt(expitemid_idx,expitemname_idx)
	{
		document.getElementById('expense_item_id').value = '';
		document.getElementById('expense_item_name').value = '';
		hepsi(row_count,'expense_item_id',expitemid_idx);
		hepsi(row_count,'expense_item_name',expitemname_idx);
	}
	
	function account_code_doldur(id_deger,accode_idx,accname_idx)
	{
		if($("#account_code_"+id_deger+"_").val() != "" && $("#account_name_"+id_deger+"_").val() != "")
		{
			deger1 = "account_code_"+id_deger+"_";
			hepsi(row_count,deger1,accode_idx);
			deger2 = "account_name_"+id_deger+"_";
			hepsi(row_count,deger2,accname_idx);
		}
	}
	
	function account_code_bosalt(id_deger,accode_idx,accname_idx)
	{
		$("#account_code_"+id_deger+"_").val('');
		$("#account_name_"+id_deger+"_").val('');
		deger1 = "account_code_"+id_deger+"_";
		hepsi(row_count,deger1,accode_idx);
		deger2 = "account_name_"+id_deger+"_";
		hepsi(row_count,deger2,accname_idx);
	}
	
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById("branch_id").value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,"<cf_get_lang dictionary_id='54322.İlişkili Departmanlar'>");
		}
	}
	
	function search_kontrol()
	{
		var branch_id = document.getElementById("branch_id").value;
		if(branch_id == "")
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57453.Şube'>");
			return false;
		}
		else{return true;}
	}
	
	//position_array - jsonData
	function showBasketItems(e)
	{
		if (e != null && $(e.target).attr("id") == "btnNext") jsonData.scrollIndex = Math.min(jsonData.DATA.length - jsonData.pageSize, jsonData.scrollIndex + jsonData.pageSize);
		if (e != null && $(e.target).attr("id") == "btnNextLast") jsonData.scrollIndex = jsonData.DATA.length - jsonData.pageSize;
        if (e != null && $(e.target).attr("id") == "btnPrev") jsonData.scrollIndex = Math.max(0, jsonData.scrollIndex - jsonData.pageSize);
        if (e != null && $(e.target).attr("id") == "btnPrevLast") jsonData.scrollIndex = 0;
        if (e != null && ($(e.target).attr("id") == "btnNext" || $(e.target).attr("id") == "btnPrev" || $(e.target).attr("id") == "btnPrevLast" || $(e.target).attr("id") == "btnNextLast"))
        {
        	$('#period_code_cat').val('');
        	$('#expense_center_id').val('');
        	$('#expense_code').val('');
        	$('#expense_code_name').val('');
        	$('#expense_item_id').val('');
			$('#expense_item_name').val('');
			$('#activity_id').val('');
        	<cfif get_acc_type.recordcount>
	        	<cfloop query="get_acc_type">
	        		$('#account_code_<cfoutput>#get_acc_type.currentrow#</cfoutput>_').val('');
	        		$('#account_name_<cfoutput>#get_acc_type.currentrow#</cfoutput>_').val('');
	        	</cfloop>
	        </cfif>
        }
        
        if((jsonData.scrollIndex+jsonData.pageSize) >= jsonData.DATA.length)
        {
			$("#btnNext").attr('disabled', 'disabled');
			$("#btnNextLast").attr('disabled', 'disabled');
		}
		else
		{
			$("#btnNext").removeAttr("disabled");
			$("#btnNextLast").removeAttr("disabled");
		}
			
		if(jsonData.scrollIndex == 0)
		{
			$("#btnPrev").attr('disabled', 'disabled');
			$("#btnPrevLast").attr('disabled', 'disabled');
		}
		else
		{
			$("#btnPrev").removeAttr("disabled");
			$("#btnPrevLast").removeAttr("disabled");
		}
        
        $("#tblBasket tr[ItemRow]").remove();
        
		if (jsonData.DATA.length)
		{
			for (var i = jsonData.scrollIndex; i < Math.min(jsonData.DATA.length, jsonData.scrollIndex + jsonData.pageSize); i++)
			{
				$("#tblBasket").append($("#basketItemBase").html());
				var item = $("#tblBasket tr[ItemRow]").last();
				var data = jsonData.DATA[i];
				$(item).attr("itemIndex", i);
				$(item).find("#expense_code_name").attr('id','expense_code_name'+i);
				$(item).find("#expense_code_name"+i).attr('name','expense_code_name'+i);
				$(item).find("#expense_code").attr('id','expense_code'+i);
				$(item).find("#expense_code"+i).attr('name','expense_code'+i);
				$(item).find("#expense_center_id").attr('id','expense_center_id'+i);
				$(item).find("#expense_center_id"+i).attr('name','expense_center_id'+i);
				$(item).find("#exp_code_img").attr('id','exp_code_img'+i);
				$(item).find("#exp_code_img"+i).attr('name','exp_code_img'+i);
				$(item).find("#expense_item_id").attr('id','expense_item_id'+i);
				$(item).find("#expense_item_id"+i).attr('name','expense_item_id'+i);
				$(item).find("#exp_item_img").attr('id','exp_item_img'+i);
				$(item).find("#exp_item_img"+i).attr('name','exp_item_img'+i);
				$(item).find("#expense_item_name").attr('id','expense_item_name'+i);
				$(item).find("#expense_item_name"+i).attr('name','expense_item_name'+i);
				$(item).find("#activity_id").attr('id','activity_id'+i);
				$(item).find("#activity_id"+i).attr('name','activity_id'+i);
				$(item).find("#activity_id"+i).attr('onchange','change_value('+i+',<cfoutput>#activityid_idx#</cfoutput>,this.value)');
				$(item).find("#period_code_cat").attr('id','period_code_cat'+i);
				$(item).find("#period_code_cat"+i).attr('name','period_code_cat'+i);
				$(item).find("#period_code_cat"+i).attr('onchange','change_value('+i+',<cfoutput>#accbilltype_idx#</cfoutput>,this.value)');
				$(item).find("#rowNr").text(i + 1);
				$(item).find("#empName").text(jsonData.DATA[i][<cfoutput>#empname_idx#</cfoutput>- 1]);
				$(item).find("#posName").text(jsonData.DATA[i][<cfoutput>#posname_idx#</cfoutput>- 1]);
				$(item).find("#period_code_cat"+i).val(jsonData.DATA[i][<cfoutput>#accbilltype_idx#</cfoutput>- 1]);
				$(item).find("#activity_id"+i).val(jsonData.DATA[i][<cfoutput>#activityid_idx#</cfoutput>- 1]);
				$(item).find("#expense_code_name"+i).val(jsonData.DATA[i][<cfoutput>#expcodename_idx#</cfoutput>- 1]);
				$(item).find("#expense_center_id"+i).val(jsonData.DATA[i][<cfoutput>#expcenterid_idx#</cfoutput>- 1]);
				$(item).find("#expense_item_id"+i).val(jsonData.DATA[i][<cfoutput>#expitemid_idx#</cfoutput>- 1]);
				$(item).find("#expense_code"+i).val(jsonData.DATA[i][<cfoutput>#expcode_idx#</cfoutput>- 1]);
				$(item).find("#expense_item_name"+i).val(jsonData.DATA[i][<cfoutput>#expitemname_idx#</cfoutput>- 1]);
				$(item).find("#exp_code_img"+i).attr('onclick',"openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#</cfoutput>&is_invoice=1&field_id=expense_center_id"+i+"&field_code=expense_code"+i+"&field_acc_code_name=expense_code_name"+i+"&call_function=change_cell&call_function_parameter="+i+",<cfoutput>#expcodename_idx#</cfoutput>,\\'expense_code_name\\',<cfoutput>#expcode_idx#</cfoutput>,\\'expense_code\\',<cfoutput>#expcenterid_idx#</cfoutput>,\\'expense_center_id\\'');");
				$(item).find("#exp_item_img"+i).attr('onclick',"openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_exp_item&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#</cfoutput>&field_id=expense_item_id"+i+"&field_acc_name=expense_item_name"+i+"&function_name=change_cell&function_name_parameter="+i+",<cfoutput>#expitemname_idx#</cfoutput>,\\'expense_item_name\\',<cfoutput>#expitemid_idx#</cfoutput>,\\'expense_item_id\\'');");
				<cfloop query="get_acc_type">
					$(item).find("#account_name_<cfoutput>#currentrow#</cfoutput>").attr('id','account_name_<cfoutput>#currentrow#</cfoutput>_'+i);
					$(item).find("#account_name_<cfoutput>#currentrow#</cfoutput>_"+i).attr('name','account_name_<cfoutput>#currentrow#</cfoutput>_'+i);
					$(item).find("#account_name_<cfoutput>#currentrow#</cfoutput>_"+i).val(jsonData.DATA[i][<cfoutput>#Evaluate('accname#currentrow#_idx')#</cfoutput> - 1]);
					$(item).find("#acc_type_id_<cfoutput>#currentrow#</cfoutput>").attr('id','acc_type_id_<cfoutput>#currentrow#</cfoutput>_'+i);
					$(item).find("#acc_type_id_<cfoutput>#currentrow#</cfoutput>_"+i).attr('name','acc_type_id_<cfoutput>#currentrow#</cfoutput>_'+i);
					$(item).find("#acc_type_id_<cfoutput>#currentrow#</cfoutput>_"+i).val(jsonData.DATA[i][<cfoutput>#Evaluate('acctypeid#currentrow#_idx')#</cfoutput> - 1]);
					$(item).find("#account_code_<cfoutput>#currentrow#</cfoutput>").attr('id','account_code_<cfoutput>#currentrow#</cfoutput>_'+i);
					$(item).find("#account_code_<cfoutput>#currentrow#</cfoutput>_"+i).attr('name','account_code_<cfoutput>#currentrow#</cfoutput>_'+i);
					$(item).find("#account_code_<cfoutput>#currentrow#</cfoutput>_"+i).val(jsonData.DATA[i][<cfoutput>#Evaluate('acccode#currentrow#_idx')#</cfoutput> - 1]);
					$(item).find("#acc_code_img_<cfoutput>#currentrow#</cfoutput>_").attr('id','acc_code_img_<cfoutput>#currentrow#</cfoutput>_'+i);
					$(item).find("#acc_code_img_<cfoutput>#currentrow#</cfoutput>_"+i).attr('name','acc_code_img_<cfoutput>#currentrow#</cfoutput>_'+i);
					$(item).find("#acc_code_img_<cfoutput>#currentrow#</cfoutput>_"+i).attr('onclick',"windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&#listfirst(session.dark_mode,":").trim()#=#listlast(session.dark_mode,":").trim()#</cfoutput>&field_name=account_name_<cfoutput>#currentrow#</cfoutput>_"+i+"&field_id=account_code_<cfoutput>#currentrow#</cfoutput>_"+i+"&function_name=change_cell("+i+",<cfoutput>#Evaluate('accname#currentrow#_idx')#</cfoutput>,\\'account_name_<cfoutput>#currentrow#</cfoutput>_\\',<cfoutput>#Evaluate('acccode#currentrow#_idx')#</cfoutput>,\\'account_code_<cfoutput>#currentrow#</cfoutput>_\\',<cfoutput>#Evaluate('acctypeid#currentrow#_idx')#</cfoutput>,\\'acc_type_id_<cfoutput>#currentrow#</cfoutput>_\\');','list');");
				</cfloop>	
			}
		}
		
		$("#itemCount").text(jsonData.DATA.length);
		
		if (jsonData.DATA.length > jsonData.pageSize)
		{
			$("#btnNext, #btnPrev, #btnNextLast, #btnPrevLast").show();
		} else {
			$("#btnNext, #btnPrev, #btnNextLast, #btnPrevLast").hide();
		}
	}
</script>
