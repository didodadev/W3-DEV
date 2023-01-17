<cfscript>
	main_account_code_list = attributes.acc_code;
	main_account_code_list = ListDeleteDuplicatesNoCase(main_account_code_list);
	main_account_code_list_wrk = main_account_code_list;
	
	m_list = ListChangeDelims(main_account_code_list_wrk, "','", ",");
	int_acc = ListLen(main_account_code_list,",");
	
	m_list = "'#m_list#'";
	get_record_account_all = cfquery(datasource : "#dsn2#", sqlstring : "SELECT ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE IN (#PreserveSingleQuotes(m_list)#)");
	
	if(int_acc neq get_record_account_all.recordcount)
	{
	  farklar = "";
	  List1 = valuelist(get_record_account_all.account_code);	
	  for ( i = 1 ; i lte ListLen(main_account_code_list, ","); i = i + 1) {
		if (not ListFindNoCase(List1, ListGetAt(main_account_code_list, i, ","),",")){
			farklar = ListAppend(farklar, ListGetAt(main_account_code_list, i, ","), ",");
		}
	  }
	}
	kontrol1 = cfquery(datasource : "#dsn2#", sqlstring : "SELECT SUB_ACCOUNT, ACCOUNT_CODE FROM ACCOUNT_PLAN WHERE SUB_ACCOUNT = 1 AND ACCOUNT_CODE IN (#PreserveSingleQuotes(m_list)#)");
	sub_farklar = valuelist(kontrol1.account_code, ",");
</cfscript>
<cfif int_acc neq get_record_account_all.recordcount>
		<script type="text/javascript">
			alert("<cfoutput>#farklar#</cfoutput> \n <cf_get_lang no ='243.Muhasebe Hesapları İçinde Kayıtlı olmayan Hesap Kodları Bulunmaktadır'> !");
			history.back();	
		</script>
	<cfabort>
</cfif>
<cfif kontrol1.recordcount>
		<script type="text/javascript">
			alert("<cfoutput>#sub_farklar#</cfoutput><cf_get_lang no ='244.Hesapları Üst Hesap Olduğundan İşlem Yapılamaz' > !");
			history.back();
		</script>
	<cfabort>
</cfif>
