<cfset uploaded_file = attributes.uploaded_file>
<cfset upload_folder = "#upload_folder#sales#dir_seperator#">
<cftry>
	<cffile action = "upload" 
		  fileField = "uploaded_file" 
		  destination = "#upload_folder#"
		  nameConflict = "MakeUnique"  
		  mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
	<!---Script dosyalarını engelle  02092010 FA-ND --->
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#">
		<script type="text/javascript">
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfset file_size = cffile.filesize>
	<cfset dosya_yolu = "#upload_folder##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="dosya">
	<cffile action="delete" file="#dosya_yolu#">
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !");
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
</cfscript>
<cfloop from="2" to="#line_count#" index="k">
	<cfset yer = k-1>
	<cfoutput>
		<input type="hidden" name="exp_product_code#yer#" id="exp_product_code#yer#" value="#ListGetAt(dosya[k],1,";")#">
		<input type="hidden" name="exp_amount#yer#" id="exp_amount#yer#" value="#ListGetAt(dosya[k],2,";")#">
	</cfoutput>
</cfloop>
<cfloop from="2" to="#line_count#" index="k">
	<script type="text/javascript">
		yer = <cfoutput>#k#</cfoutput>-1;
		if(eval('window.top.document.getElementById("product_code'+yer+'")') != undefined)
		{
			eval('window.top.document.getElementById("product_code'+yer+'")').value = eval("document.getElementById('exp_product_code"+yer+"')").value;
			eval('window.top.document.getElementById("amount'+yer+'")').value = eval("document.getElementById('exp_amount"+yer+"')").value;
		}
		else
		{
			window.top.addRow();
			window.top.document.getElementById('product_code'+yer).value = document.getElementById('exp_product_code'+yer).value;
			window.top.document.getElementById('amount'+yer).value = document.getElementById('exp_amount'+yer).value;
		}
	</script>	
</cfloop>
<script type="text/javascript">
	window.top.document.getElementById('excel_form1').style.display='none';
	window.top.document.getElementById('excel_form2').style.display='none';
	window.top.document.getElementById('excel_form3').style.display='';
	window.top.add_basket_exp.action='<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basket_row_expres';
	window.top.add_basket_exp.target='';
</script>

