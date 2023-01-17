<cfcomponent namespace="GridDataItem" extends="DataItem" hint="DataItem class for Grid component">
	<cfscript>
		variables.row_attrs = structNew();//!< hash of row attributes
		variables.cell_attrs = structNew();//!< hash of cell attributes
	</cfscript>
	
	<cffunction name="init" access="public" returntype="any" hint="constructor">
		<cfargument name="data" type="any" required="yes" hint="Data object">
		<cfargument name="config" type="any" required="yes" hint="config object">
		<cfargument name="index" type="numeric" required="no" default="0" hint="index of an element">
		<cfset super.init(ARGUMENTS.data,ARGUMENTS.config,ARGUMENTS.index)>
		<cfset variables.row_attrs=structNew()>
		<cfset variables.cell_attrs=structNew()>
		<cfreturn this>
	</cffunction>

	<cffunction name="set_row_color" access="public" returntype="void" hint="set color of row">
		<cfargument name="color" type="string" required="yes" hint="color of row">
		<cfset variables.row_attrs["bgColor"]=ARGUMENTS.color>
	</cffunction>

	<cffunction name="set_row_style" access="public" returntype="void" hint="set style of row">
		<cfargument name="style" type="string" required="yes" hint="style of row">
		<cfset variables.row_attrs["style"]=ARGUMENTS.style>
	</cffunction>

	<cffunction name="set_cell_style" access="public" returntype="void" hint="assign custom style to the column">
		<cfargument name="name" type="string" required="yes" hint="name of column">
		<cfargument name="value" type="string" required="yes" hint="css style string">
		<cfset set_cell_attribute(ARGUMENTS.name,"style",ARGUMENTS.value)>
	</cffunction>
	<cffunction name="set_cell_class" access="public" returntype="void" hint="assign custom class to specific column">
		<cfargument name="name" type="string" required="yes" hint="name of column">
		<cfargument name="value" type="string" required="yes" hint="css class name">
		<cfset set_cell_attribute(ARGUMENTS.name,"class",ARGUMENTS.value)>
	</cffunction>
	
	<cffunction name="set_cell_attribute" access="public" returntype="void" hint="set custom cell attribute">
		<cfargument name="name" type="string" required="yes" hint="name of column">
		<cfargument name="attr" type="string" required="yes" hint="name of attribute">
		<cfargument name="value" type="string" required="yes" hint="value of attribute">
		<cfif not structKeyExists(variables.cell_attrs,ARGUMENTS.name)>
			<cfset variables.cell_attrs[ARGUMENTS.name]=structNew()>
		</cfif> 
		<cfset variables.cell_attrs[ARGUMENTS.name][ARGUMENTS.attr]=ARGUMENTS.value>
	</cffunction>
	
	<cffunction name="set_row_attribute" access="public" returntype="void" hint="set custom row attribute">
		<cfargument name="attr" type="string" required="yes" hint="name of attribute">
		<cfargument name="value" type="string" required="yes" hint="value of attribute">
		<cfset variables.row_attrs[ARGUMENTS.attr]=ARGUMENTS.value>
	</cffunction>

	<cffunction name="to_xml_start" access="public" returntype="string" hint="return self as XML string without ending tag">
		<cfset var str = "">
		<cfset k = "">
		<cfset v = "">
		<cfset i = "">
		<cfset name = "">
		<cfset cattrs = "">
		
		<cfif variables.skip>
			<cfreturn "">
		</cfif>
		<cfset str = "<row id='" & get_id() & "'">
		<cfloop collection="#variables.row_attrs#" item="k">
			<cfset v = variables.row_attrs[k]>
			<cfset str = str & " " & k &  "='" & v & "'">
		</cfloop>
		<cfset str = str & ">">
		<cftry>
		<cfloop from="1" to="#ArrayLen(variables.config.data)#" index="i">
			<cfset str = str & "<cell">
			<cfset name=variables.config.data[i]["name"]>
			<cfif structKeyExists(variables.cell_attrs,name)>
				<cfset cattrs=variables.cell_attrs[name]>
				<cfloop collection="#cattrs#" item="k">
					<cfset v = cattrs[k]>
					<cfset str = str & " " & k & "='" & v & "'">
				</cfloop>
			</cfif>
			<cfset str = str & "><![CDATA[" & variables.data[name] & "]]></cell>">
		</cfloop>
			<cfcatch>
				<cfcontent reset="yes" type="text/html"><Cfoutput>#str#<Cfabort></Cfoutput>
			</cfcatch>
		</cftry>	
		<cfreturn str>
	</cffunction>

	<cffunction name="to_xml_end" access="public" returntype="string" hint="return ending tag for self as XML string ">
		<cfreturn "</row>">
	</cffunction>
</cfcomponent>

