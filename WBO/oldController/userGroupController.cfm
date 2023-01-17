<cf_xml_page_edit fuseact="settings.form_add_user_group">
<cfinclude template="../settings/query/get_user_groups.cfm">
<cfinclude template="../settings/query/get_modules.cfm">
<cfif (isdefined("attributes.event") and attributes.event is 'upd') or isdefined("attributes.section")>
	<cfif isdefined("attributes.section")>
    	<cfset attributes.id = attributes.section>
    </cfif>
    <cfinclude template="../settings/query/get_user_group.cfm">
    <cfinclude template="../settings/query/get_group_emp_count.cfm">
    
	<cfset attributes.nListObject = ''>
    <cfset attributes.nAddObject = ''>
    <cfset attributes.nUpdObject = ''>
    <cfset attributes.nDelObject = ''>
    <cfoutput query="GET_OBJECT">
        <cfif LIST_OBJECT eq 1>
            <cfset attributes.nListObject = listappend(attributes.nListObject,OBJECT_NAME,',')>
        </cfif>
        <cfif ADD_OBJECT eq 1>
            <cfset attributes.nAddObject = listappend(attributes.nAddObject,OBJECT_NAME,',')>
        </cfif>
        <cfif UPDATE_OBJECT eq 1>
            <cfset attributes.nUpdObject = listappend(attributes.nUpdObject,OBJECT_NAME,',')>
        </cfif>
        <cfif DELETE_OBJECT eq 1>
            <cfset attributes.nDelObject = listappend(attributes.nDelObject,OBJECT_NAME,',')>
        </cfif>
    </cfoutput>
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
		
		function openPopup(module,modulName){ 
			if($("#modul"+module).css('display') == 'none')
				$("#modul"+module).css('display','block');
			else
				$("#modul"+module).css('display','none');
				
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.popup_modul_permission&modul_no=</cfoutput>'+module+'&ajax_box_page=1&nListObject='+$('#nListObject').val()+'&nAddObject='+$('#nAddObject').val()+'&nUpdObject='+$('#nUpdObject').val()+'&nDelObject='+$('#nDelObject').val(),'modul'+module);
			 
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


	function kontrol()
	{
		if(!$("#user_group_name").val().length)
		{
			alert('<cfoutput>#lang_array_all.item[42102]#</cfoutput>');
			return false;	
		}
		return true;
	}
</script>
<cfif isdefined("attributes.section")>
	<script type="text/javascript">
		spaPageLoad('<cfoutput>#request.self#?fuseaction=settings.form_add_user_group&spa=1&event=upd&ID=#attributes.section#</cfoutput>','userGroup','#attributes.fuseaction#','upd',1,1);
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.form_add_user_group';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'settings/form/add_user_group.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'settings/query/add_user_group.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.form_add_user_group';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'settings.form_add_user_group';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'settings/form/upd_user_group.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'settings/query/upd_user_group.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'settings.form_add_user_group';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'section=##attributes.id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.id##';
	
	if(not attributes.event is 'add')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'settings.form_add_user_group&event=del&user_group_id=#url.id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'settings/query/del_user_group.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'settings/query/del_user_group.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'settings.form_add_user_group';
	}
	
	WOStruct['#attributes.fuseaction#']['det'] = structNew();
	WOStruct['#attributes.fuseaction#']['det']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['det']['fuseaction'] = 'settings.form_add_user_group';
	WOStruct['#attributes.fuseaction#']['det']['filePath'] = 'settings/form/upd_user_group.cfm';
	WOStruct['#attributes.fuseaction#']['det']['queryPath'] = 'settings/query/upd_user_group.cfm';
	WOStruct['#attributes.fuseaction#']['det']['nextEvent'] = 'settings.form_add_user_group';
	WOStruct['#attributes.fuseaction#']['det']['parameters'] = 'user_group_id=##attributes.user_group_id##';
	WOStruct['#attributes.fuseaction#']['det']['Identity'] = '##attributes.user_group_id##';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'settings.form_add_user_group';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'settings/form/add_user_group.cfm';
	
	// Tab Menus //
	tabMenuStruct = StructNew();
	tabMenuStruct['#attributes.fuseaction#'] = structNew();
	tabMenuStruct['#attributes.fuseaction#']['tabMenus'] = structNew();
	// Upd //
	/*
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = 'Geri';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['onClick'] = "alert(1)";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = 'Kullanıcılar';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "spaPageLoad('#request.self#?fuseaction=settings.form_add_user_group&spa=1&event=det&user_group_id=##attributes.user_group_ID##','userGroup','#attributes.fuseaction#','upd',1,1)";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	*/
</cfscript>
