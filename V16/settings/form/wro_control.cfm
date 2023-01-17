<cfscript>
   // getComponent = createObject('component','V16.objects.cfc.upgrade_notes');
    //get_release_version = getComponent.GET_RELEASE_VERSION();
	release_date = dateformat(dateadd('d',-360,now()),'yyyy-mm-dd H:m:s');
    new_release_date = dateformat(Now(),'yyyy-mm-dd H:m:s');
</cfscript>
<style>.fa-angle-down{cursor:pointer;}.activeTr{background:#f5f5f5;}.flagTrue{color:green;}.flagFalse{color:red;}.flagWarning{color:orange;}</style>
<link rel="stylesheet" href="/css/assets/template/codemirror/codemirror.css">
<script type="text/javascript" src="/JS/codemirror/codemirror.js"></script>
<script type="text/javascript" src="/JS/codemirror/simplescrollbars.js"></script>
<script type="text/javascript" src="/JS/codemirror/sql.js"></script>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <div class="row">
            <div class="col col-12"><h2 style="color:#ff4411;font-size:24px;">WRO : Workcube Release Objects</h2></div>
        </div>
        <div class="row" type="row">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                <label class="col"><button type="button" id="import_sql_script" class="ui-wrk-btn ui-wrk-btn-success">Update Sql Scripts</button></label>
                <label class="col"><button type="button" name="wo_scr" id="wo_scr" class="ui-wrk-btn ui-wrk-btn-info">Update Workcube Objects</button></label>
                <label class="col"><button type="button" id="lang_scr" class="ui-wrk-btn ui-wrk-btn-warning">Update Languages</button></label>
                <label class="col"><a class="ui-wrk-btn ui-wrk-btn-red" href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.data_services" target="_blank">Get Workcube Data Services</a></label>
            </div>
            <div id="listTable" class="col col-12 mt-3">
                <div class="col col-12 release_info">
                    <div class="before-release col col-12">
                        <h3>Welcome to the WRO - (Workcube Release Object)</h3>
                        <h4 class="mt-3 mb-3">What's the WRO?</h4>
                        <p>Workcube is a constantly developed business software and only works useful when it is up to date. <!--- Workcube sürekli geliştirilen bir iş yazılımıdır ve ancak güncel olduğunda faydalı olarak çalışır. ---></p>
                        <p>The Workcube team attaches great importance to keeping customers' systems up to date and designs various tools for this. <!--- Workcube ekibi müşterilerinin sistemlerinin güncel tutulmasına fazlasıyla önem verir ve bunun için çeşitli araçlar tasarlar. ----></p>
                        <p>It is designed to keep our WRO customer systems up to date and used for the following purposes. <!---- WRO, müşteri sistemlerimizin güncel tutulması için tasarlanmıştır ve aşağıdaki amaçlar için kullanılır. ----></p>
                        <div class="col col-12 mt-3 mb-3" style="font-size:14px;">
                            <ul>
                                <li style="list-style:circle; padding:5px;">Manipulates your database to match Workcube's current database structure. <!--- Veritabanınızı Workcube'ün güncel veritabanı yapısı ile eşlemek için manipüle eder ---></li>
                                <li style="list-style:circle; padding:5px;">It gets current solutions, families, modules, objects, widgets, languages from Workcube and upload your system. <!---- Workcube'den güncel solution, family, module, object, widged, dilleri alır ve sisteminizi yükler ----></li>
                            </ul>
                        </div>
                        <h4 class="mt-3 mb-3">How Does It Works?</h4>
                        <p>If you want to manipulate your database click to Update Sql Scripts button then click to exucute button in bottom of the page</p>
                        <p>If you want to update your solutions, families, modules, objects, widgets click to Update Objects button then click to Upgrade button</p>
                        <p>If you want to update your languages click to Update Languages button then click to Upgrade button</p>
                        <p>For more information <a href="https://wiki.workcube.com/help/9791" target="_blank">click here</a> </p>
                    </div>
                </div>                
            </div>
        </div>
    </cf_box>
</div>
<script type="text/javascript">
    $( "#import_sql_script" ).click(function() {
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.wro_control_list&is_work=0</cfoutput>','listTable',1);
	});
    //dil scriptleri
    $( "#lang_scr" ).click(function() {
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.wro_control_list&woLang=1</cfoutput>','listTable',1);
    });
    //WO scripts
    $( "#wo_scr" ).click(function() {
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.wro_control_list&woLang=0</cfoutput>','listTable',1);
	});
    //Workcube Data Service
    $( "#data_services" ).click(function() {

        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.wro_control_list&data_services=1</cfoutput>','listTable',1);
	});
    <cfif isDefined("attributes.data_services")>
        $( "#data_services" ).click();
    </cfif>
</script>