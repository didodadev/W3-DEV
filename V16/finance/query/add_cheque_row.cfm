<cfquery name="ADD_STORE_NUMBER" datasource="#dsn#">
	UPDATE
		CHEQUE_PRINTS_ROWS
	SET
		DAILY_REPORT_ID = #attributes.store_report_id#,
		COMPANY_ID = #session.ep.company_id#,
		PERIOD_YEAR = #session.ep.period_year#
	WHERE
		CHEQUE_GIFT_ROW_ID = #attributes.cheque_gift_row_id#	
</cfquery>
<cfset cek_toplam_ = 0>
<cfquery name="GET_CHEQUE" datasource="#dsn#">
	SELECT
		CHEQUE_PRINTS.MONEY
	FROM
		CHEQUE_PRINTS,
		CHEQUE_PRINTS_ROWS
	WHERE
		CHEQUE_PRINTS.CHEQUE_ID = CHEQUE_PRINTS_ROWS.CHEQUE_PRINT_ID AND
		CHEQUE_PRINTS_ROWS.DAILY_REPORT_ID = #attributes.store_report_id# 
</cfquery>
<cfquery name="GET_DEVREDEN" datasource="#dsn2#">
	SELECT DEVREDEN FROM STORE_REPORT WHERE STORE_REPORT_ID = #attributes.store_report_id#
</cfquery>
<cfloop query="get_cheque">
	<cfset cek_toplam_ = cek_toplam_ + money * (1/1000000)>
</cfloop>
<script type="text/javascript">
	function filterNum(str) 
	{
	if (str.length == 0) return '';
	re = /,/g;
	strCheck = '0123456789,'; /*izin verilen karakterler*/
	newStr = '';
	/* sadece izin verilenler bırakılır*/
	for(i=0; i < str.length; i++) if (strCheck.indexOf(str.charAt(i)) != -1) newStr += str.charAt(i);
	/*virgül yerine nokta konur*/
	return newStr.replace(re, '.');
	}	
	
	function commaSplit(str) 
	{
	negatif = 0;
	if(parseFloat(str) < 0)
		negatif = 1;
	milSep = '.'; /*binlik ayracı*/
	perSep = ','; /* kuruş ayracı*/
	aux = filterNum(str);
	len = aux.length;
	if (len <= 3) return str; /*önceden return aux idi A.Selam. 20040128*/
	textFormat='';
	t=0;
	temp_virgul = 0;
	if (len > 3) 
		{
		/* virgülden sonraki sadece 2 hane bırakılır*/
		temp_virgul = aux.indexOf(milSep);
		if ( (temp_virgul > 0) && ( (aux.length-1) > (temp_virgul + 2) ) )
			aux = aux.substr(0,temp_virgul + 3);
		/* virgülden sonraki sadece 2 hane bırakılır*/
			
		/*virgüller yerleştirilir*/
		for (var k = aux.length-1; k>=0 ; k--)
			{
			t++;
			/* nokta için özel durum*/
			if (aux.substr(k,1) == milSep)
				{
				t = 0;
				textFormat =  perSep + textFormat;
				}
			else if (t % 3 == 0)
				textFormat = milSep + aux.substr(k,1) + textFormat; 
			else 
				textFormat =  aux.substr(k,1) + textFormat;
			} 
		/*eğer ,123,123,123 gibi ise en baştaki virgül atılır*/
		if (textFormat.substr(0,1) == milSep)
			{
				if(negatif == 1)
					return '-'+textFormat.substr(1,textFormat.length-1);
				else
					return textFormat.substr(1,textFormat.length-1);
			}
		else 
			{
				if(negatif == 1)
					return '-'+textFormat;
				else
					return textFormat;
			}
		}
	}

	function f1(fld)
	{
		var temp_str = fld.toString();
		while (temp_str.indexOf('.') >= 0)
			{
			yer = temp_str.indexOf('.');
			temp_str = temp_str.substr(0,yer) + '' + temp_str.substr(yer+1, temp_str.length-yer-1);
			}
		if (temp_str.indexOf(',') >= 0)
			{
			yer = temp_str.indexOf(',');
			temp_str = temp_str.substr(0,yer) + '.' + temp_str.substr(yer+1, temp_str.length-yer-1);
			}
		return temp_str;
	}
	
	/* Bizim Dilimize Çevirir  ( 123123123123.12 -> 123.123.123123,12 )*/
	function f2(fld)
	{
		var temp_str = fld.toString();
		if (temp_str.indexOf('.') >= 0)
			{
			yer = temp_str.indexOf('.');
			temp_str = temp_str.substr(0,yer) + ',' + temp_str.substr(yer+1, temp_str.length-yer-1);
			}
		return temp_str;
	}
	
	window.opener.opener.add_daily_sales_report.alisveris_ceki.value = <cfoutput>'#tlformat(cek_toplam_)#';</cfoutput>
	window.opener.opener.add_daily_sales_report.alisveris_ceki.value = f1(window.opener.opener.add_daily_sales_report.alisveris_ceki.value);
	window.opener.opener.add_daily_sales_report.summary_genel_kalan.value = f1(window.opener.opener.add_daily_sales_report.summary_genel_kalan.value);
	window.opener.opener.add_daily_sales_report.ilk_deger.value = f1(window.opener.opener.add_daily_sales_report.ilk_deger.value);
	
	summary_genel_toplam = (parseFloat(window.opener.opener.add_daily_sales_report.ilk_deger.value) - parseFloat(window.opener.opener.add_daily_sales_report.alisveris_ceki.value));
	window.opener.opener.add_daily_sales_report.summary_genel_kalan.value = commaSplit(f2(summary_genel_toplam));
	window.opener.opener.add_daily_sales_report.alisveris_ceki.value = commaSplit(f2(window.opener.opener.add_daily_sales_report.alisveris_ceki.value));
	window.opener.opener.add_daily_sales_report.ilk_deger.value = commaSplit(f2(window.opener.opener.add_daily_sales_report.ilk_deger.value));
	<cfoutput>
	window.location='#request.self#?fuseaction=finance.popup_add_cheque_row&store_report_id=#attributes.store_report_id#&cek_toplam_=#cek_toplam_#';	wrk_opener_reload();
	</cfoutput>
</script>
