<cfinclude template="calc_icra.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfparam name="attributes.comp_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.form_submitted" default="1">
<cfparam name="attributes.process_stage" default="">
<cfif len(attributes.startdate)>
	<cf_date tarih='attributes.startdate'>
</cfif>

<cfif len(attributes.finishdate)>
	<cf_date tarih='attributes.finishdate'>
</cfif>

<cfquery name="get_docs" datasource="#DSN#">
	SELECT
		DISTINCT
		EP.*,
		E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS KAYIT_EDEN,
		(SELECT E2.EMPLOYEE_NAME + ' ' + E2.EMPLOYEE_SURNAME FROM EMPLOYEES E2 WHERE E2.EMPLOYEE_ID = EP.EMPLOYEE_ID) AS ILGILI
	FROM
		COMMANDMENT EP
		,EMPLOYEES E
		,EMPLOYEES_IN_OUT EIO
		,DEPARTMENT D
		,BRANCH B
		,OUR_COMPANY OC
	WHERE
		EP.RECORD_EMP = E.EMPLOYEE_ID
		AND EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID
		AND EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
		AND D.BRANCH_ID = B.BRANCH_ID
		AND B.COMPANY_ID = OC.COMP_ID
		<cfif not session.ep.ehesap>
			AND OC.COMP_ID IN (SELECT DISTINCT B2.COMPANY_ID FROM EMPLOYEE_POSITION_BRANCHES EBR LEFT JOIN BRANCH B2 ON B2.BRANCH_ID = EBR.BRANCH_ID WHERE EBR.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
		<cfif not session.ep.ehesap>
            AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
        </cfif>
		<cfif len(attributes.keyword)>
			AND 
				(
				EP.SERIAL_NO + EP.SERIAL_NUMBER LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				OR
				'IC-' + CAST(EP.COMMANDMENT_ID AS NVARCHAR) LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
				)
		</cfif>

		<cfif len(attributes.startdate) and not len(attributes.finishdate)>
			AND EP.COMMANDMENT_DATE >= #attributes.startdate#
		</cfif>
		<cfif len(attributes.finishdate) and not len(attributes.startdate)>
			AND EP.COMMANDMENT_DATE <= #attributes.finishdate#
		</cfif>
		<cfif len(attributes.startdate) and len(attributes.finishdate)>
			AND 
				(
					(EP.COMMANDMENT_DATE >= #attributes.startdate# AND EP.COMMANDMENT_DATE <= #attributes.finishdate#)
				)
		</cfif>
		<cfif len(attributes.employee_id) and len(attributes.employee)>
			AND EP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		</cfif>
		<cfif len(trim(attributes.comp_id))>
			AND OC.COMP_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.comp_id#">)
		</cfif>
		<cfif len(trim(attributes.branch_id))>
			AND B.BRANCH_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.branch_id#">)
		</cfif>
		<cfif len(trim(attributes.department_id))>
            AND D.DEPARTMENT_ID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#attributes.department_id#">)
		</cfif>
		<cfif len(attributes.process_stage)>
			AND EP.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
		</cfif>
	ORDER BY
		EP.RECORD_DATE DESC
</cfquery>
<cfquery name="get_process_type" datasource="#dsn#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%ehesap.list_executions%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfscript>
	cmp_company = createObject("component","V16.hr.cfc.get_our_company");
	cmp_company.dsn = dsn;
	get_company = cmp_company.get_company(is_control : 1);
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch(ehesap_control : 1, comp_id : '#iif(len(attributes.comp_id),"attributes.comp_id",DE(""))#');
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');
</cfscript>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_docs.recordcount#'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="arama_form" method="post" action="#request.self#?fuseaction=ehesap.list_executions">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="1">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#place#" maxlength="50" style="width:60px;">
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id="53089.İlgili Kişi"></cfsavecontent>
						<input type="hidden" name="employee_id" maxlength="50" id="employee_id" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
						<input type="text" name="employee"  maxlength="50" id="employee" style="width:125px;" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee#</cfoutput></cfif>" placeholder="<cfoutput>#place#</cfoutput>" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','search_asset','3','135')" autocomplete="off">
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=arama_form.employee&field_emp_id=arama_form.employee_id&select_list=1,9','list');return false"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id="57699.Baş.Tarihi"></cfsavecontent>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
						<cfinput value="#dateformat(attributes.startdate,'dd/mm/yyyy')#" type="text" name="startdate" placeholder="#place#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id="57700.BitişTarihi"></cfsavecontent>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
						<cfinput value="#dateformat(attributes.finishdate,'dd/mm/yyyy')#" type="text" name="finishdate" placeholder="#place#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
					</div>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)"  required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-3 col-xs-12">
					<div class="form-group">										  
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29531.Şirketler'></label>
						<div class="col col-12 col-xs-12">
							<div id="COMP_PLACE">
								<cf_multiselect_check
									query_name="get_company"
									name="comp_id"
									width="140"
									option_value="COMP_ID"
									option_name="COMPANY_NAME"
									option_text="#getLang('main',322)#"
									value="#attributes.comp_id#"
									onchange="get_branch_list(this.value)">
							</div>
						</div>
					</div>	
				</div>
				<div class="col col-3 col-xs-12">
					<div class="form-group">										  
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
						<div class="col col-12 col-xs-12">
							<div id="BRANCH_PLACE">                                           
								<cf_multiselect_check 
									query_name="get_branches"  
									name="branch_id"
									width="140" 
									option_value="BRANCH_ID"
									option_name="branch_name"
									option_text="#getLang('main',322)#"
									value="#attributes.branch_id#"
									onchange="get_department_list(this.value)">
							</div>
						</div>
					</div>		
				</div>
				<div class="col col-3 col-xs-12">
					<div class="form-group">										  
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
						<div class="col col-12 col-xs-12">
							<div id="DEPARTMENT_PLACE">
								<cf_multiselect_check 
									query_name="get_department"  
									name="department_id"
									width="140" 
									option_value="DEPARTMENT_ID"
									option_name="DEPARTMENT_HEAD"
									option_text="#getLang('main',322)#"
									value="#attributes.department_id#">
							</div>
						</div>
					</div>
				</div>
				<div class="col col-3 col-xs-12">
					<div class="form-group" id="item-process_stage">
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
						<div class="col col-12 col-xs-12">
							<select name="process_stage" id="process_stage">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_process_type">
									<option value="#process_row_id#"<cfif attributes.process_stage eq process_row_id>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	
	<cf_box title="#getlang('','İcra Dosyaları','39036')#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id="58577.Sıra"></th>
					<th><cf_get_lang dictionary_id="57487.No"></th>
					<th><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></th>
					<th><cf_get_lang dictionary_id="53089.İlgili Kişi"></th>
					<th><cf_get_lang dictionary_id="57630.Tip"></th>
					<th><cf_get_lang dictionary_id="31746.İcra Tarihi"></th>
					<th><cf_get_lang dictionary_id="45515.İcra No"></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id="57673.Tutar"></th>
					<th><cf_get_lang dictionary_id="58444.Kalan"></th>
					<th><cf_get_lang dictionary_id="57899.Kaydeden"></th>
					<th width="35"><cf_get_lang dictionary_id="57691.Dosya"></th>
					<th><cf_get_lang dictionary_id="57756.Durum"></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_executions&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_docs.recordcount>
				<cfset total_amount = 0>
				<cfset total_remain = 0>
				<cfoutput query="get_docs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<input type="hidden" name="COMMANDMENT_ID" id="COMMANDMENT_ID" value="#COMMANDMENT_ID#">
					<tr>
						<td width="15">#currentrow#</td>
						<td><a href="#request.self#?fuseaction=ehesap.list_executions&event=upd&id=#COMMANDMENT_ID#" class="tableyazi">IC-#COMMANDMENT_ID#</a></td>
						<td>#dateformat(record_date,'dd/mm/yyyy')# #timeformat(record_date,'HH:MM')#</td>
						<td>#ILGILI#</td>
						<td><cfif COMMANDMENT_TYPE eq 1><cf_get_lang dictionary_id="39719.İcra"><cfelse><cf_get_lang dictionary_id="45514.Nafaka"></cfif></td>
						<td>#dateformat(COMMANDMENT_DATE,'dd/mm/yyyy')#</td>
						<td>#serial_no# #serial_number#</td>
						<td><cfif len(process_stage)><cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#"></cfif></td>
						<td style="text-align:right;">
							<cfset total_amount = total_amount + COMMANDMENT_VALUE>
							<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(COMMANDMENT_VALUE)#">
						</td>
						<td style="text-align:right;">
							<cfif len(ODENEN)>
								<cfset odenen_ = ODENEN>
							<cfelse>
								<cfset odenen_ = 0>
							</cfif>
							<cfif len(PRE_COMMANDMENT_VALUE)>
								<cfset pre_commandment_value_ = PRE_COMMANDMENT_VALUE>
							<cfelse>
								<cfset pre_commandment_value_ = 0>
							</cfif>
							<cfset amount_row = COMMANDMENT_VALUE - pre_commandment_value_ - odenen_>
							<cfset total_remain = total_remain + amount_row>
							<cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(amount_row)#">
						</td>
						<td>#kayıt_eden#</td>
						<td>
							<cfif len(COMMANDMENT_FILE)>
							<a href="javascript://" onclick="windowopen('/documents/#COMMANDMENT_FILE#','medium');"><center><img src="/images/file.gif"/></center></a>
							</cfif>
						</td>
						<td><cfif is_apply eq 1><cf_get_lang dictionary_id="56261.Kabul"><cfelseif is_refuse eq 1><cf_get_lang dictionary_id="29537.Red"><cfelse><cf_get_lang dictionary_id="57058.Bekliyor"></cfif></td>
						<!-- sil --><td class="header_icn_none"><a href="#request.self#?fuseaction=ehesap.list_executions&event=upd&id=#COMMANDMENT_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Guncelle'>" alt="<cf_get_lang dictionary_id='57464.Guncelle'>"></i></a></td><!-- sil -->
					</tr>
				</cfoutput>
				<cfelse>
					<tr>
						<td colspan="12"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif len(attributes.employee_id) and len(attributes.employee) and get_docs.recordcount gt 1>
			<div class="ui-info-bottom flex-end " >
					<div class="padding-right-20">
						<p><b><cf_get_lang dictionary_id='29534.Toplam Tutar'> :</b> <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_amount)#"></p>
					</div>
					<div>
						<p><b><cf_get_lang dictionary_id='59773.Toplam Kalan'> : </b> <cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(total_remain)#"></p>
					</div>
			</div>
		</cfif>
		<cfset url_str="ehesap.list_executions">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.startdate)>
			<cfset url_str = "#url_str#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#">
		</cfif>
		<cfif len(attributes.finishdate)>
			<cfset url_str = "#url_str#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
		</cfif>

		<cfif len(attributes.employee_id)>
			<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
		</cfif>
		<cfif len(attributes.employee)>
			<cfset url_str = "#url_str#&employee=#attributes.employee#">
		</cfif>
		<cfif len(attributes.comp_id)>
			<cfset url_str = "#url_str#&comp_id=#attributes.comp_id#">
		</cfif>
		<cfif len(attributes.branch_id)>
			<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
		</cfif>
		<cfif len(attributes.department_id)>
			<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
		</cfif>
		<cfif len(attributes.process_stage)>
            <cfset url_str="#url_str#&process_stage=#attributes.process_stage#">
        </cfif>
		<cf_paging page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#url_str#">
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function get_branch_list(gelen)
	{
		checkedValues_b = $("#comp_id").multiselect("getChecked");
		var comp_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(comp_id_list == '')
				comp_id_list = checkedValues_b[kk].value;
			else
				comp_id_list = comp_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=branch_id&comp_id="+comp_id_list;
		AjaxPageLoad(send_address,'BRANCH_PLACE',1,'İlişkili Şubeler');
	}
	
	function get_department_list(gelen)
	{
        checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
</script>