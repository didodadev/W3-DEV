
/**
*
* @file         workcloud\cfc\upgrade_workcube_woLang.cfc
* @author       Uğur Hamurpet<ugurhamurpet@workcube.com>
* @description  https://dev.workcube.com adresinden güncel solutions, family, object, module, widget ve dilleri alarak veritabanına yükler.
*
*/

component output="true" extends="parameter" displayname="get solution, family, object, module, widget, lang from web service" {

    this.serviceName = "";
    this.startrow = "";
    this.maxrows = "";

    public any function initialize( string serviceName, struct recordSettings ) {
        
        this.serviceName = serviceName;
        if( StructCount( recordSettings ) ){
            this.startrow = recordSettings.startrow;
            this.maxrows = recordSettings.maxrows;
        }

        return this;

    }
    
    public any function getWoLang() returnFormat="JSON" {
        
        try {
            httpReq = createObject("component", "http");
            httpReq.setMethod( "get" );
            httpReq.setCharset( "utf-8" );
            httpReq.setResult( "objGet" );
            httpReq.setUrl("https://dev.workcube.com/web_services/defaultUpgrade.cfc?method="& this.serviceName);
            httpReq.addParam( type="formfield", name="start_date", value="" );
            httpReq.addParam( type="formfield", name="finish_date", value="" );
            httpReq.addParam( type="formfield", name="is_addon", value="" );
            httpReq.addParam( type="formfield", name="startrow", value="#this.startrow#" );
            httpReq.addParam( type="formfield", name="maxrows", value="#this.maxrows#" );
            return httpReq.send().getPrefix().filecontent;
        } catch (any e) {
            return replace( serializeJson({ status: false, data: [] }), '//', '' );
        }

    }
    
    public any function executeSql( string functionName, struct func, struct recordSettings ) {
    
        getParameter = this.getParameter();

        this.initialize( functionName, recordSettings );
        getWoLang = DeserializeJson( this.getWoLang() );

        if( getWoLang.status ){
            
            transaction{

                for (i = 1; i <= ArrayLen(getWoLang.data); i++) {
                
                    sqlValues = sqlColumns = "";
                    j = 1;
                    queryService = new query( datasource : getParameter.dsn );
                    for( woLangKey in getWoLang.data[i] ){
                        if( woLangKey != func.identityColumn and UCase( woLangKey ) != 'ROWNUM' and UCase( woLangKey ) != 'QUERY_COUNT' ){
                            comma = ( StructCount( getWoLang.data[i] ) > j ) ? ', ' : '';
                            if( func.type == "add" ){
                                sqlColumns &= '#woLangKey#' & comma;
                                sqlValues &= ':#woLangKey#' & comma;
                            }else sqlValues &= ( woLangKey != func.whereColumn ) ? '#woLangKey# = :#woLangKey#' & comma : '';
                            if( woLangKey eq 'RECORD_DATE' or woLangKey eq 'UPDATE_DATE' ) queryService.addParam( name = "#woLangKey#", value = "#now()#", cfsqltype="cf_sql_date"); 
                            else queryService.addParam( name = "#woLangKey#", value = "#(getWoLang.data[i][woLangKey] eq 'YES' ? 1 : (getWoLang.data[i][woLangKey] eq 'NO' ? 0 : getWoLang.data[i][woLangKey]))#", null = "#not len(trim(getWoLang.data[i][woLangKey])) ? true : false#" );
                        }
                        j++;
                    }
                    if( func.type == "add" ) queryService.execute( sql = "IF NOT EXISTS( SELECT 'Y' FROM #func.tableName# WHERE #func.whereColumn# = '#getWoLang.data[i][func.whereColumn]#' ) BEGIN INSERT INTO #func.tableName#( " & sqlColumns & " ) VALUES( " & sqlValues & " ) END" );
                    else{
                        updaterSql = "UPDATE #func.tableName# SET " & sqlValues & " WHERE #func.whereColumn# = '#getWoLang.data[i][func.whereColumn]#'";
                        if( func.tableName eq "SETUP_LANGUAGE_TR" ) updaterSql &= " AND (IS_SPECIAL = 0  or IS_SPECIAL IS NULL)";
                        else if( func.tableName eq "WRK_OBJECTS" ) updaterSql &= " AND ADDOPTIONS_CONTROLLER_FILE_PATH IS NULL AND FILE_PATH NOT LIKE '%add_options%'";
                        queryService.execute( sql = updaterSql );
                    }

                }

            }

            if( StructCount( recordSettings ) ) return { status: true, mode: 'move', query_count: getWoLang.data[1]['QUERY_COUNT'] };
            else return { status: true, mode: 'finish' };
            
        }else return { status: true, mode: 'finish' };

    }
    
    remote any function runWoLang( string functionName, string recordSettings ) returnFormat =  "JSON" {
        
        response = StructNew();

        functions = {
            getNewLangs : { type: "add", tableName: "SETUP_LANGUAGE", whereColumn: "LANGUAGE_ID", identityColumn: "" },
            getNewLanguages : { type: "add", tableName: "SETUP_LANGUAGE_TR", whereColumn: "DICTIONARY_ID", identityColumn : "DICTIONARY_SET_ID" },
            getNewSolution : { type: "add", tableName: "WRK_SOLUTION", whereColumn: "WRK_SOLUTION_ID", identityColumn : "WRK_SOLUTION_ID" },
            getNewFamily : { type: "add", tableName: "WRK_FAMILY", whereColumn: "WRK_FAMILY_ID", identityColumn : "WRK_FAMILY_ID" },
            getNewModule : { type: "add", tableName: "WRK_MODULE", whereColumn: "MODULE_ID", identityColumn : "MODULE_ID" },
            getNewModules : { type: "add", tableName: "MODULES", whereColumn: "MODUL_NO", identityColumn : "" },
            getNewWO : { type: "add", tableName: "WRK_OBJECTS", whereColumn: "FULL_FUSEACTION", identityColumn : "WRK_OBJECTS_ID" },
            getNewWidget : { type: "add", tableName: "WRK_WIDGET", whereColumn: "WIDGETID", identityColumn : "WIDGETID" },
            getNewWEX : { type: "add", tableName: "WRK_WEX", whereColumn: "REST_NAME", identityColumn : "WEX_ID" },
            getNewOutputTemplates : { type: "add", tableName: "WRK_OUTPUT_TEMPLATES", whereColumn: "WRK_OUTPUT_TEMPLATE_ID", identityColumn : "WRK_OUTPUT_TEMPLATE_ID" },
            getNewProcessTemplates : { type: "add", tableName: "WRK_PROCESS_TEMPLATES", whereColumn: "WRK_PROCESS_TEMPLATE_ID", identityColumn : "WRK_PROCESS_TEMPLATE_ID" }
        };

        try{
            
            response = this.executeSql( functionName, functions[functionName], deserializeJson( recordSettings ) );

        }
        catch(any exp) {

            response.status = false;
            response.error = exp;

        }

        return LCase(Replace(SerializeJson(response),"//",""));

    }

}