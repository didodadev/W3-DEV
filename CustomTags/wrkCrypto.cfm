<!--- 
Description	: verilen query result içerisinde alanların şifresini çözer yada şifreler. Tek bir değişken içerisinde veriyide şifreler ve çözer
Parameters	:
	queryname		: istem yapılmak istenen query adı yollanır
	isencryption 	:  1 ise şifreleme, 0 ise çözme işlemini yapar
	identitycol		: tabloda şifrelemede kullanılacak key alanını belirtir employee_id vs
	showidentityid	: eğer gönderilen değer ile  identity_col alanındaki değerler eşit ise şifreyi çözerek iletir moduleid yada bu alan kullanılır
	moduleid		: modül idsi verilir eğer verilen modül idye yetki varsa şifre çözülür
	value			: şifrelenecek yada çözülecke değer queryname yada bu alan yollanmalı. tagin kullanıldığı sayfadaki değişken adı
	identityid		: Value şifreleme ve çözme işleminde key içerisinde eklenecek id - tagin kullanıldığı sayfadaki değişken adı

Created		: TolgaS20191020
Syntax		:
Şifreleme
1. Tabloyu identity kolonunuda kullanarak şifrele
<cf_wrkCrypto  queryname="aaa" isencryption="1" identitycol="employee_id">
2. Tabloyu sabit anahtar ile şifrele
<cf_wrkCrypto queryname="aaa" isencryption="1">

Şifre çözme:
1.Tabloyu identity kolonunu kullanarak çöz
<cf_wrkCrypto queryname="aaa" isencryption="0" identitycol="employee_id" showidentityid="1">

2.Tabloyu sabit anahtar ile çöz
<cf_wrkCrypto queryname="aaa" isencryption="0" moduleid="67">

3. Modüle yetkisine göre şifreyi çöz
<cf_wrkCrypto queryname="aaa" isencryption="0" identitycol="employee_id" moduleid="67">
	
4.Sadece belirli idli kaydı çöz
<cf_wrkCrypto queryname="aaa" isencryption="0" identitycol="employee_id" showidentityid="1">

sadece bir değişlen yollayarak onun şifrelenmesi ve çözülmesi içinde value ve identityid alanları kullanılarak işlem yapılabilir
<cf_wrkCrypto value="aa" isencryption="1" identityid="id">
--->
<cfscript>
	if (isdefined("attributes.queryname") and isdefined("attributes.value")){
		throw(type="RequiredAttributesException",message="Attribute validation error for tag wrkCrypto",detail="It must use attribute queryname or value");
	}
if(not isdefined("attributes.moduleid")){attributes.moduleid=67;}
	//şifre çözme işleminde yetki kontrolleri
	if(attributes.isencryption eq 0){
		showalldata = false;
		if(not isDefined("attributes.showidentityid") and not isDefined("attributes.value") ){
			if(len("attributes.moduleid")){
				if(attributes.moduleid eq '67'){//ehesap
					if(session.ep.ehesap eq 1){//yetki kontorlünü nasıl yapacağız
						showalldata = true;
					}
				}
			}
		}
		if(showalldata eq false and not isDefined("attributes.showidentityid") and not isDefined("attributes.value")){
			//modul yetkisi yoksa yada çözülecek id gönderilmemiş ise fonksiyon çıkar
			exit;
		}
	}

		
	key_suffix ="wrk"; //bu key default değeri bir yerden tanımlanmalı ve daha sonra değiştirilememeli

	if(isDefined("attributes.queryname")){
		field_suffix = "_ENC";//dbde açılan şifreli kolon isimlerine eklenen ek
		key = getAESkey(apiKey1:key_suffix);

		realQuery = caller[attributes.queryname];
		colArray = ArrayToList(realQuery.getColumnNames());
		if(attributes.isencryption){
			for (row in realQuery) {
				if(isDefined("attributes.identitycol")){
					key = getAESkey(key1:key_suffix,accountKey:evaluate("realQuery." & "#attributes.identitycol#"));
				}
				cfloop(list=colArray,index="col"){
					if(len(evaluate("realQuery.#col#"))){
						"realQuery.#col##field_suffix#" = encrypt(evaluate("realQuery.#col#"),key,'AES/CBC/PKCS5Padding', 'hex');
					}
				}
			}
			caller[ATTRIBUTES.queryname] = realQuery;
		}else{
			for (row in realQuery) {
				if((isdefined("attributes.showidentityid") and not evaluate("#attributes.showidentityid# eq realQuery." & "#ATTRIBUTES.identitycol#") ) and showalldata eq false){
					continue;
				}
				if(isDefined("attributes.identitycol")){
					key = getAESkey(key1:key_suffix,accountKey:evaluate("realQuery." & "#attributes.identitycol#"));
				}
				cfloop(list=colArray,index="col"){
					if(isDefined("realQuery.#col##field_suffix#") && len(evaluate("realQuery.#col##field_suffix#"))){
						"realQuery.#col#" = decrypt(evaluate("realQuery.#col##field_suffix#"),key,'AES/CBC/PKCS5Padding', 'hex');
					}
				}
			}
			caller[attributes.queryname] = realQuery;
		}
	}else if(isdefined("attributes.value")){
		if(not isDefined("attributes.identityid")){
			attributes.identityid = "";
		}
		caller[attributes.value] = caller.contentEncryptingandDecodingAES(isEncode:attributes.isencryption,content:caller[attributes.value],accountKey:caller[attributes.identityid],apiKey1:key_suffix);
	}
</cfscript>

<cffunction name="getAESkey" access="private" returntype="string" hint="Generates the key for encrypt and decrypt" output="false">
	<cfargument name="key1" type="string" required="true" default="" />
	<cfargument name="accountKey" type="string" required="false" default="" />
	<cfscript>
		try{
			var salted = arguments.accountKey & arguments.key1;
			var hashed = binaryDecode(hash(salted, "sha"), "hex");
			var trunc = arrayNew(1);
			var i = 1;
			for (i = 1; i <= 16; i ++) {
				trunc[i] = hashed[i];
			}
			return generateKey = binaryEncode(javaCast("byte[]", trunc), "Base64");
		}
		catch(any e)
		{
			abort;	                 
		}
	</cfscript>
</cffunction>