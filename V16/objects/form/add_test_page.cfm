<cfparam name="attributes.event" default="list">

<cfset list_wbo = createObject("component", "WDO.development.cfc.list_wbo")>
<cfset WBO_TYPES = list_wbo.getWboList()>
<cfset process_type_list = list_wbo.getProcessTypes()>
<cfset category = createObject("component", "WDO.development.cfc.test_cat_controller")>
<cfset list_category = category.getCategoryList()>

<cfif isDefined("attributes.submited") && attributes.submited eq "1">
    <cfscript>
        checkid = category.saveCheckMain( catid:attributes.CATEGORYID, fuseaction:attributes.fuseact, domain:attributes.domain, version:attributes.version, event:attributes.event, test_user:attributes.record_name, test_userid:attributes.record_emp, test_date:attributes.test_date, general_point:attributes.averagepoint);
        for ( elm in structKeyArray( attributes ) ) {
            hasfield = 0;
            fieldName = listFirst( elm, "_" );
            fieldKey = listLast( elm, "_" );
            fieldStatus = 0;
            fieldSuccess = 0;
            fieldDesc = "";
            if ( fieldName eq "COMPLETE" ) {
                fieldStatus = 1;
                fieldDesc = iif(structKeyExists( attributes, "DESCRIPTION_#fieldKey#" ), "DESCRIPTION_#fieldKey#", "");
                fieldSuccess = iif(structKeyExists( attributes, "success_#fieldKey#" ), "success_#fieldKey#", DE(0));
                hasfield = 1;
            }
            if ( fieldName eq "DESCRIPTION" and structKeyExists( attributes, "COMPLETE_#fieldKey#" ) eq 0 )
            {
                fieldDesc = evaluate("DESCRIPTION_#fieldKey#");
                hasfield = 1;
            }
            if ( hasfield eq 1 ) {
                category.saveCheckRow( checkid: checkid, subjectid: fieldKey, detail: fieldDesc, status: fieldStatus, success:fieldSuccess );
            }
        }
    </cfscript>
    <cfabort>
</cfif>

<cfif not isdefined("attributes.woid")>
	<cfif not isdefined("attributes.fuseactExternal")>
	    <cfset attributes.fuseactExternal = ''>
	</cfif>
    <cfset attributes.woid = list_wbo.getWrkObjectsId('#DSN#','#attributes.fuseact#','#attributes.fuseactExternal#')>
</cfif>
<cfset GET_WRK_FUSEACTIONS = list_wbo.getWrkFuesactions('#DSN#','#attributes.woid#')>
<cfset RELATED_PROCESS_CAT = list_wbo.getRelatedProcessCat('#DSN#','#attributes.woid#')>
<cfset GET_MODULES = list_wbo.getWbo('#dsn#')>
<cfset wbo_type_list = list_wbo.getWboTypeList('#GET_WRK_FUSEACTIONS.TYPE#','#GET_WRK_FUSEACTIONS.IS_ADD#','#GET_WRK_FUSEACTIONS.IS_UPDATE#','#GET_WRK_FUSEACTIONS.IS_DELETE#')>
<cfset getSolution = list_wbo.getSolution()>
<cfset postaction = "dev.emptypopup_upd_fuseaction">

<cfset domain = "#request.self#"> 

<link rel="stylesheet" href="/css/assets/template/workdev/animate.css">
<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css">
<cfsavecontent variable="title"><cf_get_lang dictionary_id="32147.Test Ekle"></cfsavecontent>
<cf_box id="add_test_box" title="#title#" uniquebox_height="500px" closable="1" draggable="1">
    <cfform method="post" id="testform" name="testform">
        <input type="hidden" name="submited" value="1">
        <cfif isDefined("attributes.fuseact")>
            <input type="hidden" name="fuseact" value="<cfoutput>#attributes.fuseact#</cfoutput>">
        </cfif>
        <div class="col col-12">
            <div class="row formContent">
                <div class="row" type="row">
                    <div class="col col-12 col-xs-12">
                        <div class="col col-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57892.Domain'>:</label>
                                <div class="col col-8 col-xs-12">
                                    <cfoutput>
                                        <input type="hidden" name="domain" value="#cgi.SERVER_NAME#">
                                        #cgi.SERVER_NAME#
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55063.Fuseaction'>:</label>
                                <div class="col col-8 col-xs-12">
                                    <cfoutput>
                                        <input type="hidden" name="full_fuseaction" value="#get_wrk_fuseactions.full_fuseaction#">
                                        #get_wrk_fuseactions.full_fuseaction#
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col col-12 col-xs-12">
                        <div class="col col-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52747.Version'>:</label>
                                <div class="col col-8 col-xs-12">
                                    <cfoutput>
                                        <input type="hidden" name="version" value="#workcube_version#">
                                        #workcube_version#
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29510.Event'>:</label>
                                <div class="col col-8 col-xs-12">
                                    <cfoutput>
                                        <input type="hidden" name="event" value="#attributes.event#">
                                        #attributes.event#
                                    </cfoutput>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" type="row">
                    <div class="col col-12 col-xs-12">
                        <div class="col col-12 col-xs-12">
                            <cfloop query="list_category"> 
                                <div class="form-group">
                                    <div class="catalyst-seperator" id="<cfoutput>#id#</cfoutput>"><label onclick="slideBoxToggle(this)"><i class="icon-angle-down"></i>
                                        <cfoutput>#category_name#</cfoutput>
                                    </label></div>
                                    <cf_ajax_list>
                                        <thead>
                                            <tr>
                                                <th><cf_get_lang dictionary_id='55365.Kontrol'></th>
                                                <th><cf_get_lang dictionary_id='46266.Başarı Durumu'></th>
                                                <th><cf_get_lang dictionary_id='57480.Konu'></th>
                                                <th></th>
                                                <th><cf_get_lang dictionary_id='54291.Açıklaması'></th>
                                            </tr>
                                        </thead>
                                        <cfset list_subject_to_category = category.getSubjectForCategory('#id#')>
                                        <input type="hidden" name="categoryid" value="<cfoutput>#id#</cfoutput>">
                                        <cfoutput query=list_subject_to_category>
                                            <tr>
                                                <td>
                                                    <input type="checkbox" id="complete_#SUBJECT_ID#" name="complete_#SUBJECT_ID#" value="1" onChange="gosterGizle(#SUBJECT_ID#);"/>
                                                </td>
                                                <td>
                                                    <input type="checkbox" id="success_#SUBJECT_ID#" name="success_#SUBJECT_ID#" value="1" style="display:none;"/>
                                                </td>
                                                <td width="45%" class=".subject_#SUBJECT_ID#">
                                                    #subject#
                                                </td>
                                                <td>
                                                    <a class="add_button" title="Add field" data-id="#SUBJECT_ID#"><i class="fa fa-pencil"></i></a>
                                                </td>
                                                <td id="descriptionSubject_#SUBJECT_ID#" width="30%">
                                                </td>
                                            </tr>
                                        </cfoutput>
                                    </cf_ajax_list>
                                </div>
                            </cfloop>
                        </div>
                    </div>
                </div>
                <div class="row formContentFooter" type="row">
                    <div class="col col-12 col-xs-12">
                        <div class="form-group">
                            <input type="hidden" name="test_date" id="test_date" maxlength="10" validate="#validate_style#" value="<cfoutput>#dateFormat(now(), dateformat_style)#</cfoutput>" readonly>
                            <h4>
                                <label class="col col-6 col-xs-12 bold"><cf_get_lang dictionary_id='60237.Ortalama puan verin'></label>
                            </h4>
                            <h2>
                                <a title="Iyi" onclick="setAveragePoint(1);"><i class="fa fa-smile-o" data-checked="1"></i></a>
                                <a title="Orta" onclick="setAveragePoint(0);"><i class="fa fa-meh-o font-yellow" data-checked="0"></i></a>
                                <a title="Kotu" onclick="setAveragePoint(-1);"><i class="fa fa-frown-o" data-checked="-1"></i></a>
                            </h2>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <cfoutput><input type="hidden" name="record_emp" id="record_emp" value="#session.ep.USERID#"><input type="hidden" name="record_name" value="#session.ep.name# #session.ep.surname#"></cfoutput>
                <div class="col col-12 col-xs-12">
                    <div style="float:left; padding:2px;" class="record_info">
                        <i class="icons8-pencil"></i> <a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_emp_det&amp;emp_id=<cfoutput>#session.ep.USERID#</cfoutput>','medium');" class="tableyazi"><cfoutput>#session.ep.name# #session.ep.surname#</cfoutput></a><cfoutput>#dateFormat(now(), dateformat_style)#</cfoutput> &nbsp;
                    </div>
                    <cf_workcube_buttons is_upd='0' add_function='control()'>
                </div>
            </div>
        </div>
        <input type="hidden" name="averagepoint" id="averagepoint" value="0">
    </cfform>
</cf_box>
<script>       
    $(document).ready(function() {
        categoryFinder($("#categorySelect1"));
        //categoryFinder2($("#categorySelect2"));
        $("#categorySelect1").change(function() {categoryFinder(this)});  
        //$("#categorySelect2").change(function() {categoryFinder2(this)});  
        aciklama();
    });

    function setAveragePoint(p) {
        $("#averagepoint").val(p);
        $("i[data-checked]").removeClass("font-red font-yellow font-green_new");
        if(p == 1){
            $("i[data-checked='"+p+"']").addClass("font-green_new");
        }
        else if(p == 0){
            $("i[data-checked='"+p+"']").addClass("font-yellow");
        }
        else{
            $("i[data-checked='"+p+"']").addClass("font-red");
        }
    }

    function categoryFinder(ref) {
        var categoryID = $(ref).val();
        $.ajax({
           url : '<cfoutput>?fuseaction=objects.emptypopup_add_test_page&fuseact=#attributes.fuseact#</cfoutput>&categoryID='+categoryID+'&isAjax=1&mode=catlist',
           type:'POST',
           success: function (response) {
               $(".subjectForCategoryDIV1").html(response);
               aciklama();
           }
        });
    }
    
    function categoryFinder2(ref){
        var categoryID = $(ref).val();
        
       $.ajax({
           url : '<cfoutput>?fuseaction=objects.emptypopup_add_test_page&fuseact=#attributes.fuseact#</cfoutput>&categoryID='+categoryID+'&isAjax=1',
           type:'POST',
           success: function (response) {
               $(".subjectForCategoryDIV2").html(response);
           }
       });
    }

    function aciklama() {
        setTimeout(() => {
            $('.add_button').click(function () {
                if ( $(this).closest("td").next().data("rowtype") == "aciklama" ) return;
                var addid = $(this).data("id");
                $("#descriptionSubject_" + addid).hide();
                var div = '<td data-rowtype="aciklama" width="30%"><input class="boxtext" name="description_'+addid+'" placeholder="<cfoutput>#getLang('ehesap', 1345, 'Açıklama')#</cfoutput>"/></td>';
                $(div).insertAfter($(this).closest("td"));
            });
        }, 1000);
    }

    function gosterGizle(ref) {
        if($("#complete_" + ref).prop("checked")){
            $("#success_" + ref).show();
        }
        else{
            $("#success_" + ref).prop("checked", false);
            $("#success_" + ref).hide();
        }
    }

    function control(){
        var data = new FormData($("form#testform")[0]);
		AjaxControlPostData('<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_test_page</cfoutput>',data,function(response) {
			show_hide('add_test_box');
            gizle(add_test_box);
            alert("<cf_get_lang dictionary_id='60236.Bilgileriniz kaydedilmiştir'>");
			return false;
		});
		return false;
    }
</script>