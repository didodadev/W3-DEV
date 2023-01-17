<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.employee_id = attributes.iid>
<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
	SELECT 
        E.EMPLOYEE_SURNAME,
        E.EMPLOYEE_NAME,
        E.IZIN_DATE,
        OC.NICK_NAME,
        B.BRANCH_ADDRESS,
        EIO.SOCIALSECURITY_NO,
        EIO.START_DATE,
        EIO.FINISH_DATE,
        EI.TC_IDENTY_NO,
        EI.BIRTH_DATE
    FROM
        EMPLOYEES E
        LEFT JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
        LEFT JOIN BRANCH B ON EIO.BRANCH_ID = B.BRANCH_ID
        LEFT JOIN OUR_COMPANY OC ON OC.COMP_ID = B.COMPANY_ID
        LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
    WHERE
        E.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
        AND EIO.START_DATE = (SELECT MAX(START_DATE) FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">)
</cfquery>
<cfif get_employee.recordcount>
	<cfquery name="get_progress_payment_outs" datasource="#dsn#">
        SELECT * FROM EMPLOYEE_PROGRESS_PAYMENT_OUT WHERE EMP_ID = #attributes.employee_id# AND START_DATE IS NOT NULL AND FINISH_DATE IS NOT NULL AND IS_YEARLY = 1
    </cfquery>
	<!--- çalışma saati başlangıç ve bitişleri al--->
    <cfquery name="get_work_time" datasource="#dsn#">
        SELECT 
            PROPERTY_VALUE,
            PROPERTY_NAME
        FROM
            FUSEACTION_PROPERTY
        WHERE
            OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            FUSEACTION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="ehesap.form_add_offtime_popup"> AND
            (PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="start_hour_info"> OR
            PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="start_min_info"> OR
            PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="finish_hour_info"> OR
            PROPERTY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="finish_min_info">
            )	
    </cfquery>
    <cfif get_work_time.recordcount>
        <cfloop query="get_work_time">	
            <cfif property_name eq 'start_hour_info'>
                <cfset start_hour = property_value>
            <cfelseif property_name eq 'start_min_info'>
                <cfset start_min = property_value>
            <cfelseif property_name eq 'finish_hour_info'>
                <cfset finish_hour = property_value>
            <cfelseif property_name eq 'finish_min_info'>
                <cfset finish_min = property_value>
            </cfif>
        </cfloop>
    <cfelse>
        <cfset start_hour = '00'>
        <cfset start_min = '00'>
        <cfset finish_hour = '00'>
        <cfset finish_min = '00'>
    </cfif>
	<cfquery name="GET_GENERAL_OFFTIMES" datasource="#DSN#">
        SELECT START_DATE,FINISH_DATE,IS_HALFOFFTIME FROM SETUP_GENERAL_OFFTIMES
    </cfquery>
    
	<cfquery name="GET_OFFTIMES" datasource="#dsn#">
    	SELECT 
            OFFTIME.*,
            SETUP_OFFTIME.OFFTIMECAT_ID,
            SETUP_OFFTIME.OFFTIMECAT,
            SETUP_OFFTIME.IS_PAID
        FROM 
            OFFTIME,
            SETUP_OFFTIME
        WHERE
        <cfif len(get_employee.izin_date)>
            OFFTIME.STARTDATE > <cfqueryparam cfsqltype="cf_sql_date" value="#get_employee.izin_date#"> AND
        </cfif>
            SETUP_OFFTIME.OFFTIMECAT_ID=OFFTIME.OFFTIMECAT_ID AND
            OFFTIME.IS_PUANTAJ_OFF = 0 AND
            OFFTIME.VALID = 1 AND
            SETUP_OFFTIME.IS_PAID = 1 AND
            SETUP_OFFTIME.IS_YEARLY = 1 AND
            EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
        ORDER BY
            STARTDATE DESC
    </cfquery>
    
    <cfset offday_list = ''>
    <cfset halfofftime_list = ''><!--- yarım gunluk izin kayıtları--->
    
    <cfoutput query="get_general_offtimes">
		<cfscript>
            offday_gun = datediff('d',get_general_offtimes.start_date,get_general_offtimes.finish_date)+1;
            offday_startdate = date_add("h", session.ep.time_zone, get_general_offtimes.start_date); 
            offday_finishdate = date_add("h", session.ep.time_zone, get_general_offtimes.finish_date);
            
            for (mck=0; mck lt offday_gun; mck=mck+1)
            {
                temp_izin_gunu = date_add("d",mck,offday_startdate);
                daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
                if(not listfindnocase(offday_list,'#daycode#'))
                    offday_list = listappend(offday_list,'#daycode#');
                if(get_general_offtimes.is_halfofftime is 1 and dayofweek(temp_izin_gunu) neq 1) //pazar haricindeki yarım günlük izin günleri sayılsın
                {
                    halfofftime_list = listappend(halfofftime_list,'#daycode#');
                }
            }
        </cfscript>
    </cfoutput>
    
    <cfquery name="get_hours" datasource="#dsn#">
        SELECT		
            OUR_COMPANY_HOURS.WEEKLY_OFFDAY
        FROM
            OUR_COMPANY_HOURS
        WHERE
            OUR_COMPANY_HOURS.DAILY_WORK_HOURS > 0 AND
            OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS > 0 AND
            OUR_COMPANY_HOURS.SSK_WORK_HOURS > 0 AND
            OUR_COMPANY_HOURS.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
    </cfquery>
    <cfif len(get_hours.recordcount) and len(get_hours.weekly_offday)>
		<cfset this_week_rest_day_ = get_hours.weekly_offday>
    <cfelse>
        <cfset this_week_rest_day_ = 1>
    </cfif>
<!------>    
<cfoutput>
<table cellSpacing="0" cellpadding="0" border="0" width="750" align="center">
	<tr bgcolor="##FFFFFF">
        <td>#get_employee.nick_name#</td>
    </tr>
    <tr bgcolor="##FFFFFF">
        <td>#get_employee.branch_address#</td>
    </tr>
    <tr bgcolor="##FFFFFF"><td>&nbsp;</td></tr>
	<tr>
    	<td>
        	<table cellspacing="1" cellpadding="2">
            	<tr bgcolor="##CCCCCC">
                	<td align="center" colspan="6" height="20"><strong><font color="##000066">YILLIK  ÜCRETLİ İZİN  DEFTERİ</font></strong></td>
              	</tr>
                <tr bgcolor="##FFFFFF">
					<td height="20" colspan="6"></td>
				</tr>
                <tr bgcolor="##CCCCCC">
					<td colspan="6" height="20"><strong><font color="##000066">İŞÇİNİN</font></strong></td>
				</tr>
                <tr bgcolor="##FFFFFF">
					<td width="70"><b><cf_get_lang_main no='1138.Soyadı'>:</b></td>
					<td width="200">#get_employee.employee_surname#</td>
                    <td width="100"><b>SSK No :</b></td>
					<td width="200">#get_employee.socialsecurity_no#</td>
                    <td width="100"><b><cf_get_lang no='1458.işe Giriş Tarihi'>:</b></td>
					<td width="270">#dateformat(get_employee.start_date,dateformat_style)#</td>
				</tr>
                <tr bgcolor="##FFFFFF">
                	<td width="70"><b><cf_get_lang_main no='485.Adı'>:</b></td>
					<td width="200">#get_employee.employee_name#</td>
                    <td width="100"><b><cf_get_lang_main no='613.TC Kimlik No'>:</b></td>
					<td width="200">#get_employee.tc_identy_no#</td>
                    <td width="100"><b><cf_get_lang_main no='1641.Çıkış Tarihi'>:</b></td>
					<td width="270">#dateformat(get_employee.finish_date,dateformat_style)#</td>
              	</tr>
                <tr bgcolor="##FFFFFF">
					<td height="20" colspan="6"></td>
				</tr>
            </table>
        </td>
    </tr>
    <tr>
    	<td>
        	<style type="text/css">
            	.borderCol td {
					border:1px solid ##000000;
					padding:2px;
					text-align:center;
				}
				.tableVert,.tableVert2 {
				   height:150px;
				   width:70px;
                }
                .tableVert strong {
				   /* IE6-8 Values: 0, 1, 2, 3 for 0, 90, 180 or 270 degress respectively */ 
				   filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1); 
				   -ms-transform: rotate(-90deg);  /* Microsoft - Internet Explorer 9 */ 
				   -moz-transform: rotate(-90deg);  /* Mozilla - Firefox 3.5+ */ 
				   -o-transform: rotate(-90deg);  /* Opera 10.5+ */ 
				   -webkit-transform: rotate(-90deg); /* Chrome, Safari */ 
				   transform: rotate(-90deg);   /* W3C - not really reqd yet */
				   margin-left:-40px;
				   margin-top:35px;
				   position:absolute;
				   width:100px;
                }
                .tableVert2 strong {
				   /* IE6-8 Values: 0, 1, 2, 3 for 0, 90, 180 or 270 degress respectively */ 
				   filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1); 
				   -ms-transform: rotate(-90deg);  /* Microsoft - Internet Explorer 9 */ 
				   -moz-transform: rotate(-90deg);  /* Mozilla - Firefox 3.5+ */ 
				   -o-transform: rotate(-90deg);  /* Opera 10.5+ */ 
				   -webkit-transform: rotate(-90deg); /* Chrome, Safari */ 
				   transform: rotate(-90deg);   /* W3C - not really reqd yet */
				   margin-left:-65px;
				   margin-top:-13px;
				   position:absolute;
				   width:150px;
                }
            </style>
        	<table cellpadding="0" cellspacing="0" class="borderCol">
            	<tr bgcolor="##CCCCCC">
                	<td rowspan="2"><strong>Yılı</strong></td>
                    <td rowspan="2"><strong>Bir Yıl Önceki İzin Hakkını Kazandığı Tarih</strong></td>
                    <td colspan="6"><strong>Bir Yıllık Çalışma Süresi İçinde Çalışılmayan Gün Sayısı</strong></td>
                    <td rowspan="2"><strong>İzine Hak Kazandığı Tarih</strong></td>
                    <td rowspan="2"><strong>İşyerindeki Kıdemi</strong></td>
                    <td rowspan="2"><strong>İzin Süresi</strong></td>
                    <td rowspan="2"><strong>Yol İzni</strong></td>
                    <td rowspan="2"><strong>İzine Başlangıç Tarihi</strong></td>
                    <td rowspan="2"><strong>İzinden Dönüş Tarihi</strong></td>
                    <td rowspan="2"><strong>İşçinin İmzası</strong></td>
                    <td rowspan="2" class="tableVert"><strong>Gün Sayısı</strong></td>
                    <td rowspan="2" class="tableVert"><strong>Genel Tatil</strong></td>
                    <td rowspan="2" class="tableVert"><strong>Kullanılan</strong></td>
                    <td rowspan="2" class="tableVert"><strong>Kalan</strong></td>
              	</tr>
                <tr bgcolor="##CCCCCC">
                    <td class="tableVert2"><strong>Hastalık</strong></td>
                    <td class="tableVert2"><strong><cf_get_lang no='534.Askerlik'></strong></td>
                    <td class="tableVert2"><strong>Zorunluluk Hali</strong></td>
                    <td class="tableVert2"><strong><cf_get_lang no='1807.Devamsızlık'></strong></td>
                    <td class="tableVert2"><strong>Hizmete Ara Verme</strong></td>
                    <td class="tableVert2"><strong>Diğer Nedenler</strong></td>
                </tr>
                <cfif get_offtimes.recordcount>
                	<cfscript>
						tck = 0;
						toplam_hakedilen_izin = 0;
						my_giris_date = get_employee.izin_date;
						flag = true;
						baslangic_tarih_ = my_giris_date;
						while(flag)
						{
							bitis_tarihi_ = createodbcdatetime(date_add("yyyy",1,baslangic_tarih_));
							baslangic_tarih_ = createodbcdatetime(baslangic_tarih_);
							get_bos_zaman_ = cfquery(Datasource="#dsn#",dbtype="query",sqlstring="SELECT * FROM get_progress_payment_outs WHERE (START_DATE <= #baslangic_tarih_# AND FINISH_DATE >= #baslangic_tarih_#) OR (START_DATE >= #baslangic_tarih_# AND FINISH_DATE <= #bitis_tarihi_#) OR ((START_DATE BETWEEN #baslangic_tarih_# AND #bitis_tarihi_#) AND FINISH_DATE >= #bitis_tarihi_#)");	
							
							if(get_bos_zaman_.recordcount eq 0)
							{
								tck = tck + 1; 
								kontrol_date = bitis_tarihi_;
								get_offtime_limit=cfquery(datasource="#dsn#",sqlstring="SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #baslangic_tarih_# AND FINISHDATE >= #baslangic_tarih_#");	
								
								if(get_offtime_limit.recordcount)
								{
									if(tck lte get_offtime_limit.limit_1)
										eklenecek = get_offtime_limit.limit_1_days;
									else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
										eklenecek = get_offtime_limit.limit_2_days;
									else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
										eklenecek = get_offtime_limit.limit_3_days;
									else 
										eklenecek = get_offtime_limit.limit_4_days;
										
									if(len(get_employee.birth_date) and eklenecek lt get_offtime_limit.min_max_days and (datediff("yyyy",get_employee.birth_date,kontrol_date) lt get_offtime_limit.min_years or datediff("yyyy",get_employee.birth_date,kontrol_date) gt get_offtime_limit.max_years))
									{
										eklenecek = get_offtime_limit.min_max_days;
									}
									if(tck neq 1 and eklenecek neq 0) 
									{
										toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
									}
								}
							}
							else
							{												
								eklenecek_gun = 0;
								for(izd = 1; izd lte get_bos_zaman_.recordcount; izd=izd+1)
								{
									if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) gt 0)
									{
										fark_ = datediff("d",baslangic_tarih_,get_bos_zaman_.finish_date[izd]);
									}
									else if(datediff("d",get_bos_zaman_.start_date[izd],baslangic_tarih_) lte 0)
									{
										fark_ = datediff("d",get_bos_zaman_.start_date[izd],get_bos_zaman_.finish_date[izd]);
									}
									eklenecek_gun = eklenecek_gun + fark_;
								}
								bitis_tarihi_ = date_add("d",eklenecek_gun,bitis_tarihi_);
			
								tck = tck + 1; 
								kontrol_date = bitis_tarihi_;
								get_offtime_limit=cfquery(datasource="#dsn#",sqlstring="SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= #bitis_tarihi_# AND FINISHDATE >= #bitis_tarihi_#");	
								if(get_offtime_limit.recordcount)
								{
									if(tck lte get_offtime_limit.limit_1)
										eklenecek = get_offtime_limit.limit_1_days;
									else if(tck gt get_offtime_limit.limit_1 and tck lte get_offtime_limit.limit_2)
										eklenecek = get_offtime_limit.limit_2_days;
									else if(tck gt get_offtime_limit.limit_2 and tck lte get_offtime_limit.limit_3)
										eklenecek = get_offtime_limit.limit_3_days;
									else 
										eklenecek = get_offtime_limit.limit_4_days;
										
									if(len(get_employee.birth_date) and eklenecek lt get_offtime_limit.min_max_days and (datediff("yyyy",get_employee.birth_date,kontrol_date) lt get_offtime_limit.MIN_YEARS or datediff("yyyy",get_employee.birth_date,kontrol_date) gt get_offtime_limit.MAX_YEARS) )
										eklenecek = get_offtime_limit.min_max_days;
									if(tck neq 1 and eklenecek neq 0) 
									{
										toplam_hakedilen_izin = toplam_hakedilen_izin + eklenecek;
									}
								}
							}	
							ilk_tarih_ = baslangic_tarih_;
							baslangic_tarih_ = bitis_tarihi_;
							bitis_tarihi_ = date_add("yyyy",1,bitis_tarihi_);
							if(datediff("yyyy",bitis_tarihi_,now()) lt 0)				
							{
								flag = false;
							}
						}
						kalan = toplam_hakedilen_izin;
					</cfscript>
                    <cfloop query="GET_OFFTIMES">
                    	<cfquery name="get_offtime_cat" datasource="#dsn#" maxrows="1">
                            SELECT * FROM SETUP_OFFTIME_LIMIT WHERE STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_offtimes.startdate#">  AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_offtimes.startdate#">
                        </cfquery>
                        <cfif get_offtime_cat.recordcount and len(get_offtime_cat.day_control)>
                            <cfset day_control_ = get_offtime_cat.day_control>
                        <cfelse>
                            <cfset day_control_ = 0>
                        </cfif>
                        <cfif len(get_employee.izin_date)>
                            <cfset kidem=datediff('d',get_employee.izin_date,get_offtimes.startdate)>
                        <cfelse>
                            <cfset kidem=0>
                        </cfif>
                        <cfset kidem_yil=kidem/365>
                        <cfscript>
                            temporary_sunday_total = 0;
                            temporary_offday_total = 0;
                            temporary_halfday_total = 0;
                            temporary_halfofftime = 0;
                            total_izin = round(finishdate-startdate)+1;
                            if(total_izin lte 0) total_izin=1;
                            izin_startdate = date_add("h", session.ep.time_zone, get_offtimes.startdate); 
                            izin_finishdate = date_add("h", session.ep.time_zone, get_offtimes.finishdate);
                            fark = 0;
                            fark2 = 0;
                            if(dateformat(izin_startdate,dateformat_style) eq dateformat(izin_finishdate,dateformat_style))
                            {
                                fark = fark+datediff("n",timeformat(izin_startdate,timeformat_style),timeformat(izin_finishdate,timeformat_style));
                                fark = fark/60;
                            }
                            else
                            {
                                if(timeformat(izin_startdate,timeformat_style) gt timeformat('#start_hour#:#start_min#',timeformat_style))
                                {
                                    fark = fark+datediff("n",timeformat(izin_startdate,timeformat_style),timeformat('#finish_hour#:#finish_min#',timeformat_style));
                                    fark = fark/60;
                                }
                                else 
                                {
                                    fark = fark+datediff("n",timeformat(izin_startdate,timeformat_style),timeformat('#start_hour#:#start_min#',timeformat_style));
                                    fark = fark/60;
                                }
                                fark2 = fark2+datediff("n",timeformat('#start_hour#:#start_min#',timeformat_style),timeformat(izin_finishdate,timeformat_style));
                                fark2 = fark2/60;
                            }
                            if(fark gt 0 and fark lte day_control_)
                            {
                                temporary_halfday_total = temporary_halfday_total + 1;
                            }
                            if(fark2 gt 0 and fark2 lte day_control_)
                            {
                                temporary_halfday_total = temporary_halfday_total + 1;
                            }
                            for (mck=0; mck lt total_izin; mck=mck+1)
                            {
                                temp_izin_gunu = date_add("d",mck,izin_startdate);
                                daycode = '#dateformat(temp_izin_gunu,dateformat_style)#';
                                if (dayofweek(temp_izin_gunu) eq this_week_rest_day_)
                                    temporary_sunday_total = temporary_sunday_total + 1;
                                else if (dayofweek(temp_izin_gunu) eq 7 and saturday_on eq 0)
                                    temporary_sunday_total = temporary_sunday_total + 1;
                                else if(listfindnocase(offday_list,'#daycode#'))
                                    temporary_offday_total = temporary_offday_total + 1;
                                //else if(daycode is '#dateformat(dateadd("h",session.ep.time_zone,get_offtime.finishdate),dateformat_style)#' and day_control_ gt 0 and timeformat(dateadd("h",session.ep.time_zone,get_offtime.finishdate),'HH') lt day_control_)
                                    //temporary_halfday_total = temporary_halfday_total + 1;
                                if(listlen(halfofftime_list) and listfind(halfofftime_list,'#daycode#')) //yarım günlük genel tatiller
                                {	
                                    temporary_halfofftime = temporary_halfofftime + 1; 
                                }
                            
                            }
                            if(get_offtimes.is_paid neq 1 and get_offtimes.ebildirge_type_id neq 21) // ucretli isaretli degilse ve bildirge karşılığı diger ücretsiz izinden farklı ise genel tatil ve hafta tatili dusulmez  
                            {
                                izin_gun = total_izin - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime);
                            }
                            else
                            {
                                izin_gun = total_izin - temporary_sunday_total - temporary_offday_total - (0.5 * temporary_halfday_total) + (0.5 * temporary_halfofftime);
                            }
                        </cfscript>
                        <tr>
                            <td align="center">#year(startdate)#</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td align="center"><cfif len(get_offtimes.deserve_date)>#dateformat(get_offtimes.deserve_date,dateformat_style)#</cfif></td>
                            <td align="center">#Int(kidem_yil)#</td>
                            <td align="center">#total_izin#</td>
                            <td></td>
                            <td align="center">#dateformat(izin_startdate,dateformat_style)#</td>
                            <td align="center">#dateformat(izin_finishdate,dateformat_style)#</td>
                            <td></td>
                            <td align="center">#total_izin#</td>
                            <td align="center">#temporary_offday_total#</td>
                            <td align="center">#izin_gun#</td>
                            <cfset kalan = kalan - izin_gun>
                            <td align="center">#kalan#</td>
                        </tr>
                    </cfloop>
                </cfif>
            </table>
        </td>
    </tr>
</table>
</cfoutput>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
