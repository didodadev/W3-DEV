<!--- <script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout.js"></script>
<link rel="stylesheet" href="/css/assets/template/workdev/qpic.css">
<cfset list_action=createObject("component", "V16.process.cfc.list_process_qpic" )>
    <cfset list_process=list_action.listToRow()>
        <cfset list_emp=createObject("component", "V16.process.cfc.list_process_qpic" )>
            <cfset list_empRocord=list_emp.listToRow()>
                <div class="row">
                    <div class="col col-12">
                        <h4 class="wrkPageHeader">
                            <cfsavecontent variable="head"><cf_get_lang dictionary_id='48909.QPIC-RS'></cfsavecontent>
                            <cfoutput>#head#/Main Process</cfoutput>
                        </h4>
                    </div>
                </div>
                <div id="mainDesign">
                    <div class="row">
                        <div class="wrkPageHeader">
                            <div class="form-group">
                                <div class="col col-12">
                                    <div class="col col-6 col-md-4 col-sm-12">
                                        <div class="col col-1">
                                            <cfoutput>
                                                <a href="javascript:void()"
                                                    data-bind="click: function () { addRow() }"><i
                                                        class="fa fa-plus"></i></a>
                                            </cfoutput>
                                        </div>
                                        <div class="col col-4">Main Flow</div>
                                        <div class="col col-5">Detail</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" data-bind="foreach: tableRows">
                        <div class="form-group hoverSelected" >
                            <div class="col col-12">
                                <div class="col col-6 col-md-4 col-sm-12">
                                    <div class="col col-1">
                                        <a href="javascript()" data-bind="click: function () {removeRow($data)}"><i
                                                class="icon-minus"></i></a>
                                    </div>
                                    <div class="col col-4">
                                        <input type="text" data-bind="value:main, visible: editMode()"><span
                                            data-bind="text:main , visible: !editMode()"></span>
                                    </div>
                                    <div class="col col-5"><input type="text"
                                            data-bind="value:detail,visible: editMode()"><span
                                            data-bind="text:detail , visible: !editMode()"></span></div>
                                    <div class="col col-2 col-md-2 col-sm-2">
                                        <div class="col col-4 col-md-6 col-sm-6">
                                            <cfoutput>
                                                <a href="javascript://"
                                                    onclick="windowopen('index.cfm?fuseaction=objects.popup_emp_det&amp;emp_id=#list_empRocord.RECORD_EMP#','medium');"
                                                    ><i class="catalyst-user"></i></a>
                                            </cfoutput>
                                        </div>
                                        <div class="col col-4 col-md-6 col-sm-6">
                                            <cfoutput>
                                                <a data-bind="attr:{href:'#request.self#?fuseaction=process.qpic-r&event=add&mainid='+hiddenID()}">
                                                    <i class="catalyst-puzzle"></i></a>
                                            </cfoutput>
                                        </div>
                                        <div class="col col-4 col-md-6 col-sm-6">

                                            <a href="javascript()"
                                                data-bind="visible: editMode(), click:function () {saveRow($data)}"><i
                                                    class="icon-save"></i></a>
                                            <a href="javascript()"
                                                data-bind="visible: !editMode(), click:function () {editMode(true)}"><i
                                                    class="fa fa-edit"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <script type="text/javascript">
                    var mainDesign = function () {
                        var self = this;
                        self.createPage = function (box) {
                            return {
                                main: ko.observable(box == null || box.main == undefined ? '' : box.main),
                                detail: ko.observable(box == null || box.detail == undefined ? '' : box.detail),
                                hiddenID: ko.observable(box == null || box.hiddenID == undefined ? 0 : box.hiddenID),
                                editMode: ko.observable(box == null || box.editMode == undefined ? true : box.editMode)
                            };
                        }

                        self.tableRows = ko.observableArray([]);
                        self.addRow = function () {
                            var row = self.createPage(null);
                            self.tableRows.push(row);
                        }
                        
                        self.removeRow = function (row) {
                            if (confirm("Kayıt Silinsin mi? ")) {
                                $.ajax({
                                    url: "V16/process/cfc/add_process_qpic.cfc?method=deleteToRow",
                                    type: "POST",
                                    data: JSON.parse(ko.toJSON(row))
                                }).done(function (result) {
                                    console.log(result);

                                });
                                self.tableRows.remove(row);
                            }
                        }
                        self.saveRow = function (row) {
                            $.ajax({
                                url: "V16/process/cfc/add_process_qpic.cfc?method=saveToRow",
                                type: "POST",
                                data: JSON.parse(ko.toJSON(row))
                            }).done(function (result) {
                                console.log(result);
                                row.hiddenID(parseInt(result));
                            });

                            row.editMode(false);

                        }
                        return {
                            init: function () {

                                <cfoutput query="list_process">
                                    self.tableRows.push(self.createPage(
                    {main: '#PROCESS_MAIN_HEADER#',detail:'#PROCESS_MAIN_DETAIL#',hiddenID:#PROCESS_MAIN_ID#,
                                                    editMode:false}));
            </cfoutput>
                                ko.applyBindings(self, document.getElementById('mainDesign'));
                            }
                        }

                    }();
                    $(document).ready(function () {
                        mainDesign.init();
                    });

				</script> --->
<style>
	td a i{
		font-size: 14px!important;
	}
	.ui-card-item{
		padding:10px;
		background:#cbebf538;
	}
	.ui-card-item div{
		margin-bottom:5px;
	}
	.icons a, .ui-form-list-btn > div > a{
		margin:0 2.5px 0 0;
	}
	.ui-form-list-btn > div > a{
		margin:0 5px 2.5px 0;
	}
</style>
<cfparam name="attributes.author_id" default=""> 
<cfparam name="attributes.author_name" default="">
<cfparam name="attributes.authority_type" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.module" default="">
<cfparam name="attributes.company_id" default="#session.ep.company_id#">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.record_name" default="">
<cfparam name="attributes.record_id" default="">
<cfparam name="attributes.process" default="">
<cfparam name="list_comp" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.up_department_id" default="">
<cfparam name="attributes.up_department" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.employee_name" default="">
<cfset get_queries = createObject("component","V16.process.cfc.qpic_r_main_list")>
<cfset get_modules=get_queries.get_modules()>
<cfset get_company=get_queries.get_company()>
<cfset get_process=get_queries.get_process()>
<cfset s_process_id="">
<cfif isdefined("attributes.process") and len(attributes.process)>
	<cfset get_process_id=get_queries.get_process_id(process:attributes.process)>
     <cfif len(get_process_id.process_id)>
		<cfset s_process_id=valuelist(get_process_id.process_id,',')>
	</cfif>  
</cfif>
<cfif len(attributes.is_submitted)>
	<cfif len(attributes.author_id) and len(attributes.author_name)>
		<cfset get_rows=get_queries.get_rows(authority_type: attributes.authority_type,author_id:attributes.author_id)>
		<cfif get_rows.recordcount>
			<cfquery name="GET_PRO_ID" datasource="#DSN#">
				SELECT DISTINCT
					PROCESS_ID
				FROM 
					PROCESS_TYPE_ROWS
				WHERE
					PROCESS_ROW_ID IN (#valuelist(get_rows.process_row_id,',')#)
			</cfquery>
         <cfelse>
			<cfset get_pro_id.recordcount = 0>
		</cfif>
	<cfelse>
		<cfset get_pro_id.recordcount = 0>
	</cfif>
	<cfif len(attributes.author_id) and len(attributes.author_name) and get_pro_id.recordcount eq 0 and attributes.authority_type neq 0>
		<cfset GET_PROCESS_TYPE.recordcount = 0>
	<cfelse>
		
		<cfif get_pro_id.recordcount>
			<cfset record_count=get_pro_id.recordcount>
			<cfset list_process_id=Valuelist(GET_PRO_ID.PROCESS_ID,',')>
		<cfelse>
			<cfset record_count=0>
			<cfset list_process_id=0>
		</cfif>
		<cfset get_process_type=get_queries.get_process_type(
		module:attributes.module, 
		keyword:attributes.keyword,
		record_name:attributes.record_name,
		is_active:attributes.is_active,
		record_id:attributes.record_id,
		s_process_id:s_process_id,
		c_id:attributes.c_id,
		company_id:attributes.company_id,
		get_pro_id_process_id: list_process_id,
		get_pro_id_recordcount:record_count,
		department_id: attributes.department_id,
		department: attributes.department,
		up_department_id: attributes.up_department_id,
		up_department: attributes.up_department,
		emp_id: attributes.emp_id,
		employee_name: attributes.employee_name
		)>
		
	</cfif>
	<cfif get_process_type.recordcount>
		<cfset list_process=ListSort(listDeleteDuplicates(Valuelist(GET_PROCESS_TYPE.PROCESS_ID,',')),"numeric","asc",",")>
		<cfset get_our_company=get_queries.get_our_company(list_process:list_process)>
	</cfif>
<cfelse>
	<cfset get_process_type.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_process_type.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent  variable="head"><cf_get_lang dictionary_id="36187.Süreçler"> (<cf_get_lang dictionary_id='48909.QPIC-RS'>)
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search" method="post" action="#request.self#?fuseaction=process.qpic-r">
			<input name="is_submitted" id="is_submitted" type="hidden" value="1">
			<cf_box_search id="search_elements" plus="0">
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" id="keyword" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="item-process">
					<select name="process" id="process">
							<option value="" selected="selected"><cf_get_lang dictionary_id='36294.süreç'></option>
						<cfoutput query="get_process">
							<option value="#process_main_id#"<cfif attributes.process eq process_main_id>selected</cfif>>#process_main_header#</option>
						</cfoutput>
					</select>
				</div> 
				<div class="form-group" id="item-module">
					<select name="module" id="module">
							<option value="" selected><cf_get_lang dictionary_id ='55060.Modül'></option>
						<cfoutput query="get_modules">
							<option value="#module_short_name#" <cfif module_short_name eq attributes.module> selected</cfif>>#MODULE#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-is_active">
					<select name="is_active" id="is_active">
						<option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="" <cfif attributes.is_active eq "">selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group" id="item-company_id">
					<select name="company_id" id="company_id">
						<option value="" selected><cf_get_lang dictionary_id='57574.Şirket'></option>
							<cfoutput query="get_company">
								<cfquery name="get_period" datasource="#dsn#">
									SELECT
										PERIOD_ID
									FROM
										SETUP_PERIOD SP,
										OUR_COMPANY OC
									WHERE
										OC.COMP_ID = SP.OUR_COMPANY_ID AND
										OC.COMP_ID = #comp_id#
								</cfquery>
								<cfif get_period.recordcount>
								<cfset temp_per_id=valuelist(get_period.period_id,',')>
								<cfquery name="get_position_id" datasource="#dsn#">
									SELECT EMPLOYEE_ID,EMPLOYEE_NAME,POSITION_ID  FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
								</cfquery>
								<cfquery name="get_position" datasource="#dsn#">
									SELECT PERIOD_ID FROM EMPLOYEE_POSITION_PERIODS WHERE POSITION_ID=#get_position_id.position_id# AND PERIOD_ID IN (#temp_per_id#)
								</cfquery>
									<cfif get_position.recordcount>
									<option value="#comp_id#" <cfif comp_id eq attributes.company_id>selected</cfif>>#nick_name#</option>
									<cfset list_comp=listappend(list_comp,get_company.comp_id,',')>
								</cfif>
							</cfif>
						</cfoutput>
					</select>
					<input type="hidden" name="c_id" id="c_id" value="<cfoutput>#list_comp#</cfoutput>"/>
				</div>
				<div class="form-group" id="item-authority_type">
					<select name="authority_type" id="authority_type">
						<option value="0" <cfif attributes.authority_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.authority_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57578.Yetkili'></option>
						<option value="2" <cfif attributes.authority_type eq 2>selected</cfif>><cf_get_lang dictionary_id='36200.Onay ve Uyarılacak'></option>
						<option value="3" <cfif attributes.authority_type eq 3>selected</cfif>><cf_get_lang dictionary_id='58773.Bilgi Verilecek'></option>
					</select>
				</div>
				<div class="form-group" id="item-record_id">
					<div class="input-group">
						<input type="hidden" name="record_id" id="record_id" value="<cfif len(attributes.record_name) and len(attributes.record_id)><cfoutput>#attributes.record_id#</cfoutput></cfif>" >					
						<input type="text" name="record_name" id="record_name" placeholder="<cf_get_lang dictionary_id='57899.Kaydeden'>" value="<cfif len(attributes.record_name) and len(attributes.record_id)><cfoutput>#attributes.record_name#</cfoutput></cfif>" onfocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','MEMBER_ID','record_id','','3','125');"  autocomplete="off" >                    
						<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=search.record_name&field_emp_id=search.record_id&select_list=1','list');return false"></span>
					</div>
				</div> 
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" style="width:25px;" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1," required="yes" message="#message#">
				</div> 
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=process.list_process&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
				</div>
			</cf_box_search> 
			<cf_box_search_detail>
				<cfoutput>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="item-author_id">
							<label><cf_get_lang dictionary_id='57576.Çalışan'></label>
							<div class="input-group">
								<input type="hidden" name="author_id" id="author_id" value="#attributes.author_id#" >
								<input type="text" name="author_name" id="author_name" placeholder="<cf_get_lang dictionary_id='57576.Çalışan'>" value="#attributes.author_name#"  onFocus="AutoComplete_Create('author_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_ID','author_id','','3','125');" autocomplete="off">
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_name=search.author_name&field_id=search.author_id&select_list=1','list');return false"></span>                           
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="2" type="column" sort="true">
						<div class="form-group" id="item-employee_name">
							<label><cf_get_lang dictionary_id='57544.Responsible'> </label>
							<div class="input-group">
								<input type="hidden" name="emp_id" id="emp_id" value="#attributes.emp_id#">
								<input type="text" name="employee_name" id="employee_name" value="#attributes.employee_name#" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','MEMBER_ID','emp_id','','3','125');">
								<span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_name=search.employee_name&field_emp_id=search.emp_id&function_name=fill_department&select_list=1','list')"></span>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="3" type="column" sort="true">
						<div class="form-group" id="item-up_department">
							<label><cf_get_lang dictionary_id='42335.Üst Departman'></label>
							<div class="input-group">
								<input type="hidden" name="up_department_id" id="up_department_id" value="#attributes.up_department_id#">
								<input type="text" name="up_department" id="up_department" value="#attributes.up_department#">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('#request.self#?fuseaction=hr.popup_list_departments&field_id=search.up_department_id&field_name=search.up_department','list','popup_list_departments');"></span>
							</div>
						</div>
					</div>
					<div class="col col-3 col-md-3 col-sm-6 col-xs-12" index="4" type="column" sort="true">
						<div class="form-group" id="item-department">
							<label><cf_get_lang dictionary_id='57572.Departman'></label>
							<div class="input-group">
								<input type="hidden" id="department_id" name="department_id" value="#attributes.department_id#" />
								<input type="text" id="department" name="department" value="#attributes.department#" />
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('#request.self#?fuseaction=hr.popup_list_departments&field_id=search.department_id&field_name=search.department','list','popup_list_departments');"></span>
							</div>
						</div>
					</div>					
				</cfoutput>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box  title="#head#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='58859.Süreç'></th>
					<th><cf_get_lang dictionary_id='36294.General Process'></th>
					<th width="20"><a href="javascript://"><i class="fa fa-random"></i></a></th>
					<th width="20"><a href="javascript://"><i class="fa fa-quora"></i></a></th>
					<th width="20"><a href="javascript://"><i class="fa fa-info-circle"></i></a></th>
					<th><cf_get_lang dictionary_id='36202.Aşamalar'></th>
					<th width="20"><a href="javascript://" title="<cf_get_lang dictionary_id='42335.Üst Departman'>" alt="<cf_get_lang dictionary_id='42335.Üst Departman'>"><i class="fa fa-bank"></i></a></th>
					<th width="20"><a href="javascript://" title="<cf_get_lang dictionary_id='57572.Departman'>" alt="<cf_get_lang dictionary_id='57572.Departman'>"><i class="fa fa-slideshare"></i></a></th>
					<th width="20"><a href="javascript://" title="<cf_get_lang dictionary_id='57544.Responsible'>" alt="<cf_get_lang dictionary_id='57544.Responsible'>"><i class="fa fa-user-circle"></i></a></th>
					<th width="20"><a href="javascript://"><i class="fa fa-support"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_process_type.recordcount>
					<cfoutput query="get_process_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#" >   
						<cfset GET_CONTENTS=get_queries.get_contents(process_id:PROCESS_ID)>
						<cfset GET_STAGES=get_queries.get_stages(process_id:PROCESS_ID)>
						<cfset get_main_process=get_queries.get_main_process(process_id:PROCESS_ID)>
						<tr>
							<td>#currentrow#</td>
							<td>
								<a href="#request.self#?fuseaction=process.list_process&event=upd&process_id=#process_id#">#process_name#</a></br>
								<cfif len(get_process_type.detail)><p><small>(#detail#)</small></p></cfif>
								<cfif len(get_process_type.MAIN_ACTION_FILE) or len(get_process_type.MAIN_FILE)>
									<div class="ui-form-list-btn flex-start">
										<div><cfif len(get_process_type.MAIN_ACTION_FILE)><a href="javascript://"><i class="fa fa-shield" style="color:##7518da!important"></i></a></cfif></div>
										<div><cfif len(get_process_type.MAIN_FILE)><a href="javascript://"><i class="fa fa-rocket" style="color:##e25757!important"></i></a></cfif></div>
									</div>
								</cfif>
							</td>
							<td><a href="#request.self#?fuseaction=process.general_processes&event=upd&process_id=#get_main_process.process_main_id#">#get_main_process.process_main_header#</a></td>
							<td>
								<cfset get_workflowdesigner=get_queries.get_workflowdesigner(process_id:PROCESS_ID)>
								<cfif get_workflowdesigner.recordcount>
									<a href="javascript://" onclick="cfmodal('V16/process/display/list_designer.cfm?action_section=#get_workflowdesigner.action_section#&relative_id=#get_workflowdesigner.relative_id#&fuseaction=process.qpic-r','warning_modal');"><i class="fa fa-random" style="color:##673ab7!important"></i></a>
								</cfif>
							</td>
							<td><a <cfif get_contents.recordCount>href="#request.self#?fuseaction=rule.dsp_rule&cntid=#GET_CONTENTS.CONTENT_ID#&faction=#process_id#"<cfelse>href="javascript://" onclick="nocontents();"</cfif>><i class="fa fa-folder" style="color:##369cf3!important"></i></a></td>
							<td><a href="javascript://"  onclick="cfmodal('V16/process/display/list_processfuseactions.cfm?id=#process_id#','warning_modal');"><i class="fa fa-cube" style="color:##f98726f0!important;"></i></a></td>
							<td>
								<div style="display:flex;">
									<cfloop query="get_stages">
										<cfset makerCount=0>
										<cfset GET_ALL_GROUPS=get_queries.GET_ALL_GROUPS(process_row_id:GET_STAGES.PROCESS_ROW_ID)>
										<cfset workgroup_id=GET_ALL_GROUPS.workgroup_id> 
										<cfif len(GET_STAGES.PROCESS_ROW_ID)>
											<cfif GET_STAGES.is_employee eq 1>
												<cfsavecontent  variable="users"><cf_get_lang dictionary_id="59523.Tüm Kullanıcılar"></cfsavecontent>
												<cfset makerCount="#users#">
											<cfelseif len(workgroup_id)>
												<cfquery name="GET_ALL_GROUPS" datasource="#DSN#">
													SELECT * FROM PROCESS_TYPE_ROWS_WORKGRUOP WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype = "CF_SQL_INTEGER" value = "#GET_STAGES.PROCESS_ROW_ID#">
												</cfquery>
												
												<cfloop query="GET_ALL_GROUPS">
													<cfset makerCount=makerCount+get_queries.GET_PRO(workgroup_id:workgroup_id)>
												</cfloop>
											</cfif>
										</cfif>  
										<cfif get_stages.line_number eq 1>
											<cfset style="background-color:##5d78ff0d;color:##5d78ff;margin-right:10px;padding:5px 10px;cursor:pointer">
											<cfset icon_color="color:##5d78ff!important;">
										<cfelseif  get_stages.line_number eq 2>
											<cfset style="background-color:##ffb8220d;color:##ffb822;margin-right:10px;padding:5px 10px;cursor:pointer">
											<cfset icon_color="color:##ffb822!important;">
										<cfelseif  get_stages.line_number eq 3>
											<cfset style="background-color:##0abb8712;color:##0abb87;margin-right:10px;padding:5px 10px;cursor:pointer">
											<cfset icon_color="color:##0abb87!important;">
										<cfelseif  get_stages.line_number eq 4>
											<cfset style="background-color:##fd397a12;color:##fd397a;margin-right:10px;padding:5px 10px;cursor:pointer">
											<cfset icon_color="color:##fd397a!important;">
										<cfelseif  get_stages.line_number eq 5>
											<cfset style="background-color:##9370d21f;;color:##673ab7;margin-right:10px;padding:5px 10px;cursor:pointer">
											<cfset icon_color="color:##673ab7!important;">
										<cfelse>
											<cfset style="background-color:##70dbe80f;;color:##0d99d8;margin-right:10px;padding:5px 10px;cursor:pointer">
											<cfset icon_color="color:##0d99d8!important;">
										</cfif>
										<span class="ui-stage" style="#style#">
										<a href="#request.self#?fuseaction=process.form_add_process_rows&event=upd&process_id=#get_process_type.process_id#&process_row_id=#GET_STAGES.PROCESS_ROW_ID#&process_name=#get_process_type.process_name#" style="#icon_color#" target="_blank">#stage#</a>
											<div class="margin-top-5">
												<small>#GET_STAGES.detail#</small>
												<a href="javascript://" onclick="window.open('index.cfm?fuseaction=objects.chatflow&tab=1&subtab=2','Workflow');"><i class="fa fa-comments" style="#icon_color#"></i></a>
												<a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=process.form_upd_process_rows&action_name=process_id&action_id=#process_id#','Workflow')"><i class="fa fa-bell" style="#icon_color#"></i></a>
												<cfif (GET_STAGES.IS_ONLINE  eq 1) or (GET_STAGES.IS_WARNING eq 1) or ( GET_STAGES.IS_EMAIL eq 1)>
													<a href="javascript://"><i class="fa fa-envelope-o" style="#icon_color#"></i></a>
												</cfif>
												<cfif GET_STAGES.CONFIRM_REQUEST eq 1>
													<a href="javascript://"><i class="fa fa-thumbs-up" style="#icon_color#"></i></a>
												</cfif>
												<a href="javascript://"><i class="catalyst-users" style="#icon_color#"><small>#makerCount#</small></i></a>
												<cfif len(GET_STAGES.display_file_name)><a href="javascript://"><i class="fa fa-shield" style="#icon_color#"></i></a></cfif>
													<cfif len(GET_STAGES.file_name)><a href="javascript://"><i class="fa fa-rocket" style="#icon_color#"></i></a></cfif>
											</div>
										</span>
										
										<!--- <cfif currentrow lt get_stages.recordcount><div style="display:flex; align-items:center; margin:0 5px;"><a href="javascript://"><i class="fa fa-caret-right" style="color:##4472b6!important; font-size:26px!important" ></i></a> </div></cfif> --->
									</cfloop>
								</div>
							</td>
							<td>
								<cfif len(upper_dep_id)>
									<cfquery name="departments" datasource="#dsn#">
										SELECT 
											DEPARTMENT_HEAD 
										FROM
											DEPARTMENT
										WHERE 
											DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#upper_dep_id#">
									</cfquery>
									<a href="javascript://" title="#departments.department_head#" alt="#departments.department_head#"><i class="fa fa-bank" style="color:##f1b81c!important"></i></a>
								</cfif>
							</td>
							<td>
								<cfif len(department_head)>
									<a href="javascript://" title="#department_head#" alt="#department_head#"><i class="fa fa-slideshare" style="color:##fd397a!important"></i></a>
								</cfif>
							</td>
							<td>
								<cfif len(name)>
									<a href="javascript://" title="#name#" alt="#name#"><i class="fa fa-user-circle" style="color:##673ab7!important"></i></a>
								</cfif>
							</td>
							<td><a href="https://wiki.workcube.com/?keyword=#PROCESS_NAME#" target="_blank"><i class="fa fa-support" style="color:##0abb87!important"></i></a></td>
						
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="11"><cfif len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></td>
						</tr>
				</cfif>
			</tbody>
		</cf_grid_list>  
		<cfset adres='process.qpic-r'>
		<cfif isdefined("attributes.keyword")>
			<cfset adres = "#adres#&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.module")>
			<cfset adres = "#adres#&module=#attributes.module#">
		</cfif>
		<cfif isdefined("attributes.author_name")>
			<cfset adres = "#adres#&author_name=#attributes.author_name#">
		</cfif>
		<cfif isdefined("attributes.authority_type")>
			<cfset adres = "#adres#&authority_type=#attributes.authority_type#">
		</cfif>
		<cfif len(attributes.is_submitted)> 
			<cfset adres = "#adres#&is_submitted=#attributes.is_submitted#">
		</cfif>
		<cfif len(attributes.author_id)> 
			<cfset adres = "#adres#&author_id=#attributes.author_id#">
		</cfif>
		<cfif isdefined("attributes.is_active")>
			<cfset adres = "#adres#&is_active=#attributes.is_active#">
		</cfif>	  
		<cfif isdefined("attributes.company_id")>
			<cfset adres = "#adres#&company_id=#attributes.company_id#">
		</cfif>
		<cfif isdefined("attributes.emp_id")>
			<cfset adres = "#adres#&emp_id=#attributes.emp_id#">
		</cfif>
		<cfif isdefined("attributes.department_id")>
			<cfset adres = "#adres#&department_id=#attributes.department_id#">
		</cfif>
		<cfif isdefined("attributes.up_department_id")>
			<cfset adres = "#adres#&up_department_id=#attributes.up_department_id#">
		</cfif>
		<cfif isdefined("attributes.c_id")><cfset adres = "#adres#&c_id=#attributes.c_id#"></cfif>
		<cf_paging 
			page="#attributes.page#"
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#">


	</cf_box>
</div>
<script type="text/javascript">
	function nocontents(){
		alert("<cfoutput><cf_get_lang dictionary_id="60689.İlişkili içerik bulunmamaktadır!"></cfoutput>");
		return false;

	}
    function cfmodal(action, id, option){
		if( option != undefined && option.html != undefined ) $( "#"+id ).html(option.html);
		else AjaxPageLoad(action, id);
	}

</script>