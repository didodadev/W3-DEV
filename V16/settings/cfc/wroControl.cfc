<cfcomponent displayname="WROControl">
	<cfset cmp = createObject("component","cfc/queryJSONConverter")>

	<cfset download_folder = application.systemParam.systemParam().download_folder>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#application.systemParam.systemParam().dsn#_product'>

	<cfparam name="release_no" default="">
	<cfif not len(release_no)>
		<cfset release_no = DateFormat(now(), 'd.m.y')>
	</cfif>
	
<cfscript>

	private any function executeSql( queryContent, datasource ) {
		
		//try {
			transaction{
				runSql = new Query(datasource = datasource, sql = queryContent).execute().getResult();
			}
		/*	
		}
		catch(any a) {}*/

		return;
	}
	public any function querySettings( destination, queryContent ){
		
		/*
		@_dsn_main_@ : dsn 
		@_dsn_product_@ : dsn1 
		@_dsn_period_@ : sistemdeki tüm periyotlar
		@_dsn_company_@ : sistemdeki tüm şirketler ile değiştirir
		
		upd: 03/10/2019 - Uğur Hamurpet
		*/

		year = dateformat(session.ep.PERIOD_DATE, 'yyyy');
		queryContent = ReplaceNoCase( queryContent, "@_dsn_main_@", dsn, "ALL" );
		queryContent = ReplaceNoCase( queryContent, "@_dsn_product_@",dsn1, "ALL" );

		if(destination eq 'MAIN' || destination eq 'PRODUCT'){
			
			datasource = ( destination == 'MAIN' ) ? dsn : dsn1;
			executeSql( queryContent,datasource  );

		}else{
			
			periodQuery = new Query(datasource=dsn, sql="SELECT OUR_COMPANY_ID,PERIOD_YEAR FROM SETUP_PERIOD ORDER BY PERIOD_YEAR,OUR_COMPANY_ID").execute().getResult();
			companyQuery = new Query(datasource=dsn, sql="SELECT DISTINCT OUR_COMPANY_ID FROM SETUP_PERIOD").execute().getResult();

			if(destination == 'PERIOD'){///period sorgularını çalıştırır
				
				for(j = 1; j LTE periodQuery.recordcount; j++){

					queryCont = queryContent;
					datasource = '#dsn#_#periodQuery.PERIOD_YEAR[j]#_#periodQuery.OUR_COMPANY_ID[j]#';
					queryCont = ReplaceNoCase( queryCont, "@_dsn_period_@", "#dsn#_#periodQuery.PERIOD_YEAR[j]#_#periodQuery.OUR_COMPANY_ID[j]#", "ALL" );
					queryCont = ReplaceNoCase( queryCont, "@_dsn_company_@", "#dsn#_#periodQuery.OUR_COMPANY_ID[j]#", "ALL" );
					queryCont = ReplaceNoCase( queryCont, "@_companyid_@", "#periodQuery.OUR_COMPANY_ID[j]#", "ALL" );
					queryCont = ReplaceNoCase( queryCont, "@_periodid_@", "1", "ALL" );
					//query sorunlarını algılamak için açılabilir
					//writeOutput(queryCont & "<br><br><br><hr>");
					executeSql( queryCont,datasource  );
					
				}

			}else{///company sorgularını çalıştırır
				
				for(j = 1; j LTE companyQuery.recordcount; j++){

					queryCont = queryContent;
					datasource = '#dsn#_#companyQuery.OUR_COMPANY_ID[j]#';
					queryCont = ReplaceNoCase( queryCont, "@_dsn_company_@", "#dsn#_#companyQuery.OUR_COMPANY_ID[j]#", "ALL" );
					queryCont = ReplaceNoCase( queryCont, "@_companyid_@", "#companyQuery.OUR_COMPANY_ID[j]#", "ALL" );

					//query sorunlarını algılamak için açılabilir
					//writeOutput(queryCont & "<br><br><br><hr>");
					executeSql( queryCont, datasource );

				}
			}
		}
	}
	remote any function readFilePath(string release_date,string new_release_date) {
		try{
			
			dirQuery = directoryList( "#download_folder#WRO", false, "query", "", "datelastmodified" );
			for(i=1; i LTE dirQuery.RecordCount; i++){
				if(len(dirQuery.size[i]) and LCase(dirQuery.type[i]) eq 'file'){
					mydate = listgetat(dirQuery.name[i],1,'_');
					mytime = isnumeric( listgetat(dirQuery.name[i],2,'_') ) ? listgetat(dirQuery.name[i],2,'_') : 0;
					fileDate = len( mydate ) eq 8
								? createdatetime(Mid(mydate, 5, 4),Mid(mydate, 3, 2),Mid(mydate, 1, 2),mytime,0,0)
								: createdatetime(Mid(mydate, 5, 2),Mid(mydate, 3, 2),Mid(mydate, 1, 2),mytime,0,0);

					if((datecompare(fileDate,createodbcdatetime(release_date)) neq -1) and (datecompare(fileDate,createodbcdatetime(new_release_date)) neq 1)){ // file date >= old release date, file date <= new release date
						
						developer = developerCompany = description = destination = "";
						content = fileRead('#download_folder#WRO/#dirQuery.name[i]#','UTF-8');
						file_name ="#download_folder#WRO/#dirQuery.name[i]#";
						listLine = ListToArray(content,Chr(13)&Chr(10));
						
						for(line in listLine){
							
							if((FindNoCase("Description",line) NEQ 0) or (FindNoCase("Company",line) NEQ 0)  or (FindNoCase("Developer",line) NEQ 0) or (FindNoCase("Destination",line) NEQ 0) or (FindNoCase("<querytag>",line) NEQ 0) or (FindNoCase("</querytag>",line) NEQ 0)){
								
								line = Replace(line, "'", "","ALL");
								line = Replace(Replace(Replace(line, ";", "","ALL"),"<!---","","All"),"--->","","All");
								line = Replace(Replace(Replace(line, "=", "","ALL"),"<!--","","All"),"-->","","All");
								if( find( ':', line ) and listLen( line, ':' ) ){
									if( LCase(trim( listFirst( line, ':' ) )) == 'description' and not len( description ) ) description = trim( listLast( line, ':' ) );
									if( LCase(trim( listFirst( line, ':' ) )) == 'company' and not len( developerCompany ) ) developerCompany = trim( listLast( line, ':' ) );
									if( LCase(trim( listFirst( line, ':' ) )) == 'developer' and not len( developer ) ) developer = trim( listLast( line, ':' ) );
									if( LCase(trim( listFirst( line, ':' ) )) == 'destination' and not len( destination ) ) destination = trim( listLast( line, ':' ) );
								}
								line = Replace(line, ":", "","ALL");								
							}

						}

						if( len( destination ) and len( developer ) and len( developerCompany ) and len( description ) ){
							result = addtoTable( description,developer,developerCompany,destination,fileDate,release_date,file_name );
						}
					}
				}
			}
		
		}catch(any e){ returnval = 0; } 
		
	}
	remote boolean  function addtoTable(string description,string developer,string developerCompany,string destination,string lastUpdate, string release_date, string file_name){
		
		try{

			controlDbUpgradeScript = new Query(datasource = dsn, sql = "SELECT RELEASE_NUMBER,FILE_NAME FROM WRK_DBUPGRADE_SCRIPTS WHERE FILE_NAME LIKE '%#GetFileFromPath(file_name)#%'").execute().getResult();
			if( !controlDbUpgradeScript.recordcount ){

				addDbUpgradeScript = new query();
				addDbUpgradeScript.setDatasource( dsn );
				addDbUpgradeScript.execute(sql="
					INSERT INTO WRK_DBUPGRADE_SCRIPTS
					(
						RELEASE_NUMBER,
						DESCRIPTION,
						DEVELOPER,
						DEVELOPER_COMPANY,
						IS_UPGRADE_WORK,
						DESTINATION,
						LAST_UPDATE,
						UPGRADE_EMP_ID,
						UPGRADE_EMP_IP,
						UPGRADE_DATE,
						FILE_NAME

					)
					VALUES
					(
						'#release_no#',
						'#description#',
						'#developer#',
						'#developerCompany#',
						0,
						'#Lcase(destination)#',
						#lastUpdate#,
						#session.ep.userid#,
						'#cgi.REMOTE_ADDR#',
						#now()#,
						'#file_name#'
					
					)
				");

			}else{

				updDbUpgradeScript = new query();
				updDbUpgradeScript.setDatasource( dsn );
				updDbUpgradeScript.execute(sql="
					UPDATE WRK_DBUPGRADE_SCRIPTS SET
						RELEASE_NUMBER = '#release_no#',
						DESCRIPTION = '#description#',
						DEVELOPER = '#developer#',
						DEVELOPER_COMPANY = '#developerCompany#',
						DESTINATION = '#Lcase(destination)#',
						LAST_UPDATE = #lastUpdate#,
						UPGRADE_EMP_ID = #session.ep.userid#,
						UPGRADE_EMP_IP = '#cgi.REMOTE_ADDR#',
						UPGRADE_DATE = #now()#,
						FILE_NAME = '#file_name#'
					WHERE FILE_NAME LIKE '%#GetFileFromPath(file_name)#%'
				");
			}

			return true;

		}catch(any e){ return false; }

	}
	remote any function getTable(string is_work = "", string release_date = "", string new_release_date = "", numeric fileid){
		sorgu = new query();
		sorgu.setDatasource(dsn);
		query = "SELECT
				DBUPGRADE_SCRIPT_ID,
				RELEASE_NUMBER,
				DESCRIPTION, 
				DEVELOPER, 
				DEVELOPER_COMPANY,
				IS_UPGRADE_WORK,
				UPGRADE_EMP_ID,
				UPGRADE_DATE,
				LAST_UPDATE,
				DESTINATION,
				FILE_NAME 
			FROM 
				WRK_DBUPGRADE_SCRIPTS
			WHERE 1=1";
		if(isdefined("is_work") and len(is_work)) query &= " AND IS_UPGRADE_WORK = " & is_work;
		if(isdefined("release_date") and len(release_date) and isdefined("new_release_date") and len(new_release_date)) query &= " AND LAST_UPDATE >= " & createodbcdatetime(release_date) & " AND LAST_UPDATE <= " & createodbcdatetime(new_release_date);
		if( IsDefined("fileid") ) query &= " AND DBUPGRADE_SCRIPT_ID = " & fileid;
		query = query & " ORDER BY LAST_UPDATE ASC";
		returnval = sorgu.execute(sql=query).getResult();
		return returnval;
	}
	remote any function getFileContent( string is_work = "", string release_date = "", string new_release_date = "", numeric fileid, string type = "HTML" ) {
		
		wro = this.getTable(
				is_work : is_work, 
				release_date : release_date,
				new_release_date : new_release_date,
				fileid : fileid
			);

		if( wro.recordcount ){

			content = fileRead('#ReplaceNoCase(Replace(GetDirectoryFromPath(GetBaseTemplatePath()), "\", "/","ALL") ,"V16/settings/cfc","")#WRO/#GetFileFromPath(wro.FILE_NAME)#','UTF-8');
			saveContent variable = "newContent" {
				WriteOutput(content);
			}

			if( type == "HTML" ){
				
				writeOutput( "<textarea id='content_" & fileid & "'>" & newContent & "</textarea>" );
				abort;
			
			}else{
				return newContent;
			}
		}

	}
	remote any function execute_script_buffer( numeric fileid ) returnformat="JSON" {
		
		if( len( fileid ) ){

			wroList = this.getTable( is_work : 0, fileid : fileid );
			if( wroList.recordcount ){
				
				if( FileExists( '#ReplaceNoCase(Replace(GetDirectoryFromPath(GetBaseTemplatePath()), "\", "/","ALL"),"V16/settings/cfc","")#WRO/#GetFileFromPath(wroList.FILE_NAME)#' ) ){

					content = fileRead('#ReplaceNoCase(Replace(GetDirectoryFromPath(GetBaseTemplatePath()), "\", "/","ALL"),"V16/settings/cfc","")#WRO/#GetFileFromPath(wroList.FILE_NAME)#','UTF-8');
					listLine = ListToArray(content,Chr(13)&Chr(10));
					destination = "";
					forbidden = false;
					
					for(line in listLine){
						if(FindNoCase("Destination",line) NEQ 0){
							line = Replace(line, "'", "","ALL");
							line = Replace(Replace(Replace(line, ";", "","ALL"),"<!---","","All"),"--->","","All");
							line = Replace(Replace(Replace(line, "=", "","ALL"),"<!--","","All"),"-->","","All");
							if( LCase(trim( listFirst( line, ':' ) )) == 'destination' and not len( destination ) ) destination = UCase(trim( listLast( line, ':' ) ));
							line = Replace(line, ":", "","ALL");
						}
					}
					
					if(find('<querytag>',content) and find('</querytag>',content)){
						
						queryStart = find('<querytag>',content) + 10;
						queryFinish = find('</querytag>',content);
						queryContent = mid(content,queryStart,(queryFinish - queryStart));
						lineQuerytag = ListToArray( queryContent, Chr(13) & Chr(10) );

						for(linequery in lineQuerytag){
							if((FindNoCase('drop table',linequery) neq 0) or ((FindNoCase("delete from",linequery) eq 1) and (FindNoCase("where",linequery) eq 0)) or (FindNoCase("truncate table",linequery) neq 0)){
								
								return this.returnResult(
									status: false,
									fileid: wroList.DBUPGRADE_SCRIPT_ID,
									fullFileName: wroList.FILE_NAME,
									message: application.functions.getLang('assetcare',616)
								);
								forbidden = true;			
								break;

							}
						}
						
						if( !forbidden ){

							if(destination eq 'MAIN' || destination eq 'PRODUCT' || destination eq 'PERIOD' || destination eq 'COMPANY'){

								try{

									querySettings( destination, queryContent );
									runQuery = new Query(datasource = dsn, sql = "UPDATE WRK_DBUPGRADE_SCRIPTS SET IS_UPGRADE_WORK=1 WHERE DBUPGRADE_SCRIPT_ID = #fileid#").execute().getResult();
									return this.returnResult(
										status: true,
										fileid: wroList.DBUPGRADE_SCRIPT_ID,
										fullFileName: wroList.FILE_NAME
									);

								}catch(any e){
									
									return this.returnResult(
										status: false,
										fileid: wroList.DBUPGRADE_SCRIPT_ID,
										fullFileName: wroList.FILE_NAME,
										message: application.functions.getLang('','Sorgular daha önce çalıştırılmış olabilir',48457),
										errorMessage: ( IsDefined("e.sql") ) ? e : ""
									);

								}

							}else{
								
								return this.returnResult(
									status: false,
									fileid: wroList.DBUPGRADE_SCRIPT_ID,
									fullFileName: wroList.FILE_NAME,
									message: application.functions.getLang('assetcare',571)
								);

							}
						}

					}else{
						
						return this.returnResult(
							status: false,
							fileid: wroList.DBUPGRADE_SCRIPT_ID,
							fullFileName: wroList.FILE_NAME,
							message: application.functions.getLang('assetcare',613)
						);

					}

				}else{

					runQuery = new Query(datasource = dsn, sql = "UPDATE WRK_DBUPGRADE_SCRIPTS SET IS_UPGRADE_WORK=1 WHERE DBUPGRADE_SCRIPT_ID = #fileid#").execute().getResult();
					return this.returnResult(
						status: false,
						fileid: fileid,
						message: 'Çalıştırmak istediğiniz dosya silinmiş!'
					);
				}

			}else{
				return this.returnResult(
					status: false,
					fileid: fileid,
					message: application.functions.getLang('crm',637)
				);
			}

		}else{
			return this.returnResult(
				status: false,
				message: application.functions.getLang('crm',645)
			);
		}
		
	}
	public any function returnResult( boolean status, numeric fileid = 0, string fullFileName = "", string message = "", any errorMessage = "" ) returnformat = "JSON" {
		if(isStruct( errorMessage ) and structCount( errorMessage ) and isdefined("errorMessage.sql") and isdefined("errorMessage.queryError")) 
			this.sendEmail( sql: errorMessage.sql, queryError: errorMessage.queryError );
		response = structNew();
		response = {
			status: status,
			fileid: fileid,
			fullFileName: fullFileName,
			fileName: GetFileFromPath(fullFileName),
			message: message,
			errorMessage: errorMessage
		};

		return Replace(SerializeJSON(response),"//","");
	}
</cfscript>
<cffunction name="getWoLang" returntype="any" description="Webservise bağlanıp Wo ve Dil Güncellemelerini Alır" returnformat="JSON">
	<cfargument name="typeList" default=""><!--- Wo,Solution,Language vs --->
	<cfargument name="dateRangeValue" default="">
	<cfif len(typeList)>
		<cfif len(dateRangeValue) and dateRangeValue eq 1>
			<cfset release_date = dateformat(dateadd('d',-7, now()),'yyyy-mm-dd')>
		<cfelseif len(dateRangeValue) and dateRangeValue eq 2>
			<cfset release_date = dateformat(dateadd('m',-1, now()),'yyyy-mm-dd')>
		<cfelseif len(dateRangeValue) and dateRangeValue eq 3>
			<cfset release_date = dateformat(dateadd('m',-3, now()),'yyyy-mm-dd')>
		<cfelse>
			<cfset release_date = dateformat(dateadd('yyyy',-1, now()),'yyyy-mm-dd')>
		</cfif>
		<cfset return_value = structNew() />
		<cftry>
			<cfhttp url="https://dev.workcube.com/web_services/defaultUpgrade.cfc?method=#typeList#" result="response" charset="utf-8">
				<cfhttpparam name="start_date" type="formfield" value="#release_date#">
			</cfhttp>
			<cfset return_value = deserializeJSON(response.Filecontent)>
			<cfcatch type="any">
				<cfset return_value.STATUS = false>
			</cfcatch>
		</cftry>
		<cfreturn return_value>
	</cfif>
</cffunction>
<cffunction name="sendEmail" access="public">
	<cfargument name="sql">
	<cfargument name="queryError">
	<cfmail
		to="bugmail@workcube.com"
		from="#session.ep.company#<#session.ep.company_email#>"
		subject="<cfoutput>#application.functions.getLang('assetcare',554)#</cfoutput>"
		charset="UTF-8"
		>
		Sql : #arguments.sql#
		queryError : #arguments.queryError# 
	</cfmail>
</cffunction>
</cfcomponent>