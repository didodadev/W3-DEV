<cfsetting showdebugoutput="no">
<cffunction name="draw_div" returntype="string">
	<cfargument name="position_id" type="numeric" required="true">
	<cfargument name="last_hie" type="string" required="true">
	<cfargument name="query_row" type="numeric" required="true">
	<cfargument name="yeni_hierarchy" type="string" required="true">
	<cfargument name="employee_id" type="numeric" required="true">
	<cfargument name="position_name" type="string" required="true">
	<cfargument name="title" type="string" required="true">
	<cfargument name="position_cat" type="string" required="true">
	<cfargument name="employee_name" type="string" required="true">
	<cfargument name="employee_surname" type="string" required="true">
	<cfargument name="position_code" type="numeric" required="true">
	<cfargument name="is_critical" type="string" required="true">
	<cfargument name="is_vekaleten" type="numeric" required="true">
	<cfargument name="step_no" type="numeric" required="true">
	<cfargument name="upper_step_no" type="numeric" required="true">
	<cfset 'my_resim_#arguments.position_id#' = "">
	<cfif arguments.query_row lte get_all_workgroup_roles2.recordcount>
		<cfif find('#arguments.yeni_hierarchy#.',get_all_workgroup_roles2.yeni_hierarchy[arguments.query_row+1])>
			<cfset is_alt = 1>
		<cfelse>
			<cfset is_alt = 0>
		</cfif>
	</cfif>
		<cfset ek_deger_ = 0>
		<cfset my_grup_uzunlugu = listlen(arguments.yeni_hierarchy,'.')>
		<cfif attributes.is_kademe eq 1>
					<cfset aktif_kademe = listlen(arguments.yeni_hierarchy,'.')-1>
					<cfset my_kademe = arguments.step_no - 1>
					
					<cfset my_cizgi_yuksekligi = (aktif_kademe + 1) * cizgi_yuksekligi>
					<cfset kademe_eklentisi = 0>
					<cfif last_hie neq 0>
						<cfif (listlen(arguments.yeni_hierarchy,'.') gt last_hie)>
							<cfset my_left = my_left>
						<cfelseif (listlen(arguments.yeni_hierarchy,'.') lt last_hie)>
							<cfset my_left = my_left + kutu_genisligi + 5>
						<cfelseif (listlen(arguments.yeni_hierarchy,'.') eq last_hie)>
							<cfset my_left = my_left + kutu_genisligi + 5>
						</cfif>
					<cfelse>
						<cfset my_left = 30>
					</cfif>
					<cfset alt_cizgi_ = cizgi_yuksekligi>
					<cfset my_top = (((listlen(arguments.yeni_hierarchy,'.') - (my_default_hie-1))* kutu_yuksekligi)+10)+my_top_eklenti + my_cizgi_yuksekligi>
		<cfelse>
				<cfif my_grup_uzunlugu eq 1>
					<cfset my_kademe = my_grup_uzunlugu>
					<cfif arguments.step_no gt my_grup_uzunlugu>
						<cfset my_kademe = arguments.step_no>
					</cfif>
					<cfset my_asama = 1>
					<cfset my_upper_top_ = 0>
					<cfset all_uppers = listappend(all_uppers,arguments.position_code,',')>
					<cfset all_uppers_kademes = listappend(all_uppers_kademes,my_kademe,',')>
					<cfset my_top = evaluate("asama_top_1")>
					
						<cfif arguments.step_no gt my_grup_uzunlugu>
							<cfset kademe_eklentisi = evaluate("asama_top_2") - my_top>
						<cfelse>
							<cfset kademe_eklentisi = 0>
						</cfif>
					
				<cfelse>
					<cfif listfindnocase(all_uppers,arguments.upper_step_no)>
						<cfset my_upper_ = listfindnocase(all_uppers,arguments.upper_step_no)>
						<cfset my_upper_top_ = listgetat(all_uppers_kademes,my_upper_)>
					</cfif>
					
					<cfif arguments.step_no lte my_upper_top_>
						<cfset my_kademe = my_upper_top_ + 1>
					<cfelse>
						<cfset my_kademe = arguments.step_no>
						<cfset my_top = evaluate("asama_top_#my_kademe#")>
					</cfif>
					
					<cfif arguments.step_no lte my_upper_top_>
						<cfset my_top = evaluate("asama_top_#my_kademe#")>
					<cfelse>
						<cfset my_top = evaluate("asama_top_#my_upper_top_ + 1#")>				
					</cfif>
					
					<cfset all_uppers = listappend(all_uppers,arguments.position_code,',')>
					<cfset all_uppers_kademes = listappend(all_uppers_kademes,my_kademe,',')>	
					
					<cfset kademe_eklentisi = (my_kademe - 1 - my_upper_top_) * (kutu_yuksekligi + (cizgi_yuksekligi))>
					<cfif kademe_eklentisi lt 0>
						<cfset kademe_eklentisi = 0>
					</cfif>
				</cfif>
				
				<cfif isdefined("asama_top_#my_kademe + 1#")>
					<cfset alt_cizgi_ = evaluate("asama_top_#my_kademe + 1#") - (my_top + kutu_yuksekligi + kademe_eklentisi)>
				</cfif>
				
		</cfif>
	
	<cfif listfindnocase(main_employee_list,arguments.employee_id)>
		<cfset 'my_resim_#position_id#' = "#get_resimler.PHOTO[listfind(main_employee_list,employee_id,',')]#">
	</cfif>

	<cfif last_hie neq 0>
		<cfset my_left_ilk = my_left>
	<cfelse>
		<cfset my_left_ilk = 30>
	</cfif>
	
	<cfif attributes.is_kademe eq 1>	
			<cfif last_hie neq 0>
				<cfif (listlen(arguments.yeni_hierarchy,'.') gt last_hie)>
					<cfset my_left = my_left>
				<cfelseif (listlen(arguments.yeni_hierarchy,'.') lt last_hie)>
					<cfset my_left = my_left + 30>
				<cfelseif (listlen(arguments.yeni_hierarchy,'.') eq last_hie)>
					<cfset my_left = my_left + 30>
				</cfif>
			<cfelse>
				<cfset my_left = 30>
			</cfif>
	<cfelse>
			<cfif last_hie neq 0>
				<cfif (listlen(arguments.yeni_hierarchy,'.') gt last_hie)>
					<cfset my_left = my_left>
				<cfelseif (listlen(arguments.yeni_hierarchy,'.') lt last_hie)>
					<cfset my_left = my_left + kutu_genisligi + 100>
				<cfelseif (listlen(arguments.yeni_hierarchy,'.') eq last_hie)>
					<cfset my_left = my_left + kutu_genisligi + 100>
				</cfif>
				<cfif isdefined("kademe_upper_list") and listfindnocase(kademe_upper_list,arguments.position_code)>
					<cfset my_left = my_left + 140>
				</cfif>
			<cfelse>
				<cfset my_left = 135>
			</cfif>
	</cfif>
	
	<cfif attributes.tasarim_tipi eq 3 and isdefined("upper_list") and listfindnocase(upper_list,arguments.position_code) and last_hie neq 0>
		<cfset my_left = my_left + kutu_genisligi + 35>
	<cfelseif attributes.tasarim_tipi eq 3 and isdefined("upper_list") and listfindnocase(upper_list,arguments.position_code) and last_hie eq 0>
		<cfset my_left = my_left + (kutu_genisligi / 2) + 35>
	</cfif>
	
	<cfscript>
				div_spe = 'border: 1px';
				if(arguments.EMPLOYEE_ID gt 0)div_spe = div_spe & ' solid';else div_spe = div_spe & ' dashed';
				if(arguments.is_critical eq 1)div_spe = div_spe & ' red;';else div_spe = div_spe & ' ##666666';
				if(arguments.is_vekaleten eq 1)my_vekil= '<b>(V)</b>';else my_vekil= '';
				deger = '<div id="cizim_#arguments.position_id#" style="position:absolute;z-index:2;left:#my_left#px;top:#my_top#px;width:#kutu_genisligi#px;height:#kutu_yuksekligi+kademe_eklentisi#px;">';

				if((isdefined("attributes.is_critical") and arguments.is_critical eq 1) or (isdefined("attributes.is_empty_pos") and arguments.EMPLOYEE_ID eq 0) or (arguments.EMPLOYEE_ID gt 0 and arguments.is_critical neq 1))
						{
						if(browserDetect() contains 'MSIE')
							deger = deger & '<table width="100%" cellpadding="0" cellspacing="0" style="padding-top:10px;">';
						else
							deger = deger & '<table width="100%" cellpadding="0" cellspacing="0">';
						deger = deger & '<tr><td style="text-align:center;" height="18"><img src="/images/cizgi_dik_1pix.gif" height="#(cizgi_yuksekligi/2)+kademe_eklentisi+3#" width="3"></td></tr>';
						deger = deger & '<tr><td style="#div_spe#"><div id="tablo_#arguments.position_id#" style="left:#my_left#px;top:#my_top+(cizgi_yuksekligi/2)+kademe_eklentisi+3#px;"></div><table cellpadding="2" cellspacing="0" width="100%">';
						if(isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim") and len(evaluate("my_resim_#position_id#")))
							deger = deger & '<tr><td style="text-align:center;" height="#resim_yuksekligi#"><img src="http://#cgi.HTTP_HOST#/documents/hr/#evaluate("my_resim_#position_id#")#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td></tr>';
						else if(isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim"))
							deger = deger & '<tr><td style="text-align:center;" height="#resim_yuksekligi#">&nbsp;</td></tr>';
						
						deger = deger & '<tr>';
						if(isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi neq 2 and isdefined("attributes.is_resim") and len(evaluate("my_resim_#position_id#")))
							deger = deger & '<td width="#resim_genisligi#"><img src="http://#cgi.HTTP_HOST#/documents/hr/#evaluate("my_resim_#position_id#")#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td>';
						else if(isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi neq 2 and isdefined("attributes.is_resim")) 
							deger = deger & '<td width="#resim_genisligi#">&nbsp;</td>';
						
						deger = deger & '<td style="height:#kutu_yuksekligi_ilk#px;" style="text-align:center;">';
						deger = deger & '<table style="text-align:center;" cellpadding="0" cellspacing="0" width="100%">';
						if(isdefined("attributes.is_pozisyon"))
							deger = deger & '<tr><td style="text-align:center;">#arguments.POSITION_NAME#</td></tr>';
						deger = deger & '<tr><td style="text-align:center;"><a href="javascript://" onclick="windowopen(''#request.self#?fuseaction=objects.popup_emp_det&emp_id=#arguments.EMPLOYEE_ID#'',''medium'');" class="tableyazi">#arguments.EMPLOYEE_NAME# #arguments.EMPLOYEE_SURNAME#</a> #my_vekil#</td></tr>';
						if(isdefined("attributes.is_pozisyon_tipi"))
							deger = deger & '<tr><td style="text-align:center;">#POSITION_CAT#</td></tr>';
						if(isdefined("attributes.is_unvan"))
							deger = deger & '<tr><td style="text-align:center;">#TITLE#</td></tr>';
						deger = deger & '</table></td></tr></table>';
						if(is_alt eq 1)
							{
								deger = deger & '<tr><td style="text-align:center;" height="#alt_cizgi_#"><img src="/images/cizgi_dik_1pix.gif" height="#alt_cizgi_#" width="3"></td></tr>';
							}
						deger = deger & '</table>';
						}
				else
						{
						deger = deger & '<table width="100%" cellpadding="0" cellspacing="0">';
						deger = deger & '<tr><td style="text-align:center;" height="15"><img src="/images/cizgi_dik_1pix.gif" height="#(cizgi_yuksekligi/2)+kademe_eklentisi+3#" width="3"></td></tr>';
						deger = deger & '<tr><td style="text-align:center;" height="#kutu_yuksekligi#"><img src="/images/cizgi_dik_1pix.gif" height="#kutu_yuksekligi#" width="3"></td></tr>';
						if(is_alt eq 1)
							{
								deger = deger & '<tr><td style="text-align:center;" height="#alt_cizgi_-(cizgi_yuksekligi / 2)#" valign="bottom"><img src="/images/cizgi_dik_1pix.gif" height="#alt_cizgi_-(cizgi_yuksekligi / 2)#" width="3"></td></tr>';
							}
							deger = deger & '</table>';
						}
				
				deger = deger & '</div>';
		if(isdefined("fonksiyoneli_olanlar") and listfindnocase(fonksiyoneli_olanlar,arguments.position_code))
			my_left = my_left + kutu_genisligi;
		
			my_son_left = my_left + kutu_genisligi;
	</cfscript>
	<cfreturn deger>
</cffunction>

<cfset all_uppers = ''>
<cfset all_uppers_kademes = ''>
<cfif attributes.baglilik eq 1>
	<cfset amir_tipi = "UPPER_POSITION_CODE">
<cfelse>
	<cfset amir_tipi = "UPPER_POSITION_CODE2">
</cfif>
<cfset ilk_amir = attributes.upper_position_code>
<cfquery name="get_all_position" datasource="#dsn#">
	SELECT 
		EMPLOYEE_POSITIONS.IS_VEKALETEN,
		EMPLOYEE_POSITIONS.IS_CRITICAL,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		EMPLOYEE_POSITIONS.UPPER_POSITION_CODE,
		EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2,
		SETUP_POSITION_CAT.POSITION_CAT,
		SETUP_TITLE.TITLE
	FROM 
		EMPLOYEE_POSITIONS,
		SETUP_POSITION_CAT,
		SETUP_TITLE
	WHERE
		EMPLOYEE_POSITIONS.IS_ORG_VIEW = 1 AND
		EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID AND
		EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID
		<cfif isdefined("attributes.is_active_in_out")>
			AND EMPLOYEE_POSITIONS.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE FINISH_DATE IS NULL OR FINISH_DATE >= #NOW()#)
		</cfif>
		<cfif attributes.alt_cizim_sayisi eq 1>
			<cfif not isdefined("attributes.is_critical")>AND EMPLOYEE_POSITIONS.IS_CRITICAL <> 1</cfif>
			<cfif not isdefined("attributes.is_empty_pos")>AND EMPLOYEE_POSITIONS.EMPLOYEE_ID > 0</cfif>
		</cfif>
</cfquery>
<cfquery name="get_kademe_positions" datasource="#dsn#">
	SELECT
		SOS.ORG_DSP,
		SOS.ORGANIZATION_STEP_NO,
		EP.POSITION_CODE
	FROM
		EMPLOYEE_POSITIONS EP,
		SETUP_ORGANIZATION_STEPS SOS
	WHERE
		EP.ORGANIZATION_STEP_ID = SOS.ORGANIZATION_STEP_ID AND
		EP.ORGANIZATION_STEP_ID IS NOT NULL
</cfquery>

<cfquery name="get_org_steps" dbtype="query">
	SELECT ORGANIZATION_STEP_NO FROM get_kademe_positions ORDER BY ORGANIZATION_STEP_NO ASC
</cfquery>
<cfset step_gercek_list = "">

<cfquery name="get_pos_ilk" dbtype="query">
	SELECT * FROM get_all_position WHERE #amir_tipi# = #ilk_amir#
</cfquery>
<cfif not get_pos_ilk.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='56730.Hiç Bir Bağlı Alt Pozisyon Bulunamadı'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfset ilk_alt_kademeler = valuelist(get_pos_ilk.POSITION_ID)>

<cfset position_control_list = valuelist(get_pos_ilk.POSITION_CODE)>
<cfset position_all_list = valuelist(get_pos_ilk.POSITION_CODE)>
<cfset position_all_hierarchy_list = valuelist(get_pos_ilk.POSITION_CODE)>
<cfset position_kademe_list = "">

<cfset pos_upper_list = "">
<cfset pos_upper_add_list = "">

	<cfscript>
			my_sira = 1;
			while(my_sira lt (attributes.alt_cizim_sayisi + 1))
			{
				my_dongu_sayisi = listlen(position_control_list);
				position_list = position_control_list;
				position_control_list = "";
					if(my_dongu_sayisi gt 0)
					{
						for (k=1; k lte my_dongu_sayisi; k=k+1)
							{
								aktif_position = listgetat(position_list,k,',');
									if(attributes.is_kademe eq 2)
									{
									'top_ekle_#aktif_position#' = -1;
									get_kademe = cfquery(dbtype:"query",datasource:"#dsn#",sqlstring:"SELECT * FROM  get_kademe_positions WHERE POSITION_CODE = #aktif_position#");
									if(get_kademe.recordcount)
										{
										if(get_kademe.ORG_DSP eq 1)
											{
											position_kademe_list = listappend(position_kademe_list,aktif_position);
											sira = listfindnocase(position_all_list,aktif_position);
											position_all_list = listdeleteat(position_all_list,sira);
											position_all_hierarchy_list = listdeleteat(position_all_hierarchy_list,sira);
											}
										else
											{										
											'top_ekle_#aktif_position#' = get_kademe.ORGANIZATION_STEP_NO;
											step_gercek_list = listappend(step_gercek_list,get_kademe.ORGANIZATION_STEP_NO,',');
											}
										}
									pos_upper_list = listappend(pos_upper_list,aktif_position,',');
									pos_upper_add_list = listappend(pos_upper_add_list,evaluate("top_ekle_#aktif_position#"),',');
									}
								
								if(not isdefined("get_kademe.recordcount") or get_kademe.recordcount eq 0 or get_kademe.ORG_DSP neq 1)
									{
									get_alts = cfquery(dbtype:"query",datasource:"#dsn#",sqlstring:"SELECT * FROM  get_all_position WHERE #amir_tipi# = #aktif_position#");
									if(get_alts.recordcount)
										{
											for(m=1;m lte get_alts.recordcount;m=m+1)
												{
													position_control_list = listappend(position_control_list,get_alts.position_code[#m#]);
													
													if(my_sira neq attributes.alt_cizim_sayisi) 
														{
														position_all_list = listappend(position_all_list,get_alts.position_code[#m#]);
														if(listfindnocase(position_all_list,aktif_position))
															{
															my_ust_sira = listfindnocase(position_all_list,aktif_position);
															ust_code = listgetat(position_all_hierarchy_list,my_ust_sira,',');
															ust_code = '#ust_code#.' & get_alts.position_code[#m#];
															}
														else
															{
															ust_code = get_alts.position_code[#m#];
															}
														position_all_hierarchy_list = listappend(position_all_hierarchy_list,ust_code);
														}
												}
												
										}
									}
							}
					}
				my_sira = my_sira + 1;
			}
	</cfscript>
	
	
<cfif listlen(step_gercek_list)>
	<cfset step_gercek_list = listsort(listdeleteduplicates(step_gercek_list),'numeric','ASC',',')>
</cfif>

<cfif listlen(position_all_list)>
	<cfquery name="get_pos_bilgiler" dbtype="query">
		SELECT * FROM get_all_position WHERE POSITION_CODE IN (#position_all_list#)
	</cfquery>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='56731.Kriterlere Uygun Çizim Yapılamadı ! Lütfen Girdileri Kontrol Ediniz'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfset get_all_workgroup_roles = QueryNew("POSITION_CODE,POSITION_ID,IS_CRITICAL,IS_VEKALETEN,YENI_HIERARCHY,EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME,POSITION_NAME,POSITION_CAT,TITLE,STEP_NO,UPPER_STEP_NO","Integer,Integer,Integer,Integer,VarChar,Integer,VarChar,VarChar,VarChar,VarChar,VarChar,Integer,Integer")>
<cfset ROW_OF_QUERY = 0>
<cfset sira_no = 0>
<cfset my_count_ = 0>
<cfset my_en_son_hie_uzunluk = 0>
<cfset position_agac_list = "">
<cfset position_agac_list_hie = "">
<cfset position_agac_list_upper = "">
<cfloop list="#position_all_list#" index="mk">
	<cfset sira_no = sira_no + 1>
	<cfscript>
		my_son_step = 0;
		up_pos_code = listgetat(position_all_hierarchy_list,sira_no,',');
		upper_sira_no = listlen(up_pos_code,'.'); 
		ROW_OF_QUERY = ROW_OF_QUERY + 1;
		get_pos_ilk = cfquery(dbtype:"query",datasource:"#dsn#",sqlstring:"SELECT * FROM get_pos_bilgiler WHERE POSITION_CODE = #mk#");
		my_upper_ = evaluate("get_pos_ilk.#amir_tipi#");
		
		if(attributes.is_kademe eq 2 and isdefined("top_ekle_#mk#") and listlen(step_gercek_list))
		{			
			my_son_step = evaluate("top_ekle_#mk#");
			my_son_step = listfindnocase(step_gercek_list,my_son_step,',');
		}
		else
			my_son_step = 0;
	
		if(attributes.tasarim_tipi neq 3 or (attributes.tasarim_tipi eq 3 and listlen(up_pos_code,'.') neq attributes.alt_cizim_sayisi))
			{
			QueryAddRow(get_all_workgroup_roles,1);
			QuerySetCell(get_all_workgroup_roles,"POSITION_CODE",get_pos_ilk.position_code,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"POSITION_ID",get_pos_ilk.position_id,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"IS_CRITICAL",get_pos_ilk.IS_CRITICAL,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"IS_VEKALETEN",get_pos_ilk.IS_VEKALETEN,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"YENI_HIERARCHY",up_pos_code,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_ID",get_pos_ilk.EMPLOYEE_ID,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_NAME",get_pos_ilk.EMPLOYEE_NAME,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"EMPLOYEE_SURNAME",get_pos_ilk.EMPLOYEE_SURNAME,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"POSITION_NAME",get_pos_ilk.POSITION_NAME,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"POSITION_CAT",get_pos_ilk.POSITION_CAT,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"TITLE",get_pos_ilk.TITLE,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"STEP_NO",my_son_step,ROW_OF_QUERY);
			QuerySetCell(get_all_workgroup_roles,"UPPER_STEP_NO",my_upper_,ROW_OF_QUERY);
			}
		else if(attributes.tasarim_tipi eq 3 and listlen(up_pos_code,'.') eq attributes.alt_cizim_sayisi)
			{
			position_agac_list = listappend(position_agac_list,mk);
			position_agac_list_hie = listappend(position_agac_list_hie,up_pos_code);
			position_agac_list_upper = listappend(position_agac_list_upper,my_upper_);
			}
	</cfscript>
</cfloop>



<cfset my_employee_list = listsort(listdeleteduplicates(valuelist(get_pos_bilgiler.employee_id,',')),'numeric','ASC',',')>
<cfif not listlen(my_employee_list)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='56731.Kriterlere Uygun Çizim Yapılamadı!Lütfen Girdileri Kontrol Ediniz'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif listlen(position_kademe_list)>
	<cfquery name="get_" datasource="#dsn#">
		SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#position_kademe_list#)
	</cfquery>
	<cfif get_.recordcount>
		<cfset my_employee_list = listappend(my_employee_list,'#valuelist(get_.EMPLOYEE_ID)#')>
	</cfif>
</cfif>

<cfif listfindnocase(my_employee_list,'0')>
	<cfset my_employee_list = listsort(listdeleteat(my_employee_list,listfindnocase(my_employee_list,'0')),'numeric')>
</cfif>
<cfquery name="get_resimler" datasource="#dsn#">
	SELECT PHOTO,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#listsort(my_employee_list,'Numeric')#) ORDER BY EMPLOYEE_ID
</cfquery>
<cfset main_employee_list = listsort(listdeleteduplicates(valuelist(get_resimler.EMPLOYEE_ID,',')),'numeric','ASC',',')>

<cfquery name="get_all_workgroup_roles2" dbtype="query">
	SELECT * FROM get_all_workgroup_roles ORDER BY YENI_HIERARCHY ASC
</cfquery>
<cfset silinecek_list2 = "">
<cfset silinecek_list = "">
<cfset silinecek_upper_list = "">
<cfoutput query="get_all_workgroup_roles2">
	<cfset 'employee_id_#currentrow#' = employee_id>
	<cfif currentrow lt recordcount and attributes.alt_cizim_sayisi gt 1>
		<cfif find('#get_all_workgroup_roles2.yeni_hierarchy#.',get_all_workgroup_roles2.yeni_hierarchy[currentrow+1]) or find('#get_all_workgroup_roles2.yeni_hierarchy#.',position_agac_list_hie)>
			<cfset 'is_alt#currentrow#' = 1>
		<cfelse>
			<cfset 'is_alt#currentrow#' = 0>
		</cfif>
	<cfelse>
		<cfset 'is_alt#currentrow#' = 0>
	</cfif>
	
	<cfif listfindnocase(position_agac_list_upper,position_id)>
		<cfset 'is_alt#currentrow#' = 1>
	</cfif>
	
	<cfif get_all_workgroup_roles2.is_critical eq 1 and not isdefined("attributes.is_critical")>
		<cfif evaluate("is_alt#currentrow#") eq 0>
			<cfset silinecek_list = listappend(silinecek_list,position_id,',')>
		</cfif>
		<cfset silinecek_list2 = listappend(silinecek_list2,position_id,',')>
		<cfset silinecek_upper_list = listappend(silinecek_upper_list,UPPER_STEP_NO,',')>
	</cfif>
	
	<cfif evaluate("employee_id_#currentrow#") eq 0 and not isdefined("attributes.is_empty_pos") and evaluate("is_alt#currentrow#") eq 0>
		<cfif evaluate("is_alt#currentrow#") eq 0>
			<cfset silinecek_list = listappend(silinecek_list,position_id,',')>
		</cfif>
		<cfset silinecek_list2 = listappend(silinecek_list2,position_id,',')>
		<cfset silinecek_upper_list = listappend(silinecek_upper_list,UPPER_STEP_NO,',')>
	</cfif>
</cfoutput>

<cfif listlen(silinecek_list)>
	<cfquery name="get_all_workgroup_roles2" dbtype="query">
		SELECT * FROM get_all_workgroup_roles WHERE POSITION_ID NOT IN (#silinecek_list#) ORDER BY YENI_HIERARCHY ASC
	</cfquery>
</cfif>

<cfquery name="get_all_workgroup_roles_ters" dbtype="query">
	SELECT * FROM get_all_workgroup_roles2 ORDER BY YENI_HIERARCHY DESC
</cfquery>

<cfset my_top_eklenti = 5>
<cfset kademe_sayisi = 0>
<cfset kademe_carpani = 20>
<cfset kutu_yuksekligi_ilk = 40>
<cfset kutu_genisligi_ilk = 130>
<cfset resim_yuksekligi = 80>
<cfset resim_genisligi = 60>
<cfset my_default_hie = 1>
<cfset cizgi_yuksekligi = 50>
<cfset my_son_left = 1>
<cfset kutu_yukseklik_eklentisi = 1>

<cfif isdefined("attributes.is_pozisyon")>
	<cfset kutu_yuksekligi_ilk = kutu_yuksekligi_ilk + 15>
	<cfset kutu_yukseklik_eklentisi = kutu_yukseklik_eklentisi + 15>
</cfif>
<cfif isdefined("attributes.is_unvan")>
	<cfset kutu_yuksekligi_ilk = kutu_yuksekligi_ilk + 15>
	<cfset kutu_yukseklik_eklentisi = kutu_yukseklik_eklentisi + 15>
</cfif>
<cfif isdefined("attributes.is_pozisyon_tipi")>
	<cfset kutu_yuksekligi_ilk = kutu_yuksekligi_ilk + 15>
	<cfset kutu_yukseklik_eklentisi = kutu_yukseklik_eklentisi + 15>
</cfif>
<cfif isdefined("attributes.is_resim")>
	<cfset kutu_yuksekligi_ilk = 85>
	<cfset kutu_yukseklik_eklentisi = resim_yuksekligi + 5>
</cfif>


<cfif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi neq 2 and isdefined("attributes.is_resim")>
	<cfset kutu_genisligi = kutu_genisligi_ilk + resim_genisligi>
	<cfset kutu_yuksekligi = kutu_yuksekligi_ilk + 30>
<cfelseif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim")>
	<cfset kutu_yuksekligi = kutu_yuksekligi_ilk + resim_yuksekligi + 30>
	<cfset kutu_genisligi = kutu_genisligi_ilk>
<cfelse>
	<cfset kutu_yuksekligi = kutu_yuksekligi_ilk + 30>
	<cfset kutu_genisligi = kutu_genisligi_ilk>
</cfif>


<cfquery name="get_upper" datasource="#dsn#">
	SELECT 
		EMPLOYEE_POSITIONS.*,
		SETUP_POSITION_CAT.POSITION_CAT,
		SETUP_TITLE.TITLE,
		EMPLOYEES.PHOTO
	FROM  
		EMPLOYEE_POSITIONS,
		SETUP_POSITION_CAT,
		SETUP_TITLE,
		EMPLOYEES
	WHERE 
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
		EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID AND
		EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
		POSITION_CODE = #attributes.upper_position_code#
</cfquery>

<cfsavecontent variable="sema_icerik">
<cfif len(evaluate("get_upper.#amir_tipi#")) and attributes.ust_cizim_sayisi gt 0>
	<cfquery name="get_upper_1" datasource="#dsn#">
		SELECT 
			EMPLOYEE_POSITIONS.*,
			SETUP_POSITION_CAT.POSITION_CAT,
			SETUP_TITLE.TITLE,
			EMPLOYEES.PHOTO
		FROM  
			EMPLOYEE_POSITIONS,
			SETUP_POSITION_CAT,
			SETUP_TITLE,
			EMPLOYEES
		WHERE 
			EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
			EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID AND
			EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
			POSITION_CODE = #evaluate("get_upper.#amir_tipi#")#
	</cfquery>
			<cfif get_upper_1.recordcount and attributes.ust_cizim_sayisi eq 2>
					<cfif len(evaluate("get_upper_1.#amir_tipi#"))>
							<cfquery name="get_upper_2" datasource="#dsn#">
								SELECT 
									EMPLOYEE_POSITIONS.*,
									SETUP_POSITION_CAT.POSITION_CAT,
									SETUP_TITLE.TITLE,
									EMPLOYEES.PHOTO
								FROM  
									EMPLOYEE_POSITIONS,
									SETUP_POSITION_CAT,
									SETUP_TITLE,
									EMPLOYEES
								WHERE 
									EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
									EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID AND
									EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID AND
									POSITION_CODE = #evaluate("get_upper_1.#amir_tipi#")#
							</cfquery>
							<cfif get_upper_2.recordcount>
							<cfoutput>
								<div id="main_group_2" align="center" style="position:absolute;z-index:2;width:#kutu_genisligi#px;height:#kutu_yuksekligi-15#px;left:250px;top:#13+my_top_eklenti+25#px;">
									<table width="100%" cellpadding="0" cellspacing="0">
									<tr><td style="border: 1px solid ##666666;">
												<table cellpadding="2" cellspacing="0" width="100%">
												<cfif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim") and len(get_upper_2.photo)>
														<tr><td style="text-align:center;" height="#resim_yuksekligi#"><img src="http://#cgi.HTTP_HOST#/documents/hr/#get_upper_2.photo#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td></tr>
												<cfelseif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim")>
														<tr><td style="text-align:center;" height="#resim_yuksekligi#">&nbsp;</td></tr>
												</cfif>
												<tr>
												<cfif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi neq 2 and isdefined("attributes.is_resim") and len(get_upper_2.photo)>
														<td width="#resim_genisligi#"><img src="http://#cgi.HTTP_HOST#/documents/hr/#get_upper_2.photo#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td>
												<cfelseif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi neq 2 and isdefined("attributes.is_resim")> 
														<td width="#resim_genisligi#">&nbsp;</td>
												</cfif>
													<td style="height:#kutu_yuksekligi_ilk#px;">
														<table cellpadding="0" cellspacing="0" style="text-align:center;" width="100%">
															<tr>
																<td style="text-align:center;">
																	<cfif isdefined("attributes.is_pozisyon")>#get_upper_2.position_name#<br/></cfif>
																	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_upper_2.EMPLOYEE_ID#','medium');" class="tableyazi">#get_upper_2.employee_name# #get_upper_2.employee_surname#</a><br/>
																	<cfif isdefined("attributes.is_pozisyon_tipi")>#get_upper_2.position_cat#<br/></cfif>
																	<cfif isdefined("attributes.is_unvan")>#get_upper_2.title#<br/></cfif>
																</td>
															</tr>
														</table>
													</td>
												</tr>
											 </table>
										</td>
									</tr>
										<tr><td style="text-align:center;" height="15"><img src="/images/cizgi_dik_1pix.gif" height="15" width="3"></td></tr>
									</table>
								</div>
								<cfset my_top_eklenti = my_top_eklenti + kutu_yuksekligi - 14>
							</cfoutput>
							</cfif>
					</cfif>
				</cfif>
		<cfoutput>
		<div id="main_group_1" align="center" style="position:absolute;z-index:2;width:#kutu_genisligi#px;height:#kutu_yuksekligi-15#px;left:250px;top:#13+my_top_eklenti+25#px;">
			<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td style="border: 1px solid ##666666;">
						<table cellpadding="2" cellspacing="0" width="100%">
						<cfif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim") and len(get_upper_1.photo)>
								<tr><td style="text-align:center;" height="#resim_yuksekligi#"><img src="http://#cgi.HTTP_HOST#/documents/hr/#get_upper_1.photo#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td></tr>
						<cfelseif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim")>
								<tr><td style="text-align:center;" height="#resim_yuksekligi#">&nbsp;</td></tr>
						</cfif>
						<tr>
						<cfif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi neq 2 and isdefined("attributes.is_resim") and len(get_upper_1.photo)>
								<td width="#resim_genisligi#"><img src="http://#cgi.HTTP_HOST#/documents/hr/#get_upper_1.photo#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td>
						<cfelseif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi neq 2 and isdefined("attributes.is_resim")> 
								<td width="#resim_genisligi#">&nbsp;</td>
						</cfif>
							<td style="height:#kutu_yuksekligi_ilk#px;text-align:center;">
								<table cellpadding="0" cellspacing="0" style="text-align:center;" width="100%">
									<tr>
										<td>
											<cfif isdefined("attributes.is_pozisyon")>#get_upper_1.position_name#<br/></cfif>
											<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_upper_1.EMPLOYEE_ID#','medium');" class="tableyazi">#get_upper_1.employee_name# #get_upper_1.employee_surname#</a><br/>
											<cfif isdefined("attributes.is_pozisyon_tipi")>#get_upper_1.position_cat#<br/></cfif>
											<cfif isdefined("attributes.is_unvan")>#get_upper_1.title#<br/></cfif>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					 </table>
				</td>
			</tr>
				<tr><td style="text-align:center;" height="15"><img src="/images/cizgi_dik_1pix.gif" height="15" width="3"></td></tr>
			</table>
		</div>
		<cfset my_top_eklenti = my_top_eklenti + kutu_yuksekligi - 14>
		</cfoutput>
</cfif>


<cfif listlen(position_kademe_list)>
	<cfquery name="get_pos_kademe" dbtype="query">
		SELECT 
			* 
		FROM 
			get_all_position 
		WHERE 
			POSITION_CODE IN (#position_kademe_list#)
			<cfif not isdefined("attributes.is_critical")>AND IS_CRITICAL <> 1</cfif>
			<cfif not isdefined("attributes.is_empty_pos")>AND EMPLOYEE_ID > 0</cfif>
	</cfquery>
	<cfset position_kademe_list = listsort(valuelist(get_pos_kademe.position_code),'numeric','ASC',',')>
	
	<cfset kademe_upper_list = "">
	<cfloop list="#position_kademe_list#" index="ck">
			<cfscript>
			kademe_up_pos_code = evaluate("get_pos_kademe.#amir_tipi#[listfind(position_kademe_list,ck,',')]");
			if(listfindnocase(silinecek_list2,kademe_up_pos_code))
				{
				kademe_up_pos_code = listgetat(silinecek_upper_list,listfindnocase(silinecek_list2,kademe_up_pos_code));
				}
			if(not listfindnocase(kademe_upper_list,kademe_up_pos_code) and kademe_up_pos_code neq ilk_amir)
				{
				kademe_upper_list = listappend(kademe_upper_list,kademe_up_pos_code);
				}
			</cfscript>
	</cfloop>
</cfif>

<cfif listlen(position_kademe_list)>
	<cfquery name="get_ilk_alt" dbtype="query">
		SELECT * FROM get_pos_kademe WHERE #amir_tipi# = #ilk_amir#
	</cfquery>
	<cfif get_ilk_alt.recordcount>
		<cfif get_ilk_alt.recordcount eq 1>
			<cfset ilk_kademe_eklentisi = kutu_yuksekligi>
		<cfelse>
			<cfset ilk_kademe_eklentisi = (ceiling(get_ilk_alt.recordcount/2)) * kutu_yuksekligi>
		</cfif>
	</cfif>
</cfif>
<cfif not isdefined("ilk_kademe_eklentisi")>
	<cfset ilk_kademe_eklentisi = 0>
</cfif>



<cfoutput>
<div id="main_group" align="center" style="position:absolute;z-index:2;width:#kutu_genisligi#px;height:#kutu_yuksekligi-15#px;top:#13+my_top_eklenti+25#px;">
	<table width="100%" cellpadding="0" cellspacing="0">
	<tr><td style="border: 1px solid ##666666;">
				<table cellpadding="2" cellspacing="0" width="100%">
				<cfif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim") and len(get_upper.photo)>
						<tr><td style="text-align:center;" height="#resim_yuksekligi#"><img src="http://#cgi.HTTP_HOST#/documents/hr/#get_upper.photo#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td></tr>
				<cfelseif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi eq 2 and isdefined("attributes.is_resim")>
						<tr><td style="text-align:center;" height="#resim_yuksekligi#">&nbsp;</td></tr>
				</cfif>
				<tr>
				<cfif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi neq 2 and isdefined("attributes.is_resim") and len(get_upper.photo)>
						<td width="#resim_genisligi#"><img src="http://#cgi.HTTP_HOST#/documents/hr/#get_upper.photo#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td>
				<cfelseif isdefined("attributes.tasarim_tipi") and attributes.tasarim_tipi neq 2 and isdefined("attributes.is_resim")> 
						<td width="#resim_genisligi#">&nbsp;</td>
				</cfif>
					<td style="height:#kutu_yuksekligi_ilk#px;" style="text-align:center;">
						<table cellpadding="0" cellspacing="0" style="text-align:center;" width="100%">
							<tr>
								<td style="text-align:center;">
									<cfif isdefined("attributes.is_pozisyon")>#get_upper.position_name#<br/></cfif>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_upper.EMPLOYEE_ID#','medium');" class="tableyazi">#get_upper.employee_name# #get_upper.employee_surname#</a><br/>
									<cfif isdefined("attributes.is_pozisyon_tipi")>#get_upper.position_cat#<br/></cfif>
									<cfif isdefined("attributes.is_unvan")>#get_upper.title#<br/></cfif>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			 </table>
		</td>
	</tr>
		<tr><td style="text-align:center;" height="<cfoutput>#ilk_kademe_eklentisi + cizgi_yuksekligi+30#</cfoutput>"><img src="/images/cizgi_dik_1pix.gif" height="<cfoutput>#ilk_kademe_eklentisi + cizgi_yuksekligi + 30#</cfoutput>" width="3"></td></tr>
	</table>
</div>
</cfoutput>
<cfset my_top_eklenti = my_top_eklenti + ilk_kademe_eklentisi + 30>

<cfif attributes.tasarim_tipi neq 3 or (attributes.alt_cizim_sayisi neq 1 and attributes.tasarim_tipi eq 3)>
<div id="yatay_cizgi_top" style="position:absolute;z-index:5;width:2px;height:3px;left:20px;top:<cfoutput>#10+cizgi_yuksekligi+kutu_yuksekligi+my_top_eklenti-2#</cfoutput>px;"><img src="/images/cizgi_yan_1pix.gif" width="100%" height="3"></div>
</cfif>
<cfset last_hie = 0>

<cfif listlen(position_agac_list)>
	<cfquery name="get_pos_agac" dbtype="query">
		SELECT 
			* 
		FROM 
			get_all_position 
		WHERE 
			POSITION_CODE IN (#position_agac_list#) 
			<cfif not isdefined("attributes.is_critical")>AND IS_CRITICAL <> 1</cfif>
			<cfif not isdefined("attributes.is_empty_pos")>AND EMPLOYEE_ID > 0</cfif>
	</cfquery>
	<cfset position_agac_list = listsort(valuelist(get_pos_agac.position_code),'numeric','ASC',',')>
	
	<cfset upper_list = "">
	<cfloop list="#position_agac_list#" index="ck">
			<cfscript>
			agac_up_pos_code = evaluate("get_pos_agac.#amir_tipi#[listfind(position_agac_list,ck,',')]");
			if(not listfindnocase(upper_list,agac_up_pos_code))
				upper_list = listappend(upper_list,agac_up_pos_code);
			</cfscript>
	</cfloop>
</cfif>

<cfset group_hie_ = 1> 
<cfloop query="get_all_workgroup_roles_ters">
	<cfif listlen(get_all_workgroup_roles_ters.YENI_HIERARCHY,'.') gt group_hie_>
		<cfset group_hie_ = listlen(get_all_workgroup_roles_ters.YENI_HIERARCHY,'.')>
	</cfif>
</cfloop>


<cfif listlen(silinecek_upper_list)>
	<cfset m = 0>
	<cfloop list="#silinecek_upper_list#" index="cmm">
		<cfset m = m + 1>
		<cfif isdefined("altlar_#cmm#")>
			<cfset 'altlar_#cmm#' = listappend(evaluate("altlar_#cmm#"),listgetat(silinecek_list2,m))>
		<cfelse>
			<cfset 'altlar_#cmm#' = "#listgetat(silinecek_list2,m)#">
		</cfif>
	</cfloop>
</cfif>

<cfset kurmay_eklenti_var = 0>
<cfif attributes.is_kademe neq 1>
	<cfloop from="1" to="#group_hie_#" index="mmm">
		<cfset 'kurmay_eklentisi_#mmm#' = 0>
	</cfloop>
	
	<cfloop from="1" to="#group_hie_+5#" index="kkm">
		<cfif kkm eq 1>
			<cfset 'asama_top_#kkm#' = ((1 * kutu_yuksekligi)+10)+my_top_eklenti + cizgi_yuksekligi>
			
		<cfelse>
			<cfset 'asama_top_#kkm#' = kutu_yuksekligi + evaluate("asama_top_#kkm-1#") + (cizgi_yuksekligi/2)>
		</cfif>
	</cfloop>
	
	<cfif listlen(position_kademe_list)>
		<cfloop from="1" to="#group_hie_#" index="ccn">
			<cfoutput query="get_all_workgroup_roles2">
				<cfset x_ = listlen(yeni_hierarchy,'.')>
					<cfif x_ eq ccn>
						<cfquery name="get_my_k" dbtype="query">
							SELECT * FROM get_all_position WHERE POSITION_CODE IN (#position_kademe_list#) AND (#amir_tipi# = #position_code# <cfif isdefined("altlar_#position_code#")>OR #amir_tipi# IN (#evaluate("altlar_#position_code#")#)</cfif>)
						</cfquery>
						<cfif get_my_k.recordcount and get_my_k.recordcount gt evaluate("kurmay_eklentisi_#ccn#")>
							<cfset 'kurmay_eklentisi_#ccn#' = ceiling(get_my_k.recordcount/2) * kutu_yuksekligi - 25>
							<cfset kurmay_eklenti_var = 1>
						</cfif>
					</cfif>
			</cfoutput>
		</cfloop>
	</cfif>
	
	<cfset siram = 0>
	<cfloop from="1" to="#group_hie_+5#" index="llc">
			<cfset siram = siram + 1>
			<cfset ek_ = 0>
				<cfloop from="1" to="#siram#" index="mnc">
					<cfif isdefined("kurmay_eklentisi_#mnc#")>
						<cfset ek_ = ek_ + evaluate("kurmay_eklentisi_#mnc#")>
					</cfif>
				</cfloop>
			<cfif isdefined("asama_top_#siram+1#")>
				<cfset 'asama_top_#siram+1#' = evaluate("asama_top_#siram+1#") + ek_>
			</cfif>
	</cfloop>
</cfif>


<cfif isdefined("attributes.is_fonksiyonel") and attributes.baglilik eq 1>
	<!--- fonksiyonel tesbiti --->
	<cfset fonksiyonel_upper_list = valuelist(get_all_workgroup_roles2.position_code)>
	<cfif listlen(fonksiyonel_upper_list)>
		<cfquery name="get_fonksiyonel_all" datasource="#dsn#">
		SELECT 
			EMPLOYEE_POSITIONS.IS_VEKALETEN,
			EMPLOYEE_POSITIONS.IS_CRITICAL,
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.POSITION_ID,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			EMPLOYEE_POSITIONS.UPPER_POSITION_CODE,
			EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2,
			SETUP_POSITION_CAT.POSITION_CAT,
			SETUP_TITLE.TITLE
		FROM 
			EMPLOYEE_POSITIONS,
			
			SETUP_POSITION_CAT,
			SETUP_TITLE
		WHERE
			EMPLOYEE_POSITIONS.IS_ORG_VIEW = 1 AND
			EMPLOYEE_POSITIONS.TITLE_ID = SETUP_TITLE.TITLE_ID AND
			EMPLOYEE_POSITIONS.POSITION_CAT_ID = SETUP_POSITION_CAT.POSITION_CAT_ID 
			AND (EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 IN (#fonksiyonel_upper_list#)
			<cfif listlen(silinecek_list2)>OR EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 IN (#silinecek_list2#)</cfif>)
		</cfquery>
	</cfif>
	<cfif listlen(fonksiyonel_upper_list) and get_fonksiyonel_all.recordcount>
		<cfset fonksiyoneli_olanlar = valuelist(get_fonksiyonel_all.UPPER_POSITION_CODE2)>
	</cfif>
	<!--- fonksiyonel tesbiti --->
</cfif>
<cfoutput query="get_all_workgroup_roles2">
	<cfif len(employee_id)>
		<cfset emp_id_ = employee_id>
	<cfelse>
		<cfset emp_id_ = 0>
	</cfif>
	#draw_div(position_id,last_hie,currentrow,yeni_hierarchy,emp_id_,POSITION_NAME,title,position_cat,employee_name,employee_surname,position_code,is_critical,is_vekaleten,step_no,upper_step_no)#
	<cfset last_hie = listlen(get_all_workgroup_roles2.yeni_hierarchy,'.')>
</cfoutput>


<cfif isdefined("fonksiyoneli_olanlar")>
<cfset cizilen_fonk_list = ''>
<!--- fonksiyonel cizimleri --->
<cfloop list="#fonksiyoneli_olanlar#" index="kk">
		<cfif listfindnocase(silinecek_list2,kk)>
			<cfset my_upper_ = listgetat(silinecek_upper_list,listfindnocase(silinecek_list2,kk))>
		<cfelse>
			<cfset my_upper_ = kk>
		</cfif>
		<cfoutput>
		<cfquery name="get_alt_eleman_fonk" dbtype="query" maxrows="1">
			SELECT * FROM get_fonksiyonel_all WHERE UPPER_POSITION_CODE2 = #kk#
		</cfquery>
		<cfif get_alt_eleman_fonk.recordcount and not listfindnocase(cizilen_fonk_list,kk)>
			<cfset cizilen_fonk_list = listappend(cizilen_fonk_list,kk)>
			<div id="fonksiyonel_#my_upper_#" align="center" style="position:absolute;z-index:2;width:#kutu_genisligi+30#;height:#kutu_yuksekligi#px;left:250px;top:10px;">
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="30"><img src="/images/cizgi_yan_1pix.gif" width="30" height="3"></td>
					<td valign="top" style="text-align:center;">
						<table cellpadding="0" cellspacing="0" width="100%">
							<cfloop query="get_alt_eleman_fonk">
								<cfif isdefined("attributes.is_resim")>
										<cfif listfindnocase(main_employee_list,get_alt_eleman_fonk.employee_id)>
											<cfset 'my_resim_#get_alt_eleman_fonk.position_id#' = "#get_resimler.PHOTO[listfind(main_employee_list,get_alt_eleman_fonk.employee_id,',')]#">
										</cfif>
								</cfif>
									<tr>
									<cfscript>
										div_spe = 'border: 1px';
										if(get_alt_eleman_fonk.EMPLOYEE_ID gt 0)div_spe = div_spe & ' solid';else div_spe = div_spe & ' dashed';
										if(get_alt_eleman_fonk.is_critical eq 1)div_spe = div_spe & ' red;';else div_spe = div_spe & ' ##666666';
									</cfscript>
									<td nowrap="nowrap" bgcolor="cccccc" style="#div_spe#;" style="text-align:center;" width="#kutu_genisligi#">
										<table width="100%">
											<tr>
												<cfif isdefined("attributes.is_resim") and isdefined("my_resim_#get_alt_eleman_fonk.position_id#") and len(evaluate("my_resim_#get_alt_eleman_fonk.position_id#"))>
														<td width="#resim_genisligi#"><img src="/documents/hr/#evaluate("my_resim_#get_alt_eleman_fonk.position_id#")#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td>
												<cfelseif isdefined("attributes.is_resim")> 
														<td width="#resim_genisligi#">&nbsp;</td>
												</cfif>
												<td style="text-align:center;" height="#kutu_yuksekligi - cizgi_yuksekligi + 15#">
												<cfif isdefined("attributes.is_pozisyon")>#get_alt_eleman_fonk.position_name#<br/></cfif>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_alt_eleman_fonk.EMPLOYEE_ID#','medium');" class="tableyazi">#get_alt_eleman_fonk.employee_name# #get_alt_eleman_fonk.employee_surname#</a><br/>
												<cfif isdefined("attributes.is_pozisyon_tipi")>#get_alt_eleman_fonk.position_cat#<br/></cfif>
												<cfif isdefined("attributes.is_unvan")>#get_alt_eleman_fonk.title#<br/></cfif>
												</td>
											</tr>
										</table>
									</td>
									</tr>
							</cfloop>
						</table>
					</td>
				</tr>
			</table>
			</div>
			</cfif>
		</cfoutput>
				<cfif get_alt_eleman_fonk.recordcount>
					<script type="text/javascript">
						<cfoutput>
								<cfset baz_layer = "tablo_#my_upper_#">
								document.getElementById('fonksiyonel_#my_upper_#').style.top = parseInt(document.getElementById('#baz_layer#').style.top) + 'px';
								document.getElementById('fonksiyonel_#my_upper_#').style.left = parseInt(document.getElementById('#baz_layer#').style.left) + #kutu_genisligi# + 'px';
						</cfoutput>
					</script>
				</cfif>
	</cfloop>
<!--- fonksiyonel cizimleri --->
</cfif>


<!--- tasarim_tipi agac ise buraya son kademeler cizilmeyecek tipki alt kademeler gibi sonradan cizilecek --->
<cfset top_deger = 0>
<cfloop query="get_all_workgroup_roles_ters">
	<cfif get_all_workgroup_roles_ters.currentrow eq 1>
		<cfset toplam_height = (listlen(get_all_workgroup_roles_ters.yeni_hierarchy,'.') * kutu_yuksekligi) + (listlen(get_all_workgroup_roles_ters.yeni_hierarchy,'.') * 25) + kutu_yuksekligi + 15 + my_top_eklenti + (kutu_genisligi-25)>
	</cfif>
		
	<cfset my_layer_eklenti = 0>
	<cfquery name="get_group_ozel" dbtype="query">
		SELECT * FROM get_all_workgroup_roles_ters WHERE POSITION_ID <> #get_all_workgroup_roles_ters.POSITION_ID# AND YENI_HIERARCHY LIKE '#get_all_workgroup_roles_ters.yeni_hierarchy#.%' ORDER BY YENI_HIERARCHY DESC
	</cfquery>
	<cfset group_hie = listlen(get_all_workgroup_roles_ters.YENI_HIERARCHY,'.')>
	<cfset ust_id = get_all_workgroup_roles_ters.position_id>
	<cfset ozel_list = 0>
	<cfset my_wrk_id = ''>
	<cfset my_first_wrk_id = ''>
	<cfloop query="get_group_ozel">
		<cfif get_group_ozel.currentrow eq get_group_ozel.recordcount>
			<cfset my_first_wrk_id = '#get_group_ozel.position_id#'>
		</cfif>
		<cfif (listlen(get_group_ozel.YENI_HIERARCHY,'.') - group_hie) eq 1>
			<cfif ozel_list eq 0>
				<cfif attributes.tasarim_tipi eq 3 and listlen(get_group_ozel.YENI_HIERARCHY,'.') eq attributes.alt_cizim_sayisi>
					<div id="yatay_cizgi_<cfoutput>#ust_id#</cfoutput>" style="style:display:none;position:absolute;z-index:2;width:1;height:3px;left:20px;top:<cfoutput>#cizgi_yuksekligi+my_top_eklenti#</cfoutput>px;"></div>
				<cfelse>
					<div id="yatay_cizgi_<cfoutput>#ust_id#</cfoutput>" style="position:absolute;z-index:2;width:1;height:3px;left:20px;top:<cfoutput>#cizgi_yuksekligi+my_top_eklenti#</cfoutput>px;"><img src="/images/cizgi_yan_1pix.gif" width="100%" height="3"></div>
				</cfif>
				<cfset my_wrk_id = '#get_group_ozel.position_id#'>
			</cfif>
			<cfset ozel_list = ozel_list + 1>
		</cfif>
	</cfloop>
		<cfif ozel_list>
			<script type="text/javascript">
				my_yeni_sayi = <cfoutput>#ozel_list#</cfoutput>;
				my_j_layer_eklenti = <cfoutput>#my_layer_eklenti#</cfoutput>;
				my_top_eklenti = <cfoutput>#my_top_eklenti#</cfoutput>;
				my_sag_son = <cfoutput>parseInt(document.getElementById('cizim_#my_wrk_id#').style.left) + #kutu_genisligi#</cfoutput>;
				my_top = <cfoutput>parseInt(document.getElementById('cizim_#my_wrk_id#').style.top) - <cfoutput>#kutu_genisligi - 25#</cfoutput></cfoutput>;
				my_left_bas = my_sag_son - ((my_yeni_sayi * <cfoutput>#kutu_genisligi#</cfoutput>) + ((my_yeni_sayi-1)*25));
				my_second_left = parseInt(document.getElementById('cizim_<cfoutput>#my_first_wrk_id#</cfoutput>').style.left);
				
				if(my_yeni_sayi==1)
					my_orta = my_left_bas;
				else
					my_orta = ((my_sag_son + my_left_bas) / 2)-(<cfoutput>#kutu_genisligi/2#</cfoutput>);
					
				document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left = my_orta + 'px';
				
				<cfif isdefined("fonksiyoneli_olanlar") and (listfindnocase(fonksiyoneli_olanlar,ust_id) or listfindnocase(silinecek_upper_list,ust_id))>
					document.getElementById('fonksiyonel_<cfoutput>#ust_id#</cfoutput>').style.left = my_orta + <cfoutput>#kutu_genisligi#</cfoutput> + 'px';
				</cfif>
		
				document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.left = my_second_left+(<cfoutput>#kutu_genisligi/2#</cfoutput>) + 'px';
				if(my_yeni_sayi>1)
					document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.width = my_sag_son - my_second_left - <cfoutput>#kutu_genisligi#</cfoutput> + 'px';
				  document.getElementById('yatay_cizgi_<cfoutput>#ust_id#</cfoutput>').style.top = parseInt(document.getElementById('cizim_<cfoutput>#my_first_wrk_id#</cfoutput>').style.top) + 'px';
			</script>
		</cfif>
		<cfif (top_deger eq 0) and (group_hie eq my_default_hie)>
			<cfset top_deger = 1>
			<script type="text/javascript">
				my_top_cizgi_son = parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left);
			</script>
		</cfif>
		<cfif get_all_workgroup_roles_ters.currentrow eq 1>
			<cfset son_hie = listfirst(get_all_workgroup_roles_ters.yeni_hierarchy,'.')>
			<cfquery name="get_group_ilk" dbtype="query">
				SELECT * FROM get_all_workgroup_roles_ters WHERE YENI_HIERARCHY = '#son_hie#'
			</cfquery>
			<cfset my_son_ust_grup_id = get_group_ilk.position_id>
		</cfif>
		<cfif get_all_workgroup_roles_ters.currentrow eq get_all_workgroup_roles_ters.recordcount>
			<script type="text/javascript">
				document.getElementById('yatay_cizgi_top').style.left = <cfoutput>parseInt(document.getElementById('cizim_#ust_id#').style.left) + (#kutu_genisligi/2#)</cfoutput> + 'px';
				<cfif listlen(ilk_alt_kademeler) gt 1>
					document.getElementById('main_group').style.left = ((<cfoutput>#my_son_left#</cfoutput> - parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left)) / 2) + parseInt(document.getElementById('cizim_<cfoutput>#ust_id#</cfoutput>').style.left) - (<cfoutput>#kutu_genisligi/2#</cfoutput>) + 'px';
				<cfelse>
					document.getElementById('main_group').style.left = parseInt(document.getElementById('cizim_<cfoutput>#listfirst(ilk_alt_kademeler)#</cfoutput>').style.left) + 'px';
				</cfif>
				<cfif isdefined("get_upper_1.recordcount")>
					document.getElementById('main_group_1').style.left = parseInt(document.getElementById('main_group').style.left) + 'px';
				</cfif>
				<cfif isdefined("get_upper_2.recordcount")>
					document.getElementById('main_group_2').style.left = parseInt(document.getElementById('main_group').style.left) + 'px';
				</cfif>
				document.getElementById('yatay_cizgi_top').style.width = (parseInt(document.getElementById('cizim_<cfoutput>#my_son_ust_grup_id#</cfoutput>').style.left) + (<cfoutput>#kutu_genisligi/2#</cfoutput>)) - (parseInt(document.getElementById('yatay_cizgi_top').style.left)) + 'px';
			</script>
		</cfif>
</cfloop>

<!--- agac_cizimleri --->
<cfif listlen(position_agac_list)>
	<cfloop list="#upper_list#" index="uk">
		<cfoutput>
		<cfquery name="get_alt_eleman" dbtype="query">
			SELECT * FROM get_pos_agac WHERE #amir_tipi# = #uk#
		</cfquery>
		<cfquery name="get_upper_id" dbtype="query">
			SELECT POSITION_ID FROM get_all_position WHERE POSITION_CODE = #uk#
		</cfquery>
		<cfset this_upper_pos_id_ = get_upper_id.POSITION_ID>
			<div id="agac_#uk#" align="center" style="position:absolute;z-index:2;width:#kutu_genisligi * 2#;height:#get_alt_eleman.recordcount * kutu_yuksekligi#px;left:250px;top:10px;">
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td valign="top" style="text-align:center;">
						<table cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<td colspan="2"></td>
								<td style="text-align:center;"><img src="/images/cizgi_yan_1pix.gif" width="3" height="#cizgi_yuksekligi#"></td>
								<td colspan="2" width="#22 + kutu_genisligi#"></td>
							</tr>
							<cfset mck = 0>
							<cfloop query="get_alt_eleman">
								<cfset mck = mck + 1>
								<cfif isdefined("attributes.is_resim")>
										<cfif listfindnocase(main_employee_list,get_alt_eleman.employee_id)>
											<cfset 'my_resim_#get_alt_eleman.position_id#' = "#get_resimler.PHOTO[listfind(main_employee_list,get_alt_eleman.employee_id,',')]#">
										</cfif>
								</cfif>
								<cfif (mck mod 2) eq 1 or mck eq 1>
									<tr>
								</cfif>
									<cfif (mck mod 2) eq 0><td width="15"><img src="/images/cizgi_yan_1pix.gif" width="15" height="3"></td></cfif>
									<cfscript>
										div_spe = 'border: 1px';
										if(get_alt_eleman.EMPLOYEE_ID gt 0)div_spe = div_spe & ' solid';else div_spe = div_spe & ' dashed';
										if(get_alt_eleman.is_critical eq 1)div_spe = div_spe & ' red;';else div_spe = div_spe & ' ##666666';
									</cfscript>
									<td style="text-align:center;#div_spe#;" width="#kutu_genisligi#">
										<table width="100%">
											<tr>
												<cfif isdefined("attributes.is_resim") and isdefined("my_resim_#get_alt_eleman.position_id#") and len(evaluate("my_resim_#get_alt_eleman.position_id#"))>
														<td width="#resim_genisligi#"><img src="/documents/hr/#evaluate("my_resim_#get_alt_eleman.position_id#")#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td>
												<cfelseif isdefined("attributes.is_resim")> 
														<td width="#resim_genisligi#">&nbsp;</td>
												</cfif>
												<td height="#kutu_yuksekligi - cizgi_yuksekligi + 15#" style="text-align:center;">
												<cfif isdefined("attributes.is_pozisyon")>#get_alt_eleman.position_name#<br/></cfif>
												<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_alt_eleman.EMPLOYEE_ID#','medium');" class="tableyazi">#get_alt_eleman.employee_name# #get_alt_eleman.employee_surname#</a><br/>
												<cfif isdefined("attributes.is_pozisyon_tipi")>#get_alt_eleman.position_cat#<br/></cfif>
												<cfif isdefined("attributes.is_unvan")>#get_alt_eleman.title#<br/></cfif>
												</td>
											</tr>
										</table>
									</td>
									<cfif (mck mod 2) eq 1>
										<td width="22"><img src="/images/cizgi_yan_1pix.gif" width="22" height="3"></td>
										<td style="text-align:center;" width="1"><img src="/images/cizgi_yan_1pix.gif" width="3" height="#kutu_yuksekligi - cizgi_yuksekligi + 22#"></td>
									</cfif>
								<cfif (mck mod 2) eq 0 or get_alt_eleman.recordcount eq mck>
									</tr>
									<cfif get_alt_eleman.recordcount neq mck>
										<tr>
										<td colspan="2"></td>
										<td style="text-align:center;" height="5"><img src="/images/cizgi_yan_1pix.gif" width="3" height="5"></td>
										<td colspan="2"></td>
										</tr>
									</cfif>
								</cfif>
							</cfloop>
						</table>
					</td>
				</tr>
			</table>
			</div>
		</cfoutput>
		
		<script type="text/javascript">
			<cfoutput>
				<cfif attributes.alt_cizim_sayisi gt 1>
					<cfset baz_layer = "cizim_#this_upper_pos_id_#">
					document.getElementById('agac_#uk#').style.top = parseInt(document.getElementById('#baz_layer#').style.top) + parseInt(document.getElementById('#baz_layer#').style.height) + 'px';
					document.getElementById('agac_#uk#').style.left = parseInt(document.getElementById('#baz_layer#').style.left) - (#kutu_genisligi / 2#) - 25 + 'px';
				<cfelse>
					<cfset baz_layer = "main_group">
					document.getElementById('agac_#uk#').style.top = parseInt(document.getElementById('#baz_layer#').style.top) + parseInt(document.getElementById('#baz_layer#').style.height) + #ilk_kademe_eklentisi# + 30 + 'px';
					document.getElementById('agac_#uk#').style.left = parseInt(document.getElementById('#baz_layer#').style.left) - (#kutu_genisligi/2#) - 24 + 'px';
				</cfif>
			</cfoutput>
		</script>
	</cfloop>
</cfif>

<!--- agac_cizimleri --->


<!--- ana kisi yandan_bagli_cizimleri --->
<cfif listlen(position_kademe_list)>
	<cfoutput>
				<cfset kk = ilk_amir>
				<cfquery name="get_alt_eleman" dbtype="query">
					SELECT * FROM get_pos_kademe WHERE #amir_tipi# = #kk#
				</cfquery>
				<cfif get_alt_eleman.recordcount>
					<div id="kademe_#kk#" align="center" style="position:absolute;z-index:2;width:#(kutu_genisligi * 2) + 42#px;height:#ceiling(get_alt_eleman.recordcount/2) * kutu_yuksekligi#px;left:250px;top:10px;">
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td valign="top" style="text-align:center;">
								<table cellpadding="0" cellspacing="0" width="100%">
									<cfset mck = 0>
									<cfloop query="get_alt_eleman">
										<cfset mck = mck + 1>
										<cfif isdefined("attributes.is_resim")>
												<cfif listfindnocase(main_employee_list,get_alt_eleman.employee_id)>
													<cfset 'my_resim_#get_alt_eleman.position_id#' = "#get_resimler.PHOTO[listfind(main_employee_list,get_alt_eleman.employee_id,',')]#">
												</cfif>
										</cfif>
										<cfif (mck mod 2) eq 1 or mck eq 1>
											<tr>
										</cfif>
											<cfif (mck mod 2) eq 0><td width="15"><img src="/images/cizgi_yan_1pix.gif" width="15" height="3"></td></cfif>
											<cfscript>
												div_spe = 'border: 1px';
												if(get_alt_eleman.EMPLOYEE_ID gt 0)div_spe = div_spe & ' solid';else div_spe = div_spe & ' dashed';
												if(get_alt_eleman.is_critical eq 1)div_spe = div_spe & ' red;';else div_spe = div_spe & ' ##666666';
											</cfscript>
											<td bgcolor="f5f5f5" style="#div_spe#;text-align:center;" width="#kutu_genisligi#">
												<table width="100%">
													<cfif isdefined("attributes.is_resim") and attributes.tasarim_tipi eq 2 and isdefined("my_resim_#get_alt_eleman.position_id#") and len(evaluate("my_resim_#get_alt_eleman.position_id#"))>
															<tr><td width="#resim_genisligi#"><img src="/documents/hr/#evaluate("my_resim_#get_alt_eleman.position_id#")#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td></tr>
													<cfelseif isdefined("attributes.is_resim") and attributes.tasarim_tipi eq 2> 
															<tr><td width="#resim_genisligi#">&nbsp;</td></tr>
													</cfif>
													<tr>
														<cfif isdefined("attributes.is_resim") and attributes.tasarim_tipi neq 2 and isdefined("my_resim_#get_alt_eleman.position_id#") and len(evaluate("my_resim_#get_alt_eleman.position_id#"))>
																<td width="#resim_genisligi#"><img src="/documents/hr/#evaluate("my_resim_#get_alt_eleman.position_id#")#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td>
														<cfelseif isdefined("attributes.is_resim") and attributes.tasarim_tipi neq 2> 
																<td width="#resim_genisligi#">&nbsp;</td>
														</cfif>
														<td style="text-align:center;" height="#kutu_yuksekligi - cizgi_yuksekligi + 15#">
														<cfif isdefined("attributes.is_pozisyon")>#get_alt_eleman.position_name#<br/></cfif>
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_alt_eleman.EMPLOYEE_ID#','medium');" class="tableyazi">#get_alt_eleman.employee_name# #get_alt_eleman.employee_surname#</a><br/>
														<cfif isdefined("attributes.is_pozisyon_tipi")>#get_alt_eleman.position_cat#<br/></cfif>
														<cfif isdefined("attributes.is_unvan")>#get_alt_eleman.title#<br/></cfif>
														</td>
													</tr>
												</table>
											</td>
											<cfif (mck mod 2) eq 1>
												<td width="22"><img src="/images/cizgi_yan_1pix.gif" width="22" height="3"></td>
												<td style="text-align:center;" width="1"><img src="/images/cizgi_yan_1pix.gif" width="3" height="#kutu_yuksekligi - cizgi_yuksekligi + 22#"></td>
											</cfif>
										<cfif (mck mod 2) eq 0 or get_alt_eleman.recordcount eq mck>
											<cfif get_alt_eleman.recordcount eq mck and (mck mod 2) eq 1>
												<td></td>
												<td nowrap="nowrap" width="#kutu_genisligi#">&nbsp;</td>
											</cfif>
											</tr>
											<cfif get_alt_eleman.recordcount neq mck>
												<tr>
												<td colspan="2"></td>
												<td style="text-align:center;" height="5"><img src="/images/cizgi_yan_1pix.gif" width="3" height="5"></td>
												<td colspan="2"></td>
												</tr>
											</cfif>
										</cfif>
									</cfloop>
								</table>
							</td>
						</tr>
					</table>
					</div>
				</cfif>
				</cfoutput>
		<cfif get_alt_eleman.recordcount>
		<script type="text/javascript">
			<cfoutput>
					<cfset baz_layer = "main_group">
					document.getElementById('kademe_#kk#').style.top = parseInt(document.getElementById('#baz_layer#').style.top) + parseInt(document.getElementById('#baz_layer#').style.height)+2 + 'px';
					document.getElementById('kademe_#kk#').style.left = parseInt(document.getElementById('#baz_layer#').style.left) - (#kutu_genisligi / 2#) - 24 + 'px';
			</cfoutput>
		</script>
		</cfif>
		
</cfif>
<!--- ana kisi yandan_bagli_cizimleri --->

<!--- yandan_bagli_cizimleri --->
<cfif listlen(position_kademe_list)>
	<cfloop list="#kademe_upper_list#" index="kk">
				<cfquery name="get_alt_eleman" dbtype="query">
					SELECT * FROM get_pos_kademe WHERE #amir_tipi# = #kk# <cfif isdefined("altlar_#kk#")>OR #amir_tipi# IN (#evaluate("altlar_#kk#")#)</cfif>
				</cfquery>
				<cfif get_alt_eleman.recordcount>
				<cfoutput>
					<div id="kademe_#kk#" align="center" style=" position:absolute;z-index:2;width:#kutu_genisligi * 2#;height:#ceiling(get_alt_eleman.recordcount/2) * kutu_yuksekligi#px;left:250px;top:10px;">
					<table cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td valign="top" style="text-align:center;">
								<table cellpadding="0" cellspacing="0" width="100%">
									<cfset mck = 0>
									<cfloop query="get_alt_eleman">
										<cfset mck = mck + 1>
										<cfif isdefined("attributes.is_resim")>
												<cfif listfindnocase(main_employee_list,get_alt_eleman.employee_id)>
													<cfset 'my_resim_#get_alt_eleman.position_id#' = "#get_resimler.PHOTO[listfind(main_employee_list,get_alt_eleman.employee_id,',')]#">
												</cfif>
										</cfif>
										<cfif (mck mod 2) eq 1 or mck eq 1>
											<tr>
										</cfif>
											<cfif (mck mod 2) eq 0><td width="15"><img src="/images/cizgi_yan_1pix.gif" width="15" height="3"></td></cfif>
											<cfscript>
												div_spe = 'border: 1px';
												if(get_alt_eleman.EMPLOYEE_ID gt 0)div_spe = div_spe & ' solid';else div_spe = div_spe & ' dashed';
												if(get_alt_eleman.is_critical eq 1)div_spe = div_spe & ' red;';else div_spe = div_spe & ' ##666666';
											</cfscript>
											<td nowrap="nowrap" bgcolor="f5f5f5" style="#div_spe#;text-align:center;" width="#kutu_genisligi#">
												<table width="100%">
													<cfif isdefined("attributes.is_resim") and attributes.tasarim_tipi eq 2 and isdefined("my_resim_#get_alt_eleman.position_id#") and len(evaluate("my_resim_#get_alt_eleman.position_id#"))>
															<tr><td width="#resim_genisligi#"><img src="/documents/hr/#evaluate("my_resim_#get_alt_eleman.position_id#")#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td></tr>
													<cfelseif isdefined("attributes.is_resim") and attributes.tasarim_tipi eq 2> 
															<tr><td width="#resim_genisligi#">&nbsp;</td></tr>
													</cfif>
													<tr>
														<cfif isdefined("attributes.is_resim") and attributes.tasarim_tipi neq 2 and isdefined("my_resim_#get_alt_eleman.position_id#") and len(evaluate("my_resim_#get_alt_eleman.position_id#"))>
																<td width="#resim_genisligi#"><img src="/documents/hr/#evaluate("my_resim_#get_alt_eleman.position_id#")#" height="#resim_yuksekligi#" width="#resim_genisligi#"></td>
														<cfelseif isdefined("attributes.is_resim") and attributes.tasarim_tipi neq 2> 
																<td width="#resim_genisligi#">&nbsp;</td>
														</cfif>
														<td style="text-align:center;" height="#kutu_yuksekligi - cizgi_yuksekligi + 15#">
														<cfif isdefined("attributes.is_pozisyon")>#get_alt_eleman.position_name#<br/></cfif>
														<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_alt_eleman.EMPLOYEE_ID#','medium');" class="tableyazi">#get_alt_eleman.employee_name# #get_alt_eleman.employee_surname#</a><br/>
														<cfif isdefined("attributes.is_pozisyon_tipi")>#get_alt_eleman.position_cat#<br/></cfif>
														<cfif isdefined("attributes.is_unvan")>#get_alt_eleman.title#<br/></cfif>
														</td>
													</tr>
												</table>
											</td>
											<cfif (mck mod 2) eq 1>
												<td width="22"><img src="/images/cizgi_yan_1pix.gif" width="22" height="3"></td>
												<td style="text-align:center;" width="1"><img src="/images/cizgi_yan_1pix.gif" width="3" height="#kutu_yuksekligi - cizgi_yuksekligi + 22#"></td>
											</cfif>
										<cfif (mck mod 2) eq 0 or get_alt_eleman.recordcount eq mck>
											<cfif get_alt_eleman.recordcount eq mck and (mck mod 2) eq 1>
												<td></td>
												<td nowrap="nowrap" width="#kutu_genisligi#">&nbsp;</td>
											</tr></cfif>
											
											<cfif get_alt_eleman.recordcount neq mck>
												<tr>
												<td colspan="2"></td>
												<td style="text-align:center;" height="5"><img src="/images/cizgi_yan_1pix.gif" width="3" height="5"></td>
												<td colspan="2"></td>
												</tr>
											</cfif>
										</cfif>
									</cfloop>
								</table>
							</td>
						</tr>
					</table>
					</div>
				</cfoutput>
				<script type="text/javascript">
					<cfoutput>
							<cfset baz_layer = "cizim_#kk#">
							document.getElementById('kademe_#kk#').style.top = parseInt(document.getElementById('#baz_layer#').style.top) + parseInt(document.getElementById('#baz_layer#').style.height)+2 + 'px';
							document.getElementById('kademe_#kk#').style.left = parseInt(document.getElementById('#baz_layer#').style.left) - (#kutu_genisligi / 2#) - 24 + 'px';
					</cfoutput>
				</script>
				</cfif>
	</cfloop>
</cfif>
<!--- yandan_bagli_cizimleri --->
</cfsavecontent>
<cfoutput>#sema_icerik#</cfoutput>
<table cellspacing="0" cellpadding="0" width="100%" border="0" style="text-align:center;">
<tr class="color-border">
<td>
		<table cellspacing="1" cellpadding="2" width="100%" border="0">
			<tr class="color-row">
				<td>
					<table>
						<cfform action="#request.self#?fuseaction=hr.emptypopup_sve_hierrchy_drwing">
						<tr>
							<td class="formbold"><cf_get_lang dictionary_id ='56726.Şema Kaydet'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<td><cf_get_lang dictionary_id ='56727.Şema Adı'>*</td>
							<cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56728.Çizim Adı Girmelisiniz'></cfsavecontent>
							<td><cfinput type="text" value="" name="draw_name" required="yes" message="#alert#"></td>
							<td><textarea name="draw_icerik" id="draw_icerik" style="width:1px;height:1px;display:none;"><cfoutput>#sema_icerik#</cfoutput></textarea>
                            	<input type="text" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput> <cf_get_lang dictionary_id ='56732.Tarihli Pozisyon Şeması'>" style="width:250px;" name="draw_detail" id="draw_detail" maxlength="500"></td>
							<td><cf_workcube_buttons is_upd='0' type_format="1"></td>
						</tr>
						</cfform>
					</table>					
				</td>
			</tr>
		</table>
</td>
	</tr>
</table>
