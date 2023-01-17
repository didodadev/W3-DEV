<script src="/AddOns/AFM/assets/JS/catalog/catalog.common.js"></script>
<script src="/AddOns/AFM/assets/JS/catalog/catalog.vag.js"></script>
<cfprocessingdirective pageEncoding="utf8">
<cfset afmCatalog = CreateObject("component","AddOns.AFM.cfc.AfmCatalog")>
<cfset MainGroupList = afmCatalog.GetMainGroupList(url.make,url.market,url.model,url.epis_type)>
<cfset TypeInfo = afmCatalog.GetTypeInfo(url.make,url.market,url.model,url.epis_type)>
<cfif isdefined("url.mainGroup") and isdefined("url.subGroup")>
    <cfset SubGroupList = afmCatalog.GetSubGroupList(url.make,url.market,url.model,url.epis_type,url.mainGroup)>
    <cfset UnitList = afmCatalog.GetUnitList(url.make,url.market,url.model,url.epis_type,url.subgroup)>
<cfelse>
    <cfset url.mainGroup = "">
    <cfset url.subGroup = "">
</cfif>
<div class="container catalog vag">
    <div class="row">
        <div class="col-12">
            <h1>
                <cfoutput>
                    <img src="/AddOns\AFM\assets\img/#url.make#.svg" alt="vw">
                    #TypeInfo.title# (#TypeInfo.year_from#...#TypeInfo.year_to#)<small id="subGroupText_FindUnit"></small>
                </cfoutput>
            </h1>
            <div class="row cat-data group-tree">
                <div class="col-xs-12 col-sm-6">
                    <nav>
                        <ul class="nav sidenav nav-pills nav-stacked" id="sidemenu">
                            <cfloop array="#MainGroupList#" item="item" index="item_idx">
                                <li role="presentation" class="active">
                                    <cfoutput><a style="cursor:pointer;" class="subGroup_FindUnit" accesskey="0" id="primary-item-container-0#item_idx-1#" data-id="#item.mg_code#"><b>#item.mg_code# .</b>&nbsp;&nbsp;&nbsp; #item.mg_name#</a></cfoutput>
                                    <ul id="subGroupList">
                                    
                                    </ul>
                                </li>
                            </cfloop>
                        </ul>
                    </nav>
                </div>
                <cfform action="javascript:GoToEtka3();" type="GET" id="frmFindParts">
                    <cfoutput>
                        <input type="hidden" name="make" value="#url.make#" id="makeCode_FindUnit" />
                        <input type="hidden" name="model" value="#url.model#" id="catalogModel_FindUnit" />
                        <input type="hidden" name="market" value="#url.market#" id="catalogMarket_FindUnit" />
                        <input type="hidden" name="epis_type" value="#url.epis_type#" id="episType_FindUnit" />
                        <input type="hidden" name="unit_id" id="unitId_FindUnit" />
                        <input type="hidden" name="mainGroup" id="mainGroup_FindUnit" value="<cfscript>if(isDefined('MainGroupList')){arrayEach(MainGroupList,function(m,idx){if(m.mg_code == url.mainGroup){writeOutput(m.mg_name)}})}</cfscript>"/>
                        <input type="hidden" name="subGroup" id="subGroup_FindUnit" value="<cfscript>if(isDefined('SubGroupList')){arrayEach(SubGroupList,function(s,idx){if(s.sg_code == url.subGroup){writeOutput(s.sg_name)}})}</cfscript>" />
                    </cfoutput>
                    <div class="col-6 col-xs-6 col-sm-9 sg-units-col" id="sg-units">
                        <cfif isDefined("UnitList")>
                            <cfloop array="#UnitList#" item="item" index="item_idx">   
                                <cfoutput>
                                    <div data-id='#item.unit_id#' class='vag-unit unit_byManual'>
                                        <div class='unit-drawing'>
                                            <a><img src='#cdnServer#/unit_drawings/#item.drawing#' alt='Drawing' /></a>
                                        </div>
                                        <div class='unit-title'>
                                            <div class='heading'>
                                                <small>Tanım</small>
                                            </div>
                                            <div class='data'>
                                                <a>#item.title#</a>
                                            </div>
                                        </div>
                                        <div class='unit-remark'>
                                            <div class='heading'>
                                                <small>Hatırlatma</small>
                                            </div>
                                            <div class='data'>
                                                <a href='##'>#item.remark#</a>
                                            </div>
                                        </div>
                                        <div class='unit-model'>
                                            <div class='heading'>
                                                <small>Model Bilgisi</small>
                                            </div>
                                            <div class='data'>
                                                <a>#item.model#</a>
                                            </div>
                                        </div>
                                    </div>
                                </cfoutput>
                            </cfloop>
                        </cfif>
                    </div>
                </cfform>
            </div>
        </div>
    </div>
</div>

<script>

$(document).ready(function(){
    $('.subGroup_FindUnit').on('click', function (event) {
    if ($(this).attr("accesskey") == "0") {
        var idContainer = $(this).attr("id");
        var prmMake = $('#makeCode_FindUnit').attr("value");
        var prmMarket = $("#catalogMarket_FindUnit").attr("value");
        var prmModel = $("#catalogModel_FindUnit").attr("value");
        var prmEpisType = $("#episType_FindUnit").attr("value");
        var prmMg_Code = $(this).attr("data-id");
        var ParamForSubGroup = {
            makeCode: prmMake,
            catalogMarket: prmMarket,
            catalogModel: prmModel,
            episType: prmEpisType,
            mg_Code: prmMg_Code,
        };
        $.ajax({
            type: "GET",
            url: `${serviceUrl}/${prmMake}/${prmMarket}/${prmModel}/${prmEpisType}/${prmMg_Code}/subgroups`,
            contentType: 'application/json',
            beforeSend: function () {
                //$("#overlay").show();
            },
            success: function (msg) {

                var arr = msg.data.subgroups;
                var i;
                var out = "";

                for (i = 0; i < arr.length; i++) {
                    out += "<li><a style='cursor:pointer;' href='#' class='subGroupItem' data-id='" + arr[i].sg_code + "'><b>" + arr[i].sg_code + ".</b>&nbsp;&nbsp;&nbsp;" + arr[i].sg_name + "</a></li>";
                    
                }
                $("#" + idContainer).attr("accesskey", "1");
                $("#" + idContainer).parent().find("#subGroupList").html(out);
            },
            error: function (msg) {
                alert(msg);
            },
            complete: function (ev) {
                event.preventDefault();
                $(event.target).closest('li').toggleClass('active');
                $("#overlay").hide();
                $(".subGroupItem").click(function () {
                    var prmMake = $('#makeCode_FindUnit').attr("value");
                    var prmMarket = $("#catalogMarket_FindUnit").attr("value");
                    var prmModel = $("#catalogModel_FindUnit").attr("value");
                    var prmEpisType = $("#episType_FindUnit").attr("value");
                    var prmSg_Code = $(this).attr("data-id");
                    var txtMainGroup = $("#" + idContainer).text().substr(7, $("#" + idContainer).text().length - 7);
                    var txtSubGroup = $(this).text().substr(7, $(this).text().length - 7);;
                    $("#mainGroup_FindUnit").val(txtMainGroup);
                    $("#subGroup_FindUnit").val(txtSubGroup);
                    $("#LiOfTypeInfo").nextAll().remove();
                    $("#breadcrumb_FindUnit").append("<li class='active'>" + txtMainGroup + "</li><li class='active'>" + txtSubGroup + "</li>");
                    $("#subGroupText_FindUnit").text(txtSubGroup);
                    var ParamForUnit = {
                        makeCode: prmMake,
                        catalogMarket: prmMarket,
                        catalogModel: prmModel,
                        episType: prmEpisType,
                        sg_Code: prmSg_Code,
                    };
                    $.ajax({
                        type: "GET",
                        url: `${serviceUrl}/${prmMake}/${prmMarket}/${prmModel}/${prmEpisType}/${prmSg_Code}/units`,
                        contentType: 'application/json',
                        beforeSend: function () {
                            $("#overlay").show();
                        },
                        success: function (msg) {

                            var arr = msg.data.units;
                            var i;
                            var out = "";

                            for (i = 0; i < arr.length; i++) {
                                //out += "<div class='row' style='border: 1px solid #f1ede6;padding:1px; margin-bottom:10px;'><table class='table-striped table-custom' style='background-color: #f1ede6; width: 100%;'><tbody><tr><th class='text-center' style='width: 25%; border-radius: 0px; border: none; background-color: white;' rowspan='2'><br /><br /><br /><br /><img src='../Content/images/brandLogos/000.png' /> <br /> </th><th class='text-center' style='width:25%;border-radius: 0px; height: 20px; background-color: #6b5f4b; color: white; border-right: 2px solid white; '>Title</th><th class='text-center' style='width:25%;border-radius: 0px; height: 20px; background-color: #6b5f4b; color: white; border-right: 2px solid white; '>Remark</th><th class='text-center' style='width:25%;border-radius: 0px; height: 20px; background-color: #6b5f4b; color: white;'>Model</th></tr><tr><td valign='top' style='padding-left:10px;background-color: #f1ede6;border-right: 2px solid white;'><small>" + arr[i].title + "</small></td><td valign='top' style='padding-left:10px;background-color: #f1ede6;border-right: 2px solid white;'><small>" + arr[i].remark + "</small></td><td valign='top' style='padding-left:10px;background-color: f1ede6;'><p><small>" + arr[i].model + "</small></p></td></tr></tbody></table></div>";
                                if(arr[i].remark == null){arr[i].remark = ""} 
                                if(arr[i].model == null){arr[i].model = ""} 
                                out += "<div data-id='" + arr[i].unit_id + "' class='vag-unit unit_byManual'><div class='unit-drawing'><a><img src='https://cdn.alloversoft.com:8765/unit_drawings/" + arr[i].drawing + "' alt='Drawing' /></a></div><div class='unit-title'><div class='heading'><small>Tanım</small></div><div class='data'><a>" + arr[i].title + "</a></div></div><div class='unit-remark'><div class='heading'><small>Hatırlatma</small></div><div class='data'><a href='#'>" + arr[i].remark + "</a></div></div><div class='unit-model'><div class='heading'><small>Model Bilgisi</small></div><div class='data model'><a>" + arr[i].model + "</a></div></div></div>";
                            }
                            $("#sg-units").html(out);
                            
                        },
                        error: function (msg) {
                            alert(msg);
                        },
                        complete: function () {
                            $("#overlay").hide();
                            $(".vag-unit").click(function () {
                                $("#unitId_FindUnit").val($(this).attr("data-id"));
                                $("#frmFindParts").submit();    
                            });
                        }
                    });
                });
                
            }
        });
    }});

});

function GoToEtka3(){
    var prmMake = $('#makeCode_FindUnit').attr("value");
    var prmMarket = $("#catalogMarket_FindUnit").attr("value");
    var prmModel = $("#catalogModel_FindUnit").attr("value");
    var prmEpisType = $("#episType_FindUnit").attr("value");
    var prmUnitId = $("#unitId_FindUnit").attr("value");
    var prmMainGroup = $("#mainGroup_FindUnit").attr("value");
    var prmSubGroup = $("#subGroup_FindUnit").attr("value");
    var redirectlink = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_etka_3";
    redirectlink+= `&make=${prmMake}&market=${prmMarket}&model=${prmModel}&epis_type=${prmEpisType}&unit_id=${prmUnitId}&mainGroup=${prmMainGroup}&subGroup=${prmSubGroup}`;
    refresh_box('etkaCatalog',`${redirectlink}`,'0');
    void(0);
}
</script>
