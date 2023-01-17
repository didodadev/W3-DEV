<cfinclude template="../../header.cfm">

<cfquery name="GET_UNITS" datasource="#dsn#">
	SELECT #dsn#.Get_Dynamic_Language(REFINERY_UNIT_ID,'#session.ep.language#','REFINERY_TEST_UNITS','UNIT_NAME',NULL,NULL,UNIT_NAME) AS UNIT_NAME,* FROM REFINERY_TEST_UNITS WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="GET_GROUPS" datasource="#dsn#">
	SELECT #dsn#.Get_Dynamic_Language(REFINERY_GROUP_ID,'#session.ep.language#','REFINERY_GROUPS','GROUP_NAME',NULL,NULL,GROUP_NAME) AS GROUP_NAME,* FROM REFINERY_GROUPS WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="GET_TEST_PARAMETERS" datasource="#DSN#">
	SELECT REFINERY_TEST_PARAMETERS.*,#dsn#.Get_Dynamic_Language(REFINERY_TEST_PARAMETERS.REFINERY_TEST_PARAMETER_ID,'#session.ep.language#','REFINERY_TEST_PARAMETERS','PARAMETER_NAME',NULL,NULL,REFINERY_TEST_PARAMETERS.PARAMETER_NAME) AS PARAMETER_NAME_ FROM REFINERY_TEST_PARAMETERS
	LEFT JOIN REFINERY_GROUPS ON REFINERY_GROUPS.REFINERY_GROUP_ID = REFINERY_TEST_PARAMETERS.GROUP_ID AND REFINERY_GROUPS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	WHERE REFINERY_TEST_PARAMETERS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY REFINERY_GROUPS.GROUP_NAME, PARAMETER_NAME
</cfquery>
<cfquery name="GET_TEST_METHODS" datasource="#DSN#">
	SELECT *,#dsn#.Get_Dynamic_Language(REFINERY_TEST_METHOD_ID,'#session.ep.language#','REFINERY_TEST_METHODS','TEST_METHOD_NAME',NULL,NULL,TEST_METHOD_NAME) AS TEST_METHOD_NAME_ FROM REFINERY_TEST_METHODS WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>
<cfquery name="GET_ANALYZE_CAT" datasource="#DSN#">
	SELECT *,#dsn#.Get_Dynamic_Language(ANALYZE_CAT_ID,'#session.ep.language#','REFINERY_ANALYZE_CAT','ANALYZE_CAT_NAME',NULL,NULL,ANALYZE_CAT_NAME) AS ANALYZE_CAT_NAME_ FROM REFINERY_ANALYZE_CAT WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
</cfquery>

<cfoutput>
	<div class="row">
		<cfform name="analyzeUnitsForm" id="analyzeUnitsForm">
			<input type="hidden" name="parameterType" id="parameterType" value="unit">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box id="unit" title="#getLang('','Birimler',55217)#">
					<input type="hidden" name="unit_count" id="unit_count" value="<cfoutput>#GET_UNITS.recordCount#</cfoutput>">
					<cf_grid_list sort="0">
						<thead>
							<th width="30"><a href="javascript://" onclick="addUnit()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
							<th><cf_get_lang dictionary_id='37190.Birim Adı'></th>
							<th width="30"></th>
						</thead>
						<tbody>
							<cfloop query="GET_UNITS">
								<tr id="unit_#currentrow#">
									<td><a style="cursor:pointer" onclick="removeItem('unit_#currentrow#')" ><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="unitId#currentrow#" id="unitId#currentrow#" value="#REFINERY_UNIT_ID#">
												<input type="hidden" class="deleted" name="unitDeleted#currentrow#" id="unitDeleted#currentrow#" value="0">
												<input type="text" name="unitName#currentrow#" id="unitName#currentrow#" value="#UNIT_NAME#">
												<span class="input-group-addon">
													<cf_language_info
														table_name="REFINERY_TEST_UNITS"
														column_name="UNIT_NAME" 
														column_id_value="#REFINERY_UNIT_ID#" 
														maxlength="500" 
														datasource="#dsn#" 
														column_id="REFINERY_UNIT_ID" 
														control_type="0">
												</span>
											</div>
										</div>
									</td>
									<td class="text-center"><input type="checkbox" name="unitStatus#currentrow#" id="unitStatus#currentrow#" value="1" <cfif UNIT_STATUS eq 1>checked</cfif>></td>
								</tr>
							</cfloop>
						</tbody>
					</cf_grid_list>
					<cf_box_footer>
						<cf_workcube_buttons>
					</cf_box_footer>
				</cf_box>
			</div>
		</cfform>
		<cfform name="analyzeGroupsForm" id="analyzeGroupsForm">
			<input type="hidden" name="parameterType" id="parameterType" value="group">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box id="group" title="#getLang('','Gruplar',32716)#">
					<input type="hidden" name="group_count" id="group_count" value="<cfoutput>#GET_GROUPS.recordCount#</cfoutput>">
					<cf_grid_list sort="0">
						<thead>
							<th width="30"><a href="javascript://" onclick="addGroup()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
							<th><cf_get_lang dictionary_id='58969.Grup Adı'></th>
							<th width="30"></th>
						</thead>
						<tbody>
							<cfloop query="GET_GROUPS">
								<tr id="group_#currentrow#">
									<td><a style="cursor:pointer" onclick="removeItem('group_#currentrow#')" ><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="groupId#currentrow#" id="groupId#currentrow#" value="#REFINERY_GROUP_ID#">
												<input type="hidden" class="deleted" name="groupDeleted#currentrow#" id="groupDeleted#currentrow#" value="0">
												<input type="text" name="groupName#currentrow#" id="groupName#currentrow#" value="#GROUP_NAME#">
												<span class="input-group-addon">
													<cf_language_info
														table_name="REFINERY_GROUPS"
														column_name="GROUP_NAME" 
														column_id_value="#REFINERY_GROUP_ID#" 
														maxlength="500" 
														datasource="#dsn#" 
														column_id="REFINERY_GROUP_ID" 
														control_type="0">
												</span>
											</div>
										</div>
									</td>
									<td class="text-center">
										<input type="checkbox" name="groupStatus#currentrow#" id="groupStatus#currentrow#" value="1" <cfif GROUP_STATUS eq 1>checked</cfif>>
									</td>
								</tr>
							</cfloop>
						</tbody>
					</cf_grid_list>
					<cf_box_footer>
						<cf_workcube_buttons>
					</cf_box_footer>
				</cf_box>
			</div>
		</cfform>
		<cfform name="analyzeParametersForm" id="analyzeParametersForm">
			<input type="hidden" name="parameterType" id="parameterType" value="parameter">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box id="parameter" title="#getLang('','Parametreler',57693)#">
					<input type="hidden" name="parameter_count" id="parameter_count" value="<cfoutput>#GET_TEST_PARAMETERS.recordCount#</cfoutput>">
					<cf_grid_list sort="0">
						<thead>
							<tr>
								<th width="30"><a href="javascript://" onclick="addParameter()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
								<th width="300"><cf_get_lang dictionary_id='58969.Grup Adı'></th>
								<th width="300"><cf_get_lang dictionary_id='62145.Parametre Adı'></th>
								<th width="300"><cf_get_lang dictionary_id='43420.Min Limit'></th>
								<th width="300"><cf_get_lang dictionary_id='43421.Max Limit'></th>
								<th width="30"></th>
							</tr>
						</thead>
						<tbody>
							<cfif GET_TEST_PARAMETERS.recordCount>
								<cfloop query="GET_TEST_PARAMETERS">
									<tr id="parameter_#currentrow#">
										<td><a style="cursor:pointer" onclick="removeItem('parameter_#currentrow#')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
										<td>
											<div class="form-group">
												<select name="groupId#currentrow#" id="groupId#currentrow#">
													<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
													<cfif GET_GROUPS.recordCount>
														<cfloop query="#GET_GROUPS#">
															<option value='#REFINERY_GROUP_ID#' #REFINERY_GROUP_ID eq GET_TEST_PARAMETERS.GROUP_ID ? 'selected' : ''#>#GROUP_NAME#</option>
														</cfloop>
													</cfif>
												</select>
											</div>
										</td>
										<td>
											<div class="form-group">
												<div class="input-group">
													<input type="hidden" name="parameterId#currentrow#" id="parameterId#currentrow#" value="#REFINERY_TEST_PARAMETER_ID#">
													<input type="hidden" class="deleted" name="parameterDeleted#currentrow#" id="parameterDeleted#currentrow#" value="0">
													<input type="text" name="parameterName#currentrow#" id="parameterName#currentrow#" value="#PARAMETER_NAME_#" required>
													<span class="input-group-addon">
														<cf_language_info
															table_name="REFINERY_TEST_PARAMETERS"
															column_name="PARAMETER_NAME" 
															column_id_value="#REFINERY_TEST_PARAMETER_ID#" 
															maxlength="500" 
															datasource="#dsn#" 
															column_id="REFINERY_TEST_PARAMETER_ID" 
															control_type="0">
													</span>
												</div>
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="minLimit#currentrow#" id="minLimit#currentrow#" onkeyup="return(FormatCurrency(this,event));" value="#TLFormat(MIN_LIMIT,4)#">
											</div>
										</td>
										<td>
											<div class="form-group">
												<input type="text" name="maxLimit#currentrow#" id="maxLimit#currentrow#" onkeyup="return(FormatCurrency(this,event));" value="#TLFormat(MAX_LIMIT,4)#">
											</div>
										</td>
										<td class="text-center"><input type="checkbox" name="parameterStatus#currentrow#" id="parameterStatus#currentrow#" value="1" <cfif PARAMETER_STATUS eq 1>checked</cfif>></td>
									</tr>
								</cfloop>
							</cfif>
						</tbody>
					</cf_grid_list>
					<cf_box_footer>
						<cf_workcube_buttons add_function="kontrol()">
					</cf_box_footer>
				</cf_box>
			</div>
		</cfform>
		<cfform name="analyzeMethodForm" id="analyzeParamsForm">
			<input type="hidden" name="parameterType" id="parameterType" value="method">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box id="method" title="#getLang('','Test Metodları',62143)#">
					<input type="hidden" name="method_count" id="method_count" value="<cfoutput>#GET_TEST_METHODS.recordCount#</cfoutput>">
					<cf_grid_list sort="0">
						<thead>
							<tr>
								<th width="30"><a href="javascript://" onclick="addMethod()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
								<th width="300"><cf_get_lang dictionary_id='58969.Grup Adı'></th>
								<th width="300"><cf_get_lang dictionary_id='62145.Parametre Adı'></th>
								<th width="300"><cf_get_lang dictionary_id='62144.Method Adı'></th>
								<th width="30"></th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="GET_TEST_METHODS">
								<cfquery name="GET_TEST_PARAMETERS_BY_GROUP" dbtype="query">
									SELECT * FROM GET_TEST_PARAMETERS WHERE GROUP_ID = #GET_TEST_METHODS.REFINERY_GROUP_ID# ORDER BY PARAMETER_NAME ASC
								</cfquery>
								<tr id="method_#currentrow#">
									<td><a style="cursor:pointer" onclick="removeItem('method_#currentrow#')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
									<td>
										<div class="form-group">
											<select name="groupId#currentrow#" id="groupId#currentrow#" onchange="getItem('group',#currentrow#,this)">
												<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
												<cfif GET_GROUPS.recordCount>
													<cfloop query="#GET_GROUPS#">
														<option value='#REFINERY_GROUP_ID#' #REFINERY_GROUP_ID eq GET_TEST_METHODS.REFINERY_GROUP_ID ? 'selected' : ''#>#GROUP_NAME#</option>
													</cfloop>
												</cfif>
											</select>
										</div>
									</td>
									<td>
										<div class="form-group">
											<select name="parameterId#currentrow#" id="parameterId#currentrow#">
												<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
												<cfif GET_TEST_PARAMETERS_BY_GROUP.recordCount>
													<cfloop query="#GET_TEST_PARAMETERS_BY_GROUP#">
														<option value='#REFINERY_TEST_PARAMETER_ID#' #REFINERY_TEST_PARAMETER_ID eq GET_TEST_METHODS.REFINERY_TEST_PARAMETER_ID ? 'selected' : ''#>#PARAMETER_NAME_#</option>
													</cfloop>
												</cfif>
											</select>
										</div>
									</td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="methodId#currentrow#" id="methodId#currentrow#" value="#REFINERY_TEST_METHOD_ID#">
												<input type="hidden" class="deleted" name="methodDeleted#currentrow#" id="methodDeleted#currentrow#" value="0">
												<input type="text" name="methodName#currentrow#" id="methodName#currentrow#" value="#TEST_METHOD_NAME_#">
												<span class="input-group-addon">
													<cf_language_info
														table_name="REFINERY_TEST_METHODS"
														column_name="TEST_METHOD_NAME" 
														column_id_value="#REFINERY_TEST_METHOD_ID#" 
														maxlength="500" 
														datasource="#dsn#" 
														column_id="REFINERY_TEST_METHOD_ID" 
														control_type="0">
												</span>
											</div>
										</div>
									</td>
									<td class="text-center"><input type="checkbox" name="methodStatus#currentrow#" id="methodStatus#currentrow#" value="1" <cfif TEST_METHOD_STATUS eq 1>checked</cfif>></td>
								</tr>
							</cfloop>
						</tbody>
					</cf_grid_list>
					<cf_box_footer>
						<cf_workcube_buttons>
					</cf_box_footer>
				</cf_box>
			</div>
		</cfform>
		<cfform name="analyzeCat" id="analyzeCat">
			<input type="hidden" name="parameterType" id="parameterType" value="analyzeCat">
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box id="analyzeCats" title="#getLang('','Analiz Kategorileri',62176)#">
					<input type="hidden" name="analyzeCat_count" id="analyzeCat_count" value="<cfoutput>#GET_ANALYZE_CAT.recordCount#</cfoutput>">
					<cf_grid_list sort="0">
						<thead>
							<th width="30"><a href="javascript://" onclick="addAnalyzeCat()"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
							<th><cf_get_lang dictionary_id='37163.Kategori Adı'></th>
							<th width="30"></th>
						</thead>
						<tbody>
							<cfloop query="GET_ANALYZE_CAT">
								<tr id="analyzeCat_#currentrow#">
									<td><a style="cursor:pointer" onclick="removeItem('analyzeCat_#currentrow#')" ><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
									<td>
										<div class="form-group">
											<div class="input-group">
												<input type="hidden" name="analyzeCatId#currentrow#" id="analyzeCatId#currentrow#" value="#ANALYZE_CAT_ID#">
												<input type="hidden" class="deleted" name="analyzeCatDeleted#currentrow#" id="analyzeCatDeleted#currentrow#" value="0">
												<input type="text" name="analyzeCatName#currentrow#" id="analyzeCatName#currentrow#" value="#ANALYZE_CAT_NAME_#">
												<span class="input-group-addon">
													<cf_language_info
														table_name="REFINERY_ANALYZE_CAT"
														column_name="ANALYZE_CAT_NAME" 
														column_id_value="#ANALYZE_CAT_ID#" 
														maxlength="500" 
														datasource="#dsn#" 
														column_id="ANALYZE_CAT_ID" 
														control_type="0">
												</span>
											</div>
										</div>
									</td>
									<td class="text-center">
										<input type="checkbox" name="analyzeCatStatus#currentrow#" id="analyzeCatStatus#currentrow#" value="1" <cfif ANALYZE_CAT_STATUS eq 1>checked</cfif>>
									</td>
								</tr>
							</cfloop>
						</tbody>
					</cf_grid_list>
					<cf_box_footer>
						<cf_workcube_buttons>
					</cf_box_footer>
				</cf_box>
			</div>
		</cfform>
	</div>
</cfoutput>

<script type="text/javascript">
	function addUnit(){
		$("#unit_count").val( parseInt($("#unit_count").val()) + 1 );
		rowNum = parseInt($("#unit_count").val());
		$("<tr>").attr({"id":"unit_"+rowNum+""}).html('<td><a style="cursor:pointer" onclick="removeItem(\'unit_'+rowNum+'\')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td><td><div class="form-group"><input type="hidden" name="unitId'+rowNum+'" id="unitId'+rowNum+'"><input type="hidden" class="deleted" name="unitDeleted'+rowNum+'" id="unitDeleted'+rowNum+'" value="0"><input type="text" name="unitName'+rowNum+'" id="unitName'+rowNum+'"></div></td><td class="text-center"><input type="checkbox" name="unitStatus'+rowNum+'" id="unitStatus'+rowNum+'" value="1" checked></td>').appendTo($("#body_unit tbody"));
	}
	function addGroup(){
		$("#group_count").val( parseInt($("#group_count").val()) + 1 );
		rowNum = parseInt($("#group_count").val());
		$("<tr>").attr({"id":"group_"+rowNum+""}).html('<td><a style="cursor:pointer" onclick="removeItem(\'group_'+rowNum+'\')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td><td><div class="form-group"><input type="hidden" name="groupId'+rowNum+'" id="groupId'+rowNum+'"><input type="hidden" class="deleted" name="groupDeleted'+rowNum+'" id="groupDeleted'+rowNum+'" value="0"><input type="text" name="groupName'+rowNum+'" id="groupName'+rowNum+'"></div></td><td class="text-center"><input type="checkbox" name="groupStatus'+rowNum+'" id="groupStatus'+rowNum+'" value="1" checked></td>').appendTo($("#body_group tbody"));
	}
	function addParameter(){
		$("#parameter_count").val( parseInt($("#parameter_count").val()) + 1 );
		rowNum = parseInt($("#parameter_count").val());
		$("<tr>").attr({"id":"parameter_"+rowNum+""}).html('<td><a style="cursor:pointer" onclick="removeItem(\'parameter_'+rowNum+'\')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td><td><div class="form-group"><input type="hidden" name="parameterId'+rowNum+'" id="parameterId'+rowNum+'"><input type="hidden" class="deleted" name="parameterDeleted'+rowNum+'" id="parameterDeleted'+rowNum+'" value="0"><select name="groupId'+rowNum+'" id="groupId'+rowNum+'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfif GET_GROUPS.recordCount><cfoutput query="GET_GROUPS"><option value="#REFINERY_GROUP_ID#">#GROUP_NAME#</option></cfoutput></cfif></select></div></td><td><div class="form-group"><input type="text" name="parameterName'+rowNum+'" id="parameterName'+rowNum+'"></div></td><td><div class="form-group"><input type="text" name="minLimit'+rowNum+'" id="minLimit'+rowNum+'" onkeyup="return(FormatCurrency(this,event));"></div></td><td><div class="form-group"><input type="text" name="maxLimit'+rowNum+'" id="maxLimit'+rowNum+'" onkeyup="return(FormatCurrency(this,event));"></div></td><td class="text-center"><input type="checkbox" name="parameterStatus'+rowNum+'" id="parameterStatus'+rowNum+'" value="1" checked></td>').appendTo($("#body_parameter tbody"));
	}
	function addMethod(){
		$("#method_count").val( parseInt($("#method_count").val()) + 1 );
		rowNum = parseInt($("#method_count").val());
		$("<tr>").attr({"id":"method_"+rowNum+""}).html('<td><a style="cursor:pointer" onclick="removeItem(\'method_'+rowNum+'\')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td><td><div class="form-group"><input type="hidden" name="methodId'+rowNum+'" id="methodId'+rowNum+'"><input type="hidden" class="deleted" name="methodDeleted'+rowNum+'" id="methodDeleted'+rowNum+'" value="0"><select name="groupId'+rowNum+'" id="groupId'+rowNum+'" onchange="getItem(\'group\','+rowNum+',this)"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfif GET_GROUPS.recordCount><cfoutput query="GET_GROUPS"><option value="#REFINERY_GROUP_ID#">#GROUP_NAME#</option></cfoutput></cfif></select></div></td><td><div class="form-group"><select name="parameterId'+rowNum+'" id="parameterId'+rowNum+'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option></select></div></td><td><div class="form-group"><input type="text" name="methodName'+rowNum+'" id="methodName'+rowNum+'"></div></td><td class="text-center"><input type="checkbox" name="methodStatus'+rowNum+'" id="methodStatus'+rowNum+'" value="1" checked></td>').appendTo($("#body_method tbody"));
	}
	function addAnalyzeCat(){
		$("#analyzeCat_count").val( parseInt($("#analyzeCat_count").val()) + 1 );
		rowNum = parseInt($("#analyzeCat_count").val());
		$("<tr>").attr({"id":"analyzeCat_"+rowNum+""}).html('<td><a style="cursor:pointer" onclick="removeItem(\'analyzeCat_'+rowNum+'\')"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td><td><div class="form-group"><input type="hidden" name="analyzeCatId'+rowNum+'" id="analyzeCatId'+rowNum+'"><input type="hidden" class="deleted" name="analyzeCatDeleted'+rowNum+'" id="analyzeCatDeleted'+rowNum+'" value="0"><input type="text" name="analyzeCatName'+rowNum+'" id="analyzeCatName'+rowNum+'"></div></td><td class="text-center"><input type="checkbox" name="analyzeCatStatus'+rowNum+'" id="analyzeCatStatus'+rowNum+'" value="1" checked></td>').appendTo($("#body_analyzeCats tbody"));
	}
	function removeItem(row_id) {
		if(confirm( "<cf_get_lang dictionary_id='62142.Silmek istediğinize emin misiniz?'>" )) $("tr#"+row_id+"").hide().find(".deleted").val(1);
	}

	function getItem(item, row_id, element) {    
		if( item == 'group' ){

			$( "#analyzeParamsForm #parameterId"+ row_id +"" ).html($("<option>").attr({"value":""}).text("<cf_get_lang dictionary_id='57734.Seçiniz'>"));
			$( "#analyzeParamsForm #methodId"+ row_id +"" ).html($("<option>").attr({"value":""}).text("<cf_get_lang dictionary_id='57734.Seçiniz'>"));
			$( "#analyzeParamsForm #minLimit"+ row_id +", #analyzeParamsForm #maxLimit"+ row_id +"" ).val('');

			if( element.value != "" ){

				var data = new FormData();
				data.append("group_id", element.value);
				AjaxControlPostDataJson( 'WBP/Recycle/files/sample_analysis/cfc/analysis_parameters.cfc?method=getParameter', data, function(response) {
					if( response.length > 0 ){
						response.forEach((e) => {
							$("<option>").attr({"value":e.REFINERY_TEST_PARAMETER_ID}).text(e.PARAMETER_NAME).appendTo( $( "#analyzeParamsForm #parameterId"+ row_id +"" ) );
						});
					}
				} );
			}
		}
	}

	function kontrol() {
		unformat_fields();
		return true;
	}

	function unformat_fields()
    {
        
        if( analyzeParametersForm.parameter_count.value != '' && parseInt(analyzeParametersForm.parameter_count.value) > 0 ){
            for (i = 1; i <= parseInt(analyzeParametersForm.parameter_count.value); i++) {
                if( $("#minLimit"+i+"") != 'undefined' && $("#minLimit"+i+"").val() != '' ) $("#minLimit"+i+"").val( filterNum( $("#minLimit"+i+"").val() ) );
                if( $("#maxLimit"+i+"") != 'undefined' && $("#maxLimit"+i+"").val() != '' ) $("#maxLimit"+i+"").val( filterNum( $("#maxLimit"+i+"").val() ) );
            }
        }

    }

</script>