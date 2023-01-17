<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.solution" default="">
<cfparam name="attributes.family" default="">
<cfparam name="attributes.module" default="">
<cfparam name="attributes.maxrow" default='#session.ep.maxrows#'>
<cfparam name="attributes.licence" default="">
<cfparam name="attributes.wex_type" default="">
<cfparam name="attributes.formName" default="">
<cfparam name="attributes.fieldId" default="">
<cfparam name="attributes.fieldName" default="">
<cfparam name="attributes.url_str" default="">

<cfset wex = createObject("component", "WDO.development.cfc.wex")>
<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfif isdefined("attributes.is_submitted")>
    <cfset get_wex = wex.select(
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

<style>
    .status{
        width:15px;
        height:15px;
        border-radius:15px;
    }
</style>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrow)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','WEX',47849)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="search_accident" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
            <input type="hidden" name="fieldId" id="fieldId" value="<cfoutput>#attributes.fieldId#</cfoutput>" />
            <input type="hidden" name="fieldName" id="fieldName" value="<cfoutput>#attributes.fieldName#</cfoutput>" />
            <input type="hidden" name="is_submitted" id="is_submitted" value="1" />
            <cf_box_search>
                <div class="form-group">
                    <input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" placeholder="<cfoutput>#getLang('','Filtre',57460)#</cfoutput>" maxlength="255" onKeyDown="if(event.keyCode == 13) {searchButtonFunc()}">
                </div>
                <div class="form-group">
                    <select id="solution" name="solution" onchange="loadFamilies(this.value,'family','module')">
                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                        <cfoutput query="getSolutions">
                            <option value="#WRK_SOLUTION_ID#"<cfif attributes.solution eq WRK_SOLUTION_ID>selected</cfif>>#NAME#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select id="family" name="family" onchange="loadModules(this.value,'module')">
                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                    </select>
                </div>
                <div class="form-group">
                    <select id="module" name="module">
                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="licence" id="licence">
                        <option value="">Licence</option>
                        <option value="1" <cfif attributes.licence eq 1>selected</cfif>><cf_get_lang dictionary_id='37227.Standart'></option>
                        <option value="2" <cfif attributes.licence eq 2>selected</cfif>><cf_get_lang dictionary_id='60146.Add-On'></option>
                        <option value="3" <cfif attributes.licence eq 3>selected</cfif>><cf_get_lang dictionary_id='60148.Free'></option>
                    </select>
                </div>
                <div class="form-group">
                    <select name="wex_type" id="wex_type">
                        <option value="">Type</option>
                        <option value="1" <cfif attributes.wex_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29742.Export'></option>
                        <option value="2" <cfif attributes.wex_type eq 2>selected</cfif>><cf_get_lang dictionary_id='52718.Import'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrow" value="#attributes.maxrow#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_accident' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
        </cfform>
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"></th>
                    <th><cf_get_lang dictionary_id='52748.Status'></th>
                    <th><cf_get_lang dictionary_id='52831.Head'></th>
                    <th><cf_get_lang dictionary_id='52735.Type'></th>
                    <th><cf_get_lang dictionary_id='29761.URL'>/<cf_get_lang dictionary_id='58723.Adres'></th>
                    <th><cf_get_lang dictionary_id='62235.Solution'> / <cf_get_lang dictionary_id='62236.Family'> / <cf_get_lang dictionary_id='52749.Module'></th>
                    <th><cf_get_lang dictionary_id='52747.Version'></th>
                    <th><cf_get_lang dictionary_id='42197.Lisans'></th>
                    <th><cf_get_lang dictionary_id='52783.Author'></th>
                </tr>
            </thead>
            <tbody>
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
                                    </cfswitch>
                                    <div class="status" style="background-color:###colorCode#"></div>
                                </td>
                                <td><a href="javascript://" class="tableyazi" onclick="addForm(#WEX_ID#,'#head#');">#head#</a></td>
                                <td><cfif type eq 1><cf_get_lang dictionary_id='29742.Export'><cfelse><cf_get_lang dictionary_id='52718.Import'></cfif></td>
                                <td>#REST_NAME#</td>
                                <td>
                                    <cf_get_lang dictionary_id="#solution_dictionary_id#"> / <cf_get_lang dictionary_id="#family_dictionary_id#"> / <cf_get_lang dictionary_id="#module_dictionary_id#">
                                </td>
                                <td>#VERSION#</td>
                                <td><cfif LICENCE eq 1><cf_get_lang dictionary_id='45945.Standart'><cfelseif LICENCE eq 2><cf_get_lang dictionary_id='60146.Add-On'><cfelseif LICENCE eq 3><cf_get_lang dictionary_id='60148.Free'></cfif></td>
                                <td>#AUTHOR#</td>
                            </tr>
                        </tbody>
                    </cfoutput>
                <cfelse>
                    <td colspan="9" class="color-row"><cfif isdefined("attributes.is_submitted")><cf_get_lang dictionary_id="57484.Kayıt Yok"> !<cfelse><cf_get_lang dictionary_id="57701.Filtre Ediniz"> !</cfif></td>
                </cfif>
            </tbody>
        </cf_grid_list>    

        <cfif attributes.totalrecords gt attributes.maxrow>    
            <cfset url_str="objects.popup_list_wex&is_submitted=1">
            <cfif isDefined('attributes.keyword') and len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cfif isDefined('attributes.solution') and len(attributes.solution)>
                <cfset url_str = "#url_str#&solution=#attributes.solution#">
            </cfif>
            <cfif isDefined('attributes.family') and len(attributes.family)>
                <cfset url_str = "#url_str#&family=#attributes.family#">
            </cfif>
            <cfif isdefined("attributes.module") and len(attributes.module)>
                <cfset url_str = "#url_str#&module=#attributes.module#" >
            </cfif>
            <cfif isdefined("attributes.licence") and len(attributes.licence)>
                <cfset url_str = "#url_str#&licence=#attributes.licence#">
            </cfif>
            <cfif isdefined("attributes.type") and len(attributes.type)>
                <cfset url_str = "#url_str#&type=#attributes.type#">
            </cfif>
            <cfif len(attributes.maxrow)>
                <cfset url_str = "#url_str#&maxrow=#attributes.maxrow#">
            </cfif>
            <cfif len(attributes.formName)>
                <cfset url_str = "#url_str#&formName=#attributes.formName#">
            </cfif>
            <cfif len(attributes.fieldId)>
                <cfset url_str = "#url_str#&fieldId=#attributes.fieldId#">
            </cfif>
            <cfif len(attributes.fieldName)>
                <cfset url_str = "#url_str#&fieldName=#attributes.fieldName#">
            </cfif>
            <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrow#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#url_str#"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">

function addForm(wexid,wexName){
    <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.fieldId#</cfoutput>.value = wexid;
    <cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.<cfoutput>#attributes.fieldName#</cfoutput>.value = wexName;
    <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
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

$(function(){
	<cfif len(attributes.SOLUTION)>
		loadFamilies('<cfoutput>#attributes.SOLUTION#</cfoutput>','family','module','<cfoutput>#attributes.family#</cfoutput>');
	</cfif>
	<cfif len(attributes.family)>
		loadModules('<cfoutput>#attributes.family#</cfoutput>','module','<cfoutput>#attributes.module#</cfoutput>');
	</cfif>
});

</script>

