<!---<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="search_box_#round(rand()*10000000)#">--->


<cfif not isdefined("caller.attributes.fuseaction") or not isdefined("caller.lang_array_main")>
	<cfset caller = caller.caller>
</cfif>
<cfparam name="attributes.id" default="medium_list_search_#caller.attributes.fuseaction#">
<cfset attributes.id = replace(attributes.id,'.','_')>
<cfset fuseact = '#caller.attributes.fuseaction#'>
<cfset caller.last_table_id = attributes.id>
<cfif isdefined("attributes.collapsed") and attributes.collapsed eq 1> <!--- Bu kosul disaridan collapsed attributes'u find_active imajinin degilde find imajinin gelmesi icin eklendi. Bunun devami detail_area custom tag'inde. Orada da detail_area'nin gizli gelmesi icin kullaniliyor... E:Y 20121011 --->
	<cfset caller.collapsed_medium_list = 1>
<cfelseif isdefined("attributes.collapsed") and attributes.collapsed eq 0>
	<cfset caller.collapsed_medium_list = 0>
<cfelse>
	<cfset attributes.collapsed = 1>
    <cfif isdefined("caller.xml_unload_body_#caller.last_table_id#")>
        <cfset attributes.collapsed = evaluate("caller.xml_unload_body_#caller.last_table_id#")>
    <cfelseif isdefined("caller.caller.xml_unload_body_#caller.last_table_id#")>
        <cfset attributes.collapsed = evaluate("caller.caller.xml_unload_body_#caller.last_table_id#")>
    </cfif>
</cfif>
<cfparam name="attributes.title" default="">
<cfparam name="attributes.search" default="1">
<cfparam name="attributes.detailed_search" default="1">
<cfparam name="attributes.no_show" default="0">
<cfparam name="attributes.no_display" default="0">
<cfparam name="attributes.hide_images" default="0">

<cfoutput>
<cfif thisTag.executionMode eq "start">

	<cfif isdefined("caller.WOStruct") and StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#'],'add') and StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#']['add'],'fuseaction')>
		<cfif StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#'],'list') and StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#']['list'],'addButton') and caller.WOStruct['#caller.attributes.fuseaction#']['list']['addButton'] eq 0>
            <cfset addFuseaction = ''>
        <cfelse>
        	<cfset addFuseaction = '#caller.attributes.fuseaction#&event=add'>
        </cfif>
    <cfelse>
        <cfset addFuseaction = ''>
    </cfif>
    
	<cfset sira = listFindNoCase(application.langsAllList,session.ep.language,',')>
    <cfset titleCustom = caller.getLang('main',492)>
	<cfif len(attributes.title)>
    	<cftry>
        	<cfset attributes.title = listGetAt(attributes.title,sira,'█')>
        <cfcatch>
        	<cfset attributes.title = listFirst(attributes.title,'█')>
        </cfcatch>
        </cftry>
    </cfif>
	<cfif attributes.no_display neq 1>
    <!-- sil -->
    </cfif>
    <div align="left">
   <table id="<cfoutput>#attributes.id#</cfoutput>" class="form-inline" cellspacing="0" > <!--- Yeni birsey ekleyecekseniz class ifadesinden oncesine ekleyiniz. PDF alirken  kalan kisim uzerinden replace ediliyor. EY 20130812 --->
	<cfif attributes.no_display eq 1>
    <!-- sil -->
    </cfif>
	<tr>
    	<td>
			<div style="width:100%;" <cfif caller.attributes.fuseaction contains 'autoexcelpopuppage_'>colspan='10'</cfif>>
                <!-- sil -->
				<script type="text/javascript">
					
					$(function (){
						var __div =	$('<div class="otherFilter">')
							.attr('id','#attributes.id#_open_area')
							.append(function(){
								
								var aText = '<span id="#attributes.id#_image" class="btn blue btn-small wrk_detail_button" onclick="#attributes.id#_islem_yap()" title="#titleCustom#">#titleCustom#<i class="icon-angle-down"></i></span><span id="#attributes.id#_image_close" style="display:none;" class="btn blue btn-small wrk_detail_button" onclick="#attributes.id#_islem_yap()" title="#titleCustom#">#titleCustom#<i class="icon-angle-up"></i></span>';

								<cfif len(addFuseaction)>
									aText = aText  + '<a class="btn grey-cascade btn-small icon-pluss margin-left-5" href="<cfoutput>#request.self#?fuseaction=#addFuseaction#</cfoutput>"></a>';
								</cfif>

								$('<a>')
									.addClass("font-blue")
									.attr({
										'href':'javascript://',
										'id':'big_list_search_image'
										//,'onclick': '#attributes.id#_islem_yap();'
									})
									.append(aText)
									.appendTo( this );
							})
							.attr('style', 'display: none !important');// __div append
												
						$("##wrk_search_button")
							.after(__div);

					 $('.big_list_search_area table tr, .big_list_search_area table tr, .big_list_search_area table tr td').removeAttr('style');
				
				});//readyy
					  function #attributes.id#_islem_yap()
                        {
							gizle_goster(#attributes.id#_search_div);
							gizle_goster(#attributes.id#_image);
							gizle_goster(#attributes.id#_image_close);
							show_hide_medium_list('#attributes.id#','#fuseact#');
						}
				</script>
    
                <!-- sil -->
<cfelse>
		</div>
		</td>
	</tr>
	<cfif attributes.no_display eq 1>
    <!-- sil -->
    </cfif>
    </table>
    <table class="medium_list_head">
        <tr>
        	<td>
                <div style="float:left; font-size: 15px; padding: 5px;">
				  <cfif attributes.no_display eq 1><!-- sil --></cfif>&nbsp;#attributes.title#<cfif attributes.no_display eq 1><!-- sil --></cfif>
                   
                </div>
                <div style="float:right">
                    <div class="listIcon" id="listIcon"></div>
                </div>
            </td>
        </tr>
	</table>
    
    
    
    
    </div>
	<cfif attributes.no_display neq 1 and attributes.no_show eq 0>
    <!-- sil -->
    </cfif>
</cfif>
</cfoutput>
