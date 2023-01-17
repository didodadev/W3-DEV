<html lang="<cfoutput>#PAGE_DATA.LANGUAGE#</cfoutput>">
  <head>
    <cfinclude  template="header.cfm"> 
    <link rel="stylesheet" href="/themes/holistic_digital_academy/css/bootstrap.min.css">
    <link rel="stylesheet" href="/themes/holistic_digital_academy/css/index.css">
  </head>
  <body data-page="<cfoutput>#GET_PAGE.PAGE_ID#</cfoutput>">
    <cfoutput>#PRIMARY_DATA.APPENDIX_TOP#</cfoutput>
    <cfinclude  template="top_nav.cfm">
    <article>
        <!--- ~ PROTEIN CREATE GRID ~ --->
        <cfset attributes.container_class="container-fluid special-page-#GET_PAGE.PAGE_ID#">
        <cfset attributes.containiner_style="margin-top: 65px !important;">
        <cfset attributes.row_class="row">
        <cfset attributes.row_style="">
        <cfset attributes.col_class="col-md">
        <cfset attributes.col_style="">
        <cfinclude template = "/PMO/protein_create_grid.cfm">
        <!---  ~ PROTEIN CREATE GRID ~ --->
    </article>
    <cfinclude  template="footer.cfm">
    <cfoutput>#PRIMARY_DATA.APPENDIX_FOOT#</cfoutput>
  </body>
</html>