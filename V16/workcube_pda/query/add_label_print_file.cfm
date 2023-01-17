<cfscript>
	CRLF=chr(13)&chr(10);
	barcode_list = ArrayNew(1);
	for(row_i=1;row_i lte attributes.row_count;row_i=row_i+1)
		if (evaluate('attributes.row_kontrol#row_i#'))
			ArrayAppend(barcode_list,"#evaluate('attributes.barcode#row_i#')#;#evaluate('attributes.amount#row_i#')#");
	file_name = '#session.pda.name#_#session.pda.surname#_#dateformat(now(),"yyyymmdd")##timeformat(now(),"HHmm")#';
</cfscript>
<cffile action="write" output="#ArrayToList(barcode_list,CRLF)#" file="#upload_folder#pda#dir_seperator#label_print#dir_seperator##file_name#.txt" addnewline="yes" charset="iso-8859-9">
<script type="text/javascript">
	alert('Etiket dosyanız başarıyla oluşturulmuştur !');
	window.location.href = '<cfoutput>#request.self#?fuseaction=pda.form_add_label_print_file</cfoutput>';
</script>
