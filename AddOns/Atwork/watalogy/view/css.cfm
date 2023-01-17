/*------------------------------------------------------------------
[Table of contents]

1. Common styles
2. Top banner
3. Header
  3.1 Nav on top
  3.2 Top header
  3.3 Main header
  3.4 Main menu
    3.4.1  Vertical megamenus
    3.4.1  Main menu
4. Nav menu

5. Home slider
6. Page top
  6.1 Latest deals
  6.2 Popular tabs
7. Services
8. Product
9. Owl carousel
10. Banner advertisement
11. Page content
  11.1 Category featured
    11.1.1 Banner featured
    11.1.2 Product featured
  11.2 Banner bootom
12. Brand showcase
13. Hot categories
14. Footer
15. Breadcrumb
16. Columns
  16.1 Left column
  16.2 Center column
17. Order page
18. Product page
19. Contact page
20. Blog page
21. Login page
22. Blog
23. Footer2
24. Hot deals style 3
25. Box product
-------------------------------------------------------------------*/
/*34495e --- ana renk bu oldu */
/* ----------------
 [1. Common styles]
 */
body{
    font-family: 'Arial', sans-serif;
    font-size: 14px;
    overflow-x:hidden; 
}
body.is-ontop{
    margin-top: 53px;
}
h1{
    font-size: 44px;
}
h2{
    font-size: 20px;
}
h3{
    font-size: 18px;
}
a{
    color: #666;
}
a:hover{
    color: #34495e;
    text-decoration: none;
    transition: all 0.25s;
}
a:focus{
    text-decoration: none;
}
.bold{
  font-weight: bold;
}
.alignleft{
  float: left;
}
.alignright{
  float: right;
}
.btn-fb-login{
  width: 65px;
  height: 22px;
  background: url('../images/fb.jpg') no-repeat;
  display: inline-block;
  margin-top: 5px;
  font-size: 0;
  border: none!important;
}
.button{
  padding: 10px 20px;
  border: 1px solid #eaeaea;
  background: #666;
  color: #fff;
}
.button-sm{
  padding: 5px 10px;
}
.button:hover{
  background: #34495e;
  border: 1px solid #34495e;
}
.input{
  border-radius: 0px;
  border: 1px solid #eaeaea;
  -webkit-box-shadow: inherit;
  box-shadow: inherit;
}
.button .fa{
  line-height: inherit;
}
.text-center{
  text-align: center;
}
.text-left{
  text-align: left;
}
.text-right{
  text-align: right;
}
img.alignleft{
    margin: 0 20px 15px 0;
}
img.alignright{
    margin: 0 0 15px 20px;
}
.clearfix:before{
  content: "";
  display: table;
}

.container{
        padding-left: 0;
        padding-right: 0;
    }
.loader {
	position: fixed;
	left: 0px;
	top: 0px;
	width: 100%;
	height: 100%;
	z-index: 9999;
	background:#fff url('../images/Preloader_4.gif') 50% 50% no-repeat;
}

.banner-opacity{
  position: relative;
}
.banner-opacity a:before{
    display: block;
    position: absolute;
    -webkit-transition: all 0.1s ease-in 0.1s;
    transition: all 0.1s ease-in 0.1s;
    background: rgba(0,0,0,0.1);
    opacity: 0;
    filter: alpha(opacity=0);
    left: 0px;
    top: 0px;
    content: "";
    height: 0%;
    width: 100%;
    left: 0%;
    top: 50%;
}
.banner-opacity a:hover:before{
  opacity: 1;
  filter: alpha(opacity=1);
  -webkit-transition: all 0.2s ease-in 0.1s;
  transition: all 0.2s ease-in 0.1s;
  height: 100%;
  left: 0%;
  top: 0%;
}
.tab-container{
    position: relative;
}
.tab-container .tab-panel{
    position: absolute;
   top: 0;
   left: 0;
   width: 100%;
   opacity: 0;
   visibility: hidden;
}
.tab-container .active{
    opacity: 1;
   visibility: inherit;
   position: inherit;
   -vendor-animation-duration: 0.3s;
  -vendor-animation-delay: 1s;
  -vendor-animation-iteration-count: infinite;
}
.hover-zoom{
  -webkit-transition: 0.7s all ease-in-out;
  transition: 0.7s all ease-in-out;
  -webkit-backface-visibility: hidden;
  -webkit-perspective: 1000;
  overflow: hidden;
}
.hover-zoom:hover img{
  -webkit-transform: scale(1.1);
  -ms-transform: scale(1.1);
  transform: scale(1.1);
  opacity: 0.7;
}
.banner-boder-zoom{
  position: relative;
  overflow: hidden;
}
.banner-boder-zoom a:before{
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  content: "";
  display: block;
  z-index: 10;
  background-color: rgba(0, 0, 0, 0.2);
  background: rgba(0, 0, 0, 0.2);
  color: rgba(0, 0, 0, 0.2);
  opacity: 0;
  -webkit-transition: all 1s ease;
  -moz-transition: all 1s ease;
  -ms-transition: all 1s ease;
  -o-transition: all 1s ease;
  transition: all 1s ease;
}
.banner-boder-zoom a:after{
  position: absolute;
  top: 10px;
  left: 10px;
  right:10px;
  bottom:10px;
  content: "";
  display: block;
  z-index: 10;
  border: 1px solid #fff;
  opacity: 0;
}
.banner-boder-zoom a img{
  -webkit-transition: all 1s ease;
  -moz-transition: all 1s ease;
  -ms-transition: all 1s ease;
  -o-transition: all 1s ease;
  transition: all 1s ease;
}
.banner-boder-zoom:hover a img{
  -webkit-transform: scale(1.1);
  -moz-transform: scale(1.1);
  -ms-transform: scale(1.1);
  -o-transform: scale(1.1);
  transform: scale(1.1);
}
.banner-boder-zoom:hover a:before{
  opacity: 1;
}
.banner-boder-zoom:hover a:after{
  opacity: 0;
}
.banner-boder-zoom2{
  position: relative;
  overflow: hidden;
}
.banner-boder-zoom2 a:before{
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  content: "";
  display: block;
  z-index: 10;
  background-color: rgba(0, 0, 0, 0);
  background: rgba(0, 0, 0, 0);
  color: rgba(0, 0, 0, 0);
  opacity: 0;
  -webkit-transition: all 1s ease;
  -moz-transition: all 1s ease;
  -ms-transition: all 1s ease;
  -o-transition: all 1s ease;
  transition: all 1s ease;
}
.banner-boder-zoom2 a:after{
  position: absolute;
  top: 10px;
  left: 10px;
  right:10px;
  bottom:10px;
  content: "";
  display: block;
  z-index: 10;
  border: 1px solid #fff;
  opacity: 0;
}
.banner-boder-zoom2 a img{
  -webkit-transition: all 1s ease;
  -moz-transition: all 1s ease;
  -ms-transition: all 1s ease;
  -o-transition: all 1s ease;
  transition: all 1s ease;
}
.banner-boder-zoom2:hover a img{
  -webkit-transform: scale(1.1);
  -moz-transform: scale(1.1);
  -ms-transform: scale(1.1);
  -o-transform: scale(1.1);
  transform: scale(1.1);
}
.banner-boder-zoom2:hover a:before{
  opacity: 1;
}
.banner-boder-zoom2:hover a:after{
  opacity: 0;
}
.icon-up,
.icon-down{
  width: 100%;
  height: 17px;
  display: block;
}
.icon-up{
  background: url("../images/up.png") no-repeat center center;
}
.icon-down{
  background: url("../images/down.png") no-repeat center center;
}

.image-hover2 a{
  position: relative;
  display:table;
}
.image-hover2 a:after{
  overflow: hidden;
  position: absolute;
  top: 0;
  content: "";
  z-index: 100;
  width: 100%;
  height: 100%;
  left: 0;
  right: 0;
  bottom: 0;
  opacity: 0;
  pointer-events: none;
  -webkit-transition: all 0.3s ease 0s;
  -o-transition: all 0.3s ease 0s;
  transition: all 0.3s ease 0s;
  background-color: rgba(0, 0, 0, 0.3);
  -webkit-transform: scale(0);
  -ms-transform: scale(0);
  transform: scale(0);
  z-index: 1;
}
.image-hover2 a:before{
  font: normal normal normal 18px/1 FontAwesome;
  content: "\f002";
  position: absolute;
  top: 50%;
  left: 50%;
  z-index: 2;
  color: #fff;
  ms-transform: translateY(-50%);
  -webkit-transform: translateY(-50%);
  transform: translateY(-50%);

  ms-transform: translateX(-50%);
  -webkit-transform: translateX(-50%);
  transform: translateX(-50%);
  opacity: 0;
  -webkit-transition: opacity 0.3s ease 0s;
  -o-transition: opacity 0.3s ease 0s;
  transition: opacity 0.3s ease 0s;
}
.image-hover2 a:hover:after{
  visibility: visible;
  opacity: 0.8;
  -webkit-transform: scale(1);
  -ms-transform: scale(1);
  transform: scale(1);
}
.image-hover2 a:hover:before{
  opacity: 1;
}

/* ----------------
 [2. Top banner]
 */
.top-banner{
     height: 150px;
     background: url('../images/bg-top-banner.jpg') no-repeat top center;
     position: relative;
     text-align: center;
     color: #fff;
     line-height: 20px;
}
.bg-overlay{
      width: 100%;
      height: 100%;
      position: absolute;
      top: 0;
      left: 0;
      background-color: rgba(0,0,0,0.7);
}
.top-banner .container{
    position: relative;
    padding-top: 35px;
}
.top-banner h1{
    color: red;
    font-weight: bold;
    line-height: auto;
}
.top-banner h2{
    font-weight: bold;
}
.top-banner span{
    font-size: 12px;
    color: #999;
}
.top-banner .btn-close{
    width: 24px;
    height: 24px;
    background: #2d2c2e url("../images/btn-close.png") no-repeat;
    position: absolute;
    top: 0;
    right: 0;
    cursor: pointer;
}


/* ----------------
 [3. Header]
 */
 /*-----------------
 [ 3.1 Nav on top]
 */
.nav-ontop{
  position: fixed;
  top: 0px;
  left: 0px;
  width: 100%;
  padding-bottom: 0px;
  height: 50px;
  background: #eee;
  z-index: 101;
  box-shadow: 0 1px 1px 0 rgba(50, 50, 50, 0.1);
}
.nav-ontop span.notify-right{
  top: 2px;
}
.nav-ontop>.container{
  position: relative;
}
.nav-ontop #box-vertical-megamenus{
    width: 80px;
    padding: 0;
}
.nav-ontop #box-vertical-megamenus .title{
  background: #eee;
  color: #999;
  padding: 0;
  overflow: hidden;
  border-left: 1px solid #eaeaea;
}
.nav-ontop #box-vertical-megamenus .title.active{
  background: #fff;
}
.nav-ontop #box-vertical-megamenus .title .btn-open-mobile {
  margin-right: 15px;
}
.nav-ontop #box-vertical-megamenus .title .title-menu{
  display: none;
}
.nav-ontop #box-vertical-megamenus .vertical-menu-content{
  min-width: 270px;
  position: absolute;
  display: none;
  border-top: none;
  border-bottom: 1px solid #eaeaea;
  border-right: 1px solid #eaeaea;
  padding-bottom: 15px;
  border-left: 1px solid #eaeaea;
}
.nav-ontop #box-vertical-megamenus .vertical-menu-content .vertical-menu-list{
  border-left: none;
}
.nav-ontop #box-vertical-megamenus .vertical-menu-content .all-category{
  margin-left: 20px;
}

#shopping-cart-box-ontop{
  width: 50px;
  height: 50px;
  position: absolute;
  top: 0;
  right: 0;
  display: none;
}
#shopping-cart-box-ontop .fa{
  line-height: 50px;
  cursor: pointer;
  font-size: 20px;
  text-align: center;
  width: 100%;
  color: #999;
}
#shopping-cart-box-ontop .shopping-cart-box-ontop-content{
  position: absolute;
  right: 0;
  top:100%;
}
#shopping-cart-box-ontop:hover .cart-block{
   -webkit-transform: translate(0,0);
  -moz-transform: translate(0,0);
  -o-transform: translate(0,0);
  -ms-transform: translate(0,0);
  transform: translate(0,0);
  opacity: 1;
  visibility: visible;
}

#user-info-opntop{
  width: 50px;
  height: 50px;
  position: absolute;
  top: 0;
  right: 50px;
}
#user-info-opntop a.current-open span{
  display: none;
}
#user-info-opntop a.current-open{
  height: 50px;
  padding-top: 17px;
  width: 50px;
  float: left;
  text-align: center;
}
#user-info-opntop a.current-open:hover .dropdown-menu{
  transform:translateY(0px);
  -webkit-transform:translateY(0px);
  -o-transform:translateY(0px);
  -ms-transform:translateY(0px);
  -khtml-transform:translateY(0px);
  opacity: 1;
  z-index: 2;
}
#user-info-opntop a.current-open:before{
    font: normal normal normal 18px/1 FontAwesome;
    content: "\f007";
    color: #999;
}


#user-info-opntop .dropdown{
  height: 50px;
}
#user-info-opntop .dropdown-menu{
  border-radius: 0;
  border: none;
  top: 48px;
  right: 0;
  left: auto;
  border-top: 2px solid #34495e;
  transition: all 0.4s ease-out 0s;
  -webkit-transition: all 0.4s ease-out 0s;
  -o-transition: all 0.4s ease-out 0s;
  -ms-transition: all 0.4s ease-out 0s;
  opacity: 0;
  display: block;
  transform: translateY(50px);
  -webkit-transform: translateY(50px);
  -o-transform: translateY(50px);
  -ms-transform: translateY(50px);
  -khtml-transform: translateY(50px);
  z-index: 0;
  visibility: hidden;
}
#user-info-opntop .dropdown.open >.dropdown-menu{
  transform:translateY(0px);
  -webkit-transform:translateY(0px);
  -o-transform:translateY(0px);
  -ms-transform:translateY(0px);
  -khtml-transform:translateY(0px);
  opacity: 1;
  z-index: 2;
  visibility: inherit;
}

#form-search-opntop{
  position: absolute;
  top: 0;
  right: 100px;
  height: 50px;
}
#form-search-opntop .form-category{
  display: none;
}
#form-search-opntop form{
  margin-top: 10px;
  border: 1px solid transparent;
  padding-right: 10px;
}
#form-search-opntop .btn-search{
}
#form-search-opntop .btn-search{
}
#form-search-opntop .btn-search:before{
    font: normal normal normal 18px/1 FontAwesome;
      content: "\f002";
      color: #999;
      height: 30px;
      width: 25px;
      display: block;
      padding-top: 6px;
}
#form-search-opntop .input-serach{
  height: 30px;
  padding: 5px 5px 0 15px;
}
#form-search-opntop .input-serach input{
  width: 0px;
  -webkit-transition: width 1s ease-in-out;
  -moz-transition: width 1s ease-in-out;
  -o-transition: width 1s ease-in-out;
  transition: width 1s ease-in-out;
}


#form-search-opntop:hover form{
    border: 1px solid #dfdfdf;
    background: #fff;
}
#form-search-opntop:hover .input-serach input{
  width: 220px;
}

/*-----------------
 [ 3.2 Top header]
 */
.top-header{
    background: #f6f6f6;
}
.top-header .nav-top-links,
.top-header .language ,
.top-header .currency,
.top-header .user-info,
.top-header .support-link,
.top-header .top-bar-social{
    width: auto;
    display: inline-block;
    line-height: 34px;
}
.top-header .top-bar-social .fa{
  line-height: inherit;
}
.top-header .top-bar-social a{
  border:none;
  padding: 0;
  color: #999;
  font-size: 14px;
}
.top-header .support-link{
  float: right;
}
.top-header img{
    display: inline-block;
    vertical-align: middle;
    margin-top: -3px;
    margin-right: 5px;
}
.top-header a{
    border-right: 1px solid #e0e0e0;
    padding-right: 10px;
    margin-left: 10px;
}
.top-header a.first-item{
    margin-left: 0;
}
.top-header a.current-open:after{
      content: "\f107";
      font-family: "FontAwesome";
      font-size: 17px;
      vertical-align: 0;
      padding-left: 15px;
      font-weight: bold;
}
.top-header .dropdown{
  width: auto;
  display: inline-block;
}

.top-header .dropdown-menu{
    border-radius: 0;
    border: none;
    top: 100%;
    left: 0;
    border-top: 2px solid #34495e;
    transition:all 0.4s ease-out 0s;
    -webkit-transition:all 0.4s ease-out 0s;
    -o-transition:all 0.4s ease-out 0s;
    -ms-transition:all 0.4s ease-out 0s;
    opacity: 0;
    display: block;
    transform:translateY(50px);
    -webkit-transform:translateY(50px);
    -o-transform:translateY(50px);
    -ms-transform:translateY(50px);
    -khtml-transform:translateY(50px);
    z-index: 0;
    visibility: hidden;
}
.top-header .dropdown.open >.dropdown-menu{
  transform:translateY(0px);
    -webkit-transform:translateY(0px);
    -o-transform:translateY(0px);
    -ms-transform:translateY(0px);
    -khtml-transform:translateY(0px);
  opacity: 1;
  z-index: 2;
  visibility: inherit;
}
.top-header .dropdown-menu a{
    border: none;
    margin: 0;
    padding: 0;
    padding: 5px 10px;
}
/*-----------------
 [ 3.3 Main header]
 */
.main-header{
    padding: 20px 0 30px 0;
}
.main-header .header-search-box{
    margin-top: 17px;
    padding-left: 80px;
    padding-right: 45px;
    
}
.main-header .header-search-box .form-inline{
    height: 41px;
    border: 1px solid #eaeaea;
    position: relative;
}
.main-header .header-search-box .form-inline .form-category{
    background: #f6f6f6;
    height: 39px;
}
.main-header .header-search-box .form-inline .select2{
    border-right: 1px solid #eaeaea;
    min-width: 152px;
    height: 40px;
}
.main-header .header-search-box .form-inline .select2 .select2-selection{
    border: none;
    background: transparent;
    margin-top: -1px;
}
.select2-container--default .select2-selection--single .select2-selection__rendered{
    line-height: 41px;
}
.select2-container--default .select2-selection--single .select2-selection__arrow{
    top: 6px;
    right: 15px;
}
.select2-dropdown{
    border: 1px solid #eaeaea;
}
.select2-container--open .select2-dropdown {
  left: -1px;
}
.select2-container .select2-selection--single .select2-selection__rendered {
    padding-left: 15px;
}
.main-header .header-search-box .form-inline .input-serach{
    width: calc(100% - 200px);
    
}
.main-header .header-search-box .form-inline .input-serach input{
    border: none;
    padding-left: 15px;
    width: 100%;
}
.main-header .header-search-box .form-inline .btn-search{
    width: 41px;
    height: 41px;
    background: #34495e url("../images/search.png") no-repeat center center;
    border: none;
    border-radius: 0;
    color: #fff;
    font-weight: bold;
    position: absolute;
    top: -1px;
    right: -1px;
}
.main-header .header-search-box .form-inline .btn-search:hover{
  opacity: 0.8;
}

.main-header .shopping-cart-box{
    margin-top: 17px;
    margin-top: 17px;
   padding: 0;
   margin-right: 15px;
   margin-left: -15px;
   line-height:normal;
} 
.main-header .shopping-cart-box:hover .cart-block{
   -webkit-transform: translate(0,0);
  -moz-transform: translate(0,0);
  -o-transform: translate(0,0);
  -ms-transform: translate(0,0);
  transform: translate(0,0);
  opacity: 1;
  visibility: visible;
}
.main-header .shopping-cart-box a.cart-link{
    height: 41px;
    width: 100%;
    border: 1px solid #eaeaea;
    display: block;
    position: relative;
    padding: 2px 41px 0 15px;
}
.main-header .shopping-cart-box a.cart-link:hover:after{
    opacity: 0.8;
}

.main-header .shopping-cart-box a.cart-link .title{
    width: 100%;
    float: left;
    text-transform: uppercase;
    font-weight: bold;
    margin-top: 2px;
}

.main-header .shopping-cart-box a.cart-link:after{
    content: '';
    width: 41px;
    height: 41px;
    background: #34495e url('../images/cart.png') no-repeat center center;
    position: absolute;
    top: -1px;
    right: -1px;
}
.cart-block{
  position: absolute;
  top: 100%;
  right: -1px;
  z-index: 1002;
  max-height: 500px;
  overflow-y:auto;
  background: #FFF;
  color: #666;
  width: 300px;
  opacity: 0;
  -webkit-box-shadow: 0px 4px 7px 0px rgba(50, 50, 50, 0.2);
  -moz-box-shadow: 0px 4px 7px 0px rgba(50, 50, 50, 0.2);
  box-shadow: 0px 4px 7px 0px rgba(50, 50, 50, 0.2);

  -webkit-transition: opacity 0.5s, 
  -webkit-transform 0.5s;
  transition: opacity 0.5s, transform 0.5s;
  -webkit-transform: translate(0,40px);
  -moz-transform: translate(0,40px);
  -o-transform: translate(0,40px);
  -ms-transform: translate(0,40px);
  transform: translate(0,40px);
  opacity: 0;
  display: block;
  visibility: hidden;
}
.cart-block .cart-block-content{
    padding: 20px;
    overflow: hidden;
}
.cart-block .cart-block-content .cart-title{
    text-transform: uppercase;
    font-size: 12px;
}
.cart-block .cart-block-content .cart-block-list{
    
}
.cart-block .cart-block-content  .product-info{
    margin-top: 10px;
    border-bottom: 1px solid #eaeaea;
    display: block;
    overflow: hidden;
    padding-bottom: 10px;
}
.cart-block .cart-block-content  .product-info .p-left{
    width: 100px;
    float: left;
    position: relative;
}
.cart-block .cart-block-content  .product-info .p-left .remove_link{
    position: absolute;
    left: 0;
    top: 0;
}
.cart-block .cart-block-content  .product-info .p-left .remove_link:after{
  content: '';
  background: url("../images/delete_icon.png") no-repeat center center;
  font-size: 0;
  height: 9px;
  width: 9px;
  display: inline-block;
  line-height: 24px;
}
.cart-block .cart-block-content  .product-info .p-right{
    margin-left: 110px;
    line-height: 25px;
}
.cart-block .cart-block-content  .product-info .p-right .p-rice{
      color: #34495e;
}
.cart-block .cart-block-content  .product-info .p-right .change_quantity{
    margin-top: 10px;
}
.cart-block .cart-block-content  .product-info .p-right .change_quantity .blockcart_quantity_down,
.cart-block .cart-block-content  .product-info .p-right .change_quantity .blockcart_quantity_up{
    float: left;
  width: 20px;
  height: 30px;
  border: 1px solid #ccc;
  padding-top: 2px;
  text-align: center;
}
.cart-block .cart-block-content  .product-info .p-right .change_quantity .cart_quantity_input_text {
    width: 60px;
  border: 1px solid #ccc;
  margin-left: -1px;
  margin-right: -1px;
  height: 30px;
  line-height: 100%;
  float: left;
  text-align: center;
}

.cart-block .cart-block-content .toal-cart{
    margin-top: 10px;
}
.cart-block .cart-block-content .toal-cart .toal-price{
    font-size: 18px;
    color: #999;
}
.cart-block .cart-block-content .cart-buttons{
    overflow: hidden;
    width: 100%;
}
.cart-block .cart-block-content .cart-buttons a{
    width: 50%;
    float: left;
    margin-top: 12px;
    text-transform: uppercase;
    font-size: 13px;
    padding: 10px 0;
    text-align: center;
}
.cart-block .cart-block-content .cart-buttons a:hover{
  opacity: 0.8;
}
.cart-block .cart-block-content .cart-buttons a.btn-my-cart{
    background:#eee;
}
.cart-block .cart-block-content .cart-buttons a.btn-check-out{
    background:#34495e;
    color: #fff;
}

span.notify{
    width: 32px;
    height: 22px;
    color: #fff;
    text-align: center;
    position: absolute;
    line-height: normal;
    font-size: 11px;
    padding-top: 3px;
    z-index: 1;
    
}
span.notify-left{
    background: url('../images/notify.png') no-repeat;
    right: 25px;
    top: -8px;
}
span.notify-right{
    background: url('../images/notify-right.png') no-repeat;
    right: 0px;
    top: -7px;
}

/*-----------------
 [ 3.4 Main menu]
 */
.nav-top-menu{
    background: #eee;
}
/*-----------------
 [ 3.4.1 Vertical megamenus]
 */
.box-vertical-megamenus{
    position: absolute;
    left: 15px;
    right: 15px;
    z-index: 1000;
    background: #fff;
}
.box-vertical-megamenus .title{
    background: #000;
	//background: #34495e;
    color: #fff;
    height: 50px;
    line-height: 50px;
    text-transform: uppercase;
    font-weight: bold;
    font-size: 14px;
    padding-left: 20px;
    padding-right: 20px;
    letter-spacing: 1px;
    overflow: hidden;
}
.box-vertical-megamenus .title .btn-open-mobile>.fa{
  line-height: inherit;
}
.box-vertical-megamenus .title .btn-open-mobile{
  font-size: 17px;
  cursor: pointer;
  line-height: 50px;
}
.box-vertical-megamenus .vertical-menu-content{
    border-top: 3px solid #34495e;
    background: #fff;
    display: none;
    padding-bottom: 15px;
}
.home .box-vertical-megamenus .vertical-menu-content{
  display: block;
}
.box-vertical-megamenus .vertical-menu-list{
  border-left: 1px solid #eaeaea;
}
.box-vertical-megamenus .vertical-menu-list li{
  display: block;
  line-height: 34px;
  margin-left: -1px;
  position: relative;
}
.box-vertical-megamenus .vertical-menu-list>li:hover{
  background: #34495e;
}
.box-vertical-megamenus .vertical-menu-list>li:hover>a{
  color: #fff;
  border-color: #34495e;
}
.box-vertical-megamenus .vertical-menu-list>li:hover>a.parent:before{
  color: #fff;
}
.box-vertical-megamenus .vertical-menu-list>li>a{
  padding-left: 20px;
  line-height: 36px;
  display: block;
}
.box-vertical-megamenus .vertical-menu-content ul>li>a.parent:before {
  display: inline-block;
  font-family: FontAwesome;
  font-style: normal;
  font-weight: normal;
  line-height: 1;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  content: "\f105";
  position: absolute;
  top: 10px;
  right: 8px;
  color: #666;
}
.box-vertical-megamenus .vertical-menu-content ul>li>a.parent:after {
  position: absolute;
  background: #fff;
  height: 100%;
  top: 0;
  right: -2px;
  width: 2px;
  content: ' ';
  z-index: 2000;
  opacity: 0;
}
.box-vertical-megamenus .vertical-menu-content ul > li:hover > a.parent:after{
  opacity: 1;
}
.box-vertical-megamenus .vertical-menu-content ul > li.cat-link-orther{
  display: none;
}


.box-vertical-megamenus .vertical-menu-content ul li:hover .vertical-dropdown-menu{
  visibility: visible;
  display: block;
  height: auto;
  -webkit-transform: translate(0,0);
  -moz-transform: translate(0,0);
  -o-transform: translate(0,0);
  -ms-transform: translate(0,0);
  transform: translate(0,0);
  opacity: 1;

}
.box-vertical-megamenus .vertical-menu-content ul li img.icon-menu{
    vertical-align: middle;
    padding-right: 15px;
}

.box-vertical-megamenus .all-category{
    text-align: center;
    margin-top: 14px;
    padding-right: 20px;
}
.box-vertical-megamenus .all-category span{
    height: 40px;
    width: 100%;
    line-height: 39px;
    border: 1px solid #eaeaea;
    text-align: center;
    display: block;
    cursor: pointer;
}
.box-vertical-megamenus .all-category span:hover{
  background: #34495e;
  color: #fff;
  border-color: #34495e;
}
.box-vertical-megamenus .all-category span:after{
    font: normal normal normal 14px/1 FontAwesome;
    content: "\f105";
    font-weight: bold;
    margin-left: 20px;
}

.vertical-dropdown-menu{
  position: absolute;
  top: -15px;
  left: 100%;
  z-index: 900;
  -webkit-transition: opacity 0.5s, -webkit-transform 0.5s;
  transition: opacity 0.5s, transform 0.5s;
  -webkit-transition: all 0.45s ease-out 0s;
  -moz-transition: all 0.45s ease-out 0s;
  -o-transition: all 0.45s ease-out 0s;
  transition: all 0.45s ease-out 0s;
  -moz-transform: translate(100px, 0);
  -webkit-transform: translate(100px, 0);
  transform: translate(100px, 0);
  opacity: 0;
  display: block;
  visibility: hidden;
  -webkit-backface-visibility: hidden;
  height: 0;
  background: #fff;
  border: 1px solid #eaeaea;
}
.vertical-dropdown-menu .vertical-groups{
    padding: 24px 15px;
}
.vertical-dropdown-menu .mega-group-header{
    border-bottom: 1px solid #E8E8E8;
    font-size: 17px;
    margin-bottom: 10px;
    display: table;
    width: 100%;
}
.vertical-dropdown-menu .mega-group-header span{
    padding-bottom: 10px;
    border-bottom: 1px solid #34495e;
    float: left;
    margin-bottom: -1px;
}
.vertical-dropdown-menu .group-link-default{
    border: none!important;
    padding: 0;
    margin: 0;
    padding-bottom: 10px;

}
.vertical-dropdown-menu .group-link-default li{
    border: none!important;
    padding-left: 0!important;
    line-height: 28px!important;
}
.vertical-dropdown-menu .mega-products .mega-product{
    border-right: 1px solid #eaeaea;
    margin-top: 15px;
    line-height: 18px;
}
.vertical-dropdown-menu .mega-products .mega-product:last-child{
    border-right: none;
}
.vertical-dropdown-menu .mega-products .mega-product .product-price .new-price{
    width: auto;
    display: inline-block;
    color: #34495e;
}
.vertical-dropdown-menu .mega-products .mega-product .product-price .old-price{
    color: #999;
    text-decoration: line-through;
    width: auto;
    display: inline-block;
    padding-left: 20px;
}
.vertical-dropdown-menu .mega-products .mega-product .product-star{
  margin-top: 5px;
  color: #ff9900;
}


/*-----------------
 [ 3.4.2 Main menu]
 */
#main-menu{
  padding: 0;
  margin-left: -15px;
}
#main-menu .container-fluid{
  padding: 0;
}
#main-menu .navbar-header{
  display: none;
}
#main-menu .navbar{
  border: none;
  margin: 0;
  background: none;
}
#main-menu .navbar-collapse{
  padding: 0;
}
#main-menu .navbar .navbar-nav>li>a{
  color: #333;
  margin: 15px 0;
  padding: 0;
  border-right: 1px solid #cacaca;
  padding: 0 25px;
  background: transparent;
}
#main-menu .navbar .navbar-nav>li:last-child>a{
  border-right: none;
}
#main-menu .navbar .navbar-nav>li:hover,
#main-menu .navbar .navbar-nav>li.active{
  background: #34495e;
  color: #fff;
}
#main-menu .navbar .navbar-nav>li:hover>a,
#main-menu .navbar .navbar-nav>li.active>a{
  color: #fff;
  border-right: 1px solid transparent;
}
#main-menu .nav, 
#main-menu .collapse,
#main-menu .dropup, 
#main-menu .dropdown {
  position: static;
}
#main-menu .dropdown-menu {
  border-radius: 0;
  min-width: 200px;
  border-top: none;
  left: auto;
  padding: 30px 15px;
  -webkit-transition: opacity 0.5s, -webkit-transform 0.5s;
  transition: opacity 0.5s, transform 0.5s;
  -webkit-transform: translate(0,40px);
  -moz-transform: translate(0,40px);
  -o-transform: translate(0,40px);
  -ms-transform: translate(0,40px);
  transform: translate(0,40px);
  display: block;
  visibility: hidden;
  opacity: 0;
  background: #fff;
}
#main-menu .dropdown-menu.container-fluid{
  padding: 15px 30px;
}

#main-menu .navbar-nav > li:hover .dropdown-menu {
  -webkit-transform: translate(0,0);
  -moz-transform: translate(0,0);
  -o-transform: translate(0,0);
  -ms-transform: translate(0,0);
  transform: translate(0,0);
  opacity: 1;
  visibility: visible;
}
#main-menu .mega_dropdown .block-container {
  padding: 0 15px;
}
#main-menu .mega_dropdown .group_header {
  text-transform: uppercase;
  border-bottom: 1px solid #eaeaea;
  margin-bottom: 10px;
  font-weight: bold;
  font-size: 13px;
  margin-top: 15px;
}

#main-menu .mega_dropdown .group_header:first-child{
  margin-top: 0;
}
#main-menu .mega_dropdown .img_container {
  padding: 0 0 5px;
}
#main-menu .dropdown-menu .block-container .link_container>a{
  line-height: 32px;
}
#main-menu .dropdown-menu .block-container .group_header>a{
  line-height: 32px;
  border-bottom: 1px solid #34495e;
  display: inline-block;
  margin-bottom: -1px;
}
#main-menu li.dropdown>a:after {
  content: "\f107";
  font-family: "FontAwesome";
  font-size: 14px;
  vertical-align: 0;
  padding-left: 7px;
}
#main-menu li.dropdown:before {
  content: "\f0de";
  font-family: "FontAwesome";
  font-size: 15px;
  color: #fff;
  padding-left: 7px;
  position: absolute;
  bottom: -13px;
  right: 48%;
  display: none;
  z-index: 1001;
}
#main-menu li.dropdown:hover:before {
  display: block;
}

/*---------------
[4. Nav menu]
*/
.nav-menu{
    border: none;
}
.nav-menu .container-fluid{
    padding: 0;
}
.nav-menu .navbar-collapse{
   z-index: 10000;
   padding: 0;
   margin: 0;
   border:none;
}
.nav-menu .nav>li:last-child a{
    background-image: none;
}
.nav-menu .nav>li>a{
    padding: 15px 25px;
    background: url('../images/kak.png') no-repeat right center;
}
.nav-menu .navbar-toggle{
    background: url('../images/bar.png') no-repeat left center;
    height: 50px;
    margin: 0;
    padding-right: 3px;
}

.nav-menu .navbar-brand{
    
    font-size: 14px;
    font-weight: bold;
    display: none;
    text-transform: uppercase;
}
.nav-menu .navbar-brand a{
    color: #fff;
}
.nav-menu .toggle-menu{
    float: right;
    line-height: 49px;
    max-height: 50px;
}

.nav-menu .toggle-menu:before{
    font: normal normal normal 17px/1 FontAwesome;
      content: "\f0c9";
      line-height: inherit;
      color: #fff;
}
.floor-elevator{
    width: 70px;
    height: 50px;
    position: absolute;
    top: 0;
    right: 0;
    background: url("../images/floor-elevator.png") no-repeat left center;
    padding-left: 38px;
    padding-right: 22px;
    font-size: 20px;
    font-weight: bold;
    line-height: normal;
    color: #999;
    padding-top: 7px;
}
.floor-elevator .fa{
    font-weight: bold;
}
.floor-elevator .btn-elevator{
    cursor: pointer;
}
.floor-elevator .btn-elevator:hover, .floor-elevator .disabled{
    color: #ccc;
}
.floor-elevator .down{
    margin-top: -6px;
}
/** default nav **/
.nav-menu-default{
    height: 50px;
    background: #34495e;
    border-radius: 0;
    padding: 0;
    margin: 0;
}

.nav-menu-default .navbar-collapse{
    background: #eee;
}
.nav-menu-default ul>li>a:hover,
.nav-menu-default ul>li.active>a,
.nav-menu-default ul>li.selected>a{
    background: #34495e;
    color: #fff;
}

/** read nav **/
.nav-menu-red{
    height: 53px;
    background: #34495e;
    border-radius: 0;
    padding: 0;
    padding-bottom: 3px;
    margin: 0;
}

.nav-menu-red .navbar-collapse{
    background: #fff;
}
.nav-menu-red li a:hover,
.nav-menu-red li.active a,
.nav-menu-red li.selected a{
    background: #34495e;
    color: #fff;
}
/**green nav**/
.nav-menu-green{
    height: 53px;
    background: #339966;
    border-radius: 0;
    padding: 0;
    padding-bottom: 3px;
    margin: 0;
}

.nav-menu-green .navbar-collapse{
    background: #fff;
}
.nav-menu-green li a:hover,
.nav-menu-green li.active a,
.nav-menu-green li.selected a{
    background: #339966;
    color: #fff;
}
/**orange nav**/
.nav-menu-orange{
    height: 53px;
    background: #ff6633;
    border-radius: 0;
    padding: 0;
    padding-bottom: 3px;
    margin: 0;
}

.nav-menu-orange .navbar-collapse{
    background: #fff;
}
.nav-menu-orange li a:hover,
.nav-menu-orange li.active a,
.nav-menu-orange li.selected a{
    background: #ff6633;
    color: #fff;
}
/** blue nav**/
.nav-menu-blue{
    height: 53px;
    background: #3366cc;
    border-radius: 0;
    padding: 0;
    padding-bottom: 3px;
    margin: 0;
}
.nav-menu-blue .navbar-collapse{
    background: #fff;
}
.nav-menu-blue li a:hover,
.nav-menu-blue li.active a,
.nav-menu-blue li.selected a{
    background: #3366cc;
    color: #fff;
}
/**gray nav**/
.nav-menu-gray{
    height: 53px;
    background: #6c6856;
    border-radius: 0;
    padding: 0;
    padding-bottom: 3px;
    margin: 0;
}
.nav-menu-gray .navbar-collapse{
    background: #fff;
}
.nav-menu-gray li a:hover,
.nav-menu-gray li.active a,
.nav-menu-gray li.selected a{
    background: #6c6856;
    color: #fff;
}
/**blue2 nav**/
.nav-menu-blue2{
    height: 53px;
    background: #669900;
    border-radius: 0;
    padding: 0;
    padding-bottom: 3px;
    margin: 0;
}
.nav-menu-blue2 .navbar-collapse{
    background: #fff;
}
.nav-menu-blue2 li a:hover,
.nav-menu-blue2 li.active a,
.nav-menu-blue2 li.selected a{
    background: #669900;
    color: #fff;
}
.show-brand .navbar-brand{
    display: block;
    width: 234px;
    background: #000;
    margin-left: 0!important;
    text-transform: uppercase;
    padding: 0;
    padding-left: 20px;
    line-height: 50px;
    font-size: 16px;
}
.show-brand .navbar-brand a{
    color: #fff;
    line-height: 53px;
}
.show-brand .navbar-brand img{
    vertical-align: middle;
    margin-right: 15px;
}

/*----------------
[5. Home slide]
*/
.header-top-right{
    margin-left: -15px;
    padding: 0;
    border-top: 3px solid #34495e;
}
.header-top-right .homeslider{
  width: 74%;
  float: left;
}
.header-top-right .header-banner{
    width: 26%;
    float: right;
}
.header-top-right .header-banner img{
  width: 100%;
  height: auto;
}
.header-top-right .homeslider img{
    width: 100%;
    height: auto;
}
.header-top-right .homeslider .bx-wrapper .bx-viewport {
  -moz-box-shadow: 0;
  -webkit-box-shadow: 0;
  box-shadow:none;
  border:0;
  left: 0;
  background: #fff;
}
.header-top-right .homeslider .bx-controls-direction .bx-prev,
.header-top-right .homeslider .bx-controls-direction .bx-next{
  background: #34495e;
  text-indent: 0px!important;
  color: #fff;
  font-size: 15px;
  text-align: center;
  line-height: 32px;
  padding-top: 8px;
  -moz-transition: all 0.45s ease;
  -webkit-transition: all 0.45s ease;
  -o-transition: all 0.45s ease;
  -ms-transition: all 0.45s ease;
  transition: all 0.45s ease;
  position: absolute;
  opacity: 0;
  visibility: hidden;
  -ms-transform: translateY(-50%);
  -webkit-transform: translateY(-50%);
  transform: translateY(-50%);
}
.header-top-right .homeslider .bx-controls-direction .bx-prev{
  left: 50%;
}
.header-top-right .homeslider .bx-controls-direction .bx-next{
  right: 50%;
}
.header-top-right .homeslider:hover .bx-controls-direction .bx-next{
  right: 10px;
  opacity: 1;
  visibility: inherit;
}
.header-top-right .homeslider:hover .bx-controls-direction .bx-prev{
  left: 10px;
  opacity: 1;
  visibility: inherit;
}
.header-top-right .homeslider .bx-controls-direction .bx-prev:hover,
.header-top-right .homeslider .bx-controls-direction .bx-next:hover{
  opacity: 0.8;
}
.header-top-right .homeslider .bx-wrapper:hover .bx-prev,.bx-wrapper:hover .bx-next{
    display: block;
}
.header-top-right .homeslider .bx-wrapper .bx-pager, .bx-wrapper .bx-controls-auto {
  position: absolute;
  bottom: 10px;
  width: 100%;
  text-align: right;
  padding-right: 25px;
}
.header-top-right .homeslider .bx-wrapper .bx-pager .bx-pager-item{
    width: 20px;
    height: 20px;
    
    border-radius: 90%;
    margin-right: 5px;
    line-height: 20px;
}
.header-top-right .homeslider .bx-wrapper .bx-pager .bx-pager-item a{
    width: 100%;
    height: 100%;
    float: left;
    background: transparent;
    margin: 0;
    padding: 0;
    text-align: center;
    text-indent: 0px;
    border-radius: 90%;
    color: #666;
    border: 1px solid #999;
    padding-left: 1px;
}
.header-top-right .homeslider .bx-wrapper .bx-pager.bx-default-pager a:hover, .header-top-right .homeslider .bx-wrapper .bx-pager.bx-default-pager a.active {
  background: #34495e;
  color: #fff;
  border: 1px solid #fff;
}
.bx-wrapper{
    margin: 0;
}
/*---------------
[6. Page top]
*/
.page-top{
    margin-top: 30px;
}

/*------------------
[6.1 Latest deals]
*/
.latest-deals{
}

.latest-deals .latest-deal-title{
    height: 54px;
    background: url("../images/latest-deal-title.png") no-repeat left center;
    padding: 0;
    margin: 0;
    line-height: 54px;
    text-transform: uppercase;
    font-size: 16px;
    font-weight: bold;
    padding-left: 52px;
    margin-left: 8px;
}
.latest-deals .product-list li{
    padding-right: 0;
    border:none;
}
.latest-deals .latest-deal-content{
    border: 3px solid #34495e;
    padding: 20px 15px 10px 15px;
}
.latest-deals .count-down-time{
    text-align: center;
    padding-bottom: 15px;
   
}
.latest-deals .count-down-time span{
    height: 24px;
    background: #999;
    color: #fff; 
    width: auto;
    display: inline-block;
    line-height: 24px;
    margin: 0 3px;
    font-size: 18px;
    letter-spacing: 17px;
    padding-left: 7px;
    position: relative;
}
.latest-deals .count-down-time span:after{
    content: '';
    height: 24px;
    width: 2px;
    position: absolute;
    left: 25px;
    top: 0;
    background: #fff;
}
.latest-deals .count-down-time span:before{
    content: '';
    height: 24px;
    width: 11px;
    position: absolute;
    right: 0;
    top: 0;
    background: #fff;
}
.latest-deals .count-down-time span:first-child{
    margin-left: 10px;
}
.latest-deals .count-down-time b{
    margin-left: -8px;
    position: relative;
}
.latest-deals .count-down-time b:after{
    position: absolute;
    right: -1px;
    top: 0;
    content: ':';
}

.latest-deals .product-list .owl-controls{
    width: 100%;
    top: 40%;
}
.latest-deals .product-list li .right-block{
    padding: 0;
}
.latest-deals .content_price{
  width: 100%!important;
}
.latest-deals .colreduce-percentage{
  float: right;
  padding-right: 20px;
}

.latest-deals .owl-prev,
.latest-deals .owl-next{
  -moz-transition: all 0.45s ease;
  -webkit-transition: all 0.45s ease;
  -o-transition: all 0.45s ease;
  -ms-transition: all 0.45s ease;
  transition: all 0.45s ease;
  display: block;
  opacity: 0;
}
.latest-deals .owl-next{
  right: -50px;
}
.latest-deals .owl-prev{
  left: -50px;
}
.latest-deals:hover .owl-prev{
  left: -15px;
  opacity: 1;
}
.latest-deals:hover .owl-next{
  right: -15px;
  opacity: 1;
}

/*-------------------
[6.2. Popular tabs]
*/
.popular-tabs .owl-controls .owl-next{
  top: -46px;
}
.popular-tabs .owl-controls .owl-prev{
  top: -46px;
  left: inherit;
  right: 26px;
}

.popular-tabs .nav-tab{
    margin: 0;
    padding: 0;
}
.popular-tabs .nav-tab{
    margin: 0;
    border-bottom: 1px solid #eaeaea;
    overflow: hidden;
    
}
.popular-tabs .nav-tab li{
    list-style: none;
    display: inline;
    border-bottom: 3px solid #ccc;
    margin-right: 2px;
    height: 45px;
    line-height: 45px;
    float: left;
    padding: 0 15px;
}
.popular-tabs .nav-tab li:hover,.popular-tabs .nav-tab li.active{
    border-bottom: 3px solid #34495e;
}
.popular-tabs .nav-tab li:hover a,.popular-tabs .nav-tab li.active a{
    color: #333;
}
.popular-tabs .nav-tab li a{
    font-size: 16px;
    text-transform: uppercase;
    color: #333;
    font-weight: bold;
}
.popular-tabs .tab-container{
   padding-top: 30px;
}

.popular-tabs .product-list li .left-block{
    
}
.popular-tabs .product-list li{
      border: 1px solid #eaeaea;
      padding-bottom: 10px;
      overflow: hidden;
}
/*--------------------
[7. Services]
*/
.service{
    background:#f6f6f6;
    border: 1px solid #eaeaea;
    padding: 19px 0;
    font-size: 12px;
    margin-top: 20px;
    float: left;
    width: 100%;
}
.service .service-item{
    padding-left: 35px;
    border-right: 1px solid #ccc;
    overflow: hidden;
    
}
.service .service-item .icon{
    width: 40px;
    height: 40px;
    float: left;
}
.service .service-item .info{
    padding-left: 15px;
    margin-left: 40px;
    padding-top: 2px;
}
.service .service-item h3{
    margin: 0;
    padding: 0;
    text-transform: uppercase;
}
.service .service-item:last-child{
    border-right: none;
}


/*----------------
[8. Product]
*/
.product-list li{
}
.product-list li:hover .add-to-cart{
    bottom: 0;
}
.product-list li:hover .quick-view a.heart{
    margin-left: 0;
}
.product-list li:hover .quick-view a.compare{
    margin-left: 0;
}
.product-list li:hover .quick-view a.search{
    margin-left: 0;
}
.product-list li:hover .quick-view a.plus{
    margin-left: 0;
}
.product-list li .left-block{
    position: relative;
    overflow: hidden;
    padding: 10px 10px 0;
}
.product-list li .left-block a{
  display: block;
  overflow: hidden;
}
.product-list li .left-block img{
  transition:all 0.5s;
  webkit-transform: scale(1,1);
  -moz-transform: scale(1,1);
  -o-transform: scale(1,1);
  transform: scale(1,1);
  margin: 0 auto;
}
.product-list li:hover img{
    
  -webkit-transform: scale(1.2,1.2);
  -webkit-transform-origin: top right;
  -moz-transform: scale(1.2,1.2);
  -moz-transform-origin: top right;
  -o-transform: scale(1.2,1.2);
  -o-transform-origin: top right;
  transform: scale(1.2,1.2);
  transform-origin: top right;
}
.product-list li .right-block{
    padding: 0 15px;
    margin-top: 15px;
}
.product-list li .quick-view{
    position: absolute;
    right: 20px;
    top: 20%;
    width: 32px;
    overflow: hidden;
}
.product-list li .quick-view a{
    width: 32px;
    height: 32px;
    float: left;
    border-radius: 90%;
    margin-top: 5px;
    text-align: center;
    line-height: 32px;
    color: #fff;
}
.product-list li .quick-view a.heart{
    -webkit-transition: margin-left 0.4s ease 0.4s;
    -moz-transition: margin-left 0.4s ease 0.4s;
    -ms-transition: margin-left 0.4s ease 0.4s;
    -o-transition: margin-left 0.4s ease 0.4s;
    transition: margin-left 0.4s ease 0.4s;
    margin-left: 200px;
    background:  rgba(0,0,0,0.4);
    
}
.product-list li .quick-view a.heart:before{
    font: normal normal normal 14px/1 FontAwesome;
    content: "\f08a";
    font-weight: bold;
}
.product-list li .quick-view a.compare{
    background:  rgba(0,0,0,0.4);
    -webkit-transition: margin-left 0.3s ease 0.3s;
    -moz-transition: margin-left 0.3s ease 0.3s;
    -ms-transition: margin-left 0.3s ease 0.3s;
    -o-transition: margin-left 03s ease 0.3s;
    transition: margin-left 0.3s ease 0.3s;
    margin-left: 200px;
}
.product-list li .quick-view a.compare:before{
    font: normal normal normal 14px/1 FontAwesome;
    content: "\f012";
}

.product-list li .quick-view a.plus{
    background:  rgba(0,0,0,0.4);
    -webkit-transition: margin-left 0.2s ease 0.2s;
    -moz-transition: margin-left 0.2s ease 0.2s;
    -ms-transition: margin-left 0.2s ease 0.2s;
    -o-transition: margin-left 0.2s ease 0.2s;
    transition: margin-left 0.2s ease 0.2s;
    margin-left: 200px;
}
.product-list li .quick-view a.plus:before{
    font: normal normal normal 14px/1 FontAwesome;
    content: "\f07a";
}

.product-list li .quick-view a.search{
    background:  rgba(0,0,0,0.4);
    -webkit-transition: margin-left 0.2s ease 0.2s;
    -moz-transition: margin-left 0.2s ease 0.2s;
    -ms-transition: margin-left 0.2s ease 0.2s;
    -o-transition: margin-left 0.2s ease 0.2s;
    transition: margin-left 0.2s ease 0.2s;
    margin-left: 200px;
}
.product-list li .quick-view a.search:before{
    font: normal normal normal 14px/1 FontAwesome;
    content: "\f002";
}

.product-list li .quick-view a:hover{
    background-color:#34495e ;
}
.product-list li .add-to-cart{
    width: 100%;
    position: absolute;
    left: 0;
    right: 0;
    bottom: -50px;
    width: 100%;
    background-color: rgba(0,0,0,0.4);
    color: #fff;
    text-align: center;
    line-height: 50px;
    -moz-transition: all 0.45s ease;
    -webkit-transition: all 0.45s ease;
    -o-transition: all 0.45s ease;
    -ms-transition: all 0.45s ease;
    transition: all 0.45s ease;

}
.product-list li .add-to-cart:hover{
  background-color: #34495e;
}
.product-list li .add-to-cart a{
    background: url("../images/add-cart.png") no-repeat left center;
    height: 32px;
    line-height: 32px;
    color: #fff;
    width: auto;
    padding-left: 40px;
    display: inline-block;
    vertical-align: middle;
    
}
.product-list li .product-name{
    padding-bottom: 5px;
}
.product-list li .product-info{
    padding: 0 5px;
}

.product-list li .content_price{
    width: auto;
    display: inline-block;
}
.product-list li .product-price{
    font-size: 18px;
    color: #34495e;
}
.product-list li .old-price{
    text-decoration:line-through;
    margin-left: 11px;
    line-height: 25px;
    color: #666;

}
.product-list li .colreduce-percentage{
  line-height: 28px;
}
.product-list li .group-price{
  position: absolute;
  position: absolute;
  top: 10px;
  left: 10px;
  height: auto;
}
.product-list li .group-price .price-percent-reduction{
    width: 36px;
    height: 36px;
    background: #ff6600;
    color: #fff;
    float: left;
    border-radius: 90%;
    line-height: normal;
    text-align: center;
    font-size: 12px;
    padding-top: 5px;
    margin-bottom: 5px;
}
.product-list li .price-percent-reduction2{
  width: 52px;
  height: 44px;
  background: url("../images/price-percent-br.png") no-repeat center center;
  color: #fff;
  line-height: normal;
  text-align: center;
  font-size: 14px;
  position: absolute;
  top: 10px;
  right: 0;
  font-family: 'Arial Narrow', Arial, sans-serif;
  padding-left: 5px;
  padding-top: 2px;
}

.product-list li .group-price .product-new{
    color: #fff;
    float: left;
    line-height: 22px;
    text-align: center;
    font-size: 12px;
    text-transform: uppercase;
    padding:0 10px;
    background: #ffc000;
    height: 22px;
}
.product-list li .group-price .product-sale{
    color: #fff;
    float: left;
    line-height: 22px;
    text-align: center;
    font-size: 12px;
    text-transform: uppercase;
    padding: 0px 10px;
    background: #ff4318;
    height: 22px;
}

.product-list li .product-star{
    width: auto;
    float: right;
    color: #ff9900;
    text-align: right;
     display: inline-block;
     padding-top: 5px;
     font-size: 13px;
}

/*------------------
[9. Owl carousel]
*/
.owl-controls{
    
}
.owl-controls .owl-prev{
    position: absolute;
    left: 0;
    top: 50%;
    -ms-transform: translateY(-50%);
    -webkit-transform: translateY(-50%);
    transform: translateY(-50%);
}
.owl-controls .owl-next{
    position: absolute;
    right: 0;
    top: 50%;
    -ms-transform: translateY(-50%);
    -webkit-transform: translateY(-50%);
    transform: translateY(-50%);
}
.owl-controls .owl-prev,
.owl-controls .owl-next{
    background: #eaeaea;
    width: 24px;
    height: 24px;
    color: #ccc;
    text-align: center;
    padding-top: 4px;
}
.owl-controls .owl-prev:hover,
.owl-controls .owl-next:hover{
    background: #34495e;
    color: #fff;
}
.owl-controls .owl-prev .fa,
.owl-controls .owl-next .fa{
    font-weight: bold;
}

/*-----------------
[10. Banner advertisement]
*/
.banner a{
  width: 100%;
  overflow: hidden;
  height: auto;
  display: block;
  position: relative;
}
.banner a:before{
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(255,255,255,0.5);
  content: '';
  -webkit-transition: -webkit-transform 0.6s;
  transition: transform 0.6s;
  -webkit-transform: scale3d(1.9,1.4,1) rotate3d(0,0,1,45deg) translate3d(0,300%,0);
  transform: scale3d(1.9,1.4,1) rotate3d(0,0,1,135deg) translate3d(0,300%,0);
}
.banner a:hover:before{
   -webkit-transform: scale3d(1.9,1.4,1) rotate3d(0,0,1,45deg) translate3d(0,-300%,0);
  transform: scale3d(1.9,1.4,1) rotate3d(0,0,1,135deg) translate3d(0,-300%,0);
}

.banner-img{
    position: relative;
}
.banner-img a:before{
    content: "";
    position: absolute;
    top: 15px;
    left: 15px;
    bottom: 15px;
    right: 15px;
    z-index: 9;
    border-top: 1px solid rgba(255, 255, 255, 0.8);
    border-bottom: 1px solid rgba(255, 255, 255, 0.8);
    transform: scale(0, 1);
}
.banner-img a:after{
    content: "";
    position: absolute;
    top: 15px;
    left: 15px;
    bottom: 15px;
    right: 15px;
    z-index: 9;
    border-left: 1px solid rgba(255, 255, 255, 0.8);
    border-right: 1px solid rgba(255, 255, 255, 0.8);
    transform: scale(1, 0);
}
.banner-img a:hover:before,.banner-img a:hover:after{
    transform: scale(1);
  -webkit-transition: all 0.3s ease-out 0s;
  -moz-transition: all 0.3s ease-out 0s;
  -o-transition: all 0.3s ease-out 0s;
  transition: all 0.3s ease-out 0s;
}


/*-----------------
[11. Page content]
*/
.content-page{
    background: #eaeaea;
    margin-top: 30px;
    padding-bottom: 30px;
}
/*------------------
[11.1 Category featured]
*/
.category-featured{
    margin-top: 30px;
}
/*------------------
[11.1.1 Banner featured]
*/
.category-banner{
    overflow: hidden;
}
.category-banner .banner{
    padding: 0;
    overflow: hidden;
}
.featured-text{
    position: absolute;
    right: -5px;
    top: -5px;
    background: url('../images/featured2.png') no-repeat;
    width: 75px;
    height: 75px;
    z-index: 100;
}
.featured-text span{
    color: #fff;
    text-transform: uppercase;
    font-size: 12px;
    width: 100%;
    height: 20px;
    line-height: 24px;
    float: left;
    margin-top: 24px;
    margin-left: 17px;
    -webkit-transform: rotate(45deg);
    -moz-transform: rotate(45deg);
    -o-transform: rotate(45deg);
    -ms-transform: rotate(45deg);
    transform: rotate(45deg);
    color: #003366;
    font-weight: bold;
    text-indent: -999px;
}
/*------------------
[11.1.2 Product featured]
*/
.product-featured{
    margin-top: 10px;
    background: #fff;
}
.product-featured .product-featured-content{
    width: 100%;
    float: right;
}
.product-featured .product-featured-content .product-featured-list{
      margin-left: 234px;
      overflow: hidden;
}
.product-featured .banner-featured{
    width: 234px;
    float: left;
    margin-right: -100%;
    position: relative;
}
.product-featured .product-list li{
    border-right: 1px solid #eaeaea;
    padding-bottom: 10px;
    min-height: 350px;
}
.product-featured .product-list .owl-stage .active:last-child li{
    border: none;
}

.product-featured .owl-prev,
.product-featured .owl-next{
  -moz-transition: all 0.45s ease;
  -webkit-transition: all 0.45s ease;
  -o-transition: all 0.45s ease;
  -ms-transition: all 0.45s ease;
  transition: all 0.45s ease;
  opacity: 0;
  visibility: hidden;
}
.product-featured .owl-next{
  right: -50px;
}
.product-featured .owl-prev{
  left: -50px;
}
.product-featured .owl-carousel:hover .owl-prev{
    left: 0;
    opacity: 1;
    visibility: inherit;
}
.product-featured .owl-carousel:hover .owl-next{
    right: 0;
    opacity: 1;
    visibility: inherit;
}

/*
[11.2 Banner bootom]
*/
.banner-bottom{
    margin-top: 30px;
}

.owl-carousel .item{
    background: #eaeaea;
}



/*----------------
[12. Brand showcase]
*/
.brand-showcase{
    margin-top: 30px;
}
.brand-showcase .brand-showcase-title{
    font-size: 16px;
    text-transform: uppercase;
    color: #333;
    font-weight: bold;
    border-bottom: 3px solid #34495e;
    line-height: 40px;
    padding-left: 10px;
}
.brand-showcase-box{
   border-bottom: 1px solid #eaeaea;
   border-left: 1px solid #eaeaea;
   border-right: 1px solid #eaeaea;
    padding-bottom: 30px;
}
.brand-showcase-box .brand-showcase-logo{
}
.brand-showcase-box .brand-showcase-logo .owl-item:last-child{
    margin-right: 0!important;
}
.brand-showcase-box .brand-showcase-logo li{
    background: #eaeaea;
    cursor: pointer;
}
.brand-showcase-box .brand-showcase-logo li:hover,.brand-showcase-box .brand-showcase-logo li.active{
    background: #fff;
}

.brand-showcase-box .brand-showcase-logo .owl-controls .owl-prev, 
.brand-showcase-box .brand-showcase-logo .owl-controls .owl-next {
  top: -18px;
}
.brand-showcase-box .brand-showcase-logo .owl-controls .owl-next{
    
}
.brand-showcase-box .brand-showcase-logo .owl-controls .owl-prev{
    left: inherit;
    right: 26px;
}
.brand-showcase-box .brand-showcase-logo .owl-controls .fa {
  font-weight: bold;
}

.brand-showcase-content .brand-showcase-content-tab{
    display: none;
}
.brand-showcase-content .active{
    display: block;
}
.trademark-info {
    padding-left: 45px!important;
}

.trademark-info .trademark-logo,
.trademark-info .trademark-desc{
    border-bottom: 1px dotted #999999;
    padding-bottom: 20px
}
.trademark-info .trademark-logo{
    margin-top: 30px;
}
.trademark-info .trademark-desc{
    line-height: 18px;
    margin-top: 20px;
}
.trademark-info .trademark-link{
    line-height: 30px;
    text-transform: uppercase;
    border: 1px solid #999;
    padding: 0 10px 0 15px;
    margin-top: 20px;
    float: left;
}
.trademark-info .trademark-link:after{
      font: normal normal normal 14px/1 FontAwesome;
        content: "\f0da";
        padding-left: 12px;
}
.trademark-product{
    padding-right: 45px;
}
.trademark-product .product-item{
    margin-top: 30px;
}
.trademark-product .image-product{
    float: left;
    width: 40%
}

.trademark-product .info-product{
    float: right;
    width: 60%;
    padding-left: 20px;
    line-height: 35px;
    padding-top: 20px;

}
.trademark-product .info-product .product-price{
    font-size: 18px;
    color: #F36;
    font-weight: bold;
}
.trademark-product .info-product .product-star{
    color: #ff9900;
    font-size: 13px;
}
.trademark-product .info-product .quick-view a{
  width: 25px;
  height: 25px;
  display:inline-block;
  background: rgba(0,0,0,0.7);
  color: #fff;
  text-align: center;
}
.trademark-product .info-product .btn-view-more{
  height: 26px;
  text-align: center;
  line-height: 24px;
  padding: 0 15px;
  display: inline-block;
  border:  1px solid #eaeaea;
}
.trademark-product .info-product .btn-view-more:hover{
  background: #34495e;
  color: #fff;
}
.trademark-product .info-product .quick-view a .fa{
  text-align: center;
  line-height: 25px;
}
.trademark-product .info-product .quick-view a:hover{
    background: #34495e;
}


/*------------------
[12. Hot categories]
*/
#hot-categories{
    margin-top: 30px
}
.group-title-box {
    margin-bottom: 20px;
}
.group-title {
    font-size: 16px;
    border-bottom: 1px solid #e1e1e1;
    font-weight: bold;
    padding-bottom: 7px;

}
.group-title span {
    border-bottom: 3px solid #34495e;
    text-transform: uppercase;
    padding: 5px 10px;
}
.cate-box{
  padding-bottom: 20px;
}
.cate-box .cate-tit {
    background: #f4f4f4; 
    height: 110px;
    overflow: hidden;
}
.cate-box .cate-tit .div-1{
    width: 46%;
    float: left;
    padding-left: 25px;
    padding-right: 15px;
}

.cate-name-wrap {
    display: table;
    margin-bottom: 18px;
}
.cate-box .cate-name {
    font-size: 16px;
    font-weight: bold;
    height: 55px;
    display:table-cell;
    vertical-align: bottom;
}
.cate-box .cate-link {
    padding: 4px 4px 3px 7px;
    background: #999999;
    text-decoration: none;
    color: #fff;
}
.cate-box .cate-link:hover {
    background: #34495e!important;
}

.cate-link span {
    padding-right: 12px;
    background: url('../data/cate-readmore-arrow.png') right 2px top 50%  no-repeat;
   text-transform: uppercase;
   font-size: 10px;
   line-height: 20px;
}
.cate-content{
    padding-top:10px;
    padding-bottom: 10px;
}
.cate-content ul{
    list-style: none;
}
.cate-content ul li a:before{
  display: inline-block;
  font-family: FontAwesome;
  content: "\f105";
  padding: 0 10px;
  font-weight: bold;
}
.cate-box .div-2 {
    width: 54%; 
    float: left;
    padding-top: 10px;
    overflow: hidden;
}


/*
[14. footer]
*/
#footer {
    background: #eee;
}

/** add-box **/
#address-list .tit-name{
    float: left;
    font-weight: bold;
    width: 70px;
    padding-right: 5px;
}
#address-list {
    margin-top: 18px;
}
#address-list .tit-contain {
      display: flex;
}
/** #introduce-box **/
#introduce-box {
    margin-top: 40px;
}
.introduce-title {
    text-transform: uppercase;
    font-size: 16px;
    list-style: none;
    font-weight: bold;
    margin-bottom: 8px;
}
.introduce-list li{
    padding-top: 2px;
    padding-bottom: 2px;
}

.introduce-list {
    padding-left: 16px;
    list-style: inherit;
}
/** contact-box **/
#mail-box {
    margin-bottom: 20px;
}
#mail-box input{
    height: 30px;
  background: #fff;
  width: 100%;
  padding-left: 10px;
}
#mail-box .btn {
    font-weight: bold;
    color: #fff;
    height: 30px;
    border-radius: 0;
    background: #34495e;
    border: none;
    outline: none;
}
#mail-box .btn:hover{
    z-index: 0;
    opacity: 0.8;
    transition: 0.3s;
}

/** /#introduce-box **/
/** #trademark-box **/
#trademark-text-box {
    font-size: 13px;
}
#trademark-list  {
  list-style: outside none none;
  border-top: 1px solid #E1E1E1;
  border-bottom: 1px solid #E1E1E1;
  margin-bottom: 30px;
  display: table;
  width: 100%;
  margin-top: 30px;
}
#trademark-list li{
    display: inline-block;
    padding: 10px 11px;
}
#trademark-list li:last-child{
    padding-right: 0;
}
#trademark-list #payment-methods{
    display: table-cell;
    vertical-align: middle;
    text-transform: uppercase;
    font-weight: bold;
    padding-left: 0px;
}
.trademark-text-tit {
    text-transform: uppercase;
    font-size: 13px;
    font-weight: bold;
}
.trademark-list{
    list-style: none;
    margin-bottom: 10px;
}
.trademark-list li{
    display: inline;
    padding: 0 7px 0 5px;
    border-right: 1px solid #666666;
}
.trademark-list li:first-child{
    border-right: none;
    padding-right: 0;
    padding-left: 0;
}
.trademark-list li:last-child{
    border-right: 0;
    padding-right: 0;
}
.social-link a:hover{
  opacity: 0.8;
}
.social-link .fa{
    width: 30px;
    height: 30px;
    color: #fff;
    line-height: 30px;
    text-align: center;
}
.social-link .fa-facebook{
    background: #415a99;
}

.social-link .fa-pinterest-p{
    background: #cb222a;
}
.social-link .fa-vk{
    background: #5b7fa6;
}

.social-link .fa-twitter{
    background: #00caff;
}

.social-link .fa-google-plus{
    background: #da4735;
}

/** #footer-menu-box **/
#footer{
  background: #eaeaea;
}
#footer-menu-box {
    border-top: 1px solid #E1E1E1;
    margin-top: 10px;
    padding-top: 20px;
    margin-bottom: 20px;
}

.footer-menu-list{
    list-style: none;
    text-align: center;
    margin-bottom: 5px;
}
.footer-menu-list li{
    display: inline;
    padding: 0 7px 0 5px;
    border-right: 1px solid #0066cc;
}
.footer-menu-list li:last-child{
    border-right: none;
}

.footer-menu-list li a{
    color: #0066cc;
}

.footer-menu-list li a:hover{
    text-decoration: underline;
    transition: all 0.3s;
}
.scroll_top{
    width: 34px;
  height: 34px;
  position: fixed;
  display: none;
  font-size: 0;
  z-index: 9999;
  right: 10px;
  bottom: 32px;
  background: #666;
  display: none;
}
.scroll_top:hover{
  background: #F36;
}

.scroll_top:before {
  content: "\f106";
  font-family: "FontAwesome";
  font-size: 14px;
  color: #fff;
  text-align: center;
  width: 34px;
  height: 34px;
  line-height: 34px;
  display: block;
}


/*------------------
[15. Breadcrumb]
*/
.breadcrumb{
  background: none;
  padding: 0;
  margin: 0;
  padding-bottom: 17px;
  line-height: normal;
}
.breadcrumb .navigation-pipe:before{
    content: "\f105";
  font-size: 14px;
  display: inline-block;
  text-align: right;
  width: 6px;
  color: #666;
  font-family: "FontAwesome";
  padding: 0 15px;
}

/*------------------
[16. Columns]
*/
#columns{
  padding-top: 16px;
  padding-bottom: 30px;
}

/*--------------
16.1 Left column
*/
#left_column .left-module{
  margin-bottom: 30px;
  overflow: hidden;
}
#left_column .left-module .owl-dots{
  bottom: 5px;
}
#left_column .left-module:last-child{
  margin-bottom: 0;
}
#left_column .left-module img{
  margin: 0 auto;
}
#left_column .block{
  border: 1px solid #eaeaea;
}
#left_column .block .title_block{
  font-size: 16px;
  font-weight: bold;
  border-bottom: 1px solid #eaeaea;
  padding-left: 28px;
  text-transform: uppercase;
  padding-top: 11px;
  padding-bottom: 12px;
}
#left_column .block .block_content{
  padding:  15px 20px;
}
.layered .layered_subtitle{
  color: #666;
  font-size: 16px;
  padding-bottom: 4px;
  text-transform: uppercase;
}
.layered .layered-content{
  border-bottom: 1px solid #eaeaea;
  padding-bottom: 15px;
  margin-bottom: 15px;
  padding-top: 15px;
}
.layered .layered-content:last-child{
    border-bottom: none;
  padding-bottom: 0;
  margin-bottom: 0;
}
.layered .layered-content:first-child{
  
}
.layered-category .layered-content{
  border-bottom: none;
  padding-bottom: 0;
  padding-top: 0;
  margin-bottom: 0;
}

.tree-menu li{
  line-height: 24px;
}
.tree-menu li:hover>a,
.tree-menu li.active>a,
.tree-menu li:hover>span:before,
.tree-menu li.active>span:before
{
  color: #34495e;
}

.tree-menu > li >span:before{
  content: "\f105";
  font-size: 14px;
  display: inline-block;
  text-align: right;
  color: #666;
  font-family: "FontAwesome";
  padding-right: 12px;
  color: #ccc;
  font-weight: bold;
  cursor: pointer;
}
.tree-menu > li >span.open:before{
  content: "\f107";
  font-size: 14px;
  display: inline-block;
  text-align: right;
  color: #666;
  font-family: "FontAwesome";
  padding-right: 12px;
  color: #ccc;
  font-weight: bold;
  cursor: pointer;
}

.tree-menu > li > ul{
  padding-left: 17px;
  display: none;
}
.tree-menu > li > ul > li{
  border-bottom: 1px dotted #eaeaea;
}
.tree-menu > li > ul > li:last-child{
  border: none;
}
.tree-menu > li > ul > li >span:before{
    content: "\f0da";
  font-size: 14px;
  display: inline-block;
  text-align: right;
  color: #666;
  font-family: "FontAwesome";
  padding-right: 12px;
  color: #ccc;
}

/** FILTER PRICE **/
.layered-filter-price .amount-range-price{
  padding:15px 0;
}
.layered-filter-price .slider-range-price{
  height: 7px;
  background: #34495e;
  border: none;
  border-radius: 0;
}
.layered-filter-price .slider-range-price .ui-widget-header{
  background: #ccc;
  height: 7px;
}
.layered-filter-price .slider-range-price .ui-slider-handle{
  border: none;
  border-radius: 0;
  background: url("../images/range-icon.png") no-repeat;
  cursor: pointer;
}

.check-box-list{
  overflow: hidden;
}
.check-box-list li{
  line-height: 24px;
}
.check-box-list label{
  display: inline-block;
  cursor: pointer;
  line-height: 12px;
}
.check-box-list label:hover{
  color: #34495e;
}
.check-box-list input[type="checkbox"]{
  display: none;
}
.check-box-list input[type="checkbox"] + label span.button {
      display:inline-block;
      width:12px;
      height:12px;
      margin-right: 13px;
      background: url("../images/checkbox.png") no-repeat;
      padding: 0;
      border: none;
}
.check-box-list input[type="checkbox"]:checked + label span.button{
    background: #34495e url("../images/checked.png") no-repeat center center;
    

}
.check-box-list input[type="checkbox"]:checked + label{
  color: #34495e;
}
.check-box-list label span.count{
  color: #a4a4a4;
  margin-left: 2px;
}

.filter-color ul{
  padding: 0;
  margin: 0;
  overflow: hidden;
  margin-left: -5px;
  margin-right: -5px;
  margin-top: -5px;
}
.filter-color li{
  display: inline;
  padding: 0;
  margin: 0;
  line-height: normal;
  float: left;
  padding: 5px;
}
.filter-color li label{
  border: 1px solid #eaeaea;
  width: 20px;
  height: 20px;
  padding-top: 6px;
  padding-left: 6px;
  float: left;
}
.filter-color li input[type="checkbox"] + label span.button{
  background: none;
  margin: 0;
}
.filter-color li input[type="checkbox"]:checked + label{
    border-color: #34495e;
}
.filter-size{
  max-height: 200px;
  overflow-y:auto; 
}
.filter-size li{
  width: 50%;
  float: left;
}
.owl-controls .owl-dots{
  position: absolute;
  left: 0;
  bottom: 0;
  text-align: center;
  width: 100%;
}
.owl-controls .owl-dots .owl-dot{
  width: 14px;
  height: 14px;
  background: #adadad;
  display: inline-block;
  margin: 0 6px;
  border-radius: 90%;
}
.owl-controls .owl-dots .owl-dot.active{
  background: #34495e;
}

/** special-product**/
.products-block{
  overflow: hidden;
}
.products-block .products-block-left{
  width: 75px;
  float: left;
}
.products-block .products-block-right{
  margin-left: 85px;
}
.products-block .product-price{
  font-size: 18px;
  color: #34495e;
  font-weight: bold;
  line-height: 35px;
}
.products-block .product-star{
  color: #ff9900;
}

.products-block-bottom{
  padding-top: 15px;
}
.products-block .link-all{
  height: 35px;
  width: 120px;
  border: 1px solid #34495e;
  line-height: 33px;
  font-size: 14px;
  color: #34495e;
  display: block;
  margin: 0 auto;
  text-align: center;
  clear: both;
  background: #34495e;
  color: #fff;
}
.products-block .link-all:hover{
  opacity: 0.8;
}
.products-block .link-all:after{
    font: normal normal normal 13px/1 FontAwesome;
    content: "\f101";
    margin-left: 10px;
}
.best-sell li{
  border-bottom: 1px solid #eaeaea;
  padding: 20px 0;
}
.best-sell li:first-child{
  padding-top: 0;
}
.best-sell li:last-child{
  padding-bottom: 0;
  border-bottom: none;
}
.owl-best-sell{
  padding-bottom: 35px;
}
#left_column .block .block_content.product-onsale{
  padding: 15px 20px;
}
#left_column .block .block_content.product-onsale .product-list{
  padding-bottom: 25px;
}

#left_column .block .block_content.product-onsale .product-list .product-container{
  border: none;
}
#left_column .block .block_content.product-onsale .product-list .product-container .right-block{
  padding: 0;
}

.product-bottom{
  padding-top: 10px;
  text-align: center;
}
.btn-add-cart{
    height: 35px;
    width: auto;
    line-height: 35px;
    font-size: 14px;
    color: #fff;
    display: inline-block;
    margin: 0px auto;
    text-align: center;
    clear: both;
    padding-left: 15px;
    padding-right: 15px;
    background: #F36;
}

.btn-add-cart:hover{
  color: #fff;
  opacity: 0.8;
}
.btn-add-cart:before{
    width: 16px;
    height: 100%;
    float: left;
    background:url("../images/cart.png") no-repeat scroll left center;
    content: " ";
    margin-right: 15px;
}

/** tags **/
.tags{
  line-height: 26px;
}
.tags span{
  padding: 0 5px;
}
.tags .level1{
  font-size: 12px;
}
.tags .level2{
  font-size: 16px;
}
.tags .level3{
  font-size: 18px;
}
.tags .level4{
  font-size: 20px;
}
.tags .level5{
  font-size: 24px;
}

/** testimonials **/
.testimonials{
  padding-bottom: 38px;
}
.testimonials .client-mane{
  text-transform: uppercase;
  text-align: center;
  font-weight: 600;
}
.testimonials .client-avarta {
  margin-top: 10px;
  text-align: center;
}
.testimonials .client-avarta img{
  width: 110px;
  height: 110px;
  border: 3px solid #eaeaea;
  border-radius: 90%;
  margin: 0 auto;
}

/*--------------------
[16.2 Center column]
*/

.category-slider .owl-controls .owl-prev, 
.category-slider .owl-controls .owl-next {
  background: #aaa;
  width: 40px;
  height: 40px;
  color: #fff;
  text-align: center;
  padding-top: 12px;
  -moz-transition: all 0.45s ease;
  -webkit-transition: all 0.45s ease;
  -o-transition: all 0.45s ease;
  -ms-transition: all 0.45s ease;
  transition: all 0.45s ease;
  position: absolute;
  visibility: hidden;
  opacity: 0;

}
.category-slider .owl-controls .owl-prev:hover, 
.category-slider .owl-controls .owl-next:hover{
  background: #34495e;
}
.category-slider .owl-controls .owl-prev{
  left: 50%;
}
.category-slider .owl-controls .owl-next{
  right: 50%;
}
.category-slider:hover .owl-controls .owl-next{
    right: 0;
    visibility: inherit;
    opacity: 1;
}
.category-slider:hover .owl-controls .owl-prev{
    left: 0;
    visibility: inherit;
    opacity: 1;
}

/** subcategories **/
.subcategories{
  border: 1px solid #e4e4e4;
  margin-top: 20px;
}
.subcategories ul{
  overflow: hidden;
}
.subcategories li {
  display: inline;
  float: left;
  
}
.subcategories li a{
  height: 34px;
  float: left;
  line-height: 34px;
  padding: 0 40px;
  font-size: 13px;
}
.subcategories li a:hover{
  background: #f2f2f2;
  color: #666;
}
.subcategories li.current-categorie{
    position: relative;
}
.subcategories li.current-categorie:after{

    font: normal normal normal 14px/1 FontAwesome;
      content: "\f0da";
      position: absolute;
      right: -5px;
      top: 50%;
      -ms-transform: translateY(-50%);
      -webkit-transform: translateY(-50%);
      transform: translateY(-50%);
      color: #000;

}
.subcategories li.current-categorie a{
  background: #000;
  color: #fff;
  font-size: 14px;
  font-weight: bold;
}

.view-product-list{
  margin-top: 20px;
  position: relative;
}
.page-heading{
  height: 41px;
  border-bottom: 1px solid #eaeaea;
  line-height: 40px;
  position: relative;
  font-size: 24px;
}
.page-heading span.page-heading-title{
  border-bottom: 3px solid #34495e;
  position: absolute;
  bottom: -1px;
  padding: 0 12px;
}
.page-heading span.page-heading-title2{
  text-transform: uppercase;
}
.no-line{
  border-bottom: none;
}
.view-product-list .display-product-option{
  position: absolute;
  top: 0;
  right: 0;
}

/** botton view option **/
.display-product-option{
    width: 63px;
    height: 30px;
}
.display-product-option li.view-as-grid span{
  width: 30px;
  height: 30px;
  display: block;
  float: left;
  cursor: pointer;
  text-indent: -9999px;
  background: url("../images/grid-view-bg.png") 0 0 #666;
  border: none;
  float: left;
}
.display-product-option li.view-as-list span{
  width: 30px;
  height: 30px;
  display: block;
  float: left;
  cursor: pointer;
  text-indent: -9999px;
  background: url("../images/list-view-bg.png") 0 0 #666;
  border: none;
  float: right;
}
.display-product-option li.selected span,
.display-product-option li:hover span
{
  background-color: #34495e; 
  background-position: 0 -30px;
}
.view-product-list .product-list.grid{
  margin-top: -10px;
}
.product-list .product-container{
  border: 1px solid #eaeaea;
  overflow: hidden;
  padding-bottom: 10px;
}
.product-list .info-orther{
  display: none;
}
.product-list.grid li{
  margin-top: 30px;
}
.product-list.grid .info-orther{
  display: none;
}

.product-list.list li{
  width: 100%;
  margin-top: -1px;
}
.product-list.list li .product-container{
  border: none;
  border-bottom: 1px solid #eaeaea;
  border-left: 1px solid transparent;
  border-top: 1px solid transparent;
  border-right: 1px solid transparent;
}

.product-list.list li:first-child .product-container{
  margin-top: 20px;
}
.product-list.list li:hover .product-container{
  border: 1px solid #eaeaea;
}
.product-list.list .left-block{
    width: 29%;
    float: left;
    position: inherit;
}
.product-list.list .add-to-cart{
  top: 70px;
  right: 36px;
  left: inherit;
  bottom: inherit;
  width: 129px;
  height: 36px;
  background: #34495e;
  line-height: 36px;
  position: absolute;
}
.product-list.list .add-to-cart a{
  height: 36px;
  background: url("../images/cart.png") no-repeat left center;
  margin-left: 15px;
  padding-left: 15px;
  width: 114px;
}
.product-list.list .quick-view{
  width: 129px;
  right: 36px;
  top: 120px;
  text-align: center;
  padding-left: 5px;
}
.product-list.list .quick-view a{
  margin: 0 10px;
}
.product-list.list .quick-view a:last-child{
  margin: 0;
}

.product-list.list .quick-view a.heart{
  margin-left: inherit;
}
.product-list.list .quick-view a.compare{
  margin-left: inherit;
}
.product-list.list .quick-view a.search{
  margin-left: inherit;
}
.product-list.list .group-price{
  top: 34px;
    left: 25px;
}
.product-list.list .product-star{
  width: 100%;
  float: left;
  text-align: left;
  font-size: 14px;
  line-height: 26px;
    padding-top: 6px;
}
.product-list.list li .content_price {
  margin-top: -3px;
}
.product-list.list .right-block{
  width: 71%;
  float:left;
  margin-top: 20px;
  line-height: 26px;
}
.product-list.list .info-orther{
  display: block;
}
.product-list.list .right-block .product-name{
  font-size: 18px;
}
.product-list.list .right-block .availability span{
  color: #009966;
}
.product-list.list .right-block .product-desc{
  line-height: 24px;
  margin-top: 20px;
}
.product-list.style2.grid .add-to-cart{
  position: inherit;
  background: none;
  margin-top: 5px;

}
.product-list.style2.grid .add-to-cart a{
  background: #34495e;
  padding: 0 15px;
}
.product-list.style2.grid .add-to-cart a:hover{
  opacity: 0.8;
}
.product-list.style2.grid .add-to-cart a:before{
  content: '';
  width: 16px;
  height: 100%;
  background:url("../images/cart.png") no-repeat left center;
  float: left;
  margin-right: 10px;
}

/** sortPagiBar **/
.sortPagiBar{
  margin-top: 20px;
}
.sortPagiBar .page-noite{
  line-height: 30px;
}
.sortPagiBar .sort-product,
.sortPagiBar .show-product-item{
  float: right;
  border: 1px solid #eaeaea;
  height: 31px;
  margin-left: 23px;
}

.sortPagiBar select{
  background: transparent;
  padding: 0 10px;
  height: 29px;
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background: url("../images/dropdown.png") no-repeat right center #fafafa;
  padding-right: 20px;
  display: inline-block;
  font-size: 13px;
}
.sortPagiBar .sort-product .sort-product-icon{
  display: inline-block;
  width: 38px;
  text-align: center;
  float: right;
  height: 29px;
  border-left: 1px solid #eaeaea;
  background: #fafafa;
  padding-top: 8px;
}
.sortPagiBar .bottom-pagination{
  width: auto;
  float: right;
  margin-left: 23px;
}
.sortPagiBar .bottom-pagination .pagination{
  padding: 0;
  margin: 0;
  border-radius:0; 
}
.sortPagiBar .bottom-pagination .pagination a:hover{
  background: #34495e;
  color: #fff;
}
.sortPagiBar .bottom-pagination .pagination .active a{
  background: #34495e;
  color: #fff;
}
.sortPagiBar .bottom-pagination .pagination > li:first-child > a, 
.sortPagiBar .bottom-pagination .pagination > li:first-child > span {
    margin-left: 0px;
    border-top-left-radius: 0;
    border-bottom-left-radius: 0;
}
.sortPagiBar .bottom-pagination .pagination > li > a, 
.sortPagiBar .bottom-pagination .pagination > li > span {
    position: relative;
    float: left;
    padding: 5px 12px;
    margin-left: -1px;
    line-height: 1.42857;
    color: #999;
    text-decoration: none;
    background-color: #fafafa;
    border: 1px solid #eaeaea;
}
.sortPagiBar .bottom-pagination .pagination > li:last-child > a, 
.sortPagiBar .bottom-pagination .pagination > li:last-child > span {
    border-top-right-radius: 0;
    border-bottom-right-radius: 0;
}



/*----------------------
[17. Order page]
*/
.page-content{
  margin-top: 30px;
}
.page-order ul.step{
  width: 100%;
  clear: both;
  overflow: hidden;
}
.page-order ul.step li{
  display: inline;
  line-height: 30px;
  width: 20%;
  float: left;
  text-align: center;
  border-bottom: 3px solid #ccc;
}
.page-order ul.step li.current-step{
  border-bottom: 3px solid #34495e;
}

.page-order .heading-counter{
  margin: 30px 0;
  padding: 15px;
  border: 1px solid #eaeaea;
}
.table-bordered>thead>tr>td,
.table-bordered>thead>tr>th{
    border-bottom-width: 0px;
}
.page-order .cart_navigation a{
  padding: 10px 20px;
  border: 1px solid #eaeaea;
}
.page-order .cart_avail{
  text-align: center;

}
.page-order .cart_avail .label{
  white-space: normal;
  display: inline-block;
  padding: 6px 10px;
  font-size: 14px;
  border-radius: 0px;
}
.page-order .product-name{
  font-size: 16px;
}
.page-order .cart_description{
  font-size: 14px;
}
.page-order .cart_avail .label-success {
  background: #FFF;
  border: 1px solid #55c65e;
  color: #48b151;
  font-weight: normal;
}
.page-order .cart_navigation a.next-btn{
  float: right;
  background: #34495e;
  color: #fff;
  border: 1px solid #34495e;
}
.page-order .cart_navigation a.next-btn:hover{
  opacity: 0.8;
}
.page-order .cart_navigation a.prev-btn{
  float: left;
}
.page-order .cart_navigation a.prev-btn:before{
  font: normal normal normal 14px/1 FontAwesome;
    content: "\f104";
    padding-right: 15px;
}
.page-order .cart_navigation a.next-btn:after{
  font: normal normal normal 14px/1 FontAwesome;
      content: "\f105";
    padding-left: 15px;
}
.page-order .cart_navigation a:hover{
  background: #34495e;
  color: #fff;
}
.cart_summary > thead,
.cart_summary > tfoot{
  background: #f7f7f7;
  font-size: 16px;
}
.cart_summary > thead>th{
  border-bottom-width: 1px;
  padding: 20px;
}
.cart_summary td{
  vertical-align: middle!important;
  padding: 20px;
}
.cart_summary .table>tbody>tr>td, .table>tbody>tr>th, 
.cart_summary .table>tfoot>tr>td, .table>tfoot>tr>th, 
.cart_summary .table>thead>tr>td, .table>thead>tr>th{
  padding: 15px;
}
.cart_summary img{
  max-width: 100px;
}
.cart_summary td.cart_product{
  width: 120px;
  padding: 15px;
} 
.cart_summary .price{
  text-align: right;
}
.cart_summary .qty{
  text-align: center;
  width: 100px;
}
.cart_summary .qty input{
  text-align: center;
  max-width: 64px;
  margin: 0 auto;
  border-radius: 0px;
  border: 1px solid #eaeaea;
}
.cart_summary .qty a{
  padding: 8px 10px 5px 10px;
  border: 1px solid #eaeaea;
  display:inline-block;
  width: auto;
  margin-top: 5px;
}
.cart_summary .qty a:hover{
  background: #34495e;
  color: #fff;
}
.cart_summary .action{
  text-align: center;
    
}

.cart_summary .action a{
  background: url("../images/delete_icon.png") no-repeat center center;
  font-size: 0;
  height: 9px;
  width: 9px;
  display: inline-block;
  line-height: 24px;
}
.cart_summary tfoot{
  text-align: right;
}
.cart_navigation{
  margin-top: 10px;
  float: left;
  width: 100%;
}

/*
[18. Product page]
*/
#product .pb-right-column{
  line-height: 30px;
}
#product .pb-right-column .fa{
  line-height: inherit;
}
#product .pb-right-column .product-name{
  font-size: 24px;
}
#product .pb-right-column .product-comments .product-star,
#product .pb-right-column .product-comments .comments-advices{
  width: auto;
  display: inline-block;
}
#product .pb-right-column .product-comments .product-star{
  color: #ff9900;
}
#product .pb-right-column .product-comments .comments-advices a{
  border-right: 1px solid #eaeaea;
  padding-left: 15px;
  padding-right: 15px;
}
#product .pb-right-column .product-comments .comments-advices a:last-child{
  border-right: none;
}
#product .pb-right-column .product-price-group .price,
#product .pb-right-column .product-price-group .old-price,
#product .pb-right-column .product-price-group .discount{
  display: inline-block;
  margin-right: 15px;
}
#product .pb-right-column .product-price-group .price{
  font-size: 18px;
  font-weight: bold;
  color: #34495e;
}
#product .pb-right-column .product-price-group .old-price{
  text-decoration: line-through;
}
#product .pb-right-column .product-price-group .discount{
  background: #ff9900;
  color: #fff;
  padding: 0 15px;
  text-align: center;
  line-height: inherit;
  margin-right: 0;
  height: 23px;
  line-height: 23px;
}
#product .pb-right-column .info-orther{
  padding-bottom: 5px;
}
#product .pb-right-column .product-desc,
#product .pb-right-column .form-option,
#product .pb-right-column .form-action,
#product .pb-right-column .form-share{
  border-top: 1px solid #eaeaea;
  padding: 10px 0;
}
#product .pb-right-column .form-option #size_chart{
  color: #34495e;
  text-decoration:underline;
  margin-left: 15px;
}
#product .pb-right-column .product-desc{
  line-height: 24px;
}
#product .pb-right-column .form-option .attributes{
  clear: both;
  padding: 5px 0;
  overflow: hidden;
}
#product .pb-right-column .form-option .attributes:first-child{
  padding-top: 0;
}
#product .pb-right-column .form-option .attributes .attribute-label{
  width: 50px;
  float: left;
}
#product .pb-right-column .form-option .form-option-title{
  font-weight: bold;
  line-height: 20px;
}

#product .pb-right-column .form-option .attributes select{
  padding: 0px 0px 0px 10px;
  height: 29px;
    line-height: 23px;
  -moz-appearance: none;
  -webkit-appearance: none;
  background: #FAFAFA url("../images/dropdown.png") no-repeat scroll right center;
  display: inline-block;
  border: 1px solid #eaeaea;
  min-width: 95px;
}
#product .pb-right-column .form-option .qty{
  width: 40px;
  display: inline-block;
  float: left;
  overflow: hidden;

}
#product .pb-right-column .form-option .product-qty{
  border: 1px solid #eaeaea;
  width: 60px;
  margin-left: 50px;
  overflow: hidden;
  background: #FAFAFA;

}
#product .pb-right-column .form-option .attributes .btn-plus{
  width: 18px;
  height: 29px;
  float: left;
  display: inline-block;
  margin-top: -5px;

}
#product .pb-right-column .form-option .btn-plus a{
  width: 18px;
  height: 10px;
  float: left;
  text-align: center;
  cursor: inherit;
}

#product .pb-right-column .form-option .attributes input{
  max-width: 50px;
  padding: 0 5px;
}
#product .pb-right-column .form-option .list-color{
  overflow: hidden;
  padding-top: 5px;

}
#product .pb-right-column .form-option .list-color li{
  width: 20px;
  height: 20px;
  border: 1px solid #eaeaea;
  float: left;
  margin-right: 10px;
}
#product .pb-right-column .form-option .list-color li:hover,
#product .pb-right-column .form-option .list-color li.active{
    border: 1px solid #34495e;
}
#product .pb-right-column .form-option .list-color li a{
  width: 20px;
  height: 20px;
  float: left;
  text-indent: -9999px;  
}
#product .pb-right-column .form-action{
  padding: 0;
  padding-bottom: 5px;
}
#product .pb-right-column .form-action .button-group{
  margin-top: 15px;
  overflow: hidden;
}
#product .pb-right-column .form-action .button-group .wishlist,
#product .pb-right-column .form-action .button-group .compare{
  min-width: 50px;
  padding-right: 15px;
  text-align: center;
  float: left;
}
#product .pb-right-column .form-action .button-group .wishlist .fa,
#product .pb-right-column .form-action .button-group .compare .fa{
  font-size: 18px;
  width: 30px;
  height:30px;
  color: #fff;
  line-height: 30px;
  background: rgba(0, 0, 0, 0.4) none repeat scroll 0% 0%;
  border-radius: 90%;
}
#product .pb-right-column .form-action .button-group .wishlist:hover .fa,
#product .pb-right-column .form-action .button-group .compare:hover .fa{
  background: #34495e;
}
#product .pb-right-column .form-share .fa{
  font-size: 18px;
}
#product .pb-right-column .form-share .sendtofriend-print a{
  margin-right: 15px;
  margin-bottom: 15px;
}
#product .pb-left-column .product-image .product-full{
  border: 1px solid #eaeaea;
  padding: 10px;
}
#product .pb-left-column .product-image .product-img-thumb{
  margin-top: 15px;
  padding: 0 40px;
}
#product .pb-left-column .product-image .product-img-thumb li{
  border: 1px solid #eaeaea;
  padding: 7px 10px;
}
#product .pb-left-column .product-image .owl-next{
  right: -40px;
}
#product .pb-left-column .product-image .owl-prev{
  left: -40px;
}

.product-tab{
  margin-top: 30px;
}
.product-tab .nav-tab{
  width: 100%;
  overflow: hidden;
  z-index: 100;
  position: relative;
}
.product-tab .nav-tab>li{
  height: 50px;
  line-height: 50px;
  float: left;
  display: inline;
  background: #e2e2e2;
  border: 1px solid #e2e2e2;
  color: #333333;
  text-transform: uppercase;
  text-align: center;
  margin-right: 8px;
  font-weight: bold;
}
.product-tab .nav-tab>li:last-child{
  margin-right: 0;
}
.product-tab .nav-tab>li>a{
  color: #333333;
  padding: 0 26px;
  height: 50px;
  float: left;
}
.product-tab .nav-tab>li:hover>a,
.product-tab .nav-tab>li.active>a{
  background: #fff;
}
.product-tab .tab-container{
    padding: 20px;
    border: 1px solid #e2e2e2;
    margin-top: -1px;
    z-index: 1;
}
.product-tab .tab-container p{
  margin: 0 0 10px;
}
.product-tab .tab-container .table{
  margin-bottom: 0;
}
.product-tab .tab-container .tab-panel{
  line-height: 24px;
}
.product-comments-block-tab {
  overflow: hidden;
}
.product-comments-block-tab .fa{
    line-height: inherit;
}
.product-comments-block-tab .reviewRating{
  color: #ff9900;
}
.product-comments-block-tab .comment{
  padding-bottom: 10px;
  padding-top: 10px;
  border-bottom: 1px dotted #eaeaea;
}
.product-comments-block-tab .comment:first-child{
  padding-top: 0;
}
.product-comments-block-tab .comment:last-child{
  padding-bottom: 0;
  border-bottom:none;
}
.product-comments-block-tab .comment .author{
    border-right: 1px solid #eaeaea;
}
.product-comments-block-tab .btn-comment{
    padding: 5px 15px;
    border: 1px solid #eaeaea;
    float: left;
    margin-top: 15px;
}
.page-product-box{
  margin-top: 50px;
}
.page-product-box .heading{
  font-size: 16px;
  color: #333333;
  text-transform: uppercase;
  font-weight: bold;
  padding-bottom: 17px;
}
.page-product-box .owl-next{
  top: -20px;
}
.page-product-box .owl-prev{
  top: -20px;
  left: inherit;
  right: 26px;
}

/* ----------------
 [19. Contact page]
 */
#contact{
    margin-top: 20px;
}
#contact .page-subheading {
  padding-left: 0px;
  border: none;
  margin: 14px 0 30px;
  text-transform: uppercase;
  font-size: 18px;
  color: #666;
}

#contact .contact-form-box {
  padding: 0;
  margin: 0 0 30px 0;
}
#contact .contact-form-box label{
    padding-bottom: 5px;
}
#contact .contact-form-box .form-selector{
    padding-bottom: 25px;
}
#contact input,
#contact select,
#contact textarea{
    border-radius: 0;
    border-color: #eaeaea;
    box-shadow: inherit;
    outline: 0 none;
}

#contact input:focus,
#contact select:focus,
#contact textarea:focus{
    box-shadow: inherit;
    outline: 0 none;
}
#contact #btn-send-contact{
    font-size: 14px;
    line-height: 18px;
    color: white;
    padding: 0;
    font-weight: normal;
    background: #666;
    -webkit-border-radius: 0;
    -moz-border-radius: 0;
    border-radius: 0;
    border: none;
    padding: 10px 25px;
}
#contact #btn-send-contact:hover{
    background: #F36;
}
#contact_form_map ul {
  line-height: 28px;
  list-style: disc;
  list-style-position: inside;
  font-style: italic;
}

#contact_form_map ul.store_info {
  list-style: none;
  font-style: normal;
  color: #696969;
}
#contact_form_map ul.store_info i {
  display: inline-block;
  width: 30px;
  line-height: inherit;
}
#message-box-conact .fa{
    line-height: inherit;
}

.content-text{
  padding: 20px 0;
  text-align: justify;
}
.content-text p{
  margin-bottom: 15px;
}

.right-sidebar #left_column{
  float: right;
}

/* ----------------
 [20. Bolog page]
 */
 .blog-posts{
    line-height: 24px;
    margin-top: 20px;
 }
  .blog-posts .post-item{
    padding-bottom: 20px;
    padding-top: 20px;
    border-bottom: 1px solid #eaeaea;
    border-top: 1px solid #eaeaea;
    margin-top: -1px;
 }
.blog-posts .post-item .entry-meta-data{
    padding: 5px 0;
    color: #666;
    font-size: 13px;
}
.blog-posts .post-item .entry-meta-data span{
  margin-right: 5px;
}
.blog-posts .post-item .entry-meta-data .author .fa{
  opacity: 0.7;
}
.blog-posts .post-item .entry-meta-data .fa{
    line-height: inherit;
  }
.blog-posts .post-item .post-star{
  font-size: 13px;
}
.blog-posts .post-item .post-star .fa{
  line-height: inherit;
  color: #ff9900;
}
.blog-posts .post-item .entry-excerpt{
  text-align: justify;
}
.blog-posts .post-item .entry-more a{
  border: 1px solid #eaeaea;
  padding: 10px 12px;
  background: #eee;
}
.blog-posts .post-item .entry-more{
  margin-top: 15px;
}
.blog-posts .post-item .entry-more a:hover{
  background: #34495e;
  color: #fff;
}
.blog-posts .post-item .entry-thumb img{
  border: 1px solid #eaeaea;
}

/** post sidebar **/
.blog-list-sidebar{

}
.blog-list-sidebar li{
  border-bottom: 1px solid #eaeaea;
  padding-bottom: 10px;
  margin-bottom: 10px;
  overflow: hidden;
}
.blog-list-sidebar li:last-child{
  border: none;
  margin-bottom: 0px;
  
}
.blog-list-sidebar li .post-thumb{
  width: 80px;
  float: left;
  border: 1px solid #eaeaea;
  padding: 4px;
  background: #fcfcfc;
}
.blog-list-sidebar li .post-info{
  margin-left: 90px;
  color: #999;
}
.blog-list-sidebar li .post-info .post-meta{
  font-size: 12px;
  margin-top: 5px;
}
.blog-list-sidebar li .post-info .fa{
  line-height: inherit;

}
/* Recent Comments*/
.recent-comment-list li{
  border-bottom: 1px solid #eaeaea;
  padding-bottom: 10px;
  margin-bottom: 10px;
  overflow: hidden;
}
.recent-comment-list li:last-child{
  border: none;
  margin-bottom: 0px;
}
.recent-comment-list li .author{
  color: #666;
  margin-bottom: 5px;
  font-size: 13px;
}
.recent-comment-list li .comment{
  margin-top: 5px;
  color: #666;
}
.recent-comment-list li>h5>a{
  color: #333;
}

/** Blog detail **/
.entry-detail{
  margin-top: 20px;
}
.entry-detail .entry-photo img{
  border: 1px solid #eaeaea;
}
.entry-detail .entry-meta-data{
  padding: 10px 0;
  color: #666;
}
.entry-detail .entry-meta-data .fa{
  line-height: inherit;
}
.entry-detail .entry-meta-data span{
  margin-right: 10px;
}
.entry-detail .entry-meta-data .author .fa{
  opacity: 0.7;
}
.entry-detail .entry-meta-data .post-star{
  float: right;

}
.entry-detail .entry-meta-data .post-star .fa{
  color: #ff9900;
}
.entry-detail .entry-meta-data .post-star span{
  margin: 0;
}

/** COMMMENT list**/
.single-box{
  margin-top: 20px;
}
.single-box>h2{
}
.comment-list{
  margin-top: 20px;
}
.comment-list ul{
  padding-left: 80px;
}
.comment-list ul li{
  overflow: hidden;
  margin-bottom: 15px;
  border-bottom: 1px solid #eaeaea;
  padding-bottom: 15px;
}
.comment-list ul li:last-child{
  margin-bottom: 0;
  border: none;
  padding: 0;
}
.comment-list>ul{
  padding-left: 0;
}
.comment-list .avartar{
  width: 80px;
  border: 1px solid #eaeaea;
  padding: 4px;
  float: left;
}
.comment-list .comment-body{
  margin-left: 90px;
}
.comment-list .comment-meta{
  color: #ccc;
}
.comment-list .comment-meta .author a{
  font-weight: bold;
}
.coment-form{
  margin-top: 20px;
}
.coment-form label{
  margin-top: 10px;
  margin-bottom: 2px;
}
.coment-form input,
.coment-form textarea{
  border-radius: 0px;
  border:1px solid #eaeaea;
  -webkit-box-shadow:inherit;
  box-shadow:inherit;
}
.coment-form .btn-comment{
  padding: 10px 20px;
  border: 1px solid #eaeaea;
  background: #666;
  color: #fff;
  margin-top: 15px;
}
.coment-form .btn-comment:hover{
  background: #34495e;
  border:1px solid #34495e;
}
/**Related Posts**/

.related-posts{
  margin-top: 20px;
}
.related-posts .entry-thumb img{
  border: 1px solid #eaeaea;
}
.related-posts .entry-ci{
  margin-top: 10px;
}
.related-posts .entry-meta-data{
  color: #999;
  font-size: 13px;
  margin-top: 10px;
}
.related-posts .entry-meta-data .fa{
  line-height: inherit;
}
.related-posts .entry-ci .entry-excerpt{
  padding: 10px 0;
}
.related-posts .entry-title{
  font-size: 14px;
}
.related-posts .owl-next{
  top: -31px;
}
.related-posts .owl-prev{
  top: -31px;
  left: inherit;
  right: 26px;
}

/* ----------------
 [21. Login page]
 */
.box-authentication{
  border:1px solid #eaeaea;
  padding: 30px;
  min-height: 320px;
}
.box-authentication>h3{
  margin-bottom: 15px;
}
.box-authentication label{
  margin-top: 10px;
  margin-bottom: 2px;
}
.box-authentication .forgot-pass{
  margin-top: 15px;
}
.box-authentication .alert{
  margin-top: 15px;
  color:red;
}
.box-authentication input, 
.box-authentication textarea {
  border-radius: 0px;
  border: 1px solid #eaeaea;
  -webkit-box-shadow: inherit;
  box-shadow: inherit;
  width: 50%;
}
.box-authentication  .button{
  margin-top: 15px;
}


.box-border{
  border: 1px solid #eaeaea;
  padding:20px;
  overflow: hidden;
}
.box-wishlist label,
.box-wishlist .button{
  margin-top: 15px;
  margin-bottom: 5px;
}
.box-wishlist{
  margin-top: 20px;
}
.table-wishlist{
  margin-top: 20px;
}
.table-wishlist th{
  background: #fafafa;
}
.list-wishlist{
  margin-top: 20px;
}
.list-wishlist li{
  margin-top: 30px;
}
.list-wishlist li .product-img{
  border: 1px solid #eee;
  padding: 10px;
}
.list-wishlist li .product-name,
.list-wishlist li .qty,
.list-wishlist li .priority,
.list-wishlist li .button{
  margin-top: 10px;
}
.list-wishlist li .button-action{
  position: relative;
}
.list-wishlist li .button-action a{
  position: absolute;
  right: 10px;
  top: 15px;
}
.list-wishlist li .button-action a .fa{
  line-height: inherit;
}

.table-compare td.compare-label{
  width: 150px;
  background: #fafafa;
  vertical-align: middle;
}
.table-compare .product-star .fa{
  line-height: inherit;
  color: #ff9900;
}
.table-compare .price{
  font-weight: bold;
  color: #34495e;
}
.table-compare .add-cart{
  background: #34495e;
  color: #fff; 
}
.table-compare  .add-cart:hover{
  opacity: 0.8;
}
.checkout-page .checkout-sep{
  padding-bottom: 15px;
  text-transform: uppercase;
}
.checkout-page .box-border{
  margin-bottom: 15px;
}
.checkout-page .box-border .button{
  margin-top: 15px;
}
.checkout-page .box-border label{
  margin-top: 5px;
}
.checkout-page .box-border p,
.checkout-page .box-border h4{
  padding-bottom: 5px;
  margin-top: 5px;
}
.checkout-page .box-border .fa{
  line-height: inherit;
}

.checkout-page .box-border input[type="radio"]{
  margin-right: 10px;
}

/** cat-short-desc**/
.cat-short-desc{
  margin-top: 20px;
}
.cat-short-desc .cat-short-desc-products{
  margin-top: 20px;
}
.cat-short-desc .cat-short-desc-products li .product-container{
  border: 1px solid #eaeaea;
  padding: 10px;
}
.cat-short-desc .cat-short-desc-products li .product-container .product-name{
  margin-top: 10px;
}

/**today-deals**/
.today-deals{
  position: relative;
}
.today-deals .deals-product-list .product-info{
  margin-top: 10px;
}
.today-deals .deals-product-list .product-info .show-count-down{
  text-align: center;
}
.today-deals .deals-product-list .product-info .show-count-down .box-count{
  display: inline-block;
  margin-right: 2px;
  color: #34495e;
}
.today-deals .deals-product-list .product-info .show-count-down .dot{
  display: none;
}
.today-deals .deals-product-list .product-info .show-count-down .box-count .number{
  
  width: 100%;
  float: left;
  background: #eaeaea;
  padding: 5px 0;
  font-size: 16px;
}
.today-deals .deals-product-list .product-info .show-count-down .box-count .text{
  background: #eaeaea;
  font-size: 12px;
  margin-top: 1px;
  width: 100%;
  float: left;
  padding: 5px 0; 
  color: #666;
}
.today-deals .deals-product-list .product-info .product-name{
  margin-top: 15px;
}
.today-deals .deals-product-list .product-info .product-meta{
  margin-top: 7px;
  line-height: 18px;
}
.today-deals .deals-product-list .product-info .product-meta .fa{
  line-height: inherit;
}
.today-deals .deals-product-list .product-info .product-meta .price{
  color: #34495e;
  font-size: 18px;

}
.today-deals .deals-product-list .product-info .product-meta .old-price{
  text-decoration: line-through;
  margin-left: 11px;
  color: #666;
}
.today-deals .deals-product-list .product-info .product-meta .star{
  float: right;
  font-size: 13px;
  color: #ff9900;
}
.today-deals .owl-next{
  top: -55px;
}
.today-deals .owl-prev{
  top: -55px;
  left: inherit;
  right: 26px;
}
.group-button-header{
  margin-top: 17px;
}
.group-button-header .btn-cart,
.group-button-header .btn-heart,
.group-button-header .btn-compare{
  width: 39px;
  height: 39px;
  float: right;
  position: relative;
  margin-right: 16px;
}
.group-button-header .btn-cart{
  background: url("../images/icon-cart-round.png") no-repeat center center;
  position: relative;
}
.group-button-header .btn-cart:after{
  content: "";
  width: 100%;
  height: 10px;
  display: block;
  position: absolute;
  bottom: -10px;
}
.group-button-header .btn-cart .notify-right{
  top: -12px;
  right: -12px;
}
.group-button-header .btn-heart{
  background: url("../images/icon-heart-round.png") no-repeat center center;
  text-indent: -999px;
  display: inline-block;
  font-size: 0;
}
.group-button-header .btn-compare{
  background: url("../images/icon-compare-round.png") no-repeat center center;
  text-indent: -999px;
  margin-right: 0;
  display: inline-block;
  font-size: 0;
}
.main-header .group-button-header .btn-cart>a{
  width: 100%;
  height: 100%;
  float: left;
  font-size: 0;
}

.main-header .group-button-header .btn-cart:hover .cart-block {
  -webkit-transform: translate(0,0);
  -moz-transform: translate(0,0);
  -o-transform: translate(0,0);
  -ms-transform: translate(0,0);
  transform: translate(0,0);
  opacity: 1;
  visibility: visible;
}

/*----------------
[7. Blogs]
*/
.blog-list{
  margin-top: 30px;
}
.blog-list .page-heading{
  text-transform: uppercase;
}
.blog-list .blog-list-wapper{
  margin-top: 30px;
}
.blog-list .blog-list-wapper ul li{
  border: 1px solid #eaeaea;
  line-height: 30px;
}
.blog-list .blog-list-wapper ul li .post-desc{
  padding: 15px;
}
.blog-list .blog-list-wapper ul li .post-desc .post-title a{
  font-size: 14px;
  color: #333;
}
.blog-list .blog-list-wapper ul li .post-desc .post-title a:hover{
  color: #f96d10;
}

.blog-list .blog-list-wapper ul li .post-desc .post-meta{
  color: #919191;
  font-size: 13px;
}
.blog-list .blog-list-wapper ul li .post-desc .post-meta .date:before{
  font: normal normal normal 13px/1 FontAwesome;
  content: "\f1ec";
  padding-right: 5px;
}
.blog-list .blog-list-wapper ul li .post-desc .post-meta .comment:before{
  font: normal normal normal 13px/1 FontAwesome;
  content: "\f0e5";
  padding-right: 5px;
  padding-left: 15px;
}
.blog-list .blog-list-wapper ul li .readmore{
  text-align: right;
}
.blog-list .blog-list-wapper ul li .readmore a{
  color: #f96d10;
}
.blog-list .blog-list-wapper ul li .readmore a:after{
  font: normal normal normal 14px/1 FontAwesome;
  content: "\f178";
  padding-left: 10px;
}
.blog-list .blog-list-wapper .owl-controls .owl-next{
  top: -50px;
}
.blog-list .blog-list-wapper .owl-controls .owl-prev{
  left: inherit;
  right: 26px;
  top: -50px;
}

/*-------------
[23. footer2]
---------*/
#footer2{
  margin-top: 45px;
  border-top: 1px solid #eaeaea;
  background: #fff;
}
#footer2 .footer-top{
  padding: 10px 0;
}
#footer2 .footer-top .footer-menu{
  margin-top: 25px;
}
#footer2 .footer-top .footer-menu li{
  display: inline;
  float: left;
  padding: 0 10px;
}
#footer2 .footer-top .footer-social{
  margin-top: 18px;
}
#footer2 .footer-top .footer-social li{
    display: inline;
    float: right;
}
#footer2 .footer-top .footer-social li>a .fa{
  line-height: inherit;
}
#footer2 .footer-top .footer-social li>a{
  color: #fff;
  width: 32px;
  height: 32px;
  background: #415a99;
  float: left;
  text-align: center;
  line-height: 32px;
  margin-left: 5px;
}
#footer2 .footer-top .footer-social li>a:hover{
  opacity: 0.8;
}
#footer2 .footer-top .footer-social li>a.twitter{
  background: #00caff;
}
#footer2 .footer-top .footer-social li>a.pinterest{
  background: #cb222a;
}
#footer2 .footer-top .footer-social li>a.vk{
  background: #5b7fa6;
}
#footer2 .footer-top .footer-social li>a.google-plus{
  background: #da4735;
}
#footer2 .footer-paralax{
  background: url("../images/brand_prlx_bg-small.jpg") 50% 0 no-repeat fixed;
  color: #fff;
}
#footer2 .footer-row{
  padding: 45px 0;
  background-color: rgba(0, 0, 0, 0.8);
  background: rgba(0, 0, 0, 0.8);
  color: #fff;
}
#footer2 .footer-center{
  text-align: center;
  background-color: rgba(0, 0, 0, 0.6);
  background: rgba(0, 0, 0, 0.6);
}
#footer2 .footer-center h3{
  text-transform: uppercase;
  padding-bottom: 20px;
}
#footer2 .footer-center p{
  color: #999;
  padding-bottom: 20px;
}
#footer2 .footer-row .form-subscribe{
  width: 540px;
  margin: 0 auto;
  border: 1px solid #999;
  line-height: normal;
}
#footer2 .footer-row .form-subscribe .form-group{
  width: 100%;
  position: relative;
}
#footer2 .footer-row .form-subscribe .form-control{
  width: 100%;
  background: transparent;
  border: none;
  border-radius: 0;
  -webkit-box-shadow:inherit;
  box-shadow:inherit;
  padding-right: 40px;
  color: #fff;
}
#footer2 .footer-row .form-subscribe .btn{
  position: absolute;
  top: 3px;
  right:0;
  background: transparent;
  border: none;
  border-radius: 0;
  -webkit-box-shadow:inherit;
  box-shadow:inherit;
  color: #fff;
}
#footer2 .widget-title{
  text-transform: uppercase;
  padding-bottom: 20px;
}
#footer2 .widget-body ul{
  padding-left: 25px;
}
#footer2 .widget-body li{
  line-height: 30px;
}
#footer2 .widget-body li a{
  color: #999;
  margin-left: -25px;
}
#footer2 .widget-body li a:hover{
  color: #fff;
}
#footer2 .widget-body li a:before{
  font-family: 'FontAwesome';
  font-size: 14px;
  content: "\f105";
  margin-right: 15px;
}
#footer2 .widget-body li a.location:before{
    content: "\f041";
}
#footer2 .widget-body li a.phone:before{
    content: "\f095";
}
#footer2 .widget-body li a.email:before{
  content: "\f003";
}
#footer2 .widget-body li a.mobile:before{
  content: "\f10b";
}
#footer2 .footer-bottom{
  background-color: rgba(0, 0, 0, 0.8);
  background: rgba(0, 0, 0, 0.8);
  
  color: #fff;
}
#footer2 .footer-bottom .footer-bottom-wapper{
  border-top: 1px solid #333333;
  padding: 30px 0;
}
#footer2 .footer-bottom .footer-payment-logo{
  text-align: right;
}

.block-banner{
  margin-top: 30px;
}
.block-banner .block-banner-left,
.block-banner .block-banner-right{
  width: 50%;
  float: left;
}
.block-banner .block-banner-left{
  padding-right: 5px;
}
.block-banner .block-banner-right{
  padding-left: 5px;
}

/*----------------
[24. Hot deals]
-----------------*/
.hot-deals-row{
  margin-top: 30px;
}
.hot-deals-box{
  border: 1px solid #eaeaea;
}
.hot-deals-box .hot-deals-tab {
  display: table;
  width: 100%;
}
.hot-deals-box .hot-deals-tab .hot-deals-title{
  width: 45px;
  display: table-cell;
  text-transform: uppercase;
  font-size: 24px;
  text-align: center;
  background: #0088cc;
  color: #fff;
  padding-top: 40px;
}
.hot-deals-box .hot-deals-tab .hot-deals-title>span{
  width: 100%;
  float: left;
  text-align: center;
}
.hot-deals-box .hot-deals-tab .hot-deals-title>span.yellow{
  color: #ffcc00;
}
.hot-deals-box .hot-deals-tab .hot-deals-tab-box{
  display: table-cell;
  padding:25px;
}
.hot-deals-box .hot-deals-tab .hot-deals-tab-box .nav-tab li{
  line-height: 40px;
  border-bottom: 1px solid #eaeaea;
  text-transform: uppercase;
  padding-left: 15px;
}
.hot-deals-box .hot-deals-tab .hot-deals-tab-box .nav-tab li.active>a{
  color: #0099cc;
}
.hot-deals-box .hot-deals-tab .box-count-down{
  margin-top: 20px;
  float: left;
  padding-left: 4px;
}
.hot-deals-box .hot-deals-tab .box-count-down .box-count{
  width: 67px;
  height:67px;
  border:1px solid #eaeaea;
  float: left;
  border-radius: 90%;
  text-align: center;
  padding: 10px;
  position: relative;
  color: #fff;
  margin-left: -4px;
  background: #fff;
}
.hot-deals-box .hot-deals-tab .box-count-down .dot{
  display: none;
}
.hot-deals-box .hot-deals-tab .box-count-down .box-count:before{
  width: 100%;
  height: 100%;
  background: #0088cc;
  float: left;
  content: '';
  border-radius: 90%;
}
.hot-deals-box .hot-deals-tab .box-count-down .box-count:after{
  content: '';
  width: 23px;
  height: 1px;
  background: #fff;
  position: absolute;
  top: 34px;
  left: 20px;
}
.hot-deals-box .hot-deals-tab .box-count-down .number{
  position: absolute;
  width: 100%;
  left: 0;
  top: 15px;
}
.hot-deals-box .hot-deals-tab .box-count-down .text{
  position: absolute;
  width: 100%;
  left: 0;
  bottom: 16px;
  font-size: 10px;
}
.hot-deals-box .hot-deals-tab-content-col{
  padding-left: 0;
}
.hot-deals-box .hot-deals-tab-content{
  padding: 30px 30px 0 0;
}
.hot-deals-box .product-list .left-block{
  border: 1px solid #eaeaea;
  padding: 0;
}
.hot-deals-box .product-list .right-block {
  padding: 0;
}

/*---------------
[25. Box product]
*/
/** box-products**/
.box-products{
  margin-top: 30px;
}
.box-products .box-product-head{
  height: 30px;
  border-bottom: 1px solid #eaeaea;
}
.box-products .box-product-head .box-title{
  color: #333;
  text-transform: uppercase;
  border-bottom: 3px solid #ff3300;
  padding-bottom: 5px;
  font-size: 18px;
  padding-left: 10px;
  padding-right: 5px;
}
.box-products .box-tabs{
  float: right;
}
.box-products .box-tabs li{
  display: inline;
  text-transform: uppercase;
  height: 30px;
  float: left;
}
.box-products .box-tabs li>a{
  position: relative;
  padding: 0 10px;
  display: block;
  line-height: normal;
  background: url('../images/kak3.png') no-repeat center right;
  float: left;
  height: 30px;
  line-height: 30px;
}
.box-products .box-tabs li>a:after{
  content: "\f0d8";
  font-family: 'FontAwesome';
  font-size: 13px;
  color: #0088cc;
  position: absolute;
  bottom: -12px;
  left: 50%;
  -ms-transform: translateX(-50%);
  -webkit-transform: translateX(-50%);
  transform: translateX(-50%);
  display: none;
}
.box-products .box-tabs li>a:before{
  content: '';
  height: 1px;
  background: #0088cc;
  position: absolute;
  bottom: 0;
  left: 10px;
  right: 10px;
  transform: scale(0, 1);
}
.box-products .box-tabs li:last-child>a{
  background: none;
}
.box-products .box-tabs li:last-child>a:before{
  right: 0;
}
.box-products .box-tabs li:last-child>a{
  border-right: none;
  padding-right: 0;
}

.box-products .box-tabs li>a:hover:before,
.box-products .box-tabs li.active>a:before{
  transform: scale(1);
  -webkit-transition: all 0.3s ease-out 0s;
  -moz-transition: all 0.3s ease-out 0s;
  -o-transition: all 0.3s ease-out 0s;
  transition: all 0.3s ease-out 0s;
}
.box-products .box-tabs li>a:hover,
.box-products .box-tabs li.active>a{
  color: #333;
}
.box-products .box-tabs li>a:hover:after,
.box-products .box-tabs li.active>a:after{
  display: block;
}

.box-products .box-product-content{
  margin-top: 20px;
}

.box-products .box-product-content .box-product-adv{
  width: 226px;
  float: left;
}

.box-products .box-product-content .box-product-list{
  margin-left: 236px;
}
.box-products .box-product-content .box-product-list .product-list li{
  border: 1px solid #eaeaea;
  padding-bottom: 10px;
  overflow: hidden;
}
.box-products .box-product-content .box-product-list .product-list li .right-block{
  margin-top: 30px;
}
.option3 .product-list li .price-percent-reduction2{
  right: -8px;
}

/** option color **/
/*new-arrivals*/
.box-products.new-arrivals .box-tabs li>a:after{
  color: #ff3300;
}
.box-products.new-arrivals .box-tabs li>a:before{
  background: #ff3300;
}
.box-products.new-arrivals .box-product-head .box-title{
    border-bottom: 3px solid #ff3300;
}

/**top-sellers**/
.box-products.top-sellers .box-tabs li>a:after{
  color: #ffcc00;
}
.box-products.top-sellers .box-tabs li>a:before{
  background: #ffcc00;
}
.box-products.top-sellers .box-product-head .box-title{
    border-bottom: 3px solid #ffcc00;
}
/**special-products**/
.box-products.special-products .box-tabs li>a:after{
  color: #009966;
}
.box-products.special-products .box-tabs li>a:before{
  background: #009966;
}
.box-products.special-products .box-product-head .box-title{
    border-bottom: 3px solid #009966;
}
/*recommendation*/
.box-products.recommendation .box-tabs li>a:after{
  color: #ff66cc;
}
.box-products.recommendation .box-tabs li>a:before{
  background: #ff66cc;
}
.box-products.recommendation .box-product-head .box-title{
    border-bottom: 3px solid #ff66cc;
}

/** Blog **/
.option3 .blog-list .page-heading{
  font-size: 18px;
}
.option3 .blog-list .blog-list-wapper ul li .readmore a{
  color: #0099cc;
}
.option3 .blog-list .page-heading span.page-heading-title{
  border-color: #0099cc;
}


.block-popular-cat{
  border: 1px solid #eaeaea;
  padding: 15px;
}
.block-popular-cat .parent-categories{
  text-transform: uppercase;
  font-size: 16px;
  text-decoration: underline;
  padding-bottom: 15px;
}
.block-popular-cat .image{
  width: auto;
  display: inline-block;
}
.block-popular-cat .sub-categories{
  width: auto;
  display: inline-block;
  line-height: 30px;
}
.block-popular-cat .sub-categories>ul>li>a:before{
  content: '';
  background: #008a90;
  border-radius: 50%;
  width: 4px;
  height: 4px;
  display: inline-block;
  margin-right: 10px;
  margin-bottom: 3px;
}
.block-popular-cat .more{
  height: 36px;
  width: 70px;
  line-height: 36px;
  color: #fff;
  background: #00abb3;
  margin-top: 10px;
  display: block;
  text-align: center;

}
.block-popular-cat .more:hover{
  color: #fff;
  opacity: 0.8;
}
/*------------------------------------------------------------------
[Table of contents]
1. Styles for devices(>1200px)
2. Styles for devices(>=992px and <=1199px)
3. Styles for devices(>=768px and <=992px)
4. Styles for devices(>=481px and <=767px)
5. Styles for devices(<=480px)
-------------------------------------------------------------------*/
/*----------------
[1. Styles for devices(>1200px)]
*/
@media (min-width: 1201px){
}
/*----------------
[2. Styles for devices(>=993px and <=1200px)]
*/
@media (min-width: 993px) and (max-width: 1200px) {
	.nav-menu .nav > li > a{
		padding: 15px 15px;
	}
	.main-header .header-search-box{
		padding-left: 0;
		width: 50%;
	}
	.main-header .shopping-cart-box{
		float: right;
		width: 25%;
	}
	.box-vertical-megamenus .vertical-menu-content{
		display: none;
	}
	.home .box-vertical-megamenus .vertical-menu-content{
		display: none;
	}
	#home-slider .slider-left{
		display: none;
	}
	#home-slider .header-top-right{
		width: 100%;
		margin: 0;
		border-top: none;
		padding: 0 15px;
	}
	#home-slider .header-top-right .homeslider,
	#home-slider .header-top-right .header-banner{
		border-top: 3px solid #F36;
	}
	.service .service-item {
		padding: 0;
		overflow: hidden;
	}
	.service .service-item .icon{
		width: 100%;
		text-align: center;
		padding-bottom: 15px;
		height: auto;
	}
	.service .service-item .info{
		width: 100%;
		padding: 0;
		margin: 0;
		text-align: center;
	}
	.product-list li .product-star{
		float: left;
	}
	.latest-deals .count-down-time span{
		font-size: 12px;
	}
	.product-list.grid li{
		width: 50%;
	}
	.subcategories li a{
		padding: 0 10px;
	}
	#left_column .block .block_content{
		padding: 10px;
	}
	#left_column .block .title_block{
		font-size: 14px;
		padding-left: 10px;
	}
	.layered .layered_subtitle{
		font-size: 14px;
	}
	.check-box-list input[type="checkbox"] + label span.button{
		margin-right: 5px;
	}
	.special-product .special-product-left{
		width: 100%;
	}
	.special-product .special-product-right{
		margin-left: 0;
		margin-top: 10px;
	}
	.sortPagiBar .sort-product{
		margin-top: 20px;
	}
	.product-tab .nav-tab>li>a {
		padding: 0 10px;
	}
	#product .pb-right-column .product-comments .comments-advices a{
		padding: 0 5px;
	}
	/** MAIN MENU **/
	#main-menu .navbar .navbar-nav>li>a {
		padding: 0 10px;
	}
	.hot-deals-box .hot-deals-tab-content-col{
		padding-left: 15px;
	}
	.hot-deals-box .hot-deals-tab-content{
		padding: 30px;
	}
	.box-products .box-product-content .box-product-adv{
		width: 20%;
		padding-right: 5px;
	}
	.box-products .box-product-content .box-product-list{
		width: 80%;
		margin: 0;
		float: left;
		padding-left: 5px;
	}
	.box-products .box-product-content .box-product-list .product-list li{
		padding-bottom: 5px;
	}
}
/*--------------------
[3. Styles for devices(>=768px and <=992px)]
*/
@media (min-width: 768px) and (max-width: 992px) {
	.home .box-vertical-megamenus .vertical-menu-content{
		display: none;
	}
	.vertical-megamenus-ontop .box-vertical-megamenus .vertical-menu-content{
		display: block;
	}
	.top-header a {
	    border-right: 1px solid #E0E0E0;
	    padding-right: 5px;
	    margin-left: 5px;
	}
	.main-header .logo{
		width: 100%;
		text-align: center;
	}
	.main-header .header-search-box{
		padding-left: 30px;
		padding-right: 15px;
	}
	.main-header .shopping-cart-box{
		margin-left: 0;
		width: 37.667%;
	}
	.box-vertical-megamenus{
		padding-bottom: 0;
	}
	.box-vertical-megamenus .vertical-menu-content {
		min-width: 270px;
		display: none;
	}
	.nav-menu .nav > li > a {
	    padding: 15px 5px;
	}
	#home-slider .slider-left{
		height: 3px;
	}
	.header-top-right .header-banner{
		display: none;
	}
	.header-top-right {
	    margin-left: 0;
	    padding: 0 15px;
	    width: 100%;
	    border-top: none;
	}
	.header-top-right .homeslider .content-slide {
	    margin-right:0;
	}
	.service .service-item{
		padding: 0 10px;
	}
	.service .service-item .icon{
		width: 100%;
		text-align: center;
	}
	.service .service-item .info{
		width: 100%;
		padding-left: 0;
		text-align: center;
		margin-left: 0;
		margin-top: 50px;
	}
	.page-top .page-top-left{
		width: 100%;
	}
	.page-top .page-top-right{
		width: 100%;
		margin-top: 30px;
	}
	#trademark-list #payment-methods{
		width: 100%;
		float: left;
	}
	.category-banner{
		display: none;
	}
	.floor-elevator{
		display: none;
	}
	.show-brand .navbar-brand{
		padding: 0px 0px 0px 10px;
	}
	.header-top-right .homeslider {
		width: 100%;
	}
	.product-featured .banner-featured {
		display: none;
	}
	.product-featured .product-featured-content .product-featured-list{
		margin-left: 0;
	}
	.product-list.grid li{
		width: 50%;
	}
	.subcategories li a{
		padding: 0 10px;
	}
	#left_column .block .block_content{
		padding: 10px;
	}
	#left_column .block .title_block{
		font-size: 14px;
		padding-left: 10px;
	}
	.layered .layered_subtitle{
		font-size: 14px;
	}
	.check-box-list input[type="checkbox"] + label span.button{
		margin-right: 5px;
	}
	.special-product .special-product-left{
		width: 100%;
	}
	.special-product .special-product-right{
		margin-left: 0;
		margin-top: 10px;
	}
	.sortPagiBar .sort-product{
		margin-top: 20px;
	}
	.trademark-info{
		width: 100%;
		float: left;
		padding: 0 20px;
	}
	.trademark-product{
		width: 100%;
		float: left;
		padding: 0 20px;
	}
	.trademark-product .product-item {
		width: 50%;
	}
	.product-list li .product-star{
		float: left;
	}
	.product-tab .nav-tab>li{
		width: 100%;
		float: left;
		margin-bottom: 2px;
	}
	.product-tab .nav-tab>li>a {
		width: 100%;
	}
	.product-tab .nav-tab>li.active>a{
		height: 48px;
	}
	.product-tab .tab-container {
		margin-top: 2px;
	}
	#product .pb-right-column .product-comments .comments-advices a{
		padding: 0 5px;
	}
	.products-block .products-block-left{
		width: 100%;
	}
	.products-block .products-block-right{
		margin:0;
		width: 100%;
	}
	/** MAIN MENU **/
	#main-menu .navbar .navbar-nav>li>a {
		padding: 0 5px;
	}
	.box-products .box-product-content .box-product-adv {
		display: none;
	}
	.box-products .box-product-content .box-product-list{
		width: 100%;
		margin: 0;
	}
	.hot-deals-box .hot-deals-tab-content-col{
		padding-left: 15px;
	}
	.hot-deals-box .hot-deals-tab-content{
		padding: 30px;
	}
}
/*--------------------
[4. Styles for devices(>=481px and <=767px)]
*/
@media (min-width: 481px) and (max-width: 767px) { 
	.home .box-vertical-megamenus .vertical-menu-content{
		display: none;
	}
	.category-featured>.nav-menu>.container{
		padding-left: 0;
	}
	.top-banner{
		display: none;
	}
	.top-header .nav-top-links,
	.top-header .user-info,
	.top-header .support-link{
		width: 100%;
		float: left;
	}
	.main-header .logo{
		text-align: center;
	}
	.main-header .header-search-box{
		width: 100%;
		padding-left: 15px;
		padding-right: 15px;
	}
	.main-header .header-search-box .form-inline .form-category{
		display: none;
	}
	.main-header .header-search-box .form-inline .input-serach {
	    width: calc(100% - 50px);
	    padding-top: 10px;
	}
	.main-header .shopping-cart-box{
		padding-left: 15px;
		padding-right: 15px;
		margin-left:0; 
		width: 100%;
	}
	#box-vertical-megamenus{
		width: 50%;
		height: 50px;
		float: left;
	}
	#box-vertical-megamenus .box-vertical-megamenus{
		right: 0px;
		padding-bottom:0;
	}
	.box-vertical-megamenus{
	}
	.box-vertical-megamenus .vertical-menu-content{
		border-right: 1px solid #eee;
		display: none;
	}
	 .box-vertical-megamenus .vertical-menu-content ul li:hover .vertical-dropdown-menu {
	  visibility: hidden;
	  display: none;
	}
	.box-vertical-megamenus .vertical-menu-content ul li a.parent:before {
		display: none;
	} 
	.popular-tabs .nav-tab li{
		padding: 0;
	}
	#home-slider .header-banner{
		display: none;
	}
	#home-slider .header-top-right{
		padding-right: 15px;
		padding-left: 15px;
		margin: 0;
		border-top: none;
	}
	.header-top-right .homeslider{
		width: 100%;
	}
	#home-slider .header-top-right .homeslider .content-slide{
		margin-right: 0;
	}
	#home-slider .slider-left{
		height: 3px;
	}
	.service{
		display: none;
	}
	.nav-menu .navbar-brand,
	.nav-menu .toggle-menu{
		display: block;
	}
	.nav-menu .navbar-collapse{
		position: absolute;
		left: 0px;
		right: 0px;
		top: 50px;
		margin-right: 0;
		margin-left: 0;
		padding: 0 15px;
	}
	.nav-menu .navbar-collapse{
		margin-top: 0;
	}
	.nav-menu .nav>li>a {
		padding: 5px 15px;
	}
	.nav-menu .navbar-brand{
		padding-left: 30px;
	}
	.popular-tabs .nav-tab li{
		width: 100%;
		float: left;
	}{
		min-height: 480px;
	}
	.container{
		padding-left: 15px;
		padding-right: 15px;
	}
	.floor-elevator {
		display: none;
	}
	.category-banner{
		display: none;
	}
	.product-featured .banner-featured{
		display: none;
	}
	.product-featured .product-featured-content .product-featured-list{
		margin-left: 0;
	}
	.banner-bottom{
		display: none;
	}
	.trademark-info{
		padding-left: 30px!important;
		padding-right: 30px!important;
	}
	.trademark-product .image-product {
    	width: 40%;
	}
	.trademark-product .info-product{
		padding-left: 10px;
	}
	.page-top-right{
		margin-top: 30px;
	}
	.main-header .shopping-cart-box:hover .cart-block {
	  opacity: 0;
	  visibility: hidden;
	}
	.product-featured .product-featured-content{
		width: 100%;
	}
	.popular-tabs .owl-controls{
		top: -15px;
	}
	.category-slider{
		margin-top: 30px;
	}
	.subcategories li a{
		padding: 0 10px;
	}
	.popular-tabs .owl-controls .owl-next,
	.popular-tabs .owl-controls .owl-prev{
		top: -15px;
	}
	.brand-showcase-box .brand-showcase-logo .owl-controls{
	}
	.center_column{
		margin-top: 30px;
	}
	#product .pb-right-column{
		margin-top: 30px;
	}
	.product-tab .nav-tab>li{
		width: 100%;
		float: left;
		margin-bottom: 2px;
	}
	.product-tab .nav-tab>li>a {
		width: 100%;
	}
	.product-tab .nav-tab>li.active>a{
		height: 48px;
	}
	.product-tab .tab-container {
		margin-top: 2px;
	}
	.product-list li .product-star {
		float: left;
	}
	.breadcrumb{
		line-height: 20px;
	}
	.breadcrumb .navigation-pipe:before{
		padding: 0;
	}
	/** MAIN MENU **/
	#main-menu .navbar-header {
	  display: block;
	  margin: 0;
	  background: #ff3366;
	  color: #fff;
	  margin-left: 15px;
	}
	#main-menu .navbar-header .navbar-brand {
		padding: 0;
		padding-left: 10px;
		line-height: 50px;
		color: #fff;
		font-size: 14px;
		font-weight: bold;
	}
	#main-menu .navbar-header .fa{
		line-height: inherit;
		color: #fff;
		font-size: 17px;
	}
	#main-menu .navbar-header .navbar-toggle{
		border: none;
		padding: 0;
		margin-top: 12px;
	}
	#main-menu .navbar-default .navbar-toggle:focus,
	#main-menu .navbar-default .navbar-toggle:hover{
		background: none;
	}
	#main-menu .navbar-collapse{
		padding: 0 15px;
		margin-left: 15px;
		margin-right: 0px;
		background: #eee;
	}
	#main-menu .container-fluid{
		padding-right: 15px;
  		padding-left: 15px;
	}
	#main-menu .navbar-collapse.in{
		overflow-y:inherit;
	}
	#main-menu .navbar .navbar-nav>li{
		border-bottom: 1px solid #cacaca;
	}
	#main-menu .navbar .navbar-nav>li:hover,
	#main-menu .navbar .navbar-nav>li.active{
		background: none;
	}
	#main-menu .navbar .navbar-nav>li>a{
		margin: 0;
		padding: 10px;
		border-right: none;
		position: relative;
	}
	#main-menu .navbar .navbar-nav>li:hover>a, 
	#main-menu .navbar .navbar-nav>li.active>a {
	  color: #333;
	  border-right: 1px solid transparent;
	}
	#main-menu .dropdown-menu{
		position: inherit;
		opacity: 1;
		visibility: inherit;
		display: none;
	}
	#main-menu li.dropdown>a:after{
		position: absolute;
		top: 9px;
		right: 10px;
	}
	#main-menu .dropdown.open >.dropdown-menu{
		display: block;
	}
	#main-menu li.dropdown:before{
		display: none;
	}
	#main-menu li.dropdown:hover:before{
		display: none;
	}
	#main-menu .navbar-nav > li> .mega_dropdown {
		  -webkit-transform: translate(0,0);
		  -moz-transform: translate(0,0);
		  -o-transform: translate(0,0);
		  -ms-transform: translate(0,0);
		  transform: translate(0,0);
		  width: 100%!important;
		  left: 0!important;
		  top: 0;
  		  padding: 15px 0;
  		  border: 1px solid #eee;
	}
	#main-menu .dropdown-menu{
		border: 1px solid #eee;
	}
	#main-menu .dropdown-menu.container-fluid {
	  padding: 15px;
	  border: 1px solid #eee;
	}
	#footer2 .footer-top .footer-menu li{
		display: block;
		width: 100%;
		line-height: 30px;
	}
	#footer2 .footer-top .footer-social{
		margin-top: 20px;
		float: left;
	}
	#footer2 .footer-row .form-subscribe {
		width: auto;
	}
	#footer2 .footer-row .form-subscribe .form-group{
		margin-bottom: 0;
	}
	#footer2 .footer-row{
		padding: 20px 0;
	}
	#footer2 .widget-body{
		padding-bottom: 20px;
	}
	#footer2 .widget-title{
		padding-bottom: 10px;
	}
	#footer2 .footer-bottom .footer-payment-logo{
		float: left;
		margin-top: 10px;
	}
	.hot-deals-box .hot-deals-tab .hot-deals-tab-box{
		padding: 10px;
	}
	.hot-deals-box .hot-deals-tab-content-col {
		padding-left: 15px;
	}
	.hot-deals-box .hot-deals-tab-content{
		padding: 10px;
	}
	.box-products .box-product-head{
		float: left;
		height: auto;
		width: 100%;
	}
	.box-products .box-tabs{
		float: left;
		margin-top: 10px;
	}
	.box-products .box-tabs>li{
		display: block;
		width: 100%;

	}
	.box-products .box-tabs li>a{
		border: none;
		padding: 0;
	}
	.box-products .box-product-head .box-title{
		padding-left: 0;
		width: 100%;
		float: left;
	}
	.box-products .box-tabs li>a:before{
		left: 0;
		right: 0;
	}
	.box-products .box-product-content .box-product-adv{
		display: none;
	}
	.box-products .box-product-content .box-product-list {
		margin-left: 0;
		float: left;
		overflow: hidden;
		width: 100%;
	}
}
/*--------------------
[5. Styles for devices(<=480px)]
*/
@media (max-width: 480px) {
	.top-banner{
		display: none;
	}
	.top-header .nav-top-links,
	.top-header .user-info,
	.top-header .support-link{
		width: 100%;
		float: left;
	}
	.main-header .logo{
		text-align: center;
		margin-top: 10px;
	}
	.main-header .header-search-box{
		width: 100%;
		padding-left: 15px;
		padding-right: 15px;
		margin-top: 30px;
	}
	.main-header .header-search-box .form-inline .form-category{
		display: none;
	}
	.main-header .header-search-box .form-inline .input-serach {
	    width: calc(100% - 50px);
	    padding-top: 10px;
	}
	.main-header .shopping-cart-box{
		padding-left: 15px;
		padding-right: 15px;
		margin-left:0; 
		width: 100%;
		margin-top: 30px;
	}
	.nav-top-menu{
		background: transparent;
	}
	#box-vertical-megamenus{
		width: 50%;
		height: 50px;
		float: left;
	}
	#box-vertical-megamenus .box-vertical-megamenus{
		right: 0px;
		padding-bottom:0;
	}
	.box-vertical-megamenus .vertical-menu-content{
		border-right: 1px solid #eee;
		display: none;
	}
	.box-vertical-megamenus .title{
		color: #fff;
		padding-left: 10px;
		padding-right: 10px;
	}
	#box-vertical-megamenus .vertical-menu-content{
		min-width: 290px;
		display: none;
	}
	.box-vertical-megamenus .vertical-menu-content ul li:hover .vertical-dropdown-menu {
	  visibility: hidden;
	  display: none;
	}
	.box-vertical-megamenus .vertical-menu-content ul li a.parent:before {
		display: none;
	}
	.popular-tabs .nav-tab li{
		padding: 0;
	}
	#home-slider .header-banner{
		display: none;
	}
	#home-slider .header-top-right{
		padding-right: 15px;
		padding-left: 15px;
		margin: 0;
		border-top: none;
	}
	.header-top-right .homeslider{
		width: 100%;
	}
	#home-slider .header-top-right .homeslider .content-slide{
		margin-right: 0;
	}
	#home-slider .slider-left{
		height: 3px;
	}
	.service{
		display: none;
	}
	.nav-menu .navbar-brand,
	.nav-menu .toggle-menu{
		display: block;
	}
	.nav-menu .navbar-collapse{
		position: absolute;
		right: 0px;
		top: 50px;
		margin-right: 0;
		margin-left: 0;
		padding: 0 15px;
		left: 0;
		right: 0;
	}
	.nav-menu .navbar-collapse>ul{
		margin-top: 0;
	}
	.nav-menu .navbar-brand{
		margin-left: -10px;
	}
	.popular-tabs .nav-tab li{
		width: 100%;
		float: left;
	}
	.page-top-right{
		margin-top: 30px;
	}
	.content-page{
		margin-top: 0;
	}
	.container{
		padding-left: 15px;
		padding-right: 15px;
	}
	.floor-elevator {
		display: none;
	}
	.category-banner{
		display: none;
	}
	.product-featured .banner-featured{
		display: none;
	}
	.product-featured .product-featured-content .product-featured-list{
		margin-left: 0;
	}
	.product-featured .product-featured-content{
		width: 100%;
	}
	.banner-bottom{
		display: none;
	}
	.trademark-info{
		padding-left: 30px!important;
		padding-right: 30px!important;
	}
	.trademark-product .image-product {
    	width: 40%;
	}
	.trademark-product .info-product{
		padding-left: 10px;
	}
	#introduce-box {
	    margin-top: 30px;
	}
	#introduce-box .introduce-title{
		margin-top: 30px;
	}
	#trademark-list #payment-methods{
		display: block;
		width: 100%;
	}
	.product-list li .product-star{
		float: left;
		width: 100%;
		text-align: left;
	}
	.product-list li .content_price {
		float: left;
		width: 100%;
	}
	.latest-deals{
		padding-bottom: 15px;
	}
	.main-header .shopping-cart-box:hover .cart-block {
	  opacity: 0;
	  visibility: hidden;
	}
	.category-featured>.nav-menu>.container{
		padding-left: 0;
	}
	.category-slider{
		margin-top: 30px;
	}
	.category-slider .owl-controls .owl-prev, 
	.category-slider .owl-controls .owl-next {
	  width: 20px;
	  height: 20px;
	  color: #fff;
	  text-align: center;
	  padding-top: 3px;
	}
	.subcategories li.current-categorie {
	  width: 100%;
	}
	.subcategories li.current-categorie a{
		width: 100%;
		text-align: center;
	}
	.subcategories li.current-categorie:after{
		right: 50%;
		  content: "\f0d7";
		  top: 36px;
	}
	.subcategories li{
		width: 100%;
	}
	.subcategories li a{
		width: 100%;
		padding: 0 10px;
	}
	.sortPagiBar .sort-product, .sortPagiBar .show-product-item{
		margin-top: 20px;
	}
	.product-list.list .left-block {
		width: 100%;
		position: relative;
	}
	.product-list.list .right-block{
		width: 100%;
	}
	.product-list.list .add-to-cart{
		bottom: 0;
		left: 0;
		width: 50%;
		top: inherit;
	}
	.product-list.list .quick-view{
		bottom: 0;
		right: 0;
		top: inherit;
	}
	.nav-menu .nav>li>a {
		padding: 5px 15px;
	}
	.popular-tabs .owl-controls .owl-next,
	.popular-tabs .owl-controls .owl-prev{
		top: -15px;
	}
	.brand-showcase-box .brand-showcase-logo .owl-controls{
	}
	.center_column{
		margin-top: 30px;
	}
	#product .pb-right-column{
		margin-top: 30px;
	}
	.product-tab .nav-tab>li>a{
		padding: 0 10px;
	}
	.product-list li .product-star {
		float: left;
	}
	.product-tab .nav-tab>li{
		width: 100%;
		float: left;
		margin-bottom: 2px;
	}
	.product-tab .nav-tab>li>a {
		width: 100%;
	}
	.product-tab .nav-tab>li.active>a{
		height: 48px;
	}
	.product-tab .tab-container {
		margin-top: 2px;
	}
	#product .pb-right-column .product-comments .comments-advices a{
		width: 100%;
		float: left;
		padding: 0;
	}
	.breadcrumb{
		line-height: 20px;
	}
	.breadcrumb .navigation-pipe:before{
		padding: 0;
	}
	/** MAIN MENU **/
	#main-menu .navbar-header {
	  display: block;
	  margin: 0;
	  background: #ff3366;
	  color: #fff;
	  margin-left: 15px;
	}
	#main-menu .navbar-header .navbar-brand {
		padding: 0;
		padding-left: 10px;
		line-height: 50px;
		color: #fff;
		font-size: 14px;
		font-weight: bold;
	}
	#main-menu .navbar-header .fa{
		line-height: inherit;
		color: #fff;
		font-size: 17px;
	}
	#main-menu .navbar-header .navbar-toggle{
		border: none;
		padding: 0;
		margin-top: 12px;
	}
	#main-menu .navbar-default .navbar-toggle:focus,
	#main-menu .navbar-default .navbar-toggle:hover{
		background: none;
	}
	#main-menu .navbar-collapse{
		padding: 0 15px;
		margin-left: 15px;
		margin-right: 0px;
		background: #eee;
	}
	#main-menu .container-fluid{
		padding-right: 15px;
  		padding-left: 15px;
	}
	#main-menu .navbar-collapse.in{
		overflow-y:inherit;
	}
	#main-menu .navbar .navbar-nav>li{
		border-bottom: 1px solid #cacaca;
	}
	#main-menu .navbar .navbar-nav>li:hover,
	#main-menu .navbar .navbar-nav>li.active{
		background: none;
	}
	#main-menu .navbar .navbar-nav>li>a{
		margin: 0;
		padding: 10px;
		border-right: none;
		position: relative;
	}
	#main-menu .navbar .navbar-nav>li:hover>a, 
	#main-menu .navbar .navbar-nav>li.active>a {
	  color: #333;
	  border-right: 1px solid transparent;
	}
	#main-menu .dropdown-menu{
		position: inherit;
		opacity: 1;
		visibility: inherit;
		display: none;
	}
	#main-menu li.dropdown>a:after{
		position: absolute;
		top: 9px;
		right: 10px;
	}
	#main-menu .dropdown.open >.dropdown-menu{
		display: block;
	}
	#main-menu li.dropdown:before{
		display: none;
	}
	#main-menu li.dropdown:hover:before{
		display: none;
	}
	#main-menu .navbar-nav > li> .mega_dropdown {
		  -webkit-transform: translate(0,0);
		  -moz-transform: translate(0,0);
		  -o-transform: translate(0,0);
		  -ms-transform: translate(0,0);
		  transform: translate(0,0);
		  width: 100%!important;
		  left: 0!important;
		  top: 0;
  		  padding: 15px 0;
  		  border: 1px solid #eee;
	}
	#main-menu .dropdown-menu{
		border: 1px solid #eee;
	}
	#main-menu .dropdown-menu.container-fluid {
	  padding: 15px;
	  border: 1px solid #eee;
	}
	.page-heading{
		font-size: 16px;
	}
	.page-heading span{
		padding: 0;
	}
	.page-order ul.step li{
		width: 100%;
		display:block;
		text-align: left;
		border-bottom: none;
		border-left: 3px solid #eee;
		padding-left: 20px;
		margin-top: 10px;
	}
	.page-order ul.step li.current-step{
		border-left: 3px solid #ff3366;
		border-bottom: none;
	}
	#footer2 .footer-top .footer-menu li{
		display: block;
		width: 100%;
		line-height: 30px;
	}
	#footer2 .footer-top .footer-social{
		margin-top: 20px;
		float: left;
	}
	#footer2 .footer-row .form-subscribe {
		width: auto;
	}
	#footer2 .footer-row .form-subscribe .form-group{
		margin-bottom: 0;
	}
	#footer2 .footer-row{
		padding: 20px 0;
	}
	#footer2 .widget-body{
		padding-bottom: 20px;
	}
	#footer2 .widget-title{
		padding-bottom: 10px;
	}
	#footer2 .footer-bottom .footer-payment-logo{
		float: left;
		margin-top: 10px;
	}
	.box-products .box-product-head{
		float: left;
		height: auto;
	}
	.box-products .box-product-head .box-title{
		float: left;
		width: 100%;
	}
	.box-products .box-tabs{
		float: left;
		margin-top: 10px;
	}
	.box-products .box-tabs>li{
		display: block;
		width: 100%;

	}
	.box-products .box-tabs li>a{
		border: none;
		padding: 0;
	}
	.box-products .box-product-head .box-title{
		padding-left: 0;
	}
	.box-products .box-tabs li>a:before{
		left: 0;
		right: 0;
	}
	.box-products .box-product-content .box-product-adv{
		display: none;
	}
	.box-products .box-product-content .box-product-list {
		margin-left: 0;
		float: left;
		overflow: hidden;
		width: 100%;
	}
	.hot-deals-box .hot-deals-tab .hot-deals-tab-box{
		padding: 10px;
	}
	.hot-deals-box .hot-deals-tab-content-col {
		padding-left: 15px;
	}
	.hot-deals-box .hot-deals-tab-content{
		padding: 10px;
	}
}
*{margin:0;padding:0;border:none;}article,aside,audio,canvas,command,datalist,details,embed,figcaption,figure,footer,header,hgroup,keygen,meter,nav,output,progress,section,source,video,main{display:block}mark,rp,rt,ruby,summary,time{display:inline}a, abbr, acronym, address, applet, article, aside, audio,b, blockquote, big, body,center, canvas, caption, cite, code, command,datalist, dd, del, details, dfn, dl, div, dt, em, embed,fieldset, figcaption, figure, font, footer, form, h1, h2, h3, h4, h5, h6, header, hgroup, html,i, iframe, img, ins,kbd, keygen,label, legend, li, meter,nav,object, ol, output,p, pre, progress,q, s, samp, section, small, span, source, strike, strong, sub, sup,table, tbody, tfoot, thead, th, tr, tdvideo, tt,u, ul, var{background: transparent;border: 0 none;font-weight: inherit;margin: 0;padding: 0;border: 0;outline: 0;vertical-align: top;}a{text-decoration:none;outline: none !important;}b, strong{font-weight:bold !important;}ul,ol{list-style: none;}q {quotes: none;}table, table td { padding:0;border:none;border-collapse:collapse;}img{vertical-align:top; max-width:100%;}embed{ vertical-align:top;}input,textarea{font-family:inherit;}input,button{outline: none;background:transparent;}button::-moz-focus-inner{border:0;}th{text-align:left;}textarea{outline:none !important;}.clearfix::after{content:""; display: block; clear:both;}button{cursor: pointer;}#_atssh{display: none !important;}

/*------------------------------------------------------------------
[Table of contents]

1. Group button on top menu
2. Latest deals products
3. Products list
4. Header
5. Category featured
6. Banner bottom
7. Blogs
8. Services
9. Footer
10. Owl carousel vertical
11. Styles for devices(>1200px)
12. Styles for devices(>=992px and <=1199px)
13. Styles for devices(>=768px and <=992px)
14. Styles for devices(>=481px and <=767px)
15. Styles for devices(<=480px)

-------------------------------------------------------------------*/
.option6 span.notify-right{
	background: url('../images/notify-right-6.png') no-repeat;
}
.option6 #main-menu .navbar .navbar-nav>li>a span.notify-right{
	top: -20px;
	left: 40%;
	text-transform: uppercase;
}
/*-------------------
[2. Latest deals products]
*/
.latest-deals-product{
  margin-top: 20px;
  position: relative;
}
.latest-deals-product .count-down-time2{
  position: absolute;
  top: -61px;
  right: 80px;
}
.latest-deals-product .product-list li{
  border: 1px solid #eaeaea;
  overflow: hidden;
  padding-bottom: 5px;
}
.latest-deals-product .product-list li:hover{
  border: 1px solid #007176;
}
.latest-deals-product .owl-next{
  top: -40px;
}
.latest-deals-product .owl-prev{
  top: -40px;
  left: inherit;
  right: 26px;
}

.count-down-time2{
  text-transform: uppercase;
  font-size: 14px;
  font-weight: normal;
  line-height: 40px;
}
.count-down-time2 .icon-clock{
  width: 23px;
  height: 26px;
  background: url("../images/icon-clock.png") no-repeat center center;
  display: inline-block;
  margin-top: 5px;
}
.count-down-time2 .box-count{
  text-transform: none;
  color: #007176;
  border: 1px solid #007176;
  height: 30px;
  line-height: 30px;
  display: inline-block;
  padding: 0 10px;
  margin-top: 4px;
  margin-right: 4px;
  margin-left: 4px;
}


/*
[3. Products list]
*/
.option6 .product-list li .quick-view{
	right: 10px;
}
.option6 .product-list li .quick-view a:hover{
	background: #007176;
}
.option6 .product-list li .quick-view a:hover{
	background: #007176;
}
.option6 .product-list li .quick-view a:hover {
	background: #007176;
}
.option6 .product-list li .add-to-cart:hover{
	background: #007176;
}
.option6 .product-list li .product-price {
	color: #f96d10;
}


/*
[4. Header ]
*/
.option6 .header{
	background: #008a90;
}
.option6 .nav-top-menu{
	background: transparent;
}
.option6 .top-header img {
	margin-top: -5px;
}
.option6 .top-header a.current-open:after{
	font-size: 13px;
}
.option6 .top-header{
	background: #007176;
	font-size: 13px;
	color: #fff;
}
.option6 .top-header a{
	color: #fff;
}
.option6 .top-header a:hover{
	color: #ccc;
}
.option6 .cart-block{
	margin-top: 5px;
}
.option6 .cart-block .cart-block-content .product-info .p-right .p-rice{
	  color:#f96d10;
}
.option6 #shopping-cart-box-ontop .cart-block{
	margin-top: 0;
}
.option6 a:hover{
	color: #007176;
}
.option6 .top-header .dropdown-menu{
	border-top: 2px solid #007176;
}
.option6 .top-header .dropdown-menu a{
	color: #333;
}
.option6 .main-header .header-search-box{
	padding: 0 15px;
	padding-left: 40px;
}
.option6 .main-header .header-search-box .form-inline .form-category{
	float: right;
	margin-right: 40px;
	border-left: 1px solid #008a90;
	height: 41px;
	background: #00abb3;
	color: #fff;
}
.option6 .main-header .header-search-box .form-inline .btn-search{
	top: 0;
	right: 0;
}
.option6 .main-header .header-search-box .form-inline .input-serach{
	padding-top: 9px;
}.option6 .header-search-box form .input-serach input{
	color: #fff;
}
.option6 .header-search-box form .input-serach input::-webkit-input-placeholder { color:#fff; }
.option6 .header-search-box form .input-serach input::-webkit-input-placeholder { color:#fff;  }
.option6 .header-search-box form .input-serach input::-webkit-input-placeholder { color:#fff; }

.option6 .main-header .header-search-box .form-inline .btn-search{
	color: #fff;
	font-size: 16px;
	background-color: #007176;
}
.option6 .select2-container--default .select2-selection--single .select2-selection__rendered{
	color: #fff;
}
.option6 .select2-container--default .select2-selection--single .select2-selection__arrow b{
	border-color: #fff transparent transparent transparent;
}
.option6 .main-header .header-search-box .form-inline{
	border: none;
	background: #00abb3;
	color: #fff;
	display: inline-block;
	min-width: 470px;
}
.option6 .main-header .header-search-box .keyword{
	display: inline-block;
	color: #fff;
	font-size: 13px;
	line-height: 21px;
	float: right;
}
.option6 .main-header .header-search-box .keyword a{
	color: #fff;
}
.option6 .main-header .header-search-box .keyword .lebal{
	text-decoration: underline;
	font-weight: bold;
}
.option6 .main-header .header-search-box .keyword .lebal:before{
	content: '';
	width: 5px;
	height: 5px;
	background: #fff;
	float: left;
	margin-right: 10px;
	margin-top: 9px;
}
.option6 .main-header .header-search-box .form-inline .btn-search .fa{
	line-height: inherit;
}
.option6 .group-button-header .btn-cart{
	background: url("../images/icon-cart-round6.png") no-repeat center center;
}
.option6 .group-button-header .btn-heart{
	  background: url("../images/icon-heart-round6.png") no-repeat center center;
}
.option6 .group-button-header .btn-compare{
	background: url("../images/icon-compare-round6.png") no-repeat center center;
}

.option6 .nav-top-menu.nav-ontop{
	background: #007176;
	height: 51px;
}
.option6 .nav-top-menu.nav-ontop .navbar-right{
	display: none;
}
.option6 #form-search-opntop .btn-search .fa{
	display: none;
}
.option6 #box-vertical-megamenus{
	width: 85px;
	padding: 0;
}

.option6 #main-menu .navbar{
	border-radius: 0;
	background: #007176;
}
.option6 #main-menu .navbar-default .navbar-nav>li>a{
	color: #fff;
	border-right: none;
}
.option6 #main-menu .navbar-default .navbar-nav>li:last-child>a{
	background: none;
}
.option6 #main-menu .navbar .navbar-nav>li:hover, 
.option6 #main-menu .navbar .navbar-nav>li.active{
	background-image: none;
	background: #00abb3;
}
.option6 #main-menu .navbar .navbar-nav>li:hover a, 
.option6 #main-menu .navbar .navbar-nav>li.active a{
	background: none;
}
.option6 #main-menu li.dropdown>a:after{
	position: absolute;
	left: 46%;
	-ms-transform: translateX(-50%);
  	-webkit-transform: translateX(-50%);
  	transform: translateX(-50%);
	top: 15px;
	font-size: 12px;
}
.option6 #main-menu li.dropdown:hover:before{
	display: none;
}

.option6 .box-vertical-megamenus .title{
	background: #000;
}
.option6 .box-vertical-megamenus .vertical-menu-content{
	border-top: none;
	min-width: 270px;
	border-right: 1px solid #eaeaea;
}
.option6 #main-menu{
	width: 100%;
	padding: 0 15px;
	margin: 0;
	padding-left: 70px;
}
.option6 .box-vertical-megamenus{
	top: 1px;
}
.option6 .nav-ontop #box-vertical-megamenus .title{
	background: #000;
	color: #fff;
	border-left: none;
	text-align: center;
	height: 51px;

}
.option6 .nav-ontop #box-vertical-megamenus .title .btn-open-mobile{
	margin: 0;
}
.option6 .nav-ontop #box-vertical-megamenus .box-vertical-megamenus{
	top: 0;
}
.option6 #form-search-opntop .btn-search:before{
	color: #fff;
}
.option6 #form-search-opntop form .input-serach input{
	color: #fff;
}
.option6 #form-search-opntop form .input-serach input::-webkit-input-placeholder { color:#fff; }
.option6 #form-search-opntop form .input-serach input::-webkit-input-placeholder { color:#fff;  }
.option6 #form-search-opntop form .input-serach input::-webkit-input-placeholder { color:#fff; }

.option6 #form-search-opntop:hover form{
  border: 1px solid #dfdfdf;
  background: #007176;
}
.option6 #user-info-opntop a.current-open:before {
  color: #fff;
}
.option6 #shopping-cart-box-ontop .fa{
	color: #fff;
}
.option6 .header-top-right{
	border-top: none;
	margin: 0;
	padding: 0 15px;
}
.option6 .header-top-right .homeslider {
	width: 63.5%;
}
.option6 .group-banner-slider .item{
	margin-bottom: 2px;
}
.option6 .group-banner-slide .col-left{
	width: 196px;
	float: left;
}
.option6 .group-banner-slide .col-right{
	width: 228px;
	float: left;
}
.option6 .group-banner-slide .item{
	margin-left: 1px;
	float: left;
	margin-bottom: 2px;
}
.option6 .group-banner-slide .item:last-child{
	margin-bottom: 0;
}
.option6  .policy{
	background: #e1e9ee;
}
.option6 .policy .title{
	height: 34px;
	background: #cfd5da;
	border-left: 5px solid #008a90;
	line-height: 34px;
	font-size: 16px;
	font-weight: bold;
	color: #006379;
	text-transform: uppercase;
	padding-left: 8px;
}
.option6 .policy ul{
	line-height: 24px;
	padding-left: 13px;
	padding-top: 10px;
	padding-bottom: 11px;
}
.option6 .link-buytheme .fa{
	line-height: inherit;
}
.option6 .group-banner-slide .col-right .item:last-child{
	margin-top: 1px;
}
.option6 .policy ul li{
	margin-bottom: 10px;
}
.option6 .policy a img{
	margin-right: 5px;
}
.option6 .policy a .icon2{
	display: none;
}
.option6 .policy a:hover .icon2{
	display: inline-block;
}
.option6 .policy a:hover .icon1{
	display: none;
}

.option6 .policy ul li:last-child{
	margin-bottom: 0;
}

.option6 .header-top-right .homeslider .bx-controls-direction .bx-prev, 
.option6 .header-top-right .homeslider .bx-controls-direction .bx-next{
	background: #007176;
}
.option6 .header-top-right .homeslider .bx-wrapper .bx-pager .bx-pager-item a{
	border-radius: 0;
	width: 24px;
	height: 24px;
	background-color: rgba(190,190,190, 0.7);
	color: #000;
	line-height: 24px;
	border: none;
	margin-right: 10px;
	display: block;
}
.header-top-right .homeslider .bx-wrapper .bx-pager .bx-pager-item{
	width: 34px;
	height: 24px;
	margin-right: 0;
}
.option6 .header-top-right .homeslider .bx-wrapper .bx-pager.bx-default-pager a:hover,
.option6 .header-top-right .homeslider .bx-wrapper .bx-pager.bx-default-pager a.active{
	background-color: rgba(0,0,0, 0.7);
	color: #fff;
}



.option6 .box-vertical-megamenus .vertical-menu-list {
	padding-top: 4px;
}
.option6 .box-vertical-megamenus .vertical-menu-list li{
	border: none;
	padding: 0 20px;
}
.option6 .box-vertical-megamenus .vertical-menu-list>li:hover{
	background: #007176;
}
.option6 .box-vertical-megamenus .vertical-menu-list>li:hover>a{
	color: #fff;
	border-color: transparent;
}
.option6 .box-vertical-megamenus .vertical-menu-list>li:hover>a:before{
	color: #fff;
}
.option6 .box-vertical-megamenus .vertical-menu-list:li:last-child>a{
	border:none;
}
.option6 .box-vertical-megamenus .vertical-menu-list>li>a{
	border:none;
	padding-left: 0;
	border-bottom: 1px dotted #eaeaea;
	line-height: 36px;
}
.option6 .box-vertical-megamenus .vertical-menu-list li:hover{
	border-left: none;
}
.option6 .box-vertical-megamenus .vertical-menu-list li:hover>a{
	border-top: none;
}
.option6 .box-vertical-megamenus .all-category{
	margin-top: 0px;
	padding-right: 0;
}
.option6 .vertical-dropdown-menu .mega-group-header span{
	border-color: #007176;
}
.option6 .box-vertical-megamenus .all-category span:hover{
	background: #007176;
	color: #fff;
	border-color: #007176;
}
.option6 .box-vertical-megamenus .all-category span:after{
	  content: "\f101";
	  font-size: 16px;
	  font-weight: normal;
}
.option6 .box-vertical-megamenus .vertical-menu-content ul>li>a.parent:before{
	right: 20px;
}
.option6 .vertical-dropdown-menu .mega-products .mega-product .product-price .new-price{
	  color: #f96d10;
}
.option6 .cart-block .cart-block-content .cart-buttons a.btn-check-out{
	background: #007176;
}

.option6 .page-heading{
	font-size: 16px;
	font-weight: bold;
}
.option6 .page-heading span.page-heading-title{
	border-bottom: 3px solid #007176;
}

.option6 .owl-controls .owl-prev:hover, 
.option6 .owl-controls .owl-next:hover {
  background: #007176;
  color: #fff;
}

.option6 .content-page {
	background: #eaeaea;
}
.option6 #main-menu .dropdown-menu .block-container .group_header>a{
	border-color: #007176;
}

/*
[5. Category featured]
*/

.option6 .show-brand .navbar-brand{
	width: 200px;
	position: relative;
	padding-left: 10px;
	font-family: 'Arial Narrow', Arial, sans-serif;
	font-size: 22px;
	font-weight: normal;
}
.option6 .show-brand .navbar-brand img{
	margin-right: 10px;
}
.option6 .show-brand .navbar-brand>a:hover{
	color: #fff;

}
.option6 .show-brand .navbar-brand:after{
	content: '';
	width: 12px;
	height: 20px;
	position: absolute;
	right: 5px;
	color: #fff;
	font-weight: normal;
	background: url("../images/icon-angle-right.png") no-repeat right center;
	top: 50%;
	-ms-transform: translateY(-50%);
	-webkit-transform: translateY(-50%);
	transform: translateY(-50%);
}
.option6 .nav-menu{
	margin-bottom: 0;
}
.option6 .nav-menu .nav>li>a{
	background: none;
	padding: 14px 15px;
	margin-left: 10px;
}
.option6 .nav-menu .nav>li>a:after{
	font: normal normal normal 14px/1 FontAwesome;
	content: "\f0d8";
	position: absolute;
	bottom: -40px;
	left: 50%;
	-ms-transform: translateX(-50%);
	-webkit-transform: translateX(-50%);
	transform: translateX(-50%);
	color: #fff;
	-webkit-transition: all 0.3s ease-out 0s;
	  -moz-transition: all 0.3s ease-out 0s;
	  -o-transition: all 0.3s ease-out 0s;
	  transition: all 0.3s ease-out 0s;
	  opacity: 0;
	  visibility: hidden;
}
.option6 .nav-menu .nav>li>a:before{
	content: '';
	width: 100%;
	height: 1px;
	background: #fa8334;
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	transform: scale(0, 1);
}
.option6 .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #fa8334;
}
.option6 .nav-menu .nav>li:hover a,
.option6 .nav-menu .nav>li.active a{
}

.option6 .nav-menu .nav>li:hover a:before,
.option6 .nav-menu .nav>li.active a:before{
	transform: scale(1);
  -webkit-transition: all 0.3s ease-out 0s;
  -moz-transition: all 0.3s ease-out 0s;
  -o-transition: all 0.3s ease-out 0s;
  transition: all 0.3s ease-out 0s;
}
.option6 .nav-menu .nav>li:hover a:after,
.option6 .nav-menu .nav>li.active a:after{
	color: #fa8334;
	bottom: -6px;
	opacity: 1;
	visibility: inherit;
}

.option6 .product-featured{
	margin-top: 0;
	background: #fff;
}
.option6 .product-featured .sub-category-list{
	float: left;
	padding: 20px 30px;
	line-height: 30px;
}
.option6 .product-featured .product-featured-tab-content{
}
.option6 .product-featured .product-featured-tab-content .box-left{
	width: 40%;
	float: left;
	border-left: 1px solid #eaeaea;
}
.option6 .product-featured .product-featured-tab-content .box-right{
	width: 60%;
	float: left;
}
.option6 .product-featured .product-featured-tab-content .box-full{
	width: 100%;
	float: left;
	border-left: 1px solid #eaeaea;
} 
.option6 .product-featured .product-featured-tab-content .box-full .product-list li{
	width: 20%;
	float: left;
	border-bottom: none;
}
.option6 .product-featured .product-featured-tab-content .category-banner{
	padding-right: 0;
}
.option6 .product-featured .product-featured-tab-content .category-banner img{
	
}
.option6 .product-featured .product-featured-tab-content .category-list-product{
	padding-left: 0;
}
.option6 .product-featured .product-list{
	margin-left: 0;
	margin-right: 0;

}
.option6 .product-featured .product-list li{
	padding: 0;
	min-height: inherit;
	border-right: 1px solid #eaeaea;
	border-top: 1px solid #eaeaea;
	padding-bottom: 3px;
	min-height: 286px;
}

.option6 .product-featured .owl-prev, 
.option6 .product-featured .owl-next {
  background: transparent;
  width: 28px;
  height: 28px;
  color: #ccc;
  text-align: center;
  padding-top: 0;
  font-size: 48px;
}
.option6 .product-featured .owl-next{
	background: url("../images/next.png") no-repeat center center;
}
.option6 .product-featured .owl-prev{
	background: url("../images/prev.png") no-repeat center center;
}
.option6 .product-featured .owl-prev .fa, 
.option6 .product-featured .owl-next .fa{
	font-weight: normal;
	line-height: 28px;
	display: none;
}
.option6 .product-featured .owl-prev:hover{
	background: url("../images/prev.png") no-repeat center center;
}

.option6 .product-featured .owl-next:hover{
	background: url("../images/next.png") no-repeat center center;
}

.option6 .product-featured .deal-product{
	line-height: 24px;
	border-right: 1px solid #eaeaea;
	overflow: hidden;
	padding-bottom: 23px;
}
.option6 .product-featured .deal-product .deal-product-head{
	text-align: center;
}
.option6 .product-featured .deal-product .deal-product-head h3{
	position: relative;
    z-index: 1;
    margin-top: 15px;
}
.option6 .product-featured .deal-product .deal-product-head h3:before{
	border-top: 1px solid #eaeaea;
    content:"";
    margin: 0 auto; /* this centers the line to the full width specified */
    position: absolute; /* positioning must be absolute here, and relative positioning must be applied to the parent */
    top: 40%; left: 40px; right: 40px; bottom: 0;
    width: 95%;
    z-index: -1;
    width: 300px;/*
    -ms-transform: translateY(-50%);
  -webkit-transform: translateY(-50%);
  transform: translateY(-50%);*/
}
.option6 .product-featured .deal-product .deal-product-head h3>span{
	background: #fff; 
    padding: 0 5px; 
    font-size: 14px;
    font-weight: bold;
}
.option6 .product-featured .deal-product .deal-product-content .deal-product-info{
	padding-left: 0;
}
.option6 .product-featured .deal-product .deal-product-content{
	margin-top: 10px;
}
.option6 .product-featured .deal-product .price{
	margin-top: 4px;
}
.option6 .product-featured .deal-product .price span{
	margin-right: 10px;
}
.option6 .product-featured .deal-product .price .product-price{
	color: #007176;
	font-size: 18px;
}
.option6 .product-featured .deal-product .price .old-price{
	text-decoration: line-through;
}
.option6 .product-featured .deal-product .price .sale-price{
	background: url("../images/sale-bg.png") no-repeat;
	color: #fff;
	padding: 0 7px;
}
.option6 .product-featured .deal-product .product-star{
	color: #febf2b;
	margin-top: 15px;
}
.option6 .product-featured .deal-product .product-desc{
	margin-top: -3px;
}
.option6 .product-featured .deal-product .show-count-down{
	overflow: hidden;
	margin-top: 11px;
	font-family: 'Arial Narrow', Arial, sans-serif;
	line-height: normal;
}
.option6 .product-featured .deal-product .show-count-down .dot{
	display: none;
}
.option6 .product-featured .deal-product .show-count-down .box-count{
	font-size: 20px;
	color: #717171;
	background: #f6f6f6;
	text-align: center;
	width: 45px;
	height: 47px;
	display: table-cell;
	float: left;
	margin-right: 5px;
}
.option6 .product-featured .deal-product .show-count-down .box-count .number{
	width: 45px;
	font-size: 18px;
	display: table;
	margin-top: 4px;
}
.option6 .product-featured .deal-product .show-count-down .box-count .text{
	width: 45px;
	font-size: 14px;
	display: table;
}
.option6 .product-featured .manufacture-list{
	padding-right: 0;
	float: left;
	overflow: hidden;
}
.option6 .product-featured .manufacture-list .manufacture-waper{
	border: 1px solid #eaeaea;
	padding: 44px 0px 44px 0;
	border-top: none;
	position: relative;
	border-bottom: none;
}
.option6 .product-featured .manufacture-list .manufacture-waper ul{
	padding: 0 20px;
	background: #fff;
}

.option6 .product-featured .manufacture-list .manufacture-waper .owl-prev{
	position: absolute;
	top: -16px;
	left: 0;
	right: 0;
	border-bottom: 1px solid #eaeaea;
}
.option6 .product-featured .manufacture-list .manufacture-waper .owl-next{
	position: absolute;
	bottom: -64px;
	top: inherit;
	left: 0;
	right: 0;
	border-top: 1px solid #eaeaea;
	border-bottom: 1px solid #eaeaea;
	padding-top: 12px;
	height: 42px;
}
.option6 .product-featured .manufacture-list .manufacture-waper .owl-controls .owl-nav{
	margin: 0;
	padding: 0;
}
.option6 .product-list li .add-to-cart:hover{
	opacity: 1;
}
.option6 .product-list li .add-to-cart a {
	  background: url("../images/icon-cart-option2.png") no-repeat left center;
}
.option6 .product-list li .quick-view a.compare:before{
	  content: "\f066";
}

/** OPTION CATEGORY **/

.option6 .category-featured.fashion .sub-category-list a:hover{
	color: #ff3366;
}

.option6 .category-featured.fashion .navbar-brand{
	background: #ff3366;
}
.option6 .category-featured.fashion .navbar-brand a:hover{
	color: #fff;
}
.option6 .category-featured.fashion .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #ff3366;
}
.option6 .category-featured.fashion .nav-menu .nav>li:hover a,
.option6 .category-featured.fashion .nav-menu .nav>li.active a{
	color: #ff3366;
}

.option6 .category-featured.fashion .nav-menu .nav>li:hover a:after,
.option6 .category-featured.fashion .nav-menu .nav>li.active a:after{
	color: #ff3366;
}

.option6 .category-featured.fashion .nav-menu .nav>li>a:before{
	background: #ff3366;
}

.option6 .category-featured.fashion .product-list li .add-to-cart {
	background-color: rgba(255, 51, 102, 0.7);
	background: rgba(255, 51, 102, 0.7);
	color: rgba(255, 51, 102, 0.7);
}
.option6 .category-featured.fashion .product-list li .add-to-cart:hover {
	background: #ff3366;
}

.option6 .category-featured.fashion .product-list li .quick-view a.search:hover,
.option6 .category-featured.fashion .product-list li .quick-view a.compare:hover,
.option6 .category-featured.fashion .product-list li .quick-view a.heart:hover{
	background-color: #ff3366;
	opacity: 0.9;
}

/** sports **/
.option6 .category-featured.sports .sub-category-list a:hover{
	color: #00a360;
}
.option6 .category-featured.sports .navbar-brand{
	background: #00a360;
}
.option6 .category-featured.sports .navbar-brand a:hover{
	color: #fff;
}
.option6 .category-featured.sports .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #00a360;
}
.option6 .category-featured.sports .nav-menu .nav>li:hover a,
.option6 .category-featured.sports .nav-menu .nav>li.active a{
	color: #00a360;
}
.option6 .category-featured.sports .nav-menu .nav>li:hover a:after,
.option6 .category-featured.sports .nav-menu .nav>li.active a:after{
	color: #00a360;
}

.option6 .category-featured.sports .nav-menu .nav>li>a:before{
	background: #00a360;
}

.option6 .category-featured.sports .product-list li .add-to-cart {
	background-color: rgba(0, 163, 96, 0.7);
	background: rgba(0, 163, 96, 0.7);
	color: rgba(0, 163, 96, 0.7);
}
.option6 .category-featured.sports .product-list li .add-to-cart:hover {
	background: #00a360;
}
.option6 .category-featured.sports .product-list li .quick-view a.search:hover,
.option6 .category-featured.sports .product-list li .quick-view a.compare:hover,
.option6 .category-featured.sports .product-list li .quick-view a.heart:hover{
	background-color: #00a360;
	opacity: 0.9;
}

/** electronic **/

.option6 .category-featured.electronic .product-featured{
	background: #fff url('../images/cat-br1.png') no-repeat left bottom;
}
.option6 .category-featured.electronic .sub-category-list a:hover{
	color: #0090c9;
}
.option6 .category-featured.electronic .navbar-brand{
	background: #0090c9;
}
.option6 .category-featured.electronic .navbar-brand a:hover{
	color: #fff;
}
.option6 .category-featured.electronic .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #0090c9;
}
.option6 .category-featured.electronic .nav-menu .nav>li:hover a,
.option6 .category-featured.electronic .nav-menu .nav>li.active a{
	color: #0090c9;
}
.option6 .category-featured.electronic .nav-menu .nav>li>a:before{
	background: #0090c9;
}
.option6 .category-featured.electronic .nav-menu .nav>li:hover a:after,
.option6 .category-featured.electronic .nav-menu .nav>li.active a:after{
	color: #0090c9;
}

.option6 .category-featured.electronic .product-list li .add-to-cart {
	background-color: rgba(0, 144, 201, 0.7);
	background: rgba(0, 144, 201, 0.7);
	color: rgba(0, 144, 201, 0.7);
}
.option6 .category-featured.electronic .product-list li .add-to-cart:hover {
	background-color: #0090c9;
}
.option6 .category-featured.electronic .product-list li .quick-view a.search:hover,
.option6 .category-featured.electronic .product-list li .quick-view a.compare:hover,
.option6 .category-featured.electronic .product-list li .quick-view a.heart:hover{
	background-color: #0090c9;
	opacity: 0.9;
}
/** digital **/
.option6 .category-featured.digital .product-featured{
	background: #fff url('../images/cat-br2.png') no-repeat left bottom;
}
.option6 .category-featured.digital .sub-category-list a:hover{
	color: #3f5eca;
}
.option6 .category-featured.digital .navbar-brand{
	background: #3f5eca;
}
.option6 .category-featured.digital .navbar-brand a:hover{
	color: #fff;
}
.option6 .category-featured.digital .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #3f5eca;
}
.option6 .category-featured.digital .nav-menu .nav>li:hover a,
.option6 .category-featured.digital .nav-menu .nav>li.active a{
	color: #3f5eca;
}
.option6 .category-featured.digital .nav-menu .nav>li>a:before{
	background: #3f5eca;
}
.option6 .category-featured.digital .nav-menu .nav>li:hover a:after,
.option6 .category-featured.digital .nav-menu .nav>li.active a:after{
	color: #3f5eca;
}
.option6 .category-featured.digital .product-list li .add-to-cart {
	background-color: rgba(63, 94, 202, 0.7);
	background: rgba(63, 94, 202, 0.7);
	color: rgba(63, 94, 202, 0.7);
}
.option6 .category-featured.digital .product-list li .add-to-cart:hover {
	background-color: #3f5eca;
}
.option6 .category-featured.digital .product-list li .quick-view a.search:hover,
.option6 .category-featured.digital .product-list li .quick-view a.compare:hover,
.option6 .category-featured.digital .product-list li .quick-view a.heart:hover{
	background-color: #3f5eca;
	opacity: 0.9;
}
/** furniture **/
.option6 .category-featured.furniture .product-featured{
	background: #fff url('../images/cat-br3.png') no-repeat left bottom;
}
.option6 .category-featured.furniture .sub-category-list a:hover{
	color: #669900;
}
.option6 .category-featured.furniture .navbar-brand{
	background: #669900;
}
.option6 .category-featured.furniture .navbar-brand a:hover{
	color: #fff;
}
.option6 .category-featured.furniture .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #669900;
}
.option6 .category-featured.furniture .nav-menu .nav>li:hover a,
.option6 .category-featured.furniture .nav-menu .nav>li.active a{
	color: #669900;
}
.option6 .category-featured.furniture .nav-menu .nav>li>a:before{
	background: #669900;
}
.option6 .category-featured.furniture .nav-menu .nav>li:hover a:after,
.option6 .category-featured.furniture .nav-menu .nav>li.active a:after{
	color: #669900;
}

.option6 .category-featured.furniture .product-list li .add-to-cart {
	background-color: rgba(102, 153, 0, 0.7);
	background: rgba(102, 153, 0, 0.7);
	color: rgba(102, 153, 0, 0.7);
}
.option6 .category-featured.furniture .product-list li .add-to-cart:hover {
	background-color: #669900;
}

.option6 .category-featured.furniture .product-list li .quick-view a.search:hover,
.option6 .category-featured.furniture .product-list li .quick-view a.compare:hover,
.option6 .category-featured.furniture .product-list li .quick-view a.heart:hover{
	background-color: #669900;
	opacity: 0.9;
}

/** jewelry **/
.option6 .category-featured.jewelry .sub-category-list a:hover{
	color: #6d6855;
}
.option6 .category-featured.jewelry .navbar-brand{
	background: #6d6855;
}
.option6 .category-featured.jewelry .navbar-brand a:hover{
	color: #fff;
}
.option6 .category-featured.jewelry .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #6d6855;
}
.option6 .category-featured.jewelry .nav-menu .nav>li:hover a,
.option6 .category-featured.jewelry .nav-menu .nav>li.active a{
	color: #6d6855;
}
.option6 .category-featured.jewelry .nav-menu .nav>li>a:before{
	background: #6d6855;
}
.option6 .category-featured.jewelry .nav-menu .nav>li:hover a:after,
.option6 .category-featured.jewelry .nav-menu .nav>li.active a:after{
	color: #6d6855;
}
.option6 .category-featured.jewelry .product-list li .add-to-cart {
	background-color: #6d6855;
}
.option6 .category-featured.jewelry .product-list li .add-to-cart {
	background-color: rgba(109, 104,85, 0.7);
	background: rgba(109, 104,85, 0.7);
	color: rgba(109, 104,85, 0.7);
}
.option6 .category-featured.jewelry .product-list li .add-to-cart:hover {
	background-color: #6d6855;
}

.option6 .category-featured.jewelry .product-list li .quick-view a.search:hover,
.option6 .category-featured.jewelry .product-list li .quick-view a.compare:hover,
.option6 .category-featured.jewelry .product-list li .quick-view a.heart:hover{
	background-color: #6d6855;
	opacity: 0.9;
}
.option6 .band-logo{
	margin-top: 30px;
	overflow: hidden;
}
.option6 .band-logo a{
	float: left;
	background: #eee;
	border: 1px solid #eee;
	overflow: hidden;
	height: 66px;
}
.option6 .band-logo a:hover{
	background: transparent;
}

/*-----------------
[6. Banner bootom]
*/
.option6 .banner-bottom .item-left{
	padding-right: 0;
}
.option6 .banner-bottom .item-right{
	padding-left: 0;
}




/*--------------
[8. Services]
*/
.services2{
	margin-top: 30px;
	border-top: 1px solid #eaeaea;
	border-right: 1px solid #eaeaea;
	overflow: hidden;
}
.services2 .services2-item{
	padding: 0;
	border-left: 1px solid #eaeaea;
	border-bottom: 1px solid #eaeaea;
	padding-bottom: 15px;
	min-height: 120px;
}
.services2 .services2-item .image{
	text-align: center;
	color: #333333;
	padding-left: 30px;
	font-size: 14px;
	text-transform: uppercase;
	font-weight: normal;
}
.services2 .services2-item .image h3{
	font-size: 14px;
	color: #333333;
	font-weight: 600;
	margin-top: 10px;
}
.services2 .services2-item .text{
	padding-top: 15px;
	color: #919191;
	padding-left: 0;
	padding-right: 30px;

}


/*--------------
[9. Footer]
*/
.option6 #footer{
	margin-top: 60px;
}
.option6 #mail-box .btn{
	background: #007176;
}

.option6 .scroll_top:hover{
	background: #007176;
}


/*-----------------
[10. Owl carousel vertical]
*/
.owl-carousel-vertical .owl-next,
.owl-carousel-vertical .owl-prev{
	position: inherit;
	width: 100%!important;
	height: 17px;
	margin: 0 auto;
	float: left;
	opacity: 1;
	visibility: inherit;
	background: none;

}
.owl-carousel-vertical .owl-controls .owl-nav{
	margin: 0 auto;
	text-align: center;
	display: table-cell;
	width: 100%!important;
	float: left;
}

.option6 .product-featured .owl-carousel-vertical .owl-controls .owl-nav{
	margin-top: 26px;
	padding-left: 30px;
}
.option6 .product-featured .owl-carousel-vertical .owl-controls .owl-nav .owl-next,
.option6 .product-featured .owl-carousel-vertical .owl-controls .owl-nav .owl-prev{
	background: none;
}

.option6 .blog-list .blog-list-wapper ul li .readmore a{
	color: #007176;
}

.option6 .homeslider{
	position: relative;
}
.option6 .bx-control{
	position: absolute;
	bottom: 25px;
	right: 15px;
}
.option6 .bx-control .fa{
	line-height: inherit;
}
.option6 .bx-control a{
	width: 24px;
	height: 24px;
	background-color: rgba(190,190,190, 0.7);
	float: left;
	text-align: center;
	line-height: 24px;
	color: #000;
	margin-right: 10px;
}
.option6 .bx-control .bx-prev,
.option6 .bx-control .bx-next{
	color: #fff;
	font-weight: bold;
}
.option6 .bx-control .bx-prev:hover,
.option6 .bx-control .bx-next:hover{
	background: #008a90;
}
.option6 .bx-control a:hover,
.option6 .bx-control a.active{
	background-color: rgba(0,0,0, 0.7); 
	color: #fff;
}
.option6 .bx-control .slide-prev,
.option6 .bx-control .slide-next,
.option6 .bx-control .slide-pager{
	width: auto;
	display: inline-block;
	float: left;
}
/** REPONSIVE **/
/*----------------
[11. Styles for devices(>1200px)]
*/
@media (min-width: 1201px){
	
}
/*----------------
[12. Styles for devices(>=993px and <=1200px)]
*/
@media (min-width: 993px) and (max-width: 1200px) {
	.option6 .group-button-header{
		width: 25%;
		float: right;
	}
	.option6 .sub-category-wapper{
		width: 15%;
		display: none;
	}
	.option6 .col-right-tab{
		width: 100%;

	}
	.option6 .product-featured .manufacture-list .manufacture-waper{
		display: none;
	}
	.option6 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
	}
	.option6 .product-featured .product-featured-tab-content .category-list-product .product-list{
		border-left: 1px solid #eaeaea;
	}
	.option6 .main-header .header-search-box{
		width: 40%;
	}
	.option6 #home-slider .header-top-right .homeslider, 
	.option6 #home-slider .header-top-right .header-banner{
		border: none;
	}
	.option6 .main-header .header-search-box .keyword{
		display: none;
	}
	.option6 .header-top-right .homeslider{
		width: 100%;
	}
	.option6 .group-banner-slide{
		display: none;
	}
}
/*--------------------
[13. Styles for devices(>=768px and <=992px)]
*/
@media (min-width: 768px) and (max-width: 992px) {
	.option6 .group-button-header{
		float: right;
	}
	.option6 .main-header .logo{
		margin-top: 15px;
	}
	.option6 .nav-menu .nav>li>a{
		padding: 14px 10px;
		margin-left: 0;
	}
	.option6 .product-featured .product-featured-tab-content .box-left{
		width: 100%;
	}
	.option6 .product-featured .product-featured-tab-content .box-right{
		width: 100%;
		border-left: 1px solid #eaeaea;
	}
	.option6 .sub-category-wapper{
		width: 20%;
	}
	.option6 .col-right-tab{
		width: 80%;
	}
	.option6 .show-brand .navbar-brand{
		width: 21%;
		padding-right: 30px;
		font-size: 14px;
		font-weight: bold;
	}
	.option6 .product-featured .sub-category-list{
		padding: 10px;
	}
	.option6 .product-featured .box-left .banner-img{
		display: none;
	}
	.option6 .product-featured .manufacture-list .manufacture-waper{
		display: none;
	}
	.option6 .product-featured .product-featured-tab-content .box-full .product-list li{
		width: 33.3333%;
	}
	.option6 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
	}
	.option6 .product-featured .product-featured-tab-content .category-list-product .product-list{
		border-left: 1px solid #eaeaea;
	}
	.option6 .product-featured .product-featured-tab-content .category-list-product .product-list li{
		width: 33.3333%;
	}
	.option6 .group-banner-slide{
		display: none;
	}
	.option6 .header-top-right .homeslider{
		width: 100%;
	}
	.option6 .main-header .header-search-box .keyword{
		display: none;
	}
	
}
/*--------------------
[14. Styles for devices(>=481px and <=767px)]
*/
@media (min-width: 481px) and (max-width: 767px) { 
	.group-button-header{
		margin-top: 30px;
	}
	.option6 .logo{
		margin-top: 15px;
	}
	.main-header .group-button-header .btn-cart:hover .cart-block {
		display: none;
	}
	.option6 .main-header .header-search-box{
		padding-right: 15px;
	}
	.option6 #main-menu .navbar{
		background: none;
	}
	.option6 #main-menu .navbar-header{
		background: #007176;
	}
	.option6 #main-menu .navbar-default .navbar-nav>li>a{
		background: none;
		color: #999;
	}
	.option6 #main-menu li.dropdown>a:after {
	  position: absolute;
	  left: inherit;
	  right: 10px;
	  -ms-transform: translateY(-50%);
	  -webkit-transform: translateY(-50%);
	  transform: translateY(-50%);
	  top: 50%;
	  font-size: 12px;
	}
	.option6 #main-menu .navbar .navbar-nav>li:hover,
	.option6 #main-menu .navbar .navbar-nav>li.active{
		background: none;
	}
	.latest-deals-product .count-down-time2{
		position: inherit;
		top: inherit;
		right: inherit;
	}
	.latest-deals-product .owl-prev {
	  top: 50%;
	  left: 0;
	  right: inherit;
	}
	.latest-deals-product .owl-next {
	  top: 50%;
	}
	.option6 .content-page{
		margin-top: 30px;
	}
	.option6 .nav-menu{
		background: #ccc;
	}
	.option6 .nav-menu .nav>li>a{
		margin-left: 0;
		padding: 5px 15px;
	}
	
	.option6 .nav-menu .nav>li>a:after{
		display: none;
	}
	.option6 .product-featured .sub-category-wapper{
		width: 100%;
		padding: 15px;
		display: none;
	}
	.option6 .product-featured .product-featured-tab-content .box-left{
		width: 100%;
		display: none;
	}
	.option6 .product-featured .product-featured-tab-content .box-right{
		width: 100%;
		border-left: 1px solid #eaeaea;
	}
	.option6 .product-featured .deal-product .deal-product-content .deal-product-info{
		padding-left: 15px;
	}
	.option6 .product-featured .product-featured-tab-content .box-full .product-list li{
		width: 50%;
		float: left;
	}
	.services2 .services2-item .image{
		padding: 15px 30px 0 30px 0;
	}
	.services2 .services2-item .text{
		padding: 15px 30px;
		text-align: center;
	}
	.option6 .product-featured .manufacture-list{
		display: none;
	}
	.option6 .product-featured .product-list li{
		width: 50%;
		float: left;
	}
	.option6 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
		border-left: 1px solid #eaeaea;
	}
	.option6 #main-menu{
		padding: 0;
	}
	.option6 #main-menu .navbar-header{
		margin: 0;
	}
	.option6 #box-vertical-megamenus{
		display: none;
	}
	.option6 #main-menu .navbar-collapse{
		margin-left: 0;
	}
	.option6 .main-header .header-search-box .keyword{
		display: none;
	}
	.option6 .main-header .header-search-box .form-inline{
		width: 100%;
		min-width: 100%;
	}
	.option6 .group-banner-slide{
		display: none;
	}
	.option6 .header-top-right .homeslider{
		width: 100%;
	}
}
/*--------------------
[15. Styles for devices(<=480px)]
*/
@media (max-width: 480px) {
	.group-button-header{
		width: 100%;
		margin-top: 30px;
	}
	.option6 .logo{
		width: 100%;
		margin-top: 15px;
	}

	.main-header .group-button-header .btn-cart:hover .cart-block {
		display: none;
	}
	.option6 .main-header .header-search-box{
		padding-right: 15px;
	}
	.option6 #main-menu .navbar{
		background: none;
	}
	.option6 #main-menu .navbar-header{
		background: #007176;
	}
	.option6 #main-menu .navbar-default .navbar-nav>li>a{
		background: none;
		color: #999;
	}
	.option6 #main-menu li.dropdown>a:after {
	  position: absolute;
	  left: inherit;
	  right: 10px;
	  -ms-transform: translateY(-50%);
	  -webkit-transform: translateY(-50%);
	  transform: translateY(-50%);
	  top: 50%;
	  font-size: 12px;
	}
	.option6 #main-menu .navbar .navbar-nav>li:hover,
	.option6 #main-menu .navbar .navbar-nav>li.active{
		background: none;
	}
	.latest-deals-product .count-down-time2{
		position: inherit;
		top: inherit;
		right: inherit;
	}
	.latest-deals-product .owl-prev {
	  top: 50%;
	  left: 0;
	  right: inherit;
	}
	.latest-deals-product .owl-next {
	  top: 50%;
	}
	.option6 .content-page{
		margin-top: 30px;
	}
	.option6 .nav-menu{
		background: #ccc;
	}
	.option6 .nav-menu .nav>li>a{
		margin-left: 0;
		padding: 5px 15px;
	}
	
	.option6 .nav-menu .nav>li>a:after{
		display: none;
	}

	.option6 .product-featured .sub-category-wapper{
		display: none;
	}
	.option6 .product-featured .product-featured-tab-content .box-left{
		width: 100%;
		display: none;
	}
	.option6 .product-featured .product-featured-tab-content .box-right{
		width: 100%;
	}
	.option6 .product-featured .deal-product .deal-product-content .deal-product-info{
		padding-left: 15px;
	}
	.option6 .product-featured .product-featured-tab-content .box-full .product-list li{
		width: 100%;
	}
	.services2 .services2-item .image{
		padding: 15px 30px 0 30px 0;
	}
	.services2 .services2-item .text{
		padding: 15px 30px;
		text-align: center;
	}
	.option6 .product-featured .manufacture-list{
		display: none;
	}
	.option6 .product-featured .product-list li{
		border-right: none;
	}
	.option6 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
		border-left: 1px solid #eaeaea;
	}
	.option6 #main-menu{
		padding: 0;
	}
	.option6 #main-menu .navbar-header{
		margin: 0;
	}
	.option6 #box-vertical-megamenus{
		display: none;
	}
	.option6 #main-menu .navbar-collapse{
		margin-left: 0;
	}
	.option6 .main-header .header-search-box .keyword{
		display: none;
	}
	.option6 .main-header .header-search-box .form-inline{
		width: 100%;
		min-width: 100%;
	}
	.option6 .group-banner-slide{
		display: none;
	}
	.option6 .header-top-right .homeslider{
		width: 100%;
	}

}

/*------------------------------------------------------------------
[Table of contents]

1. Group button on top menu
2. Latest deals products
3. Products list
4. Header
5. Category featured
6. Banner bottom
7. Blogs
8. Services
9. Footer
10. Owl carousel vertical
11. Styles for devices(>1200px)
12. Styles for devices(>=992px and <=1199px)
13. Styles for devices(>=768px and <=992px)
14. Styles for devices(>=481px and <=767px)
15. Styles for devices(<=480px)

-------------------------------------------------------------------*/
.option5 #main-menu .navbar .navbar-nav>li>a span.notify-right{
  top: -20px;
  left: 40%;
  text-transform: uppercase;
}
/*-------------------
[2. Latest deals products]
*/
.latest-deals-product{
  margin-top: 20px;
  position: relative;
}
.latest-deals-product .count-down-time2{
  position: absolute;
  top: -61px;
  right: 80px;
}
.latest-deals-product .product-list li{
  border: 1px solid #eaeaea;
  overflow: hidden;
  padding-bottom: 5px;
}
.latest-deals-product .product-list li:hover{
  border: 1px solid #f96d10;
}
.latest-deals-product .owl-next{
  top: -40px;
}
.latest-deals-product .owl-prev{
  top: -40px;
  left: inherit;
  right: 26px;
}

.count-down-time2{
  text-transform: uppercase;
  font-size: 14px;
  font-weight: normal;
  line-height: 40px;
}
.count-down-time2 .icon-clock{
  width: 23px;
  height: 26px;
  background: url("../images/icon-clock.png") no-repeat center center;
  display: inline-block;
  margin-top: 5px;
}
.count-down-time2 .box-count{
  text-transform: none;
  color: #f96d10;
  border: 1px solid #f96d10;
  height: 30px;
  line-height: 30px;
  display: inline-block;
  padding: 0 10px;
  margin-top: 4px;
  margin-right: 4px;
  margin-left: 4px;
}


/*
[3. Products list]
*/
.option5 .product-list li .quick-view{
	right: 10px;
}
.option5 .product-list li .quick-view a:hover{
	background: #f96d10;
}
.option5 .product-list li .quick-view a:hover{
	background: #f96d10;
}
.option5 .product-list li .quick-view a:hover {
	background: #f96d10;
}
.option5 .product-list li .add-to-cart:hover{
	background: #f96d10;
}
.option5 .product-list li .product-price {
	color: #f96d10;
}


/*
[4. Header ]
*/
.option5 .logo{
	text-align: center;
}
.option5 .top-header img {
	margin-top: -5px;
}
.option5 .top-header a.current-open:after{
	font-size: 13px;
}
.option5 .top-header{
	background: #eee;
	font-size: 13px;
}
.option5 .cart-block{
	margin-top: 5px;
}
.option5 .cart-block .cart-block-content .product-info .p-right .p-rice{
	  color: #f96d10;
}
.option5 #shopping-cart-box-ontop .cart-block{
	margin-top: 0;
}
.option5 a:hover{
	color: #f96d10;
}
.option5 .top-header .dropdown-menu{
	border-top: 2px solid #f96d10;
}
.option5 .main-header .header-search-box{
	padding: 0 15px;
}
.option5 .main-header .header-search-box .form-inline .form-category{
	float: right;
	margin-right: 40px;
	border-left: 1px solid #eaeaea;
}
.option5 .main-header .header-search-box .form-inline .input-serach{
	padding-top: 9px;
}
.option5 .main-header .header-search-box .form-inline .btn-search{
	background: none;
	border-left: 1px solid #eaeaea;
	color: #f96d10;
	font-size: 16px;
}
.option5 .main-header .header-search-box .form-inline .btn-search .fa{
	line-height: inherit;
}
.option5 .group-button-header .btn-cart{
	background: url("../images/icon-cart-round5.png") no-repeat center center;
}
.option5 .group-button-header .btn-heart{
	  background: url("../images/icon-heart-round5.png") no-repeat center center;
}
.option5 .group-button-header .btn-compare{
	background: url("../images/icon-compare-round5.png") no-repeat center center;
}

.option5 .nav-top-menu.nav-ontop{
	background: #f96d10;
	height: 51px;
}
.option5 #form-search-opntop .btn-search .fa{
	display: none;
}
.option5 #box-vertical-megamenus{
	width: 85px;
	padding: 0;
}

.option5 #main-menu .navbar{
	border-radius: 0;
	background: #f96d10;
}
.option5 #main-menu .navbar-default .navbar-nav>li>a{
	color: #fff;
	border-right: none;
}
.option5 #main-menu .navbar-default .navbar-nav>li:last-child>a{
	background: none;
}
.option5 #main-menu .navbar .navbar-nav>li:hover, 
.option5 #main-menu .navbar .navbar-nav>li.active{
	background-image: none;
	background: #e80000;
}
.option5 #main-menu .navbar .navbar-nav>li:hover a, 
.option5 #main-menu .navbar .navbar-nav>li.active a{
	background: none;
}
.option5 #main-menu li.dropdown>a:after{
	position: absolute;
	left: 46%;
	-ms-transform: translateX(-50%);
  	-webkit-transform: translateX(-50%);
  	transform: translateX(-50%);
	top: 15px;
	font-size: 12px;
}
.option5 #main-menu li.dropdown:hover:before{
	display: none;
}

.option5 .box-vertical-megamenus .title{
	background: #e80000;
}
.option5 .box-vertical-megamenus .vertical-menu-content{
	border-top: none;
	min-width: 270px;
	border-right: 1px solid #eaeaea;
}
.option5 #main-menu{
	width: 100%;
	padding: 0 15px;
	margin: 0;
	padding-left: 70px;
	margin-top: -1px;
}
.option5 .nav-ontop #box-vertical-megamenus .title{
	background: #e80000;
	color: #fff;
	border-left: none;
	text-align: center;
	height: 51px;

}
.option5 .nav-ontop #box-vertical-megamenus .title .btn-open-mobile{
	margin: 0;
}
.option5 .nav-ontop #box-vertical-megamenus .box-vertical-megamenus{
	top: 0;
}
.option5 #form-search-opntop .btn-search:before{
	color: #fff;
}
.option5 #form-search-opntop form .input-serach input{
	color: #fff;
}
.option5 #form-search-opntop form .input-serach input
.option5 #form-search-opntop form .input-serach input::-webkit-input-placeholder { color:#fff; }
.option5 #form-search-opntop form .input-serach input::-webkit-input-placeholder { color:#fff;  }
.option5 #form-search-opntop form .input-serach input::-webkit-input-placeholder { color:#fff; }

.option5 #form-search-opntop:hover form{
  border: 1px solid #dfdfdf;
  background: #f96d10;
}
.option5 #user-info-opntop a.current-open:before {
  color: #fff;
}
.option5 #shopping-cart-box-ontop .fa{
	color: #fff;
}
.option5 .header-top-right{
	border-top: none;
	margin: 0;
	padding: 0 15px;
}
.option5 .header-top-right .homeslider {
	width: 100%;
}
.option5 .header-top-right .homeslider .bx-controls-direction .bx-prev, 
.option5 .header-top-right .homeslider .bx-controls-direction .bx-next{
	background: #f96d10;
}
.option5 .header-top-right .homeslider .bx-wrapper .bx-pager, 
.option5 .bx-wrapper .bx-controls-auto{
	text-align: center;
}
.option5 .header-top-right .homeslider .bx-wrapper .bx-pager .bx-pager-item a{
	background: #fff;
	font-size: 0;
	border-color: #fff;
	width: 14px;
	height: 14px;
}
.option5 .header-top-right .homeslider .bx-wrapper .bx-pager.bx-default-pager a:hover,
.option5 .header-top-right .homeslider .bx-wrapper .bx-pager.bx-default-pager a.active{
	background: #f96d10;
	border-color: #f96d10;
}

.option5 #main-menu .navbar-default .navbar-nav>li>a {
  color: #fff;
  background: url('../images/kak2.png') no-repeat right center;
  border-right: none;
}

.option5 .box-vertical-megamenus .vertical-menu-list {
	padding-top: 4px;
}
.option5 .box-vertical-megamenus .vertical-menu-list li{
	border: none;
	padding: 0 20px;
}
.option5 .box-vertical-megamenus .vertical-menu-list>li:hover{
	background: #f96d10;
}
.option5 .box-vertical-megamenus .vertical-menu-list>li:hover>a{
	color: #fff;
	border-color: transparent;
}
.option5 .box-vertical-megamenus .vertical-menu-list>li:hover>a:before{
	color: #fff;
}
.option5 .box-vertical-megamenus .vertical-menu-list:li:last-child>a{
	border:none;
}
.option5 .box-vertical-megamenus .vertical-menu-list>li>a{
	border:none;
	padding-left: 0;
	border-bottom: 1px dotted #eaeaea;
	line-height: 36px;
}
.option5 .box-vertical-megamenus .vertical-menu-list li:hover{
	border-left: none;
}
.option5 .box-vertical-megamenus .vertical-menu-list li:hover>a{
	border-top: none;
}
.option5 .box-vertical-megamenus .all-category{
	margin-top: 0px;
	padding-right: 0;
}
.option5 .vertical-dropdown-menu .mega-group-header span{
	border-color: #f96d10;
}
.option5 .box-vertical-megamenus .all-category span:hover{
	background: #f96d10;
	color: #fff;
	border-color: #f96d10;
}
.option5 .box-vertical-megamenus .all-category span:after{
	  content: "\f101";
	  font-size: 16px;
	  font-weight: normal;
}
.option5 .box-vertical-megamenus .vertical-menu-content ul>li>a.parent:before{
	right: 20px;
}
.option5 .vertical-dropdown-menu .mega-products .mega-product .product-price .new-price{
	  color: #f96d10;
}
.option5 .cart-block .cart-block-content .cart-buttons a.btn-check-out{
	background: #f96d10;
}

.option5 .page-heading{
	font-size: 16px;
	font-weight: bold;
}
.option5 .page-heading span.page-heading-title{
	border-bottom: 3px solid #f96d10;
}

.option5 .owl-controls .owl-prev:hover, 
.option5 .owl-controls .owl-next:hover {
  background: #f96d10;
  color: #fff;
}

.option5 .content-page {
	background: #eaeaea;
}
.option5 #main-menu .dropdown-menu .block-container .group_header>a{
	border-color: #f96d10;
}

/*
[5. Category featured]
*/

.option5 .show-brand .navbar-brand{
	width: 200px;
	position: relative;
	padding-left: 10px;
	font-family: 'Arial Narrow', Arial, sans-serif;
	font-size: 22px;
	font-weight: normal;
}
.option5 .show-brand .navbar-brand img{
	margin-right: 10px;
}
.option5 .show-brand .navbar-brand>a:hover{
	color: #fff;

}
.option5 .show-brand .navbar-brand:after{
	content: '';
	width: 12px;
	height: 20px;
	position: absolute;
	right: 5px;
	color: #fff;
	font-weight: normal;
	background: url("../images/icon-angle-right.png") no-repeat right center;
	top: 50%;
	-ms-transform: translateY(-50%);
	-webkit-transform: translateY(-50%);
	transform: translateY(-50%);
}
.option5 .nav-menu{
	margin-bottom: 0;
}
.option5 .nav-menu .nav>li>a{
	background: none;
	padding: 14px 15px;
	margin-left: 10px;
}
.option5 .nav-menu .nav>li>a:after{
	font: normal normal normal 14px/1 FontAwesome;
	content: "\f0d8";
	position: absolute;
	bottom: -40px;
	left: 50%;
	-ms-transform: translateX(-50%);
	-webkit-transform: translateX(-50%);
	transform: translateX(-50%);
	color: #fff;
	-webkit-transition: all 0.3s ease-out 0s;
	  -moz-transition: all 0.3s ease-out 0s;
	  -o-transition: all 0.3s ease-out 0s;
	  transition: all 0.3s ease-out 0s;
	  opacity: 0;
	  visibility: hidden;
}
.option5 .nav-menu .nav>li>a:before{
	content: '';
	width: 100%;
	height: 1px;
	background: #fa8334;
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	transform: scale(0, 1);
}
.option5 .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #fa8334;
}
.option5 .nav-menu .nav>li:hover a,
.option5 .nav-menu .nav>li.active a{
}

.option5 .nav-menu .nav>li:hover a:before,
.option5 .nav-menu .nav>li.active a:before{
	transform: scale(1);
  -webkit-transition: all 0.3s ease-out 0s;
  -moz-transition: all 0.3s ease-out 0s;
  -o-transition: all 0.3s ease-out 0s;
  transition: all 0.3s ease-out 0s;
}
.option5 .nav-menu .nav>li:hover a:after,
.option5 .nav-menu .nav>li.active a:after{
	color: #fa8334;
	bottom: -6px;
	opacity: 1;
	visibility: inherit;
}

.option5 .product-featured{
	margin-top: 0;
}
.option5 .product-featured .sub-category-list{
	float: left;
	padding: 20px 30px;
	line-height: 30px;
	background: #fff;
}
.option5 .product-featured .product-featured-tab-content{
}
.option5 .product-featured .product-featured-tab-content .box-left{
	width: 40%;
	float: left;
	border-left: 1px solid #eaeaea;
}
.option5 .product-featured .product-featured-tab-content .box-right{
	width: 60%;
	float: left;
}
.option5 .product-featured .product-featured-tab-content .box-full{
	width: 100%;
	float: left;
	border-left: 1px solid #eaeaea;
} 
.option5 .product-featured .product-featured-tab-content .box-full .product-list li{
	width: 20%;
	float: left;
	border-bottom: none;
}
.option5 .product-featured .product-featured-tab-content .category-banner{
	padding-right: 0;
}
.option5 .product-featured .product-featured-tab-content .category-banner img{
	
}
.option5 .product-featured .product-featured-tab-content .category-list-product{
	padding-left: 0;
}
.option5 .product-featured .product-list{
	margin-left: 0;
	margin-right: 0;

}
.option5 .product-featured .product-list li{
	padding: 0;
	min-height: inherit;
	border-right: 1px solid #eaeaea;
	border-top: 1px solid #eaeaea;
	padding-bottom: 3px;
	min-height: 286px;
}

.option5 .product-featured .owl-prev, 
.option5 .product-featured .owl-next {
  background: transparent;
  width: 28px;
  height: 28px;
  color: #ccc;
  text-align: center;
  padding-top: 0;
  font-size: 48px;
}
.option5 .product-featured .owl-next{
	background: url("../images/next.png") no-repeat center center;
}
.option5 .product-featured .owl-prev{
	background: url("../images/prev.png") no-repeat center center;
}
.option5 .product-featured .owl-prev .fa, 
.option5 .product-featured .owl-next .fa{
	font-weight: normal;
	line-height: 28px;
	display: none;
}
.option5 .product-featured .owl-prev:hover{
	background: url("../images/prev.png") no-repeat center center;
}

.option5 .product-featured .owl-next:hover{
	background: url("../images/next.png") no-repeat center center;
}

.option5 .product-featured .deal-product{
	line-height: 24px;
	border-right: 1px solid #eaeaea;
	overflow: hidden;
	padding-bottom: 23px;
}
.option5 .product-featured .deal-product .deal-product-head{
	text-align: center;
}
.option5 .product-featured .deal-product .deal-product-head h3{
	position: relative;
    z-index: 1;
    margin-top: 15px;
}
.option5 .product-featured .deal-product .deal-product-head h3:before{
	border-top: 1px solid #eaeaea;
    content:"";
    margin: 0 auto; /* this centers the line to the full width specified */
    position: absolute; /* positioning must be absolute here, and relative positioning must be applied to the parent */
    top: 40%; left: 40px; right: 40px; bottom: 0;
    width: 95%;
    z-index: -1;
    width: 300px;/*
    -ms-transform: translateY(-50%);
  -webkit-transform: translateY(-50%);
  transform: translateY(-50%);*/
}
.option5 .product-featured .deal-product .deal-product-head h3>span{
	background: #fff; 
    padding: 0 5px; 
    font-size: 14px;
    font-weight: bold;
}
.option5 .product-featured .deal-product .deal-product-content .deal-product-info{
	padding-left: 0;
}
.option5 .product-featured .deal-product .deal-product-content{
	margin-top: 10px;
}
.option5 .product-featured .deal-product .price{
	margin-top: 4px;
}
.option5 .product-featured .deal-product .price span{
	margin-right: 10px;
}
.option5 .product-featured .deal-product .price .product-price{
	color: #f96d10;
	font-size: 18px;
}
.option5 .product-featured .deal-product .price .old-price{
	text-decoration: line-through;
}
.option5 .product-featured .deal-product .price .sale-price{
	background: url("../images/sale-bg.png") no-repeat;
	color: #fff;
	padding: 0 7px;
}
.option5 .product-featured .deal-product .product-star{
	color: #febf2b;
	margin-top: 15px;
}
.option5 .product-featured .deal-product .product-desc{
	margin-top: -3px;
}
.option5 .product-featured .deal-product .show-count-down{
	overflow: hidden;
	margin-top: 11px;
	font-family: 'Arial Narrow', Arial, sans-serif;
	line-height: normal;
}
.option5 .product-featured .deal-product .show-count-down .dot{
	display: none;
}
.option5 .product-featured .deal-product .show-count-down .box-count{
	font-size: 20px;
	color: #717171;
	background: #f6f6f6;
	text-align: center;
	width: 45px;
	height: 47px;
	display: table-cell;
	float: left;
	margin-right: 5px;
}
.option5 .product-featured .deal-product .show-count-down .box-count .number{
	width: 45px;
	font-size: 18px;
	display: table;
	margin-top: 4px;
}
.option5 .product-featured .deal-product .show-count-down .box-count .text{
	width: 45px;
	font-size: 14px;
	display: table;
}
.option5 .product-featured .manufacture-list{
	padding-right: 0;
	float: left;
	overflow: hidden;
}
.option5 .product-featured .manufacture-list .manufacture-waper{
	border: 1px solid #eaeaea;
	padding: 44px 0px 44px 0;
	border-top: none;
	position: relative;
	border-bottom: none;
}
.option5 .product-featured .manufacture-list .manufacture-waper ul{
	padding: 0 20px;
	background: #fff;
}

.option5 .product-featured .manufacture-list .manufacture-waper .owl-prev{
	position: absolute;
	top: -16px;
	left: 0;
	right: 0;
	border-bottom: 1px solid #eaeaea;
}
.option5 .product-featured .manufacture-list .manufacture-waper .owl-next{
	position: absolute;
	bottom: -64px;
	top: inherit;
	left: 0;
	right: 0;
	border-top: 1px solid #eaeaea;
	border-bottom: 1px solid #eaeaea;
	padding-top: 12px;
	height: 42px;
}
.option5 .product-featured .manufacture-list .manufacture-waper .owl-controls .owl-nav{
	margin: 0;
	padding: 0;
}
.option5 .product-list li .add-to-cart:hover{
	opacity: 1;
}
.option5 .product-list li .add-to-cart a {
	  background: url("../images/icon-cart-option2.png") no-repeat left center;
}
.option5 .product-list li .quick-view a.compare:before{
	  content: "\f066";
}

/** OPTION CATEGORY **/

.option5 .category-featured.fashion .sub-category-list a:hover{
	color: #ff3366;
}
.option5 .category-featured.fashion .navbar-brand{
	background: #ff3366;
}
.option5 .category-featured.fashion .navbar-brand a:hover{
	color: #fff;
}
.option5 .category-featured.fashion .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #ff3366;
}
.option5 .category-featured.fashion .nav-menu .nav>li:hover a,
.option5 .category-featured.fashion .nav-menu .nav>li.active a{
	color: #ff3366;
}

.option5 .category-featured.fashion .nav-menu .nav>li:hover a:after,
.option5 .category-featured.fashion .nav-menu .nav>li.active a:after{
	color: #ff3366;
}

.option5 .category-featured.fashion .nav-menu .nav>li>a:before{
	background: #ff3366;
}

.option5 .category-featured.fashion .product-list li .add-to-cart {
	background-color: rgba(255, 51, 102, 0.7);
	background: rgba(255, 51, 102, 0.7);
	color: rgba(255, 51, 102, 0.7);
}
.option5 .category-featured.fashion .product-list li .add-to-cart:hover {
	background: #ff3366;
}

.option5 .category-featured.fashion .product-list li .quick-view a.search:hover,
.option5 .category-featured.fashion .product-list li .quick-view a.compare:hover,
.option5 .category-featured.fashion .product-list li .quick-view a.heart:hover{
	background-color: #ff3366;
	opacity: 0.9;
}

/** sports **/
.option5 .category-featured.sports .sub-category-list a:hover{
	color: #00a360;
}
.option5 .category-featured.sports .navbar-brand{
	background: #00a360;
}
.option5 .category-featured.sports .navbar-brand a:hover{
	color: #fff;
}
.option5 .category-featured.sports .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #00a360;
}
.option5 .category-featured.sports .nav-menu .nav>li:hover a,
.option5 .category-featured.sports .nav-menu .nav>li.active a{
	color: #00a360;
}
.option5 .category-featured.sports .nav-menu .nav>li:hover a:after,
.option5 .category-featured.sports .nav-menu .nav>li.active a:after{
	color: #00a360;
}

.option5 .category-featured.sports .nav-menu .nav>li>a:before{
	background: #00a360;
}

.option5 .category-featured.sports .product-list li .add-to-cart {
	background-color: rgba(0, 163, 96, 0.7);
	background: rgba(0, 163, 96, 0.7);
	color: rgba(0, 163, 96, 0.7);
}
.option5 .category-featured.sports .product-list li .add-to-cart:hover {
	background: #00a360;
}
.option5 .category-featured.sports .product-list li .quick-view a.search:hover,
.option5 .category-featured.sports .product-list li .quick-view a.compare:hover,
.option5 .category-featured.sports .product-list li .quick-view a.heart:hover{
	background-color: #00a360;
	opacity: 0.9;
}

/** electronic **/
.option5 .category-featured.electronic .sub-category-list a:hover{
	color: #0090c9;
}
.option5 .category-featured.electronic .navbar-brand{
	background: #0090c9;
}
.option5 .category-featured.electronic .navbar-brand a:hover{
	color: #fff;
}
.option5 .category-featured.electronic .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #0090c9;
}
.option5 .category-featured.electronic .nav-menu .nav>li:hover a,
.option5 .category-featured.electronic .nav-menu .nav>li.active a{
	color: #0090c9;
}
.option5 .category-featured.electronic .nav-menu .nav>li>a:before{
	background: #0090c9;
}
.option5 .category-featured.electronic .nav-menu .nav>li:hover a:after,
.option5 .category-featured.electronic .nav-menu .nav>li.active a:after{
	color: #0090c9;
}

.option5 .category-featured.electronic .product-list li .add-to-cart {
	background-color: rgba(0, 144, 201, 0.7);
	background: rgba(0, 144, 201, 0.7);
	color: rgba(0, 144, 201, 0.7);
}
.option5 .category-featured.electronic .product-list li .add-to-cart:hover {
	background-color: #0090c9;
}
.option5 .category-featured.electronic .product-list li .quick-view a.search:hover,
.option5 .category-featured.electronic .product-list li .quick-view a.compare:hover,
.option5 .category-featured.electronic .product-list li .quick-view a.heart:hover{
	background-color: #0090c9;
	opacity: 0.9;
}
/** digital **/
.option5 .category-featured.digital .sub-category-list a:hover{
	color: #3f5eca;
}
.option5 .category-featured.digital .navbar-brand{
	background: #3f5eca;
}
.option5 .category-featured.digital .navbar-brand a:hover{
	color: #fff;
}
.option5 .category-featured.digital .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #3f5eca;
}
.option5 .category-featured.digital .nav-menu .nav>li:hover a,
.option5 .category-featured.digital .nav-menu .nav>li.active a{
	color: #3f5eca;
}
.option5 .category-featured.digital .nav-menu .nav>li>a:before{
	background: #3f5eca;
}
.option5 .category-featured.digital .nav-menu .nav>li:hover a:after,
.option5 .category-featured.digital .nav-menu .nav>li.active a:after{
	color: #3f5eca;
}
.option5 .category-featured.digital .product-list li .add-to-cart {
	background-color: rgba(63, 94, 202, 0.7);
	background: rgba(63, 94, 202, 0.7);
	color: rgba(63, 94, 202, 0.7);
}
.option5 .category-featured.digital .product-list li .add-to-cart:hover {
	background-color: #3f5eca;
}
.option5 .category-featured.digital .product-list li .quick-view a.search:hover,
.option5 .category-featured.digital .product-list li .quick-view a.compare:hover,
.option5 .category-featured.digital .product-list li .quick-view a.heart:hover{
	background-color: #3f5eca;
	opacity: 0.9;
}
/** furniture **/
.option5 .category-featured.furniture .sub-category-list a:hover{
	color: #669900;
}
.option5 .category-featured.furniture .navbar-brand{
	background: #669900;
}
.option5 .category-featured.furniture .navbar-brand a:hover{
	color: #fff;
}
.option5 .category-featured.furniture .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #669900;
}
.option5 .category-featured.furniture .nav-menu .nav>li:hover a,
.option5 .category-featured.furniture .nav-menu .nav>li.active a{
	color: #669900;
}
.option5 .category-featured.furniture .nav-menu .nav>li>a:before{
	background: #669900;
}
.option5 .category-featured.furniture .nav-menu .nav>li:hover a:after,
.option5 .category-featured.furniture .nav-menu .nav>li.active a:after{
	color: #669900;
}

.option5 .category-featured.furniture .product-list li .add-to-cart {
	background-color: rgba(102, 153, 0, 0.7);
	background: rgba(102, 153, 0, 0.7);
	color: rgba(102, 153, 0, 0.7);
}
.option5 .category-featured.furniture .product-list li .add-to-cart:hover {
	background-color: #669900;
}

.option5 .category-featured.furniture .product-list li .quick-view a.search:hover,
.option5 .category-featured.furniture .product-list li .quick-view a.compare:hover,
.option5 .category-featured.furniture .product-list li .quick-view a.heart:hover{
	background-color: #669900;
	opacity: 0.9;
}

/** jewelry **/
.option5 .category-featured.jewelry .sub-category-list a:hover{
	color: #6d6855;
}
.option5 .category-featured.jewelry .navbar-brand{
	background: #6d6855;
}
.option5 .category-featured.jewelry .navbar-brand a:hover{
	color: #fff;
}
.option5 .category-featured.jewelry .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #6d6855;
}
.option5 .category-featured.jewelry .nav-menu .nav>li:hover a,
.option5 .category-featured.jewelry .nav-menu .nav>li.active a{
	color: #6d6855;
}
.option5 .category-featured.jewelry .nav-menu .nav>li>a:before{
	background: #6d6855;
}
.option5 .category-featured.jewelry .nav-menu .nav>li:hover a:after,
.option5 .category-featured.jewelry .nav-menu .nav>li.active a:after{
	color: #6d6855;
}
.option5 .category-featured.jewelry .product-list li .add-to-cart {
	background-color: #6d6855;
}
.option5 .category-featured.jewelry .product-list li .add-to-cart {
	background-color: rgba(109, 104,85, 0.7);
	background: rgba(109, 104,85, 0.7);
	color: rgba(109, 104,85, 0.7);
}
.option5 .category-featured.jewelry .product-list li .add-to-cart:hover {
	background-color: #6d6855;
}

.option5 .category-featured.jewelry .product-list li .quick-view a.search:hover,
.option5 .category-featured.jewelry .product-list li .quick-view a.compare:hover,
.option5 .category-featured.jewelry .product-list li .quick-view a.heart:hover{
	background-color: #6d6855;
	opacity: 0.9;
}
/****/

/*-----------------
[6. Banner bootom]
*/
.option5 .banner-bottom .item-left{
	padding-right: 0;
}
.option5 .banner-bottom .item-right{
	padding-left: 0;
}




/*--------------
[8. Services]
*/
.services2{
	margin-top: 30px;
	border-top: 1px solid #eaeaea;
	border-right: 1px solid #eaeaea;
	overflow: hidden;
}
.services2 .services2-item{
	padding: 0;
	border-left: 1px solid #eaeaea;
	border-bottom: 1px solid #eaeaea;
	padding-bottom: 15px;
	min-height: 120px;
}
.services2 .services2-item .image{
	text-align: center;
	color: #333333;
	padding-left: 30px;
	font-size: 14px;
	text-transform: uppercase;
	font-weight: normal;
}
.services2 .services2-item .image h3{
	font-size: 14px;
	color: #333333;
	font-weight: 600;
	margin-top: 10px;
}
.services2 .services2-item .text{
	padding-top: 15px;
	color: #919191;
	padding-left: 0;
	padding-right: 30px;

}


/*--------------
[9. Footer]
*/
.option5 #footer{
	margin-top: 60px;
}
.option5 #mail-box .btn{
	background: #f96d10;
}

.option5 .scroll_top:hover{
	background: #f96d10;
}


/*-----------------
[10. Owl carousel vertical]
*/
.owl-carousel-vertical .owl-next,
.owl-carousel-vertical .owl-prev{
	position: inherit;
	width: 100%!important;
	height: 17px;
	margin: 0 auto;
	float: left;
	opacity: 1;
	visibility: inherit;
	background: none;

}
.owl-carousel-vertical .owl-controls .owl-nav{
	margin: 0 auto;
	text-align: center;
	display: table-cell;
	width: 100%!important;
	float: left;
}

.option5 .product-featured .owl-carousel-vertical .owl-controls .owl-nav{
	margin-top: 26px;
	padding-left: 30px;
}
.option5 .product-featured .owl-carousel-vertical .owl-controls .owl-nav .owl-next,
.option5 .product-featured .owl-carousel-vertical .owl-controls .owl-nav .owl-prev{
	background: none;
}

.option5 .blog-list .blog-list-wapper ul li .readmore a{
	color: #f96d10;
}


/** REPONSIVE **/
/*----------------
[11. Styles for devices(>1200px)]
*/
@media (min-width: 1201px){
	
}
/*----------------
[12. Styles for devices(>=993px and <=1200px)]
*/
@media (min-width: 993px) and (max-width: 1200px) {
	.option5 .group-button-header{
		width: 25%;
		float: right;
	}
	.option5 .sub-category-wapper{
		width: 15%;
		display: none;
	}
	.option5 .col-right-tab{
		width: 100%;

	}
	.option5 .product-featured .manufacture-list .manufacture-waper{
		display: none;
	}
	.option5 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
	}
	.option5 .product-featured .product-featured-tab-content .category-list-product .product-list{
		border-left: 1px solid #eaeaea;
	}
	.option5 .main-header .header-search-box{
		width: 40%;
	}
	.option5 #home-slider .header-top-right .homeslider, 
	.option5 #home-slider .header-top-right .header-banner{
		border: none;
	}
}
/*--------------------
[13. Styles for devices(>=768px and <=992px)]
*/
@media (min-width: 768px) and (max-width: 992px) {
	.option5 .group-button-header{
		float: right;
		margin-top: 30px;
	}
	.option5 .main-header .logo{
		width: inherit;
		margin-top: 15px;
	}
	.option5 .nav-menu .nav>li>a{
		padding: 14px 10px;
		margin-left: 0;
	}
	.option5 .product-featured .product-featured-tab-content .box-left{
		width: 100%;
	}
	.option5 .product-featured .product-featured-tab-content .box-right{
		width: 100%;
		border-left: 1px solid #eaeaea;
	}
	.option5 .sub-category-wapper{
		width: 20%;
	}
	.option5 .col-right-tab{
		width: 80%;
	}
	.option5 .show-brand .navbar-brand{
		width: 21%;
		padding-right: 30px;
		font-size: 14px;
		font-weight: bold;
	}
	.option5 .product-featured .sub-category-list{
		padding: 10px;
	}
	.option5 .product-featured .box-left .banner-img{
		display: none;
	}
	.option5 .product-featured .manufacture-list .manufacture-waper{
		display: none;
	}
	.option5 .product-featured .product-featured-tab-content .box-full .product-list li{
		width: 33.3333%;
	}
	.option5 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
	}
	.option5 .product-featured .product-featured-tab-content .category-list-product .product-list{
		border-left: 1px solid #eaeaea;
	}
	.option5 .product-featured .product-featured-tab-content .category-list-product .product-list li{
		width: 33.3333%;
	}
	
}
/*--------------------
[14. Styles for devices(>=481px and <=767px)]
*/
@media (min-width: 481px) and (max-width: 767px) { 
	.group-button-header{
		margin-top: 30px;
	}
	.option5 .logo{
		margin-top: 15px;
	}
	.main-header .group-button-header .btn-cart:hover .cart-block {
		display: none;
	}
	.option5 .main-header .header-search-box{
		padding-right: 15px;
	}
	.option5 #main-menu .navbar{
		background: none;
	}
	.option5 #main-menu .navbar-header{
		background: #f96d10;
	}
	.option5 #main-menu .navbar-default .navbar-nav>li>a{
		background: none;
		color: #999;
	}
	.option5 #main-menu li.dropdown>a:after {
	  position: absolute;
	  left: inherit;
	  right: 10px;
	  -ms-transform: translateY(-50%);
	  -webkit-transform: translateY(-50%);
	  transform: translateY(-50%);
	  top: 50%;
	  font-size: 12px;
	}
	.option5 #main-menu .navbar .navbar-nav>li:hover,
	.option5 #main-menu .navbar .navbar-nav>li.active{
		background: none;
	}
	.latest-deals-product .count-down-time2{
		position: inherit;
		top: inherit;
		right: inherit;
	}
	.latest-deals-product .owl-prev {
	  top: 50%;
	  left: 0;
	  right: inherit;
	}
	.latest-deals-product .owl-next {
	  top: 50%;
	}
	.option5 .content-page{
		margin-top: 30px;
	}
	.option5 .nav-menu{
		background: #ccc;
	}
	.option5 .nav-menu .nav>li>a{
		margin-left: 0;
		padding: 5px 15px;
	}
	
	.option5 .nav-menu .nav>li>a:after{
		display: none;
	}
	.option5 .product-featured .sub-category-wapper{
		width: 100%;
		padding: 15px;
		display: none;
	}
	.option5 .product-featured .product-featured-tab-content .box-left{
		width: 100%;
		display: none;
	}
	.option5 .product-featured .product-featured-tab-content .box-right{
		width: 100%;
		border-left: 1px solid #eaeaea;
	}
	.option5 .product-featured .deal-product .deal-product-content .deal-product-info{
		padding-left: 15px;
	}
	.option5 .product-featured .product-featured-tab-content .box-full .product-list li{
		width: 50%;
		float: left;
	}
	.services2 .services2-item .image{
		padding: 15px 30px 0 30px 0;
	}
	.services2 .services2-item .text{
		padding: 15px 30px;
		text-align: center;
	}
	.option5 .product-featured .manufacture-list{
		display: none;
	}
	.option5 .product-featured .product-list li{
		width: 50%;
		float: left;
	}
	.option5 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
		border-left: 1px solid #eaeaea;
	}
	.option5 #main-menu{
		padding: 0;
	}
	.option5 #main-menu .navbar-header{
		margin: 0;
	}
	.option5 #box-vertical-megamenus{
		display: none;
	}
	.option5 #main-menu .navbar-collapse{
		margin-left: 0;
	}
}
/*--------------------
[15. Styles for devices(<=480px)]
*/
@media (max-width: 480px) {
	.group-button-header{
		width: 100%;
		margin-top: 30px;
	}
	.option5 .logo{
		width: 100%;
		margin-top: 15px;
	}

	.main-header .group-button-header .btn-cart:hover .cart-block {
		display: none;
	}
	.option5 .main-header .header-search-box{
		padding-right: 15px;
	}
	.option5 #main-menu .navbar{
		background: none;
	}
	.option5 #main-menu .navbar-header{
		background: #f96d10;
	}
	.option5 #main-menu .navbar-default .navbar-nav>li>a{
		background: none;
		color: #999;
	}
	.option5 #main-menu li.dropdown>a:after {
	  position: absolute;
	  left: inherit;
	  right: 10px;
	  -ms-transform: translateY(-50%);
	  -webkit-transform: translateY(-50%);
	  transform: translateY(-50%);
	  top: 50%;
	  font-size: 12px;
	}
	.option5 #main-menu .navbar .navbar-nav>li:hover,
	.option5 #main-menu .navbar .navbar-nav>li.active{
		background: none;
	}
	.latest-deals-product .count-down-time2{
		position: inherit;
		top: inherit;
		right: inherit;
	}
	.latest-deals-product .owl-prev {
	  top: 50%;
	  left: 0;
	  right: inherit;
	}
	.latest-deals-product .owl-next {
	  top: 50%;
	}
	.option5 .content-page{
		margin-top: 30px;
	}
	.option5 .nav-menu{
		background: #ccc;
	}
	.option5 .nav-menu .nav>li>a{
		margin-left: 0;
		padding: 5px 15px;
	}
	
	.option5 .nav-menu .nav>li>a:after{
		display: none;
	}

	.option5 .product-featured .sub-category-wapper{
		display: none;
	}
	.option5 .product-featured .product-featured-tab-content .box-left{
		width: 100%;
		display: none;
	}
	.option5 .product-featured .product-featured-tab-content .box-right{
		width: 100%;
	}
	.option5 .product-featured .deal-product .deal-product-content .deal-product-info{
		padding-left: 15px;
	}
	.option5 .product-featured .product-featured-tab-content .box-full .product-list li{
		width: 100%;
	}
	.services2 .services2-item .image{
		padding: 15px 30px 0 30px 0;
	}
	.services2 .services2-item .text{
		padding: 15px 30px;
		text-align: center;
	}
	.option5 .product-featured .manufacture-list{
		display: none;
	}
	.option5 .product-featured .product-list li{
		border-right: none;
	}
	.option5 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
		border-left: 1px solid #eaeaea;
	}
	.option5 #main-menu{
		padding: 0;
	}
	.option5 #main-menu .navbar-header{
		margin: 0;
	}
	.option5 #box-vertical-megamenus{
		display: none;
	}
	.option5 #main-menu .navbar-collapse{
		margin-left: 0;
	}

}
.option4 .product-list li .price-percent-reduction2{
	right: -8px;
}
.option4 .blog-list .blog-list-wapper ul li .readmore a{
	color: #0088cc;
}
.option4{
	background: #eaeaea;
}
.option4 .product-list li .product-price {
	color: #0088cc;
}
.option4 a:hover{
	color: #0088cc;
}
.option4 .scroll_top:hover{
	background: #0088cc;
}
.option4 .nav-center .owl-controls .owl-prev,
.option4 .nav-center .owl-controls .owl-next{
	-moz-transition: all 0.45s ease;
	-webkit-transition: all 0.45s ease;
	-o-transition: all 0.45s ease;
	-ms-transition: all 0.45s ease;
	transition: all 0.45s ease;
	opacity: 0;
	visibility: hidden;
}
.option4 .nav-center .owl-controls .owl-prev{
	left: -30px;
}
.option4 .nav-center .owl-controls .owl-next{
	right: -30px;
}
.option4 .nav-center.owl-loaded:hover .owl-next {
  right: 0;
  visibility: inherit;
  opacity: 1;
}
.option4 .nav-center.owl-loaded:hover .owl-prev {
  left: 0;
  visibility: inherit;
  opacity: 1;
}

.option4 .owl-controls .owl-prev:hover, 
.option4 .owl-controls .owl-next:hover {
  background: #0088cc;
  color: #fff;
}
.option4 .product-list li .add-to-cart:hover {
  background-color: #0088cc;
}
.option4 .product-list li .quick-view a:hover{
	background-color: #0088cc;
}
/*---------------
[2. Main header]
*/
.option4 .group-button-header{
	margin-top: 10px;
	padding-left: 0;
}
.option4 .group-button-header .btn-cart, 
.option4 .group-button-header .btn-heart,
.option4 .group-button-header .btn-compare,
.option4 .group-button-header .btn-login{
	width: auto;
	float: right;
	text-indent: inherit;
	padding-left: 30px;
	padding-top: 19px;
}
.option4 .group-button-header .btn-heart{
	background: url("../images/heart-icon.png") no-repeat center left;
	font-size: 14px;
}
.option4 .group-button-header .btn-login{
	background: url("../images/user-icon.png") no-repeat center left;
	font-size: 14px;
	height: 39px;
	margin-right: 16px;
}
.option4 .group-button-header .btn-cart{
	background: url("../images/cart-icon4.png") no-repeat center left;
	font-size: 14px;
	margin-right: 0;
	padding-left: 25px;
	padding-top: 12px;
}
.option4 .group-button-header .btn-cart>a{
	font-size: 14px;
}
.option4 .group-button-header .btn-cart .notify-right{
	right: 22px;
	top: -8px;

}
.option4 span.notify-right{
	background: url('../images/notify-right-red.png') no-repeat;
}


.option4 .hot-deals-box{
	background: #fff;
	border: none;
}
.option4 .box-products .box-product-content .box-product-list .product-list li{
	border: none;
	background: #fff;
}
.option4 .box-products .box-product-head {
	border-color: #ccc;
}

.option4 .blog-list .page-heading span.page-heading-title {
  border-color: #0099cc;
}
.option4 .nav-top-menu{
	background: none;
	border-top: 1px solid #ccc;
	border-bottom: 1px solid #ccc;
}
.option4 .box-vertical-megamenus .title{
	height: 42px;
	line-height: 42px;
	background: #0088cc;
}
.option4 .box-vertical-megamenus .title .btn-open-mobile{
	line-height: 40px;
}
.option4 .main-menu .navbar{
	min-height: 40px;
}
.option4 #main-menu .navbar .navbar-nav>li>a{
	margin: 10px 0;
	padding: 0 10px;
	text-transform: uppercase;
	border: none;
}
.option4 #main-menu .navbar .navbar-nav>li:hover,
.option4 #main-menu .navbar .navbar-nav>li.active{
	background: transparent;
	color: #0088cc;
}
.option4 #main-menu .navbar .navbar-nav>li:hover>a,
.option4 #main-menu .navbar .navbar-nav>li.active>a{
	color: #0088cc;
	border: none;
}

.option4 #main-menu .navbar .navbar-nav>li:last-child>a,
.option4 #main-menu .navbar .navbar-nav>li.active:last-child>a{
	border: none;
	padding-right: 0;
}

.option4 #main-menu .navbar-nav > li:hover .dropdown-menu {
  -webkit-transform: translate(0,5px);
  -moz-transform: translate(0,5px);
  -o-transform: translate(0,5px);
  -ms-transform: translate(0,5px);
  transform: translate(0,5px);
  opacity: 1;
  visibility: visible;
}
.option4 #main-menu li.dropdown:before{
	content: '';
	width: 100%;
	height: 5px;
	left: 0;
	right: 0;
	top: inherit;
	bottom: -5px;
}
.option4 #main-menu{
	margin: 0;
	margin-top: 12px;
}

.option4 .nav-ontop{
	height: 40px;
	background: #0088cc;
}
.option4 .nav-ontop #box-vertical-megamenus .title {
	background: #0088cc;
	color: #fff;
	border:none;
}
.option4 .box-vertical-megamenus .vertical-menu-content{
	border: 1px solid #eaeaea;
	padding-bottom: 32px;
}
.option4 .box-vertical-megamenus .vertical-menu-list {
	border: none;
}
.option4 .box-vertical-megamenus .vertical-menu-list li{
	border: none;
	padding: 0 20px;
}
.option4 .box-vertical-megamenus .vertical-menu-list li:last-child>a{
	border:none;
}
.option4 .box-vertical-megamenus .vertical-menu-list>li>a{
	border:none;
	padding-left: 0;
	border-bottom: 1px dotted #eaeaea;
	line-height: 36px;
}
.option4 .box-vertical-megamenus{
	top: -1px;
}
.option4 .box-vertical-megamenus .vertical-menu-list>li:hover {
  background: #0088cc;
}
.option4 .box-vertical-megamenus .vertical-menu-list>li:hover>a{
	border-color: transparent;
}
.option4 .box-vertical-megamenus .vertical-menu-list>li:hover{
	border-left: none;
}
.option4 .box-vertical-megamenus .vertical-menu-list>li:hover>a{
	border-top: none;
}
.option4 .box-vertical-megamenus .all-category{
	margin-top: 0;
	padding-right: 20px;
	padding-left: 20px;
}
.option4 .box-vertical-megamenus .all-category span:after{
	  content: "\f101";
	  font-size: 16px;
	  font-weight: normal;
}
.option4 .vertical-dropdown-menu .mega-group-header span{
	border-color: #0088cc;
}
.option4 .box-vertical-megamenus .all-category:hover span {
	background: #0088cc;
	border-color: #0088cc;
}
.option4 #main-menu .dropdown-menu .block-container .group_header>a {
  border-color: #0088cc;
}
.option4 .box-vertical-megamenus .vertical-menu-content ul>li>a.parent:before{
	right: 20px;
}
.option4 .vertical-dropdown-menu .mega-products .mega-product .product-price .new-price{
	  color: #0088cc;
}
.option4 .cart-block .cart-block-content .product-info .p-right .p-rice{
	color: #0088cc;
}
.option4 .cart-block .cart-block-content .cart-buttons a.btn-check-out{
	background: #0088cc;
}
.option4 .nav-ontop #box-vertical-megamenus {
	width: 60px;
}
.option4 .nav-ontop #main-menu .navbar .navbar-nav>li>a{
	color: #fff;
	border-right:none;
}
.option4 .nav-ontop #main-menu .navbar .navbar-nav>li:hover,
.option4 .nav-ontop #main-menu .navbar .navbar-nav>li.active{
	background: #31a5df;
	color: #0088cc;
}
.option4 .nav-ontop #main-menu .navbar .navbar-nav>li:hover>a,
.option4 .nav-ontop #main-menu .navbar .navbar-nav>li.active>a{
	color: #fff;
}

.option4 #form-search-opntop{
	height: 40px;
}
.option4 #form-search-opntop form{
	margin-top: 4px;
	color: #fff;
}
.option4 #form-search-opntop .btn-search:before {
	color: #fff;
}
.option4 #form-search-opntop:hover form {
  border: 1px solid #cacaca;
  background: #31a5df;
}
.option4 .header{
	background: #fff;
}
.option4 .main-header{
	background:#fff;
	padding: 20px 0;
}
.option4 #home-slider{
	background: #fff;
}
.option4 .header-top-right .homeslider{
	width: 100%;
	padding: 10px 0 0 10px;
}
.option4 .header-top-right{
	border: none;
}
.row-blog{
	background: #fff;
	margin-top: 40px;
}

.formsearch-option4{
	padding: 0;
	height: 40px;
}
.formsearch-option4>form{
	border-right: 1px solid #ccc;
	height: 40px;
}
.formsearch-option4 .form-category{
	border-right: 1px solid #ccc;
	height: 40px;
	min-width: 150px;
}
.formsearch-option4 .select2-container--default,
.formsearch-option4 .select2-selection--single{
	border: none;
	height: 40px;
	padding: 0;
	margin: 0;
	width: 100%!important;
}
.formsearch-option4 .select2-container .select2-selection--single .select2-selection__rendered{
	padding: 0;
}
.formsearch-option4 .select2-container--default .select2-selection--single .select2-selection__arrow{
	right: 5px;
}
.formsearch-option4 .form-category select{
	padding: 10px 0;
	-webkit-appearance: none;
   -moz-appearance: none;
   appearance: none;
   background: url('../images/dropdow.png') no-repeat right center;
   padding-right: 25px;
   color: #666;
}
.formsearch-option4 .input-serach{
	padding-left: 10px;
}
.formsearch-option4 .btn-search{
	width: 50px;
	height: 40px;
	border-left: 1px solid #ccc;
	color: #666;
}
.formsearch-option4 .btn-search .fa{
	line-height: inherit;
}


.option4 .group-banner4{
	background: #fff;
	padding: 32px 0;
}
.option4 .group-banner4 .list-banner{
	margin-left: -5px;
	margin-right: -5px;
}
.option4 .group-banner4 .list-banner li{
	display: inline;
	float: left;
	padding: 0 5px;
}

.option4 .header-top-right .homeslider .bx-controls-direction .bx-prev, 
.option4 .header-top-right .homeslider .bx-controls-direction .bx-next{
	background: #0088cc;
}
.option4 .header-top-right .homeslider .bx-wrapper .bx-pager .bx-pager-item {
  width: 10px;
  height: 10px;
}
.option4 .header-top-right .homeslider .bx-wrapper .bx-pager .bx-pager-item a {
  width: 100%;
  height: 100%;
  float: left;
  background: transparent;
  margin: 0;
  padding: 0;
  text-align: center;
  text-indent: 0px;
  border-radius: 90%;
  color: #666;
  border: 1px solid #fff;
  padding-left: 1px;
  background: #fff;
  font-size: 0;
}
.option4 .header-top-right .homeslider .bx-wrapper .bx-pager .bx-pager-item a.active {
  background: #0088cc;
  border-color: #0088cc;
}
.option4 .blog-list .page-heading {
  font-size: 18px;
}
.option4 #footer2 {
	margin-top: 0;
	padding-top: 40px;
	border: none;
}
.option4 #footer2 .footer-top{
	border-top: 1px solid #eaeaea;
}

.nav-top-menu .link-mainmenu {
	width: auto;
	display: inline-block;
	float: right;
	height: 40px;
}
.nav-top-menu .link-mainmenu img{
	vertical-align: middle;
	display: inline-block;
}
.nav-top-menu .link-mainmenu .dropdown{
	padding: 0 10px;
	border-right: 1px solid #ccc;
}
.nav-top-menu .link-mainmenu .dropdown>a{
	line-height: 40px;
}
.nav-top-menu .link-mainmenu .dropdown>a:after{
	content: "\f107";
	font-family: "FontAwesome";
	font-size: 17px;
	vertical-align: 0;
	padding-left: 10px;
}
.nav-top-menu .link-mainmenu .dropdown>a>img{
	margin-top: -3px;
	margin-right: 5px;
}
.nav-top-menu .link-mainmenu .dropdown-menu {
  border-radius: 0;
  border: none;
  top: 100%;
  left: 0;
}
.nav-top-menu .link-mainmenu .dropdown-menu>li>a>img{
	margin-top: -2px;
	margin-right: 5px;
}
.group-link-main-menu{
	padding-left: 0;
}
.option4 .header-top-right .homeslider .bx-wrapper .bx-pager, 
.option4 .bx-wrapper .bx-controls-auto{
	text-align: center;
}
/** MAIN HEADER ON TOP**/
.main-header-ontop{
	padding: 0;
	position: fixed;
	left: 0;
	right: 0;
	z-index: 10000;
	width: 100%;
	background: #fff;
	top: 0;
	box-shadow: 0 1px 1px 0 rgba(50, 50, 50, 0.1);
	min-height: 50px;
}
.main-header-ontop .main-header{
	padding: 10px 0;
}
.main-header-ontop .main-header .logo img{
	width: 80%;
	height: auto;
}

/** REPONSIVE **/
/*----------------
[4. Styles for devices(>1200px)]
*/
@media (min-width: 1201px){
	
}
/*----------------
[5. Styles for devices(>=993px and <=1200px)]
*/
@media (min-width: 993px) and (max-width: 1200px) {
	
}
/*--------------------
[6. Styles for devices(>=768px and <=992px)]
*/
@media (min-width: 768px) and (max-width: 992px) {
	.option4 #main-menu{
		padding: 0 15px;
	}
	.formsearch-option4 .form-category{
		display: none;
	}
	.formsearch-option4 .input-serach input{
		padding: 10px;
	}
	.option4 .header-top-right .homeslider{
		padding: 0;
	}
	.option4 .group-button-header .btn-cart{
		float: left;
	}
}
/*--------------------
[7. Styles for devices(>=481px and <=767px)]
*/
@media (min-width: 481px) and (max-width: 767px) { 
	.option4 #main-menu{
		float: left;
		width: 100%;
		margin-top: 25px;
		padding-right: 15px;
	}
	.option4 #main-menu .navbar-header{
		background: #0088cc;
	}
	.option4 #main-menu li.dropdown>a:after{
		top: 0;
	}
	.option4 .nav-top-menu{
		border: none;
	}
	.option4 #box-vertical-megamenus{
		width: 100%;
	}
	.formsearch-option4{
		width: 100%;
		float: left;
		margin-top: 25px;
		padding: 0 15px;
	}
	.formsearch-option4 .form-category{
		display: none;
	}
	.formsearch-option4>form{
		border: 1px solid #ccc;
	}
	.group-link-main-menu{
		width: 100%;
		float: left;
		margin-top: 25px;
	}
	.formsearch-option4 .btn-search{
		position: absolute;
		top: 0;
		right: 20px;
	}
	.formsearch-option4 .form-group{
		margin: 0;
	}
	.formsearch-option4 .input-serach input{
		padding: 10px 10px;
		width: 100%;
	}
	.nav-top-menu .link-mainmenu .dropdown{
		border: 1px solid #ccc;
		margin-left: -1px;
	}
	.option4 #box-vertical-megamenus .box-vertical-megamenus{
		right: 15px;
	}
	.option4 .group-button-header .btn-cart{
		display: none;
	}
	.option4 .group-banner4{
		padding: 20px 0;
	}
	.option4 .group-banner4 .list-banner{
		margin: 0;
		overflow: hidden;
	}
	.option4 .group-banner4 .list-banner li{
		padding: 0;
		margin-top: 5px;
	}
	.option4 .header-top-right .homeslider{
		padding: 0;
		margin-top: 25px;
	}
}
/*--------------------
[8. Styles for devices(<=480px)]
*/
@media (max-width: 480px) {
	.option4 #main-menu{
		float: left;
		width: 100%;
		margin-top: 25px;
		padding-right: 15px;
	}
	.option4 #main-menu .navbar-header{
		background: #0088cc;
	}
	.option4 #main-menu li.dropdown>a:after{
		top: 0;
	}
	.option4 .nav-top-menu{
		border: none;
	}
	.option4 #box-vertical-megamenus{
		width: 100%;
	}
	.formsearch-option4{
		width: 100%;
		float: left;
		margin-top: 25px;
		padding: 0 15px;
	}
	.formsearch-option4 .form-category{
		display: none;
	}
	.formsearch-option4>form{
		border: 1px solid #ccc;
	}
	.group-link-main-menu{
		width: 100%;
		float: left;
		margin-top: 25px;
	}
	.formsearch-option4 .btn-search{
		position: absolute;
		top: 0;
		right: 20px;
	}
	.formsearch-option4 .form-group{
		margin: 0;
	}
	.formsearch-option4 .input-serach input{
		padding: 10px 10px;
		width: 100%;
	}
	.nav-top-menu .link-mainmenu .dropdown{
		border: 1px solid #ccc;
		margin-left: -1px;
	}
	.option4 #box-vertical-megamenus .box-vertical-megamenus{
		right: 15px;
	}
	.option4 .group-button-header .btn-cart{
		display: none;
	}
	.option4 .group-banner4{
		padding: 20px 0;
	}
	.option4 .group-banner4 .list-banner{
		margin: 0;
		overflow: hidden;
	}
	.option4 .group-banner4 .list-banner li{
		padding: 0;
		margin-top: 5px;
	}
	.option4 .header-top-right .homeslider{
		padding: 0;
		margin-top: 25px;
	}
}
/*------------------------------------------------------------------
[Table of contents]
0. Global
1. Top menu
2. Main header
3. Home slider

4. Styles for devices(>1200px)
5. Styles for devices(>=992px and <=1199px)
6. Styles for devices(>=768px and <=992px)
7. Styles for devices(>=481px and <=767px)
8. Styles for devices(<=480px)

-------------------------------------------------------------------*/
/*---------------
[0. Global]
*/
.option3 .product-list li .product-price {
	color: #0088cc;
}
.option3 a:hover{
	color: #0088cc;
}
.option3 .scroll_top:hover{
	background: #0088cc;
}
.option3 .nav-center .owl-controls .owl-prev,
.option3 .nav-center .owl-controls .owl-next{
	-moz-transition: all 0.45s ease;
	-webkit-transition: all 0.45s ease;
	-o-transition: all 0.45s ease;
	-ms-transition: all 0.45s ease;
	transition: all 0.45s ease;
	opacity: 0;
	visibility: hidden;
}
.option3 .nav-center .owl-controls .owl-prev{
	left: -30px;
}
.option3 .nav-center .owl-controls .owl-next{
	right: -30px;
}
.option3 .nav-center.owl-loaded:hover .owl-next {
  right: 0;
  visibility: inherit;
  opacity: 1;
}
.option3 .nav-center.owl-loaded:hover .owl-prev {
  left: 0;
  visibility: inherit;
  opacity: 1;
}

.option3 .owl-controls .owl-prev:hover, 
.option3 .owl-controls .owl-next:hover {
  background: #0088cc;
  color: #fff;
}
.option3 .product-list li .add-to-cart:hover {
  background-color: #0088cc;
}

.option3 .product-list li .quick-view a:hover{
	background-color: #0088cc;
}
/*---------------
[1. Top menu]
*/
.option3 .navbar-right{
	margin-right: 0;
}
.option3 .link-buytheme .fa{
	line-height: inherit;
	color: #0088cc;
}
.option3 .logo{
	margin-top: -20px;
}
.option3 .main-header{
	padding-bottom: 25px;
	padding-top: 25px;
}
.option3 .top-header .dropdown-menu{
	border-top: 2px solid #0088cc;
}
.option3 #user-info-opntop .dropdown-menu{
	border-top: 2px solid #0088cc;
}
.option3 .main-header .header-search-box .form-inline{
	border: 2px solid #0088cc;
}
.option3 .main-header .header-search-box .form-inline .select2{
	border-right: none;
}
.option3 .main-header .header-search-box .form-inline .form-category {
	height: 37px;
}
.option3 .main-header .header-search-box .form-inline .btn-search{
	background: #0088cc url("../images/search.png") no-repeat center center;
	width: 40px;
	height: 40px;
}
.option3 .main-header .header-search-box{
	padding: 0 15px;
	margin-top: 10px;
}
.option3 .main-header .shopping-cart-box{
	padding: 0 15px;
	margin: 0;
	margin-top: 10px;
}

.option3 .main-header-top-link li{
	display: inline;
	float: left;
}
.option3 .main-header-top-link li>a{
	padding: 0 5px;
	border-right: 1px solid #e4e4e4;
}
.option3 .main-header-top-link li:first-child>a{
	padding-left: 0;
}
.option3 .main-header-top-link li:last-child>a{
	padding-right: 0;
	border-right: none;
}
/*---------------
[2. Main header]
*/
.option3 .group-button-header{
	margin-top: 10px;
}
.option3 .group-button-header .btn-cart, 
.option3 .group-button-header .btn-heart,
.option3 .group-button-header .btn-compare,
.option3 .group-button-header .btn-login{
	width: auto;
	float: right;
	text-indent: inherit;
	padding-left: 30px;
	padding-top: 19px;
}
.option3 .group-button-header .btn-heart{
	background: url("../images/heart-icon.png") no-repeat center left;
	font-size: 14px;
}
.option3 .group-button-header .btn-login{
	background: url("../images/user-icon.png") no-repeat center left;
	font-size: 14px;
	height: 39px;
	margin-right: 16px;
}
.option3 .group-button-header .btn-cart{
	background: url("../images/cart-icon.png") no-repeat center left;
	font-size: 14px;
	margin-right: 0;
}
.option3 .group-button-header .btn-cart>a{
	font-size: 14px;
}
.option3 .group-button-header .btn-cart .notify-right{
	right: -6px;
	top: 0;
}
.option3 span.notify-right{
	background: url('../images/notify-right-red.png') no-repeat;
}
.header-text{
	font-size: 13px;
	text-align: right;
}
.header-text .fa{
	line-height: inherit;
	font-size: 14px;
	color: #f9d717;
	margin-top: -1px;
}
.option3 .nav-top-menu{
	background: none;
}
.option3 .box-vertical-megamenus .title{
	height: 40px;
	line-height: 40px;
	background: #0088cc;
}
.option3 .box-vertical-megamenus .title .btn-open-mobile{
	line-height: 40px;
}
.option3 .main-menu .navbar{
	min-height: 40px;
}
.option3 #main-menu .navbar .navbar-nav>li>a{
	margin: 14px 0;
	padding: 0 10px;
	text-transform: uppercase;
	line-height: 11px;
}
.option3 #main-menu .navbar .navbar-nav>li:hover,
.option3 #main-menu .navbar .navbar-nav>li.active{
	background: transparent;
	color: #0088cc;
}
.option3 #main-menu .navbar .navbar-nav>li:hover>a,
.option3 #main-menu .navbar .navbar-nav>li.active>a{
	color: #0088cc;
	border-right: 1px solid #cacaca;
}
.option3 #main-menu .navbar .navbar-nav>li:last-child>a,
.option3 #main-menu .navbar .navbar-nav>li.active:last-child>a{
	border: none;
	padding-right: 0;
}

.option3 #main-menu .navbar-nav > li:hover .dropdown-menu {
  -webkit-transform: translate(0,5px);
  -moz-transform: translate(0,5px);
  -o-transform: translate(0,5px);
  -ms-transform: translate(0,5px);
  transform: translate(0,5px);
  opacity: 1;
  visibility: visible;
}
.option3 #main-menu li.dropdown:before{
	content: '';
	width: 100%;
	height: 5px;
	left: 0;
	right: 0;
	top: inherit;
	bottom: -5px;
}

.option3 .nav-ontop{
	height: 40px;
	background: #0088cc;
}
.option3 .nav-ontop #box-vertical-megamenus .title {
	background: #0088cc;
	color: #fff;
	border:none;
}
.option3 .box-vertical-megamenus .vertical-menu-content{
	border-top: none;
}
.option3 .box-vertical-megamenus .vertical-menu-list {
	padding-top: 4px;
}
.option3 .box-vertical-megamenus .vertical-menu-list li{
	border: none;
	padding: 0 20px;
}
.option3 .box-vertical-megamenus .vertical-menu-list li:last-child>a{
	border:none;
}
.option3 .box-vertical-megamenus .vertical-menu-list>li>a{
	border:none;
	padding-left: 0;
	border-bottom: 1px dotted #eaeaea;
	line-height: 36px;
}
.option3 .box-vertical-megamenus .vertical-menu-list>li:hover {
  background: #0088cc;
}
.option3 .box-vertical-megamenus .vertical-menu-list>li:hover>a{
	border-color: transparent;
}
.option3 .box-vertical-megamenus .vertical-menu-list>li:hover{
	border-left: none;
}
.option3 .box-vertical-megamenus .vertical-menu-list>li:hover>a{
	border-top: none;
}
.option3 .box-vertical-megamenus .all-category{
	margin-top: 0px;
	padding-right: 0;
}
.option3 .box-vertical-megamenus .all-category:hover>span{
	background:#0088cc; 
	border-color: #0088cc;
}
.option3 .box-vertical-megamenus .all-category span:after{
	  content: "\f101";
	  font-size: 16px;
	  font-weight: normal;
}
.option3 .box-vertical-megamenus .vertical-menu-content{
	padding-bottom: 31px;
}
.option3 #main-menu .dropdown-menu .block-container .group_header>a {
  border-color: #0088cc;
}
.option3 .box-vertical-megamenus .vertical-menu-content ul>li>a.parent:before{
	right: 20px;
}
.option3 .vertical-dropdown-menu .mega-products .mega-product .product-price .new-price{
	  color: #0088cc;
}
.option3 .cart-block .cart-block-content .product-info .p-right .p-rice{
	color: #0088cc;
}
.option3 .cart-block .cart-block-content .cart-buttons a.btn-check-out{
	background: #0088cc;
}
.option3 .nav-ontop #box-vertical-megamenus {
	width: 60px;
}
.option3 .nav-ontop #main-menu .navbar .navbar-nav>li>a{
	color: #fff;
	border-right:none;
}
.option3 .nav-ontop #main-menu .navbar .navbar-nav>li:hover,
.option3 .nav-ontop #main-menu .navbar .navbar-nav>li.active{
	background: #31a5df;
	color: #0088cc;
}
.option3 .nav-ontop #main-menu .navbar .navbar-nav>li:hover>a,
.option3 .nav-ontop #main-menu .navbar .navbar-nav>li.active>a{
	color: #fff;
}

.option3 #form-search-opntop{
	height: 40px;
}
.option3 #form-search-opntop form{
	margin-top: 4px;
	color: #fff;
}
.option3 #form-search-opntop .btn-search:before {
	color: #fff;
}
.option3 #form-search-opntop:hover form {
  border: 1px solid #cacaca;
  background: #31a5df;
}
.option3 #form-search-opntop ::-webkit-input-placeholder {
   color: #fff;
}

.option3 #form-search-opntop :-moz-placeholder { /* Firefox 18- */
   color: #fff;  
}

.option3 #form-search-opntop ::-moz-placeholder {  /* Firefox 19+ */
   color: #fff;  
}

.option3 #form-search-opntop :-ms-input-placeholder {  
   color: #fff;  
}
.option3 #user-info-opntop,
.option3 #user-info-opntop .dropdown,
.option3 #user-info-opntop a.current-open{
	height: 40px;
}
.option3 #user-info-opntop a.current-open{
	padding-top: 12px;
}
.option3 #user-info-opntop a.current-open:before{
	color: #fff;
}
.option3 #user-info-opntop .dropdown-menu {
	top: 40px;
}
.option3 #shopping-cart-box-ontop {
	height: 40px;
}
.option3 #shopping-cart-box-ontop .fa{
	line-height: 40px;
	color: #fff;
}

/*---------------
[3. Home slider]
*/
.option3 .header-top-right{
	border-top: none;
}
.option3 .header-top-right .header-top-right-wapper{
	display: table;
}
.option3 .header-top-right .homeslider{
	width: 79%;
	display: table-cell;
	float: inherit;
}
.option3 .header-top-right .header-banner{
	width: 21%;
	display: table-cell;
	float: inherit;
	background: #fff;
	max-width: 190px;
}
.option3 .header-top-right .homeslider .bx-controls-direction .bx-prev, 
.option3 .header-top-right .homeslider .bx-controls-direction .bx-next{
	background: #0088cc;
}
.trending .trending-title{
	height: 33px;
	line-height: 33px;
	background: #0088cc;
	color: #fff;
	text-transform: uppercase;
	text-align: center;
	font-size: 14px;
}
.option3 .header-top-right .header-banner img{
	width: inherit;
	margin: 0 auto;
	vertical-align: middle;
}
.trending  .trending-product li{
	text-align: center;
	border-bottom: 1px solid #eaeaea;
}
.trending  .trending-product li:last-child{
	border:none;
}
.trending  .trending-product li .product-name{
	margin-top: 8px;
}
.trending  .trending-product li .product-price{
	line-height: 30px;
}
.trending  .trending-product li .price{
	font-size: 18px;
	color: #0099cc;
}
.trending  .trending-product li .price-old{
	text-decoration: line-through;
	margin-left: 11px;
	color: #666;
}
.services-wapper{
	background: #f6f6f6;
	border-bottom: 1px solid #eaeaea;
}
.services-wapper .service{
	margin-top: 0;
	border:none;
}
.option3 .header-top-right .homeslider .bx-wrapper .bx-pager .bx-pager-item{
	width: 10px;
	height: 10px;
}
.option3 .header-top-right .homeslider .bx-wrapper .bx-pager .bx-pager-item a {
  width: 100%;
  height: 100%;
  float: left;
  background: transparent;
  margin: 0;
  padding: 0;
  text-align: center;
  text-indent: 0px;
  border-radius: 90%;
  color: #666;
  border: 1px solid #fff;
  padding-left: 1px;
  background: #fff;
  font-size: 0;
}
.option3 .header-top-right .homeslider .bx-wrapper .bx-pager .bx-pager-item a.active{
	background: #0088cc;
	border-color: #0088cc;
}
.option3 .vertical-dropdown-menu .mega-group-header span{
	border-color: #0088cc;
}
.option3 .header-top-right .homeslider .bx-wrapper .bx-pager, 
.option3 .bx-wrapper .bx-controls-auto{
	display: none;
}

/** REPONSIVE **/
/*----------------
[4. Styles for devices(>1200px)]
*/
@media (min-width: 1201px){
	
}
/*----------------
[5. Styles for devices(>=993px and <=1200px)]
*/
@media (min-width: 993px) and (max-width: 1200px) {
	.option3 #home-slider .header-top-right .homeslider, 
	.option3 #home-slider .header-top-right .header-banner{
		border:none;
	}
	
	.option3 #main-menu .navbar .navbar-nav>li>a{
		font-size: 13px;
		border:none;
		padding: 0 7px;
	}
	.option3 #main-menu .navbar .navbar-nav>li:hover>a,
	.option3 #main-menu .navbar .navbar-nav>li.active>a{
		border: none;
	}
}
/*--------------------
[6. Styles for devices(>=768px and <=992px)]
*/
@media (min-width: 768px) and (max-width: 992px) {
	.option3 .logo{
		margin-top: 25px;
	}

	.option3 .main-header .header-search-box{
		margin-top: 25px;
	}
	.option3 .group-button-header {
		margin-top: 25px;
	}
	.option3 #box-vertical-megamenus{
		width: 40px;
		display: none;
	}
	.option3 #main-menu .navbar .navbar-nav>li>a{
		padding: 0 10px;
		border-left: none;
		font-size: 13px;
	}
	.option3 #main-menu{
		margin: 0;
		padding-left: 15px;
		width: auto;
	}
	.option3 .navbar-right{
		display: none;
	}
	.option3 .box-vertical-megamenus .title-menu{
		display: none;
	}
	.option3 .box-vertical-megamenus .title .btn-open-mobile{
		margin-left: -7px;
		float: left!important;
	}
	.option3 #form-search-opntop,
	.option3 #user-info-opntop,
	.option3 #shopping-cart-box-ontop{
		display: none;
	}
	.option3 .header-top-right .header-banner{
		display: none;
	}
	

	
}
/*--------------------
[7. Styles for devices(>=481px and <=767px)]
*/
@media (min-width: 481px) and (max-width: 767px) { 
	.option3 .top-main-header{
		display: none;
	}
	.option3 .group-button-header{
		width: 100%;
		margin-top: 25px;
	}
	.option3 .logo {
		margin-top: 0;
	}
	.option3 .main-header .header-search-box{
		margin-top: 25px;
	}
	.option3 #main-menu .navbar-header .navbar-brand{
		line-height: 40px;
		min-height: 40px;
	}
	.option3 #main-menu .navbar-header .navbar-toggle{
		margin-top: 7px;
		padding: 0;
	}
	.option3 #main-menu .navbar-header{
		height: 40px;
	}
	.option3 .navbar-brand{
		height: auto;
	}
	.option3 #main-menu .navbar .navbar-nav>li:hover>a, 
	.option3 #main-menu .navbar .navbar-nav>li.active>a{
		border-right: none;
	}
	.option3 #main-menu li.dropdown>a:after{
		top: 0;
	}
	
	.block-banner .block-banner-left, 
	.block-banner .block-banner-right {
		width: 100%;
		padding: 0;
	}
	.block-banner .block-banner-right{
		margin-top: 10px;
	}
	
	.option3 #home-slider .slider-left{
		display: none;
	}
}
/*--------------------
[8. Styles for devices(<=480px)]
*/
@media (max-width: 480px) {
	.option3 .top-main-header{
		display: none;
	}
	.option3 .group-button-header{
		width: 100%;
		margin-top: 25px;
	}
	.option3 .logo {
		margin-top: 0;
	}
	.option3 .main-header .header-search-box{
		margin-top: 25px;
	}
	.option3 #main-menu .navbar-header .navbar-brand{
		line-height: 40px;
		min-height: 40px;
	}
	.option3 #main-menu .navbar-header .navbar-toggle{
		margin-top: 7px;
		padding: 0;
	}
	.option3 #main-menu .navbar-header{
		height: 40px;
	}
	.option3 .navbar-brand{
		height: auto;
	}

	.option3 #main-menu .navbar .navbar-nav>li:hover>a, 
	.option3 #main-menu .navbar .navbar-nav>li.active>a{
		border-right: none;
	}
	.option3 #main-menu li.dropdown>a:after{
		top: 0;
	}
	#main-menu li.dropdown>a:after{

	}
	.option3 #home-slider .slider-left{
		display: none;
	}
	
	
	.block-banner .block-banner-left, 
	.block-banner .block-banner-right {
		width: 100%;
		padding: 0;
	}
	.block-banner .block-banner-right{
		margin-top: 10px;
	}
	
}

/*------------------------------------------------------------------
[Table of contents]

1. Group button on top menu
2. Latest deals products
3. Products list
4. Header
5. Category featured
6. Banner bottom
7. Blogs
8. Services
9. Footer
10. Owl carousel vertical
11. Styles for devices(>1200px)
12. Styles for devices(>=992px and <=1199px)
13. Styles for devices(>=768px and <=992px)
14. Styles for devices(>=481px and <=767px)
15. Styles for devices(<=480px)

-------------------------------------------------------------------*/

/*-------------------
[2. Latest deals products]
*/
.latest-deals-product{
  margin-top: 20px;
  position: relative;
}
.latest-deals-product .count-down-time2{
  position: absolute;
  top: -61px;
  right: 80px;
}
.latest-deals-product .product-list li{
  border: 1px solid #eaeaea;
  overflow: hidden;
  padding-bottom: 5px;
}
.latest-deals-product .product-list li:hover{
  border: 1px solid #958457;
}
.latest-deals-product .owl-next{
  top: -40px;
}
.latest-deals-product .owl-prev{
  top: -40px;
  left: inherit;
  right: 26px;
}

.count-down-time2{
  text-transform: uppercase;
  font-size: 14px;
  font-weight: normal;
  line-height: 40px;
}
.count-down-time2 .icon-clock{
  width: 23px;
  height: 26px;
  background: url("../images/icon-clock.png") no-repeat center center;
  display: inline-block;
  margin-top: 5px;
}
.count-down-time2 .box-count{
  text-transform: none;
  color: #f96d10;
  border: 1px solid #f96d10;
  height: 30px;
  line-height: 30px;
  display: inline-block;
  padding: 0 10px;
  margin-top: 4px;
  margin-right: 4px;
  margin-left: 4px;
}


/*
[3. Products list]
*/
.option2 .product-list li .quick-view{
	right: 10px;
}
.option2 .product-list li .quick-view a:hover{
	background: #958457;
}
.option2 .product-list li .quick-view a:hover{
	background: #958457;
}
.option2 .product-list li .quick-view a:hover {
	background: #958457;
}
.option2 .product-list li .add-to-cart:hover{
	background: #958457;
}
.option2 .product-list li .product-price {
	color: #f96d10;
}


/*
[4. Header ]
*/
.option2 .cart-block{
	margin-top: 5px;
}
.option2 .cart-block .cart-block-content .product-info .p-right .p-rice{
	  color: #f96d10;
}
.option2 #shopping-cart-box-ontop .cart-block{
	margin-top: 0;
}
.option2 a:hover{
	color: #4c311d;
}
.option2 .top-header .dropdown-menu{
	border-top: 2px solid #958457;
}
.option2 .main-header .header-search-box{
	padding-right: 0;
}
.option2 .main-header .header-search-box .form-inline .form-category{
	float: right;
	margin-right: 40px;
	border-left: 1px solid #eaeaea;
}
.option2 .main-header .header-search-box .form-inline .input-serach{
	padding-top: 9px;
}
.option2 .main-header .header-search-box .form-inline .btn-search{
	background-color: #958457;
}

.option2 .nav-top-menu.nav-ontop{
	background: #958457;
}
.option2 .nav-top-menu{
	background: #958457;
}
.option2 #main-menu .navbar{
	border-radius: 0;
}
.option2 #main-menu .navbar-default .navbar-nav>li>a{
	color: #fff;
	border-right: none;
}
.option2 #main-menu .navbar-default .navbar-nav>li:last-child>a{
	background: none;
}
.option2 #main-menu .navbar .navbar-nav>li:hover, 
.option2 #main-menu .navbar .navbar-nav>li.active{
	background-image: none;
	background: #ab9d77;
}
.option2 #main-menu .navbar .navbar-nav>li:hover a, 
.option2 #main-menu .navbar .navbar-nav>li.active a{
	background: none;
}
.option2 #main-menu li.dropdown>a:after{
	position: absolute;
	left: 46%;
	-ms-transform: translateX(-50%);
  	-webkit-transform: translateX(-50%);
  	transform: translateX(-50%);
	top: 15px;
	font-size: 12px;
}
.option2 #main-menu li.dropdown:hover:before{
	display: none;
}

.option2 .box-vertical-megamenus .title{
	background: #4c311d;
}
.option2 .box-vertical-megamenus .vertical-menu-content{
	border-top: none;
}

.option2 .nav-ontop #box-vertical-megamenus .title{
	background: #958457;
	color: #fff;
	border-left: none;
}
.option2 #form-search-opntop .btn-search:before{
	color: #fff;
}
.option2 #form-search-opntop form .input-serach input{
	color: #fff;
}
.option2 #form-search-opntop form .input-serach input
.option2 #form-search-opntop form .input-serach input::-webkit-input-placeholder { color:#fff; }
.option2 #form-search-opntop form .input-serach input::-webkit-input-placeholder { color:#fff;  }
.option2 #form-search-opntop form .input-serach input::-webkit-input-placeholder { color:#fff; }

.option2 #form-search-opntop:hover form{
  border: 1px solid #dfdfdf;
  background: #958457;
}
.option2 #user-info-opntop a.current-open:before {
  color: #fff;
}
.option2 #shopping-cart-box-ontop .fa{
	color: #fff;
}
.option2 .header-top-right{
	border-top: none;
}
.option2 .header-top-right .homeslider {
	width: 100%;
}
.option2 .header-top-right .homeslider .bx-controls-direction .bx-prev, 
.option2 .header-top-right .homeslider .bx-controls-direction .bx-next{
	background: #958457;
}
.option2 .header-top-right .homeslider .bx-wrapper .bx-pager.bx-default-pager a:hover,
.option2 .header-top-right .homeslider .bx-wrapper .bx-pager.bx-default-pager a.active{
	background: #958457;
}

.option2 .box-vertical-megamenus .vertical-menu-list {
	padding-top: 4px;
}
.option2 .box-vertical-megamenus .vertical-menu-list li{
	border: none;
	padding: 0 20px;
}
.option2 .box-vertical-megamenus .vertical-menu-list>li:hover{
	background: #958457;
}
.option2 .box-vertical-megamenus .vertical-menu-list>li:hover>a{
	color: #fff;
	border-color: transparent;
}
.option2 .box-vertical-megamenus .vertical-menu-list>li:hover>a:before{
	color: #fff;
}
.option2 .box-vertical-megamenus .vertical-menu-list:li:last-child>a{
	border:none;
}
.option2 .box-vertical-megamenus .vertical-menu-list>li>a{
	border:none;
	padding-left: 0;
	border-bottom: 1px dotted #eaeaea;
	line-height: 36px;
}
.option2 .box-vertical-megamenus .vertical-menu-list li:hover{
	border-left: none;
}
.option2 .box-vertical-megamenus .vertical-menu-list li:hover>a{
	border-top: none;
}
.option2 .box-vertical-megamenus .all-category{
	margin-top: 0px;
	padding-right: 0;
}
.option2 .vertical-dropdown-menu .mega-group-header span{
	border-color: #958457;
}
.option2 .box-vertical-megamenus .all-category span:hover{
	background: #958457;
	color: #fff;
	border-color: #958457;
}
.option2 .box-vertical-megamenus .all-category span:after{
	  content: "\f101";
	  font-size: 16px;
	  font-weight: normal;
}
.option2 .box-vertical-megamenus .vertical-menu-content ul>li>a.parent:before{
	right: 20px;
}
.option2 .vertical-dropdown-menu .mega-products .mega-product .product-price .new-price{
	  color: #f96d10;
}
.option2 .cart-block .cart-block-content .cart-buttons a.btn-check-out{
	background: #958457;
}

.option2 .page-heading{
	font-size: 16px;
	font-weight: bold;
}
.option2 .page-heading span.page-heading-title{
	border-bottom: 3px solid #958457;
}

.option2 .owl-controls .owl-prev:hover, 
.option2 .owl-controls .owl-next:hover {
  background: #958457;
  color: #fff;
}

.option2 .content-page {
	background: #eaeaea;
}
.option2 #main-menu .dropdown-menu .block-container .group_header>a{
	border-color: #958457;
}

/*
[5. Category featured]
*/

.option2 .show-brand .navbar-brand{
	width: 200px;
	position: relative;
	padding-left: 10px;
	font-family: 'Arial Narrow', Arial, sans-serif;
	font-size: 22px;
	font-weight: normal;
}
.option2 .show-brand .navbar-brand img{
	margin-right: 10px;
}
.option2 .show-brand .navbar-brand>a:hover{
	color: #fff;

}
.option2 .show-brand .navbar-brand:after{
	content: '';
	width: 12px;
	height: 20px;
	position: absolute;
	right: 5px;
	color: #fff;
	font-weight: normal;
	background: url("../images/icon-angle-right.png") no-repeat right center;
	top: 50%;
	-ms-transform: translateY(-50%);
	-webkit-transform: translateY(-50%);
	transform: translateY(-50%);
}
.option2 .nav-menu{
	margin-bottom: 0;
}
.option2 .nav-menu .nav>li>a{
	background: none;
	padding: 14px 15px;
	margin-left: 10px;
}
.option2 .nav-menu .nav>li>a:after{
	font: normal normal normal 14px/1 FontAwesome;
	content: "\f0d8";
	position: absolute;
	bottom: -40px;
	left: 50%;
	-ms-transform: translateX(-50%);
	-webkit-transform: translateX(-50%);
	transform: translateX(-50%);
	color: #fff;
	-webkit-transition: all 0.3s ease-out 0s;
	  -moz-transition: all 0.3s ease-out 0s;
	  -o-transition: all 0.3s ease-out 0s;
	  transition: all 0.3s ease-out 0s;
	  opacity: 0;
	  visibility: hidden;
}
.option2 .nav-menu .nav>li>a:before{
	content: '';
	width: 100%;
	height: 1px;
	background: #fa8334;
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	transform: scale(0, 1);
}
.option2 .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #fa8334;
}
.option2 .nav-menu .nav>li:hover a,
.option2 .nav-menu .nav>li.active a{
}

.option2 .nav-menu .nav>li:hover a:before,
.option2 .nav-menu .nav>li.active a:before{
	transform: scale(1);
  -webkit-transition: all 0.3s ease-out 0s;
  -moz-transition: all 0.3s ease-out 0s;
  -o-transition: all 0.3s ease-out 0s;
  transition: all 0.3s ease-out 0s;
}
.option2 .nav-menu .nav>li:hover a:after,
.option2 .nav-menu .nav>li.active a:after{
	color: #fa8334;
	bottom: -6px;
	opacity: 1;
	visibility: inherit;
}

.option2 .product-featured{
	margin-top: 0;
}
.option2 .product-featured .sub-category-list{
	float: left;
	padding: 20px 30px;
	line-height: 30px;
	background: #fff;
}
.option2 .product-featured .product-featured-tab-content{
}
.option2 .product-featured .product-featured-tab-content .box-left{
	width: 40%;
	float: left;
	border-left: 1px solid #eaeaea;
}
.option2 .product-featured .product-featured-tab-content .box-right{
	width: 60%;
	float: left;
}
.option2 .product-featured .product-featured-tab-content .box-full{
	width: 100%;
	float: left;
	border-left: 1px solid #eaeaea;
} 
.option2 .product-featured .product-featured-tab-content .box-full .product-list li{
	width: 20%;
	float: left;
	border-bottom: none;
}
.option2 .product-featured .product-featured-tab-content .category-banner{
	padding-right: 0;
}
.option2 .product-featured .product-featured-tab-content .category-banner img{
	
}
.option2 .product-featured .product-featured-tab-content .category-list-product{
	padding-left: 0;
}
.option2 .product-featured .product-list{
	margin-left: 0;
	margin-right: 0;

}
.option2 .product-featured .product-list li{
	padding: 0;
	min-height: inherit;
	border-right: 1px solid #eaeaea;
	border-top: 1px solid #eaeaea;
	padding-bottom: 3px;
	min-height: 286px;
}

.option2 .product-featured .owl-prev, 
.option2 .product-featured .owl-next {
  background: transparent;
  width: 28px;
  height: 28px;
  color: #ccc;
  text-align: center;
  padding-top: 0;
  font-size: 48px;
}
.option2 .product-featured .owl-next{
	background: url("../images/next.png") no-repeat center center;
}
.option2 .product-featured .owl-prev{
	background: url("../images/prev.png") no-repeat center center;
}
.option2 .product-featured .owl-prev .fa, 
.option2 .product-featured .owl-next .fa{
	font-weight: normal;
	line-height: 28px;
	display: none;
}
.option2 .product-featured .owl-prev:hover{
	background: url("../images/prev.png") no-repeat center center;
}

.option2 .product-featured .owl-next:hover{
	background: url("../images/next.png") no-repeat center center;
}

.option2 .product-featured .deal-product{
	line-height: 24px;
	border-right: 1px solid #eaeaea;
	overflow: hidden;
	padding-bottom: 23px;
}
.option2 .product-featured .deal-product .deal-product-head{
	text-align: center;
}
.option2 .product-featured .deal-product .deal-product-head h3{
	position: relative;
    z-index: 1;
    margin-top: 15px;
}
.option2 .product-featured .deal-product .deal-product-head h3:before{
	border-top: 1px solid #eaeaea;
    content:"";
    margin: 0 auto; /* this centers the line to the full width specified */
    position: absolute; /* positioning must be absolute here, and relative positioning must be applied to the parent */
    top: 40%; left: 40px; right: 40px; bottom: 0;
    width: 95%;
    z-index: -1;
    width: 300px;/*
    -ms-transform: translateY(-50%);
  -webkit-transform: translateY(-50%);
  transform: translateY(-50%);*/
}
.option2 .product-featured .deal-product .deal-product-head h3>span{
	background: #fff; 
    padding: 0 5px; 
    font-size: 14px;
    font-weight: bold;
}
.option2 .product-featured .deal-product .deal-product-content .deal-product-info{
	padding-left: 0;
}
.option2 .product-featured .deal-product .deal-product-content{
	margin-top: 10px;
}
.option2 .product-featured .deal-product .price{
	margin-top: 4px;
}
.option2 .product-featured .deal-product .price span{
	margin-right: 10px;
}
.option2 .product-featured .deal-product .price .product-price{
	color: #958457;
	font-size: 18px;
}
.option2 .product-featured .deal-product .price .old-price{
	text-decoration: line-through;
}
.option2 .product-featured .deal-product .price .sale-price{
	background: url("../images/sale-bg.png") no-repeat;
	color: #fff;
	padding: 0 7px;
}
.option2 .product-featured .deal-product .product-star{
	color: #febf2b;
	margin-top: 15px;
}
.option2 .product-featured .deal-product .product-desc{
	margin-top: -3px;
}
.option2 .product-featured .deal-product .show-count-down{
	overflow: hidden;
	margin-top: 11px;
	font-family: 'Arial Narrow', Arial, sans-serif;
	line-height: normal;
}
.option2 .product-featured .deal-product .show-count-down .dot{
	display: none;
}
.option2 .product-featured .deal-product .show-count-down .box-count{
	font-size: 20px;
	color: #717171;
	background: #f6f6f6;
	text-align: center;
	width: 45px;
	height: 47px;
	display: table-cell;
	float: left;
	margin-right: 5px;
}
.option2 .product-featured .deal-product .show-count-down .box-count .number{
	width: 45px;
	font-size: 18px;
	display: table;
	margin-top: 4px;
}
.option2 .product-featured .deal-product .show-count-down .box-count .text{
	width: 45px;
	font-size: 14px;
	display: table;
}
.option2 .product-featured .manufacture-list{
	padding-right: 0;
	float: left;
	overflow: hidden;
}
.option2 .product-featured .manufacture-list .manufacture-waper{
	border: 1px solid #eaeaea;
	padding: 44px 0px 44px 0;
	border-top: none;
	position: relative;
	border-bottom: none;
}
.option2 .product-featured .manufacture-list .manufacture-waper ul{
	padding: 0 20px;
	background: #fff;
}

.option2 .product-featured .manufacture-list .manufacture-waper .owl-prev{
	position: absolute;
	top: -16px;
	left: 0;
	right: 0;
	border-bottom: 1px solid #eaeaea;
}
.option2 .product-featured .manufacture-list .manufacture-waper .owl-next{
	position: absolute;
	bottom: -64px;
	top: inherit;
	left: 0;
	right: 0;
	border-top: 1px solid #eaeaea;
	border-bottom: 1px solid #eaeaea;
	padding-top: 12px;
	height: 42px;
}
.option2 .product-featured .manufacture-list .manufacture-waper .owl-controls .owl-nav{
	margin: 0;
	padding: 0;
}
.option2 .product-list li .add-to-cart:hover{
	opacity: 1;
}
.option2 .product-list li .add-to-cart a {
	  background: url("../images/icon-cart-option2.png") no-repeat left center;
}
.option2 .product-list li .quick-view a.compare:before{
	  content: "\f066";
}

/** OPTION CATEGORY **/

.option2 .category-featured.fashion .sub-category-list a:hover{
	color: #ff3366;
}
.option2 .category-featured.fashion .navbar-brand{
	background: #ff3366;
}
.option2 .category-featured.fashion .navbar-brand a:hover{
	color: #fff;
}
.option2 .category-featured.fashion .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #ff3366;
}
.option2 .category-featured.fashion .nav-menu .nav>li:hover a,
.option2 .category-featured.fashion .nav-menu .nav>li.active a{
	color: #ff3366;
}

.option2 .category-featured.fashion .nav-menu .nav>li:hover a:after,
.option2 .category-featured.fashion .nav-menu .nav>li.active a:after{
	color: #ff3366;
}

.option2 .category-featured.fashion .nav-menu .nav>li>a:before{
	background: #ff3366;
}

.option2 .category-featured.fashion .product-list li .add-to-cart {
	background-color: rgba(255, 51, 102, 0.7);
	background: rgba(255, 51, 102, 0.7);
	color: rgba(255, 51, 102, 0.7);
}
.option2 .category-featured.fashion .product-list li .add-to-cart:hover {
	background: #ff3366;
}

.option2 .category-featured.fashion .product-list li .quick-view a.search:hover,
.option2 .category-featured.fashion .product-list li .quick-view a.compare:hover,
.option2 .category-featured.fashion .product-list li .quick-view a.heart:hover{
	background-color: #ff3366;
	opacity: 0.9;
}

/** sports **/
.option2 .category-featured.sports .sub-category-list a:hover{
	color: #00a360;
}
.option2 .category-featured.sports .navbar-brand{
	background: #00a360;
}
.option2 .category-featured.sports .navbar-brand a:hover{
	color: #fff;
}
.option2 .category-featured.sports .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #00a360;
}
.option2 .category-featured.sports .nav-menu .nav>li:hover a,
.option2 .category-featured.sports .nav-menu .nav>li.active a{
	color: #00a360;
}
.option2 .category-featured.sports .nav-menu .nav>li:hover a:after,
.option2 .category-featured.sports .nav-menu .nav>li.active a:after{
	color: #00a360;
}

.option2 .category-featured.sports .nav-menu .nav>li>a:before{
	background: #00a360;
}

.option2 .category-featured.sports .product-list li .add-to-cart {
	background-color: rgba(0, 163, 96, 0.7);
	background: rgba(0, 163, 96, 0.7);
	color: rgba(0, 163, 96, 0.7);
}
.option2 .category-featured.sports .product-list li .add-to-cart:hover {
	background: #00a360;
}
.option2 .category-featured.sports .product-list li .quick-view a.search:hover,
.option2 .category-featured.sports .product-list li .quick-view a.compare:hover,
.option2 .category-featured.sports .product-list li .quick-view a.heart:hover{
	background-color: #00a360;
	opacity: 0.9;
}

/** electronic **/
.option2 .category-featured.electronic .sub-category-list a:hover{
	color: #0090c9;
}
.option2 .category-featured.electronic .navbar-brand{
	background: #0090c9;
}
.option2 .category-featured.electronic .navbar-brand a:hover{
	color: #fff;
}
.option2 .category-featured.electronic .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #0090c9;
}
.option2 .category-featured.electronic .nav-menu .nav>li:hover a,
.option2 .category-featured.electronic .nav-menu .nav>li.active a{
	color: #0090c9;
}
.option2 .category-featured.electronic .nav-menu .nav>li>a:before{
	background: #0090c9;
}
.option2 .category-featured.electronic .nav-menu .nav>li:hover a:after,
.option2 .category-featured.electronic .nav-menu .nav>li.active a:after{
	color: #0090c9;
}

.option2 .category-featured.electronic .product-list li .add-to-cart {
	background-color: rgba(0, 144, 201, 0.7);
	background: rgba(0, 144, 201, 0.7);
	color: rgba(0, 144, 201, 0.7);
}
.option2 .category-featured.electronic .product-list li .add-to-cart:hover {
	background-color: #0090c9;
}
.option2 .category-featured.electronic .product-list li .quick-view a.search:hover,
.option2 .category-featured.electronic .product-list li .quick-view a.compare:hover,
.option2 .category-featured.electronic .product-list li .quick-view a.heart:hover{
	background-color: #0090c9;
	opacity: 0.9;
}
/** digital **/
.option2 .category-featured.digital .sub-category-list a:hover{
	color: #3f5eca;
}
.option2 .category-featured.digital .navbar-brand{
	background: #3f5eca;
}
.option2 .category-featured.digital .navbar-brand a:hover{
	color: #fff;
}
.option2 .category-featured.digital .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #3f5eca;
}
.option2 .category-featured.digital .nav-menu .nav>li:hover a,
.option2 .category-featured.digital .nav-menu .nav>li.active a{
	color: #3f5eca;
}
.option2 .category-featured.digital .nav-menu .nav>li>a:before{
	background: #3f5eca;
}
.option2 .category-featured.digital .nav-menu .nav>li:hover a:after,
.option2 .category-featured.digital .nav-menu .nav>li.active a:after{
	color: #3f5eca;
}
.option2 .category-featured.digital .product-list li .add-to-cart {
	background-color: rgba(63, 94, 202, 0.7);
	background: rgba(63, 94, 202, 0.7);
	color: rgba(63, 94, 202, 0.7);
}
.option2 .category-featured.digital .product-list li .add-to-cart:hover {
	background-color: #3f5eca;
}
.option2 .category-featured.digital .product-list li .quick-view a.search:hover,
.option2 .category-featured.digital .product-list li .quick-view a.compare:hover,
.option2 .category-featured.digital .product-list li .quick-view a.heart:hover{
	background-color: #3f5eca;
	opacity: 0.9;
}
/** furniture **/
.option2 .category-featured.furniture .sub-category-list a:hover{
	color: #669900;
}
.option2 .category-featured.furniture .navbar-brand{
	background: #669900;
}
.option2 .category-featured.furniture .navbar-brand a:hover{
	color: #fff;
}
.option2 .category-featured.furniture .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #669900;
}
.option2 .category-featured.furniture .nav-menu .nav>li:hover a,
.option2 .category-featured.furniture .nav-menu .nav>li.active a{
	color: #669900;
}
.option2 .category-featured.furniture .nav-menu .nav>li>a:before{
	background: #669900;
}
.option2 .category-featured.furniture .nav-menu .nav>li:hover a:after,
.option2 .category-featured.furniture .nav-menu .nav>li.active a:after{
	color: #669900;
}

.option2 .category-featured.furniture .product-list li .add-to-cart {
	background-color: rgba(102, 153, 0, 0.7);
	background: rgba(102, 153, 0, 0.7);
	color: rgba(102, 153, 0, 0.7);
}
.option2 .category-featured.furniture .product-list li .add-to-cart:hover {
	background-color: #669900;
}

.option2 .category-featured.furniture .product-list li .quick-view a.search:hover,
.option2 .category-featured.furniture .product-list li .quick-view a.compare:hover,
.option2 .category-featured.furniture .product-list li .quick-view a.heart:hover{
	background-color: #669900;
	opacity: 0.9;
}

/** jewelry **/
.option2 .category-featured.jewelry .sub-category-list a:hover{
	color: #6d6855;
}
.option2 .category-featured.jewelry .navbar-brand{
	background: #6d6855;
}
.option2 .category-featured.jewelry .navbar-brand a:hover{
	color: #fff;
}
.option2 .category-featured.jewelry .nav-menu .navbar-collapse {
	background: #fff;
	border-bottom: 2px solid #6d6855;
}
.option2 .category-featured.jewelry .nav-menu .nav>li:hover a,
.option2 .category-featured.jewelry .nav-menu .nav>li.active a{
	color: #6d6855;
}
.option2 .category-featured.jewelry .nav-menu .nav>li>a:before{
	background: #6d6855;
}
.option2 .category-featured.jewelry .nav-menu .nav>li:hover a:after,
.option2 .category-featured.jewelry .nav-menu .nav>li.active a:after{
	color: #6d6855;
}
.option2 .category-featured.jewelry .product-list li .add-to-cart {
	background-color: #6d6855;
}
.option2 .category-featured.jewelry .product-list li .add-to-cart {
	background-color: rgba(109, 104,85, 0.7);
	background: rgba(109, 104,85, 0.7);
	color: rgba(109, 104,85, 0.7);
}
.option2 .category-featured.jewelry .product-list li .add-to-cart:hover {
	background-color: #6d6855;
}

.option2 .category-featured.jewelry .product-list li .quick-view a.search:hover,
.option2 .category-featured.jewelry .product-list li .quick-view a.compare:hover,
.option2 .category-featured.jewelry .product-list li .quick-view a.heart:hover{
	background-color: #6d6855;
	opacity: 0.9;
}
/****/

/*-----------------
[6. Banner bootom]
*/
.option2 .banner-bottom .item-left{
	padding-right: 0;
}
.option2 .banner-bottom .item-right{
	padding-left: 0;
}




/*--------------
[8. Services]
*/
.services2{
	margin-top: 30px;
	border-top: 1px solid #eaeaea;
	border-right: 1px solid #eaeaea;
	overflow: hidden;
}
.services2 .services2-item{
	padding: 0;
	border-left: 1px solid #eaeaea;
	border-bottom: 1px solid #eaeaea;
	padding-bottom: 15px;
	min-height: 120px;
}
.services2 .services2-item .image{
	text-align: center;
	color: #333333;
	padding-left: 30px;
	font-size: 14px;
	text-transform: uppercase;
	font-weight: normal;
}
.services2 .services2-item .image h3{
	font-size: 14px;
	color: #333333;
	font-weight: 600;
	margin-top: 10px;
}
.services2 .services2-item .text{
	padding-top: 15px;
	color: #919191;
	padding-left: 0;
	padding-right: 30px;

}


/*--------------
[9. Footer]
*/
.option2 #footer{
	margin-top: 60px;
}
.option2 #mail-box .btn{
	background: #958457;
}

.option2 .scroll_top:hover{
	background: #958457;
}


/*-----------------
[10. Owl carousel vertical]
*/
.owl-carousel-vertical .owl-next,
.owl-carousel-vertical .owl-prev{
	position: inherit;
	width: 100%!important;
	height: 17px;
	margin: 0 auto;
	float: left;
	opacity: 1;
	visibility: inherit;
	background: none;

}
.owl-carousel-vertical .owl-controls .owl-nav{
	margin: 0 auto;
	text-align: center;
	display: table-cell;
	width: 100%!important;
	float: left;
}

.option2 .product-featured .owl-carousel-vertical .owl-controls .owl-nav{
	margin-top: 26px;
	padding-left: 30px;
}
.option2 .product-featured .owl-carousel-vertical .owl-controls .owl-nav .owl-next,
.option2 .product-featured .owl-carousel-vertical .owl-controls .owl-nav .owl-prev{
	background: none;
}

.option2 .blog-list .blog-list-wapper ul li .readmore a{
	color: #958457;
}


/** REPONSIVE **/
/*----------------
[11. Styles for devices(>1200px)]
*/
@media (min-width: 1201px){
	
}
/*----------------
[12. Styles for devices(>=993px and <=1200px)]
*/
@media (min-width: 993px) and (max-width: 1200px) {
	.option2 .group-button-header{
		width: 25%;
		float: right;
	}
	.option2 .sub-category-wapper{
		width: 15%;
		display: none;
	}
	.option2 .col-right-tab{
		width: 100%;

	}
	.option2 .product-featured .manufacture-list .manufacture-waper{
		display: none;
	}
	.option2 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
	}
	.option2 .product-featured .product-featured-tab-content .category-list-product .product-list{
		border-left: 1px solid #eaeaea;
	}
}
/*--------------------
[13. Styles for devices(>=768px and <=992px)]
*/
@media (min-width: 768px) and (max-width: 992px) {
	.option2 .group-button-header{
		width: 30%;
		float: right;
	}
	.option2 .nav-menu .nav>li>a{
		padding: 14px 10px;
		margin-left: 0;
	}
	.option2 .product-featured .product-featured-tab-content .box-left{
		width: 100%;
	}
	.option2 .product-featured .product-featured-tab-content .box-right{
		width: 100%;
		border-left: 1px solid #eaeaea;
	}
	.option2 .sub-category-wapper{
		width: 20%;
	}
	.option2 .col-right-tab{
		width: 80%;
	}
	.option2 .show-brand .navbar-brand{
		width: 21%;
		padding-right: 30px;
		font-size: 14px;
		font-weight: bold;
	}
	.option2 .product-featured .sub-category-list{
		padding: 10px;
	}
	.option2 .product-featured .box-left .banner-img{
		display: none;
	}
	.option2 .product-featured .manufacture-list .manufacture-waper{
		display: none;
	}
	.option2 .product-featured .product-featured-tab-content .box-full .product-list li{
		width: 33.3333%;
	}
	.option2 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
	}
	.option2 .product-featured .product-featured-tab-content .category-list-product .product-list{
		border-left: 1px solid #eaeaea;
	}
	.option2 .product-featured .product-featured-tab-content .category-list-product .product-list li{
		width: 33.3333%;
	}
	
}
/*--------------------
[14. Styles for devices(>=481px and <=767px)]
*/
@media (min-width: 481px) and (max-width: 767px) { 
	.group-button-header{
		width: 100%;
		margin-top: 30px;
	}
	.main-header .group-button-header .btn-cart:hover .cart-block {
		display: none;
	}
	.option2 .main-header .header-search-box{
		padding-right: 15px;
	}
	.option2 #main-menu .navbar{
		background: none;
	}
	.option2 #main-menu .navbar-header{
		background: #f96d10;
	}
	.option2 #main-menu .navbar-default .navbar-nav>li>a{
		background: none;
		color: #999;
	}
	.option2 #main-menu li.dropdown>a:after {
	  position: absolute;
	  left: inherit;
	  right: 10px;
	  -ms-transform: translateY(-50%);
	  -webkit-transform: translateY(-50%);
	  transform: translateY(-50%);
	  top: 50%;
	  font-size: 12px;
	}
	.option2 #main-menu .navbar .navbar-nav>li:hover,
	.option2 #main-menu .navbar .navbar-nav>li.active{
		background: none;
	}
	.latest-deals-product .count-down-time2{
		position: inherit;
		top: inherit;
		right: inherit;
	}
	.latest-deals-product .owl-prev {
	  top: 50%;
	  left: 0;
	  right: inherit;
	}
	.latest-deals-product .owl-next {
	  top: 50%;
	}
	.option2 .content-page{
		margin-top: 30px;
	}
	.option2 .nav-menu{
		background: #ccc;
	}
	.option2 .nav-menu .nav>li>a{
		margin-left: 0;
		padding: 5px 15px;
	}
	
	.option2 .nav-menu .nav>li>a:after{
		display: none;
	}
	.option2 .product-featured .sub-category-wapper{
		width: 100%;
		padding: 15px;
		display: none;
	}
	.option2 .product-featured .product-featured-tab-content .box-left{
		width: 100%;
		display: none;
	}
	.option2 .product-featured .product-featured-tab-content .box-right{
		width: 100%;
		border-left: 1px solid #eaeaea;
	}
	.option2 .product-featured .deal-product .deal-product-content .deal-product-info{
		padding-left: 15px;
	}
	.option2 .product-featured .product-featured-tab-content .box-full .product-list li{
		width: 50%;
		float: left;
	}
	.services2 .services2-item .image{
		padding: 15px 30px 0 30px 0;
	}
	.services2 .services2-item .text{
		padding: 15px 30px;
		text-align: center;
	}
	.option2 .product-featured .manufacture-list{
		display: none;
	}
	.option2 .product-featured .product-list li{
		width: 50%;
		float: left;
	}
	.option2 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
		border-left: 1px solid #eaeaea;
	}
}
/*--------------------
[15. Styles for devices(<=480px)]
*/
@media (max-width: 480px) {
	.group-button-header{
		width: 100%;
		margin-top: 30px;
	}
	.main-header .group-button-header .btn-cart:hover .cart-block {
		display: none;
	}
	.option2 .main-header .header-search-box{
		padding-right: 15px;
	}
	.option2 #main-menu .navbar{
		background: none;
	}
	.option2 #main-menu .navbar-header{
		background: #f96d10;
	}
	.option2 #main-menu .navbar-default .navbar-nav>li>a{
		background: none;
		color: #999;
	}
	.option2 #main-menu li.dropdown>a:after {
	  position: absolute;
	  left: inherit;
	  right: 10px;
	  -ms-transform: translateY(-50%);
	  -webkit-transform: translateY(-50%);
	  transform: translateY(-50%);
	  top: 50%;
	  font-size: 12px;
	}
	.option2 #main-menu .navbar .navbar-nav>li:hover,
	.option2 #main-menu .navbar .navbar-nav>li.active{
		background: none;
	}
	.latest-deals-product .count-down-time2{
		position: inherit;
		top: inherit;
		right: inherit;
	}
	.latest-deals-product .owl-prev {
	  top: 50%;
	  left: 0;
	  right: inherit;
	}
	.latest-deals-product .owl-next {
	  top: 50%;
	}
	.option2 .content-page{
		margin-top: 30px;
	}
	.option2 .nav-menu{
		background: #ccc;
	}
	.option2 .nav-menu .nav>li>a{
		margin-left: 0;
		padding: 5px 15px;
	}
	
	.option2 .nav-menu .nav>li>a:after{
		display: none;
	}

	.option2 .product-featured .sub-category-wapper{
		display: none;
	}
	.option2 .product-featured .product-featured-tab-content .box-left{
		width: 100%;
		display: none;
	}
	.option2 .product-featured .product-featured-tab-content .box-right{
		width: 100%;
	}
	.option2 .product-featured .deal-product .deal-product-content .deal-product-info{
		padding-left: 15px;
	}
	.option2 .product-featured .product-featured-tab-content .box-full .product-list li{
		width: 100%;
	}
	.services2 .services2-item .image{
		padding: 15px 30px 0 30px 0;
	}
	.services2 .services2-item .text{
		padding: 15px 30px;
		text-align: center;
	}
	.option2 .product-featured .manufacture-list{
		display: none;
	}
	.option2 .product-featured .product-list li{
		border-right: none;
	}
	.option2 .product-featured .product-featured-tab-content .category-list-product{
		padding-left: 15px;
		border-left: 1px solid #eaeaea;
	}

}
.keypadlogin_div{background-color:#cccccc;}

.border{border-left:#093682 2px solid;background-color:#f4f4f5;border-right:#093682 2px solid}
.sk_mini{font-family:Arial, Helvetica, sans-serif;color:#004774;font-size:9px;font-weight:bold}
.sk_regular{font-family:Arial, Helvetica, sans-serif;color:#093682;font-size:11px;font-weight:bold}
.tdbuton{border-bottom:#a5a5a6 1px solid;border-left:#fff 1px solid;background-color:#d9dadc;border-top:#fff 1px solid;border-right:#a5a5a6 1px solid}
.buton{border-bottom:0;text-align:center;border-left:0;background-color:#d9dadc;width:16px;font-family:Arial, Helvetica, sans-serif;height:16px;color:#000;font-size:11px;vertical-align:middle;border-top:0;cursor:hand;font-weight:700;border-right:0;text-decoration:none}
.text{font-family:Tahoma}
.keypadHeader{background-color:#6e00a4;font-family:Tahoma, Verdana, Helvetica, sans-serif;margin-bottom:0;color:#fff;font-size:11px;cursor:move;font-weight:700;text-decoration:none}
.keypadButton{width:30px; height:30px;font-family:Tahoma, Verdana, Helvetica, sans-serif;color:#f5f5f5;text-decoration:none;text-align:center}
.keypadButtonNum{width:30px; height:30px; font-family:Tahoma, Verdana, Helvetica, sans-serif;color:#004774;text-decoration:none;text-align:center}
.keypadButton3{background-color:#CCC;width:94px;font-family:Tahoma, Verdana, Helvetica, sans-serif;height:19px;color:#067ec7;font-size:10px;vertical-align:middle;font-weight:700;text-decoration:none}
.buttonErase{background-color:#CCC;width:48px;font-family:Tahoma, Verdana, Helvetica, sans-serif;height:19px;color:#067ec7;font-size:10px;vertical-align:middle;font-weight:700;text-decoration:none}
.yellowtext{font-family:Arial, Helvetica, sans-serif;color:#ffea5c;font-size:11px}
.LColor1{z-index:2;border-bottom:1px solid;border-left:1px solid;background-color:#06b5d7;font-family:Tahoma, Verdana, Arial, Helvetica;color:#fff;font-size:13px;border-top:1px solid;font-weight:700;border-right:1px solid;padding:5px}
.LColor2{z-index:3;border-bottom:1px solid;border-left:1px solid;background-color:#f2074f;font-family:Tahoma, Verdana, Arial, Helvetica;color:#fff;font-size:13px;border-top:1px solid;font-weight:700;border-right:1px solid;padding:5px}
.LColor3{z-index:4;border-bottom:1px solid;border-left:1px solid;background-color:#e715cf;font-family:Tahoma, Verdana, Arial, Helvetica;color:#fff;font-size:13px;border-top:1px solid;font-weight:700;border-right:1px solid;padding:5px}
.LColor4{z-index:1;border-bottom:1px solid;border-left:1px solid;background-color:#828282;font-family:Tahoma, Verdana, Arial, Helvetica;color:#fff;font-size:13px;border-top:1px solid;font-weight:700;border-right:1px solid;padding:5px}
.LColor5{z-index:6;border-bottom:1px solid;border-left:1px solid;background-color:#4ec964;font-family:Tahoma, Verdana, Arial, Helvetica;color:#fff;font-size:13px;border-top:1px solid;font-weight:700;border-right:1px solid;padding:5px}
.LColor6{z-index:5;border-bottom:1px solid;border-left:1px solid;background-color:#fbae56;font-family:Tahoma, Verdana, Arial, Helvetica;color:#fff;font-size:13px;border-top:1px solid;font-weight:700;border-right:1px solid;padding:5px}
.LColor7{z-index:7;border-bottom:1px solid;border-left:1px solid;background-color:#97a0a5;font-family:Tahoma, Verdana, Arial, Helvetica;color:#fff;font-size:13px;border-top:1px solid;font-weight:700;border-right:1px solid;padding:5px}
.keypadButton2,.keypadButtonOK{background-color:#CCC;width:70px;font-family:Tahoma, Verdana, Helvetica, sans-serif;height:19px;color:#067ec7;font-size:10px;vertical-align:middle;font-weight:700;text-decoration:none}

.yellowtext{font-family:Verdana, Arial, Helvetica, sans-serif;color:#fff;font-size:10px}
.keypadText{font-family:Verdana, Arial, Helvetica, sans-serif;color:#fff;font-size:9px}
.bluetext{font-family:Arial, Helvetica, sans-serif;color:#00f;font-size:11px}
.blueTitle1{font-family:Arial, Helvetica, sans-serif;color:#067ac7;font-size:12px}
.blueTextExp{font-family:Arial, Helvetica, sans-serif;color:#067ac7;font-size:11px}
A.ustsag:link,A.ustsag:visited,A.ustsag:hover,A.ustsag:active{color:#fff;text-decoration:none}

@charset "UTF-8";



/*!

Animate.css - http://daneden.me/animate

Licensed under the MIT license - http://opensource.org/licenses/MIT



Copyright (c) 2015 Daniel Eden

*/



.animated {

  -webkit-animation-duration: 1s;

  animation-duration: 1s;

  -webkit-animation-fill-mode: both;

  animation-fill-mode: both;

}



.animated.infinite {

  -webkit-animation-iteration-count: infinite;

  animation-iteration-count: infinite;

}



.animated.hinge {

  -webkit-animation-duration: 2s;

  animation-duration: 2s;

}



.animated.bounceIn,

.animated.bounceOut {

  -webkit-animation-duration: .75s;

  animation-duration: .75s;

}



.animated.flipOutX,

.animated.flipOutY {

  -webkit-animation-duration: .75s;

  animation-duration: .75s;

}



@-webkit-keyframes bounce {

  0%, 20%, 53%, 80%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    -webkit-transform: translate3d(0,0,0);

    transform: translate3d(0,0,0);

  }



  40%, 43% {

    -webkit-transition-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);

    transition-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);

    -webkit-transform: translate3d(0, -30px, 0);

    transform: translate3d(0, -30px, 0);

  }



  70% {

    -webkit-transition-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);

    transition-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);

    -webkit-transform: translate3d(0, -15px, 0);

    transform: translate3d(0, -15px, 0);

  }



  90% {

    -webkit-transform: translate3d(0,-4px,0);

    transform: translate3d(0,-4px,0);

  }

}



@keyframes bounce {

  0%, 20%, 53%, 80%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    -webkit-transform: translate3d(0,0,0);

    transform: translate3d(0,0,0);

  }



  40%, 43% {

    -webkit-transition-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);

    transition-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);

    -webkit-transform: translate3d(0, -30px, 0);

    transform: translate3d(0, -30px, 0);

  }



  70% {

    -webkit-transition-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);

    transition-timing-function: cubic-bezier(0.755, 0.050, 0.855, 0.060);

    -webkit-transform: translate3d(0, -15px, 0);

    transform: translate3d(0, -15px, 0);

  }



  90% {

    -webkit-transform: translate3d(0,-4px,0);

    transform: translate3d(0,-4px,0);

  }

}



.bounce {

  -webkit-animation-name: bounce;

  animation-name: bounce;

  -webkit-transform-origin: center bottom;

  transform-origin: center bottom;

}



@-webkit-keyframes flash {

  0%, 50%, 100% {

    opacity: 1;

  }



  25%, 75% {

    opacity: 0;

  }

}



@keyframes flash {

  0%, 50%, 100% {

    opacity: 1;

  }



  25%, 75% {

    opacity: 0;

  }

}



.flash {

  -webkit-animation-name: flash;

  animation-name: flash;

}



/* originally authored by Nick Pettit - https://github.com/nickpettit/glide */



@-webkit-keyframes pulse {

  0% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }



  50% {

    -webkit-transform: scale3d(1.05, 1.05, 1.05);

    transform: scale3d(1.05, 1.05, 1.05);

  }



  100% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }

}



@keyframes pulse {

  0% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }



  50% {

    -webkit-transform: scale3d(1.05, 1.05, 1.05);

    transform: scale3d(1.05, 1.05, 1.05);

  }



  100% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }

}



.pulse {

  -webkit-animation-name: pulse;

  animation-name: pulse;

}



@-webkit-keyframes rubberBand {

  0% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }



  30% {

    -webkit-transform: scale3d(1.25, 0.75, 1);

    transform: scale3d(1.25, 0.75, 1);

  }



  40% {

    -webkit-transform: scale3d(0.75, 1.25, 1);

    transform: scale3d(0.75, 1.25, 1);

  }



  50% {

    -webkit-transform: scale3d(1.15, 0.85, 1);

    transform: scale3d(1.15, 0.85, 1);

  }



  65% {

    -webkit-transform: scale3d(.95, 1.05, 1);

    transform: scale3d(.95, 1.05, 1);

  }



  75% {

    -webkit-transform: scale3d(1.05, .95, 1);

    transform: scale3d(1.05, .95, 1);

  }



  100% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }

}



@keyframes rubberBand {

  0% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }



  30% {

    -webkit-transform: scale3d(1.25, 0.75, 1);

    transform: scale3d(1.25, 0.75, 1);

  }



  40% {

    -webkit-transform: scale3d(0.75, 1.25, 1);

    transform: scale3d(0.75, 1.25, 1);

  }



  50% {

    -webkit-transform: scale3d(1.15, 0.85, 1);

    transform: scale3d(1.15, 0.85, 1);

  }



  65% {

    -webkit-transform: scale3d(.95, 1.05, 1);

    transform: scale3d(.95, 1.05, 1);

  }



  75% {

    -webkit-transform: scale3d(1.05, .95, 1);

    transform: scale3d(1.05, .95, 1);

  }



  100% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }

}



.rubberBand {

  -webkit-animation-name: rubberBand;

  animation-name: rubberBand;

}



@-webkit-keyframes shake {

  0%, 100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }



  10%, 30%, 50%, 70%, 90% {

    -webkit-transform: translate3d(-10px, 0, 0);

    transform: translate3d(-10px, 0, 0);

  }



  20%, 40%, 60%, 80% {

    -webkit-transform: translate3d(10px, 0, 0);

    transform: translate3d(10px, 0, 0);

  }

}



@keyframes shake {

  0%, 100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }



  10%, 30%, 50%, 70%, 90% {

    -webkit-transform: translate3d(-10px, 0, 0);

    transform: translate3d(-10px, 0, 0);

  }



  20%, 40%, 60%, 80% {

    -webkit-transform: translate3d(10px, 0, 0);

    transform: translate3d(10px, 0, 0);

  }

}



.shake {

  -webkit-animation-name: shake;

  animation-name: shake;

}



@-webkit-keyframes swing {

  20% {

    -webkit-transform: rotate3d(0, 0, 1, 15deg);

    transform: rotate3d(0, 0, 1, 15deg);

  }



  40% {

    -webkit-transform: rotate3d(0, 0, 1, -10deg);

    transform: rotate3d(0, 0, 1, -10deg);

  }



  60% {

    -webkit-transform: rotate3d(0, 0, 1, 5deg);

    transform: rotate3d(0, 0, 1, 5deg);

  }



  80% {

    -webkit-transform: rotate3d(0, 0, 1, -5deg);

    transform: rotate3d(0, 0, 1, -5deg);

  }



  100% {

    -webkit-transform: rotate3d(0, 0, 1, 0deg);

    transform: rotate3d(0, 0, 1, 0deg);

  }

}



@keyframes swing {

  20% {

    -webkit-transform: rotate3d(0, 0, 1, 15deg);

    transform: rotate3d(0, 0, 1, 15deg);

  }



  40% {

    -webkit-transform: rotate3d(0, 0, 1, -10deg);

    transform: rotate3d(0, 0, 1, -10deg);

  }



  60% {

    -webkit-transform: rotate3d(0, 0, 1, 5deg);

    transform: rotate3d(0, 0, 1, 5deg);

  }



  80% {

    -webkit-transform: rotate3d(0, 0, 1, -5deg);

    transform: rotate3d(0, 0, 1, -5deg);

  }



  100% {

    -webkit-transform: rotate3d(0, 0, 1, 0deg);

    transform: rotate3d(0, 0, 1, 0deg);

  }

}



.swing {

  -webkit-transform-origin: top center;

  transform-origin: top center;

  -webkit-animation-name: swing;

  animation-name: swing;

}



@-webkit-keyframes tada {

  0% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }



  10%, 20% {

    -webkit-transform: scale3d(.9, .9, .9) rotate3d(0, 0, 1, -3deg);

    transform: scale3d(.9, .9, .9) rotate3d(0, 0, 1, -3deg);

  }



  30%, 50%, 70%, 90% {

    -webkit-transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, 3deg);

    transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, 3deg);

  }



  40%, 60%, 80% {

    -webkit-transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, -3deg);

    transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, -3deg);

  }



  100% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }

}



@keyframes tada {

  0% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }



  10%, 20% {

    -webkit-transform: scale3d(.9, .9, .9) rotate3d(0, 0, 1, -3deg);

    transform: scale3d(.9, .9, .9) rotate3d(0, 0, 1, -3deg);

  }



  30%, 50%, 70%, 90% {

    -webkit-transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, 3deg);

    transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, 3deg);

  }



  40%, 60%, 80% {

    -webkit-transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, -3deg);

    transform: scale3d(1.1, 1.1, 1.1) rotate3d(0, 0, 1, -3deg);

  }



  100% {

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }

}



.tada {

  -webkit-animation-name: tada;

  animation-name: tada;

}



/* originally authored by Nick Pettit - https://github.com/nickpettit/glide */



@-webkit-keyframes wobble {

  0% {

    -webkit-transform: none;

    transform: none;

  }



  15% {

    -webkit-transform: translate3d(-25%, 0, 0) rotate3d(0, 0, 1, -5deg);

    transform: translate3d(-25%, 0, 0) rotate3d(0, 0, 1, -5deg);

  }



  30% {

    -webkit-transform: translate3d(20%, 0, 0) rotate3d(0, 0, 1, 3deg);

    transform: translate3d(20%, 0, 0) rotate3d(0, 0, 1, 3deg);

  }



  45% {

    -webkit-transform: translate3d(-15%, 0, 0) rotate3d(0, 0, 1, -3deg);

    transform: translate3d(-15%, 0, 0) rotate3d(0, 0, 1, -3deg);

  }



  60% {

    -webkit-transform: translate3d(10%, 0, 0) rotate3d(0, 0, 1, 2deg);

    transform: translate3d(10%, 0, 0) rotate3d(0, 0, 1, 2deg);

  }



  75% {

    -webkit-transform: translate3d(-5%, 0, 0) rotate3d(0, 0, 1, -1deg);

    transform: translate3d(-5%, 0, 0) rotate3d(0, 0, 1, -1deg);

  }



  100% {

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes wobble {

  0% {

    -webkit-transform: none;

    transform: none;

  }



  15% {

    -webkit-transform: translate3d(-25%, 0, 0) rotate3d(0, 0, 1, -5deg);

    transform: translate3d(-25%, 0, 0) rotate3d(0, 0, 1, -5deg);

  }



  30% {

    -webkit-transform: translate3d(20%, 0, 0) rotate3d(0, 0, 1, 3deg);

    transform: translate3d(20%, 0, 0) rotate3d(0, 0, 1, 3deg);

  }



  45% {

    -webkit-transform: translate3d(-15%, 0, 0) rotate3d(0, 0, 1, -3deg);

    transform: translate3d(-15%, 0, 0) rotate3d(0, 0, 1, -3deg);

  }



  60% {

    -webkit-transform: translate3d(10%, 0, 0) rotate3d(0, 0, 1, 2deg);

    transform: translate3d(10%, 0, 0) rotate3d(0, 0, 1, 2deg);

  }



  75% {

    -webkit-transform: translate3d(-5%, 0, 0) rotate3d(0, 0, 1, -1deg);

    transform: translate3d(-5%, 0, 0) rotate3d(0, 0, 1, -1deg);

  }



  100% {

    -webkit-transform: none;

    transform: none;

  }

}



.wobble {

  -webkit-animation-name: wobble;

  animation-name: wobble;

}



@-webkit-keyframes bounceIn {

  0%, 20%, 40%, 60%, 80%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

  }



  0% {

    opacity: 0;

    -webkit-transform: scale3d(.3, .3, .3);

    transform: scale3d(.3, .3, .3);

  }



  20% {

    -webkit-transform: scale3d(1.1, 1.1, 1.1);

    transform: scale3d(1.1, 1.1, 1.1);

  }



  40% {

    -webkit-transform: scale3d(.9, .9, .9);

    transform: scale3d(.9, .9, .9);

  }



  60% {

    opacity: 1;

    -webkit-transform: scale3d(1.03, 1.03, 1.03);

    transform: scale3d(1.03, 1.03, 1.03);

  }



  80% {

    -webkit-transform: scale3d(.97, .97, .97);

    transform: scale3d(.97, .97, .97);

  }



  100% {

    opacity: 1;

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }

}



@keyframes bounceIn {

  0%, 20%, 40%, 60%, 80%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

  }



  0% {

    opacity: 0;

    -webkit-transform: scale3d(.3, .3, .3);

    transform: scale3d(.3, .3, .3);

  }



  20% {

    -webkit-transform: scale3d(1.1, 1.1, 1.1);

    transform: scale3d(1.1, 1.1, 1.1);

  }



  40% {

    -webkit-transform: scale3d(.9, .9, .9);

    transform: scale3d(.9, .9, .9);

  }



  60% {

    opacity: 1;

    -webkit-transform: scale3d(1.03, 1.03, 1.03);

    transform: scale3d(1.03, 1.03, 1.03);

  }



  80% {

    -webkit-transform: scale3d(.97, .97, .97);

    transform: scale3d(.97, .97, .97);

  }



  100% {

    opacity: 1;

    -webkit-transform: scale3d(1, 1, 1);

    transform: scale3d(1, 1, 1);

  }

}



.bounceIn {

  -webkit-animation-name: bounceIn;

  animation-name: bounceIn;

}



@-webkit-keyframes bounceInDown {

  0%, 60%, 75%, 90%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

  }



  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, -3000px, 0);

    transform: translate3d(0, -3000px, 0);

  }



  60% {

    opacity: 1;

    -webkit-transform: translate3d(0, 25px, 0);

    transform: translate3d(0, 25px, 0);

  }



  75% {

    -webkit-transform: translate3d(0, -10px, 0);

    transform: translate3d(0, -10px, 0);

  }



  90% {

    -webkit-transform: translate3d(0, 5px, 0);

    transform: translate3d(0, 5px, 0);

  }



  100% {

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes bounceInDown {

  0%, 60%, 75%, 90%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

  }



  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, -3000px, 0);

    transform: translate3d(0, -3000px, 0);

  }



  60% {

    opacity: 1;

    -webkit-transform: translate3d(0, 25px, 0);

    transform: translate3d(0, 25px, 0);

  }



  75% {

    -webkit-transform: translate3d(0, -10px, 0);

    transform: translate3d(0, -10px, 0);

  }



  90% {

    -webkit-transform: translate3d(0, 5px, 0);

    transform: translate3d(0, 5px, 0);

  }



  100% {

    -webkit-transform: none;

    transform: none;

  }

}



.bounceInDown {

  -webkit-animation-name: bounceInDown;

  animation-name: bounceInDown;

}



@-webkit-keyframes bounceInLeft {

  0%, 60%, 75%, 90%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

  }



  0% {

    opacity: 0;

    -webkit-transform: translate3d(-3000px, 0, 0);

    transform: translate3d(-3000px, 0, 0);

  }



  60% {

    opacity: 1;

    -webkit-transform: translate3d(25px, 0, 0);

    transform: translate3d(25px, 0, 0);

  }



  75% {

    -webkit-transform: translate3d(-10px, 0, 0);

    transform: translate3d(-10px, 0, 0);

  }



  90% {

    -webkit-transform: translate3d(5px, 0, 0);

    transform: translate3d(5px, 0, 0);

  }



  100% {

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes bounceInLeft {

  0%, 60%, 75%, 90%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

  }



  0% {

    opacity: 0;

    -webkit-transform: translate3d(-3000px, 0, 0);

    transform: translate3d(-3000px, 0, 0);

  }



  60% {

    opacity: 1;

    -webkit-transform: translate3d(25px, 0, 0);

    transform: translate3d(25px, 0, 0);

  }



  75% {

    -webkit-transform: translate3d(-10px, 0, 0);

    transform: translate3d(-10px, 0, 0);

  }



  90% {

    -webkit-transform: translate3d(5px, 0, 0);

    transform: translate3d(5px, 0, 0);

  }



  100% {

    -webkit-transform: none;

    transform: none;

  }

}



.bounceInLeft {

  -webkit-animation-name: bounceInLeft;

  animation-name: bounceInLeft;

}



@-webkit-keyframes bounceInRight {

  0%, 60%, 75%, 90%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

  }



  0% {

    opacity: 0;

    -webkit-transform: translate3d(3000px, 0, 0);

    transform: translate3d(3000px, 0, 0);

  }



  60% {

    opacity: 1;

    -webkit-transform: translate3d(-25px, 0, 0);

    transform: translate3d(-25px, 0, 0);

  }



  75% {

    -webkit-transform: translate3d(10px, 0, 0);

    transform: translate3d(10px, 0, 0);

  }



  90% {

    -webkit-transform: translate3d(-5px, 0, 0);

    transform: translate3d(-5px, 0, 0);

  }



  100% {

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes bounceInRight {

  0%, 60%, 75%, 90%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

  }



  0% {

    opacity: 0;

    -webkit-transform: translate3d(3000px, 0, 0);

    transform: translate3d(3000px, 0, 0);

  }



  60% {

    opacity: 1;

    -webkit-transform: translate3d(-25px, 0, 0);

    transform: translate3d(-25px, 0, 0);

  }



  75% {

    -webkit-transform: translate3d(10px, 0, 0);

    transform: translate3d(10px, 0, 0);

  }



  90% {

    -webkit-transform: translate3d(-5px, 0, 0);

    transform: translate3d(-5px, 0, 0);

  }



  100% {

    -webkit-transform: none;

    transform: none;

  }

}



.bounceInRight {

  -webkit-animation-name: bounceInRight;

  animation-name: bounceInRight;

}



@-webkit-keyframes bounceInUp {

  0%, 60%, 75%, 90%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

  }



  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, 3000px, 0);

    transform: translate3d(0, 3000px, 0);

  }



  60% {

    opacity: 1;

    -webkit-transform: translate3d(0, -20px, 0);

    transform: translate3d(0, -20px, 0);

  }



  75% {

    -webkit-transform: translate3d(0, 10px, 0);

    transform: translate3d(0, 10px, 0);

  }



  90% {

    -webkit-transform: translate3d(0, -5px, 0);

    transform: translate3d(0, -5px, 0);

  }



  100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }

}



@keyframes bounceInUp {

  0%, 60%, 75%, 90%, 100% {

    -webkit-transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

    transition-timing-function: cubic-bezier(0.215, 0.610, 0.355, 1.000);

  }



  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, 3000px, 0);

    transform: translate3d(0, 3000px, 0);

  }



  60% {

    opacity: 1;

    -webkit-transform: translate3d(0, -20px, 0);

    transform: translate3d(0, -20px, 0);

  }



  75% {

    -webkit-transform: translate3d(0, 10px, 0);

    transform: translate3d(0, 10px, 0);

  }



  90% {

    -webkit-transform: translate3d(0, -5px, 0);

    transform: translate3d(0, -5px, 0);

  }



  100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }

}



.bounceInUp {

  -webkit-animation-name: bounceInUp;

  animation-name: bounceInUp;

}



@-webkit-keyframes bounceOut {

  20% {

    -webkit-transform: scale3d(.9, .9, .9);

    transform: scale3d(.9, .9, .9);

  }



  50%, 55% {

    opacity: 1;

    -webkit-transform: scale3d(1.1, 1.1, 1.1);

    transform: scale3d(1.1, 1.1, 1.1);

  }



  100% {

    opacity: 0;

    -webkit-transform: scale3d(.3, .3, .3);

    transform: scale3d(.3, .3, .3);

  }

}



@keyframes bounceOut {

  20% {

    -webkit-transform: scale3d(.9, .9, .9);

    transform: scale3d(.9, .9, .9);

  }



  50%, 55% {

    opacity: 1;

    -webkit-transform: scale3d(1.1, 1.1, 1.1);

    transform: scale3d(1.1, 1.1, 1.1);

  }



  100% {

    opacity: 0;

    -webkit-transform: scale3d(.3, .3, .3);

    transform: scale3d(.3, .3, .3);

  }

}



.bounceOut {

  -webkit-animation-name: bounceOut;

  animation-name: bounceOut;

}



@-webkit-keyframes bounceOutDown {

  20% {

    -webkit-transform: translate3d(0, 10px, 0);

    transform: translate3d(0, 10px, 0);

  }



  40%, 45% {

    opacity: 1;

    -webkit-transform: translate3d(0, -20px, 0);

    transform: translate3d(0, -20px, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, 2000px, 0);

    transform: translate3d(0, 2000px, 0);

  }

}



@keyframes bounceOutDown {

  20% {

    -webkit-transform: translate3d(0, 10px, 0);

    transform: translate3d(0, 10px, 0);

  }



  40%, 45% {

    opacity: 1;

    -webkit-transform: translate3d(0, -20px, 0);

    transform: translate3d(0, -20px, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, 2000px, 0);

    transform: translate3d(0, 2000px, 0);

  }

}



.bounceOutDown {

  -webkit-animation-name: bounceOutDown;

  animation-name: bounceOutDown;

}



@-webkit-keyframes bounceOutLeft {

  20% {

    opacity: 1;

    -webkit-transform: translate3d(20px, 0, 0);

    transform: translate3d(20px, 0, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(-2000px, 0, 0);

    transform: translate3d(-2000px, 0, 0);

  }

}



@keyframes bounceOutLeft {

  20% {

    opacity: 1;

    -webkit-transform: translate3d(20px, 0, 0);

    transform: translate3d(20px, 0, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(-2000px, 0, 0);

    transform: translate3d(-2000px, 0, 0);

  }

}



.bounceOutLeft {

  -webkit-animation-name: bounceOutLeft;

  animation-name: bounceOutLeft;

}



@-webkit-keyframes bounceOutRight {

  20% {

    opacity: 1;

    -webkit-transform: translate3d(-20px, 0, 0);

    transform: translate3d(-20px, 0, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(2000px, 0, 0);

    transform: translate3d(2000px, 0, 0);

  }

}



@keyframes bounceOutRight {

  20% {

    opacity: 1;

    -webkit-transform: translate3d(-20px, 0, 0);

    transform: translate3d(-20px, 0, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(2000px, 0, 0);

    transform: translate3d(2000px, 0, 0);

  }

}



.bounceOutRight {

  -webkit-animation-name: bounceOutRight;

  animation-name: bounceOutRight;

}



@-webkit-keyframes bounceOutUp {

  20% {

    -webkit-transform: translate3d(0, -10px, 0);

    transform: translate3d(0, -10px, 0);

  }



  40%, 45% {

    opacity: 1;

    -webkit-transform: translate3d(0, 20px, 0);

    transform: translate3d(0, 20px, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, -2000px, 0);

    transform: translate3d(0, -2000px, 0);

  }

}



@keyframes bounceOutUp {

  20% {

    -webkit-transform: translate3d(0, -10px, 0);

    transform: translate3d(0, -10px, 0);

  }



  40%, 45% {

    opacity: 1;

    -webkit-transform: translate3d(0, 20px, 0);

    transform: translate3d(0, 20px, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, -2000px, 0);

    transform: translate3d(0, -2000px, 0);

  }

}



.bounceOutUp {

  -webkit-animation-name: bounceOutUp;

  animation-name: bounceOutUp;

}



@-webkit-keyframes fadeIn {

  0% {

    opacity: 0;

  }



  100% {

    opacity: 1;

  }

}



@keyframes fadeIn {

  0% {

    opacity: 0;

  }



  100% {

    opacity: 1;

  }

}



.fadeIn {

  -webkit-animation-name: fadeIn;

  animation-name: fadeIn;

}



@-webkit-keyframes fadeInDown {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, -100%, 0);

    transform: translate3d(0, -100%, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes fadeInDown {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, -100%, 0);

    transform: translate3d(0, -100%, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



.fadeInDown {

  -webkit-animation-name: fadeInDown;

  animation-name: fadeInDown;

}



@-webkit-keyframes fadeInDownBig {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, -2000px, 0);

    transform: translate3d(0, -2000px, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes fadeInDownBig {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, -2000px, 0);

    transform: translate3d(0, -2000px, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



.fadeInDownBig {

  -webkit-animation-name: fadeInDownBig;

  animation-name: fadeInDownBig;

}



@-webkit-keyframes fadeInLeft {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(-100%, 0, 0);

    transform: translate3d(-100%, 0, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes fadeInLeft {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(-100%, 0, 0);

    transform: translate3d(-100%, 0, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



.fadeInLeft {

  -webkit-animation-name: fadeInLeft;

  animation-name: fadeInLeft;

}



@-webkit-keyframes fadeInLeftBig {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(-2000px, 0, 0);

    transform: translate3d(-2000px, 0, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes fadeInLeftBig {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(-2000px, 0, 0);

    transform: translate3d(-2000px, 0, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



.fadeInLeftBig {

  -webkit-animation-name: fadeInLeftBig;

  animation-name: fadeInLeftBig;

}



@-webkit-keyframes fadeInRight {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(100%, 0, 0);

    transform: translate3d(100%, 0, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes fadeInRight {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(100%, 0, 0);

    transform: translate3d(100%, 0, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



.fadeInRight {

  -webkit-animation-name: fadeInRight;

  animation-name: fadeInRight;

}



@-webkit-keyframes fadeInRightBig {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(2000px, 0, 0);

    transform: translate3d(2000px, 0, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes fadeInRightBig {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(2000px, 0, 0);

    transform: translate3d(2000px, 0, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



.fadeInRightBig {

  -webkit-animation-name: fadeInRightBig;

  animation-name: fadeInRightBig;

}



@-webkit-keyframes fadeInUp {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, 100%, 0);

    transform: translate3d(0, 100%, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes fadeInUp {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, 100%, 0);

    transform: translate3d(0, 100%, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



.fadeInUp {

  -webkit-animation-name: fadeInUp;

  animation-name: fadeInUp;

}



@-webkit-keyframes fadeInUpBig {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, 2000px, 0);

    transform: translate3d(0, 2000px, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes fadeInUpBig {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(0, 2000px, 0);

    transform: translate3d(0, 2000px, 0);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



.fadeInUpBig {

  -webkit-animation-name: fadeInUpBig;

  animation-name: fadeInUpBig;

}



@-webkit-keyframes fadeOut {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

  }

}



@keyframes fadeOut {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

  }

}



.fadeOut {

  -webkit-animation-name: fadeOut;

  animation-name: fadeOut;

}



@-webkit-keyframes fadeOutDown {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, 100%, 0);

    transform: translate3d(0, 100%, 0);

  }

}



@keyframes fadeOutDown {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, 100%, 0);

    transform: translate3d(0, 100%, 0);

  }

}



.fadeOutDown {

  -webkit-animation-name: fadeOutDown;

  animation-name: fadeOutDown;

}



@-webkit-keyframes fadeOutDownBig {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, 2000px, 0);

    transform: translate3d(0, 2000px, 0);

  }

}



@keyframes fadeOutDownBig {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, 2000px, 0);

    transform: translate3d(0, 2000px, 0);

  }

}



.fadeOutDownBig {

  -webkit-animation-name: fadeOutDownBig;

  animation-name: fadeOutDownBig;

}



@-webkit-keyframes fadeOutLeft {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(-100%, 0, 0);

    transform: translate3d(-100%, 0, 0);

  }

}



@keyframes fadeOutLeft {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(-100%, 0, 0);

    transform: translate3d(-100%, 0, 0);

  }

}



.fadeOutLeft {

  -webkit-animation-name: fadeOutLeft;

  animation-name: fadeOutLeft;

}



@-webkit-keyframes fadeOutLeftBig {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(-2000px, 0, 0);

    transform: translate3d(-2000px, 0, 0);

  }

}



@keyframes fadeOutLeftBig {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(-2000px, 0, 0);

    transform: translate3d(-2000px, 0, 0);

  }

}



.fadeOutLeftBig {

  -webkit-animation-name: fadeOutLeftBig;

  animation-name: fadeOutLeftBig;

}



@-webkit-keyframes fadeOutRight {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(100%, 0, 0);

    transform: translate3d(100%, 0, 0);

  }

}



@keyframes fadeOutRight {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(100%, 0, 0);

    transform: translate3d(100%, 0, 0);

  }

}



.fadeOutRight {

  -webkit-animation-name: fadeOutRight;

  animation-name: fadeOutRight;

}



@-webkit-keyframes fadeOutRightBig {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(2000px, 0, 0);

    transform: translate3d(2000px, 0, 0);

  }

}



@keyframes fadeOutRightBig {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(2000px, 0, 0);

    transform: translate3d(2000px, 0, 0);

  }

}



.fadeOutRightBig {

  -webkit-animation-name: fadeOutRightBig;

  animation-name: fadeOutRightBig;

}



@-webkit-keyframes fadeOutUp {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, -100%, 0);

    transform: translate3d(0, -100%, 0);

  }

}



@keyframes fadeOutUp {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, -100%, 0);

    transform: translate3d(0, -100%, 0);

  }

}



.fadeOutUp {

  -webkit-animation-name: fadeOutUp;

  animation-name: fadeOutUp;

}



@-webkit-keyframes fadeOutUpBig {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, -2000px, 0);

    transform: translate3d(0, -2000px, 0);

  }

}



@keyframes fadeOutUpBig {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(0, -2000px, 0);

    transform: translate3d(0, -2000px, 0);

  }

}



.fadeOutUpBig {

  -webkit-animation-name: fadeOutUpBig;

  animation-name: fadeOutUpBig;

}



@-webkit-keyframes flip {

  0% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, -360deg);

    transform: perspective(400px) rotate3d(0, 1, 0, -360deg);

    -webkit-animation-timing-function: ease-out;

    animation-timing-function: ease-out;

  }



  40% {

    -webkit-transform: perspective(400px) translate3d(0, 0, 150px) rotate3d(0, 1, 0, -190deg);

    transform: perspective(400px) translate3d(0, 0, 150px) rotate3d(0, 1, 0, -190deg);

    -webkit-animation-timing-function: ease-out;

    animation-timing-function: ease-out;

  }



  50% {

    -webkit-transform: perspective(400px) translate3d(0, 0, 150px) rotate3d(0, 1, 0, -170deg);

    transform: perspective(400px) translate3d(0, 0, 150px) rotate3d(0, 1, 0, -170deg);

    -webkit-animation-timing-function: ease-in;

    animation-timing-function: ease-in;

  }



  80% {

    -webkit-transform: perspective(400px) scale3d(.95, .95, .95);

    transform: perspective(400px) scale3d(.95, .95, .95);

    -webkit-animation-timing-function: ease-in;

    animation-timing-function: ease-in;

  }



  100% {

    -webkit-transform: perspective(400px);

    transform: perspective(400px);

    -webkit-animation-timing-function: ease-in;

    animation-timing-function: ease-in;

  }

}



@keyframes flip {

  0% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, -360deg);

    transform: perspective(400px) rotate3d(0, 1, 0, -360deg);

    -webkit-animation-timing-function: ease-out;

    animation-timing-function: ease-out;

  }



  40% {

    -webkit-transform: perspective(400px) translate3d(0, 0, 150px) rotate3d(0, 1, 0, -190deg);

    transform: perspective(400px) translate3d(0, 0, 150px) rotate3d(0, 1, 0, -190deg);

    -webkit-animation-timing-function: ease-out;

    animation-timing-function: ease-out;

  }



  50% {

    -webkit-transform: perspective(400px) translate3d(0, 0, 150px) rotate3d(0, 1, 0, -170deg);

    transform: perspective(400px) translate3d(0, 0, 150px) rotate3d(0, 1, 0, -170deg);

    -webkit-animation-timing-function: ease-in;

    animation-timing-function: ease-in;

  }



  80% {

    -webkit-transform: perspective(400px) scale3d(.95, .95, .95);

    transform: perspective(400px) scale3d(.95, .95, .95);

    -webkit-animation-timing-function: ease-in;

    animation-timing-function: ease-in;

  }



  100% {

    -webkit-transform: perspective(400px);

    transform: perspective(400px);

    -webkit-animation-timing-function: ease-in;

    animation-timing-function: ease-in;

  }

}



.animated.flip {

  -webkit-backface-visibility: visible;

  backface-visibility: visible;

  -webkit-animation-name: flip;

  animation-name: flip;

}



@-webkit-keyframes flipInX {

  0% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, 90deg);

    transform: perspective(400px) rotate3d(1, 0, 0, 90deg);

    -webkit-transition-timing-function: ease-in;

    transition-timing-function: ease-in;

    opacity: 0;

  }



  40% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, -20deg);

    transform: perspective(400px) rotate3d(1, 0, 0, -20deg);

    -webkit-transition-timing-function: ease-in;

    transition-timing-function: ease-in;

  }



  60% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, 10deg);

    transform: perspective(400px) rotate3d(1, 0, 0, 10deg);

    opacity: 1;

  }



  80% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, -5deg);

    transform: perspective(400px) rotate3d(1, 0, 0, -5deg);

  }



  100% {

    -webkit-transform: perspective(400px);

    transform: perspective(400px);

  }

}



@keyframes flipInX {

  0% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, 90deg);

    transform: perspective(400px) rotate3d(1, 0, 0, 90deg);

    -webkit-transition-timing-function: ease-in;

    transition-timing-function: ease-in;

    opacity: 0;

  }



  40% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, -20deg);

    transform: perspective(400px) rotate3d(1, 0, 0, -20deg);

    -webkit-transition-timing-function: ease-in;

    transition-timing-function: ease-in;

  }



  60% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, 10deg);

    transform: perspective(400px) rotate3d(1, 0, 0, 10deg);

    opacity: 1;

  }



  80% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, -5deg);

    transform: perspective(400px) rotate3d(1, 0, 0, -5deg);

  }



  100% {

    -webkit-transform: perspective(400px);

    transform: perspective(400px);

  }

}



.flipInX {

  -webkit-backface-visibility: visible !important;

  backface-visibility: visible !important;

  -webkit-animation-name: flipInX;

  animation-name: flipInX;

}



@-webkit-keyframes flipInY {

  0% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, 90deg);

    transform: perspective(400px) rotate3d(0, 1, 0, 90deg);

    -webkit-transition-timing-function: ease-in;

    transition-timing-function: ease-in;

    opacity: 0;

  }



  40% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, -20deg);

    transform: perspective(400px) rotate3d(0, 1, 0, -20deg);

    -webkit-transition-timing-function: ease-in;

    transition-timing-function: ease-in;

  }



  60% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, 10deg);

    transform: perspective(400px) rotate3d(0, 1, 0, 10deg);

    opacity: 1;

  }



  80% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, -5deg);

    transform: perspective(400px) rotate3d(0, 1, 0, -5deg);

  }



  100% {

    -webkit-transform: perspective(400px);

    transform: perspective(400px);

  }

}



@keyframes flipInY {

  0% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, 90deg);

    transform: perspective(400px) rotate3d(0, 1, 0, 90deg);

    -webkit-transition-timing-function: ease-in;

    transition-timing-function: ease-in;

    opacity: 0;

  }



  40% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, -20deg);

    transform: perspective(400px) rotate3d(0, 1, 0, -20deg);

    -webkit-transition-timing-function: ease-in;

    transition-timing-function: ease-in;

  }



  60% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, 10deg);

    transform: perspective(400px) rotate3d(0, 1, 0, 10deg);

    opacity: 1;

  }



  80% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, -5deg);

    transform: perspective(400px) rotate3d(0, 1, 0, -5deg);

  }



  100% {

    -webkit-transform: perspective(400px);

    transform: perspective(400px);

  }

}



.flipInY {

  -webkit-backface-visibility: visible !important;

  backface-visibility: visible !important;

  -webkit-animation-name: flipInY;

  animation-name: flipInY;

}



@-webkit-keyframes flipOutX {

  0% {

    -webkit-transform: perspective(400px);

    transform: perspective(400px);

  }



  30% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, -20deg);

    transform: perspective(400px) rotate3d(1, 0, 0, -20deg);

    opacity: 1;

  }



  100% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, 90deg);

    transform: perspective(400px) rotate3d(1, 0, 0, 90deg);

    opacity: 0;

  }

}



@keyframes flipOutX {

  0% {

    -webkit-transform: perspective(400px);

    transform: perspective(400px);

  }



  30% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, -20deg);

    transform: perspective(400px) rotate3d(1, 0, 0, -20deg);

    opacity: 1;

  }



  100% {

    -webkit-transform: perspective(400px) rotate3d(1, 0, 0, 90deg);

    transform: perspective(400px) rotate3d(1, 0, 0, 90deg);

    opacity: 0;

  }

}



.flipOutX {

  -webkit-animation-name: flipOutX;

  animation-name: flipOutX;

  -webkit-backface-visibility: visible !important;

  backface-visibility: visible !important;

}



@-webkit-keyframes flipOutY {

  0% {

    -webkit-transform: perspective(400px);

    transform: perspective(400px);

  }



  30% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, -15deg);

    transform: perspective(400px) rotate3d(0, 1, 0, -15deg);

    opacity: 1;

  }



  100% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, 90deg);

    transform: perspective(400px) rotate3d(0, 1, 0, 90deg);

    opacity: 0;

  }

}



@keyframes flipOutY {

  0% {

    -webkit-transform: perspective(400px);

    transform: perspective(400px);

  }



  30% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, -15deg);

    transform: perspective(400px) rotate3d(0, 1, 0, -15deg);

    opacity: 1;

  }



  100% {

    -webkit-transform: perspective(400px) rotate3d(0, 1, 0, 90deg);

    transform: perspective(400px) rotate3d(0, 1, 0, 90deg);

    opacity: 0;

  }

}



.flipOutY {

  -webkit-backface-visibility: visible !important;

  backface-visibility: visible !important;

  -webkit-animation-name: flipOutY;

  animation-name: flipOutY;

}



@-webkit-keyframes lightSpeedIn {

  0% {

    -webkit-transform: translate3d(100%, 0, 0) skewX(-30deg);

    transform: translate3d(100%, 0, 0) skewX(-30deg);

    opacity: 0;

  }



  60% {

    -webkit-transform: skewX(20deg);

    transform: skewX(20deg);

    opacity: 1;

  }



  80% {

    -webkit-transform: skewX(-5deg);

    transform: skewX(-5deg);

    opacity: 1;

  }



  100% {

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



@keyframes lightSpeedIn {

  0% {

    -webkit-transform: translate3d(100%, 0, 0) skewX(-30deg);

    transform: translate3d(100%, 0, 0) skewX(-30deg);

    opacity: 0;

  }



  60% {

    -webkit-transform: skewX(20deg);

    transform: skewX(20deg);

    opacity: 1;

  }



  80% {

    -webkit-transform: skewX(-5deg);

    transform: skewX(-5deg);

    opacity: 1;

  }



  100% {

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



.lightSpeedIn {

  -webkit-animation-name: lightSpeedIn;

  animation-name: lightSpeedIn;

  -webkit-animation-timing-function: ease-out;

  animation-timing-function: ease-out;

}



@-webkit-keyframes lightSpeedOut {

  0% {

    opacity: 1;

  }



  100% {

    -webkit-transform: translate3d(100%, 0, 0) skewX(30deg);

    transform: translate3d(100%, 0, 0) skewX(30deg);

    opacity: 0;

  }

}



@keyframes lightSpeedOut {

  0% {

    opacity: 1;

  }



  100% {

    -webkit-transform: translate3d(100%, 0, 0) skewX(30deg);

    transform: translate3d(100%, 0, 0) skewX(30deg);

    opacity: 0;

  }

}



.lightSpeedOut {

  -webkit-animation-name: lightSpeedOut;

  animation-name: lightSpeedOut;

  -webkit-animation-timing-function: ease-in;

  animation-timing-function: ease-in;

}



@-webkit-keyframes rotateIn {

  0% {

    -webkit-transform-origin: center;

    transform-origin: center;

    -webkit-transform: rotate3d(0, 0, 1, -200deg);

    transform: rotate3d(0, 0, 1, -200deg);

    opacity: 0;

  }



  100% {

    -webkit-transform-origin: center;

    transform-origin: center;

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



@keyframes rotateIn {

  0% {

    -webkit-transform-origin: center;

    transform-origin: center;

    -webkit-transform: rotate3d(0, 0, 1, -200deg);

    transform: rotate3d(0, 0, 1, -200deg);

    opacity: 0;

  }



  100% {

    -webkit-transform-origin: center;

    transform-origin: center;

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



.rotateIn {

  -webkit-animation-name: rotateIn;

  animation-name: rotateIn;

}



@-webkit-keyframes rotateInDownLeft {

  0% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: rotate3d(0, 0, 1, -45deg);

    transform: rotate3d(0, 0, 1, -45deg);

    opacity: 0;

  }



  100% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



@keyframes rotateInDownLeft {

  0% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: rotate3d(0, 0, 1, -45deg);

    transform: rotate3d(0, 0, 1, -45deg);

    opacity: 0;

  }



  100% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



.rotateInDownLeft {

  -webkit-animation-name: rotateInDownLeft;

  animation-name: rotateInDownLeft;

}



@-webkit-keyframes rotateInDownRight {

  0% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: rotate3d(0, 0, 1, 45deg);

    transform: rotate3d(0, 0, 1, 45deg);

    opacity: 0;

  }



  100% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



@keyframes rotateInDownRight {

  0% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: rotate3d(0, 0, 1, 45deg);

    transform: rotate3d(0, 0, 1, 45deg);

    opacity: 0;

  }



  100% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



.rotateInDownRight {

  -webkit-animation-name: rotateInDownRight;

  animation-name: rotateInDownRight;

}



@-webkit-keyframes rotateInUpLeft {

  0% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: rotate3d(0, 0, 1, 45deg);

    transform: rotate3d(0, 0, 1, 45deg);

    opacity: 0;

  }



  100% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



@keyframes rotateInUpLeft {

  0% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: rotate3d(0, 0, 1, 45deg);

    transform: rotate3d(0, 0, 1, 45deg);

    opacity: 0;

  }



  100% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



.rotateInUpLeft {

  -webkit-animation-name: rotateInUpLeft;

  animation-name: rotateInUpLeft;

}



@-webkit-keyframes rotateInUpRight {

  0% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: rotate3d(0, 0, 1, -90deg);

    transform: rotate3d(0, 0, 1, -90deg);

    opacity: 0;

  }



  100% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



@keyframes rotateInUpRight {

  0% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: rotate3d(0, 0, 1, -90deg);

    transform: rotate3d(0, 0, 1, -90deg);

    opacity: 0;

  }



  100% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: none;

    transform: none;

    opacity: 1;

  }

}



.rotateInUpRight {

  -webkit-animation-name: rotateInUpRight;

  animation-name: rotateInUpRight;

}



@-webkit-keyframes rotateOut {

  0% {

    -webkit-transform-origin: center;

    transform-origin: center;

    opacity: 1;

  }



  100% {

    -webkit-transform-origin: center;

    transform-origin: center;

    -webkit-transform: rotate3d(0, 0, 1, 200deg);

    transform: rotate3d(0, 0, 1, 200deg);

    opacity: 0;

  }

}



@keyframes rotateOut {

  0% {

    -webkit-transform-origin: center;

    transform-origin: center;

    opacity: 1;

  }



  100% {

    -webkit-transform-origin: center;

    transform-origin: center;

    -webkit-transform: rotate3d(0, 0, 1, 200deg);

    transform: rotate3d(0, 0, 1, 200deg);

    opacity: 0;

  }

}



.rotateOut {

  -webkit-animation-name: rotateOut;

  animation-name: rotateOut;

}



@-webkit-keyframes rotateOutDownLeft {

  0% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    opacity: 1;

  }



  100% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: rotate3d(0, 0, 1, 45deg);

    transform: rotate3d(0, 0, 1, 45deg);

    opacity: 0;

  }

}



@keyframes rotateOutDownLeft {

  0% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    opacity: 1;

  }



  100% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: rotate3d(0, 0, 1, 45deg);

    transform: rotate3d(0, 0, 1, 45deg);

    opacity: 0;

  }

}



.rotateOutDownLeft {

  -webkit-animation-name: rotateOutDownLeft;

  animation-name: rotateOutDownLeft;

}



@-webkit-keyframes rotateOutDownRight {

  0% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    opacity: 1;

  }



  100% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: rotate3d(0, 0, 1, -45deg);

    transform: rotate3d(0, 0, 1, -45deg);

    opacity: 0;

  }

}



@keyframes rotateOutDownRight {

  0% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    opacity: 1;

  }



  100% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: rotate3d(0, 0, 1, -45deg);

    transform: rotate3d(0, 0, 1, -45deg);

    opacity: 0;

  }

}



.rotateOutDownRight {

  -webkit-animation-name: rotateOutDownRight;

  animation-name: rotateOutDownRight;

}



@-webkit-keyframes rotateOutUpLeft {

  0% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    opacity: 1;

  }



  100% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: rotate3d(0, 0, 1, -45deg);

    transform: rotate3d(0, 0, 1, -45deg);

    opacity: 0;

  }

}



@keyframes rotateOutUpLeft {

  0% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    opacity: 1;

  }



  100% {

    -webkit-transform-origin: left bottom;

    transform-origin: left bottom;

    -webkit-transform: rotate3d(0, 0, 1, -45deg);

    transform: rotate3d(0, 0, 1, -45deg);

    opacity: 0;

  }

}



.rotateOutUpLeft {

  -webkit-animation-name: rotateOutUpLeft;

  animation-name: rotateOutUpLeft;

}



@-webkit-keyframes rotateOutUpRight {

  0% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    opacity: 1;

  }



  100% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: rotate3d(0, 0, 1, 90deg);

    transform: rotate3d(0, 0, 1, 90deg);

    opacity: 0;

  }

}



@keyframes rotateOutUpRight {

  0% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    opacity: 1;

  }



  100% {

    -webkit-transform-origin: right bottom;

    transform-origin: right bottom;

    -webkit-transform: rotate3d(0, 0, 1, 90deg);

    transform: rotate3d(0, 0, 1, 90deg);

    opacity: 0;

  }

}



.rotateOutUpRight {

  -webkit-animation-name: rotateOutUpRight;

  animation-name: rotateOutUpRight;

}



@-webkit-keyframes hinge {

  0% {

    -webkit-transform-origin: top left;

    transform-origin: top left;

    -webkit-animation-timing-function: ease-in-out;

    animation-timing-function: ease-in-out;

  }



  20%, 60% {

    -webkit-transform: rotate3d(0, 0, 1, 80deg);

    transform: rotate3d(0, 0, 1, 80deg);

    -webkit-transform-origin: top left;

    transform-origin: top left;

    -webkit-animation-timing-function: ease-in-out;

    animation-timing-function: ease-in-out;

  }



  40%, 80% {

    -webkit-transform: rotate3d(0, 0, 1, 60deg);

    transform: rotate3d(0, 0, 1, 60deg);

    -webkit-transform-origin: top left;

    transform-origin: top left;

    -webkit-animation-timing-function: ease-in-out;

    animation-timing-function: ease-in-out;

    opacity: 1;

  }



  100% {

    -webkit-transform: translate3d(0, 700px, 0);

    transform: translate3d(0, 700px, 0);

    opacity: 0;

  }

}



@keyframes hinge {

  0% {

    -webkit-transform-origin: top left;

    transform-origin: top left;

    -webkit-animation-timing-function: ease-in-out;

    animation-timing-function: ease-in-out;

  }



  20%, 60% {

    -webkit-transform: rotate3d(0, 0, 1, 80deg);

    transform: rotate3d(0, 0, 1, 80deg);

    -webkit-transform-origin: top left;

    transform-origin: top left;

    -webkit-animation-timing-function: ease-in-out;

    animation-timing-function: ease-in-out;

  }



  40%, 80% {

    -webkit-transform: rotate3d(0, 0, 1, 60deg);

    transform: rotate3d(0, 0, 1, 60deg);

    -webkit-transform-origin: top left;

    transform-origin: top left;

    -webkit-animation-timing-function: ease-in-out;

    animation-timing-function: ease-in-out;

    opacity: 1;

  }



  100% {

    -webkit-transform: translate3d(0, 700px, 0);

    transform: translate3d(0, 700px, 0);

    opacity: 0;

  }

}



.hinge {

  -webkit-animation-name: hinge;

  animation-name: hinge;

}



/* originally authored by Nick Pettit - https://github.com/nickpettit/glide */



@-webkit-keyframes rollIn {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(-100%, 0, 0) rotate3d(0, 0, 1, -120deg);

    transform: translate3d(-100%, 0, 0) rotate3d(0, 0, 1, -120deg);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



@keyframes rollIn {

  0% {

    opacity: 0;

    -webkit-transform: translate3d(-100%, 0, 0) rotate3d(0, 0, 1, -120deg);

    transform: translate3d(-100%, 0, 0) rotate3d(0, 0, 1, -120deg);

  }



  100% {

    opacity: 1;

    -webkit-transform: none;

    transform: none;

  }

}



.rollIn {

  -webkit-animation-name: rollIn;

  animation-name: rollIn;

}



/* originally authored by Nick Pettit - https://github.com/nickpettit/glide */



@-webkit-keyframes rollOut {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(100%, 0, 0) rotate3d(0, 0, 1, 120deg);

    transform: translate3d(100%, 0, 0) rotate3d(0, 0, 1, 120deg);

  }

}



@keyframes rollOut {

  0% {

    opacity: 1;

  }



  100% {

    opacity: 0;

    -webkit-transform: translate3d(100%, 0, 0) rotate3d(0, 0, 1, 120deg);

    transform: translate3d(100%, 0, 0) rotate3d(0, 0, 1, 120deg);

  }

}



.rollOut {

  -webkit-animation-name: rollOut;

  animation-name: rollOut;

}



@-webkit-keyframes zoomIn {

  0% {

    opacity: 0;

    -webkit-transform: scale3d(.3, .3, .3);

    transform: scale3d(.3, .3, .3);

  }



  50% {

    opacity: 1;

  }

}



@keyframes zoomIn {

  0% {

    opacity: 0;

    -webkit-transform: scale3d(.3, .3, .3);

    transform: scale3d(.3, .3, .3);

  }



  50% {

    opacity: 1;

  }

}



.zoomIn {

  -webkit-animation-name: zoomIn;

  animation-name: zoomIn;

}



@-webkit-keyframes zoomInDown {

  0% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(0, -1000px, 0);

    transform: scale3d(.1, .1, .1) translate3d(0, -1000px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  60% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(0, 60px, 0);

    transform: scale3d(.475, .475, .475) translate3d(0, 60px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



@keyframes zoomInDown {

  0% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(0, -1000px, 0);

    transform: scale3d(.1, .1, .1) translate3d(0, -1000px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  60% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(0, 60px, 0);

    transform: scale3d(.475, .475, .475) translate3d(0, 60px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



.zoomInDown {

  -webkit-animation-name: zoomInDown;

  animation-name: zoomInDown;

}



@-webkit-keyframes zoomInLeft {

  0% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(-1000px, 0, 0);

    transform: scale3d(.1, .1, .1) translate3d(-1000px, 0, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  60% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(10px, 0, 0);

    transform: scale3d(.475, .475, .475) translate3d(10px, 0, 0);

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



@keyframes zoomInLeft {

  0% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(-1000px, 0, 0);

    transform: scale3d(.1, .1, .1) translate3d(-1000px, 0, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  60% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(10px, 0, 0);

    transform: scale3d(.475, .475, .475) translate3d(10px, 0, 0);

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



.zoomInLeft {

  -webkit-animation-name: zoomInLeft;

  animation-name: zoomInLeft;

}



@-webkit-keyframes zoomInRight {

  0% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(1000px, 0, 0);

    transform: scale3d(.1, .1, .1) translate3d(1000px, 0, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  60% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(-10px, 0, 0);

    transform: scale3d(.475, .475, .475) translate3d(-10px, 0, 0);

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



@keyframes zoomInRight {

  0% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(1000px, 0, 0);

    transform: scale3d(.1, .1, .1) translate3d(1000px, 0, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  60% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(-10px, 0, 0);

    transform: scale3d(.475, .475, .475) translate3d(-10px, 0, 0);

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



.zoomInRight {

  -webkit-animation-name: zoomInRight;

  animation-name: zoomInRight;

}



@-webkit-keyframes zoomInUp {

  0% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(0, 1000px, 0);

    transform: scale3d(.1, .1, .1) translate3d(0, 1000px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  60% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(0, -60px, 0);

    transform: scale3d(.475, .475, .475) translate3d(0, -60px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



@keyframes zoomInUp {

  0% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(0, 1000px, 0);

    transform: scale3d(.1, .1, .1) translate3d(0, 1000px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  60% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(0, -60px, 0);

    transform: scale3d(.475, .475, .475) translate3d(0, -60px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



.zoomInUp {

  -webkit-animation-name: zoomInUp;

  animation-name: zoomInUp;

}



@-webkit-keyframes zoomOut {

  0% {

    opacity: 1;

  }



  50% {

    opacity: 0;

    -webkit-transform: scale3d(.3, .3, .3);

    transform: scale3d(.3, .3, .3);

  }



  100% {

    opacity: 0;

  }

}



@keyframes zoomOut {

  0% {

    opacity: 1;

  }



  50% {

    opacity: 0;

    -webkit-transform: scale3d(.3, .3, .3);

    transform: scale3d(.3, .3, .3);

  }



  100% {

    opacity: 0;

  }

}



.zoomOut {

  -webkit-animation-name: zoomOut;

  animation-name: zoomOut;

}



@-webkit-keyframes zoomOutDown {

  40% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(0, -60px, 0);

    transform: scale3d(.475, .475, .475) translate3d(0, -60px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  100% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(0, 2000px, 0);

    transform: scale3d(.1, .1, .1) translate3d(0, 2000px, 0);

    -webkit-transform-origin: center bottom;

    transform-origin: center bottom;

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



@keyframes zoomOutDown {

  40% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(0, -60px, 0);

    transform: scale3d(.475, .475, .475) translate3d(0, -60px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  100% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(0, 2000px, 0);

    transform: scale3d(.1, .1, .1) translate3d(0, 2000px, 0);

    -webkit-transform-origin: center bottom;

    transform-origin: center bottom;

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



.zoomOutDown {

  -webkit-animation-name: zoomOutDown;

  animation-name: zoomOutDown;

}



@-webkit-keyframes zoomOutLeft {

  40% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(42px, 0, 0);

    transform: scale3d(.475, .475, .475) translate3d(42px, 0, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: scale(.1) translate3d(-2000px, 0, 0);

    transform: scale(.1) translate3d(-2000px, 0, 0);

    -webkit-transform-origin: left center;

    transform-origin: left center;

  }

}



@keyframes zoomOutLeft {

  40% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(42px, 0, 0);

    transform: scale3d(.475, .475, .475) translate3d(42px, 0, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: scale(.1) translate3d(-2000px, 0, 0);

    transform: scale(.1) translate3d(-2000px, 0, 0);

    -webkit-transform-origin: left center;

    transform-origin: left center;

  }

}



.zoomOutLeft {

  -webkit-animation-name: zoomOutLeft;

  animation-name: zoomOutLeft;

}



@-webkit-keyframes zoomOutRight {

  40% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(-42px, 0, 0);

    transform: scale3d(.475, .475, .475) translate3d(-42px, 0, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: scale(.1) translate3d(2000px, 0, 0);

    transform: scale(.1) translate3d(2000px, 0, 0);

    -webkit-transform-origin: right center;

    transform-origin: right center;

  }

}



@keyframes zoomOutRight {

  40% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(-42px, 0, 0);

    transform: scale3d(.475, .475, .475) translate3d(-42px, 0, 0);

  }



  100% {

    opacity: 0;

    -webkit-transform: scale(.1) translate3d(2000px, 0, 0);

    transform: scale(.1) translate3d(2000px, 0, 0);

    -webkit-transform-origin: right center;

    transform-origin: right center;

  }

}



.zoomOutRight {

  -webkit-animation-name: zoomOutRight;

  animation-name: zoomOutRight;

}



@-webkit-keyframes zoomOutUp {

  40% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(0, 60px, 0);

    transform: scale3d(.475, .475, .475) translate3d(0, 60px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  100% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(0, -2000px, 0);

    transform: scale3d(.1, .1, .1) translate3d(0, -2000px, 0);

    -webkit-transform-origin: center bottom;

    transform-origin: center bottom;

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



@keyframes zoomOutUp {

  40% {

    opacity: 1;

    -webkit-transform: scale3d(.475, .475, .475) translate3d(0, 60px, 0);

    transform: scale3d(.475, .475, .475) translate3d(0, 60px, 0);

    -webkit-animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

    animation-timing-function: cubic-bezier(0.550, 0.055, 0.675, 0.190);

  }



  100% {

    opacity: 0;

    -webkit-transform: scale3d(.1, .1, .1) translate3d(0, -2000px, 0);

    transform: scale3d(.1, .1, .1) translate3d(0, -2000px, 0);

    -webkit-transform-origin: center bottom;

    transform-origin: center bottom;

    -webkit-animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

    animation-timing-function: cubic-bezier(0.175, 0.885, 0.320, 1);

  }

}



.zoomOutUp {

  -webkit-animation-name: zoomOutUp;

  animation-name: zoomOutUp;

}



@-webkit-keyframes slideInDown {

  0% {

    -webkit-transform: translate3d(0, -100%, 0);

    transform: translate3d(0, -100%, 0);

    visibility: visible;

  }



  100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }

}



@keyframes slideInDown {

  0% {

    -webkit-transform: translate3d(0, -100%, 0);

    transform: translate3d(0, -100%, 0);

    visibility: visible;

  }



  100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }

}



.slideInDown {

  -webkit-animation-name: slideInDown;

  animation-name: slideInDown;

}



@-webkit-keyframes slideInLeft {

  0% {

    -webkit-transform: translate3d(-100%, 0, 0);

    transform: translate3d(-100%, 0, 0);

    visibility: visible;

  }



  100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }

}



@keyframes slideInLeft {

  0% {

    -webkit-transform: translate3d(-100%, 0, 0);

    transform: translate3d(-100%, 0, 0);

    visibility: visible;

  }



  100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }

}



.slideInLeft {

  -webkit-animation-name: slideInLeft;

  animation-name: slideInLeft;

}



@-webkit-keyframes slideInRight {

  0% {

    -webkit-transform: translate3d(100%, 0, 0);

    transform: translate3d(100%, 0, 0);

    visibility: visible;

  }



  100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }

}



@keyframes slideInRight {

  0% {

    -webkit-transform: translate3d(100%, 0, 0);

    transform: translate3d(100%, 0, 0);

    visibility: visible;

  }



  100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }

}



.slideInRight {

  -webkit-animation-name: slideInRight;

  animation-name: slideInRight;

}



@-webkit-keyframes slideInUp {

  0% {

    -webkit-transform: translate3d(0, 100%, 0);

    transform: translate3d(0, 100%, 0);

    visibility: visible;

  }



  100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }

}



@keyframes slideInUp {

  0% {

    -webkit-transform: translate3d(0, 100%, 0);

    transform: translate3d(0, 100%, 0);

    visibility: visible;

  }



  100% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }

}



.slideInUp {

  -webkit-animation-name: slideInUp;

  animation-name: slideInUp;

}



@-webkit-keyframes slideOutDown {

  0% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }



  100% {

    visibility: hidden;

    -webkit-transform: translate3d(0, 100%, 0);

    transform: translate3d(0, 100%, 0);

  }

}



@keyframes slideOutDown {

  0% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }



  100% {

    visibility: hidden;

    -webkit-transform: translate3d(0, 100%, 0);

    transform: translate3d(0, 100%, 0);

  }

}



.slideOutDown {

  -webkit-animation-name: slideOutDown;

  animation-name: slideOutDown;

}



@-webkit-keyframes slideOutLeft {

  0% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }



  100% {

    visibility: hidden;

    -webkit-transform: translate3d(-100%, 0, 0);

    transform: translate3d(-100%, 0, 0);

  }

}



@keyframes slideOutLeft {

  0% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }



  100% {

    visibility: hidden;

    -webkit-transform: translate3d(-100%, 0, 0);

    transform: translate3d(-100%, 0, 0);

  }

}



.slideOutLeft {

  -webkit-animation-name: slideOutLeft;

  animation-name: slideOutLeft;

}



@-webkit-keyframes slideOutRight {

  0% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }



  100% {

    visibility: hidden;

    -webkit-transform: translate3d(100%, 0, 0);

    transform: translate3d(100%, 0, 0);

  }

}



@keyframes slideOutRight {

  0% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }



  100% {

    visibility: hidden;

    -webkit-transform: translate3d(100%, 0, 0);

    transform: translate3d(100%, 0, 0);

  }

}



.slideOutRight {

  -webkit-animation-name: slideOutRight;

  animation-name: slideOutRight;

}



@-webkit-keyframes slideOutUp {

  0% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }



  100% {

    visibility: hidden;

    -webkit-transform: translate3d(0, -100%, 0);

    transform: translate3d(0, -100%, 0);

  }

}



@keyframes slideOutUp {

  0% {

    -webkit-transform: translate3d(0, 0, 0);

    transform: translate3d(0, 0, 0);

  }



  100% {

    visibility: hidden;

    -webkit-transform: translate3d(0, -100%, 0);

    transform: translate3d(0, -100%, 0);

  }

}



.slideOutUp {

  -webkit-animation-name: slideOutUp;

  animation-name: slideOutUp;

}



@-webkit-keyframes zoom-image {

    0%   {

      -webkit-transform: scale(1.22);

    }

    25%  {

      -webkit-transform: scale(1.23);

    }

    75%  {

      -webkit-transform: scale(1.24);

    }

    100% {

      -webkit-transform: scale(1.25);

    }

}



/* Standard syntax */

@keyframes zoom-image {

    0%   {

      -moz-transform: scale(1.22);

      -ms-transform: scale(1.22;

      -o-transform: scale(1.22);

      transform: scale(1.22);

    }

    25%  {

      -moz-transform: scale(1.23);

      -ms-transform: scale(1.23;

      -o-transform: scale(1.23);

      transform: scale(1.23);

    }

    75%  {

      -moz-transform: scale(1.24);

      -ms-transform: scale(1.24;

      -o-transform: scale(1.24);

      transform: scale(1.24);

    }

    100% {

      -moz-transform: scale(1.25);

      -ms-transform: scale(1.25;

      -o-transform: scale(1.25);

      transform: scale(1.25);

    }

}