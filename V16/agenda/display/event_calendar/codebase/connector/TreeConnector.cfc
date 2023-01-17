<cfcomponent namespace="TreeConnector" extends="Connector">
	<cfscript>
		variables.id_swap = structNew();	
	</cfscript>
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="res" type="string" required="yes">
		<cfargument name="type" type="string" required="no" default="">
		<cfargument name="item_type" type="string" required="no" default="">
		<cfargument name="data_type" type="string" required="no" default="">
		
		<cfset var ar = "">
		<cfif NOT len(ARGUMENTS.item_type)>
			<cfset ARGUMENTS.item_type="TreeDataItem">
		</cfif> 
		<cfif not len(ARGUMENTS.data_type)>
			<cfset ARGUMENTS.data_type="TreeDataProcessor">
		</cfif>
		<cfset super.init(ARGUMENTS.res,ARGUMENTS.type,ARGUMENTS.item_type,ARGUMENTS.data_type)>
		<cfset ar = ArrayNew(1)>
		<cfset arrayAppend(ar,this)>
		<cfset arrayAppend(ar,"parent_id_correction_a")>
		<cfset this.event.attach("afterInsert",ar)>
		<cfset ar = ArrayNew(1)>
		<cfset arrayAppend(ar,this)>
		<cfset arrayAppend(ar,"parent_id_correction_b")>
		<cfset this.event.attach("beforeProcessing",ar)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="parent_id_correction_a" access="public" returntype="void">
		<cfargument name="dataAction" type="any" required="yes">
		<cfset variables.id_swap[ARGUMENTS.dataAction.get_id()]=ARGUMENTS.dataAction.get_new_id()>
	</cffunction>
	<cffunction name="parent_id_correction_b" access="public" returntype="void">
		<cfargument name="dataAction" type="any" required="yes">
		<cfset var relation = "">
		<cfset var value = "">
		
		<cfset relation = variables.config.relation_id["db_name"]>
		<cfset value = ARGUMENTS.dataAction.get_value(relation)>
		<cfif structKeyExists(variables.id_swap,value)>
			<cfset ARGUMENTS.dataAction.set_value(relation,variables.id_swap[value])>
		</cfif>
	</cffunction>
	
	<cffunction name="parse_request" access="public" returntype="void">
		<cfset super.parse_request()>
		<cfif isDefined("URL.id")>
			<Cfset variables._request.set_relation(URL.id)>
		<cfelse>
			<cfset variables._request.set_relation("0")>
		</cfif>	
		<!--- //netralize default reaction on dyn. loading mode--->
		<cfset variables._request.set_limit(0,0)> 
	</cffunction>
	
	
	<cffunction name="render_set" access="public" returntype="string">
		<cfargument name="res" type="query" required="yes">
		<cfset var output="">
		<cfset var index=0>
		<cfset var data="">
		<cfset var sub_request = "">
		
		<cfif not isDefined("this.dataO")>
			<cfset this.dataO = CreateObject("component",variables.names["item_class"])>
		</cfif>	
		<cfif not isDefined("this.sub_requestO")>
			<cfset this.sub_requestO = createObject("component","DataRequestConfig")>	
		</cfif>
		<cfloop query="ARGUMENTS.res">
			<cfset data=this.sql.get_next(ARGUMENTS.res,ARGUMENTS.res.currentRow)>
			<cfset data = this.dataO.init(data,variables.config,index)>
			<cfset this.event.trigger("beforeRender",data)>
			<!---	
			//there is no info about child elements, 
			//if we are using dyn. loading - assume that it has,
			//in normal mode juse exec sub-render routine			
			--->
			<cfif data.has_kids() eq -1 AND variables.dload>
				<cfset data.set_kids(true)>
			</cfif>		
			<cfset output = output & data.to_xml_start()>
			<cfif data.has_kids() eq -1 OR (data.has_kids() eq true AND NOT variables.dload)>
				<cfset sub_request = this.sub_requestO.init(variables._request)>
				<cfset sub_request.set_relation(data.get_id())>
				<cfset output = output & render_set(this.sql.do_select(sub_request))>
			</cfif>
			<cfset output = output & data.to_xml_end()>
			<cfset index =index+1>
		</cfloop>
		<cfreturn output>
	</cffunction>
	
	<cffunction name="xml_start" access="public" returntype="string">
		<cfreturn "<tree id='" & variables._request.get_relation() & "'>">
	</cffunction>
	<cffunction name="xml_end" access="public" returntype="string">
		<cfreturn "</tree>">
	</cffunction>
</cfcomponent>

