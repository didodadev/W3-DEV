<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.online" default="">
<cfparam name="attributes.process_stage" default="">
<cfset groups = createObject("component","V16.training_management.cfc.training_groups")>

<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'training_management.list_training_groups')>
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
			action_table = 'TRAINING_CLASS_GROUPS'
			action_column = 'TRAIN_GROUP_ID'
			action_page = '#request.self#?fuseaction=training_management.list_training_groups'
			total_values = '#totalValues#'
		>
		<cfset attributes.approve_submit = 0>
	</cfif>
</cfif>
	<!---<cfquery name="get_attender_train_qroup" datasource="#dsn#">
			SELECT
				TCA.*
			FROM
				TRAINING_CLASS_ATTENDER TCA,
				<!--- TRAINING_CLASS_GROUP_CLASSES TCGC, --->
				EMPLOYEE_POSITIONS EPOS,
				DEPARTMENT D,
				BRANCH B,
				OUR_COMPANY COMP
			WHERE
				<!--- TCGC.CLASS_ID = TCA.CLASS_ID AND --->
				TCA.EMP_ID = EPOS.EMPLOYEE_ID AND
				EPOS.DEPARTMENT_ID = D.DEPARTMENT_ID AND 
				D.BRANCH_ID = B.BRANCH_ID AND
				B.COMPANY_ID = COMP.COMP_ID AND
				B.BRANCH_ID IN (
									SELECT
										BRANCH_ID
									FROM
										EMPLOYEE_POSITION_BRANCHES
									WHERE
										POSITION_CODE =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">	
								)
		</cfquery>
		<cfset class_id_list = listsort(listdeleteduplicates(valuelist(get_attender_train_qroup.class_id,',')),'numeric','ASC',',')>
	--->
	<cfif isdefined("attributes.form_submitted")><!---len(class_id_list) and katılımcılarin şubesi benim yetkili olduğum şubeler ise sadece kayitlari gorebiliyordum simdilik kaldirildi SG 20120816 --->
		<cfset get_group = groups.get_training_groups_list(attributes.keyword)/>
	<cfelse>
		<cfset get_group.recordcount=0>
	</cfif>
	
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_group.recordcount#>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box >
		<cfform name="form1" action="#request.self#?fuseaction=training_management.list_training_groups" method="post">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" id="keyword" name="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#place#"/>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
				</div>
				<!--- <div class="row" type="row">
					<div class="col col-12 form-inline">
						<div class="form-group">
							<label><cf_get_lang dictionary_id='48.Filtre'></label>
						</div>
						<div class="form-group"><cfinput type="text" id="keyword" name="keyword" maxlength="50" value="#attributes.keyword#">
						</div>
						<div class="form-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)" style="width:25px;">
						</div>
						<div class="form-group">
						<cf_wrk_search_button>
						</div>
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
					</div>
				</div> --->
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(637,'Sınıfla',58049)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead> 
				<tr> 
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='32326.Sınıf'></th>
					<th><cf_get_lang dictionary_id='57544.Sorumlu'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'>-<cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id='46013.Kontenjan'></th>
					<th width="200" class="text-center"><cf_get_lang dictionary_id='46015.Ders'></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#</cfoutput>.list_training_groups&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_group.recordcount gt 0>
					<cfoutput query="get_group" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td width="35">#currentrow#</td>
							<td><a  class="tableyazi" href="#request.self#?fuseaction=training_management.list_training_groups&event=upd&train_group_id=#TRAIN_GROUP_ID#">#GROUP_HEAD#</a></td>
							<td>
								<cfif IsNumeric(get_group.GROUP_EMP)>

									<cfset GET_EMP_NAME = groups.EMP_NAME(EMPLOYEE_ID : get_group.GROUP_EMP)/>
									
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#group_emp#','project');" class="tableyazi">#GET_EMP_NAME.EMPLOYEE_NAME#&nbsp;#GET_EMP_NAME.EMPLOYEE_SURNAME#</a>
								</cfif>
							</td>
							<td>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#EMPLOYEE_ID#','project');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>
							</td>
							<td>#DEPARTMENT_HEAD# - #BRANCH_NAME#</td>
							<td>
								#dateFormat(RECORD_DATE, 'dd/mm/yyyy')#
							</td>
							<td>
								#QUOTA#
							</td>
							<td align="center">
								<cfset get_class_num = groups.class_num(TRAIN_GROUP_ID : get_group.TRAIN_GROUP_ID)/>
								#get_class_num.TOT#
							</td>
							<!-- sil -->
							<td id="valid_status_#TRAIN_GROUP_ID#">
								<cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#">
							</td>
							<td style="text-align:center;"><a href="#request.self#?fuseaction=training_management.list_training_groups&event=upd&train_group_id=#TRAIN_GROUP_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfif get_group.recordcount gt 0 and (attributes.totalrecords gt attributes.maxrows)>
			<cfset url_str = "">
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.online)>
				<cfset url_str = "#url_str#&online=#attributes.online#">
			</cfif>
				<cfif len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
				<cf_paging
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="training_management.list_training_groups#url_str#"> 
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

