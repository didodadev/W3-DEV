<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="basket_#round(rand()*10000000)#">
<cfparam name="attributes.height" default="">
<cfparam name="attributes.style" default="">
<cfparam name="attributes.special" default="0">
<cfset degerim_ = thisTag.GeneratedContent>
<cfset caller.last_basket_id = attributes.id>
<cfset thisTag.GeneratedContent =''>
<cfif thisTag.executionMode eq "start">
   <!--- <link type="text/css" rel="stylesheet" media="all" href="css/temp/fixed_table_rc.css" />
	<script src="http://meetselva.github.io/fixed-table-rows-cols/js/sortable_table.js" type="text/javascript"></script>
    <script src="JS/temp/fixedtable/fixed_table_rc.js" type="text/javascript"></script>--->
    <style>
        #main-content { min-height: 600px; overflow: hidden; }			
        #example_d1 { width: 95%; }
        #example_d2 { width: 95%; }
        #example_d3 { width: 95%; }
        
        #example_d3 .dwrapper { width:auto }
        
        
        .dwrapper { padding: 2px; overflow: hidden; vertical-align: top; }
        .dwrapper div.tblWrapper { height: 300px; overflow: auto; margin-top: 0px;}
        .dwrapper div.ft_container { width: 100%; margin-top: 10px; }		
        
        body { line-height: 1.5em; }
        #main-content { min-width: 990px; }
    </style>
    <script type="text/javascript">
		$(function () {
			$('#main-content').width($('#page-content').width() + 80);
			$('.example').addClass('ui-widget-content');
		});
	</script>
<cfelse>
	<cfoutput>
	    <div id="page-content">
            <div id="main-content" class="ui-widget-content">
                <div class="example" id="example_d2">
                    <div class="dwrapper">
                    	#degerim_#
						<cfif isdefined("caller.attributes.basket_footer_#attributes.id#")>
                            <cfif isdefined("caller.attributes.basket_footer_height_#attributes.id#")>
                                <cfset f_height = evaluate("caller.attributes.basket_footer_height_#attributes.id#")>
                            <cfelse>
                                <cfset f_height = 40>
                            </cfif>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed;">
                                <tr>
                                    <td valign="top" class="sepetim_td_footer">
                                        <div id="basket_footer_#attributes.id#" class="pod_basket_footer" style="text-align:left; width:100%; " align="left">
                                            <cfoutput>#evaluate("caller.attributes.basket_footer_#attributes.id#")#</cfoutput>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </cfif>
                    </div>
                 </div>
             </div>
        </div>
	</cfoutput>
</cfif>
