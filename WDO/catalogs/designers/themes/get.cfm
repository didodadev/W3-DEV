<cfset download_folder = application.systemParam.systemParam().download_folder />

<cffunction  name="get_theme_component">
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
    <div class="col col-4 col-md-6 col-sm-12">
        <ul class="ui-list">
            <cfoutput query="fileList">
                <li>
                    <a href="javascript:void(0)">
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
                                        <a href="javascript:void(0)">
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
                                                            <a href="javascript:void(0)">
                                                                <div class="ui-list-left">
                                                                    <span class="ui-list-icon #dirSecondFileList.Type eq 'Dir' ? 'ctl-office-material-2' : 'ctl-check-mark'#"></span>
                                                                    #dirSecondFileList.Name#
                                                                </div>
                                                                <div class="ui-list-right">
                                                                    <cfif not findNoCase('documents', '#arguments.file_path#/#Name#')>
                                                                        <i onclick="window.open('https://bitbucket.org/workcube/devcatalyst/src/dev/#replace(replace('#dirFileList.Directory#/#dirFileList.Name#',download_folder,''),'\','/','all')#/#dirSecondFileList.Name#','Bitbucket')" class="fa fa-bitbucket"></i>
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
            </cfoutput>
        </ul>
        <script>
            $('.ui-list li a i.fa-chevron-down').click(function(){
                $(this).closest('.ui-list-right').toggleClass("ui-list-right-open");
                $(this).closest('li').find("> ul").fadeToggle();
            });
        </script>
    </div>
   
    <cfset main_folder = Replace(application.systemParam.systemParam().index_folder,"V16/","")>
    <cfdirectory directory="#main_folder##arguments.file_path#/preview" name="preview_list" action="LIST">
    <cfif preview_list.recordcount gt 0>                
        <div class="col col-8 col-md-6 col-xs-12">
            <div class="theme_previews" style=" width: 600px; padding: 10px; border: 3px dotted #d2d7da; }">
                <cfloop query = "preview_list"> 
                    <div><img class="img-responsive" style="max-width: 600px;" alt="<cfoutput>#name#</cfoutput>" src="<cfoutput>#arguments.file_path#/preview/#name#</cfoutput>" /></div>                       
                </cfloop>
            </div>
            <script>
                $('.theme_previews').slick({
                    dots: true,
                    infinite: true,
                    speed: 500,
                    fade: true,
                    cssEase: 'linear'
                });
            </script>
        </div>
    </cfif>
    
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
                        <p>A??a????daki dosya ekleme alan??n?? kullanarak Tema bile??enlerinizi ekleyebilirsiniz.</p>
                        <h4><cf_get_lang dictionary_id='57757.Uyar??lar'></h4>
                        <p><cf_get_lang dictionary_id='61169.Sadece zip uzant??l?? dosya y??kleyebilirsiniz'></p>
                        <p>Ekleyece??iniz zip dosyas?? Tema ile ayn?? isme sahip olmal?? ve bo??luk, T??rk??e karakter vb i??ermemelidir.</p>
                        <p>Zip dosyas?? i??erisinde Tema ile ayn?? isme sahip bir klas??r olmal?? ve t??m bile??enler bu klas??r i??erisinde toplanmal??d??r.</p>
                        <p><cf_get_lang dictionary_id='61172.Y??kleme i??lemi tamamland??ktan sonra zip dosyan??z i??erisindeki t??m klas??r ve dosyalar bile??enler b??l??m??nde g??r??nt??lenecektir'>.</p>
                        <p><cf_get_lang dictionary_id='61173.Hatal?? ya da eksik y??kleme yapt??????n??z?? d??????n??yorsan??z ve bile??enleri kal??c?? olarak silmek istiyorsan??z; Y??kleme i??lemi tamamland??ktan sonra File Path alan??n??n de??erini bo??altarak g??ncellemeniz yeterlidir'>.</p>
                    </div>
                </div>
                <div class="col col-12 pdn-l-0 pdn-r-0" type="column" index="1" sort="true">
                    <div class="form-group" id="item-componentFile">
                        <label class="col col-4 col-xs-12 pdn-l-0"><cf_get_lang dictionary_id='56.Dosya Se??in'>*</label>
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
            AjaxControlPostDataJson("<cfoutput>#request.self#?fuseaction=dev.themes&event=upd&mode=save</cfoutput>", data, function(response){
                alert(response.message);
                if( response.status ){
                    document.getElementById('file_path').value = response.file_path;
                    getWPTComponent();
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