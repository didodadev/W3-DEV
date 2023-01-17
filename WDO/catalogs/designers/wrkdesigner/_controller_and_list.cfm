<!---
    File: _controller_and_list.cfm
    Author: Botan KAYĞAN <botankaygan@workcube.com>
    Date: 27.08.2019
    Controller: -
    Description: WO Detay sayfasındayken eğer dosyanın controlleri varsa dosyanın konumunu va controllerda tanımlı eventları getirir.​
--->

<cfprocessingdirective pageencoding = "utf-8">
<cfscript>
	
    parseController = createObject("component","WDO.development.cfc.parseControllerPath");

    list = [];
    hreflist = [];
    controllerPath = "";
    if ( len( GET_WRK_FUSEACTIONS.CONTROLLER_FILE_PATH ) ) {

        content = parseController.Dosyaoku( GET_WRK_FUSEACTIONS.CONTROLLER_FILE_PATH );
        list = parseController.getEventPaths( content );
        hreflist = parseController.getOtherFilePath( content );
        controllerPath = GET_WRK_FUSEACTIONS.CONTROLLER_FILE_PATH;
        controllerPath = "/" & Replace( controllerPath, "wbo", "WBO", "ONE" );                            
    
    }
</cfscript>

<cf_box title="Source Files" id="sourceFiles" closable="0">
    <div class="row formContent">
        <div class="col col-12">
            <cfif len( controllerPath ) eq 0>
            <div>
                <cfoutput>
                    <a target="_blank" href="https://bitbucket.org/workcube/devcatalyst/src/master/V16/#GET_WRK_FUSEACTIONS.FILE_PATH#"><i class="fa fa-bitbucket"></i> #GET_WRK_FUSEACTIONS.FILE_PATH#</a>
                </cfoutput>
            </div>
            <cfelse>
                <div class="row mb-3">
                    <div class="form-group">
                        <label class="col col-3 col-xs-12"><strong>Controller</strong></label>
                        <label class="col col-9 col-xs-12"><cfoutput>#GET_WRK_FUSEACTIONS.CONTROLLER_FILE_PATH# <a target="_blank" href="https://bitbucket.org/workcube/devcatalyst/src/master/#GET_WRK_FUSEACTIONS.CONTROLLER_FILE_PATH#"><i class="fa fa-bitbucket"></i></a></cfoutput></label>
                    </div>
                </div>
                <cfif arrayLen( list ) neq 0>
                <cfloop index="elm" array="#list#">
                <cfoutput>
                <div class="row">
                    <div class="form-group">
                        <label class="col col-3 col-xs-12"><strong>#elm["eventName"]#</strong> | #elm["pathName"]#</label>
                        <div class="col col-6 col-xs-12"><input type="text" value="#elm["path"]#"></div>
                        <label class="col col-3 col-xs-12">
                            <a target="_blank" href="https://bitbucket.org/workcube/devcatalyst/src/master/#elm["path"]#"><i class="fa fa-bitbucket"></i></a>
                            <cfquery name="query_file_path" datasource="#dsn#">
                                SELECT FULL_FUSEACTION FROM WRK_OBJECTS
                                WHERE '#elm["path"]#' LIKE '%'+FILE_PATH
                            </cfquery>
                            <cfif query_file_path.recordCount>
                                <cfif query_file_path.FULL_FUSEACTION neq attributes.fuseact>
                                <cfloop query="query_file_path">
                                    <a target="_blank" href="#request.self#?fuseaction=dev.workdev&fuseact=#query_file_path.FULL_FUSEACTION#"><i class="fa fa-external-link"></i></a>
                                </cfloop>
                                </cfif>
                            </cfif>
                        </label>
                    </div>
                </div>
                </cfoutput>
                </cfloop>
            </cfif>
            </cfif>
        </div>
    </div>
</cf_box>

<cf_box title="Links" id="links" closable="0">
    <div class="row formContent">
        <div class="col col-12">
            <cfif arrayLen( hreflist ) eq 0>
                There are no any links!
            <cfelse>
            <cfloop index="elm" array="#hreflist#">
            <cfset paths = parseController.getPathFromDB( elm["link"] ) />
            <cfoutput>
            <div class="row">
                <div class="form-group">
                    <label class="col col-3 col-xs-12">#elm["type"]#</label>
                    <div class="col col-6 col-xs-12"><input type="text" value="#elm["link"]#"></div>
                    <label class="col col-3 col-xs-12">
                        <a target="_blank" href="https://bitbucket.org/workcube/devcatalyst/src/master/V16/#paths.FILE_PATH#"><i class="fa fa-bitbucket"></i></a>
                        <cfif reFindNoCase( '^[a-zA-Z0-9_]+\.[a-zA-Z0-9_]+', elm["link"]) gt 0>
                            <cfset match = reMatchNoCase( '^[a-zA-Z0-9_]+\.[a-zA-Z0-9_]+', elm["link"])>
                            <cfif arrayLen(match)>
                            <a target="_blank" href="#request.self#?fuseaction=dev.workdev&fuseact=#match[1]#"><i class="fa fa-external-link"></i></a>
                            </cfif>
                        </cfif>
                    </label>
                </div>
            </div>
            </cfoutput>
            </cfloop>
            </cfif>
        </div>
    </div>
</cf_box>