<cfset CfrootDir = Server.ColdFusion.RootDir>
<cfset libPath = "#index_folder#workcloud\lib">
<cfset libs = [
    [
        name    =   "barcode",
        lib     =   [
                        fullPath        =   "#index_folder#workcloud\lib\barcode",
                        moveDir         =   "#CfrootDir#\lib"
        ]   
    ],
    [
        name    =   "flash_remoting",
        lib     =   [
                        fullPath        =   "#index_folder#workcloud\lib\flash_remoting",
                        moveDir         =   "#CfrootDir#\wwwroot"
        ]   
    ],
    [
        name    =   "gateway_config",
        lib     =   [
                        fullPath        =   "#index_folder#workcloud\lib\gateway_config",
                        moveDir         =   "#CfrootDir#\wwwroot\WEB-INF"
        ]   
    ],
    [
        name    =   "uriworkermap",
        lib     =   [
                        fullPath        =   "#index_folder#workcloud\lib\uriworkermap",
                        moveDir         =   "#Replace(CfrootDir,"\cfusion","")#\config\wsconfig\1"
        ]   
    ]
]>
<style>
.resultArea{
    height: 255px;
    overflow: auto;
    margin-bottom: 20px;
}
</style>
<div class="col col-md-10 resultArea">
    <cfloop from = "1" to = "#ArrayLen(libs)#" index = "i">
        <cfif DirectoryExists("#libs[i]['lib']['fullPath']#")>
            
            <cfset fullPath =libs[i]['lib']['fullPath']>
            <cfset moveDir = libs[i]['lib']['moveDir']>
            
            <cfsavecontent variable = "execCommand">
                xcopy /E /I /Y <cfoutput>#fullPath#  #moveDir#</cfoutput>
            </cfsavecontent>
            <cftry>
                <cffile action = "write" file = "#libPath#\execCommand.bat" addnewline="yes" output = "#execCommand#" mode="777">
                <cfexecute name = '#libPath#\execCommand.bat' timeout="10"></cfexecute>
                <cffile action = "delete" file = "#libPath#\execCommand.bat">
            <cfcatch type = "any">
                There was a problem when uploading libraries!    
            </cfcatch>
            </cftry>
            
        <cfelse>
            <script>
                alert("<cfoutput>#libs[i]['lib']['fullPath']# (Directory not exist! Please upload libraries.)</cfoutput>");
            </script>
        </cfif>
    </cfloop>
</div>