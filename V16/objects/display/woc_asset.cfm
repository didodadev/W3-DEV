<cfif attributes.fuseaction neq 'objects.popup_print_designer'><link rel="stylesheet" href="<cfoutput>#user_domain#</cfoutput>/css/assets/template/catalyst/catalyst.css" type="text/css"></cfif>

<style>
    .print_title{font-size:16px;}
    table{border-collapse:collapse;border-spacing:0;}
    table tr td img{max-width: 150px;}
    table tr td{padding:5px 3px;}
    .print_border tr th{border:1px solid #c0c0c0;padding:3px;color:#000}
    .print_border tr td{border:1px solid #c0c0c0;font-size:9px!important;}
    .bottom_border{border-bottom:1px solid #c0c0c0;}
    .top_border{border-top:1px solid #c0c0c0;}


    @media print
    {   html,body {background: white;}
        table{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
        tr{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
        td{font-size: 10px;font-family:Geneva, Verdana, tahoma, arial,  Helvetica, sans-serif;}
        <cfoutput>
            .print_page{width : #page_width##rule_unit#;height :#page_height##rule_unit#;margin:#page_margin_top##rule_unit# #page_margin_right##rule_unit# #page_margin_bottom##rule_unit# #page_margin_left##rule_unit# ;}
            .print_header{height : #page_header_height##rule_unit#;width:100%;padding:10px 0 0 0!important}
            <cfif use_logo neq 1>.print_header td:last-child{display:none;}</cfif>
            <cfif use_logo neq 1 and use_adress neq 1>.print_footer{display:none;}</cfif>
            <cfif use_adress neq 1>.print_footer{display:none;}</cfif>
            .print_footer table {height : #page_footer_height##rule_unit#}
        </cfoutput>
        <cfif attributes.fuseaction neq 'objects.popup_print_designer'>
            #footer {
                display: table-footer-group;
            }
            
            #header {
                display: table-header-group;
            }
        </cfif>
    }

    @media screen
    {
        html,body{height: 100%;width:100%;}
        table{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color: #333333;}
        tr{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}
        td{font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : #333333;}
        <cfoutput>
            <cfif attributes.fuseaction eq 'objects.popup_print_designer'>
                .print_page{width : #page_width##rule_unit#;height :#page_height##rule_unit#;border-top:#page_margin_top##rule_unit# rgba(0,142,255,0.3) solid;border-right: #page_margin_right##rule_unit# rgba(0,142,255,0.3) solid; border-bottom: #page_margin_bottom##rule_unit# rgba(0,142,255,0.3) solid; border-left:#page_margin_left##rule_unit# rgba(0,142,255,0.3) solid}
                .print_header{border-top : #page_header_height##rule_unit# rgba(73, 22, 84, 0.3) solid;padding:10px 0 0 0!important}
                ##print_footer {border-bottom : #page_footer_height##rule_unit# rgba(73, 22, 84, 0.3) solid}
            <cfelse>
                .print_page{width : #page_width##rule_unit#;height :#page_height##rule_unit#;margin:#page_margin_top##rule_unit# #page_margin_right##rule_unit# #page_margin_bottom##rule_unit# #page_margin_left##rule_unit# ;}
                .print_header{height : #page_header_height##rule_unit#;padding:10px 0 0 0!important}
                ##print_footer {height : #page_footer_height##rule_unit#}
            </cfif>
            
            <cfif use_logo neq 1>.print_header td:last-child{display:none;}</cfif>
            <cfif use_logo neq 1 and use_adress neq 1>.print_footer{display:none;}</cfif>
            <cfif use_adress neq 1>.print_footer{display:none;}</cfif>
            .print_footer table {height : #page_footer_height##rule_unit#}
        </cfoutput>
        <cfif attributes.fuseaction neq 'objects.popup_print_designer'>
       
            #footer {
                display: table-footer-group;
            }

           
        </cfif>
    }
</style>