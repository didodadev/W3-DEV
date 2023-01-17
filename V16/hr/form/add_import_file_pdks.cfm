<cfparam name="attributes.is_puantaj_off" default="">
<cfparam name="attributes.paper_type" default="">
<cfscript>
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branch = cmp_branch.get_branch(status:1);
</cfscript>
<cf_box title="#getLang('','PDKS Import',56561)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="formimport" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=hr.import_file_pdks">
    	<cf_box_elements>
		<div class="row">
        	<div class="col col-12 uniqueRow">
            	<div class="row formContent">
                	<div class="row" type="row">
                    	<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                        	<div class="form-group" id="item-file">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
                                <div class="col col-8 col-xs-12"><input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;"></div>
                            </div>
                            <div class="form-group" id="item-branch_id">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                <div class="col col-8 col-xs-12">
                                    <select name="branch_id" id="branch_id" style="width:200px;">
										<option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
                                        <cfoutput query="get_branch">
                                        <option value="#get_branch.branch_id#">#get_branch.branch_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-paper_type">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58578.Belge Türü'>*</label>
                                <div class="col col-8 col-xs-12">
                                    <select name="paper_type" id="paper_type" style="width:200px;" onChange="type_gizle(); formatGoster(this.value, this.options[this.selectedIndex].text);">
                                        <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
										<option value="12">Workcube</option><!--- Standart --->
                                        <option value="1"><cf_get_lang dictionary_id ='35538.Multiport'></option><!--- Hedef için --->
                                        <option value="2"><cf_get_lang dictionary_id ='37756.XML Base'></option><!--- Mepa için --->
                                        <option value="3">ERK</option><!--- WRK için --->
                                        <option value="4">TXT File</option><!--- akay için --->
                                        <option value="5"><cf_get_lang dictionary_id ='35586.Toplu PDKS Giriş'></option>
                                        <option value="6"><cf_get_lang dictionary_id ='35579.Özgür Zaman'></option><!--- Workcube için --->
                                        <option value="7">Nideka X659 UTC</option><!--- Emra Metal için --->
                                        <option value="8">TA PDKS</option><!---  Teknik Aleminyum için --->
                                        <!--- <option value="9">PLN PDKS</option> Polin için --->
                                        <!--- <option value="10">TZCN PDKS</option> Tezcan için --->
                                        <!--- <option value="11">AAKT PDKS</option> Adnan Akat için --->
                                    </select>
                                </div>
                            </div>
                            <div<cfif not listfind("5",attributes.paper_type)> class="form-group" style="display:none"</cfif> id="puantaj_off">
                                <label class="col col-12"><input type="checkbox" name="is_puantaj_off" id="is_puantaj_off" value="1" <cfif attributes.is_puantaj_off eq 1>checked</cfif>><cf_get_lang dictionary_id="64706.Puantajı oluşturulan aylar için PDKS İmportu Yapılmasın"></label>
                            </div>
                            <div<cfif not listfind("5",attributes.paper_type)> class="form-group" style="display:none"</cfif> id="is_time_choice">
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id="37733.Günlere Saat Olarak Dağıt"></label>
                                <div class="col col-6 col-xs-12">
                                	<select name="time_choice" id="time_choice" style="width:100px;">
                                        <option value="7.5">7 <cf_get_lang dictionary_id="57491.Saat"> 30 <cf_get_lang dictionary_id="58827.Dk"> </option>
                                        <option value="8">8 <cf_get_lang dictionary_id="57491.Saat"></option>
                                        <option value="8.5">8 <cf_get_lang dictionary_id="57491.Saat"> 30 <cf_get_lang dictionary_id="58827.Dk"></option>
                                        <option value="9">9 <cf_get_lang dictionary_id="57491.Saat"></option>
                                        <option value="9.5">9 <cf_get_lang dictionary_id="57491.Saat"> 30 <cf_get_lang dictionary_id="58827.Dk"></option>
                                        <option value="10">10 <cf_get_lang dictionary_id="57491.Saat"></option>
                                        <option value="10.5">10 <cf_get_lang dictionary_id="57491.Saat"> 30 <cf_get_lang dictionary_id="58827.Dk"></option>
                                        <option value="11">11 <cf_get_lang dictionary_id="57491.Saat"></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12" type="column" sort="true" index="2">
                        	<div class="row col-12" id="tdFormat">
                            	<label class="hide"><cf_get_lang dictionary_id="37723.Belge Türü Açıklama"></label>
                            </div>
						</div>
                    </div>
                    <div class="row formContentFooter">
                    	<div class="col col-12">
                        	<cf_workcube_buttons is_upd='0' add_function='form_chk()'>
                        </div>
                    </div>
                </div>
            </div>
        </div>
	</cf_box_elements>
    </cfform>
</cf_box>
<div id="tanimlar" style="display:none;">
<div id="t1">
	<div style="font-family:Verdana, Geneva, sans-serif;">
		<cf_get_lang dictionary_id="35516.Dosya uzantısı txt olmalı ve alan araları boşluk ile ayrılmalıdır."> <cf_get_lang dictionary_id="35435.Aktarım işlemi dosyanın 1. satırından itibaren başlar, bu yüzden birinci
		satırda alan isimleri olmamalıdır.">
		<cf_get_lang dictionary_id="35508.Belgede toplam 4 alan olacaktır alanlar sırasi ile">:
			<br/><br/>
		1- <cf_get_lang dictionary_id="37701.Çalışanın PDKS No"><br/>
		2- <cf_get_lang dictionary_id="37686.Başlangıç Tarihi (gg.aa.yy formatında yazılmalıdır)"><br/>
		3- <cf_get_lang dictionary_id="30961.Başlangıç Saati"><br/>
		4- <cf_get_lang dictionary_id="59005.Şube Kodu">
	</div>
</div>

<div id="t2">
<div class="col col-12" style="font-family:Verdana, Geneva, sans-serif;">
<cf_get_lang dictionary_id="35645.Dosya uzantısı xml olmalıdır">. <cf_get_lang dictionary_id="35435.Aktarım işlemi dosyanın 1. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır">.
<cf_get_lang dictionary_id="35628.Belgede toplam 2 alan olacaktır alanlar sırasi ile">:
<br/><br/>
1- <cf_get_lang dictionary_id="37701.Çalışanın PDKS No"><br/>
2- <cf_get_lang dictionary_id="58053.Başlangıç Tarihi">
</div>
</div>

<div id="t3">
<div style="font-family:Verdana, Geneva, sans-serif;">
<cf_get_lang dictionary_id="35435.Aktarım işlemi dosyanın 1. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır."> <cf_get_lang dictionary_id="36516.Belgede toplam 7 alan olacaktır
alanlar sırasi ile">:
<br/><br/>
1- <cf_get_lang dictionary_id="37701.Çalışanın PDKS No"><br/>
2- <cf_get_lang dictionary_id="57490.Gün"><br/>
3- <cf_get_lang dictionary_id="58724.Ay"><br/>
4- <cf_get_lang dictionary_id="58455.Yıl"><br/>
5- <cf_get_lang dictionary_id="57491.Saat"><br/>
6- <cf_get_lang dictionary_id="58127.Dakika"><br/>
7- <cf_get_lang dictionary_id="58053.Başlangıç Tarihi">
</div>
</div>

<div id="t4">
<div style="font-family:Verdana, Geneva, sans-serif;">
<cf_get_lang dictionary_id="35516.Dosya uzantısı txt olmalı ve alan araları boşluk ile ayrılmalıdır"> <cf_get_lang dictionary_id="35435.Aktarım işlemi dosyanın 1. satırından itibaren başlar bu yüzden birinci
satırda alan isimleri olmamalıdır."> <cf_get_lang dictionary_id="35508.Belgede toplam 4 alan olacaktır alanlar sırasi ile">:
<br/><br/>
1-<cf_get_lang dictionary_id="30757.PDKS No"><br/>
2- <cf_get_lang dictionary_id="37686.Başlangıç Tarihi (gg.aa.yy formatında yazılmalıdır)"><br/>
3- <cf_get_lang dictionary_id="58053.Başlangıç Tarihi"><br/>
4- <cf_get_lang dictionary_id="59005.Şube Kodu">
</div>
</div>

<div id="t5">
<div style="font-family:Verdana, Geneva, sans-serif;">
<cf_get_lang dictionary_id="44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar bu
yüzden birinci satırda alan isimleri olmalıdır."> <cf_get_lang dictionary_id="35508.Belgede toplam 4 alan olacaktır alanlar sırasi ile">:
<br/><br/>
1- <cf_get_lang dictionary_id="58025.TC Kimlik No"><br/>
2- <cf_get_lang dictionary_id="47539.Çalışma Saati"><br/>
3- <cf_get_lang dictionary_id="58724.Ay"><br/>
4- <cf_get_lang dictionary_id="58455.Yıl">
</div>
</div>

<div id="t6">
<div style="font-family:Verdana, Geneva, sans-serif;">
<cf_get_lang dictionary_id="35693.Dosya uzantısı txt olmalı ve alan araları virgül (,) ile ayrılmalıdır."> <cf_get_lang dictionary_id="44338.Belgede toplam 5 alan olacaktır, alanlar sırasi ile">:
<br/><br/>
1- <cf_get_lang dictionary_id="35551.Cihaz numarası">: <cf_get_lang dictionary_id="35729.Cihaz numarası yoksa 001 girin">.<br/>
2- <cf_get_lang dictionary_id="37701.Çalışanın PDKS Numarası">.<br/>
3- <cf_get_lang dictionary_id="35725.Bu alana 1 (Bir) giriniz"><br/>
4- <cf_get_lang dictionary_id="57742.Tarih"><br/>
5- <cf_get_lang dictionary_id="57491.Saat">
</div>
</div>

<div id="t7">
<div style="font-family:Verdana, Geneva, sans-serif;">
<cf_get_lang dictionary_id="35693.Dosya uzantısı txt olmalı ve alan araları virgül (,) ile ayrılmalıdır."> <cf_get_lang dictionary_id="44338.Belgede toplam 5 alan olacaktır, alanlar sırasi ile">:
<br/><br/>
1- <cf_get_lang dictionary_id="35551.Cihaz numarası">: <cf_get_lang dictionary_id="35729.Cihaz numarası yoksa 001 girin">.<br/>
2- <cf_get_lang dictionary_id="37701.Çalışanın PDKS Numarası">.<br/>
3- <cf_get_lang dictionary_id="35725.Bu alana 1 (Bir) giriniz"><br/>
4- <cf_get_lang dictionary_id="57742.Tarih"><br/>
5- <cf_get_lang dictionary_id="57491.Saat">
</div>
</div>

<div id="t8">
<div style="font-family:Verdana, Geneva, sans-serif;">
<cf_get_lang dictionary_id="44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar bu
yüzden birinci satırda alan isimleri olmalıdır."> <cf_get_lang dictionary_id="37684.İmport dosyasına veriler saat formatında (SS:DD) girilmelidir."> <cf_get_lang dictionary_id="37683.İmport dosyasının
her satırı bir güne tekabül etmektedir.">
<cf_get_lang dictionary_id="44939.Belgede toplam 26 alan olacaktır. Alanlar sırası ile">:
<br/><br/>
1. <cf_get_lang dictionary_id="30757.PDKS No"><cf_get_lang dictionary_id='57998.veya'><cf_get_lang dictionary_id="58487.Çalışan no"> <br/>
2. <cf_get_lang dictionary_id="57897.Adı">: <cf_get_lang dictionary_id="44688.Çalışan adı"><br/>
3. <cf_get_lang dictionary_id="58550.Soyadı">: <cf_get_lang dictionary_id="44689.Çalışanın soyadı"><br/>
4. <cf_get_lang dictionary_id="57742.Tarih">: <cf_get_lang dictionary_id="37639.PDKS import işleminin kayıt atılacağı tarih. \GG.AA.YYYY\ şeklinde girilmelidir."><br/>
5. <cf_get_lang dictionary_id="37647.PK:Posta kodu (Boş bırakılabilir)"><br/>
6. <cf_get_lang dictionary_id="31474.Normal Gün">: <cf_get_lang dictionary_id="37636.Hafta içi normal çalışma saati"><br/>
7. <cf_get_lang dictionary_id="40514.Devamsızlık">: <cf_get_lang dictionary_id="37787.Devamsızlık adı altında açılmış izin kaydı oluşturacak."><br/>
8. <cf_get_lang dictionary_id="58867.Hafta Tatili">: <cf_get_lang dictionary_id="37935.Hafta Tatili alanına kayıt atacaktır."><br/>
9. <cf_get_lang dictionary_id="37764.SSK Gün">: <cf_get_lang dictionary_id="37776.SSK Saat Gün (Bu alan pasiftir. Sistem SGK Gününü"><br/>
10.<cf_get_lang dictionary_id="37931.Hafta içi Mesai">: <cf_get_lang dictionary_id="37835.Hafta içi mesai saati"><br/>
11.<cf_get_lang dictionary_id="54251.Gece Çalışması">: <cf_get_lang dictionary_id="37834.Gece çalışması saati"><br/>
12.<cf_get_lang dictionary_id="38348.Genel Tatil Mesaisi">: <cf_get_lang dictionary_id="38345.Genel tatil mesaisi saati"><br/>
13.<cf_get_lang dictionary_id="38339.Hafta sonu Mesaisi">: <cf_get_lang dictionary_id="38337.Hafta sonu mesaisi saati"><br/>
14.<cf_get_lang dictionary_id="53686.Ücretli İzin">: <cf_get_lang dictionary_id="38335.Ücretli izin adı altında açılmış izin kaydı oluşturmaktadır"><br/>
15.<cf_get_lang dictionary_id="43317.Ücretsiz İzin">: <cf_get_lang dictionary_id="38327.Ücretsiz izin adı altında açılmış izin kaydı oluşturmaktadır"><br/>
16.<cf_get_lang dictionary_id="58576.Vizite">: <cf_get_lang dictionary_id="38319.Vizite adı altında açılmış izin kaydı oluşturmaktadır"><br/>
17.<cf_get_lang dictionary_id="57434.Rapor">: <cf_get_lang dictionary_id="38318.Rapor adı altında açılmış izin kaydı oluşturmaktadır"><br/>
18.<cf_get_lang dictionary_id="43082.Yıllık İzin">: <cf_get_lang dictionary_id="38302.Yılık izin adı altında açılmış izin kaydı oluşturmaktadır."><br/>
19.<cf_get_lang dictionary_id="38290.Evlenme İzni">: <cf_get_lang dictionary_id="38301.Evlenme İzni adı altında açılmış izin kaydı oluşturmaktadır."><br/>
20.<cf_get_lang dictionary_id="38289.Ölüm İzni">: <cf_get_lang dictionary_id="38298.Ölüm İzni adı altında açılmış izin kaydı oluşturmaktadır."><br/>
21.<cf_get_lang dictionary_id="38287.Doğum İzni">: <cf_get_lang dictionary_id="38296.Doğum izni adı altında açılmış izin kaydı oluşturmaktadır."><br/>
22.<cf_get_lang dictionary_id="38285.Mazeret İzni">: <cf_get_lang dictionary_id="38294.Mazeret izni adı altında açılmış izin kaydı oluşturmaktadır.">;<br/>
23.<cf_get_lang dictionary_id="53706.Genel Tatil Günü">: <cf_get_lang dictionary_id="38292.Genel Tatil Günü alnına kayıt atmaktadır."><br/>
24.<cf_get_lang dictionary_id="43698.Kontrol">: <cf_get_lang dictionary_id="38291.Bu alana herhangi bir değer girilmedir. (\'0\' olarak doldurulabilir)"><br/>
25.<cf_get_lang dictionary_id='62778.Process ID'>: <cf_get_lang dictionary_id='62779.İzin sürecinin ID si girilmeli'><br/>
26.<cf_get_lang dictionary_id='43422.Category ID'>: <cf_get_lang dictionary_id='62780.İzin Kategori IDsi Girilmelidir. Yoksa 0 olarak girilmeli!'>
</div>
</div>
<div id="t9">
<div style="font-family:Verdana, Geneva, sans-serif;">
<cf_get_lang dictionary_id="44984.Dosya uzantısı csv olmalı ve alan araları noktalı virgül (;) ile ayrılmalıdır. Aktarım işlemi dosyanın 2. satırından itibaren başlar,
bu yüzden birinci satırda alan isimleri olmalıdır."> <cf_get_lang dictionary_id="38453.İmport dosyasına veriler (7,5) formatında girilmelidir."> <cf_get_lang dictionary_id="37683.İmport dosyasının
her satırı bir güne tekabül etmektedir.">
<cf_get_lang dictionary_id="44939.Belgede toplam 26 alan olacaktır. Alanlar sırası ile">:
	<br/><br/>
	1. <cf_get_lang dictionary_id="30757.PDKS No"><cf_get_lang dictionary_id='57998.veya'><cf_get_lang dictionary_id="58487.Çalışan no"> <br/>
		2. <cf_get_lang dictionary_id="57897.Adı">: <cf_get_lang dictionary_id="44688.Çalışan adı"><br/>
		3. <cf_get_lang dictionary_id="58550.Soyadı">: <cf_get_lang dictionary_id="44689.Çalışanın soyadı"><br/>
		4. <cf_get_lang dictionary_id="57742.Tarih">: <cf_get_lang dictionary_id="37639.PDKS import işleminin kayıt atılacağı tarih. \GG.AA.YYYY\ şeklinde girilmelidir."><br/>
		5. <cf_get_lang dictionary_id="37647.PK:Posta kodu (Boş bırakılabilir)"><br/>
		6. <cf_get_lang dictionary_id="31474.Normal Gün">: <cf_get_lang dictionary_id="37636.Hafta içi normal çalışma saati"><br/>
		7. <cf_get_lang dictionary_id="40514.Devamsızlık">: <cf_get_lang dictionary_id="37787.Devamsızlık adı altında açılmış izin kaydı oluşturacak."><br/>
		8. <cf_get_lang dictionary_id="58867.Hafta Tatili">: <cf_get_lang dictionary_id="37935.Hafta Tatili alanına kayıt atacaktır."><br/>
		9. <cf_get_lang dictionary_id="37764.SSK Gün">: <cf_get_lang dictionary_id="37776.SSK Saat Gün (Bu alan pasiftir. Sistem SGK Gününü"><br/>
		10.<cf_get_lang dictionary_id="37931.Hafta içi Mesai">: <cf_get_lang dictionary_id="37835.Hafta içi mesai saati"><br/>
		11.<cf_get_lang dictionary_id="54251.Gece Çalışması">: <cf_get_lang dictionary_id="37834.Gece çalışması saati"><br/>
		12.<cf_get_lang dictionary_id="38348.Genel Tatil Mesaisi">: <cf_get_lang dictionary_id="38345.Genel tatil mesaisi saati"><br/>
		13.<cf_get_lang dictionary_id="38339.Hafta sonu Mesaisi">: <cf_get_lang dictionary_id="38337.Hafta sonu mesaisi saati"><br/>
		14.<cf_get_lang dictionary_id="53686.Ücretli İzin">: <cf_get_lang dictionary_id="38335.Ücretli izin adı altında açılmış izin kaydı oluşturmaktadır"><br/>
		15.<cf_get_lang dictionary_id="43317.Ücretsiz İzin">: <cf_get_lang dictionary_id="38327.Ücretsiz izin adı altında açılmış izin kaydı oluşturmaktadır"><br/>
		16.<cf_get_lang dictionary_id="58576.Vizite">: <cf_get_lang dictionary_id="38319.Vizite adı altında açılmış izin kaydı oluşturmaktadır"><br/>
		17.<cf_get_lang dictionary_id="57434.Rapor">: <cf_get_lang dictionary_id="38318.Rapor adı altında açılmış izin kaydı oluşturmaktadır"><br/>
		18.<cf_get_lang dictionary_id="43082.Yıllık İzin">: <cf_get_lang dictionary_id="38302.Yılık izin adı altında açılmış izin kaydı oluşturmaktadır."><br/>
		19.<cf_get_lang dictionary_id="38290.Evlenme İzni">: <cf_get_lang dictionary_id="38301.Evlenme İzni adı altında açılmış izin kaydı oluşturmaktadır."><br/>
		20.<cf_get_lang dictionary_id="38289.Ölüm İzni">: <cf_get_lang dictionary_id="38298.Ölüm İzni adı altında açılmış izin kaydı oluşturmaktadır."><br/>
		21.<cf_get_lang dictionary_id="38287.Doğum İzni">: <cf_get_lang dictionary_id="38296.Doğum izni adı altında açılmış izin kaydı oluşturmaktadır."><br/>
		22.<cf_get_lang dictionary_id="38285.Mazeret İzni">: <cf_get_lang dictionary_id="38294.Mazeret izni adı altında açılmış izin kaydı oluşturmaktadır.">;<br/>
		23.<cf_get_lang dictionary_id="53706.Genel Tatil Günü">: <cf_get_lang dictionary_id="38292.Genel Tatil Günü alnına kayıt atmaktadır."><br/>
24. GörS :<cf_get_lang dictionary_id="38451.Görevli izin saati"><br/>
25. FMKS<br/>
24.<cf_get_lang dictionary_id="43698.Kontrol">: <cf_get_lang dictionary_id="38291.Bu alana herhangi bir değer girilmedir. (\'0\' olarak doldurulabilir)">
</div>
</div>
<div id="t10">
	<div style="font-family:Verdana, Geneva, sans-serif;">
	*	<cf_get_lang dictionary_id="38421.Dosyanın 4.satırından okumaya başlayacaktır">.<br/>
	*	<cf_get_lang dictionary_id="38413.Her çalışan için 9 satırlık veri bulunmaktadır">.<br/>
	*	<cf_get_lang dictionary_id="38411.Her çalışan için 1.satırın 19-23.karakterleri arasındaki PDKS no bilgisi baz alınarak veri alınacaktır">.<br/>
	*	<cf_get_lang dictionary_id="38409.Çalışanın normal çalışma günü, devamsızlık günü ile toplanıp içeriye alınacaktır."><br/>
	*	<cf_get_lang dictionary_id="38394.Her çalışanın">;<br/><br/>
		<cf_get_lang dictionary_id="38393.2.satırının 12-17.karakterleri arası normal çalışma günü, 33-38. karakterleri arası normal çalışma saati"><br/>
		<cf_get_lang dictionary_id="38392.3.satırının 33-38. karakterleri arası hafta içi fazla mesai saati"><br/>
		<cf_get_lang dictionary_id="38389.4.satırının 33-38. karakterleri arası hafta sonu fazla mesai saati"><br/>
		<cf_get_lang dictionary_id="38386.5.satırının 12-17.karakterleri arası ücretli izin günü, 33-38. karakterleri arası ücretli izin saati"><br/>
		<cf_get_lang dictionary_id="38384.6.satırının 12-17.karakterleri arası hafta tatili günü, 33-38. karakterleri arası hafta tatili saati"><br/>
		<cf_get_lang dictionary_id="38376.7.satırının 12-17.karakterleri arası yıllık izin günü, 33-38. karakterleri arası yıllık izin saati"><br/>
		<cf_get_lang dictionary_id="38363.8.satırının 12-17.karakterleri arası devamsızlık günü, 33-38. karakterleri arası devamsızlık saati"><br/>
		<cf_get_lang dictionary_id="38359.9.satırının 12-17.karakterleri arası ücretsiz izin günü, 33-38. karakterleri arası ücretsiz izin saati"><br/>
		<cf_get_lang dictionary_id="38358.10.satırının 12-17.karakterleri arası ücretsiz izin günü(İstirahat), 33-38. karakterleri arası ücretsiz izin saati">    
	</div>
</div>
	<div id="t11">
		<div style="font-family:Verdana, Geneva, sans-serif;">
			<cf_get_lang dictionary_id="35435.Aktarım işlemi dosyanın 1. satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır."> <cf_get_lang dictionary_id='64156.Belgede toplam 9 alan olacaktır. İşaretli alanlar zorunludur. Alanlar sırası ile şu şekilde olmalıdır'>:
			<br/><br/>
			1- <cf_get_lang dictionary_id="30757.PDKS No"> *<br/>
			2- <cf_get_lang dictionary_id="57490.Gün"> *<br/>
			3- <cf_get_lang dictionary_id="58724.Ay"> *<br/>
			4- <cf_get_lang dictionary_id="58455.Yıl"> *<br/>
			5- <cf_get_lang dictionary_id='57501.Başlangıç'> <cf_get_lang dictionary_id="57491.Saat"> *<br/>
			6- <cf_get_lang dictionary_id='57501.Başlangıç'> <cf_get_lang dictionary_id="58127.Dakika"> *<br/>
			7 - <cf_get_lang dictionary_id='57502.Bitiş'> <cf_get_lang dictionary_id="57491.Saat"> *<br/>
			8 - <cf_get_lang dictionary_id='57502.Bitiş'> <cf_get_lang dictionary_id="58127.Dakika"> * <br/>
			9 - <cf_get_lang dictionary_id='54126.Mesai'> - <cf_get_lang dictionary_id='58575.İzin'> ID *
			(<cf_get_lang dictionary_id='54126.Mesai'> ID: <cf_get_lang dictionary_id='55753.Çalışma Günü'> <cf_get_lang dictionary_id='53539.FM'>: -1, 
			<cf_get_lang dictionary_id='58867.Hafta Tatili'> <cf_get_lang dictionary_id='53539.FM'>: -2, 
			<cf_get_lang dictionary_id='56022.Resmi Tatil'> <cf_get_lang dictionary_id='53539.FM'>: -3, 
			<cf_get_lang dictionary_id='54251.Gece Çalışması'> <cf_get_lang dictionary_id='53539.FM'>: -4, 
			<cf_get_lang dictionary_id='55753.Çalışma Günü'>: -5
			<cf_get_lang dictionary_id='58867.Hafta Tatili'>: -6
			<cf_get_lang dictionary_id='29482.Genel Tatil'>: -7
			<cf_get_lang dictionary_id='58575.İzin'>: <cf_get_lang dictionary_id='54109.İzin Kategorisi'> ID)<br/>
		</div>
	</div>
</div>

<script type="text/javascript">
	function form_chk()
	{	
		if (document.getElementById('uploaded_file').value == '')
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57468.Belge'>");
			return false;
		}
		if (document.getElementById('paper_type').value.length == 0)
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='58578.Belge Türü'>");
			return false;
		}
		return true;		
	}

	function type_gizle()
	{
		if (document.getElementById('paper_type').value == 5)
		{
			puantaj_off.style.display = "";
			is_time_choice.style.display = "";
		}
		else
		{
			puantaj_off.style.display = "none";
			is_time_choice.style.display = "none";
		}
	}

	function formatGoster(type, text)
	{
		document.getElementById('tdFormat').innerHTML = "";
		document.getElementById('tdFormat').innerHTML = "<strong>" + text + ":</strong><br /><br />";

		if (type == "")
			document.getElementById('tdFormat').innerHTML = "";
		else if (type == 1)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t1').innerHTML;
		else if (type == 2)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t2').innerHTML;
		else if (type == 3)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t3').innerHTML;
		else if (type == 4)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t4').innerHTML;
		else if (type == 5)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t5').innerHTML;
		else if (type == 6)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t6').innerHTML;
		else if (type == 7)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t7').innerHTML;
		else if (type == 8)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t8').innerHTML;
		else if (type == 9)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t8').innerHTML;
		else if (type == 10)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t9').innerHTML;
		else if (type == 11)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t10').innerHTML;
		else if (type == 12)
			document.getElementById('tdFormat').innerHTML += document.getElementById('t11').innerHTML;
	}
</script>
