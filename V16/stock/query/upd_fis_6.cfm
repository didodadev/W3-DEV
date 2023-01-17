<cfscript>
if (get_process_type.is_account eq 1) 
{
	branch_id_in=''; branch_id_out='';
	if( listfind("111,112,113",attributes.fis_type) ) //sarf,fire ve ambar fişi için çıkış depo lokasyon tipi belirleniyor 
	{
		if( len(attributes.location_out) and len(attributes.department_out)) 
		{
			LOCATION_OUT=cfquery(datasource:"#dsn2#",sqlstring:"SELECT SL.LOCATION_TYPE,D.BRANCH_ID,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION SL, #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND SL.DEPARTMENT_ID=#attributes.department_out# AND SL.LOCATION_ID=#attributes.location_out#");
			location_type_out = LOCATION_OUT.LOCATION_TYPE;
			branch_id_out = LOCATION_OUT.BRANCH_ID;
			is_scrap_out = LOCATION_OUT.IS_SCRAP;
		}
		else
		{location_type_out ='';	is_scrap_out='';}	
	}
	if (attributes.fis_type eq 113) //ambar fisi için giriş depo lokasyon tipi belirleniyor
	{
		if( len(attributes.location_in) and len(attributes.department_in)) //giris depo lokasyonu tipi kontrol ediliyor
		{	
			LOCATION_IN=cfquery(datasource:"#dsn2#",sqlstring:"SELECT SL.LOCATION_TYPE,D.BRANCH_ID,IS_SCRAP FROM #dsn_alias#.STOCKS_LOCATION SL, #dsn_alias#.DEPARTMENT D WHERE D.DEPARTMENT_ID=SL.DEPARTMENT_ID AND SL.DEPARTMENT_ID=#attributes.department_in# AND SL.LOCATION_ID=#attributes.location_in#");
			location_type_in = LOCATION_IN.LOCATION_TYPE;
			branch_id_in = LOCATION_IN.BRANCH_ID;
			is_scrap_in = LOCATION_IN.IS_SCRAP;
		}
		else
		{location_type_in ='';	is_scrap_in='';}
	}
	//ambar fisinde; giris deposu icin hammadde lokasyon secilmis ise, cıkıs depo da sadece mal depo secildiginde muhasebe islemi yapılır...
	if(attributes.fis_type eq 111)
		detail = getLang('main',1831);
	else if(attributes.fis_type eq 112)
		detail = getLang('main',1832);
	else if(attributes.fis_type eq 113)
		detail = getLang('main',1833);
	else
		detail = getLang('main',2701);
	detail_row = "#detail#" & iif(isDefined("attributes.detail") and Len(attributes.detail),de("-#attributes.detail#"),de(""));	
	include('stock_fis_account_process.cfm');
	muhasebeci(
		action_id : attributes.UPD_ID,
		workcube_process_type : get_process_type.process_type,
		workcube_old_process_type : form.old_process_type,
		workcube_process_cat:form.process_cat,
		account_card_type : 13,
		islem_tarihi : attributes.FIS_DATE,
		borc_hesaplar : str_borclu_hesaplar,
		borc_tutarlar : borc_alacak_tutar,
		other_amount_borc : str_dovizli_tutarlar,
		other_currency_borc : str_doviz_currency,
		alacak_hesaplar : str_alacakli_hesaplar,
		alacak_tutarlar : borc_alacak_tutar,
		other_amount_alacak : str_dovizli_tutarlar,
		other_currency_alacak :str_doviz_currency,
		from_branch_id : branch_id_out,
		to_branch_id : branch_id_in,
		fis_detay : detail,
		fis_satir_detay : detail_row,
		belge_no : FIS_NO,
		is_account_group : get_process_type.is_account_group,
		currency_multiplier : currency_multiplier,
		acc_project_list_alacak : acc_project_list_alacak,
		acc_project_list_borc : acc_project_list_borc
	);		
}
else
	muhasebe_sil(action_id:attributes.UPD_ID, process_type:form.old_process_type);
</cfscript>
