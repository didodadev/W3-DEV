<cfcomponent namespace="TreeGridConnector" extends="GridConnector">
	<cfscript>
		variables.id_swap = structNew();
	</cfscript>	
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="res" type="string" required="yes">
		<cfargument name="type" type="string" required="no" default="">
		<cfargument name="item_type" type="string" required="no" default="">
		<cfargument name="data_type" type="string" required="no" default="">
		<cfset var ar = "">
		<cfif not len(ARGUMENTS.item_type)>
			<cfset ARGUMENTS.item_type="TreeGridDataItem">	
		</cfif>
		<cfif not len(ARGUMENTS.data_type)>
			<cfset ARGUMENTS.data_type="TreeGridDataProcessor">
		</cfif>
		<cfset super.init(ARGUMENTS.res,ARGUMENTS.type,ARGUMENTS.item_type,ARGUMENTS.data_type)>
		<cfset ar = ArrayNew(1)>
		<cfset ar[1] = this>
		<cfset ar[2] = "parent_id_correction_a">
		<cfset this.event.attach("afterInsert",ar)>
		<cfset ar = ArrayNew(1)>
		<cfset ar[1] = this>
		<cfset ar[2] = "parent_id_correction_b">
		<cfset this.event.attach("beforeProcessing",ar)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="parent_id_correction_a" access="public" returntype="any">
		<cfargument name="dataAction" type="any" required="yes">
		<cfset variables.id_swap[ARGUMENTS.dataAction.get_id()]=ARGUMENTS.dataAction.get_new_id()>
	</cffunction>	
	<cffunction name="parent_id_correction_b" access="public" returntype="any">
		<cfargument name="dataAction" type="any" required="yes">
		<cfset var relation = variables.config.relation_id["db_name"]>
		<cfset var value = ARGUMENTS.dataAction.get_value(relation)>
		<cfif structKeyExists(variables.id_swap,value)>
			<cfset ARGUMENTS.dataAction.set_value(relation,variables.id_swap[value])>
		</cfif>	
	</cffunction>	

	<cffunction name="parse_request" access="public" returntype="any" hint="process treegrid specific options in incoming request">
		<cfset super.parse_request()>
		<cfif isDefined("URL.id")>
			<cfset variables._request.set_relation(URL.id)>
		<cfelse>
			<cfset variables._request.set_relation("0")>
		</cfif>	
		<!--- //netralize default reaction on dyn. loading mode--->
		<cfset variables._request.set_limit(0,0)> 
	</cffunction>

	<cffunction name="render_set" access="public" returntype="any" hint="process treegrid specific options in incoming request">
		<cfargument name="res" type="query" required="yes">
		<cfset var output="">
		<cfset var index=0>
		<cfset var data="">
		<cfset var sub_request = "">
		
		<cfif not isDefined("this.sub_requestO")>
			<cfset this.sub_requestO = createObject("component","DataRequestConfig")>	
		</cfif>
		
		
		<cfloop query="ARGUMENTS.res">
			<cfset data=this.sql.get_next(ARGUMENTS.res,ARGUMENTS.res.currentRow)>
			<cfset data = CreateObject("component",names["item_class"]).init(data,variables.config,index)>
			<cfset this.event.trigger("beforeRender",data)>
			
			<!----
			//there is no info about child elements, 
			//if we are using dyn. loading - assume that it has,
			//in normal mode juse exec sub-render routine		
			--->
			
			<cfif data.has_kids()eq -1 AND variables.dload>
				<cfset data.set_kids(true)>
			</cfif>	
			<cfset output = output & data.to_xml_start()>
			<cfif data.has_kids() eq -1 OR (data.has_kids() eq true AND NOT variables.dload)>
				<cfset sub_request = this.sub_requestO.init(variables._request)>
				<cfset sub_request.set_relation(data.get_id())>
				<cfset output = output & render_set(this.sql.do_select(sub_request))>
			</cfif>
			<cfset output = output & data.to_xml_end()>
			<cfset index = index+1>
		</cfloop>
		<cfreturn output>
	</cffunction>
	<cffunction name="xml_start" access="public" returntype="string">
		<cfreturn "<rows parent='" & variables._request.get_relation() & "'>">
	</cffunction>
</cfcomponent>			
