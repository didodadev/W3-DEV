<script type="text/javascript" src="/JS/bootstrap.min.js"></script>
<link rel="stylesheet" href="/css/assets/template/workdev/animate.css">
<link rel="stylesheet" href="/css/assets/template/workdev/workdev.min.css">
<style>
.flex{
    display:flex;
    flex-wrap: wrap;
    justify-content:center;
}
.flex span, .flex a{
    display:flex;
    justify-content:center;
    color:#463a3a;
}
.box_link {
  background-color:transparent;
  border-radius: 5px;
  transition:.4s;
  height: 125px;
  margin: 10px;
  position: relative;
  flex-direction:column;
  width: 150px;
  cursor:pointer;
  
}
.box_link:hover{
    background-color:#fff;color:#FF9800;box-shadow:0 0 5px rgba(174,174,174,.25);transition:.4s;
} 
</style>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="head">
        <cf_get_lang dictionary_id='47614.Dev'><cf_get_lang dictionary_id='60879.Tools'>
    </cfsavecontent>
<cf_box title="#head#">
    <div class="flex">
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.wo</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0006 fa-2x" title="Workcube Objects"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60941.WORKCUBE OBJECTS'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.widget</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0142 fa-2x" title="<cf_get_lang dictionary_id='60942.Widgets'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60942.WIDGETS'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.wex</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0041 fa-2x" title="<cf_get_lang dictionary_id='47849.WEX'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='47849.WEX'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.mockup</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-list-alt fa-2x" title="MOCKUP"></i></div>
                <div class="searchText">MOCKUP</div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.extensions</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0207 fa-2x" title="Extensions"></i></div>
                <div class="searchText">EXTENSIONS</div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.process_templates</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0003 fa-2x" title="Extensions"></i></div>
                <div class="searchText">PROCESS TEMPLATES</div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.output_templates</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0135 fa-2x" title="Extensions"></i></div>
                <div class="searchText">OUTPUT TEMPLATES</div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.utility</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0026 fa-2x" title="Utility"></i></div>
                <div class="searchText">UTILITY</div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#</cfoutput>?fuseaction=dev.menudesigner">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-sitemap fa-2x" title="<cf_get_lang dictionary_id='60944.Menu Designer'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60944.MENU DESIGNER'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.bestpractice</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0133 fa-2x" title="<cf_get_lang dictionary_id='60945.Best Practice'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60945.BEST PRACTICE'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.imp_steps</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0025 fa-2x" title="<cf_get_lang dictionary_id='60946.Implementation Steps'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60946.IMPLEMENTATION STEPS'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.icons</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"> <i class="wrk-uF0176 fa-2x" title="<cf_get_lang dictionary_id='60947.Icons'>"></i> </div>
                <div class="searchText"><cf_get_lang dictionary_id='60947.ICONS'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.css</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0216 fa-2x" title="<cf_get_lang dictionary_id='60948.CSS Standarts'>"></i> </div>
                <div class="searchText"><cf_get_lang dictionary_id='60948.CSS STANDARTS'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.themes</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0004 fa-2x" title="<cf_get_lang dictionary_id='63860.Protein Themes'>"></i> </div>
                <div class="searchText"><cf_get_lang dictionary_id='63859.THEMES'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.testkits</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0206 fa-2x" title="<cf_get_lang dictionary_id='60949.Test Results'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60949.TEST RESULTS'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=settings.data_source</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-plug fa-2x" title="<cf_get_lang dictionary_id='62668.DATA SOURCE'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='62668.DATA SOURCE'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.database</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-database fa-2x" title="<cf_get_lang dictionary_id='60950.Database'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60950.DB MANAGER'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.schema_comparison</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-trello fa-2x" title="<cf_get_lang dictionary_id='60951.Schema Compare'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60951.SCHEMA COMPARE'></div>
            </div>
        </a>
        <!--- <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.list_db_change</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-ERP-Finans-Muhasebe fa-2x" title="<cf_get_lang dictionary_id='60952.DB Change'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60952.DB CHANGE'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=dev.list_repaet_column</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0185 fa-2x" title="<cf_get_lang dictionary_id='60953.Column Repeat'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60953.COLUMN REPEAT'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=dev.popup_add_index</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-table fa-2x" title="<cf_get_lang dictionary_id='60954.DB Index'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60954.DB INDEX'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.code_search</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0086 fa-2x" title="<cf_get_lang dictionary_id='60955.CODE SEARCH'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60955.CODE SEARCH'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.language_search</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-language fa-2x" title="<cf_get_lang dictionary_id='60956.LANGUAGE SEARCH'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60956.LANGUAGE SEARCH'></div>
            </div>  
        </a>  --->
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.wo_dashboard</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0022 fa-2x" title="<cf_get_lang dictionary_id='60957.DEV DASHBOARD'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60957.DEV DASHBOARD'></div>
            </div>  
        </a> 
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6"  href="<cfoutput>#request.self#?fuseaction=dev.system</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-microchip fa-2x" title="<cf_get_lang dictionary_id='47646.System'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='47646.SYSTEM'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=settings.aiclass</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="wrk-uF0220 fa-2x" title="<cf_get_lang dictionary_id='60958.AI Class'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='60958.AI CLASS'></div>
            </div>
        </a>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.data_import_library</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-stack-overflow fa-2x" title="<cf_get_lang dictionary_id='62732.Data İmport Library'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='62732.Data İmport Library'></div>
            </div>
        </a>
        <cfif findNoCase("networg.workcube.com", cgi.server_name) or findNoCase("qa.workcube.com", cgi.server_name) or findNoCase("dev.workcube.com", cgi.server_name) or findNoCase("devcatalyst", cgi.server_name) or findNoCase("localhost", cgi.server_name)>
            <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.bitbucket</cfoutput>" target="_blank">
                <div class="box_link flex">
                    <div class="searchText"><i class="fa fa-random fa-2x" title="GIT REQUESTS"></i></div>
                    <div class="searchText">GIT REQUESTS</div>
                </div>
            </a>
        </cfif>
        <cfif structKeyExists(application.objects, "plevne.dashboard")>
            <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=plevne.dashboard</cfoutput>" target="_blank">
                <div class="box_link flex">
                    <div class="searchText"><i class="fa fa-shield fa-2x" title="PLEVNE"></i></div>
                    <div class="searchText">PLEVNE</div>
                </div>
            </a>
        </cfif>
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=settings.list_languages_deff</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-language fa-2x" title="Dil Gelişimi"></i></div>
                <div class="searchText">Dil Gelişimi</div>
            </div>  
        </a> 
        <a class="col col-2 col-md-2 col-sm-3 col-xs-6" href="<cfoutput>#request.self#?fuseaction=dev.wiki_progress</cfoutput>" target="_blank">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-wikipedia-w fa-2x" title="<cf_get_lang dictionary_id='65338.Wiki Gelişimi'>"></i></div>
                <div class="searchText"><cf_get_lang dictionary_id='65338.Wiki Gelişimi'></div>
            </div>  
        </a> 
    </div>
</cf_box>
    <!--- 
         <span class="col col-2 col-md-2 col-sm-3 col-xs-6"  href="https://bitbucket.org/">
            <div class="box_link flex">
                <div class="searchText"><i class="fa fa-bitbucket fa-2x" title="<cf_get_lang dictionary_id='Bitbucket"></i></div>
                <div class="searchText">BITBUCKET</div>
            </div>
        </span>
        <span class="col col-2 col-md-2 col-sm-3 col-xs-6">
        <div class="box_link flex">
            <div class="searchText"><i class="fa fa-database fa-2x"></i></div>
            <div class="searchText">DB Changes</div>
        </div>
    </span>
    <span class="col col-2 col-md-2 col-sm-3 col-xs-6">
        <div class="box_link flex">
            <div class="searchText"><i class="fa fa-columns fa-2x"></i></div>
            <div class="searchText">Column Report</div>
        </div>
    </span>
    <span class="col col-2 col-md-2 col-sm-3 col-xs-6">
        <div class="box_link flex">
            <div class="searchText" style="font-size:30px;"><i class="catalyst-eyeglasses"></i></div>
            <div class="searchText">Test Result</div>
        </div>
    </span>
    <span class="col col-2 col-md-2 col-sm-3 col-xs-6">
        <div class="box_link flex">
            <div class="searchText"><i class="fa fa-list fa-2x"></i></div>
            <div class="searchText">Indexes</div>
        </div>
    </span>
    <span class="col col-2 col-md-2 col-sm-3 col-xs-6">
        <div class="box_link flex">
            <div class="searchText"><i class="fa fa-lightbulb-o fa-2x"></i></div>
            <div class="searchText">Data Meaning</div>
        </div>
    </span>
    <span class="col col-2 col-md-2 col-sm-3 col-xs-6">
            <div class="box_link flex">
            <div class="searchText"><i class="fa fa-database fa-2x"></i></div>
            <div class="searchText">Create WRO</div>
        </div>  
    </span>
    --->

</div>
