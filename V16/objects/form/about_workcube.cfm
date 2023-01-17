<cfset getComponent = createObject('component','V16.objects.cfc.upgrade_notes')>
<cfset get_release_version = getComponent.GET_RELEASE_VERSION()>
<cfset api_key = "201118kSm20">
<cfset session_ep_language = "#session.ep.language#">
<cfhttp url="https://networg.workcube.com/web_services/webserviceforrelease.cfc?method=GET_UPGRADE_NOTES" result="response" charset="utf-8">
    <cfhttpparam name="api_key" type="formfield" value="#api_key#">
    <cfhttpparam name="session_ep_language" type="formfield" value="#session_ep_language#">
</cfhttp>
<cfset local.systemParam = application.systemParam.systemParam() />
<cfset gitSelfPull = local.systemParam.git.git_self_pull?:false />
<cfset freeSystems = ['dev.workcube.com','qa.workcube.com','beta.workcube.com'] />
<cfset systemmode = ArrayContains( freeSystems, cgi.server_name ) ? 'free' : 'dev' />
<cfset responseData =  Replace(response.filecontent,"//","")> 
<cfset cfData=DeserializeJSON(responseData)>
<cf_box id="workcube_upgrade" title="">
    <div class="col col-12 col-md-12 col-xs-12 mt-3">
        <div class="header col col-12 col-md-12 col-xs-12">
            <img src="css/assets/icons/catalyst-icon-svg/workcube-logo.svg" width="60" height="55">
            <h3>WORKCUBE</h3>
            <!--- Google Translate Özelliği Silmeyin! ---->
            <div align="right">
                <div class="form-group" id="google_translate_element"></div>
                <script type="text/javascript">
                    function googleTranslateElementInit() 
                    {
                        new google.translate.TranslateElement({pageLanguage: '<cfoutput>#session.ep.language#</cfoutput>', includedLanguages: 'en,fr,ar,ru,de,es,it,ro',
                        layout:google.translate.TranslateElement.InlineLayout.SIMPLE, autoDisplay: false},
                        'google_translate_element');
                    }
                </script>
                <script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
            </div>
            <!--- Google Translate Özelliği Silmeyin! ---->
        </div>
        <div class="col col-12 col-md-12 pdn-l-0 mt-3">
            <div class="col col-12" style="font-size : 15px">
                <cf_get_lang dictionary_id="33500.Workcube Topluluğu müşterileri, kullanıcıları, geliştiricileri, danışmanları ile hergün büyüyen bir topluluktur. Workcube geliştirimleri bu topluluk tarafından kooperatifçilik ilkesiyle yapılmaktadır.">
            </div>
            <div class="col col-12 mt-3 release_info">
                <h4><cf_get_lang dictionary_id="43922.Sürüm Bilgileriniz"></h4>
                <cfif len(application.systemParam.systemParam().workcube_version) and application.systemParam.systemParam().workcube_version eq 'catalyst v1.0'>
                    <div class="col col-12 pdn-l-0">
                        <span class="rd_title"><cf_get_lang dictionary_id='30562.Master'></span>
                    </div>
                    <div class="before-release col col-12 mt-4">
                        <p><cf_get_lang dictionary_id="49408.Master Sürüm ile çalışmaktasınız. Master Sürümü geliştirim ortamıdır. QA süreçleri tamamlanmış sürümlere geçmeniz tavsiye edilir."></p>
                        <cfif session.ep.admin eq 1>
                            <p><cf_get_lang dictionary_id="49417.Güncel sürüme geçmeden önce yapmanız gerekenler için"><a href="<cfoutput>#request.self#?fuseaction=objects.popup_upgrade_workcube</cfoutput>"><cf_get_lang dictionary_id = "35345.Tıklayınız"></a></p>
                        </cfif>
                    </div>
                <cfelse>
                    <cfif gitSelfPull>
                        <cfset gitBranch = local.systemParam.git.git_branch?:application.systemParam.systemParam().workcube_version />
                        <div class="col col-4 col-lg-4 col-xs-12 mb-3 pdn-l-0">
                            <span class="rd_title"><cfoutput>#gitBranch#</cfoutput></span>
                        </div>
                        <!--- self pull aktifse pull butonu görüntülenmesi --->
                        <div class="col col-8 col-lg-6 col-xs-12">
                            <input type="button" value="PULL" onclick="goUpgrade('<cfoutput>#gitBranch#</cfoutput>','<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>','patch','<cfoutput>#systemmode#</cfoutput>');">
                        </div>
                    <cfelse>
                        <div class="col col-4 col-lg-4 col-xs-12 mb-3 pdn-l-0">
                            <span class="rd_title"><cfoutput>#get_release_version.release_no#</cfoutput></span>
                            <span class="br_title"><cfoutput> #dateformat(get_release_version.RELEASE_DATE,dateformat_style)#</cfoutput></span>
                        </div>
                        <!--- PATCH Buton ya da bilgilerinin görüntülenmesi --->
                        <cfscript>releaseInfo = arrayFilter(cfData.RELEASE, function( elm ){ return elm.release eq get_release_version.release_no; })[1];</cfscript>
                        <cfif len(releaseInfo.patch_info)>
                            <cfscript> lastPatch = arrayFilter(deserializeJSON( releaseInfo.patch_info ), function( el ){ return el.patch_status; })[1]?:''; </cfscript>
                            <div class="col col-8 col-lg-6 col-xs-12">
                                <cfif session.ep.admin eq 1 and isStruct(lastPatch) and (not len( get_release_version.PATCH_DATE ) or (dateCompare(createodbcdatetime(lastPatch.PATCH_DATE),createodbcdatetime(get_release_version.PATCH_DATE)) eq 1))>
                                    <input type="button" value="PATCH" class="position: relative;top: -4px;" onclick="goUpgrade('<cfoutput>#lastPatch.PATCH_NO#</cfoutput>','<cfoutput>#lastPatch.PATCH_DATE#</cfoutput>','patch','production');">
                                <cfelseif len( get_release_version.PATCH_DATE )>
                                    Patch : 
                                    <span class="rd_title"><cfoutput>#get_release_version.PATCH_NO#</cfoutput></span>
                                    <span class="br_title"><cfoutput> #dateformat(get_release_version.PATCH_DATE,dateformat_style)#</cfoutput></span>
                                </cfif>
                            </div>
                        </cfif>
                    </cfif>
                </cfif>
            </div>
        </div>
        
        <div class="col col-12 pdn-l-0 mt-4">
            <div class="col col-12 release_info">
                <h4><cf_get_lang dictionary_id="43923.Güncel Sürüm"></h4>
            </div>
            <div class="col col-12 pdn-l-0">
                <cfif isdefined('cfData.recordcnt') and len(cfData.recordcnt)>
                    <cfloop index="i" from="1" to="#cfData.recordcnt#">                             
                        <div class="col col-12 mb-3">   
                            <div class="col col-4 col-lg-4 col-xs-12 mb-3 pdn-l-0">
                                <a id="href_<cfoutput>#i#</cfoutput>" href="#" class="release_notes_title">
                                    <span class="rd_title"><cfoutput>#cfData.RELEASE[i].release# <i class="fa fa-angle-double-down" id="icon_#i#"></i></cfoutput></span>
                                </a>
                                <span class="br_title"><cfoutput>#dateformat(cfData.RELEASE[i].NOTE_DATE,dateformat_style)#</cfoutput></span>
                            </div>
                        <cfif session.ep.admin eq 1 and isdefined('get_release_version.RELEASE_DATE') and len(get_release_version.RELEASE_DATE) and get_release_version.RELEASE_NO NEQ cfData.RELEASE[i].release and dateCompare(createodbcdatetime(cfData.RELEASE[i].NOTE_DATE),createodbcdatetime(get_release_version.RELEASE_DATE)) eq 1>
                            <cfif application.systemParam.systemParam().workcube_version neq 'catalyst v1.0' and not gitSelfPull>
                                <div class="col col-8 col-lg-6 col-xs-12">
                                    <input type="button" value="UPGRADE" onclick="goUpgrade('<cfoutput>#cfData.RELEASE[i].release#</cfoutput>','<cfoutput>#cfData.RELEASE[i].note_date#</cfoutput>','upgrade','production');">
                                </div>
                            </cfif>
                        </cfif>
                        <div class="release_notes col col-12 col-lg-12-col-xs-12" id="release_notes_<cfoutput>#i#</cfoutput>" style="<cfif i neq 1>display:none;</cfif>">
                            <cfoutput> #Replace(cfData.RELEASE[i].UPGRADE_NOTE_DETAIL, chr(13)&Chr(10), "", 'All')# </cfoutput>
                            <cfscript>noPatch = arrayFilter(cfData.RELEASE[i].RELEASE_ROWS, function( el ){ return not len( el.PATCH_NO );});</cfscript>
                            <cfif ArrayLen(noPatch)>
                                <cfloop index="j" from = "1" to = "#ArrayLen(noPatch)#">
                                    <cf_seperator id="release_row_no_patch#j#" header="#noPatch[j].NOTE_ROW_TYPE# - #noPatch[j].NOTE_ROW_TITLE#" closeForGrid="1">
                                    <cfoutput><div class="col col-12" id="release_row_no_patch#j#" style="display:none;">#noPatch[j].NOTE_ROW_DETAIL#</div></cfoutput>
                                </cfloop>
                            </cfif>
                            <cfif len(cfData.RELEASE[i].PATCH_INFO)>
                                <!---- Sadece aktif patchleri gösterir ---->
                                <cfscript> patchinfo = arrayFilter(deserializeJSON(cfData.RELEASE[i].PATCH_INFO), function( el ){ return el.patch_status; }); </cfscript>
                                <cfloop index="k" from = "1" to = "#ArrayLen(patchinfo)#"> 
                                    <cfscript>yesPatch = arrayFilter(cfData.RELEASE[i].RELEASE_ROWS, function( el ){ return len( el.PATCH_NO ) and patchinfo[k].patch_no eq el.PATCH_NO;});</cfscript>
                                    <cfif ArrayLen(yesPatch)>
                                        <div class="col col-12 col-lg-12-col-xs-12 pdn-l-0 mt-3 release_info">
                                            <cfoutput><h3><strong>#patchinfo[k].patch_no# - #patchinfo[k].patch_date#</strong></h3></cfoutput>
                                        </div>
                                        <cfloop index="j" from = "1" to = "#ArrayLen(yesPatch)#">
                                            <cf_seperator id="release_row_yes_patch_#cfData.RELEASE[i].UPGRADE_NOTE_ID#_#k#_#j#" header="#yesPatch[j].NOTE_ROW_TYPE# - #yesPatch[j].NOTE_ROW_TITLE#" closeForGrid="1">
                                            <cfoutput><div class="col col-12" id="release_row_yes_patch_#cfData.RELEASE[i].UPGRADE_NOTE_ID#_#k#_#j#" style="display:none;">#yesPatch[j].NOTE_ROW_DETAIL#</div></cfoutput>
                                        </cfloop>
                                    </cfif>
                                </cfloop>
                            </cfif>
                        </div>
                        <cfif i eq 1>
                            <div class="col col-12 col-lg-12-col-xs-12 pdn-l-0 mt-3 release_info">
                                <h4><cf_get_lang dictionary_id="33502.Önceki Sürümler"></h4>
                            </div>
                        </cfif>
                        </div>                  
                    </cfloop>
                <cfelse>
                    <cf_get_lang dictionary_id="57484.Kayit yok">
                </cfif>
            </div>
        </div>
    </div>
</cf_box>
<script>
    $( document ).ready(function() {
        $('.release_notes_title').click(function(evt) {
            evt.preventDefault();
            div_number =  this.id.split('_');
            release_notes = 'release_notes_' + div_number[1];     
            if(document.getElementById(release_notes).style.display == ""){
                document.getElementById(release_notes).style.display="none";
            }else{
                document.getElementById(release_notes).style.display="";
            }
        });
    });
    function goUpgrade(release, release_note, upgradeMode, systemmode){
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_upgrade_workcube&release_no='+release+'&release_date='+release_note+'&type=cfgitdifflist&upgrademode='+upgradeMode+'&systemmode='+systemmode+'&mode=2','medium');
        window.close();
    }
</script>
