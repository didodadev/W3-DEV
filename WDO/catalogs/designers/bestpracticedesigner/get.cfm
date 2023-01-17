<cfset download_folder = application.systemParam.systemParam().download_folder />

<cffunction  name="get_bp_component">
    <cfargument  name="args" type="struct">
    <cfset arguments = arguments.args />

    <cffunction  name="get_file_list">
        <cfargument  name="file_path">
    
        <cfif DirectoryExists( arguments.file_path )>
            <cfdirectory action="list" directory="#arguments.file_path#" recurse="false" name="fileList">
            <cfreturn fileList>
        <cfelse>
            <cfreturn { recordCount : 0 }>
        </cfif>
    
    </cffunction>

    <cfset fileList = get_file_list( '#download_folder#/#arguments.file_path#' ) />

    <cfif fileList.recordCount>
        <ul class="ui-list">
            <cfoutput query="fileList">
                <li>
                    <a href="javascript:void(0)" <cfif Type neq 'Dir'>onclick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=getFileContent&isbox=1&box_title=<cf_get_lang dictionary_id="63176.Dosya Okuyucu">&file_path=#replace('#download_folder#/#arguments.file_path#/#Name#','\','/','all')#')"</cfif>>
                        <div class="ui-list-left">
                            <span class="ui-list-icon #Type eq 'Dir' ? 'ctl-office-material-2' : 'ctl-check-mark'#"></span>
                            #Name#
                        </div>
                        <div class="ui-list-right">
                            <cfif not findNoCase('documents', '#arguments.file_path#/#Name#')>
                                <i onclick="window.open('https://bitbucket.org/workcube/devcatalyst/src/dev/#arguments.file_path#/#Name#','Bitbucket')" class="fa fa-bitbucket"></i>
                            </cfif>
                            <cfif Type eq 'Dir'>
                                <i class="fa fa-chevron-down"></i>
                            </cfif>
                        </div>
                    </a>
                    <cfif Type eq 'Dir'>
                        <cfset dirFileList = get_file_list( '#Directory#/#Name#' ) />
                        <cfif dirFileList.recordCount>
                            <ul>
                                <cfloop query="#dirFileList#">
                                    <li>
                                        <a href="javascript:void(0)" <cfif dirFileList.Type neq 'Dir'>onclick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=getFileContent&isbox=1&box_title=<cf_get_lang dictionary_id="63176.Dosya Okuyucu">&file_path=#replace('#dirFileList.Directory#/#dirFileList.Name#','\','/','all')#')"</cfif>>
                                            <div class="ui-list-left">
                                                <span class="ui-list-icon #dirFileList.Type eq 'Dir' ? 'ctl-office-material-2' : 'ctl-check-mark'#"></span>
                                                #dirFileList.Name#
                                            </div>
                                            <div class="ui-list-right">
                                                <cfif not findNoCase('documents', '#arguments.file_path#/#Name#')>
                                                    <i onclick="window.open('https://bitbucket.org/workcube/devcatalyst/src/dev/#replace(replace(Directory,download_folder,''),'\','/','all')#/#dirFileList.Name#','Bitbucket')" class="fa fa-bitbucket"></i>
                                                </cfif>
                                                <cfif dirFileList.Type eq 'Dir'>
                                                    <i class="fa fa-chevron-down"></i>
                                                </cfif>
                                            </div>
                                        </a>
                                        <cfif Type eq 'Dir'>
                                            <cfset dirSecondFileList = get_file_list( '#dirFileList.Directory#/#dirFileList.Name#' ) />
                                            <cfif dirSecondFileList.recordCount>
                                                <ul>
                                                    <cfloop query="#dirSecondFileList#">
                                                        <li>
                                                            <a href="javascript:void(0)" <cfif dirSecondFileList.Type neq 'Dir'>onclick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=getFileContent&isbox=1&box_title=<cf_get_lang dictionary_id="63176.Dosya Okuyucu">&file_path=#replace('#dirFileList.Directory#/#dirFileList.Name#/#dirSecondFileList.Name#','\','/','all')#')"</cfif>>
                                                                <div class="ui-list-left">
                                                                    <span class="ui-list-icon #dirSecondFileList.Type eq 'Dir' ? 'ctl-office-material-2' : 'ctl-check-mark'#"></span>
                                                                    #dirSecondFileList.Name#
                                                                </div>
                                                                <div class="ui-list-right">
                                                                    <cfif not findNoCase('documents', '#arguments.file_path#/#Name#')>
                                                                        <i onclick="window.open('https://bitbucket.org/workcube/devcatalyst/src/dev/#replace(replace('#dirFileList.Directory#/#dirFileList.Name#',download_folder,''),'\','/','all')#/#dirSecondFileList.Name#','Bitbucket')" class="fa fa-bitbucket"></i>
                                                                    </cfif>
                                                                    <cfif dirSecondFileList.Type eq 'Dir'>
                                                                        <i class="fa fa-chevron-down"></i>
                                                                    </cfif>
                                                                </div>
                                                            </a>
                                                            <cfif dirSecondFileList.Type eq 'Dir'>
                                                                <cfset dirFileListThird = get_file_list( '#dirSecondFileList.Directory#/#dirSecondFileList.Name#' ) />
                                                                <cfif dirFileListThird.recordCount>
                                                                    <ul>
                                                                        <cfloop query="#dirFileListThird#">
                                                                            <li>
                                                                                <a href="javascript:void(0)" <cfif dirFileListThird.Type neq 'Dir'>onclick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=getFileContent&isbox=1&box_title=<cf_get_lang dictionary_id="63176.Dosya Okuyucu">&file_path=#replace('#dirSecondFileList.Directory#/#dirSecondFileList.Name#/#dirFileListThird.Name#','\','/','all')#')"</cfif>>
                                                                                    <div class="ui-list-left">
                                                                                        <span class="ui-list-icon #dirFileListThird.Type eq 'Dir' ? 'ctl-office-material-2' : 'ctl-check-mark'#"></span>
                                                                                        #dirFileListThird.Name#
                                                                                    </div>
                                                                                    <div class="ui-list-right">
                                                                                        <cfif not findNoCase('documents', '#arguments.file_path#/#Name#')>
                                                                                            <i onclick="window.open('https://bitbucket.org/workcube/devcatalyst/src/dev/#replace(replace('#dirFileListThird.Directory#',download_folder,''),'\','/','all')#/#dirFileListThird.Name#','Bitbucket')" class="fa fa-bitbucket"></i>
                                                                                        </cfif>
                                                                                        <cfif dirFileListThird.Type eq 'Dir'>
                                                                                            <i class="fa fa-chevron-down"></i>
                                                                                        </cfif>
                                                                                    </div>
                                                                                </a>
                                                                                <cfif dirFileListThird.Type eq 'Dir'>
                                                                                    <cfset dirFileListFourth = get_file_list( '#dirFileListThird.Directory#/#dirFileListThird.Name#' ) />
                                                                                    <cfif dirFileListFourth.recordCount>
                                                                                        <ul>
                                                                                            <cfloop query="#dirFileListFourth#">
                                                                                                <li>
                                                                                                    <a href="javascript:void(0)" <cfif dirFileListFourth.Type neq 'Dir'>onclick="openBoxDraggable('#request.self#?fuseaction=objects.widget_loader&widget_load=getFileContent&isbox=1&box_title=<cf_get_lang dictionary_id="63176.Dosya Okuyucu">&file_path=#replace('#dirFileListThird.Directory#/#dirFileListThird.Name#/#dirFileListFourth.Name#','\','/','all')#')"</cfif>>
                                                                                                        <div class="ui-list-left">
                                                                                                            <span class="ui-list-icon #dirFileListFourth.Type eq 'Dir' ? 'ctl-office-material-2' : 'ctl-check-mark'#"></span>
                                                                                                            #dirFileListFourth.Name#
                                                                                                        </div>
                                                                                                        <div class="ui-list-right">
                                                                                                            <cfif not findNoCase('documents', '#arguments.file_path#/#Name#')>
                                                                                                                <i onclick="window.open('https://bitbucket.org/workcube/devcatalyst/src/dev/#replace(replace('#dirFileListFourth.Directory#',download_folder,''),'\','/','all')#/#dirFileListFourth.Name#','Bitbucket')" class="fa fa-bitbucket"></i>
                                                                                                            </cfif>
                                                                                                        </div>
                                                                                                    </a>
                                                                                                </li>
                                                                                            </cfloop>
                                                                                        </ul>
                                                                                    </cfif>
                                                                                </cfif>
                                                                            </li>
                                                                        </cfloop>
                                                                    </ul>
                                                                </cfif>
                                                            </cfif>
                                                        </li>
                                                    </cfloop>
                                                </ul>
                                            </cfif>
                                        </cfif>
                                    </li>
                                </cfloop>
                            </ul>
                        </cfif>
                    </cfif>
                </li>
            </cfoutput>
        </ul>
        <script>
            $('.ui-list li a i.fa-chevron-down').click(function(){
                $(this).closest('.ui-list-right').toggleClass("ui-list-right-open");
                $(this).closest('li').find("> ul").fadeToggle();
            });
        </script>
    <cfelse>
        <cfoutput>This folder cannot found!</cfoutput>
    </cfif>

</cffunction>

<cffunction name = "get_add_component_form">
    <cf_box title="#getLang('','',48515)#" collapsable="0" resize="0" closable="1">
        <cfform name="addComponent" id="addComponent" action="">
            <cfinput type="hidden" name="id" value="#attributes.id#">
            <div class="row">
                <div class="ui-card">
                    <div class="ui-card-item">
                        <p><cf_get_lang dictionary_id='61166.Aşağıdaki dosya ekleme alanını kullanarak Best Practice bileşenlerinizi ekleyebilirsiniz'>.</p>
                        <h4><cf_get_lang dictionary_id='57757.Uyarılar'></h4>
                        <p><cf_get_lang dictionary_id='61169.Sadece zip uzantılı dosya yükleyebilirsiniz'></p>
                        <p><cf_get_lang dictionary_id='61170.Ekleyeceğiniz zip dosyası Best Practice ile aynı isme sahip olmalı ve boşluk, Türkçe karakter vb içermemelidir'>.</p>
                        <p><cf_get_lang dictionary_id='61171.Zip dosyası içerisinde Best Practice ile aynı isme sahip bir klasör olmalı ve tüm bileşenler bu klasör içerisinde toplanmalıdır'>.</p>
                        <p><cf_get_lang dictionary_id='61172.Yükleme işlemi tamamlandıktan sonra zip dosyanız içerisindeki tüm klasör ve dosyalar bileşenler bölümünde görüntülenecektir'>.</p>
                        <p><cf_get_lang dictionary_id='61173.Hatalı ya da eksik yükleme yaptığınızı düşünüyorsanız ve bileşenleri kalıcı olarak silmek istiyorsanız; Yükleme işlemi tamamlandıktan sonra File Path alanının değerini boşaltarak güncellemeniz yeterlidir'>.</p>
                    </div>
                </div>
                <div class="col col-12 pdn-l-0 pdn-r-0" type="column" index="1" sort="true">
                    <div class="form-group" id="item-componentFile">
                        <label class="col col-4 col-xs-12 pdn-l-0"><cf_get_lang dictionary_id='56.Dosya Seçin'>*</label>
                        <div class="col col-8 col-xs-12 pdn-r-0">
                            <input type="file" name="componentFile" id="componentFile" required accept=".zip">
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-12 col-xs-12 pdn-l-0 pdn-r-0">
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </div>
        </cfform>
    </cf_box>

    <script>
        function kontrol(){
            var data = new FormData(document.querySelector('#addComponent'));
            AjaxControlPostDataJson("<cfoutput>#request.self#?fuseaction=dev.bestpractice&event=upd&mode=save</cfoutput>", data, function(response){
                alert(response.message);
                if( response.status ){
                    document.getElementById('file_path').value = response.file_path;
                    getBpComponent();
                    document.querySelector('.catalystClose').click();
                    document.querySelector('.catalyst-plus').parentNode.remove();
                }
            });
            return false;
        }
    </script>

</cffunction>

<cfif IsDefined("attributes.method")>
    <cfset Evaluate("#attributes.method#(attributes)") />
</cfif>