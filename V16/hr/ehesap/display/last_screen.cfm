<cfif getSgkDetail.ACTION_TYPE is 'IN'>
	<cfoutput>
        <form  name="lastform" id="lastform" method="post">
          <input type="hidden" value="" name="okunankeyIlkIsGrs" id="okunankeyIlkIsGrs">
          <input type="hidden" name="S_il" id="S_il">
          <input type="hidden" name="S_ilce" id="S_ilce">
          <input type="hidden" name="S_ulke" id="S_ulke">
          <input type="hidden" name="istisna" id="istisna">
          <input type="hidden" name="sigturS" id="sigturS">
          <input type="hidden" name="ogrenimDurum" id="ogrenimDurum">
          <input type="hidden" name="ozurkod" id="ozurkod">
          <input type="hidden" name="eskihukumlu" id="eskihukumlu">
          <input type="hidden" name="hukumlu" id="hukumlu">
          <input type="hidden" name="terormagduru" id="terormagduru">
          <input type="hidden" name="meslekadi" id="meslekadi" value="#getSgkDetail.BUSINESS_CODE_NAME#">
          <input type="hidden" name="gorevAd" id="gorevAd">
          <input type="hidden" name="csgbiskoluAd" id="csgbiskoluAd">
          <input type="text" name="tx_TekIsGirTarGG" id="tx_TekIsGirTarGG" maxlength="02" style="width:25px" value="">
          <input type="text" name="tx_TekIsGirTarAA" id="tx_TekIsGirTarAA" maxlength="02" style="width:25px" value="">
          <input type="text" name="tx_TekIsGirTarYY" id="tx_TekIsGirTarYY" maxlength="04" style="width:50px" value="">
          <select name="sigtur" id="sigtur">
            <option selected="selected" value=""></option>
            <option value="0">0 - <cf_get_lang dictionary_id="41957.Tüm Sigorta Kolları"> <cf_get_lang dictionary_id="29801.zorunlu"></option>
            <option value="7">7 - <cf_get_lang dictionary_id="54077.Çırak"></option>
            <option value="8">8 - <cf_get_lang dictionary_id="41947.Sosyal Güvenlik Destek Primi"></option>
            <option value="12">12 - <cf_get_lang dictionary_id="41943.U.Söz.Olmayan Yab.Uyrk.Sigortalı"></option>
            <option value="14">14 - <cf_get_lang dictionary_id="41940.Cezaevi Çalışanları"></option>
            <option value="16">16 - <cf_get_lang dictionary_id="41931.İşkur Kursiyerleri"></option>
            <option value="17">17 - <cf_get_lang dictionary_id="41916.İş Kaybı Tazminatı Alanlar"></option>
            <option value="18">18 - <cf_get_lang dictionary_id="41913.Yök ve ÖSYM Kısmi Isdihdam"></option>
            <option value="19">19 - <cf_get_lang dictionary_id="41911.Stajyer"></option>
            <option value="24">24 - <cf_get_lang dictionary_id="41910.İntörn Öğrenci"></option>
            <option value="25">25 - <cf_get_lang dictionary_id="41909.Harp m. Vazife m. 2330 ve 3713 SK göre aylık alan"></option>
            <option value="32">32 - <cf_get_lang dictionary_id="41899.Bursiyer"></option>
          </select>
          <select name="cmb_Ozurkod" id="cmb_Ozurkod">
            <option value="" selected="selected"> </option>
            <option value="H"><cf_get_lang dictionary_id="57496.Hayır"></option>
            <option value="E"><cf_get_lang dictionary_id="57495.Evet"></option>
          </select>
          <select name="cmb_eskiHukumlu" id="cmb_eskiHukumlu">
            <option value="" selected="selected"> </option>
            <option value="H"><cf_get_lang dictionary_id="57496.Hayır"></option>
            <option value="E"><cf_get_lang dictionary_id="57495.Evet"></option>
          </select>
          <select name="cmb_ogrenimDurum" id="cmb_ogrenimDurum">
            <option value="" selected="selected"> </option>
            <option value="1"><cf_get_lang dictionary_id="41896.Okur yazar değil"></option>
            <option value="2"><cf_get_lang dictionary_id="30478.İlkokul"></option>
            <option value="3"><cf_get_lang dictionary_id="41886.Ortaokul yada İ.Ö.O"></option>
            <option value="4"><cf_get_lang dictionary_id="41882.Lise veya dengi o."></option>
            <option value="5"><cf_get_lang dictionary_id="41871.Yüksek o veya fakülte"></option>
            <option value="6"><cf_get_lang dictionary_id="30483.Yüksek lisans"></option>
            <option value="7"><cf_get_lang dictionary_id="31293.Doktora"></option>
            <option value="0"><cf_get_lang dictionary_id="41869.Bilinmeyen"></option>
          </select>
          <select name="mezuniyetYil" id="mezuniyetYil">
            <option value="0" selected="selected">0</option>
            <option value="1998">1998</option>
            <option value="1999">1999</option>
            <option value="2000">2000</option>
            <option value="2001">2001</option>
            <option value="2002">2002</option>
            <option value="2003">2003</option>
            <option value="2004">2004</option>
            <option value="2005">2005</option>
            <option value="2006">2006</option>
            <option value="2007">2007</option>
            <option value="2008">2008</option>
            <option value="2009">2009</option>
            <option value="2010">2010</option>
            <option value="2011">2011</option>
            <option value="2012">2012</option>
            <option value="2013">2013</option>
            <option value="2014">2014</option>
            <option value="2015">2015</option>
            <option value="2016">2016</option>
          </select>
          <input type="text" name="tx_MezuniyetBlm" id="tx_MezuniyetBlm" size="30" maxlength="80" value="">
          <select name="30gundenaz" id="30gundenaz">
            <option value="" selected="selected"> </option>
            <option value="H"><cf_get_lang dictionary_id="57496.Hayır"></option>
            <option value="E"><cf_get_lang dictionary_id="57495.Evet"></option>
          </select>
          <select name="gunsayisi" id="gunsayisi">
            <option value="" selected="selected"> </option>
            <option value=""> </option>
            <option value="1"> 1</option>
            <option value="2"> 2</option>
            <option value="3"> 3</option>
            <option value="4"> 4</option>
            <option value="5"> 5</option>
            <option value="6"> 6</option>
            <option value="7"> 7</option>
            <option value="8"> 8</option>
            <option value="9"> 9</option>
            <option value="10"> 10</option>
            <option value="11"> 11</option>
            <option value="12"> 12</option>
            <option value="13"> 13</option>
            <option value="14"> 14</option>
            <option value="15"> 15</option>
            <option value="16"> 16</option>
            <option value="17"> 17</option>
            <option value="18"> 18</option>
            <option value="19"> 19</option>
            <option value="20"> 20</option>
            <option value="21"> 21</option>
            <option value="22"> 22</option>
            <option value="23"> 23</option>
            <option value="24"> 24</option>
            <option value="25"> 25</option>
            <option value="26"> 26</option>
            <option value="27"> 27</option>
            <option value="28"> 28</option>
            <option value="29"> 29</option>
          </select>
          <select name="csgbiskolukod" id="csgbiskolukod" style="width:100px">
            <option value=""></option>
            <option value="01">01-<cf_get_lang dictionary_id="41863.Tarım ve Ormancılık, Avcılık ve Balıkçılık"></option>
            <option value="02">02-<cf_get_lang dictionary_id="41859.Madencilik"></option>
            <option value="03">03-<cf_get_lang dictionary_id="41855.PETROL, KİMYA VE LASTİK"></option>
            <option value="04">04-<cf_get_lang dictionary_id="41854.GIDA SANAYİİ"></option>
            <option value="05">05-<cf_get_lang dictionary_id="41853.ŞEKER"></option>
            <option value="06">06-<cf_get_lang dictionary_id="41847.DOKUMA"></option>
            <option value="07">07-<cf_get_lang dictionary_id="55722.DERİ"></option>
            <option value="08">08-<cf_get_lang dictionary_id="58901.AĞAÇ"></option>
            <option value="09">09-<cf_get_lang dictionary_id="41981.KAĞIT"></option>
            <option value="10">10-<cf_get_lang dictionary_id="41980.BASIN VE YAYIN"></option>
            <option value="11">11-<cf_get_lang dictionary_id="41976.BANKA VE SİGORTA"></option>
            <option value="12">12-<cf_get_lang dictionary_id="41965.ÇİMENTO,TOPRAK VE CAM"></option>
            <option value="13">13-<cf_get_lang dictionary_id="43864.METAL"></option>
            <option value="14">14-<cf_get_lang dictionary_id="41964.GEMİ"></option>
            <option value="15">15-<cf_get_lang dictionary_id="41961.İNŞAAT"></option>
            <option value="16">16-<cf_get_lang dictionary_id="38027.ENERJİ"></option>
            <option value="17">17-<cf_get_lang dictionary_id="41937.TİCARET,BÜRO,EĞİTİM VE GÜZEL SANATLAR"></option>
            <option value="18">18-<cf_get_lang dictionary_id="41934.KARA TAŞIMACILIĞI"></option>
            <option value="19">19-<cf_get_lang dictionary_id="45068.DEMİR YOLU TAŞIMACIĞI"></option>
            <option value="20">20-<cf_get_lang dictionary_id="45066.DENİZ TAŞIMACILIĞI"></option>
            <option value="21">21-<cf_get_lang dictionary_id="45065.HAVA TAŞIMACILIĞI"></option>
            <option value="22">22-<cf_get_lang dictionary_id="45060.ARDİYE VE ANTREPOCULUK"></option>
            <option value="23">23-<cf_get_lang dictionary_id="45057.HABERLEŞME"></option>
            <option value="24">24-<cf_get_lang dictionary_id="45055.SAĞLIK"></option>
            <option value="25">25-<cf_get_lang dictionary_id="45054.KONAKLAMA VE EĞLENCE YERLERİ"></option>
            <option value="26">26-<cf_get_lang dictionary_id="45053.MİLLİSAVUNMA"></option>
            <option value="27">27-<cf_get_lang dictionary_id="45052.GAZETECİLİK"></option>
            <option value="28">28-<cf_get_lang dictionary_id="45051.GENEL İŞLER"></option>
          </select>
          <input type="text" name="cbMeslek" id="cbMeslek" value="0" />
          <select name="cbgorev" id="cbgorev">
            <option value="0"></option>
            <option value="01"><cf_get_lang dictionary_id="45050.İşveren veya vekili"></option>
            <option value="02"><cf_get_lang dictionary_id="45049.İşçi"></option>
            <option value="03">657 SK (4/b) <cf_get_lang dictionary_id="45009.kapsamında çalışanlar"></option>
            <option value="04">657 SK (4/c) <cf_get_lang dictionary_id="45009.kapsamında çalışanlar"></option>
            <option value="05"><cf_get_lang dictionary_id="45175.Çıraklar ve stajer öğrenciler"></option>
            <option value="06"><cf_get_lang dictionary_id="45159.Diğerleri"></option>
          </select>
          <input type="text" name="tx_Bulvar" id="tx_Bulvar" size="20" maxlength="40" value="">
          <input type="text" name="tx_Cadde" id="tx_Cadde" size="20" maxlength="20" value="">
          <input type="text" name="tx_Sokak" id="tx_Sokak" size="20" maxlength="20" value="">
          <input type="text" name="tx_Mah" id="tx_Mah" size="20" maxlength="20" value="">
          <input type="text" name="tx_Kapi" id="tx_Kapi" size="10" maxlength="10" value="">
          <input type="text" name="tx_Daire" id="tx_Daire" size="10" maxlength="10" value="">
          <select name="adresIlId" id="adresIlId" style="visibility: visible;">
            <option selected="selected" value=""> <cf_get_lang dictionary_id="31644.Lütfen bir il seçiniz">... </option>
            <option value="17">ÇANAKKALE </option>
            <option value="18">ÇANKIRI </option>
            <option value="19">ÇORUM </option>
            <option value="34">İSTANBUL </option>
            <option value="35">İZMİR </option>
            <option value="63">ŞANLIURFA </option>
            <option value="73">ŞIRNAK </option>
            <option value="4">AĞRI </option>
            <option value="1">ADANA </option>
            <option value="2">ADIYAMAN </option>
            <option value="3">AFYON </option>
            <option value="68">AKSARAY </option>
            <option value="5">AMASYA </option>
            <option value="6">ANKARA </option>
            <option value="7">ANTALYA </option>
            <option value="75">ARDAHAN </option>
            <option value="8">ARTVİN </option>
            <option value="9">AYDIN </option>
            <option value="11">BİLECİK </option>
            <option value="12">BİNGÖL </option>
            <option value="13">BİTLİS </option>
            <option value="10">BALIKESİR </option>
            <option value="74">BARTIN </option>
            <option value="72">BATMAN </option>
            <option value="69">BAYBURT </option>
            <option value="14">BOLU </option>
            <option value="15">BURDUR </option>
            <option value="16">BURSA </option>
            <option value="21">DİYARBAKIR </option>
            <option value="81">DÜZCE </option>
            <option value="20">DENİZLİ </option>
            <option value="22">EDİRNE </option>
            <option value="23">ELAZIĞ </option>
            <option value="24">ERZİNCAN </option>
            <option value="25">ERZURUM </option>
            <option value="26">ESKİŞEHİR </option>
            <option value="28">GİRESUN </option>
            <option value="29">GÜMÜŞHANE </option>
            <option value="27">GAZİANTEP </option>
            <option value="30">HAKKARİ </option>
            <option value="31">HATAY </option>
            <option value="76">IĞDIR </option>
            <option value="32">ISPARTA </option>
            <option value="79">KİLİS </option>
            <option value="43">KÜTAHYA </option>
            <option value="46">KAHRAMANMARAŞ </option>
            <option value="78">KARABüK </option>
            <option value="70">KARAMAN </option>
            <option value="36">KARS </option>
            <option value="37">KASTAMONU </option>
            <option value="38">KAYSERİ </option>
            <option value="40">KIRŞEHİR </option>
            <option value="71">KIRIKKALE </option>
            <option value="39">KIRKLARELİ </option>
            <option value="41">KOCAELİ </option>
            <option value="42">KONYA </option>
            <option value="44">MALATYA </option>
            <option value="45">MANİSA </option>
            <option value="47">MARDİN </option>
            <option value="33">MERSİN </option>
            <option value="48">MUĞLA </option>
            <option value="49">MUŞ </option>
            <option value="51">NİĞDE </option>
            <option value="50">NEVŞEHİR </option>
            <option value="52">ORDU </option>
            <option value="80">OSMANIYE </option>
            <option value="53">RİZE </option>
            <option value="56">SİİRT </option>
            <option value="57">SİNOP </option>
            <option value="58">SİVAS </option>
            <option value="54">SAKARYA </option>
            <option value="55">SAMSUN </option>
            <option value="59">TEKİRDAĞ </option>
            <option value="60">TOKAT </option>
            <option value="61">TRABZON </option>
            <option value="62">TUNCELİ </option>
            <option value="64">UŞAK </option>
            <option value="65">VAN </option>
            <option value="77">YALOVA </option>
            <option value="66">YOZGAT </option>
            <option value="67">ZONGULDAK </option>
          </select>
          <input type="text" name="adresIlceId" id="adresIlceId" size="15" maxlength="25" value="" style="visibility: visible;">
          <input type="text" name="tx_Koy" id="tx_Koy" size="20" maxlength="20" value="">
          <input type="text" name="tx_PostaKodu" id="tx_PostaKodu" size="10" maxlength="5" onChange="javascript:checkNumeric(this);" value="">
          <select name="cmb_Ulke" id="cmb_Ulke">
            <option selected="selected" value="TC"><cf_get_lang dictionary_id="45151.TÜRKİYE"></option>
          </select>
          <input type="text" name="tx_Eposta" id="tx_Eposta" size="20" maxlength="50" value="">
          <input type="text" name="tx_Tel1alan" id="tx_Tel1alan" size="5" maxlength="3" onChange="javascript:checkNumeric(this);" value="">
          <input type="text" name="tx_Tel1" id="tx_Tel1" size="10" maxlength="7" onChange="javascript:checkNumeric(this);" value="">
          <input type="text" name="tx_Tel2alan" id="tx_Tel2alan" size="5" maxlength="3" onChange="javascript:checkNumeric(this);" value="">
          <input type="text" name="tx_Tel2" id="tx_Tel2" size="10" maxlength="7" onChange="javascript:checkNumeric(this);" value="">
          <input type="radio" name="istisnano" value="0" id="istisnano" onClick="document.getElementById(&####39;istisnano&####39;).value=this.value" checked="" style="border: none">
          <input type="radio" name="istisnano" id="istisnano" value="4" style="border: none" onClick="document.getElementById(&####39;istisnano&####39;).value=this.value">
          <input type="radio" name="istisnano" value="6" id="istisnano" onClick="document.getElementById(&####39;istisnano&####39;).value=this.value" style="border: none" disabled="">
          <input type="text" name="is6_yaziGirTarGG" disabled="" maxlength="02" style="width:25" value="">
          <input type="text" name="is6_yaziGirTarAA" disabled="" maxlength="02" style="width:25" value="">
          <input type="text" name="is6_yaziGirTarYY" disabled="" maxlength="04" style="width:50" value="">
          <input type="radio" name="istisnano" value="7" disabled="" id="istisnano" onClick="document.getElementById(&####39;istisnano&####39;).value=this.value" style="border: none">
          <input type="radio" name="istisnano" id="istisnano" value="3" onClick="document.getElementById(&####39;istisnano&####39;).value=this.value" disabled="" style="border:none">
          <input type="radio" name="istisnano" id="istisnano" value="9" onClick="document.getElementById(&####39;istisnano&####39;).value=this.value" disabled="" style="border:none">
          <input type="radio" name="istisnano" id="istisnano" value="8" style="border:none" onClick="document.getElementById(&##39;istisnano&##39;).value=this.value">
          <input type="button" value="İLERİ" onClick="javascript:do_belgeHazirla();">
          <input type="hidden" id="jobid" name="jobid">
        </form>
    </cfoutput>
    <script language=javascript>
    
    function ulkeDegisim(objUlke)
    {
    if (objUlke.value=='TC')
    {
    document.getElementById("adresIlId").style.visibility = 'visible';
    document.getElementById("adresIlceId").style.visibility = 'visible';
    //document.getElementById("yabanciSehir").style.visibility='hidden';
    //document.getElementById("yabanciIlce").style.visibility='hidden';
    } else
    {
    document.getElementById("adresIlId").style.visibility = 'hidden';
    document.getElementById("adresIlceId").style.visibility = 'hidden';
    //document.getElementById("yabanciSehir").style.visibility='visible';
    //document.getElementById("yabanciIlce").style.visibility='visible';
    }
    }
    function temel()
    {
    //document.getElementById("yabanciSehir").style.visibility='hidden';
    //document.getElementById("yabanciIlce").style.visibility='hidden';
    
    document.getElementById("adresIlId").style.visibility = 'visible';
    document.getElementById("adresIlceId").style.visibility = 'visible';
    }
    function getIlcelerByIl(ilKodu) {
            var str = window.location.pathname.substring(1);
            str = str.substring(0, str.indexOf('/'));
            return new AJAXRequest("post", "/" + str + "/GetIlceler", "ilId=" + ilKodu, processIlcelerByIl);
    }
    function handleIlChanged(obj) {
    
            var lastform = obj.form;
            lastform.action = '/SigortaliTescil/amp/sigortaliTescilAction';
            lastform.jobid.value="ilceDoldur";
            document.getElementById("ozurkod").value=document.getElementById('cmb_Ozurkod')[document.getElementById('cmb_Ozurkod').selectedIndex].text;	
    document.getElementById("ogrenimDurum").value=document.getElementById('cmb_ogrenimDurum')[document.getElementById('cmb_ogrenimDurum').selectedIndex].text;
     document.getElementById("eskihukumlu").value=document.getElementById('cmb_eskiHukumlu')[document.getElementById('cmb_eskiHukumlu').selectedIndex].text;		
     document.getElementById("sigturS").value=document.getElementById('sigtur')[document.getElementById('sigtur').selectedIndex].text;
            // document.getElementById("terormagduru").value=document.getElementById('cmb_terormagduru')[document.getElementById('cmb_terormagduru').selectedIndex].text;	
            document.getElementById("S_il").value=document.getElementById('adresIlId')[document.getElementById('adresIlId').selectedIndex].text;
            lastform.submit();
            
    //  var session="< %=request.getSession().getServletContext().getAttribute("ilcelerilktscl")%>";
     
    
    //  	clearIlceler();
    // 	document.getElementById("adresIlceId").disabeld = true;
    //	getIlcelerByIl(obj.value);
    
    }
    function clearIlceler() {
        document.getElementById("adresIlceId").options.length = 0;
        document.getElementById("adresIlceId").disabled = true;
    }
    
    function processIlcelerByIl(myAJAX) {
        if (myAJAX.readyState == 4) {
                var result = myAJAX.responseText;
                var frm = document.forms["lastform"];
                insertXMLToSelect(document.getElementById("adresIlceId"), myAJAX.responseXML, 'ilce');
                document.getElementById("adresIlceId").disabled = false;
        }
    }
    function preventAlphabetic() {
            if ((event.keyCode < 48) || (event.keyCode > 57))
                event.returnValue = false;
            else
                event.returnValue = true;
        }
    
    function checkNumeric(theField) {
            if (isNaN(theField.value)) {
                theField.value = "";
                return false;
            } else
                return true; 
        }
    
    
    function do_belgeHazirla()
    {
    document.getElementById("csgbiskoluAd").value=document.getElementById('csgbiskolukod')[document.getElementById('csgbiskolukod').selectedIndex].text;
     document.getElementById("gorevAd").value=document.getElementById('cbgorev')[document.getElementById('cbgorev').selectedIndex].text;
    //document.getElementById("meslekadi").value=document.getElementById('cbMeslek')[document.getElementById('cbMeslek').selectedIndex].text;
    var hata="0";
        var devam=false;
         var bos='0';
         var uyari='Lütfen sigortalinin ';
         var ististadeger="";	  
    
    if (document.getElementById('istisnano').value=='0')
     ististadeger="Istisnai durum BILDIRMIYORUM";
      if (document.getElementById('istisnano').value=='3')
     ististadeger="Kamu isyerlerinde yurt disina atanan görevli personel ";
     
      if (document.getElementById('istisnano').value=='4')
     ististadeger="Yabanci ülkelere sefer yapan ulastirma araçlarina <br> sefer esnasinda alinarak calistirilan kimseler";
      if (document.getElementById('istisnano').value=='6')
     ististadeger="Maliye Bakanligi'nin vizesine bagli olarak kamu isyerlerinde <br> çalisacak sigortalilar.Vize Tarihi:";
      if (document.getElementById('istisnano').value=='7')
     ististadeger="4046 sayili yasa uyarinca özellestirilen isyerlerinden diger kamu kurum <br> ve kuruluslarina naklen atanan sözlesmeli veya kapsam disi personel ";
      if (document.getElementById('istisnano').value=='8')
     ististadeger="Naklen ve hizmet akdi iliskisi sona ermeden ayni isverenin kurumun ayni ya da <br> baska sigorta/il sigorta müdürlügünce tescil edilmis diger isyerinde çalisan sigortali";
      if (document.getElementById('istisnano').value=='9')
    ististadeger="4447 sayili yasa uyarinca issizlik sigortasina tabi olmayan sözlesmeli personel";
    
    
    //////////////
    if (document.getElementById("sigtur").value=='')
      {uyari=uyari+ ' Sigorta Kolu, ';  bos='1'; }
        if (document.getElementById("tx_TekIsGirTarGG").value=='')
        {uyari=uyari+ ' Ise Giris Tarihi gün, ';  bos='1'; }
        
        if (document.getElementById("tx_TekIsGirTarAA").value=='')
        {uyari=uyari+ ' Ise Giris Tarihi ay, ';  bos='1'; }
        
        if (document.getElementById("tx_TekIsGirTarYY").value=='')
        {uyari=uyari+ ' Ise Giris Tarihi yil,';  bos='1'; }
        
        
          if (document.getElementById("adresIlId").value=='')
        {  }
        //////////
          if (document.getElementById("tx_Mah").value=='') //mah
        {  }
          if (!((document.getElementById("tx_Cadde").value!='')||(document.getElementById("tx_Sokak").value!='')))//cadde veya sokak
        {  }
          if (document.getElementById("tx_Kapi").value=='') //diskapi
        {  }
        ////////////////
        
          if (document.getElementById("cmb_Ozurkod").value=='')
        {document.getElementById("cmb_Ozurkod").value='H';}
    
          if (document.getElementById("cmb_eskiHukumlu").value=='')
        { document.getElementById("cmb_eskiHukumlu").value='H';}
         if (document.getElementById("cmb_ogrenimDurum").value=='')
        { document.getElementById("cmb_ogrenimDurum").value='0';}
        
        if (document.getElementById("30gundenaz").value=='')
        {
       uyari=uyari+' 4857 sayili Kanunun 13 ve 14 üncü maddesine göre kismi süreli veya çagri üzerine ya da ev hizmetlerinde 30 günden az çalisiyor mu '; 
     bos='1';
        }
       if ((document.getElementById("30gundenaz").value=='E')&&(document.getElementById("gunsayisi").value==''))
        {
        uyari=uyari+',Çalisilacak Gün sayisi '; bos='1';
        }
         if ((document.getElementById("30gundenaz").value=='H')&&(document.getElementById("gunsayisi").value!=''))
        {
        uyari=uyari+',30 günden az çalisiyor mu '; bos='1';
        }
      
     if (bos=='1')
     {
      uyari=uyari+ "<cf_get_lang dictionary_id='45150.bilgisini giriniz'>!";
     alert(uyari);
     }else{
     try{
            devam=true;
        }
        catch(exc)
        { alert(exc);
        }
    if (devam)
    {
    document.getElementById("sigturS").value=document.getElementById('sigtur')[document.getElementById('sigtur').selectedIndex].text;
    document.getElementById("ozurkod").value=document.getElementById('cmb_Ozurkod')[document.getElementById('cmb_Ozurkod').selectedIndex].text;	
    
    document.getElementById("eskihukumlu").value=document.getElementById('cmb_eskiHukumlu')[document.getElementById('cmb_eskiHukumlu').selectedIndex].text;		
    document.getElementById("ogrenimDurum").value=document.getElementById('cmb_ogrenimDurum')[document.getElementById('cmb_ogrenimDurum').selectedIndex].text;			
     
    document.getElementById("S_il").value=document.getElementById('adresIlId')[document.getElementById('adresIlId').selectedIndex].text;
    
    //document.getElementById("S_ilce").value=document.getElementById('adresIlceId')[document.getElementById('adresIlceId').selectedIndex].text;
    
    document.getElementById("S_ulke").value=document.getElementById('cmb_Ulke')[document.getElementById('cmb_Ulke').selectedIndex].text; 
    
        if (document.getElementById('istisnano').value=='0')
     document.getElementById("istisna").value="Istisnai durum <U><b>BILDIRMIYORUM</b></U>";
      if (document.getElementById('istisnano').value=='3')
     document.getElementById("istisna").value="Kamu isyerlerinde yurt disina atanan görevli personel ";
     
      if (document.getElementById('istisnano').value=='4')
     document.getElementById("istisna").value="Yabanci ülkelere sefer yapan ulastirma araçlarina <br> sefer esnasinda alinarak calistirilan kimseler";
      if (document.getElementById('istisnano').value=='6')
     document.getElementById("istisna").value="Maliye Bakanligi'nin vizesine bagli olarak kamu isyerlerinde <br> çalisacak sigortalilar.Vize Tarihi:";
      if (document.getElementById('istisnano').value=='7')
     document.getElementById("istisna").value="4046 sayili yasa uyarinca özellestirilen isyerlerinden diger kamu kurum <br> ve kuruluslarina naklen atanan sözlesmeli veya kapsam disi personel ";
      if (document.getElementById('istisnano').value=='8')
     document.getElementById("istisna").value="Naklen ve hizmet akdi iliskisi sona ermeden ayni isverenin kurumun ayni ya da <br> baska sigorta/il sigorta müdürlügünce tescil edilmis diger isyerinde çalisan sigortali";
    if (document.getElementById('istisnano').value=='9')
     document.getElementById("istisna").value="4447 sayili yasa uyarinca issizlik sigortasina tabi olmayan sözlesmeli personel";
    
    
            //lastform.jobid.value="onaylamaoncesi";
            document.getElementById("jobid").value="onaylamaoncesi";
            
            document.forms["lastform"].action="https://uyg.sgk.gov.tr/SigortaliTescil/amp/tekrarIseGrsSorgu";
            
            
            document.forms["lastform"].submit();
         //	lastform.submit();
    }
            }
            
        }
    </script> 
<cfelseif getSgkDetail.ACTION_TYPE is 'OUT'>
	<cfoutput>
        <form  name="lastform" id="lastform" method="post">
            <input type="hidden" value="" name="okunankeyIlkIsGrs" id="okunankeyIlkIsGrs">
            <input type="hidden" name="jobid" id="jobid">
            <input type="hidden" name="gorevAd" id="gorevAd">
            <input type="hidden" name="S_il" id="S_il">
            <input type="hidden" name="csgbiskoluAdi" id="csgbiskoluAdi">
            <input type="hidden" name="nufilceadi" id="nufilceadi">
            <input type="hidden" name="nufiladi" id="nufiladi">
            <input type="hidden" name="ozurkod" id="ozurkod">
            <input type="hidden" name="meslekadi" id="meslekadi" value="#getSgkDetail.BUSINESS_CODE_NAME#">
            <input type="hidden" name="eskihukumlu" id="eskihukumlu">
            <input type="hidden" name="cinsiyeti" id="cinsiyeti">
            <input type="hidden" name="sandikAdi" id="sandikAdi">
            <input type="hidden" name="sandikindex" id="sandikindex">
            <input type="hidden" name="adresiladi" id="adresiladi">
            <input type="hidden" name="adresilceadi" id="adresilceadi">
            <input type="hidden" name="meslekad" id="meslekad">
            <input type="text" name="meslekadfiltre" id="meslekadfiltre" value="Meslek Adı Yaz" size="12" style="font-size:xx-small;font-style: italic;color: gray;" onmousedown="javascript:temizle(this);" onmouseout="javascript:meslekadiyaz();">
            <input type="button" name="filtrele" value="Yazılan Meslek Adına göre liste getir" size="30" onclick="meslekGetir();">
            <input type="button" name="filtrele" id="filtrele" value="Tüm Meslek listesini göster" size="20" onclick="tumMeslekGetir();">
            <input type="text" name="cbMeslek" id="cbMeslek" value="0" />
            <input size="10" style="width:60" readonly="readonly" type="text" name="yil1" id="yil1" value="2016">
            <input readonly="readonly" style="width:60" type="text" name="ay1" id="ay1" value="#evaluate('ay#getSgkDetail.START_DATE_AY#')#" size="10">
            <input type="text" name="belgetur1" id="belgetur1" style="width:50" onclick="javascript: belgeturuSec1()" readonly="readonly">
            <input type="text" name="gun1" id="gun1" style="width:50" onkeypress="javascript:return preventAlphabetic(this);">
            <input type="text" name="heu1" id="heu1" style="width:50" onkeypress="javascript:preventAlphabetic(this);">
            <input type="text" name="prim_ikrm1" id="prim_ikrm1" style="width: 50" onkeypress="javascript:preventAlphabetic(this);">
            <input type="text" name="isegirisgun1" id="isegirisgun1" size="5">
            <input type="text" name="isegirisay1" id="isegirisay1" size="5">
            <input type="text" name="istencikgun1" id="istencikgun1" size="5">
            <input type="text" name="istencikay1" id="istencikay1" size="5">
            <input type="text" name="eksikgunsayisi" id="eksikgunsayisi" size="5">
            <input type="text" name="eksikgunnedeni" id="eksikgunnedeni" size="5" onclick="javascript: eksiknedensec()" readonly="readonly">
            <input size="10" style="width:60" readonly="readonly" type="text" name="yil2" id="yil2" value="2016">
            <input readonly="readonly" style="width:60" type="text" name="ay2" id="ay2" value="#evaluate('ay#getSgkDetail.FINISH_DATE_AY#')#" size="10">
            <input type="text" name="belgetur2" id="belgetur2" style="width:50" onclick="javascript:  belgeturuSec2()" readonly="readonly">
            <input type="text" name="gun2" id="gun2" style="width:50" onkeypress="javascript:return preventAlphabetic(this);">
            <input type="text" name="heu2" id="heu2" style="width:50" onkeypress="javascript:preventAlphabetic(this);">
            <input type="text" name="prim_ikrm2" id="prim_ikrm2" onkeypress="javascript:preventAlphabetic(this);" style="width: 50">
            <input type="text" name="isegirisgun2" id="isegirisgun2" size="5">
            <input type="text" name="isegirisay2" id="isegirisay2" size="5">
            <input type="text" name="istencikgun2" id="istencikgun2" size="5" value="" readonly="readonly">
            <input type="text" name="tx_TekIsGirTarAA" id="tx_TekIsGirTarAA" size="5" value="" readonly="readonly">
            <input type="text" name="eksikgunsayisi2" id="eksikgunsayisi2" size="5">
            <input type="text" name="eksikgunnedeni2" id="eksikgunnedeni2" size="5" onclick="javascript: eksiknedensec2()" readonly="readonly">
            <select name="cmb_Yuzde">
                <option value="H">Hayır</option>
                <option value="E">Evet</option>
            </select>
            <input type="text" name="txtnedenKodu" id="txtnedenKodu" size="5" onclick="javascript: nedenSec()" readonly="readonly">
            <select name="csgbiskolukod" id="csgbiskolukod">
                <option value=""></option>
                <option value="01">01-<cf_get_lang dictionary_id="41863.TARIM VE ORMANCILIK, AVCILIK VE BALIKCILIK"></option>
                <option value="02">02-<cf_get_lang dictionary_id="41859.MADENCİLİK"></option>
                <option value="03">03-<cf_get_lang dictionary_id="41855.PETROL, KİMYA VE LASTİK"></option>
                <option value="04">04-<cf_get_lang dictionary_id="41854.GIDA SANAYİİ"></option>
                <option value="05">05-<cf_get_lang dictionary_id="41853.ŞEKER"></option>
                <option value="06">06-<cf_get_lang dictionary_id="41847.DOKUMA"></option>
                <option value="07">07-<cf_get_lang dictionary_id="55722.DERİ"></option>
                <option value="08">08-<cf_get_lang dictionary_id="58901.AĞAÇ"></option>
                <option value="09">09-<cf_get_lang dictionary_id="41981.KAĞIT"></option>
                <option value="10">10-<cf_get_lang dictionary_id="41980.BASIN VE YAYIN"></option>
                <option value="11">11-<cf_get_lang dictionary_id="41976.BANKA VE SİGORTA"></option>
                <option value="12">12-<cf_get_lang dictionary_id="41965.ÇİMENTO,TOPRAK VE CAM"></option>
                <option value="13">13-<cf_get_lang dictionary_id="59345.METAL"></option>
                <option value="14">14-<cf_get_lang dictionary_id="41964.GEMİ"></option>
                <option value="15">15-<cf_get_lang dictionary_id="41961.İNŞAAT"></option>
                <option value="16">16-<cf_get_lang dictionary_id="38027.ENERJİ"></option>
                <option value="17">17-<cf_get_lang dictionary_id="41937.TİCARET,BÜRO,EĞİTİM VE GÜZEL SANATLAR"></option>
                <option value="18">18-<cf_get_lang dictionary_id="41934.KARA TAŞIMACILIĞI"></option>
                <option value="19">19-<cf_get_lang dictionary_id="45068.DEMİR YOLU TAŞIMACIĞI"></option>
                <option value="20">20-<cf_get_lang dictionary_id="41863.DENİZ TAŞIMACILIĞI"></option>
                <option value="21">21-<cf_get_lang dictionary_id="45065.HAVA TAŞIMACILIĞI"></option>
                <option value="22">22-<cf_get_lang dictionary_id="45060.ARDİYE VE ANTREPOCULUK"></option>
                <option value="23">23-<cf_get_lang dictionary_id="45057.HABERLEŞME"></option>
                <option value="24">24-<cf_get_lang dictionary_id="45055.SAĞLIK"></option>
                <option value="25">25-<cf_get_lang dictionary_id="45054.KONAKLAMA VE EĞLENCE YERLERİ"></option>
                <option value="26">26-<cf_get_lang dictionary_id="45053.MİLLİ SAVUNMA"></option>
                <option value="27">27-<cf_get_lang dictionary_id="45052.GAZETECİLİK"></option>
                <option value="28">28-<cf_get_lang dictionary_id="45051.GENEL İŞLER"></option>
            </select>
            <select name="cmb_4447">
                <option value="H"><cf_get_lang dictionary_id="57496.Hayır"></option>
                <option value="E"><cf_get_lang dictionary_id="57495.Evet"></option>
            </select>
            <input type="text" name="tx_csgb_S" id="tx_csgb_S" size="2" value="0" maxlength="1">
            <input type="text" name="tx_csgb_Meslek" id="tx_csgb_Meslek" size="7" value="0" maxlength="4">
            <input type="text" name="tx_csgb_DosyaNo" id="tx_csgb_DosyaNo" size="9" value="0" maxlength="7">
            <input type="text" name="tx_csgb_Il" id="tx_csgb_Il" size="2" value="0" maxlength="2">
            <input type="text" name="tx_Bulvar" id="tx_Bulvar" size="20" maxlength="20">
            <input type="text" name="tx_Cadde" id="tx_Cadde" size="20" maxlength="20">
            <input type="text" name="tx_Sokak" id="tx_Sokak" size="20" maxlength="20">
            <input type="text" name="tx_Mah" id="tx_Mah" size="20" maxlength="20">
            <input type="text" name="tx_Kapi" id="tx_Kapi" size="10" maxlength="10">
            <input type="text" name="tx_Daire" id="tx_Daire" size="10" maxlength="10">
            <select name="adresIlId" id="adresIlId">
                <option value="17">ÇANAKKALE </option>
                <option value="18">ÇANKIRI </option>
                <option value="19">ÇORUM </option>
                <option value="34">İSTANBUL </option>
                <option value="35">İZMİR </option>
                <option value="63">ŞANLIURFA </option>
                <option value="73">ŞIRNAK </option>
                <option value="4">AĞRI </option>
                <option value="1">ADANA </option>
                <option value="2">ADIYAMAN </option>
                <option value="3">AFYON </option>
                <option value="68">AKSARAY </option>
                <option value="5">AMASYA </option>
                <option value="6">ANKARA </option>
                <option value="7">ANTALYA </option>
                <option value="75">ARDAHAN </option>
                <option value="8">ARTVİN </option>
                <option value="9">AYDIN </option>
                <option value="11">BİLECİK </option>
                <option value="12">BİNGÖL </option>
                <option value="13">BİTLİS </option>
                <option value="10">BALIKESİR </option>
                <option value="74">BARTIN </option>
                <option value="72">BATMAN </option>
                <option value="69">BAYBURT </option>
                <option value="14">BOLU </option>
                <option value="15">BURDUR </option>
                <option value="16">BURSA </option>
                <option value="21">DİYARBAKIR </option>
                <option value="81">DÜZCE </option>
                <option value="20">DENİZLİ </option>
                <option value="22">EDİRNE </option>
                <option value="23">ELAZIĞ </option>
                <option value="24">ERZİNCAN </option>
                <option value="25">ERZURUM </option>
                <option value="26">ESKİŞEHİR </option>
                <option value="28">GİRESUN </option>
                <option value="29">GÜMÜŞHANE </option>
                <option value="27">GAZİANTEP </option>
                <option value="30">HAKKARİ </option>
                <option value="31">HATAY </option>
                <option value="76">IĞDIR </option>
                <option value="32">ISPARTA </option>
                <option value="79">KİLİS </option>
                <option value="43">KÜTAHYA </option>
                <option value="46">KAHRAMANMARAŞ </option>
                <option value="78">KARABüK </option>
                <option value="70">KARAMAN </option>
                <option value="36">KARS </option>
                <option value="37">KASTAMONU </option>
                <option value="38">KAYSERİ </option>
                <option value="40">KIRŞEHİR </option>
                <option value="71">KIRIKKALE </option>
                <option value="39">KIRKLARELİ </option>
                <option value="41">KOCAELİ </option>
                <option value="42">KONYA </option>
                <option value="44">MALATYA </option>
                <option value="45">MANİSA </option>
                <option value="47">MARDİN </option>
                <option value="33">MERSİN </option>
                <option value="48">MUĞLA </option>
                <option value="49">MUŞ </option>
                <option value="51">NİĞDE </option>
                <option value="50">NEVŞEHİR </option>
                <option value="52">ORDU </option>
                <option value="80">OSMANIYE </option>
                <option value="53">RİZE </option>
                <option value="56">SİİRT </option>
                <option value="57">SİNOP </option>
                <option value="58">SİVAS </option>
                <option value="54">SAKARYA </option>
                <option value="55">SAMSUN </option>
                <option value="59">TEKİRDAĞ </option>
                <option value="60">TOKAT </option>
                <option value="61">TRABZON </option>
                <option value="62">TUNCELİ </option>
                <option value="64">UŞAK </option>
                <option value="65">VAN </option>
                <option value="77">YALOVA </option>
                <option value="66">YOZGAT </option>
                <option value="67">ZONGULDAK </option>
            </select>
            <input type="text" name="adresIlceId" id="adresIlceId" size="15" maxlength="20">
            <input type="text" name="tx_Koy" id="tx_Koy" size="20" maxlength="25">
            <input type="text" name="tx_PostaKodu" id="tx_PostaKodu" size="10" maxlength="5" onchange="javascript:checkNumeric(this);">
            <input type="text" name="tx_Eposta" id="tx_Eposta" size="20" maxlength="50">
            <input type="text" name="tx_Tel1alan" id="tx_Tel1alan" size="5" maxlength="3" onchange="javascript:checkNumeric(this);" value="">
            <input type="text" name="tx_Tel" id="tx_Tel" size="10" maxlength="7" onchange="javascript:checkNumeric(this);" value="">
            <input type="text" name="tx_Tel2alan" id="tx_Tel2alan" size="5" maxlength="3" onchange="javascript:checkNumeric(this);" value="">
            <input type="text" name="tx_Cep" id="tx_Cep" size="10" maxlength="7" onchange="javascript:checkNumeric(this);" value="">
            <input type="button" name="ileri" id="ileri" value="İLERİ" onclick="javascript:devam();">
        </form>
    </cfoutput>

	<script type="text/javascript">
    function nedenSec(){
        window.open('/hr/ehesap/display/nedenleryeni.html', 'win', 'width=700 height=500 scrollbars=yes');
    }
    function nedenSecKamu(){
        window.open('/SigortaliTescil/jsp/nedenlerkamu.html', 'win', 'width=700 height=500 scrollbars=yes');
    }
    function eksiknedensec(){
        window.open('/SigortaliTescil/jsp/eksikGunNedeni.jsp', 'win', 'width=300 height=300 scrollbars=yes');
    }
    function eksiknedensec2(){
        window.open('/SigortaliTescil/jsp/eksikGunNedeni_2.jsp', 'win', 'width=300 height=300 scrollbars=yes');
    }
    function  belgeturuSec1(){
        window.open('/SigortaliTescil/jsp/belgeturleri.jsp', 'win', 'width=700 height=500 scrollbars=yes');
    }
    function  belgeturuSec2(){
        window.open('/SigortaliTescil/jsp/belgeturleri2.jsp', 'win', 'width=700 height=500 scrollbars=yes');
    }
    
    function preventAlphabetic(theField) {
    if (event.keyCode==44)
    {event.returnValue = true;
    } else{
    if ((event.keyCode < 48) || (event.keyCode > 57))
    {theField.value="Nokta yada harf yazılmaz!";
            //	event.returnValue = false;}
            }
            else
                event.returnValue = true;
        }
    }
    function checkNumeric(theField) {
    
            if (isNaN(theField.value)) {
                theField.value = "";
                return false;
            } else
                return true; 
        }
    
    function temizle(theField) {
                theField.value = "";	 
        }
        function meslekadiyaz()
        {
        if (Trim(document.getElementById("meslekadfiltre").value)=="")
        {
        document.getElementById("meslekadfiltre").value="Meslek Adı Yaz";
        }
        }
        function kontrol()
        {
        if (false)
        {
        document.getElementById("div2").style.visibility='hidden';
        document.getElementById("div5").style.visibility='hidden';
        }else
        {
        document.getElementById("div2").style.visibility='visible';
        document.getElementById("div5").style.visibility='visible';
        }
        
        if (false)
        {
        document.getElementById("div1").style.visibility='hidden';
        document.getElementById("div3").style.visibility='hidden';
        document.getElementById("div4").style.visibility='hidden';
        document.getElementById("div6").style.visibility='hidden';
        document.getElementById("div7").style.visibility='hidden';
        }
        else
        {
        document.getElementById("div1").style.visibility='visible';
        document.getElementById("div3").style.visibility='visible';
        document.getElementById("div4").style.visibility='visible';
        document.getElementById("div6").style.visibility='visible';
        document.getElementById("div7").style.visibility='visible';
        }
        
        }
    function eksiknedentemizle()
    {
     document.getElementById("eksikgunnedeni").value="";
    }
    function eksiknedentemizle2()
    {
     document.getElementById("eksikgunnedeni2").value="";
    }
    function Trim(TheString) 
    { 
    var len; 
    len = TheString.length; 
    while(TheString.substring(0,1) == " "){ //trim left 
    TheString = TheString.substring(1, len); 
    len = TheString.length; 
    } 
    while(TheString.substring(len-1, len) == " "){ //trim right 
    TheString = TheString.substring(0, len-1); 
    len = TheString.length; 
    } 
    return TheString; 
    } 
    
    
    
    function getIlcelerByIl2(ilKodu) {
            var str = window.location.pathname.substring(1);
            str = str.substring(0, str.indexOf('/'));
            return new AJAXRequest("post", "/" + str + "/GetIlceler", "ilId=" + ilKodu, processIlcelerByIl2);
    }
    
    
    
    
    ////////////////////////
    
    function degerleriAl()
    {
    
    //document.getElementById("meslekadi").value=document.getElementById('cbMeslek')[document.getElementById('cbMeslek').selectedIndex].text;
    
    document.getElementById("csgbiskoluAdi").value=document.getElementById('csgbiskolukod')[document.getElementById('csgbiskolukod').selectedIndex].text;
    
    if (Trim(document.getElementById('adresIlId').value)!="")
    document.getElementById("adresiladi").value=document.getElementById('adresIlId')[document.getElementById('adresIlId').selectedIndex].text;
    
    if (Trim(document.getElementById('adresIlceId').value)!="")
    document.getElementById("adresilceadi").value=document.getElementById('adresIlceId').value;
    ///////////
    if (Trim(document.getElementById('tx_csgb_S').value)=="")
    document.getElementById("tx_csgb_S").value="0";
    if (Trim(document.getElementById('tx_csgb_Meslek').value)=="")
    document.getElementById("tx_csgb_Meslek").value="0";
    
    if (Trim(document.getElementById('tx_csgb_DosyaNo').value)=="")
    document.getElementById("tx_csgb_DosyaNo").value="0";
    if (Trim(document.getElementById('tx_csgb_Il').value)=="")
    document.getElementById("tx_csgb_Il").value="0";
    if (Trim(document.getElementById('gun1').value)=="")
    document.getElementById("gun1").value="0";
    if (Trim(document.getElementById('gun2').value)=="")
    document.getElementById("gun2").value="0";
    if (Trim(document.getElementById('heu1').value)=="")
    document.getElementById("heu1").value="0";
    if (Trim(document.getElementById('heu2').value)=="")
    document.getElementById("heu1").value="0";
    if (Trim(document.getElementById('isegirisgun1').value)=="")
    document.getElementById("isegirisgun1").value="0";
    if (Trim(document.getElementById('isegirisay1').value)=="")
    document.getElementById("isegirisay1").value="0";
    if (Trim(document.getElementById('istencikgun1').value)=="")
    document.getElementById("istencikgun1").value="0";
    if (Trim(document.getElementById('istencikay1').value)=="")
    document.getElementById("istencikay1").value="0";
    if (Trim(document.getElementById('eksikgunnedeni').value)=="")
    document.getElementById("eksikgunnedeni").value="0";
    if (Trim(document.getElementById('eksikgunnedeni2').value)=="")
    document.getElementById("eksikgunnedeni2").value="0";
    if (Trim(document.getElementById('isegirisgun2').value)=="")
    document.getElementById("isegirisgun2").value="0";
    if (Trim(document.getElementById('isegirisay2').value)=="")
    document.getElementById("isegirisay2").value="0";
    if (Trim(document.getElementById('istencikgun2').value)=="")
    document.getElementById("istencikgun2").value="0";
    
    }	
    function devam(){  
    
    ////////veriler dolu mu kontrol 
      var uyari='Lütfen sigortalının ';
      var bos='0';
      
    
    if (Trim(document.getElementById('gun1').value)=="")
    document.getElementById("gun1").value="0";
    if (Trim(document.getElementById('gun2').value)=="")
    document.getElementById("gun2").value="0";
    //////////////
    if (Trim(document.getElementById('eksikgunsayisi').value)=="")
    document.getElementById("eksikgunsayisi").value="0";
    if (Trim(document.getElementById('eksikgunsayisi2').value)=="")
    document.getElementById("eksikgunsayisi2").value="0";
    
    if (Trim(document.getElementById('heu1').value)=="")
    document.getElementById("heu1").value="0";
    if (Trim(document.getElementById('heu2').value)=="")
    document.getElementById("heu2").value="0";
    if (Trim(document.getElementById('prim_ikrm1').value)=="")
    document.getElementById("prim_ikrm1").value="0";
    if (Trim(document.getElementById('prim_ikrm2').value)=="")
    document.getElementById("prim_ikrm2").value="0";
       if (document.getElementById("txtnedenKodu").value=='') //
        {uyari=uyari+ ' İşten Ayrılış Nedeni ,';  bos='1'; }
    
          if (document.getElementById("tx_Mah").value=='') //mah
        {  }
          if (!((document.getElementById("tx_Cadde").value!='')||(document.getElementById("tx_Sokak").value!='')))//cadde veya sokak
        {  }
          if (document.getElementById("tx_Kapi").value=='') //dışkapı
        {  }
       if ((!((document.getElementById("gun1").value=='')||(document.getElementById("gun1").value=='0')))&&(document.getElementById("belgetur1").value==''))
           {uyari=uyari+ ' Belge türü, ';  bos='1'; }
    if ((!((document.getElementById("gun2").value=='')||(document.getElementById("gun2").value=='0')))&&(document.getElementById("belgetur2").value==''))
           {uyari=uyari+ ' Belge türü, ';  bos='1'; }
          if ((document.getElementById("gun1").value=='')&&(document.getElementById("isegirisgun2").value=='')) //dışkapı
        {uyari=uyari+ ' Gün sayısı, ';  bos='1'; }
        
    
      /* if ((document.getElementById("gun2").value!="0")&&(((document.getElementById("pek2").value=="0")||(document.getElementById("pek2").value=="0,0")||(document.getElementById("pek2").value=="0.0"))))
     {uyari=uyari+ ' Gün sayısı girilen satıra ait kazanç, ';  bos='1'; }
       if ((document.getElementById("gun1").value!="0")&& (((document.getElementById("pek1").value=="0")||(document.getElementById("pek1").value=="0,0")||(document.getElementById("pek1").value=="0.0"))))
     {uyari=uyari+ ' Gün sayısı girilen satıra ait kazanç, ';  bos='1'; }
     if ((document.getElementById("gun2").value=="0")&&(!((document.getElementById("pek2").value=="0")||(document.getElementById("pek2").value=="0,0")||(document.getElementById("pek2").value=="0.0"))))
     {uyari=uyari+ ' Kazanç girilen satıra ait gün sayısı, ';  bos='1'; }
       if ((document.getElementById("gun1").value=="0")&&(!((document.getElementById("pek1").value=="0")||(document.getElementById("pek1").value=="0,0")||(document.getElementById("pek1").value=="0.0"))))
     {uyari=uyari+ ' Kazanç girilen satıra ait gün sayısı, ';  bos='1'; }*/
      if (document.getElementById("eksikgunnedeni").value=='02')
        {  bos='1'; }
          if (document.getElementById("eksikgunnedeni2").value=='02')
        { bos='1'; }
     if (bos=='1')
     {
      uyari=uyari+' bilgisini giriniz!';
         if (document.getElementById("eksikgunnedeni").value=='02')
        {uyari=uyari+ 'Eksik Gün Nedeni Kodu "2" olamaz,';  }
          if (document.getElementById("eksikgunnedeni2").value=='02')
        {uyari=uyari+ 'Eksik Gün Nedeni Kodu "2" olamaz,';   }
     alert(uyari);
     }else{
    document.getElementById("jobid").value="ayrilisnext";
    degerleriAl();
    document.getElementById("S_il").value=document.getElementById('adresIlId')[document.getElementById('adresIlId').selectedIndex].text;
    document.forms["lastform"].action="https://uyg.sgk.gov.tr/SigortaliTescil/amp/sigortaliTescilAction";
    document.forms["lastform"].submit();
     }
    }
    function meslekGetir()
    {
    document.getElementById("jobid").value="meslekGetir";
     document.forms["lastform"].action="https://uyg.sgk.gov.tr/SigortaliTescil/amp/sigortaliTescilAction";
     document.forms["lastform"].submit();
    }
    function tumMeslekGetir()
    {
    document.getElementById("jobid").value="tumMeslekGetir";
     document.forms["lastform"].action="https://uyg.sgk.gov.tr/SigortaliTescil/amp/sigortaliTescilAction";
     document.forms["lastform"].submit();
    }
    </script>
</cfif>
