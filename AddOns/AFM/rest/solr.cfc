<cfcomponent rest="true" restPath="AFMSolr">
    
    <cffunction name="optionsMethod" access="remote" output="false" returntype="any" httpmethod="OPTIONS" restPath="search">
        <cfset getPageContext().getResponse().reset()>
        <cfheader name="Access-Control-Allow-Origin" value="*">      
        <cfheader name="Access-Control-Allow-Methods" value="GET,OPTIONS,POST">      
        <cfheader name="Access-Control-Allow-Headers" value="Content-Type,x-requested-with,Authorization"> 
        <cfheader name="Access-Control-Allow-Credentials" value="true"> 
    </cffunction>

    <cffunction name="search" httpMethod="POST" access="remote" returnformat="JSON" returntype="struct" restPath="search" produces="application/json">
        <cfargument name="data" type="struct">
        <cfset collection = data.collection>
        <cfset q = data.q>
        <cfset q = replace(q," ","\ ","all")>
        <cfset q = replace(q,"(","\(","all")>
        <cfset q = replace(q,")","\)","all")>
        <cfset data.category = replace(data.category," ","\ ","all")>
        <cfset data.category = replace(data.category,"(","\(","all")>
        <cfset data.category = replace(data.category,")","\)","all")>
        <cfset data.categoryTree = replace(data.categoryTree," ","\ ","all")>
        <cfset data.categoryTree = replace(data.categoryTree,"(","\(","all")>
        <cfset data.categoryTree = replace(data.categoryTree,")","\)","all")>
        <cfsearch collection=#collection# name="qresult" criteria='*#q#*' suggestions="always" category="*#data.category#*" categorytree="*#data.categoryTree#*">
        <cfset summaryArray = arrayNew(1)>
        <cfloop query="qresult">
            <cfscript>
                arrayAppend(summaryArray,qresult.summary);
            </cfscript>
        </cfloop>
        <cfset result = structNew()>
        <cfset result.summaryArray = summaryArray>
        <cfset result.qresult = qresult>
        <cfreturn result>
    </cffunction>
    
    <cffunction name="createIndex" access="remote" httpMethod="POST" returnformat="JSON" returntype="any" restPath="createIndex">
        <cfargument name="data" type="struct">
        <cfset response = deserializeJSON(SerializeJSON(data.result))> 
        <cfset queryVar=queryNew(data.columns,data.columnTypes,response)> <!--- [{},{}] ---><!--- "Id,Adı,Soyadı" ---><!--- "Integer,Varchar" --->
        <cfindex collection=#data.collectionName# action="update" query="queryVar" key=#data.key# body=#data.columns# status="status" category=#data.category# categoryTree=#data.categoryTree#>
        <cfreturn status> 
    </cffunction>

    <cffunction name="createCollection" access="remote" httpMethod="POST" returnformat="JSON" returntype="any" restPath="createCollection">
        <cfargument name="data" type="struct">
        <cftry>
            <cfcollection action="create" categories="true" collection=#data.collectionName#>
            <cfreturn "Koleksiyon başarıyla oluşturuldu.">
        <cfcatch type="any">
            <cfreturn cfcatch.message>
        </cfcatch>
    </cftry>
    </cffunction>

    <cffunction name="deleteCollection" access="remote" httpMethod="POST" returnformat="JSON" returntype="any" restPath="deleteCollection">
        <cfargument name="data" type="struct">
        <cftry>
            <cfcollection action="delete" collection=#data.collectionName#>
            <cfreturn "Koleksiyon başarıyla silindi.">
        <cfcatch type="any">
            <cfreturn cfcatch.message>
        </cfcatch>
    </cftry>
    </cffunction>
</cfcomponent>