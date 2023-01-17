<!---
    File: 
    Author: 
    Date: 
    Description:
		
--->
<cfcomponent displayname="data classifaciton yapabilmek için gerekli fonksiyonlar" output="false">
    <!---
    verilen dsn için GDPRClassificationWords tablosundaki ifadelerin olduğu tablo kolonlarını listeler	
    --->
    <cffunction name="get_datasoruces" access="public" returntype="any">
        <cfargument name="adminUser" type="string" required="true">
        <cfargument name="adminPass" type="string" required="true">
      
            <cfscript>
                adminObj = createObject("component","cfide.adminapi.administrator");
            // Pass Login Credentials
                adminObj.login(adminUserId=adminUser,adminPassword=adminPass);
            // Instantiate DSN ServiceFactory
                factory = createObject("java", "coldfusion.server.ServiceFactory").DataSourceService;
                sources = {};
                sources = factory.getDatasources();
            </cfscript>

        <cfreturn sources />
    </cffunction>

    <cffunction name="get_collections" access="public" returntype="query">
        <cfcollection action="list"  name="collectionExists" />
        <cfreturn collectionExists>
    </cffunction>

    <cffunction name="get_data_classification_for_db" access="public" returntype="query">
        <cfargument name="fn_dsn" type="string" required="true">
        <cfargument name="data_officer_id" type="string" required="true">
        <cfquery name="get_data_classification" datasource="#fn_dsn#">
             SELECT	DB_NAME() AS [DB_NAME],
                SCHEMA_NAME(t.schema_id) AS [SCHEMA_NAME],
                t.name AS TABLE_NAME, 
                c.name AS COLUMN_NAME,
                g.DATA_CATEGORY_ID,
                dc.DATA_CATEGORY,
                T3.SENSITIVITY_LABEL_ID,
                T3.SENSITIVITY_LABEL,
                cl.CLASSIFICATION_ID,
                cl.CLASSIFICATION_DESCRIPTION,
                cl.FILE_PATH,
                g.KEYWORD
            FROM
                sys.tables AS t 
                INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID
                INNER JOIN GDPR_CLASSIFICATION_KEYWORDS as g on 
                    ( 
                        ( g.SEARCH_TYPE = 2 AND c.name Like '%'+g.KEYWORD+'%' COLLATE SQL_Latin1_General_CP1_CI_AI )
                        OR
                        ( g.SEARCH_TYPE = 1 AND c.name = g.KEYWORD COLLATE SQL_Latin1_General_CP1_CI_AI )
                    )
                LEFT JOIN GDPR_CLASSIFICATION AS cl ON cl.DATA_OFFICER_ID = <cfqueryparam value="#data_officer_id#" cfsqltype="cf_sql_integer">
                    AND cl.CLASSIFICATION_TYPE_ID = 1
                    AND cl.[DB_NAME] = DB_NAME()
                    AND cl.[SCHEMA_NAME] = SCHEMA_NAME(t.schema_id)
                    AND cl.TABLE_NAME = t.name
                    AND cl.COLUMN_NAME = c.name
                LEFT JOIN GDPR_DATA_CATEGORIES as dc on dc.DATA_CATEGORY_ID = cl.DATA_CATEGORY_ID
                LEFT JOIN  GDPR_SENSITIVITY_LABEL AS T3 ON T3.SENSITIVITY_LABEL_ID = dc.SENSITIVITY_LABEL_ID
            WHERE NOT EXISTS(
                SELECT KEYWORD_ID FROM GDPR_CLASSIFICATION_KEYWORDS exculudeT 
                WHERE exculudeT.SEARCH_TYPE = 0 AND exculudeT.KEYWORD = c.name )
        </cfquery>
  		<cfreturn get_data_classification>
    </cffunction>
    

    <cffunction name="createCollection" returntype="boolean">
        <cfargument name="collectionName" type="string" required="true" />
    
        <!--- var scope a variable to check if the collection already exists --->
        <cfset var collectionExists = "" />
    
        <!--- use cfcollection to get a list of documents from the passed in collection      --->
        <cfcollection action="list"  name="collectionExists" />

        <!--- see if the collection has any records --->
        <cfquery name="qoq" dbtype="query"> 
            SELECT * from myCollections 
                WHERE myCollections.name = <cfqueryparam value="#arguments.collectionName#" cfsqltype="cf_sql_nvarchar">
        </cfquery> 
        <cfif qoq.recordcount GT 0> 
            <!--- it doesn't, but wrap create in a try in case it exists but is merely empty --->
            <cftry>
                <!--- use cfcollection to create a new collection 
                <cfcollection action="create" collection="#arguments.collectionName#" />
                --->
            <!--- catch if this collection already exists --->
            <cfcatch type="any">
                <!--- it does, return false --->
                <cfreturn false />
            </cfcatch>
            </cftry>
        <!--- otherwise --->
        <cfelse>
            <!--- collection already has records (and thus exists), return false --->
            <cfreturn false />
        </cfif>
    
        <!--- the collection was successfully created, return true --->
        <cfreturn true />
    </cffunction>

    <cffunction name="collectionIndex" returntype="boolean">
        <cfargument name="collectionName" type="string" required="true" />
        <cfargument name="key" type="string" required="true" />
        <cftry>
        <cfindex collection="#collectionName#"
            action="update"
            type="path"
            key="#key#"
            <!---urlpath="http://localhost/vw_files/newspaper/sports"--->
            extensions=".*"
            recurse="yes"
            <!---language="English"--->
            status="status"
            >
        <cfcatch type="any">
            <!--- it does, return false --->
            <cfreturn false />
        </cfcatch>
        </cftry>
        <cfreturn true />
    </cffunction>

    <cffunction name="get_data_classification_for_collection" returntype="query">
        <cfargument name="collectionName" type="string" required="true" />
        <cfargument name="criteria" type="string" required="true" />
            <cfsearch
                name = "data_classification"
                collection = "#collectionName#"
                criteria = "#criteria#"
                contextpassages = "1"> 
        <cfreturn data_classification />
    </cffunction>


</cfcomponent>
