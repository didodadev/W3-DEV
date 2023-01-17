<!--- 
    Author : Uğur Hamurpet
    Date : 01/06/2020
    Desc : Hata çıktılarının görüntülenmesini sağlar. Bu dosya application onError içerisinde çalışan error_manager.cfc tarafından include edilir.
--->
<cfsavecontent  variable="errorResult">
    <link href="/css/assets/template/error_manager.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="/css/assets/template/codemirror/codemirror.css">
    <script type="text/javascript" src="/JS/codemirror/codemirror.js"></script>
    <script type="text/javascript" src="/JS/codemirror/simplescrollbars.js"></script>
    <script type="text/javascript" src="/JS/codemirror/sql.js"></script>
        <div class = "col col-9">
            <div class="boxRow uniqueBox" style="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08);left:20%;margin:100px 0px 100px 0px!important;" id="unique_error">
                <div id="box_error_manager" class="portBox portBottom">
                    <div id="header_error" class="portHeadLight">
                        <div class="portHeadLightTitle">
                            <span id="handle_error">
                                <a href="javascript://">Oops :(</a>
                            </span> 
                        </div>
                    </div>
                    <div class="portBoxBodyStandart">
                        <div class = "col col-12 scrollContent" style="max-height:570px;">
                            <cfoutput>
                                <cfif isDefined("session.ep.USERID")>
                                    <cfif errorDetail.message.status>
                                        <h3>#errorDetail.message.devmessage#</h3>
                                        <div class = "col col-12">
                                            <h4><cf_get_lang dictionary_id='54666.Hata Detayı'></h4>
                                            <p><u><cf_get_lang dictionary_id='40568.Hata Kodu'></u> : <strong class = "text-danger">#errorDetail.error.code#</strong></p>
                                            <p>#errorDetail.message.devdetail#</p>
                                            <p><u>Buglog</u> : #errorDetail.message.buglogMessage#</p>
                                            <p><u><cf_get_lang dictionary_id='29463.Mail'></u> : #errorDetail.message.mailMessage#</p>
                                            <p><u>System Log</u> : #errorDetail.message.logMessage#</p>
                                        </div>
                                        <div class = "col col-12">
                                            <h4><cf_get_lang dictionary_id='62418.Tavsiyeler'></h4>
                                            <p>#errorDetail.message.devadvice.text#</p>
                                        </div>
                                        <cfif structKeyExists(errorDetail.message.devadvice, "link") and arrayLen( errorDetail.message.devadvice.link )>
                                            <div class = "col col-12">
                                                <h4><cf_get_lang dictionary_id='50548.İlişkili İçerikler'></h4>
                                                <table class = "workDevList">
                                                    <cfloop array="#errorDetail.message.devadvice.link#" index="item">
                                                        <tr>
                                                            <td>#item.name#</td>
                                                            <td><a href = "#item.url#" target = "_blank">#item.url#</a></td>
                                                        </tr>
                                                    </cfloop>
                                                </table>
                                            </div>
                                        </cfif>
                                    <cfelse>
                                        <div class = "col col-12">
                                            <p><cf_get_lang dictionary_id='62419.Bu hatayı tanımlayamadık! Aşağıdaki hata çıktısını inceleyebilirsiniz!'>!</p>
                                            <p><u>Buglog</u> : #errorDetail.message.buglogMessage#</p>
                                            <p><u><cf_get_lang dictionary_id='29463.Mail'></u> : #errorDetail.message.mailMessage#</p>
                                            <p><u>System Log</u> : #errorDetail.message.logMessage#</p>
                                        </div>
                                    </cfif>
                                
                                    <cfset dumping = structKeyExists(errorDetail.error.dumping, "Cause") ? errorDetail.error.dumping.Cause : errorDetail.error.dumping />
                                    <cfset dumpingTagContext = structKeyExists(dumping, "RootCause") ? dumping.RootCause.TagContext : dumping.TagContext />
                                    
                                    <div class = "col col-12">
                                        <h4>CF <cf_get_lang dictionary_id='62420.Hata Çıktısı'></h4>
                                        <p>Message : #dumping.Message#</p>
                                        <p>Detail : #dumping.Detail#</p>
                                        <p>Type : #dumping.Type#</p>
                                        <cfif structKeyExists(dumping, "sql_type") and structKeyExists(dumping, "value")>
                                            <p>Sql Type : #dumping.sql_type#</p>
                                            <p>Value : #len(dumping.value) ? dumping.value : 'Empty String'#</p>
                                        </cfif>
                                        <cfif structKeyExists(dumping, "sql")>
                                            <p>Sql</p> 
                                            <textarea id = "sqlText">#dumping.sql#</textarea>
                                            <script>
                                                setTimeout(() => {
                                                    var editor = CodeMirror.fromTextArea(document.getElementById("sqlText"), {
                                                        mode: "text/x-sql",
                                                        lineNumbers: false
                                                    });
                                                }, 1000);
                                            </script>
                                        </cfif>
                                        <cfif structKeyExists(dumping, "where")>
                                            <p>Where : #dumping.where#</p>
                                        </cfif>
                                    </div>
                                    <div class = "col col-12">
                                        <h4 style = "cursor:pointer; color:##069;" onclick="if(document.getElementById('errorPageList').style.display === 'block') document.getElementById('errorPageList').style.display = 'none'; else document.getElementById('errorPageList').style.display = 'block';">
                                            <cf_get_lang dictionary_id='62421.Hatayla İlişkili Dosya ve Satırlar İçin Tıklayın'>
                                        </h4>
                                        <div class = "errorPageList" id = "errorPageList" style = "display:none;">
                                            <table class = "workDevList">
                                                <cfloop array="#dumpingTagContext#" index="item">
                                                    <tr>
                                                        <td>
                                                            <table class = "workDevList">
                                                                <cfif structKeyExists( item, "ID" )>
                                                                    <tr>
                                                                        <td>ID</td>
                                                                        <td>#item.ID#</td>
                                                                    </tr>
                                                                </cfif>
                                                                <cfif structKeyExists( item, "LINE" )>
                                                                    <tr>
                                                                        <td>LINE</td>
                                                                        <td>#item.LINE#</td>
                                                                    </tr>
                                                                </cfif>
                                                                <cfif structKeyExists( item, "RAW_TRACE" )>
                                                                    <tr>
                                                                        <td>RAW_TRACE</td>
                                                                        <td>#item.RAW_TRACE#</td>
                                                                    </tr>
                                                                </cfif>
                                                                <cfif structKeyExists( item, "TEMPLATE" )>
                                                                    <tr>
                                                                        <td>TEMPLATE</td>
                                                                        <td>#item.TEMPLATE#</td>
                                                                    </tr>
                                                                </cfif>
                                                                <cfif structKeyExists( item, "TYPE" )>
                                                                    <tr>
                                                                        <td>TYPE</td>
                                                                        <td>#item.TYPE#</td>
                                                                    </tr>
                                                                </cfif>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                </cfloop>
                                            </table>
                                        </div>
                                    </div>
                                    <cfif ((isDefined("workcube_mode") and workcube_mode eq 0) or (isdefined("session.ep.admin") and session.ep.admin eq 1))>
                                        <div class = "col col-12">
                                            <h4 style = "cursor:pointer; color:##069;" onclick="if(document.getElementById('error_detail').style.display === 'block') document.getElementById('error_detail').style.display = 'none'; else document.getElementById('error_detail').style.display = 'block';">
                                                <cf_get_lang dictionary_id='62422.Teknik Hata Çıktısı İçin Tıklayın'>
                                            </h4>
                                            <div id = "error_detail" style = "display:none;"><cfdump var="#errorDetail.error.dumping#"></div>
                                        </div>
                                    </cfif>
                                <cfelse>
                                    <h3>The system is temporarily unavailable! The system administrator has been informed. Thank you for your time and consideration.</h3>
                                </cfif>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="ui-form-list-btn">
                        <div class="col col-12">
                            <cfif isDefined("session.ep.USERID") and errorDetail.message.status>
                                <a href="<cfoutput>#request.self#?#cgi.query_string#&runwro=1</cfoutput>" class="ui-wrk-btn ui-wrk-btn-success ui-btn-sm" style="float:right;margin:5px 5px 5px 0px!important;">Run SQL Script</a>
                            </cfif>
                            <cfset fuseaction = (isdefined('url.fuseaction') and len( url.fuseaction )) ? url.fuseaction : ((isdefined('form.fuseaction') and len( form.fuseaction )) ? form.fuseaction : '') />
                            <a href="<cfoutput>#request.self#?fuseaction=help.popup_add_problem&help=#fuseaction#&error_code=#errorDetail.error.code#</cfoutput>" class="ui-wrk-btn ui-wrk-btn-success ui-btn-sm" style="float:right;margin:5px 5px 5px 0px!important;" target="_blank"><cf_get_lang dictionary_id = "55064.Sorun Bildir"></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
</cfsavecontent>

<!--- <cflog type="error" file="workcube_errors" text="Type: #error.type#</vr> Description: #error.diagnostics#"> --->

<cfif not isdefined("url.isAjax") and not isdefined("form.isAjax")>
    <cfoutput>#errorResult#</cfoutput>
    <script>
        document.getElementById("helpLink").setAttribute("onclick","window.open('<cfoutput>#request.self#?fuseaction=help.popup_add_problem&help=#fuseaction#&error_code=#errorDetail.error.code#</cfoutput>','<cf_get_lang dictionary_id = '60908.Destek Başvuru'>');");
    </script>
<cfelse>
    <cfdump var="#errorDetail.error.dumping#">
    <script>
        if(confirm("<cf_get_lang dictionary_id = '52126.Bir Hata Oluştu'>! \n <cf_get_lang dictionary_id='62417.Sayfayı yeniden yüklemek için Tamam butonuna tıklayabilirsiniz'>!")) location.reload();
    </script>
</cfif>