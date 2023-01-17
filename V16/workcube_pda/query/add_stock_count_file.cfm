<cfset attributes.seperator_type = 59><!--- Noktali Virgul Chr --->
<!--- <cfset upload_folder = "#upload_folder#pda#dir_seperator#stock_count#dir_seperator#"> --->
<cfset upload_folder = "#upload_folder#store#dir_seperator#">
<cfscript>
	CRLF=chr(13)&chr(10);
	barcode_list = ArrayNew(1);
	for(row_i=1;row_i lte attributes.row_count;row_i=row_i+1)
		if (evaluate('attributes.row_kontrol#row_i#'))
			ArrayAppend(barcode_list,"#evaluate('attributes.barcode#row_i#')#;#evaluate('attributes.amount#row_i#')#");
</cfscript>
<!--- 
	file_name = '#Trim(ListLast(attributes.department_location,'-'))#_#session.pda.name#_#session.pda.surname#_#dateformat(now(),"yyyymmdd")##timeformat(now(),"HHmm")#';
	<cfset File_Name_New = ReplaceList(file_name,'ü,ğ,ı,ş,ç,ö,Ü,Ğ,İ,Ş,Ç,Ö,|, ','u,g,i,s,c,o,U,G,I,S,C,O,_,_')>
 --->
<cfset file_name = "#createUUID()#.txt">
<cffile action="write" output="#ArrayToList(barcode_list,CRLF)#" file="#upload_folder##file_name#" addnewline="yes" charset="iso-8859-9">
<cfdirectory directory="#upload_folder#" name="folder_info" sort="datelastmodified" filter="#file_name#">
<cfset file_name = folder_info.name>
<cfset file_size = folder_info.size>
<cfset form.store = attributes.department_location>
<cfset attributes.stock_identity_type = 1><!--- Tip Barkod --->
<cfinclude template="/objects/display/import_stock_count_display.cfm">

<script type="text/javascript">
	<cfif not isdefined('error_flag')>
		alert('Sayım dosyanız başarıyla oluşturulmuştur !');
	</cfif>
	window.location.href = '<cfoutput>#request.self#?fuseaction=pda.popup_welcome</cfoutput>';
</script>
