<link rel="stylesheet" href="/css/assets/template/w3-intranet/intranet.css" type="text/css">

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.help_fuseaction" default="">
<cfparam name="attributes.answer" default="0">
<cfparam name="attributes.news" default="0">
<cfparam name="attributes.page" default=1>
<cfif isDefined('session.ep.maxrows')>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfelseif isDefined('session.pp.maxrows')>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_submitted")>
    <cfset get_tips = createObject('component','WEX.sitetour.components.data').getlists(
        help_fuseaction : attributes.help_fuseaction,
        keyword : attributes.keyword,
        news : attributes.news)>
<cfelse>
    <cfset get_tips.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_tips.recordcount#'>
<div class="wrapper">
    <div id="wiki" class="col col-12 col-md-12 col-sm-12 col-xs-12" >
        <div class="search_group">    
            <cf_box>
                <cfform name="help_worktips" id="help_worktips" action="#request.self#?fuseaction=help.worktips" method="post">               
                    <cf_box_search more="0">
                        <cfoutput>
                            <input type="hidden" id="update_date" name="update_date" value="#now()#">
                            <input type="hidden" id="update_ip" name="update_ip" value="#cgi.remote_addr#">
                            <input type="hidden" id="update_emp" name="update_emp" value="#session.ep.userid#">
                            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                            <div class="form-group title">
                                <cf_get_lang dictionary_id='62428.Worktips'>
                            </div>
                            <div class="form-group">
                                <cfsavecontent  variable="keyword"><cf_get_lang dictionary_id='57701.Filtre'></cfsavecontent>
                                <cfinput type="text" name="keyword" id="keyword" maxlength="100" value="#attributes.keyword#" placeholder="#keyword#">
                            </div>
                            <div class="form-group">
                                <cfsavecontent  variable="fuseact"><cf_get_lang dictionary_id='36185.Fuseaction'></cfsavecontent>
                                <cfinput type="text" name="help_fuseaction" id="help_fuseaction" maxlength="100" value="#attributes.help_fuseaction#" placeholder="#fuseact#">
                            </div>
                          <!---   <div class="form-group">
                                <select id="module" name="module">
                                    <option value=""><cf_get_lang dictionary_id='55452.Module'></option>                              
                                </select>
                            </div> --->
                            
                            <div class="form-group">
                                <select id="answer" name="answer">
                                    <option value="0"><cf_get_lang dictionary_id='57708.Tümü'></option>
                                    <option value="1" <cfif attributes.answer eq 1>selected</cfif>><cf_get_lang dictionary_id='63100.Cevaplanmış'></option>
                                    <option value="2" <cfif attributes.answer eq 2>selected</cfif>><cf_get_lang dictionary_id='63101.Cevaplanmamış'></option>
                                </select>
                            </div>
                            <div class="form-group">
                                <select id="news" name="news">
                                    <option value="0"><cf_get_lang dictionary_id='57708.Tümü'></option>
                                    <option value="1" <cfif attributes.news eq 1>selected</cfif>><cf_get_lang dictionary_id='61899.Yenilikler'></option>
                                    <option value="2" <cfif attributes.news eq 2>selected</cfif>><cf_get_lang dictionary_id='63099.İpuçları'></option>
                                </select>
                            </div>
                            <div class="form-group small">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="4">
                            </div>
                            <div class="form-group">
                                <cf_wrk_search_button button_type="4">
                            </div>
                            <div class="form-group">
                                <a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.widget_loader&widget_load=addWorktips&is_box=1&box_title=<cf_get_lang dictionary_id='63531.Tips Ekle'>&fuseact=#attributes.fuseaction#</cfoutput>','','ui-draggable-box-small')" class="ui-btn ui-btn-gray"><i class="fa fa-plus"></i></a>
                            </div>
                        </cfoutput>
                    </cf_box_search>                
                </cfform>
            </cf_box>
        </div>
        <cfif get_tips.recordcount>
            <cfoutput query="get_tips" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <div class="forum_item flex-col">
                    <div class="reply_item">
                        <p class="name">
                            <a>#HELP_HEAD#</a>
                        </p>
						<cfset help_topic_ = deserializeJSON(HELP_TOPIC)>
                        <p class="text"><a>#help_topic_.options.el_content#</a></p>
                        <p class="text">
                            <a class="bold">
                            <cfif news eq 1>
                                <cf_get_lang dictionary_id='65433.Yenilik'>
                            <cfelse>
                                <cf_get_lang dictionary_id='39620.İpucu'>
                            </cfif>
                            </a>
                        </p>
                        <p class="category">
                            <span>#HELP_FUSEACTION#</span>
                            <a class="read_more" href="javascript://" onclick='openBoxDraggable("#request.self#?fuseaction=objects.widget_loader&widget_load=updWorktips&is_box=1&box_title=Tips Güncelle&worktips_id=#HELP_ID#","","ui-draggable-box-small")'><i class="fa fa-pencil"></i><cf_get_lang dictionary_id='57464.Güncelle'></a>
                        </p>
                    </div>
                </div>                                  
            </cfoutput>
        <cfelse>
            <cfif isDefined('attributes.form_submitted') and attributes.form_submitted eq 1>
                <div class="ui-form-list">
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
                        <div class="training_item">
                            <p class="text"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'> !</p>
                        </div>
                    </div>
                </div>
            </cfif>    
        </cfif>
        <cfif attributes.maxrows lt attributes.totalrecords>
                
            <cfset adres = attributes.fuseaction>
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                <cfset adres = adres&"&keyword=#attributes.keyword#">
            </cfif>
            <cfif isDefined("attributes.help_fuseaction") and len(attributes.help_fuseaction)>
                <cfset adres = adres&"&help_fuseaction=#attributes.help_fuseaction#">
            </cfif>
            <cfif isDefined("attributes.answer") and len(attributes.answer)>
                <cfset adres = adres&"&answer=#attributes.answer#">
            </cfif>
            <cfif isDefined("attributes.news") and len(attributes.news)>
                <cfset adres = adres&"&news=#attributes.news#">
            </cfif>
            <cfif isDefined("attributes.form_submitted") and len(attributes.form_submitted)>
                <cfset adres = adres&"&form_submitted=#attributes.form_submitted#">
            </cfif>
            <cf_box>
            <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#adres#"
                >
        </cfif>    
    </div>
</div>

<script>

function addTip(){
       $('#help_tour_modal_add').show();
    }
    function control(){
        var formObject = {}, el_id = "", el = "", elOffsetX = "", elOffsetY = ""; 
        var el_content = $('#help_tour_modal_add #help_tour_form textarea[name="help_content"]').val();
			
        $.each($('#help_tour_modal_add #help_tour_form').serializeArray(),function(i, v) {
            formObject[v.name] = v.value;
        });
    
        var obj = {"active": true, options : {"left":elOffsetX, "top":elOffsetY, "el_id":el_id, "el_content":el_content, "el_node":el.nodeName}};
        formObject.help_topic = JSON.stringify(obj);

        formObject.is_news = 0;
        if ($('#help_tour_form #is_news').is(':checked')) {formObject.is_news = 1;}
        $.ajax({
            url :'/wex.cfm/tour/insert',
            method: 'post',
            contentType: 'application/json; charset=utf-8',
            dataType: "json",
            data : JSON.stringify(formObject),
            error :  function(response){
                if(trim(response.responseText) === "Ok"){
                    alert("Yardım Notu Eklendi. Yönlendiriliyorsunuz..");
                    location.reload();
                }
                else{
                    alert("Bir hata oluştu!");
                    location.reload();
                }
            }
        });
    }
</script>