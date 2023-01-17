
<!----<cfquery name="release_number" datasource="#dsn#">
    SELECT RELEASE_NO FROM LICENSE
</cfquery>
<cfset release_no = "#release_number.release_no#">----->
<cfparam name="release_no" default="">
<cfif not len(release_no)>
    <cfset release_no = DateFormat(now(), "d.m.yy")>
</cfif>
<cfscript>
	wroController = createObject("component","V16/settings/cfc/wroControl");
	readFile = wroController.execute_script(file_name,file_id);
   
    file_id_list = file_id.Split(';');
    total_file = ArrayLen(file_id_list);
</cfscript>
<cfoutput>
    <cfif readFile eq 1 or readFile eq 2>
        <div class="column">
            <div class="col col-12">
                <div class="col col-4">
                    <h4>Toplam Çalıştırılacak Dosya Sayısı</h4>
                </div>
                <div class="col col-4" style="color : red">
                    <h4>#total_file#</h4>
                </div>   
            </div>
            <div class="col col-12 mb-3">
                <div class="col col-4">
                    <h4 >Tamamlanan Dosya Sayısı</h4>
                </div>
                <div class="col col-4" style="color : green">
                <h4 id="succes_file"></h4>
                </div> 
            </div>
            <div class="col col-12 mb-3">
                <div class="col col-4">
                    <h4 >Tamamlanamayan Dosya Sayısı</h4>
                </div>
                <div class="col col-4" style="color : green">
                <h4 id="fail"></h4>
                </div> 
            </div>
            <hr class="mb-3">
            <div class="col col-12 mb-1">
                <div class="col col-6">
                    <h4 id="file_name" ></h4>
                </div>  
                <div class="col col-6">
                    <h4 id="fail_file_name" ></h4>
                </div>           
            </div>
            <div class="col col-12  mb-1">   
                <div class="col col-12">        
                    <h4 id="description"></h4>
                </div>
            </div>
            <div class="col col-12 mb-3">   
                <div class="col col-12">        
                    <h4 id="developer"></h4>
                </div>
            </div>
            <div class="col col-12 mb-3">   
                <div class="col col-12">        
                    <h4 id="error_cause"></h4>
                </div>
            </div>
        </div>
    <cfelse>
       <cfoutput><b><h4>#getLang('account',207)#</h4></b></cfoutput>
    </cfif>
</cfoutput>