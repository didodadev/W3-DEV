<cfinclude template="../config.cfm">
<cffunction name="child_setter">
	<cfargument name="data" type="any" required="yes">
	<!--- //the check is kind of lame, in real table you most probably may have some more stable way to detect is item have childs or not---->
	<cfif ARGUMENTS.data.get_value("taskId") mod 100 gt 1>
		<cfset data.set_kids(false)>
	<cfelse>
		<cfset data.set_kids(true)>
	</cfif> 	
</cffunction>
<cfset tree = createObject("component",request.dhtmlxConnectors["tree"]).init(request.dhtmlxConnectors["datasource"])>
<cfset tree.event.attach("beforeRender",child_setter)>
<cfset tree.render_table("tasks","taskId","taskName","","parentId")>

