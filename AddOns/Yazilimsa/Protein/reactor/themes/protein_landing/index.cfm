<cfif (structKeyExists(url,'fuseaction') AND FindNoCase("emptypopup",url.fuseaction) EQ 0) OR not structKeyExists(url,'ajax') >
<!DOCTYPE html>
<html lang="en">
    <head>
        <cfoutput>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="#PRIMARY_DATA.DETAIL#" >
        <meta name="keywords" content="#PRIMARY_DATA.META_KEYWORD#" >
        #PRIMARY_DATA.APPENDIX_META#
        <title>#GET_PAGE.TITLE# | #PRIMARY_DATA.TITLE#</title>
        <link rel="icon" type="image/png" href="/src/includes/manifest/<cfoutput>#PRIMARY_DATA.FAVICON#</cfoutput>"/>  
        <!-- Font Awesome icons (free version)-->
        <script src="https://use.fontawesome.com/releases/v5.15.3/js/all.js" crossorigin="anonymous"></script>
        <!-- Google fonts-->
        <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i" rel="stylesheet" />
        <script  type="text/javascript" src="/src/assets/js/jquery.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script> 
        <script  type="text/javascript" src="/src/assets/js/js_functions.js"></script>
        <script  type="text/javascript" src="/src/assets/js/js_functions_money_tr.js"></script>
        <script  type="text/javascript" src="/src/assets/js/axios.min.js"></script>
        <script  type="text/javascript" src="/src/assets/js/vue.js"></script> 
        <script  type="text/javascript" src="/src/assets/plugin/js_calender/js/jscal2.js"></script>
        <script  type="text/javascript" src="/src/assets/js/protein.js"></script>
        <script  type="text/javascript" src="/src/assets/js/isotope.pkgd.min.js"></script>
          
        <!-- Core theme CSS (includes Bootstrap)-->
        <link href="/themes/protein_landing/css/styles.css" rel="stylesheet" />
        <link rel="stylesheet" type="text/css" href="/src/assets/css/protein.css?v=1234"> 
        <link rel="stylesheet" type="text/css" href="/src/assets/plugin/toastr/toastr.min.css">
        <script type="text/javascript" src="/src/assets/plugin/toastr/toastr.min.js"></script>
        </cfoutput>
    </head>
    <body id="page-top">
        <!-- Navigation-->
        <nav class="navbar navbar-expand-lg navbar-dark navbar-custom fixed-top">
            <div class="container px-5">
                <a class="navbar-brand" href="#page-top"><cfoutput>#PRIMARY_DATA.TITLE#</cfoutput></a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
                <div class="collapse navbar-collapse" id="navbarResponsive">
                    <ul class="navbar-nav ms-auto">
                        <cfoutput>                  
                            <cfloop array="#GET_DEFAULT_MENU_JSON#" item="ITEM">
                              <li <cfif ITEM.type eq "group">class="nav-item dropdown"<cfelse> class="nav-item"</cfif>><a <cfif ITEM.type neq "group"> class="nav-link" href="#ITEM.url#"<cfelse>class="nav-link dropdown-toggle" data-toggle="dropdown"</cfif>>#ITEM.name#</a>
                                <cfif ITEM.type eq 'group'>
                                  
                                  <div class="dropdown-menu">
                                    <cfloop array="#ITEM.CHILDREN#" item="ITEM">
                                      <a class="dropdown-item" href="#ITEM.url#">#ITEM.name#</a>
                                    </cfloop>
                                  </div>
                                </cfif>
                              </li>
                            </cfloop>
                        </cfoutput>
                    </ul>
                </div>
            </div>
        </nav>
        <!-- Header-->
        <header class="masthead text-center text-white">
            <div class="masthead-content">
                <div class="container px-5">
                    <h1 class="masthead-heading mb-0">
                        <img src="/src/includes/manifest/micae_logo.png" style="width: 350px;">
                    </h1>
                    <h2 class="masthead-subheading mb-0"><cfoutput>#PRIMARY_DATA.DETAIL#</cfoutput></h2>
                    <a class="btn btn-primary btn-xl rounded-pill mt-5" href="#scroll" onclick="openBoxDraggable('widgetloader?widget_load=SupportNoteForm&isbox=1')"><i class="fas fa-chevron-down"></i></a>
                </div>
            </div>
            <div class="bg-circle-1 bg-circle"></div>
            <div class="bg-circle-2 bg-circle"></div>
            <div class="bg-circle-3 bg-circle"></div>
            <div class="bg-circle-4 bg-circle"></div>
        </header>
        <!-- Content section 1-->
        <section id="scroll">
            <cfif isdefined("url.fuseaction")>
                <main role="main" class="container-fluid special-page-caller" style="margin-top: 65px !important;"> 
                  <cfinclude  template="/caller_action.cfm">
                </main>
            <cfelse>
              <!--- ~ PROTEIN CREATE GRID ~ --->
                <cfset attributes.container_class="container-fluid special-page-#GET_PAGE.PAGE_ID#">
                <cfset attributes.containiner_style="margin-top: 65px !important;">
                <cfset attributes.row_class="row">
                <cfset attributes.row_style="">
                <cfset attributes.col_class="col-md">
                <cfset attributes.col_style="">
                <cfinclude template = "/PMO/protein_create_grid.cfm">
              <!---  ~ PROTEIN CREATE GRID ~ --->
            </cfif>
        </section>
        <!-- Content section 2-->

       
        <!-- Footer-->
        <footer class="py-5 bg-black">
            <div class="container px-5"><p class="m-0 text-center text-white small">Copyright &copy; <cfoutput>#PRIMARY_DATA.TITLE#</cfoutput> 2021</p></div>
        </footer>
        <!-- Bootstrap core JS-->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.0/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Core theme JS-->
        <script src="/themes/protein_landing/js/scripts.js"></script>
    </body>
</html>
<cfelse>
    <cfinclude  template="/caller_action.cfm">
 </cfif>