<cfset modul = attributes.CIRCUIT>
<cfset pageAddress = listgetat(attributes.fuseaction,"2",".")>
 <!--- hangi modüle yetki olmadığını gösterebilmek için eklendi --->

<div class="menu" <cfif isDefined('attributes.event') and attributes.event eq "updPopup"> style="display:none;" </cfif>>
    <ul>
        <li class="navLite" <cfif modul eq "rule" and pageAddress neq "list_hr">style="border-color: #13be54;"</cfif>><a href="?fuseaction=rule.list_rule"><cf_get_lang dictionary_id='57418.Literatür'></a>  
            <!---<div class="menuToggle">
                <ul class="menuDropdown">
                     <div class="search_bar">
                        <cfinclude template="list_main_news.cfm">
                    </div> 
                    <div class="menuDropdownItem">
                        <cfinclude template="list_cat_chapter_home.cfm">
                    </div>
                </ul>
            </div>--->
        </li> 
        <cfif ListFind(session.ep.USER_LEVEL,"10") neq 0>      
            <li class="navFor" <cfif modul eq "forum">style="border-color: #009688;" <cfset color = "##009688"></cfif>><a href="?fuseaction=forum.list_forum"><cf_get_lang dictionary_id='57421.Forum'></a>   
                <!--- <div class="menuToggle">
                    <ul class="menuDropdown">
                        <div class="search_bar">
                            <cfinclude template="../../forum/display/module_header.cfm">
                        </div>
                    </ul>
                </div> --->
            </li> 
        </cfif>
        <cfif ListFind(session.ep.USER_LEVEL,"8") neq 0>  
            <li class="navDij" <cfif modul eq "asset">style="border-color: #fd950f;" <cfset color = "##fd950f"></cfif>>
                <a href="?fuseaction=asset.list_asset"><cf_get_lang dictionary_id='47626.Dijital Arşiv'></a>
                <!--- <div class="menuToggle">
                    <ul class="menuDropdown">
                        <div class="search_bar">
                            <cfinclude template="asset_search.cfm">
                        </div>
                    </ul> 
                </div> --->
            </li>
            <li>
                <a href="<cfoutput>#request.self#?fuseaction=asset.tv</cfoutput>"><cf_get_lang dictionary_id='58153.TV'></a>
                    <!--- <div class="menuToggle">
                        <ul class="menuDropdown">
                            <div class="search_bar">
                                <cfinclude template="tv_search.cfm">
                            </div>
                        </ul> 
                    </div>    --->
            </li>
        </cfif>
        <li class="navSos" <cfif fuseaction eq "myhome.hr">style="border-color: #4889f4;" <cfset color = "##4889f4"></cfif>><a href="?fuseaction=help.wiki"><cfoutput><cf_get_lang dictionary_id="60721.Wiki"></cfoutput></a></li>
        <li><a href="<cfoutput>#request.self#?fuseaction=asset.library</cfoutput>"><cf_get_lang dictionary_id='57697.Kütüphane'></a></li>
        <cfif ListFind(session.ep.USER_LEVEL,"9") neq 0>  
            <li class="navEgi" <cfif modul eq "training">style="border-color: #f5cc0f;" <cfset color = "##f5cc0f"></cfif>><a href="?fuseaction=training.welcome"><cf_get_lang dictionary_id='57419.Eğitim'></a></li> 
        </cfif>
        <cfif ListFind(session.ep.USER_LEVEL,"43") neq 0>  
            <li class="navKim" <cfif modul eq "rule" and pageAddress eq "list_hr">style="border-color: #9c44c5;" <cfset color = "##9c44c5"></cfif>><a href="?fuseaction=rule.list_hr"><cf_get_lang dictionary_id='40779.Kim Kimdir?'></a>
                <!--- <div class="menuToggle">
                    <ul class="menuDropdown">
                        <div class="search_bar">
                            <cfinclude template="hr_search.cfm">
                        </div>
                    </ul> 
                </div> --->
            </li>
        </cfif>
        <cfif ListFind(session.ep.USER_LEVEL,"81") neq 0>  
            <li class="navSos" <cfif fuseaction eq "myhome.hr">style="border-color: #4889f4;" <cfset color = "##4889f4"></cfif>><a href="?fuseaction=myhome.hr"><cf_get_lang dictionary_id='47630.İK İşlemleri'></a></li>
        </cfif>
         <cfif ListFind(session.ep.USER_LEVEL,"82") neq 0>  
            <li class="navDig" <cfif modul eq "myhome">style="border-color: #f64b4b;" <cfset color = "##f64b4b"></cfif>><a href="?fuseaction=myhome.other_hr"><cf_get_lang dictionary_id='58156.Diğer'></a></li>
        </cfif>
        
    </ul>
</div>


<script>
    $(function(){
        if($(window).width() > 568){
            $('.menu > ul > li').hover(function(){
            if($(this).find('> .menuToggle').length){
                /* $('body').css("overflow","hidden"); */
                $('#searchToggle').removeClass("active");
                $(this).find('> .menuToggle').stop().fadeIn();
                $(this).find('> a').addClass("active");
            }
        }, function(){
            /* $('body').css("overflow","auto"); */
            $(this).find('> .menuToggle').stop().fadeOut();
            $(this).find('> a').removeClass("active");
        })
        }
        else{
            $('.menu > ul > li > a').click(function(){
            if($(this).parent().find('> .menuToggle').length){
                $(this).attr("href","javascript://");
                $('#searchToggle').removeClass("active");
                $(this).parent().prevAll().find('> .menuToggle').fadeOut();
                $(this).parent().nextAll().find('> .menuToggle').fadeOut();
                $(this).parent().find('> .menuToggle').stop().fadeToggle();
            }
        })
        }
        
    })
</script>