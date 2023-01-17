<cfparam name="attributes.solution" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.module" default=''>
<cfparam name="attributes.family" default="">
<cfparam name="attributes.module" default="">
<cfparam name="attributes.licence" default="">
<cfparam name="attributes.is_upd" default="">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.field_name" default="">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.only_choice" default="">
<cfparam name="attributes.typeObject" default="0">
<cfparam name="attributes.choice" default="">
<cfparam name="attributes.function" default="">
<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfif isdefined("attributes.is_submitted")>
    <cfset get_wbo = list_wbo.getWrkFuesactions(
		dsn : dsn,
		woid : '',
		solution : '#IIf(len(attributes.solution),"attributes.solution",DE(""))#',
		family : '#IIf(len(attributes.family),"attributes.family",DE(""))#',
		module : '#IIf(len(attributes.module),"attributes.module",DE(""))#',
		is_menu : '#IIf(IsDefined("attributes.is_menu"),"attributes.is_menu",DE(""))#',
		typeObject : '#IIf(len(attributes.typeObject),"attributes.typeObject",DE(""))#',
		keyword : '#IIf(len(attributes.keyword),"attributes.keyword",DE(""))#',
		licence : '#IIf(len(attributes.licence),"attributes.licence",DE(""))#'
	)>
<cfelse>
	<cfset get_wbo.recordcount=0>
</cfif>
<cfset getSolutions = list_wbo.getSolution()>
<cfset getFamilies = list_wbo.getFamily()>
<cfset getModules = list_wbo.getModule()>
<cfparam name="attributes.totalrecords" default='#get_wbo.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="WO" popup_box="#iif(isdefined("attributes.draggable"),1,0)#" id="wo_box">
		<cfform name="form1" method="post" action="#request.self#?fuseaction=process.popup_dsp_faction_list&is_upd=#attributes.is_upd#">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1" />
			<input type="hidden" name="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
			<input type="hidden" name="click_count" value="<cfoutput><cfif isdefined("attributes.click_count") and len(attributes.click_count)>#attributes.click_count#<cfelse>#attributes.is_upd#</cfif></cfoutput>">
			<input type="hidden" name="is_upd" value="<cfoutput>#attributes.is_upd#</cfoutput>">
			<input type="hidden" name="function" value="<cfoutput>#attributes.function#</cfoutput>">
			<cfif isDefined("attributes.draggable")><input type="hidden" name="draggable" value="1"></cfif>
			<cf_box_search>
				<div class="form-group">
					<input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" maxlength="255">
				</div>
				<div class="form-group">
					<select id="solution1" name="solution" onchange="loadFamilies(this.value,'family1','module')">
						<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
						<cfoutput query="getSolutions">
							<option value="#WRK_SOLUTION_ID#"<cfif attributes.solution eq WRK_SOLUTION_ID>selected</cfif>>#NAME#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select id="family1" name="family" onchange="loadModules(this.value,'module1')">
						<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					</select>
				</div>
				<div class="form-group">
					<select id="module1" name="module">
						<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
					</select>
				</div>
				<div class="form-group">
					<select name="typeObject" id="typeObject">
						<option value="">Type</option>
						<option value="0" <cfif attributes.typeObject eq 0>selected</cfif>>WBO</option>
						<option value="8" <cfif attributes.typeObject eq 8>selected</cfif>>Report</option>
						<option value="1" <cfif attributes.typeObject eq 1>selected</cfif>>Param</option>
						<option value="3" <cfif attributes.typeObject eq 3>selected</cfif>>Import</option>
						<option value="10" <cfif attributes.typeObject eq 10>selected</cfif>>Child WO</option>
					</select>
				</div>
				<div class="form-group">
					<label><input type="checkbox" name="is_menu" id="is_menu" value="1" <cfoutput>#(isdefined("attributes.is_menu") and (attributes.is_menu eq 1)) ? 'checked' : ''#</cfoutput>/>Is Menu</label>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form1', #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
	
		<cf_flat_list>
				<thead>
					<tr>
						<th width="180"><cf_get_lang dictionary_id='52831.Head'></th>
						<th width="200"><cf_get_lang dictionary_id ='36185.Fuseaction'></th>
						<th>Solution / Family / Module</th>
					</tr>
				</thead>
			<tbody>
				<cfif get_wbo.recordcount>
					<cfoutput query="get_wbo" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#head#</td>
							<td height="20"><a href="##" onClick="add_faction('#full_fuseaction#');" class="tableyazi">#full_fuseaction#</a></td>
							<td><cfif len(MODULE_NO) AND LEN(MODUL)>
									<cf_get_lang_main dictionary_id="#solution_dictionary_id#"> / <cf_get_lang_main dictionary_id="#family_dictionary_id#"> / <cf_get_lang_main dictionary_id="#module_dictionary_id#">
								<cfelse>
										Modul Definition Empty
								</cfif>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
					</tr>
					</cfif>
				</tbody>
		</cf_flat_list>
		<cfif attributes.totalrecords gt attributes.maxrows>    
			<cfset adres="process.popup_dsp_faction_list&is_upd=">
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
			<cfif isdefined("attributes.typeObject") and len(attributes.typeObject)>
				<cfset adres = "#adres#&typeObject=#attributes.typeObject#">
			</cfif>
			<cfif isdefined("attributes.is_menu") and len(attributes.is_menu)>
				<cfset adres = "#adres#&is_menu=#attributes.is_menu#">
			</cfif>
			<cfif len(attributes.field_name)>
				<cfset adres = "#adres#&field_name=#attributes.field_name#">
			</cfif>
			<cfif len(attributes.choice)>
				<cfset adres = "#adres#&choice=#attributes.choice#">
			</cfif>
			<cfif len(attributes.function)>
				<cfset adres = "#adres#&function=#attributes.function#">
			</cfif>
			<cfif isdefined("attributes.draggable")>
				<cfset adres = "#adres#&draggable=#attributes.draggable#">
			</cfif>
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	function add_faction(f_name)
	{	
		<cfif len( attributes.field_name )>
			<cfif len( attributes.only_choice )>
				<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value =  f_name;
			<cfelse>
				var x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value;
				if (form1.click_count.value==0)
				{	
					form1.click_count.value = 1;
					<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = x + f_name;
				}
				else
				{
					var x = <cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value;
					if (form1.click_count.value==0)
					{
						form1.click_count.value = 1;
						<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = x + f_name;
					}
					else
					{
						<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = x + ',\n'+f_name;
					}
				}
			</cfif>
		</cfif>
		<cfif len( attributes.function )>
			<cfif not isdefined("attributes.draggable")>opener.</cfif><cfoutput>#attributes.function#(f_name)</cfoutput>;
		</cfif>

		<cfif attributes.choice eq 1 and not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>

	}
	function loadFamilies(solutionId,target,related,selected)
	{
		$('#'+related+" option[value!='']").remove();
		$.ajax({
			url: '/WMO/GeneralFunctions.cfc?method=getFamily&dsn=<cfoutput>#dsn#</cfoutput>&solutionId=' + solutionId,
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
		  url: '/WMO/GeneralFunctions.cfc?method=getModule&dsn=<cfoutput>#dsn#</cfoutput>&familyId=' + familyId,
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
</script>