<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
<cfif not isdefined('attributes.uploaded_file')>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box title="#getLang('','İşe Giriş Aktarım','42825')#">
            <cfform name="formimport" action="#request.self#?fuseaction=ehesap.import_employee_position_in" enctype="multipart/form-data" method="post">
                <cf_box_elements>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-file_format">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43385.Belge Formatı'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <select name="file_format" id="file_format">
                                    <option value="UTF-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-file">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <input type="file" name="uploaded_file" id="uploaded_file">
                            </div>
                        </div>          
                        <div class="form-group" id="item-example_file">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <a  href="/IEF/standarts/import_example_file/ise_giris_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
                            </div>
                        </div>   
                        <div class="form-group" id="item-process">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
                            <div class="col col-6 col-md-8 col-sm-8 col-xs-12">
                                <cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
                            </div>
                        </div>                                                                
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true"> 
                        <div class="form-group" id="item-format">
                            <label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
                        </div>   
                        <div class="form-group" id="item-exp1">
                            <cf_get_lang dictionary_id ='35657.Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>
                        </div>    
                        <div class="form-group" id="item-exp2">
                            <cf_get_lang dictionary_id ='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.
                        </div>       
                        <div class="form-group" id="item-exp2">
                            <cf_get_lang dictionary_id="44381.Belgede toplam 21 alan olacaktır alanlar sırasi ile">;<br/><br/>
                        </div>          
                        <div class="form-group" id="item-exp2">
                            1- <cf_get_lang dictionary_id="58025.Tc Kimlik No">*<br/>
                            2- <cf_get_lang dictionary_id="57572.Departman"> <cf_get_lang dictionary_id="58527.Id">*<br />
                            3- <cf_get_lang dictionary_id="55716.Ücret Tipi"> (<cf_get_lang dictionary_id="58544.Sabit"> =0, <cf_get_lang dictionary_id="56430.Primli">=1)<br />
                            4- <cf_get_lang dictionary_id="56435.Brüt / Net">*  (<cf_get_lang dictionary_id="38990.Brüt">=0,<cf_get_lang dictionary_id="58083.Net">=1)<br />
                            5- <cf_get_lang dictionary_id="53554.Ücret Yönetimi">* (<cf_get_lang dictionary_id="57491.Saat">= 0, <cf_get_lang dictionary_id="57490.Gün">=1, <cf_get_lang dictionary_id="58724.Ay">=2)<br />
                            6- <cf_get_lang dictionary_id="56407.SGK Statüsü">(<cf_get_lang dictionary_id="32287.Normal">=1,<cf_get_lang dictionary_id="58541.Emekli">=2)<br />
                            7- <cf_get_lang dictionary_id="58650.Puantaj"> (<cf_get_lang dictionary_id="53653.Puantaja Gelmesin">=1, <cf_get_lang dictionary_id="59627.Puantaja Gelsin">=0) <br />
                            8- <cf_get_lang dictionary_id="58538.Görev Tipi">(<cf_get_lang dictionary_id="53550.İşveren">=0,<cf_get_lang dictionary_id="56405.İşveren Vekili">=1,<cf_get_lang dictionary_id="30368.Çalışan">=2,<cf_get_lang dictionary_id="55892.Sendikalı">=3,<cf_get_lang dictionary_id="55893.Sözleşmeli">=4,<cf_get_lang dictionary_id="55894.Kapsam Dışı">=5,<cf_get_lang dictionary_id="53182.Kısmi istihdam">=6, <cf_get_lang dictionary_id="53199.Taşeron">=7)<br />
                            9- <cf_get_lang dictionary_id="58714.SGK">(<cf_get_lang dictionary_id="54046.Sgk'lı çalışan"> =1, <cf_get_lang dictionary_id="54047.SGK sız çalışan"> =0)<br />
                            10- <cf_get_lang dictionary_id="55663.SGK No"><br />
                            11- <cf_get_lang dictionary_id="59628.Tahsis No"><br />
                            12- <cf_get_lang dictionary_id="56403.Sendika No"><br />
                            13- <cf_get_lang dictionary_id="59629.PDKS Bağlılık Tipi">(<cf_get_lang dictionary_id="53210.Bağlı Değil">=0,<cf_get_lang dictionary_id="53207.Bağlı">=1,<cf_get_lang dictionary_id="53229.Tam Bağlı"> <cf_get_lang dictionary_id="57491.Saat">=2,<cf_get_lang dictionary_id="53229.Tam Bağlı"> <cf_get_lang dictionary_id="57490.Gün">=3,<cf_get_lang dictionary_id="38806.Vardiya Sistemi">=4)<br />
                            14- <cf_get_lang dictionary_id="56887.PDKS No"><br />
                            15- <cf_get_lang dictionary_id="29489.PDKS Tipi"><br />
                            16- <cf_get_lang dictionary_id="56566.Vardiya Tipi"><br />
                            17- <cf_get_lang dictionary_id="49909.Kurumsal Üye"><br />
                            18- <cf_get_lang dictionary_id="59614.Meslek Kodu (4220.05 şeklinde kod olarak girilmelidir.)"><br />
                            19- <cf_get_lang dictionary_id="59630.İşe Giriş Tarihi dd.mm.yyyy formatında olmalıdır"><br />
                            20- <cf_get_lang dictionary_id="59631.İşten Çıkış Tarihi dd.mm.yyyy formatında olmalıdır"><br />
                            21- <cf_get_lang dictionary_id="59632.İşten Çıkış Gerekçe Id"> :<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    (<cf_get_lang dictionary_id="59635.Toplu İşçi Çıkarma">>=1,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59636.Belirsiz Süreli İş Sözleşmesinin İşçi Tarafından Feshi">=2,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59636.Malülen Emeklilik Nedeniyle">=3,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="33549.Emeklilik"> (<cf_get_lang dictionary_id="59637.Yaşlılık veya Toptan Ödeme Nedeniyle">)=4,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="40507.Ölüm">=5,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="34639.Askerlik">=6,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="35037.Kadın Sigortalının Evlenmesi">=7,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    (4857 16)<cf_get_lang dictionary_id="40510.İşe Ara Verme">(<cf_get_lang dictionary_id="40511.Zorunlu Nedenler">)= 8,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59638.İşveren Tarafından Sağlık Nedeni İle Fesih">=9,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59639.İşçi Tarafından İşverenin Ahlak ve İyiniyet Kurallarına Aykırı Davranması Nedeni İle Fesih">=10,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="40513.Disiplin Kurulu Kararı İle Fesih"> = 11,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    (4857 25-2)<cf_get_lang dictionary_id="40514.Devamsızlık">=12,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    (4857 17)<cf_get_lang dictionary_id="40510.İşe Ara Verme">(<cf_get_lang dictionary_id="40511.Zorunlu Nedenler">)=13,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59640.İşçi Tarafından Sağlık Nedeniyle Fesih">=14,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59641.İşveren Tarafından İşçinin Ahlak ve İyiniyet Kurallarına Aykırı Davranması Nedeni İle Fesih">=15,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59642.Kaldırılan Çıkış Maddesi">=16,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="40515.İşin Sona Ermesi"> = 17,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="55510.Nakil">=18,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="40517.İşyerinin Kapanması">=19,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="40518.Vize Süresinin Bitimi"> / <cf_get_lang dictionary_id="59644.İş Akdinin Askıya Alınması Halinde"> = 20,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59645.Deneme Süreli İş Sözleşmesinin İşçi Tarafından Feshi">=21,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="40519.Mevsim Bitimi">=22,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="40520.Kampanya Bitimi">=23,</br>&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="40521.Statü Değişikliği">=24,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59646.Deneme Süreli İş Sözleşmesinin İşverence Feshi">=25,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="35067.Belirsiz Süreli İş Sözleşmesinin İşveren Tarafından Feshi">=26,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="35077.Belirli Süreli İş Sözleşmesinin Sona Ermesi">=27,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="35232.Diğer Nedenler">=28,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59648.Emeklilik İçin Yaş Dışında Diğer Şartların Tamamlanması">=29,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="35066.İş Sözleşmesinin Haklı Nedenlerle İşçi Tarafından Feshi">=30,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="35065.İş Sözleşmesinin Haklı Nedenlerle İşverence Feshi">=31,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59649.İş Kazası Sonucu Ölüm">=32,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59650.İşçi Tarafından Zorunlu Nedenle Fesih">=33,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59651.İşveren Tarafından Zorunlu Nedenlerle ve Tutukluluk Nedeniyle Fesih">=34,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59652.Borçlar Kanunu,Sendikalar Kanunu,Grev ve Lokavt Kanunu Kapsamında Kendi İstek ve Kusuru Dışında Fesih">=35,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59653.4046 Sayılı Kanunun 21. Maddesine Göre Özelleştirme Nedeniyle Fesih">=36,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59654.Gazeteci Tarafından Sözleşmenin Feshi">=37,<br />&nbsp;&nbsp;&nbsp;&nbsp;
                                    <cf_get_lang dictionary_id="59655.İşyerinin Devri, İşin veya İşyerinin Niteliğinin Değişmesi Nedeniyle Fesih">=38)                            
                        </div>                        
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </cf_box_footer>
            </cfform>
        </cf_box>
    </div>
	<script type="text/javascript">
		function kontrol()
		{
			if(formimport.uploaded_file.value.length==0)
			{
				alert("<cf_get_lang dictionary_id='43424.Belge Seçmelisiniz'>!");
				return false;
			}
				return true;
		}
	</script>
<cfelse>
	<cfsetting showdebugoutput="no">
	<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
				filefield = "uploaded_file" 
				destination = "#upload_folder_#"
				nameconflict = "MakeUnique"  
				mode="777" charset="#attributes.file_format#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="#attributes.file_format#">	
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='57455.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	<cftry>
		<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="#attributes.file_format#">
		<cffile action="delete" file="#upload_folder_##file_name#">
	<cfcatch>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>.");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
	</cftry>
    <cfquery name="GET_BUSINESS_CODES" datasource="#DSN#">
        SELECT	
            BUSINESS_CODE_ID,
            BUSINESS_CODE,
            BUSINESS_CODE_NAME 
        FROM 
            SETUP_BUSINESS_CODES 
        ORDER BY
            BUSINESS_CODE_NAME
    </cfquery>	

	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
		counter = 0;
		liste = "";
	</cfscript>
	<cfloop from="2" to="#line_count#" index="i">
		<cfset j= 1>
		<cfset error_flag = 0>
		<cftry>
			<cfscript>
			counter = counter + 1;
			//tckimlik_no
			tckimlik_no = Listgetat(dosya[i],j,";");
			tckimlik_no =trim(tckimlik_no);
			j=j+1;
			
			//department id
			department_id = Listgetat(dosya[i],j,";");
			department_id =trim(department_id);
			j=j+1;
			//ücret tipi
			sabit_prim = Listgetat(dosya[i],j,";");
			sabit_prim =trim(sabit_prim);
			j=j+1; 
			//brüt/net
			gross_net = Listgetat(dosya[i],j,";");
			gross_net =trim(gross_net);
			j=j+1; 
			//ücret yönetimi
			salary_type = Listgetat(dosya[i],j,";");
			salary_type =trim(salary_type);
			j=j+1; 
			//sgk statüs
			sgk_statu = Listgetat(dosya[i],j,";");
			sgk_statu =trim(sgk_statu);
			j=j+1; 
			//puantaj
			is_puantaj = Listgetat(dosya[i],j,";");
			is_puantaj =trim(is_puantaj);
			j=j+1; 
			//görev tipi
			duty_type = Listgetat(dosya[i],j,";");
			duty_type =trim(duty_type);
			j=j+1;
			//sgk durumu
			use_ssk = Listgetat(dosya[i],j,";");
			use_ssk =trim(use_ssk);
			j=j+1; 
			//ssk no
			socialsecurity_no = Listgetat(dosya[i],j,";");
			socialsecurity_no =trim(socialsecurity_no);
			j=j+1;
			//tahsis no
			retired_sgdp_number = Listgetat(dosya[i],j,";");
			retired_sgdp_number =trim(retired_sgdp_number);
			j=j+1;
			//sendika no
			trade_union_no = Listgetat(dosya[i],j,";");
			trade_union_no =trim(trade_union_no);
			j=j+1;
			//pdks bağlılık tipi
			use_pdks = Listgetat(dosya[i],j,";");
			use_pdks =trim(use_pdks);
			j=j+1;
			//pdks no
			pdks_number = Listgetat(dosya[i],j,";");
			pdks_number =trim(pdks_number);
			j=j+1;
			//pdks türü
			pdks_type_id = Listgetat(dosya[i],j,";");
			pdks_type_id =trim(pdks_type_id);
			j=j+1;
			//vardiya tipi
			shift_id = Listgetat(dosya[i],j,";");
			shift_id =trim(shift_id);
			j=j+1;
			//kurumsal üye
			duty_type_company_id = Listgetat(dosya[i],j,";");
			duty_type_company_id =trim(duty_type_company_id);
			j=j+1;
			
			//meslek kodu
			business_code_ = Listgetat(dosya[i],j,";");
			business_code_ =trim(business_code_);
			j=j+1;	
			//işe giriş tarihi
			start_date = Listgetat(dosya[i],j,";");
			start_date = trim(start_date);
			j=j+1;
			//işten çıkış tarihi
			finish_date = Listgetat(dosya[i],j,";");
			finish_date = trim(finish_date);
			j=j+1;
			//Gerekçe
			if(listlen(dosya[i],';') gte j)
			{
				explanation = Listgetat(dosya[i],j,";");
				explanation =trim(explanation);
			}
			else
				explanation='';
			j=j+1;
			//alanlar bitti
			</cfscript>
			<cfcatch type="Any">
				<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
				<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
				<cfset error_flag = 1>
			</cfcatch>
		</cftry>
        <cftry>
            <cfif len(tckimlik_no) and len(department_id) and len(start_date) and len(gross_net) and error_flag neq 1>
                <cfquery name="GET_EMPLOYEE_INFO" maxrows="1" datasource="#DSN#">
                    SELECT 
                        E.EMPLOYEE_ID
                    FROM
                        EMPLOYEES E,
                        EMPLOYEES_IDENTY EI
                    WHERE 
                        E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
                        EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tckimlik_no#">
                </cfquery>
                <cfquery name="GET_DEP_BRANCH" datasource="#DSN#">
                    SELECT 
                        BRANCH_ID
                    FROM 
                        DEPARTMENT
                    WHERE
                        DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">
                </cfquery>
                <cfset business_code_id_ = ''>
                <cfif len(business_code_) and get_business_codes.recordcount>
                    <cfquery name="GET_B_NAME" dbtype="query">
                        SELECT BUSINESS_CODE_ID FROM get_business_codes WHERE BUSINESS_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#business_code_#">
                    </cfquery>
                    <cfif get_b_name.recordcount>
                        <cfset business_code_id_ =  get_b_name.business_code_id>
                    </cfif>
                </cfif>
                <cfif get_employee_info.recordcount>
                    <cftry>
                        <cfquery datasource="#dsn#" name="ADD_POSITION_IN">
                            INSERT INTO 
                                EMPLOYEES_IN_OUT
                                    (
                                    BRANCH_ID,
                                    DEPARTMENT_ID,
                                    EMPLOYEE_ID,
                                    START_DATE,
                                    SALARY_TYPE,
                                    GROSS_NET,
                                    USE_PDKS,
                                    PDKS_NUMBER,
                                    PDKS_TYPE_ID,
                                    IS_5084,
                                    USE_SSK,
                                    SOCIALSECURITY_NO,
                                    RETIRED_SGDP_NUMBER,
                                    TRADE_UNION_NO,
                                    SSK_STATUTE,
                                    IS_PUANTAJ_OFF,
                                    SABIT_PRIM,
                                    IS_KISMI_ISTIHDAM,
                                    DEFECTION_LEVEL,
                                    DUTY_TYPE,
                                    SHIFT_ID,
                                    DUTY_TYPE_COMPANY_ID,
                                    FINISH_DATE,
                                    EXPLANATION_ID,
                                    VALID,
                                    VALID_DATE,
                                    VALID_EMP,
                                    BUSINESS_CODE_ID,
                                    IN_OUT_STAGE,
                                    RECORD_IP,
                                    RECORD_EMP,
                                    RECORD_DATE
                                    )
                                VALUES
                                    (
                                    <cfif len(get_dep_branch.branch_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_dep_branch.branch_id#"><cfelse>NULL</cfif>,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#department_id#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#get_employee_info.employee_id#">,
                                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(listgetat(start_date,3,'.'),listgetat(start_date,2,'.'),listgetat(start_date,1,'.'))#">,
                                    <cfif len(salary_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#salary_type#"><cfelse>NULL</cfif>,
                                    <cfif len(gross_net)><cfqueryparam cfsqltype="cf_sql_bit" value="#gross_net#"><cfelse>0</cfif>,
                                    <cfif len(use_pdks)><cfqueryparam cfsqltype="cf_sql_integer" value="#use_pdks#"><cfelse>0</cfif>,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#pdks_number#">,
                                    <cfif len(pdks_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#pdks_type_id#"><cfelse>NULL</cfif>,
                                    0,
                                    <cfif len(use_ssk)><cfqueryparam cfsqltype="cf_sql_bit" value="#use_ssk#"><cfelse>0</cfif>,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#socialsecurity_no#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#retired_sgdp_number#">,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#trade_union_no#">,
                                    <cfif len(sgk_statu)><cfqueryparam cfsqltype="cf_sql_integer" value="#sgk_statu#"><cfelse>NULL</cfif>, <!---1,--->
                                    <cfif len(is_puantaj)><cfqueryparam cfsqltype="cf_sql_bit" value="#is_puantaj#"><cfelse>NULL</cfif>,
                                    <cfif len(sabit_prim)><cfqueryparam cfsqltype="cf_sql_bit" value="#sabit_prim#"><cfelse>NULL</cfif>,
                                    0,
                                    0,
                                    <cfif len(duty_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#duty_type#"><cfelse>NULL</cfif>,
                                    <cfif len(shift_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#shift_id#"><cfelse>NULL</cfif>,
                                    <cfif len(duty_type_company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#duty_type_company_id#"><cfelse>NULL</cfif>,
                                    <cfif len(finish_date)>
                                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(listgetat(finish_date,3,'.'),listgetat(finish_date,2,'.'),listgetat(finish_date,1,'.'))#">,
                                        <cfif len(explanation)><cfqueryparam cfsqltype="cf_sql_integer" value="#explanation#"><cfelse>NULL</cfif>,
                                        1,
                                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                    <cfelse>
                                        NULL,
                                        NULL,
                                        0,
                                        NULL,
                                        NULL,
                                    </cfif>
                                    <cfif len(business_code_id_)><cfqueryparam cfsqltype="cf_sql_integer" value="#business_code_id_#"><cfelse>NULL</cfif>,
                                    <cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
                                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
                                    )
                        </cfquery>
                    <cfcatch type="Any">
                            <cfset liste=ListAppend(liste,i&'. satırda kayıt sırasında hata oldu <br/>',',')>
                            <cfoutput>#i#. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44948.İkinci adımda sorun oluştu'> : #cfcatch.Message#<br/></cfoutput>
                        </cfcatch>
                    </cftry>
                <cfelse>
                    <cfset liste=ListAppend(liste,i&'. satırın employee_id si yok <br/>',',')>
                </cfif>
            </cfif>
        <cfcatch type="Any">
            <cfset error_flag = 1>
        </cfcatch>
    </cftry>
        <cfoutput>#liste#</cfoutput>
        <cfif error_flag neq 1>
            <cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'>.
        </cfif>
	</cfloop>
    <script type="text/javascript">
        window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_employee_position_in';     
    </script><abort>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
