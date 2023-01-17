<cf_get_lang_set module_name="ehesap">
<cf_xml_page_edit fuseact="ehesap.list_emp_interruption">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.yil" default="#year(now())#">
<cfparam name="attributes.aylar" default="#Month(now())#">
<cfparam name="attributes.end_mon" default="#Month(now())#">
<cfparam name="attributes.odkes" default="">
<cfparam name="attributes.param" default="">
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.position_cat_id" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.inout_statue" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.action_list_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.filter_process" default="">
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>

<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'ehesap.list_payments')>

<cfscript>
	toplam_tutar=0;
	url_str = "";
	url_str = "#url_str#&keyword=#attributes.keyword#";
	if (isdefined("attributes.branch_id") and len(attributes.branch_id))
		url_str = "#url_str#&branch_id=#attributes.branch_id#";
	if (len(attributes.odkes))
		url_str = "#url_str#&odkes=#attributes.odkes#";
	if (len(attributes.yil))
		url_str = "#url_str#&yil=#attributes.yil#";
	if (len(attributes.aylar))
		url_str = "#url_str#&aylar=#attributes.aylar#";
	if (len(attributes.collar_type))
		url_str = "#url_str#&collar_type=#attributes.collar_type#";
	if (len(attributes.position_cat_id))
		url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#";
	if (len(attributes.end_mon))
		url_str = "#url_str#&end_mon=#attributes.end_mon#";
	if (isdefined('attributes.form_submit'))
		url_str = "#url_str#&form_submit=#attributes.form_submit#";
	if (isdefined("attributes.department_id"))
		url_str = "#url_str#&department_id=#attributes.department_id#";
	if (isdefined("attributes.hierarchy"))
		url_str = "#url_str#&hierarchy=#attributes.hierarchy#";
	if (isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.expense_code_name") and len(attributes.expense_code_name))
		url_str = "#url_str#&expense_center_id=#attributes.expense_center_id#&expense_code_name=#attributes.expense_code_name#";
</cfscript>
<cfif len(attributes.startdate) and isdate(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif len(attributes.finishdate) and isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>
<!--- Pozistyon ekleme sayfasının xml ine göre pozisyon alanını kapatıyoruz --->
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
			action_table = 'SALARYPARAM_GET'
			action_column = 'SPG_ID'
			action_page = '#request.self#?fuseaction=ehesap.list_interruption'
			total_values = '#totalValues#'
		>
		<cfset attributes.approve_submit = 0>
	</cfif>
</cfif>

<cfif (get_position_list_xml.recordcount and get_position_list_xml.property_value eq 1) or get_position_list_xml.recordcount eq 0><cfset show_position = 1><cfelse><cfset show_position = 0></cfif>
<cfinclude template="../query/get_ssk_offices.cfm">
<cfquery name="get_branches" datasource="#DSN#">
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
<cfif isdefined('attributes.form_submit')>
<cfinclude template="../query/get_interruptions.cfm">
<cfelse>
<cfset get_interruption.recordcount = 0>
</cfif>
<cfquery name="get_odeneks" datasource="#dsn#">
	SELECT 
		ODKES_ID,
		COMMENT_PAY
	FROM 
		SETUP_PAYMENT_INTERRUPTION 
	WHERE 
		IS_ODENEK = 0
</cfquery>
<cfquery name="GET_POSITION_CATS_" datasource="#dsn#">
	SELECT 
    	POSITION_CAT_ID, 
        POSITION_CAT, 
        HIERARCHY, 
        POSITION_CAT_STATUS
    FROM 
	    SETUP_POSITION_CAT 
    ORDER BY 
    	POSITION_CAT
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=#fusebox.circuit#.list_interruption" name="myform" method="post">
            <input type="hidden" name="form_submit" id="form_submit" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#message#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57761.Hiyerarşi"></cfsavecontent>
                    <cfinput name="hierarchy" id="hierarchy" placeholder="#message#" value="#attributes.hierarchy#" style="width:100px;" maxlength="50">
                </div>
                <div class="form-group">
                    <select name="ODKES" id="ODKES" style="width:120px;">
                        <option value=""><cf_get_lang dictionary_id='53275.Kesinti Türü'></option>
                        <cfoutput query="get_odeneks">
                            <option value="#COMMENT_PAY#"<cfif attributes.odkes eq comment_pay> Selected</cfif>>#COMMENT_PAY#</option>
                        </cfoutput>
                    </select>
                </div>
                <cfif is_expense_center eq 1>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.EXPENSE_CODE_NAME") and len(attributes.EXPENSE_CODE_NAME)><cfoutput>#attributes.expense_center_id#</cfoutput></cfif>">
                        <input type="Text" name="EXPENSE_CODE_NAME" id="EXPENSE_CODE_NAME" value="<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id) and isdefined("attributes.EXPENSE_CODE_NAME") and len(attributes.EXPENSE_CODE_NAME)><cfoutput>#attributes.EXPENSE_CODE_NAME#</cfoutput></cfif>" style="width:145px;">
                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=myform.expense_center_id&field_acc_code_name=myform.EXPENSE_CODE_NAME</cfoutput>','list');"></span>
                    </div>
                </div>
                </cfif>
                <div class="form-group">
                    <select name="aylar" id="aylar" onchange="change_mon(this.value);">
                        <cfloop from="1" to="12" index="i">
                            <cfset ay_bu=ListGetAt(ay_list(),i)>
                            <cfoutput><option value="#i#" <cfif attributes.aylar eq i>Selected</cfif> >#ay_bu#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="end_mon" id="end_mon">
                        <cfloop from="1" to="12" index="i">
                            <cfset ay_bu=ListGetAt(ay_list(),i)>
                            <cfoutput><option value="#i#" <cfif attributes.end_mon eq i>Selected</cfif> >#ay_bu#</option></cfoutput>
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
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-inout_statue">
                        <label class="col col-12"><cf_get_lang dictionary_id='58535.Girişler'>/<cf_get_lang dictionary_id='58536.Çıkışlar'></label>
                        <div class="col col-12">
                            <select name="inout_statue" id="inout_statue">
                                <option value=""><cf_get_lang dictionary_id="53208.Giriş ve Çıkışlar"></option>
                                <option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
                                <option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
                                <option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id="39083.Aktif Çalışanlar"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-startdate">
                        <label class="col col-12"><cf_get_lang dictionary_id='57501.Başlangıç'>-<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-12">
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                                    <cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                                </div>
                            </div>
                            <div class="col col-6">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                    <cfinput type="text" name="finishdate" id="finishdate" style="width:65px;"  maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-position_cat_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'></label>
                        <div class="col col-12">
                            <select name="position_cat_id" id="position_cat_id" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id='57779.Pozisyon Tipleri'>
                                <cfoutput query="GET_POSITION_CATS_">
                                    <option value="#POSITION_CAT_ID#"<cfif attributes.position_cat_id eq position_cat_id> selected</cfif>>#POSITION_CAT#
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-related_company">
                        <label class="col col-12"><cf_get_lang dictionary_id='53701.İlgili Şirket'></label>
                        <div class="col col-12">
                            <select name="related_company" id="related_company">
                                <option value=""><cf_get_lang dictionary_id='53701.İlgili Şirket'></option>
                                <cfoutput query="get_branches">
                                    <option value="#related_company#" <cfif isdefined("attributes.related_company") and attributes.related_company is related_company>selected</cfif>>#related_company#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12">
                            <select name="BRANCH_ID" id="branch_id" style="width:200px;" onChange="showDepartment(this.value)">
                                <option value="all"><cf_get_lang dictionary_id='57453.Şube'></option>
                                <cfoutput query="GET_SSK_OFFICES">
                                    <cfif len(SSK_OFFICE) and len(SSK_NO)>
                                        <option value="#BRANCH_ID#"<cfif isdefined("attributes.BRANCH_ID") and (attributes.BRANCH_ID is BRANCH_ID)> selected</cfif>>#BRANCH_NAME#</option>
                                    </cfif>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-off_validate">
                        <label><cf_get_lang dictionary_id='53042.Onay Durumu'></label>
                        <cf_workcube_process is_upd='0' select_value="#attributes.filter_process#" process_cat_width='188' is_detail='0' select_name="filter_process" is_select_text="1">
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="DEPARTMENT_PLACE">
                        <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-12">
                            <select name="department_id" id="department_id" style="width:150px">
                                <option value="0"><cf_get_lang dictionary_id='57572.Departman'></option>
                                <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                                    <cfquery name="get_departmant" datasource="#dsn#">
                                        SELECT 
                                            DEPARTMENT_STATUS, 
                                            IS_STORE, 
                                            BRANCH_ID, 
                                            DEPARTMENT_ID, 
                                            DEPARTMENT_HEAD, 
                                            HIERARCHY
                                        FROM 
                                            DEPARTMENT 
                                        WHERE 
                                            DEPARTMENT_STATUS = 1 
                                        AND 
                                            BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> 
                                        AND 
                                            IS_STORE <> 1 
                                        ORDER BY 
                                            DEPARTMENT_HEAD
                                    </cfquery>
                                    <cfoutput query="get_departmant">
                                        <option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department_id') and (attributes.department_id eq get_departmant.DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
                                    </cfoutput>
                                </cfif>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-collar_type">
                        <label class="col col-12"><cf_get_lang dictionary_id='54054.Yaka Tipi'></label>
                        <div class="col col-12">
                            <select name="collar_type" id="collar_type">
                                <option value=""><cf_get_lang dictionary_id='54054.Yaka Tipi'></option>
                                <option value="1"<cfif attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='54055.Mavi Yaka'></option> 
                                <option value="2"<cfif attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='54056.Beyaz Yaka'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfform name="setProcessForm" id="setProcessForm" method="post" action="">
        <cf_box title="#getLang('','kesintiler','38977')#" uidrop="1" hide_table_column="1">
            <cf_grid_list> 
                <thead>
                    <tr> 
                        <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
                        <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                        <th><cf_get_lang dictionary_id='57453.Şube'></th>
                        <th><cf_get_lang dictionary_id='57572.Departman'></th>
                        <th><cf_get_lang dictionary_id='59004.Pozisyon tipi'></th>
                        <cfif show_position eq 1>
                            <th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='54054.Yaka tipi'></th>
                        <cfif is_in_date eq 1>
                            <th><cf_get_lang dictionary_id='53348.İşe Giriş Tarihi'></th>
                        </cfif>
                        <cfif is_out_date eq 1>
                            <th><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></th>
                        </cfif>
                        <cfif is_expense_center eq 1><th><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th></cfif>
                        <th><cf_get_lang dictionary_id='53275.Kesinti Türü'></th>
                        <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                        <th><cf_get_lang dictionary_id="53132.başlangıç ay"></th>
                        <th><cf_get_lang dictionary_id="53133.bitiş ay"></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
                        <cfif fusebox.circuit is 'ehesap'>
                            <cfif len(attributes.filter_process)>
                                <th width="20"><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0"/></th>
                            </cfif>
                            <!-- sil --><th class="text-center" width="5"><a href="javascript://" onClick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_interruption&event=add','wide');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
                        </cfif>
                    </tr>
                </thead>
                <cfparam name="attributes.totalrecords" default="#get_interruption.recordcount#">
                <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <cfif get_interruption.recordcount>
                    <tbody>
                        <cfset in_out_id_list = "">
                        <cfoutput query="get_interruption" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif not listfind(in_out_id_list,in_out_id)>
                                <cfset in_out_id_list=listappend(in_out_id_list,in_out_id)>
                            </cfif>
                        </cfoutput>
                        <cfif is_expense_center eq 1>
                        <cfif len(in_out_id_list)>
                            <cfquery name="get_in_out_period" datasource="#dsn2#">
                                SELECT
                                    IN_OUT_ID,
                                    EC.EXPENSE,
                                    EC.EXPENSE_ID
                                FROM 
                                    #dsn_alias#.EMPLOYEES_IN_OUT_PERIOD EP,
                                    EXPENSE_CENTER EC
                                WHERE
                                    EP.EXPENSE_CENTER_ID = EC.EXPENSE_ID AND
                                    EP.IN_OUT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#in_out_id_list#">)
                                ORDER BY
                                    IN_OUT_ID
                            </cfquery>
                            <cfset in_out_id_list = listsort(listdeleteduplicates(valuelist(get_in_out_period.IN_OUT_ID,',')),'numeric','ASC',',')>
                        </cfif>
                        </cfif>
                            <cfoutput query="get_interruption" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                                <tr>
                                    <td width="30">#currentrow#</td>
                                    <td><cf_duxi name='identity_no' class="tableyazi" type="label" value="#tc_identy_no#" gdpr="2"></td>
                                    <cfif fusebox.circuit is 'ehesap'>
                                        <td><a href="#request.self#?fuseaction=ehesap.list_salary&event=upd&employee_id=#employee_id#&in_out_id=#in_out_id#&empName=#UrlEncodedFormat('#EMPLOYEE#')#" class="tableyazi">#employee_name# #employee_surname#</a></td>
                                    <cfelse>
                                        <td>#employee_name# #employee_surname#</td>
                                    </cfif>
                                    <td>#BRANCH_NAME#</td>
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
                                    <td><cfif len(in_out_id)>#get_in_out_period.EXPENSE[listfind(in_out_id_list,IN_OUT_ID,',')]#</cfif></td>
                                    </cfif>
                                    <td>#comment_get#</td>
                                    <td>#detail#</td>
                                    <td>#listgetat(ay_list(),START_SAL_MON)#</td>
                                    <td>#listgetat(ay_list(),END_SAL_MON)#</td>
                                    <td style="text-align:right;"><cfif METHOD_GET eq 2>%</cfif><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(AMOUNT_GET)#"></td>
                                    <cfset toplam_tutar=toplam_tutar+AMOUNT_GET>
                                    <td>
                                        <cfif len(PROCESS_STAGE)>
                                            <cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#">
                                        </cfif>
                                    </td>   
                                    <cfif fusebox.circuit is 'ehesap'>
                                        <cfif len(attributes.filter_process)>
                                            <td>
                                                <input class="checkControl" type="checkbox" name="action_list_id" id="action_list_id" value="#spg_id#"/>
                                            </td>
                                        </cfif>
                                        <!-- sil --><td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_interruption&event=upd&id=#spg_id#&is_interruption=1');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                                    </cfif>
                                </tr>
                            </cfoutput> 
                        <cfset cols = 10>
                        </tbody>
                        <cfif is_expense_center eq 1><cfset cols = cols+1></cfif>
                        <cfif is_in_date eq 1><cfset cols = cols+1></cfif>
                        <cfif is_out_date eq 1><cfset cols = cols+1></cfif>
                        <cfif show_position eq 1><cfset cols = cols+1></cfif>
                        <tfoot>
                            <tr>
                                <td class="formbold" colspan="15" style="text-align:right;"><cf_get_lang dictionary_id='57492.Toplam'> : <cfoutput><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#TLFormat(toplam_tutar)#"></cfoutput></td>
                            </tr>
                        </tfoot>
                </cfif>
            </cf_grid_list> 
            <cfif get_interruption.recordcount eq 0>
                <div class="ui-info-bottom">
                    <p><cfif isdefined("attributes.form_submit")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></p>
                </div>
            </cfif>
            
            <cf_paging
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="ehesap.list_interruption&#url_str#">
        </cf_box>
        <cfif isdefined("attributes.form_submit") and len(attributes.form_submit) and len(attributes.filter_process)>
            <cf_box id="list_checked" closable="0" title="#getLang('','',46186)#">
                <cf_box_elements vertical="1">
                    <div class="col col-4 col-xs-12" type="column" index="1" sort="true">
                        <cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
                        faction_list : 'ehesap.list_interruption',
                        filter_stage: '#attributes.filter_process#')>
                        <cf_workcube_general_process print_type="145" select_value = '#get_process_f.process_row_id#'>						
                    </div>
                </cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="ui-form-list-btn">
                        <input type="hidden" id="paper_submit" name="paper_submit" value="0">
                        <div>
                            <input type="submit" name="setOfftimeProcess" id="setOfftimeProcess" onclick="if(confirm('<cf_get_lang dictionary_id='57535.Kaydetmek istediğinize emin misiniz'>')) return setofftimesProcess(); else return false;" value="<cf_get_lang dictionary_id='57461.Kaydet'>">
                        </div>
                    </div>
                </div>
            </cf_box>
        </cfif>
    </cfform>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
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
			alert("<cf_get_lang dictionary_id='52987.Please select deduction'>");
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
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
