<!DOCTYPE html>
<html lang="<cfoutput>#PAGE_DATA.LANGUAGE#</cfoutput>">
<head>
    <cfinclude  template="header.cfm">
</head>
<body data-page="<cfoutput>#GET_PAGE.PAGE_ID#</cfoutput>">
<cfoutput>#PRIMARY_DATA.APPENDIX_TOP#</cfoutput>
<cfinclude  template="site_head.cfm">
<!--- ~ PROTEIN CREATE GRID ~ --->
<cfset attributes.container_class="container-fluid special-page-#GET_PAGE.PAGE_ID#">
<cfset attributes.containiner_style="margin-top: 65px !important;">
<cfset attributes.row_class="row">
<cfset attributes.row_style="">
<cfset attributes.col_class="col-md">
<cfset attributes.col_style="">
<cfinclude template = "/PMO/protein_create_grid.cfm">
<!---  ~ PROTEIN CREATE GRID ~ --->
<cfinclude  template="footer.cfm">
<cfoutput>#PRIMARY_DATA.APPENDIX_FOOT#</cfoutput>
<script>
    var mySwiper = new Swiper ('.swiper-row', {
    // Optional parameters
    direction: 'horizontal',
    loop: false,
    slidesPerView: 3,
    spaceBetween: 20,

    // Navigation arrows
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
  })

  var mySwiper = new Swiper ('.swiper-col', {
    // Optional parameters
    cssMode: true,
    direction: 'horizontal',
    loop: true,
    slidesPerView: 1,
    mousewheel: true,
    keyboard: true,
    // Navigation arrows
    /* pagination: {
        el: '.swiper-pagination',
        dynamicBullets: true,
        clickable: true,
    }, */

  });

  var mySwiper = new Swiper ('.swiper_row-type2', {
    // Optional parameters
    direction: 'vertical',
    loop: true,
    slidesPerView: 4,
    spaceBetween: 20,

    // Navigation arrows
    navigation: {
      nextEl: '.swiper-button-right',
      prevEl: '.swiper-button-left',
    },
  })
</script>  
</body>
</html>