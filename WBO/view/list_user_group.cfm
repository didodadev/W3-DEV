<div class="col col-12 col-xs-12">
    <cf_catalystHeader>
    <div class="imp-tool">
        <div class="page-wrapper">
            <main class="page-content">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <cfsavecontent variable = "box_title">
                        <cf_get_lang no='161.Yetki Grupları'>
                    </cfsavecontent>
                    <cf_box title="#box_title#" closable="0" collapsed="0" add_href="javascript:addWO()">
                        <cfoutput query="get_user_groups">            
                            <ul class="ui-list">
                                <li class="list-group-item" id="headQuerter#user_group_ID#">
                                    <a href="javascript://">
                                        <div class="ui-list-left">
                                            <span class="ui-list-icon ctl-network-1" title="#getLang('main',1734,'Şirketler')#"></span>
                                            #user_group_name# - #USER_COUNT#
                                        </div>
                                        <div class="ui-list-right">
                                            <i class="fa fa-pencil"  onclick="updWO(#user_group_ID#)" title="#getLang(dictionary_id : 42293)#")></i>
                                            <i class="fa fa-history"  onclick="historyWO(#user_group_ID#)" title="#getLang('main',52,'Güncelle')#")></i>
                                        </div>
                                        
                                    </a>
                                </li>
                            </ul>
                        </cfoutput> 
                    </cf_box>
                </div>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div id="ajax_right">
                    </div>           
                </div>
            </main>
        </div>
    </div>
</div>
<script  type="text/javascript">
    function addWO() {
            AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_user_group&event=add','ajax_right');  
    }   
    function updWO(id) {
        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_user_group&event=upd&ID='+id,'ajax_right');  
    }   
    function historyWO(id) {
        AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.history_user_group&user_group_id='+id,'ajax_right');  
    } 
</script>
    