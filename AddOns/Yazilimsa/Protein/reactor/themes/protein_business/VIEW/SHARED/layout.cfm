<cfif (structKeyExists(url,'fuseaction') AND FindNoCase("emptypopup",url.fuseaction) EQ 0) OR not structKeyExists(url,'ajax') >
  <html lang="">
    <head>
      <cfinclude  template="header.cfm"> 
      <!-- Bootstrap CSS -->
      <script  type="text/javascript" src="/src/assets/js/jquery.js"></script>
      <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>    
      <script type="text/javascript" src="/src/assets/js/AjaxControl/dist/build.js"></script><!--- AjaxControl --->  
      <script  type="text/javascript" src="/themes/protein_business/assets/js/slick.min.js"></script>
      <script  type="text/javascript" src="/src/assets/plugin/sweetalert/sweetalert.min.js"></script>
      <script  type="text/javascript" src="/src/assets/js/js_functions.js"></script>
      <script  type="text/javascript" src="/src/assets/js/js_functions_money_tr.js"></script>
      <script  type="text/javascript" src="/src/assets/js/axios.min.js"></script>
      <script  type="text/javascript" src="/src/assets/js/vue.js"></script> 
      <script  type="text/javascript" src="/src/assets/plugin/js_calender/js/jscal2.js"></script>
      <script  type="text/javascript" src="/src/assets/js/protein.js"></script>
      <script  type="text/javascript" src="/src/assets/js/isotope.pkgd.min.js"></script>
      <script  type="text/javascript" src="/src/assets/plugin/select2/js/select2.min.js"></script>
      <script  type="text/javascript" src="/src/assets/plugin/payment-master/dist/payment.js"></script>
      <script  type="text/javascript" src="/src/assets/plugin/imask/mask.js"></script>
      <link rel="stylesheet" type="text/css" href="/src/assets/css/protein.css?v=1234"> 
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/js_calender/css/jscal2.css">
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/js_calender/css/border-radius.css">
      <link href="/src/assets/plugin/font_awsome/css/all.css" rel="stylesheet">
      <link href="/src/assets/css/bootstrap.min.css" rel="stylesheet">
      <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
      <link rel="stylesheet" href="/themes/protein_business/assets/css/slick.css">
      <link rel="stylesheet" href="/themes/protein_business/assets/css/index.css">
      <link rel="stylesheet" href="https://together.workcube.com/src/assets/svg/svg.css">
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/select2/css/select2.min.css">
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/toastr/toastr.min.css">
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/sweetalert/sweetalert.min.css">
      <script type="text/javascript" src="/src/assets/plugin/toastr/toastr.min.js"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
      <link rel="manifest" href="/manifest.cfc?method=get">
    	<link rel="icon" type="image/png" href="/src/includes/manifest/<cfoutput>#PRIMARY_DATA.FAVICON#</cfoutput>"/>
      
    </head>
    <body data-page="<cfoutput>#GET_PAGE.PAGE_ID#</cfoutput>">
      <cfoutput>#PRIMARY_DATA.APPENDIX_TOP#</cfoutput>
      <cfinclude  template="top_nav.cfm">
      <cfif isdefined("url.fuseaction")>
          <main role="main" class="container-fluid special-page-caller"> 
            <cfinclude  template="/caller_action.cfm">
          </main>
      <cfelse>
        <!--- ~ PROTEIN CREATE GRID ~ --->
        <cfset attributes.container_class="container-fluid special-page-#GET_PAGE.PAGE_ID#">
        <cfset attributes.containiner_style="">
        <cfset attributes.row_class="row">
        <cfset attributes.row_style="">
        <cfset attributes.col_class="col-lg">
        <cfset attributes.col_style="">
        <cfinclude template = "../../../../PMO/protein_create_grid.cfm">
        <!---  ~ PROTEIN CREATE GRID ~ --->
      </cfif>    
      <!-- Optional JavaScript -->
      <cfinclude  template="footer_#session_base.language#.cfm">     
       <cfoutput>#PRIMARY_DATA.APPENDIX_FOOT#</cfoutput>
      <!--- * SCHEMA.ORG ld+json OLUSTURUR --->
      <cfloop array="#structKeyArray(SCHEMA_ORG)#" item="item">
        <cfset schema = evaluate("SCHEMA_ORG.#item#")>
        <script type="application/ld+json"><cfoutput>#replace(serializeJSON(schema), "//", "")#</cfoutput></script>
      </cfloop>
      <script src="/src/assets/js/bootstrap.min.js"></script>
    </body>
  </html>
<cfelse>
   <cfinclude  template="/caller_action.cfm">
</cfif>