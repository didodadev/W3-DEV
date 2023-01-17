<cfif (structKeyExists(url,'fuseaction') AND FindNoCase("emptypopup",url.fuseaction) EQ 0) OR not structKeyExists(url,'ajax') >
  <html lang="<cfoutput>#session_base.language#</cfoutput>">
    <head>
      <cfinclude  template="header.cfm">
      <!-- Optional JavaScript -->
      <!-- jQuery first, then Popper.js, then Bootstrap JS, then slick.js -->
      <script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>
      <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
      <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
      <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
      <script  type="text/javascript" src="/themes/protein_project/assets/js/slick.min.js"></script>   
      <script  type="text/javascript" src="/src/assets/plugin/sweetalert/sweetalert.min.js"></script>    
      <!-- Bootstrap CSS -->
      <link rel="stylesheet" type="text/css" href="/themes/protein_project/assets/css/bootstrap.min.css">
      <script  type="text/javascript" src="/src/assets/js/js_functions.js"></script>
      <script  type="text/javascript" src="/src/assets/js/js_functions_money_tr.js"></script>
      <script  type="text/javascript" src="/src/assets/js/axios.min.js"></script>
      <script  type="text/javascript" src="/src/assets/js/vue.js"></script> 
      <script  type="text/javascript" src="/src/assets/plugin/js_calender/js/jscal2.js"></script>
      <script  type="text/javascript" src="/src/assets/js/protein.js"></script>
      <script  type="text/javascript" src="/src/assets/plugin/payment-master/dist/payment.js"></script>
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/js_calender/css/jscal2.css">
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/js_calender/css/border-radius.css">
      <link href="/src/assets/plugin/font_awsome/css/all.css" rel="stylesheet">    
      <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
      <script src="https://cdn.ckeditor.com/ckeditor5/24.0.0/classic/ckeditor.js"></script>
      <script  type="text/javascript" src="/src/assets/js/AjaxControl/dist/build.js"></script><!--- AjaxControl --->
      <link rel="manifest" href="/manifest.cfc?method=get">
    
      <!--- reset.css --->
      <link rel="stylesheet" href="/src/assets/css/reset.css">
      <!--- protein.css --->
      <link href="/src/assets/css/protein.css?v=04102021" rel="stylesheet" type="text/css">    
      <!--- Crop --->
      <script  type="text/javascript" src="/src/assets/js/jquery-cropper.js"></script>  
      <link href="/src/assets/css/crop.css" rel="stylesheet" type="text/css">   
      <!--- favicon --->
      <link rel="icon" type="image/png" href="/src/includes/manifest/<cfoutput>#PRIMARY_DATA.FAVICON#</cfoutput>"/>
      <!--- icons --->
      <link rel="stylesheet" href="/src/assets/icons/fontello/fontello.css">    
      <link rel="stylesheet" href="/src/assets/icons/icon-Set/icon-Set.css">   
      <link rel="stylesheet" href="/src/assets/icons/simple-line/simple-line-icons.css ">  
      <!--- svg --->
      <link rel="stylesheet" href="src/assets/svg/svg.css">      
      <!--- style.css --->
      <link rel="stylesheet" href="/themes/protein_project/assets/css/style.css">
      <!--- toastr --->
      <link rel="stylesheet" type="text/css" href="/src/assets/plugin/toastr/toastr.min.css">
      <script type="text/javascript" src="/src/assets/plugin/toastr/toastr.min.js"></script>
      <!--- slick.css--->
      <link rel="stylesheet" href="/themes/protein_project/assets/css/slick.css">
      <!--- FullCalendar --->
      <link href='/src/assets/js/fullcalendar/css/fullcalendar.css' rel='stylesheet' />
      <link href='/src/assets/js/fullcalendar/css/fullcalendar.print.min.css' rel='stylesheet' media='print' />
      <script type="text/javascript" src="/src/assets/js/fullcalendar/moment.min.js"></script>      
      <script type="text/javascript" src="/src/assets/js/fullcalendar/fullcalendar.js"></script> 
      <!--- index.css --->
      <link rel="stylesheet" href="/themes/protein_project/assets/css/index.css">
      <script src="https://cdn.jsdelivr.net/npm/@splidejs/splide@latest/dist/js/splide.min.js"></script>
			<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@splidejs/splide@latest/dist/css/splide.min.css">
      <!--- isotope --->
      <script type="text/javascript" src="/src/assets/js/isotope.pkgd.min.js"></script>
    </head>
    <body data-page="<cfoutput>#GET_PAGE.PAGE_ID#</cfoutput>" style="background-color:#eaeaec;">
      <cfoutput>#PRIMARY_DATA.APPENDIX_TOP#</cfoutput>
      <cfinclude  template="top_nav.cfm">
      <cfif isdefined("url.fuseaction")>
          <main role="main" class="special-page-caller"> 
            <cfinclude  template="/caller_action.cfm">
          </main>
      <cfelse>
      <!--- ~ PROTEIN CREATE GRID ~ --->
      <cfset attributes.container_class="special-page-#GET_PAGE.PAGE_ID#">
      <cfset attributes.containiner_style="">
      <cfset attributes.row_class="row">
      <cfset attributes.row_style="margin:0">
      <cfset attributes.col_class="col-md">
      <cfset attributes.col_style="padding: 0px 10!important;">
      <cfset attributes.col_style2="padding: 0px 0px!important;">
      <cfinclude template = "../../../../PMO/protein_create_grid.cfm">
      <!---  ~ PROTEIN CREATE GRID ~ --->
      </cfif>
      
  <cfinclude  template="footer.cfm">
      <cfoutput>#PRIMARY_DATA.APPENDIX_FOOT#</cfoutput>
    </body>
  </html>
  <cfelse>
    <cfinclude  template="/caller_action.cfm">
  </cfif>