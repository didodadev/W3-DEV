<cf_get_lang_set module_name="ehesap">
<cf_xml_page_edit fuseact="ehesap.list_payments">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfset periods = createObject('component','V16.objects.cfc.periods')>

<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'ehesap.list_payments')>
<cfset get_payments_paper = createObject("component","V16.hr.ehesap.cfc.get_payments")>

<cfset period_years = periods.get_period_year()>
<cfparam name="attributes.start_mon" default="#month(now())#"> 
<cfparam name="attributes.end_mon" default="#month(now())#">
<cfparam name="attributes.yil" default="#year(now())#">
<cfparam name="attributes.odkes" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.tax" default="">
<cfparam name="attributes.ssk" default="">
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.inout_statue" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.type" default="1">
<cfparam name="attributes.filter_process" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isdefined("attributes.action_list_id")>
	<cfset attributes.form_submit = 1>
</cfif>
<cfset url_str = "">
<cfset toplam_tutar=0>
<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
<cfsavecontent variable = "title">
	<cf_get_lang dictionary_id = "53399.Ek ödenekler">
</cfsavecontent>
<cfif isdefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)>
	<cfset url_str = "#url_str#&BRANCH_ID=#attributes.BRANCH_ID#">
</cfif>
<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
	<cfset url_str = "#url_str#&hierarchy=#attributes.hierarchy#">
</cfif>
<cfif len(attributes.ODKES)>
	<cfset url_str = "#url_str#&ODKES=#attributes.ODKES#">
</cfif>
<cfif len(attributes.yil)>
	<cfset url_str = "#url_str#&yil=#attributes.yil#">
</cfif>
<cfif len(attributes.start_mon)>
	<cfset url_str = "#url_str#&start_mon=#attributes.start_mon#">
</cfif>
<cfif len(attributes.end_mon)>
	<cfset url_str = "#url_str#&end_mon=#attributes.end_mon#">
</cfif>
<cfif len(attributes.ssk)>
	<cfset url_str = "#url_str#&ssk=#attributes.ssk#">
</cfif>
<cfif len(attributes.tax)>
	<cfset url_str = "#url_str#&tax=#attributes.tax#">
</cfif>
<cfif len(attributes.collar_type)>
	<cfset url_str = "#url_str#&collar_type=#attributes.collar_type#">
</cfif>
<cfif len(attributes.position_cat_id)>
	<cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
</cfif>
<cfif len(attributes.title_id)>
	<cfset url_str = "#url_str#&title_id=#attributes.title_id#">
</cfif>
<cfif isdefined('attributes.form_submit')>
	<cfset url_str = "#url_str#&form_submit=#attributes.form_submit#">
</cfif>
<cfif isdefined("attributes.department_id")>
	<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
</cfif>
<cfif isdefined("attributes.related_company")>
	<cfset url_str="#url_str#&related_company=#attributes.related_company#">
</cfif>
<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.EXPENSE_CODE_NAME") and len(attributes.EXPENSE_CODE_NAME)>
	<cfset url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#&EXPENSE_CODE_NAME=#attributes.EXPENSE_CODE_NAME#">
</cfif>
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cfset url_str="#url_str#&startdate=#dateformat(attributes.startdate)#">
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cfset url_str="#url_str#&finishdate=#dateformat(attributes.finishdate)#">
</cfif>
<cfif isdefined("attributes.inout_statue") and len(attributes.inout_statue)>
	<cfset url_str="#url_str#&inout_statue=#attributes.inout_statue#">
</cfif>
<cfif len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<!--- Pozisyon ekleme sayfasının xml ine göre pozisyon alanını kapatıyoruz --->
<cfquery name="get_position_list_xml" datasource="#dsn#">
	SELECT 
		PROPERTY_VALUE,
		PROPERTY_NAME
	FROM
		FUSEACTION_PROPERTY
	WHERE
		OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="hr.form_add_position"> AND
		PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="x_add_position_name">
</cfquery>
<!--- Kayıt Silme --->
<cfif (get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1) or get_position_list_xml.recordcount eq 0><cfset show_position = 1><cfelse><cfset show_position = 0></cfif>
<cfif isdefined("attributes.del_submit") and len(attributes.del_submit) and attributes.del_submit eq 1>
	<cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0>
		<cfset del_payment = get_payments_paper.DELETE_SALARYPARAM_PAY(action_list_id: attributes.action_list_id)>
	</cfif>
</cfif>
<cfif isdefined('attributes.form_submit')>
	<cfif attributes.type eq 1>
		<cfinclude template="../query/get_payments.cfm">
	<cfelse>
		<cfset get_payments = get_payments_paper.GET_BONUS_PAYROLL(start_mon : attributes.start_mon,end_mon : attributes.end_mon,keyword : attributes.keyword)>
	</cfif>
<cfelse>
	<cfset get_payments.recordcount = 0>
</cfif>
<cfinclude template="../query/get_ssk_offices.cfm">
<cfquery name="get_related_branches" datasource="#DSN#">
	SELECT DISTINCT
		RELATED_COMPANY
	FROM 
		BRANCH
	WHERE 
		BRANCH_ID IS NOT NULL AND
		RELATED_COMPANY IS NOT NULL
	<cfif not session.ep.ehesap>
		AND
		BRANCH_ID IN (
						SELECT
							BRANCH_ID
						FROM
							EMPLOYEE_POSITION_BRANCHES
						WHERE
							POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
					)
	</cfif>
	ORDER BY
		RELATED_COMPANY
</cfquery>
<cfquery name="get_odeneks" datasource="#dsn#">
	SELECT 
		SO.ODKES_ID,
		#dsn#.Get_Dynamic_Language(SO.ODKES_ID,'#session.ep.language#','SETUP_PAYMENT_INTERRUPTION','COMMENT_PAY',NULL,NULL,SO.COMMENT_PAY) AS COMMENT_PAY
	FROM 
		SETUP_PAYMENT_INTERRUPTION SO
	WHERE
		SO.IS_ODENEK = 1 AND
		SO.STATUS = 1
</cfquery>
<cfquery name="GET_POSITION_CATS_" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT
</cfquery>
<cfquery name="get_title" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfif isdefined("attributes.paper_submit") and len(attributes.paper_submit) and attributes.paper_submit eq 1>
	<cfif isDefined("attributes.action_list_id") and Listlen(attributes.action_list_id) gt 0>
		<cfset totalValues = structNew()>
		<cfset totalValues = {
				total_offtime : 0
			}>
		<cfif IsDefined('attributes.comp_id') and len(attributes.comp_id)>
			<cfset url_str="#url_str#&comp_id=#attributes.comp_id#">
		</cfif>
		<cfset action_list_id = replace(attributes.action_list_id,";",",","all")>
		<cf_workcube_general_process
			mode = "query"
			general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
			general_paper_no = "#attributes.general_paper_no#"
			general_paper_date = "#attributes.general_paper_date#"
			action_list_id = "#action_list_id#"
			process_stage = "#attributes.process_stage#"
			general_paper_notice = "#attributes.general_paper_notice#"
			responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
			responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
			action_table = 'SALARYPARAM_PAY'
			action_column = 'SPP_ID'
			action_page = '#request.self#?fuseaction=ehesap.list_payments'
			total_values = '#totalValues#'
		>
		<cfset attributes.approve_submit = 0>
	</cfif>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
<cfform action="#request.self#?fuseaction=#listfirst(attributes.fuseaction,'.')#.list_payments" name="myform" method="post">
	<input type="hidden" name="form_submit" id="form_submit" value="1">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="53605.Ödenekler"></cfsavecontent>
	<cf_box_search>
		<div class="form-group">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
			<cfinput name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#message#">
		</div>
		<div class="form-group">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57761.Hiyerarşi'></cfsavecontent>
			<cfinput name="hierarchy" id="hierarchy" value="#attributes.hierarchy#" maxlength="50" placeholder="#message#">
		</div>
		<div class="form-group">
			<select name="start_mon" id="start_mon" onchange="change_mon(this.value);">
				<cfloop from="1" to="12" index="i">
					<cfset ay_bu=ListGetAt(ay_list(),i)>
					<cfoutput><option value="#i#" <cfif attributes.start_mon eq i>selected</cfif>>#ay_bu#</option></cfoutput>
				</cfloop>
			</select>
		</div>
		<div class="form-group">
			<select name="end_mon" id="end_mon">
				<cfloop from="1" to="12" index="i">
					<cfset ay_bu=ListGetAt(ay_list(),i)>
					<cfoutput><option value="#i#" <cfif attributes.end_mon eq i>selected</cfif>>#ay_bu#</option></cfoutput>
				</cfloop>
			</select>
		</div>
		<div class="form-group">
			<select name="yil" id="yil">
				<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
				<cfoutput>
					<option value="#i#"<cfif attributes.yil eq i> selected</cfif>>#i#</option>
				</cfoutput>
				</cfloop>
			</select>
		</div>
		<div class="form-group">
			<select name="type" id="type">
				<option value="1"<cfif attributes.type eq 1> selected</cfif>><cf_get_lang dictionary_id = "29539.Satır Bazında"></option>
				<option value="2"<cfif attributes.type eq 2> selected</cfif>><cf_get_lang dictionary_id = "57660.Belge Bazında"></option>
			</select>
		</div>
		<div class="form-group small">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
		</div>
		<div class="form-group">
			<cf_wrk_search_button button_type="4">
		</div>
		<!--- <div class="form-group">
			<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
		</div> --->
	</cf_box_search>
	<cf_box_search_detail>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-inout_statue">
				<label><cf_get_lang dictionary_id="53208.Giriş ve Çıkışlar"></label>
				<select name="inout_statue" id="inout_statue">
					<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
					<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
					<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id="39083.Aktif Çalışanlar"></option>
				</select>
			</div>
			<div class="form-group" id="item-startdate">
				<label><cf_get_lang dictionary_id="47800.Başlangıç - Bitiş"></label>
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
					<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					<span class="input-group-addon no-bg"></span>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
					<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
				</div>
			</div>
			<div class="form-group" id="item-ssk">
				<label><cf_get_lang dictionary_id="53606.SGK Durumu"></label>
				<select name="ssk" id="ssk" style="width:90px;">
					<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					<option value="1"<cfif attributes.ssk eq 1> selected</cfif>><cf_get_lang dictionary_id='53285.SSK Muaf'></option>
					<option value="2"<cfif attributes.ssk eq 2> selected</cfif>><cf_get_lang dictionary_id='53286.SSK Muaf Değil'></option>			
				</select>
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group" id="item-tax">
				<label><cf_get_lang dictionary_id="53607.Vergi Durumu"></label>
				<select name="tax" id="tax" style="width:90px;">
					<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					<option value="1"<cfif  attributes.tax eq 1> selected</cfif>> <cf_get_lang dictionary_id='53287.Vergi Muaf'></option>
					<option value="2"<cfif  attributes.tax eq 2> selected</cfif>><cf_get_lang dictionary_id='53288.Vergi Muaf Değil'></option>
				</select>
			</div>
			<div class="form-group" id="item-">
				<label><cf_get_lang dictionary_id="53701.İlgili Şirket"></label>
				<select name="related_company" id="related_company">
					<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					<cfoutput query="get_related_branches">
							<option value="#related_company#" <cfif isdefined("attributes.related_company") and attributes.related_company is '#related_company#'>selected</cfif>>#related_company#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group" id="item-ODKES">
			<label><cf_get_lang dictionary_id="53290.Ödenek Türü"></label>
			<cf_multiselect_check 
				query_name="get_odeneks"  
				name="ODKES"
				width="135" 
				option_value="ODKES_ID"
				option_name="COMMENT_PAY"
				value="#attributes.ODKES#"
				option_text="#getlang('main',322)#"><!--- 322.seçiniz ---> 
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
			<div class="form-group" id="item-branch_id">
				<label><cf_get_lang dictionary_id="57453.Şube"></label>
				<select name="BRANCH_ID" id="branch_id" onChange="showDepartment(this.value)">
					<option value="all"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					<cfoutput query="GET_SSK_OFFICES">
						<cfif len(SSK_OFFICE) and len(SSK_NO)>
						<option value="#BRANCH_ID#"<cfif isdefined("attributes.BRANCH_ID") and (attributes.BRANCH_ID is BRANCH_ID)> selected</cfif>>#BRANCH_NAME#</option>
						</cfif>
					</cfoutput>
				</select>
			</div>
			<div class="form-group" id="DEPARTMENT_PLACE">
				<label><cf_get_lang dictionary_id="57572.Departman"></label>
				<select name="department_id" id="department_id">
					<option value="0"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
						<cfquery name="get_departmant" datasource="#dsn#">
							SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND IS_STORE <> 1 ORDER BY DEPARTMENT_HEAD
						</cfquery>
						<cfoutput query="get_departmant">
							<option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department_id') and (attributes.department_id eq get_departmant.DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
						</cfoutput>
					</cfif>
				</select>
			</div>
			<div class="form-group" id="item-off_validate">
				<label><cf_get_lang dictionary_id='53042.Onay Durumu'></label>
				<cf_workcube_process is_upd='0' select_value="#attributes.filter_process#" process_cat_width='188' is_detail='0' select_name="filter_process" is_select_text="1">
			</div>
			<cfif is_expense_center eq 1>
				<div class="form-group" id="item-EXPENSE_CODE_NAME">
					<label><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
					<div class="input-group">
						<input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.EXPENSE_CODE_NAME") and len(attributes.EXPENSE_CODE_NAME)><cfoutput>#attributes.expense_center_id#</cfoutput></cfif>">
						<input type="Text" name="EXPENSE_CODE_NAME" id="EXPENSE_CODE_NAME" value="<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.EXPENSE_CODE_NAME") and len(attributes.EXPENSE_CODE_NAME)><cfoutput>#attributes.EXPENSE_CODE_NAME#</cfoutput></cfif>">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=myform.expense_center_id&field_acc_code_name=myform.EXPENSE_CODE_NAME</cfoutput>','list');"></span>
					</div>
				</div>
			</cfif>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
			<div class="form-group" id="item-collar_type">
				<label><cf_get_lang dictionary_id="54054.Yaka Tipi"></label>
				<select name="collar_type" id="collar_type">
					<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					<option value="1"<cfif attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='54055.Mavi Yaka'></option> 
					<option value="2"<cfif attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='54056.Beyaz Yaka'></option>
				</select>
			</div>
			<div class="form-group" id="item-position_cat_id">
				<label><cf_get_lang dictionary_id="57779.Pozisyon Tipleri"></label>
				<select name="position_cat_id" id="position_cat_id">
					<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					<cfoutput query="GET_POSITION_CATS_">
						<option value="#POSITION_CAT_ID#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#POSITION_CAT#
					</cfoutput>
				</select>
			</div>
		</div>
	</cf_box_search_detail>
</cfform> 
</cf_box>
</div>
<cfform name="setProcessForm" id="setProcessForm" method="post" action="">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box id="list_worknet_list" closable="0" collapsable="1" title="#title#" add_href="#request.self#?fuseaction=ehesap.list_payments&event=add" hide_table_column="1" uidrop="1">
		<cf_grid_list>
			<cfif attributes.type eq 1>
				<thead>
					<tr> 
						<th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
						<th width="60"><cf_get_lang dictionary_id="54265.TC No"></th>
						<th width="100"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<th><cf_get_lang dictionary_id='57453.Şube'></th>
						<th><cf_get_lang dictionary_id='57572.Departman'></th>
						<th width="125"><cf_get_lang dictionary_id='59004.Pozisyon tipi'></th>
						<cfif show_position eq 1>
							<th width="125"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
						</cfif>
						<th width="125"><cf_get_lang dictionary_id='54054.Yaka tipi'></th>
						<cfif is_in_date eq 1>
							<th width="125"><cf_get_lang dictionary_id='53348.İşe Giriş Tarihi'></th>
						</cfif>
						<cfif is_out_date eq 1>
							<th width="125"><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></th>
						</cfif>
						<cfif is_expense_center eq 1>
							<th width="125"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
						</cfif>
						<th width="80" nowrap="nowrap"><cf_get_lang dictionary_id='53290.Ödenek Türü'></th>
						<th><cf_get_lang dictionary_id="53132.başlangıç ay"></th>
						<th style="width:50px;"><cf_get_lang dictionary_id="53133.bitiş ay"></th>
						<th width="50"><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
						<cfif len(attributes.filter_process)>
							<th width="20"><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0"/></th>
						</cfif>
						<!-- sil --><th class="header_icn_none" width="20"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_payments&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
					</tr>
				</thead>
				<cfparam name="attributes.totalrecords" default="#get_payments.recordcount#">
				<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
				<cfif get_payments.recordcount>
					<tbody>
						<cfset in_out_id_list = "">
						<cfset expence_center_id_list = "">
						<cfoutput query="get_payments" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif len(in_out_id) and not listfind(in_out_id_list,in_out_id)>
								<cfset in_out_id_list=listappend(in_out_id_list,in_out_id)>
							</cfif>
							<cfif len(EXPENSE_CENTER_ID) and not listfind(expence_center_id_list,EXPENSE_CENTER_ID)>
								<cfset expence_center_id_list=listappend(expence_center_id_list,EXPENSE_CENTER_ID)>
							</cfif>
						</cfoutput>
						<cfif is_expense_center eq 1>
						<cfif len(expence_center_id_list)>
							<cfset expence_center_id_list=listsort(expence_center_id_list,"numeric","ASC",",")>
							<cfquery name="get_expense_center" datasource="#dsn2#">
								SELECT EXPENSE_CODE, EXPENSE_ID,EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#PreserveSingleQuotes(expence_center_id_list)#) ORDER BY EXPENSE_ID
							</cfquery>
							<cfset expence_center_id_list = listsort(listdeleteduplicates(valuelist(get_expense_center.EXPENSE_ID,',')),'numeric','ASC',',')>
						</cfif>
						</cfif>
						<cfoutput query="get_payments" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
							<tr>
								<td>#currentrow#</td>
								<td>#TC_IDENTY_NO#</td>
								<td><a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&employee_id=#employee_id#&in_out_id=#in_out_id#&empName=#UrlEncodedFormat('#EMPLOYEE#')#" class="tableyazi">#employee_name# #employee_surname#</a></td>
								<td>#branch_name#</td>
								<td>#department_head#</td>
								<td>#position_cat#</td>
								<cfif show_position eq 1>
									<td>#position_name#</td>
								</cfif>
								<td><cfif collar_type eq 1><cf_get_lang dictionary_id='54055.Mavi Yaka'><cfelseif collar_type eq 2><cf_get_lang dictionary_id='54056.Beyaz Yaka'></cfif></td>
								<cfif is_in_date eq 1>
									<td>#dateformat(start_date,dateformat_style)#</td>
								</cfif>
								<cfif is_out_date eq 1>
									<td>#dateformat(finish_date,dateformat_style)#</td>
								</cfif>
								<cfif is_expense_center eq 1>
								<td><cfif len(EXPENSE_CENTER_ID)>#get_expense_center.EXPENSE[listfind(expence_center_id_list,EXPENSE_CENTER_ID,',')]#</cfif></td>
								</cfif>
								<td>#COMMENT_PAY#</td>
								<td>#listgetat(ay_list(),START_SAL_MON)#</td>
								<td>#listgetat(ay_list(),END_SAL_MON)#</td>
								<td style="text-align:right;" nowrap="nowrap"><cfif listfindnocase('2,3,4',METHOD_PAY)>%</cfif><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(AMOUNT_PAY,2)#"></td>
								<cfset toplam_tutar=toplam_tutar+AMOUNT_PAY>
								<td>
									<cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#">
								</td>
								<!-- sil -->
								<cfif len(attributes.filter_process)>
									<td>
										<input class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#spp_id#"/>
									</td>
								</cfif>
								<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_payments&event=upd&id=#spp_id#&is_payment=1','','ui-draggable-box-medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id="57464.Güncelle">"></i></a></td>
								<!-- sil -->
							</tr>
						</cfoutput>
					</tbody>
					<cfset cols = 8>
					<cfif is_expense_center eq 1><cfset cols = cols+1></cfif>
					<cfif is_in_date eq 1><cfset cols = cols+1></cfif>
					<cfif is_out_date eq 1><cfset cols = cols+1></cfif>
					<cfif show_position eq 1><cfset cols = cols+1></cfif>
					<tfoot>
					<tr style="background-color:#f9f9f9">
						<td colspan="3" class="formbold"><cf_get_lang dictionary_id ='57492.Toplam'>:</td>
						<td colspan="<cfoutput>#cols#</cfoutput>" style="text-align:right;"><cfoutput><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(toplam_tutar,2)#"></cfoutput></td>
						<!-- sil --><td></td><!-- sil -->
					</tr>
					</tfoot>
				<cfelse>	
					<tr> 
						<td colspan="16"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			<cfelse>
				<!--- Belge bazında listeleme yapıldığında 20200116ERU --->
				<thead>
					<tr> 
						<th width="35"><cf_get_lang dictionary_id="58577.Sıra"></th>
						<th width="60">Belge No</th>
						<th>Düzenleyen</th>
						<th>Belge Tarihi</th>
						<th>Süreç</th>
						<!-- sil --><th><i class="fa fa-pencil"/></th><!-- sil -->
					</tr>
				</thead>
				<cfparam name="attributes.totalrecords" default="#get_payments.recordcount#">
				<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
				<cfif get_payments.recordcount>
					<tbody>
						<cfoutput query="get_payments" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
							<tr>
								<td>#currentrow#</td>
								<td>#paper_no#</td>
								<td>#get_emp_info(employee_id,0,0)#</td>
								<td>#dateformat(paper_date,dateformat_style)#</td>
								<td><cf_workcube_process type="color-status" process_stage="#process_id#"></td>
								<td><a href="#request.self#?fuseaction=ehesap.list_payments&event=bonus&bonus_id=#bonus_id#" target="_blank"><i class="fa fa-pencil"/></a></td>
							</tr>
						</cfoutput>
					</tbody>
				<cfelse>
					<tr> 
						<td colspan="6"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</cfif>
			</cfif>
		</cf_grid_list>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="ehesap.list_payments&#url_str#">
		<cfif isdefined("attributes.form_submit") and len(attributes.form_submit) and len(attributes.filter_process)>
			<cf_box id="list_checked" closable="0" title="#getLang('','',46186)#">
				<cf_box_elements vertical="1">
					<div class="col col-4 col-xs-12" type="column" index="1" sort="true">
						<cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
						faction_list : 'ehesap.list_payments',
						filter_stage: '#attributes.filter_process#')>
						<cf_workcube_general_process print_type="145" select_value = '#get_process_f.process_row_id#'>						
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<input type="hidden" id="paper_submit" name="paper_submit" value="0">
					<cfsavecontent  variable="ext_button">
						<cf_get_lang dictionary_id='64173.Seçili Kayıtları Sil'>
					</cfsavecontent>
					<input type="hidden" id="del_submit" name="del_submit" value="0">
					<cf_workcube_buttons extraButton = "1" update_status="0" extraFunction="del_payments()" extraButtonText="#ext_button#" extraButtonClass="ui-wrk-btn ui-wrk-btn-red">
					<div>
						<input type="submit" class="pull-right" name="setOfftimeProcess" id="setOfftimeProcess" onclick="if(confirm('<cf_get_lang dictionary_id='57535.Kaydetmek istediğinize emin misiniz'>')) return setofftimesProcess(); else return false;" value="<cf_get_lang dictionary_id='57461.Kaydet'>" >
					</div>
				</cf_box_footer>
			</cf_box>
		</cfif>
	</cf_box>
	</div>
</cfform>
<script type="text/javascript">

document.getElementById('keyword').focus();
	$(function(){
		$('input[name=checkAll]').click(function(){
			if(this.checked){
				$('.checkControl').each(function(){
					$(this).prop("checked", true);
				});
			}
			else{
				$('.checkControl').each(function(){
					$(this).prop("checked", false);
				});
			}
		});
	});
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
	}
	function change_mon(i)
	{
		$('#end_mon').val(i);
	}
	function setofftimesProcess(){
		var controlChc = 0;
		$('.checkControl').each(function(){
			if(this.checked){
				controlChc += 1;
			}
		});
		if(controlChc == 0){
			alert("<cf_get_lang dictionary_id='53612.Please select additional allowance'>");
			return false;
		}
		if( $.trim($('#general_paper_no').val()) == '' ){
			alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'>");
			return false;
		}else{
			paper_no_control = wrk_safe_query('general_paper_control','dsn',0,$('#general_paper_no').val());
			if(paper_no_control.recordcount > 0)
			{
				alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'>.<cf_get_lang dictionary_id='59367.Otomatik olarak değişecektir'>.");
				paper_no_val = $('#general_paper_no').val();
				paper_no_split = paper_no_val.split("-");
				if(paper_no_split.length == 1)
					paper_no = paper_no_split[0];
				else
					paper_no = paper_no_split[1];
				paper_no = parseInt(paper_no);
				paper_no++;
				if(paper_no_split.length == 1)
					$('#general_paper_no').val(paper_no);
				else
					$('#general_paper_no').val(paper_no_split[0]+"-"+paper_no);
				return false;
			}
		}
		if( $.trim($('#general_paper_date').val()) == '' ){
			alert("Lütfen Belge Tarihi Giriniz!");
			return false;
		}
		if( $.trim($('#general_paper_notice').val()) == '' ){
			alert("Lütfen Ek Açıklama Giriniz!");
			return false;
		}
		document.getElementById("paper_submit").value = 1;
		$('#setProcessForm').submit();
		
	}

	function del_payments()
	{
		var controlChc = 0;
		$('.checkControl').each(function(){
			if(this.checked){
				controlChc += 1;
			}
		});
		if(controlChc == 0){
			alert("<cf_get_lang dictionary_id='53612.Please select additional allowance'>");
			return false;
		}
		document.getElementById("del_submit").value = 1;
		$('#setProcessForm').submit();

	}
</script>

<cf_get_lang_set module_name="#fusebox.circuit#">
	