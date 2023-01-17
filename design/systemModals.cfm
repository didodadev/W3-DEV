<cfif (not attributes.fuseaction contains 'emptypopup')  and (not isdefined("attributes.notModal") and not listfind('ehesap.popup_view_price_compass,objects.popup_convertpdf,member.popup_print_analysis,objects.emptypopup_get_document,objects.popup_send_print_action,objects.popup_send_flash_paper_action,objects.popup_documenter,report.popup_report_ba_bs_print',attributes.fuseaction))>
    <!-- sil -->
    <!--- Sistem İçinde Kullanılan Dinamik Modal Yapılarının Tümü Burada Bulunur --->
    <!--- Lisans Modalı --->
    <div class="modal col-10 col-md-9 col-xs-12" id="licenceModal" role="dialog" style="display: none;">
        <div class="modal-dialog">    
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">      
                    <h4 class="modal-title"><cf_get_lang dictionary_id='61207.Workcube NetWorg Intranet Platformu Kullanım ve Gizlilik Sözleşmesi'></h4> 
                </div>
                <div class="modal-body modal-special-body"></div>  
                <div class="modal-footer padding-top-10">
                    <button type="button" class="btn btn-success pull-right margin-right-5" id="licenceSaveButton" onclick="licenceStatus(1,<cfoutput>#session.ep.userid#</cfoutput>)" disabled="disabled"><cfoutput>#getlang(49,'kaydet',57461)#</cfoutput></button>
                    <label class="pull-right margin-top-10 margin-right-5">&nbsp;<cf_get_lang dictionary_id='61208.Okudum Onaylıyorum'><input type="checkbox" id="confirmLicence" name="confirmLicence" onclick="activeButtonLicence(this)"></label>
                </div>
            </div>
        </div>
        <div class="modal-special-backdrop"></div>
    </div> 
    
    
    <!--- Uyarı Modalı --->
    <div class="modal col-8 col-md-9 col-xs-12" id="uyariModal" role="dialog" style="display: none;">
        <div class="modal-dialog">    
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">×</button>                
                    <h4 class="modal-title"><cf_get_lang dictionary_id='57425.Uyarı'></h4> 
                </div>
                <div class="modal-body"></div>                       
            </div>
        </div>
        <div class="modal-backdrop" style="display:none;"></div>
    </div>  
    
    <!--- Genel Modalı --->
    <div class="modal col-8 col-md-9 col-xs-12" id="generalModal" role="dialog" style="display: none;">
        <div class="modal-dialog">    
            <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">×</button>                
                    <h4 class="modal-title"><cf_get_lang dictionary_id='57425.Uyarı'></h4> 
                </div>
                <div class="modal-body"></div>                       
            </div>
        </div>
        <div class="modal-backdrop" style="display:none;"></div>
    </div>  
    
    <!--- z-index i kaldırıyorum, page designer içinde açılan boxlar arkada kalıyor. --->
    <div class="ui-cfmodal page_designer hide" id="formPanel">
        <cf_box title="Page Designer #isdefined("attributes.event") and len(attributes.event) ? "#pageFriendlyUrl# : #attributes.event#" : ""#" closable="1" close_href="javascript://" call_function="closePageDesigner()"><!---<cfif isdefined("controllerEventList")>: #controllerEventList#</cfif>--->
            <div class="page_designer_top">
                <ul class="tab flex-start">
                    <cfif isdefined("WOStruct")>
                        <cfif StructKeyExists(WOStruct,'#attributes.fuseaction#')>
                            <cfif isdefined("attributes.event")>
                                <cfif attributes.event is 'list'>
                                    <li class="active"><a href="#frmEditEx"><cf_get_lang dictionary_id='61236.Search Form'></a></li>
                                    <!--- siralama yapilmamasi gereken listeler icin controllerdan parametreye bakilir FA --->
                                    <cfif not StructKeyExists(WOStruct['#attributes.fuseaction#']['list'],'sortListColumns') or (StructKeyExists(WOStruct['#attributes.fuseaction#']['list'],'sortListColumns') and WOStruct['#attributes.fuseaction#']['list']['sortListColumns'] is true)>
                                        <li><a href="#listEditEx"><cf_get_lang dictionary_id='61237.List Columns'></a></li>
                                    </cfif>
                                <cfelseif attributes.event is 'add'>
                                    <li class="active"><a href="#frmEditEx"><cf_get_lang dictionary_id='61238.Add Form'></a></li>
                                <cfelseif attributes.event is 'upd'>
                                    <li class="active"><a href="#frmEditEx"><cf_get_lang dictionary_id='61239.Upd Form'></a></li>
                                <cfelseif attributes.event is 'det'>
                                    <li class="active"><a href="#frmEditEx"><cf_get_lang dictionary_id='61240.Det Form'></a></li>
                                    <li><a href="#pageEdit"><cf_get_lang dictionary_id='61241.Det'></a></li>
                                </cfif>
                            </cfif>
                        </cfif>
                    </cfif>
                    <cfif isdefined("WOStruct") and StructKeyExists(WOStruct,'#attributes.fuseaction#') and StructKeyExists(WOStruct['#attributes.fuseaction#'],'list') and StructKeyExists(WOStruct['#attributes.fuseaction#']['list'],'fuseaction') and not attributes.event is 'list'>
                        <li><a onclick="gotoListModal('<cfoutput>#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list']['fuseaction']#</cfoutput>')"><cfoutput>#getlang(97,'Liste',57509)#</cfoutput></a></li>
                    </cfif>
                    <cfif isdefined("attributes.basket_id") and len(attributes.basket_id)><li><a href="#frmBasket" onclick="funcBasket()"><cf_get_lang dictionary_id='44749.Basket Yapısı'></a></li></cfif>
                    <li id="pageParamLi" class="hide"><a href="#pageParam"><cf_get_lang dictionary_id='29924.Sayfa Parametreleri'></a></li>
                </ul>
                <ul class="ui-icon-list flex-end">
                    <li>
                        <select id="pageType" name="type">
                            <option value=""><cf_get_lang dictionary_id='61242.Page Type'></option>
                            <option value="accordion"><cf_get_lang dictionary_id='61243.Accordion'></option>
                            <option value="tabs"><cf_get_lang dictionary_id='61244.Tab'></option>
                            <!--- <option value="step"><cf_get_lang dictionary_id='61245.Step'></option> geçici olarak kapatıyoruz.. geri döneceğizz. --->
                        </select>
                    </li>
                    <li>
                        <select id="pageType_screen" name="type">
                            <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                            <option value="mobile"><cf_get_lang dictionary_id='64098.Sadece Mobil'></option>
                            <option value="desktop"><cf_get_lang dictionary_id='64097.Sadece Masaüstü'></option>
                        </select>
                    </li>
                    <li><a href="javascript://" title="<cf_get_lang dictionary_id='57707.Satır Ekle'>" onClick="columnSettings('addRow')"><i class="fa fa-th-list"></i></a></li>
                    <li class="remove"><a href="javascript://" title="<cf_get_lang dictionary_id='58971.Satır Sil'>" onClick="columnSettings('delRow')"><i class="fa fa-th-list"></i></a></li>
                    <li><a href="javascript://" title="<cf_get_lang dictionary_id='43058.Kolon'> <cf_get_lang dictionary_id='57582.Ekle'>" onClick="columnSettings('addColumn')"><i class="fa fa-th-large"></i></a></li>
                    <li class="remove"><a href="javascript://" title="<cf_get_lang dictionary_id='43058.Kolon'> <cf_get_lang dictionary_id='57463.Sil'>" onClick="columnSettings('delColumn')"><i class="fa fa-th-large"></i></a></li>
                </ul> 
            </div>
            <div class="modal-body">
                <div id="tab-container" class="tabStandart">
                    <div id="tab-content"> 
                        <div id="frmEditEx" class="content">
                            <cfform id="formBuilder" name="formBuilder" action="#request.self#?fuseaction=objects.formBuilder">
                                <div style="display:none;" class="form-group">
                                    <div class="input-group">
                                        <input  name="head" id="head">
                                        <input type="hidden" name="dictionary_id" id="dictionary_id">
                                    </div>
                                </div>        
                                <div id="frmEdit" class="row"></div>
                                <script>
                                    $(function(){
                                        var event = (typeof(document.getElementById('controllerEvents')) != 'undefined' && document.getElementById('controllerEvents') != null) ? document.getElementById('controllerEvents').value : '';
                                        if(event == "list"){
                                            listSortState($("table thead tr:first"),'<cfoutput>#pageControllerName#</cfoutput>');
                                        }
                                    });
                                    function closePageDesigner(){
                                        var pageType_screen = $("#pageType_screen").val();
                                        if( pageType_screen == 'mobile') location.reload();
                                        else $(".page_designer").hide();
                                    }
                                </script>          
                                <div>
                                    <cfquery name="get_updated_emp" datasource="#dsn#">
                                        SELECT top 1 RECORD_EMP, RECORD_DATE, RECORD_IP, UPDATE_EMP, UPDATE_DATE, UPDATE_IP from MODIFIED_PAGE WHERE CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#pageControllerName#">
                                        <cfif isDefined("attributes.event") and len(attributes.event)>AND EVENT_LIST = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.event#"></cfif>
                                        <cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session.ep.company_id#"></cfif>
                                        <cfif isDefined("session.ep.period_id") and len(session.ep.period_id)>AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#session.ep.period_id#"></cfif>
                                    </cfquery>
                                    
                                    <div class="ui-form-list-btn modal-footer">
                                        <cf_record_info query_name="get_updated_emp" record_emp="RECORD_EMP" update_emp="UPDATE_EMP">
                                        <div class="padding-top-10">
                                            <label>
                                                <input type="checkbox" name="all_company" id="all_company" value="1">
                                                <cf_get_lang dictionary_id='43266.All Companies'>
                                            </label>
                                        </div>
                                        <div>
                                            <cfif isdefined('pageControllerName') and len(pageControllerName)>
                                               <input type="button" onClick="columnSettings('returnDefault','<cfoutput>#pageControllerName#</cfoutput>','<cfoutput>#attributes.event#</cfoutput>')" class="ui-wrk-btn ui-wrk-btn-success hide" value="<cf_get_lang dictionary_id='61209.Varsayılana Dön'>">
                                            </cfif>
                                        </div>
                                        <div>
                                            <input type="button" id="actionButton" class="ui-wrk-btn ui-wrk-btn-success" value="<cfoutput>#getlang(49,'kaydet',57461)#</cfoutput>">
                                        </div>
                                    </div>
                                </div>           
                            </cfform>
                        </div>
                        <div id="frmAdd" class="content">  
                            <cfif isdefined("WOStruct") and structKeyExists(WOStruct['#attributes.fuseaction#'],'systemObject') and structKeyExists(WOStruct['#attributes.fuseaction#']['systemObject'],'extendedForm') and WOStruct['#attributes.fuseaction#']['systemObject']['extendedForm'] is true>
                                <cfquery name="GET_FIELDS" datasource="#dsn#">
                                    SELECT
                                        TOP 1
                                        JSON_DATA
                                    FROM
                                        EXTENDED_FIELDS
                                    WHERE
                                        JSON_DATA IS NOT NULL
                                        AND CONTROLLER_NAME = '#pageControllerName#'
                                        AND COMPANY_ID_LIST LIKE '%#session.ep.company_id#%'
                                        AND PERIOD_ID_LIST LIKE '%#session.ep.period_id#%'
                                        AND EVENT_LIST = '#woStruct['#attributes.fuseaction#']['systemObject']['pageExtendedEventList']#'​
                                </cfquery>
                                
                                <cfform name="formBuilder" action="#request.self#?fuseaction=objects.formBuilder">
                                    <div class="fb-main"></div>
                                </cfform>
                                
                                <script>
                                function callURL(url, callback, data, target, async)
                                {
                                    var method = (data != null) ? "POST": "GET";
                                    $.ajax({
                                        async: async != null ? async: true,
                                        url: url,
                                        type: method,
                                        data: data,
                                        success: function(responseData, status, jqXHR)
                                        { 
                                            callback(target, responseData, status, jqXHR); 
                                        }
                                    });
                                }
                                function handlerPost(target, responseData, status, jqXHR){
                                    responseData = $.trim(responseData);
                                    if(responseData.substr(0,2) == '//') responseData = responseData.substr(2,responseData.length-2);
                                    ajax_request_script(responseData);
                                    var SCRIPT_REGEX = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi;
                                    while (SCRIPT_REGEX.test(responseData)) {
                                        responseData = responseData.replace(SCRIPT_REGEX, "");
                                    }
                                    responseData = responseData.replace(/<!-- sil -->/g, '');
                                    responseData = responseData.replace(/(\r\n|\n|\r)/gm,'');
                                }
                                </script>
    
                            </cfif>            
                        </div>
                        <cfif isdefined("attributes.basket_id") and len(attributes.basket_id)>
                            <div id="frmBasket" class="content">
                                <div id="basketPage"></div>
                            </div>
                        </cfif>           
                        <div id="pageEdit" class="content">
                            <div id="pageEditDiv" class="row"></div>
                            <div class="ui-form-list-btn modal-footer">
                                <div>
                                    <cfif isdefined('pageControllerName') and len(pageControllerName)>
                                        <input type="button" detEventReturn onClick="returnDetSettings('<cfoutput>#pageControllerName#</cfoutput>')" class="hide" value="<cf_get_lang dictionary_id='61209.Varsayılana Dön'>">
                                    </cfif>                                
                                </div>
                                <div>
                                    <input type="button" id="actionButton" class="ui-btn ui-btn-success" value="<cfoutput>#getlang(49,'kaydet',57461)#</cfoutput>">
                                </div>
                            </div>
                        </div>
                        <div id="pageParam" class="content" style="display:none;">
                            <div id="pageParamDiv" class="row"></div>
                            <div class="ui-form-list-btn modal-footer">
                                <div>
                                    <input type="button" id="actionButton" class="ui-btn ui-btn-success" value="<cfoutput>#getlang(49,'kaydet',57461)#</cfoutput>">
                                </div>
                            </div>
                        </div>           
                        <div id="listEditEx" class="content" style="display:none;">
                            <div id="listEdit" class="row"></div>
                            <div class="ui-form-list-btn modal-footer">
                                <div>
                                    <cfif isdefined('pageControllerName') and len(pageControllerName)>
                                        <input type="button" onClick="delList('<cfoutput>#pageControllerName#</cfoutput>')" class="hide" value="<cf_get_lang dictionary_id='61209.Varsayılana Dön'>">
                                    </cfif>     
                                </div>
                                <div>
                                    <input type="button" id="actionButton" class="ui-btn ui-btn-success" value="<cfoutput>#getlang(49,'kaydet',57461)#</cfoutput>" onclick="saveList('<cfoutput>#pageControllerName#</cfoutput>')">
                                </div>
                            </div>
                        </div>
                        <div id="pageBarEdit" class="content" style="display:none;">
                            <div id="editBar" class="row"></div>
                             <div class="ui-form-list-btn modal-footer">
                                 <div>
                                    <input type="button" id="actionButton" class="ui-btn ui-btn-success" value="<cfoutput>#getlang(49,'kaydet',57461)#</cfoutput>">
                                 </div>
                             </div>
                        </div>         
                    </div>
                </div> 
            </div>             	
            <div class="modal-backdrop" style="display:none;"></div>
        </cf_box>
    </div>



    <!---
    <cfif isdefined("WOStruct") and StructKeyExists(WOStruct['#attributes.fuseaction#'],'print') and StructKeyExists(WOStruct['#attributes.fuseaction#']['print'],'cfcName')>
        <cfset pagePrintCfc = WOStruct['#attributes.fuseaction#']['print']['cfcName']>
        <cfset pagePrintIdentity = WOStruct['#attributes.fuseaction#']['print']['identity']>
        <cfif structKeyExists(attributes,'#pagePrintIdentity#')>
            <cfset pageIdentity = attributes['#pagePrintIdentity#']>
        <cfelse>
            <cfset pageIdentity = ''>
        </cfif>
    <cfelse>
        <cfset pagePrintCfc = ''>
        <cfset pagePrintIdentity = ''>
        <cfset pageIdentity = ''>
    </cfif>
    
    <cfquery name="GET_PRINTJSON" datasource="#dsn#">
        SELECT
            FORM_ID,
            NAME
        FROM
            #dsn3_alias#.SETUP_PRINT_FILES
        WHERE
            CONTROLLER_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#pageControllerName#">
    </cfquery>
    <cfif GET_PRINTJSON.recordcount>
        <!--- Print Designer --->
        <div class="modal fs hide" id="printPanel" role="dialog">
            <div class="modal-dialog">    
                <div class="modal-content">
                    <div class="modal-header">
                        <!--- header--->
                        <button type="button" class="close" data-dismiss="modal">×</button>
                        <h4 class="modal-title">Print Düzenle</h4>	
                    </div>
                    <div class="modal-body">
                        <!--- body --->                 
                        <div class="row">
                            <div class="col col-2" >
                                 <div class="row">
                                    <div class="col col-12 divBox">
                                        <div class="row divBox-Head text-left font-green-sharp"><cfoutput>#getlang('content',8,'Şablonlar')#</cfoutput></div>
                                        <div class="row">
                                            <div class="col col-12">
                                                <div class="form-group" >
                                                    <label class="col col-4 col-sm-12"><cfoutput>#getlang('main',1228,'Şablon')#</cfoutput></label>
                                                    <div class="col col-8 col-sm-12">
                                                        <select id="printType" name="printType" onchange="getPrint(<cfoutput>'#session.ep.company_id#','#pageControllerName#','#pagePrintCfc#','#pageIdentity#'</cfoutput>,this.value,0)">
                                                            <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                                            <cfoutput query="GET_PRINTJSON">
                                                                <option value="#FORM_ID#">#NAME#</option>
                                                            </cfoutput>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                 </div>
                            
                                <div class="row" id="pageStyle">
                                    <div class="col col-12 divBox">
                                        <div class="row divBox-Head text-left font-green-sharp"><cfoutput>#getlang('report',424,'Sayfa yapısı')#</cfoutput></div>
                                        <div class="row">  
                                            <div class="col col-12">
                                                <div class="form-group" >
                                                    <label class="col col-4 col-sm-12"><cfoutput>#getlang('main',485,'adı')#</cfoutput></label>
                                                    <div class="col col-8 col-sm-12">
                                                        <input type="text" id="printName" name="printName"/>
                                                        <input type="hidden" id="cName" name="cName" <cfif isdefined("pageControllerName") and len(pageControllerName)>value="<cfoutput>#pageControllerName#</cfoutput>"</cfif>/>
                                                        <input type="hidden" id="cIdPrint" name="cIdPrint" value="<cfoutput>#session.ep.company_id#</cfoutput>"/>
                                                        <input type="hidden" id="printActionId" name="printActionId" value=""/>
                                                    </div>
                                                </div>
                                                <div class="form-group" >
                                                    <label class="col col-4 col-sm-12">Kağıt Boyutu</label>                                
                                                    <div class="col col-8 col-sm-12">
                                                        <div class="input-group">
                                                            <select id="type">
                                                                <option value="0">A4</option>
                                                                <option value="1">A5</option>
                                                                <option value="2">Özel</option>
                                                            </select>
                                                        <span class="input-group-addon">
                                                            <select id="rotate">
                                                                <option value="0"><cfoutput>#getlang('main',1996,'dikey')#</cfoutput></option>
                                                                <option value="1"><cfoutput>#getlang('main',1997,'yatay')#</cfoutput></option>                                  
                                                            </select>
                                                        </span> 
                                                        </div>	   
                                                    </div>
                                                </div>
                                                <div class="form-group" >
                                                    <label class="col col-4 col-sm-12"><cfoutput>#getlang('main',283,'Genişlik')#</cfoutput></label>                                
                                                    <div class="col col-8 col-sm-12">
                                                        <div class="input-group">
                                                            <input type="text" id="width" />
                                                            <span class="input-group-addon"> mm </span> 
                                                        </div>	   
                                                    </div>
                                                </div>
                                                <div class="form-group" >
                                                    <label class="col col-4 col-sm-12"><cfoutput>#getlang('main',284,'Yükseklik')#</cfoutput></label>                                
                                                    <div class="col col-8 col-sm-12">
                                                        <div class="input-group">
                                                            <input type="text" id="height"  />
                                                            <span class="input-group-addon"> mm </span> 
                                                        </div>	   
                                                    </div>
                                                </div>
                                                <div class="form-group" >
                                                    <label class="col col-4 col-sm-12">iç Boşluk</label>                                
                                                    <div class="col col-8 col-sm-12">
                                                        <div class="input-group">
                                                            <input type="text" id="padding"  />
                                                            <span class="input-group-addon"> mm </span> 
                                                        </div>	   
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col col-4 col-sm-12">Arkaplan</label>                                
                                                    <div class="col col-8 col-sm-12">
                                                        <input type="file" name="img" id="backgroundFile">	   
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col col-8 col-sm-12">                           
                                                        Header Sabit  
                                                        <input type="checkbox" id="headerFixed" onClick="headerFixed(this)">	   
                                                   </label>    
                                                </div>
                                            </div>               
                                        </div><!--row-->
                                    </div>
                                 </div>
                                <div class="row">
                                    <div class="col col-12 divBox">
                                        <div class="row divBox-Head text-left font-green-sharp">Element</div>
                                        <div class="row scrollContent scroll-x4" id="elements">  
                                                        
                                        </div><!--row-->
                                    </div>
                                 </div>
                                 <div class="row">
                                    <div class="col col-12 divBox">
                                        <div class="row divBox-Head text-left font-green-sharp">
                                            Lists 
                                            <span class="pull-right">
                                                <i class="icon-pluss  btnPointer" onClick="tableSettings('addRow')"></i>&nbsp;
                                                <i class="icon-minus  btnPointer" onClick="tableSettings('delRow')"></i>
                                            </span>
                                        </div>
                                        <div class="row scrollContent scroll-x4" id="lists">  
                                                        
                                        </div><!--row-->
                                    </div>
                                 </div>
                                <div class="row" id="elemetStyle">
                                    <div class="col col-12 divBox">
                                    <div class="row divBox-Head text-left font-green-sharp">Element Style <span id="name" class="headHelper pull-right"></span> </div>
                                        <div class="row">  
                                            <div class="col col-12 ">
                                                <div class="form-group">
                                                    <label class="col col-4 col-sm-12">Font Ayarı</label>                                
                                                    <div class="col col-8 col-sm-12">
                                                        <div class="input-group">
                                                        <select id="font-family">
                                                            <option value="0"><cfoutput>#getlang('main',322,'seçiniz')#</cfoutput></option>
                                                            <option value="1">Arial</option>
                                                            <option value="2">Tahoma</option>
                                                            <option value="3">Times New Roman</option>
                                                        </select>
                                                        <span class="input-group-addon">
                                                        <select id="font-size">
                                                            <option value="0"><cfoutput>#getlang('main',322,'seçiniz')#</cfoutput></option>
                                                            <option value="8">8Px</option>
                                                            <option value="9">9Px</option>                                  
                                                        </select>
                                                        </span> 
                                                        </div>	   
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col col-4 col-sm-12"></label>                                
                                                    <div class="col col-8 col-sm-12">
                                                        <div class="input-group">                                    
                                                            <button type="button" class="btn btn-default" id="font-bold"><span class="icon-bold"></span></button>
                                                            <button type="button" class="btn btn-default" id="font-italic"><span class="icon-italic"></span></button>
                                                            <button type="button" class="btn btn-default" id="font-underline"><span class="icon-underline"></span></button>
                                                        </div>  
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <label class="col col-4 col-sm-12">Hizalama</label>                                
                                                    <div class="col col-8 col-sm-12">
                                                      <div class="input-group">                                    
                                                            <button type="button" class="btn btn-default" id="align-justify"><span class="icon-align-justify"></span></button>
                                                            <button type="button" class="btn btn-default" id="align-right"><span class="icon-align-right"></span></button>
                                                            <button type="button" class="btn btn-default" id="align-center"><span class="icon-align-center"></span></button> 
                                                            <button type="button" class="btn btn-default" id="align-left"><span class="icon-align-left"></span></button>                                              
                                                        </div>		
                                                    </div>
                                                </div>
                                             <div class="form-group hide" id="columnSum">
                                                    <label class="col col-12 col-sm-12">                           
                                                         Sayfa Toplam  
                                                        <input type="checkbox" onClick="tableSettings('columnSum')">	   
                                                   </label>    
                                                </div>
                                            </div>               
                                        </div><!--row-->
                                    </div>
                                </div>      
                            </div>
                            <div class="col col-10">
                                <div class="divBox">
                                    <div class="row divBox-Head text-left font-green-sharp">Desing Paper</div>
                                    <div class="row">  
                                        <div class="col col-12 designWrapper">
                                            <div class="pageWrapper">
                                                <div class="Designer-ruler-corner"></div>
                                                <div class="rullerW" id="rullerTrick-W"></div>   
                                                <div class="rullerH" id="rullerTrick-H"></div>                            
                                                <div class="myCanvas" id="page">
                                                    <div class="printBox" id="pageHeader"><div class="head">header</div></div>
                                                    <div class="printBox" id="pageBody"><div class="head">body</div></div>                                            
                                                    <div class="printBox" id="pageFooter"><div class="head">footer</div></div>                                            
                                                </div>
                                            </div>                    
                                        </div>               
                                    </div>
                                </div>
                            </div>   
                        </div>
                    </div>              
                    <div class="modal-footer">
                        <!--- foooter --->
                        <input type="button" id="actionButton" class="btn green-haze" value="<cfoutput>#getlang('main',49,'kaydet')#</cfoutput>"/>
                    </div> 
                </div> 
            </div> 
            <div class="modal-backdrop" style="display:none;"></div>
            </div>
        
        <!--- Print Page --->
        <div class="modal col-10 col-md-11 col-xs-12 modal-top hide" id="printPage" role="dialog">
            <div class="modal-dialog">    
                <div class="modal-content">
                    <div class="modal-header">
                        <!--- header--->
                        <button type="button" class="close" data-dismiss="modal">×</button>
                        <h4 class="modal-title">Print page</h4>	
                    </div>
                    <div class="modal-body">
                        <!--- body --->
                        <div class="row">
                          <div class="col col-2">
                            <div class="row">
                                <div class="col col-12 divBox">
                                    <div class="row divBox-Head text-left font-green-sharp">Şablonlar</div>
                                    <div class="row">
                                        <div class="col col-12">
                                            <div class="form-group" >
                                                <label class="col col-4 col-sm-12">Şablon</label>
                                                <div class="col col-8 col-sm-12">
                                                    <select onchange="getPrint(<cfoutput>'#session.ep.company_id#','#pageControllerName#','#pagePrintCfc#','#pageIdentity#'</cfoutput>,this.value,1)">
                                                        <option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                                                        <!---
                                                        <cfoutput query="GET_PRINTJSON">
                                                            <option value="#FORM_ID#">#NAME#</option>
                                                        </cfoutput>
                                                        --->
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                             </div>
                          </div>
                          <div class="col col-10">
                              <div class="divBox">
                                <div class="row divBox-Head text-left font-green-sharp">Desing Paper</div>
                                <div class="row">  
                                    <div class="col col-12" id="templateBody">
                                                        
                                    </div>               
                                </div>
                            </div>                 
                          </div>
                        </div>
                       
                    </div>              
                    <div class="modal-footer">
                        <!--- foooter --->
                        <input type="button" value="Yazdır" id="printBook">
                    </div> 
                </div> 
            </div> 
            <div class="modal-backdrop" style="display:none;"></div>
        </div>
    </cfif>
    --->
    
    <!--- WorkDev --->
    <div class="modal fs hide" id="workDev" role="dialog">
        <div class="modal-dialog"> 
        <!-- Modal content-->
            <div class="modal-content">
                <div class="modal-header">
                    <div class="modal-logo"><img src="images/w3-white.png" title="Workcube Catalyst"></div>
                    
                    <button type="button" class="close" data-dismiss="modal">×</button>
                    <div class="modal-header-buttons" id="workdevtopmenu">
                        <i class="icon-industry" title=""></i>   
                        <i class="mhdText" onclick="callPage('icn');" title="Modul Menü"><cf_get_lang dictionary_id='60947.ICONS'></i> 
                        <i class="mhdText" onclick="callPage('mm');" title="Modul Menü">MM</i>
                        <i class="mhdText" onclick="callPage('ut');" title="Utility">UT</i>
                        <i class="mhdText" onclick="callPage('wo');" title="Workcube Objects">WO</i>
                        <i class="mhdText" onclick="callPage('wex');" title="WEX">WX</i>
                        <i class="catalyst-user" onclick="callPage('community');"  title="Community"></i>
                    </div>
                    <h4 class="modal-title"><cf_get_lang dictionary_id='52706.WorkDev'> / <cfoutput>#pageFriendlyUrl#</cfoutput> <span class="workdevMenuTitle"></span></h4>
                </div>
                <div class="modal-body-content scrollContent">
                    <div class="modalMenuContent">
                        <ul class="modalMenu" id="workdevmenu">
                            <li onclick="AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_system&type=a&event=upd&fuseact=#attributes.fuseaction#&controllerName=#pageControllerName#&mainDictId=#mainDictId#</cfoutput>','workDev-page-content');"  title="Workcube Object">
                                <i class="catalyst-info"></i>
                                <span class="title"><cf_get_lang dictionary_id='52782.WorkCube Object'></span>
                            </li>
                            <li onclick="callPage('model');" title="Model"><!---  AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.modalModel&controllerName=#pageControllerName#&mainDictId=#mainDictId#</cfoutput>','workDev-poppage'); --->
                                <i class="catalyst-calculator" title="Model"></i>
                                <span class="title"><cf_get_lang dictionary_id='58225.Model'></span>
                            </li>
                            <li onclick="callPage('components');" title="Components">
                                <i class="catalyst-layers" ></i>
                                <span class="title"><cf_get_lang dictionary_id='60943.COMPONENTS'></span>
                            </li>
                            <li onclick="callPage('controller');" title="Controler">
                                <i class="catalyst-directions"></i>
                                <span class="title"><cf_get_lang dictionary_id='61246.Controller'></span>
                            </li>
                            <li onclick="callPage('typetrigger');" title="Trigger">
                                <i class="catalyst-link" ></i>
                                <span class="title"><cf_get_lang dictionary_id='61247.Trigger'></span>
                            </li>
                            <!---
                            <li onclick="callPage('oldController');" title="Old Controler">
                                OC
                                <span class="title">Old Controller</span>
                            </li>
                            --->
                            <li onclick="callPage('converter');" title="Converter">
                                <i class="catalyst-shuffle" ></i>
                                <span class="title"><cf_get_lang dictionary_id='61248.Converter'></span>
                            </li>
                            <li onclick="AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.modelResult</cfoutput>','workDev-page-content');" title="Output"><!---callPage('output');--->
                                <i class="catalyst-printer" ></i>
                                <span class="title"><cf_get_lang dictionary_id='37100.Output'></span>
                            </li>
                            <li onclick="callPage('db');" title="DB">
                                <i class="catalyst-screen-tablet"></i>
                                <span class="title"><cf_get_lang dictionary_id='60858.DB'></span>
                            </li>
                            <li onclick="callPage('bugs');" title="Bugs">
                                <i class="catalyst-wrench" ></i>
                                <span class="title"><cf_get_lang dictionary_id='52710.Bugs'></span>
                            </li>
                            <li onclick="callPage('support');" title="Helps">
                                <i class="catalyst-support"></i>
                                <span class="title">Helps</span>
                            </li>
                        </ul>
                    </div>
                    <div Class="modal-body" id="workDev-poppage">
                        <div id="warningContainer"></div>
                        <div class="workDevTab" id="workDev-page-content"></div>
                        <div class="workDevTab" id="editBarx">
                             <div class="modal-footer">
                                <!--- foooter --->
                                <input type="button" id="actionButton" class="btn green-haze" value="<cfoutput>#getlang(49,'kaydet',57461)#</cfoutput>">
                            </div>
                        </div>
                    </div>
                    <!---<div class="modal-footer"><button type="button" class="btn green-haze">Kaydet</button></div>--->
                </div>
            </div>
        </div>
    <div class="modal-backdrop"></div>
    </div>
    <!---
    <cfif isdefined("tabMenuData")>
        <cfset wo = URLEncodedFormat(tabMenuData, "utf-8")>
        <cfdump var="#wo#">
    </cfif>
    --->
    
    <!-- sil -->
    
    <script type="text/javascript">
         /*workdev*/

    $(function(){
        var page_designer_tab = $('.page_designer_top ul.tab li a');
	    page_designer_tab.click(function(){
		    var href = $(this).attr("href");
		    if($(this).hasClass("active") != true){
			    $('.page_designer_top ul li').removeClass("active");
			    $(this).parent("li").addClass("active");
		    }
		    $('#tab-content .content').hide();
		    $(href).show();
	    });
    })

         
	$('.fullSize .catalystClose').click(function(){
		$('.page_designer').removeClass("fullSize").css({"display":"none","visibility":"hidden"});
		$('.page_designer, .page_designer .portBox').toggle();
	})
        
        function workdevMenuTitle(title){$(".workdevMenuTitle").empty(); $(".workdevMenuTitle").append(window.friendly + "&nbsp;/&nbsp;"+title);}	
        $( "#workdevmenu li" ).click(function() {		
            var title= $(this).attr( "title" ); workdevMenuTitle(title);
            $( "#workdevmenu li" ).removeClass("workdevActive");
            $( this ).addClass("workdevActive");
        });
        $( "#workdevtopmenu i" ).click(function() {var title= $(this).attr( "title" ); workdevMenuTitle(title);});
    
        $(function() {
            <!---AjaxPageLoad('<cfoutput>#request.self#?fuseaction=dev.list_wbo&event=upd&fuseact=#attributes.fuseaction#</cfoutput>','workDev-poppage');--->
            var h =$( window ).height()-45+"px"
            $(".modal.fs .modal-body-content").css("max-height",h);
            //AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_system&type=a&event=upd&fuseact=#attributes.fuseaction#&controllerName=#pageControllerName#&mainDictId=#mainDictId#</cfoutput>','workDev-page-content');
        });
    
        function openModalStart()
        {
            myPopup('workDev');
            AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_system&type=a&event=upd&fuseact=#attributes.fuseaction#&controllerName=#pageControllerName#&mainDictId=#mainDictId#</cfoutput>','workDev-page-content')
        }
        
        $( window ).resize(function() {
            var h =$( window ).height()-45+"px"
            $(".modal.fs .modal-body-content").css("max-height",h);
        });
        
        $("#formBuilder .modal-footer .text-left .record_info").css("color","white");
        $("#formBuilder .modal-footer .text-left .record_info a").css("color","blue");
        $("#formBuilder .modal-footer .text-left .record_info a").css("text-decoration","underline");

        $('.workDevTab').hide();
        $('.workDevTab#workDev-page-content').show();
        
        function callPage(type,tab,pageContent, prm){		
            $('.workDevTab').hide();
            if (pageContent){var content = pageContent}else{var content = 'workDev-page-content'}	
            if(tab){
                $('.workDevTab#'+tab).show();
                }
            else if (prm !== null && prm !== undefined) {
                $(".workDevTab#"+content).show();
                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_system&type='+type+prm+'</cfoutput>', content);
            }
            else{
                $('.workDevTab#'+content).show();
                AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_system&type='+type+'&userFriendly=' + window.friendly + '&mainDictId=#mainDictId#&fuseact=' + window.fuseact + '</cfoutput>', content);	
            }
        }
        
        /*---------------------------------------------------------------------------*/
        <!---$(function(e){
                getPrint(<cfoutput>'#session.ep.company_id#','#pageControllerName#','#pagePrintCfc#'</Cfoutput>,0,0,1);
            });--->
            <cfif isdefined("attributes.basket_id") and len(attributes.basket_id)>
                function funcBasket()
                {
                    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_basketSideBar&basket_id=#attributes.basket_id#<cfif isdefined("attributes.is_view") and attributes.is_view>&is_view=1</cfif></cfoutput>','basketPage');
                }
                function funcBasketExtra()
                {
                    AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.basketSideBarExtra</cfoutput>','basketPageExtra');
                }
            </cfif>
    </script>
    </cfif>