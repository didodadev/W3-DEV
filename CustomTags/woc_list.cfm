<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="form_list_#round(rand()*10000000)#">
<cfparam name="attributes.class" default="form_list">
<cfparam name="attributes.sort" default="1">
<cfparam name="attributes.margin" default="">
<cfparam name="attributes.table_width" default="">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.colspan" default="">
<cfset title_value = "">
<cfoutput>
	<cfif thisTag.executionMode eq "start">
        
        <tr  id="#attributes.id#">
            <td>
                <table class="table table-bordered print_border" data-resizable-columns-id="demo-table"<cfif len(attributes.sort) and attributes.sort eq 1>sort="true"</cfif> border="1" <cfif len(attributes.table_width)>style="width:#attributes.table_width#px"</cfif> id="#attributes.id#_table"> 
                    <cfif len(attributes.title)>
                        <thead>
                            <tr>
                                <cfloop list="#attributes.title#" delimiters="+" index="i" item="c">
                                    <cfsavecontent variable="tmplabel">
                                        <cf_get_lang dictionary_id="#c#">
                                    </cfsavecontent>
                                    <cfset title_value = listAppend(title_value, tmplabel, " ")>
                                </cfloop>
                                <th class="bold" colspan="#attributes.colspan#">#title_value#</th> 
                            </tr>
                        </thead>
                    </cfif> 
       
    <cfelse>
                </table>
            </td>
        </tr>
        <script type="text/javascript">
            <cfif caller.attributes.fuseaction eq 'objects.popup_print_designer'>
                $( "###attributes.id# td" ).click(function() {
                    $( "###attributes.id#" ).draggable();
                });
                $(function(){
                    $("###attributes.id#_table").resizableColumns({
                        store: window.store
                    });
                    
                });
            </cfif>            
        </script>
    </cfif>
</cfoutput>
