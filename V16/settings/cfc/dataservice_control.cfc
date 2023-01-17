
/**
*
* @file         V16\settings\cfc\dataservice_control.cfc
* @author       Esma R. Uysal<esmauysal@workcube.com>
* @description  
* Data service olan Wex'leri alarak veritabanına yükler.
* Kullanım : runWexService Fonksiyonuna Functions'a Rest Name eklenir. 
type: 3 çeşit type vardır. Add, upd, change. Add tipinde whereColumn'a göre kontrol edilir. Yoksa eklenir. 
Upd tipinde verilen whereColumn'a göre update edilir. 
Change tipinde finishDateColumn ve startDateColumn'a göre varsa güncelleme yoksa ekleme yapar.
tableName: Eklenecek Tablo ismi yazılır.
whereColumn: Where şartına yazılacak kolon ismi yazılır.
identityColumn : Tablonun identiy kolonu yazılır.
whereColumnParamtype : where şaartı parametre tipi yazılır.

cfc\upgrade_workcube_woLang.cfc'sinden uyarlanmıştır.


*
*/
component output="true" displayname=""  {

    this.serviceName = "";
    this.start_date = "";
    this.finish_date = "";
    this.extra_param = "";

    public any function initialize( string serviceName, string start_date = "", string finish_date = "",string extra_param = "") {
        
        this.serviceName = serviceName;
        this.start_date = start_date;
        this.finish_date = finish_date;
        this.extra_param = extra_param;

        return this;

    }
    
    public any function getWexService() returnFormat="JSON" {
        
        httpReq = createObject("component", "http");
        httpReq.setMethod( "get" );
        httpReq.setCharset( "utf-8" );
        httpReq.setResult( "objGet" );
        if(this.serviceName eq 'watalogyCategories')
        {
            httpReq.setUrl("http://watalogy.workcube.com/wex.cfm/"&this.serviceName&"/control_"&this.serviceName);
            dsn = application.systemParam.systemParam().dsn&"_product";
        }
        else
            httpReq.setUrl("https://dev.workcube.com/wex.cfm/"&this.serviceName&"/control_"&this.serviceName);
        httpReq.addParam( type="formfield", name="start_date", value="#this.start_date#" );
        httpReq.addParam( type="formfield", name="finish_date", value="#this.finish_date#" );
        httpReq.addParam( type="formfield", name="extra_param", value="#this.extra_param#" );
        return httpReq.send().getPrefix().filecontent;

    }
    
    public any function executeSql( string functionName, start_date, finish_date, extra_param ) {
        
        dsn = application.systemParam.systemParam().dsn;
    
        transaction{
            
            this.initialize( functionName, start_date, finish_date, extra_param );

            getWexService = DeserializeJson( this.getWexService() );

            if( getWexService.status ){
                getWexService_data = DeserializeJson(getWexService.data);
                
                if(isdefined("getWexService.FUNCTIONS_PROPERTY.dsn"))
                    dsn = getWexService.FUNCTIONS_PROPERTY.dsn;
                    
                for (i = 1; i <= ArrayLen(getWexService_data); i++) {
                    
                    sqlValues = sqlColumns = "";
                    j = 1;
                    queryService = new query( datasource : dsn );
                    
                    for( serviceKey in getWexService_data[i] ){
                        
                        if( serviceKey != getWexService.functions_property.identityColumn ){
                            comma = (StructCount( getWexService_data[i] ) > j) ? ', ' : '';
                          
                            if( getWexService.functions_property.type == "add" or getWexService.functions_property.type == "change" ){
                                sqlColumns &= '#serviceKey#' & comma;
                                sqlValues &= ':#serviceKey#' & comma;
                            }
                            else sqlValues &= ( serviceKey != getWexService.functions_property.whereColumn ) ? '#serviceKey# = :#serviceKey#' & comma : '';
                            if( serviceKey eq 'RECORD_DATE' or serviceKey eq 'UPDATE_DATE' ) 
                            {
                                queryService.addParam( name = "#serviceKey#", value = "#now()#", cfsqltype="cf_sql_date"); 
                            }
                            else queryService.addParam( name = "#serviceKey#", value = "#ReplaceNoCase(ReplaceNoCase( getWexService_data[i][serviceKey], 'YES', 1 ), 'NO', 0 )#" );

                        }else if(StructCount( getWexService_data[i] ) == j){
                            sqlColumns = ListDeleteAt(sqlColumns, j);
                            sqlValues = ListDeleteAt(sqlValues, j);
                        }
                        j++;
                    }
                    if( getWexService.functions_property.type == "add" ) {
                        result = queryService.execute( sql = "IF NOT EXISTS( SELECT 'Y' FROM #dsn#.#getWexService.functions_property.tableName# WHERE #getWexService.functions_property.whereColumn# = :#getWexService.functions_property.whereColumn# ) 
                        BEGIN INSERT INTO #getWexService.functions_property.tableName#( " & sqlColumns & " ) 
                        VALUES( " & sqlValues & " ) 
                        END");
                         
                    }
                    else if( getWexService.functions_property.type == "change" ) {
                        column_finishdate = evaluate("getWexService_data[i].#getWexService.functions_property.finishDateColumn#");
                        column_startdate = evaluate("getWexService_data[i].#getWexService.functions_property.startDateColumn#");
                         
                        upd_list  = "";

                        for(list_ = 1; list_<= listlen(sqlColumns); list_++)
                        {
                             upd_list = listAppend(upd_list,'#listgetat(sqlColumns,list_)# = #listgetat(sqlValues,list_)#');
                        }
                        
                        queryService.execute( sql = "IF NOT EXISTS( SELECT 'Y' FROM #getWexService.functions_property.tableName# WHERE #getWexService.functions_property.finishDateColumn# = '#column_finishdate#' AND #getWexService.functions_property.startDateColumn# = '#column_startdate#') 
                        BEGIN 
                            INSERT INTO #getWexService.functions_property.tableName#( " & sqlColumns & " ) 
                        VALUES( " & sqlValues & " ) 
                        END
                        ELSE BEGIN
                            UPDATE #getWexService.functions_property.tableName# SET #upd_list# WHERE #getWexService.functions_property.finishDateColumn# = '#column_finishdate#' AND #getWexService.functions_property.startDateColumn# = '#column_startdate#'
                        END
                        " ); 
                    }
                    else if( getWexService.functions_property.type == "upd" ){
                        updaterSql = "UPDATE #getWexService.functions_property.tableName# SET " & sqlValues & " WHERE #getWexService.functions_property.whereColumn# = '#getWexService_data[i][getWexService.functions_property.whereColumn]#'";
                        queryService.execute( sql = updaterSql );
                        
                    }

                }

            }else {
                this.returnResult( 
                    status: false, 
                    dataservices_name: getWexService.DATASERVICES_NAME, 
                    message: "", 
                    errorMessage: getWexService.ERRORMESSAGE);
            }
          
        }

        return;
    }
    
    remote any function runWexService( string functionName, string start_date, string finish_date, string extra_param = "" ) returnFormat =  "JSON" {
        
        response = StructNew();
            
            if( find( ",", functionName ) ) 
                for (i = 1; i <= listLen( functionName ); i++) 
                    this.executeSql( listGetAt( functionName, i ), start_date, finish_date,extra_param );
            else 
                this.executeSql( functionName, start_date, finish_date, extra_param );
            
            this.returnResult( 
                status: true, 
                dataservices_name: functionName, 
                message: "", 
                errorMessage: "",
                data: ""
                );

       
          
        return LCase(Replace(SerializeJson(response),"//",""));

    }
    public any function returnResult( boolean status, string dataservices_name = "", string message = "", any errorMessage = "",string data="") returnformat = "JSON" {
        response = structNew();
        response = {
            status: status,
            dataservices_name: dataservices_name,
            message: message,
            errorMessage: errorMessage,
            data: data
        };

        writeOutput(Replace(SerializeJSON(response),"//",""));
        abort;
    }

}