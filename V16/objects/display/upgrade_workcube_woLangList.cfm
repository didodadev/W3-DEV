<cffunction name="getFromService">
    <cfargument name = "serviceName" required="no" default="">

    <cfset woLang = CreateObject("component","cfc.upgrade_workcube_woLang").initialize(
        serviceName : '#attributes.serviceName#',
        start_date : '#application.upgradeSystem.last_release_date#',
        finish_date : '#application.upgradeSystem.release_date#'
    )>

    <cfreturn DeserializeJson(woLang.getWoLang())/>

</cffunction>
<cfif attributes.serviceName eq 'getNewLangs'>

    <cfset AddedLangData = getFromService()>
    <cfif AddedLangData.status>
        <table class="workDevList">
            <thead>
                <tr>
                    <th>Language</th>
                    <th>Language Short</th>
                    <th>Is Active</th>
                </tr>
            </thead>
            <tbody>
                <cfloop from="1" to="#arrayLen(AddedLangData.data)#" index="i">
                    <tr>
                        <td><cfoutput>#AddedLangData.data[i]["LANGUAGE_SET"]#</cfoutput></td>
                        <td><cfoutput>#AddedLangData.data[i]["LANGUAGE_SHORT"]#</cfoutput></td>
                        <td><cfoutput>#AddedLangData.data[i]["IS_ACTIVE"]#</cfoutput></td>
                    </tr>
                </cfloop>
            </tbody>
        </table>
    <cfelse>
        Yeni eklenen dil bulunamadı
    </cfif>
       
<cfelseif attributes.serviceName eq 'getNewLanguages'>

    <cfset AddedLangData = getFromService() />
    <cfset UpdatedLangData = getFromService("getUpdatedLanguages") />

    <div id="tab-container" class="tabStandart margin-top-5">
        <div id="tab-head">
            <ul class="tabNav">
                <li class="active"><a href="#addedLanguage">Added Languages</a></li>
                <li class=""><a href="#updatedLanguage">Updated Languages</a></li>													
            </ul>
        </div>

        <div style="clear:both;"></div>
        
        <div id="tab-content" class="margin-top-10"> 
            <div id="addedLanguage" class="content row"> 												
                <cfif AddedLangData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>ITEM</th>
                                <th>ITEM_TR</th>
                                <th>ITEM_ARB</th>
                                <th>ITEM_DE</th>
                                <th>ITEM_ENG</th>
                                <th>ITEM_ES</th>
                                <th>ITEM_RUS</th>
                                <th>ITEM_UKR</th>
                                <th>ITEM_FR</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(AddedLangData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#AddedLangData.data[i]["ITEM"]#</cfoutput></td>
                                    <td><cfoutput>#AddedLangData.data[i]["ITEM_TR"]#</cfoutput></td>
                                    <td><cfoutput>#AddedLangData.data[i]["ITEM_ARB"]#</cfoutput></td>
                                    <td><cfoutput>#AddedLangData.data[i]["ITEM_DE"]#</cfoutput></td>
                                    <td><cfoutput>#AddedLangData.data[i]["ITEM_ENG"]#</cfoutput></td>
                                    <td><cfoutput>#AddedLangData.data[i]["ITEM_ES"]#</cfoutput></td>
                                    <td><cfoutput>#AddedLangData.data[i]["ITEM_RUS"]#</cfoutput></td>
                                    <td><cfoutput>#AddedLangData.data[i]["ITEM_UKR"]#</cfoutput></td>
                                    <td><cfoutput>#AddedLangData.data[i]["ITEM_FR"]#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Yeni eklenen dil bulunamadı
                </cfif>
            </div>
            <div id="updatedLanguage" class="content row">
                <cfif UpdatedLangData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>ITEM</th>
                                <th>ITEM_TR</th>
                                <th>ITEM_ARB</th>
                                <th>ITEM_DE</th>
                                <th>ITEM_ENG</th>
                                <th>ITEM_ES</th>
                                <th>ITEM_RUS</th>
                                <th>ITEM_UKR</th>
                                <th>ITEM_FR</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(UpdatedLangData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#UpdatedLangData.data[i]["ITEM"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedLangData.data[i]["ITEM_TR"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedLangData.data[i]["ITEM_ARB"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedLangData.data[i]["ITEM_DE"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedLangData.data[i]["ITEM_ENG"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedLangData.data[i]["ITEM_ES"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedLangData.data[i]["ITEM_RUS"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedLangData.data[i]["ITEM_UKR"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedLangData.data[i]["ITEM_FR"]#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Güncellenen dil bulunamadı
                </cfif>
            </div>								                    
        </div>
    </div>

<cfelseif attributes.serviceName eq 'getNewSolution'>

    <cfset AddedSolutionData = getFromService() />
    <cfset UpdatedSolutionData = getFromService("getUpdatedSolution") />

    <div id="tab-container" class="tabStandart margin-top-5">
        <div id="tab-head">
            <ul class="tabNav">
                <li class="active"><a href="#addedSolution">Added Solution</a></li>
                <li class=""><a href="#updatedSolution">Updated Solution</a></li>													
            </ul>
        </div>

        <div style="clear:both;"></div>

        <div id="tab-content" class="margin-top-10"> 
            <div id="addedSolution" class="content row"> 												
                <cfif AddedSolutionData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>IS_MENU</th>
                                <th>SOLUTION</th>
                                <th>RECORD DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(AddedSolutionData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#AddedSolutionData.data[i]["IS_MENU"]#</cfoutput></td>
                                    <td><cfoutput>#AddedSolutionData.data[i]["SOLUTION"]#</cfoutput></td>
                                    <td><cfoutput>#dateformat(AddedSolutionData.data[i]["RECORD_DATE"], dateformat_style)#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Yeni eklenen Solution bulunamadı
                </cfif>
            </div>
            <div id="updatedSolution" class="content row">  	
                <cfif UpdatedSolutionData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>IS_MENU</th>
                                <th>SOLUTION</th>
                                <th>UPDATE DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(UpdatedSolutionData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#UpdatedSolutionData.data[i]["IS_MENU"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedSolutionData.data[i]["SOLUTION"]#</cfoutput></td>
                                    <td><cfoutput>#dateformat(UpdatedSolutionData.data[i]["UPDATE_DATE"], dateformat_style)#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Güncellenen Solution bulunamadı
                </cfif>
            </div>								                    
        </div>
    </div>

<cfelseif attributes.serviceName eq 'getNewFamily'>

    <cfset AddedFamilyData = getFromService() />
    <cfset UpdatedFamilyData = getFromService("getUpdatedFamily") />

    <div id="tab-container" class="tabStandart margin-top-5">
        <div id="tab-head">
            <ul class="tabNav">
                <li class="active"><a href="#addedFamily">Added Family</a></li>
                <li class=""><a href="#updatedFamily">Updated Family</a></li>													
            </ul>
        </div>

        <div style="clear:both;"></div>

        <div id="tab-content" class="margin-top-10"> 
            <div id="addedFamily" class="content row"> 												
                <cfif AddedFamilyData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>IS_MENU</th>
                                <th>FAMILY</th>
                                <th>RECORD DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(AddedFamilyData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#AddedFamilyData.data[i]["IS_MENU"]#</cfoutput></td>
                                    <td><cfoutput>#AddedFamilyData.data[i]["FAMILY"]#</cfoutput></td>
                                    <td><cfoutput>#dateformat(AddedFamilyData.data[i]["RECORD_DATE"],dateformat_style)#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Yeni eklenen Family bulunamadı
                </cfif>
            </div>
            <div id="updatedFamily" class="content row">  	
                <cfif UpdatedFamilyData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>IS_MENU</th>
                                <th>FAMILY</th>
                                <th>UPDATE DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(UpdatedFamilyData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#UpdatedFamilyData.data[i]["IS_MENU"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedFamilyData.data[i]["FAMILY"]#</cfoutput></td>
                                    <td><cfoutput>#dateformat(AddedFamilyData.data[i]["UPDATE_DATE"],dateformat_style)#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Güncellenen Family bulunamadı
                </cfif>
            </div>								                    
        </div>
    </div>

<cfelseif attributes.serviceName eq 'getNewModule'>

    <cfset AddedModuleData = getFromService() />
    <cfset UpdatedModuleData = getFromService("getUpdatedModule") />

    <div id="tab-container" class="tabStandart margin-top-5">
        <div id="tab-head">
            <ul class="tabNav">
                <li class="active"><a href="#addedModule">Added Module</a></li>
                <li class=""><a href="#updatedModule">Updated Module</a></li>													
            </ul>
        </div>

        <div style="clear:both;"></div>

        <div id="tab-content" class="margin-top-10"> 
            <div id="addedModule" class="content row"> 												
                <cfif AddedModuleData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>IS_MENU</th>
                                <th>MODULE</th>
                                <th>RECORD DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(AddedModuleData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#AddedModuleData.data[i]["IS_MENU"]#</cfoutput></td>
                                    <td><cfoutput>#AddedModuleData.data[i]["MODULE"]#</cfoutput></td>
                                    <td><cfoutput>#dateformat(AddedModuleData.data[i]["RECORD_DATE"],dateformat_style)#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Yeni eklenen Module bulunamadı
                </cfif>
            </div>
            <div id="updatedModule" class="content row">  	
                <cfif UpdatedModuleData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>IS_MENU</th>
                                <th>MODULE</th>
                                <th>UPDATE DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(UpdatedModuleData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#UpdatedModuleData.data[i]["IS_MENU"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedModuleData.data[i]["MODULE"]#</cfoutput></td>
                                    <td><cfoutput>#dateformat(UpdatedModuleData.data[i]["UPDATE_DATE"],dateformat_style)#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Güncellenen Module bulunamadı
                </cfif>
            </div>								                    
        </div>
    </div>

<cfelseif attributes.serviceName eq 'getNewWO'>

    <cfset AddedObjectData = getFromService() />
    <cfset UpdatedObjectData = getFromService("getUpdatedWO") />

    <div id="tab-container" class="tabStandart margin-top-5">
        <div id="tab-head">
            <ul class="tabNav">
                <li class="active"><a href="#addedObject">Added Object</a></li>
                <li class=""><a href="#updatedObject">Updated Object</a></li>													
            </ul>
        </div>

        <div style="clear:both;"></div>

        <div id="tab-content" class="margin-top-10"> 
            <div id="addedObject" class="content row"> 												
                <cfif AddedObjectData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>FULL_FUSEACTION</th>
                                <th>HEAD</th>
                                <th>RECORD DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(AddedObjectData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#AddedObjectData.data[i]["FULL_FUSEACTION"]#</cfoutput></td>
                                    <td><cfoutput>#AddedObjectData.data[i]["HEAD"]#</cfoutput></td>
                                    <td><cfoutput>#dateformat(AddedObjectData.data[i]["RECORD_DATE"],dateformat_style)#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Yeni eklenen Object bulunamadı
                </cfif>
            </div>
            <div id="updatedObject" class="content row">  	
                <cfif UpdatedObjectData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>FULL FUSEACTION</th>
                                <th>HEAD</th>
                                <th>UPDATE DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(UpdatedObjectData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#UpdatedObjectData.data[i]["FULL_FUSEACTION"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedObjectData.data[i]["HEAD"]#</cfoutput></td>
                                    <td><cfoutput>#dateformat(UpdatedObjectData.data[i]["UPDATE_DATE"],dateformat_style)#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Güncellenen Object bulunamadı
                </cfif>
            </div>								                    
        </div>
    </div>

<cfelseif attributes.serviceName eq 'getNewWidget'>

    <cfset AddedWidgetData = getFromService() />
    <cfset UpdatedWidgetData = getFromService("getUpdatedWidget") />

    <div id="tab-container" class="tabStandart margin-top-5">
        <div id="tab-head">
            <ul class="tabNav">
                <li class="active"><a href="#addedWidget">Added Widget</a></li>
                <li class=""><a href="#updatedWidget">Updated Widget</a></li>													
            </ul>
        </div>

        <div style="clear:both;"></div>

        <div id="tab-content" class="margin-top-10"> 
            <div id="addedWidget" class="content row"> 												
                <cfif AddedWidgetData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>WIDGET FUSEACTION</th>
                                <th>WIDGET TITLE</th>
                                <th>RECORD DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(AddedWidgetData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#AddedWidgetData.data[i]["WIDGET_FUSEACTION"]#</cfoutput></td>
                                    <td><cfoutput>#AddedWidgetData.data[i]["WIDGET_TITLE"]#</cfoutput></td>
                                    <td><cfoutput>#dateformat(AddedWidgetData.data[i]["RECORD_DATE"],dateformat_style)#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Yeni eklenen Widget bulunamadı
                </cfif>
            </div>
            <div id="updatedWidget" class="content row">  	
                <cfif UpdatedWidgetData.status>
                    <table class="workDevList">
                        <thead>
                            <tr>
                                <th>WIDGET FUSEACTION</th>
                                <th>WIDGET TITLE</th>
                                <th>UPDATE DATE</th>
                            </tr>
                        </thead>
                        <tbody>
                            <cfloop from="1" to="#arrayLen(UpdatedWidgetData.data)#" index="i">
                                <tr>
                                    <td><cfoutput>#UpdatedWidgetData.data[i]["WIDGET_FUSEACTION"]#</cfoutput></td>
                                    <td><cfoutput>#UpdatedWidgetData.data[i]["WIDGET_TITLE"]#</cfoutput></td>
                                    <td><cfoutput>#dateformat(UpdatedWidgetData.data[i]["UPDATE_DATE"],dateformat_style)#</cfoutput></td>
                                </tr>
                            </cfloop>
                        </tbody>
                    </table>
                <cfelse>
                    Güncellenen Widget bulunamadı
                </cfif>
            </div>								                    
        </div>
    </div>

</cfif>

<script>
    $(function(){
        
        $('#tab-head ul li a').click(function(){
            var href = $(this).attr('href');//açılacak content in id si
            if(href){
                var tab = $(this).parent("li").parents("ul.tabNav");
                $(tab).removeClass('active');//Tab linklerindeki active i isler
                $(this).parents('li').addClass('active'); // Tıklanan tab linkine active ekler
                $(tab).parents().eq(2).find('.content').hide(); // aynı ailedeki tüm tab contentleri kapatır.
                var content = $(tab).parents().eq(2).find(href).fadeIn(); // aynı ailedeki seçile id li tab contenti açar
            }
            return false;
        });//#tab-head ul li a click function

        $('#tab-head ul li:first-child a').click();

    });
</script>
