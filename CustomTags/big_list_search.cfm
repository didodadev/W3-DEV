<cfparam name="attributes.id" default="big_list_search_#caller.attributes.fuseaction#">
<cfset attributes.id = replace(attributes.id,'.','_')>
<cfset fuseact = '#caller.attributes.fuseaction#'>
<cfparam name="attributes.title" default="">
<cfparam name="attributes.search" default="1">
<cfparam name="attributes.detailed_search" default="1">
<cfparam name="attributes.basket_id" default="">
<cfparam name="attributes.no_display" default="0">
<cfparam name="attributes.export" default="">

<cfset caller.last_table_id = attributes.id>
<cfif isdefined("attributes.collapsed") and attributes.collapsed eq 1> <!--- Bu kosul disaridan collapsed attributes'u find_active imajinin degilde find imajinin gelmesi icin eklendi. Bunun devami detail_area custom tag'inde. Orada da detail_area'nin gizli gelmesi icin kullaniliyor... E:Y 20121011 --->
	<cfset caller.collapsed = 1>
<cfelseif isdefined("attributes.collapsed") and attributes.collapsed eq 0>
	<cfset caller.collapsed = 0>
<cfelse>
	<cfset attributes.collapsed = 1>
    <cfif isdefined("caller.xml_unload_body_#caller.last_table_id#")>   
        <cfset attributes.collapsed = evaluate("caller.xml_unload_body_#caller.last_table_id#")>
    <cfelseif isdefined("caller.caller.xml_unload_body_#caller.last_table_id#")> 
        <cfset attributes.collapsed = evaluate("caller.caller.xml_unload_body_#caller.last_table_id#")>
    </cfif>
    <cfset caller.collapsed = 2>
</cfif>

<cfset caller.big_list_search_area_id = attributes.id&'_open_area'>
<cfset caller.big_list_search_var = 0>

<cfoutput>
<cfif thisTag.executionMode eq "start">

	
    <cfset titleCustom = caller.getLang('main',492)>
    <!---
	FA Baslik yerine filtrelerinde oldugu elementler gonderilince sorun oluyor
	
	<cfset sira = listFindNoCase(application.langsAllList,session.ep.language,',')>
    <cfif len(attributes.title)>
        <cfset attributes.title = listGetAt(attributes.title,sira,'█')>
    </cfif>
	--->
	<cfset caller.big_list_search_var = 1>
	<cfif attributes.no_display neq 1>
    <!-- sil -->
    </cfif>
	<table class="big_list_search" id="<cfoutput>#attributes.id#</cfoutput>" cellspacing="0"> <!--- cellspacing ve align'i silmeyiniz. Yerlerini degistirmeyiniz. Replace islemi icin fbx_excel'de kullaniliyor. EY 20130620 --->
	<span class="detail_button"></span>
	<cfif attributes.no_display eq 1>
    <!-- sil -->
    </cfif>
	<tr>
    	<td <cfif caller.attributes.fuseaction contains 'autoexcelpopuppage_'>colspan='10'</cfif>>
        	<div id="action_#attributes.id#" style="display:none; width:1px;"></div>
			<div style="width:100%;">
				<!---<div class="big_list_header" style="float:left;"><cfif attributes.no_display eq 1><!-- sil --></cfif>#attributes.title#<cfif attributes.no_display eq 1><!-- sil --></cfif></div>--->
				<!-- sil -->
				<cfif isdefined("caller.WOStruct") and StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#'],'add') and StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#']['add'],'fuseaction')>
                	<cfif StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#'],'list') and StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#']['list'],'addButton') and caller.WOStruct['#caller.attributes.fuseaction#']['list']['addButton'] eq 0>
                    	<cfset addFuseaction = ''>
                    <cfelse>
	                    <cfset addFuseaction = '#caller.attributes.fuseaction#&event=add'><!--- #caller.attributes.fuseaction#&event=add Daha sonra bakılacak.EY20161020 ---> 
                    </cfif>
                <cfelse>
                    <cfset addFuseaction = ''>
                </cfif>
                <script type="text/javascript">
					//icon-filter
					$(function (){
						var __div =	$('<div class="otherFilter">')
							.attr('id','#attributes.id#_open_area')
							.append(function(){
								
								var aText = '<span id="#attributes.id#_image" class="btn blue btn-small wrk_detail_button" onclick="#attributes.id#_islem_yap()" title="#titleCustom#">#titleCustom#<i class="icon-angle-down"></i></span><span id="#attributes.id#_image_close" style="display:none;" class="btn blue btn-small wrk_detail_button" onclick="#attributes.id#_islem_yap()" title="#titleCustom#">#titleCustom#<i class="icon-angle-up"></i></span>';
								<cfif len(addFuseaction)>
									aText = aText  + '<a class="btn grey-cascade btn-small icon-pluss margin-left-5" onclick="triggerPlusIcon()"></a>';
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
						show_hide_big_list('#attributes.id#','#fuseact#');
						<cfif isdefined("attributes.basket_id") and len(attributes.basket_id)>
							resize_basket('#attributes.basket_id#');
						</cfif>
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
    <table class="big_list_head">
        <tr>
        	<td>
                <div class="col col-8 col-md-8 col-xs-5 pull-left font-green-sharp" style="float:left; font-size: 14px; padding: 5px;">
				   <cfif attributes.no_display eq 1><!-- sil --></cfif>#attributes.title#<cfif attributes.no_display eq 1><!-- sil --></cfif>
                </div>
                
                    <div class="col col-4 col-md-4 col-xs-7 pull-right">
                        <div class="listIcon" id="listIcon"></div>
                    </div>
               
            </td>
        </tr>
	</table>
		
	<cfif attributes.no_display neq 1>
    <!-- sil -->
    </cfif>
</cfif>
</cfoutput>

<script>
    $(window).load(function(){
        var  __div = $('div#buttons');
        var __buttons = __div.html();
        $('.wrkFileACtions').appendTo('#listIcon');      
            __div.remove();
        <cfif not len(attributes.export)><!--- export="0" listeleme sayfalarındaki excell,word,mail,print gelmemesi için kontrol amaçlı(iadeler sayfası)--->
                $('div#listIcon').html( __buttons )
            </cfif>
        //console.log (test);
    });//windows load
</script>

