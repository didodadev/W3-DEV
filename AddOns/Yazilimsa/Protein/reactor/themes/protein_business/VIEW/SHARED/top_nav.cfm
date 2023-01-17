
<header class="top-nav-standart">
    <div class="left">
        <div class="logo">
            <a href="<cfoutput>#site_language_path#</cfoutput>"> <img src="/themes/protein_business/assets/img/W3_logo.png" alt="Workcube Logo"></a>               
        </div>
    </div>
    <div class="right">
        <div class="right-top">
            <ul>
                <cfif session_base.language eq 'tr'>
                <!---- <li class="search"><a href=""><i class="fas fa-search"></i>Search</a></li> ---->
                <li class="whatsapp"><a href="https://api.whatsapp.com/send/?phone=905531073722&text&app_absent=0"><i class="fab fa-whatsapp"></i>0553 107 37 22</a></li>
                <li class="phone"><a href="tel:908504412323"><i class="fas fa-phone-alt"></i>0850 441 23 23</a></li>
                <li class="phone"><a href="/contact">İletişim</a></li>
                <cfelse>
                <li class="phone"><a href="/contact">Contact</a></li>
                </cfif>
                <li class="login"><a href="https://alltogether.workcube.com">Alltogether <i class="fa-sign-in-alt fas ml-1 text-reset"></i></a></li>
                <li  class="dropdown">
                    <a href="#" class="dropdown-toggle" id="dropdownLanguage" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20.617" height="20.617" viewBox="0 0 20.617 20.617"><defs><clipPath id="a"><rect width="20.617" height="20.617" fill="#57b8ff"/></clipPath></defs><g clip-path="url(#a)"><path d="M10.3,0A10.309,10.309,0,1,0,20.617,10.309,10.3,10.3,0,0,0,10.3,0m7.144,6.185H14.4a16.037,16.037,0,0,0-1.423-3.67,8.28,8.28,0,0,1,4.465,3.67M10.309,2.1a14.522,14.522,0,0,1,1.969,4.082H8.339A14.552,14.552,0,0,1,10.309,2.1M2.329,12.37a8.554,8.554,0,0,1-.267-2.062,8.547,8.547,0,0,1,.267-2.062H5.814a17.025,17.025,0,0,0-.144,2.062,17.025,17.025,0,0,0,.144,2.062Zm.846,2.062h3.04A16.183,16.183,0,0,0,7.639,18.1a8.23,8.23,0,0,1-4.464-3.67m3.04-8.247H3.175a8.23,8.23,0,0,1,4.464-3.67,16.183,16.183,0,0,0-1.424,3.67m4.094,12.329a14.552,14.552,0,0,1-1.97-4.082h3.939a14.522,14.522,0,0,1-1.969,4.082M12.72,12.37H7.9a15,15,0,0,1-.165-2.062A14.875,14.875,0,0,1,7.9,8.247H12.72a15.035,15.035,0,0,1,.166,2.062,15.167,15.167,0,0,1-.166,2.062m.258,5.732a16.037,16.037,0,0,0,1.423-3.67h3.042a8.284,8.284,0,0,1-4.465,3.67M14.8,12.37a17.025,17.025,0,0,0,.144-2.062A17.025,17.025,0,0,0,14.8,8.247h3.484a8.5,8.5,0,0,1,.268,2.062,8.5,8.5,0,0,1-.268,2.062Z" fill="#57b8ff"/></g></svg>
                    </a>
                    <div class="dropdown-menu" aria-labelledby="dropdownLanguage">
                        <cfoutput>                
                        <cfloop collection="#lang_list#" item="item">
                            <a class="dropdown-item" href="/#item#">#lang_list[item][1]#</a>
                        </cfloop>
                        </cfoutput>
                    </div>
                </li>
            </ul>
        </div>
        <div class="right-bottom">
            <div class="menu">                
                <ul>
                    <cfoutput>                  
                        <cfloop array="#GET_DEFAULT_MENU_JSON#" item="ITEM">
                        <li><a <cfif ITEM.type neq "group"> href="#site_language_path#/#ITEM.url#"<cfelse>href="javascript://"</cfif>>
                            #ITEM.name#
                            <cfif ITEM.type eq "group">
                                <svg xmlns="http://www.w3.org/2000/svg" width="13.104" height="7.824" viewBox="0 0 13.104 7.824">
                                    <path id="Path_733" data-name="Path 733" d="M0,5.137,5.276,0,10.5,5.137" transform="matrix(-1, 0.017, -0.017, -1, 11.845, 6.395)" fill="none"  stroke-linecap="round" stroke-width="1.75"/>
                                </svg>
                            </cfif>
                            </a>
                            <cfif ITEM.type eq 'group'>
                            <cfset megamenu = MAIN.GET_MEGA_MENU(megamenu:ITEM.id)>                                              
                            <div class="dropdown_menu">
                                <i class="fa-lg fa-times fas float-right text-muted dropdown-close"></i>
                                <cfif megamenu.recordcount>
                                        <!--- ~ PROTEIN Mega Menu Create Grid ~ --->
                                        <cfset attributes.mm_container_class="dropdown_menu_flex">
                                        <cfset attributes.mm_containiner_style="">
                                        <cfset attributes.mm_row_class="row">
                                        <cfset attributes.mm_row_style="">
                                        <cfset attributes.mm_col_class="col-md">
                                        <cfset attributes.mm_col_style="">
                                        <cfinclude template = "../../../../PMO/protein_mega_menu_cereate_grid.cfm">
                                        <!---  ~ PROTEIN Mega Menu Create Grid  ~ --->                                      
                                <cfelse>
                                    <cfif StructKeyExists(ITEM,"CHILDREN")>  
                                        <div class="dropdown_menu_flex">
                                            <div>
                                                <h1></h1>
                                                <ul>
                                                    <li>
                                                        <cfloop array="#ITEM.CHILDREN#" item="ITEM">
                                                            <a href="#site_language_path#/#ITEM.url#">#ITEM.name#</a>
                                                        </cfloop>
                                                    </li>
                                                </ul>
                                            </div>  
                                        </div> 
                                    </cfif>
                                </cfif>
                            </div>
                            </cfif>
                        </li>
                        </cfloop>
                    </cfoutput>                    
                </ul>
                <div class="btnn">
                    <!---- <a href="">Kullanmaya Başla</a> ---->
                    <a href="https://holistic.workcube.com">Live Demo</a>
                </div>
            </div>
        </div>
    </div>
</header>
<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top top-nav-mobile">
 
    <a class="navbar-brand" href="<cfoutput>#site_language_path#</cfoutput>">
         <img src="/themes/protein_business/assets/img/W3_logo.png" alt="Workcube Logo">
        </a>               


    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
        <cfoutput>                  
            <cfloop array="#GET_DEFAULT_MENU_JSON#" item="ITEM">
                <li class="nav-item<cfif ITEM.type eq "group"> dropdown</cfif>">
                    <a <cfif ITEM.type neq "group"> href="#site_language_path#/#ITEM.url#" class="nav-link"<cfelse>href="javascript://" class="nav-link dropdown-toggle"  data-toggle="dropdown" </cfif>>
                    #ITEM.name#
                    </a>
                    <cfif ITEM.type eq 'group'>
                        <cfset megamenu = MAIN.GET_MEGA_MENU(megamenu:ITEM.id)> 
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <cfif megamenu.recordcount>
                                <!--- ~ PROTEIN Mega Menu Create Grid ~ --->
                                <cfset attributes.mm_container_class="dropdown_menu_flex">
                                <cfset attributes.mm_containiner_style="">
                                <cfset attributes.mm_row_class="row">
                                <cfset attributes.mm_row_style="">
                                <cfset attributes.mm_col_class="col-md">
                                <cfset attributes.mm_col_style="">
                                <cfinclude template = "../../../../PMO/protein_mega_menu_cereate_grid.cfm">
                                <!---  ~ PROTEIN Mega Menu Create Grid  ~ --->                                      
                            <cfelse>
                                <cfif StructKeyExists(ITEM,"CHILDREN")>  
                                    <cfloop array="#ITEM.CHILDREN#" item="ITEM">
                                        <a class="dropdown-item" href="#site_language_path#/#ITEM.url#">#ITEM.name#</a>
                                    </cfloop>  
                                </cfif>
                            </cfif>
                        </div>
                    </cfif>
                </li>
            </cfloop>
        </cfoutput> 
        <li  class="dropdown">
            <a href="#" class="dropdown-toggle text-success" id="dropdownLanguage" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20.617" height="20.617" viewBox="0 0 20.617 20.617"><defs><clipPath id="a"><rect width="20.617" height="20.617" fill="#57b8ff"/></clipPath></defs><g clip-path="url(#a)"><path d="M10.3,0A10.309,10.309,0,1,0,20.617,10.309,10.3,10.3,0,0,0,10.3,0m7.144,6.185H14.4a16.037,16.037,0,0,0-1.423-3.67,8.28,8.28,0,0,1,4.465,3.67M10.309,2.1a14.522,14.522,0,0,1,1.969,4.082H8.339A14.552,14.552,0,0,1,10.309,2.1M2.329,12.37a8.554,8.554,0,0,1-.267-2.062,8.547,8.547,0,0,1,.267-2.062H5.814a17.025,17.025,0,0,0-.144,2.062,17.025,17.025,0,0,0,.144,2.062Zm.846,2.062h3.04A16.183,16.183,0,0,0,7.639,18.1a8.23,8.23,0,0,1-4.464-3.67m3.04-8.247H3.175a8.23,8.23,0,0,1,4.464-3.67,16.183,16.183,0,0,0-1.424,3.67m4.094,12.329a14.552,14.552,0,0,1-1.97-4.082h3.939a14.522,14.522,0,0,1-1.969,4.082M12.72,12.37H7.9a15,15,0,0,1-.165-2.062A14.875,14.875,0,0,1,7.9,8.247H12.72a15.035,15.035,0,0,1,.166,2.062,15.167,15.167,0,0,1-.166,2.062m.258,5.732a16.037,16.037,0,0,0,1.423-3.67h3.042a8.284,8.284,0,0,1-4.465,3.67M14.8,12.37a17.025,17.025,0,0,0,.144-2.062A17.025,17.025,0,0,0,14.8,8.247h3.484a8.5,8.5,0,0,1,.268,2.062,8.5,8.5,0,0,1-.268,2.062Z" fill="#5BBD72"/></g></svg>
            </a>
            <div class="dropdown-menu" aria-labelledby="dropdownLanguage">
                <cfoutput>                
                <cfloop collection="#lang_list#" item="item">
                    <a class="dropdown-item" href="/#item#">#lang_list[item][1]#</a>
                </cfloop>
                </cfoutput>
            </div>
        </li>
        </ul>
    </div>
</nav>

    <script>
        $(function(){
            if(location.pathname != "/" && location.pathname != "/urun_detay"){
                $('body').addClass("home");
            }
            $(document).click((event) => {
                if (!$(event.target).parent().closest('.menu').length) {
                   $('.dropdown_menu').stop().fadeOut();
                   $('.menu li').removeClass("active");
                }        
            });
            $('.menu li').click(function(){
                if($(this).find('> .dropdown_menu').length){
                    $(this).addClass("active");
                    $(this).prevAll().removeClass("active");
                    $(this).nextAll().removeClass("active");
                    $(this).prevAll().find('> .dropdown_menu').fadeOut();
                    $(this).nextAll().find('> .dropdown_menu').fadeOut();
                    $(this).find('> .dropdown_menu').stop().fadeIn();
                }
            });

            $('.dropdown-close').click(function(){
                setTimeout(function(){

                    $('.dropdown_menu').stop().fadeOut();
                   $('.menu li').removeClass("active");
                 }, 300);
                
            })
        })

       
    </script>
    
    
    