<!---

    Author : Uğur Hamurpet
    Create Date : 23/05/2021

--->

<cfcomponent accessors="true" extends="V16/settings/cfc/workcube_license">

    <cfproperty  name="datasource" type="string">
    <cfproperty  name="wbp_name" type="string">
    <cfproperty  name="wbp_code" type="string">
    <cfproperty  name="schema_type" type="string">
    <cfproperty  name="wbp_type" type="string">
    <cfproperty  name="object_type" type="string">
    <cfproperty  name="our_company_ids" type="string">

    <cfset wbpPath = '#ReplaceNoCase(Replace(GetDirectoryFromPath(GetBaseTemplatePath()),'\','/','ALL'),"V16/settings/cfc/","")#WBP' />

    <cffunction name="init" access="public">
        <cfargument  name="data" type="struct">

        <cfset setDatasource( application.systemParam.systemParam().dsn ) />
        
        <cfif isDefined("arguments.data.wbp_name") and len( arguments.data.wbp_name )><cfset setWbp_name( arguments.data.wbp_name ) /></cfif>
        <cfif isDefined("arguments.data.wbp_code") and len( arguments.data.wbp_code )><cfset setWbp_code( arguments.data.wbp_code ) /></cfif>
        <cfif isDefined("arguments.data.schema_type") and len( arguments.data.schema_type )><cfset setSchema_type( arguments.data.schema_type ) /></cfif>
        <cfif isDefined("arguments.data.wbp_type") and len( arguments.data.wbp_type )><cfset setWBP_type( arguments.data.wbp_type ) /></cfif>
        <cfif isDefined("arguments.data.object_type") and len( arguments.data.object_type )><cfset setObject_type( arguments.data.object_type ) /></cfif>
        <cfif isDefined("arguments.data.our_company_ids") and len( arguments.data.our_company_ids )><cfset setOur_company_ids( arguments.data.our_company_ids ) /></cfif>

        <cfreturn this>

    </cffunction>

    <cffunction  name="controlWBPLicense" returnType = "any" returnformat="JSON" access = "remote" hint = "WBP License Control">
        <cfargument  name="company_id" required="true">
        <cfargument  name="wbp_p_code" required="true">

        <cfset this.init() />

        <cfset response = structNew() />

        <cfscript>
            get_license_information = this.get_license_information();
            if( len(get_license_information.PROD) ){
                license_prod = arrayFilter(deserializeJSON( get_license_information.PROD ), function( el ){ return el.manufact_code eq wbp_p_code; })[1]?:'';
                
                if( isStruct(license_prod) ){ //Satın alınmış
                    companyQuery = new Query(datasource=getDatasource(), sql="
                            SELECT OC.COMP_ID 
                            FROM OUR_COMPANY AS OC 
                            JOIN OUR_COMPANY_INFO AS OCI ON OC.COMP_ID = OCI.COMP_ID
                            WHERE 
                                OC.COMP_STATUS = 1 
                                AND OC.COMP_ID = #arguments.company_id# 
                                AND '#arguments.wbp_p_code#' IN (SELECT * FROM #getDatasource()#.fnSplit((OCI.PROD), ','))"
                    ).execute().getResult();
                    if( companyQuery.recordcount ){//Şirkete yüklenmiş
                        response = {
                            subscription_status: true,
                            company_status: true
                        };
                    }else{//Şirkete yüklenmemiş
                        response = {
                            subscription_status: true,
                            company_status: false
                        };
                    }
                }else{//Satın alınmamış
                    response = {
                        subscription_status: false,
                        company_status: false
                    };
                }

            }else{
                response = {
                    subscription_status: false,
                    company_status: false
                };
            }
        </cfscript>

        <cfreturn response />

    </cffunction>

    <cffunction name = "createObject" returnType = "any" returnformat="JSON" access = "remote" hint = "Create WBP Objects">
        
        <cfsetting requesttimeout="1000">
        <cfset this.init(arguments) />
        <cfreturn this.execute_script_buffer_objects() />

    </cffunction>

    <cffunction name = "InstallDataLibrary" returnType = "any" returnformat="JSON" access = "remote" hint = "Install WBP Data Library">
        
        <cfsetting requesttimeout="1000">
        <cfset this.init(arguments) />
        <cfreturn this.execute_script_buffer() />

    </cffunction>

    <cffunction name = "complete_wbp_upload" returnType = "any" returnformat="JSON" access = "remote" hint = "Completed WBP Upload">
        
        <cfset this.init(arguments) />
        <cfset response = structNew() />

        <cftry>
            <cfquery name="updateOurCompanyInfo" datasource="#getDatasource()#">
                UPDATE OUR_COMPANY_INFO SET PROD = CONCAT(PROD, '#getWbp_code()#,') WHERE COMP_ID IN (#getOur_company_ids()#)
            </cfquery>
            <cfset response = {status: true} />
        <cfcatch type="any">
            <cfset response = {status: false} />
        </cfcatch>
        </cftry>

        <cfreturn replace( serializeJSON(response), '//', '' )>
    </cffunction>

    <cffunction name = "complete_imp_step" returnType = "any" access = "public" hint = "Completed WBP Implementation Step">
        
        <cfset wbpType = ['dictionary','extension','implementation_step','master_data','menu','module','output_template','page_designer','params','process_cat','process_stage','process_template','wex','widget','wo','xml_setup'] />

        <cftry>
            <cfquery name="updateImpStep" datasource="#getDatasource()#">
                UPDATE WRK_IMPLEMENTATION_STEP SET WRK_IMPLEMENTATION_TASK_COMPLETE = 1 WHERE WRK_IMPLEMENTATION_TYPE = #wbpType[arrayFind(wbpType, getwbp_type())] - 1#
            </cfquery>
            <cfreturn true />
        <cfcatch type="any">
            <cfreturn false />
        </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name = "getFileContent" returnType = "any" access = "remote" hint = "Get WBP File Content">
        
        <cfsetting requesttimeout="1000">
        <cfset this.init(arguments) />
        
        <cfscript>

            filePath =  len( getWBP_type() )
                        ? '#wbpPath#/#getWbp_name()#/install/#arguments.folder_type#/#getSchema_type()#/#getWBP_type()#/#getObject_type()#.txt'
                        : '#wbpPath#/#getWbp_name()#/install/#arguments.folder_type#/#getSchema_type()#/#getObject_type()#.txt';
            content = fileRead(filePath,'UTF-8');
			saveContent variable = "newContent" {
				WriteOutput(content);
			}

			if( arguments.type == "HTML" ){
				writeOutput( "<textarea id='content_" & arguments.folder_type & "_" & getObject_type() & "'>" & newContent & "</textarea>" );
				abort;
			}else{
				return newContent;
			}

        </cfscript>

    </cffunction>

    <cfscript>

        public any function executeSql( queryContent, datasource ) {
		
            try {
                transaction{
                    if( structCount( this.getConfig() ) ){//config ayarı olan wbp dosyaları satır satır çalıştırılır ve config dosyasındaki ayarlar uygulanır!
                        config = this.getConfig();
                        sqlLines = ListToArray(queryContent, Chr(13) & Chr(10))
                        if( ArrayLen( sqlLines ) ){
                            for( i = 1; i < ArrayLen( sqlLines ); i++ ){
                                if( len( sqlLines[i] ) ){

                                    runSql = new Query(datasource = datasource, sql = sqlLines[i]).execute().getPrefix();
                                    companies = listToArray( getOur_company_ids() );
                                    associateConfig = config.associate_config;

                                    bottomDatasource = associateConfig.datasource_type eq 'main' ? getDatasource() : '';

                                    if( len( bottomDatasource ) ){

                                        if( len( associateConfig.company_id_column ) ){
                                            for( var j = 1; j <= ArrayLen( companies ); j++ ){
                                                query = 'INSERT INTO #associateConfig.table_name#(#associateConfig.column_name#, #associateConfig.company_id_column#) VALUES(#runSql.identitycol#, #companies[j]#)';
                                                runAssociateSql = new Query(datasource = bottomDatasource, sql = query).execute().getResult();
                                            }
                                        }else{
                                            query = 'INSERT INTO #associateConfig.table_name#(#associateConfig.column_name#) VALUES(#runSql.identitycol#)';
                                            runAssociateSql = new Query(datasource = bottomDatasource, sql = query).execute().getResult();
                                        }

                                    }

                                }
                            }
                        }
                    }else runSql = new Query(datasource = datasource, sql = queryContent).execute().getResult();
                }
                return { status: true, errorMessage: "" };
            }
            catch(any exp) {
                return { status: false, errorMessage: exp };
            }
        }

        public any function getConfig() {
            response = StructNew();
            configPath = '#wbpPath#/#getWbp_name()#/config.json';
            if( FileExists( configPath ) ){
                configFile = fileRead( configPath, 'UTF-8' );
                if( len( configFile ) ){
                    config = deserializeJSON( configFile );
                    if( StructKeyExists( config, getObject_type() ) ) response = config[ getObject_type() ];
                }
            }
            return response;
        }
        
        public any function querySettings( queryContent ){

            queryContent = ReplaceNoCase( queryContent, "@_dsn_main_@", getDatasource(), "ALL" );
		    queryContent = ReplaceNoCase( queryContent, "@_dsn_product_@","#getDatasource()#_product", "ALL" );

            if( LCase( getSchema_type() ) eq 'main' || LCase( getSchema_type() ) eq 'product' ){

                datasource_name = (LCase( getSchema_type() ) eq 'main') ? getDatasource() : "#getDatasource()#_product";
                response = this.executeSql( queryContent, datasource_name );
                return response;

            }else{

                periodQuery = new Query(datasource=getDatasource(), sql="SELECT OUR_COMPANY_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID IN (#getOur_company_ids()#) ORDER BY PERIOD_YEAR,OUR_COMPANY_ID").execute().getResult();
			    companyQuery = new Query(datasource=getDatasource(), sql="SELECT DISTINCT OUR_COMPANY_ID FROM SETUP_PERIOD WHERE OUR_COMPANY_ID IN (#getOur_company_ids()#)").execute().getResult();

                if(LCase( getSchema_type() ) == 'period'){///period sorgularını çalıştırır
				
                    for(j = 1; j LTE periodQuery.recordcount; j++){

                        queryCont = queryContent;
                        datasource_name = '#getDatasource()#_#periodQuery.PERIOD_YEAR[j]#_#periodQuery.OUR_COMPANY_ID[j]#';
                        queryCont = ReplaceNoCase( queryCont, "@_dsn_period_@", "#getDatasource()#_#periodQuery.PERIOD_YEAR[j]#_#periodQuery.OUR_COMPANY_ID[j]#", "ALL" );
                        queryCont = ReplaceNoCase( queryCont, "@_dsn_company_@", "#getDatasource()#_#periodQuery.OUR_COMPANY_ID[j]#", "ALL" );
                        queryCont = ReplaceNoCase( queryCont, "@_companyid_@", "#periodQuery.OUR_COMPANY_ID[j]#", "ALL" );
                        response = this.executeSql( queryCont, datasource_name ); 
                        if( !response.status ) return response;

                    }
    
                }else{///company sorgularını çalıştırır
                    
                    for(j = 1; j LTE companyQuery.recordcount; j++){
                        
                        queryCont = queryContent;
                        datasource_name = '#getDatasource()#_#companyQuery.OUR_COMPANY_ID[j]#';
                        queryCont = ReplaceNoCase( queryCont, "@_dsn_company_@", "#getDatasource()#_#companyQuery.OUR_COMPANY_ID[j]#", "ALL" );
                        queryCont = ReplaceNoCase( queryCont, "@_companyid_@", "#companyQuery.OUR_COMPANY_ID[j]#", "ALL" );
                        response = this.executeSql( queryCont, datasource_name ); 
                        if( !response.status ) return response;

                    }

                }

            }

            return { status: true, errorMessage: "" }; 
            
        }

        public any function execute_script_buffer_objects() returnformat="JSON" {
            
            filePath = '#wbpPath#/#getWbp_name()#/install/db_objects/#getSchema_type()#/#getObject_type()#.txt';
            if( FileExists( filePath ) ){
                fileInfo = GetFileInfo( filePath );
                if( len(fileInfo.size) and fileInfo.size gt 0 ){
                    queryContent = fileRead( filePath, 'UTF-8' );
                    response = this.querySettings( queryContent );
                    return this.returnResult( status: response.status, errorMessage: response.errorMessage );
                }
            }else return this.returnResult( status: false, message: "There is no object file!" );

        }

        public any function execute_script_buffer() returnformat="JSON" {
            
            filePath = '#wbpPath#/#getWbp_name()#/install/data_library/#getSchema_type()#/#getwbp_type()#/#getObject_type()#.txt';
            if( FileExists( filePath ) ){
                fileInfo = GetFileInfo( filePath );
                if( len(fileInfo.size) and fileInfo.size gt 0 ){
                    queryContent = fileRead( filePath, 'UTF-8' );
                    response = this.querySettings( queryContent );
                    this.insert( response.status );
                    if( response.status ) this.complete_imp_step();
                    return this.returnResult( status: response.status, errorMessage: response.errorMessage ); 
                }
            }else return this.returnResult( status: false, message: "There is no data file!" );

        }

        public any function get( company_id ) {

            return new Query(datasource = getDatasource(), sql = "SELECT BPDL_ID FROM WRK_BESTPRACTICE_DATA_LIBRARY WHERE WBP_CODE = '#getWbp_code()#' AND COMPANY_ID = #company_id# AND BPDL_FILE = '#getSchema_type()#/#getwbp_type()#/#getObject_type()#.txt'").execute().getResult();

        }

        public any function insert( boolean status ) {
            
            companies = listToArray( getOur_company_ids() );

            for( var i = 1; i <= ArrayLen( companies ); i++ ){
                
                control = this.get( companies[i] );

                if( not control.recordcount ){
                    new Query(
                        datasource = getDatasource(),
                        sql = "
                            INSERT INTO WRK_BESTPRACTICE_DATA_LIBRARY(
                                WBP_CODE,
                                BPDL_NAME,
                                BPDL_SCHEMA,
                                BPDL_TYPE,
                                BPDL_FILE,
                                BPDL_STATUS,
                                COMPANY_ID,
                                RECORD_DATE,
                                RECORD_EMP,
                                RECORD_IP
                            )
                            VALUES(
                                '#getWbp_code()#',
                                '#replace(listFirst(getObject_type(),'.'),'_',' ','all')#',
                                '#getSchema_type()#',
                                '#getwbp_type()#',
                                '#getSchema_type()#/#getwbp_type()#/#getObject_type()#.txt',
                                #status?1:0#,
                                #companies[i]#,
                                #now()#,
                                #session.ep.userid#,
                                '#cgi.REMOTE_ADDR#'
                            )
                        "
                    ).execute();
                }else{
                    new Query(
                        datasource = getDatasource(),
                        sql = "
                            UPDATE WRK_BESTPRACTICE_DATA_LIBRARY
                            SET BPDL_STATUS = #status?1:0#
                            WHERE BPDL_ID = #control.BPDL_ID[1]#
                        "
                    ).execute();
                }
            }

        }
        
        public any function returnResult( boolean status, string message = "", any errorMessage = "" ) returnformat = "JSON" {
            response = structNew();
            response = {
                status: status,
                message: message,
                errorMessage: errorMessage
            };

            return Replace(SerializeJSON(response),"//","");
        }
    
    </cfscript>

</cfcomponent>