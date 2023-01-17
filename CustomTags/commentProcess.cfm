<cfparam name="attributes.action_section" default="">
<cfparam name="attributes.company_id" default="1">
<cfparam name="attributes.period_id" default="">
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.asset_cat_id" default="">
<cfset getNotesComponent = createObject('component','V16.project.cfc.get_work')>
<cfset getNotes = getNotesComponent.getNotes(action_section:attributes.action_section,action_id:attributes.action_id)>
<link rel="stylesheet" href="css/assets/template/w3-comment/comment.css" type="text/css">
<cfset upload_folder=application.systemParam.systemParam().upload_folder>
<div class="slimScrollDiv clearfix" role="article" direction="left">
    <ul class="ltCommentList">
        <cfif getNotes.recordcount>
            <cfoutput query="getNotes">
                <li id="message_#currentrow#">
                    <div class="message">
                        <div>
                            <cfif len(PHOTO) and DirectoryExists("#upload_folder#hr/#photo#")>
                                <img src="#upload_folder#hr/#photo#" class="img-circle pull-left" alt="">
                            <cfelse>
                                <span class="avatextCt color-#Left(EMPLOYEE_NAME, 1)#"><small class="avatext" >#Left(EMPLOYEE_NAME, 1)##Left(EMPLOYEE_SURNAME, 1)#</small></span>
                            </cfif>
                        </div>
                        <div class="message float-left">                           
                            <a href="javascript://" onclick="nModal({head: 'Profil',page:'index.cfm?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#'});" class="name"><cfif len(EMPLOYEE)>#EMPLOYEE#<cfelse>#COMPANY_PARTNER#</cfif></a>
                            <span class="message_content ">#BODY#</span>
                            <small class="datetime"> #TimeFormat(caller.date_add('h',session.ep.time_zone,record_date),'HH:MM')# - #Dateformat(record_date,'dd/mm/yyyy')#</small><span aria-hidden="true">  </span>
                            <span class="bodyChatButton">
                                <a onclick="$(this).parent('span').parent('div').find('div.chat-form').toggle();$(this).parent('span').parent('div').find('div.chat-form input.messageField').focus()"><i class="fa fa-comment"></i>#caller.getLang('objects2',178,'Yanıtla')#</a>
                            </span>
                            <form name="saveNote">
                                <div class="chat-form" style="display:none;">
                                    <div class="ui-form-list ui-form-block">
                                        <div class="form-group">
                                            <div class="input-group searchInput col-md-12">
                                                <input type="hidden" name="rowNumber" value="#currentrow#">
                                                <input type="hidden" class="noteId" name="actionId" value="#NOTE_ID#">
                                                <input type="text" class="form-control messageField search-input" name="noteBody" placeholder="<cf_get_lang dictionary_id='54375.Mesajınızı yazınız....'>">
                                                <span class="input-group-addon input-group-addon-btn">
                                                    <button type="submit" class="btn fa fa-paper-plane"></button>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </form> 
                            </div> 
                        </div>
                        <div id="bodyAnswer#currentrow#" class="bodyAnswers">
                            <cfset getNotesComment = getNotesComponent.getNotes(action_section:'WORK_ID',action_id:NOTE_ID)>
                            <ul class="chatsAnwars">
                                <cfloop query="getNotesComment">
                                    <li class="anwars" id="bodyAnswer#currentrow#">
                                        <cfif getNotesComment.recordcount>
                                            <div>
                                                <cfif len(PHOTO) and DirectoryExists("#upload_folder#hr/#photo#")>
                                                    <img src="#upload_folder#hr/#photo#" class="img-circle pull-left" alt="">
                                                <cfelse>
                                                    <span class="avatextCt color-#Left(EMPLOYEE_NAME, 1)#"><small class="avatext" >#Left(EMPLOYEE_NAME, 1)##Left(EMPLOYEE_SURNAME, 1)#</small></span>
                                                </cfif>
                                            </div>
                                            <div class="message float-right" style="">
                                                <a href="javascript://" onclick="nModal({head: 'Profil',page:'index.cfm?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#'});" class="name"><cfif len(EMPLOYEE)>#EMPLOYEE#<cfelse>#COMPANY_PARTNER#</cfif></a>
                                                <span class="message_content">#BODY#</span>	
                                                <small class="datetime"> #TimeFormat(caller.date_add('h',session.ep.time_zone,record_date),'HH:MM')# - #Dateformat(record_date,'dd/mm/yyyy')#</small>
                                            </div>
                                        </cfif>
                                    </li>
                                </cfloop>
                            </ul>                               
                        </div>                     
                    </div>
                </li>
            </cfoutput>
        </cfif>
    </ul>     
</div>
<cfoutput>
	<form name="saveNote">
        <div class="ui-form-list ui-form-block">
            <div class="form-group">
                <div class="input-group searchInput col-md-12">
                    <input type="hidden" name="rowNumber" value="">
                    <input type="hidden" class="noteId" name="actionId" value="#attributes.action_id#">
                    <input type="text" class="form-control messageField search-input" id="noteBody" name="noteBody" placeholder="<cf_get_lang dictionary_id='54375.Mesajınızı yazınız....'>">
                    <span class="input-group-addon input-group-addon-btn">
                        <button type="submit" class="btn fa fa-paper-plane"></button>
                    </span>
                </div>
            </div>
        </div>
    </form>
</cfoutput>
<li class="out" id="base" style="display:none;">
    <div class="message">
        <div id="bodyAnswer" class="bodyAnswers">
            <div>
                <cfif len(getNotes.PHOTO) and DirectoryExists("#upload_folder#hr/#getNotes.photo#")>
                    <img src="" class="img-circle pull-left" alt="">
                <cfelse>
                    <cfoutput><span class="avatextCt color-#Left(session.ep.name, 1)#">
                        <small class="avatext" >#Left(session.ep.name, 1)##Left(session.ep.surname, 1)#</small></span></cfoutput>
                </cfif>
            </div>
            <div class="message float-right">
                <a class="name"></a>
                <span class="message_content"></span>
                <small class="datetime"></small>
            </div>
        </div>
    </div>    
</li>
<li class="out main" id="mainBase" style="display:none;">
    <div class="message">
        <div>
            <cfif len(getNotes.PHOTO) and DirectoryExists("#upload_folder#hr/#getNotes.photo#")>
                <img src="" class="img-circle pull-left" style="padding-right:5px;margin: 10px;" alt="" width="40">
            <cfelse>
                <cfoutput><span class="pull-left avatextCt color-#Left(session.ep.name, 1)#"><small class="avatext" >#Left(session.ep.name, 1)##Left(session.ep.surname, 1)#</small></span></cfoutput>
            </cfif>   
        </div>
        <div class="message float-left">
            <a class="name"></a>
            <span class="message_content"></span>
            <small class="datetime"></small>
            <span class="bodyChatButton">
                <a onclick="$(this).parent('span').parent('div').find('div.chat-form').toggle();$(this).parent('span').parent('div').find('div.chat-form input.messageField').focus()"><i class="fa fa-comment"></i><cfoutput>#caller.getLang('objects2',178,'Yanıtla')#</cfoutput></a>
            </span>
            <form name="saveNote">
                <div class="chat-form" style="display:none;">
                    <div class="input-group searchInput col-md-12">
                        <input type="hidden" name="rowNumber" value="<cfoutput>#getNotes.currentrow#</cfoutput>">
                        <input type="hidden" class="noteId" name="actionId" value="#NOTE_ID#">
                        <input type="text" class="form-control messageField search-input" name="noteBody" placeholder="<cf_get_lang dictionary_id='54375.Mesajınızı yazınız....'>">
                        <span class="input-group-addon input-group-addon-btn bg-white" style="background:##dddddd;">
                            <button type="submit" class="btn fa fa-paper-plane px-2"></button>
                        </span>
                    </div>
                </div>
            </form>
        </div>
            <div class="<cfoutput>bodyAnswer#getNotes.currentrow#</cfoutput>">
               <ul class="chatsAnwars"></ul>
            </div>
        </div>
</li>
<script type="text/javascript">
var rowCounter = <cfoutput>#getNotes.recordcount#</cfoutput>;
$("form[name = saveNote]").submit(function() {
    
    var rowNumber = $.trim($(this).find("input[name = rowNumber]").val());
    var propertyId = $("#property_id").val();
    var assetDescription = $("#asset_description").val();
    var assetDetail = $("#asset_detail").val();

    if(rowNumber) noteHead = 'comment';
    else{  
        rowCounter++;
        noteHead = 'comment';
    }

    var form = $(this).serialize() + "&actionSection=WORK_ID&noteHead=" + noteHead;

    $.ajax({
        url :'V16/project/cfc/get_work.cfc?method=SAVENOTES', 
        data :form,
        async:false, 
        dataType: 'json', 
        success : function(res){
            if (res.STATUS) {
                if(rowNumber != "") var temp = $("li#base").clone();
                else var temp = $("li#mainBase").clone();
                $("#noteBody").val("");
                $(temp).find('img.img-circle').attr("src",res.DATA.PHOTO);
                $(temp).find('a.name').html("<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>").attr("onClick","nModal({head: 'Profil',page:'index.cfm?fuseaction=objects.popup_emp_det&emp_id=<cfoutput>#session.ep.userid#</cfoutput>'});");
                $(temp).find('span.message_content').html(res.DATA.BODY);
                $(temp).find('small.datetime').html(res.DATA.RECORD_DATE);
                $(temp).find('input.noteId').val(res.DATA.NOTE_ID);
                $(temp).removeAttr('class');
                $(temp).removeAttr('style');
                $(temp).removeAttr('id');
                if(rowNumber != "") $("ul.ltCommentList li#message_"+rowNumber+" div.bodyAnswers ul.chatsAnwars").append($(temp));
                else{
                    $(temp).find('button.btn-info').attr('onclick','saveNote(this,'+rowCounter+')');
                    $(temp).attr("id","message_"+rowCounter);
                    $("ul.ltCommentList").append($(temp));
                } 
            }
            else
                alert("Bir sorundan dolayı yorumunuz eklenmedi !");

        }
    });
    return false;
});
</script>