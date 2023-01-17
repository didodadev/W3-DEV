<cfinclude template="core.cfm">

<cfset initializeCache = initSCO(scoID: url.scoID)>

<html>
<head>
    <title></title>
    <script language="javascript">
        // Vars
        var flagFinished = false;
        var lastErrorCode = 0;
        var lastErrorString = "";
		var heartBeatInterval = 5 * 60 * 1000;	// 5 minutes
		var tmrHeartBeat;
        
        // Init SCO data
        <cfoutput>#initializeCache#</cfoutput>
		
        function LMSInitialize(dummyString) 
        {
			//alert("init");
			tmrHeartBeat = setInterval(heartBeat, heartBeatInterval);
            return "true";
        }
        
        function Initialize(dummyString)
        {
            return LMSInitialize(dummyString);
        }
        
        function LMSGetValue(varName) 
        {
			if (cache[varName] == null || cache[varName] == undefined) cache[varName] = "";
			if (varName.length >= 6 && varName.substr(varName.length - 6, 6) == ".entry") cache[varName] = (cache[varName] == "") ? "ab-initio": "resume";
			if (varName.indexOf(".score.min") != -1 && cache[varName] == "") cache[varName] = "0";
			if (varName.indexOf(".score.max") != -1 && cache[varName] == "") cache[varName] = "100";
			if (varName.indexOf(".score.raw") != -1 && cache[varName] == "") cache[varName] = "0";
			if (varName.indexOf(".score.scaled") != -1 && cache[varName] == "") cache[varName] = "0";
			if (varName.indexOf(".progress_measure") != -1 && cache[varName] == "") cache[varName] = "0";
			/*if (varName.indexOf(".completion_threshold") != -1 && cache[varName] == "") cache[varName] = "0";*/
			if (varName.indexOf("._count") != -1 && cache[varName] == "") cache[varName] = "0";
			//alert("get: " + varName + ": " + cache[varName]);
			
            return cache[varName];
        }
        
        function GetValue(varName)
        {
            return LMSGetValue(varName);
        }
        
        function LMSSetValue(varName, varValue) 
        {
			//alert("set: " + varName + "=" + varValue);
            cache[varName] = varValue;
           // LMSCommit("", varName, varValue);
            return "true";
        }
        
        function SetValue(varName, varValue)
        {
            return LMSSetValue(varName, varValue);
        }
        
        function LMSCommit(dummyString, varName, varValue) 
        {
			//alert("commit: " + varName + "=" + varValue);
            var req = createRequest();
            var d = new Date();
        
            req.open('POST','<cfoutput>#PAGE_COMMIT#</cfoutput>', false);
        
            var params = 'scoID=<cfoutput>#url.scoID#</cfoutput>&code=' + d.getTime();
            if (varName != null && varValue != null)
            {
                params += "&data[" + varName + "]=" + encodeURIComponent(varValue);
            } else {
                for (var i in cache)
                {
                    params += "&data[" + i + "]=" + encodeURIComponent(cache[i]);
                }
            }
            
            req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            req.setRequestHeader("Content-length", params.length);
            req.setRequestHeader("Connection", "close");
            
            req.send(params);
        
            if (req.status != 200) 
            {
                lastErrorCode = 1;
                alert(LMSGetErrorString(lastErrorCode));
                return "false";
            } else {				
                return "true";
            }
        }
        
        function Commit(dummyString)
        {
            return LMSCommit(dummyString);
        }
        
        function LMSFinish(dummyString) 
        {
			//alert("finish");
			
            if (flagFinished) return "true";
        
            LMSCommit("");
        
            var req = createRequest();
            var d = new Date();
    
            req.open('POST','<cfoutput>#PAGE_FINISH#</cfoutput>', false);
        
            var params = 'scoID=<cfoutput>#url.scoID#</cfoutput>&code=' + d.getTime();
            
            req.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            req.setRequestHeader("Content-length", params.length);
            req.setRequestHeader("Connection", "close");
            
            req.send(params);
        
            if (req.status != 200) 
            {
                lastErrorCode = 2;
                alert(LMSGetErrorString(lastErrorCode));
                return "false";
            }
        
            flagFinished = true;
			
			clearInterval(tmrHeartBeat);
            
            // Close the window if navigation request contains suspend or exit
			// Redirect if needed according to adl.nav.request
            if (cache["adl.nav.request"] != null && (cache["adl.nav.request"].indexOf("exit") != -1 || cache["adl.nav.request"].indexOf("suspend") != -1)) 
			{
				parent.window.close();
			} else if (cache["adl.nav.request"] != null && cache["adl.nav.request"].indexOf("jump") != -1) {
				parent.location.href = parent.window.location.href + "&jump=true";
			}
		
            return "true";
        }
        
        function Terminate(dummyString)
        {
			//alert("terminate");
            return LMSFinish(dummyString);
        }
        
        function LMSGetLastError() 
        {
            return lastErrorCode;
        }
        
        function GetLastError()
        {
            return LMSGetLastError();
        }
        
        function LMSGetDiagnostic(errorCode) 
        {
            return LMSGetErrorString(errorCode);
        }
        
        function GetDiagnostic(errorCode)
        {
            return LMSGetDiagnostic(errorCode);
        }
        
        function LMSGetErrorString(errorCode) 
        {
            var errStr;
            
            switch (errorCode)
            {
                case 1:
                    errStr = "Problem with AJAX Request in LMSCommit!";
                    break;
                case 2:
                    errStr = "Problem with AJAX Request in LMSFinish!";
                    break;
            }
            
            return errStr;
        }
        
        function GetErrorString(errorCode) 
        {
            return LMSGetErrorString(errorCode);
        }
        
        function createRequest() 
        {
            var request;
            
            try 
            {
                request = new XMLHttpRequest();
            } catch (tryIE) {
                try {
                  request = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (tryOlderIE) {
                    try 
                    {
                        request = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (failed) {
                        alert("Error creating XMLHttpRequest");
                    }
                }
            }
            
            return request;
        }
		
		function heartBeat()
		{
			return LMSCommit('', '<cfoutput>#PARAM_NAME_VERSION#</cfoutput>', cache['<cfoutput>#PARAM_NAME_VERSION#</cfoutput>']);
		}
    
    </script>
    
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>&nbsp;</body>
</html>
