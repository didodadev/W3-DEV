<cfparam name="attributes.extraQuery" default="">
<cfset extraQuery = attributes.extraQuery>
<cfset attributes = caller.attributes>
<cfset attributes.extraQuery = extraQuery>
<cfset attributes.tabMenuController = 1>
<cfinclude template="../#application.objects['#caller.attributes.fuseaction#']['CONTROLLER_FILE_PATH']#">
<cfset popupControl = "">
<cfif caller.windowProp is 'popup' OR attributes.fuseaction contains 'popup'><cfset popupControl = "headerIsPopup"></cfif>

<cfoutput>
	<cfif not (isdefined("caller.attributes.spa") and caller.attributes.spa eq 1)>
        <div>		
            <cfif isdefined("caller.attributes.event") and isdefined("caller.tabMenuData") and StructKeyExists(caller.tabMenuStruct['#caller.attributes.fuseaction#']['tabMenus'],'#caller.attributes.event#')>
                <div id="pageHeader" class="col col-12 text-left pageHeader font-green-haze #popupControl#" >
                    <cfif StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#']['#caller.attributes.event#'],'js')>
                        <span class="pageCaption font-green-sharp bold" style="cursor:pointer" onclick="#WOStruct['#caller.attributes.fuseaction#']['#caller.attributes.event#']['js']#">#caller.pageHead#</span>
                    <cfelse>
                        <span class="pageCaption font-green-sharp bold">#caller.pageHead#</span>
                    </cfif>
                    <div id="pageTab" class="pull-right">
                        <nav class="detailHeadButton" id="tabMenu"></nav>
                    </div>
            <cfelseif len(caller.pageHead)>
                <div id="pageHeader" class="col col-12 text-left pageHeader font-green-haze #popupControl#">
                    <cfif StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#']['#caller.attributes.event#'],'js')>
                        <span class="pageCaption font-green-sharp bold" style="cursor:pointer" onclick="#caller.WOStruct['#caller.attributes.fuseaction#']['#caller.attributes.event#']['js']#">#caller.pageHead#</span>
                    <cfelse>
                        <span class="pageCaption font-green-sharp bold">#caller.pageHead#</span>
                    </cfif>
                    <div id="pageTab" class="pull-right">
                        <nav class="detailHeadButton" id="tabMenu"></nav>
                    </div>
                </div>
            </cfif>
        </div>
    </cfif>
</cfoutput>

<cfif isdefined("transformations")>
	<cfif StructKeyExists(transformations['#attributes.fuseaction#']["#attributes.event#"]['icons'],'customTag')>
		<cfoutput>
            <cfset tabMenuDivName = 'tabMenu#CreateUUID()#'>
            <cfset fileName = '#tabMenuDivName#.cfm'>
            <cffile action="write" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#" output="#transformations['#attributes.fuseaction#']['#attributes.event#']['icons']['customTag']#" nameconflict="overwrite"></cffile>
            <cfinclude template="#fileName#">
            <cffile action="delete" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#">
        </cfoutput>
    </cfif>
</cfif>

<cfif (isdefined("tabMenuData") and StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus'],'#attributes.event#'))>
	<cfif StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#'],'menus')>
    	<cfloop index="aaa" from="1" to="#structCount(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'])#">
        	<cfif StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'][aaa-1],'customTag')>
				<cfoutput>
					<cfset tabMenuDivName = 'tabMenu#CreateUUID()#'>
                    <cfset fileName = '#tabMenuDivName#.cfm'>
                    <cffile action="write" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#" output="#tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'][aaa-1]['customTag']#" nameconflict="overwrite"></cffile>
                    <cfsavecontent variable="tabMenuDivName">
                        <cfinclude template="#fileName#">
                    </cfsavecontent>
					<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'][aaa-1]['onClick'] = '#tabMenuDivName#'>
                    <cfset StructDelete(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['menus'][aaa-1], 'customTag')>
                    <cffile action="delete" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#">
				</cfoutput>
            </cfif>
        </cfloop>
    </cfif>
    
    <cfif StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#'],'icons')><!--- np custom tag'i için eklenmiştir. --->
    	<cfif StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'],'extra')>
        	<cfif StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['extra'],'customTag')>
				<cfoutput>
                    <cfset tabMenuDivName = 'tabMenu#CreateUUID()#'>
                    <cfset fileName = '#tabMenuDivName#.cfm'>
                    <cffile action="write" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#" output="#tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['extra']['customTag']#" nameconflict="overwrite"></cffile>
                    <cfinclude template="#fileName#">
                    <cfloop from="1" to="2" index="index">
                        <cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['extra'][index]['text'] = evaluate('dataLinkName#index#')>
                        <cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['extra'][index]['href'] = evaluate('datalink#index#')>
						<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['extra'][index]['status'] = evaluate('datalinkStatus#index#')>
                    </cfloop>
                    <cfset StructDelete(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['extra'], 'customTag')>
                    <cfset StructDelete(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['extra'], 'text')>
                    <cffile action="delete" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#">
                </cfoutput>
            </cfif>
        </cfif>
    	<cfif StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'],'fileAction')>
        	<cfif StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['fileAction'],'customTag')>
				<cfoutput>
                    <cfset tabMenuDivName = 'tabMenu#CreateUUID()#'>
                    <cfset fileName = '#tabMenuDivName#.cfm'>
                    <cffile action="write" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#" output="#tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['fileAction']['customTag']#" nameconflict="overwrite"></cffile>
                    <cfinclude template="#fileName#">
                    <cfloop index="indFileAction" from="1" to="#structCount(iconSet)#">
						<cfif StructKeyExists(iconSet,'pdf')>
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconSet.pdf.text]['text'] = 'PDF'>
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconSet.pdf.text]['onclick'] = iconSet.pdf.js>
                        </cfif>
						<cfif StructKeyExists(iconSet,'doc')>
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconSet.doc.text]['text'] = "#caller.getLang('main',49)#">
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconSet.doc.text]['onclick'] = iconSet.doc.js>
                        </cfif>
						<cfif StructKeyExists(iconSet,'mail')>
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconSet.mail.text]['text'] = "#caller.getLang('main',1666)#">
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconSet.mail.text]['onclick'] = iconSet.mail.js>
                        </cfif>
						<cfif StructKeyExists(iconSet,'print')>
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconSet.print.text]['text'] = "#caller.getLang('main',62)#">
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconSet.print.text]['onclick'] = iconSet.print.js>
                        </cfif>
						<cfif StructKeyExists(iconSet,'flash')>
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconSet.flash.text]['text'] = "#caller.getLang('main',62)#">
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconSet.flash.text]['onclick'] = iconSet.flash.js>
                        </cfif>
                    </cfloop>
                    <cfset StructDelete(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'],'fileAction')>
                    <cffile action="delete" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#">
                </cfoutput>
            </cfif>
        </cfif>
        <cfif StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'],'archive')>
        	<cfif StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['archive'],'customTag')>
				<cfoutput>
                    <cfset tabMenuDivName = 'tabMenu#CreateUUID()#'>
                    <cfset fileName = '#tabMenuDivName#.cfm'>
                    <cffile action="write" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#" output="#tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['archive']['customTag']#" nameconflict="overwrite"></cffile>
                    <cfinclude template="#fileName#">
                    <cfloop index="indFileAction" from="1" to="#structCount(iconInfo)#">
						<cfif StructKeyExists(iconInfo,'info')>
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconInfo.info.text]['text'] = '#caller.getLang(dictionary_id:57568)#'>
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][iconInfo.info.text]['onclick'] = iconInfo.info.js>
                        </cfif>
                    </cfloop>
                    <cfset StructDelete(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'],'archive')>
                    <cffile action="delete" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#">
                </cfoutput>
            </cfif>
        </cfif>
        <cfif StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'],'history')>
        	<cfif StructKeyExists(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['history'],'customTag')>
				<cfoutput>
                    <cfset tabMenuDivName = 'tabMenu#CreateUUID()#'>
                    <cfset fileName = '#tabMenuDivName#.cfm'>
                    <cffile action="write" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#" output="#tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons']['history']['customTag']#" nameconflict="overwrite"></cffile>
                    <cfinclude template="#fileName#">
                    <cfloop index="indFileAction" from="1" to="#structCount(IconHistory)#">
						<cfif StructKeyExists(IconHistory,'hist')>
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][IconHistory.hist.text]['text'] = '#caller.getLang('main',61)#'>
                        	<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'][IconHistory.hist.text]['onclick'] = IconHistory.hist.js>
                        </cfif>
                    </cfloop>
                    <cfset StructDelete(tabMenuStruct['#attributes.fuseaction#']['tabMenus']['#attributes.event#']['icons'],'history')>
                    <cffile action="delete" file="#GetDirectoryFromPath(GetCurrentTemplatePath())##fileName#">
                </cfoutput>
            </cfif>
        </cfif>
    </cfif>
    <cftry>
    <cfif caller.WOStruct[caller.attributes.fuseaction][caller.attributes.event]['window'] is 'popup'>
		<cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus'][caller.attributes.event]['icons']['settings']['text'] = ''>
        <cfset tabMenuStruct['#attributes.fuseaction#']['tabMenus'][caller.attributes.event]['icons']['settings']['onclick'] = "resizeTo(screen.availWidth,screen.availHeight);myPopup('formPanel');">
    </cfif>
    <cfcatch></cfcatch>
    </cftry>
    <cfset tabMenuData =  SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus'])>
</cfif>

<cfscript>
	if(isdefined("tabMenuData"))
	{
		tabMenuData = URLEncodedFormat(tabMenuData, "utf-8");
		tabMenuData = URLDecode(tabMenuData,'utf-8');
		if (left(tabMenuData, 2) is "//")
			tabMenuData = mid(tabMenuData, 3, len(tabMenuData) - 2);
		tabMenuData = replace(tabMenuData,"'","\'",'all');
	}
</cfscript>

<script type="text/javascript">
var settings = [
	
		'a[href="javascript:;"]',
		'a[href="javascript:void(0)"]',
		'a[href="javascript://"]',
		'a[href="#"]'		
			
	];// settings	
</script>

<!--- Tab menüler oluşturuluyor. --->
<cfif thisTag.executionMode eq "start">
	<cfif isdefined("tabMenuData")>
        <script>
            $(function (e) {
				
                var tabMenuData = '<cfoutput>#tabMenuData#</cfoutput>',
                    tabMenuIconsSettings = ['fa fa-eye','fa fa-envelope','fa fa-history','fa fa-magic','fa fa-table','icn-md wrk-uF0134','search','fa fa-info','fa fa-info-circle','MLM','fa fa-archive','archive','download','link','detail','bell','update','fa fa-pencil','list-ul','save','file-pdf-o','envelope-o','print','copy','add','check','settings','fa fa-qrcode','fa fa-tags'];
				<cfif isdefined("caller.attributes.event")<!---  and not listFindNoCase('list',caller.attributes.event,',') ---> <!--- Listelerde ikonların gelmesi için kaldırıldı. --->>
	                tabMenus ('set,sort', tabMenuData, $('#tabMenu'),null,"<cfoutput>#caller.pageControllerName#</cfoutput>","<cfoutput>#caller.attributes.event#</cfoutput>",tabMenuIconsSettings);
				</cfif>
                
                resizeControl(1);
                <cfif isdefined("transformations")>
                    $("<li>").attr({'class':'dropdown','id':'transformation'}).appendTo($("#tabMenu ul:first-child"));
					if($("#efatura_display").length)
						uniqueId = 	'efatura_display';
					else
						uniqueId = 	'earchive_display';
					$("#"+uniqueId).css('display','');
					$("#"+uniqueId+'Ul').css('display','');
                    $("#"+uniqueId).appendTo($("#transformation"));
                    $("#"+uniqueId+'Ul').appendTo($("#transformation"));
                </cfif>
            });//ready
        </script>
    </cfif>
</cfif>
<cfset attributes.tabMenuController = 0>
<cfif not caller.windowProp is 'popup'>
	<script>
	//$('section.pageBody').css("padding", "72px 0px 30px 0px");
	/*catalyst header alani ust kisma fixlendigi icin eklendi sa*/
	$('.page-bar').after($('.pageHeader'));
	</script>
</cfif>