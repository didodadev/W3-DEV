<cfset groups = createObject("component","V16.training_management.cfc.training_groups")>

<script src="/JS/assets/plugins/masonry.pkgd.min.js"></script>
<style>
    .pageMainLayout{padding:0;}    
    .clever .portBoxBodyStandart{padding:20px 20px;}
    .clever tr {border-bottom: none}
    .joinLink {padding: 5px;}
    .joinLink:hover {background-color: #44b6ae;}
</style>

<cfinclude template="../../rules/display/rule_menu.cfm">
<div class="wrapper" style="margin-top:-5px;">
    <div class="col col-12">
	    <cfinclude template="general_training_menu.cfm">
    </div>
</div>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
    <cfparam name="attributes.keyword" default="#attributes.keyword#">
<cfelse>
    <cfparam name="attributes.keyword" default="">
</cfif>
<cfif isDefined("attributes.status") and len(attributes.status)>
    <cfparam name="attributes.status" default="#attributes.status#">
<cfelse>
    <cfparam name="attributes.status" default="1">
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset training_groups ="#groups.get_training_groups(keyword: attributes.keyword, status: attributes.status)#">
<cfparam name="attributes.totalrecords" default='#training_groups.recordcount#'>
<div class="wrapper">
    <div id="wiki" class="col col-12 col-md-12 col-sm-12 col-xs-12">
         <div class="search_group">    
            <cf_box>
                <cfform name="subject_search" id="subject_search" action="#request.self#?fuseaction=training.list_training_groups" method="post">
                    <input type="hidden" name="form_submitted" id="form_submitted" value="1" />   
                    
                    <cf_box_search more="0">
                        <div class="form-group title_clever">
                            <cf_get_lang dictionary_id='58049.Sınıflar'>
                        </div>
                        <div class="form-group" id="item-keyword">
                            <cfinput type="text" name="keyword" id="keyword" placeHolder="#getlang(48,'Filtre',57460)#" value="#attributes.keyword#" maxlength="50">
                        </div>
                        <div class="form-group">
                            <select name="status" id="status">
                                <option VALUE="1" <cfif isdefined("attributes.status") and attributes.status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option VALUE="0" <cfif isdefined("attributes.status") and attributes.status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                                <option VALUE="" <cfif isdefined("attributes.status") and not len(attributes.status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                            </select>
                        </div>
                        <div class="form-group small">
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" onKeyUp="isNumber(this)">
                        </div>	
                        <div class="form-group">
                            <cf_wrk_search_button button_type="4">
                        </div>
                    </cf_box_search>
                </cfform>
            </cf_box>
        </div>
        
        <cfif training_groups.recordcount>
            <div class="training_groups_cards" style="margin: 0 -5px 0 -5px;">
                <cfoutput query="training_groups" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <cfif statu eq 1>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12 masonry-item">
                            <cf_box class="clever" scroll="0">
                                <div class="protein-table training_items">
                                    <div style="word-wrap: break-word;white-space: normal;">
                                        <cfif FileExists("documents/train_group/#path#")>
                                            <img src="documents/train_group/#path#" style="width:100%" height="150px">
                                        </cfif>
                                        <div class="training_items_head">
                                            <a href="#request.self#?fuseaction=training.list_training_groups&event=upd&train_group_id=#TRAIN_GROUP_ID#">#group_head#</a>
                                        </div>
                                        <div class="training_items_cat">
                                            <cfset training_group_subjects ="#groups.get_training_group_subjects(train_group_id: training_groups.train_group_id)#">
                                            <cfloop query="training_group_subjects">
                                                #train_head#<cfif recordcount gt currentrow> / </cfif>
                                            </cfloop>
                                        </div>
                                        <div class="training_items_bottom">
                                            <div class="training_items_bottom_icon">
                                                <i class="icon-SUBO" style="color:##f8a128"></i>
                                            </div>
                                            <div class="training_items_bottom_num">
                                                #quota#
                                            </div>
                                            <div class="training_items_bottom_rbtn">
                                                <cfset attenders ="#groups.get_training_group_attenders(train_group_id: train_group_id)#">
                                                <cfif attenders.emp_id neq session.ep.userid>
                                                    <a class="joinLink" href="javascript://" onclick="joinClass(#training_groups.train_group_id#)">
                                                        <cf_get_lang dictionary_id='46962.Katıl'>
                                                    </a>
                                                </cfif>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </cf_box>
                        </div>
                    </cfif>
                </cfoutput>
            </div>
            <cfif training_groups.recordcount gt attributes.maxrows>
                <div class="col col-12">
                    <cfset adres = "">
                    <cfset adres = "#adres#&form_submitted=1">
                    <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
                        <cfset adres = "#adres#&keyword=#attributes.keyword#">
                    </cfif>
                    <cfif isdefined("attributes.training_sec_id")>
                        <cfset adres = "#adres#&training_sec_id=#attributes.training_sec_id#">
                    </cfif>
                    <cfif isdefined("attributes.training_cat_id")>
                        <cfset adres = "#adres#&training_cat_id=#attributes.training_cat_id#">
                    </cfif>
                    <cfif isdefined("attributes.status")>
                        <cfset adres = "#adres#&status=#attributes.status#">
                    </cfif>
                    <cf_box>
                        <cf_paging page="#attributes.page#"
                            maxrows="#attributes.maxrows#"
                            totalrecords="#training_groups.recordcount#"
                            startrow="#attributes.startrow#"
                            adres="training.list_training_groups#adres#">
                    </cf_box>
                </div>
            </cfif>
        <cfelse>
            <cf_box>
                <cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif>
            </cf_box>
        </cfif>
        </div>
    </div>
</div>
<script type="text/javascript">
    document.getElementById('keyword').focus();
    $( document ).ready(function() {
        $('.training_groups_cards').masonry({
            // options
            itemSelector: '.masonry-item'
        });
    });

    function joinClass(requestId){
        openBoxDraggable('<cfoutput>#request.self#?fuseaction=training.list_training_groups&event=joinClass&train_group_id=</cfoutput>'+requestId, 'joinClassBox', 'ui-draggable-box-medium');
    }
</script>