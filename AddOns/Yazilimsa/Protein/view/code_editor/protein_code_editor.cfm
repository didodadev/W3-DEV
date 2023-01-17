<!---
    File :          AddOns\Yazilimsa\Protein\view\code_editor\protein_code_editor.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          20.06.2022
    Description :   Protein Tema Düzenleme Code Editörü
--->
<cfif not isDefined("attributes.isajax")>
  <cflocation url="#request.self#?fuseaction=protein.code_editor&isajax=1" addtoken="no">
  <cfabort>
</cfif>
<cffunction  name="dirFolder">
  <cfargument  name="folder">
  <cfargument  name="listClass" default="">    
  <cfdirectory action="list" directory="#folder#" recurse="false" name="protein_files">
  <cfquery dbtype="query" name="find_files">
      SELECT * FROM protein_files WHERE NAME NOT LIKE '.%'
  </cfquery>
  <cfsavecontent variable="folders">
      <ul <cfoutput>#(LEN(listClass))?"class='#listClass#'":"class='hidden'"#</cfoutput>>
          <cfloop query="find_files">
              <cfoutput>
                  <li class="#(Type eq "Dir")?"folder":"File"#"  
                    <cfif Type eq "File">
                      <cfset Extension = listToArray("#Name#",".")>
                      @click="openProteinEditor(
                        '#encrypt("#Directory#/#Name#",'protein_3d','CFMX_COMPAT','Hex')#',
                        '#Name#',
                        '#Extension[2]#',
                        '#Size#',
                        '#dateFormat(DateLastModified, "dd.MM.YYYY HH:mm:ss")#'
                        )"
                    </cfif>
                  >
                      <span class="#(Type eq "Dir")?"open-folder":""#">#NAME#</span>
                      <cfif Type eq "Dir">
                          #dirFolder(folder:"#Directory#/#Name#")#
                      </cfif>
                  </li>                           
              </cfoutput>
          </cfloop>
      </ul>
      <!--- Directory NAME --->
  </cfsavecontent>
  <cfreturn folders>
</cffunction>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Protein Editor</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <link rel="stylesheet" href="/AddOns/Yazilimsa/Protein/src/assets/css/protein.css?v=22042022" />
    <link rel="stylesheet" href="/css/assets/icons/icon-Set/icon-Set.css" type="text/css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js" integrity="sha384-7+zCNj/IqJ95wo16oMtfsKbZ9ccEh31eOz1HGyDuCQ6wgnyJNSYdrPa03rtR1zdB" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>
    
    <script src="/JS/assets/plugins/vue.js"></script>
    <script src="/JS/assets/plugins/axios.min.js"></script>
    <script src="/AddOns/Yazilimsa/Protein/src/assets/js/protein_general_functions.js"></script>
    <script src="/AddOns/Yazilimsa/Protein/src/assets/js/protein_trap.js"></script>
    <script src="https://unpkg.com/monaco-editor@latest/min/vs/loader.js"></script>

    <style>
      /* The list style
      -------------------------------------------------------------- */

      ul.directory-list {
        padding: 0px 7px;
      }

      .directory-list ul {
        margin-left: 10px;
        padding-left: 5px;
        border-left: 1px dashed #569ccb;
      }



      .directory-list li {
        list-style: none;
        color: #888;
        font-size: 17px;
        font-weight: normal;
      }

      .directory-list span {
        border-bottom: 1px solid transparent;
        color: #888;
        text-decoration: none;
        transition: all 0.2s ease;
        cursor:pointer;
      }

      .directory-list sapn:hover {
        border-color: #eee;
        color: #000;
      }

      .directory-list .folder,
      .directory-list .folder > a {
        color: #777;
      }


      /* The icons
      -------------------------------------------------------------- */

      .directory-list li:before {
        margin-right: 0px;
        content: "";
        height: 20px;
        vertical-align: middle;
        width: 20px;
        background-repeat: no-repeat;
        display: inline-block;
        /* file icon by default */
        background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><path fill='lightgrey' d='M85.714,42.857V87.5c0,1.487-0.521,2.752-1.562,3.794c-1.042,1.041-2.308,1.562-3.795,1.562H19.643 c-1.488,0-2.753-0.521-3.794-1.562c-1.042-1.042-1.562-2.307-1.562-3.794v-75c0-1.487,0.521-2.752,1.562-3.794 c1.041-1.041,2.306-1.562,3.794-1.562H50V37.5c0,1.488,0.521,2.753,1.562,3.795s2.307,1.562,3.795,1.562H85.714z M85.546,35.714 H57.143V7.311c3.05,0.558,5.505,1.767,7.366,3.627l17.41,17.411C83.78,30.209,84.989,32.665,85.546,35.714z' /></svg>");
        background-position: center 2px;
        background-size: 60% auto;
      }

      .directory-list li.folder:before {
        /* folder icon if folder class is specified */
        background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><path fill='lightblue' d='M96.429,37.5v39.286c0,3.423-1.228,6.361-3.684,8.817c-2.455,2.455-5.395,3.683-8.816,3.683H16.071 c-3.423,0-6.362-1.228-8.817-3.683c-2.456-2.456-3.683-5.395-3.683-8.817V23.214c0-3.422,1.228-6.362,3.683-8.817 c2.455-2.456,5.394-3.683,8.817-3.683h17.857c3.422,0,6.362,1.228,8.817,3.683c2.455,2.455,3.683,5.395,3.683,8.817V25h37.5 c3.422,0,6.361,1.228,8.816,3.683C95.201,31.138,96.429,34.078,96.429,37.5z' /></svg>");
        background-position: center top;
        background-size: 75% auto;
        
      }

      .elem { display:none; }
      .hidden { display:none; }
      #protein_editor {
          width: 100%;
          height: 100%;
          margin: 0;
          padding: 0;
          overflow: hidden;
      }

      .code-tab{
        border: 1px #1e1e1e !important;
        color: #959191 !important;
     }
      .code-tab.active{
        background: #1e1e1e !important;
        border: 1px #1e1e1e !important;
        color: #959191 !important;
     }
     

    html, body, #container,.container-fluid{
        left: 0;
        top: 0;
        height: 100% !important;
        margin: 0;
        padding: 0;
        overflow:hidden;
    }

    .card.tool-box-top .card-header .btn {
        margin-right: 8px;
    }

    i.protein-editor-code-status {
        font-size: 9px;
        color: white;
        top: -1px;
        position: relative;
    }
    </style>
    
  </head>
  <body style="background: #2c2c2c;">  
    <div id="proteinCodeEditor" class="container-fluid">
        <div class="row" style="height: 100%">
            <div class="col-3 p-1">
              <div class="card text-white bg-dark mb-3">
                <div class="card-header">
                  <ul class="nav nav-tabs card-header-tabs">
                    <li class="nav-item">
                      <a class="nav-link active code-tab" aria-current="true" href="#">Files</a>
                    </li>
                    <li class="nav-item">
                      <a class="nav-link code-tab" aria-current="true" href="#">Search</a>
                    </li>
                    <li class="nav-item">
                      <a class="nav-link code-tab" aria-current="true" href="#">Diff</a>
                    </li>
                  </ul>
                </div>
                <div class="card-body" style=" background-color:#1e1e1e;">
                  <cfset protein_folder = #replace(application.systemParam.INDEX_FOLDER,"v16/","")#>
                  <cfset protein_folder = #replace(protein_folder,"V16/","")#>
                  <cfoutput>
                  #dirFolder(FOLDER:"#protein_folder#AddOns/Yazilimsa/Protein/reactor/themes/",LISTCLASS :"directory-list")#                         
                  </cfoutput>
                </div>
              </div>	
            </div>
            <div class="col-9 p-1">
              <div class="card text-white bg-dark mb-3 tool-box-top" style="height: calc(100% - 10px);">
                <div class="card-header d-flex justify-content-between">
                  <ul class="nav nav-tabs card-header-tabs">
                    <li class="nav-item">
                      <a class="nav-link active code-tab" aria-current="true" href="#">{{opened_file}} 
                      <i v-if="!save_status" class="fa fa-circle protein-editor-code-status"></i>
                      </a>
                    </li>
                  </ul>
                  <ul class="nav nav-pills card-header-pills">
                    <li class="nav-item" @click="saveProteinEditor()">
                      <a class="btn btn-sm btn-success" href="#">Save</a>
                    </li>
                    <li class="nav-item">
                      <a class="btn btn-sm btn-secondary" href="#">Discard</a>
                    </li>
                  </ul>
                </div>
                <div class="card-body p-0">
                  <div id="protein_editor"></div>                  
                </div>
                <div class="card-footer text-muted align-items-center  d-flex justify-content-between">
                  <div class="footer-file-info">
                    <i class="fa fa-file"></i> {{extension}} | <i class="fa fa-database"></i> {{size}} bytes | <i class="fa fa-edit"></i> {{last_modified}}
                  </div>
                  <div class="footer-copyright-protein-sa">
                    Protein Editor
                  </div>
                </div>
              </div>
            </div>
        </div>
    </div>
    
    <script>
      require.config({ paths: { 'vs': 'https://unpkg.com/monaco-editor@latest/min/vs' }});
      window.MonacoEnvironment = { getWorkerUrl: () => proxy };

      let proxy = URL.createObjectURL(new Blob([`
        self.MonacoEnvironment = {
          baseUrl: 'https://unpkg.com/monaco-editor@latest/min/'
        };
        importScripts('https://unpkg.com/monaco-editor@latest/min/vs/base/worker/workerMain.js');
      `], { type: 'text/javascript' }));

      require(["vs/editor/editor.main"], function () {
         proteinEditor = monaco.editor.create(document.getElementById('protein_editor'), {
          value: '',
          language: 'css',
          theme: 'vs-dark'
        });
        proteinEditor.addCommand(monaco.KeyMod.CtrlCmd | monaco.KeyCode.KeyS, function() {
          proteinApp.saveProteinEditor();
          return false;
        });
        proteinEditor.onKeyDown(function (e) {
          proteinApp.save_status = false;
        });
        axios.get("/AddOns/Yazilimsa/Protein/cfc/codeEditor.cfc?method=getInfo").then(response => {
          console.clear();
          console.log(response.data.INFO);
          proteinEditor.getModel().setValue(response.data.INFO);
        })
      });
     
    </script>
    <script>
      var proteinApp = new Vue({
          el: '#proteinCodeEditor',
          data: {
            protein: 'sa',
            opened_file:'welcome',
            extension : 'Plain Text',
            size:0,
            last_modified:'',
            cry_file:'',
            save_status : true,
            extensions : {
              css:'css',
              scss:'scss',
              js:'javascript',
              cfm:'html',
              cfc:'html',
              html:'html'
            }
          },
          methods: {
              protein : function(){
                  axios.get( "/cfc/system/login.cfc?method=x",{params:{key:200}})
                  .then(response => {
                     setTimeout(function(){location.reload();} , 2000);                              
                  })
                  .catch(e => {
                     console.log("");
                  })
              },
              openProteinEditor : function(file,file_name,extension,size,last_modified){
                _this = this
                _this.cry_file = file;

                if (!_this.save_status) {
                  let controlChange;
                  if (confirm("Kaydedilmemiş Değişiklik Var! Devam Etmek İster Misin?") == true) {
                    _this.save_status = true;
                  } else {
                    _this.save_status = false;
                  }
                  
                }
               

                if(_this.save_status){
                  axios.get( "/AddOns/Yazilimsa/Protein/cfc/codeEditor.cfc?method=getFile",{params:{file:file}})
                    .then(response => {
                      proteinEditor.getModel().setValue(response.data.FILE_CONTENT);
                      _this.opened_file = file_name;
                      _this.extension = extension;
                      _this.size = size; 
                      _this.last_modified = last_modified; 
                      _this.save_status = true;
                      monaco.editor.setModelLanguage(proteinEditor.getModel(),_this.extensions[extension]);                    
                      console.log("🧨",response);                           
                    })
                    .catch(e => {
                      console.log("🧨🧨🧨");
                    })
                  }
              },
              saveProteinEditor : function(){
                _this = this
                _get_editor_val = proteinEditor.getModel().getValue();
                var formData = new FormData();
						    formData.append('file', _this.cry_file);
                formData.append('file_content', _get_editor_val);    
                axios
                  ({
                    method: "post",
                    url: "/AddOns/Yazilimsa/Protein/cfc/codeEditor.cfc?method=setFile",
                    data: formData,
                    headers: { "Content-Type": "multipart/form-data"}
                  })
                  .then(response => {
                    if(response.data.STATUS){
                      _this.save_status = true;
                    }                    
                    console.log(response.data)                   
                  })
                  .catch(e => {
                     console.log("🧨🧨🧨");
                  })
              }
          },
          mounted () {             
           //protein editor mounted           
          }      
      });
  </script>
  <script>
      $(".open-folder").click(function(){
      var obj = $(this).next();
          if($(obj).hasClass("hidden")){
              $(obj).removeClass("hidden").slideDown();
          } else {
              $(obj).addClass("hidden").slideUp();
          }
      });

      
      $(function() {
        proteinTrap.bind(['command+s', 'ctrl+s'], function() {
          proteinApp.saveProteinEditor();
          return false;
        });       
      });
  </script>
  </body>
</html>
<!--- proteinEditor.getModel().getValue()
proteinEditor.getModel().setValue('some value'); --->