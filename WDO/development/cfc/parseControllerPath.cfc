<cfcomponent displayname="parseControllerPath">
<cfscript>
	public string function Dosyaoku(string yol = ""){
		if (fileExists(application.systemParam.systemParam().download_folder&yol)) {
			content = fileRead(application.systemParam.systemParam().download_folder&yol,"utf-8");
			return content;	
		}
		return "";
	}
	public array function getOtherFilePath(string content){

		listLine = ListToArray(content,Chr(13)&Chr(10));

		items = [];

		for(line in listLine){

			search = FindNoCase("href",line);
			search2 = FindNoCase("onclick", line);
			if(search NEQ 0 or search2 NEQ 0){

				line = Replace(line, "'", "","ALL");
				line = Replace(line, ";", "","ALL");
				line = Replace(line, '"' , "","ALL");

				resultArray = ListToArray(line,Chr(93)&Chr(91));

				ArrayDeleteAt(resultArray, 1);
				ArrayDeleteAt(resultArray, 1);
				
				if (arrayLen(resultArray) lt 6) return items;

				if (arrayLen(resultArray) lt 6) return items;

				functionara = FindNoCase("buttonclick", resultArray[6]);

				if(functionara LT 1){
					
				
				onclickara = Find("windowopen", resultArray[6]);

				resultArray[6] = Right(resultArray[6], Len(resultArray[6])-2);
				if(onclickara NEQ 0){
					resultArray[6] = Right(resultArray[6], Len(resultArray[6])-12);
					resultArray[6] = Left(resultArray[6], Len(resultArray[6])-1);
				}		

				
				item = StructNew();
				item["type"] = resultArray[1] & "/"& resultArray[2] & "/" & resultArray[4] & "/" & resultArray[5];
				item["link"] = trim(Right(resultArray[6], Len(resultArray[6])- Find("=",resultArray[6])));
			//	item["controllerPath"] = 

				ArrayAppend(items, item);
				}

			}

		}

		return items;
	}


	public array function getEventPaths(string content){
		listLine = ListToArray(content,Chr(13)&Chr(10));

								
								items = [];	

								for(line in listLine){
									
									search = FindNoCase("Path", line);
									
									if(search NEQ 0){
									 	line = Replace(line, "'", "","ALL");
										line = Replace(line, ";", "","ALL");
										line = Replace(line, "=", "","ALL");
									    resultArray = ListToArray(line,Chr(93)&Chr(91));
										ArrayDeleteAt(resultArray, 1);
										ArrayDeleteAt(resultArray, 1);
										
										item = StructNew();
										item["eventName"] = resultArray[1];
										item["pathName"] = resultArray[2];
										path = trim(resultArray[3]);
										
									 	path = ReplaceNoCase(path, "v", "V", "ONE");
										

										item["path"] = path;

										ArrayAppend(items, item);

									}
										
								}
									
								 return items;
								
	}
	
	public query  function getPathFromDB(string link){

		action = ListToArray(link,'&' );
        fuseaction = action[1];
        sorgu = new query();
        sorgu.setDatasource(application.systemParam.systemParam().dsn);
        sorgu.setName("WorkDevPathQuery");

        queryresult = sorgu.execute(sql="
        SELECT 
        FILE_PATH,
        CASE WHEN ADDOPTIONS_CONTROLLER_FILE_PATH IS NOT NULL THEN ADDOPTIONS_CONTROLLER_FILE_PATH ELSE CONTROLLER_FILE_PATH END AS CONTROLLER_FILE_PATH
        FROM WRK_OBJECTS 
        WHERE FULL_FUSEACTION = '#fuseaction#'"); 

		queryresult = queryresult.getResult();
	
		return queryresult;
		//result["controllerPath"] = queryresult["CONTROLLER_FILE_PATH"];
		
	}
	
</cfscript>
</cfcomponent>


				