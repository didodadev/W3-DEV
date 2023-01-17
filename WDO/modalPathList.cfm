<cfprocessingdirective pageencoding = "utf-8">
	<cfscript>
	
		parseController = createObject("component","development/cfc/parseControllerPath");

            list = [];
            hreflist = [];
            controllerPath = "";        			
            if(len(GET_WRK_FUSEACTIONS.CONTROLLER_FILE_PATH)) {                        
                content = parseController.Dosyaoku(GET_WRK_FUSEACTIONS.CONTROLLER_FILE_PATH);
				list = parseController.getEventPaths(content);
                hreflist = parseController.getOtherFilePath(content);
                controllerPath = GET_WRK_FUSEACTIONS.CONTROLLER_FILE_PATH;
                controllerPath ="/"&Replace(controllerPath, "wbo", "WBO", "ONE");                            
            }						
	</cfscript>
    
    
    <div class="col col-12">
            <h3 class="workdevPageHead"><cfoutput>#getLang('objects',1095)#</cfoutput></h3>
    </div>
    <div class="row">
        <div class="col col-8 offset-md-1 col-md-12 col-xs-12">
                <cfif len(controllerPath) GT 0 >
                 <div class="form-group">
                                    
                                    <label class="col col-3 col-xs-12">Controller Path</label>
                                    <div class="col col-6 col-xs-10">
                                        <cfoutput>
                                            <input type="text" value="#controllerPath#">
                                        </cfoutput>    
                                    </div>
                                    <label class="col col-3 col-xs-2">
                                        <cfoutput>
                                        <a target="_blank" class="btn" href="https://bitbucket.org/workcube/beta-catalyst/src/dev/#controllerPath#">Düzenle</a>
                                        </cfoutput>
                                    </label>
                                    
                                </div>    
       
        </cfif>
                <cfif ArrayLen(list)>
                    <cfloop index="i"  array="#list#">
                        <cfoutput>
                                <div class="form-group">
                                    
                                    <label class="col col-3 col-xs-12">#i["eventName"]# / #i["pathName"]#</label>
                                    <div class="col col-6 col-xs-10">
                                        <input type="text" value="#i["path"]#">
                                    </div>
                                    <label class="col col-3 col-xs-2">
                                        <a target="_blank" class="btn" href="https://bitbucket.org/workcube/beta-catalyst/src/dev/#i['path']#">Düzenle</a>
                                    </label>
                                </div>
                    </cfoutput>
                </cfloop>
                </cfif>
                
                
        </div>
	</div>

    <div class="col col-12">
            <h3 class="workdevPageHead"><cfoutput>#getLang('dev',199)#</cfoutput></h3>
    </div>
    <div class="row">
        <div class="col col-8  offset-md-1 col-md-12 col-xs-12">
        <cfif ArrayLen(hreflist)>
            <cfloop index="i" array="#hreflist#">
                                            
                            <div class="form-group">
                                <cfoutput>
                                <label class="col col-3 col-xs-12">#i["type"]#</label>
                                <div class="col col-6 col-xs-10">
                                    <input type="text" value="#i["link"]#">
                                </div>
                                <label class="col col-3 col-xs-2">
                                </cfoutput>    
                                
                                <cfset paths = parseController.getPathFromDB(i["link"]) />

                                <cfoutput>
                                  
                                    <cfif len(paths.FILE_PATH)>
                                      <a target="_blank" href="https://bitbucket.org/workcube/beta-catalyst/src/dev/V16/#paths.FILE_PATH#" class="btn">F</a>
                                    
                                    </cfif>
                                    
                                    <cfif  len(paths.CONTROLLER_FILE_PATH)>
                                        <cfset controllerpath= "https://bitbucket.org/workcube/beta-catalyst/src/dev/"&Replace(paths.CONTROLLER_FILE_PATH, "wbo", "WBO","ONE")  />
                                        <a target="_blank" href="#controllerpath#" class="btn">C</a>
                                    </cfif>

                                   
                                </cfoutput>
                                </label>
                            </div>         
            </cfloop>
        </cfif>
        
        
        </div>
	</div>
