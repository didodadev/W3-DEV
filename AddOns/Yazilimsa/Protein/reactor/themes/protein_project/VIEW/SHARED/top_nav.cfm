<nav class="navbar navbar-expand-xl navbar-light fixed-top shadow-sm row-bg-w" id="top_nav">
  <a href="/welcome"><div class="navbar-brand nav-img p-0"><img src="/src/includes/manifest/<cfoutput>#PRIMARY_DATA.OG_IMAGE#</cfoutput>" width="50px" height="50px"></div></a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExampleDefault" aria-controls="navbarsExampleDefault" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
    <div class="collapse navbar-collapse" id="navbarsExampleDefault">
        <ul class="navbar-nav mr-auto">
            <cfoutput>                  
                <cfloop array="#GET_DEFAULT_MENU_JSON#" item="ITEM">
                <cfset megamenu = MAIN.GET_MEGA_MENU(megamenu:ITEM.id)>
                <cfset item_class = megamenu.recordcount eq 0?"nav-item dropdown":"nav-item dropdown nav-item-mega-menu"> 
                <li <cfif ITEM.type eq "group">class="#item_class#"<cfelse> class="nav-item active"</cfif>>
                    <a <cfif ITEM.type eq "link">class="nav-link" href="#ITEM.url#"<cfelseif ITEM.type neq "group">class="nav-link" href="#site_language_path#/#ITEM.url#"<cfelse>href="javascript://" class="nav-link dropdown-toggle" data-toggle="dropdown"</cfif>>
                    #ITEM.name#
                    <cfif ITEM.type eq "group">
                        <svg xmlns="http://www.w3.org/2000/svg" width="13.104" height="7.824" viewBox="0 0 13.104 7.824">
                            <path id="Path_733" data-name="Path 733" d="M0,5.137,5.276,0,10.5,5.137" transform="matrix(-1, 0.017, -0.017, -1, 11.845, 6.395)" fill="none"  stroke-linecap="round" stroke-width="1.75"/>
                        </svg>
                    </cfif>
                    </a>
                    <cfif ITEM.type eq 'group'>
                    
                    <cfset dropdown_class = megamenu.recordcount eq 0?"dropdown-menu":"dropdown-menu dropdown-mega-menu">                                            
                    <div class="#dropdown_class#">
                        <cfif megamenu.recordcount>
                                <!--- ~ PROTEIN Mega Menu Create Grid ~ --->
                                <cfset attributes.mm_container_class="container-fluid dropdown-menu-container">
                                <cfset attributes.mm_containiner_style="">
                                <cfset attributes.mm_row_class="row">
                                <cfset attributes.mm_row_style="">
                                <cfset attributes.mm_col_class="col-md">
                                <cfset attributes.mm_col_style="">
                                <cfinclude template = "../../../../PMO/protein_mega_menu_cereate_grid.cfm">
                                <!---  ~ PROTEIN Mega Menu Create Grid  ~ --->                                      
                        <cfelse>
                            <cfif StructKeyExists(ITEM,"CHILDREN")>  
                                <div class="dropdown-menu-container">
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
    </div>  
    <div class="navbar-collapse collapse">
        <ul class="navbar-nav ml-auto d-flex align-items-center"> 
            <li class="nav-item dropdown">
                <a href="#" class="nav-link dropdown-toggle menu-item" id="dropdownLanguage" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <i class="fa fa-globe large-font"></i>
                </a>
                <div class="dropdown-menu" aria-labelledby="dropdownLanguage">
                    <cfoutput>                
                    <cfloop collection="#lang_list#" item="item">
                        <a class="dropdown-item" href="/#item#">#lang_list[item][1]#</a>
                    </cfloop>
                    </cfoutput>
                </div>
            </li>           
            <!--- <li class="nav-item">             
            <a class="nav-link waves-effect waves-light">
                <i class="fa fa-search mr-2 large-font"></i>
            </a>
            </li> --->
            <li class="nav-item">
            <a class="nav-link waves-effect waves-light" href="<cfoutput>#site_language_path#</cfoutput>/Calendar">
                <i class="fa fa-calendar large-font"></i>
            </a>
            </li>
            <!--- <li class="nav-item">
            <a class="nav-link waves-effect waves-light notification">
                <i class="fa fa-bell-o mr-2 large-font"><span class="badge badge-danger">3</span></i>
            </a>
            </li>  --->
            <cfset basketAction = createObject("component", "V16.objects2.sale.cfc.basketAction" ) />  
            <cfset show_product_on_basket = deserializeJSON(basketAction.show_product_on_basket( consumer_id: session.ww.userid?:'', partner_id: session.pp.userid?:'' ) ) />
            <li class="nav-item" type="cart">
            <a class="nav-link waves-effect waves-light notification" href="/cart">
                <i class="fa fa-shopping-basket mr-2 large-font"><span class="badge badge-success"><cfoutput>#show_product_on_basket.sepet_adet#</cfoutput></span></i>
            </a>
            </li>            
            <li class="nav-item dropdown active">
            <a class="nav-link dropdown-toggle menu-item" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                <cfoutput>#session_base.company_nick#</cfoutput>
            </a>
            <div class="dropdown-menu shadow dropdown-menu-right border-0 menu-item-on" aria-labelledby="navbarDropdown">
                <a class="dropdown-item" href="/accountStatement"><i class="fas fa-calculator text-color-2"></i> <cf_get_lang dictionary_id='61566.Hesap Özeti'></a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="/company"><i class="fas fa-city text-color-2"></i> <cf_get_lang dictionary_id='61620.Kurumsal Bilgiler'></a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="/users"><i class="fas fa-users-cog text-color-2"></i> <cf_get_lang dictionary_id='58992.Kullanıcılar'></a>
            </div>
            </li>
            <li class="nav-item dropdown active">
            <a class="nav-link dropdown-toggle menu-item" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <cfoutput> #session_base.name# #session_base.surname# </cfoutput>
            </a>
            <div class="dropdown-menu shadow dropdown-menu-right border-0 menu-item-on" aria-labelledby="navbarDropdown">
                <a class="dropdown-item" href="<cfoutput>#site_language_path#/myinfo</cfoutput>"><i class="fas fa-user-edit text-color-2"></i> <cf_get_lang dictionary_id='62041.Üyelik Bilgilerim'></a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="<cfoutput>#site_language_path#/saleorder</cfoutput>"><i class="fas fa-cart-plus text-color-2"></i> <cf_get_lang dictionary_id='64257.Siparişlerim'></a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="<cfoutput>#site_language_path#/mytender</cfoutput>"><i class="fas fa-money-bill-wave text-color-2"></i> <cf_get_lang dictionary_id='64274.İhalelerim'></a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item" href="#" @click="logOut"><i class="fas fa-sign-out-alt text-color-2"></i> <cf_get_lang dictionary_id='57431.Çıkış'></a>                         
            </div>
            </li>  
            <li>
            <cfif isdefined("session.pp.userid")>
                <cfset get_profile = GET_PARTNER(userid: session.pp.userid)>
            </cfif>
            <cfif isdefined("get_profile") and len(get_profile.photo) and FileExists(Replace(GetDirectoryFromPath(GetCurrentTemplatePath()),"AddOns\Yazilimsa\Protein\reactor\themes\protein_project\VIEW\SHARED\","documents/hr/")&get_profile.photo)>
                <svg height="40" width="40" class="rounded-circle">
                <image href="<cfoutput>http://#cgi.server_name#/documents/hr/#get_profile.photo#</cfoutput>" height="40px" width="40px"/>
                </svg> 
            <cfelseif FileExists(Replace(GetDirectoryFromPath(GetCurrentTemplatePath()),"themes\protein_project\VIEW\SHARED\","")&"images/female.JPG") or FileExists(Replace(GetDirectoryFromPath(GetCurrentTemplatePath()),"themes\protein_project\VIEW\SHARED\","")&"images/male.JPG")>
                <svg height="40" width="40" class="rounded-circle">
                <image href="/images/<cfif isdefined("get_profile") and get_profile.sex eq 1>male<cfelse>female</cfif>.JPG" height="40px" width="40px"/>
                </svg>
            <cfelse>
                <span class="rounded-circle tab-circle"><cfoutput>#Left(session_base.name, 1)##Left(session_base.surname, 1)#</cfoutput></span>
            </cfif>            
            </li>
        </ul>
    </div>        
</nav>
<script>
    var proteinApp = new Vue({
        el: '#top_nav',
        data: {
          vue: 0       
        },
        methods: {
            logOut : function(){
                axios.get( "/cfc/SYSTEM/LOGIN.cfc?method=logOut",{params:{key:200}})
                .then(response => {
                   setTimeout(function(){window.location="/"} , 2000);                              
                })
                .catch(e => {
                   console.log("");
                })
            }
        }       
    });
    

    $('.dropdown-menu.dropdown-mega-menu').on("click.bs.dropdown", function (e) {
        e.stopPropagation();                
    });
</script>
<style>
    .dropdown-menu.dropdown-mega-menu.show {width: calc(100% - 1px);left: 1px;}
    li.nav-item.dropdown.nav-item-mega-menu.show {position: unset;}
</style>