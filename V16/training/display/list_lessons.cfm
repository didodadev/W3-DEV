<cfset intranet = createObject('component','cfc.intranet')>
<cfset trainingSec = intranet.trainingSec()>
<cfset trainingClass = intranet.trainingClass(top:6)>
<cfset trainingAgenda = intranet.trainingClass(top:3)>
<cfset trainingAnounce = intranet.trainingAnounce()>
<cfparam name="attributes.keyword" default="">
<cfset cfc = createObject('component','V16.training_management.cfc.training_groups')>
<cfset get_training_groups = cfc.get_training_groups()>
<cfset get_training_group_subjects_all = cfc.get_training_group_subjects_all()>
<cfset get_departments = cfc.get_departments()>
<style>
    .pageMainLayout{padding:0;}
</style>
<!--- <link rel="stylesheet" href="/css/assets/template/intranet/intranetSa.css" type="text/css"> --->
<cfinclude template="../../rules/display/rule_menu.cfm">
<div class="wrapper" style="margin-top:-5px;">
    <div class="col col-12">
	    <cfinclude template="general_training_menu.cfm">
    </div>
</div>

<div class="wrapper">
    <div id="wiki" class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <div class="search_group">    
            <cf_box>
                <cfform name="subject_search" id="subject_search" action="#request.self#?fuseaction=training.lesson" method="post">
                    <input type="hidden" name="form_submitted" id="form_submitted" value="1" />   
                    
                    <cf_box_search more="0">
                        <div class="form-group title_clever">
                            <cf_get_lang dictionary_id='58063.Dersler'>
                        </div>
                        <!--- <div class="form-group xlarge">
                            <select name="train_departments" id="train_departments">
                                <option value="0"><cf_get_lang dictionary_id='57453.Şube'> / <cf_get_lang dictionary_id='35449.Departman'></option>
                                <cfoutput query="get_departments" group="branch_id"><cfoutput>
                                    <option value="#department_id#" <cfif isdefined("attributes.train_departments") and attributes.train_departments eq department_id>selected</cfif>>#BRANCH_NAME# / #department_head#</option>
                                </cfoutput></cfoutput>
                            </select>
                        </div> --->
                        <div class="form-group medium">
                            <select name="train_group_id" id="train_group_id">
                                <option value="0"><cf_get_lang dictionary_id='32326.Sınıf'></option>
                                <cfoutput query="get_training_groups">
                                    <option value="#train_group_id#" <cfif isdefined("attributes.train_group_id") and (attributes.train_group_id eq train_group_id)>selected</cfif>>#group_head#</option>
                                </cfoutput>
                            </select>
                        </div>
                        <div class="form-group">
                            <select name="train_id" id="train_id">
                                <option value="0"><cf_get_lang dictionary_id='46049.Müfredat'></option>
                                <cfoutput query="get_training_group_subjects_all">
                                    <option value="#train_id#" <cfif isdefined("attributes.train_id") and (attributes.train_id eq train_id)>selected</cfif>>#train_head#</option>
                                </cfoutput>
                            </select>
                        </div>
                        <div class="form-group">
                            <cf_wrk_search_button button_type="4">
                        </div>
                    </cf_box_search>
                </cfform>
            </cf_box>
        </div>

        <cfif get_training_groups.recordcount>
            <cfinclude  template="list_class_agenda.cfm">
        <cfelse>
            <cf_box>
                <p class="text"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'> !</cfif></p>
            </cf_box>
        </cfif>
    </div>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>