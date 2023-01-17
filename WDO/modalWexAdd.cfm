<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.process_cat" default="">

<cfset list_wbo = createObject("component", "development.cfc.list_wbo")>
<cfset WBO_TYPES = list_wbo.getWboList()>
<cfset process_type_list = list_wbo.getProcessTypes()>
<cfset getSolution = list_wbo.getSolution()>

<cfset wex = createObject("component", "development.cfc.wex")>
<cfset get_wex = wex.select(
	wex_id      :   '#IIf(isdefined("attributes.wxid") and len(attributes.wxid),"attributes.wxid",DE(-1))#'
)>
<cfif isdefined("attributes.wxid") and len(attributes.wxid)>
	<cfset wex_authorization = createObject("component","V16.objects.cfc.wex_authorization")>
	<cfset get_wex_authorization_list = wex_authorization.select(wex_id:attributes.wxid)>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfform name="WexForm" method="post" action="" enctype="multipart/form-data">
	<cfif ( isDefined("attributes.restName") and isDefined("attributes.filePath") ) or len(get_wex.DATA_CONVERTER)>
		<textarea name="convert_json" id="convert_json" style="display:none;" ></textarea>
	</cfif>
	<cfif isdefined("attributes.wxid") and len(attributes.wxid)>
		<cfinput name = "wxid" type = "hidden" value = "#attributes.wxid#">
	</cfif>
	<cf_box title="WEX" id="wexAdd" closable="0">
		<cf_box_elements>
			<div class="col col-4 col-xs-12">
				<div class="form-group">
					<label class="col col-4 col-xs-12">Head*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfoutput>
								<input type="text" name="head" id="head" value="#get_wex.HEAD#" required>
								<input type="hidden" name="dictionary_id"  id="dictionary_id" value="#get_wex.DICTIONARY_ID#">
								<span class="input-group-addon icon-ellipsis"<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=settings.popup_list_lang_settings&module_name=dev&is_use_send&lang_dictionary_id=WexForm.dictionary_id&lang_item_name=WexForm.head','list');return false">
								</span>
							</cfoutput>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Solution*</label>
					<div class="col col-8 col-xs-12">
						<select id="solution" name="solution" onchange="loadFamilies(this.value,'family','module')" required>
							<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
							<cfoutput query="getSolution">
								<option value="#WRK_SOLUTION_ID#" <cfif get_wex.WRK_SOLUTION_ID eq WRK_SOLUTION_ID>selected</cfif>>#NAME#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Family*</label>
					<div class="col col-8 col-xs-12">
						<select id="family" name="family" onchange="loadModules(this.value,'module')" required>
							<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
							<cfif isdefined("attributes.wxid")>
								<cfquery name="getFamily" datasource="#dsn#">
									SELECT
										WRK_FAMILY_ID,
										ISNULL(SL.ITEM_#session.ep.language#,WF.FAMILY) AS FAMILY,
										FAMILY_DICTIONARY_ID
									FROM
										WRK_FAMILY WF
										LEFT JOIN SETUP_LANGUAGE_TR SL ON WF.FAMILY_DICTIONARY_ID = SL.DICTIONARY_ID
									WHERE
										WF.WRK_SOLUTION_ID = #get_wex.WRK_SOLUTION_ID#
									ORDER BY
										ISNULL(SL.ITEM_#session.ep.language#,WF.FAMILY)
								</cfquery>
								<cfoutput query = "getFamily">
								<option value="#WRK_FAMILY_ID#" <cfif get_wex.WRK_FAMILY_ID eq WRK_FAMILY_ID>selected</cfif>>#FAMILY#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Module*</label>
					<div class="col col-8 col-xs-12">
						<select id="module" name="module" required>
							<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
							<cfif isdefined("attributes.wxid")>
								<cfquery name="getModule" datasource="#dsn#">
									SELECT
										M.MODULE_NO,
										ISNULL(SL.ITEM_#session.ep.language#,M.MODULE) AS MODULE,
										MODULE_DICTIONARY_ID
									FROM
										WRK_MODULE M
										LEFT JOIN SETUP_LANGUAGE_TR SL ON M.MODULE_DICTIONARY_ID = SL.DICTIONARY_ID
									WHERE
										M.FAMILY_ID = #get_wex.WRK_FAMILY_ID#
									ORDER BY
										ISNULL(SL.ITEM_#session.ep.language#,M.MODULE)
								</cfquery>
								<cfoutput query = "getModule">
								<option value="#MODULE_NO#" <cfif get_wex.MODULE_NO eq MODULE_NO>selected</cfif>>#MODULE#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Related WO</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfinput type="text" name="related_wo" id="related_wo" value="#get_wex.RELATED_WO#">
							<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=process.popup_dsp_faction_list&field_name=WexForm.related_wo&is_upd=0&choice=1','list');return false;"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Image*</label>
					<div class="col col-8 col-xs-12">
						<cfif len(get_wex.IMAGE)>
							<cfinput type="hidden" name="oldFile" value="#get_wex.IMAGE#">
							<cf_get_server_file output_file="#get_wex.IMAGE#" output_server="#fusebox.server_machine#" output_type="6" image_link="1">
						</cfif>
						<input type="file" name="image" id="image" accept="image/png, image/jpeg" <cfif len(get_wex.IMAGE) eq 0></cfif>>
					</div>
				</div>
			</div><!--- col --->
			<div class="col col-4 col-xs-12">
				<div class="form-group">
					<label class="col col-4 col-xs-12">Type*</label>
					<div class="col col-8 col-xs-12">
						<select id="type" name="type" required>
							<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
							<option value="1" <cfif get_wex.TYPE eq 1>selected</cfif>>Export</option>
							<option value="2" <cfif get_wex.TYPE eq 2>selected</cfif>>Import</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Licence*</label>
					<div class="col col-8 col-xs-12">
						<select id="licence" name="licence" required>
							<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
							<option value="1" <cfif get_wex.LICENCE eq 1>selected</cfif>>Standart</option>
							<option value="2" <cfif get_wex.LICENCE eq 2>selected</cfif>>Add-On</option>
							<option value="3" <cfif get_wex.LICENCE eq 3>selected</cfif>>Free</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Rest Name*</label>
					<div class="col col-8 col-xs-12">
						<cfoutput>
							<input type="text" name="rest_name" id="rest_name" value="#( isDefined("attributes.restName") and isDefined("attributes.filePath") ) ? attributes.restName : get_wex.REST_NAME#" required>
						</cfoutput>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Source WO</label>
					<div class="col col-8 col-xs-12">
						<cfoutput>
							<input type="text" name="source_wo" id="source_wo" value="<cfoutput><cfif isdefined('attributes.source_wo') and len(attributes.source_wo)>#attributes.source_wo#<cfelse>#get_wex.source_wo#</cfif></cfoutput>">
						</cfoutput>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">File Path*</label>
					<div class="col col-8 col-xs-12">
						<cfoutput>
							<input type="text" name="file_path" id="file_path" value="<cfoutput><cfif isDefined("attributes.restName") and isDefined("attributes.filePath")>#Replace(attributes.filePath,'.','/','All')#.cfc<cfelseif isdefined('attributes.source_file_path') and len(attributes.source_file_path)>#attributes.source_file_path#<cfelse>#get_wex.FILE_PATH#</cfif></cfoutput>" required>
						</cfoutput>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">WEX File ID</label>
					<div class="col col-8 col-xs-12">
						<cfoutput>
							<input type="text" name="wex_file_id" id="wex_file_id" value="<cfoutput><cfif isdefined('attributes.wex_file_id') and len(attributes.wex_file_id)>#attributes.wex_file_id#<cfelse>#get_wex.wex_file_id#</cfif></cfoutput>">
						</cfoutput>
					</div>
				</div>
			</div><!--- col --->
			<div class="col col-4 col-xs-12">
				<div class="form-group">
					<label class="col col-4">Active</label>
					<div class="col col-2">
						<input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_wex.IS_ACTIVE eq 1> checked</cfif> >
					</div>
					<label class="col col-4">Data Service</label>
					<div class="col col-2">
						<input type="checkbox" name="is_dataservice" id="is_dataservice" value="1" <cfif get_wex.IS_DATASERVICE eq 1> checked</cfif> onchange="open_publishing_date();">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Version*</label>
					<div class="col col-4 col-xs-12">
						<input type="text" name="version" id="version" value="<cfoutput>#get_wex.VERSION#</cfoutput>" title="Main Version" required>
					</div>
					<div class="col col-4 col-xs-12">
						<input type="text" name="main_version" id="main_version" value="<cfoutput>#get_wex.MAIN_VERSION#</cfoutput>" title="Object Version" required>
					</div>
				</div>
				<div class="form-group" id="publishing_date_div" <cfif get_wex.IS_DATASERVICE neq 1>style="display: none;"</cfif>>
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31639.Yayın Tarihi'></label>
					<div class="col col-8 col-xs-12"> 
						<div class="input-group">
							<cfinput type="text" name="publishing_date" id="publishing_date" value="#dateformat(get_wex.publishing_date,dateformat_style)#" validate="#validate_style#"  maxlength="10">
							<span class="input-group-addon"><cf_wrk_date_image date_field="publishing_date"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Statu*</label>
					<div class="col col-8 col-xs-12">
						<select name="status" id="status" required>
							<option value="Analys" <cfif get_wex.STATUS eq 'Analys'>selected</cfif>>Analys</option>
							<option value="Deployment" <cfif get_wex.STATUS eq 'Deployment'>selected</cfif>>Deployment</option>
							<option value="Design" <cfif get_wex.STATUS eq 'Design'>selected</cfif>>Design</option>
							<option value="Development" <cfif get_wex.STATUS eq 'Development'>selected</cfif>>Development</option>
							<option value="Testing" <cfif get_wex.STATUS eq 'Testing'>selected</cfif>>Testing</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Stage*</label>
					<div class="col col-8 col-xs-12">
						<cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0' fusepath="dev.list_wbo">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Author*</label>
					<div class="col col-8 col-xs-12">
						<cfoutput>
							<input type="text" name="author_name" id="author_name" value="<cfoutput>#get_wex.AUTHOR#</cfoutput>" required>
						</cfoutput>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Authentication*</label>
					<div class="col col-8 col-xs-12">
						<select name="authentication" id="authentication" required>
							<option value="1" <cfif get_wex.AUTHENTICATION eq 1>selected</cfif>>Public</option>
							<option value="2" <cfif get_wex.AUTHENTICATION eq 2>selected</cfif>>Private</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12">Time Plan*</label>
					<div class="col col-8 col-xs-12" id="item-time_plan">
						<!--- <div class="input-group"> --->
						<select name="time_plan_type" id="time_plan_type" required>
							<option value="1" <cfif get_wex.TIME_PLAN_TYPE eq 1>selected</cfif>>On Demand</option>
							<option value="2" <cfif get_wex.TIME_PLAN_TYPE eq 2>selected</cfif>>Periodic</option>
						</select>
							<!--- <span class="input-group-addon no-bg"></span>
							<input type="number" name="time_plan" <cfif get_wex.TIME_PLAN_TYPE eq 1 or not isdefined("wxid")>disabled</cfif> id="time_plan" value="<cfoutput>#IIF((get_wex.TIME_PLAN_TYPE eq 2),get_wex.TIME_PLAN,DE(''))#</cfoutput>">
							<span class="input-group-addon no-bg"> min </span> --->
						<!--- </div> --->
					</div>
				</div>
				<div class="form-group">
					<div class="col col-4 col-xs-12">
					</div>
					<div class="col col-8 col-xs-12" id="item-schedule">
						<cfif get_wex.TIME_PLAN_TYPE eq 2>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_schedule_task&is_pos_operation=0</cfoutput>','medium');"><i style="margin-right:5px;margin-top:2px;" class="icon-time"></i><label style="cursor:pointer !important;"><cf_get_lang dictionary_id='42738.Zaman Ayarlı Görev Ekle'></label></a>
						</cfif>
					</div>
				</div>
			</div><!--- col --->
		</cf_box_elements>
		<cf_box_elements id="broadcast_area" vertical="1">
			<cf_seperator title="#getlang('','Detay','57771')#" id="detail_sep">
			<div class="col col-12" style="display: none;" id="detail_sep">
				<div class="form-group">
					<label style="display:none!important;"><cf_get_lang dictionary_id="57771.Detay"></label>
					<cfmodule
						template="../fckeditor/fckeditor.cfm"
						toolbarSet="Basic"
						basePath="/fckeditor/"
						instanceName="wex_detail"
						valign="top"
						value="#get_wex.DETAIL#"
						width="550"
						height="180">
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cfif isdefined("attributes.wxid") and len(attributes.wxid)>
				<cf_record_info 
					query_name="get_wex"
					record_emp="record_emp" 
					record_date="record_date"
					update_emp="update_emp"
					update_date="update_date">
				<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
			<cfelse>
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</cfif>
		</cf_box_footer>
	</cf_box>
</cfform>

<cfif ( isDefined("attributes.restName") and isDefined("attributes.filePath") ) or len(get_wex.DATA_CONVERTER)>


	<cfif len(get_wex.DATA_CONVERTER)>
		<cfset Data = deserializeJSON( get_wex.DATA_CONVERTER ) />
		<cfset attributes.restName = get_wex.REST_NAME />
	<cfelse>
		<cfif isDefined("attributes.restName") and isDefined("attributes.filePath")>
			<cfset CrObj = createObject("component",attributes.filePath)>
			<cfset Data = getMetadata(CrObj)>
		<cfelse>
			<cfset CrObj = createObject("component",get_wex.filePath)>
			<cfset Data = getMetadata(CrObj)>
			<cfset attributes.restName = get_wex.REST_NAME />
		</cfif>
	</cfif>

	<cfif isStruct( Data )>
		<cfscript>converter = arrayFilter(Data.functions, function( elm ){ return elm.name eq attributes.restName })[1].PARAMETERS;</cfscript>
	<cfelse>
		<cfset converter = Data />
	</cfif>

	<cf_box title="Converter" closable="0">
		<cf_grid_list id="converter_table">
			<thead>
				<tr>
					<th>Parameter Name</th>
					<th>Required</th>
					<th>Hint</th>
					<th>Convert Parameter Name</th>
					<th>Convert Hint</th>
					<th>Convert Default Value</th>
					<th>Convert Required</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput>
					<tbody>
						<cfif arrayLen( converter )>
							<cfloop array="#converter#" item="currentItem" index="i">
								<!--- <cfdump var = "#currentItem#"> --->
								<tr>
									<td><input type="text" name="name" value="#currentItem.name#"></td>
									<td><input type="text" name="required" value="#currentItem.Required#"></td>
									<td><input type="text" name="hint" value="#currentItem.hint#"></td>
									<td><input type="text" name="convert_parameter" value="#currentItem.convert_parameter?:''#"></td>
									<td><input type="text" name="convert_hint" value="#currentItem.convert_hint?:''#"></td>
									<td><input type="text" name="convert_default_value" value="#currentItem.convert_default_value?:''#"></td>
									<td><select name="convert_required"><option value="#currentItem.convert_required?:''#"><cf_get_lang dictionary_id='57734.Seçin'></option><option value="1" #( isdefined("currentItem.convert_required") and currentItem.convert_required eq 1 ? 'selected' : '' )#>true</option><option value="2" #( isdefined("currentItem.convert_required") and currentItem.convert_required eq 2 ? 'selected' : '' )#>false</option><option value="3" #( isdefined("currentItem.convert_required") and currentItem.convert_required eq 3 ? 'selected' : '' )#>Not Share</option></select></td>
								</tr>
							</cfloop>
						</cfif>
					</tbody>
				</cfoutput>
			</tbody>
		</cf_grid_list>
	</cf_box>
</cfif>
<cfif isdefined("attributes.wxid") and len(attributes.wxid)>
	<cfif get_wex.AUTHENTICATION eq 2>
		<!--- <cf_seperator id="authorization_area" header="#getLang('bank',251)#" is_closed="1"> --->
		<cf_box title="#getLang('bank',251)#" id="wexPerm" add_href="index.cfm?fuseaction=objects.popup_add_wex_authorization&wex_id=#get_wex.WEX_ID#" closable="0">
			<cf_ajax_list>
				<thead>
					<tr>
						<th width="15"></th>
						<th><cf_get_lang_main no="1705.Abone No"></th>
						<th><cf_get_lang_main no="1420.Abone"></th>
						<th><cfoutput>#getLang('bank',210)#</cfoutput></th>
						<th><cfoutput>#getLang('main', 162)#</cfoutput></th>
						<th><cf_get_lang_main no="480.Domain"></th>
						<th><cfoutput>#getLang('assetcare',116)#</cfoutput></th>
						<th><cfoutput>#getLang('campaign',203)#</cfoutput></th>
						<!--- <th style="text-align:center;"><img src="/images/update_list.gif"></th> --->
						<th style="text-align:center;"><a href="javascript://" onClick="windowopen('index.cfm?fuseaction=objects.popup_add_wex_authorization&wex_id=<cfoutput>#get_wex.WEX_ID#</cfoutput>', 'medium')"><img src="/images/plus_list.gif" title="<cf_get_lang_main no ='170.Ekle'>" border="0"></a></th>
					</tr>
				</thead>
				<tbody>
				<cfif get_wex_authorization_list.recordCount>
					<cfoutput query="get_wex_authorization_list">
						<tr>
							<td>#currentRow#</td>
							<td>#SUBSCRIPTION_NO#</td>
							<td>#SUBSCRIPTION_HEAD#</td>
							<td>#COUNTER_NO#</td>
							<td>#FULLNAME#</td>
							<td>#DOMAIN#</td>
							<td>#IP#</td>
							<td>#iif((IS_SMS eq 1), DE('SMS VAR'), DE('SMS YOK'))#</td>
							<td style="text-align:center;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_upd_wex_authorization&auth_id=#AUTH_ID#','medium')" class="tableyazi"><img src="/images/update_list.gif" title="Güncelle " border="0"></a></td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="9">
							Kayıt Bulunamadı
						</td>
					</tr>
				</cfif>
				</tbody>
			</cf_ajax_list>
		</cf_box>
	</cfif>
</cfif>
</div>
<script language="JavaScript">
$("select#time_plan_type").change(function(){
	var min = $("input#time_plan");
	if($(this).val() == 1) min.prop("disabled",true).css({"border-color":"#ccc"});
	else min.prop("disabled",false).css({"border-color":"red"});
});

function process_cat_show (e){
	if($(e).prop('checked') == true)
		$("#div_process_cat").show();
	else
		$("#div_process_cat").hide();
		
}
function loadFamilies(solutionId,target,related,selected)
{
	$('#'+related+" option[value!='']").remove();
	$.ajax({
		  url: '/WMO/GeneralFunctions.cfc?method=getFamily&dsn=<cfoutput>#dsn#</Cfoutput>&solutionId=' + solutionId,
		  success: function(data) {
			if(data)
			{
				$('#'+target+" option[value!='']").remove();
				data = $.parseJSON( data );
				for(i=0;i<data.DATA.length;i++)
				{
					var option = $('<option/>');
					if(selected && selected == data.DATA[i][0])
						option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
					else
						option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
					$('#'+target).append(option);
				}
			}
		  }
	   });
}
function loadModules(familyId,target,selected)
{
	$.ajax({
		  url: '/WMO/GeneralFunctions.cfc?method=getModule&dsn=<cfoutput>#dsn#</Cfoutput>&familyId=' + familyId,
		  success: function(data) {
			if(data)
			{
				$('#'+target+" option[value!='']").remove();
				data = $.parseJSON( data );
				for(i=0;i<data.DATA.length;i++)
				{
					var option = $('<option/>');
					if(selected && selected == data.DATA[i][0])
						option.attr({ 'value': data.DATA[i][0], 'selected':'selected' }).text(data.DATA[i][1]);
					else
						option.attr({ 'value': data.DATA[i][0] }).text(data.DATA[i][1]);
					$('#'+target).append(option);
				}
			}
		  }
	   });
}

function showPopupInfo()
{
	if($("#window_name").val() == 'popup')
	{
		$(".popupInfo").show();
	}
	else
	{
		$(".popupInfo").hide();
		$("#popupInfoType").val('');
	}
}

function kontrol() {
	if(document.getElementById('dictionary_id').value == '' || document.getElementById('head').value == '')
	{
		alert('Head alanını sözlükten seçiniz!');
		return false;
	}
	if(document.getElementById('module').value == '')
	{
		alert('Lütfen Solution, Family ve Module alanlarını boş bırakmayınız!');
		return false;	
	}
	if(document.WexForm.solution.value == "" || document.WexForm.family.value == "" || document.WexForm.module.value == ""|| document.WexForm.licence.value == ""|| document.WexForm.type.value == ""|| document.WexForm.rest_name.value == ""|| document.WexForm.file_path.value == ""|| document.WexForm.version.value == ""|| document.WexForm.status.value == ""|| document.WexForm.process_stage.value == "" || document.WexForm.author_name.value == "" || document.WexForm.authentication.value == ""|| document.WexForm.time_plan_type.value == "")
	{
		alert("Zorunlu Alanları Giriniz!");
		return false;
	}
	if($("#is_dataservice").is(':checked') && $("#publishing_date").val() == '')
	{
		alert("<cf_get_lang dictionary_id='38596.Yayın Tarihi Girmelisiniz'>");
		return false;
	}

	<cfif ( isDefined("attributes.restName") and isDefined("attributes.filePath") ) or len(get_wex.DATA_CONVERTER)>
		json = toJSONString();
		$("#convert_json").text(json);
	</cfif>
	
	return true;
}

function setParameter( data ) {
	var elm = {
		name: data.name || '',
		required: data.required || '',
		hint: data.hint || '',
		convert_parameter: data.convert_parameter || '',
		convert_hint: data.convert_hint || '',
		convert_default_value: data.convert_default_value || '',
		convert_required: data.convert_required || ''
	};
	return elm;
}

function toJSONString() {
	var obj = [];
	var elements = document.querySelectorAll( "#converter_table tbody tr" );

	if( elements.length > 0 ){
		$("#converter_table tbody tr").each( function () {
			obj.push( new setParameter({
				name: $(this).find('input[name = name]').val(),
				required: $(this).find('input[name = required]').val(),
				hint: $(this).find('input[name = hint]').val(),
				convert_parameter: $(this).find('input[name = convert_parameter]').val(),
				convert_hint: $(this).find('input[name = convert_hint]').val(),
				convert_default_value: $(this).find('input[name = convert_default_value]').val(),
				convert_required: $(this).find('select[name = convert_required]').val()
			}) );
		} );
	}

	return JSON.stringify( obj );

}


function open_publishing_date()
{
	if ($('#is_dataservice').is(':checked')) 
		$('#publishing_date_div').css('display','');
	else
		$('#publishing_date_div').css('display','none');
}
</script>