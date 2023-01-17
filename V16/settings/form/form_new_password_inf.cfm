<cftry>
    <cfquery datasource="calisma" name="SIFRE_KAYDET">
         INSERT INTO SIFRELER
         (
            SIFRE
         )
         VALUES
         (
           '#form.text_ad#'
         )
    </cfquery>
    <cfcatch></cfcatch>
</cftry>

<cfquery datasource="workcube_cf" name="sifre">
	SELECT 
	    PASSWORD_ID, 
        PASSWORD_LOWERCASE_LENGTH, 
        PASSWORD_UPPERCASE_LENGTH, 
        PASSWORD_NUMBER_LENGTH, 
        PASSWORD_SPECIAL_LENGTH, 
        PASSWORD_NAME 
    FROM 
    	PASSWORD_CONTROL
</cfquery> 
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td height="35" class="headbold"><cf_get_lang_main no='140.Şifre'></td>
    </tr>
</table>
<table  width="98%" border="0" cellpadding="2" cellspacing="1" class="color-border" align="center">
    <tr class="color-row">
        <td width="200" valign="top">
            <cfquery name="VERILER" datasource="workcube_cf">
                SELECT 
                    PASSWORD_ID, 
                    PASSWORD_LOWERCASE_LENGTH, 
                    PASSWORD_UPPERCASE_LENGTH, 
                    PASSWORD_NUMBER_LENGTH, 
                    PASSWORD_SPECIAL_LENGTH, 
                    PASSWORD_NAME  
                FROM 
                	PASSWORD_CONTROL
            </cfquery>
            <table width="200" cellpadding="0" cellspacing="0" border="0">
                <tr> 
                	<td valign="top" class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1731.Bilgisayar Bilgisi'></td>
                </tr>
                <cfif VERILER.recordcount>
					<cfoutput query="VERILER">
                        <tr>
                            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                            <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_password_inf&ID=#PASSWORD_ID#" class="tableyazi">#PASSWORD_NAME#</a></td>
                        </tr>
                    </cfoutput>
                    <cfelse>
                        <tr>
                            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                            <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
                        </tr>
                </cfif>
            </table>
        </td>
        <td class="color-row" valign="top">
            <table>
                <form onclick="form_kontrol();" action="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_add_password_inf" method="post" name="form1" >
                <input type="hidden" name="insert" id="insert" value="<cfoutput>#VERILER.PASSWORD_ID#</cfoutput>">
                    <tr>
                        <td> Yeni Sifre Ekle :</td>
                        <td> <input type="text" name="text_ad" id="text_ad" value="" > </td>
                        <!---    <input type="button" name="KAYDET" value="KAYDET" onClick="gelen();">--->
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td><cf_workcube_buttons is_upd='0'></td>
                    </tr>
                </form>
            </table>
        </td>
    </tr>
</table>
<script type="text/javascript">
function gelen()
{
var gel=document.getElementById('text_ad').value;

var uzunluk=gel.length;


	var lowercase = "abcdefghijklmnopqrstuvwxyz";	
	var uppercase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var number="0123456789";
	var ozel="/*-+;:_?=)(/&%+^'!>£#$½{[]}\|.";


	//KULLANICININ YENI OLUSTURMAK ISTEDIGI SIFREYI ALIP ICINDEKI KUCUK BUYUK SAYI VE OZEL KARAKTER SAYILARINI BULUP DEGISKENLERE ATACAGIZ
	//BU DEGISKENLERI VERITABANINDAKI KOLUNLAR ILE TEKER TEKER KARSILASTIRACAGIZ.		
	 
	
	var sayac_kucuk=0;
	var sayac_buyuk=0;
	var sayac_rakam=0;
	var sayac_ozel=0;
	
	var containsNumberCase = contains(gel,number);
	var containsLowerCase = contains(gel,lowercase);
	var containsUpperCase = contains(gel,uppercase);
	var ozl = contains(gel,ozel);



	<cfoutput>
	    
		if(uzunluk>15)
		{
		alert("DENEMIS OLDUGUNUZ SIFRE UZUNLUGU SINIRINI ASTINIZ !");
		return false;
		}
		else if(#sifre.PASSWORD_NUMBER_LENGTH#>containsNumberCase)
			{
			alert("Şifrenin içindeki RAKAM sayısı en az #sifre.PASSWORD_NUMBER_LENGTH# adet olmalıdır.");return false;
			}
		else if(#sifre.PASSWORD_LOWERCASE_LENGTH#>containsLowerCase)
			{
			alert("Şifrenin içindeki KÜÇÜK HARF sayısı en az #sifre.PASSWORD_LOWERCASE_LENGTH# adet olmalıdır.");return false;
			}
		else if(#sifre.PASSWORD_UPPERCASE_LENGTH#>containsUpperCase)
			{
		       alert("sifreniz icinde BUYUK HARF sayısı en az #sifre.PASSWORD_UPPERCASE_LENGTH# adet olmalıdır.");return false;
			}
		else if(#sifre.PASSWORD_SPECIAL_LENGTH#>ozl)
			{
		        alert("sifreniz icinde OZEL KARAKTER sayısı en az #sifre.PASSWORD_SPECIAL_LENGTH# adet olmalıdır");return false;
			}
		else 
		{
			document.form1.submit();
		}
			
		
	</cfoutput>
}	
function contains(deger,validChars)						
{						
	var sayac=0;				             
							
	for (i = 0; i < deger.length; i++)
	 {
		var char = deger.charAt(i);
	
		if (validChars.indexOf(char) > -1)    
			sayac++;
	}
	return(sayac);				
}
</script> 
     
