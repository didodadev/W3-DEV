<cfif (structKeyExists(url,'fuseaction') AND FindNoCase("emptypopup",url.fuseaction) EQ 0) OR not structKeyExists(url,'ajax') >
  <html>
    <head>
      <cfinclude  template="header.cfm"> 
      <!-- Bootstrap CSS -->
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
      <!--- <link rel="stylesheet" type="text/css" href="/themes/bootstrap/assets/css/style.css"> --->
      <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
      <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
      <script  type="text/javascript" src="/src/assets/js/js_functions.js"></script>
      <script  type="text/javascript" src="/src/assets/js/js_functions_money_tr.js"></script>
      <script  type="text/javascript" src="/src/assets/js/axios.min.js"></script>
      <script  type="text/javascript" src="/src/assets/js/vue.js"></script> 
      <script  type="text/javascript" src="/src/assets/plugin/js_calender/js/jscal2.js"></script>
      <script  type="text/javascript" src="/src/assets/js/protein.js"></script>
      <script  type="text/javascript" src="/src/assets/js/AjaxControl/dist/build.js"></script><!--- AjaxControl --->  
      <link rel="stylesheet" type="text/css" href="/src/assets/css/protein.css?v=1234"> 
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/js_calender/css/jscal2.css">
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/js_calender/css/border-radius.css">
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/toastr/toastr.min.css">
      <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
      <script defer src="/src/assets/plugin/font_awsome/js/all.min.js"></script>     
      <link rel="manifest" href="/manifest.json">
      <script>
          if ('serviceWorker' in navigator) navigator.serviceWorker.register('/protein-sw.js');
      </script>
      <cfif len(PRIMARY_DATA.FAVICON)><link rel="icon" type="image/png" href="/src/includes/manifest/<cfoutput>#PRIMARY_DATA.FAVICON#</cfoutput>"/></cfif>
      <link rel="icon" type="image/png" href="/src/includes/manifest/6_og_image.ico"/>
    </head>
    <body data-page="<cfoutput>#GET_PAGE.PAGE_ID#</cfoutput>" dir="<cfoutput>#(session_base.language eq "arb")?"rtl":"ltr"#</cfoutput>">
   
      <cfoutput>#PRIMARY_DATA.APPENDIX_TOP#</cfoutput>
      <cfinclude  template="top_nav.cfm">
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
          <cfinclude template = "../../../../PMO/protein_create_grid.cfm">
        <!---  ~ PROTEIN CREATE GRID ~ --->
      </cfif>    
      <!-- Optional JavaScript -->
      <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
      <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
      <script type="text/javascript" src="/src/assets/plugin/toastr/toastr.min.js"></script>
      <cfinclude  template="footer.cfm">
      <cfoutput>#PRIMARY_DATA.APPENDIX_FOOT#</cfoutput>
      <!--- * SCHEMA.ORG ld+json OLUSTURUR --->
      <cfloop array="#structKeyArray(SCHEMA_ORG)#" item="item">
        <cfset schema = evaluate("SCHEMA_ORG.#item#")>
        <script type="application/ld+json"><cfoutput>#replace(serializeJSON(schema), "//", "")#</cfoutput></script>
      </cfloop>
    </body>
  </html>
<cfelse>
   <cfinclude  template="/caller_action.cfm">
</cfif>