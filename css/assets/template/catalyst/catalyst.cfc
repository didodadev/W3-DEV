<cfcomponent>
    <cfheader name="Content-Type" value="text/css">
    <cffunction name="theme" access="remote" returntype="string" returnFormat="plain">
<cfsavecontent variable="css">
    <cfswitch expression="#session.ep.design_color#">
        <cfcase value="1">
            .page-header.navbar {background-color: #2b3643;}
            .rightBar #tab-container ul.tabNav li a {
            background: #576d87}
            .rightBar ul.tabNav .active > a {
                background: #364150 !important;
            }
            .rightBar {
                background-color: #364150;
            } 
            ul.rightmenu-content .acordionContent{
                background: #616161;
            }      
            ul.rightmenu-content .acordionContent{
                background: #465261;
            }
            .leftBar .nav-side-menu {
                background-color: #364150;
            }
            .nav-side-menu .brand  {
                background-color: #364150;
            }
            .menu-content ul ul ul li a {
                background-color: #364150;
            }
            ul.rightmenu-content .acordionContent{
                background: #364150;
            }      
            .closeMenu li.menuItem:hover {
                background-color: #364150;
            }
            .closeMenu li.menuItem:hover > ul.sub-menu{
                background-color: #364150;
            }
            .nav-side-menu .brand ::placeholder {
                color: white;
                opacity: 1;
            }
        </cfcase>
        <cfcase value="2">
            .page-header.navbar {
                background-color: #2978B5;
            }
            .rightBar #tab-container ul.tabNav li a {
                background-color: #1670b5;
            }
            .rightBar ul.tabNav .active > a {
                background: #236294 !important;
                color: #236294;
            }
            .rightBar {
                background-color: #236294;
            }
            ul.rightmenu-content .acordionContent{
                background: #195585;
            }
            .leftBar .nav-side-menu {
                background-color: #236294;
            }
            .nav-side-menu .brand  {
                background-color: #236294;
            }
            .menu-content ul ul ul li a {
                background-color: #2978B5;
            }
            ul.rightmenu-content .acordionContent{
                background: #2978B5;
            }      
            .closeMenu li.menuItem:hover {
                background-color: #236294;
            }
            .closeMenu li.menuItem:hover > ul.sub-menu{
                background-color: #2978B5;
            }
            .nav-side-menu .brand ::placeholder {
                color: white;
                opacity: 1;
            }
        </cfcase>
        <cfcase value="3">
            .page-header.navbar {
                background-color: #009688;
            }
            .rightBar #tab-container ul.tabNav li a {
                background: #079185;
            }
            .rightBar ul.tabNav .active > a {
                background: #007d72 !important;
                color: #8F8F8F;
            }
            .rightBar {
                background-color: #007d72;
            }
            ul.rightmenu-content .acordionContent{
                background: #007066;
            }
            .leftBar .nav-side-menu {
                background-color: #007d72;
            }
            .nav-side-menu .brand  {
                background-color: #007d72;
            }
            .menu-content ul ul ul li a {
                background-color: #007d72;
            }
            ul.rightmenu-content .acordionContent{
                background: #007d72;
            }      
            .closeMenu li.menuItem:hover {
                background-color: #007d72;
            }
            .closeMenu li.menuItem:hover > ul.sub-menu{
                background-color: #007d72;
            }
            .nav-side-menu .brand ::placeholder {
                color: white;
                opacity: 1;
            }
        </cfcase>
        <cfcase value="4">
            .page-header.navbar {
                background-color: #af7474;
            }
            .rightBar #tab-container ul.tabNav li a {
                background: #a64141;
            }
            .rightBar ul.tabNav .active > a {
                background: #9c4e4e !important;
                color: #9c4e4e;
            }
            .rightBar {
                background-color: #9c4e4e;
            }
            ul.rightmenu-content .acordionContent{
                background: #8f4242;
            }
            .leftBar .nav-side-menu {
                background-color: #af7474;
            }
            .nav-side-menu .brand  {
                background-color: #af7474;
            }
            .menu-content ul ul ul li a {
                background-color: #af7474;
            }
            ul.rightmenu-content .acordionContent{
                background: #af7474;
            }      
            .closeMenu li.menuItem:hover {
                background-color: #af7474;
            }
            .closeMenu li.menuItem:hover > ul.sub-menu{
                background-color: #af7474;
            }
            .nav-side-menu .brand ::placeholder {
                color: white;
                opacity: 1;
            }
        </cfcase>
        <cfcase value="5">
            .page-header.navbar {
                background-color: #d08245;
            }
            .rightBar #tab-container ul.tabNav li a {
                background: #c46e29;
            }
            .rightBar ul.tabNav .active > a {
                background: #ad5d1d !important;
                color: #ad5d1d;
            }
            .rightBar {
                background-color: #ad5d1d;
            } 
            .leftBar .nav-side-menu {
                background-color: #ad5d1d;
            }
            .nav-side-menu .brand  {
                background-color: #ad5d1d;
            }
            .menu-content ul ul ul li a {
                background-color: #ad5d1d;
            }
            ul.rightmenu-content .acordionContent{
                background: #a15315;
            }      
            .closeMenu li.menuItem:hover {
                background-color: #a15315;
            }
            .closeMenu li.menuItem:hover > ul.sub-menu{
                background-color: #a15315;
            }
            .nav-side-menu .brand ::placeholder {
                color: white;
                opacity: 1;
            }
        </cfcase>
        <cfcase value="6">
            .page-header.navbar {
                background-color: #8c8989;
            }
            .rightBar #tab-container ul.tabNav li a {
                background: #787272;
            }
            .rightBar ul.tabNav .active > a {
                background: #7a7878 !important;
                color: #7a7878;
            }
            .rightBar {
                background-color: #7a7878;
            } 
            ul.rightmenu-content .acordionContent{
                background: #878282;
            }
            .leftBar .nav-side-menu {
                background-color: #7a7878;
            }
            .nav-side-menu .brand  {
                background-color: #7a7878;
            }
            .menu-content ul ul ul li a {
                background-color: #7a7878;
            }
            ul.rightmenu-content .acordionContent{
                background: #7a7878;
            }      
            .closeMenu li.menuItem:hover {
                background-color: #7a7878;
            }
            .closeMenu li.menuItem:hover > ul.sub-menu{
                background-color: #7a7878;
            }    
            .nav-side-menu .brand ::placeholder {
                color: white;
                opacity: 1;
            }  
        </cfcase>
    </cfswitch>
</cfsavecontent>
        <cfheader name="Content-Type" value="text/css">
        <cfreturn css>
    </cffunction>
</cfcomponent>