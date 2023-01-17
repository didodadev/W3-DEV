<cfif attributes.tabMenuController eq 0>
    <cf_xml_page_edit fuseact="settings.form_add_user_group">
    <cfset userGroup = createObject('component','WBO/model/userGroup')>
    <cfset get_user_groups = userGroup.GET_USER_GROUPS()>
    <cfset get_modules = userGroup.GET_MODULES()>
    <cfparam name="attributes.id" default="">
    <cfif (isdefined("attributes.event") and attributes.event is 'upd') or isdefined("attributes.section")>
        <cfif isdefined("attributes.section")>
            <cfset attributes.id = attributes.section>
        </cfif>
        <cfset get_user_group = userGroup.GET_USER_GROUP(attributes.id)>
        <cfset get_object = userGroup.GET_OBJECT(attributes.id)>

        <cfset get_group_emp_count = userGroup.GET_GROUP_EMP_COUNT(attributes.id)>
        
        <cfif not isdefined("attributes.nListObject")>
            <cfset attributes.nListObject = ''>
            <cfset attributes.nAddObject = ''>
            <cfset attributes.nUpdObject = ''>
            <cfset attributes.nDelObject = ''>
            <cfset attributes.object_info = ''>

            
            <cfoutput query="GET_OBJECT">
                <cfset GET_OBJECTS_INFO = userGroup.GET_OBJECTS_INFO(GET_OBJECT.OBJECT_NAME)>
                <cfset object_info = GET_OBJECTS_INFO.WRK_OBJECTS_ID>
                <cfif LIST_OBJECT eq 1>
                    <cfset attributes.nListObject = listappend(attributes.nListObject,object_info,',')&'_'&MODULE_NO>
                </cfif>
                <cfif ADD_OBJECT eq 1>
                    <cfset attributes.nAddObject = listappend(attributes.nAddObject,object_info,',')&'_'&MODULE_NO>
                </cfif>
                <cfif UPDATE_OBJECT eq 1>
                    <cfset attributes.nUpdObject = listappend(attributes.nUpdObject,object_info,',')&'_'&MODULE_NO>
                </cfif>
                <cfif DELETE_OBJECT eq 1>
                    <cfset attributes.nDelObject = listappend(attributes.nDelObject,object_info,',')&'_'&MODULE_NO>
                </cfif>
            </cfoutput>
        </cfif>
    <cfelseif isdefined("attributes.event") and attributes.event is 'userList'>
        <cfif isdefined("attributes.empId") and len(attributes.empId)>
            <cfset GET_USER_GROUP_MEMBER = userGroup.GET_USER_GROUP_MEMBER(attributes.empId)>
        </cfif>
    </cfif>
    
    <script type="text/javascript">
        <cfif (isdefined("attributes.event") and attributes.event is 'add') or not isdefined("attributes.event")>
            $(document).ready(function () {
                $(".portBox").find(".fa-angle-down").click(function(){	
                    $(this).parent().next("ul").slideToggle(100);	
                });
                $('.allModules').click(function () {
                    $('.data').prop('checked', this.checked);
                });
                $('.allModules').change(function () {
                    var check = ($('.data').filter(":checked").length == $('.data').length);
                    $('.data').prop("checked", check);
                });
                $('.extraModules').click(function () {
                    $('.extraData').prop('checked', this.checked);
                });
                $('.extraModules').change(function () {
                    var check = ($('.extraData').filter(":checked").length == $('.extraData').length);
                    $('.extraData').prop("checked", check);
                });
            });
        <cfelse>
            $(function(){
            $(".portBox").find(".fa-angle-down").click(function(){	
                $(this).parent().next("ul").slideToggle(100);
                
                });
            });//ready
            
            function openModalUGroup(userGroupId)
            {
                  var url = '<cfoutput>#request.self#?fuseaction=objects.members&user_group_id=</cfoutput>'+userGroupId+'&ajax_box_page=1&spa=1';
                  var myModel = $('#uGroupModal');
                  var myModelBody = myModel.find('div.modal-body');
                  var myModelTitle = myModel.find('div.modal-header > .modal-title');
                  
                    myModel.slideToggle(200);
                    $('.modal-backdrop').fadeIn('fast');
                    
                    $.get( url, function( data ) {
                            
                        myModelBody.empty();
                        myModelTitle.empty();
                        
                        myModelBody.append( data );
                    }); // get 
            }
            var modulid = '';
            function openPopup(module,modulName){ 
                var FamilyId;
                if($('input[name=level_id_'+module+']').is(':checked')) FamilyId = 1;
                else FamilyId = 0;
                if($("#modul"+module).css('display') == 'none')
                    $("#modul"+module).css('display','block');
                else
                    $("#modul"+module).css('display','none');
					modulid = "modul" + module;  
                     $('#'+modulid+'').html('<div id="divPageLoad"><?xml version="1.0" encoding="utf-8"?><svg width="32px" height="32px" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="xMidYMid" class="uil-ring-alt"><rect x="0" y="0" width="100" height="100" fill="none" class="bk"></rect><circle cx="50" cy="50" r="40" stroke="rgba(255,255,255,0)" fill="none" stroke-width="10" stroke-linecap="round"></circle><circle cx="50" cy="50" r="40" stroke="#ff8a00" fill="none" stroke-width="6" stroke-linecap="round"><animate attributeName="stroke-dashoffset" dur="2s" repeatCount="indefinite" from="0" to="502"></animate><animate attributeName="stroke-dasharray" dur="2s" repeatCount="indefinite" values="150.6 100.4;1 250;150.6 100.4"></animate></circle></svg></div>');
					 $.ajax({
                        type: "POST",
                        url: '<cfoutput>#request.self#?fuseaction=settings.popup_modul_permission&modul_no=</cfoutput>'+module+'&ajax_box_page=1&isAjax=1&FamilyId='+FamilyId,
                        data: $("form[name=add_user_group]").serialize(),
                        success: function(response){
                            $('#modul'+module).html(response);
                            $('#'+modulid+' div#divPageLoad').css('display','none');
                        }
                      });
                // ajaxpageload parametreleri get yöntemiyle gönderdiğinde çok uzun urller oluşuyor ve sayfalar hataya düşüyor,
                // bu yüzden veriler post yöntemiyle gönderilebilmek için ajaxpageload kapatıldı, yerine standart ajax yazıldı.   
                //AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.popup_modul_permission&modul_no=</cfoutput>'+module+'&ajax_box_page=1&nListObject='+$('#nListObject').val()//+'&nAddObject='+$('#nAddObject').val()+'&nUpdObject='+$('#nUpdObject').val()+'&nDelObject='+$('#nDelObject').val(),'modul'+module);
                 
                } // openPopup

                function closeModal ( el) {
                    $('#'+ el +'.modal').slideToggle(200);
                    $('#'+ el +'.modal-backdrop').fadeOut('fast');
                
                }//closeModal
                
            $(document).ready(function () {
                $('.allModules').click(function () {
                    $('.data').prop('checked', this.checked);
                });
                $('.allModules').change(function () {
                    var check = ($('.data').filter(":checked").length == $('.data').length);
                    $('.data').prop("checked", check);
                });
                $('.extraModules').click(function () {
                    $('.extraData').prop('checked', this.checked);
                });
                $('.extraModules').change(function () {
                    var check = ($('.extraData').filter(":checked").length == $('.extraData').length);
                    $('.extraData').prop("checked", check);
                });
            });
            function checkAreas(modul_no,type)
            {
                if($("input[name=level_id_"+modul_no+"]").is(':checked')) {
                    $("#modul"+modul_no+" input[type=checkbox]").attr('disabled',false);
                }
                else
                {
                    $("#modul"+modul_no+" input[type=checkbox]").attr({
                                                                        disabled:true,
                                                                        checked:false
                                                                    });

                }

                listObject = $('#nListObject').val();
                addObject = $('#nAddObject').val();
                updObject = $('#nUpdObject').val();
                delObject = $('#nDelObject').val();
                $("#modul"+modul_no).find(".list").each(function(index,element){
                    elementName = $(element).attr('name').replace('list_','');
                    if($(element).filter(":checked").length)
                    {
                            if(!list_find(listObject,elementName))
                            {
                                if(!listObject.length)
                                    listObject = elementName;
                                else
                                    listObject = listObject + ',' + elementName;
                            }
                    }
                    else
                    {
                        sira = list_find(listObject,elementName);
                        if(sira > 1)
                            listObject = listObject.replace(','+elementName,'');
                        else if(sira == 1)
                            listObject = listObject.replace(elementName,'');
                        
                    }
                })
                $("#modul"+modul_no).find(".add").each(function(index,element){
                    elementName = $(element).attr('name').replace('add_','');
                    if($(element).filter(":checked").length)
                    {
                        if(!list_find(addObject,elementName))
                        {
                            if(!addObject.length)
                                addObject = elementName; 
                            else
                                addObject = addObject + ',' + elementName; 
                        }
                    }
                    else
                    {
                        sira = list_find(addObject,elementName);
                        if(sira > 1)
                            addObject = addObject.replace(','+elementName,'');
                        else if(sira == 1)
                            addObject = addObject.replace(elementName,'');
                        
                    }
                })
                $("#modul"+modul_no).find(".upd").each(function(index,element){
                    elementName = $(element).attr('name').replace('upd_','');
                    if($(element).filter(":checked").length)
                    {
                        if(!list_find(updObject,elementName))
                        {
                            if(!updObject.length)
                                updObject = elementName; 
                            else
                                updObject = updObject + ',' + elementName; 
                        }
                    }
                    else
                    {
                        sira = list_find(updObject,elementName);
                        if(sira > 1)
                            updObject = updObject.replace(','+elementName,'');
                        else if(sira == 1)
                            updObject = updObject.replace(elementName,'');
                        
                    }
                })
                $("#modul"+modul_no).find(".del").each(function(index,element){
                    elementName = $(element).attr('name').replace('del_','');
                    if($(element).filter(":checked").length)
                    {
                        if(!list_find(delObject,elementName))
                        {
                            if(!delObject.length)
                                delObject = elementName; 
                            else
                                delObject = delObject + ',' + elementName; 
                        }
                    }
                    else
                    {
                        sira = list_find(delObject,elementName);
                        if(sira > 1)
                            delObject = delObject.replace(','+elementName,'');
                        else if(sira == 1)
                            delObject = delObject.replace(elementName,'');
                        
                    }
                })
                $("#nListObject").val(listObject);
                $("#nAddObject").val(addObject);
                $("#nUpdObject").val(updObject);
                $("#nDelObject").val(delObject);
                //closeModal('uGroupModal');
                //add_user_group.submit();
            }
        </cfif>
    
        function kontrolUserGroup()
        {
            if(!$("#user_group_name").val().length)
            {
                alert('<cfoutput>#getLang("settings",119)#</cfoutput>');
                return false;	
            }
            return true;
        }
		
		function activeClass(obj){
			$(obj).parent('li.user').parent('ul').find('li.selected').removeClass('selected');
			$(obj).parent('li.user').addClass('selected');
		}
        
        function kontrolUserGroupList(obj)
        {
            <cfoutput>
                spaPageLoad('#request.self#?fuseaction=settings.form_add_user_group&spa=1&event=userList&empId='+$(obj).closest('form').find('input##empId').val()+'&empName='+$(obj).closest('form').find('input##empName').val(),'userGroup','#attributes.fuseaction#','upd',1,1)
            </cfoutput>
            return false;
        }
        
    </script>
    <cfif isdefined("attributes.section")>
        <script type="text/javascript">
            spaPageLoad('<cfoutput>#request.self#?fuseaction=settings.form_add_user_group&spa=1&event=upd&ID=#attributes.section#</cfoutput>','userGroup','#attributes.fuseaction#','upd',1,1);
        </script>
    </cfif>
</cfif>
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.form_add_user_group';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = '/WBO/view/add_user_group.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = '/WBO/include/add_user_group.cfm';
		WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.form_add_user_group';
		
		WOStruct['#attributes.fuseaction#']['upd'] = structNew();
		WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.form_add_user_group';
		WOStruct['#attributes.fuseaction#']['upd']['filePath'] = '/WBO/view/upd_user_group.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = '/WBO/include/upd_user_group.cfm';
		WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.form_add_user_group';
		WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'section=#attributes.id#';
		WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '#attributes.id#';
		
		WOStruct['#attributes.fuseaction#']['userList'] = structNew();
		WOStruct['#attributes.fuseaction#']['userList']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['userList']['fuseaction'] = 'settings.form_add_user_group';
		WOStruct['#attributes.fuseaction#']['userList']['filePath'] = '/WBO/view/members.cfm';
		WOStruct['#attributes.fuseaction#']['userList']['queryPath'] = '/WBO/include/listUserGroupMember.cfm';
		WOStruct['#attributes.fuseaction#']['userList']['nextEvent'] = 'settings.form_add_user_group';
		WOStruct['#attributes.fuseaction#']['userList']['parameters'] = 'section=#attributes.id#';
		WOStruct['#attributes.fuseaction#']['userList']['Identity'] = '#attributes.id#';
		
		if(not attributes.event is 'add')
		{
			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'settings.form_add_user_group&event=del&user_group_id=#attributes.id#';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = '/WBO/include/del_user_group.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = '/WBO/include/del_user_group.cfm';
			WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.form_add_user_group';
		}
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.form_add_user_group';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/WBO/view/list_user_group.cfm';
	}
	else
	{
		// Tab Menus //
		tabMenuStruct = StructNew();
		tabMenuStruct['#attributes.fuseaction#'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
		// Upd //
		if(isdefined("attributes.event") and attributes.event is 'add')
		{
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = 'Kullanıcılar';
			tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "spaPageLoad('#request.self#?fuseaction=settings.form_add_user_group&event=add&spa=1&newRecord=1','userGroup','#attributes.fuseaction#','upd',1,1)";
            
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-users']['text'] = 'Kullanıcılar';
            tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['fa fa-users']['onClick'] = "spaPageLoad('#request.self#?fuseaction=objects.members&spa=1&event=upd&user_group_id=#attributes.id#','userGroup','#attributes.fuseaction#','upd',1,1)";

            tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);

        }
   
	}
</cfscript>
