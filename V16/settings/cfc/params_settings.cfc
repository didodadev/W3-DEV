<cfcomponent>
    <cfset file_path = ReplaceNoCase(replace(GetDirectoryFromPath(GetCurrentTemplatePath()),"\","/","ALL"),"V16/settings/cfc/","","ALL")>
    <cffile action="read" file="#file_path#dsn.txt" variable="returnval">
    <cfset returnval = replace(returnval, chr(13)&Chr(10), '' ,'all') />
    <cfset params_val = structNew()>
    <cffunction name="UPDATE_PARAMS_COL" hint="" access="remote" returnType="boolean">
        <cfargument name="json" type="string">
        <cfargument name="release_no" type="string" required="false">
        <cfset response = 0 />
        
        <cfquery name="GET_PARAMS" datasource="#returnval#">
            SELECT WSP_PARAM FROM WRK_SYSTEM_PARAMS WHERE WSP_DOMAIN = <cfqueryparam value="#cgi.server_name#">
        </cfquery>

        <cftry>
            <cfif GET_PARAMS.recordcount>
                <cfquery name="UPDATE_PARAMS_COL" datasource="#returnval#">
                    UPDATE WRK_SYSTEM_PARAMS 
                    SET WSP_PARAM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.json#">
                    WHERE WSP_DOMAIN = <cfqueryparam value="#cgi.server_name#">
                </cfquery>
            <cfelse>
                <cfquery name="UPDATE_PARAMS_COL" datasource="#returnval#">
                    INSERT INTO WRK_SYSTEM_PARAMS(
                        WSP_DOMAIN,
                        WSP_PARAM
                    )VALUES(
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.server_name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.json#">
                    ) 
                </cfquery>
            </cfif>
            <cfset response = 1 />
            <cfcatch type="any">
                <cfset response = 0 />
            </cfcatch>
        </cftry>

        <cfreturn response>
    </cffunction>
    <cffunction name="GET_PARAMS"  hint="" access="remote" returnformat="JSON">
        <cfargument  name="mode" default="">

        <cfquery name="create_table" datasource="#returnval#">
            IF NOT EXISTS( SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='WRK_SYSTEM_PARAMS')
            BEGIN
                CREATE TABLE [WRK_SYSTEM_PARAMS](
                    [WSP_ID] [int] IDENTITY(1,1) NOT NULL,
                    [WSP_DOMAIN] [nvarchar](250) NOT NULL,
                    [RELEASE_NO] [nvarchar](250) NULL,
                    [WSP_PARAM] [nvarchar](max) NOT NULL,
                CONSTRAINT [PK_WRK_SYSTEM_PARAMS] PRIMARY KEY CLUSTERED 
                (
                    [WSP_ID] ASC
                )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
                ) ON [PRIMARY]
            END
            ELSE
            BEGIN
                IF NOT EXISTS (SELECT 'Y' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'WRK_SYSTEM_PARAMS' AND COLUMN_NAME = 'RELEASE_NO')
                BEGIN
                    ALTER TABLE WRK_SYSTEM_PARAMS ADD 
                    RELEASE_NO nvarchar(250) NULL
                END
            END
        </cfquery>

        <cfquery name="GET_PARAMS" datasource="#returnval#">
            SELECT WSP_PARAM AS PARAMS, RELEASE_NO FROM WRK_SYSTEM_PARAMS WHERE WSP_DOMAIN = <cfqueryparam value="#cgi.server_name#"> OR WSP_DOMAIN_WHOPS = <cfqueryparam value="#cgi.server_name#">
        </cfquery>

        <cfif not GET_PARAMS.recordcount and mode neq 'systemParam'>
            <cfquery name="GET_PARAMS" datasource="#returnval#">
                SELECT TOP 1 PARAMS, RELEASE_NO FROM WRK_LICENSE ORDER BY LICENSE_ID DESC
            </cfquery>
        </cfif>

        <cfreturn GET_PARAMS>
    </cffunction>
    <cffunction name="GET_PARAMS_RELEASE"  hint="" access="remote">
        <cfquery name="GET_PARAMS_RELEASE" datasource="#returnval#">
            SELECT TOP 1 RELEASE_NO FROM WRK_LICENSE ORDER BY LICENSE_ID DESC
        </cfquery>
        <cfreturn GET_PARAMS_RELEASE>
    </cffunction>
    <cffunction name = "GET_BITBUCKET_APP_PASSWORD" returnType = "any" access = "remote" returnformat="JSON">
        <cfargument name="release_no" required="false" default="">
        
        <cfset workcube_license = createObject( "component","V16.settings.cfc.workcube_license" ) />
        <cfset get_license_information =  workcube_license.get_license_information() />
        <cfif get_license_information.recordcount and len(get_license_information.WORKCUBE_ID)>
            <cfset api_key = "20180911HjPo356h">
            <cfhttp url="https://networg.workcube.com/web_services/uhtil854o2018.cfc?method=GET_BITBUCKET_APP_PASSWORD" result="response" charset="utf-8">
                <cfhttpparam name="api_key" type="formfield" value="#api_key#">
                <cfhttpparam name="release_no" type="formfield" value="#len(arguments.release_no) ? arguments.release_no : this.GET_PARAMS().RELEASE_NO#">
                <cfhttpparam name="domain_address" type="formfield" value="#listFirst(application.systemParam.systemParam().employee_url,';')#">
                <cfhttpparam name="license_code" type="formfield" value="#get_license_information.WORKCUBE_ID#">
            </cfhttp>
            <cfreturn response.filecontent>
        </cfif>
    </cffunction>

    <cfscript>

        public struct function getDeserializedParams( string mode = "" ) {
            allParams = deserializeJson( len( this.GET_PARAMS( mode ).PARAMS ) ? this.GET_PARAMS( mode ).PARAMS : '{}' );
            newParams = structNew();
            for(param in allParams){

                convertedStruct = convertStringToStruct(param,allParams[param]);
                if( newParams.keyExists( convertedStruct.keyList() ) ) structAppend(newParams[convertedStruct.keyList()], convertedStruct[convertedStruct.keyList()], false); //structInsert(newParams, convertedStruct.keyList(), convertedStruct[convertedStruct.keyList()] );        
                else structAppend(newParams, convertedStruct, false);

            }
            return newParams;
        }

        public struct function getAllParams( struct data, string mode = "" ) {

            params = this.getDeserializedParams( mode );

            for( param in params ){
                if( isStruct( params[ param ] ) ){

                    if( not data.keyExists( param ) ) data[param] = structNew();
                    for( prm in params[ param ] ){

                        if( not data[param].keyExists( prm ) ){
                            data[param][prm] = { val : params[param][prm], type: 'text', required : false, readonlyKey : false, readonlyValue : false }; 
                        }else{
                            data[param][prm]['VAL'] = params[param][prm];
                        }

                    }

                }else{
                    if( not data.keyExists( param ) ){
                        data[param] = { val : params[param], type: 'text', required : false, readonlyKey : false, readonlyValue : false };
                    }else data[param]['VAL'] = params[param];
                }
            }

            return data;

        }

        public struct function convertStringToStruct(required string key, required any value, string delimiter = ".") {

            var obj = StructNew();
            var first = ListFirst(arguments.key, arguments.delimiter);
            var rest = ListRest(arguments.key, arguments.delimiter);
        
            if (Len(rest)) obj[first] = convertStringToStruct(rest, arguments.value, arguments.delimiter);
            else obj[first] = arguments.value;
    
            return obj;
            
        }

    </cfscript>
</cfcomponent>