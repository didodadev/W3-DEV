<script src="/AddOns/AFM/assets/JS/catalog/catalog.common.js"></script>
<script src="/AddOns/AFM/assets/JS/catalog/catalog.vag.js"></script>

<cfset afmCatalog = CreateObject("component","AddOns.AFM.cfc.AfmCatalogVin")>
<cfset url.vin = trim(url.vin)>
<cfset MainGroupList = afmCatalog.GetMainGroupList(url.vin)>
<cfif arrayLen(MainGroupList) eq 0>
    <script>
        refresh_box('etkaCatalog','index.cfm?fuseaction=objects.emptypopup_etka_1&isVinAvailable=0','0');
    </script>
    <cfabort>
</cfif>
<cfset TypeInfo = afmCatalog.GetTypeInfo(url.vin)>
<cfif not isDefined("TypeInfo.note")>
    <cfset TypeInfo.note = "">
</cfif>
<cfif isdefined("url.mainGroup") and isdefined("url.subGroup")>
    <cfset SubGroupList = afmCatalog.GetSubGroupList(url.vin,url.mainGroup)>
    <cfset UnitList = afmCatalog.GetUnitList(url.vin,url.subgroup)>
<cfelse>
    <cfset url.mainGroup = "">
    <cfset url.subGroup = "">
</cfif>
<div class="main-wrapper">
    <div class="content catalog">
        <div class="container catalog vag">
            <div class="row">
                <div class="col-xs-24">
                    <cfoutput>
                        <h1>
                            <img src="/AddOns\AFM\assets\img/#TypeInfo.make#.svg" alt="#TypeInfo.make#" />
                            #TypeInfo.title#&nbsp;#TypeInfo.note# &nbsp; Parça Kataloğu
                            <small class="current-vin">
                                Şasi No:&nbsp;<a href="##" class="jslink" data-toggle="modal" data-target="##vin-info">#url.vin#<i style="margin-left:-40px;" class="fa fa-search"></i></a>
                            </small>
                        </h1>
                    </cfoutput>

                    <div class="row cat-data group-tree">
                        <div class="col-xs-12 col-sm-6">
                            <nav>
                                <ul class="nav sidenav nav-pills nav-stacked" id="sidemenu">     
                                    <cfloop array="#MainGroupList#" item="item" index="item_idx">
                                        <li role="presentation" class="active">
                                            <cfoutput><a style="cursor:pointer; padding: 10px 15px!important;" class="subGroup_FindUnit_ByVin" accesskey="0" id="primary-item-container-0#item_idx#" data-id="#item.mg_code#"><b>#item.mg_code# .</b>&nbsp;&nbsp;&nbsp; #item.mg_name#</a></cfoutput>
                                            <ul id="subGroupList">

                                            </ul>
                                        </li>
                                    </cfloop>
                                </ul>
                            </nav>
                        </div>
                        <div class="modal fade" id="vin-info" tabindex="-1" role="dialog" aria-labelledby="vin-info-head" aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"></button>
                                        <cfoutput><h4 class="modal-title" id="vin-info-head">#TypeInfo.title#&nbsp;#TypeInfo.note# &nbsp;(#url.vin#) Araç Bilgileri</h4></cfoutput>
                                    </div>
                                    <div class="modal-body">
                                        <dl class="dl-horizontal">
                                            <cfoutput>
                                                <dt>Araç Modeli:</dt>
                                                <dd>#TypeInfo.title# <span class="model-desc">#TypeInfo.note#</span></dd>
                                                <dt>Motor Kodu:</dt>
                                                <dd>#TypeInfo.engine_code#</dd>
                                                <dt>Motor Hacmi:</dt>
                                                <dd>#TypeInfo.engine_cc#</dd>
                                                <dt>Motor Gücü:</dt>
                                                <dd>#TypeInfo.engine_hp#&nbsp;HP (#TypeInfo.engine_kw#&nbsp;kW)</dd>
                                                <dt>Şanzuman Kodu:</dt>
                                                <dd>#TypeInfo.transmission_code#</dd>
                                                <dt>Modeli:</dt>
                                                <dd>#TypeInfo.model_year#</dd>
                                            </cfoutput>
                                        </dl>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-default" data-dismiss="modal">Kapat</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <cfform id="frmFindParts_ByVIN" action="javascript:goToEtkaVinParts();" type="GET">
                            <input type="hidden" name="unit_id" id="unitId_FindUnit" />
                            <input type="hidden" name="vin" id="vin_number_FindUnit_ByVin" value="<cfoutput>#url.vin#</cfoutput>" />
                            <input type="hidden" name="mainGroup" id="mainGroup_FindUnit" value="<cfscript>if(isDefined('MainGroupList')){arrayEach(MainGroupList,function(m,idx){if(m.mg_code == url.mainGroup){writeOutput(m.mg_name)}})}</cfscript>"/>
                            <input type="hidden" name="subGroup" id="subGroup_FindUnit" value="<cfscript>if(isDefined('SubGroupList')){arrayEach(SubGroupList,function(s,idx){if(s.sg_code == url.subGroup){writeOutput(s.sg_name)}})}</cfscript>" />

                            <div class="col-xs-12 col-sm-18 sg-units-col" id="sg-units">
                                <cfif isDefined("UnitList")>
                                    <cfloop array="#UnitList#" item="item" index="item_idx">
                                        <div data-id='#item.unit_id#' class='vag-unit unit_byVin <cfif item.is_compatible=="False">"not-compatible"<cfelse>""</cfif>'>
                                            <cfoutput>
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
                                            </cfoutput>
                                        </div>
                                    </cfloop>
                                </cfif>
                            </div>
                        </cfform>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<script>
$('.mainGroup_item_byvin').on('click', function (event) {
    
    if ($(this).attr("accesskey") == "0") {
        var mgContainer = $(this).attr("id");
        var prmMg_Code = $(this).attr("data-mg");
        var prmVinNumber = $("#vin_number_hidden").val();
        var ParamForSubGroup = {
            vin: prmVinNumber,
            mg_Code: prmMg_Code,
            
        };
        $.ajax({
            type: "GET",
            url: `${serviceUrl}/${prmVinNumber}/${prmMg_Code}/subgroups`,
            contentType: 'application/json',
            beforeSend: function () {
            },
            success: function (msg) {

                var arr = msg.data.subgroups;
                var i;
                var out = "<ul>";

                for (i = 0; i < arr.length; i++) {
                    out += "<li><a class='subGroup_item' style='cursor:pointer;' data-mg='" + prmMg_Code + "' data-sg='" + arr[i].sg_code + "'><b>" + arr[i].sg_code + ".</b>&nbsp;&nbsp;&nbsp;" + arr[i].sg_name + "</a></li>";

                }
                out += "</ul>";
                $("#" + mgContainer).attr("accesskey", "1");
                $("#" + mgContainer).nextAll().remove();
                $("#" + mgContainer).parent().append(out);
            },
            error: function (msg) {
                alert(msg);
            },
            complete: function (ev) {
                event.preventDefault();
                //$(event.target).closest('li').toggleClass('active');
                $(".subGroup_item").click(function () {
                    //mainGroup_FindParts
                    //subGroup_FindParts

                    $("#vin_number_FindUnit_ByVin").val($(this).attr("id"));
                    $("#mainGroup_FindParts").val($(this).attr("data-mg"));
                    $("#subGroup_FindParts").val($(this).attr("data-sg"));

                    $("#frmFindUnitByMainGroup").submit();
                });
                $("#overlay").hide();


            }
        });
    }
});

$(".unit_byVin").click(function () {
    $("#unitId_FindUnit").val($(this).attr("data-id"));
    $("#frmFindParts_ByVIN").submit();
});

$('.subGroup_FindUnit_ByVin').on('click', function (event) {
    if ($(this).attr("accesskey") == "0") {
        var idContainer = $(this).attr("id");
        var prmVinNumber = $("#vin_number_FindUnit_ByVin").val();
        var prmMg_Code = $(this).attr("data-id");
        var ParamForSubGroup = {
            vin: prmVinNumber,
            mg_Code: prmMg_Code,
        };
        sessionStorage.setItem('Catalog_MgKode', prmMg_Code);
        sessionStorage.removeItem('Catalog_sgCode');
        $.ajax({
            type: "GET",
            url: `${serviceUrl}/${prmVinNumber}/${prmMg_Code}/subgroups`,
            contentType: 'application/json',
            beforeSend: function () {
               // $("#overlay").show();
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
                    
                    var prmSg_Code = $(this).attr("data-id");
                    var txtMainGroup = $("#" + idContainer).text().substr(7, $("#" + idContainer).text().length - 7);;
                    var txtSubGroup = $(this).text().substr(7, $(this).text().length - 7);;
                    $("#mainGroup_FindUnit").val(txtMainGroup);
                    $("#subGroup_FindUnit").val(txtSubGroup);
                    $("#LiOfTypeInfo").nextAll().remove();
                    $("#breadcrumb_FindUnit").append("<li class='active'>" + txtMainGroup + "</li><li class='active'>" + txtSubGroup + "</li>");
                    $("#subGroupText_FindUnit").text(txtSubGroup);
                    var ParamForUnit = {
                        vin: prmVinNumber,
                        sg_Code: prmSg_Code,
                    };
                    sessionStorage.setItem('Catalog_sgCode', prmSg_Code);

                    $.ajax({
                        type: "GET",
                        url: `${serviceUrl}/${prmVinNumber}/${prmSg_Code}/units`,
                        contentType: 'application/json',
                        beforeSend: function () {
                            //$("#overlay").show();
                        },
                        success: function (msg) {

                            var arr = msg.data.units;
                            var i;
                            var out = "";

                            for (i = 0; i < arr.length; i++) {
                                //out += "<div class='row' style='border: 1px solid #f1ede6;padding:1px; margin-bottom:10px;'><table class='table-striped table-custom' style='background-color: #f1ede6; width: 100%;'><tbody><tr><th class='text-center' style='width: 25%; border-radius: 0px; border: none; background-color: white;' rowspan='2'><br /><br /><br /><br /><img src='../Content/images/brandLogos/000.png' /> <br /> </th><th class='text-center' style='width:25%;border-radius: 0px; height: 20px; background-color: #6b5f4b; color: white; border-right: 2px solid white; '>Title</th><th class='text-center' style='width:25%;border-radius: 0px; height: 20px; background-color: #6b5f4b; color: white; border-right: 2px solid white; '>Remark</th><th class='text-center' style='width:25%;border-radius: 0px; height: 20px; background-color: #6b5f4b; color: white;'>Model</th></tr><tr><td valign='top' style='padding-left:10px;background-color: #f1ede6;border-right: 2px solid white;'><small>" + arr[i].title + "</small></td><td valign='top' style='padding-left:10px;background-color: #f1ede6;border-right: 2px solid white;'><small>" + arr[i].remark + "</small></td><td valign='top' style='padding-left:10px;background-color: f1ede6;'><p><small>" + arr[i].model + "</small></p></td></tr></tbody></table></div>";
                                var is_compatible = "";
                                if (arr[i].is_compatible == "False") {
                                    is_compatible = "not-compatible";
                                }
                                if(arr[i].remark == null){arr[i].remark = ""} 
                                if(arr[i].model == null){arr[i].model = ""} 
                                out += "<div data-id='" + arr[i].unit_id + "' class='vag-unit unit_byVin " + is_compatible + "'><div class='unit-drawing'><a><img src='https://cdn.alloversoft.com:8765/unit_drawings/" + arr[i].drawing + "' alt='Drawing' /></a></div><div class='unit-title'><div class='heading'><small>Tanım</small></div><div class='data'><a>" + arr[i].title + "</a></div></div><div class='unit-remark'><div class='heading'><small>Hatırlatma</small></div><div class='data'><a href='#'>" + arr[i].remark + "</a></div></div><div class='unit-model'><div class='heading'><small>Model Bilgisi</small></div><div class='data'><a>" + arr[i].model + "</a></div></div></div>";
                                
                            }
                            $("#sg-units").html(out);

                        },
                        error: function (msg) {
                            alert(msg);
                        },
                        complete: function () {
                            //$("#overlay").hide();
                            $(".vag-unit").click(function () {
                                $("#unitId_FindUnit").val($(this).attr("data-id"));
                                $("#frmFindParts_ByVIN").submit();
                            });
                        }
                    });
                });

            }
        });
    }
});
function goToEtkaVinParts() {
    var prmVin = document.getElementById("vin_number_FindUnit_ByVin").value;
    var prmUnitId = $("#unitId_FindUnit").attr("value");
    var redirectlink = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.emptypopup_etka_vin_findparts";
    redirectlink+= `&vin=${prmVin}&unit_id=${prmUnitId}`;
    refresh_box('etkaCatalog',`${redirectlink}`,'0');
    void(0);
}
</script>