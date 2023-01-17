<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.employee_name" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.req_year" default="#session.ep.period_year#">
<cfparam name="attributes.request_type" default="1">
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.request_type)>
	<cfset url_str = "#url_str#&request_type=#attributes.request_type#">
</cfif>
<cfif len(attributes.employee_id)>
	<cfset url_str = "#url_str#&employee_id=#attributes.employee_id#">
</cfif>
<cfif len(attributes.req_year)>
	<cfset url_str = "#url_str#&req_year=#attributes.req_year#">
</cfif>
<cfif isdefined('attributes.is_submitted') and len(attributes.is_submitted)>
	<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfif isdefined('attributes.process_stage_type') and len(attributes.process_stage_type)>
	<cfset url_str = "#url_str#&process_stage_type=#attributes.process_stage_type#">
</cfif>
<cfif isdefined('attributes.is_submitted')>
<cfquery name="GET_TRAINING_REQUESTS" datasource="#dsn#">
	SELECT
		<cfif attributes.request_type eq 3><!--- duyuru talebi ise--->
		TRR.REQUEST_TYPE,
		TRR.CLASS_ID,
		TRR.RECORD_DATE,
        TRR.HR_VALID,
        TRR.REQUEST_ROW_ID,
		<cfelseif attributes.request_type eq 4>
		4 AS REQUEST_TYPE,
		TRR.CLASS_ID,
		TRR.RECORD_DATE,
		0 AS PROCESS_STAGE,
        TRR.HR_VALID,
        TRR.REQUEST_ROW_ID,
		<cfelse>
		(SELECT TOP 1 TRAIN_HEAD FROM TRAINING,TRAINING_REQUEST_ROWS TRR WHERE TRR.TRAIN_REQUEST_ID = TR.TRAIN_REQUEST_ID AND TRAIN_ID = TRR.TRAINING_ID) AS TRAINING_NAME,
		(SELECT TOP 1 OTHER_TRAIN_NAME FROM TRAINING_REQUEST_ROWS TRR WHERE TRR.TRAIN_REQUEST_ID = TR.TRAIN_REQUEST_ID) AS OTHER_TRAIN_NAME,
		(SELECT TOP 1 CLASS_ID FROM TRAINING_REQUEST_ROWS TRR WHERE TRR.TRAIN_REQUEST_ID = TR.TRAIN_REQUEST_ID) AS CLASS_ID,
		TR.*,
		</cfif>
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		<cfif attributes.request_type eq 3 or attributes.request_type eq 4><!--- duyuru talebi ise--->
			TRAINING_REQUEST_ROWS TRR,
		<cfelse>
			TRAINING_REQUEST TR,
		</cfif>
		EMPLOYEE_POSITIONS E,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY C
	WHERE
		<cfif attributes.request_type eq 3 or attributes.request_type eq 4>
		E.EMPLOYEE_ID = TRR.EMPLOYEE_ID  AND		
		<cfelse>
		E.EMPLOYEE_ID = TR.EMPLOYEE_ID  AND
		E.POSITION_CODE = TR.POSITION_CODE AND		
		</cfif>
		E.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND 
		C.COMP_ID=BRANCH.COMPANY_ID 
		<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN (
                                SELECT
                                    BRANCH_ID
                                FROM
                                    EMPLOYEE_POSITION_BRANCHES
                                WHERE
                                    POSITION_CODE =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> 	
                            ) 
		</cfif>
		<cfif len(attributes.keyword)>
			AND (E.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI OR E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> COLLATE SQL_Latin1_General_CP1_CI_AI)
		</cfif>
		<cfif attributes.request_type eq 1>
			AND TR.REQUEST_TYPE IN(1,2)<!--- eğitim talepleri katalog ve katalog dışı--->
		<cfelseif attributes.request_type eq 2> 
			AND TR.REQUEST_TYPE = 3 <!---yıllık eğitim talebi --->
		<cfelseif attributes.request_type eq 3>
			AND TRR.TRAIN_REQUEST_ID IS NULL AND TRR.ANNOUNCE_ID IS NOT NULL
		<cfelseif attributes.request_type eq 4>
			AND TRR.TRAIN_REQUEST_ID IS NULL AND TRR.ANNOUNCE_ID IS NULL
		</cfif>
		<cfif not listfind('3,4',attributes.request_type,',')>
			<cfif isdefined('attributes.process_stage_type') and len(attributes.process_stage_type)>
				AND TR.PROCESS_STAGE = #attributes.process_stage_type#
			</cfif>
		</cfif>
        <cfif listfind('3,4',attributes.request_type,',')>
			<cfif isdefined("attributes.req_year") and len(attributes.req_year)>
                AND DATEPART(YY,TRR.RECORD_DATE) = #attributes.req_year#
            </cfif> 
        </cfif>
		<cfif listfind('1,2',attributes.request_type,',')>
			<cfif isdefined("attributes.req_year") and len(attributes.req_year)>
                AND DATEPART(YY,TR.RECORD_DATE) = #attributes.req_year#
            </cfif>
        </cfif>
	ORDER BY
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME 
</cfquery>
<cfelse>
	<cfset get_training_requests.recordcount = 0> 
</cfif>
<cfquery name="GET_TRAINING_STAGE" datasource="#DSN#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%training_management.list_class_requests%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_training_requests.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_train_req" method="post" action="#request.self#?fuseaction=training_management.list_class_requests">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search> 
				<div class="form-group" id="item-keyword">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" id="keyword" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="item-request_type">
					<select name="request_type" id="request_type" >
						<option value="1" <cfif attributes.request_type eq 1>selected</cfif>><cfoutput>#getLang('','Eğitim Talepleri',46607)#</cfoutput></option>
						<option value="2" <cfif attributes.request_type eq 2>selected</cfif>><cf_get_lang dictionary_id='31108.Yıllık Eğitim Talepleri'></option>
						<option value="3" <cfif attributes.request_type eq 3>selected</cfif>><cf_get_lang dictionary_id='46662.Duyuru Talepleri'></option>			
						<option value="4" <cfif attributes.request_type eq 4>selected</cfif>><cfoutput>#getLang('','Ders Talepleri',46636)#</cfoutput></option>			
					</select>
				</div> 
				<div class="form-group" id="item-req_year">
					<select name="req_year" id="req_year" >
						<cfoutput>
							<cfloop from="2005" to="#session.ep.period_year+2#" index="i">
							<option value="#i#" <cfif i eq attributes.req_year>selected</cfif>>#i#</option>
							</cfloop>
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-process_stage_type">
					<select name="process_stage_type" id="process_stage_type">
						<option value="" selected><cf_get_lang dictionary_id='57482.Asama'></option>
						<cfoutput query="get_training_stage">
							<option value="#process_row_id#" <cfif isDefined('attributes.process_stage_type') and attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" onKeyUp="isNumber (this)" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
    <cf_box uidrop="1" hide_table_column="1" title="#getLang('','Eğitim Talepleri',46607)#">
		<cfform name="train_reqs" method="post" action="">
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th><cf_get_lang dictionary_id='51081.Talep Eden'></th>
						<th><cf_get_lang dictionary_id='57419.Eğitim'></th>
						<cfif attributes.request_type eq 2><th><cf_get_lang dictionary_id='58472.Dönem'></th></cfif>
						<cfif attributes.request_type eq 3 or attributes.request_type eq 4><th><cf_get_lang dictionary_id='46576.Eğitim Tarihi'></th></cfif>
						<cfif attributes.request_type neq 3 and attributes.request_type neq 4><th><cf_get_lang dictionary_id='57482.Aşama'></th></cfif>
						<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
						<cfif attributes.request_type eq 3 or attributes.request_type eq 4><th class="header_icn_none"><cf_get_lang dictionary_id='57500.Onay'><input type="checkbox" onchange="deselectAll(0);" name="allSelecthemand" id="allSelecthemand" onClick="wrk_select_all('allSelecthemand','row_demand_accept');"></th>
						<th class="header_icn_none text-center"><cf_get_lang dictionary_id='58461.Reddet'><input type="checkbox" name="allSelectDecs" id="allSelectDecs" onchange="deselectAll(1);" onClick="wrk_select_all('allSelectDecs','row_demand_decline');"></th>
						<th><cf_get_lang dictionary_id='57756.Durum'></th></cfif>
						<th width="20" class="header_icn_none text-center"><i class="fa fa-pencil"></i></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_training_requests.recordcount>	
						<cfif attributes.request_type neq 3>
							<cfset stage_id_list=''>
							<cfoutput query="get_training_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
								<cfif len(process_stage) and not listfind(stage_id_list,process_stage)>
									<cfset stage_id_list = Listappend(stage_id_list,process_stage)>
								</cfif>
							</cfoutput>
							<cfif len(stage_id_list)>
								<cfset stage_id_list=listsort(stage_id_list,"numeric","ASC",",")>
								<cfquery name="get_content_process_stage" datasource="#DSN#">
									SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_id_list#">) ORDER BY PROCESS_ROW_ID
								</cfquery>
								<cfset stage_id_list = listsort(listdeleteduplicates(valuelist(get_content_process_stage.process_row_id,',')),'numeric','ASC',',')>
							</cfif>
						</cfif>
						<cfoutput query="get_training_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
							<tr>
								<td width="35">#currentrow#</td>
								<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#employee_id#','project');" class="tableyazi">#employee_name# #employee_surname#</a></td>
								<cfif attributes.request_type eq 3 or attributes.request_type eq 4>
									<td>
										<cfif len(class_id)>
											<cfquery name="GET_CLASS" datasource="#dsn#">
												SELECT CLASS_NAME,CLASS_ID,START_DATE,FINISH_DATE FROM TRAINING_CLASS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
											</cfquery>#get_class.class_name#
										</cfif>
									</td>
									<td>#dateformat(get_class.start_date,dateformat_style)#-#dateformat(get_class.finish_date,dateformat_style)#</td>
								<cfelseif attributes.request_type eq 1><!--- Eğitim talepleri katalog/katalog dışı--->
									<td>
										<cfif get_training_requests.request_type eq 1>
											<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_dsp_training_request_form&train_req_id=#TRAIN_REQUEST_ID#','medium')" class="tableyazi">#training_name# (Katalog)</a>--->
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#fusebox.circuit#.list_class_requests&event=upd&train_req_id=#TRAIN_REQUEST_ID#','medium')" class="tableyazi">#training_name# (<cf_get_lang dictionary_id='59154.Katalog'>)</a>	
										<cfelseif get_training_requests.request_type eq 2>						
											<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_dsp_training_request_form&train_req_id=#TRAIN_REQUEST_ID#','medium')" class="tableyazi">#other_train_name# (Katalog Dışı)</a>--->
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#fusebox.circuit#.list_class_requests&event=upd&train_req_id=#TRAIN_REQUEST_ID#','medium')" class="tableyazi">#other_train_name# (<cf_get_lang dictionary_id='31102.Katalog Dışı'>)</a>
										</cfif>
									</td>
								<cfelseif attributes.request_type eq 2><!--- yıllık eğitim talepleri--->
									<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#fusebox.circuit#.popup_form_upd_training_request_annual&train_req_id=#TRAIN_REQUEST_ID#','medium')" class="tableyazi">#training_name#</a></td>
								</cfif>
								<cfif attributes.request_type eq 2><td>#request_year#</td></cfif>
								<cfif attributes.request_type neq 3 and attributes.request_type neq 4><td>#get_content_process_stage.stage[listfind(stage_id_list,process_stage,',')]#</td></cfif>
								<td>#dateformat(record_date,dateformat_style)#</td>
								<cfif attributes.request_type eq 3 or attributes.request_type eq 4>
								<td width="70" align="center"><cfif hr_valid neq 1 and hr_valid neq 0><input type="checkbox" name="row_demand_accept" id="row_demand_accept" value="#EMPLOYEE_ID#;#class_id#;ac" onchange="check_dec_control(this, '#EMPLOYEE_ID#;#class_id#;de');"></cfif></td>
								<td width="75" align="center"><cfif hr_valid neq 1 and hr_valid neq 0><input type="checkbox" name="row_demand_decline" id="row_demand_decline" value="#EMPLOYEE_ID#;#class_id#;de" onchange="check_ac_control(this, '#EMPLOYEE_ID#;#class_id#;ac');"></cfif></td>
								<td><cfif hr_valid eq 1>Onaylandı<cfelseif hr_valid eq 0>Reddedildi</cfif></td></cfif>
								<cfif attributes.request_type eq 3 or attributes.request_type eq 4>
									<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_form_upd_class_join_request&request_id=#REQUEST_ROW_ID#','small');" ><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='46167.Ayrıntılar'>"></i></a></td>
								<cfelseif attributes.request_type eq 1><!--- Eğitim talepleri katalog/katalog dışı--->
									<td>
										<cfif get_training_requests.request_type eq 1>
											<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_dsp_training_request_form&train_req_id=#TRAIN_REQUEST_ID#','medium')" class="tableyazi">#training_name# (Katalog)</a>--->
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#fusebox.circuit#.list_class_requests&event=upd&train_req_id=#TRAIN_REQUEST_ID#','medium')" class="tableyazi"><i class="fa fa-pencil" title="#getLang('','Güncelle',57464)#"></i></a>	
										<cfelseif get_training_requests.request_type eq 2>						
											<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_dsp_training_request_form&train_req_id=#TRAIN_REQUEST_ID#','medium')" class="tableyazi">#other_train_name# (Katalog Dışı)</a>--->
											<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#fusebox.circuit#.list_class_requests&event=upd&train_req_id=#TRAIN_REQUEST_ID#','medium')" class="tableyazi"><i class="fa fa-pencil" title="#getLang('','Güncelle',57464)#"></i></a>
										</cfif>
									</td>
								<cfelseif attributes.request_type eq 2><!--- yıllık eğitim talepleri--->
									<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=#fusebox.circuit#.popup_form_upd_training_request_annual&train_req_id=#TRAIN_REQUEST_ID#','medium')" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id ='46167.Ayrıntılar'>"></i></a></td>
								</cfif>
							</tr>
						</cfoutput>
					</tbody>
					<cfif attributes.request_type eq 3 or attributes.request_type eq 4> 
					<tfoot>
						<tr height="25">
							<td colspan="9" style="text-align:right;">
								<input type="button" name="mail" id="mail" value="<cf_get_lang dictionary_id='57461.Kaydet'>" onclick="KatilimciDurumuKaydet();">
								<input type="hidden" name="id_list" id="id_list" value="">
								<input type="hidden" name="katilimci_kaydet" id="katilimci_kaydet" value="">
							</td>
						</tr>
					</tfoot></cfif>
				<cfelse>
					<tbody>
						<tr> 
							<td colspan="9"><cfif isdefined('attributes.is_submitted') and attributes.is_submitted eq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
						</tr>
					</tbody>
				</cfif>
			</cf_grid_list>
		</cfform>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr> 
					<td height="35">
						<cf_pages 
						page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="training_management.list_class_requests#url_str#"> 
					</td>
					<!-- sil -->
					<td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
				</tr>
			</table>
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function deselectAll(i){
		if (i == 1){
			if (document.train_reqs.allSelectDecs.checked == true){
				document.train_reqs.allSelecthemand.checked = false;
				if(document.getElementsByName('row_demand_accept').length > 0){
					for (i=0;i<document.getElementsByName('row_demand_accept').length;i++){
						document.train_reqs.row_demand_accept[i].checked = false;	
					}
				}
			}
		} else {
			if (document.train_reqs.allSelecthemand.checked == true){
				document.train_reqs.allSelectDecs.checked = false;
				if(document.getElementsByName('row_demand_decline').length > 0){
					for (i=0;i<document.getElementsByName('row_demand_decline').length;i++){
						document.train_reqs.row_demand_decline[i].checked = false;	
					}
				}
			}
		}
	}
	function check_dec_control(cmp, vl){
		if (cmp.checked){
			if(document.getElementsByName('row_demand_decline').length > 0){
				if(document.getElementsByName('row_demand_decline').length ==1){
					if(document.getElementById('row_demand_decline').value==vl){
						document.getElementById('row_demand_decline').checked = false;
					}
				} else {
					for (i=0;i<document.getElementsByName('row_demand_decline').length;i++){
						if(document.train_reqs.row_demand_decline[i].value==vl){ 
							document.train_reqs.row_demand_decline[i].checked = false;	
						}
					}
				}
			}
		}
	}
	function check_ac_control(cmp, vl){
		if (cmp.checked){
			if(document.getElementsByName('row_demand_accept').length > 0){
				if(document.getElementsByName('row_demand_accept').length ==1){
					if(document.getElementById('row_demand_accept').value==vl){
						document.getElementById('row_demand_accept').checked = false;
					}
				} else {
					for (i=0;i<document.getElementsByName('row_demand_accept').length;i++){
						if(document.train_reqs.row_demand_accept[i].value==vl){ 
							document.train_reqs.row_demand_accept[i].checked = false;	
						}
					}
				}
			}
		}
	}
	function KatilimciDurumuKaydet(){
		var is_selected=0;
		if(document.getElementsByName('row_demand_accept').length > 0){
			var id_list="";
			if(document.getElementsByName('row_demand_accept').length ==1){
				if(document.getElementById('row_demand_accept').checked==true){
					is_selected=1;
					id_list+=document.train_reqs.row_demand_accept.value+',';
				}
			} else {
				for (i=0;i<document.getElementsByName('row_demand_accept').length;i++){
					if(document.train_reqs.row_demand_accept[i].checked==true){ 
						id_list+=document.train_reqs.row_demand_accept[i].value+',';
						is_selected=1;	
					}
				}
			}
		}
		if(document.getElementsByName('row_demand_decline').length > 0){
			if(document.getElementsByName('row_demand_decline').length ==1){
				if(document.getElementById('row_demand_decline').checked==true){
					is_selected=1;
					id_list+=document.train_reqs.row_demand_decline.value+',';
				}
			} else {
				for (i=0;i<document.getElementsByName('row_demand_decline').length;i++){
					if(document.train_reqs.row_demand_decline[i].checked==true){ 
						id_list+=document.train_reqs.row_demand_decline[i].value+',';
						is_selected=1;	
					}
				}
			}
		}
		if(is_selected==1){
			if(list_len(id_list,',') > 1){
				id_list = id_list.substr(0,id_list.length-1);
				document.getElementById('id_list').value=id_list;
				document.getElementById('katilimci_kaydet').value=1;
				katilimci_kaydet_ = document.getElementById('katilimci_kaydet').value;
				if(confirm("<cf_get_lang dictionary_id='57535.Kaydetmek İstediğinizden Emin Misiniz?'> ?")){
					train_reqs.action='<cfoutput>#request.self#?fuseaction=training_management.emptypopup_add_reqs_attenders&fsactn=training_management.list_class_requests#url_str#</cfoutput>&id_list='+document.getElementById('id_list').value;
					train_reqs.submit();
				}
			}
		} else {
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='29780.Katılımcı'>");
			return false;
		}
	}
</script>
