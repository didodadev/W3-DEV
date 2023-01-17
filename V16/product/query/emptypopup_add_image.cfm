<cfif isDefined("form.image_file") and (session.resim eq 3)>
	<cftry>
  		<cfset file_name = createUUID()>
  		<cffile action="UPLOAD" 
			destination="#upload_folder#product#dir_seperator#" 
			filefield="image_file"  
			nameconflict="MAKEUNIQUE" accept="image/*">
  		<cffile action="rename" source="#upload_folder#product#dir_seperator##cffile.serverfile#" destination="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
        <cfcatch type="any">
            <script type="text/javascript">
                alert("Lütfen imaj dosyası giriniz!");
                history.back();
            </script><cfabort>
		</cfcatch>
	</cftry>
	<!---Script dosyalarını engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>z
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder#product#dir_seperator##file_name#.#cffile.serverfileext#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>
  <cfset  session.imFile = #file_name#&"."&#cffile.serverfileext#>
  
  <cfif ( findnocase("gif","#CFFILE.SERVERFILE#",1) neq 0) and isDefined("rd")>
    	<cfscript>
			CFFILE.SERVERFILE = listgetat(CFFILE.SERVERFILE,1,".")&"."&"jpg";
			cffile.serverfileext = "jpg";
		</cfscript>
  </cfif>
  <cfset size = cffile.fileSize / 1024>
  <cfquery name="ADD_IMAGE" datasource="#dsn1#">
	INSERT INTO 
		PRODUCT_IMAGES
	(
		IS_INTERNET,
		PRODUCT_ID,
		PATH,
		PATH_SERVER_ID,
		DETAIL,
		IMAGE_SIZE,
		STOCK_ID,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP
	)
	VALUES
	(
		<cfif isdefined("attributes.is_internet")>1,<cfelse>0,</cfif>
		#FORM.PID#,
		'#file_name#.#cffile.serverfileext#',
		'#fusebox.server_machine#',
		'#FORM.DETAIL#',
		<cfif isdefined("attributes.size") and len(attributes.size)>#attributes.size#,<cfelse>NULL,</cfif>
		<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>',#attributes.stock_id#,'<cfelse>NULL</cfif>,
		#NOW()#,
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
		#session.ep.userid#,
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
		#session.pp.userid# ,
		</cfif>
		'#cgi.REMOTE_ADDR#'
	)
  </cfquery>
  <cfset session.resim = 4>
  <cfif not isDefined("rd")>
    <script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
  </cfif>  
</cfif>
 
<cfif isDefined("rd")>
  <cfinclude template="../display/rd.cfm">
</cfif>
