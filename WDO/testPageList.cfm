<cfif isDefined("attributes.mode") and attributes.mode eq "det">
    <cfinclude template="testPageDet.cfm">
    <cfexit>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrow" default='#session.ep.maxrows#'>
<cfparam name="attributes.solutionid" default="">
<cfparam name="attributes.familyid" default="">
<cfparam name="attributes.moduleid" default="">
<cfparam name="attributes.record_emp" default="">
<cfparam name="attributes.record_name" default="">

<cfset list_wbo = createObject("component", "development.cfc.list_wbo")>
<cfset category = createObject("component", "WDO.development.cfc.test_cat_controller")>
<cfset getSolution = list_wbo.getSolution()>

<cfif isDefined( "attributes.is_submited" )>
    <cfset checkParams = {}>
    <cfif isDefined("attributes.moduleid") and len(attributes.moduleid)>
        <cfset checkParams.module = attributes.moduleid>
    </cfif>
    <cfif isDefined("attributes.familyid") and len(attributes.familyid)>
        <cfset checkParams.family = attributes.familyid>
    </cfif>
    <cfif isDefined("attributes.solutionid") and len(attributes.solutionid)>
        <cfset checkParams.solution = attributes.solutionid>
    </cfif>
    <cfif isDefined("attributes.fuse")>
        <cfset checkParams.fuseaction = attributes.fuse>
    </cfif>
    <cfif isDefined("attributes.record_emp") and len(attributes.record_emp)>
        <cfset checkParams.tester = attributes.record_emp>
    </cfif>
    <cfset listofchecks = category.getCheckMain(argumentcollection:checkParams)>
<cfelse>
    <cfset listofchecks.recordcount = 0>
</cfif>

<cfparam name="attributes.totalrecords" default="#listofchecks.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrow)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="formsearch" id="formsearch">
            <input type="hidden" name="is_submited" id="is_submited" value="1" />
            <cf_box_search more="0">
                <div class="form-group">
                    <select id="solutionid" name="solutionid" onchange="loadFamilies(this.value,'familyid','moduleid')" message="Solution seçiniz">
                        <option value="">SOLUTION</option>
                        <cfoutput query="getSolution">
                            <option value="#WRK_SOLUTION_ID#"#iif(WRK_SOLUTION_ID eq attributes.solutionid,de(' selected="selected"'),de(""))#>#NAME#</option>
                        </cfoutput>
                    </select>
                </div>  
                <div class="form-group">
                    <input type="hidden" name="family" id="family">
                    <select id="familyid" name="familyid" onchange="loadModules(this.value, 'moduleid')" message="Family seçiniz" required>
                        <option value="">FAMILY</option>
                    </select>
                </div>
                <div class="form-group">
                    <input type="hidden" name="module" id="module">
                    <select id="moduleid" name="moduleid" message="Module seçiniz" required>
                        <option value="">MODULE</option>
                    </select>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#attributes.record_emp#</cfoutput>">
                        <cfsavecontent variable="registerlabel">Test User</cfsavecontent>
                        <input type="text" name="record_name" id="record_name" value="<cfoutput>#attributes.record_name#</cfoutput>" maxlength="255" onFocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp','list_help','3','135');" class="form-control" placeholder="<cfoutput>#registerlabel#</cfoutput>">
                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=formsearch.record_emp&field_name=formsearch.record_name&select_list=1','list','popup_list_positions');"></span>
                    </div>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrow" value="#attributes.maxrow#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
                <cfif isdefined("attributes.fuse") and len(attributes.fuse)>
					<div class="form-group" id="item-submit">     
						<a href="javascript://" class="ui-btn ui-btn-green" onclick="searchButtonFunc()"><i class="fa fa-search"></i></a>  
					</div>
				<cfelse>
					<div class="form-group" id="item-submit">     
						<cf_wrk_search_button button_type="4">
					</div>
				</cfif>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box uidrop="1" hide_table_column="1" title="#getLang('service',163,'Test Sonuçları')#">
        <cf_flat_list>
            <thead>
                <tr>
                    <th>No</th>
                    <th>Wo-Fuseaction</th>
                    <th>Solution/Family/Modul</th>
                    <th>Domain</th>
                    <th>Version</th>
                    <th>Test User</th>
                    <th>Test Results</th>
                    <th>Date</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            <cfif listofchecks.recordcount>
                <cfoutput query="listofchecks" startrow="#attributes.startrow#" maxrows="#attributes.maxrow#">
                    <tr>
                        <td>#CHECH_ID#</td>
                        <td>#FUSEACTION#</td>
                        <td>#MODUL_SHORT_NAME#</td>
                        <td>#DOMAIN#</td>
                        <td>#VERSION#</td>
                        <td>#TEST_USER#</td>
                        <td>
                            <cfif GENERAL_POINT eq 1>
                                <h3><i class="fa fa-smile-o font-green_new" title="Successful"></i></h3>
                            <cfelseif GENERAL_POINT eq 0>
                                <h3><i class="fa fa-meh-o font-yellow" title="Middle"></i></h3>
                            <cfelseif GENERAL_POINT eq -1>
                                <h3><i class="fa fa-frown-o font-red" title="Failed"></i></h3>
                            </cfif>
                        </td>
                        <td>#dateformat(TEST_DATE, dateformat_style)#</td>
                        <td><a href="javascript:void(0)" onclick="AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_system&type=tst&mode=det&testid=#CHECH_ID#','workDev-page-content')"><i class="fa fa-refresh"></i></a></td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="9"><cfif isdefined("attributes.is_submited")><cf_get_lang_main no="72.Kayıt Yok"> !<cfelse><cf_get_lang_main no="289.Filtre Ediniz"> !</cfif></td>
                </tr>
            </cfif>
            </tbody>
        </cf_flat_list>
        <cfif attributes.totalrecords and(attributes.totalrecords gt attributes.maxrow)> 
            <cfset adres="dev.testkits&is_submited=1">
            <cfset target=''>
			<cfset isAjax=0> 
			<cfif isdefined("attributes.fuse") and len(attributes.fuse)>
				<cfset target='objects'>
				<cfset isAjax=1>
			</cfif>
            <cfif isDefined('attributes.solutionid') and len(attributes.solutionid)>
                <cfset adres = "#adres#&solutionid=#attributes.solutionid#">
            </cfif>
            <cfif isDefined('attributes.familyid') and len(attributes.familyid)>
                <cfset adres = "#adres#&familyid=#attributes.familyid#">
            </cfif>
            <cfif isdefined("attributes.moduleid") and len(attributes.moduleid)>
                <cfset adres = "#adres#&moduleid=#attributes.moduleid#" >
            </cfif>
            <cfif isdefined("attributes.record_emp") and len(attributes.record_emp)>
                <cfset adres = "#adres#&record_emp=#attributes.record_emp#">
            </cfif>
            <cfif isdefined("attributes.record_name") and len(attributes.record_name)>
                <cfset adres = "#adres#&record_name=#attributes.record_name#">
            </cfif>
            <cfif isdefined("attributes.maxrow") and len(attributes.maxrow)>
                <cfset adres = '#adres#&maxrow=#attributes.maxrow#'>
            </cfif>
            <cfif isdefined("attributes.fuse") and len(attributes.fuse)>
                <cfset adres = '#adres#&fuse=#attributes.fuse#'>
            </cfif>
            <cf_paging
                page="#attributes.page#" 
                maxrows="#attributes.maxrow#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#adres#"
                isAjax="#isajax#"
				target="#target#">
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

    function searchButtonFunc() {
        var solutionid = $("#solutionid").val();
        var maxrow = $("#maxrow").val();
        var moduleid = $("#moduleid").val();
        var familyid = $("#familyid").val();
        var record_name = $("#record_name").val();
        if(record_name != ''){
            var record_emp = $("#record_emp").val();
        }
        else{
            var record_emp = '';
        }
        var str = "&is_submited=1";
        if ( solutionid != "" ) str += "&solutionid=" + solutionid;
        if ( familyid != "" ) str += "&familyid=" + familyid;
        if ( moduleid != "" ) str += "&moduleid=" + moduleid;
        if ( record_emp != "" ) str += "&record_emp=" + record_emp;
        if ( record_name != "" ) str += "&record_name=" + record_name;
        if ( maxrow != "" ) str += "&maxrow=" + maxrow;

        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=dev.testkits</cfoutput>'+str,'objects');
	    return false;
    }

    $(document).ready(function () {
        <cfif len(attributes.solutionid)><cfoutput>loadFamilies('#attributes.solutionid#', 'familyid', 'moduleid', '<cfif len(attributes.familyid)>#attributes.familyid#</cfif>');</cfoutput></cfif>
        <cfif len(attributes.familyid)><cfoutput>loadModules('#attributes.familyid#', 'moduleid', '<cfif len(attributes.moduleid)>#attributes.moduleid#</cfif>');</cfoutput></cfif>
    });
</script>