<cfcomponent namespace="DataConfig" hint="manager of data configuration">
	<cfscript>
		variables.lineBreak = "#chr(13)##chr(10)#";
		this.id = structNew();			////!< name of ID field
		this.relation_id = structNew();	//!< name or relation ID field
		this.text = ArrayNew(1);		//!< array of text fields
		this.data = ArrayNew(1);		//!< array of all known fields , fields which exists only in this collection will not be included in dataprocessor's operations
	</cfscript>
	
	<!--- ----------------------------------------------------------------------------
		constructor
		init public collectons
		@param proto
			DataConfig object used as prototype for new one, optional
	---------------------------------------------------------------------------- ---> 
	<cffunction name="init" access="public" returntype="any">
		<cfargument name="proto" type="any" required="no">
		
		<cfif isDefined("ARGUMENTS.proto")>
			<cfset copy(ARGUMENTS.proto)>
		<cfelse>
			<cfset this.text=ArrayNew(1)>
			<cfset this.data=ArrayNew(1)>
			<cfset this.id=structNew()>
			<cfset this.id["name"] = "dhx_auto_id">
			<cfset this.id["db_name"] = "dhx_auto_id">
			<cfset this.relation_id = structNew()>
			<cfset this.relation_id["name"] = "">
			<cfset this.relation_id["db_name"] = "">
		</cfif>
		<cfreturn this>
	</cffunction>	
	
	
	<cffunction name="__toString" access="public" returntype="string">
		<cfset var str = "">
		<cfset var i = 0>
		
		<cfset str="ID:#this.id['db_name']#(ID:#this.id['name']#)#variables.lineBreak#">
		<cfset str = str & "Relation ID:#this.relation_id['db_name']#(#this.relation_id['name']#)#variables.lineBreak#">
		<cfset str = str & "Data:">
		<cfloop from="1" to="#ArrayLen(this.text)#" index="i">
			<cfset str = str & "#this.text[i]['db_name']#(#this.text[i]['name']#),">
		</cfloop>
		<cfset str = str & "#variables.lineBreak#Extra:">
		<cfloop from="1" to="#ArrayLen(this.data)#" index="i">
			<cfset str = str & "#this.data[i]['db_name']#(#this.data[i]['name']#),">
		</cfloop>
		<cfreturn str>
	</cffunction>
	
	<cffunction name="minimize" access="public" returntype="void">
		<cfargument name="name" type="string" required="yes">
		<cfset var i=0>
		<cfset var tmp = "">
		<cfloop from="1" to="#ArrayLen(this.text)#" index="i">
			<cfif this.text[i]["name"] eq ARGUMENTS.name>
				<cfset this.text[i]["name"]="value">
				<cfset tmp = this.text[i]>
				<cfset this.data = ArrayNew(1)>
				<cfset this.text = ArrayNew(1)>
				<cfset this.data[1] = tmp>
				<cfset this.text[1] = tmp> 
				<cfreturn>
			</cfif>		
		</cfloop>
		<cfthrow  errorcode="99" message="Incorrect dataset minimization, master field not found.">	
	</cffunction>
	
	<cffunction name="init2" access="public" returntype="void">
		<cfargument name="id" type="any" required="yes">
		<cfargument name="fields" type="any" required="yes">
		<cfargument name="extra" type="any" required="yes">
		<cfargument name="relation" type="any" required="yes">
		<cfset var i = 0>
			
		<cfset this.id = parse(ARGUMENTS.id,false)>
		<cfset this.text = parse(ARGUMENTS.fields,true)>

		<cfset this.data = parse(ARGUMENTS.extra,true)>
		<cfloop from="1" to="#ArrayLen(this.text)#" index="i">
			<cfset ArrayAPpend(this.data,this.text[i])>
		</cfloop>
		<cfif len(ARGUMENTS.relation)>
			<cfset this.relation_id = parse(ARGUMENTS.relation,false)>
		</cfif>
	</cffunction>
	
	<cffunction name="parse" access="private" returntype="any">
		<cfargument name="key" type="string" required="yes">
		<cfargument name="mode" type="boolean" required="yes">
		<cfset var i=0>
		<cfset var data="">
		<cfif ARGUMENTS.mode>
			<cfif NOT Len(ARGUMENTS.key)><cfreturn ArrayNew(1)></cfif>
			<cfset ARGUMENTS.key=ListToArray(ARGUMENTS.key,",")>
			<cfloop from="1" to="#ArrayLen(ARGUMENTS.key)#" index="i">
				<cfset ARGUMENTS.key[i] = parse(ARGUMENTS.key[i],false)>
			</cfloop>	
			<cfreturn ARGUMENTS.key>
		</cfif>
		<cfset ARGUMENTS.key=ListToArray(ARGUMENTS.key,"(")>
		<cfset data = structNew()>
		<cfset data["db_name"] = trim(ARGUMENTS.key[1])>
		<cfset data["name"] = trim(ARGUMENTS.key[1])>
		<cfif ArrayLen(ARGUMENTS.key) gt 1>
			<cfset data["name"]=mid(trim(ARGUMENTS.key[2]),1,len(trim(ARGUMENTS.key[2]))-1)>
		</cfif>
		<cfreturn duplicate(data)>
	</cffunction>	

	
	<cffunction name="copy" access="public" returntype="void">
		<cfargument name="proto" type="any" required="yes">
		<cfset this.id = duplicate(ARGUMENTS.proto.id)>
		<cfset this.relation_id = duplicate(ARGUMENTS.proto.relation_id)>
		<cfset this.text = ARGUMENTS.proto.text>
		<cfset this.data = ARGUMENTS.proto.data>
	</cffunction>
	<!--- ----------------------------------------------------------------------------
		returns list of data fields (db_names)
		@return 
			list of data fields ( ready to be used in SQL query )
	---------------------------------------------------------------------------- ---> 
	<cffunction name="db_names_list" access="public" returntype="string">
		<cfset var out= ArrayNew(1)>
		<cfset var i=0>
		<cfif len(this.id["db_name"])>
			<cfset ArrayAppend(out,this.id["db_name"])>
		</cfif>	
		<cfif len(this.relation_id["db_name"])>
			<cfset ArrayAppend(out,this.relation_id["db_name"])>
		</cfif>
		<cfloop from="1" to="#ArrayLen(this.data)#" index="i">
			<cfif this.data[i]["db_name"] neq this.data[i]["name"]>
				<cfset ArrayAppend(out,this.data[i]["db_name"] & " as " & this.data[i]["name"])>
			<cfelse>
				<cfset ArrayAppend(out,this.data[i]["db_name"])>
			</cfif>	
		</cfloop>
		<cfreturn ArraytoList(out,",")>	
	</cffunction>
	<!--- ----------------------------------------------------------------------------
		add field to dataset config ($text collection)
		added field will be used in all auto-generated queries
		@param name 
			name of field
		@param aliase
			aliase of field, optional
	---------------------------------------------------------------------------- ---> 
	<cffunction name="add_field" access="public" returntype="void">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="aliase" type="any" required="no" default="">
		
		<cfset var st="">
		<cfset var i=0>
		
		<cfif NOT len(ARGUMENTS.aliase)>
			<cfset ARGUMENTS.aliase=ARGUMENTS.name>
		</cfif>
		
		<!---adding to list of data-active fields --->
		<cfif this.id["db_name"] eq ARGUMENTS.name OR this.relation_id["db_name"] eq ARGUMENTS.name>
			<cfset request.dhtmlXLogMaster.do_log("Field name already used as ID, be sure that it is really necessary.")>
		</cfif>
		<cfif is_field(ARGUMENTS.name,this.text) neq -1>
			<cfthrow errorcode="99" message="Data field already registered: #ARGUMENTS.name#">
		</cfif>
		
		<cfset st = structNew()>
		<cfset st["db_name"] = ARGUMENTS.name>
		<cfset st["name"] = ARGUMENTS.aliase>
		<cfset ArrayAppend(this.text,st)>
		
		<!--- adding to list of all fields as well --->
		<cfif is_field(ARGUMENTS.name,this.data) eq -1>
			<cfset st = structNew()>
			<cfset st["db_name"] = ARGUMENTS.name>
			<cfset st["name"] = ARGUMENTS.aliase>
			<Cfset ArrayAppend(this.data,st)>
		</cfif>	
	</cffunction>
	<!--- ----------------------------------------------------------------------------
		remove field from dataset config ($text collection)

		removed field will be excluded from all auto-generated queries
		@param name 
			name of field, or aliase of field
	---------------------------------------------------------------------------- ---> 
	<cffunction name="remove_field" access="public" returntype="void">
		<cfargument name="name" type="string" required="yes">
		<cfset var ind = is_field(ARGUMENTS.name)>
		<cfif ind eq -1>
			 <cfthrow errorcode="99" message="There was no such data field registered as: #ARGUMENTS.name#">
		</cfif>	 
		<cfset ArrayDeleteAt(this.config["field"],ind)>
		<!---
		we not deleting field from $data collection, so it will not be included in data operation, but its data still available
		--->
	</cffunction>
	<!--- ----------------------------------------------------------------------------
		check if field is a part of dataset
		@param name 
			name of field
		@param collecton
			collection, against which check will be done, $text collection by default
		@return 
			returns true if field already a part of dataset, otherwise returns true
	---------------------------------------------------------------------------- ---> 
	<cffunction name="is_field" access="private" returntype="numeric">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="collection" type="any" required="no">
		<cfset var i=0>
		<cfif not isDefined("ARGUMENTS.collection")>
			<cfset ARGUMENTS.collection=this.text>
		</cfif>	
		<cfloop from="1" to="#ArrayLen(ARGUMENTs.collection)#" index="i">
			<cfif ARGUMENTS.collection[i]["name"] eq ARGUMENTS.name OR ARGUMENTS.collection[i]["db_name"] eq ARGUMENTS.name>
				<cfreturn i>
			</cfif>
		</cfloop>
		<cfreturn -1>
	</cffunction>
</cfcomponent>

