<cf_get_lang_set module_name="dev">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_active" default=1>
<cfparam name="attributes.solution" default="">
<cfparam name="attributes.family" default="">
<cfparam name="attributes.module" default="">
<cfparam name="attributes.maxrow" default='#session.ep.maxrows#'>
<cfparam name="attributes.licence" default="">
<cfparam name="attributes.wex_type" default="">

<cfset wex = createObject("component", "development.cfc.wex")>
<cfset list_wbo = createObject("component", "development.cfc.list_wbo")>
<cfif isdefined("attributes.is_submitted")>
    <cfset get_wex = wex.select(
        wex_id      :   '#IIf(isdefined("attributes.wxid") and len(attributes.wxid),"attributes.wxid",DE(0))#',
        keyword     :   '#IIf(len(attributes.keyword),"attributes.keyword",DE(""))#',
        solution    :   '#IIf(len(attributes.solution),"attributes.solution",DE(""))#',
        family      :   '#IIf(len(attributes.family),"attributes.family",DE(""))#',
        module      :   '#IIf(len(attributes.module),"attributes.module",DE(""))#',
        licence     :   '#IIf(len(attributes.licence),"attributes.licence",DE(""))#',
        wex_type    :   '#IIf(len(attributes.wex_type),"attributes.wex_type",DE(""))#'
    )>
<cfelse>
	<cfset get_wex.recordcount=0>
</cfif>
<cfset getSolutions = list_wbo.getSolution()>
<cfset getFamilies = list_wbo.getFamily()>
<cfset getModules = list_wbo.getModule()>
<cfparam name="attributes.totalrecords" default="#get_wex.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrow)+1>

<style>
    .status{
        width:15px;
        height:15px;
        border-radius:15px;
    }
</style>

<!--- <div class="row">
	<div class="col col-12">
		<h3>WEX</h3>
	</div>
</div> --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box id="wex_search" closable="0" collapsable="0">
    <cfform name="wex_list" action="#request.self#?fuseaction=dev.wex" method="post">
        <input type="hidden" name="is_submitted" id="is_submitted" value="1" />
            <cf_box_search more="0">
                <div class="form-group">
                    <input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cf_get_lang_main no='48.Filtre'>" maxlength="255">
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
                        <option value="3" <cfif attributes.licence eq 3>selected</cfif>>Free</option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="wex_type" id="wex_type">
                        <option value="">Type</option>
                        <option value="1" <cfif attributes.wex_type eq 1>selected</cfif>>Export</option>
                        <option value="2" <cfif attributes.wex_type eq 2>selected</cfif>>Import</option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrow" value="#attributes.maxrow#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type='4'>
                </div>
                <div class="form-group">
                    <a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=dev.wex&event=add"><i class="fa fa-plus"></i></a>
                </div>
            </cf_box_search>
    </cfform>
</cf_box>
<cf_box id="wex_list_box" title="WEX" uidrop="1" hide_table_column="1">
    <cf_ajax_list>
         <thead>
            <tr>
                <th width="30">No</th>
                <th><cf_get_lang no="43.Status"></th>
                <th><cf_get_lang no="126.Head"></th>
                <th>Type</th>
                <th>Url/Address</th>
                <th>Solution / Family / Module</th>
                <th>Version</th>
                <th>Licence</th>
                <th><cf_get_lang no="78.Author"></th>
                <th><i class="fa fa-feed" title="Data Service"></i></th>
                <th width="20"><a href="<cfoutput>#request.self#?fuseaction=dev.wex&event=add</cfoutput>"><i class="fa fa-plus"></i></a></th>
            </tr>
        </thead>
        <cfif get_wex.recordcount>
            <cfoutput query="get_wex" startrow="#attributes.startrow#" maxrows="#attributes.maxrow#">
                <tbody>
                    <tr>
                        <td>#currentrow#</td>
                        <td>
                            <cfswitch expression="#status#">
                                <cfcase value="Analys"><cfset colorCode = "afafaf"></cfcase>
                                <cfcase value="Deployment"><cfset colorCode = "30a957"></cfcase>
                                <cfcase value="Design"><cfset colorCode = "abdcea"></cfcase>
                                <cfcase value="Development"><cfset colorCode = "0d91ef"></cfcase>
                                <cfcase value="Test"><cfset colorCode = "dac425"></cfcase>
                                <cfdefaultcase><cfset colorCode="fff"></cfdefaultcase>
                            </cfswitch>
                            <div class="status" style="background-color:###colorCode#"></div>
                        </td>
                        <td><a href="#request.self#?fuseaction=dev.wex&event=upd&wxid=#WEX_ID#" class="tableyazi">#head#</a></td>
                        <td><cfif type eq 1>Export<cfelse>Import</cfif></td>
                        <td>#REST_NAME#</td>
                        <td>
                            <cf_get_lang_main dictionary_id="#solution_dictionary_id#"> / <cf_get_lang_main dictionary_id="#family_dictionary_id#"> / <cf_get_lang_main dictionary_id="#module_dictionary_id#">
                        </td>
                        <td>#VERSION#</td>
                        <td><cfif LICENCE eq 1>Standart<cfelseif LICENCE eq 2>Add-On<cfelseif LICENCE eq 3>Free</cfif></td>
                        <td>#AUTHOR#</td>
                        <td><cfif is_dataservice eq 1><i class="fa fa-rss" title="Data Service"></i></cfif></td>
                        <td><a href="#request.self#?fuseaction=dev.wex&event=upd&wxid=#WEX_ID#"><i class="fa fa-pencil"></i></a></td>
                    </tr>
                </tbody>
            </cfoutput>
        <cfelse>
            <td colspan="10" class="color-row"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no="72.Kayıt Yok"> !<cfelse><cf_get_lang_main no="289.Filtre Ediniz"> !</cfif></td>
        </cfif>
    </cf_ajax_list>
    <cfif attributes.totalrecords gt attributes.maxrow>    
        <cfset adres="dev.wex&is_submitted=1">
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
        <cfif isdefined("attributes.is_legacy") and len(attributes.is_legacy)>
            <cfset adres = "#adres#&is_legacy=#attributes.is_legacy#">
        </cfif>
        <cfif len(attributes.maxrow)>
            <cfset adres = "#adres#&maxrow=#attributes.maxrow#">
        </cfif>
        <cf_paging
            page="#attributes.page#" 
            maxrows="#attributes.maxrow#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
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
</script>