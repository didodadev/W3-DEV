<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="form_list_#round(rand()*10000000)#">
<cfparam name="attributes.class" default="form_list">
<cfparam name="attributes.sort" default="1">
<cfparam name="attributes.uiscroll" default="1">
<cfparam name="attributes.margin" default="">
<cfparam name="attributes.table_width" default="">
<cfoutput>
	<cfif thisTag.executionMode eq "start">
		<div class="<cfif attributes.uiscroll eq 1>ui-scroll</cfif>"  <!--- style="position:relative;<cfif len(attributes.margin)>margin:#attributes.margin#px</cfif>" --->>
       		<table id="#attributes.id#" class="ui-table-list ui-form" <cfif len(attributes.sort) and attributes.sort eq 1>sort="true"</cfif> border="1" <cfif len(attributes.table_width)>style="width:#attributes.table_width#px"</cfif>>
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
                event = $('.controllerEvents').attr("id");
                if(event == "list"){
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
               $(function() {
					var column_order =  JSON.parse('<cfoutput>#caller.attributes.js_column_order#</cfoutput>');
					$.each(column_order, function(i, v){
						if(document.getElementById(i).cellIndex != v){
							var tbl = jQuery('.ui-table-list');
							jQuery.moveColumn(tbl, document.getElementById(i).cellIndex, v);
						}
					})
				});
		</cfif>	
		</script>
    </cfif>
</cfoutput>
