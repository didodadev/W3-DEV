<!--- YapıKredi için Joker Vada sorgulaması yapar,varsa uygun vadaları getirip kullanıcıya seçtirecektir,
Tahsilat işlemi gerçekleştirmez!
--->
<cfquery name="getSanalPosType" datasource="#dsn#">
	SELECT * FROM OUR_COMPANY_POS_RELATION WHERE POS_TYPE = 9
</cfquery>
<cfscript>
	//sanal pos sifre ve gerekli bilgileri
	pos_type = getSanalPosType.pos_type;
	pos_user_name = getSanalPosType.user_name;
	pos_user_password = getSanalPosType.password;
	pos_client_id = getSanalPosType.client_id;
	pos_terminal_no = getSanalPosType.terminal_no;
	post_adress = getSanalPosType.bank_host;
	ssl_ip = getSanalPosType.ssl_ip;
	pos_store_key = getSanalPosType.store_key;
		
	my_doc = XmlNew();
	my_doc.xmlRoot = XmlElemNew(my_doc,"posnetRequest");
	my_doc.xmlRoot.XmlChildren[1] = XmlElemNew(my_doc,"mid");//Kullanıcı adı-banka tarafından üye işyerine verilir
	my_doc.xmlRoot.XmlChildren[1].XmlText = pos_client_id;
	my_doc.xmlRoot.XmlChildren[2] = XmlElemNew(my_doc,"tid");//Şifre-banka tarafından üye işyerine verilir
	my_doc.xmlRoot.XmlChildren[2].XmlText = pos_terminal_no;
	my_doc.xmlRoot.XmlChildren[3] = XmlElemNew(my_doc,"koiCampaignQuery");//kart no dan bakarak joker vada ları getirir
	my_doc.xmlRoot.XmlChildren[3].XmlChildren[1] = XmlElemNew(my_doc,"ccno");
	my_doc.xmlRoot.XmlChildren[3].XmlChildren[1].XmlText = attributes.card_no;

	try
	{
		get_approved_info();
		xml_response_node = XmlParse(cfhttp.FileContent);
		approved_joker_info = xml_response_node.posnetResponse.approved.XmlText;
	}
	catch(any e)
	{
		abort("Sistem Yoğunluğu Nedeniyle İşleminiz Gerçekleştirilemedi! Lütfen Tekrar Deneyiniz!");
	}
</cfscript>
<cffunction name="get_approved_info">
	<cfhttp method="post" url="#post_adress#">
		<cfhttpparam name="xmldata" type="formfield" value="#my_doc#">
	</cfhttp>
</cffunction>
