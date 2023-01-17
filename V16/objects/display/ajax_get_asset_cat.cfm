<cfif isdefined("attributes.isAjax")><cf_xml_page_edit fuseact="settings.asset_cat"></cfif>
<cfset Assetcfc= createObject("component","V16.objects.cfc.get_ajax_asset_cat")>
<cfset DIGITAL_ASSET_GROUP_PERM=Assetcfc.DigitalAssetGroupPerm()>  
<cfset GROUP_PERM_LIST = "">
<cfoutput query="DIGITAL_ASSET_GROUP_PERM">
       <cfset GROUP_PERM_LIST = ListAppend(GROUP_PERM_LIST,GROUP_ID)>
</cfoutput>
<cfset GET_ASSET_CAT = Assetcfc.GetAssetCat( bottomCat: isdefined('attributes.bottomCat') ? attributes.bottomCat : "" ) />  
<style>.display-visible .ui-list{display:block!important;}</style>
<cfif GET_ASSET_CAT.recordcount>
    <cfif not IsDefined("attributes.bottomCat")>
     <!---    <div class="cat-bar-header col col-12">
         
            <cfif not isdefined('attributes.chooseCat')>
                <cfif IsDefined("attributes.isAjax") or attributes.fuseaction contains 'popup'>
                    <div class="col col-3 add-cat">
                        <cfif attributes.fuseaction contains 'popup'>
                            <i class="fa fa-plus" onclick="document.location = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat';"></i>
                        <cfelse>
                            <i class="fa fa-plus" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_asset_cat','list');"></i>
                        </cfif>
                    </div>
                <cfelse>
                    <div class="col col-3 add-cat"><i class="fa fa-plus" onclick="document.location = '<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_asset_cat'"></i></div>
                </cfif>
            </cfif>
        </div> --->
        <ul class="ui-list">
            <cfoutput query = "GET_ASSET_CAT">
                <li id="cat_#ASSETCAT_ID#">
                    <a href="javascript://">
                        <div class="ui-list-left">
                            <span class="ui-list-icon ctl-school-material" <cfif not isdefined('attributes.chooseCat')> <cfif IsDefined("attributes.isAjax")>  onclick="chooseCat(#ASSETCAT_ID#,'#ASSETCAT#')"<cfelse> <cfif attributes.fuseaction contains 'popup'> onclick="document.location ='#request.self#?fuseaction=objects.popup_upd_asset_cat&ID=#ASSETCAT_ID#&mainCatName=#ASSETCAT#'" <cfelse> onclick="document.location ='#request.self#?fuseaction=settings.form_upd_asset_cat&ID=#ASSETCAT_ID#&mainCatName=#ASSETCAT#'"</cfif> </cfif> <cfelse> onclick="chooseCat(#ASSETCAT_ID#,'#ASSETCAT#')"</cfif>></span>
							<span <cfif not isdefined('attributes.chooseCat')> <cfif IsDefined("attributes.isAjax")>  onclick="chooseCat(#ASSETCAT_ID#,'#ASSETCAT#')"<cfelse> <cfif attributes.fuseaction contains 'popup'> onclick="document.location ='#request.self#?fuseaction=objects.popup_upd_asset_cat&ID=#ASSETCAT_ID#&mainCatName=#ASSETCAT#'" <cfelse> onclick="document.location ='#request.self#?fuseaction=settings.form_upd_asset_cat&ID=#ASSETCAT_ID#&mainCatName=#ASSETCAT#'"</cfif> </cfif> <cfelse> onclick="chooseCat(#ASSETCAT_ID#,'#ASSETCAT#')"</cfif>>#ASSETCAT#</span>
                        </div>
                        <div class="ui-list-right">
                            <i class="fa fa-caret-right" onclick="getBottomCat('#ASSETCAT_ID#',this,<cfif IsDefined("attributes.isAjax")>0<cfelse>1</cfif>,<cfif IsDefined("attributes.chooseCat")>1<cfelse>0</cfif>)"></i>
                                <cfif not isdefined('attributes.chooseCat')>
                                    <i  class="fa fa-ellipsis-v"></i>
                            </cfif>
                        </div>
                        
                    </a>
                    <ul id="selectCat-Dropdown_#ASSETCAT_ID#">
                        <cfif IsDefined("attributes.isAjax")>
                            <li>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_asset_cat&mainCat=#ASSETCAT_ID#&mainCatName=#ASSETCAT#','list');">
                                    <div class="ui-list-left">
                                        <span class="ui-list-icon ctl-office-material-2"></span>
                                        <cf_get_lang dictionary_id="48601.Yeni Klasör">
                                    </div>
                                </a>
                            </li>
                            <li>
                                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_asset_cat&ID=#ASSETCAT_ID#&mainCatName=#ASSETCAT#','list');">
                                    <div class="ui-list-left">
                                        <span class="ui-list-icon ctl-writer-1"></span>
                                        <cf_get_lang dictionary_id="57464.Güncelle">
                                    </div>
                                </a>
                            </li>
                        <cfelse>
                            <cfif attributes.fuseaction contains 'popup'>
                                <li>
                                    <a href="#request.self#?fuseaction=objects.popup_add_asset_cat&mainCat=#ASSETCAT_ID#&mainCatName=#ASSETCAT#">
                                        <div class="ui-list-left">
                                            <span class="ui-list-icon ctl-office-material-2"></span>
                                            <cf_get_lang dictionary_id="48601.Yeni Klasör">
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <a href="#request.self#?fuseaction=objects.popup_upd_asset_cat&ID=#ASSETCAT_ID#&mainCatName=#ASSETCAT#">
                                        <div class="ui-list-left">
                                            <span class="ui-list-icon ctl-writer-1"></span>
                                            <cf_get_lang dictionary_id="57464.Güncelle">
                                        </div>
                                    </a>
                                </li>
                            <cfelse>
                                <li>
                                    <a href="#request.self#?fuseaction=settings.form_add_asset_cat&mainCat=#ASSETCAT_ID#&mainCatName=#ASSETCAT#">
                                        <div class="ui-list-left">
                                            <span class="ui-list-icon ctl-office-material-2"></span>
                                            <cf_get_lang dictionary_id="48601.Yeni Klasör">
                                        </div>
                                    </a>
                                </li>
                                <li>
                                    <a href="#request.self#?fuseaction=settings.form_upd_asset_cat&ID=#ASSETCAT_ID#&mainCatName=#ASSETCAT#">
                                        <div class="ui-list-left">
                                            <span class="ui-list-icon ctl-writer-1"></span>
                                            <cf_get_lang dictionary_id="57464.Güncelle">
                                        </div>
                                    </a>
                                </li>
                            </cfif>
                        </cfif>
                    </ul>
                </li>
            </cfoutput>
        </ul>
        <script>
            function getBottomCat(catid,element,form,chooseCat){
                if(form == 1) var form = "&form=1";
                else var form = "";
                if(chooseCat == 1) var chooseCat = "&chooseCat";
                else var chooseCat = "";
                var url = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.ajax_get_asset_cat&bottomCat="+catid+form+chooseCat;
		        if($(element).hasClass("fa-caret-right")){
                    $(element).removeClass("fa-caret-right").addClass("fa-caret-down");
                    $("<div>").addClass("display-visible").attr({"id":"catbottom_"+catid+""}).appendTo("#cat_"+catid);
                    AjaxPageLoad(url,"catbottom_"+catid+"");
                }else {
                    $(element).removeClass("fa-caret-down").addClass("fa-caret-right");
                    $("div#catbottom_"+catid+"").remove();
                }
            }
            /* When the user clicks on the button, 
            toggle between hiding and showing the dropdown content */
            function dropFunction(dropid) {
                document.getElementById(dropid).classList.toggle("cat-dropDown-show");
            }

            // Close the dropdown if the user clicks outside of it
            window.onclick = function(event) {
                if (!event.target.matches('.dropbtn')) {
                    var dropdowns = document.getElementsByClassName("cat-dropdown-content");
                    var i;
                    for (i = 0; i < dropdowns.length; i++) {
                        var openDropdown = dropdowns[i];
                        if (openDropdown.classList.contains('cat-dropDown-show')) {
                            openDropdown.classList.remove('cat-dropDown-show');
                        }
                    }
                }
            }
        </script>
    <cfelse>
        <ul class="ui-list">
            <cfoutput query = "GET_ASSET_CAT">
                <li id="cat_#ASSETCAT_ID#">
                    <a href="javascript://">
                        <div class="ui-list-left">
                            <cfif not isdefined('attributes.chooseCat')>
                                <span class="ui-list-icon ctl-school-material" onclick="chooseCat(#ASSETCAT_ID#,'#ASSETCAT#')"></span>#ASSETCAT#
                            <cfelse>
                                <span class="ui-list-icon ctl-school-material" onclick="chooseCat(#ASSETCAT_ID#,'#ASSETCAT#')"></span>#ASSETCAT#
                            </cfif>
                        </div>
                        <cfif not isdefined('attributes.chooseCat')>
                            <div class="ui-list-right">
                                <i class="fa fa-caret-right" onclick="getBottomCat('#ASSETCAT_ID#',this,<cfif IsDefined("attributes.form")>1<cfelse>0</cfif>,<cfif IsDefined("attributes.chooseCat")>1<cfelse>0</cfif>)"></i>
                                <i class="fa fa-ellipsis-v"></i>
                            </div>
                                <!--- <i onclick="dropFunction('selectCat-Dropdown_#ASSETCAT_ID#')" class="dropbtn fa fa-ellipsis-v"></i> --->
                            <ul id="selectCat-Dropdown_#ASSETCAT_ID#">
                                <cfif IsDefined("attributes.form")>
                                    <li>
                                        <a href="javascript://" onclick="document.location = '#request.self#?fuseaction=settings.form_add_asset_cat&mainCat=#ASSETCAT_ID#&mainCatName=#ASSETCAT#'"> 
                                            <div class="ui-list-left">
                                                <span class="ui-list-icon ctl-office-material-2"></span>
                                                <cf_get_lang dictionary_id="48601.Yeni Klasör">
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript://" onclick="document.location = '#request.self#?fuseaction=settings.form_upd_asset_cat&ID=#ASSETCAT_ID#&mainCatName=#ASSETCAT#'"><cf_get_lang dictionary_id="57464.Güncelle">
                                            <div class="ui-list-left">
                                                <span class="ui-list-icon ctl-writer-1"></span>
                                                <cf_get_lang dictionary_id="57464.Güncelle">
                                            </div>
                                        </a>
                                    </li>
                                <cfelse>
                                    <li>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_asset_cat&mainCat=#ASSETCAT_ID#&mainCatName=#ASSETCAT#','list');"><cf_get_lang dictionary_id="48601.Yeni Klasör">
                                            <div class="ui-list-left">
                                                <span class="ui-list-icon ctl-office-material-2"></span>
                                                <cf_get_lang dictionary_id="48601.Yeni Klasör">
                                            </div>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_upd_asset_cat&ID=#ASSETCAT_ID#&mainCatName=#ASSETCAT#','list');">
                                            <div class="ui-list-left">
                                                <span class="ui-list-icon ctl-writer-1"></span>
                                                <cf_get_lang dictionary_id="57464.Güncelle">
                                            </div>
                                        </a>
                                    </li>
                                </cfif>
                            </ul>
                        <cfelse>
                            <div class="ui-list-right">
                                <i class="fa fa-caret-right" onclick="getBottomCat('#ASSETCAT_ID#',this,<cfif IsDefined("attributes.form")>1<cfelse>0</cfif>,<cfif IsDefined("attributes.chooseCat")>1<cfelse>0</cfif>)"></i>
                             
                            </div>
                        </cfif>
                    </a>
                </li>
            </cfoutput>
        </ul>
    </cfif>
<cfelse>
    <ul class="ui-list">
        <li><a href="javascript://"><cf_get_lang dictionary_id = "57484.Kayıt Yok">!</a></li>
    </ul>
</cfif>
<script>
    	$('.ui-list li a i.fa-ellipsis-v').click(function(){
		$(this).closest('.ui-list-right').toggleClass("ui-list-right-open");
		$(this).closest('li').find("> ul").fadeToggle();
	});
</script>