<cfparam name="attributes.style" default="">
<cfparam name="attributes.id" default="ajax_list_#round(rand()*10000000)#"> <!--- Seperator kullanılınca buna ihtiyac duyuluyor diye ekledim. E.Y 20121003--->
<cfoutput>
	<cfif thisTag.executionMode eq "start">
        <div class="ui-scroll">
        	<table id="#attributes.id#" class="ajax_list ui-form"  <cfif len(attributes.style)>style="#attributes.style#"</cfif> sort="true">
    <cfelse>
        	</table>
        </div>
        <script>
            jQuery.moveColumn = function (table, from, to) {
                var rows = jQuery('tr', table);
                var cols;
                rows.each(function() {
                cols = jQuery(this).children('th, td');
                cols.eq(from).detach().insertBefore(cols.eq(to));
                });
            }
		
            if($('.controllerEvents').length){
                if($('.controllerEvents').attr("id") == "list"){
                    var th = $('.ui-table-list thead th');
                        th.each(function(){
                            if($(this).attr("id") == undefined)
                            {
                                $(this).attr("id","th_"+$(this).index());
                            };
                    });
                }
            }

            <cfif isdefined("caller.attributes.js_column_order") and len(caller.attributes.js_column_order)>
                var column_order =  JSON.parse('<cfoutput>#caller.attributes.js_column_order#</cfoutput>');
                $.each(column_order, function(i, v){
                    if(document.getElementById(i).cellIndex != v){
                        var tbl = jQuery('.ui-table-list');
                        jQuery.moveColumn(tbl, document.getElementById(i).cellIndex, v);
                    }
                })
            </cfif>	
        </script>
    </cfif>
</cfoutput>
