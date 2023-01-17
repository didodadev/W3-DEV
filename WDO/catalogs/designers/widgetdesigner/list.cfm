<cfparam name="attributes.component" default="0">
<cfparam name="attributes.fuseact" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.solution" default="">
<cfparam name="attributes.family" default="">
<cfparam name="attributes.module" default="">
<cfparam name="attributes.licence" default="">
<cfparam name="attributes.typeObject" default="">
<cfparam name="attributes.public_area" default="">
<cfparam name="attributes.friendly_name" default="">
<cfparam name="attributes.widget_type" default="">
<cfparam name="attributes.tool" default="">
<cfparam name="attributes.maxrow" default="#session.ep.maxrows#">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrow)+1>
<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfscript>	
	if ( isDefined( "attributes.form_submitted" ) || isdefined("attributes.selfwo") ) {
		if(attributes.component eq 0)
			getComponent = getObj.GET_WIDGETS(fuseaction : attributes.fuseact, keyword : attributes.keyword);
		else
			{
				getComponent = getObj.GET_WIDGETS(
				fuseaction : '', 
				keyword : attributes.keyword, 
				solution : attributes.solution,
				family : attributes.family,
				module : attributes.module,
				licence : attributes.licence,
				maxrow	: attributes.maxrow,
				other: 1,
				widget_type: attributes.widget_type,
				public_area : attributes.public_area,
				tool : attributes.tool,
				friendly_name : attributes.friendly_name);
			}
	}
	else{
		getComponent.recordcount=0;
	}
</cfscript>

<cfparam name="attributes.totalrecords" default="#getComponent.recordcount#">

<cfset getSolutions = list_wbo.getSolution()>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="listComponents" id="listComponents">
			<input type="hidden" name="fuseact" id="fuseact" value="<cfoutput>#attributes.fuseact#</cfoutput>" />
			<input name="form_submitted" id="form_submitted" type="hidden" value="1">
			<cfif isDefined("attributes.selfwo")>
				<input type="hidden" name="component" id="component" value="0">
				<input type="hidden" name="selfwo" id="selfwo" value="1">
			<cfelse>
				<input type="hidden" name="component" id="component" value="1">
			</cfif>
			<cf_box_search more="0">
				<div class="form-group" id="item-keyword">
					<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cf_get_lang_main no='48.Filtre'>">
				</div>
				<div class="form-group" id="item-friendly-name">
					<input type="text" name="friendly_name" id="friendly_name" value="<cfoutput>#attributes.friendly_name#</cfoutput>" placeholder="Friendly Name">
				</div>
				<div class="form-group">
					<select id="solution" name="solution" onchange="loadFamilies(this.value,'family','module')">
						<option value="">Solution</option>
						<cfoutput query="getSolutions">
							<option value="#WRK_SOLUTION_ID#"<cfif attributes.solution eq WRK_SOLUTION_ID>selected</cfif>>#NAME#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select id="family" name="family" onchange="loadModules(this.value,'module')">
						<option value="">Family</option>
					</select>
				</div>
				<div class="form-group">
					<select id="module" name="module">
						<option value="">Module</option>
					</select>
				</div>
				<div class="form-group">
					<select name="licence" id="licence">
						<option value="">Licence</option>
						<option value="1" <cfif attributes.licence eq 1>selected</cfif>>Standart</option>
						<option value="2" <cfif attributes.licence eq 2>selected</cfif>>Add-On</option>
					</select>
				</div>
				<div class="form-group">
					<select name="tool" id="tool">
						<option value="">Tool</option>
						<option value="code" <cfif attributes.tool eq 'code'>selected</cfif>>Code</option>
						<option value="nocode" <cfif attributes.tool eq 'nocode'>selected</cfif>>NoCode</option>
					</select>
				</div>
				<div class="form-group">
					<select name="public_area" id="public_area">
						<option value=""><cf_get_lang dictionary_id="30327.Yayın Alanı"></option>
						<option value="1" <cfif attributes.public_area eq 1>selected</cfif>>Public</option>
						<option value="2" <cfif attributes.public_area eq 2>selected</cfif>>Employee</option>
						<option value="3" <cfif attributes.public_area eq 3>selected</cfif>>Company</option>
						<option value="4" <cfif attributes.public_area eq 4>selected</cfif>>Consumer</option>
						<option value="5" <cfif attributes.public_area eq 5>selected</cfif>>Career</option>
						<option value="6" <cfif attributes.public_area eq 6>selected</cfif>>Machines</option>
						<option value="7" <cfif attributes.public_area eq 7>selected</cfif>>LiveStock</option>
						
					</select>
				</div>
				<!--- <div class="form-group">
					<select name="typeObject" id="typeObject">
						<option value="">Type</option>
						<option value="0" <cfif attributes.typeObject eq 0>selected</cfif>>WBO</option>
						<option value="13" <cfif attributes.typeObject eq 13>selected</cfif>>Dashboard</option>
						<option value="8" <cfif attributes.typeObject eq 8>selected</cfif>>Report</option>
						<option value="9" <cfif attributes.typeObject eq 9>selected</cfif>>General</option>
						<option value="1" <cfif attributes.typeObject eq 1>selected</cfif>>Param</option>           
						<option value="2" <cfif attributes.typeObject eq 2>selected</cfif>>System</option>
						<option value="3" <cfif attributes.typeObject eq 3>selected</cfif>>Import</option>
						<option value="12" <cfif attributes.typeObject eq 12>selected</cfif>>Export</option>
						<option value="4" <cfif attributes.typeObject eq 4>selected</cfif>>Period</option>
						<option value="5" <cfif attributes.typeObject eq 5>selected</cfif>>Maintenance</option>
						<option value="6" <cfif attributes.typeObject eq 6>selected</cfif>>Utility</option>
						<option value="7" <cfif attributes.typeObject eq 7>selected</cfif>>Dev</option>
						<option value="10" <cfif attributes.typeObject eq 10>selected</cfif>>Child WO</option>
						<option value="11" <cfif attributes.typeObject eq 11>selected</cfif>>Query-Backend</option>
					</select>
				</div> --->
				<div class="form-group">
					<select name="widget_type" id="widget_type">
						<option value="">Widget Type</option>
						<option value="1" <cfif attributes.widget_type eq 1>selected</cfif>>Design</option>
						<option value="2" <cfif attributes.widget_type eq 2>selected</cfif>>Configurator</option>
						<option value="3" <cfif attributes.widget_type eq 3>selected</cfif>>General</option>
						<option value="4" <cfif attributes.widget_type eq 4>selected</cfif>>WO Inside</option>
						<option value="5" <cfif attributes.widget_type eq 5>selected</cfif>>Micro Service</option>  
					</select>
				</div>
				<div class="form-group small" id="item-maxrows">
					<input type="text" name="maxrow" id="maxrow" value="<cfoutput>#attributes.maxrow#</cfoutput>">
				</div>
				<cfif isdefined("attributes.fuseact") and len(attributes.fuseact)>
					<div class="form-group" id="item-submit">     
						<a href="javascript://" class="ui-btn ui-btn-green" onclick="searchComponents()"><i class="fa fa-search"></i></a>  
					</div>
				<cfelse>
					<div class="form-group" id="item-submit">     
						<cf_wrk_search_button button_type="4">
					</div>
				</cfif>
				<div class="form-group" id="item-submit">     <!--- 
					<span class="btn blue btn-small" >ADD</span>   --->
					<a href="<cfoutput>#request.self#?fuseaction=dev.widget&event=add</cfoutput>" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="Widgets" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
                	<th>No</th>
					<th>Title</th>
					<th>FuseAction</th>
					<th>Friendly Name</th>
					<th>Event</th>
					<th>Solution</th>
					<th>Family</th>
					<th>Modul</th>
					<th>Version</th>
					<th>Tool</th>
					<th>Type</th>
					<th style="width:20px;"><a href="javascript://"><i class="fa fa-pencil"></i></a></th>
					<th style="width:20px;"><a href="javascript://"><i class="fa fa-object-group"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif (isdefined("attributes.form_submitted") || isdefined("attributes.selfwo"))>
					<cfif getComponent.recordcount>
						<cfoutput query="getComponent" startrow="#attributes.startrow#" maxrows="#attributes.maxrow#">
							<tr>
								<td>#currentrow#</td>
								<td>
									<cfif isdefined("attributes.selfwo")>
										<a href="javascript://" onclick="AjaxPageLoad('#request.self#?fuseaction=dev.widget&event=add&id=#WIDGETID#&selfwo=1&woid=#WRK_OBJECTS_ID#', 'objects')" title="Detail">#WIDGET_TITLE#</a>
									<cfelse>
										<a href="#request.self#?fuseaction=dev.widget&event=add&id=#WIDGETID#&woid=#WRK_OBJECTS_ID#" title="Detail">#WIDGET_TITLE#</a>
									</cfif>
								</td>
								<td>
									
									<cfloop list="#WIDGET_FUSEACTION#" index="i">
										<cfquery name="get_woid" datasource="#dsn#">
											SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#i#">
										</cfquery>
										<a href="#request.self#?fuseaction=dev.wo&event=upd&fuseact=#i#&woid=#get_woid.WRK_OBJECTS_ID#">#i#</a>&nbsp;
									</cfloop>
									
								</td>
								<td>#WIDGET_FRIENDLY_NAME#</td>
								<td>#WIDGET_EVENT_TYPE#</td>
								<td>#WIDGETSOLUTION#</td>
								<td>#WIDGETFAMILY#</td>
								<td>#WIDGETMODULE#</td>
								<td>#WIDGET_VERSION#</td>
								<td>#WIDGET_TOOL#</td>
								<td>
									<cfif WIDGET_TYPE eq 1>
										Design
									<cfelseif WIDGET_TYPE eq 2>
										Configurator
									<cfelseif WIDGET_TYPE eq 3>
										General
									<cfelseif WIDGET_TYPE eq 4>
										WO Inside
									<cfelseif WIDGET_TYPE eq 5>
										Micro Service
									<cfelse>
										-
									</cfif>
								</td>
                                <td>
									<cfif isdefined("attributes.selfwo")>
										<a href="javascript://" onclick="AjaxPageLoad('#request.self#?fuseaction=dev.widget&event=add&id=#WIDGETID#&selfwo=1&woid=#WRK_OBJECTS_ID#', 'objects')" title="Detail"><i class="fa fa-pencil"></i></a>
									<cfelse>
										<a href="#request.self#?fuseaction=dev.widget&event=add&id=#WIDGETID#&woid=#WRK_OBJECTS_ID#" title="Detail"><i class="fa fa-pencil"></i></a>
									</cfif>
								</td>
								<td>
									<a href="#request.self#?fuseaction=dev.widget&event=upd&fuseact=#WIDGET_FUSEACTION#&event_type=#WIDGET_EVENT_TYPE#&version=#WIDGET_VERSION#&id=#WIDGETID#&woid=#WRK_OBJECTS_ID#" title="Designer"><i class="fa fa-object-group"></i></a> 
								</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>	
							<td colspan="13"><cf_get_lang dictionary_id='57484.No record'> !</td>
						</tr>
					</cfif>
                <cfelse>
                    <tr>	
                        <td colspan="13"><cf_get_lang_main no='289.Filtre Ediniz '> !</td>
                    </tr>
                </cfif>
			</tbody>
		</cf_flat_list>
	
		<cfif attributes.totalrecords gt attributes.maxrow>   
			<cfset adres="dev.widget&form_submitted=1">
			<cfset target=''>
			<cfset isAjax=0> 
			<cfif isdefined("attributes.fuseact") and len(attributes.fuseact)>
				<cfset target='objects'>
				<cfset isAjax=1>
			</cfif>
			<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isDefined('attributes.solution') and len(attributes.solution)>
				<cfset adres = "#adres#&solution=#attributes.solution#">
			</cfif>
			<cfif isDefined('attributes.family') and len(attributes.family)>
				<cfset adres = "#adres#&family=#attributes.family#">
			</cfif>
			<cfif isdefined("attributes.module") and len(attributes.module)>
				<cfset adres = "#adres#&module=#attributes.module#" >
			</cfif>
			<cfif isdefined("attributes.licence") and len(attributes.licence)>
				<cfset adres = "#adres#&licence=#attributes.licence#">
			</cfif>
			<cfif isdefined("attributes.widget_type") and len(attributes.widget_type)>
				<cfset adres = "#adres#&widget_type=#attributes.widget_type#">
			</cfif>
			<cfif len(attributes.maxrow)>
				<cfset adres = "#adres#&maxrow=#attributes.maxrow#">
			</cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrow#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				isAjax="#isajax#"
				target="#target#"
				adres="#adres#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
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
	$(function(){
	<cfif len(attributes.SOLUTION)>
		loadFamilies('<cfoutput>#attributes.SOLUTION#</cfoutput>','family','module','<cfoutput>#attributes.family#</cfoutput>');
	</cfif>
	<cfif len(attributes.family)>
		loadModules('<cfoutput>#attributes.family#</cfoutput>','module','<cfoutput>#attributes.module#</cfoutput>');
	</cfif>
	});

	function searchComponents()
	{
		component = $("#listComponents #component").val();
		maxrow = $("#listComponents input#maxrow").val();
		keyword = $("#listComponents input#keyword").val();
		solution = $("#listComponents select#solution").val();
		family = $("#listComponents select#family").val();
		widget_type = $("#listComponents select#widget_type").val();
		module = $("#listComponents select#module").val();
		licence = $("#listComponents select#licence").val();
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=dev.widget&form_submitted=1&fuseact=#attributes.fuseact#&component=</cfoutput>'+component+'&maxrow='+maxrow+'&keyword='+keyword+'&solution='+solution+'&family='+family+'&module='+module+'&licence='+licence<cfoutput><cfif isdefined('attributes.selfwo')>+'&selfwo='+'#attributes.selfwo#'</cfif></cfoutput>,'objects');
	}
	
	function goFormList(option)
	{
		$("#workdevmenu li.workdevActive").attr('class','');
		$("#workdevmenu li[title="+option+"]").attr('class','workdevActive');
		callPage(option);
	}

	function goFormDetail(option, id) 
	{
		<cfif attributes.component eq 0>
		$("#workdevmenu li.workdevActive").attr('class', '');
		$("#workdevmenu li[title="+option+"]").attr('class', 'workdevActive');
		callPage(option, null, null, '&fuseact='+id);
		<cfelse>
		window.location.href = '<cfoutput>#request.self#?fuseaction=dev.workdev&fuseact=</cfoutput>' + id;
		</cfif>
	}

</script>