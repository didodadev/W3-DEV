<cfprocessingdirective pageEncoding="utf8">
<cfset afmCatalog = CreateObject("component","AddOns.AFM.cfc.AfmCatalog")>
<cfset MainGroupList = afmCatalog.GetMainGroupList(url.make,url.market,url.model,url.epis_type)>
<cfset TypeInfo = afmCatalog.GetTypeInfo(url.make,url.market,url.model,url.epis_type)>
<cfset UnitPartList = afmCatalog.GetUnitPartList(url.make,url.market,url.model,url.epis_type,url.unit_id)>
<cfset UnitInfo = afmCatalog.GetUnit(url.make,url.market,url.model,url.epis_type,url.unit_id)>
<cfset SubUnitList = afmCatalog.GetSubUnitList(url.make,url.market,url.model,url.epis_type,url.unit_id)>
<cfset cdnServer = "https://cdn.alloversoft.com:8765">
<div class="main-wrapper">
    <input type="hidden" id="OrderType" value="S" />
    <div class="content catalog">
        <div class="container catalog vag">
            <div class="row">
                <div class="col-12">
                    <div class="row">
                        <div class="col-12 cat-head">
                            <h1>
                                <img src="/AddOns\AFM\assets\img/<cfoutput>#url.make#</cfoutput>.svg" alt="Audi" />
                                <cfoutput>#url.model#&nbsp;(#TypeInfo.year_from#...#TypeInfo.year_to#) #url.mainGroup#, <cfif not isDefined("UnitInfo")>""<cfelse>#replace(UnitInfo.title,"<br>","")#</cfif></cfoutput>
                            </h1>
                        </div>
                    </div>
                    <div class="row cat-data">
                        <div class="col-xs-12 col-sm-12 col-5" id="unit-dwg-col">
                            <div id="affix-left-pane">
                                <div id="group-btn-container">
                                    <cfoutput>
                                        <input type="hidden" name="make" value="#url.make#" id="makeCode_FindParts" />
                                        <input type="hidden" name="model" value="#url.model#" id="catalogModel_FindParts" />
                                        <input type="hidden" name="market" value="#url.market#" id="catalogMarket_FindParts" />
                                        <input type="hidden" name="epis_type" value="#url.epis_type#" id="episType_FindParts" />
                                        <input type="hidden" name="unit_id" value="#url.unit_id#" id="unitId_FindParts"  />
                                        <input type="hidden" name="mainGroup" id="mainGroup_FindParts" />
                                        <input type="hidden" name="subGroup" id="subGroup_FindParts" />
                                    </cfoutput>
                                    <div class="dropdown pull-left">
                                        <a id="group-tree-dd-btn" class="btn btn-primary" data-target="#" href="#" data-toggle="dropdown" aria-haspopup="true" role="button" aria-expanded="false">
                                            <svg>
                                                    <path class="group-tree-icon" d="M3 7l1 0 0 -1c0,0 0,0 0,0 0,-1 1,-1 1,-1l2 0c1,0 1,0 1,1 0,0 0,0 0,0l0 3c0,0 0,0 0,0 0,0 0,0 -1,0l-2 0c0,0 -1,0 -1,0 0,0 0,0 0,0l0 -1 -1 0 0 2 0 0 0 2 1 0 0 -1c0,0 0,0 0,0 0,-1 1,-1 1,-1l2 0c1,0 1,0 1,1 0,0 0,0 0,0l0 2c0,1 0,1 0,1 0,0 0,0 -1,0l-2 0c0,0 -1,0 -1,0 0,0 0,0 0,-1l0 0 -1 0c-1,0 -1,0 -1,-1 0,0 0,0 0,0l0 -8 0 0 -1 0c0,0 -1,0 -1,0 0,0 0,0 0,0l0 -3c0,0 0,-1 0,-1 0,0 1,0 1,0l3 0c0,0 0,0 0,0 0,0 0,1 0,1l0 3c0,0 0,0 0,0 0,0 0,0 0,0l-1 0 0 0 0 3z"></path>
                                                </svg>
                                            Montaj Grupları
                                            <i class="fa fa-fw fa-caret-down"></i>
                                        </a>

                                        <ul class="dropdown-menu dd-group-tree-menu" role="menu" aria-labelledby="group-tree-dd-btn">
                                        <cfloop array="#MainGroupList#" index="mg_index" item="mg_current">
                                                <li role="presentation">
                                                    <cfoutput><a id="mg_#mg_current.mg_code#" class="mainGroup_item" accesskey="0" href="##" data-mg="#mg_current.mg_code#"><b>#mg_current.mg_code# .</b>&nbsp;&nbsp;&nbsp; #mg_current.mg_name#</a></cfoutput>
                                                </li>
                                            </cfloop>
                                        </ul>
                                    </div>
                                </div>
                                <div id="unit-dwg-container">

                                    <cfoutput><img src="#cdnServer#/unit_drawings/#UnitInfo.drawing#" alt="Drawing" id="unit-dwg" /></cfoutput>
                                    <div class="zoom-btn-container">
                                        <a class="btn btn-default btn-xs zoom-btn" id="zoom-in-btn" href="#"><i class="fa fa-fw fa-search-plus"></i></a>
                                        <a class="btn btn-default btn-xs zoom-btn hidden" id="zoom-out-btn" href="#"><i class="fa fa-fw fa-search-minus"></i></a>
                                    </div>

                                    <cfloop array="#UnitPartList#" index="part_idx" item="item">
                                        <cfif isDefined("item.drawing_hotspots") and arrayLen(item.drawing_hotspots)>
                                            <cfloop array="#item.drawing_hotspots#" item="hotSpots" index="hotspot_idx">
                                                <cfoutput><a class="hotspot" href="##" data-hsname="#item.drawing_pos#" data-hsleft="#hotSpots.Left#" data-hstop="#hotSpots.Top#" data-hswidth="#hotSpots.Width#" data-hsheight="#hotSpots.Height#"></a></cfoutput>
                                            </cfloop>
                                        </cfif>
                                    </cfloop>
                                </div>
                            </div>  
                        </div>
                        <div class="col-xs-12 col-sm-12 col-md-7 col-lg-7 col-7 unit-parts-col" id="unit-parts-col">

                                <form class="unselectable" action="#">
                                    <table class="table table-striped table-bordered table-custom table-vag" id="unit-parts-tbl">
                                        <thead id="parts-table-head">
                                            <tr>
                                                <th width="37"><span class="sr-only">Parça Bilgisi</span></th>
                                                <th width="23"><span class="sr-only">Seçili</span></th>
                                                <th width="35"><small>Poz</small></th>
                                                <th class="hidden-xs hidden-md"><small>Parça No</small></th>
                                                <th><small>Tanım</small></th>
                                                <th><small>Hatırlatma</small></th>
                                                <th><small>Adet</small></th>
                                                <th><small>Model Bilgisi</small></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <cfif isDefined("UnitInfo.sys_remark")>
                                                <tr class="unit-sys-remark">
                                                    <td colspan="8"><div class="alert alert-warning alert-dismissible" role="alert"><button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>@(new HtmlString(Model.unitInfo.sys_remark))</div></td>
                                                </tr>
                                            </cfif>
                                            <cfset SubUnitId = "">
                                            <cfloop array="#UnitPartList#" item="item" index="item_idx">
                                                <cfif item.subunit_id neq SubUnitId>
                                                    <tr class="subunit" data-subunit-id="2586">
                                                        <td class="btn-cell"></td>
                                                        <td class="checkbox-cell"></td>
                                                        <td class="dwg-pos"></td>
                                                        <td class="partno hidden-xs hidden-md"></td>
                                                        <td class="desc"><cfscript>arrayEach(SubUnitList,function(su,idx){if(su.subunit_id == item.subunit_id){writeOutput(su.title)}})</cfscript></td>
                                                        <td class="remark"><cfscript>arrayEach(SubUnitList,function(su,idx){if(su.subunit_id == item.subunit_id){writeOutput(su.remark)}})</cfscript></td>
                                                        <td class="qty"></td>
                                                        <td class="model"><cfscript>arrayEach(SubUnitList,function(su,idx){if(su.subunit_id == item.subunit_id){writeOutput(su.model)}})</cfscript></td>
                                                    </tr>
                                                    <cfset SubUnitId = item.subunit_id>
                                                </cfif>
                                                <cfoutput><tr class="part part_add_basket" data-part-id="#item.part_id#" data-part-no="<cfif isDefined("item.part_no")>#item.part_no#</cfif>" data-dwg-pos="#item.drawing_pos#" data-is-composite="#item.is_composite#" data-is-component="#item.is_component#"></cfoutput>
                                                    <td class="btn-cell">
                                                        <cfif isDefined("item.part_no")>
                                                            <a href="#" class="btn btn-sm btn-part-info partInformationIcon" data-toggle="modal" data-target="#part-info">
                                                                <i class="fa fa-fw fa-info-circle text-info"></i>
                                                                <span class="sr-only">Parça Bilgisi</span>
                                                            </a>
                                                        </cfif>
                                                        <div class="hidden part-info-store">
                                                            <cfif isDefined("item.linked_parts")>
                                                                <div class="linked-parts">
                                                                    <h5><cfif item.linked_parts.link_type eq "ALSO_USE">Ayrıca Kullanın<cfelse>Gerekliyse Kullanın</cfif></h5>
                                                                    <table class="table table-striped table-bordered table-custom table-vag-modal">
                                                                        <thead>
                                                                            <tr>
                                                                                <th>Parça No</th>
                                                                                <th>Adet</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            <cfif isDefined("item.linked_parts.parts")>
                                                                                <cfloop array="#item.linked_parts.parts#" item="linked_part" index="lp_idx">
                                                                                    <tr>
                                                                                        <cfoutput>
                                                                                            <td>#linked_part.part_no#</td>
                                                                                            <td>#linked_part.quantity#</td>
                                                                                        </cfoutput>
                                                                                    </tr>
                                                                                </cfloop>
                                                                            </cfif>
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            </cfif>
                                                        
                                                            <cfif isDefined("item.sys_remark")>
                                                                <div class="part-sys-remark"><cfif isDefined("item.sys_remark")><cfoutput>#item.sys_remark#</cfoutput></cfif></div>
                                                            </cfif>
                                                        </div>           
                                                    </td>
                                                    <td class="checkbox-cell">
                                                        <div class="checkbox">
                                                            <label>
                                                                <cfoutput><input type="checkbox" name="selected-parts[]" class="part-checkbox" value="<cfif isDefined("item.part_no")>#item.part_no#</cfif>" aria-label="Select/deselect the part"></cfoutput>
                                                            </label>
                                                        </div>
                                                    </td>
                                                    <cfoutput>
                                                        <td class="dwg-pos"><span class="visible-xs visible-md"><br></span><cfif isDefined("item.drawing_pos")>#item.drawing_pos#</cfif></td>
                                                        <td class="partno hidden-xs hidden-md"><cfif isDefined("item.part_no")>#item.part_no#</cfif></td>
                                                        <td class="desc"><span class="visible-xs visible-md partno-in-desc-col"><cfif isDefined("item.part_no")>#item.part_no#</cfif></span><cfif isDefined("item.part_no")>#item.title#</cfif></td>
                                                        <td class="remark"><cfif isDefined("item.remark")>#item.remark#</cfif></td>
                                                        <td class="qty"><cfif isDefined("item.quantity")>#item.quantity#</cfif></td>
                                                        <td class="model"><cfif isDefined("item.model")>#item.model#</cfif></td>
                                                    </cfoutput>
                                                </tr>
                                            </cfloop>
                                        </tbody>
                                    </table>
                                </form>
                            </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="/AddOns/AFM/assets/JS/catalog/catalog.common.js"></script>
<script src="/AddOns/AFM/assets/JS/catalog/catalog.vag.js"></script>