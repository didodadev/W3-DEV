<cfparam name="attributes.component" default="0">
<cfparam name="attributes.fuseact" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.fuseaction" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.solution" default="">
<cfparam name="attributes.family" default="">
<cfparam name="attributes.module" default="">
<cfparam name="attributes.widget_id" default="">
<cfparam name="attributes.licence" default="">
<cfparam name="attributes.typeObject" default="">
<cfparam name="attributes.public_area" default="">
<cfparam name="attributes.friendly_name" default="">
<cfparam name="attributes.friendly_id" default="">
<cfparam name="attributes.widget_type" default="">
<cfparam name="attributes.tool" default="">
<cfparam name="attributes.maxrow" default="#session.ep.maxrows#">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.only_choice" default="1">
<cfparam name="attributes.is_friendly" default="0">
<cfparam name="attributes.click_count" default="">
<cfparam name="attributes.is_upd" default="0">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrow)+1>
<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfset comp = createObject("component", "cfc.system")>
<cfscript>	
    GET_WIDGETS = comp.GET_WIDGETS(
    fuseaction : '', 
    keyword : attributes.keyword, 
    solution : attributes.solution,
    family : attributes.family,
    module : attributes.module,
    licence : attributes.licence,
    maxrow	: attributes.maxrow,
    widget_type: attributes.widget_type,
	widget_id:attributes.widget_id,
    other: 1,
    public_area : attributes.public_area,
    tool : attributes.tool,
    friendly_name : attributes.friendly_name);
</cfscript>
<cfparam name="attributes.totalrecords" default="#GET_WIDGETS.recordcount#">
<cfset url_string = "">
	<cfif isdefined("field_id")><cfset url_string = "#url_string#&field_id=#field_id#"></cfif>
	<cfif isdefined("field_name")><cfset url_string = "#url_string#&field_name=#field_name#"></cfif>
<cfset getSolutions = list_wbo.getSolution()>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="Widgets" popup_box="1">
		<cfform name="listWidget" id="listWidget" action="#request.self#?fuseaction=dev.popup_widget#url_string#" method="post">
			<cf_box_search more="0">		
				<input type="hidden" name="fuseact" id="fuseact" value="<cfoutput>#attributes.fuseact#</cfoutput>" />
				<input name="form_submitted" id="form_submitted" type="hidden" value="1">
				<input type="hidden" name="click_count" value="<cfoutput><cfif isdefined("attributes.click_count") and len(attributes.click_count)>#attributes.click_count#<cfelse>#attributes.is_upd#</cfif></cfoutput>">
				<input type="hidden" name="component" id="component" value="1">
				<input type="hidden" name="widget_id" id="widget_id"  value="<cfoutput>#attributes.widget_id#</cfoutput>">
				<input type="hidden" name="only_choice" id="only_choice"  value="<cfoutput>#attributes.only_choice#</cfoutput>">
				<input type="hidden" name="is_friendly" id="is_friendly"  value="<cfoutput>#attributes.is_friendly#</cfoutput>">
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
				<div class="form-group" id="item-submit">     
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('listWidget' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_flat_list>
			<thead>
				<tr>
                	<th>No</th>
					<th>ID</th>
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
				</tr>
			</thead>
			<tbody>
				<cfif isdefined("attributes.form_submitted")>
					<cfif GET_WIDGETS.recordCount>
						<cfoutput query="GET_WIDGETS" startrow="#attributes.startrow#" maxrows="#attributes.maxrow#">
							<tr>
								<td>#currentrow#</td>
								<td>#WIDGETID#</td>
								<td>
									<cfif attributes.is_friendly eq 0>
										<a href="javascript://" onClick="set_widget('#WIDGETID#', '#WIDGET_TITLE##len(WIDGET_FRIENDLY_NAME) ? " (" & WIDGET_FRIENDLY_NAME & ")" : ""#')" class="tableyazi" >#WIDGET_TITLE#</a>
									<cfelse>
										<a href="javascript://" onClick="set_widget('#WIDGETID#', '#WIDGET_FRIENDLY_NAME#')" class="tableyazi" >#WIDGET_TITLE#</a>
									</cfif>
								</td>
								<td>#WIDGET_FUSEACTION#</td>
                                <td>
									<cfif attributes.is_friendly eq 0>
										<a href="javascript://" onClick="set_widget('#WIDGETID#', '#WIDGET_TITLE##len(WIDGET_FRIENDLY_NAME) ? " (" & WIDGET_FRIENDLY_NAME & ")" : ""#')" class="tableyazi" >#WIDGET_FRIENDLY_NAME#</a>
									<cfelse>
										<a href="javascript://" onClick="set_widget('#WIDGETID#', '#WIDGET_FRIENDLY_NAME#')" class="tableyazi" >#WIDGET_FRIENDLY_NAME#</a>
									</cfif>
								</td>
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
		<cfif attributes.totalrecords gt attributes.maxrow and isdefined("attributes.form_submitted")>   
			<cfset adres="dev.popup_widget&form_submitted=1">
			<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
            <cfif isdefined("attributes.friendly_name")>
                <cfset adres = "#adres#&friendly_name=#attributes.friendly_name#">
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
			<cfif isdefined("attributes.tool") and len(attributes.tool)>
                <cfset adres = "#adres#&tool=#attributes.tool#">
            </cfif>
			<cfif isdefined("attributes.public_area") and len(attributes.public_area)>
				<cfset adres = "#adres#&public_area=#attributes.public_area#">
			</cfif>
			<cfif isdefined("attributes.widget_type") and len(attributes.widget_type)>
				<cfset adres = "#adres#&widget_type=#attributes.widget_type#">
			</cfif>
			<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
                <cfset adres = "#adres#&field_id=#attributes.field_id#">
            </cfif>
			<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
                <cfset adres = "#adres#&field_name=#attributes.field_name#">
            </cfif>
			<cfif isdefined("attributes.only_choice") and len(attributes.only_choice)>
                <cfset adres = "#adres#&only_choice=#attributes.only_choice#">
            </cfif>
			<cfif isdefined("attributes.is_friendly") and len(attributes.is_friendly)>
                <cfset adres = "#adres#&is_friendly=#attributes.is_friendly#">
            </cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrow#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#adres#"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">

	function loadFamilies(solutionId,target,related,selected){
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
	function loadModules(familyId,target,selected){
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

	function set_widget(widget_id, friendly_name){
		<cfif attributes.only_choice eq 1>
			<cfif isdefined("attributes.field_id")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = widget_id;
			</cfif>
			<cfif isdefined("attributes.field_name")>
				<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = friendly_name;
			</cfif>
			console.log("<cfoutput>#attributes.only_choice#</cfoutput>");
		<cfelse>
		console.log("aaa");
			var x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value;
				console.log(x);
			if (listWidget.click_count.value==0)
			{	
				listWidget.click_count.value = 1;
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = x + friendly_name;
			}
			else
			{
				var x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value;
				if (listWidget.click_count.value==0)
				{
					listWidget.click_count.value = 1;
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = x + friendly_name;
				}
				else
				{
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = x + ',\n'+friendly_name;
				}
			}
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
</script>