<!---
Parametreler:
	-action			: işlem tipi ConvertToFlv veya CreateThumb.
	-inputfile		: dönüştürülecek video'nun fiziksel adresi
	-outputfile		: çıktı video'nun fiziksel adresi
	-debugmode		: true olduğunda daha ayrıntılı bilgi döner (bug var)
	-timeout		: milisaniye cinsinden maksimum işlem süresi. zaman aşımı olursa işlem kesilir. varsayılan değer 0'dır yani işlem tamamlanıncaya kadar beklenir.
	-returnvariable	: çıktının aktarılacağı değişken
--->
<cfparam name="attributes.action" type="string" default="ConvertToFlv" />
<cfparam name="attributes.inputfile" type="string" />
<cfscript>
function exec_cmd(cmd) { 
   var runtimeClass=""; 
   var out=""; 
   var isr="";
   var ins="";
   var br="";
   var output="";
    // Initialize the Java class. 
    runtimeClass=CreateObject("java", "java.lang.Runtime"); 
    // Execute command 
    out=runtimeClass.getRuntime().exec(cmd); 
    // Return the output 
   	out.waitFor(); 
   	
	ins = out.getInputStream();
	isr = CreateObject("java","java.io.InputStreamReader").init(ins);
	br = CreateObject("java","java.io.BufferedReader").init(isr);
	output = br.readLine();
	if (not isdefined("output")) {
		output = "";
	}
	br.close();
	isr.close();
	ins.close();
       /*while (line neq "") {
         output = output & line;
		 line = br.readLine();
       }*/
	return output;
   // return out.getInputStream().read(); 
}  
</cfscript>
<cfset cmd = "" />
<cfif attributes.action neq "InjectMetaData">
	<cfset cmd = cmd & expandPath('/COM_MX/tools/') & "MediaToolkitConsole2.exe" />
    <cfset cmd = cmd & " -a " & attributes.action />
    <cfset cmd = cmd & " -i " & attributes.inputfile />
    <cfif isDefined("attributes.debugmode") and attributes.debugmode eq true>
        <cfset cmd = cmd & " -d" />
    </cfif>
    <cfif isDefined("attributes.timeout")>
        <cfset cmd = cmd & " -t " & attributes.timeout />
    </cfif>
    <cfif isDefined("attributes.outputfile")>
        <cfset cmd = cmd & " -o " & attributes.outputfile />
    </cfif>
<cfelse>
	<cfset cmd = cmd & expandPath('/COM_MX/tools/') & "flvmdi.exe" />
    <cfset cmd = cmd & " " & attributes.inputfile & " /k /l" />
</cfif>
<cfif isdefined("attributes.returnvariable")>
	<cfset caller[attributes.returnvariable] = exec_cmd(cmd) />
<cfelse>
	<cfset exec_cmd(cmd) />
</cfif>
